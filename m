Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85E0812001
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 18:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbfEBQWE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 12:22:04 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:50440 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbfEBQWE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 May 2019 12:22:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=NEE7q9fJqWlOL/6gjfFl5T3x0YhAmp0ge6MX8JnB8I8=; b=N8IZE0ESBNt9nS+dNXuwQBlkX
        ppoMJqSg8EAFtnEYG6eiYwTrNK1tHFnp6s5CExm3dxK4qdbnO2bu7Kjle4vfRNdhQwZ3AEV6gIooJ
        k3dh2tiWDSO4SoHzjexazn+RtFSHYcpZUYqCs4NZWkayzfAdfmFhQ1W6K+uyxpHqSouxdNVDd1K4D
        HdnEyGsdXYdvnE+n2/Dc5aZMnXfRCDb+Mf5e1F0djHioZt8V4bn4//bTShhlhSOfZFNCX063wewdJ
        Jsa97a8CfwaiAMrG7HiPLCJ/TADTvtJLCZ+8mFyDxhYPufkkWZn+7FvAbpstGA5NjZY59TpLe6LGr
        OFQXDYPtw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hMESl-0007w5-6E; Thu, 02 May 2019 16:21:35 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 237202066BB89; Thu,  2 May 2019 18:21:33 +0200 (CEST)
Date:   Thu, 2 May 2019 18:21:33 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
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
        <linux-kselftest@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: [RFC][PATCH 1/2] x86: Allow breakpoints to emulate call functions
Message-ID: <20190502162133.GX2623@hirez.programming.kicks-ass.net>
References: <20190501202830.347656894@goodmis.org>
 <20190501203152.397154664@goodmis.org>
 <20190501232412.1196ef18@oasis.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190501232412.1196ef18@oasis.local.home>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 01, 2019 at 11:24:12PM -0400, Steven Rostedt wrote:
> On Wed, 01 May 2019 16:28:31 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > diff --git a/arch/x86/entry/entry_32.S b/arch/x86/entry/entry_32.S
> > index d309f30cf7af..50bbf4035baf 100644
> > --- a/arch/x86/entry/entry_32.S
> > +++ b/arch/x86/entry/entry_32.S
> > @@ -1478,6 +1478,17 @@ ENTRY(int3)
> >  	ASM_CLAC
> >  	pushl	$-1				# mark this as an int
> >  
> > +#ifdef CONFIG_VM86
> > +	testl	$X86_EFLAGS_VM, PT_EFLAGS(%esp)
> > +	jnz	.Lfrom_usermode_no_gap
> > +#endif
> > +	testl	$SEGMENT_RPL_MASK, PT_CS(%esp)
> > +	jnz	.Lfrom_usermode_no_gap
> > +	.rept 6
> > +	pushl	5*4(%esp)
> > +	.endr
> > +.Lfrom_usermode_no_gap:
> > +
> >  	SAVE_ALL switch_stacks=1
> >  	ENCODE_FRAME_POINTER
> >  	TRACE_IRQS_OFF
> 
> This failed to work on 32 bit at all (crashed and burned badly - triple
> fault!). 

Indeed so; find a working version below (albeit with a lot of debug
garbage still in).

It also includes the self-test code that Andy wanted -- it's what I used
to debug this mess.

Much thanks to Joerg Roedel for talking entry_32.S with me.

TL;DR, on x86_32 kernel->kernel IRET frames are only 3 entries and do
not include ESP/SS, so not only wasn't regs->sp setup, if you changed it
it wouldn't be effective and corrupt random stack state.

---
 arch/x86/entry/entry_32.S            |  87 +++++++++++++++++++++++---
 arch/x86/entry/entry_64.S            |  14 ++++-
 arch/x86/include/asm/text-patching.h |  20 ++++++
 arch/x86/kernel/alternative.c        | 116 +++++++++++++++++++++++++++++++++--
 arch/x86/kernel/traps.c              |   1 +
 5 files changed, 225 insertions(+), 13 deletions(-)

diff --git a/arch/x86/entry/entry_32.S b/arch/x86/entry/entry_32.S
index 7b23431be5cb..01c5bdbe5f39 100644
--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -203,7 +203,7 @@
 .Lend_\@:
 .endm
 
-.macro SAVE_ALL pt_regs_ax=%eax switch_stacks=0
+.macro SAVE_ALL pt_regs_ax=%eax switch_stacks=0 clear_cs=1
 	cld
 	PUSH_GS
 	pushl	%fs
@@ -225,7 +225,7 @@
 
 	/* Switch to kernel stack if necessary */
 .if \switch_stacks > 0
-	SWITCH_TO_KERNEL_STACK
+	SWITCH_TO_KERNEL_STACK \clear_cs
 .endif
 
 .endm
@@ -377,8 +377,9 @@
 
 #define CS_FROM_ENTRY_STACK	(1 << 31)
 #define CS_FROM_USER_CR3	(1 << 30)
+#define CS_FROM_INT3		(1 << 29)
 
-.macro SWITCH_TO_KERNEL_STACK
+.macro SWITCH_TO_KERNEL_STACK clear_cs=1
 
 	ALTERNATIVE     "", "jmp .Lend_\@", X86_FEATURE_XENPV
 
@@ -391,12 +392,13 @@
 	 * that register for the time this macro runs
 	 */
 
+	.if \clear_cs
 	/*
-	 * The high bits of the CS dword (__csh) are used for
-	 * CS_FROM_ENTRY_STACK and CS_FROM_USER_CR3. Clear them in case
-	 * hardware didn't do this for us.
+	 * The high bits of the CS dword (__csh) are used for CS_FROM_*. Clear
+	 * them in case hardware didn't do this for us.
 	 */
 	andl	$(0x0000ffff), PT_CS(%esp)
+	.endif
 
 	/* Are we on the entry stack? Bail out if not! */
 	movl	PER_CPU_VAR(cpu_entry_area), %ecx
@@ -1019,6 +1021,29 @@ ENTRY(entry_INT80_32)
 	/* Restore user state */
 	RESTORE_REGS pop=4			# skip orig_eax/error_code
 .Lirq_return:
+	testl $CS_FROM_INT3, 4(%esp)
+	jz .Lno_iret_fixup
+
+	/*
+	 * Undo the magic from ENTRY(int3), in particular consider the case
+	 * where regs->sp has been modified.
+	 */
+
+	pushl	%eax
+	movl	%esp, %eax
+
+	movl	4*4(%eax), %esp		# restore (modified) regs->sp
+
+	/* rebuild IRET frame */
+	pushl	3*4(%eax)		# flags
+	pushl	2*4(%eax)		# cs
+	pushl	1*4(%eax)		# ip
+
+	andl	$0x0000ffff, 4(%esp)	# clear high CS bits
+
+	movl	(%eax), %eax		# restore eax
+
+.Lno_iret_fixup:
 	/*
 	 * ARCH_HAS_MEMBARRIER_SYNC_CORE rely on IRET core serialization
 	 * when returning from IPI handler and when returning from
@@ -1477,9 +1502,57 @@ END(nmi)
 
 ENTRY(int3)
 	ASM_CLAC
+
+	/*
+	 * The high bits of the CS dword (__csh) are used for CS_FROM_*. Clear
+	 * them in case hardware didn't do this for us.
+	 */
+	andl	$0x0000ffff, 4(%esp)
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
+	orl	$CS_FROM_INT3, 4(%esp) # mark magic IRET
+
+.Lfrom_usermode_no_gap:
+
 	pushl	$-1				# mark this as an int
 
-	SAVE_ALL switch_stacks=1
+	SAVE_ALL switch_stacks=1 clear_cs=0
 	ENCODE_FRAME_POINTER
 	TRACE_IRQS_OFF
 	xorl	%edx, %edx			# zero error code
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
index 4db9c0d29bc1..1e11076c3a2b 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -613,11 +613,118 @@ extern struct paravirt_patch_site __start_parainstructions[],
 	__stop_parainstructions[];
 #endif	/* CONFIG_PARAVIRT */
 
+static __always_inline void print_stack(struct pt_regs *regs)
+{
+#if 1
+	unsigned long *end = (unsigned long *)current_stack_pointer;
+	unsigned long *frame = (unsigned long *)__builtin_frame_address(0);
+	unsigned long *stack = (unsigned long *)(current_stack_pointer & ~(THREAD_SIZE - 1));
+	int i, j;
+
+	stack += THREAD_SIZE / sizeof(unsigned long);
+
+	printk("stack dump from: %lx\n", stack);
+
+	for (i=0; ; i++) {
+		pr_info("stack[%03d]: ", 16*i);
+		for (j=0; j<16; j++) {
+			if (i==0 && j==0) {
+				pr_cont(" %08lx  ", 0UL);
+				stack--;
+				continue;
+			}
+			if (stack == end)
+				pr_cont(">%08lx< ", *(stack--));
+			else if (stack == frame)
+				pr_cont("*%08lx* ", *(stack--));
+			else if (stack == regs)
+				pr_cont("r%08lxr ", *(stack--));
+			else if (regs && stack == regs->sp)
+				pr_cont("s%08lxs ", *(stack--));
+			else
+				pr_cont(" %08lx  ", *(stack--));
+		}
+		pr_cont("\n");
+
+		if (stack < end)
+			break;
+	}
+#endif
+}
+
+static void __init int3_magic(unsigned int *ptr)
+{
+	printk("*************** %lx\n", (unsigned long)ptr);
+	print_stack(NULL);
+	*ptr = 1;
+}
+
+static __initdata unsigned long int3_ip;
+
+static int __init int3_exception_notify(struct notifier_block *self, unsigned long val, void *data)
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
+	printk("XXXXXXXXXXXXXXXXXXXXXXXXXX %lx %lx\n", regs->ip, int3_ip);
+	if (regs->ip - INT3_INSN_SIZE != int3_ip)
+		return NOTIFY_DONE;
+
+	print_stack(regs);
+	int3_emulate_call(regs, (unsigned long)&int3_magic);
+	print_stack(regs);
+
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
+	printk("+++++++++++++++++++ %lx %lx\n", (unsigned long)&val, (unsigned long)&int3_ip);
+
+	print_stack(NULL);
+
+	/*
+	 * Basically: int3_magic(&val); but really complicated :-)
+	 *
+	 * Stick the address of the INT3 instruction into int3_ip, then trigger
+	 * the INT3, padded with NOPs to match a CALL instruction length.
+	 */
+#ifdef CONFIG_X86_32
+	asm volatile ("call 1f; 1: pop (%%edx); add $5, (%%edx);"
+		      "int3; nop; nop; nop; nop" : : "d" (&int3_ip), "a" (&val) : "memory");
+#else /* CONFIG_X86_64 */
+	asm volatile ("call 1f; 1: pop (%%rdx); add $5, (%%rdx);"
+		      "int3; nop; nop; nop; nop" : : "d" (&int3_ip), "D" (&val) : "memory");
+#endif
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
@@ -642,10 +749,11 @@ void __init alternative_instructions(void)
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
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 8b6d03e55d2f..e072cdd07284 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -572,6 +572,7 @@ NOKPROBE_SYMBOL(do_general_protection);
 
 dotraplinkage void notrace do_int3(struct pt_regs *regs, long error_code)
 {
+	printk("int3 frame: %lx\n", __builtin_frame_address(0));
 #ifdef CONFIG_DYNAMIC_FTRACE
 	/*
 	 * ftrace must be first, everything else may cause a recursive crash.
