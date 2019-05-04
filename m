Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFCBF13742
	for <lists+stable@lfdr.de>; Sat,  4 May 2019 06:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725801AbfEDESC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 May 2019 00:18:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:38502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725796AbfEDESC (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 4 May 2019 00:18:02 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F354C206DF;
        Sat,  4 May 2019 04:17:57 +0000 (UTC)
Date:   Sat, 4 May 2019 00:17:56 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        Nicolai Stange <nstange@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
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
Subject: Re: [RFC][PATCH 1/2] x86: Allow breakpoints to emulate call
 functions
Message-ID: <20190504001756.17fad840@oasis.local.home>
In-Reply-To: <CAHk-=wh2vPLvsGBi6JtmEYeqHxB5UpTzHDjY5JsWG=YR0Lypzw@mail.gmail.com>
References: <20190501202830.347656894@goodmis.org>
        <20190501203152.397154664@goodmis.org>
        <20190501232412.1196ef18@oasis.local.home>
        <20190502162133.GX2623@hirez.programming.kicks-ass.net>
        <CAHk-=wijZ-MD4g3zMJ9W2r=h8LUWneiu29OWuxZEoSfAF=0bhQ@mail.gmail.com>
        <20190502181811.GY2623@hirez.programming.kicks-ass.net>
        <CAHk-=wi6A9tgw=kkPh5Ywqt687VvsVEjYXVkAnq0jpt0u0tk6g@mail.gmail.com>
        <20190502202146.GZ2623@hirez.programming.kicks-ass.net>
        <CAHk-=wh8bi5c_GkyjPtDAiaXaZRqtmhWs30usUvs4qK_F+c9tg@mail.gmail.com>
        <20190503152405.2d741af8@gandalf.local.home>
        <CAHk-=wiA-WbrFrDs-kOfJZMXy4zMo9-SZfk=7B-GfmBJ866naw@mail.gmail.com>
        <20190503184919.2b7ef242@gandalf.local.home>
        <CAHk-=wh2vPLvsGBi6JtmEYeqHxB5UpTzHDjY5JsWG=YR0Lypzw@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 3 May 2019 16:07:59 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

>     static struct pt_regs *emulate_call(struct pt_regs *regs, unsigned
> long return, unsigned long target)
>     {
>     #ifdef CONFIG_X86_32
>             /* BIG comment about how we need to move pt_regs to make
> room and to update the return 'sp' */
>             struct pt_regs *new = (void *)regs - 4;
>             unsigned long *sp = (unsigned long *)(new + 1);

I tried this, and it crashed. After a bit of debugging, I found that
the issue is that we can't use sizeof(*regs), because we don't have a
full pt_regs. We are missing the first entry (which is why we have
kernel_stack_pointer() in the first place!)


>             memmove(new, regs, sizeof(*regs));

This would need to be something like:

#define SAVED_REGS_SIZE (sizeof(struct pt_regs) - 4)

		struct pt_regs *new = (void *)regs - 4;
		unsigned long *sp = (unsigned long *)
			((void *)new + SAVED_REGS_SIZE);

		memmove(new, regs, SAVED_REGS_SIZE);

>             regs = new;
>     #else
>             unsigned long *sp = regs->sp;
>             regs->sp -= 4;

should be:

		unsigned long *sp;

		regs->sp -= sizeof(long);
		sp = (unsigned long *)regs->sp;

>     #endif
>             *sp = value;
>             regs->ip = target;
>             return regs;
>     }

I got it sorta working. And it appears that printk() no longer flushes
partial lines, and I couldn't figure out where my self tests broke as
it does:

	pr_info("Testing ....: ");
	ret = do_test();
	if (ret)
		pr_info("PASSED\n");
	else
		pr_info("FAILED\n");

but because it doesn't flush anymore, I don't see what test it is :-p
But that's another issue.

With some "early_printk" in the code, I do see it doing the calls, but
for some reason, the start up test never moves forward.

Below is the patch that I tried. I started with Peter's changes (this
works on x86_64) and tried to work your ideas in for x86_32. This still
gets stuck (but doesn't crash). 

Also note that this method prevents the die notifiers from doing this,
which means I had to disable Peter's selftest because that no longer
will work the way it is written.

-- Steve

diff --git a/arch/x86/entry/entry_32.S b/arch/x86/entry/entry_32.S
index d309f30cf7af..f0fd3e17bedd 100644
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
@@ -377,6 +388,7 @@
 
 #define CS_FROM_ENTRY_STACK	(1 << 31)
 #define CS_FROM_USER_CR3	(1 << 30)
+#define CS_FROM_INT3		(1 << 29)
 
 .macro SWITCH_TO_KERNEL_STACK
 
@@ -753,7 +765,7 @@ ret_from_intr:
 	andl	$SEGMENT_RPL_MASK, %eax
 #endif
 	cmpl	$USER_RPL, %eax
-	jb	resume_kernel			# not returning to v8086 or userspace
+	jb	restore_all_kernel		# not returning to v8086 or userspace
 
 ENTRY(resume_userspace)
 	DISABLE_INTERRUPTS(CLBR_ANY)
@@ -763,19 +775,6 @@ ENTRY(resume_userspace)
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
@@ -1026,6 +1025,7 @@ restore_all:
 	INTERRUPT_RETURN
 
 restore_all_kernel:
+	RETINT_PREEMPT
 	TRACE_IRQS_IRET
 	PARANOID_EXIT_TO_KERNEL_MODE
 	BUG_IF_WRONG_CR3
@@ -1476,6 +1476,27 @@ END(nmi)
 
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
+	pushl	$-1				# mark this as an int
+
+	SAVE_ALL switch_stacks=1
+	ENCODE_FRAME_POINTER
+	TRACE_IRQS_OFF
+	movl	%esp, %eax			# pt_regs pointer
+	subl	$8, %esp
+	call	do_kernel_int3
+	movl	%eax, %esp
+	jmp	ret_from_exception
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
diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
index cf350639e76d..4b335ac5afcc 100644
--- a/arch/x86/include/asm/ftrace.h
+++ b/arch/x86/include/asm/ftrace.h
@@ -37,7 +37,7 @@ struct dyn_arch_ftrace {
 	/* No extra data needed for x86 */
 };
 
-int ftrace_int3_handler(struct pt_regs *regs);
+int ftrace_int3_handler(struct pt_regs **regs);
 
 #define FTRACE_GRAPH_TRAMP_ADDR FTRACE_GRAPH_ADDR
 
diff --git a/arch/x86/include/asm/text-patching.h b/arch/x86/include/asm/text-patching.h
index e85ff65c43c3..8e638231cf52 100644
--- a/arch/x86/include/asm/text-patching.h
+++ b/arch/x86/include/asm/text-patching.h
@@ -39,4 +39,33 @@ extern int poke_int3_handler(struct pt_regs *regs);
 extern void *text_poke_bp(void *addr, const void *opcode, size_t len, void *handler);
 extern int after_bootmem;
 
+static inline void int3_emulate_jmp(struct pt_regs *regs, unsigned long ip)
+{
+	regs->ip = ip;
+}
+
+#define INT3_INSN_SIZE 1
+#define CALL_INSN_SIZE 5
+
+static inline struct pt_regs * int3_emulate_call(struct pt_regs *regs, unsigned long func)
+{
+#ifdef CONFIG_X86_32
+#define SAVED_REGS_SIZE (sizeof(struct pt_regs) - 8)
+	/* BIG comment about how we need to move pt_regs to make
+	   room and to update the return 'sp' */
+	struct pt_regs *new = (void *)regs - sizeof(long);
+	unsigned long *sp = (unsigned long *)
+		((void *)new + SAVED_REGS_SIZE);
+	memmove(new, regs, SAVED_REGS_SIZE);
+	regs = new;
+#else
+	unsigned long *sp;
+	regs->sp -= sizeof(long);
+	sp = (unsigned long *)regs->sp;
+#endif
+	*sp = regs->ip - INT3_INSN_SIZE + CALL_INSN_SIZE;
+	regs->ip = func;
+	return regs;
+}
+
 #endif /* _ASM_X86_TEXT_PATCHING_H */
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 9a79c7808f9c..c0e9002e2708 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -613,11 +613,84 @@ extern struct paravirt_patch_site __start_parainstructions[],
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
+	return;
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
@@ -642,10 +715,11 @@ void __init alternative_instructions(void)
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
index ef49517f6bb2..c5e2ae1efbd8 100644
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
 
@@ -287,20 +291,30 @@ static nokprobe_inline int is_ftrace_caller(unsigned long ip)
  * call to a nop. While the change is taking place, we treat
  * it just like it was a nop.
  */
-int ftrace_int3_handler(struct pt_regs *regs)
+int ftrace_int3_handler(struct pt_regs **pregs)
 {
+	struct pt_regs *regs = *pregs;
 	unsigned long ip;
 
 	if (WARN_ON_ONCE(!regs))
 		return 0;
 
-	ip = regs->ip - 1;
-	if (!ftrace_location(ip) && !is_ftrace_caller(ip))
-		return 0;
+	ip = regs->ip - INT3_INSN_SIZE;
 
-	regs->ip += MCOUNT_INSN_SIZE - 1;
+	if (ftrace_location(ip)) {
+		*pregs = int3_emulate_call(regs, (unsigned long)ftrace_regs_caller);
+//		early_printk("ip=%pS was=%px is=%px\n", (void *)ip, regs, *pregs);
+		return 1;
+	} else if (is_ftrace_caller(ip)) {
+		if (!ftrace_update_func_call) {
+			int3_emulate_jmp(regs, ip + CALL_INSN_SIZE);
+			return 1;
+		}
+		*pregs = int3_emulate_call(regs, ftrace_update_func_call);
+		return 1;
+	}
 
-	return 1;
+	return 0;
 }
 NOKPROBE_SYMBOL(ftrace_int3_handler);
 
@@ -859,6 +873,8 @@ void arch_ftrace_update_trampoline(struct ftrace_ops *ops)
 
 	func = ftrace_ops_get_func(ops);
 
+	ftrace_update_func_call = (unsigned long)func;
+
 	/* Do a safe modify in case the trampoline is executing */
 	new = ftrace_call_replace(ip, (unsigned long)func);
 	ret = update_ftrace_func(ip, new);
@@ -960,6 +976,7 @@ static int ftrace_mod_jmp(unsigned long ip, void *func)
 {
 	unsigned char *new;
 
+	ftrace_update_func_call = 0UL;
 	new = ftrace_jmp_replace(ip, (unsigned long)func);
 
 	return update_ftrace_func(ip, new);
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 4b8ee05dd6ad..03ba69a6e594 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -163,6 +163,9 @@ static inline bool invalid_selector(u16 value)
  * stack pointer we fall back to regs as stack if no previous stack
  * exists.
  *
+ * There is a special case for INT3, there we construct a full pt_regs
+ * environment. We can detect this case by a high bit in regs->cs
+ *
  * This is valid only for kernel mode traps.
  */
 unsigned long kernel_stack_pointer(struct pt_regs *regs)
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index d26f9e9c3d83..17e0c56326c9 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -570,7 +570,7 @@ do_general_protection(struct pt_regs *regs, long error_code)
 }
 NOKPROBE_SYMBOL(do_general_protection);
 
-dotraplinkage void notrace do_int3(struct pt_regs *regs, long error_code)
+dotraplinkage struct pt_regs * notrace do_kernel_int3(struct pt_regs *regs)
 {
 #ifdef CONFIG_DYNAMIC_FTRACE
 	/*
@@ -578,11 +578,11 @@ dotraplinkage void notrace do_int3(struct pt_regs *regs, long error_code)
 	 * See note by declaration of modifying_ftrace_code in ftrace.c
 	 */
 	if (unlikely(atomic_read(&modifying_ftrace_code)) &&
-	    ftrace_int3_handler(regs))
-		return;
+	    ftrace_int3_handler(&regs))
+		return regs;
 #endif
 	if (poke_int3_handler(regs))
-		return;
+		return regs;
 
 	/*
 	 * Use ist_enter despite the fact that we don't use an IST stack.
@@ -594,7 +594,7 @@ dotraplinkage void notrace do_int3(struct pt_regs *regs, long error_code)
 	ist_enter(regs);
 	RCU_LOCKDEP_WARN(!rcu_is_watching(), "entry code didn't wake RCU");
 #ifdef CONFIG_KGDB_LOW_LEVEL_TRAP
-	if (kgdb_ll_trap(DIE_INT3, "int3", regs, error_code, X86_TRAP_BP,
+	if (kgdb_ll_trap(DIE_INT3, "int3", regs, 0, X86_TRAP_BP,
 				SIGTRAP) == NOTIFY_STOP)
 		goto exit;
 #endif /* CONFIG_KGDB_LOW_LEVEL_TRAP */
@@ -604,16 +604,26 @@ dotraplinkage void notrace do_int3(struct pt_regs *regs, long error_code)
 		goto exit;
 #endif
 
-	if (notify_die(DIE_INT3, "int3", regs, error_code, X86_TRAP_BP,
+	if (notify_die(DIE_INT3, "int3", regs, 0, X86_TRAP_BP,
 			SIGTRAP) == NOTIFY_STOP)
 		goto exit;
 
 	cond_local_irq_enable(regs);
-	do_trap(X86_TRAP_BP, SIGTRAP, "int3", regs, error_code, 0, NULL);
+	do_trap(X86_TRAP_BP, SIGTRAP, "int3", regs, 0, 0, NULL);
 	cond_local_irq_disable(regs);
 
 exit:
 	ist_exit(regs);
+	return regs;
+}
+NOKPROBE_SYMBOL(do_kernel_int3);
+
+dotraplinkage void notrace do_int3(struct pt_regs *regs, long error_code)
+{
+	struct pt_regs *ret_regs;
+
+	ret_regs = do_kernel_int3(regs);
+	WARN_ON_ONCE(ret_regs != regs);
 }
 NOKPROBE_SYMBOL(do_int3);
 
