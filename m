Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78B8F68755E
	for <lists+stable@lfdr.de>; Thu,  2 Feb 2023 06:45:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231537AbjBBFph (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Feb 2023 00:45:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230502AbjBBFpf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Feb 2023 00:45:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACC0F3F283;
        Wed,  1 Feb 2023 21:45:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40091B824B6;
        Thu,  2 Feb 2023 05:45:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0FEDC4339C;
        Thu,  2 Feb 2023 05:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675316722;
        bh=CPC3rnkJBI+2seUXRbQ6cBmh4fgZrX70sHReKY5rEZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oYyMXxn5zYzVzt2gJWJOLWY6litnWBqumdAoDbpX964Vdkh81Yci4EWv4Jec3JUMZ
         SZi3TLLWL3V6dpJqXBtzd94V/hbdMiIlr5lx/toRPuLFHz8Y//uM3E1RTb1Sd2bRHR
         s2gY6wz/NHuuaFdKRAJv7qsaBNscnXIYN9pWkXSz9/N1IDgjl0SxqjNArT8cQWBCZ3
         cgPgZcgR9uH5bek27l2FHkqBsgxqsmKWN61gSaoLTrlcphhkYNbswDPeKD9ayla6Qi
         xVn7ABW9RKgyJb62ulGRXn/GY56aJim9mCd5Klr0kAtS+kALsRPbN3tH963w6NqYSE
         SyBzw089cudyA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        Kees Cook <keescook@chromium.org>,
        SeongJae Park <sj@kernel.org>,
        Seth Jenkins <sethjenkins@google.com>,
        Jann Horn <jannh@google.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4.14 04/16] exit: Add and use make_task_dead.
Date:   Wed,  1 Feb 2023 21:43:54 -0800
Message-Id: <20230202054406.221721-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230202054406.221721-1-ebiggers@kernel.org>
References: <20230202054406.221721-1-ebiggers@kernel.org>
MIME-Version: 1.0
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
---
 arch/alpha/kernel/traps.c           | 6 +++---
 arch/alpha/mm/fault.c               | 2 +-
 arch/arm/kernel/traps.c             | 2 +-
 arch/arm/mm/fault.c                 | 2 +-
 arch/arm64/kernel/traps.c           | 2 +-
 arch/arm64/mm/fault.c               | 2 +-
 arch/h8300/kernel/traps.c           | 2 +-
 arch/h8300/mm/fault.c               | 2 +-
 arch/hexagon/kernel/traps.c         | 2 +-
 arch/ia64/kernel/mca_drv.c          | 2 +-
 arch/ia64/kernel/traps.c            | 2 +-
 arch/ia64/mm/fault.c                | 2 +-
 arch/m68k/kernel/traps.c            | 2 +-
 arch/m68k/mm/fault.c                | 2 +-
 arch/microblaze/kernel/exceptions.c | 4 ++--
 arch/mips/kernel/traps.c            | 2 +-
 arch/nios2/kernel/traps.c           | 4 ++--
 arch/openrisc/kernel/traps.c        | 2 +-
 arch/parisc/kernel/traps.c          | 2 +-
 arch/powerpc/kernel/traps.c         | 2 +-
 arch/s390/kernel/dumpstack.c        | 2 +-
 arch/s390/kernel/nmi.c              | 2 +-
 arch/sh/kernel/traps.c              | 2 +-
 arch/sparc/kernel/traps_32.c        | 4 +---
 arch/sparc/kernel/traps_64.c        | 4 +---
 arch/x86/entry/entry_32.S           | 6 +++---
 arch/x86/entry/entry_64.S           | 6 +++---
 arch/x86/kernel/dumpstack.c         | 4 ++--
 arch/xtensa/kernel/traps.c          | 2 +-
 include/linux/sched/task.h          | 1 +
 kernel/exit.c                       | 9 +++++++++
 tools/objtool/check.c               | 3 ++-
 32 files changed, 50 insertions(+), 43 deletions(-)

diff --git a/arch/alpha/kernel/traps.c b/arch/alpha/kernel/traps.c
index f43bd05dede26..6a45f392c6728 100644
--- a/arch/alpha/kernel/traps.c
+++ b/arch/alpha/kernel/traps.c
@@ -192,7 +192,7 @@ die_if_kernel(char * str, struct pt_regs *regs, long err, unsigned long *r9_15)
 		local_irq_enable();
 		while (1);
 	}
-	do_exit(SIGSEGV);
+	make_task_dead(SIGSEGV);
 }
 
 #ifndef CONFIG_MATHEMU
@@ -609,7 +609,7 @@ do_entUna(void * va, unsigned long opcode, unsigned long reg,
 
 	printk("Bad unaligned kernel access at %016lx: %p %lx %lu\n",
 		pc, va, opcode, reg);
-	do_exit(SIGSEGV);
+	make_task_dead(SIGSEGV);
 
 got_exception:
 	/* Ok, we caught the exception, but we don't want it.  Is there
@@ -664,7 +664,7 @@ do_entUna(void * va, unsigned long opcode, unsigned long reg,
 		local_irq_enable();
 		while (1);
 	}
-	do_exit(SIGSEGV);
+	make_task_dead(SIGSEGV);
 }
 
 /*
diff --git a/arch/alpha/mm/fault.c b/arch/alpha/mm/fault.c
index e9392302c5dab..a85c1b18d0bc9 100644
--- a/arch/alpha/mm/fault.c
+++ b/arch/alpha/mm/fault.c
@@ -206,7 +206,7 @@ do_page_fault(unsigned long address, unsigned long mmcsr,
 	printk(KERN_ALERT "Unable to handle kernel paging request at "
 	       "virtual address %016lx\n", address);
 	die_if_kernel("Oops", regs, cause, (unsigned long*)regs - 16);
-	do_exit(SIGKILL);
+	make_task_dead(SIGKILL);
 
 	/* We ran out of memory, or some other thing happened to us that
 	   made us unable to handle the page fault gracefully.  */
diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index 7d81d4a1f5a9c..df7a92c5df6c5 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -342,7 +342,7 @@ static void oops_end(unsigned long flags, struct pt_regs *regs, int signr)
 	if (panic_on_oops)
 		panic("Fatal exception");
 	if (signr)
-		do_exit(signr);
+		make_task_dead(signr);
 }
 
 /*
diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
index 9bb446cc135d1..45e73596b524c 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -150,7 +150,7 @@ __do_kernel_fault(struct mm_struct *mm, unsigned long addr, unsigned int fsr,
 	show_pte(mm, addr);
 	die("Oops", regs, fsr);
 	bust_spinlocks(0);
-	do_exit(SIGKILL);
+	make_task_dead(SIGKILL);
 }
 
 /*
diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index b30d23431fe11..ee19e6463e5a4 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -223,7 +223,7 @@ void die(const char *str, struct pt_regs *regs, int err)
 	raw_spin_unlock_irqrestore(&die_lock, flags);
 
 	if (ret != NOTIFY_STOP)
-		do_exit(SIGSEGV);
+		make_task_dead(SIGSEGV);
 }
 
 void arm64_notify_die(const char *str, struct pt_regs *regs,
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 617787e4081f1..d191b046d4c18 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -288,7 +288,7 @@ static void __do_kernel_fault(unsigned long addr, unsigned int esr,
 	show_pte(addr);
 	die("Oops", regs, esr);
 	bust_spinlocks(0);
-	do_exit(SIGKILL);
+	make_task_dead(SIGKILL);
 }
 
 /*
diff --git a/arch/h8300/kernel/traps.c b/arch/h8300/kernel/traps.c
index e47a9e0dc278f..a284c126f07a6 100644
--- a/arch/h8300/kernel/traps.c
+++ b/arch/h8300/kernel/traps.c
@@ -110,7 +110,7 @@ void die(const char *str, struct pt_regs *fp, unsigned long err)
 	dump(fp);
 
 	spin_unlock_irq(&die_lock);
-	do_exit(SIGSEGV);
+	make_dead_task(SIGSEGV);
 }
 
 static int kstack_depth_to_print = 24;
diff --git a/arch/h8300/mm/fault.c b/arch/h8300/mm/fault.c
index fabffb83930af..a8d8fc63780e4 100644
--- a/arch/h8300/mm/fault.c
+++ b/arch/h8300/mm/fault.c
@@ -52,7 +52,7 @@ asmlinkage int do_page_fault(struct pt_regs *regs, unsigned long address,
 	printk(" at virtual address %08lx\n", address);
 	if (!user_mode(regs))
 		die("Oops", regs, error_code);
-	do_exit(SIGKILL);
+	make_dead_task(SIGKILL);
 
 	return 1;
 }
diff --git a/arch/hexagon/kernel/traps.c b/arch/hexagon/kernel/traps.c
index 2942a9204a9aa..797608772f8a4 100644
--- a/arch/hexagon/kernel/traps.c
+++ b/arch/hexagon/kernel/traps.c
@@ -234,7 +234,7 @@ int die(const char *str, struct pt_regs *regs, long err)
 		panic("Fatal exception");
 
 	oops_exit();
-	do_exit(err);
+	make_dead_task(err);
 	return 0;
 }
 
diff --git a/arch/ia64/kernel/mca_drv.c b/arch/ia64/kernel/mca_drv.c
index 3503d488e9b3f..7c9d63ef1cb28 100644
--- a/arch/ia64/kernel/mca_drv.c
+++ b/arch/ia64/kernel/mca_drv.c
@@ -176,7 +176,7 @@ mca_handler_bh(unsigned long paddr, void *iip, unsigned long ipsr)
 	spin_unlock(&mca_bh_lock);
 
 	/* This process is about to be killed itself */
-	do_exit(SIGKILL);
+	make_task_dead(SIGKILL);
 }
 
 /**
diff --git a/arch/ia64/kernel/traps.c b/arch/ia64/kernel/traps.c
index 6d4e76a4267f1..2bab65c10d236 100644
--- a/arch/ia64/kernel/traps.c
+++ b/arch/ia64/kernel/traps.c
@@ -85,7 +85,7 @@ die (const char *str, struct pt_regs *regs, long err)
 	if (panic_on_oops)
 		panic("Fatal exception");
 
-  	do_exit(SIGSEGV);
+	make_task_dead(SIGSEGV);
 	return 0;
 }
 
diff --git a/arch/ia64/mm/fault.c b/arch/ia64/mm/fault.c
index dfdc152d6737b..23f23e051ee24 100644
--- a/arch/ia64/mm/fault.c
+++ b/arch/ia64/mm/fault.c
@@ -300,7 +300,7 @@ ia64_do_page_fault (unsigned long address, unsigned long isr, struct pt_regs *re
 		regs = NULL;
 	bust_spinlocks(0);
 	if (regs)
-		do_exit(SIGKILL);
+		make_task_dead(SIGKILL);
 	return;
 
   out_of_memory:
diff --git a/arch/m68k/kernel/traps.c b/arch/m68k/kernel/traps.c
index c1cc4e99aa945..5c72deb117a8e 100644
--- a/arch/m68k/kernel/traps.c
+++ b/arch/m68k/kernel/traps.c
@@ -1141,7 +1141,7 @@ void die_if_kernel (char *str, struct pt_regs *fp, int nr)
 	pr_crit("%s: %08x\n", str, nr);
 	show_registers(fp);
 	add_taint(TAINT_DIE, LOCKDEP_NOW_UNRELIABLE);
-	do_exit(SIGSEGV);
+	make_task_dead(SIGSEGV);
 }
 
 asmlinkage void set_esp0(unsigned long ssp)
diff --git a/arch/m68k/mm/fault.c b/arch/m68k/mm/fault.c
index 127d7c1f2090c..4ef6057592f12 100644
--- a/arch/m68k/mm/fault.c
+++ b/arch/m68k/mm/fault.c
@@ -50,7 +50,7 @@ int send_fault_sig(struct pt_regs *regs)
 			pr_alert("Unable to handle kernel access");
 		pr_cont(" at virtual address %p\n", siginfo.si_addr);
 		die_if_kernel("Oops", regs, 0 /*error_code*/);
-		do_exit(SIGKILL);
+		make_task_dead(SIGKILL);
 	}
 
 	return 1;
diff --git a/arch/microblaze/kernel/exceptions.c b/arch/microblaze/kernel/exceptions.c
index e6f338d0496bb..3066d7fe484bd 100644
--- a/arch/microblaze/kernel/exceptions.c
+++ b/arch/microblaze/kernel/exceptions.c
@@ -44,10 +44,10 @@ void die(const char *str, struct pt_regs *fp, long err)
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
diff --git a/arch/mips/kernel/traps.c b/arch/mips/kernel/traps.c
index abbc64788008a..a8f166ff2762b 100644
--- a/arch/mips/kernel/traps.c
+++ b/arch/mips/kernel/traps.c
@@ -414,7 +414,7 @@ void __noreturn die(const char *str, struct pt_regs *regs)
 	if (regs && kexec_should_crash(current))
 		crash_kexec(regs);
 
-	do_exit(sig);
+	make_task_dead(sig);
 }
 
 extern struct exception_table_entry __start___dbe_table[];
diff --git a/arch/nios2/kernel/traps.c b/arch/nios2/kernel/traps.c
index 8184e7d6b3857..5dadd36d13ce3 100644
--- a/arch/nios2/kernel/traps.c
+++ b/arch/nios2/kernel/traps.c
@@ -43,10 +43,10 @@ void die(const char *str, struct pt_regs *regs, long err)
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
diff --git a/arch/openrisc/kernel/traps.c b/arch/openrisc/kernel/traps.c
index 0d44e8007ad6e..a8fb061f1c888 100644
--- a/arch/openrisc/kernel/traps.c
+++ b/arch/openrisc/kernel/traps.c
@@ -265,7 +265,7 @@ void die(const char *str, struct pt_regs *regs, long err)
 	__asm__ __volatile__("l.nop   1");
 	do {} while (1);
 #endif
-	do_exit(SIGSEGV);
+	make_task_dead(SIGSEGV);
 }
 
 /* This is normally the 'Oops' routine */
diff --git a/arch/parisc/kernel/traps.c b/arch/parisc/kernel/traps.c
index 346456c43aa0b..36582e23f9b9d 100644
--- a/arch/parisc/kernel/traps.c
+++ b/arch/parisc/kernel/traps.c
@@ -290,7 +290,7 @@ void die_if_kernel(char *str, struct pt_regs *regs, long err)
 		panic("Fatal exception");
 
 	oops_exit();
-	do_exit(SIGSEGV);
+	make_task_dead(SIGSEGV);
 }
 
 /* gdb uses break 4,8 */
diff --git a/arch/powerpc/kernel/traps.c b/arch/powerpc/kernel/traps.c
index 05c1aabad01c6..a507a6874d420 100644
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -211,7 +211,7 @@ static void oops_end(unsigned long flags, struct pt_regs *regs,
 		panic("Fatal exception in interrupt");
 	if (panic_on_oops)
 		panic("Fatal exception");
-	do_exit(signr);
+	make_task_dead(signr);
 }
 NOKPROBE_SYMBOL(oops_end);
 
diff --git a/arch/s390/kernel/dumpstack.c b/arch/s390/kernel/dumpstack.c
index 2aa545dca4d53..d9513a9f0db12 100644
--- a/arch/s390/kernel/dumpstack.c
+++ b/arch/s390/kernel/dumpstack.c
@@ -186,5 +186,5 @@ void die(struct pt_regs *regs, const char *str)
 	if (panic_on_oops)
 		panic("Fatal exception: panic_on_oops");
 	oops_exit();
-	do_exit(SIGSEGV);
+	make_task_dead(SIGSEGV);
 }
diff --git a/arch/s390/kernel/nmi.c b/arch/s390/kernel/nmi.c
index 31d03a84126c5..5dca748d3815c 100644
--- a/arch/s390/kernel/nmi.c
+++ b/arch/s390/kernel/nmi.c
@@ -94,7 +94,7 @@ void s390_handle_mcck(void)
 		       "malfunction (code 0x%016lx).\n", mcck.mcck_code);
 		printk(KERN_EMERG "mcck: task: %s, pid: %d.\n",
 		       current->comm, current->pid);
-		do_exit(SIGSEGV);
+		make_task_dead(SIGSEGV);
 	}
 }
 EXPORT_SYMBOL_GPL(s390_handle_mcck);
diff --git a/arch/sh/kernel/traps.c b/arch/sh/kernel/traps.c
index 8b49cced663dc..5fafbef7849b1 100644
--- a/arch/sh/kernel/traps.c
+++ b/arch/sh/kernel/traps.c
@@ -57,7 +57,7 @@ void die(const char *str, struct pt_regs *regs, long err)
 	if (panic_on_oops)
 		panic("Fatal exception");
 
-	do_exit(SIGSEGV);
+	make_task_dead(SIGSEGV);
 }
 
 void die_if_kernel(const char *str, struct pt_regs *regs, long err)
diff --git a/arch/sparc/kernel/traps_32.c b/arch/sparc/kernel/traps_32.c
index b1ed763e47877..fb0576f3b1de0 100644
--- a/arch/sparc/kernel/traps_32.c
+++ b/arch/sparc/kernel/traps_32.c
@@ -86,9 +86,7 @@ void __noreturn die_if_kernel(char *str, struct pt_regs *regs)
 	}
 	printk("Instruction DUMP:");
 	instruction_dump ((unsigned long *) regs->pc);
-	if(regs->psr & PSR_PS)
-		do_exit(SIGKILL);
-	do_exit(SIGSEGV);
+	make_task_dead((regs->psr & PSR_PS) ? SIGKILL : SIGSEGV);
 }
 
 void do_hw_interrupt(struct pt_regs *regs, unsigned long type)
diff --git a/arch/sparc/kernel/traps_64.c b/arch/sparc/kernel/traps_64.c
index 6ab9b87dbca8c..cfc06eeeb4f35 100644
--- a/arch/sparc/kernel/traps_64.c
+++ b/arch/sparc/kernel/traps_64.c
@@ -2547,9 +2547,7 @@ void __noreturn die_if_kernel(char *str, struct pt_regs *regs)
 	}
 	if (panic_on_oops)
 		panic("Fatal exception");
-	if (regs->tstate & TSTATE_PRIV)
-		do_exit(SIGKILL);
-	do_exit(SIGSEGV);
+	make_task_dead((regs->tstate & TSTATE_PRIV)? SIGKILL : SIGSEGV);
 }
 EXPORT_SYMBOL(die_if_kernel);
 
diff --git a/arch/x86/entry/entry_32.S b/arch/x86/entry/entry_32.S
index dbcea4281c309..1fdedb2eaef35 100644
--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -1068,13 +1068,13 @@ ENTRY(async_page_fault)
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
diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index 637a23d404e95..b57f15b51ed52 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -1672,7 +1672,7 @@ ENTRY(ignore_sysret)
 	sysret
 END(ignore_sysret)
 
-ENTRY(rewind_stack_do_exit)
+ENTRY(rewind_stack_and_make_dead)
 	UNWIND_HINT_FUNC
 	/* Prevent any naive code from trying to unwind to our caller. */
 	xorl	%ebp, %ebp
@@ -1681,5 +1681,5 @@ ENTRY(rewind_stack_do_exit)
 	leaq	-PTREGS_SIZE(%rax), %rsp
 	UNWIND_HINT_REGS
 
-	call	do_exit
-END(rewind_stack_do_exit)
+	call	make_task_dead
+END(rewind_stack_and_make_dead)
diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index 224de37821e4e..92585a755410b 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -271,7 +271,7 @@ unsigned long oops_begin(void)
 EXPORT_SYMBOL_GPL(oops_begin);
 NOKPROBE_SYMBOL(oops_begin);
 
-void __noreturn rewind_stack_do_exit(int signr);
+void __noreturn rewind_stack_and_make_dead(int signr);
 
 void oops_end(unsigned long flags, struct pt_regs *regs, int signr)
 {
@@ -303,7 +303,7 @@ void oops_end(unsigned long flags, struct pt_regs *regs, int signr)
 	 * reuse the task stack and that existing poisons are invalid.
 	 */
 	kasan_unpoison_task_stack(current);
-	rewind_stack_do_exit(signr);
+	rewind_stack_and_make_dead(signr);
 }
 NOKPROBE_SYMBOL(oops_end);
 
diff --git a/arch/xtensa/kernel/traps.c b/arch/xtensa/kernel/traps.c
index 2986bc88a18e7..09ba7436d1bd0 100644
--- a/arch/xtensa/kernel/traps.c
+++ b/arch/xtensa/kernel/traps.c
@@ -547,5 +547,5 @@ void die(const char * str, struct pt_regs * regs, long err)
 	if (panic_on_oops)
 		panic("Fatal exception");
 
-	do_exit(err);
+	make_task_dead(err);
 }
diff --git a/include/linux/sched/task.h b/include/linux/sched/task.h
index c3d157a370734..3ef0986cf0ea3 100644
--- a/include/linux/sched/task.h
+++ b/include/linux/sched/task.h
@@ -36,6 +36,7 @@ extern int sched_fork(unsigned long clone_flags, struct task_struct *p);
 extern void sched_dead(struct task_struct *p);
 
 void __noreturn do_task_dead(void);
+void __noreturn make_task_dead(int signr);
 
 extern void proc_caches_init(void);
 
diff --git a/kernel/exit.c b/kernel/exit.c
index 9e70577b818ab..1e778b88fa3fe 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -920,6 +920,15 @@ void __noreturn do_exit(long code)
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
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 2c8e2dae17016..9048b02b54474 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -159,6 +159,7 @@ static int __dead_end_function(struct objtool_file *file, struct symbol *func,
 		"panic",
 		"do_exit",
 		"do_task_dead",
+		"make_task_dead",
 		"__module_put_and_exit",
 		"complete_and_exit",
 		"kvm_spurious_fault",
@@ -166,7 +167,7 @@ static int __dead_end_function(struct objtool_file *file, struct symbol *func,
 		"lbug_with_loc",
 		"fortify_panic",
 		"machine_real_restart",
-		"rewind_stack_do_exit",
+		"rewind_stack_and_make_dead"
 	};
 
 	if (func->bind == STB_WEAK)
-- 
2.39.1

