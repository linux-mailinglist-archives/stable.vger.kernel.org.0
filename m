Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0F4F64CD5D
	for <lists+stable@lfdr.de>; Wed, 14 Dec 2022 16:50:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238896AbiLNPuz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Dec 2022 10:50:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238882AbiLNPsy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Dec 2022 10:48:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC9AE27FDD;
        Wed, 14 Dec 2022 07:48:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 013E3B815FC;
        Wed, 14 Dec 2022 15:48:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A41ABC433EF;
        Wed, 14 Dec 2022 15:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671032884;
        bh=GvL4e8h13sQjW2V78LWYuEEXav+ZAWlQo6STFSxdqVI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=10roSaR7Q1GrL3oZCIldD0EPbbvSFpwVHsQJ73Wbtvj7VX9hm6wjEl9FWUL6Eq9XM
         VVScL60aRGMjaWQMhgol3aVfRvJrmDBmi4ecZZotZ5DHgcatHLXVFiTy4KdhmBHNjR
         cImcY+7keDiiKLW9w/bfts1eoTNnh6W+GMg2DeoE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 6.0.13
Date:   Wed, 14 Dec 2022 16:47:19 +0100
Message-Id: <167103283874192@kroah.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <167103283885128@kroah.com>
References: <167103283885128@kroah.com>
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

diff --git a/.clang-format b/.clang-format
index 1247d54f9e49..8d01225bfcb7 100644
--- a/.clang-format
+++ b/.clang-format
@@ -535,6 +535,7 @@ ForEachMacros:
   - 'perf_hpp_list__for_each_sort_list_safe'
   - 'perf_pmu__for_each_hybrid_pmu'
   - 'ping_portaddr_for_each_entry'
+  - 'ping_portaddr_for_each_entry_rcu'
   - 'plist_for_each'
   - 'plist_for_each_continue'
   - 'plist_for_each_entry'
diff --git a/Makefile b/Makefile
index 46c6eb57b354..bf00f3240b3a 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 6
 PATCHLEVEL = 0
-SUBLEVEL = 12
+SUBLEVEL = 13
 EXTRAVERSION =
 NAME = Hurr durr I'ma ninja sloth
 
diff --git a/arch/arm/boot/dts/imx7s.dtsi b/arch/arm/boot/dts/imx7s.dtsi
index 1dc3bfac30b6..29148285f9fc 100644
--- a/arch/arm/boot/dts/imx7s.dtsi
+++ b/arch/arm/boot/dts/imx7s.dtsi
@@ -1270,10 +1270,10 @@ dma_apbh: dma-apbh@33000000 {
 			clocks = <&clks IMX7D_NAND_USDHC_BUS_RAWNAND_CLK>;
 		};
 
-		gpmi: nand-controller@33002000 {
+		gpmi: nand-controller@33002000{
 			compatible = "fsl,imx7d-gpmi-nand";
 			#address-cells = <1>;
-			#size-cells = <0>;
+			#size-cells = <1>;
 			reg = <0x33002000 0x2000>, <0x33004000 0x4000>;
 			reg-names = "gpmi-nand", "bch";
 			interrupts = <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>;
diff --git a/arch/arm/boot/dts/rk3036-evb.dts b/arch/arm/boot/dts/rk3036-evb.dts
index 2a7e6624efb9..94216f870b57 100644
--- a/arch/arm/boot/dts/rk3036-evb.dts
+++ b/arch/arm/boot/dts/rk3036-evb.dts
@@ -31,11 +31,10 @@ phy0: ethernet-phy@0 {
 &i2c1 {
 	status = "okay";
 
-	hym8563: hym8563@51 {
+	hym8563: rtc@51 {
 		compatible = "haoyu,hym8563";
 		reg = <0x51>;
 		#clock-cells = <0>;
-		clock-frequency = <32768>;
 		clock-output-names = "xin32k";
 	};
 };
diff --git a/arch/arm/boot/dts/rk3066a-mk808.dts b/arch/arm/boot/dts/rk3066a-mk808.dts
index cfa318a506eb..2db5ba706208 100644
--- a/arch/arm/boot/dts/rk3066a-mk808.dts
+++ b/arch/arm/boot/dts/rk3066a-mk808.dts
@@ -32,7 +32,7 @@ adc-keys {
 		keyup-threshold-microvolt = <2500000>;
 		poll-interval = <100>;
 
-		recovery {
+		button-recovery {
 			label = "recovery";
 			linux,code = <KEY_VENDOR>;
 			press-threshold-microvolt = <0>;
diff --git a/arch/arm/boot/dts/rk3188-radxarock.dts b/arch/arm/boot/dts/rk3188-radxarock.dts
index a9ed3cd2c2da..239d2ec37fdc 100644
--- a/arch/arm/boot/dts/rk3188-radxarock.dts
+++ b/arch/arm/boot/dts/rk3188-radxarock.dts
@@ -71,7 +71,7 @@ spdif_out: spdif-out {
 		#sound-dai-cells = <0>;
 	};
 
-	ir_recv: gpio-ir-receiver {
+	ir_recv: ir-receiver {
 		compatible = "gpio-ir-receiver";
 		gpios = <&gpio0 RK_PB2 GPIO_ACTIVE_LOW>;
 		pinctrl-names = "default";
diff --git a/arch/arm/boot/dts/rk3188.dtsi b/arch/arm/boot/dts/rk3188.dtsi
index cdd4a0bd5133..44b54af0bbf9 100644
--- a/arch/arm/boot/dts/rk3188.dtsi
+++ b/arch/arm/boot/dts/rk3188.dtsi
@@ -379,7 +379,7 @@ lcdc1_vsync: lcdc1-vsync {
 				rockchip,pins = <2 RK_PD3 1 &pcfg_pull_none>;
 			};
 
-			lcdc1_rgb24: ldcd1-rgb24 {
+			lcdc1_rgb24: lcdc1-rgb24 {
 				rockchip,pins = <2 RK_PA0 1 &pcfg_pull_none>,
 						<2 RK_PA1 1 &pcfg_pull_none>,
 						<2 RK_PA2 1 &pcfg_pull_none>,
@@ -607,7 +607,6 @@ &emac {
 
 &global_timer {
 	interrupts = <GIC_PPI 11 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_EDGE_RISING)>;
-	status = "disabled";
 };
 
 &local_timer {
diff --git a/arch/arm/boot/dts/rk3288-evb-act8846.dts b/arch/arm/boot/dts/rk3288-evb-act8846.dts
index be695b8c1f67..8a635c243127 100644
--- a/arch/arm/boot/dts/rk3288-evb-act8846.dts
+++ b/arch/arm/boot/dts/rk3288-evb-act8846.dts
@@ -54,7 +54,7 @@ vdd_gpu: syr828@41 {
 		vin-supply = <&vcc_sys>;
 	};
 
-	hym8563@51 {
+	rtc@51 {
 		compatible = "haoyu,hym8563";
 		reg = <0x51>;
 
diff --git a/arch/arm/boot/dts/rk3288-evb.dtsi b/arch/arm/boot/dts/rk3288-evb.dtsi
index 399d6b9c5fd4..382d2839cf47 100644
--- a/arch/arm/boot/dts/rk3288-evb.dtsi
+++ b/arch/arm/boot/dts/rk3288-evb.dtsi
@@ -28,19 +28,19 @@ button-down {
 			press-threshold-microvolt = <300000>;
 		};
 
-		menu {
+		button-menu {
 			label = "Menu";
 			linux,code = <KEY_MENU>;
 			press-threshold-microvolt = <640000>;
 		};
 
-		esc {
+		button-esc {
 			label = "Esc";
 			linux,code = <KEY_ESC>;
 			press-threshold-microvolt = <1000000>;
 		};
 
-		home  {
+		button-home  {
 			label = "Home";
 			linux,code = <KEY_HOME>;
 			press-threshold-microvolt = <1300000>;
diff --git a/arch/arm/boot/dts/rk3288-firefly.dtsi b/arch/arm/boot/dts/rk3288-firefly.dtsi
index 052afe5543e2..3836c61cfb76 100644
--- a/arch/arm/boot/dts/rk3288-firefly.dtsi
+++ b/arch/arm/boot/dts/rk3288-firefly.dtsi
@@ -233,11 +233,10 @@ vdd_gpu: syr828@41 {
 		vin-supply = <&vcc_sys>;
 	};
 
-	hym8563: hym8563@51 {
+	hym8563: rtc@51 {
 		compatible = "haoyu,hym8563";
 		reg = <0x51>;
 		#clock-cells = <0>;
-		clock-frequency = <32768>;
 		clock-output-names = "xin32k";
 		interrupt-parent = <&gpio7>;
 		interrupts = <RK_PA4 IRQ_TYPE_EDGE_FALLING>;
diff --git a/arch/arm/boot/dts/rk3288-miqi.dts b/arch/arm/boot/dts/rk3288-miqi.dts
index 713f55e143c6..db1eb648e0e1 100644
--- a/arch/arm/boot/dts/rk3288-miqi.dts
+++ b/arch/arm/boot/dts/rk3288-miqi.dts
@@ -162,11 +162,10 @@ vdd_gpu: syr828@41 {
 		vin-supply = <&vcc_sys>;
 	};
 
-	hym8563: hym8563@51 {
+	hym8563: rtc@51 {
 		compatible = "haoyu,hym8563";
 		reg = <0x51>;
 		#clock-cells = <0>;
-		clock-frequency = <32768>;
 		clock-output-names = "xin32k";
 	};
 
diff --git a/arch/arm/boot/dts/rk3288-rock2-square.dts b/arch/arm/boot/dts/rk3288-rock2-square.dts
index 80e0f07c8e87..13cfdaa95cc7 100644
--- a/arch/arm/boot/dts/rk3288-rock2-square.dts
+++ b/arch/arm/boot/dts/rk3288-rock2-square.dts
@@ -165,11 +165,10 @@ &hdmi {
 };
 
 &i2c0 {
-	hym8563: hym8563@51 {
+	hym8563: rtc@51 {
 		compatible = "haoyu,hym8563";
 		reg = <0x51>;
 		#clock-cells = <0>;
-		clock-frequency = <32768>;
 		clock-output-names = "xin32k";
 		interrupt-parent = <&gpio0>;
 		interrupts = <RK_PA4 IRQ_TYPE_EDGE_FALLING>;
diff --git a/arch/arm/boot/dts/rk3288-vmarc-som.dtsi b/arch/arm/boot/dts/rk3288-vmarc-som.dtsi
index 0ae2bd150e37..793951655b73 100644
--- a/arch/arm/boot/dts/rk3288-vmarc-som.dtsi
+++ b/arch/arm/boot/dts/rk3288-vmarc-som.dtsi
@@ -241,7 +241,6 @@ hym8563: rtc@51 {
 		interrupt-parent = <&gpio5>;
 		interrupts = <RK_PC3 IRQ_TYPE_LEVEL_LOW>;
 		#clock-cells = <0>;
-		clock-frequency = <32768>;
 		clock-output-names = "hym8563";
 		pinctrl-names = "default";
 		pinctrl-0 = <&hym8563_int>;
diff --git a/arch/arm/boot/dts/rk3xxx.dtsi b/arch/arm/boot/dts/rk3xxx.dtsi
index 616a828e0c6e..17e89d30de78 100644
--- a/arch/arm/boot/dts/rk3xxx.dtsi
+++ b/arch/arm/boot/dts/rk3xxx.dtsi
@@ -76,6 +76,13 @@ global_timer: global-timer@1013c200 {
 		reg = <0x1013c200 0x20>;
 		interrupts = <GIC_PPI 11 (GIC_CPU_MASK_SIMPLE(2) | IRQ_TYPE_EDGE_RISING)>;
 		clocks = <&cru CORE_PERI>;
+		status = "disabled";
+		/* The clock source and the sched_clock provided by the arm_global_timer
+		 * on Rockchip rk3066a/rk3188 are quite unstable because their rates
+		 * depend on the CPU frequency.
+		 * Keep the arm_global_timer disabled in order to have the
+		 * DW_APB_TIMER (rk3066a) or ROCKCHIP_TIMER (rk3188) selected by default.
+		 */
 	};
 
 	local_timer: local-timer@1013c600 {
diff --git a/arch/arm/include/asm/perf_event.h b/arch/arm/include/asm/perf_event.h
index fe87397c3d8c..bdbc1e590891 100644
--- a/arch/arm/include/asm/perf_event.h
+++ b/arch/arm/include/asm/perf_event.h
@@ -17,7 +17,7 @@ extern unsigned long perf_misc_flags(struct pt_regs *regs);
 
 #define perf_arch_fetch_caller_regs(regs, __ip) { \
 	(regs)->ARM_pc = (__ip); \
-	(regs)->ARM_fp = (unsigned long) __builtin_frame_address(0); \
+	frame_pointer((regs)) = (unsigned long) __builtin_frame_address(0); \
 	(regs)->ARM_sp = current_stack_pointer; \
 	(regs)->ARM_cpsr = SVC_MODE; \
 }
diff --git a/arch/arm/include/asm/pgtable-nommu.h b/arch/arm/include/asm/pgtable-nommu.h
index d16aba48fa0a..090011394477 100644
--- a/arch/arm/include/asm/pgtable-nommu.h
+++ b/arch/arm/include/asm/pgtable-nommu.h
@@ -44,12 +44,6 @@
 
 typedef pte_t *pte_addr_t;
 
-/*
- * ZERO_PAGE is a global shared page that is always zero: used
- * for zero-mapped memory areas etc..
- */
-#define ZERO_PAGE(vaddr)	(virt_to_page(0))
-
 /*
  * Mark the prot value as uncacheable and unbufferable.
  */
diff --git a/arch/arm/include/asm/pgtable.h b/arch/arm/include/asm/pgtable.h
index 78a532068fec..ef48a55e9af8 100644
--- a/arch/arm/include/asm/pgtable.h
+++ b/arch/arm/include/asm/pgtable.h
@@ -10,6 +10,15 @@
 #include <linux/const.h>
 #include <asm/proc-fns.h>
 
+#ifndef __ASSEMBLY__
+/*
+ * ZERO_PAGE is a global shared page that is always zero: used
+ * for zero-mapped memory areas etc..
+ */
+extern struct page *empty_zero_page;
+#define ZERO_PAGE(vaddr)	(empty_zero_page)
+#endif
+
 #ifndef CONFIG_MMU
 
 #include <asm-generic/pgtable-nopud.h>
@@ -139,13 +148,6 @@ extern pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
  */
 
 #ifndef __ASSEMBLY__
-/*
- * ZERO_PAGE is a global shared page that is always zero: used
- * for zero-mapped memory areas etc..
- */
-extern struct page *empty_zero_page;
-#define ZERO_PAGE(vaddr)	(empty_zero_page)
-
 
 extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
 
diff --git a/arch/arm/mach-at91/sama5.c b/arch/arm/mach-at91/sama5.c
index 67ed68fbe3a5..bf2b5c6a18c6 100644
--- a/arch/arm/mach-at91/sama5.c
+++ b/arch/arm/mach-at91/sama5.c
@@ -26,7 +26,7 @@ static void sama5_l2c310_write_sec(unsigned long val, unsigned reg)
 static void __init sama5_secure_cache_init(void)
 {
 	sam_secure_init();
-	if (sam_linux_is_optee_available())
+	if (IS_ENABLED(CONFIG_OUTER_CACHE) && sam_linux_is_optee_available())
 		outer_cache.write_sec = sama5_l2c310_write_sec;
 }
 
diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
index 46cccd6bf705..de988cba9a4b 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -105,6 +105,19 @@ static inline bool is_write_fault(unsigned int fsr)
 	return (fsr & FSR_WRITE) && !(fsr & FSR_CM);
 }
 
+static inline bool is_translation_fault(unsigned int fsr)
+{
+	int fs = fsr_fs(fsr);
+#ifdef CONFIG_ARM_LPAE
+	if ((fs & FS_MMU_NOLL_MASK) == FS_TRANS_NOLL)
+		return true;
+#else
+	if (fs == FS_L1_TRANS || fs == FS_L2_TRANS)
+		return true;
+#endif
+	return false;
+}
+
 static void die_kernel_fault(const char *msg, struct mm_struct *mm,
 			     unsigned long addr, unsigned int fsr,
 			     struct pt_regs *regs)
@@ -140,7 +153,8 @@ __do_kernel_fault(struct mm_struct *mm, unsigned long addr, unsigned int fsr,
 	if (addr < PAGE_SIZE) {
 		msg = "NULL pointer dereference";
 	} else {
-		if (kfence_handle_page_fault(addr, is_write_fault(fsr), regs))
+		if (is_translation_fault(fsr) &&
+		    kfence_handle_page_fault(addr, is_write_fault(fsr), regs))
 			return;
 
 		msg = "paging request";
@@ -208,7 +222,7 @@ static inline bool is_permission_fault(unsigned int fsr)
 {
 	int fs = fsr_fs(fsr);
 #ifdef CONFIG_ARM_LPAE
-	if ((fs & FS_PERM_NOLL_MASK) == FS_PERM_NOLL)
+	if ((fs & FS_MMU_NOLL_MASK) == FS_PERM_NOLL)
 		return true;
 #else
 	if (fs == FS_L1_PERM || fs == FS_L2_PERM)
diff --git a/arch/arm/mm/fault.h b/arch/arm/mm/fault.h
index 83b5ab32d7a4..54927ba1fa6e 100644
--- a/arch/arm/mm/fault.h
+++ b/arch/arm/mm/fault.h
@@ -14,8 +14,9 @@
 
 #ifdef CONFIG_ARM_LPAE
 #define FSR_FS_AEA		17
+#define FS_TRANS_NOLL		0x4
 #define FS_PERM_NOLL		0xC
-#define FS_PERM_NOLL_MASK	0x3C
+#define FS_MMU_NOLL_MASK	0x3C
 
 static inline int fsr_fs(unsigned int fsr)
 {
@@ -23,8 +24,10 @@ static inline int fsr_fs(unsigned int fsr)
 }
 #else
 #define FSR_FS_AEA		22
-#define FS_L1_PERM             0xD
-#define FS_L2_PERM             0xF
+#define FS_L1_TRANS		0x5
+#define FS_L2_TRANS		0x7
+#define FS_L1_PERM		0xD
+#define FS_L2_PERM		0xF
 
 static inline int fsr_fs(unsigned int fsr)
 {
diff --git a/arch/arm/mm/nommu.c b/arch/arm/mm/nommu.c
index c42debaded95..c1494a4dee25 100644
--- a/arch/arm/mm/nommu.c
+++ b/arch/arm/mm/nommu.c
@@ -26,6 +26,13 @@
 
 unsigned long vectors_base;
 
+/*
+ * empty_zero_page is a special page that is used for
+ * zero-initialized data and COW.
+ */
+struct page *empty_zero_page;
+EXPORT_SYMBOL(empty_zero_page);
+
 #ifdef CONFIG_ARM_MPU
 struct mpu_rgn_info mpu_rgn_info;
 #endif
@@ -148,9 +155,21 @@ void __init adjust_lowmem_bounds(void)
  */
 void __init paging_init(const struct machine_desc *mdesc)
 {
+	void *zero_page;
+
 	early_trap_init((void *)vectors_base);
 	mpu_setup();
+
+	/* allocate the zero page. */
+	zero_page = memblock_alloc(PAGE_SIZE, PAGE_SIZE);
+	if (!zero_page)
+		panic("%s: Failed to allocate %lu bytes align=0x%lx\n",
+		      __func__, PAGE_SIZE, PAGE_SIZE);
+
 	bootmem_init();
+
+	empty_zero_page = virt_to_page(zero_page);
+	flush_dcache_page(empty_zero_page);
 }
 
 /*
diff --git a/arch/arm64/boot/dts/rockchip/px30-evb.dts b/arch/arm64/boot/dts/rockchip/px30-evb.dts
index 848bc39cf86a..4249b42843da 100644
--- a/arch/arm64/boot/dts/rockchip/px30-evb.dts
+++ b/arch/arm64/boot/dts/rockchip/px30-evb.dts
@@ -30,31 +30,31 @@ adc-keys {
 		keyup-threshold-microvolt = <1800000>;
 		poll-interval = <100>;
 
-		esc-key {
+		button-esc {
 			label = "esc";
 			linux,code = <KEY_ESC>;
 			press-threshold-microvolt = <1310000>;
 		};
 
-		home-key {
+		button-home {
 			label = "home";
 			linux,code = <KEY_HOME>;
 			press-threshold-microvolt = <624000>;
 		};
 
-		menu-key {
+		button-menu {
 			label = "menu";
 			linux,code = <KEY_MENU>;
 			press-threshold-microvolt = <987000>;
 		};
 
-		vol-down-key {
+		button-down {
 			label = "volume down";
 			linux,code = <KEY_VOLUMEDOWN>;
 			press-threshold-microvolt = <300000>;
 		};
 
-		vol-up-key {
+		button-up {
 			label = "volume up";
 			linux,code = <KEY_VOLUMEUP>;
 			press-threshold-microvolt = <17000>;
diff --git a/arch/arm64/boot/dts/rockchip/rk3308-evb.dts b/arch/arm64/boot/dts/rockchip/rk3308-evb.dts
index 9fe9b0d11003..184b84fdde07 100644
--- a/arch/arm64/boot/dts/rockchip/rk3308-evb.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3308-evb.dts
@@ -23,7 +23,7 @@ adc-keys0 {
 		poll-interval = <100>;
 		keyup-threshold-microvolt = <1800000>;
 
-		func-key {
+		button-func {
 			linux,code = <KEY_FN>;
 			label = "function";
 			press-threshold-microvolt = <18000>;
@@ -37,31 +37,31 @@ adc-keys1 {
 		poll-interval = <100>;
 		keyup-threshold-microvolt = <1800000>;
 
-		esc-key {
+		button-esc {
 			linux,code = <KEY_MICMUTE>;
 			label = "micmute";
 			press-threshold-microvolt = <1130000>;
 		};
 
-		home-key {
+		button-home {
 			linux,code = <KEY_MODE>;
 			label = "mode";
 			press-threshold-microvolt = <901000>;
 		};
 
-		menu-key {
+		button-menu {
 			linux,code = <KEY_PLAY>;
 			label = "play";
 			press-threshold-microvolt = <624000>;
 		};
 
-		vol-down-key {
+		button-down {
 			linux,code = <KEY_VOLUMEDOWN>;
 			label = "volume down";
 			press-threshold-microvolt = <300000>;
 		};
 
-		vol-up-key {
+		button-up {
 			linux,code = <KEY_VOLUMEUP>;
 			label = "volume up";
 			press-threshold-microvolt = <18000>;
diff --git a/arch/arm64/boot/dts/rockchip/rk3308-roc-cc.dts b/arch/arm64/boot/dts/rockchip/rk3308-roc-cc.dts
index ea6820902ede..7ea48167747c 100644
--- a/arch/arm64/boot/dts/rockchip/rk3308-roc-cc.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3308-roc-cc.dts
@@ -19,7 +19,7 @@ chosen {
 		stdout-path = "serial2:1500000n8";
 	};
 
-	ir_rx {
+	ir-receiver {
 		compatible = "gpio-ir-receiver";
 		gpios = <&gpio0 RK_PC0 GPIO_ACTIVE_HIGH>;
 		pinctrl-names = "default";
diff --git a/arch/arm64/boot/dts/rockchip/rk3318-a95x-z2.dts b/arch/arm64/boot/dts/rockchip/rk3318-a95x-z2.dts
index 43c928ac98f0..1deef53a4c94 100644
--- a/arch/arm64/boot/dts/rockchip/rk3318-a95x-z2.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3318-a95x-z2.dts
@@ -25,7 +25,7 @@ adc-keys {
 		keyup-threshold-microvolt = <1800000>;
 		poll-interval = <100>;
 
-		recovery {
+		button-recovery {
 			label = "recovery";
 			linux,code = <KEY_VENDOR>;
 			press-threshold-microvolt = <17000>;
diff --git a/arch/arm64/boot/dts/rockchip/rk3368-orion-r68-meta.dts b/arch/arm64/boot/dts/rockchip/rk3368-orion-r68-meta.dts
index 7f5bba0c6001..0e88e9592c1c 100644
--- a/arch/arm64/boot/dts/rockchip/rk3368-orion-r68-meta.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3368-orion-r68-meta.dts
@@ -208,7 +208,7 @@ vdd_cpu: syr827@40 {
 		vin-supply = <&vcc_sys>;
 	};
 
-	hym8563: hym8563@51 {
+	hym8563: rtc@51 {
 		compatible = "haoyu,hym8563";
 		reg = <0x51>;
 		#clock-cells = <0>;
diff --git a/arch/arm64/boot/dts/rockchip/rk3368-r88.dts b/arch/arm64/boot/dts/rockchip/rk3368-r88.dts
index 38d757c00548..e147d6f8b43e 100644
--- a/arch/arm64/boot/dts/rockchip/rk3368-r88.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3368-r88.dts
@@ -192,7 +192,7 @@ vdd_cpu: syr827@40 {
 		vin-supply = <&vcc_sys>;
 	};
 
-	hym8563: hym8563@51 {
+	hym8563: rtc@51 {
 		compatible = "haoyu,hym8563";
 		reg = <0x51>;
 		#clock-cells = <0>;
diff --git a/arch/arm64/boot/dts/rockchip/rk3399-khadas-edge.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-khadas-edge.dtsi
index 2a332763c35c..9d9297bc5f04 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-khadas-edge.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-khadas-edge.dtsi
@@ -123,7 +123,7 @@ adc-keys {
 		keyup-threshold-microvolt = <1800000>;
 		poll-interval = <100>;
 
-		recovery {
+		button-recovery {
 			label = "Recovery";
 			linux,code = <KEY_VENDOR>;
 			press-threshold-microvolt = <18000>;
diff --git a/arch/arm64/boot/dts/rockchip/rk3399-nanopc-t4.dts b/arch/arm64/boot/dts/rockchip/rk3399-nanopc-t4.dts
index 452728b82e42..3bf8f959e42c 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-nanopc-t4.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-nanopc-t4.dts
@@ -39,7 +39,7 @@ adc-keys {
 		keyup-threshold-microvolt = <1800000>;
 		poll-interval = <100>;
 
-		recovery {
+		button-recovery {
 			label = "Recovery";
 			linux,code = <KEY_VENDOR>;
 			press-threshold-microvolt = <18000>;
diff --git a/arch/arm64/boot/dts/rockchip/rk3399-nanopi-m4b.dts b/arch/arm64/boot/dts/rockchip/rk3399-nanopi-m4b.dts
index 72182c58cc46..65cb21837b0c 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-nanopi-m4b.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-nanopi-m4b.dts
@@ -19,7 +19,7 @@ adc-keys {
 		keyup-threshold-microvolt = <1500000>;
 		poll-interval = <100>;
 
-		recovery {
+		button-recovery {
 			label = "Recovery";
 			linux,code = <KEY_VENDOR>;
 			press-threshold-microvolt = <18000>;
diff --git a/arch/arm64/boot/dts/rockchip/rk3399-orangepi.dts b/arch/arm64/boot/dts/rockchip/rk3399-orangepi.dts
index 9e2e246e0bab..dba4d03bfc2b 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-orangepi.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-orangepi.dts
@@ -52,13 +52,13 @@ button-down {
 			press-threshold-microvolt = <300000>;
 		};
 
-		back {
+		button-back {
 			label = "Back";
 			linux,code = <KEY_BACK>;
 			press-threshold-microvolt = <985000>;
 		};
 
-		menu {
+		button-menu {
 			label = "Menu";
 			linux,code = <KEY_MENU>;
 			press-threshold-microvolt = <1314000>;
diff --git a/arch/arm64/boot/dts/rockchip/rk3399-roc-pc-plus.dts b/arch/arm64/boot/dts/rockchip/rk3399-roc-pc-plus.dts
index 5a2661ae0131..18b5050c6cd3 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-roc-pc-plus.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-roc-pc-plus.dts
@@ -98,7 +98,7 @@ &fusb0 {
 };
 
 &i2c0 {
-	hym8563: hym8563@51 {
+	hym8563: rtc@51 {
 		compatible = "haoyu,hym8563";
 		reg = <0x51>;
 		interrupt-parent = <&gpio0>;
diff --git a/arch/arm64/boot/dts/rockchip/rk3399-roc-pc.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-roc-pc.dtsi
index acb174d3a8c5..4f3dd107e83e 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-roc-pc.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-roc-pc.dtsi
@@ -41,7 +41,7 @@ adc-keys {
 		keyup-threshold-microvolt = <1500000>;
 		poll-interval = <100>;
 
-		recovery {
+		button-recovery {
 			label = "Recovery";
 			linux,code = <KEY_VENDOR>;
 			press-threshold-microvolt = <18000>;
diff --git a/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dtsi
index 401e1ae9d944..b045f74071e4 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dtsi
@@ -491,7 +491,6 @@ i2s0_p0_0: endpoint {
 &i2s1 {
 	rockchip,playback-channels = <2>;
 	rockchip,capture-channels = <2>;
-	status = "okay";
 };
 
 &i2s2 {
diff --git a/arch/arm64/boot/dts/rockchip/rk3399-sapphire-excavator.dts b/arch/arm64/boot/dts/rockchip/rk3399-sapphire-excavator.dts
index 13927e7d0724..dbec2b7173a0 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-sapphire-excavator.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-sapphire-excavator.dts
@@ -33,13 +33,13 @@ button-down {
 			press-threshold-microvolt = <300000>;
 		};
 
-		back {
+		button-back {
 			label = "Back";
 			linux,code = <KEY_BACK>;
 			press-threshold-microvolt = <985000>;
 		};
 
-		menu {
+		button-menu {
 			label = "Menu";
 			linux,code = <KEY_MENU>;
 			press-threshold-microvolt = <1314000>;
diff --git a/arch/arm64/boot/dts/rockchip/rk3399pro-vmarc-som.dtsi b/arch/arm64/boot/dts/rockchip/rk3399pro-vmarc-som.dtsi
index 935b8c68a71d..6c168566321b 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399pro-vmarc-som.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399pro-vmarc-som.dtsi
@@ -297,7 +297,7 @@ &i2c2 {
 	clock-frequency = <400000>;
 	status = "okay";
 
-	hym8563: hym8563@51 {
+	hym8563: rtc@51 {
 		compatible = "haoyu,hym8563";
 		reg = <0x51>;
 		#clock-cells = <0>;
diff --git a/arch/arm64/boot/dts/rockchip/rk3566-pinenote.dtsi b/arch/arm64/boot/dts/rockchip/rk3566-pinenote.dtsi
index 0d45868132b9..8d61f824c12d 100644
--- a/arch/arm64/boot/dts/rockchip/rk3566-pinenote.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3566-pinenote.dtsi
@@ -23,7 +23,7 @@ adc-keys {
 		io-channel-names = "buttons";
 		keyup-threshold-microvolt = <1750000>;
 
-		recovery {
+		button-recovery {
 			label = "recovery";
 			linux,code = <KEY_VENDOR>;
 			press-threshold-microvolt = <0>;
diff --git a/arch/arm64/boot/dts/rockchip/rk3566-roc-pc.dts b/arch/arm64/boot/dts/rockchip/rk3566-roc-pc.dts
index 57759b66d44d..ab1abf0bb749 100644
--- a/arch/arm64/boot/dts/rockchip/rk3566-roc-pc.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3566-roc-pc.dts
@@ -130,7 +130,7 @@ &gmac1 {
 	assigned-clocks = <&cru SCLK_GMAC1_RX_TX>, <&cru SCLK_GMAC1_RGMII_SPEED>, <&cru SCLK_GMAC1>;
 	assigned-clock-parents = <&cru SCLK_GMAC1_RGMII_SPEED>, <&cru SCLK_GMAC1>, <&gmac1_clkin>;
 	clock_in_out = "input";
-	phy-mode = "rgmii-id";
+	phy-mode = "rgmii";
 	phy-supply = <&vcc_3v3>;
 	pinctrl-names = "default";
 	pinctrl-0 = <&gmac1m0_miim
@@ -397,11 +397,7 @@ &i2c2 {
 
 &i2c3 {
 	pinctrl-names = "default";
-	pinctrl-0 = <&i2c3m1_xfer>;
-	status = "okay";
-};
-
-&i2c5 {
+	pinctrl-0 = <&i2c3m0_xfer>;
 	status = "okay";
 };
 
diff --git a/arch/loongarch/Makefile b/arch/loongarch/Makefile
index ec3de6191276..9123feb69854 100644
--- a/arch/loongarch/Makefile
+++ b/arch/loongarch/Makefile
@@ -68,7 +68,7 @@ KBUILD_LDFLAGS	+= -m $(ld-emul)
 
 ifdef CONFIG_LOONGARCH
 CHECKFLAGS += $(shell $(CC) $(KBUILD_CFLAGS) -dM -E -x c /dev/null | \
-	egrep -vw '__GNUC_(MINOR_|PATCHLEVEL_)?_' | \
+	grep -E -vw '__GNUC_(MINOR_|PATCHLEVEL_)?_' | \
 	sed -e "s/^\#define /-D'/" -e "s/ /'='/" -e "s/$$/'/" -e 's/\$$/&&/g')
 endif
 
diff --git a/arch/loongarch/include/asm/pgtable.h b/arch/loongarch/include/asm/pgtable.h
index cc0674d1b8f0..645e24ebec68 100644
--- a/arch/loongarch/include/asm/pgtable.h
+++ b/arch/loongarch/include/asm/pgtable.h
@@ -357,7 +357,9 @@ static inline pte_t pte_mkdirty(pte_t pte)
 
 static inline pte_t pte_mkwrite(pte_t pte)
 {
-	pte_val(pte) |= (_PAGE_WRITE | _PAGE_DIRTY);
+	pte_val(pte) |= _PAGE_WRITE;
+	if (pte_val(pte) & _PAGE_MODIFIED)
+		pte_val(pte) |= _PAGE_DIRTY;
 	return pte;
 }
 
@@ -454,7 +456,9 @@ static inline int pmd_write(pmd_t pmd)
 
 static inline pmd_t pmd_mkwrite(pmd_t pmd)
 {
-	pmd_val(pmd) |= (_PAGE_WRITE | _PAGE_DIRTY);
+	pmd_val(pmd) |= _PAGE_WRITE;
+	if (pmd_val(pmd) & _PAGE_MODIFIED)
+		pmd_val(pmd) |= _PAGE_DIRTY;
 	return pmd;
 }
 
diff --git a/arch/loongarch/kernel/acpi.c b/arch/loongarch/kernel/acpi.c
index 335398482038..8319cc409009 100644
--- a/arch/loongarch/kernel/acpi.c
+++ b/arch/loongarch/kernel/acpi.c
@@ -56,23 +56,6 @@ void __iomem *acpi_os_ioremap(acpi_physical_address phys, acpi_size size)
 		return ioremap_cache(phys, size);
 }
 
-void __init acpi_boot_table_init(void)
-{
-	/*
-	 * If acpi_disabled, bail out
-	 */
-	if (acpi_disabled)
-		return;
-
-	/*
-	 * Initialize the ACPI boot-time table parser.
-	 */
-	if (acpi_table_init()) {
-		disable_acpi();
-		return;
-	}
-}
-
 #ifdef CONFIG_SMP
 static int set_processor_mask(u32 id, u32 flags)
 {
@@ -156,13 +139,21 @@ static void __init acpi_process_madt(void)
 	loongson_sysconf.nr_cpus = num_processors;
 }
 
-int __init acpi_boot_init(void)
+void __init acpi_boot_table_init(void)
 {
 	/*
 	 * If acpi_disabled, bail out
 	 */
 	if (acpi_disabled)
-		return -1;
+		return;
+
+	/*
+	 * Initialize the ACPI boot-time table parser.
+	 */
+	if (acpi_table_init()) {
+		disable_acpi();
+		return;
+	}
 
 	loongson_sysconf.boot_cpu_id = read_csr_cpuid();
 
@@ -173,8 +164,6 @@ int __init acpi_boot_init(void)
 
 	/* Do not enable ACPI SPCR console by default */
 	acpi_parse_spcr(earlycon_acpi_spcr_enable, false);
-
-	return 0;
 }
 
 #ifdef CONFIG_ACPI_NUMA
diff --git a/arch/loongarch/kernel/setup.c b/arch/loongarch/kernel/setup.c
index 8f5c2f9a1a83..574647e3483d 100644
--- a/arch/loongarch/kernel/setup.c
+++ b/arch/loongarch/kernel/setup.c
@@ -203,7 +203,6 @@ void __init platform_init(void)
 #ifdef CONFIG_ACPI
 	acpi_gbl_use_default_register_widths = false;
 	acpi_boot_table_init();
-	acpi_boot_init();
 #endif
 
 #ifdef CONFIG_NUMA
diff --git a/arch/loongarch/kernel/unwind_prologue.c b/arch/loongarch/kernel/unwind_prologue.c
index b206d9159205..4571c3c87cd4 100644
--- a/arch/loongarch/kernel/unwind_prologue.c
+++ b/arch/loongarch/kernel/unwind_prologue.c
@@ -43,7 +43,8 @@ static bool unwind_by_prologue(struct unwind_state *state)
 {
 	struct stack_info *info = &state->stack_info;
 	union loongarch_instruction *ip, *ip_end;
-	unsigned long frame_size = 0, frame_ra = -1;
+	long frame_ra = -1;
+	unsigned long frame_size = 0;
 	unsigned long size, offset, pc = state->pc;
 
 	if (state->sp >= info->end || state->sp < info->begin)
diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index 94138f8f0c1c..ace2541ababd 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -546,8 +546,10 @@ static int shadow_scb(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 	if (test_kvm_cpu_feat(vcpu->kvm, KVM_S390_VM_CPU_FEAT_CEI))
 		scb_s->eca |= scb_o->eca & ECA_CEI;
 	/* Epoch Extension */
-	if (test_kvm_facility(vcpu->kvm, 139))
+	if (test_kvm_facility(vcpu->kvm, 139)) {
 		scb_s->ecd |= scb_o->ecd & ECD_MEF;
+		scb_s->epdx = scb_o->epdx;
+	}
 
 	/* etoken */
 	if (test_kvm_facility(vcpu->kvm, 156))
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 1bb46cbff0fa..882b5893f910 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -2042,6 +2042,11 @@ static int btusb_setup_csr(struct hci_dev *hdev)
 
 	rp = (struct hci_rp_read_local_version *)skb->data;
 
+	bt_dev_info(hdev, "CSR: Setting up dongle with HCI ver=%u rev=%04x; LMP ver=%u subver=%04x; manufacturer=%u",
+		le16_to_cpu(rp->hci_ver), le16_to_cpu(rp->hci_rev),
+		le16_to_cpu(rp->lmp_ver), le16_to_cpu(rp->lmp_subver),
+		le16_to_cpu(rp->manufacturer));
+
 	/* Detect a wide host of Chinese controllers that aren't CSR.
 	 *
 	 * Known fake bcdDevices: 0x0100, 0x0134, 0x1915, 0x2520, 0x7558, 0x8891
@@ -2104,6 +2109,7 @@ static int btusb_setup_csr(struct hci_dev *hdev)
 		 * without these the controller will lock up.
 		 */
 		set_bit(HCI_QUIRK_BROKEN_STORED_LINK_KEY, &hdev->quirks);
+		set_bit(HCI_QUIRK_BROKEN_ERR_DATA_REPORTING, &hdev->quirks);
 		set_bit(HCI_QUIRK_BROKEN_FILTER_CLEAR_ALL, &hdev->quirks);
 		set_bit(HCI_QUIRK_NO_SUSPEND_NOTIFIER, &hdev->quirks);
 
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 6c49e6d06114..034a74196a82 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -748,6 +748,11 @@ static int sev_update_firmware(struct device *dev)
 	struct page *p;
 	u64 data_size;
 
+	if (!sev_version_greater_or_equal(0, 15)) {
+		dev_dbg(dev, "DOWNLOAD_FIRMWARE not supported\n");
+		return -1;
+	}
+
 	if (sev_get_firmware(dev, &firmware) == -ENOENT) {
 		dev_dbg(dev, "No SEV firmware file present\n");
 		return -1;
@@ -780,6 +785,14 @@ static int sev_update_firmware(struct device *dev)
 	data->len = firmware->size;
 
 	ret = sev_do_cmd(SEV_CMD_DOWNLOAD_FIRMWARE, data, &error);
+
+	/*
+	 * A quirk for fixing the committed TCB version, when upgrading from
+	 * earlier firmware version than 1.50.
+	 */
+	if (!ret && !sev_version_greater_or_equal(1, 50))
+		ret = sev_do_cmd(SEV_CMD_DOWNLOAD_FIRMWARE, data, &error);
+
 	if (ret)
 		dev_dbg(dev, "Failed to update SEV firmware: %#x\n", error);
 	else
@@ -1289,8 +1302,7 @@ void sev_pci_init(void)
 	if (sev_get_api_version())
 		goto err;
 
-	if (sev_version_greater_or_equal(0, 15) &&
-	    sev_update_firmware(sev->dev) == 0)
+	if (sev_update_firmware(sev->dev) == 0)
 		sev_get_api_version();
 
 	/* If an init_ex_path is provided rely on INIT_EX for PSP initialization
diff --git a/drivers/gpio/gpio-amd8111.c b/drivers/gpio/gpio-amd8111.c
index 14e6b3e64add..6f3ded619c8b 100644
--- a/drivers/gpio/gpio-amd8111.c
+++ b/drivers/gpio/gpio-amd8111.c
@@ -226,7 +226,10 @@ static int __init amd_gpio_init(void)
 		ioport_unmap(gp.pm);
 		goto out;
 	}
+	return 0;
+
 out:
+	pci_dev_put(pdev);
 	return err;
 }
 
@@ -234,6 +237,7 @@ static void __exit amd_gpio_exit(void)
 {
 	gpiochip_remove(&gp.chip);
 	ioport_unmap(gp.pm);
+	pci_dev_put(gp.pdev);
 }
 
 module_init(amd_gpio_init);
diff --git a/drivers/gpio/gpio-rockchip.c b/drivers/gpio/gpio-rockchip.c
index 9c976ad7208e..09cfb49ed998 100644
--- a/drivers/gpio/gpio-rockchip.c
+++ b/drivers/gpio/gpio-rockchip.c
@@ -621,6 +621,7 @@ static int rockchip_gpiolib_register(struct rockchip_pin_bank *bank)
 			return -ENODATA;
 
 		pctldev = of_pinctrl_get(pctlnp);
+		of_node_put(pctlnp);
 		if (!pctldev)
 			return -ENODEV;
 
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index cc9c0a12259e..eb7d00608c7f 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -526,12 +526,13 @@ static int gpiochip_setup_dev(struct gpio_device *gdev)
 	if (ret)
 		return ret;
 
+	/* From this point, the .release() function cleans up gpio_device */
+	gdev->dev.release = gpiodevice_release;
+
 	ret = gpiochip_sysfs_register(gdev);
 	if (ret)
 		goto err_remove_device;
 
-	/* From this point, the .release() function cleans up gpio_device */
-	gdev->dev.release = gpiodevice_release;
 	dev_dbg(&gdev->dev, "registered GPIOs %d to %d on %s\n", gdev->base,
 		gdev->base + gdev->ngpio - 1, gdev->chip->label ? : "generic");
 
@@ -597,10 +598,10 @@ int gpiochip_add_data_with_key(struct gpio_chip *gc, void *data,
 	struct fwnode_handle *fwnode = NULL;
 	struct gpio_device *gdev;
 	unsigned long flags;
-	int base = gc->base;
 	unsigned int i;
+	u32 ngpios = 0;
+	int base = 0;
 	int ret = 0;
-	u32 ngpios;
 
 	if (gc->fwnode)
 		fwnode = gc->fwnode;
@@ -647,17 +648,12 @@ int gpiochip_add_data_with_key(struct gpio_chip *gc, void *data,
 	else
 		gdev->owner = THIS_MODULE;
 
-	gdev->descs = kcalloc(gc->ngpio, sizeof(gdev->descs[0]), GFP_KERNEL);
-	if (!gdev->descs) {
-		ret = -ENOMEM;
-		goto err_free_dev_name;
-	}
-
 	/*
 	 * Try the device properties if the driver didn't supply the number
 	 * of GPIO lines.
 	 */
-	if (gc->ngpio == 0) {
+	ngpios = gc->ngpio;
+	if (ngpios == 0) {
 		ret = device_property_read_u32(&gdev->dev, "ngpios", &ngpios);
 		if (ret == -ENODATA)
 			/*
@@ -668,7 +664,7 @@ int gpiochip_add_data_with_key(struct gpio_chip *gc, void *data,
 			 */
 			ngpios = 0;
 		else if (ret)
-			goto err_free_descs;
+			goto err_free_dev_name;
 
 		gc->ngpio = ngpios;
 	}
@@ -676,13 +672,19 @@ int gpiochip_add_data_with_key(struct gpio_chip *gc, void *data,
 	if (gc->ngpio == 0) {
 		chip_err(gc, "tried to insert a GPIO chip with zero lines\n");
 		ret = -EINVAL;
-		goto err_free_descs;
+		goto err_free_dev_name;
 	}
 
 	if (gc->ngpio > FASTPATH_NGPIO)
 		chip_warn(gc, "line cnt %u is greater than fast path cnt %u\n",
 			  gc->ngpio, FASTPATH_NGPIO);
 
+	gdev->descs = kcalloc(gc->ngpio, sizeof(*gdev->descs), GFP_KERNEL);
+	if (!gdev->descs) {
+		ret = -ENOMEM;
+		goto err_free_dev_name;
+	}
+
 	gdev->label = kstrdup_const(gc->label ?: "unknown", GFP_KERNEL);
 	if (!gdev->label) {
 		ret = -ENOMEM;
@@ -701,11 +703,13 @@ int gpiochip_add_data_with_key(struct gpio_chip *gc, void *data,
 	 * it may be a pipe dream. It will not happen before we get rid
 	 * of the sysfs interface anyways.
 	 */
+	base = gc->base;
 	if (base < 0) {
 		base = gpiochip_find_base(gc->ngpio);
 		if (base < 0) {
-			ret = base;
 			spin_unlock_irqrestore(&gpio_lock, flags);
+			ret = base;
+			base = 0;
 			goto err_free_label;
 		}
 		/*
@@ -816,6 +820,11 @@ int gpiochip_add_data_with_key(struct gpio_chip *gc, void *data,
 err_free_gpiochip_mask:
 	gpiochip_remove_pin_ranges(gc);
 	gpiochip_free_valid_mask(gc);
+	if (gdev->dev.release) {
+		/* release() has been registered by gpiochip_setup_dev() */
+		put_device(&gdev->dev);
+		goto err_print_message;
+	}
 err_remove_from_list:
 	spin_lock_irqsave(&gpio_lock, flags);
 	list_del(&gdev->list);
@@ -829,13 +838,14 @@ int gpiochip_add_data_with_key(struct gpio_chip *gc, void *data,
 err_free_ida:
 	ida_free(&gpio_ida, gdev->id);
 err_free_gdev:
+	kfree(gdev);
+err_print_message:
 	/* failures here can mean systems won't boot... */
 	if (ret != -EPROBE_DEFER) {
 		pr_err("%s: GPIOs %d..%d (%s) failed to register, %d\n", __func__,
-		       gdev->base, gdev->base + gdev->ngpio - 1,
+		       base, base + (int)ngpios - 1,
 		       gc->label ? : "generic", ret);
 	}
-	kfree(gdev);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(gpiochip_add_data_with_key);
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
index 3b025aace283..eb4c0523e42d 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
@@ -167,7 +167,11 @@ static void amdgpu_job_free_cb(struct drm_sched_job *s_job)
 	amdgpu_sync_free(&job->sync);
 	amdgpu_sync_free(&job->sched_sync);
 
-	dma_fence_put(&job->hw_fence);
+	/* only put the hw fence if has embedded fence */
+	if (!job->hw_fence.ops)
+		kfree(job);
+	else
+		dma_fence_put(&job->hw_fence);
 }
 
 void amdgpu_job_free(struct amdgpu_job *job)
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h
index 60c608144480..ecb8db731081 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h
@@ -161,6 +161,7 @@
 #define AMDGPU_VCN_SW_RING_FLAG		(1 << 9)
 #define AMDGPU_VCN_FW_LOGGING_FLAG	(1 << 10)
 #define AMDGPU_VCN_SMU_VERSION_INFO_FLAG (1 << 11)
+#define AMDGPU_VCN_SMU_DPM_INTERFACE_FLAG (1 << 11)
 
 #define AMDGPU_VCN_IB_FLAG_DECODE_BUFFER	0x00000001
 #define AMDGPU_VCN_CMD_FLAG_MSG_BUFFER		0x00000001
@@ -170,6 +171,9 @@
 #define VCN_CODEC_DISABLE_MASK_HEVC (1 << 2)
 #define VCN_CODEC_DISABLE_MASK_H264 (1 << 3)
 
+#define AMDGPU_VCN_SMU_DPM_INTERFACE_DGPU (0)
+#define AMDGPU_VCN_SMU_DPM_INTERFACE_APU (1)
+
 enum fw_queue_mode {
 	FW_QUEUE_RING_RESET = 1,
 	FW_QUEUE_DPG_HOLD_OFF = 2,
@@ -323,6 +327,9 @@ struct amdgpu_vcn4_fw_shared {
 	struct amdgpu_fw_shared_unified_queue_struct sq;
 	uint8_t pad1[8];
 	struct amdgpu_fw_shared_fw_logging fw_log;
+	uint8_t pad2[20];
+	uint32_t pad3[13];
+	struct amdgpu_fw_shared_smu_interface_info smu_dpm_interface;
 };
 
 struct amdgpu_vcn_fwlog {
diff --git a/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c b/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
index 65181efba50e..408b0f399cfc 100644
--- a/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
@@ -980,13 +980,13 @@ static void sdma_v4_0_ring_emit_fence(struct amdgpu_ring *ring, u64 addr, u64 se
 
 
 /**
- * sdma_v4_0_gfx_stop - stop the gfx async dma engines
+ * sdma_v4_0_gfx_enable - enable the gfx async dma engines
  *
  * @adev: amdgpu_device pointer
- *
- * Stop the gfx async dma ring buffers (VEGA10).
+ * @enable: enable SDMA RB/IB
+ * control the gfx async dma ring buffers (VEGA10).
  */
-static void sdma_v4_0_gfx_stop(struct amdgpu_device *adev)
+static void sdma_v4_0_gfx_enable(struct amdgpu_device *adev, bool enable)
 {
 	struct amdgpu_ring *sdma[AMDGPU_MAX_SDMA_INSTANCES];
 	u32 rb_cntl, ib_cntl;
@@ -1001,10 +1001,10 @@ static void sdma_v4_0_gfx_stop(struct amdgpu_device *adev)
 		}
 
 		rb_cntl = RREG32_SDMA(i, mmSDMA0_GFX_RB_CNTL);
-		rb_cntl = REG_SET_FIELD(rb_cntl, SDMA0_GFX_RB_CNTL, RB_ENABLE, 0);
+		rb_cntl = REG_SET_FIELD(rb_cntl, SDMA0_GFX_RB_CNTL, RB_ENABLE, enable ? 1 : 0);
 		WREG32_SDMA(i, mmSDMA0_GFX_RB_CNTL, rb_cntl);
 		ib_cntl = RREG32_SDMA(i, mmSDMA0_GFX_IB_CNTL);
-		ib_cntl = REG_SET_FIELD(ib_cntl, SDMA0_GFX_IB_CNTL, IB_ENABLE, 0);
+		ib_cntl = REG_SET_FIELD(ib_cntl, SDMA0_GFX_IB_CNTL, IB_ENABLE, enable ? 1 : 0);
 		WREG32_SDMA(i, mmSDMA0_GFX_IB_CNTL, ib_cntl);
 	}
 }
@@ -1131,7 +1131,7 @@ static void sdma_v4_0_enable(struct amdgpu_device *adev, bool enable)
 	int i;
 
 	if (!enable) {
-		sdma_v4_0_gfx_stop(adev);
+		sdma_v4_0_gfx_enable(adev, enable);
 		sdma_v4_0_rlc_stop(adev);
 		if (adev->sdma.has_page_queue)
 			sdma_v4_0_page_stop(adev);
@@ -2043,8 +2043,10 @@ static int sdma_v4_0_suspend(void *handle)
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
 
 	/* SMU saves SDMA state for us */
-	if (adev->in_s0ix)
+	if (adev->in_s0ix) {
+		sdma_v4_0_gfx_enable(adev, false);
 		return 0;
+	}
 
 	return sdma_v4_0_hw_fini(adev);
 }
@@ -2054,8 +2056,12 @@ static int sdma_v4_0_resume(void *handle)
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
 
 	/* SMU restores SDMA state for us */
-	if (adev->in_s0ix)
+	if (adev->in_s0ix) {
+		sdma_v4_0_enable(adev, true);
+		sdma_v4_0_gfx_enable(adev, true);
+		amdgpu_ttm_set_buffer_funcs_status(adev, true);
 		return 0;
+	}
 
 	return sdma_v4_0_hw_init(adev);
 }
diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
index fb2d74f30448..c5afb5bc9eb6 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
@@ -132,6 +132,10 @@ static int vcn_v4_0_sw_init(void *handle)
 		fw_shared->present_flag_0 = cpu_to_le32(AMDGPU_FW_SHARED_FLAG_0_UNIFIED_QUEUE);
 		fw_shared->sq.is_enabled = 1;
 
+		fw_shared->present_flag_0 |= cpu_to_le32(AMDGPU_VCN_SMU_DPM_INTERFACE_FLAG);
+		fw_shared->smu_dpm_interface.smu_interface_type = (adev->flags & AMD_IS_APU) ?
+			AMDGPU_VCN_SMU_DPM_INTERFACE_APU : AMDGPU_VCN_SMU_DPM_INTERFACE_DGPU;
+
 		if (amdgpu_vcnfw_log)
 			amdgpu_vcn_fwlog_init(&adev->vcn.inst[i]);
 	}
diff --git a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_dccg.c b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_dccg.c
index fb729674953b..de9fa534b77a 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_dccg.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_dccg.c
@@ -96,6 +96,13 @@ static void dccg314_set_pixel_rate_div(
 	struct dcn_dccg *dccg_dcn = TO_DCN_DCCG(dccg);
 	enum pixel_rate_div cur_k1 = PIXEL_RATE_DIV_NA, cur_k2 = PIXEL_RATE_DIV_NA;
 
+	// Don't program 0xF into the register field. Not valid since
+	// K1 / K2 field is only 1 / 2 bits wide
+	if (k1 == PIXEL_RATE_DIV_NA || k2 == PIXEL_RATE_DIV_NA) {
+		BREAK_TO_DEBUGGER();
+		return;
+	}
+
 	dccg314_get_pixel_rate_div(dccg, otg_inst, &cur_k1, &cur_k2);
 	if (k1 == PIXEL_RATE_DIV_NA || k2 == PIXEL_RATE_DIV_NA || (k1 == cur_k1 && k2 == cur_k2))
 		return;
diff --git a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_hwseq.c
index f4d1b83979fe..a0741794db62 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_hwseq.c
@@ -349,6 +349,7 @@ unsigned int dcn314_calculate_dccg_k1_k2_values(struct pipe_ctx *pipe_ctx, unsig
 	odm_combine_factor = get_odm_config(pipe_ctx, NULL);
 
 	if (is_dp_128b_132b_signal(pipe_ctx)) {
+		*k1_div = PIXEL_RATE_DIV_BY_1;
 		*k2_div = PIXEL_RATE_DIV_BY_1;
 	} else if (dc_is_hdmi_tmds_signal(pipe_ctx->stream->signal) || dc_is_dvi_signal(pipe_ctx->stream->signal)) {
 		*k1_div = PIXEL_RATE_DIV_BY_1;
@@ -356,7 +357,7 @@ unsigned int dcn314_calculate_dccg_k1_k2_values(struct pipe_ctx *pipe_ctx, unsig
 			*k2_div = PIXEL_RATE_DIV_BY_2;
 		else
 			*k2_div = PIXEL_RATE_DIV_BY_4;
-	} else if (dc_is_dp_signal(pipe_ctx->stream->signal)) {
+	} else if (dc_is_dp_signal(pipe_ctx->stream->signal) || dc_is_virtual_signal(pipe_ctx->stream->signal)) {
 		if (two_pix_per_container) {
 			*k1_div = PIXEL_RATE_DIV_BY_1;
 			*k2_div = PIXEL_RATE_DIV_BY_2;
diff --git a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_dccg.c b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_dccg.c
index 6640d0ac4304..6dd8dadd68a5 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_dccg.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_dccg.c
@@ -96,8 +96,10 @@ static void dccg32_set_pixel_rate_div(
 
 	// Don't program 0xF into the register field. Not valid since
 	// K1 / K2 field is only 1 / 2 bits wide
-	if (k1 == PIXEL_RATE_DIV_NA || k2 == PIXEL_RATE_DIV_NA)
+	if (k1 == PIXEL_RATE_DIV_NA || k2 == PIXEL_RATE_DIV_NA) {
+		BREAK_TO_DEBUGGER();
 		return;
+	}
 
 	dccg32_get_pixel_rate_div(dccg, otg_inst, &cur_k1, &cur_k2);
 	if (k1 == cur_k1 && k2 == cur_k2)
diff --git a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c
index bbc0bfbec6c4..3128c111c619 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c
@@ -1171,6 +1171,7 @@ unsigned int dcn32_calculate_dccg_k1_k2_values(struct pipe_ctx *pipe_ctx, unsign
 	odm_combine_factor = get_odm_config(pipe_ctx, NULL);
 
 	if (is_dp_128b_132b_signal(pipe_ctx)) {
+		*k1_div = PIXEL_RATE_DIV_BY_1;
 		*k2_div = PIXEL_RATE_DIV_BY_1;
 	} else if (dc_is_hdmi_tmds_signal(pipe_ctx->stream->signal) || dc_is_dvi_signal(pipe_ctx->stream->signal)) {
 		*k1_div = PIXEL_RATE_DIV_BY_1;
diff --git a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource_helpers.c b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource_helpers.c
index 7c37575d69c7..0ef11fb338e9 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource_helpers.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource_helpers.c
@@ -103,7 +103,7 @@ uint32_t dcn32_helper_calculate_num_ways_for_subvp(struct dc *dc, struct dc_stat
 			mall_alloc_width_blk_aligned = full_vp_width_blk_aligned;
 
 			/* mall_alloc_height_blk_aligned_l/c = CEILING(sub_vp_height_l/c - 1, blk_height_l/c) + blk_height_l/c */
-			mall_alloc_height_blk_aligned = (pipe->stream->timing.v_addressable - 1 + mblk_height - 1) /
+			mall_alloc_height_blk_aligned = (pipe->plane_res.scl_data.viewport.height - 1 + mblk_height - 1) /
 					mblk_height * mblk_height + mblk_height;
 
 			/* full_mblk_width_ub_l/c = mall_alloc_width_blk_aligned_l/c;
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
index 2f996fdaa70d..07c56e231b04 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
@@ -1803,7 +1803,7 @@ void dcn32_calculate_wm_and_dlg_fpu(struct dc *dc, struct dc_state *context,
 
 		if (context->bw_ctx.dml.vba.DRAMClockChangeSupport[vlevel][maxMpcComb] ==
 			dm_dram_clock_change_unsupported) {
-			int min_dram_speed_mts_offset = dc->clk_mgr->bw_params->clk_table.num_entries - 1;
+			int min_dram_speed_mts_offset = dc->clk_mgr->bw_params->clk_table.num_entries_per_clk.num_memclk_levels - 1;
 
 			min_dram_speed_mts =
 				dc->clk_mgr->bw_params->clk_table.entries[min_dram_speed_mts_offset].memclk_mhz * 16;
diff --git a/drivers/gpu/drm/amd/display/dc/dml/display_mode_vba.h b/drivers/gpu/drm/amd/display/dc/dml/display_mode_vba.h
index 2051ddaa641a..6ec0947ace9c 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/display_mode_vba.h
+++ b/drivers/gpu/drm/amd/display/dc/dml/display_mode_vba.h
@@ -1152,7 +1152,7 @@ struct vba_vars_st {
 	double UrgBurstFactorLumaPre[DC__NUM_DPP__MAX];
 	double UrgBurstFactorChromaPre[DC__NUM_DPP__MAX];
 	bool NotUrgentLatencyHidingPre[DC__NUM_DPP__MAX];
-	bool LinkCapacitySupport[DC__NUM_DPP__MAX];
+	bool LinkCapacitySupport[DC__VOLTAGE_STATES];
 	bool VREADY_AT_OR_AFTER_VSYNC[DC__NUM_DPP__MAX];
 	unsigned int MIN_DST_Y_NEXT_START[DC__NUM_DPP__MAX];
 	unsigned int VFrontPorch[DC__NUM_DPP__MAX];
diff --git a/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c b/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
index 40d8ca37f5bc..aa51c61a78c7 100644
--- a/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
+++ b/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
@@ -2720,6 +2720,9 @@ static u32 *dw_hdmi_bridge_atomic_get_output_bus_fmts(struct drm_bridge *bridge,
 	 * if supported. In any case the default RGB888 format is added
 	 */
 
+	/* Default 8bit RGB fallback */
+	output_fmts[i++] = MEDIA_BUS_FMT_RGB888_1X24;
+
 	if (max_bpc >= 16 && info->bpc == 16) {
 		if (info->color_formats & DRM_COLOR_FORMAT_YCBCR444)
 			output_fmts[i++] = MEDIA_BUS_FMT_YUV16_1X48;
@@ -2753,9 +2756,6 @@ static u32 *dw_hdmi_bridge_atomic_get_output_bus_fmts(struct drm_bridge *bridge,
 	if (info->color_formats & DRM_COLOR_FORMAT_YCBCR444)
 		output_fmts[i++] = MEDIA_BUS_FMT_YUV8_1X24;
 
-	/* Default 8bit RGB fallback */
-	output_fmts[i++] = MEDIA_BUS_FMT_RGB888_1X24;
-
 	*num_output_fmts = i;
 
 	return output_fmts;
diff --git a/drivers/gpu/drm/bridge/ti-sn65dsi86.c b/drivers/gpu/drm/bridge/ti-sn65dsi86.c
index d6dd4d99a229..d72bd1392c84 100644
--- a/drivers/gpu/drm/bridge/ti-sn65dsi86.c
+++ b/drivers/gpu/drm/bridge/ti-sn65dsi86.c
@@ -906,9 +906,9 @@ static void ti_sn_bridge_set_video_timings(struct ti_sn65dsi86 *pdata)
 		&pdata->bridge.encoder->crtc->state->adjusted_mode;
 	u8 hsync_polarity = 0, vsync_polarity = 0;
 
-	if (mode->flags & DRM_MODE_FLAG_PHSYNC)
+	if (mode->flags & DRM_MODE_FLAG_NHSYNC)
 		hsync_polarity = CHA_HSYNC_POLARITY;
-	if (mode->flags & DRM_MODE_FLAG_PVSYNC)
+	if (mode->flags & DRM_MODE_FLAG_NVSYNC)
 		vsync_polarity = CHA_VSYNC_POLARITY;
 
 	ti_sn65dsi86_write_u16(pdata, SN_CHA_ACTIVE_LINE_LENGTH_LOW_REG,
diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
index 904fc893c905..eb9e722a865b 100644
--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -571,12 +571,20 @@ static void drm_gem_shmem_vm_open(struct vm_area_struct *vma)
 {
 	struct drm_gem_object *obj = vma->vm_private_data;
 	struct drm_gem_shmem_object *shmem = to_drm_gem_shmem_obj(obj);
-	int ret;
 
 	WARN_ON(shmem->base.import_attach);
 
-	ret = drm_gem_shmem_get_pages(shmem);
-	WARN_ON_ONCE(ret != 0);
+	mutex_lock(&shmem->pages_lock);
+
+	/*
+	 * We should have already pinned the pages when the buffer was first
+	 * mmap'd, vm_open() just grabs an additional reference for the new
+	 * mm the vma is getting copied into (ie. on fork()).
+	 */
+	if (!WARN_ON_ONCE(!shmem->pages_use_count))
+		shmem->pages_use_count++;
+
+	mutex_unlock(&shmem->pages_lock);
 
 	drm_gem_vm_open(vma);
 }
@@ -622,10 +630,8 @@ int drm_gem_shmem_mmap(struct drm_gem_shmem_object *shmem, struct vm_area_struct
 	}
 
 	ret = drm_gem_shmem_get_pages(shmem);
-	if (ret) {
-		drm_gem_vm_close(vma);
+	if (ret)
 		return ret;
-	}
 
 	vma->vm_flags |= VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP;
 	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
diff --git a/drivers/gpu/drm/i915/display/intel_display.c b/drivers/gpu/drm/i915/display/intel_display.c
index fc5d94862ef3..d0f20bd0e51a 100644
--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -3717,12 +3717,16 @@ static bool ilk_get_pipe_config(struct intel_crtc *crtc,
 
 static u8 bigjoiner_pipes(struct drm_i915_private *i915)
 {
+	u8 pipes;
+
 	if (DISPLAY_VER(i915) >= 12)
-		return BIT(PIPE_A) | BIT(PIPE_B) | BIT(PIPE_C) | BIT(PIPE_D);
+		pipes = BIT(PIPE_A) | BIT(PIPE_B) | BIT(PIPE_C) | BIT(PIPE_D);
 	else if (DISPLAY_VER(i915) >= 11)
-		return BIT(PIPE_B) | BIT(PIPE_C);
+		pipes = BIT(PIPE_B) | BIT(PIPE_C);
 	else
-		return 0;
+		pipes = 0;
+
+	return pipes & INTEL_INFO(i915)->display.pipe_mask;
 }
 
 static bool transcoder_ddi_func_is_enabled(struct drm_i915_private *dev_priv,
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_msg.c b/drivers/gpu/drm/vmwgfx/vmwgfx_msg.c
index 089046fa21be..50fa3df0bc0c 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_msg.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_msg.c
@@ -1085,21 +1085,21 @@ int vmw_mksstat_add_ioctl(struct drm_device *dev, void *data,
 	reset_ppn_array(pdesc->strsPPNs, ARRAY_SIZE(pdesc->strsPPNs));
 
 	/* Pin mksGuestStat user pages and store those in the instance descriptor */
-	nr_pinned_stat = pin_user_pages(arg->stat, num_pages_stat, FOLL_LONGTERM, pages_stat, NULL);
+	nr_pinned_stat = pin_user_pages_fast(arg->stat, num_pages_stat, FOLL_LONGTERM, pages_stat);
 	if (num_pages_stat != nr_pinned_stat)
 		goto err_pin_stat;
 
 	for (i = 0; i < num_pages_stat; ++i)
 		pdesc->statPPNs[i] = page_to_pfn(pages_stat[i]);
 
-	nr_pinned_info = pin_user_pages(arg->info, num_pages_info, FOLL_LONGTERM, pages_info, NULL);
+	nr_pinned_info = pin_user_pages_fast(arg->info, num_pages_info, FOLL_LONGTERM, pages_info);
 	if (num_pages_info != nr_pinned_info)
 		goto err_pin_info;
 
 	for (i = 0; i < num_pages_info; ++i)
 		pdesc->infoPPNs[i] = page_to_pfn(pages_info[i]);
 
-	nr_pinned_strs = pin_user_pages(arg->strs, num_pages_strs, FOLL_LONGTERM, pages_strs, NULL);
+	nr_pinned_strs = pin_user_pages_fast(arg->strs, num_pages_strs, FOLL_LONGTERM, pages_strs);
 	if (num_pages_strs != nr_pinned_strs)
 		goto err_pin_strs;
 
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_scrn.c b/drivers/gpu/drm/vmwgfx/vmwgfx_scrn.c
index c89ad3a2d141..753d421a27ad 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_scrn.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_scrn.c
@@ -950,6 +950,10 @@ int vmw_kms_sou_init_display(struct vmw_private *dev_priv)
 	struct drm_device *dev = &dev_priv->drm;
 	int i, ret;
 
+	/* Screen objects won't work if GMR's aren't available */
+	if (!dev_priv->has_gmr)
+		return -ENOSYS;
+
 	if (!(dev_priv->capabilities & SVGA_CAP_SCREEN_OBJECT_2)) {
 		return -ENOSYS;
 	}
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index b7f5566e338d..e4974c27ca3d 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1315,6 +1315,9 @@ static s32 snto32(__u32 value, unsigned n)
 	if (!value || !n)
 		return 0;
 
+	if (n > 32)
+		n = 32;
+
 	switch (n) {
 	case 8:  return ((__s8)value);
 	case 16: return ((__s16)value);
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 256795ed6247..86e754b9400f 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -274,6 +274,7 @@
 #define USB_DEVICE_ID_CH_AXIS_295	0x001c
 
 #define USB_VENDOR_ID_CHERRY		0x046a
+#define USB_DEVICE_ID_CHERRY_MOUSE_000C	0x000c
 #define USB_DEVICE_ID_CHERRY_CYMOTION	0x0023
 #define USB_DEVICE_ID_CHERRY_CYMOTION_SOLAR	0x0027
 
@@ -917,6 +918,7 @@
 #define USB_DEVICE_ID_MS_XBOX_ONE_S_CONTROLLER	0x02fd
 #define USB_DEVICE_ID_MS_PIXART_MOUSE    0x00cb
 #define USB_DEVICE_ID_8BITDO_SN30_PRO_PLUS      0x02e0
+#define USB_DEVICE_ID_MS_MOUSE_0783      0x0783
 
 #define USB_VENDOR_ID_MOJO		0x8282
 #define USB_DEVICE_ID_RETRO_ADAPTER	0x3201
@@ -1215,6 +1217,7 @@
 #define USB_DEVICE_ID_SYNAPTICS_DELL_K15A	0x6e21
 #define USB_DEVICE_ID_SYNAPTICS_ACER_ONE_S1002	0x73f4
 #define USB_DEVICE_ID_SYNAPTICS_ACER_ONE_S1003	0x73f5
+#define USB_DEVICE_ID_SYNAPTICS_ACER_SWITCH5_017	0x73f6
 #define USB_DEVICE_ID_SYNAPTICS_ACER_SWITCH5	0x81a7
 
 #define USB_VENDOR_ID_TEXAS_INSTRUMENTS	0x2047
@@ -1379,6 +1382,7 @@
 
 #define USB_VENDOR_ID_PRIMAX	0x0461
 #define USB_DEVICE_ID_PRIMAX_MOUSE_4D22	0x4d22
+#define USB_DEVICE_ID_PRIMAX_MOUSE_4E2A	0x4e2a
 #define USB_DEVICE_ID_PRIMAX_KEYBOARD	0x4e05
 #define USB_DEVICE_ID_PRIMAX_REZEL	0x4e72
 #define USB_DEVICE_ID_PRIMAX_PIXART_MOUSE_4D0F	0x4d0f
diff --git a/drivers/hid/hid-ite.c b/drivers/hid/hid-ite.c
index 430fa4f52ed3..75ebfcf31889 100644
--- a/drivers/hid/hid-ite.c
+++ b/drivers/hid/hid-ite.c
@@ -121,6 +121,11 @@ static const struct hid_device_id ite_devices[] = {
 		     USB_VENDOR_ID_SYNAPTICS,
 		     USB_DEVICE_ID_SYNAPTICS_ACER_ONE_S1003),
 	  .driver_data = QUIRK_TOUCHPAD_ON_OFF_REPORT },
+	/* ITE8910 USB kbd ctlr, with Synaptics touchpad connected to it. */
+	{ HID_DEVICE(BUS_USB, HID_GROUP_GENERIC,
+		     USB_VENDOR_ID_SYNAPTICS,
+		     USB_DEVICE_ID_SYNAPTICS_ACER_SWITCH5_017),
+	  .driver_data = QUIRK_TOUCHPAD_ON_OFF_REPORT },
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, ite_devices);
diff --git a/drivers/hid/hid-lg4ff.c b/drivers/hid/hid-lg4ff.c
index 5e6a0cef2a06..e3fcf1353fb3 100644
--- a/drivers/hid/hid-lg4ff.c
+++ b/drivers/hid/hid-lg4ff.c
@@ -872,6 +872,12 @@ static ssize_t lg4ff_alternate_modes_store(struct device *dev, struct device_att
 		return -ENOMEM;
 
 	i = strlen(lbuf);
+
+	if (i == 0) {
+		kfree(lbuf);
+		return -EINVAL;
+	}
+
 	if (lbuf[i-1] == '\n') {
 		if (i == 1) {
 			kfree(lbuf);
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index 50e1c717fc0a..0e9702c7f7d6 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -54,6 +54,7 @@ static const struct hid_device_id hid_quirks[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CH, USB_DEVICE_ID_CH_FLIGHT_SIM_YOKE), HID_QUIRK_NOGET },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CH, USB_DEVICE_ID_CH_PRO_PEDALS), HID_QUIRK_NOGET },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CH, USB_DEVICE_ID_CH_PRO_THROTTLE), HID_QUIRK_NOGET },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_CHERRY, USB_DEVICE_ID_CHERRY_MOUSE_000C), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CORSAIR, USB_DEVICE_ID_CORSAIR_K65RGB), HID_QUIRK_NO_INIT_REPORTS },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CORSAIR, USB_DEVICE_ID_CORSAIR_K65RGB_RAPIDFIRE), HID_QUIRK_NO_INIT_REPORTS | HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CORSAIR, USB_DEVICE_ID_CORSAIR_K70RGB), HID_QUIRK_NO_INIT_REPORTS },
@@ -122,6 +123,7 @@ static const struct hid_device_id hid_quirks[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_MOUSE_C05A), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_MOUSE_C06A), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MCS, USB_DEVICE_ID_MCS_GAMEPADBLOCK), HID_QUIRK_MULTI_INPUT },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_MOUSE_0783), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_PIXART_MOUSE), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_POWER_COVER), HID_QUIRK_NO_INIT_REPORTS },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_SURFACE3_COVER), HID_QUIRK_NO_INIT_REPORTS },
@@ -146,6 +148,7 @@ static const struct hid_device_id hid_quirks[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_PIXART, USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN), HID_QUIRK_NO_INIT_REPORTS },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_PIXART, USB_DEVICE_ID_PIXART_USB_OPTICAL_MOUSE), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_PRIMAX, USB_DEVICE_ID_PRIMAX_MOUSE_4D22), HID_QUIRK_ALWAYS_POLL },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_PRIMAX, USB_DEVICE_ID_PRIMAX_MOUSE_4E2A), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_PRIMAX, USB_DEVICE_ID_PRIMAX_PIXART_MOUSE_4D0F), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_PRIMAX, USB_DEVICE_ID_PRIMAX_PIXART_MOUSE_4D65), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_PRIMAX, USB_DEVICE_ID_PRIMAX_PIXART_MOUSE_4E22), HID_QUIRK_ALWAYS_POLL },
diff --git a/drivers/hid/hid-uclogic-core.c b/drivers/hid/hid-uclogic-core.c
index ff46604ef1d8..683350596ea6 100644
--- a/drivers/hid/hid-uclogic-core.c
+++ b/drivers/hid/hid-uclogic-core.c
@@ -192,6 +192,7 @@ static int uclogic_probe(struct hid_device *hdev,
 	 * than the pen, so use QUIRK_MULTI_INPUT for all tablets.
 	 */
 	hdev->quirks |= HID_QUIRK_MULTI_INPUT;
+	hdev->quirks |= HID_QUIRK_HIDINPUT_FORCE;
 
 	/* Allocate and assign driver data */
 	drvdata = devm_kzalloc(&hdev->dev, sizeof(*drvdata), GFP_KERNEL);
diff --git a/drivers/hid/hid-uclogic-rdesc.c b/drivers/hid/hid-uclogic-rdesc.c
index 81ca22398ed5..ce6cf6b18ae6 100644
--- a/drivers/hid/hid-uclogic-rdesc.c
+++ b/drivers/hid/hid-uclogic-rdesc.c
@@ -1119,7 +1119,7 @@ __u8 *uclogic_rdesc_template_apply(const __u8 *template_ptr,
 			   p[sizeof(btn_head)] < param_num) {
 			v = param_list[p[sizeof(btn_head)]];
 			put_unaligned((__u8)0x2A, p); /* Usage Maximum */
-			put_unaligned_le16((__force u16)cpu_to_le16(v), p + 1);
+			put_unaligned((__force u16)cpu_to_le16(v), (s16 *)(p + 1));
 			p += sizeof(btn_head) + 1;
 		} else {
 			p++;
diff --git a/drivers/hid/i2c-hid/Kconfig b/drivers/hid/i2c-hid/Kconfig
index 5273ee2bb134..d65abe65ce73 100644
--- a/drivers/hid/i2c-hid/Kconfig
+++ b/drivers/hid/i2c-hid/Kconfig
@@ -66,6 +66,6 @@ endmenu
 
 config I2C_HID_CORE
 	tristate
-	default y if I2C_HID_ACPI=y || I2C_HID_OF=y || I2C_HID_OF_GOODIX=y
-	default m if I2C_HID_ACPI=m || I2C_HID_OF=m || I2C_HID_OF_GOODIX=m
+	default y if I2C_HID_ACPI=y || I2C_HID_OF=y || I2C_HID_OF_ELAN=y || I2C_HID_OF_GOODIX=y
+	default m if I2C_HID_ACPI=m || I2C_HID_OF=m || I2C_HID_OF_ELAN=m || I2C_HID_OF_GOODIX=m
 	select HID
diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index b203c1e26353..4eac35c4ea3b 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -813,7 +813,13 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
 	num_buffers = max_t(unsigned int, *count, q->min_buffers_needed);
 	num_buffers = min_t(unsigned int, num_buffers, VB2_MAX_FRAME);
 	memset(q->alloc_devs, 0, sizeof(q->alloc_devs));
+	/*
+	 * Set this now to ensure that drivers see the correct q->memory value
+	 * in the queue_setup op.
+	 */
+	mutex_lock(&q->mmap_lock);
 	q->memory = memory;
+	mutex_unlock(&q->mmap_lock);
 	set_queue_coherency(q, non_coherent_mem);
 
 	/*
@@ -823,22 +829,27 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
 	ret = call_qop(q, queue_setup, q, &num_buffers, &num_planes,
 		       plane_sizes, q->alloc_devs);
 	if (ret)
-		return ret;
+		goto error;
 
 	/* Check that driver has set sane values */
-	if (WARN_ON(!num_planes))
-		return -EINVAL;
+	if (WARN_ON(!num_planes)) {
+		ret = -EINVAL;
+		goto error;
+	}
 
 	for (i = 0; i < num_planes; i++)
-		if (WARN_ON(!plane_sizes[i]))
-			return -EINVAL;
+		if (WARN_ON(!plane_sizes[i])) {
+			ret = -EINVAL;
+			goto error;
+		}
 
 	/* Finally, allocate buffers and video memory */
 	allocated_buffers =
 		__vb2_queue_alloc(q, memory, num_buffers, num_planes, plane_sizes);
 	if (allocated_buffers == 0) {
 		dprintk(q, 1, "memory allocation failed\n");
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto error;
 	}
 
 	/*
@@ -879,7 +890,8 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
 	if (ret < 0) {
 		/*
 		 * Note: __vb2_queue_free() will subtract 'allocated_buffers'
-		 * from q->num_buffers.
+		 * from q->num_buffers and it will reset q->memory to
+		 * VB2_MEMORY_UNKNOWN.
 		 */
 		__vb2_queue_free(q, allocated_buffers);
 		mutex_unlock(&q->mmap_lock);
@@ -895,6 +907,12 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
 	q->waiting_for_buffers = !q->is_output;
 
 	return 0;
+
+error:
+	mutex_lock(&q->mmap_lock);
+	q->memory = VB2_MEMORY_UNKNOWN;
+	mutex_unlock(&q->mmap_lock);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(vb2_core_reqbufs);
 
@@ -906,6 +924,7 @@ int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
 	unsigned int num_planes = 0, num_buffers, allocated_buffers;
 	unsigned plane_sizes[VB2_MAX_PLANES] = { };
 	bool non_coherent_mem = flags & V4L2_MEMORY_FLAG_NON_COHERENT;
+	bool no_previous_buffers = !q->num_buffers;
 	int ret;
 
 	if (q->num_buffers == VB2_MAX_FRAME) {
@@ -913,13 +932,19 @@ int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
 		return -ENOBUFS;
 	}
 
-	if (!q->num_buffers) {
+	if (no_previous_buffers) {
 		if (q->waiting_in_dqbuf && *count) {
 			dprintk(q, 1, "another dup()ped fd is waiting for a buffer\n");
 			return -EBUSY;
 		}
 		memset(q->alloc_devs, 0, sizeof(q->alloc_devs));
+		/*
+		 * Set this now to ensure that drivers see the correct q->memory
+		 * value in the queue_setup op.
+		 */
+		mutex_lock(&q->mmap_lock);
 		q->memory = memory;
+		mutex_unlock(&q->mmap_lock);
 		q->waiting_for_buffers = !q->is_output;
 		set_queue_coherency(q, non_coherent_mem);
 	} else {
@@ -945,14 +970,15 @@ int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
 	ret = call_qop(q, queue_setup, q, &num_buffers,
 		       &num_planes, plane_sizes, q->alloc_devs);
 	if (ret)
-		return ret;
+		goto error;
 
 	/* Finally, allocate buffers and video memory */
 	allocated_buffers = __vb2_queue_alloc(q, memory, num_buffers,
 				num_planes, plane_sizes);
 	if (allocated_buffers == 0) {
 		dprintk(q, 1, "memory allocation failed\n");
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto error;
 	}
 
 	/*
@@ -983,7 +1009,8 @@ int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
 	if (ret < 0) {
 		/*
 		 * Note: __vb2_queue_free() will subtract 'allocated_buffers'
-		 * from q->num_buffers.
+		 * from q->num_buffers and it will reset q->memory to
+		 * VB2_MEMORY_UNKNOWN.
 		 */
 		__vb2_queue_free(q, allocated_buffers);
 		mutex_unlock(&q->mmap_lock);
@@ -998,6 +1025,14 @@ int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
 	*count = allocated_buffers;
 
 	return 0;
+
+error:
+	if (no_previous_buffers) {
+		mutex_lock(&q->mmap_lock);
+		q->memory = VB2_MEMORY_UNKNOWN;
+		mutex_unlock(&q->mmap_lock);
+	}
+	return ret;
 }
 EXPORT_SYMBOL_GPL(vb2_core_create_bufs);
 
@@ -2164,6 +2199,22 @@ static int __find_plane_by_offset(struct vb2_queue *q, unsigned long off,
 	struct vb2_buffer *vb;
 	unsigned int buffer, plane;
 
+	/*
+	 * Sanity checks to ensure the lock is held, MEMORY_MMAP is
+	 * used and fileio isn't active.
+	 */
+	lockdep_assert_held(&q->mmap_lock);
+
+	if (q->memory != VB2_MEMORY_MMAP) {
+		dprintk(q, 1, "queue is not currently set up for mmap\n");
+		return -EINVAL;
+	}
+
+	if (vb2_fileio_is_active(q)) {
+		dprintk(q, 1, "file io in progress\n");
+		return -EBUSY;
+	}
+
 	/*
 	 * Go over all buffers and their planes, comparing the given offset
 	 * with an offset assigned to each plane. If a match is found,
@@ -2265,11 +2316,6 @@ int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
 	int ret;
 	unsigned long length;
 
-	if (q->memory != VB2_MEMORY_MMAP) {
-		dprintk(q, 1, "queue is not currently set up for mmap\n");
-		return -EINVAL;
-	}
-
 	/*
 	 * Check memory area access mode.
 	 */
@@ -2291,14 +2337,9 @@ int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
 
 	mutex_lock(&q->mmap_lock);
 
-	if (vb2_fileio_is_active(q)) {
-		dprintk(q, 1, "mmap: file io in progress\n");
-		ret = -EBUSY;
-		goto unlock;
-	}
-
 	/*
-	 * Find the plane corresponding to the offset passed by userspace.
+	 * Find the plane corresponding to the offset passed by userspace. This
+	 * will return an error if not MEMORY_MMAP or file I/O is in progress.
 	 */
 	ret = __find_plane_by_offset(q, off, &buffer, &plane);
 	if (ret)
@@ -2351,22 +2392,25 @@ unsigned long vb2_get_unmapped_area(struct vb2_queue *q,
 	void *vaddr;
 	int ret;
 
-	if (q->memory != VB2_MEMORY_MMAP) {
-		dprintk(q, 1, "queue is not currently set up for mmap\n");
-		return -EINVAL;
-	}
+	mutex_lock(&q->mmap_lock);
 
 	/*
-	 * Find the plane corresponding to the offset passed by userspace.
+	 * Find the plane corresponding to the offset passed by userspace. This
+	 * will return an error if not MEMORY_MMAP or file I/O is in progress.
 	 */
 	ret = __find_plane_by_offset(q, off, &buffer, &plane);
 	if (ret)
-		return ret;
+		goto unlock;
 
 	vb = q->bufs[buffer];
 
 	vaddr = vb2_plane_vaddr(vb, plane);
+	mutex_unlock(&q->mmap_lock);
 	return vaddr ? (unsigned long)vaddr : -EINVAL;
+
+unlock:
+	mutex_unlock(&q->mmap_lock);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(vb2_get_unmapped_area);
 #endif
diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c b/drivers/media/v4l2-core/v4l2-dv-timings.c
index 003c32fed3f7..942d0005c55e 100644
--- a/drivers/media/v4l2-core/v4l2-dv-timings.c
+++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
@@ -145,6 +145,8 @@ bool v4l2_valid_dv_timings(const struct v4l2_dv_timings *t,
 	const struct v4l2_bt_timings *bt = &t->bt;
 	const struct v4l2_bt_timings_cap *cap = &dvcap->bt;
 	u32 caps = cap->capabilities;
+	const u32 max_vert = 10240;
+	u32 max_hor = 3 * bt->width;
 
 	if (t->type != V4L2_DV_BT_656_1120)
 		return false;
@@ -166,14 +168,20 @@ bool v4l2_valid_dv_timings(const struct v4l2_dv_timings *t,
 	if (!bt->interlaced &&
 	    (bt->il_vbackporch || bt->il_vsync || bt->il_vfrontporch))
 		return false;
-	if (bt->hfrontporch > 2 * bt->width ||
-	    bt->hsync > 1024 || bt->hbackporch > 1024)
+	/*
+	 * Some video receivers cannot properly separate the frontporch,
+	 * backporch and sync values, and instead they only have the total
+	 * blanking. That can be assigned to any of these three fields.
+	 * So just check that none of these are way out of range.
+	 */
+	if (bt->hfrontporch > max_hor ||
+	    bt->hsync > max_hor || bt->hbackporch > max_hor)
 		return false;
-	if (bt->vfrontporch > 4096 ||
-	    bt->vsync > 128 || bt->vbackporch > 4096)
+	if (bt->vfrontporch > max_vert ||
+	    bt->vsync > max_vert || bt->vbackporch > max_vert)
 		return false;
-	if (bt->interlaced && (bt->il_vfrontporch > 4096 ||
-	    bt->il_vsync > 128 || bt->il_vbackporch > 4096))
+	if (bt->interlaced && (bt->il_vfrontporch > max_vert ||
+	    bt->il_vsync > max_vert || bt->il_vbackporch > max_vert))
 		return false;
 	return fnc == NULL || fnc(t, fnc_handle);
 }
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 76dd5ff1d99d..c2939621b683 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3247,7 +3247,7 @@ static int bond_na_rcv(const struct sk_buff *skb, struct bonding *bond,
 		goto out;
 
 	saddr = &combined->ip6.saddr;
-	daddr = &combined->ip6.saddr;
+	daddr = &combined->ip6.daddr;
 
 	slave_dbg(bond->dev, slave->dev, "%s: %s/%d av %d sv %d sip %pI6c tip %pI6c\n",
 		  __func__, slave->dev->name, bond_slave_state(slave),
diff --git a/drivers/net/can/can327.c b/drivers/net/can/can327.c
index ed3d0b8989a0..dc7192ecb001 100644
--- a/drivers/net/can/can327.c
+++ b/drivers/net/can/can327.c
@@ -796,9 +796,9 @@ static int can327_netdev_close(struct net_device *dev)
 
 	netif_stop_queue(dev);
 
-	/* Give UART one final chance to flush. */
-	clear_bit(TTY_DO_WRITE_WAKEUP, &elm->tty->flags);
-	flush_work(&elm->tx_work);
+	/* We don't flush the UART TX queue here, as we want final stop
+	 * commands (like the above dummy char) to be flushed out.
+	 */
 
 	can_rx_offload_disable(&elm->offload);
 	elm->can.state = CAN_STATE_STOPPED;
@@ -1069,12 +1069,15 @@ static void can327_ldisc_close(struct tty_struct *tty)
 {
 	struct can327 *elm = (struct can327 *)tty->disc_data;
 
-	/* unregister_netdev() calls .ndo_stop() so we don't have to.
-	 * Our .ndo_stop() also flushes the TTY write wakeup handler,
-	 * so we can safely set elm->tty = NULL after this.
-	 */
+	/* unregister_netdev() calls .ndo_stop() so we don't have to. */
 	unregister_candev(elm->dev);
 
+	/* Give UART one final chance to flush.
+	 * No need to clear TTY_DO_WRITE_WAKEUP since .write_wakeup() is
+	 * serialised against .close() and will not be called once we return.
+	 */
+	flush_work(&elm->tx_work);
+
 	/* Mark channel as dead */
 	spin_lock_bh(&elm->lock);
 	tty->disc_data = NULL;
diff --git a/drivers/net/can/slcan/slcan-core.c b/drivers/net/can/slcan/slcan-core.c
index fbb34139daa1..f4db77007c13 100644
--- a/drivers/net/can/slcan/slcan-core.c
+++ b/drivers/net/can/slcan/slcan-core.c
@@ -864,12 +864,14 @@ static void slcan_close(struct tty_struct *tty)
 {
 	struct slcan *sl = (struct slcan *)tty->disc_data;
 
-	/* unregister_netdev() calls .ndo_stop() so we don't have to.
-	 * Our .ndo_stop() also flushes the TTY write wakeup handler,
-	 * so we can safely set sl->tty = NULL after this.
-	 */
 	unregister_candev(sl->dev);
 
+	/*
+	 * The netdev needn't be UP (so .ndo_stop() is not called). Hence make
+	 * sure this is not running before freeing it up.
+	 */
+	flush_work(&sl->tx_work);
+
 	/* Mark channel as dead */
 	spin_lock_bh(&sl->lock);
 	tty->disc_data = NULL;
diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_usb.c
index 81b88e9e5bdc..42323f5e6f3a 100644
--- a/drivers/net/can/usb/esd_usb.c
+++ b/drivers/net/can/usb/esd_usb.c
@@ -234,6 +234,10 @@ static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
 		u8 rxerr = msg->msg.rx.data[2];
 		u8 txerr = msg->msg.rx.data[3];
 
+		netdev_dbg(priv->netdev,
+			   "CAN_ERR_EV_EXT: dlc=%#02x state=%02x ecc=%02x rec=%02x tec=%02x\n",
+			   msg->msg.rx.dlc, state, ecc, rxerr, txerr);
+
 		skb = alloc_can_err_skb(priv->netdev, &cf);
 		if (skb == NULL) {
 			stats->rx_dropped++;
@@ -260,6 +264,8 @@ static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
 				break;
 			default:
 				priv->can.state = CAN_STATE_ERROR_ACTIVE;
+				txerr = 0;
+				rxerr = 0;
 				break;
 			}
 		} else {
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 07e9a4da924c..546d90dae933 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -825,10 +825,13 @@ static void mv88e6xxx_get_caps(struct dsa_switch *ds, int port,
 
 	chip->info->ops->phylink_get_caps(chip, port, config);
 
-	/* Internal ports need GMII for PHYLIB */
-	if (mv88e6xxx_phy_is_internal(ds, port))
+	if (mv88e6xxx_phy_is_internal(ds, port)) {
+		__set_bit(PHY_INTERFACE_MODE_INTERNAL,
+			  config->supported_interfaces);
+		/* Internal ports with no phy-mode need GMII for PHYLIB */
 		__set_bit(PHY_INTERFACE_MODE_GMII,
 			  config->supported_interfaces);
+	}
 }
 
 static void mv88e6xxx_mac_config(struct dsa_switch *ds, int port,
diff --git a/drivers/net/dsa/sja1105/sja1105_devlink.c b/drivers/net/dsa/sja1105/sja1105_devlink.c
index 10c6fea1227f..bdbbff2a7909 100644
--- a/drivers/net/dsa/sja1105/sja1105_devlink.c
+++ b/drivers/net/dsa/sja1105/sja1105_devlink.c
@@ -95,6 +95,8 @@ static int sja1105_setup_devlink_regions(struct dsa_switch *ds)
 		if (IS_ERR(region)) {
 			while (--i >= 0)
 				dsa_devlink_region_destroy(priv->regions[i]);
+
+			kfree(priv->regions);
 			return PTR_ERR(region);
 		}
 
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index b03d0d0c3dbf..2cb8fa2494cb 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1038,7 +1038,7 @@ static int sja1105_init_l2_policing(struct sja1105_private *priv)
 
 		policing[bcast].sharindx = port;
 		/* Only SJA1110 has multicast policers */
-		if (mcast <= table->ops->max_entry_count)
+		if (mcast < table->ops->max_entry_count)
 			policing[mcast].sharindx = port;
 	}
 
diff --git a/drivers/net/ethernet/aeroflex/greth.c b/drivers/net/ethernet/aeroflex/greth.c
index 447dc64a17e5..4ce8367bb81c 100644
--- a/drivers/net/ethernet/aeroflex/greth.c
+++ b/drivers/net/ethernet/aeroflex/greth.c
@@ -258,6 +258,7 @@ static int greth_init_rings(struct greth_private *greth)
 			if (dma_mapping_error(greth->dev, dma_addr)) {
 				if (netif_msg_ifup(greth))
 					dev_err(greth->dev, "Could not create initial DMA mapping\n");
+				dev_kfree_skb(skb);
 				goto cleanup;
 			}
 			greth->rx_skbuff[i] = skb;
diff --git a/drivers/net/ethernet/broadcom/Kconfig b/drivers/net/ethernet/broadcom/Kconfig
index 1cd3c289f49b..cd1706909044 100644
--- a/drivers/net/ethernet/broadcom/Kconfig
+++ b/drivers/net/ethernet/broadcom/Kconfig
@@ -71,13 +71,14 @@ config BCM63XX_ENET
 config BCMGENET
 	tristate "Broadcom GENET internal MAC support"
 	depends on HAS_IOMEM
+	depends on PTP_1588_CLOCK_OPTIONAL || !ARCH_BCM2835
 	select MII
 	select PHYLIB
 	select FIXED_PHY
 	select BCM7XXX_PHY
 	select MDIO_BCM_UNIMAC
 	select DIMLIB
-	select BROADCOM_PHY if (ARCH_BCM2835 && PTP_1588_CLOCK_OPTIONAL)
+	select BROADCOM_PHY if ARCH_BCM2835
 	help
 	  This driver supports the built-in Ethernet MACs found in the
 	  Broadcom BCM7xxx Set Top Box family chipset.
diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_main.c b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
index 768ea426d49f..745bd2dfb742 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
@@ -2240,7 +2240,7 @@ static int nicvf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	err = register_netdev(netdev);
 	if (err) {
 		dev_err(dev, "Failed to register netdevice\n");
-		goto err_unregister_interrupts;
+		goto err_destroy_workqueue;
 	}
 
 	nic->msg_enable = debug;
@@ -2249,6 +2249,8 @@ static int nicvf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	return 0;
 
+err_destroy_workqueue:
+	destroy_workqueue(nic->nicvf_rx_mode_wq);
 err_unregister_interrupts:
 	nicvf_unregister_interrupts(nic);
 err_free_netdev:
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
index cacd454ac696..c39b866e2582 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
@@ -132,6 +132,7 @@ int dpaa2_switch_acl_entry_add(struct dpaa2_switch_filter_block *filter_block,
 						 DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(dev, acl_entry_cfg->key_iova))) {
 		dev_err(dev, "DMA mapping failed\n");
+		kfree(cmd_buff);
 		return -EFAULT;
 	}
 
@@ -142,6 +143,7 @@ int dpaa2_switch_acl_entry_add(struct dpaa2_switch_filter_block *filter_block,
 			 DMA_TO_DEVICE);
 	if (err) {
 		dev_err(dev, "dpsw_acl_add_entry() failed %d\n", err);
+		kfree(cmd_buff);
 		return err;
 	}
 
@@ -172,6 +174,7 @@ dpaa2_switch_acl_entry_remove(struct dpaa2_switch_filter_block *block,
 						 DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(dev, acl_entry_cfg->key_iova))) {
 		dev_err(dev, "DMA mapping failed\n");
+		kfree(cmd_buff);
 		return -EFAULT;
 	}
 
@@ -182,6 +185,7 @@ dpaa2_switch_acl_entry_remove(struct dpaa2_switch_filter_block *block,
 			 DMA_TO_DEVICE);
 	if (err) {
 		dev_err(dev, "dpsw_acl_remove_entry() failed %d\n", err);
+		kfree(cmd_buff);
 		return err;
 	}
 
diff --git a/drivers/net/ethernet/hisilicon/hisi_femac.c b/drivers/net/ethernet/hisilicon/hisi_femac.c
index 93846bace028..ce2571c16e43 100644
--- a/drivers/net/ethernet/hisilicon/hisi_femac.c
+++ b/drivers/net/ethernet/hisilicon/hisi_femac.c
@@ -283,7 +283,7 @@ static int hisi_femac_rx(struct net_device *dev, int limit)
 		skb->protocol = eth_type_trans(skb, dev);
 		napi_gro_receive(&priv->napi, skb);
 		dev->stats.rx_packets++;
-		dev->stats.rx_bytes += skb->len;
+		dev->stats.rx_bytes += len;
 next:
 		pos = (pos + 1) % rxq->num;
 		if (rx_pkts_num >= limit)
diff --git a/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c b/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
index d7e62eca050f..b981b6cbe6ff 100644
--- a/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
+++ b/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
@@ -550,7 +550,7 @@ static int hix5hd2_rx(struct net_device *dev, int limit)
 		skb->protocol = eth_type_trans(skb, dev);
 		napi_gro_receive(&priv->napi, skb);
 		dev->stats.rx_packets++;
-		dev->stats.rx_bytes += skb->len;
+		dev->stats.rx_bytes += len;
 next:
 		pos = dma_ring_incr(pos, RX_DESC_NUM);
 	}
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 321f2a95ae3a..da113f5011e9 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -5936,9 +5936,9 @@ static netdev_tx_t e1000_xmit_frame(struct sk_buff *skb,
 		e1000_tx_queue(tx_ring, tx_flags, count);
 		/* Make sure there is space in the ring for the next send. */
 		e1000_maybe_stop_tx(tx_ring,
-				    (MAX_SKB_FRAGS *
+				    ((MAX_SKB_FRAGS + 1) *
 				     DIV_ROUND_UP(PAGE_SIZE,
-						  adapter->tx_fifo_limit) + 2));
+						  adapter->tx_fifo_limit) + 4));
 
 		if (!netdev_xmit_more() ||
 		    netif_xmit_stopped(netdev_get_tx_queue(netdev, 0))) {
diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index 6f0d4160ff82..d9368f7669aa 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -4464,11 +4464,7 @@ static int i40e_check_fdir_input_set(struct i40e_vsi *vsi,
 			return -EOPNOTSUPP;
 
 		/* First 4 bytes of L4 header */
-		if (usr_ip4_spec->l4_4_bytes == htonl(0xFFFFFFFF))
-			new_mask |= I40E_L4_SRC_MASK | I40E_L4_DST_MASK;
-		else if (!usr_ip4_spec->l4_4_bytes)
-			new_mask &= ~(I40E_L4_SRC_MASK | I40E_L4_DST_MASK);
-		else
+		if (usr_ip4_spec->l4_4_bytes)
 			return -EOPNOTSUPP;
 
 		/* Filtering on Type of Service is not supported. */
@@ -4507,11 +4503,7 @@ static int i40e_check_fdir_input_set(struct i40e_vsi *vsi,
 		else
 			return -EOPNOTSUPP;
 
-		if (usr_ip6_spec->l4_4_bytes == htonl(0xFFFFFFFF))
-			new_mask |= I40E_L4_SRC_MASK | I40E_L4_DST_MASK;
-		else if (!usr_ip6_spec->l4_4_bytes)
-			new_mask &= ~(I40E_L4_SRC_MASK | I40E_L4_DST_MASK);
-		else
+		if (usr_ip6_spec->l4_4_bytes)
 			return -EOPNOTSUPP;
 
 		/* Filtering on Traffic class is not supported. */
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 023685cca2c1..e53ea7ed0b1d 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -10661,6 +10661,21 @@ static int i40e_rebuild_channels(struct i40e_vsi *vsi)
 	return 0;
 }
 
+/**
+ * i40e_clean_xps_state - clean xps state for every tx_ring
+ * @vsi: ptr to the VSI
+ **/
+static void i40e_clean_xps_state(struct i40e_vsi *vsi)
+{
+	int i;
+
+	if (vsi->tx_rings)
+		for (i = 0; i < vsi->num_queue_pairs; i++)
+			if (vsi->tx_rings[i])
+				clear_bit(__I40E_TX_XPS_INIT_DONE,
+					  vsi->tx_rings[i]->state);
+}
+
 /**
  * i40e_prep_for_reset - prep for the core to reset
  * @pf: board private structure
@@ -10685,8 +10700,10 @@ static void i40e_prep_for_reset(struct i40e_pf *pf)
 	i40e_pf_quiesce_all_vsi(pf);
 
 	for (v = 0; v < pf->num_alloc_vsi; v++) {
-		if (pf->vsi[v])
+		if (pf->vsi[v]) {
+			i40e_clean_xps_state(pf->vsi[v]);
 			pf->vsi[v]->seid = 0;
+		}
 	}
 
 	i40e_shutdown_adminq(&pf->hw);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 72ddcefc45b1..635f93d60318 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -1578,6 +1578,7 @@ bool i40e_reset_vf(struct i40e_vf *vf, bool flr)
 	i40e_cleanup_reset_vf(vf);
 
 	i40e_flush(hw);
+	usleep_range(20000, 40000);
 	clear_bit(I40E_VF_STATE_RESETTING, &vf->vf_states);
 
 	return true;
@@ -1701,6 +1702,7 @@ bool i40e_reset_all_vfs(struct i40e_pf *pf, bool flr)
 	}
 
 	i40e_flush(hw);
+	usleep_range(20000, 40000);
 	clear_bit(__I40E_VF_DISABLE, pf->state);
 
 	return true;
diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c b/drivers/net/ethernet/intel/igb/igb_ethtool.c
index c14fc871dd41..677893f891ed 100644
--- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
+++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
@@ -1413,6 +1413,8 @@ static int igb_intr_test(struct igb_adapter *adapter, u64 *data)
 			*data = 1;
 			return -1;
 		}
+		wr32(E1000_IVAR_MISC, E1000_IVAR_VALID << 8);
+		wr32(E1000_EIMS, BIT(0));
 	} else if (adapter->flags & IGB_FLAG_HAS_MSI) {
 		shared_int = false;
 		if (request_irq(irq,
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 0caa2df87c04..85c93ba6a82b 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -4271,7 +4271,7 @@ static void mvneta_percpu_elect(struct mvneta_port *pp)
 	/* Use the cpu associated to the rxq when it is online, in all
 	 * the other cases, use the cpu 0 which can't be offline.
 	 */
-	if (cpu_online(pp->rxq_def))
+	if (pp->rxq_def < nr_cpu_ids && cpu_online(pp->rxq_def))
 		elected_cpu = pp->rxq_def;
 
 	max_cpu = num_present_cpus();
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
index e64318c110fd..6a01ab1a6e6f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
@@ -1134,7 +1134,12 @@ int otx2_init_tc(struct otx2_nic *nic)
 		return err;
 
 	tc->flow_ht_params = tc_flow_ht_params;
-	return rhashtable_init(&tc->flow_table, &tc->flow_ht_params);
+	err = rhashtable_init(&tc->flow_table, &tc->flow_ht_params);
+	if (err) {
+		kfree(tc->tc_entries_bitmap);
+		tc->tc_entries_bitmap = NULL;
+	}
+	return err;
 }
 EXPORT_SYMBOL(otx2_init_tc);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 48f86e12f5c0..bbe810f3b373 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -201,9 +201,8 @@ static void mlx5_ldev_free(struct kref *ref)
 	if (ldev->nb.notifier_call)
 		unregister_netdevice_notifier_net(&init_net, &ldev->nb);
 	mlx5_lag_mp_cleanup(ldev);
-	mlx5_lag_mpesw_cleanup(ldev);
-	cancel_work_sync(&ldev->mpesw_work);
 	destroy_workqueue(ldev->wq);
+	mlx5_lag_mpesw_cleanup(ldev);
 	mutex_destroy(&ldev->lock);
 	kfree(ldev);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
index ce2ce8ccbd70..f30ac2de639f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
@@ -50,6 +50,19 @@ struct lag_tracker {
 	enum netdev_lag_hash hash_type;
 };
 
+enum mpesw_op {
+	MLX5_MPESW_OP_ENABLE,
+	MLX5_MPESW_OP_DISABLE,
+};
+
+struct mlx5_mpesw_work_st {
+	struct work_struct work;
+	struct mlx5_lag    *lag;
+	enum mpesw_op	   op;
+	struct completion  comp;
+	int result;
+};
+
 /* LAG data of a ConnectX card.
  * It serves both its phys functions.
  */
@@ -66,7 +79,6 @@ struct mlx5_lag {
 	struct lag_tracker        tracker;
 	struct workqueue_struct   *wq;
 	struct delayed_work       bond_work;
-	struct work_struct	  mpesw_work;
 	struct notifier_block     nb;
 	struct lag_mp             lag_mp;
 	struct mlx5_lag_port_sel  port_sel;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
index f643202b29c6..c17e8f1ec914 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
@@ -7,63 +7,95 @@
 #include "eswitch.h"
 #include "lib/mlx5.h"
 
-void mlx5_mpesw_work(struct work_struct *work)
+static int add_mpesw_rule(struct mlx5_lag *ldev)
 {
-	struct mlx5_lag *ldev = container_of(work, struct mlx5_lag, mpesw_work);
+	struct mlx5_core_dev *dev = ldev->pf[MLX5_LAG_P1].dev;
+	int err;
 
-	mutex_lock(&ldev->lock);
-	mlx5_disable_lag(ldev);
-	mutex_unlock(&ldev->lock);
-}
+	if (atomic_add_return(1, &ldev->lag_mpesw.mpesw_rule_count) != 1)
+		return 0;
 
-static void mlx5_lag_disable_mpesw(struct mlx5_core_dev *dev)
-{
-	struct mlx5_lag *ldev = dev->priv.lag;
+	if (ldev->mode != MLX5_LAG_MODE_NONE) {
+		err = -EINVAL;
+		goto out_err;
+	}
 
-	if (!queue_work(ldev->wq, &ldev->mpesw_work))
-		mlx5_core_warn(dev, "failed to queue work\n");
+	err = mlx5_activate_lag(ldev, NULL, MLX5_LAG_MODE_MPESW, false);
+	if (err) {
+		mlx5_core_warn(dev, "Failed to create LAG in MPESW mode (%d)\n", err);
+		goto out_err;
+	}
+
+	return 0;
+
+out_err:
+	atomic_dec(&ldev->lag_mpesw.mpesw_rule_count);
+	return err;
 }
 
-void mlx5_lag_del_mpesw_rule(struct mlx5_core_dev *dev)
+static void del_mpesw_rule(struct mlx5_lag *ldev)
 {
-	struct mlx5_lag *ldev = dev->priv.lag;
+	if (!atomic_dec_return(&ldev->lag_mpesw.mpesw_rule_count) &&
+	    ldev->mode == MLX5_LAG_MODE_MPESW)
+		mlx5_disable_lag(ldev);
+}
 
-	if (!ldev)
-		return;
+static void mlx5_mpesw_work(struct work_struct *work)
+{
+	struct mlx5_mpesw_work_st *mpesww = container_of(work, struct mlx5_mpesw_work_st, work);
+	struct mlx5_lag *ldev = mpesww->lag;
 
 	mutex_lock(&ldev->lock);
-	if (!atomic_dec_return(&ldev->lag_mpesw.mpesw_rule_count) &&
-	    ldev->mode == MLX5_LAG_MODE_MPESW)
-		mlx5_lag_disable_mpesw(dev);
+	if (mpesww->op == MLX5_MPESW_OP_ENABLE)
+		mpesww->result = add_mpesw_rule(ldev);
+	else if (mpesww->op == MLX5_MPESW_OP_DISABLE)
+		del_mpesw_rule(ldev);
 	mutex_unlock(&ldev->lock);
+
+	complete(&mpesww->comp);
 }
 
-int mlx5_lag_add_mpesw_rule(struct mlx5_core_dev *dev)
+static int mlx5_lag_mpesw_queue_work(struct mlx5_core_dev *dev,
+				     enum mpesw_op op)
 {
 	struct mlx5_lag *ldev = dev->priv.lag;
+	struct mlx5_mpesw_work_st *work;
 	int err = 0;
 
 	if (!ldev)
 		return 0;
 
-	mutex_lock(&ldev->lock);
-	if (atomic_add_return(1, &ldev->lag_mpesw.mpesw_rule_count) != 1)
-		goto out;
+	work = kzalloc(sizeof(*work), GFP_KERNEL);
+	if (!work)
+		return -ENOMEM;
 
-	if (ldev->mode != MLX5_LAG_MODE_NONE) {
+	INIT_WORK(&work->work, mlx5_mpesw_work);
+	init_completion(&work->comp);
+	work->op = op;
+	work->lag = ldev;
+
+	if (!queue_work(ldev->wq, &work->work)) {
+		mlx5_core_warn(dev, "failed to queue mpesw work\n");
 		err = -EINVAL;
 		goto out;
 	}
-
-	err = mlx5_activate_lag(ldev, NULL, MLX5_LAG_MODE_MPESW, false);
-	if (err)
-		mlx5_core_warn(dev, "Failed to create LAG in MPESW mode (%d)\n", err);
-
+	wait_for_completion(&work->comp);
+	err = work->result;
 out:
-	mutex_unlock(&ldev->lock);
+	kfree(work);
 	return err;
 }
 
+void mlx5_lag_del_mpesw_rule(struct mlx5_core_dev *dev)
+{
+	mlx5_lag_mpesw_queue_work(dev, MLX5_MPESW_OP_DISABLE);
+}
+
+int mlx5_lag_add_mpesw_rule(struct mlx5_core_dev *dev)
+{
+	return mlx5_lag_mpesw_queue_work(dev, MLX5_MPESW_OP_ENABLE);
+}
+
 int mlx5_lag_do_mirred(struct mlx5_core_dev *mdev, struct net_device *out_dev)
 {
 	struct mlx5_lag *ldev = mdev->priv.lag;
@@ -71,12 +103,9 @@ int mlx5_lag_do_mirred(struct mlx5_core_dev *mdev, struct net_device *out_dev)
 	if (!netif_is_bond_master(out_dev) || !ldev)
 		return 0;
 
-	mutex_lock(&ldev->lock);
-	if (ldev->mode == MLX5_LAG_MODE_MPESW) {
-		mutex_unlock(&ldev->lock);
+	if (ldev->mode == MLX5_LAG_MODE_MPESW)
 		return -EOPNOTSUPP;
-	}
-	mutex_unlock(&ldev->lock);
+
 	return 0;
 }
 
@@ -90,11 +119,10 @@ bool mlx5_lag_mpesw_is_activated(struct mlx5_core_dev *dev)
 
 void mlx5_lag_mpesw_init(struct mlx5_lag *ldev)
 {
-	INIT_WORK(&ldev->mpesw_work, mlx5_mpesw_work);
 	atomic_set(&ldev->lag_mpesw.mpesw_rule_count, 0);
 }
 
 void mlx5_lag_mpesw_cleanup(struct mlx5_lag *ldev)
 {
-	cancel_delayed_work_sync(&ldev->bond_work);
+	WARN_ON(atomic_read(&ldev->lag_mpesw.mpesw_rule_count));
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.h b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.h
index be4abcb8fcd5..88e8daffcf92 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.h
@@ -12,7 +12,6 @@ struct lag_mpesw {
 	atomic_t mpesw_rule_count;
 };
 
-void mlx5_mpesw_work(struct work_struct *work);
 int mlx5_lag_do_mirred(struct mlx5_core_dev *mdev, struct net_device *out_dev);
 bool mlx5_lag_mpesw_is_activated(struct mlx5_core_dev *dev);
 #if IS_ENABLED(CONFIG_MLX5_ESWITCH)
diff --git a/drivers/net/ethernet/microchip/encx24j600-regmap.c b/drivers/net/ethernet/microchip/encx24j600-regmap.c
index 81a8ccca7e5e..5693784eec5b 100644
--- a/drivers/net/ethernet/microchip/encx24j600-regmap.c
+++ b/drivers/net/ethernet/microchip/encx24j600-regmap.c
@@ -359,7 +359,7 @@ static int regmap_encx24j600_phy_reg_read(void *context, unsigned int reg,
 		goto err_out;
 
 	usleep_range(26, 100);
-	while ((ret = regmap_read(ctx->regmap, MISTAT, &mistat) != 0) &&
+	while (((ret = regmap_read(ctx->regmap, MISTAT, &mistat)) == 0) &&
 	       (mistat & BUSY))
 		cpu_relax();
 
@@ -397,7 +397,7 @@ static int regmap_encx24j600_phy_reg_write(void *context, unsigned int reg,
 		goto err_out;
 
 	usleep_range(26, 100);
-	while ((ret = regmap_read(ctx->regmap, MISTAT, &mistat) != 0) &&
+	while (((ret = regmap_read(ctx->regmap, MISTAT, &mistat)) == 0) &&
 	       (mistat & BUSY))
 		cpu_relax();
 
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c b/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c
index 66360c8c5a38..141897dfe388 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c
@@ -317,7 +317,7 @@ int sparx5_fdma_xmit(struct sparx5 *sparx5, u32 *ifh, struct sk_buff *skb)
 	next_dcb_hw = sparx5_fdma_next_dcb(tx, tx->curr_entry);
 	db_hw = &next_dcb_hw->db[0];
 	if (!(db_hw->status & FDMA_DCB_STATUS_DONE))
-		tx->dropped++;
+		return -EINVAL;
 	db = list_first_entry(&tx->db_list, struct sparx5_db, list);
 	list_move_tail(&db->list, &tx->db_list);
 	next_dcb_hw->nextptr = FDMA_DCB_INVALID_DATA;
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
index 30815c0e3f76..e58de119186a 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
@@ -876,6 +876,8 @@ static int mchp_sparx5_probe(struct platform_device *pdev)
 
 cleanup_ports:
 	sparx5_cleanup_ports(sparx5);
+	if (sparx5->mact_queue)
+		destroy_workqueue(sparx5->mact_queue);
 cleanup_config:
 	kfree(configs);
 cleanup_pnode:
@@ -900,6 +902,7 @@ static int mchp_sparx5_remove(struct platform_device *pdev)
 	sparx5_cleanup_ports(sparx5);
 	/* Unregister netdevs */
 	sparx5_unregister_notifier_blocks(sparx5);
+	destroy_workqueue(sparx5->mact_queue);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c b/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
index 21844beba72d..0ce0fc985222 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
@@ -234,9 +234,8 @@ int sparx5_port_xmit_impl(struct sk_buff *skb, struct net_device *dev)
 	sparx5_set_port_ifh(ifh, port->portno);
 
 	if (sparx5->ptp && skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) {
-		ret = sparx5_ptp_txtstamp_request(port, skb);
-		if (ret)
-			return ret;
+		if (sparx5_ptp_txtstamp_request(port, skb) < 0)
+			return NETDEV_TX_BUSY;
 
 		sparx5_set_port_ifh_rew_op(ifh, SPARX5_SKB_CB(skb)->rew_op);
 		sparx5_set_port_ifh_pdu_type(ifh, SPARX5_SKB_CB(skb)->pdu_type);
@@ -250,23 +249,31 @@ int sparx5_port_xmit_impl(struct sk_buff *skb, struct net_device *dev)
 	else
 		ret = sparx5_inject(sparx5, ifh, skb, dev);
 
-	if (ret == NETDEV_TX_OK) {
-		stats->tx_bytes += skb->len;
-		stats->tx_packets++;
+	if (ret == -EBUSY)
+		goto busy;
+	if (ret < 0)
+		goto drop;
 
-		if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP &&
-		    SPARX5_SKB_CB(skb)->rew_op == IFH_REW_OP_TWO_STEP_PTP)
-			return ret;
+	stats->tx_bytes += skb->len;
+	stats->tx_packets++;
+	sparx5->tx.packets++;
 
-		dev_kfree_skb_any(skb);
-	} else {
-		stats->tx_dropped++;
+	if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP &&
+	    SPARX5_SKB_CB(skb)->rew_op == IFH_REW_OP_TWO_STEP_PTP)
+		return NETDEV_TX_OK;
 
-		if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP &&
-		    SPARX5_SKB_CB(skb)->rew_op == IFH_REW_OP_TWO_STEP_PTP)
-			sparx5_ptp_txtstamp_release(port, skb);
-	}
-	return ret;
+	dev_consume_skb_any(skb);
+	return NETDEV_TX_OK;
+drop:
+	stats->tx_dropped++;
+	sparx5->tx.dropped++;
+	dev_kfree_skb_any(skb);
+	return NETDEV_TX_OK;
+busy:
+	if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP &&
+	    SPARX5_SKB_CB(skb)->rew_op == IFH_REW_OP_TWO_STEP_PTP)
+		sparx5_ptp_txtstamp_release(port, skb);
+	return NETDEV_TX_BUSY;
 }
 
 static enum hrtimer_restart sparx5_injection_timeout(struct hrtimer *tmr)
diff --git a/drivers/net/ethernet/microsoft/mana/gdma.h b/drivers/net/ethernet/microsoft/mana/gdma.h
index 4a6efe6ada08..65c24ee49efd 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma.h
+++ b/drivers/net/ethernet/microsoft/mana/gdma.h
@@ -498,7 +498,14 @@ enum {
 
 #define GDMA_DRV_CAP_FLAG_1_EQ_SHARING_MULTI_VPORT BIT(0)
 
-#define GDMA_DRV_CAP_FLAGS1 GDMA_DRV_CAP_FLAG_1_EQ_SHARING_MULTI_VPORT
+/* Advertise to the NIC firmware: the NAPI work_done variable race is fixed,
+ * so the driver is able to reliably support features like busy_poll.
+ */
+#define GDMA_DRV_CAP_FLAG_1_NAPI_WKDONE_FIX BIT(2)
+
+#define GDMA_DRV_CAP_FLAGS1 \
+	(GDMA_DRV_CAP_FLAG_1_EQ_SHARING_MULTI_VPORT | \
+	 GDMA_DRV_CAP_FLAG_1_NAPI_WKDONE_FIX)
 
 #define GDMA_DRV_CAP_FLAGS2 0
 
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 9259a74eca40..27a0f3af8aab 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -1303,10 +1303,11 @@ static void mana_poll_rx_cq(struct mana_cq *cq)
 		xdp_do_flush();
 }
 
-static void mana_cq_handler(void *context, struct gdma_queue *gdma_queue)
+static int mana_cq_handler(void *context, struct gdma_queue *gdma_queue)
 {
 	struct mana_cq *cq = context;
 	u8 arm_bit;
+	int w;
 
 	WARN_ON_ONCE(cq->gdma_cq != gdma_queue);
 
@@ -1315,26 +1316,31 @@ static void mana_cq_handler(void *context, struct gdma_queue *gdma_queue)
 	else
 		mana_poll_tx_cq(cq);
 
-	if (cq->work_done < cq->budget &&
-	    napi_complete_done(&cq->napi, cq->work_done)) {
+	w = cq->work_done;
+
+	if (w < cq->budget &&
+	    napi_complete_done(&cq->napi, w)) {
 		arm_bit = SET_ARM_BIT;
 	} else {
 		arm_bit = 0;
 	}
 
 	mana_gd_ring_cq(gdma_queue, arm_bit);
+
+	return w;
 }
 
 static int mana_poll(struct napi_struct *napi, int budget)
 {
 	struct mana_cq *cq = container_of(napi, struct mana_cq, napi);
+	int w;
 
 	cq->work_done = 0;
 	cq->budget = budget;
 
-	mana_cq_handler(cq, cq->gdma_cq);
+	w = mana_cq_handler(cq, cq->gdma_cq);
 
-	return min(cq->work_done, budget);
+	return min(w, budget);
 }
 
 static void mana_schedule_napi(void *context, struct gdma_queue *gdma_queue)
diff --git a/drivers/net/ethernet/netronome/nfp/nfdk/dp.c b/drivers/net/ethernet/netronome/nfp/nfdk/dp.c
index 2b427d8ccb2f..ccacb6ab6c39 100644
--- a/drivers/net/ethernet/netronome/nfp/nfdk/dp.c
+++ b/drivers/net/ethernet/netronome/nfp/nfdk/dp.c
@@ -282,7 +282,7 @@ netdev_tx_t nfp_nfdk_tx(struct sk_buff *skb, struct net_device *netdev)
 	dma_len = skb_headlen(skb);
 	if (skb_is_gso(skb))
 		type = NFDK_DESC_TX_TYPE_TSO;
-	else if (!nr_frags && dma_len < NFDK_TX_MAX_DATA_PER_HEAD)
+	else if (!nr_frags && dma_len <= NFDK_TX_MAX_DATA_PER_HEAD)
 		type = NFDK_DESC_TX_TYPE_SIMPLE;
 	else
 		type = NFDK_DESC_TX_TYPE_GATHER;
@@ -927,7 +927,7 @@ nfp_nfdk_tx_xdp_buf(struct nfp_net_dp *dp, struct nfp_net_rx_ring *rx_ring,
 	dma_len = pkt_len;
 	dma_addr = rxbuf->dma_addr + dma_off;
 
-	if (dma_len < NFDK_TX_MAX_DATA_PER_HEAD)
+	if (dma_len <= NFDK_TX_MAX_DATA_PER_HEAD)
 		type = NFDK_DESC_TX_TYPE_SIMPLE;
 	else
 		type = NFDK_DESC_TX_TYPE_GATHER;
@@ -1325,7 +1325,7 @@ nfp_nfdk_ctrl_tx_one(struct nfp_net *nn, struct nfp_net_r_vector *r_vec,
 	txbuf = &tx_ring->ktxbufs[wr_idx];
 
 	dma_len = skb_headlen(skb);
-	if (dma_len < NFDK_TX_MAX_DATA_PER_HEAD)
+	if (dma_len <= NFDK_TX_MAX_DATA_PER_HEAD)
 		type = NFDK_DESC_TX_TYPE_SIMPLE;
 	else
 		type = NFDK_DESC_TX_TYPE_GATHER;
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 44f9b31f8b99..77d4f3eab971 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -835,7 +835,7 @@ static bool ravb_rx_gbeth(struct net_device *ndev, int *quota, int q)
 				napi_gro_receive(&priv->napi[q],
 						 priv->rx_1st_skb);
 				stats->rx_packets++;
-				stats->rx_bytes += priv->rx_1st_skb->len;
+				stats->rx_bytes += pkt_len;
 				break;
 			}
 		}
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 9f5cac4000da..5c234a8158c7 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -108,10 +108,10 @@ static struct stmmac_axi *stmmac_axi_setup(struct platform_device *pdev)
 
 	axi->axi_lpi_en = of_property_read_bool(np, "snps,lpi_en");
 	axi->axi_xit_frm = of_property_read_bool(np, "snps,xit_frm");
-	axi->axi_kbbe = of_property_read_bool(np, "snps,axi_kbbe");
-	axi->axi_fb = of_property_read_bool(np, "snps,axi_fb");
-	axi->axi_mb = of_property_read_bool(np, "snps,axi_mb");
-	axi->axi_rb =  of_property_read_bool(np, "snps,axi_rb");
+	axi->axi_kbbe = of_property_read_bool(np, "snps,kbbe");
+	axi->axi_fb = of_property_read_bool(np, "snps,fb");
+	axi->axi_mb = of_property_read_bool(np, "snps,mb");
+	axi->axi_rb =  of_property_read_bool(np, "snps,rb");
 
 	if (of_property_read_u32(np, "snps,wr_osr_lmt", &axi->axi_wr_osr_lmt))
 		axi->axi_wr_osr_lmt = 1;
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 95baacd6c761..47da11b9ac28 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1450,7 +1450,7 @@ static void am65_cpsw_nuss_mac_link_up(struct phylink_config *config, struct phy
 
 	if (speed == SPEED_1000)
 		mac_control |= CPSW_SL_CTL_GIG;
-	if (speed == SPEED_10 && interface == PHY_INTERFACE_MODE_RGMII)
+	if (speed == SPEED_10 && phy_interface_mode_is_rgmii(interface))
 		/* Can be used with in band mode only */
 		mac_control |= CPSW_SL_CTL_EXT_EN;
 	if (speed == SPEED_100 && interface == PHY_INTERFACE_MODE_RMII)
diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
index 450b16ad40a4..e1a569b99e4a 100644
--- a/drivers/net/ieee802154/ca8210.c
+++ b/drivers/net/ieee802154/ca8210.c
@@ -885,7 +885,7 @@ static int ca8210_spi_transfer(
 
 	dev_dbg(&spi->dev, "%s called\n", __func__);
 
-	cas_ctl = kmalloc(sizeof(*cas_ctl), GFP_ATOMIC);
+	cas_ctl = kzalloc(sizeof(*cas_ctl), GFP_ATOMIC);
 	if (!cas_ctl)
 		return -ENOMEM;
 
diff --git a/drivers/net/ieee802154/cc2520.c b/drivers/net/ieee802154/cc2520.c
index c69b87d3837d..edc769daad07 100644
--- a/drivers/net/ieee802154/cc2520.c
+++ b/drivers/net/ieee802154/cc2520.c
@@ -970,7 +970,7 @@ static int cc2520_hw_init(struct cc2520_private *priv)
 
 		if (timeout-- <= 0) {
 			dev_err(&priv->spi->dev, "oscillator start failed!\n");
-			return ret;
+			return -ETIMEDOUT;
 		}
 		udelay(1);
 	} while (!(status & CC2520_STATUS_XOSC32M_STABLE));
diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 104fc564a766..8dafc814282c 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -3720,6 +3720,7 @@ static const struct nla_policy macsec_rtnl_policy[IFLA_MACSEC_MAX + 1] = {
 	[IFLA_MACSEC_SCB] = { .type = NLA_U8 },
 	[IFLA_MACSEC_REPLAY_PROTECT] = { .type = NLA_U8 },
 	[IFLA_MACSEC_VALIDATION] = { .type = NLA_U8 },
+	[IFLA_MACSEC_OFFLOAD] = { .type = NLA_U8 },
 };
 
 static void macsec_free_netdev(struct net_device *dev)
diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
index 40e745a1d185..2c47efdae73b 100644
--- a/drivers/net/mdio/fwnode_mdio.c
+++ b/drivers/net/mdio/fwnode_mdio.c
@@ -77,6 +77,7 @@ int fwnode_mdiobus_phy_device_register(struct mii_bus *mdio,
 	 */
 	rc = phy_device_register(phy);
 	if (rc) {
+		device_set_node(&phy->mdio.dev, NULL);
 		fwnode_handle_put(child);
 		return rc;
 	}
@@ -110,8 +111,8 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 	else
 		phy = phy_device_create(bus, addr, phy_id, 0, NULL);
 	if (IS_ERR(phy)) {
-		unregister_mii_timestamper(mii_ts);
-		return PTR_ERR(phy);
+		rc = PTR_ERR(phy);
+		goto clean_mii_ts;
 	}
 
 	if (is_acpi_node(child)) {
@@ -125,17 +126,14 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 		/* All data is now stored in the phy struct, so register it */
 		rc = phy_device_register(phy);
 		if (rc) {
-			phy_device_free(phy);
-			fwnode_handle_put(phy->mdio.dev.fwnode);
-			return rc;
+			phy->mdio.dev.fwnode = NULL;
+			fwnode_handle_put(child);
+			goto clean_phy;
 		}
 	} else if (is_of_node(child)) {
 		rc = fwnode_mdiobus_phy_device_register(bus, phy, child, addr);
-		if (rc) {
-			unregister_mii_timestamper(mii_ts);
-			phy_device_free(phy);
-			return rc;
-		}
+		if (rc)
+			goto clean_phy;
 	}
 
 	/* phy->mii_ts may already be defined by the PHY driver. A
@@ -145,5 +143,12 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 	if (mii_ts)
 		phy->mii_ts = mii_ts;
 	return 0;
+
+clean_phy:
+	phy_device_free(phy);
+clean_mii_ts:
+	unregister_mii_timestamper(mii_ts);
+
+	return rc;
 }
 EXPORT_SYMBOL(fwnode_mdiobus_register_phy);
diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index 796e9c7857d0..510822d6d0d9 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -68,8 +68,9 @@ static int of_mdiobus_register_device(struct mii_bus *mdio,
 	/* All data is now stored in the mdiodev struct; register it. */
 	rc = mdio_device_register(mdiodev);
 	if (rc) {
+		device_set_node(&mdiodev->dev, NULL);
+		fwnode_handle_put(fwnode);
 		mdio_device_free(mdiodev);
-		of_node_put(child);
 		return rc;
 	}
 
diff --git a/drivers/net/phy/mdio_device.c b/drivers/net/phy/mdio_device.c
index 250742ffdfd9..044828d081d2 100644
--- a/drivers/net/phy/mdio_device.c
+++ b/drivers/net/phy/mdio_device.c
@@ -21,6 +21,7 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/unistd.h>
+#include <linux/property.h>
 
 void mdio_device_free(struct mdio_device *mdiodev)
 {
@@ -30,6 +31,7 @@ EXPORT_SYMBOL(mdio_device_free);
 
 static void mdio_device_release(struct device *dev)
 {
+	fwnode_handle_put(dev->fwnode);
 	kfree(to_mdio_device(dev));
 }
 
diff --git a/drivers/net/phy/mxl-gpy.c b/drivers/net/phy/mxl-gpy.c
index 24bae27eedef..cae24091fb6f 100644
--- a/drivers/net/phy/mxl-gpy.c
+++ b/drivers/net/phy/mxl-gpy.c
@@ -9,6 +9,7 @@
 #include <linux/module.h>
 #include <linux/bitfield.h>
 #include <linux/hwmon.h>
+#include <linux/mutex.h>
 #include <linux/phy.h>
 #include <linux/polynomial.h>
 #include <linux/netdevice.h>
@@ -70,6 +71,14 @@
 #define VPSPEC1_TEMP_STA	0x0E
 #define VPSPEC1_TEMP_STA_DATA	GENMASK(9, 0)
 
+/* Mailbox */
+#define VSPEC1_MBOX_DATA	0x5
+#define VSPEC1_MBOX_ADDRLO	0x6
+#define VSPEC1_MBOX_CMD		0x7
+#define VSPEC1_MBOX_CMD_ADDRHI	GENMASK(7, 0)
+#define VSPEC1_MBOX_CMD_RD	(0 << 8)
+#define VSPEC1_MBOX_CMD_READY	BIT(15)
+
 /* WoL */
 #define VPSPEC2_WOL_CTL		0x0E06
 #define VPSPEC2_WOL_AD01	0x0E08
@@ -77,7 +86,13 @@
 #define VPSPEC2_WOL_AD45	0x0E0A
 #define WOL_EN			BIT(0)
 
+/* Internal registers, access via mbox */
+#define REG_GPIO0_OUT		0xd3ce00
+
 struct gpy_priv {
+	/* serialize mailbox acesses */
+	struct mutex mbox_lock;
+
 	u8 fw_major;
 	u8 fw_minor;
 };
@@ -187,6 +202,45 @@ static int gpy_hwmon_register(struct phy_device *phydev)
 }
 #endif
 
+static int gpy_mbox_read(struct phy_device *phydev, u32 addr)
+{
+	struct gpy_priv *priv = phydev->priv;
+	int val, ret;
+	u16 cmd;
+
+	mutex_lock(&priv->mbox_lock);
+
+	ret = phy_write_mmd(phydev, MDIO_MMD_VEND1, VSPEC1_MBOX_ADDRLO,
+			    addr);
+	if (ret)
+		goto out;
+
+	cmd = VSPEC1_MBOX_CMD_RD;
+	cmd |= FIELD_PREP(VSPEC1_MBOX_CMD_ADDRHI, addr >> 16);
+
+	ret = phy_write_mmd(phydev, MDIO_MMD_VEND1, VSPEC1_MBOX_CMD, cmd);
+	if (ret)
+		goto out;
+
+	/* The mbox read is used in the interrupt workaround. It was observed
+	 * that a read might take up to 2.5ms. This is also the time for which
+	 * the interrupt line is stuck low. To be on the safe side, poll the
+	 * ready bit for 10ms.
+	 */
+	ret = phy_read_mmd_poll_timeout(phydev, MDIO_MMD_VEND1,
+					VSPEC1_MBOX_CMD, val,
+					(val & VSPEC1_MBOX_CMD_READY),
+					500, 10000, false);
+	if (ret)
+		goto out;
+
+	ret = phy_read_mmd(phydev, MDIO_MMD_VEND1, VSPEC1_MBOX_DATA);
+
+out:
+	mutex_unlock(&priv->mbox_lock);
+	return ret;
+}
+
 static int gpy_config_init(struct phy_device *phydev)
 {
 	int ret;
@@ -201,6 +255,13 @@ static int gpy_config_init(struct phy_device *phydev)
 	return ret < 0 ? ret : 0;
 }
 
+static bool gpy_has_broken_mdint(struct phy_device *phydev)
+{
+	/* At least these PHYs are known to have broken interrupt handling */
+	return phydev->drv->phy_id == PHY_ID_GPY215B ||
+	       phydev->drv->phy_id == PHY_ID_GPY215C;
+}
+
 static int gpy_probe(struct phy_device *phydev)
 {
 	struct device *dev = &phydev->mdio.dev;
@@ -218,6 +279,7 @@ static int gpy_probe(struct phy_device *phydev)
 	if (!priv)
 		return -ENOMEM;
 	phydev->priv = priv;
+	mutex_init(&priv->mbox_lock);
 
 	fw_version = phy_read(phydev, PHY_FWV);
 	if (fw_version < 0)
@@ -492,6 +554,29 @@ static irqreturn_t gpy_handle_interrupt(struct phy_device *phydev)
 	if (!(reg & PHY_IMASK_MASK))
 		return IRQ_NONE;
 
+	/* The PHY might leave the interrupt line asserted even after PHY_ISTAT
+	 * is read. To avoid interrupt storms, delay the interrupt handling as
+	 * long as the PHY drives the interrupt line. An internal bus read will
+	 * stall as long as the interrupt line is asserted, thus just read a
+	 * random register here.
+	 * Because we cannot access the internal bus at all while the interrupt
+	 * is driven by the PHY, there is no way to make the interrupt line
+	 * unstuck (e.g. by changing the pinmux to GPIO input) during that time
+	 * frame. Therefore, polling is the best we can do and won't do any more
+	 * harm.
+	 * It was observed that this bug happens on link state and link speed
+	 * changes on a GPY215B and GYP215C independent of the firmware version
+	 * (which doesn't mean that this list is exhaustive).
+	 */
+	if (gpy_has_broken_mdint(phydev) &&
+	    (reg & (PHY_IMASK_LSTC | PHY_IMASK_LSPC))) {
+		reg = gpy_mbox_read(phydev, REG_GPIO0_OUT);
+		if (reg < 0) {
+			phy_error(phydev);
+			return IRQ_NONE;
+		}
+	}
+
 	phy_trigger_machine(phydev);
 
 	return IRQ_HANDLED;
diff --git a/drivers/net/plip/plip.c b/drivers/net/plip/plip.c
index c8791e9b451d..40ce8abe6999 100644
--- a/drivers/net/plip/plip.c
+++ b/drivers/net/plip/plip.c
@@ -450,12 +450,12 @@ plip_bh_timeout_error(struct net_device *dev, struct net_local *nl,
 	}
 	rcv->state = PLIP_PK_DONE;
 	if (rcv->skb) {
-		kfree_skb(rcv->skb);
+		dev_kfree_skb_irq(rcv->skb);
 		rcv->skb = NULL;
 	}
 	snd->state = PLIP_PK_DONE;
 	if (snd->skb) {
-		dev_kfree_skb(snd->skb);
+		dev_consume_skb_irq(snd->skb);
 		snd->skb = NULL;
 	}
 	spin_unlock_irq(&nl->lock);
diff --git a/drivers/net/thunderbolt.c b/drivers/net/thunderbolt.c
index 8391f8303499..1f4dcadc284c 100644
--- a/drivers/net/thunderbolt.c
+++ b/drivers/net/thunderbolt.c
@@ -902,6 +902,7 @@ static int tbnet_open(struct net_device *dev)
 				tbnet_start_poll, net);
 	if (!ring) {
 		netdev_err(dev, "failed to allocate Rx ring\n");
+		tb_xdomain_release_out_hopid(xd, hopid);
 		tb_ring_free(net->tx_ring.ring);
 		net->tx_ring.ring = NULL;
 		return -ENOMEM;
diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index afd6faa4c2ec..554d4e2a84a4 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1423,6 +1423,7 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x0489, 0xe0b4, 0)},	/* Foxconn T77W968 LTE */
 	{QMI_FIXED_INTF(0x0489, 0xe0b5, 0)},	/* Foxconn T77W968 LTE with eSIM support*/
 	{QMI_FIXED_INTF(0x2692, 0x9025, 4)},    /* Cellient MPL200 (rebranded Qualcomm 05c6:9025) */
+	{QMI_QUIRK_SET_DTR(0x1546, 0x1342, 4)},	/* u-blox LARA-L6 */
 
 	/* 4. Gobi 1000 devices */
 	{QMI_GOBI1K_DEVICE(0x05c6, 0x9212)},	/* Acer Gobi Modem Device */
diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 53b3b241e027..c28c4a654615 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -75,8 +75,14 @@ vmxnet3_enable_all_intrs(struct vmxnet3_adapter *adapter)
 
 	for (i = 0; i < adapter->intr.num_intrs; i++)
 		vmxnet3_enable_intr(adapter, i);
-	adapter->shared->devRead.intrConf.intrCtrl &=
+	if (!VMXNET3_VERSION_GE_6(adapter) ||
+	    !adapter->queuesExtEnabled) {
+		adapter->shared->devRead.intrConf.intrCtrl &=
+					cpu_to_le32(~VMXNET3_IC_DISABLE_ALL);
+	} else {
+		adapter->shared->devReadExt.intrConfExt.intrCtrl &=
 					cpu_to_le32(~VMXNET3_IC_DISABLE_ALL);
+	}
 }
 
 
@@ -85,8 +91,14 @@ vmxnet3_disable_all_intrs(struct vmxnet3_adapter *adapter)
 {
 	int i;
 
-	adapter->shared->devRead.intrConf.intrCtrl |=
+	if (!VMXNET3_VERSION_GE_6(adapter) ||
+	    !adapter->queuesExtEnabled) {
+		adapter->shared->devRead.intrConf.intrCtrl |=
+					cpu_to_le32(VMXNET3_IC_DISABLE_ALL);
+	} else {
+		adapter->shared->devReadExt.intrConfExt.intrCtrl |=
 					cpu_to_le32(VMXNET3_IC_DISABLE_ALL);
+	}
 	for (i = 0; i < adapter->intr.num_intrs; i++)
 		vmxnet3_disable_intr(adapter, i);
 }
@@ -1396,6 +1408,7 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
 	};
 	u32 num_pkts = 0;
 	bool skip_page_frags = false;
+	bool encap_lro = false;
 	struct Vmxnet3_RxCompDesc *rcd;
 	struct vmxnet3_rx_ctx *ctx = &rq->rx_ctx;
 	u16 segCnt = 0, mss = 0;
@@ -1556,13 +1569,18 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
 			if (VMXNET3_VERSION_GE_2(adapter) &&
 			    rcd->type == VMXNET3_CDTYPE_RXCOMP_LRO) {
 				struct Vmxnet3_RxCompDescExt *rcdlro;
+				union Vmxnet3_GenericDesc *gdesc;
+
 				rcdlro = (struct Vmxnet3_RxCompDescExt *)rcd;
+				gdesc = (union Vmxnet3_GenericDesc *)rcd;
 
 				segCnt = rcdlro->segCnt;
 				WARN_ON_ONCE(segCnt == 0);
 				mss = rcdlro->mss;
 				if (unlikely(segCnt <= 1))
 					segCnt = 0;
+				encap_lro = (le32_to_cpu(gdesc->dword[0]) &
+					(1UL << VMXNET3_RCD_HDR_INNER_SHIFT));
 			} else {
 				segCnt = 0;
 			}
@@ -1630,7 +1648,7 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
 			vmxnet3_rx_csum(adapter, skb,
 					(union Vmxnet3_GenericDesc *)rcd);
 			skb->protocol = eth_type_trans(skb, adapter->netdev);
-			if (!rcd->tcp ||
+			if ((!rcd->tcp && !encap_lro) ||
 			    !(adapter->netdev->features & NETIF_F_LRO))
 				goto not_lro;
 
@@ -1639,7 +1657,7 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
 					SKB_GSO_TCPV4 : SKB_GSO_TCPV6;
 				skb_shinfo(skb)->gso_size = mss;
 				skb_shinfo(skb)->gso_segs = segCnt;
-			} else if (segCnt != 0 || skb->len > mtu) {
+			} else if ((segCnt != 0 || skb->len > mtu) && !encap_lro) {
 				u32 hlen;
 
 				hlen = vmxnet3_get_hdr_len(adapter, skb,
@@ -1668,6 +1686,7 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
 				napi_gro_receive(&rq->napi, skb);
 
 			ctx->skb = NULL;
+			encap_lro = false;
 			num_pkts++;
 		}
 
diff --git a/drivers/net/wwan/iosm/iosm_ipc_mux.c b/drivers/net/wwan/iosm/iosm_ipc_mux.c
index 9c7a9a2a1f25..fc928b298a98 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_mux.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_mux.c
@@ -332,6 +332,7 @@ struct iosm_mux *ipc_mux_init(struct ipc_mux_config *mux_cfg,
 			if (!ipc_mux->ul_adb.pp_qlt[i]) {
 				for (j = i - 1; j >= 0; j--)
 					kfree(ipc_mux->ul_adb.pp_qlt[j]);
+				kfree(ipc_mux);
 				return NULL;
 			}
 		}
diff --git a/drivers/net/xen-netback/common.h b/drivers/net/xen-netback/common.h
index 8174d7b2966c..adfd21aa5b6a 100644
--- a/drivers/net/xen-netback/common.h
+++ b/drivers/net/xen-netback/common.h
@@ -386,7 +386,7 @@ int xenvif_dealloc_kthread(void *data);
 irqreturn_t xenvif_ctrl_irq_fn(int irq, void *data);
 
 bool xenvif_have_rx_work(struct xenvif_queue *queue, bool test_kthread);
-void xenvif_rx_queue_tail(struct xenvif_queue *queue, struct sk_buff *skb);
+bool xenvif_rx_queue_tail(struct xenvif_queue *queue, struct sk_buff *skb);
 
 void xenvif_carrier_on(struct xenvif *vif);
 
diff --git a/drivers/net/xen-netback/interface.c b/drivers/net/xen-netback/interface.c
index fb32ae82d9b0..d048a5cc918b 100644
--- a/drivers/net/xen-netback/interface.c
+++ b/drivers/net/xen-netback/interface.c
@@ -254,14 +254,16 @@ xenvif_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (vif->hash.alg == XEN_NETIF_CTRL_HASH_ALGORITHM_NONE)
 		skb_clear_hash(skb);
 
-	xenvif_rx_queue_tail(queue, skb);
+	if (!xenvif_rx_queue_tail(queue, skb))
+		goto drop;
+
 	xenvif_kick_thread(queue);
 
 	return NETDEV_TX_OK;
 
  drop:
 	vif->dev->stats.tx_dropped++;
-	dev_kfree_skb(skb);
+	dev_kfree_skb_any(skb);
 	return NETDEV_TX_OK;
 }
 
diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index a256695fc89e..82d7910f7ade 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -332,10 +332,13 @@ static int xenvif_count_requests(struct xenvif_queue *queue,
 
 
 struct xenvif_tx_cb {
-	u16 pending_idx;
+	u16 copy_pending_idx[XEN_NETBK_LEGACY_SLOTS_MAX + 1];
+	u8 copy_count;
 };
 
 #define XENVIF_TX_CB(skb) ((struct xenvif_tx_cb *)(skb)->cb)
+#define copy_pending_idx(skb, i) (XENVIF_TX_CB(skb)->copy_pending_idx[i])
+#define copy_count(skb) (XENVIF_TX_CB(skb)->copy_count)
 
 static inline void xenvif_tx_create_map_op(struct xenvif_queue *queue,
 					   u16 pending_idx,
@@ -370,31 +373,93 @@ static inline struct sk_buff *xenvif_alloc_skb(unsigned int size)
 	return skb;
 }
 
-static struct gnttab_map_grant_ref *xenvif_get_requests(struct xenvif_queue *queue,
-							struct sk_buff *skb,
-							struct xen_netif_tx_request *txp,
-							struct gnttab_map_grant_ref *gop,
-							unsigned int frag_overflow,
-							struct sk_buff *nskb)
+static void xenvif_get_requests(struct xenvif_queue *queue,
+				struct sk_buff *skb,
+				struct xen_netif_tx_request *first,
+				struct xen_netif_tx_request *txfrags,
+			        unsigned *copy_ops,
+			        unsigned *map_ops,
+				unsigned int frag_overflow,
+				struct sk_buff *nskb,
+				unsigned int extra_count,
+				unsigned int data_len)
 {
 	struct skb_shared_info *shinfo = skb_shinfo(skb);
 	skb_frag_t *frags = shinfo->frags;
-	u16 pending_idx = XENVIF_TX_CB(skb)->pending_idx;
-	int start;
+	u16 pending_idx;
 	pending_ring_idx_t index;
 	unsigned int nr_slots;
+	struct gnttab_copy *cop = queue->tx_copy_ops + *copy_ops;
+	struct gnttab_map_grant_ref *gop = queue->tx_map_ops + *map_ops;
+	struct xen_netif_tx_request *txp = first;
+
+	nr_slots = shinfo->nr_frags + 1;
+
+	copy_count(skb) = 0;
+
+	/* Create copy ops for exactly data_len bytes into the skb head. */
+	__skb_put(skb, data_len);
+	while (data_len > 0) {
+		int amount = data_len > txp->size ? txp->size : data_len;
+
+		cop->source.u.ref = txp->gref;
+		cop->source.domid = queue->vif->domid;
+		cop->source.offset = txp->offset;
+
+		cop->dest.domid = DOMID_SELF;
+		cop->dest.offset = (offset_in_page(skb->data +
+						   skb_headlen(skb) -
+						   data_len)) & ~XEN_PAGE_MASK;
+		cop->dest.u.gmfn = virt_to_gfn(skb->data + skb_headlen(skb)
+				               - data_len);
+
+		cop->len = amount;
+		cop->flags = GNTCOPY_source_gref;
 
-	nr_slots = shinfo->nr_frags;
+		index = pending_index(queue->pending_cons);
+		pending_idx = queue->pending_ring[index];
+		callback_param(queue, pending_idx).ctx = NULL;
+		copy_pending_idx(skb, copy_count(skb)) = pending_idx;
+		copy_count(skb)++;
+
+		cop++;
+		data_len -= amount;
 
-	/* Skip first skb fragment if it is on same page as header fragment. */
-	start = (frag_get_pending_idx(&shinfo->frags[0]) == pending_idx);
+		if (amount == txp->size) {
+			/* The copy op covered the full tx_request */
+
+			memcpy(&queue->pending_tx_info[pending_idx].req,
+			       txp, sizeof(*txp));
+			queue->pending_tx_info[pending_idx].extra_count =
+				(txp == first) ? extra_count : 0;
+
+			if (txp == first)
+				txp = txfrags;
+			else
+				txp++;
+			queue->pending_cons++;
+			nr_slots--;
+		} else {
+			/* The copy op partially covered the tx_request.
+			 * The remainder will be mapped.
+			 */
+			txp->offset += amount;
+			txp->size -= amount;
+		}
+	}
 
-	for (shinfo->nr_frags = start; shinfo->nr_frags < nr_slots;
-	     shinfo->nr_frags++, txp++, gop++) {
+	for (shinfo->nr_frags = 0; shinfo->nr_frags < nr_slots;
+	     shinfo->nr_frags++, gop++) {
 		index = pending_index(queue->pending_cons++);
 		pending_idx = queue->pending_ring[index];
-		xenvif_tx_create_map_op(queue, pending_idx, txp, 0, gop);
+		xenvif_tx_create_map_op(queue, pending_idx, txp,
+				        txp == first ? extra_count : 0, gop);
 		frag_set_pending_idx(&frags[shinfo->nr_frags], pending_idx);
+
+		if (txp == first)
+			txp = txfrags;
+		else
+			txp++;
 	}
 
 	if (frag_overflow) {
@@ -415,7 +480,8 @@ static struct gnttab_map_grant_ref *xenvif_get_requests(struct xenvif_queue *que
 		skb_shinfo(skb)->frag_list = nskb;
 	}
 
-	return gop;
+	(*copy_ops) = cop - queue->tx_copy_ops;
+	(*map_ops) = gop - queue->tx_map_ops;
 }
 
 static inline void xenvif_grant_handle_set(struct xenvif_queue *queue,
@@ -451,7 +517,7 @@ static int xenvif_tx_check_gop(struct xenvif_queue *queue,
 			       struct gnttab_copy **gopp_copy)
 {
 	struct gnttab_map_grant_ref *gop_map = *gopp_map;
-	u16 pending_idx = XENVIF_TX_CB(skb)->pending_idx;
+	u16 pending_idx;
 	/* This always points to the shinfo of the skb being checked, which
 	 * could be either the first or the one on the frag_list
 	 */
@@ -462,24 +528,37 @@ static int xenvif_tx_check_gop(struct xenvif_queue *queue,
 	struct skb_shared_info *first_shinfo = NULL;
 	int nr_frags = shinfo->nr_frags;
 	const bool sharedslot = nr_frags &&
-				frag_get_pending_idx(&shinfo->frags[0]) == pending_idx;
-	int i, err;
+				frag_get_pending_idx(&shinfo->frags[0]) ==
+				    copy_pending_idx(skb, copy_count(skb) - 1);
+	int i, err = 0;
 
-	/* Check status of header. */
-	err = (*gopp_copy)->status;
-	if (unlikely(err)) {
-		if (net_ratelimit())
-			netdev_dbg(queue->vif->dev,
-				   "Grant copy of header failed! status: %d pending_idx: %u ref: %u\n",
-				   (*gopp_copy)->status,
-				   pending_idx,
-				   (*gopp_copy)->source.u.ref);
-		/* The first frag might still have this slot mapped */
-		if (!sharedslot)
-			xenvif_idx_release(queue, pending_idx,
-					   XEN_NETIF_RSP_ERROR);
+	for (i = 0; i < copy_count(skb); i++) {
+		int newerr;
+
+		/* Check status of header. */
+		pending_idx = copy_pending_idx(skb, i);
+
+		newerr = (*gopp_copy)->status;
+		if (likely(!newerr)) {
+			/* The first frag might still have this slot mapped */
+			if (i < copy_count(skb) - 1 || !sharedslot)
+				xenvif_idx_release(queue, pending_idx,
+						   XEN_NETIF_RSP_OKAY);
+		} else {
+			err = newerr;
+			if (net_ratelimit())
+				netdev_dbg(queue->vif->dev,
+					   "Grant copy of header failed! status: %d pending_idx: %u ref: %u\n",
+					   (*gopp_copy)->status,
+					   pending_idx,
+					   (*gopp_copy)->source.u.ref);
+			/* The first frag might still have this slot mapped */
+			if (i < copy_count(skb) - 1 || !sharedslot)
+				xenvif_idx_release(queue, pending_idx,
+						   XEN_NETIF_RSP_ERROR);
+		}
+		(*gopp_copy)++;
 	}
-	(*gopp_copy)++;
 
 check_frags:
 	for (i = 0; i < nr_frags; i++, gop_map++) {
@@ -526,14 +605,6 @@ static int xenvif_tx_check_gop(struct xenvif_queue *queue,
 		if (err)
 			continue;
 
-		/* First error: if the header haven't shared a slot with the
-		 * first frag, release it as well.
-		 */
-		if (!sharedslot)
-			xenvif_idx_release(queue,
-					   XENVIF_TX_CB(skb)->pending_idx,
-					   XEN_NETIF_RSP_OKAY);
-
 		/* Invalidate preceding fragments of this skb. */
 		for (j = 0; j < i; j++) {
 			pending_idx = frag_get_pending_idx(&shinfo->frags[j]);
@@ -803,7 +874,6 @@ static void xenvif_tx_build_gops(struct xenvif_queue *queue,
 				     unsigned *copy_ops,
 				     unsigned *map_ops)
 {
-	struct gnttab_map_grant_ref *gop = queue->tx_map_ops;
 	struct sk_buff *skb, *nskb;
 	int ret;
 	unsigned int frag_overflow;
@@ -885,8 +955,12 @@ static void xenvif_tx_build_gops(struct xenvif_queue *queue,
 			continue;
 		}
 
+		data_len = (txreq.size > XEN_NETBACK_TX_COPY_LEN) ?
+			XEN_NETBACK_TX_COPY_LEN : txreq.size;
+
 		ret = xenvif_count_requests(queue, &txreq, extra_count,
 					    txfrags, work_to_do);
+
 		if (unlikely(ret < 0))
 			break;
 
@@ -912,9 +986,8 @@ static void xenvif_tx_build_gops(struct xenvif_queue *queue,
 		index = pending_index(queue->pending_cons);
 		pending_idx = queue->pending_ring[index];
 
-		data_len = (txreq.size > XEN_NETBACK_TX_COPY_LEN &&
-			    ret < XEN_NETBK_LEGACY_SLOTS_MAX) ?
-			XEN_NETBACK_TX_COPY_LEN : txreq.size;
+		if (ret >= XEN_NETBK_LEGACY_SLOTS_MAX - 1 && data_len < txreq.size)
+			data_len = txreq.size;
 
 		skb = xenvif_alloc_skb(data_len);
 		if (unlikely(skb == NULL)) {
@@ -925,8 +998,6 @@ static void xenvif_tx_build_gops(struct xenvif_queue *queue,
 		}
 
 		skb_shinfo(skb)->nr_frags = ret;
-		if (data_len < txreq.size)
-			skb_shinfo(skb)->nr_frags++;
 		/* At this point shinfo->nr_frags is in fact the number of
 		 * slots, which can be as large as XEN_NETBK_LEGACY_SLOTS_MAX.
 		 */
@@ -988,54 +1059,19 @@ static void xenvif_tx_build_gops(struct xenvif_queue *queue,
 					     type);
 		}
 
-		XENVIF_TX_CB(skb)->pending_idx = pending_idx;
-
-		__skb_put(skb, data_len);
-		queue->tx_copy_ops[*copy_ops].source.u.ref = txreq.gref;
-		queue->tx_copy_ops[*copy_ops].source.domid = queue->vif->domid;
-		queue->tx_copy_ops[*copy_ops].source.offset = txreq.offset;
-
-		queue->tx_copy_ops[*copy_ops].dest.u.gmfn =
-			virt_to_gfn(skb->data);
-		queue->tx_copy_ops[*copy_ops].dest.domid = DOMID_SELF;
-		queue->tx_copy_ops[*copy_ops].dest.offset =
-			offset_in_page(skb->data) & ~XEN_PAGE_MASK;
-
-		queue->tx_copy_ops[*copy_ops].len = data_len;
-		queue->tx_copy_ops[*copy_ops].flags = GNTCOPY_source_gref;
-
-		(*copy_ops)++;
-
-		if (data_len < txreq.size) {
-			frag_set_pending_idx(&skb_shinfo(skb)->frags[0],
-					     pending_idx);
-			xenvif_tx_create_map_op(queue, pending_idx, &txreq,
-						extra_count, gop);
-			gop++;
-		} else {
-			frag_set_pending_idx(&skb_shinfo(skb)->frags[0],
-					     INVALID_PENDING_IDX);
-			memcpy(&queue->pending_tx_info[pending_idx].req,
-			       &txreq, sizeof(txreq));
-			queue->pending_tx_info[pending_idx].extra_count =
-				extra_count;
-		}
-
-		queue->pending_cons++;
-
-		gop = xenvif_get_requests(queue, skb, txfrags, gop,
-				          frag_overflow, nskb);
+		xenvif_get_requests(queue, skb, &txreq, txfrags, copy_ops,
+				    map_ops, frag_overflow, nskb, extra_count,
+				    data_len);
 
 		__skb_queue_tail(&queue->tx_queue, skb);
 
 		queue->tx.req_cons = idx;
 
-		if (((gop-queue->tx_map_ops) >= ARRAY_SIZE(queue->tx_map_ops)) ||
+		if ((*map_ops >= ARRAY_SIZE(queue->tx_map_ops)) ||
 		    (*copy_ops >= ARRAY_SIZE(queue->tx_copy_ops)))
 			break;
 	}
 
-	(*map_ops) = gop - queue->tx_map_ops;
 	return;
 }
 
@@ -1114,9 +1150,8 @@ static int xenvif_tx_submit(struct xenvif_queue *queue)
 	while ((skb = __skb_dequeue(&queue->tx_queue)) != NULL) {
 		struct xen_netif_tx_request *txp;
 		u16 pending_idx;
-		unsigned data_len;
 
-		pending_idx = XENVIF_TX_CB(skb)->pending_idx;
+		pending_idx = copy_pending_idx(skb, 0);
 		txp = &queue->pending_tx_info[pending_idx].req;
 
 		/* Check the remap error code. */
@@ -1135,18 +1170,6 @@ static int xenvif_tx_submit(struct xenvif_queue *queue)
 			continue;
 		}
 
-		data_len = skb->len;
-		callback_param(queue, pending_idx).ctx = NULL;
-		if (data_len < txp->size) {
-			/* Append the packet payload as a fragment. */
-			txp->offset += data_len;
-			txp->size -= data_len;
-		} else {
-			/* Schedule a response immediately. */
-			xenvif_idx_release(queue, pending_idx,
-					   XEN_NETIF_RSP_OKAY);
-		}
-
 		if (txp->flags & XEN_NETTXF_csum_blank)
 			skb->ip_summed = CHECKSUM_PARTIAL;
 		else if (txp->flags & XEN_NETTXF_data_validated)
@@ -1331,7 +1354,7 @@ static inline void xenvif_tx_dealloc_action(struct xenvif_queue *queue)
 /* Called after netfront has transmitted */
 int xenvif_tx_action(struct xenvif_queue *queue, int budget)
 {
-	unsigned nr_mops, nr_cops = 0;
+	unsigned nr_mops = 0, nr_cops = 0;
 	int work_done, ret;
 
 	if (unlikely(!tx_work_todo(queue)))
diff --git a/drivers/net/xen-netback/rx.c b/drivers/net/xen-netback/rx.c
index 932762177110..0ba754ebc5ba 100644
--- a/drivers/net/xen-netback/rx.c
+++ b/drivers/net/xen-netback/rx.c
@@ -82,9 +82,10 @@ static bool xenvif_rx_ring_slots_available(struct xenvif_queue *queue)
 	return false;
 }
 
-void xenvif_rx_queue_tail(struct xenvif_queue *queue, struct sk_buff *skb)
+bool xenvif_rx_queue_tail(struct xenvif_queue *queue, struct sk_buff *skb)
 {
 	unsigned long flags;
+	bool ret = true;
 
 	spin_lock_irqsave(&queue->rx_queue.lock, flags);
 
@@ -92,8 +93,7 @@ void xenvif_rx_queue_tail(struct xenvif_queue *queue, struct sk_buff *skb)
 		struct net_device *dev = queue->vif->dev;
 
 		netif_tx_stop_queue(netdev_get_tx_queue(dev, queue->id));
-		kfree_skb(skb);
-		queue->vif->dev->stats.rx_dropped++;
+		ret = false;
 	} else {
 		if (skb_queue_empty(&queue->rx_queue))
 			xenvif_update_needed_slots(queue, skb);
@@ -104,6 +104,8 @@ void xenvif_rx_queue_tail(struct xenvif_queue *queue, struct sk_buff *skb)
 	}
 
 	spin_unlock_irqrestore(&queue->rx_queue.lock, flags);
+
+	return ret;
 }
 
 static struct sk_buff *xenvif_rx_dequeue(struct xenvif_queue *queue)
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 27a11cc08c61..479e215159fc 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1862,6 +1862,12 @@ static int netfront_resume(struct xenbus_device *dev)
 	netif_tx_unlock_bh(info->netdev);
 
 	xennet_disconnect_backend(info);
+
+	rtnl_lock();
+	if (info->queues)
+		xennet_destroy_queues(info);
+	rtnl_unlock();
+
 	return 0;
 }
 
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index f612a0ba64d0..aca50bb93750 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3089,10 +3089,6 @@ static int nvme_init_identify(struct nvme_ctrl *ctrl)
 	if (!ctrl->identified) {
 		unsigned int i;
 
-		ret = nvme_init_subsystem(ctrl, id);
-		if (ret)
-			goto out_free;
-
 		/*
 		 * Check for quirks.  Quirk can depend on firmware version,
 		 * so, in principle, the set of quirks present can change
@@ -3105,6 +3101,10 @@ static int nvme_init_identify(struct nvme_ctrl *ctrl)
 			if (quirk_matches(id, &core_quirks[i]))
 				ctrl->quirks |= core_quirks[i].quirks;
 		}
+
+		ret = nvme_init_subsystem(ctrl, id);
+		if (ret)
+			goto out_free;
 	}
 	memcpy(ctrl->subsys->firmware_rev, id->fr,
 	       sizeof(ctrl->subsys->firmware_rev));
diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
index 478dd300b9c9..d9e7cf6e4a0e 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -115,12 +115,17 @@ static struct quirk_entry quirk_asus_forceals = {
 };
 
 static struct quirk_entry quirk_asus_use_kbd_dock_devid = {
-	.use_kbd_dock_devid = true,
+	.tablet_switch_mode = asus_wmi_kbd_dock_devid,
 };
 
 static struct quirk_entry quirk_asus_use_lid_flip_devid = {
 	.wmi_backlight_set_devstate = true,
-	.use_lid_flip_devid = true,
+	.tablet_switch_mode = asus_wmi_lid_flip_devid,
+};
+
+static struct quirk_entry quirk_asus_tablet_mode = {
+	.wmi_backlight_set_devstate = true,
+	.tablet_switch_mode = asus_wmi_lid_flip_rog_devid,
 };
 
 static int dmi_matched(const struct dmi_system_id *dmi)
@@ -471,6 +476,15 @@ static const struct dmi_system_id asus_quirks[] = {
 		},
 		.driver_data = &quirk_asus_use_lid_flip_devid,
 	},
+	{
+		.callback = dmi_matched,
+		.ident = "ASUS ROG FLOW X13",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "GV301Q"),
+		},
+		.driver_data = &quirk_asus_tablet_mode,
+	},
 	{},
 };
 
@@ -492,16 +506,13 @@ static void asus_nb_wmi_quirks(struct asus_wmi_driver *driver)
 
 	switch (tablet_mode_sw) {
 	case 0:
-		quirks->use_kbd_dock_devid = false;
-		quirks->use_lid_flip_devid = false;
+		quirks->tablet_switch_mode = asus_wmi_no_tablet_switch;
 		break;
 	case 1:
-		quirks->use_kbd_dock_devid = true;
-		quirks->use_lid_flip_devid = false;
+		quirks->tablet_switch_mode = asus_wmi_kbd_dock_devid;
 		break;
 	case 2:
-		quirks->use_kbd_dock_devid = false;
-		quirks->use_lid_flip_devid = true;
+		quirks->tablet_switch_mode = asus_wmi_lid_flip_devid;
 		break;
 	}
 
@@ -581,6 +592,7 @@ static const struct key_entry asus_nb_wmi_keymap[] = {
 	{ KE_KEY, 0xC5, { KEY_KBDILLUMDOWN } },
 	{ KE_IGNORE, 0xC6, },  /* Ambient Light Sensor notification */
 	{ KE_KEY, 0xFA, { KEY_PROG2 } },           /* Lid flip action */
+	{ KE_KEY, 0xBD, { KEY_PROG2 } },           /* Lid flip action on ROG xflow laptops */
 	{ KE_END, 0},
 };
 
diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index 8e1979b477a7..dce93187e11f 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -68,6 +68,7 @@ module_param(fnlock_default, bool, 0444);
 #define NOTIFY_KBD_FBM			0x99
 #define NOTIFY_KBD_TTP			0xae
 #define NOTIFY_LID_FLIP			0xfa
+#define NOTIFY_LID_FLIP_ROG		0xbd
 
 #define ASUS_WMI_FNLOCK_BIOS_DISABLED	BIT(0)
 
@@ -489,8 +490,11 @@ static bool asus_wmi_dev_is_present(struct asus_wmi *asus, u32 dev_id)
 
 static int asus_wmi_input_init(struct asus_wmi *asus)
 {
+	struct device *dev;
 	int err, result;
 
+	dev = &asus->platform_device->dev;
+
 	asus->inputdev = input_allocate_device();
 	if (!asus->inputdev)
 		return -ENOMEM;
@@ -498,35 +502,51 @@ static int asus_wmi_input_init(struct asus_wmi *asus)
 	asus->inputdev->name = asus->driver->input_name;
 	asus->inputdev->phys = asus->driver->input_phys;
 	asus->inputdev->id.bustype = BUS_HOST;
-	asus->inputdev->dev.parent = &asus->platform_device->dev;
+	asus->inputdev->dev.parent = dev;
 	set_bit(EV_REP, asus->inputdev->evbit);
 
 	err = sparse_keymap_setup(asus->inputdev, asus->driver->keymap, NULL);
 	if (err)
 		goto err_free_dev;
 
-	if (asus->driver->quirks->use_kbd_dock_devid) {
+	switch (asus->driver->quirks->tablet_switch_mode) {
+	case asus_wmi_no_tablet_switch:
+		break;
+	case asus_wmi_kbd_dock_devid:
 		result = asus_wmi_get_devstate_simple(asus, ASUS_WMI_DEVID_KBD_DOCK);
 		if (result >= 0) {
 			input_set_capability(asus->inputdev, EV_SW, SW_TABLET_MODE);
 			input_report_switch(asus->inputdev, SW_TABLET_MODE, !result);
 		} else if (result != -ENODEV) {
-			pr_err("Error checking for keyboard-dock: %d\n", result);
+			dev_err(dev, "Error checking for keyboard-dock: %d\n", result);
 		}
-	}
-
-	if (asus->driver->quirks->use_lid_flip_devid) {
+		break;
+	case asus_wmi_lid_flip_devid:
 		result = asus_wmi_get_devstate_simple(asus, ASUS_WMI_DEVID_LID_FLIP);
 		if (result < 0)
-			asus->driver->quirks->use_lid_flip_devid = 0;
+			asus->driver->quirks->tablet_switch_mode = asus_wmi_no_tablet_switch;
+		if (result >= 0) {
+			input_set_capability(asus->inputdev, EV_SW, SW_TABLET_MODE);
+			input_report_switch(asus->inputdev, SW_TABLET_MODE, result);
+		} else if (result == -ENODEV) {
+			dev_err(dev, "This device has lid_flip quirk but got ENODEV checking it. This is a bug.");
+		} else {
+			dev_err(dev, "Error checking for lid-flip: %d\n", result);
+		}
+		break;
+	case asus_wmi_lid_flip_rog_devid:
+		result = asus_wmi_get_devstate_simple(asus, ASUS_WMI_DEVID_LID_FLIP_ROG);
+		if (result < 0)
+			asus->driver->quirks->tablet_switch_mode = asus_wmi_no_tablet_switch;
 		if (result >= 0) {
 			input_set_capability(asus->inputdev, EV_SW, SW_TABLET_MODE);
 			input_report_switch(asus->inputdev, SW_TABLET_MODE, result);
 		} else if (result == -ENODEV) {
-			pr_err("This device has lid_flip quirk but got ENODEV checking it. This is a bug.");
+			dev_err(dev, "This device has lid-flip-rog quirk but got ENODEV checking it. This is a bug.");
 		} else {
-			pr_err("Error checking for lid-flip: %d\n", result);
+			dev_err(dev, "Error checking for lid-flip: %d\n", result);
 		}
+		break;
 	}
 
 	err = input_register_device(asus->inputdev);
@@ -552,8 +572,20 @@ static void asus_wmi_input_exit(struct asus_wmi *asus)
 
 static void lid_flip_tablet_mode_get_state(struct asus_wmi *asus)
 {
-	int result = asus_wmi_get_devstate_simple(asus, ASUS_WMI_DEVID_LID_FLIP);
+	int result;
 
+	result = asus_wmi_get_devstate_simple(asus, ASUS_WMI_DEVID_LID_FLIP);
+	if (result >= 0) {
+		input_report_switch(asus->inputdev, SW_TABLET_MODE, result);
+		input_sync(asus->inputdev);
+	}
+}
+
+static void lid_flip_rog_tablet_mode_get_state(struct asus_wmi *asus)
+{
+	int result;
+
+	result = asus_wmi_get_devstate_simple(asus, ASUS_WMI_DEVID_LID_FLIP_ROG);
 	if (result >= 0) {
 		input_report_switch(asus->inputdev, SW_TABLET_MODE, result);
 		input_sync(asus->inputdev);
@@ -3109,7 +3141,8 @@ static void asus_wmi_handle_event_code(int code, struct asus_wmi *asus)
 		return;
 	}
 
-	if (asus->driver->quirks->use_kbd_dock_devid && code == NOTIFY_KBD_DOCK_CHANGE) {
+	if (asus->driver->quirks->tablet_switch_mode == asus_wmi_kbd_dock_devid &&
+	    code == NOTIFY_KBD_DOCK_CHANGE) {
 		result = asus_wmi_get_devstate_simple(asus,
 						      ASUS_WMI_DEVID_KBD_DOCK);
 		if (result >= 0) {
@@ -3120,11 +3153,18 @@ static void asus_wmi_handle_event_code(int code, struct asus_wmi *asus)
 		return;
 	}
 
-	if (asus->driver->quirks->use_lid_flip_devid && code == NOTIFY_LID_FLIP) {
+	if (asus->driver->quirks->tablet_switch_mode == asus_wmi_lid_flip_devid &&
+	    code == NOTIFY_LID_FLIP) {
 		lid_flip_tablet_mode_get_state(asus);
 		return;
 	}
 
+	if (asus->driver->quirks->tablet_switch_mode == asus_wmi_lid_flip_rog_devid &&
+	    code == NOTIFY_LID_FLIP_ROG) {
+		lid_flip_rog_tablet_mode_get_state(asus);
+		return;
+	}
+
 	if (asus->fan_boost_mode_available && code == NOTIFY_KBD_FBM) {
 		fan_boost_mode_switch_next(asus);
 		return;
@@ -3757,8 +3797,17 @@ static int asus_hotk_resume(struct device *device)
 	if (asus_wmi_has_fnlock_key(asus))
 		asus_wmi_fnlock_update(asus);
 
-	if (asus->driver->quirks->use_lid_flip_devid)
+	switch (asus->driver->quirks->tablet_switch_mode) {
+	case asus_wmi_no_tablet_switch:
+	case asus_wmi_kbd_dock_devid:
+		break;
+	case asus_wmi_lid_flip_devid:
 		lid_flip_tablet_mode_get_state(asus);
+		break;
+	case asus_wmi_lid_flip_rog_devid:
+		lid_flip_rog_tablet_mode_get_state(asus);
+		break;
+	}
 
 	return 0;
 }
@@ -3799,8 +3848,17 @@ static int asus_hotk_restore(struct device *device)
 	if (asus_wmi_has_fnlock_key(asus))
 		asus_wmi_fnlock_update(asus);
 
-	if (asus->driver->quirks->use_lid_flip_devid)
+	switch (asus->driver->quirks->tablet_switch_mode) {
+	case asus_wmi_no_tablet_switch:
+	case asus_wmi_kbd_dock_devid:
+		break;
+	case asus_wmi_lid_flip_devid:
 		lid_flip_tablet_mode_get_state(asus);
+		break;
+	case asus_wmi_lid_flip_rog_devid:
+		lid_flip_rog_tablet_mode_get_state(asus);
+		break;
+	}
 
 	return 0;
 }
diff --git a/drivers/platform/x86/asus-wmi.h b/drivers/platform/x86/asus-wmi.h
index b302415bf1d9..0187f13d2414 100644
--- a/drivers/platform/x86/asus-wmi.h
+++ b/drivers/platform/x86/asus-wmi.h
@@ -25,6 +25,13 @@ struct module;
 struct key_entry;
 struct asus_wmi;
 
+enum asus_wmi_tablet_switch_mode {
+	asus_wmi_no_tablet_switch,
+	asus_wmi_kbd_dock_devid,
+	asus_wmi_lid_flip_devid,
+	asus_wmi_lid_flip_rog_devid,
+};
+
 struct quirk_entry {
 	bool hotplug_wireless;
 	bool scalar_panel_brightness;
@@ -33,8 +40,7 @@ struct quirk_entry {
 	bool wmi_backlight_native;
 	bool wmi_backlight_set_devstate;
 	bool wmi_force_als_set;
-	bool use_kbd_dock_devid;
-	bool use_lid_flip_devid;
+	enum asus_wmi_tablet_switch_mode tablet_switch_mode;
 	int wapf;
 	/*
 	 * For machines with AMD graphic chips, it will send out WMI event
diff --git a/drivers/regulator/slg51000-regulator.c b/drivers/regulator/slg51000-regulator.c
index 75a941fb3c2b..1b2eee95ad3f 100644
--- a/drivers/regulator/slg51000-regulator.c
+++ b/drivers/regulator/slg51000-regulator.c
@@ -457,6 +457,8 @@ static int slg51000_i2c_probe(struct i2c_client *client)
 		chip->cs_gpiod = cs_gpiod;
 	}
 
+	usleep_range(10000, 11000);
+
 	i2c_set_clientdata(client, chip);
 	chip->chip_irq = client->irq;
 	chip->dev = dev;
diff --git a/drivers/regulator/twl6030-regulator.c b/drivers/regulator/twl6030-regulator.c
index 7c7e3648ea4b..f3856750944f 100644
--- a/drivers/regulator/twl6030-regulator.c
+++ b/drivers/regulator/twl6030-regulator.c
@@ -67,6 +67,7 @@ struct twlreg_info {
 #define TWL6030_CFG_STATE_SLEEP	0x03
 #define TWL6030_CFG_STATE_GRP_SHIFT	5
 #define TWL6030_CFG_STATE_APP_SHIFT	2
+#define TWL6030_CFG_STATE_MASK		0x03
 #define TWL6030_CFG_STATE_APP_MASK	(0x03 << TWL6030_CFG_STATE_APP_SHIFT)
 #define TWL6030_CFG_STATE_APP(v)	(((v) & TWL6030_CFG_STATE_APP_MASK) >>\
 						TWL6030_CFG_STATE_APP_SHIFT)
@@ -128,13 +129,14 @@ static int twl6030reg_is_enabled(struct regulator_dev *rdev)
 		if (grp < 0)
 			return grp;
 		grp &= P1_GRP_6030;
+		val = twlreg_read(info, TWL_MODULE_PM_RECEIVER, VREG_STATE);
+		val = TWL6030_CFG_STATE_APP(val);
 	} else {
+		val = twlreg_read(info, TWL_MODULE_PM_RECEIVER, VREG_STATE);
+		val &= TWL6030_CFG_STATE_MASK;
 		grp = 1;
 	}
 
-	val = twlreg_read(info, TWL_MODULE_PM_RECEIVER, VREG_STATE);
-	val = TWL6030_CFG_STATE_APP(val);
-
 	return grp && (val == TWL6030_CFG_STATE_ON);
 }
 
@@ -187,7 +189,12 @@ static int twl6030reg_get_status(struct regulator_dev *rdev)
 
 	val = twlreg_read(info, TWL_MODULE_PM_RECEIVER, VREG_STATE);
 
-	switch (TWL6030_CFG_STATE_APP(val)) {
+	if (info->features & TWL6032_SUBCLASS)
+		val &= TWL6030_CFG_STATE_MASK;
+	else
+		val = TWL6030_CFG_STATE_APP(val);
+
+	switch (val) {
 	case TWL6030_CFG_STATE_ON:
 		return REGULATOR_STATUS_NORMAL;
 
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 2d4436cbcb47..b38024a79376 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -758,7 +758,6 @@ static void qeth_l2_br2dev_worker(struct work_struct *work)
 	struct list_head *iter;
 	int err = 0;
 
-	kfree(br2dev_event_work);
 	QETH_CARD_TEXT_(card, 4, "b2dw%04lx", event);
 	QETH_CARD_TEXT_(card, 4, "ma%012llx", ether_addr_to_u64(addr));
 
@@ -815,6 +814,7 @@ static void qeth_l2_br2dev_worker(struct work_struct *work)
 	dev_put(brdev);
 	dev_put(lsyncdev);
 	dev_put(dstdev);
+	kfree(br2dev_event_work);
 }
 
 static int qeth_l2_br2dev_queue_work(struct net_device *brdev,
diff --git a/drivers/soundwire/dmi-quirks.c b/drivers/soundwire/dmi-quirks.c
index 747983743a14..f81cdd83ec26 100644
--- a/drivers/soundwire/dmi-quirks.c
+++ b/drivers/soundwire/dmi-quirks.c
@@ -55,7 +55,26 @@ static const struct adr_remap dell_sku_0A3E[] = {
 	{}
 };
 
+/*
+ * The HP Omen 16-k0005TX does not expose the correct version of RT711 on link0
+ * and does not expose a RT1316 on link3
+ */
+static const struct adr_remap hp_omen_16[] = {
+	/* rt711-sdca on link0 */
+	{
+		0x000020025d071100ull,
+		0x000030025d071101ull
+	},
+	/* rt1316-sdca on link3 */
+	{
+		0x000120025d071100ull,
+		0x000330025d131601ull
+	},
+	{}
+};
+
 static const struct dmi_system_id adr_remap_quirk_table[] = {
+	/* TGL devices */
 	{
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
@@ -78,6 +97,14 @@ static const struct dmi_system_id adr_remap_quirk_table[] = {
 		},
 		.driver_data = (void *)dell_sku_0A3E,
 	},
+	/* ADL devices */
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OMEN by HP Gaming Laptop 16-k0xxx"),
+		},
+		.driver_data = (void *)hp_omen_16,
+	},
 	{}
 };
 
diff --git a/drivers/soundwire/intel.c b/drivers/soundwire/intel.c
index af6c1a93372d..002bc26b525e 100644
--- a/drivers/soundwire/intel.c
+++ b/drivers/soundwire/intel.c
@@ -1307,6 +1307,7 @@ static int intel_link_probe(struct auxiliary_device *auxdev,
 	cdns->msg_count = 0;
 
 	bus->link_id = auxdev->id;
+	bus->clk_stop_timeout = 1;
 
 	sdw_cdns_probe(cdns);
 
diff --git a/drivers/spi/spi-mt65xx.c b/drivers/spi/spi-mt65xx.c
index cd9dc358d396..a7cc96aeb590 100644
--- a/drivers/spi/spi-mt65xx.c
+++ b/drivers/spi/spi-mt65xx.c
@@ -1268,8 +1268,11 @@ static int mtk_spi_remove(struct platform_device *pdev)
 {
 	struct spi_master *master = platform_get_drvdata(pdev);
 	struct mtk_spi *mdata = spi_master_get_devdata(master);
+	int ret;
 
-	pm_runtime_disable(&pdev->dev);
+	ret = pm_runtime_resume_and_get(&pdev->dev);
+	if (ret < 0)
+		return ret;
 
 	mtk_spi_reset(mdata);
 
@@ -1278,6 +1281,9 @@ static int mtk_spi_remove(struct platform_device *pdev)
 		clk_unprepare(mdata->spi_hclk);
 	}
 
+	pm_runtime_put_noidle(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
+
 	return 0;
 }
 
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 6f61a288073b..c2075b90f3df 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -291,7 +291,8 @@ int dwc3_send_gadget_ep_cmd(struct dwc3_ep *dep, unsigned int cmd,
 	 *
 	 * DWC_usb3 3.30a and DWC_usb31 1.90a programming guide section 3.2.2
 	 */
-	if (dwc->gadget->speed <= USB_SPEED_HIGH) {
+	if (dwc->gadget->speed <= USB_SPEED_HIGH ||
+	    DWC3_DEPCMD_CMD(cmd) == DWC3_DEPCMD_ENDTRANSFER) {
 		reg = dwc3_readl(dwc->regs, DWC3_GUSB2PHYCFG(0));
 		if (unlikely(reg & DWC3_GUSB2PHYCFG_SUSPHY)) {
 			saved_config |= DWC3_GUSB2PHYCFG_SUSPHY;
diff --git a/drivers/video/fbdev/core/fbcon.c b/drivers/video/fbdev/core/fbcon.c
index 098b62f7b701..c0143d38df83 100644
--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -577,7 +577,7 @@ static void fbcon_prepare_logo(struct vc_data *vc, struct fb_info *info,
 		if (scr_readw(r) != vc->vc_video_erase_char)
 			break;
 	if (r != q && new_rows >= rows + logo_lines) {
-		save = kmalloc(array3_size(logo_lines, new_cols, 2),
+		save = kzalloc(array3_size(logo_lines, new_cols, 2),
 			       GFP_KERNEL);
 		if (save) {
 			int i = min(cols, new_cols);
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index e7671afcee4f..8cc038460bed 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -5615,6 +5615,7 @@ static int clone_range(struct send_ctx *sctx, struct btrfs_path *dst_path,
 		u64 ext_len;
 		u64 clone_len;
 		u64 clone_data_offset;
+		bool crossed_src_i_size = false;
 
 		if (slot >= btrfs_header_nritems(leaf)) {
 			ret = btrfs_next_leaf(clone_root->root, path);
@@ -5672,8 +5673,10 @@ static int clone_range(struct send_ctx *sctx, struct btrfs_path *dst_path,
 		if (key.offset >= clone_src_i_size)
 			break;
 
-		if (key.offset + ext_len > clone_src_i_size)
+		if (key.offset + ext_len > clone_src_i_size) {
 			ext_len = clone_src_i_size - key.offset;
+			crossed_src_i_size = true;
+		}
 
 		clone_data_offset = btrfs_file_extent_offset(leaf, ei);
 		if (btrfs_file_extent_disk_bytenr(leaf, ei) == disk_byte) {
@@ -5734,6 +5737,25 @@ static int clone_range(struct send_ctx *sctx, struct btrfs_path *dst_path,
 				ret = send_clone(sctx, offset, clone_len,
 						 clone_root);
 			}
+		} else if (crossed_src_i_size && clone_len < len) {
+			/*
+			 * If we are at i_size of the clone source inode and we
+			 * can not clone from it, terminate the loop. This is
+			 * to avoid sending two write operations, one with a
+			 * length matching clone_len and the final one after
+			 * this loop with a length of len - clone_len.
+			 *
+			 * When using encoded writes (BTRFS_SEND_FLAG_COMPRESSED
+			 * was passed to the send ioctl), this helps avoid
+			 * sending an encoded write for an offset that is not
+			 * sector size aligned, in case the i_size of the source
+			 * inode is not sector size aligned. That will make the
+			 * receiver fallback to decompression of the data and
+			 * writing it using regular buffered IO, therefore while
+			 * not incorrect, it's not optimal due decompression and
+			 * possible re-compression at the receiver.
+			 */
+			break;
 		} else {
 			ret = send_extent_data(sctx, dst_path, offset,
 					       clone_len);
diff --git a/fs/file.c b/fs/file.c
index 3bcc1ecc314a..57af5f8375fd 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -1002,7 +1002,16 @@ static unsigned long __fget_light(unsigned int fd, fmode_t mask)
 	struct files_struct *files = current->files;
 	struct file *file;
 
-	if (atomic_read(&files->count) == 1) {
+	/*
+	 * If another thread is concurrently calling close_fd() followed
+	 * by put_files_struct(), we must not observe the old table
+	 * entry combined with the new refcount - otherwise we could
+	 * return a file that is concurrently being freed.
+	 *
+	 * atomic_read_acquire() pairs with atomic_dec_and_test() in
+	 * put_files_struct().
+	 */
+	if (atomic_read_acquire(&files->count) == 1) {
 		file = files_lookup_fd_raw(files, fd);
 		if (!file || unlikely(file->f_mode & mask))
 			return 0;
diff --git a/fs/fscache/cookie.c b/fs/fscache/cookie.c
index 451d8a077e12..bce2492186d0 100644
--- a/fs/fscache/cookie.c
+++ b/fs/fscache/cookie.c
@@ -605,6 +605,14 @@ void __fscache_use_cookie(struct fscache_cookie *cookie, bool will_modify)
 			set_bit(FSCACHE_COOKIE_DO_PREP_TO_WRITE, &cookie->flags);
 			queue = true;
 		}
+		/*
+		 * We could race with cookie_lru which may set LRU_DISCARD bit
+		 * but has yet to run the cookie state machine.  If this happens
+		 * and another thread tries to use the cookie, clear LRU_DISCARD
+		 * so we don't end up withdrawing the cookie while in use.
+		 */
+		if (test_and_clear_bit(FSCACHE_COOKIE_DO_LRU_DISCARD, &cookie->flags))
+			fscache_see_cookie(cookie, fscache_cookie_see_lru_discard_clear);
 		break;
 
 	case FSCACHE_COOKIE_STATE_FAILED:
diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index 492dce43236e..cab7cfebf40b 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -222,12 +222,16 @@ extern void tlb_remove_table(struct mmu_gather *tlb, void *table);
 #define tlb_needs_table_invalidate() (true)
 #endif
 
+void tlb_remove_table_sync_one(void);
+
 #else
 
 #ifdef tlb_needs_table_invalidate
 #error tlb_needs_table_invalidate() requires MMU_GATHER_RCU_TABLE_FREE
 #endif
 
+static inline void tlb_remove_table_sync_one(void) { }
+
 #endif /* CONFIG_MMU_GATHER_RCU_TABLE_FREE */
 
 
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index ac5d0515680e..a3535a485497 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -68,6 +68,7 @@ struct css_task_iter {
 	struct list_head		iters_node;	/* css_set->task_iters */
 };
 
+extern struct file_system_type cgroup_fs_type;
 extern struct cgroup_root cgrp_dfl_root;
 extern struct css_set init_css_set;
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 21f8b27bd9fd..4ff52127a6b8 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1778,6 +1778,25 @@ extern void pagefault_out_of_memory(void);
 
 extern void show_free_areas(unsigned int flags, nodemask_t *nodemask);
 
+/*
+ * Parameter block passed down to zap_pte_range in exceptional cases.
+ */
+struct zap_details {
+	struct folio *single_folio;	/* Locked folio to be unmapped */
+	bool even_cows;			/* Zap COWed private pages too? */
+	zap_flags_t zap_flags;		/* Extra flags for zapping */
+};
+
+/*
+ * Whether to drop the pte markers, for example, the uffd-wp information for
+ * file-backed memory.  This should only be specified when we will completely
+ * drop the page in the mm, either by truncation or unmapping of the vma.  By
+ * default, the flag is not set.
+ */
+#define  ZAP_FLAG_DROP_MARKER        ((__force zap_flags_t) BIT(0))
+/* Set in unmap_vmas() to indicate a final unmap call.  Only used by hugetlb */
+#define  ZAP_FLAG_UNMAP              ((__force zap_flags_t) BIT(1))
+
 #ifdef CONFIG_MMU
 extern bool can_do_mlock(void);
 #else
@@ -1797,6 +1816,8 @@ void zap_page_range(struct vm_area_struct *vma, unsigned long address,
 		    unsigned long size);
 void unmap_vmas(struct mmu_gather *tlb, struct vm_area_struct *start_vma,
 		unsigned long start, unsigned long end);
+void zap_page_range_single(struct vm_area_struct *vma, unsigned long address,
+			   unsigned long size, struct zap_details *details);
 
 struct mmu_notifier_range;
 
@@ -3386,12 +3407,4 @@ madvise_set_anon_name(struct mm_struct *mm, unsigned long start,
 }
 #endif
 
-/*
- * Whether to drop the pte markers, for example, the uffd-wp information for
- * file-backed memory.  This should only be specified when we will completely
- * drop the page in the mm, either by truncation or unmapping of the vma.  By
- * default, the flag is not set.
- */
-#define  ZAP_FLAG_DROP_MARKER        ((__force zap_flags_t) BIT(0))
-
 #endif /* _LINUX_MM_H */
diff --git a/include/linux/platform_data/x86/asus-wmi.h b/include/linux/platform_data/x86/asus-wmi.h
index 98f2b2f20f3e..7c96db7f3060 100644
--- a/include/linux/platform_data/x86/asus-wmi.h
+++ b/include/linux/platform_data/x86/asus-wmi.h
@@ -65,6 +65,7 @@
 #define ASUS_WMI_DEVID_PANEL_OD		0x00050019
 #define ASUS_WMI_DEVID_CAMERA		0x00060013
 #define ASUS_WMI_DEVID_LID_FLIP		0x00060062
+#define ASUS_WMI_DEVID_LID_FLIP_ROG	0x00060077
 
 /* Storage */
 #define ASUS_WMI_DEVID_CARDREADER	0x00080013
diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index cf29511b25a8..4518c63e9d17 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -228,6 +228,17 @@ enum {
 	 */
 	HCI_QUIRK_VALID_LE_STATES,
 
+	/* When this quirk is set, then erroneous data reporting
+	 * is ignored. This is mainly due to the fact that the HCI
+	 * Read Default Erroneous Data Reporting command is advertised,
+	 * but not supported; these controllers often reply with unknown
+	 * command and tend to lock up randomly. Needing a hard reset.
+	 *
+	 * This quirk can be set before hci_register_dev is called or
+	 * during the hdev->setup vendor callback.
+	 */
+	HCI_QUIRK_BROKEN_ERR_DATA_REPORTING,
+
 	/*
 	 * When this quirk is set, then the hci_suspend_notifier is not
 	 * registered. This is intended for devices which drop completely
@@ -1420,7 +1431,6 @@ struct hci_std_codecs_v2 {
 } __packed;
 
 struct hci_vnd_codec_v2 {
-	__u8	id;
 	__le16	cid;
 	__le16	vid;
 	__u8	transport;
diff --git a/include/net/ping.h b/include/net/ping.h
index e4ff3911cbf5..9233ad3de0ad 100644
--- a/include/net/ping.h
+++ b/include/net/ping.h
@@ -16,9 +16,6 @@
 #define PING_HTABLE_SIZE 	64
 #define PING_HTABLE_MASK 	(PING_HTABLE_SIZE-1)
 
-#define ping_portaddr_for_each_entry(__sk, node, list) \
-	hlist_nulls_for_each_entry(__sk, node, list, sk_nulls_node)
-
 /*
  * gid_t is either uint or ushort.  We want to pass it to
  * proc_dointvec_minmax(), so it must not be larger than MAX_INT
diff --git a/include/trace/events/fscache.h b/include/trace/events/fscache.h
index c078c48a8e6d..a6190aa1b406 100644
--- a/include/trace/events/fscache.h
+++ b/include/trace/events/fscache.h
@@ -66,6 +66,7 @@ enum fscache_cookie_trace {
 	fscache_cookie_put_work,
 	fscache_cookie_see_active,
 	fscache_cookie_see_lru_discard,
+	fscache_cookie_see_lru_discard_clear,
 	fscache_cookie_see_lru_do_one,
 	fscache_cookie_see_relinquish,
 	fscache_cookie_see_withdraw,
@@ -149,6 +150,7 @@ enum fscache_access_trace {
 	EM(fscache_cookie_put_work,		"PQ  work ")		\
 	EM(fscache_cookie_see_active,		"-   activ")		\
 	EM(fscache_cookie_see_lru_discard,	"-   x-lru")		\
+	EM(fscache_cookie_see_lru_discard_clear,"-   lrudc")            \
 	EM(fscache_cookie_see_lru_do_one,	"-   lrudo")		\
 	EM(fscache_cookie_see_relinquish,	"-   x-rlq")		\
 	EM(fscache_cookie_see_withdraw,		"-   x-wth")		\
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index adf73d162521..1b6c25dc3f0c 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2560,8 +2560,10 @@ static __cold void io_tctx_exit_cb(struct callback_head *cb)
 	/*
 	 * When @in_idle, we're in cancellation and it's racy to remove the
 	 * node. It'll be removed by the end of cancellation, just ignore it.
+	 * tctx can be NULL if the queueing of this task_work raced with
+	 * work cancelation off the exec path.
 	 */
-	if (!atomic_read(&tctx->in_idle))
+	if (tctx && !atomic_read(&tctx->in_idle))
 		io_uring_del_tctx_node((unsigned long)work->ctx);
 	complete(&work->completion);
 }
diff --git a/kernel/cgroup/cgroup-internal.h b/kernel/cgroup/cgroup-internal.h
index 36b740cb3d59..b231081be177 100644
--- a/kernel/cgroup/cgroup-internal.h
+++ b/kernel/cgroup/cgroup-internal.h
@@ -168,7 +168,6 @@ extern struct mutex cgroup_mutex;
 extern spinlock_t css_set_lock;
 extern struct cgroup_subsys *cgroup_subsys[];
 extern struct list_head cgroup_roots;
-extern struct file_system_type cgroup_fs_type;
 
 /* iterate across the hierarchies */
 #define for_each_root(root)						\
diff --git a/mm/gup.c b/mm/gup.c
index 251cb6a10bc0..d7f9116fc645 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2818,7 +2818,7 @@ static int gup_pud_range(p4d_t *p4dp, p4d_t p4d, unsigned long addr, unsigned lo
 		next = pud_addr_end(addr, end);
 		if (unlikely(!pud_present(pud)))
 			return 0;
-		if (unlikely(pud_huge(pud))) {
+		if (unlikely(pud_huge(pud) || pud_devmap(pud))) {
 			if (!gup_huge_pud(pud, pudp, addr, next, flags,
 					  pages, nr))
 				return 0;
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index dbb558e71e9e..022a3bfafec4 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5145,17 +5145,20 @@ void __unmap_hugepage_range_final(struct mmu_gather *tlb,
 {
 	__unmap_hugepage_range(tlb, vma, start, end, ref_page, zap_flags);
 
-	/*
-	 * Clear this flag so that x86's huge_pmd_share page_table_shareable
-	 * test will fail on a vma being torn down, and not grab a page table
-	 * on its way out.  We're lucky that the flag has such an appropriate
-	 * name, and can in fact be safely cleared here. We could clear it
-	 * before the __unmap_hugepage_range above, but all that's necessary
-	 * is to clear it before releasing the i_mmap_rwsem. This works
-	 * because in the context this is called, the VMA is about to be
-	 * destroyed and the i_mmap_rwsem is held.
-	 */
-	vma->vm_flags &= ~VM_MAYSHARE;
+	if (zap_flags & ZAP_FLAG_UNMAP) {	/* final unmap */
+		/*
+		 * Clear this flag so that x86's huge_pmd_share
+		 * page_table_shareable test will fail on a vma being torn
+		 * down, and not grab a page table on its way out.  We're lucky
+		 * that the flag has such an appropriate name, and can in fact
+		 * be safely cleared here. We could clear it before the
+		 * __unmap_hugepage_range above, but all that's necessary
+		 * is to clear it before releasing the i_mmap_rwsem. This works
+		 * because in the context this is called, the VMA is about to
+		 * be destroyed and the i_mmap_rwsem is held.
+		 */
+		vma->vm_flags &= ~VM_MAYSHARE;
+	}
 }
 
 void unmap_hugepage_range(struct vm_area_struct *vma, unsigned long start,
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 70b7ac66411c..5935765bcb33 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1093,6 +1093,7 @@ static void collapse_huge_page(struct mm_struct *mm,
 	_pmd = pmdp_collapse_flush(vma, address, pmd);
 	spin_unlock(pmd_ptl);
 	mmu_notifier_invalidate_range_end(&range);
+	tlb_remove_table_sync_one();
 
 	spin_lock(pte_ptl);
 	isolated = __collapse_huge_page_isolate(vma, address, pte,
@@ -1360,16 +1361,43 @@ static void khugepaged_add_pte_mapped_thp(struct mm_struct *mm,
 	spin_unlock(&khugepaged_mm_lock);
 }
 
+/*
+ * A note about locking:
+ * Trying to take the page table spinlocks would be useless here because those
+ * are only used to synchronize:
+ *
+ *  - modifying terminal entries (ones that point to a data page, not to another
+ *    page table)
+ *  - installing *new* non-terminal entries
+ *
+ * Instead, we need roughly the same kind of protection as free_pgtables() or
+ * mm_take_all_locks() (but only for a single VMA):
+ * The mmap lock together with this VMA's rmap locks covers all paths towards
+ * the page table entries we're messing with here, except for hardware page
+ * table walks and lockless_pages_from_mm().
+ */
 static void collapse_and_free_pmd(struct mm_struct *mm, struct vm_area_struct *vma,
 				  unsigned long addr, pmd_t *pmdp)
 {
-	spinlock_t *ptl;
 	pmd_t pmd;
+	struct mmu_notifier_range range;
 
 	mmap_assert_write_locked(mm);
-	ptl = pmd_lock(vma->vm_mm, pmdp);
+	if (vma->vm_file)
+		lockdep_assert_held_write(&vma->vm_file->f_mapping->i_mmap_rwsem);
+	/*
+	 * All anon_vmas attached to the VMA have the same root and are
+	 * therefore locked by the same lock.
+	 */
+	if (vma->anon_vma)
+		lockdep_assert_held_write(&vma->anon_vma->root->rwsem);
+
+	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, NULL, mm, addr,
+				addr + HPAGE_PMD_SIZE);
+	mmu_notifier_invalidate_range_start(&range);
 	pmd = pmdp_collapse_flush(vma, addr, pmdp);
-	spin_unlock(ptl);
+	tlb_remove_table_sync_one();
+	mmu_notifier_invalidate_range_end(&range);
 	mm_dec_nr_ptes(mm);
 	page_table_check_pte_clear_range(mm, addr, pmd);
 	pte_free(mm, pmd_pgtable(pmd));
@@ -1410,6 +1438,14 @@ void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr)
 	if (!hugepage_vma_check(vma, vma->vm_flags | VM_HUGEPAGE, false, false))
 		return;
 
+	/*
+	 * Symmetry with retract_page_tables(): Exclude MAP_PRIVATE mappings
+	 * that got written to. Without this, we'd have to also lock the
+	 * anon_vma if one exists.
+	 */
+	if (vma->anon_vma)
+		return;
+
 	/* Keep pmd pgtable for uffd-wp; see comment in retract_page_tables() */
 	if (userfaultfd_wp(vma))
 		return;
@@ -1426,6 +1462,20 @@ void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr)
 	if (!pmd)
 		goto drop_hpage;
 
+	/*
+	 * We need to lock the mapping so that from here on, only GUP-fast and
+	 * hardware page walks can access the parts of the page tables that
+	 * we're operating on.
+	 * See collapse_and_free_pmd().
+	 */
+	i_mmap_lock_write(vma->vm_file->f_mapping);
+
+	/*
+	 * This spinlock should be unnecessary: Nobody else should be accessing
+	 * the page tables under spinlock protection here, only
+	 * lockless_pages_from_mm() and the hardware page walker can access page
+	 * tables while all the high-level locks are held in write mode.
+	 */
 	start_pte = pte_offset_map_lock(mm, pmd, haddr, &ptl);
 
 	/* step 1: check all mapped PTEs are to the right huge page */
@@ -1476,6 +1526,9 @@ void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr)
 
 	/* step 4: collapse pmd */
 	collapse_and_free_pmd(mm, vma, haddr, pmd);
+
+	i_mmap_unlock_write(vma->vm_file->f_mapping);
+
 drop_hpage:
 	unlock_page(hpage);
 	put_page(hpage);
@@ -1483,6 +1536,7 @@ void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr)
 
 abort:
 	pte_unmap_unlock(start_pte, ptl);
+	i_mmap_unlock_write(vma->vm_file->f_mapping);
 	goto drop_hpage;
 }
 
@@ -1531,7 +1585,8 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
 		 * An alternative would be drop the check, but check that page
 		 * table is clear before calling pmdp_collapse_flush() under
 		 * ptl. It has higher chance to recover THP for the VMA, but
-		 * has higher cost too.
+		 * has higher cost too. It would also probably require locking
+		 * the anon_vma.
 		 */
 		if (vma->anon_vma)
 			continue;
diff --git a/mm/madvise.c b/mm/madvise.c
index 98ed17a4471a..b2831b57aef8 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -770,8 +770,8 @@ static int madvise_free_single_vma(struct vm_area_struct *vma,
  * Application no longer needs these pages.  If the pages are dirty,
  * it's OK to just throw them away.  The app will be more careful about
  * data it wants to keep.  Be sure to free swap resources too.  The
- * zap_page_range call sets things up for shrink_active_list to actually free
- * these pages later if no one else has touched them in the meantime,
+ * zap_page_range_single call sets things up for shrink_active_list to actually
+ * free these pages later if no one else has touched them in the meantime,
  * although we could add these pages to a global reuse list for
  * shrink_active_list to pick up before reclaiming other pages.
  *
@@ -788,7 +788,7 @@ static int madvise_free_single_vma(struct vm_area_struct *vma,
 static long madvise_dontneed_single_vma(struct vm_area_struct *vma,
 					unsigned long start, unsigned long end)
 {
-	zap_page_range(vma, start, end - start);
+	zap_page_range_single(vma, start, end - start, NULL);
 	return 0;
 }
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6a95ea7c5ee7..f2fc11ba2426 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4772,6 +4772,7 @@ static ssize_t memcg_write_event_control(struct kernfs_open_file *of,
 	unsigned int efd, cfd;
 	struct fd efile;
 	struct fd cfile;
+	struct dentry *cdentry;
 	const char *name;
 	char *endp;
 	int ret;
@@ -4825,6 +4826,16 @@ static ssize_t memcg_write_event_control(struct kernfs_open_file *of,
 	if (ret < 0)
 		goto out_put_cfile;
 
+	/*
+	 * The control file must be a regular cgroup1 file. As a regular cgroup
+	 * file can't be renamed, it's safe to access its name afterwards.
+	 */
+	cdentry = cfile.file->f_path.dentry;
+	if (cdentry->d_sb->s_type != &cgroup_fs_type || !d_is_reg(cdentry)) {
+		ret = -EINVAL;
+		goto out_put_cfile;
+	}
+
 	/*
 	 * Determine the event callbacks and set them in @event.  This used
 	 * to be done via struct cftype but cgroup core no longer knows
@@ -4833,7 +4844,7 @@ static ssize_t memcg_write_event_control(struct kernfs_open_file *of,
 	 *
 	 * DO NOT ADD NEW FILES.
 	 */
-	name = cfile.file->f_path.dentry->d_name.name;
+	name = cdentry->d_name.name;
 
 	if (!strcmp(name, "memory.usage_in_bytes")) {
 		event->register_event = mem_cgroup_usage_register_event;
@@ -4857,7 +4868,7 @@ static ssize_t memcg_write_event_control(struct kernfs_open_file *of,
 	 * automatically removed on cgroup destruction but the removal is
 	 * asynchronous, so take an extra ref on @css.
 	 */
-	cfile_css = css_tryget_online_from_dir(cfile.file->f_path.dentry->d_parent,
+	cfile_css = css_tryget_online_from_dir(cdentry->d_parent,
 					       &memory_cgrp_subsys);
 	ret = -EINVAL;
 	if (IS_ERR(cfile_css))
diff --git a/mm/memory.c b/mm/memory.c
index de0dbe09b013..a0fdaa74091f 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1341,15 +1341,6 @@ copy_page_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma)
 	return ret;
 }
 
-/*
- * Parameter block passed down to zap_pte_range in exceptional cases.
- */
-struct zap_details {
-	struct folio *single_folio;	/* Locked folio to be unmapped */
-	bool even_cows;			/* Zap COWed private pages too? */
-	zap_flags_t zap_flags;		/* Extra flags for zapping */
-};
-
 /* Whether we should zap all COWed (private) pages too */
 static inline bool should_zap_cows(struct zap_details *details)
 {
@@ -1721,7 +1712,7 @@ void unmap_vmas(struct mmu_gather *tlb,
 {
 	struct mmu_notifier_range range;
 	struct zap_details details = {
-		.zap_flags = ZAP_FLAG_DROP_MARKER,
+		.zap_flags = ZAP_FLAG_DROP_MARKER | ZAP_FLAG_UNMAP,
 		/* Careful - we need to zap private pages too! */
 		.even_cows = true,
 	};
@@ -1769,19 +1760,27 @@ void zap_page_range(struct vm_area_struct *vma, unsigned long start,
  *
  * The range must fit into one VMA.
  */
-static void zap_page_range_single(struct vm_area_struct *vma, unsigned long address,
+void zap_page_range_single(struct vm_area_struct *vma, unsigned long address,
 		unsigned long size, struct zap_details *details)
 {
+	const unsigned long end = address + size;
 	struct mmu_notifier_range range;
 	struct mmu_gather tlb;
 
 	lru_add_drain();
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, vma->vm_mm,
-				address, address + size);
+				address, end);
+	if (is_vm_hugetlb_page(vma))
+		adjust_range_if_pmd_sharing_possible(vma, &range.start,
+						     &range.end);
 	tlb_gather_mmu(&tlb, vma->vm_mm);
 	update_hiwater_rss(vma->vm_mm);
 	mmu_notifier_invalidate_range_start(&range);
-	unmap_single_vma(&tlb, vma, address, range.end, details);
+	/*
+	 * unmap 'address-end' not 'range.start-range.end' as range
+	 * could have been expanded for hugetlb pmd sharing.
+	 */
+	unmap_single_vma(&tlb, vma, address, end, details);
 	mmu_notifier_invalidate_range_end(&range);
 	tlb_finish_mmu(&tlb);
 }
diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
index a71924bd38c0..ba7d26a291dd 100644
--- a/mm/mmu_gather.c
+++ b/mm/mmu_gather.c
@@ -152,7 +152,7 @@ static void tlb_remove_table_smp_sync(void *arg)
 	/* Simply deliver the interrupt */
 }
 
-static void tlb_remove_table_sync_one(void)
+void tlb_remove_table_sync_one(void)
 {
 	/*
 	 * This isn't an RCU grace period and hence the page-tables cannot be
@@ -176,8 +176,6 @@ static void tlb_remove_table_free(struct mmu_table_batch *batch)
 
 #else /* !CONFIG_MMU_GATHER_RCU_TABLE_FREE */
 
-static void tlb_remove_table_sync_one(void) { }
-
 static void tlb_remove_table_free(struct mmu_table_batch *batch)
 {
 	__tlb_remove_table_free(batch);
diff --git a/mm/shmem.c b/mm/shmem.c
index 42e5888bf84d..112ebf601bb4 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -958,6 +958,15 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, loff_t lend,
 		index++;
 	}
 
+	/*
+	 * When undoing a failed fallocate, we want none of the partial folio
+	 * zeroing and splitting below, but shall want to truncate the whole
+	 * folio when !uptodate indicates that it was added by this fallocate,
+	 * even when [lstart, lend] covers only a part of the folio.
+	 */
+	if (unfalloc)
+		goto whole_folios;
+
 	same_folio = (lstart >> PAGE_SHIFT) == (lend >> PAGE_SHIFT);
 	folio = shmem_get_partial_folio(inode, lstart >> PAGE_SHIFT);
 	if (folio) {
@@ -983,6 +992,8 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, loff_t lend,
 		folio_put(folio);
 	}
 
+whole_folios:
+
 	index = start;
 	while (index < end) {
 		cond_resched();
diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index 3e056fb043bb..080b5de3e1ed 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -120,7 +120,7 @@ struct p9_conn {
 	struct list_head unsent_req_list;
 	struct p9_req_t *rreq;
 	struct p9_req_t *wreq;
-	char tmp_buf[7];
+	char tmp_buf[P9_HDRSZ];
 	struct p9_fcall rc;
 	int wpos;
 	int wsize;
@@ -293,7 +293,7 @@ static void p9_read_work(struct work_struct *work)
 	if (!m->rc.sdata) {
 		m->rc.sdata = m->tmp_buf;
 		m->rc.offset = 0;
-		m->rc.capacity = 7; /* start by reading header */
+		m->rc.capacity = P9_HDRSZ; /* start by reading header */
 	}
 
 	clear_bit(Rpending, &m->wsched);
@@ -316,7 +316,7 @@ static void p9_read_work(struct work_struct *work)
 		p9_debug(P9_DEBUG_TRANS, "got new header\n");
 
 		/* Header size */
-		m->rc.size = 7;
+		m->rc.size = P9_HDRSZ;
 		err = p9_parse_header(&m->rc, &m->rc.size, NULL, NULL, 0);
 		if (err) {
 			p9_debug(P9_DEBUG_ERROR,
diff --git a/net/9p/trans_xen.c b/net/9p/trans_xen.c
index 227f89cc7237..0f862d5a5960 100644
--- a/net/9p/trans_xen.c
+++ b/net/9p/trans_xen.c
@@ -208,6 +208,14 @@ static void p9_xen_response(struct work_struct *work)
 			continue;
 		}
 
+		if (h.size > req->rc.capacity) {
+			dev_warn(&priv->dev->dev,
+				 "requested packet size too big: %d for tag %d with capacity %zd\n",
+				 h.size, h.tag, req->rc.capacity);
+			req->status = REQ_STATUS_ERROR;
+			goto recv_error;
+		}
+
 		memcpy(&req->rc, &h, sizeof(h));
 		req->rc.offset = 0;
 
@@ -217,6 +225,7 @@ static void p9_xen_response(struct work_struct *work)
 				     masked_prod, &masked_cons,
 				     XEN_9PFS_RING_SIZE(ring));
 
+recv_error:
 		virt_mb();
 		cons += h.size;
 		ring->intf->in_cons = cons;
diff --git a/net/bluetooth/6lowpan.c b/net/bluetooth/6lowpan.c
index 215af9b3b589..c57d643afb10 100644
--- a/net/bluetooth/6lowpan.c
+++ b/net/bluetooth/6lowpan.c
@@ -972,6 +972,7 @@ static int get_l2cap_conn(char *buf, bdaddr_t *addr, u8 *addr_type,
 	hci_dev_lock(hdev);
 	hcon = hci_conn_hash_lookup_le(hdev, addr, *addr_type);
 	hci_dev_unlock(hdev);
+	hci_dev_put(hdev);
 
 	if (!hcon)
 		return -ENOENT;
diff --git a/net/bluetooth/af_bluetooth.c b/net/bluetooth/af_bluetooth.c
index dc65974f5adb..1c3c7ff5c3c6 100644
--- a/net/bluetooth/af_bluetooth.c
+++ b/net/bluetooth/af_bluetooth.c
@@ -737,7 +737,7 @@ static int __init bt_init(void)
 
 	err = bt_sysfs_init();
 	if (err < 0)
-		return err;
+		goto cleanup_led;
 
 	err = sock_register(&bt_sock_family_ops);
 	if (err)
@@ -773,6 +773,8 @@ static int __init bt_init(void)
 	sock_unregister(PF_BLUETOOTH);
 cleanup_sysfs:
 	bt_sysfs_cleanup();
+cleanup_led:
+	bt_leds_cleanup();
 	return err;
 }
 
diff --git a/net/bluetooth/hci_codec.c b/net/bluetooth/hci_codec.c
index 38201532f58e..3cc135bb1d30 100644
--- a/net/bluetooth/hci_codec.c
+++ b/net/bluetooth/hci_codec.c
@@ -72,9 +72,8 @@ static void hci_read_codec_capabilities(struct hci_dev *hdev, __u8 transport,
 				continue;
 			}
 
-			skb = __hci_cmd_sync(hdev, HCI_OP_READ_LOCAL_CODEC_CAPS,
-					     sizeof(*cmd), cmd,
-					     HCI_CMD_TIMEOUT);
+			skb = __hci_cmd_sync_sk(hdev, HCI_OP_READ_LOCAL_CODEC_CAPS,
+						sizeof(*cmd), cmd, 0, HCI_CMD_TIMEOUT, NULL);
 			if (IS_ERR(skb)) {
 				bt_dev_err(hdev, "Failed to read codec capabilities (%ld)",
 					   PTR_ERR(skb));
@@ -127,8 +126,8 @@ void hci_read_supported_codecs(struct hci_dev *hdev)
 	struct hci_op_read_local_codec_caps caps;
 	__u8 i;
 
-	skb = __hci_cmd_sync(hdev, HCI_OP_READ_LOCAL_CODECS, 0, NULL,
-			     HCI_CMD_TIMEOUT);
+	skb = __hci_cmd_sync_sk(hdev, HCI_OP_READ_LOCAL_CODECS, 0, NULL,
+				0, HCI_CMD_TIMEOUT, NULL);
 
 	if (IS_ERR(skb)) {
 		bt_dev_err(hdev, "Failed to read local supported codecs (%ld)",
@@ -158,7 +157,8 @@ void hci_read_supported_codecs(struct hci_dev *hdev)
 	for (i = 0; i < std_codecs->num; i++) {
 		caps.id = std_codecs->codec[i];
 		caps.direction = 0x00;
-		hci_read_codec_capabilities(hdev, LOCAL_CODEC_ACL_MASK, &caps);
+		hci_read_codec_capabilities(hdev,
+					    LOCAL_CODEC_ACL_MASK | LOCAL_CODEC_SCO_MASK, &caps);
 	}
 
 	skb_pull(skb, flex_array_size(std_codecs, codec, std_codecs->num)
@@ -178,7 +178,8 @@ void hci_read_supported_codecs(struct hci_dev *hdev)
 		caps.cid = vnd_codecs->codec[i].cid;
 		caps.vid = vnd_codecs->codec[i].vid;
 		caps.direction = 0x00;
-		hci_read_codec_capabilities(hdev, LOCAL_CODEC_ACL_MASK, &caps);
+		hci_read_codec_capabilities(hdev,
+					    LOCAL_CODEC_ACL_MASK | LOCAL_CODEC_SCO_MASK, &caps);
 	}
 
 error:
@@ -194,8 +195,8 @@ void hci_read_supported_codecs_v2(struct hci_dev *hdev)
 	struct hci_op_read_local_codec_caps caps;
 	__u8 i;
 
-	skb = __hci_cmd_sync(hdev, HCI_OP_READ_LOCAL_CODECS_V2, 0, NULL,
-			     HCI_CMD_TIMEOUT);
+	skb = __hci_cmd_sync_sk(hdev, HCI_OP_READ_LOCAL_CODECS_V2, 0, NULL,
+				0, HCI_CMD_TIMEOUT, NULL);
 
 	if (IS_ERR(skb)) {
 		bt_dev_err(hdev, "Failed to read local supported codecs (%ld)",
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 6ae5aa5c0927..c8ea03edd081 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2757,7 +2757,8 @@ int hci_register_suspend_notifier(struct hci_dev *hdev)
 {
 	int ret = 0;
 
-	if (!test_bit(HCI_QUIRK_NO_SUSPEND_NOTIFIER, &hdev->quirks)) {
+	if (!hdev->suspend_notifier.notifier_call &&
+	    !test_bit(HCI_QUIRK_NO_SUSPEND_NOTIFIER, &hdev->quirks)) {
 		hdev->suspend_notifier.notifier_call = hci_suspend_notifier;
 		ret = register_pm_notifier(&hdev->suspend_notifier);
 	}
@@ -2769,8 +2770,11 @@ int hci_unregister_suspend_notifier(struct hci_dev *hdev)
 {
 	int ret = 0;
 
-	if (!test_bit(HCI_QUIRK_NO_SUSPEND_NOTIFIER, &hdev->quirks))
+	if (hdev->suspend_notifier.notifier_call) {
 		ret = unregister_pm_notifier(&hdev->suspend_notifier);
+		if (!ret)
+			hdev->suspend_notifier.notifier_call = NULL;
+	}
 
 	return ret;
 }
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index f70798589bf5..a5e89e1b5452 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -12,6 +12,7 @@
 #include <net/bluetooth/mgmt.h>
 
 #include "hci_request.h"
+#include "hci_codec.h"
 #include "hci_debugfs.h"
 #include "smp.h"
 #include "eir.h"
@@ -3459,7 +3460,8 @@ static int hci_read_page_scan_activity_sync(struct hci_dev *hdev)
 static int hci_read_def_err_data_reporting_sync(struct hci_dev *hdev)
 {
 	if (!(hdev->commands[18] & 0x04) ||
-	    !(hdev->features[0][6] & LMP_ERR_DATA_REPORTING))
+	    !(hdev->features[0][6] & LMP_ERR_DATA_REPORTING) ||
+	    test_bit(HCI_QUIRK_BROKEN_ERR_DATA_REPORTING, &hdev->quirks))
 		return 0;
 
 	return __hci_cmd_sync_status(hdev, HCI_OP_READ_DEF_ERR_DATA_REPORTING,
@@ -3917,11 +3919,12 @@ static int hci_set_event_mask_page_2_sync(struct hci_dev *hdev)
 /* Read local codec list if the HCI command is supported */
 static int hci_read_local_codecs_sync(struct hci_dev *hdev)
 {
-	if (!(hdev->commands[29] & 0x20))
-		return 0;
+	if (hdev->commands[45] & 0x04)
+		hci_read_supported_codecs_v2(hdev);
+	else if (hdev->commands[29] & 0x20)
+		hci_read_supported_codecs(hdev);
 
-	return __hci_cmd_sync_status(hdev, HCI_OP_READ_LOCAL_CODECS, 0, NULL,
-				     HCI_CMD_TIMEOUT);
+	return 0;
 }
 
 /* Read local pairing options if the HCI command is supported */
@@ -3977,7 +3980,8 @@ static int hci_set_err_data_report_sync(struct hci_dev *hdev)
 	bool enabled = hci_dev_test_flag(hdev, HCI_WIDEBAND_SPEECH_ENABLED);
 
 	if (!(hdev->commands[18] & 0x08) ||
-	    !(hdev->features[0][6] & LMP_ERR_DATA_REPORTING))
+	    !(hdev->features[0][6] & LMP_ERR_DATA_REPORTING) ||
+	    test_bit(HCI_QUIRK_BROKEN_ERR_DATA_REPORTING, &hdev->quirks))
 		return 0;
 
 	if (enabled == hdev->err_data_reporting)
@@ -4136,6 +4140,9 @@ static const struct {
 	HCI_QUIRK_BROKEN(STORED_LINK_KEY,
 			 "HCI Delete Stored Link Key command is advertised, "
 			 "but not supported."),
+	HCI_QUIRK_BROKEN(ERR_DATA_REPORTING,
+			 "HCI Read Default Erroneous Data Reporting command is "
+			 "advertised, but not supported."),
 	HCI_QUIRK_BROKEN(READ_TRANSMIT_POWER,
 			 "HCI Read Transmit Power Level command is advertised, "
 			 "but not supported."),
diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index f825857db6d0..26db929b97c4 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -879,6 +879,7 @@ static int iso_listen_bis(struct sock *sk)
 				 iso_pi(sk)->bc_sid);
 
 	hci_dev_unlock(hdev);
+	hci_dev_put(hdev);
 
 	return err;
 }
diff --git a/net/can/af_can.c b/net/can/af_can.c
index e48ccf7cf200..461fa7c04464 100644
--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -680,7 +680,7 @@ static int can_rcv(struct sk_buff *skb, struct net_device *dev,
 {
 	struct canfd_frame *cfd = (struct canfd_frame *)skb->data;
 
-	if (unlikely(dev->type != ARPHRD_CAN || skb->len != CAN_MTU)) {
+	if (unlikely(dev->type != ARPHRD_CAN || !can_get_ml_priv(dev) || skb->len != CAN_MTU)) {
 		pr_warn_once("PF_CAN: dropped non conform CAN skbuff: dev type %d, len %d\n",
 			     dev->type, skb->len);
 		goto free_skb;
@@ -706,7 +706,7 @@ static int canfd_rcv(struct sk_buff *skb, struct net_device *dev,
 {
 	struct canfd_frame *cfd = (struct canfd_frame *)skb->data;
 
-	if (unlikely(dev->type != ARPHRD_CAN || skb->len != CANFD_MTU)) {
+	if (unlikely(dev->type != ARPHRD_CAN || !can_get_ml_priv(dev) || skb->len != CANFD_MTU)) {
 		pr_warn_once("PF_CAN: dropped non conform CAN FD skbuff: dev type %d, len %d\n",
 			     dev->type, skb->len);
 		goto free_skb;
diff --git a/net/dsa/tag_hellcreek.c b/net/dsa/tag_hellcreek.c
index 846588c0070a..53a206d11685 100644
--- a/net/dsa/tag_hellcreek.c
+++ b/net/dsa/tag_hellcreek.c
@@ -49,7 +49,8 @@ static struct sk_buff *hellcreek_rcv(struct sk_buff *skb,
 		return NULL;
 	}
 
-	pskb_trim_rcsum(skb, skb->len - HELLCREEK_TAG_LEN);
+	if (pskb_trim_rcsum(skb, skb->len - HELLCREEK_TAG_LEN))
+		return NULL;
 
 	dsa_default_offload_fwd_mark(skb);
 
diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
index 38fa19c1e2d5..429250298ac4 100644
--- a/net/dsa/tag_ksz.c
+++ b/net/dsa/tag_ksz.c
@@ -21,7 +21,8 @@ static struct sk_buff *ksz_common_rcv(struct sk_buff *skb,
 	if (!skb->dev)
 		return NULL;
 
-	pskb_trim_rcsum(skb, skb->len - len);
+	if (pskb_trim_rcsum(skb, skb->len - len))
+		return NULL;
 
 	dsa_default_offload_fwd_mark(skb);
 
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 83e4136516b0..1a85125bda6d 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -665,7 +665,8 @@ static struct sk_buff *sja1110_rcv_inband_control_extension(struct sk_buff *skb,
 		 * padding and trailer we need to account for the fact that
 		 * skb->data points to skb_mac_header(skb) + ETH_HLEN.
 		 */
-		pskb_trim_rcsum(skb, start_of_padding - ETH_HLEN);
+		if (pskb_trim_rcsum(skb, start_of_padding - ETH_HLEN))
+			return NULL;
 	/* Trap-to-host frame, no timestamp trailer */
 	} else {
 		*source_port = SJA1110_RX_HEADER_SRC_PORT(rx_header);
diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index 943edf4ad4db..3528e8befa58 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -841,6 +841,9 @@ static int rtm_to_fib_config(struct net *net, struct sk_buff *skb,
 		return -EINVAL;
 	}
 
+	if (!cfg->fc_table)
+		cfg->fc_table = RT_TABLE_MAIN;
+
 	return 0;
 errout:
 	return err;
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index cb24260692e1..7885b2f15315 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -423,6 +423,7 @@ static struct fib_info *fib_find_info(struct fib_info *nfi)
 		    nfi->fib_prefsrc == fi->fib_prefsrc &&
 		    nfi->fib_priority == fi->fib_priority &&
 		    nfi->fib_type == fi->fib_type &&
+		    nfi->fib_tb_id == fi->fib_tb_id &&
 		    memcmp(nfi->fib_metrics, fi->fib_metrics,
 			   sizeof(u32) * RTAX_MAX) == 0 &&
 		    !((nfi->fib_flags ^ fi->fib_flags) & ~RTNH_COMPARE_MASK) &&
diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index f866d6282b2b..cae9f1a4e059 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -1492,24 +1492,6 @@ static int ipgre_fill_info(struct sk_buff *skb, const struct net_device *dev)
 	struct ip_tunnel_parm *p = &t->parms;
 	__be16 o_flags = p->o_flags;
 
-	if (t->erspan_ver <= 2) {
-		if (t->erspan_ver != 0 && !t->collect_md)
-			o_flags |= TUNNEL_KEY;
-
-		if (nla_put_u8(skb, IFLA_GRE_ERSPAN_VER, t->erspan_ver))
-			goto nla_put_failure;
-
-		if (t->erspan_ver == 1) {
-			if (nla_put_u32(skb, IFLA_GRE_ERSPAN_INDEX, t->index))
-				goto nla_put_failure;
-		} else if (t->erspan_ver == 2) {
-			if (nla_put_u8(skb, IFLA_GRE_ERSPAN_DIR, t->dir))
-				goto nla_put_failure;
-			if (nla_put_u16(skb, IFLA_GRE_ERSPAN_HWID, t->hwid))
-				goto nla_put_failure;
-		}
-	}
-
 	if (nla_put_u32(skb, IFLA_GRE_LINK, p->link) ||
 	    nla_put_be16(skb, IFLA_GRE_IFLAGS,
 			 gre_tnl_flags_to_gre_flags(p->i_flags)) ||
@@ -1550,6 +1532,34 @@ static int ipgre_fill_info(struct sk_buff *skb, const struct net_device *dev)
 	return -EMSGSIZE;
 }
 
+static int erspan_fill_info(struct sk_buff *skb, const struct net_device *dev)
+{
+	struct ip_tunnel *t = netdev_priv(dev);
+
+	if (t->erspan_ver <= 2) {
+		if (t->erspan_ver != 0 && !t->collect_md)
+			t->parms.o_flags |= TUNNEL_KEY;
+
+		if (nla_put_u8(skb, IFLA_GRE_ERSPAN_VER, t->erspan_ver))
+			goto nla_put_failure;
+
+		if (t->erspan_ver == 1) {
+			if (nla_put_u32(skb, IFLA_GRE_ERSPAN_INDEX, t->index))
+				goto nla_put_failure;
+		} else if (t->erspan_ver == 2) {
+			if (nla_put_u8(skb, IFLA_GRE_ERSPAN_DIR, t->dir))
+				goto nla_put_failure;
+			if (nla_put_u16(skb, IFLA_GRE_ERSPAN_HWID, t->hwid))
+				goto nla_put_failure;
+		}
+	}
+
+	return ipgre_fill_info(skb, dev);
+
+nla_put_failure:
+	return -EMSGSIZE;
+}
+
 static void erspan_setup(struct net_device *dev)
 {
 	struct ip_tunnel *t = netdev_priv(dev);
@@ -1628,7 +1638,7 @@ static struct rtnl_link_ops erspan_link_ops __read_mostly = {
 	.changelink	= erspan_changelink,
 	.dellink	= ip_tunnel_dellink,
 	.get_size	= ipgre_get_size,
-	.fill_info	= ipgre_fill_info,
+	.fill_info	= erspan_fill_info,
 	.get_link_net	= ip_tunnel_get_link_net,
 };
 
diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index b83c2bd9d722..3b2420829c23 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -48,6 +48,11 @@
 #include <net/transp_v6.h>
 #endif
 
+#define ping_portaddr_for_each_entry(__sk, node, list) \
+	hlist_nulls_for_each_entry(__sk, node, list, sk_nulls_node)
+#define ping_portaddr_for_each_entry_rcu(__sk, node, list) \
+	hlist_nulls_for_each_entry_rcu(__sk, node, list, sk_nulls_node)
+
 struct ping_table {
 	struct hlist_nulls_head	hash[PING_HTABLE_SIZE];
 	spinlock_t		lock;
@@ -191,7 +196,7 @@ static struct sock *ping_lookup(struct net *net, struct sk_buff *skb, u16 ident)
 		return NULL;
 	}
 
-	ping_portaddr_for_each_entry(sk, hnode, hslot) {
+	ping_portaddr_for_each_entry_rcu(sk, hnode, hslot) {
 		isk = inet_sk(sk);
 
 		pr_debug("iterate\n");
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index f152e51242cb..4fb5dd35af18 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -920,6 +920,9 @@ int ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 		if (err < 0)
 			goto fail;
 
+		/* We prevent @rt from being freed. */
+		rcu_read_lock();
+
 		for (;;) {
 			/* Prepare header of the next frame,
 			 * before previous one went down. */
@@ -943,6 +946,7 @@ int ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 		if (err == 0) {
 			IP6_INC_STATS(net, ip6_dst_idev(&rt->dst),
 				      IPSTATS_MIB_FRAGOKS);
+			rcu_read_unlock();
 			return 0;
 		}
 
@@ -950,6 +954,7 @@ int ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 
 		IP6_INC_STATS(net, ip6_dst_idev(&rt->dst),
 			      IPSTATS_MIB_FRAGFAILS);
+		rcu_read_unlock();
 		return err;
 
 slow_path_clean:
diff --git a/net/mac802154/iface.c b/net/mac802154/iface.c
index 500ed1b81250..7e2065e72915 100644
--- a/net/mac802154/iface.c
+++ b/net/mac802154/iface.c
@@ -662,6 +662,7 @@ ieee802154_if_add(struct ieee802154_local *local, const char *name,
 	sdata->dev = ndev;
 	sdata->wpan_dev.wpan_phy = local->hw.phy;
 	sdata->local = local;
+	INIT_LIST_HEAD(&sdata->wpan_dev.list);
 
 	/* setup type-dependent data */
 	ret = ieee802154_setup_sdata(sdata, type);
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 60289c074eef..df46e9a35e47 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -891,7 +891,7 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
 	zone = nf_ct_zone(ct);
 
 	if (!nf_ct_ext_valid_pre(ct->ext)) {
-		NF_CT_STAT_INC(net, insert_failed);
+		NF_CT_STAT_INC_ATOMIC(net, insert_failed);
 		return -ETIMEDOUT;
 	}
 
@@ -938,7 +938,7 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
 
 	if (!nf_ct_ext_valid_post(ct->ext)) {
 		nf_ct_kill(ct);
-		NF_CT_STAT_INC(net, drop);
+		NF_CT_STAT_INC_ATOMIC(net, drop);
 		return -ETIMEDOUT;
 	}
 
@@ -1275,7 +1275,7 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 	 */
 	if (!nf_ct_ext_valid_post(ct->ext)) {
 		nf_ct_kill(ct);
-		NF_CT_STAT_INC(net, drop);
+		NF_CT_STAT_INC_ATOMIC(net, drop);
 		return NF_DROP;
 	}
 
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index d71150a40fb0..1286ae7d4609 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -328,8 +328,13 @@ ctnetlink_dump_timestamp(struct sk_buff *skb, const struct nf_conn *ct)
 }
 
 #ifdef CONFIG_NF_CONNTRACK_MARK
-static int ctnetlink_dump_mark(struct sk_buff *skb, u32 mark)
+static int ctnetlink_dump_mark(struct sk_buff *skb, const struct nf_conn *ct)
 {
+	u32 mark = READ_ONCE(ct->mark);
+
+	if (!mark)
+		return 0;
+
 	if (nla_put_be32(skb, CTA_MARK, htonl(mark)))
 		goto nla_put_failure;
 	return 0;
@@ -543,7 +548,7 @@ static int ctnetlink_dump_extinfo(struct sk_buff *skb,
 static int ctnetlink_dump_info(struct sk_buff *skb, struct nf_conn *ct)
 {
 	if (ctnetlink_dump_status(skb, ct) < 0 ||
-	    ctnetlink_dump_mark(skb, READ_ONCE(ct->mark)) < 0 ||
+	    ctnetlink_dump_mark(skb, ct) < 0 ||
 	    ctnetlink_dump_secctx(skb, ct) < 0 ||
 	    ctnetlink_dump_id(skb, ct) < 0 ||
 	    ctnetlink_dump_use(skb, ct) < 0 ||
@@ -722,7 +727,6 @@ ctnetlink_conntrack_event(unsigned int events, const struct nf_ct_event *item)
 	struct sk_buff *skb;
 	unsigned int type;
 	unsigned int flags = 0, group;
-	u32 mark;
 	int err;
 
 	if (events & (1 << IPCT_DESTROY)) {
@@ -827,9 +831,8 @@ ctnetlink_conntrack_event(unsigned int events, const struct nf_ct_event *item)
 	}
 
 #ifdef CONFIG_NF_CONNTRACK_MARK
-	mark = READ_ONCE(ct->mark);
-	if ((events & (1 << IPCT_MARK) || mark) &&
-	    ctnetlink_dump_mark(skb, mark) < 0)
+	if (events & (1 << IPCT_MARK) &&
+	    ctnetlink_dump_mark(skb, ct) < 0)
 		goto nla_put_failure;
 #endif
 	nlmsg_end(skb, nlh);
@@ -2671,7 +2674,6 @@ static int __ctnetlink_glue_build(struct sk_buff *skb, struct nf_conn *ct)
 {
 	const struct nf_conntrack_zone *zone;
 	struct nlattr *nest_parms;
-	u32 mark;
 
 	zone = nf_ct_zone(ct);
 
@@ -2733,8 +2735,7 @@ static int __ctnetlink_glue_build(struct sk_buff *skb, struct nf_conn *ct)
 		goto nla_put_failure;
 
 #ifdef CONFIG_NF_CONNTRACK_MARK
-	mark = READ_ONCE(ct->mark);
-	if (mark && ctnetlink_dump_mark(skb, mark) < 0)
+	if (ctnetlink_dump_mark(skb, ct) < 0)
 		goto nla_put_failure;
 #endif
 	if (ctnetlink_dump_labels(skb, ct) < 0)
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 00b522890d77..0fdcdb2c9ae4 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -997,13 +997,13 @@ static void flow_offload_queue_work(struct flow_offload_work *offload)
 	struct net *net = read_pnet(&offload->flowtable->net);
 
 	if (offload->cmd == FLOW_CLS_REPLACE) {
-		NF_FLOW_TABLE_STAT_INC(net, count_wq_add);
+		NF_FLOW_TABLE_STAT_INC_ATOMIC(net, count_wq_add);
 		queue_work(nf_flow_offload_add_wq, &offload->work);
 	} else if (offload->cmd == FLOW_CLS_DESTROY) {
-		NF_FLOW_TABLE_STAT_INC(net, count_wq_del);
+		NF_FLOW_TABLE_STAT_INC_ATOMIC(net, count_wq_del);
 		queue_work(nf_flow_offload_del_wq, &offload->work);
 	} else {
-		NF_FLOW_TABLE_STAT_INC(net, count_wq_stats);
+		NF_FLOW_TABLE_STAT_INC_ATOMIC(net, count_wq_stats);
 		queue_work(nf_flow_offload_stats_wq, &offload->work);
 	}
 }
diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 4f9299b9dcdd..06d46d182634 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1162,6 +1162,7 @@ static int nft_pipapo_insert(const struct net *net, const struct nft_set *set,
 	struct nft_pipapo_match *m = priv->clone;
 	u8 genmask = nft_genmask_next(net);
 	struct nft_pipapo_field *f;
+	const u8 *start_p, *end_p;
 	int i, bsize_max, err = 0;
 
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_KEY_END))
@@ -1202,9 +1203,9 @@ static int nft_pipapo_insert(const struct net *net, const struct nft_set *set,
 	}
 
 	/* Validate */
+	start_p = start;
+	end_p = end;
 	nft_pipapo_for_each_field(f, i, m) {
-		const u8 *start_p = start, *end_p = end;
-
 		if (f->rules >= (unsigned long)NFT_PIPAPO_RULE0_MAX)
 			return -ENOSPC;
 
diff --git a/net/nfc/nci/ntf.c b/net/nfc/nci/ntf.c
index 282c51051dcc..994a0a1efb58 100644
--- a/net/nfc/nci/ntf.c
+++ b/net/nfc/nci/ntf.c
@@ -240,6 +240,8 @@ static int nci_add_new_protocol(struct nci_dev *ndev,
 		target->sens_res = nfca_poll->sens_res;
 		target->sel_res = nfca_poll->sel_res;
 		target->nfcid1_len = nfca_poll->nfcid1_len;
+		if (target->nfcid1_len > ARRAY_SIZE(target->nfcid1))
+			return -EPROTO;
 		if (target->nfcid1_len > 0) {
 			memcpy(target->nfcid1, nfca_poll->nfcid1,
 			       target->nfcid1_len);
@@ -248,6 +250,8 @@ static int nci_add_new_protocol(struct nci_dev *ndev,
 		nfcb_poll = (struct rf_tech_specific_params_nfcb_poll *)params;
 
 		target->sensb_res_len = nfcb_poll->sensb_res_len;
+		if (target->sensb_res_len > ARRAY_SIZE(target->sensb_res))
+			return -EPROTO;
 		if (target->sensb_res_len > 0) {
 			memcpy(target->sensb_res, nfcb_poll->sensb_res,
 			       target->sensb_res_len);
@@ -256,6 +260,8 @@ static int nci_add_new_protocol(struct nci_dev *ndev,
 		nfcf_poll = (struct rf_tech_specific_params_nfcf_poll *)params;
 
 		target->sensf_res_len = nfcf_poll->sensf_res_len;
+		if (target->sensf_res_len > ARRAY_SIZE(target->sensf_res))
+			return -EPROTO;
 		if (target->sensf_res_len > 0) {
 			memcpy(target->sensf_res, nfcf_poll->sensf_res,
 			       target->sensf_res_len);
diff --git a/net/tipc/link.c b/net/tipc/link.c
index e260c0d557f5..b3ce24823f50 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -2224,7 +2224,9 @@ static int tipc_link_proto_rcv(struct tipc_link *l, struct sk_buff *skb,
 	if (tipc_own_addr(l->net) > msg_prevnode(hdr))
 		l->net_plane = msg_net_plane(hdr);
 
-	skb_linearize(skb);
+	if (skb_linearize(skb))
+		goto exit;
+
 	hdr = buf_msg(skb);
 	data = msg_data(hdr);
 
diff --git a/net/tipc/node.c b/net/tipc/node.c
index b48d97cbbe29..49ddc484c4fe 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -1689,6 +1689,7 @@ int tipc_node_xmit(struct net *net, struct sk_buff_head *list,
 	struct tipc_node *n;
 	struct sk_buff_head xmitq;
 	bool node_up = false;
+	struct net *peer_net;
 	int bearer_id;
 	int rc;
 
@@ -1705,18 +1706,23 @@ int tipc_node_xmit(struct net *net, struct sk_buff_head *list,
 		return -EHOSTUNREACH;
 	}
 
+	rcu_read_lock();
 	tipc_node_read_lock(n);
 	node_up = node_is_up(n);
-	if (node_up && n->peer_net && check_net(n->peer_net)) {
+	peer_net = n->peer_net;
+	tipc_node_read_unlock(n);
+	if (node_up && peer_net && check_net(peer_net)) {
 		/* xmit inner linux container */
-		tipc_lxc_xmit(n->peer_net, list);
+		tipc_lxc_xmit(peer_net, list);
 		if (likely(skb_queue_empty(list))) {
-			tipc_node_read_unlock(n);
+			rcu_read_unlock();
 			tipc_node_put(n);
 			return 0;
 		}
 	}
+	rcu_read_unlock();
 
+	tipc_node_read_lock(n);
 	bearer_id = n->active_links[selector & 1];
 	if (unlikely(bearer_id == INVALID_BEARER_ID)) {
 		tipc_node_read_unlock(n);
diff --git a/net/unix/diag.c b/net/unix/diag.c
index 105f522a89fe..616b55c5b890 100644
--- a/net/unix/diag.c
+++ b/net/unix/diag.c
@@ -114,14 +114,16 @@ static int sk_diag_show_rqlen(struct sock *sk, struct sk_buff *nlskb)
 	return nla_put(nlskb, UNIX_DIAG_RQLEN, sizeof(rql), &rql);
 }
 
-static int sk_diag_dump_uid(struct sock *sk, struct sk_buff *nlskb)
+static int sk_diag_dump_uid(struct sock *sk, struct sk_buff *nlskb,
+			    struct user_namespace *user_ns)
 {
-	uid_t uid = from_kuid_munged(sk_user_ns(nlskb->sk), sock_i_uid(sk));
+	uid_t uid = from_kuid_munged(user_ns, sock_i_uid(sk));
 	return nla_put(nlskb, UNIX_DIAG_UID, sizeof(uid_t), &uid);
 }
 
 static int sk_diag_fill(struct sock *sk, struct sk_buff *skb, struct unix_diag_req *req,
-		u32 portid, u32 seq, u32 flags, int sk_ino)
+			struct user_namespace *user_ns,
+			u32 portid, u32 seq, u32 flags, int sk_ino)
 {
 	struct nlmsghdr *nlh;
 	struct unix_diag_msg *rep;
@@ -167,7 +169,7 @@ static int sk_diag_fill(struct sock *sk, struct sk_buff *skb, struct unix_diag_r
 		goto out_nlmsg_trim;
 
 	if ((req->udiag_show & UDIAG_SHOW_UID) &&
-	    sk_diag_dump_uid(sk, skb))
+	    sk_diag_dump_uid(sk, skb, user_ns))
 		goto out_nlmsg_trim;
 
 	nlmsg_end(skb, nlh);
@@ -179,7 +181,8 @@ static int sk_diag_fill(struct sock *sk, struct sk_buff *skb, struct unix_diag_r
 }
 
 static int sk_diag_dump(struct sock *sk, struct sk_buff *skb, struct unix_diag_req *req,
-		u32 portid, u32 seq, u32 flags)
+			struct user_namespace *user_ns,
+			u32 portid, u32 seq, u32 flags)
 {
 	int sk_ino;
 
@@ -190,7 +193,7 @@ static int sk_diag_dump(struct sock *sk, struct sk_buff *skb, struct unix_diag_r
 	if (!sk_ino)
 		return 0;
 
-	return sk_diag_fill(sk, skb, req, portid, seq, flags, sk_ino);
+	return sk_diag_fill(sk, skb, req, user_ns, portid, seq, flags, sk_ino);
 }
 
 static int unix_diag_dump(struct sk_buff *skb, struct netlink_callback *cb)
@@ -214,7 +217,7 @@ static int unix_diag_dump(struct sk_buff *skb, struct netlink_callback *cb)
 				goto next;
 			if (!(req->udiag_states & (1 << sk->sk_state)))
 				goto next;
-			if (sk_diag_dump(sk, skb, req,
+			if (sk_diag_dump(sk, skb, req, sk_user_ns(skb->sk),
 					 NETLINK_CB(cb->skb).portid,
 					 cb->nlh->nlmsg_seq,
 					 NLM_F_MULTI) < 0) {
@@ -282,7 +285,8 @@ static int unix_diag_get_exact(struct sk_buff *in_skb,
 	if (!rep)
 		goto out;
 
-	err = sk_diag_fill(sk, rep, req, NETLINK_CB(in_skb).portid,
+	err = sk_diag_fill(sk, rep, req, sk_user_ns(NETLINK_CB(in_skb).sk),
+			   NETLINK_CB(in_skb).portid,
 			   nlh->nlmsg_seq, 0, req->udiag_ino);
 	if (err < 0) {
 		nlmsg_free(rep);
diff --git a/sound/core/seq/seq_memory.c b/sound/core/seq/seq_memory.c
index b7aee23fc387..47ef6bc30c0e 100644
--- a/sound/core/seq/seq_memory.c
+++ b/sound/core/seq/seq_memory.c
@@ -113,15 +113,19 @@ EXPORT_SYMBOL(snd_seq_dump_var_event);
  * expand the variable length event to linear buffer space.
  */
 
-static int seq_copy_in_kernel(char **bufptr, const void *src, int size)
+static int seq_copy_in_kernel(void *ptr, void *src, int size)
 {
+	char **bufptr = ptr;
+
 	memcpy(*bufptr, src, size);
 	*bufptr += size;
 	return 0;
 }
 
-static int seq_copy_in_user(char __user **bufptr, const void *src, int size)
+static int seq_copy_in_user(void *ptr, void *src, int size)
 {
+	char __user **bufptr = ptr;
+
 	if (copy_to_user(*bufptr, src, size))
 		return -EFAULT;
 	*bufptr += size;
@@ -151,8 +155,7 @@ int snd_seq_expand_var_event(const struct snd_seq_event *event, int count, char
 		return newlen;
 	}
 	err = snd_seq_dump_var_event(event,
-				     in_kernel ? (snd_seq_dump_func_t)seq_copy_in_kernel :
-				     (snd_seq_dump_func_t)seq_copy_in_user,
+				     in_kernel ? seq_copy_in_kernel : seq_copy_in_user,
 				     &buf);
 	return err < 0 ? err : newlen;
 }
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index bf58e98c7a69..d8c6af9e43ad 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -18,6 +18,7 @@
 #include <linux/module.h>
 #include <linux/input.h>
 #include <linux/leds.h>
+#include <linux/ctype.h>
 #include <sound/core.h>
 #include <sound/jack.h>
 #include <sound/hda_codec.h>
@@ -6704,23 +6705,51 @@ static void comp_generic_playback_hook(struct hda_pcm_stream *hinfo, struct hda_
 	}
 }
 
+struct cs35l41_dev_name {
+	const char *bus;
+	const char *hid;
+	int index;
+};
+
+/* match the device name in a slightly relaxed manner */
+static int comp_match_cs35l41_dev_name(struct device *dev, void *data)
+{
+	struct cs35l41_dev_name *p = data;
+	const char *d = dev_name(dev);
+	int n = strlen(p->bus);
+	char tmp[32];
+
+	/* check the bus name */
+	if (strncmp(d, p->bus, n))
+		return 0;
+	/* skip the bus number */
+	if (isdigit(d[n]))
+		n++;
+	/* the rest must be exact matching */
+	snprintf(tmp, sizeof(tmp), "-%s:00-cs35l41-hda.%d", p->hid, p->index);
+	return !strcmp(d + n, tmp);
+}
+
 static void cs35l41_generic_fixup(struct hda_codec *cdc, int action, const char *bus,
 				  const char *hid, int count)
 {
 	struct device *dev = hda_codec_dev(cdc);
 	struct alc_spec *spec = cdc->spec;
-	char *name;
+	struct cs35l41_dev_name *rec;
 	int ret, i;
 
 	switch (action) {
 	case HDA_FIXUP_ACT_PRE_PROBE:
 		for (i = 0; i < count; i++) {
-			name = devm_kasprintf(dev, GFP_KERNEL,
-					      "%s-%s:00-cs35l41-hda.%d", bus, hid, i);
-			if (!name)
+			rec = devm_kmalloc(dev, sizeof(*rec), GFP_KERNEL);
+			if (!rec)
 				return;
+			rec->bus = bus;
+			rec->hid = hid;
+			rec->index = i;
 			spec->comps[i].codec = cdc;
-			component_match_add(dev, &spec->match, component_compare_dev_name, name);
+			component_match_add(dev, &spec->match,
+					    comp_match_cs35l41_dev_name, rec);
 		}
 		ret = component_master_add_with_match(dev, &comp_master_ops, spec->match);
 		if (ret)
@@ -6738,17 +6767,12 @@ static void cs35l41_fixup_i2c_two(struct hda_codec *cdc, const struct hda_fixup
 
 static void cs35l41_fixup_spi_two(struct hda_codec *codec, const struct hda_fixup *fix, int action)
 {
-	cs35l41_generic_fixup(codec, action, "spi0", "CSC3551", 2);
-}
-
-static void cs35l41_fixup_spi1_two(struct hda_codec *codec, const struct hda_fixup *fix, int action)
-{
-	cs35l41_generic_fixup(codec, action, "spi1", "CSC3551", 2);
+	cs35l41_generic_fixup(codec, action, "spi", "CSC3551", 2);
 }
 
 static void cs35l41_fixup_spi_four(struct hda_codec *codec, const struct hda_fixup *fix, int action)
 {
-	cs35l41_generic_fixup(codec, action, "spi0", "CSC3551", 4);
+	cs35l41_generic_fixup(codec, action, "spi", "CSC3551", 4);
 }
 
 static void alc287_fixup_legion_16achg6_speakers(struct hda_codec *cdc, const struct hda_fixup *fix,
@@ -7137,8 +7161,6 @@ enum {
 	ALC287_FIXUP_CS35L41_I2C_2_HP_GPIO_LED,
 	ALC245_FIXUP_CS35L41_SPI_2,
 	ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED,
-	ALC245_FIXUP_CS35L41_SPI1_2,
-	ALC245_FIXUP_CS35L41_SPI1_2_HP_GPIO_LED,
 	ALC245_FIXUP_CS35L41_SPI_4,
 	ALC245_FIXUP_CS35L41_SPI_4_HP_GPIO_LED,
 	ALC285_FIXUP_HP_SPEAKERS_MICMUTE_LED,
@@ -8988,16 +9010,6 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chained = true,
 		.chain_id = ALC285_FIXUP_HP_GPIO_LED,
 	},
-	[ALC245_FIXUP_CS35L41_SPI1_2] = {
-		.type = HDA_FIXUP_FUNC,
-		.v.func = cs35l41_fixup_spi1_two,
-	},
-	[ALC245_FIXUP_CS35L41_SPI1_2_HP_GPIO_LED] = {
-		.type = HDA_FIXUP_FUNC,
-		.v.func = cs35l41_fixup_spi1_two,
-		.chained = true,
-		.chain_id = ALC285_FIXUP_HP_GPIO_LED,
-	},
 	[ALC245_FIXUP_CS35L41_SPI_4] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = cs35l41_fixup_spi_four,
@@ -9361,7 +9373,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8aa3, "HP ProBook 450 G9 (MB 8AA1)", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8aa8, "HP EliteBook 640 G9 (MB 8AA6)", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8aab, "HP EliteBook 650 G9 (MB 8AA9)", ALC236_FIXUP_HP_GPIO_LED),
-	 SND_PCI_QUIRK(0x103c, 0x8abb, "HP ZBook Firefly 14 G9", ALC245_FIXUP_CS35L41_SPI1_2_HP_GPIO_LED),
+	 SND_PCI_QUIRK(0x103c, 0x8abb, "HP ZBook Firefly 14 G9", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8ad1, "HP EliteBook 840 14 inch G9 Notebook PC", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8ad2, "HP EliteBook 860 16 inch G9 Notebook PC", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x1043, 0x103e, "ASUS X540SA", ALC256_FIXUP_ASUS_MIC),
diff --git a/sound/soc/codecs/rt711-sdca-sdw.c b/sound/soc/codecs/rt711-sdca-sdw.c
index a085b2f530aa..31e77d462ef3 100644
--- a/sound/soc/codecs/rt711-sdca-sdw.c
+++ b/sound/soc/codecs/rt711-sdca-sdw.c
@@ -230,7 +230,7 @@ static int rt711_sdca_read_prop(struct sdw_slave *slave)
 	}
 
 	/* set the timeout values */
-	prop->clk_stop_timeout = 20;
+	prop->clk_stop_timeout = 700;
 
 	/* wake-up event */
 	prop->wake_capable = 1;
diff --git a/sound/soc/codecs/wm8962.c b/sound/soc/codecs/wm8962.c
index 6df06fba4377..ee1cad5af535 100644
--- a/sound/soc/codecs/wm8962.c
+++ b/sound/soc/codecs/wm8962.c
@@ -2503,6 +2503,14 @@ static void wm8962_configure_bclk(struct snd_soc_component *component)
 		snd_soc_component_update_bits(component, WM8962_CLOCKING2,
 				WM8962_SYSCLK_ENA_MASK, WM8962_SYSCLK_ENA);
 
+	/* DSPCLK_DIV field in WM8962_CLOCKING1 register is used to generate
+	 * correct frequency of LRCLK and BCLK. Sometimes the read-only value
+	 * can't be updated timely after enabling SYSCLK. This results in wrong
+	 * calculation values. Delay is introduced here to wait for newest
+	 * value from register. The time of the delay should be at least
+	 * 500~1000us according to test.
+	 */
+	usleep_range(500, 1000);
 	dspclk = snd_soc_component_read(component, WM8962_CLOCKING1);
 
 	if (snd_soc_component_get_bias_level(component) != SND_SOC_BIAS_ON)
diff --git a/sound/soc/soc-pcm.c b/sound/soc/soc-pcm.c
index f6a996f0f9c7..f000a7168afc 100644
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -1242,6 +1242,8 @@ static void dpcm_be_reparent(struct snd_soc_pcm_runtime *fe,
 		return;
 
 	be_substream = snd_soc_dpcm_get_substream(be, stream);
+	if (!be_substream)
+		return;
 
 	for_each_dpcm_fe(be, stream, dpcm) {
 		if (dpcm->fe == fe)
diff --git a/tools/testing/selftests/net/config b/tools/testing/selftests/net/config
index ead7963b9bf0..bd89198cd817 100644
--- a/tools/testing/selftests/net/config
+++ b/tools/testing/selftests/net/config
@@ -43,5 +43,5 @@ CONFIG_NET_ACT_TUNNEL_KEY=m
 CONFIG_NET_ACT_MIRRED=m
 CONFIG_BAREUDP=m
 CONFIG_IPV6_IOAM6_LWTUNNEL=y
-CONFIG_CRYPTO_SM4=y
+CONFIG_CRYPTO_SM4_GENERIC=y
 CONFIG_AMT=m
diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index 31c3b6ebd388..21ca91473c09 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -4196,10 +4196,13 @@ elif [ "$TESTS" = "ipv6" ]; then
 	TESTS="$TESTS_IPV6"
 fi
 
-which nettest >/dev/null
-if [ $? -ne 0 ]; then
-	echo "'nettest' command not found; skipping tests"
-	exit $ksft_skip
+# nettest can be run from PATH or from same directory as this selftest
+if ! which nettest >/dev/null; then
+	PATH=$PWD:$PATH
+	if ! which nettest >/dev/null; then
+		echo "'nettest' command not found; skipping tests"
+		exit $ksft_skip
+	fi
 fi
 
 declare -i nfail=0
diff --git a/tools/testing/selftests/net/fib_tests.sh b/tools/testing/selftests/net/fib_tests.sh
index 2271a8727f62..5637b5dadabd 100755
--- a/tools/testing/selftests/net/fib_tests.sh
+++ b/tools/testing/selftests/net/fib_tests.sh
@@ -1711,13 +1711,21 @@ ipv4_del_addr_test()
 
 	$IP addr add dev dummy1 172.16.104.1/24
 	$IP addr add dev dummy1 172.16.104.11/24
+	$IP addr add dev dummy1 172.16.104.12/24
+	$IP addr add dev dummy1 172.16.104.13/24
 	$IP addr add dev dummy2 172.16.104.1/24
 	$IP addr add dev dummy2 172.16.104.11/24
+	$IP addr add dev dummy2 172.16.104.12/24
 	$IP route add 172.16.105.0/24 via 172.16.104.2 src 172.16.104.11
+	$IP route add 172.16.106.0/24 dev lo src 172.16.104.12
+	$IP route add table 0 172.16.107.0/24 via 172.16.104.2 src 172.16.104.13
 	$IP route add vrf red 172.16.105.0/24 via 172.16.104.2 src 172.16.104.11
+	$IP route add vrf red 172.16.106.0/24 dev lo src 172.16.104.12
 	set +e
 
 	# removing address from device in vrf should only remove route from vrf table
+	echo "    Regular FIB info"
+
 	$IP addr del dev dummy2 172.16.104.11/24
 	$IP ro ls vrf red | grep -q 172.16.105.0/24
 	log_test $? 1 "Route removed from VRF when source address deleted"
@@ -1735,6 +1743,35 @@ ipv4_del_addr_test()
 	$IP ro ls vrf red | grep -q 172.16.105.0/24
 	log_test $? 0 "Route in VRF is not removed by address delete"
 
+	# removing address from device in vrf should only remove route from vrf
+	# table even when the associated fib info only differs in table ID
+	echo "    Identical FIB info with different table ID"
+
+	$IP addr del dev dummy2 172.16.104.12/24
+	$IP ro ls vrf red | grep -q 172.16.106.0/24
+	log_test $? 1 "Route removed from VRF when source address deleted"
+
+	$IP ro ls | grep -q 172.16.106.0/24
+	log_test $? 0 "Route in default VRF not removed"
+
+	$IP addr add dev dummy2 172.16.104.12/24
+	$IP route add vrf red 172.16.106.0/24 dev lo src 172.16.104.12
+
+	$IP addr del dev dummy1 172.16.104.12/24
+	$IP ro ls | grep -q 172.16.106.0/24
+	log_test $? 1 "Route removed in default VRF when source address deleted"
+
+	$IP ro ls vrf red | grep -q 172.16.106.0/24
+	log_test $? 0 "Route in VRF is not removed by address delete"
+
+	# removing address from device in default vrf should remove route from
+	# the default vrf even when route was inserted with a table ID of 0.
+	echo "    Table ID 0"
+
+	$IP addr del dev dummy1 172.16.104.13/24
+	$IP ro ls | grep -q 172.16.107.0/24
+	log_test $? 1 "Route removed in default VRF when source address deleted"
+
 	$IP li del dummy1
 	$IP li del dummy2
 	cleanup
diff --git a/tools/testing/selftests/net/pmtu.sh b/tools/testing/selftests/net/pmtu.sh
index 736e358dc549..dfe3d287f01d 100755
--- a/tools/testing/selftests/net/pmtu.sh
+++ b/tools/testing/selftests/net/pmtu.sh
@@ -686,10 +686,12 @@ setup_xfrm() {
 }
 
 setup_nettest_xfrm() {
-	which nettest >/dev/null
-	if [ $? -ne 0 ]; then
-		echo "'nettest' command not found; skipping tests"
-	        return 1
+	if ! which nettest >/dev/null; then
+		PATH=$PWD:$PATH
+		if ! which nettest >/dev/null; then
+			echo "'nettest' command not found; skipping tests"
+			return 1
+		fi
 	fi
 
 	[ ${1} -eq 6 ] && proto="-6" || proto=""
diff --git a/tools/testing/selftests/net/rtnetlink.sh b/tools/testing/selftests/net/rtnetlink.sh
index 0900c5438fbb..275491be3da2 100755
--- a/tools/testing/selftests/net/rtnetlink.sh
+++ b/tools/testing/selftests/net/rtnetlink.sh
@@ -782,7 +782,7 @@ kci_test_ipsec_offload()
 	    tmpl proto esp src $srcip dst $dstip spi 9 \
 	    mode transport reqid 42
 	check_err $?
-	ip x p add dir out src $dstip/24 dst $srcip/24 \
+	ip x p add dir in src $dstip/24 dst $srcip/24 \
 	    tmpl proto esp src $dstip dst $srcip spi 9 \
 	    mode transport reqid 42
 	check_err $?
