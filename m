Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4738B68B655
	for <lists+stable@lfdr.de>; Mon,  6 Feb 2023 08:26:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbjBFH0v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Feb 2023 02:26:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbjBFH0u (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Feb 2023 02:26:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0604F1C5B9;
        Sun,  5 Feb 2023 23:26:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 600ECB80B9D;
        Mon,  6 Feb 2023 07:26:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35A38C433D2;
        Mon,  6 Feb 2023 07:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675668401;
        bh=U1nZM1k+nLJ/c/IVHD29GtTEBkyDIiAArb7X5Kp5fyw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r0OaahNQhmy4LPkxHzpWWWUiwRNVT/MmjXyciLPKKrcWSHfsthfSyGunMklJUI2Lp
         wlQQX7XQ2ZIGp/qRxkkmU/8O28WIWrNzmlqanItZ59AJ71HdrKYqqKd/qU3AdOLi9X
         wbM4vfK6+qqpSqtmvhYx2qtpHQo2OW627CaS5o6s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.14.305
Date:   Mon,  6 Feb 2023 08:26:33 +0100
Message-Id: <167566839294186@kroah.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <16756683924720@kroah.com>
References: <16756683924720@kroah.com>
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

diff --git a/Documentation/ABI/testing/sysfs-kernel-oops_count b/Documentation/ABI/testing/sysfs-kernel-oops_count
new file mode 100644
index 000000000000..156cca9dbc96
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-kernel-oops_count
@@ -0,0 +1,6 @@
+What:		/sys/kernel/oops_count
+Date:		November 2022
+KernelVersion:	6.2.0
+Contact:	Linux Kernel Hardening List <linux-hardening@vger.kernel.org>
+Description:
+		Shows how many times the system has Oopsed since last boot.
diff --git a/Documentation/ABI/testing/sysfs-kernel-warn_count b/Documentation/ABI/testing/sysfs-kernel-warn_count
new file mode 100644
index 000000000000..90a029813717
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-kernel-warn_count
@@ -0,0 +1,6 @@
+What:		/sys/kernel/warn_count
+Date:		November 2022
+KernelVersion:	6.2.0
+Contact:	Linux Kernel Hardening List <linux-hardening@vger.kernel.org>
+Description:
+		Shows how many times the system has Warned since last boot.
diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index 37b612a17c46..fefffc8e6ac5 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -48,6 +48,7 @@ show up in /proc/sys/kernel:
 - msgmnb
 - msgmni
 - nmi_watchdog
+- oops_limit
 - osrelease
 - ostype
 - overflowgid
@@ -93,6 +94,7 @@ show up in /proc/sys/kernel:
 - threads-max
 - unprivileged_bpf_disabled
 - unknown_nmi_panic
+- warn_limit
 - watchdog
 - watchdog_thresh
 - version
@@ -515,6 +517,15 @@ scanned for a given scan.
 
 ==============================================================
 
+oops_limit:
+
+Number of kernel oopses after which the kernel should panic when
+``panic_on_oops`` is not set. Setting this to 0 disables checking
+the count. Setting this to  1 has the same effect as setting
+``panic_on_oops=1``. The default value is 10000.
+
+==============================================================
+
 osrelease, ostype & version:
 
 # cat osrelease
@@ -1062,6 +1073,15 @@ example.  If a system hangs up, try pressing the NMI switch.
 
 ==============================================================
 
+warn_limit:
+
+Number of kernel warnings after which the kernel should panic when
+``panic_on_warn`` is not set. Setting this to 0 disables checking
+the warning count. Setting this to 1 has the same effect as setting
+``panic_on_warn=1``. The default value is 0.
+
+==============================================================
+
 watchdog:
 
 This parameter can be used to disable or enable the soft lockup detector
diff --git a/Makefile b/Makefile
index 6a2a71d3051b..9722d1518655 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 14
-SUBLEVEL = 304
+SUBLEVEL = 305
 EXTRAVERSION =
 NAME = Petit Gorille
 
diff --git a/arch/alpha/kernel/traps.c b/arch/alpha/kernel/traps.c
index f43bd05dede2..6a45f392c672 100644
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
index e9392302c5da..a85c1b18d0bc 100644
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
diff --git a/arch/arm/boot/dts/imx6qdl-gw560x.dtsi b/arch/arm/boot/dts/imx6qdl-gw560x.dtsi
index d894dde6e85d..b2fc09fec2be 100644
--- a/arch/arm/boot/dts/imx6qdl-gw560x.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-gw560x.dtsi
@@ -462,7 +462,6 @@
 &uart1 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_uart1>;
-	uart-has-rtscts;
 	rts-gpios = <&gpio7 1 GPIO_ACTIVE_HIGH>;
 	status = "okay";
 };
diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index 7d81d4a1f5a9..df7a92c5df6c 100644
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
index 9bb446cc135d..45e73596b524 100644
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
diff --git a/arch/arm/mm/nommu.c b/arch/arm/mm/nommu.c
index d58dd8af2cf0..05659be8751a 100644
--- a/arch/arm/mm/nommu.c
+++ b/arch/arm/mm/nommu.c
@@ -379,7 +379,7 @@ void __init paging_init(const struct machine_desc *mdesc)
 	mpu_setup();
 
 	/* allocate the zero page. */
-	zero_page = memblock_alloc(PAGE_SIZE, PAGE_SIZE);
+	zero_page = (void *)memblock_alloc(PAGE_SIZE, PAGE_SIZE);
 	if (!zero_page)
 		panic("%s: Failed to allocate %lu bytes align=0x%lx\n",
 		      __func__, PAGE_SIZE, PAGE_SIZE);
diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index b30d23431fe1..ee19e6463e5a 100644
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
index 617787e4081f..d191b046d4c1 100644
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
index e47a9e0dc278..090adaee4b84 100644
--- a/arch/h8300/kernel/traps.c
+++ b/arch/h8300/kernel/traps.c
@@ -17,6 +17,7 @@
 #include <linux/types.h>
 #include <linux/sched.h>
 #include <linux/sched/debug.h>
+#include <linux/sched/task.h>
 #include <linux/mm_types.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
@@ -110,7 +111,7 @@ void die(const char *str, struct pt_regs *fp, unsigned long err)
 	dump(fp);
 
 	spin_unlock_irq(&die_lock);
-	do_exit(SIGSEGV);
+	make_task_dead(SIGSEGV);
 }
 
 static int kstack_depth_to_print = 24;
diff --git a/arch/h8300/mm/fault.c b/arch/h8300/mm/fault.c
index fabffb83930a..573825c3cb70 100644
--- a/arch/h8300/mm/fault.c
+++ b/arch/h8300/mm/fault.c
@@ -52,7 +52,7 @@ asmlinkage int do_page_fault(struct pt_regs *regs, unsigned long address,
 	printk(" at virtual address %08lx\n", address);
 	if (!user_mode(regs))
 		die("Oops", regs, error_code);
-	do_exit(SIGKILL);
+	make_task_dead(SIGKILL);
 
 	return 1;
 }
diff --git a/arch/hexagon/kernel/traps.c b/arch/hexagon/kernel/traps.c
index 2942a9204a9a..65330343bdc3 100644
--- a/arch/hexagon/kernel/traps.c
+++ b/arch/hexagon/kernel/traps.c
@@ -234,7 +234,7 @@ int die(const char *str, struct pt_regs *regs, long err)
 		panic("Fatal exception");
 
 	oops_exit();
-	do_exit(err);
+	make_task_dead(err);
 	return 0;
 }
 
diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 1efc444f5fa1..f8dac6bd17dd 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -461,7 +461,7 @@ config ARCH_PROC_KCORE_TEXT
 	depends on PROC_KCORE
 
 config IA64_MCA_RECOVERY
-	tristate "MCA recovery from errors other than TLB."
+	bool "MCA recovery from errors other than TLB."
 
 config PERFMON
 	bool "Performance monitor support"
diff --git a/arch/ia64/kernel/mca_drv.c b/arch/ia64/kernel/mca_drv.c
index 3503d488e9b3..c16a5e36872c 100644
--- a/arch/ia64/kernel/mca_drv.c
+++ b/arch/ia64/kernel/mca_drv.c
@@ -11,6 +11,7 @@
 #include <linux/types.h>
 #include <linux/init.h>
 #include <linux/sched.h>
+#include <linux/sched/task.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/kallsyms.h>
@@ -176,7 +177,7 @@ mca_handler_bh(unsigned long paddr, void *iip, unsigned long ipsr)
 	spin_unlock(&mca_bh_lock);
 
 	/* This process is about to be killed itself */
-	do_exit(SIGKILL);
+	make_task_dead(SIGKILL);
 }
 
 /**
diff --git a/arch/ia64/kernel/traps.c b/arch/ia64/kernel/traps.c
index 6d4e76a4267f..2bab65c10d23 100644
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
index dfdc152d6737..23f23e051ee2 100644
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
index c1cc4e99aa94..5c72deb117a8 100644
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
index 127d7c1f2090..4ef6057592f1 100644
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
index e6f338d0496b..3066d7fe484b 100644
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
index abbc64788008..a8f166ff2762 100644
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
index 8184e7d6b385..5dadd36d13ce 100644
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
index 0d44e8007ad6..a8fb061f1c88 100644
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
index 346456c43aa0..36582e23f9b9 100644
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
index 05c1aabad01c..a507a6874d42 100644
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
index 2aa545dca4d5..d9513a9f0db1 100644
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
index 31d03a84126c..5dca748d3815 100644
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
index 8b49cced663d..5fafbef7849b 100644
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
index b1ed763e4787..fb0576f3b1de 100644
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
index 6ab9b87dbca8..cfc06eeeb4f3 100644
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
index dbcea4281c30..1fdedb2eaef3 100644
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
index 637a23d404e9..1804ccf52d9b 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -1669,10 +1669,10 @@ END(nmi)
 ENTRY(ignore_sysret)
 	UNWIND_HINT_EMPTY
 	mov	$-ENOSYS, %eax
-	sysret
+	sysretl
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
index 224de37821e4..92585a755410 100644
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
 
diff --git a/arch/x86/kernel/i8259.c b/arch/x86/kernel/i8259.c
index f7833ae4e3f1..c359b8265ad4 100644
--- a/arch/x86/kernel/i8259.c
+++ b/arch/x86/kernel/i8259.c
@@ -114,6 +114,7 @@ static void make_8259A_irq(unsigned int irq)
 	disable_irq_nosync(irq);
 	io_apic_irqs &= ~(1<<irq);
 	irq_set_chip_and_handler(irq, &i8259A_chip, handle_level_irq);
+	irq_set_status_flags(irq, IRQ_LEVEL);
 	enable_irq(irq);
 }
 
diff --git a/arch/x86/kernel/irqinit.c b/arch/x86/kernel/irqinit.c
index 40f83d0d7b8a..7913b157d1d0 100644
--- a/arch/x86/kernel/irqinit.c
+++ b/arch/x86/kernel/irqinit.c
@@ -67,8 +67,10 @@ void __init init_ISA_irqs(void)
 #endif
 	legacy_pic->init(0);
 
-	for (i = 0; i < nr_legacy_irqs(); i++)
+	for (i = 0; i < nr_legacy_irqs(); i++) {
 		irq_set_chip_and_handler(i, chip, handle_level_irq);
+		irq_set_status_flags(i, IRQ_LEVEL);
+	}
 }
 
 void __init init_IRQ(void)
diff --git a/arch/x86/lib/iomap_copy_64.S b/arch/x86/lib/iomap_copy_64.S
index 33147fef3452..f1024b51cfee 100644
--- a/arch/x86/lib/iomap_copy_64.S
+++ b/arch/x86/lib/iomap_copy_64.S
@@ -22,6 +22,6 @@
  */
 ENTRY(__iowrite32_copy)
 	movl %edx,%ecx
-	rep movsd
+	rep movsl
 	ret
 ENDPROC(__iowrite32_copy)
diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index 03706331f567..8ecc38110bcc 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -516,7 +516,7 @@ static void __init xen_time_init(void)
 		pvclock_gtod_register_notifier(&xen_pvclock_gtod_notifier);
 }
 
-void __ref xen_init_time_ops(void)
+void __init xen_init_time_ops(void)
 {
 	xen_sched_clock_offset = xen_clocksource_read();
 	pv_time_ops = xen_time_ops;
diff --git a/arch/xtensa/kernel/traps.c b/arch/xtensa/kernel/traps.c
index 2986bc88a18e..09ba7436d1bd 100644
--- a/arch/xtensa/kernel/traps.c
+++ b/arch/xtensa/kernel/traps.c
@@ -547,5 +547,5 @@ void die(const char * str, struct pt_regs * regs, long err)
 	if (panic_on_oops)
 		panic("Fatal exception");
 
-	do_exit(err);
+	make_task_dead(err);
 }
diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index faaaf10311ec..ef93045d7d7f 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -225,7 +225,8 @@ static int dma_chan_get(struct dma_chan *chan)
 	/* The channel is already in use, update client count */
 	if (chan->client_count) {
 		__module_get(owner);
-		goto out;
+		chan->client_count++;
+		return 0;
 	}
 
 	if (!try_module_get(owner))
@@ -238,11 +239,11 @@ static int dma_chan_get(struct dma_chan *chan)
 			goto err_out;
 	}
 
+	chan->client_count++;
+
 	if (!dma_has_cap(DMA_PRIVATE, chan->device->cap_mask))
 		balance_ref_count(chan);
 
-out:
-	chan->client_count++;
 	return 0;
 
 err_out:
diff --git a/drivers/edac/edac_device.c b/drivers/edac/edac_device.c
index 93d6e6319b3c..0ac6c49ecdbf 100644
--- a/drivers/edac/edac_device.c
+++ b/drivers/edac/edac_device.c
@@ -34,6 +34,9 @@
 static DEFINE_MUTEX(device_ctls_mutex);
 static LIST_HEAD(edac_device_list);
 
+/* Default workqueue processing interval on this instance, in msecs */
+#define DEFAULT_POLL_INTERVAL 1000
+
 #ifdef CONFIG_EDAC_DEBUG
 static void edac_device_dump_device(struct edac_device_ctl_info *edac_dev)
 {
@@ -366,7 +369,7 @@ static void edac_device_workq_function(struct work_struct *work_req)
 	 * whole one second to save timers firing all over the period
 	 * between integral seconds
 	 */
-	if (edac_dev->poll_msec == 1000)
+	if (edac_dev->poll_msec == DEFAULT_POLL_INTERVAL)
 		edac_queue_work(&edac_dev->work, round_jiffies_relative(edac_dev->delay));
 	else
 		edac_queue_work(&edac_dev->work, edac_dev->delay);
@@ -396,7 +399,7 @@ static void edac_device_workq_setup(struct edac_device_ctl_info *edac_dev,
 	 * timers firing on sub-second basis, while they are happy
 	 * to fire together on the 1 second exactly
 	 */
-	if (edac_dev->poll_msec == 1000)
+	if (edac_dev->poll_msec == DEFAULT_POLL_INTERVAL)
 		edac_queue_work(&edac_dev->work, round_jiffies_relative(edac_dev->delay));
 	else
 		edac_queue_work(&edac_dev->work, edac_dev->delay);
@@ -430,7 +433,7 @@ void edac_device_reset_delay_period(struct edac_device_ctl_info *edac_dev,
 	edac_dev->delay	    = msecs_to_jiffies(msec);
 
 	/* See comment in edac_device_workq_setup() above */
-	if (edac_dev->poll_msec == 1000)
+	if (edac_dev->poll_msec == DEFAULT_POLL_INTERVAL)
 		edac_mod_work(&edac_dev->work, round_jiffies_relative(edac_dev->delay));
 	else
 		edac_mod_work(&edac_dev->work, edac_dev->delay);
@@ -472,11 +475,7 @@ int edac_device_add_device(struct edac_device_ctl_info *edac_dev)
 		/* This instance is NOW RUNNING */
 		edac_dev->op_state = OP_RUNNING_POLL;
 
-		/*
-		 * enable workq processing on this instance,
-		 * default = 1000 msec
-		 */
-		edac_device_workq_setup(edac_dev, 1000);
+		edac_device_workq_setup(edac_dev, edac_dev->poll_msec ?: DEFAULT_POLL_INTERVAL);
 	} else {
 		edac_dev->op_state = OP_RUNNING_INTERRUPT;
 	}
diff --git a/drivers/edac/highbank_mc_edac.c b/drivers/edac/highbank_mc_edac.c
index 6092e61be605..bcf41601a977 100644
--- a/drivers/edac/highbank_mc_edac.c
+++ b/drivers/edac/highbank_mc_edac.c
@@ -185,8 +185,10 @@ static int highbank_mc_probe(struct platform_device *pdev)
 	drvdata = mci->pvt_info;
 	platform_set_drvdata(pdev, mci);
 
-	if (!devres_open_group(&pdev->dev, NULL, GFP_KERNEL))
-		return -ENOMEM;
+	if (!devres_open_group(&pdev->dev, NULL, GFP_KERNEL)) {
+		res = -ENOMEM;
+		goto free;
+	}
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!r) {
@@ -254,6 +256,7 @@ static int highbank_mc_probe(struct platform_device *pdev)
 	edac_mc_del_mc(&pdev->dev);
 err:
 	devres_release_group(&pdev->dev, NULL);
+free:
 	edac_mc_free(mci);
 	return res;
 }
diff --git a/drivers/gpu/drm/radeon/atombios_dp.c b/drivers/gpu/drm/radeon/atombios_dp.c
index fd7682bf335d..3e798593e042 100644
--- a/drivers/gpu/drm/radeon/atombios_dp.c
+++ b/drivers/gpu/drm/radeon/atombios_dp.c
@@ -302,10 +302,10 @@ static int convert_bpc_to_bpp(int bpc)
 
 /***** radeon specific DP functions *****/
 
-int radeon_dp_get_dp_link_config(struct drm_connector *connector,
-				 const u8 dpcd[DP_DPCD_SIZE],
-				 unsigned pix_clock,
-				 unsigned *dp_lanes, unsigned *dp_rate)
+static int radeon_dp_get_dp_link_config(struct drm_connector *connector,
+					const u8 dpcd[DP_DPCD_SIZE],
+					unsigned pix_clock,
+					unsigned *dp_lanes, unsigned *dp_rate)
 {
 	int bpp = convert_bpc_to_bpp(radeon_get_monitor_bpc(connector));
 	static const unsigned link_rates[3] = { 162000, 270000, 540000 };
diff --git a/drivers/gpu/drm/radeon/radeon_mode.h b/drivers/gpu/drm/radeon/radeon_mode.h
index da44ac234f64..ca0a7ed28c9b 100644
--- a/drivers/gpu/drm/radeon/radeon_mode.h
+++ b/drivers/gpu/drm/radeon/radeon_mode.h
@@ -762,10 +762,6 @@ extern u8 radeon_dp_getsinktype(struct radeon_connector *radeon_connector);
 extern bool radeon_dp_getdpcd(struct radeon_connector *radeon_connector);
 extern int radeon_dp_get_panel_mode(struct drm_encoder *encoder,
 				    struct drm_connector *connector);
-extern int radeon_dp_get_dp_link_config(struct drm_connector *connector,
-					const u8 *dpcd,
-					unsigned pix_clock,
-					unsigned *dp_lanes, unsigned *dp_rate);
 extern void radeon_dp_set_rx_power_state(struct drm_connector *connector,
 					 u8 power_state);
 extern void radeon_dp_aux_init(struct radeon_connector *radeon_connector);
diff --git a/drivers/hid/hid-betopff.c b/drivers/hid/hid-betopff.c
index 9b60efe6ec44..ba386e5aa055 100644
--- a/drivers/hid/hid-betopff.c
+++ b/drivers/hid/hid-betopff.c
@@ -63,7 +63,6 @@ static int betopff_init(struct hid_device *hid)
 	struct list_head *report_list =
 			&hid->report_enum[HID_OUTPUT_REPORT].report_list;
 	struct input_dev *dev;
-	int field_count = 0;
 	int error;
 	int i, j;
 
@@ -89,19 +88,21 @@ static int betopff_init(struct hid_device *hid)
 	 * -----------------------------------------
 	 * Do init them with default value.
 	 */
+	if (report->maxfield < 4) {
+		hid_err(hid, "not enough fields in the report: %d\n",
+				report->maxfield);
+		return -ENODEV;
+	}
 	for (i = 0; i < report->maxfield; i++) {
+		if (report->field[i]->report_count < 1) {
+			hid_err(hid, "no values in the field\n");
+			return -ENODEV;
+		}
 		for (j = 0; j < report->field[i]->report_count; j++) {
 			report->field[i]->value[j] = 0x00;
-			field_count++;
 		}
 	}
 
-	if (field_count < 4) {
-		hid_err(hid, "not enough fields in the report: %d\n",
-				field_count);
-		return -ENODEV;
-	}
-
 	betopff = kzalloc(sizeof(*betopff), GFP_KERNEL);
 	if (!betopff)
 		return -ENOMEM;
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index a3debe38d2c7..ab78c1e6f37d 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -984,8 +984,8 @@ struct hid_report *hid_validate_values(struct hid_device *hid,
 		 * Validating on id 0 means we should examine the first
 		 * report in the list.
 		 */
-		report = list_entry(
-				hid->report_enum[type].report_list.next,
+		report = list_first_entry_or_null(
+				&hid->report_enum[type].report_list,
 				struct hid_report, list);
 	} else {
 		report = hid->report_enum[type].report_id_hash[id];
diff --git a/drivers/hid/intel-ish-hid/ishtp/dma-if.c b/drivers/hid/intel-ish-hid/ishtp/dma-if.c
index 2783f3666114..ff4419c8ed4f 100644
--- a/drivers/hid/intel-ish-hid/ishtp/dma-if.c
+++ b/drivers/hid/intel-ish-hid/ishtp/dma-if.c
@@ -113,6 +113,11 @@ void *ishtp_cl_get_dma_send_buf(struct ishtp_device *dev,
 	int required_slots = (size / DMA_SLOT_SIZE)
 		+ 1 * (size % DMA_SLOT_SIZE != 0);
 
+	if (!dev->ishtp_dma_tx_map) {
+		dev_err(dev->devc, "Fail to allocate Tx map\n");
+		return NULL;
+	}
+
 	spin_lock_irqsave(&dev->ishtp_dma_tx_lock, flags);
 	for (i = 0; i <= (dev->ishtp_dma_num_slots - required_slots); i++) {
 		free = 1;
@@ -159,6 +164,11 @@ void ishtp_cl_release_dma_acked_mem(struct ishtp_device *dev,
 		return;
 	}
 
+	if (!dev->ishtp_dma_tx_map) {
+		dev_err(dev->devc, "Fail to allocate Tx map\n");
+		return;
+	}
+
 	i = (msg_addr - dev->ishtp_host_dma_tx_buf) / DMA_SLOT_SIZE;
 	spin_lock_irqsave(&dev->ishtp_dma_tx_lock, flags);
 	for (j = 0; j < acked_slots; j++) {
diff --git a/drivers/infiniband/hw/hfi1/user_exp_rcv.c b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
index c6d085e1c10d..b17c1fc59f7e 100644
--- a/drivers/infiniband/hw/hfi1/user_exp_rcv.c
+++ b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
@@ -323,6 +323,8 @@ int hfi1_user_exp_rcv_setup(struct hfi1_filedata *fd,
 
 	if (!PAGE_ALIGNED(tinfo->vaddr))
 		return -EINVAL;
+	if (tinfo->length == 0)
+		return -EINVAL;
 
 	tidbuf = kzalloc(sizeof(*tidbuf), GFP_KERNEL);
 	if (!tidbuf)
@@ -347,16 +349,13 @@ int hfi1_user_exp_rcv_setup(struct hfi1_filedata *fd,
 	/* Find sets of physically contiguous pages */
 	tidbuf->n_psets = find_phys_blocks(tidbuf, pinned);
 
-	/*
-	 * We don't need to access this under a lock since tid_used is per
-	 * process and the same process cannot be in hfi1_user_exp_rcv_clear()
-	 * and hfi1_user_exp_rcv_setup() at the same time.
-	 */
+	/* Reserve the number of expected tids to be used. */
 	spin_lock(&fd->tid_lock);
 	if (fd->tid_used + tidbuf->n_psets > fd->tid_limit)
 		pageset_count = fd->tid_limit - fd->tid_used;
 	else
 		pageset_count = tidbuf->n_psets;
+	fd->tid_used += pageset_count;
 	spin_unlock(&fd->tid_lock);
 
 	if (!pageset_count)
@@ -466,10 +465,11 @@ int hfi1_user_exp_rcv_setup(struct hfi1_filedata *fd,
 nomem:
 	hfi1_cdbg(TID, "total mapped: tidpairs:%u pages:%u (%d)", tididx,
 		  mapped_pages, ret);
+	/* adjust reserved tid_used to actual count */
+	spin_lock(&fd->tid_lock);
+	fd->tid_used -= pageset_count - tididx;
+	spin_unlock(&fd->tid_lock);
 	if (tididx) {
-		spin_lock(&fd->tid_lock);
-		fd->tid_used += tididx;
-		spin_unlock(&fd->tid_lock);
 		tinfo->tidcnt = tididx;
 		tinfo->length = mapped_pages * PAGE_SIZE;
 
diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index 53bd449a5e49..0714d572e49a 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -192,7 +192,6 @@ static const char * const smbus_pnp_ids[] = {
 	"SYN3221", /* HP 15-ay000 */
 	"SYN323d", /* HP Spectre X360 13-w013dx */
 	"SYN3257", /* HP Envy 13-ad105ng */
-	"SYN3286", /* HP Laptop 15-da3001TU */
 	NULL
 };
 
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-dev.c b/drivers/net/ethernet/amd/xgbe/xgbe-dev.c
index 1e4bb33925e6..39d4df40700f 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-dev.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-dev.c
@@ -523,19 +523,28 @@ static void xgbe_disable_vxlan(struct xgbe_prv_data *pdata)
 	netif_dbg(pdata, drv, pdata->netdev, "VXLAN acceleration disabled\n");
 }
 
+static unsigned int xgbe_get_fc_queue_count(struct xgbe_prv_data *pdata)
+{
+	unsigned int max_q_count = XGMAC_MAX_FLOW_CONTROL_QUEUES;
+
+	/* From MAC ver 30H the TFCR is per priority, instead of per queue */
+	if (XGMAC_GET_BITS(pdata->hw_feat.version, MAC_VR, SNPSVER) >= 0x30)
+		return max_q_count;
+	else
+		return min_t(unsigned int, pdata->tx_q_count, max_q_count);
+}
+
 static int xgbe_disable_tx_flow_control(struct xgbe_prv_data *pdata)
 {
-	unsigned int max_q_count, q_count;
 	unsigned int reg, reg_val;
-	unsigned int i;
+	unsigned int i, q_count;
 
 	/* Clear MTL flow control */
 	for (i = 0; i < pdata->rx_q_count; i++)
 		XGMAC_MTL_IOWRITE_BITS(pdata, i, MTL_Q_RQOMR, EHFC, 0);
 
 	/* Clear MAC flow control */
-	max_q_count = XGMAC_MAX_FLOW_CONTROL_QUEUES;
-	q_count = min_t(unsigned int, pdata->tx_q_count, max_q_count);
+	q_count = xgbe_get_fc_queue_count(pdata);
 	reg = MAC_Q0TFCR;
 	for (i = 0; i < q_count; i++) {
 		reg_val = XGMAC_IOREAD(pdata, reg);
@@ -552,9 +561,8 @@ static int xgbe_enable_tx_flow_control(struct xgbe_prv_data *pdata)
 {
 	struct ieee_pfc *pfc = pdata->pfc;
 	struct ieee_ets *ets = pdata->ets;
-	unsigned int max_q_count, q_count;
 	unsigned int reg, reg_val;
-	unsigned int i;
+	unsigned int i, q_count;
 
 	/* Set MTL flow control */
 	for (i = 0; i < pdata->rx_q_count; i++) {
@@ -578,8 +586,7 @@ static int xgbe_enable_tx_flow_control(struct xgbe_prv_data *pdata)
 	}
 
 	/* Set MAC flow control */
-	max_q_count = XGMAC_MAX_FLOW_CONTROL_QUEUES;
-	q_count = min_t(unsigned int, pdata->tx_q_count, max_q_count);
+	q_count = xgbe_get_fc_queue_count(pdata);
 	reg = MAC_Q0TFCR;
 	for (i = 0; i < q_count; i++) {
 		reg_val = XGMAC_IOREAD(pdata, reg);
diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 3279a6e48f3b..e0eacfc46dd4 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -11158,7 +11158,7 @@ static void tg3_reset_task(struct work_struct *work)
 	rtnl_lock();
 	tg3_full_lock(tp, 0);
 
-	if (!netif_running(tp->dev)) {
+	if (tp->pcierr_recovery || !netif_running(tp->dev)) {
 		tg3_flag_clear(tp, RESET_TASK_PENDING);
 		tg3_full_unlock(tp);
 		rtnl_unlock();
@@ -18190,6 +18190,9 @@ static pci_ers_result_t tg3_io_error_detected(struct pci_dev *pdev,
 
 	netdev_info(netdev, "PCI I/O error detected\n");
 
+	/* Want to make sure that the reset task doesn't run */
+	tg3_reset_task_cancel(tp);
+
 	rtnl_lock();
 
 	/* Could be second call or maybe we don't have netdev yet */
@@ -18206,9 +18209,6 @@ static pci_ers_result_t tg3_io_error_detected(struct pci_dev *pdev,
 
 	tg3_timer_stop(tp);
 
-	/* Want to make sure that the reset task doesn't run */
-	tg3_reset_task_cancel(tp);
-
 	netif_device_detach(netdev);
 
 	/* Clean up software state, even if MMIO is blocked */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 049d9d19c66d..840ce070bddf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1615,7 +1615,7 @@ static void mlx5_core_verify_params(void)
 	}
 }
 
-static int __init init(void)
+static int __init mlx5_init(void)
 {
 	int err;
 
@@ -1637,7 +1637,7 @@ static int __init init(void)
 	return err;
 }
 
-static void __exit cleanup(void)
+static void __exit mlx5_cleanup(void)
 {
 #ifdef CONFIG_MLX5_CORE_EN
 	mlx5e_cleanup();
@@ -1646,5 +1646,5 @@ static void __exit cleanup(void)
 	mlx5_unregister_debugfs();
 }
 
-module_init(init);
-module_exit(cleanup);
+module_init(mlx5_init);
+module_exit(mlx5_cleanup);
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 4c8a4e6efb9f..4acea1ab6000 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -727,14 +727,14 @@ static void ravb_error_interrupt(struct net_device *ndev)
 	ravb_write(ndev, ~(EIS_QFS | EIS_RESERVED), EIS);
 	if (eis & EIS_QFS) {
 		ris2 = ravb_read(ndev, RIS2);
-		ravb_write(ndev, ~(RIS2_QFF0 | RIS2_RFFF | RIS2_RESERVED),
+		ravb_write(ndev, ~(RIS2_QFF0 | RIS2_QFF1 | RIS2_RFFF | RIS2_RESERVED),
 			   RIS2);
 
 		/* Receive Descriptor Empty int */
 		if (ris2 & RIS2_QFF0)
 			priv->stats[RAVB_BE].rx_over_errors++;
 
-		    /* Receive Descriptor Empty int */
+		/* Receive Descriptor Empty int */
 		if (ris2 & RIS2_QFF1)
 			priv->stats[RAVB_NC].rx_over_errors++;
 
diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 7a813449d0d1..a9a0638a9b7a 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -70,7 +70,12 @@ EXPORT_SYMBOL(mdiobus_unregister_device);
 
 struct phy_device *mdiobus_get_phy(struct mii_bus *bus, int addr)
 {
-	struct mdio_device *mdiodev = bus->mdio_map[addr];
+	struct mdio_device *mdiodev;
+
+	if (addr < 0 || addr >= ARRAY_SIZE(bus->mdio_map))
+		return NULL;
+
+	mdiodev = bus->mdio_map[addr];
 
 	if (!mdiodev)
 		return NULL;
diff --git a/drivers/net/usb/sr9700.c b/drivers/net/usb/sr9700.c
index a97dd62b9d54..dbdb027abe47 100644
--- a/drivers/net/usb/sr9700.c
+++ b/drivers/net/usb/sr9700.c
@@ -410,7 +410,7 @@ static int sr9700_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 		/* ignore the CRC length */
 		len = (skb->data[1] | (skb->data[2] << 8)) - 4;
 
-		if (len > ETH_FRAME_LEN || len > skb->len)
+		if (len > ETH_FRAME_LEN || len > skb->len || len < 0)
 			return 0;
 
 		/* the last packet of current skb */
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
index 6d868b8b441a..da9b94754b73 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
@@ -574,7 +574,7 @@ int brcmf_fw_map_chip_to_name(u32 chip, u32 chiprev,
 
 	if (chiprev >= BITS_PER_TYPE(u32)) {
 		brcmf_err("Invalid chip revision %u\n", chiprev);
-		return NULL;
+		return -EINVAL;
 	}
 
 	for (i = 0; i < table_size; i++) {
diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index d4947e3a909e..0376a2a74572 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -712,8 +712,8 @@ static int rndis_query_oid(struct usbnet *dev, u32 oid, void *data, int *len)
 		struct rndis_query	*get;
 		struct rndis_query_c	*get_c;
 	} u;
-	int ret, buflen;
-	int resplen, respoffs, copylen;
+	int ret;
+	size_t buflen, resplen, respoffs, copylen;
 
 	buflen = *len + sizeof(*u.get);
 	if (buflen < CONTROL_BUFFER_SIZE)
@@ -748,22 +748,15 @@ static int rndis_query_oid(struct usbnet *dev, u32 oid, void *data, int *len)
 
 		if (respoffs > buflen) {
 			/* Device returned data offset outside buffer, error. */
-			netdev_dbg(dev->net, "%s(%s): received invalid "
-				"data offset: %d > %d\n", __func__,
-				oid_to_string(oid), respoffs, buflen);
+			netdev_dbg(dev->net,
+				   "%s(%s): received invalid data offset: %zu > %zu\n",
+				   __func__, oid_to_string(oid), respoffs, buflen);
 
 			ret = -EINVAL;
 			goto exit_unlock;
 		}
 
-		if ((resplen + respoffs) > buflen) {
-			/* Device would have returned more data if buffer would
-			 * have been big enough. Copy just the bits that we got.
-			 */
-			copylen = buflen - respoffs;
-		} else {
-			copylen = resplen;
-		}
+		copylen = min(resplen, buflen - respoffs);
 
 		if (copylen > *len)
 			copylen = *len;
diff --git a/drivers/phy/rockchip/phy-rockchip-inno-usb2.c b/drivers/phy/rockchip/phy-rockchip-inno-usb2.c
index ee7ce5ee53f9..a088cb027657 100644
--- a/drivers/phy/rockchip/phy-rockchip-inno-usb2.c
+++ b/drivers/phy/rockchip/phy-rockchip-inno-usb2.c
@@ -477,8 +477,10 @@ static int rockchip_usb2phy_power_on(struct phy *phy)
 		return ret;
 
 	ret = property_enable(base, &rport->port_cfg->phy_sus, false);
-	if (ret)
+	if (ret) {
+		clk_disable_unprepare(rphy->clk480m);
 		return ret;
+	}
 
 	/* waiting for the utmi_clk to become stable */
 	usleep_range(1500, 2000);
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 6b25c5ce13ed..34434b7107ee 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -5627,7 +5627,7 @@ static int hpsa_scsi_host_alloc(struct ctlr_info *h)
 {
 	struct Scsi_Host *sh;
 
-	sh = scsi_host_alloc(&hpsa_driver_template, sizeof(h));
+	sh = scsi_host_alloc(&hpsa_driver_template, sizeof(struct ctlr_info));
 	if (sh == NULL) {
 		dev_err(&h->pdev->dev, "scsi_host_alloc failed\n");
 		return -ENOMEM;
diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 06063a841726..b50478fa14ad 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -924,9 +924,9 @@ qla2x00_process_loopback(struct bsg_job *bsg_job)
 
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply) +
 	    sizeof(response) + sizeof(uint8_t);
-	fw_sts_ptr = ((uint8_t *)scsi_req(bsg_job->req)->sense) +
-	    sizeof(struct fc_bsg_reply);
-	memcpy(fw_sts_ptr, response, sizeof(response));
+	fw_sts_ptr = bsg_job->reply + sizeof(struct fc_bsg_reply);
+	memcpy(bsg_job->reply + sizeof(struct fc_bsg_reply), response,
+			sizeof(response));
 	fw_sts_ptr += sizeof(response);
 	*fw_sts_ptr = command_sent;
 
@@ -2558,13 +2558,11 @@ qla24xx_bsg_timeout(struct bsg_job *bsg_job)
 						ql_log(ql_log_warn, vha, 0x7089,
 						    "mbx abort_command "
 						    "failed.\n");
-						scsi_req(bsg_job->req)->result =
 						bsg_reply->result = -EIO;
 					} else {
 						ql_dbg(ql_dbg_user, vha, 0x708a,
 						    "mbx abort_command "
 						    "success.\n");
-						scsi_req(bsg_job->req)->result =
 						bsg_reply->result = 0;
 					}
 					spin_lock_irqsave(&ha->hardware_lock, flags);
@@ -2575,7 +2573,7 @@ qla24xx_bsg_timeout(struct bsg_job *bsg_job)
 	}
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	ql_log(ql_log_info, vha, 0x708b, "SRB not found to abort.\n");
-	scsi_req(bsg_job->req)->result = bsg_reply->result = -ENXIO;
+	bsg_reply->result = -ENXIO;
 	return 0;
 
 done:
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index b39faf2bfa0d..b2056714804c 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1540,7 +1540,6 @@ qla24xx_els_ct_entry(scsi_qla_host_t *vha, struct req_que *req,
 	struct fc_bsg_reply *bsg_reply;
 	uint16_t comp_status;
 	uint32_t fw_status[3];
-	uint8_t* fw_sts_ptr;
 	int res;
 
 	sp = qla2x00_get_sp_from_handle(vha, func, req, pkt);
@@ -1601,11 +1600,7 @@ qla24xx_els_ct_entry(scsi_qla_host_t *vha, struct req_que *req,
 			    type, sp->handle, comp_status, fw_status[1], fw_status[2],
 			    le16_to_cpu(((struct els_sts_entry_24xx *)
 				pkt)->total_byte_count));
-			fw_sts_ptr = ((uint8_t*)scsi_req(bsg_job->req)->sense) +
-				sizeof(struct fc_bsg_reply);
-			memcpy( fw_sts_ptr, fw_status, sizeof(fw_status));
-		}
-		else {
+		} else {
 			ql_dbg(ql_dbg_user, vha, 0x5040,
 			    "ELS-CT pass-through-%s error hdl=%x comp_status-status=0x%x "
 			    "error subcode 1=0x%x error subcode 2=0x%x.\n",
@@ -1616,10 +1611,9 @@ qla24xx_els_ct_entry(scsi_qla_host_t *vha, struct req_que *req,
 				    pkt)->error_subcode_2));
 			res = DID_ERROR << 16;
 			bsg_reply->reply_payload_rcv_len = 0;
-			fw_sts_ptr = ((uint8_t*)scsi_req(bsg_job->req)->sense) +
-					sizeof(struct fc_bsg_reply);
-			memcpy( fw_sts_ptr, fw_status, sizeof(fw_status));
 		}
+		memcpy(bsg_job->reply + sizeof(struct fc_bsg_reply),
+		       fw_status, sizeof(fw_status));
 		ql_dump_buffer(ql_dbg_user + ql_dbg_buffer, vha, 0x5056,
 				(uint8_t *)pkt, sizeof(*pkt));
 	}
diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index 66ee20602661..a37c8eedcab2 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -2222,8 +2222,7 @@ qlafx00_ioctl_iosb_entry(scsi_qla_host_t *vha, struct req_que *req,
 		memcpy(fstatus.reserved_3,
 		    pkt->reserved_2, 20 * sizeof(uint8_t));
 
-		fw_sts_ptr = ((uint8_t *)scsi_req(bsg_job->req)->sense) +
-		    sizeof(struct fc_bsg_reply);
+		fw_sts_ptr = bsg_job->reply + sizeof(struct fc_bsg_reply);
 
 		memcpy(fw_sts_ptr, (uint8_t *)&fstatus,
 		    sizeof(struct qla_mt_iocb_rsp_fx00));
diff --git a/drivers/staging/comedi/drivers/adv_pci1760.c b/drivers/staging/comedi/drivers/adv_pci1760.c
index 9f525ff7290c..67b0cf0b9066 100644
--- a/drivers/staging/comedi/drivers/adv_pci1760.c
+++ b/drivers/staging/comedi/drivers/adv_pci1760.c
@@ -68,7 +68,7 @@
 #define PCI1760_CMD_CLR_IMB2		0x00	/* Clears IMB2 */
 #define PCI1760_CMD_SET_DO		0x01	/* Set output state */
 #define PCI1760_CMD_GET_DO		0x02	/* Read output status */
-#define PCI1760_CMD_GET_STATUS		0x03	/* Read current status */
+#define PCI1760_CMD_GET_STATUS		0x07	/* Read current status */
 #define PCI1760_CMD_GET_FW_VER		0x0e	/* Read firware version */
 #define PCI1760_CMD_GET_HW_VER		0x0f	/* Read hardware version */
 #define PCI1760_CMD_SET_PWM_HI(x)	(0x10 + (x) * 2) /* Set "hi" period */
diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 13a38ed806df..946cf039eddd 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -274,6 +274,9 @@ static int __ffs_ep0_queue_wait(struct ffs_data *ffs, char *data, size_t len)
 	struct usb_request *req = ffs->ep0req;
 	int ret;
 
+	if (!req)
+		return -EINVAL;
+
 	req->zero     = len < le16_to_cpu(ffs->ev.setup.wLength);
 
 	spin_unlock_irq(&ffs->ev.waitq.lock);
@@ -1797,10 +1800,14 @@ static void functionfs_unbind(struct ffs_data *ffs)
 	ENTER();
 
 	if (!WARN_ON(!ffs->gadget)) {
+		/* dequeue before freeing ep0req */
+		usb_ep_dequeue(ffs->gadget->ep0, ffs->ep0req);
+		mutex_lock(&ffs->mutex);
 		usb_ep_free_request(ffs->gadget->ep0, ffs->ep0req);
 		ffs->ep0req = NULL;
 		ffs->gadget = NULL;
 		clear_bit(FFS_FL_BOUND, &ffs->flags);
+		mutex_unlock(&ffs->mutex);
 		ffs_data_put(ffs);
 	}
 }
diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
index 2a73592908e1..3d20fe9c415f 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -252,7 +252,7 @@ static int xhci_plat_probe(struct platform_device *pdev)
 			*priv = *priv_match;
 	}
 
-	device_wakeup_enable(hcd->self.controller);
+	device_set_wakeup_capable(&pdev->dev, true);
 
 	xhci->clk = clk;
 	xhci->main_hcd = hcd;
diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index 6f9e9505b34c..4d43c373e5c6 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -1136,6 +1136,8 @@ int w1_process(void *data)
 	/* remainder if it woke up early */
 	unsigned long jremain = 0;
 
+	atomic_inc(&dev->refcnt);
+
 	for (;;) {
 
 		if (!jremain && dev->search_count) {
@@ -1163,8 +1165,10 @@ int w1_process(void *data)
 		 */
 		mutex_unlock(&dev->list_mutex);
 
-		if (kthread_should_stop())
+		if (kthread_should_stop()) {
+			__set_current_state(TASK_RUNNING);
 			break;
+		}
 
 		/* Only sleep when the search is active. */
 		if (dev->search_count) {
diff --git a/drivers/w1/w1_int.c b/drivers/w1/w1_int.c
index 1c776178f598..eb851eb44300 100644
--- a/drivers/w1/w1_int.c
+++ b/drivers/w1/w1_int.c
@@ -60,10 +60,9 @@ static struct w1_master *w1_alloc_dev(u32 id, int slave_count, int slave_ttl,
 	dev->search_count	= w1_search_count;
 	dev->enable_pullup	= w1_enable_pullup;
 
-	/* 1 for w1_process to decrement
-	 * 1 for __w1_remove_master_device to decrement
+	/* For __w1_remove_master_device to decrement
 	 */
-	atomic_set(&dev->refcnt, 2);
+	atomic_set(&dev->refcnt, 1);
 
 	INIT_LIST_HEAD(&dev->slist);
 	INIT_LIST_HEAD(&dev->async_list);
diff --git a/fs/affs/file.c b/fs/affs/file.c
index ba084b0b214b..82bb38370aa9 100644
--- a/fs/affs/file.c
+++ b/fs/affs/file.c
@@ -878,7 +878,7 @@ affs_truncate(struct inode *inode)
 	if (inode->i_size > AFFS_I(inode)->mmu_private) {
 		struct address_space *mapping = inode->i_mapping;
 		struct page *page;
-		void *fsdata;
+		void *fsdata = NULL;
 		loff_t isize = inode->i_size;
 		int res;
 
diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 12bac452738d..f4b46f796901 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -13,6 +13,7 @@
 #include <linux/namei.h>
 #include <linux/mm.h>
 #include <linux/module.h>
+#include <linux/kmemleak.h>
 #include "internal.h"
 
 static const struct dentry_operations proc_sys_dentry_operations;
@@ -1370,6 +1371,38 @@ struct ctl_table_header *register_sysctl(const char *path, struct ctl_table *tab
 }
 EXPORT_SYMBOL(register_sysctl);
 
+/**
+ * __register_sysctl_init() - register sysctl table to path
+ * @path: path name for sysctl base
+ * @table: This is the sysctl table that needs to be registered to the path
+ * @table_name: The name of sysctl table, only used for log printing when
+ *              registration fails
+ *
+ * The sysctl interface is used by userspace to query or modify at runtime
+ * a predefined value set on a variable. These variables however have default
+ * values pre-set. Code which depends on these variables will always work even
+ * if register_sysctl() fails. If register_sysctl() fails you'd just loose the
+ * ability to query or modify the sysctls dynamically at run time. Chances of
+ * register_sysctl() failing on init are extremely low, and so for both reasons
+ * this function does not return any error as it is used by initialization code.
+ *
+ * Context: Can only be called after your respective sysctl base path has been
+ * registered. So for instance, most base directories are registered early on
+ * init before init levels are processed through proc_sys_init() and
+ * sysctl_init().
+ */
+void __init __register_sysctl_init(const char *path, struct ctl_table *table,
+				 const char *table_name)
+{
+	struct ctl_table_header *hdr = register_sysctl(path, table);
+
+	if (unlikely(!hdr)) {
+		pr_err("failed when register_sysctl %s to %s\n", table_name, path);
+		return;
+	}
+	kmemleak_not_leak(hdr);
+}
+
 static char *append_path(const char *path, char *pos, const char *name)
 {
 	int namelen;
diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index 7dfdc503e601..6101ce8a47bd 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -1443,7 +1443,6 @@ static int reiserfs_remount(struct super_block *s, int *mount_flags, char *arg)
 	unsigned long safe_mask = 0;
 	unsigned int commit_max_age = (unsigned int)-1;
 	struct reiserfs_journal *journal = SB_JOURNAL(s);
-	char *new_opts;
 	int err;
 	char *qf_names[REISERFS_MAXQUOTAS];
 	unsigned int qfmt = 0;
@@ -1451,10 +1450,6 @@ static int reiserfs_remount(struct super_block *s, int *mount_flags, char *arg)
 	int i;
 #endif
 
-	new_opts = kstrdup(arg, GFP_KERNEL);
-	if (arg && !new_opts)
-		return -ENOMEM;
-
 	sync_filesystem(s);
 	reiserfs_write_lock(s);
 
@@ -1605,7 +1600,6 @@ static int reiserfs_remount(struct super_block *s, int *mount_flags, char *arg)
 out_err_unlock:
 	reiserfs_write_unlock(s);
 out_err:
-	kfree(new_opts);
 	return err;
 }
 
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 22b914665595..a4ac278d02d0 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -293,6 +293,7 @@ extern long (*panic_blink)(int state);
 __printf(1, 2)
 void panic(const char *fmt, ...) __noreturn __cold;
 void nmi_panic(struct pt_regs *regs, const char *msg);
+void check_panic_on_warn(const char *origin);
 extern void oops_enter(void);
 extern void oops_exit(void);
 void print_oops_end_marker(void);
diff --git a/include/linux/sched/task.h b/include/linux/sched/task.h
index c3d157a37073..3ef0986cf0ea 100644
--- a/include/linux/sched/task.h
+++ b/include/linux/sched/task.h
@@ -36,6 +36,7 @@ extern int sched_fork(unsigned long clone_flags, struct task_struct *p);
 extern void sched_dead(struct task_struct *p);
 
 void __noreturn do_task_dead(void);
+void __noreturn make_task_dead(int signr);
 
 extern void proc_caches_init(void);
 
diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index b769ecfcc3bd..0a980aecc8f0 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -198,6 +198,9 @@ struct ctl_table_header *register_sysctl_paths(const struct ctl_path *path,
 void unregister_sysctl_table(struct ctl_table_header * table);
 
 extern int sysctl_init(void);
+extern void __register_sysctl_init(const char *path, struct ctl_table *table,
+				 const char *table_name);
+#define register_sysctl_init(path, table) __register_sysctl_init(path, table, #table)
 
 extern struct ctl_table sysctl_mount_point[];
 
diff --git a/kernel/exit.c b/kernel/exit.c
index 9e70577b818a..c0ff4461643d 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -62,12 +62,59 @@
 #include <linux/random.h>
 #include <linux/rcuwait.h>
 #include <linux/compat.h>
+#include <linux/sysfs.h>
 
 #include <linux/uaccess.h>
 #include <asm/unistd.h>
 #include <asm/pgtable.h>
 #include <asm/mmu_context.h>
 
+/*
+ * The default value should be high enough to not crash a system that randomly
+ * crashes its kernel from time to time, but low enough to at least not permit
+ * overflowing 32-bit refcounts or the ldsem writer count.
+ */
+static unsigned int oops_limit = 10000;
+
+#ifdef CONFIG_SYSCTL
+static struct ctl_table kern_exit_table[] = {
+	{
+		.procname       = "oops_limit",
+		.data           = &oops_limit,
+		.maxlen         = sizeof(oops_limit),
+		.mode           = 0644,
+		.proc_handler   = proc_douintvec,
+	},
+	{ }
+};
+
+static __init int kernel_exit_sysctls_init(void)
+{
+	register_sysctl_init("kernel", kern_exit_table);
+	return 0;
+}
+late_initcall(kernel_exit_sysctls_init);
+#endif
+
+static atomic_t oops_count = ATOMIC_INIT(0);
+
+#ifdef CONFIG_SYSFS
+static ssize_t oops_count_show(struct kobject *kobj, struct kobj_attribute *attr,
+			       char *page)
+{
+	return sysfs_emit(page, "%d\n", atomic_read(&oops_count));
+}
+
+static struct kobj_attribute oops_count_attr = __ATTR_RO(oops_count);
+
+static __init int kernel_exit_sysfs_init(void)
+{
+	sysfs_add_file_to_group(kernel_kobj, &oops_count_attr.attr, NULL);
+	return 0;
+}
+late_initcall(kernel_exit_sysfs_init);
+#endif
+
 static void __unhash_process(struct task_struct *p, bool group_dead)
 {
 	nr_threads--;
@@ -920,6 +967,31 @@ void __noreturn do_exit(long code)
 }
 EXPORT_SYMBOL_GPL(do_exit);
 
+void __noreturn make_task_dead(int signr)
+{
+	/*
+	 * Take the task off the cpu after something catastrophic has
+	 * happened.
+	 */
+	unsigned int limit;
+
+	/*
+	 * Every time the system oopses, if the oops happens while a reference
+	 * to an object was held, the reference leaks.
+	 * If the oops doesn't also leak memory, repeated oopsing can cause
+	 * reference counters to wrap around (if they're not using refcount_t).
+	 * This means that repeated oopsing can make unexploitable-looking bugs
+	 * exploitable through repeated oopsing.
+	 * To make sure this can't happen, place an upper bound on how often the
+	 * kernel may oops without panic().
+	 */
+	limit = READ_ONCE(oops_limit);
+	if (atomic_inc_return(&oops_count) >= limit && limit)
+		panic("Oopsed too often (kernel.oops_limit is %d)", limit);
+
+	do_exit(signr);
+}
+
 void complete_and_exit(struct completion *comp, long code)
 {
 	if (comp)
diff --git a/kernel/module.c b/kernel/module.c
index 8404b41be7c6..2cd7de23cb1f 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3451,7 +3451,8 @@ static bool finished_loading(const char *name)
 	sched_annotate_sleep();
 	mutex_lock(&module_mutex);
 	mod = find_module_all(name, strlen(name), true);
-	ret = !mod || mod->state == MODULE_STATE_LIVE;
+	ret = !mod || mod->state == MODULE_STATE_LIVE
+		|| mod->state == MODULE_STATE_GOING;
 	mutex_unlock(&module_mutex);
 
 	return ret;
@@ -3603,20 +3604,35 @@ static int add_unformed_module(struct module *mod)
 
 	mod->state = MODULE_STATE_UNFORMED;
 
-again:
 	mutex_lock(&module_mutex);
 	old = find_module_all(mod->name, strlen(mod->name), true);
 	if (old != NULL) {
-		if (old->state != MODULE_STATE_LIVE) {
+		if (old->state == MODULE_STATE_COMING
+		    || old->state == MODULE_STATE_UNFORMED) {
 			/* Wait in case it fails to load. */
 			mutex_unlock(&module_mutex);
 			err = wait_event_interruptible(module_wq,
 					       finished_loading(mod->name));
 			if (err)
 				goto out_unlocked;
-			goto again;
+
+			/* The module might have gone in the meantime. */
+			mutex_lock(&module_mutex);
+			old = find_module_all(mod->name, strlen(mod->name),
+					      true);
 		}
-		err = -EEXIST;
+
+		/*
+		 * We are here only when the same module was being loaded. Do
+		 * not try to load it again right now. It prevents long delays
+		 * caused by serialized module load failures. It might happen
+		 * when more devices of the same type trigger load of
+		 * a particular module.
+		 */
+		if (old && old->state == MODULE_STATE_LIVE)
+			err = -EEXIST;
+		else
+			err = -EBUSY;
 		goto out;
 	}
 	mod_update_bounds(mod);
diff --git a/kernel/panic.c b/kernel/panic.c
index 207ceac3a432..165fd747cebd 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -28,6 +28,7 @@
 #include <linux/console.h>
 #include <linux/bug.h>
 #include <linux/ratelimit.h>
+#include <linux/sysfs.h>
 
 #define PANIC_TIMER_STEP 100
 #define PANIC_BLINK_SPD 18
@@ -39,6 +40,7 @@ static int pause_on_oops_flag;
 static DEFINE_SPINLOCK(pause_on_oops_lock);
 bool crash_kexec_post_notifiers;
 int panic_on_warn __read_mostly;
+static unsigned int warn_limit __read_mostly;
 
 int panic_timeout = CONFIG_PANIC_TIMEOUT;
 EXPORT_SYMBOL_GPL(panic_timeout);
@@ -47,6 +49,45 @@ ATOMIC_NOTIFIER_HEAD(panic_notifier_list);
 
 EXPORT_SYMBOL(panic_notifier_list);
 
+#ifdef CONFIG_SYSCTL
+static struct ctl_table kern_panic_table[] = {
+	{
+		.procname       = "warn_limit",
+		.data           = &warn_limit,
+		.maxlen         = sizeof(warn_limit),
+		.mode           = 0644,
+		.proc_handler   = proc_douintvec,
+	},
+	{ }
+};
+
+static __init int kernel_panic_sysctls_init(void)
+{
+	register_sysctl_init("kernel", kern_panic_table);
+	return 0;
+}
+late_initcall(kernel_panic_sysctls_init);
+#endif
+
+static atomic_t warn_count = ATOMIC_INIT(0);
+
+#ifdef CONFIG_SYSFS
+static ssize_t warn_count_show(struct kobject *kobj, struct kobj_attribute *attr,
+			       char *page)
+{
+	return sysfs_emit(page, "%d\n", atomic_read(&warn_count));
+}
+
+static struct kobj_attribute warn_count_attr = __ATTR_RO(warn_count);
+
+static __init int kernel_panic_sysfs_init(void)
+{
+	sysfs_add_file_to_group(kernel_kobj, &warn_count_attr.attr, NULL);
+	return 0;
+}
+late_initcall(kernel_panic_sysfs_init);
+#endif
+
 static long no_blink(int state)
 {
 	return 0;
@@ -122,6 +163,19 @@ void nmi_panic(struct pt_regs *regs, const char *msg)
 }
 EXPORT_SYMBOL(nmi_panic);
 
+void check_panic_on_warn(const char *origin)
+{
+	unsigned int limit;
+
+	if (panic_on_warn)
+		panic("%s: panic_on_warn set ...\n", origin);
+
+	limit = READ_ONCE(warn_limit);
+	if (atomic_inc_return(&warn_count) >= limit && limit)
+		panic("%s: system warned too often (kernel.warn_limit is %d)",
+		      origin, limit);
+}
+
 /**
  *	panic - halt the system
  *	@fmt: The text string to print
@@ -139,6 +193,16 @@ void panic(const char *fmt, ...)
 	int old_cpu, this_cpu;
 	bool _crash_kexec_post_notifiers = crash_kexec_post_notifiers;
 
+	if (panic_on_warn) {
+		/*
+		 * This thread may hit another WARN() in the panic path.
+		 * Resetting this prevents additional WARN() from panicking the
+		 * system on this thread.  Other threads are blocked by the
+		 * panic_mutex in panic().
+		 */
+		panic_on_warn = 0;
+	}
+
 	/*
 	 * Disable local interrupts. This will prevent panic_smp_self_stop
 	 * from deadlocking the first cpu that invokes the panic, since
@@ -536,16 +600,7 @@ void __warn(const char *file, int line, void *caller, unsigned taint,
 	if (args)
 		vprintk(args->fmt, args->args);
 
-	if (panic_on_warn) {
-		/*
-		 * This thread may hit another WARN() in the panic path.
-		 * Resetting this prevents additional WARN() from panicking the
-		 * system on this thread.  Other threads are blocked by the
-		 * panic_mutex in panic().
-		 */
-		panic_on_warn = 0;
-		panic("panic_on_warn set ...\n");
-	}
+	check_panic_on_warn("kernel");
 
 	print_modules();
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 544a1cb66d90..5dc66377864a 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3185,8 +3185,7 @@ static noinline void __schedule_bug(struct task_struct *prev)
 		print_ip_sym(preempt_disable_ip);
 		pr_cont("\n");
 	}
-	if (panic_on_warn)
-		panic("scheduling while atomic\n");
+	check_panic_on_warn("scheduling while atomic");
 
 	dump_stack();
 	add_taint(TAINT_WARN, LOCKDEP_STILL_OK);
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 02075886f530..f5d084b88228 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -8487,6 +8487,8 @@ void __init early_trace_init(void)
 			static_key_enable(&tracepoint_printk_key.key);
 	}
 	tracer_alloc_buffers();
+
+	init_events();
 }
 
 void __init trace_init(void)
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 365bc02230a9..5a3f27fe0c69 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -1531,6 +1531,7 @@ trace_find_event_field(struct trace_event_call *call, char *name);
 extern void trace_event_enable_cmd_record(bool enable);
 extern void trace_event_enable_tgid_record(bool enable);
 
+extern int init_events(void);
 extern int event_trace_add_tracer(struct dentry *parent, struct trace_array *tr);
 extern int event_trace_del_tracer(struct trace_array *tr);
 
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 4500b00e4e36..e3ab66e6fd85 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -1394,7 +1394,7 @@ static struct trace_event *events[] __initdata = {
 	NULL
 };
 
-__init static int init_events(void)
+__init int init_events(void)
 {
 	struct trace_event *event;
 	int i, ret;
@@ -1412,4 +1412,3 @@ __init static int init_events(void)
 
 	return 0;
 }
-early_initcall(init_events);
diff --git a/mm/kasan/report.c b/mm/kasan/report.c
index 6bcfb01ba038..1c96c83f9775 100644
--- a/mm/kasan/report.c
+++ b/mm/kasan/report.c
@@ -172,8 +172,7 @@ static void kasan_end_report(unsigned long *flags)
 	pr_err("==================================================================\n");
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
 	spin_unlock_irqrestore(&report_lock, *flags);
-	if (panic_on_warn)
-		panic("panic_on_warn set ...\n");
+	check_panic_on_warn("KASAN");
 	kasan_enable_current();
 }
 
diff --git a/mm/util.c b/mm/util.c
index 84e775f5216f..7d80c8119dce 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -400,7 +400,8 @@ EXPORT_SYMBOL(vm_mmap);
  * __GFP_RETRY_MAYFAIL is supported, and it should be used only if kmalloc is
  * preferable to the vmalloc fallback, due to visible performance drawbacks.
  *
- * Any use of gfp flags outside of GFP_KERNEL should be consulted with mm people.
+ * Please note that any use of gfp flags outside of GFP_KERNEL is careful to not
+ * fall back to vmalloc.
  */
 void *kvmalloc_node(size_t size, gfp_t flags, int node)
 {
@@ -411,7 +412,8 @@ void *kvmalloc_node(size_t size, gfp_t flags, int node)
 	 * vmalloc uses GFP_KERNEL for some internal allocations (e.g page tables)
 	 * so the given set of flags has to be compatible.
 	 */
-	WARN_ON_ONCE((flags & GFP_KERNEL) != GFP_KERNEL);
+	if ((flags & GFP_KERNEL) != GFP_KERNEL)
+		return kmalloc_node(size, flags, node);
 
 	/*
 	 * We want to attempt a large physically contiguous block first because
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 81a151ca4a24..1fd6498e3387 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1479,6 +1479,7 @@ static int hci_dev_do_open(struct hci_dev *hdev)
 			hdev->flush(hdev);
 
 		if (hdev->sent_cmd) {
+			cancel_delayed_work_sync(&hdev->cmd_timer);
 			kfree_skb(hdev->sent_cmd);
 			hdev->sent_cmd = NULL;
 		}
diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index cd11c56525ff..b393cea79d9c 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -771,14 +771,16 @@ static void ip6gre_tnl_link_config(struct ip6_tnl *t, int set_mtu)
 					       t_hlen;
 
 			if (set_mtu) {
-				dev->mtu = rt->dst.dev->mtu - t_hlen;
+				int mtu = rt->dst.dev->mtu - t_hlen;
+
 				if (!(t->parms.flags & IP6_TNL_F_IGN_ENCAP_LIMIT))
-					dev->mtu -= 8;
+					mtu -= 8;
 				if (dev->type == ARPHRD_ETHER)
-					dev->mtu -= ETH_HLEN;
+					mtu -= ETH_HLEN;
 
-				if (dev->mtu < IPV6_MIN_MTU)
-					dev->mtu = IPV6_MIN_MTU;
+				if (mtu < IPV6_MIN_MTU)
+					mtu = IPV6_MIN_MTU;
+				WRITE_ONCE(dev->mtu, mtu);
 			}
 		}
 		ip6_rt_put(rt);
diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 9458a0dfa820..639440032c2b 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1431,6 +1431,7 @@ static void ip6_tnl_link_config(struct ip6_tnl *t)
 	struct __ip6_tnl_parm *p = &t->parms;
 	struct flowi6 *fl6 = &t->fl.u.ip6;
 	int t_hlen;
+	int mtu;
 
 	memcpy(dev->dev_addr, &p->laddr, sizeof(struct in6_addr));
 	memcpy(dev->broadcast, &p->raddr, sizeof(struct in6_addr));
@@ -1473,12 +1474,13 @@ static void ip6_tnl_link_config(struct ip6_tnl *t)
 			dev->hard_header_len = rt->dst.dev->hard_header_len +
 				t_hlen;
 
-			dev->mtu = rt->dst.dev->mtu - t_hlen;
+			mtu = rt->dst.dev->mtu - t_hlen;
 			if (!(t->parms.flags & IP6_TNL_F_IGN_ENCAP_LIMIT))
-				dev->mtu -= 8;
+				mtu -= 8;
 
-			if (dev->mtu < IPV6_MIN_MTU)
-				dev->mtu = IPV6_MIN_MTU;
+			if (mtu < IPV6_MIN_MTU)
+				mtu = IPV6_MIN_MTU;
+			WRITE_ONCE(dev->mtu, mtu);
 		}
 		ip6_rt_put(rt);
 	}
diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 6525a95a668d..e5baf5e4782b 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -1068,10 +1068,12 @@ static void ipip6_tunnel_bind_dev(struct net_device *dev)
 
 	if (tdev && !netif_is_l3_master(tdev)) {
 		int t_hlen = tunnel->hlen + sizeof(struct iphdr);
+		int mtu;
 
-		dev->mtu = tdev->mtu - t_hlen;
-		if (dev->mtu < IPV6_MIN_MTU)
-			dev->mtu = IPV6_MIN_MTU;
+		mtu = tdev->mtu - t_hlen;
+		if (mtu < IPV6_MIN_MTU)
+			mtu = IPV6_MIN_MTU;
+		WRITE_ONCE(dev->mtu, mtu);
 	}
 }
 
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 6303a88af12b..1278b27c625a 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -343,22 +343,29 @@ static int sctp_packet(struct nf_conn *ct,
 	for_each_sctp_chunk (skb, sch, _sch, offset, dataoff, count) {
 		/* Special cases of Verification tag check (Sec 8.5.1) */
 		if (sch->type == SCTP_CID_INIT) {
-			/* Sec 8.5.1 (A) */
+			/* (A) vtag MUST be zero */
 			if (sh->vtag != 0)
 				goto out_unlock;
 		} else if (sch->type == SCTP_CID_ABORT) {
-			/* Sec 8.5.1 (B) */
-			if (sh->vtag != ct->proto.sctp.vtag[dir] &&
-			    sh->vtag != ct->proto.sctp.vtag[!dir])
+			/* (B) vtag MUST match own vtag if T flag is unset OR
+			 * MUST match peer's vtag if T flag is set
+			 */
+			if ((!(sch->flags & SCTP_CHUNK_FLAG_T) &&
+			     sh->vtag != ct->proto.sctp.vtag[dir]) ||
+			    ((sch->flags & SCTP_CHUNK_FLAG_T) &&
+			     sh->vtag != ct->proto.sctp.vtag[!dir]))
 				goto out_unlock;
 		} else if (sch->type == SCTP_CID_SHUTDOWN_COMPLETE) {
-			/* Sec 8.5.1 (C) */
-			if (sh->vtag != ct->proto.sctp.vtag[dir] &&
-			    sh->vtag != ct->proto.sctp.vtag[!dir] &&
-			    sch->flags & SCTP_CHUNK_FLAG_T)
+			/* (C) vtag MUST match own vtag if T flag is unset OR
+			 * MUST match peer's vtag if T flag is set
+			 */
+			if ((!(sch->flags & SCTP_CHUNK_FLAG_T) &&
+			     sh->vtag != ct->proto.sctp.vtag[dir]) ||
+			    ((sch->flags & SCTP_CHUNK_FLAG_T) &&
+			     sh->vtag != ct->proto.sctp.vtag[!dir]))
 				goto out_unlock;
 		} else if (sch->type == SCTP_CID_COOKIE_ECHO) {
-			/* Sec 8.5.1 (D) */
+			/* (D) vtag must be same as init_vtag as found in INIT_ACK */
 			if (sh->vtag != ct->proto.sctp.vtag[dir])
 				goto out_unlock;
 		} else if (sch->type == SCTP_CID_HEARTBEAT ||
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 1b2e99ce54e5..d7b0a7aa29a8 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1061,9 +1061,11 @@ static int netlink_connect(struct socket *sock, struct sockaddr *addr,
 		return -EINVAL;
 
 	if (addr->sa_family == AF_UNSPEC) {
-		sk->sk_state	= NETLINK_UNCONNECTED;
-		nlk->dst_portid	= 0;
-		nlk->dst_group  = 0;
+		/* paired with READ_ONCE() in netlink_getsockbyportid() */
+		WRITE_ONCE(sk->sk_state, NETLINK_UNCONNECTED);
+		/* dst_portid and dst_group can be read locklessly */
+		WRITE_ONCE(nlk->dst_portid, 0);
+		WRITE_ONCE(nlk->dst_group, 0);
 		return 0;
 	}
 	if (addr->sa_family != AF_NETLINK)
@@ -1084,9 +1086,11 @@ static int netlink_connect(struct socket *sock, struct sockaddr *addr,
 		err = netlink_autobind(sock);
 
 	if (err == 0) {
-		sk->sk_state	= NETLINK_CONNECTED;
-		nlk->dst_portid = nladdr->nl_pid;
-		nlk->dst_group  = ffs(nladdr->nl_groups);
+		/* paired with READ_ONCE() in netlink_getsockbyportid() */
+		WRITE_ONCE(sk->sk_state, NETLINK_CONNECTED);
+		/* dst_portid and dst_group can be read locklessly */
+		WRITE_ONCE(nlk->dst_portid, nladdr->nl_pid);
+		WRITE_ONCE(nlk->dst_group, ffs(nladdr->nl_groups));
 	}
 
 	return err;
@@ -1104,8 +1108,9 @@ static int netlink_getname(struct socket *sock, struct sockaddr *addr,
 	*addr_len = sizeof(*nladdr);
 
 	if (peer) {
-		nladdr->nl_pid = nlk->dst_portid;
-		nladdr->nl_groups = netlink_group_mask(nlk->dst_group);
+		/* Paired with WRITE_ONCE() in netlink_connect() */
+		nladdr->nl_pid = READ_ONCE(nlk->dst_portid);
+		nladdr->nl_groups = netlink_group_mask(READ_ONCE(nlk->dst_group));
 	} else {
 		nladdr->nl_pid = nlk->portid;
 		netlink_lock_table();
@@ -1134,8 +1139,9 @@ static struct sock *netlink_getsockbyportid(struct sock *ssk, u32 portid)
 
 	/* Don't bother queuing skb if kernel socket has no input function */
 	nlk = nlk_sk(sock);
-	if (sock->sk_state == NETLINK_CONNECTED &&
-	    nlk->dst_portid != nlk_sk(ssk)->portid) {
+	/* dst_portid and sk_state can be changed in netlink_connect() */
+	if (READ_ONCE(sock->sk_state) == NETLINK_CONNECTED &&
+	    READ_ONCE(nlk->dst_portid) != nlk_sk(ssk)->portid) {
 		sock_put(sock);
 		return ERR_PTR(-ECONNREFUSED);
 	}
@@ -1847,8 +1853,9 @@ static int netlink_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 			goto out;
 		netlink_skb_flags |= NETLINK_SKB_DST;
 	} else {
-		dst_portid = nlk->dst_portid;
-		dst_group = nlk->dst_group;
+		/* Paired with WRITE_ONCE() in netlink_connect() */
+		dst_portid = READ_ONCE(nlk->dst_portid);
+		dst_group = READ_ONCE(nlk->dst_group);
 	}
 
 	/* Paired with WRITE_ONCE() in netlink_insert() */
diff --git a/net/netrom/nr_timer.c b/net/netrom/nr_timer.c
index d1a0b7056743..1fb9084bb937 100644
--- a/net/netrom/nr_timer.c
+++ b/net/netrom/nr_timer.c
@@ -125,6 +125,7 @@ static void nr_heartbeat_expiry(unsigned long param)
 		   is accepted() it isn't 'dead' so doesn't get removed. */
 		if (sock_flag(sk, SOCK_DESTROY) ||
 		    (sk->sk_state == TCP_LISTEN && sock_flag(sk, SOCK_DEAD))) {
+			sock_hold(sk);
 			bh_unlock_sock(sk);
 			nr_destroy_socket(sk);
 			goto out;
diff --git a/net/nfc/llcp_core.c b/net/nfc/llcp_core.c
index 7e619ff8a653..150f7ffbf6bc 100644
--- a/net/nfc/llcp_core.c
+++ b/net/nfc/llcp_core.c
@@ -171,6 +171,7 @@ static void local_cleanup(struct nfc_llcp_local *local)
 	cancel_work_sync(&local->rx_work);
 	cancel_work_sync(&local->timeout_work);
 	kfree_skb(local->rx_pending);
+	local->rx_pending = NULL;
 	del_timer_sync(&local->sdreq_timer);
 	cancel_work_sync(&local->sdreq_timeout_work);
 	nfc_llcp_free_sdp_tlv_list(&local->pending_sdreqs);
diff --git a/net/sctp/bind_addr.c b/net/sctp/bind_addr.c
index f8a283245672..d723942e5e65 100644
--- a/net/sctp/bind_addr.c
+++ b/net/sctp/bind_addr.c
@@ -88,6 +88,12 @@ int sctp_bind_addr_copy(struct net *net, struct sctp_bind_addr *dest,
 		}
 	}
 
+	/* If somehow no addresses were found that can be used with this
+	 * scope, it's an error.
+	 */
+	if (list_empty(&dest->address_list))
+		error = -ENETUNREACH;
+
 out:
 	if (error)
 		sctp_bind_addr_clean(dest);
diff --git a/security/tomoyo/Makefile b/security/tomoyo/Makefile
index b7c6a7ffc058..a1ecf68930c7 100644
--- a/security/tomoyo/Makefile
+++ b/security/tomoyo/Makefile
@@ -10,7 +10,7 @@ endef
 quiet_cmd_policy  = POLICY  $@
       cmd_policy  = ($(call do_policy,profile); $(call do_policy,exception_policy); $(call do_policy,domain_policy); $(call do_policy,manager); $(call do_policy,stat)) >$@
 
-$(obj)/builtin-policy.h: $(wildcard $(obj)/policy/*.conf $(src)/policy/*.conf.default) FORCE
+$(obj)/builtin-policy.h: $(wildcard $(obj)/policy/*.conf $(srctree)/$(src)/policy/*.conf.default) FORCE
 	$(call if_changed,policy)
 
 $(obj)/common.o: $(obj)/builtin-policy.h
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 2c8e2dae1701..e93c061654a7 100644
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
+		"rewind_stack_and_make_dead",
 	};
 
 	if (func->bind == STB_WEAK)
