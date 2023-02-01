Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D45B6860D1
	for <lists+stable@lfdr.de>; Wed,  1 Feb 2023 08:43:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231771AbjBAHnv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Feb 2023 02:43:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230503AbjBAHnr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Feb 2023 02:43:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA4FA29E05;
        Tue, 31 Jan 2023 23:43:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC5A5B82107;
        Wed,  1 Feb 2023 07:43:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 954FBC433D2;
        Wed,  1 Feb 2023 07:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675237418;
        bh=8jk4jMYpi3Oh8PrJuUE8VXptNbUaH2T7lkLYY8NQmSo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GTDPOZlv6yC0P0eEWacQArYZDrr4g7dc6AHsX636SvQE/1R39aSRAqfpaDy/ALA/a
         G/yuG1qwON/lCX2kf5f7xryC1DDO7aY1E6EYg0MJAdMz9+tAvJWSmgsqQhdTVYX7Zd
         RII0H3NEs6rsZlbIYxEYX+53SurecvoUXbHXnOsM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.10.166
Date:   Wed,  1 Feb 2023 08:43:28 +0100
Message-Id: <167523740721196@kroah.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <167523740789253@kroah.com>
References: <167523740789253@kroah.com>
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
diff --git a/Documentation/admin-guide/sysctl/kernel.rst b/Documentation/admin-guide/sysctl/kernel.rst
index a4b1ebc2e70b..6b0c7b650dea 100644
--- a/Documentation/admin-guide/sysctl/kernel.rst
+++ b/Documentation/admin-guide/sysctl/kernel.rst
@@ -663,6 +663,15 @@ This is the default behavior.
 an oops event is detected.
 
 
+oops_limit
+==========
+
+Number of kernel oopses after which the kernel should panic when
+``panic_on_oops`` is not set. Setting this to 0 disables checking
+the count. Setting this to  1 has the same effect as setting
+``panic_on_oops=1``. The default value is 10000.
+
+
 osrelease, ostype & version
 ===========================
 
@@ -1469,6 +1478,16 @@ entry will default to 2 instead of 0.
 2 Unprivileged calls to ``bpf()`` are disabled
 = =============================================================
 
+
+warn_limit
+==========
+
+Number of kernel warnings after which the kernel should panic when
+``panic_on_warn`` is not set. Setting this to 0 disables checking
+the warning count. Setting this to 1 has the same effect as setting
+``panic_on_warn=1``. The default value is 0.
+
+
 watchdog
 ========
 
diff --git a/Makefile b/Makefile
index 5fbff8603f44..efdfb40a82ab 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 10
-SUBLEVEL = 165
+SUBLEVEL = 166
 EXTRAVERSION =
 NAME = Dare mighty things
 
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
diff --git a/arch/arm/boot/dts/imx6qdl-gw560x.dtsi b/arch/arm/boot/dts/imx6qdl-gw560x.dtsi
index 093a219a77ae..f520e337698a 100644
--- a/arch/arm/boot/dts/imx6qdl-gw560x.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-gw560x.dtsi
@@ -634,7 +634,6 @@ &ssi1 {
 &uart1 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_uart1>;
-	uart-has-rtscts;
 	rts-gpios = <&gpio7 1 GPIO_ACTIVE_HIGH>;
 	status = "okay";
 };
diff --git a/arch/arm/boot/dts/imx6ul-pico-dwarf.dts b/arch/arm/boot/dts/imx6ul-pico-dwarf.dts
index 162dc259edc8..5a74c7f68eb6 100644
--- a/arch/arm/boot/dts/imx6ul-pico-dwarf.dts
+++ b/arch/arm/boot/dts/imx6ul-pico-dwarf.dts
@@ -32,7 +32,7 @@ sys_mclk: clock-sys-mclk {
 };
 
 &i2c2 {
-	clock_frequency = <100000>;
+	clock-frequency = <100000>;
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_i2c2>;
 	status = "okay";
diff --git a/arch/arm/boot/dts/imx7d-pico-dwarf.dts b/arch/arm/boot/dts/imx7d-pico-dwarf.dts
index 5162fe227d1e..fdc10563f147 100644
--- a/arch/arm/boot/dts/imx7d-pico-dwarf.dts
+++ b/arch/arm/boot/dts/imx7d-pico-dwarf.dts
@@ -32,7 +32,7 @@ sys_mclk: clock-sys-mclk {
 };
 
 &i2c1 {
-	clock_frequency = <100000>;
+	clock-frequency = <100000>;
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_i2c1>;
 	status = "okay";
@@ -52,7 +52,7 @@ pressure-sensor@60 {
 };
 
 &i2c4 {
-	clock_frequency = <100000>;
+	clock-frequency = <100000>;
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_i2c1>;
 	status = "okay";
diff --git a/arch/arm/boot/dts/imx7d-pico-nymph.dts b/arch/arm/boot/dts/imx7d-pico-nymph.dts
index 104a85254adb..5afb1674e012 100644
--- a/arch/arm/boot/dts/imx7d-pico-nymph.dts
+++ b/arch/arm/boot/dts/imx7d-pico-nymph.dts
@@ -43,7 +43,7 @@ sys_mclk: clock-sys-mclk {
 };
 
 &i2c1 {
-	clock_frequency = <100000>;
+	clock-frequency = <100000>;
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_i2c1>;
 	status = "okay";
@@ -64,7 +64,7 @@ adc@52 {
 };
 
 &i2c2 {
-	clock_frequency = <100000>;
+	clock-frequency = <100000>;
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_i2c2>;
 	status = "okay";
diff --git a/arch/arm/boot/dts/sam9x60.dtsi b/arch/arm/boot/dts/sam9x60.dtsi
index ec45ced3cde6..e1e0dec8cc1f 100644
--- a/arch/arm/boot/dts/sam9x60.dtsi
+++ b/arch/arm/boot/dts/sam9x60.dtsi
@@ -567,7 +567,7 @@ pmecc: ecc-engine@ffffe000 {
 			mpddrc: mpddrc@ffffe800 {
 				compatible = "microchip,sam9x60-ddramc", "atmel,sama5d3-ddramc";
 				reg = <0xffffe800 0x200>;
-				clocks = <&pmc PMC_TYPE_SYSTEM 2>, <&pmc PMC_TYPE_CORE PMC_MCK>;
+				clocks = <&pmc PMC_TYPE_SYSTEM 2>, <&pmc PMC_TYPE_PERIPHERAL 49>;
 				clock-names = "ddrck", "mpddr";
 			};
 
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
diff --git a/arch/arm/mach-imx/cpu-imx25.c b/arch/arm/mach-imx/cpu-imx25.c
index b2e1963f473d..2ee2d2813d57 100644
--- a/arch/arm/mach-imx/cpu-imx25.c
+++ b/arch/arm/mach-imx/cpu-imx25.c
@@ -23,6 +23,7 @@ static int mx25_read_cpu_rev(void)
 
 	np = of_find_compatible_node(NULL, NULL, "fsl,imx25-iim");
 	iim_base = of_iomap(np, 0);
+	of_node_put(np);
 	BUG_ON(!iim_base);
 	rev = readl(iim_base + MXC_IIMSREV);
 	iounmap(iim_base);
diff --git a/arch/arm/mach-imx/cpu-imx27.c b/arch/arm/mach-imx/cpu-imx27.c
index bf70e13bbe9e..1d2893908368 100644
--- a/arch/arm/mach-imx/cpu-imx27.c
+++ b/arch/arm/mach-imx/cpu-imx27.c
@@ -28,6 +28,7 @@ static int mx27_read_cpu_rev(void)
 
 	np = of_find_compatible_node(NULL, NULL, "fsl,imx27-ccm");
 	ccm_base = of_iomap(np, 0);
+	of_node_put(np);
 	BUG_ON(!ccm_base);
 	/*
 	 * now we have access to the IO registers. As we need
diff --git a/arch/arm/mach-imx/cpu-imx31.c b/arch/arm/mach-imx/cpu-imx31.c
index b9c24b851d1a..35c544924e50 100644
--- a/arch/arm/mach-imx/cpu-imx31.c
+++ b/arch/arm/mach-imx/cpu-imx31.c
@@ -39,6 +39,7 @@ static int mx31_read_cpu_rev(void)
 
 	np = of_find_compatible_node(NULL, NULL, "fsl,imx31-iim");
 	iim_base = of_iomap(np, 0);
+	of_node_put(np);
 	BUG_ON(!iim_base);
 
 	/* read SREV register from IIM module */
diff --git a/arch/arm/mach-imx/cpu-imx35.c b/arch/arm/mach-imx/cpu-imx35.c
index 80e7d8ab9f1b..1fe75b39c2d9 100644
--- a/arch/arm/mach-imx/cpu-imx35.c
+++ b/arch/arm/mach-imx/cpu-imx35.c
@@ -21,6 +21,7 @@ static int mx35_read_cpu_rev(void)
 
 	np = of_find_compatible_node(NULL, NULL, "fsl,imx35-iim");
 	iim_base = of_iomap(np, 0);
+	of_node_put(np);
 	BUG_ON(!iim_base);
 
 	rev = imx_readl(iim_base + MXC_IIMSREV);
diff --git a/arch/arm/mach-imx/cpu-imx5.c b/arch/arm/mach-imx/cpu-imx5.c
index ad56263778f9..a67c89bf155d 100644
--- a/arch/arm/mach-imx/cpu-imx5.c
+++ b/arch/arm/mach-imx/cpu-imx5.c
@@ -28,6 +28,7 @@ static u32 imx5_read_srev_reg(const char *compat)
 
 	np = of_find_compatible_node(NULL, NULL, compat);
 	iim_base = of_iomap(np, 0);
+	of_node_put(np);
 	WARN_ON(!iim_base);
 
 	srev = readl(iim_base + IIM_SREV) & 0xff;
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
diff --git a/arch/arm/mm/nommu.c b/arch/arm/mm/nommu.c
index 959f05701738..c4d5b3bacf64 100644
--- a/arch/arm/mm/nommu.c
+++ b/arch/arm/mm/nommu.c
@@ -161,7 +161,7 @@ void __init paging_init(const struct machine_desc *mdesc)
 	mpu_setup();
 
 	/* allocate the zero page. */
-	zero_page = memblock_alloc(PAGE_SIZE, PAGE_SIZE);
+	zero_page = (void *)memblock_alloc(PAGE_SIZE, PAGE_SIZE);
 	if (!zero_page)
 		panic("%s: Failed to allocate %lu bytes align=0x%lx\n",
 		      __func__, PAGE_SIZE, PAGE_SIZE);
diff --git a/arch/arm64/boot/dts/freescale/imx8mm-beacon-baseboard.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-beacon-baseboard.dtsi
index 5667009aae13..674a0ab8a539 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-beacon-baseboard.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-beacon-baseboard.dtsi
@@ -70,7 +70,7 @@ sound {
 &ecspi2 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_espi2>;
-	cs-gpios = <&gpio5 9 GPIO_ACTIVE_LOW>;
+	cs-gpios = <&gpio5 13 GPIO_ACTIVE_LOW>;
 	status = "okay";
 
 	eeprom@0 {
@@ -187,7 +187,7 @@ pinctrl_espi2: espi2grp {
 			MX8MM_IOMUXC_ECSPI2_SCLK_ECSPI2_SCLK		0x82
 			MX8MM_IOMUXC_ECSPI2_MOSI_ECSPI2_MOSI		0x82
 			MX8MM_IOMUXC_ECSPI2_MISO_ECSPI2_MISO		0x82
-			MX8MM_IOMUXC_ECSPI1_SS0_GPIO5_IO9		0x41
+			MX8MM_IOMUXC_ECSPI2_SS0_GPIO5_IO13              0x41
 		>;
 	};
 
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
index cb2a0d94a144..2df115d0e210 100644
--- a/arch/csky/abiv1/alignment.c
+++ b/arch/csky/abiv1/alignment.c
@@ -294,7 +294,7 @@ void csky_alignment(struct pt_regs *regs)
 				__func__, opcode, rz, rx, imm, addr);
 		show_regs(regs);
 		bust_spinlocks(0);
-		do_exit(SIGKILL);
+		make_task_dead(SIGKILL);
 	}
 
 	force_sig_fault(SIGBUS, BUS_ADRALN, (void __user *)addr);
diff --git a/arch/csky/kernel/traps.c b/arch/csky/kernel/traps.c
index 22721468a04b..15711efa14a4 100644
--- a/arch/csky/kernel/traps.c
+++ b/arch/csky/kernel/traps.c
@@ -111,7 +111,7 @@ void die(struct pt_regs *regs, const char *str)
 	if (panic_on_oops)
 		panic("Fatal exception");
 	if (ret != NOTIFY_STOP)
-		do_exit(SIGSEGV);
+		make_task_dead(SIGSEGV);
 }
 
 void do_trap(struct pt_regs *regs, int signo, int code, unsigned long addr)
diff --git a/arch/h8300/kernel/traps.c b/arch/h8300/kernel/traps.c
index 5d8b969cd8f3..cf23ccb50c17 100644
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
index d4bc9c16f2df..b465441f490d 100644
--- a/arch/h8300/mm/fault.c
+++ b/arch/h8300/mm/fault.c
@@ -51,7 +51,7 @@ asmlinkage int do_page_fault(struct pt_regs *regs, unsigned long address,
 	printk(" at virtual address %08lx\n", address);
 	if (!user_mode(regs))
 		die("Oops", regs, error_code);
-	do_exit(SIGKILL);
+	make_task_dead(SIGKILL);
 
 	return 1;
 }
diff --git a/arch/hexagon/kernel/traps.c b/arch/hexagon/kernel/traps.c
index 904134b37232..b334e8071709 100644
--- a/arch/hexagon/kernel/traps.c
+++ b/arch/hexagon/kernel/traps.c
@@ -218,7 +218,7 @@ int die(const char *str, struct pt_regs *regs, long err)
 		panic("Fatal exception");
 
 	oops_exit();
-	do_exit(err);
+	make_task_dead(err);
 	return 0;
 }
 
diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 39b25a5a591b..1d0579bc9d65 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -361,7 +361,7 @@ config ARCH_PROC_KCORE_TEXT
 	depends on PROC_KCORE
 
 config IA64_MCA_RECOVERY
-	tristate "MCA recovery from errors other than TLB."
+	bool "MCA recovery from errors other than TLB."
 
 config IA64_PALINFO
 	tristate "/proc/pal support"
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
diff --git a/arch/s390/include/asm/debug.h b/arch/s390/include/asm/debug.h
index c1b82bcc017c..29a1badbe2f5 100644
--- a/arch/s390/include/asm/debug.h
+++ b/arch/s390/include/asm/debug.h
@@ -4,8 +4,8 @@
  *
  *    Copyright IBM Corp. 1999, 2020
  */
-#ifndef DEBUG_H
-#define DEBUG_H
+#ifndef _ASM_S390_DEBUG_H
+#define _ASM_S390_DEBUG_H
 
 #include <linux/string.h>
 #include <linux/spinlock.h>
@@ -425,4 +425,4 @@ int debug_unregister_view(debug_info_t *id, struct debug_view *view);
 #define PRINT_FATAL(x...)	printk(KERN_DEBUG PRINTK_HEADER x)
 #endif /* DASD_DEBUG */
 
-#endif /* DEBUG_H */
+#endif /* _ASM_S390_DEBUG_H */
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
diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index b51ab19eb972..64d1dfe6dca5 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -81,8 +81,9 @@ static int sca_inject_ext_call(struct kvm_vcpu *vcpu, int src_id)
 		struct esca_block *sca = vcpu->kvm->arch.sca;
 		union esca_sigp_ctrl *sigp_ctrl =
 			&(sca->cpu[vcpu->vcpu_id].sigp_ctrl);
-		union esca_sigp_ctrl new_val = {0}, old_val = *sigp_ctrl;
+		union esca_sigp_ctrl new_val = {0}, old_val;
 
+		old_val = READ_ONCE(*sigp_ctrl);
 		new_val.scn = src_id;
 		new_val.c = 1;
 		old_val.c = 0;
@@ -93,8 +94,9 @@ static int sca_inject_ext_call(struct kvm_vcpu *vcpu, int src_id)
 		struct bsca_block *sca = vcpu->kvm->arch.sca;
 		union bsca_sigp_ctrl *sigp_ctrl =
 			&(sca->cpu[vcpu->vcpu_id].sigp_ctrl);
-		union bsca_sigp_ctrl new_val = {0}, old_val = *sigp_ctrl;
+		union bsca_sigp_ctrl new_val = {0}, old_val;
 
+		old_val = READ_ONCE(*sigp_ctrl);
 		new_val.scn = src_id;
 		new_val.c = 1;
 		old_val.c = 0;
@@ -124,16 +126,18 @@ static void sca_clear_ext_call(struct kvm_vcpu *vcpu)
 		struct esca_block *sca = vcpu->kvm->arch.sca;
 		union esca_sigp_ctrl *sigp_ctrl =
 			&(sca->cpu[vcpu->vcpu_id].sigp_ctrl);
-		union esca_sigp_ctrl old = *sigp_ctrl;
+		union esca_sigp_ctrl old;
 
+		old = READ_ONCE(*sigp_ctrl);
 		expect = old.value;
 		rc = cmpxchg(&sigp_ctrl->value, old.value, 0);
 	} else {
 		struct bsca_block *sca = vcpu->kvm->arch.sca;
 		union bsca_sigp_ctrl *sigp_ctrl =
 			&(sca->cpu[vcpu->vcpu_id].sigp_ctrl);
-		union bsca_sigp_ctrl old = *sigp_ctrl;
+		union bsca_sigp_ctrl old;
 
+		old = READ_ONCE(*sigp_ctrl);
 		expect = old.value;
 		rc = cmpxchg(&sigp_ctrl->value, old.value, 0);
 	}
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
diff --git a/arch/x86/events/amd/core.c b/arch/x86/events/amd/core.c
index 39eb276d0277..52eba415928a 100644
--- a/arch/x86/events/amd/core.c
+++ b/arch/x86/events/amd/core.c
@@ -976,7 +976,7 @@ static int __init amd_core_pmu_init(void)
 		 * numbered counter following it.
 		 */
 		for (i = 0; i < x86_pmu.num_counters - 1; i += 2)
-			even_ctr_mask |= 1 << i;
+			even_ctr_mask |= BIT_ULL(i);
 
 		pair_constraint = (struct event_constraint)
 				    __EVENT_CONSTRAINT(0, even_ctr_mask, 0,
diff --git a/arch/x86/kernel/acpi/cstate.c b/arch/x86/kernel/acpi/cstate.c
index 49ae4e1ac9cd..d28d43d774a2 100644
--- a/arch/x86/kernel/acpi/cstate.c
+++ b/arch/x86/kernel/acpi/cstate.c
@@ -79,6 +79,21 @@ void acpi_processor_power_init_bm_check(struct acpi_processor_flags *flags,
 		 */
 		flags->bm_control = 0;
 	}
+	if (c->x86_vendor == X86_VENDOR_AMD && c->x86 >= 0x17) {
+		/*
+		 * For all AMD Zen or newer CPUs that support C3, caches
+		 * should not be flushed by software while entering C3
+		 * type state. Set bm->check to 1 so that kernel doesn't
+		 * need to execute cache flush operation.
+		 */
+		flags->bm_check = 1;
+		/*
+		 * In current AMD C state implementation ARB_DIS is no longer
+		 * used. So set bm_control to zero to indicate ARB_DIS is not
+		 * required while entering C3 type state.
+		 */
+		flags->bm_control = 0;
+	}
 }
 EXPORT_SYMBOL(acpi_processor_power_init_bm_check);
 
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
 
diff --git a/arch/x86/kernel/i8259.c b/arch/x86/kernel/i8259.c
index 282b4ee1339f..f325389d0351 100644
--- a/arch/x86/kernel/i8259.c
+++ b/arch/x86/kernel/i8259.c
@@ -114,6 +114,7 @@ static void make_8259A_irq(unsigned int irq)
 	disable_irq_nosync(irq);
 	io_apic_irqs &= ~(1<<irq);
 	irq_set_chip_and_handler(irq, &i8259A_chip, handle_level_irq);
+	irq_set_status_flags(irq, IRQ_LEVEL);
 	enable_irq(irq);
 	lapic_assign_legacy_vector(irq, true);
 }
diff --git a/arch/x86/kernel/irqinit.c b/arch/x86/kernel/irqinit.c
index beb1bada1b0a..c683666876f1 100644
--- a/arch/x86/kernel/irqinit.c
+++ b/arch/x86/kernel/irqinit.c
@@ -65,8 +65,10 @@ void __init init_ISA_irqs(void)
 
 	legacy_pic->init(0);
 
-	for (i = 0; i < nr_legacy_irqs(); i++)
+	for (i = 0; i < nr_legacy_irqs(); i++) {
 		irq_set_chip_and_handler(i, chip, handle_level_irq);
+		irq_set_status_flags(i, IRQ_LEVEL);
+	}
 }
 
 void __init init_IRQ(void)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index af6742d11ca1..8f7152e158e2 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3332,18 +3332,15 @@ static u32 vmx_segment_access_rights(struct kvm_segment *var)
 {
 	u32 ar;
 
-	if (var->unusable || !var->present)
-		ar = 1 << 16;
-	else {
-		ar = var->type & 15;
-		ar |= (var->s & 1) << 4;
-		ar |= (var->dpl & 3) << 5;
-		ar |= (var->present & 1) << 7;
-		ar |= (var->avl & 1) << 12;
-		ar |= (var->l & 1) << 13;
-		ar |= (var->db & 1) << 14;
-		ar |= (var->g & 1) << 15;
-	}
+	ar = var->type & 15;
+	ar |= (var->s & 1) << 4;
+	ar |= (var->dpl & 3) << 5;
+	ar |= (var->present & 1) << 7;
+	ar |= (var->avl & 1) << 12;
+	ar |= (var->l & 1) << 13;
+	ar |= (var->db & 1) << 14;
+	ar |= (var->g & 1) << 15;
+	ar |= (var->unusable || !var->present) << 16;
 
 	return ar;
 }
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
diff --git a/block/blk-core.c b/block/blk-core.c
index 26664f2a139e..9afb79b322fb 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -700,9 +700,7 @@ static inline bool bio_check_ro(struct bio *bio, struct hd_struct *part)
 
 		if (op_is_flush(bio->bi_opf) && !bio_sectors(bio))
 			return false;
-
-		WARN_ONCE(1,
-		       "Trying to write to read-only block-device %s (partno %d)\n",
+		pr_warn("Trying to write to read-only block-device %s (partno %d)\n",
 			bio_devname(bio, b), part->partno);
 		/* Older lvm-tools actually trigger this */
 		return false;
diff --git a/drivers/base/test/test_async_driver_probe.c b/drivers/base/test/test_async_driver_probe.c
index 3bb7beb127a9..c157a912d673 100644
--- a/drivers/base/test/test_async_driver_probe.c
+++ b/drivers/base/test/test_async_driver_probe.c
@@ -146,7 +146,7 @@ static int __init test_async_probe_init(void)
 	calltime = ktime_get();
 	for_each_online_cpu(cpu) {
 		nid = cpu_to_node(cpu);
-		pdev = &sync_dev[sync_id];
+		pdev = &async_dev[async_id];
 
 		*pdev = test_platform_device_register_node("test_async_driver",
 							   async_id,
diff --git a/drivers/clk/clk-devres.c b/drivers/clk/clk-devres.c
index f9d5b7334341..4fb4fd4b06bd 100644
--- a/drivers/clk/clk-devres.c
+++ b/drivers/clk/clk-devres.c
@@ -4,42 +4,101 @@
 #include <linux/export.h>
 #include <linux/gfp.h>
 
+struct devm_clk_state {
+	struct clk *clk;
+	void (*exit)(struct clk *clk);
+};
+
 static void devm_clk_release(struct device *dev, void *res)
 {
-	clk_put(*(struct clk **)res);
+	struct devm_clk_state *state = res;
+
+	if (state->exit)
+		state->exit(state->clk);
+
+	clk_put(state->clk);
 }
 
-struct clk *devm_clk_get(struct device *dev, const char *id)
+static struct clk *__devm_clk_get(struct device *dev, const char *id,
+				  struct clk *(*get)(struct device *dev, const char *id),
+				  int (*init)(struct clk *clk),
+				  void (*exit)(struct clk *clk))
 {
-	struct clk **ptr, *clk;
+	struct devm_clk_state *state;
+	struct clk *clk;
+	int ret;
 
-	ptr = devres_alloc(devm_clk_release, sizeof(*ptr), GFP_KERNEL);
-	if (!ptr)
+	state = devres_alloc(devm_clk_release, sizeof(*state), GFP_KERNEL);
+	if (!state)
 		return ERR_PTR(-ENOMEM);
 
-	clk = clk_get(dev, id);
-	if (!IS_ERR(clk)) {
-		*ptr = clk;
-		devres_add(dev, ptr);
-	} else {
-		devres_free(ptr);
+	clk = get(dev, id);
+	if (IS_ERR(clk)) {
+		ret = PTR_ERR(clk);
+		goto err_clk_get;
 	}
 
+	if (init) {
+		ret = init(clk);
+		if (ret)
+			goto err_clk_init;
+	}
+
+	state->clk = clk;
+	state->exit = exit;
+
+	devres_add(dev, state);
+
 	return clk;
+
+err_clk_init:
+
+	clk_put(clk);
+err_clk_get:
+
+	devres_free(state);
+	return ERR_PTR(ret);
+}
+
+struct clk *devm_clk_get(struct device *dev, const char *id)
+{
+	return __devm_clk_get(dev, id, clk_get, NULL, NULL);
 }
 EXPORT_SYMBOL(devm_clk_get);
 
-struct clk *devm_clk_get_optional(struct device *dev, const char *id)
+struct clk *devm_clk_get_prepared(struct device *dev, const char *id)
 {
-	struct clk *clk = devm_clk_get(dev, id);
+	return __devm_clk_get(dev, id, clk_get, clk_prepare, clk_unprepare);
+}
+EXPORT_SYMBOL_GPL(devm_clk_get_prepared);
 
-	if (clk == ERR_PTR(-ENOENT))
-		return NULL;
+struct clk *devm_clk_get_enabled(struct device *dev, const char *id)
+{
+	return __devm_clk_get(dev, id, clk_get,
+			      clk_prepare_enable, clk_disable_unprepare);
+}
+EXPORT_SYMBOL_GPL(devm_clk_get_enabled);
 
-	return clk;
+struct clk *devm_clk_get_optional(struct device *dev, const char *id)
+{
+	return __devm_clk_get(dev, id, clk_get_optional, NULL, NULL);
 }
 EXPORT_SYMBOL(devm_clk_get_optional);
 
+struct clk *devm_clk_get_optional_prepared(struct device *dev, const char *id)
+{
+	return __devm_clk_get(dev, id, clk_get_optional,
+			      clk_prepare, clk_unprepare);
+}
+EXPORT_SYMBOL_GPL(devm_clk_get_optional_prepared);
+
+struct clk *devm_clk_get_optional_enabled(struct device *dev, const char *id)
+{
+	return __devm_clk_get(dev, id, clk_get_optional,
+			      clk_prepare_enable, clk_disable_unprepare);
+}
+EXPORT_SYMBOL_GPL(devm_clk_get_optional_enabled);
+
 struct clk_bulk_devres {
 	struct clk_bulk_data *clks;
 	int num_clks;
diff --git a/drivers/cpufreq/armada-37xx-cpufreq.c b/drivers/cpufreq/armada-37xx-cpufreq.c
index 2de7fd18f66a..f0be8a43ec49 100644
--- a/drivers/cpufreq/armada-37xx-cpufreq.c
+++ b/drivers/cpufreq/armada-37xx-cpufreq.c
@@ -443,7 +443,7 @@ static int __init armada37xx_cpufreq_driver_init(void)
 		return -ENODEV;
 	}
 
-	clk = clk_get(cpu_dev, 0);
+	clk = clk_get(cpu_dev, NULL);
 	if (IS_ERR(clk)) {
 		dev_err(cpu_dev, "Cannot get clock for CPU0\n");
 		return PTR_ERR(clk);
diff --git a/drivers/cpufreq/cpufreq-dt-platdev.c b/drivers/cpufreq/cpufreq-dt-platdev.c
index a3734014db47..aea285651fba 100644
--- a/drivers/cpufreq/cpufreq-dt-platdev.c
+++ b/drivers/cpufreq/cpufreq-dt-platdev.c
@@ -130,6 +130,7 @@ static const struct of_device_id blacklist[] __initconst = {
 	{ .compatible = "nvidia,tegra30", },
 	{ .compatible = "nvidia,tegra124", },
 	{ .compatible = "nvidia,tegra210", },
+	{ .compatible = "nvidia,tegra234", },
 
 	{ .compatible = "qcom,apq8096", },
 	{ .compatible = "qcom,msm8996", },
diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index af3ee288bc11..4ec7bb58c195 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -451,7 +451,8 @@ static int dma_chan_get(struct dma_chan *chan)
 	/* The channel is already in use, update client count */
 	if (chan->client_count) {
 		__module_get(owner);
-		goto out;
+		chan->client_count++;
+		return 0;
 	}
 
 	if (!try_module_get(owner))
@@ -470,11 +471,11 @@ static int dma_chan_get(struct dma_chan *chan)
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
diff --git a/drivers/dma/xilinx/xilinx_dma.c b/drivers/dma/xilinx/xilinx_dma.c
index e76adc31ab66..12ad4bb3c5f2 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -3119,8 +3119,10 @@ static int xilinx_dma_probe(struct platform_device *pdev)
 	/* Initialize the channels */
 	for_each_child_of_node(node, child) {
 		err = xilinx_dma_child_probe(xdev, child);
-		if (err < 0)
+		if (err < 0) {
+			of_node_put(child);
 			goto error;
+		}
 	}
 
 	if (xdev->dma_config->dmatype == XDMA_TYPE_VDMA) {
diff --git a/drivers/edac/edac_device.c b/drivers/edac/edac_device.c
index 8220ce5b87ca..85c229985f90 100644
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
index 61b76ec226af..19fba258ae10 100644
--- a/drivers/edac/highbank_mc_edac.c
+++ b/drivers/edac/highbank_mc_edac.c
@@ -174,8 +174,10 @@ static int highbank_mc_probe(struct platform_device *pdev)
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
@@ -243,6 +245,7 @@ static int highbank_mc_probe(struct platform_device *pdev)
 	edac_mc_del_mc(&pdev->dev);
 err:
 	devres_release_group(&pdev->dev, NULL);
+free:
 	edac_mc_free(mci);
 	return res;
 }
diff --git a/drivers/edac/qcom_edac.c b/drivers/edac/qcom_edac.c
index 97a27e42dd61..c45519f59dc1 100644
--- a/drivers/edac/qcom_edac.c
+++ b/drivers/edac/qcom_edac.c
@@ -252,7 +252,7 @@ dump_syn_reg_values(struct llcc_drv_data *drv, u32 bank, int err_type)
 static int
 dump_syn_reg(struct edac_device_ctl_info *edev_ctl, int err_type, u32 bank)
 {
-	struct llcc_drv_data *drv = edev_ctl->pvt_info;
+	struct llcc_drv_data *drv = edev_ctl->dev->platform_data;
 	int ret;
 
 	ret = dump_syn_reg_values(drv, bank, err_type);
@@ -289,7 +289,7 @@ static irqreturn_t
 llcc_ecc_irq_handler(int irq, void *edev_ctl)
 {
 	struct edac_device_ctl_info *edac_dev_ctl = edev_ctl;
-	struct llcc_drv_data *drv = edac_dev_ctl->pvt_info;
+	struct llcc_drv_data *drv = edac_dev_ctl->dev->platform_data;
 	irqreturn_t irq_rc = IRQ_NONE;
 	u32 drp_error, trp_error, i;
 	int ret;
@@ -358,7 +358,6 @@ static int qcom_llcc_edac_probe(struct platform_device *pdev)
 	edev_ctl->dev_name = dev_name(dev);
 	edev_ctl->ctl_name = "llcc";
 	edev_ctl->panic_on_ue = LLCC_ERP_PANIC_ON_UE;
-	edev_ctl->pvt_info = llcc_driv_data;
 
 	rc = edac_device_add_device(edev_ctl);
 	if (rc)
diff --git a/drivers/firmware/arm_scmi/shmem.c b/drivers/firmware/arm_scmi/shmem.c
index 0e3eaea5d852..56a1f61aa3ff 100644
--- a/drivers/firmware/arm_scmi/shmem.c
+++ b/drivers/firmware/arm_scmi/shmem.c
@@ -58,10 +58,11 @@ u32 shmem_read_header(struct scmi_shared_mem __iomem *shmem)
 void shmem_fetch_response(struct scmi_shared_mem __iomem *shmem,
 			  struct scmi_xfer *xfer)
 {
+	size_t len = ioread32(&shmem->length);
+
 	xfer->hdr.status = ioread32(shmem->msg_payload);
 	/* Skip the length of header and status in shmem area i.e 8 bytes */
-	xfer->rx.len = min_t(size_t, xfer->rx.len,
-			     ioread32(&shmem->length) - 8);
+	xfer->rx.len = min_t(size_t, xfer->rx.len, len > 8 ? len - 8 : 0);
 
 	/* Take a copy to the rx buffer.. */
 	memcpy_fromio(xfer->rx.buf, shmem->msg_payload + 4, xfer->rx.len);
@@ -70,8 +71,10 @@ void shmem_fetch_response(struct scmi_shared_mem __iomem *shmem,
 void shmem_fetch_notification(struct scmi_shared_mem __iomem *shmem,
 			      size_t max_len, struct scmi_xfer *xfer)
 {
+	size_t len = ioread32(&shmem->length);
+
 	/* Skip only the length of header in shmem area i.e 4 bytes */
-	xfer->rx.len = min_t(size_t, max_len, ioread32(&shmem->length) - 4);
+	xfer->rx.len = min_t(size_t, max_len, len > 4 ? len - 4 : 0);
 
 	/* Take a copy to the rx buffer.. */
 	memcpy_fromio(xfer->rx.buf, shmem->msg_payload, xfer->rx.len);
diff --git a/drivers/gpio/gpio-mxc.c b/drivers/gpio/gpio-mxc.c
index ba6ed2a413f5..0d5a9fee3c70 100644
--- a/drivers/gpio/gpio-mxc.c
+++ b/drivers/gpio/gpio-mxc.c
@@ -231,7 +231,7 @@ static int gpio_set_irq_type(struct irq_data *d, u32 type)
 
 	writel(1 << gpio_idx, port->base + GPIO_ISR);
 
-	return 0;
+	return port->gc.direction_input(&port->gc, gpio_idx);
 }
 
 static void mxc_flip_edge(struct mxc_gpio_port *port, u32 gpio)
diff --git a/drivers/gpu/drm/drm_panel_orientation_quirks.c b/drivers/gpu/drm/drm_panel_orientation_quirks.c
index ca0fefeaab20..ce739ba45c55 100644
--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -272,6 +272,12 @@ static const struct dmi_system_id orientation_data[] = {
 		  DMI_EXACT_MATCH(DMI_PRODUCT_VERSION, "Lenovo ideapad D330-10IGM"),
 		},
 		.driver_data = (void *)&lcd1200x1920_rightside_up,
+	}, {	/* Lenovo Ideapad D330-10IGL (HD) */
+		.matches = {
+		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+		  DMI_EXACT_MATCH(DMI_PRODUCT_VERSION, "Lenovo ideapad D330-10IGL"),
+		},
+		.driver_data = (void *)&lcd800x1280_rightside_up,
 	}, {	/* Lenovo Yoga Book X90F / X91F / X91L */
 		.matches = {
 		  /* Non exact match to match all versions */
diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.c b/drivers/gpu/drm/nouveau/nouveau_bo.c
index b57dcad8865f..7633f56bc0a4 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bo.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
@@ -823,6 +823,15 @@ nouveau_bo_move_m2mf(struct ttm_buffer_object *bo, int evict, bool intr,
 		if (ret == 0) {
 			ret = nouveau_fence_new(chan, false, &fence);
 			if (ret == 0) {
+				/* TODO: figure out a better solution here
+				 *
+				 * wait on the fence here explicitly as going through
+				 * ttm_bo_move_accel_cleanup somehow doesn't seem to do it.
+				 *
+				 * Without this the operation can timeout and we'll fallback to a
+				 * software copy, which might take several minutes to finish.
+				 */
+				nouveau_fence_wait(fence, false, false);
 				ret = ttm_bo_move_accel_cleanup(bo,
 								&fence->base,
 								evict, false,
diff --git a/drivers/gpu/drm/panfrost/Kconfig b/drivers/gpu/drm/panfrost/Kconfig
index 86cdc0ce79e6..77f4d32e5204 100644
--- a/drivers/gpu/drm/panfrost/Kconfig
+++ b/drivers/gpu/drm/panfrost/Kconfig
@@ -3,7 +3,8 @@
 config DRM_PANFROST
 	tristate "Panfrost (DRM support for ARM Mali Midgard/Bifrost GPUs)"
 	depends on DRM
-	depends on ARM || ARM64 || (COMPILE_TEST && !GENERIC_ATOMIC64)
+	depends on ARM || ARM64 || COMPILE_TEST
+	depends on !GENERIC_ATOMIC64    # for IOMMU_IO_PGTABLE_LPAE
 	depends on MMU
 	select DRM_SCHED
 	select IOMMU_SUPPORT
diff --git a/drivers/hid/hid-betopff.c b/drivers/hid/hid-betopff.c
index 467d789f9bc2..25ed7b9a917e 100644
--- a/drivers/hid/hid-betopff.c
+++ b/drivers/hid/hid-betopff.c
@@ -60,7 +60,6 @@ static int betopff_init(struct hid_device *hid)
 	struct list_head *report_list =
 			&hid->report_enum[HID_OUTPUT_REPORT].report_list;
 	struct input_dev *dev;
-	int field_count = 0;
 	int error;
 	int i, j;
 
@@ -86,19 +85,21 @@ static int betopff_init(struct hid_device *hid)
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
diff --git a/drivers/hid/hid-bigbenff.c b/drivers/hid/hid-bigbenff.c
index e8c5e3ac9fff..e8b16665860d 100644
--- a/drivers/hid/hid-bigbenff.c
+++ b/drivers/hid/hid-bigbenff.c
@@ -344,6 +344,11 @@ static int bigben_probe(struct hid_device *hid,
 	}
 
 	report_list = &hid->report_enum[HID_OUTPUT_REPORT].report_list;
+	if (list_empty(report_list)) {
+		hid_err(hid, "no output report found\n");
+		error = -ENODEV;
+		goto error_hw_stop;
+	}
 	bigben->report = list_entry(report_list->next,
 		struct hid_report, list);
 
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index eaaf732f0630..baadead947c8 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -988,8 +988,8 @@ struct hid_report *hid_validate_values(struct hid_device *hid,
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
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 09c3f30f10d3..1d1306a6004e 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -257,7 +257,6 @@
 #define USB_DEVICE_ID_CH_AXIS_295	0x001c
 
 #define USB_VENDOR_ID_CHERRY		0x046a
-#define USB_DEVICE_ID_CHERRY_MOUSE_000C	0x000c
 #define USB_DEVICE_ID_CHERRY_CYMOTION	0x0023
 #define USB_DEVICE_ID_CHERRY_CYMOTION_SOLAR	0x0027
 
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index 1efde40e5136..9f1fcbea19eb 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -54,7 +54,6 @@ static const struct hid_device_id hid_quirks[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CH, USB_DEVICE_ID_CH_FLIGHT_SIM_YOKE), HID_QUIRK_NOGET },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CH, USB_DEVICE_ID_CH_PRO_PEDALS), HID_QUIRK_NOGET },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CH, USB_DEVICE_ID_CH_PRO_THROTTLE), HID_QUIRK_NOGET },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_CHERRY, USB_DEVICE_ID_CHERRY_MOUSE_000C), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CORSAIR, USB_DEVICE_ID_CORSAIR_K65RGB), HID_QUIRK_NO_INIT_REPORTS },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CORSAIR, USB_DEVICE_ID_CORSAIR_K65RGB_RAPIDFIRE), HID_QUIRK_NO_INIT_REPORTS | HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CORSAIR, USB_DEVICE_ID_CORSAIR_K70RGB), HID_QUIRK_NO_INIT_REPORTS },
diff --git a/drivers/hid/intel-ish-hid/ishtp/dma-if.c b/drivers/hid/intel-ish-hid/ishtp/dma-if.c
index 40554c8daca0..00046cbfd4ed 100644
--- a/drivers/hid/intel-ish-hid/ishtp/dma-if.c
+++ b/drivers/hid/intel-ish-hid/ishtp/dma-if.c
@@ -104,6 +104,11 @@ void *ishtp_cl_get_dma_send_buf(struct ishtp_device *dev,
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
@@ -150,6 +155,11 @@ void ishtp_cl_release_dma_acked_mem(struct ishtp_device *dev,
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
diff --git a/drivers/i2c/busses/i2c-designware-common.c b/drivers/i2c/busses/i2c-designware-common.c
index 9468c6c89b3f..682fffaab2b4 100644
--- a/drivers/i2c/busses/i2c-designware-common.c
+++ b/drivers/i2c/busses/i2c-designware-common.c
@@ -24,6 +24,7 @@
 #include <linux/regmap.h>
 #include <linux/swab.h>
 #include <linux/types.h>
+#include <linux/units.h>
 
 #include "i2c-designware-core.h"
 
@@ -347,7 +348,8 @@ u32 i2c_dw_scl_hcnt(u32 ic_clk, u32 tSYMBOL, u32 tf, int cond, int offset)
 		 *
 		 * If your hardware is free from tHD;STA issue, try this one.
 		 */
-		return (ic_clk * tSYMBOL + 500000) / 1000000 - 8 + offset;
+		return DIV_ROUND_CLOSEST_ULL((u64)ic_clk * tSYMBOL, MICRO) -
+		       8 + offset;
 	else
 		/*
 		 * Conditional expression:
@@ -363,8 +365,8 @@ u32 i2c_dw_scl_hcnt(u32 ic_clk, u32 tSYMBOL, u32 tf, int cond, int offset)
 		 * The reason why we need to take into account "tf" here,
 		 * is the same as described in i2c_dw_scl_lcnt().
 		 */
-		return (ic_clk * (tSYMBOL + tf) + 500000) / 1000000
-			- 3 + offset;
+		return DIV_ROUND_CLOSEST_ULL((u64)ic_clk * (tSYMBOL + tf), MICRO) -
+		       3 + offset;
 }
 
 u32 i2c_dw_scl_lcnt(u32 ic_clk, u32 tLOW, u32 tf, int offset)
@@ -380,7 +382,8 @@ u32 i2c_dw_scl_lcnt(u32 ic_clk, u32 tLOW, u32 tf, int offset)
 	 * account the fall time of SCL signal (tf).  Default tf value
 	 * should be 0.3 us, for safety.
 	 */
-	return ((ic_clk * (tLOW + tf) + 500000) / 1000000) - 1 + offset;
+	return DIV_ROUND_CLOSEST_ULL((u64)ic_clk * (tLOW + tf), MICRO) -
+	       1 + offset;
 }
 
 int i2c_dw_set_sda_hold(struct dw_i2c_dev *dev)
diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/busses/i2c-designware-platdrv.c
index ad91c7c0faa5..474754151725 100644
--- a/drivers/i2c/busses/i2c-designware-platdrv.c
+++ b/drivers/i2c/busses/i2c-designware-platdrv.c
@@ -32,12 +32,13 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/suspend.h>
+#include <linux/units.h>
 
 #include "i2c-designware-core.h"
 
 static u32 i2c_dw_get_clk_rate_khz(struct dw_i2c_dev *dev)
 {
-	return clk_get_rate(dev->clk)/1000;
+	return clk_get_rate(dev->clk) / KILO;
 }
 
 #ifdef CONFIG_ACPI
@@ -284,7 +285,7 @@ static int dw_i2c_plat_probe(struct platform_device *pdev)
 
 		if (!dev->sda_hold_time && t->sda_hold_ns)
 			dev->sda_hold_time =
-				div_u64(clk_khz * t->sda_hold_ns + 500000, 1000000);
+				DIV_S64_ROUND_CLOSEST(clk_khz * t->sda_hold_ns, MICRO);
 	}
 
 	adap = &dev->adapter;
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 5889639e90a1..5123be0ab02f 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -2911,15 +2911,18 @@ EXPORT_SYMBOL(__rdma_block_iter_start);
 bool __rdma_block_iter_next(struct ib_block_iter *biter)
 {
 	unsigned int block_offset;
+	unsigned int sg_delta;
 
 	if (!biter->__sg_nents || !biter->__sg)
 		return false;
 
 	biter->__dma_addr = sg_dma_address(biter->__sg) + biter->__sg_advance;
 	block_offset = biter->__dma_addr & (BIT_ULL(biter->__pg_bit) - 1);
-	biter->__sg_advance += BIT_ULL(biter->__pg_bit) - block_offset;
+	sg_delta = BIT_ULL(biter->__pg_bit) - block_offset;
 
-	if (biter->__sg_advance >= sg_dma_len(biter->__sg)) {
+	if (sg_dma_len(biter->__sg) - biter->__sg_advance > sg_delta) {
+		biter->__sg_advance += sg_delta;
+	} else {
 		biter->__sg_advance = 0;
 		biter->__sg = sg_next(biter->__sg);
 		biter->__sg_nents--;
diff --git a/drivers/infiniband/hw/hfi1/user_exp_rcv.c b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
index b94fc7fd75a9..897923981855 100644
--- a/drivers/infiniband/hw/hfi1/user_exp_rcv.c
+++ b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
@@ -65,18 +65,25 @@ static void cacheless_tid_rb_remove(struct hfi1_filedata *fdata,
 static bool tid_rb_invalidate(struct mmu_interval_notifier *mni,
 			      const struct mmu_notifier_range *range,
 			      unsigned long cur_seq);
+static bool tid_cover_invalidate(struct mmu_interval_notifier *mni,
+			         const struct mmu_notifier_range *range,
+			         unsigned long cur_seq);
 static int program_rcvarray(struct hfi1_filedata *fd, struct tid_user_buf *,
 			    struct tid_group *grp,
 			    unsigned int start, u16 count,
 			    u32 *tidlist, unsigned int *tididx,
 			    unsigned int *pmapped);
-static int unprogram_rcvarray(struct hfi1_filedata *fd, u32 tidinfo,
-			      struct tid_group **grp);
+static int unprogram_rcvarray(struct hfi1_filedata *fd, u32 tidinfo);
+static void __clear_tid_node(struct hfi1_filedata *fd,
+			     struct tid_rb_node *node);
 static void clear_tid_node(struct hfi1_filedata *fd, struct tid_rb_node *node);
 
 static const struct mmu_interval_notifier_ops tid_mn_ops = {
 	.invalidate = tid_rb_invalidate,
 };
+static const struct mmu_interval_notifier_ops tid_cover_ops = {
+	.invalidate = tid_cover_invalidate,
+};
 
 /*
  * Initialize context and file private data needed for Expected
@@ -295,53 +302,65 @@ int hfi1_user_exp_rcv_setup(struct hfi1_filedata *fd,
 		tididx = 0, mapped, mapped_pages = 0;
 	u32 *tidlist = NULL;
 	struct tid_user_buf *tidbuf;
+	unsigned long mmu_seq = 0;
 
 	if (!PAGE_ALIGNED(tinfo->vaddr))
 		return -EINVAL;
+	if (tinfo->length == 0)
+		return -EINVAL;
 
 	tidbuf = kzalloc(sizeof(*tidbuf), GFP_KERNEL);
 	if (!tidbuf)
 		return -ENOMEM;
 
+	mutex_init(&tidbuf->cover_mutex);
 	tidbuf->vaddr = tinfo->vaddr;
 	tidbuf->length = tinfo->length;
 	tidbuf->psets = kcalloc(uctxt->expected_count, sizeof(*tidbuf->psets),
 				GFP_KERNEL);
 	if (!tidbuf->psets) {
-		kfree(tidbuf);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto fail_release_mem;
+	}
+
+	if (fd->use_mn) {
+		ret = mmu_interval_notifier_insert(
+			&tidbuf->notifier, current->mm,
+			tidbuf->vaddr, tidbuf->npages * PAGE_SIZE,
+			&tid_cover_ops);
+		if (ret)
+			goto fail_release_mem;
+		mmu_seq = mmu_interval_read_begin(&tidbuf->notifier);
 	}
 
 	pinned = pin_rcv_pages(fd, tidbuf);
 	if (pinned <= 0) {
-		kfree(tidbuf->psets);
-		kfree(tidbuf);
-		return pinned;
+		ret = (pinned < 0) ? pinned : -ENOSPC;
+		goto fail_unpin;
 	}
 
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
 
-	if (!pageset_count)
-		goto bail;
+	if (!pageset_count) {
+		ret = -ENOSPC;
+		goto fail_unreserve;
+	}
 
 	ngroups = pageset_count / dd->rcv_entries.group_size;
 	tidlist = kcalloc(pageset_count, sizeof(*tidlist), GFP_KERNEL);
 	if (!tidlist) {
 		ret = -ENOMEM;
-		goto nomem;
+		goto fail_unreserve;
 	}
 
 	tididx = 0;
@@ -437,43 +456,78 @@ int hfi1_user_exp_rcv_setup(struct hfi1_filedata *fd,
 	}
 unlock:
 	mutex_unlock(&uctxt->exp_mutex);
-nomem:
 	hfi1_cdbg(TID, "total mapped: tidpairs:%u pages:%u (%d)", tididx,
 		  mapped_pages, ret);
-	if (tididx) {
-		spin_lock(&fd->tid_lock);
-		fd->tid_used += tididx;
-		spin_unlock(&fd->tid_lock);
-		tinfo->tidcnt = tididx;
-		tinfo->length = mapped_pages * PAGE_SIZE;
-
-		if (copy_to_user(u64_to_user_ptr(tinfo->tidlist),
-				 tidlist, sizeof(tidlist[0]) * tididx)) {
-			/*
-			 * On failure to copy to the user level, we need to undo
-			 * everything done so far so we don't leak resources.
-			 */
-			tinfo->tidlist = (unsigned long)&tidlist;
-			hfi1_user_exp_rcv_clear(fd, tinfo);
-			tinfo->tidlist = 0;
-			ret = -EFAULT;
-			goto bail;
+
+	/* fail if nothing was programmed, set error if none provided */
+	if (tididx == 0) {
+		if (ret >= 0)
+			ret = -ENOSPC;
+		goto fail_unreserve;
+	}
+
+	/* adjust reserved tid_used to actual count */
+	spin_lock(&fd->tid_lock);
+	fd->tid_used -= pageset_count - tididx;
+	spin_unlock(&fd->tid_lock);
+
+	/* unpin all pages not covered by a TID */
+	unpin_rcv_pages(fd, tidbuf, NULL, mapped_pages, pinned - mapped_pages,
+			false);
+
+	if (fd->use_mn) {
+		/* check for an invalidate during setup */
+		bool fail = false;
+
+		mutex_lock(&tidbuf->cover_mutex);
+		fail = mmu_interval_read_retry(&tidbuf->notifier, mmu_seq);
+		mutex_unlock(&tidbuf->cover_mutex);
+
+		if (fail) {
+			ret = -EBUSY;
+			goto fail_unprogram;
 		}
 	}
 
-	/*
-	 * If not everything was mapped (due to insufficient RcvArray entries,
-	 * for example), unpin all unmapped pages so we can pin them nex time.
-	 */
-	if (mapped_pages != pinned)
-		unpin_rcv_pages(fd, tidbuf, NULL, mapped_pages,
-				(pinned - mapped_pages), false);
-bail:
+	tinfo->tidcnt = tididx;
+	tinfo->length = mapped_pages * PAGE_SIZE;
+
+	if (copy_to_user(u64_to_user_ptr(tinfo->tidlist),
+			 tidlist, sizeof(tidlist[0]) * tididx)) {
+		ret = -EFAULT;
+		goto fail_unprogram;
+	}
+
+	if (fd->use_mn)
+		mmu_interval_notifier_remove(&tidbuf->notifier);
+	kfree(tidbuf->pages);
 	kfree(tidbuf->psets);
+	kfree(tidbuf);
 	kfree(tidlist);
+	return 0;
+
+fail_unprogram:
+	/* unprogram, unmap, and unpin all allocated TIDs */
+	tinfo->tidlist = (unsigned long)tidlist;
+	hfi1_user_exp_rcv_clear(fd, tinfo);
+	tinfo->tidlist = 0;
+	pinned = 0;		/* nothing left to unpin */
+	pageset_count = 0;	/* nothing left reserved */
+fail_unreserve:
+	spin_lock(&fd->tid_lock);
+	fd->tid_used -= pageset_count;
+	spin_unlock(&fd->tid_lock);
+fail_unpin:
+	if (fd->use_mn)
+		mmu_interval_notifier_remove(&tidbuf->notifier);
+	if (pinned > 0)
+		unpin_rcv_pages(fd, tidbuf, NULL, 0, pinned, false);
+fail_release_mem:
 	kfree(tidbuf->pages);
+	kfree(tidbuf->psets);
 	kfree(tidbuf);
-	return ret > 0 ? 0 : ret;
+	kfree(tidlist);
+	return ret;
 }
 
 int hfi1_user_exp_rcv_clear(struct hfi1_filedata *fd,
@@ -494,7 +548,7 @@ int hfi1_user_exp_rcv_clear(struct hfi1_filedata *fd,
 
 	mutex_lock(&uctxt->exp_mutex);
 	for (tididx = 0; tididx < tinfo->tidcnt; tididx++) {
-		ret = unprogram_rcvarray(fd, tidinfo[tididx], NULL);
+		ret = unprogram_rcvarray(fd, tidinfo[tididx]);
 		if (ret) {
 			hfi1_cdbg(TID, "Failed to unprogram rcv array %d",
 				  ret);
@@ -750,6 +804,7 @@ static int set_rcvarray_entry(struct hfi1_filedata *fd,
 	}
 
 	node->fdata = fd;
+	mutex_init(&node->invalidate_mutex);
 	node->phys = page_to_phys(pages[0]);
 	node->npages = npages;
 	node->rcventry = rcventry;
@@ -765,11 +820,6 @@ static int set_rcvarray_entry(struct hfi1_filedata *fd,
 			&tid_mn_ops);
 		if (ret)
 			goto out_unmap;
-		/*
-		 * FIXME: This is in the wrong order, the notifier should be
-		 * established before the pages are pinned by pin_rcv_pages.
-		 */
-		mmu_interval_read_begin(&node->notifier);
 	}
 	fd->entry_to_rb[node->rcventry - uctxt->expected_base] = node;
 
@@ -789,8 +839,7 @@ static int set_rcvarray_entry(struct hfi1_filedata *fd,
 	return -EFAULT;
 }
 
-static int unprogram_rcvarray(struct hfi1_filedata *fd, u32 tidinfo,
-			      struct tid_group **grp)
+static int unprogram_rcvarray(struct hfi1_filedata *fd, u32 tidinfo)
 {
 	struct hfi1_ctxtdata *uctxt = fd->uctxt;
 	struct hfi1_devdata *dd = uctxt->dd;
@@ -813,9 +862,6 @@ static int unprogram_rcvarray(struct hfi1_filedata *fd, u32 tidinfo,
 	if (!node || node->rcventry != (uctxt->expected_base + rcventry))
 		return -EBADF;
 
-	if (grp)
-		*grp = node->grp;
-
 	if (fd->use_mn)
 		mmu_interval_notifier_remove(&node->notifier);
 	cacheless_tid_rb_remove(fd, node);
@@ -823,23 +869,34 @@ static int unprogram_rcvarray(struct hfi1_filedata *fd, u32 tidinfo,
 	return 0;
 }
 
-static void clear_tid_node(struct hfi1_filedata *fd, struct tid_rb_node *node)
+static void __clear_tid_node(struct hfi1_filedata *fd, struct tid_rb_node *node)
 {
 	struct hfi1_ctxtdata *uctxt = fd->uctxt;
 	struct hfi1_devdata *dd = uctxt->dd;
 
+	mutex_lock(&node->invalidate_mutex);
+	if (node->freed)
+		goto done;
+	node->freed = true;
+
 	trace_hfi1_exp_tid_unreg(uctxt->ctxt, fd->subctxt, node->rcventry,
 				 node->npages,
 				 node->notifier.interval_tree.start, node->phys,
 				 node->dma_addr);
 
-	/*
-	 * Make sure device has seen the write before we unpin the
-	 * pages.
-	 */
+	/* Make sure device has seen the write before pages are unpinned */
 	hfi1_put_tid(dd, node->rcventry, PT_INVALID_FLUSH, 0, 0);
 
 	unpin_rcv_pages(fd, NULL, node, 0, node->npages, true);
+done:
+	mutex_unlock(&node->invalidate_mutex);
+}
+
+static void clear_tid_node(struct hfi1_filedata *fd, struct tid_rb_node *node)
+{
+	struct hfi1_ctxtdata *uctxt = fd->uctxt;
+
+	__clear_tid_node(fd, node);
 
 	node->grp->used--;
 	node->grp->map &= ~(1 << (node->rcventry - node->grp->base));
@@ -898,10 +955,16 @@ static bool tid_rb_invalidate(struct mmu_interval_notifier *mni,
 	if (node->freed)
 		return true;
 
+	/* take action only if unmapping */
+	if (range->event != MMU_NOTIFY_UNMAP)
+		return true;
+
 	trace_hfi1_exp_tid_inval(uctxt->ctxt, fdata->subctxt,
 				 node->notifier.interval_tree.start,
 				 node->rcventry, node->npages, node->dma_addr);
-	node->freed = true;
+
+	/* clear the hardware rcvarray entry */
+	__clear_tid_node(fdata, node);
 
 	spin_lock(&fdata->invalid_lock);
 	if (fdata->invalid_tid_idx < uctxt->expected_count) {
@@ -931,6 +994,23 @@ static bool tid_rb_invalidate(struct mmu_interval_notifier *mni,
 	return true;
 }
 
+static bool tid_cover_invalidate(struct mmu_interval_notifier *mni,
+			         const struct mmu_notifier_range *range,
+			         unsigned long cur_seq)
+{
+	struct tid_user_buf *tidbuf =
+		container_of(mni, struct tid_user_buf, notifier);
+
+	/* take action only if unmapping */
+	if (range->event == MMU_NOTIFY_UNMAP) {
+		mutex_lock(&tidbuf->cover_mutex);
+		mmu_interval_set_seq(mni, cur_seq);
+		mutex_unlock(&tidbuf->cover_mutex);
+	}
+
+	return true;
+}
+
 static void cacheless_tid_rb_remove(struct hfi1_filedata *fdata,
 				    struct tid_rb_node *tnode)
 {
diff --git a/drivers/infiniband/hw/hfi1/user_exp_rcv.h b/drivers/infiniband/hw/hfi1/user_exp_rcv.h
index d45c7b6988d4..849f265f2f11 100644
--- a/drivers/infiniband/hw/hfi1/user_exp_rcv.h
+++ b/drivers/infiniband/hw/hfi1/user_exp_rcv.h
@@ -57,6 +57,8 @@ struct tid_pageset {
 };
 
 struct tid_user_buf {
+	struct mmu_interval_notifier notifier;
+	struct mutex cover_mutex;
 	unsigned long vaddr;
 	unsigned long length;
 	unsigned int npages;
@@ -68,6 +70,7 @@ struct tid_user_buf {
 struct tid_rb_node {
 	struct mmu_interval_notifier notifier;
 	struct hfi1_filedata *fdata;
+	struct mutex invalidate_mutex; /* covers hw removal */
 	unsigned long phys;
 	struct tid_group *grp;
 	u32 rcventry;
diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index f1013b950d57..82577095e175 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -191,7 +191,6 @@ static const char * const smbus_pnp_ids[] = {
 	"SYN3221", /* HP 15-ay000 */
 	"SYN323d", /* HP Spectre X360 13-w013dx */
 	"SYN3257", /* HP Envy 13-ad105ng */
-	"SYN3286", /* HP Laptop 15-da3001TU */
 	NULL
 };
 
diff --git a/drivers/memory/atmel-sdramc.c b/drivers/memory/atmel-sdramc.c
index 9c49d00c2a96..ea6e9e1eaf04 100644
--- a/drivers/memory/atmel-sdramc.c
+++ b/drivers/memory/atmel-sdramc.c
@@ -47,19 +47,17 @@ static int atmel_ramc_probe(struct platform_device *pdev)
 	caps = of_device_get_match_data(&pdev->dev);
 
 	if (caps->has_ddrck) {
-		clk = devm_clk_get(&pdev->dev, "ddrck");
+		clk = devm_clk_get_enabled(&pdev->dev, "ddrck");
 		if (IS_ERR(clk))
 			return PTR_ERR(clk);
-		clk_prepare_enable(clk);
 	}
 
 	if (caps->has_mpddr_clk) {
-		clk = devm_clk_get(&pdev->dev, "mpddr");
+		clk = devm_clk_get_enabled(&pdev->dev, "mpddr");
 		if (IS_ERR(clk)) {
 			pr_err("AT91 RAMC: couldn't get mpddr clock\n");
 			return PTR_ERR(clk);
 		}
-		clk_prepare_enable(clk);
 	}
 
 	return 0;
diff --git a/drivers/memory/mvebu-devbus.c b/drivers/memory/mvebu-devbus.c
index 8450638e8670..efc6c08db2b7 100644
--- a/drivers/memory/mvebu-devbus.c
+++ b/drivers/memory/mvebu-devbus.c
@@ -280,10 +280,9 @@ static int mvebu_devbus_probe(struct platform_device *pdev)
 	if (IS_ERR(devbus->base))
 		return PTR_ERR(devbus->base);
 
-	clk = devm_clk_get(&pdev->dev, NULL);
+	clk = devm_clk_get_enabled(&pdev->dev, NULL);
 	if (IS_ERR(clk))
 		return PTR_ERR(clk);
-	clk_prepare_enable(clk);
 
 	/*
 	 * Obtain clock period in picoseconds,
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index ece4c0512ee2..f42f2f4e4b60 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -678,10 +678,10 @@ static int ksz9477_port_fdb_del(struct dsa_switch *ds, int port,
 		ksz_read32(dev, REG_SW_ALU_VAL_D, &alu_table[3]);
 
 		/* clear forwarding port */
-		alu_table[2] &= ~BIT(port);
+		alu_table[1] &= ~BIT(port);
 
 		/* if there is no port to forward, clear table */
-		if ((alu_table[2] & ALU_V_PORT_MAP) == 0) {
+		if ((alu_table[1] & ALU_V_PORT_MAP) == 0) {
 			alu_table[0] = 0;
 			alu_table[1] = 0;
 			alu_table[2] = 0;
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-dev.c b/drivers/net/ethernet/amd/xgbe/xgbe-dev.c
index d5fd49dd25f3..decc1c09a031 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-dev.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-dev.c
@@ -524,19 +524,28 @@ static void xgbe_disable_vxlan(struct xgbe_prv_data *pdata)
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
@@ -553,9 +562,8 @@ static int xgbe_enable_tx_flow_control(struct xgbe_prv_data *pdata)
 {
 	struct ieee_pfc *pfc = pdata->pfc;
 	struct ieee_ets *ets = pdata->ets;
-	unsigned int max_q_count, q_count;
 	unsigned int reg, reg_val;
-	unsigned int i;
+	unsigned int i, q_count;
 
 	/* Set MTL flow control */
 	for (i = 0; i < pdata->rx_q_count; i++) {
@@ -579,8 +587,7 @@ static int xgbe_enable_tx_flow_control(struct xgbe_prv_data *pdata)
 	}
 
 	/* Set MAC flow control */
-	max_q_count = XGMAC_MAX_FLOW_CONTROL_QUEUES;
-	q_count = min_t(unsigned int, pdata->tx_q_count, max_q_count);
+	q_count = xgbe_get_fc_queue_count(pdata);
 	reg = MAC_Q0TFCR;
 	for (i = 0; i < q_count; i++) {
 		reg_val = XGMAC_IOREAD(pdata, reg);
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c b/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
index 0c5c1b155683..43fdd111235a 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
@@ -496,6 +496,7 @@ static enum xgbe_an xgbe_an73_tx_training(struct xgbe_prv_data *pdata,
 	reg |= XGBE_KR_TRAINING_ENABLE;
 	reg |= XGBE_KR_TRAINING_START;
 	XMDIO_WRITE(pdata, MDIO_MMD_PMAPMD, MDIO_PMA_10GBR_PMD_CTRL, reg);
+	pdata->kr_start_time = jiffies;
 
 	netif_dbg(pdata, link, pdata->netdev,
 		  "KR training initiated\n");
@@ -632,6 +633,8 @@ static enum xgbe_an xgbe_an73_incompat_link(struct xgbe_prv_data *pdata)
 
 	xgbe_switch_mode(pdata);
 
+	pdata->an_result = XGBE_AN_READY;
+
 	xgbe_an_restart(pdata);
 
 	return XGBE_AN_INCOMPAT_LINK;
@@ -1275,9 +1278,30 @@ static bool xgbe_phy_aneg_done(struct xgbe_prv_data *pdata)
 static void xgbe_check_link_timeout(struct xgbe_prv_data *pdata)
 {
 	unsigned long link_timeout;
+	unsigned long kr_time;
+	int wait;
 
 	link_timeout = pdata->link_check + (XGBE_LINK_TIMEOUT * HZ);
 	if (time_after(jiffies, link_timeout)) {
+		if ((xgbe_cur_mode(pdata) == XGBE_MODE_KR) &&
+		    pdata->phy.autoneg == AUTONEG_ENABLE) {
+			/* AN restart should not happen while KR training is in progress.
+			 * The while loop ensures no AN restart during KR training,
+			 * waits up to 500ms and AN restart is triggered only if KR
+			 * training is failed.
+			 */
+			wait = XGBE_KR_TRAINING_WAIT_ITER;
+			while (wait--) {
+				kr_time = pdata->kr_start_time +
+					  msecs_to_jiffies(XGBE_AN_MS_TIMEOUT);
+				if (time_after(jiffies, kr_time))
+					break;
+				/* AN restart is not required, if AN result is COMPLETE */
+				if (pdata->an_result == XGBE_AN_COMPLETE)
+					return;
+				usleep_range(10000, 11000);
+			}
+		}
 		netif_dbg(pdata, link, pdata->netdev, "AN link timeout\n");
 		xgbe_phy_config_aneg(pdata);
 	}
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe.h b/drivers/net/ethernet/amd/xgbe/xgbe.h
index 3305979a9f7c..e0b8f3c4cc0b 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe.h
+++ b/drivers/net/ethernet/amd/xgbe/xgbe.h
@@ -289,6 +289,7 @@
 /* Auto-negotiation */
 #define XGBE_AN_MS_TIMEOUT		500
 #define XGBE_LINK_TIMEOUT		5
+#define XGBE_KR_TRAINING_WAIT_ITER	50
 
 #define XGBE_SGMII_AN_LINK_STATUS	BIT(1)
 #define XGBE_SGMII_AN_LINK_SPEED	(BIT(2) | BIT(3))
@@ -1253,6 +1254,7 @@ struct xgbe_prv_data {
 	unsigned int parallel_detect;
 	unsigned int fec_ability;
 	unsigned long an_start;
+	unsigned long kr_start_time;
 	enum xgbe_an_mode an_mode;
 
 	/* I2C support */
diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index be96116dc2cc..613ca6124e3c 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -11185,7 +11185,7 @@ static void tg3_reset_task(struct work_struct *work)
 	rtnl_lock();
 	tg3_full_lock(tp, 0);
 
-	if (!netif_running(tp->dev)) {
+	if (tp->pcierr_recovery || !netif_running(tp->dev)) {
 		tg3_flag_clear(tp, RESET_TASK_PENDING);
 		tg3_full_unlock(tp);
 		rtnl_unlock();
@@ -18179,6 +18179,9 @@ static pci_ers_result_t tg3_io_error_detected(struct pci_dev *pdev,
 
 	netdev_info(netdev, "PCI I/O error detected\n");
 
+	/* Want to make sure that the reset task doesn't run */
+	tg3_reset_task_cancel(tp);
+
 	rtnl_lock();
 
 	/* Could be second call or maybe we don't have netdev yet */
@@ -18195,9 +18198,6 @@ static pci_ers_result_t tg3_io_error_detected(struct pci_dev *pdev,
 
 	tg3_timer_stop(tp);
 
-	/* Want to make sure that the reset task doesn't run */
-	tg3_reset_task_cancel(tp);
-
 	netif_device_detach(netdev);
 
 	/* Clean up software state, even if MMIO is blocked */
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 792c8147c2c4..e0d62e251387 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -1963,7 +1963,6 @@ static int macb_pad_and_fcs(struct sk_buff **skb, struct net_device *ndev)
 	bool cloned = skb_cloned(*skb) || skb_header_cloned(*skb) ||
 		      skb_is_nonlinear(*skb);
 	int padlen = ETH_ZLEN - (*skb)->len;
-	int headroom = skb_headroom(*skb);
 	int tailroom = skb_tailroom(*skb);
 	struct sk_buff *nskb;
 	u32 fcs;
@@ -1977,9 +1976,6 @@ static int macb_pad_and_fcs(struct sk_buff **skb, struct net_device *ndev)
 		/* FCS could be appeded to tailroom. */
 		if (tailroom >= ETH_FCS_LEN)
 			goto add_fcs;
-		/* FCS could be appeded by moving data to headroom. */
-		else if (!cloned && headroom + tailroom >= ETH_FCS_LEN)
-			padlen = 0;
 		/* No room for FCS, need to reallocate skb. */
 		else
 			padlen = ETH_FCS_LEN;
@@ -1988,10 +1984,7 @@ static int macb_pad_and_fcs(struct sk_buff **skb, struct net_device *ndev)
 		padlen += ETH_FCS_LEN;
 	}
 
-	if (!cloned && headroom + tailroom >= padlen) {
-		(*skb)->data = memmove((*skb)->head, (*skb)->data, (*skb)->len);
-		skb_set_tail_pointer(*skb, (*skb)->len);
-	} else {
+	if (cloned || tailroom < padlen) {
 		nskb = skb_copy_expand(*skb, 0, padlen, GFP_ATOMIC);
 		if (!nskb)
 			return -ENOMEM;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 29bc1df28aeb..112eaef186e1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1642,7 +1642,7 @@ static void mlx5_core_verify_params(void)
 	}
 }
 
-static int __init init(void)
+static int __init mlx5_init(void)
 {
 	int err;
 
@@ -1667,7 +1667,7 @@ static int __init init(void)
 	return err;
 }
 
-static void __exit cleanup(void)
+static void __exit mlx5_cleanup(void)
 {
 #ifdef CONFIG_MLX5_CORE_EN
 	mlx5e_cleanup();
@@ -1676,5 +1676,5 @@ static void __exit cleanup(void)
 	mlx5_unregister_debugfs();
 }
 
-module_init(init);
-module_exit(cleanup);
+module_init(mlx5_init);
+module_exit(mlx5_cleanup);
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 9ec6d63691aa..410ccd28f653 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -736,14 +736,14 @@ static void ravb_error_interrupt(struct net_device *ndev)
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
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 14ea0168b548..b52ca2fe04d8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1125,6 +1125,11 @@ static int stmmac_init_phy(struct net_device *dev)
 		int addr = priv->plat->phy_addr;
 		struct phy_device *phydev;
 
+		if (addr < 0) {
+			netdev_err(priv->dev, "no phy found\n");
+			return -ENODEV;
+		}
+
 		phydev = mdiobus_get_phy(priv->mii, addr);
 		if (!phydev) {
 			netdev_err(priv->dev, "no phy at addr %d\n", addr);
diff --git a/drivers/net/mdio/mdio-mux-meson-g12a.c b/drivers/net/mdio/mdio-mux-meson-g12a.c
index bf86c9c7a288..ab863530c9e8 100644
--- a/drivers/net/mdio/mdio-mux-meson-g12a.c
+++ b/drivers/net/mdio/mdio-mux-meson-g12a.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/bitfield.h>
+#include <linux/delay.h>
 #include <linux/clk.h>
 #include <linux/clk-provider.h>
 #include <linux/device.h>
@@ -150,6 +151,7 @@ static const struct clk_ops g12a_ephy_pll_ops = {
 
 static int g12a_enable_internal_mdio(struct g12a_mdio_mux *priv)
 {
+	u32 value;
 	int ret;
 
 	/* Enable the phy clock */
@@ -163,18 +165,25 @@ static int g12a_enable_internal_mdio(struct g12a_mdio_mux *priv)
 
 	/* Initialize ephy control */
 	writel(EPHY_G12A_ID, priv->regs + ETH_PHY_CNTL0);
-	writel(FIELD_PREP(PHY_CNTL1_ST_MODE, 3) |
-	       FIELD_PREP(PHY_CNTL1_ST_PHYADD, EPHY_DFLT_ADD) |
-	       FIELD_PREP(PHY_CNTL1_MII_MODE, EPHY_MODE_RMII) |
-	       PHY_CNTL1_CLK_EN |
-	       PHY_CNTL1_CLKFREQ |
-	       PHY_CNTL1_PHY_ENB,
-	       priv->regs + ETH_PHY_CNTL1);
+
+	/* Make sure we get a 0 -> 1 transition on the enable bit */
+	value = FIELD_PREP(PHY_CNTL1_ST_MODE, 3) |
+		FIELD_PREP(PHY_CNTL1_ST_PHYADD, EPHY_DFLT_ADD) |
+		FIELD_PREP(PHY_CNTL1_MII_MODE, EPHY_MODE_RMII) |
+		PHY_CNTL1_CLK_EN |
+		PHY_CNTL1_CLKFREQ;
+	writel(value, priv->regs + ETH_PHY_CNTL1);
 	writel(PHY_CNTL2_USE_INTERNAL |
 	       PHY_CNTL2_SMI_SRC_MAC |
 	       PHY_CNTL2_RX_CLK_EPHY,
 	       priv->regs + ETH_PHY_CNTL2);
 
+	value |= PHY_CNTL1_PHY_ENB;
+	writel(value, priv->regs + ETH_PHY_CNTL1);
+
+	/* The phy needs a bit of time to power up */
+	mdelay(10);
+
 	return 0;
 }
 
diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 77ba6c3c7a09..e9303be48655 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -108,7 +108,12 @@ EXPORT_SYMBOL(mdiobus_unregister_device);
 
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
index fce6713e970b..811c8751308c 100644
--- a/drivers/net/usb/sr9700.c
+++ b/drivers/net/usb/sr9700.c
@@ -410,7 +410,7 @@ static int sr9700_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 		/* ignore the CRC length */
 		len = (skb->data[1] | (skb->data[2] << 8)) - 4;
 
-		if (len > ETH_FRAME_LEN || len > skb->len)
+		if (len > ETH_FRAME_LEN || len > skb->len || len < 0)
 			return 0;
 
 		/* the last packet of current skb */
diff --git a/drivers/net/wan/fsl_ucc_hdlc.c b/drivers/net/wan/fsl_ucc_hdlc.c
index 7eac6a3e1cde..ae1ae65e7f90 100644
--- a/drivers/net/wan/fsl_ucc_hdlc.c
+++ b/drivers/net/wan/fsl_ucc_hdlc.c
@@ -1245,9 +1245,11 @@ static int ucc_hdlc_probe(struct platform_device *pdev)
 free_dev:
 	free_netdev(dev);
 undo_uhdlc_init:
-	iounmap(utdm->siram);
+	if (utdm)
+		iounmap(utdm->siram);
 unmap_si_regs:
-	iounmap(utdm->si_regs);
+	if (utdm)
+		iounmap(utdm->si_regs);
 free_utdm:
 	if (uhdlc_priv->tsa)
 		kfree(utdm);
diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 75b5d545b49e..dc076d844868 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -694,8 +694,8 @@ static int rndis_query_oid(struct usbnet *dev, u32 oid, void *data, int *len)
 		struct rndis_query	*get;
 		struct rndis_query_c	*get_c;
 	} u;
-	int ret, buflen;
-	int resplen, respoffs, copylen;
+	int ret;
+	size_t buflen, resplen, respoffs, copylen;
 
 	buflen = *len + sizeof(*u.get);
 	if (buflen < CONTROL_BUFFER_SIZE)
@@ -730,22 +730,15 @@ static int rndis_query_oid(struct usbnet *dev, u32 oid, void *data, int *len)
 
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
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 67dd68462b81..c47512da9872 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1292,7 +1292,7 @@ static enum blk_eh_timer_return nvme_timeout(struct request *req, bool reserved)
 	else
 		nvme_poll_irqdisable(nvmeq);
 
-	if (blk_mq_request_completed(req)) {
+	if (blk_mq_rq_state(req) != MQ_RQ_IN_FLIGHT) {
 		dev_warn(dev->ctrl.device,
 			 "I/O %d QID %d timeout, completion polled\n",
 			 req->tag, nvmeq->qid);
diff --git a/drivers/phy/rockchip/phy-rockchip-inno-usb2.c b/drivers/phy/rockchip/phy-rockchip-inno-usb2.c
index 46ebdb1460a3..cab6a94bf161 100644
--- a/drivers/phy/rockchip/phy-rockchip-inno-usb2.c
+++ b/drivers/phy/rockchip/phy-rockchip-inno-usb2.c
@@ -467,8 +467,10 @@ static int rockchip_usb2phy_power_on(struct phy *phy)
 		return ret;
 
 	ret = property_enable(base, &rport->port_cfg->phy_sus, false);
-	if (ret)
+	if (ret) {
+		clk_disable_unprepare(rphy->clk480m);
 		return ret;
+	}
 
 	/* waiting for the utmi_clk to become stable */
 	usleep_range(1500, 2000);
diff --git a/drivers/phy/ti/Kconfig b/drivers/phy/ti/Kconfig
index 15a3bcf32308..b905902d5750 100644
--- a/drivers/phy/ti/Kconfig
+++ b/drivers/phy/ti/Kconfig
@@ -23,7 +23,7 @@ config PHY_DM816X_USB
 
 config PHY_AM654_SERDES
 	tristate "TI AM654 SERDES support"
-	depends on OF && ARCH_K3 || COMPILE_TEST
+	depends on OF && (ARCH_K3 || COMPILE_TEST)
 	depends on COMMON_CLK
 	select GENERIC_PHY
 	select MULTIPLEXER
@@ -35,7 +35,7 @@ config PHY_AM654_SERDES
 
 config PHY_J721E_WIZ
 	tristate "TI J721E WIZ (SERDES Wrapper) support"
-	depends on OF && ARCH_K3 || COMPILE_TEST
+	depends on OF && (ARCH_K3 || COMPILE_TEST)
 	depends on HAS_IOMEM && OF_ADDRESS
 	depends on COMMON_CLK
 	select GENERIC_PHY
diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
index 949ddeb673bc..74637bd0433e 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -478,6 +478,7 @@ static const struct key_entry asus_nb_wmi_keymap[] = {
 	{ KE_KEY, 0x30, { KEY_VOLUMEUP } },
 	{ KE_KEY, 0x31, { KEY_VOLUMEDOWN } },
 	{ KE_KEY, 0x32, { KEY_MUTE } },
+	{ KE_KEY, 0x33, { KEY_SCREENLOCK } },
 	{ KE_KEY, 0x35, { KEY_SCREENLOCK } },
 	{ KE_KEY, 0x40, { KEY_PREVIOUSSONG } },
 	{ KE_KEY, 0x41, { KEY_NEXTSONG } },
diff --git a/drivers/platform/x86/touchscreen_dmi.c b/drivers/platform/x86/touchscreen_dmi.c
index 110ff1e6ef81..bc26acace2c3 100644
--- a/drivers/platform/x86/touchscreen_dmi.c
+++ b/drivers/platform/x86/touchscreen_dmi.c
@@ -255,6 +255,23 @@ static const struct ts_dmi_data connect_tablet9_data = {
 	.properties     = connect_tablet9_props,
 };
 
+static const struct property_entry csl_panther_tab_hd_props[] = {
+	PROPERTY_ENTRY_U32("touchscreen-min-x", 1),
+	PROPERTY_ENTRY_U32("touchscreen-min-y", 20),
+	PROPERTY_ENTRY_U32("touchscreen-size-x", 1980),
+	PROPERTY_ENTRY_U32("touchscreen-size-y", 1526),
+	PROPERTY_ENTRY_BOOL("touchscreen-inverted-y"),
+	PROPERTY_ENTRY_BOOL("touchscreen-swapped-x-y"),
+	PROPERTY_ENTRY_STRING("firmware-name", "gsl1680-csl-panther-tab-hd.fw"),
+	PROPERTY_ENTRY_U32("silead,max-fingers", 10),
+	{ }
+};
+
+static const struct ts_dmi_data csl_panther_tab_hd_data = {
+	.acpi_name      = "MSSL1680:00",
+	.properties     = csl_panther_tab_hd_props,
+};
+
 static const struct property_entry cube_iwork8_air_props[] = {
 	PROPERTY_ENTRY_U32("touchscreen-min-x", 1),
 	PROPERTY_ENTRY_U32("touchscreen-min-y", 3),
@@ -1057,6 +1074,14 @@ const struct dmi_system_id touchscreen_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Tablet 9"),
 		},
 	},
+	{
+		/* CSL Panther Tab HD */
+		.driver_data = (void *)&csl_panther_tab_hd_data,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "CSL Computer GmbH & Co. KG"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "CSL Panther Tab HD"),
+		},
+	},
 	{
 		/* CUBE iwork8 Air */
 		.driver_data = (void *)&cube_iwork8_air_data,
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 1feca45384c7..e5b9229310a0 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1408,7 +1408,7 @@ static void hisi_sas_refresh_port_id(struct hisi_hba *hisi_hba)
 				device->linkrate = phy->sas_phy.linkrate;
 
 			hisi_hba->hw->setup_itct(hisi_hba, sas_dev);
-		} else
+		} else if (!port->port_attached)
 			port->id = 0xff;
 	}
 }
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index b2d4b6c78b5c..a44a098dbb9c 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -5834,7 +5834,7 @@ static int hpsa_scsi_host_alloc(struct ctlr_info *h)
 {
 	struct Scsi_Host *sh;
 
-	sh = scsi_host_alloc(&hpsa_driver_template, sizeof(h));
+	sh = scsi_host_alloc(&hpsa_driver_template, sizeof(struct ctlr_info));
 	if (sh == NULL) {
 		dev_err(&h->pdev->dev, "scsi_host_alloc failed\n");
 		return -ENOMEM;
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index ef7cd7520e7c..092bd6a3d64a 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1674,6 +1674,13 @@ static const char *iscsi_session_state_name(int state)
 	return name;
 }
 
+static char *iscsi_session_target_state_name[] = {
+	[ISCSI_SESSION_TARGET_UNBOUND]   = "UNBOUND",
+	[ISCSI_SESSION_TARGET_ALLOCATED] = "ALLOCATED",
+	[ISCSI_SESSION_TARGET_SCANNED]   = "SCANNED",
+	[ISCSI_SESSION_TARGET_UNBINDING] = "UNBINDING",
+};
+
 int iscsi_session_chkready(struct iscsi_cls_session *session)
 {
 	unsigned long flags;
@@ -1805,9 +1812,13 @@ static int iscsi_user_scan_session(struct device *dev, void *data)
 		if ((scan_data->channel == SCAN_WILD_CARD ||
 		     scan_data->channel == 0) &&
 		    (scan_data->id == SCAN_WILD_CARD ||
-		     scan_data->id == id))
+		     scan_data->id == id)) {
 			scsi_scan_target(&session->dev, 0, id,
 					 scan_data->lun, scan_data->rescan);
+			spin_lock_irqsave(&session->lock, flags);
+			session->target_state = ISCSI_SESSION_TARGET_SCANNED;
+			spin_unlock_irqrestore(&session->lock, flags);
+		}
 	}
 
 user_scan_exit:
@@ -1996,31 +2007,41 @@ static void __iscsi_unbind_session(struct work_struct *work)
 	struct iscsi_cls_host *ihost = shost->shost_data;
 	unsigned long flags;
 	unsigned int target_id;
+	bool remove_target = true;
 
 	ISCSI_DBG_TRANS_SESSION(session, "Unbinding session\n");
 
 	/* Prevent new scans and make sure scanning is not in progress */
 	mutex_lock(&ihost->mutex);
 	spin_lock_irqsave(&session->lock, flags);
-	if (session->target_id == ISCSI_MAX_TARGET) {
+	if (session->target_state == ISCSI_SESSION_TARGET_ALLOCATED) {
+		remove_target = false;
+	} else if (session->target_state != ISCSI_SESSION_TARGET_SCANNED) {
 		spin_unlock_irqrestore(&session->lock, flags);
 		mutex_unlock(&ihost->mutex);
-		goto unbind_session_exit;
+		ISCSI_DBG_TRANS_SESSION(session,
+			"Skipping target unbinding: Session is unbound/unbinding.\n");
+		return;
 	}
 
+	session->target_state = ISCSI_SESSION_TARGET_UNBINDING;
 	target_id = session->target_id;
 	session->target_id = ISCSI_MAX_TARGET;
 	spin_unlock_irqrestore(&session->lock, flags);
 	mutex_unlock(&ihost->mutex);
 
-	scsi_remove_target(&session->dev);
+	if (remove_target)
+		scsi_remove_target(&session->dev);
 
 	if (session->ida_used)
 		ida_simple_remove(&iscsi_sess_ida, target_id);
 
-unbind_session_exit:
 	iscsi_session_event(session, ISCSI_KEVENT_UNBIND_SESSION);
 	ISCSI_DBG_TRANS_SESSION(session, "Completed target removal\n");
+
+	spin_lock_irqsave(&session->lock, flags);
+	session->target_state = ISCSI_SESSION_TARGET_UNBOUND;
+	spin_unlock_irqrestore(&session->lock, flags);
 }
 
 static void __iscsi_destroy_session(struct work_struct *work)
@@ -2089,6 +2110,9 @@ int iscsi_add_session(struct iscsi_cls_session *session, unsigned int target_id)
 		session->ida_used = true;
 	} else
 		session->target_id = target_id;
+	spin_lock_irqsave(&session->lock, flags);
+	session->target_state = ISCSI_SESSION_TARGET_ALLOCATED;
+	spin_unlock_irqrestore(&session->lock, flags);
 
 	dev_set_name(&session->dev, "session%u", session->sid);
 	err = device_add(&session->dev);
@@ -4343,6 +4367,19 @@ iscsi_session_attr(def_taskmgmt_tmo, ISCSI_PARAM_DEF_TASKMGMT_TMO, 0);
 iscsi_session_attr(discovery_parent_idx, ISCSI_PARAM_DISCOVERY_PARENT_IDX, 0);
 iscsi_session_attr(discovery_parent_type, ISCSI_PARAM_DISCOVERY_PARENT_TYPE, 0);
 
+static ssize_t
+show_priv_session_target_state(struct device *dev, struct device_attribute *attr,
+			char *buf)
+{
+	struct iscsi_cls_session *session = iscsi_dev_to_session(dev->parent);
+
+	return sysfs_emit(buf, "%s\n",
+			iscsi_session_target_state_name[session->target_state]);
+}
+
+static ISCSI_CLASS_ATTR(priv_sess, target_state, S_IRUGO,
+			show_priv_session_target_state, NULL);
+
 static ssize_t
 show_priv_session_state(struct device *dev, struct device_attribute *attr,
 			char *buf)
@@ -4445,6 +4482,7 @@ static struct attribute *iscsi_session_attrs[] = {
 	&dev_attr_sess_boot_target.attr,
 	&dev_attr_priv_sess_recovery_tmo.attr,
 	&dev_attr_priv_sess_state.attr,
+	&dev_attr_priv_sess_target_state.attr,
 	&dev_attr_priv_sess_creator.attr,
 	&dev_attr_sess_chap_out_idx.attr,
 	&dev_attr_sess_chap_in_idx.attr,
@@ -4558,6 +4596,8 @@ static umode_t iscsi_session_attr_is_visible(struct kobject *kobj,
 		return S_IRUGO | S_IWUSR;
 	else if (attr == &dev_attr_priv_sess_state.attr)
 		return S_IRUGO;
+	else if (attr == &dev_attr_priv_sess_target_state.attr)
+		return S_IRUGO;
 	else if (attr == &dev_attr_priv_sess_creator.attr)
 		return S_IRUGO;
 	else if (attr == &dev_attr_priv_sess_target_id.attr)
diff --git a/drivers/soc/qcom/cpr.c b/drivers/soc/qcom/cpr.c
index 6298561bc29c..fac0414c3731 100644
--- a/drivers/soc/qcom/cpr.c
+++ b/drivers/soc/qcom/cpr.c
@@ -1743,12 +1743,16 @@ static int cpr_probe(struct platform_device *pdev)
 
 	ret = of_genpd_add_provider_simple(dev->of_node, &drv->pd);
 	if (ret)
-		return ret;
+		goto err_remove_genpd;
 
 	platform_set_drvdata(pdev, drv);
 	cpr_debugfs_init(drv);
 
 	return 0;
+
+err_remove_genpd:
+	pm_genpd_remove(&drv->pd);
+	return ret;
 }
 
 static int cpr_remove(struct platform_device *pdev)
diff --git a/drivers/spi/spidev.c b/drivers/spi/spidev.c
index 9c5ec99431d2..aee960a7d7f9 100644
--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -592,7 +592,6 @@ static int spidev_open(struct inode *inode, struct file *filp)
 	if (!spidev->tx_buffer) {
 		spidev->tx_buffer = kmalloc(bufsiz, GFP_KERNEL);
 		if (!spidev->tx_buffer) {
-			dev_dbg(&spidev->spi->dev, "open/ENOMEM\n");
 			status = -ENOMEM;
 			goto err_find_dev;
 		}
@@ -601,7 +600,6 @@ static int spidev_open(struct inode *inode, struct file *filp)
 	if (!spidev->rx_buffer) {
 		spidev->rx_buffer = kmalloc(bufsiz, GFP_KERNEL);
 		if (!spidev->rx_buffer) {
-			dev_dbg(&spidev->spi->dev, "open/ENOMEM\n");
 			status = -ENOMEM;
 			goto err_alloc_rx_buf;
 		}
diff --git a/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c b/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c
index a337600d5bc4..6952f4e237e1 100644
--- a/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c
+++ b/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c
@@ -44,11 +44,13 @@ static int int340x_thermal_get_trip_temp(struct thermal_zone_device *zone,
 					 int trip, int *temp)
 {
 	struct int34x_thermal_zone *d = zone->devdata;
-	int i;
+	int i, ret = 0;
 
 	if (d->override_ops && d->override_ops->get_trip_temp)
 		return d->override_ops->get_trip_temp(zone, trip, temp);
 
+	mutex_lock(&d->trip_mutex);
+
 	if (trip < d->aux_trip_nr)
 		*temp = d->aux_trips[trip];
 	else if (trip == d->crt_trip_id)
@@ -66,10 +68,12 @@ static int int340x_thermal_get_trip_temp(struct thermal_zone_device *zone,
 			}
 		}
 		if (i == INT340X_THERMAL_MAX_ACT_TRIP_COUNT)
-			return -EINVAL;
+			ret = -EINVAL;
 	}
 
-	return 0;
+	mutex_unlock(&d->trip_mutex);
+
+	return ret;
 }
 
 static int int340x_thermal_get_trip_type(struct thermal_zone_device *zone,
@@ -77,11 +81,13 @@ static int int340x_thermal_get_trip_type(struct thermal_zone_device *zone,
 					 enum thermal_trip_type *type)
 {
 	struct int34x_thermal_zone *d = zone->devdata;
-	int i;
+	int i, ret = 0;
 
 	if (d->override_ops && d->override_ops->get_trip_type)
 		return d->override_ops->get_trip_type(zone, trip, type);
 
+	mutex_lock(&d->trip_mutex);
+
 	if (trip < d->aux_trip_nr)
 		*type = THERMAL_TRIP_PASSIVE;
 	else if (trip == d->crt_trip_id)
@@ -99,10 +105,12 @@ static int int340x_thermal_get_trip_type(struct thermal_zone_device *zone,
 			}
 		}
 		if (i == INT340X_THERMAL_MAX_ACT_TRIP_COUNT)
-			return -EINVAL;
+			ret = -EINVAL;
 	}
 
-	return 0;
+	mutex_unlock(&d->trip_mutex);
+
+	return ret;
 }
 
 static int int340x_thermal_set_trip_temp(struct thermal_zone_device *zone,
@@ -174,6 +182,8 @@ int int340x_thermal_read_trips(struct int34x_thermal_zone *int34x_zone)
 	int trip_cnt = int34x_zone->aux_trip_nr;
 	int i;
 
+	mutex_lock(&int34x_zone->trip_mutex);
+
 	int34x_zone->crt_trip_id = -1;
 	if (!int340x_thermal_get_trip_config(int34x_zone->adev->handle, "_CRT",
 					     &int34x_zone->crt_temp))
@@ -201,6 +211,8 @@ int int340x_thermal_read_trips(struct int34x_thermal_zone *int34x_zone)
 		int34x_zone->act_trips[i].valid = true;
 	}
 
+	mutex_unlock(&int34x_zone->trip_mutex);
+
 	return trip_cnt;
 }
 EXPORT_SYMBOL_GPL(int340x_thermal_read_trips);
@@ -224,6 +236,8 @@ struct int34x_thermal_zone *int340x_thermal_zone_add(struct acpi_device *adev,
 	if (!int34x_thermal_zone)
 		return ERR_PTR(-ENOMEM);
 
+	mutex_init(&int34x_thermal_zone->trip_mutex);
+
 	int34x_thermal_zone->adev = adev;
 	int34x_thermal_zone->override_ops = override_ops;
 
@@ -275,6 +289,7 @@ struct int34x_thermal_zone *int340x_thermal_zone_add(struct acpi_device *adev,
 	acpi_lpat_free_conversion_table(int34x_thermal_zone->lpat_table);
 	kfree(int34x_thermal_zone->aux_trips);
 err_trip_alloc:
+	mutex_destroy(&int34x_thermal_zone->trip_mutex);
 	kfree(int34x_thermal_zone);
 	return ERR_PTR(ret);
 }
@@ -286,6 +301,7 @@ void int340x_thermal_zone_remove(struct int34x_thermal_zone
 	thermal_zone_device_unregister(int34x_thermal_zone->zone);
 	acpi_lpat_free_conversion_table(int34x_thermal_zone->lpat_table);
 	kfree(int34x_thermal_zone->aux_trips);
+	mutex_destroy(&int34x_thermal_zone->trip_mutex);
 	kfree(int34x_thermal_zone);
 }
 EXPORT_SYMBOL_GPL(int340x_thermal_zone_remove);
diff --git a/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.h b/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.h
index 3b4971df1b33..8f9872afd0d3 100644
--- a/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.h
+++ b/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.h
@@ -32,6 +32,7 @@ struct int34x_thermal_zone {
 	struct thermal_zone_device_ops *override_ops;
 	void *priv_data;
 	struct acpi_lpat_conversion_table *lpat_table;
+	struct mutex trip_mutex;
 };
 
 struct int34x_thermal_zone *int340x_thermal_zone_add(struct acpi_device *,
diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index bb0d92837f67..94000fd190e5 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -278,6 +278,9 @@ static int __ffs_ep0_queue_wait(struct ffs_data *ffs, char *data, size_t len)
 	struct usb_request *req = ffs->ep0req;
 	int ret;
 
+	if (!req)
+		return -EINVAL;
+
 	req->zero     = len < le16_to_cpu(ffs->ev.setup.wLength);
 
 	spin_unlock_irq(&ffs->ev.waitq.lock);
@@ -1881,10 +1884,14 @@ static void functionfs_unbind(struct ffs_data *ffs)
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
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 2967372a9988..473b0b64dd57 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -696,6 +696,8 @@ int xhci_run(struct usb_hcd *hcd)
 	xhci_dbg_trace(xhci, trace_xhci_dbg_init,
 			"Finished xhci_run for USB2 roothub");
 
+	set_bit(HCD_FLAG_DEFER_RH_REGISTER, &hcd->flags);
+
 	xhci_dbc_init(xhci);
 
 	xhci_debugfs_init(xhci);
diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index 15a2ee32f116..15842377c8d2 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -1131,6 +1131,8 @@ int w1_process(void *data)
 	/* remainder if it woke up early */
 	unsigned long jremain = 0;
 
+	atomic_inc(&dev->refcnt);
+
 	for (;;) {
 
 		if (!jremain && dev->search_count) {
@@ -1158,8 +1160,10 @@ int w1_process(void *data)
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
index b3e1792d9c49..3a71c5eb2f83 100644
--- a/drivers/w1/w1_int.c
+++ b/drivers/w1/w1_int.c
@@ -51,10 +51,9 @@ static struct w1_master *w1_alloc_dev(u32 id, int slave_count, int slave_ttl,
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
index d91b0133d95d..c3d89fa1bab7 100644
--- a/fs/affs/file.c
+++ b/fs/affs/file.c
@@ -879,7 +879,7 @@ affs_truncate(struct inode *inode)
 	if (inode->i_size > AFFS_I(inode)->mmu_private) {
 		struct address_space *mapping = inode->i_mapping;
 		struct page *page;
-		void *fsdata;
+		void *fsdata = NULL;
 		loff_t isize = inode->i_size;
 		int res;
 
diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index b029ed31ef91..f73f9b062525 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -1394,6 +1394,7 @@ void smbd_destroy(struct TCP_Server_Info *server)
 	destroy_workqueue(info->workqueue);
 	log_rdma_event(INFO,  "rdma session destroyed\n");
 	kfree(info);
+	server->smbd_conn = NULL;
 }
 
 /*
diff --git a/fs/nfsd/netns.h b/fs/nfsd/netns.h
index 7346acda9d76..02d3d2f0e616 100644
--- a/fs/nfsd/netns.h
+++ b/fs/nfsd/netns.h
@@ -42,9 +42,6 @@ struct nfsd_net {
 	bool grace_ended;
 	time64_t boot_time;
 
-	/* internal mount of the "nfsd" pseudofilesystem: */
-	struct vfsmount *nfsd_mnt;
-
 	struct dentry *nfsd_client_dir;
 
 	/*
@@ -121,6 +118,9 @@ struct nfsd_net {
 	wait_queue_head_t ntf_wq;
 	atomic_t ntf_refcnt;
 
+	/* Allow umount to wait for nfsd state cleanup */
+	struct completion nfsd_shutdown_complete;
+
 	/*
 	 * clientid and stateid data for construction of net unique COPY
 	 * stateids.
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 9a47cc66963f..cb13a1649632 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -7394,14 +7394,9 @@ nfs4_state_start_net(struct net *net)
 	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
 	int ret;
 
-	ret = get_nfsdfs(net);
-	if (ret)
-		return ret;
 	ret = nfs4_state_create_net(net);
-	if (ret) {
-		mntput(nn->nfsd_mnt);
+	if (ret)
 		return ret;
-	}
 	locks_start_grace(net, &nn->nfsd4_manager);
 	nfsd4_client_tracking_init(net);
 	if (nn->track_reclaim_completes && nn->reclaim_str_hashtbl_size == 0)
@@ -7471,7 +7466,6 @@ nfs4_state_shutdown_net(struct net *net)
 
 	nfsd4_client_tracking_exit(net);
 	nfs4_state_destroy_net(net);
-	mntput(nn->nfsd_mnt);
 }
 
 void
diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index dedec4771ecc..c4b11560ac1b 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -1417,6 +1417,8 @@ static void nfsd_umount(struct super_block *sb)
 {
 	struct net *net = sb->s_fs_info;
 
+	nfsd_shutdown_threads(net);
+
 	kill_litter_super(sb);
 	put_net(net);
 }
@@ -1429,18 +1431,6 @@ static struct file_system_type nfsd_fs_type = {
 };
 MODULE_ALIAS_FS("nfsd");
 
-int get_nfsdfs(struct net *net)
-{
-	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
-	struct vfsmount *mnt;
-
-	mnt =  vfs_kern_mount(&nfsd_fs_type, SB_KERNMOUNT, "nfsd", NULL);
-	if (IS_ERR(mnt))
-		return PTR_ERR(mnt);
-	nn->nfsd_mnt = mnt;
-	return 0;
-}
-
 #ifdef CONFIG_PROC_FS
 static int create_proc_exports_entry(void)
 {
diff --git a/fs/nfsd/nfsd.h b/fs/nfsd/nfsd.h
index cb742e17e04a..4362d295ed34 100644
--- a/fs/nfsd/nfsd.h
+++ b/fs/nfsd/nfsd.h
@@ -85,13 +85,12 @@ int		nfsd_get_nrthreads(int n, int *, struct net *);
 int		nfsd_set_nrthreads(int n, int *, struct net *);
 int		nfsd_pool_stats_open(struct inode *, struct file *);
 int		nfsd_pool_stats_release(struct inode *, struct file *);
+void		nfsd_shutdown_threads(struct net *net);
 
 void		nfsd_destroy(struct net *net);
 
 bool		i_am_nfsd(void);
 
-int get_nfsdfs(struct net *);
-
 struct nfsdfs_client {
 	struct kref cl_ref;
 	void (*cl_release)(struct kref *kref);
diff --git a/fs/nfsd/nfssvc.c b/fs/nfsd/nfssvc.c
index c7fffe1453bd..2e61a565cdbd 100644
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -600,6 +600,37 @@ static const struct svc_serv_ops nfsd_thread_sv_ops = {
 	.svo_module		= THIS_MODULE,
 };
 
+static void nfsd_complete_shutdown(struct net *net)
+{
+	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
+
+	WARN_ON(!mutex_is_locked(&nfsd_mutex));
+
+	nn->nfsd_serv = NULL;
+	complete(&nn->nfsd_shutdown_complete);
+}
+
+void nfsd_shutdown_threads(struct net *net)
+{
+	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
+	struct svc_serv *serv;
+
+	mutex_lock(&nfsd_mutex);
+	serv = nn->nfsd_serv;
+	if (serv == NULL) {
+		mutex_unlock(&nfsd_mutex);
+		return;
+	}
+
+	svc_get(serv);
+	/* Kill outstanding nfsd threads */
+	serv->sv_ops->svo_setup(serv, NULL, 0);
+	nfsd_destroy(net);
+	mutex_unlock(&nfsd_mutex);
+	/* Wait for shutdown of nfsd_serv to complete */
+	wait_for_completion(&nn->nfsd_shutdown_complete);
+}
+
 bool i_am_nfsd(void)
 {
 	return kthread_func(current) == nfsd;
@@ -622,11 +653,13 @@ int nfsd_create_serv(struct net *net)
 						&nfsd_thread_sv_ops);
 	if (nn->nfsd_serv == NULL)
 		return -ENOMEM;
+	init_completion(&nn->nfsd_shutdown_complete);
 
 	nn->nfsd_serv->sv_maxconn = nn->max_connections;
 	error = svc_bind(nn->nfsd_serv, net);
 	if (error < 0) {
 		svc_destroy(nn->nfsd_serv);
+		nfsd_complete_shutdown(net);
 		return error;
 	}
 
@@ -675,7 +708,7 @@ void nfsd_destroy(struct net *net)
 		svc_shutdown_net(nn->nfsd_serv, net);
 	svc_destroy(nn->nfsd_serv);
 	if (destroy)
-		nn->nfsd_serv = NULL;
+		nfsd_complete_shutdown(net);
 }
 
 int nfsd_set_nrthreads(int n, int *nthreads, struct net *net)
diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 070d2df8ab9c..cd7c6c4af83a 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -16,6 +16,7 @@
 #include <linux/module.h>
 #include <linux/bpf-cgroup.h>
 #include <linux/mount.h>
+#include <linux/kmemleak.h>
 #include "internal.h"
 
 static const struct dentry_operations proc_sys_dentry_operations;
@@ -1380,6 +1381,38 @@ struct ctl_table_header *register_sysctl(const char *path, struct ctl_table *tab
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
index 913f5af9bf24..0ebb6e684908 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -1437,7 +1437,6 @@ static int reiserfs_remount(struct super_block *s, int *mount_flags, char *arg)
 	unsigned long safe_mask = 0;
 	unsigned int commit_max_age = (unsigned int)-1;
 	struct reiserfs_journal *journal = SB_JOURNAL(s);
-	char *new_opts;
 	int err;
 	char *qf_names[REISERFS_MAXQUOTAS];
 	unsigned int qfmt = 0;
@@ -1445,10 +1444,6 @@ static int reiserfs_remount(struct super_block *s, int *mount_flags, char *arg)
 	int i;
 #endif
 
-	new_opts = kstrdup(arg, GFP_KERNEL);
-	if (arg && !new_opts)
-		return -ENOMEM;
-
 	sync_filesystem(s);
 	reiserfs_write_lock(s);
 
@@ -1599,7 +1594,6 @@ static int reiserfs_remount(struct super_block *s, int *mount_flags, char *arg)
 out_err_unlock:
 	reiserfs_write_unlock(s);
 out_err:
-	kfree(new_opts);
 	return err;
 }
 
diff --git a/include/linux/clk.h b/include/linux/clk.h
index 7fd6a1febcf4..1814eabb7c20 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -418,6 +418,47 @@ int __must_check devm_clk_bulk_get_all(struct device *dev,
  */
 struct clk *devm_clk_get(struct device *dev, const char *id);
 
+/**
+ * devm_clk_get_prepared - devm_clk_get() + clk_prepare()
+ * @dev: device for clock "consumer"
+ * @id: clock consumer ID
+ *
+ * Context: May sleep.
+ *
+ * Return: a struct clk corresponding to the clock producer, or
+ * valid IS_ERR() condition containing errno.  The implementation
+ * uses @dev and @id to determine the clock consumer, and thereby
+ * the clock producer.  (IOW, @id may be identical strings, but
+ * clk_get may return different clock producers depending on @dev.)
+ *
+ * The returned clk (if valid) is prepared. Drivers must however assume
+ * that the clock is not enabled.
+ *
+ * The clock will automatically be unprepared and freed when the device
+ * is unbound from the bus.
+ */
+struct clk *devm_clk_get_prepared(struct device *dev, const char *id);
+
+/**
+ * devm_clk_get_enabled - devm_clk_get() + clk_prepare_enable()
+ * @dev: device for clock "consumer"
+ * @id: clock consumer ID
+ *
+ * Context: May sleep.
+ *
+ * Return: a struct clk corresponding to the clock producer, or
+ * valid IS_ERR() condition containing errno.  The implementation
+ * uses @dev and @id to determine the clock consumer, and thereby
+ * the clock producer.  (IOW, @id may be identical strings, but
+ * clk_get may return different clock producers depending on @dev.)
+ *
+ * The returned clk (if valid) is prepared and enabled.
+ *
+ * The clock will automatically be disabled, unprepared and freed
+ * when the device is unbound from the bus.
+ */
+struct clk *devm_clk_get_enabled(struct device *dev, const char *id);
+
 /**
  * devm_clk_get_optional - lookup and obtain a managed reference to an optional
  *			   clock producer.
@@ -429,6 +470,50 @@ struct clk *devm_clk_get(struct device *dev, const char *id);
  */
 struct clk *devm_clk_get_optional(struct device *dev, const char *id);
 
+/**
+ * devm_clk_get_optional_prepared - devm_clk_get_optional() + clk_prepare()
+ * @dev: device for clock "consumer"
+ * @id: clock consumer ID
+ *
+ * Context: May sleep.
+ *
+ * Return: a struct clk corresponding to the clock producer, or
+ * valid IS_ERR() condition containing errno.  The implementation
+ * uses @dev and @id to determine the clock consumer, and thereby
+ * the clock producer.  If no such clk is found, it returns NULL
+ * which serves as a dummy clk.  That's the only difference compared
+ * to devm_clk_get_prepared().
+ *
+ * The returned clk (if valid) is prepared. Drivers must however
+ * assume that the clock is not enabled.
+ *
+ * The clock will automatically be unprepared and freed when the
+ * device is unbound from the bus.
+ */
+struct clk *devm_clk_get_optional_prepared(struct device *dev, const char *id);
+
+/**
+ * devm_clk_get_optional_enabled - devm_clk_get_optional() +
+ *                                 clk_prepare_enable()
+ * @dev: device for clock "consumer"
+ * @id: clock consumer ID
+ *
+ * Context: May sleep.
+ *
+ * Return: a struct clk corresponding to the clock producer, or
+ * valid IS_ERR() condition containing errno.  The implementation
+ * uses @dev and @id to determine the clock consumer, and thereby
+ * the clock producer.  If no such clk is found, it returns NULL
+ * which serves as a dummy clk.  That's the only difference compared
+ * to devm_clk_get_enabled().
+ *
+ * The returned clk (if valid) is prepared and enabled.
+ *
+ * The clock will automatically be disabled, unprepared and freed
+ * when the device is unbound from the bus.
+ */
+struct clk *devm_clk_get_optional_enabled(struct device *dev, const char *id);
+
 /**
  * devm_get_clk_from_child - lookup and obtain a managed reference to a
  *			     clock producer from child node.
@@ -773,12 +858,36 @@ static inline struct clk *devm_clk_get(struct device *dev, const char *id)
 	return NULL;
 }
 
+static inline struct clk *devm_clk_get_prepared(struct device *dev,
+						const char *id)
+{
+	return NULL;
+}
+
+static inline struct clk *devm_clk_get_enabled(struct device *dev,
+					       const char *id)
+{
+	return NULL;
+}
+
 static inline struct clk *devm_clk_get_optional(struct device *dev,
 						const char *id)
 {
 	return NULL;
 }
 
+static inline struct clk *devm_clk_get_optional_prepared(struct device *dev,
+							 const char *id)
+{
+	return NULL;
+}
+
+static inline struct clk *devm_clk_get_optional_enabled(struct device *dev,
+							const char *id)
+{
+	return NULL;
+}
+
 static inline int __must_check devm_clk_bulk_get(struct device *dev, int num_clks,
 						 struct clk_bulk_data *clks)
 {
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index f5392d96d688..394f10fc29aa 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -320,6 +320,7 @@ extern long (*panic_blink)(int state);
 __printf(1, 2)
 void panic(const char *fmt, ...) __noreturn __cold;
 void nmi_panic(struct pt_regs *regs, const char *msg);
+void check_panic_on_warn(const char *origin);
 extern void oops_enter(void);
 extern void oops_exit(void);
 extern bool oops_may_print(void);
@@ -520,12 +521,6 @@ static inline u32 int_sqrt64(u64 x)
 }
 #endif
 
-#ifdef CONFIG_SMP
-extern unsigned int sysctl_oops_all_cpu_backtrace;
-#else
-#define sysctl_oops_all_cpu_backtrace 0
-#endif /* CONFIG_SMP */
-
 extern void bust_spinlocks(int yes);
 extern int panic_timeout;
 extern unsigned long panic_print;
diff --git a/include/linux/sched/task.h b/include/linux/sched/task.h
index 4ce511437a8a..2832cc6be062 100644
--- a/include/linux/sched/task.h
+++ b/include/linux/sched/task.h
@@ -61,6 +61,7 @@ extern void sched_post_fork(struct task_struct *p,
 extern void sched_dead(struct task_struct *p);
 
 void __noreturn do_task_dead(void);
+void __noreturn make_task_dead(int signr);
 
 extern void proc_caches_init(void);
 
diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index 51298a4f4623..161eba9fd912 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -195,6 +195,9 @@ struct ctl_table_header *register_sysctl_paths(const struct ctl_path *path,
 void unregister_sysctl_table(struct ctl_table_header * table);
 
 extern int sysctl_init(void);
+extern void __register_sysctl_init(const char *path, struct ctl_table *table,
+				 const char *table_name);
+#define register_sysctl_init(path, table) __register_sysctl_init(path, table, #table)
 void do_sysctl_args(void);
 
 extern int pwrsw_enabled;
diff --git a/include/linux/units.h b/include/linux/units.h
index aaf716364ec3..3457179f7116 100644
--- a/include/linux/units.h
+++ b/include/linux/units.h
@@ -4,6 +4,26 @@
 
 #include <linux/kernel.h>
 
+/* Metric prefixes in accordance with Système international (d'unités) */
+#define PETA	1000000000000000ULL
+#define TERA	1000000000000ULL
+#define GIGA	1000000000UL
+#define MEGA	1000000UL
+#define KILO	1000UL
+#define HECTO	100UL
+#define DECA	10UL
+#define DECI	10UL
+#define CENTI	100UL
+#define MILLI	1000UL
+#define MICRO	1000000UL
+#define NANO	1000000000UL
+#define PICO	1000000000000ULL
+#define FEMTO	1000000000000000ULL
+
+#define MILLIWATT_PER_WATT	1000L
+#define MICROWATT_PER_MILLIWATT	1000L
+#define MICROWATT_PER_WATT	1000000L
+
 #define ABSOLUTE_ZERO_MILLICELSIUS -273150
 
 static inline long milli_kelvin_to_millicelsius(long t)
diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index e7e8c318925d..61cd19ee51f4 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -1325,4 +1325,11 @@ static inline int skb_tc_reinsert(struct sk_buff *skb, struct tcf_result *res)
 	return res->ingress ? netif_receive_skb(skb) : dev_queue_xmit(skb);
 }
 
+/* Make sure qdisc is no longer in SCHED state. */
+static inline void qdisc_synchronize(const struct Qdisc *q)
+{
+	while (test_bit(__QDISC_STATE_SCHED, &q->state))
+		msleep(1);
+}
+
 #endif
diff --git a/include/net/sock.h b/include/net/sock.h
index 90a8b8b26a20..69bbbe8bbf34 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -315,7 +315,7 @@ struct bpf_local_storage;
   *	@sk_tskey: counter to disambiguate concurrent tstamp requests
   *	@sk_zckey: counter to order MSG_ZEROCOPY notifications
   *	@sk_socket: Identd and reporting IO signals
-  *	@sk_user_data: RPC layer private data
+  *	@sk_user_data: RPC layer private data. Write-protected by @sk_callback_lock.
   *	@sk_frag: cached page frag
   *	@sk_peek_off: current peek_offset value
   *	@sk_send_head: front of stuff to transmit
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 037c77fb5dc5..c4de15f7a0a5 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -236,6 +236,14 @@ enum {
 	ISCSI_SESSION_FREE,
 };
 
+enum {
+	ISCSI_SESSION_TARGET_UNBOUND,
+	ISCSI_SESSION_TARGET_ALLOCATED,
+	ISCSI_SESSION_TARGET_SCANNED,
+	ISCSI_SESSION_TARGET_UNBINDING,
+	ISCSI_SESSION_TARGET_MAX,
+};
+
 #define ISCSI_MAX_TARGET -1
 
 struct iscsi_cls_session {
@@ -262,6 +270,7 @@ struct iscsi_cls_session {
 	 */
 	pid_t creator;
 	int state;
+	int target_state;			/* session target bind state */
 	int sid;				/* session id */
 	void *dd_data;				/* LLD private data */
 	struct device dev;	/* sysfs transport/container device */
diff --git a/include/uapi/linux/netfilter/nf_conntrack_sctp.h b/include/uapi/linux/netfilter/nf_conntrack_sctp.h
index edc6ddab0de6..2d6f80d75ae7 100644
--- a/include/uapi/linux/netfilter/nf_conntrack_sctp.h
+++ b/include/uapi/linux/netfilter/nf_conntrack_sctp.h
@@ -15,7 +15,7 @@ enum sctp_conntrack {
 	SCTP_CONNTRACK_SHUTDOWN_RECD,
 	SCTP_CONNTRACK_SHUTDOWN_ACK_SENT,
 	SCTP_CONNTRACK_HEARTBEAT_SENT,
-	SCTP_CONNTRACK_HEARTBEAT_ACKED,
+	SCTP_CONNTRACK_HEARTBEAT_ACKED,	/* no longer used */
 	SCTP_CONNTRACK_MAX
 };
 
diff --git a/include/uapi/linux/netfilter/nfnetlink_cttimeout.h b/include/uapi/linux/netfilter/nfnetlink_cttimeout.h
index 6b20fb22717b..aa805e6d4e28 100644
--- a/include/uapi/linux/netfilter/nfnetlink_cttimeout.h
+++ b/include/uapi/linux/netfilter/nfnetlink_cttimeout.h
@@ -94,7 +94,7 @@ enum ctattr_timeout_sctp {
 	CTA_TIMEOUT_SCTP_SHUTDOWN_RECD,
 	CTA_TIMEOUT_SCTP_SHUTDOWN_ACK_SENT,
 	CTA_TIMEOUT_SCTP_HEARTBEAT_SENT,
-	CTA_TIMEOUT_SCTP_HEARTBEAT_ACKED,
+	CTA_TIMEOUT_SCTP_HEARTBEAT_ACKED, /* no longer used */
 	__CTA_TIMEOUT_SCTP_MAX
 };
 #define CTA_TIMEOUT_SCTP_MAX (__CTA_TIMEOUT_SCTP_MAX - 1)
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 232c93357b90..a6c931fed39b 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2319,7 +2319,9 @@ static int check_stack_write_fixed_off(struct bpf_verifier_env *env,
 		bool sanitize = reg && is_spillable_regtype(reg->type);
 
 		for (i = 0; i < size; i++) {
-			if (state->stack[spi].slot_type[i] == STACK_INVALID) {
+			u8 type = state->stack[spi].slot_type[i];
+
+			if (type != STACK_MISC && type != STACK_ZERO) {
 				sanitize = true;
 				break;
 			}
diff --git a/kernel/exit.c b/kernel/exit.c
index 8989e1d1f79b..bacdaf980933 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -64,11 +64,58 @@
 #include <linux/rcuwait.h>
 #include <linux/compat.h>
 #include <linux/io_uring.h>
+#include <linux/sysfs.h>
 
 #include <linux/uaccess.h>
 #include <asm/unistd.h>
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
@@ -863,6 +910,31 @@ void __noreturn do_exit(long code)
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
diff --git a/kernel/kcsan/kcsan-test.c b/kernel/kcsan/kcsan-test.c
index ebe7fd245104..8a8ccaf4f38f 100644
--- a/kernel/kcsan/kcsan-test.c
+++ b/kernel/kcsan/kcsan-test.c
@@ -149,7 +149,7 @@ static bool report_matches(const struct expect_report *r)
 	const bool is_assert = (r->access[0].type | r->access[1].type) & KCSAN_ACCESS_ASSERT;
 	bool ret = false;
 	unsigned long flags;
-	typeof(observed.lines) expect;
+	typeof(*observed.lines) *expect;
 	const char *end;
 	char *cur;
 	int i;
@@ -158,6 +158,10 @@ static bool report_matches(const struct expect_report *r)
 	if (!report_available())
 		return false;
 
+	expect = kmalloc(sizeof(observed.lines), GFP_KERNEL);
+	if (WARN_ON(!expect))
+		return false;
+
 	/* Generate expected report contents. */
 
 	/* Title */
@@ -241,6 +245,7 @@ static bool report_matches(const struct expect_report *r)
 		strstr(observed.lines[2], expect[1])));
 out:
 	spin_unlock_irqrestore(&observed.lock, flags);
+	kfree(expect);
 	return ret;
 }
 
diff --git a/kernel/kcsan/report.c b/kernel/kcsan/report.c
index d3bf87e6007c..069830f5a5d2 100644
--- a/kernel/kcsan/report.c
+++ b/kernel/kcsan/report.c
@@ -630,8 +630,8 @@ void kcsan_report(const volatile void *ptr, size_t size, int access_type,
 		bool reported = value_change != KCSAN_VALUE_CHANGE_FALSE &&
 				print_report(value_change, type, &ai, other_info);
 
-		if (reported && panic_on_warn)
-			panic("panic_on_warn set ...\n");
+		if (reported)
+			check_panic_on_warn("KCSAN");
 
 		release_report(&flags, other_info);
 	}
diff --git a/kernel/module.c b/kernel/module.c
index 6a0fd245c048..33d1dc6d4cd6 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3661,7 +3661,8 @@ static bool finished_loading(const char *name)
 	sched_annotate_sleep();
 	mutex_lock(&module_mutex);
 	mod = find_module_all(name, strlen(name), true);
-	ret = !mod || mod->state == MODULE_STATE_LIVE;
+	ret = !mod || mod->state == MODULE_STATE_LIVE
+		|| mod->state == MODULE_STATE_GOING;
 	mutex_unlock(&module_mutex);
 
 	return ret;
@@ -3827,20 +3828,35 @@ static int add_unformed_module(struct module *mod)
 
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
index 332736a72a58..bc39e2b27d31 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -31,6 +31,7 @@
 #include <linux/bug.h>
 #include <linux/ratelimit.h>
 #include <linux/debugfs.h>
+#include <linux/sysfs.h>
 #include <asm/sections.h>
 
 #define PANIC_TIMER_STEP 100
@@ -41,7 +42,9 @@
  * Should we dump all CPUs backtraces in an oops event?
  * Defaults to 0, can be changed via sysctl.
  */
-unsigned int __read_mostly sysctl_oops_all_cpu_backtrace;
+static unsigned int __read_mostly sysctl_oops_all_cpu_backtrace;
+#else
+#define sysctl_oops_all_cpu_backtrace 0
 #endif /* CONFIG_SMP */
 
 int panic_on_oops = CONFIG_PANIC_ON_OOPS_VALUE;
@@ -54,6 +57,7 @@ bool crash_kexec_post_notifiers;
 int panic_on_warn __read_mostly;
 unsigned long panic_on_taint;
 bool panic_on_taint_nousertaint = false;
+static unsigned int warn_limit __read_mostly;
 
 int panic_timeout = CONFIG_PANIC_TIMEOUT;
 EXPORT_SYMBOL_GPL(panic_timeout);
@@ -70,6 +74,56 @@ ATOMIC_NOTIFIER_HEAD(panic_notifier_list);
 
 EXPORT_SYMBOL(panic_notifier_list);
 
+#ifdef CONFIG_SYSCTL
+static struct ctl_table kern_panic_table[] = {
+#ifdef CONFIG_SMP
+	{
+		.procname       = "oops_all_cpu_backtrace",
+		.data           = &sysctl_oops_all_cpu_backtrace,
+		.maxlen         = sizeof(int),
+		.mode           = 0644,
+		.proc_handler   = proc_dointvec_minmax,
+		.extra1         = SYSCTL_ZERO,
+		.extra2         = SYSCTL_ONE,
+	},
+#endif
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
@@ -166,6 +220,19 @@ static void panic_print_sys_info(void)
 		ftrace_dump(DUMP_ALL);
 }
 
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
@@ -183,6 +250,16 @@ void panic(const char *fmt, ...)
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
@@ -594,16 +671,7 @@ void __warn(const char *file, int line, void *caller, unsigned taint,
 	if (regs)
 		show_regs(regs);
 
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
 
 	if (!regs)
 		dump_stack();
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index a875bc59804e..1303a2607f1f 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4280,8 +4280,7 @@ static noinline void __schedule_bug(struct task_struct *prev)
 		pr_err("Preemption disabled at:");
 		print_ip_sym(KERN_ERR, preempt_disable_ip);
 	}
-	if (panic_on_warn)
-		panic("scheduling while atomic\n");
+	check_panic_on_warn("scheduling while atomic");
 
 	dump_stack();
 	add_taint(TAINT_WARN, LOCKDEP_STILL_OK);
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 3eb527f8a269..d8b7b2846313 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -2199,17 +2199,6 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 #endif
-#ifdef CONFIG_SMP
-	{
-		.procname	= "oops_all_cpu_backtrace",
-		.data		= &sysctl_oops_all_cpu_backtrace,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
-	},
-#endif /* CONFIG_SMP */
 	{
 		.procname	= "pid_max",
 		.data		= &pid_max,
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index c7c92b0eed04..f06d48be5a96 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -9680,6 +9680,8 @@ void __init early_trace_init(void)
 			static_key_enable(&tracepoint_printk_key.key);
 	}
 	tracer_alloc_buffers();
+
+	init_events();
 }
 
 void __init trace_init(void)
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 8d67f7f44840..37f616bf5fa9 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -1673,6 +1673,7 @@ extern void trace_event_enable_cmd_record(bool enable);
 extern void trace_event_enable_tgid_record(bool enable);
 
 extern int event_trace_init(void);
+extern int init_events(void);
 extern int event_trace_add_tracer(struct dentry *parent, struct trace_array *tr);
 extern int event_trace_del_tracer(struct trace_array *tr);
 extern void __trace_early_add_events(struct trace_array *tr);
diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index 0ae3e4454ff2..ccc99cd23f3c 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -1646,6 +1646,8 @@ static struct hist_field *create_hist_field(struct hist_trigger_data *hist_data,
 		unsigned long fl = flags & ~HIST_FIELD_FL_LOG2;
 		hist_field->fn = hist_field_log2;
 		hist_field->operands[0] = create_hist_field(hist_data, field, fl, NULL);
+		if (!hist_field->operands[0])
+			goto free;
 		hist_field->size = hist_field->operands[0]->size;
 		hist_field->type = kstrdup(hist_field->operands[0]->type, GFP_KERNEL);
 		if (!hist_field->type)
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 000e9dc224c6..b3ee8d9b6b62 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -1378,7 +1378,7 @@ static struct trace_event *events[] __initdata = {
 	NULL
 };
 
-__init static int init_events(void)
+__init int init_events(void)
 {
 	struct trace_event *event;
 	int i, ret;
@@ -1396,4 +1396,3 @@ __init static int init_events(void)
 
 	return 0;
 }
-early_initcall(init_events);
diff --git a/lib/lockref.c b/lib/lockref.c
index 5b34bbd3eba8..81ac5f355242 100644
--- a/lib/lockref.c
+++ b/lib/lockref.c
@@ -24,7 +24,6 @@
 		}								\
 		if (!--retry)							\
 			break;							\
-		cpu_relax();							\
 	}									\
 } while (0)
 
diff --git a/lib/nlattr.c b/lib/nlattr.c
index fe60f9ae9db1..aa8fc4371e93 100644
--- a/lib/nlattr.c
+++ b/lib/nlattr.c
@@ -10,6 +10,7 @@
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/jiffies.h>
+#include <linux/nospec.h>
 #include <linux/skbuff.h>
 #include <linux/string.h>
 #include <linux/types.h>
@@ -369,6 +370,7 @@ static int validate_nla(const struct nlattr *nla, int maxtype,
 	if (type <= 0 || type > maxtype)
 		return 0;
 
+	type = array_index_nospec(type, maxtype + 1);
 	pt = &policy[type];
 
 	BUG_ON(pt->type > NLA_TYPE_MAX);
@@ -584,6 +586,7 @@ static int __nla_validate_parse(const struct nlattr *head, int len, int maxtype,
 			}
 			continue;
 		}
+		type = array_index_nospec(type, maxtype + 1);
 		if (policy) {
 			int err = validate_nla(nla, maxtype, policy,
 					       validate, extack, depth);
diff --git a/lib/ubsan.c b/lib/ubsan.c
index adf8dcf3c84e..ee14c46cac89 100644
--- a/lib/ubsan.c
+++ b/lib/ubsan.c
@@ -151,16 +151,7 @@ static void ubsan_epilogue(void)
 
 	current->in_ubsan--;
 
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
+	check_panic_on_warn("UBSAN");
 }
 
 static void handle_overflow(struct overflow_data *data, void *lhs,
diff --git a/mm/kasan/report.c b/mm/kasan/report.c
index 00a53f1355ae..2f5e96ac4d00 100644
--- a/mm/kasan/report.c
+++ b/mm/kasan/report.c
@@ -95,16 +95,8 @@ static void end_report(unsigned long *flags)
 	pr_err("==================================================================\n");
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
 	spin_unlock_irqrestore(&report_lock, *flags);
-	if (panic_on_warn && !test_bit(KASAN_BIT_MULTI_SHOT, &kasan_flags)) {
-		/*
-		 * This thread may hit another WARN() in the panic path.
-		 * Resetting this prevents additional WARN() from panicking the
-		 * system on this thread.  Other threads are blocked by the
-		 * panic_mutex in panic().
-		 */
-		panic_on_warn = 0;
-		panic("panic_on_warn set ...\n");
-	}
+	if (!test_bit(KASAN_BIT_MULTI_SHOT, &kasan_flags))
+		check_panic_on_warn("KASAN");
 	kasan_enable_current();
 }
 
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 2af1477a05ca..08c473aa0113 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1623,6 +1623,7 @@ static int hci_dev_do_open(struct hci_dev *hdev)
 			hdev->flush(hdev);
 
 		if (hdev->sent_cmd) {
+			cancel_delayed_work_sync(&hdev->cmd_timer);
 			kfree_skb(hdev->sent_cmd);
 			hdev->sent_cmd = NULL;
 		}
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index a3b7d965e9c0..e05dd4f3279a 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -155,12 +155,12 @@ static int ops_init(const struct pernet_operations *ops, struct net *net)
 		return 0;
 
 	if (ops->id && ops->size) {
-cleanup:
 		ng = rcu_dereference_protected(net->gen,
 					       lockdep_is_held(&pernet_ops_rwsem));
 		ng->ptr[*ops->id] = NULL;
 	}
 
+cleanup:
 	kfree(data);
 
 out:
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index ab9fcc6231b8..4e94796ccdbd 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -30,6 +30,7 @@
 #include <linux/slab.h>
 #include <linux/netlink.h>
 #include <linux/hash.h>
+#include <linux/nospec.h>
 
 #include <net/arp.h>
 #include <net/ip.h>
@@ -1021,6 +1022,7 @@ bool fib_metrics_match(struct fib_config *cfg, struct fib_info *fi)
 		if (type > RTAX_MAX)
 			return false;
 
+		type = array_index_nospec(type, RTAX_MAX + 1);
 		if (type == RTAX_CC_ALGO) {
 			char tmp[TCP_CA_NAME_MAX];
 			bool ecn_ca = false;
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index c68a1dae25ca..2615b72118d1 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -571,8 +571,20 @@ bool inet_ehash_insert(struct sock *sk, struct sock *osk, bool *found_dup_sk)
 	spin_lock(lock);
 	if (osk) {
 		WARN_ON_ONCE(sk->sk_hash != osk->sk_hash);
-		ret = sk_nulls_del_node_init_rcu(osk);
-	} else if (found_dup_sk) {
+		ret = sk_hashed(osk);
+		if (ret) {
+			/* Before deleting the node, we insert a new one to make
+			 * sure that the look-up-sk process would not miss either
+			 * of them and that at least one node would exist in ehash
+			 * table all the time. Otherwise there's a tiny chance
+			 * that lookup process could find nothing in ehash table.
+			 */
+			__sk_nulls_add_node_tail_rcu(sk, list);
+			sk_nulls_del_node_init_rcu(osk);
+		}
+		goto unlock;
+	}
+	if (found_dup_sk) {
 		*found_dup_sk = inet_ehash_lookup_by_sk(sk, list);
 		if (*found_dup_sk)
 			ret = false;
@@ -581,6 +593,7 @@ bool inet_ehash_insert(struct sock *sk, struct sock *osk, bool *found_dup_sk)
 	if (ret)
 		__sk_nulls_add_node_rcu(sk, list);
 
+unlock:
 	spin_unlock(lock);
 
 	return ret;
diff --git a/net/ipv4/inet_timewait_sock.c b/net/ipv4/inet_timewait_sock.c
index c411c87ae865..a00102d7c7fd 100644
--- a/net/ipv4/inet_timewait_sock.c
+++ b/net/ipv4/inet_timewait_sock.c
@@ -81,10 +81,10 @@ void inet_twsk_put(struct inet_timewait_sock *tw)
 }
 EXPORT_SYMBOL_GPL(inet_twsk_put);
 
-static void inet_twsk_add_node_rcu(struct inet_timewait_sock *tw,
-				   struct hlist_nulls_head *list)
+static void inet_twsk_add_node_tail_rcu(struct inet_timewait_sock *tw,
+					struct hlist_nulls_head *list)
 {
-	hlist_nulls_add_head_rcu(&tw->tw_node, list);
+	hlist_nulls_add_tail_rcu(&tw->tw_node, list);
 }
 
 static void inet_twsk_add_bind_node(struct inet_timewait_sock *tw,
@@ -120,7 +120,7 @@ void inet_twsk_hashdance(struct inet_timewait_sock *tw, struct sock *sk,
 
 	spin_lock(lock);
 
-	inet_twsk_add_node_rcu(tw, &ehead->chain);
+	inet_twsk_add_node_tail_rcu(tw, &ehead->chain);
 
 	/* Step 3: Remove SK from hash chain */
 	if (__sk_nulls_del_node_init_rcu(sk))
diff --git a/net/ipv4/metrics.c b/net/ipv4/metrics.c
index 3205d5f7c8c9..4966ac2aaf87 100644
--- a/net/ipv4/metrics.c
+++ b/net/ipv4/metrics.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 #include <linux/netlink.h>
+#include <linux/nospec.h>
 #include <linux/rtnetlink.h>
 #include <linux/types.h>
 #include <net/ip.h>
@@ -28,6 +29,7 @@ static int ip_metrics_convert(struct net *net, struct nlattr *fc_mx,
 			return -EINVAL;
 		}
 
+		type = array_index_nospec(type, RTAX_MAX + 1);
 		if (type == RTAX_CC_ALGO) {
 			char tmp[TCP_CA_NAME_MAX];
 
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index cc588bc2b11d..6a0560a735ce 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -432,6 +432,7 @@ void tcp_init_sock(struct sock *sk)
 
 	/* There's a bubble in the pipe until at least the first ACK. */
 	tp->app_limited = ~0U;
+	tp->rate_app_limited = 1;
 
 	/* See draft-stevens-tcpca-spec-01 for discussion of the
 	 * initialization of these values.
@@ -2837,6 +2838,7 @@ int tcp_disconnect(struct sock *sk, int flags)
 	tp->last_oow_ack_time = 0;
 	/* There's a bubble in the pipe until at least the first ACK. */
 	tp->app_limited = ~0U;
+	tp->rate_app_limited = 1;
 	tp->rack.mstamp = 0;
 	tp->rack.advanced = 0;
 	tp->rack.reo_wnd_steps = 1;
diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index dc8987ed08ad..a4b793d1b7d7 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -104,9 +104,9 @@ static struct workqueue_struct *l2tp_wq;
 /* per-net private data for this module */
 static unsigned int l2tp_net_id;
 struct l2tp_net {
-	struct list_head l2tp_tunnel_list;
-	/* Lock for write access to l2tp_tunnel_list */
-	spinlock_t l2tp_tunnel_list_lock;
+	/* Lock for write access to l2tp_tunnel_idr */
+	spinlock_t l2tp_tunnel_idr_lock;
+	struct idr l2tp_tunnel_idr;
 	struct hlist_head l2tp_session_hlist[L2TP_HASH_SIZE_2];
 	/* Lock for write access to l2tp_session_hlist */
 	spinlock_t l2tp_session_hlist_lock;
@@ -208,13 +208,10 @@ struct l2tp_tunnel *l2tp_tunnel_get(const struct net *net, u32 tunnel_id)
 	struct l2tp_tunnel *tunnel;
 
 	rcu_read_lock_bh();
-	list_for_each_entry_rcu(tunnel, &pn->l2tp_tunnel_list, list) {
-		if (tunnel->tunnel_id == tunnel_id &&
-		    refcount_inc_not_zero(&tunnel->ref_count)) {
-			rcu_read_unlock_bh();
-
-			return tunnel;
-		}
+	tunnel = idr_find(&pn->l2tp_tunnel_idr, tunnel_id);
+	if (tunnel && refcount_inc_not_zero(&tunnel->ref_count)) {
+		rcu_read_unlock_bh();
+		return tunnel;
 	}
 	rcu_read_unlock_bh();
 
@@ -224,13 +221,14 @@ EXPORT_SYMBOL_GPL(l2tp_tunnel_get);
 
 struct l2tp_tunnel *l2tp_tunnel_get_nth(const struct net *net, int nth)
 {
-	const struct l2tp_net *pn = l2tp_pernet(net);
+	struct l2tp_net *pn = l2tp_pernet(net);
+	unsigned long tunnel_id, tmp;
 	struct l2tp_tunnel *tunnel;
 	int count = 0;
 
 	rcu_read_lock_bh();
-	list_for_each_entry_rcu(tunnel, &pn->l2tp_tunnel_list, list) {
-		if (++count > nth &&
+	idr_for_each_entry_ul(&pn->l2tp_tunnel_idr, tunnel, tmp, tunnel_id) {
+		if (tunnel && ++count > nth &&
 		    refcount_inc_not_zero(&tunnel->ref_count)) {
 			rcu_read_unlock_bh();
 			return tunnel;
@@ -1043,7 +1041,7 @@ static int l2tp_xmit_core(struct l2tp_session *session, struct sk_buff *skb, uns
 	IPCB(skb)->flags &= ~(IPSKB_XFRM_TUNNEL_SIZE | IPSKB_XFRM_TRANSFORMED | IPSKB_REROUTED);
 	nf_reset_ct(skb);
 
-	bh_lock_sock(sk);
+	bh_lock_sock_nested(sk);
 	if (sock_owned_by_user(sk)) {
 		kfree_skb(skb);
 		ret = NET_XMIT_DROP;
@@ -1150,8 +1148,10 @@ static void l2tp_tunnel_destruct(struct sock *sk)
 	}
 
 	/* Remove hooks into tunnel socket */
+	write_lock_bh(&sk->sk_callback_lock);
 	sk->sk_destruct = tunnel->old_sk_destruct;
 	sk->sk_user_data = NULL;
+	write_unlock_bh(&sk->sk_callback_lock);
 
 	/* Call the original destructor */
 	if (sk->sk_destruct)
@@ -1227,6 +1227,15 @@ static void l2tp_udp_encap_destroy(struct sock *sk)
 		l2tp_tunnel_delete(tunnel);
 }
 
+static void l2tp_tunnel_remove(struct net *net, struct l2tp_tunnel *tunnel)
+{
+	struct l2tp_net *pn = l2tp_pernet(net);
+
+	spin_lock_bh(&pn->l2tp_tunnel_idr_lock);
+	idr_remove(&pn->l2tp_tunnel_idr, tunnel->tunnel_id);
+	spin_unlock_bh(&pn->l2tp_tunnel_idr_lock);
+}
+
 /* Workqueue tunnel deletion function */
 static void l2tp_tunnel_del_work(struct work_struct *work)
 {
@@ -1234,7 +1243,6 @@ static void l2tp_tunnel_del_work(struct work_struct *work)
 						  del_work);
 	struct sock *sk = tunnel->sock;
 	struct socket *sock = sk->sk_socket;
-	struct l2tp_net *pn;
 
 	l2tp_tunnel_closeall(tunnel);
 
@@ -1248,12 +1256,7 @@ static void l2tp_tunnel_del_work(struct work_struct *work)
 		}
 	}
 
-	/* Remove the tunnel struct from the tunnel list */
-	pn = l2tp_pernet(tunnel->l2tp_net);
-	spin_lock_bh(&pn->l2tp_tunnel_list_lock);
-	list_del_rcu(&tunnel->list);
-	spin_unlock_bh(&pn->l2tp_tunnel_list_lock);
-
+	l2tp_tunnel_remove(tunnel->l2tp_net, tunnel);
 	/* drop initial ref */
 	l2tp_tunnel_dec_refcount(tunnel);
 
@@ -1384,8 +1387,6 @@ static int l2tp_tunnel_sock_create(struct net *net,
 	return err;
 }
 
-static struct lock_class_key l2tp_socket_class;
-
 int l2tp_tunnel_create(int fd, int version, u32 tunnel_id, u32 peer_tunnel_id,
 		       struct l2tp_tunnel_cfg *cfg, struct l2tp_tunnel **tunnelp)
 {
@@ -1455,12 +1456,19 @@ static int l2tp_validate_socket(const struct sock *sk, const struct net *net,
 int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 			 struct l2tp_tunnel_cfg *cfg)
 {
-	struct l2tp_tunnel *tunnel_walk;
-	struct l2tp_net *pn;
+	struct l2tp_net *pn = l2tp_pernet(net);
+	u32 tunnel_id = tunnel->tunnel_id;
 	struct socket *sock;
 	struct sock *sk;
 	int ret;
 
+	spin_lock_bh(&pn->l2tp_tunnel_idr_lock);
+	ret = idr_alloc_u32(&pn->l2tp_tunnel_idr, NULL, &tunnel_id, tunnel_id,
+			    GFP_ATOMIC);
+	spin_unlock_bh(&pn->l2tp_tunnel_idr_lock);
+	if (ret)
+		return ret == -ENOSPC ? -EEXIST : ret;
+
 	if (tunnel->fd < 0) {
 		ret = l2tp_tunnel_sock_create(net, tunnel->tunnel_id,
 					      tunnel->peer_tunnel_id, cfg,
@@ -1471,30 +1479,16 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 		sock = sockfd_lookup(tunnel->fd, &ret);
 		if (!sock)
 			goto err;
-
-		ret = l2tp_validate_socket(sock->sk, net, tunnel->encap);
-		if (ret < 0)
-			goto err_sock;
 	}
 
-	tunnel->l2tp_net = net;
-	pn = l2tp_pernet(net);
-
 	sk = sock->sk;
-	sock_hold(sk);
-	tunnel->sock = sk;
-
-	spin_lock_bh(&pn->l2tp_tunnel_list_lock);
-	list_for_each_entry(tunnel_walk, &pn->l2tp_tunnel_list, list) {
-		if (tunnel_walk->tunnel_id == tunnel->tunnel_id) {
-			spin_unlock_bh(&pn->l2tp_tunnel_list_lock);
-			sock_put(sk);
-			ret = -EEXIST;
-			goto err_sock;
-		}
-	}
-	list_add_rcu(&tunnel->list, &pn->l2tp_tunnel_list);
-	spin_unlock_bh(&pn->l2tp_tunnel_list_lock);
+	lock_sock(sk);
+	write_lock_bh(&sk->sk_callback_lock);
+	ret = l2tp_validate_socket(sk, net, tunnel->encap);
+	if (ret < 0)
+		goto err_inval_sock;
+	rcu_assign_sk_user_data(sk, tunnel);
+	write_unlock_bh(&sk->sk_callback_lock);
 
 	if (tunnel->encap == L2TP_ENCAPTYPE_UDP) {
 		struct udp_tunnel_sock_cfg udp_cfg = {
@@ -1505,15 +1499,20 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 		};
 
 		setup_udp_tunnel_sock(net, sock, &udp_cfg);
-	} else {
-		sk->sk_user_data = tunnel;
 	}
 
 	tunnel->old_sk_destruct = sk->sk_destruct;
 	sk->sk_destruct = &l2tp_tunnel_destruct;
-	lockdep_set_class_and_name(&sk->sk_lock.slock, &l2tp_socket_class,
-				   "l2tp_sock");
 	sk->sk_allocation = GFP_ATOMIC;
+	release_sock(sk);
+
+	sock_hold(sk);
+	tunnel->sock = sk;
+	tunnel->l2tp_net = net;
+
+	spin_lock_bh(&pn->l2tp_tunnel_idr_lock);
+	idr_replace(&pn->l2tp_tunnel_idr, tunnel, tunnel->tunnel_id);
+	spin_unlock_bh(&pn->l2tp_tunnel_idr_lock);
 
 	trace_register_tunnel(tunnel);
 
@@ -1522,12 +1521,16 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 
 	return 0;
 
-err_sock:
+err_inval_sock:
+	write_unlock_bh(&sk->sk_callback_lock);
+	release_sock(sk);
+
 	if (tunnel->fd < 0)
 		sock_release(sock);
 	else
 		sockfd_put(sock);
 err:
+	l2tp_tunnel_remove(net, tunnel);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(l2tp_tunnel_register);
@@ -1641,8 +1644,8 @@ static __net_init int l2tp_init_net(struct net *net)
 	struct l2tp_net *pn = net_generic(net, l2tp_net_id);
 	int hash;
 
-	INIT_LIST_HEAD(&pn->l2tp_tunnel_list);
-	spin_lock_init(&pn->l2tp_tunnel_list_lock);
+	idr_init(&pn->l2tp_tunnel_idr);
+	spin_lock_init(&pn->l2tp_tunnel_idr_lock);
 
 	for (hash = 0; hash < L2TP_HASH_SIZE_2; hash++)
 		INIT_HLIST_HEAD(&pn->l2tp_session_hlist[hash]);
@@ -1656,11 +1659,13 @@ static __net_exit void l2tp_exit_net(struct net *net)
 {
 	struct l2tp_net *pn = l2tp_pernet(net);
 	struct l2tp_tunnel *tunnel = NULL;
+	unsigned long tunnel_id, tmp;
 	int hash;
 
 	rcu_read_lock_bh();
-	list_for_each_entry_rcu(tunnel, &pn->l2tp_tunnel_list, list) {
-		l2tp_tunnel_delete(tunnel);
+	idr_for_each_entry_ul(&pn->l2tp_tunnel_idr, tunnel, tmp, tunnel_id) {
+		if (tunnel)
+			l2tp_tunnel_delete(tunnel);
 	}
 	rcu_read_unlock_bh();
 
@@ -1670,6 +1675,7 @@ static __net_exit void l2tp_exit_net(struct net *net)
 
 	for (hash = 0; hash < L2TP_HASH_SIZE_2; hash++)
 		WARN_ON_ONCE(!hlist_empty(&pn->l2tp_session_hlist[hash]));
+	idr_destroy(&pn->l2tp_tunnel_idr);
 }
 
 static struct pernet_operations l2tp_net_ops = {
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 7626f3e1c70a..cec4b16170a0 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -27,22 +27,16 @@
 #include <net/netfilter/nf_conntrack_ecache.h>
 #include <net/netfilter/nf_conntrack_timeout.h>
 
-/* FIXME: Examine ipfilter's timeouts and conntrack transitions more
-   closely.  They're more complex. --RR
-
-   And so for me for SCTP :D -Kiran */
-
 static const char *const sctp_conntrack_names[] = {
-	"NONE",
-	"CLOSED",
-	"COOKIE_WAIT",
-	"COOKIE_ECHOED",
-	"ESTABLISHED",
-	"SHUTDOWN_SENT",
-	"SHUTDOWN_RECD",
-	"SHUTDOWN_ACK_SENT",
-	"HEARTBEAT_SENT",
-	"HEARTBEAT_ACKED",
+	[SCTP_CONNTRACK_NONE]			= "NONE",
+	[SCTP_CONNTRACK_CLOSED]			= "CLOSED",
+	[SCTP_CONNTRACK_COOKIE_WAIT]		= "COOKIE_WAIT",
+	[SCTP_CONNTRACK_COOKIE_ECHOED]		= "COOKIE_ECHOED",
+	[SCTP_CONNTRACK_ESTABLISHED]		= "ESTABLISHED",
+	[SCTP_CONNTRACK_SHUTDOWN_SENT]		= "SHUTDOWN_SENT",
+	[SCTP_CONNTRACK_SHUTDOWN_RECD]		= "SHUTDOWN_RECD",
+	[SCTP_CONNTRACK_SHUTDOWN_ACK_SENT]	= "SHUTDOWN_ACK_SENT",
+	[SCTP_CONNTRACK_HEARTBEAT_SENT]		= "HEARTBEAT_SENT",
 };
 
 #define SECS  * HZ
@@ -54,12 +48,11 @@ static const unsigned int sctp_timeouts[SCTP_CONNTRACK_MAX] = {
 	[SCTP_CONNTRACK_CLOSED]			= 10 SECS,
 	[SCTP_CONNTRACK_COOKIE_WAIT]		= 3 SECS,
 	[SCTP_CONNTRACK_COOKIE_ECHOED]		= 3 SECS,
-	[SCTP_CONNTRACK_ESTABLISHED]		= 5 DAYS,
+	[SCTP_CONNTRACK_ESTABLISHED]		= 210 SECS,
 	[SCTP_CONNTRACK_SHUTDOWN_SENT]		= 300 SECS / 1000,
 	[SCTP_CONNTRACK_SHUTDOWN_RECD]		= 300 SECS / 1000,
 	[SCTP_CONNTRACK_SHUTDOWN_ACK_SENT]	= 3 SECS,
 	[SCTP_CONNTRACK_HEARTBEAT_SENT]		= 30 SECS,
-	[SCTP_CONNTRACK_HEARTBEAT_ACKED]	= 210 SECS,
 };
 
 #define	SCTP_FLAG_HEARTBEAT_VTAG_FAILED	1
@@ -73,7 +66,6 @@ static const unsigned int sctp_timeouts[SCTP_CONNTRACK_MAX] = {
 #define	sSR SCTP_CONNTRACK_SHUTDOWN_RECD
 #define	sSA SCTP_CONNTRACK_SHUTDOWN_ACK_SENT
 #define	sHS SCTP_CONNTRACK_HEARTBEAT_SENT
-#define	sHA SCTP_CONNTRACK_HEARTBEAT_ACKED
 #define	sIV SCTP_CONNTRACK_MAX
 
 /*
@@ -96,9 +88,6 @@ SHUTDOWN_ACK_SENT - We have seen a SHUTDOWN_ACK chunk in the direction opposite
 CLOSED            - We have seen a SHUTDOWN_COMPLETE chunk in the direction of
 		    the SHUTDOWN chunk. Connection is closed.
 HEARTBEAT_SENT    - We have seen a HEARTBEAT in a new flow.
-HEARTBEAT_ACKED   - We have seen a HEARTBEAT-ACK in the direction opposite to
-		    that of the HEARTBEAT chunk. Secondary connection is
-		    established.
 */
 
 /* TODO
@@ -115,33 +104,33 @@ cookie echoed to closed.
 static const u8 sctp_conntracks[2][11][SCTP_CONNTRACK_MAX] = {
 	{
 /*	ORIGINAL	*/
-/*                  sNO, sCL, sCW, sCE, sES, sSS, sSR, sSA, sHS, sHA */
-/* init         */ {sCL, sCL, sCW, sCE, sES, sSS, sSR, sSA, sCW, sHA},
-/* init_ack     */ {sCL, sCL, sCW, sCE, sES, sSS, sSR, sSA, sCL, sHA},
-/* abort        */ {sCL, sCL, sCL, sCL, sCL, sCL, sCL, sCL, sCL, sCL},
-/* shutdown     */ {sCL, sCL, sCW, sCE, sSS, sSS, sSR, sSA, sCL, sSS},
-/* shutdown_ack */ {sSA, sCL, sCW, sCE, sES, sSA, sSA, sSA, sSA, sHA},
-/* error        */ {sCL, sCL, sCW, sCE, sES, sSS, sSR, sSA, sCL, sHA},/* Can't have Stale cookie*/
-/* cookie_echo  */ {sCL, sCL, sCE, sCE, sES, sSS, sSR, sSA, sCL, sHA},/* 5.2.4 - Big TODO */
-/* cookie_ack   */ {sCL, sCL, sCW, sCE, sES, sSS, sSR, sSA, sCL, sHA},/* Can't come in orig dir */
-/* shutdown_comp*/ {sCL, sCL, sCW, sCE, sES, sSS, sSR, sCL, sCL, sHA},
-/* heartbeat    */ {sHS, sCL, sCW, sCE, sES, sSS, sSR, sSA, sHS, sHA},
-/* heartbeat_ack*/ {sCL, sCL, sCW, sCE, sES, sSS, sSR, sSA, sHS, sHA}
+/*                  sNO, sCL, sCW, sCE, sES, sSS, sSR, sSA, sHS */
+/* init         */ {sCL, sCL, sCW, sCE, sES, sSS, sSR, sSA, sCW},
+/* init_ack     */ {sCL, sCL, sCW, sCE, sES, sSS, sSR, sSA, sCL},
+/* abort        */ {sCL, sCL, sCL, sCL, sCL, sCL, sCL, sCL, sCL},
+/* shutdown     */ {sCL, sCL, sCW, sCE, sSS, sSS, sSR, sSA, sCL},
+/* shutdown_ack */ {sSA, sCL, sCW, sCE, sES, sSA, sSA, sSA, sSA},
+/* error        */ {sCL, sCL, sCW, sCE, sES, sSS, sSR, sSA, sCL},/* Can't have Stale cookie*/
+/* cookie_echo  */ {sCL, sCL, sCE, sCE, sES, sSS, sSR, sSA, sCL},/* 5.2.4 - Big TODO */
+/* cookie_ack   */ {sCL, sCL, sCW, sCE, sES, sSS, sSR, sSA, sCL},/* Can't come in orig dir */
+/* shutdown_comp*/ {sCL, sCL, sCW, sCE, sES, sSS, sSR, sCL, sCL},
+/* heartbeat    */ {sHS, sCL, sCW, sCE, sES, sSS, sSR, sSA, sHS},
+/* heartbeat_ack*/ {sCL, sCL, sCW, sCE, sES, sSS, sSR, sSA, sHS},
 	},
 	{
 /*	REPLY	*/
-/*                  sNO, sCL, sCW, sCE, sES, sSS, sSR, sSA, sHS, sHA */
-/* init         */ {sIV, sCL, sCW, sCE, sES, sSS, sSR, sSA, sIV, sHA},/* INIT in sCL Big TODO */
-/* init_ack     */ {sIV, sCW, sCW, sCE, sES, sSS, sSR, sSA, sIV, sHA},
-/* abort        */ {sIV, sCL, sCL, sCL, sCL, sCL, sCL, sCL, sIV, sCL},
-/* shutdown     */ {sIV, sCL, sCW, sCE, sSR, sSS, sSR, sSA, sIV, sSR},
-/* shutdown_ack */ {sIV, sCL, sCW, sCE, sES, sSA, sSA, sSA, sIV, sHA},
-/* error        */ {sIV, sCL, sCW, sCL, sES, sSS, sSR, sSA, sIV, sHA},
-/* cookie_echo  */ {sIV, sCL, sCW, sCE, sES, sSS, sSR, sSA, sIV, sHA},/* Can't come in reply dir */
-/* cookie_ack   */ {sIV, sCL, sCW, sES, sES, sSS, sSR, sSA, sIV, sHA},
-/* shutdown_comp*/ {sIV, sCL, sCW, sCE, sES, sSS, sSR, sCL, sIV, sHA},
-/* heartbeat    */ {sIV, sCL, sCW, sCE, sES, sSS, sSR, sSA, sHS, sHA},
-/* heartbeat_ack*/ {sIV, sCL, sCW, sCE, sES, sSS, sSR, sSA, sHA, sHA}
+/*                  sNO, sCL, sCW, sCE, sES, sSS, sSR, sSA, sHS */
+/* init         */ {sIV, sCL, sCW, sCE, sES, sSS, sSR, sSA, sIV},/* INIT in sCL Big TODO */
+/* init_ack     */ {sIV, sCW, sCW, sCE, sES, sSS, sSR, sSA, sIV},
+/* abort        */ {sIV, sCL, sCL, sCL, sCL, sCL, sCL, sCL, sIV},
+/* shutdown     */ {sIV, sCL, sCW, sCE, sSR, sSS, sSR, sSA, sIV},
+/* shutdown_ack */ {sIV, sCL, sCW, sCE, sES, sSA, sSA, sSA, sIV},
+/* error        */ {sIV, sCL, sCW, sCL, sES, sSS, sSR, sSA, sIV},
+/* cookie_echo  */ {sIV, sCL, sCW, sCE, sES, sSS, sSR, sSA, sIV},/* Can't come in reply dir */
+/* cookie_ack   */ {sIV, sCL, sCW, sES, sES, sSS, sSR, sSA, sIV},
+/* shutdown_comp*/ {sIV, sCL, sCW, sCE, sES, sSS, sSR, sCL, sIV},
+/* heartbeat    */ {sIV, sCL, sCW, sCE, sES, sSS, sSR, sSA, sHS},
+/* heartbeat_ack*/ {sIV, sCL, sCW, sCE, sES, sSS, sSR, sSA, sES},
 	}
 };
 
@@ -412,22 +401,29 @@ int nf_conntrack_sctp_packet(struct nf_conn *ct,
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
 		} else if (sch->type == SCTP_CID_HEARTBEAT) {
@@ -501,8 +497,12 @@ int nf_conntrack_sctp_packet(struct nf_conn *ct,
 		}
 
 		ct->proto.sctp.state = new_state;
-		if (old_state != new_state)
+		if (old_state != new_state) {
 			nf_conntrack_event_cache(IPCT_PROTOINFO, ct);
+			if (new_state == SCTP_CONNTRACK_ESTABLISHED &&
+			    !test_and_set_bit(IPS_ASSURED_BIT, &ct->status))
+				nf_conntrack_event_cache(IPCT_ASSURED, ct);
+		}
 	}
 	spin_unlock_bh(&ct->lock);
 
@@ -516,14 +516,6 @@ int nf_conntrack_sctp_packet(struct nf_conn *ct,
 
 	nf_ct_refresh_acct(ct, ctinfo, skb, timeouts[new_state]);
 
-	if (old_state == SCTP_CONNTRACK_COOKIE_ECHOED &&
-	    dir == IP_CT_DIR_REPLY &&
-	    new_state == SCTP_CONNTRACK_ESTABLISHED) {
-		pr_debug("Setting assured bit\n");
-		set_bit(IPS_ASSURED_BIT, &ct->status);
-		nf_conntrack_event_cache(IPCT_ASSURED, ct);
-	}
-
 	return NF_ACCEPT;
 
 out_unlock:
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 3f785bdfa942..c1d02c0b4f00 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1158,6 +1158,16 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 			nf_ct_kill_acct(ct, ctinfo, skb);
 			return NF_ACCEPT;
 		}
+
+		if (index == TCP_SYN_SET && old_state == TCP_CONNTRACK_SYN_SENT) {
+			/* do not renew timeout on SYN retransmit.
+			 *
+			 * Else port reuse by client or NAT middlebox can keep
+			 * entry alive indefinitely (including nat info).
+			 */
+			return NF_ACCEPT;
+		}
+
 		/* ESTABLISHED without SEEN_REPLY, i.e. mid-connection
 		 * pickup with loose=1. Avoid large ESTABLISHED timeout.
 		 */
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index a7f88cdf3f87..e12b52019a55 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -583,7 +583,6 @@ enum nf_ct_sysctl_index {
 	NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_SHUTDOWN_RECD,
 	NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_SHUTDOWN_ACK_SENT,
 	NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_HEARTBEAT_SENT,
-	NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_HEARTBEAT_ACKED,
 #endif
 #ifdef CONFIG_NF_CT_PROTO_DCCP
 	NF_SYSCTL_CT_PROTO_TIMEOUT_DCCP_REQUEST,
@@ -853,12 +852,6 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_jiffies,
 	},
-	[NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_HEARTBEAT_ACKED] = {
-		.procname       = "nf_conntrack_sctp_timeout_heartbeat_acked",
-		.maxlen         = sizeof(unsigned int),
-		.mode           = 0644,
-		.proc_handler   = proc_dointvec_jiffies,
-	},
 #endif
 #ifdef CONFIG_NF_CT_PROTO_DCCP
 	[NF_SYSCTL_CT_PROTO_TIMEOUT_DCCP_REQUEST] = {
@@ -987,7 +980,6 @@ static void nf_conntrack_standalone_init_sctp_sysctl(struct net *net,
 	XASSIGN(SHUTDOWN_RECD, sn);
 	XASSIGN(SHUTDOWN_ACK_SENT, sn);
 	XASSIGN(HEARTBEAT_SENT, sn);
-	XASSIGN(HEARTBEAT_ACKED, sn);
 #undef XASSIGN
 #endif
 }
diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 94a5446c5eae..4b9a499fe8f4 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -38,10 +38,12 @@ static bool nft_rbtree_interval_start(const struct nft_rbtree_elem *rbe)
 	return !nft_rbtree_interval_end(rbe);
 }
 
-static bool nft_rbtree_equal(const struct nft_set *set, const void *this,
-			     const struct nft_rbtree_elem *interval)
+static int nft_rbtree_cmp(const struct nft_set *set,
+			  const struct nft_rbtree_elem *e1,
+			  const struct nft_rbtree_elem *e2)
 {
-	return memcmp(this, nft_set_ext_key(&interval->ext), set->klen) == 0;
+	return memcmp(nft_set_ext_key(&e1->ext), nft_set_ext_key(&e2->ext),
+		      set->klen);
 }
 
 static bool __nft_rbtree_lookup(const struct net *net, const struct nft_set *set,
@@ -52,7 +54,6 @@ static bool __nft_rbtree_lookup(const struct net *net, const struct nft_set *set
 	const struct nft_rbtree_elem *rbe, *interval = NULL;
 	u8 genmask = nft_genmask_cur(net);
 	const struct rb_node *parent;
-	const void *this;
 	int d;
 
 	parent = rcu_dereference_raw(priv->root.rb_node);
@@ -62,12 +63,11 @@ static bool __nft_rbtree_lookup(const struct net *net, const struct nft_set *set
 
 		rbe = rb_entry(parent, struct nft_rbtree_elem, node);
 
-		this = nft_set_ext_key(&rbe->ext);
-		d = memcmp(this, key, set->klen);
+		d = memcmp(nft_set_ext_key(&rbe->ext), key, set->klen);
 		if (d < 0) {
 			parent = rcu_dereference_raw(parent->rb_left);
 			if (interval &&
-			    nft_rbtree_equal(set, this, interval) &&
+			    !nft_rbtree_cmp(set, rbe, interval) &&
 			    nft_rbtree_interval_end(rbe) &&
 			    nft_rbtree_interval_start(interval))
 				continue;
@@ -214,154 +214,216 @@ static void *nft_rbtree_get(const struct net *net, const struct nft_set *set,
 	return rbe;
 }
 
+static int nft_rbtree_gc_elem(const struct nft_set *__set,
+			      struct nft_rbtree *priv,
+			      struct nft_rbtree_elem *rbe)
+{
+	struct nft_set *set = (struct nft_set *)__set;
+	struct rb_node *prev = rb_prev(&rbe->node);
+	struct nft_rbtree_elem *rbe_prev;
+	struct nft_set_gc_batch *gcb;
+
+	gcb = nft_set_gc_batch_check(set, NULL, GFP_ATOMIC);
+	if (!gcb)
+		return -ENOMEM;
+
+	/* search for expired end interval coming before this element. */
+	do {
+		rbe_prev = rb_entry(prev, struct nft_rbtree_elem, node);
+		if (nft_rbtree_interval_end(rbe_prev))
+			break;
+
+		prev = rb_prev(prev);
+	} while (prev != NULL);
+
+	rb_erase(&rbe_prev->node, &priv->root);
+	rb_erase(&rbe->node, &priv->root);
+	atomic_sub(2, &set->nelems);
+
+	nft_set_gc_batch_add(gcb, rbe);
+	nft_set_gc_batch_complete(gcb);
+
+	return 0;
+}
+
+static bool nft_rbtree_update_first(const struct nft_set *set,
+				    struct nft_rbtree_elem *rbe,
+				    struct rb_node *first)
+{
+	struct nft_rbtree_elem *first_elem;
+
+	first_elem = rb_entry(first, struct nft_rbtree_elem, node);
+	/* this element is closest to where the new element is to be inserted:
+	 * update the first element for the node list path.
+	 */
+	if (nft_rbtree_cmp(set, rbe, first_elem) < 0)
+		return true;
+
+	return false;
+}
+
 static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 			       struct nft_rbtree_elem *new,
 			       struct nft_set_ext **ext)
 {
-	bool overlap = false, dup_end_left = false, dup_end_right = false;
+	struct nft_rbtree_elem *rbe, *rbe_le = NULL, *rbe_ge = NULL;
+	struct rb_node *node, *parent, **p, *first = NULL;
 	struct nft_rbtree *priv = nft_set_priv(set);
 	u8 genmask = nft_genmask_next(net);
-	struct nft_rbtree_elem *rbe;
-	struct rb_node *parent, **p;
-	int d;
+	int d, err;
 
-	/* Detect overlaps as we descend the tree. Set the flag in these cases:
-	 *
-	 * a1. _ _ __>|  ?_ _ __|  (insert end before existing end)
-	 * a2. _ _ ___|  ?_ _ _>|  (insert end after existing end)
-	 * a3. _ _ ___? >|_ _ __|  (insert start before existing end)
-	 *
-	 * and clear it later on, as we eventually reach the points indicated by
-	 * '?' above, in the cases described below. We'll always meet these
-	 * later, locally, due to tree ordering, and overlaps for the intervals
-	 * that are the closest together are always evaluated last.
-	 *
-	 * b1. _ _ __>|  !_ _ __|  (insert end before existing start)
-	 * b2. _ _ ___|  !_ _ _>|  (insert end after existing start)
-	 * b3. _ _ ___! >|_ _ __|  (insert start after existing end, as a leaf)
-	 *            '--' no nodes falling in this range
-	 * b4.          >|_ _   !  (insert start before existing start)
-	 *
-	 * Case a3. resolves to b3.:
-	 * - if the inserted start element is the leftmost, because the '0'
-	 *   element in the tree serves as end element
-	 * - otherwise, if an existing end is found immediately to the left. If
-	 *   there are existing nodes in between, we need to further descend the
-	 *   tree before we can conclude the new start isn't causing an overlap
-	 *
-	 * or to b4., which, preceded by a3., means we already traversed one or
-	 * more existing intervals entirely, from the right.
-	 *
-	 * For a new, rightmost pair of elements, we'll hit cases b3. and b2.,
-	 * in that order.
-	 *
-	 * The flag is also cleared in two special cases:
-	 *
-	 * b5. |__ _ _!|<_ _ _   (insert start right before existing end)
-	 * b6. |__ _ >|!__ _ _   (insert end right after existing start)
-	 *
-	 * which always happen as last step and imply that no further
-	 * overlapping is possible.
-	 *
-	 * Another special case comes from the fact that start elements matching
-	 * an already existing start element are allowed: insertion is not
-	 * performed but we return -EEXIST in that case, and the error will be
-	 * cleared by the caller if NLM_F_EXCL is not present in the request.
-	 * This way, request for insertion of an exact overlap isn't reported as
-	 * error to userspace if not desired.
-	 *
-	 * However, if the existing start matches a pre-existing start, but the
-	 * end element doesn't match the corresponding pre-existing end element,
-	 * we need to report a partial overlap. This is a local condition that
-	 * can be noticed without need for a tracking flag, by checking for a
-	 * local duplicated end for a corresponding start, from left and right,
-	 * separately.
+	/* Descend the tree to search for an existing element greater than the
+	 * key value to insert that is greater than the new element. This is the
+	 * first element to walk the ordered elements to find possible overlap.
 	 */
-
 	parent = NULL;
 	p = &priv->root.rb_node;
 	while (*p != NULL) {
 		parent = *p;
 		rbe = rb_entry(parent, struct nft_rbtree_elem, node);
-		d = memcmp(nft_set_ext_key(&rbe->ext),
-			   nft_set_ext_key(&new->ext),
-			   set->klen);
+		d = nft_rbtree_cmp(set, rbe, new);
+
 		if (d < 0) {
 			p = &parent->rb_left;
-
-			if (nft_rbtree_interval_start(new)) {
-				if (nft_rbtree_interval_end(rbe) &&
-				    nft_set_elem_active(&rbe->ext, genmask) &&
-				    !nft_set_elem_expired(&rbe->ext) && !*p)
-					overlap = false;
-			} else {
-				if (dup_end_left && !*p)
-					return -ENOTEMPTY;
-
-				overlap = nft_rbtree_interval_end(rbe) &&
-					  nft_set_elem_active(&rbe->ext,
-							      genmask) &&
-					  !nft_set_elem_expired(&rbe->ext);
-
-				if (overlap) {
-					dup_end_right = true;
-					continue;
-				}
-			}
 		} else if (d > 0) {
-			p = &parent->rb_right;
+			if (!first ||
+			    nft_rbtree_update_first(set, rbe, first))
+				first = &rbe->node;
 
-			if (nft_rbtree_interval_end(new)) {
-				if (dup_end_right && !*p)
-					return -ENOTEMPTY;
-
-				overlap = nft_rbtree_interval_end(rbe) &&
-					  nft_set_elem_active(&rbe->ext,
-							      genmask) &&
-					  !nft_set_elem_expired(&rbe->ext);
-
-				if (overlap) {
-					dup_end_left = true;
-					continue;
-				}
-			} else if (nft_set_elem_active(&rbe->ext, genmask) &&
-				   !nft_set_elem_expired(&rbe->ext)) {
-				overlap = nft_rbtree_interval_end(rbe);
-			}
+			p = &parent->rb_right;
 		} else {
-			if (nft_rbtree_interval_end(rbe) &&
-			    nft_rbtree_interval_start(new)) {
+			if (nft_rbtree_interval_end(rbe))
 				p = &parent->rb_left;
-
-				if (nft_set_elem_active(&rbe->ext, genmask) &&
-				    !nft_set_elem_expired(&rbe->ext))
-					overlap = false;
-			} else if (nft_rbtree_interval_start(rbe) &&
-				   nft_rbtree_interval_end(new)) {
+			else
 				p = &parent->rb_right;
+		}
+	}
+
+	if (!first)
+		first = rb_first(&priv->root);
+
+	/* Detect overlap by going through the list of valid tree nodes.
+	 * Values stored in the tree are in reversed order, starting from
+	 * highest to lowest value.
+	 */
+	for (node = first; node != NULL; node = rb_next(node)) {
+		rbe = rb_entry(node, struct nft_rbtree_elem, node);
 
-				if (nft_set_elem_active(&rbe->ext, genmask) &&
-				    !nft_set_elem_expired(&rbe->ext))
-					overlap = false;
-			} else if (nft_set_elem_active(&rbe->ext, genmask) &&
-				   !nft_set_elem_expired(&rbe->ext)) {
-				*ext = &rbe->ext;
-				return -EEXIST;
-			} else {
-				overlap = false;
-				if (nft_rbtree_interval_end(rbe))
-					p = &parent->rb_left;
-				else
-					p = &parent->rb_right;
+		if (!nft_set_elem_active(&rbe->ext, genmask))
+			continue;
+
+		/* perform garbage collection to avoid bogus overlap reports. */
+		if (nft_set_elem_expired(&rbe->ext)) {
+			err = nft_rbtree_gc_elem(set, priv, rbe);
+			if (err < 0)
+				return err;
+
+			continue;
+		}
+
+		d = nft_rbtree_cmp(set, rbe, new);
+		if (d == 0) {
+			/* Matching end element: no need to look for an
+			 * overlapping greater or equal element.
+			 */
+			if (nft_rbtree_interval_end(rbe)) {
+				rbe_le = rbe;
+				break;
+			}
+
+			/* first element that is greater or equal to key value. */
+			if (!rbe_ge) {
+				rbe_ge = rbe;
+				continue;
+			}
+
+			/* this is a closer more or equal element, update it. */
+			if (nft_rbtree_cmp(set, rbe_ge, new) != 0) {
+				rbe_ge = rbe;
+				continue;
+			}
+
+			/* element is equal to key value, make sure flags are
+			 * the same, an existing more or equal start element
+			 * must not be replaced by more or equal end element.
+			 */
+			if ((nft_rbtree_interval_start(new) &&
+			     nft_rbtree_interval_start(rbe_ge)) ||
+			    (nft_rbtree_interval_end(new) &&
+			     nft_rbtree_interval_end(rbe_ge))) {
+				rbe_ge = rbe;
+				continue;
 			}
+		} else if (d > 0) {
+			/* annotate element greater than the new element. */
+			rbe_ge = rbe;
+			continue;
+		} else if (d < 0) {
+			/* annotate element less than the new element. */
+			rbe_le = rbe;
+			break;
 		}
+	}
 
-		dup_end_left = dup_end_right = false;
+	/* - new start element matching existing start element: full overlap
+	 *   reported as -EEXIST, cleared by caller if NLM_F_EXCL is not given.
+	 */
+	if (rbe_ge && !nft_rbtree_cmp(set, new, rbe_ge) &&
+	    nft_rbtree_interval_start(rbe_ge) == nft_rbtree_interval_start(new)) {
+		*ext = &rbe_ge->ext;
+		return -EEXIST;
 	}
 
-	if (overlap)
+	/* - new end element matching existing end element: full overlap
+	 *   reported as -EEXIST, cleared by caller if NLM_F_EXCL is not given.
+	 */
+	if (rbe_le && !nft_rbtree_cmp(set, new, rbe_le) &&
+	    nft_rbtree_interval_end(rbe_le) == nft_rbtree_interval_end(new)) {
+		*ext = &rbe_le->ext;
+		return -EEXIST;
+	}
+
+	/* - new start element with existing closest, less or equal key value
+	 *   being a start element: partial overlap, reported as -ENOTEMPTY.
+	 *   Anonymous sets allow for two consecutive start element since they
+	 *   are constant, skip them to avoid bogus overlap reports.
+	 */
+	if (!nft_set_is_anonymous(set) && rbe_le &&
+	    nft_rbtree_interval_start(rbe_le) && nft_rbtree_interval_start(new))
+		return -ENOTEMPTY;
+
+	/* - new end element with existing closest, less or equal key value
+	 *   being a end element: partial overlap, reported as -ENOTEMPTY.
+	 */
+	if (rbe_le &&
+	    nft_rbtree_interval_end(rbe_le) && nft_rbtree_interval_end(new))
 		return -ENOTEMPTY;
 
+	/* - new end element with existing closest, greater or equal key value
+	 *   being an end element: partial overlap, reported as -ENOTEMPTY
+	 */
+	if (rbe_ge &&
+	    nft_rbtree_interval_end(rbe_ge) && nft_rbtree_interval_end(new))
+		return -ENOTEMPTY;
+
+	/* Accepted element: pick insertion point depending on key value */
+	parent = NULL;
+	p = &priv->root.rb_node;
+	while (*p != NULL) {
+		parent = *p;
+		rbe = rb_entry(parent, struct nft_rbtree_elem, node);
+		d = nft_rbtree_cmp(set, rbe, new);
+
+		if (d < 0)
+			p = &parent->rb_left;
+		else if (d > 0)
+			p = &parent->rb_right;
+		else if (nft_rbtree_interval_end(rbe))
+			p = &parent->rb_left;
+		else
+			p = &parent->rb_right;
+	}
+
 	rb_link_node_rcu(&new->node, parent, p);
 	rb_insert_color(&new->node, &priv->root);
 	return 0;
@@ -500,23 +562,37 @@ static void nft_rbtree_gc(struct work_struct *work)
 	struct nft_rbtree *priv;
 	struct rb_node *node;
 	struct nft_set *set;
+	struct net *net;
+	u8 genmask;
 
 	priv = container_of(work, struct nft_rbtree, gc_work.work);
 	set  = nft_set_container_of(priv);
+	net  = read_pnet(&set->net);
+	genmask = nft_genmask_cur(net);
 
 	write_lock_bh(&priv->lock);
 	write_seqcount_begin(&priv->count);
 	for (node = rb_first(&priv->root); node != NULL; node = rb_next(node)) {
 		rbe = rb_entry(node, struct nft_rbtree_elem, node);
 
+		if (!nft_set_elem_active(&rbe->ext, genmask))
+			continue;
+
+		/* elements are reversed in the rbtree for historical reasons,
+		 * from highest to lowest value, that is why end element is
+		 * always visited before the start element.
+		 */
 		if (nft_rbtree_interval_end(rbe)) {
 			rbe_end = rbe;
 			continue;
 		}
 		if (!nft_set_elem_expired(&rbe->ext))
 			continue;
-		if (nft_set_elem_mark_busy(&rbe->ext))
+
+		if (nft_set_elem_mark_busy(&rbe->ext)) {
+			rbe_end = NULL;
 			continue;
+		}
 
 		if (rbe_prev) {
 			rb_erase(&rbe_prev->node, &priv->root);
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index d96a610929d9..2104fbdd63d2 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -570,7 +570,9 @@ static int netlink_insert(struct sock *sk, u32 portid)
 	if (nlk_sk(sk)->bound)
 		goto err;
 
-	nlk_sk(sk)->portid = portid;
+	/* portid can be read locklessly from netlink_getname(). */
+	WRITE_ONCE(nlk_sk(sk)->portid, portid);
+
 	sock_hold(sk);
 
 	err = __netlink_insert(table, sk);
@@ -1079,9 +1081,11 @@ static int netlink_connect(struct socket *sock, struct sockaddr *addr,
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
@@ -1102,9 +1106,11 @@ static int netlink_connect(struct socket *sock, struct sockaddr *addr,
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
@@ -1121,10 +1127,12 @@ static int netlink_getname(struct socket *sock, struct sockaddr *addr,
 	nladdr->nl_pad = 0;
 
 	if (peer) {
-		nladdr->nl_pid = nlk->dst_portid;
-		nladdr->nl_groups = netlink_group_mask(nlk->dst_group);
+		/* Paired with WRITE_ONCE() in netlink_connect() */
+		nladdr->nl_pid = READ_ONCE(nlk->dst_portid);
+		nladdr->nl_groups = netlink_group_mask(READ_ONCE(nlk->dst_group));
 	} else {
-		nladdr->nl_pid = nlk->portid;
+		/* Paired with WRITE_ONCE() in netlink_insert() */
+		nladdr->nl_pid = READ_ONCE(nlk->portid);
 		netlink_lock_table();
 		nladdr->nl_groups = nlk->groups ? nlk->groups[0] : 0;
 		netlink_unlock_table();
@@ -1151,8 +1159,9 @@ static struct sock *netlink_getsockbyportid(struct sock *ssk, u32 portid)
 
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
@@ -1888,8 +1897,9 @@ static int netlink_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
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
index a8da88db7893..4e7c968cde2d 100644
--- a/net/netrom/nr_timer.c
+++ b/net/netrom/nr_timer.c
@@ -121,6 +121,7 @@ static void nr_heartbeat_expiry(struct timer_list *t)
 		   is accepted() it isn't 'dead' so doesn't get removed. */
 		if (sock_flag(sk, SOCK_DESTROY) ||
 		    (sk->sk_state == TCP_LISTEN && sock_flag(sk, SOCK_DEAD))) {
+			sock_hold(sk);
 			bh_unlock_sock(sk);
 			nr_destroy_socket(sk);
 			goto out;
diff --git a/net/nfc/llcp_core.c b/net/nfc/llcp_core.c
index cc997518f79d..edadebb3efd2 100644
--- a/net/nfc/llcp_core.c
+++ b/net/nfc/llcp_core.c
@@ -159,6 +159,7 @@ static void local_cleanup(struct nfc_llcp_local *local)
 	cancel_work_sync(&local->rx_work);
 	cancel_work_sync(&local->timeout_work);
 	kfree_skb(local->rx_pending);
+	local->rx_pending = NULL;
 	del_timer_sync(&local->sdreq_timer);
 	cancel_work_sync(&local->sdreq_timeout_work);
 	nfc_llcp_free_sdp_tlv_list(&local->pending_sdreqs);
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 7f33b31c7b8b..e25fe44899ff 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1621,6 +1621,7 @@ static void taprio_reset(struct Qdisc *sch)
 	int i;
 
 	hrtimer_cancel(&q->advance_timer);
+
 	if (q->qdiscs) {
 		for (i = 0; i < dev->num_tx_queues; i++)
 			if (q->qdiscs[i])
@@ -1642,6 +1643,7 @@ static void taprio_destroy(struct Qdisc *sch)
 	 * happens in qdisc_create(), after taprio_init() has been called.
 	 */
 	hrtimer_cancel(&q->advance_timer);
+	qdisc_synchronize(sch);
 
 	taprio_disable_offload(dev, q, NULL);
 
diff --git a/net/sctp/bind_addr.c b/net/sctp/bind_addr.c
index 59e653b528b1..6b95d3ba8fe1 100644
--- a/net/sctp/bind_addr.c
+++ b/net/sctp/bind_addr.c
@@ -73,6 +73,12 @@ int sctp_bind_addr_copy(struct net *net, struct sctp_bind_addr *dest,
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
diff --git a/scripts/tracing/ftrace-bisect.sh b/scripts/tracing/ftrace-bisect.sh
index 926701162bc8..bb4f59262bbe 100755
--- a/scripts/tracing/ftrace-bisect.sh
+++ b/scripts/tracing/ftrace-bisect.sh
@@ -12,7 +12,7 @@
 #   (note, if this is a problem with function_graph tracing, then simply
 #    replace "function" with "function_graph" in the following steps).
 #
-#  # cd /sys/kernel/debug/tracing
+#  # cd /sys/kernel/tracing
 #  # echo schedule > set_ftrace_filter
 #  # echo function > current_tracer
 #
@@ -20,22 +20,40 @@
 #
 #  # echo nop > current_tracer
 #
-#  # cat available_filter_functions > ~/full-file
+# Starting with v5.1 this can be done with numbers, making it much faster:
+#
+# The old (slow) way, for kernels before v5.1.
+#
+# [old-way] # cat available_filter_functions > ~/full-file
+#
+# [old-way] *** Note ***  this process will take several minutes to update the
+# [old-way] filters. Setting multiple functions is an O(n^2) operation, and we
+# [old-way] are dealing with thousands of functions. So go have coffee, talk
+# [old-way] with your coworkers, read facebook. And eventually, this operation
+# [old-way] will end.
+#
+# The new way (using numbers) is an O(n) operation, and usually takes less than a second.
+#
+# seq `wc -l available_filter_functions | cut -d' ' -f1` > ~/full-file
+#
+# This will create a sequence of numbers that match the functions in
+# available_filter_functions, and when echoing in a number into the
+# set_ftrace_filter file, it will enable the corresponding function in
+# O(1) time. Making enabling all functions O(n) where n is the number of
+# functions to enable.
+#
+# For either the new or old way, the rest of the operations remain the same.
+#
 #  # ftrace-bisect ~/full-file ~/test-file ~/non-test-file
 #  # cat ~/test-file > set_ftrace_filter
 #
-# *** Note *** this will take several minutes. Setting multiple functions is
-# an O(n^2) operation, and we are dealing with thousands of functions. So go
-# have  coffee, talk with your coworkers, read facebook. And eventually, this
-# operation will end.
-#
 #  # echo function > current_tracer
 #
 # If it crashes, we know that ~/test-file has a bad function.
 #
 #   Reboot back to test kernel.
 #
-#     # cd /sys/kernel/debug/tracing
+#     # cd /sys/kernel/tracing
 #     # mv ~/test-file ~/full-file
 #
 # If it didn't crash.
diff --git a/security/tomoyo/Makefile b/security/tomoyo/Makefile
index cca5a3012fee..221eaadffb09 100644
--- a/security/tomoyo/Makefile
+++ b/security/tomoyo/Makefile
@@ -10,7 +10,7 @@ endef
 quiet_cmd_policy  = POLICY  $@
       cmd_policy  = ($(call do_policy,profile); $(call do_policy,exception_policy); $(call do_policy,domain_policy); $(call do_policy,manager); $(call do_policy,stat)) >$@
 
-$(obj)/builtin-policy.h: $(wildcard $(obj)/policy/*.conf $(src)/policy/*.conf.default) FORCE
+$(obj)/builtin-policy.h: $(wildcard $(obj)/policy/*.conf $(srctree)/$(src)/policy/*.conf.default) FORCE
 	$(call if_changed,policy)
 
 $(obj)/common.o: $(obj)/builtin-policy.h
diff --git a/sound/soc/fsl/fsl-asoc-card.c b/sound/soc/fsl/fsl-asoc-card.c
index 7cd14d6b9436..9a756d0a6032 100644
--- a/sound/soc/fsl/fsl-asoc-card.c
+++ b/sound/soc/fsl/fsl-asoc-card.c
@@ -117,11 +117,11 @@ static const struct snd_soc_dapm_route audio_map[] = {
 
 static const struct snd_soc_dapm_route audio_map_ac97[] = {
 	/* 1st half -- Normal DAPM routes */
-	{"Playback",  NULL, "AC97 Playback"},
-	{"AC97 Capture",  NULL, "Capture"},
+	{"AC97 Playback",  NULL, "CPU AC97 Playback"},
+	{"CPU AC97 Capture",  NULL, "AC97 Capture"},
 	/* 2nd half -- ASRC DAPM routes */
-	{"AC97 Playback",  NULL, "ASRC-Playback"},
-	{"ASRC-Capture",  NULL, "AC97 Capture"},
+	{"CPU AC97 Playback",  NULL, "ASRC-Playback"},
+	{"ASRC-Capture",  NULL, "CPU AC97 Capture"},
 };
 
 static const struct snd_soc_dapm_route audio_map_tx[] = {
diff --git a/sound/soc/fsl/fsl_micfil.c b/sound/soc/fsl/fsl_micfil.c
index 6c794605e33c..97f83c63e765 100644
--- a/sound/soc/fsl/fsl_micfil.c
+++ b/sound/soc/fsl/fsl_micfil.c
@@ -87,21 +87,21 @@ static DECLARE_TLV_DB_SCALE(gain_tlv, 0, 100, 0);
 
 static const struct snd_kcontrol_new fsl_micfil_snd_controls[] = {
 	SOC_SINGLE_SX_TLV("CH0 Volume", REG_MICFIL_OUT_CTRL,
-			  MICFIL_OUTGAIN_CHX_SHIFT(0), 0xF, 0x7, gain_tlv),
+			  MICFIL_OUTGAIN_CHX_SHIFT(0), 0x8, 0xF, gain_tlv),
 	SOC_SINGLE_SX_TLV("CH1 Volume", REG_MICFIL_OUT_CTRL,
-			  MICFIL_OUTGAIN_CHX_SHIFT(1), 0xF, 0x7, gain_tlv),
+			  MICFIL_OUTGAIN_CHX_SHIFT(1), 0x8, 0xF, gain_tlv),
 	SOC_SINGLE_SX_TLV("CH2 Volume", REG_MICFIL_OUT_CTRL,
-			  MICFIL_OUTGAIN_CHX_SHIFT(2), 0xF, 0x7, gain_tlv),
+			  MICFIL_OUTGAIN_CHX_SHIFT(2), 0x8, 0xF, gain_tlv),
 	SOC_SINGLE_SX_TLV("CH3 Volume", REG_MICFIL_OUT_CTRL,
-			  MICFIL_OUTGAIN_CHX_SHIFT(3), 0xF, 0x7, gain_tlv),
+			  MICFIL_OUTGAIN_CHX_SHIFT(3), 0x8, 0xF, gain_tlv),
 	SOC_SINGLE_SX_TLV("CH4 Volume", REG_MICFIL_OUT_CTRL,
-			  MICFIL_OUTGAIN_CHX_SHIFT(4), 0xF, 0x7, gain_tlv),
+			  MICFIL_OUTGAIN_CHX_SHIFT(4), 0x8, 0xF, gain_tlv),
 	SOC_SINGLE_SX_TLV("CH5 Volume", REG_MICFIL_OUT_CTRL,
-			  MICFIL_OUTGAIN_CHX_SHIFT(5), 0xF, 0x7, gain_tlv),
+			  MICFIL_OUTGAIN_CHX_SHIFT(5), 0x8, 0xF, gain_tlv),
 	SOC_SINGLE_SX_TLV("CH6 Volume", REG_MICFIL_OUT_CTRL,
-			  MICFIL_OUTGAIN_CHX_SHIFT(6), 0xF, 0x7, gain_tlv),
+			  MICFIL_OUTGAIN_CHX_SHIFT(6), 0x8, 0xF, gain_tlv),
 	SOC_SINGLE_SX_TLV("CH7 Volume", REG_MICFIL_OUT_CTRL,
-			  MICFIL_OUTGAIN_CHX_SHIFT(7), 0xF, 0x7, gain_tlv),
+			  MICFIL_OUTGAIN_CHX_SHIFT(7), 0x8, 0xF, gain_tlv),
 	SOC_ENUM_EXT("MICFIL Quality Select",
 		     fsl_micfil_quality_enum,
 		     snd_soc_get_enum_double, snd_soc_put_enum_double),
diff --git a/sound/soc/fsl/fsl_ssi.c b/sound/soc/fsl/fsl_ssi.c
index 1d774c876c52..94229ce1a30e 100644
--- a/sound/soc/fsl/fsl_ssi.c
+++ b/sound/soc/fsl/fsl_ssi.c
@@ -1161,14 +1161,14 @@ static struct snd_soc_dai_driver fsl_ssi_ac97_dai = {
 	.symmetric_channels = 1,
 	.probe = fsl_ssi_dai_probe,
 	.playback = {
-		.stream_name = "AC97 Playback",
+		.stream_name = "CPU AC97 Playback",
 		.channels_min = 2,
 		.channels_max = 2,
 		.rates = SNDRV_PCM_RATE_8000_48000,
 		.formats = SNDRV_PCM_FMTBIT_S16 | SNDRV_PCM_FMTBIT_S20,
 	},
 	.capture = {
-		.stream_name = "AC97 Capture",
+		.stream_name = "CPU AC97 Capture",
 		.channels_min = 2,
 		.channels_max = 2,
 		.rates = SNDRV_PCM_RATE_48000,
diff --git a/tools/gpio/gpio-event-mon.c b/tools/gpio/gpio-event-mon.c
index 84ae1039b0a8..367c10636890 100644
--- a/tools/gpio/gpio-event-mon.c
+++ b/tools/gpio/gpio-event-mon.c
@@ -86,6 +86,7 @@ int monitor_device(const char *device_name,
 			gpiotools_test_bit(values.bits, i));
 	}
 
+	i = 0;
 	while (1) {
 		struct gpio_v2_line_event event;
 
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 700984e7f5ba..985bcc5cea8a 100644
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
+		"rewind_stack_and_make_dead",
 		"kunit_try_catch_throw",
 		"xen_start_kernel",
 		"cpu_bringup_and_idle",
diff --git a/tools/testing/selftests/bpf/prog_tests/jeq_infer_not_null.c b/tools/testing/selftests/bpf/prog_tests/jeq_infer_not_null.c
deleted file mode 100644
index 3add34df5767..000000000000
--- a/tools/testing/selftests/bpf/prog_tests/jeq_infer_not_null.c
+++ /dev/null
@@ -1,9 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-
-#include <test_progs.h>
-#include "jeq_infer_not_null_fail.skel.h"
-
-void test_jeq_infer_not_null(void)
-{
-	RUN_TESTS(jeq_infer_not_null_fail);
-}
diff --git a/tools/testing/selftests/bpf/progs/jeq_infer_not_null_fail.c b/tools/testing/selftests/bpf/progs/jeq_infer_not_null_fail.c
deleted file mode 100644
index f46965053acb..000000000000
--- a/tools/testing/selftests/bpf/progs/jeq_infer_not_null_fail.c
+++ /dev/null
@@ -1,42 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-
-#include "vmlinux.h"
-#include <bpf/bpf_helpers.h>
-#include "bpf_misc.h"
-
-char _license[] SEC("license") = "GPL";
-
-struct {
-	__uint(type, BPF_MAP_TYPE_HASH);
-	__uint(max_entries, 1);
-	__type(key, u64);
-	__type(value, u64);
-} m_hash SEC(".maps");
-
-SEC("?raw_tp")
-__failure __msg("R8 invalid mem access 'map_value_or_null")
-int jeq_infer_not_null_ptr_to_btfid(void *ctx)
-{
-	struct bpf_map *map = (struct bpf_map *)&m_hash;
-	struct bpf_map *inner_map = map->inner_map_meta;
-	u64 key = 0, ret = 0, *val;
-
-	val = bpf_map_lookup_elem(map, &key);
-	/* Do not mark ptr as non-null if one of them is
-	 * PTR_TO_BTF_ID (R9), reject because of invalid
-	 * access to map value (R8).
-	 *
-	 * Here, we need to inline those insns to access
-	 * R8 directly, since compiler may use other reg
-	 * once it figures out val==inner_map.
-	 */
-	asm volatile("r8 = %[val];\n"
-		     "r9 = %[inner_map];\n"
-		     "if r8 != r9 goto +1;\n"
-		     "%[ret] = *(u64 *)(r8 +0);\n"
-		     : [ret] "+r"(ret)
-		     : [inner_map] "r"(inner_map), [val] "r"(val)
-		     : "r8", "r9");
-
-	return ret;
-}
diff --git a/tools/testing/selftests/ftrace/test.d/trigger/inter-event/trigger-synthetic_event_syntax_errors.tc b/tools/testing/selftests/ftrace/test.d/trigger/inter-event/trigger-synthetic_event_syntax_errors.tc
index 955e3ceea44b..ada594fe16cb 100644
--- a/tools/testing/selftests/ftrace/test.d/trigger/inter-event/trigger-synthetic_event_syntax_errors.tc
+++ b/tools/testing/selftests/ftrace/test.d/trigger/inter-event/trigger-synthetic_event_syntax_errors.tc
@@ -1,38 +1,19 @@
 #!/bin/sh
 # SPDX-License-Identifier: GPL-2.0
 # description: event trigger - test synthetic_events syntax parser errors
-# requires: synthetic_events error_log "char name[]' >> synthetic_events":README
+# requires: synthetic_events error_log
 
 check_error() { # command-with-error-pos-by-^
     ftrace_errlog_check 'synthetic_events' "$1" 'synthetic_events'
 }
 
-check_dyn_error() { # command-with-error-pos-by-^
-    ftrace_errlog_check 'synthetic_events' "$1" 'dynamic_events'
-}
-
 check_error 'myevent ^chr arg'			# INVALID_TYPE
-check_error 'myevent ^unsigned arg'		# INCOMPLETE_TYPE
-
-check_error 'myevent char ^str]; int v'		# BAD_NAME
-check_error '^mye-vent char str[]'		# BAD_NAME
-check_error 'myevent char ^st-r[]'		# BAD_NAME
-
-check_error 'myevent char str;^[]'		# INVALID_FIELD
-check_error 'myevent char str; ^int'		# INVALID_FIELD
-
-check_error 'myevent char ^str[; int v'		# INVALID_ARRAY_SPEC
-check_error 'myevent char ^str[kdjdk]'		# INVALID_ARRAY_SPEC
-check_error 'myevent char ^str[257]'		# INVALID_ARRAY_SPEC
-
-check_error '^mye;vent char str[]'		# INVALID_CMD
-check_error '^myevent ; char str[]'		# INVALID_CMD
-check_error '^myevent; char str[]'		# INVALID_CMD
-check_error '^myevent ;char str[]'		# INVALID_CMD
-check_error '^; char str[]'			# INVALID_CMD
-check_error '^;myevent char str[]'		# INVALID_CMD
-check_error '^myevent'				# INVALID_CMD
-
-check_dyn_error '^s:junk/myevent char str['	# INVALID_DYN_CMD
+check_error 'myevent ^char str[];; int v'	# INVALID_TYPE
+check_error 'myevent char ^str]; int v'		# INVALID_NAME
+check_error 'myevent char ^str;[]'		# INVALID_NAME
+check_error 'myevent ^char str[; int v'		# INVALID_TYPE
+check_error '^mye;vent char str[]'		# BAD_NAME
+check_error 'myevent char str[]; ^int'		# INVALID_FIELD
+check_error '^myevent'				# INCOMPLETE_CMD
 
 exit 0
