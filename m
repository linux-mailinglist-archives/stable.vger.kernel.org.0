Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73EA514612
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 10:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbfEFIUd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 04:20:33 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:52338 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726576AbfEFIUd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 May 2019 04:20:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Transfer-Encoding
        :Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=rO18+droSvV4SZ7jW/VFNC7nFBf93zwlq1lZ3sk7NqQ=; b=jmZy1zLei096e4UT6zR3LrzhoK
        eI/xc0Gkw4IfJvB9FvcVbEXaSMov+gvhpheNThg/OQ8Nh7M1gqi0ko05ImynkKyCXKQh3hsxgYR8W
        Xy6BUrdrUOLGz7c02EMtxOU99CVKVuaX/FD1rObYNwYhgLQdbv+OMA7jMhIw5ucFmP91DIwhqJ1nx
        5/jcO/CWT56LPKOZNB664jV7/aqMn4Vb9HDrq5iPoMGEzwT2kdCaDOLC+mr1MtRftDbmBkX6ec0Hw
        3ZO/g47g07rswcbWI70MkSqgCt29heNE2vKRRApUyRLwvdVglQffW7WQYOBykH4FLWzaGo79YvzHg
        4wHNSpoA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hNYqm-00038k-Tp; Mon, 06 May 2019 08:19:53 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 3A38B286AB2CB; Mon,  6 May 2019 10:19:51 +0200 (CEST)
Date:   Mon, 6 May 2019 10:19:51 +0200
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
Message-ID: <20190506081951.GJ2606@hirez.programming.kicks-ass.net>
References: <20190502181811.GY2623@hirez.programming.kicks-ass.net>
 <CAHk-=wi6A9tgw=kkPh5Ywqt687VvsVEjYXVkAnq0jpt0u0tk6g@mail.gmail.com>
 <20190502202146.GZ2623@hirez.programming.kicks-ass.net>
 <20190502185225.0cdfc8bc@gandalf.local.home>
 <20190502193129.664c5b2e@gandalf.local.home>
 <20190502195052.0af473cf@gandalf.local.home>
 <20190503092959.GB2623@hirez.programming.kicks-ass.net>
 <20190503092247.20cc1ff0@gandalf.local.home>
 <2045370D-38D8-406C-9E94-C1D483E232C9@amacapital.net>
 <CAHk-=wjrOLqBG1qe9C3T=fLN0m=78FgNOGOEL22gU=+Pw6Mu9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHk-=wjrOLqBG1qe9C3T=fLN0m=78FgNOGOEL22gU=+Pw6Mu9Q@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 03, 2019 at 11:57:22AM -0700, Linus Torvalds wrote:
> On Fri, May 3, 2019 at 9:21 AM Andy Lutomirski <luto@amacapital.net> wrote:
> >
> > So here’s a somewhat nutty suggestion: how about we tweak the 32-bit
> > entry code to emulate the sane 64-bit frame, not just for int3 but
> > always?
> 
> What would the code actually end up looking like? I don't necessarily
> object, since that kernel_stack_pointer() thing certainly looks
> horrible, but honestly, my suggestion to just pass in the 'struct
> pt_regs' and let the call emulation fix it up would have also worked,
> and avoided that bug (and who knows what else might be hiding).
> 
> I really think that you're now hitting all the special case magic
> low-level crap that I wanted to avoid.

This did actually boot on first try; so there must be something horribly
wrong...

Now, I know you like that other approach; but I figured I should at
least show you what this one looks like. Maybe I've been staring at
entry_32.S too much, but I really don't dislike this.

---
 arch/x86/entry/entry_32.S            | 150 +++++++++++++++++++++++++++++------
 arch/x86/entry/entry_64.S            |  14 +++-
 arch/x86/include/asm/ptrace.h        |   4 -
 arch/x86/include/asm/text-patching.h |  20 +++++
 arch/x86/kernel/alternative.c        |  81 ++++++++++++++++++-
 arch/x86/kernel/ptrace.c             |  29 -------
 6 files changed, 235 insertions(+), 63 deletions(-)

diff --git a/arch/x86/entry/entry_32.S b/arch/x86/entry/entry_32.S
index 7b23431be5cb..d29cf03219c5 100644
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
@@ -203,8 +214,119 @@
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
+	add	$5*4, (%esp)	# point sp back at the previous context
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
+	pushl %eax
+
+	lea 10*4(%esp), %eax	# address of <previous context>
+	cmpl %eax, 4*4(%esp)	# if ->sp is unmodified
+	jnz .Lmodified_sp_do_fixup_\@
+
+	/*
+	 * Fast path; regs->sp wasn't modified, reuse the original IRET frame.
+	 */
+	pop %eax
+	add $6*4, %esp
+	jmp .Lfinished_frame_\@;
+
+.Lmodified_sp_do_fixup_\@:
+
+	/*
+	 * Reconstruct the 3 entry IRET frame right after the (modified)
+	 * regs->sp without lowering %esp in between, such that an NMI in the
+	 * middle doesn't scribble our stack.
+	 */
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
@@ -375,9 +497,6 @@
  * switch to it before we do any copying.
  */
 
-#define CS_FROM_ENTRY_STACK	(1 << 31)
-#define CS_FROM_USER_CR3	(1 << 30)
-
 .macro SWITCH_TO_KERNEL_STACK
 
 	ALTERNATIVE     "", "jmp .Lend_\@", X86_FEATURE_XENPV
@@ -391,13 +510,6 @@
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
@@ -755,7 +867,7 @@ END(ret_from_fork)
 	andl	$SEGMENT_RPL_MASK, %eax
 #endif
 	cmpl	$USER_RPL, %eax
-	jb	resume_kernel			# not returning to v8086 or userspace
+	jb	restore_all_kernel		# not returning to v8086 or userspace
 
 ENTRY(resume_userspace)
 	DISABLE_INTERRUPTS(CLBR_ANY)
@@ -765,18 +877,6 @@ ENTRY(resume_userspace)
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
@@ -1019,6 +1119,7 @@ ENTRY(entry_INT80_32)
 	/* Restore user state */
 	RESTORE_REGS pop=4			# skip orig_eax/error_code
 .Lirq_return:
+	IRET_FRAME
 	/*
 	 * ARCH_HAS_MEMBARRIER_SYNC_CORE rely on IRET core serialization
 	 * when returning from IPI handler and when returning from
@@ -1027,6 +1128,7 @@ ENTRY(entry_INT80_32)
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
index 4db9c0d29bc1..9519bc553d6d 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -613,11 +613,83 @@ extern struct paravirt_patch_site __start_parainstructions[],
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
@@ -642,10 +714,11 @@ void __init alternative_instructions(void)
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

