Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85DF4687489
	for <lists+stable@lfdr.de>; Thu,  2 Feb 2023 05:44:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbjBBEoe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Feb 2023 23:44:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231542AbjBBEoO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Feb 2023 23:44:14 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8A0379F22;
        Wed,  1 Feb 2023 20:43:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CE5A6CE2773;
        Thu,  2 Feb 2023 04:43:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0084C433A0;
        Thu,  2 Feb 2023 04:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675313029;
        bh=15/R4vHRcJ4+mVME8lXm1dPwIUwCjOjTWOMBudOQmvQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eWQcJezlubbRS2Ni1NZgg3F9BLTuNYLbPzaSvY5XZuPLh/G7pqQQYoqnF1yX3DSvl
         fL5hc6s2X2BBg5NiyuAaKODDEFOzsLjPNNjFjmP7L9Znj3wEAeNHBbPLF4Wra7NDFf
         3GgteNgfdnlBIpuoS/ctnEK3eQ/jBA5SPKX5NmmHIv1zs2zSW4MGWU7TsfPG+dAOOc
         lyUhUhPbC8lA0afqIT8HVv3a7lztkVncKQHAi5rPT3/6U8EOPE7tkKrLVnLra3cKfP
         i/CtTxq4WZufrB4kkV2vC00NbduaA+YOw86XQBbZtAki99BesiGdKxR96OxCeXOufu
         STgkpWYXlwEtQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        Kees Cook <keescook@chromium.org>,
        SeongJae Park <sj@kernel.org>,
        Seth Jenkins <sethjenkins@google.com>,
        Jann Horn <jannh@google.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5.4 04/17] exit: Add and use make_task_dead.
Date:   Wed,  1 Feb 2023 20:42:42 -0800
Message-Id: <20230202044255.128815-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230202044255.128815-1-ebiggers@kernel.org>
References: <20230202044255.128815-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
 arch/csky/abiv1/alignment.c         | 2 +-
 arch/csky/kernel/traps.c            | 2 +-
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
 arch/nds32/kernel/fpu.c             | 2 +-
 arch/nds32/kernel/traps.c           | 8 ++++----
 arch/nios2/kernel/traps.c           | 4 ++--
 arch/openrisc/kernel/traps.c        | 2 +-
 arch/parisc/kernel/traps.c          | 2 +-
 arch/powerpc/kernel/traps.c         | 2 +-
 arch/riscv/kernel/traps.c           | 2 +-
 arch/riscv/mm/fault.c               | 2 +-
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
 38 files changed, 59 insertions(+), 52 deletions(-)

diff --git a/arch/alpha/kernel/traps.c b/arch/alpha/kernel/traps.c
index f6b9664ac5042..f87d8e1fcfe42 100644
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
@@ -577,7 +577,7 @@ do_entUna(void * va, unsigned long opcode, unsigned long reg,
 
 	printk("Bad unaligned kernel access at %016lx: %p %lx %lu\n",
 		pc, va, opcode, reg);
-	do_exit(SIGSEGV);
+	make_task_dead(SIGSEGV);
 
 got_exception:
 	/* Ok, we caught the exception, but we don't want it.  Is there
@@ -632,7 +632,7 @@ do_entUna(void * va, unsigned long opcode, unsigned long reg,
 		local_irq_enable();
 		while (1);
 	}
-	do_exit(SIGSEGV);
+	make_task_dead(SIGSEGV);
 }
 
 /*
diff --git a/arch/alpha/mm/fault.c b/arch/alpha/mm/fault.c
index 741e61ef9d3fe..a86286d2d3f3f 100644
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
index 207ef9a797bd4..03dfeb1208431 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -341,7 +341,7 @@ static void oops_end(unsigned long flags, struct pt_regs *regs, int signr)
 	if (panic_on_oops)
 		panic("Fatal exception");
 	if (signr)
-		do_exit(signr);
+		make_task_dead(signr);
 }
 
 /*
diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
index bd0f4821f7e11..d623932437208 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -124,7 +124,7 @@ __do_kernel_fault(struct mm_struct *mm, unsigned long addr, unsigned int fsr,
 	show_pte(KERN_ALERT, mm, addr);
 	die("Oops", regs, fsr);
 	bust_spinlocks(0);
-	do_exit(SIGKILL);
+	make_task_dead(SIGKILL);
 }
 
 /*
diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index 4e3e9d9c81517..a436a6972ced7 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -202,7 +202,7 @@ void die(const char *str, struct pt_regs *regs, int err)
 	raw_spin_unlock_irqrestore(&die_lock, flags);
 
 	if (ret != NOTIFY_STOP)
-		do_exit(SIGSEGV);
+		make_task_dead(SIGSEGV);
 }
 
 static void arm64_show_signal(int signo, const char *str)
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 2a7339aeb1ad4..a8e9c98147a19 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -296,7 +296,7 @@ static void die_kernel_fault(const char *msg, unsigned long addr,
 	show_pte(addr);
 	die("Oops", regs, esr);
 	bust_spinlocks(0);
-	do_exit(SIGKILL);
+	make_task_dead(SIGKILL);
 }
 
 static void __do_kernel_fault(unsigned long addr, unsigned int esr,
diff --git a/arch/csky/abiv1/alignment.c b/arch/csky/abiv1/alignment.c
index cb2a0d94a144d..5e2fb45d605cf 100644
--- a/arch/csky/abiv1/alignment.c
+++ b/arch/csky/abiv1/alignment.c
@@ -294,7 +294,7 @@ void csky_alignment(struct pt_regs *regs)
 				__func__, opcode, rz, rx, imm, addr);
 		show_regs(regs);
 		bust_spinlocks(0);
-		do_exit(SIGKILL);
+		make_dead_task(SIGKILL);
 	}
 
 	force_sig_fault(SIGBUS, BUS_ADRALN, (void __user *)addr);
diff --git a/arch/csky/kernel/traps.c b/arch/csky/kernel/traps.c
index 63715cb90ee99..af7562907f7fa 100644
--- a/arch/csky/kernel/traps.c
+++ b/arch/csky/kernel/traps.c
@@ -85,7 +85,7 @@ void die_if_kernel(char *str, struct pt_regs *regs, int nr)
 	pr_err("%s: %08x\n", str, nr);
 	show_regs(regs);
 	add_taint(TAINT_DIE, LOCKDEP_NOW_UNRELIABLE);
-	do_exit(SIGSEGV);
+	make_dead_task(SIGSEGV);
 }
 
 void buserr(struct pt_regs *regs)
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
index 69c623b14ddd2..bfd04a388bcac 100644
--- a/arch/hexagon/kernel/traps.c
+++ b/arch/hexagon/kernel/traps.c
@@ -221,7 +221,7 @@ int die(const char *str, struct pt_regs *regs, long err)
 		panic("Fatal exception");
 
 	oops_exit();
-	do_exit(err);
+	make_dead_task(err);
 	return 0;
 }
 
diff --git a/arch/ia64/kernel/mca_drv.c b/arch/ia64/kernel/mca_drv.c
index 2a40268c3d494..d9ee3b186249d 100644
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
index e13cb905930fb..753642366e12e 100644
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
index c2f299fe9e04a..7f8c49579a2c2 100644
--- a/arch/ia64/mm/fault.c
+++ b/arch/ia64/mm/fault.c
@@ -272,7 +272,7 @@ ia64_do_page_fault (unsigned long address, unsigned long isr, struct pt_regs *re
 		regs = NULL;
 	bust_spinlocks(0);
 	if (regs)
-		do_exit(SIGKILL);
+		make_task_dead(SIGKILL);
 	return;
 
   out_of_memory:
diff --git a/arch/m68k/kernel/traps.c b/arch/m68k/kernel/traps.c
index 344f93d36a9a0..a245c1933d418 100644
--- a/arch/m68k/kernel/traps.c
+++ b/arch/m68k/kernel/traps.c
@@ -1139,7 +1139,7 @@ void die_if_kernel (char *str, struct pt_regs *fp, int nr)
 	pr_crit("%s: %08x\n", str, nr);
 	show_registers(fp);
 	add_taint(TAINT_DIE, LOCKDEP_NOW_UNRELIABLE);
-	do_exit(SIGSEGV);
+	make_task_dead(SIGSEGV);
 }
 
 asmlinkage void set_esp0(unsigned long ssp)
diff --git a/arch/m68k/mm/fault.c b/arch/m68k/mm/fault.c
index e9b1d7585b43b..03ebb67b413ef 100644
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
diff --git a/arch/microblaze/kernel/exceptions.c b/arch/microblaze/kernel/exceptions.c
index cf99c411503e3..6d3a6a6442205 100644
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
index 749089c25d5e6..5a491eca456fc 100644
--- a/arch/mips/kernel/traps.c
+++ b/arch/mips/kernel/traps.c
@@ -415,7 +415,7 @@ void __noreturn die(const char *str, struct pt_regs *regs)
 	if (regs && kexec_should_crash(current))
 		crash_kexec(regs);
 
-	do_exit(sig);
+	make_task_dead(sig);
 }
 
 extern struct exception_table_entry __start___dbe_table[];
diff --git a/arch/nds32/kernel/fpu.c b/arch/nds32/kernel/fpu.c
index 62bdafbc53f4c..26c62d5a55c15 100644
--- a/arch/nds32/kernel/fpu.c
+++ b/arch/nds32/kernel/fpu.c
@@ -223,7 +223,7 @@ inline void handle_fpu_exception(struct pt_regs *regs)
 		}
 	} else if (fpcsr & FPCSR_mskRIT) {
 		if (!user_mode(regs))
-			do_exit(SIGILL);
+			make_task_dead(SIGILL);
 		si_signo = SIGILL;
 	}
 
diff --git a/arch/nds32/kernel/traps.c b/arch/nds32/kernel/traps.c
index f4d386b526227..f6648845aae76 100644
--- a/arch/nds32/kernel/traps.c
+++ b/arch/nds32/kernel/traps.c
@@ -184,7 +184,7 @@ void die(const char *str, struct pt_regs *regs, int err)
 
 	bust_spinlocks(0);
 	spin_unlock_irq(&die_lock);
-	do_exit(SIGSEGV);
+	make_task_dead(SIGSEGV);
 }
 
 EXPORT_SYMBOL(die);
@@ -288,7 +288,7 @@ void unhandled_interruption(struct pt_regs *regs)
 	pr_emerg("unhandled_interruption\n");
 	show_regs(regs);
 	if (!user_mode(regs))
-		do_exit(SIGKILL);
+		make_task_dead(SIGKILL);
 	force_sig(SIGKILL);
 }
 
@@ -299,7 +299,7 @@ void unhandled_exceptions(unsigned long entry, unsigned long addr,
 		 addr, type);
 	show_regs(regs);
 	if (!user_mode(regs))
-		do_exit(SIGKILL);
+		make_task_dead(SIGKILL);
 	force_sig(SIGKILL);
 }
 
@@ -326,7 +326,7 @@ void do_revinsn(struct pt_regs *regs)
 	pr_emerg("Reserved Instruction\n");
 	show_regs(regs);
 	if (!user_mode(regs))
-		do_exit(SIGILL);
+		make_task_dead(SIGILL);
 	force_sig(SIGILL);
 }
 
diff --git a/arch/nios2/kernel/traps.c b/arch/nios2/kernel/traps.c
index 486db793923c0..8e192d6564261 100644
--- a/arch/nios2/kernel/traps.c
+++ b/arch/nios2/kernel/traps.c
@@ -37,10 +37,10 @@ void die(const char *str, struct pt_regs *regs, long err)
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
index 932a8ec2b520e..2804852a55924 100644
--- a/arch/openrisc/kernel/traps.c
+++ b/arch/openrisc/kernel/traps.c
@@ -218,7 +218,7 @@ void die(const char *str, struct pt_regs *regs, long err)
 	__asm__ __volatile__("l.nop   1");
 	do {} while (1);
 #endif
-	do_exit(SIGSEGV);
+	make_task_dead(SIGSEGV);
 }
 
 /* This is normally the 'Oops' routine */
diff --git a/arch/parisc/kernel/traps.c b/arch/parisc/kernel/traps.c
index 2a1060d747a5d..37988f7f3abcb 100644
--- a/arch/parisc/kernel/traps.c
+++ b/arch/parisc/kernel/traps.c
@@ -268,7 +268,7 @@ void die_if_kernel(char *str, struct pt_regs *regs, long err)
 		panic("Fatal exception");
 
 	oops_exit();
-	do_exit(SIGSEGV);
+	make_task_dead(SIGSEGV);
 }
 
 /* gdb uses break 4,8 */
diff --git a/arch/powerpc/kernel/traps.c b/arch/powerpc/kernel/traps.c
index ecfa460f66d17..70b99246dec46 100644
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -246,7 +246,7 @@ static void oops_end(unsigned long flags, struct pt_regs *regs,
 
 	if (panic_on_oops)
 		panic("Fatal exception");
-	do_exit(signr);
+	make_task_dead(signr);
 }
 NOKPROBE_SYMBOL(oops_end);
 
diff --git a/arch/riscv/kernel/traps.c b/arch/riscv/kernel/traps.c
index ae462037910be..c28d4debf5926 100644
--- a/arch/riscv/kernel/traps.c
+++ b/arch/riscv/kernel/traps.c
@@ -57,7 +57,7 @@ void die(struct pt_regs *regs, const char *str)
 	if (panic_on_oops)
 		panic("Fatal exception");
 	if (ret != NOTIFY_STOP)
-		do_exit(SIGSEGV);
+		make_task_dead(SIGSEGV);
 }
 
 void do_trap(struct pt_regs *regs, int signo, int code, unsigned long addr)
diff --git a/arch/riscv/mm/fault.c b/arch/riscv/mm/fault.c
index 247b8c859c448..1cfce62caa119 100644
--- a/arch/riscv/mm/fault.c
+++ b/arch/riscv/mm/fault.c
@@ -189,7 +189,7 @@ asmlinkage void do_page_fault(struct pt_regs *regs)
 		(addr < PAGE_SIZE) ? "NULL pointer dereference" :
 		"paging request", addr);
 	die(regs, "Oops");
-	do_exit(SIGKILL);
+	make_task_dead(SIGKILL);
 
 	/*
 	 * We ran out of memory, call the OOM killer, and return the userspace
diff --git a/arch/s390/kernel/dumpstack.c b/arch/s390/kernel/dumpstack.c
index 34bdc60c0b11d..2100833adfb69 100644
--- a/arch/s390/kernel/dumpstack.c
+++ b/arch/s390/kernel/dumpstack.c
@@ -210,5 +210,5 @@ void die(struct pt_regs *regs, const char *str)
 	if (panic_on_oops)
 		panic("Fatal exception: panic_on_oops");
 	oops_exit();
-	do_exit(SIGSEGV);
+	make_task_dead(SIGSEGV);
 }
diff --git a/arch/s390/kernel/nmi.c b/arch/s390/kernel/nmi.c
index 0a487fae763ee..d8951274658bd 100644
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
diff --git a/arch/sh/kernel/traps.c b/arch/sh/kernel/traps.c
index 63cf17bc760da..6a228c00b73f4 100644
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
index 4ceecad556a9f..dbf068ac54ff3 100644
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
index f2b22c496fb97..17768680cbaeb 100644
--- a/arch/sparc/kernel/traps_64.c
+++ b/arch/sparc/kernel/traps_64.c
@@ -2564,9 +2564,7 @@ void __noreturn die_if_kernel(char *str, struct pt_regs *regs)
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
index 2d837fb54c31b..740df9cc21963 100644
--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -1659,13 +1659,13 @@ ENTRY(async_page_fault)
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
index c82136030d58f..bd7a4ad0937c4 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -1757,7 +1757,7 @@ ENTRY(ignore_sysret)
 END(ignore_sysret)
 #endif
 
-ENTRY(rewind_stack_do_exit)
+ENTRY(rewind_stack_and_make_dead)
 	UNWIND_HINT_FUNC
 	/* Prevent any naive code from trying to unwind to our caller. */
 	xorl	%ebp, %ebp
@@ -1766,5 +1766,5 @@ ENTRY(rewind_stack_do_exit)
 	leaq	-PTREGS_SIZE(%rax), %rsp
 	UNWIND_HINT_REGS
 
-	call	do_exit
-END(rewind_stack_do_exit)
+	call	make_task_dead
+END(rewind_stack_and_make_dead)
diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index e07424e19274b..e72042dc9487c 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -326,7 +326,7 @@ unsigned long oops_begin(void)
 }
 NOKPROBE_SYMBOL(oops_begin);
 
-void __noreturn rewind_stack_do_exit(int signr);
+void __noreturn rewind_stack_and_make_dead(int signr);
 
 void oops_end(unsigned long flags, struct pt_regs *regs, int signr)
 {
@@ -361,7 +361,7 @@ void oops_end(unsigned long flags, struct pt_regs *regs, int signr)
 	 * reuse the task stack and that existing poisons are invalid.
 	 */
 	kasan_unpoison_task_stack(current);
-	rewind_stack_do_exit(signr);
+	rewind_stack_and_make_dead(signr);
 }
 NOKPROBE_SYMBOL(oops_end);
 
diff --git a/arch/xtensa/kernel/traps.c b/arch/xtensa/kernel/traps.c
index 4a6c495ce9b6d..16af8e514cb3b 100644
--- a/arch/xtensa/kernel/traps.c
+++ b/arch/xtensa/kernel/traps.c
@@ -543,5 +543,5 @@ void die(const char * str, struct pt_regs * regs, long err)
 	if (panic_on_oops)
 		panic("Fatal exception");
 
-	do_exit(err);
+	make_task_dead(err);
 }
diff --git a/include/linux/sched/task.h b/include/linux/sched/task.h
index 36f3011ab6013..6f33a07858cf6 100644
--- a/include/linux/sched/task.h
+++ b/include/linux/sched/task.h
@@ -51,6 +51,7 @@ extern int sched_fork(unsigned long clone_flags, struct task_struct *p);
 extern void sched_dead(struct task_struct *p);
 
 void __noreturn do_task_dead(void);
+void __noreturn make_task_dead(int signr);
 
 extern void proc_caches_init(void);
 
diff --git a/kernel/exit.c b/kernel/exit.c
index ece64771a31f5..6512d82b4d9b0 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -864,6 +864,15 @@ void __noreturn do_exit(long code)
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
index ccf5580442d29..14be7d261ae7a 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -136,6 +136,7 @@ static bool __dead_end_function(struct objtool_file *file, struct symbol *func,
 		"panic",
 		"do_exit",
 		"do_task_dead",
+		"make_task_dead",
 		"__module_put_and_exit",
 		"complete_and_exit",
 		"__reiserfs_panic",
@@ -143,7 +144,7 @@ static bool __dead_end_function(struct objtool_file *file, struct symbol *func,
 		"fortify_panic",
 		"usercopy_abort",
 		"machine_real_restart",
-		"rewind_stack_do_exit",
+		"rewind_stack_and_make_dead"
 		"cpu_bringup_and_idle",
 	};
 
-- 
2.39.1

