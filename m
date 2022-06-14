Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B710F54B498
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 17:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356820AbiFNP0B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 11:26:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354593AbiFNPZ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 11:25:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EA67237ED;
        Tue, 14 Jun 2022 08:25:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C8ED6119F;
        Tue, 14 Jun 2022 15:25:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D8F1C3411D;
        Tue, 14 Jun 2022 15:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655220324;
        bh=nohb/yHiCM3Cy5z7bxWJcAVxH5IGFIXOQUmm/sbsHVo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eitjh+LiFcu54esvALLLuSlABYkPt3r2sF/3yx/vfjASzoYZjA+pKh46hp/+Nxm1W
         d253j828LGIvI23Gub0kYw2y2d75XCVtmiR2CnVPomt7hO4FR1sERUSvICKwsqYGKo
         t1DdfDt7XqyuPTXS0YeycooZ92kAcw3CCIOmXVWc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.14.283
Date:   Tue, 14 Jun 2022 17:25:12 +0200
Message-Id: <1655220311133102@kroah.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <165522031144113@kroah.com>
References: <165522031144113@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Documentation/ABI/testing/sysfs-ata b/Documentation/ABI/testing/sysfs-ata
index aa4296498859..c5dda2bc477d 100644
--- a/Documentation/ABI/testing/sysfs-ata
+++ b/Documentation/ABI/testing/sysfs-ata
@@ -59,17 +59,18 @@ class
 
 dma_mode
 
-	Transfer modes supported by the device when in DMA mode.
+	DMA transfer mode used by the device.
 	Mostly used by PATA device.
 
 pio_mode
 
-	Transfer modes supported by the device when in PIO mode.
+	PIO transfer mode used by the device.
 	Mostly used by PATA device.
 
 xfer_mode
 
 	Current transfer mode.
+	Mostly used by PATA device.
 
 id
 
diff --git a/Documentation/conf.py b/Documentation/conf.py
index 329c519158b6..2f74cf1d56f5 100644
--- a/Documentation/conf.py
+++ b/Documentation/conf.py
@@ -96,7 +96,7 @@ finally:
 #
 # This is also used if you do content translation via gettext catalogs.
 # Usually you set "language" from the command line for these cases.
-language = None
+language = 'en'
 
 # There are two options for replacing |today|: either, you set today to some
 # non-false value, then it is used:
diff --git a/Documentation/devicetree/bindings/gpio/gpio-altera.txt b/Documentation/devicetree/bindings/gpio/gpio-altera.txt
index 826a7208ca93..184ecd6bc39d 100644
--- a/Documentation/devicetree/bindings/gpio/gpio-altera.txt
+++ b/Documentation/devicetree/bindings/gpio/gpio-altera.txt
@@ -9,8 +9,9 @@ Required properties:
   - The second cell is reserved and is currently unused.
 - gpio-controller : Marks the device node as a GPIO controller.
 - interrupt-controller: Mark the device node as an interrupt controller
-- #interrupt-cells : Should be 1. The interrupt type is fixed in the hardware.
+- #interrupt-cells : Should be 2. The interrupt type is fixed in the hardware.
   - The first cell is the GPIO offset number within the GPIO controller.
+  - The second cell is the interrupt trigger type and level flags.
 - interrupts: Specify the interrupt.
 - altr,interrupt-type: Specifies the interrupt trigger type the GPIO
   hardware is synthesized. This field is required if the Altera GPIO controller
@@ -38,6 +39,6 @@ gpio_altr: gpio@0xff200000 {
 	altr,interrupt-type = <IRQ_TYPE_EDGE_RISING>;
 	#gpio-cells = <2>;
 	gpio-controller;
-	#interrupt-cells = <1>;
+	#interrupt-cells = <2>;
 	interrupt-controller;
 };
diff --git a/Makefile b/Makefile
index 14820e213362..a1fc5a832663 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 14
-SUBLEVEL = 282
+SUBLEVEL = 283
 EXTRAVERSION =
 NAME = Petit Gorille
 
diff --git a/arch/arm/boot/dts/bcm2835-rpi-b.dts b/arch/arm/boot/dts/bcm2835-rpi-b.dts
index cca4a75a5651..6f39d5e54cb8 100644
--- a/arch/arm/boot/dts/bcm2835-rpi-b.dts
+++ b/arch/arm/boot/dts/bcm2835-rpi-b.dts
@@ -48,18 +48,17 @@
 			  "GPIO18",
 			  "NC", /* GPIO19 */
 			  "NC", /* GPIO20 */
-			  "GPIO21",
+			  "CAM_GPIO0",
 			  "GPIO22",
 			  "GPIO23",
 			  "GPIO24",
 			  "GPIO25",
 			  "NC", /* GPIO26 */
-			  "CAM_GPIO0",
-			  /* Binary number representing build/revision */
-			  "CONFIG0",
-			  "CONFIG1",
-			  "CONFIG2",
-			  "CONFIG3",
+			  "GPIO27",
+			  "GPIO28",
+			  "GPIO29",
+			  "GPIO30",
+			  "GPIO31",
 			  "NC", /* GPIO32 */
 			  "NC", /* GPIO33 */
 			  "NC", /* GPIO34 */
diff --git a/arch/arm/boot/dts/bcm2835-rpi-zero-w.dts b/arch/arm/boot/dts/bcm2835-rpi-zero-w.dts
index 120776d45441..932e0e6320c5 100644
--- a/arch/arm/boot/dts/bcm2835-rpi-zero-w.dts
+++ b/arch/arm/boot/dts/bcm2835-rpi-zero-w.dts
@@ -77,16 +77,18 @@
 			  "GPIO27",
 			  "SDA0",
 			  "SCL0",
-			  "NC", /* GPIO30 */
-			  "NC", /* GPIO31 */
-			  "NC", /* GPIO32 */
-			  "NC", /* GPIO33 */
-			  "NC", /* GPIO34 */
-			  "NC", /* GPIO35 */
-			  "NC", /* GPIO36 */
-			  "NC", /* GPIO37 */
-			  "NC", /* GPIO38 */
-			  "NC", /* GPIO39 */
+			  /* Used by BT module */
+			  "CTS0",
+			  "RTS0",
+			  "TXD0",
+			  "RXD0",
+			  /* Used by Wifi */
+			  "SD1_CLK",
+			  "SD1_CMD",
+			  "SD1_DATA0",
+			  "SD1_DATA1",
+			  "SD1_DATA2",
+			  "SD1_DATA3",
 			  "CAM_GPIO1", /* GPIO40 */
 			  "WL_ON", /* GPIO41 */
 			  "NC", /* GPIO42 */
diff --git a/arch/arm/boot/dts/exynos5250-smdk5250.dts b/arch/arm/boot/dts/exynos5250-smdk5250.dts
index a3c4b9e03fbf..dc539a4eb27a 100644
--- a/arch/arm/boot/dts/exynos5250-smdk5250.dts
+++ b/arch/arm/boot/dts/exynos5250-smdk5250.dts
@@ -128,7 +128,7 @@
 	samsung,i2c-max-bus-freq = <20000>;
 
 	eeprom@50 {
-		compatible = "samsung,s524ad0xd1";
+		compatible = "samsung,s524ad0xd1", "atmel,24c128";
 		reg = <0x50>;
 	};
 
@@ -287,7 +287,7 @@
 	samsung,i2c-max-bus-freq = <20000>;
 
 	eeprom@51 {
-		compatible = "samsung,s524ad0xd1";
+		compatible = "samsung,s524ad0xd1", "atmel,24c128";
 		reg = <0x51>;
 	};
 
diff --git a/arch/arm/boot/dts/ox820.dtsi b/arch/arm/boot/dts/ox820.dtsi
index 8355cb034525..3382b1a9cac9 100644
--- a/arch/arm/boot/dts/ox820.dtsi
+++ b/arch/arm/boot/dts/ox820.dtsi
@@ -286,7 +286,7 @@
 				clocks = <&armclk>;
 			};
 
-			gic: gic@1000 {
+			gic: interrupt-controller@1000 {
 				compatible = "arm,arm11mp-gic";
 				interrupt-controller;
 				#interrupt-cells = <3>;
diff --git a/arch/arm/mach-hisi/platsmp.c b/arch/arm/mach-hisi/platsmp.c
index da5689ababf7..d7fbfb6d293d 100644
--- a/arch/arm/mach-hisi/platsmp.c
+++ b/arch/arm/mach-hisi/platsmp.c
@@ -70,14 +70,17 @@ static void __init hi3xxx_smp_prepare_cpus(unsigned int max_cpus)
 		}
 		ctrl_base = of_iomap(np, 0);
 		if (!ctrl_base) {
+			of_node_put(np);
 			pr_err("failed to map address\n");
 			return;
 		}
 		if (of_property_read_u32(np, "smp-offset", &offset) < 0) {
+			of_node_put(np);
 			pr_err("failed to find smp-offset property\n");
 			return;
 		}
 		ctrl_base += offset;
+		of_node_put(np);
 	}
 }
 
@@ -163,6 +166,7 @@ static int hip01_boot_secondary(unsigned int cpu, struct task_struct *idle)
 	if (WARN_ON(!node))
 		return -1;
 	ctrl_base = of_iomap(node, 0);
+	of_node_put(node);
 
 	/* set the secondary core boot from DDR */
 	remap_reg_value = readl_relaxed(ctrl_base + REG_SC_CTRL);
diff --git a/arch/arm/mach-omap1/clock.c b/arch/arm/mach-omap1/clock.c
index fa512413a471..b277409f303a 100644
--- a/arch/arm/mach-omap1/clock.c
+++ b/arch/arm/mach-omap1/clock.c
@@ -44,7 +44,7 @@ static DEFINE_SPINLOCK(clockfw_lock);
 unsigned long omap1_uart_recalc(struct clk *clk)
 {
 	unsigned int val = __raw_readl(clk->enable_reg);
-	return val & clk->enable_bit ? 48000000 : 12000000;
+	return val & 1 << clk->enable_bit ? 48000000 : 12000000;
 }
 
 unsigned long omap1_sossi_recalc(struct clk *clk)
diff --git a/arch/arm/mach-vexpress/dcscb.c b/arch/arm/mach-vexpress/dcscb.c
index ee2a0faafaa1..aaade91f6551 100644
--- a/arch/arm/mach-vexpress/dcscb.c
+++ b/arch/arm/mach-vexpress/dcscb.c
@@ -146,6 +146,7 @@ static int __init dcscb_init(void)
 	if (!node)
 		return -ENODEV;
 	dcscb_base = of_iomap(node, 0);
+	of_node_put(node);
 	if (!dcscb_base)
 		return -EADDRNOTAVAIL;
 	cfg = readl_relaxed(dcscb_base + DCS_CFG_R);
diff --git a/arch/arm64/boot/dts/qcom/ipq8074.dtsi b/arch/arm64/boot/dts/qcom/ipq8074.dtsi
index 2bc5dec5614d..ffab4de694c2 100644
--- a/arch/arm64/boot/dts/qcom/ipq8074.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq8074.dtsi
@@ -181,7 +181,7 @@
 	clocks {
 		sleep_clk: sleep_clk {
 			compatible = "fixed-clock";
-			clock-frequency = <32000>;
+			clock-frequency = <32768>;
 			#clock-cells = <0>;
 		};
 
diff --git a/arch/m68k/Kconfig.cpu b/arch/m68k/Kconfig.cpu
index ff5f0896318b..6f13c53c8dc7 100644
--- a/arch/m68k/Kconfig.cpu
+++ b/arch/m68k/Kconfig.cpu
@@ -308,7 +308,7 @@ comment "Processor Specific Options"
 
 config M68KFPU_EMU
 	bool "Math emulation support"
-	depends on MMU
+	depends on M68KCLASSIC && FPU
 	help
 	  At some point in the future, this will cause floating-point math
 	  instructions to be emulated by the kernel on machines that lack a
diff --git a/arch/m68k/Kconfig.machine b/arch/m68k/Kconfig.machine
index 4a1697fa9a37..1054c5400671 100644
--- a/arch/m68k/Kconfig.machine
+++ b/arch/m68k/Kconfig.machine
@@ -309,6 +309,7 @@ comment "Machine Options"
 
 config UBOOT
 	bool "Support for U-Boot command line parameters"
+	depends on COLDFIRE
 	help
 	  If you say Y here kernel will try to collect command
 	  line parameters from the initial u-boot stack.
diff --git a/arch/m68k/include/asm/pgtable_no.h b/arch/m68k/include/asm/pgtable_no.h
index fc3a96c77bd8..12f673707d4b 100644
--- a/arch/m68k/include/asm/pgtable_no.h
+++ b/arch/m68k/include/asm/pgtable_no.h
@@ -42,7 +42,8 @@ extern void paging_init(void);
  * ZERO_PAGE is a global shared page that is always zero: used
  * for zero-mapped memory areas etc..
  */
-#define ZERO_PAGE(vaddr)	(virt_to_page(0))
+extern void *empty_zero_page;
+#define ZERO_PAGE(vaddr)	(virt_to_page(empty_zero_page))
 
 /*
  * No page table caches to initialise.
diff --git a/arch/mips/include/asm/mach-ip27/cpu-feature-overrides.h b/arch/mips/include/asm/mach-ip27/cpu-feature-overrides.h
index 136d6d464e32..93c69fc7bbd8 100644
--- a/arch/mips/include/asm/mach-ip27/cpu-feature-overrides.h
+++ b/arch/mips/include/asm/mach-ip27/cpu-feature-overrides.h
@@ -28,7 +28,6 @@
 #define cpu_has_6k_cache		0
 #define cpu_has_8k_cache		0
 #define cpu_has_tx39_cache		0
-#define cpu_has_fpu			1
 #define cpu_has_nofpuex			0
 #define cpu_has_32fpr			1
 #define cpu_has_counter			1
diff --git a/arch/mips/kernel/mips-cpc.c b/arch/mips/kernel/mips-cpc.c
index fcf9af492d60..cf46502c605e 100644
--- a/arch/mips/kernel/mips-cpc.c
+++ b/arch/mips/kernel/mips-cpc.c
@@ -31,6 +31,7 @@ phys_addr_t __weak mips_cpc_default_phys_base(void)
 	cpc_node = of_find_compatible_node(of_root, NULL, "mti,mips-cpc");
 	if (cpc_node) {
 		err = of_address_to_resource(cpc_node, 0, &res);
+		of_node_put(cpc_node);
 		if (!err)
 			return res.start;
 	}
diff --git a/arch/openrisc/include/asm/timex.h b/arch/openrisc/include/asm/timex.h
index 9935cad1b9b9..34d015bf0462 100644
--- a/arch/openrisc/include/asm/timex.h
+++ b/arch/openrisc/include/asm/timex.h
@@ -27,6 +27,7 @@ static inline cycles_t get_cycles(void)
 {
 	return mfspr(SPR_TTCR);
 }
+#define get_cycles get_cycles
 
 /* This isn't really used any more */
 #define CLOCK_TICK_RATE 1000
diff --git a/arch/openrisc/kernel/head.S b/arch/openrisc/kernel/head.S
index 4d878d13b860..3f1e9d168710 100644
--- a/arch/openrisc/kernel/head.S
+++ b/arch/openrisc/kernel/head.S
@@ -459,6 +459,15 @@ _start:
 	l.ori	r3,r0,0x1
 	l.mtspr	r0,r3,SPR_SR
 
+	/*
+	 * Start the TTCR as early as possible, so that the RNG can make use of
+	 * measurements of boot time from the earliest opportunity. Especially
+	 * important is that the TTCR does not return zero by the time we reach
+	 * rand_initialize().
+	 */
+	l.movhi r3,hi(SPR_TTMR_CR)
+	l.mtspr r0,r3,SPR_TTMR
+
 	CLEAR_GPR(r1)
 	CLEAR_GPR(r2)
 	CLEAR_GPR(r3)
diff --git a/arch/powerpc/kernel/idle.c b/arch/powerpc/kernel/idle.c
index d7216c9abda1..ca79aacfeda2 100644
--- a/arch/powerpc/kernel/idle.c
+++ b/arch/powerpc/kernel/idle.c
@@ -41,7 +41,7 @@ static int __init powersave_off(char *arg)
 {
 	ppc_md.power_save = NULL;
 	cpuidle_disable = IDLE_POWERSAVE_OFF;
-	return 0;
+	return 1;
 }
 __setup("powersave=off", powersave_off);
 
diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
index bfc5f59d9f1b..ef5875f83692 100644
--- a/arch/powerpc/kernel/ptrace.c
+++ b/arch/powerpc/kernel/ptrace.c
@@ -2920,8 +2920,13 @@ long arch_ptrace(struct task_struct *child, long request,
 
 			flush_fp_to_thread(child);
 			if (fpidx < (PT_FPSCR - PT_FPR0))
-				memcpy(&tmp, &child->thread.TS_FPR(fpidx),
-				       sizeof(long));
+				if (IS_ENABLED(CONFIG_PPC32)) {
+					// On 32-bit the index we are passed refers to 32-bit words
+					tmp = ((u32 *)child->thread.fp_state.fpr)[fpidx];
+				} else {
+					memcpy(&tmp, &child->thread.TS_FPR(fpidx),
+					       sizeof(long));
+				}
 			else
 				tmp = child->thread.fp_state.fpscr;
 		}
@@ -2953,8 +2958,13 @@ long arch_ptrace(struct task_struct *child, long request,
 
 			flush_fp_to_thread(child);
 			if (fpidx < (PT_FPSCR - PT_FPR0))
-				memcpy(&child->thread.TS_FPR(fpidx), &data,
-				       sizeof(long));
+				if (IS_ENABLED(CONFIG_PPC32)) {
+					// On 32-bit the index we are passed refers to 32-bit words
+					((u32 *)child->thread.fp_state.fpr)[fpidx] = data;
+				} else {
+					memcpy(&child->thread.TS_FPR(fpidx), &data,
+					       sizeof(long));
+				}
 			else
 				child->thread.fp_state.fpscr = data;
 			ret = 0;
diff --git a/arch/powerpc/perf/isa207-common.c b/arch/powerpc/perf/isa207-common.c
index 24a78565bca6..279bf3a3afbf 100644
--- a/arch/powerpc/perf/isa207-common.c
+++ b/arch/powerpc/perf/isa207-common.c
@@ -324,7 +324,8 @@ int isa207_get_constraint(u64 event, unsigned long *maskp, unsigned long *valp)
 		if (event_is_threshold(event) && is_thresh_cmp_valid(event)) {
 			mask  |= CNST_THRESH_MASK;
 			value |= CNST_THRESH_VAL(event >> EVENT_THRESH_SHIFT);
-		}
+		} else if (event_is_threshold(event))
+			return -1;
 	} else {
 		/*
 		 * Special case for PM_MRK_FAB_RSP_MATCH and PM_MRK_FAB_RSP_MATCH_CYC,
diff --git a/arch/powerpc/platforms/4xx/cpm.c b/arch/powerpc/platforms/4xx/cpm.c
index 53ff81ca8a3c..6400ae376216 100644
--- a/arch/powerpc/platforms/4xx/cpm.c
+++ b/arch/powerpc/platforms/4xx/cpm.c
@@ -341,6 +341,6 @@ late_initcall(cpm_init);
 static int __init cpm_powersave_off(char *arg)
 {
 	cpm.powersave_off = 1;
-	return 0;
+	return 1;
 }
 __setup("powersave=off", cpm_powersave_off);
diff --git a/arch/powerpc/sysdev/cpm1.c b/arch/powerpc/sysdev/cpm1.c
index c6f154b602fb..72eaa77c1f85 100644
--- a/arch/powerpc/sysdev/cpm1.c
+++ b/arch/powerpc/sysdev/cpm1.c
@@ -291,6 +291,7 @@ cpm_setbrg(uint brg, uint rate)
 		out_be32(bp, (((BRG_UART_CLK_DIV16 / rate) - 1) << 1) |
 			      CPM_BRG_EN | CPM_BRG_DIV16);
 }
+EXPORT_SYMBOL(cpm_setbrg);
 
 struct cpm_ioport16 {
 	__be16 dir, par, odr_sor, dat, intr;
diff --git a/arch/powerpc/sysdev/fsl_rio.c b/arch/powerpc/sysdev/fsl_rio.c
index 5011ffea4e4b..c48ebe677962 100644
--- a/arch/powerpc/sysdev/fsl_rio.c
+++ b/arch/powerpc/sysdev/fsl_rio.c
@@ -509,8 +509,10 @@ int fsl_rio_setup(struct platform_device *dev)
 	if (rc) {
 		dev_err(&dev->dev, "Can't get %pOF property 'reg'\n",
 				rmu_node);
+		of_node_put(rmu_node);
 		goto err_rmu;
 	}
+	of_node_put(rmu_node);
 	rmu_regs_win = ioremap(rmu_regs.start, resource_size(&rmu_regs));
 	if (!rmu_regs_win) {
 		dev_err(&dev->dev, "Unable to map rmu register window\n");
diff --git a/arch/powerpc/sysdev/xics/icp-opal.c b/arch/powerpc/sysdev/xics/icp-opal.c
index c71d2ea42627..3c9dd871491e 100644
--- a/arch/powerpc/sysdev/xics/icp-opal.c
+++ b/arch/powerpc/sysdev/xics/icp-opal.c
@@ -199,6 +199,7 @@ int icp_opal_init(void)
 
 	printk("XICS: Using OPAL ICP fallbacks\n");
 
+	of_node_put(np);
 	return 0;
 }
 
diff --git a/arch/s390/include/asm/preempt.h b/arch/s390/include/asm/preempt.h
index 23a14d187fb1..1aebf09fbcd8 100644
--- a/arch/s390/include/asm/preempt.h
+++ b/arch/s390/include/asm/preempt.h
@@ -50,10 +50,17 @@ static inline bool test_preempt_need_resched(void)
 
 static inline void __preempt_count_add(int val)
 {
-	if (__builtin_constant_p(val) && (val >= -128) && (val <= 127))
-		__atomic_add_const(val, &S390_lowcore.preempt_count);
-	else
-		__atomic_add(val, &S390_lowcore.preempt_count);
+	/*
+	 * With some obscure config options and CONFIG_PROFILE_ALL_BRANCHES
+	 * enabled, gcc 12 fails to handle __builtin_constant_p().
+	 */
+	if (!IS_ENABLED(CONFIG_PROFILE_ALL_BRANCHES)) {
+		if (__builtin_constant_p(val) && (val >= -128) && (val <= 127)) {
+			__atomic_add_const(val, &S390_lowcore.preempt_count);
+			return;
+		}
+	}
+	__atomic_add(val, &S390_lowcore.preempt_count);
 }
 
 static inline void __preempt_count_sub(int val)
diff --git a/arch/um/drivers/chan_user.c b/arch/um/drivers/chan_user.c
index feb7f5ab4084..cd7346d26b89 100644
--- a/arch/um/drivers/chan_user.c
+++ b/arch/um/drivers/chan_user.c
@@ -220,7 +220,7 @@ static int winch_tramp(int fd, struct tty_port *port, int *fd_out,
 		       unsigned long *stack_out)
 {
 	struct winch_data data;
-	int fds[2], n, err;
+	int fds[2], n, err, pid;
 	char c;
 
 	err = os_pipe(fds, 1, 1);
@@ -238,8 +238,9 @@ static int winch_tramp(int fd, struct tty_port *port, int *fd_out,
 	 * problem with /dev/net/tun, which if held open by this
 	 * thread, prevents the TUN/TAP device from being reused.
 	 */
-	err = run_helper_thread(winch_thread, &data, CLONE_FILES, stack_out);
-	if (err < 0) {
+	pid = run_helper_thread(winch_thread, &data, CLONE_FILES, stack_out);
+	if (pid < 0) {
+		err = pid;
 		printk(UM_KERN_ERR "fork of winch_thread failed - errno = %d\n",
 		       -err);
 		goto out_close;
@@ -263,7 +264,7 @@ static int winch_tramp(int fd, struct tty_port *port, int *fd_out,
 		goto out_close;
 	}
 
-	return err;
+	return pid;
 
  out_close:
 	close(fds[1]);
diff --git a/arch/x86/entry/vdso/vma.c b/arch/x86/entry/vdso/vma.c
index 2ab8628aef10..63ed146abef0 100644
--- a/arch/x86/entry/vdso/vma.c
+++ b/arch/x86/entry/vdso/vma.c
@@ -328,7 +328,7 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 static __init int vdso_setup(char *s)
 {
 	vdso64_enabled = simple_strtoul(s, NULL, 0);
-	return 0;
+	return 1;
 }
 __setup("vdso=", vdso_setup);
 #endif
diff --git a/arch/x86/include/asm/acenv.h b/arch/x86/include/asm/acenv.h
index 1b010a859b8b..6de59a4f723c 100644
--- a/arch/x86/include/asm/acenv.h
+++ b/arch/x86/include/asm/acenv.h
@@ -16,7 +16,19 @@
 
 /* Asm macros */
 
-#define ACPI_FLUSH_CPU_CACHE()	wbinvd()
+/*
+ * ACPI_FLUSH_CPU_CACHE() flushes caches on entering sleep states.
+ * It is required to prevent data loss.
+ *
+ * While running inside virtual machine, the kernel can bypass cache flushing.
+ * Changing sleep state in a virtual machine doesn't affect the host system
+ * sleep state and cannot lead to data loss.
+ */
+#define ACPI_FLUSH_CPU_CACHE()					\
+do {								\
+	if (!cpu_feature_enabled(X86_FEATURE_HYPERVISOR))	\
+		wbinvd();					\
+} while (0)
 
 int __acpi_acquire_global_lock(unsigned int *lock);
 int __acpi_release_global_lock(unsigned int *lock);
diff --git a/arch/x86/include/asm/suspend_32.h b/arch/x86/include/asm/suspend_32.h
index 8be6afb58471..32662cbaa27e 100644
--- a/arch/x86/include/asm/suspend_32.h
+++ b/arch/x86/include/asm/suspend_32.h
@@ -21,7 +21,6 @@ struct saved_context {
 #endif
 	unsigned long cr0, cr2, cr3, cr4;
 	u64 misc_enable;
-	bool misc_enable_saved;
 	struct saved_msrs saved_msrs;
 	struct desc_ptr gdt_desc;
 	struct desc_ptr idt;
@@ -30,6 +29,7 @@ struct saved_context {
 	unsigned long tr;
 	unsigned long safety;
 	unsigned long return_address;
+	bool misc_enable_saved;
 } __attribute__((packed));
 
 #endif /* _ASM_X86_SUSPEND_32_H */
diff --git a/arch/x86/include/asm/suspend_64.h b/arch/x86/include/asm/suspend_64.h
index a7af9f53c0cb..b2861400c6a2 100644
--- a/arch/x86/include/asm/suspend_64.h
+++ b/arch/x86/include/asm/suspend_64.h
@@ -14,9 +14,13 @@
  * Image of the saved processor state, used by the low level ACPI suspend to
  * RAM code and by the low level hibernation code.
  *
- * If you modify it, fix arch/x86/kernel/acpi/wakeup_64.S and make sure that
- * __save/__restore_processor_state(), defined in arch/x86/kernel/suspend_64.c,
- * still work as required.
+ * If you modify it, check how it is used in arch/x86/kernel/acpi/wakeup_64.S
+ * and make sure that __save/__restore_processor_state(), defined in
+ * arch/x86/power/cpu.c, still work as required.
+ *
+ * Because the structure is packed, make sure to avoid unaligned members. For
+ * optimisation purposes but also because tools like kmemleak only search for
+ * pointers that are aligned.
  */
 struct saved_context {
 	struct pt_regs regs;
@@ -36,7 +40,6 @@ struct saved_context {
 
 	unsigned long cr0, cr2, cr3, cr4, cr8;
 	u64 misc_enable;
-	bool misc_enable_saved;
 	struct saved_msrs saved_msrs;
 	unsigned long efer;
 	u16 gdt_pad; /* Unused */
@@ -48,6 +51,7 @@ struct saved_context {
 	unsigned long tr;
 	unsigned long safety;
 	unsigned long return_address;
+	bool misc_enable_saved;
 } __attribute__((packed));
 
 #define loaddebug(thread,register) \
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 76f2bbba92f9..488e0853a44d 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -167,7 +167,7 @@ static __init int setup_apicpmtimer(char *s)
 {
 	apic_calibrate_pmtmr = 1;
 	notsc_setup(NULL);
-	return 0;
+	return 1;
 }
 __setup("apicpmtimer", setup_apicpmtimer);
 #endif
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 3a5ea741701b..541e190c3f0e 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -71,7 +71,7 @@ static bool ring3mwait_disabled __read_mostly;
 static int __init ring3mwait_disable(char *__unused)
 {
 	ring3mwait_disabled = true;
-	return 0;
+	return 1;
 }
 __setup("ring3mwait=disable", ring3mwait_disable);
 
diff --git a/arch/x86/kernel/step.c b/arch/x86/kernel/step.c
index 60d2c3798ba2..2f97d1a1032f 100644
--- a/arch/x86/kernel/step.c
+++ b/arch/x86/kernel/step.c
@@ -175,8 +175,7 @@ void set_task_blockstep(struct task_struct *task, bool on)
 	 *
 	 * NOTE: this means that set/clear TIF_BLOCKSTEP is only safe if
 	 * task is current or it can't be running, otherwise we can race
-	 * with __switch_to_xtra(). We rely on ptrace_freeze_traced() but
-	 * PTRACE_KILL is not safe.
+	 * with __switch_to_xtra(). We rely on ptrace_freeze_traced().
 	 */
 	local_irq_disable();
 	debugctl = get_debugctlmsr();
diff --git a/arch/x86/kernel/sys_x86_64.c b/arch/x86/kernel/sys_x86_64.c
index a63fe77b3217..7a08c42770f1 100644
--- a/arch/x86/kernel/sys_x86_64.c
+++ b/arch/x86/kernel/sys_x86_64.c
@@ -70,9 +70,6 @@ static int __init control_va_addr_alignment(char *str)
 	if (*str == 0)
 		return 1;
 
-	if (*str == '=')
-		str++;
-
 	if (!strcmp(str, "32"))
 		va_align.flags = ALIGN_VA_32;
 	else if (!strcmp(str, "64"))
@@ -82,11 +79,11 @@ static int __init control_va_addr_alignment(char *str)
 	else if (!strcmp(str, "on"))
 		va_align.flags = ALIGN_VA_32 | ALIGN_VA_64;
 	else
-		return 0;
+		pr_warn("invalid option value: 'align_va_addr=%s'\n", str);
 
 	return 1;
 }
-__setup("align_va_addr", control_va_addr_alignment);
+__setup("align_va_addr=", control_va_addr_alignment);
 
 SYSCALL_DEFINE6(mmap, unsigned long, addr, unsigned long, len,
 		unsigned long, prot, unsigned long, flags,
diff --git a/arch/x86/lib/delay.c b/arch/x86/lib/delay.c
index 17a0d0f5a1bf..ea1d00159ea6 100644
--- a/arch/x86/lib/delay.c
+++ b/arch/x86/lib/delay.c
@@ -43,8 +43,8 @@ static void delay_loop(unsigned long loops)
 		"	jnz 2b		\n"
 		"3:	dec %0		\n"
 
-		: /* we don't need output */
-		:"a" (loops)
+		: "+a" (loops)
+		:
 	);
 }
 
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index fe7d57a8fb60..49aeb4e73a35 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -74,7 +74,7 @@ int pat_debug_enable;
 static int __init pat_debug_setup(char *str)
 {
 	pat_debug_enable = 1;
-	return 0;
+	return 1;
 }
 __setup("debugpat", pat_debug_setup);
 
diff --git a/arch/x86/um/ldt.c b/arch/x86/um/ldt.c
index 3ee234b6234d..255a44dd415a 100644
--- a/arch/x86/um/ldt.c
+++ b/arch/x86/um/ldt.c
@@ -23,9 +23,11 @@ static long write_ldt_entry(struct mm_id *mm_idp, int func,
 {
 	long res;
 	void *stub_addr;
+
+	BUILD_BUG_ON(sizeof(*desc) % sizeof(long));
+
 	res = syscall_stub_data(mm_idp, (unsigned long *)desc,
-				(sizeof(*desc) + sizeof(long) - 1) &
-				    ~(sizeof(long) - 1),
+				sizeof(*desc) / sizeof(long),
 				addr, &stub_addr);
 	if (!res) {
 		unsigned long args[] = { func,
diff --git a/arch/xtensa/kernel/ptrace.c b/arch/xtensa/kernel/ptrace.c
index 7c3ed7d78075..7870b1a801e6 100644
--- a/arch/xtensa/kernel/ptrace.c
+++ b/arch/xtensa/kernel/ptrace.c
@@ -35,12 +35,12 @@
 
 void user_enable_single_step(struct task_struct *child)
 {
-	child->ptrace |= PT_SINGLESTEP;
+	set_tsk_thread_flag(child, TIF_SINGLESTEP);
 }
 
 void user_disable_single_step(struct task_struct *child)
 {
-	child->ptrace &= ~PT_SINGLESTEP;
+	clear_tsk_thread_flag(child, TIF_SINGLESTEP);
 }
 
 /*
diff --git a/arch/xtensa/kernel/signal.c b/arch/xtensa/kernel/signal.c
index d427e784ab44..2a2b2a4da2be 100644
--- a/arch/xtensa/kernel/signal.c
+++ b/arch/xtensa/kernel/signal.c
@@ -459,7 +459,7 @@ static void do_signal(struct pt_regs *regs)
 		/* Set up the stack frame */
 		ret = setup_frame(&ksig, sigmask_to_save(), regs);
 		signal_setup_done(ret, &ksig, 0);
-		if (current->ptrace & PT_SINGLESTEP)
+		if (test_thread_flag(TIF_SINGLESTEP))
 			task_pt_regs(current)->icountlevel = 1;
 
 		return;
@@ -485,7 +485,7 @@ static void do_signal(struct pt_regs *regs)
 	/* If there's no signal to deliver, we just restore the saved mask.  */
 	restore_saved_sigmask();
 
-	if (current->ptrace & PT_SINGLESTEP)
+	if (test_thread_flag(TIF_SINGLESTEP))
 		task_pt_regs(current)->icountlevel = 1;
 	return;
 }
diff --git a/drivers/ata/libata-transport.c b/drivers/ata/libata-transport.c
index 19e6e539a061..ecc257fa5a54 100644
--- a/drivers/ata/libata-transport.c
+++ b/drivers/ata/libata-transport.c
@@ -196,7 +196,7 @@ static struct {
 	{ XFER_PIO_0,			"XFER_PIO_0" },
 	{ XFER_PIO_SLOW,		"XFER_PIO_SLOW" }
 };
-ata_bitfield_name_match(xfer,ata_xfer_names)
+ata_bitfield_name_search(xfer, ata_xfer_names)
 
 /*
  * ATA Port attributes
diff --git a/drivers/ata/pata_octeon_cf.c b/drivers/ata/pata_octeon_cf.c
index ac3b1fda820f..c240d8cbfd41 100644
--- a/drivers/ata/pata_octeon_cf.c
+++ b/drivers/ata/pata_octeon_cf.c
@@ -888,12 +888,14 @@ static int octeon_cf_probe(struct platform_device *pdev)
 				int i;
 				res_dma = platform_get_resource(dma_dev, IORESOURCE_MEM, 0);
 				if (!res_dma) {
+					put_device(&dma_dev->dev);
 					of_node_put(dma_node);
 					return -EINVAL;
 				}
 				cf_port->dma_base = (u64)devm_ioremap_nocache(&pdev->dev, res_dma->start,
 									 resource_size(res_dma));
 				if (!cf_port->dma_base) {
+					put_device(&dma_dev->dev);
 					of_node_put(dma_node);
 					return -EINVAL;
 				}
@@ -903,6 +905,7 @@ static int octeon_cf_probe(struct platform_device *pdev)
 					irq = i;
 					irq_handler = octeon_cf_interrupt;
 				}
+				put_device(&dma_dev->dev);
 			}
 			of_node_put(dma_node);
 		}
diff --git a/drivers/base/node.c b/drivers/base/node.c
index 5c39f14d15a5..57eef6b24448 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -337,6 +337,7 @@ static int register_node(struct node *node, int num)
  */
 void unregister_node(struct node *node)
 {
+	compaction_unregister_node(node);
 	hugetlb_unregister_node(node);		/* no-op, if memoryless node */
 
 	device_unregister(&node->dev);
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 826b3877a157..338d02a67afb 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -1275,7 +1275,7 @@ static int nbd_start_device_ioctl(struct nbd_device *nbd, struct block_device *b
 static void nbd_clear_sock_ioctl(struct nbd_device *nbd,
 				 struct block_device *bdev)
 {
-	sock_shutdown(nbd);
+	nbd_clear_sock(nbd);
 	__invalidate_device(bdev, true);
 	nbd_bdev_reset(bdev);
 	if (test_and_clear_bit(NBD_HAS_CONFIG_REF,
@@ -1382,15 +1382,20 @@ static struct nbd_config *nbd_alloc_config(void)
 {
 	struct nbd_config *config;
 
+	if (!try_module_get(THIS_MODULE))
+		return ERR_PTR(-ENODEV);
+
 	config = kzalloc(sizeof(struct nbd_config), GFP_NOFS);
-	if (!config)
-		return NULL;
+	if (!config) {
+		module_put(THIS_MODULE);
+		return ERR_PTR(-ENOMEM);
+	}
+
 	atomic_set(&config->recv_threads, 0);
 	init_waitqueue_head(&config->recv_wq);
 	init_waitqueue_head(&config->conn_wait);
 	config->blksize = NBD_DEF_BLKSIZE;
 	atomic_set(&config->live_connections, 0);
-	try_module_get(THIS_MODULE);
 	return config;
 }
 
@@ -1417,12 +1422,13 @@ static int nbd_open(struct block_device *bdev, fmode_t mode)
 			mutex_unlock(&nbd->config_lock);
 			goto out;
 		}
-		config = nbd->config = nbd_alloc_config();
-		if (!config) {
-			ret = -ENOMEM;
+		config = nbd_alloc_config();
+		if (IS_ERR(config)) {
+			ret = PTR_ERR(config);
 			mutex_unlock(&nbd->config_lock);
 			goto out;
 		}
+		nbd->config = config;
 		refcount_set(&nbd->config_refs, 1);
 		refcount_inc(&nbd->refs);
 		mutex_unlock(&nbd->config_lock);
@@ -1803,13 +1809,14 @@ static int nbd_genl_connect(struct sk_buff *skb, struct genl_info *info)
 		nbd_put(nbd);
 		return -EINVAL;
 	}
-	config = nbd->config = nbd_alloc_config();
-	if (!nbd->config) {
+	config = nbd_alloc_config();
+	if (IS_ERR(config)) {
 		mutex_unlock(&nbd->config_lock);
 		nbd_put(nbd);
 		printk(KERN_ERR "nbd: couldn't allocate config\n");
-		return -ENOMEM;
+		return PTR_ERR(config);
 	}
+	nbd->config = config;
 	refcount_set(&nbd->config_refs, 1);
 	set_bit(NBD_BOUND, &config->runtime_flags);
 
@@ -2319,6 +2326,12 @@ static void __exit nbd_cleanup(void)
 	struct nbd_device *nbd;
 	LIST_HEAD(del_list);
 
+	/*
+	 * Unregister netlink interface prior to waiting
+	 * for the completion of netlink commands.
+	 */
+	genl_unregister_family(&nbd_genl_family);
+
 	nbd_dbg_close();
 
 	mutex_lock(&nbd_index_mutex);
@@ -2328,13 +2341,15 @@ static void __exit nbd_cleanup(void)
 	while (!list_empty(&del_list)) {
 		nbd = list_first_entry(&del_list, struct nbd_device, list);
 		list_del_init(&nbd->list);
+		if (refcount_read(&nbd->config_refs))
+			printk(KERN_ERR "nbd: possibly leaking nbd_config (ref %d)\n",
+					refcount_read(&nbd->config_refs));
 		if (refcount_read(&nbd->refs) != 1)
 			printk(KERN_ERR "nbd: possibly leaking a device\n");
 		nbd_put(nbd);
 	}
 
 	idr_destroy(&nbd_index_idr);
-	genl_unregister_family(&nbd_genl_family);
 	unregister_blkdev(NBD_MAJOR, "nbd");
 }
 
diff --git a/drivers/char/ipmi/ipmi_ssif.c b/drivers/char/ipmi/ipmi_ssif.c
index cf87bfe971e6..171c54c86356 100644
--- a/drivers/char/ipmi/ipmi_ssif.c
+++ b/drivers/char/ipmi/ipmi_ssif.c
@@ -816,6 +816,14 @@ static void msg_done_handler(struct ssif_info *ssif_info, int result,
 		break;
 
 	case SSIF_GETTING_EVENTS:
+		if (!msg) {
+			/* Should never happen, but just in case. */
+			dev_warn(&ssif_info->client->dev,
+				 "No message set while getting events\n");
+			ipmi_ssif_unlock_cond(ssif_info, flags);
+			break;
+		}
+
 		if ((result < 0) || (len < 3) || (msg->rsp[2] != 0)) {
 			/* Error getting event, probably done. */
 			msg->done(msg);
@@ -839,6 +847,14 @@ static void msg_done_handler(struct ssif_info *ssif_info, int result,
 		break;
 
 	case SSIF_GETTING_MESSAGES:
+		if (!msg) {
+			/* Should never happen, but just in case. */
+			dev_warn(&ssif_info->client->dev,
+				 "No message set while getting messages\n");
+			ipmi_ssif_unlock_cond(ssif_info, flags);
+			break;
+		}
+
 		if ((result < 0) || (len < 3) || (msg->rsp[2] != 0)) {
 			/* Error getting event, probably done. */
 			msg->done(msg);
@@ -861,6 +877,13 @@ static void msg_done_handler(struct ssif_info *ssif_info, int result,
 			deliver_recv_msg(ssif_info, msg);
 		}
 		break;
+
+	default:
+		/* Should never happen, but just in case. */
+		dev_warn(&ssif_info->client->dev,
+			 "Invalid state in message done handling: %d\n",
+			 ssif_info->ssif_state);
+		ipmi_ssif_unlock_cond(ssif_info, flags);
 	}
 
 	flags = ipmi_ssif_lock_cond(ssif_info, &oflags);
diff --git a/drivers/clocksource/timer-oxnas-rps.c b/drivers/clocksource/timer-oxnas-rps.c
index 30c6f4ce672b..cfcd54e66c57 100644
--- a/drivers/clocksource/timer-oxnas-rps.c
+++ b/drivers/clocksource/timer-oxnas-rps.c
@@ -247,7 +247,7 @@ static int __init oxnas_rps_timer_init(struct device_node *np)
 	}
 
 	rps->irq = irq_of_parse_and_map(np, 0);
-	if (rps->irq < 0) {
+	if (!rps->irq) {
 		ret = -EINVAL;
 		goto err_iomap;
 	}
diff --git a/drivers/clocksource/timer-sp804.c b/drivers/clocksource/timer-sp804.c
index 3ac9dec9a038..42cac9262630 100644
--- a/drivers/clocksource/timer-sp804.c
+++ b/drivers/clocksource/timer-sp804.c
@@ -227,6 +227,11 @@ static int __init sp804_of_init(struct device_node *np)
 	struct clk *clk1, *clk2;
 	const char *name = of_get_property(np, "compatible", NULL);
 
+	if (initialized) {
+		pr_debug("%pOF: skipping further SP804 timer device\n", np);
+		return 0;
+	}
+
 	base = of_iomap(np, 0);
 	if (!base)
 		return -ENXIO;
@@ -235,11 +240,6 @@ static int __init sp804_of_init(struct device_node *np)
 	writel(0, base + TIMER_CTRL);
 	writel(0, base + TIMER_2_BASE + TIMER_CTRL);
 
-	if (initialized || !of_device_is_available(np)) {
-		ret = -EINVAL;
-		goto err;
-	}
-
 	clk1 = of_clk_get(np, 0);
 	if (IS_ERR(clk1))
 		clk1 = NULL;
diff --git a/drivers/extcon/extcon.c b/drivers/extcon/extcon.c
index e9fe3e3bac2b..81a552654cc7 100644
--- a/drivers/extcon/extcon.c
+++ b/drivers/extcon/extcon.c
@@ -1241,19 +1241,14 @@ int extcon_dev_register(struct extcon_dev *edev)
 		edev->dev.type = &edev->extcon_dev_type;
 	}
 
-	ret = device_register(&edev->dev);
-	if (ret) {
-		put_device(&edev->dev);
-		goto err_dev;
-	}
-
 	spin_lock_init(&edev->lock);
-	edev->nh = devm_kcalloc(&edev->dev, edev->max_supported,
-				sizeof(*edev->nh), GFP_KERNEL);
-	if (!edev->nh) {
-		ret = -ENOMEM;
-		device_unregister(&edev->dev);
-		goto err_dev;
+	if (edev->max_supported) {
+		edev->nh = kcalloc(edev->max_supported, sizeof(*edev->nh),
+				GFP_KERNEL);
+		if (!edev->nh) {
+			ret = -ENOMEM;
+			goto err_alloc_nh;
+		}
 	}
 
 	for (index = 0; index < edev->max_supported; index++)
@@ -1264,6 +1259,12 @@ int extcon_dev_register(struct extcon_dev *edev)
 	dev_set_drvdata(&edev->dev, edev);
 	edev->state = 0;
 
+	ret = device_register(&edev->dev);
+	if (ret) {
+		put_device(&edev->dev);
+		goto err_dev;
+	}
+
 	mutex_lock(&extcon_dev_list_lock);
 	list_add(&edev->entry, &extcon_dev_list);
 	mutex_unlock(&extcon_dev_list_lock);
@@ -1271,6 +1272,9 @@ int extcon_dev_register(struct extcon_dev *edev)
 	return 0;
 
 err_dev:
+	if (edev->max_supported)
+		kfree(edev->nh);
+err_alloc_nh:
 	if (edev->max_supported)
 		kfree(edev->extcon_dev_type.groups);
 err_alloc_groups:
@@ -1331,6 +1335,7 @@ void extcon_dev_unregister(struct extcon_dev *edev)
 	if (edev->max_supported) {
 		kfree(edev->extcon_dev_type.groups);
 		kfree(edev->cables);
+		kfree(edev->nh);
 	}
 
 	put_device(&edev->dev);
diff --git a/drivers/firmware/dmi-sysfs.c b/drivers/firmware/dmi-sysfs.c
index d5de6ee8466d..084948a31d2d 100644
--- a/drivers/firmware/dmi-sysfs.c
+++ b/drivers/firmware/dmi-sysfs.c
@@ -602,7 +602,7 @@ static void __init dmi_sysfs_register_handle(const struct dmi_header *dh,
 				    "%d-%d", dh->type, entry->instance);
 
 	if (*ret) {
-		kfree(entry);
+		kobject_put(&entry->kobj);
 		return;
 	}
 
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
index 44aa58ab55d0..8a8b65b1b5a9 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -84,7 +84,7 @@ static int amdgpu_cs_parser_init(struct amdgpu_cs_parser *p, void *data)
 	int ret;
 
 	if (cs->in.num_chunks == 0)
-		return 0;
+		return -EINVAL;
 
 	chunk_array = kmalloc_array(cs->in.num_chunks, sizeof(uint64_t), GFP_KERNEL);
 	if (!chunk_array)
diff --git a/drivers/gpu/drm/amd/amdgpu/kv_dpm.c b/drivers/gpu/drm/amd/amdgpu/kv_dpm.c
index c76073b422d6..d99fb88341f4 100644
--- a/drivers/gpu/drm/amd/amdgpu/kv_dpm.c
+++ b/drivers/gpu/drm/amd/amdgpu/kv_dpm.c
@@ -1608,19 +1608,7 @@ static int kv_update_samu_dpm(struct amdgpu_device *adev, bool gate)
 
 static u8 kv_get_acp_boot_level(struct amdgpu_device *adev)
 {
-	u8 i;
-	struct amdgpu_clock_voltage_dependency_table *table =
-		&adev->pm.dpm.dyn_state.acp_clock_voltage_dependency_table;
-
-	for (i = 0; i < table->count; i++) {
-		if (table->entries[i].clk >= 0) /* XXX */
-			break;
-	}
-
-	if (i >= table->count)
-		i = table->count - 1;
-
-	return i;
+	return 0;
 }
 
 static void kv_update_acp_boot_level(struct amdgpu_device *adev)
diff --git a/drivers/gpu/drm/amd/amdgpu/si_dpm.c b/drivers/gpu/drm/amd/amdgpu/si_dpm.c
index 55613f425931..288ac692f536 100644
--- a/drivers/gpu/drm/amd/amdgpu/si_dpm.c
+++ b/drivers/gpu/drm/amd/amdgpu/si_dpm.c
@@ -7238,17 +7238,15 @@ static int si_parse_power_table(struct amdgpu_device *adev)
 	if (!adev->pm.dpm.ps)
 		return -ENOMEM;
 	power_state_offset = (u8 *)state_array->states;
-	for (i = 0; i < state_array->ucNumEntries; i++) {
+	for (adev->pm.dpm.num_ps = 0, i = 0; i < state_array->ucNumEntries; i++) {
 		u8 *idx;
 		power_state = (union pplib_power_state *)power_state_offset;
 		non_clock_array_index = power_state->v2.nonClockInfoIndex;
 		non_clock_info = (struct _ATOM_PPLIB_NONCLOCK_INFO *)
 			&non_clock_info_array->nonClockInfo[non_clock_array_index];
 		ps = kzalloc(sizeof(struct  si_ps), GFP_KERNEL);
-		if (ps == NULL) {
-			kfree(adev->pm.dpm.ps);
+		if (ps == NULL)
 			return -ENOMEM;
-		}
 		adev->pm.dpm.ps[i].ps_priv = ps;
 		si_parse_pplib_non_clock_info(adev, &adev->pm.dpm.ps[i],
 					      non_clock_info,
@@ -7270,8 +7268,8 @@ static int si_parse_power_table(struct amdgpu_device *adev)
 			k++;
 		}
 		power_state_offset += 2 + power_state->v2.ucNumDPMLevels;
+		adev->pm.dpm.num_ps++;
 	}
-	adev->pm.dpm.num_ps = state_array->ucNumEntries;
 
 	/* fill in the vce power states */
 	for (i = 0; i < adev->pm.dpm.num_of_vce_states; i++) {
diff --git a/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c b/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
index a8905049b9da..5855f17caf16 100644
--- a/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
+++ b/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
@@ -1279,8 +1279,19 @@ static ssize_t analogix_dpaux_transfer(struct drm_dp_aux *aux,
 				       struct drm_dp_aux_msg *msg)
 {
 	struct analogix_dp_device *dp = to_dp(aux);
+	int ret;
+
+	pm_runtime_get_sync(dp->dev);
 
-	return analogix_dp_transfer(dp, msg);
+	ret = analogix_dp_detect_hpd(dp);
+	if (ret)
+		goto out;
+
+	ret = analogix_dp_transfer(dp, msg);
+out:
+	pm_runtime_put(dp->dev);
+
+	return ret;
 }
 
 int analogix_dp_bind(struct device *dev, struct drm_device *drm_dev,
diff --git a/drivers/gpu/drm/gma500/psb_intel_display.c b/drivers/gpu/drm/gma500/psb_intel_display.c
index 8762efaef283..987f202c70ff 100644
--- a/drivers/gpu/drm/gma500/psb_intel_display.c
+++ b/drivers/gpu/drm/gma500/psb_intel_display.c
@@ -543,14 +543,15 @@ void psb_intel_crtc_init(struct drm_device *dev, int pipe,
 
 struct drm_crtc *psb_intel_get_crtc_from_pipe(struct drm_device *dev, int pipe)
 {
-	struct drm_crtc *crtc = NULL;
+	struct drm_crtc *crtc;
 
 	list_for_each_entry(crtc, &dev->mode_config.crtc_list, head) {
 		struct gma_crtc *gma_crtc = to_gma_crtc(crtc);
+
 		if (gma_crtc->pipe == pipe)
-			break;
+			return crtc;
 	}
-	return crtc;
+	return NULL;
 }
 
 int gma_connector_clones(struct drm_device *dev, int type_mask)
diff --git a/drivers/gpu/drm/imx/ipuv3-crtc.c b/drivers/gpu/drm/imx/ipuv3-crtc.c
index 12dd261fc308..628de21c03d2 100644
--- a/drivers/gpu/drm/imx/ipuv3-crtc.c
+++ b/drivers/gpu/drm/imx/ipuv3-crtc.c
@@ -72,7 +72,7 @@ static void ipu_crtc_disable_planes(struct ipu_crtc *ipu_crtc,
 	drm_atomic_crtc_state_for_each_plane(plane, old_crtc_state) {
 		if (plane == &ipu_crtc->plane[0]->base)
 			disable_full = true;
-		if (&ipu_crtc->plane[1] && plane == &ipu_crtc->plane[1]->base)
+		if (ipu_crtc->plane[1] && plane == &ipu_crtc->plane[1]->base)
 			disable_partial = true;
 	}
 
diff --git a/drivers/gpu/drm/mediatek/mtk_cec.c b/drivers/gpu/drm/mediatek/mtk_cec.c
index 7a3eb8c17ef9..4e5482986dc2 100644
--- a/drivers/gpu/drm/mediatek/mtk_cec.c
+++ b/drivers/gpu/drm/mediatek/mtk_cec.c
@@ -91,7 +91,7 @@ static void mtk_cec_mask(struct mtk_cec *cec, unsigned int offset,
 	u32 tmp = readl(cec->regs + offset) & ~mask;
 
 	tmp |= val & mask;
-	writel(val, cec->regs + offset);
+	writel(tmp, cec->regs + offset);
 }
 
 void mtk_cec_set_hpd_event(struct device *dev,
diff --git a/drivers/gpu/drm/msm/dsi/dsi_host.c b/drivers/gpu/drm/msm/dsi/dsi_host.c
index d49f17748119..c9c8d2190515 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -1240,10 +1240,10 @@ static int dsi_cmds2buf_tx(struct msm_dsi_host *msm_host,
 			dsi_get_bpp(msm_host->format) / 8;
 
 	len = dsi_cmd_dma_add(msm_host, msg);
-	if (!len) {
+	if (len < 0) {
 		pr_err("%s: failed to add cmd type = 0x%x\n",
 			__func__,  msg->type);
-		return -EINVAL;
+		return len;
 	}
 
 	/* for video mode, do not send cmds more than
@@ -1262,10 +1262,14 @@ static int dsi_cmds2buf_tx(struct msm_dsi_host *msm_host,
 	}
 
 	ret = dsi_cmd_dma_tx(msm_host, len);
-	if (ret < len) {
-		pr_err("%s: cmd dma tx failed, type=0x%x, data0=0x%x, len=%d\n",
-			__func__, msg->type, (*(u8 *)(msg->tx_buf)), len);
-		return -ECOMM;
+	if (ret < 0) {
+		pr_err("%s: cmd dma tx failed, type=0x%x, data0=0x%x, len=%d, ret=%d\n",
+			__func__, msg->type, (*(u8 *)(msg->tx_buf)), len, ret);
+		return ret;
+	} else if (ret < len) {
+		pr_err("%s: cmd dma tx failed, type=0x%x, data0=0x%x, ret=%d len=%d\n",
+			__func__, msg->type, (*(u8 *)(msg->tx_buf)), ret, len);
+		return -EIO;
 	}
 
 	return len;
@@ -1988,9 +1992,12 @@ int msm_dsi_host_cmd_rx(struct mipi_dsi_host *host,
 		}
 
 		ret = dsi_cmds2buf_tx(msm_host, msg);
-		if (ret < msg->tx_len) {
+		if (ret < 0) {
 			pr_err("%s: Read cmd Tx failed, %d\n", __func__, ret);
 			return ret;
+		} else if (ret < msg->tx_len) {
+			pr_err("%s: Read cmd Tx failed, too short: %d\n", __func__, ret);
+			return -ECOMM;
 		}
 
 		/*
diff --git a/drivers/gpu/drm/msm/hdmi/hdmi.c b/drivers/gpu/drm/msm/hdmi/hdmi.c
index 17e069a133a4..0df62c9c2856 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi.c
+++ b/drivers/gpu/drm/msm/hdmi/hdmi.c
@@ -148,6 +148,10 @@ static struct hdmi *msm_hdmi_init(struct platform_device *pdev)
 	/* HDCP needs physical address of hdmi register */
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
 		config->mmio_name);
+	if (!res) {
+		ret = -EINVAL;
+		goto fail;
+	}
 	hdmi->mmio_phy_addr = res->start;
 
 	hdmi->qfprom_mmio = msm_ioremap(pdev,
diff --git a/drivers/gpu/drm/msm/msm_gem_prime.c b/drivers/gpu/drm/msm/msm_gem_prime.c
index 13403c6da6c7..7e4664968106 100644
--- a/drivers/gpu/drm/msm/msm_gem_prime.c
+++ b/drivers/gpu/drm/msm/msm_gem_prime.c
@@ -26,7 +26,7 @@ struct sg_table *msm_gem_prime_get_sg_table(struct drm_gem_object *obj)
 	int npages = obj->size >> PAGE_SHIFT;
 
 	if (WARN_ON(!msm_obj->pages))  /* should have already pinned! */
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	return drm_prime_pages_to_sg(msm_obj->pages, npages);
 }
diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/clk/base.c b/drivers/gpu/drm/nouveau/nvkm/subdev/clk/base.c
index e4c8d310d870..6f5aa6fd8776 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/clk/base.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/clk/base.c
@@ -136,10 +136,10 @@ nvkm_cstate_find_best(struct nvkm_clk *clk, struct nvkm_pstate *pstate,
 	for (cstate = start; &cstate->head != &pstate->list;
 	     cstate = list_entry(cstate->head.prev, typeof(*cstate), head)) {
 		if (nvkm_cstate_valid(clk, cstate, max_volt, clk->temp))
-			break;
+			return cstate;
 	}
 
-	return cstate;
+	return NULL;
 }
 
 static struct nvkm_cstate *
@@ -170,6 +170,8 @@ nvkm_cstate_prog(struct nvkm_clk *clk, struct nvkm_pstate *pstate, int cstatei)
 	if (!list_empty(&pstate->list)) {
 		cstate = nvkm_cstate_get(clk, pstate, cstatei);
 		cstate = nvkm_cstate_find_best(clk, pstate, cstate);
+		if (!cstate)
+			return -EINVAL;
 	} else {
 		cstate = &pstate->base;
 	}
diff --git a/drivers/gpu/drm/radeon/radeon_connectors.c b/drivers/gpu/drm/radeon/radeon_connectors.c
index fc021b8e4077..dd7d771d13b5 100644
--- a/drivers/gpu/drm/radeon/radeon_connectors.c
+++ b/drivers/gpu/drm/radeon/radeon_connectors.c
@@ -489,6 +489,8 @@ static struct drm_display_mode *radeon_fp_native_mode(struct drm_encoder *encode
 	    native_mode->vdisplay != 0 &&
 	    native_mode->clock != 0) {
 		mode = drm_mode_duplicate(dev, native_mode);
+		if (!mode)
+			return NULL;
 		mode->type = DRM_MODE_TYPE_PREFERRED | DRM_MODE_TYPE_DRIVER;
 		drm_mode_set_name(mode);
 
@@ -503,6 +505,8 @@ static struct drm_display_mode *radeon_fp_native_mode(struct drm_encoder *encode
 		 * simpler.
 		 */
 		mode = drm_cvt_mode(dev, native_mode->hdisplay, native_mode->vdisplay, 60, true, false, false);
+		if (!mode)
+			return NULL;
 		mode->type = DRM_MODE_TYPE_PREFERRED | DRM_MODE_TYPE_DRIVER;
 		DRM_DEBUG_KMS("Adding cvt approximation of native panel mode %s\n", mode->name);
 	}
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
index 7010424b2f89..80a65eaed0be 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
@@ -1551,10 +1551,10 @@ static int vop_bind(struct device *dev, struct device *master, void *data)
 	vop_win_init(vop);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	vop->len = resource_size(res);
 	vop->regs = devm_ioremap_resource(dev, res);
 	if (IS_ERR(vop->regs))
 		return PTR_ERR(vop->regs);
+	vop->len = resource_size(res);
 
 	vop->regsbak = devm_kzalloc(dev, vop->len, GFP_KERNEL);
 	if (!vop->regsbak)
diff --git a/drivers/gpu/drm/virtio/virtgpu_display.c b/drivers/gpu/drm/virtio/virtgpu_display.c
index b6d52055a11f..3a5f73bc2a37 100644
--- a/drivers/gpu/drm/virtio/virtgpu_display.c
+++ b/drivers/gpu/drm/virtio/virtgpu_display.c
@@ -187,6 +187,8 @@ static int virtio_gpu_conn_get_modes(struct drm_connector *connector)
 		DRM_DEBUG("add mode: %dx%d\n", width, height);
 		mode = drm_cvt_mode(connector->dev, width, height, 60,
 				    false, false, false);
+		if (!mode)
+			return count;
 		mode->type |= DRM_MODE_TYPE_PREFERRED;
 		drm_mode_probed_add(connector, mode);
 		count++;
diff --git a/drivers/hid/hid-led.c b/drivers/hid/hid-led.c
index d3e1ab162f7c..7fc5982a0ca4 100644
--- a/drivers/hid/hid-led.c
+++ b/drivers/hid/hid-led.c
@@ -369,7 +369,7 @@ static const struct hidled_config hidled_configs[] = {
 		.type = DREAM_CHEEKY,
 		.name = "Dream Cheeky Webmail Notifier",
 		.short_name = "dream_cheeky",
-		.max_brightness = 31,
+		.max_brightness = 63,
 		.num_leds = 1,
 		.report_size = 9,
 		.report_type = RAW_REQUEST,
diff --git a/drivers/hwtracing/coresight/coresight-cpu-debug.c b/drivers/hwtracing/coresight/coresight-cpu-debug.c
index 2f6f46ea68e9..ccd59ba26609 100644
--- a/drivers/hwtracing/coresight/coresight-cpu-debug.c
+++ b/drivers/hwtracing/coresight/coresight-cpu-debug.c
@@ -391,9 +391,10 @@ static int debug_notifier_call(struct notifier_block *self,
 	int cpu;
 	struct debug_drvdata *drvdata;
 
-	mutex_lock(&debug_lock);
+	/* Bail out if we can't acquire the mutex or the functionality is off */
+	if (!mutex_trylock(&debug_lock))
+		return NOTIFY_DONE;
 
-	/* Bail out if the functionality is disabled */
 	if (!debug_enable)
 		goto skip_dump;
 
@@ -412,7 +413,7 @@ static int debug_notifier_call(struct notifier_block *self,
 
 skip_dump:
 	mutex_unlock(&debug_lock);
-	return 0;
+	return NOTIFY_DONE;
 }
 
 static struct notifier_block debug_notifier = {
diff --git a/drivers/i2c/busses/i2c-cadence.c b/drivers/i2c/busses/i2c-cadence.c
index c5475bb4fae6..2150afdcc083 100644
--- a/drivers/i2c/busses/i2c-cadence.c
+++ b/drivers/i2c/busses/i2c-cadence.c
@@ -511,7 +511,7 @@ static void cdns_i2c_master_reset(struct i2c_adapter *adap)
 static int cdns_i2c_process_msg(struct cdns_i2c *id, struct i2c_msg *msg,
 		struct i2c_adapter *adap)
 {
-	unsigned long time_left;
+	unsigned long time_left, msg_timeout;
 	u32 reg;
 
 	id->p_msg = msg;
@@ -536,8 +536,16 @@ static int cdns_i2c_process_msg(struct cdns_i2c *id, struct i2c_msg *msg,
 	else
 		cdns_i2c_msend(id);
 
+	/* Minimal time to execute this message */
+	msg_timeout = msecs_to_jiffies((1000 * msg->len * BITS_PER_BYTE) / id->i2c_clk);
+	/* Plus some wiggle room */
+	msg_timeout += msecs_to_jiffies(500);
+
+	if (msg_timeout < adap->timeout)
+		msg_timeout = adap->timeout;
+
 	/* Wait for the signal of completion */
-	time_left = wait_for_completion_timeout(&id->xfer_done, adap->timeout);
+	time_left = wait_for_completion_timeout(&id->xfer_done, msg_timeout);
 	if (time_left == 0) {
 		cdns_i2c_master_reset(adap);
 		dev_err(id->adap.dev.parent,
diff --git a/drivers/iio/dummy/iio_simple_dummy.c b/drivers/iio/dummy/iio_simple_dummy.c
index ad3410e528b6..7fef76f0b5c7 100644
--- a/drivers/iio/dummy/iio_simple_dummy.c
+++ b/drivers/iio/dummy/iio_simple_dummy.c
@@ -572,10 +572,9 @@ static struct iio_sw_device *iio_dummy_probe(const char *name)
 	struct iio_sw_device *swd;
 
 	swd = kzalloc(sizeof(*swd), GFP_KERNEL);
-	if (!swd) {
-		ret = -ENOMEM;
-		goto error_kzalloc;
-	}
+	if (!swd)
+		return ERR_PTR(-ENOMEM);
+
 	/*
 	 * Allocate an IIO device.
 	 *
@@ -587,7 +586,7 @@ static struct iio_sw_device *iio_dummy_probe(const char *name)
 	indio_dev = iio_device_alloc(sizeof(*st));
 	if (!indio_dev) {
 		ret = -ENOMEM;
-		goto error_ret;
+		goto error_free_swd;
 	}
 
 	st = iio_priv(indio_dev);
@@ -618,6 +617,10 @@ static struct iio_sw_device *iio_dummy_probe(const char *name)
 	 *    indio_dev->name = spi_get_device_id(spi)->name;
 	 */
 	indio_dev->name = kstrdup(name, GFP_KERNEL);
+	if (!indio_dev->name) {
+		ret = -ENOMEM;
+		goto error_free_device;
+	}
 
 	/* Provide description of available channels */
 	indio_dev->channels = iio_dummy_channels;
@@ -634,7 +637,7 @@ static struct iio_sw_device *iio_dummy_probe(const char *name)
 
 	ret = iio_simple_dummy_events_register(indio_dev);
 	if (ret < 0)
-		goto error_free_device;
+		goto error_free_name;
 
 	ret = iio_simple_dummy_configure_buffer(indio_dev);
 	if (ret < 0)
@@ -651,11 +654,12 @@ static struct iio_sw_device *iio_dummy_probe(const char *name)
 	iio_simple_dummy_unconfigure_buffer(indio_dev);
 error_unregister_events:
 	iio_simple_dummy_events_unregister(indio_dev);
+error_free_name:
+	kfree(indio_dev->name);
 error_free_device:
 	iio_device_free(indio_dev);
-error_ret:
+error_free_swd:
 	kfree(swd);
-error_kzalloc:
 	return ERR_PTR(ret);
 }
 
diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
index b3ab803bf8b1..7b8644610feb 100644
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -424,6 +424,8 @@ static ssize_t hfi1_write_iter(struct kiocb *kiocb, struct iov_iter *from)
 	unsigned long dim = from->nr_segs;
 	int idx;
 
+	if (!HFI1_CAP_IS_KSET(SDMA))
+		return -EINVAL;
 	idx = srcu_read_lock(&fd->pq_srcu);
 	pq = srcu_dereference(fd->pq, &fd->pq_srcu);
 	if (!cq || !pq) {
diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index 3f6e6233c60e..01df430d10bd 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -515,7 +515,7 @@ void set_link_ipg(struct hfi1_pportdata *ppd)
 	u16 shift, mult;
 	u64 src;
 	u32 current_egress_rate; /* Mbits /sec */
-	u32 max_pkt_time;
+	u64 max_pkt_time;
 	/*
 	 * max_pkt_time is the maximum packet egress time in units
 	 * of the fabric clock period 1/(805 MHz).
diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/rxe/rxe_req.c
index 693884160f00..5d0f4c0120ac 100644
--- a/drivers/infiniband/sw/rxe/rxe_req.c
+++ b/drivers/infiniband/sw/rxe/rxe_req.c
@@ -680,7 +680,7 @@ int rxe_requester(void *arg)
 	opcode = next_opcode(qp, wqe, wqe->wr.opcode);
 	if (unlikely(opcode < 0)) {
 		wqe->status = IB_WC_LOC_QP_OP_ERR;
-		goto exit;
+		goto err;
 	}
 
 	mask = rxe_opcode[opcode].mask;
diff --git a/drivers/input/misc/sparcspkr.c b/drivers/input/misc/sparcspkr.c
index 4a5afc7fe96e..f6e1f38267d9 100644
--- a/drivers/input/misc/sparcspkr.c
+++ b/drivers/input/misc/sparcspkr.c
@@ -204,6 +204,7 @@ static int bbc_beep_probe(struct platform_device *op)
 
 	info = &state->u.bbc;
 	info->clock_freq = of_getintprop_default(dp, "clock-frequency", 0);
+	of_node_put(dp);
 	if (!info->clock_freq)
 		goto out_free;
 
diff --git a/drivers/input/mouse/bcm5974.c b/drivers/input/mouse/bcm5974.c
index d0122134f320..f68816329a2e 100644
--- a/drivers/input/mouse/bcm5974.c
+++ b/drivers/input/mouse/bcm5974.c
@@ -956,17 +956,22 @@ static int bcm5974_probe(struct usb_interface *iface,
 	if (!dev->tp_data)
 		goto err_free_bt_buffer;
 
-	if (dev->bt_urb)
+	if (dev->bt_urb) {
 		usb_fill_int_urb(dev->bt_urb, udev,
 				 usb_rcvintpipe(udev, cfg->bt_ep),
 				 dev->bt_data, dev->cfg.bt_datalen,
 				 bcm5974_irq_button, dev, 1);
 
+		dev->bt_urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
+	}
+
 	usb_fill_int_urb(dev->tp_urb, udev,
 			 usb_rcvintpipe(udev, cfg->tp_ep),
 			 dev->tp_data, dev->cfg.tp_datalen,
 			 bcm5974_irq_trackpad, dev, 1);
 
+	dev->tp_urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
+
 	/* create bcm5974 device */
 	usb_make_path(udev, dev->phys, sizeof(dev->phys));
 	strlcat(dev->phys, "/input0", sizeof(dev->phys));
diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 5dddbb9b06f1..2a6a108f0e8c 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -89,7 +89,7 @@
 #define ACPI_DEVFLAG_LINT1              0x80
 #define ACPI_DEVFLAG_ATSDIS             0x10000000
 
-#define LOOP_TIMEOUT	100000
+#define LOOP_TIMEOUT	2000000
 /*
  * ACPI table definitions
  *
diff --git a/drivers/iommu/msm_iommu.c b/drivers/iommu/msm_iommu.c
index 92c8c83ce38c..cdbe487403a7 100644
--- a/drivers/iommu/msm_iommu.c
+++ b/drivers/iommu/msm_iommu.c
@@ -638,16 +638,19 @@ static void insert_iommu_master(struct device *dev,
 static int qcom_iommu_of_xlate(struct device *dev,
 			       struct of_phandle_args *spec)
 {
-	struct msm_iommu_dev *iommu;
+	struct msm_iommu_dev *iommu = NULL, *iter;
 	unsigned long flags;
 	int ret = 0;
 
 	spin_lock_irqsave(&msm_iommu_lock, flags);
-	list_for_each_entry(iommu, &qcom_iommu_devices, dev_node)
-		if (iommu->dev->of_node == spec->np)
+	list_for_each_entry(iter, &qcom_iommu_devices, dev_node) {
+		if (iter->dev->of_node == spec->np) {
+			iommu = iter;
 			break;
+		}
+	}
 
-	if (!iommu || iommu->dev->of_node != spec->np) {
+	if (!iommu) {
 		ret = -ENODEV;
 		goto fail;
 	}
diff --git a/drivers/iommu/mtk_iommu.c b/drivers/iommu/mtk_iommu.c
index 0f99e95a1a73..7ac868c71577 100644
--- a/drivers/iommu/mtk_iommu.c
+++ b/drivers/iommu/mtk_iommu.c
@@ -696,8 +696,7 @@ static int mtk_iommu_remove(struct platform_device *pdev)
 	iommu_device_sysfs_remove(&data->iommu);
 	iommu_device_unregister(&data->iommu);
 
-	if (iommu_present(&platform_bus_type))
-		bus_set_iommu(&platform_bus_type, NULL);
+	list_del(&data->list);
 
 	clk_disable_unprepare(data->bclk);
 	devm_free_irq(&pdev->dev, data->irq, data);
diff --git a/drivers/irqchip/irq-armada-370-xp.c b/drivers/irqchip/irq-armada-370-xp.c
index 5849ac5a2ad3..0fd428db3aa4 100644
--- a/drivers/irqchip/irq-armada-370-xp.c
+++ b/drivers/irqchip/irq-armada-370-xp.c
@@ -392,7 +392,16 @@ static void armada_xp_mpic_smp_cpu_init(void)
 
 static void armada_xp_mpic_perf_init(void)
 {
-	unsigned long cpuid = cpu_logical_map(smp_processor_id());
+	unsigned long cpuid;
+
+	/*
+	 * This Performance Counter Overflow interrupt is specific for
+	 * Armada 370 and XP. It is not available on Armada 375, 38x and 39x.
+	 */
+	if (!of_machine_is_compatible("marvell,armada-370-xp"))
+		return;
+
+	cpuid = cpu_logical_map(smp_processor_id());
 
 	/* Enable Performance Counter Overflow interrupts */
 	writel(ARMADA_370_XP_INT_CAUSE_PERF(cpuid),
diff --git a/drivers/irqchip/irq-aspeed-i2c-ic.c b/drivers/irqchip/irq-aspeed-i2c-ic.c
index 815b88dd18f2..45de46066d06 100644
--- a/drivers/irqchip/irq-aspeed-i2c-ic.c
+++ b/drivers/irqchip/irq-aspeed-i2c-ic.c
@@ -82,8 +82,8 @@ static int __init aspeed_i2c_ic_of_init(struct device_node *node,
 	}
 
 	i2c_ic->parent_irq = irq_of_parse_and_map(node, 0);
-	if (i2c_ic->parent_irq < 0) {
-		ret = i2c_ic->parent_irq;
+	if (!i2c_ic->parent_irq) {
+		ret = -EINVAL;
 		goto err_iounmap;
 	}
 
diff --git a/drivers/irqchip/irq-xtensa-mx.c b/drivers/irqchip/irq-xtensa-mx.c
index a15a9510c904..a71cd1c7e421 100644
--- a/drivers/irqchip/irq-xtensa-mx.c
+++ b/drivers/irqchip/irq-xtensa-mx.c
@@ -143,14 +143,25 @@ static struct irq_chip xtensa_mx_irq_chip = {
 	.irq_set_affinity = xtensa_mx_irq_set_affinity,
 };
 
+static void __init xtensa_mx_init_common(struct irq_domain *root_domain)
+{
+	unsigned int i;
+
+	irq_set_default_host(root_domain);
+	secondary_init_irq();
+
+	/* Initialize default IRQ routing to CPU 0 */
+	for (i = 0; i < XCHAL_NUM_EXTINTERRUPTS; ++i)
+		set_er(1, MIROUT(i));
+}
+
 int __init xtensa_mx_init_legacy(struct device_node *interrupt_parent)
 {
 	struct irq_domain *root_domain =
 		irq_domain_add_legacy(NULL, NR_IRQS - 1, 1, 0,
 				&xtensa_mx_irq_domain_ops,
 				&xtensa_mx_irq_chip);
-	irq_set_default_host(root_domain);
-	secondary_init_irq();
+	xtensa_mx_init_common(root_domain);
 	return 0;
 }
 
@@ -160,8 +171,7 @@ static int __init xtensa_mx_init(struct device_node *np,
 	struct irq_domain *root_domain =
 		irq_domain_add_linear(np, NR_IRQS, &xtensa_mx_irq_domain_ops,
 				&xtensa_mx_irq_chip);
-	irq_set_default_host(root_domain);
-	secondary_init_irq();
+	xtensa_mx_init_common(root_domain);
 	return 0;
 }
 IRQCHIP_DECLARE(xtensa_mx_irq_chip, "cdns,xtensa-mx", xtensa_mx_init);
diff --git a/drivers/macintosh/Kconfig b/drivers/macintosh/Kconfig
index 97a420c11eed..5e47d91da519 100644
--- a/drivers/macintosh/Kconfig
+++ b/drivers/macintosh/Kconfig
@@ -77,6 +77,10 @@ config ADB_PMU
 	  this device; you should do so if your machine is one of those
 	  mentioned above.
 
+config ADB_PMU_EVENT
+	def_bool y
+	depends on ADB_PMU && INPUT=y
+
 config ADB_PMU_LED
 	bool "Support for the Power/iBook front LED"
 	depends on ADB_PMU
diff --git a/drivers/macintosh/Makefile b/drivers/macintosh/Makefile
index ee803638e595..ff099c7d4edd 100644
--- a/drivers/macintosh/Makefile
+++ b/drivers/macintosh/Makefile
@@ -12,7 +12,8 @@ obj-$(CONFIG_MAC_EMUMOUSEBTN)	+= mac_hid.o
 obj-$(CONFIG_INPUT_ADBHID)	+= adbhid.o
 obj-$(CONFIG_ANSLCD)		+= ans-lcd.o
 
-obj-$(CONFIG_ADB_PMU)		+= via-pmu.o via-pmu-event.o
+obj-$(CONFIG_ADB_PMU)		+= via-pmu.o
+obj-$(CONFIG_ADB_PMU_EVENT)	+= via-pmu-event.o
 obj-$(CONFIG_ADB_PMU_LED)	+= via-pmu-led.o
 obj-$(CONFIG_PMAC_BACKLIGHT)	+= via-pmu-backlight.o
 obj-$(CONFIG_ADB_CUDA)		+= via-cuda.o
diff --git a/drivers/macintosh/via-pmu.c b/drivers/macintosh/via-pmu.c
index f6e040fcad9a..9d6828f49779 100644
--- a/drivers/macintosh/via-pmu.c
+++ b/drivers/macintosh/via-pmu.c
@@ -1440,7 +1440,7 @@ pmu_handle_data(unsigned char *data, int len)
 		pmu_pass_intr(data, len);
 		/* len == 6 is probably a bad check. But how do I
 		 * know what PMU versions send what events here? */
-		if (len == 6) {
+		if (IS_ENABLED(CONFIG_ADB_PMU_EVENT) && len == 6) {
 			via_pmu_event(PMU_EVT_POWER, !!(data[1]&8));
 			via_pmu_event(PMU_EVT_LID, data[1]&1);
 		}
diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
index 10a559cfb7ea..aa28fdcb81b9 100644
--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -85,11 +85,11 @@ static void msg_submit(struct mbox_chan *chan)
 exit:
 	spin_unlock_irqrestore(&chan->lock, flags);
 
-	/* kick start the timer immediately to avoid delays */
 	if (!err && (chan->txdone_method & TXDONE_BY_POLL)) {
-		/* but only if not already active */
-		if (!hrtimer_active(&chan->mbox->poll_hrt))
-			hrtimer_start(&chan->mbox->poll_hrt, 0, HRTIMER_MODE_REL);
+		/* kick start the timer immediately to avoid delays */
+		spin_lock_irqsave(&chan->mbox->poll_hrt_lock, flags);
+		hrtimer_start(&chan->mbox->poll_hrt, 0, HRTIMER_MODE_REL);
+		spin_unlock_irqrestore(&chan->mbox->poll_hrt_lock, flags);
 	}
 }
 
@@ -123,20 +123,26 @@ static enum hrtimer_restart txdone_hrtimer(struct hrtimer *hrtimer)
 		container_of(hrtimer, struct mbox_controller, poll_hrt);
 	bool txdone, resched = false;
 	int i;
+	unsigned long flags;
 
 	for (i = 0; i < mbox->num_chans; i++) {
 		struct mbox_chan *chan = &mbox->chans[i];
 
 		if (chan->active_req && chan->cl) {
-			resched = true;
 			txdone = chan->mbox->ops->last_tx_done(chan);
 			if (txdone)
 				tx_tick(chan, 0);
+			else
+				resched = true;
 		}
 	}
 
 	if (resched) {
-		hrtimer_forward_now(hrtimer, ms_to_ktime(mbox->txpoll_period));
+		spin_lock_irqsave(&mbox->poll_hrt_lock, flags);
+		if (!hrtimer_is_queued(hrtimer))
+			hrtimer_forward_now(hrtimer, ms_to_ktime(mbox->txpoll_period));
+		spin_unlock_irqrestore(&mbox->poll_hrt_lock, flags);
+
 		return HRTIMER_RESTART;
 	}
 	return HRTIMER_NORESTART;
@@ -473,6 +479,7 @@ int mbox_controller_register(struct mbox_controller *mbox)
 		hrtimer_init(&mbox->poll_hrt, CLOCK_MONOTONIC,
 			     HRTIMER_MODE_REL);
 		mbox->poll_hrt.function = txdone_hrtimer;
+		spin_lock_init(&mbox->poll_hrt_lock);
 	}
 
 	for (i = 0; i < mbox->num_chans; i++) {
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 5e8706a66c31..36d4cc1d7429 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2427,14 +2427,16 @@ static void sync_sbs(struct mddev *mddev, int nospares)
 
 static bool does_sb_need_changing(struct mddev *mddev)
 {
-	struct md_rdev *rdev;
+	struct md_rdev *rdev = NULL, *iter;
 	struct mdp_superblock_1 *sb;
 	int role;
 
 	/* Find a good rdev */
-	rdev_for_each(rdev, mddev)
-		if ((rdev->raid_disk >= 0) && !test_bit(Faulty, &rdev->flags))
+	rdev_for_each(iter, mddev)
+		if ((iter->raid_disk >= 0) && !test_bit(Faulty, &iter->flags)) {
+			rdev = iter;
 			break;
+		}
 
 	/* No good device found. */
 	if (!rdev)
@@ -7588,17 +7590,22 @@ EXPORT_SYMBOL(md_register_thread);
 
 void md_unregister_thread(struct md_thread **threadp)
 {
-	struct md_thread *thread = *threadp;
-	if (!thread)
-		return;
-	pr_debug("interrupting MD-thread pid %d\n", task_pid_nr(thread->tsk));
-	/* Locking ensures that mddev_unlock does not wake_up a
+	struct md_thread *thread;
+
+	/*
+	 * Locking ensures that mddev_unlock does not wake_up a
 	 * non-existent thread
 	 */
 	spin_lock(&pers_lock);
+	thread = *threadp;
+	if (!thread) {
+		spin_unlock(&pers_lock);
+		return;
+	}
 	*threadp = NULL;
 	spin_unlock(&pers_lock);
 
+	pr_debug("interrupting MD-thread pid %d\n", task_pid_nr(thread->tsk));
 	kthread_stop(thread->tsk);
 	kfree(thread);
 }
@@ -9264,16 +9271,18 @@ static int read_rdev(struct mddev *mddev, struct md_rdev *rdev)
 
 void md_reload_sb(struct mddev *mddev, int nr)
 {
-	struct md_rdev *rdev;
+	struct md_rdev *rdev = NULL, *iter;
 	int err;
 
 	/* Find the rdev */
-	rdev_for_each_rcu(rdev, mddev) {
-		if (rdev->desc_nr == nr)
+	rdev_for_each_rcu(iter, mddev) {
+		if (iter->desc_nr == nr) {
+			rdev = iter;
 			break;
+		}
 	}
 
-	if (!rdev || rdev->desc_nr != nr) {
+	if (!rdev) {
 		pr_warn("%s: %d Could not find rdev with nr %d\n", __func__, __LINE__, nr);
 		return;
 	}
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index e179c121c030..671d57c30690 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -150,21 +150,6 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 	pr_debug("md/raid0:%s: FINAL %d zones\n",
 		 mdname(mddev), conf->nr_strip_zones);
 
-	if (conf->nr_strip_zones == 1) {
-		conf->layout = RAID0_ORIG_LAYOUT;
-	} else if (mddev->layout == RAID0_ORIG_LAYOUT ||
-		   mddev->layout == RAID0_ALT_MULTIZONE_LAYOUT) {
-		conf->layout = mddev->layout;
-	} else if (default_layout == RAID0_ORIG_LAYOUT ||
-		   default_layout == RAID0_ALT_MULTIZONE_LAYOUT) {
-		conf->layout = default_layout;
-	} else {
-		pr_err("md/raid0:%s: cannot assemble multi-zone RAID0 with default_layout setting\n",
-		       mdname(mddev));
-		pr_err("md/raid0: please set raid0.default_layout to 1 or 2\n");
-		err = -ENOTSUPP;
-		goto abort;
-	}
 	/*
 	 * now since we have the hard sector sizes, we can make sure
 	 * chunk size is a multiple of that sector size
@@ -293,6 +278,22 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 			 (unsigned long long)smallest->sectors);
 	}
 
+	if (conf->nr_strip_zones == 1 || conf->strip_zone[1].nb_dev == 1) {
+		conf->layout = RAID0_ORIG_LAYOUT;
+	} else if (mddev->layout == RAID0_ORIG_LAYOUT ||
+		   mddev->layout == RAID0_ALT_MULTIZONE_LAYOUT) {
+		conf->layout = mddev->layout;
+	} else if (default_layout == RAID0_ORIG_LAYOUT ||
+		   default_layout == RAID0_ALT_MULTIZONE_LAYOUT) {
+		conf->layout = default_layout;
+	} else {
+		pr_err("md/raid0:%s: cannot assemble multi-zone RAID0 with default_layout setting\n",
+		       mdname(mddev));
+		pr_err("md/raid0: please set raid0.default_layout to 1 or 2\n");
+		err = -EOPNOTSUPP;
+		goto abort;
+	}
+
 	pr_debug("md/raid0:%s: done.\n", mdname(mddev));
 	*private_conf = conf;
 
diff --git a/drivers/media/pci/cx23885/cx23885-core.c b/drivers/media/pci/cx23885/cx23885-core.c
index 4612f26fcd6d..6f297caf5540 100644
--- a/drivers/media/pci/cx23885/cx23885-core.c
+++ b/drivers/media/pci/cx23885/cx23885-core.c
@@ -2005,7 +2005,7 @@ static int cx23885_initdev(struct pci_dev *pci_dev,
 	err = pci_set_dma_mask(pci_dev, 0xffffffff);
 	if (err) {
 		pr_err("%s/0: Oops: no 32bit PCI DMA ???\n", dev->name);
-		goto fail_ctrl;
+		goto fail_dma_set_mask;
 	}
 
 	err = request_irq(pci_dev->irq, cx23885_irq,
@@ -2013,7 +2013,7 @@ static int cx23885_initdev(struct pci_dev *pci_dev,
 	if (err < 0) {
 		pr_err("%s: can't get IRQ %d\n",
 		       dev->name, pci_dev->irq);
-		goto fail_irq;
+		goto fail_dma_set_mask;
 	}
 
 	switch (dev->board) {
@@ -2035,7 +2035,7 @@ static int cx23885_initdev(struct pci_dev *pci_dev,
 
 	return 0;
 
-fail_irq:
+fail_dma_set_mask:
 	cx23885_dev_unregister(dev);
 fail_ctrl:
 	v4l2_ctrl_handler_free(hdl);
diff --git a/drivers/media/pci/cx25821/cx25821-core.c b/drivers/media/pci/cx25821/cx25821-core.c
index 79582071f139..c5e0fa447e4d 100644
--- a/drivers/media/pci/cx25821/cx25821-core.c
+++ b/drivers/media/pci/cx25821/cx25821-core.c
@@ -1350,11 +1350,11 @@ static void cx25821_finidev(struct pci_dev *pci_dev)
 	struct cx25821_dev *dev = get_cx25821(v4l2_dev);
 
 	cx25821_shutdown(dev);
-	pci_disable_device(pci_dev);
 
 	/* unregister stuff */
 	if (pci_dev->irq)
 		free_irq(pci_dev->irq, dev);
+	pci_disable_device(pci_dev);
 
 	cx25821_dev_unregister(dev);
 	v4l2_device_unregister(v4l2_dev);
diff --git a/drivers/media/platform/exynos4-is/fimc-is.c b/drivers/media/platform/exynos4-is/fimc-is.c
index 0fe9be93fabe..0f3f82bd4d20 100644
--- a/drivers/media/platform/exynos4-is/fimc-is.c
+++ b/drivers/media/platform/exynos4-is/fimc-is.c
@@ -144,7 +144,7 @@ static int fimc_is_enable_clocks(struct fimc_is *is)
 			dev_err(&is->pdev->dev, "clock %s enable failed\n",
 				fimc_is_clocks[i]);
 			for (--i; i >= 0; i--)
-				clk_disable(is->clocks[i]);
+				clk_disable_unprepare(is->clocks[i]);
 			return ret;
 		}
 		pr_debug("enabled clock: %s\n", fimc_is_clocks[i]);
diff --git a/drivers/media/platform/exynos4-is/fimc-isp-video.h b/drivers/media/platform/exynos4-is/fimc-isp-video.h
index f79a1b348aa6..67ef85249912 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp-video.h
+++ b/drivers/media/platform/exynos4-is/fimc-isp-video.h
@@ -35,7 +35,7 @@ static inline int fimc_isp_video_device_register(struct fimc_isp *isp,
 	return 0;
 }
 
-void fimc_isp_video_device_unregister(struct fimc_isp *isp,
+static inline void fimc_isp_video_device_unregister(struct fimc_isp *isp,
 				enum v4l2_buf_type type)
 {
 }
diff --git a/drivers/media/platform/qcom/venus/hfi.c b/drivers/media/platform/qcom/venus/hfi.c
index ba29fd4d4984..7d1d3e64007c 100644
--- a/drivers/media/platform/qcom/venus/hfi.c
+++ b/drivers/media/platform/qcom/venus/hfi.c
@@ -117,6 +117,9 @@ int hfi_core_deinit(struct venus_core *core, bool blocking)
 		mutex_lock(&core->lock);
 	}
 
+	if (!core->ops)
+		goto unlock;
+
 	ret = core->ops->core_deinit(core);
 
 	if (!ret)
diff --git a/drivers/media/platform/sti/delta/delta-v4l2.c b/drivers/media/platform/sti/delta/delta-v4l2.c
index 7c925f309158..a489d0d17989 100644
--- a/drivers/media/platform/sti/delta/delta-v4l2.c
+++ b/drivers/media/platform/sti/delta/delta-v4l2.c
@@ -1880,7 +1880,7 @@ static int delta_probe(struct platform_device *pdev)
 	if (ret) {
 		dev_err(delta->dev, "%s failed to initialize firmware ipc channel\n",
 			DELTA_PREFIX);
-		goto err;
+		goto err_pm_disable;
 	}
 
 	/* register all available decoders */
@@ -1894,7 +1894,7 @@ static int delta_probe(struct platform_device *pdev)
 	if (ret) {
 		dev_err(delta->dev, "%s failed to register V4L2 device\n",
 			DELTA_PREFIX);
-		goto err;
+		goto err_pm_disable;
 	}
 
 	delta->work_queue = create_workqueue(DELTA_NAME);
@@ -1919,6 +1919,8 @@ static int delta_probe(struct platform_device *pdev)
 	destroy_workqueue(delta->work_queue);
 err_v4l2:
 	v4l2_device_unregister(&delta->v4l2_dev);
+err_pm_disable:
+	pm_runtime_disable(dev);
 err:
 	return ret;
 }
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
index 4ca7e1fad08b..4b0d44e25396 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
@@ -2563,6 +2563,11 @@ struct pvr2_hdw *pvr2_hdw_create(struct usb_interface *intf,
 	} while (0);
 	mutex_unlock(&pvr2_unit_mtx);
 
+	INIT_WORK(&hdw->workpoll, pvr2_hdw_worker_poll);
+
+	if (hdw->unit_number == -1)
+		goto fail;
+
 	cnt1 = 0;
 	cnt2 = scnprintf(hdw->name+cnt1,sizeof(hdw->name)-cnt1,"pvrusb2");
 	cnt1 += cnt2;
@@ -2574,8 +2579,6 @@ struct pvr2_hdw *pvr2_hdw_create(struct usb_interface *intf,
 	if (cnt1 >= sizeof(hdw->name)) cnt1 = sizeof(hdw->name)-1;
 	hdw->name[cnt1] = 0;
 
-	INIT_WORK(&hdw->workpoll,pvr2_hdw_worker_poll);
-
 	pvr2_trace(PVR2_TRACE_INIT,"Driver unit number is %d, name is %s",
 		   hdw->unit_number,hdw->name);
 
diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index 2b0ca32d7196..800b37a5bbe8 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -841,29 +841,31 @@ static int uvc_ioctl_enum_input(struct file *file, void *fh,
 	struct uvc_video_chain *chain = handle->chain;
 	const struct uvc_entity *selector = chain->selector;
 	struct uvc_entity *iterm = NULL;
+	struct uvc_entity *it;
 	u32 index = input->index;
-	int pin = 0;
 
 	if (selector == NULL ||
 	    (chain->dev->quirks & UVC_QUIRK_IGNORE_SELECTOR_UNIT)) {
 		if (index != 0)
 			return -EINVAL;
-		list_for_each_entry(iterm, &chain->entities, chain) {
-			if (UVC_ENTITY_IS_ITERM(iterm))
+		list_for_each_entry(it, &chain->entities, chain) {
+			if (UVC_ENTITY_IS_ITERM(it)) {
+				iterm = it;
 				break;
+			}
 		}
-		pin = iterm->id;
 	} else if (index < selector->bNrInPins) {
-		pin = selector->baSourceID[index];
-		list_for_each_entry(iterm, &chain->entities, chain) {
-			if (!UVC_ENTITY_IS_ITERM(iterm))
+		list_for_each_entry(it, &chain->entities, chain) {
+			if (!UVC_ENTITY_IS_ITERM(it))
 				continue;
-			if (iterm->id == pin)
+			if (it->id == selector->baSourceID[index]) {
+				iterm = it;
 				break;
+			}
 		}
 	}
 
-	if (iterm == NULL || iterm->id != pin)
+	if (iterm == NULL)
 		return -EINVAL;
 
 	memset(input, 0, sizeof(*input));
diff --git a/drivers/mfd/ipaq-micro.c b/drivers/mfd/ipaq-micro.c
index cd762d08f116..2ba0e2d575c0 100644
--- a/drivers/mfd/ipaq-micro.c
+++ b/drivers/mfd/ipaq-micro.c
@@ -410,7 +410,7 @@ static int __init micro_probe(struct platform_device *pdev)
 	micro_reset_comm(micro);
 
 	irq = platform_get_irq(pdev, 0);
-	if (!irq)
+	if (irq < 0)
 		return -EINVAL;
 	ret = devm_request_irq(&pdev->dev, irq, micro_serial_isr,
 			       IRQF_SHARED, "ipaq-micro",
diff --git a/drivers/mfd/rtsx_usb.c b/drivers/mfd/rtsx_usb.c
index 691dab791f7a..e94f855eac15 100644
--- a/drivers/mfd/rtsx_usb.c
+++ b/drivers/mfd/rtsx_usb.c
@@ -678,6 +678,7 @@ static int rtsx_usb_probe(struct usb_interface *intf,
 	return 0;
 
 out_init_fail:
+	usb_set_intfdata(ucr->pusb_intf, NULL);
 	usb_free_coherent(ucr->pusb_dev, IOBUF_SIZE, ucr->iobuf,
 			ucr->iobuf_dma);
 	return ret;
diff --git a/drivers/misc/lkdtm_usercopy.c b/drivers/misc/lkdtm_usercopy.c
index a64372cc148d..178b55141772 100644
--- a/drivers/misc/lkdtm_usercopy.c
+++ b/drivers/misc/lkdtm_usercopy.c
@@ -30,12 +30,12 @@ static const unsigned char test_text[] = "This is a test.\n";
  */
 static noinline unsigned char *trick_compiler(unsigned char *stack)
 {
-	return stack + 0;
+	return stack + unconst;
 }
 
 static noinline unsigned char *do_usercopy_stack_callee(int value)
 {
-	unsigned char buf[32];
+	unsigned char buf[128];
 	int i;
 
 	/* Exercise stack to avoid everything living in registers. */
@@ -43,7 +43,12 @@ static noinline unsigned char *do_usercopy_stack_callee(int value)
 		buf[i] = value & 0xff;
 	}
 
-	return trick_compiler(buf);
+	/*
+	 * Put the target buffer in the middle of stack allocation
+	 * so that we don't step on future stack users regardless
+	 * of stack growth direction.
+	 */
+	return trick_compiler(&buf[(128/2)-32]);
 }
 
 static noinline void do_usercopy_stack(bool to_user, bool bad_frame)
@@ -66,6 +71,12 @@ static noinline void do_usercopy_stack(bool to_user, bool bad_frame)
 		bad_stack -= sizeof(unsigned long);
 	}
 
+#ifdef ARCH_HAS_CURRENT_STACK_POINTER
+	pr_info("stack     : %px\n", (void *)current_stack_pointer);
+#endif
+	pr_info("good_stack: %px-%px\n", good_stack, good_stack + sizeof(good_stack));
+	pr_info("bad_stack : %px-%px\n", bad_stack, bad_stack + sizeof(good_stack));
+
 	user_addr = vm_mmap(NULL, 0, PAGE_SIZE,
 			    PROT_READ | PROT_WRITE | PROT_EXEC,
 			    MAP_ANONYMOUS | MAP_PRIVATE, 0);
diff --git a/drivers/mtd/chips/cfi_cmdset_0002.c b/drivers/mtd/chips/cfi_cmdset_0002.c
index 870d1f1331b1..e3477b5bceaf 100644
--- a/drivers/mtd/chips/cfi_cmdset_0002.c
+++ b/drivers/mtd/chips/cfi_cmdset_0002.c
@@ -49,6 +49,10 @@
 #define SST49LF008A		0x005a
 #define AT49BV6416		0x00d6
 
+enum cfi_quirks {
+	CFI_QUIRK_DQ_TRUE_DATA = BIT(0),
+};
+
 static int cfi_amdstd_read (struct mtd_info *, loff_t, size_t, size_t *, u_char *);
 static int cfi_amdstd_write_words(struct mtd_info *, loff_t, size_t, size_t *, const u_char *);
 static int cfi_amdstd_write_buffers(struct mtd_info *, loff_t, size_t, size_t *, const u_char *);
@@ -365,6 +369,15 @@ static void fixup_s29ns512p_sectors(struct mtd_info *mtd)
 		mtd->name);
 }
 
+static void fixup_quirks(struct mtd_info *mtd)
+{
+	struct map_info *map = mtd->priv;
+	struct cfi_private *cfi = map->fldrv_priv;
+
+	if (cfi->mfr == CFI_MFR_AMD && cfi->id == 0x0c01)
+		cfi->quirks |= CFI_QUIRK_DQ_TRUE_DATA;
+}
+
 /* Used to fix CFI-Tables of chips without Extended Query Tables */
 static struct cfi_fixup cfi_nopri_fixup_table[] = {
 	{ CFI_MFR_SST, 0x234a, fixup_sst39vf }, /* SST39VF1602 */
@@ -403,6 +416,7 @@ static struct cfi_fixup cfi_fixup_table[] = {
 #if !FORCE_WORD_WRITE
 	{ CFI_MFR_ANY, CFI_ID_ANY, fixup_use_write_buffers },
 #endif
+	{ CFI_MFR_ANY, CFI_ID_ANY, fixup_quirks },
 	{ 0, 0, NULL }
 };
 static struct cfi_fixup jedec_fixup_table[] = {
@@ -730,50 +744,46 @@ static struct mtd_info *cfi_amdstd_setup(struct mtd_info *mtd)
 }
 
 /*
- * Return true if the chip is ready.
+ * Return true if the chip is ready and has the correct value.
  *
  * Ready is one of: read mode, query mode, erase-suspend-read mode (in any
  * non-suspended sector) and is indicated by no toggle bits toggling.
  *
+ * Error are indicated by toggling bits or bits held with the wrong value,
+ * or with bits toggling.
+ *
  * Note that anything more complicated than checking if no bits are toggling
  * (including checking DQ5 for an error status) is tricky to get working
  * correctly and is therefore not done	(particularly with interleaved chips
  * as each chip must be checked independently of the others).
  */
-static int __xipram chip_ready(struct map_info *map, unsigned long addr)
+static int __xipram chip_ready(struct map_info *map, unsigned long addr,
+			       map_word *expected)
 {
 	map_word d, t;
+	int ret;
 
 	d = map_read(map, addr);
 	t = map_read(map, addr);
 
-	return map_word_equal(map, d, t);
+	ret = map_word_equal(map, d, t);
+
+	if (!ret || !expected)
+		return ret;
+
+	return map_word_equal(map, t, *expected);
 }
 
-/*
- * Return true if the chip is ready and has the correct value.
- *
- * Ready is one of: read mode, query mode, erase-suspend-read mode (in any
- * non-suspended sector) and it is indicated by no bits toggling.
- *
- * Error are indicated by toggling bits or bits held with the wrong value,
- * or with bits toggling.
- *
- * Note that anything more complicated than checking if no bits are toggling
- * (including checking DQ5 for an error status) is tricky to get working
- * correctly and is therefore not done	(particularly with interleaved chips
- * as each chip must be checked independently of the others).
- *
- */
-static int __xipram chip_good(struct map_info *map, unsigned long addr, map_word expected)
+static int __xipram chip_good(struct map_info *map, unsigned long addr,
+			      map_word *expected)
 {
-	map_word oldd, curd;
+	struct cfi_private *cfi = map->fldrv_priv;
+	map_word *datum = expected;
 
-	oldd = map_read(map, addr);
-	curd = map_read(map, addr);
+	if (cfi->quirks & CFI_QUIRK_DQ_TRUE_DATA)
+		datum = NULL;
 
-	return	map_word_equal(map, oldd, curd) &&
-		map_word_equal(map, curd, expected);
+	return chip_ready(map, addr, datum);
 }
 
 static int get_chip(struct map_info *map, struct flchip *chip, unsigned long adr, int mode)
@@ -790,7 +800,7 @@ static int get_chip(struct map_info *map, struct flchip *chip, unsigned long adr
 
 	case FL_STATUS:
 		for (;;) {
-			if (chip_ready(map, adr))
+			if (chip_ready(map, adr, NULL))
 				break;
 
 			if (time_after(jiffies, timeo)) {
@@ -828,7 +838,7 @@ static int get_chip(struct map_info *map, struct flchip *chip, unsigned long adr
 		chip->state = FL_ERASE_SUSPENDING;
 		chip->erase_suspended = 1;
 		for (;;) {
-			if (chip_ready(map, adr))
+			if (chip_ready(map, adr, NULL))
 				break;
 
 			if (time_after(jiffies, timeo)) {
@@ -1361,7 +1371,7 @@ static int do_otp_lock(struct map_info *map, struct flchip *chip, loff_t adr,
 	/* wait for chip to become ready */
 	timeo = jiffies + msecs_to_jiffies(2);
 	for (;;) {
-		if (chip_ready(map, adr))
+		if (chip_ready(map, adr, NULL))
 			break;
 
 		if (time_after(jiffies, timeo)) {
@@ -1631,7 +1641,8 @@ static int __xipram do_write_oneword(struct map_info *map, struct flchip *chip,
 		 * We check "time_after" and "!chip_good" before checking
 		 * "chip_good" to avoid the failure due to scheduling.
 		 */
-		if (time_after(jiffies, timeo) && !chip_good(map, adr, datum)) {
+		if (time_after(jiffies, timeo) &&
+		    !chip_good(map, adr, &datum)) {
 			xip_enable(map, chip, adr);
 			printk(KERN_WARNING "MTD %s(): software timeout\n", __func__);
 			xip_disable(map, chip, adr);
@@ -1639,7 +1650,7 @@ static int __xipram do_write_oneword(struct map_info *map, struct flchip *chip,
 			break;
 		}
 
-		if (chip_good(map, adr, datum))
+		if (chip_good(map, adr, &datum))
 			break;
 
 		/* Latency issues. Drop the lock, wait a while and retry */
@@ -1883,13 +1894,13 @@ static int __xipram do_write_buffer(struct map_info *map, struct flchip *chip,
 		}
 
 		/*
-		 * We check "time_after" and "!chip_good" before checking "chip_good" to avoid
-		 * the failure due to scheduling.
+		 * We check "time_after" and "!chip_good" before checking
+		 * "chip_good" to avoid the failure due to scheduling.
 		 */
-		if (time_after(jiffies, timeo) && !chip_good(map, adr, datum))
+		if (time_after(jiffies, timeo) && !chip_good(map, adr, &datum))
 			break;
 
-		if (chip_good(map, adr, datum)) {
+		if (chip_good(map, adr, &datum)) {
 			xip_enable(map, chip, adr);
 			goto op_done;
 		}
@@ -2023,7 +2034,7 @@ static int cfi_amdstd_panic_wait(struct map_info *map, struct flchip *chip,
 	 * If the driver thinks the chip is idle, and no toggle bits
 	 * are changing, then the chip is actually idle for sure.
 	 */
-	if (chip->state == FL_READY && chip_ready(map, adr))
+	if (chip->state == FL_READY && chip_ready(map, adr, NULL))
 		return 0;
 
 	/*
@@ -2040,7 +2051,7 @@ static int cfi_amdstd_panic_wait(struct map_info *map, struct flchip *chip,
 
 		/* wait for the chip to become ready */
 		for (i = 0; i < jiffies_to_usecs(timeo); i++) {
-			if (chip_ready(map, adr))
+			if (chip_ready(map, adr, NULL))
 				return 0;
 
 			udelay(1);
@@ -2104,13 +2115,13 @@ static int do_panic_write_oneword(struct map_info *map, struct flchip *chip,
 	map_write(map, datum, adr);
 
 	for (i = 0; i < jiffies_to_usecs(uWriteTimeout); i++) {
-		if (chip_ready(map, adr))
+		if (chip_ready(map, adr, NULL))
 			break;
 
 		udelay(1);
 	}
 
-	if (!chip_good(map, adr, datum)) {
+	if (!chip_ready(map, adr, &datum)) {
 		/* reset on all failures. */
 		map_write(map, CMD(0xF0), chip->start);
 		/* FIXME - should have reset delay before continuing */
@@ -2251,6 +2262,7 @@ static int __xipram do_erase_chip(struct map_info *map, struct flchip *chip)
 	DECLARE_WAITQUEUE(wait, current);
 	int ret = 0;
 	int retry_cnt = 0;
+	map_word datum = map_word_ff(map);
 
 	adr = cfi->addr_unlock1;
 
@@ -2305,7 +2317,7 @@ static int __xipram do_erase_chip(struct map_info *map, struct flchip *chip)
 			chip->erase_suspended = 0;
 		}
 
-		if (chip_good(map, adr, map_word_ff(map)))
+		if (chip_ready(map, adr, &datum))
 			break;
 
 		if (time_after(jiffies, timeo)) {
@@ -2347,6 +2359,7 @@ static int __xipram do_erase_oneblock(struct map_info *map, struct flchip *chip,
 	DECLARE_WAITQUEUE(wait, current);
 	int ret = 0;
 	int retry_cnt = 0;
+	map_word datum = map_word_ff(map);
 
 	adr += chip->start;
 
@@ -2401,7 +2414,7 @@ static int __xipram do_erase_oneblock(struct map_info *map, struct flchip *chip,
 			chip->erase_suspended = 0;
 		}
 
-		if (chip_good(map, adr, map_word_ff(map))) {
+		if (chip_ready(map, adr, &datum)) {
 			xip_enable(map, chip, adr);
 			break;
 		}
@@ -2616,7 +2629,7 @@ static int __maybe_unused do_ppb_xxlock(struct map_info *map,
 	 */
 	timeo = jiffies + msecs_to_jiffies(2000);	/* 2s max (un)locking */
 	for (;;) {
-		if (chip_ready(map, adr))
+		if (chip_ready(map, adr, NULL))
 			break;
 
 		if (time_after(jiffies, timeo)) {
diff --git a/drivers/mtd/ubi/vmt.c b/drivers/mtd/ubi/vmt.c
index 8f641448a97a..d32144c0098a 100644
--- a/drivers/mtd/ubi/vmt.c
+++ b/drivers/mtd/ubi/vmt.c
@@ -315,7 +315,6 @@ int ubi_create_volume(struct ubi_device *ubi, struct ubi_mkvol_req *req)
 	ubi->volumes[vol_id] = NULL;
 	ubi->vol_count -= 1;
 	spin_unlock(&ubi->volumes_lock);
-	ubi_eba_destroy_table(eba_tbl);
 out_acc:
 	spin_lock(&ubi->volumes_lock);
 	ubi->rsvd_pebs -= vol->reserved_pebs;
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 7ab4cc0962ac..ef016c9f7c74 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2317,6 +2317,7 @@ static int mv88e6xxx_mdios_register(struct mv88e6xxx_chip *chip,
 	 */
 	child = of_get_child_by_name(np, "mdio");
 	err = mv88e6xxx_mdio_register(chip, child, false);
+	of_node_put(child);
 	if (err)
 		return err;
 
diff --git a/drivers/net/ethernet/altera/altera_tse_main.c b/drivers/net/ethernet/altera/altera_tse_main.c
index 691fd194e5ea..1c0f11ec7a83 100644
--- a/drivers/net/ethernet/altera/altera_tse_main.c
+++ b/drivers/net/ethernet/altera/altera_tse_main.c
@@ -174,7 +174,8 @@ static int altera_tse_mdio_create(struct net_device *dev, unsigned int id)
 	mdio = mdiobus_alloc();
 	if (mdio == NULL) {
 		netdev_err(dev, "Error allocating MDIO bus\n");
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto put_node;
 	}
 
 	mdio->name = ALTERA_TSE_RESOURCE_NAME;
@@ -191,6 +192,7 @@ static int altera_tse_mdio_create(struct net_device *dev, unsigned int id)
 			   mdio->id);
 		goto out_free_mdio;
 	}
+	of_node_put(mdio_node);
 
 	if (netif_msg_drv(priv))
 		netdev_info(dev, "MDIO bus %s: created\n", mdio->id);
@@ -200,6 +202,8 @@ static int altera_tse_mdio_create(struct net_device *dev, unsigned int id)
 out_free_mdio:
 	mdiobus_free(mdio);
 	mdio = NULL;
+put_node:
+	of_node_put(mdio_node);
 	return ret;
 }
 
diff --git a/drivers/net/ethernet/broadcom/Makefile b/drivers/net/ethernet/broadcom/Makefile
index 7046ad6d3d0e..ac50da49ca77 100644
--- a/drivers/net/ethernet/broadcom/Makefile
+++ b/drivers/net/ethernet/broadcom/Makefile
@@ -16,3 +16,8 @@ obj-$(CONFIG_BGMAC_BCMA) += bgmac-bcma.o bgmac-bcma-mdio.o
 obj-$(CONFIG_BGMAC_PLATFORM) += bgmac-platform.o
 obj-$(CONFIG_SYSTEMPORT) += bcmsysport.o
 obj-$(CONFIG_BNXT) += bnxt/
+
+# FIXME: temporarily silence -Warray-bounds on non W=1+ builds
+ifndef KBUILD_EXTRA_WARN
+CFLAGS_tg3.o += -Wno-array-bounds
+endif
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
index 7f3941752aa0..f36bb9e7d8d5 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
@@ -1156,9 +1156,9 @@ static int ixgbe_update_vf_xcast_mode(struct ixgbe_adapter *adapter,
 
 	switch (xcast_mode) {
 	case IXGBEVF_XCAST_MODE_NONE:
-		disable = IXGBE_VMOLR_BAM | IXGBE_VMOLR_ROMPE |
+		disable = IXGBE_VMOLR_ROMPE |
 			  IXGBE_VMOLR_MPE | IXGBE_VMOLR_UPE | IXGBE_VMOLR_VPE;
-		enable = 0;
+		enable = IXGBE_VMOLR_BAM;
 		break;
 	case IXGBEVF_XCAST_MODE_MULTI:
 		disable = IXGBE_VMOLR_MPE | IXGBE_VMOLR_UPE | IXGBE_VMOLR_VPE;
@@ -1180,9 +1180,9 @@ static int ixgbe_update_vf_xcast_mode(struct ixgbe_adapter *adapter,
 			return -EPERM;
 		}
 
-		disable = 0;
+		disable = IXGBE_VMOLR_VPE;
 		enable = IXGBE_VMOLR_BAM | IXGBE_VMOLR_ROMPE |
-			 IXGBE_VMOLR_MPE | IXGBE_VMOLR_UPE | IXGBE_VMOLR_VPE;
+			 IXGBE_VMOLR_MPE | IXGBE_VMOLR_UPE;
 		break;
 	default:
 		return -EOPNOTSUPP;
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index dbd16dd5aa04..ade72b46e93c 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1579,6 +1579,9 @@ static int mtk_hwlro_get_fdir_entry(struct net_device *dev,
 	struct ethtool_rx_flow_spec *fsp =
 		(struct ethtool_rx_flow_spec *)&cmd->fs;
 
+	if (fsp->location >= ARRAY_SIZE(mac->hwlro_ip))
+		return -EINVAL;
+
 	/* only tcp dst ipv4 is meaningful, others are meaningless */
 	fsp->flow_type = TCP_V4_FLOW;
 	fsp->h_u.tcp_ip4_spec.ip4dst = ntohl(mac->hwlro_ip[fsp->location]);
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
index 565e1ac241aa..cca7aaf03777 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
@@ -2055,7 +2055,7 @@ static int mlx4_en_get_module_eeprom(struct net_device *dev,
 			en_err(priv,
 			       "mlx4_get_module_info i(%d) offset(%d) bytes_to_read(%d) - FAILED (0x%x)\n",
 			       i, offset, ee->len - i, ret);
-			return 0;
+			return ret;
 		}
 
 		i += ret;
diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 7b9480ce21a2..2911648d4669 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -716,7 +716,6 @@ int __init mdio_bus_init(void)
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(mdio_bus_init);
 
 #if IS_ENABLED(CONFIG_PHYLIB)
 void mdio_bus_exit(void)
diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 755aa6741292..6f15cd5d4e7a 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -285,7 +285,7 @@ static int kszphy_config_reset(struct phy_device *phydev)
 		}
 	}
 
-	if (priv->led_mode >= 0)
+	if (priv->type && priv->led_mode >= 0)
 		kszphy_setup_led(phydev, priv->type->led_mode_reg, priv->led_mode);
 
 	return 0;
@@ -301,10 +301,10 @@ static int kszphy_config_init(struct phy_device *phydev)
 
 	type = priv->type;
 
-	if (type->has_broadcast_disable)
+	if (type && type->has_broadcast_disable)
 		kszphy_broadcast_disable(phydev);
 
-	if (type->has_nand_tree_disable)
+	if (type && type->has_nand_tree_disable)
 		kszphy_nand_tree_disable(phydev);
 
 	return kszphy_config_reset(phydev);
@@ -764,7 +764,7 @@ static int kszphy_probe(struct phy_device *phydev)
 
 	priv->type = type;
 
-	if (type->led_mode_reg) {
+	if (type && type->led_mode_reg) {
 		ret = of_property_read_u32(np, "micrel,led-mode",
 				&priv->led_mode);
 		if (ret)
@@ -785,7 +785,8 @@ static int kszphy_probe(struct phy_device *phydev)
 		unsigned long rate = clk_get_rate(clk);
 		bool rmii_ref_clk_sel_25_mhz;
 
-		priv->rmii_ref_clk_sel = type->has_rmii_ref_clk_sel;
+		if (type)
+			priv->rmii_ref_clk_sel = type->has_rmii_ref_clk_sel;
 		rmii_ref_clk_sel_25_mhz = of_property_read_bool(np,
 				"micrel,rmii-reference-clock-select-25-mhz");
 
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 694a58b1e995..bdbe0427b90e 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -5501,7 +5501,7 @@ unsigned int ar9003_get_paprd_scale_factor(struct ath_hw *ah,
 
 static u8 ar9003_get_eepmisc(struct ath_hw *ah)
 {
-	return ah->eeprom.map4k.baseEepHeader.eepMisc;
+	return ah->eeprom.ar9300_eep.baseEepHeader.opCapFlags.eepMisc;
 }
 
 const struct eeprom_ops eep_ar9300_ops = {
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
index a171dbb29fbb..ad949eb02f3d 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -720,7 +720,7 @@
 #define AR_CH0_TOP2		(AR_SREV_9300(ah) ? 0x1628c : \
 					(AR_SREV_9462(ah) ? 0x16290 : 0x16284))
 #define AR_CH0_TOP2_XPABIASLVL		(AR_SREV_9561(ah) ? 0x1e00 : 0xf000)
-#define AR_CH0_TOP2_XPABIASLVL_S	12
+#define AR_CH0_TOP2_XPABIASLVL_S	(AR_SREV_9561(ah) ? 9 : 12)
 
 #define AR_CH0_XTAL		(AR_SREV_9300(ah) ? 0x16294 : \
 				 ((AR_SREV_9462(ah) || AR_SREV_9565(ah)) ? 0x16298 : \
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 6782c3d0c333..e62ed7f42281 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -1005,6 +1005,14 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 		goto rx_next;
 	}
 
+	if (rxstatus->rs_keyix >= ATH_KEYMAX &&
+	    rxstatus->rs_keyix != ATH9K_RXKEYIX_INVALID) {
+		ath_dbg(common, ANY,
+			"Invalid keyix, dropping (keyix: %d)\n",
+			rxstatus->rs_keyix);
+		goto rx_next;
+	}
+
 	/* Get the RX status information */
 
 	memset(rx_status, 0, sizeof(struct ieee80211_rx_status));
diff --git a/drivers/net/wireless/ath/carl9170/tx.c b/drivers/net/wireless/ath/carl9170/tx.c
index 0cb5b58925dc..40369cb59eb5 100644
--- a/drivers/net/wireless/ath/carl9170/tx.c
+++ b/drivers/net/wireless/ath/carl9170/tx.c
@@ -1554,6 +1554,9 @@ static struct carl9170_vif_info *carl9170_pick_beaconing_vif(struct ar9170 *ar)
 					goto out;
 			}
 		} while (ar->beacon_enabled && i--);
+
+		/* no entry found in list */
+		return NULL;
 	}
 
 out:
diff --git a/drivers/net/wireless/broadcom/b43/phy_n.c b/drivers/net/wireless/broadcom/b43/phy_n.c
index d1afa74aa144..9cbc17c2751c 100644
--- a/drivers/net/wireless/broadcom/b43/phy_n.c
+++ b/drivers/net/wireless/broadcom/b43/phy_n.c
@@ -594,7 +594,7 @@ static void b43_nphy_adjust_lna_gain_table(struct b43_wldev *dev)
 	u16 data[4];
 	s16 gain[2];
 	u16 minmax[2];
-	static const u16 lna_gain[4] = { -2, 10, 19, 25 };
+	static const s16 lna_gain[4] = { -2, 10, 19, 25 };
 
 	if (nphy->hang_avoid)
 		b43_nphy_stay_in_carrier_search(dev, 1);
diff --git a/drivers/net/wireless/broadcom/b43legacy/phy.c b/drivers/net/wireless/broadcom/b43legacy/phy.c
index 995c7d0c212a..11ee5ee48976 100644
--- a/drivers/net/wireless/broadcom/b43legacy/phy.c
+++ b/drivers/net/wireless/broadcom/b43legacy/phy.c
@@ -1148,7 +1148,7 @@ void b43legacy_phy_lo_b_measure(struct b43legacy_wldev *dev)
 	struct b43legacy_phy *phy = &dev->phy;
 	u16 regstack[12] = { 0 };
 	u16 mls;
-	u16 fval;
+	s16 fval;
 	int i;
 	int j;
 
diff --git a/drivers/net/wireless/intel/ipw2x00/libipw_tx.c b/drivers/net/wireless/intel/ipw2x00/libipw_tx.c
index 84205aa508df..daa4f9eb08ff 100644
--- a/drivers/net/wireless/intel/ipw2x00/libipw_tx.c
+++ b/drivers/net/wireless/intel/ipw2x00/libipw_tx.c
@@ -397,7 +397,7 @@ netdev_tx_t libipw_xmit(struct sk_buff *skb, struct net_device *dev)
 
 		/* Each fragment may need to have room for encryption
 		 * pre/postfix */
-		if (host_encrypt)
+		if (host_encrypt && crypt && crypt->ops)
 			bytes_per_frag -= crypt->ops->extra_mpdu_prefix_len +
 			    crypt->ops->extra_mpdu_postfix_len;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/power.c b/drivers/net/wireless/intel/iwlwifi/mvm/power.c
index c11fe2621d51..cd19831ace57 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/power.c
@@ -611,6 +611,9 @@ static void iwl_mvm_power_get_vifs_iterator(void *_data, u8 *mac,
 	struct iwl_power_vifs *power_iterator = _data;
 	bool active = mvmvif->phy_ctxt && mvmvif->phy_ctxt->id < NUM_PHY_CTX;
 
+	if (!mvmvif->uploaded)
+		return;
+
 	switch (ieee80211_vif_type_p2p(vif)) {
 	case NL80211_IFTYPE_P2P_DEVICE:
 		break;
diff --git a/drivers/net/wireless/marvell/mwifiex/11h.c b/drivers/net/wireless/marvell/mwifiex/11h.c
index 238accfe4f41..c4176e357b22 100644
--- a/drivers/net/wireless/marvell/mwifiex/11h.c
+++ b/drivers/net/wireless/marvell/mwifiex/11h.c
@@ -303,5 +303,7 @@ void mwifiex_dfs_chan_sw_work_queue(struct work_struct *work)
 
 	mwifiex_dbg(priv->adapter, MSG,
 		    "indicating channel switch completion to kernel\n");
+	mutex_lock(&priv->wdev.mtx);
 	cfg80211_ch_switch_notify(priv->netdev, &priv->dfs_chandef);
+	mutex_unlock(&priv->wdev.mtx);
 }
diff --git a/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c b/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
index 225c1c8851cc..77bf8a601ca4 100644
--- a/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
@@ -460,8 +460,10 @@ static void rtl8180_tx(struct ieee80211_hw *dev,
 	struct rtl8180_priv *priv = dev->priv;
 	struct rtl8180_tx_ring *ring;
 	struct rtl8180_tx_desc *entry;
+	unsigned int prio = 0;
 	unsigned long flags;
-	unsigned int idx, prio, hw_prio;
+	unsigned int idx, hw_prio;
+
 	dma_addr_t mapping;
 	u32 tx_flags;
 	u8 rc_flags;
@@ -470,7 +472,9 @@ static void rtl8180_tx(struct ieee80211_hw *dev,
 	/* do arithmetic and then convert to le16 */
 	u16 frame_duration = 0;
 
-	prio = skb_get_queue_mapping(skb);
+	/* rtl8180/rtl8185 only has one useable tx queue */
+	if (dev->queues > IEEE80211_AC_BK)
+		prio = skb_get_queue_mapping(skb);
 	ring = &priv->tx_ring[prio];
 
 	mapping = pci_map_single(priv->pdev, skb->data,
diff --git a/drivers/net/wireless/realtek/rtlwifi/usb.c b/drivers/net/wireless/realtek/rtlwifi/usb.c
index 4fa4d877f913..c29beb00203c 100644
--- a/drivers/net/wireless/realtek/rtlwifi/usb.c
+++ b/drivers/net/wireless/realtek/rtlwifi/usb.c
@@ -1060,7 +1060,7 @@ int rtl_usb_probe(struct usb_interface *intf,
 	hw = ieee80211_alloc_hw(sizeof(struct rtl_priv) +
 				sizeof(struct rtl_usb_priv), &rtl_ops);
 	if (!hw) {
-		WARN_ONCE(true, "rtl_usb: ieee80211 alloc failed\n");
+		pr_warn("rtl_usb: ieee80211 alloc failed\n");
 		return -ENOMEM;
 	}
 	rtlpriv = hw->priv;
diff --git a/drivers/nfc/st21nfca/se.c b/drivers/nfc/st21nfca/se.c
index 475f8a67856d..21ab3e678cf3 100644
--- a/drivers/nfc/st21nfca/se.c
+++ b/drivers/nfc/st21nfca/se.c
@@ -320,7 +320,7 @@ int st21nfca_connectivity_event_received(struct nfc_hci_dev *hdev, u8 host,
 		 * AID		81	5 to 16
 		 * PARAMETERS	82	0 to 255
 		 */
-		if (skb->len < NFC_MIN_AID_LENGTH + 2 &&
+		if (skb->len < NFC_MIN_AID_LENGTH + 2 ||
 		    skb->data[0] != NFC_EVT_TRANSACTION_AID_TAG)
 			return -EPROTO;
 
@@ -332,22 +332,29 @@ int st21nfca_connectivity_event_received(struct nfc_hci_dev *hdev, u8 host,
 		transaction->aid_len = skb->data[1];
 
 		/* Checking if the length of the AID is valid */
-		if (transaction->aid_len > sizeof(transaction->aid))
+		if (transaction->aid_len > sizeof(transaction->aid)) {
+			devm_kfree(dev, transaction);
 			return -EINVAL;
+		}
 
 		memcpy(transaction->aid, &skb->data[2],
 		       transaction->aid_len);
 
 		/* Check next byte is PARAMETERS tag (82) */
 		if (skb->data[transaction->aid_len + 2] !=
-		    NFC_EVT_TRANSACTION_PARAMS_TAG)
+		    NFC_EVT_TRANSACTION_PARAMS_TAG) {
+			devm_kfree(dev, transaction);
 			return -EPROTO;
+		}
 
 		transaction->params_len = skb->data[transaction->aid_len + 3];
 
 		/* Total size is allocated (skb->len - 2) minus fixed array members */
-		if (transaction->params_len > ((skb->len - 2) - sizeof(struct nfc_evt_transaction)))
+		if (transaction->params_len > ((skb->len - 2) -
+		    sizeof(struct nfc_evt_transaction))) {
+			devm_kfree(dev, transaction);
 			return -EINVAL;
+		}
 
 		memcpy(transaction->params, skb->data +
 		       transaction->aid_len + 4, transaction->params_len);
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 92f269a0846c..de23f2814877 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1424,6 +1424,7 @@ static int nvme_alloc_admin_tags(struct nvme_dev *dev)
 		dev->ctrl.admin_q = blk_mq_init_queue(&dev->admin_tagset);
 		if (IS_ERR(dev->ctrl.admin_q)) {
 			blk_mq_free_tag_set(&dev->admin_tagset);
+			dev->ctrl.admin_q = NULL;
 			return -ENOMEM;
 		}
 		if (!blk_get_queue(dev->ctrl.admin_q)) {
diff --git a/drivers/pci/dwc/pcie-qcom.c b/drivers/pci/dwc/pcie-qcom.c
index b84603f52dc1..fe710f83e59b 100644
--- a/drivers/pci/dwc/pcie-qcom.c
+++ b/drivers/pci/dwc/pcie-qcom.c
@@ -1302,10 +1302,15 @@ static int qcom_pcie_probe(struct platform_device *pdev)
 	ret = dw_pcie_host_init(pp);
 	if (ret) {
 		dev_err(dev, "cannot initialize host\n");
-		return ret;
+		goto err_phy_exit;
 	}
 
 	return 0;
+
+err_phy_exit:
+	phy_exit(pcie->phy);
+
+	return ret;
 }
 
 static const struct of_device_id qcom_pcie_match[] = {
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 4ff7f2575d28..efcd06064953 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -4153,18 +4153,18 @@ static int pci_dev_reset_slot_function(struct pci_dev *dev, int probe)
 
 static void pci_dev_lock(struct pci_dev *dev)
 {
-	pci_cfg_access_lock(dev);
 	/* block PM suspend, driver probe, etc. */
 	device_lock(&dev->dev);
+	pci_cfg_access_lock(dev);
 }
 
 /* Return 1 on successful lock, 0 on contention */
 static int pci_dev_trylock(struct pci_dev *dev)
 {
-	if (pci_cfg_access_trylock(dev)) {
-		if (device_trylock(&dev->dev))
+	if (device_trylock(&dev->dev)) {
+		if (pci_cfg_access_trylock(dev))
 			return 1;
-		pci_cfg_access_unlock(dev);
+		device_unlock(&dev->dev);
 	}
 
 	return 0;
@@ -4172,8 +4172,8 @@ static int pci_dev_trylock(struct pci_dev *dev)
 
 static void pci_dev_unlock(struct pci_dev *dev)
 {
-	device_unlock(&dev->dev);
 	pci_cfg_access_unlock(dev);
+	device_unlock(&dev->dev);
 }
 
 static void pci_dev_save_and_disable(struct pci_dev *dev)
diff --git a/drivers/pcmcia/Kconfig b/drivers/pcmcia/Kconfig
index d3c378b4db6c..20d85d564b80 100644
--- a/drivers/pcmcia/Kconfig
+++ b/drivers/pcmcia/Kconfig
@@ -146,7 +146,7 @@ config TCIC
 
 config PCMCIA_ALCHEMY_DEVBOARD
 	tristate "Alchemy Db/Pb1xxx PCMCIA socket services"
-	depends on MIPS_ALCHEMY && PCMCIA
+	depends on MIPS_DB1XXX && PCMCIA
 	help
 	  Enable this driver of you want PCMCIA support on your Alchemy
 	  Db1000, Db/Pb1100, Db/Pb1500, Db/Pb1550, Db/Pb1200, DB1300
diff --git a/drivers/phy/qualcomm/phy-qcom-qmp.c b/drivers/phy/qualcomm/phy-qcom-qmp.c
index 3eeaf57e6d93..6d9454077af7 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp.c
@@ -1086,6 +1086,11 @@ static const struct phy_ops qcom_qmp_phy_gen_ops = {
 	.owner		= THIS_MODULE,
 };
 
+static void qcom_qmp_reset_control_put(void *data)
+{
+	reset_control_put(data);
+}
+
 static
 int qcom_qmp_phy_create(struct device *dev, struct device_node *np, int id)
 {
@@ -1123,7 +1128,7 @@ int qcom_qmp_phy_create(struct device *dev, struct device_node *np, int id)
 	 * all phys that don't need this.
 	 */
 	snprintf(prop_name, sizeof(prop_name), "pipe%d", id);
-	qphy->pipe_clk = of_clk_get_by_name(np, prop_name);
+	qphy->pipe_clk = devm_get_clk_from_child(dev, np, prop_name);
 	if (IS_ERR(qphy->pipe_clk)) {
 		if (qmp->cfg->type == PHY_TYPE_PCIE ||
 		    qmp->cfg->type == PHY_TYPE_USB3) {
@@ -1145,6 +1150,10 @@ int qcom_qmp_phy_create(struct device *dev, struct device_node *np, int id)
 			dev_err(dev, "failed to get lane%d reset\n", id);
 			return PTR_ERR(qphy->lane_rst);
 		}
+		ret = devm_add_action_or_reset(dev, qcom_qmp_reset_control_put,
+					       qphy->lane_rst);
+		if (ret)
+			return ret;
 	}
 
 	generic_phy = devm_phy_create(dev, np, &qcom_qmp_phy_gen_ops);
diff --git a/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c b/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
index 9f7d917458c7..d90aae2a5cfd 100644
--- a/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
+++ b/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
@@ -710,7 +710,7 @@ static int armada_37xx_irqchip_register(struct platform_device *pdev,
 	for (i = 0; i < nr_irq_parent; i++) {
 		int irq = irq_of_parse_and_map(np, i);
 
-		if (irq < 0)
+		if (!irq)
 			continue;
 
 		gpiochip_set_chained_irqchip(gc, irqchip, irq,
diff --git a/drivers/pwm/pwm-lp3943.c b/drivers/pwm/pwm-lp3943.c
index fc446d5c19f9..34151fc4cd51 100644
--- a/drivers/pwm/pwm-lp3943.c
+++ b/drivers/pwm/pwm-lp3943.c
@@ -128,6 +128,7 @@ static int lp3943_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 	if (err)
 		return err;
 
+	duty_ns = min(duty_ns, period_ns);
 	val = (u8)(duty_ns * LP3943_MAX_DUTY / period_ns);
 
 	return lp3943_write_byte(lp3943, reg_duty, val);
diff --git a/drivers/regulator/pfuze100-regulator.c b/drivers/regulator/pfuze100-regulator.c
index 4f205366d8ae..587a6bf9037b 100644
--- a/drivers/regulator/pfuze100-regulator.c
+++ b/drivers/regulator/pfuze100-regulator.c
@@ -431,6 +431,7 @@ static int pfuze_parse_regulators_dt(struct pfuze_chip *chip)
 	parent = of_get_child_by_name(np, "regulators");
 	if (!parent) {
 		dev_err(dev, "regulators node not found\n");
+		of_node_put(np);
 		return -EINVAL;
 	}
 
@@ -455,6 +456,7 @@ static int pfuze_parse_regulators_dt(struct pfuze_chip *chip)
 	}
 
 	of_node_put(parent);
+	of_node_put(np);
 	if (ret < 0) {
 		dev_err(dev, "Error parsing regulator init data: %d\n",
 			ret);
diff --git a/drivers/rpmsg/qcom_smd.c b/drivers/rpmsg/qcom_smd.c
index 72d02bfeda9e..781df7a17b56 100644
--- a/drivers/rpmsg/qcom_smd.c
+++ b/drivers/rpmsg/qcom_smd.c
@@ -1299,7 +1299,7 @@ static int qcom_smd_parse_edge(struct device *dev,
 		edge->name = node->name;
 
 	irq = irq_of_parse_and_map(node, 0);
-	if (irq < 0) {
+	if (!irq) {
 		dev_err(dev, "required smd interrupt missing\n");
 		return -EINVAL;
 	}
diff --git a/drivers/rtc/rtc-mt6397.c b/drivers/rtc/rtc-mt6397.c
index c696d9186451..4fdd96f71e11 100644
--- a/drivers/rtc/rtc-mt6397.c
+++ b/drivers/rtc/rtc-mt6397.c
@@ -339,6 +339,8 @@ static int mtk_rtc_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -EINVAL;
 	rtc->addr_base = res->start;
 
 	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 8490d0ff04ca..f7304ff0e08e 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -3775,10 +3775,19 @@ static struct DeviceCtlBlk *device_alloc(struct AdapterCtlBlk *acb,
 #endif
 	if (dcb->target_lun != 0) {
 		/* Copy settings */
-		struct DeviceCtlBlk *p;
-		list_for_each_entry(p, &acb->dcb_list, list)
-			if (p->target_id == dcb->target_id)
+		struct DeviceCtlBlk *p = NULL, *iter;
+
+		list_for_each_entry(iter, &acb->dcb_list, list)
+			if (iter->target_id == dcb->target_id) {
+				p = iter;
 				break;
+			}
+
+		if (!p) {
+			kfree(dcb);
+			return NULL;
+		}
+
 		dprintkdbg(DBG_1, 
 		       "device_alloc: <%02i-%i> copy from <%02i-%i>\n",
 		       dcb->target_id, dcb->target_lun,
diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index eaab59afd90c..1c8fa41aa3ab 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -1978,7 +1978,7 @@ EXPORT_SYMBOL(fcoe_ctlr_recv_flogi);
  *
  * Returns: u64 fc world wide name
  */
-u64 fcoe_wwn_from_mac(unsigned char mac[MAX_ADDR_LEN],
+u64 fcoe_wwn_from_mac(unsigned char mac[ETH_ALEN],
 		      unsigned int scheme, unsigned int port)
 {
 	u64 wwn;
diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index f5c09bbf9374..eed6d45b8025 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -4707,7 +4707,7 @@ static int __init megaraid_init(void)
 	 * major number allocation.
 	 */
 	major = register_chrdev(0, "megadev_legacy", &megadev_fops);
-	if (!major) {
+	if (major < 0) {
 		printk(KERN_WARNING
 				"megaraid: failed to register char device\n");
 	}
diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 6b6b8bf2ec92..d51f52d6e471 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -915,8 +915,11 @@ static void ufs_qcom_dev_ref_clk_ctrl(struct ufs_qcom_host *host, bool enable)
 
 		writel_relaxed(temp, host->dev_ref_clk_ctrl_mmio);
 
-		/* ensure that ref_clk is enabled/disabled before we return */
-		wmb();
+		/*
+		 * Make sure the write to ref_clk reaches the destination and
+		 * not stored in a Write Buffer (WB).
+		 */
+		readl(host->dev_ref_clk_ctrl_mmio);
 
 		/*
 		 * If we call hibern8 exit after this, we need to make sure that
diff --git a/drivers/soc/qcom/smp2p.c b/drivers/soc/qcom/smp2p.c
index 4c5767c73b7a..a0562dec9604 100644
--- a/drivers/soc/qcom/smp2p.c
+++ b/drivers/soc/qcom/smp2p.c
@@ -416,6 +416,7 @@ static int smp2p_parse_ipc(struct qcom_smp2p *smp2p)
 	}
 
 	smp2p->ipc_regmap = syscon_node_to_regmap(syscon);
+	of_node_put(syscon);
 	if (IS_ERR(smp2p->ipc_regmap))
 		return PTR_ERR(smp2p->ipc_regmap);
 
diff --git a/drivers/soc/qcom/smsm.c b/drivers/soc/qcom/smsm.c
index 2b49d2c212da..5304529b41c9 100644
--- a/drivers/soc/qcom/smsm.c
+++ b/drivers/soc/qcom/smsm.c
@@ -367,6 +367,7 @@ static int smsm_parse_ipc(struct qcom_smsm *smsm, unsigned host_id)
 		return 0;
 
 	host->ipc_regmap = syscon_node_to_regmap(syscon);
+	of_node_put(syscon);
 	if (IS_ERR(host->ipc_regmap))
 		return PTR_ERR(host->ipc_regmap);
 
diff --git a/drivers/soc/rockchip/grf.c b/drivers/soc/rockchip/grf.c
index 0931ddb0b384..39f9a7c1d7e0 100644
--- a/drivers/soc/rockchip/grf.c
+++ b/drivers/soc/rockchip/grf.c
@@ -123,12 +123,14 @@ static int __init rockchip_grf_init(void)
 		return -ENODEV;
 	if (!match || !match->data) {
 		pr_err("%s: missing grf data\n", __func__);
+		of_node_put(np);
 		return -EINVAL;
 	}
 
 	grf_info = match->data;
 
 	grf = syscon_node_to_regmap(np);
+	of_node_put(np);
 	if (IS_ERR(grf)) {
 		pr_err("%s: could not get grf syscon\n", __func__);
 		return PTR_ERR(grf);
diff --git a/drivers/spi/spi-img-spfi.c b/drivers/spi/spi-img-spfi.c
index 2a340234c85c..82ab1bc2196a 100644
--- a/drivers/spi/spi-img-spfi.c
+++ b/drivers/spi/spi-img-spfi.c
@@ -771,7 +771,7 @@ static int img_spfi_resume(struct device *dev)
 	int ret;
 
 	ret = pm_runtime_get_sync(dev);
-	if (ret) {
+	if (ret < 0) {
 		pm_runtime_put_noidle(dev);
 		return ret;
 	}
diff --git a/drivers/spi/spi-ti-qspi.c b/drivers/spi/spi-ti-qspi.c
index d9b02e7668ae..e5db20d11e3f 100644
--- a/drivers/spi/spi-ti-qspi.c
+++ b/drivers/spi/spi-ti-qspi.c
@@ -405,6 +405,7 @@ static int ti_qspi_dma_xfer(struct ti_qspi *qspi, dma_addr_t dma_dst,
 	enum dma_ctrl_flags flags = DMA_CTRL_ACK | DMA_PREP_INTERRUPT;
 	struct dma_async_tx_descriptor *tx;
 	int ret;
+	unsigned long time_left;
 
 	tx = dmaengine_prep_dma_memcpy(chan, dma_dst, dma_src, len, flags);
 	if (!tx) {
@@ -424,9 +425,9 @@ static int ti_qspi_dma_xfer(struct ti_qspi *qspi, dma_addr_t dma_dst,
 	}
 
 	dma_async_issue_pending(chan);
-	ret = wait_for_completion_timeout(&qspi->transfer_complete,
+	time_left = wait_for_completion_timeout(&qspi->transfer_complete,
 					  msecs_to_jiffies(len));
-	if (ret <= 0) {
+	if (time_left == 0) {
 		dmaengine_terminate_sync(chan);
 		dev_err(qspi->dev, "DMA wait_for_completion_timeout\n");
 		return -ETIMEDOUT;
diff --git a/drivers/staging/greybus/audio_codec.c b/drivers/staging/greybus/audio_codec.c
index 6ba5a34fcdf2..2e9ec3fe442b 100644
--- a/drivers/staging/greybus/audio_codec.c
+++ b/drivers/staging/greybus/audio_codec.c
@@ -622,8 +622,8 @@ static int gbcodec_mute_stream(struct snd_soc_dai *dai, int mute, int stream)
 			break;
 	}
 	if (!data) {
-		dev_err(dai->dev, "%s:%s DATA connection missing\n",
-			dai->name, module->name);
+		dev_err(dai->dev, "%s DATA connection missing\n",
+			dai->name);
 		mutex_unlock(&codec->lock);
 		return -ENODEV;
 	}
diff --git a/drivers/staging/rtl8192e/rtllib_softmac.c b/drivers/staging/rtl8192e/rtllib_softmac.c
index e4be85af31e7..1edece694fff 100644
--- a/drivers/staging/rtl8192e/rtllib_softmac.c
+++ b/drivers/staging/rtl8192e/rtllib_softmac.c
@@ -654,9 +654,9 @@ static void rtllib_beacons_stop(struct rtllib_device *ieee)
 	spin_lock_irqsave(&ieee->beacon_lock, flags);
 
 	ieee->beacon_txing = 0;
-	del_timer_sync(&ieee->beacon_timer);
 
 	spin_unlock_irqrestore(&ieee->beacon_lock, flags);
+	del_timer_sync(&ieee->beacon_timer);
 
 }
 
diff --git a/drivers/staging/rtl8712/usb_intf.c b/drivers/staging/rtl8712/usb_intf.c
index 8be4fcc54ad6..b7bd37b62861 100644
--- a/drivers/staging/rtl8712/usb_intf.c
+++ b/drivers/staging/rtl8712/usb_intf.c
@@ -569,13 +569,13 @@ static int r871xu_drv_init(struct usb_interface *pusb_intf,
 		} else {
 			AutoloadFail = false;
 		}
-		if (((mac[0] == 0xff) && (mac[1] == 0xff) &&
+		if ((!AutoloadFail) ||
+		    ((mac[0] == 0xff) && (mac[1] == 0xff) &&
 		     (mac[2] == 0xff) && (mac[3] == 0xff) &&
 		     (mac[4] == 0xff) && (mac[5] == 0xff)) ||
 		    ((mac[0] == 0x00) && (mac[1] == 0x00) &&
 		     (mac[2] == 0x00) && (mac[3] == 0x00) &&
-		     (mac[4] == 0x00) && (mac[5] == 0x00)) ||
-		     (!AutoloadFail)) {
+		     (mac[4] == 0x00) && (mac[5] == 0x00))) {
 			mac[0] = 0x00;
 			mac[1] = 0xe0;
 			mac[2] = 0x4c;
diff --git a/drivers/tty/goldfish.c b/drivers/tty/goldfish.c
index 85a500ddbcaa..1b72321f2d0b 100644
--- a/drivers/tty/goldfish.c
+++ b/drivers/tty/goldfish.c
@@ -414,6 +414,7 @@ static int goldfish_tty_probe(struct platform_device *pdev)
 err_tty_register_device_failed:
 	free_irq(irq, qtty);
 err_dec_line_count:
+	tty_port_destroy(&qtty->port);
 	goldfish_tty_current_line_count--;
 	if (goldfish_tty_current_line_count == 0)
 		goldfish_tty_delete_driver();
@@ -435,6 +436,7 @@ static int goldfish_tty_remove(struct platform_device *pdev)
 	iounmap(qtty->base);
 	qtty->base = NULL;
 	free_irq(qtty->irq, pdev);
+	tty_port_destroy(&qtty->port);
 	goldfish_tty_current_line_count--;
 	if (goldfish_tty_current_line_count == 0)
 		goldfish_tty_delete_driver();
diff --git a/drivers/tty/serial/digicolor-usart.c b/drivers/tty/serial/digicolor-usart.c
index 794864fac625..74127813e6db 100644
--- a/drivers/tty/serial/digicolor-usart.c
+++ b/drivers/tty/serial/digicolor-usart.c
@@ -313,6 +313,8 @@ static void digicolor_uart_set_termios(struct uart_port *port,
 	case CS8:
 	default:
 		config |= UA_CONFIG_CHAR_LEN;
+		termios->c_cflag &= ~CSIZE;
+		termios->c_cflag |= CS8;
 		break;
 	}
 
diff --git a/drivers/tty/serial/icom.c b/drivers/tty/serial/icom.c
index fe92d74f4ea5..4711b3ec2c56 100644
--- a/drivers/tty/serial/icom.c
+++ b/drivers/tty/serial/icom.c
@@ -1515,7 +1515,7 @@ static int icom_probe(struct pci_dev *dev,
 	retval = pci_read_config_dword(dev, PCI_COMMAND, &command_reg);
 	if (retval) {
 		dev_err(&dev->dev, "PCI Config read FAILED\n");
-		return retval;
+		goto probe_exit0;
 	}
 
 	pci_write_config_dword(dev, PCI_COMMAND,
diff --git a/drivers/tty/serial/meson_uart.c b/drivers/tty/serial/meson_uart.c
index 07c0f98be3ac..2bb5ab508321 100644
--- a/drivers/tty/serial/meson_uart.c
+++ b/drivers/tty/serial/meson_uart.c
@@ -253,6 +253,14 @@ static const char *meson_uart_type(struct uart_port *port)
 	return (port->type == PORT_MESON) ? "meson_uart" : NULL;
 }
 
+/*
+ * This function is called only from probe() using a temporary io mapping
+ * in order to perform a reset before setting up the device. Since the
+ * temporarily mapped region was successfully requested, there can be no
+ * console on this port at this time. Hence it is not necessary for this
+ * function to acquire the port->lock. (Since there is no console on this
+ * port at this time, the port->lock is not initialized yet.)
+ */
 static void meson_uart_reset(struct uart_port *port)
 {
 	u32 val;
@@ -267,9 +275,12 @@ static void meson_uart_reset(struct uart_port *port)
 
 static int meson_uart_startup(struct uart_port *port)
 {
+	unsigned long flags;
 	u32 val;
 	int ret = 0;
 
+	spin_lock_irqsave(&port->lock, flags);
+
 	val = readl(port->membase + AML_UART_CONTROL);
 	val |= AML_UART_CLR_ERR;
 	writel(val, port->membase + AML_UART_CONTROL);
@@ -285,6 +296,8 @@ static int meson_uart_startup(struct uart_port *port)
 	val = (AML_UART_RECV_IRQ(1) | AML_UART_XMIT_IRQ(port->fifosize / 2));
 	writel(val, port->membase + AML_UART_MISC);
 
+	spin_unlock_irqrestore(&port->lock, flags);
+
 	ret = request_irq(port->irq, meson_uart_interrupt, 0,
 			  port->name, port);
 
diff --git a/drivers/tty/serial/msm_serial.c b/drivers/tty/serial/msm_serial.c
index 7848e9455950..3df3716caa56 100644
--- a/drivers/tty/serial/msm_serial.c
+++ b/drivers/tty/serial/msm_serial.c
@@ -1587,6 +1587,7 @@ static inline struct uart_port *msm_get_port_from_line(unsigned int line)
 static void __msm_console_write(struct uart_port *port, const char *s,
 				unsigned int count, bool is_uartdm)
 {
+	unsigned long flags;
 	int i;
 	int num_newlines = 0;
 	bool replaced = false;
@@ -1604,6 +1605,8 @@ static void __msm_console_write(struct uart_port *port, const char *s,
 			num_newlines++;
 	count += num_newlines;
 
+	local_irq_save(flags);
+
 	if (port->sysrq)
 		locked = 0;
 	else if (oops_in_progress)
@@ -1649,6 +1652,8 @@ static void __msm_console_write(struct uart_port *port, const char *s,
 
 	if (locked)
 		spin_unlock(&port->lock);
+
+	local_irq_restore(flags);
 }
 
 static void msm_console_write(struct console *co, const char *s,
diff --git a/drivers/tty/serial/sa1100.c b/drivers/tty/serial/sa1100.c
index fd3d1329d48c..68eb1c9faa29 100644
--- a/drivers/tty/serial/sa1100.c
+++ b/drivers/tty/serial/sa1100.c
@@ -452,6 +452,8 @@ sa1100_set_termios(struct uart_port *port, struct ktermios *termios,
 	baud = uart_get_baud_rate(port, termios, old, 0, port->uartclk/16); 
 	quot = uart_get_divisor(port, baud);
 
+	del_timer_sync(&sport->timer);
+
 	spin_lock_irqsave(&sport->port.lock, flags);
 
 	sport->port.read_status_mask &= UTSR0_TO_SM(UTSR0_TFS);
@@ -482,8 +484,6 @@ sa1100_set_termios(struct uart_port *port, struct ktermios *termios,
 				UTSR1_TO_SM(UTSR1_ROR);
 	}
 
-	del_timer_sync(&sport->timer);
-
 	/*
 	 * Update the per-port timeout.
 	 */
diff --git a/drivers/tty/serial/serial_txx9.c b/drivers/tty/serial/serial_txx9.c
index ba77e72057a9..5d41884f5012 100644
--- a/drivers/tty/serial/serial_txx9.c
+++ b/drivers/tty/serial/serial_txx9.c
@@ -652,6 +652,8 @@ serial_txx9_set_termios(struct uart_port *port, struct ktermios *termios,
 	case CS6:	/* not supported */
 	case CS8:
 		cval |= TXX9_SILCR_UMODE_8BIT;
+		termios->c_cflag &= ~CSIZE;
+		termios->c_cflag |= CS8;
 		break;
 	}
 
diff --git a/drivers/tty/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c
index 21f81dc08139..f7dd843a3eff 100644
--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -2267,8 +2267,12 @@ static void sci_set_termios(struct uart_port *port, struct ktermios *termios,
 	unsigned long max_freq = 0;
 	int best_clk = -1;
 
-	if ((termios->c_cflag & CSIZE) == CS7)
+	if ((termios->c_cflag & CSIZE) == CS7) {
 		smr_val |= SCSMR_CHR;
+	} else {
+		termios->c_cflag &= ~CSIZE;
+		termios->c_cflag |= CS8;
+	}
 	if (termios->c_cflag & PARENB)
 		smr_val |= SCSMR_PE;
 	if (termios->c_cflag & PARODD)
diff --git a/drivers/tty/serial/st-asc.c b/drivers/tty/serial/st-asc.c
index b313a792b149..44d52c087c56 100644
--- a/drivers/tty/serial/st-asc.c
+++ b/drivers/tty/serial/st-asc.c
@@ -545,10 +545,14 @@ static void asc_set_termios(struct uart_port *port, struct ktermios *termios,
 	/* set character length */
 	if ((cflag & CSIZE) == CS7) {
 		ctrl_val |= ASC_CTL_MODE_7BIT_PAR;
+		cflag |= PARENB;
 	} else {
 		ctrl_val |= (cflag & PARENB) ?  ASC_CTL_MODE_8BIT_PAR :
 						ASC_CTL_MODE_8BIT;
+		cflag &= ~CSIZE;
+		cflag |= CS8;
 	}
+	termios->c_cflag = cflag;
 
 	/* set stop bit */
 	ctrl_val |= (cflag & CSTOPB) ? ASC_CTL_STOP_2BIT : ASC_CTL_STOP_1BIT;
diff --git a/drivers/tty/synclink_gt.c b/drivers/tty/synclink_gt.c
index 9d68f89a2bf8..4b5ff6e173bd 100644
--- a/drivers/tty/synclink_gt.c
+++ b/drivers/tty/synclink_gt.c
@@ -1822,6 +1822,8 @@ static int hdlcdev_init(struct slgt_info *info)
  */
 static void hdlcdev_exit(struct slgt_info *info)
 {
+	if (!info->netdev)
+		return;
 	unregister_hdlc_device(info->netdev);
 	free_netdev(info->netdev);
 	info->netdev = NULL;
diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index a5b32dd056be..608769f6a564 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -166,7 +166,8 @@ static struct tty_buffer *tty_buffer_alloc(struct tty_port *port, size_t size)
 	   have queued and recycle that ? */
 	if (atomic_read(&port->buf.mem_used) > port->buf.mem_limit)
 		return NULL;
-	p = kmalloc(sizeof(struct tty_buffer) + 2 * size, GFP_ATOMIC);
+	p = kmalloc(sizeof(struct tty_buffer) + 2 * size,
+		    GFP_ATOMIC | __GFP_NOWARN);
 	if (p == NULL)
 		return NULL;
 
diff --git a/drivers/usb/core/hcd-pci.c b/drivers/usb/core/hcd-pci.c
index 5340d433cdf0..18b3a5e518cd 100644
--- a/drivers/usb/core/hcd-pci.c
+++ b/drivers/usb/core/hcd-pci.c
@@ -632,10 +632,10 @@ const struct dev_pm_ops usb_hcd_pci_pm_ops = {
 	.suspend_noirq	= hcd_pci_suspend_noirq,
 	.resume_noirq	= hcd_pci_resume_noirq,
 	.resume		= hcd_pci_resume,
-	.freeze		= check_root_hub_suspended,
+	.freeze		= hcd_pci_suspend,
 	.freeze_noirq	= check_root_hub_suspended,
 	.thaw_noirq	= NULL,
-	.thaw		= NULL,
+	.thaw		= hcd_pci_resume,
 	.poweroff	= hcd_pci_suspend,
 	.poweroff_noirq	= hcd_pci_suspend_noirq,
 	.restore_noirq	= hcd_pci_resume_noirq,
diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index bba74e9b7da0..1f26f0ab155f 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -328,6 +328,9 @@ static const struct usb_device_id usb_quirk_list[] = {
 	/* DJI CineSSD */
 	{ USB_DEVICE(0x2ca3, 0x0031), .driver_info = USB_QUIRK_NO_LPM },
 
+	/* DELL USB GEN2 */
+	{ USB_DEVICE(0x413c, 0xb062), .driver_info = USB_QUIRK_NO_LPM | USB_QUIRK_RESET_RESUME },
+
 	/* VCOM device */
 	{ USB_DEVICE(0x4296, 0x7570), .driver_info = USB_QUIRK_CONFIG_INTF_STRINGS },
 
diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index dddc5d02b552..14f907cf71a3 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -4302,7 +4302,6 @@ static int dwc2_hsotg_udc_start(struct usb_gadget *gadget,
 
 	WARN_ON(hsotg->driver);
 
-	driver->driver.bus = NULL;
 	hsotg->driver = driver;
 	hsotg->gadget.dev.of_node = hsotg->dev->of_node;
 	hsotg->gadget.speed = USB_SPEED_UNKNOWN;
diff --git a/drivers/usb/host/isp116x-hcd.c b/drivers/usb/host/isp116x-hcd.c
index 73fec38754f9..83eb62001679 100644
--- a/drivers/usb/host/isp116x-hcd.c
+++ b/drivers/usb/host/isp116x-hcd.c
@@ -1551,10 +1551,12 @@ static int isp116x_remove(struct platform_device *pdev)
 
 	iounmap(isp116x->data_reg);
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-	release_mem_region(res->start, 2);
+	if (res)
+		release_mem_region(res->start, 2);
 	iounmap(isp116x->addr_reg);
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(res->start, 2);
+	if (res)
+		release_mem_region(res->start, 2);
 
 	usb_put_hcd(hcd);
 	return 0;
diff --git a/drivers/usb/host/oxu210hp-hcd.c b/drivers/usb/host/oxu210hp-hcd.c
index 1d3a79c2eba2..c986dcb7a87c 100644
--- a/drivers/usb/host/oxu210hp-hcd.c
+++ b/drivers/usb/host/oxu210hp-hcd.c
@@ -3489,8 +3489,10 @@ static int oxu_bus_suspend(struct usb_hcd *hcd)
 		}
 	}
 
+	spin_unlock_irq(&oxu->lock);
 	/* turn off now-idle HC */
 	del_timer_sync(&oxu->watchdog);
+	spin_lock_irq(&oxu->lock);
 	ehci_halt(oxu);
 	hcd->state = HC_STATE_SUSPENDED;
 
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index a58335adab8a..6facdd77c138 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1140,6 +1140,8 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EM12, 0xff, 0, 0) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, 0x0620, 0xff, 0xff, 0x30) },	/* EM160R-GL */
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, 0x0620, 0xff, 0, 0) },
+	{ USB_DEVICE_INTERFACE_CLASS(QUECTEL_VENDOR_ID, 0x0700, 0xff), /* BG95 */
+	  .driver_info = RSVD(3) | ZLP },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_RM500Q, 0xff, 0xff, 0x30) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_RM500Q, 0xff, 0, 0) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_RM500Q, 0xff, 0xff, 0x10),
diff --git a/drivers/usb/storage/karma.c b/drivers/usb/storage/karma.c
index b05ba4929f00..89a273e9439f 100644
--- a/drivers/usb/storage/karma.c
+++ b/drivers/usb/storage/karma.c
@@ -185,23 +185,24 @@ static void rio_karma_destructor(void *extra)
 
 static int rio_karma_init(struct us_data *us)
 {
-	int ret = 0;
 	struct karma_data *data = kzalloc(sizeof(struct karma_data), GFP_NOIO);
 	if (!data)
-		goto out;
+		return -ENOMEM;
 
 	data->recv = kmalloc(RIO_RECV_LEN, GFP_NOIO);
 	if (!data->recv) {
 		kfree(data);
-		goto out;
+		return -ENOMEM;
 	}
 
 	us->extra = data;
 	us->extra_destructor = rio_karma_destructor;
-	ret = rio_karma_send_command(RIO_ENTER_STORAGE, us);
-	data->in_storage = (ret == 0);
-out:
-	return ret;
+	if (rio_karma_send_command(RIO_ENTER_STORAGE, us))
+		return -EIO;
+
+	data->in_storage = 1;
+
+	return 0;
 }
 
 static struct scsi_host_template karma_host_template;
diff --git a/drivers/usb/usbip/stub_dev.c b/drivers/usb/usbip/stub_dev.c
index 1b3aad59d6c9..16bb3197d658 100644
--- a/drivers/usb/usbip/stub_dev.c
+++ b/drivers/usb/usbip/stub_dev.c
@@ -441,7 +441,6 @@ static int stub_probe(struct usb_device *udev)
 			     (struct usb_dev_state *) udev);
 err_port:
 	dev_set_drvdata(&udev->dev, NULL);
-	usb_put_dev(udev);
 
 	/* we already have busid_priv, just lock busid_lock */
 	spin_lock(&busid_priv->busid_lock);
@@ -456,6 +455,7 @@ static int stub_probe(struct usb_device *udev)
 	put_busid_priv(busid_priv);
 
 sdev_free:
+	usb_put_dev(udev);
 	stub_device_free(sdev);
 
 	return rc;
diff --git a/drivers/usb/usbip/stub_rx.c b/drivers/usb/usbip/stub_rx.c
index cb24b22252e4..bf4a6dca95c6 100644
--- a/drivers/usb/usbip/stub_rx.c
+++ b/drivers/usb/usbip/stub_rx.c
@@ -152,7 +152,9 @@ static int tweak_set_configuration_cmd(struct urb *urb)
 	req = (struct usb_ctrlrequest *) urb->setup_packet;
 	config = le16_to_cpu(req->wValue);
 
+	usb_lock_device(sdev->udev);
 	err = usb_set_configuration(sdev->udev, config);
+	usb_unlock_device(sdev->udev);
 	if (err && err != -ENODEV)
 		dev_err(&sdev->udev->dev, "can't set config #%d, error %d\n",
 			config, err);
diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index c23045aa9873..a764d36c4d38 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -263,7 +263,7 @@ __vringh_iov(struct vringh *vrh, u16 i,
 	     gfp_t gfp,
 	     int (*copy)(void *dst, const void *src, size_t len))
 {
-	int err, count = 0, up_next, desc_max;
+	int err, count = 0, indirect_count = 0, up_next, desc_max;
 	struct vring_desc desc, *descs;
 	struct vringh_range range = { -1ULL, 0 }, slowrange;
 	bool slow = false;
@@ -320,7 +320,12 @@ __vringh_iov(struct vringh *vrh, u16 i,
 			continue;
 		}
 
-		if (count++ == vrh->vring.num) {
+		if (up_next == -1)
+			count++;
+		else
+			indirect_count++;
+
+		if (count > vrh->vring.num || indirect_count > desc_max) {
 			vringh_bad("Descriptor loop in %p", descs);
 			err = -ELOOP;
 			goto fail;
@@ -382,6 +387,7 @@ __vringh_iov(struct vringh *vrh, u16 i,
 				i = return_from_indirect(vrh, &up_next,
 							 &descs, &desc_max);
 				slow = false;
+				indirect_count = 0;
 			} else
 				break;
 		}
diff --git a/drivers/video/fbdev/amba-clcd.c b/drivers/video/fbdev/amba-clcd.c
index 36d25190b48c..66c7d766e330 100644
--- a/drivers/video/fbdev/amba-clcd.c
+++ b/drivers/video/fbdev/amba-clcd.c
@@ -838,12 +838,15 @@ static int clcdfb_of_vram_setup(struct clcd_fb *fb)
 		return -ENODEV;
 
 	fb->fb.screen_base = of_iomap(memory, 0);
-	if (!fb->fb.screen_base)
+	if (!fb->fb.screen_base) {
+		of_node_put(memory);
 		return -ENOMEM;
+	}
 
 	fb->fb.fix.smem_start = of_translate_address(memory,
 			of_get_address(memory, 0, &size, NULL));
 	fb->fb.fix.smem_len = size;
+	of_node_put(memory);
 
 	return 0;
 }
diff --git a/drivers/video/fbdev/pxa3xx-gcu.c b/drivers/video/fbdev/pxa3xx-gcu.c
index 933619da1a94..4febbe21b9b5 100644
--- a/drivers/video/fbdev/pxa3xx-gcu.c
+++ b/drivers/video/fbdev/pxa3xx-gcu.c
@@ -662,6 +662,7 @@ static int pxa3xx_gcu_probe(struct platform_device *pdev)
 	for (i = 0; i < 8; i++) {
 		ret = pxa3xx_gcu_add_buffer(dev, priv);
 		if (ret) {
+			pxa3xx_gcu_free_buffers(dev, priv);
 			dev_err(dev, "failed to allocate DMA memory\n");
 			goto err_disable_clk;
 		}
@@ -677,15 +678,15 @@ static int pxa3xx_gcu_probe(struct platform_device *pdev)
 			SHARED_SIZE, irq);
 	return 0;
 
-err_free_dma:
-	dma_free_coherent(dev, SHARED_SIZE,
-			priv->shared, priv->shared_phys);
+err_disable_clk:
+	clk_disable_unprepare(priv->clk);
 
 err_misc_deregister:
 	misc_deregister(&priv->misc_dev);
 
-err_disable_clk:
-	clk_disable_unprepare(priv->clk);
+err_free_dma:
+	dma_free_coherent(dev, SHARED_SIZE,
+			  priv->shared, priv->shared_phys);
 
 	return ret;
 }
@@ -698,6 +699,7 @@ static int pxa3xx_gcu_remove(struct platform_device *pdev)
 	pxa3xx_gcu_wait_idle(priv);
 	misc_deregister(&priv->misc_dev);
 	dma_free_coherent(dev, SHARED_SIZE, priv->shared, priv->shared_phys);
+	clk_disable_unprepare(priv->clk);
 	pxa3xx_gcu_free_buffers(dev, priv);
 
 	return 0;
diff --git a/fs/binfmt_flat.c b/fs/binfmt_flat.c
index 78b5bac82559..7ce2db0020f3 100644
--- a/fs/binfmt_flat.c
+++ b/fs/binfmt_flat.c
@@ -408,6 +408,30 @@ static void old_reloc(unsigned long rl)
 
 /****************************************************************************/
 
+static inline u32 __user *skip_got_header(u32 __user *rp)
+{
+	if (IS_ENABLED(CONFIG_RISCV)) {
+		/*
+		 * RISC-V has a 16 byte GOT PLT header for elf64-riscv
+		 * and 8 byte GOT PLT header for elf32-riscv.
+		 * Skip the whole GOT PLT header, since it is reserved
+		 * for the dynamic linker (ld.so).
+		 */
+		u32 rp_val0, rp_val1;
+
+		if (get_user(rp_val0, rp))
+			return rp;
+		if (get_user(rp_val1, rp + 1))
+			return rp;
+
+		if (rp_val0 == 0xffffffff && rp_val1 == 0xffffffff)
+			rp += 4;
+		else if (rp_val0 == 0xffffffff)
+			rp += 2;
+	}
+	return rp;
+}
+
 static int load_flat_file(struct linux_binprm *bprm,
 		struct lib_info *libinfo, int id, unsigned long *extra_stack)
 {
@@ -745,7 +769,8 @@ static int load_flat_file(struct linux_binprm *bprm,
 	 * image.
 	 */
 	if (flags & FLAT_FLAG_GOTPIC) {
-		for (rp = (u32 __user *)datapos; ; rp++) {
+		rp = skip_got_header((u32 __user *) datapos);
+		for (; ; rp++) {
 			u32 addr, rp_val;
 			if (get_user(rp_val, rp))
 				return -EFAULT;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 41ebc613ca4c..589722f35934 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2653,7 +2653,7 @@ int open_ctree(struct super_block *sb,
 		~BTRFS_FEATURE_INCOMPAT_SUPP;
 	if (features) {
 		btrfs_err(fs_info,
-		    "cannot mount because of unsupported optional features (%llx)",
+		    "cannot mount because of unsupported optional features (0x%llx)",
 		    features);
 		err = -EINVAL;
 		goto fail_alloc;
@@ -2713,7 +2713,7 @@ int open_ctree(struct super_block *sb,
 		~BTRFS_FEATURE_COMPAT_RO_SUPP;
 	if (!sb_rdonly(sb) && features) {
 		btrfs_err(fs_info,
-	"cannot mount read-write because of unsupported optional features (%llx)",
+	"cannot mount read-write because of unsupported optional features (0x%llx)",
 		       features);
 		err = -EINVAL;
 		goto fail_alloc;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 3b3c65b7d0c1..8df4aedb3138 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6975,12 +6975,12 @@ int btrfs_read_chunk_tree(struct btrfs_fs_info *fs_info)
 	 * do another round of validation checks.
 	 */
 	if (total_dev != fs_info->fs_devices->total_devices) {
-		btrfs_err(fs_info,
-	   "super_num_devices %llu mismatch with num_devices %llu found here",
+		btrfs_warn(fs_info,
+"super block num_devices %llu mismatch with DEV_ITEM count %llu, will be repaired on next transaction commit",
 			  btrfs_super_num_devices(fs_info->super_copy),
 			  total_dev);
-		ret = -EINVAL;
-		goto error;
+		fs_info->fs_devices->total_devices = total_dev;
+		btrfs_set_super_num_devices(fs_info->super_copy, total_dev);
 	}
 	if (btrfs_super_total_bytes(fs_info->super_copy) <
 	    fs_info->fs_devices->total_rw_bytes) {
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 77a9aeaf2cb1..fcd4fbe9281f 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -263,6 +263,9 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon)
 			rc = -EHOSTDOWN;
 			mutex_unlock(&tcon->ses->session_mutex);
 			goto failed;
+		} else if (rc) {
+			mutex_unlock(&ses->session_mutex);
+			goto out;
 		}
 	}
 	if (rc || !tcon->need_reconnect) {
diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 8364f170fbb8..73e1eeee4743 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -1554,6 +1554,7 @@ static int _remove_from_waiters(struct dlm_lkb *lkb, int mstype,
 		lkb->lkb_wait_type = 0;
 		lkb->lkb_flags &= ~DLM_IFL_OVERLAP_CANCEL;
 		lkb->lkb_wait_count--;
+		unhold_lkb(lkb);
 		goto out_del;
 	}
 
@@ -1580,6 +1581,7 @@ static int _remove_from_waiters(struct dlm_lkb *lkb, int mstype,
 		log_error(ls, "remwait error %x reply %d wait_type %d overlap",
 			  lkb->lkb_id, mstype, lkb->lkb_wait_type);
 		lkb->lkb_wait_count--;
+		unhold_lkb(lkb);
 		lkb->lkb_wait_type = 0;
 	}
 
@@ -5311,11 +5313,16 @@ int dlm_recover_waiters_post(struct dlm_ls *ls)
 		lkb->lkb_flags &= ~DLM_IFL_OVERLAP_UNLOCK;
 		lkb->lkb_flags &= ~DLM_IFL_OVERLAP_CANCEL;
 		lkb->lkb_wait_type = 0;
-		lkb->lkb_wait_count = 0;
+		/* drop all wait_count references we still
+		 * hold a reference for this iteration.
+		 */
+		while (lkb->lkb_wait_count) {
+			lkb->lkb_wait_count--;
+			unhold_lkb(lkb);
+		}
 		mutex_lock(&ls->ls_waiters_mutex);
 		list_del_init(&lkb->lkb_wait_reply);
 		mutex_unlock(&ls->ls_waiters_mutex);
-		unhold_lkb(lkb); /* for waiters list */
 
 		if (oc || ou) {
 			/* do an unlock or cancel instead of resending */
diff --git a/fs/dlm/plock.c b/fs/dlm/plock.c
index e631b1689228..b53ca4df7e77 100644
--- a/fs/dlm/plock.c
+++ b/fs/dlm/plock.c
@@ -26,11 +26,11 @@ struct plock_op {
 	struct list_head list;
 	int done;
 	struct dlm_plock_info info;
+	int (*callback)(struct file_lock *fl, int result);
 };
 
 struct plock_xop {
 	struct plock_op xop;
-	int (*callback)(struct file_lock *fl, int result);
 	void *fl;
 	void *file;
 	struct file_lock flc;
@@ -132,19 +132,18 @@ int dlm_posix_lock(dlm_lockspace_t *lockspace, u64 number, struct file *file,
 		/* fl_owner is lockd which doesn't distinguish
 		   processes on the nfs client */
 		op->info.owner	= (__u64) fl->fl_pid;
-		xop->callback	= fl->fl_lmops->lm_grant;
+		op->callback	= fl->fl_lmops->lm_grant;
 		locks_init_lock(&xop->flc);
 		locks_copy_lock(&xop->flc, fl);
 		xop->fl		= fl;
 		xop->file	= file;
 	} else {
 		op->info.owner	= (__u64)(long) fl->fl_owner;
-		xop->callback	= NULL;
 	}
 
 	send_op(op);
 
-	if (xop->callback == NULL) {
+	if (!op->callback) {
 		rv = wait_event_interruptible(recv_wq, (op->done != 0));
 		if (rv == -ERESTARTSYS) {
 			log_debug(ls, "dlm_posix_lock: wait killed %llx",
@@ -206,7 +205,7 @@ static int dlm_plock_callback(struct plock_op *op)
 	file = xop->file;
 	flc = &xop->flc;
 	fl = xop->fl;
-	notify = xop->callback;
+	notify = op->callback;
 
 	if (op->info.rv) {
 		notify(fl, op->info.rv);
@@ -439,10 +438,9 @@ static ssize_t dev_write(struct file *file, const char __user *u, size_t count,
 		if (op->info.fsid == info.fsid &&
 		    op->info.number == info.number &&
 		    op->info.owner == info.owner) {
-			struct plock_xop *xop = (struct plock_xop *)op;
 			list_del_init(&op->list);
 			memcpy(&op->info, &info, sizeof(info));
-			if (xop->callback)
+			if (op->callback)
 				do_callback = 1;
 			else
 				op->done = 1;
diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 58d8fd654302..5fb57a0e6f81 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1995,6 +1995,18 @@ int ext4_convert_inline_data(struct inode *inode)
 	if (!ext4_has_inline_data(inode)) {
 		ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
 		return 0;
+	} else if (!ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)) {
+		/*
+		 * Inode has inline data but EXT4_STATE_MAY_INLINE_DATA is
+		 * cleared. This means we are in the middle of moving of
+		 * inline data to delay allocated block. Just force writeout
+		 * here to finish conversion.
+		 */
+		error = filemap_flush(inode->i_mapping);
+		if (error)
+			return error;
+		if (!ext4_has_inline_data(inode))
+			return 0;
 	}
 
 	needed_blocks = ext4_writepage_trans_blocks(inode);
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 9a138a6dc17e..eb4de706cc9c 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -271,9 +271,9 @@ static struct dx_frame *dx_probe(struct ext4_filename *fname,
 				 struct dx_hash_info *hinfo,
 				 struct dx_frame *frame);
 static void dx_release(struct dx_frame *frames);
-static int dx_make_map(struct inode *dir, struct ext4_dir_entry_2 *de,
-		       unsigned blocksize, struct dx_hash_info *hinfo,
-		       struct dx_map_entry map[]);
+static int dx_make_map(struct inode *dir, struct buffer_head *bh,
+		       struct dx_hash_info *hinfo,
+		       struct dx_map_entry *map_tail);
 static void dx_sort_map(struct dx_map_entry *map, unsigned count);
 static struct ext4_dir_entry_2 *dx_move_dirents(char *from, char *to,
 		struct dx_map_entry *offsets, int count, unsigned blocksize);
@@ -747,12 +747,14 @@ static struct dx_frame *
 dx_probe(struct ext4_filename *fname, struct inode *dir,
 	 struct dx_hash_info *hinfo, struct dx_frame *frame_in)
 {
-	unsigned count, indirect;
+	unsigned count, indirect, level, i;
 	struct dx_entry *at, *entries, *p, *q, *m;
 	struct dx_root *root;
 	struct dx_frame *frame = frame_in;
 	struct dx_frame *ret_err = ERR_PTR(ERR_BAD_DX_DIR);
 	u32 hash;
+	ext4_lblk_t block;
+	ext4_lblk_t blocks[EXT4_HTREE_LEVEL];
 
 	memset(frame_in, 0, EXT4_HTREE_LEVEL * sizeof(frame_in[0]));
 	frame->bh = ext4_read_dirblock(dir, 0, INDEX);
@@ -808,6 +810,8 @@ dx_probe(struct ext4_filename *fname, struct inode *dir,
 	}
 
 	dxtrace(printk("Look up %x", hash));
+	level = 0;
+	blocks[0] = 0;
 	while (1) {
 		count = dx_get_count(entries);
 		if (!count || count > dx_get_limit(entries)) {
@@ -849,15 +853,27 @@ dx_probe(struct ext4_filename *fname, struct inode *dir,
 			       dx_get_block(at)));
 		frame->entries = entries;
 		frame->at = at;
-		if (!indirect--)
+
+		block = dx_get_block(at);
+		for (i = 0; i <= level; i++) {
+			if (blocks[i] == block) {
+				ext4_warning_inode(dir,
+					"dx entry: tree cycle block %u points back to block %u",
+					blocks[level], block);
+				goto fail;
+			}
+		}
+		if (++level > indirect)
 			return frame;
+		blocks[level] = block;
 		frame++;
-		frame->bh = ext4_read_dirblock(dir, dx_get_block(at), INDEX);
+		frame->bh = ext4_read_dirblock(dir, block, INDEX);
 		if (IS_ERR(frame->bh)) {
 			ret_err = (struct dx_frame *) frame->bh;
 			frame->bh = NULL;
 			goto fail;
 		}
+
 		entries = ((struct dx_node *) frame->bh->b_data)->entries;
 
 		if (dx_get_limit(entries) != dx_node_limit(dir)) {
@@ -1202,15 +1218,23 @@ static inline int search_dirblock(struct buffer_head *bh,
  * Create map of hash values, offsets, and sizes, stored at end of block.
  * Returns number of entries mapped.
  */
-static int dx_make_map(struct inode *dir, struct ext4_dir_entry_2 *de,
-		       unsigned blocksize, struct dx_hash_info *hinfo,
+static int dx_make_map(struct inode *dir, struct buffer_head *bh,
+		       struct dx_hash_info *hinfo,
 		       struct dx_map_entry *map_tail)
 {
 	int count = 0;
-	char *base = (char *) de;
+	struct ext4_dir_entry_2 *de = (struct ext4_dir_entry_2 *)bh->b_data;
+	unsigned int buflen = bh->b_size;
+	char *base = bh->b_data;
 	struct dx_hash_info h = *hinfo;
 
-	while ((char *) de < base + blocksize) {
+	if (ext4_has_metadata_csum(dir->i_sb))
+		buflen -= sizeof(struct ext4_dir_entry_tail);
+
+	while ((char *) de < base + buflen) {
+		if (ext4_check_dir_entry(dir, NULL, de, bh, base, buflen,
+					 ((char *)de) - base))
+			return -EFSCORRUPTED;
 		if (de->name_len && de->inode) {
 			ext4fs_dirhash(de->name, de->name_len, &h);
 			map_tail--;
@@ -1220,8 +1244,7 @@ static int dx_make_map(struct inode *dir, struct ext4_dir_entry_2 *de,
 			count++;
 			cond_resched();
 		}
-		/* XXX: do we need to check rec_len == 0 case? -Chris */
-		de = ext4_next_entry(de, blocksize);
+		de = ext4_next_entry(de, dir->i_sb->s_blocksize);
 	}
 	return count;
 }
@@ -1737,8 +1760,11 @@ static struct ext4_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
 
 	/* create map in the end of data2 block */
 	map = (struct dx_map_entry *) (data2 + blocksize);
-	count = dx_make_map(dir, (struct ext4_dir_entry_2 *) data1,
-			     blocksize, hinfo, map);
+	count = dx_make_map(dir, *bh, hinfo, map);
+	if (count < 0) {
+		err = count;
+		goto journal_error;
+	}
 	map -= count;
 	dx_sort_map(map, count);
 	/* Ensure that neither split block is over half full */
@@ -3338,6 +3364,9 @@ static struct buffer_head *ext4_get_first_dir_block(handle_t *handle,
 	struct buffer_head *bh;
 
 	if (!ext4_has_inline_data(inode)) {
+		struct ext4_dir_entry_2 *de;
+		unsigned int offset;
+
 		/* The first directory block must not be a hole, so
 		 * treat it as DIRENT_HTREE
 		 */
@@ -3346,9 +3375,30 @@ static struct buffer_head *ext4_get_first_dir_block(handle_t *handle,
 			*retval = PTR_ERR(bh);
 			return NULL;
 		}
-		*parent_de = ext4_next_entry(
-					(struct ext4_dir_entry_2 *)bh->b_data,
-					inode->i_sb->s_blocksize);
+
+		de = (struct ext4_dir_entry_2 *) bh->b_data;
+		if (ext4_check_dir_entry(inode, NULL, de, bh, bh->b_data,
+					 bh->b_size, 0) ||
+		    le32_to_cpu(de->inode) != inode->i_ino ||
+		    strcmp(".", de->name)) {
+			EXT4_ERROR_INODE(inode, "directory missing '.'");
+			brelse(bh);
+			*retval = -EFSCORRUPTED;
+			return NULL;
+		}
+		offset = ext4_rec_len_from_disk(de->rec_len,
+						inode->i_sb->s_blocksize);
+		de = ext4_next_entry(de, inode->i_sb->s_blocksize);
+		if (ext4_check_dir_entry(inode, NULL, de, bh, bh->b_data,
+					 bh->b_size, offset) ||
+		    le32_to_cpu(de->inode) == 0 || strcmp("..", de->name)) {
+			EXT4_ERROR_INODE(inode, "directory missing '..'");
+			brelse(bh);
+			*retval = -EFSCORRUPTED;
+			return NULL;
+		}
+		*parent_de = de;
+
 		return bh;
 	}
 
diff --git a/fs/fat/fatent.c b/fs/fat/fatent.c
index 24ed1f4e48ae..3ef3e773da1b 100644
--- a/fs/fat/fatent.c
+++ b/fs/fat/fatent.c
@@ -92,7 +92,8 @@ static int fat12_ent_bread(struct super_block *sb, struct fat_entry *fatent,
 err_brelse:
 	brelse(bhs[0]);
 err:
-	fat_msg(sb, KERN_ERR, "FAT read failed (blocknr %llu)", (llu)blocknr);
+	fat_msg_ratelimit(sb, KERN_ERR, "FAT read failed (blocknr %llu)",
+			  (llu)blocknr);
 	return -EIO;
 }
 
@@ -105,8 +106,8 @@ static int fat_ent_bread(struct super_block *sb, struct fat_entry *fatent,
 	fatent->fat_inode = MSDOS_SB(sb)->fat_inode;
 	fatent->bhs[0] = sb_bread(sb, blocknr);
 	if (!fatent->bhs[0]) {
-		fat_msg(sb, KERN_ERR, "FAT read failed (blocknr %llu)",
-		       (llu)blocknr);
+		fat_msg_ratelimit(sb, KERN_ERR, "FAT read failed (blocknr %llu)",
+				  (llu)blocknr);
 		return -EIO;
 	}
 	fatent->nr_bhs = 1;
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 1e583e24dd5d..be6096f195c5 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1565,11 +1565,12 @@ static long writeback_sb_inodes(struct super_block *sb,
 	};
 	unsigned long start_time = jiffies;
 	long write_chunk;
-	long wrote = 0;  /* count both pages and inodes */
+	long total_wrote = 0;  /* count both pages and inodes */
 
 	while (!list_empty(&wb->b_io)) {
 		struct inode *inode = wb_inode(wb->b_io.prev);
 		struct bdi_writeback *tmp_wb;
+		long wrote;
 
 		if (inode->i_sb != sb) {
 			if (work->sb) {
@@ -1645,7 +1646,9 @@ static long writeback_sb_inodes(struct super_block *sb,
 
 		wbc_detach_inode(&wbc);
 		work->nr_pages -= write_chunk - wbc.nr_to_write;
-		wrote += write_chunk - wbc.nr_to_write;
+		wrote = write_chunk - wbc.nr_to_write - wbc.pages_skipped;
+		wrote = wrote < 0 ? 0 : wrote;
+		total_wrote += wrote;
 
 		if (need_resched()) {
 			/*
@@ -1667,7 +1670,7 @@ static long writeback_sb_inodes(struct super_block *sb,
 		tmp_wb = inode_to_wb_and_lock_list(inode);
 		spin_lock(&inode->i_lock);
 		if (!(inode->i_state & I_DIRTY_ALL))
-			wrote++;
+			total_wrote++;
 		requeue_inode(inode, tmp_wb, &wbc);
 		inode_sync_complete(inode);
 		spin_unlock(&inode->i_lock);
@@ -1681,14 +1684,14 @@ static long writeback_sb_inodes(struct super_block *sb,
 		 * bail out to wb_writeback() often enough to check
 		 * background threshold and other termination conditions.
 		 */
-		if (wrote) {
+		if (total_wrote) {
 			if (time_is_before_jiffies(start_time + HZ / 10UL))
 				break;
 			if (work->nr_pages <= 0)
 				break;
 		}
 	}
-	return wrote;
+	return total_wrote;
 }
 
 static long __writeback_inodes_wb(struct bdi_writeback *wb,
diff --git a/fs/jffs2/fs.c b/fs/jffs2/fs.c
index b7df9e34ccfd..dd7c6fbd2cc5 100644
--- a/fs/jffs2/fs.c
+++ b/fs/jffs2/fs.c
@@ -598,6 +598,7 @@ int jffs2_do_fill_super(struct super_block *sb, void *data, int silent)
 	jffs2_free_raw_node_refs(c);
 	kvfree(c->blocks);
 	jffs2_clear_xattr_subsystem(c);
+	jffs2_sum_exit(c);
  out_inohash:
 	kfree(c->inocache_list);
  out_wbuf:
diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
index 6dac48e29d28..a07fbb60ac3c 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -398,7 +398,8 @@ int dbFree(struct inode *ip, s64 blkno, s64 nblocks)
 	}
 
 	/* write the last buffer. */
-	write_metapage(mp);
+	if (mp)
+		write_metapage(mp);
 
 	IREAD_UNLOCK(ipbmap);
 
diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 8697b750b1c9..fa2dee322ee9 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -20,7 +20,15 @@
 
 DEFINE_MUTEX(kernfs_mutex);
 static DEFINE_SPINLOCK(kernfs_rename_lock);	/* kn->parent and ->name */
-static char kernfs_pr_cont_buf[PATH_MAX];	/* protected by rename_lock */
+/*
+ * Don't use rename_lock to piggy back on pr_cont_buf. We don't want to
+ * call pr_cont() while holding rename_lock. Because sometimes pr_cont()
+ * will perform wakeups when releasing console_sem. Holding rename_lock
+ * will introduce deadlock if the scheduler reads the kernfs_name in the
+ * wakeup path.
+ */
+static DEFINE_SPINLOCK(kernfs_pr_cont_lock);
+static char kernfs_pr_cont_buf[PATH_MAX];	/* protected by pr_cont_lock */
 static DEFINE_SPINLOCK(kernfs_idr_lock);	/* root->ino_idr */
 
 #define rb_to_kn(X) rb_entry((X), struct kernfs_node, rb)
@@ -229,12 +237,12 @@ void pr_cont_kernfs_name(struct kernfs_node *kn)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&kernfs_rename_lock, flags);
+	spin_lock_irqsave(&kernfs_pr_cont_lock, flags);
 
-	kernfs_name_locked(kn, kernfs_pr_cont_buf, sizeof(kernfs_pr_cont_buf));
+	kernfs_name(kn, kernfs_pr_cont_buf, sizeof(kernfs_pr_cont_buf));
 	pr_cont("%s", kernfs_pr_cont_buf);
 
-	spin_unlock_irqrestore(&kernfs_rename_lock, flags);
+	spin_unlock_irqrestore(&kernfs_pr_cont_lock, flags);
 }
 
 /**
@@ -248,10 +256,10 @@ void pr_cont_kernfs_path(struct kernfs_node *kn)
 	unsigned long flags;
 	int sz;
 
-	spin_lock_irqsave(&kernfs_rename_lock, flags);
+	spin_lock_irqsave(&kernfs_pr_cont_lock, flags);
 
-	sz = kernfs_path_from_node_locked(kn, NULL, kernfs_pr_cont_buf,
-					  sizeof(kernfs_pr_cont_buf));
+	sz = kernfs_path_from_node(kn, NULL, kernfs_pr_cont_buf,
+				   sizeof(kernfs_pr_cont_buf));
 	if (sz < 0) {
 		pr_cont("(error)");
 		goto out;
@@ -265,7 +273,7 @@ void pr_cont_kernfs_path(struct kernfs_node *kn)
 	pr_cont("%s", kernfs_pr_cont_buf);
 
 out:
-	spin_unlock_irqrestore(&kernfs_rename_lock, flags);
+	spin_unlock_irqrestore(&kernfs_pr_cont_lock, flags);
 }
 
 /**
@@ -850,13 +858,12 @@ static struct kernfs_node *kernfs_walk_ns(struct kernfs_node *parent,
 
 	lockdep_assert_held(&kernfs_mutex);
 
-	/* grab kernfs_rename_lock to piggy back on kernfs_pr_cont_buf */
-	spin_lock_irq(&kernfs_rename_lock);
+	spin_lock_irq(&kernfs_pr_cont_lock);
 
 	len = strlcpy(kernfs_pr_cont_buf, path, sizeof(kernfs_pr_cont_buf));
 
 	if (len >= sizeof(kernfs_pr_cont_buf)) {
-		spin_unlock_irq(&kernfs_rename_lock);
+		spin_unlock_irq(&kernfs_pr_cont_lock);
 		return NULL;
 	}
 
@@ -868,7 +875,7 @@ static struct kernfs_node *kernfs_walk_ns(struct kernfs_node *parent,
 		parent = kernfs_find_ns(parent, name, ns);
 	}
 
-	spin_unlock_irq(&kernfs_rename_lock);
+	spin_unlock_irq(&kernfs_pr_cont_lock);
 
 	return parent;
 }
diff --git a/fs/notify/fdinfo.c b/fs/notify/fdinfo.c
index 517f88c1dbe5..c62a87ee3b00 100644
--- a/fs/notify/fdinfo.c
+++ b/fs/notify/fdinfo.c
@@ -83,16 +83,9 @@ static void inotify_fdinfo(struct seq_file *m, struct fsnotify_mark *mark)
 	inode_mark = container_of(mark, struct inotify_inode_mark, fsn_mark);
 	inode = igrab(mark->connector->inode);
 	if (inode) {
-		/*
-		 * IN_ALL_EVENTS represents all of the mask bits
-		 * that we expose to userspace.  There is at
-		 * least one bit (FS_EVENT_ON_CHILD) which is
-		 * used only internally to the kernel.
-		 */
-		u32 mask = mark->mask & IN_ALL_EVENTS;
-		seq_printf(m, "inotify wd:%x ino:%lx sdev:%x mask:%x ignored_mask:%x ",
+		seq_printf(m, "inotify wd:%x ino:%lx sdev:%x mask:%x ignored_mask:0 ",
 			   inode_mark->wd, inode->i_ino, inode->i_sb->s_dev,
-			   mask, mark->ignored_mask);
+			   inotify_mark_user_mask(mark));
 		show_mark_fhandle(m, inode);
 		seq_putc(m, '\n');
 		iput(inode);
diff --git a/fs/notify/inotify/inotify.h b/fs/notify/inotify/inotify.h
index c00d2caca894..63050e25c84d 100644
--- a/fs/notify/inotify/inotify.h
+++ b/fs/notify/inotify/inotify.h
@@ -21,6 +21,18 @@ static inline struct inotify_event_info *INOTIFY_E(struct fsnotify_event *fse)
 	return container_of(fse, struct inotify_event_info, fse);
 }
 
+/*
+ * INOTIFY_USER_FLAGS represents all of the mask bits that we expose to
+ * userspace.  There is at least one bit (FS_EVENT_ON_CHILD) which is
+ * used only internally to the kernel.
+ */
+#define INOTIFY_USER_MASK (IN_ALL_EVENTS | IN_ONESHOT | IN_EXCL_UNLINK)
+
+static inline __u32 inotify_mark_user_mask(struct fsnotify_mark *fsn_mark)
+{
+	return fsn_mark->mask & INOTIFY_USER_MASK;
+}
+
 extern void inotify_ignored_and_remove_idr(struct fsnotify_mark *fsn_mark,
 					   struct fsnotify_group *group);
 extern int inotify_handle_event(struct fsnotify_group *group,
diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index 7cc7d3fb1862..2393956542bc 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -95,7 +95,7 @@ static inline __u32 inotify_arg_to_mask(u32 arg)
 	mask = (FS_IN_IGNORED | FS_EVENT_ON_CHILD | FS_UNMOUNT);
 
 	/* mask off the flags used to open the fd */
-	mask |= (arg & (IN_ALL_EVENTS | IN_ONESHOT | IN_EXCL_UNLINK));
+	mask |= (arg & INOTIFY_USER_MASK);
 
 	return mask;
 }
diff --git a/fs/notify/mark.c b/fs/notify/mark.c
index 258d99087183..9b7201d1398f 100644
--- a/fs/notify/mark.c
+++ b/fs/notify/mark.c
@@ -387,7 +387,7 @@ void fsnotify_free_mark(struct fsnotify_mark *mark)
 void fsnotify_destroy_mark(struct fsnotify_mark *mark,
 			   struct fsnotify_group *group)
 {
-	mutex_lock_nested(&group->mark_mutex, SINGLE_DEPTH_NESTING);
+	mutex_lock(&group->mark_mutex);
 	fsnotify_detach_mark(mark);
 	mutex_unlock(&group->mark_mutex);
 	fsnotify_free_mark(mark);
@@ -666,7 +666,7 @@ void fsnotify_clear_marks_by_group(struct fsnotify_group *group,
 	 * move marks to free to to_free list in one go and then free marks in
 	 * to_free list one by one.
 	 */
-	mutex_lock_nested(&group->mark_mutex, SINGLE_DEPTH_NESTING);
+	mutex_lock(&group->mark_mutex);
 	list_for_each_entry_safe(mark, lmark, &group->marks_list, g_list) {
 		if (mark->connector->flags & type)
 			list_move(&mark->g_list, &to_free);
@@ -675,7 +675,7 @@ void fsnotify_clear_marks_by_group(struct fsnotify_group *group,
 
 clear:
 	while (1) {
-		mutex_lock_nested(&group->mark_mutex, SINGLE_DEPTH_NESTING);
+		mutex_lock(&group->mark_mutex);
 		if (list_empty(head)) {
 			mutex_unlock(&group->mark_mutex);
 			break;
diff --git a/fs/ocfs2/dlmfs/userdlm.c b/fs/ocfs2/dlmfs/userdlm.c
index 9cecf4857195..24dbbbf13827 100644
--- a/fs/ocfs2/dlmfs/userdlm.c
+++ b/fs/ocfs2/dlmfs/userdlm.c
@@ -449,6 +449,11 @@ int user_dlm_cluster_lock(struct user_lock_res *lockres,
 	}
 
 	spin_lock(&lockres->l_lock);
+	if (lockres->l_flags & USER_LOCK_IN_TEARDOWN) {
+		spin_unlock(&lockres->l_lock);
+		status = -EAGAIN;
+		goto bail;
+	}
 
 	/* We only compare against the currently granted level
 	 * here. If the lock is blocked waiting on a downconvert,
@@ -615,7 +620,7 @@ int user_dlm_destroy_lock(struct user_lock_res *lockres)
 	spin_lock(&lockres->l_lock);
 	if (lockres->l_flags & USER_LOCK_IN_TEARDOWN) {
 		spin_unlock(&lockres->l_lock);
-		return 0;
+		goto bail;
 	}
 
 	lockres->l_flags |= USER_LOCK_IN_TEARDOWN;
@@ -629,12 +634,17 @@ int user_dlm_destroy_lock(struct user_lock_res *lockres)
 	}
 
 	if (lockres->l_ro_holders || lockres->l_ex_holders) {
+		lockres->l_flags &= ~USER_LOCK_IN_TEARDOWN;
 		spin_unlock(&lockres->l_lock);
 		goto bail;
 	}
 
 	status = 0;
 	if (!(lockres->l_flags & USER_LOCK_ATTACHED)) {
+		/*
+		 * lock is never requested, leave USER_LOCK_IN_TEARDOWN set
+		 * to avoid new lock request coming in.
+		 */
 		spin_unlock(&lockres->l_lock);
 		goto bail;
 	}
@@ -645,6 +655,10 @@ int user_dlm_destroy_lock(struct user_lock_res *lockres)
 
 	status = ocfs2_dlm_unlock(conn, &lockres->l_lksb, DLM_LKF_VALBLK);
 	if (status) {
+		spin_lock(&lockres->l_lock);
+		lockres->l_flags &= ~USER_LOCK_IN_TEARDOWN;
+		lockres->l_flags &= ~USER_LOCK_BUSY;
+		spin_unlock(&lockres->l_lock);
 		user_log_dlm_error("ocfs2_dlm_unlock", status, lockres);
 		goto bail;
 	}
diff --git a/include/drm/drm_edid.h b/include/drm/drm_edid.h
index 267e0426c479..0262e32ab59e 100644
--- a/include/drm/drm_edid.h
+++ b/include/drm/drm_edid.h
@@ -115,7 +115,7 @@ struct detailed_data_monitor_range {
 			u8 supported_scalings;
 			u8 preferred_refresh;
 		} __attribute__((packed)) cvt;
-	} formula;
+	} __attribute__((packed)) formula;
 } __attribute__((packed));
 
 struct detailed_data_wpindex {
@@ -148,7 +148,7 @@ struct detailed_non_pixel {
 		struct detailed_data_wpindex color;
 		struct std_timing timings[6];
 		struct cvt_timing cvt[4];
-	} data;
+	} __attribute__((packed)) data;
 } __attribute__((packed));
 
 #define EDID_DETAIL_EST_TIMINGS 0xf7
@@ -166,7 +166,7 @@ struct detailed_timing {
 	union {
 		struct detailed_pixel_timing pixel_data;
 		struct detailed_non_pixel other_data;
-	} data;
+	} __attribute__((packed)) data;
 } __attribute__((packed));
 
 #define DRM_EDID_INPUT_SERRATION_VSYNC (1 << 0)
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 598ee6ba5b18..2c63afd68978 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -150,6 +150,8 @@ struct capsule_info {
 	size_t			page_bytes_remain;
 };
 
+int efi_capsule_setup_info(struct capsule_info *cap_info, void *kbuff,
+                           size_t hdr_bytes);
 int __efi_capsule_setup_info(struct capsule_info *cap_info);
 
 /*
diff --git a/include/linux/mailbox_controller.h b/include/linux/mailbox_controller.h
index 74deadb42d76..5a4524f66ea1 100644
--- a/include/linux/mailbox_controller.h
+++ b/include/linux/mailbox_controller.h
@@ -83,6 +83,7 @@ struct mbox_controller {
 				      const struct of_phandle_args *sp);
 	/* Internal to API */
 	struct hrtimer poll_hrt;
+	spinlock_t poll_hrt_lock;
 	struct list_head node;
 };
 
diff --git a/include/linux/mtd/cfi.h b/include/linux/mtd/cfi.h
index 9b57a9b1b081..4ead3d1559f5 100644
--- a/include/linux/mtd/cfi.h
+++ b/include/linux/mtd/cfi.h
@@ -293,6 +293,7 @@ struct cfi_private {
 	map_word sector_erase_cmd;
 	unsigned long chipshift; /* Because they're of the same type */
 	const char *im_name;	 /* inter_module name for cmdset_setup */
+	unsigned long quirks;
 	struct flchip chips[0];  /* per-chip data structure for each chip */
 };
 
diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
index de1c50b93c61..13f6248151b9 100644
--- a/include/linux/nodemask.h
+++ b/include/linux/nodemask.h
@@ -42,11 +42,11 @@
  * void nodes_shift_right(dst, src, n)	Shift right
  * void nodes_shift_left(dst, src, n)	Shift left
  *
- * int first_node(mask)			Number lowest set bit, or MAX_NUMNODES
- * int next_node(node, mask)		Next node past 'node', or MAX_NUMNODES
- * int next_node_in(node, mask)		Next node past 'node', or wrap to first,
+ * unsigned int first_node(mask)	Number lowest set bit, or MAX_NUMNODES
+ * unsigend int next_node(node, mask)	Next node past 'node', or MAX_NUMNODES
+ * unsigned int next_node_in(node, mask) Next node past 'node', or wrap to first,
  *					or MAX_NUMNODES
- * int first_unset_node(mask)		First node not set in mask, or 
+ * unsigned int first_unset_node(mask)	First node not set in mask, or
  *					MAX_NUMNODES
  *
  * nodemask_t nodemask_of_node(node)	Return nodemask with bit 'node' set
@@ -144,7 +144,7 @@ static inline void __nodes_clear(nodemask_t *dstp, unsigned int nbits)
 
 #define node_test_and_set(node, nodemask) \
 			__node_test_and_set((node), &(nodemask))
-static inline int __node_test_and_set(int node, nodemask_t *addr)
+static inline bool __node_test_and_set(int node, nodemask_t *addr)
 {
 	return test_and_set_bit(node, addr->bits);
 }
@@ -191,7 +191,7 @@ static inline void __nodes_complement(nodemask_t *dstp,
 
 #define nodes_equal(src1, src2) \
 			__nodes_equal(&(src1), &(src2), MAX_NUMNODES)
-static inline int __nodes_equal(const nodemask_t *src1p,
+static inline bool __nodes_equal(const nodemask_t *src1p,
 					const nodemask_t *src2p, unsigned int nbits)
 {
 	return bitmap_equal(src1p->bits, src2p->bits, nbits);
@@ -199,7 +199,7 @@ static inline int __nodes_equal(const nodemask_t *src1p,
 
 #define nodes_intersects(src1, src2) \
 			__nodes_intersects(&(src1), &(src2), MAX_NUMNODES)
-static inline int __nodes_intersects(const nodemask_t *src1p,
+static inline bool __nodes_intersects(const nodemask_t *src1p,
 					const nodemask_t *src2p, unsigned int nbits)
 {
 	return bitmap_intersects(src1p->bits, src2p->bits, nbits);
@@ -207,20 +207,20 @@ static inline int __nodes_intersects(const nodemask_t *src1p,
 
 #define nodes_subset(src1, src2) \
 			__nodes_subset(&(src1), &(src2), MAX_NUMNODES)
-static inline int __nodes_subset(const nodemask_t *src1p,
+static inline bool __nodes_subset(const nodemask_t *src1p,
 					const nodemask_t *src2p, unsigned int nbits)
 {
 	return bitmap_subset(src1p->bits, src2p->bits, nbits);
 }
 
 #define nodes_empty(src) __nodes_empty(&(src), MAX_NUMNODES)
-static inline int __nodes_empty(const nodemask_t *srcp, unsigned int nbits)
+static inline bool __nodes_empty(const nodemask_t *srcp, unsigned int nbits)
 {
 	return bitmap_empty(srcp->bits, nbits);
 }
 
 #define nodes_full(nodemask) __nodes_full(&(nodemask), MAX_NUMNODES)
-static inline int __nodes_full(const nodemask_t *srcp, unsigned int nbits)
+static inline bool __nodes_full(const nodemask_t *srcp, unsigned int nbits)
 {
 	return bitmap_full(srcp->bits, nbits);
 }
@@ -251,15 +251,15 @@ static inline void __nodes_shift_left(nodemask_t *dstp,
           > MAX_NUMNODES, then the silly min_ts could be dropped. */
 
 #define first_node(src) __first_node(&(src))
-static inline int __first_node(const nodemask_t *srcp)
+static inline unsigned int __first_node(const nodemask_t *srcp)
 {
-	return min_t(int, MAX_NUMNODES, find_first_bit(srcp->bits, MAX_NUMNODES));
+	return min_t(unsigned int, MAX_NUMNODES, find_first_bit(srcp->bits, MAX_NUMNODES));
 }
 
 #define next_node(n, src) __next_node((n), &(src))
-static inline int __next_node(int n, const nodemask_t *srcp)
+static inline unsigned int __next_node(int n, const nodemask_t *srcp)
 {
-	return min_t(int,MAX_NUMNODES,find_next_bit(srcp->bits, MAX_NUMNODES, n+1));
+	return min_t(unsigned int, MAX_NUMNODES, find_next_bit(srcp->bits, MAX_NUMNODES, n+1));
 }
 
 /*
@@ -267,7 +267,7 @@ static inline int __next_node(int n, const nodemask_t *srcp)
  * the first node in src if needed.  Returns MAX_NUMNODES if src is empty.
  */
 #define next_node_in(n, src) __next_node_in((n), &(src))
-int __next_node_in(int node, const nodemask_t *srcp);
+unsigned int __next_node_in(int node, const nodemask_t *srcp);
 
 static inline void init_nodemask_of_node(nodemask_t *mask, int node)
 {
@@ -287,9 +287,9 @@ static inline void init_nodemask_of_node(nodemask_t *mask, int node)
 })
 
 #define first_unset_node(mask) __first_unset_node(&(mask))
-static inline int __first_unset_node(const nodemask_t *maskp)
+static inline unsigned int __first_unset_node(const nodemask_t *maskp)
 {
-	return min_t(int,MAX_NUMNODES,
+	return min_t(unsigned int, MAX_NUMNODES,
 			find_first_zero_bit(maskp->bits, MAX_NUMNODES));
 }
 
@@ -366,14 +366,13 @@ static inline void __nodes_fold(nodemask_t *dstp, const nodemask_t *origp,
 }
 
 #if MAX_NUMNODES > 1
-#define for_each_node_mask(node, mask)			\
-	for ((node) = first_node(mask);			\
-		(node) < MAX_NUMNODES;			\
-		(node) = next_node((node), (mask)))
+#define for_each_node_mask(node, mask)				    \
+	for ((node) = first_node(mask);				    \
+	     (node >= 0) && (node) < MAX_NUMNODES;		    \
+	     (node) = next_node((node), (mask)))
 #else /* MAX_NUMNODES == 1 */
-#define for_each_node_mask(node, mask)			\
-	if (!nodes_empty(mask))				\
-		for ((node) = 0; (node) < 1; (node)++)
+#define for_each_node_mask(node, mask)                                  \
+	for ((node) = 0; (node) < 1 && !nodes_empty(mask); (node)++)
 #endif /* MAX_NUMNODES */
 
 /*
@@ -426,11 +425,11 @@ static inline int num_node_state(enum node_states state)
 
 #define first_online_node	first_node(node_states[N_ONLINE])
 #define first_memory_node	first_node(node_states[N_MEMORY])
-static inline int next_online_node(int nid)
+static inline unsigned int next_online_node(int nid)
 {
 	return next_node(nid, node_states[N_ONLINE]);
 }
-static inline int next_memory_node(int nid)
+static inline unsigned int next_memory_node(int nid)
 {
 	return next_node(nid, node_states[N_MEMORY]);
 }
diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index 38342e88b3f3..a9bfd16fcf0e 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -40,12 +40,6 @@ extern int ptrace_access_vm(struct task_struct *tsk, unsigned long addr,
 #define PT_EXITKILL		(PTRACE_O_EXITKILL << PT_OPT_FLAG_SHIFT)
 #define PT_SUSPEND_SECCOMP	(PTRACE_O_SUSPEND_SECCOMP << PT_OPT_FLAG_SHIFT)
 
-/* single stepping state bits (used on ARM and PA-RISC) */
-#define PT_SINGLESTEP_BIT	31
-#define PT_SINGLESTEP		(1<<PT_SINGLESTEP_BIT)
-#define PT_BLOCKSTEP_BIT	30
-#define PT_BLOCKSTEP		(1<<PT_BLOCKSTEP_BIT)
-
 extern long arch_ptrace(struct task_struct *child, long request,
 			unsigned long addr, unsigned long data);
 extern int ptrace_readdata(struct task_struct *tsk, unsigned long src, char __user *dst, int len);
diff --git a/include/scsi/libfcoe.h b/include/scsi/libfcoe.h
index 78b9ad2df0b1..6f3571f42529 100644
--- a/include/scsi/libfcoe.h
+++ b/include/scsi/libfcoe.h
@@ -261,7 +261,8 @@ int fcoe_ctlr_recv_flogi(struct fcoe_ctlr *, struct fc_lport *,
 			 struct fc_frame *);
 
 /* libfcoe funcs */
-u64 fcoe_wwn_from_mac(unsigned char mac[MAX_ADDR_LEN], unsigned int, unsigned int);
+u64 fcoe_wwn_from_mac(unsigned char mac[ETH_ALEN], unsigned int scheme,
+		      unsigned int port);
 int fcoe_libfc_config(struct fc_lport *, struct fcoe_ctlr *,
 		      const struct libfc_function_template *, int init_fcp);
 u32 fcoe_fc_crc(struct fc_frame *fp);
diff --git a/include/sound/jack.h b/include/sound/jack.h
index 1e84bfb553cf..4742f842b457 100644
--- a/include/sound/jack.h
+++ b/include/sound/jack.h
@@ -77,6 +77,7 @@ struct snd_jack {
 	const char *id;
 #ifdef CONFIG_SND_JACK_INPUT_DEV
 	struct input_dev *input_dev;
+	struct mutex input_dev_lock;
 	int registered;
 	int type;
 	char name[100];
diff --git a/include/trace/events/vmscan.h b/include/trace/events/vmscan.h
index dc23cf032403..9553f6167e51 100644
--- a/include/trace/events/vmscan.h
+++ b/include/trace/events/vmscan.h
@@ -290,7 +290,7 @@ TRACE_EVENT(mm_vmscan_lru_isolate,
 		__field(unsigned long, nr_scanned)
 		__field(unsigned long, nr_skipped)
 		__field(unsigned long, nr_taken)
-		__field(isolate_mode_t, isolate_mode)
+		__field(unsigned int, isolate_mode)
 		__field(int, lru)
 	),
 
@@ -301,7 +301,7 @@ TRACE_EVENT(mm_vmscan_lru_isolate,
 		__entry->nr_scanned = nr_scanned;
 		__entry->nr_skipped = nr_skipped;
 		__entry->nr_taken = nr_taken;
-		__entry->isolate_mode = isolate_mode;
+		__entry->isolate_mode = (__force unsigned int)isolate_mode;
 		__entry->lru = lru;
 	),
 
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index cf03de0a7cc6..82cfc1d0e3e4 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -1127,9 +1127,8 @@ int ptrace_request(struct task_struct *child, long request,
 		return ptrace_resume(child, request, data);
 
 	case PTRACE_KILL:
-		if (child->exit_state)	/* already dead */
-			return 0;
-		return ptrace_resume(child, request, SIGKILL);
+		send_sig_info(SIGKILL, SEND_SIG_NOINFO, child);
+		return 0;
 
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
 	case PTRACE_GETREGSET:
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index c728acb6b14c..60a1733abbb7 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2324,7 +2324,7 @@ trace_event_buffer_lock_reserve(struct ring_buffer **current_rb,
 }
 EXPORT_SYMBOL_GPL(trace_event_buffer_lock_reserve);
 
-static DEFINE_SPINLOCK(tracepoint_iter_lock);
+static DEFINE_RAW_SPINLOCK(tracepoint_iter_lock);
 static DEFINE_MUTEX(tracepoint_printk_mutex);
 
 static void output_printk(struct trace_event_buffer *fbuffer)
@@ -2345,14 +2345,14 @@ static void output_printk(struct trace_event_buffer *fbuffer)
 
 	event = &fbuffer->trace_file->event_call->event;
 
-	spin_lock_irqsave(&tracepoint_iter_lock, flags);
+	raw_spin_lock_irqsave(&tracepoint_iter_lock, flags);
 	trace_seq_init(&iter->seq);
 	iter->ent = fbuffer->entry;
 	event_call->event.funcs->trace(iter, 0, event);
 	trace_seq_putc(&iter->seq, 0);
 	printk("%s", iter->seq.buffer);
 
-	spin_unlock_irqrestore(&tracepoint_iter_lock, flags);
+	raw_spin_unlock_irqrestore(&tracepoint_iter_lock, flags);
 }
 
 int tracepoint_printk_sysctl(struct ctl_table *table, int write,
@@ -5363,12 +5363,18 @@ static void tracing_set_nop(struct trace_array *tr)
 	tr->current_trace = &nop_trace;
 }
 
+static bool tracer_options_updated;
+
 static void add_tracer_options(struct trace_array *tr, struct tracer *t)
 {
 	/* Only enable if the directory has been created already. */
 	if (!tr->dir)
 		return;
 
+	/* Only create trace option files after update_tracer_options finish */
+	if (!tracer_options_updated)
+		return;
+
 	create_trace_option_files(tr, t);
 }
 
@@ -7733,6 +7739,7 @@ static void __update_tracer_options(struct trace_array *tr)
 static void update_tracer_options(struct trace_array *tr)
 {
 	mutex_lock(&trace_types_lock);
+	tracer_options_updated = true;
 	__update_tracer_options(tr);
 	mutex_unlock(&trace_types_lock);
 }
diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index 61e7240947f5..163e0e9b357f 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -465,7 +465,7 @@ EXPORT_SYMBOL(debug_dma_dump_mappings);
  * At any time debug_dma_assert_idle() can be called to trigger a
  * warning if any cachelines in the given page are in the active set.
  */
-static RADIX_TREE(dma_active_cacheline, GFP_NOWAIT);
+static RADIX_TREE(dma_active_cacheline, GFP_ATOMIC);
 static DEFINE_SPINLOCK(radix_lock);
 #define ACTIVE_CACHELINE_MAX_OVERLAP ((1 << RADIX_TREE_MAX_TAGS) - 1)
 #define CACHELINE_PER_PAGE_SHIFT (PAGE_SHIFT - L1_CACHE_SHIFT)
diff --git a/lib/nodemask.c b/lib/nodemask.c
index 3aa454c54c0d..e22647f5181b 100644
--- a/lib/nodemask.c
+++ b/lib/nodemask.c
@@ -3,9 +3,9 @@
 #include <linux/module.h>
 #include <linux/random.h>
 
-int __next_node_in(int node, const nodemask_t *srcp)
+unsigned int __next_node_in(int node, const nodemask_t *srcp)
 {
-	int ret = __next_node(node, srcp);
+	unsigned int ret = __next_node(node, srcp);
 
 	if (ret == MAX_NUMNODES)
 		ret = __first_node(srcp);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index c6ae9c9e360d..04ad2bba01eb 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4798,7 +4798,14 @@ int huge_pmd_unshare(struct mm_struct *mm, unsigned long *addr, pte_t *ptep)
 	pud_clear(pud);
 	put_page(virt_to_page(ptep));
 	mm_dec_nr_pmds(mm);
-	*addr = ALIGN(*addr, HPAGE_SIZE * PTRS_PER_PTE) - HPAGE_SIZE;
+	/*
+	 * This update of passed address optimizes loops sequentially
+	 * processing addresses in increments of huge page size (PMD_SIZE
+	 * in this case).  By clearing the pud, a PUD_SIZE area is unmapped.
+	 * Update address to the 'last page' in the cleared area so that
+	 * calling loop can move to first page past this area.
+	 */
+	*addr |= PUD_SIZE - PMD_SIZE;
 	return 1;
 }
 #define want_pmd_share()	(1)
diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index 5c411118b30d..22761a404e0d 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -563,19 +563,24 @@ static int sco_sock_connect(struct socket *sock, struct sockaddr *addr, int alen
 	    addr->sa_family != AF_BLUETOOTH)
 		return -EINVAL;
 
-	if (sk->sk_state != BT_OPEN && sk->sk_state != BT_BOUND)
-		return -EBADFD;
+	lock_sock(sk);
+	if (sk->sk_state != BT_OPEN && sk->sk_state != BT_BOUND) {
+		err = -EBADFD;
+		goto done;
+	}
 
-	if (sk->sk_type != SOCK_SEQPACKET)
-		return -EINVAL;
+	if (sk->sk_type != SOCK_SEQPACKET) {
+		err = -EINVAL;
+		goto done;
+	}
 
 	hdev = hci_get_route(&sa->sco_bdaddr, &sco_pi(sk)->src, BDADDR_BREDR);
-	if (!hdev)
-		return -EHOSTUNREACH;
+	if (!hdev) {
+		err = -EHOSTUNREACH;
+		goto done;
+	}
 	hci_dev_lock(hdev);
 
-	lock_sock(sk);
-
 	/* Set destination address and psm */
 	bacpy(&sco_pi(sk)->dst, &sa->sco_bdaddr);
 
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index f5cc025003cd..906d26794d00 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2619,12 +2619,15 @@ static void tcp_mtup_probe_success(struct sock *sk)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct inet_connection_sock *icsk = inet_csk(sk);
+	u64 val;
 
-	/* FIXME: breaks with very large cwnd */
 	tp->prior_ssthresh = tcp_current_ssthresh(sk);
-	tp->snd_cwnd = tp->snd_cwnd *
-		       tcp_mss_to_mtu(sk, tp->mss_cache) /
-		       icsk->icsk_mtup.probe_size;
+
+	val = (u64)tp->snd_cwnd * tcp_mss_to_mtu(sk, tp->mss_cache);
+	do_div(val, icsk->icsk_mtup.probe_size);
+	WARN_ON_ONCE((u32)val != val);
+	tp->snd_cwnd = max_t(u32, 1U, val);
+
 	tp->snd_cwnd_cnt = 0;
 	tp->snd_cwnd_stamp = tcp_jiffies32;
 	tp->snd_ssthresh = tcp_current_ssthresh(sk);
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 1a5c42c67d42..a231993c81c4 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3795,8 +3795,8 @@ int tcp_rtx_synack(const struct sock *sk, struct request_sock *req)
 	tcp_rsk(req)->txhash = net_tx_rndhash();
 	res = af_ops->send_synack(sk, NULL, &fl, req, NULL, TCP_SYNACK_NORMAL);
 	if (!res) {
-		__TCP_INC_STATS(sock_net(sk), TCP_MIB_RETRANSSEGS);
-		__NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPSYNRETRANS);
+		TCP_INC_STATS(sock_net(sk), TCP_MIB_RETRANSSEGS);
+		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPSYNRETRANS);
 		if (unlikely(tcp_passive_fastopen(sk)))
 			tcp_sk(sk)->total_retrans++;
 	}
diff --git a/net/ipv4/xfrm4_protocol.c b/net/ipv4/xfrm4_protocol.c
index 8dd0e6ab8606..0e1f5dc2766b 100644
--- a/net/ipv4/xfrm4_protocol.c
+++ b/net/ipv4/xfrm4_protocol.c
@@ -297,4 +297,3 @@ void __init xfrm4_protocol_init(void)
 {
 	xfrm_input_register_afinfo(&xfrm4_input_afinfo);
 }
-EXPORT_SYMBOL(xfrm4_protocol_init);
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 09807202bd1c..0d3e76b160a5 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -4058,7 +4058,8 @@ static void addrconf_dad_completed(struct inet6_ifaddr *ifp, bool bump_id,
 	send_rs = send_mld &&
 		  ipv6_accept_ra(ifp->idev) &&
 		  ifp->idev->cnf.rtr_solicits != 0 &&
-		  (dev->flags&IFF_LOOPBACK) == 0;
+		  (dev->flags & IFF_LOOPBACK) == 0 &&
+		  (dev->type != ARPHRD_TUNNEL);
 	read_unlock_bh(&ifp->idev->lock);
 
 	/* While dad is in progress mld report's source address is in6_addrany.
diff --git a/net/ipv6/seg6_hmac.c b/net/ipv6/seg6_hmac.c
index 558fe8cc6d43..ad5f8d521402 100644
--- a/net/ipv6/seg6_hmac.c
+++ b/net/ipv6/seg6_hmac.c
@@ -405,7 +405,6 @@ int __init seg6_hmac_init(void)
 {
 	return seg6_hmac_init_algo();
 }
-EXPORT_SYMBOL(seg6_hmac_init);
 
 int __net_init seg6_hmac_net_init(struct net *net)
 {
diff --git a/net/key/af_key.c b/net/key/af_key.c
index 990de0702b79..035123bf7259 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -2834,10 +2834,12 @@ static int pfkey_process(struct sock *sk, struct sk_buff *skb, const struct sadb
 	void *ext_hdrs[SADB_EXT_MAX];
 	int err;
 
-	err = pfkey_broadcast(skb_clone(skb, GFP_KERNEL), GFP_KERNEL,
-			      BROADCAST_PROMISC_ONLY, NULL, sock_net(sk));
-	if (err)
-		return err;
+	/* Non-zero return value of pfkey_broadcast() does not always signal
+	 * an error and even on an actual error we may still want to process
+	 * the message so rather ignore the return value.
+	 */
+	pfkey_broadcast(skb_clone(skb, GFP_KERNEL), GFP_KERNEL,
+			BROADCAST_PROMISC_ONLY, NULL, sock_net(sk));
 
 	memset(ext_hdrs, 0, sizeof(ext_hdrs));
 	err = parse_exthdrs(skb, hdr, ext_hdrs);
diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 89178b46b32f..5dbfbe1c6b00 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -1638,12 +1638,9 @@ int ieee80211_vif_use_reserved_context(struct ieee80211_sub_if_data *sdata)
 
 	if (new_ctx->replace_state == IEEE80211_CHANCTX_REPLACE_NONE) {
 		if (old_ctx)
-			err = ieee80211_vif_use_reserved_reassign(sdata);
-		else
-			err = ieee80211_vif_use_reserved_assign(sdata);
+			return ieee80211_vif_use_reserved_reassign(sdata);
 
-		if (err)
-			return err;
+		return ieee80211_vif_use_reserved_assign(sdata);
 	}
 
 	/*
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 0d4f7258b243..7c8d77d899b6 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1067,6 +1067,9 @@ struct tpt_led_trigger {
  *	a scan complete for an aborted scan.
  * @SCAN_HW_CANCELLED: Set for our scan work function when the scan is being
  *	cancelled.
+ * @SCAN_BEACON_WAIT: Set whenever we're passive scanning because of radar/no-IR
+ *	and could send a probe request after receiving a beacon.
+ * @SCAN_BEACON_DONE: Beacon received, we can now send a probe request
  */
 enum {
 	SCAN_SW_SCANNING,
@@ -1075,6 +1078,8 @@ enum {
 	SCAN_COMPLETED,
 	SCAN_ABORTED,
 	SCAN_HW_CANCELLED,
+	SCAN_BEACON_WAIT,
+	SCAN_BEACON_DONE,
 };
 
 /**
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 47d2ed570470..dd9d7c4b7f2d 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -205,6 +205,16 @@ void ieee80211_scan_rx(struct ieee80211_local *local, struct sk_buff *skb)
 	if (likely(!sdata1 && !sdata2))
 		return;
 
+	if (test_and_clear_bit(SCAN_BEACON_WAIT, &local->scanning)) {
+		/*
+		 * we were passive scanning because of radar/no-IR, but
+		 * the beacon/proberesp rx gives us an opportunity to upgrade
+		 * to active scan
+		 */
+		 set_bit(SCAN_BEACON_DONE, &local->scanning);
+		 ieee80211_queue_delayed_work(&local->hw, &local->scan_work, 0);
+	}
+
 	if (ieee80211_is_probe_resp(mgmt->frame_control)) {
 		struct cfg80211_scan_request *scan_req;
 		struct cfg80211_sched_scan_request *sched_scan_req;
@@ -646,6 +656,8 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 						IEEE80211_CHAN_RADAR)) ||
 		    !req->n_ssids) {
 			next_delay = IEEE80211_PASSIVE_CHANNEL_TIME;
+			if (req->n_ssids)
+				set_bit(SCAN_BEACON_WAIT, &local->scanning);
 		} else {
 			ieee80211_scan_state_send_probe(local, &next_delay);
 			next_delay = IEEE80211_CHANNEL_TIME;
@@ -826,6 +838,8 @@ static void ieee80211_scan_state_set_channel(struct ieee80211_local *local,
 	    !scan_req->n_ssids) {
 		*next_delay = IEEE80211_PASSIVE_CHANNEL_TIME;
 		local->next_scan_state = SCAN_DECISION;
+		if (scan_req->n_ssids)
+			set_bit(SCAN_BEACON_WAIT, &local->scanning);
 		return;
 	}
 
@@ -918,6 +932,8 @@ void ieee80211_scan_work(struct work_struct *work)
 			goto out;
 	}
 
+	clear_bit(SCAN_BEACON_WAIT, &local->scanning);
+
 	/*
 	 * as long as no delay is required advance immediately
 	 * without scheduling a new work
@@ -928,6 +944,10 @@ void ieee80211_scan_work(struct work_struct *work)
 			goto out_complete;
 		}
 
+		if (test_and_clear_bit(SCAN_BEACON_DONE, &local->scanning) &&
+		    local->next_scan_state == SCAN_DECISION)
+			local->next_scan_state = SCAN_SEND_PROBE;
+
 		switch (local->next_scan_state) {
 		case SCAN_DECISION:
 			/* if no more bands/channels left, complete scan */
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 7c95314f0b7d..28fc44e31272 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1952,23 +1952,27 @@ struct nft_expr *nft_expr_init(const struct nft_ctx *ctx,
 
 	err = nf_tables_expr_parse(ctx, nla, &info);
 	if (err < 0)
-		goto err1;
+		goto err_expr_parse;
+
+	err = -EOPNOTSUPP;
+	if (!(info.ops->type->flags & NFT_EXPR_STATEFUL))
+		goto err_expr_stateful;
 
 	err = -ENOMEM;
 	expr = kzalloc(info.ops->size, GFP_KERNEL);
 	if (expr == NULL)
-		goto err2;
+		goto err_expr_stateful;
 
 	err = nf_tables_newexpr(ctx, &info, expr);
 	if (err < 0)
-		goto err3;
+		goto err_expr_new;
 
 	return expr;
-err3:
+err_expr_new:
 	kfree(expr);
-err2:
+err_expr_stateful:
 	module_put(info.ops->type->owner);
-err1:
+err_expr_parse:
 	return ERR_PTR(err);
 }
 
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index 278d76566348..f8688f9bf46c 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -191,9 +191,6 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 		if (IS_ERR(priv->expr))
 			return PTR_ERR(priv->expr);
 
-		err = -EOPNOTSUPP;
-		if (!(priv->expr->ops->type->flags & NFT_EXPR_STATEFUL))
-			goto err1;
 	} else if (set->flags & NFT_SET_EVAL)
 		return -EINVAL;
 
diff --git a/net/nfc/core.c b/net/nfc/core.c
index 8c38a21fb0c6..120259c2b6a7 100644
--- a/net/nfc/core.c
+++ b/net/nfc/core.c
@@ -1174,6 +1174,7 @@ void nfc_unregister_device(struct nfc_dev *dev)
 	if (dev->rfkill) {
 		rfkill_unregister(dev->rfkill);
 		rfkill_destroy(dev->rfkill);
+		dev->rfkill = NULL;
 	}
 	dev->shutting_down = true;
 	device_unlock(&dev->dev);
diff --git a/net/rxrpc/call_event.c b/net/rxrpc/call_event.c
index 7a77844aab16..7444290b228a 100644
--- a/net/rxrpc/call_event.c
+++ b/net/rxrpc/call_event.c
@@ -403,7 +403,8 @@ void rxrpc_process_call(struct work_struct *work)
 		goto recheck_state;
 	}
 
-	if (test_and_clear_bit(RXRPC_CALL_EV_RESEND, &call->events)) {
+	if (test_and_clear_bit(RXRPC_CALL_EV_RESEND, &call->events) &&
+	    call->state != RXRPC_CALL_CLIENT_RECV_REPLY) {
 		rxrpc_resend(call, now);
 		goto recheck_state;
 	}
diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
index 8f9a2a7eeb7c..de73c2effc89 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -383,6 +383,12 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
 
 success:
 	ret = copied;
+	if (READ_ONCE(call->state) == RXRPC_CALL_COMPLETE) {
+		read_lock_bh(&call->state_lock);
+		if (call->error < 0)
+			ret = call->error;
+		read_unlock_bh(&call->state_lock);
+	}
 out:
 	call->tx_pending = skb;
 	_leave(" = %d", ret);
diff --git a/net/rxrpc/sysctl.c b/net/rxrpc/sysctl.c
index 34c706d2f79c..f9afc21b7e2c 100644
--- a/net/rxrpc/sysctl.c
+++ b/net/rxrpc/sysctl.c
@@ -18,7 +18,7 @@ static struct ctl_table_header *rxrpc_sysctl_reg_table;
 static const unsigned int zero = 0;
 static const unsigned int one = 1;
 static const unsigned int four = 4;
-static const unsigned int thirtytwo = 32;
+static const unsigned int max_backlog = RXRPC_BACKLOG_MAX - 1;
 static const unsigned int n_65535 = 65535;
 static const unsigned int n_max_acks = RXRPC_RXTX_BUFF_SIZE - 1;
 
@@ -114,7 +114,7 @@ static struct ctl_table rxrpc_sysctl_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= (void *)&four,
-		.extra2		= (void *)&thirtytwo,
+		.extra2		= (void *)&max_backlog,
 	},
 	{
 		.procname	= "rx_window_size",
diff --git a/net/sctp/input.c b/net/sctp/input.c
index b20a1fbea8bf..3305e11035fd 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -103,6 +103,7 @@ int sctp_rcv(struct sk_buff *skb)
 	struct sctp_chunk *chunk;
 	union sctp_addr src;
 	union sctp_addr dest;
+	int bound_dev_if;
 	int family;
 	struct sctp_af *af;
 	struct net *net = dev_net(skb->dev);
@@ -180,7 +181,8 @@ int sctp_rcv(struct sk_buff *skb)
 	 * If a frame arrives on an interface and the receiving socket is
 	 * bound to another interface, via SO_BINDTODEVICE, treat it as OOTB
 	 */
-	if (sk->sk_bound_dev_if && (sk->sk_bound_dev_if != af->skb_iif(skb))) {
+	bound_dev_if = READ_ONCE(sk->sk_bound_dev_if);
+	if (bound_dev_if && (bound_dev_if != af->skb_iif(skb))) {
 		if (transport) {
 			sctp_transport_put(transport);
 			asoc = NULL;
diff --git a/net/sunrpc/xdr.c b/net/sunrpc/xdr.c
index 87cf0b933f99..51ccde7c1311 100644
--- a/net/sunrpc/xdr.c
+++ b/net/sunrpc/xdr.c
@@ -544,7 +544,11 @@ static __be32 *xdr_get_next_encode_buffer(struct xdr_stream *xdr,
 	 */
 	xdr->p = (void *)p + frag2bytes;
 	space_left = xdr->buf->buflen - xdr->buf->len;
-	xdr->end = (void *)p + min_t(int, space_left, PAGE_SIZE);
+	if (space_left - nbytes >= PAGE_SIZE)
+		xdr->end = (void *)p + PAGE_SIZE;
+	else
+		xdr->end = (void *)p + space_left - frag1bytes;
+
 	xdr->buf->page_len += frag2bytes;
 	xdr->buf->len += nbytes;
 	return p;
diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rpc_rdma.c
index 991d5a96f35b..030bf17a20b6 100644
--- a/net/sunrpc/xprtrdma/rpc_rdma.c
+++ b/net/sunrpc/xprtrdma/rpc_rdma.c
@@ -974,6 +974,7 @@ rpcrdma_is_bcall(struct rpcrdma_xprt *r_xprt, struct rpcrdma_rep *rep,
 		 __be32 xid, __be32 proc)
 #if defined(CONFIG_SUNRPC_BACKCHANNEL)
 {
+	struct rpc_xprt *xprt = &r_xprt->rx_xprt;
 	struct xdr_stream *xdr = &rep->rr_stream;
 	__be32 *p;
 
@@ -997,6 +998,10 @@ rpcrdma_is_bcall(struct rpcrdma_xprt *r_xprt, struct rpcrdma_rep *rep,
 	if (*p != cpu_to_be32(RPC_CALL))
 		return false;
 
+	/* No bc service. */
+	if (xprt->bc_serv == NULL)
+		return false;
+
 	/* Now that we are sure this is a backchannel call,
 	 * advance to the RPC header.
 	 */
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index b6eb929899c5..f35fb7fcd98c 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1229,7 +1229,8 @@ static int secref_whitelist(const struct sectioncheck *mismatch,
 
 static inline int is_arm_mapping_symbol(const char *str)
 {
-	return str[0] == '$' && strchr("axtd", str[1])
+	return str[0] == '$' &&
+	       (str[1] == 'a' || str[1] == 'd' || str[1] == 't' || str[1] == 'x')
 	       && (str[2] == '\0' || str[2] == '.');
 }
 
@@ -1949,7 +1950,7 @@ static char *remove_dot(char *s)
 
 	if (n && s[n]) {
 		size_t m = strspn(s + n + 1, "0123456789");
-		if (m && (s[n + m] == '.' || s[n + m] == 0))
+		if (m && (s[n + m + 1] == '.' || s[n + m + 1] == 0))
 			s[n] = 0;
 	}
 	return s;
diff --git a/sound/core/jack.c b/sound/core/jack.c
index 36cfe1c54109..d2f9a92453f2 100644
--- a/sound/core/jack.c
+++ b/sound/core/jack.c
@@ -48,8 +48,11 @@ static int snd_jack_dev_disconnect(struct snd_device *device)
 #ifdef CONFIG_SND_JACK_INPUT_DEV
 	struct snd_jack *jack = device->device_data;
 
-	if (!jack->input_dev)
+	mutex_lock(&jack->input_dev_lock);
+	if (!jack->input_dev) {
+		mutex_unlock(&jack->input_dev_lock);
 		return 0;
+	}
 
 	/* If the input device is registered with the input subsystem
 	 * then we need to use a different deallocator. */
@@ -58,6 +61,7 @@ static int snd_jack_dev_disconnect(struct snd_device *device)
 	else
 		input_free_device(jack->input_dev);
 	jack->input_dev = NULL;
+	mutex_unlock(&jack->input_dev_lock);
 #endif /* CONFIG_SND_JACK_INPUT_DEV */
 	return 0;
 }
@@ -96,8 +100,11 @@ static int snd_jack_dev_register(struct snd_device *device)
 	snprintf(jack->name, sizeof(jack->name), "%s %s",
 		 card->shortname, jack->id);
 
-	if (!jack->input_dev)
+	mutex_lock(&jack->input_dev_lock);
+	if (!jack->input_dev) {
+		mutex_unlock(&jack->input_dev_lock);
 		return 0;
+	}
 
 	jack->input_dev->name = jack->name;
 
@@ -122,6 +129,7 @@ static int snd_jack_dev_register(struct snd_device *device)
 	if (err == 0)
 		jack->registered = 1;
 
+	mutex_unlock(&jack->input_dev_lock);
 	return err;
 }
 #endif /* CONFIG_SND_JACK_INPUT_DEV */
@@ -242,9 +250,11 @@ int snd_jack_new(struct snd_card *card, const char *id, int type,
 		return -ENOMEM;
 	}
 
-	/* don't creat input device for phantom jack */
-	if (!phantom_jack) {
 #ifdef CONFIG_SND_JACK_INPUT_DEV
+	mutex_init(&jack->input_dev_lock);
+
+	/* don't create input device for phantom jack */
+	if (!phantom_jack) {
 		int i;
 
 		jack->input_dev = input_allocate_device();
@@ -262,8 +272,8 @@ int snd_jack_new(struct snd_card *card, const char *id, int type,
 				input_set_capability(jack->input_dev, EV_SW,
 						     jack_switch_types[i]);
 
-#endif /* CONFIG_SND_JACK_INPUT_DEV */
 	}
+#endif /* CONFIG_SND_JACK_INPUT_DEV */
 
 	err = snd_device_new(card, SNDRV_DEV_JACK, jack, &ops);
 	if (err < 0)
@@ -303,10 +313,14 @@ EXPORT_SYMBOL(snd_jack_new);
 void snd_jack_set_parent(struct snd_jack *jack, struct device *parent)
 {
 	WARN_ON(jack->registered);
-	if (!jack->input_dev)
+	mutex_lock(&jack->input_dev_lock);
+	if (!jack->input_dev) {
+		mutex_unlock(&jack->input_dev_lock);
 		return;
+	}
 
 	jack->input_dev->dev.parent = parent;
+	mutex_unlock(&jack->input_dev_lock);
 }
 EXPORT_SYMBOL(snd_jack_set_parent);
 
@@ -354,6 +368,8 @@ EXPORT_SYMBOL(snd_jack_set_key);
 
 /**
  * snd_jack_report - Report the current status of a jack
+ * Note: This function uses mutexes and should be called from a
+ * context which can sleep (such as a workqueue).
  *
  * @jack:   The jack to report status for
  * @status: The current status of the jack
@@ -373,8 +389,11 @@ void snd_jack_report(struct snd_jack *jack, int status)
 					    status & jack_kctl->mask_bits);
 
 #ifdef CONFIG_SND_JACK_INPUT_DEV
-	if (!jack->input_dev)
+	mutex_lock(&jack->input_dev_lock);
+	if (!jack->input_dev) {
+		mutex_unlock(&jack->input_dev_lock);
 		return;
+	}
 
 	for (i = 0; i < ARRAY_SIZE(jack->key); i++) {
 		int testbit = SND_JACK_BTN_0 >> i;
@@ -393,6 +412,7 @@ void snd_jack_report(struct snd_jack *jack, int status)
 	}
 
 	input_sync(jack->input_dev);
+	mutex_unlock(&jack->input_dev_lock);
 #endif /* CONFIG_SND_JACK_INPUT_DEV */
 }
 EXPORT_SYMBOL(snd_jack_report);
diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index d790c8604a9c..a888e3593d5f 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -1059,6 +1059,13 @@ static int patch_conexant_auto(struct hda_codec *codec)
 		snd_hda_pick_fixup(codec, cxt5051_fixup_models,
 				   cxt5051_fixups, cxt_fixups);
 		break;
+	case 0x14f15098:
+		codec->pin_amp_workaround = 1;
+		spec->gen.mixer_nid = 0x22;
+		spec->gen.add_stereo_mix_input = HDA_HINT_STEREO_MIX_AUTO;
+		snd_hda_pick_fixup(codec, cxt5066_fixup_models,
+				   cxt5066_fixups, cxt_fixups);
+		break;
 	case 0x14f150f2:
 		codec->power_save_node = 1;
 		/* Fall through */
diff --git a/sound/soc/codecs/rt5514.c b/sound/soc/codecs/rt5514.c
index 56ddab43da7e..c651cc6dddc8 100644
--- a/sound/soc/codecs/rt5514.c
+++ b/sound/soc/codecs/rt5514.c
@@ -352,7 +352,7 @@ static int rt5514_dsp_voice_wake_up_put(struct snd_kcontrol *kcontrol,
 		}
 	}
 
-	return 0;
+	return 1;
 }
 
 static const struct snd_kcontrol_new rt5514_snd_controls[] = {
diff --git a/sound/soc/codecs/rt5645.c b/sound/soc/codecs/rt5645.c
index a98647ac497c..01de25813c72 100644
--- a/sound/soc/codecs/rt5645.c
+++ b/sound/soc/codecs/rt5645.c
@@ -3972,9 +3972,14 @@ static int rt5645_i2c_remove(struct i2c_client *i2c)
 	if (i2c->irq)
 		free_irq(i2c->irq, rt5645);
 
+	/*
+	 * Since the rt5645_btn_check_callback() can queue jack_detect_work,
+	 * the timer need to be delted first
+	 */
+	del_timer_sync(&rt5645->btn_check_timer);
+
 	cancel_delayed_work_sync(&rt5645->jack_detect_work);
 	cancel_delayed_work_sync(&rt5645->rcclock_work);
-	del_timer_sync(&rt5645->btn_check_timer);
 
 	snd_soc_unregister_codec(&i2c->dev);
 	regulator_bulk_disable(ARRAY_SIZE(rt5645->supplies), rt5645->supplies);
diff --git a/sound/soc/codecs/wm2000.c b/sound/soc/codecs/wm2000.c
index 23cde3a0dc11..73cda3c2a861 100644
--- a/sound/soc/codecs/wm2000.c
+++ b/sound/soc/codecs/wm2000.c
@@ -545,7 +545,7 @@ static int wm2000_anc_transition(struct wm2000_priv *wm2000,
 {
 	struct i2c_client *i2c = wm2000->i2c;
 	int i, j;
-	int ret;
+	int ret = 0;
 
 	if (wm2000->anc_mode == mode)
 		return 0;
@@ -575,13 +575,13 @@ static int wm2000_anc_transition(struct wm2000_priv *wm2000,
 		ret = anc_transitions[i].step[j](i2c,
 						 anc_transitions[i].analogue);
 		if (ret != 0)
-			return ret;
+			break;
 	}
 
 	if (anc_transitions[i].dest == ANC_OFF)
 		clk_disable_unprepare(wm2000->mclk);
 
-	return 0;
+	return ret;
 }
 
 static int wm2000_anc_set_mode(struct wm2000_priv *wm2000)
diff --git a/sound/soc/mediatek/mt2701/mt2701-wm8960.c b/sound/soc/mediatek/mt2701/mt2701-wm8960.c
index a08ce2323bdc..3db92506ccea 100644
--- a/sound/soc/mediatek/mt2701/mt2701-wm8960.c
+++ b/sound/soc/mediatek/mt2701/mt2701-wm8960.c
@@ -126,7 +126,8 @@ static int mt2701_wm8960_machine_probe(struct platform_device *pdev)
 	if (!codec_node) {
 		dev_err(&pdev->dev,
 			"Property 'audio-codec' missing or invalid\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto put_platform_node;
 	}
 	for (i = 0; i < card->num_links; i++) {
 		if (mt2701_wm8960_dai_links[i].codec_name)
@@ -137,7 +138,7 @@ static int mt2701_wm8960_machine_probe(struct platform_device *pdev)
 	ret = snd_soc_of_parse_audio_routing(card, "audio-routing");
 	if (ret) {
 		dev_err(&pdev->dev, "failed to parse audio-routing: %d\n", ret);
-		return ret;
+		goto put_codec_node;
 	}
 
 	ret = devm_snd_soc_register_card(&pdev->dev, card);
@@ -145,6 +146,10 @@ static int mt2701_wm8960_machine_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "%s snd_soc_register_card fail %d\n",
 			__func__, ret);
 
+put_codec_node:
+	of_node_put(codec_node);
+put_platform_node:
+	of_node_put(platform_node);
 	return ret;
 }
 
diff --git a/sound/soc/mediatek/mt8173/mt8173-max98090.c b/sound/soc/mediatek/mt8173/mt8173-max98090.c
index 0adb7ded61e9..0f460bc77f47 100644
--- a/sound/soc/mediatek/mt8173/mt8173-max98090.c
+++ b/sound/soc/mediatek/mt8173/mt8173-max98090.c
@@ -164,7 +164,8 @@ static int mt8173_max98090_dev_probe(struct platform_device *pdev)
 	if (!codec_node) {
 		dev_err(&pdev->dev,
 			"Property 'audio-codec' missing or invalid\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto put_platform_node;
 	}
 	for (i = 0; i < card->num_links; i++) {
 		if (mt8173_max98090_dais[i].codec_name)
@@ -179,6 +180,8 @@ static int mt8173_max98090_dev_probe(struct platform_device *pdev)
 			__func__, ret);
 
 	of_node_put(codec_node);
+
+put_platform_node:
 	of_node_put(platform_node);
 	return ret;
 }
diff --git a/sound/soc/mxs/mxs-saif.c b/sound/soc/mxs/mxs-saif.c
index 93c019670199..6d0ab4e75518 100644
--- a/sound/soc/mxs/mxs-saif.c
+++ b/sound/soc/mxs/mxs-saif.c
@@ -780,6 +780,7 @@ static int mxs_saif_probe(struct platform_device *pdev)
 		saif->master_id = saif->id;
 	} else {
 		ret = of_alias_get_id(master, "saif");
+		of_node_put(master);
 		if (ret < 0)
 			return ret;
 		else
diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index dd3053c243c1..320d262c16c9 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -3282,7 +3282,6 @@ int snd_soc_dapm_put_volsw(struct snd_kcontrol *kcontrol,
 			update.val = val;
 			card->update = &update;
 		}
-		change |= reg_change;
 
 		ret = soc_dapm_mixer_update_power(card, kcontrol, connect,
 						  rconnect);
@@ -3388,7 +3387,6 @@ int snd_soc_dapm_put_enum_double(struct snd_kcontrol *kcontrol,
 			update.val = val;
 			card->update = &update;
 		}
-		change |= reg_change;
 
 		ret = soc_dapm_mux_update_power(card, kcontrol, item[0], e);
 
diff --git a/tools/perf/builtin-c2c.c b/tools/perf/builtin-c2c.c
index 264d458bfe2a..729e5f137963 100644
--- a/tools/perf/builtin-c2c.c
+++ b/tools/perf/builtin-c2c.c
@@ -886,8 +886,8 @@ percent_rmt_hitm_cmp(struct perf_hpp_fmt *fmt __maybe_unused,
 	double per_left;
 	double per_right;
 
-	per_left  = PERCENT(left, lcl_hitm);
-	per_right = PERCENT(right, lcl_hitm);
+	per_left  = PERCENT(left, rmt_hitm);
+	per_right = PERCENT(right, rmt_hitm);
 
 	return per_left - per_right;
 }
@@ -2552,9 +2552,7 @@ static int perf_c2c__report(int argc, const char **argv)
 		   "the input file to process"),
 	OPT_INCR('N', "node-info", &c2c.node_info,
 		 "show extra node info in report (repeat for more info)"),
-#ifdef HAVE_SLANG_SUPPORT
 	OPT_BOOLEAN(0, "stdio", &c2c.use_stdio, "Use the stdio interface"),
-#endif
 	OPT_BOOLEAN(0, "stats", &c2c.stats_only,
 		    "Display only statistic tables (implies --stdio)"),
 	OPT_BOOLEAN(0, "full-symbols", &c2c.symbol_full,
@@ -2581,6 +2579,10 @@ static int perf_c2c__report(int argc, const char **argv)
 	if (argc)
 		usage_with_options(report_c2c_usage, options);
 
+#ifndef HAVE_SLANG_SUPPORT
+	c2c.use_stdio = true;
+#endif
+
 	if (c2c.stats_only)
 		c2c.use_stdio = true;
 
diff --git a/tools/perf/pmu-events/jevents.c b/tools/perf/pmu-events/jevents.c
index 8e487b2a37a6..dcfbbade657e 100644
--- a/tools/perf/pmu-events/jevents.c
+++ b/tools/perf/pmu-events/jevents.c
@@ -428,7 +428,7 @@ int json_events(const char *fn,
 			} else if (json_streq(map, field, "ExtSel")) {
 				char *code = NULL;
 				addfield(map, &code, "", "", val);
-				eventcode |= strtoul(code, NULL, 0) << 21;
+				eventcode |= strtoul(code, NULL, 0) << 8;
 				free(code);
 			} else if (json_streq(map, field, "EventName")) {
 				addfield(map, &name, "", "", val);
