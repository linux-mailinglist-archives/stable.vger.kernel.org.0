Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3A7D1263D
	for <lists+stable@lfdr.de>; Fri,  3 May 2019 03:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbfECBvu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 21:51:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:44070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726053AbfECBvu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 21:51:50 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 103AF206C3;
        Fri,  3 May 2019 01:51:45 +0000 (UTC)
Date:   Thu, 2 May 2019 21:51:44 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        Nicolai Stange <nstange@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Shuah Khan <shuah@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Juergen Gross <jgross@suse.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nayna Jain <nayna@linux.ibm.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Joerg Roedel <jroedel@suse.de>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, stable <stable@vger.kernel.org>
Subject: [RFC][PATCH 1/2 v2] x86: Allow breakpoints to emulate call
 functions
Message-ID: <20190502215144.3853a5be@oasis.local.home>
In-Reply-To: <20190502195052.0af473cf@gandalf.local.home>
References: <20190501202830.347656894@goodmis.org>
        <20190501203152.397154664@goodmis.org>
        <20190501232412.1196ef18@oasis.local.home>
        <20190502162133.GX2623@hirez.programming.kicks-ass.net>
        <CAHk-=wijZ-MD4g3zMJ9W2r=h8LUWneiu29OWuxZEoSfAF=0bhQ@mail.gmail.com>
        <20190502181811.GY2623@hirez.programming.kicks-ass.net>
        <CAHk-=wi6A9tgw=kkPh5Ywqt687VvsVEjYXVkAnq0jpt0u0tk6g@mail.gmail.com>
        <20190502202146.GZ2623@hirez.programming.kicks-ass.net>
        <20190502185225.0cdfc8bc@gandalf.local.home>
        <20190502193129.664c5b2e@gandalf.local.home>
        <20190502195052.0af473cf@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


[ This version of the patch passed all my tests! ]

From: Peter Zijlstra <peterz@infradead.org>

In order to allow breakpoints to emulate call functions, they need to push
the return address onto the stack. But because the breakpoint exception
frame is added to the stack when the breakpoint is hit, there's no room to
add the address onto the stack and return to the address of the emulated
called funtion.

To handle this, copy the exception frame on entry of the breakpoint handler
and have leave a gap that can be used to add a return address to the stack
frame and return from the breakpoint to the emulated called function,
allowing for that called function to return back to the location after the
breakpoint was placed.

The helper functions were also added:

  int3_emulate_push(): to push the address onto the gap in the stack
  int3_emulate_jmp(): changes the location of the regs->ip to return there.
  int3_emulate_call(): push the return address and change regs->ip

Cc: Andy Lutomirski <luto@kernel.org>
Cc: Nicolai Stange <nstange@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Miroslav Benes <mbenes@suse.cz>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Joe Lawrence <joe.lawrence@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Mimi Zohar <zohar@linux.ibm.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Nayna Jain <nayna@linux.ibm.com>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>
Cc: stable@vger.kernel.org
Fixes: b700e7f03df5 ("livepatch: kernel: add support for live patching")
Signed-off-by: *** Need Peter Zijlstra's SoB here! ***
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---

Changes since v1:

 - Updated the 32bit code with Peter's latest changes
 - Added int3 stack check in kernel_stack_pointer()

 arch/x86/entry/entry_32.S            | 117 +++++++++++++++++++++++----
 arch/x86/entry/entry_64.S            |  14 +++-
 arch/x86/include/asm/text-patching.h |  20 +++++
 arch/x86/kernel/ptrace.c             |   6 +-
 4 files changed, 139 insertions(+), 18 deletions(-)

diff --git a/arch/x86/entry/entry_32.S b/arch/x86/entry/entry_32.S
index d309f30cf7af..2885acd691ac 100644
--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -67,9 +67,20 @@
 # define preempt_stop(clobbers)	DISABLE_INTERRUPTS(clobbers); TRACE_IRQS_OFF
 #else
 # define preempt_stop(clobbers)
-# define resume_kernel		restore_all_kernel
 #endif
 
+.macro RETINT_PREEMPT
+#ifdef CONFIG_PREEMPT
+	DISABLE_INTERRUPTS(CLBR_ANY)
+	cmpl	$0, PER_CPU_VAR(__preempt_count)
+	jnz	.Lend_\@
+	testl	$X86_EFLAGS_IF, PT_EFLAGS(%esp)	# interrupts off (exception path) ?
+	jz	.Lend_\@
+	call	preempt_schedule_irq
+.Lend_\@:
+#endif
+.endm
+
 .macro TRACE_IRQS_IRET
 #ifdef CONFIG_TRACE_IRQFLAGS
 	testl	$X86_EFLAGS_IF, PT_EFLAGS(%esp)     # interrupts off?
@@ -753,7 +764,7 @@ ret_from_intr:
 	andl	$SEGMENT_RPL_MASK, %eax
 #endif
 	cmpl	$USER_RPL, %eax
-	jb	resume_kernel			# not returning to v8086 or userspace
+	jb	restore_all_kernel		# not returning to v8086 or userspace
 
 ENTRY(resume_userspace)
 	DISABLE_INTERRUPTS(CLBR_ANY)
@@ -763,19 +774,6 @@ ENTRY(resume_userspace)
 	jmp	restore_all
 END(ret_from_exception)
 
-#ifdef CONFIG_PREEMPT
-ENTRY(resume_kernel)
-	DISABLE_INTERRUPTS(CLBR_ANY)
-.Lneed_resched:
-	cmpl	$0, PER_CPU_VAR(__preempt_count)
-	jnz	restore_all_kernel
-	testl	$X86_EFLAGS_IF, PT_EFLAGS(%esp)	# interrupts off (exception path) ?
-	jz	restore_all_kernel
-	call	preempt_schedule_irq
-	jmp	.Lneed_resched
-END(resume_kernel)
-#endif
-
 GLOBAL(__begin_SYSENTER_singlestep_region)
 /*
  * All code from here through __end_SYSENTER_singlestep_region is subject
@@ -1026,6 +1024,7 @@ restore_all:
 	INTERRUPT_RETURN
 
 restore_all_kernel:
+	RETINT_PREEMPT
 	TRACE_IRQS_IRET
 	PARANOID_EXIT_TO_KERNEL_MODE
 	BUG_IF_WRONG_CR3
@@ -1476,6 +1475,94 @@ END(nmi)
 
 ENTRY(int3)
 	ASM_CLAC
+
+#ifdef CONFIG_VM86
+	testl	$X86_EFLAGS_VM, 8(%esp)
+	jnz	.Lfrom_usermode_no_gap
+#endif
+	testl	$SEGMENT_RPL_MASK, 4(%esp)
+	jnz	.Lfrom_usermode_no_gap
+
+	/*
+	 * Here from kernel mode; so the (exception) stack looks like:
+	 *
+	 * 12(esp) - <previous context>
+	 *  8(esp) - flags
+	 *  4(esp) - cs
+	 *  0(esp) - ip
+	 *
+	 * Lets build a 5 entry IRET frame after that, such that struct pt_regs
+	 * is complete and in particular regs->sp is correct. This gives us
+	 * the original 3 enties as gap:
+	 *
+	 * 32(esp) - <previous context>
+	 * 28(esp) - orig_flags / gap
+	 * 24(esp) - orig_cs	/ gap
+	 * 20(esp) - orig_ip	/ gap
+	 * 16(esp) - ss
+	 * 12(esp) - sp
+	 *  8(esp) - flags
+	 *  4(esp) - cs
+	 *  0(esp) - ip
+	 */
+	pushl	%ss	  # ss
+	pushl	%esp      # sp (points at ss)
+	pushl	4*4(%esp) # flags
+	pushl	4*4(%esp) # cs
+	pushl	4*4(%esp) # ip
+
+	add	$16, 12(%esp) # point sp back at the previous context
+
+	pushl	$-1				# orig_eax; mark as interrupt
+
+	SAVE_ALL
+	ENCODE_FRAME_POINTER
+	TRACE_IRQS_OFF
+	xorl	%edx, %edx			# zero error code
+	movl	%esp, %eax			# pt_regs pointer
+	call	do_int3
+
+	RETINT_PREEMPT
+	TRACE_IRQS_IRET
+	/*
+	 * If we really never INT3 from entry code, it looks like
+	 * we can skip this one.
+	PARANOID_EXIT_TO_KERNEL_MODE
+	 */
+	BUG_IF_WRONG_CR3
+	RESTORE_REGS 4				# consume orig_eax
+
+	/*
+	 * Reconstruct the 3 entry IRET frame right after the (modified)
+	 * regs->sp without lowering %esp in between, such that an NMI in the
+	 * middle doesn't scribble our stack.
+	 */
+
+	pushl	%eax
+	pushl	%ecx
+	movl	5*4(%esp), %eax		# (modified) regs->sp
+
+	movl	4*4(%esp), %ecx		# flags
+	movl	%ecx, -4(%eax)
+
+	movl	3*4(%esp), %ecx		# cs
+	andl	$0x0000ffff, %ecx
+	movl	%ecx, -8(%eax)
+
+	movl	2*4(%esp), %ecx		# ip
+	movl	%ecx, -12(%eax)
+
+	movl	1*4(%esp), %ecx		# eax
+	movl	%ecx, -16(%eax)
+
+	popl	%ecx
+	lea	-16(%eax), %esp
+	popl	%eax
+
+	jmp	.Lirq_return
+
+.Lfrom_usermode_no_gap:
+
 	pushl	$-1				# mark this as an int
 
 	SAVE_ALL switch_stacks=1
diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index 1f0efdb7b629..834ec1397dab 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -879,7 +879,7 @@ apicinterrupt IRQ_WORK_VECTOR			irq_work_interrupt		smp_irq_work_interrupt
  * @paranoid == 2 is special: the stub will never switch stacks.  This is for
  * #DF: if the thread stack is somehow unusable, we'll still get a useful OOPS.
  */
-.macro idtentry sym do_sym has_error_code:req paranoid=0 shift_ist=-1
+.macro idtentry sym do_sym has_error_code:req paranoid=0 shift_ist=-1 create_gap=0
 ENTRY(\sym)
 	UNWIND_HINT_IRET_REGS offset=\has_error_code*8
 
@@ -899,6 +899,16 @@ ENTRY(\sym)
 	jnz	.Lfrom_usermode_switch_stack_\@
 	.endif
 
+	.if \create_gap == 1
+	testb	$3, CS-ORIG_RAX(%rsp)
+	jnz	.Lfrom_usermode_no_gap_\@
+	.rept 6
+	pushq	5*8(%rsp)
+	.endr
+	UNWIND_HINT_IRET_REGS offset=8
+.Lfrom_usermode_no_gap_\@:
+	.endif
+
 	.if \paranoid
 	call	paranoid_entry
 	.else
@@ -1130,7 +1140,7 @@ apicinterrupt3 HYPERV_STIMER0_VECTOR \
 #endif /* CONFIG_HYPERV */
 
 idtentry debug			do_debug		has_error_code=0	paranoid=1 shift_ist=DEBUG_STACK
-idtentry int3			do_int3			has_error_code=0
+idtentry int3			do_int3			has_error_code=0	create_gap=1
 idtentry stack_segment		do_stack_segment	has_error_code=1
 
 #ifdef CONFIG_XEN_PV
diff --git a/arch/x86/include/asm/text-patching.h b/arch/x86/include/asm/text-patching.h
index e85ff65c43c3..ba275b6292db 100644
--- a/arch/x86/include/asm/text-patching.h
+++ b/arch/x86/include/asm/text-patching.h
@@ -39,4 +39,24 @@ extern int poke_int3_handler(struct pt_regs *regs);
 extern void *text_poke_bp(void *addr, const void *opcode, size_t len, void *handler);
 extern int after_bootmem;
 
+static inline void int3_emulate_push(struct pt_regs *regs, unsigned long val)
+{
+	regs->sp -= sizeof(unsigned long);
+	*(unsigned long *)regs->sp = val;
+}
+
+static inline void int3_emulate_jmp(struct pt_regs *regs, unsigned long ip)
+{
+	regs->ip = ip;
+}
+
+#define INT3_INSN_SIZE 1
+#define CALL_INSN_SIZE 5
+
+static inline void int3_emulate_call(struct pt_regs *regs, unsigned long func)
+{
+	int3_emulate_push(regs, regs->ip - INT3_INSN_SIZE + CALL_INSN_SIZE);
+	int3_emulate_jmp(regs, func);
+}
+
 #endif /* _ASM_X86_TEXT_PATCHING_H */
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 4b8ee05dd6ad..600ead178bf4 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -171,8 +171,12 @@ unsigned long kernel_stack_pointer(struct pt_regs *regs)
 	unsigned long sp = (unsigned long)&regs->sp;
 	u32 *prev_esp;
 
-	if (context == (sp & ~(THREAD_SIZE - 1)))
+	if (context == (sp & ~(THREAD_SIZE - 1))) {
+		/* int3 code adds a gap */
+		if (sp == regs->sp - 5*4)
+			return regs->sp;
 		return sp;
+	}
 
 	prev_esp = (u32 *)(context);
 	if (*prev_esp)
-- 
2.20.1

