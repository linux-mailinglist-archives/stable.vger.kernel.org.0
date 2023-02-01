Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 987FD6812F3
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:26:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236053AbjA3O0r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:26:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237071AbjA3O02 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:26:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4381E402F2
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:25:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E8316114B
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:24:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B17AC433EF;
        Mon, 30 Jan 2023 14:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088686;
        bh=U4utVWRv59GQvFJtxXQLANEyTsUkJER54GxG4WJWypY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zPT8+r1cahuEfShKr1hJb98aSwijdjx+/UEFi9E5Tn0sdG4JVr6QO3lBt57NPZ2uF
         DTygIBQedgNhcLnCg6nK7NC+mRKo3jFNhgKle1Ik/oxNiD3dfx/TFFgt4L7Dgm1EnJ
         lq6jje1SbR35tsCe4fEecFqZV2Qefat+vPvyFX40=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Eric Biggers <ebiggers@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 084/143] exit: Add and use make_task_dead.
Date:   Mon, 30 Jan 2023 14:52:21 +0100
Message-Id: <20230130134310.372430950@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134306.862721518@linuxfoundation.org>
References: <20230130134306.862721518@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
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
index 921d4b6e4d95..8b0f81a58b94 100644
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
index 09172f017efc..5d42f94887da 100644
--- a/arch/alpha/mm/fault.c
+++ b/arch/alpha/mm/fault.c
@@ -204,7 +204,7 @@ do_page_fault(unsigned long address, unsigned long mmcsr,
 	printk(KERN_ALERT "Unable to handle kernel paging request at "
 	       "virtual address %016lx\n", address);
 	die_if_kernel("Oops", regs, cause, (unsigned long*)regs - 16);
-	do_exit(SIGKILL);
+	make_task_dead(SIGKILL);
 
 	/* We ran out of memory, or some other thing happened to us that
 	   made us unable to handle the page fault gracefully.  */
diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index a531afad87fd..7878c33e188d 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -348,7 +348,7 @@ static void oops_end(unsigned long flags, struct pt_regs *regs, int signr)
 	if (panic_on_oops)
 		panic("Fatal exception");
 	if (signr)
-		do_exit(signr);
+		make_task_dead(signr);
 }
 
 /*
diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
index efa402025031..af5177801fb1 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -125,7 +125,7 @@ __do_kernel_fault(struct mm_struct *mm, unsigned long addr, unsigned int fsr,
 	show_pte(KERN_ALERT, mm, addr);
 	die("Oops", regs, fsr);
 	bust_spinlocks(0);
-	do_exit(SIGKILL);
+	make_task_dead(SIGKILL);
 }
 
 /*
diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index 2059d8f43f55..2cdd53425509 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -144,7 +144,7 @@ void die(const char *str, struct pt_regs *regs, int err)
 	raw_spin_unlock_irqrestore(&die_lock, flags);
 
 	if (ret != NOTIFY_STOP)
-		do_exit(SIGSEGV);
+		make_task_dead(SIGSEGV);
 }
 
 static void arm64_show_signal(int signo, const char *str)
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 795d224f184f..2be856731e81 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -293,7 +293,7 @@ static void die_kernel_fault(const char *msg, unsigned long addr,
 	show_pte(addr);
 	die("Oops", regs, esr);
 	bust_spinlocks(0);
-	do_exit(SIGKILL);
+	make_task_dead(SIGKILL);
 }
 
 static void __do_kernel_fault(unsigned long addr, unsigned int esr,
diff --git a/arch/csky/abiv1/alignment.c b/arch/csky/abiv1/alignment.c
index cb2a0d94a144..5e2fb45d605c 100644
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
index 22721468a04b..3c648305f2c3 100644
--- a/arch/csky/kernel/traps.c
+++ b/arch/csky/kernel/traps.c
@@ -111,7 +111,7 @@ void die(struct pt_regs *regs, const char *str)
 	if (panic_on_oops)
 		panic("Fatal exception");
 	if (ret != NOTIFY_STOP)
-		do_exit(SIGSEGV);
+		make_dead_task(SIGSEGV);
 }
 
 void do_trap(struct pt_regs *regs, int signo, int code, unsigned long addr)
diff --git a/arch/h8300/kernel/traps.c b/arch/h8300/kernel/traps.c
index 5d8b969cd8f3..2b1366c958e3 100644
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
index d4bc9c16f2df..0223528565dd 100644
--- a/arch/h8300/mm/fault.c
+++ b/arch/h8300/mm/fault.c
@@ -51,7 +51,7 @@ asmlinkage int do_page_fault(struct pt_regs *regs, unsigned long address,
 	printk(" at virtual address %08lx\n", address);
 	if (!user_mode(regs))
 		die("Oops", regs, error_code);
-	do_exit(SIGKILL);
+	make_dead_task(SIGKILL);
 
 	return 1;
 }
diff --git a/arch/hexagon/kernel/traps.c b/arch/hexagon/kernel/traps.c
index 904134b37232..25e8bdbfd685 100644
--- a/arch/hexagon/kernel/traps.c
+++ b/arch/hexagon/kernel/traps.c
@@ -218,7 +218,7 @@ int die(const char *str, struct pt_regs *regs, long err)
 		panic("Fatal exception");
 
 	oops_exit();
-	do_exit(err);
+	make_dead_task(err);
 	return 0;
 }
 
diff --git a/arch/ia64/kernel/mca_drv.c b/arch/ia64/kernel/mca_drv.c
index 2a40268c3d49..d9ee3b186249 100644
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
index e13cb905930f..753642366e12 100644
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
index cd9766d2b6e0..829198180ca6 100644
--- a/arch/ia64/mm/fault.c
+++ b/arch/ia64/mm/fault.c
@@ -274,7 +274,7 @@ ia64_do_page_fault (unsigned long address, unsigned long isr, struct pt_regs *re
 		regs = NULL;
 	bust_spinlocks(0);
 	if (regs)
-		do_exit(SIGKILL);
+		make_task_dead(SIGKILL);
 	return;
 
   out_of_memory:
diff --git a/arch/m68k/kernel/traps.c b/arch/m68k/kernel/traps.c
index 9e1261462bcc..b2a31afb998c 100644
--- a/arch/m68k/kernel/traps.c
+++ b/arch/m68k/kernel/traps.c
@@ -1136,7 +1136,7 @@ void die_if_kernel (char *str, struct pt_regs *fp, int nr)
 	pr_crit("%s: %08x\n", str, nr);
 	show_registers(fp);
 	add_taint(TAINT_DIE, LOCKDEP_NOW_UNRELIABLE);
-	do_exit(SIGSEGV);
+	make_task_dead(SIGSEGV);
 }
 
 asmlinkage void set_esp0(unsigned long ssp)
diff --git a/arch/m68k/mm/fault.c b/arch/m68k/mm/fault.c
index ef46e77e97a5..fcb3a0d8421c 100644
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
index cf99c411503e..6d3a6a644220 100644
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
index b1fe4518bd22..ebd0101f0958 100644
--- a/arch/mips/kernel/traps.c
+++ b/arch/mips/kernel/traps.c
@@ -413,7 +413,7 @@ void __noreturn die(const char *str, struct pt_regs *regs)
 	if (regs && kexec_should_crash(current))
 		crash_kexec(regs);
 
-	do_exit(sig);
+	make_task_dead(sig);
 }
 
 extern struct exception_table_entry __start___dbe_table[];
diff --git a/arch/nds32/kernel/fpu.c b/arch/nds32/kernel/fpu.c
index 9edd7ed7d7bf..701c09a668de 100644
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
index 6a9772ba7392..12cdd6549360 100644
--- a/arch/nds32/kernel/traps.c
+++ b/arch/nds32/kernel/traps.c
@@ -185,7 +185,7 @@ void die(const char *str, struct pt_regs *regs, int err)
 
 	bust_spinlocks(0);
 	spin_unlock_irq(&die_lock);
-	do_exit(SIGSEGV);
+	make_task_dead(SIGSEGV);
 }
 
 EXPORT_SYMBOL(die);
@@ -289,7 +289,7 @@ void unhandled_interruption(struct pt_regs *regs)
 	pr_emerg("unhandled_interruption\n");
 	show_regs(regs);
 	if (!user_mode(regs))
-		do_exit(SIGKILL);
+		make_task_dead(SIGKILL);
 	force_sig(SIGKILL);
 }
 
@@ -300,7 +300,7 @@ void unhandled_exceptions(unsigned long entry, unsigned long addr,
 		 addr, type);
 	show_regs(regs);
 	if (!user_mode(regs))
-		do_exit(SIGKILL);
+		make_task_dead(SIGKILL);
 	force_sig(SIGKILL);
 }
 
@@ -327,7 +327,7 @@ void do_revinsn(struct pt_regs *regs)
 	pr_emerg("Reserved Instruction\n");
 	show_regs(regs);
 	if (!user_mode(regs))
-		do_exit(SIGILL);
+		make_task_dead(SIGILL);
 	force_sig(SIGILL);
 }
 
diff --git a/arch/nios2/kernel/traps.c b/arch/nios2/kernel/traps.c
index b172da4eb1a9..86208178024f 100644
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
index 206e5325e61b..fca5317f3ce1 100644
--- a/arch/openrisc/kernel/traps.c
+++ b/arch/openrisc/kernel/traps.c
@@ -212,7 +212,7 @@ void die(const char *str, struct pt_regs *regs, long err)
 	__asm__ __volatile__("l.nop   1");
 	do {} while (1);
 #endif
-	do_exit(SIGSEGV);
+	make_task_dead(SIGSEGV);
 }
 
 /* This is normally the 'Oops' routine */
diff --git a/arch/parisc/kernel/traps.c b/arch/parisc/kernel/traps.c
index bce47e0fb692..2fad7867af10 100644
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
index 069d451240fa..5e5a2448ae79 100644
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -245,7 +245,7 @@ static void oops_end(unsigned long flags, struct pt_regs *regs,
 
 	if (panic_on_oops)
 		panic("Fatal exception");
-	do_exit(signr);
+	make_task_dead(signr);
 }
 NOKPROBE_SYMBOL(oops_end);
 
diff --git a/arch/riscv/kernel/traps.c b/arch/riscv/kernel/traps.c
index c1a13011fb8e..23fe03ca7ec7 100644
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
index 8f84bbe0ac33..54b12943cc7b 100644
--- a/arch/riscv/mm/fault.c
+++ b/arch/riscv/mm/fault.c
@@ -34,7 +34,7 @@ static inline void no_context(struct pt_regs *regs, unsigned long addr)
 		(addr < PAGE_SIZE) ? "NULL pointer dereference" :
 		"paging request", addr);
 	die(regs, "Oops");
-	do_exit(SIGKILL);
+	make_task_dead(SIGKILL);
 }
 
 static inline void mm_fault_error(struct pt_regs *regs, unsigned long addr, vm_fault_t fault)
diff --git a/arch/s390/kernel/dumpstack.c b/arch/s390/kernel/dumpstack.c
index 0dc4b258b98d..763e726025b3 100644
--- a/arch/s390/kernel/dumpstack.c
+++ b/arch/s390/kernel/dumpstack.c
@@ -214,5 +214,5 @@ void die(struct pt_regs *regs, const char *str)
 	if (panic_on_oops)
 		panic("Fatal exception: panic_on_oops");
 	oops_exit();
-	do_exit(SIGSEGV);
+	make_task_dead(SIGSEGV);
 }
diff --git a/arch/s390/kernel/nmi.c b/arch/s390/kernel/nmi.c
index 86c8d5370e7f..0102376eca3d 100644
--- a/arch/s390/kernel/nmi.c
+++ b/arch/s390/kernel/nmi.c
@@ -178,7 +178,7 @@ void s390_handle_mcck(void)
 		       "malfunction (code 0x%016lx).\n", mcck.mcck_code);
 		printk(KERN_EMERG "mcck: task: %s, pid: %d.\n",
 		       current->comm, current->pid);
-		do_exit(SIGSEGV);
+		make_task_dead(SIGSEGV);
 	}
 }
 EXPORT_SYMBOL_GPL(s390_handle_mcck);
diff --git a/arch/sh/kernel/traps.c b/arch/sh/kernel/traps.c
index 9c3d32b80038..4efffc18c851 100644
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
index 247a0d9683b2..5d47f4a34226 100644
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
index a850dccd78ea..814277d0e3e8 100644
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
index 8fcd6a42b3a1..70bd81b6c612 100644
--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -1333,14 +1333,14 @@ SYM_CODE_START(asm_exc_nmi)
 SYM_CODE_END(asm_exc_nmi)
 
 .pushsection .text, "ax"
-SYM_CODE_START(rewind_stack_do_exit)
+SYM_CODE_START(rewind_stack_and_make_dead)
 	/* Prevent any naive code from trying to unwind to our caller. */
 	xorl	%ebp, %ebp
 
 	movl	PER_CPU_VAR(cpu_current_top_of_stack), %esi
 	leal	-TOP_OF_KERNEL_STACK_PADDING-PTREGS_SIZE(%esi), %esp
 
-	call	do_exit
+	call	make_task_dead
 1:	jmp 1b
-SYM_CODE_END(rewind_stack_do_exit)
+SYM_CODE_END(rewind_stack_and_make_dead)
 .popsection
diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index 559c82b83475..23212c53cef7 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -1509,7 +1509,7 @@ SYM_CODE_END(ignore_sysret)
 #endif
 
 .pushsection .text, "ax"
-SYM_CODE_START(rewind_stack_do_exit)
+SYM_CODE_START(rewind_stack_and_make_dead)
 	UNWIND_HINT_FUNC
 	/* Prevent any naive code from trying to unwind to our caller. */
 	xorl	%ebp, %ebp
@@ -1518,6 +1518,6 @@ SYM_CODE_START(rewind_stack_do_exit)
 	leaq	-PTREGS_SIZE(%rax), %rsp
 	UNWIND_HINT_REGS
 
-	call	do_exit
-SYM_CODE_END(rewind_stack_do_exit)
+	call	make_task_dead
+SYM_CODE_END(rewind_stack_and_make_dead)
 .popsection
diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index 97aa900386cb..b4964300153a 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -351,7 +351,7 @@ unsigned long oops_begin(void)
 }
 NOKPROBE_SYMBOL(oops_begin);
 
-void __noreturn rewind_stack_do_exit(int signr);
+void __noreturn rewind_stack_and_make_dead(int signr);
 
 void oops_end(unsigned long flags, struct pt_regs *regs, int signr)
 {
@@ -386,7 +386,7 @@ void oops_end(unsigned long flags, struct pt_regs *regs, int signr)
 	 * reuse the task stack and that existing poisons are invalid.
 	 */
 	kasan_unpoison_task_stack(current);
-	rewind_stack_do_exit(signr);
+	rewind_stack_and_make_dead(signr);
 }
 NOKPROBE_SYMBOL(oops_end);
 
diff --git a/arch/xtensa/kernel/traps.c b/arch/xtensa/kernel/traps.c
index efc3a29cde80..129f23c0ab55 100644
--- a/arch/xtensa/kernel/traps.c
+++ b/arch/xtensa/kernel/traps.c
@@ -545,5 +545,5 @@ void die(const char * str, struct pt_regs * regs, long err)
 	if (panic_on_oops)
 		panic("Fatal exception");
 
-	do_exit(err);
+	make_task_dead(err);
 }
diff --git a/include/linux/sched/task.h b/include/linux/sched/task.h
index 4ce511437a8a..2832cc6be062 100644
--- a/include/linux/sched/task.h
+++ b/include/linux/sched/task.h
@@ -61,6 +61,7 @@ extern void sched_post_fork(struct task_struct *p,
 extern void sched_dead(struct task_struct *p);
 
 void __noreturn do_task_dead(void);
+void __noreturn make_task_dead(int signr);
 
 extern void proc_caches_init(void);
 
diff --git a/kernel/exit.c b/kernel/exit.c
index 8989e1d1f79b..8d7577940077 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -863,6 +863,15 @@ void __noreturn do_exit(long code)
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
index 700984e7f5ba..3c2baeb86c57 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -168,6 +168,7 @@ static bool __dead_end_function(struct objtool_file *file, struct symbol *func,
 		"panic",
 		"do_exit",
 		"do_task_dead",
+		"make_task_dead",
 		"__module_put_and_exit",
 		"complete_and_exit",
 		"__reiserfs_panic",
@@ -175,7 +176,7 @@ static bool __dead_end_function(struct objtool_file *file, struct symbol *func,
 		"fortify_panic",
 		"usercopy_abort",
 		"machine_real_restart",
-		"rewind_stack_do_exit",
+		"rewind_stack_and_make_dead"
 		"kunit_try_catch_throw",
 		"xen_start_kernel",
 		"cpu_bringup_and_idle",
-- 
2.39.0



