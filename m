Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2808C165AE
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 16:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbfEGO3s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 10:29:48 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39552 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726353AbfEGO3r (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 May 2019 10:29:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=yz9BbmTt3ZQni9xHMhfWVeSsUqLrYeFW48dacer7mtw=; b=h/Diw5xxJ/BVBe34P5hGjC2uZ
        hYlyytEQisBEQeRye/p1a5GrmovcV5suKzrlzNX3j6uq6SIR86aZl7F/7bX4OlXkPmcsR5bArzlv8
        Rpri3wRFr3XrXtkQevxxT/7f3WyDqWF2Yef/L00LVmAt/n2HmPpeNPRdRiWaPx0uRarKJ6CZYhGOo
        lNUhdInYOLUWGrmoEV7HzxpYbfI4A0WMkPjOO0jQEG9sSBaG1mvk32WD4GbGuZ485it7I13bZvGv0
        GK+z72NS3w09v7FIz4ISgIzp18U1JtErccZcin3yKILCgdoeI2pL6DP9O0s+NOtAhnQ97jflD2o7w
        rBx/8F+DA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hO15O-0008Pp-BC; Tue, 07 May 2019 14:28:50 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id CCA18201E11CE; Tue,  7 May 2019 16:28:48 +0200 (CEST)
Date:   Tue, 7 May 2019 16:28:48 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        Steven Rostedt <rostedt@goodmis.org>,
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
Subject: Re: [RFC][PATCH 1/2] x86: Allow breakpoints to emulate call functions
Message-ID: <20190507142848.GU2606@hirez.programming.kicks-ass.net>
References: <20190502202146.GZ2623@hirez.programming.kicks-ass.net>
 <20190502185225.0cdfc8bc@gandalf.local.home>
 <20190502193129.664c5b2e@gandalf.local.home>
 <20190502195052.0af473cf@gandalf.local.home>
 <20190503092959.GB2623@hirez.programming.kicks-ass.net>
 <20190503092247.20cc1ff0@gandalf.local.home>
 <2045370D-38D8-406C-9E94-C1D483E232C9@amacapital.net>
 <CAHk-=wjrOLqBG1qe9C3T=fLN0m=78FgNOGOEL22gU=+Pw6Mu9Q@mail.gmail.com>
 <20190506081951.GJ2606@hirez.programming.kicks-ass.net>
 <20190507085753.GO2606@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190507085753.GO2606@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 07, 2019 at 10:57:53AM +0200, Peter Zijlstra wrote:
> So this one boots with all of Steve's self-test code enabled.

The selftests need improvement; I passed the 'ftrace regs test' but that
trampline was buggered.

> Yes, its fairly huge, and it really should be multiple patches. But it
> does make a lot of the 32bit code a lot more like the 64bit code.
> 
> It also fixes a bunch of bugs in the various trampolines (notably the
> EBP frame pointer crud, which was wrong or missing). And all the weird
> 32bit exceptions in the unwinder can go. However, I still cannot get an
> unwind from trace_selftest_test_regs_func() for some reason. Josh?
> 
> ---

 arch/x86/entry/entry_32.S            | 136 ++++++++++++++++++++++++++++-------
 arch/x86/entry/entry_64.S            |  14 +++-
 arch/x86/include/asm/ptrace.h        |   4 --
 arch/x86/include/asm/text-patching.h |  20 ++++++
 arch/x86/kernel/alternative.c        |  81 +++++++++++++++++++--
 arch/x86/kernel/ftrace.c             |  25 +++++--
 arch/x86/kernel/ftrace_32.S          |  85 +++++++++++++---------
 arch/x86/kernel/kprobes/common.h     |  36 +++++++---
 arch/x86/kernel/kprobes/core.c       |  27 +++----
 arch/x86/kernel/kprobes/opt.c        |  20 +++---
 arch/x86/kernel/ptrace.c             |  29 --------
 arch/x86/kernel/unwind_frame.c       |   8 ---
 kernel/trace/trace_selftest.c        |   3 +
 13 files changed, 343 insertions(+), 145 deletions(-)

diff --git a/arch/x86/entry/entry_32.S b/arch/x86/entry/entry_32.S
index 7b23431be5cb..183d0cf5c167 100644
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
@@ -203,8 +214,105 @@
 .Lend_\@:
 .endm
 
+#define CS_FROM_ENTRY_STACK	(1 << 31)
+#define CS_FROM_USER_CR3	(1 << 30)
+#define CS_FROM_KERNEL		(1 << 29)
+
+.macro FIXUP_FRAME
+
+#ifdef CONFIG_VM86
+	testl	$X86_EFLAGS_VM, 3*4(%esp)
+	jnz	.Lfrom_usermode_no_fixup_\@
+#endif
+	testl	$SEGMENT_RPL_MASK, 2*4(%esp)
+	jnz	.Lfrom_usermode_no_fixup_\@
+
+	orl	$CS_FROM_KERNEL, 2*4(%esp)
+
+	/*
+	 * When we're here from kernel mode; the (exception) stack looks like:
+	 *
+	 * 4*4(%esp) - <previous context>
+	 * 3*4(%esp) - flags
+	 * 2*4(%esp) - cs
+	 * 1*4(%esp) - ip
+	 * 0*4(%esp) - orig_eax
+	 *
+	 * Lets build a 5 entry IRET frame after that, such that struct pt_regs
+	 * is complete and in particular regs->sp is correct. This gives us
+	 * the original 4 enties as gap:
+	 *
+	 * 10*4(%esp) - <previous context>
+	 *  9*4(%esp) - gap / flags
+	 *  8*4(%esp) - gap / cs
+	 *  7*4(%esp) - gap / ip
+	 *  6*4(%esp) - gap / orig_eax
+	 *  5*4(%esp) - ss
+	 *  4*4(%esp) - sp
+	 *  3*4(%esp) - flags
+	 *  2*4(%esp) - cs
+	 *  1*4(%esp) - ip
+	 *  0*4(%esp) - orig_eax
+	 */
+
+	pushl	%ss		# ss
+	pushl	%esp		# sp (points at ss)
+	addl	$5*4, (%esp)	# point sp back at the previous context
+	pushl	5*4(%esp)	# flags
+	pushl	5*4(%esp)	# cs
+	pushl	5*4(%esp)	# ip
+	pushl	5*4(%esp)	# orig_eax
+
+.Lfrom_usermode_no_fixup_\@:
+.endm
+
+.macro IRET_FRAME
+
+	/* orig_eax is already POP'ed when we're here */
+
+	testl $CS_FROM_KERNEL, 1*4(%esp)
+	jz .Lfinished_frame_\@
+
+	/*
+	 * Reconstruct the 3 entry IRET frame right after the (modified)
+	 * regs->sp without lowering %esp in between, such that an NMI in the
+	 * middle doesn't scribble our stack.
+	 */
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
+.Lfinished_frame_\@:
+.endm
+
 .macro SAVE_ALL pt_regs_ax=%eax switch_stacks=0
+
 	cld
+	/*
+	 * The high bits of the CS dword (__csh) are used for CS_FROM_*.
+	 * Clear them in case hardware didn't do this for us.
+	 */
+	andl	$(0x0000ffff), 2*4(%esp)
+
+	FIXUP_FRAME
+
 	PUSH_GS
 	pushl	%fs
 	pushl	%es
@@ -375,9 +483,6 @@
  * switch to it before we do any copying.
  */
 
-#define CS_FROM_ENTRY_STACK	(1 << 31)
-#define CS_FROM_USER_CR3	(1 << 30)
-
 .macro SWITCH_TO_KERNEL_STACK
 
 	ALTERNATIVE     "", "jmp .Lend_\@", X86_FEATURE_XENPV
@@ -391,13 +496,6 @@
 	 * that register for the time this macro runs
 	 */
 
-	/*
-	 * The high bits of the CS dword (__csh) are used for
-	 * CS_FROM_ENTRY_STACK and CS_FROM_USER_CR3. Clear them in case
-	 * hardware didn't do this for us.
-	 */
-	andl	$(0x0000ffff), PT_CS(%esp)
-
 	/* Are we on the entry stack? Bail out if not! */
 	movl	PER_CPU_VAR(cpu_entry_area), %ecx
 	addl	$CPU_ENTRY_AREA_entry_stack + SIZEOF_entry_stack, %ecx
@@ -755,7 +853,7 @@ END(ret_from_fork)
 	andl	$SEGMENT_RPL_MASK, %eax
 #endif
 	cmpl	$USER_RPL, %eax
-	jb	resume_kernel			# not returning to v8086 or userspace
+	jb	restore_all_kernel		# not returning to v8086 or userspace
 
 ENTRY(resume_userspace)
 	DISABLE_INTERRUPTS(CLBR_ANY)
@@ -765,18 +863,6 @@ ENTRY(resume_userspace)
 	jmp	restore_all
 END(ret_from_exception)
 
-#ifdef CONFIG_PREEMPT
-ENTRY(resume_kernel)
-	DISABLE_INTERRUPTS(CLBR_ANY)
-	cmpl	$0, PER_CPU_VAR(__preempt_count)
-	jnz	restore_all_kernel
-	testl	$X86_EFLAGS_IF, PT_EFLAGS(%esp)	# interrupts off (exception path) ?
-	jz	restore_all_kernel
-	call	preempt_schedule_irq
-	jmp	restore_all_kernel
-END(resume_kernel)
-#endif
-
 GLOBAL(__begin_SYSENTER_singlestep_region)
 /*
  * All code from here through __end_SYSENTER_singlestep_region is subject
@@ -1019,6 +1105,7 @@ ENTRY(entry_INT80_32)
 	/* Restore user state */
 	RESTORE_REGS pop=4			# skip orig_eax/error_code
 .Lirq_return:
+	IRET_FRAME
 	/*
 	 * ARCH_HAS_MEMBARRIER_SYNC_CORE rely on IRET core serialization
 	 * when returning from IPI handler and when returning from
@@ -1027,6 +1114,7 @@ ENTRY(entry_INT80_32)
 	INTERRUPT_RETURN
 
 restore_all_kernel:
+	RETINT_PREEMPT
 	TRACE_IRQS_IRET
 	PARANOID_EXIT_TO_KERNEL_MODE
 	BUG_IF_WRONG_CR3
diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index 20e45d9b4e15..268cd9affe04 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -878,7 +878,7 @@ apicinterrupt IRQ_WORK_VECTOR			irq_work_interrupt		smp_irq_work_interrupt
  * @paranoid == 2 is special: the stub will never switch stacks.  This is for
  * #DF: if the thread stack is somehow unusable, we'll still get a useful OOPS.
  */
-.macro idtentry sym do_sym has_error_code:req paranoid=0 shift_ist=-1 ist_offset=0
+.macro idtentry sym do_sym has_error_code:req paranoid=0 shift_ist=-1 ist_offset=0 create_gap=0
 ENTRY(\sym)
 	UNWIND_HINT_IRET_REGS offset=\has_error_code*8
 
@@ -898,6 +898,16 @@ ENTRY(\sym)
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
@@ -1129,7 +1139,7 @@ apicinterrupt3 HYPERV_STIMER0_VECTOR \
 #endif /* CONFIG_HYPERV */
 
 idtentry debug			do_debug		has_error_code=0	paranoid=1 shift_ist=IST_INDEX_DB ist_offset=DB_STACK_OFFSET
-idtentry int3			do_int3			has_error_code=0
+idtentry int3			do_int3			has_error_code=0	create_gap=1
 idtentry stack_segment		do_stack_segment	has_error_code=1
 
 #ifdef CONFIG_XEN_PV
diff --git a/arch/x86/include/asm/ptrace.h b/arch/x86/include/asm/ptrace.h
index 8a7fc0cca2d1..5ff42dc8b396 100644
--- a/arch/x86/include/asm/ptrace.h
+++ b/arch/x86/include/asm/ptrace.h
@@ -166,14 +166,10 @@ static inline bool user_64bit_mode(struct pt_regs *regs)
 #define compat_user_stack_pointer()	current_pt_regs()->sp
 #endif
 
-#ifdef CONFIG_X86_32
-extern unsigned long kernel_stack_pointer(struct pt_regs *regs);
-#else
 static inline unsigned long kernel_stack_pointer(struct pt_regs *regs)
 {
 	return regs->sp;
 }
-#endif
 
 #define GET_IP(regs) ((regs)->ip)
 #define GET_FP(regs) ((regs)->bp)
diff --git a/arch/x86/include/asm/text-patching.h b/arch/x86/include/asm/text-patching.h
index c90678fd391a..6aac6abf931e 100644
--- a/arch/x86/include/asm/text-patching.h
+++ b/arch/x86/include/asm/text-patching.h
@@ -42,4 +42,24 @@ extern int after_bootmem;
 extern __ro_after_init struct mm_struct *poking_mm;
 extern __ro_after_init unsigned long poking_addr;
 
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
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 7b9b49dfc05a..8e1fafffb926 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -614,11 +614,83 @@ extern struct paravirt_patch_site __start_parainstructions[],
 	__stop_parainstructions[];
 #endif	/* CONFIG_PARAVIRT */
 
+/*
+ * Self-test for the INT3 based CALL emulation code.
+ *
+ * This exercises int3_emulate_call() to make sure INT3 pt_regs are set up
+ * properly and that there is a stack gap between the INT3 frame and the
+ * previous context. Without this gap doing a virtual PUSH on the interrupted
+ * stack would corrupt the INT3 IRET frame.
+ *
+ * See entry_{32,64}.S for more details.
+ */
+static void __init int3_magic(unsigned int *ptr)
+{
+	*ptr = 1;
+}
+
+extern __initdata unsigned long int3_selftest_ip; /* defined in asm below */
+
+static int __init
+int3_exception_notify(struct notifier_block *self, unsigned long val, void *data)
+{
+	struct die_args *args = data;
+	struct pt_regs *regs = args->regs;
+
+	if (!regs || user_mode(regs))
+		return NOTIFY_DONE;
+
+	if (val != DIE_INT3)
+		return NOTIFY_DONE;
+
+	if (regs->ip - INT3_INSN_SIZE != int3_selftest_ip)
+		return NOTIFY_DONE;
+
+	int3_emulate_call(regs, (unsigned long)&int3_magic);
+	return NOTIFY_STOP;
+}
+
+static void __init int3_selftest(void)
+{
+	static __initdata struct notifier_block int3_exception_nb = {
+		.notifier_call	= int3_exception_notify,
+		.priority	= INT_MAX-1, /* last */
+	};
+	unsigned int val = 0;
+
+	BUG_ON(register_die_notifier(&int3_exception_nb));
+
+	/*
+	 * Basically: int3_magic(&val); but really complicated :-)
+	 *
+	 * Stick the address of the INT3 instruction into int3_selftest_ip,
+	 * then trigger the INT3, padded with NOPs to match a CALL instruction
+	 * length.
+	 */
+	asm volatile ("1: int3; nop; nop; nop; nop\n\t"
+		      ".pushsection .init.data,\"aw\"\n\t"
+		      ".align " __ASM_SEL(4, 8) "\n\t"
+		      ".type int3_selftest_ip, @object\n\t"
+		      ".size int3_selftest_ip, " __ASM_SEL(4, 8) "\n\t"
+		      "int3_selftest_ip:\n\t"
+		      __ASM_SEL(.long, .quad) " 1b\n\t"
+		      ".popsection\n\t"
+		      : : __ASM_SEL_RAW(a, D) (&val) : "memory");
+
+	BUG_ON(val != 1);
+
+	unregister_die_notifier(&int3_exception_nb);
+}
+
 void __init alternative_instructions(void)
 {
-	/* The patching is not fully atomic, so try to avoid local interruptions
-	   that might execute the to be patched code.
-	   Other CPUs are not running. */
+	int3_selftest();
+
+	/*
+	 * The patching is not fully atomic, so try to avoid local
+	 * interruptions that might execute the to be patched code.
+	 * Other CPUs are not running.
+	 */
 	stop_nmi();
 
 	/*
@@ -643,10 +715,11 @@ void __init alternative_instructions(void)
 					    _text, _etext);
 	}
 
-	if (!uniproc_patched || num_possible_cpus() == 1)
+	if (!uniproc_patched || num_possible_cpus() == 1) {
 		free_init_pages("SMP alternatives",
 				(unsigned long)__smp_locks,
 				(unsigned long)__smp_locks_end);
+	}
 #endif
 
 	apply_paravirt(__parainstructions, __parainstructions_end);
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 0caf8122d680..a4eea7bad4a1 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -29,6 +29,7 @@
 #include <asm/kprobes.h>
 #include <asm/ftrace.h>
 #include <asm/nops.h>
+#include <asm/text-patching.h>
 
 #ifdef CONFIG_DYNAMIC_FTRACE
 
@@ -231,6 +232,7 @@ int ftrace_modify_call(struct dyn_ftrace *rec, unsigned long old_addr,
 }
 
 static unsigned long ftrace_update_func;
+static unsigned long ftrace_update_func_call;
 
 static int update_ftrace_func(unsigned long ip, void *new)
 {
@@ -259,6 +261,8 @@ int ftrace_update_ftrace_func(ftrace_func_t func)
 	unsigned char *new;
 	int ret;
 
+	ftrace_update_func_call = (unsigned long)func;
+
 	new = ftrace_call_replace(ip, (unsigned long)func);
 	ret = update_ftrace_func(ip, new);
 
@@ -294,13 +298,21 @@ int ftrace_int3_handler(struct pt_regs *regs)
 	if (WARN_ON_ONCE(!regs))
 		return 0;
 
-	ip = regs->ip - 1;
-	if (!ftrace_location(ip) && !is_ftrace_caller(ip))
-		return 0;
+	ip = regs->ip - INT3_INSN_SIZE;
 
-	regs->ip += MCOUNT_INSN_SIZE - 1;
+	if (ftrace_location(ip)) {
+		int3_emulate_call(regs, (unsigned long)ftrace_regs_caller);
+		return 1;
+	} else if (is_ftrace_caller(ip)) {
+		if (!ftrace_update_func_call) {
+			int3_emulate_jmp(regs, ip + CALL_INSN_SIZE);
+			return 1;
+		}
+		int3_emulate_call(regs, ftrace_update_func_call);
+		return 1;
+	}
 
-	return 1;
+	return 0;
 }
 NOKPROBE_SYMBOL(ftrace_int3_handler);
 
@@ -865,6 +877,8 @@ void arch_ftrace_update_trampoline(struct ftrace_ops *ops)
 
 	func = ftrace_ops_get_func(ops);
 
+	ftrace_update_func_call = (unsigned long)func;
+
 	/* Do a safe modify in case the trampoline is executing */
 	new = ftrace_call_replace(ip, (unsigned long)func);
 	ret = update_ftrace_func(ip, new);
@@ -966,6 +980,7 @@ static int ftrace_mod_jmp(unsigned long ip, void *func)
 {
 	unsigned char *new;
 
+	ftrace_update_func_call = 0UL;
 	new = ftrace_jmp_replace(ip, (unsigned long)func);
 
 	return update_ftrace_func(ip, new);
diff --git a/arch/x86/kernel/ftrace_32.S b/arch/x86/kernel/ftrace_32.S
index 4c8440de3355..6ff9911adbb7 100644
--- a/arch/x86/kernel/ftrace_32.S
+++ b/arch/x86/kernel/ftrace_32.S
@@ -9,6 +9,7 @@
 #include <asm/export.h>
 #include <asm/ftrace.h>
 #include <asm/nospec-branch.h>
+#include <asm/asm-offsets.h>
 
 #ifdef CC_USING_FENTRY
 # define function_hook	__fentry__
@@ -104,26 +105,38 @@ END(ftrace_caller)
 
 ENTRY(ftrace_regs_caller)
 	/*
-	 * i386 does not save SS and ESP when coming from kernel.
-	 * Instead, to get sp, &regs->sp is used (see ptrace.h).
-	 * Unfortunately, that means eflags must be at the same location
-	 * as the current return ip is. We move the return ip into the
-	 * regs->ip location, and move flags into the return ip location.
+	 * We're here from an mcount/fentry CALL, and the stack frame looks like:
+	 *
+	 *  <previous context>
+	 *  RET-IP
+	 *
+	 * The purpose of this function is to call out in an emulated INT3
+	 * environment with a stack frame like:
+	 *
+	 *  <previous context>
+	 *  gap / RET-IP
+	 *  gap
+	 *  gap
+	 *  gap
+	 *  pt_regs
+	 *
+	 * We do _NOT_ restore: ss, flags, cs, gs, fs, es, ds
 	 */
-	pushl	$__KERNEL_CS
-	pushl	4(%esp)				/* Save the return ip */
-	pushl	$0				/* Load 0 into orig_ax */
+	subl	$3*4, %esp	# RET-IP + 3 gaps
+	pushl	%ss		# ss
+	pushl	%esp		# points at ss
+	addl	$5*4, (%esp)	#   make it point at <previous context>
+	pushfl			# flags
+	pushl	$__KERNEL_CS	# cs
+	pushl	7*4(%esp)	# ip <- RET-IP
+	pushl	$0		# orig_eax
+
 	pushl	%gs
 	pushl	%fs
 	pushl	%es
 	pushl	%ds
-	pushl	%eax
-
-	/* Get flags and place them into the return ip slot */
-	pushf
-	popl	%eax
-	movl	%eax, 8*4(%esp)
 
+	pushl	%eax
 	pushl	%ebp
 	pushl	%edi
 	pushl	%esi
@@ -131,28 +144,36 @@ ENTRY(ftrace_regs_caller)
 	pushl	%ecx
 	pushl	%ebx
 
-	movl	12*4(%esp), %eax		/* Load ip (1st parameter) */
-	subl	$MCOUNT_INSN_SIZE, %eax		/* Adjust ip */
+	movl	PT_EIP(%esp), %eax	# 1st argument: IP
+	subl	$MCOUNT_INSN_SIZE, %eax
+
 #ifdef CC_USING_FENTRY
-	movl	15*4(%esp), %edx		/* Load parent ip (2nd parameter) */
+	movl	21*4(%esp), %edx	# 2nd argument: parent ip
 #else
-	movl	0x4(%ebp), %edx			/* Load parent ip (2nd parameter) */
+	movl	1*4(%ebp), %edx		# 2nd argument: parent ip
 #endif
-	movl	function_trace_op, %ecx		/* Save ftrace_pos in 3rd parameter */
-	pushl	%esp				/* Save pt_regs as 4th parameter */
+
+#ifdef CONFIG_FRAME_POINTER
+	movl	%esp, %ebp
+	andl	$0x7fffffff, %ebp
+#endif
+
+	movl	function_trace_op, %ecx	# 3rd argument: ftrace_pos
+	pushl	%esp			# 4th argument: pt_regs
 
 GLOBAL(ftrace_regs_call)
 	call	ftrace_stub
 
-	addl	$4, %esp			/* Skip pt_regs */
+	addl	$4, %esp		# skip 4th argument
 
-	/* restore flags */
-	push	14*4(%esp)
-	popf
+	/* place IP below the new SP */
+	movl	PT_OLDESP(%esp), %eax
+	movl	PT_EIP(%esp), %ecx
+	movl	%ecx, -4(%eax)
 
-	/* Move return ip back to its original location */
-	movl	12*4(%esp), %eax
-	movl	%eax, 14*4(%esp)
+	/* place EAX below that */
+	movl	PT_EAX(%esp), %ecx
+	movl	%ecx, -8(%eax)
 
 	popl	%ebx
 	popl	%ecx
@@ -160,16 +181,12 @@ GLOBAL(ftrace_regs_call)
 	popl	%esi
 	popl	%edi
 	popl	%ebp
-	popl	%eax
-	popl	%ds
-	popl	%es
-	popl	%fs
-	popl	%gs
 
-	/* use lea to not affect flags */
-	lea	3*4(%esp), %esp			/* Skip orig_ax, ip and cs */
+	lea	-8(%eax), %esp
+	popl	%eax
 
 	jmp	.Lftrace_ret
+
 #else /* ! CONFIG_DYNAMIC_FTRACE */
 
 ENTRY(function_hook)
diff --git a/arch/x86/kernel/kprobes/common.h b/arch/x86/kernel/kprobes/common.h
index 2b949f4fd4d8..f54b5d666169 100644
--- a/arch/x86/kernel/kprobes/common.h
+++ b/arch/x86/kernel/kprobes/common.h
@@ -6,14 +6,15 @@
 
 #include <asm/asm.h>
 
+#ifdef CONFIG_X86_64
+
 #ifdef CONFIG_FRAME_POINTER
-# define SAVE_RBP_STRING "	push %" _ASM_BP "\n" \
-			 "	mov  %" _ASM_SP ", %" _ASM_BP "\n"
+#define ENCODE_FRAME_POINTER			\
+	"	leaq 1(%rsp), %rbp\n"
 #else
-# define SAVE_RBP_STRING "	push %" _ASM_BP "\n"
+#define ENCODE_FRAME_POINTER
 #endif
 
-#ifdef CONFIG_X86_64
 #define SAVE_REGS_STRING			\
 	/* Skip cs, ip, orig_ax. */		\
 	"	subq $24, %rsp\n"		\
@@ -27,11 +28,13 @@
 	"	pushq %r10\n"			\
 	"	pushq %r11\n"			\
 	"	pushq %rbx\n"			\
-	SAVE_RBP_STRING				\
+	"	pushq %rbp\n"			\
 	"	pushq %r12\n"			\
 	"	pushq %r13\n"			\
 	"	pushq %r14\n"			\
-	"	pushq %r15\n"
+	"	pushq %r15\n"			\
+	ENCODE_FRAME_POINTER
+
 #define RESTORE_REGS_STRING			\
 	"	popq %r15\n"			\
 	"	popq %r14\n"			\
@@ -51,19 +54,30 @@
 	/* Skip orig_ax, ip, cs */		\
 	"	addq $24, %rsp\n"
 #else
+
+#ifdef CONFIG_FRAME_POINTER
+#define ENCODE_FRAME_POINTER 			\
+	"	movl %esp, %ebp\n"		\
+	"	andl $0x7fffffff, %ebp\n"
+#else
+#define ENCODE_FRAME_POINTER
+#endif
+
 #define SAVE_REGS_STRING			\
 	/* Skip cs, ip, orig_ax and gs. */	\
-	"	subl $16, %esp\n"		\
+	"	subl $4*4, %esp\n"		\
 	"	pushl %fs\n"			\
 	"	pushl %es\n"			\
 	"	pushl %ds\n"			\
 	"	pushl %eax\n"			\
-	SAVE_RBP_STRING				\
+	"	pushl %ebp\n"			\
 	"	pushl %edi\n"			\
 	"	pushl %esi\n"			\
 	"	pushl %edx\n"			\
 	"	pushl %ecx\n"			\
-	"	pushl %ebx\n"
+	"	pushl %ebx\n"			\
+	ENCODE_FRAME_POINTER
+
 #define RESTORE_REGS_STRING			\
 	"	popl %ebx\n"			\
 	"	popl %ecx\n"			\
@@ -72,8 +86,8 @@
 	"	popl %edi\n"			\
 	"	popl %ebp\n"			\
 	"	popl %eax\n"			\
-	/* Skip ds, es, fs, gs, orig_ax, and ip. Note: don't pop cs here*/\
-	"	addl $24, %esp\n"
+	/* Skip ds, es, fs, gs, orig_ax, ip, and cs. */\
+	"	addl $7*4, %esp\n"
 #endif
 
 /* Ensure if the instruction can be boostable */
diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index 9e4fa2484d10..28d8ba3b9add 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -731,29 +731,27 @@ asm(
 	".global kretprobe_trampoline\n"
 	".type kretprobe_trampoline, @function\n"
 	"kretprobe_trampoline:\n"
-#ifdef CONFIG_X86_64
 	/* We don't bother saving the ss register */
+#ifdef CONFIG_X86_64
 	"	pushq %rsp\n"
 	"	pushfq\n"
 	SAVE_REGS_STRING
 	"	movq %rsp, %rdi\n"
 	"	call trampoline_handler\n"
 	/* Replace saved sp with true return address. */
-	"	movq %rax, 152(%rsp)\n"
+	"	movq %rax, 19*8(%rsp)\n"
 	RESTORE_REGS_STRING
 	"	popfq\n"
 #else
-	"	pushf\n"
+	"	pushl %esp\n"
+	"	pushfl\n"
 	SAVE_REGS_STRING
 	"	movl %esp, %eax\n"
 	"	call trampoline_handler\n"
-	/* Move flags to cs */
-	"	movl 56(%esp), %edx\n"
-	"	movl %edx, 52(%esp)\n"
-	/* Replace saved flags with true return address. */
-	"	movl %eax, 56(%esp)\n"
+	/* Replace saved sp with true return address. */
+	"	movl %eax, 15*4(%esp)\n"
 	RESTORE_REGS_STRING
-	"	popf\n"
+	"	popfl\n"
 #endif
 	"	ret\n"
 	".size kretprobe_trampoline, .-kretprobe_trampoline\n"
@@ -794,16 +792,13 @@ __used __visible void *trampoline_handler(struct pt_regs *regs)
 	INIT_HLIST_HEAD(&empty_rp);
 	kretprobe_hash_lock(current, &head, &flags);
 	/* fixup registers */
-#ifdef CONFIG_X86_64
 	regs->cs = __KERNEL_CS;
-	/* On x86-64, we use pt_regs->sp for return address holder. */
-	frame_pointer = &regs->sp;
-#else
-	regs->cs = __KERNEL_CS | get_kernel_rpl();
+#ifdef CONFIG_X86_32
+	regs->cs |= get_kernel_rpl();
 	regs->gs = 0;
-	/* On x86-32, we use pt_regs->flags for return address holder. */
-	frame_pointer = &regs->flags;
 #endif
+	/* We use pt_regs->sp for return address holder. */
+	frame_pointer = &regs->sp;
 	regs->ip = trampoline_address;
 	regs->orig_ax = ~0UL;
 
diff --git a/arch/x86/kernel/kprobes/opt.c b/arch/x86/kernel/kprobes/opt.c
index f14262952015..c1010207d036 100644
--- a/arch/x86/kernel/kprobes/opt.c
+++ b/arch/x86/kernel/kprobes/opt.c
@@ -115,14 +115,15 @@ asm (
 			"optprobe_template_call:\n"
 			ASM_NOP5
 			/* Move flags to rsp */
-			"	movq 144(%rsp), %rdx\n"
-			"	movq %rdx, 152(%rsp)\n"
+			"	movq 18*8(%rsp), %rdx\n"
+			"	movq %rdx, 19*8(%rsp)\n"
 			RESTORE_REGS_STRING
 			/* Skip flags entry */
 			"	addq $8, %rsp\n"
 			"	popfq\n"
 #else /* CONFIG_X86_32 */
-			"	pushf\n"
+			"	pushl %esp\n"
+			"	pushfl\n"
 			SAVE_REGS_STRING
 			"	movl %esp, %edx\n"
 			".global optprobe_template_val\n"
@@ -131,9 +132,13 @@ asm (
 			".global optprobe_template_call\n"
 			"optprobe_template_call:\n"
 			ASM_NOP5
+			/* Move flags into esp */
+			"	movl 14*4(%esp), %edx\n"
+			"	movl %edx, 15*4(%esp)\n"
 			RESTORE_REGS_STRING
-			"	addl $4, %esp\n"	/* skip cs */
-			"	popf\n"
+			/* Skip flags entry */
+			"	addl $4, %esp\n"
+			"	popfl\n"
 #endif
 			".global optprobe_template_end\n"
 			"optprobe_template_end:\n"
@@ -165,10 +170,9 @@ optimized_callback(struct optimized_kprobe *op, struct pt_regs *regs)
 	} else {
 		struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
 		/* Save skipped registers */
-#ifdef CONFIG_X86_64
 		regs->cs = __KERNEL_CS;
-#else
-		regs->cs = __KERNEL_CS | get_kernel_rpl();
+#ifdef CONFIG_X86_32
+		regs->cs |= get_kernel_rpl();
 		regs->gs = 0;
 #endif
 		regs->ip = (unsigned long)op->kp.addr + INT3_SIZE;
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 4b8ee05dd6ad..d13f892d2c47 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -153,35 +153,6 @@ static inline bool invalid_selector(u16 value)
 
 #define FLAG_MASK		FLAG_MASK_32
 
-/*
- * X86_32 CPUs don't save ss and esp if the CPU is already in kernel mode
- * when it traps.  The previous stack will be directly underneath the saved
- * registers, and 'sp/ss' won't even have been saved. Thus the '&regs->sp'.
- *
- * Now, if the stack is empty, '&regs->sp' is out of range. In this
- * case we try to take the previous stack. To always return a non-null
- * stack pointer we fall back to regs as stack if no previous stack
- * exists.
- *
- * This is valid only for kernel mode traps.
- */
-unsigned long kernel_stack_pointer(struct pt_regs *regs)
-{
-	unsigned long context = (unsigned long)regs & ~(THREAD_SIZE - 1);
-	unsigned long sp = (unsigned long)&regs->sp;
-	u32 *prev_esp;
-
-	if (context == (sp & ~(THREAD_SIZE - 1)))
-		return sp;
-
-	prev_esp = (u32 *)(context);
-	if (*prev_esp)
-		return (unsigned long)*prev_esp;
-
-	return (unsigned long)regs;
-}
-EXPORT_SYMBOL_GPL(kernel_stack_pointer);
-
 static unsigned long *pt_regs_access(struct pt_regs *regs, unsigned long regno)
 {
 	BUILD_BUG_ON(offsetof(struct pt_regs, bx) != 0);
diff --git a/arch/x86/kernel/unwind_frame.c b/arch/x86/kernel/unwind_frame.c
index 9b9fd4826e7a..df51040d1689 100644
--- a/arch/x86/kernel/unwind_frame.c
+++ b/arch/x86/kernel/unwind_frame.c
@@ -71,10 +71,6 @@ static void unwind_dump(struct unwind_state *state)
 
 static size_t regs_size(struct pt_regs *regs)
 {
-	/* x86_32 regs from kernel mode are two words shorter: */
-	if (IS_ENABLED(CONFIG_X86_32) && !user_mode(regs))
-		return sizeof(*regs) - 2*sizeof(long);
-
 	return sizeof(*regs);
 }
 
@@ -197,11 +193,7 @@ static struct pt_regs *decode_frame_pointer(unsigned long *bp)
 }
 #endif
 
-#ifdef CONFIG_X86_32
-#define KERNEL_REGS_SIZE (sizeof(struct pt_regs) - 2*sizeof(long))
-#else
 #define KERNEL_REGS_SIZE (sizeof(struct pt_regs))
-#endif
 
 static bool update_stack_state(struct unwind_state *state,
 			       unsigned long *next_bp)
diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index 9d402e7fc949..acfd7a174337 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -548,6 +548,9 @@ static void trace_selftest_test_regs_func(unsigned long ip,
 					  struct ftrace_ops *op,
 					  struct pt_regs *pt_regs)
 {
+
+	WARN(1, "whoomp!\n");
+
 	if (pt_regs)
 		trace_selftest_regs_stat = TRACE_SELFTEST_REGS_FOUND;
 	else
