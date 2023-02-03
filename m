Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC6C9689596
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:24:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233278AbjBCKVB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:21:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233332AbjBCKU6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:20:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEF9C9E9FD
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:20:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6168B82A73
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:20:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F308EC433D2;
        Fri,  3 Feb 2023 10:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419630;
        bh=dnGCLA99twT8itG9epST+v0N7WrSI1SuIMW6pYMjfF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YWZSDla2m9sjVbrBJko43FgGFnkjnVPcTS/NA3Y37ALSPN8pbdG1D3tpDBlU4g+cE
         czdRKE0wjkEXaWhsl6V/hnS0HuyxfMGIHIBK92oimKWKIh+eJ/r5JL8ofgTYad233M
         690s9k0yJJAnYcfuwXWbdBSAEf7ZpKX1qQgWM0S8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH 4.19 66/80] exit: Add and use make_task_dead.
Date:   Fri,  3 Feb 2023 11:13:00 +0100
Message-Id: <20230203101018.044943980@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101015.263854890@linuxfoundation.org>
References: <20230203101015.263854890@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

commit 0e25498f8cd43c1b5aa327f373dd094e9a006da7 upstream.

There are two big uses of do_exit.  The first is it's design use to be
the guts of the exit(2) system call.  The second use is to terminate
a task after something catastrophic has happened like a NULL pointer
in kernel code.

Add a function make_task_dead that is initialy exactly the same as
do_exit to cover the cases where do_exit is called to handle
catastrophic failure.  In time this can probably be reduced to just a
light wrapper around do_task_dead. For now keep it exactly the same so
that there will be no behavioral differences introducing this new
concept.

Replace all of the uses of do_exit that use it for catastraphic
task cleanup with make_task_dead to make it clear what the code
is doing.

As part of this rename rewind_stack_do_exit
rewind_stack_and_make_dead.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/alpha/kernel/traps.c           |    6 +++---
 arch/alpha/mm/fault.c               |    2 +-
 arch/arm/kernel/traps.c             |    2 +-
 arch/arm/mm/fault.c                 |    2 +-
 arch/arm64/kernel/traps.c           |    2 +-
 arch/arm64/mm/fault.c               |    2 +-
 arch/h8300/kernel/traps.c           |    2 +-
 arch/h8300/mm/fault.c               |    2 +-
 arch/hexagon/kernel/traps.c         |    2 +-
 arch/ia64/kernel/mca_drv.c          |    2 +-
 arch/ia64/kernel/traps.c            |    2 +-
 arch/ia64/mm/fault.c                |    2 +-
 arch/m68k/kernel/traps.c            |    2 +-
 arch/m68k/mm/fault.c                |    2 +-
 arch/microblaze/kernel/exceptions.c |    4 ++--
 arch/mips/kernel/traps.c            |    2 +-
 arch/nds32/kernel/traps.c           |    8 ++++----
 arch/nios2/kernel/traps.c           |    4 ++--
 arch/openrisc/kernel/traps.c        |    2 +-
 arch/parisc/kernel/traps.c          |    2 +-
 arch/powerpc/kernel/traps.c         |    2 +-
 arch/riscv/kernel/traps.c           |    2 +-
 arch/riscv/mm/fault.c               |    2 +-
 arch/s390/kernel/dumpstack.c        |    2 +-
 arch/s390/kernel/nmi.c              |    2 +-
 arch/sh/kernel/traps.c              |    2 +-
 arch/sparc/kernel/traps_32.c        |    4 +---
 arch/sparc/kernel/traps_64.c        |    4 +---
 arch/x86/entry/entry_32.S           |    6 +++---
 arch/x86/entry/entry_64.S           |    6 +++---
 arch/x86/kernel/dumpstack.c         |    4 ++--
 arch/xtensa/kernel/traps.c          |    2 +-
 include/linux/sched/task.h          |    1 +
 kernel/exit.c                       |    9 +++++++++
 tools/objtool/check.c               |    3 ++-
 35 files changed, 56 insertions(+), 49 deletions(-)

--- a/arch/alpha/kernel/traps.c
+++ b/arch/alpha/kernel/traps.c
@@ -192,7 +192,7 @@ die_if_kernel(char * str, struct pt_regs
 		local_irq_enable();
 		while (1);
 	}
-	do_exit(SIGSEGV);
+	make_task_dead(SIGSEGV);
 }
 
 #ifndef CONFIG_MATHEMU
@@ -577,7 +577,7 @@ do_entUna(void * va, unsigned long opcod
 
 	printk("Bad unaligned kernel access at %016lx: %p %lx %lu\n",
 		pc, va, opcode, reg);
-	do_exit(SIGSEGV);
+	make_task_dead(SIGSEGV);
 
 got_exception:
 	/* Ok, we caught the exception, but we don't want it.  Is there
@@ -632,7 +632,7 @@ got_exception:
 		local_irq_enable();
 		while (1);
 	}
-	do_exit(SIGSEGV);
+	make_task_dead(SIGSEGV);
 }
 
 /*
--- a/arch/alpha/mm/fault.c
+++ b/arch/alpha/mm/fault.c
@@ -206,7 +206,7 @@ retry:
 	printk(KERN_ALERT "Unable to handle kernel paging request at "
 	       "virtual address %016lx\n", address);
 	die_if_kernel("Oops", regs, cause, (unsigned long*)regs - 16);
-	do_exit(SIGKILL);
+	make_task_dead(SIGKILL);
 
 	/* We ran out of memory, or some other thing happened to us that
 	   made us unable to handle the page fault gracefully.  */
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -344,7 +344,7 @@ static void oops_end(unsigned long flags
 	if (panic_on_oops)
 		panic("Fatal exception");
 	if (signr)
-		do_exit(signr);
+		make_task_dead(signr);
 }
 
 /*
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -149,7 +149,7 @@ __do_kernel_fault(struct mm_struct *mm,
 	show_pte(mm, addr);
 	die("Oops", regs, fsr);
 	bust_spinlocks(0);
-	do_exit(SIGKILL);
+	make_task_dead(SIGKILL);
 }
 
 /*
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -224,7 +224,7 @@ void die(const char *str, struct pt_regs
 	raw_spin_unlock_irqrestore(&die_lock, flags);
 
 	if (ret != NOTIFY_STOP)
-		do_exit(SIGSEGV);
+		make_task_dead(SIGSEGV);
 }
 
 static bool show_unhandled_signals_ratelimited(void)
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -268,7 +268,7 @@ static void die_kernel_fault(const char
 	show_pte(addr);
 	die("Oops", regs, esr);
 	bust_spinlocks(0);
-	do_exit(SIGKILL);
+	make_task_dead(SIGKILL);
 }
 
 static void __do_kernel_fault(unsigned long addr, unsigned int esr,
--- a/arch/h8300/kernel/traps.c
+++ b/arch/h8300/kernel/traps.c
@@ -110,7 +110,7 @@ void die(const char *str, struct pt_regs
 	dump(fp);
 
 	spin_unlock_irq(&die_lock);
-	do_exit(SIGSEGV);
+	make_dead_task(SIGSEGV);
 }
 
 static int kstack_depth_to_print = 24;
--- a/arch/h8300/mm/fault.c
+++ b/arch/h8300/mm/fault.c
@@ -52,7 +52,7 @@ asmlinkage int do_page_fault(struct pt_r
 	printk(" at virtual address %08lx\n", address);
 	if (!user_mode(regs))
 		die("Oops", regs, error_code);
-	do_exit(SIGKILL);
+	make_dead_task(SIGKILL);
 
 	return 1;
 }
--- a/arch/hexagon/kernel/traps.c
+++ b/arch/hexagon/kernel/traps.c
@@ -234,7 +234,7 @@ int die(const char *str, struct pt_regs
 		panic("Fatal exception");
 
 	oops_exit();
-	do_exit(err);
+	make_dead_task(err);
 	return 0;
 }
 
--- a/arch/ia64/kernel/mca_drv.c
+++ b/arch/ia64/kernel/mca_drv.c
@@ -176,7 +176,7 @@ mca_handler_bh(unsigned long paddr, void
 	spin_unlock(&mca_bh_lock);
 
 	/* This process is about to be killed itself */
-	do_exit(SIGKILL);
+	make_task_dead(SIGKILL);
 }
 
 /**
--- a/arch/ia64/kernel/traps.c
+++ b/arch/ia64/kernel/traps.c
@@ -85,7 +85,7 @@ die (const char *str, struct pt_regs *re
 	if (panic_on_oops)
 		panic("Fatal exception");
 
-  	do_exit(SIGSEGV);
+	make_task_dead(SIGSEGV);
 	return 0;
 }
 
--- a/arch/ia64/mm/fault.c
+++ b/arch/ia64/mm/fault.c
@@ -302,7 +302,7 @@ retry:
 		regs = NULL;
 	bust_spinlocks(0);
 	if (regs)
-		do_exit(SIGKILL);
+		make_task_dead(SIGKILL);
 	return;
 
   out_of_memory:
--- a/arch/m68k/kernel/traps.c
+++ b/arch/m68k/kernel/traps.c
@@ -1139,7 +1139,7 @@ void die_if_kernel (char *str, struct pt
 	pr_crit("%s: %08x\n", str, nr);
 	show_registers(fp);
 	add_taint(TAINT_DIE, LOCKDEP_NOW_UNRELIABLE);
-	do_exit(SIGSEGV);
+	make_task_dead(SIGSEGV);
 }
 
 asmlinkage void set_esp0(unsigned long ssp)
--- a/arch/m68k/mm/fault.c
+++ b/arch/m68k/mm/fault.c
@@ -48,7 +48,7 @@ int send_fault_sig(struct pt_regs *regs)
 			pr_alert("Unable to handle kernel access");
 		pr_cont(" at virtual address %p\n", addr);
 		die_if_kernel("Oops", regs, 0 /*error_code*/);
-		do_exit(SIGKILL);
+		make_task_dead(SIGKILL);
 	}
 
 	return 1;
--- a/arch/microblaze/kernel/exceptions.c
+++ b/arch/microblaze/kernel/exceptions.c
@@ -44,10 +44,10 @@ void die(const char *str, struct pt_regs
 	pr_warn("Oops: %s, sig: %ld\n", str, err);
 	show_regs(fp);
 	spin_unlock_irq(&die_lock);
-	/* do_exit() should take care of panic'ing from an interrupt
+	/* make_task_dead() should take care of panic'ing from an interrupt
 	 * context so we don't handle it here
 	 */
-	do_exit(err);
+	make_task_dead(err);
 }
 
 /* for user application debugging */
--- a/arch/mips/kernel/traps.c
+++ b/arch/mips/kernel/traps.c
@@ -412,7 +412,7 @@ void __noreturn die(const char *str, str
 	if (regs && kexec_should_crash(current))
 		crash_kexec(regs);
 
-	do_exit(sig);
+	make_task_dead(sig);
 }
 
 extern struct exception_table_entry __start___dbe_table[];
--- a/arch/nds32/kernel/traps.c
+++ b/arch/nds32/kernel/traps.c
@@ -183,7 +183,7 @@ void die(const char *str, struct pt_regs
 
 	bust_spinlocks(0);
 	spin_unlock_irq(&die_lock);
-	do_exit(SIGSEGV);
+	make_task_dead(SIGSEGV);
 }
 
 EXPORT_SYMBOL(die);
@@ -286,7 +286,7 @@ void unhandled_interruption(struct pt_re
 	pr_emerg("unhandled_interruption\n");
 	show_regs(regs);
 	if (!user_mode(regs))
-		do_exit(SIGKILL);
+		make_task_dead(SIGKILL);
 	force_sig(SIGKILL, current);
 }
 
@@ -297,7 +297,7 @@ void unhandled_exceptions(unsigned long
 		 addr, type);
 	show_regs(regs);
 	if (!user_mode(regs))
-		do_exit(SIGKILL);
+		make_task_dead(SIGKILL);
 	force_sig(SIGKILL, current);
 }
 
@@ -324,7 +324,7 @@ void do_revinsn(struct pt_regs *regs)
 	pr_emerg("Reserved Instruction\n");
 	show_regs(regs);
 	if (!user_mode(regs))
-		do_exit(SIGILL);
+		make_task_dead(SIGILL);
 	force_sig(SIGILL, current);
 }
 
--- a/arch/nios2/kernel/traps.c
+++ b/arch/nios2/kernel/traps.c
@@ -37,10 +37,10 @@ void die(const char *str, struct pt_regs
 	show_regs(regs);
 	spin_unlock_irq(&die_lock);
 	/*
-	 * do_exit() should take care of panic'ing from an interrupt
+	 * make_task_dead() should take care of panic'ing from an interrupt
 	 * context so we don't handle it here
 	 */
-	do_exit(err);
+	make_task_dead(err);
 }
 
 void _exception(int signo, struct pt_regs *regs, int code, unsigned long addr)
--- a/arch/openrisc/kernel/traps.c
+++ b/arch/openrisc/kernel/traps.c
@@ -224,7 +224,7 @@ void die(const char *str, struct pt_regs
 	__asm__ __volatile__("l.nop   1");
 	do {} while (1);
 #endif
-	do_exit(SIGSEGV);
+	make_task_dead(SIGSEGV);
 }
 
 /* This is normally the 'Oops' routine */
--- a/arch/parisc/kernel/traps.c
+++ b/arch/parisc/kernel/traps.c
@@ -265,7 +265,7 @@ void die_if_kernel(char *str, struct pt_
 		panic("Fatal exception");
 
 	oops_exit();
-	do_exit(SIGSEGV);
+	make_task_dead(SIGSEGV);
 }
 
 /* gdb uses break 4,8 */
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -251,7 +251,7 @@ static void oops_end(unsigned long flags
 		panic("Fatal exception in interrupt");
 	if (panic_on_oops)
 		panic("Fatal exception");
-	do_exit(signr);
+	make_task_dead(signr);
 }
 NOKPROBE_SYMBOL(oops_end);
 
--- a/arch/riscv/kernel/traps.c
+++ b/arch/riscv/kernel/traps.c
@@ -64,7 +64,7 @@ void die(struct pt_regs *regs, const cha
 	if (panic_on_oops)
 		panic("Fatal exception");
 	if (ret != NOTIFY_STOP)
-		do_exit(SIGSEGV);
+		make_task_dead(SIGSEGV);
 }
 
 void do_trap(struct pt_regs *regs, int signo, int code,
--- a/arch/riscv/mm/fault.c
+++ b/arch/riscv/mm/fault.c
@@ -200,7 +200,7 @@ no_context:
 		(addr < PAGE_SIZE) ? "NULL pointer dereference" :
 		"paging request", addr);
 	die(regs, "Oops");
-	do_exit(SIGKILL);
+	make_task_dead(SIGKILL);
 
 	/*
 	 * We ran out of memory, call the OOM killer, and return the userspace
--- a/arch/s390/kernel/dumpstack.c
+++ b/arch/s390/kernel/dumpstack.c
@@ -187,5 +187,5 @@ void die(struct pt_regs *regs, const cha
 	if (panic_on_oops)
 		panic("Fatal exception: panic_on_oops");
 	oops_exit();
-	do_exit(SIGSEGV);
+	make_task_dead(SIGSEGV);
 }
--- a/arch/s390/kernel/nmi.c
+++ b/arch/s390/kernel/nmi.c
@@ -179,7 +179,7 @@ void s390_handle_mcck(void)
 		       "malfunction (code 0x%016lx).\n", mcck.mcck_code);
 		printk(KERN_EMERG "mcck: task: %s, pid: %d.\n",
 		       current->comm, current->pid);
-		do_exit(SIGSEGV);
+		make_task_dead(SIGSEGV);
 	}
 }
 EXPORT_SYMBOL_GPL(s390_handle_mcck);
--- a/arch/sh/kernel/traps.c
+++ b/arch/sh/kernel/traps.c
@@ -57,7 +57,7 @@ void die(const char *str, struct pt_regs
 	if (panic_on_oops)
 		panic("Fatal exception");
 
-	do_exit(SIGSEGV);
+	make_task_dead(SIGSEGV);
 }
 
 void die_if_kernel(const char *str, struct pt_regs *regs, long err)
--- a/arch/sparc/kernel/traps_32.c
+++ b/arch/sparc/kernel/traps_32.c
@@ -86,9 +86,7 @@ void __noreturn die_if_kernel(char *str,
 	}
 	printk("Instruction DUMP:");
 	instruction_dump ((unsigned long *) regs->pc);
-	if(regs->psr & PSR_PS)
-		do_exit(SIGKILL);
-	do_exit(SIGSEGV);
+	make_task_dead((regs->psr & PSR_PS) ? SIGKILL : SIGSEGV);
 }
 
 void do_hw_interrupt(struct pt_regs *regs, unsigned long type)
--- a/arch/sparc/kernel/traps_64.c
+++ b/arch/sparc/kernel/traps_64.c
@@ -2565,9 +2565,7 @@ void __noreturn die_if_kernel(char *str,
 	}
 	if (panic_on_oops)
 		panic("Fatal exception");
-	if (regs->tstate & TSTATE_PRIV)
-		do_exit(SIGKILL);
-	do_exit(SIGSEGV);
+	make_task_dead((regs->tstate & TSTATE_PRIV)? SIGKILL : SIGSEGV);
 }
 EXPORT_SYMBOL(die_if_kernel);
 
--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -1500,13 +1500,13 @@ ENTRY(async_page_fault)
 END(async_page_fault)
 #endif
 
-ENTRY(rewind_stack_do_exit)
+ENTRY(rewind_stack_and_make_dead)
 	/* Prevent any naive code from trying to unwind to our caller. */
 	xorl	%ebp, %ebp
 
 	movl	PER_CPU_VAR(cpu_current_top_of_stack), %esi
 	leal	-TOP_OF_KERNEL_STACK_PADDING-PTREGS_SIZE(%esi), %esp
 
-	call	do_exit
+	call	make_task_dead
 1:	jmp 1b
-END(rewind_stack_do_exit)
+END(rewind_stack_and_make_dead)
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -1762,7 +1762,7 @@ ENTRY(ignore_sysret)
 	sysretl
 END(ignore_sysret)
 
-ENTRY(rewind_stack_do_exit)
+ENTRY(rewind_stack_and_make_dead)
 	UNWIND_HINT_FUNC
 	/* Prevent any naive code from trying to unwind to our caller. */
 	xorl	%ebp, %ebp
@@ -1771,5 +1771,5 @@ ENTRY(rewind_stack_do_exit)
 	leaq	-PTREGS_SIZE(%rax), %rsp
 	UNWIND_HINT_REGS
 
-	call	do_exit
-END(rewind_stack_do_exit)
+	call	make_task_dead
+END(rewind_stack_and_make_dead)
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -326,7 +326,7 @@ unsigned long oops_begin(void)
 }
 NOKPROBE_SYMBOL(oops_begin);
 
-void __noreturn rewind_stack_do_exit(int signr);
+void __noreturn rewind_stack_and_make_dead(int signr);
 
 void oops_end(unsigned long flags, struct pt_regs *regs, int signr)
 {
@@ -361,7 +361,7 @@ void oops_end(unsigned long flags, struc
 	 * reuse the task stack and that existing poisons are invalid.
 	 */
 	kasan_unpoison_task_stack(current);
-	rewind_stack_do_exit(signr);
+	rewind_stack_and_make_dead(signr);
 }
 NOKPROBE_SYMBOL(oops_end);
 
--- a/arch/xtensa/kernel/traps.c
+++ b/arch/xtensa/kernel/traps.c
@@ -542,5 +542,5 @@ void die(const char * str, struct pt_reg
 	if (panic_on_oops)
 		panic("Fatal exception");
 
-	do_exit(err);
+	make_task_dead(err);
 }
--- a/include/linux/sched/task.h
+++ b/include/linux/sched/task.h
@@ -36,6 +36,7 @@ extern int sched_fork(unsigned long clon
 extern void sched_dead(struct task_struct *p);
 
 void __noreturn do_task_dead(void);
+void __noreturn make_task_dead(int signr);
 
 extern void proc_caches_init(void);
 
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -922,6 +922,15 @@ void __noreturn do_exit(long code)
 }
 EXPORT_SYMBOL_GPL(do_exit);
 
+void __noreturn make_task_dead(int signr)
+{
+	/*
+	 * Take the task off the cpu after something catastrophic has
+	 * happened.
+	 */
+	do_exit(signr);
+}
+
 void complete_and_exit(struct completion *comp, long code)
 {
 	if (comp)
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -159,6 +159,7 @@ static int __dead_end_function(struct ob
 		"panic",
 		"do_exit",
 		"do_task_dead",
+		"make_task_dead",
 		"__module_put_and_exit",
 		"complete_and_exit",
 		"kvm_spurious_fault",
@@ -167,7 +168,7 @@ static int __dead_end_function(struct ob
 		"fortify_panic",
 		"usercopy_abort",
 		"machine_real_restart",
-		"rewind_stack_do_exit",
+		"rewind_stack_and_make_dead"
 	};
 
 	if (func->bind == STB_WEAK)


