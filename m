Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7C365B97FF
	for <lists+stable@lfdr.de>; Thu, 15 Sep 2022 11:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbiIOJsG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Sep 2022 05:48:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbiIOJrq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Sep 2022 05:47:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0A9A9A94B;
        Thu, 15 Sep 2022 02:46:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5EF6961AEA;
        Thu, 15 Sep 2022 09:46:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04B6AC43470;
        Thu, 15 Sep 2022 09:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663235209;
        bh=rgAxFZ8GCIFdS0fOw3ZA65h3+uxUB7reaXeu2jKVJKU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gEF2QfEwREVTyTYDA8zxlkPhzc+DkbGRjf7v1I42o+rX01M7Ozg1H1h2xQ5NP4xel
         r+ylqVxeCDUTLIPCcaMyLhyq/ib9z9nl1d4y90kSaEJyTub2WBQAQ2voNjwtRAWnrn
         lWufqrKS0dCG5e4l9t003DYBYUUJLPaGNykyU4dc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.68
Date:   Thu, 15 Sep 2022 11:47:10 +0200
Message-Id: <166323522914918@kroah.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <1663235229191201@kroah.com>
References: <1663235229191201@kroah.com>
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

diff --git a/Documentation/arm64/silicon-errata.rst b/Documentation/arm64/silicon-errata.rst
index 46644736e583..663001f69773 100644
--- a/Documentation/arm64/silicon-errata.rst
+++ b/Documentation/arm64/silicon-errata.rst
@@ -94,6 +94,8 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A510     | #2441009        | ARM64_ERRATUM_2441009       |
 +----------------+-----------------+-----------------+-----------------------------+
+| ARM            | Cortex-A510     | #2457168        | ARM64_ERRATUM_2457168       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Neoverse-N1     | #1188873,1418040| ARM64_ERRATUM_1418040       |
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Neoverse-N1     | #1349291        | N/A                         |
diff --git a/Makefile b/Makefile
index eca45b7be9c1..d6b672375c07 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 67
+SUBLEVEL = 68
 EXTRAVERSION =
 NAME = Trick or Treat
 
@@ -1332,8 +1332,7 @@ hdr-inst := -f $(srctree)/scripts/Makefile.headersinst obj
 
 PHONY += headers
 headers: $(version_h) scripts_unifdef uapi-asm-generic archheaders archscripts
-	$(if $(wildcard $(srctree)/arch/$(SRCARCH)/include/uapi/asm/Kbuild),, \
-	  $(error Headers not exportable for the $(SRCARCH) architecture))
+	$(if $(filter um, $(SRCARCH)), $(error Headers not exportable for UML))
 	$(Q)$(MAKE) $(hdr-inst)=include/uapi
 	$(Q)$(MAKE) $(hdr-inst)=arch/$(SRCARCH)/include/uapi
 
diff --git a/arch/arm/boot/dts/at91-sama5d27_wlsom1.dtsi b/arch/arm/boot/dts/at91-sama5d27_wlsom1.dtsi
index 025a78310e3a..a818e8ebd638 100644
--- a/arch/arm/boot/dts/at91-sama5d27_wlsom1.dtsi
+++ b/arch/arm/boot/dts/at91-sama5d27_wlsom1.dtsi
@@ -68,8 +68,8 @@ mcp16502@5b {
 		regulators {
 			vdd_3v3: VDD_IO {
 				regulator-name = "VDD_IO";
-				regulator-min-microvolt = <1200000>;
-				regulator-max-microvolt = <3700000>;
+				regulator-min-microvolt = <3300000>;
+				regulator-max-microvolt = <3300000>;
 				regulator-initial-mode = <2>;
 				regulator-allowed-modes = <2>, <4>;
 				regulator-always-on;
@@ -87,8 +87,8 @@ regulator-state-mem {
 
 			vddio_ddr: VDD_DDR {
 				regulator-name = "VDD_DDR";
-				regulator-min-microvolt = <600000>;
-				regulator-max-microvolt = <1850000>;
+				regulator-min-microvolt = <1200000>;
+				regulator-max-microvolt = <1200000>;
 				regulator-initial-mode = <2>;
 				regulator-allowed-modes = <2>, <4>;
 				regulator-always-on;
@@ -110,8 +110,8 @@ regulator-state-mem {
 
 			vdd_core: VDD_CORE {
 				regulator-name = "VDD_CORE";
-				regulator-min-microvolt = <600000>;
-				regulator-max-microvolt = <1850000>;
+				regulator-min-microvolt = <1250000>;
+				regulator-max-microvolt = <1250000>;
 				regulator-initial-mode = <2>;
 				regulator-allowed-modes = <2>, <4>;
 				regulator-always-on;
@@ -152,8 +152,8 @@ regulator-state-mem {
 
 			LDO1 {
 				regulator-name = "LDO1";
-				regulator-min-microvolt = <1200000>;
-				regulator-max-microvolt = <3700000>;
+				regulator-min-microvolt = <3300000>;
+				regulator-max-microvolt = <3300000>;
 				regulator-always-on;
 
 				regulator-state-standby {
@@ -167,9 +167,8 @@ regulator-state-mem {
 
 			LDO2 {
 				regulator-name = "LDO2";
-				regulator-min-microvolt = <1200000>;
-				regulator-max-microvolt = <3700000>;
-				regulator-always-on;
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <3300000>;
 
 				regulator-state-standby {
 					regulator-on-in-suspend;
diff --git a/arch/arm/boot/dts/at91-sama5d2_icp.dts b/arch/arm/boot/dts/at91-sama5d2_icp.dts
index fd1a288f686b..4ebbbe65c0ce 100644
--- a/arch/arm/boot/dts/at91-sama5d2_icp.dts
+++ b/arch/arm/boot/dts/at91-sama5d2_icp.dts
@@ -197,8 +197,8 @@ mcp16502@5b {
 			regulators {
 				vdd_io_reg: VDD_IO {
 					regulator-name = "VDD_IO";
-					regulator-min-microvolt = <1200000>;
-					regulator-max-microvolt = <3700000>;
+					regulator-min-microvolt = <3300000>;
+					regulator-max-microvolt = <3300000>;
 					regulator-initial-mode = <2>;
 					regulator-allowed-modes = <2>, <4>;
 					regulator-always-on;
@@ -216,8 +216,8 @@ regulator-state-mem {
 
 				VDD_DDR {
 					regulator-name = "VDD_DDR";
-					regulator-min-microvolt = <600000>;
-					regulator-max-microvolt = <1850000>;
+					regulator-min-microvolt = <1350000>;
+					regulator-max-microvolt = <1350000>;
 					regulator-initial-mode = <2>;
 					regulator-allowed-modes = <2>, <4>;
 					regulator-always-on;
@@ -235,8 +235,8 @@ regulator-state-mem {
 
 				VDD_CORE {
 					regulator-name = "VDD_CORE";
-					regulator-min-microvolt = <600000>;
-					regulator-max-microvolt = <1850000>;
+					regulator-min-microvolt = <1250000>;
+					regulator-max-microvolt = <1250000>;
 					regulator-initial-mode = <2>;
 					regulator-allowed-modes = <2>, <4>;
 					regulator-always-on;
@@ -258,7 +258,6 @@ VDD_OTHER {
 					regulator-max-microvolt = <1850000>;
 					regulator-initial-mode = <2>;
 					regulator-allowed-modes = <2>, <4>;
-					regulator-always-on;
 
 					regulator-state-standby {
 						regulator-on-in-suspend;
@@ -273,8 +272,8 @@ regulator-state-mem {
 
 				LDO1 {
 					regulator-name = "LDO1";
-					regulator-min-microvolt = <1200000>;
-					regulator-max-microvolt = <3700000>;
+					regulator-min-microvolt = <2500000>;
+					regulator-max-microvolt = <2500000>;
 					regulator-always-on;
 
 					regulator-state-standby {
@@ -288,8 +287,8 @@ regulator-state-mem {
 
 				LDO2 {
 					regulator-name = "LDO2";
-					regulator-min-microvolt = <1200000>;
-					regulator-max-microvolt = <3700000>;
+					regulator-min-microvolt = <3300000>;
+					regulator-max-microvolt = <3300000>;
 					regulator-always-on;
 
 					regulator-state-standby {
diff --git a/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi b/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
index b167b33bd108..9a3e5f782715 100644
--- a/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
@@ -51,16 +51,6 @@ reg_3p3v_s0: regulator-3p3v-s0 {
 		vin-supply = <&reg_3p3v_s5>;
 	};
 
-	reg_3p3v_s0: regulator-3p3v-s0 {
-		compatible = "regulator-fixed";
-		regulator-name = "V_3V3_S0";
-		regulator-min-microvolt = <3300000>;
-		regulator-max-microvolt = <3300000>;
-		regulator-always-on;
-		regulator-boot-on;
-		vin-supply = <&reg_3p3v_s5>;
-	};
-
 	reg_3p3v_s5: regulator-3p3v-s5 {
 		compatible = "regulator-fixed";
 		regulator-name = "V_3V3_S5";
diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
index ed1050404ef0..c8cc993ca8ca 100644
--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -350,9 +350,41 @@ extern u32 at91_pm_suspend_in_sram_sz;
 
 static int at91_suspend_finish(unsigned long val)
 {
+	unsigned char modified_gray_code[] = {
+		0x00, 0x01, 0x02, 0x03, 0x06, 0x07, 0x04, 0x05, 0x0c, 0x0d,
+		0x0e, 0x0f, 0x0a, 0x0b, 0x08, 0x09, 0x18, 0x19, 0x1a, 0x1b,
+		0x1e, 0x1f, 0x1c, 0x1d, 0x14, 0x15, 0x16, 0x17, 0x12, 0x13,
+		0x10, 0x11,
+	};
+	unsigned int tmp, index;
 	int i;
 
 	if (soc_pm.data.mode == AT91_PM_BACKUP && soc_pm.data.ramc_phy) {
+		/*
+		 * Bootloader will perform DDR recalibration and will try to
+		 * restore the ZQ0SR0 with the value saved here. But the
+		 * calibration is buggy and restoring some values from ZQ0SR0
+		 * is forbidden and risky thus we need to provide processed
+		 * values for these (modified gray code values).
+		 */
+		tmp = readl(soc_pm.data.ramc_phy + DDR3PHY_ZQ0SR0);
+
+		/* Store pull-down output impedance select. */
+		index = (tmp >> DDR3PHY_ZQ0SR0_PDO_OFF) & 0x1f;
+		soc_pm.bu->ddr_phy_calibration[0] = modified_gray_code[index];
+
+		/* Store pull-up output impedance select. */
+		index = (tmp >> DDR3PHY_ZQ0SR0_PUO_OFF) & 0x1f;
+		soc_pm.bu->ddr_phy_calibration[0] |= modified_gray_code[index];
+
+		/* Store pull-down on-die termination impedance select. */
+		index = (tmp >> DDR3PHY_ZQ0SR0_PDODT_OFF) & 0x1f;
+		soc_pm.bu->ddr_phy_calibration[0] |= modified_gray_code[index];
+
+		/* Store pull-up on-die termination impedance select. */
+		index = (tmp >> DDR3PHY_ZQ0SRO_PUODT_OFF) & 0x1f;
+		soc_pm.bu->ddr_phy_calibration[0] |= modified_gray_code[index];
+
 		/*
 		 * The 1st 8 words of memory might get corrupted in the process
 		 * of DDR PHY recalibration; it is saved here in securam and it
@@ -841,10 +873,6 @@ static int __init at91_pm_backup_init(void)
 		of_scan_flat_dt(at91_pm_backup_scan_memcs, &located);
 		if (!located)
 			goto securam_fail;
-
-		/* DDR3PHY_ZQ0SR0 */
-		soc_pm.bu->ddr_phy_calibration[0] = readl(soc_pm.data.ramc_phy +
-							  0x188);
 	}
 
 	return 0;
diff --git a/arch/arm/mach-at91/pm_suspend.S b/arch/arm/mach-at91/pm_suspend.S
index fdb4f63ecde4..65cfcc19a936 100644
--- a/arch/arm/mach-at91/pm_suspend.S
+++ b/arch/arm/mach-at91/pm_suspend.S
@@ -172,9 +172,15 @@ sr_ena_2:
 	/* Put DDR PHY's DLL in bypass mode for non-backup modes. */
 	cmp	r7, #AT91_PM_BACKUP
 	beq	sr_ena_3
-	ldr	tmp1, [r3, #DDR3PHY_PIR]
-	orr	tmp1, tmp1, #DDR3PHY_PIR_DLLBYP
-	str	tmp1, [r3, #DDR3PHY_PIR]
+
+	/* Disable DX DLLs. */
+	ldr	tmp1, [r3, #DDR3PHY_DX0DLLCR]
+	orr	tmp1, tmp1, #DDR3PHY_DXDLLCR_DLLDIS
+	str	tmp1, [r3, #DDR3PHY_DX0DLLCR]
+
+	ldr	tmp1, [r3, #DDR3PHY_DX1DLLCR]
+	orr	tmp1, tmp1, #DDR3PHY_DXDLLCR_DLLDIS
+	str	tmp1, [r3, #DDR3PHY_DX1DLLCR]
 
 sr_ena_3:
 	/* Power down DDR PHY data receivers. */
@@ -221,10 +227,14 @@ sr_ena_3:
 	bic	tmp1, tmp1, #DDR3PHY_DSGCR_ODTPDD_ODT0
 	str	tmp1, [r3, #DDR3PHY_DSGCR]
 
-	/* Take DDR PHY's DLL out of bypass mode. */
-	ldr	tmp1, [r3, #DDR3PHY_PIR]
-	bic	tmp1, tmp1, #DDR3PHY_PIR_DLLBYP
-	str	tmp1, [r3, #DDR3PHY_PIR]
+	/* Enable DX DLLs. */
+	ldr	tmp1, [r3, #DDR3PHY_DX0DLLCR]
+	bic	tmp1, tmp1, #DDR3PHY_DXDLLCR_DLLDIS
+	str	tmp1, [r3, #DDR3PHY_DX0DLLCR]
+
+	ldr	tmp1, [r3, #DDR3PHY_DX1DLLCR]
+	bic	tmp1, tmp1, #DDR3PHY_DXDLLCR_DLLDIS
+	str	tmp1, [r3, #DDR3PHY_DX1DLLCR]
 
 	/* Enable quasi-dynamic programming. */
 	mov	tmp1, #0
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 9d80c783142f..24cce3b9ff1a 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -683,6 +683,23 @@ config ARM64_ERRATUM_2441009
 
 	  If unsure, say Y.
 
+config ARM64_ERRATUM_2457168
+	bool "Cortex-A510: 2457168: workaround for AMEVCNTR01 incrementing incorrectly"
+	depends on ARM64_AMU_EXTN
+	default y
+	help
+	  This option adds the workaround for ARM Cortex-A510 erratum 2457168.
+
+	  The AMU counter AMEVCNTR01 (constant counter) should increment at the same rate
+	  as the system counter. On affected Cortex-A510 cores AMEVCNTR01 increments
+	  incorrectly giving a significantly higher output value.
+
+	  Work around this problem by returning 0 when reading the affected counter in
+	  key locations that results in disabling all users of this counter. This effect
+	  is the same to firmware disabling affected counters.
+
+	  If unsure, say Y.
+
 config CAVIUM_ERRATUM_22375
 	bool "Cavium erratum 22375, 24313"
 	default y
@@ -1626,6 +1643,8 @@ config ARM64_BTI_KERNEL
 	depends on CC_HAS_BRANCH_PROT_PAC_RET_BTI
 	# https://gcc.gnu.org/bugzilla/show_bug.cgi?id=94697
 	depends on !CC_IS_GCC || GCC_VERSION >= 100100
+	# https://gcc.gnu.org/bugzilla/show_bug.cgi?id=106671
+	depends on !CC_IS_GCC
 	# https://github.com/llvm/llvm-project/commit/a88c722e687e6780dcd6a58718350dc76fcc4cc9
 	depends on !CC_IS_CLANG || CLANG_VERSION >= 120000
 	depends on (!FUNCTION_GRAPH_TRACER || DYNAMIC_FTRACE_WITH_REGS)
diff --git a/arch/arm64/kernel/cacheinfo.c b/arch/arm64/kernel/cacheinfo.c
index 587543c6c51c..97c42be71338 100644
--- a/arch/arm64/kernel/cacheinfo.c
+++ b/arch/arm64/kernel/cacheinfo.c
@@ -45,7 +45,8 @@ static void ci_leaf_init(struct cacheinfo *this_leaf,
 
 int init_cache_level(unsigned int cpu)
 {
-	unsigned int ctype, level, leaves, fw_level;
+	unsigned int ctype, level, leaves;
+	int fw_level;
 	struct cpu_cacheinfo *this_cpu_ci = get_cpu_cacheinfo(cpu);
 
 	for (level = 1, leaves = 0; level <= MAX_CACHE_LEVEL; level++) {
@@ -63,6 +64,9 @@ int init_cache_level(unsigned int cpu)
 	else
 		fw_level = acpi_find_last_cache_level(cpu);
 
+	if (fw_level < 0)
+		return fw_level;
+
 	if (level < fw_level) {
 		/*
 		 * some external caches not specified in CLIDR_EL1
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 23c57e0a7fd1..25c495f58f67 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -550,6 +550,15 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		.capability = ARM64_WORKAROUND_NVIDIA_CARMEL_CNP,
 		ERRATA_MIDR_ALL_VERSIONS(MIDR_NVIDIA_CARMEL),
 	},
+#endif
+#ifdef CONFIG_ARM64_ERRATUM_2457168
+	{
+		.desc = "ARM erratum 2457168",
+		.capability = ARM64_WORKAROUND_2457168,
+		.type = ARM64_CPUCAP_WEAK_LOCAL_CPU_FEATURE,
+		/* Cortex-A510 r0p0-r1p1 */
+		CAP_MIDR_RANGE(MIDR_CORTEX_A510, 0, 0, 1, 1)
+	},
 #endif
 	{
 	}
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 474aa55c2f68..3e52a9e8b50b 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1736,7 +1736,10 @@ static void cpu_amu_enable(struct arm64_cpu_capabilities const *cap)
 		pr_info("detected CPU%d: Activity Monitors Unit (AMU)\n",
 			smp_processor_id());
 		cpumask_set_cpu(smp_processor_id(), &amu_cpus);
-		update_freq_counters_refs();
+
+		/* 0 reference values signal broken/disabled counters */
+		if (!this_cpu_has_cap(ARM64_WORKAROUND_2457168))
+			update_freq_counters_refs();
 	}
 }
 
diff --git a/arch/arm64/kernel/hibernate.c b/arch/arm64/kernel/hibernate.c
index db93ce2b0113..46a0b4d6e251 100644
--- a/arch/arm64/kernel/hibernate.c
+++ b/arch/arm64/kernel/hibernate.c
@@ -326,6 +326,11 @@ static void swsusp_mte_restore_tags(void)
 		unsigned long pfn = xa_state.xa_index;
 		struct page *page = pfn_to_online_page(pfn);
 
+		/*
+		 * It is not required to invoke page_kasan_tag_reset(page)
+		 * at this point since the tags stored in page->flags are
+		 * already restored.
+		 */
 		mte_restore_page_tags(page_address(page), tags);
 
 		mte_free_tag_storage(tags);
diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
index 10207e3e5ae2..7c1c82c8115c 100644
--- a/arch/arm64/kernel/mte.c
+++ b/arch/arm64/kernel/mte.c
@@ -44,6 +44,15 @@ static void mte_sync_page_tags(struct page *page, pte_t old_pte,
 	if (!pte_is_tagged)
 		return;
 
+	page_kasan_tag_reset(page);
+	/*
+	 * We need smp_wmb() in between setting the flags and clearing the
+	 * tags because if another thread reads page->flags and builds a
+	 * tagged address out of it, there is an actual dependency to the
+	 * memory access, but on the current thread we do not guarantee that
+	 * the new page->flags are visible before the tags were updated.
+	 */
+	smp_wmb();
 	mte_clear_page_tags(page_address(page));
 }
 
diff --git a/arch/arm64/kernel/topology.c b/arch/arm64/kernel/topology.c
index 4dd14a6620c1..acf67ef4c505 100644
--- a/arch/arm64/kernel/topology.c
+++ b/arch/arm64/kernel/topology.c
@@ -308,12 +308,25 @@ core_initcall(init_amu_fie);
 
 static void cpu_read_corecnt(void *val)
 {
+	/*
+	 * A value of 0 can be returned if the current CPU does not support AMUs
+	 * or if the counter is disabled for this CPU. A return value of 0 at
+	 * counter read is properly handled as an error case by the users of the
+	 * counter.
+	 */
 	*(u64 *)val = read_corecnt();
 }
 
 static void cpu_read_constcnt(void *val)
 {
-	*(u64 *)val = read_constcnt();
+	/*
+	 * Return 0 if the current CPU is affected by erratum 2457168. A value
+	 * of 0 is also returned if the current CPU does not support AMUs or if
+	 * the counter is disabled. A return value of 0 at counter read is
+	 * properly handled as an error case by the users of the counter.
+	 */
+	*(u64 *)val = this_cpu_has_cap(ARM64_WORKAROUND_2457168) ?
+		      0UL : read_constcnt();
 }
 
 static inline
@@ -340,7 +353,22 @@ int counters_read_on_cpu(int cpu, smp_call_func_t func, u64 *val)
  */
 bool cpc_ffh_supported(void)
 {
-	return freq_counters_valid(get_cpu_with_amu_feat());
+	int cpu = get_cpu_with_amu_feat();
+
+	/*
+	 * FFH is considered supported if there is at least one present CPU that
+	 * supports AMUs. Using FFH to read core and reference counters for CPUs
+	 * that do not support AMUs, have counters disabled or that are affected
+	 * by errata, will result in a return value of 0.
+	 *
+	 * This is done to allow any enabled and valid counters to be read
+	 * through FFH, knowing that potentially returning 0 as counter value is
+	 * properly handled by the users of these counters.
+	 */
+	if ((cpu >= nr_cpu_ids) || !cpumask_test_cpu(cpu, cpu_present_mask))
+		return false;
+
+	return true;
 }
 
 int cpc_read_ffh(int cpu, struct cpc_reg *reg, u64 *val)
diff --git a/arch/arm64/mm/copypage.c b/arch/arm64/mm/copypage.c
index 24913271e898..0dea80bf6de4 100644
--- a/arch/arm64/mm/copypage.c
+++ b/arch/arm64/mm/copypage.c
@@ -23,6 +23,15 @@ void copy_highpage(struct page *to, struct page *from)
 
 	if (system_supports_mte() && test_bit(PG_mte_tagged, &from->flags)) {
 		set_bit(PG_mte_tagged, &to->flags);
+		page_kasan_tag_reset(to);
+		/*
+		 * We need smp_wmb() in between setting the flags and clearing the
+		 * tags because if another thread reads page->flags and builds a
+		 * tagged address out of it, there is an actual dependency to the
+		 * memory access, but on the current thread we do not guarantee that
+		 * the new page->flags are visible before the tags were updated.
+		 */
+		smp_wmb();
 		mte_copy_page_tags(kto, kfrom);
 	}
 }
diff --git a/arch/arm64/mm/mteswap.c b/arch/arm64/mm/mteswap.c
index c52c1847079c..7c4ef56265ee 100644
--- a/arch/arm64/mm/mteswap.c
+++ b/arch/arm64/mm/mteswap.c
@@ -53,6 +53,15 @@ bool mte_restore_tags(swp_entry_t entry, struct page *page)
 	if (!tags)
 		return false;
 
+	page_kasan_tag_reset(page);
+	/*
+	 * We need smp_wmb() in between setting the flags and clearing the
+	 * tags because if another thread reads page->flags and builds a
+	 * tagged address out of it, there is an actual dependency to the
+	 * memory access, but on the current thread we do not guarantee that
+	 * the new page->flags are visible before the tags were updated.
+	 */
+	smp_wmb();
 	mte_restore_page_tags(page_address(page), tags);
 
 	return true;
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index b71c6cbb2309..cfaffd3c8289 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -54,6 +54,7 @@ WORKAROUND_1418040
 WORKAROUND_1463225
 WORKAROUND_1508412
 WORKAROUND_1542419
+WORKAROUND_2457168
 WORKAROUND_CAVIUM_23154
 WORKAROUND_CAVIUM_27456
 WORKAROUND_CAVIUM_30115
diff --git a/arch/mips/loongson32/ls1c/board.c b/arch/mips/loongson32/ls1c/board.c
index e9de6da0ce51..9dcfe9de55b0 100644
--- a/arch/mips/loongson32/ls1c/board.c
+++ b/arch/mips/loongson32/ls1c/board.c
@@ -15,7 +15,6 @@ static struct platform_device *ls1c_platform_devices[] __initdata = {
 static int __init ls1c_platform_init(void)
 {
 	ls1x_serial_set_uartclk(&ls1x_uart_pdev);
-	ls1x_rtc_set_extclk(&ls1x_rtc_pdev);
 
 	return platform_add_devices(ls1c_platform_devices,
 				   ARRAY_SIZE(ls1c_platform_devices));
diff --git a/arch/parisc/include/asm/bitops.h b/arch/parisc/include/asm/bitops.h
index 5779d463b341..aa4e883431c1 100644
--- a/arch/parisc/include/asm/bitops.h
+++ b/arch/parisc/include/asm/bitops.h
@@ -12,14 +12,6 @@
 #include <asm/barrier.h>
 #include <linux/atomic.h>
 
-/* compiler build environment sanity checks: */
-#if !defined(CONFIG_64BIT) && defined(__LP64__)
-#error "Please use 'ARCH=parisc' to build the 32-bit kernel."
-#endif
-#if defined(CONFIG_64BIT) && !defined(__LP64__)
-#error "Please use 'ARCH=parisc64' to build the 64-bit kernel."
-#endif
-
 /* See http://marc.theaimsgroup.com/?t=108826637900003 for discussion
  * on use of volatile and __*_bit() (set/clear/change):
  *	*_bit() want use of volatile.
diff --git a/arch/parisc/kernel/head.S b/arch/parisc/kernel/head.S
index aa93d775c34d..598d0938449d 100644
--- a/arch/parisc/kernel/head.S
+++ b/arch/parisc/kernel/head.S
@@ -22,7 +22,7 @@
 #include <linux/init.h>
 #include <linux/pgtable.h>
 
-	.level	PA_ASM_LEVEL
+	.level	1.1
 
 	__INITDATA
 ENTRY(boot_args)
@@ -69,6 +69,47 @@ $bss_loop:
 	stw,ma          %arg2,4(%r1)
 	stw,ma          %arg3,4(%r1)
 
+#if !defined(CONFIG_64BIT) && defined(CONFIG_PA20)
+	/* This 32-bit kernel was compiled for PA2.0 CPUs. Check current CPU
+	 * and halt kernel if we detect a PA1.x CPU. */
+	ldi		32,%r10
+	mtctl		%r10,%cr11
+	.level 2.0
+	mfctl,w		%cr11,%r10
+	.level 1.1
+	comib,<>,n	0,%r10,$cpu_ok
+
+	load32		PA(msg1),%arg0
+	ldi		msg1_end-msg1,%arg1
+$iodc_panic:
+	copy		%arg0, %r10
+	copy		%arg1, %r11
+	load32		PA(init_stack),%sp
+#define MEM_CONS 0x3A0
+	ldw		MEM_CONS+32(%r0),%arg0	// HPA
+	ldi		ENTRY_IO_COUT,%arg1
+	ldw		MEM_CONS+36(%r0),%arg2	// SPA
+	ldw		MEM_CONS+8(%r0),%arg3	// layers
+	load32		PA(__bss_start),%r1
+	stw		%r1,-52(%sp)		// arg4
+	stw		%r0,-56(%sp)		// arg5
+	stw		%r10,-60(%sp)		// arg6 = ptr to text
+	stw		%r11,-64(%sp)		// arg7 = len
+	stw		%r0,-68(%sp)		// arg8
+	load32		PA(.iodc_panic_ret), %rp
+	ldw		MEM_CONS+40(%r0),%r1	// ENTRY_IODC
+	bv,n		(%r1)
+.iodc_panic_ret:
+	b .				/* wait endless with ... */
+	or		%r10,%r10,%r10	/* qemu idle sleep */
+msg1:	.ascii "Can't boot kernel which was built for PA8x00 CPUs on this machine.\r\n"
+msg1_end:
+
+$cpu_ok:
+#endif
+
+	.level	PA_ASM_LEVEL
+
 	/* Initialize startup VM. Just map first 16/32 MB of memory */
 	load32		PA(swapper_pg_dir),%r4
 	mtctl		%r4,%cr24	/* Initialize kernel root pointer */
diff --git a/arch/s390/kernel/nmi.c b/arch/s390/kernel/nmi.c
index a50f2ff1b00e..383b4799b6dd 100644
--- a/arch/s390/kernel/nmi.c
+++ b/arch/s390/kernel/nmi.c
@@ -62,7 +62,7 @@ static inline unsigned long nmi_get_mcesa_size(void)
  * The structure is required for machine check happening early in
  * the boot process.
  */
-static struct mcesa boot_mcesa __initdata __aligned(MCESA_MAX_SIZE);
+static struct mcesa boot_mcesa __aligned(MCESA_MAX_SIZE);
 
 void __init nmi_alloc_boot_cpu(struct lowcore *lc)
 {
diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index 6b1a8697fae8..4dfe37b06889 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -484,6 +484,7 @@ static void __init setup_lowcore_dat_off(void)
 	put_abs_lowcore(restart_data, lc->restart_data);
 	put_abs_lowcore(restart_source, lc->restart_source);
 	put_abs_lowcore(restart_psw, lc->restart_psw);
+	put_abs_lowcore(mcesad, lc->mcesad);
 
 	lc->spinlock_lockval = arch_spin_lockval(0);
 	lc->spinlock_index = 0;
diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index cddf7e13c232..799431d287ee 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -532,7 +532,7 @@ static unsigned int __resolve_freq(struct cpufreq_policy *policy,
 
 	target_freq = clamp_val(target_freq, policy->min, policy->max);
 
-	if (!cpufreq_driver->target_index)
+	if (!policy->freq_table)
 		return target_freq;
 
 	idx = cpufreq_frequency_table_target(policy, target_freq, relation);
diff --git a/drivers/firmware/efi/capsule-loader.c b/drivers/firmware/efi/capsule-loader.c
index 4dde8edd53b6..3e8d4b51a814 100644
--- a/drivers/firmware/efi/capsule-loader.c
+++ b/drivers/firmware/efi/capsule-loader.c
@@ -242,29 +242,6 @@ static ssize_t efi_capsule_write(struct file *file, const char __user *buff,
 	return ret;
 }
 
-/**
- * efi_capsule_flush - called by file close or file flush
- * @file: file pointer
- * @id: not used
- *
- *	If a capsule is being partially uploaded then calling this function
- *	will be treated as upload termination and will free those completed
- *	buffer pages and -ECANCELED will be returned.
- **/
-static int efi_capsule_flush(struct file *file, fl_owner_t id)
-{
-	int ret = 0;
-	struct capsule_info *cap_info = file->private_data;
-
-	if (cap_info->index > 0) {
-		pr_err("capsule upload not complete\n");
-		efi_free_all_buff_pages(cap_info);
-		ret = -ECANCELED;
-	}
-
-	return ret;
-}
-
 /**
  * efi_capsule_release - called by file close
  * @inode: not used
@@ -277,6 +254,13 @@ static int efi_capsule_release(struct inode *inode, struct file *file)
 {
 	struct capsule_info *cap_info = file->private_data;
 
+	if (cap_info->index > 0 &&
+	    (cap_info->header.headersize == 0 ||
+	     cap_info->count < cap_info->total_size)) {
+		pr_err("capsule upload not complete\n");
+		efi_free_all_buff_pages(cap_info);
+	}
+
 	kfree(cap_info->pages);
 	kfree(cap_info->phys);
 	kfree(file->private_data);
@@ -324,7 +308,6 @@ static const struct file_operations efi_capsule_fops = {
 	.owner = THIS_MODULE,
 	.open = efi_capsule_open,
 	.write = efi_capsule_write,
-	.flush = efi_capsule_flush,
 	.release = efi_capsule_release,
 	.llseek = no_llseek,
 };
diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index d0537573501e..2c67f71f2375 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -37,6 +37,13 @@ KBUILD_CFLAGS			:= $(cflags-y) -Os -DDISABLE_BRANCH_PROFILING \
 				   $(call cc-option,-fno-addrsig) \
 				   -D__DISABLE_EXPORTS
 
+#
+# struct randomization only makes sense for Linux internal types, which the EFI
+# stub code never touches, so let's turn off struct randomization for the stub
+# altogether
+#
+KBUILD_CFLAGS := $(filter-out $(RANDSTRUCT_CFLAGS), $(KBUILD_CFLAGS))
+
 # remove SCS flags from all objects in this directory
 KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_SCS), $(KBUILD_CFLAGS))
 # disable LTO
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
index 57e9932d8a04..5b41c29f3ed5 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -2729,6 +2729,9 @@ static int psp_hw_fini(void *handle)
 		psp_rap_terminate(psp);
 		psp_dtm_terminate(psp);
 		psp_hdcp_terminate(psp);
+
+		if (adev->gmc.xgmi.num_physical_nodes > 1)
+			psp_xgmi_terminate(psp);
 	}
 
 	psp_asd_unload(psp);
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c
index a799e0b1ff73..ce0b9cb61f58 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c
@@ -723,7 +723,7 @@ int amdgpu_xgmi_remove_device(struct amdgpu_device *adev)
 		amdgpu_put_xgmi_hive(hive);
 	}
 
-	return psp_xgmi_terminate(&adev->psp);
+	return 0;
 }
 
 static int amdgpu_xgmi_ras_late_init(struct amdgpu_device *adev)
diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
index db27fcf87cd0..16cbae04078a 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -2624,7 +2624,8 @@ static void gfx_v9_0_constants_init(struct amdgpu_device *adev)
 
 	gfx_v9_0_tiling_mode_table_init(adev);
 
-	gfx_v9_0_setup_rb(adev);
+	if (adev->gfx.num_gfx_rings)
+		gfx_v9_0_setup_rb(adev);
 	gfx_v9_0_get_cu_info(adev, &adev->gfx.cu_info);
 	adev->gfx.config.db_debug2 = RREG32_SOC15(GC, 0, mmDB_DEBUG2);
 
diff --git a/drivers/gpu/drm/amd/amdgpu/mmhub_v1_0.c b/drivers/gpu/drm/amd/amdgpu/mmhub_v1_0.c
index b3bede1dc41d..4259f623a9d7 100644
--- a/drivers/gpu/drm/amd/amdgpu/mmhub_v1_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mmhub_v1_0.c
@@ -176,6 +176,7 @@ static void mmhub_v1_0_init_cache_regs(struct amdgpu_device *adev)
 	tmp = REG_SET_FIELD(tmp, VM_L2_CNTL2, INVALIDATE_L2_CACHE, 1);
 	WREG32_SOC15(MMHUB, 0, mmVM_L2_CNTL2, tmp);
 
+	tmp = mmVM_L2_CNTL3_DEFAULT;
 	if (adev->gmc.translate_further) {
 		tmp = REG_SET_FIELD(tmp, VM_L2_CNTL3, BANK_SELECT, 12);
 		tmp = REG_SET_FIELD(tmp, VM_L2_CNTL3,
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
index 5c9f5214bc4e..6d694cea2420 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
@@ -3007,7 +3007,7 @@ void crtc_debugfs_init(struct drm_crtc *crtc)
 				   &crc_win_y_end_fops);
 	debugfs_create_file_unsafe("crc_win_update", 0644, dir, crtc,
 				   &crc_win_update_fops);
-
+	dput(dir);
 }
 #endif
 /*
diff --git a/drivers/gpu/drm/bridge/display-connector.c b/drivers/gpu/drm/bridge/display-connector.c
index 847a0dce7f1d..d24f5b90feab 100644
--- a/drivers/gpu/drm/bridge/display-connector.c
+++ b/drivers/gpu/drm/bridge/display-connector.c
@@ -13,6 +13,7 @@
 #include <linux/platform_device.h>
 #include <linux/regulator/consumer.h>
 
+#include <drm/drm_atomic_helper.h>
 #include <drm/drm_bridge.h>
 #include <drm/drm_edid.h>
 
@@ -87,10 +88,95 @@ static struct edid *display_connector_get_edid(struct drm_bridge *bridge,
 	return drm_get_edid(connector, conn->bridge.ddc);
 }
 
+/*
+ * Since this bridge is tied to the connector, it acts like a passthrough,
+ * so concerning the output bus formats, either pass the bus formats from the
+ * previous bridge or return fallback data like done in the bridge function:
+ * drm_atomic_bridge_chain_select_bus_fmts().
+ * This supports negotiation if the bridge chain has all bits in place.
+ */
+static u32 *display_connector_get_output_bus_fmts(struct drm_bridge *bridge,
+					struct drm_bridge_state *bridge_state,
+					struct drm_crtc_state *crtc_state,
+					struct drm_connector_state *conn_state,
+					unsigned int *num_output_fmts)
+{
+	struct drm_bridge *prev_bridge = drm_bridge_get_prev_bridge(bridge);
+	struct drm_bridge_state *prev_bridge_state;
+
+	if (!prev_bridge || !prev_bridge->funcs->atomic_get_output_bus_fmts) {
+		struct drm_connector *conn = conn_state->connector;
+		u32 *out_bus_fmts;
+
+		*num_output_fmts = 1;
+		out_bus_fmts = kmalloc(sizeof(*out_bus_fmts), GFP_KERNEL);
+		if (!out_bus_fmts)
+			return NULL;
+
+		if (conn->display_info.num_bus_formats &&
+		    conn->display_info.bus_formats)
+			out_bus_fmts[0] = conn->display_info.bus_formats[0];
+		else
+			out_bus_fmts[0] = MEDIA_BUS_FMT_FIXED;
+
+		return out_bus_fmts;
+	}
+
+	prev_bridge_state = drm_atomic_get_new_bridge_state(crtc_state->state,
+							    prev_bridge);
+
+	return prev_bridge->funcs->atomic_get_output_bus_fmts(prev_bridge, prev_bridge_state,
+							      crtc_state, conn_state,
+							      num_output_fmts);
+}
+
+/*
+ * Since this bridge is tied to the connector, it acts like a passthrough,
+ * so concerning the input bus formats, either pass the bus formats from the
+ * previous bridge or MEDIA_BUS_FMT_FIXED (like select_bus_fmt_recursive())
+ * when atomic_get_input_bus_fmts is not supported.
+ * This supports negotiation if the bridge chain has all bits in place.
+ */
+static u32 *display_connector_get_input_bus_fmts(struct drm_bridge *bridge,
+					struct drm_bridge_state *bridge_state,
+					struct drm_crtc_state *crtc_state,
+					struct drm_connector_state *conn_state,
+					u32 output_fmt,
+					unsigned int *num_input_fmts)
+{
+	struct drm_bridge *prev_bridge = drm_bridge_get_prev_bridge(bridge);
+	struct drm_bridge_state *prev_bridge_state;
+
+	if (!prev_bridge || !prev_bridge->funcs->atomic_get_input_bus_fmts) {
+		u32 *in_bus_fmts;
+
+		*num_input_fmts = 1;
+		in_bus_fmts = kmalloc(sizeof(*in_bus_fmts), GFP_KERNEL);
+		if (!in_bus_fmts)
+			return NULL;
+
+		in_bus_fmts[0] = MEDIA_BUS_FMT_FIXED;
+
+		return in_bus_fmts;
+	}
+
+	prev_bridge_state = drm_atomic_get_new_bridge_state(crtc_state->state,
+							    prev_bridge);
+
+	return prev_bridge->funcs->atomic_get_input_bus_fmts(prev_bridge, prev_bridge_state,
+							     crtc_state, conn_state, output_fmt,
+							     num_input_fmts);
+}
+
 static const struct drm_bridge_funcs display_connector_bridge_funcs = {
 	.attach = display_connector_attach,
 	.detect = display_connector_detect,
 	.get_edid = display_connector_get_edid,
+	.atomic_get_output_bus_fmts = display_connector_get_output_bus_fmts,
+	.atomic_get_input_bus_fmts = display_connector_get_input_bus_fmts,
+	.atomic_duplicate_state = drm_atomic_helper_bridge_duplicate_state,
+	.atomic_destroy_state = drm_atomic_helper_bridge_destroy_state,
+	.atomic_reset = drm_atomic_helper_bridge_reset,
 };
 
 static irqreturn_t display_connector_hpd_irq(int irq, void *arg)
diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
index 6410563a9cb6..dbd19a34b517 100644
--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -167,21 +167,6 @@ void drm_gem_private_object_init(struct drm_device *dev,
 }
 EXPORT_SYMBOL(drm_gem_private_object_init);
 
-static void
-drm_gem_remove_prime_handles(struct drm_gem_object *obj, struct drm_file *filp)
-{
-	/*
-	 * Note: obj->dma_buf can't disappear as long as we still hold a
-	 * handle reference in obj->handle_count.
-	 */
-	mutex_lock(&filp->prime.lock);
-	if (obj->dma_buf) {
-		drm_prime_remove_buf_handle_locked(&filp->prime,
-						   obj->dma_buf);
-	}
-	mutex_unlock(&filp->prime.lock);
-}
-
 /**
  * drm_gem_object_handle_free - release resources bound to userspace handles
  * @obj: GEM object to clean up.
@@ -252,7 +237,7 @@ drm_gem_object_release_handle(int id, void *ptr, void *data)
 	if (obj->funcs->close)
 		obj->funcs->close(obj, file_priv);
 
-	drm_gem_remove_prime_handles(obj, file_priv);
+	drm_prime_remove_buf_handle(&file_priv->prime, id);
 	drm_vma_node_revoke(&obj->vma_node, file_priv);
 
 	drm_gem_object_handle_put_unlocked(obj);
diff --git a/drivers/gpu/drm/drm_internal.h b/drivers/gpu/drm/drm_internal.h
index 17f3548c8ed2..d05e6a5b6687 100644
--- a/drivers/gpu/drm/drm_internal.h
+++ b/drivers/gpu/drm/drm_internal.h
@@ -74,8 +74,8 @@ int drm_prime_fd_to_handle_ioctl(struct drm_device *dev, void *data,
 
 void drm_prime_init_file_private(struct drm_prime_file_private *prime_fpriv);
 void drm_prime_destroy_file_private(struct drm_prime_file_private *prime_fpriv);
-void drm_prime_remove_buf_handle_locked(struct drm_prime_file_private *prime_fpriv,
-					struct dma_buf *dma_buf);
+void drm_prime_remove_buf_handle(struct drm_prime_file_private *prime_fpriv,
+				 uint32_t handle);
 
 /* drm_drv.c */
 struct drm_minor *drm_minor_acquire(unsigned int minor_id);
diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_prime.c
index d6c7f4f9a7a2..a350310b65d8 100644
--- a/drivers/gpu/drm/drm_prime.c
+++ b/drivers/gpu/drm/drm_prime.c
@@ -187,29 +187,33 @@ static int drm_prime_lookup_buf_handle(struct drm_prime_file_private *prime_fpri
 	return -ENOENT;
 }
 
-void drm_prime_remove_buf_handle_locked(struct drm_prime_file_private *prime_fpriv,
-					struct dma_buf *dma_buf)
+void drm_prime_remove_buf_handle(struct drm_prime_file_private *prime_fpriv,
+				 uint32_t handle)
 {
 	struct rb_node *rb;
 
-	rb = prime_fpriv->dmabufs.rb_node;
+	mutex_lock(&prime_fpriv->lock);
+
+	rb = prime_fpriv->handles.rb_node;
 	while (rb) {
 		struct drm_prime_member *member;
 
-		member = rb_entry(rb, struct drm_prime_member, dmabuf_rb);
-		if (member->dma_buf == dma_buf) {
+		member = rb_entry(rb, struct drm_prime_member, handle_rb);
+		if (member->handle == handle) {
 			rb_erase(&member->handle_rb, &prime_fpriv->handles);
 			rb_erase(&member->dmabuf_rb, &prime_fpriv->dmabufs);
 
-			dma_buf_put(dma_buf);
+			dma_buf_put(member->dma_buf);
 			kfree(member);
-			return;
-		} else if (member->dma_buf < dma_buf) {
+			break;
+		} else if (member->handle < handle) {
 			rb = rb->rb_right;
 		} else {
 			rb = rb->rb_left;
 		}
 	}
+
+	mutex_unlock(&prime_fpriv->lock);
 }
 
 void drm_prime_init_file_private(struct drm_prime_file_private *prime_fpriv)
diff --git a/drivers/gpu/drm/i915/display/intel_dp_link_training.c b/drivers/gpu/drm/i915/display/intel_dp_link_training.c
index 508a514c5e37..d77d91c0a03a 100644
--- a/drivers/gpu/drm/i915/display/intel_dp_link_training.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_link_training.c
@@ -475,6 +475,28 @@ intel_dp_prepare_link_train(struct intel_dp *intel_dp,
 	intel_dp_compute_rate(intel_dp, crtc_state->port_clock,
 			      &link_bw, &rate_select);
 
+	/*
+	 * WaEdpLinkRateDataReload
+	 *
+	 * Parade PS8461E MUX (used on varius TGL+ laptops) needs
+	 * to snoop the link rates reported by the sink when we
+	 * use LINK_RATE_SET in order to operate in jitter cleaning
+	 * mode (as opposed to redriver mode). Unfortunately it
+	 * loses track of the snooped link rates when powered down,
+	 * so we need to make it re-snoop often. Without this high
+	 * link rates are not stable.
+	 */
+	if (!link_bw) {
+		struct intel_connector *connector = intel_dp->attached_connector;
+		__le16 sink_rates[DP_MAX_SUPPORTED_RATES];
+
+		drm_dbg_kms(&i915->drm, "[CONNECTOR:%d:%s] Reloading eDP link rates\n",
+			    connector->base.base.id, connector->base.name);
+
+		drm_dp_dpcd_read(&intel_dp->aux, DP_SUPPORTED_LINK_RATES,
+				 sink_rates, sizeof(sink_rates));
+	}
+
 	if (link_bw)
 		drm_dbg_kms(&i915->drm,
 			    "Using LINK_BW_SET value %02x\n", link_bw);
diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index 4f0fbf667431..92905ebb7b45 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -1617,6 +1617,9 @@ int radeon_suspend_kms(struct drm_device *dev, bool suspend,
 		if (r) {
 			/* delay GPU reset to resume */
 			radeon_fence_driver_force_completion(rdev, i);
+		} else {
+			/* finish executing delayed work */
+			flush_delayed_work(&rdev->fence_drv[i].lockup_work);
 		}
 	}
 
diff --git a/drivers/hwmon/mr75203.c b/drivers/hwmon/mr75203.c
index 1ba1e3145969..05da83841536 100644
--- a/drivers/hwmon/mr75203.c
+++ b/drivers/hwmon/mr75203.c
@@ -68,8 +68,9 @@
 
 /* VM Individual Macro Register */
 #define VM_COM_REG_SIZE	0x200
-#define VM_SDIF_DONE(n)	(VM_COM_REG_SIZE + 0x34 + 0x200 * (n))
-#define VM_SDIF_DATA(n)	(VM_COM_REG_SIZE + 0x40 + 0x200 * (n))
+#define VM_SDIF_DONE(vm)	(VM_COM_REG_SIZE + 0x34 + 0x200 * (vm))
+#define VM_SDIF_DATA(vm, ch)	\
+	(VM_COM_REG_SIZE + 0x40 + 0x200 * (vm) + 0x4 * (ch))
 
 /* SDA Slave Register */
 #define IP_CTRL			0x00
@@ -115,6 +116,7 @@ struct pvt_device {
 	u32			t_num;
 	u32			p_num;
 	u32			v_num;
+	u32			c_num;
 	u32			ip_freq;
 	u8			*vm_idx;
 };
@@ -178,14 +180,15 @@ static int pvt_read_in(struct device *dev, u32 attr, int channel, long *val)
 {
 	struct pvt_device *pvt = dev_get_drvdata(dev);
 	struct regmap *v_map = pvt->v_map;
+	u8 vm_idx, ch_idx;
 	u32 n, stat;
-	u8 vm_idx;
 	int ret;
 
-	if (channel >= pvt->v_num)
+	if (channel >= pvt->v_num * pvt->c_num)
 		return -EINVAL;
 
-	vm_idx = pvt->vm_idx[channel];
+	vm_idx = pvt->vm_idx[channel / pvt->c_num];
+	ch_idx = channel % pvt->c_num;
 
 	switch (attr) {
 	case hwmon_in_input:
@@ -196,13 +199,23 @@ static int pvt_read_in(struct device *dev, u32 attr, int channel, long *val)
 		if (ret)
 			return ret;
 
-		ret = regmap_read(v_map, VM_SDIF_DATA(vm_idx), &n);
+		ret = regmap_read(v_map, VM_SDIF_DATA(vm_idx, ch_idx), &n);
 		if(ret < 0)
 			return ret;
 
 		n &= SAMPLE_DATA_MSK;
-		/* Convert the N bitstream count into voltage */
-		*val = (PVT_N_CONST * n - PVT_R_CONST) >> PVT_CONV_BITS;
+		/*
+		 * Convert the N bitstream count into voltage.
+		 * To support negative voltage calculation for 64bit machines
+		 * n must be cast to long, since n and *val differ both in
+		 * signedness and in size.
+		 * Division is used instead of right shift, because for signed
+		 * numbers, the sign bit is used to fill the vacated bit
+		 * positions, and if the number is negative, 1 is used.
+		 * BIT(x) may not be used instead of (1 << x) because it's
+		 * unsigned.
+		 */
+		*val = (PVT_N_CONST * (long)n - PVT_R_CONST) / (1 << PVT_CONV_BITS);
 
 		return 0;
 	default:
@@ -385,6 +398,19 @@ static int pvt_init(struct pvt_device *pvt)
 		if (ret)
 			return ret;
 
+		val = (BIT(pvt->c_num) - 1) | VM_CH_INIT |
+		      IP_POLL << SDIF_ADDR_SFT | SDIF_WRN_W | SDIF_PROG;
+		ret = regmap_write(v_map, SDIF_W, val);
+		if (ret < 0)
+			return ret;
+
+		ret = regmap_read_poll_timeout(v_map, SDIF_STAT,
+					       val, !(val & SDIF_BUSY),
+					       PVT_POLL_DELAY_US,
+					       PVT_POLL_TIMEOUT_US);
+		if (ret)
+			return ret;
+
 		val = CFG1_VOL_MEAS_MODE | CFG1_PARALLEL_OUT |
 		      CFG1_14_BIT | IP_CFG << SDIF_ADDR_SFT |
 		      SDIF_WRN_W | SDIF_PROG;
@@ -499,8 +525,8 @@ static int pvt_reset_control_deassert(struct device *dev, struct pvt_device *pvt
 
 static int mr75203_probe(struct platform_device *pdev)
 {
+	u32 ts_num, vm_num, pd_num, ch_num, val, index, i;
 	const struct hwmon_channel_info **pvt_info;
-	u32 ts_num, vm_num, pd_num, val, index, i;
 	struct device *dev = &pdev->dev;
 	u32 *temp_config, *in_config;
 	struct device *hwmon_dev;
@@ -541,9 +567,11 @@ static int mr75203_probe(struct platform_device *pdev)
 	ts_num = (val & TS_NUM_MSK) >> TS_NUM_SFT;
 	pd_num = (val & PD_NUM_MSK) >> PD_NUM_SFT;
 	vm_num = (val & VM_NUM_MSK) >> VM_NUM_SFT;
+	ch_num = (val & CH_NUM_MSK) >> CH_NUM_SFT;
 	pvt->t_num = ts_num;
 	pvt->p_num = pd_num;
 	pvt->v_num = vm_num;
+	pvt->c_num = ch_num;
 	val = 0;
 	if (ts_num)
 		val++;
@@ -580,7 +608,7 @@ static int mr75203_probe(struct platform_device *pdev)
 	}
 
 	if (vm_num) {
-		u32 num = vm_num;
+		u32 total_ch;
 
 		ret = pvt_get_regmap(pdev, "vm", pvt);
 		if (ret)
@@ -594,30 +622,30 @@ static int mr75203_probe(struct platform_device *pdev)
 		ret = device_property_read_u8_array(dev, "intel,vm-map",
 						    pvt->vm_idx, vm_num);
 		if (ret) {
-			num = 0;
+			/*
+			 * Incase intel,vm-map property is not defined, we
+			 * assume incremental channel numbers.
+			 */
+			for (i = 0; i < vm_num; i++)
+				pvt->vm_idx[i] = i;
 		} else {
 			for (i = 0; i < vm_num; i++)
 				if (pvt->vm_idx[i] >= vm_num ||
 				    pvt->vm_idx[i] == 0xff) {
-					num = i;
+					pvt->v_num = i;
+					vm_num = i;
 					break;
 				}
 		}
 
-		/*
-		 * Incase intel,vm-map property is not defined, we assume
-		 * incremental channel numbers.
-		 */
-		for (i = num; i < vm_num; i++)
-			pvt->vm_idx[i] = i;
-
-		in_config = devm_kcalloc(dev, num + 1,
+		total_ch = ch_num * vm_num;
+		in_config = devm_kcalloc(dev, total_ch + 1,
 					 sizeof(*in_config), GFP_KERNEL);
 		if (!in_config)
 			return -ENOMEM;
 
-		memset32(in_config, HWMON_I_INPUT, num);
-		in_config[num] = 0;
+		memset32(in_config, HWMON_I_INPUT, total_ch);
+		in_config[total_ch] = 0;
 		pvt_in.config = in_config;
 
 		pvt_info[index++] = &pvt_in;
diff --git a/drivers/hwmon/tps23861.c b/drivers/hwmon/tps23861.c
index 8bd6435c13e8..2148fd543bb4 100644
--- a/drivers/hwmon/tps23861.c
+++ b/drivers/hwmon/tps23861.c
@@ -489,18 +489,20 @@ static char *tps23861_port_poe_plus_status(struct tps23861_data *data, int port)
 
 static int tps23861_port_resistance(struct tps23861_data *data, int port)
 {
-	u16 regval;
+	unsigned int raw_val;
+	__le16 regval;
 
 	regmap_bulk_read(data->regmap,
 			 PORT_1_RESISTANCE_LSB + PORT_N_RESISTANCE_LSB_OFFSET * (port - 1),
 			 &regval,
 			 2);
 
-	switch (FIELD_GET(PORT_RESISTANCE_RSN_MASK, regval)) {
+	raw_val = le16_to_cpu(regval);
+	switch (FIELD_GET(PORT_RESISTANCE_RSN_MASK, raw_val)) {
 	case PORT_RESISTANCE_RSN_OTHER:
-		return (FIELD_GET(PORT_RESISTANCE_MASK, regval) * RESISTANCE_LSB) / 10000;
+		return (FIELD_GET(PORT_RESISTANCE_MASK, raw_val) * RESISTANCE_LSB) / 10000;
 	case PORT_RESISTANCE_RSN_LOW:
-		return (FIELD_GET(PORT_RESISTANCE_MASK, regval) * RESISTANCE_LSB_LOW) / 10000;
+		return (FIELD_GET(PORT_RESISTANCE_MASK, raw_val) * RESISTANCE_LSB_LOW) / 10000;
 	case PORT_RESISTANCE_RSN_SHORT:
 	case PORT_RESISTANCE_RSN_OPEN:
 	default:
diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index a814dabcdff4..0da66dd40d6a 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1718,8 +1718,8 @@ cma_ib_id_from_event(struct ib_cm_id *cm_id,
 		}
 
 		if (!validate_net_dev(*net_dev,
-				 (struct sockaddr *)&req->listen_addr_storage,
-				 (struct sockaddr *)&req->src_addr_storage)) {
+				 (struct sockaddr *)&req->src_addr_storage,
+				 (struct sockaddr *)&req->listen_addr_storage)) {
 			id_priv = ERR_PTR(-EHOSTUNREACH);
 			goto err;
 		}
diff --git a/drivers/infiniband/core/umem_odp.c b/drivers/infiniband/core/umem_odp.c
index 7a47343d11f9..b052de1b9ccb 100644
--- a/drivers/infiniband/core/umem_odp.c
+++ b/drivers/infiniband/core/umem_odp.c
@@ -463,7 +463,7 @@ int ib_umem_odp_map_dma_and_lock(struct ib_umem_odp *umem_odp, u64 user_virt,
 		mutex_unlock(&umem_odp->umem_mutex);
 
 out_put_mm:
-	mmput(owning_mm);
+	mmput_async(owning_mm);
 out_put_task:
 	if (owning_process)
 		put_task_struct(owning_process);
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
index df4501e77fd1..d3d5b5f57052 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
@@ -98,7 +98,7 @@
 
 #define HNS_ROCE_V2_QPC_TIMER_ENTRY_SZ		PAGE_SIZE
 #define HNS_ROCE_V2_CQC_TIMER_ENTRY_SZ		PAGE_SIZE
-#define HNS_ROCE_V2_PAGE_SIZE_SUPPORTED		0xFFFFF000
+#define HNS_ROCE_V2_PAGE_SIZE_SUPPORTED		0xFFFF000
 #define HNS_ROCE_V2_MAX_INNER_MTPT_NUM		2
 #define HNS_ROCE_INVALID_LKEY			0x0
 #define HNS_ROCE_INVALID_SGE_LENGTH		0x80000000
diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
index 9af4509894e6..5d50d2d1deca 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -495,11 +495,8 @@ static int set_rq_size(struct hns_roce_dev *hr_dev, struct ib_qp_cap *cap,
 	hr_qp->rq.max_gs = roundup_pow_of_two(max(1U, cap->max_recv_sge) +
 					      hr_qp->rq.rsv_sge);
 
-	if (hr_dev->caps.max_rq_sg <= HNS_ROCE_SGE_IN_WQE)
-		hr_qp->rq.wqe_shift = ilog2(hr_dev->caps.max_rq_desc_sz);
-	else
-		hr_qp->rq.wqe_shift = ilog2(hr_dev->caps.max_rq_desc_sz *
-					    hr_qp->rq.max_gs);
+	hr_qp->rq.wqe_shift = ilog2(hr_dev->caps.max_rq_desc_sz *
+				    hr_qp->rq.max_gs);
 
 	hr_qp->rq.wqe_cnt = cnt;
 	if (hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_RQ_INLINE &&
diff --git a/drivers/infiniband/hw/irdma/uk.c b/drivers/infiniband/hw/irdma/uk.c
index 9b544a3b1288..7e6c3ba8df6a 100644
--- a/drivers/infiniband/hw/irdma/uk.c
+++ b/drivers/infiniband/hw/irdma/uk.c
@@ -1068,6 +1068,7 @@ irdma_uk_cq_poll_cmpl(struct irdma_cq_uk *cq, struct irdma_cq_poll_info *info)
 	enum irdma_status_code ret_code;
 	bool move_cq_head = true;
 	u8 polarity;
+	u8 op_type;
 	bool ext_valid;
 	__le64 *ext_cqe;
 
@@ -1250,7 +1251,6 @@ irdma_uk_cq_poll_cmpl(struct irdma_cq_uk *cq, struct irdma_cq_poll_info *info)
 			do {
 				__le64 *sw_wqe;
 				u64 wqe_qword;
-				u8 op_type;
 				u32 tail;
 
 				tail = qp->sq_ring.tail;
@@ -1267,6 +1267,8 @@ irdma_uk_cq_poll_cmpl(struct irdma_cq_uk *cq, struct irdma_cq_poll_info *info)
 					break;
 				}
 			} while (1);
+			if (op_type == IRDMA_OP_TYPE_BIND_MW && info->minor_err == FLUSH_PROT_ERR)
+				info->minor_err = FLUSH_MW_BIND_ERR;
 			qp->sq_flush_seen = true;
 			if (!IRDMA_RING_MORE_WORK(qp->sq_ring))
 				qp->sq_flush_complete = true;
diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index cac4fb228b9b..5275616398d8 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -36,15 +36,18 @@ static int irdma_query_device(struct ib_device *ibdev,
 	props->max_send_sge = hw_attrs->uk_attrs.max_hw_wq_frags;
 	props->max_recv_sge = hw_attrs->uk_attrs.max_hw_wq_frags;
 	props->max_cq = rf->max_cq - rf->used_cqs;
-	props->max_cqe = rf->max_cqe;
+	props->max_cqe = rf->max_cqe - 1;
 	props->max_mr = rf->max_mr - rf->used_mrs;
 	props->max_mw = props->max_mr;
 	props->max_pd = rf->max_pd - rf->used_pds;
 	props->max_sge_rd = hw_attrs->uk_attrs.max_hw_read_sges;
 	props->max_qp_rd_atom = hw_attrs->max_hw_ird;
 	props->max_qp_init_rd_atom = hw_attrs->max_hw_ord;
-	if (rdma_protocol_roce(ibdev, 1))
+	if (rdma_protocol_roce(ibdev, 1)) {
+		props->device_cap_flags |= IB_DEVICE_RC_RNR_NAK_GEN;
 		props->max_pkeys = IRDMA_PKEY_TBL_SZ;
+	}
+
 	props->max_ah = rf->max_ah;
 	props->max_mcast_grp = rf->max_mcg;
 	props->max_mcast_qp_attach = IRDMA_MAX_MGS_PER_CTX;
diff --git a/drivers/infiniband/hw/mlx5/mad.c b/drivers/infiniband/hw/mlx5/mad.c
index ec242a5a17a3..f6f2df855c2e 100644
--- a/drivers/infiniband/hw/mlx5/mad.c
+++ b/drivers/infiniband/hw/mlx5/mad.c
@@ -166,6 +166,12 @@ static int process_pma_cmd(struct mlx5_ib_dev *dev, u32 port_num,
 		mdev = dev->mdev;
 		mdev_port_num = 1;
 	}
+	if (MLX5_CAP_GEN(dev->mdev, num_ports) == 1) {
+		/* set local port to one for Function-Per-Port HCA. */
+		mdev = dev->mdev;
+		mdev_port_num = 1;
+	}
+
 	/* Declaring support of extended counters */
 	if (in_mad->mad_hdr.attr_id == IB_PMA_CLASS_PORT_INFO) {
 		struct ib_class_port_info cpi = {};
diff --git a/drivers/infiniband/sw/siw/siw_qp_tx.c b/drivers/infiniband/sw/siw/siw_qp_tx.c
index 1f4e60257700..7d47b521070b 100644
--- a/drivers/infiniband/sw/siw/siw_qp_tx.c
+++ b/drivers/infiniband/sw/siw/siw_qp_tx.c
@@ -29,7 +29,7 @@ static struct page *siw_get_pblpage(struct siw_mem *mem, u64 addr, int *idx)
 	dma_addr_t paddr = siw_pbl_get_buffer(pbl, offset, NULL, idx);
 
 	if (paddr)
-		return virt_to_page(paddr);
+		return virt_to_page((void *)paddr);
 
 	return NULL;
 }
@@ -533,13 +533,23 @@ static int siw_tx_hdt(struct siw_iwarp_tx *c_tx, struct socket *s)
 					kunmap_local(kaddr);
 				}
 			} else {
-				u64 va = sge->laddr + sge_off;
+				/*
+				 * Cast to an uintptr_t to preserve all 64 bits
+				 * in sge->laddr.
+				 */
+				uintptr_t va = (uintptr_t)(sge->laddr + sge_off);
 
-				page_array[seg] = virt_to_page(va & PAGE_MASK);
+				/*
+				 * virt_to_page() takes a (void *) pointer
+				 * so cast to a (void *) meaning it will be 64
+				 * bits on a 64 bit platform and 32 bits on a
+				 * 32 bit platform.
+				 */
+				page_array[seg] = virt_to_page((void *)(va & PAGE_MASK));
 				if (do_crc)
 					crypto_shash_update(
 						c_tx->mpa_crc_hd,
-						(void *)(uintptr_t)va,
+						(void *)va,
 						plen);
 			}
 
diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
index 9edbb309b96c..c644617725a8 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -1011,7 +1011,8 @@ rtrs_clt_get_copy_req(struct rtrs_clt_path *alive_path,
 static int rtrs_post_rdma_write_sg(struct rtrs_clt_con *con,
 				   struct rtrs_clt_io_req *req,
 				   struct rtrs_rbuf *rbuf, bool fr_en,
-				   u32 size, u32 imm, struct ib_send_wr *wr,
+				   u32 count, u32 size, u32 imm,
+				   struct ib_send_wr *wr,
 				   struct ib_send_wr *tail)
 {
 	struct rtrs_clt_path *clt_path = to_clt_path(con->c.path);
@@ -1031,12 +1032,12 @@ static int rtrs_post_rdma_write_sg(struct rtrs_clt_con *con,
 		num_sge = 2;
 		ptail = tail;
 	} else {
-		for_each_sg(req->sglist, sg, req->sg_cnt, i) {
+		for_each_sg(req->sglist, sg, count, i) {
 			sge[i].addr   = sg_dma_address(sg);
 			sge[i].length = sg_dma_len(sg);
 			sge[i].lkey   = clt_path->s.dev->ib_pd->local_dma_lkey;
 		}
-		num_sge = 1 + req->sg_cnt;
+		num_sge = 1 + count;
 	}
 	sge[i].addr   = req->iu->dma_addr;
 	sge[i].length = size;
@@ -1149,7 +1150,7 @@ static int rtrs_clt_write_req(struct rtrs_clt_io_req *req)
 	 */
 	rtrs_clt_update_all_stats(req, WRITE);
 
-	ret = rtrs_post_rdma_write_sg(req->con, req, rbuf, fr_en,
+	ret = rtrs_post_rdma_write_sg(req->con, req, rbuf, fr_en, count,
 				      req->usr_len + sizeof(*msg),
 				      imm, wr, &inv_wr);
 	if (ret) {
diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv.c b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
index 1ca31b919e98..733116554e0b 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -600,7 +600,7 @@ static int map_cont_bufs(struct rtrs_srv_path *srv_path)
 		struct sg_table *sgt = &srv_mr->sgt;
 		struct scatterlist *s;
 		struct ib_mr *mr;
-		int nr, chunks;
+		int nr, nr_sgt, chunks;
 
 		chunks = chunks_per_mr * mri;
 		if (!always_invalidate)
@@ -615,19 +615,19 @@ static int map_cont_bufs(struct rtrs_srv_path *srv_path)
 			sg_set_page(s, srv->chunks[chunks + i],
 				    max_chunk_size, 0);
 
-		nr = ib_dma_map_sg(srv_path->s.dev->ib_dev, sgt->sgl,
+		nr_sgt = ib_dma_map_sg(srv_path->s.dev->ib_dev, sgt->sgl,
 				   sgt->nents, DMA_BIDIRECTIONAL);
-		if (nr < sgt->nents) {
-			err = nr < 0 ? nr : -EINVAL;
+		if (!nr_sgt) {
+			err = -EINVAL;
 			goto free_sg;
 		}
 		mr = ib_alloc_mr(srv_path->s.dev->ib_pd, IB_MR_TYPE_MEM_REG,
-				 sgt->nents);
+				 nr_sgt);
 		if (IS_ERR(mr)) {
 			err = PTR_ERR(mr);
 			goto unmap_sg;
 		}
-		nr = ib_map_mr_sg(mr, sgt->sgl, sgt->nents,
+		nr = ib_map_mr_sg(mr, sgt->sgl, nr_sgt,
 				  NULL, max_chunk_size);
 		if (nr < 0 || nr < sgt->nents) {
 			err = nr < 0 ? nr : -EINVAL;
@@ -646,7 +646,7 @@ static int map_cont_bufs(struct rtrs_srv_path *srv_path)
 			}
 		}
 		/* Eventually dma addr for each chunk can be cached */
-		for_each_sg(sgt->sgl, s, sgt->orig_nents, i)
+		for_each_sg(sgt->sgl, s, nr_sgt, i)
 			srv_path->dma_addr[chunks + i] = sg_dma_address(s);
 
 		ib_update_fast_reg_key(mr, ib_inc_rkey(mr->rkey));
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 5d416ec22871..473b3a08cf96 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1955,7 +1955,8 @@ static void srp_process_rsp(struct srp_rdma_ch *ch, struct srp_rsp *rsp)
 		if (scmnd) {
 			req = scsi_cmd_priv(scmnd);
 			scmnd = srp_claim_req(ch, req, NULL, scmnd);
-		} else {
+		}
+		if (!scmnd) {
 			shost_printk(KERN_ERR, target->scsi_host,
 				     "Null scmnd for RSP w/tag %#016llx received on ch %td / QP %#x\n",
 				     rsp->tag, ch - target->ch, ch->qp->qp_num);
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index e23e70af718f..7154fb551ddc 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -852,7 +852,8 @@ static void build_completion_wait(struct iommu_cmd *cmd,
 	memset(cmd, 0, sizeof(*cmd));
 	cmd->data[0] = lower_32_bits(paddr) | CMD_COMPL_WAIT_STORE_MASK;
 	cmd->data[1] = upper_32_bits(paddr);
-	cmd->data[2] = data;
+	cmd->data[2] = lower_32_bits(data);
+	cmd->data[3] = upper_32_bits(data);
 	CMD_SET_TYPE(cmd, CMD_COMPL_WAIT);
 }
 
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index a1ffb3d6d901..bc5444daca9b 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -542,14 +542,36 @@ static inline int domain_pfn_supported(struct dmar_domain *domain,
 	return !(addr_width < BITS_PER_LONG && pfn >> addr_width);
 }
 
+/*
+ * Calculate the Supported Adjusted Guest Address Widths of an IOMMU.
+ * Refer to 11.4.2 of the VT-d spec for the encoding of each bit of
+ * the returned SAGAW.
+ */
+static unsigned long __iommu_calculate_sagaw(struct intel_iommu *iommu)
+{
+	unsigned long fl_sagaw, sl_sagaw;
+
+	fl_sagaw = BIT(2) | (cap_fl1gp_support(iommu->cap) ? BIT(3) : 0);
+	sl_sagaw = cap_sagaw(iommu->cap);
+
+	/* Second level only. */
+	if (!sm_supported(iommu) || !ecap_flts(iommu->ecap))
+		return sl_sagaw;
+
+	/* First level only. */
+	if (!ecap_slts(iommu->ecap))
+		return fl_sagaw;
+
+	return fl_sagaw & sl_sagaw;
+}
+
 static int __iommu_calculate_agaw(struct intel_iommu *iommu, int max_gaw)
 {
 	unsigned long sagaw;
 	int agaw;
 
-	sagaw = cap_sagaw(iommu->cap);
-	for (agaw = width_to_agaw(max_gaw);
-	     agaw >= 0; agaw--) {
+	sagaw = __iommu_calculate_sagaw(iommu);
+	for (agaw = width_to_agaw(max_gaw); agaw >= 0; agaw--) {
 		if (test_bit(agaw, &sagaw))
 			break;
 	}
diff --git a/drivers/md/md.c b/drivers/md/md.c
index c8f2e8524bfb..04e1e294b4b1 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5651,6 +5651,7 @@ static int md_alloc(dev_t dev, char *name)
 	 * removed (mddev_delayed_delete).
 	 */
 	flush_workqueue(md_misc_wq);
+	flush_workqueue(md_rdev_misc_wq);
 
 	mutex_lock(&disks_mutex);
 	mddev = mddev_alloc(dev);
diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index 210f09118ede..0f19c237cb58 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -1286,4 +1286,18 @@ int i40e_add_del_cloud_filter(struct i40e_vsi *vsi,
 int i40e_add_del_cloud_filter_big_buf(struct i40e_vsi *vsi,
 				      struct i40e_cloud_filter *filter,
 				      bool add);
+
+/**
+ * i40e_is_tc_mqprio_enabled - check if TC MQPRIO is enabled on PF
+ * @pf: pointer to a pf.
+ *
+ * Check and return value of flag I40E_FLAG_TC_MQPRIO.
+ *
+ * Return: I40E_FLAG_TC_MQPRIO set state.
+ **/
+static inline u32 i40e_is_tc_mqprio_enabled(struct i40e_pf *pf)
+{
+	return pf->flags & I40E_FLAG_TC_MQPRIO;
+}
+
 #endif /* _I40E_H_ */
diff --git a/drivers/net/ethernet/intel/i40e/i40e_client.c b/drivers/net/ethernet/intel/i40e/i40e_client.c
index ea2bb0140a6e..10d7a982a5b9 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_client.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_client.c
@@ -177,6 +177,10 @@ void i40e_notify_client_of_netdev_close(struct i40e_vsi *vsi, bool reset)
 			"Cannot locate client instance close routine\n");
 		return;
 	}
+	if (!test_bit(__I40E_CLIENT_INSTANCE_OPENED, &cdev->state)) {
+		dev_dbg(&pf->pdev->dev, "Client is not open, abort close\n");
+		return;
+	}
 	cdev->client->ops->close(&cdev->lan_info, cdev->client, reset);
 	clear_bit(__I40E_CLIENT_INSTANCE_OPENED, &cdev->state);
 	i40e_client_release_qvlist(&cdev->lan_info);
@@ -429,7 +433,6 @@ void i40e_client_subtask(struct i40e_pf *pf)
 				/* Remove failed client instance */
 				clear_bit(__I40E_CLIENT_INSTANCE_OPENED,
 					  &cdev->state);
-				i40e_client_del_instance(pf);
 				return;
 			}
 		}
diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index 669ae53f4c72..8e770c5e181e 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -4921,7 +4921,7 @@ static int i40e_set_channels(struct net_device *dev,
 	/* We do not support setting channels via ethtool when TCs are
 	 * configured through mqprio
 	 */
-	if (pf->flags & I40E_FLAG_TC_MQPRIO)
+	if (i40e_is_tc_mqprio_enabled(pf))
 		return -EINVAL;
 
 	/* verify they are not requesting separate vectors */
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 536f9198bd47..ce6eea7a6002 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -5320,7 +5320,7 @@ static u8 i40e_pf_get_num_tc(struct i40e_pf *pf)
 	u8 num_tc = 0;
 	struct i40e_dcbx_config *dcbcfg = &hw->local_dcbx_config;
 
-	if (pf->flags & I40E_FLAG_TC_MQPRIO)
+	if (i40e_is_tc_mqprio_enabled(pf))
 		return pf->vsi[pf->lan_vsi]->mqprio_qopt.qopt.num_tc;
 
 	/* If neither MQPRIO nor DCB is enabled, then always use single TC */
@@ -5352,7 +5352,7 @@ static u8 i40e_pf_get_num_tc(struct i40e_pf *pf)
  **/
 static u8 i40e_pf_get_tc_map(struct i40e_pf *pf)
 {
-	if (pf->flags & I40E_FLAG_TC_MQPRIO)
+	if (i40e_is_tc_mqprio_enabled(pf))
 		return i40e_mqprio_get_enabled_tc(pf);
 
 	/* If neither MQPRIO nor DCB is enabled for this PF then just return
@@ -5449,7 +5449,7 @@ static int i40e_vsi_configure_bw_alloc(struct i40e_vsi *vsi, u8 enabled_tc,
 	int i;
 
 	/* There is no need to reset BW when mqprio mode is on.  */
-	if (pf->flags & I40E_FLAG_TC_MQPRIO)
+	if (i40e_is_tc_mqprio_enabled(pf))
 		return 0;
 	if (!vsi->mqprio_qopt.qopt.hw && !(pf->flags & I40E_FLAG_DCB_ENABLED)) {
 		ret = i40e_set_bw_limit(vsi, vsi->seid, 0);
@@ -5521,7 +5521,7 @@ static void i40e_vsi_config_netdev_tc(struct i40e_vsi *vsi, u8 enabled_tc)
 					vsi->tc_config.tc_info[i].qoffset);
 	}
 
-	if (pf->flags & I40E_FLAG_TC_MQPRIO)
+	if (i40e_is_tc_mqprio_enabled(pf))
 		return;
 
 	/* Assign UP2TC map for the VSI */
@@ -5682,7 +5682,7 @@ static int i40e_vsi_config_tc(struct i40e_vsi *vsi, u8 enabled_tc)
 	ctxt.vf_num = 0;
 	ctxt.uplink_seid = vsi->uplink_seid;
 	ctxt.info = vsi->info;
-	if (vsi->back->flags & I40E_FLAG_TC_MQPRIO) {
+	if (i40e_is_tc_mqprio_enabled(pf)) {
 		ret = i40e_vsi_setup_queue_map_mqprio(vsi, &ctxt, enabled_tc);
 		if (ret)
 			goto out;
@@ -6406,7 +6406,7 @@ int i40e_create_queue_channel(struct i40e_vsi *vsi,
 		pf->flags |= I40E_FLAG_VEB_MODE_ENABLED;
 
 		if (vsi->type == I40E_VSI_MAIN) {
-			if (pf->flags & I40E_FLAG_TC_MQPRIO)
+			if (i40e_is_tc_mqprio_enabled(pf))
 				i40e_do_reset(pf, I40E_PF_RESET_FLAG, true);
 			else
 				i40e_do_reset_safe(pf, I40E_PF_RESET_FLAG);
@@ -6517,6 +6517,9 @@ static int i40e_configure_queue_channels(struct i40e_vsi *vsi)
 			vsi->tc_seid_map[i] = ch->seid;
 		}
 	}
+
+	/* reset to reconfigure TX queue contexts */
+	i40e_do_reset(vsi->back, I40E_PF_RESET_FLAG, true);
 	return ret;
 
 err_free:
@@ -7800,7 +7803,7 @@ static void *i40e_fwd_add(struct net_device *netdev, struct net_device *vdev)
 		netdev_info(netdev, "Macvlans are not supported when DCB is enabled\n");
 		return ERR_PTR(-EINVAL);
 	}
-	if ((pf->flags & I40E_FLAG_TC_MQPRIO)) {
+	if (i40e_is_tc_mqprio_enabled(pf)) {
 		netdev_info(netdev, "Macvlans are not supported when HW TC offload is on\n");
 		return ERR_PTR(-EINVAL);
 	}
@@ -8053,7 +8056,7 @@ static int i40e_setup_tc(struct net_device *netdev, void *type_data)
 	/* Quiesce VSI queues */
 	i40e_quiesce_vsi(vsi);
 
-	if (!hw && !(pf->flags & I40E_FLAG_TC_MQPRIO))
+	if (!hw && !i40e_is_tc_mqprio_enabled(pf))
 		i40e_remove_queue_channels(vsi);
 
 	/* Configure VSI for enabled TCs */
@@ -8077,7 +8080,7 @@ static int i40e_setup_tc(struct net_device *netdev, void *type_data)
 		 "Setup channel (id:%u) utilizing num_queues %d\n",
 		 vsi->seid, vsi->tc_config.tc_info[0].qcount);
 
-	if (pf->flags & I40E_FLAG_TC_MQPRIO) {
+	if (i40e_is_tc_mqprio_enabled(pf)) {
 		if (vsi->mqprio_qopt.max_rate[0]) {
 			u64 max_tx_rate = vsi->mqprio_qopt.max_rate[0];
 
@@ -10731,7 +10734,7 @@ static void i40e_rebuild(struct i40e_pf *pf, bool reinit, bool lock_acquired)
 	 * unless I40E_FLAG_TC_MQPRIO was enabled or DCB
 	 * is not supported with new link speed
 	 */
-	if (pf->flags & I40E_FLAG_TC_MQPRIO) {
+	if (i40e_is_tc_mqprio_enabled(pf)) {
 		i40e_aq_set_dcb_parameters(hw, false, NULL);
 	} else {
 		if (I40E_IS_X710TL_DEVICE(hw->device_id) &&
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index d3a4a33977ee..326fd25d055f 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -3651,7 +3651,8 @@ u16 i40e_lan_select_queue(struct net_device *netdev,
 	u8 prio;
 
 	/* is DCB enabled at all? */
-	if (vsi->tc_config.numtc == 1)
+	if (vsi->tc_config.numtc == 1 ||
+	    i40e_is_tc_mqprio_enabled(vsi->back))
 		return netdev_pick_tx(netdev, skb, sb_dev);
 
 	prio = skb->priority;
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index db95786c3419..00b2ef01f4ea 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -2222,6 +2222,11 @@ static void iavf_reset_task(struct work_struct *work)
 	int i = 0, err;
 	bool running;
 
+	/* Detach interface to avoid subsequent NDO callbacks */
+	rtnl_lock();
+	netif_device_detach(netdev);
+	rtnl_unlock();
+
 	/* When device is being removed it doesn't make sense to run the reset
 	 * task, just return in such a case.
 	 */
@@ -2229,7 +2234,7 @@ static void iavf_reset_task(struct work_struct *work)
 		if (adapter->state != __IAVF_REMOVE)
 			queue_work(iavf_wq, &adapter->reset_task);
 
-		return;
+		goto reset_finish;
 	}
 
 	while (!mutex_trylock(&adapter->client_lock))
@@ -2299,7 +2304,6 @@ static void iavf_reset_task(struct work_struct *work)
 
 	if (running) {
 		netif_carrier_off(netdev);
-		netif_tx_stop_all_queues(netdev);
 		adapter->link_up = false;
 		iavf_napi_disable_all(adapter);
 	}
@@ -2412,7 +2416,7 @@ static void iavf_reset_task(struct work_struct *work)
 	mutex_unlock(&adapter->client_lock);
 	mutex_unlock(&adapter->crit_lock);
 
-	return;
+	goto reset_finish;
 reset_err:
 	if (running) {
 		set_bit(__IAVF_VSI_DOWN, adapter->vsi.state);
@@ -2423,6 +2427,10 @@ static void iavf_reset_task(struct work_struct *work)
 	mutex_unlock(&adapter->client_lock);
 	mutex_unlock(&adapter->crit_lock);
 	dev_err(&adapter->pdev->dev, "failed to allocate resources during reinit\n");
+reset_finish:
+	rtnl_lock();
+	netif_device_attach(netdev);
+	rtnl_unlock();
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index b9d45c7dbef1..63ae4674d200 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3549,7 +3549,7 @@ static int ice_init_pf(struct ice_pf *pf)
 
 	pf->avail_rxqs = bitmap_zalloc(pf->max_pf_rxqs, GFP_KERNEL);
 	if (!pf->avail_rxqs) {
-		devm_kfree(ice_pf_to_dev(pf), pf->avail_txqs);
+		bitmap_free(pf->avail_txqs);
 		pf->avail_txqs = NULL;
 		return -ENOMEM;
 	}
diff --git a/drivers/net/phy/meson-gxl.c b/drivers/net/phy/meson-gxl.c
index 73f7962a37d3..c49062ad72c6 100644
--- a/drivers/net/phy/meson-gxl.c
+++ b/drivers/net/phy/meson-gxl.c
@@ -243,13 +243,7 @@ static irqreturn_t meson_gxl_handle_interrupt(struct phy_device *phydev)
 	    irq_status == INTSRC_ENERGY_DETECT)
 		return IRQ_HANDLED;
 
-	/* Give PHY some time before MAC starts sending data. This works
-	 * around an issue where network doesn't come up properly.
-	 */
-	if (!(irq_status & INTSRC_LINK_DOWN))
-		phy_queue_state_machine(phydev, msecs_to_jiffies(100));
-	else
-		phy_trigger_machine(phydev);
+	phy_trigger_machine(phydev);
 
 	return IRQ_HANDLED;
 }
diff --git a/drivers/net/wireless/intel/iwlegacy/4965-rs.c b/drivers/net/wireless/intel/iwlegacy/4965-rs.c
index 532e3b91777d..150805aec407 100644
--- a/drivers/net/wireless/intel/iwlegacy/4965-rs.c
+++ b/drivers/net/wireless/intel/iwlegacy/4965-rs.c
@@ -2403,7 +2403,7 @@ il4965_rs_fill_link_cmd(struct il_priv *il, struct il_lq_sta *lq_sta,
 		/* Repeat initial/next rate.
 		 * For legacy IL_NUMBER_TRY == 1, this loop will not execute.
 		 * For HT IL_HT_NUMBER_TRY == 3, this executes twice. */
-		while (repeat_rate > 0) {
+		while (repeat_rate > 0 && idx < (LINK_QUAL_MAX_RETRY_NUM - 1)) {
 			if (is_legacy(tbl_type.lq_type)) {
 				if (ant_toggle_cnt < NUM_TRY_BEFORE_ANT_TOGGLE)
 					ant_toggle_cnt++;
@@ -2422,8 +2422,6 @@ il4965_rs_fill_link_cmd(struct il_priv *il, struct il_lq_sta *lq_sta,
 			    cpu_to_le32(new_rate);
 			repeat_rate--;
 			idx++;
-			if (idx >= LINK_QUAL_MAX_RETRY_NUM)
-				goto out;
 		}
 
 		il4965_rs_get_tbl_info_from_mcs(new_rate, lq_sta->band,
@@ -2468,7 +2466,6 @@ il4965_rs_fill_link_cmd(struct il_priv *il, struct il_lq_sta *lq_sta,
 		repeat_rate--;
 	}
 
-out:
 	lq_cmd->agg_params.agg_frame_cnt_limit = LINK_QUAL_AGG_FRAME_LIMIT_DEF;
 	lq_cmd->agg_params.agg_dis_start_th = LINK_QUAL_AGG_DISABLE_START_DEF;
 
diff --git a/drivers/net/wireless/microchip/wilc1000/netdev.h b/drivers/net/wireless/microchip/wilc1000/netdev.h
index 86209b391a3d..e6e23fc585ee 100644
--- a/drivers/net/wireless/microchip/wilc1000/netdev.h
+++ b/drivers/net/wireless/microchip/wilc1000/netdev.h
@@ -252,6 +252,7 @@ struct wilc {
 	u8 *rx_buffer;
 	u32 rx_buffer_offset;
 	u8 *tx_buffer;
+	u32 *vmm_table;
 
 	struct txq_handle txq[NQUEUES];
 	int txq_entries;
diff --git a/drivers/net/wireless/microchip/wilc1000/sdio.c b/drivers/net/wireless/microchip/wilc1000/sdio.c
index 8b3b73523108..6c0727fc4abd 100644
--- a/drivers/net/wireless/microchip/wilc1000/sdio.c
+++ b/drivers/net/wireless/microchip/wilc1000/sdio.c
@@ -27,6 +27,7 @@ struct wilc_sdio {
 	bool irq_gpio;
 	u32 block_size;
 	int has_thrpt_enh3;
+	u8 *cmd53_buf;
 };
 
 struct sdio_cmd52 {
@@ -46,6 +47,7 @@ struct sdio_cmd53 {
 	u32 count:		9;
 	u8 *buffer;
 	u32 block_size;
+	bool use_global_buf;
 };
 
 static const struct wilc_hif_func wilc_hif_sdio;
@@ -90,6 +92,8 @@ static int wilc_sdio_cmd53(struct wilc *wilc, struct sdio_cmd53 *cmd)
 {
 	struct sdio_func *func = container_of(wilc->dev, struct sdio_func, dev);
 	int size, ret;
+	struct wilc_sdio *sdio_priv = wilc->bus_data;
+	u8 *buf = cmd->buffer;
 
 	sdio_claim_host(func);
 
@@ -100,12 +104,23 @@ static int wilc_sdio_cmd53(struct wilc *wilc, struct sdio_cmd53 *cmd)
 	else
 		size = cmd->count;
 
+	if (cmd->use_global_buf) {
+		if (size > sizeof(u32))
+			return -EINVAL;
+
+		buf = sdio_priv->cmd53_buf;
+	}
+
 	if (cmd->read_write) {  /* write */
-		ret = sdio_memcpy_toio(func, cmd->address,
-				       (void *)cmd->buffer, size);
+		if (cmd->use_global_buf)
+			memcpy(buf, cmd->buffer, size);
+
+		ret = sdio_memcpy_toio(func, cmd->address, buf, size);
 	} else {        /* read */
-		ret = sdio_memcpy_fromio(func, (void *)cmd->buffer,
-					 cmd->address,  size);
+		ret = sdio_memcpy_fromio(func, buf, cmd->address, size);
+
+		if (cmd->use_global_buf)
+			memcpy(cmd->buffer, buf, size);
 	}
 
 	sdio_release_host(func);
@@ -127,6 +142,12 @@ static int wilc_sdio_probe(struct sdio_func *func,
 	if (!sdio_priv)
 		return -ENOMEM;
 
+	sdio_priv->cmd53_buf = kzalloc(sizeof(u32), GFP_KERNEL);
+	if (!sdio_priv->cmd53_buf) {
+		ret = -ENOMEM;
+		goto free;
+	}
+
 	ret = wilc_cfg80211_init(&wilc, &func->dev, WILC_HIF_SDIO,
 				 &wilc_hif_sdio);
 	if (ret)
@@ -160,6 +181,7 @@ static int wilc_sdio_probe(struct sdio_func *func,
 	irq_dispose_mapping(wilc->dev_irq_num);
 	wilc_netdev_cleanup(wilc);
 free:
+	kfree(sdio_priv->cmd53_buf);
 	kfree(sdio_priv);
 	return ret;
 }
@@ -171,6 +193,7 @@ static void wilc_sdio_remove(struct sdio_func *func)
 
 	clk_disable_unprepare(wilc->rtc_clk);
 	wilc_netdev_cleanup(wilc);
+	kfree(sdio_priv->cmd53_buf);
 	kfree(sdio_priv);
 }
 
@@ -367,8 +390,9 @@ static int wilc_sdio_write_reg(struct wilc *wilc, u32 addr, u32 data)
 		cmd.address = WILC_SDIO_FBR_DATA_REG;
 		cmd.block_mode = 0;
 		cmd.increment = 1;
-		cmd.count = 4;
+		cmd.count = sizeof(u32);
 		cmd.buffer = (u8 *)&data;
+		cmd.use_global_buf = true;
 		cmd.block_size = sdio_priv->block_size;
 		ret = wilc_sdio_cmd53(wilc, &cmd);
 		if (ret)
@@ -406,6 +430,7 @@ static int wilc_sdio_write(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
 	nblk = size / block_size;
 	nleft = size % block_size;
 
+	cmd.use_global_buf = false;
 	if (nblk > 0) {
 		cmd.block_mode = 1;
 		cmd.increment = 1;
@@ -484,8 +509,9 @@ static int wilc_sdio_read_reg(struct wilc *wilc, u32 addr, u32 *data)
 		cmd.address = WILC_SDIO_FBR_DATA_REG;
 		cmd.block_mode = 0;
 		cmd.increment = 1;
-		cmd.count = 4;
+		cmd.count = sizeof(u32);
 		cmd.buffer = (u8 *)data;
+		cmd.use_global_buf = true;
 
 		cmd.block_size = sdio_priv->block_size;
 		ret = wilc_sdio_cmd53(wilc, &cmd);
@@ -527,6 +553,7 @@ static int wilc_sdio_read(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
 	nblk = size / block_size;
 	nleft = size % block_size;
 
+	cmd.use_global_buf = false;
 	if (nblk > 0) {
 		cmd.block_mode = 1;
 		cmd.increment = 1;
diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index 200a103a0a85..380699983a75 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -701,7 +701,7 @@ int wilc_wlan_handle_txq(struct wilc *wilc, u32 *txq_count)
 	int ret = 0;
 	int counter;
 	int timeout;
-	u32 vmm_table[WILC_VMM_TBL_SIZE];
+	u32 *vmm_table = wilc->vmm_table;
 	u8 ac_pkt_num_to_chip[NQUEUES] = {0, 0, 0, 0};
 	const struct wilc_hif_func *func;
 	int srcu_idx;
@@ -1220,6 +1220,8 @@ void wilc_wlan_cleanup(struct net_device *dev)
 	while ((rqe = wilc_wlan_rxq_remove(wilc)))
 		kfree(rqe);
 
+	kfree(wilc->vmm_table);
+	wilc->vmm_table = NULL;
 	kfree(wilc->rx_buffer);
 	wilc->rx_buffer = NULL;
 	kfree(wilc->tx_buffer);
@@ -1455,6 +1457,14 @@ int wilc_wlan_init(struct net_device *dev)
 		goto fail;
 	}
 
+	if (!wilc->vmm_table)
+		wilc->vmm_table = kzalloc(WILC_VMM_TBL_SIZE, GFP_KERNEL);
+
+	if (!wilc->vmm_table) {
+		ret = -ENOBUFS;
+		goto fail;
+	}
+
 	if (!wilc->tx_buffer)
 		wilc->tx_buffer = kmalloc(WILC_TX_BUFF_SIZE, GFP_KERNEL);
 
@@ -1479,7 +1489,8 @@ int wilc_wlan_init(struct net_device *dev)
 	return 0;
 
 fail:
-
+	kfree(wilc->vmm_table);
+	wilc->vmm_table = NULL;
 	kfree(wilc->rx_buffer);
 	wilc->rx_buffer = NULL;
 	kfree(wilc->tx_buffer);
diff --git a/drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c b/drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c
index c6b032f95d2e..4627847c6daa 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c
@@ -372,8 +372,6 @@ bool ipc_protocol_dl_td_prepare(struct iosm_protocol *ipc_protocol,
 struct sk_buff *ipc_protocol_dl_td_process(struct iosm_protocol *ipc_protocol,
 					   struct ipc_pipe *pipe)
 {
-	u32 tail =
-		le32_to_cpu(ipc_protocol->p_ap_shm->tail_array[pipe->pipe_nr]);
 	struct ipc_protocol_td *p_td;
 	struct sk_buff *skb;
 
@@ -403,14 +401,6 @@ struct sk_buff *ipc_protocol_dl_td_process(struct iosm_protocol *ipc_protocol,
 		goto ret;
 	}
 
-	if (!IPC_CB(skb)) {
-		dev_err(ipc_protocol->dev, "pipe# %d, tail: %d skb_cb is NULL",
-			pipe->pipe_nr, tail);
-		ipc_pcie_kfree_skb(ipc_protocol->pcie, skb);
-		skb = NULL;
-		goto ret;
-	}
-
 	if (p_td->buffer.address != IPC_CB(skb)->mapping) {
 		dev_err(ipc_protocol->dev, "invalid buf=%llx or skb=%p",
 			(unsigned long long)p_td->buffer.address, skb->data);
diff --git a/drivers/net/xen-netback/xenbus.c b/drivers/net/xen-netback/xenbus.c
index 990360d75cb6..e85b3c5d4acc 100644
--- a/drivers/net/xen-netback/xenbus.c
+++ b/drivers/net/xen-netback/xenbus.c
@@ -256,7 +256,6 @@ static void backend_disconnect(struct backend_info *be)
 		unsigned int queue_index;
 
 		xen_unregister_watchers(vif);
-		xenbus_rm(XBT_NIL, be->dev->nodename, "hotplug-status");
 #ifdef CONFIG_DEBUG_FS
 		xenvif_debugfs_delif(vif);
 #endif /* CONFIG_DEBUG_FS */
@@ -984,6 +983,7 @@ static int netback_remove(struct xenbus_device *dev)
 	struct backend_info *be = dev_get_drvdata(&dev->dev);
 
 	unregister_hotplug_status_watch(be);
+	xenbus_rm(XBT_NIL, dev->nodename, "hotplug-status");
 	if (be->vif) {
 		kobject_uevent(&dev->dev.kobj, KOBJ_OFFLINE);
 		backend_disconnect(be);
diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 20138e132558..96d8d7844e84 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -119,7 +119,6 @@ struct nvme_tcp_queue {
 	struct mutex		send_mutex;
 	struct llist_head	req_list;
 	struct list_head	send_list;
-	bool			more_requests;
 
 	/* recv state */
 	void			*pdu;
@@ -315,7 +314,7 @@ static inline void nvme_tcp_send_all(struct nvme_tcp_queue *queue)
 static inline bool nvme_tcp_queue_more(struct nvme_tcp_queue *queue)
 {
 	return !list_empty(&queue->send_list) ||
-		!llist_empty(&queue->req_list) || queue->more_requests;
+		!llist_empty(&queue->req_list);
 }
 
 static inline void nvme_tcp_queue_request(struct nvme_tcp_request *req,
@@ -334,9 +333,7 @@ static inline void nvme_tcp_queue_request(struct nvme_tcp_request *req,
 	 */
 	if (queue->io_cpu == raw_smp_processor_id() &&
 	    sync && empty && mutex_trylock(&queue->send_mutex)) {
-		queue->more_requests = !last;
 		nvme_tcp_send_all(queue);
-		queue->more_requests = false;
 		mutex_unlock(&queue->send_mutex);
 	}
 
@@ -1209,7 +1206,7 @@ static void nvme_tcp_io_work(struct work_struct *w)
 		else if (unlikely(result < 0))
 			return;
 
-		if (!pending)
+		if (!pending || !queue->rd_enabled)
 			return;
 
 	} while (!time_after(jiffies, deadline)); /* quota is exhausted */
diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index a8dafe8670f2..0a0c1d956c73 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -736,6 +736,8 @@ static void nvmet_set_error(struct nvmet_req *req, u16 status)
 
 static void __nvmet_req_complete(struct nvmet_req *req, u16 status)
 {
+	struct nvmet_ns *ns = req->ns;
+
 	if (!req->sq->sqhd_disabled)
 		nvmet_update_sq_head(req);
 	req->cqe->sq_id = cpu_to_le16(req->sq->qid);
@@ -746,9 +748,9 @@ static void __nvmet_req_complete(struct nvmet_req *req, u16 status)
 
 	trace_nvmet_req_complete(req);
 
-	if (req->ns)
-		nvmet_put_namespace(req->ns);
 	req->ops->queue_response(req);
+	if (ns)
+		nvmet_put_namespace(ns);
 }
 
 void nvmet_req_complete(struct nvmet_req *req, u16 status)
diff --git a/drivers/nvme/target/zns.c b/drivers/nvme/target/zns.c
index 235553337fb2..1466698751c5 100644
--- a/drivers/nvme/target/zns.c
+++ b/drivers/nvme/target/zns.c
@@ -100,6 +100,7 @@ void nvmet_execute_identify_cns_cs_ns(struct nvmet_req *req)
 	struct nvme_id_ns_zns *id_zns;
 	u64 zsze;
 	u16 status;
+	u32 mar, mor;
 
 	if (le32_to_cpu(req->cmd->identify.nsid) == NVME_NSID_ALL) {
 		req->error_loc = offsetof(struct nvme_identify, nsid);
@@ -126,8 +127,20 @@ void nvmet_execute_identify_cns_cs_ns(struct nvmet_req *req)
 	zsze = (bdev_zone_sectors(req->ns->bdev) << 9) >>
 					req->ns->blksize_shift;
 	id_zns->lbafe[0].zsze = cpu_to_le64(zsze);
-	id_zns->mor = cpu_to_le32(bdev_max_open_zones(req->ns->bdev));
-	id_zns->mar = cpu_to_le32(bdev_max_active_zones(req->ns->bdev));
+
+	mor = bdev_max_open_zones(req->ns->bdev);
+	if (!mor)
+		mor = U32_MAX;
+	else
+		mor--;
+	id_zns->mor = cpu_to_le32(mor);
+
+	mar = bdev_max_active_zones(req->ns->bdev);
+	if (!mar)
+		mar = U32_MAX;
+	else
+		mar--;
+	id_zns->mar = cpu_to_le32(mar);
 
 done:
 	status = nvmet_copy_to_sgl(req, 0, id_zns, sizeof(*id_zns));
diff --git a/drivers/parisc/ccio-dma.c b/drivers/parisc/ccio-dma.c
index 9be007c9420f..f69ab90b5e22 100644
--- a/drivers/parisc/ccio-dma.c
+++ b/drivers/parisc/ccio-dma.c
@@ -1380,15 +1380,17 @@ ccio_init_resource(struct resource *res, char *name, void __iomem *ioaddr)
 	}
 }
 
-static void __init ccio_init_resources(struct ioc *ioc)
+static int __init ccio_init_resources(struct ioc *ioc)
 {
 	struct resource *res = ioc->mmio_region;
 	char *name = kmalloc(14, GFP_KERNEL);
-
+	if (unlikely(!name))
+		return -ENOMEM;
 	snprintf(name, 14, "GSC Bus [%d/]", ioc->hw_path);
 
 	ccio_init_resource(res, name, &ioc->ioc_regs->io_io_low);
 	ccio_init_resource(res + 1, name, &ioc->ioc_regs->io_io_low_hv);
+	return 0;
 }
 
 static int new_ioc_area(struct resource *res, unsigned long size,
@@ -1543,7 +1545,10 @@ static int __init ccio_probe(struct parisc_device *dev)
 		return -ENOMEM;
 	}
 	ccio_ioc_init(ioc);
-	ccio_init_resources(ioc);
+	if (ccio_init_resources(ioc)) {
+		kfree(ioc);
+		return -ENOMEM;
+	}
 	hppa_dma_ops = &ccio_ops;
 
 	hba = kzalloc(sizeof(*hba), GFP_KERNEL);
diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index f4f28e5888b1..43613db7af75 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2688,13 +2688,18 @@ static int _regulator_do_enable(struct regulator_dev *rdev)
  */
 static int _regulator_handle_consumer_enable(struct regulator *regulator)
 {
+	int ret;
 	struct regulator_dev *rdev = regulator->rdev;
 
 	lockdep_assert_held_once(&rdev->mutex.base);
 
 	regulator->enable_count++;
-	if (regulator->uA_load && regulator->enable_count == 1)
-		return drms_uA_update(rdev);
+	if (regulator->uA_load && regulator->enable_count == 1) {
+		ret = drms_uA_update(rdev);
+		if (ret)
+			regulator->enable_count--;
+		return ret;
+	}
 
 	return 0;
 }
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 6d04b3323eb7..33e33fff8986 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -7893,7 +7893,7 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 	/* Allocate device driver memory */
 	rc = lpfc_mem_alloc(phba, SGL_ALIGN_SZ);
 	if (rc)
-		return -ENOMEM;
+		goto out_destroy_workqueue;
 
 	/* IF Type 2 ports get initialized now. */
 	if (bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) >=
@@ -8309,6 +8309,9 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 	lpfc_destroy_bootstrap_mbox(phba);
 out_free_mem:
 	lpfc_mem_free(phba);
+out_destroy_workqueue:
+	destroy_workqueue(phba->wq);
+	phba->wq = NULL;
 	return rc;
 }
 
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index eb5ceb75a15e..056837849ead 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -5279,7 +5279,6 @@ megasas_alloc_fusion_context(struct megasas_instance *instance)
 		if (!fusion->log_to_span) {
 			dev_err(&instance->pdev->dev, "Failed from %s %d\n",
 				__func__, __LINE__);
-			kfree(instance->ctrl_context);
 			return -ENOMEM;
 		}
 	}
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 5351959fbaba..9eb3d0b4891d 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -3670,6 +3670,7 @@ static struct fw_event_work *dequeue_next_fw_event(struct MPT3SAS_ADAPTER *ioc)
 		fw_event = list_first_entry(&ioc->fw_event_list,
 				struct fw_event_work, list);
 		list_del_init(&fw_event->list);
+		fw_event_work_put(fw_event);
 	}
 	spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
 
@@ -3751,7 +3752,6 @@ _scsih_fw_event_cleanup_queue(struct MPT3SAS_ADAPTER *ioc)
 		if (cancel_work_sync(&fw_event->work))
 			fw_event_work_put(fw_event);
 
-		fw_event_work_put(fw_event);
 	}
 	ioc->fw_events_cleanup = 0;
 }
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 7ab3c9e4d478..b86f6e1f21b5 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -6961,14 +6961,8 @@ qlt_24xx_config_rings(struct scsi_qla_host *vha)
 
 	if (ha->flags.msix_enabled) {
 		if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
-			if (IS_QLA2071(ha)) {
-				/* 4 ports Baker: Enable Interrupt Handshake */
-				icb->msix_atio = 0;
-				icb->firmware_options_2 |= cpu_to_le32(BIT_26);
-			} else {
-				icb->msix_atio = cpu_to_le16(msix->entry);
-				icb->firmware_options_2 &= cpu_to_le32(~BIT_26);
-			}
+			icb->msix_atio = cpu_to_le16(msix->entry);
+			icb->firmware_options_2 &= cpu_to_le32(~BIT_26);
 			ql_dbg(ql_dbg_init, vha, 0xf072,
 			    "Registering ICB vector 0x%x for atio que.\n",
 			    msix->entry);
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 2f6468f22b48..dae1a85f1512 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8476,6 +8476,8 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 	struct scsi_device *sdp;
 	unsigned long flags;
 	int ret, retries;
+	unsigned long deadline;
+	int32_t remaining;
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	sdp = hba->sdev_ufs_device;
@@ -8508,9 +8510,14 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 	 * callbacks hence set the RQF_PM flag so that it doesn't resume the
 	 * already suspended childs.
 	 */
+	deadline = jiffies + 10 * HZ;
 	for (retries = 3; retries > 0; --retries) {
+		ret = -ETIMEDOUT;
+		remaining = deadline - jiffies;
+		if (remaining <= 0)
+			break;
 		ret = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
-				START_STOP_TIMEOUT, 0, 0, RQF_PM, NULL);
+				   remaining / HZ, 0, 0, RQF_PM, NULL);
 		if (!scsi_status_is_check_condition(ret) ||
 				!scsi_sense_valid(&sshdr) ||
 				sshdr.sense_key != UNIT_ATTENTION)
diff --git a/drivers/soc/bcm/brcmstb/pm/pm-arm.c b/drivers/soc/bcm/brcmstb/pm/pm-arm.c
index 70ad0f3dce28..286f5d57c0ca 100644
--- a/drivers/soc/bcm/brcmstb/pm/pm-arm.c
+++ b/drivers/soc/bcm/brcmstb/pm/pm-arm.c
@@ -684,13 +684,14 @@ static int brcmstb_pm_probe(struct platform_device *pdev)
 	const struct of_device_id *of_id = NULL;
 	struct device_node *dn;
 	void __iomem *base;
-	int ret, i;
+	int ret, i, s;
 
 	/* AON ctrl registers */
 	base = brcmstb_ioremap_match(aon_ctrl_dt_ids, 0, NULL);
 	if (IS_ERR(base)) {
 		pr_err("error mapping AON_CTRL\n");
-		return PTR_ERR(base);
+		ret = PTR_ERR(base);
+		goto aon_err;
 	}
 	ctrl.aon_ctrl_base = base;
 
@@ -700,8 +701,10 @@ static int brcmstb_pm_probe(struct platform_device *pdev)
 		/* Assume standard offset */
 		ctrl.aon_sram = ctrl.aon_ctrl_base +
 				     AON_CTRL_SYSTEM_DATA_RAM_OFS;
+		s = 0;
 	} else {
 		ctrl.aon_sram = base;
+		s = 1;
 	}
 
 	writel_relaxed(0, ctrl.aon_sram + AON_REG_PANIC);
@@ -711,7 +714,8 @@ static int brcmstb_pm_probe(struct platform_device *pdev)
 				     (const void **)&ddr_phy_data);
 	if (IS_ERR(base)) {
 		pr_err("error mapping DDR PHY\n");
-		return PTR_ERR(base);
+		ret = PTR_ERR(base);
+		goto ddr_phy_err;
 	}
 	ctrl.support_warm_boot = ddr_phy_data->supports_warm_boot;
 	ctrl.pll_status_offset = ddr_phy_data->pll_status_offset;
@@ -731,17 +735,20 @@ static int brcmstb_pm_probe(struct platform_device *pdev)
 	for_each_matching_node(dn, ddr_shimphy_dt_ids) {
 		i = ctrl.num_memc;
 		if (i >= MAX_NUM_MEMC) {
+			of_node_put(dn);
 			pr_warn("too many MEMCs (max %d)\n", MAX_NUM_MEMC);
 			break;
 		}
 
 		base = of_io_request_and_map(dn, 0, dn->full_name);
 		if (IS_ERR(base)) {
+			of_node_put(dn);
 			if (!ctrl.support_warm_boot)
 				break;
 
 			pr_err("error mapping DDR SHIMPHY %d\n", i);
-			return PTR_ERR(base);
+			ret = PTR_ERR(base);
+			goto ddr_shimphy_err;
 		}
 		ctrl.memcs[i].ddr_shimphy_base = base;
 		ctrl.num_memc++;
@@ -752,14 +759,18 @@ static int brcmstb_pm_probe(struct platform_device *pdev)
 	for_each_matching_node(dn, brcmstb_memc_of_match) {
 		base = of_iomap(dn, 0);
 		if (!base) {
+			of_node_put(dn);
 			pr_err("error mapping DDR Sequencer %d\n", i);
-			return -ENOMEM;
+			ret = -ENOMEM;
+			goto brcmstb_memc_err;
 		}
 
 		of_id = of_match_node(brcmstb_memc_of_match, dn);
 		if (!of_id) {
 			iounmap(base);
-			return -EINVAL;
+			of_node_put(dn);
+			ret = -EINVAL;
+			goto brcmstb_memc_err;
 		}
 
 		ddr_seq_data = of_id->data;
@@ -779,21 +790,24 @@ static int brcmstb_pm_probe(struct platform_device *pdev)
 	dn = of_find_matching_node(NULL, sram_dt_ids);
 	if (!dn) {
 		pr_err("SRAM not found\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto brcmstb_memc_err;
 	}
 
 	ret = brcmstb_init_sram(dn);
 	of_node_put(dn);
 	if (ret) {
 		pr_err("error setting up SRAM for PM\n");
-		return ret;
+		goto brcmstb_memc_err;
 	}
 
 	ctrl.pdev = pdev;
 
 	ctrl.s3_params = kmalloc(sizeof(*ctrl.s3_params), GFP_KERNEL);
-	if (!ctrl.s3_params)
-		return -ENOMEM;
+	if (!ctrl.s3_params) {
+		ret = -ENOMEM;
+		goto s3_params_err;
+	}
 	ctrl.s3_params_pa = dma_map_single(&pdev->dev, ctrl.s3_params,
 					   sizeof(*ctrl.s3_params),
 					   DMA_TO_DEVICE);
@@ -813,7 +827,21 @@ static int brcmstb_pm_probe(struct platform_device *pdev)
 
 out:
 	kfree(ctrl.s3_params);
-
+s3_params_err:
+	iounmap(ctrl.boot_sram);
+brcmstb_memc_err:
+	for (i--; i >= 0; i--)
+		iounmap(ctrl.memcs[i].ddr_ctrl);
+ddr_shimphy_err:
+	for (i = 0; i < ctrl.num_memc; i++)
+		iounmap(ctrl.memcs[i].ddr_shimphy_base);
+
+	iounmap(ctrl.memcs[0].ddr_phy_base);
+ddr_phy_err:
+	iounmap(ctrl.aon_ctrl_base);
+	if (s)
+		iounmap(ctrl.aon_sram);
+aon_err:
 	pr_warn("PM: initialization failed with code %d\n", ret);
 
 	return ret;
diff --git a/drivers/soc/imx/gpcv2.c b/drivers/soc/imx/gpcv2.c
index b4aa28420f2a..4dc3a3f73511 100644
--- a/drivers/soc/imx/gpcv2.c
+++ b/drivers/soc/imx/gpcv2.c
@@ -237,6 +237,8 @@ static int imx_pgc_power_up(struct generic_pm_domain *genpd)
 		}
 	}
 
+	reset_control_assert(domain->reset);
+
 	/* Enable reset clocks for all devices in the domain */
 	ret = clk_bulk_prepare_enable(domain->num_clks, domain->clks);
 	if (ret) {
@@ -244,7 +246,8 @@ static int imx_pgc_power_up(struct generic_pm_domain *genpd)
 		goto out_regulator_disable;
 	}
 
-	reset_control_assert(domain->reset);
+	/* delays for reset to propagate */
+	udelay(5);
 
 	if (domain->bits.pxx) {
 		/* request the domain to power up */
diff --git a/drivers/tee/tee_shm.c b/drivers/tee/tee_shm.c
index 6e662fb131d5..bd96ebb82c8e 100644
--- a/drivers/tee/tee_shm.c
+++ b/drivers/tee/tee_shm.c
@@ -9,6 +9,7 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/tee_drv.h>
+#include <linux/uaccess.h>
 #include <linux/uio.h>
 #include "tee_private.h"
 
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 0e9217687f5c..852e6c5643e5 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -561,6 +561,18 @@ static int vaddr_get_pfns(struct mm_struct *mm, unsigned long vaddr,
 	ret = pin_user_pages_remote(mm, vaddr, npages, flags | FOLL_LONGTERM,
 				    pages, NULL, NULL);
 	if (ret > 0) {
+		int i;
+
+		/*
+		 * The zero page is always resident, we don't need to pin it
+		 * and it falls into our invalid/reserved test so we don't
+		 * unpin in put_pfn().  Unpin all zero pages in the batch here.
+		 */
+		for (i = 0 ; i < ret; i++) {
+			if (unlikely(is_zero_pfn(page_to_pfn(pages[i]))))
+				unpin_user_page(pages[i]);
+		}
+
 		*pfn = page_to_pfn(pages[0]);
 		goto done;
 	}
diff --git a/drivers/video/fbdev/chipsfb.c b/drivers/video/fbdev/chipsfb.c
index 393894af26f8..2b00a9d554fc 100644
--- a/drivers/video/fbdev/chipsfb.c
+++ b/drivers/video/fbdev/chipsfb.c
@@ -430,6 +430,7 @@ static int chipsfb_pci_init(struct pci_dev *dp, const struct pci_device_id *ent)
  err_release_fb:
 	framebuffer_release(p);
  err_disable:
+	pci_disable_device(dp);
  err_out:
 	return rc;
 }
diff --git a/drivers/video/fbdev/core/fbsysfs.c b/drivers/video/fbdev/core/fbsysfs.c
index ce699396d6ba..09ee27e7fc25 100644
--- a/drivers/video/fbdev/core/fbsysfs.c
+++ b/drivers/video/fbdev/core/fbsysfs.c
@@ -84,6 +84,10 @@ void framebuffer_release(struct fb_info *info)
 	if (WARN_ON(refcount_read(&info->count)))
 		return;
 
+#if IS_ENABLED(CONFIG_FB_BACKLIGHT)
+	mutex_destroy(&info->bl_curve_mutex);
+#endif
+
 	kfree(info->apertures);
 	kfree(info);
 }
diff --git a/fs/afs/flock.c b/fs/afs/flock.c
index c4210a3964d8..bbcc5afd1576 100644
--- a/fs/afs/flock.c
+++ b/fs/afs/flock.c
@@ -76,7 +76,7 @@ void afs_lock_op_done(struct afs_call *call)
 	if (call->error == 0) {
 		spin_lock(&vnode->lock);
 		trace_afs_flock_ev(vnode, NULL, afs_flock_timestamp, 0);
-		vnode->locked_at = call->reply_time;
+		vnode->locked_at = call->issue_time;
 		afs_schedule_lock_extension(vnode);
 		spin_unlock(&vnode->lock);
 	}
diff --git a/fs/afs/fsclient.c b/fs/afs/fsclient.c
index 4943413d9c5f..7d37f63ef0f0 100644
--- a/fs/afs/fsclient.c
+++ b/fs/afs/fsclient.c
@@ -131,7 +131,7 @@ static void xdr_decode_AFSFetchStatus(const __be32 **_bp,
 
 static time64_t xdr_decode_expiry(struct afs_call *call, u32 expiry)
 {
-	return ktime_divns(call->reply_time, NSEC_PER_SEC) + expiry;
+	return ktime_divns(call->issue_time, NSEC_PER_SEC) + expiry;
 }
 
 static void xdr_decode_AFSCallBack(const __be32 **_bp,
diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index 0ad97a8fc0d4..567e61b553f5 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -138,7 +138,6 @@ struct afs_call {
 	bool			need_attention;	/* T if RxRPC poked us */
 	bool			async;		/* T if asynchronous */
 	bool			upgrade;	/* T to request service upgrade */
-	bool			have_reply_time; /* T if have got reply_time */
 	bool			intr;		/* T if interruptible */
 	bool			unmarshalling_error; /* T if an unmarshalling error occurred */
 	u16			service_id;	/* Actual service ID (after upgrade) */
@@ -152,7 +151,7 @@ struct afs_call {
 		} __attribute__((packed));
 		__be64		tmp64;
 	};
-	ktime_t			reply_time;	/* Time of first reply packet */
+	ktime_t			issue_time;	/* Time of issue of operation */
 };
 
 struct afs_call_type {
diff --git a/fs/afs/rxrpc.c b/fs/afs/rxrpc.c
index a5434f3e57c6..e3de7fea3643 100644
--- a/fs/afs/rxrpc.c
+++ b/fs/afs/rxrpc.c
@@ -347,6 +347,7 @@ void afs_make_call(struct afs_addr_cursor *ac, struct afs_call *call, gfp_t gfp)
 	if (call->max_lifespan)
 		rxrpc_kernel_set_max_life(call->net->socket, rxcall,
 					  call->max_lifespan);
+	call->issue_time = ktime_get_real();
 
 	/* send the request */
 	iov[0].iov_base	= call->request;
@@ -497,12 +498,6 @@ static void afs_deliver_to_call(struct afs_call *call)
 			return;
 		}
 
-		if (!call->have_reply_time &&
-		    rxrpc_kernel_get_reply_time(call->net->socket,
-						call->rxcall,
-						&call->reply_time))
-			call->have_reply_time = true;
-
 		ret = call->type->deliver(call);
 		state = READ_ONCE(call->state);
 		if (ret == 0 && call->unmarshalling_error)
diff --git a/fs/afs/yfsclient.c b/fs/afs/yfsclient.c
index 2b35cba8ad62..88ea20e79ae2 100644
--- a/fs/afs/yfsclient.c
+++ b/fs/afs/yfsclient.c
@@ -239,8 +239,7 @@ static void xdr_decode_YFSCallBack(const __be32 **_bp,
 	struct afs_callback *cb = &scb->callback;
 	ktime_t cb_expiry;
 
-	cb_expiry = call->reply_time;
-	cb_expiry = ktime_add(cb_expiry, xdr_to_u64(x->expiration_time) * 100);
+	cb_expiry = ktime_add(call->issue_time, xdr_to_u64(x->expiration_time) * 100);
 	cb->expires_at	= ktime_divns(cb_expiry, NSEC_PER_SEC);
 	scb->have_cb	= true;
 	*_bp += xdr_size(x);
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 7a127d3c521f..96958ca474bd 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -392,10 +392,19 @@ int btrfs_get_dev_zone_info(struct btrfs_device *device, bool populate_cache)
 	 * since btrfs adds the pages one by one to a bio, and btrfs cannot
 	 * increase the metadata reservation even if it increases the number of
 	 * extents, it is safe to stick with the limit.
+	 *
+	 * With the zoned emulation, we can have non-zoned device on the zoned
+	 * mode. In this case, we don't have a valid max zone append size. So,
+	 * use max_segments * PAGE_SIZE as the pseudo max_zone_append_size.
 	 */
-	zone_info->max_zone_append_size =
-		min_t(u64, (u64)bdev_max_zone_append_sectors(bdev) << SECTOR_SHIFT,
-		      (u64)bdev_max_segments(bdev) << PAGE_SHIFT);
+	if (bdev_is_zoned(bdev)) {
+		zone_info->max_zone_append_size = min_t(u64,
+			(u64)bdev_max_zone_append_sectors(bdev) << SECTOR_SHIFT,
+			(u64)bdev_max_segments(bdev) << PAGE_SHIFT);
+	} else {
+		zone_info->max_zone_append_size =
+			(u64)bdev_max_segments(bdev) << PAGE_SHIFT;
+	}
 	if (!IS_ALIGNED(nr_sectors, zone_sectors))
 		zone_info->nr_zones++;
 
diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index 2f117c57160d..26f9cd328291 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -734,6 +734,28 @@ void debugfs_remove(struct dentry *dentry)
 }
 EXPORT_SYMBOL_GPL(debugfs_remove);
 
+/**
+ * debugfs_lookup_and_remove - lookup a directory or file and recursively remove it
+ * @name: a pointer to a string containing the name of the item to look up.
+ * @parent: a pointer to the parent dentry of the item.
+ *
+ * This is the equlivant of doing something like
+ * debugfs_remove(debugfs_lookup(..)) but with the proper reference counting
+ * handled for the directory being looked up.
+ */
+void debugfs_lookup_and_remove(const char *name, struct dentry *parent)
+{
+	struct dentry *dentry;
+
+	dentry = debugfs_lookup(name, parent);
+	if (!dentry)
+		return;
+
+	debugfs_remove(dentry);
+	dput(dentry);
+}
+EXPORT_SYMBOL_GPL(debugfs_lookup_and_remove);
+
 /**
  * debugfs_rename - rename a file/directory in the debugfs filesystem
  * @old_dir: a pointer to the parent dentry for the renamed object. This
diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
index 9524e155b38f..b77acf09726c 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -143,7 +143,6 @@ struct erofs_workgroup {
 	atomic_t refcount;
 };
 
-#if defined(CONFIG_SMP)
 static inline bool erofs_workgroup_try_to_freeze(struct erofs_workgroup *grp,
 						 int val)
 {
@@ -172,34 +171,6 @@ static inline int erofs_wait_on_workgroup_freezed(struct erofs_workgroup *grp)
 	return atomic_cond_read_relaxed(&grp->refcount,
 					VAL != EROFS_LOCKED_MAGIC);
 }
-#else
-static inline bool erofs_workgroup_try_to_freeze(struct erofs_workgroup *grp,
-						 int val)
-{
-	preempt_disable();
-	/* no need to spin on UP platforms, let's just disable preemption. */
-	if (val != atomic_read(&grp->refcount)) {
-		preempt_enable();
-		return false;
-	}
-	return true;
-}
-
-static inline void erofs_workgroup_unfreeze(struct erofs_workgroup *grp,
-					    int orig_val)
-{
-	preempt_enable();
-}
-
-static inline int erofs_wait_on_workgroup_freezed(struct erofs_workgroup *grp)
-{
-	int v = atomic_read(&grp->refcount);
-
-	/* workgroup is never freezed on uniprocessor systems */
-	DBG_BUGON(v == EROFS_LOCKED_MAGIC);
-	return v;
-}
-#endif	/* !CONFIG_SMP */
 #endif	/* !CONFIG_EROFS_FS_ZIP */
 
 /* we strictly follow PAGE_SIZE and no buffer head yet */
diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 78219396788b..32c3d0c454b1 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -78,6 +78,7 @@ static struct nfs_open_dir_context *alloc_nfs_open_dir_context(struct inode *dir
 		ctx->attr_gencount = nfsi->attr_gencount;
 		ctx->dir_cookie = 0;
 		ctx->dup_cookie = 0;
+		ctx->page_index = 0;
 		spin_lock(&dir->i_lock);
 		if (list_empty(&nfsi->open_files) &&
 		    (nfsi->cache_validity & NFS_INO_DATA_INVAL_DEFER))
@@ -85,6 +86,7 @@ static struct nfs_open_dir_context *alloc_nfs_open_dir_context(struct inode *dir
 					      NFS_INO_INVALID_DATA |
 						      NFS_INO_REVAL_FORCED);
 		list_add(&ctx->list, &nfsi->open_files);
+		clear_bit(NFS_INO_FORCE_READDIR, &nfsi->flags);
 		spin_unlock(&dir->i_lock);
 		return ctx;
 	}
@@ -626,8 +628,7 @@ void nfs_force_use_readdirplus(struct inode *dir)
 	if (nfs_server_capable(dir, NFS_CAP_READDIRPLUS) &&
 	    !list_empty(&nfsi->open_files)) {
 		set_bit(NFS_INO_ADVISE_RDPLUS, &nfsi->flags);
-		invalidate_mapping_pages(dir->i_mapping,
-			nfsi->page_index + 1, -1);
+		set_bit(NFS_INO_FORCE_READDIR, &nfsi->flags);
 	}
 }
 
@@ -938,10 +939,8 @@ static int find_and_lock_cache_page(struct nfs_readdir_descriptor *desc)
 			       sizeof(nfsi->cookieverf));
 	}
 	res = nfs_readdir_search_array(desc);
-	if (res == 0) {
-		nfsi->page_index = desc->page_index;
+	if (res == 0)
 		return 0;
-	}
 	nfs_readdir_page_unlock_and_put_cached(desc);
 	return res;
 }
@@ -1081,6 +1080,7 @@ static int nfs_readdir(struct file *file, struct dir_context *ctx)
 	struct nfs_inode *nfsi = NFS_I(inode);
 	struct nfs_open_dir_context *dir_ctx = file->private_data;
 	struct nfs_readdir_descriptor *desc;
+	pgoff_t page_index;
 	int res;
 
 	dfprintk(FILE, "NFS: readdir(%pD2) starting at cookie %llu\n",
@@ -1111,10 +1111,15 @@ static int nfs_readdir(struct file *file, struct dir_context *ctx)
 	desc->dir_cookie = dir_ctx->dir_cookie;
 	desc->dup_cookie = dir_ctx->dup_cookie;
 	desc->duped = dir_ctx->duped;
+	page_index = dir_ctx->page_index;
 	desc->attr_gencount = dir_ctx->attr_gencount;
 	memcpy(desc->verf, dir_ctx->verf, sizeof(desc->verf));
 	spin_unlock(&file->f_lock);
 
+	if (test_and_clear_bit(NFS_INO_FORCE_READDIR, &nfsi->flags) &&
+	    list_is_singular(&nfsi->open_files))
+		invalidate_mapping_pages(inode->i_mapping, page_index + 1, -1);
+
 	do {
 		res = readdir_search_pagecache(desc);
 
@@ -1151,6 +1156,7 @@ static int nfs_readdir(struct file *file, struct dir_context *ctx)
 	dir_ctx->dup_cookie = desc->dup_cookie;
 	dir_ctx->duped = desc->duped;
 	dir_ctx->attr_gencount = desc->attr_gencount;
+	dir_ctx->page_index = desc->page_index;
 	memcpy(dir_ctx->verf, desc->verf, sizeof(dir_ctx->verf));
 	spin_unlock(&file->f_lock);
 
diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index a8693cc50c7c..ad5114e48009 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -223,8 +223,10 @@ nfs_file_fsync_commit(struct file *file, int datasync)
 int
 nfs_file_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 {
-	struct nfs_open_context *ctx = nfs_file_open_context(file);
 	struct inode *inode = file_inode(file);
+	struct nfs_inode *nfsi = NFS_I(inode);
+	long save_nredirtied = atomic_long_read(&nfsi->redirtied_pages);
+	long nredirtied;
 	int ret;
 
 	trace_nfs_fsync_enter(inode);
@@ -239,15 +241,10 @@ nfs_file_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 		ret = pnfs_sync_inode(inode, !!datasync);
 		if (ret != 0)
 			break;
-		if (!test_and_clear_bit(NFS_CONTEXT_RESEND_WRITES, &ctx->flags))
+		nredirtied = atomic_long_read(&nfsi->redirtied_pages);
+		if (nredirtied == save_nredirtied)
 			break;
-		/*
-		 * If nfs_file_fsync_commit detected a server reboot, then
-		 * resend all dirty pages that might have been covered by
-		 * the NFS_CONTEXT_RESEND_WRITES flag
-		 */
-		start = 0;
-		end = LLONG_MAX;
+		save_nredirtied = nredirtied;
 	}
 
 	trace_nfs_fsync_exit(inode, ret);
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index cb407af9e9e9..e4524635a129 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -431,6 +431,23 @@ nfs_ilookup(struct super_block *sb, struct nfs_fattr *fattr, struct nfs_fh *fh)
 	return inode;
 }
 
+static void nfs_inode_init_regular(struct nfs_inode *nfsi)
+{
+	atomic_long_set(&nfsi->nrequests, 0);
+	atomic_long_set(&nfsi->redirtied_pages, 0);
+	INIT_LIST_HEAD(&nfsi->commit_info.list);
+	atomic_long_set(&nfsi->commit_info.ncommit, 0);
+	atomic_set(&nfsi->commit_info.rpcs_out, 0);
+	mutex_init(&nfsi->commit_mutex);
+}
+
+static void nfs_inode_init_dir(struct nfs_inode *nfsi)
+{
+	nfsi->cache_change_attribute = 0;
+	memset(nfsi->cookieverf, 0, sizeof(nfsi->cookieverf));
+	init_rwsem(&nfsi->rmdir_sem);
+}
+
 /*
  * This is our front-end to iget that looks up inodes by file handle
  * instead of inode number.
@@ -485,10 +502,12 @@ nfs_fhget(struct super_block *sb, struct nfs_fh *fh, struct nfs_fattr *fattr, st
 		if (S_ISREG(inode->i_mode)) {
 			inode->i_fop = NFS_SB(sb)->nfs_client->rpc_ops->file_ops;
 			inode->i_data.a_ops = &nfs_file_aops;
+			nfs_inode_init_regular(nfsi);
 		} else if (S_ISDIR(inode->i_mode)) {
 			inode->i_op = NFS_SB(sb)->nfs_client->rpc_ops->dir_inode_ops;
 			inode->i_fop = &nfs_dir_operations;
 			inode->i_data.a_ops = &nfs_dir_aops;
+			nfs_inode_init_dir(nfsi);
 			/* Deal with crossing mountpoints */
 			if (fattr->valid & NFS_ATTR_FATTR_MOUNTPOINT ||
 					fattr->valid & NFS_ATTR_FATTR_V4_REFERRAL) {
@@ -514,7 +533,6 @@ nfs_fhget(struct super_block *sb, struct nfs_fh *fh, struct nfs_fattr *fattr, st
 		inode->i_uid = make_kuid(&init_user_ns, -2);
 		inode->i_gid = make_kgid(&init_user_ns, -2);
 		inode->i_blocks = 0;
-		memset(nfsi->cookieverf, 0, sizeof(nfsi->cookieverf));
 		nfsi->write_io = 0;
 		nfsi->read_io = 0;
 
@@ -2282,14 +2300,7 @@ static void init_once(void *foo)
 	INIT_LIST_HEAD(&nfsi->open_files);
 	INIT_LIST_HEAD(&nfsi->access_cache_entry_lru);
 	INIT_LIST_HEAD(&nfsi->access_cache_inode_lru);
-	INIT_LIST_HEAD(&nfsi->commit_info.list);
-	atomic_long_set(&nfsi->nrequests, 0);
-	atomic_long_set(&nfsi->commit_info.ncommit, 0);
-	atomic_set(&nfsi->commit_info.rpcs_out, 0);
-	init_rwsem(&nfsi->rmdir_sem);
-	mutex_init(&nfsi->commit_mutex);
 	nfs4_init_once(nfsi);
-	nfsi->cache_change_attribute = 0;
 }
 
 static int __init nfs_init_inodecache(void)
diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index cdb29fd23549..be70874bc329 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -1394,10 +1394,12 @@ static void nfs_initiate_write(struct nfs_pgio_header *hdr,
  */
 static void nfs_redirty_request(struct nfs_page *req)
 {
+	struct nfs_inode *nfsi = NFS_I(page_file_mapping(req->wb_page)->host);
+
 	/* Bump the transmission count */
 	req->wb_nio++;
 	nfs_mark_request_dirty(req);
-	set_bit(NFS_CONTEXT_RESEND_WRITES, &nfs_req_openctx(req)->flags);
+	atomic_long_inc(&nfsi->redirtied_pages);
 	nfs_end_page_writeback(req);
 	nfs_release_request(req);
 }
@@ -1870,7 +1872,7 @@ static void nfs_commit_release_pages(struct nfs_commit_data *data)
 		/* We have a mismatch. Write the page again */
 		dprintk_cont(" mismatch\n");
 		nfs_mark_request_dirty(req);
-		set_bit(NFS_CONTEXT_RESEND_WRITES, &nfs_req_openctx(req)->flags);
+		atomic_long_inc(&NFS_I(data->inode)->redirtied_pages);
 	next:
 		nfs_unlock_and_release_request(req);
 		/* Latency breaker */
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index c841367ff8c9..25b4263d66d7 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -136,6 +136,17 @@ BUFFER_FNS(Defer_Completion, defer_completion)
 
 static __always_inline void set_buffer_uptodate(struct buffer_head *bh)
 {
+	/*
+	 * If somebody else already set this uptodate, they will
+	 * have done the memory barrier, and a reader will thus
+	 * see *some* valid buffer state.
+	 *
+	 * Any other serialization (with IO errors or whatever that
+	 * might clear the bit) has to come from other state (eg BH_Lock).
+	 */
+	if (test_bit(BH_Uptodate, &bh->b_state))
+		return;
+
 	/*
 	 * make it consistent with folio_mark_uptodate
 	 * pairs with smp_load_acquire in buffer_uptodate
diff --git a/include/linux/debugfs.h b/include/linux/debugfs.h
index c869f1e73d75..f60674692d36 100644
--- a/include/linux/debugfs.h
+++ b/include/linux/debugfs.h
@@ -91,6 +91,8 @@ struct dentry *debugfs_create_automount(const char *name,
 void debugfs_remove(struct dentry *dentry);
 #define debugfs_remove_recursive debugfs_remove
 
+void debugfs_lookup_and_remove(const char *name, struct dentry *parent);
+
 const struct file_operations *debugfs_real_fops(const struct file *filp);
 
 int debugfs_file_get(struct dentry *dentry);
@@ -225,6 +227,10 @@ static inline void debugfs_remove(struct dentry *dentry)
 static inline void debugfs_remove_recursive(struct dentry *dentry)
 { }
 
+static inline void debugfs_lookup_and_remove(const char *name,
+					     struct dentry *parent)
+{ }
+
 const struct file_operations *debugfs_real_fops(const struct file *filp);
 
 static inline int debugfs_file_get(struct dentry *dentry)
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index 66b6cc24ab8c..71467d661fb6 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -103,6 +103,7 @@ struct nfs_open_dir_context {
 	__be32	verf[NFS_DIR_VERIFIER_SIZE];
 	__u64 dir_cookie;
 	__u64 dup_cookie;
+	pgoff_t page_index;
 	signed char duped;
 };
 
@@ -154,36 +155,40 @@ struct nfs_inode {
 	unsigned long		attrtimeo_timestamp;
 
 	unsigned long		attr_gencount;
-	/* "Generation counter" for the attribute cache. This is
-	 * bumped whenever we update the metadata on the
-	 * server.
-	 */
-	unsigned long		cache_change_attribute;
 
 	struct rb_root		access_cache;
 	struct list_head	access_cache_entry_lru;
 	struct list_head	access_cache_inode_lru;
 
-	/*
-	 * This is the cookie verifier used for NFSv3 readdir
-	 * operations
-	 */
-	__be32			cookieverf[NFS_DIR_VERIFIER_SIZE];
-
-	atomic_long_t		nrequests;
-	struct nfs_mds_commit_info commit_info;
+	union {
+		/* Directory */
+		struct {
+			/* "Generation counter" for the attribute cache.
+			 * This is bumped whenever we update the metadata
+			 * on the server.
+			 */
+			unsigned long	cache_change_attribute;
+			/*
+			 * This is the cookie verifier used for NFSv3 readdir
+			 * operations
+			 */
+			__be32		cookieverf[NFS_DIR_VERIFIER_SIZE];
+			/* Readers: in-flight sillydelete RPC calls */
+			/* Writers: rmdir */
+			struct rw_semaphore	rmdir_sem;
+		};
+		/* Regular file */
+		struct {
+			atomic_long_t	nrequests;
+			atomic_long_t	redirtied_pages;
+			struct nfs_mds_commit_info commit_info;
+			struct mutex	commit_mutex;
+		};
+	};
 
 	/* Open contexts for shared mmap writes */
 	struct list_head	open_files;
 
-	/* Readers: in-flight sillydelete RPC calls */
-	/* Writers: rmdir */
-	struct rw_semaphore	rmdir_sem;
-	struct mutex		commit_mutex;
-
-	/* track last access to cached pages */
-	unsigned long		page_index;
-
 #if IS_ENABLED(CONFIG_NFS_V4)
 	struct nfs4_cached_acl	*nfs4_acl;
         /* NFSv4 state */
@@ -272,6 +277,7 @@ struct nfs4_copy_state {
 #define NFS_INO_INVALIDATING	(3)		/* inode is being invalidated */
 #define NFS_INO_FSCACHE		(5)		/* inode can be cached by FS-Cache */
 #define NFS_INO_FSCACHE_LOCK	(6)		/* FS-Cache cookie management lock */
+#define NFS_INO_FORCE_READDIR	(7)		/* force readdirplus */
 #define NFS_INO_LAYOUTCOMMIT	(9)		/* layoutcommit required */
 #define NFS_INO_LAYOUTCOMMITTING (10)		/* layoutcommit inflight */
 #define NFS_INO_LAYOUTSTATS	(11)		/* layoutstats inflight */
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index ae598ed86b50..cfb889f66c70 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2232,6 +2232,22 @@ static inline unsigned int skb_pagelen(const struct sk_buff *skb)
 	return skb_headlen(skb) + __skb_pagelen(skb);
 }
 
+static inline void __skb_fill_page_desc_noacc(struct skb_shared_info *shinfo,
+					      int i, struct page *page,
+					      int off, int size)
+{
+	skb_frag_t *frag = &shinfo->frags[i];
+
+	/*
+	 * Propagate page pfmemalloc to the skb if we can. The problem is
+	 * that not all callers have unique ownership of the page but rely
+	 * on page_is_pfmemalloc doing the right thing(tm).
+	 */
+	frag->bv_page		  = page;
+	frag->bv_offset		  = off;
+	skb_frag_size_set(frag, size);
+}
+
 /**
  * __skb_fill_page_desc - initialise a paged fragment in an skb
  * @skb: buffer containing fragment to be initialised
@@ -2248,17 +2264,7 @@ static inline unsigned int skb_pagelen(const struct sk_buff *skb)
 static inline void __skb_fill_page_desc(struct sk_buff *skb, int i,
 					struct page *page, int off, int size)
 {
-	skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
-
-	/*
-	 * Propagate page pfmemalloc to the skb if we can. The problem is
-	 * that not all callers have unique ownership of the page but rely
-	 * on page_is_pfmemalloc doing the right thing(tm).
-	 */
-	frag->bv_page		  = page;
-	frag->bv_offset		  = off;
-	skb_frag_size_set(frag, size);
-
+	__skb_fill_page_desc_noacc(skb_shinfo(skb), i, page, off, size);
 	page = compound_head(page);
 	if (page_is_pfmemalloc(page))
 		skb->pfmemalloc	= true;
@@ -2285,6 +2291,27 @@ static inline void skb_fill_page_desc(struct sk_buff *skb, int i,
 	skb_shinfo(skb)->nr_frags = i + 1;
 }
 
+/**
+ * skb_fill_page_desc_noacc - initialise a paged fragment in an skb
+ * @skb: buffer containing fragment to be initialised
+ * @i: paged fragment index to initialise
+ * @page: the page to use for this fragment
+ * @off: the offset to the data with @page
+ * @size: the length of the data
+ *
+ * Variant of skb_fill_page_desc() which does not deal with
+ * pfmemalloc, if page is not owned by us.
+ */
+static inline void skb_fill_page_desc_noacc(struct sk_buff *skb, int i,
+					    struct page *page, int off,
+					    int size)
+{
+	struct skb_shared_info *shinfo = skb_shinfo(skb);
+
+	__skb_fill_page_desc_noacc(shinfo, i, page, off, size);
+	shinfo->nr_frags = i + 1;
+}
+
 void skb_add_rx_frag(struct sk_buff *skb, int i, struct page *page, int off,
 		     int size, unsigned int truesize);
 
diff --git a/include/linux/udp.h b/include/linux/udp.h
index ae66dadd8543..0727276e7538 100644
--- a/include/linux/udp.h
+++ b/include/linux/udp.h
@@ -75,6 +75,7 @@ struct udp_sock {
 	 * For encapsulation sockets.
 	 */
 	int (*encap_rcv)(struct sock *sk, struct sk_buff *skb);
+	void (*encap_err_rcv)(struct sock *sk, struct sk_buff *skb, unsigned int udp_offset);
 	int (*encap_err_lookup)(struct sock *sk, struct sk_buff *skb);
 	void (*encap_destroy)(struct sock *sk);
 
diff --git a/include/net/udp_tunnel.h b/include/net/udp_tunnel.h
index afc7ce713657..72394f441dad 100644
--- a/include/net/udp_tunnel.h
+++ b/include/net/udp_tunnel.h
@@ -67,6 +67,9 @@ static inline int udp_sock_create(struct net *net,
 typedef int (*udp_tunnel_encap_rcv_t)(struct sock *sk, struct sk_buff *skb);
 typedef int (*udp_tunnel_encap_err_lookup_t)(struct sock *sk,
 					     struct sk_buff *skb);
+typedef void (*udp_tunnel_encap_err_rcv_t)(struct sock *sk,
+					   struct sk_buff *skb,
+					   unsigned int udp_offset);
 typedef void (*udp_tunnel_encap_destroy_t)(struct sock *sk);
 typedef struct sk_buff *(*udp_tunnel_gro_receive_t)(struct sock *sk,
 						    struct list_head *head,
@@ -80,6 +83,7 @@ struct udp_tunnel_sock_cfg {
 	__u8  encap_type;
 	udp_tunnel_encap_rcv_t encap_rcv;
 	udp_tunnel_encap_err_lookup_t encap_err_lookup;
+	udp_tunnel_encap_err_rcv_t encap_err_rcv;
 	udp_tunnel_encap_destroy_t encap_destroy;
 	udp_tunnel_gro_receive_t gro_receive;
 	udp_tunnel_gro_complete_t gro_complete;
diff --git a/include/soc/at91/sama7-ddr.h b/include/soc/at91/sama7-ddr.h
index f6542584ca13..f203f34dba12 100644
--- a/include/soc/at91/sama7-ddr.h
+++ b/include/soc/at91/sama7-ddr.h
@@ -11,8 +11,6 @@
 #ifndef __SAMA7_DDR_H__
 #define __SAMA7_DDR_H__
 
-#ifdef CONFIG_SOC_SAMA7
-
 /* DDR3PHY */
 #define DDR3PHY_PIR				(0x04)		/* DDR3PHY PHY Initialization Register	*/
 #define	DDR3PHY_PIR_DLLBYP		(1 << 17)	/* DLL Bypass */
@@ -40,6 +38,14 @@
 #define		DDR3PHY_DSGCR_ODTPDD_ODT0	(1 << 20)	/* ODT[0] Power Down Driver */
 
 #define DDR3PHY_ZQ0SR0				(0x188)		/* ZQ status register 0 */
+#define DDR3PHY_ZQ0SR0_PDO_OFF			(0)		/* Pull-down output impedance select offset */
+#define DDR3PHY_ZQ0SR0_PUO_OFF			(5)		/* Pull-up output impedance select offset */
+#define DDR3PHY_ZQ0SR0_PDODT_OFF		(10)		/* Pull-down on-die termination impedance select offset */
+#define DDR3PHY_ZQ0SRO_PUODT_OFF		(15)		/* Pull-up on-die termination impedance select offset */
+
+#define	DDR3PHY_DX0DLLCR			(0x1CC)		/* DDR3PHY DATX8 DLL Control Register */
+#define	DDR3PHY_DX1DLLCR			(0x20C)		/* DDR3PHY DATX8 DLL Control Register */
+#define		DDR3PHY_DXDLLCR_DLLDIS		(1 << 31)	/* DLL Disable */
 
 /* UDDRC */
 #define UDDRC_STAT				(0x04)		/* UDDRC Operating Mode Status Register */
@@ -75,6 +81,4 @@
 #define UDDRC_PCTRL_3				(0x6A0)		/* UDDRC Port 3 Control Register */
 #define UDDRC_PCTRL_4				(0x750)		/* UDDRC Port 4 Control Register */
 
-#endif /* CONFIG_SOC_SAMA7 */
-
 #endif /* __SAMA7_DDR_H__ */
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 416dd7db3fb2..75c3881af078 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2345,6 +2345,47 @@ int task_cgroup_path(struct task_struct *task, char *buf, size_t buflen)
 }
 EXPORT_SYMBOL_GPL(task_cgroup_path);
 
+/**
+ * cgroup_attach_lock - Lock for ->attach()
+ * @lock_threadgroup: whether to down_write cgroup_threadgroup_rwsem
+ *
+ * cgroup migration sometimes needs to stabilize threadgroups against forks and
+ * exits by write-locking cgroup_threadgroup_rwsem. However, some ->attach()
+ * implementations (e.g. cpuset), also need to disable CPU hotplug.
+ * Unfortunately, letting ->attach() operations acquire cpus_read_lock() can
+ * lead to deadlocks.
+ *
+ * Bringing up a CPU may involve creating and destroying tasks which requires
+ * read-locking threadgroup_rwsem, so threadgroup_rwsem nests inside
+ * cpus_read_lock(). If we call an ->attach() which acquires the cpus lock while
+ * write-locking threadgroup_rwsem, the locking order is reversed and we end up
+ * waiting for an on-going CPU hotplug operation which in turn is waiting for
+ * the threadgroup_rwsem to be released to create new tasks. For more details:
+ *
+ *   http://lkml.kernel.org/r/20220711174629.uehfmqegcwn2lqzu@wubuntu
+ *
+ * Resolve the situation by always acquiring cpus_read_lock() before optionally
+ * write-locking cgroup_threadgroup_rwsem. This allows ->attach() to assume that
+ * CPU hotplug is disabled on entry.
+ */
+static void cgroup_attach_lock(bool lock_threadgroup)
+{
+	cpus_read_lock();
+	if (lock_threadgroup)
+		percpu_down_write(&cgroup_threadgroup_rwsem);
+}
+
+/**
+ * cgroup_attach_unlock - Undo cgroup_attach_lock()
+ * @lock_threadgroup: whether to up_write cgroup_threadgroup_rwsem
+ */
+static void cgroup_attach_unlock(bool lock_threadgroup)
+{
+	if (lock_threadgroup)
+		percpu_up_write(&cgroup_threadgroup_rwsem);
+	cpus_read_unlock();
+}
+
 /**
  * cgroup_migrate_add_task - add a migration target task to a migration context
  * @task: target task
@@ -2821,8 +2862,7 @@ int cgroup_attach_task(struct cgroup *dst_cgrp, struct task_struct *leader,
 }
 
 struct task_struct *cgroup_procs_write_start(char *buf, bool threadgroup,
-					     bool *locked)
-	__acquires(&cgroup_threadgroup_rwsem)
+					     bool *threadgroup_locked)
 {
 	struct task_struct *tsk;
 	pid_t pid;
@@ -2839,12 +2879,8 @@ struct task_struct *cgroup_procs_write_start(char *buf, bool threadgroup,
 	 * Therefore, we can skip the global lock.
 	 */
 	lockdep_assert_held(&cgroup_mutex);
-	if (pid || threadgroup) {
-		percpu_down_write(&cgroup_threadgroup_rwsem);
-		*locked = true;
-	} else {
-		*locked = false;
-	}
+	*threadgroup_locked = pid || threadgroup;
+	cgroup_attach_lock(*threadgroup_locked);
 
 	rcu_read_lock();
 	if (pid) {
@@ -2875,17 +2911,14 @@ struct task_struct *cgroup_procs_write_start(char *buf, bool threadgroup,
 	goto out_unlock_rcu;
 
 out_unlock_threadgroup:
-	if (*locked) {
-		percpu_up_write(&cgroup_threadgroup_rwsem);
-		*locked = false;
-	}
+	cgroup_attach_unlock(*threadgroup_locked);
+	*threadgroup_locked = false;
 out_unlock_rcu:
 	rcu_read_unlock();
 	return tsk;
 }
 
-void cgroup_procs_write_finish(struct task_struct *task, bool locked)
-	__releases(&cgroup_threadgroup_rwsem)
+void cgroup_procs_write_finish(struct task_struct *task, bool threadgroup_locked)
 {
 	struct cgroup_subsys *ss;
 	int ssid;
@@ -2893,8 +2926,8 @@ void cgroup_procs_write_finish(struct task_struct *task, bool locked)
 	/* release reference from cgroup_procs_write_start() */
 	put_task_struct(task);
 
-	if (locked)
-		percpu_up_write(&cgroup_threadgroup_rwsem);
+	cgroup_attach_unlock(threadgroup_locked);
+
 	for_each_subsys(ss, ssid)
 		if (ss->post_attach)
 			ss->post_attach();
@@ -2949,12 +2982,11 @@ static int cgroup_update_dfl_csses(struct cgroup *cgrp)
 	struct cgroup_subsys_state *d_css;
 	struct cgroup *dsct;
 	struct css_set *src_cset;
+	bool has_tasks;
 	int ret;
 
 	lockdep_assert_held(&cgroup_mutex);
 
-	percpu_down_write(&cgroup_threadgroup_rwsem);
-
 	/* look up all csses currently attached to @cgrp's subtree */
 	spin_lock_irq(&css_set_lock);
 	cgroup_for_each_live_descendant_pre(dsct, d_css, cgrp) {
@@ -2965,6 +2997,15 @@ static int cgroup_update_dfl_csses(struct cgroup *cgrp)
 	}
 	spin_unlock_irq(&css_set_lock);
 
+	/*
+	 * We need to write-lock threadgroup_rwsem while migrating tasks.
+	 * However, if there are no source csets for @cgrp, changing its
+	 * controllers isn't gonna produce any task migrations and the
+	 * write-locking can be skipped safely.
+	 */
+	has_tasks = !list_empty(&mgctx.preloaded_src_csets);
+	cgroup_attach_lock(has_tasks);
+
 	/* NULL dst indicates self on default hierarchy */
 	ret = cgroup_migrate_prepare_dst(&mgctx);
 	if (ret)
@@ -2984,7 +3025,7 @@ static int cgroup_update_dfl_csses(struct cgroup *cgrp)
 	ret = cgroup_migrate_execute(&mgctx);
 out_finish:
 	cgroup_migrate_finish(&mgctx);
-	percpu_up_write(&cgroup_threadgroup_rwsem);
+	cgroup_attach_unlock(has_tasks);
 	return ret;
 }
 
@@ -4932,13 +4973,13 @@ static ssize_t __cgroup_procs_write(struct kernfs_open_file *of, char *buf,
 	struct task_struct *task;
 	const struct cred *saved_cred;
 	ssize_t ret;
-	bool locked;
+	bool threadgroup_locked;
 
 	dst_cgrp = cgroup_kn_lock_live(of->kn, false);
 	if (!dst_cgrp)
 		return -ENODEV;
 
-	task = cgroup_procs_write_start(buf, threadgroup, &locked);
+	task = cgroup_procs_write_start(buf, threadgroup, &threadgroup_locked);
 	ret = PTR_ERR_OR_ZERO(task);
 	if (ret)
 		goto out_unlock;
@@ -4964,7 +5005,7 @@ static ssize_t __cgroup_procs_write(struct kernfs_open_file *of, char *buf,
 	ret = cgroup_attach_task(dst_cgrp, task, threadgroup);
 
 out_finish:
-	cgroup_procs_write_finish(task, locked);
+	cgroup_procs_write_finish(task, threadgroup_locked);
 out_unlock:
 	cgroup_kn_unlock(of->kn);
 
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 9c5b659db63f..3213d3c8ea0a 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2249,7 +2249,7 @@ static void cpuset_attach(struct cgroup_taskset *tset)
 	cgroup_taskset_first(tset, &css);
 	cs = css_cs(css);
 
-	cpus_read_lock();
+	lockdep_assert_cpus_held();	/* see cgroup_attach_lock() */
 	percpu_down_write(&cpuset_rwsem);
 
 	guarantee_online_mems(cs, &cpuset_attach_nodemask_to);
@@ -2303,7 +2303,6 @@ static void cpuset_attach(struct cgroup_taskset *tset)
 		wake_up(&cpuset_attach_wq);
 
 	percpu_up_write(&cpuset_rwsem);
-	cpus_read_unlock();
 }
 
 /* The various types of files and directories in a cpuset file system */
diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index e62fb7a4da69..018f140aaaf4 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -435,7 +435,10 @@ static void swiotlb_bounce(struct device *dev, phys_addr_t tlb_addr, size_t size
 	}
 }
 
-#define slot_addr(start, idx)	((start) + ((idx) << IO_TLB_SHIFT))
+static inline phys_addr_t slot_addr(phys_addr_t start, phys_addr_t idx)
+{
+	return start + (idx << IO_TLB_SHIFT);
+}
 
 /*
  * Carefully handle integer overflow which can occur when boundary_mask == ~0UL.
diff --git a/kernel/fork.c b/kernel/fork.c
index 89475c994ca9..908ba3c93893 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1153,6 +1153,7 @@ void mmput_async(struct mm_struct *mm)
 		schedule_work(&mm->async_put_work);
 	}
 }
+EXPORT_SYMBOL_GPL(mmput_async);
 #endif
 
 /**
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index ed3f24a81549..9df585b9467e 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1561,6 +1561,7 @@ static int check_kprobe_address_safe(struct kprobe *p,
 	/* Ensure it is not in reserved area nor out of text */
 	if (!(core_kernel_text((unsigned long) p->addr) ||
 	    is_module_text_address((unsigned long) p->addr)) ||
+	    in_gate_area_no_mm((unsigned long) p->addr) ||
 	    within_kprobe_blacklist((unsigned long) p->addr) ||
 	    jump_label_text_reserved(p->addr, p->addr) ||
 	    static_call_text_reserved(p->addr, p->addr) ||
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 7a2d32d2025f..34c5ff3a0669 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -416,7 +416,7 @@ void update_sched_domain_debugfs(void)
 		char buf[32];
 
 		snprintf(buf, sizeof(buf), "cpu%d", cpu);
-		debugfs_remove(debugfs_lookup(buf, sd_dentry));
+		debugfs_lookup_and_remove(buf, sd_dentry);
 		d_cpu = debugfs_create_dir(buf, sd_dentry);
 
 		i = 0;
diff --git a/kernel/trace/trace_events_trigger.c b/kernel/trace/trace_events_trigger.c
index 67c7979c40c0..106f9813841a 100644
--- a/kernel/trace/trace_events_trigger.c
+++ b/kernel/trace/trace_events_trigger.c
@@ -128,7 +128,8 @@ static bool check_user_trigger(struct trace_event_file *file)
 {
 	struct event_trigger_data *data;
 
-	list_for_each_entry_rcu(data, &file->triggers, list) {
+	list_for_each_entry_rcu(data, &file->triggers, list,
+				lockdep_is_held(&event_mutex)) {
 		if (data->flags & EVENT_TRIGGER_FL_PROBE)
 			continue;
 		return true;
diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 859303aae180..b78861b8e013 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1125,7 +1125,7 @@ EXPORT_SYMBOL(kmemleak_no_scan);
 void __ref kmemleak_alloc_phys(phys_addr_t phys, size_t size, int min_count,
 			       gfp_t gfp)
 {
-	if (PHYS_PFN(phys) >= min_low_pfn && PHYS_PFN(phys) < max_low_pfn)
+	if (!IS_ENABLED(CONFIG_HIGHMEM) || PHYS_PFN(phys) < max_low_pfn)
 		kmemleak_alloc(__va(phys), size, min_count, gfp);
 }
 EXPORT_SYMBOL(kmemleak_alloc_phys);
@@ -1139,7 +1139,7 @@ EXPORT_SYMBOL(kmemleak_alloc_phys);
  */
 void __ref kmemleak_free_part_phys(phys_addr_t phys, size_t size)
 {
-	if (PHYS_PFN(phys) >= min_low_pfn && PHYS_PFN(phys) < max_low_pfn)
+	if (!IS_ENABLED(CONFIG_HIGHMEM) || PHYS_PFN(phys) < max_low_pfn)
 		kmemleak_free_part(__va(phys), size);
 }
 EXPORT_SYMBOL(kmemleak_free_part_phys);
@@ -1151,7 +1151,7 @@ EXPORT_SYMBOL(kmemleak_free_part_phys);
  */
 void __ref kmemleak_not_leak_phys(phys_addr_t phys)
 {
-	if (PHYS_PFN(phys) >= min_low_pfn && PHYS_PFN(phys) < max_low_pfn)
+	if (!IS_ENABLED(CONFIG_HIGHMEM) || PHYS_PFN(phys) < max_low_pfn)
 		kmemleak_not_leak(__va(phys));
 }
 EXPORT_SYMBOL(kmemleak_not_leak_phys);
@@ -1163,7 +1163,7 @@ EXPORT_SYMBOL(kmemleak_not_leak_phys);
  */
 void __ref kmemleak_ignore_phys(phys_addr_t phys)
 {
-	if (PHYS_PFN(phys) >= min_low_pfn && PHYS_PFN(phys) < max_low_pfn)
+	if (!IS_ENABLED(CONFIG_HIGHMEM) || PHYS_PFN(phys) < max_low_pfn)
 		kmemleak_ignore(__va(phys));
 }
 EXPORT_SYMBOL(kmemleak_ignore_phys);
diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index 10a2c7bca719..a718204c4bfd 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -384,6 +384,7 @@ static int br_nf_pre_routing_finish(struct net *net, struct sock *sk, struct sk_
 				/* - Bridged-and-DNAT'ed traffic doesn't
 				 *   require ip_forwarding. */
 				if (rt->dst.dev == dev) {
+					skb_dst_drop(skb);
 					skb_dst_set(skb, &rt->dst);
 					goto bridged_dnat;
 				}
@@ -413,6 +414,7 @@ static int br_nf_pre_routing_finish(struct net *net, struct sock *sk, struct sk_
 			kfree_skb(skb);
 			return 0;
 		}
+		skb_dst_drop(skb);
 		skb_dst_set_noref(skb, &rt->dst);
 	}
 
diff --git a/net/bridge/br_netfilter_ipv6.c b/net/bridge/br_netfilter_ipv6.c
index e4e0c836c3f5..6b07f30675bb 100644
--- a/net/bridge/br_netfilter_ipv6.c
+++ b/net/bridge/br_netfilter_ipv6.c
@@ -197,6 +197,7 @@ static int br_nf_pre_routing_finish_ipv6(struct net *net, struct sock *sk, struc
 			kfree_skb(skb);
 			return 0;
 		}
+		skb_dst_drop(skb);
 		skb_dst_set_noref(skb, &rt->dst);
 	}
 
diff --git a/net/core/datagram.c b/net/core/datagram.c
index 15ab9ffb27fe..28e5f921dcaf 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -677,7 +677,7 @@ int __zerocopy_sg_from_iter(struct sock *sk, struct sk_buff *skb,
 				page_ref_sub(last_head, refs);
 				refs = 0;
 			}
-			skb_fill_page_desc(skb, frag++, head, start, size);
+			skb_fill_page_desc_noacc(skb, frag++, head, start, size);
 		}
 		if (refs)
 			page_ref_sub(last_head, refs);
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 563848242ad3..3c193e7d4bc6 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4188,9 +4188,8 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
 				SKB_GSO_CB(nskb)->csum_start =
 					skb_headroom(nskb) + doffset;
 			} else {
-				skb_copy_bits(head_skb, offset,
-					      skb_put(nskb, len),
-					      len);
+				if (skb_copy_bits(head_skb, offset, skb_put(nskb, len), len))
+					goto err;
 			}
 			continue;
 		}
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 0ebef2a5950c..4f6b897ccf23 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1002,7 +1002,7 @@ struct sk_buff *tcp_build_frag(struct sock *sk, int size_goal, int flags,
 		skb_frag_size_add(&skb_shinfo(skb)->frags[i - 1], copy);
 	} else {
 		get_page(page);
-		skb_fill_page_desc(skb, i, page, offset, copy);
+		skb_fill_page_desc_noacc(skb, i, page, offset, copy);
 	}
 
 	if (!(flags & MSG_NO_SHARED_FRAGS))
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 7fd7e7cba0c9..686e210d89c2 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2506,6 +2506,21 @@ static inline bool tcp_may_undo(const struct tcp_sock *tp)
 	return tp->undo_marker && (!tp->undo_retrans || tcp_packet_delayed(tp));
 }
 
+static bool tcp_is_non_sack_preventing_reopen(struct sock *sk)
+{
+	struct tcp_sock *tp = tcp_sk(sk);
+
+	if (tp->snd_una == tp->high_seq && tcp_is_reno(tp)) {
+		/* Hold old state until something *above* high_seq
+		 * is ACKed. For Reno it is MUST to prevent false
+		 * fast retransmits (RFC2582). SACK TCP is safe. */
+		if (!tcp_any_retrans_done(sk))
+			tp->retrans_stamp = 0;
+		return true;
+	}
+	return false;
+}
+
 /* People celebrate: "We love our President!" */
 static bool tcp_try_undo_recovery(struct sock *sk)
 {
@@ -2528,14 +2543,8 @@ static bool tcp_try_undo_recovery(struct sock *sk)
 	} else if (tp->rack.reo_wnd_persist) {
 		tp->rack.reo_wnd_persist--;
 	}
-	if (tp->snd_una == tp->high_seq && tcp_is_reno(tp)) {
-		/* Hold old state until something *above* high_seq
-		 * is ACKed. For Reno it is MUST to prevent false
-		 * fast retransmits (RFC2582). SACK TCP is safe. */
-		if (!tcp_any_retrans_done(sk))
-			tp->retrans_stamp = 0;
+	if (tcp_is_non_sack_preventing_reopen(sk))
 		return true;
-	}
 	tcp_set_ca_state(sk, TCP_CA_Open);
 	tp->is_sack_reneg = 0;
 	return false;
@@ -2571,6 +2580,8 @@ static bool tcp_try_undo_loss(struct sock *sk, bool frto_undo)
 			NET_INC_STATS(sock_net(sk),
 					LINUX_MIB_TCPSPURIOUSRTOS);
 		inet_csk(sk)->icsk_retransmits = 0;
+		if (tcp_is_non_sack_preventing_reopen(sk))
+			return true;
 		if (frto_undo || tcp_is_sack(tp)) {
 			tcp_set_ca_state(sk, TCP_CA_Open);
 			tp->is_sack_reneg = 0;
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index efef7ba44e1d..75d1977ecc07 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -781,6 +781,8 @@ int __udp4_lib_err(struct sk_buff *skb, u32 info, struct udp_table *udptable)
 	 */
 	if (tunnel) {
 		/* ...not for tunnels though: we don't have a sending socket */
+		if (udp_sk(sk)->encap_err_rcv)
+			udp_sk(sk)->encap_err_rcv(sk, skb, iph->ihl << 2);
 		goto out;
 	}
 	if (!inet->recverr) {
diff --git a/net/ipv4/udp_tunnel_core.c b/net/ipv4/udp_tunnel_core.c
index b97e3635acf5..46101fd67a47 100644
--- a/net/ipv4/udp_tunnel_core.c
+++ b/net/ipv4/udp_tunnel_core.c
@@ -75,6 +75,7 @@ void setup_udp_tunnel_sock(struct net *net, struct socket *sock,
 
 	udp_sk(sk)->encap_type = cfg->encap_type;
 	udp_sk(sk)->encap_rcv = cfg->encap_rcv;
+	udp_sk(sk)->encap_err_rcv = cfg->encap_err_rcv;
 	udp_sk(sk)->encap_err_lookup = cfg->encap_err_lookup;
 	udp_sk(sk)->encap_destroy = cfg->encap_destroy;
 	udp_sk(sk)->gro_receive = cfg->gro_receive;
diff --git a/net/ipv6/seg6.c b/net/ipv6/seg6.c
index fa6b64c95d3a..0c7c6fc16c3c 100644
--- a/net/ipv6/seg6.c
+++ b/net/ipv6/seg6.c
@@ -191,6 +191,11 @@ static int seg6_genl_sethmac(struct sk_buff *skb, struct genl_info *info)
 		goto out_unlock;
 	}
 
+	if (slen > nla_len(info->attrs[SEG6_ATTR_SECRET])) {
+		err = -EINVAL;
+		goto out_unlock;
+	}
+
 	if (hinfo) {
 		err = seg6_hmac_info_del(net, hmackeyid);
 		if (err)
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 4a9afdbd5f29..07726a51a3f0 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -614,8 +614,11 @@ int __udp6_lib_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 	}
 
 	/* Tunnels don't have an application socket: don't pass errors back */
-	if (tunnel)
+	if (tunnel) {
+		if (udp_sk(sk)->encap_err_rcv)
+			udp_sk(sk)->encap_err_rcv(sk, skb, offset);
 		goto out;
+	}
 
 	if (!np->recverr) {
 		if (!harderr || sk->sk_state != TCP_ESTABLISHED)
diff --git a/net/netfilter/nf_conntrack_irc.c b/net/netfilter/nf_conntrack_irc.c
index 08ee4e760a3d..18b90e334b5b 100644
--- a/net/netfilter/nf_conntrack_irc.c
+++ b/net/netfilter/nf_conntrack_irc.c
@@ -188,8 +188,9 @@ static int help(struct sk_buff *skb, unsigned int protoff,
 
 			/* dcc_ip can be the internal OR external (NAT'ed) IP */
 			tuple = &ct->tuplehash[dir].tuple;
-			if (tuple->src.u3.ip != dcc_ip &&
-			    tuple->dst.u3.ip != dcc_ip) {
+			if ((tuple->src.u3.ip != dcc_ip &&
+			     ct->tuplehash[!dir].tuple.dst.u3.ip != dcc_ip) ||
+			    dcc_port == 0) {
 				net_warn_ratelimited("Forged DCC command from %pI4: %pI4:%u\n",
 						     &tuple->src.u3.ip,
 						     &dcc_ip, dcc_port);
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 3cee5d8ee702..1ecfdc4f23be 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -671,6 +671,37 @@ static bool tcp_in_window(struct nf_conn *ct,
 		    tn->tcp_be_liberal)
 			res = true;
 		if (!res) {
+			bool seq_ok = before(seq, sender->td_maxend + 1);
+
+			if (!seq_ok) {
+				u32 overshot = end - sender->td_maxend + 1;
+				bool ack_ok;
+
+				ack_ok = after(sack, receiver->td_end - MAXACKWINDOW(sender) - 1);
+
+				if (in_recv_win &&
+				    ack_ok &&
+				    overshot <= receiver->td_maxwin &&
+				    before(sack, receiver->td_end + 1)) {
+					/* Work around TCPs that send more bytes than allowed by
+					 * the receive window.
+					 *
+					 * If the (marked as invalid) packet is allowed to pass by
+					 * the ruleset and the peer acks this data, then its possible
+					 * all future packets will trigger 'ACK is over upper bound' check.
+					 *
+					 * Thus if only the sequence check fails then do update td_end so
+					 * possible ACK for this data can update internal state.
+					 */
+					sender->td_end = end;
+					sender->flags |= IP_CT_TCP_FLAG_DATA_UNACKNOWLEDGED;
+
+					nf_ct_l4proto_log_invalid(skb, ct, hook_state,
+								  "%u bytes more than expected", overshot);
+					return res;
+				}
+			}
+
 			nf_ct_l4proto_log_invalid(skb, ct, hook_state,
 			"%s",
 			before(seq, sender->td_maxend + 1) ?
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index d8ca55d6be40..d35d09df83fe 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2072,8 +2072,10 @@ static int nft_basechain_init(struct nft_base_chain *basechain, u8 family,
 	chain->flags |= NFT_CHAIN_BASE | flags;
 	basechain->policy = NF_ACCEPT;
 	if (chain->flags & NFT_CHAIN_HW_OFFLOAD &&
-	    !nft_chain_offload_support(basechain))
+	    !nft_chain_offload_support(basechain)) {
+		list_splice_init(&basechain->hook_list, &hook->list);
 		return -EOPNOTSUPP;
+	}
 
 	flow_block_init(&basechain->flow_block);
 
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index f2d593e27b64..f2e3fb77a02d 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -990,6 +990,7 @@ void rxrpc_send_keepalive(struct rxrpc_peer *);
 /*
  * peer_event.c
  */
+void rxrpc_encap_err_rcv(struct sock *sk, struct sk_buff *skb, unsigned int udp_offset);
 void rxrpc_error_report(struct sock *);
 void rxrpc_peer_keepalive_worker(struct work_struct *);
 
diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
index 6a1611b0e303..ef43fe8bdd2f 100644
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -137,6 +137,7 @@ static int rxrpc_open_socket(struct rxrpc_local *local, struct net *net)
 
 	tuncfg.encap_type = UDP_ENCAP_RXRPC;
 	tuncfg.encap_rcv = rxrpc_input_packet;
+	tuncfg.encap_err_rcv = rxrpc_encap_err_rcv;
 	tuncfg.sk_user_data = local;
 	setup_udp_tunnel_sock(net, local->socket, &tuncfg);
 
diff --git a/net/rxrpc/peer_event.c b/net/rxrpc/peer_event.c
index be032850ae8c..32561e9567fe 100644
--- a/net/rxrpc/peer_event.c
+++ b/net/rxrpc/peer_event.c
@@ -16,22 +16,105 @@
 #include <net/sock.h>
 #include <net/af_rxrpc.h>
 #include <net/ip.h>
+#include <net/icmp.h>
 #include "ar-internal.h"
 
+static void rxrpc_adjust_mtu(struct rxrpc_peer *, unsigned int);
 static void rxrpc_store_error(struct rxrpc_peer *, struct sock_exterr_skb *);
 static void rxrpc_distribute_error(struct rxrpc_peer *, int,
 				   enum rxrpc_call_completion);
 
 /*
- * Find the peer associated with an ICMP packet.
+ * Find the peer associated with an ICMPv4 packet.
  */
 static struct rxrpc_peer *rxrpc_lookup_peer_icmp_rcu(struct rxrpc_local *local,
-						     const struct sk_buff *skb,
+						     struct sk_buff *skb,
+						     unsigned int udp_offset,
+						     unsigned int *info,
 						     struct sockaddr_rxrpc *srx)
 {
-	struct sock_exterr_skb *serr = SKB_EXT_ERR(skb);
+	struct iphdr *ip, *ip0 = ip_hdr(skb);
+	struct icmphdr *icmp = icmp_hdr(skb);
+	struct udphdr *udp = (struct udphdr *)(skb->data + udp_offset);
 
-	_enter("");
+	_enter("%u,%u,%u", ip0->protocol, icmp->type, icmp->code);
+
+	switch (icmp->type) {
+	case ICMP_DEST_UNREACH:
+		*info = ntohs(icmp->un.frag.mtu);
+		fallthrough;
+	case ICMP_TIME_EXCEEDED:
+	case ICMP_PARAMETERPROB:
+		ip = (struct iphdr *)((void *)icmp + 8);
+		break;
+	default:
+		return NULL;
+	}
+
+	memset(srx, 0, sizeof(*srx));
+	srx->transport_type = local->srx.transport_type;
+	srx->transport_len = local->srx.transport_len;
+	srx->transport.family = local->srx.transport.family;
+
+	/* Can we see an ICMP4 packet on an ICMP6 listening socket?  and vice
+	 * versa?
+	 */
+	switch (srx->transport.family) {
+	case AF_INET:
+		srx->transport_len = sizeof(srx->transport.sin);
+		srx->transport.family = AF_INET;
+		srx->transport.sin.sin_port = udp->dest;
+		memcpy(&srx->transport.sin.sin_addr, &ip->daddr,
+		       sizeof(struct in_addr));
+		break;
+
+#ifdef CONFIG_AF_RXRPC_IPV6
+	case AF_INET6:
+		srx->transport_len = sizeof(srx->transport.sin);
+		srx->transport.family = AF_INET;
+		srx->transport.sin.sin_port = udp->dest;
+		memcpy(&srx->transport.sin.sin_addr, &ip->daddr,
+		       sizeof(struct in_addr));
+		break;
+#endif
+
+	default:
+		WARN_ON_ONCE(1);
+		return NULL;
+	}
+
+	_net("ICMP {%pISp}", &srx->transport);
+	return rxrpc_lookup_peer_rcu(local, srx);
+}
+
+#ifdef CONFIG_AF_RXRPC_IPV6
+/*
+ * Find the peer associated with an ICMPv6 packet.
+ */
+static struct rxrpc_peer *rxrpc_lookup_peer_icmp6_rcu(struct rxrpc_local *local,
+						      struct sk_buff *skb,
+						      unsigned int udp_offset,
+						      unsigned int *info,
+						      struct sockaddr_rxrpc *srx)
+{
+	struct icmp6hdr *icmp = icmp6_hdr(skb);
+	struct ipv6hdr *ip, *ip0 = ipv6_hdr(skb);
+	struct udphdr *udp = (struct udphdr *)(skb->data + udp_offset);
+
+	_enter("%u,%u,%u", ip0->nexthdr, icmp->icmp6_type, icmp->icmp6_code);
+
+	switch (icmp->icmp6_type) {
+	case ICMPV6_DEST_UNREACH:
+		*info = ntohl(icmp->icmp6_mtu);
+		fallthrough;
+	case ICMPV6_PKT_TOOBIG:
+	case ICMPV6_TIME_EXCEED:
+	case ICMPV6_PARAMPROB:
+		ip = (struct ipv6hdr *)((void *)icmp + 8);
+		break;
+	default:
+		return NULL;
+	}
 
 	memset(srx, 0, sizeof(*srx));
 	srx->transport_type = local->srx.transport_type;
@@ -41,6 +124,165 @@ static struct rxrpc_peer *rxrpc_lookup_peer_icmp_rcu(struct rxrpc_local *local,
 	/* Can we see an ICMP4 packet on an ICMP6 listening socket?  and vice
 	 * versa?
 	 */
+	switch (srx->transport.family) {
+	case AF_INET:
+		_net("Rx ICMP6 on v4 sock");
+		srx->transport_len = sizeof(srx->transport.sin);
+		srx->transport.family = AF_INET;
+		srx->transport.sin.sin_port = udp->dest;
+		memcpy(&srx->transport.sin.sin_addr,
+		       &ip->daddr.s6_addr32[3], sizeof(struct in_addr));
+		break;
+	case AF_INET6:
+		_net("Rx ICMP6");
+		srx->transport.sin.sin_port = udp->dest;
+		memcpy(&srx->transport.sin6.sin6_addr, &ip->daddr,
+		       sizeof(struct in6_addr));
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		return NULL;
+	}
+
+	_net("ICMP {%pISp}", &srx->transport);
+	return rxrpc_lookup_peer_rcu(local, srx);
+}
+#endif /* CONFIG_AF_RXRPC_IPV6 */
+
+/*
+ * Handle an error received on the local endpoint as a tunnel.
+ */
+void rxrpc_encap_err_rcv(struct sock *sk, struct sk_buff *skb,
+			 unsigned int udp_offset)
+{
+	struct sock_extended_err ee;
+	struct sockaddr_rxrpc srx;
+	struct rxrpc_local *local;
+	struct rxrpc_peer *peer;
+	unsigned int info = 0;
+	int err;
+	u8 version = ip_hdr(skb)->version;
+	u8 type = icmp_hdr(skb)->type;
+	u8 code = icmp_hdr(skb)->code;
+
+	rcu_read_lock();
+	local = rcu_dereference_sk_user_data(sk);
+	if (unlikely(!local)) {
+		rcu_read_unlock();
+		return;
+	}
+
+	rxrpc_new_skb(skb, rxrpc_skb_received);
+
+	switch (ip_hdr(skb)->version) {
+	case IPVERSION:
+		peer = rxrpc_lookup_peer_icmp_rcu(local, skb, udp_offset,
+						  &info, &srx);
+		break;
+#ifdef CONFIG_AF_RXRPC_IPV6
+	case 6:
+		peer = rxrpc_lookup_peer_icmp6_rcu(local, skb, udp_offset,
+						   &info, &srx);
+		break;
+#endif
+	default:
+		rcu_read_unlock();
+		return;
+	}
+
+	if (peer && !rxrpc_get_peer_maybe(peer))
+		peer = NULL;
+	if (!peer) {
+		rcu_read_unlock();
+		return;
+	}
+
+	memset(&ee, 0, sizeof(ee));
+
+	switch (version) {
+	case IPVERSION:
+		switch (type) {
+		case ICMP_DEST_UNREACH:
+			switch (code) {
+			case ICMP_FRAG_NEEDED:
+				rxrpc_adjust_mtu(peer, info);
+				rcu_read_unlock();
+				rxrpc_put_peer(peer);
+				return;
+			default:
+				break;
+			}
+
+			err = EHOSTUNREACH;
+			if (code <= NR_ICMP_UNREACH) {
+				/* Might want to do something different with
+				 * non-fatal errors
+				 */
+				//harderr = icmp_err_convert[code].fatal;
+				err = icmp_err_convert[code].errno;
+			}
+			break;
+
+		case ICMP_TIME_EXCEEDED:
+			err = EHOSTUNREACH;
+			break;
+		default:
+			err = EPROTO;
+			break;
+		}
+
+		ee.ee_origin = SO_EE_ORIGIN_ICMP;
+		ee.ee_type = type;
+		ee.ee_code = code;
+		ee.ee_errno = err;
+		break;
+
+#ifdef CONFIG_AF_RXRPC_IPV6
+	case 6:
+		switch (type) {
+		case ICMPV6_PKT_TOOBIG:
+			rxrpc_adjust_mtu(peer, info);
+			rcu_read_unlock();
+			rxrpc_put_peer(peer);
+			return;
+		}
+
+		icmpv6_err_convert(type, code, &err);
+
+		if (err == EACCES)
+			err = EHOSTUNREACH;
+
+		ee.ee_origin = SO_EE_ORIGIN_ICMP6;
+		ee.ee_type = type;
+		ee.ee_code = code;
+		ee.ee_errno = err;
+		break;
+#endif
+	}
+
+	trace_rxrpc_rx_icmp(peer, &ee, &srx);
+
+	rxrpc_distribute_error(peer, err, RXRPC_CALL_NETWORK_ERROR);
+	rcu_read_unlock();
+	rxrpc_put_peer(peer);
+}
+
+/*
+ * Find the peer associated with a local error.
+ */
+static struct rxrpc_peer *rxrpc_lookup_peer_local_rcu(struct rxrpc_local *local,
+						      const struct sk_buff *skb,
+						      struct sockaddr_rxrpc *srx)
+{
+	struct sock_exterr_skb *serr = SKB_EXT_ERR(skb);
+
+	_enter("");
+
+	memset(srx, 0, sizeof(*srx));
+	srx->transport_type = local->srx.transport_type;
+	srx->transport_len = local->srx.transport_len;
+	srx->transport.family = local->srx.transport.family;
+
 	switch (srx->transport.family) {
 	case AF_INET:
 		srx->transport_len = sizeof(srx->transport.sin);
@@ -104,10 +346,8 @@ static struct rxrpc_peer *rxrpc_lookup_peer_icmp_rcu(struct rxrpc_local *local,
 /*
  * Handle an MTU/fragmentation problem.
  */
-static void rxrpc_adjust_mtu(struct rxrpc_peer *peer, struct sock_exterr_skb *serr)
+static void rxrpc_adjust_mtu(struct rxrpc_peer *peer, unsigned int mtu)
 {
-	u32 mtu = serr->ee.ee_info;
-
 	_net("Rx ICMP Fragmentation Needed (%d)", mtu);
 
 	/* wind down the local interface MTU */
@@ -148,7 +388,7 @@ void rxrpc_error_report(struct sock *sk)
 	struct sock_exterr_skb *serr;
 	struct sockaddr_rxrpc srx;
 	struct rxrpc_local *local;
-	struct rxrpc_peer *peer;
+	struct rxrpc_peer *peer = NULL;
 	struct sk_buff *skb;
 
 	rcu_read_lock();
@@ -172,41 +412,20 @@ void rxrpc_error_report(struct sock *sk)
 	}
 	rxrpc_new_skb(skb, rxrpc_skb_received);
 	serr = SKB_EXT_ERR(skb);
-	if (!skb->len && serr->ee.ee_origin == SO_EE_ORIGIN_TIMESTAMPING) {
-		_leave("UDP empty message");
-		rcu_read_unlock();
-		rxrpc_free_skb(skb, rxrpc_skb_freed);
-		return;
-	}
 
-	peer = rxrpc_lookup_peer_icmp_rcu(local, skb, &srx);
-	if (peer && !rxrpc_get_peer_maybe(peer))
-		peer = NULL;
-	if (!peer) {
-		rcu_read_unlock();
-		rxrpc_free_skb(skb, rxrpc_skb_freed);
-		_leave(" [no peer]");
-		return;
-	}
-
-	trace_rxrpc_rx_icmp(peer, &serr->ee, &srx);
-
-	if ((serr->ee.ee_origin == SO_EE_ORIGIN_ICMP &&
-	     serr->ee.ee_type == ICMP_DEST_UNREACH &&
-	     serr->ee.ee_code == ICMP_FRAG_NEEDED)) {
-		rxrpc_adjust_mtu(peer, serr);
-		rcu_read_unlock();
-		rxrpc_free_skb(skb, rxrpc_skb_freed);
-		rxrpc_put_peer(peer);
-		_leave(" [MTU update]");
-		return;
+	if (serr->ee.ee_origin == SO_EE_ORIGIN_LOCAL) {
+		peer = rxrpc_lookup_peer_local_rcu(local, skb, &srx);
+		if (peer && !rxrpc_get_peer_maybe(peer))
+			peer = NULL;
+		if (peer) {
+			trace_rxrpc_rx_icmp(peer, &serr->ee, &srx);
+			rxrpc_store_error(peer, serr);
+		}
 	}
 
-	rxrpc_store_error(peer, serr);
 	rcu_read_unlock();
 	rxrpc_free_skb(skb, rxrpc_skb_freed);
 	rxrpc_put_peer(peer);
-
 	_leave("");
 }
 
diff --git a/net/rxrpc/rxkad.c b/net/rxrpc/rxkad.c
index 08aab5c01437..db47844f4ac9 100644
--- a/net/rxrpc/rxkad.c
+++ b/net/rxrpc/rxkad.c
@@ -540,7 +540,7 @@ static int rxkad_verify_packet_2(struct rxrpc_call *call, struct sk_buff *skb,
 	 * directly into the target buffer.
 	 */
 	sg = _sg;
-	nsg = skb_shinfo(skb)->nr_frags;
+	nsg = skb_shinfo(skb)->nr_frags + 1;
 	if (nsg <= 4) {
 		nsg = 4;
 	} else {
diff --git a/net/sched/sch_sfb.c b/net/sched/sch_sfb.c
index 3d061a13d7ed..2829455211f8 100644
--- a/net/sched/sch_sfb.c
+++ b/net/sched/sch_sfb.c
@@ -135,15 +135,15 @@ static void increment_one_qlen(u32 sfbhash, u32 slot, struct sfb_sched_data *q)
 	}
 }
 
-static void increment_qlen(const struct sk_buff *skb, struct sfb_sched_data *q)
+static void increment_qlen(const struct sfb_skb_cb *cb, struct sfb_sched_data *q)
 {
 	u32 sfbhash;
 
-	sfbhash = sfb_hash(skb, 0);
+	sfbhash = cb->hashes[0];
 	if (sfbhash)
 		increment_one_qlen(sfbhash, 0, q);
 
-	sfbhash = sfb_hash(skb, 1);
+	sfbhash = cb->hashes[1];
 	if (sfbhash)
 		increment_one_qlen(sfbhash, 1, q);
 }
@@ -281,8 +281,10 @@ static int sfb_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 {
 
 	struct sfb_sched_data *q = qdisc_priv(sch);
+	unsigned int len = qdisc_pkt_len(skb);
 	struct Qdisc *child = q->qdisc;
 	struct tcf_proto *fl;
+	struct sfb_skb_cb cb;
 	int i;
 	u32 p_min = ~0;
 	u32 minqlen = ~0;
@@ -399,11 +401,12 @@ static int sfb_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	}
 
 enqueue:
+	memcpy(&cb, sfb_skb_cb(skb), sizeof(cb));
 	ret = qdisc_enqueue(skb, child, to_free);
 	if (likely(ret == NET_XMIT_SUCCESS)) {
-		qdisc_qstats_backlog_inc(sch, skb);
+		sch->qstats.backlog += len;
 		sch->q.qlen++;
-		increment_qlen(skb, q);
+		increment_qlen(&cb, q);
 	} else if (net_xmit_drop_count(ret)) {
 		q->stats.childdrop++;
 		qdisc_qstats_drop(sch);
diff --git a/net/tipc/monitor.c b/net/tipc/monitor.c
index 2f4d23238a7e..9618e4429f0f 100644
--- a/net/tipc/monitor.c
+++ b/net/tipc/monitor.c
@@ -160,7 +160,7 @@ static void map_set(u64 *up_map, int i, unsigned int v)
 
 static int map_get(u64 up_map, int i)
 {
-	return (up_map & (1 << i)) >> i;
+	return (up_map & (1ULL << i)) >> i;
 }
 
 static struct tipc_peer *peer_prev(struct tipc_peer *peer)
diff --git a/sound/core/oss/pcm_oss.c b/sound/core/oss/pcm_oss.c
index f158f0abd25d..ca4a692fe1c3 100644
--- a/sound/core/oss/pcm_oss.c
+++ b/sound/core/oss/pcm_oss.c
@@ -1664,14 +1664,14 @@ static int snd_pcm_oss_sync(struct snd_pcm_oss_file *pcm_oss_file)
 		runtime = substream->runtime;
 		if (atomic_read(&substream->mmap_count))
 			goto __direct;
-		err = snd_pcm_oss_make_ready(substream);
-		if (err < 0)
-			return err;
 		atomic_inc(&runtime->oss.rw_ref);
 		if (mutex_lock_interruptible(&runtime->oss.params_lock)) {
 			atomic_dec(&runtime->oss.rw_ref);
 			return -ERESTARTSYS;
 		}
+		err = snd_pcm_oss_make_ready_locked(substream);
+		if (err < 0)
+			goto unlock;
 		format = snd_pcm_oss_format_from(runtime->oss.format);
 		width = snd_pcm_format_physical_width(format);
 		if (runtime->oss.buffer_used > 0) {
diff --git a/sound/drivers/aloop.c b/sound/drivers/aloop.c
index 9b4a7cdb103a..12f12a294df5 100644
--- a/sound/drivers/aloop.c
+++ b/sound/drivers/aloop.c
@@ -605,17 +605,18 @@ static unsigned int loopback_jiffies_timer_pos_update
 			cable->streams[SNDRV_PCM_STREAM_PLAYBACK];
 	struct loopback_pcm *dpcm_capt =
 			cable->streams[SNDRV_PCM_STREAM_CAPTURE];
-	unsigned long delta_play = 0, delta_capt = 0;
+	unsigned long delta_play = 0, delta_capt = 0, cur_jiffies;
 	unsigned int running, count1, count2;
 
+	cur_jiffies = jiffies;
 	running = cable->running ^ cable->pause;
 	if (running & (1 << SNDRV_PCM_STREAM_PLAYBACK)) {
-		delta_play = jiffies - dpcm_play->last_jiffies;
+		delta_play = cur_jiffies - dpcm_play->last_jiffies;
 		dpcm_play->last_jiffies += delta_play;
 	}
 
 	if (running & (1 << SNDRV_PCM_STREAM_CAPTURE)) {
-		delta_capt = jiffies - dpcm_capt->last_jiffies;
+		delta_capt = cur_jiffies - dpcm_capt->last_jiffies;
 		dpcm_capt->last_jiffies += delta_capt;
 	}
 
diff --git a/sound/pci/emu10k1/emupcm.c b/sound/pci/emu10k1/emupcm.c
index b2701a4452d8..48af77ae8020 100644
--- a/sound/pci/emu10k1/emupcm.c
+++ b/sound/pci/emu10k1/emupcm.c
@@ -124,7 +124,7 @@ static int snd_emu10k1_pcm_channel_alloc(struct snd_emu10k1_pcm * epcm, int voic
 	epcm->voices[0]->epcm = epcm;
 	if (voices > 1) {
 		for (i = 1; i < voices; i++) {
-			epcm->voices[i] = &epcm->emu->voices[epcm->voices[0]->number + i];
+			epcm->voices[i] = &epcm->emu->voices[(epcm->voices[0]->number + i) % NUM_G];
 			epcm->voices[i]->epcm = epcm;
 		}
 	}
diff --git a/sound/soc/atmel/mchp-spdiftx.c b/sound/soc/atmel/mchp-spdiftx.c
index d24380046435..bcca1cf3cd7b 100644
--- a/sound/soc/atmel/mchp-spdiftx.c
+++ b/sound/soc/atmel/mchp-spdiftx.c
@@ -196,8 +196,7 @@ struct mchp_spdiftx_dev {
 	struct clk				*pclk;
 	struct clk				*gclk;
 	unsigned int				fmt;
-	const struct mchp_i2s_caps		*caps;
-	int					gclk_enabled:1;
+	unsigned int				gclk_enabled:1;
 };
 
 static inline int mchp_spdiftx_is_running(struct mchp_spdiftx_dev *dev)
@@ -766,8 +765,6 @@ static const struct of_device_id mchp_spdiftx_dt_ids[] = {
 MODULE_DEVICE_TABLE(of, mchp_spdiftx_dt_ids);
 static int mchp_spdiftx_probe(struct platform_device *pdev)
 {
-	struct device_node *np = pdev->dev.of_node;
-	const struct of_device_id *match;
 	struct mchp_spdiftx_dev *dev;
 	struct resource *mem;
 	struct regmap *regmap;
@@ -781,11 +778,6 @@ static int mchp_spdiftx_probe(struct platform_device *pdev)
 	if (!dev)
 		return -ENOMEM;
 
-	/* Get hardware capabilities. */
-	match = of_match_node(mchp_spdiftx_dt_ids, np);
-	if (match)
-		dev->caps = match->data;
-
 	/* Map I/O registers. */
 	base = devm_platform_get_and_ioremap_resource(pdev, 0, &mem);
 	if (IS_ERR(base))
diff --git a/sound/soc/qcom/sm8250.c b/sound/soc/qcom/sm8250.c
index fe8fd7367e21..e5190aa588c6 100644
--- a/sound/soc/qcom/sm8250.c
+++ b/sound/soc/qcom/sm8250.c
@@ -191,6 +191,7 @@ static int sm8250_platform_probe(struct platform_device *pdev)
 	if (!card)
 		return -ENOMEM;
 
+	card->owner = THIS_MODULE;
 	/* Allocate the private data */
 	data = devm_kzalloc(dev, sizeof(*data), GFP_KERNEL);
 	if (!data)
diff --git a/sound/usb/card.c b/sound/usb/card.c
index ff5f8de1bc54..713b84d8d42f 100644
--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -698,7 +698,7 @@ static bool check_delayed_register_option(struct snd_usb_audio *chip, int iface)
 		if (delayed_register[i] &&
 		    sscanf(delayed_register[i], "%x:%x", &id, &inum) == 2 &&
 		    id == chip->usb_id)
-			return inum != iface;
+			return iface < inum;
 	}
 
 	return false;
diff --git a/sound/usb/endpoint.c b/sound/usb/endpoint.c
index 743b8287cfcd..11fa7745c017 100644
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -731,7 +731,8 @@ bool snd_usb_endpoint_compatible(struct snd_usb_audio *chip,
  * The endpoint needs to be closed via snd_usb_endpoint_close() later.
  *
  * Note that this function doesn't configure the endpoint.  The substream
- * needs to set it up later via snd_usb_endpoint_configure().
+ * needs to set it up later via snd_usb_endpoint_set_params() and
+ * snd_usb_endpoint_prepare().
  */
 struct snd_usb_endpoint *
 snd_usb_endpoint_open(struct snd_usb_audio *chip,
@@ -1254,12 +1255,13 @@ static int sync_ep_set_params(struct snd_usb_endpoint *ep)
 /*
  * snd_usb_endpoint_set_params: configure an snd_usb_endpoint
  *
+ * It's called either from hw_params callback.
  * Determine the number of URBs to be used on this endpoint.
  * An endpoint must be configured before it can be started.
  * An endpoint that is already running can not be reconfigured.
  */
-static int snd_usb_endpoint_set_params(struct snd_usb_audio *chip,
-				       struct snd_usb_endpoint *ep)
+int snd_usb_endpoint_set_params(struct snd_usb_audio *chip,
+				struct snd_usb_endpoint *ep)
 {
 	const struct audioformat *fmt = ep->cur_audiofmt;
 	int err;
@@ -1315,18 +1317,18 @@ static int snd_usb_endpoint_set_params(struct snd_usb_audio *chip,
 }
 
 /*
- * snd_usb_endpoint_configure: Configure the endpoint
+ * snd_usb_endpoint_prepare: Prepare the endpoint
  *
  * This function sets up the EP to be fully usable state.
- * It's called either from hw_params or prepare callback.
+ * It's called either from prepare callback.
  * The function checks need_setup flag, and performs nothing unless needed,
  * so it's safe to call this multiple times.
  *
  * This returns zero if unchanged, 1 if the configuration has changed,
  * or a negative error code.
  */
-int snd_usb_endpoint_configure(struct snd_usb_audio *chip,
-			       struct snd_usb_endpoint *ep)
+int snd_usb_endpoint_prepare(struct snd_usb_audio *chip,
+			     struct snd_usb_endpoint *ep)
 {
 	bool iface_first;
 	int err = 0;
@@ -1348,9 +1350,6 @@ int snd_usb_endpoint_configure(struct snd_usb_audio *chip,
 			if (err < 0)
 				goto unlock;
 		}
-		err = snd_usb_endpoint_set_params(chip, ep);
-		if (err < 0)
-			goto unlock;
 		goto done;
 	}
 
@@ -1378,10 +1377,6 @@ int snd_usb_endpoint_configure(struct snd_usb_audio *chip,
 	if (err < 0)
 		goto unlock;
 
-	err = snd_usb_endpoint_set_params(chip, ep);
-	if (err < 0)
-		goto unlock;
-
 	err = snd_usb_select_mode_quirk(chip, ep->cur_audiofmt);
 	if (err < 0)
 		goto unlock;
diff --git a/sound/usb/endpoint.h b/sound/usb/endpoint.h
index 6a9af04cf175..e67ea28faa54 100644
--- a/sound/usb/endpoint.h
+++ b/sound/usb/endpoint.h
@@ -17,8 +17,10 @@ snd_usb_endpoint_open(struct snd_usb_audio *chip,
 		      bool is_sync_ep);
 void snd_usb_endpoint_close(struct snd_usb_audio *chip,
 			    struct snd_usb_endpoint *ep);
-int snd_usb_endpoint_configure(struct snd_usb_audio *chip,
-			       struct snd_usb_endpoint *ep);
+int snd_usb_endpoint_set_params(struct snd_usb_audio *chip,
+				struct snd_usb_endpoint *ep);
+int snd_usb_endpoint_prepare(struct snd_usb_audio *chip,
+			     struct snd_usb_endpoint *ep);
 int snd_usb_endpoint_get_clock_rate(struct snd_usb_audio *chip, int clock);
 
 bool snd_usb_endpoint_compatible(struct snd_usb_audio *chip,
diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index b6cd43c5ea3e..2d60e6d1f8df 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -443,17 +443,17 @@ static int configure_endpoints(struct snd_usb_audio *chip,
 		if (stop_endpoints(subs, false))
 			sync_pending_stops(subs);
 		if (subs->sync_endpoint) {
-			err = snd_usb_endpoint_configure(chip, subs->sync_endpoint);
+			err = snd_usb_endpoint_prepare(chip, subs->sync_endpoint);
 			if (err < 0)
 				return err;
 		}
-		err = snd_usb_endpoint_configure(chip, subs->data_endpoint);
+		err = snd_usb_endpoint_prepare(chip, subs->data_endpoint);
 		if (err < 0)
 			return err;
 		snd_usb_set_format_quirk(subs, subs->cur_audiofmt);
 	} else {
 		if (subs->sync_endpoint) {
-			err = snd_usb_endpoint_configure(chip, subs->sync_endpoint);
+			err = snd_usb_endpoint_prepare(chip, subs->sync_endpoint);
 			if (err < 0)
 				return err;
 		}
@@ -551,7 +551,13 @@ static int snd_usb_hw_params(struct snd_pcm_substream *substream,
 	subs->cur_audiofmt = fmt;
 	mutex_unlock(&chip->mutex);
 
-	ret = configure_endpoints(chip, subs);
+	if (subs->sync_endpoint) {
+		ret = snd_usb_endpoint_set_params(chip, subs->sync_endpoint);
+		if (ret < 0)
+			goto unlock;
+	}
+
+	ret = snd_usb_endpoint_set_params(chip, subs->data_endpoint);
 
  unlock:
 	if (ret < 0)
diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 9bfead5efc4c..5b4d8f5eade2 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1764,7 +1764,7 @@ bool snd_usb_registration_quirk(struct snd_usb_audio *chip, int iface)
 
 	for (q = registration_quirks; q->usb_id; q++)
 		if (chip->usb_id == q->usb_id)
-			return iface != q->interface;
+			return iface < q->interface;
 
 	/* Register as normal */
 	return false;
diff --git a/sound/usb/stream.c b/sound/usb/stream.c
index ceb93d798182..f10f4e6d3fb8 100644
--- a/sound/usb/stream.c
+++ b/sound/usb/stream.c
@@ -495,6 +495,10 @@ static int __snd_usb_add_audio_stream(struct snd_usb_audio *chip,
 			return 0;
 		}
 	}
+
+	if (chip->card->registered)
+		chip->need_delayed_register = true;
+
 	/* look for an empty stream */
 	list_for_each_entry(as, &chip->pcm_list, list) {
 		if (as->fmt_type != fp->fmt_type)
@@ -502,9 +506,6 @@ static int __snd_usb_add_audio_stream(struct snd_usb_audio *chip,
 		subs = &as->substream[stream];
 		if (subs->ep_num)
 			continue;
-		if (snd_device_get_state(chip->card, as->pcm) !=
-		    SNDRV_DEV_BUILD)
-			chip->need_delayed_register = true;
 		err = snd_pcm_new_stream(as->pcm, stream, 1);
 		if (err < 0)
 			return err;
@@ -1105,7 +1106,7 @@ static int __snd_usb_parse_audio_interface(struct snd_usb_audio *chip,
 	 * Dallas DS4201 workaround: It presents 5 altsettings, but the last
 	 * one misses syncpipe, and does not produce any sound.
 	 */
-	if (chip->usb_id == USB_ID(0x04fa, 0x4201))
+	if (chip->usb_id == USB_ID(0x04fa, 0x4201) && num >= 4)
 		num = 4;
 
 	for (i = 0; i < num; i++) {
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index cb3d81adf5ca..c6c40191933d 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -435,6 +435,9 @@ static int evsel__check_attr(struct evsel *evsel, struct perf_session *session)
 	struct perf_event_attr *attr = &evsel->core.attr;
 	bool allow_user_set;
 
+	if (evsel__is_dummy_event(evsel))
+		return 0;
+
 	if (perf_header__has_feat(&session->header, HEADER_STAT))
 		return 0;
 
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 44e40bad0e33..55a041329990 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -16,6 +16,7 @@
 #include "map_symbol.h"
 #include "branch.h"
 #include "mem-events.h"
+#include "path.h"
 #include "srcline.h"
 #include "symbol.h"
 #include "sort.h"
@@ -1407,7 +1408,7 @@ static int maps__set_modules_path_dir(struct maps *maps, const char *dir_name, i
 		struct stat st;
 
 		/*sshfs might return bad dent->d_type, so we have to stat*/
-		snprintf(path, sizeof(path), "%s/%s", dir_name, dent->d_name);
+		path__join(path, sizeof(path), dir_name, dent->d_name);
 		if (stat(path, &st))
 			continue;
 
