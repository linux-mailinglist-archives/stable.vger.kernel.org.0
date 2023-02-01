Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 824B26860D5
	for <lists+stable@lfdr.de>; Wed,  1 Feb 2023 08:43:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbjBAHnw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Feb 2023 02:43:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231513AbjBAHnu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Feb 2023 02:43:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0E8659279;
        Tue, 31 Jan 2023 23:43:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18E186162A;
        Wed,  1 Feb 2023 07:43:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C68AC433EF;
        Wed,  1 Feb 2023 07:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675237422;
        bh=UicUSdeb3ozZhpaQCW+dn6egs+jbAsGF6eHOdw7LtbM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tA7rE2ThOjxxLK4tDz9nqamkkDEtEF8UnibY8HOE1Eb3MPL3qKeVjTMXnzwW5waBt
         SlNjFWQuxMEZWM781eowQb8E6/Bc43vFxUaijVhBBkCAcupWhuXIi+elobzR/KoIII
         mvLelYcQxp7TzT5DB89Sq09hTkTozOH2iIKQSj0k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.91
Date:   Wed,  1 Feb 2023 08:43:35 +0100
Message-Id: <16752374147189@kroah.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <167523741424550@kroah.com>
References: <167523741424550@kroah.com>
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
index 609b89175408..48b91c485c99 100644
--- a/Documentation/admin-guide/sysctl/kernel.rst
+++ b/Documentation/admin-guide/sysctl/kernel.rst
@@ -671,6 +671,15 @@ This is the default behavior.
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
 
@@ -1485,6 +1494,16 @@ entry will default to 2 instead of 0.
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
index 028d23841df8..02b2ade89c51 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 90
+SUBLEVEL = 91
 EXTRAVERSION =
 NAME = Trick or Treat
 
@@ -430,6 +430,7 @@ else
 HOSTCC	= gcc
 HOSTCXX	= g++
 endif
+HOSTPKG_CONFIG	= pkg-config
 
 export KBUILD_USERCFLAGS := -Wall -Wmissing-prototypes -Wstrict-prototypes \
 			      -O2 -fomit-frame-pointer -std=gnu89
@@ -525,7 +526,7 @@ KBUILD_LDFLAGS_MODULE :=
 KBUILD_LDFLAGS :=
 CLANG_FLAGS :=
 
-export ARCH SRCARCH CONFIG_SHELL BASH HOSTCC KBUILD_HOSTCFLAGS CROSS_COMPILE LD CC
+export ARCH SRCARCH CONFIG_SHELL BASH HOSTCC KBUILD_HOSTCFLAGS CROSS_COMPILE LD CC HOSTPKG_CONFIG
 export CPP AR NM STRIP OBJCOPY OBJDUMP READELF PAHOLE RESOLVE_BTFIDS LEX YACC AWK INSTALLKERNEL
 export PERL PYTHON3 CHECK CHECKFLAGS MAKE UTS_MACHINE HOSTCXX
 export KGZIP KBZIP2 KLZOP LZMA LZ4 XZ ZSTD
diff --git a/arch/alpha/kernel/traps.c b/arch/alpha/kernel/traps.c
index e805106409f7..f5ba12adde67 100644
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
index eee5102c3d88..e9193d52222e 100644
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
index 4bc4371e6bae..4b81a975c979 100644
--- a/arch/arm/boot/dts/imx6qdl-gw560x.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-gw560x.dtsi
@@ -632,7 +632,6 @@ &ssi1 {
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
index 54abd8720dde..91e757bb054e 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -334,7 +334,7 @@ static void oops_end(unsigned long flags, struct pt_regs *regs, int signr)
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
index 88feffebae21..80613674deb5 100644
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
index 94e5fa8ca957..bb18354c10f0 100644
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
@@ -186,7 +186,7 @@ pinctrl_espi2: espi2grp {
 			MX8MM_IOMUXC_ECSPI2_SCLK_ECSPI2_SCLK		0x82
 			MX8MM_IOMUXC_ECSPI2_MOSI_ECSPI2_MOSI		0x82
 			MX8MM_IOMUXC_ECSPI2_MISO_ECSPI2_MISO		0x82
-			MX8MM_IOMUXC_ECSPI1_SS0_GPIO5_IO9		0x41
+			MX8MM_IOMUXC_ECSPI2_SS0_GPIO5_IO13              0x41
 		>;
 	};
 
diff --git a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw7901.dts b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw7901.dts
index bafd5c8ea4e2..f7e41e5c2c7b 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw7901.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw7901.dts
@@ -675,6 +675,7 @@ &usbotg1 {
 &usbotg2 {
 	dr_mode = "host";
 	vbus-supply = <&reg_usb2_vbus>;
+	over-current-active-low;
 	status = "okay";
 };
 
diff --git a/arch/arm64/boot/dts/freescale/imx8mp-phycore-som.dtsi b/arch/arm64/boot/dts/freescale/imx8mp-phycore-som.dtsi
index fc178eebf8aa..8e189d899794 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-phycore-som.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-phycore-som.dtsi
@@ -98,7 +98,6 @@ pmic: pmic@25 {
 
 		regulators {
 			buck1: BUCK1 {
-				regulator-compatible = "BUCK1";
 				regulator-min-microvolt = <600000>;
 				regulator-max-microvolt = <2187500>;
 				regulator-boot-on;
@@ -107,7 +106,6 @@ buck1: BUCK1 {
 			};
 
 			buck2: BUCK2 {
-				regulator-compatible = "BUCK2";
 				regulator-min-microvolt = <600000>;
 				regulator-max-microvolt = <2187500>;
 				regulator-boot-on;
@@ -116,7 +114,6 @@ buck2: BUCK2 {
 			};
 
 			buck4: BUCK4 {
-				regulator-compatible = "BUCK4";
 				regulator-min-microvolt = <600000>;
 				regulator-max-microvolt = <3400000>;
 				regulator-boot-on;
@@ -124,7 +121,6 @@ buck4: BUCK4 {
 			};
 
 			buck5: BUCK5 {
-				regulator-compatible = "BUCK5";
 				regulator-min-microvolt = <600000>;
 				regulator-max-microvolt = <3400000>;
 				regulator-boot-on;
@@ -132,7 +128,6 @@ buck5: BUCK5 {
 			};
 
 			buck6: BUCK6 {
-				regulator-compatible = "BUCK6";
 				regulator-min-microvolt = <600000>;
 				regulator-max-microvolt = <3400000>;
 				regulator-boot-on;
@@ -140,7 +135,6 @@ buck6: BUCK6 {
 			};
 
 			ldo1: LDO1 {
-				regulator-compatible = "LDO1";
 				regulator-min-microvolt = <1600000>;
 				regulator-max-microvolt = <3300000>;
 				regulator-boot-on;
@@ -148,7 +142,6 @@ ldo1: LDO1 {
 			};
 
 			ldo2: LDO2 {
-				regulator-compatible = "LDO2";
 				regulator-min-microvolt = <800000>;
 				regulator-max-microvolt = <1150000>;
 				regulator-boot-on;
@@ -156,7 +149,6 @@ ldo2: LDO2 {
 			};
 
 			ldo3: LDO3 {
-				regulator-compatible = "LDO3";
 				regulator-min-microvolt = <800000>;
 				regulator-max-microvolt = <3300000>;
 				regulator-boot-on;
@@ -164,7 +156,6 @@ ldo3: LDO3 {
 			};
 
 			ldo4: LDO4 {
-				regulator-compatible = "LDO4";
 				regulator-min-microvolt = <800000>;
 				regulator-max-microvolt = <3300000>;
 				regulator-boot-on;
@@ -172,7 +163,6 @@ ldo4: LDO4 {
 			};
 
 			ldo5: LDO5 {
-				regulator-compatible = "LDO5";
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <3300000>;
 			};
diff --git a/arch/arm64/boot/dts/qcom/msm8992-xiaomi-libra.dts b/arch/arm64/boot/dts/qcom/msm8992-xiaomi-libra.dts
index a3d6340a0c55..d08659c606b9 100644
--- a/arch/arm64/boot/dts/qcom/msm8992-xiaomi-libra.dts
+++ b/arch/arm64/boot/dts/qcom/msm8992-xiaomi-libra.dts
@@ -11,6 +11,12 @@
 #include <dt-bindings/gpio/gpio.h>
 #include <dt-bindings/input/gpio-keys.h>
 
+/delete-node/ &adsp_mem;
+/delete-node/ &audio_mem;
+/delete-node/ &mpss_mem;
+/delete-node/ &peripheral_region;
+/delete-node/ &rmtfs_mem;
+
 / {
 	model = "Xiaomi Mi 4C";
 	compatible = "xiaomi,libra", "qcom,msm8992";
@@ -60,24 +66,66 @@ reserved-memory {
 		#size-cells = <2>;
 		ranges;
 
-		/* This is for getting crash logs using Android downstream kernels */
-		ramoops@dfc00000 {
-			compatible = "ramoops";
-			reg = <0x0 0xdfc00000 0x0 0x40000>;
-			console-size = <0x10000>;
-			record-size = <0x10000>;
-			ftrace-size = <0x10000>;
-			pmsg-size = <0x20000>;
+		memory_hole: hole@6400000 {
+			reg = <0 0x06400000 0 0x600000>;
+			no-map;
+		};
+
+		memory_hole2: hole2@6c00000 {
+			reg = <0 0x06c00000 0 0x2400000>;
+			no-map;
+		};
+
+		mpss_mem: mpss@9000000 {
+			reg = <0 0x09000000 0 0x5a00000>;
+			no-map;
+		};
+
+		tzapp: tzapp@ea00000 {
+			reg = <0 0x0ea00000 0 0x1900000>;
+			no-map;
 		};
 
-		modem_region: modem_region@9000000 {
-			reg = <0x0 0x9000000 0x0 0x5a00000>;
+		mdm_rfsa_mem: mdm-rfsa@ca0b0000 {
+			reg = <0 0xca0b0000 0 0x10000>;
 			no-map;
 		};
 
-		tzapp: modem_region@ea00000 {
-			reg = <0x0 0xea00000 0x0 0x1900000>;
+		rmtfs_mem: rmtfs@ca100000 {
+			compatible = "qcom,rmtfs-mem";
+			reg = <0 0xca100000 0 0x180000>;
 			no-map;
+
+			qcom,client-id = <1>;
+		};
+
+		audio_mem: audio@cb400000 {
+			reg = <0 0xcb000000 0 0x400000>;
+			no-mem;
+		};
+
+		qseecom_mem: qseecom@cb400000 {
+			reg = <0 0xcb400000 0 0x1c00000>;
+			no-mem;
+		};
+
+		adsp_rfsa_mem: adsp-rfsa@cd000000 {
+			reg = <0 0xcd000000 0 0x10000>;
+			no-map;
+		};
+
+		sensor_rfsa_mem: sensor-rfsa@cd010000 {
+			reg = <0 0xcd010000 0 0x10000>;
+			no-map;
+		};
+
+		ramoops@dfc00000 {
+			compatible = "ramoops";
+			reg = <0 0xdfc00000 0 0x40000>;
+			console-size = <0x10000>;
+			record-size = <0x10000>;
+			ftrace-size = <0x10000>;
+			pmsg-size = <0x20000>;
 		};
 	};
 };
@@ -120,9 +168,21 @@ &blsp2_uart2 {
 	status = "okay";
 };
 
-&peripheral_region {
-	reg = <0x0 0x7400000 0x0 0x1c00000>;
-	no-map;
+&pm8994_spmi_regulators {
+	VDD_APC0: s8 {
+		regulator-min-microvolt = <680000>;
+		regulator-max-microvolt = <1180000>;
+		regulator-always-on;
+		regulator-boot-on;
+	};
+
+	/* APC1 is 3-phase, but quoting downstream, s11 is "the gang leader" */
+	VDD_APC1: s11 {
+		regulator-min-microvolt = <700000>;
+		regulator-max-microvolt = <1225000>;
+		regulator-always-on;
+		regulator-boot-on;
+	};
 };
 
 &rpm_requests {
diff --git a/arch/arm64/boot/dts/qcom/msm8992.dtsi b/arch/arm64/boot/dts/qcom/msm8992.dtsi
index 58fe58cc7703..765e1f1989b5 100644
--- a/arch/arm64/boot/dts/qcom/msm8992.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8992.dtsi
@@ -14,10 +14,6 @@ &rpmcc {
 	compatible = "qcom,rpmcc-msm8992";
 };
 
-&tcsr_mutex {
-	compatible = "qcom,sfpb-mutex";
-};
-
 &timer {
 	interrupts = <GIC_PPI 2 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_LOW)>,
 			     <GIC_PPI 3 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_LOW)>,
diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index f859cc870d5b..21e69a991bc8 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -235,7 +235,7 @@ void die(const char *str, struct pt_regs *regs, int err)
 	raw_spin_unlock_irqrestore(&die_lock, flags);
 
 	if (ret != NOTIFY_STOP)
-		do_exit(SIGSEGV);
+		make_task_dead(SIGSEGV);
 }
 
 static void arm64_show_signal(int signo, const char *str)
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 21a6207fb2ee..8eb70451323b 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -347,26 +347,23 @@ int vgic_v3_lpi_sync_pending_status(struct kvm *kvm, struct vgic_irq *irq)
  * The deactivation of the doorbell interrupt will trigger the
  * unmapping of the associated vPE.
  */
-static void unmap_all_vpes(struct vgic_dist *dist)
+static void unmap_all_vpes(struct kvm *kvm)
 {
-	struct irq_desc *desc;
+	struct vgic_dist *dist = &kvm->arch.vgic;
 	int i;
 
-	for (i = 0; i < dist->its_vm.nr_vpes; i++) {
-		desc = irq_to_desc(dist->its_vm.vpes[i]->irq);
-		irq_domain_deactivate_irq(irq_desc_get_irq_data(desc));
-	}
+	for (i = 0; i < dist->its_vm.nr_vpes; i++)
+		free_irq(dist->its_vm.vpes[i]->irq, kvm_get_vcpu(kvm, i));
 }
 
-static void map_all_vpes(struct vgic_dist *dist)
+static void map_all_vpes(struct kvm *kvm)
 {
-	struct irq_desc *desc;
+	struct vgic_dist *dist = &kvm->arch.vgic;
 	int i;
 
-	for (i = 0; i < dist->its_vm.nr_vpes; i++) {
-		desc = irq_to_desc(dist->its_vm.vpes[i]->irq);
-		irq_domain_activate_irq(irq_desc_get_irq_data(desc), false);
-	}
+	for (i = 0; i < dist->its_vm.nr_vpes; i++)
+		WARN_ON(vgic_v4_request_vpe_irq(kvm_get_vcpu(kvm, i),
+						dist->its_vm.vpes[i]->irq));
 }
 
 /**
@@ -391,7 +388,7 @@ int vgic_v3_save_pending_tables(struct kvm *kvm)
 	 * and enabling of the doorbells have already been done.
 	 */
 	if (kvm_vgic_global_state.has_gicv4_1) {
-		unmap_all_vpes(dist);
+		unmap_all_vpes(kvm);
 		vlpi_avail = true;
 	}
 
@@ -441,7 +438,7 @@ int vgic_v3_save_pending_tables(struct kvm *kvm)
 
 out:
 	if (vlpi_avail)
-		map_all_vpes(dist);
+		map_all_vpes(kvm);
 
 	return ret;
 }
diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
index c1845d8f5f7e..f507e3fcffce 100644
--- a/arch/arm64/kvm/vgic/vgic-v4.c
+++ b/arch/arm64/kvm/vgic/vgic-v4.c
@@ -222,6 +222,11 @@ void vgic_v4_get_vlpi_state(struct vgic_irq *irq, bool *val)
 	*val = !!(*ptr & mask);
 }
 
+int vgic_v4_request_vpe_irq(struct kvm_vcpu *vcpu, int irq)
+{
+	return request_irq(irq, vgic_v4_doorbell_handler, 0, "vcpu", vcpu);
+}
+
 /**
  * vgic_v4_init - Initialize the GICv4 data structures
  * @kvm:	Pointer to the VM being initialized
@@ -282,8 +287,7 @@ int vgic_v4_init(struct kvm *kvm)
 			irq_flags &= ~IRQ_NOAUTOEN;
 		irq_set_status_flags(irq, irq_flags);
 
-		ret = request_irq(irq, vgic_v4_doorbell_handler,
-				  0, "vcpu", vcpu);
+		ret = vgic_v4_request_vpe_irq(vcpu, irq);
 		if (ret) {
 			kvm_err("failed to allocate vcpu IRQ%d\n", irq);
 			/*
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 14a9218641f5..36021c31a706 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -321,5 +321,6 @@ int vgic_v4_init(struct kvm *kvm);
 void vgic_v4_teardown(struct kvm *kvm);
 void vgic_v4_configure_vsgis(struct kvm *kvm);
 void vgic_v4_get_vlpi_state(struct vgic_irq *irq, bool *val);
+int vgic_v4_request_vpe_irq(struct kvm_vcpu *vcpu, int irq);
 
 #endif
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index d09b21faa0b2..97a93ee756a2 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -302,7 +302,7 @@ static void die_kernel_fault(const char *msg, unsigned long addr,
 	show_pte(addr);
 	die("Oops", regs, esr);
 	bust_spinlocks(0);
-	do_exit(SIGKILL);
+	make_task_dead(SIGKILL);
 }
 
 #ifdef CONFIG_KASAN_HW_TAGS
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
index 2020af88b636..6e426fba0119 100644
--- a/arch/csky/kernel/traps.c
+++ b/arch/csky/kernel/traps.c
@@ -109,7 +109,7 @@ void die(struct pt_regs *regs, const char *str)
 	if (panic_on_oops)
 		panic("Fatal exception");
 	if (ret != NOTIFY_STOP)
-		do_exit(SIGSEGV);
+		make_task_dead(SIGSEGV);
 }
 
 void do_trap(struct pt_regs *regs, int signo, int code, unsigned long addr)
diff --git a/arch/csky/mm/fault.c b/arch/csky/mm/fault.c
index 466ad949818a..7215a46b6b8e 100644
--- a/arch/csky/mm/fault.c
+++ b/arch/csky/mm/fault.c
@@ -67,7 +67,7 @@ static inline void no_context(struct pt_regs *regs, unsigned long addr)
 	pr_alert("Unable to handle kernel paging request at virtual "
 		 "addr 0x%08lx, pc: 0x%08lx\n", addr, regs->pc);
 	die(regs, "Oops");
-	do_exit(SIGKILL);
+	make_task_dead(SIGKILL);
 }
 
 static inline void mm_fault_error(struct pt_regs *regs, unsigned long addr, vm_fault_t fault)
diff --git a/arch/h8300/kernel/traps.c b/arch/h8300/kernel/traps.c
index bdbe988d8dbc..a92c39e03802 100644
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
@@ -106,7 +107,7 @@ void die(const char *str, struct pt_regs *fp, unsigned long err)
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
index edfc35dafeb1..1240f038cce0 100644
--- a/arch/hexagon/kernel/traps.c
+++ b/arch/hexagon/kernel/traps.c
@@ -214,7 +214,7 @@ int die(const char *str, struct pt_regs *regs, long err)
 		panic("Fatal exception");
 
 	oops_exit();
-	do_exit(err);
+	make_task_dead(err);
 	return 0;
 }
 
diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 1e33666fa679..b1f2b6ac9b1d 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -323,7 +323,7 @@ config ARCH_PROC_KCORE_TEXT
 	depends on PROC_KCORE
 
 config IA64_MCA_RECOVERY
-	tristate "MCA recovery from errors other than TLB."
+	bool "MCA recovery from errors other than TLB."
 
 config IA64_PALINFO
 	tristate "/proc/pal support"
diff --git a/arch/ia64/kernel/mca_drv.c b/arch/ia64/kernel/mca_drv.c
index 5bfc79be4cef..23c203639a96 100644
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
index 02de2e70c587..4796cccbf74f 100644
--- a/arch/ia64/mm/fault.c
+++ b/arch/ia64/mm/fault.c
@@ -259,7 +259,7 @@ ia64_do_page_fault (unsigned long address, unsigned long isr, struct pt_regs *re
 		regs = NULL;
 	bust_spinlocks(0);
 	if (regs)
-		do_exit(SIGKILL);
+		make_task_dead(SIGKILL);
 	return;
 
   out_of_memory:
diff --git a/arch/m68k/kernel/traps.c b/arch/m68k/kernel/traps.c
index 34d6458340b0..59fc63feb0dc 100644
--- a/arch/m68k/kernel/traps.c
+++ b/arch/m68k/kernel/traps.c
@@ -1131,7 +1131,7 @@ void die_if_kernel (char *str, struct pt_regs *fp, int nr)
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
index 908788497b28..fd153d5fab98 100644
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
index edd93430b954..afb2c955d99e 100644
--- a/arch/mips/kernel/traps.c
+++ b/arch/mips/kernel/traps.c
@@ -416,7 +416,7 @@ void __noreturn die(const char *str, struct pt_regs *regs)
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
index f06421c645af..b90030e8e546 100644
--- a/arch/nds32/kernel/traps.c
+++ b/arch/nds32/kernel/traps.c
@@ -141,7 +141,7 @@ void die(const char *str, struct pt_regs *regs, int err)
 
 	bust_spinlocks(0);
 	spin_unlock_irq(&die_lock);
-	do_exit(SIGSEGV);
+	make_task_dead(SIGSEGV);
 }
 
 EXPORT_SYMBOL(die);
@@ -240,7 +240,7 @@ void unhandled_interruption(struct pt_regs *regs)
 	pr_emerg("unhandled_interruption\n");
 	show_regs(regs);
 	if (!user_mode(regs))
-		do_exit(SIGKILL);
+		make_task_dead(SIGKILL);
 	force_sig(SIGKILL);
 }
 
@@ -251,7 +251,7 @@ void unhandled_exceptions(unsigned long entry, unsigned long addr,
 		 addr, type);
 	show_regs(regs);
 	if (!user_mode(regs))
-		do_exit(SIGKILL);
+		make_task_dead(SIGKILL);
 	force_sig(SIGKILL);
 }
 
@@ -278,7 +278,7 @@ void do_revinsn(struct pt_regs *regs)
 	pr_emerg("Reserved Instruction\n");
 	show_regs(regs);
 	if (!user_mode(regs))
-		do_exit(SIGILL);
+		make_task_dead(SIGILL);
 	force_sig(SIGILL);
 }
 
diff --git a/arch/nios2/kernel/traps.c b/arch/nios2/kernel/traps.c
index 596986a74a26..85ac49d64cf7 100644
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
index aa1e709405ac..9df1d85bfe1d 100644
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
index 6fe5a3e98edc..70ace3687950 100644
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
index 11741703d26e..a08bb7cefdc5 100644
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -245,7 +245,7 @@ static void oops_end(unsigned long flags, struct pt_regs *regs,
 
 	if (panic_on_oops)
 		panic("Fatal exception");
-	do_exit(signr);
+	make_task_dead(signr);
 }
 NOKPROBE_SYMBOL(oops_end);
 
@@ -792,9 +792,9 @@ int machine_check_generic(struct pt_regs *regs)
 void die_mce(const char *str, struct pt_regs *regs, long err)
 {
 	/*
-	 * The machine check wants to kill the interrupted context, but
-	 * do_exit() checks for in_interrupt() and panics in that case, so
-	 * exit the irq/nmi before calling die.
+	 * The machine check wants to kill the interrupted context,
+	 * but make_task_dead() checks for in_interrupt() and panics
+	 * in that case, so exit the irq/nmi before calling die.
 	 */
 	if (in_nmi())
 		nmi_exit();
diff --git a/arch/riscv/kernel/probes/simulate-insn.c b/arch/riscv/kernel/probes/simulate-insn.c
index d73e96f6ed7c..a20568bd1f1a 100644
--- a/arch/riscv/kernel/probes/simulate-insn.c
+++ b/arch/riscv/kernel/probes/simulate-insn.c
@@ -71,11 +71,11 @@ bool __kprobes simulate_jalr(u32 opcode, unsigned long addr, struct pt_regs *reg
 	u32 rd_index = (opcode >> 7) & 0x1f;
 	u32 rs1_index = (opcode >> 15) & 0x1f;
 
-	ret = rv_insn_reg_set_val(regs, rd_index, addr + 4);
+	ret = rv_insn_reg_get_val(regs, rs1_index, &base_addr);
 	if (!ret)
 		return ret;
 
-	ret = rv_insn_reg_get_val(regs, rs1_index, &base_addr);
+	ret = rv_insn_reg_set_val(regs, rd_index, addr + 4);
 	if (!ret)
 		return ret;
 
diff --git a/arch/riscv/kernel/traps.c b/arch/riscv/kernel/traps.c
index 4102c97309cc..6084bd93d2f5 100644
--- a/arch/riscv/kernel/traps.c
+++ b/arch/riscv/kernel/traps.c
@@ -59,7 +59,7 @@ void die(struct pt_regs *regs, const char *str)
 	if (panic_on_oops)
 		panic("Fatal exception");
 	if (ret != NOTIFY_STOP)
-		do_exit(SIGSEGV);
+		make_task_dead(SIGSEGV);
 }
 
 void do_trap(struct pt_regs *regs, int signo, int code, unsigned long addr)
diff --git a/arch/riscv/mm/fault.c b/arch/riscv/mm/fault.c
index 7cfaf366463f..676a3f28811f 100644
--- a/arch/riscv/mm/fault.c
+++ b/arch/riscv/mm/fault.c
@@ -31,7 +31,7 @@ static void die_kernel_fault(const char *msg, unsigned long addr,
 
 	bust_spinlocks(0);
 	die(regs, "Oops");
-	do_exit(SIGKILL);
+	make_task_dead(SIGKILL);
 }
 
 static inline void no_context(struct pt_regs *regs, unsigned long addr)
diff --git a/arch/s390/include/asm/debug.h b/arch/s390/include/asm/debug.h
index 19a55e1e3a0c..5fc91a90657e 100644
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
@@ -487,4 +487,4 @@ void debug_register_static(debug_info_t *id, int pages_per_area, int nr_areas);
 
 #endif /* MODULE */
 
-#endif /* DEBUG_H */
+#endif /* _ASM_S390_DEBUG_H */
diff --git a/arch/s390/kernel/dumpstack.c b/arch/s390/kernel/dumpstack.c
index db1bc00229ca..272ef8597e20 100644
--- a/arch/s390/kernel/dumpstack.c
+++ b/arch/s390/kernel/dumpstack.c
@@ -224,5 +224,5 @@ void die(struct pt_regs *regs, const char *str)
 	if (panic_on_oops)
 		panic("Fatal exception: panic_on_oops");
 	oops_exit();
-	do_exit(SIGSEGV);
+	make_task_dead(SIGSEGV);
 }
diff --git a/arch/s390/kernel/nmi.c b/arch/s390/kernel/nmi.c
index 383b4799b6dd..d4f071e73a0a 100644
--- a/arch/s390/kernel/nmi.c
+++ b/arch/s390/kernel/nmi.c
@@ -175,7 +175,7 @@ void __s390_handle_mcck(void)
 		       "malfunction (code 0x%016lx).\n", mcck.mcck_code);
 		printk(KERN_EMERG "mcck: task: %s, pid: %d.\n",
 		       current->comm, current->pid);
-		do_exit(SIGSEGV);
+		make_task_dead(SIGSEGV);
 	}
 }
 
diff --git a/arch/s390/kernel/vmlinux.lds.S b/arch/s390/kernel/vmlinux.lds.S
index b508ccad4856..8ce1615c1046 100644
--- a/arch/s390/kernel/vmlinux.lds.S
+++ b/arch/s390/kernel/vmlinux.lds.S
@@ -80,6 +80,7 @@ SECTIONS
 		_end_amode31_refs = .;
 	}
 
+	. = ALIGN(PAGE_SIZE);
 	_edata = .;		/* End of data section */
 
 	/* will be freed after init */
@@ -194,6 +195,7 @@ SECTIONS
 
 	BSS_SECTION(PAGE_SIZE, 4 * PAGE_SIZE, PAGE_SIZE)
 
+	. = ALIGN(PAGE_SIZE);
 	_end = . ;
 
 	/*
diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 8ce03a5ca863..ca7d09f09809 100644
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
index e76b22157099..361b764700b7 100644
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
index 5630e5a395e0..179aabfa712e 100644
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
index 6863025ed56d..21077821f427 100644
--- a/arch/sparc/kernel/traps_64.c
+++ b/arch/sparc/kernel/traps_64.c
@@ -2559,9 +2559,7 @@ void __noreturn die_if_kernel(char *str, struct pt_regs *regs)
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
index 6b44263d7efb..e309e7156038 100644
--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -1239,14 +1239,14 @@ SYM_CODE_START(asm_exc_nmi)
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
index a3af2a9159b1..9f1333a9ee41 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -1487,7 +1487,7 @@ SYM_CODE_END(ignore_sysret)
 #endif
 
 .pushsection .text, "ax"
-SYM_CODE_START(rewind_stack_do_exit)
+SYM_CODE_START(rewind_stack_and_make_dead)
 	UNWIND_HINT_FUNC
 	/* Prevent any naive code from trying to unwind to our caller. */
 	xorl	%ebp, %ebp
@@ -1496,6 +1496,6 @@ SYM_CODE_START(rewind_stack_do_exit)
 	leaq	-PTREGS_SIZE(%rax), %rsp
 	UNWIND_HINT_REGS
 
-	call	do_exit
-SYM_CODE_END(rewind_stack_do_exit)
+	call	make_task_dead
+SYM_CODE_END(rewind_stack_and_make_dead)
 .popsection
diff --git a/arch/x86/events/amd/core.c b/arch/x86/events/amd/core.c
index 9687a8aef01c..d93d098dea99 100644
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
diff --git a/arch/x86/events/intel/uncore.c b/arch/x86/events/intel/uncore.c
index c72e368dd164..7e16c590f259 100644
--- a/arch/x86/events/intel/uncore.c
+++ b/arch/x86/events/intel/uncore.c
@@ -1829,6 +1829,7 @@ static const struct x86_cpu_id intel_uncore_match[] __initconst = {
 	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE,		&adl_uncore_init),
 	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE_L,		&adl_uncore_init),
 	X86_MATCH_INTEL_FAM6_MODEL(SAPPHIRERAPIDS_X,	&spr_uncore_init),
+	X86_MATCH_INTEL_FAM6_MODEL(EMERALDRAPIDS_X,	&spr_uncore_init),
 	X86_MATCH_INTEL_FAM6_MODEL(ATOM_TREMONT_D,	&snr_uncore_init),
 	{},
 };
diff --git a/arch/x86/events/msr.c b/arch/x86/events/msr.c
index 96c775abe31f..d23b5523cdd3 100644
--- a/arch/x86/events/msr.c
+++ b/arch/x86/events/msr.c
@@ -69,6 +69,7 @@ static bool test_intel(int idx, void *data)
 	case INTEL_FAM6_BROADWELL_G:
 	case INTEL_FAM6_BROADWELL_X:
 	case INTEL_FAM6_SAPPHIRERAPIDS_X:
+	case INTEL_FAM6_EMERALDRAPIDS_X:
 
 	case INTEL_FAM6_ATOM_SILVERMONT:
 	case INTEL_FAM6_ATOM_SILVERMONT_D:
diff --git a/arch/x86/kernel/acpi/cstate.c b/arch/x86/kernel/acpi/cstate.c
index 7de599eba7f0..7945eae5b315 100644
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
index ea4fe192189d..53de044e5654 100644
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
index 15aefa3f3e18..f91e5e31aa4f 100644
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
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 773420203305..c1a758038892 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -465,11 +465,24 @@ static int has_svm(void)
 	return 1;
 }
 
+void __svm_write_tsc_multiplier(u64 multiplier)
+{
+	preempt_disable();
+
+	if (multiplier == __this_cpu_read(current_tsc_ratio))
+		goto out;
+
+	wrmsrl(MSR_AMD64_TSC_RATIO, multiplier);
+	__this_cpu_write(current_tsc_ratio, multiplier);
+out:
+	preempt_enable();
+}
+
 static void svm_hardware_disable(void)
 {
 	/* Make sure we clean up behind us */
 	if (static_cpu_has(X86_FEATURE_TSCRATEMSR))
-		wrmsrl(MSR_AMD64_TSC_RATIO, TSC_RATIO_DEFAULT);
+		__svm_write_tsc_multiplier(TSC_RATIO_DEFAULT);
 
 	cpu_svm_disable();
 
@@ -511,8 +524,11 @@ static int svm_hardware_enable(void)
 	wrmsrl(MSR_VM_HSAVE_PA, __sme_page_pa(sd->save_area));
 
 	if (static_cpu_has(X86_FEATURE_TSCRATEMSR)) {
-		wrmsrl(MSR_AMD64_TSC_RATIO, TSC_RATIO_DEFAULT);
-		__this_cpu_write(current_tsc_ratio, TSC_RATIO_DEFAULT);
+		/*
+		 * Set the default value, even if we don't use TSC scaling
+		 * to avoid having stale value in the msr
+		 */
+		__svm_write_tsc_multiplier(TSC_RATIO_DEFAULT);
 	}
 
 
@@ -1125,9 +1141,10 @@ static void svm_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
 
 static void svm_write_tsc_multiplier(struct kvm_vcpu *vcpu, u64 multiplier)
 {
-	wrmsrl(MSR_AMD64_TSC_RATIO, multiplier);
+	__svm_write_tsc_multiplier(multiplier);
 }
 
+
 /* Evaluate instruction intercepts that depend on guest CPUID features. */
 static void svm_recalc_instruction_intercepts(struct kvm_vcpu *vcpu,
 					      struct vcpu_svm *svm)
@@ -1451,13 +1468,8 @@ static void svm_prepare_guest_switch(struct kvm_vcpu *vcpu)
 		vmsave(__sme_page_pa(sd->save_area));
 	}
 
-	if (static_cpu_has(X86_FEATURE_TSCRATEMSR)) {
-		u64 tsc_ratio = vcpu->arch.tsc_scaling_ratio;
-		if (tsc_ratio != __this_cpu_read(current_tsc_ratio)) {
-			__this_cpu_write(current_tsc_ratio, tsc_ratio);
-			wrmsrl(MSR_AMD64_TSC_RATIO, tsc_ratio);
-		}
-	}
+	if (static_cpu_has(X86_FEATURE_TSCRATEMSR))
+		__svm_write_tsc_multiplier(vcpu->arch.tsc_scaling_ratio);
 
 	if (likely(tsc_aux_uret_slot >= 0))
 		kvm_set_user_return_msr(tsc_aux_uret_slot, svm->tsc_aux, -1ull);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 7004f356edf9..1d9b1a9e4398 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -487,6 +487,7 @@ int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
 int nested_svm_exit_special(struct vcpu_svm *svm);
 void nested_load_control_from_vmcb12(struct vcpu_svm *svm,
 				     struct vmcb_control_area *control);
+void __svm_write_tsc_multiplier(u64 multiplier);
 void nested_sync_control_from_vmcb02(struct vcpu_svm *svm);
 void nested_vmcb02_compute_g_pat(struct vcpu_svm *svm);
 void svm_switch_vmcb(struct vcpu_svm *svm, struct kvm_vmcb_info *target_vmcb);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6918f597b8ab..0718658268fe 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3361,18 +3361,15 @@ static u32 vmx_segment_access_rights(struct kvm_segment *var)
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
index 874b6efc6fb3..904086ad5682 100644
--- a/arch/xtensa/kernel/traps.c
+++ b/arch/xtensa/kernel/traps.c
@@ -552,5 +552,5 @@ void die(const char * str, struct pt_regs * regs, long err)
 	if (panic_on_oops)
 		panic("Fatal exception");
 
-	do_exit(err);
+	make_task_dead(err);
 }
diff --git a/block/blk-core.c b/block/blk-core.c
index 13e1fca1e923..ed6271dcc1b1 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -698,14 +698,10 @@ static inline bool should_fail_request(struct block_device *part,
 static inline bool bio_check_ro(struct bio *bio)
 {
 	if (op_is_write(bio_op(bio)) && bdev_read_only(bio->bi_bdev)) {
-		char b[BDEVNAME_SIZE];
-
 		if (op_is_flush(bio->bi_opf) && !bio_sectors(bio))
 			return false;
-
-		WARN_ONCE(1,
-		       "Trying to write to read-only block-device %s (partno %d)\n",
-			bio_devname(bio, b), bio->bi_bdev->bd_partno);
+		pr_warn("Trying to write to read-only block-device %pg\n",
+			bio->bi_bdev);
 		/* Older lvm-tools actually trigger this */
 		return false;
 	}
diff --git a/drivers/base/property.c b/drivers/base/property.c
index 735a23db1b5e..17a648d64356 100644
--- a/drivers/base/property.c
+++ b/drivers/base/property.c
@@ -1055,26 +1055,32 @@ struct fwnode_handle *
 fwnode_graph_get_next_endpoint(const struct fwnode_handle *fwnode,
 			       struct fwnode_handle *prev)
 {
+	struct fwnode_handle *ep, *port_parent = NULL;
 	const struct fwnode_handle *parent;
-	struct fwnode_handle *ep;
 
 	/*
 	 * If this function is in a loop and the previous iteration returned
 	 * an endpoint from fwnode->secondary, then we need to use the secondary
 	 * as parent rather than @fwnode.
 	 */
-	if (prev)
-		parent = fwnode_graph_get_port_parent(prev);
-	else
+	if (prev) {
+		port_parent = fwnode_graph_get_port_parent(prev);
+		parent = port_parent;
+	} else {
 		parent = fwnode;
+	}
 	if (IS_ERR_OR_NULL(parent))
 		return NULL;
 
 	ep = fwnode_call_ptr_op(parent, graph_get_next_endpoint, prev);
 	if (ep)
-		return ep;
+		goto out_put_port_parent;
+
+	ep = fwnode_graph_get_next_endpoint(parent->secondary, NULL);
 
-	return fwnode_graph_get_next_endpoint(parent->secondary, NULL);
+out_put_port_parent:
+	fwnode_handle_put(port_parent);
+	return ep;
 }
 EXPORT_SYMBOL_GPL(fwnode_graph_get_next_endpoint);
 
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
diff --git a/drivers/cpufreq/armada-37xx-cpufreq.c b/drivers/cpufreq/armada-37xx-cpufreq.c
index c10fc33b29b1..b74289a95a17 100644
--- a/drivers/cpufreq/armada-37xx-cpufreq.c
+++ b/drivers/cpufreq/armada-37xx-cpufreq.c
@@ -445,7 +445,7 @@ static int __init armada37xx_cpufreq_driver_init(void)
 		return -ENODEV;
 	}
 
-	clk = clk_get(cpu_dev, 0);
+	clk = clk_get(cpu_dev, NULL);
 	if (IS_ERR(clk)) {
 		dev_err(cpu_dev, "Cannot get clock for CPU0\n");
 		return PTR_ERR(clk);
diff --git a/drivers/cpufreq/cpufreq-dt-platdev.c b/drivers/cpufreq/cpufreq-dt-platdev.c
index ca1d103ec449..e1b5975c7daa 100644
--- a/drivers/cpufreq/cpufreq-dt-platdev.c
+++ b/drivers/cpufreq/cpufreq-dt-platdev.c
@@ -133,6 +133,7 @@ static const struct of_device_id blocklist[] __initconst = {
 	{ .compatible = "nvidia,tegra30", },
 	{ .compatible = "nvidia,tegra124", },
 	{ .compatible = "nvidia,tegra210", },
+	{ .compatible = "nvidia,tegra234", },
 
 	{ .compatible = "qcom,apq8096", },
 	{ .compatible = "qcom,msm8996", },
@@ -143,6 +144,7 @@ static const struct of_device_id blocklist[] __initconst = {
 	{ .compatible = "qcom,sc8180x", },
 	{ .compatible = "qcom,sdm845", },
 	{ .compatible = "qcom,sm6350", },
+	{ .compatible = "qcom,sm6375", },
 	{ .compatible = "qcom,sm8150", },
 	{ .compatible = "qcom,sm8250", },
 	{ .compatible = "qcom,sm8350", },
diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
index 63f7c219062b..55c80319d268 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -388,6 +388,15 @@ static void free_policy_dbs_info(struct policy_dbs_info *policy_dbs,
 	gov->free(policy_dbs);
 }
 
+static void cpufreq_dbs_data_release(struct kobject *kobj)
+{
+	struct dbs_data *dbs_data = to_dbs_data(to_gov_attr_set(kobj));
+	struct dbs_governor *gov = dbs_data->gov;
+
+	gov->exit(dbs_data);
+	kfree(dbs_data);
+}
+
 int cpufreq_dbs_governor_init(struct cpufreq_policy *policy)
 {
 	struct dbs_governor *gov = dbs_governor_of(policy);
@@ -425,6 +434,7 @@ int cpufreq_dbs_governor_init(struct cpufreq_policy *policy)
 		goto free_policy_dbs_info;
 	}
 
+	dbs_data->gov = gov;
 	gov_attr_set_init(&dbs_data->attr_set, &policy_dbs->list);
 
 	ret = gov->init(dbs_data);
@@ -447,6 +457,7 @@ int cpufreq_dbs_governor_init(struct cpufreq_policy *policy)
 	policy->governor_data = policy_dbs;
 
 	gov->kobj_type.sysfs_ops = &governor_sysfs_ops;
+	gov->kobj_type.release = cpufreq_dbs_data_release;
 	ret = kobject_init_and_add(&dbs_data->attr_set.kobj, &gov->kobj_type,
 				   get_governor_parent_kobj(policy),
 				   "%s", gov->gov.name);
@@ -488,13 +499,8 @@ void cpufreq_dbs_governor_exit(struct cpufreq_policy *policy)
 
 	policy->governor_data = NULL;
 
-	if (!count) {
-		if (!have_governor_per_policy())
-			gov->gdbs_data = NULL;
-
-		gov->exit(dbs_data);
-		kfree(dbs_data);
-	}
+	if (!count && !have_governor_per_policy())
+		gov->gdbs_data = NULL;
 
 	free_policy_dbs_info(policy_dbs, gov);
 
diff --git a/drivers/cpufreq/cpufreq_governor.h b/drivers/cpufreq/cpufreq_governor.h
index bab8e6140377..a6de26318abb 100644
--- a/drivers/cpufreq/cpufreq_governor.h
+++ b/drivers/cpufreq/cpufreq_governor.h
@@ -37,6 +37,7 @@ enum {OD_NORMAL_SAMPLE, OD_SUB_SAMPLE};
 /* Governor demand based switching data (per-policy or global). */
 struct dbs_data {
 	struct gov_attr_set attr_set;
+	struct dbs_governor *gov;
 	void *tuners;
 	unsigned int ignore_nice_load;
 	unsigned int sampling_rate;
diff --git a/drivers/cpufreq/cpufreq_governor_attr_set.c b/drivers/cpufreq/cpufreq_governor_attr_set.c
index a6f365b9cc1a..771770ea0ed0 100644
--- a/drivers/cpufreq/cpufreq_governor_attr_set.c
+++ b/drivers/cpufreq/cpufreq_governor_attr_set.c
@@ -8,11 +8,6 @@
 
 #include "cpufreq_governor.h"
 
-static inline struct gov_attr_set *to_gov_attr_set(struct kobject *kobj)
-{
-	return container_of(kobj, struct gov_attr_set, kobj);
-}
-
 static inline struct governor_attr *to_gov_attr(struct attribute *attr)
 {
 	return container_of(attr, struct governor_attr, attr);
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
diff --git a/drivers/dma/ptdma/ptdma-dev.c b/drivers/dma/ptdma/ptdma-dev.c
index daafea5bc35d..bca4063b0dce 100644
--- a/drivers/dma/ptdma/ptdma-dev.c
+++ b/drivers/dma/ptdma/ptdma-dev.c
@@ -71,12 +71,13 @@ static int pt_core_execute_cmd(struct ptdma_desc *desc, struct pt_cmd_queue *cmd
 	bool soc = FIELD_GET(DWORD0_SOC, desc->dw0);
 	u8 *q_desc = (u8 *)&cmd_q->qbase[cmd_q->qidx];
 	u32 tail;
+	unsigned long flags;
 
 	if (soc) {
 		desc->dw0 |= FIELD_PREP(DWORD0_IOC, desc->dw0);
 		desc->dw0 &= ~DWORD0_SOC;
 	}
-	mutex_lock(&cmd_q->q_mutex);
+	spin_lock_irqsave(&cmd_q->q_lock, flags);
 
 	/* Copy 32-byte command descriptor to hw queue. */
 	memcpy(q_desc, desc, 32);
@@ -91,7 +92,7 @@ static int pt_core_execute_cmd(struct ptdma_desc *desc, struct pt_cmd_queue *cmd
 
 	/* Turn the queue back on using our cached control register */
 	pt_start_queue(cmd_q);
-	mutex_unlock(&cmd_q->q_mutex);
+	spin_unlock_irqrestore(&cmd_q->q_lock, flags);
 
 	return 0;
 }
@@ -197,7 +198,7 @@ int pt_core_init(struct pt_device *pt)
 
 	cmd_q->pt = pt;
 	cmd_q->dma_pool = dma_pool;
-	mutex_init(&cmd_q->q_mutex);
+	spin_lock_init(&cmd_q->q_lock);
 
 	/* Page alignment satisfies our needs for N <= 128 */
 	cmd_q->qsize = Q_SIZE(Q_DESC_SIZE);
diff --git a/drivers/dma/ptdma/ptdma.h b/drivers/dma/ptdma/ptdma.h
index afbf192c9230..0f0b400a864e 100644
--- a/drivers/dma/ptdma/ptdma.h
+++ b/drivers/dma/ptdma/ptdma.h
@@ -196,7 +196,7 @@ struct pt_cmd_queue {
 	struct ptdma_desc *qbase;
 
 	/* Aligned queue start address (per requirement) */
-	struct mutex q_mutex ____cacheline_aligned;
+	spinlock_t q_lock ____cacheline_aligned;
 	unsigned int qidx;
 
 	unsigned int qsize;
diff --git a/drivers/dma/ti/k3-udma.c b/drivers/dma/ti/k3-udma.c
index 75f2a0006c73..d796e50dfe99 100644
--- a/drivers/dma/ti/k3-udma.c
+++ b/drivers/dma/ti/k3-udma.c
@@ -760,11 +760,12 @@ static void udma_decrement_byte_counters(struct udma_chan *uc, u32 val)
 	if (uc->desc->dir == DMA_DEV_TO_MEM) {
 		udma_rchanrt_write(uc, UDMA_CHAN_RT_BCNT_REG, val);
 		udma_rchanrt_write(uc, UDMA_CHAN_RT_SBCNT_REG, val);
-		udma_rchanrt_write(uc, UDMA_CHAN_RT_PEER_BCNT_REG, val);
+		if (uc->config.ep_type != PSIL_EP_NATIVE)
+			udma_rchanrt_write(uc, UDMA_CHAN_RT_PEER_BCNT_REG, val);
 	} else {
 		udma_tchanrt_write(uc, UDMA_CHAN_RT_BCNT_REG, val);
 		udma_tchanrt_write(uc, UDMA_CHAN_RT_SBCNT_REG, val);
-		if (!uc->bchan)
+		if (!uc->bchan && uc->config.ep_type != PSIL_EP_NATIVE)
 			udma_tchanrt_write(uc, UDMA_CHAN_RT_PEER_BCNT_REG, val);
 	}
 }
diff --git a/drivers/dma/xilinx/xilinx_dma.c b/drivers/dma/xilinx/xilinx_dma.c
index 4273150b68dc..edc2bb8f0523 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -3138,8 +3138,10 @@ static int xilinx_dma_probe(struct platform_device *pdev)
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
diff --git a/drivers/firmware/google/coreboot_table.c b/drivers/firmware/google/coreboot_table.c
index 9ca21feb9d45..f3694d347801 100644
--- a/drivers/firmware/google/coreboot_table.c
+++ b/drivers/firmware/google/coreboot_table.c
@@ -93,7 +93,12 @@ static int coreboot_table_populate(struct device *dev, void *ptr)
 	for (i = 0; i < header->table_entries; i++) {
 		entry = ptr_entry;
 
-		device = kzalloc(sizeof(struct device) + entry->size, GFP_KERNEL);
+		if (entry->size < sizeof(*entry)) {
+			dev_warn(dev, "coreboot table entry too small!\n");
+			return -EINVAL;
+		}
+
+		device = kzalloc(sizeof(device->dev) + entry->size, GFP_KERNEL);
 		if (!device)
 			return -ENOMEM;
 
@@ -101,7 +106,7 @@ static int coreboot_table_populate(struct device *dev, void *ptr)
 		device->dev.parent = dev;
 		device->dev.bus = &coreboot_bus_type;
 		device->dev.release = coreboot_device_release;
-		memcpy(&device->entry, ptr_entry, entry->size);
+		memcpy(device->raw, ptr_entry, entry->size);
 
 		ret = device_register(&device->dev);
 		if (ret) {
diff --git a/drivers/firmware/google/coreboot_table.h b/drivers/firmware/google/coreboot_table.h
index beb778674acd..4a89277b99a3 100644
--- a/drivers/firmware/google/coreboot_table.h
+++ b/drivers/firmware/google/coreboot_table.h
@@ -66,6 +66,7 @@ struct coreboot_device {
 		struct coreboot_table_entry entry;
 		struct lb_cbmem_ref cbmem_ref;
 		struct lb_framebuffer framebuffer;
+		DECLARE_FLEX_ARRAY(u8, raw);
 	};
 };
 
diff --git a/drivers/gpio/gpio-amdpt.c b/drivers/gpio/gpio-amdpt.c
index 44398992ae15..dba4836a18f8 100644
--- a/drivers/gpio/gpio-amdpt.c
+++ b/drivers/gpio/gpio-amdpt.c
@@ -35,19 +35,19 @@ static int pt_gpio_request(struct gpio_chip *gc, unsigned offset)
 
 	dev_dbg(gc->parent, "pt_gpio_request offset=%x\n", offset);
 
-	spin_lock_irqsave(&gc->bgpio_lock, flags);
+	raw_spin_lock_irqsave(&gc->bgpio_lock, flags);
 
 	using_pins = readl(pt_gpio->reg_base + PT_SYNC_REG);
 	if (using_pins & BIT(offset)) {
 		dev_warn(gc->parent, "PT GPIO pin %x reconfigured\n",
 			 offset);
-		spin_unlock_irqrestore(&gc->bgpio_lock, flags);
+		raw_spin_unlock_irqrestore(&gc->bgpio_lock, flags);
 		return -EINVAL;
 	}
 
 	writel(using_pins | BIT(offset), pt_gpio->reg_base + PT_SYNC_REG);
 
-	spin_unlock_irqrestore(&gc->bgpio_lock, flags);
+	raw_spin_unlock_irqrestore(&gc->bgpio_lock, flags);
 
 	return 0;
 }
@@ -58,13 +58,13 @@ static void pt_gpio_free(struct gpio_chip *gc, unsigned offset)
 	unsigned long flags;
 	u32 using_pins;
 
-	spin_lock_irqsave(&gc->bgpio_lock, flags);
+	raw_spin_lock_irqsave(&gc->bgpio_lock, flags);
 
 	using_pins = readl(pt_gpio->reg_base + PT_SYNC_REG);
 	using_pins &= ~BIT(offset);
 	writel(using_pins, pt_gpio->reg_base + PT_SYNC_REG);
 
-	spin_unlock_irqrestore(&gc->bgpio_lock, flags);
+	raw_spin_unlock_irqrestore(&gc->bgpio_lock, flags);
 
 	dev_dbg(gc->parent, "pt_gpio_free offset=%x\n", offset);
 }
diff --git a/drivers/gpio/gpio-brcmstb.c b/drivers/gpio/gpio-brcmstb.c
index 895a79936248..c5d85e931f2a 100644
--- a/drivers/gpio/gpio-brcmstb.c
+++ b/drivers/gpio/gpio-brcmstb.c
@@ -92,9 +92,9 @@ brcmstb_gpio_get_active_irqs(struct brcmstb_gpio_bank *bank)
 	unsigned long status;
 	unsigned long flags;
 
-	spin_lock_irqsave(&bank->gc.bgpio_lock, flags);
+	raw_spin_lock_irqsave(&bank->gc.bgpio_lock, flags);
 	status = __brcmstb_gpio_get_active_irqs(bank);
-	spin_unlock_irqrestore(&bank->gc.bgpio_lock, flags);
+	raw_spin_unlock_irqrestore(&bank->gc.bgpio_lock, flags);
 
 	return status;
 }
@@ -114,14 +114,14 @@ static void brcmstb_gpio_set_imask(struct brcmstb_gpio_bank *bank,
 	u32 imask;
 	unsigned long flags;
 
-	spin_lock_irqsave(&gc->bgpio_lock, flags);
+	raw_spin_lock_irqsave(&gc->bgpio_lock, flags);
 	imask = gc->read_reg(priv->reg_base + GIO_MASK(bank->id));
 	if (enable)
 		imask |= mask;
 	else
 		imask &= ~mask;
 	gc->write_reg(priv->reg_base + GIO_MASK(bank->id), imask);
-	spin_unlock_irqrestore(&gc->bgpio_lock, flags);
+	raw_spin_unlock_irqrestore(&gc->bgpio_lock, flags);
 }
 
 static int brcmstb_gpio_to_irq(struct gpio_chip *gc, unsigned offset)
@@ -204,7 +204,7 @@ static int brcmstb_gpio_irq_set_type(struct irq_data *d, unsigned int type)
 		return -EINVAL;
 	}
 
-	spin_lock_irqsave(&bank->gc.bgpio_lock, flags);
+	raw_spin_lock_irqsave(&bank->gc.bgpio_lock, flags);
 
 	iedge_config = bank->gc.read_reg(priv->reg_base +
 			GIO_EC(bank->id)) & ~mask;
@@ -220,7 +220,7 @@ static int brcmstb_gpio_irq_set_type(struct irq_data *d, unsigned int type)
 	bank->gc.write_reg(priv->reg_base + GIO_LEVEL(bank->id),
 			ilevel | level);
 
-	spin_unlock_irqrestore(&bank->gc.bgpio_lock, flags);
+	raw_spin_unlock_irqrestore(&bank->gc.bgpio_lock, flags);
 	return 0;
 }
 
diff --git a/drivers/gpio/gpio-cadence.c b/drivers/gpio/gpio-cadence.c
index 562f8f7e7d1f..137aea49ba02 100644
--- a/drivers/gpio/gpio-cadence.c
+++ b/drivers/gpio/gpio-cadence.c
@@ -41,12 +41,12 @@ static int cdns_gpio_request(struct gpio_chip *chip, unsigned int offset)
 	struct cdns_gpio_chip *cgpio = gpiochip_get_data(chip);
 	unsigned long flags;
 
-	spin_lock_irqsave(&chip->bgpio_lock, flags);
+	raw_spin_lock_irqsave(&chip->bgpio_lock, flags);
 
 	iowrite32(ioread32(cgpio->regs + CDNS_GPIO_BYPASS_MODE) & ~BIT(offset),
 		  cgpio->regs + CDNS_GPIO_BYPASS_MODE);
 
-	spin_unlock_irqrestore(&chip->bgpio_lock, flags);
+	raw_spin_unlock_irqrestore(&chip->bgpio_lock, flags);
 	return 0;
 }
 
@@ -55,13 +55,13 @@ static void cdns_gpio_free(struct gpio_chip *chip, unsigned int offset)
 	struct cdns_gpio_chip *cgpio = gpiochip_get_data(chip);
 	unsigned long flags;
 
-	spin_lock_irqsave(&chip->bgpio_lock, flags);
+	raw_spin_lock_irqsave(&chip->bgpio_lock, flags);
 
 	iowrite32(ioread32(cgpio->regs + CDNS_GPIO_BYPASS_MODE) |
 		  (BIT(offset) & cgpio->bypass_orig),
 		  cgpio->regs + CDNS_GPIO_BYPASS_MODE);
 
-	spin_unlock_irqrestore(&chip->bgpio_lock, flags);
+	raw_spin_unlock_irqrestore(&chip->bgpio_lock, flags);
 }
 
 static void cdns_gpio_irq_mask(struct irq_data *d)
@@ -90,7 +90,7 @@ static int cdns_gpio_irq_set_type(struct irq_data *d, unsigned int type)
 	u32 mask = BIT(d->hwirq);
 	int ret = 0;
 
-	spin_lock_irqsave(&chip->bgpio_lock, flags);
+	raw_spin_lock_irqsave(&chip->bgpio_lock, flags);
 
 	int_value = ioread32(cgpio->regs + CDNS_GPIO_IRQ_VALUE) & ~mask;
 	int_type = ioread32(cgpio->regs + CDNS_GPIO_IRQ_TYPE) & ~mask;
@@ -115,7 +115,7 @@ static int cdns_gpio_irq_set_type(struct irq_data *d, unsigned int type)
 	iowrite32(int_type, cgpio->regs + CDNS_GPIO_IRQ_TYPE);
 
 err_irq_type:
-	spin_unlock_irqrestore(&chip->bgpio_lock, flags);
+	raw_spin_unlock_irqrestore(&chip->bgpio_lock, flags);
 	return ret;
 }
 
diff --git a/drivers/gpio/gpio-dwapb.c b/drivers/gpio/gpio-dwapb.c
index e981e7a46fc1..a503f37001eb 100644
--- a/drivers/gpio/gpio-dwapb.c
+++ b/drivers/gpio/gpio-dwapb.c
@@ -242,9 +242,9 @@ static void dwapb_irq_ack(struct irq_data *d)
 	u32 val = BIT(irqd_to_hwirq(d));
 	unsigned long flags;
 
-	spin_lock_irqsave(&gc->bgpio_lock, flags);
+	raw_spin_lock_irqsave(&gc->bgpio_lock, flags);
 	dwapb_write(gpio, GPIO_PORTA_EOI, val);
-	spin_unlock_irqrestore(&gc->bgpio_lock, flags);
+	raw_spin_unlock_irqrestore(&gc->bgpio_lock, flags);
 }
 
 static void dwapb_irq_mask(struct irq_data *d)
@@ -254,10 +254,10 @@ static void dwapb_irq_mask(struct irq_data *d)
 	unsigned long flags;
 	u32 val;
 
-	spin_lock_irqsave(&gc->bgpio_lock, flags);
+	raw_spin_lock_irqsave(&gc->bgpio_lock, flags);
 	val = dwapb_read(gpio, GPIO_INTMASK) | BIT(irqd_to_hwirq(d));
 	dwapb_write(gpio, GPIO_INTMASK, val);
-	spin_unlock_irqrestore(&gc->bgpio_lock, flags);
+	raw_spin_unlock_irqrestore(&gc->bgpio_lock, flags);
 }
 
 static void dwapb_irq_unmask(struct irq_data *d)
@@ -267,10 +267,10 @@ static void dwapb_irq_unmask(struct irq_data *d)
 	unsigned long flags;
 	u32 val;
 
-	spin_lock_irqsave(&gc->bgpio_lock, flags);
+	raw_spin_lock_irqsave(&gc->bgpio_lock, flags);
 	val = dwapb_read(gpio, GPIO_INTMASK) & ~BIT(irqd_to_hwirq(d));
 	dwapb_write(gpio, GPIO_INTMASK, val);
-	spin_unlock_irqrestore(&gc->bgpio_lock, flags);
+	raw_spin_unlock_irqrestore(&gc->bgpio_lock, flags);
 }
 
 static void dwapb_irq_enable(struct irq_data *d)
@@ -280,11 +280,11 @@ static void dwapb_irq_enable(struct irq_data *d)
 	unsigned long flags;
 	u32 val;
 
-	spin_lock_irqsave(&gc->bgpio_lock, flags);
+	raw_spin_lock_irqsave(&gc->bgpio_lock, flags);
 	val = dwapb_read(gpio, GPIO_INTEN);
 	val |= BIT(irqd_to_hwirq(d));
 	dwapb_write(gpio, GPIO_INTEN, val);
-	spin_unlock_irqrestore(&gc->bgpio_lock, flags);
+	raw_spin_unlock_irqrestore(&gc->bgpio_lock, flags);
 }
 
 static void dwapb_irq_disable(struct irq_data *d)
@@ -294,11 +294,11 @@ static void dwapb_irq_disable(struct irq_data *d)
 	unsigned long flags;
 	u32 val;
 
-	spin_lock_irqsave(&gc->bgpio_lock, flags);
+	raw_spin_lock_irqsave(&gc->bgpio_lock, flags);
 	val = dwapb_read(gpio, GPIO_INTEN);
 	val &= ~BIT(irqd_to_hwirq(d));
 	dwapb_write(gpio, GPIO_INTEN, val);
-	spin_unlock_irqrestore(&gc->bgpio_lock, flags);
+	raw_spin_unlock_irqrestore(&gc->bgpio_lock, flags);
 }
 
 static int dwapb_irq_set_type(struct irq_data *d, u32 type)
@@ -308,7 +308,7 @@ static int dwapb_irq_set_type(struct irq_data *d, u32 type)
 	irq_hw_number_t bit = irqd_to_hwirq(d);
 	unsigned long level, polarity, flags;
 
-	spin_lock_irqsave(&gc->bgpio_lock, flags);
+	raw_spin_lock_irqsave(&gc->bgpio_lock, flags);
 	level = dwapb_read(gpio, GPIO_INTTYPE_LEVEL);
 	polarity = dwapb_read(gpio, GPIO_INT_POLARITY);
 
@@ -343,7 +343,7 @@ static int dwapb_irq_set_type(struct irq_data *d, u32 type)
 	dwapb_write(gpio, GPIO_INTTYPE_LEVEL, level);
 	if (type != IRQ_TYPE_EDGE_BOTH)
 		dwapb_write(gpio, GPIO_INT_POLARITY, polarity);
-	spin_unlock_irqrestore(&gc->bgpio_lock, flags);
+	raw_spin_unlock_irqrestore(&gc->bgpio_lock, flags);
 
 	return 0;
 }
@@ -373,7 +373,7 @@ static int dwapb_gpio_set_debounce(struct gpio_chip *gc,
 	unsigned long flags, val_deb;
 	unsigned long mask = BIT(offset);
 
-	spin_lock_irqsave(&gc->bgpio_lock, flags);
+	raw_spin_lock_irqsave(&gc->bgpio_lock, flags);
 
 	val_deb = dwapb_read(gpio, GPIO_PORTA_DEBOUNCE);
 	if (debounce)
@@ -382,7 +382,7 @@ static int dwapb_gpio_set_debounce(struct gpio_chip *gc,
 		val_deb &= ~mask;
 	dwapb_write(gpio, GPIO_PORTA_DEBOUNCE, val_deb);
 
-	spin_unlock_irqrestore(&gc->bgpio_lock, flags);
+	raw_spin_unlock_irqrestore(&gc->bgpio_lock, flags);
 
 	return 0;
 }
@@ -738,7 +738,7 @@ static int dwapb_gpio_suspend(struct device *dev)
 	unsigned long flags;
 	int i;
 
-	spin_lock_irqsave(&gc->bgpio_lock, flags);
+	raw_spin_lock_irqsave(&gc->bgpio_lock, flags);
 	for (i = 0; i < gpio->nr_ports; i++) {
 		unsigned int offset;
 		unsigned int idx = gpio->ports[i].idx;
@@ -765,7 +765,7 @@ static int dwapb_gpio_suspend(struct device *dev)
 			dwapb_write(gpio, GPIO_INTMASK, ~ctx->wake_en);
 		}
 	}
-	spin_unlock_irqrestore(&gc->bgpio_lock, flags);
+	raw_spin_unlock_irqrestore(&gc->bgpio_lock, flags);
 
 	clk_bulk_disable_unprepare(DWAPB_NR_CLOCKS, gpio->clks);
 
@@ -785,7 +785,7 @@ static int dwapb_gpio_resume(struct device *dev)
 		return err;
 	}
 
-	spin_lock_irqsave(&gc->bgpio_lock, flags);
+	raw_spin_lock_irqsave(&gc->bgpio_lock, flags);
 	for (i = 0; i < gpio->nr_ports; i++) {
 		unsigned int offset;
 		unsigned int idx = gpio->ports[i].idx;
@@ -812,7 +812,7 @@ static int dwapb_gpio_resume(struct device *dev)
 			dwapb_write(gpio, GPIO_PORTA_EOI, 0xffffffff);
 		}
 	}
-	spin_unlock_irqrestore(&gc->bgpio_lock, flags);
+	raw_spin_unlock_irqrestore(&gc->bgpio_lock, flags);
 
 	return 0;
 }
diff --git a/drivers/gpio/gpio-grgpio.c b/drivers/gpio/gpio-grgpio.c
index f954359c9544..21204a5dca3d 100644
--- a/drivers/gpio/gpio-grgpio.c
+++ b/drivers/gpio/gpio-grgpio.c
@@ -145,7 +145,7 @@ static int grgpio_irq_set_type(struct irq_data *d, unsigned int type)
 		return -EINVAL;
 	}
 
-	spin_lock_irqsave(&priv->gc.bgpio_lock, flags);
+	raw_spin_lock_irqsave(&priv->gc.bgpio_lock, flags);
 
 	ipol = priv->gc.read_reg(priv->regs + GRGPIO_IPOL) & ~mask;
 	iedge = priv->gc.read_reg(priv->regs + GRGPIO_IEDGE) & ~mask;
@@ -153,7 +153,7 @@ static int grgpio_irq_set_type(struct irq_data *d, unsigned int type)
 	priv->gc.write_reg(priv->regs + GRGPIO_IPOL, ipol | pol);
 	priv->gc.write_reg(priv->regs + GRGPIO_IEDGE, iedge | edge);
 
-	spin_unlock_irqrestore(&priv->gc.bgpio_lock, flags);
+	raw_spin_unlock_irqrestore(&priv->gc.bgpio_lock, flags);
 
 	return 0;
 }
@@ -164,11 +164,11 @@ static void grgpio_irq_mask(struct irq_data *d)
 	int offset = d->hwirq;
 	unsigned long flags;
 
-	spin_lock_irqsave(&priv->gc.bgpio_lock, flags);
+	raw_spin_lock_irqsave(&priv->gc.bgpio_lock, flags);
 
 	grgpio_set_imask(priv, offset, 0);
 
-	spin_unlock_irqrestore(&priv->gc.bgpio_lock, flags);
+	raw_spin_unlock_irqrestore(&priv->gc.bgpio_lock, flags);
 }
 
 static void grgpio_irq_unmask(struct irq_data *d)
@@ -177,11 +177,11 @@ static void grgpio_irq_unmask(struct irq_data *d)
 	int offset = d->hwirq;
 	unsigned long flags;
 
-	spin_lock_irqsave(&priv->gc.bgpio_lock, flags);
+	raw_spin_lock_irqsave(&priv->gc.bgpio_lock, flags);
 
 	grgpio_set_imask(priv, offset, 1);
 
-	spin_unlock_irqrestore(&priv->gc.bgpio_lock, flags);
+	raw_spin_unlock_irqrestore(&priv->gc.bgpio_lock, flags);
 }
 
 static struct irq_chip grgpio_irq_chip = {
@@ -199,7 +199,7 @@ static irqreturn_t grgpio_irq_handler(int irq, void *dev)
 	int i;
 	int match = 0;
 
-	spin_lock_irqsave(&priv->gc.bgpio_lock, flags);
+	raw_spin_lock_irqsave(&priv->gc.bgpio_lock, flags);
 
 	/*
 	 * For each gpio line, call its interrupt handler if it its underlying
@@ -215,7 +215,7 @@ static irqreturn_t grgpio_irq_handler(int irq, void *dev)
 		}
 	}
 
-	spin_unlock_irqrestore(&priv->gc.bgpio_lock, flags);
+	raw_spin_unlock_irqrestore(&priv->gc.bgpio_lock, flags);
 
 	if (!match)
 		dev_warn(priv->dev, "No gpio line matched irq %d\n", irq);
@@ -247,13 +247,13 @@ static int grgpio_irq_map(struct irq_domain *d, unsigned int irq,
 	dev_dbg(priv->dev, "Mapping irq %d for gpio line %d\n",
 		irq, offset);
 
-	spin_lock_irqsave(&priv->gc.bgpio_lock, flags);
+	raw_spin_lock_irqsave(&priv->gc.bgpio_lock, flags);
 
 	/* Request underlying irq if not already requested */
 	lirq->irq = irq;
 	uirq = &priv->uirqs[lirq->index];
 	if (uirq->refcnt == 0) {
-		spin_unlock_irqrestore(&priv->gc.bgpio_lock, flags);
+		raw_spin_unlock_irqrestore(&priv->gc.bgpio_lock, flags);
 		ret = request_irq(uirq->uirq, grgpio_irq_handler, 0,
 				  dev_name(priv->dev), priv);
 		if (ret) {
@@ -262,11 +262,11 @@ static int grgpio_irq_map(struct irq_domain *d, unsigned int irq,
 				uirq->uirq);
 			return ret;
 		}
-		spin_lock_irqsave(&priv->gc.bgpio_lock, flags);
+		raw_spin_lock_irqsave(&priv->gc.bgpio_lock, flags);
 	}
 	uirq->refcnt++;
 
-	spin_unlock_irqrestore(&priv->gc.bgpio_lock, flags);
+	raw_spin_unlock_irqrestore(&priv->gc.bgpio_lock, flags);
 
 	/* Setup irq  */
 	irq_set_chip_data(irq, priv);
@@ -290,7 +290,7 @@ static void grgpio_irq_unmap(struct irq_domain *d, unsigned int irq)
 	irq_set_chip_and_handler(irq, NULL, NULL);
 	irq_set_chip_data(irq, NULL);
 
-	spin_lock_irqsave(&priv->gc.bgpio_lock, flags);
+	raw_spin_lock_irqsave(&priv->gc.bgpio_lock, flags);
 
 	/* Free underlying irq if last user unmapped */
 	index = -1;
@@ -309,13 +309,13 @@ static void grgpio_irq_unmap(struct irq_domain *d, unsigned int irq)
 		uirq = &priv->uirqs[lirq->index];
 		uirq->refcnt--;
 		if (uirq->refcnt == 0) {
-			spin_unlock_irqrestore(&priv->gc.bgpio_lock, flags);
+			raw_spin_unlock_irqrestore(&priv->gc.bgpio_lock, flags);
 			free_irq(uirq->uirq, priv);
 			return;
 		}
 	}
 
-	spin_unlock_irqrestore(&priv->gc.bgpio_lock, flags);
+	raw_spin_unlock_irqrestore(&priv->gc.bgpio_lock, flags);
 }
 
 static const struct irq_domain_ops grgpio_irq_domain_ops = {
diff --git a/drivers/gpio/gpio-hlwd.c b/drivers/gpio/gpio-hlwd.c
index 641719a96a1a..4e13e937f832 100644
--- a/drivers/gpio/gpio-hlwd.c
+++ b/drivers/gpio/gpio-hlwd.c
@@ -65,7 +65,7 @@ static void hlwd_gpio_irqhandler(struct irq_desc *desc)
 	int hwirq;
 	u32 emulated_pending;
 
-	spin_lock_irqsave(&hlwd->gpioc.bgpio_lock, flags);
+	raw_spin_lock_irqsave(&hlwd->gpioc.bgpio_lock, flags);
 	pending = ioread32be(hlwd->regs + HW_GPIOB_INTFLAG);
 	pending &= ioread32be(hlwd->regs + HW_GPIOB_INTMASK);
 
@@ -93,7 +93,7 @@ static void hlwd_gpio_irqhandler(struct irq_desc *desc)
 		/* Mark emulated interrupts as pending */
 		pending |= rising | falling;
 	}
-	spin_unlock_irqrestore(&hlwd->gpioc.bgpio_lock, flags);
+	raw_spin_unlock_irqrestore(&hlwd->gpioc.bgpio_lock, flags);
 
 	chained_irq_enter(chip, desc);
 
@@ -118,11 +118,11 @@ static void hlwd_gpio_irq_mask(struct irq_data *data)
 	unsigned long flags;
 	u32 mask;
 
-	spin_lock_irqsave(&hlwd->gpioc.bgpio_lock, flags);
+	raw_spin_lock_irqsave(&hlwd->gpioc.bgpio_lock, flags);
 	mask = ioread32be(hlwd->regs + HW_GPIOB_INTMASK);
 	mask &= ~BIT(data->hwirq);
 	iowrite32be(mask, hlwd->regs + HW_GPIOB_INTMASK);
-	spin_unlock_irqrestore(&hlwd->gpioc.bgpio_lock, flags);
+	raw_spin_unlock_irqrestore(&hlwd->gpioc.bgpio_lock, flags);
 }
 
 static void hlwd_gpio_irq_unmask(struct irq_data *data)
@@ -132,11 +132,11 @@ static void hlwd_gpio_irq_unmask(struct irq_data *data)
 	unsigned long flags;
 	u32 mask;
 
-	spin_lock_irqsave(&hlwd->gpioc.bgpio_lock, flags);
+	raw_spin_lock_irqsave(&hlwd->gpioc.bgpio_lock, flags);
 	mask = ioread32be(hlwd->regs + HW_GPIOB_INTMASK);
 	mask |= BIT(data->hwirq);
 	iowrite32be(mask, hlwd->regs + HW_GPIOB_INTMASK);
-	spin_unlock_irqrestore(&hlwd->gpioc.bgpio_lock, flags);
+	raw_spin_unlock_irqrestore(&hlwd->gpioc.bgpio_lock, flags);
 }
 
 static void hlwd_gpio_irq_enable(struct irq_data *data)
@@ -173,7 +173,7 @@ static int hlwd_gpio_irq_set_type(struct irq_data *data, unsigned int flow_type)
 	unsigned long flags;
 	u32 level;
 
-	spin_lock_irqsave(&hlwd->gpioc.bgpio_lock, flags);
+	raw_spin_lock_irqsave(&hlwd->gpioc.bgpio_lock, flags);
 
 	hlwd->edge_emulation &= ~BIT(data->hwirq);
 
@@ -194,11 +194,11 @@ static int hlwd_gpio_irq_set_type(struct irq_data *data, unsigned int flow_type)
 		hlwd_gpio_irq_setup_emulation(hlwd, data->hwirq, flow_type);
 		break;
 	default:
-		spin_unlock_irqrestore(&hlwd->gpioc.bgpio_lock, flags);
+		raw_spin_unlock_irqrestore(&hlwd->gpioc.bgpio_lock, flags);
 		return -EINVAL;
 	}
 
-	spin_unlock_irqrestore(&hlwd->gpioc.bgpio_lock, flags);
+	raw_spin_unlock_irqrestore(&hlwd->gpioc.bgpio_lock, flags);
 	return 0;
 }
 
diff --git a/drivers/gpio/gpio-idt3243x.c b/drivers/gpio/gpio-idt3243x.c
index 52b8b72ded77..1cafdf46f875 100644
--- a/drivers/gpio/gpio-idt3243x.c
+++ b/drivers/gpio/gpio-idt3243x.c
@@ -57,7 +57,7 @@ static int idt_gpio_irq_set_type(struct irq_data *d, unsigned int flow_type)
 	if (sense == IRQ_TYPE_NONE || (sense & IRQ_TYPE_EDGE_BOTH))
 		return -EINVAL;
 
-	spin_lock_irqsave(&gc->bgpio_lock, flags);
+	raw_spin_lock_irqsave(&gc->bgpio_lock, flags);
 
 	ilevel = readl(ctrl->gpio + IDT_GPIO_ILEVEL);
 	if (sense & IRQ_TYPE_LEVEL_HIGH)
@@ -68,7 +68,7 @@ static int idt_gpio_irq_set_type(struct irq_data *d, unsigned int flow_type)
 	writel(ilevel, ctrl->gpio + IDT_GPIO_ILEVEL);
 	irq_set_handler_locked(d, handle_level_irq);
 
-	spin_unlock_irqrestore(&gc->bgpio_lock, flags);
+	raw_spin_unlock_irqrestore(&gc->bgpio_lock, flags);
 	return 0;
 }
 
@@ -86,12 +86,12 @@ static void idt_gpio_mask(struct irq_data *d)
 	struct idt_gpio_ctrl *ctrl = gpiochip_get_data(gc);
 	unsigned long flags;
 
-	spin_lock_irqsave(&gc->bgpio_lock, flags);
+	raw_spin_lock_irqsave(&gc->bgpio_lock, flags);
 
 	ctrl->mask_cache |= BIT(d->hwirq);
 	writel(ctrl->mask_cache, ctrl->pic + IDT_PIC_IRQ_MASK);
 
-	spin_unlock_irqrestore(&gc->bgpio_lock, flags);
+	raw_spin_unlock_irqrestore(&gc->bgpio_lock, flags);
 }
 
 static void idt_gpio_unmask(struct irq_data *d)
@@ -100,12 +100,12 @@ static void idt_gpio_unmask(struct irq_data *d)
 	struct idt_gpio_ctrl *ctrl = gpiochip_get_data(gc);
 	unsigned long flags;
 
-	spin_lock_irqsave(&gc->bgpio_lock, flags);
+	raw_spin_lock_irqsave(&gc->bgpio_lock, flags);
 
 	ctrl->mask_cache &= ~BIT(d->hwirq);
 	writel(ctrl->mask_cache, ctrl->pic + IDT_PIC_IRQ_MASK);
 
-	spin_unlock_irqrestore(&gc->bgpio_lock, flags);
+	raw_spin_unlock_irqrestore(&gc->bgpio_lock, flags);
 }
 
 static int idt_gpio_irq_init_hw(struct gpio_chip *gc)
diff --git a/drivers/gpio/gpio-ixp4xx.c b/drivers/gpio/gpio-ixp4xx.c
index b3b050604e0b..6b184502fa3f 100644
--- a/drivers/gpio/gpio-ixp4xx.c
+++ b/drivers/gpio/gpio-ixp4xx.c
@@ -128,7 +128,7 @@ static int ixp4xx_gpio_irq_set_type(struct irq_data *d, unsigned int type)
 		int_reg = IXP4XX_REG_GPIT1;
 	}
 
-	spin_lock_irqsave(&g->gc.bgpio_lock, flags);
+	raw_spin_lock_irqsave(&g->gc.bgpio_lock, flags);
 
 	/* Clear the style for the appropriate pin */
 	val = __raw_readl(g->base + int_reg);
@@ -147,7 +147,7 @@ static int ixp4xx_gpio_irq_set_type(struct irq_data *d, unsigned int type)
 	val |= BIT(d->hwirq);
 	__raw_writel(val, g->base + IXP4XX_REG_GPOE);
 
-	spin_unlock_irqrestore(&g->gc.bgpio_lock, flags);
+	raw_spin_unlock_irqrestore(&g->gc.bgpio_lock, flags);
 
 	/* This parent only accept level high (asserted) */
 	return irq_chip_set_type_parent(d, IRQ_TYPE_LEVEL_HIGH);
diff --git a/drivers/gpio/gpio-loongson1.c b/drivers/gpio/gpio-loongson1.c
index 1b1ee94eeab4..5d90b3bc5a25 100644
--- a/drivers/gpio/gpio-loongson1.c
+++ b/drivers/gpio/gpio-loongson1.c
@@ -25,10 +25,10 @@ static int ls1x_gpio_request(struct gpio_chip *gc, unsigned int offset)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&gc->bgpio_lock, flags);
+	raw_spin_lock_irqsave(&gc->bgpio_lock, flags);
 	__raw_writel(__raw_readl(gpio_reg_base + GPIO_CFG) | BIT(offset),
 		     gpio_reg_base + GPIO_CFG);
-	spin_unlock_irqrestore(&gc->bgpio_lock, flags);
+	raw_spin_unlock_irqrestore(&gc->bgpio_lock, flags);
 
 	return 0;
 }
@@ -37,10 +37,10 @@ static void ls1x_gpio_free(struct gpio_chip *gc, unsigned int offset)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&gc->bgpio_lock, flags);
+	raw_spin_lock_irqsave(&gc->bgpio_lock, flags);
 	__raw_writel(__raw_readl(gpio_reg_base + GPIO_CFG) & ~BIT(offset),
 		     gpio_reg_base + GPIO_CFG);
-	spin_unlock_irqrestore(&gc->bgpio_lock, flags);
+	raw_spin_unlock_irqrestore(&gc->bgpio_lock, flags);
 }
 
 static int ls1x_gpio_probe(struct platform_device *pdev)
diff --git a/drivers/gpio/gpio-menz127.c b/drivers/gpio/gpio-menz127.c
index 1e21c661d79d..a035a9bcb57c 100644
--- a/drivers/gpio/gpio-menz127.c
+++ b/drivers/gpio/gpio-menz127.c
@@ -64,7 +64,7 @@ static int men_z127_debounce(struct gpio_chip *gc, unsigned gpio,
 		debounce /= 50;
 	}
 
-	spin_lock(&gc->bgpio_lock);
+	raw_spin_lock(&gc->bgpio_lock);
 
 	db_en = readl(priv->reg_base + MEN_Z127_DBER);
 
@@ -79,7 +79,7 @@ static int men_z127_debounce(struct gpio_chip *gc, unsigned gpio,
 	writel(db_en, priv->reg_base + MEN_Z127_DBER);
 	writel(db_cnt, priv->reg_base + GPIO_TO_DBCNT_REG(gpio));
 
-	spin_unlock(&gc->bgpio_lock);
+	raw_spin_unlock(&gc->bgpio_lock);
 
 	return 0;
 }
@@ -91,7 +91,7 @@ static int men_z127_set_single_ended(struct gpio_chip *gc,
 	struct men_z127_gpio *priv = gpiochip_get_data(gc);
 	u32 od_en;
 
-	spin_lock(&gc->bgpio_lock);
+	raw_spin_lock(&gc->bgpio_lock);
 	od_en = readl(priv->reg_base + MEN_Z127_ODER);
 
 	if (param == PIN_CONFIG_DRIVE_OPEN_DRAIN)
@@ -101,7 +101,7 @@ static int men_z127_set_single_ended(struct gpio_chip *gc,
 		od_en &= ~BIT(offset);
 
 	writel(od_en, priv->reg_base + MEN_Z127_ODER);
-	spin_unlock(&gc->bgpio_lock);
+	raw_spin_unlock(&gc->bgpio_lock);
 
 	return 0;
 }
diff --git a/drivers/gpio/gpio-mlxbf2.c b/drivers/gpio/gpio-mlxbf2.c
index 40a052bc6784..5a09070e5f78 100644
--- a/drivers/gpio/gpio-mlxbf2.c
+++ b/drivers/gpio/gpio-mlxbf2.c
@@ -120,7 +120,7 @@ static int mlxbf2_gpio_lock_acquire(struct mlxbf2_gpio_context *gs)
 	u32 arm_gpio_lock_val;
 
 	mutex_lock(yu_arm_gpio_lock_param.lock);
-	spin_lock(&gs->gc.bgpio_lock);
+	raw_spin_lock(&gs->gc.bgpio_lock);
 
 	arm_gpio_lock_val = readl(yu_arm_gpio_lock_param.io);
 
@@ -128,7 +128,7 @@ static int mlxbf2_gpio_lock_acquire(struct mlxbf2_gpio_context *gs)
 	 * When lock active bit[31] is set, ModeX is write enabled
 	 */
 	if (YU_LOCK_ACTIVE_BIT(arm_gpio_lock_val)) {
-		spin_unlock(&gs->gc.bgpio_lock);
+		raw_spin_unlock(&gs->gc.bgpio_lock);
 		mutex_unlock(yu_arm_gpio_lock_param.lock);
 		return -EINVAL;
 	}
@@ -146,7 +146,7 @@ static void mlxbf2_gpio_lock_release(struct mlxbf2_gpio_context *gs)
 	__releases(yu_arm_gpio_lock_param.lock)
 {
 	writel(YU_ARM_GPIO_LOCK_RELEASE, yu_arm_gpio_lock_param.io);
-	spin_unlock(&gs->gc.bgpio_lock);
+	raw_spin_unlock(&gs->gc.bgpio_lock);
 	mutex_unlock(yu_arm_gpio_lock_param.lock);
 }
 
diff --git a/drivers/gpio/gpio-mmio.c b/drivers/gpio/gpio-mmio.c
index c335a0309ba3..d9dff3dc92ae 100644
--- a/drivers/gpio/gpio-mmio.c
+++ b/drivers/gpio/gpio-mmio.c
@@ -220,7 +220,7 @@ static void bgpio_set(struct gpio_chip *gc, unsigned int gpio, int val)
 	unsigned long mask = bgpio_line2mask(gc, gpio);
 	unsigned long flags;
 
-	spin_lock_irqsave(&gc->bgpio_lock, flags);
+	raw_spin_lock_irqsave(&gc->bgpio_lock, flags);
 
 	if (val)
 		gc->bgpio_data |= mask;
@@ -229,7 +229,7 @@ static void bgpio_set(struct gpio_chip *gc, unsigned int gpio, int val)
 
 	gc->write_reg(gc->reg_dat, gc->bgpio_data);
 
-	spin_unlock_irqrestore(&gc->bgpio_lock, flags);
+	raw_spin_unlock_irqrestore(&gc->bgpio_lock, flags);
 }
 
 static void bgpio_set_with_clear(struct gpio_chip *gc, unsigned int gpio,
@@ -248,7 +248,7 @@ static void bgpio_set_set(struct gpio_chip *gc, unsigned int gpio, int val)
 	unsigned long mask = bgpio_line2mask(gc, gpio);
 	unsigned long flags;
 
-	spin_lock_irqsave(&gc->bgpio_lock, flags);
+	raw_spin_lock_irqsave(&gc->bgpio_lock, flags);
 
 	if (val)
 		gc->bgpio_data |= mask;
@@ -257,7 +257,7 @@ static void bgpio_set_set(struct gpio_chip *gc, unsigned int gpio, int val)
 
 	gc->write_reg(gc->reg_set, gc->bgpio_data);
 
-	spin_unlock_irqrestore(&gc->bgpio_lock, flags);
+	raw_spin_unlock_irqrestore(&gc->bgpio_lock, flags);
 }
 
 static void bgpio_multiple_get_masks(struct gpio_chip *gc,
@@ -286,7 +286,7 @@ static void bgpio_set_multiple_single_reg(struct gpio_chip *gc,
 	unsigned long flags;
 	unsigned long set_mask, clear_mask;
 
-	spin_lock_irqsave(&gc->bgpio_lock, flags);
+	raw_spin_lock_irqsave(&gc->bgpio_lock, flags);
 
 	bgpio_multiple_get_masks(gc, mask, bits, &set_mask, &clear_mask);
 
@@ -295,7 +295,7 @@ static void bgpio_set_multiple_single_reg(struct gpio_chip *gc,
 
 	gc->write_reg(reg, gc->bgpio_data);
 
-	spin_unlock_irqrestore(&gc->bgpio_lock, flags);
+	raw_spin_unlock_irqrestore(&gc->bgpio_lock, flags);
 }
 
 static void bgpio_set_multiple(struct gpio_chip *gc, unsigned long *mask,
@@ -347,7 +347,7 @@ static int bgpio_dir_in(struct gpio_chip *gc, unsigned int gpio)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&gc->bgpio_lock, flags);
+	raw_spin_lock_irqsave(&gc->bgpio_lock, flags);
 
 	gc->bgpio_dir &= ~bgpio_line2mask(gc, gpio);
 
@@ -356,7 +356,7 @@ static int bgpio_dir_in(struct gpio_chip *gc, unsigned int gpio)
 	if (gc->reg_dir_out)
 		gc->write_reg(gc->reg_dir_out, gc->bgpio_dir);
 
-	spin_unlock_irqrestore(&gc->bgpio_lock, flags);
+	raw_spin_unlock_irqrestore(&gc->bgpio_lock, flags);
 
 	return 0;
 }
@@ -387,7 +387,7 @@ static void bgpio_dir_out(struct gpio_chip *gc, unsigned int gpio, int val)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&gc->bgpio_lock, flags);
+	raw_spin_lock_irqsave(&gc->bgpio_lock, flags);
 
 	gc->bgpio_dir |= bgpio_line2mask(gc, gpio);
 
@@ -396,7 +396,7 @@ static void bgpio_dir_out(struct gpio_chip *gc, unsigned int gpio, int val)
 	if (gc->reg_dir_out)
 		gc->write_reg(gc->reg_dir_out, gc->bgpio_dir);
 
-	spin_unlock_irqrestore(&gc->bgpio_lock, flags);
+	raw_spin_unlock_irqrestore(&gc->bgpio_lock, flags);
 }
 
 static int bgpio_dir_out_dir_first(struct gpio_chip *gc, unsigned int gpio,
@@ -610,7 +610,7 @@ int bgpio_init(struct gpio_chip *gc, struct device *dev,
 	if (gc->bgpio_bits > BITS_PER_LONG)
 		return -EINVAL;
 
-	spin_lock_init(&gc->bgpio_lock);
+	raw_spin_lock_init(&gc->bgpio_lock);
 	gc->parent = dev;
 	gc->label = dev_name(dev);
 	gc->base = -1;
diff --git a/drivers/gpio/gpio-mxc.c b/drivers/gpio/gpio-mxc.c
index c871602fc5ba..853d9aa6b3b1 100644
--- a/drivers/gpio/gpio-mxc.c
+++ b/drivers/gpio/gpio-mxc.c
@@ -18,6 +18,7 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
+#include <linux/spinlock.h>
 #include <linux/syscore_ops.h>
 #include <linux/gpio/driver.h>
 #include <linux/of.h>
@@ -147,6 +148,7 @@ static int gpio_set_irq_type(struct irq_data *d, u32 type)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
 	struct mxc_gpio_port *port = gc->private;
+	unsigned long flags;
 	u32 bit, val;
 	u32 gpio_idx = d->hwirq;
 	int edge;
@@ -185,6 +187,8 @@ static int gpio_set_irq_type(struct irq_data *d, u32 type)
 		return -EINVAL;
 	}
 
+	raw_spin_lock_irqsave(&port->gc.bgpio_lock, flags);
+
 	if (GPIO_EDGE_SEL >= 0) {
 		val = readl(port->base + GPIO_EDGE_SEL);
 		if (edge == GPIO_INT_BOTH_EDGES)
@@ -204,15 +208,20 @@ static int gpio_set_irq_type(struct irq_data *d, u32 type)
 
 	writel(1 << gpio_idx, port->base + GPIO_ISR);
 
-	return 0;
+	raw_spin_unlock_irqrestore(&port->gc.bgpio_lock, flags);
+
+	return port->gc.direction_input(&port->gc, gpio_idx);
 }
 
 static void mxc_flip_edge(struct mxc_gpio_port *port, u32 gpio)
 {
 	void __iomem *reg = port->base;
+	unsigned long flags;
 	u32 bit, val;
 	int edge;
 
+	raw_spin_lock_irqsave(&port->gc.bgpio_lock, flags);
+
 	reg += GPIO_ICR1 + ((gpio & 0x10) >> 2); /* lower or upper register */
 	bit = gpio & 0xf;
 	val = readl(reg);
@@ -227,9 +236,12 @@ static void mxc_flip_edge(struct mxc_gpio_port *port, u32 gpio)
 	} else {
 		pr_err("mxc: invalid configuration for GPIO %d: %x\n",
 		       gpio, edge);
-		return;
+		goto unlock;
 	}
 	writel(val | (edge << (bit << 1)), reg);
+
+unlock:
+	raw_spin_unlock_irqrestore(&port->gc.bgpio_lock, flags);
 }
 
 /* handle 32 interrupts in one status register */
diff --git a/drivers/gpio/gpio-sifive.c b/drivers/gpio/gpio-sifive.c
index f50236e68e88..f41123de69c5 100644
--- a/drivers/gpio/gpio-sifive.c
+++ b/drivers/gpio/gpio-sifive.c
@@ -44,7 +44,7 @@ static void sifive_gpio_set_ie(struct sifive_gpio *chip, unsigned int offset)
 	unsigned long flags;
 	unsigned int trigger;
 
-	spin_lock_irqsave(&chip->gc.bgpio_lock, flags);
+	raw_spin_lock_irqsave(&chip->gc.bgpio_lock, flags);
 	trigger = (chip->irq_state & BIT(offset)) ? chip->trigger[offset] : 0;
 	regmap_update_bits(chip->regs, SIFIVE_GPIO_RISE_IE, BIT(offset),
 			   (trigger & IRQ_TYPE_EDGE_RISING) ? BIT(offset) : 0);
@@ -54,7 +54,7 @@ static void sifive_gpio_set_ie(struct sifive_gpio *chip, unsigned int offset)
 			   (trigger & IRQ_TYPE_LEVEL_HIGH) ? BIT(offset) : 0);
 	regmap_update_bits(chip->regs, SIFIVE_GPIO_LOW_IE, BIT(offset),
 			   (trigger & IRQ_TYPE_LEVEL_LOW) ? BIT(offset) : 0);
-	spin_unlock_irqrestore(&chip->gc.bgpio_lock, flags);
+	raw_spin_unlock_irqrestore(&chip->gc.bgpio_lock, flags);
 }
 
 static int sifive_gpio_irq_set_type(struct irq_data *d, unsigned int trigger)
@@ -84,13 +84,13 @@ static void sifive_gpio_irq_enable(struct irq_data *d)
 	/* Switch to input */
 	gc->direction_input(gc, offset);
 
-	spin_lock_irqsave(&gc->bgpio_lock, flags);
+	raw_spin_lock_irqsave(&gc->bgpio_lock, flags);
 	/* Clear any sticky pending interrupts */
 	regmap_write(chip->regs, SIFIVE_GPIO_RISE_IP, bit);
 	regmap_write(chip->regs, SIFIVE_GPIO_FALL_IP, bit);
 	regmap_write(chip->regs, SIFIVE_GPIO_HIGH_IP, bit);
 	regmap_write(chip->regs, SIFIVE_GPIO_LOW_IP, bit);
-	spin_unlock_irqrestore(&gc->bgpio_lock, flags);
+	raw_spin_unlock_irqrestore(&gc->bgpio_lock, flags);
 
 	/* Enable interrupts */
 	assign_bit(offset, &chip->irq_state, 1);
@@ -116,13 +116,13 @@ static void sifive_gpio_irq_eoi(struct irq_data *d)
 	u32 bit = BIT(offset);
 	unsigned long flags;
 
-	spin_lock_irqsave(&gc->bgpio_lock, flags);
+	raw_spin_lock_irqsave(&gc->bgpio_lock, flags);
 	/* Clear all pending interrupts */
 	regmap_write(chip->regs, SIFIVE_GPIO_RISE_IP, bit);
 	regmap_write(chip->regs, SIFIVE_GPIO_FALL_IP, bit);
 	regmap_write(chip->regs, SIFIVE_GPIO_HIGH_IP, bit);
 	regmap_write(chip->regs, SIFIVE_GPIO_LOW_IP, bit);
-	spin_unlock_irqrestore(&gc->bgpio_lock, flags);
+	raw_spin_unlock_irqrestore(&gc->bgpio_lock, flags);
 
 	irq_chip_eoi_parent(d);
 }
diff --git a/drivers/gpio/gpio-tb10x.c b/drivers/gpio/gpio-tb10x.c
index 718a508d3b2f..de6afa3f9716 100644
--- a/drivers/gpio/gpio-tb10x.c
+++ b/drivers/gpio/gpio-tb10x.c
@@ -62,14 +62,14 @@ static inline void tb10x_set_bits(struct tb10x_gpio *gpio, unsigned int offs,
 	u32 r;
 	unsigned long flags;
 
-	spin_lock_irqsave(&gpio->gc.bgpio_lock, flags);
+	raw_spin_lock_irqsave(&gpio->gc.bgpio_lock, flags);
 
 	r = tb10x_reg_read(gpio, offs);
 	r = (r & ~mask) | (val & mask);
 
 	tb10x_reg_write(gpio, offs, r);
 
-	spin_unlock_irqrestore(&gpio->gc.bgpio_lock, flags);
+	raw_spin_unlock_irqrestore(&gpio->gc.bgpio_lock, flags);
 }
 
 static int tb10x_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
index e7845df6cad2..5e32906f9819 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
@@ -580,10 +580,14 @@ void amdgpu_gfx_off_ctrl(struct amdgpu_device *adev, bool enable)
 		if (adev->gfx.gfx_off_req_count == 0 &&
 		    !adev->gfx.gfx_off_state) {
 			/* If going to s2idle, no need to wait */
-			if (adev->in_s0ix)
-				delay = GFX_OFF_NO_DELAY;
-			schedule_delayed_work(&adev->gfx.gfx_off_delay_work,
+			if (adev->in_s0ix) {
+				if (!amdgpu_dpm_set_powergating_by_smu(adev,
+						AMD_IP_BLOCK_TYPE_GFX, true))
+					adev->gfx.gfx_off_state = true;
+			} else {
+				schedule_delayed_work(&adev->gfx.gfx_off_delay_work,
 					      delay);
+			}
 		}
 	} else {
 		if (adev->gfx.gfx_off_req_count == 0) {
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 409739ee5ba0..a2d9e0af0654 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1688,10 +1688,6 @@ static void amdgpu_dm_fini(struct amdgpu_device *adev)
 	}
 #endif
 
-	for (i = 0; i < adev->dm.display_indexes_num; i++) {
-		drm_encoder_cleanup(&adev->dm.mst_encoders[i].base);
-	}
-
 	amdgpu_dm_destroy_drm_device(&adev->dm);
 
 #if defined(CONFIG_DRM_AMD_SECURE_DISPLAY)
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
index 652cf108b3c2..bc02e3e0d17d 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -385,7 +385,6 @@ static const struct drm_connector_helper_funcs dm_dp_mst_connector_helper_funcs
 static void amdgpu_dm_encoder_destroy(struct drm_encoder *encoder)
 {
 	drm_encoder_cleanup(encoder);
-	kfree(encoder);
 }
 
 static const struct drm_encoder_funcs amdgpu_dm_encoder_funcs = {
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
diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
index 59fb4c710c8c..41094d51fc6f 100644
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -986,12 +986,9 @@ static int i915_driver_open(struct drm_device *dev, struct drm_file *file)
  */
 static void i915_driver_lastclose(struct drm_device *dev)
 {
-	struct drm_i915_private *i915 = to_i915(dev);
-
 	intel_fbdev_restore_mode(dev);
 
-	if (HAS_DISPLAY(i915))
-		vga_switcheroo_process_delayed_switch();
+	vga_switcheroo_process_delayed_switch();
 }
 
 static void i915_driver_postclose(struct drm_device *dev, struct drm_file *file)
diff --git a/drivers/gpu/drm/i915/i915_switcheroo.c b/drivers/gpu/drm/i915/i915_switcheroo.c
index de0e224b56ce..f1ce9f591efa 100644
--- a/drivers/gpu/drm/i915/i915_switcheroo.c
+++ b/drivers/gpu/drm/i915/i915_switcheroo.c
@@ -18,6 +18,10 @@ static void i915_switcheroo_set_state(struct pci_dev *pdev,
 		dev_err(&pdev->dev, "DRM not initialized, aborting switch.\n");
 		return;
 	}
+	if (!HAS_DISPLAY(i915)) {
+		dev_err(&pdev->dev, "Device state not initialized, aborting switch.\n");
+		return;
+	}
 
 	if (state == VGA_SWITCHEROO_ON) {
 		drm_info(&i915->drm, "switched on\n");
@@ -43,7 +47,7 @@ static bool i915_switcheroo_can_switch(struct pci_dev *pdev)
 	 * locking inversion with the driver load path. And the access here is
 	 * completely racy anyway. So don't bother with locking for now.
 	 */
-	return i915 && atomic_read(&i915->drm.open_count) == 0;
+	return i915 && HAS_DISPLAY(i915) && atomic_read(&i915->drm.open_count) == 0;
 }
 
 static const struct vga_switcheroo_client_ops i915_switcheroo_ops = {
diff --git a/drivers/gpu/drm/i915/selftests/intel_scheduler_helpers.c b/drivers/gpu/drm/i915/selftests/intel_scheduler_helpers.c
index 4b328346b48a..83ffd175ca89 100644
--- a/drivers/gpu/drm/i915/selftests/intel_scheduler_helpers.c
+++ b/drivers/gpu/drm/i915/selftests/intel_scheduler_helpers.c
@@ -16,8 +16,7 @@
 
 int intel_selftest_modify_policy(struct intel_engine_cs *engine,
 				 struct intel_selftest_saved_policy *saved,
-				 u32 modify_type)
-
+				 enum selftest_scheduler_modify modify_type)
 {
 	int err;
 
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
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_msg_arm64.h b/drivers/gpu/drm/vmwgfx/vmwgfx_msg_arm64.h
old mode 100755
new mode 100644
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
index ef9c799fa371..2e475bd426b8 100644
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
index 8698d49edaa3..fa1aa22547ea 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -261,7 +261,6 @@
 #define USB_DEVICE_ID_CH_AXIS_295	0x001c
 
 #define USB_VENDOR_ID_CHERRY		0x046a
-#define USB_DEVICE_ID_CHERRY_MOUSE_000C	0x000c
 #define USB_DEVICE_ID_CHERRY_CYMOTION	0x0023
 #define USB_DEVICE_ID_CHERRY_CYMOTION_SOLAR	0x0027
 
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index fc1e061900bc..184029cad014 100644
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
index a1100e37626e..4af65f101dac 100644
--- a/drivers/i2c/busses/i2c-designware-common.c
+++ b/drivers/i2c/busses/i2c-designware-common.c
@@ -351,7 +351,8 @@ u32 i2c_dw_scl_hcnt(u32 ic_clk, u32 tSYMBOL, u32 tf, int cond, int offset)
 		 *
 		 * If your hardware is free from tHD;STA issue, try this one.
 		 */
-		return DIV_ROUND_CLOSEST(ic_clk * tSYMBOL, MICRO) - 8 + offset;
+		return DIV_ROUND_CLOSEST_ULL((u64)ic_clk * tSYMBOL, MICRO) -
+		       8 + offset;
 	else
 		/*
 		 * Conditional expression:
@@ -367,7 +368,8 @@ u32 i2c_dw_scl_hcnt(u32 ic_clk, u32 tSYMBOL, u32 tf, int cond, int offset)
 		 * The reason why we need to take into account "tf" here,
 		 * is the same as described in i2c_dw_scl_lcnt().
 		 */
-		return DIV_ROUND_CLOSEST(ic_clk * (tSYMBOL + tf), MICRO) - 3 + offset;
+		return DIV_ROUND_CLOSEST_ULL((u64)ic_clk * (tSYMBOL + tf), MICRO) -
+		       3 + offset;
 }
 
 u32 i2c_dw_scl_lcnt(u32 ic_clk, u32 tLOW, u32 tf, int offset)
@@ -383,7 +385,8 @@ u32 i2c_dw_scl_lcnt(u32 ic_clk, u32 tLOW, u32 tf, int offset)
 	 * account the fall time of SCL signal (tf).  Default tf value
 	 * should be 0.3 us, for safety.
 	 */
-	return DIV_ROUND_CLOSEST(ic_clk * (tLOW + tf), MICRO) - 1 + offset;
+	return DIV_ROUND_CLOSEST_ULL((u64)ic_clk * (tLOW + tf), MICRO) -
+	       1 + offset;
 }
 
 int i2c_dw_set_sda_hold(struct dw_i2c_dev *dev)
diff --git a/drivers/i2c/busses/i2c-mv64xxx.c b/drivers/i2c/busses/i2c-mv64xxx.c
index 5c8e94b6cdb5..103a05ecc3d6 100644
--- a/drivers/i2c/busses/i2c-mv64xxx.c
+++ b/drivers/i2c/busses/i2c-mv64xxx.c
@@ -150,6 +150,7 @@ struct mv64xxx_i2c_data {
 	/* Clk div is 2 to the power n, not 2 to the power n + 1 */
 	bool			clk_n_base_0;
 	struct i2c_bus_recovery_info	rinfo;
+	bool			atomic;
 };
 
 static struct mv64xxx_i2c_regs mv64xxx_i2c_regs_mv64xxx = {
@@ -179,7 +180,10 @@ mv64xxx_i2c_prepare_for_io(struct mv64xxx_i2c_data *drv_data,
 	u32	dir = 0;
 
 	drv_data->cntl_bits = MV64XXX_I2C_REG_CONTROL_ACK |
-		MV64XXX_I2C_REG_CONTROL_INTEN | MV64XXX_I2C_REG_CONTROL_TWSIEN;
+			      MV64XXX_I2C_REG_CONTROL_TWSIEN;
+
+	if (!drv_data->atomic)
+		drv_data->cntl_bits |= MV64XXX_I2C_REG_CONTROL_INTEN;
 
 	if (msg->flags & I2C_M_RD)
 		dir = 1;
@@ -409,7 +413,8 @@ mv64xxx_i2c_do_action(struct mv64xxx_i2c_data *drv_data)
 	case MV64XXX_I2C_ACTION_RCV_DATA_STOP:
 		drv_data->msg->buf[drv_data->byte_posn++] =
 			readl(drv_data->reg_base + drv_data->reg_offsets.data);
-		drv_data->cntl_bits &= ~MV64XXX_I2C_REG_CONTROL_INTEN;
+		if (!drv_data->atomic)
+			drv_data->cntl_bits &= ~MV64XXX_I2C_REG_CONTROL_INTEN;
 		writel(drv_data->cntl_bits | MV64XXX_I2C_REG_CONTROL_STOP,
 			drv_data->reg_base + drv_data->reg_offsets.control);
 		drv_data->block = 0;
@@ -427,7 +432,8 @@ mv64xxx_i2c_do_action(struct mv64xxx_i2c_data *drv_data)
 		drv_data->rc = -EIO;
 		fallthrough;
 	case MV64XXX_I2C_ACTION_SEND_STOP:
-		drv_data->cntl_bits &= ~MV64XXX_I2C_REG_CONTROL_INTEN;
+		if (!drv_data->atomic)
+			drv_data->cntl_bits &= ~MV64XXX_I2C_REG_CONTROL_INTEN;
 		writel(drv_data->cntl_bits | MV64XXX_I2C_REG_CONTROL_STOP,
 			drv_data->reg_base + drv_data->reg_offsets.control);
 		drv_data->block = 0;
@@ -575,6 +581,17 @@ mv64xxx_i2c_wait_for_completion(struct mv64xxx_i2c_data *drv_data)
 		spin_unlock_irqrestore(&drv_data->lock, flags);
 }
 
+static void mv64xxx_i2c_wait_polling(struct mv64xxx_i2c_data *drv_data)
+{
+	ktime_t timeout = ktime_add_ms(ktime_get(), drv_data->adapter.timeout);
+
+	while (READ_ONCE(drv_data->block) &&
+	       ktime_compare(ktime_get(), timeout) < 0) {
+		udelay(5);
+		mv64xxx_i2c_intr(0, drv_data);
+	}
+}
+
 static int
 mv64xxx_i2c_execute_msg(struct mv64xxx_i2c_data *drv_data, struct i2c_msg *msg,
 				int is_last)
@@ -590,7 +607,11 @@ mv64xxx_i2c_execute_msg(struct mv64xxx_i2c_data *drv_data, struct i2c_msg *msg,
 	mv64xxx_i2c_send_start(drv_data);
 	spin_unlock_irqrestore(&drv_data->lock, flags);
 
-	mv64xxx_i2c_wait_for_completion(drv_data);
+	if (!drv_data->atomic)
+		mv64xxx_i2c_wait_for_completion(drv_data);
+	else
+		mv64xxx_i2c_wait_polling(drv_data);
+
 	return drv_data->rc;
 }
 
@@ -717,7 +738,7 @@ mv64xxx_i2c_functionality(struct i2c_adapter *adap)
 }
 
 static int
-mv64xxx_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[], int num)
+mv64xxx_i2c_xfer_core(struct i2c_adapter *adap, struct i2c_msg msgs[], int num)
 {
 	struct mv64xxx_i2c_data *drv_data = i2c_get_adapdata(adap);
 	int rc, ret = num;
@@ -730,7 +751,7 @@ mv64xxx_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[], int num)
 	drv_data->msgs = msgs;
 	drv_data->num_msgs = num;
 
-	if (mv64xxx_i2c_can_offload(drv_data))
+	if (mv64xxx_i2c_can_offload(drv_data) && !drv_data->atomic)
 		rc = mv64xxx_i2c_offload_xfer(drv_data);
 	else
 		rc = mv64xxx_i2c_execute_msg(drv_data, &msgs[0], num == 1);
@@ -747,8 +768,27 @@ mv64xxx_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[], int num)
 	return ret;
 }
 
+static int
+mv64xxx_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[], int num)
+{
+	struct mv64xxx_i2c_data *drv_data = i2c_get_adapdata(adap);
+
+	drv_data->atomic = 0;
+	return mv64xxx_i2c_xfer_core(adap, msgs, num);
+}
+
+static int mv64xxx_i2c_xfer_atomic(struct i2c_adapter *adap,
+				   struct i2c_msg msgs[], int num)
+{
+	struct mv64xxx_i2c_data *drv_data = i2c_get_adapdata(adap);
+
+	drv_data->atomic = 1;
+	return mv64xxx_i2c_xfer_core(adap, msgs, num);
+}
+
 static const struct i2c_algorithm mv64xxx_i2c_algo = {
 	.master_xfer = mv64xxx_i2c_xfer,
+	.master_xfer_atomic = mv64xxx_i2c_xfer_atomic,
 	.functionality = mv64xxx_i2c_functionality,
 };
 
@@ -1047,14 +1087,6 @@ mv64xxx_i2c_remove(struct platform_device *pd)
 	return 0;
 }
 
-static void
-mv64xxx_i2c_shutdown(struct platform_device *pd)
-{
-	pm_runtime_disable(&pd->dev);
-	if (!pm_runtime_status_suspended(&pd->dev))
-		mv64xxx_i2c_runtime_suspend(&pd->dev);
-}
-
 static const struct dev_pm_ops mv64xxx_i2c_pm_ops = {
 	SET_RUNTIME_PM_OPS(mv64xxx_i2c_runtime_suspend,
 			   mv64xxx_i2c_runtime_resume, NULL)
@@ -1065,7 +1097,6 @@ static const struct dev_pm_ops mv64xxx_i2c_pm_ops = {
 static struct platform_driver mv64xxx_i2c_driver = {
 	.probe	= mv64xxx_i2c_probe,
 	.remove	= mv64xxx_i2c_remove,
-	.shutdown = mv64xxx_i2c_shutdown,
 	.driver	= {
 		.name	= MV64XXX_I2C_CTLR_NAME,
 		.pm     = &mv64xxx_i2c_pm_ops,
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index b721085bb597..f0c07e4ba438 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -2965,15 +2965,18 @@ EXPORT_SYMBOL(__rdma_block_iter_start);
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
index 0c86e9d354f8..ba930112c162 100644
--- a/drivers/infiniband/hw/hfi1/user_exp_rcv.c
+++ b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
@@ -23,18 +23,25 @@ static void cacheless_tid_rb_remove(struct hfi1_filedata *fdata,
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
@@ -253,53 +260,65 @@ int hfi1_user_exp_rcv_setup(struct hfi1_filedata *fd,
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
@@ -395,43 +414,78 @@ int hfi1_user_exp_rcv_setup(struct hfi1_filedata *fd,
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
@@ -452,7 +506,7 @@ int hfi1_user_exp_rcv_clear(struct hfi1_filedata *fd,
 
 	mutex_lock(&uctxt->exp_mutex);
 	for (tididx = 0; tididx < tinfo->tidcnt; tididx++) {
-		ret = unprogram_rcvarray(fd, tidinfo[tididx], NULL);
+		ret = unprogram_rcvarray(fd, tidinfo[tididx]);
 		if (ret) {
 			hfi1_cdbg(TID, "Failed to unprogram rcv array %d",
 				  ret);
@@ -707,6 +761,7 @@ static int set_rcvarray_entry(struct hfi1_filedata *fd,
 	}
 
 	node->fdata = fd;
+	mutex_init(&node->invalidate_mutex);
 	node->phys = page_to_phys(pages[0]);
 	node->npages = npages;
 	node->rcventry = rcventry;
@@ -722,11 +777,6 @@ static int set_rcvarray_entry(struct hfi1_filedata *fd,
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
 
@@ -746,8 +796,7 @@ static int set_rcvarray_entry(struct hfi1_filedata *fd,
 	return -EFAULT;
 }
 
-static int unprogram_rcvarray(struct hfi1_filedata *fd, u32 tidinfo,
-			      struct tid_group **grp)
+static int unprogram_rcvarray(struct hfi1_filedata *fd, u32 tidinfo)
 {
 	struct hfi1_ctxtdata *uctxt = fd->uctxt;
 	struct hfi1_devdata *dd = uctxt->dd;
@@ -770,9 +819,6 @@ static int unprogram_rcvarray(struct hfi1_filedata *fd, u32 tidinfo,
 	if (!node || node->rcventry != (uctxt->expected_base + rcventry))
 		return -EBADF;
 
-	if (grp)
-		*grp = node->grp;
-
 	if (fd->use_mn)
 		mmu_interval_notifier_remove(&node->notifier);
 	cacheless_tid_rb_remove(fd, node);
@@ -780,23 +826,34 @@ static int unprogram_rcvarray(struct hfi1_filedata *fd, u32 tidinfo,
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
@@ -855,10 +912,16 @@ static bool tid_rb_invalidate(struct mmu_interval_notifier *mni,
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
@@ -888,6 +951,23 @@ static bool tid_rb_invalidate(struct mmu_interval_notifier *mni,
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
index 8c53e416bf84..f8ee997d0050 100644
--- a/drivers/infiniband/hw/hfi1/user_exp_rcv.h
+++ b/drivers/infiniband/hw/hfi1/user_exp_rcv.h
@@ -16,6 +16,8 @@ struct tid_pageset {
 };
 
 struct tid_user_buf {
+	struct mmu_interval_notifier notifier;
+	struct mutex cover_mutex;
 	unsigned long vaddr;
 	unsigned long length;
 	unsigned int npages;
@@ -27,6 +29,7 @@ struct tid_user_buf {
 struct tid_rb_node {
 	struct mmu_interval_notifier notifier;
 	struct hfi1_filedata *fdata;
+	struct mutex invalidate_mutex; /* covers hw removal */
 	unsigned long phys;
 	struct tid_group *grp;
 	u32 rcventry;
diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index 973a4c1d5d09..ffad142801b3 100644
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
diff --git a/drivers/memory/tegra/tegra186.c b/drivers/memory/tegra/tegra186.c
index 3d153881abc1..4bed0e54fd45 100644
--- a/drivers/memory/tegra/tegra186.c
+++ b/drivers/memory/tegra/tegra186.c
@@ -20,32 +20,6 @@
 #define MC_SID_STREAMID_SECURITY_WRITE_ACCESS_DISABLED BIT(16)
 #define MC_SID_STREAMID_SECURITY_OVERRIDE BIT(8)
 
-static void tegra186_mc_program_sid(struct tegra_mc *mc)
-{
-	unsigned int i;
-
-	for (i = 0; i < mc->soc->num_clients; i++) {
-		const struct tegra_mc_client *client = &mc->soc->clients[i];
-		u32 override, security;
-
-		override = readl(mc->regs + client->regs.sid.override);
-		security = readl(mc->regs + client->regs.sid.security);
-
-		dev_dbg(mc->dev, "client %s: override: %x security: %x\n",
-			client->name, override, security);
-
-		dev_dbg(mc->dev, "setting SID %u for %s\n", client->sid,
-			client->name);
-		writel(client->sid, mc->regs + client->regs.sid.override);
-
-		override = readl(mc->regs + client->regs.sid.override);
-		security = readl(mc->regs + client->regs.sid.security);
-
-		dev_dbg(mc->dev, "client %s: override: %x security: %x\n",
-			client->name, override, security);
-	}
-}
-
 static int tegra186_mc_probe(struct tegra_mc *mc)
 {
 	int err;
@@ -54,8 +28,6 @@ static int tegra186_mc_probe(struct tegra_mc *mc)
 	if (err < 0)
 		return err;
 
-	tegra186_mc_program_sid(mc);
-
 	return 0;
 }
 
@@ -64,13 +36,6 @@ static void tegra186_mc_remove(struct tegra_mc *mc)
 	of_platform_depopulate(mc->dev);
 }
 
-static int tegra186_mc_resume(struct tegra_mc *mc)
-{
-	tegra186_mc_program_sid(mc);
-
-	return 0;
-}
-
 #if IS_ENABLED(CONFIG_IOMMU_API)
 static void tegra186_mc_client_sid_override(struct tegra_mc *mc,
 					    const struct tegra_mc_client *client,
@@ -142,7 +107,6 @@ static int tegra186_mc_probe_device(struct tegra_mc *mc, struct device *dev)
 const struct tegra_mc_ops tegra186_mc_ops = {
 	.probe = tegra186_mc_probe,
 	.remove = tegra186_mc_remove,
-	.resume = tegra186_mc_resume,
 	.probe_device = tegra186_mc_probe_device,
 };
 
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 379b38c5844f..bf788e17f408 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -675,10 +675,10 @@ static int ksz9477_port_fdb_del(struct dsa_switch *ds, int port,
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
index 8aab07419263..50f86bebbc19 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -11176,7 +11176,7 @@ static void tg3_reset_task(struct work_struct *work)
 	rtnl_lock();
 	tg3_full_lock(tp, 0);
 
-	if (!netif_running(tp->dev)) {
+	if (tp->pcierr_recovery || !netif_running(tp->dev)) {
 		tg3_flag_clear(tp, RESET_TASK_PENDING);
 		tg3_full_unlock(tp);
 		rtnl_unlock();
@@ -18111,6 +18111,9 @@ static pci_ers_result_t tg3_io_error_detected(struct pci_dev *pdev,
 
 	netdev_info(netdev, "PCI I/O error detected\n");
 
+	/* Want to make sure that the reset task doesn't run */
+	tg3_reset_task_cancel(tp);
+
 	rtnl_lock();
 
 	/* Could be second call or maybe we don't have netdev yet */
@@ -18127,9 +18130,6 @@ static pci_ers_result_t tg3_io_error_detected(struct pci_dev *pdev,
 
 	tg3_timer_stop(tp);
 
-	/* Want to make sure that the reset task doesn't run */
-	tg3_reset_task_cancel(tp);
-
 	netif_device_detach(netdev);
 
 	/* Clean up software state, even if MMIO is blocked */
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 61efb2350412..906c5bbefaac 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -2154,7 +2154,6 @@ static int macb_pad_and_fcs(struct sk_buff **skb, struct net_device *ndev)
 	bool cloned = skb_cloned(*skb) || skb_header_cloned(*skb) ||
 		      skb_is_nonlinear(*skb);
 	int padlen = ETH_ZLEN - (*skb)->len;
-	int headroom = skb_headroom(*skb);
 	int tailroom = skb_tailroom(*skb);
 	struct sk_buff *nskb;
 	u32 fcs;
@@ -2168,9 +2167,6 @@ static int macb_pad_and_fcs(struct sk_buff **skb, struct net_device *ndev)
 		/* FCS could be appeded to tailroom. */
 		if (tailroom >= ETH_FCS_LEN)
 			goto add_fcs;
-		/* FCS could be appeded by moving data to headroom. */
-		else if (!cloned && headroom + tailroom >= ETH_FCS_LEN)
-			padlen = 0;
 		/* No room for FCS, need to reallocate skb. */
 		else
 			padlen = ETH_FCS_LEN;
@@ -2179,10 +2175,7 @@ static int macb_pad_and_fcs(struct sk_buff **skb, struct net_device *ndev)
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
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index adccb14c1644..8b7c93447770 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -2000,14 +2000,14 @@ static void enetc_tx_onestep_tstamp(struct work_struct *work)
 
 	priv = container_of(work, struct enetc_ndev_priv, tx_onestep_tstamp);
 
-	netif_tx_lock(priv->ndev);
+	netif_tx_lock_bh(priv->ndev);
 
 	clear_bit_unlock(ENETC_TX_ONESTEP_TSTAMP_IN_PROGRESS, &priv->flags);
 	skb = skb_dequeue(&priv->tx_skbs);
 	if (skb)
 		enetc_start_xmit(skb, priv->ndev);
 
-	netif_tx_unlock(priv->ndev);
+	netif_tx_unlock_bh(priv->ndev);
 }
 
 static void enetc_tx_onestep_tstamp_init(struct enetc_ndev_priv *priv)
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index f6306eedd59b..2e225309de9c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -962,7 +962,6 @@ static void otx2_pool_refill_task(struct work_struct *work)
 	rbpool = cq->rbpool;
 	free_ptrs = cq->pool_ptrs;
 
-	get_cpu();
 	while (cq->pool_ptrs) {
 		if (otx2_alloc_rbuf(pfvf, rbpool, &bufptr)) {
 			/* Schedule a WQ if we fails to free atleast half of the
@@ -982,7 +981,6 @@ static void otx2_pool_refill_task(struct work_struct *work)
 		pfvf->hw_ops->aura_freeptr(pfvf, qidx, bufptr + OTX2_HEAD_ROOM);
 		cq->pool_ptrs--;
 	}
-	put_cpu();
 	cq->refill_task_sched = false;
 }
 
@@ -1316,7 +1314,6 @@ int otx2_sq_aura_pool_init(struct otx2_nic *pfvf)
 	if (err)
 		goto fail;
 
-	get_cpu();
 	/* Allocate pointers and free them to aura/pool */
 	for (qidx = 0; qidx < hw->tx_queues; qidx++) {
 		pool_id = otx2_get_pool_idx(pfvf, AURA_NIX_SQ, qidx);
@@ -1340,7 +1337,6 @@ int otx2_sq_aura_pool_init(struct otx2_nic *pfvf)
 	}
 
 err_mem:
-	put_cpu();
 	return err ? -ENOMEM : 0;
 
 fail:
@@ -1381,21 +1377,18 @@ int otx2_rq_aura_pool_init(struct otx2_nic *pfvf)
 	if (err)
 		goto fail;
 
-	get_cpu();
 	/* Allocate pointers and free them to aura/pool */
 	for (pool_id = 0; pool_id < hw->rqpool_cnt; pool_id++) {
 		pool = &pfvf->qset.pool[pool_id];
 		for (ptr = 0; ptr < num_ptrs; ptr++) {
 			err = otx2_alloc_rbuf(pfvf, pool, &bufptr);
 			if (err)
-				goto err_mem;
+				return -ENOMEM;
 			pfvf->hw_ops->aura_freeptr(pfvf, pool_id,
 						   bufptr + OTX2_HEAD_ROOM);
 		}
 	}
-err_mem:
-	put_cpu();
-	return err ? -ENOMEM : 0;
+	return 0;
 fail:
 	otx2_mbox_reset(&pfvf->mbox.mbox, 0);
 	otx2_aura_pool_free(pfvf);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 095e5de78c0b..e685628b9294 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -605,8 +605,10 @@ static inline void cn10k_aura_freeptr(void *dev, int aura, u64 buf)
 	u64 ptrs[2];
 
 	ptrs[1] = buf;
+	get_cpu();
 	/* Free only one buffer at time during init and teardown */
 	__cn10k_aura_freeptr(pfvf, aura, ptrs, 2);
+	put_cpu();
 }
 
 /* Alloc pointer from pool/aura */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
index d377ddc70fc7..65c8f1f08472 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
@@ -22,15 +22,13 @@ struct mlx5_esw_rate_group {
 };
 
 static int esw_qos_tsar_config(struct mlx5_core_dev *dev, u32 *sched_ctx,
-			       u32 parent_ix, u32 tsar_ix,
-			       u32 max_rate, u32 bw_share)
+			       u32 tsar_ix, u32 max_rate, u32 bw_share)
 {
 	u32 bitmask = 0;
 
 	if (!MLX5_CAP_GEN(dev, qos) || !MLX5_CAP_QOS(dev, esw_scheduling))
 		return -EOPNOTSUPP;
 
-	MLX5_SET(scheduling_context, sched_ctx, parent_element_id, parent_ix);
 	MLX5_SET(scheduling_context, sched_ctx, max_average_bw, max_rate);
 	MLX5_SET(scheduling_context, sched_ctx, bw_share, bw_share);
 	bitmask |= MODIFY_SCHEDULING_ELEMENT_IN_MODIFY_BITMASK_MAX_AVERAGE_BW;
@@ -51,7 +49,7 @@ static int esw_qos_group_config(struct mlx5_eswitch *esw, struct mlx5_esw_rate_g
 	int err;
 
 	err = esw_qos_tsar_config(dev, sched_ctx,
-				  esw->qos.root_tsar_ix, group->tsar_ix,
+				  group->tsar_ix,
 				  max_rate, bw_share);
 	if (err)
 		NL_SET_ERR_MSG_MOD(extack, "E-Switch modify group TSAR element failed");
@@ -67,23 +65,13 @@ static int esw_qos_vport_config(struct mlx5_eswitch *esw,
 				struct netlink_ext_ack *extack)
 {
 	u32 sched_ctx[MLX5_ST_SZ_DW(scheduling_context)] = {};
-	struct mlx5_esw_rate_group *group = vport->qos.group;
 	struct mlx5_core_dev *dev = esw->dev;
-	u32 parent_tsar_ix;
-	void *vport_elem;
 	int err;
 
 	if (!vport->qos.enabled)
 		return -EIO;
 
-	parent_tsar_ix = group ? group->tsar_ix : esw->qos.root_tsar_ix;
-	MLX5_SET(scheduling_context, sched_ctx, element_type,
-		 SCHEDULING_CONTEXT_ELEMENT_TYPE_VPORT);
-	vport_elem = MLX5_ADDR_OF(scheduling_context, sched_ctx,
-				  element_attributes);
-	MLX5_SET(vport_element, vport_elem, vport_number, vport->vport);
-
-	err = esw_qos_tsar_config(dev, sched_ctx, parent_tsar_ix, vport->qos.esw_tsar_ix,
+	err = esw_qos_tsar_config(dev, sched_ctx, vport->qos.esw_tsar_ix,
 				  max_rate, bw_share);
 	if (err) {
 		esw_warn(esw->dev,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 145e56f5eeee..9e15eea9743f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1849,7 +1849,7 @@ static void mlx5_core_verify_params(void)
 	}
 }
 
-static int __init init(void)
+static int __init mlx5_init(void)
 {
 	int err;
 
@@ -1885,7 +1885,7 @@ static int __init init(void)
 	return err;
 }
 
-static void __exit cleanup(void)
+static void __exit mlx5_cleanup(void)
 {
 	mlx5e_cleanup();
 	mlx5_sf_driver_unregister();
@@ -1893,5 +1893,5 @@ static void __exit cleanup(void)
 	mlx5_unregister_debugfs();
 }
 
-module_init(init);
-module_exit(cleanup);
+module_init(mlx5_init);
+module_exit(mlx5_cleanup);
diff --git a/drivers/net/ethernet/microsoft/mana/gdma.h b/drivers/net/ethernet/microsoft/mana/gdma.h
index 1038bdf28ec0..f74f416a296f 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma.h
+++ b/drivers/net/ethernet/microsoft/mana/gdma.h
@@ -324,9 +324,12 @@ struct gdma_queue_spec {
 	};
 };
 
+#define MANA_IRQ_NAME_SZ 32
+
 struct gdma_irq_context {
 	void (*handler)(void *arg);
 	void *arg;
+	char name[MANA_IRQ_NAME_SZ];
 };
 
 struct gdma_context {
diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index f577507f522b..0fb42193643d 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -1195,13 +1195,20 @@ static int mana_gd_setup_irqs(struct pci_dev *pdev)
 		gic->handler = NULL;
 		gic->arg = NULL;
 
+		if (!i)
+			snprintf(gic->name, MANA_IRQ_NAME_SZ, "mana_hwc@pci:%s",
+				 pci_name(pdev));
+		else
+			snprintf(gic->name, MANA_IRQ_NAME_SZ, "mana_q%d@pci:%s",
+				 i - 1, pci_name(pdev));
+
 		irq = pci_irq_vector(pdev, i);
 		if (irq < 0) {
 			err = irq;
 			goto free_irq;
 		}
 
-		err = request_irq(irq, mana_gd_intr, 0, "mana_intr", gic);
+		err = request_irq(irq, mana_gd_intr, 0, gic->name, gic);
 		if (err)
 			goto free_irq;
 	}
diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index 47c5377e4f42..a475f54a6b63 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -1000,8 +1000,8 @@ struct ravb_hw_info {
 	unsigned internal_delay:1;	/* AVB-DMAC has internal delays */
 	unsigned tx_counters:1;		/* E-MAC has TX counters */
 	unsigned multi_irqs:1;		/* AVB-DMAC and E-MAC has multiple irqs */
-	unsigned no_ptp_cfg_active:1;	/* AVB-DMAC does not support gPTP active in config mode */
-	unsigned ptp_cfg_active:1;	/* AVB-DMAC has gPTP support active in config mode */
+	unsigned gptp:1;		/* AVB-DMAC has gPTP support */
+	unsigned ccc_gac:1;		/* AVB-DMAC has gPTP support active in config mode */
 };
 
 struct ravb_private {
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index c89bcdd15f16..c6fe1cda7b88 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -792,14 +792,14 @@ static void ravb_error_interrupt(struct net_device *ndev)
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
 
@@ -1275,7 +1275,7 @@ static int ravb_set_ringparam(struct net_device *ndev,
 	if (netif_running(ndev)) {
 		netif_device_detach(ndev);
 		/* Stop PTP Clock driver */
-		if (info->no_ptp_cfg_active)
+		if (info->gptp)
 			ravb_ptp_stop(ndev);
 		/* Wait for DMA stopping */
 		error = ravb_stop_dma(ndev);
@@ -1307,7 +1307,7 @@ static int ravb_set_ringparam(struct net_device *ndev,
 		ravb_emac_init(ndev);
 
 		/* Initialise PTP Clock driver */
-		if (info->no_ptp_cfg_active)
+		if (info->gptp)
 			ravb_ptp_init(ndev, priv->pdev);
 
 		netif_device_attach(ndev);
@@ -1447,7 +1447,7 @@ static int ravb_open(struct net_device *ndev)
 	ravb_emac_init(ndev);
 
 	/* Initialise PTP Clock driver */
-	if (info->no_ptp_cfg_active)
+	if (info->gptp)
 		ravb_ptp_init(ndev, priv->pdev);
 
 	netif_tx_start_all_queues(ndev);
@@ -1461,7 +1461,7 @@ static int ravb_open(struct net_device *ndev)
 
 out_ptp_stop:
 	/* Stop PTP Clock driver */
-	if (info->no_ptp_cfg_active)
+	if (info->gptp)
 		ravb_ptp_stop(ndev);
 out_free_irq_nc_tx:
 	if (!info->multi_irqs)
@@ -1509,7 +1509,7 @@ static void ravb_tx_timeout_work(struct work_struct *work)
 	netif_tx_stop_all_queues(ndev);
 
 	/* Stop PTP Clock driver */
-	if (info->no_ptp_cfg_active)
+	if (info->gptp)
 		ravb_ptp_stop(ndev);
 
 	/* Wait for DMA stopping */
@@ -1544,7 +1544,7 @@ static void ravb_tx_timeout_work(struct work_struct *work)
 
 out:
 	/* Initialise PTP Clock driver */
-	if (info->no_ptp_cfg_active)
+	if (info->gptp)
 		ravb_ptp_init(ndev, priv->pdev);
 
 	netif_tx_start_all_queues(ndev);
@@ -1753,7 +1753,7 @@ static int ravb_close(struct net_device *ndev)
 	ravb_write(ndev, 0, TIC);
 
 	/* Stop PTP Clock driver */
-	if (info->no_ptp_cfg_active)
+	if (info->gptp)
 		ravb_ptp_stop(ndev);
 
 	/* Set the config mode to stop the AVB-DMAC's processes */
@@ -2019,7 +2019,7 @@ static const struct ravb_hw_info ravb_gen3_hw_info = {
 	.internal_delay = 1,
 	.tx_counters = 1,
 	.multi_irqs = 1,
-	.ptp_cfg_active = 1,
+	.ccc_gac = 1,
 };
 
 static const struct ravb_hw_info ravb_gen2_hw_info = {
@@ -2038,7 +2038,7 @@ static const struct ravb_hw_info ravb_gen2_hw_info = {
 	.stats_len = ARRAY_SIZE(ravb_gstrings_stats),
 	.max_rx_len = RX_BUF_SZ + RAVB_ALIGN - 1,
 	.aligned_tx = 1,
-	.no_ptp_cfg_active = 1,
+	.gptp = 1,
 };
 
 static const struct of_device_id ravb_match_table[] = {
@@ -2080,7 +2080,7 @@ static void ravb_set_config_mode(struct net_device *ndev)
 	struct ravb_private *priv = netdev_priv(ndev);
 	const struct ravb_hw_info *info = priv->info;
 
-	if (info->no_ptp_cfg_active) {
+	if (info->gptp) {
 		ravb_modify(ndev, CCC, CCC_OPC, CCC_OPC_CONFIG);
 		/* Set CSEL value */
 		ravb_modify(ndev, CCC, CCC_CSEL, CCC_CSEL_HPB);
@@ -2301,7 +2301,7 @@ static int ravb_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&priv->ts_skb_list);
 
 	/* Initialise PTP Clock driver */
-	if (info->ptp_cfg_active)
+	if (info->ccc_gac)
 		ravb_ptp_init(ndev, pdev);
 
 	/* Debug message level */
@@ -2349,7 +2349,7 @@ static int ravb_probe(struct platform_device *pdev)
 			  priv->desc_bat_dma);
 
 	/* Stop PTP Clock driver */
-	if (info->ptp_cfg_active)
+	if (info->ccc_gac)
 		ravb_ptp_stop(ndev);
 out_disable_refclk:
 	clk_disable_unprepare(priv->refclk);
@@ -2369,7 +2369,7 @@ static int ravb_remove(struct platform_device *pdev)
 	const struct ravb_hw_info *info = priv->info;
 
 	/* Stop PTP Clock driver */
-	if (info->ptp_cfg_active)
+	if (info->ccc_gac)
 		ravb_ptp_stop(ndev);
 
 	clk_disable_unprepare(priv->refclk);
@@ -2446,6 +2446,9 @@ static int __maybe_unused ravb_suspend(struct device *dev)
 	else
 		ret = ravb_close(ndev);
 
+	if (priv->info->ccc_gac)
+		ravb_ptp_stop(ndev);
+
 	return ret;
 }
 
@@ -2482,6 +2485,9 @@ static int __maybe_unused ravb_resume(struct device *dev)
 	/* Restore descriptor base address table */
 	ravb_write(ndev, priv->desc_bat_dma, DBAT);
 
+	if (priv->info->ccc_gac)
+		ravb_ptp_init(ndev, priv->pdev);
+
 	if (netif_running(ndev)) {
 		if (priv->wol_enabled) {
 			ret = ravb_wol_restore(ndev);
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac5.c b/drivers/net/ethernet/stmicro/stmmac/dwmac5.c
index 9c2d40f853ed..413f66017219 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac5.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac5.c
@@ -186,11 +186,25 @@ static void dwmac5_handle_dma_err(struct net_device *ndev,
 int dwmac5_safety_feat_config(void __iomem *ioaddr, unsigned int asp,
 			      struct stmmac_safety_feature_cfg *safety_feat_cfg)
 {
+	struct stmmac_safety_feature_cfg all_safety_feats = {
+		.tsoee = 1,
+		.mrxpee = 1,
+		.mestee = 1,
+		.mrxee = 1,
+		.mtxee = 1,
+		.epsi = 1,
+		.edpp = 1,
+		.prtyen = 1,
+		.tmouten = 1,
+	};
 	u32 value;
 
 	if (!asp)
 		return -EINVAL;
 
+	if (!safety_feat_cfg)
+		safety_feat_cfg = &all_safety_feats;
+
 	/* 1. Enable Safety Features */
 	value = readl(ioaddr + MTL_ECC_CONTROL);
 	value |= MEEAO; /* MTL ECC Error Addr Status Override */
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index dc31501fec8f..9e8ae4384e4f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -548,16 +548,16 @@ static void stmmac_get_per_qstats(struct stmmac_priv *priv, u64 *data)
 		p = (char *)priv + offsetof(struct stmmac_priv,
 					    xstats.txq_stats[q].tx_pkt_n);
 		for (stat = 0; stat < STMMAC_TXQ_STATS; stat++) {
-			*data++ = (*(u64 *)p);
-			p += sizeof(u64 *);
+			*data++ = (*(unsigned long *)p);
+			p += sizeof(unsigned long);
 		}
 	}
 	for (q = 0; q < rx_cnt; q++) {
 		p = (char *)priv + offsetof(struct stmmac_priv,
 					    xstats.rxq_stats[q].rx_pkt_n);
 		for (stat = 0; stat < STMMAC_RXQ_STATS; stat++) {
-			*data++ = (*(u64 *)p);
-			p += sizeof(u64 *);
+			*data++ = (*(unsigned long *)p);
+			p += sizeof(unsigned long);
 		}
 	}
 }
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 15b0daf416f3..4191502d6472 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1242,6 +1242,11 @@ static int stmmac_init_phy(struct net_device *dev)
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
diff --git a/drivers/net/ipa/ipa_interrupt.c b/drivers/net/ipa/ipa_interrupt.c
index b35170a93b0f..0c9ff8c055a0 100644
--- a/drivers/net/ipa/ipa_interrupt.c
+++ b/drivers/net/ipa/ipa_interrupt.c
@@ -122,6 +122,16 @@ static irqreturn_t ipa_isr_thread(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+void ipa_interrupt_irq_disable(struct ipa *ipa)
+{
+	disable_irq(ipa->interrupt->irq);
+}
+
+void ipa_interrupt_irq_enable(struct ipa *ipa)
+{
+	enable_irq(ipa->interrupt->irq);
+}
+
 /* Common function used to enable/disable TX_SUSPEND for an endpoint */
 static void ipa_interrupt_suspend_control(struct ipa_interrupt *interrupt,
 					  u32 endpoint_id, bool enable)
diff --git a/drivers/net/ipa/ipa_interrupt.h b/drivers/net/ipa/ipa_interrupt.h
index 231390cea52a..16aa84ee0094 100644
--- a/drivers/net/ipa/ipa_interrupt.h
+++ b/drivers/net/ipa/ipa_interrupt.h
@@ -85,6 +85,22 @@ void ipa_interrupt_suspend_clear_all(struct ipa_interrupt *interrupt);
  */
 void ipa_interrupt_simulate_suspend(struct ipa_interrupt *interrupt);
 
+/**
+ * ipa_interrupt_irq_enable() - Enable IPA interrupts
+ * @ipa:	IPA pointer
+ *
+ * This enables the IPA interrupt line
+ */
+void ipa_interrupt_irq_enable(struct ipa *ipa);
+
+/**
+ * ipa_interrupt_irq_disable() - Disable IPA interrupts
+ * @ipa:	IPA pointer
+ *
+ * This disables the IPA interrupt line
+ */
+void ipa_interrupt_irq_disable(struct ipa *ipa);
+
 /**
  * ipa_interrupt_config() - Configure the IPA interrupt framework
  * @ipa:	IPA pointer
diff --git a/drivers/net/ipa/ipa_power.c b/drivers/net/ipa/ipa_power.c
index f2989aac47a6..07fb367cfc99 100644
--- a/drivers/net/ipa/ipa_power.c
+++ b/drivers/net/ipa/ipa_power.c
@@ -277,6 +277,17 @@ static int ipa_suspend(struct device *dev)
 
 	__set_bit(IPA_POWER_FLAG_SYSTEM, ipa->power->flags);
 
+	/* Increment the disable depth to ensure that the IRQ won't
+	 * be re-enabled until the matching _enable call in
+	 * ipa_resume(). We do this to ensure that the interrupt
+	 * handler won't run whilst PM runtime is disabled.
+	 *
+	 * Note that disabling the IRQ is NOT the same as disabling
+	 * irq wake. If wakeup is enabled for the IPA then the IRQ
+	 * will still cause the system to wake up, see irq_set_irq_wake().
+	 */
+	ipa_interrupt_irq_disable(ipa);
+
 	return pm_runtime_force_suspend(dev);
 }
 
@@ -289,6 +300,12 @@ static int ipa_resume(struct device *dev)
 
 	__clear_bit(IPA_POWER_FLAG_SYSTEM, ipa->power->flags);
 
+	/* Now that PM runtime is enabled again it's safe
+	 * to turn the IRQ back on and process any data
+	 * that was received during suspend.
+	 */
+	ipa_interrupt_irq_enable(ipa);
+
 	return ret;
 }
 
diff --git a/drivers/net/mdio/mdio-mux-meson-g12a.c b/drivers/net/mdio/mdio-mux-meson-g12a.c
index b8866bc3f2e8..917c8a10eea0 100644
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
index dd7739b5f791..5f89828fd9f1 100644
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
diff --git a/drivers/net/usb/cdc_ether.c b/drivers/net/usb/cdc_ether.c
index c6b0de1b752f..3497b5a286ea 100644
--- a/drivers/net/usb/cdc_ether.c
+++ b/drivers/net/usb/cdc_ether.c
@@ -1000,6 +1000,12 @@ static const struct usb_device_id	products[] = {
 				      USB_CDC_SUBCLASS_ETHERNET,
 				      USB_CDC_PROTO_NONE),
 	.driver_info = (unsigned long)&wwan_info,
+}, {
+	/* Cinterion PLS62-W modem by GEMALTO/THALES */
+	USB_DEVICE_AND_INTERFACE_INFO(0x1e2d, 0x005b, USB_CLASS_COMM,
+				      USB_CDC_SUBCLASS_ETHERNET,
+				      USB_CDC_PROTO_NONE),
+	.driver_info = (unsigned long)&wwan_info,
 }, {
 	/* Cinterion PLS83/PLS63 modem by GEMALTO/THALES */
 	USB_DEVICE_AND_INTERFACE_INFO(0x1e2d, 0x0069, USB_CLASS_COMM,
diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 109c288d8b47..cf6941b1d280 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -9809,6 +9809,7 @@ static const struct usb_device_id rtl8152_table[] = {
 	REALTEK_USB_DEVICE(VENDOR_ID_MICROSOFT, 0x07ab),
 	REALTEK_USB_DEVICE(VENDOR_ID_MICROSOFT, 0x07c6),
 	REALTEK_USB_DEVICE(VENDOR_ID_MICROSOFT, 0x0927),
+	REALTEK_USB_DEVICE(VENDOR_ID_MICROSOFT, 0x0c5e),
 	REALTEK_USB_DEVICE(VENDOR_ID_SAMSUNG, 0xa101),
 	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x304f),
 	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3054),
diff --git a/drivers/net/usb/sr9700.c b/drivers/net/usb/sr9700.c
index 0c50f24671da..1fac6ee273c4 100644
--- a/drivers/net/usb/sr9700.c
+++ b/drivers/net/usb/sr9700.c
@@ -410,7 +410,7 @@ static int sr9700_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 		/* ignore the CRC length */
 		len = (skb->data[1] | (skb->data[2] << 8)) - 4;
 
-		if (len > ETH_FRAME_LEN || len > skb->len)
+		if (len > ETH_FRAME_LEN || len > skb->len || len < 0)
 			return 0;
 
 		/* the last packet of current skb */
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 48fb7bdc0f0b..9222be208aba 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1780,8 +1780,10 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
 	 */
 	if (sq->vq->num_free < 2+MAX_SKB_FRAGS) {
 		netif_stop_subqueue(dev, qnum);
-		if (!use_napi &&
-		    unlikely(!virtqueue_enable_cb_delayed(sq->vq))) {
+		if (use_napi) {
+			if (unlikely(!virtqueue_enable_cb_delayed(sq->vq)))
+				virtqueue_napi_schedule(&sq->napi, sq->vq);
+		} else if (unlikely(!virtqueue_enable_cb_delayed(sq->vq))) {
 			/* More just got used, free them then recheck. */
 			free_old_xmit_skbs(sq, false);
 			if (sq->vq->num_free >= 2+MAX_SKB_FRAGS) {
diff --git a/drivers/net/wan/fsl_ucc_hdlc.c b/drivers/net/wan/fsl_ucc_hdlc.c
index cda1b4ce6b21..8305df1a3008 100644
--- a/drivers/net/wan/fsl_ucc_hdlc.c
+++ b/drivers/net/wan/fsl_ucc_hdlc.c
@@ -1241,9 +1241,11 @@ static int ucc_hdlc_probe(struct platform_device *pdev)
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
index 63ce2443f136..70841d131d72 100644
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
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 672f53d5651a..06750f3d5274 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1132,7 +1132,7 @@ u32 nvme_command_effects(struct nvme_ctrl *ctrl, struct nvme_ns *ns, u8 opcode)
 	if (ns) {
 		if (ns->head->effects)
 			effects = le32_to_cpu(ns->head->effects->iocs[opcode]);
-		if (ns->head->ids.csi == NVME_CAP_CSS_NVM)
+		if (ns->head->ids.csi == NVME_CSI_NVM)
 			effects |= nvme_known_nvm_effects(opcode);
 		if (effects & ~(NVME_CMD_EFFECTS_CSUPP | NVME_CMD_EFFECTS_LBCC))
 			dev_warn_once(ctrl->device,
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 0165e65cf548..00552cd02d73 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1280,7 +1280,7 @@ static enum blk_eh_timer_return nvme_timeout(struct request *req, bool reserved)
 	else
 		nvme_poll_irqdisable(nvmeq);
 
-	if (blk_mq_request_completed(req)) {
+	if (blk_mq_rq_state(req) != MQ_RQ_IN_FLIGHT) {
 		dev_warn(dev->ctrl.device,
 			 "I/O %d QID %d timeout, completion polled\n",
 			 req->tag, nvmeq->qid);
diff --git a/drivers/phy/phy-can-transceiver.c b/drivers/phy/phy-can-transceiver.c
index c2cb93b4df71..4525d3fd903a 100644
--- a/drivers/phy/phy-can-transceiver.c
+++ b/drivers/phy/phy-can-transceiver.c
@@ -87,6 +87,7 @@ static int can_transceiver_phy_probe(struct platform_device *pdev)
 	struct gpio_desc *standby_gpio;
 	struct gpio_desc *enable_gpio;
 	u32 max_bitrate = 0;
+	int err;
 
 	can_transceiver_phy = devm_kzalloc(dev, sizeof(struct can_transceiver_phy), GFP_KERNEL);
 	if (!can_transceiver_phy)
@@ -102,8 +103,8 @@ static int can_transceiver_phy_probe(struct platform_device *pdev)
 		return PTR_ERR(phy);
 	}
 
-	device_property_read_u32(dev, "max-bitrate", &max_bitrate);
-	if (!max_bitrate)
+	err = device_property_read_u32(dev, "max-bitrate", &max_bitrate);
+	if ((err != -EINVAL) && !max_bitrate)
 		dev_warn(dev, "Invalid value for transceiver max bitrate. Ignoring bitrate limit\n");
 	phy->attrs.max_link_rate = max_bitrate;
 
diff --git a/drivers/phy/rockchip/phy-rockchip-inno-usb2.c b/drivers/phy/rockchip/phy-rockchip-inno-usb2.c
index 4f569d9307b9..c167b8c5cc86 100644
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
diff --git a/drivers/pinctrl/nuvoton/pinctrl-npcm7xx.c b/drivers/pinctrl/nuvoton/pinctrl-npcm7xx.c
index 41136f63014a..e4a0d16b58cc 100644
--- a/drivers/pinctrl/nuvoton/pinctrl-npcm7xx.c
+++ b/drivers/pinctrl/nuvoton/pinctrl-npcm7xx.c
@@ -104,12 +104,12 @@ static void npcm_gpio_set(struct gpio_chip *gc, void __iomem *reg,
 	unsigned long flags;
 	unsigned long val;
 
-	spin_lock_irqsave(&gc->bgpio_lock, flags);
+	raw_spin_lock_irqsave(&gc->bgpio_lock, flags);
 
 	val = ioread32(reg) | pinmask;
 	iowrite32(val, reg);
 
-	spin_unlock_irqrestore(&gc->bgpio_lock, flags);
+	raw_spin_unlock_irqrestore(&gc->bgpio_lock, flags);
 }
 
 static void npcm_gpio_clr(struct gpio_chip *gc, void __iomem *reg,
@@ -118,12 +118,12 @@ static void npcm_gpio_clr(struct gpio_chip *gc, void __iomem *reg,
 	unsigned long flags;
 	unsigned long val;
 
-	spin_lock_irqsave(&gc->bgpio_lock, flags);
+	raw_spin_lock_irqsave(&gc->bgpio_lock, flags);
 
 	val = ioread32(reg) & ~pinmask;
 	iowrite32(val, reg);
 
-	spin_unlock_irqrestore(&gc->bgpio_lock, flags);
+	raw_spin_unlock_irqrestore(&gc->bgpio_lock, flags);
 }
 
 static void npcmgpio_dbg_show(struct seq_file *s, struct gpio_chip *chip)
diff --git a/drivers/pinctrl/pinctrl-rockchip.c b/drivers/pinctrl/pinctrl-rockchip.c
index 25ec0d22f184..c33cbf7568db 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -285,6 +285,7 @@ static int rockchip_dt_node_to_map(struct pinctrl_dev *pctldev,
 {
 	struct rockchip_pinctrl *info = pinctrl_dev_get_drvdata(pctldev);
 	const struct rockchip_pin_group *grp;
+	struct device *dev = info->dev;
 	struct pinctrl_map *new_map;
 	struct device_node *parent;
 	int map_num = 1;
@@ -296,8 +297,7 @@ static int rockchip_dt_node_to_map(struct pinctrl_dev *pctldev,
 	 */
 	grp = pinctrl_name_to_group(info, np->name);
 	if (!grp) {
-		dev_err(info->dev, "unable to find group for node %pOFn\n",
-			np);
+		dev_err(dev, "unable to find group for node %pOFn\n", np);
 		return -EINVAL;
 	}
 
@@ -331,7 +331,7 @@ static int rockchip_dt_node_to_map(struct pinctrl_dev *pctldev,
 		new_map[i].data.configs.num_configs = grp->data[i].nconfigs;
 	}
 
-	dev_dbg(pctldev->dev, "maps: function %s group %s num %d\n",
+	dev_dbg(dev, "maps: function %s group %s num %d\n",
 		(*map)->data.mux.function, (*map)->data.mux.group, map_num);
 
 	return 0;
@@ -758,19 +758,19 @@ static struct rockchip_mux_route_data rk3568_mux_route_data[] = {
 	RK_MUXROUTE_PMU(0, RK_PB5, 4, 0x0110, WRITE_MASK_VAL(3, 2, 1)), /* PWM1 IO mux M1 */
 	RK_MUXROUTE_PMU(0, RK_PC1, 1, 0x0110, WRITE_MASK_VAL(5, 4, 0)), /* PWM2 IO mux M0 */
 	RK_MUXROUTE_PMU(0, RK_PB6, 4, 0x0110, WRITE_MASK_VAL(5, 4, 1)), /* PWM2 IO mux M1 */
-	RK_MUXROUTE_PMU(0, RK_PB3, 2, 0x0300, WRITE_MASK_VAL(0, 0, 0)), /* CAN0 IO mux M0 */
+	RK_MUXROUTE_GRF(0, RK_PB3, 2, 0x0300, WRITE_MASK_VAL(0, 0, 0)), /* CAN0 IO mux M0 */
 	RK_MUXROUTE_GRF(2, RK_PA1, 4, 0x0300, WRITE_MASK_VAL(0, 0, 1)), /* CAN0 IO mux M1 */
 	RK_MUXROUTE_GRF(1, RK_PA1, 3, 0x0300, WRITE_MASK_VAL(2, 2, 0)), /* CAN1 IO mux M0 */
 	RK_MUXROUTE_GRF(4, RK_PC3, 3, 0x0300, WRITE_MASK_VAL(2, 2, 1)), /* CAN1 IO mux M1 */
 	RK_MUXROUTE_GRF(4, RK_PB5, 3, 0x0300, WRITE_MASK_VAL(4, 4, 0)), /* CAN2 IO mux M0 */
 	RK_MUXROUTE_GRF(2, RK_PB2, 4, 0x0300, WRITE_MASK_VAL(4, 4, 1)), /* CAN2 IO mux M1 */
 	RK_MUXROUTE_GRF(4, RK_PC4, 1, 0x0300, WRITE_MASK_VAL(6, 6, 0)), /* HPDIN IO mux M0 */
-	RK_MUXROUTE_PMU(0, RK_PC2, 2, 0x0300, WRITE_MASK_VAL(6, 6, 1)), /* HPDIN IO mux M1 */
+	RK_MUXROUTE_GRF(0, RK_PC2, 2, 0x0300, WRITE_MASK_VAL(6, 6, 1)), /* HPDIN IO mux M1 */
 	RK_MUXROUTE_GRF(3, RK_PB1, 3, 0x0300, WRITE_MASK_VAL(8, 8, 0)), /* GMAC1 IO mux M0 */
 	RK_MUXROUTE_GRF(4, RK_PA7, 3, 0x0300, WRITE_MASK_VAL(8, 8, 1)), /* GMAC1 IO mux M1 */
 	RK_MUXROUTE_GRF(4, RK_PD1, 1, 0x0300, WRITE_MASK_VAL(10, 10, 0)), /* HDMITX IO mux M0 */
-	RK_MUXROUTE_PMU(0, RK_PC7, 1, 0x0300, WRITE_MASK_VAL(10, 10, 1)), /* HDMITX IO mux M1 */
-	RK_MUXROUTE_PMU(0, RK_PB6, 1, 0x0300, WRITE_MASK_VAL(14, 14, 0)), /* I2C2 IO mux M0 */
+	RK_MUXROUTE_GRF(0, RK_PC7, 1, 0x0300, WRITE_MASK_VAL(10, 10, 1)), /* HDMITX IO mux M1 */
+	RK_MUXROUTE_GRF(0, RK_PB6, 1, 0x0300, WRITE_MASK_VAL(14, 14, 0)), /* I2C2 IO mux M0 */
 	RK_MUXROUTE_GRF(4, RK_PB4, 1, 0x0300, WRITE_MASK_VAL(14, 14, 1)), /* I2C2 IO mux M1 */
 	RK_MUXROUTE_GRF(1, RK_PA0, 1, 0x0304, WRITE_MASK_VAL(0, 0, 0)), /* I2C3 IO mux M0 */
 	RK_MUXROUTE_GRF(3, RK_PB6, 4, 0x0304, WRITE_MASK_VAL(0, 0, 1)), /* I2C3 IO mux M1 */
@@ -796,7 +796,7 @@ static struct rockchip_mux_route_data rk3568_mux_route_data[] = {
 	RK_MUXROUTE_GRF(4, RK_PC3, 1, 0x0308, WRITE_MASK_VAL(12, 12, 1)), /* PWM15 IO mux M1 */
 	RK_MUXROUTE_GRF(3, RK_PD2, 3, 0x0308, WRITE_MASK_VAL(14, 14, 0)), /* SDMMC2 IO mux M0 */
 	RK_MUXROUTE_GRF(3, RK_PA5, 5, 0x0308, WRITE_MASK_VAL(14, 14, 1)), /* SDMMC2 IO mux M1 */
-	RK_MUXROUTE_PMU(0, RK_PB5, 2, 0x030c, WRITE_MASK_VAL(0, 0, 0)), /* SPI0 IO mux M0 */
+	RK_MUXROUTE_GRF(0, RK_PB5, 2, 0x030c, WRITE_MASK_VAL(0, 0, 0)), /* SPI0 IO mux M0 */
 	RK_MUXROUTE_GRF(2, RK_PD3, 3, 0x030c, WRITE_MASK_VAL(0, 0, 1)), /* SPI0 IO mux M1 */
 	RK_MUXROUTE_GRF(2, RK_PB5, 3, 0x030c, WRITE_MASK_VAL(2, 2, 0)), /* SPI1 IO mux M0 */
 	RK_MUXROUTE_GRF(3, RK_PC3, 3, 0x030c, WRITE_MASK_VAL(2, 2, 1)), /* SPI1 IO mux M1 */
@@ -805,8 +805,8 @@ static struct rockchip_mux_route_data rk3568_mux_route_data[] = {
 	RK_MUXROUTE_GRF(4, RK_PB3, 4, 0x030c, WRITE_MASK_VAL(6, 6, 0)), /* SPI3 IO mux M0 */
 	RK_MUXROUTE_GRF(4, RK_PC2, 2, 0x030c, WRITE_MASK_VAL(6, 6, 1)), /* SPI3 IO mux M1 */
 	RK_MUXROUTE_GRF(2, RK_PB4, 2, 0x030c, WRITE_MASK_VAL(8, 8, 0)), /* UART1 IO mux M0 */
-	RK_MUXROUTE_PMU(0, RK_PD1, 1, 0x030c, WRITE_MASK_VAL(8, 8, 1)), /* UART1 IO mux M1 */
-	RK_MUXROUTE_PMU(0, RK_PD1, 1, 0x030c, WRITE_MASK_VAL(10, 10, 0)), /* UART2 IO mux M0 */
+	RK_MUXROUTE_GRF(3, RK_PD6, 4, 0x030c, WRITE_MASK_VAL(8, 8, 1)), /* UART1 IO mux M1 */
+	RK_MUXROUTE_GRF(0, RK_PD1, 1, 0x030c, WRITE_MASK_VAL(10, 10, 0)), /* UART2 IO mux M0 */
 	RK_MUXROUTE_GRF(1, RK_PD5, 2, 0x030c, WRITE_MASK_VAL(10, 10, 1)), /* UART2 IO mux M1 */
 	RK_MUXROUTE_GRF(1, RK_PA1, 2, 0x030c, WRITE_MASK_VAL(12, 12, 0)), /* UART3 IO mux M0 */
 	RK_MUXROUTE_GRF(3, RK_PB7, 4, 0x030c, WRITE_MASK_VAL(12, 12, 1)), /* UART3 IO mux M1 */
@@ -836,13 +836,13 @@ static struct rockchip_mux_route_data rk3568_mux_route_data[] = {
 	RK_MUXROUTE_GRF(3, RK_PD6, 5, 0x0314, WRITE_MASK_VAL(1, 0, 1)), /* PDM IO mux M1 */
 	RK_MUXROUTE_GRF(4, RK_PA0, 4, 0x0314, WRITE_MASK_VAL(1, 0, 1)), /* PDM IO mux M1 */
 	RK_MUXROUTE_GRF(3, RK_PC4, 5, 0x0314, WRITE_MASK_VAL(1, 0, 2)), /* PDM IO mux M2 */
-	RK_MUXROUTE_PMU(0, RK_PA5, 3, 0x0314, WRITE_MASK_VAL(3, 2, 0)), /* PCIE20 IO mux M0 */
+	RK_MUXROUTE_GRF(0, RK_PA5, 3, 0x0314, WRITE_MASK_VAL(3, 2, 0)), /* PCIE20 IO mux M0 */
 	RK_MUXROUTE_GRF(2, RK_PD0, 4, 0x0314, WRITE_MASK_VAL(3, 2, 1)), /* PCIE20 IO mux M1 */
 	RK_MUXROUTE_GRF(1, RK_PB0, 4, 0x0314, WRITE_MASK_VAL(3, 2, 2)), /* PCIE20 IO mux M2 */
-	RK_MUXROUTE_PMU(0, RK_PA4, 3, 0x0314, WRITE_MASK_VAL(5, 4, 0)), /* PCIE30X1 IO mux M0 */
+	RK_MUXROUTE_GRF(0, RK_PA4, 3, 0x0314, WRITE_MASK_VAL(5, 4, 0)), /* PCIE30X1 IO mux M0 */
 	RK_MUXROUTE_GRF(2, RK_PD2, 4, 0x0314, WRITE_MASK_VAL(5, 4, 1)), /* PCIE30X1 IO mux M1 */
 	RK_MUXROUTE_GRF(1, RK_PA5, 4, 0x0314, WRITE_MASK_VAL(5, 4, 2)), /* PCIE30X1 IO mux M2 */
-	RK_MUXROUTE_PMU(0, RK_PA6, 2, 0x0314, WRITE_MASK_VAL(7, 6, 0)), /* PCIE30X2 IO mux M0 */
+	RK_MUXROUTE_GRF(0, RK_PA6, 2, 0x0314, WRITE_MASK_VAL(7, 6, 0)), /* PCIE30X2 IO mux M0 */
 	RK_MUXROUTE_GRF(2, RK_PD4, 4, 0x0314, WRITE_MASK_VAL(7, 6, 1)), /* PCIE30X2 IO mux M1 */
 	RK_MUXROUTE_GRF(4, RK_PC2, 4, 0x0314, WRITE_MASK_VAL(7, 6, 2)), /* PCIE30X2 IO mux M2 */
 };
@@ -927,20 +927,20 @@ static int rockchip_verify_mux(struct rockchip_pin_bank *bank,
 			       int pin, int mux)
 {
 	struct rockchip_pinctrl *info = bank->drvdata;
+	struct device *dev = info->dev;
 	int iomux_num = (pin / 8);
 
 	if (iomux_num > 3)
 		return -EINVAL;
 
 	if (bank->iomux[iomux_num].type & IOMUX_UNROUTED) {
-		dev_err(info->dev, "pin %d is unrouted\n", pin);
+		dev_err(dev, "pin %d is unrouted\n", pin);
 		return -EINVAL;
 	}
 
 	if (bank->iomux[iomux_num].type & IOMUX_GPIO_ONLY) {
 		if (mux != RK_FUNC_GPIO) {
-			dev_err(info->dev,
-				"pin %d only supports a gpio mux\n", pin);
+			dev_err(dev, "pin %d only supports a gpio mux\n", pin);
 			return -ENOTSUPP;
 		}
 	}
@@ -964,6 +964,7 @@ static int rockchip_verify_mux(struct rockchip_pin_bank *bank,
 static int rockchip_set_mux(struct rockchip_pin_bank *bank, int pin, int mux)
 {
 	struct rockchip_pinctrl *info = bank->drvdata;
+	struct device *dev = info->dev;
 	int iomux_num = (pin / 8);
 	struct regmap *regmap;
 	int reg, ret, mask, mux_type;
@@ -977,8 +978,7 @@ static int rockchip_set_mux(struct rockchip_pin_bank *bank, int pin, int mux)
 	if (bank->iomux[iomux_num].type & IOMUX_GPIO_ONLY)
 		return 0;
 
-	dev_dbg(info->dev, "setting mux of GPIO%d-%d to %d\n",
-						bank->bank_num, pin, mux);
+	dev_dbg(dev, "setting mux of GPIO%d-%d to %d\n", bank->bank_num, pin, mux);
 
 	regmap = (bank->iomux[iomux_num].type & IOMUX_SOURCE_PMU)
 				? info->regmap_pmu : info->regmap_base;
@@ -1039,9 +1039,9 @@ static int rockchip_set_mux(struct rockchip_pin_bank *bank, int pin, int mux)
 #define PX30_PULL_PINS_PER_REG		8
 #define PX30_PULL_BANK_STRIDE		16
 
-static void px30_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
-				       int pin_num, struct regmap **regmap,
-				       int *reg, u8 *bit)
+static int px30_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
+				      int pin_num, struct regmap **regmap,
+				      int *reg, u8 *bit)
 {
 	struct rockchip_pinctrl *info = bank->drvdata;
 
@@ -1061,6 +1061,8 @@ static void px30_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
 	*reg += ((pin_num / PX30_PULL_PINS_PER_REG) * 4);
 	*bit = (pin_num % PX30_PULL_PINS_PER_REG);
 	*bit *= PX30_PULL_BITS_PER_PIN;
+
+	return 0;
 }
 
 #define PX30_DRV_PMU_OFFSET		0x20
@@ -1069,9 +1071,9 @@ static void px30_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
 #define PX30_DRV_PINS_PER_REG		8
 #define PX30_DRV_BANK_STRIDE		16
 
-static void px30_calc_drv_reg_and_bit(struct rockchip_pin_bank *bank,
-				      int pin_num, struct regmap **regmap,
-				      int *reg, u8 *bit)
+static int px30_calc_drv_reg_and_bit(struct rockchip_pin_bank *bank,
+				     int pin_num, struct regmap **regmap,
+				     int *reg, u8 *bit)
 {
 	struct rockchip_pinctrl *info = bank->drvdata;
 
@@ -1091,6 +1093,8 @@ static void px30_calc_drv_reg_and_bit(struct rockchip_pin_bank *bank,
 	*reg += ((pin_num / PX30_DRV_PINS_PER_REG) * 4);
 	*bit = (pin_num % PX30_DRV_PINS_PER_REG);
 	*bit *= PX30_DRV_BITS_PER_PIN;
+
+	return 0;
 }
 
 #define PX30_SCHMITT_PMU_OFFSET			0x38
@@ -1130,9 +1134,9 @@ static int px30_calc_schmitt_reg_and_bit(struct rockchip_pin_bank *bank,
 #define RV1108_PULL_BITS_PER_PIN	2
 #define RV1108_PULL_BANK_STRIDE		16
 
-static void rv1108_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
-					 int pin_num, struct regmap **regmap,
-					 int *reg, u8 *bit)
+static int rv1108_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
+					int pin_num, struct regmap **regmap,
+					int *reg, u8 *bit)
 {
 	struct rockchip_pinctrl *info = bank->drvdata;
 
@@ -1151,6 +1155,8 @@ static void rv1108_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
 	*reg += ((pin_num / RV1108_PULL_PINS_PER_REG) * 4);
 	*bit = (pin_num % RV1108_PULL_PINS_PER_REG);
 	*bit *= RV1108_PULL_BITS_PER_PIN;
+
+	return 0;
 }
 
 #define RV1108_DRV_PMU_OFFSET		0x20
@@ -1159,9 +1165,9 @@ static void rv1108_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
 #define RV1108_DRV_PINS_PER_REG		8
 #define RV1108_DRV_BANK_STRIDE		16
 
-static void rv1108_calc_drv_reg_and_bit(struct rockchip_pin_bank *bank,
-					int pin_num, struct regmap **regmap,
-					int *reg, u8 *bit)
+static int rv1108_calc_drv_reg_and_bit(struct rockchip_pin_bank *bank,
+				       int pin_num, struct regmap **regmap,
+				       int *reg, u8 *bit)
 {
 	struct rockchip_pinctrl *info = bank->drvdata;
 
@@ -1181,6 +1187,8 @@ static void rv1108_calc_drv_reg_and_bit(struct rockchip_pin_bank *bank,
 	*reg += ((pin_num / RV1108_DRV_PINS_PER_REG) * 4);
 	*bit = pin_num % RV1108_DRV_PINS_PER_REG;
 	*bit *= RV1108_DRV_BITS_PER_PIN;
+
+	return 0;
 }
 
 #define RV1108_SCHMITT_PMU_OFFSET		0x30
@@ -1237,9 +1245,9 @@ static int rk3308_calc_schmitt_reg_and_bit(struct rockchip_pin_bank *bank,
 #define RK2928_PULL_PINS_PER_REG	16
 #define RK2928_PULL_BANK_STRIDE		8
 
-static void rk2928_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
-				    int pin_num, struct regmap **regmap,
-				    int *reg, u8 *bit)
+static int rk2928_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
+					int pin_num, struct regmap **regmap,
+					int *reg, u8 *bit)
 {
 	struct rockchip_pinctrl *info = bank->drvdata;
 
@@ -1249,13 +1257,15 @@ static void rk2928_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
 	*reg += (pin_num / RK2928_PULL_PINS_PER_REG) * 4;
 
 	*bit = pin_num % RK2928_PULL_PINS_PER_REG;
+
+	return 0;
 };
 
 #define RK3128_PULL_OFFSET	0x118
 
-static void rk3128_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
-					 int pin_num, struct regmap **regmap,
-					 int *reg, u8 *bit)
+static int rk3128_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
+					int pin_num, struct regmap **regmap,
+					int *reg, u8 *bit)
 {
 	struct rockchip_pinctrl *info = bank->drvdata;
 
@@ -1265,6 +1275,8 @@ static void rk3128_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
 	*reg += ((pin_num / RK2928_PULL_PINS_PER_REG) * 4);
 
 	*bit = pin_num % RK2928_PULL_PINS_PER_REG;
+
+	return 0;
 }
 
 #define RK3188_PULL_OFFSET		0x164
@@ -1273,9 +1285,9 @@ static void rk3128_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
 #define RK3188_PULL_BANK_STRIDE		16
 #define RK3188_PULL_PMU_OFFSET		0x64
 
-static void rk3188_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
-				    int pin_num, struct regmap **regmap,
-				    int *reg, u8 *bit)
+static int rk3188_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
+					int pin_num, struct regmap **regmap,
+					int *reg, u8 *bit)
 {
 	struct rockchip_pinctrl *info = bank->drvdata;
 
@@ -1305,12 +1317,14 @@ static void rk3188_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
 		*bit = 7 - (pin_num % RK3188_PULL_PINS_PER_REG);
 		*bit *= RK3188_PULL_BITS_PER_PIN;
 	}
+
+	return 0;
 }
 
 #define RK3288_PULL_OFFSET		0x140
-static void rk3288_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
-				    int pin_num, struct regmap **regmap,
-				    int *reg, u8 *bit)
+static int rk3288_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
+					int pin_num, struct regmap **regmap,
+					int *reg, u8 *bit)
 {
 	struct rockchip_pinctrl *info = bank->drvdata;
 
@@ -1334,6 +1348,8 @@ static void rk3288_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
 		*bit = (pin_num % RK3188_PULL_PINS_PER_REG);
 		*bit *= RK3188_PULL_BITS_PER_PIN;
 	}
+
+	return 0;
 }
 
 #define RK3288_DRV_PMU_OFFSET		0x70
@@ -1342,9 +1358,9 @@ static void rk3288_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
 #define RK3288_DRV_PINS_PER_REG		8
 #define RK3288_DRV_BANK_STRIDE		16
 
-static void rk3288_calc_drv_reg_and_bit(struct rockchip_pin_bank *bank,
-				    int pin_num, struct regmap **regmap,
-				    int *reg, u8 *bit)
+static int rk3288_calc_drv_reg_and_bit(struct rockchip_pin_bank *bank,
+				       int pin_num, struct regmap **regmap,
+				       int *reg, u8 *bit)
 {
 	struct rockchip_pinctrl *info = bank->drvdata;
 
@@ -1368,13 +1384,15 @@ static void rk3288_calc_drv_reg_and_bit(struct rockchip_pin_bank *bank,
 		*bit = (pin_num % RK3288_DRV_PINS_PER_REG);
 		*bit *= RK3288_DRV_BITS_PER_PIN;
 	}
+
+	return 0;
 }
 
 #define RK3228_PULL_OFFSET		0x100
 
-static void rk3228_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
-				    int pin_num, struct regmap **regmap,
-				    int *reg, u8 *bit)
+static int rk3228_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
+					int pin_num, struct regmap **regmap,
+					int *reg, u8 *bit)
 {
 	struct rockchip_pinctrl *info = bank->drvdata;
 
@@ -1385,13 +1403,15 @@ static void rk3228_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
 
 	*bit = (pin_num % RK3188_PULL_PINS_PER_REG);
 	*bit *= RK3188_PULL_BITS_PER_PIN;
+
+	return 0;
 }
 
 #define RK3228_DRV_GRF_OFFSET		0x200
 
-static void rk3228_calc_drv_reg_and_bit(struct rockchip_pin_bank *bank,
-				    int pin_num, struct regmap **regmap,
-				    int *reg, u8 *bit)
+static int rk3228_calc_drv_reg_and_bit(struct rockchip_pin_bank *bank,
+				       int pin_num, struct regmap **regmap,
+				       int *reg, u8 *bit)
 {
 	struct rockchip_pinctrl *info = bank->drvdata;
 
@@ -1402,13 +1422,15 @@ static void rk3228_calc_drv_reg_and_bit(struct rockchip_pin_bank *bank,
 
 	*bit = (pin_num % RK3288_DRV_PINS_PER_REG);
 	*bit *= RK3288_DRV_BITS_PER_PIN;
+
+	return 0;
 }
 
 #define RK3308_PULL_OFFSET		0xa0
 
-static void rk3308_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
-				    int pin_num, struct regmap **regmap,
-				    int *reg, u8 *bit)
+static int rk3308_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
+					int pin_num, struct regmap **regmap,
+					int *reg, u8 *bit)
 {
 	struct rockchip_pinctrl *info = bank->drvdata;
 
@@ -1419,13 +1441,15 @@ static void rk3308_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
 
 	*bit = (pin_num % RK3188_PULL_PINS_PER_REG);
 	*bit *= RK3188_PULL_BITS_PER_PIN;
+
+	return 0;
 }
 
 #define RK3308_DRV_GRF_OFFSET		0x100
 
-static void rk3308_calc_drv_reg_and_bit(struct rockchip_pin_bank *bank,
-				    int pin_num, struct regmap **regmap,
-				    int *reg, u8 *bit)
+static int rk3308_calc_drv_reg_and_bit(struct rockchip_pin_bank *bank,
+				       int pin_num, struct regmap **regmap,
+				       int *reg, u8 *bit)
 {
 	struct rockchip_pinctrl *info = bank->drvdata;
 
@@ -1436,14 +1460,16 @@ static void rk3308_calc_drv_reg_and_bit(struct rockchip_pin_bank *bank,
 
 	*bit = (pin_num % RK3288_DRV_PINS_PER_REG);
 	*bit *= RK3288_DRV_BITS_PER_PIN;
+
+	return 0;
 }
 
 #define RK3368_PULL_GRF_OFFSET		0x100
 #define RK3368_PULL_PMU_OFFSET		0x10
 
-static void rk3368_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
-				    int pin_num, struct regmap **regmap,
-				    int *reg, u8 *bit)
+static int rk3368_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
+					int pin_num, struct regmap **regmap,
+					int *reg, u8 *bit)
 {
 	struct rockchip_pinctrl *info = bank->drvdata;
 
@@ -1467,14 +1493,16 @@ static void rk3368_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
 		*bit = (pin_num % RK3188_PULL_PINS_PER_REG);
 		*bit *= RK3188_PULL_BITS_PER_PIN;
 	}
+
+	return 0;
 }
 
 #define RK3368_DRV_PMU_OFFSET		0x20
 #define RK3368_DRV_GRF_OFFSET		0x200
 
-static void rk3368_calc_drv_reg_and_bit(struct rockchip_pin_bank *bank,
-				    int pin_num, struct regmap **regmap,
-				    int *reg, u8 *bit)
+static int rk3368_calc_drv_reg_and_bit(struct rockchip_pin_bank *bank,
+				       int pin_num, struct regmap **regmap,
+				       int *reg, u8 *bit)
 {
 	struct rockchip_pinctrl *info = bank->drvdata;
 
@@ -1498,15 +1526,17 @@ static void rk3368_calc_drv_reg_and_bit(struct rockchip_pin_bank *bank,
 		*bit = (pin_num % RK3288_DRV_PINS_PER_REG);
 		*bit *= RK3288_DRV_BITS_PER_PIN;
 	}
+
+	return 0;
 }
 
 #define RK3399_PULL_GRF_OFFSET		0xe040
 #define RK3399_PULL_PMU_OFFSET		0x40
 #define RK3399_DRV_3BITS_PER_PIN	3
 
-static void rk3399_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
-					 int pin_num, struct regmap **regmap,
-					 int *reg, u8 *bit)
+static int rk3399_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
+					int pin_num, struct regmap **regmap,
+					int *reg, u8 *bit)
 {
 	struct rockchip_pinctrl *info = bank->drvdata;
 
@@ -1532,11 +1562,13 @@ static void rk3399_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
 		*bit = (pin_num % RK3188_PULL_PINS_PER_REG);
 		*bit *= RK3188_PULL_BITS_PER_PIN;
 	}
+
+	return 0;
 }
 
-static void rk3399_calc_drv_reg_and_bit(struct rockchip_pin_bank *bank,
-					int pin_num, struct regmap **regmap,
-					int *reg, u8 *bit)
+static int rk3399_calc_drv_reg_and_bit(struct rockchip_pin_bank *bank,
+				       int pin_num, struct regmap **regmap,
+				       int *reg, u8 *bit)
 {
 	struct rockchip_pinctrl *info = bank->drvdata;
 	int drv_num = (pin_num / 8);
@@ -1553,6 +1585,8 @@ static void rk3399_calc_drv_reg_and_bit(struct rockchip_pin_bank *bank,
 		*bit = (pin_num % 8) * 3;
 	else
 		*bit = (pin_num % 8) * 2;
+
+	return 0;
 }
 
 #define RK3568_PULL_PMU_OFFSET		0x20
@@ -1561,9 +1595,9 @@ static void rk3399_calc_drv_reg_and_bit(struct rockchip_pin_bank *bank,
 #define RK3568_PULL_PINS_PER_REG	8
 #define RK3568_PULL_BANK_STRIDE		0x10
 
-static void rk3568_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
-					 int pin_num, struct regmap **regmap,
-					 int *reg, u8 *bit)
+static int rk3568_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
+					int pin_num, struct regmap **regmap,
+					int *reg, u8 *bit)
 {
 	struct rockchip_pinctrl *info = bank->drvdata;
 
@@ -1584,6 +1618,8 @@ static void rk3568_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
 		*bit = (pin_num % RK3568_PULL_PINS_PER_REG);
 		*bit *= RK3568_PULL_BITS_PER_PIN;
 	}
+
+	return 0;
 }
 
 #define RK3568_DRV_PMU_OFFSET		0x70
@@ -1592,9 +1628,9 @@ static void rk3568_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
 #define RK3568_DRV_PINS_PER_REG		2
 #define RK3568_DRV_BANK_STRIDE		0x40
 
-static void rk3568_calc_drv_reg_and_bit(struct rockchip_pin_bank *bank,
-					int pin_num, struct regmap **regmap,
-					int *reg, u8 *bit)
+static int rk3568_calc_drv_reg_and_bit(struct rockchip_pin_bank *bank,
+				       int pin_num, struct regmap **regmap,
+				       int *reg, u8 *bit)
 {
 	struct rockchip_pinctrl *info = bank->drvdata;
 
@@ -1615,6 +1651,8 @@ static void rk3568_calc_drv_reg_and_bit(struct rockchip_pin_bank *bank,
 		*bit = (pin_num % RK3568_DRV_PINS_PER_REG);
 		*bit *= RK3568_DRV_BITS_PER_PIN;
 	}
+
+	return 0;
 }
 
 static int rockchip_perpin_drv_list[DRV_TYPE_MAX][8] = {
@@ -1630,13 +1668,16 @@ static int rockchip_get_drive_perpin(struct rockchip_pin_bank *bank,
 {
 	struct rockchip_pinctrl *info = bank->drvdata;
 	struct rockchip_pin_ctrl *ctrl = info->ctrl;
+	struct device *dev = info->dev;
 	struct regmap *regmap;
 	int reg, ret;
 	u32 data, temp, rmask_bits;
 	u8 bit;
 	int drv_type = bank->drv[pin_num / 8].drv_type;
 
-	ctrl->drv_calc_reg(bank, pin_num, &regmap, &reg, &bit);
+	ret = ctrl->drv_calc_reg(bank, pin_num, &regmap, &reg, &bit);
+	if (ret)
+		return ret;
 
 	switch (drv_type) {
 	case DRV_TYPE_IO_1V8_3V0_AUTO:
@@ -1675,7 +1716,7 @@ static int rockchip_get_drive_perpin(struct rockchip_pin_bank *bank,
 			bit -= 16;
 			break;
 		default:
-			dev_err(info->dev, "unsupported bit: %d for pinctrl drive type: %d\n",
+			dev_err(dev, "unsupported bit: %d for pinctrl drive type: %d\n",
 				bit, drv_type);
 			return -EINVAL;
 		}
@@ -1687,8 +1728,7 @@ static int rockchip_get_drive_perpin(struct rockchip_pin_bank *bank,
 		rmask_bits = RK3288_DRV_BITS_PER_PIN;
 		break;
 	default:
-		dev_err(info->dev, "unsupported pinctrl drive type: %d\n",
-			drv_type);
+		dev_err(dev, "unsupported pinctrl drive type: %d\n", drv_type);
 		return -EINVAL;
 	}
 
@@ -1707,16 +1747,19 @@ static int rockchip_set_drive_perpin(struct rockchip_pin_bank *bank,
 {
 	struct rockchip_pinctrl *info = bank->drvdata;
 	struct rockchip_pin_ctrl *ctrl = info->ctrl;
+	struct device *dev = info->dev;
 	struct regmap *regmap;
 	int reg, ret, i;
 	u32 data, rmask, rmask_bits, temp;
 	u8 bit;
 	int drv_type = bank->drv[pin_num / 8].drv_type;
 
-	dev_dbg(info->dev, "setting drive of GPIO%d-%d to %d\n",
+	dev_dbg(dev, "setting drive of GPIO%d-%d to %d\n",
 		bank->bank_num, pin_num, strength);
 
-	ctrl->drv_calc_reg(bank, pin_num, &regmap, &reg, &bit);
+	ret = ctrl->drv_calc_reg(bank, pin_num, &regmap, &reg, &bit);
+	if (ret)
+		return ret;
 	if (ctrl->type == RK3568) {
 		rmask_bits = RK3568_DRV_BITS_PER_PIN;
 		ret = (1 << (strength + 1)) - 1;
@@ -1735,8 +1778,7 @@ static int rockchip_set_drive_perpin(struct rockchip_pin_bank *bank,
 	}
 
 	if (ret < 0) {
-		dev_err(info->dev, "unsupported driver strength %d\n",
-			strength);
+		dev_err(dev, "unsupported driver strength %d\n", strength);
 		return ret;
 	}
 
@@ -1775,7 +1817,7 @@ static int rockchip_set_drive_perpin(struct rockchip_pin_bank *bank,
 			bit -= 16;
 			break;
 		default:
-			dev_err(info->dev, "unsupported bit: %d for pinctrl drive type: %d\n",
+			dev_err(dev, "unsupported bit: %d for pinctrl drive type: %d\n",
 				bit, drv_type);
 			return -EINVAL;
 		}
@@ -1786,8 +1828,7 @@ static int rockchip_set_drive_perpin(struct rockchip_pin_bank *bank,
 		rmask_bits = RK3288_DRV_BITS_PER_PIN;
 		break;
 	default:
-		dev_err(info->dev, "unsupported pinctrl drive type: %d\n",
-			drv_type);
+		dev_err(dev, "unsupported pinctrl drive type: %d\n", drv_type);
 		return -EINVAL;
 	}
 
@@ -1821,6 +1862,7 @@ static int rockchip_get_pull(struct rockchip_pin_bank *bank, int pin_num)
 {
 	struct rockchip_pinctrl *info = bank->drvdata;
 	struct rockchip_pin_ctrl *ctrl = info->ctrl;
+	struct device *dev = info->dev;
 	struct regmap *regmap;
 	int reg, ret, pull_type;
 	u8 bit;
@@ -1830,7 +1872,9 @@ static int rockchip_get_pull(struct rockchip_pin_bank *bank, int pin_num)
 	if (ctrl->type == RK3066B)
 		return PIN_CONFIG_BIAS_DISABLE;
 
-	ctrl->pull_calc_reg(bank, pin_num, &regmap, &reg, &bit);
+	ret = ctrl->pull_calc_reg(bank, pin_num, &regmap, &reg, &bit);
+	if (ret)
+		return ret;
 
 	ret = regmap_read(regmap, reg, &data);
 	if (ret)
@@ -1849,13 +1893,22 @@ static int rockchip_get_pull(struct rockchip_pin_bank *bank, int pin_num)
 	case RK3308:
 	case RK3368:
 	case RK3399:
+	case RK3568:
 		pull_type = bank->pull_type[pin_num / 8];
 		data >>= bit;
 		data &= (1 << RK3188_PULL_BITS_PER_PIN) - 1;
+		/*
+		 * In the TRM, pull-up being 1 for everything except the GPIO0_D3-D6,
+		 * where that pull up value becomes 3.
+		 */
+		if (ctrl->type == RK3568 && bank->bank_num == 0 && pin_num >= 27 && pin_num <= 30) {
+			if (data == 3)
+				data = 1;
+		}
 
 		return rockchip_pull_list[pull_type][data];
 	default:
-		dev_err(info->dev, "unsupported pinctrl type\n");
+		dev_err(dev, "unsupported pinctrl type\n");
 		return -EINVAL;
 	};
 }
@@ -1865,19 +1918,21 @@ static int rockchip_set_pull(struct rockchip_pin_bank *bank,
 {
 	struct rockchip_pinctrl *info = bank->drvdata;
 	struct rockchip_pin_ctrl *ctrl = info->ctrl;
+	struct device *dev = info->dev;
 	struct regmap *regmap;
 	int reg, ret, i, pull_type;
 	u8 bit;
 	u32 data, rmask;
 
-	dev_dbg(info->dev, "setting pull of GPIO%d-%d to %d\n",
-		 bank->bank_num, pin_num, pull);
+	dev_dbg(dev, "setting pull of GPIO%d-%d to %d\n", bank->bank_num, pin_num, pull);
 
 	/* rk3066b does support any pulls */
 	if (ctrl->type == RK3066B)
 		return pull ? -EINVAL : 0;
 
-	ctrl->pull_calc_reg(bank, pin_num, &regmap, &reg, &bit);
+	ret = ctrl->pull_calc_reg(bank, pin_num, &regmap, &reg, &bit);
+	if (ret)
+		return ret;
 
 	switch (ctrl->type) {
 	case RK2928:
@@ -1905,7 +1960,7 @@ static int rockchip_set_pull(struct rockchip_pin_bank *bank,
 			}
 		}
 		/*
-		 * In the TRM, pull-up being 1 for everything except the GPIO0_D0-D6,
+		 * In the TRM, pull-up being 1 for everything except the GPIO0_D3-D6,
 		 * where that pull up value becomes 3.
 		 */
 		if (ctrl->type == RK3568 && bank->bank_num == 0 && pin_num >= 27 && pin_num <= 30) {
@@ -1914,8 +1969,7 @@ static int rockchip_set_pull(struct rockchip_pin_bank *bank,
 		}
 
 		if (ret < 0) {
-			dev_err(info->dev, "unsupported pull setting %d\n",
-				pull);
+			dev_err(dev, "unsupported pull setting %d\n", pull);
 			return ret;
 		}
 
@@ -1927,7 +1981,7 @@ static int rockchip_set_pull(struct rockchip_pin_bank *bank,
 		ret = regmap_update_bits(regmap, reg, rmask, data);
 		break;
 	default:
-		dev_err(info->dev, "unsupported pinctrl type\n");
+		dev_err(dev, "unsupported pinctrl type\n");
 		return -EINVAL;
 	}
 
@@ -2018,12 +2072,13 @@ static int rockchip_set_schmitt(struct rockchip_pin_bank *bank,
 {
 	struct rockchip_pinctrl *info = bank->drvdata;
 	struct rockchip_pin_ctrl *ctrl = info->ctrl;
+	struct device *dev = info->dev;
 	struct regmap *regmap;
 	int reg, ret;
 	u8 bit;
 	u32 data, rmask;
 
-	dev_dbg(info->dev, "setting input schmitt of GPIO%d-%d to %d\n",
+	dev_dbg(dev, "setting input schmitt of GPIO%d-%d to %d\n",
 		bank->bank_num, pin_num, enable);
 
 	ret = ctrl->schmitt_calc_reg(bank, pin_num, &regmap, &reg, &bit);
@@ -2083,10 +2138,11 @@ static int rockchip_pmx_set(struct pinctrl_dev *pctldev, unsigned selector,
 	struct rockchip_pinctrl *info = pinctrl_dev_get_drvdata(pctldev);
 	const unsigned int *pins = info->groups[group].pins;
 	const struct rockchip_pin_config *data = info->groups[group].data;
+	struct device *dev = info->dev;
 	struct rockchip_pin_bank *bank;
 	int cnt, ret = 0;
 
-	dev_dbg(info->dev, "enable function %s group %s\n",
+	dev_dbg(dev, "enable function %s group %s\n",
 		info->functions[selector].name, info->groups[group].name);
 
 	/*
@@ -2392,6 +2448,7 @@ static int rockchip_pinctrl_parse_groups(struct device_node *np,
 					      struct rockchip_pinctrl *info,
 					      u32 index)
 {
+	struct device *dev = info->dev;
 	struct rockchip_pin_bank *bank;
 	int size;
 	const __be32 *list;
@@ -2399,7 +2456,7 @@ static int rockchip_pinctrl_parse_groups(struct device_node *np,
 	int i, j;
 	int ret;
 
-	dev_dbg(info->dev, "group(%d): %pOFn\n", index, np);
+	dev_dbg(dev, "group(%d): %pOFn\n", index, np);
 
 	/* Initialise group */
 	grp->name = np->name;
@@ -2412,18 +2469,14 @@ static int rockchip_pinctrl_parse_groups(struct device_node *np,
 	/* we do not check return since it's safe node passed down */
 	size /= sizeof(*list);
 	if (!size || size % 4) {
-		dev_err(info->dev, "wrong pins number or pins and configs should be by 4\n");
+		dev_err(dev, "wrong pins number or pins and configs should be by 4\n");
 		return -EINVAL;
 	}
 
 	grp->npins = size / 4;
 
-	grp->pins = devm_kcalloc(info->dev, grp->npins, sizeof(unsigned int),
-						GFP_KERNEL);
-	grp->data = devm_kcalloc(info->dev,
-					grp->npins,
-					sizeof(struct rockchip_pin_config),
-					GFP_KERNEL);
+	grp->pins = devm_kcalloc(dev, grp->npins, sizeof(*grp->pins), GFP_KERNEL);
+	grp->data = devm_kcalloc(dev, grp->npins, sizeof(*grp->data), GFP_KERNEL);
 	if (!grp->pins || !grp->data)
 		return -ENOMEM;
 
@@ -2457,6 +2510,7 @@ static int rockchip_pinctrl_parse_functions(struct device_node *np,
 						struct rockchip_pinctrl *info,
 						u32 index)
 {
+	struct device *dev = info->dev;
 	struct device_node *child;
 	struct rockchip_pmx_func *func;
 	struct rockchip_pin_group *grp;
@@ -2464,7 +2518,7 @@ static int rockchip_pinctrl_parse_functions(struct device_node *np,
 	static u32 grp_index;
 	u32 i = 0;
 
-	dev_dbg(info->dev, "parse function(%d): %pOFn\n", index, np);
+	dev_dbg(dev, "parse function(%d): %pOFn\n", index, np);
 
 	func = &info->functions[index];
 
@@ -2474,8 +2528,7 @@ static int rockchip_pinctrl_parse_functions(struct device_node *np,
 	if (func->ngroups <= 0)
 		return 0;
 
-	func->groups = devm_kcalloc(info->dev,
-			func->ngroups, sizeof(char *), GFP_KERNEL);
+	func->groups = devm_kcalloc(dev, func->ngroups, sizeof(*func->groups), GFP_KERNEL);
 	if (!func->groups)
 		return -ENOMEM;
 
@@ -2503,20 +2556,14 @@ static int rockchip_pinctrl_parse_dt(struct platform_device *pdev,
 
 	rockchip_pinctrl_child_count(info, np);
 
-	dev_dbg(&pdev->dev, "nfunctions = %d\n", info->nfunctions);
-	dev_dbg(&pdev->dev, "ngroups = %d\n", info->ngroups);
+	dev_dbg(dev, "nfunctions = %d\n", info->nfunctions);
+	dev_dbg(dev, "ngroups = %d\n", info->ngroups);
 
-	info->functions = devm_kcalloc(dev,
-					      info->nfunctions,
-					      sizeof(struct rockchip_pmx_func),
-					      GFP_KERNEL);
+	info->functions = devm_kcalloc(dev, info->nfunctions, sizeof(*info->functions), GFP_KERNEL);
 	if (!info->functions)
 		return -ENOMEM;
 
-	info->groups = devm_kcalloc(dev,
-					    info->ngroups,
-					    sizeof(struct rockchip_pin_group),
-					    GFP_KERNEL);
+	info->groups = devm_kcalloc(dev, info->ngroups, sizeof(*info->groups), GFP_KERNEL);
 	if (!info->groups)
 		return -ENOMEM;
 
@@ -2528,7 +2575,7 @@ static int rockchip_pinctrl_parse_dt(struct platform_device *pdev,
 
 		ret = rockchip_pinctrl_parse_functions(child, info, i++);
 		if (ret) {
-			dev_err(&pdev->dev, "failed to parse function\n");
+			dev_err(dev, "failed to parse function\n");
 			of_node_put(child);
 			return ret;
 		}
@@ -2543,6 +2590,7 @@ static int rockchip_pinctrl_register(struct platform_device *pdev,
 	struct pinctrl_desc *ctrldesc = &info->pctl;
 	struct pinctrl_pin_desc *pindesc, *pdesc;
 	struct rockchip_pin_bank *pin_bank;
+	struct device *dev = &pdev->dev;
 	int pin, bank, ret;
 	int k;
 
@@ -2552,9 +2600,7 @@ static int rockchip_pinctrl_register(struct platform_device *pdev,
 	ctrldesc->pmxops = &rockchip_pmx_ops;
 	ctrldesc->confops = &rockchip_pinconf_ops;
 
-	pindesc = devm_kcalloc(&pdev->dev,
-			       info->ctrl->nr_pins, sizeof(*pindesc),
-			       GFP_KERNEL);
+	pindesc = devm_kcalloc(dev, info->ctrl->nr_pins, sizeof(*pindesc), GFP_KERNEL);
 	if (!pindesc)
 		return -ENOMEM;
 
@@ -2579,9 +2625,9 @@ static int rockchip_pinctrl_register(struct platform_device *pdev,
 	if (ret)
 		return ret;
 
-	info->pctl_dev = devm_pinctrl_register(&pdev->dev, ctrldesc, info);
+	info->pctl_dev = devm_pinctrl_register(dev, ctrldesc, info);
 	if (IS_ERR(info->pctl_dev)) {
-		dev_err(&pdev->dev, "could not register pinctrl driver\n");
+		dev_err(dev, "could not register pinctrl driver\n");
 		return PTR_ERR(info->pctl_dev);
 	}
 
@@ -2595,8 +2641,9 @@ static struct rockchip_pin_ctrl *rockchip_pinctrl_get_soc_data(
 						struct rockchip_pinctrl *d,
 						struct platform_device *pdev)
 {
+	struct device *dev = &pdev->dev;
+	struct device_node *node = dev->of_node;
 	const struct of_device_id *match;
-	struct device_node *node = pdev->dev.of_node;
 	struct rockchip_pin_ctrl *ctrl;
 	struct rockchip_pin_bank *bank;
 	int grf_offs, pmu_offs, drv_grf_offs, drv_pmu_offs, i, j;
@@ -2648,7 +2695,7 @@ static struct rockchip_pin_ctrl *rockchip_pinctrl_get_soc_data(
 						drv_pmu_offs : drv_grf_offs;
 			}
 
-			dev_dbg(d->dev, "bank %d, iomux %d has iom_offset 0x%x drv_offset 0x%x\n",
+			dev_dbg(dev, "bank %d, iomux %d has iom_offset 0x%x drv_offset 0x%x\n",
 				i, j, iom->offset, drv->offset);
 
 			/*
@@ -2757,8 +2804,8 @@ static int rockchip_pinctrl_probe(struct platform_device *pdev)
 {
 	struct rockchip_pinctrl *info;
 	struct device *dev = &pdev->dev;
+	struct device_node *np = dev->of_node, *node;
 	struct rockchip_pin_ctrl *ctrl;
-	struct device_node *np = pdev->dev.of_node, *node;
 	struct resource *res;
 	void __iomem *base;
 	int ret;
@@ -2795,8 +2842,8 @@ static int rockchip_pinctrl_probe(struct platform_device *pdev)
 
 		rockchip_regmap_config.max_register = resource_size(res) - 4;
 		rockchip_regmap_config.name = "rockchip,pinctrl";
-		info->regmap_base = devm_regmap_init_mmio(&pdev->dev, base,
-						    &rockchip_regmap_config);
+		info->regmap_base =
+			devm_regmap_init_mmio(dev, base, &rockchip_regmap_config);
 
 		/* to check for the old dt-bindings */
 		info->reg_size = resource_size(res);
@@ -2808,12 +2855,10 @@ static int rockchip_pinctrl_probe(struct platform_device *pdev)
 			if (IS_ERR(base))
 				return PTR_ERR(base);
 
-			rockchip_regmap_config.max_register =
-							resource_size(res) - 4;
+			rockchip_regmap_config.max_register = resource_size(res) - 4;
 			rockchip_regmap_config.name = "rockchip,pinctrl-pull";
-			info->regmap_pull = devm_regmap_init_mmio(&pdev->dev,
-						    base,
-						    &rockchip_regmap_config);
+			info->regmap_pull =
+				devm_regmap_init_mmio(dev, base, &rockchip_regmap_config);
 		}
 	}
 
@@ -2834,7 +2879,7 @@ static int rockchip_pinctrl_probe(struct platform_device *pdev)
 
 	ret = of_platform_populate(np, NULL, NULL, &pdev->dev);
 	if (ret) {
-		dev_err(&pdev->dev, "failed to register gpio device\n");
+		dev_err(dev, "failed to register gpio device\n");
 		return ret;
 	}
 
diff --git a/drivers/pinctrl/pinctrl-rockchip.h b/drivers/pinctrl/pinctrl-rockchip.h
index 98a01a616da6..59116e13758d 100644
--- a/drivers/pinctrl/pinctrl-rockchip.h
+++ b/drivers/pinctrl/pinctrl-rockchip.h
@@ -230,10 +230,10 @@ struct rockchip_pin_ctrl {
 	struct rockchip_mux_route_data *iomux_routes;
 	u32				niomux_routes;
 
-	void	(*pull_calc_reg)(struct rockchip_pin_bank *bank,
+	int	(*pull_calc_reg)(struct rockchip_pin_bank *bank,
 				    int pin_num, struct regmap **regmap,
 				    int *reg, u8 *bit);
-	void	(*drv_calc_reg)(struct rockchip_pin_bank *bank,
+	int	(*drv_calc_reg)(struct rockchip_pin_bank *bank,
 				    int pin_num, struct regmap **regmap,
 				    int *reg, u8 *bit);
 	int	(*schmitt_calc_reg)(struct rockchip_pin_bank *bank,
diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
index a81dc4b191b7..4d7327b67a7d 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -521,6 +521,7 @@ static const struct key_entry asus_nb_wmi_keymap[] = {
 	{ KE_KEY, 0x30, { KEY_VOLUMEUP } },
 	{ KE_KEY, 0x31, { KEY_VOLUMEDOWN } },
 	{ KE_KEY, 0x32, { KEY_MUTE } },
+	{ KE_KEY, 0x33, { KEY_SCREENLOCK } },
 	{ KE_KEY, 0x35, { KEY_SCREENLOCK } },
 	{ KE_KEY, 0x40, { KEY_PREVIOUSSONG } },
 	{ KE_KEY, 0x41, { KEY_NEXTSONG } },
diff --git a/drivers/platform/x86/touchscreen_dmi.c b/drivers/platform/x86/touchscreen_dmi.c
index 3d0790263fa7..93671037fd59 100644
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
@@ -1100,6 +1117,14 @@ const struct dmi_system_id touchscreen_dmi_table[] = {
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
diff --git a/drivers/reset/reset-uniphier-glue.c b/drivers/reset/reset-uniphier-glue.c
index 027990b79f61..7493e9618837 100644
--- a/drivers/reset/reset-uniphier-glue.c
+++ b/drivers/reset/reset-uniphier-glue.c
@@ -23,7 +23,7 @@ struct uniphier_glue_reset_soc_data {
 
 struct uniphier_glue_reset_priv {
 	struct clk_bulk_data clk[MAX_CLKS];
-	struct reset_control *rst[MAX_RSTS];
+	struct reset_control_bulk_data rst[MAX_RSTS];
 	struct reset_simple_data rdata;
 	const struct uniphier_glue_reset_soc_data *data;
 };
@@ -33,9 +33,7 @@ static int uniphier_glue_reset_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct uniphier_glue_reset_priv *priv;
 	struct resource *res;
-	resource_size_t size;
-	const char *name;
-	int i, ret, nr;
+	int i, ret;
 
 	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
@@ -47,7 +45,6 @@ static int uniphier_glue_reset_probe(struct platform_device *pdev)
 		return -EINVAL;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	size = resource_size(res);
 	priv->rdata.membase = devm_ioremap_resource(dev, res);
 	if (IS_ERR(priv->rdata.membase))
 		return PTR_ERR(priv->rdata.membase);
@@ -58,26 +55,24 @@ static int uniphier_glue_reset_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	for (i = 0; i < priv->data->nrsts; i++) {
-		name = priv->data->reset_names[i];
-		priv->rst[i] = devm_reset_control_get_shared(dev, name);
-		if (IS_ERR(priv->rst[i]))
-			return PTR_ERR(priv->rst[i]);
-	}
+	for (i = 0; i < priv->data->nrsts; i++)
+		priv->rst[i].id = priv->data->reset_names[i];
+	ret = devm_reset_control_bulk_get_shared(dev, priv->data->nrsts,
+						 priv->rst);
+	if (ret)
+		return ret;
 
 	ret = clk_bulk_prepare_enable(priv->data->nclks, priv->clk);
 	if (ret)
 		return ret;
 
-	for (nr = 0; nr < priv->data->nrsts; nr++) {
-		ret = reset_control_deassert(priv->rst[nr]);
-		if (ret)
-			goto out_rst_assert;
-	}
+	ret = reset_control_bulk_deassert(priv->data->nrsts, priv->rst);
+	if (ret)
+		goto out_clk_disable;
 
 	spin_lock_init(&priv->rdata.lock);
 	priv->rdata.rcdev.owner = THIS_MODULE;
-	priv->rdata.rcdev.nr_resets = size * BITS_PER_BYTE;
+	priv->rdata.rcdev.nr_resets = resource_size(res) * BITS_PER_BYTE;
 	priv->rdata.rcdev.ops = &reset_simple_ops;
 	priv->rdata.rcdev.of_node = dev->of_node;
 	priv->rdata.active_low = true;
@@ -91,9 +86,9 @@ static int uniphier_glue_reset_probe(struct platform_device *pdev)
 	return 0;
 
 out_rst_assert:
-	while (nr--)
-		reset_control_assert(priv->rst[nr]);
+	reset_control_bulk_assert(priv->data->nrsts, priv->rst);
 
+out_clk_disable:
 	clk_bulk_disable_unprepare(priv->data->nclks, priv->clk);
 
 	return ret;
@@ -102,10 +97,8 @@ static int uniphier_glue_reset_probe(struct platform_device *pdev)
 static int uniphier_glue_reset_remove(struct platform_device *pdev)
 {
 	struct uniphier_glue_reset_priv *priv = platform_get_drvdata(pdev);
-	int i;
 
-	for (i = 0; i < priv->data->nrsts; i++)
-		reset_control_assert(priv->rst[i]);
+	reset_control_bulk_assert(priv->data->nrsts, priv->rst);
 
 	clk_bulk_disable_unprepare(priv->data->nclks, priv->clk);
 
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 9515c45affa5..7d93783c09a5 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1414,7 +1414,7 @@ static void hisi_sas_refresh_port_id(struct hisi_hba *hisi_hba)
 				device->linkrate = phy->sas_phy.linkrate;
 
 			hisi_hba->hw->setup_itct(hisi_hba, sas_dev);
-		} else
+		} else if (!port->port_attached)
 			port->id = 0xff;
 	}
 }
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index cf7988de7b90..8aa5c22ae3ff 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -5848,7 +5848,7 @@ static int hpsa_scsi_host_alloc(struct ctlr_info *h)
 {
 	struct Scsi_Host *sh;
 
-	sh = scsi_host_alloc(&hpsa_driver_template, sizeof(h));
+	sh = scsi_host_alloc(&hpsa_driver_template, sizeof(struct ctlr_info));
 	if (sh == NULL) {
 		dev_err(&h->pdev->dev, "scsi_host_alloc failed\n");
 		return -ENOMEM;
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index cc39cbef9d7f..4d23e5af20d3 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1679,6 +1679,13 @@ static const char *iscsi_session_state_name(int state)
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
 	int err;
@@ -1807,9 +1814,13 @@ static int iscsi_user_scan_session(struct device *dev, void *data)
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
@@ -1998,31 +2009,41 @@ static void __iscsi_unbind_session(struct work_struct *work)
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
@@ -2091,6 +2112,9 @@ int iscsi_add_session(struct iscsi_cls_session *session, unsigned int target_id)
 		session->ida_used = true;
 	} else
 		session->target_id = target_id;
+	spin_lock_irqsave(&session->lock, flags);
+	session->target_state = ISCSI_SESSION_TARGET_ALLOCATED;
+	spin_unlock_irqrestore(&session->lock, flags);
 
 	dev_set_name(&session->dev, "session%u", session->sid);
 	err = device_add(&session->dev);
@@ -4391,6 +4415,19 @@ iscsi_session_attr(def_taskmgmt_tmo, ISCSI_PARAM_DEF_TASKMGMT_TMO, 0);
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
@@ -4493,6 +4530,7 @@ static struct attribute *iscsi_session_attrs[] = {
 	&dev_attr_sess_boot_target.attr,
 	&dev_attr_priv_sess_recovery_tmo.attr,
 	&dev_attr_priv_sess_state.attr,
+	&dev_attr_priv_sess_target_state.attr,
 	&dev_attr_priv_sess_creator.attr,
 	&dev_attr_sess_chap_out_idx.attr,
 	&dev_attr_sess_chap_in_idx.attr,
@@ -4606,6 +4644,8 @@ static umode_t iscsi_session_attr_is_visible(struct kobject *kobj,
 		return S_IRUGO | S_IWUSR;
 	else if (attr == &dev_attr_priv_sess_state.attr)
 		return S_IRUGO;
+	else if (attr == &dev_attr_priv_sess_target_state.attr)
+		return S_IRUGO;
 	else if (attr == &dev_attr_priv_sess_creator.attr)
 		return S_IRUGO;
 	else if (attr == &dev_attr_priv_sess_target_id.attr)
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 0b06223f5714..120831428ec6 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1185,12 +1185,14 @@ static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba)
 	 * clock scaling is in progress
 	 */
 	ufshcd_scsi_block_requests(hba);
+	mutex_lock(&hba->wb_mutex);
 	down_write(&hba->clk_scaling_lock);
 
 	if (!hba->clk_scaling.is_allowed ||
 	    ufshcd_wait_for_doorbell_clr(hba, DOORBELL_CLR_TOUT_US)) {
 		ret = -EBUSY;
 		up_write(&hba->clk_scaling_lock);
+		mutex_unlock(&hba->wb_mutex);
 		ufshcd_scsi_unblock_requests(hba);
 		goto out;
 	}
@@ -1202,12 +1204,15 @@ static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba)
 	return ret;
 }
 
-static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba, bool writelock)
+static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba, int err, bool scale_up)
 {
-	if (writelock)
-		up_write(&hba->clk_scaling_lock);
-	else
-		up_read(&hba->clk_scaling_lock);
+	up_write(&hba->clk_scaling_lock);
+
+	/* Enable Write Booster if we have scaled up else disable it */
+	ufshcd_wb_toggle(hba, scale_up);
+
+	mutex_unlock(&hba->wb_mutex);
+
 	ufshcd_scsi_unblock_requests(hba);
 	ufshcd_release(hba);
 }
@@ -1224,7 +1229,6 @@ static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba, bool writelock)
 static int ufshcd_devfreq_scale(struct ufs_hba *hba, bool scale_up)
 {
 	int ret = 0;
-	bool is_writelock = true;
 
 	ret = ufshcd_clock_scaling_prepare(hba);
 	if (ret)
@@ -1253,13 +1257,8 @@ static int ufshcd_devfreq_scale(struct ufs_hba *hba, bool scale_up)
 		}
 	}
 
-	/* Enable Write Booster if we have scaled up else disable it */
-	downgrade_write(&hba->clk_scaling_lock);
-	is_writelock = false;
-	ufshcd_wb_toggle(hba, scale_up);
-
 out_unprepare:
-	ufshcd_clock_scaling_unprepare(hba, is_writelock);
+	ufshcd_clock_scaling_unprepare(hba, ret, scale_up);
 	return ret;
 }
 
@@ -5919,9 +5918,11 @@ static void ufshcd_force_error_recovery(struct ufs_hba *hba)
 
 static void ufshcd_clk_scaling_allow(struct ufs_hba *hba, bool allow)
 {
+	mutex_lock(&hba->wb_mutex);
 	down_write(&hba->clk_scaling_lock);
 	hba->clk_scaling.is_allowed = allow;
 	up_write(&hba->clk_scaling_lock);
+	mutex_unlock(&hba->wb_mutex);
 }
 
 static void ufshcd_clk_scaling_suspend(struct ufs_hba *hba, bool suspend)
@@ -9480,6 +9481,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	/* Initialize mutex for exception event control */
 	mutex_init(&hba->ee_ctrl_mutex);
 
+	mutex_init(&hba->wb_mutex);
 	init_rwsem(&hba->clk_scaling_lock);
 
 	ufshcd_init_clk_gating(hba);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index d470a52ff24c..c8513cc6c2bd 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -763,6 +763,7 @@ struct ufs_hba_monitor {
  * @urgent_bkops_lvl: keeps track of urgent bkops level for device
  * @is_urgent_bkops_lvl_checked: keeps track if the urgent bkops level for
  *  device is known or not.
+ * @wb_mutex: used to serialize devfreq and sysfs write booster toggling
  * @scsi_block_reqs_cnt: reference counting for scsi block requests
  * @crypto_capabilities: Content of crypto capabilities register (0x100)
  * @crypto_cap_array: Array of crypto capabilities
@@ -892,6 +893,7 @@ struct ufs_hba {
 	enum bkops_status urgent_bkops_lvl;
 	bool is_urgent_bkops_lvl_checked;
 
+	struct mutex wb_mutex;
 	struct rw_semaphore clk_scaling_lock;
 	unsigned char desc_size[QUERY_DESC_IDN_MAX];
 	atomic_t scsi_block_reqs_cnt;
diff --git a/drivers/soc/imx/soc-imx8m.c b/drivers/soc/imx/soc-imx8m.c
index 28144c699b0c..32ed9dc88e45 100644
--- a/drivers/soc/imx/soc-imx8m.c
+++ b/drivers/soc/imx/soc-imx8m.c
@@ -66,8 +66,8 @@ static u32 __init imx8mq_soc_revision(void)
 	ocotp_base = of_iomap(np, 0);
 	WARN_ON(!ocotp_base);
 	clk = of_clk_get_by_name(np, NULL);
-	if (!clk) {
-		WARN_ON(!clk);
+	if (IS_ERR(clk)) {
+		WARN_ON(IS_ERR(clk));
 		return 0;
 	}
 
diff --git a/drivers/soc/qcom/cpr.c b/drivers/soc/qcom/cpr.c
index 84dd93472a25..e61cff3d9c8a 100644
--- a/drivers/soc/qcom/cpr.c
+++ b/drivers/soc/qcom/cpr.c
@@ -1710,12 +1710,16 @@ static int cpr_probe(struct platform_device *pdev)
 
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
index d233e2424ad1..922d778df064 100644
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
diff --git a/drivers/thermal/gov_fair_share.c b/drivers/thermal/gov_fair_share.c
index 1e5abf4822be..a4c30797b534 100644
--- a/drivers/thermal/gov_fair_share.c
+++ b/drivers/thermal/gov_fair_share.c
@@ -25,10 +25,10 @@ static int get_trip_level(struct thermal_zone_device *tz)
 	int trip_temp;
 	enum thermal_trip_type trip_type;
 
-	if (tz->trips == 0 || !tz->ops->get_trip_temp)
+	if (tz->num_trips == 0 || !tz->ops->get_trip_temp)
 		return 0;
 
-	for (count = 0; count < tz->trips; count++) {
+	for (count = 0; count < tz->num_trips; count++) {
 		tz->ops->get_trip_temp(tz, count, &trip_temp);
 		if (tz->temperature < trip_temp)
 			break;
@@ -49,11 +49,7 @@ static int get_trip_level(struct thermal_zone_device *tz)
 static long get_target_state(struct thermal_zone_device *tz,
 		struct thermal_cooling_device *cdev, int percentage, int level)
 {
-	unsigned long max_state;
-
-	cdev->ops->get_max_state(cdev, &max_state);
-
-	return (long)(percentage * level * max_state) / (100 * tz->trips);
+	return (long)(percentage * level * cdev->max_state) / (100 * tz->num_trips);
 }
 
 /**
diff --git a/drivers/thermal/gov_power_allocator.c b/drivers/thermal/gov_power_allocator.c
index 13e375751d22..1d5052470967 100644
--- a/drivers/thermal/gov_power_allocator.c
+++ b/drivers/thermal/gov_power_allocator.c
@@ -527,7 +527,7 @@ static void get_governor_trips(struct thermal_zone_device *tz,
 	last_active = INVALID_TRIP;
 	last_passive = INVALID_TRIP;
 
-	for (i = 0; i < tz->trips; i++) {
+	for (i = 0; i < tz->num_trips; i++) {
 		enum thermal_trip_type type;
 		int ret;
 
@@ -668,7 +668,7 @@ static int power_allocator_bind(struct thermal_zone_device *tz)
 
 	get_governor_trips(tz, params);
 
-	if (tz->trips > 0) {
+	if (tz->num_trips > 0) {
 		ret = tz->ops->get_trip_temp(tz,
 					params->trip_max_desired_temperature,
 					&control_temp);
diff --git a/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c b/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c
index 62c0aa5d0783..0a4eaa307156 100644
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
@@ -180,6 +188,8 @@ int int340x_thermal_read_trips(struct int34x_thermal_zone *int34x_zone)
 	int trip_cnt = int34x_zone->aux_trip_nr;
 	int i;
 
+	mutex_lock(&int34x_zone->trip_mutex);
+
 	int34x_zone->crt_trip_id = -1;
 	if (!int340x_thermal_get_trip_config(int34x_zone->adev->handle, "_CRT",
 					     &int34x_zone->crt_temp))
@@ -207,6 +217,8 @@ int int340x_thermal_read_trips(struct int34x_thermal_zone *int34x_zone)
 		int34x_zone->act_trips[i].valid = true;
 	}
 
+	mutex_unlock(&int34x_zone->trip_mutex);
+
 	return trip_cnt;
 }
 EXPORT_SYMBOL_GPL(int340x_thermal_read_trips);
@@ -230,6 +242,8 @@ struct int34x_thermal_zone *int340x_thermal_zone_add(struct acpi_device *adev,
 	if (!int34x_thermal_zone)
 		return ERR_PTR(-ENOMEM);
 
+	mutex_init(&int34x_thermal_zone->trip_mutex);
+
 	int34x_thermal_zone->adev = adev;
 	int34x_thermal_zone->override_ops = override_ops;
 
@@ -281,6 +295,7 @@ struct int34x_thermal_zone *int340x_thermal_zone_add(struct acpi_device *adev,
 	acpi_lpat_free_conversion_table(int34x_thermal_zone->lpat_table);
 	kfree(int34x_thermal_zone->aux_trips);
 err_trip_alloc:
+	mutex_destroy(&int34x_thermal_zone->trip_mutex);
 	kfree(int34x_thermal_zone);
 	return ERR_PTR(ret);
 }
@@ -292,6 +307,7 @@ void int340x_thermal_zone_remove(struct int34x_thermal_zone
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
diff --git a/drivers/thermal/tegra/tegra30-tsensor.c b/drivers/thermal/tegra/tegra30-tsensor.c
index 9b6b693cbcf8..05886684f429 100644
--- a/drivers/thermal/tegra/tegra30-tsensor.c
+++ b/drivers/thermal/tegra/tegra30-tsensor.c
@@ -316,7 +316,7 @@ static void tegra_tsensor_get_hw_channel_trips(struct thermal_zone_device *tzd,
 	*hot_trip  = 85000;
 	*crit_trip = 90000;
 
-	for (i = 0; i < tzd->trips; i++) {
+	for (i = 0; i < tzd->num_trips; i++) {
 		enum thermal_trip_type type;
 		int trip_temp;
 
diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index 38082fdc4fde..052e8e8fbb21 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -503,7 +503,7 @@ void thermal_zone_device_update(struct thermal_zone_device *tz,
 
 	tz->notify_event = event;
 
-	for (count = 0; count < tz->trips; count++)
+	for (count = 0; count < tz->num_trips; count++)
 		handle_thermal_trip(tz, count);
 }
 EXPORT_SYMBOL_GPL(thermal_zone_device_update);
@@ -625,10 +625,9 @@ int thermal_zone_bind_cooling_device(struct thermal_zone_device *tz,
 	struct thermal_instance *pos;
 	struct thermal_zone_device *pos1;
 	struct thermal_cooling_device *pos2;
-	unsigned long max_state;
-	int result, ret;
+	int result;
 
-	if (trip >= tz->trips || trip < 0)
+	if (trip >= tz->num_trips || trip < 0)
 		return -EINVAL;
 
 	list_for_each_entry(pos1, &thermal_tz_list, node) {
@@ -643,15 +642,11 @@ int thermal_zone_bind_cooling_device(struct thermal_zone_device *tz,
 	if (tz != pos1 || cdev != pos2)
 		return -EINVAL;
 
-	ret = cdev->ops->get_max_state(cdev, &max_state);
-	if (ret)
-		return ret;
-
 	/* lower default 0, upper default max_state */
 	lower = lower == THERMAL_NO_LIMIT ? 0 : lower;
-	upper = upper == THERMAL_NO_LIMIT ? max_state : upper;
+	upper = upper == THERMAL_NO_LIMIT ? cdev->max_state : upper;
 
-	if (lower > upper || upper > max_state)
+	if (lower > upper || upper > cdev->max_state)
 		return -EINVAL;
 
 	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
@@ -809,7 +804,7 @@ static void __bind(struct thermal_zone_device *tz, int mask,
 {
 	int i, ret;
 
-	for (i = 0; i < tz->trips; i++) {
+	for (i = 0; i < tz->num_trips; i++) {
 		if (mask & (1 << i)) {
 			unsigned long upper, lower;
 
@@ -918,12 +913,22 @@ __thermal_cooling_device_register(struct device_node *np,
 	cdev->updated = false;
 	cdev->device.class = &thermal_class;
 	cdev->devdata = devdata;
+
+	ret = cdev->ops->get_max_state(cdev, &cdev->max_state);
+	if (ret) {
+		kfree(cdev->type);
+		goto out_ida_remove;
+	}
+
 	thermal_cooling_device_setup_sysfs(cdev);
+
 	ret = dev_set_name(&cdev->device, "cooling_device%d", cdev->id);
 	if (ret) {
+		kfree(cdev->type);
 		thermal_cooling_device_destroy_sysfs(cdev);
-		goto out_kfree_type;
+		goto out_ida_remove;
 	}
+
 	ret = device_register(&cdev->device);
 	if (ret)
 		goto out_kfree_type;
@@ -949,6 +954,8 @@ __thermal_cooling_device_register(struct device_node *np,
 	thermal_cooling_device_destroy_sysfs(cdev);
 	kfree(cdev->type);
 	put_device(&cdev->device);
+
+	/* thermal_release() takes care of the rest */
 	cdev = NULL;
 out_ida_remove:
 	ida_simple_remove(&thermal_cdev_ida, id);
@@ -1056,7 +1063,7 @@ static void __unbind(struct thermal_zone_device *tz, int mask,
 {
 	int i;
 
-	for (i = 0; i < tz->trips; i++)
+	for (i = 0; i < tz->num_trips; i++)
 		if (mask & (1 << i))
 			thermal_zone_unbind_cooling_device(tz, i, cdev);
 }
@@ -1161,7 +1168,7 @@ static void bind_tz(struct thermal_zone_device *tz)
 /**
  * thermal_zone_device_register() - register a new thermal zone device
  * @type:	the thermal zone device type
- * @trips:	the number of trip points the thermal zone support
+ * @num_trips:	the number of trip points the thermal zone support
  * @mask:	a bit string indicating the writeablility of trip points
  * @devdata:	private device data
  * @ops:	standard thermal zone device callbacks
@@ -1183,7 +1190,7 @@ static void bind_tz(struct thermal_zone_device *tz)
  * IS_ERR*() helpers.
  */
 struct thermal_zone_device *
-thermal_zone_device_register(const char *type, int trips, int mask,
+thermal_zone_device_register(const char *type, int num_trips, int mask,
 			     void *devdata, struct thermal_zone_device_ops *ops,
 			     struct thermal_zone_params *tzp, int passive_delay,
 			     int polling_delay)
@@ -1197,27 +1204,27 @@ thermal_zone_device_register(const char *type, int trips, int mask,
 	struct thermal_governor *governor;
 
 	if (!type || strlen(type) == 0) {
-		pr_err("Error: No thermal zone type defined\n");
+		pr_err("No thermal zone type defined\n");
 		return ERR_PTR(-EINVAL);
 	}
 
 	if (type && strlen(type) >= THERMAL_NAME_LENGTH) {
-		pr_err("Error: Thermal zone name (%s) too long, should be under %d chars\n",
+		pr_err("Thermal zone name (%s) too long, should be under %d chars\n",
 		       type, THERMAL_NAME_LENGTH);
 		return ERR_PTR(-EINVAL);
 	}
 
-	if (trips > THERMAL_MAX_TRIPS || trips < 0 || mask >> trips) {
-		pr_err("Error: Incorrect number of thermal trips\n");
+	if (num_trips > THERMAL_MAX_TRIPS || num_trips < 0 || mask >> num_trips) {
+		pr_err("Incorrect number of thermal trips\n");
 		return ERR_PTR(-EINVAL);
 	}
 
 	if (!ops) {
-		pr_err("Error: Thermal zone device ops not defined\n");
+		pr_err("Thermal zone device ops not defined\n");
 		return ERR_PTR(-EINVAL);
 	}
 
-	if (trips > 0 && (!ops->get_trip_type || !ops->get_trip_temp))
+	if (num_trips > 0 && (!ops->get_trip_type || !ops->get_trip_temp))
 		return ERR_PTR(-EINVAL);
 
 	tz = kzalloc(sizeof(*tz), GFP_KERNEL);
@@ -1243,7 +1250,7 @@ thermal_zone_device_register(const char *type, int trips, int mask,
 	tz->tzp = tzp;
 	tz->device.class = &thermal_class;
 	tz->devdata = devdata;
-	tz->trips = trips;
+	tz->num_trips = num_trips;
 
 	thermal_set_delay_jiffies(&tz->passive_delay_jiffies, passive_delay);
 	thermal_set_delay_jiffies(&tz->polling_delay_jiffies, polling_delay);
@@ -1266,7 +1273,7 @@ thermal_zone_device_register(const char *type, int trips, int mask,
 	if (result)
 		goto release_device;
 
-	for (count = 0; count < trips; count++) {
+	for (count = 0; count < num_trips; count++) {
 		if (tz->ops->get_trip_type(tz, count, &trip_type) ||
 		    tz->ops->get_trip_temp(tz, count, &trip_temp) ||
 		    !trip_temp)
diff --git a/drivers/thermal/thermal_helpers.c b/drivers/thermal/thermal_helpers.c
index 3edd047e144f..ee7027bdcafa 100644
--- a/drivers/thermal/thermal_helpers.c
+++ b/drivers/thermal/thermal_helpers.c
@@ -90,7 +90,7 @@ int thermal_zone_get_temp(struct thermal_zone_device *tz, int *temp)
 	ret = tz->ops->get_temp(tz, temp);
 
 	if (IS_ENABLED(CONFIG_THERMAL_EMULATION) && tz->emul_temperature) {
-		for (count = 0; count < tz->trips; count++) {
+		for (count = 0; count < tz->num_trips; count++) {
 			ret = tz->ops->get_trip_type(tz, count, &type);
 			if (!ret && type == THERMAL_TRIP_CRITICAL) {
 				ret = tz->ops->get_trip_temp(tz, count,
@@ -138,7 +138,7 @@ void thermal_zone_set_trips(struct thermal_zone_device *tz)
 	if (!tz->ops->set_trips || !tz->ops->get_trip_hyst)
 		goto exit;
 
-	for (i = 0; i < tz->trips; i++) {
+	for (i = 0; i < tz->num_trips; i++) {
 		int trip_low;
 
 		tz->ops->get_trip_temp(tz, i, &trip_temp);
diff --git a/drivers/thermal/thermal_netlink.c b/drivers/thermal/thermal_netlink.c
index 41c8d47805c4..c70d407c2c71 100644
--- a/drivers/thermal/thermal_netlink.c
+++ b/drivers/thermal/thermal_netlink.c
@@ -415,7 +415,7 @@ static int thermal_genl_cmd_tz_get_trip(struct param *p)
 
 	mutex_lock(&tz->lock);
 
-	for (i = 0; i < tz->trips; i++) {
+	for (i = 0; i < tz->num_trips; i++) {
 
 		enum thermal_trip_type type;
 		int temp, hyst = 0;
diff --git a/drivers/thermal/thermal_sysfs.c b/drivers/thermal/thermal_sysfs.c
index 1e5a78131aba..de7cdec3db90 100644
--- a/drivers/thermal/thermal_sysfs.c
+++ b/drivers/thermal/thermal_sysfs.c
@@ -416,15 +416,15 @@ static int create_trip_attrs(struct thermal_zone_device *tz, int mask)
 	int indx;
 
 	/* This function works only for zones with at least one trip */
-	if (tz->trips <= 0)
+	if (tz->num_trips <= 0)
 		return -EINVAL;
 
-	tz->trip_type_attrs = kcalloc(tz->trips, sizeof(*tz->trip_type_attrs),
+	tz->trip_type_attrs = kcalloc(tz->num_trips, sizeof(*tz->trip_type_attrs),
 				      GFP_KERNEL);
 	if (!tz->trip_type_attrs)
 		return -ENOMEM;
 
-	tz->trip_temp_attrs = kcalloc(tz->trips, sizeof(*tz->trip_temp_attrs),
+	tz->trip_temp_attrs = kcalloc(tz->num_trips, sizeof(*tz->trip_temp_attrs),
 				      GFP_KERNEL);
 	if (!tz->trip_temp_attrs) {
 		kfree(tz->trip_type_attrs);
@@ -432,7 +432,7 @@ static int create_trip_attrs(struct thermal_zone_device *tz, int mask)
 	}
 
 	if (tz->ops->get_trip_hyst) {
-		tz->trip_hyst_attrs = kcalloc(tz->trips,
+		tz->trip_hyst_attrs = kcalloc(tz->num_trips,
 					      sizeof(*tz->trip_hyst_attrs),
 					      GFP_KERNEL);
 		if (!tz->trip_hyst_attrs) {
@@ -442,7 +442,7 @@ static int create_trip_attrs(struct thermal_zone_device *tz, int mask)
 		}
 	}
 
-	attrs = kcalloc(tz->trips * 3 + 1, sizeof(*attrs), GFP_KERNEL);
+	attrs = kcalloc(tz->num_trips * 3 + 1, sizeof(*attrs), GFP_KERNEL);
 	if (!attrs) {
 		kfree(tz->trip_type_attrs);
 		kfree(tz->trip_temp_attrs);
@@ -451,7 +451,7 @@ static int create_trip_attrs(struct thermal_zone_device *tz, int mask)
 		return -ENOMEM;
 	}
 
-	for (indx = 0; indx < tz->trips; indx++) {
+	for (indx = 0; indx < tz->num_trips; indx++) {
 		/* create trip type attribute */
 		snprintf(tz->trip_type_attrs[indx].name, THERMAL_NAME_LENGTH,
 			 "trip_point_%d_type", indx);
@@ -478,7 +478,7 @@ static int create_trip_attrs(struct thermal_zone_device *tz, int mask)
 			tz->trip_temp_attrs[indx].attr.store =
 							trip_point_temp_store;
 		}
-		attrs[indx + tz->trips] = &tz->trip_temp_attrs[indx].attr.attr;
+		attrs[indx + tz->num_trips] = &tz->trip_temp_attrs[indx].attr.attr;
 
 		/* create Optional trip hyst attribute */
 		if (!tz->ops->get_trip_hyst)
@@ -496,10 +496,10 @@ static int create_trip_attrs(struct thermal_zone_device *tz, int mask)
 			tz->trip_hyst_attrs[indx].attr.store =
 					trip_point_hyst_store;
 		}
-		attrs[indx + tz->trips * 2] =
+		attrs[indx + tz->num_trips * 2] =
 					&tz->trip_hyst_attrs[indx].attr.attr;
 	}
-	attrs[tz->trips * 3] = NULL;
+	attrs[tz->num_trips * 3] = NULL;
 
 	tz->trips_attribute_group.attrs = attrs;
 
@@ -540,7 +540,7 @@ int thermal_zone_create_device_groups(struct thermal_zone_device *tz,
 	for (i = 0; i < size - 2; i++)
 		groups[i] = thermal_zone_attribute_groups[i];
 
-	if (tz->trips) {
+	if (tz->num_trips) {
 		result = create_trip_attrs(tz, mask);
 		if (result) {
 			kfree(groups);
@@ -561,7 +561,7 @@ void thermal_zone_destroy_device_groups(struct thermal_zone_device *tz)
 	if (!tz)
 		return;
 
-	if (tz->trips)
+	if (tz->num_trips)
 		destroy_trip_attrs(tz);
 
 	kfree(tz->device.groups);
@@ -580,13 +580,8 @@ static ssize_t max_state_show(struct device *dev, struct device_attribute *attr,
 			      char *buf)
 {
 	struct thermal_cooling_device *cdev = to_cooling_device(dev);
-	unsigned long state;
-	int ret;
 
-	ret = cdev->ops->get_max_state(cdev, &state);
-	if (ret)
-		return ret;
-	return sprintf(buf, "%ld\n", state);
+	return sprintf(buf, "%ld\n", cdev->max_state);
 }
 
 static ssize_t cur_state_show(struct device *dev, struct device_attribute *attr,
@@ -616,6 +611,10 @@ cur_state_store(struct device *dev, struct device_attribute *attr,
 	if ((long)state < 0)
 		return -EINVAL;
 
+	/* Requested state should be less than max_state + 1 */
+	if (state > cdev->max_state)
+		return -EINVAL;
+
 	mutex_lock(&cdev->lock);
 
 	result = cdev->ops->set_cur_state(cdev, state);
diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index adc44a2685b5..c9145ee95956 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -279,6 +279,9 @@ static int __ffs_ep0_queue_wait(struct ffs_data *ffs, char *data, size_t len)
 	struct usb_request *req = ffs->ep0req;
 	int ret;
 
+	if (!req)
+		return -EINVAL;
+
 	req->zero     = len < le16_to_cpu(ffs->ev.setup.wLength);
 
 	spin_unlock_irq(&ffs->ev.waitq.lock);
@@ -1892,10 +1895,14 @@ static void functionfs_unbind(struct ffs_data *ffs)
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
diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index f2ae2e563dc5..4a2ddf730a3a 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -1166,6 +1166,8 @@ int w1_process(void *data)
 	/* remainder if it woke up early */
 	unsigned long jremain = 0;
 
+	atomic_inc(&dev->refcnt);
+
 	for (;;) {
 
 		if (!jremain && dev->search_count) {
@@ -1193,8 +1195,10 @@ int w1_process(void *data)
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
index 75ebd2b576ca..25d480ea797b 100644
--- a/fs/affs/file.c
+++ b/fs/affs/file.c
@@ -881,7 +881,7 @@ affs_truncate(struct inode *inode)
 	if (inode->i_size > AFFS_I(inode)->mmu_private) {
 		struct address_space *mapping = inode->i_mapping;
 		struct page *page;
-		void *fsdata;
+		void *fsdata = NULL;
 		loff_t isize = inode->i_size;
 		int res;
 
diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
index 1f3efa7821a0..8c98fa507768 100644
--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@ -792,26 +792,27 @@ static int get_dfs_referral(const unsigned int xid, struct cifs_ses *ses, const
  */
 static int cache_refresh_path(const unsigned int xid, struct cifs_ses *ses, const char *path)
 {
-	int rc;
-	struct cache_entry *ce;
 	struct dfs_info3_param *refs = NULL;
+	struct cache_entry *ce;
 	int numrefs = 0;
-	bool newent = false;
+	int rc;
 
 	cifs_dbg(FYI, "%s: search path: %s\n", __func__, path);
 
-	down_write(&htable_rw_lock);
+	down_read(&htable_rw_lock);
 
 	ce = lookup_cache_entry(path);
-	if (!IS_ERR(ce)) {
-		if (!cache_entry_expired(ce)) {
-			dump_ce(ce);
-			up_write(&htable_rw_lock);
-			return 0;
-		}
-	} else {
-		newent = true;
+	if (!IS_ERR(ce) && !cache_entry_expired(ce)) {
+		up_read(&htable_rw_lock);
+		return 0;
 	}
+	/*
+	 * Unlock shared access as we don't want to hold any locks while getting
+	 * a new referral.  The @ses used for performing the I/O could be
+	 * reconnecting and it acquires @htable_rw_lock to look up the dfs cache
+	 * in order to failover -- if necessary.
+	 */
+	up_read(&htable_rw_lock);
 
 	/*
 	 * Either the entry was not found, or it is expired.
@@ -819,19 +820,22 @@ static int cache_refresh_path(const unsigned int xid, struct cifs_ses *ses, cons
 	 */
 	rc = get_dfs_referral(xid, ses, path, &refs, &numrefs);
 	if (rc)
-		goto out_unlock;
+		goto out;
 
 	dump_refs(refs, numrefs);
 
-	if (!newent) {
-		rc = update_cache_entry_locked(ce, refs, numrefs);
-		goto out_unlock;
+	down_write(&htable_rw_lock);
+	/* Re-check as another task might have it added or refreshed already */
+	ce = lookup_cache_entry(path);
+	if (!IS_ERR(ce)) {
+		if (cache_entry_expired(ce))
+			rc = update_cache_entry_locked(ce, refs, numrefs);
+	} else {
+		rc = add_cache_entry_locked(refs, numrefs);
 	}
 
-	rc = add_cache_entry_locked(refs, numrefs);
-
-out_unlock:
 	up_write(&htable_rw_lock);
+out:
 	free_dfs_info_array(refs, numrefs);
 	return rc;
 }
diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index 31ef64eb7fbb..cb93cccbf0c4 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -1405,6 +1405,7 @@ void smbd_destroy(struct TCP_Server_Info *server)
 	destroy_workqueue(info->workqueue);
 	log_rdma_event(INFO,  "rdma session destroyed\n");
 	kfree(info);
+	server->smbd_conn = NULL;
 }
 
 /*
diff --git a/fs/ksmbd/connection.c b/fs/ksmbd/connection.c
index 6a1d1fbe5fb2..ce0edf926c2a 100644
--- a/fs/ksmbd/connection.c
+++ b/fs/ksmbd/connection.c
@@ -274,7 +274,7 @@ int ksmbd_conn_handler_loop(void *p)
 {
 	struct ksmbd_conn *conn = (struct ksmbd_conn *)p;
 	struct ksmbd_transport *t = conn->transport;
-	unsigned int pdu_size;
+	unsigned int pdu_size, max_allowed_pdu_size;
 	char hdr_buf[4] = {0,};
 	int size;
 
@@ -299,13 +299,26 @@ int ksmbd_conn_handler_loop(void *p)
 		pdu_size = get_rfc1002_len(hdr_buf);
 		ksmbd_debug(CONN, "RFC1002 header %u bytes\n", pdu_size);
 
+		if (conn->status == KSMBD_SESS_GOOD)
+			max_allowed_pdu_size =
+				SMB3_MAX_MSGSIZE + conn->vals->max_write_size;
+		else
+			max_allowed_pdu_size = SMB3_MAX_MSGSIZE;
+
+		if (pdu_size > max_allowed_pdu_size) {
+			pr_err_ratelimited("PDU length(%u) excceed maximum allowed pdu size(%u) on connection(%d)\n",
+					pdu_size, max_allowed_pdu_size,
+					conn->status);
+			break;
+		}
+
 		/*
 		 * Check if pdu size is valid (min : smb header size,
 		 * max : 0x00FFFFFF).
 		 */
 		if (pdu_size < __SMB2_HEADER_STRUCTURE_SIZE ||
 		    pdu_size > MAX_STREAM_PROT_LEN) {
-			continue;
+			break;
 		}
 
 		/* 4 for rfc1002 length field */
diff --git a/fs/ksmbd/ksmbd_netlink.h b/fs/ksmbd/ksmbd_netlink.h
index 71bfb7de4472..fae859d59c79 100644
--- a/fs/ksmbd/ksmbd_netlink.h
+++ b/fs/ksmbd/ksmbd_netlink.h
@@ -104,7 +104,9 @@ struct ksmbd_startup_request {
 					 */
 	__u32	sub_auth[3];		/* Subauth value for Security ID */
 	__u32	smb2_max_credits;	/* MAX credits */
-	__u32	reserved[128];		/* Reserved room */
+	__u32	smbd_max_io_size;	/* smbd read write size */
+	__u32	max_connections;	/* Number of maximum simultaneous connections */
+	__u32	reserved[126];		/* Reserved room */
 	__u32	ifc_list_sz;		/* interfaces list size */
 	__s8	____payload[];
 };
diff --git a/fs/ksmbd/ndr.c b/fs/ksmbd/ndr.c
index 5052be9261d9..28f44f0c918c 100644
--- a/fs/ksmbd/ndr.c
+++ b/fs/ksmbd/ndr.c
@@ -242,7 +242,7 @@ int ndr_decode_dos_attr(struct ndr *n, struct xattr_dos_attrib *da)
 		return ret;
 
 	if (da->version != 3 && da->version != 4) {
-		pr_err("v%d version is not supported\n", da->version);
+		ksmbd_debug(VFS, "v%d version is not supported\n", da->version);
 		return -EINVAL;
 	}
 
@@ -251,7 +251,7 @@ int ndr_decode_dos_attr(struct ndr *n, struct xattr_dos_attrib *da)
 		return ret;
 
 	if (da->version != version2) {
-		pr_err("ndr version mismatched(version: %d, version2: %d)\n",
+		ksmbd_debug(VFS, "ndr version mismatched(version: %d, version2: %d)\n",
 		       da->version, version2);
 		return -EINVAL;
 	}
@@ -453,7 +453,7 @@ int ndr_decode_v4_ntacl(struct ndr *n, struct xattr_ntacl *acl)
 	if (ret)
 		return ret;
 	if (acl->version != 4) {
-		pr_err("v%d version is not supported\n", acl->version);
+		ksmbd_debug(VFS, "v%d version is not supported\n", acl->version);
 		return -EINVAL;
 	}
 
@@ -461,7 +461,7 @@ int ndr_decode_v4_ntacl(struct ndr *n, struct xattr_ntacl *acl)
 	if (ret)
 		return ret;
 	if (acl->version != version2) {
-		pr_err("ndr version mismatched(version: %d, version2: %d)\n",
+		ksmbd_debug(VFS, "ndr version mismatched(version: %d, version2: %d)\n",
 		       acl->version, version2);
 		return -EINVAL;
 	}
diff --git a/fs/ksmbd/server.h b/fs/ksmbd/server.h
index ac9d932f8c8a..db7278181760 100644
--- a/fs/ksmbd/server.h
+++ b/fs/ksmbd/server.h
@@ -41,6 +41,7 @@ struct ksmbd_server_config {
 	unsigned int		share_fake_fscaps;
 	struct smb_sid		domain_sid;
 	unsigned int		auth_mechs;
+	unsigned int		max_connections;
 
 	char			*conf[SERVER_CONF_WORK_GROUP + 1];
 };
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 65c85ca71ebe..ac029dfd23ab 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -8613,6 +8613,7 @@ int smb3_decrypt_req(struct ksmbd_work *work)
 bool smb3_11_final_sess_setup_resp(struct ksmbd_work *work)
 {
 	struct ksmbd_conn *conn = work->conn;
+	struct ksmbd_session *sess = work->sess;
 	struct smb2_hdr *rsp = work->response_buf;
 
 	if (conn->dialect < SMB30_PROT_ID)
@@ -8622,6 +8623,7 @@ bool smb3_11_final_sess_setup_resp(struct ksmbd_work *work)
 		rsp = ksmbd_resp_buf_next(work);
 
 	if (le16_to_cpu(rsp->Command) == SMB2_SESSION_SETUP_HE &&
+	    sess->user && !user_guest(sess->user) &&
 	    rsp->Status == STATUS_SUCCESS)
 		return true;
 	return false;
diff --git a/fs/ksmbd/smb2pdu.h b/fs/ksmbd/smb2pdu.h
index 4f8574944ac1..ddc3cea9c905 100644
--- a/fs/ksmbd/smb2pdu.h
+++ b/fs/ksmbd/smb2pdu.h
@@ -113,8 +113,9 @@
 #define SMB21_DEFAULT_IOSIZE	(1024 * 1024)
 #define SMB3_DEFAULT_IOSIZE	(4 * 1024 * 1024)
 #define SMB3_DEFAULT_TRANS_SIZE	(1024 * 1024)
-#define SMB3_MIN_IOSIZE	(64 * 1024)
-#define SMB3_MAX_IOSIZE	(8 * 1024 * 1024)
+#define SMB3_MIN_IOSIZE		(64 * 1024)
+#define SMB3_MAX_IOSIZE		(8 * 1024 * 1024)
+#define SMB3_MAX_MSGSIZE	(4 * 4096)
 
 /*
  * SMB2 Header Definition
diff --git a/fs/ksmbd/transport_ipc.c b/fs/ksmbd/transport_ipc.c
index 3ad6881e0f7e..a8313eed4f10 100644
--- a/fs/ksmbd/transport_ipc.c
+++ b/fs/ksmbd/transport_ipc.c
@@ -26,6 +26,7 @@
 #include "mgmt/ksmbd_ida.h"
 #include "connection.h"
 #include "transport_tcp.h"
+#include "transport_rdma.h"
 
 #define IPC_WAIT_TIMEOUT	(2 * HZ)
 
@@ -303,6 +304,11 @@ static int ipc_server_config_on_startup(struct ksmbd_startup_request *req)
 		init_smb2_max_trans_size(req->smb2_max_trans);
 	if (req->smb2_max_credits)
 		init_smb2_max_credits(req->smb2_max_credits);
+	if (req->smbd_max_io_size)
+		init_smbd_max_io_size(req->smbd_max_io_size);
+
+	if (req->max_connections)
+		server_conf.max_connections = req->max_connections;
 
 	ret = ksmbd_set_netbios_name(req->netbios_name);
 	ret |= ksmbd_set_server_string(req->server_string);
diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
index a2fd5a4d4cd5..9d67419929d6 100644
--- a/fs/ksmbd/transport_rdma.c
+++ b/fs/ksmbd/transport_rdma.c
@@ -75,7 +75,7 @@ static int smb_direct_max_fragmented_recv_size = 1024 * 1024;
 /*  The maximum single-message size which can be received */
 static int smb_direct_max_receive_size = 8192;
 
-static int smb_direct_max_read_write_size = 1024 * 1024;
+static int smb_direct_max_read_write_size = SMBD_DEFAULT_IOSIZE;
 
 static int smb_direct_max_outstanding_rw_ops = 8;
 
@@ -201,6 +201,12 @@ struct smb_direct_rdma_rw_msg {
 	struct scatterlist	sg_list[0];
 };
 
+void init_smbd_max_io_size(unsigned int sz)
+{
+	sz = clamp_val(sz, SMBD_MIN_IOSIZE, SMBD_MAX_IOSIZE);
+	smb_direct_max_read_write_size = sz;
+}
+
 static inline int get_buf_page_count(void *buf, int size)
 {
 	return DIV_ROUND_UP((uintptr_t)buf + size, PAGE_SIZE) -
diff --git a/fs/ksmbd/transport_rdma.h b/fs/ksmbd/transport_rdma.h
index 0fa8adc0776f..04a7a37685c3 100644
--- a/fs/ksmbd/transport_rdma.h
+++ b/fs/ksmbd/transport_rdma.h
@@ -9,6 +9,10 @@
 
 #define SMB_DIRECT_PORT	5445
 
+#define SMBD_DEFAULT_IOSIZE (8 * 1024 * 1024)
+#define SMBD_MIN_IOSIZE (512 * 1024)
+#define SMBD_MAX_IOSIZE (16 * 1024 * 1024)
+
 /* SMB DIRECT negotiation request packet [MS-SMBD] 2.2.1 */
 struct smb_direct_negotiate_req {
 	__le16 min_version;
@@ -54,10 +58,12 @@ struct smb_direct_data_transfer {
 int ksmbd_rdma_init(void);
 int ksmbd_rdma_destroy(void);
 bool ksmbd_rdma_capable_netdev(struct net_device *netdev);
+void init_smbd_max_io_size(unsigned int sz);
 #else
 static inline int ksmbd_rdma_init(void) { return 0; }
 static inline int ksmbd_rdma_destroy(void) { return 0; }
 static inline bool ksmbd_rdma_capable_netdev(struct net_device *netdev) { return false; }
+static inline void init_smbd_max_io_size(unsigned int sz) { }
 #endif
 
 #endif /* __KSMBD_TRANSPORT_RDMA_H__ */
diff --git a/fs/ksmbd/transport_tcp.c b/fs/ksmbd/transport_tcp.c
index 293af921f2ad..e0ca6cc04b91 100644
--- a/fs/ksmbd/transport_tcp.c
+++ b/fs/ksmbd/transport_tcp.c
@@ -15,6 +15,8 @@
 #define IFACE_STATE_DOWN		BIT(0)
 #define IFACE_STATE_CONFIGURED		BIT(1)
 
+static atomic_t active_num_conn;
+
 struct interface {
 	struct task_struct	*ksmbd_kthread;
 	struct socket		*ksmbd_socket;
@@ -185,8 +187,10 @@ static int ksmbd_tcp_new_connection(struct socket *client_sk)
 	struct tcp_transport *t;
 
 	t = alloc_transport(client_sk);
-	if (!t)
+	if (!t) {
+		sock_release(client_sk);
 		return -ENOMEM;
+	}
 
 	csin = KSMBD_TCP_PEER_SOCKADDR(KSMBD_TRANS(t)->conn);
 	if (kernel_getpeername(client_sk, csin) < 0) {
@@ -239,6 +243,15 @@ static int ksmbd_kthread_fn(void *p)
 			continue;
 		}
 
+		if (server_conf.max_connections &&
+		    atomic_inc_return(&active_num_conn) >= server_conf.max_connections) {
+			pr_info_ratelimited("Limit the maximum number of connections(%u)\n",
+					    atomic_read(&active_num_conn));
+			atomic_dec(&active_num_conn);
+			sock_release(client_sk);
+			continue;
+		}
+
 		ksmbd_debug(CONN, "connect success: accepted new connection\n");
 		client_sk->sk->sk_rcvtimeo = KSMBD_TCP_RECV_TIMEOUT;
 		client_sk->sk->sk_sndtimeo = KSMBD_TCP_SEND_TIMEOUT;
@@ -368,6 +381,8 @@ static int ksmbd_tcp_writev(struct ksmbd_transport *t, struct kvec *iov,
 static void ksmbd_tcp_disconnect(struct ksmbd_transport *t)
 {
 	free_transport(TCP_TRANS(t));
+	if (server_conf.max_connections)
+		atomic_dec(&active_num_conn);
 }
 
 static void tcp_destroy_socket(struct socket *ksmbd_socket)
diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 09dd70f79158..0a900b9e39ea 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1205,6 +1205,7 @@ static __be32 nfsd4_ssc_setup_dul(struct nfsd_net *nn, char *ipaddr,
 			/* allow 20secs for mount/unmount for now - revisit */
 			if (signal_pending(current) ||
 					(schedule_timeout(20*HZ) == 0)) {
+				finish_wait(&nn->nfsd_ssc_waitq, &wait);
 				kfree(work);
 				return nfserr_eagain;
 			}
diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index e040970408d4..ef0bf98b620d 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -960,6 +960,10 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 	if (err)
 		return err;
 
+	if (!kuid_has_mapping(current_user_ns(), ctx.stat.uid) ||
+	    !kgid_has_mapping(current_user_ns(), ctx.stat.gid))
+		return -EOVERFLOW;
+
 	ctx.metacopy = ovl_need_meta_copy_up(dentry, ctx.stat.mode, flags);
 
 	if (parent) {
diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 013fc5931bc3..0b7a00ed6c49 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -16,6 +16,7 @@
 #include <linux/module.h>
 #include <linux/bpf-cgroup.h>
 #include <linux/mount.h>
+#include <linux/kmemleak.h>
 #include "internal.h"
 
 static const struct dentry_operations proc_sys_dentry_operations;
@@ -1384,6 +1385,38 @@ struct ctl_table_header *register_sysctl(const char *path, struct ctl_table *tab
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
index 58481f8d63d5..f7b05c6b3dcf 100644
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
 
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 66a1f495f01a..025391be1b19 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -643,6 +643,11 @@ struct gov_attr_set {
 /* sysfs ops for cpufreq governors */
 extern const struct sysfs_ops governor_sysfs_ops;
 
+static inline struct gov_attr_set *to_gov_attr_set(struct kobject *kobj)
+{
+	return container_of(kobj, struct gov_attr_set, kobj);
+}
+
 void gov_attr_set_init(struct gov_attr_set *attr_set, struct list_head *list_node);
 void gov_attr_set_get(struct gov_attr_set *attr_set, struct list_head *list_node);
 unsigned int gov_attr_set_put(struct gov_attr_set *attr_set, struct list_head *list_node);
diff --git a/include/linux/gpio/driver.h b/include/linux/gpio/driver.h
index ad479db8f0aa..11c26ae7b4fa 100644
--- a/include/linux/gpio/driver.h
+++ b/include/linux/gpio/driver.h
@@ -425,7 +425,7 @@ struct gpio_chip {
 	void __iomem *reg_dir_in;
 	bool bgpio_dir_unreadable;
 	int bgpio_bits;
-	spinlock_t bgpio_lock;
+	raw_spinlock_t bgpio_lock;
 	unsigned long bgpio_data;
 	unsigned long bgpio_dir;
 #endif /* CONFIG_GPIO_GENERIC */
diff --git a/include/linux/panic.h b/include/linux/panic.h
index f5844908a089..8eb5897c164f 100644
--- a/include/linux/panic.h
+++ b/include/linux/panic.h
@@ -11,16 +11,11 @@ extern long (*panic_blink)(int state);
 __printf(1, 2)
 void panic(const char *fmt, ...) __noreturn __cold;
 void nmi_panic(struct pt_regs *regs, const char *msg);
+void check_panic_on_warn(const char *origin);
 extern void oops_enter(void);
 extern void oops_exit(void);
 extern bool oops_may_print(void);
 
-#ifdef CONFIG_SMP
-extern unsigned int sysctl_oops_all_cpu_backtrace;
-#else
-#define sysctl_oops_all_cpu_backtrace 0
-#endif /* CONFIG_SMP */
-
 extern int panic_timeout;
 extern unsigned long panic_print;
 extern int panic_on_oops;
diff --git a/include/linux/sched/task.h b/include/linux/sched/task.h
index caae8e045160..d351f1b362ef 100644
--- a/include/linux/sched/task.h
+++ b/include/linux/sched/task.h
@@ -59,6 +59,7 @@ extern void sched_post_fork(struct task_struct *p);
 extern void sched_dead(struct task_struct *p);
 
 void __noreturn do_task_dead(void);
+void __noreturn make_task_dead(int signr);
 
 extern void proc_caches_init(void);
 
diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index fa372b4c2313..47cf70c8eb93 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -206,6 +206,9 @@ struct ctl_table_header *register_sysctl_paths(const struct ctl_path *path,
 void unregister_sysctl_table(struct ctl_table_header * table);
 
 extern int sysctl_init(void);
+extern void __register_sysctl_init(const char *path, struct ctl_table *table,
+				 const char *table_name);
+#define register_sysctl_init(path, table) __register_sysctl_init(path, table, #table)
 void do_sysctl_args(void);
 
 extern int pwrsw_enabled;
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index c314893970b3..b94314ed0c96 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -92,6 +92,7 @@ struct thermal_cooling_device_ops {
 struct thermal_cooling_device {
 	int id;
 	char *type;
+	unsigned long max_state;
 	struct device device;
 	struct device_node *np;
 	void *devdata;
@@ -113,7 +114,7 @@ struct thermal_cooling_device {
  * @trip_hyst_attrs:	attributes for trip points for sysfs: trip hysteresis
  * @mode:		current mode of this thermal zone
  * @devdata:	private pointer for device private data
- * @trips:	number of trip points the thermal zone supports
+ * @num_trips:	number of trip points the thermal zone supports
  * @trips_disabled;	bitmap for disabled trips
  * @passive_delay_jiffies: number of jiffies to wait between polls when
  *			performing passive cooling.
@@ -153,7 +154,7 @@ struct thermal_zone_device {
 	struct thermal_attr *trip_hyst_attrs;
 	enum thermal_device_mode mode;
 	void *devdata;
-	int trips;
+	int num_trips;
 	unsigned long trips_disabled;	/* bitmap for disabled trips */
 	unsigned long passive_delay_jiffies;
 	unsigned long polling_delay_jiffies;
diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 891b44d80c98..6906da5c733e 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -1335,4 +1335,11 @@ void mini_qdisc_pair_block_init(struct mini_Qdisc_pair *miniqp,
 
 int sch_frag_xmit_hook(struct sk_buff *skb, int (*xmit)(struct sk_buff *skb));
 
+/* Make sure qdisc is no longer in SCHED state. */
+static inline void qdisc_synchronize(const struct Qdisc *q)
+{
+	while (test_bit(__QDISC_STATE_SCHED, &q->state))
+		msleep(1);
+}
+
 #endif
diff --git a/include/net/sock.h b/include/net/sock.h
index e1a303e4f0f7..3e9db5146765 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -323,7 +323,7 @@ struct bpf_local_storage;
   *	@sk_tskey: counter to disambiguate concurrent tstamp requests
   *	@sk_zckey: counter to order MSG_ZEROCOPY notifications
   *	@sk_socket: Identd and reporting IO signals
-  *	@sk_user_data: RPC layer private data
+  *	@sk_user_data: RPC layer private data. Write-protected by @sk_callback_lock.
   *	@sk_frag: cached page frag
   *	@sk_peek_off: current peek_offset value
   *	@sk_send_head: front of stuff to transmit
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 0f2f149ad916..304ccf153928 100644
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
index 488225bb42f6..49e51fc0c2f4 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2653,7 +2653,9 @@ static int check_stack_write_fixed_off(struct bpf_verifier_env *env,
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
index aefe7445508d..80efdfda6662 100644
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
@@ -877,6 +924,31 @@ void __noreturn do_exit(long code)
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
diff --git a/kernel/kcsan/kcsan_test.c b/kernel/kcsan/kcsan_test.c
index dc55fd5a36fc..8b176aeab91b 100644
--- a/kernel/kcsan/kcsan_test.c
+++ b/kernel/kcsan/kcsan_test.c
@@ -151,7 +151,7 @@ static bool report_matches(const struct expect_report *r)
 	const bool is_assert = (r->access[0].type | r->access[1].type) & KCSAN_ACCESS_ASSERT;
 	bool ret = false;
 	unsigned long flags;
-	typeof(observed.lines) expect;
+	typeof(*observed.lines) *expect;
 	const char *end;
 	char *cur;
 	int i;
@@ -160,6 +160,10 @@ static bool report_matches(const struct expect_report *r)
 	if (!report_available())
 		return false;
 
+	expect = kmalloc(sizeof(observed.lines), GFP_KERNEL);
+	if (WARN_ON(!expect))
+		return false;
+
 	/* Generate expected report contents. */
 
 	/* Title */
@@ -243,6 +247,7 @@ static bool report_matches(const struct expect_report *r)
 		strstr(observed.lines[2], expect[1])));
 out:
 	spin_unlock_irqrestore(&observed.lock, flags);
+	kfree(expect);
 	return ret;
 }
 
diff --git a/kernel/kcsan/report.c b/kernel/kcsan/report.c
index 21137929d428..b88d5d5f29e4 100644
--- a/kernel/kcsan/report.c
+++ b/kernel/kcsan/report.c
@@ -432,8 +432,7 @@ static void print_report(enum kcsan_value_change value_change,
 	dump_stack_print_info(KERN_DEFAULT);
 	pr_err("==================================================================\n");
 
-	if (panic_on_warn)
-		panic("panic_on_warn set ...\n");
+	check_panic_on_warn("KCSAN");
 }
 
 static void release_report(unsigned long *flags, struct other_info *other_info)
diff --git a/kernel/module.c b/kernel/module.c
index ef79f4dbda87..8a1766c69c6e 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3665,7 +3665,8 @@ static bool finished_loading(const char *name)
 	sched_annotate_sleep();
 	mutex_lock(&module_mutex);
 	mod = find_module_all(name, strlen(name), true);
-	ret = !mod || mod->state == MODULE_STATE_LIVE;
+	ret = !mod || mod->state == MODULE_STATE_LIVE
+		|| mod->state == MODULE_STATE_GOING;
 	mutex_unlock(&module_mutex);
 
 	return ret;
@@ -3835,20 +3836,35 @@ static int add_unformed_module(struct module *mod)
 
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
index cefd7d82366f..47933d4c769b 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -32,6 +32,7 @@
 #include <linux/bug.h>
 #include <linux/ratelimit.h>
 #include <linux/debugfs.h>
+#include <linux/sysfs.h>
 #include <asm/sections.h>
 
 #define PANIC_TIMER_STEP 100
@@ -42,7 +43,9 @@
  * Should we dump all CPUs backtraces in an oops event?
  * Defaults to 0, can be changed via sysctl.
  */
-unsigned int __read_mostly sysctl_oops_all_cpu_backtrace;
+static unsigned int __read_mostly sysctl_oops_all_cpu_backtrace;
+#else
+#define sysctl_oops_all_cpu_backtrace 0
 #endif /* CONFIG_SMP */
 
 int panic_on_oops = CONFIG_PANIC_ON_OOPS_VALUE;
@@ -55,6 +58,7 @@ bool crash_kexec_post_notifiers;
 int panic_on_warn __read_mostly;
 unsigned long panic_on_taint;
 bool panic_on_taint_nousertaint = false;
+static unsigned int warn_limit __read_mostly;
 
 int panic_timeout = CONFIG_PANIC_TIMEOUT;
 EXPORT_SYMBOL_GPL(panic_timeout);
@@ -71,6 +75,56 @@ ATOMIC_NOTIFIER_HEAD(panic_notifier_list);
 
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
@@ -167,6 +221,19 @@ static void panic_print_sys_info(void)
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
@@ -184,6 +251,16 @@ void panic(const char *fmt, ...)
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
@@ -592,16 +669,7 @@ void __warn(const char *file, int line, void *caller, unsigned taint,
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
index 2bd5e235d078..c1458fa8beb3 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5560,8 +5560,7 @@ static noinline void __schedule_bug(struct task_struct *prev)
 		pr_err("Preemption disabled at:");
 		print_ip_sym(KERN_ERR, preempt_disable_ip);
 	}
-	if (panic_on_warn)
-		panic("scheduling while atomic\n");
+	check_panic_on_warn("scheduling while atomic");
 
 	dump_stack();
 	add_taint(TAINT_WARN, LOCKDEP_STILL_OK);
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 34ce5953dbb0..928798f89ca1 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -2220,17 +2220,6 @@ static struct ctl_table kern_table[] = {
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
index 114d94d1e0a9..06ff4dea34d0 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -10217,6 +10217,8 @@ void __init early_trace_init(void)
 			static_key_enable(&tracepoint_printk_key.key);
 	}
 	tracer_alloc_buffers();
+
+	init_events();
 }
 
 void __init trace_init(void)
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 9fc598165f3a..66b6c8395fbc 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -1500,6 +1500,7 @@ extern void trace_event_enable_cmd_record(bool enable);
 extern void trace_event_enable_tgid_record(bool enable);
 
 extern int event_trace_init(void);
+extern int init_events(void);
 extern int event_trace_add_tracer(struct dentry *parent, struct trace_array *tr);
 extern int event_trace_del_tracer(struct trace_array *tr);
 extern void __trace_early_add_events(struct trace_array *tr);
diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index cc1a078f7a16..aaf779ee68a6 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -1699,6 +1699,8 @@ static struct hist_field *create_hist_field(struct hist_trigger_data *hist_data,
 		hist_field->fn = flags & HIST_FIELD_FL_LOG2 ? hist_field_log2 :
 			hist_field_bucket;
 		hist_field->operands[0] = create_hist_field(hist_data, field, fl, NULL);
+		if (!hist_field->operands[0])
+			goto free;
 		hist_field->size = hist_field->operands[0]->size;
 		hist_field->type = kstrdup_const(hist_field->operands[0]->type, GFP_KERNEL);
 		if (!hist_field->type)
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index c2ca40e8595b..6b4d3f3abdae 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -1569,7 +1569,7 @@ static struct trace_event *events[] __initdata = {
 	NULL
 };
 
-__init static int init_events(void)
+__init int init_events(void)
 {
 	struct trace_event *event;
 	int i, ret;
@@ -1587,4 +1587,3 @@ __init static int init_events(void)
 
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
index 86029ad5ead4..73635bdb0062 100644
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
index bdc380ff5d5c..60c7099857a0 100644
--- a/lib/ubsan.c
+++ b/lib/ubsan.c
@@ -154,16 +154,7 @@ static void ubsan_epilogue(void)
 
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
 
 void __ubsan_handle_divrem_overflow(void *_data, void *lhs, void *rhs)
diff --git a/mm/kasan/report.c b/mm/kasan/report.c
index 884a950c7026..887af873733b 100644
--- a/mm/kasan/report.c
+++ b/mm/kasan/report.c
@@ -117,16 +117,8 @@ static void end_report(unsigned long *flags, unsigned long addr)
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
 	if (kasan_arg_fault == KASAN_ARG_FAULT_PANIC)
 		panic("kasan.fault=panic set ...\n");
 	kasan_enable_current();
diff --git a/mm/kfence/report.c b/mm/kfence/report.c
index 37e140e7f201..cbd9456359b9 100644
--- a/mm/kfence/report.c
+++ b/mm/kfence/report.c
@@ -267,8 +267,7 @@ void kfence_report_error(unsigned long address, bool is_write, struct pt_regs *r
 
 	lockdep_on();
 
-	if (panic_on_warn)
-		panic("panic_on_warn set ...\n");
+	check_panic_on_warn("KFENCE");
 
 	/* We encountered a memory safety error, taint the kernel! */
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_STILL_OK);
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index a41b4dcf1a7a..cabe8eb4c14f 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1632,6 +1632,7 @@ static int hci_dev_do_open(struct hci_dev *hdev)
 			hdev->flush(hdev);
 
 		if (hdev->sent_cmd) {
+			cancel_delayed_work_sync(&hdev->cmd_timer);
 			kfree_skb(hdev->sent_cmd);
 			hdev->sent_cmd = NULL;
 		}
diff --git a/net/bluetooth/rfcomm/sock.c b/net/bluetooth/rfcomm/sock.c
index 21e24da4847f..4397e14ff560 100644
--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -391,6 +391,7 @@ static int rfcomm_sock_connect(struct socket *sock, struct sockaddr *addr, int a
 	    addr->sa_family != AF_BLUETOOTH)
 		return -EINVAL;
 
+	sock_hold(sk);
 	lock_sock(sk);
 
 	if (sk->sk_state != BT_OPEN && sk->sk_state != BT_BOUND) {
@@ -410,14 +411,18 @@ static int rfcomm_sock_connect(struct socket *sock, struct sockaddr *addr, int a
 	d->sec_level = rfcomm_pi(sk)->sec_level;
 	d->role_switch = rfcomm_pi(sk)->role_switch;
 
+	/* Drop sock lock to avoid potential deadlock with the RFCOMM lock */
+	release_sock(sk);
 	err = rfcomm_dlc_open(d, &rfcomm_pi(sk)->src, &sa->rc_bdaddr,
 			      sa->rc_channel);
-	if (!err)
+	lock_sock(sk);
+	if (!err && !sock_flag(sk, SOCK_ZAPPED))
 		err = bt_sock_wait_state(sk, BT_CONNECTED,
 				sock_sndtimeo(sk, flags & O_NONBLOCK));
 
 done:
 	release_sock(sk);
+	sock_put(sk);
 	return err;
 }
 
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 982d06332007..dcddc54d0840 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -137,12 +137,12 @@ static int ops_init(const struct pernet_operations *ops, struct net *net)
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
index 250af6e5a892..607a4f816155 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -30,6 +30,7 @@
 #include <linux/slab.h>
 #include <linux/netlink.h>
 #include <linux/hash.h>
+#include <linux/nospec.h>
 
 #include <net/arp.h>
 #include <net/ip.h>
@@ -1020,6 +1021,7 @@ bool fib_metrics_match(struct fib_config *cfg, struct fib_info *fi)
 		if (type > RTAX_MAX)
 			return false;
 
+		type = array_index_nospec(type, RTAX_MAX + 1);
 		if (type == RTAX_CC_ALGO) {
 			char tmp[TCP_CA_NAME_MAX];
 			bool ecn_ca = false;
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 0d378da4b1b1..410b6b7998ca 100644
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
index 437afe392e66..fe6340c363b4 100644
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
index 25ea6ac44db9..6a1427916c7d 100644
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
index fe1972aad279..51f34560a9d6 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -439,6 +439,7 @@ void tcp_init_sock(struct sock *sk)
 
 	/* There's a bubble in the pipe until at least the first ACK. */
 	tp->app_limited = ~0U;
+	tp->rate_app_limited = 1;
 
 	/* See draft-stevens-tcpca-spec-01 for discussion of the
 	 * initialization of these values.
@@ -3066,6 +3067,7 @@ int tcp_disconnect(struct sock *sk, int flags)
 	tp->last_oow_ack_time = 0;
 	/* There's a bubble in the pipe until at least the first ACK. */
 	tp->app_limited = ~0U;
+	tp->rate_app_limited = 1;
 	tp->rack.mstamp = 0;
 	tp->rack.advanced = 0;
 	tp->rack.reo_wnd_steps = 1;
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 675a80dd78ba..383442ded954 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -527,7 +527,20 @@ int ip6_forward(struct sk_buff *skb)
 	    pneigh_lookup(&nd_tbl, net, &hdr->daddr, skb->dev, 0)) {
 		int proxied = ip6_forward_proxy_check(skb);
 		if (proxied > 0) {
-			hdr->hop_limit--;
+			/* It's tempting to decrease the hop limit
+			 * here by 1, as we do at the end of the
+			 * function too.
+			 *
+			 * But that would be incorrect, as proxying is
+			 * not forwarding.  The ip6_input function
+			 * will handle this packet locally, and it
+			 * depends on the hop limit being unchanged.
+			 *
+			 * One example is the NDP hop limit, that
+			 * always has to stay 255, but other would be
+			 * similar checks around RA packets, where the
+			 * user can even change the desired limit.
+			 */
 			return ip6_input(skb);
 		} else if (proxied < 0) {
 			__IP6_INC_STATS(net, idev, IPSTATS_MIB_INDISCARDS);
diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 93271a2632b8..a2b13e213e06 100644
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
diff --git a/net/mctp/af_mctp.c b/net/mctp/af_mctp.c
index cbbde0f73a08..a77fafbc31cf 100644
--- a/net/mctp/af_mctp.c
+++ b/net/mctp/af_mctp.c
@@ -288,6 +288,7 @@ static void mctp_sk_unhash(struct sock *sk)
 
 		kfree_rcu(key, rcu);
 	}
+	sock_set_flag(sk, SOCK_DEAD);
 	spin_unlock_irqrestore(&net->mctp.keys_lock, flags);
 
 	synchronize_rcu();
diff --git a/net/mctp/route.c b/net/mctp/route.c
index 6aebb4a3eded..89e67399249b 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -135,6 +135,11 @@ static int mctp_key_add(struct mctp_sk_key *key, struct mctp_sock *msk)
 
 	spin_lock_irqsave(&net->mctp.keys_lock, flags);
 
+	if (sock_flag(&msk->sk, SOCK_DEAD)) {
+		rc = -EINVAL;
+		goto out_unlock;
+	}
+
 	hlist_for_each_entry(tmp, &net->mctp.keys, hlist) {
 		if (mctp_key_match(tmp, key->local_addr, key->peer_addr,
 				   key->tag)) {
@@ -148,6 +153,7 @@ static int mctp_key_add(struct mctp_sk_key *key, struct mctp_sock *msk)
 		hlist_add_head(&key->sklist, &msk->keys);
 	}
 
+out_unlock:
 	spin_unlock_irqrestore(&net->mctp.keys_lock, flags);
 
 	return rc;
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 5a936334b517..895e0ca54299 100644
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
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 4d85368203e0..338f02a12076 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -599,7 +599,6 @@ enum nf_ct_sysctl_index {
 	NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_SHUTDOWN_RECD,
 	NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_SHUTDOWN_ACK_SENT,
 	NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_HEARTBEAT_SENT,
-	NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_HEARTBEAT_ACKED,
 #endif
 #ifdef CONFIG_NF_CT_PROTO_DCCP
 	NF_SYSCTL_CT_PROTO_TIMEOUT_DCCP_REQUEST,
@@ -892,12 +891,6 @@ static struct ctl_table nf_ct_sysctl_table[] = {
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
@@ -1041,7 +1034,6 @@ static void nf_conntrack_standalone_init_sctp_sysctl(struct net *net,
 	XASSIGN(SHUTDOWN_RECD, sn);
 	XASSIGN(SHUTDOWN_ACK_SENT, sn);
 	XASSIGN(HEARTBEAT_SENT, sn);
-	XASSIGN(HEARTBEAT_ACKED, sn);
 #undef XASSIGN
 #endif
 }
diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 7325bee7d144..19ea4d3c3553 100644
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
@@ -215,154 +215,216 @@ static void *nft_rbtree_get(const struct net *net, const struct nft_set *set,
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
@@ -501,23 +563,37 @@ static void nft_rbtree_gc(struct work_struct *work)
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
index 974d32632ef4..011ec7d9a719 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -578,7 +578,9 @@ static int netlink_insert(struct sock *sk, u32 portid)
 	if (nlk_sk(sk)->bound)
 		goto err;
 
-	nlk_sk(sk)->portid = portid;
+	/* portid can be read locklessly from netlink_getname(). */
+	WRITE_ONCE(nlk_sk(sk)->portid, portid);
+
 	sock_hold(sk);
 
 	err = __netlink_insert(table, sk);
@@ -1087,9 +1089,11 @@ static int netlink_connect(struct socket *sock, struct sockaddr *addr,
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
@@ -1110,9 +1114,11 @@ static int netlink_connect(struct socket *sock, struct sockaddr *addr,
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
@@ -1129,10 +1135,12 @@ static int netlink_getname(struct socket *sock, struct sockaddr *addr,
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
@@ -1159,8 +1167,9 @@ static struct sock *netlink_getsockbyportid(struct sock *ssk, u32 portid)
 
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
@@ -1896,8 +1905,9 @@ static int netlink_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
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
index eaeb2b1cfa6a..fd43e75abd94 100644
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
diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index caabdaa2f30f..45b92e40082e 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -1558,7 +1558,7 @@ static int htb_destroy_class_offload(struct Qdisc *sch, struct htb_class *cl,
 	struct tc_htb_qopt_offload offload_opt;
 	struct netdev_queue *dev_queue;
 	struct Qdisc *q = cl->leaf.q;
-	struct Qdisc *old = NULL;
+	struct Qdisc *old;
 	int err;
 
 	if (cl->level)
@@ -1566,14 +1566,17 @@ static int htb_destroy_class_offload(struct Qdisc *sch, struct htb_class *cl,
 
 	WARN_ON(!q);
 	dev_queue = htb_offload_get_queue(cl);
-	old = htb_graft_helper(dev_queue, NULL);
-	if (destroying)
-		/* Before HTB is destroyed, the kernel grafts noop_qdisc to
-		 * all queues.
+	/* When destroying, caller qdisc_graft grafts the new qdisc and invokes
+	 * qdisc_put for the qdisc being destroyed. htb_destroy_class_offload
+	 * does not need to graft or qdisc_put the qdisc being destroyed.
+	 */
+	if (!destroying) {
+		old = htb_graft_helper(dev_queue, NULL);
+		/* Last qdisc grafted should be the same as cl->leaf.q when
+		 * calling htb_delete.
 		 */
-		WARN_ON(!(old->flags & TCQ_F_BUILTIN));
-	else
 		WARN_ON(old != q);
+	}
 
 	if (cl->parent) {
 		cl->parent->bstats_bias.bytes += q->bstats.bytes;
@@ -1589,10 +1592,12 @@ static int htb_destroy_class_offload(struct Qdisc *sch, struct htb_class *cl,
 	};
 	err = htb_offload(qdisc_dev(sch), &offload_opt);
 
-	if (!err || destroying)
-		qdisc_put(old);
-	else
-		htb_graft_helper(dev_queue, old);
+	if (!destroying) {
+		if (!err)
+			qdisc_put(old);
+		else
+			htb_graft_helper(dev_queue, old);
+	}
 
 	if (last_child)
 		return err;
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index bd10a8eeb82d..135ea8b3816f 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1632,6 +1632,7 @@ static void taprio_reset(struct Qdisc *sch)
 	int i;
 
 	hrtimer_cancel(&q->advance_timer);
+
 	if (q->qdiscs) {
 		for (i = 0; i < dev->num_tx_queues; i++)
 			if (q->qdiscs[i])
@@ -1653,6 +1654,7 @@ static void taprio_destroy(struct Qdisc *sch)
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
diff --git a/scripts/Makefile b/scripts/Makefile
index 9adb6d247818..e2a239829556 100644
--- a/scripts/Makefile
+++ b/scripts/Makefile
@@ -3,8 +3,8 @@
 # scripts contains sources for various helper programs used throughout
 # the kernel for the build process.
 
-CRYPTO_LIBS = $(shell pkg-config --libs libcrypto 2> /dev/null || echo -lcrypto)
-CRYPTO_CFLAGS = $(shell pkg-config --cflags libcrypto 2> /dev/null)
+CRYPTO_LIBS = $(shell $(HOSTPKG_CONFIG) --libs libcrypto 2> /dev/null || echo -lcrypto)
+CRYPTO_CFLAGS = $(shell $(HOSTPKG_CONFIG) --cflags libcrypto 2> /dev/null)
 
 hostprogs-always-$(CONFIG_BUILD_BIN2C)			+= bin2c
 hostprogs-always-$(CONFIG_KALLSYMS)			+= kallsyms
diff --git a/scripts/dtc/Makefile b/scripts/dtc/Makefile
index 1cba78e1dce6..2d5f274d6efd 100644
--- a/scripts/dtc/Makefile
+++ b/scripts/dtc/Makefile
@@ -18,7 +18,7 @@ fdtoverlay-objs	:= $(libfdt) fdtoverlay.o util.o
 # Source files need to get at the userspace version of libfdt_env.h to compile
 HOST_EXTRACFLAGS += -I $(srctree)/$(src)/libfdt
 
-ifeq ($(shell pkg-config --exists yaml-0.1 2>/dev/null && echo yes),)
+ifeq ($(shell $(HOSTPKG_CONFIG) --exists yaml-0.1 2>/dev/null && echo yes),)
 ifneq ($(CHECK_DT_BINDING)$(CHECK_DTBS),)
 $(error dtc needs libyaml for DT schema validation support. \
 	Install the necessary libyaml development package.)
@@ -27,9 +27,9 @@ HOST_EXTRACFLAGS += -DNO_YAML
 else
 dtc-objs	+= yamltree.o
 # To include <yaml.h> installed in a non-default path
-HOSTCFLAGS_yamltree.o := $(shell pkg-config --cflags yaml-0.1)
+HOSTCFLAGS_yamltree.o := $(shell $(HOSTPKG_CONFIG) --cflags yaml-0.1)
 # To link libyaml installed in a non-default path
-HOSTLDLIBS_dtc	:= $(shell pkg-config --libs yaml-0.1)
+HOSTLDLIBS_dtc	:= $(shell $(HOSTPKG_CONFIG) --libs yaml-0.1)
 endif
 
 # Generated files need one more search path to include headers in source tree
diff --git a/scripts/kconfig/gconf-cfg.sh b/scripts/kconfig/gconf-cfg.sh
index 480ecd8b9f41..cbd90c28c05f 100755
--- a/scripts/kconfig/gconf-cfg.sh
+++ b/scripts/kconfig/gconf-cfg.sh
@@ -3,14 +3,14 @@
 
 PKG="gtk+-2.0 gmodule-2.0 libglade-2.0"
 
-if [ -z "$(command -v pkg-config)" ]; then
+if [ -z "$(command -v ${HOSTPKG_CONFIG})" ]; then
 	echo >&2 "*"
-	echo >&2 "* 'make gconfig' requires 'pkg-config'. Please install it."
+	echo >&2 "* 'make gconfig' requires '${HOSTPKG_CONFIG}'. Please install it."
 	echo >&2 "*"
 	exit 1
 fi
 
-if ! pkg-config --exists $PKG; then
+if ! ${HOSTPKG_CONFIG} --exists $PKG; then
 	echo >&2 "*"
 	echo >&2 "* Unable to find the GTK+ installation. Please make sure that"
 	echo >&2 "* the GTK+ 2.0 development package is correctly installed."
@@ -19,12 +19,12 @@ if ! pkg-config --exists $PKG; then
 	exit 1
 fi
 
-if ! pkg-config --atleast-version=2.0.0 gtk+-2.0; then
+if ! ${HOSTPKG_CONFIG} --atleast-version=2.0.0 gtk+-2.0; then
 	echo >&2 "*"
 	echo >&2 "* GTK+ is present but version >= 2.0.0 is required."
 	echo >&2 "*"
 	exit 1
 fi
 
-echo cflags=\"$(pkg-config --cflags $PKG)\"
-echo libs=\"$(pkg-config --libs $PKG)\"
+echo cflags=\"$(${HOSTPKG_CONFIG} --cflags $PKG)\"
+echo libs=\"$(${HOSTPKG_CONFIG} --libs $PKG)\"
diff --git a/scripts/kconfig/mconf-cfg.sh b/scripts/kconfig/mconf-cfg.sh
index b520e407a8eb..025b565e0b7c 100755
--- a/scripts/kconfig/mconf-cfg.sh
+++ b/scripts/kconfig/mconf-cfg.sh
@@ -4,16 +4,16 @@
 PKG="ncursesw"
 PKG2="ncurses"
 
-if [ -n "$(command -v pkg-config)" ]; then
-	if pkg-config --exists $PKG; then
-		echo cflags=\"$(pkg-config --cflags $PKG)\"
-		echo libs=\"$(pkg-config --libs $PKG)\"
+if [ -n "$(command -v ${HOSTPKG_CONFIG})" ]; then
+	if ${HOSTPKG_CONFIG} --exists $PKG; then
+		echo cflags=\"$(${HOSTPKG_CONFIG} --cflags $PKG)\"
+		echo libs=\"$(${HOSTPKG_CONFIG} --libs $PKG)\"
 		exit 0
 	fi
 
-	if pkg-config --exists $PKG2; then
-		echo cflags=\"$(pkg-config --cflags $PKG2)\"
-		echo libs=\"$(pkg-config --libs $PKG2)\"
+	if ${HOSTPKG_CONFIG} --exists $PKG2; then
+		echo cflags=\"$(${HOSTPKG_CONFIG} --cflags $PKG2)\"
+		echo libs=\"$(${HOSTPKG_CONFIG} --libs $PKG2)\"
 		exit 0
 	fi
 fi
@@ -46,7 +46,7 @@ echo >&2 "* Unable to find the ncurses package."
 echo >&2 "* Install ncurses (ncurses-devel or libncurses-dev"
 echo >&2 "* depending on your distribution)."
 echo >&2 "*"
-echo >&2 "* You may also need to install pkg-config to find the"
+echo >&2 "* You may also need to install ${HOSTPKG_CONFIG} to find the"
 echo >&2 "* ncurses installed in a non-default location."
 echo >&2 "*"
 exit 1
diff --git a/scripts/kconfig/nconf-cfg.sh b/scripts/kconfig/nconf-cfg.sh
index c212255070c0..3a10bac2adb3 100755
--- a/scripts/kconfig/nconf-cfg.sh
+++ b/scripts/kconfig/nconf-cfg.sh
@@ -4,16 +4,16 @@
 PKG="ncursesw menuw panelw"
 PKG2="ncurses menu panel"
 
-if [ -n "$(command -v pkg-config)" ]; then
-	if pkg-config --exists $PKG; then
-		echo cflags=\"$(pkg-config --cflags $PKG)\"
-		echo libs=\"$(pkg-config --libs $PKG)\"
+if [ -n "$(command -v ${HOSTPKG_CONFIG})" ]; then
+	if ${HOSTPKG_CONFIG} --exists $PKG; then
+		echo cflags=\"$(${HOSTPKG_CONFIG} --cflags $PKG)\"
+		echo libs=\"$(${HOSTPKG_CONFIG} --libs $PKG)\"
 		exit 0
 	fi
 
-	if pkg-config --exists $PKG2; then
-		echo cflags=\"$(pkg-config --cflags $PKG2)\"
-		echo libs=\"$(pkg-config --libs $PKG2)\"
+	if ${HOSTPKG_CONFIG} --exists $PKG2; then
+		echo cflags=\"$(${HOSTPKG_CONFIG} --cflags $PKG2)\"
+		echo libs=\"$(${HOSTPKG_CONFIG} --libs $PKG2)\"
 		exit 0
 	fi
 fi
@@ -44,7 +44,7 @@ echo >&2 "* Unable to find the ncurses package."
 echo >&2 "* Install ncurses (ncurses-devel or libncurses-dev"
 echo >&2 "* depending on your distribution)."
 echo >&2 "*"
-echo >&2 "* You may also need to install pkg-config to find the"
+echo >&2 "* You may also need to install ${HOSTPKG_CONFIG} to find the"
 echo >&2 "* ncurses installed in a non-default location."
 echo >&2 "*"
 exit 1
diff --git a/scripts/kconfig/qconf-cfg.sh b/scripts/kconfig/qconf-cfg.sh
index fa564cd795b7..9b695e5cd9b3 100755
--- a/scripts/kconfig/qconf-cfg.sh
+++ b/scripts/kconfig/qconf-cfg.sh
@@ -3,22 +3,22 @@
 
 PKG="Qt5Core Qt5Gui Qt5Widgets"
 
-if [ -z "$(command -v pkg-config)" ]; then
+if [ -z "$(command -v ${HOSTPKG_CONFIG})" ]; then
 	echo >&2 "*"
-	echo >&2 "* 'make xconfig' requires 'pkg-config'. Please install it."
+	echo >&2 "* 'make xconfig' requires '${HOSTPKG_CONFIG}'. Please install it."
 	echo >&2 "*"
 	exit 1
 fi
 
-if pkg-config --exists $PKG; then
-	echo cflags=\"-std=c++11 -fPIC $(pkg-config --cflags $PKG)\"
-	echo libs=\"$(pkg-config --libs $PKG)\"
-	echo moc=\"$(pkg-config --variable=host_bins Qt5Core)/moc\"
+if ${HOSTPKG_CONFIG} --exists $PKG; then
+	echo cflags=\"-std=c++11 -fPIC $(${HOSTPKG_CONFIG} --cflags $PKG)\"
+	echo libs=\"$(${HOSTPKG_CONFIG} --libs $PKG)\"
+	echo moc=\"$(${HOSTPKG_CONFIG} --variable=host_bins Qt5Core)/moc\"
 	exit 0
 fi
 
 echo >&2 "*"
-echo >&2 "* Could not find Qt5 via pkg-config."
+echo >&2 "* Could not find Qt5 via ${HOSTPKG_CONFIG}."
 echo >&2 "* Please install Qt5 and make sure it's in PKG_CONFIG_PATH"
 echo >&2 "*"
 exit 1
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
index c72a156737e6..5000d779aade 100644
--- a/sound/soc/fsl/fsl-asoc-card.c
+++ b/sound/soc/fsl/fsl-asoc-card.c
@@ -120,11 +120,11 @@ static const struct snd_soc_dapm_route audio_map[] = {
 
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
index d1cd104f8584..38d4d1b7cfe3 100644
--- a/sound/soc/fsl/fsl_micfil.c
+++ b/sound/soc/fsl/fsl_micfil.c
@@ -88,21 +88,21 @@ static DECLARE_TLV_DB_SCALE(gain_tlv, 0, 100, 0);
 
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
index ecbc1c365d5b..0c73c2e9dce0 100644
--- a/sound/soc/fsl/fsl_ssi.c
+++ b/sound/soc/fsl/fsl_ssi.c
@@ -1160,14 +1160,14 @@ static struct snd_soc_dai_driver fsl_ssi_ac97_dai = {
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
index a2b233fdb572..667019990982 100644
--- a/tools/gpio/gpio-event-mon.c
+++ b/tools/gpio/gpio-event-mon.c
@@ -86,6 +86,7 @@ int monitor_device(const char *device_name,
 			gpiotools_test_bit(values.bits, i));
 	}
 
+	i = 0;
 	while (1) {
 		struct gpio_v2_line_event event;
 
diff --git a/tools/objtool/Makefile b/tools/objtool/Makefile
index 92ce4fce7bc7..549acc5859e9 100644
--- a/tools/objtool/Makefile
+++ b/tools/objtool/Makefile
@@ -19,8 +19,8 @@ LIBSUBCMD		= $(LIBSUBCMD_OUTPUT)libsubcmd.a
 OBJTOOL    := $(OUTPUT)objtool
 OBJTOOL_IN := $(OBJTOOL)-in.o
 
-LIBELF_FLAGS := $(shell pkg-config libelf --cflags 2>/dev/null)
-LIBELF_LIBS  := $(shell pkg-config libelf --libs 2>/dev/null || echo -lelf)
+LIBELF_FLAGS := $(shell $(HOSTPKG_CONFIG) libelf --cflags 2>/dev/null)
+LIBELF_LIBS  := $(shell $(HOSTPKG_CONFIG) libelf --libs 2>/dev/null || echo -lelf)
 
 all: $(OBJTOOL)
 
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 308c8806ad94..758c0ba8de35 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -169,6 +169,7 @@ static bool __dead_end_function(struct objtool_file *file, struct symbol *func,
 		"panic",
 		"do_exit",
 		"do_task_dead",
+		"make_task_dead",
 		"__module_put_and_exit",
 		"complete_and_exit",
 		"__reiserfs_panic",
@@ -176,7 +177,7 @@ static bool __dead_end_function(struct objtool_file *file, struct symbol *func,
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
diff --git a/tools/testing/selftests/net/toeplitz.c b/tools/testing/selftests/net/toeplitz.c
index c5489341cfb8..8ce96028341d 100644
--- a/tools/testing/selftests/net/toeplitz.c
+++ b/tools/testing/selftests/net/toeplitz.c
@@ -213,7 +213,7 @@ static char *recv_frame(const struct ring_state *ring, char *frame)
 }
 
 /* A single TPACKET_V3 block can hold multiple frames */
-static void recv_block(struct ring_state *ring)
+static bool recv_block(struct ring_state *ring)
 {
 	struct tpacket_block_desc *block;
 	char *frame;
@@ -221,7 +221,7 @@ static void recv_block(struct ring_state *ring)
 
 	block = (void *)(ring->mmap + ring->idx * ring_block_sz);
 	if (!(block->hdr.bh1.block_status & TP_STATUS_USER))
-		return;
+		return false;
 
 	frame = (char *)block;
 	frame += block->hdr.bh1.offset_to_first_pkt;
@@ -233,6 +233,8 @@ static void recv_block(struct ring_state *ring)
 
 	block->hdr.bh1.block_status = TP_STATUS_KERNEL;
 	ring->idx = (ring->idx + 1) % ring_block_nr;
+
+	return true;
 }
 
 /* simple test: sleep once unconditionally and then process all rings */
@@ -243,7 +245,7 @@ static void process_rings(void)
 	usleep(1000 * cfg_timeout_msec);
 
 	for (i = 0; i < num_cpus; i++)
-		recv_block(&rings[i]);
+		do {} while (recv_block(&rings[i]));
 
 	fprintf(stderr, "count: pass=%u nohash=%u fail=%u\n",
 		frames_received - frames_nohash - frames_error,
@@ -255,12 +257,12 @@ static char *setup_ring(int fd)
 	struct tpacket_req3 req3 = {0};
 	void *ring;
 
-	req3.tp_retire_blk_tov = cfg_timeout_msec;
+	req3.tp_retire_blk_tov = cfg_timeout_msec / 8;
 	req3.tp_feature_req_word = TP_FT_REQ_FILL_RXHASH;
 
 	req3.tp_frame_size = 2048;
 	req3.tp_frame_nr = 1 << 10;
-	req3.tp_block_nr = 2;
+	req3.tp_block_nr = 16;
 
 	req3.tp_block_size = req3.tp_frame_size * req3.tp_frame_nr;
 	req3.tp_block_size /= req3.tp_block_nr;
