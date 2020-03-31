/*
 * generated by Xtext 2.20.0
 */
package org.xtext.mdsd.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.AbstractGenerator
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext
import org.xtext.mdsd.mathCompiler.MathExp
import org.xtext.mdsd.mathCompiler.Plus
import org.xtext.mdsd.mathCompiler.Minus
import org.xtext.mdsd.mathCompiler.Mult
import org.xtext.mdsd.mathCompiler.Divi
import org.xtext.mdsd.mathCompiler.Binary
import javax.swing.JOptionPane
import org.xtext.mdsd.mathCompiler.VarReference
import org.xtext.mdsd.mathCompiler.Variable
import org.xtext.mdsd.mathCompiler.FunctionalBind
import org.xtext.mdsd.mathCompiler.Parenthesis
import org.xtext.mdsd.mathCompiler.Constant

/**
 * Generates code from your model files on save.
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#code-generation
 */
class MathCompilerGenerator extends AbstractGenerator {

	override void doGenerate(Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {

		val math = resource.allContents.filter(MathExp).next
		val result = math.compute
		System.out.println("Math expression = " + math.display)
		// For +1 score, replace with hovering, see Bettini Chapter 8
		JOptionPane.showMessageDialog(null, "result = " + result, "Math Language", JOptionPane.INFORMATION_MESSAGE)
	}

	def int compute(MathExp math) {

		math.exp.computeExp
	}

	def dispatch int computeExp(Binary exp) {
		val left = exp.left.computeExp
		switch exp.operator {
			Plus: left + exp.right.computeExp
			Minus: left - exp.right.computeExp
			Mult: left * exp.right.computeExp
			Divi: left / exp.right.computeExp
			default: left
		}
	}

	def dispatch int computeExp(FunctionalBind reference) {
		reference.body.computeExp
	}

	def dispatch int computeExp(VarReference reference) {
		reference.variable.expression.computeExp
	}

	def dispatch int computeExp(Constant constant) {
		constant.value
	}

	def dispatch int computeExp(Parenthesis parenthesis) {
		parenthesis.expression.computeExp
	}

	def CharSequence display(MathExp math) '''�math.exp.displayExp�'''

	def dispatch CharSequence displayExp(Binary binary) {
		'''�binary.left.displayExp� �binary.operator.displayOp� �binary.right.displayExp�'''
	}

	def dispatch CharSequence displayExp(Constant num) { '''�num.value�''' }

	def dispatch CharSequence displayExp(Parenthesis parenthesis) { '''(�parenthesis.expression.displayExp�)''' }

	def dispatch CharSequence displayExp(FunctionalBind functional) {
		'''let �functional.variable.displayExp� in (�functional.body.displayExp�);'''
	}

	def dispatch CharSequence displayExp(VarReference reference) { '''�reference.variable.name�''' }

	def dispatch CharSequence displayExp(Variable variable) { '''�variable.name� = �variable.expression.displayExp�''' }

	def dispatch CharSequence displayOp(Plus op) { '''+''' }

	def dispatch CharSequence displayOp(Minus op) { '''-''' }

	def dispatch CharSequence displayOp(Mult op) { '''*''' }

	def dispatch CharSequence displayOp(Divi op) { '''/''' }
}
