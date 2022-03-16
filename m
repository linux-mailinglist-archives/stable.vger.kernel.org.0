Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C275D4DB1A4
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 14:37:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348953AbiCPNio (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 09:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347832AbiCPNig (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 09:38:36 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E6A0483A6;
        Wed, 16 Mar 2022 06:37:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BA488CE1EEB;
        Wed, 16 Mar 2022 13:36:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EFD0C340E9;
        Wed, 16 Mar 2022 13:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647437817;
        bh=l6EyM416Qs6WiDDT2TR2BQHPiGHEsBSOWrFRnNDFvnU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gA1+qFSJ5Aq/bJXvSQwVtrQLh/OYH7pZYDqY6F9YqCj2uVcKiNjwAuNh04J02+8IF
         D9qdipG1YEOLYD3qLB6QdgzIx/GrgN9RAPN9p1/opARqPL53RSlnd48zTvJCwmh5cL
         pKI0J4XFsS81LrzgC54raGxGXP/tM1gU74SdkpGs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.29
Date:   Wed, 16 Mar 2022 14:36:42 +0100
Message-Id: <1647437802204231@kroah.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <164743780292174@kroah.com>
References: <164743780292174@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index ad64687080cf..5adb4865ffa0 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 28
+SUBLEVEL = 29
 EXTRAVERSION =
 NAME = Trick or Treat
 
diff --git a/arch/arm/boot/dts/aspeed-g6-pinctrl.dtsi b/arch/arm/boot/dts/aspeed-g6-pinctrl.dtsi
index 6dde51c2aed3..e4775bbceecc 100644
--- a/arch/arm/boot/dts/aspeed-g6-pinctrl.dtsi
+++ b/arch/arm/boot/dts/aspeed-g6-pinctrl.dtsi
@@ -118,7 +118,7 @@ pinctrl_fwspid_default: fwspid_default {
 	};
 
 	pinctrl_fwqspid_default: fwqspid_default {
-		function = "FWQSPID";
+		function = "FWSPID";
 		groups = "FWQSPID";
 	};
 
diff --git a/arch/arm/boot/dts/bcm2711.dtsi b/arch/arm/boot/dts/bcm2711.dtsi
index dff18fc9a906..21294f775a20 100644
--- a/arch/arm/boot/dts/bcm2711.dtsi
+++ b/arch/arm/boot/dts/bcm2711.dtsi
@@ -290,6 +290,7 @@ pixelvalve4: pixelvalve@7e216000 {
 
 		hvs: hvs@7e400000 {
 			compatible = "brcm,bcm2711-hvs";
+			reg = <0x7e400000 0x8000>;
 			interrupts = <GIC_SPI 97 IRQ_TYPE_LEVEL_HIGH>;
 		};
 
diff --git a/arch/arm/include/asm/spectre.h b/arch/arm/include/asm/spectre.h
index d1fa5607d3aa..85f9e538fb32 100644
--- a/arch/arm/include/asm/spectre.h
+++ b/arch/arm/include/asm/spectre.h
@@ -25,7 +25,13 @@ enum {
 	SPECTRE_V2_METHOD_LOOP8 = BIT(__SPECTRE_V2_METHOD_LOOP8),
 };
 
+#ifdef CONFIG_GENERIC_CPU_VULNERABILITIES
 void spectre_v2_update_state(unsigned int state, unsigned int methods);
+#else
+static inline void spectre_v2_update_state(unsigned int state,
+					   unsigned int methods)
+{}
+#endif
 
 int spectre_bhb_update_vectors(unsigned int method);
 
diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
index a0654ab1074f..46b697dfa4cf 100644
--- a/arch/arm/kernel/entry-armv.S
+++ b/arch/arm/kernel/entry-armv.S
@@ -1038,9 +1038,9 @@ vector_bhb_loop8_\name:
 
 	@ bhb workaround
 	mov	r0, #8
-1:	b	. + 4
+3:	b	. + 4
 	subs	r0, r0, #1
-	bne	1b
+	bne	3b
 	dsb
 	isb
 	b	2b
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index b68d5cbbeca6..1a18c9045773 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1053,9 +1053,6 @@ config HW_PERF_EVENTS
 	def_bool y
 	depends on ARM_PMU
 
-config ARCH_HAS_FILTER_PGPROT
-	def_bool y
-
 # Supported by clang >= 7.0
 config CC_HAVE_SHADOW_CALL_STACK
 	def_bool $(cc-option, -fsanitize=shadow-call-stack -ffixed-x18)
diff --git a/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts b/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
index 04da07ae4420..1cee26479bfe 100644
--- a/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
+++ b/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
@@ -18,6 +18,7 @@ / {
 
 	aliases {
 		spi0 = &spi0;
+		ethernet0 = &eth0;
 		ethernet1 = &eth1;
 		mmc0 = &sdhci0;
 		mmc1 = &sdhci1;
@@ -138,7 +139,9 @@ &pcie0 {
 	/*
 	 * U-Boot port for Turris Mox has a bug which always expects that "ranges" DT property
 	 * contains exactly 2 ranges with 3 (child) address cells, 2 (parent) address cells and
-	 * 2 size cells and also expects that the second range starts at 16 MB offset. If these
+	 * 2 size cells and also expects that the second range starts at 16 MB offset. Also it
+	 * expects that first range uses same address for PCI (child) and CPU (parent) cells (so
+	 * no remapping) and that this address is the lowest from all specified ranges. If these
 	 * conditions are not met then U-Boot crashes during loading kernel DTB file. PCIe address
 	 * space is 128 MB long, so the best split between MEM and IO is to use fixed 16 MB window
 	 * for IO and the rest 112 MB (64+32+16) for MEM, despite that maximal IO size is just 64 kB.
@@ -147,6 +150,9 @@ &pcie0 {
 	 * https://source.denx.de/u-boot/u-boot/-/commit/cb2ddb291ee6fcbddd6d8f4ff49089dfe580f5d7
 	 * https://source.denx.de/u-boot/u-boot/-/commit/c64ac3b3185aeb3846297ad7391fc6df8ecd73bf
 	 * https://source.denx.de/u-boot/u-boot/-/commit/4a82fca8e330157081fc132a591ebd99ba02ee33
+	 * Bug related to requirement of same child and parent addresses for first range is fixed
+	 * in U-Boot version 2022.04 by following commit:
+	 * https://source.denx.de/u-boot/u-boot/-/commit/1fd54253bca7d43d046bba4853fe5fafd034bc17
 	 */
 	#address-cells = <3>;
 	#size-cells = <2>;
diff --git a/arch/arm64/boot/dts/marvell/armada-37xx.dtsi b/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
index 9acc5d2b5a00..0adc194e46d1 100644
--- a/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
+++ b/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
@@ -497,7 +497,7 @@ pcie0: pcie@d0070000 {
 			 * (totaling 127 MiB) for MEM.
 			 */
 			ranges = <0x82000000 0 0xe8000000   0 0xe8000000   0 0x07f00000   /* Port 0 MEM */
-				  0x81000000 0 0xefff0000   0 0xefff0000   0 0x00010000>; /* Port 0 IO */
+				  0x81000000 0 0x00000000   0 0xefff0000   0 0x00010000>; /* Port 0 IO */
 			interrupt-map-mask = <0 0 0 7>;
 			interrupt-map = <0 0 0 1 &pcie_intc 0>,
 					<0 0 0 2 &pcie_intc 1>,
diff --git a/arch/arm64/boot/dts/qcom/sm8350.dtsi b/arch/arm64/boot/dts/qcom/sm8350.dtsi
index 296ffb0e9888..a8886adaaf37 100644
--- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi
@@ -35,6 +35,24 @@ sleep_clk: sleep-clk {
 			clock-frequency = <32000>;
 			#clock-cells = <0>;
 		};
+
+		ufs_phy_rx_symbol_0_clk: ufs-phy-rx-symbol-0 {
+			compatible = "fixed-clock";
+			clock-frequency = <1000>;
+			#clock-cells = <0>;
+		};
+
+		ufs_phy_rx_symbol_1_clk: ufs-phy-rx-symbol-1 {
+			compatible = "fixed-clock";
+			clock-frequency = <1000>;
+			#clock-cells = <0>;
+		};
+
+		ufs_phy_tx_symbol_0_clk: ufs-phy-tx-symbol-0 {
+			compatible = "fixed-clock";
+			clock-frequency = <1000>;
+			#clock-cells = <0>;
+		};
 	};
 
 	cpus {
@@ -443,8 +461,30 @@ gcc: clock-controller@100000 {
 			#clock-cells = <1>;
 			#reset-cells = <1>;
 			#power-domain-cells = <1>;
-			clock-names = "bi_tcxo", "sleep_clk";
-			clocks = <&rpmhcc RPMH_CXO_CLK>, <&sleep_clk>;
+			clock-names = "bi_tcxo",
+				      "sleep_clk",
+				      "pcie_0_pipe_clk",
+				      "pcie_1_pipe_clk",
+				      "ufs_card_rx_symbol_0_clk",
+				      "ufs_card_rx_symbol_1_clk",
+				      "ufs_card_tx_symbol_0_clk",
+				      "ufs_phy_rx_symbol_0_clk",
+				      "ufs_phy_rx_symbol_1_clk",
+				      "ufs_phy_tx_symbol_0_clk",
+				      "usb3_phy_wrapper_gcc_usb30_pipe_clk",
+				      "usb3_uni_phy_sec_gcc_usb30_pipe_clk";
+			clocks = <&rpmhcc RPMH_CXO_CLK>,
+				 <&sleep_clk>,
+				 <0>,
+				 <0>,
+				 <0>,
+				 <0>,
+				 <0>,
+				 <&ufs_phy_rx_symbol_0_clk>,
+				 <&ufs_phy_rx_symbol_1_clk>,
+				 <&ufs_phy_tx_symbol_0_clk>,
+				 <0>,
+				 <0>;
 		};
 
 		ipcc: mailbox@408000 {
@@ -1060,8 +1100,8 @@ ufs_mem_hc: ufshc@1d84000 {
 				<75000000 300000000>,
 				<0 0>,
 				<0 0>,
-				<75000000 300000000>,
-				<75000000 300000000>;
+				<0 0>,
+				<0 0>;
 			status = "disabled";
 		};
 
diff --git a/arch/arm64/include/asm/mte-kasan.h b/arch/arm64/include/asm/mte-kasan.h
index 26e013e540ae..592aabb25b0e 100644
--- a/arch/arm64/include/asm/mte-kasan.h
+++ b/arch/arm64/include/asm/mte-kasan.h
@@ -5,6 +5,7 @@
 #ifndef __ASM_MTE_KASAN_H
 #define __ASM_MTE_KASAN_H
 
+#include <asm/compiler.h>
 #include <asm/mte-def.h>
 
 #ifndef __ASSEMBLY__
diff --git a/arch/arm64/include/asm/pgtable-prot.h b/arch/arm64/include/asm/pgtable-prot.h
index 7032f04c8ac6..b1e1b74d993c 100644
--- a/arch/arm64/include/asm/pgtable-prot.h
+++ b/arch/arm64/include/asm/pgtable-prot.h
@@ -92,7 +92,7 @@ extern bool arm64_use_ng_mappings;
 #define __P001  PAGE_READONLY
 #define __P010  PAGE_READONLY
 #define __P011  PAGE_READONLY
-#define __P100  PAGE_EXECONLY
+#define __P100  PAGE_READONLY_EXEC	/* PAGE_EXECONLY if Enhanced PAN */
 #define __P101  PAGE_READONLY_EXEC
 #define __P110  PAGE_READONLY_EXEC
 #define __P111  PAGE_READONLY_EXEC
@@ -101,7 +101,7 @@ extern bool arm64_use_ng_mappings;
 #define __S001  PAGE_READONLY
 #define __S010  PAGE_SHARED
 #define __S011  PAGE_SHARED
-#define __S100  PAGE_EXECONLY
+#define __S100  PAGE_READONLY_EXEC	/* PAGE_EXECONLY if Enhanced PAN */
 #define __S101  PAGE_READONLY_EXEC
 #define __S110  PAGE_SHARED_EXEC
 #define __S111  PAGE_SHARED_EXEC
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 72f95c6a7051..08363d3cc1da 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1017,18 +1017,6 @@ static inline bool arch_wants_old_prefaulted_pte(void)
 }
 #define arch_wants_old_prefaulted_pte	arch_wants_old_prefaulted_pte
 
-static inline pgprot_t arch_filter_pgprot(pgprot_t prot)
-{
-	if (cpus_have_const_cap(ARM64_HAS_EPAN))
-		return prot;
-
-	if (pgprot_val(prot) != pgprot_val(PAGE_EXECONLY))
-		return prot;
-
-	return PAGE_READONLY_EXEC;
-}
-
-
 #endif /* !__ASSEMBLY__ */
 
 #endif /* __ASM_PGTABLE_H */
diff --git a/arch/arm64/mm/mmap.c b/arch/arm64/mm/mmap.c
index a38f54cd638c..77ada00280d9 100644
--- a/arch/arm64/mm/mmap.c
+++ b/arch/arm64/mm/mmap.c
@@ -7,8 +7,10 @@
 
 #include <linux/io.h>
 #include <linux/memblock.h>
+#include <linux/mm.h>
 #include <linux/types.h>
 
+#include <asm/cpufeature.h>
 #include <asm/page.h>
 
 /*
@@ -38,3 +40,18 @@ int valid_mmap_phys_addr_range(unsigned long pfn, size_t size)
 {
 	return !(((pfn << PAGE_SHIFT) + size) & ~PHYS_MASK);
 }
+
+static int __init adjust_protection_map(void)
+{
+	/*
+	 * With Enhanced PAN we can honour the execute-only permissions as
+	 * there is no PAN override with such mappings.
+	 */
+	if (cpus_have_const_cap(ARM64_HAS_EPAN)) {
+		protection_map[VM_EXEC] = PAGE_EXECONLY;
+		protection_map[VM_EXEC | VM_SHARED] = PAGE_EXECONLY;
+	}
+
+	return 0;
+}
+arch_initcall(adjust_protection_map);
diff --git a/arch/riscv/Kconfig.erratas b/arch/riscv/Kconfig.erratas
index b44d6ecdb46e..0aacd7052585 100644
--- a/arch/riscv/Kconfig.erratas
+++ b/arch/riscv/Kconfig.erratas
@@ -2,6 +2,7 @@ menu "CPU errata selection"
 
 config RISCV_ERRATA_ALTERNATIVE
 	bool "RISC-V alternative scheme"
+	depends on !XIP_KERNEL
 	default y
 	help
 	  This Kconfig allows the kernel to automatically patch the
diff --git a/arch/riscv/Kconfig.socs b/arch/riscv/Kconfig.socs
index 30676ebb16eb..46a534f04793 100644
--- a/arch/riscv/Kconfig.socs
+++ b/arch/riscv/Kconfig.socs
@@ -14,8 +14,8 @@ config SOC_SIFIVE
 	select CLK_SIFIVE
 	select CLK_SIFIVE_PRCI
 	select SIFIVE_PLIC
-	select RISCV_ERRATA_ALTERNATIVE
-	select ERRATA_SIFIVE
+	select RISCV_ERRATA_ALTERNATIVE if !XIP_KERNEL
+	select ERRATA_SIFIVE if !XIP_KERNEL
 	help
 	  This enables support for SiFive SoC platform hardware.
 
diff --git a/arch/riscv/boot/dts/canaan/k210.dtsi b/arch/riscv/boot/dts/canaan/k210.dtsi
index 5e8ca8142482..780416d489aa 100644
--- a/arch/riscv/boot/dts/canaan/k210.dtsi
+++ b/arch/riscv/boot/dts/canaan/k210.dtsi
@@ -113,7 +113,8 @@ plic0: interrupt-controller@c000000 {
 			compatible = "canaan,k210-plic", "sifive,plic-1.0.0";
 			reg = <0xC000000 0x4000000>;
 			interrupt-controller;
-			interrupts-extended = <&cpu0_intc 11 &cpu1_intc 11>;
+			interrupts-extended = <&cpu0_intc 11>, <&cpu0_intc 9>,
+					      <&cpu1_intc 11>, <&cpu1_intc 9>;
 			riscv,ndev = <65>;
 		};
 
diff --git a/arch/riscv/kernel/module.c b/arch/riscv/kernel/module.c
index 68a9e3d1fe16..4a48287513c3 100644
--- a/arch/riscv/kernel/module.c
+++ b/arch/riscv/kernel/module.c
@@ -13,6 +13,19 @@
 #include <linux/pgtable.h>
 #include <asm/sections.h>
 
+/*
+ * The auipc+jalr instruction pair can reach any PC-relative offset
+ * in the range [-2^31 - 2^11, 2^31 - 2^11)
+ */
+static bool riscv_insn_valid_32bit_offset(ptrdiff_t val)
+{
+#ifdef CONFIG_32BIT
+	return true;
+#else
+	return (-(1L << 31) - (1L << 11)) <= val && val < ((1L << 31) - (1L << 11));
+#endif
+}
+
 static int apply_r_riscv_32_rela(struct module *me, u32 *location, Elf_Addr v)
 {
 	if (v != (u32)v) {
@@ -95,7 +108,7 @@ static int apply_r_riscv_pcrel_hi20_rela(struct module *me, u32 *location,
 	ptrdiff_t offset = (void *)v - (void *)location;
 	s32 hi20;
 
-	if (offset != (s32)offset) {
+	if (!riscv_insn_valid_32bit_offset(offset)) {
 		pr_err(
 		  "%s: target %016llx can not be addressed by the 32-bit offset from PC = %p\n",
 		  me->name, (long long)v, location);
@@ -197,10 +210,9 @@ static int apply_r_riscv_call_plt_rela(struct module *me, u32 *location,
 				       Elf_Addr v)
 {
 	ptrdiff_t offset = (void *)v - (void *)location;
-	s32 fill_v = offset;
 	u32 hi20, lo12;
 
-	if (offset != fill_v) {
+	if (!riscv_insn_valid_32bit_offset(offset)) {
 		/* Only emit the plt entry if offset over 32-bit range */
 		if (IS_ENABLED(CONFIG_MODULE_SECTIONS)) {
 			offset = module_emit_plt_entry(me, v);
@@ -224,10 +236,9 @@ static int apply_r_riscv_call_rela(struct module *me, u32 *location,
 				   Elf_Addr v)
 {
 	ptrdiff_t offset = (void *)v - (void *)location;
-	s32 fill_v = offset;
 	u32 hi20, lo12;
 
-	if (offset != fill_v) {
+	if (!riscv_insn_valid_32bit_offset(offset)) {
 		pr_err(
 		  "%s: target %016llx can not be addressed by the 32-bit offset from PC = %p\n",
 		  me->name, (long long)v, location);
diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
index cd9dc0556e91..fefd343412c7 100644
--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -27,6 +27,7 @@
 #include <linux/blk-mq.h>
 #include <linux/ata.h>
 #include <linux/hdreg.h>
+#include <linux/major.h>
 #include <linux/cdrom.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 48afe96ae0f0..7c63a1911fae 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -12,6 +12,30 @@
 #include "encls.h"
 #include "sgx.h"
 
+/*
+ * Calculate byte offset of a PCMD struct associated with an enclave page. PCMD's
+ * follow right after the EPC data in the backing storage. In addition to the
+ * visible enclave pages, there's one extra page slot for SECS, before PCMD
+ * structs.
+ */
+static inline pgoff_t sgx_encl_get_backing_page_pcmd_offset(struct sgx_encl *encl,
+							    unsigned long page_index)
+{
+	pgoff_t epc_end_off = encl->size + sizeof(struct sgx_secs);
+
+	return epc_end_off + page_index * sizeof(struct sgx_pcmd);
+}
+
+/*
+ * Free a page from the backing storage in the given page index.
+ */
+static inline void sgx_encl_truncate_backing_page(struct sgx_encl *encl, unsigned long page_index)
+{
+	struct inode *inode = file_inode(encl->backing);
+
+	shmem_truncate_range(inode, PFN_PHYS(page_index), PFN_PHYS(page_index) + PAGE_SIZE - 1);
+}
+
 /*
  * ELDU: Load an EPC page as unblocked. For more info, see "OS Management of EPC
  * Pages" in the SDM.
@@ -22,9 +46,11 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
 {
 	unsigned long va_offset = encl_page->desc & SGX_ENCL_PAGE_VA_OFFSET_MASK;
 	struct sgx_encl *encl = encl_page->encl;
+	pgoff_t page_index, page_pcmd_off;
 	struct sgx_pageinfo pginfo;
 	struct sgx_backing b;
-	pgoff_t page_index;
+	bool pcmd_page_empty;
+	u8 *pcmd_page;
 	int ret;
 
 	if (secs_page)
@@ -32,14 +58,16 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
 	else
 		page_index = PFN_DOWN(encl->size);
 
+	page_pcmd_off = sgx_encl_get_backing_page_pcmd_offset(encl, page_index);
+
 	ret = sgx_encl_get_backing(encl, page_index, &b);
 	if (ret)
 		return ret;
 
 	pginfo.addr = encl_page->desc & PAGE_MASK;
 	pginfo.contents = (unsigned long)kmap_atomic(b.contents);
-	pginfo.metadata = (unsigned long)kmap_atomic(b.pcmd) +
-			  b.pcmd_offset;
+	pcmd_page = kmap_atomic(b.pcmd);
+	pginfo.metadata = (unsigned long)pcmd_page + b.pcmd_offset;
 
 	if (secs_page)
 		pginfo.secs = (u64)sgx_get_epc_virt_addr(secs_page);
@@ -55,11 +83,24 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
 		ret = -EFAULT;
 	}
 
-	kunmap_atomic((void *)(unsigned long)(pginfo.metadata - b.pcmd_offset));
+	memset(pcmd_page + b.pcmd_offset, 0, sizeof(struct sgx_pcmd));
+
+	/*
+	 * The area for the PCMD in the page was zeroed above.  Check if the
+	 * whole page is now empty meaning that all PCMD's have been zeroed:
+	 */
+	pcmd_page_empty = !memchr_inv(pcmd_page, 0, PAGE_SIZE);
+
+	kunmap_atomic(pcmd_page);
 	kunmap_atomic((void *)(unsigned long)pginfo.contents);
 
 	sgx_encl_put_backing(&b, false);
 
+	sgx_encl_truncate_backing_page(encl, page_index);
+
+	if (pcmd_page_empty)
+		sgx_encl_truncate_backing_page(encl, PFN_DOWN(page_pcmd_off));
+
 	return ret;
 }
 
@@ -579,7 +620,7 @@ static struct page *sgx_encl_get_backing_page(struct sgx_encl *encl,
 int sgx_encl_get_backing(struct sgx_encl *encl, unsigned long page_index,
 			 struct sgx_backing *backing)
 {
-	pgoff_t pcmd_index = PFN_DOWN(encl->size) + 1 + (page_index >> 5);
+	pgoff_t page_pcmd_off = sgx_encl_get_backing_page_pcmd_offset(encl, page_index);
 	struct page *contents;
 	struct page *pcmd;
 
@@ -587,7 +628,7 @@ int sgx_encl_get_backing(struct sgx_encl *encl, unsigned long page_index,
 	if (IS_ERR(contents))
 		return PTR_ERR(contents);
 
-	pcmd = sgx_encl_get_backing_page(encl, pcmd_index);
+	pcmd = sgx_encl_get_backing_page(encl, PFN_DOWN(page_pcmd_off));
 	if (IS_ERR(pcmd)) {
 		put_page(contents);
 		return PTR_ERR(pcmd);
@@ -596,9 +637,7 @@ int sgx_encl_get_backing(struct sgx_encl *encl, unsigned long page_index,
 	backing->page_index = page_index;
 	backing->contents = contents;
 	backing->pcmd = pcmd;
-	backing->pcmd_offset =
-		(page_index & (PAGE_SIZE / sizeof(struct sgx_pcmd) - 1)) *
-		sizeof(struct sgx_pcmd);
+	backing->pcmd_offset = page_pcmd_off & (PAGE_SIZE - 1);
 
 	return 0;
 }
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index bc0657f0deed..f267205f2d5a 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -995,8 +995,10 @@ early_param("memmap", parse_memmap_opt);
  */
 void __init e820__reserve_setup_data(void)
 {
+	struct setup_indirect *indirect;
 	struct setup_data *data;
-	u64 pa_data;
+	u64 pa_data, pa_next;
+	u32 len;
 
 	pa_data = boot_params.hdr.setup_data;
 	if (!pa_data)
@@ -1004,6 +1006,14 @@ void __init e820__reserve_setup_data(void)
 
 	while (pa_data) {
 		data = early_memremap(pa_data, sizeof(*data));
+		if (!data) {
+			pr_warn("e820: failed to memremap setup_data entry\n");
+			return;
+		}
+
+		len = sizeof(*data);
+		pa_next = data->next;
+
 		e820__range_update(pa_data, sizeof(*data)+data->len, E820_TYPE_RAM, E820_TYPE_RESERVED_KERN);
 
 		/*
@@ -1015,18 +1025,27 @@ void __init e820__reserve_setup_data(void)
 						 sizeof(*data) + data->len,
 						 E820_TYPE_RAM, E820_TYPE_RESERVED_KERN);
 
-		if (data->type == SETUP_INDIRECT &&
-		    ((struct setup_indirect *)data->data)->type != SETUP_INDIRECT) {
-			e820__range_update(((struct setup_indirect *)data->data)->addr,
-					   ((struct setup_indirect *)data->data)->len,
-					   E820_TYPE_RAM, E820_TYPE_RESERVED_KERN);
-			e820__range_update_kexec(((struct setup_indirect *)data->data)->addr,
-						 ((struct setup_indirect *)data->data)->len,
-						 E820_TYPE_RAM, E820_TYPE_RESERVED_KERN);
+		if (data->type == SETUP_INDIRECT) {
+			len += data->len;
+			early_memunmap(data, sizeof(*data));
+			data = early_memremap(pa_data, len);
+			if (!data) {
+				pr_warn("e820: failed to memremap indirect setup_data\n");
+				return;
+			}
+
+			indirect = (struct setup_indirect *)data->data;
+
+			if (indirect->type != SETUP_INDIRECT) {
+				e820__range_update(indirect->addr, indirect->len,
+						   E820_TYPE_RAM, E820_TYPE_RESERVED_KERN);
+				e820__range_update_kexec(indirect->addr, indirect->len,
+							 E820_TYPE_RAM, E820_TYPE_RESERVED_KERN);
+			}
 		}
 
-		pa_data = data->next;
-		early_memunmap(data, sizeof(*data));
+		pa_data = pa_next;
+		early_memunmap(data, len);
 	}
 
 	e820__update_table(e820_table);
diff --git a/arch/x86/kernel/kdebugfs.c b/arch/x86/kernel/kdebugfs.c
index 64b6da95af98..e2e89bebcbc3 100644
--- a/arch/x86/kernel/kdebugfs.c
+++ b/arch/x86/kernel/kdebugfs.c
@@ -88,11 +88,13 @@ create_setup_data_node(struct dentry *parent, int no,
 
 static int __init create_setup_data_nodes(struct dentry *parent)
 {
+	struct setup_indirect *indirect;
 	struct setup_data_node *node;
 	struct setup_data *data;
-	int error;
+	u64 pa_data, pa_next;
 	struct dentry *d;
-	u64 pa_data;
+	int error;
+	u32 len;
 	int no = 0;
 
 	d = debugfs_create_dir("setup_data", parent);
@@ -112,12 +114,29 @@ static int __init create_setup_data_nodes(struct dentry *parent)
 			error = -ENOMEM;
 			goto err_dir;
 		}
-
-		if (data->type == SETUP_INDIRECT &&
-		    ((struct setup_indirect *)data->data)->type != SETUP_INDIRECT) {
-			node->paddr = ((struct setup_indirect *)data->data)->addr;
-			node->type  = ((struct setup_indirect *)data->data)->type;
-			node->len   = ((struct setup_indirect *)data->data)->len;
+		pa_next = data->next;
+
+		if (data->type == SETUP_INDIRECT) {
+			len = sizeof(*data) + data->len;
+			memunmap(data);
+			data = memremap(pa_data, len, MEMREMAP_WB);
+			if (!data) {
+				kfree(node);
+				error = -ENOMEM;
+				goto err_dir;
+			}
+
+			indirect = (struct setup_indirect *)data->data;
+
+			if (indirect->type != SETUP_INDIRECT) {
+				node->paddr = indirect->addr;
+				node->type  = indirect->type;
+				node->len   = indirect->len;
+			} else {
+				node->paddr = pa_data;
+				node->type  = data->type;
+				node->len   = data->len;
+			}
 		} else {
 			node->paddr = pa_data;
 			node->type  = data->type;
@@ -125,7 +144,7 @@ static int __init create_setup_data_nodes(struct dentry *parent)
 		}
 
 		create_setup_data_node(d, no, node);
-		pa_data = data->next;
+		pa_data = pa_next;
 
 		memunmap(data);
 		no++;
diff --git a/arch/x86/kernel/ksysfs.c b/arch/x86/kernel/ksysfs.c
index d0a19121c6a4..257892fcefa7 100644
--- a/arch/x86/kernel/ksysfs.c
+++ b/arch/x86/kernel/ksysfs.c
@@ -91,26 +91,41 @@ static int get_setup_data_paddr(int nr, u64 *paddr)
 
 static int __init get_setup_data_size(int nr, size_t *size)
 {
-	int i = 0;
+	u64 pa_data = boot_params.hdr.setup_data, pa_next;
+	struct setup_indirect *indirect;
 	struct setup_data *data;
-	u64 pa_data = boot_params.hdr.setup_data;
+	int i = 0;
+	u32 len;
 
 	while (pa_data) {
 		data = memremap(pa_data, sizeof(*data), MEMREMAP_WB);
 		if (!data)
 			return -ENOMEM;
+		pa_next = data->next;
+
 		if (nr == i) {
-			if (data->type == SETUP_INDIRECT &&
-			    ((struct setup_indirect *)data->data)->type != SETUP_INDIRECT)
-				*size = ((struct setup_indirect *)data->data)->len;
-			else
+			if (data->type == SETUP_INDIRECT) {
+				len = sizeof(*data) + data->len;
+				memunmap(data);
+				data = memremap(pa_data, len, MEMREMAP_WB);
+				if (!data)
+					return -ENOMEM;
+
+				indirect = (struct setup_indirect *)data->data;
+
+				if (indirect->type != SETUP_INDIRECT)
+					*size = indirect->len;
+				else
+					*size = data->len;
+			} else {
 				*size = data->len;
+			}
 
 			memunmap(data);
 			return 0;
 		}
 
-		pa_data = data->next;
+		pa_data = pa_next;
 		memunmap(data);
 		i++;
 	}
@@ -120,9 +135,11 @@ static int __init get_setup_data_size(int nr, size_t *size)
 static ssize_t type_show(struct kobject *kobj,
 			 struct kobj_attribute *attr, char *buf)
 {
+	struct setup_indirect *indirect;
+	struct setup_data *data;
 	int nr, ret;
 	u64 paddr;
-	struct setup_data *data;
+	u32 len;
 
 	ret = kobj_to_setup_data_nr(kobj, &nr);
 	if (ret)
@@ -135,10 +152,20 @@ static ssize_t type_show(struct kobject *kobj,
 	if (!data)
 		return -ENOMEM;
 
-	if (data->type == SETUP_INDIRECT)
-		ret = sprintf(buf, "0x%x\n", ((struct setup_indirect *)data->data)->type);
-	else
+	if (data->type == SETUP_INDIRECT) {
+		len = sizeof(*data) + data->len;
+		memunmap(data);
+		data = memremap(paddr, len, MEMREMAP_WB);
+		if (!data)
+			return -ENOMEM;
+
+		indirect = (struct setup_indirect *)data->data;
+
+		ret = sprintf(buf, "0x%x\n", indirect->type);
+	} else {
 		ret = sprintf(buf, "0x%x\n", data->type);
+	}
+
 	memunmap(data);
 	return ret;
 }
@@ -149,9 +176,10 @@ static ssize_t setup_data_data_read(struct file *fp,
 				    char *buf,
 				    loff_t off, size_t count)
 {
+	struct setup_indirect *indirect;
+	struct setup_data *data;
 	int nr, ret = 0;
 	u64 paddr, len;
-	struct setup_data *data;
 	void *p;
 
 	ret = kobj_to_setup_data_nr(kobj, &nr);
@@ -165,10 +193,27 @@ static ssize_t setup_data_data_read(struct file *fp,
 	if (!data)
 		return -ENOMEM;
 
-	if (data->type == SETUP_INDIRECT &&
-	    ((struct setup_indirect *)data->data)->type != SETUP_INDIRECT) {
-		paddr = ((struct setup_indirect *)data->data)->addr;
-		len = ((struct setup_indirect *)data->data)->len;
+	if (data->type == SETUP_INDIRECT) {
+		len = sizeof(*data) + data->len;
+		memunmap(data);
+		data = memremap(paddr, len, MEMREMAP_WB);
+		if (!data)
+			return -ENOMEM;
+
+		indirect = (struct setup_indirect *)data->data;
+
+		if (indirect->type != SETUP_INDIRECT) {
+			paddr = indirect->addr;
+			len = indirect->len;
+		} else {
+			/*
+			 * Even though this is technically undefined, return
+			 * the data as though it is a normal setup_data struct.
+			 * This will at least allow it to be inspected.
+			 */
+			paddr += sizeof(*data);
+			len = data->len;
+		}
 	} else {
 		paddr += sizeof(*data);
 		len = data->len;
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index b656456c3a94..811c7aaf23aa 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -457,19 +457,22 @@ static bool pv_tlb_flush_supported(void)
 {
 	return (kvm_para_has_feature(KVM_FEATURE_PV_TLB_FLUSH) &&
 		!kvm_para_has_hint(KVM_HINTS_REALTIME) &&
-		kvm_para_has_feature(KVM_FEATURE_STEAL_TIME));
+		kvm_para_has_feature(KVM_FEATURE_STEAL_TIME) &&
+		(num_possible_cpus() != 1));
 }
 
 static bool pv_ipi_supported(void)
 {
-	return kvm_para_has_feature(KVM_FEATURE_PV_SEND_IPI);
+	return (kvm_para_has_feature(KVM_FEATURE_PV_SEND_IPI) &&
+	       (num_possible_cpus() != 1));
 }
 
 static bool pv_sched_yield_supported(void)
 {
 	return (kvm_para_has_feature(KVM_FEATURE_PV_SCHED_YIELD) &&
 		!kvm_para_has_hint(KVM_HINTS_REALTIME) &&
-	    kvm_para_has_feature(KVM_FEATURE_STEAL_TIME));
+	    kvm_para_has_feature(KVM_FEATURE_STEAL_TIME) &&
+	    (num_possible_cpus() != 1));
 }
 
 #define KVM_IPI_CLUSTER_SIZE	(2 * BITS_PER_LONG)
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 48596f9fddf4..8e56c4de00b9 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -368,21 +368,41 @@ static void __init parse_setup_data(void)
 
 static void __init memblock_x86_reserve_range_setup_data(void)
 {
+	struct setup_indirect *indirect;
 	struct setup_data *data;
-	u64 pa_data;
+	u64 pa_data, pa_next;
+	u32 len;
 
 	pa_data = boot_params.hdr.setup_data;
 	while (pa_data) {
 		data = early_memremap(pa_data, sizeof(*data));
+		if (!data) {
+			pr_warn("setup: failed to memremap setup_data entry\n");
+			return;
+		}
+
+		len = sizeof(*data);
+		pa_next = data->next;
+
 		memblock_reserve(pa_data, sizeof(*data) + data->len);
 
-		if (data->type == SETUP_INDIRECT &&
-		    ((struct setup_indirect *)data->data)->type != SETUP_INDIRECT)
-			memblock_reserve(((struct setup_indirect *)data->data)->addr,
-					 ((struct setup_indirect *)data->data)->len);
+		if (data->type == SETUP_INDIRECT) {
+			len += data->len;
+			early_memunmap(data, sizeof(*data));
+			data = early_memremap(pa_data, len);
+			if (!data) {
+				pr_warn("setup: failed to memremap indirect setup_data\n");
+				return;
+			}
 
-		pa_data = data->next;
-		early_memunmap(data, sizeof(*data));
+			indirect = (struct setup_indirect *)data->data;
+
+			if (indirect->type != SETUP_INDIRECT)
+				memblock_reserve(indirect->addr, indirect->len);
+		}
+
+		pa_data = pa_next;
+		early_memunmap(data, len);
 	}
 }
 
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 5b1984d46822..928e1ac820e6 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -659,6 +659,7 @@ static bool do_int3(struct pt_regs *regs)
 
 	return res == NOTIFY_STOP;
 }
+NOKPROBE_SYMBOL(do_int3);
 
 static void do_int3_user(struct pt_regs *regs)
 {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 2297dd90fe4a..d6579bae25ca 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3967,6 +3967,7 @@ static bool kvm_faultin_pfn(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
 
 	*pfn = __gfn_to_pfn_memslot(slot, gfn, false, NULL,
 				    write, writable, hva);
+	return false;
 
 out_retry:
 	*r = RET_PF_RETRY;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8213f7fb71a7..61bc54748f22 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8666,6 +8666,13 @@ static int kvm_pv_clock_pairing(struct kvm_vcpu *vcpu, gpa_t paddr,
 	if (clock_type != KVM_CLOCK_PAIRING_WALLCLOCK)
 		return -KVM_EOPNOTSUPP;
 
+	/*
+	 * When tsc is in permanent catchup mode guests won't be able to use
+	 * pvclock_read_retry loop to get consistent view of pvclock
+	 */
+	if (vcpu->arch.tsc_always_catchup)
+		return -KVM_EOPNOTSUPP;
+
 	if (!kvm_get_walltime_and_clockread(&ts, &cycle))
 		return -KVM_EOPNOTSUPP;
 
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 60ade7dd71bd..7ce9b8dd8757 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -614,6 +614,7 @@ static bool memremap_is_efi_data(resource_size_t phys_addr,
 static bool memremap_is_setup_data(resource_size_t phys_addr,
 				   unsigned long size)
 {
+	struct setup_indirect *indirect;
 	struct setup_data *data;
 	u64 paddr, paddr_next;
 
@@ -626,6 +627,10 @@ static bool memremap_is_setup_data(resource_size_t phys_addr,
 
 		data = memremap(paddr, sizeof(*data),
 				MEMREMAP_WB | MEMREMAP_DEC);
+		if (!data) {
+			pr_warn("failed to memremap setup_data entry\n");
+			return false;
+		}
 
 		paddr_next = data->next;
 		len = data->len;
@@ -635,10 +640,21 @@ static bool memremap_is_setup_data(resource_size_t phys_addr,
 			return true;
 		}
 
-		if (data->type == SETUP_INDIRECT &&
-		    ((struct setup_indirect *)data->data)->type != SETUP_INDIRECT) {
-			paddr = ((struct setup_indirect *)data->data)->addr;
-			len = ((struct setup_indirect *)data->data)->len;
+		if (data->type == SETUP_INDIRECT) {
+			memunmap(data);
+			data = memremap(paddr, sizeof(*data) + len,
+					MEMREMAP_WB | MEMREMAP_DEC);
+			if (!data) {
+				pr_warn("failed to memremap indirect setup_data\n");
+				return false;
+			}
+
+			indirect = (struct setup_indirect *)data->data;
+
+			if (indirect->type != SETUP_INDIRECT) {
+				paddr = indirect->addr;
+				len = indirect->len;
+			}
 		}
 
 		memunmap(data);
@@ -659,22 +675,51 @@ static bool memremap_is_setup_data(resource_size_t phys_addr,
 static bool __init early_memremap_is_setup_data(resource_size_t phys_addr,
 						unsigned long size)
 {
+	struct setup_indirect *indirect;
 	struct setup_data *data;
 	u64 paddr, paddr_next;
 
 	paddr = boot_params.hdr.setup_data;
 	while (paddr) {
-		unsigned int len;
+		unsigned int len, size;
 
 		if (phys_addr == paddr)
 			return true;
 
 		data = early_memremap_decrypted(paddr, sizeof(*data));
+		if (!data) {
+			pr_warn("failed to early memremap setup_data entry\n");
+			return false;
+		}
+
+		size = sizeof(*data);
 
 		paddr_next = data->next;
 		len = data->len;
 
-		early_memunmap(data, sizeof(*data));
+		if ((phys_addr > paddr) && (phys_addr < (paddr + len))) {
+			early_memunmap(data, sizeof(*data));
+			return true;
+		}
+
+		if (data->type == SETUP_INDIRECT) {
+			size += len;
+			early_memunmap(data, sizeof(*data));
+			data = early_memremap_decrypted(paddr, size);
+			if (!data) {
+				pr_warn("failed to early memremap indirect setup_data\n");
+				return false;
+			}
+
+			indirect = (struct setup_indirect *)data->data;
+
+			if (indirect->type != SETUP_INDIRECT) {
+				paddr = indirect->addr;
+				len = indirect->len;
+			}
+		}
+
+		early_memunmap(data, size);
 
 		if ((phys_addr > paddr) && (phys_addr < (paddr + len)))
 			return true;
diff --git a/block/genhd.c b/block/genhd.c
index 2dcedbe4ef04..0276a2846adf 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -19,6 +19,7 @@
 #include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/kmod.h>
+#include <linux/major.h>
 #include <linux/mutex.h>
 #include <linux/idr.h>
 #include <linux/log2.h>
diff --git a/block/holder.c b/block/holder.c
index 9dc084182337..27cddce1b446 100644
--- a/block/holder.c
+++ b/block/holder.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 #include <linux/genhd.h>
+#include <linux/slab.h>
 
 struct bd_holder_disk {
 	struct list_head	list;
diff --git a/block/partitions/core.c b/block/partitions/core.c
index 7bea19dd9458..b9e9af84f518 100644
--- a/block/partitions/core.c
+++ b/block/partitions/core.c
@@ -5,6 +5,7 @@
  * Copyright (C) 2020 Christoph Hellwig
  */
 #include <linux/fs.h>
+#include <linux/major.h>
 #include <linux/slab.h>
 #include <linux/ctype.h>
 #include <linux/genhd.h>
diff --git a/drivers/block/amiflop.c b/drivers/block/amiflop.c
index 8b1714021498..1ed557cb5ed2 100644
--- a/drivers/block/amiflop.c
+++ b/drivers/block/amiflop.c
@@ -61,6 +61,7 @@
 #include <linux/hdreg.h>
 #include <linux/delay.h>
 #include <linux/init.h>
+#include <linux/major.h>
 #include <linux/mutex.h>
 #include <linux/fs.h>
 #include <linux/blk-mq.h>
diff --git a/drivers/block/ataflop.c b/drivers/block/ataflop.c
index aab48b292a3b..82faaa458157 100644
--- a/drivers/block/ataflop.c
+++ b/drivers/block/ataflop.c
@@ -68,6 +68,7 @@
 #include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/blk-mq.h>
+#include <linux/major.h>
 #include <linux/mutex.h>
 #include <linux/completion.h>
 #include <linux/wait.h>
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 4a6a74177b3c..0f58594c5a4d 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -184,6 +184,7 @@ static int print_unex = 1;
 #include <linux/ioport.h>
 #include <linux/interrupt.h>
 #include <linux/init.h>
+#include <linux/major.h>
 #include <linux/platform_device.h>
 #include <linux/mod_devicetable.h>
 #include <linux/mutex.h>
diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index 7ccc8d2a41bc..3911d0833e1b 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -16,6 +16,7 @@
 #include <linux/fd.h>
 #include <linux/slab.h>
 #include <linux/blk-mq.h>
+#include <linux/major.h>
 #include <linux/mutex.h>
 #include <linux/hdreg.h>
 #include <linux/kernel.h>
diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 303caf2d17d0..f538bc9dce7d 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -859,9 +859,15 @@ static int virtblk_probe(struct virtio_device *vdev)
 
 		virtio_cread(vdev, struct virtio_blk_config, max_discard_seg,
 			     &v);
+
+		/*
+		 * max_discard_seg == 0 is out of spec but we always
+		 * handled it.
+		 */
+		if (!v)
+			v = sg_elems - 2;
 		blk_queue_max_discard_segments(q,
-					       min_not_zero(v,
-							    MAX_DISCARD_SEGMENTS));
+					       min(v, MAX_DISCARD_SEGMENTS));
 
 		blk_queue_flag_set(QUEUE_FLAG_DISCARD, q);
 	}
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 1becbbb3be13..390817cf1221 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -42,6 +42,7 @@
 #include <linux/cdrom.h>
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/major.h>
 #include <linux/mutex.h>
 #include <linux/scatterlist.h>
 #include <linux/bitmap.h>
diff --git a/drivers/clk/qcom/dispcc-sc7180.c b/drivers/clk/qcom/dispcc-sc7180.c
index 538e4963c915..5d2ae297e741 100644
--- a/drivers/clk/qcom/dispcc-sc7180.c
+++ b/drivers/clk/qcom/dispcc-sc7180.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * Copyright (c) 2019, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2019, 2022, The Linux Foundation. All rights reserved.
  */
 
 #include <linux/clk-provider.h>
@@ -625,6 +625,9 @@ static struct clk_branch disp_cc_mdss_vsync_clk = {
 
 static struct gdsc mdss_gdsc = {
 	.gdscr = 0x3000,
+	.en_rest_wait_val = 0x2,
+	.en_few_wait_val = 0x2,
+	.clk_dis_wait_val = 0xf,
 	.pd = {
 		.name = "mdss_gdsc",
 	},
diff --git a/drivers/clk/qcom/dispcc-sc7280.c b/drivers/clk/qcom/dispcc-sc7280.c
index 4ef4ae231794..ad596d567f6a 100644
--- a/drivers/clk/qcom/dispcc-sc7280.c
+++ b/drivers/clk/qcom/dispcc-sc7280.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * Copyright (c) 2021, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2021-2022, The Linux Foundation. All rights reserved.
  */
 
 #include <linux/clk-provider.h>
@@ -787,6 +787,9 @@ static struct clk_branch disp_cc_sleep_clk = {
 
 static struct gdsc disp_cc_mdss_core_gdsc = {
 	.gdscr = 0x1004,
+	.en_rest_wait_val = 0x2,
+	.en_few_wait_val = 0x2,
+	.clk_dis_wait_val = 0xf,
 	.pd = {
 		.name = "disp_cc_mdss_core_gdsc",
 	},
diff --git a/drivers/clk/qcom/dispcc-sm8250.c b/drivers/clk/qcom/dispcc-sm8250.c
index bf9ffe1a1cf4..73c5feea9818 100644
--- a/drivers/clk/qcom/dispcc-sm8250.c
+++ b/drivers/clk/qcom/dispcc-sm8250.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * Copyright (c) 2018-2020, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2018-2020, 2022, The Linux Foundation. All rights reserved.
  */
 
 #include <linux/clk-provider.h>
@@ -1125,6 +1125,9 @@ static struct clk_branch disp_cc_mdss_vsync_clk = {
 
 static struct gdsc mdss_gdsc = {
 	.gdscr = 0x3000,
+	.en_rest_wait_val = 0x2,
+	.en_few_wait_val = 0x2,
+	.clk_dis_wait_val = 0xf,
 	.pd = {
 		.name = "mdss_gdsc",
 	},
diff --git a/drivers/clk/qcom/gdsc.c b/drivers/clk/qcom/gdsc.c
index 4ece326ea233..cf23cfd7e467 100644
--- a/drivers/clk/qcom/gdsc.c
+++ b/drivers/clk/qcom/gdsc.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * Copyright (c) 2015, 2017-2018, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2015, 2017-2018, 2022, The Linux Foundation. All rights reserved.
  */
 
 #include <linux/bitops.h>
@@ -34,9 +34,14 @@
 #define CFG_GDSCR_OFFSET		0x4
 
 /* Wait 2^n CXO cycles between all states. Here, n=2 (4 cycles). */
-#define EN_REST_WAIT_VAL	(0x2 << 20)
-#define EN_FEW_WAIT_VAL		(0x8 << 16)
-#define CLK_DIS_WAIT_VAL	(0x2 << 12)
+#define EN_REST_WAIT_VAL	0x2
+#define EN_FEW_WAIT_VAL		0x8
+#define CLK_DIS_WAIT_VAL	0x2
+
+/* Transition delay shifts */
+#define EN_REST_WAIT_SHIFT	20
+#define EN_FEW_WAIT_SHIFT	16
+#define CLK_DIS_WAIT_SHIFT	12
 
 #define RETAIN_MEM		BIT(14)
 #define RETAIN_PERIPH		BIT(13)
@@ -341,7 +346,18 @@ static int gdsc_init(struct gdsc *sc)
 	 */
 	mask = HW_CONTROL_MASK | SW_OVERRIDE_MASK |
 	       EN_REST_WAIT_MASK | EN_FEW_WAIT_MASK | CLK_DIS_WAIT_MASK;
-	val = EN_REST_WAIT_VAL | EN_FEW_WAIT_VAL | CLK_DIS_WAIT_VAL;
+
+	if (!sc->en_rest_wait_val)
+		sc->en_rest_wait_val = EN_REST_WAIT_VAL;
+	if (!sc->en_few_wait_val)
+		sc->en_few_wait_val = EN_FEW_WAIT_VAL;
+	if (!sc->clk_dis_wait_val)
+		sc->clk_dis_wait_val = CLK_DIS_WAIT_VAL;
+
+	val = sc->en_rest_wait_val << EN_REST_WAIT_SHIFT |
+		sc->en_few_wait_val << EN_FEW_WAIT_SHIFT |
+		sc->clk_dis_wait_val << CLK_DIS_WAIT_SHIFT;
+
 	ret = regmap_update_bits(sc->regmap, sc->gdscr, mask, val);
 	if (ret)
 		return ret;
diff --git a/drivers/clk/qcom/gdsc.h b/drivers/clk/qcom/gdsc.h
index 5bb396b344d1..762f1b5e1ec5 100644
--- a/drivers/clk/qcom/gdsc.h
+++ b/drivers/clk/qcom/gdsc.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 /*
- * Copyright (c) 2015, 2017-2018, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2015, 2017-2018, 2022, The Linux Foundation. All rights reserved.
  */
 
 #ifndef __QCOM_GDSC_H__
@@ -22,6 +22,9 @@ struct reset_controller_dev;
  * @cxcs: offsets of branch registers to toggle mem/periph bits in
  * @cxc_count: number of @cxcs
  * @pwrsts: Possible powerdomain power states
+ * @en_rest_wait_val: transition delay value for receiving enr ack signal
+ * @en_few_wait_val: transition delay value for receiving enf ack signal
+ * @clk_dis_wait_val: transition delay value for halting clock
  * @resets: ids of resets associated with this gdsc
  * @reset_count: number of @resets
  * @rcdev: reset controller
@@ -35,6 +38,9 @@ struct gdsc {
 	unsigned int			clamp_io_ctrl;
 	unsigned int			*cxcs;
 	unsigned int			cxc_count;
+	unsigned int			en_rest_wait_val;
+	unsigned int			en_few_wait_val;
+	unsigned int			clk_dis_wait_val;
 	const u8			pwrsts;
 /* Powerdomain allowable state bitfields */
 #define PWRSTS_OFF		BIT(0)
diff --git a/drivers/gpio/gpio-ts4900.c b/drivers/gpio/gpio-ts4900.c
index d885032cf814..d918d2df4de2 100644
--- a/drivers/gpio/gpio-ts4900.c
+++ b/drivers/gpio/gpio-ts4900.c
@@ -1,7 +1,7 @@
 /*
  * Digital I/O driver for Technologic Systems I2C FPGA Core
  *
- * Copyright (C) 2015 Technologic Systems
+ * Copyright (C) 2015, 2018 Technologic Systems
  * Copyright (C) 2016 Savoir-Faire Linux
  *
  * This program is free software; you can redistribute it and/or
@@ -55,19 +55,33 @@ static int ts4900_gpio_direction_input(struct gpio_chip *chip,
 {
 	struct ts4900_gpio_priv *priv = gpiochip_get_data(chip);
 
-	/*
-	 * This will clear the output enable bit, the other bits are
-	 * dontcare when this is cleared
+	/* Only clear the OE bit here, requires a RMW. Prevents potential issue
+	 * with OE and data getting to the physical pin at different times.
 	 */
-	return regmap_write(priv->regmap, offset, 0);
+	return regmap_update_bits(priv->regmap, offset, TS4900_GPIO_OE, 0);
 }
 
 static int ts4900_gpio_direction_output(struct gpio_chip *chip,
 					unsigned int offset, int value)
 {
 	struct ts4900_gpio_priv *priv = gpiochip_get_data(chip);
+	unsigned int reg;
 	int ret;
 
+	/* If changing from an input to an output, we need to first set the
+	 * proper data bit to what is requested and then set OE bit. This
+	 * prevents a glitch that can occur on the IO line
+	 */
+	regmap_read(priv->regmap, offset, &reg);
+	if (!(reg & TS4900_GPIO_OE)) {
+		if (value)
+			reg = TS4900_GPIO_OUT;
+		else
+			reg &= ~TS4900_GPIO_OUT;
+
+		regmap_write(priv->regmap, offset, reg);
+	}
+
 	if (value)
 		ret = regmap_write(priv->regmap, offset, TS4900_GPIO_OE |
 							 TS4900_GPIO_OUT);
diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
index d040c72fea58..4c2e32c38acc 100644
--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -311,7 +311,8 @@ static struct gpio_desc *acpi_request_own_gpiod(struct gpio_chip *chip,
 	if (IS_ERR(desc))
 		return desc;
 
-	ret = gpio_set_debounce_timeout(desc, agpio->debounce_timeout);
+	/* ACPI uses hundredths of milliseconds units */
+	ret = gpio_set_debounce_timeout(desc, agpio->debounce_timeout * 10);
 	if (ret)
 		dev_warn(chip->parent,
 			 "Failed to set debounce-timeout for pin 0x%04X, err %d\n",
@@ -1052,7 +1053,8 @@ int acpi_dev_gpio_irq_get_by(struct acpi_device *adev, const char *name, int ind
 			if (ret < 0)
 				return ret;
 
-			ret = gpio_set_debounce_timeout(desc, info.debounce);
+			/* ACPI uses hundredths of milliseconds units */
+			ret = gpio_set_debounce_timeout(desc, info.debounce * 10);
 			if (ret)
 				return ret;
 
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index d1b9b721218f..358f0ad9d0f8 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -2186,6 +2186,16 @@ static int gpio_set_bias(struct gpio_desc *desc)
 	return gpio_set_config_with_argument_optional(desc, bias, arg);
 }
 
+/**
+ * gpio_set_debounce_timeout() - Set debounce timeout
+ * @desc:	GPIO descriptor to set the debounce timeout
+ * @debounce:	Debounce timeout in microseconds
+ *
+ * The function calls the certain GPIO driver to set debounce timeout
+ * in the hardware.
+ *
+ * Returns 0 on success, or negative error code otherwise.
+ */
 int gpio_set_debounce_timeout(struct gpio_desc *desc, unsigned int debounce)
 {
 	return gpio_set_config_with_argument_optional(desc,
@@ -3106,6 +3116,16 @@ int gpiod_to_irq(const struct gpio_desc *desc)
 
 		return retirq;
 	}
+#ifdef CONFIG_GPIOLIB_IRQCHIP
+	if (gc->irq.chip) {
+		/*
+		 * Avoid race condition with other code, which tries to lookup
+		 * an IRQ before the irqchip has been properly registered,
+		 * i.e. while gpiochip is still being brought up.
+		 */
+		return -EPROBE_DEFER;
+	}
+#endif
 	return -ENXIO;
 }
 EXPORT_SYMBOL_GPL(gpiod_to_irq);
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
index dc50c05f23fc..5c08047adb59 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
@@ -1145,7 +1145,7 @@ int amdgpu_display_framebuffer_init(struct drm_device *dev,
 	if (ret)
 		return ret;
 
-	if (!dev->mode_config.allow_fb_modifiers) {
+	if (!dev->mode_config.allow_fb_modifiers && !adev->enable_virtual_display) {
 		drm_WARN_ONCE(dev, adev->family >= AMDGPU_FAMILY_AI,
 			      "GFX9+ requires FB check based on format modifier\n");
 		ret = check_tiling_flags_gfx6(rfb);
diff --git a/drivers/gpu/drm/i915/display/intel_display.c b/drivers/gpu/drm/i915/display/intel_display.c
index 625ce6975eeb..c9b051ab18e0 100644
--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -1658,8 +1658,8 @@ static void fixup_plane_bitmasks(struct intel_crtc_state *crtc_state)
 	}
 }
 
-static void intel_plane_disable_noatomic(struct intel_crtc *crtc,
-					 struct intel_plane *plane)
+void intel_plane_disable_noatomic(struct intel_crtc *crtc,
+				  struct intel_plane *plane)
 {
 	struct drm_i915_private *dev_priv = to_i915(crtc->base.dev);
 	struct intel_crtc_state *crtc_state =
@@ -13217,6 +13217,7 @@ intel_modeset_setup_hw_state(struct drm_device *dev,
 		vlv_wm_sanitize(dev_priv);
 	} else if (DISPLAY_VER(dev_priv) >= 9) {
 		skl_wm_get_hw_state(dev_priv);
+		skl_wm_sanitize(dev_priv);
 	} else if (HAS_PCH_SPLIT(dev_priv)) {
 		ilk_wm_get_hw_state(dev_priv);
 	}
diff --git a/drivers/gpu/drm/i915/display/intel_display.h b/drivers/gpu/drm/i915/display/intel_display.h
index 284936f0ddab..6a7a91b38080 100644
--- a/drivers/gpu/drm/i915/display/intel_display.h
+++ b/drivers/gpu/drm/i915/display/intel_display.h
@@ -629,6 +629,8 @@ void intel_plane_unpin_fb(struct intel_plane_state *old_plane_state);
 struct intel_encoder *
 intel_get_crtc_new_encoder(const struct intel_atomic_state *state,
 			   const struct intel_crtc_state *crtc_state);
+void intel_plane_disable_noatomic(struct intel_crtc *crtc,
+				  struct intel_plane *plane);
 
 unsigned int intel_surf_alignment(const struct drm_framebuffer *fb,
 				  int color_plane);
diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
index 9c5e4758947b..c7c8a556e401 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -6681,6 +6681,74 @@ void skl_wm_get_hw_state(struct drm_i915_private *dev_priv)
 	dbuf_state->enabled_slices = dev_priv->dbuf.enabled_slices;
 }
 
+static bool skl_dbuf_is_misconfigured(struct drm_i915_private *i915)
+{
+	const struct intel_dbuf_state *dbuf_state =
+		to_intel_dbuf_state(i915->dbuf.obj.state);
+	struct skl_ddb_entry entries[I915_MAX_PIPES] = {};
+	struct intel_crtc *crtc;
+
+	for_each_intel_crtc(&i915->drm, crtc) {
+		const struct intel_crtc_state *crtc_state =
+			to_intel_crtc_state(crtc->base.state);
+
+		entries[crtc->pipe] = crtc_state->wm.skl.ddb;
+	}
+
+	for_each_intel_crtc(&i915->drm, crtc) {
+		const struct intel_crtc_state *crtc_state =
+			to_intel_crtc_state(crtc->base.state);
+		u8 slices;
+
+		slices = skl_compute_dbuf_slices(crtc, dbuf_state->active_pipes,
+						 dbuf_state->joined_mbus);
+		if (dbuf_state->slices[crtc->pipe] & ~slices)
+			return true;
+
+		if (skl_ddb_allocation_overlaps(&crtc_state->wm.skl.ddb, entries,
+						I915_MAX_PIPES, crtc->pipe))
+			return true;
+	}
+
+	return false;
+}
+
+void skl_wm_sanitize(struct drm_i915_private *i915)
+{
+	struct intel_crtc *crtc;
+
+	/*
+	 * On TGL/RKL (at least) the BIOS likes to assign the planes
+	 * to the wrong DBUF slices. This will cause an infinite loop
+	 * in skl_commit_modeset_enables() as it can't find a way to
+	 * transition between the old bogus DBUF layout to the new
+	 * proper DBUF layout without DBUF allocation overlaps between
+	 * the planes (which cannot be allowed or else the hardware
+	 * may hang). If we detect a bogus DBUF layout just turn off
+	 * all the planes so that skl_commit_modeset_enables() can
+	 * simply ignore them.
+	 */
+	if (!skl_dbuf_is_misconfigured(i915))
+		return;
+
+	drm_dbg_kms(&i915->drm, "BIOS has misprogrammed the DBUF, disabling all planes\n");
+
+	for_each_intel_crtc(&i915->drm, crtc) {
+		struct intel_plane *plane = to_intel_plane(crtc->base.primary);
+		const struct intel_plane_state *plane_state =
+			to_intel_plane_state(plane->base.state);
+		struct intel_crtc_state *crtc_state =
+			to_intel_crtc_state(crtc->base.state);
+
+		if (plane_state->uapi.visible)
+			intel_plane_disable_noatomic(crtc, plane);
+
+		drm_WARN_ON(&i915->drm, crtc_state->active_planes != 0);
+
+		memset(&crtc_state->wm.skl.ddb, 0, sizeof(crtc_state->wm.skl.ddb));
+	}
+}
+
 static void ilk_pipe_wm_get_hw_state(struct intel_crtc *crtc)
 {
 	struct drm_device *dev = crtc->base.dev;
diff --git a/drivers/gpu/drm/i915/intel_pm.h b/drivers/gpu/drm/i915/intel_pm.h
index 91f23b7f0af2..79d89fe22d8c 100644
--- a/drivers/gpu/drm/i915/intel_pm.h
+++ b/drivers/gpu/drm/i915/intel_pm.h
@@ -48,6 +48,7 @@ void skl_pipe_wm_get_hw_state(struct intel_crtc *crtc,
 			      struct skl_pipe_wm *out);
 void g4x_wm_sanitize(struct drm_i915_private *dev_priv);
 void vlv_wm_sanitize(struct drm_i915_private *dev_priv);
+void skl_wm_sanitize(struct drm_i915_private *dev_priv);
 bool intel_can_enable_sagv(struct drm_i915_private *dev_priv,
 			   const struct intel_bw_state *bw_state);
 void intel_sagv_pre_plane_update(struct intel_atomic_state *state);
diff --git a/drivers/gpu/drm/panel/Kconfig b/drivers/gpu/drm/panel/Kconfig
index 418638e6e3b0..f63fd0f90360 100644
--- a/drivers/gpu/drm/panel/Kconfig
+++ b/drivers/gpu/drm/panel/Kconfig
@@ -83,6 +83,7 @@ config DRM_PANEL_SIMPLE
 	depends on PM
 	select VIDEOMODE_HELPERS
 	select DRM_DP_AUX_BUS
+	select DRM_DP_HELPER
 	help
 	  DRM panel driver for dumb panels that need at most a regulator and
 	  a GPIO to be powered up. Optionally a backlight can be attached so
diff --git a/drivers/gpu/drm/sun4i/sun8i_mixer.h b/drivers/gpu/drm/sun4i/sun8i_mixer.h
index 145833a9d82d..5b3fbee18671 100644
--- a/drivers/gpu/drm/sun4i/sun8i_mixer.h
+++ b/drivers/gpu/drm/sun4i/sun8i_mixer.h
@@ -111,10 +111,10 @@
 /* format 13 is semi-planar YUV411 VUVU */
 #define SUN8I_MIXER_FBFMT_YUV411	14
 /* format 15 doesn't exist */
-/* format 16 is P010 YVU */
-#define SUN8I_MIXER_FBFMT_P010_YUV	17
-/* format 18 is P210 YVU */
-#define SUN8I_MIXER_FBFMT_P210_YUV	19
+#define SUN8I_MIXER_FBFMT_P010_YUV	16
+/* format 17 is P010 YVU */
+#define SUN8I_MIXER_FBFMT_P210_YUV	18
+/* format 19 is P210 YVU */
 /* format 20 is packed YVU444 10-bit */
 /* format 21 is packed YUV444 10-bit */
 
diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index 9170d948b448..07887cbfd9cb 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -1522,6 +1522,7 @@ static int vc4_hdmi_audio_init(struct vc4_hdmi *vc4_hdmi)
 		dev_err(dev, "Couldn't register the HDMI codec: %ld\n", PTR_ERR(codec_pdev));
 		return PTR_ERR(codec_pdev);
 	}
+	vc4_hdmi->audio.codec_pdev = codec_pdev;
 
 	dai_link->cpus		= &vc4_hdmi->audio.cpu;
 	dai_link->codecs	= &vc4_hdmi->audio.codec;
@@ -1561,6 +1562,12 @@ static int vc4_hdmi_audio_init(struct vc4_hdmi *vc4_hdmi)
 
 }
 
+static void vc4_hdmi_audio_exit(struct vc4_hdmi *vc4_hdmi)
+{
+	platform_device_unregister(vc4_hdmi->audio.codec_pdev);
+	vc4_hdmi->audio.codec_pdev = NULL;
+}
+
 static irqreturn_t vc4_hdmi_hpd_irq_thread(int irq, void *priv)
 {
 	struct vc4_hdmi *vc4_hdmi = priv;
@@ -2298,6 +2305,7 @@ static void vc4_hdmi_unbind(struct device *dev, struct device *master,
 	kfree(vc4_hdmi->hdmi_regset.regs);
 	kfree(vc4_hdmi->hd_regset.regs);
 
+	vc4_hdmi_audio_exit(vc4_hdmi);
 	vc4_hdmi_cec_exit(vc4_hdmi);
 	vc4_hdmi_hotplug_exit(vc4_hdmi);
 	vc4_hdmi_connector_destroy(&vc4_hdmi->connector);
diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.h b/drivers/gpu/drm/vc4/vc4_hdmi.h
index 33e9f665ab8e..c0492da73683 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.h
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.h
@@ -113,6 +113,7 @@ struct vc4_hdmi_audio {
 	struct snd_soc_dai_link_component platform;
 	struct snd_dmaengine_dai_dma_data dma_data;
 	struct hdmi_audio_infoframe infoframe;
+	struct platform_device *codec_pdev;
 	bool streaming;
 };
 
diff --git a/drivers/hid/hid-elo.c b/drivers/hid/hid-elo.c
index 9b42b0cdeef0..2876cb6a7dca 100644
--- a/drivers/hid/hid-elo.c
+++ b/drivers/hid/hid-elo.c
@@ -228,7 +228,6 @@ static int elo_probe(struct hid_device *hdev, const struct hid_device_id *id)
 {
 	struct elo_priv *priv;
 	int ret;
-	struct usb_device *udev;
 
 	if (!hid_is_usb(hdev))
 		return -EINVAL;
@@ -238,8 +237,7 @@ static int elo_probe(struct hid_device *hdev, const struct hid_device_id *id)
 		return -ENOMEM;
 
 	INIT_DELAYED_WORK(&priv->work, elo_work);
-	udev = interface_to_usbdev(to_usb_interface(hdev->dev.parent));
-	priv->usbdev = usb_get_dev(udev);
+	priv->usbdev = interface_to_usbdev(to_usb_interface(hdev->dev.parent));
 
 	hid_set_drvdata(hdev, priv);
 
@@ -262,7 +260,6 @@ static int elo_probe(struct hid_device *hdev, const struct hid_device_id *id)
 
 	return 0;
 err_free:
-	usb_put_dev(udev);
 	kfree(priv);
 	return ret;
 }
@@ -271,8 +268,6 @@ static void elo_remove(struct hid_device *hdev)
 {
 	struct elo_priv *priv = hid_get_drvdata(hdev);
 
-	usb_put_dev(priv->usbdev);
-
 	hid_hw_stop(hdev);
 	cancel_delayed_work_sync(&priv->work);
 	kfree(priv);
diff --git a/drivers/hid/hid-thrustmaster.c b/drivers/hid/hid-thrustmaster.c
index 0c92b7f9b8b8..afdd778a10f0 100644
--- a/drivers/hid/hid-thrustmaster.c
+++ b/drivers/hid/hid-thrustmaster.c
@@ -158,6 +158,12 @@ static void thrustmaster_interrupts(struct hid_device *hdev)
 		return;
 	}
 
+	if (usbif->cur_altsetting->desc.bNumEndpoints < 2) {
+		kfree(send_buf);
+		hid_err(hdev, "Wrong number of endpoints?\n");
+		return;
+	}
+
 	ep = &usbif->cur_altsetting->endpoint[1];
 	b_ep = ep->desc.bEndpointAddress;
 
diff --git a/drivers/hid/hid-vivaldi.c b/drivers/hid/hid-vivaldi.c
index 576518e704ee..d57ec1767037 100644
--- a/drivers/hid/hid-vivaldi.c
+++ b/drivers/hid/hid-vivaldi.c
@@ -143,7 +143,7 @@ static void vivaldi_feature_mapping(struct hid_device *hdev,
 static int vivaldi_input_configured(struct hid_device *hdev,
 				    struct hid_input *hidinput)
 {
-	return sysfs_create_group(&hdev->dev.kobj, &input_attribute_group);
+	return devm_device_add_group(&hdev->dev, &input_attribute_group);
 }
 
 static const struct hid_device_id vivaldi_table[] = {
diff --git a/drivers/hwmon/pmbus/pmbus_core.c b/drivers/hwmon/pmbus/pmbus_core.c
index 776ee2237be2..ac2fbee1ba9c 100644
--- a/drivers/hwmon/pmbus/pmbus_core.c
+++ b/drivers/hwmon/pmbus/pmbus_core.c
@@ -911,6 +911,11 @@ static int pmbus_get_boolean(struct i2c_client *client, struct pmbus_boolean *b,
 		pmbus_update_sensor_data(client, s2);
 
 	regval = status & mask;
+	if (regval) {
+		ret = pmbus_write_byte_data(client, page, reg, regval);
+		if (ret)
+			goto unlock;
+	}
 	if (s1 && s2) {
 		s64 v1, v2;
 
diff --git a/drivers/isdn/hardware/mISDN/hfcpci.c b/drivers/isdn/hardware/mISDN/hfcpci.c
index bd087cca1c1d..af17459c1a5c 100644
--- a/drivers/isdn/hardware/mISDN/hfcpci.c
+++ b/drivers/isdn/hardware/mISDN/hfcpci.c
@@ -2005,7 +2005,11 @@ setup_hw(struct hfc_pci *hc)
 	}
 	/* Allocate memory for FIFOS */
 	/* the memory needs to be on a 32k boundary within the first 4G */
-	dma_set_mask(&hc->pdev->dev, 0xFFFF8000);
+	if (dma_set_mask(&hc->pdev->dev, 0xFFFF8000)) {
+		printk(KERN_WARNING
+		       "HFC-PCI: No usable DMA configuration!\n");
+		return -EIO;
+	}
 	buffer = dma_alloc_coherent(&hc->pdev->dev, 0x8000, &hc->hw.dmahandle,
 				    GFP_KERNEL);
 	/* We silently assume the address is okay if nonzero */
diff --git a/drivers/isdn/mISDN/dsp_pipeline.c b/drivers/isdn/mISDN/dsp_pipeline.c
index e11ca6bbc7f4..c3b2c99b5cd5 100644
--- a/drivers/isdn/mISDN/dsp_pipeline.c
+++ b/drivers/isdn/mISDN/dsp_pipeline.c
@@ -192,7 +192,7 @@ void dsp_pipeline_destroy(struct dsp_pipeline *pipeline)
 int dsp_pipeline_build(struct dsp_pipeline *pipeline, const char *cfg)
 {
 	int found = 0;
-	char *dup, *tok, *name, *args;
+	char *dup, *next, *tok, *name, *args;
 	struct dsp_element_entry *entry, *n;
 	struct dsp_pipeline_entry *pipeline_entry;
 	struct mISDN_dsp_element *elem;
@@ -203,10 +203,10 @@ int dsp_pipeline_build(struct dsp_pipeline *pipeline, const char *cfg)
 	if (!list_empty(&pipeline->list))
 		_dsp_pipeline_destroy(pipeline);
 
-	dup = kstrdup(cfg, GFP_ATOMIC);
+	dup = next = kstrdup(cfg, GFP_ATOMIC);
 	if (!dup)
 		return 0;
-	while ((tok = strsep(&dup, "|"))) {
+	while ((tok = strsep(&next, "|"))) {
 		if (!strlen(tok))
 			continue;
 		name = strsep(&tok, "(");
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 2d31a079be33..5ce2648cbe5b 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -51,6 +51,7 @@
 #include <linux/hdreg.h>
 #include <linux/proc_fs.h>
 #include <linux/random.h>
+#include <linux/major.h>
 #include <linux/module.h>
 #include <linux/reboot.h>
 #include <linux/file.h>
diff --git a/drivers/mmc/host/meson-gx-mmc.c b/drivers/mmc/host/meson-gx-mmc.c
index 8f36536cb1b6..58ab9d90bc8b 100644
--- a/drivers/mmc/host/meson-gx-mmc.c
+++ b/drivers/mmc/host/meson-gx-mmc.c
@@ -173,6 +173,8 @@ struct meson_host {
 	int irq;
 
 	bool vqmmc_enabled;
+	bool needs_pre_post_req;
+
 };
 
 #define CMD_CFG_LENGTH_MASK GENMASK(8, 0)
@@ -663,6 +665,8 @@ static void meson_mmc_request_done(struct mmc_host *mmc,
 	struct meson_host *host = mmc_priv(mmc);
 
 	host->cmd = NULL;
+	if (host->needs_pre_post_req)
+		meson_mmc_post_req(mmc, mrq, 0);
 	mmc_request_done(host->mmc, mrq);
 }
 
@@ -880,7 +884,7 @@ static int meson_mmc_validate_dram_access(struct mmc_host *mmc, struct mmc_data
 static void meson_mmc_request(struct mmc_host *mmc, struct mmc_request *mrq)
 {
 	struct meson_host *host = mmc_priv(mmc);
-	bool needs_pre_post_req = mrq->data &&
+	host->needs_pre_post_req = mrq->data &&
 			!(mrq->data->host_cookie & SD_EMMC_PRE_REQ_DONE);
 
 	/*
@@ -896,22 +900,19 @@ static void meson_mmc_request(struct mmc_host *mmc, struct mmc_request *mrq)
 		}
 	}
 
-	if (needs_pre_post_req) {
+	if (host->needs_pre_post_req) {
 		meson_mmc_get_transfer_mode(mmc, mrq);
 		if (!meson_mmc_desc_chain_mode(mrq->data))
-			needs_pre_post_req = false;
+			host->needs_pre_post_req = false;
 	}
 
-	if (needs_pre_post_req)
+	if (host->needs_pre_post_req)
 		meson_mmc_pre_req(mmc, mrq);
 
 	/* Stop execution */
 	writel(0, host->regs + SD_EMMC_START);
 
 	meson_mmc_start_cmd(mmc, mrq->sbc ?: mrq->cmd);
-
-	if (needs_pre_post_req)
-		meson_mmc_post_req(mmc, mrq, 0);
 }
 
 static void meson_mmc_read_resp(struct mmc_host *mmc, struct mmc_command *cmd)
diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index fb59efc7f926..14bf1828cbba 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2928,7 +2928,7 @@ mt753x_phylink_validate(struct dsa_switch *ds, int port,
 
 	phylink_set_port_modes(mask);
 
-	if (state->interface != PHY_INTERFACE_MODE_TRGMII ||
+	if (state->interface != PHY_INTERFACE_MODE_TRGMII &&
 	    !phy_interface_mode_is_8023z(state->interface)) {
 		phylink_set(mask, 10baseT_Half);
 		phylink_set(mask, 10baseT_Full);
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 263da7e2d6be..056e3b65cd27 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2291,13 +2291,6 @@ static int mv88e6xxx_port_vlan_del(struct dsa_switch *ds, int port,
 	if (!mv88e6xxx_max_vid(chip))
 		return -EOPNOTSUPP;
 
-	/* The ATU removal procedure needs the FID to be mapped in the VTU,
-	 * but FDB deletion runs concurrently with VLAN deletion. Flush the DSA
-	 * switchdev workqueue to ensure that all FDB entries are deleted
-	 * before we remove the VLAN.
-	 */
-	dsa_flush_workqueue();
-
 	mv88e6xxx_reg_lock(chip);
 
 	err = mv88e6xxx_port_get_pvid(chip, port, &pvid);
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
index e31a5a397f11..f55d9d9c01a8 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
@@ -40,6 +40,13 @@
 void bcmgenet_get_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
 {
 	struct bcmgenet_priv *priv = netdev_priv(dev);
+	struct device *kdev = &priv->pdev->dev;
+
+	if (!device_can_wakeup(kdev)) {
+		wol->supported = 0;
+		wol->wolopts = 0;
+		return;
+	}
 
 	wol->supported = WAKE_MAGIC | WAKE_MAGICSECURE | WAKE_FILTER;
 	wol->wolopts = priv->wolopts;
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index d71c11a6282e..9705c49655ad 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -1606,7 +1606,14 @@ static int macb_poll(struct napi_struct *napi, int budget)
 	if (work_done < budget) {
 		napi_complete_done(napi, work_done);
 
-		/* Packets received while interrupts were disabled */
+		/* RSR bits only seem to propagate to raise interrupts when
+		 * interrupts are enabled at the time, so if bits are already
+		 * set due to packets received while interrupts were disabled,
+		 * they will not cause another interrupt to be generated when
+		 * interrupts are re-enabled.
+		 * Check for this case here. This has been seen to happen
+		 * around 30% of the time under heavy network load.
+		 */
 		status = macb_readl(bp, RSR);
 		if (status) {
 			if (bp->caps & MACB_CAPS_ISR_CLEAR_ON_WRITE)
@@ -1614,6 +1621,22 @@ static int macb_poll(struct napi_struct *napi, int budget)
 			napi_reschedule(napi);
 		} else {
 			queue_writel(queue, IER, bp->rx_intr_mask);
+
+			/* In rare cases, packets could have been received in
+			 * the window between the check above and re-enabling
+			 * interrupts. Therefore, a double-check is required
+			 * to avoid losing a wakeup. This can potentially race
+			 * with the interrupt handler doing the same actions
+			 * if an interrupt is raised just after enabling them,
+			 * but this should be harmless.
+			 */
+			status = macb_readl(bp, RSR);
+			if (unlikely(status)) {
+				queue_writel(queue, IDR, bp->rx_intr_mask);
+				if (bp->caps & MACB_CAPS_ISR_CLEAR_ON_WRITE)
+					queue_writel(queue, ISR, MACB_BIT(RCOMP));
+				napi_schedule(napi);
+			}
 		}
 	}
 
diff --git a/drivers/net/ethernet/freescale/gianfar_ethtool.c b/drivers/net/ethernet/freescale/gianfar_ethtool.c
index 7b32ed29bf4c..8c17fe5d66ed 100644
--- a/drivers/net/ethernet/freescale/gianfar_ethtool.c
+++ b/drivers/net/ethernet/freescale/gianfar_ethtool.c
@@ -1460,6 +1460,7 @@ static int gfar_get_ts_info(struct net_device *dev,
 	ptp_node = of_find_compatible_node(NULL, NULL, "fsl,etsec-ptp");
 	if (ptp_node) {
 		ptp_dev = of_find_device_by_node(ptp_node);
+		of_node_put(ptp_node);
 		if (ptp_dev)
 			ptp = platform_get_drvdata(ptp_dev);
 	}
diff --git a/drivers/net/ethernet/intel/i40e/i40e_debugfs.c b/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
index 1e57cc8c47d7..9db5001297c7 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
@@ -742,10 +742,8 @@ static void i40e_dbg_dump_vf(struct i40e_pf *pf, int vf_id)
 		vsi = pf->vsi[vf->lan_vsi_idx];
 		dev_info(&pf->pdev->dev, "vf %2d: VSI id=%d, seid=%d, qps=%d\n",
 			 vf_id, vf->lan_vsi_id, vsi->seid, vf->num_queue_pairs);
-		dev_info(&pf->pdev->dev, "       num MDD=%lld, invalid msg=%lld, valid msg=%lld\n",
-			 vf->num_mdd_events,
-			 vf->num_invalid_msgs,
-			 vf->num_valid_msgs);
+		dev_info(&pf->pdev->dev, "       num MDD=%lld\n",
+			 vf->num_mdd_events);
 	} else {
 		dev_info(&pf->pdev->dev, "invalid VF id %d\n", vf_id);
 	}
diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index c6f643e54c4f..babf8b7fa767 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -1917,19 +1917,17 @@ int i40e_pci_sriov_configure(struct pci_dev *pdev, int num_vfs)
 /***********************virtual channel routines******************/
 
 /**
- * i40e_vc_send_msg_to_vf_ex
+ * i40e_vc_send_msg_to_vf
  * @vf: pointer to the VF info
  * @v_opcode: virtual channel opcode
  * @v_retval: virtual channel return value
  * @msg: pointer to the msg buffer
  * @msglen: msg length
- * @is_quiet: true for not printing unsuccessful return values, false otherwise
  *
  * send msg to VF
  **/
-static int i40e_vc_send_msg_to_vf_ex(struct i40e_vf *vf, u32 v_opcode,
-				     u32 v_retval, u8 *msg, u16 msglen,
-				     bool is_quiet)
+static int i40e_vc_send_msg_to_vf(struct i40e_vf *vf, u32 v_opcode,
+				  u32 v_retval, u8 *msg, u16 msglen)
 {
 	struct i40e_pf *pf;
 	struct i40e_hw *hw;
@@ -1944,25 +1942,6 @@ static int i40e_vc_send_msg_to_vf_ex(struct i40e_vf *vf, u32 v_opcode,
 	hw = &pf->hw;
 	abs_vf_id = vf->vf_id + hw->func_caps.vf_base_id;
 
-	/* single place to detect unsuccessful return values */
-	if (v_retval && !is_quiet) {
-		vf->num_invalid_msgs++;
-		dev_info(&pf->pdev->dev, "VF %d failed opcode %d, retval: %d\n",
-			 vf->vf_id, v_opcode, v_retval);
-		if (vf->num_invalid_msgs >
-		    I40E_DEFAULT_NUM_INVALID_MSGS_ALLOWED) {
-			dev_err(&pf->pdev->dev,
-				"Number of invalid messages exceeded for VF %d\n",
-				vf->vf_id);
-			dev_err(&pf->pdev->dev, "Use PF Control I/F to enable the VF\n");
-			set_bit(I40E_VF_STATE_DISABLED, &vf->vf_states);
-		}
-	} else {
-		vf->num_valid_msgs++;
-		/* reset the invalid counter, if a valid message is received. */
-		vf->num_invalid_msgs = 0;
-	}
-
 	aq_ret = i40e_aq_send_msg_to_vf(hw, abs_vf_id,	v_opcode, v_retval,
 					msg, msglen, NULL);
 	if (aq_ret) {
@@ -1975,23 +1954,6 @@ static int i40e_vc_send_msg_to_vf_ex(struct i40e_vf *vf, u32 v_opcode,
 	return 0;
 }
 
-/**
- * i40e_vc_send_msg_to_vf
- * @vf: pointer to the VF info
- * @v_opcode: virtual channel opcode
- * @v_retval: virtual channel return value
- * @msg: pointer to the msg buffer
- * @msglen: msg length
- *
- * send msg to VF
- **/
-static int i40e_vc_send_msg_to_vf(struct i40e_vf *vf, u32 v_opcode,
-				  u32 v_retval, u8 *msg, u16 msglen)
-{
-	return i40e_vc_send_msg_to_vf_ex(vf, v_opcode, v_retval,
-					 msg, msglen, false);
-}
-
 /**
  * i40e_vc_send_resp_to_vf
  * @vf: pointer to the VF info
@@ -2813,7 +2775,6 @@ static int i40e_vc_get_stats_msg(struct i40e_vf *vf, u8 *msg)
  * i40e_check_vf_permission
  * @vf: pointer to the VF info
  * @al: MAC address list from virtchnl
- * @is_quiet: set true for printing msg without opcode info, false otherwise
  *
  * Check that the given list of MAC addresses is allowed. Will return -EPERM
  * if any address in the list is not valid. Checks the following conditions:
@@ -2828,15 +2789,13 @@ static int i40e_vc_get_stats_msg(struct i40e_vf *vf, u8 *msg)
  * addresses might not be accurate.
  **/
 static inline int i40e_check_vf_permission(struct i40e_vf *vf,
-					   struct virtchnl_ether_addr_list *al,
-					   bool *is_quiet)
+					   struct virtchnl_ether_addr_list *al)
 {
 	struct i40e_pf *pf = vf->pf;
 	struct i40e_vsi *vsi = pf->vsi[vf->lan_vsi_idx];
 	int mac2add_cnt = 0;
 	int i;
 
-	*is_quiet = false;
 	for (i = 0; i < al->num_elements; i++) {
 		struct i40e_mac_filter *f;
 		u8 *addr = al->list[i].addr;
@@ -2860,7 +2819,6 @@ static inline int i40e_check_vf_permission(struct i40e_vf *vf,
 		    !ether_addr_equal(addr, vf->default_lan_addr.addr)) {
 			dev_err(&pf->pdev->dev,
 				"VF attempting to override administratively set MAC address, bring down and up the VF interface to resume normal operation\n");
-			*is_quiet = true;
 			return -EPERM;
 		}
 
@@ -2897,7 +2855,6 @@ static int i40e_vc_add_mac_addr_msg(struct i40e_vf *vf, u8 *msg)
 	    (struct virtchnl_ether_addr_list *)msg;
 	struct i40e_pf *pf = vf->pf;
 	struct i40e_vsi *vsi = NULL;
-	bool is_quiet = false;
 	i40e_status ret = 0;
 	int i;
 
@@ -2914,7 +2871,7 @@ static int i40e_vc_add_mac_addr_msg(struct i40e_vf *vf, u8 *msg)
 	 */
 	spin_lock_bh(&vsi->mac_filter_hash_lock);
 
-	ret = i40e_check_vf_permission(vf, al, &is_quiet);
+	ret = i40e_check_vf_permission(vf, al);
 	if (ret) {
 		spin_unlock_bh(&vsi->mac_filter_hash_lock);
 		goto error_param;
@@ -2952,8 +2909,8 @@ static int i40e_vc_add_mac_addr_msg(struct i40e_vf *vf, u8 *msg)
 
 error_param:
 	/* send the response to the VF */
-	return i40e_vc_send_msg_to_vf_ex(vf, VIRTCHNL_OP_ADD_ETH_ADDR,
-				       ret, NULL, 0, is_quiet);
+	return i40e_vc_send_msg_to_vf(vf, VIRTCHNL_OP_ADD_ETH_ADDR,
+				      ret, NULL, 0);
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h
index 03c42fd0fea1..a554d0a0b09b 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h
@@ -10,8 +10,6 @@
 
 #define I40E_VIRTCHNL_SUPPORTED_QTYPES 2
 
-#define I40E_DEFAULT_NUM_INVALID_MSGS_ALLOWED	10
-
 #define I40E_VLAN_PRIORITY_SHIFT	13
 #define I40E_VLAN_MASK			0xFFF
 #define I40E_PRIORITY_MASK		0xE000
@@ -92,9 +90,6 @@ struct i40e_vf {
 	u8 num_queue_pairs;	/* num of qps assigned to VF vsis */
 	u8 num_req_queues;	/* num of requested qps */
 	u64 num_mdd_events;	/* num of mdd events detected */
-	/* num of continuous malformed or invalid msgs detected */
-	u64 num_invalid_msgs;
-	u64 num_valid_msgs;	/* num of valid msgs detected */
 
 	unsigned long vf_caps;	/* vf's adv. capabilities */
 	unsigned long vf_states;	/* vf's runtime states */
diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
index 8a1c293b8c7a..7013769fc038 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -1460,6 +1460,22 @@ void iavf_request_reset(struct iavf_adapter *adapter)
 	adapter->current_op = VIRTCHNL_OP_UNKNOWN;
 }
 
+/**
+ * iavf_netdev_features_vlan_strip_set - update vlan strip status
+ * @netdev: ptr to netdev being adjusted
+ * @enable: enable or disable vlan strip
+ *
+ * Helper function to change vlan strip status in netdev->features.
+ */
+static void iavf_netdev_features_vlan_strip_set(struct net_device *netdev,
+						const bool enable)
+{
+	if (enable)
+		netdev->features |= NETIF_F_HW_VLAN_CTAG_RX;
+	else
+		netdev->features &= ~NETIF_F_HW_VLAN_CTAG_RX;
+}
+
 /**
  * iavf_virtchnl_completion
  * @adapter: adapter structure
@@ -1683,8 +1699,18 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 			}
 			break;
 		case VIRTCHNL_OP_ENABLE_VLAN_STRIPPING:
+			dev_warn(&adapter->pdev->dev, "Changing VLAN Stripping is not allowed when Port VLAN is configured\n");
+			/* Vlan stripping could not be enabled by ethtool.
+			 * Disable it in netdev->features.
+			 */
+			iavf_netdev_features_vlan_strip_set(netdev, false);
+			break;
 		case VIRTCHNL_OP_DISABLE_VLAN_STRIPPING:
 			dev_warn(&adapter->pdev->dev, "Changing VLAN Stripping is not allowed when Port VLAN is configured\n");
+			/* Vlan stripping could not be disabled by ethtool.
+			 * Enable it in netdev->features.
+			 */
+			iavf_netdev_features_vlan_strip_set(netdev, true);
 			break;
 		default:
 			dev_err(&adapter->pdev->dev, "PF returned error %d (%s) to our request %d\n",
@@ -1918,6 +1944,20 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 		spin_unlock_bh(&adapter->adv_rss_lock);
 		}
 		break;
+	case VIRTCHNL_OP_ENABLE_VLAN_STRIPPING:
+		/* PF enabled vlan strip on this VF.
+		 * Update netdev->features if needed to be in sync with ethtool.
+		 */
+		if (!v_retval)
+			iavf_netdev_features_vlan_strip_set(netdev, true);
+		break;
+	case VIRTCHNL_OP_DISABLE_VLAN_STRIPPING:
+		/* PF disabled vlan strip on this VF.
+		 * Update netdev->features if needed to be in sync with ethtool.
+		 */
+		if (!v_retval)
+			iavf_netdev_features_vlan_strip_set(netdev, false);
+		break;
 	default:
 		if (adapter->current_op && (v_opcode != adapter->current_op))
 			dev_warn(&adapter->pdev->dev, "Expected response %d from PF, received %d\n",
diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 387322615e08..f23a741e30bf 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -398,6 +398,7 @@ enum ice_pf_flags {
 	ICE_FLAG_MDD_AUTO_RESET_VF,
 	ICE_FLAG_LINK_LENIENT_MODE_ENA,
 	ICE_FLAG_PLUG_AUX_DEV,
+	ICE_FLAG_MTU_CHANGED,
 	ICE_PF_FLAGS_NBITS		/* must be last */
 };
 
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index c451cf401e63..38c2d9a5574a 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -2275,7 +2275,7 @@ ice_set_link_ksettings(struct net_device *netdev,
 		goto done;
 	}
 
-	curr_link_speed = pi->phy.link_info.link_speed;
+	curr_link_speed = pi->phy.curr_user_speed_req;
 	adv_link_speed = ice_ksettings_find_adv_link_speed(ks);
 
 	/* If speed didn't get set, set it to what it currently is.
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 8a0c928853e6..137a054dd1e3 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2146,6 +2146,17 @@ static void ice_service_task(struct work_struct *work)
 	if (test_and_clear_bit(ICE_FLAG_PLUG_AUX_DEV, pf->flags))
 		ice_plug_aux_dev(pf);
 
+	if (test_and_clear_bit(ICE_FLAG_MTU_CHANGED, pf->flags)) {
+		struct iidc_event *event;
+
+		event = kzalloc(sizeof(*event), GFP_KERNEL);
+		if (event) {
+			set_bit(IIDC_EVENT_AFTER_MTU_CHANGE, event->type);
+			ice_send_event_to_aux(pf, event);
+			kfree(event);
+		}
+	}
+
 	ice_clean_adminq_subtask(pf);
 	ice_check_media_subtask(pf);
 	ice_check_for_hang_subtask(pf);
@@ -2863,7 +2874,7 @@ static irqreturn_t ice_misc_intr(int __always_unused irq, void *data)
 		struct iidc_event *event;
 
 		ena_mask &= ~ICE_AUX_CRIT_ERR;
-		event = kzalloc(sizeof(*event), GFP_KERNEL);
+		event = kzalloc(sizeof(*event), GFP_ATOMIC);
 		if (event) {
 			set_bit(IIDC_EVENT_CRIT_ERR, event->type);
 			/* report the entire OICR value to AUX driver */
@@ -6532,7 +6543,6 @@ static int ice_change_mtu(struct net_device *netdev, int new_mtu)
 	struct ice_netdev_priv *np = netdev_priv(netdev);
 	struct ice_vsi *vsi = np->vsi;
 	struct ice_pf *pf = vsi->back;
-	struct iidc_event *event;
 	u8 count = 0;
 	int err = 0;
 
@@ -6567,14 +6577,6 @@ static int ice_change_mtu(struct net_device *netdev, int new_mtu)
 		return -EBUSY;
 	}
 
-	event = kzalloc(sizeof(*event), GFP_KERNEL);
-	if (!event)
-		return -ENOMEM;
-
-	set_bit(IIDC_EVENT_BEFORE_MTU_CHANGE, event->type);
-	ice_send_event_to_aux(pf, event);
-	clear_bit(IIDC_EVENT_BEFORE_MTU_CHANGE, event->type);
-
 	netdev->mtu = (unsigned int)new_mtu;
 
 	/* if VSI is up, bring it down and then back up */
@@ -6582,21 +6584,18 @@ static int ice_change_mtu(struct net_device *netdev, int new_mtu)
 		err = ice_down(vsi);
 		if (err) {
 			netdev_err(netdev, "change MTU if_down err %d\n", err);
-			goto event_after;
+			return err;
 		}
 
 		err = ice_up(vsi);
 		if (err) {
 			netdev_err(netdev, "change MTU if_up err %d\n", err);
-			goto event_after;
+			return err;
 		}
 	}
 
 	netdev_dbg(netdev, "changed MTU to %d\n", new_mtu);
-event_after:
-	set_bit(IIDC_EVENT_AFTER_MTU_CHANGE, event->type);
-	ice_send_event_to_aux(pf, event);
-	kfree(event);
+	set_bit(ICE_FLAG_MTU_CHANGED, pf->flags);
 
 	return err;
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 4054adb5279c..4338e4ff7e85 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -2234,24 +2234,6 @@ ice_vc_send_msg_to_vf(struct ice_vf *vf, u32 v_opcode,
 
 	dev = ice_pf_to_dev(pf);
 
-	/* single place to detect unsuccessful return values */
-	if (v_retval) {
-		vf->num_inval_msgs++;
-		dev_info(dev, "VF %d failed opcode %d, retval: %d\n", vf->vf_id,
-			 v_opcode, v_retval);
-		if (vf->num_inval_msgs > ICE_DFLT_NUM_INVAL_MSGS_ALLOWED) {
-			dev_err(dev, "Number of invalid messages exceeded for VF %d\n",
-				vf->vf_id);
-			dev_err(dev, "Use PF Control I/F to enable the VF\n");
-			set_bit(ICE_VF_STATE_DIS, vf->vf_states);
-			return -EIO;
-		}
-	} else {
-		vf->num_valid_msgs++;
-		/* reset the invalid counter, if a valid message is received. */
-		vf->num_inval_msgs = 0;
-	}
-
 	aq_ret = ice_aq_send_msg_to_vf(&pf->hw, vf->vf_id, v_opcode, v_retval,
 				       msg, msglen, NULL);
 	if (aq_ret && pf->hw.mailboxq.sq_last_status != ICE_AQ_RC_ENOSYS) {
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
index a750e9a9d712..532f57f01467 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
@@ -14,7 +14,6 @@
 #define ICE_MAX_MACADDR_PER_VF		18
 
 /* Malicious Driver Detection */
-#define ICE_DFLT_NUM_INVAL_MSGS_ALLOWED		10
 #define ICE_MDD_EVENTS_THRESHOLD		30
 
 /* Static VF transaction/status register def */
@@ -107,8 +106,6 @@ struct ice_vf {
 	unsigned int tx_rate;		/* Tx bandwidth limit in Mbps */
 	DECLARE_BITMAP(vf_states, ICE_VF_STATES_NBITS);	/* VF runtime states */
 
-	u64 num_inval_msgs;		/* number of continuous invalid msgs */
-	u64 num_valid_msgs;		/* number of valid msgs detected */
 	unsigned long vf_caps;		/* VF's adv. capabilities */
 	u8 num_req_qs;			/* num of queue pairs requested by VF */
 	u16 num_mac;
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index aa543b29799e..656c68cfd7ec 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -492,6 +492,7 @@ static int prestera_switch_set_base_mac_addr(struct prestera_switch *sw)
 		dev_info(prestera_dev(sw), "using random base mac address\n");
 	}
 	of_node_put(base_mac_np);
+	of_node_put(np);
 
 	return prestera_hw_switch_mac_set(sw, sw->base_mac);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 00f63fbfe9b4..e06a6104e91f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -130,11 +130,8 @@ static int cmd_alloc_index(struct mlx5_cmd *cmd)
 
 static void cmd_free_index(struct mlx5_cmd *cmd, int idx)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&cmd->alloc_lock, flags);
+	lockdep_assert_held(&cmd->alloc_lock);
 	set_bit(idx, &cmd->bitmask);
-	spin_unlock_irqrestore(&cmd->alloc_lock, flags);
 }
 
 static void cmd_ent_get(struct mlx5_cmd_work_ent *ent)
@@ -144,17 +141,21 @@ static void cmd_ent_get(struct mlx5_cmd_work_ent *ent)
 
 static void cmd_ent_put(struct mlx5_cmd_work_ent *ent)
 {
+	struct mlx5_cmd *cmd = ent->cmd;
+	unsigned long flags;
+
+	spin_lock_irqsave(&cmd->alloc_lock, flags);
 	if (!refcount_dec_and_test(&ent->refcnt))
-		return;
+		goto out;
 
 	if (ent->idx >= 0) {
-		struct mlx5_cmd *cmd = ent->cmd;
-
 		cmd_free_index(cmd, ent->idx);
 		up(ent->page_queue ? &cmd->pages_sem : &cmd->sem);
 	}
 
 	cmd_free_ent(ent);
+out:
+	spin_unlock_irqrestore(&cmd->alloc_lock, flags);
 }
 
 static struct mlx5_cmd_layout *get_inst(struct mlx5_cmd *cmd, int idx)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c b/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
index 30282d86e6b9..cb0a48d374a3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
@@ -126,6 +126,10 @@ static void mlx5_lag_fib_route_event(struct mlx5_lag *ldev,
 		return;
 	}
 
+	/* Handle multipath entry with lower priority value */
+	if (mp->mfi && mp->mfi != fi && fi->fib_priority >= mp->mfi->fib_priority)
+		return;
+
 	/* Handle add/replace event */
 	nhs = fib_info_num_path(fi);
 	if (nhs == 1) {
@@ -135,12 +139,13 @@ static void mlx5_lag_fib_route_event(struct mlx5_lag *ldev,
 			int i = mlx5_lag_dev_get_netdev_idx(ldev, nh_dev);
 
 			if (i < 0)
-				i = MLX5_LAG_NORMAL_AFFINITY;
-			else
-				++i;
+				return;
 
+			i++;
 			mlx5_lag_set_port_affinity(ldev, i);
 		}
+
+		mp->mfi = fi;
 		return;
 	}
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
index 1e8ec4f236b2..df58cba37930 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
@@ -121,9 +121,6 @@ u32 mlx5_chains_get_nf_ft_chain(struct mlx5_fs_chains *chains)
 
 u32 mlx5_chains_get_prio_range(struct mlx5_fs_chains *chains)
 {
-	if (!mlx5_chains_prios_supported(chains))
-		return 1;
-
 	if (mlx5_chains_ignore_flow_level_supported(chains))
 		return UINT_MAX;
 
diff --git a/drivers/net/ethernet/nxp/lpc_eth.c b/drivers/net/ethernet/nxp/lpc_eth.c
index c910fa2f40a4..919140522885 100644
--- a/drivers/net/ethernet/nxp/lpc_eth.c
+++ b/drivers/net/ethernet/nxp/lpc_eth.c
@@ -1469,6 +1469,7 @@ static int lpc_eth_drv_resume(struct platform_device *pdev)
 {
 	struct net_device *ndev = platform_get_drvdata(pdev);
 	struct netdata_local *pldat;
+	int ret;
 
 	if (device_may_wakeup(&pdev->dev))
 		disable_irq_wake(ndev->irq);
@@ -1478,7 +1479,9 @@ static int lpc_eth_drv_resume(struct platform_device *pdev)
 			pldat = netdev_priv(ndev);
 
 			/* Enable interface clock */
-			clk_enable(pldat->clk);
+			ret = clk_enable(pldat->clk);
+			if (ret)
+				return ret;
 
 			/* Reset and initialize */
 			__lpc_eth_reset(pldat);
diff --git a/drivers/net/ethernet/qlogic/qed/qed_sriov.c b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
index ed2b6fe5a78d..998378ce9983 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_sriov.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
@@ -3778,11 +3778,11 @@ bool qed_iov_mark_vf_flr(struct qed_hwfn *p_hwfn, u32 *p_disabled_vfs)
 	return found;
 }
 
-static void qed_iov_get_link(struct qed_hwfn *p_hwfn,
-			     u16 vfid,
-			     struct qed_mcp_link_params *p_params,
-			     struct qed_mcp_link_state *p_link,
-			     struct qed_mcp_link_capabilities *p_caps)
+static int qed_iov_get_link(struct qed_hwfn *p_hwfn,
+			    u16 vfid,
+			    struct qed_mcp_link_params *p_params,
+			    struct qed_mcp_link_state *p_link,
+			    struct qed_mcp_link_capabilities *p_caps)
 {
 	struct qed_vf_info *p_vf = qed_iov_get_vf_info(p_hwfn,
 						       vfid,
@@ -3790,7 +3790,7 @@ static void qed_iov_get_link(struct qed_hwfn *p_hwfn,
 	struct qed_bulletin_content *p_bulletin;
 
 	if (!p_vf)
-		return;
+		return -EINVAL;
 
 	p_bulletin = p_vf->bulletin.p_virt;
 
@@ -3800,6 +3800,7 @@ static void qed_iov_get_link(struct qed_hwfn *p_hwfn,
 		__qed_vf_get_link_state(p_hwfn, p_link, p_bulletin);
 	if (p_caps)
 		__qed_vf_get_link_caps(p_hwfn, p_caps, p_bulletin);
+	return 0;
 }
 
 static int
@@ -4658,6 +4659,7 @@ static int qed_get_vf_config(struct qed_dev *cdev,
 	struct qed_public_vf_info *vf_info;
 	struct qed_mcp_link_state link;
 	u32 tx_rate;
+	int ret;
 
 	/* Sanitize request */
 	if (IS_VF(cdev))
@@ -4671,7 +4673,9 @@ static int qed_get_vf_config(struct qed_dev *cdev,
 
 	vf_info = qed_iov_get_public_vf_info(hwfn, vf_id, true);
 
-	qed_iov_get_link(hwfn, vf_id, NULL, &link, NULL);
+	ret = qed_iov_get_link(hwfn, vf_id, NULL, &link, NULL);
+	if (ret)
+		return ret;
 
 	/* Fill information about VF */
 	ivi->vf = vf_id;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_vf.c b/drivers/net/ethernet/qlogic/qed/qed_vf.c
index 72a38d53d33f..e2a5a6a373cb 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_vf.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_vf.c
@@ -513,6 +513,9 @@ int qed_vf_hw_prepare(struct qed_hwfn *p_hwfn)
 						    p_iov->bulletin.size,
 						    &p_iov->bulletin.phys,
 						    GFP_KERNEL);
+	if (!p_iov->bulletin.p_virt)
+		goto free_pf2vf_reply;
+
 	DP_VERBOSE(p_hwfn, QED_MSG_IOV,
 		   "VF's bulletin Board [%p virt 0x%llx phys 0x%08x bytes]\n",
 		   p_iov->bulletin.p_virt,
@@ -552,6 +555,10 @@ int qed_vf_hw_prepare(struct qed_hwfn *p_hwfn)
 
 	return rc;
 
+free_pf2vf_reply:
+	dma_free_coherent(&p_hwfn->cdev->pdev->dev,
+			  sizeof(union pfvf_tlvs),
+			  p_iov->pf2vf_reply, p_iov->pf2vf_reply_phys);
 free_vf2pf_request:
 	dma_free_coherent(&p_hwfn->cdev->pdev->dev,
 			  sizeof(union vfpf_tlvs),
diff --git a/drivers/net/ethernet/ti/cpts.c b/drivers/net/ethernet/ti/cpts.c
index 43222a34cba0..f9514518700e 100644
--- a/drivers/net/ethernet/ti/cpts.c
+++ b/drivers/net/ethernet/ti/cpts.c
@@ -568,7 +568,9 @@ int cpts_register(struct cpts *cpts)
 	for (i = 0; i < CPTS_MAX_EVENTS; i++)
 		list_add(&cpts->pool_data[i].list, &cpts->pool);
 
-	clk_enable(cpts->refclk);
+	err = clk_enable(cpts->refclk);
+	if (err)
+		return err;
 
 	cpts_write32(cpts, CPTS_EN, control);
 	cpts_write32(cpts, TS_PEND_EN, int_enable);
diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
index b780aad3550a..5524ac4fae80 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -1185,7 +1185,7 @@ static int xemaclite_of_probe(struct platform_device *ofdev)
 	if (rc) {
 		dev_err(dev,
 			"Cannot register network device, aborting\n");
-		goto error;
+		goto put_node;
 	}
 
 	dev_info(dev,
@@ -1193,6 +1193,8 @@ static int xemaclite_of_probe(struct platform_device *ofdev)
 		 (unsigned long __force)ndev->mem_start, lp->base_addr, ndev->irq);
 	return 0;
 
+put_node:
+	of_node_put(lp->phy_node);
 error:
 	free_netdev(ndev);
 	return rc;
diff --git a/drivers/net/phy/dp83822.c b/drivers/net/phy/dp83822.c
index 211b5476a6f5..ce17b2af3218 100644
--- a/drivers/net/phy/dp83822.c
+++ b/drivers/net/phy/dp83822.c
@@ -274,7 +274,7 @@ static int dp83822_config_intr(struct phy_device *phydev)
 		if (err < 0)
 			return err;
 
-		err = phy_write(phydev, MII_DP83822_MISR1, 0);
+		err = phy_write(phydev, MII_DP83822_MISR2, 0);
 		if (err < 0)
 			return err;
 
diff --git a/drivers/net/phy/meson-gxl.c b/drivers/net/phy/meson-gxl.c
index 7e7904fee1d9..73f7962a37d3 100644
--- a/drivers/net/phy/meson-gxl.c
+++ b/drivers/net/phy/meson-gxl.c
@@ -30,8 +30,12 @@
 #define  INTSRC_LINK_DOWN	BIT(4)
 #define  INTSRC_REMOTE_FAULT	BIT(5)
 #define  INTSRC_ANEG_COMPLETE	BIT(6)
+#define  INTSRC_ENERGY_DETECT	BIT(7)
 #define INTSRC_MASK	30
 
+#define INT_SOURCES (INTSRC_LINK_DOWN | INTSRC_ANEG_COMPLETE | \
+		     INTSRC_ENERGY_DETECT)
+
 #define BANK_ANALOG_DSP		0
 #define BANK_WOL		1
 #define BANK_BIST		3
@@ -200,7 +204,6 @@ static int meson_gxl_ack_interrupt(struct phy_device *phydev)
 
 static int meson_gxl_config_intr(struct phy_device *phydev)
 {
-	u16 val;
 	int ret;
 
 	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
@@ -209,16 +212,9 @@ static int meson_gxl_config_intr(struct phy_device *phydev)
 		if (ret)
 			return ret;
 
-		val = INTSRC_ANEG_PR
-			| INTSRC_PARALLEL_FAULT
-			| INTSRC_ANEG_LP_ACK
-			| INTSRC_LINK_DOWN
-			| INTSRC_REMOTE_FAULT
-			| INTSRC_ANEG_COMPLETE;
-		ret = phy_write(phydev, INTSRC_MASK, val);
+		ret = phy_write(phydev, INTSRC_MASK, INT_SOURCES);
 	} else {
-		val = 0;
-		ret = phy_write(phydev, INTSRC_MASK, val);
+		ret = phy_write(phydev, INTSRC_MASK, 0);
 
 		/* Ack any pending IRQ */
 		ret = meson_gxl_ack_interrupt(phydev);
@@ -237,10 +233,23 @@ static irqreturn_t meson_gxl_handle_interrupt(struct phy_device *phydev)
 		return IRQ_NONE;
 	}
 
+	irq_status &= INT_SOURCES;
+
 	if (irq_status == 0)
 		return IRQ_NONE;
 
-	phy_trigger_machine(phydev);
+	/* Aneg-complete interrupt is used for link-up detection */
+	if (phydev->autoneg == AUTONEG_ENABLE &&
+	    irq_status == INTSRC_ENERGY_DETECT)
+		return IRQ_HANDLED;
+
+	/* Give PHY some time before MAC starts sending data. This works
+	 * around an issue where network doesn't come up properly.
+	 */
+	if (!(irq_status & INTSRC_LINK_DOWN))
+		phy_queue_state_machine(phydev, msecs_to_jiffies(100));
+	else
+		phy_trigger_machine(phydev);
 
 	return IRQ_HANDLED;
 }
diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index 026e7487c45b..eb0d325e92b7 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -84,9 +84,10 @@ static int __must_check __smsc95xx_read_reg(struct usbnet *dev, u32 index,
 	ret = fn(dev, USB_VENDOR_REQUEST_READ_REGISTER, USB_DIR_IN
 		 | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 		 0, index, &buf, 4);
-	if (unlikely(ret < 0)) {
-		netdev_warn(dev->net, "Failed to read reg index 0x%08x: %d\n",
-			    index, ret);
+	if (ret < 0) {
+		if (ret != -ENODEV)
+			netdev_warn(dev->net, "Failed to read reg index 0x%08x: %d\n",
+				    index, ret);
 		return ret;
 	}
 
@@ -116,7 +117,7 @@ static int __must_check __smsc95xx_write_reg(struct usbnet *dev, u32 index,
 	ret = fn(dev, USB_VENDOR_REQUEST_WRITE_REGISTER, USB_DIR_OUT
 		 | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 		 0, index, &buf, 4);
-	if (unlikely(ret < 0))
+	if (ret < 0 && ret != -ENODEV)
 		netdev_warn(dev->net, "Failed to write reg index 0x%08x: %d\n",
 			    index, ret);
 
@@ -159,6 +160,9 @@ static int __must_check __smsc95xx_phy_wait_not_busy(struct usbnet *dev,
 	do {
 		ret = __smsc95xx_read_reg(dev, MII_ADDR, &val, in_pm);
 		if (ret < 0) {
+			/* Ignore -ENODEV error during disconnect() */
+			if (ret == -ENODEV)
+				return 0;
 			netdev_warn(dev->net, "Error reading MII_ACCESS\n");
 			return ret;
 		}
@@ -194,7 +198,8 @@ static int __smsc95xx_mdio_read(struct usbnet *dev, int phy_id, int idx,
 	addr = mii_address_cmd(phy_id, idx, MII_READ_ | MII_BUSY_);
 	ret = __smsc95xx_write_reg(dev, MII_ADDR, addr, in_pm);
 	if (ret < 0) {
-		netdev_warn(dev->net, "Error writing MII_ADDR\n");
+		if (ret != -ENODEV)
+			netdev_warn(dev->net, "Error writing MII_ADDR\n");
 		goto done;
 	}
 
@@ -206,7 +211,8 @@ static int __smsc95xx_mdio_read(struct usbnet *dev, int phy_id, int idx,
 
 	ret = __smsc95xx_read_reg(dev, MII_DATA, &val, in_pm);
 	if (ret < 0) {
-		netdev_warn(dev->net, "Error reading MII_DATA\n");
+		if (ret != -ENODEV)
+			netdev_warn(dev->net, "Error reading MII_DATA\n");
 		goto done;
 	}
 
@@ -214,6 +220,10 @@ static int __smsc95xx_mdio_read(struct usbnet *dev, int phy_id, int idx,
 
 done:
 	mutex_unlock(&dev->phy_mutex);
+
+	/* Ignore -ENODEV error during disconnect() */
+	if (ret == -ENODEV)
+		return 0;
 	return ret;
 }
 
@@ -235,7 +245,8 @@ static void __smsc95xx_mdio_write(struct usbnet *dev, int phy_id,
 	val = regval;
 	ret = __smsc95xx_write_reg(dev, MII_DATA, val, in_pm);
 	if (ret < 0) {
-		netdev_warn(dev->net, "Error writing MII_DATA\n");
+		if (ret != -ENODEV)
+			netdev_warn(dev->net, "Error writing MII_DATA\n");
 		goto done;
 	}
 
@@ -243,7 +254,8 @@ static void __smsc95xx_mdio_write(struct usbnet *dev, int phy_id,
 	addr = mii_address_cmd(phy_id, idx, MII_WRITE_ | MII_BUSY_);
 	ret = __smsc95xx_write_reg(dev, MII_ADDR, addr, in_pm);
 	if (ret < 0) {
-		netdev_warn(dev->net, "Error writing MII_ADDR\n");
+		if (ret != -ENODEV)
+			netdev_warn(dev->net, "Error writing MII_ADDR\n");
 		goto done;
 	}
 
diff --git a/drivers/net/xen-netback/xenbus.c b/drivers/net/xen-netback/xenbus.c
index d24b7a7993aa..990360d75cb6 100644
--- a/drivers/net/xen-netback/xenbus.c
+++ b/drivers/net/xen-netback/xenbus.c
@@ -256,6 +256,7 @@ static void backend_disconnect(struct backend_info *be)
 		unsigned int queue_index;
 
 		xen_unregister_watchers(vif);
+		xenbus_rm(XBT_NIL, be->dev->nodename, "hotplug-status");
 #ifdef CONFIG_DEBUG_FS
 		xenvif_debugfs_delif(vif);
 #endif /* CONFIG_DEBUG_FS */
@@ -675,7 +676,6 @@ static void hotplug_status_changed(struct xenbus_watch *watch,
 
 		/* Not interested in this watch anymore. */
 		unregister_hotplug_status_watch(be);
-		xenbus_rm(XBT_NIL, be->dev->nodename, "hotplug-status");
 	}
 	kfree(str);
 }
@@ -824,15 +824,11 @@ static void connect(struct backend_info *be)
 	xenvif_carrier_on(be->vif);
 
 	unregister_hotplug_status_watch(be);
-	if (xenbus_exists(XBT_NIL, dev->nodename, "hotplug-status")) {
-		err = xenbus_watch_pathfmt(dev, &be->hotplug_status_watch,
-					   NULL, hotplug_status_changed,
-					   "%s/%s", dev->nodename,
-					   "hotplug-status");
-		if (err)
-			goto err;
+	err = xenbus_watch_pathfmt(dev, &be->hotplug_status_watch, NULL,
+				   hotplug_status_changed,
+				   "%s/%s", dev->nodename, "hotplug-status");
+	if (!err)
 		be->have_hotplug_status_watch = 1;
-	}
 
 	netif_tx_wake_all_queues(be->vif->dev);
 
diff --git a/drivers/nfc/port100.c b/drivers/nfc/port100.c
index 16ceb763594f..90e30e2f1512 100644
--- a/drivers/nfc/port100.c
+++ b/drivers/nfc/port100.c
@@ -1612,7 +1612,9 @@ static int port100_probe(struct usb_interface *interface,
 	nfc_digital_free_device(dev->nfc_digital_dev);
 
 error:
+	usb_kill_urb(dev->in_urb);
 	usb_free_urb(dev->in_urb);
+	usb_kill_urb(dev->out_urb);
 	usb_free_urb(dev->out_urb);
 	usb_put_dev(dev->udev);
 
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 0663762ea69d..e7cd8b504535 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5344,11 +5344,6 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SERVERWORKS, 0x0422, quirk_no_ext_tags);
  */
 static void quirk_amd_harvest_no_ats(struct pci_dev *pdev)
 {
-	if ((pdev->device == 0x7312 && pdev->revision != 0x00) ||
-	    (pdev->device == 0x7340 && pdev->revision != 0xc5) ||
-	    (pdev->device == 0x7341 && pdev->revision != 0x00))
-		return;
-
 	if (pdev->device == 0x15d8) {
 		if (pdev->revision == 0xcf &&
 		    pdev->subsystem_vendor == 0xea50 &&
@@ -5370,10 +5365,19 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x98e4, quirk_amd_harvest_no_ats);
 /* AMD Iceland dGPU */
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x6900, quirk_amd_harvest_no_ats);
 /* AMD Navi10 dGPU */
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x7310, quirk_amd_harvest_no_ats);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x7312, quirk_amd_harvest_no_ats);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x7318, quirk_amd_harvest_no_ats);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x7319, quirk_amd_harvest_no_ats);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x731a, quirk_amd_harvest_no_ats);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x731b, quirk_amd_harvest_no_ats);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x731e, quirk_amd_harvest_no_ats);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x731f, quirk_amd_harvest_no_ats);
 /* AMD Navi14 dGPU */
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x7340, quirk_amd_harvest_no_ats);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x7341, quirk_amd_harvest_no_ats);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x7347, quirk_amd_harvest_no_ats);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x734f, quirk_amd_harvest_no_ats);
 /* AMD Raven platform iGPU */
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x15d8, quirk_amd_harvest_no_ats);
 #endif /* CONFIG_PCI_ATS */
diff --git a/drivers/pinctrl/intel/pinctrl-tigerlake.c b/drivers/pinctrl/intel/pinctrl-tigerlake.c
index 0bcd19597e4a..3ddaeffc0415 100644
--- a/drivers/pinctrl/intel/pinctrl-tigerlake.c
+++ b/drivers/pinctrl/intel/pinctrl-tigerlake.c
@@ -749,7 +749,6 @@ static const struct acpi_device_id tgl_pinctrl_acpi_match[] = {
 	{ "INT34C5", (kernel_ulong_t)&tgllp_soc_data },
 	{ "INT34C6", (kernel_ulong_t)&tglh_soc_data },
 	{ "INTC1055", (kernel_ulong_t)&tgllp_soc_data },
-	{ "INTC1057", (kernel_ulong_t)&tgllp_soc_data },
 	{ }
 };
 MODULE_DEVICE_TABLE(acpi, tgl_pinctrl_acpi_match);
diff --git a/drivers/s390/block/dasd_genhd.c b/drivers/s390/block/dasd_genhd.c
index fa966e0db6ca..3a6f3af240fa 100644
--- a/drivers/s390/block/dasd_genhd.c
+++ b/drivers/s390/block/dasd_genhd.c
@@ -14,6 +14,7 @@
 #define KMSG_COMPONENT "dasd"
 
 #include <linux/interrupt.h>
+#include <linux/major.h>
 #include <linux/fs.h>
 #include <linux/blkpg.h>
 
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 78ead3369779..564a21b5da9d 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -48,6 +48,7 @@
 #include <linux/blkpg.h>
 #include <linux/blk-pm.h>
 #include <linux/delay.h>
+#include <linux/major.h>
 #include <linux/mutex.h>
 #include <linux/string_helpers.h>
 #include <linux/async.h>
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 8f05248920e8..3c98f08dc25d 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -31,6 +31,7 @@ static int sg_version_num = 30536;	/* 2 digits for each component */
 #include <linux/errno.h>
 #include <linux/mtio.h>
 #include <linux/ioctl.h>
+#include <linux/major.h>
 #include <linux/slab.h>
 #include <linux/fcntl.h>
 #include <linux/init.h>
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 1203374828b9..973d6e079b02 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -44,6 +44,7 @@
 #include <linux/cdrom.h>
 #include <linux/interrupt.h>
 #include <linux/init.h>
+#include <linux/major.h>
 #include <linux/blkdev.h>
 #include <linux/blk-pm.h>
 #include <linux/mutex.h>
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index ae8636d3780b..9933722acfd9 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -32,6 +32,7 @@ static const char *verstr = "20160209";
 #include <linux/slab.h>
 #include <linux/errno.h>
 #include <linux/mtio.h>
+#include <linux/major.h>
 #include <linux/cdrom.h>
 #include <linux/ioctl.h>
 #include <linux/fcntl.h>
diff --git a/drivers/spi/spi-rockchip.c b/drivers/spi/spi-rockchip.c
index 553b6b9d0222..c6a1bb09be05 100644
--- a/drivers/spi/spi-rockchip.c
+++ b/drivers/spi/spi-rockchip.c
@@ -585,6 +585,12 @@ static int rockchip_spi_slave_abort(struct spi_controller *ctlr)
 {
 	struct rockchip_spi *rs = spi_controller_get_devdata(ctlr);
 
+	if (atomic_read(&rs->state) & RXDMA)
+		dmaengine_terminate_sync(ctlr->dma_rx);
+	if (atomic_read(&rs->state) & TXDMA)
+		dmaengine_terminate_sync(ctlr->dma_tx);
+	atomic_set(&rs->state, 0);
+	spi_enable_chip(rs, false);
 	rs->slave_abort = true;
 	spi_finalize_current_transfer(ctlr);
 
@@ -654,7 +660,7 @@ static int rockchip_spi_probe(struct platform_device *pdev)
 	struct spi_controller *ctlr;
 	struct resource *mem;
 	struct device_node *np = pdev->dev.of_node;
-	u32 rsd_nsecs;
+	u32 rsd_nsecs, num_cs;
 	bool slave_mode;
 
 	slave_mode = of_property_read_bool(np, "spi-slave");
@@ -764,8 +770,9 @@ static int rockchip_spi_probe(struct platform_device *pdev)
 		 * rk spi0 has two native cs, spi1..5 one cs only
 		 * if num-cs is missing in the dts, default to 1
 		 */
-		if (of_property_read_u16(np, "num-cs", &ctlr->num_chipselect))
-			ctlr->num_chipselect = 1;
+		if (of_property_read_u32(np, "num-cs", &num_cs))
+			num_cs = 1;
+		ctlr->num_chipselect = num_cs;
 		ctlr->use_gpio_descriptors = true;
 	}
 	ctlr->dev.of_node = pdev->dev.of_node;
diff --git a/drivers/staging/gdm724x/gdm_lte.c b/drivers/staging/gdm724x/gdm_lte.c
index e390c924ec1c..3c680ed4429c 100644
--- a/drivers/staging/gdm724x/gdm_lte.c
+++ b/drivers/staging/gdm724x/gdm_lte.c
@@ -76,14 +76,15 @@ static void tx_complete(void *arg)
 
 static int gdm_lte_rx(struct sk_buff *skb, struct nic *nic, int nic_type)
 {
-	int ret;
+	int ret, len;
 
+	len = skb->len + ETH_HLEN;
 	ret = netif_rx_ni(skb);
 	if (ret == NET_RX_DROP) {
 		nic->stats.rx_dropped++;
 	} else {
 		nic->stats.rx_packets++;
-		nic->stats.rx_bytes += skb->len + ETH_HLEN;
+		nic->stats.rx_bytes += len;
 	}
 
 	return 0;
diff --git a/drivers/staging/rtl8723bs/core/rtw_mlme_ext.c b/drivers/staging/rtl8723bs/core/rtw_mlme_ext.c
index ad9c237054c4..1a4b4c75c4bf 100644
--- a/drivers/staging/rtl8723bs/core/rtw_mlme_ext.c
+++ b/drivers/staging/rtl8723bs/core/rtw_mlme_ext.c
@@ -5915,6 +5915,7 @@ u8 chk_bmc_sleepq_hdl(struct adapter *padapter, unsigned char *pbuf)
 	struct sta_info *psta_bmc;
 	struct list_head *xmitframe_plist, *xmitframe_phead, *tmp;
 	struct xmit_frame *pxmitframe = NULL;
+	struct xmit_priv *pxmitpriv = &padapter->xmitpriv;
 	struct sta_priv  *pstapriv = &padapter->stapriv;
 
 	/* for BC/MC Frames */
@@ -5925,7 +5926,8 @@ u8 chk_bmc_sleepq_hdl(struct adapter *padapter, unsigned char *pbuf)
 	if ((pstapriv->tim_bitmap&BIT(0)) && (psta_bmc->sleepq_len > 0)) {
 		msleep(10);/*  10ms, ATIM(HIQ) Windows */
 
-		spin_lock_bh(&psta_bmc->sleep_q.lock);
+		/* spin_lock_bh(&psta_bmc->sleep_q.lock); */
+		spin_lock_bh(&pxmitpriv->lock);
 
 		xmitframe_phead = get_list_head(&psta_bmc->sleep_q);
 		list_for_each_safe(xmitframe_plist, tmp, xmitframe_phead) {
@@ -5948,7 +5950,8 @@ u8 chk_bmc_sleepq_hdl(struct adapter *padapter, unsigned char *pbuf)
 			rtw_hal_xmitframe_enqueue(padapter, pxmitframe);
 		}
 
-		spin_unlock_bh(&psta_bmc->sleep_q.lock);
+		/* spin_unlock_bh(&psta_bmc->sleep_q.lock); */
+		spin_unlock_bh(&pxmitpriv->lock);
 
 		/* check hi queue and bmc_sleepq */
 		rtw_chk_hi_queue_cmd(padapter);
diff --git a/drivers/staging/rtl8723bs/core/rtw_recv.c b/drivers/staging/rtl8723bs/core/rtw_recv.c
index 3564e2af5741..5b0a596eefb7 100644
--- a/drivers/staging/rtl8723bs/core/rtw_recv.c
+++ b/drivers/staging/rtl8723bs/core/rtw_recv.c
@@ -953,8 +953,10 @@ static signed int validate_recv_ctrl_frame(struct adapter *padapter, union recv_
 		if ((psta->state&WIFI_SLEEP_STATE) && (pstapriv->sta_dz_bitmap&BIT(psta->aid))) {
 			struct list_head	*xmitframe_plist, *xmitframe_phead;
 			struct xmit_frame *pxmitframe = NULL;
+			struct xmit_priv *pxmitpriv = &padapter->xmitpriv;
 
-			spin_lock_bh(&psta->sleep_q.lock);
+			/* spin_lock_bh(&psta->sleep_q.lock); */
+			spin_lock_bh(&pxmitpriv->lock);
 
 			xmitframe_phead = get_list_head(&psta->sleep_q);
 			xmitframe_plist = get_next(xmitframe_phead);
@@ -985,10 +987,12 @@ static signed int validate_recv_ctrl_frame(struct adapter *padapter, union recv_
 					update_beacon(padapter, WLAN_EID_TIM, NULL, true);
 				}
 
-				spin_unlock_bh(&psta->sleep_q.lock);
+				/* spin_unlock_bh(&psta->sleep_q.lock); */
+				spin_unlock_bh(&pxmitpriv->lock);
 
 			} else {
-				spin_unlock_bh(&psta->sleep_q.lock);
+				/* spin_unlock_bh(&psta->sleep_q.lock); */
+				spin_unlock_bh(&pxmitpriv->lock);
 
 				if (pstapriv->tim_bitmap&BIT(psta->aid)) {
 					if (psta->sleepq_len == 0) {
diff --git a/drivers/staging/rtl8723bs/core/rtw_sta_mgt.c b/drivers/staging/rtl8723bs/core/rtw_sta_mgt.c
index 3d269842677d..5eae3ccb1ff5 100644
--- a/drivers/staging/rtl8723bs/core/rtw_sta_mgt.c
+++ b/drivers/staging/rtl8723bs/core/rtw_sta_mgt.c
@@ -288,48 +288,46 @@ u32 rtw_free_stainfo(struct adapter *padapter, struct sta_info *psta)
 
 	/* list_del_init(&psta->wakeup_list); */
 
-	spin_lock_bh(&psta->sleep_q.lock);
+	spin_lock_bh(&pxmitpriv->lock);
+
 	rtw_free_xmitframe_queue(pxmitpriv, &psta->sleep_q);
 	psta->sleepq_len = 0;
-	spin_unlock_bh(&psta->sleep_q.lock);
-
-	spin_lock_bh(&pxmitpriv->lock);
 
 	/* vo */
-	spin_lock_bh(&pstaxmitpriv->vo_q.sta_pending.lock);
+	/* spin_lock_bh(&(pxmitpriv->vo_pending.lock)); */
 	rtw_free_xmitframe_queue(pxmitpriv, &pstaxmitpriv->vo_q.sta_pending);
 	list_del_init(&(pstaxmitpriv->vo_q.tx_pending));
 	phwxmit = pxmitpriv->hwxmits;
 	phwxmit->accnt -= pstaxmitpriv->vo_q.qcnt;
 	pstaxmitpriv->vo_q.qcnt = 0;
-	spin_unlock_bh(&pstaxmitpriv->vo_q.sta_pending.lock);
+	/* spin_unlock_bh(&(pxmitpriv->vo_pending.lock)); */
 
 	/* vi */
-	spin_lock_bh(&pstaxmitpriv->vi_q.sta_pending.lock);
+	/* spin_lock_bh(&(pxmitpriv->vi_pending.lock)); */
 	rtw_free_xmitframe_queue(pxmitpriv, &pstaxmitpriv->vi_q.sta_pending);
 	list_del_init(&(pstaxmitpriv->vi_q.tx_pending));
 	phwxmit = pxmitpriv->hwxmits+1;
 	phwxmit->accnt -= pstaxmitpriv->vi_q.qcnt;
 	pstaxmitpriv->vi_q.qcnt = 0;
-	spin_unlock_bh(&pstaxmitpriv->vi_q.sta_pending.lock);
+	/* spin_unlock_bh(&(pxmitpriv->vi_pending.lock)); */
 
 	/* be */
-	spin_lock_bh(&pstaxmitpriv->be_q.sta_pending.lock);
+	/* spin_lock_bh(&(pxmitpriv->be_pending.lock)); */
 	rtw_free_xmitframe_queue(pxmitpriv, &pstaxmitpriv->be_q.sta_pending);
 	list_del_init(&(pstaxmitpriv->be_q.tx_pending));
 	phwxmit = pxmitpriv->hwxmits+2;
 	phwxmit->accnt -= pstaxmitpriv->be_q.qcnt;
 	pstaxmitpriv->be_q.qcnt = 0;
-	spin_unlock_bh(&pstaxmitpriv->be_q.sta_pending.lock);
+	/* spin_unlock_bh(&(pxmitpriv->be_pending.lock)); */
 
 	/* bk */
-	spin_lock_bh(&pstaxmitpriv->bk_q.sta_pending.lock);
+	/* spin_lock_bh(&(pxmitpriv->bk_pending.lock)); */
 	rtw_free_xmitframe_queue(pxmitpriv, &pstaxmitpriv->bk_q.sta_pending);
 	list_del_init(&(pstaxmitpriv->bk_q.tx_pending));
 	phwxmit = pxmitpriv->hwxmits+3;
 	phwxmit->accnt -= pstaxmitpriv->bk_q.qcnt;
 	pstaxmitpriv->bk_q.qcnt = 0;
-	spin_unlock_bh(&pstaxmitpriv->bk_q.sta_pending.lock);
+	/* spin_unlock_bh(&(pxmitpriv->bk_pending.lock)); */
 
 	spin_unlock_bh(&pxmitpriv->lock);
 
diff --git a/drivers/staging/rtl8723bs/core/rtw_xmit.c b/drivers/staging/rtl8723bs/core/rtw_xmit.c
index 6b37b42ec226..79e4d7df1ef5 100644
--- a/drivers/staging/rtl8723bs/core/rtw_xmit.c
+++ b/drivers/staging/rtl8723bs/core/rtw_xmit.c
@@ -1723,12 +1723,15 @@ void rtw_free_xmitframe_queue(struct xmit_priv *pxmitpriv, struct __queue *pfram
 	struct list_head *plist, *phead, *tmp;
 	struct	xmit_frame	*pxmitframe;
 
+	spin_lock_bh(&pframequeue->lock);
+
 	phead = get_list_head(pframequeue);
 	list_for_each_safe(plist, tmp, phead) {
 		pxmitframe = list_entry(plist, struct xmit_frame, list);
 
 		rtw_free_xmitframe(pxmitpriv, pxmitframe);
 	}
+	spin_unlock_bh(&pframequeue->lock);
 }
 
 s32 rtw_xmitframe_enqueue(struct adapter *padapter, struct xmit_frame *pxmitframe)
@@ -1783,7 +1786,6 @@ s32 rtw_xmit_classifier(struct adapter *padapter, struct xmit_frame *pxmitframe)
 	struct sta_info *psta;
 	struct tx_servq	*ptxservq;
 	struct pkt_attrib	*pattrib = &pxmitframe->attrib;
-	struct xmit_priv *xmit_priv = &padapter->xmitpriv;
 	struct hw_xmit	*phwxmits =  padapter->xmitpriv.hwxmits;
 	signed int res = _SUCCESS;
 
@@ -1801,14 +1803,12 @@ s32 rtw_xmit_classifier(struct adapter *padapter, struct xmit_frame *pxmitframe)
 
 	ptxservq = rtw_get_sta_pending(padapter, psta, pattrib->priority, (u8 *)(&ac_index));
 
-	spin_lock_bh(&xmit_priv->lock);
 	if (list_empty(&ptxservq->tx_pending))
 		list_add_tail(&ptxservq->tx_pending, get_list_head(phwxmits[ac_index].sta_queue));
 
 	list_add_tail(&pxmitframe->list, get_list_head(&ptxservq->sta_pending));
 	ptxservq->qcnt++;
 	phwxmits[ac_index].accnt++;
-	spin_unlock_bh(&xmit_priv->lock);
 
 exit:
 
@@ -2191,10 +2191,11 @@ void wakeup_sta_to_xmit(struct adapter *padapter, struct sta_info *psta)
 	struct list_head *xmitframe_plist, *xmitframe_phead, *tmp;
 	struct xmit_frame *pxmitframe = NULL;
 	struct sta_priv *pstapriv = &padapter->stapriv;
+	struct xmit_priv *pxmitpriv = &padapter->xmitpriv;
 
 	psta_bmc = rtw_get_bcmc_stainfo(padapter);
 
-	spin_lock_bh(&psta->sleep_q.lock);
+	spin_lock_bh(&pxmitpriv->lock);
 
 	xmitframe_phead = get_list_head(&psta->sleep_q);
 	list_for_each_safe(xmitframe_plist, tmp, xmitframe_phead) {
@@ -2295,7 +2296,7 @@ void wakeup_sta_to_xmit(struct adapter *padapter, struct sta_info *psta)
 
 _exit:
 
-	spin_unlock_bh(&psta->sleep_q.lock);
+	spin_unlock_bh(&pxmitpriv->lock);
 
 	if (update_mask)
 		update_beacon(padapter, WLAN_EID_TIM, NULL, true);
@@ -2307,8 +2308,9 @@ void xmit_delivery_enabled_frames(struct adapter *padapter, struct sta_info *pst
 	struct list_head *xmitframe_plist, *xmitframe_phead, *tmp;
 	struct xmit_frame *pxmitframe = NULL;
 	struct sta_priv *pstapriv = &padapter->stapriv;
+	struct xmit_priv *pxmitpriv = &padapter->xmitpriv;
 
-	spin_lock_bh(&psta->sleep_q.lock);
+	spin_lock_bh(&pxmitpriv->lock);
 
 	xmitframe_phead = get_list_head(&psta->sleep_q);
 	list_for_each_safe(xmitframe_plist, tmp, xmitframe_phead) {
@@ -2361,7 +2363,7 @@ void xmit_delivery_enabled_frames(struct adapter *padapter, struct sta_info *pst
 		}
 	}
 
-	spin_unlock_bh(&psta->sleep_q.lock);
+	spin_unlock_bh(&pxmitpriv->lock);
 }
 
 void enqueue_pending_xmitbuf(struct xmit_priv *pxmitpriv, struct xmit_buf *pxmitbuf)
diff --git a/drivers/staging/rtl8723bs/hal/rtl8723bs_xmit.c b/drivers/staging/rtl8723bs/hal/rtl8723bs_xmit.c
index 5f5c4719b586..156d6aba18ca 100644
--- a/drivers/staging/rtl8723bs/hal/rtl8723bs_xmit.c
+++ b/drivers/staging/rtl8723bs/hal/rtl8723bs_xmit.c
@@ -507,7 +507,9 @@ s32 rtl8723bs_hal_xmit(
 			rtw_issue_addbareq_cmd(padapter, pxmitframe);
 	}
 
+	spin_lock_bh(&pxmitpriv->lock);
 	err = rtw_xmitframe_enqueue(padapter, pxmitframe);
+	spin_unlock_bh(&pxmitpriv->lock);
 	if (err != _SUCCESS) {
 		rtw_free_xmitframe(pxmitpriv, pxmitframe);
 
diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
index 1ecedbb1684c..06d0e88ec8af 100644
--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -43,6 +43,7 @@
 #define PCI_DEVICE_ID_INTEL_ADLP		0x51ee
 #define PCI_DEVICE_ID_INTEL_ADLM		0x54ee
 #define PCI_DEVICE_ID_INTEL_ADLS		0x7ae1
+#define PCI_DEVICE_ID_INTEL_RPLS		0x7a61
 #define PCI_DEVICE_ID_INTEL_TGL			0x9a15
 #define PCI_DEVICE_ID_AMD_MR			0x163a
 
@@ -420,6 +421,9 @@ static const struct pci_device_id dwc3_pci_id_table[] = {
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_ADLS),
 	  (kernel_ulong_t) &dwc3_pci_intel_swnode, },
 
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_RPLS),
+	  (kernel_ulong_t) &dwc3_pci_intel_swnode, },
+
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_TGL),
 	  (kernel_ulong_t) &dwc3_pci_intel_swnode, },
 
diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 1afbda216df5..902aad29456f 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1529,11 +1529,27 @@ static virtio_net_ctrl_ack handle_ctrl_mq(struct mlx5_vdpa_dev *mvdev, u8 cmd)
 
 	switch (cmd) {
 	case VIRTIO_NET_CTRL_MQ_VQ_PAIRS_SET:
+		/* This mq feature check aligns with pre-existing userspace
+		 * implementation.
+		 *
+		 * Without it, an untrusted driver could fake a multiqueue config
+		 * request down to a non-mq device that may cause kernel to
+		 * panic due to uninitialized resources for extra vqs. Even with
+		 * a well behaving guest driver, it is not expected to allow
+		 * changing the number of vqs on a non-mq device.
+		 */
+		if (!MLX5_FEATURE(mvdev, VIRTIO_NET_F_MQ))
+			break;
+
 		read = vringh_iov_pull_iotlb(&cvq->vring, &cvq->riov, (void *)&mq, sizeof(mq));
 		if (read != sizeof(mq))
 			break;
 
 		newqps = mlx5vdpa16_to_cpu(mvdev, mq.virtqueue_pairs);
+		if (newqps < VIRTIO_NET_CTRL_MQ_VQ_PAIRS_MIN ||
+		    newqps > mlx5_vdpa_max_qps(mvdev->max_vqs))
+			break;
+
 		if (ndev->cur_num_vqs == 2 * newqps) {
 			status = VIRTIO_NET_OK;
 			break;
diff --git a/drivers/vdpa/vdpa_user/iova_domain.c b/drivers/vdpa/vdpa_user/iova_domain.c
index 1daae2608860..0678c2514197 100644
--- a/drivers/vdpa/vdpa_user/iova_domain.c
+++ b/drivers/vdpa/vdpa_user/iova_domain.c
@@ -302,7 +302,7 @@ vduse_domain_alloc_iova(struct iova_domain *iovad,
 		iova_len = roundup_pow_of_two(iova_len);
 	iova_pfn = alloc_iova_fast(iovad, iova_len, limit >> shift, true);
 
-	return iova_pfn << shift;
+	return (dma_addr_t)iova_pfn << shift;
 }
 
 static void vduse_domain_free_iova(struct iova_domain *iovad,
diff --git a/drivers/vdpa/virtio_pci/vp_vdpa.c b/drivers/vdpa/virtio_pci/vp_vdpa.c
index 5bcd00246d2e..dead832b4571 100644
--- a/drivers/vdpa/virtio_pci/vp_vdpa.c
+++ b/drivers/vdpa/virtio_pci/vp_vdpa.c
@@ -513,8 +513,8 @@ static void vp_vdpa_remove(struct pci_dev *pdev)
 {
 	struct vp_vdpa *vp_vdpa = pci_get_drvdata(pdev);
 
-	vdpa_unregister_device(&vp_vdpa->vdpa);
 	vp_modern_remove(&vp_vdpa->mdev);
+	vdpa_unregister_device(&vp_vdpa->vdpa);
 }
 
 static struct pci_driver vp_vdpa_driver = {
diff --git a/drivers/vhost/iotlb.c b/drivers/vhost/iotlb.c
index 670d56c879e5..40b098320b2a 100644
--- a/drivers/vhost/iotlb.c
+++ b/drivers/vhost/iotlb.c
@@ -57,6 +57,17 @@ int vhost_iotlb_add_range_ctx(struct vhost_iotlb *iotlb,
 	if (last < start)
 		return -EFAULT;
 
+	/* If the range being mapped is [0, ULONG_MAX], split it into two entries
+	 * otherwise its size would overflow u64.
+	 */
+	if (start == 0 && last == ULONG_MAX) {
+		u64 mid = last / 2;
+
+		vhost_iotlb_add_range_ctx(iotlb, start, mid, addr, perm, opaque);
+		addr += mid + 1;
+		start = mid + 1;
+	}
+
 	if (iotlb->limit &&
 	    iotlb->nmaps == iotlb->limit &&
 	    iotlb->flags & VHOST_IOTLB_FLAG_RETIRE) {
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 59edb5a1ffe2..6942472cffb0 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1170,6 +1170,13 @@ ssize_t vhost_chr_write_iter(struct vhost_dev *dev,
 		goto done;
 	}
 
+	if ((msg.type == VHOST_IOTLB_UPDATE ||
+	     msg.type == VHOST_IOTLB_INVALIDATE) &&
+	     msg.size == 0) {
+		ret = -EINVAL;
+		goto done;
+	}
+
 	if (dev->msg_handler)
 		ret = dev->msg_handler(dev, &msg);
 	else
diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index 236081afe9a2..c2b733ef95b0 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -166,14 +166,13 @@ void virtio_add_status(struct virtio_device *dev, unsigned int status)
 }
 EXPORT_SYMBOL_GPL(virtio_add_status);
 
-int virtio_finalize_features(struct virtio_device *dev)
+/* Do some validation, then set FEATURES_OK */
+static int virtio_features_ok(struct virtio_device *dev)
 {
-	int ret = dev->config->finalize_features(dev);
 	unsigned status;
+	int ret;
 
 	might_sleep();
-	if (ret)
-		return ret;
 
 	ret = arch_has_restricted_virtio_memory_access();
 	if (ret) {
@@ -202,7 +201,6 @@ int virtio_finalize_features(struct virtio_device *dev)
 	}
 	return 0;
 }
-EXPORT_SYMBOL_GPL(virtio_finalize_features);
 
 static int virtio_dev_probe(struct device *_d)
 {
@@ -239,17 +237,6 @@ static int virtio_dev_probe(struct device *_d)
 		driver_features_legacy = driver_features;
 	}
 
-	/*
-	 * Some devices detect legacy solely via F_VERSION_1. Write
-	 * F_VERSION_1 to force LE config space accesses before FEATURES_OK for
-	 * these when needed.
-	 */
-	if (drv->validate && !virtio_legacy_is_little_endian()
-			  && device_features & BIT_ULL(VIRTIO_F_VERSION_1)) {
-		dev->features = BIT_ULL(VIRTIO_F_VERSION_1);
-		dev->config->finalize_features(dev);
-	}
-
 	if (device_features & (1ULL << VIRTIO_F_VERSION_1))
 		dev->features = driver_features & device_features;
 	else
@@ -260,13 +247,26 @@ static int virtio_dev_probe(struct device *_d)
 		if (device_features & (1ULL << i))
 			__virtio_set_bit(dev, i);
 
+	err = dev->config->finalize_features(dev);
+	if (err)
+		goto err;
+
 	if (drv->validate) {
+		u64 features = dev->features;
+
 		err = drv->validate(dev);
 		if (err)
 			goto err;
+
+		/* Did validation change any features? Then write them again. */
+		if (features != dev->features) {
+			err = dev->config->finalize_features(dev);
+			if (err)
+				goto err;
+		}
 	}
 
-	err = virtio_finalize_features(dev);
+	err = virtio_features_ok(dev);
 	if (err)
 		goto err;
 
@@ -490,7 +490,11 @@ int virtio_device_restore(struct virtio_device *dev)
 	/* We have a driver! */
 	virtio_add_status(dev, VIRTIO_CONFIG_S_DRIVER);
 
-	ret = virtio_finalize_features(dev);
+	ret = dev->config->finalize_features(dev);
+	if (ret)
+		goto err;
+
+	ret = virtio_features_ok(dev);
 	if (ret)
 		goto err;
 
diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index d721c66d0b41..5edd07e0232d 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1491,7 +1491,6 @@ void btrfs_reclaim_bgs_work(struct work_struct *work)
 		container_of(work, struct btrfs_fs_info, reclaim_bgs_work);
 	struct btrfs_block_group *bg;
 	struct btrfs_space_info *space_info;
-	LIST_HEAD(again_list);
 
 	if (!test_bit(BTRFS_FS_OPEN, &fs_info->flags))
 		return;
@@ -1562,18 +1561,14 @@ void btrfs_reclaim_bgs_work(struct work_struct *work)
 				div64_u64(zone_unusable * 100, bg->length));
 		trace_btrfs_reclaim_block_group(bg);
 		ret = btrfs_relocate_chunk(fs_info, bg->start);
-		if (ret && ret != -EAGAIN)
+		if (ret)
 			btrfs_err(fs_info, "error relocating chunk %llu",
 				  bg->start);
 
 next:
+		btrfs_put_block_group(bg);
 		spin_lock(&fs_info->unused_bgs_lock);
-		if (ret == -EAGAIN && list_empty(&bg->bg_list))
-			list_add_tail(&bg->bg_list, &again_list);
-		else
-			btrfs_put_block_group(bg);
 	}
-	list_splice_tail(&again_list, &fs_info->reclaim_bgs);
 	spin_unlock(&fs_info->unused_bgs_lock);
 	mutex_unlock(&fs_info->reclaim_bgs_lock);
 	btrfs_exclop_finish(fs_info);
diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 95a6a63caf04..899f85445925 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1566,32 +1566,13 @@ static struct extent_buffer *btrfs_search_slot_get_root(struct btrfs_root *root,
 							struct btrfs_path *p,
 							int write_lock_level)
 {
-	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct extent_buffer *b;
 	int root_lock = 0;
 	int level = 0;
 
 	if (p->search_commit_root) {
-		/*
-		 * The commit roots are read only so we always do read locks,
-		 * and we always must hold the commit_root_sem when doing
-		 * searches on them, the only exception is send where we don't
-		 * want to block transaction commits for a long time, so
-		 * we need to clone the commit root in order to avoid races
-		 * with transaction commits that create a snapshot of one of
-		 * the roots used by a send operation.
-		 */
-		if (p->need_commit_sem) {
-			down_read(&fs_info->commit_root_sem);
-			b = btrfs_clone_extent_buffer(root->commit_root);
-			up_read(&fs_info->commit_root_sem);
-			if (!b)
-				return ERR_PTR(-ENOMEM);
-
-		} else {
-			b = root->commit_root;
-			atomic_inc(&b->refs);
-		}
+		b = root->commit_root;
+		atomic_inc(&b->refs);
 		level = btrfs_header_level(b);
 		/*
 		 * Ensure that all callers have set skip_locking when
@@ -1657,6 +1638,42 @@ static struct extent_buffer *btrfs_search_slot_get_root(struct btrfs_root *root,
 	return b;
 }
 
+/*
+ * Replace the extent buffer at the lowest level of the path with a cloned
+ * version. The purpose is to be able to use it safely, after releasing the
+ * commit root semaphore, even if relocation is happening in parallel, the
+ * transaction used for relocation is committed and the extent buffer is
+ * reallocated in the next transaction.
+ *
+ * This is used in a context where the caller does not prevent transaction
+ * commits from happening, either by holding a transaction handle or holding
+ * some lock, while it's doing searches through a commit root.
+ * At the moment it's only used for send operations.
+ */
+static int finish_need_commit_sem_search(struct btrfs_path *path)
+{
+	const int i = path->lowest_level;
+	const int slot = path->slots[i];
+	struct extent_buffer *lowest = path->nodes[i];
+	struct extent_buffer *clone;
+
+	ASSERT(path->need_commit_sem);
+
+	if (!lowest)
+		return 0;
+
+	lockdep_assert_held_read(&lowest->fs_info->commit_root_sem);
+
+	clone = btrfs_clone_extent_buffer(lowest);
+	if (!clone)
+		return -ENOMEM;
+
+	btrfs_release_path(path);
+	path->nodes[i] = clone;
+	path->slots[i] = slot;
+
+	return 0;
+}
 
 /*
  * btrfs_search_slot - look for a key in a tree and perform necessary
@@ -1693,6 +1710,7 @@ int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		      const struct btrfs_key *key, struct btrfs_path *p,
 		      int ins_len, int cow)
 {
+	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct extent_buffer *b;
 	int slot;
 	int ret;
@@ -1734,6 +1752,11 @@ int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 
 	min_write_lock_level = write_lock_level;
 
+	if (p->need_commit_sem) {
+		ASSERT(p->search_commit_root);
+		down_read(&fs_info->commit_root_sem);
+	}
+
 again:
 	prev_cmp = -1;
 	b = btrfs_search_slot_get_root(root, p, write_lock_level);
@@ -1928,6 +1951,16 @@ int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 done:
 	if (ret < 0 && !p->skip_release_on_error)
 		btrfs_release_path(p);
+
+	if (p->need_commit_sem) {
+		int ret2;
+
+		ret2 = finish_need_commit_sem_search(p);
+		up_read(&fs_info->commit_root_sem);
+		if (ret2)
+			ret = ret2;
+	}
+
 	return ret;
 }
 ALLOW_ERROR_INJECTION(btrfs_search_slot, ERRNO);
@@ -4396,7 +4429,9 @@ int btrfs_next_old_leaf(struct btrfs_root *root, struct btrfs_path *path,
 	int level;
 	struct extent_buffer *c;
 	struct extent_buffer *next;
+	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_key key;
+	bool need_commit_sem = false;
 	u32 nritems;
 	int ret;
 	int i;
@@ -4413,14 +4448,20 @@ int btrfs_next_old_leaf(struct btrfs_root *root, struct btrfs_path *path,
 
 	path->keep_locks = 1;
 
-	if (time_seq)
+	if (time_seq) {
 		ret = btrfs_search_old_slot(root, &key, path, time_seq);
-	else
+	} else {
+		if (path->need_commit_sem) {
+			path->need_commit_sem = 0;
+			need_commit_sem = true;
+			down_read(&fs_info->commit_root_sem);
+		}
 		ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+	}
 	path->keep_locks = 0;
 
 	if (ret < 0)
-		return ret;
+		goto done;
 
 	nritems = btrfs_header_nritems(path->nodes[0]);
 	/*
@@ -4543,6 +4584,15 @@ int btrfs_next_old_leaf(struct btrfs_root *root, struct btrfs_path *path,
 	ret = 0;
 done:
 	unlock_up(path, 0, 1, 0, NULL);
+	if (need_commit_sem) {
+		int ret2;
+
+		path->need_commit_sem = 1;
+		ret2 = finish_need_commit_sem_search(path);
+		up_read(&fs_info->commit_root_sem);
+		if (ret2)
+			ret = ret2;
+	}
 
 	return ret;
 }
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index b46409801647..e89f814cc8f5 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -568,7 +568,6 @@ enum {
 	/*
 	 * Indicate that relocation of a chunk has started, it's set per chunk
 	 * and is toggled between chunks.
-	 * Set, tested and cleared while holding fs_info::send_reloc_lock.
 	 */
 	BTRFS_FS_RELOC_RUNNING,
 
@@ -668,6 +667,12 @@ struct btrfs_fs_info {
 
 	u64 generation;
 	u64 last_trans_committed;
+	/*
+	 * Generation of the last transaction used for block group relocation
+	 * since the filesystem was last mounted (or 0 if none happened yet).
+	 * Must be written and read while holding btrfs_fs_info::commit_root_sem.
+	 */
+	u64 last_reloc_trans;
 	u64 avg_delayed_ref_runtime;
 
 	/*
@@ -997,13 +1002,6 @@ struct btrfs_fs_info {
 
 	struct crypto_shash *csum_shash;
 
-	spinlock_t send_reloc_lock;
-	/*
-	 * Number of send operations in progress.
-	 * Updated while holding fs_info::send_reloc_lock.
-	 */
-	int send_in_progress;
-
 	/* Type of exclusive operation running, protected by super_lock */
 	enum btrfs_exclusive_operation exclusive_operation;
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 2180fcef56ca..d5a590b11be5 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2859,6 +2859,7 @@ static int __cold init_tree_roots(struct btrfs_fs_info *fs_info)
 		/* All successful */
 		fs_info->generation = generation;
 		fs_info->last_trans_committed = generation;
+		fs_info->last_reloc_trans = 0;
 
 		/* Always begin writing backup roots after the one being used */
 		if (backup_index < 0) {
@@ -2992,9 +2993,6 @@ void btrfs_init_fs_info(struct btrfs_fs_info *fs_info)
 	spin_lock_init(&fs_info->swapfile_pins_lock);
 	fs_info->swapfile_pins = RB_ROOT;
 
-	spin_lock_init(&fs_info->send_reloc_lock);
-	fs_info->send_in_progress = 0;
-
 	fs_info->bg_reclaim_threshold = BTRFS_DEFAULT_RECLAIM_THRESH;
 	INIT_WORK(&fs_info->reclaim_bgs_work, btrfs_reclaim_bgs_work);
 }
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index a050f9748fa7..a6661f2ad2c0 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3854,25 +3854,14 @@ struct inode *create_reloc_inode(struct btrfs_fs_info *fs_info,
  *   0             success
  *   -EINPROGRESS  operation is already in progress, that's probably a bug
  *   -ECANCELED    cancellation request was set before the operation started
- *   -EAGAIN       can not start because there are ongoing send operations
  */
 static int reloc_chunk_start(struct btrfs_fs_info *fs_info)
 {
-	spin_lock(&fs_info->send_reloc_lock);
-	if (fs_info->send_in_progress) {
-		btrfs_warn_rl(fs_info,
-"cannot run relocation while send operations are in progress (%d in progress)",
-			      fs_info->send_in_progress);
-		spin_unlock(&fs_info->send_reloc_lock);
-		return -EAGAIN;
-	}
 	if (test_and_set_bit(BTRFS_FS_RELOC_RUNNING, &fs_info->flags)) {
 		/* This should not happen */
-		spin_unlock(&fs_info->send_reloc_lock);
 		btrfs_err(fs_info, "reloc already running, cannot start");
 		return -EINPROGRESS;
 	}
-	spin_unlock(&fs_info->send_reloc_lock);
 
 	if (atomic_read(&fs_info->reloc_cancel_req) > 0) {
 		btrfs_info(fs_info, "chunk relocation canceled on start");
@@ -3894,9 +3883,7 @@ static void reloc_chunk_end(struct btrfs_fs_info *fs_info)
 	/* Requested after start, clear bit first so any waiters can continue */
 	if (atomic_read(&fs_info->reloc_cancel_req) > 0)
 		btrfs_info(fs_info, "chunk relocation canceled during operation");
-	spin_lock(&fs_info->send_reloc_lock);
 	clear_and_wake_up_bit(BTRFS_FS_RELOC_RUNNING, &fs_info->flags);
-	spin_unlock(&fs_info->send_reloc_lock);
 	atomic_set(&fs_info->reloc_cancel_req, 0);
 }
 
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 5612e8bf2ace..4d2c6ce29fe5 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -24,6 +24,7 @@
 #include "transaction.h"
 #include "compression.h"
 #include "xattr.h"
+#include "print-tree.h"
 
 /*
  * Maximum number of references an extent can have in order for us to attempt to
@@ -95,6 +96,15 @@ struct send_ctx {
 	struct btrfs_path *right_path;
 	struct btrfs_key *cmp_key;
 
+	/*
+	 * Keep track of the generation of the last transaction that was used
+	 * for relocating a block group. This is periodically checked in order
+	 * to detect if a relocation happened since the last check, so that we
+	 * don't operate on stale extent buffers for nodes (level >= 1) or on
+	 * stale disk_bytenr values of file extent items.
+	 */
+	u64 last_reloc_trans;
+
 	/*
 	 * infos of the currently processed inode. In case of deleted inodes,
 	 * these are the values from the deleted inode.
@@ -1415,6 +1425,26 @@ static int find_extent_clone(struct send_ctx *sctx,
 	if (ret < 0)
 		goto out;
 
+	down_read(&fs_info->commit_root_sem);
+	if (fs_info->last_reloc_trans > sctx->last_reloc_trans) {
+		/*
+		 * A transaction commit for a transaction in which block group
+		 * relocation was done just happened.
+		 * The disk_bytenr of the file extent item we processed is
+		 * possibly stale, referring to the extent's location before
+		 * relocation. So act as if we haven't found any clone sources
+		 * and fallback to write commands, which will read the correct
+		 * data from the new extent location. Otherwise we will fail
+		 * below because we haven't found our own back reference or we
+		 * could be getting incorrect sources in case the old extent
+		 * was already reallocated after the relocation.
+		 */
+		up_read(&fs_info->commit_root_sem);
+		ret = -ENOENT;
+		goto out;
+	}
+	up_read(&fs_info->commit_root_sem);
+
 	if (!backref_ctx.found_itself) {
 		/* found a bug in backref code? */
 		ret = -EIO;
@@ -6596,6 +6626,50 @@ static int changed_cb(struct btrfs_path *left_path,
 {
 	int ret = 0;
 
+	/*
+	 * We can not hold the commit root semaphore here. This is because in
+	 * the case of sending and receiving to the same filesystem, using a
+	 * pipe, could result in a deadlock:
+	 *
+	 * 1) The task running send blocks on the pipe because it's full;
+	 *
+	 * 2) The task running receive, which is the only consumer of the pipe,
+	 *    is waiting for a transaction commit (for example due to a space
+	 *    reservation when doing a write or triggering a transaction commit
+	 *    when creating a subvolume);
+	 *
+	 * 3) The transaction is waiting to write lock the commit root semaphore,
+	 *    but can not acquire it since it's being held at 1).
+	 *
+	 * Down this call chain we write to the pipe through kernel_write().
+	 * The same type of problem can also happen when sending to a file that
+	 * is stored in the same filesystem - when reserving space for a write
+	 * into the file, we can trigger a transaction commit.
+	 *
+	 * Our caller has supplied us with clones of leaves from the send and
+	 * parent roots, so we're safe here from a concurrent relocation and
+	 * further reallocation of metadata extents while we are here. Below we
+	 * also assert that the leaves are clones.
+	 */
+	lockdep_assert_not_held(&sctx->send_root->fs_info->commit_root_sem);
+
+	/*
+	 * We always have a send root, so left_path is never NULL. We will not
+	 * have a leaf when we have reached the end of the send root but have
+	 * not yet reached the end of the parent root.
+	 */
+	if (left_path->nodes[0])
+		ASSERT(test_bit(EXTENT_BUFFER_UNMAPPED,
+				&left_path->nodes[0]->bflags));
+	/*
+	 * When doing a full send we don't have a parent root, so right_path is
+	 * NULL. When doing an incremental send, we may have reached the end of
+	 * the parent root already, so we don't have a leaf at right_path.
+	 */
+	if (right_path && right_path->nodes[0])
+		ASSERT(test_bit(EXTENT_BUFFER_UNMAPPED,
+				&right_path->nodes[0]->bflags));
+
 	if (result == BTRFS_COMPARE_TREE_SAME) {
 		if (key->type == BTRFS_INODE_REF_KEY ||
 		    key->type == BTRFS_INODE_EXTREF_KEY) {
@@ -6642,14 +6716,46 @@ static int changed_cb(struct btrfs_path *left_path,
 	return ret;
 }
 
+static int search_key_again(const struct send_ctx *sctx,
+			    struct btrfs_root *root,
+			    struct btrfs_path *path,
+			    const struct btrfs_key *key)
+{
+	int ret;
+
+	if (!path->need_commit_sem)
+		lockdep_assert_held_read(&root->fs_info->commit_root_sem);
+
+	/*
+	 * Roots used for send operations are readonly and no one can add,
+	 * update or remove keys from them, so we should be able to find our
+	 * key again. The only exception is deduplication, which can operate on
+	 * readonly roots and add, update or remove keys to/from them - but at
+	 * the moment we don't allow it to run in parallel with send.
+	 */
+	ret = btrfs_search_slot(NULL, root, key, path, 0, 0);
+	ASSERT(ret <= 0);
+	if (ret > 0) {
+		btrfs_print_tree(path->nodes[path->lowest_level], false);
+		btrfs_err(root->fs_info,
+"send: key (%llu %u %llu) not found in %s root %llu, lowest_level %d, slot %d",
+			  key->objectid, key->type, key->offset,
+			  (root == sctx->parent_root ? "parent" : "send"),
+			  root->root_key.objectid, path->lowest_level,
+			  path->slots[path->lowest_level]);
+		return -EUCLEAN;
+	}
+
+	return ret;
+}
+
 static int full_send_tree(struct send_ctx *sctx)
 {
 	int ret;
 	struct btrfs_root *send_root = sctx->send_root;
 	struct btrfs_key key;
+	struct btrfs_fs_info *fs_info = send_root->fs_info;
 	struct btrfs_path *path;
-	struct extent_buffer *eb;
-	int slot;
 
 	path = alloc_path_for_send();
 	if (!path)
@@ -6660,6 +6766,10 @@ static int full_send_tree(struct send_ctx *sctx)
 	key.type = BTRFS_INODE_ITEM_KEY;
 	key.offset = 0;
 
+	down_read(&fs_info->commit_root_sem);
+	sctx->last_reloc_trans = fs_info->last_reloc_trans;
+	up_read(&fs_info->commit_root_sem);
+
 	ret = btrfs_search_slot_for_read(send_root, &key, path, 1, 0);
 	if (ret < 0)
 		goto out;
@@ -6667,15 +6777,35 @@ static int full_send_tree(struct send_ctx *sctx)
 		goto out_finish;
 
 	while (1) {
-		eb = path->nodes[0];
-		slot = path->slots[0];
-		btrfs_item_key_to_cpu(eb, &key, slot);
+		btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
 
 		ret = changed_cb(path, NULL, &key,
 				 BTRFS_COMPARE_TREE_NEW, sctx);
 		if (ret < 0)
 			goto out;
 
+		down_read(&fs_info->commit_root_sem);
+		if (fs_info->last_reloc_trans > sctx->last_reloc_trans) {
+			sctx->last_reloc_trans = fs_info->last_reloc_trans;
+			up_read(&fs_info->commit_root_sem);
+			/*
+			 * A transaction used for relocating a block group was
+			 * committed or is about to finish its commit. Release
+			 * our path (leaf) and restart the search, so that we
+			 * avoid operating on any file extent items that are
+			 * stale, with a disk_bytenr that reflects a pre
+			 * relocation value. This way we avoid as much as
+			 * possible to fallback to regular writes when checking
+			 * if we can clone file ranges.
+			 */
+			btrfs_release_path(path);
+			ret = search_key_again(sctx, send_root, path, &key);
+			if (ret < 0)
+				goto out;
+		} else {
+			up_read(&fs_info->commit_root_sem);
+		}
+
 		ret = btrfs_next_item(send_root, path);
 		if (ret < 0)
 			goto out;
@@ -6693,6 +6823,20 @@ static int full_send_tree(struct send_ctx *sctx)
 	return ret;
 }
 
+static int replace_node_with_clone(struct btrfs_path *path, int level)
+{
+	struct extent_buffer *clone;
+
+	clone = btrfs_clone_extent_buffer(path->nodes[level]);
+	if (!clone)
+		return -ENOMEM;
+
+	free_extent_buffer(path->nodes[level]);
+	path->nodes[level] = clone;
+
+	return 0;
+}
+
 static int tree_move_down(struct btrfs_path *path, int *level, u64 reada_min_gen)
 {
 	struct extent_buffer *eb;
@@ -6702,6 +6846,8 @@ static int tree_move_down(struct btrfs_path *path, int *level, u64 reada_min_gen
 	u64 reada_max;
 	u64 reada_done = 0;
 
+	lockdep_assert_held_read(&parent->fs_info->commit_root_sem);
+
 	BUG_ON(*level == 0);
 	eb = btrfs_read_node_slot(parent, slot);
 	if (IS_ERR(eb))
@@ -6725,6 +6871,10 @@ static int tree_move_down(struct btrfs_path *path, int *level, u64 reada_min_gen
 	path->nodes[*level - 1] = eb;
 	path->slots[*level - 1] = 0;
 	(*level)--;
+
+	if (*level == 0)
+		return replace_node_with_clone(path, 0);
+
 	return 0;
 }
 
@@ -6738,8 +6888,10 @@ static int tree_move_next_or_upnext(struct btrfs_path *path,
 	path->slots[*level]++;
 
 	while (path->slots[*level] >= nritems) {
-		if (*level == root_level)
+		if (*level == root_level) {
+			path->slots[*level] = nritems - 1;
 			return -1;
+		}
 
 		/* move upnext */
 		path->slots[*level] = 0;
@@ -6771,14 +6923,20 @@ static int tree_advance(struct btrfs_path *path,
 	} else {
 		ret = tree_move_down(path, level, reada_min_gen);
 	}
-	if (ret >= 0) {
-		if (*level == 0)
-			btrfs_item_key_to_cpu(path->nodes[*level], key,
-					path->slots[*level]);
-		else
-			btrfs_node_key_to_cpu(path->nodes[*level], key,
-					path->slots[*level]);
-	}
+
+	/*
+	 * Even if we have reached the end of a tree, ret is -1, update the key
+	 * anyway, so that in case we need to restart due to a block group
+	 * relocation, we can assert that the last key of the root node still
+	 * exists in the tree.
+	 */
+	if (*level == 0)
+		btrfs_item_key_to_cpu(path->nodes[*level], key,
+				      path->slots[*level]);
+	else
+		btrfs_node_key_to_cpu(path->nodes[*level], key,
+				      path->slots[*level]);
+
 	return ret;
 }
 
@@ -6807,6 +6965,97 @@ static int tree_compare_item(struct btrfs_path *left_path,
 	return 0;
 }
 
+/*
+ * A transaction used for relocating a block group was committed or is about to
+ * finish its commit. Release our paths and restart the search, so that we are
+ * not using stale extent buffers:
+ *
+ * 1) For levels > 0, we are only holding references of extent buffers, without
+ *    any locks on them, which does not prevent them from having been relocated
+ *    and reallocated after the last time we released the commit root semaphore.
+ *    The exception are the root nodes, for which we always have a clone, see
+ *    the comment at btrfs_compare_trees();
+ *
+ * 2) For leaves, level 0, we are holding copies (clones) of extent buffers, so
+ *    we are safe from the concurrent relocation and reallocation. However they
+ *    can have file extent items with a pre relocation disk_bytenr value, so we
+ *    restart the start from the current commit roots and clone the new leaves so
+ *    that we get the post relocation disk_bytenr values. Not doing so, could
+ *    make us clone the wrong data in case there are new extents using the old
+ *    disk_bytenr that happen to be shared.
+ */
+static int restart_after_relocation(struct btrfs_path *left_path,
+				    struct btrfs_path *right_path,
+				    const struct btrfs_key *left_key,
+				    const struct btrfs_key *right_key,
+				    int left_level,
+				    int right_level,
+				    const struct send_ctx *sctx)
+{
+	int root_level;
+	int ret;
+
+	lockdep_assert_held_read(&sctx->send_root->fs_info->commit_root_sem);
+
+	btrfs_release_path(left_path);
+	btrfs_release_path(right_path);
+
+	/*
+	 * Since keys can not be added or removed to/from our roots because they
+	 * are readonly and we do not allow deduplication to run in parallel
+	 * (which can add, remove or change keys), the layout of the trees should
+	 * not change.
+	 */
+	left_path->lowest_level = left_level;
+	ret = search_key_again(sctx, sctx->send_root, left_path, left_key);
+	if (ret < 0)
+		return ret;
+
+	right_path->lowest_level = right_level;
+	ret = search_key_again(sctx, sctx->parent_root, right_path, right_key);
+	if (ret < 0)
+		return ret;
+
+	/*
+	 * If the lowest level nodes are leaves, clone them so that they can be
+	 * safely used by changed_cb() while not under the protection of the
+	 * commit root semaphore, even if relocation and reallocation happens in
+	 * parallel.
+	 */
+	if (left_level == 0) {
+		ret = replace_node_with_clone(left_path, 0);
+		if (ret < 0)
+			return ret;
+	}
+
+	if (right_level == 0) {
+		ret = replace_node_with_clone(right_path, 0);
+		if (ret < 0)
+			return ret;
+	}
+
+	/*
+	 * Now clone the root nodes (unless they happen to be the leaves we have
+	 * already cloned). This is to protect against concurrent snapshotting of
+	 * the send and parent roots (see the comment at btrfs_compare_trees()).
+	 */
+	root_level = btrfs_header_level(sctx->send_root->commit_root);
+	if (root_level > 0) {
+		ret = replace_node_with_clone(left_path, root_level);
+		if (ret < 0)
+			return ret;
+	}
+
+	root_level = btrfs_header_level(sctx->parent_root->commit_root);
+	if (root_level > 0) {
+		ret = replace_node_with_clone(right_path, root_level);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
 /*
  * This function compares two trees and calls the provided callback for
  * every changed/new/deleted item it finds.
@@ -6835,10 +7084,10 @@ static int btrfs_compare_trees(struct btrfs_root *left_root,
 	int right_root_level;
 	int left_level;
 	int right_level;
-	int left_end_reached;
-	int right_end_reached;
-	int advance_left;
-	int advance_right;
+	int left_end_reached = 0;
+	int right_end_reached = 0;
+	int advance_left = 0;
+	int advance_right = 0;
 	u64 left_blockptr;
 	u64 right_blockptr;
 	u64 left_gen;
@@ -6906,12 +7155,18 @@ static int btrfs_compare_trees(struct btrfs_root *left_root,
 	down_read(&fs_info->commit_root_sem);
 	left_level = btrfs_header_level(left_root->commit_root);
 	left_root_level = left_level;
+	/*
+	 * We clone the root node of the send and parent roots to prevent races
+	 * with snapshot creation of these roots. Snapshot creation COWs the
+	 * root node of a tree, so after the transaction is committed the old
+	 * extent can be reallocated while this send operation is still ongoing.
+	 * So we clone them, under the commit root semaphore, to be race free.
+	 */
 	left_path->nodes[left_level] =
 			btrfs_clone_extent_buffer(left_root->commit_root);
 	if (!left_path->nodes[left_level]) {
-		up_read(&fs_info->commit_root_sem);
 		ret = -ENOMEM;
-		goto out;
+		goto out_unlock;
 	}
 
 	right_level = btrfs_header_level(right_root->commit_root);
@@ -6919,9 +7174,8 @@ static int btrfs_compare_trees(struct btrfs_root *left_root,
 	right_path->nodes[right_level] =
 			btrfs_clone_extent_buffer(right_root->commit_root);
 	if (!right_path->nodes[right_level]) {
-		up_read(&fs_info->commit_root_sem);
 		ret = -ENOMEM;
-		goto out;
+		goto out_unlock;
 	}
 	/*
 	 * Our right root is the parent root, while the left root is the "send"
@@ -6931,7 +7185,6 @@ static int btrfs_compare_trees(struct btrfs_root *left_root,
 	 * will need to read them at some point.
 	 */
 	reada_min_gen = btrfs_header_generation(right_root->commit_root);
-	up_read(&fs_info->commit_root_sem);
 
 	if (left_level == 0)
 		btrfs_item_key_to_cpu(left_path->nodes[left_level],
@@ -6946,11 +7199,26 @@ static int btrfs_compare_trees(struct btrfs_root *left_root,
 		btrfs_node_key_to_cpu(right_path->nodes[right_level],
 				&right_key, right_path->slots[right_level]);
 
-	left_end_reached = right_end_reached = 0;
-	advance_left = advance_right = 0;
+	sctx->last_reloc_trans = fs_info->last_reloc_trans;
 
 	while (1) {
-		cond_resched();
+		if (need_resched() ||
+		    rwsem_is_contended(&fs_info->commit_root_sem)) {
+			up_read(&fs_info->commit_root_sem);
+			cond_resched();
+			down_read(&fs_info->commit_root_sem);
+		}
+
+		if (fs_info->last_reloc_trans > sctx->last_reloc_trans) {
+			ret = restart_after_relocation(left_path, right_path,
+						       &left_key, &right_key,
+						       left_level, right_level,
+						       sctx);
+			if (ret < 0)
+				goto out_unlock;
+			sctx->last_reloc_trans = fs_info->last_reloc_trans;
+		}
+
 		if (advance_left && !left_end_reached) {
 			ret = tree_advance(left_path, &left_level,
 					left_root_level,
@@ -6959,7 +7227,7 @@ static int btrfs_compare_trees(struct btrfs_root *left_root,
 			if (ret == -1)
 				left_end_reached = ADVANCE;
 			else if (ret < 0)
-				goto out;
+				goto out_unlock;
 			advance_left = 0;
 		}
 		if (advance_right && !right_end_reached) {
@@ -6970,54 +7238,55 @@ static int btrfs_compare_trees(struct btrfs_root *left_root,
 			if (ret == -1)
 				right_end_reached = ADVANCE;
 			else if (ret < 0)
-				goto out;
+				goto out_unlock;
 			advance_right = 0;
 		}
 
 		if (left_end_reached && right_end_reached) {
 			ret = 0;
-			goto out;
+			goto out_unlock;
 		} else if (left_end_reached) {
 			if (right_level == 0) {
+				up_read(&fs_info->commit_root_sem);
 				ret = changed_cb(left_path, right_path,
 						&right_key,
 						BTRFS_COMPARE_TREE_DELETED,
 						sctx);
 				if (ret < 0)
 					goto out;
+				down_read(&fs_info->commit_root_sem);
 			}
 			advance_right = ADVANCE;
 			continue;
 		} else if (right_end_reached) {
 			if (left_level == 0) {
+				up_read(&fs_info->commit_root_sem);
 				ret = changed_cb(left_path, right_path,
 						&left_key,
 						BTRFS_COMPARE_TREE_NEW,
 						sctx);
 				if (ret < 0)
 					goto out;
+				down_read(&fs_info->commit_root_sem);
 			}
 			advance_left = ADVANCE;
 			continue;
 		}
 
 		if (left_level == 0 && right_level == 0) {
+			up_read(&fs_info->commit_root_sem);
 			cmp = btrfs_comp_cpu_keys(&left_key, &right_key);
 			if (cmp < 0) {
 				ret = changed_cb(left_path, right_path,
 						&left_key,
 						BTRFS_COMPARE_TREE_NEW,
 						sctx);
-				if (ret < 0)
-					goto out;
 				advance_left = ADVANCE;
 			} else if (cmp > 0) {
 				ret = changed_cb(left_path, right_path,
 						&right_key,
 						BTRFS_COMPARE_TREE_DELETED,
 						sctx);
-				if (ret < 0)
-					goto out;
 				advance_right = ADVANCE;
 			} else {
 				enum btrfs_compare_tree_result result;
@@ -7031,11 +7300,13 @@ static int btrfs_compare_trees(struct btrfs_root *left_root,
 					result = BTRFS_COMPARE_TREE_SAME;
 				ret = changed_cb(left_path, right_path,
 						 &left_key, result, sctx);
-				if (ret < 0)
-					goto out;
 				advance_left = ADVANCE;
 				advance_right = ADVANCE;
 			}
+
+			if (ret < 0)
+				goto out;
+			down_read(&fs_info->commit_root_sem);
 		} else if (left_level == right_level) {
 			cmp = btrfs_comp_cpu_keys(&left_key, &right_key);
 			if (cmp < 0) {
@@ -7075,6 +7346,8 @@ static int btrfs_compare_trees(struct btrfs_root *left_root,
 		}
 	}
 
+out_unlock:
+	up_read(&fs_info->commit_root_sem);
 out:
 	btrfs_free_path(left_path);
 	btrfs_free_path(right_path);
@@ -7413,21 +7686,7 @@ long btrfs_ioctl_send(struct file *mnt_file, struct btrfs_ioctl_send_args *arg)
 	if (ret)
 		goto out;
 
-	spin_lock(&fs_info->send_reloc_lock);
-	if (test_bit(BTRFS_FS_RELOC_RUNNING, &fs_info->flags)) {
-		spin_unlock(&fs_info->send_reloc_lock);
-		btrfs_warn_rl(fs_info,
-		"cannot run send because a relocation operation is in progress");
-		ret = -EAGAIN;
-		goto out;
-	}
-	fs_info->send_in_progress++;
-	spin_unlock(&fs_info->send_reloc_lock);
-
 	ret = send_subvol(sctx);
-	spin_lock(&fs_info->send_reloc_lock);
-	fs_info->send_in_progress--;
-	spin_unlock(&fs_info->send_reloc_lock);
 	if (ret < 0)
 		goto out;
 
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 9a6009108ea5..642cd2b55fa0 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -163,6 +163,10 @@ static noinline void switch_commit_roots(struct btrfs_trans_handle *trans)
 	struct btrfs_caching_control *caching_ctl, *next;
 
 	down_write(&fs_info->commit_root_sem);
+
+	if (test_bit(BTRFS_FS_RELOC_RUNNING, &fs_info->flags))
+		fs_info->last_reloc_trans = trans->transid;
+
 	list_for_each_entry_safe(root, tmp, &cur_trans->switch_commits,
 				 dirty_list) {
 		list_del_init(&root->dirty_list);
diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index a9d21b33da9c..d6b5339c56e2 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -941,7 +941,17 @@ static int fuse_copy_page(struct fuse_copy_state *cs, struct page **pagep,
 
 	while (count) {
 		if (cs->write && cs->pipebufs && page) {
-			return fuse_ref_page(cs, page, offset, count);
+			/*
+			 * Can't control lifetime of pipe buffers, so always
+			 * copy user pages.
+			 */
+			if (cs->req->args->user_pages) {
+				err = fuse_copy_fill(cs);
+				if (err)
+					return err;
+			} else {
+				return fuse_ref_page(cs, page, offset, count);
+			}
 		} else if (!cs->len) {
 			if (cs->move_pages && page &&
 			    offset == 0 && count == PAGE_SIZE) {
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 2004d362361e..bc50a9fa84a0 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1417,6 +1417,7 @@ static int fuse_get_user_pages(struct fuse_args_pages *ap, struct iov_iter *ii,
 			(PAGE_SIZE - ret) & (PAGE_SIZE - 1);
 	}
 
+	ap->args.user_pages = true;
 	if (write)
 		ap->args.in_pages = true;
 	else
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index a59e36c7deae..c3a87586a15f 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -256,6 +256,7 @@ struct fuse_args {
 	bool nocreds:1;
 	bool in_pages:1;
 	bool out_pages:1;
+	bool user_pages:1;
 	bool out_argvar:1;
 	bool page_zeroing:1;
 	bool page_replace:1;
diff --git a/fs/fuse/ioctl.c b/fs/fuse/ioctl.c
index 546ea3d58fb4..fc69e1797a33 100644
--- a/fs/fuse/ioctl.c
+++ b/fs/fuse/ioctl.c
@@ -394,9 +394,12 @@ static int fuse_priv_ioctl(struct inode *inode, struct fuse_file *ff,
 	args.out_args[1].value = ptr;
 
 	err = fuse_simple_request(fm, &args);
-	if (!err && outarg.flags & FUSE_IOCTL_RETRY)
-		err = -EIO;
-
+	if (!err) {
+		if (outarg.result < 0)
+			err = outarg.result;
+		else if (outarg.flags & FUSE_IOCTL_RETRY)
+			err = -EIO;
+	}
 	return err;
 }
 
diff --git a/fs/pipe.c b/fs/pipe.c
index 6d4342bad9f1..751d5b36c84b 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -252,7 +252,8 @@ pipe_read(struct kiocb *iocb, struct iov_iter *to)
 	 */
 	was_full = pipe_full(pipe->head, pipe->tail, pipe->max_usage);
 	for (;;) {
-		unsigned int head = pipe->head;
+		/* Read ->head with a barrier vs post_one_notification() */
+		unsigned int head = smp_load_acquire(&pipe->head);
 		unsigned int tail = pipe->tail;
 		unsigned int mask = pipe->ring_size - 1;
 
@@ -830,10 +831,8 @@ void free_pipe_info(struct pipe_inode_info *pipe)
 	int i;
 
 #ifdef CONFIG_WATCH_QUEUE
-	if (pipe->watch_queue) {
+	if (pipe->watch_queue)
 		watch_queue_clear(pipe->watch_queue);
-		put_watch_queue(pipe->watch_queue);
-	}
 #endif
 
 	(void) account_pipe_buffers(pipe->user, pipe->nr_accounted, 0);
@@ -843,6 +842,10 @@ void free_pipe_info(struct pipe_inode_info *pipe)
 		if (buf->ops)
 			pipe_buf_release(pipe, buf);
 	}
+#ifdef CONFIG_WATCH_QUEUE
+	if (pipe->watch_queue)
+		put_watch_queue(pipe->watch_queue);
+#endif
 	if (pipe->tmp_page)
 		__free_page(pipe->tmp_page);
 	kfree(pipe->bufs);
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 0f5315c2b5a3..0b48a0cf4262 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -12,12 +12,10 @@
 
 #include <linux/types.h>
 #include <linux/kdev_t.h>
-#include <linux/rcupdate.h>
-#include <linux/slab.h>
-#include <linux/percpu-refcount.h>
 #include <linux/uuid.h>
 #include <linux/blk_types.h>
-#include <asm/local.h>
+#include <linux/device.h>
+#include <linux/xarray.h>
 
 extern const struct device_type disk_type;
 extern struct device_type part_type;
@@ -26,14 +24,6 @@ extern struct class block_class;
 #define DISK_MAX_PARTS			256
 #define DISK_NAME_LEN			32
 
-#include <linux/major.h>
-#include <linux/device.h>
-#include <linux/smp.h>
-#include <linux/string.h>
-#include <linux/fs.h>
-#include <linux/workqueue.h>
-#include <linux/xarray.h>
-
 #define PARTITION_META_INFO_VOLNAMELTH	64
 /*
  * Enough for the string representation of any kind of UUID plus NULL.
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 25d775764a5a..fdf4589ab4d4 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -9508,8 +9508,8 @@ struct mlx5_ifc_bufferx_reg_bits {
 	u8         reserved_at_0[0x6];
 	u8         lossy[0x1];
 	u8         epsb[0x1];
-	u8         reserved_at_8[0xc];
-	u8         size[0xc];
+	u8         reserved_at_8[0x8];
+	u8         size[0x10];
 
 	u8         xoff_threshold[0x10];
 	u8         xon_threshold[0x10];
diff --git a/include/linux/part_stat.h b/include/linux/part_stat.h
index d2558121d48c..6f7949b2fd8d 100644
--- a/include/linux/part_stat.h
+++ b/include/linux/part_stat.h
@@ -3,6 +3,7 @@
 #define _LINUX_PART_STAT_H
 
 #include <linux/genhd.h>
+#include <asm/local.h>
 
 struct disk_stats {
 	u64 nsecs[NR_STAT_GROUPS];
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index 41edbc01ffa4..1af8d65d4c8f 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -133,7 +133,6 @@ bool is_virtio_device(struct device *dev);
 void virtio_break_device(struct virtio_device *dev);
 
 void virtio_config_changed(struct virtio_device *dev);
-int virtio_finalize_features(struct virtio_device *dev);
 #ifdef CONFIG_PM_SLEEP
 int virtio_device_freeze(struct virtio_device *dev);
 int virtio_device_restore(struct virtio_device *dev);
diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index 8519b3ae5d52..b341dd62aa4d 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -62,8 +62,9 @@ struct virtio_shm_region {
  *	Returns the first 64 feature bits (all we currently need).
  * @finalize_features: confirm what device features we'll be using.
  *	vdev: the virtio_device
- *	This gives the final feature bits for the device: it can change
+ *	This sends the driver feature bits to the device: it can change
  *	the dev->feature bits if it wants.
+ * Note: despite the name this can be called any number of times.
  *	Returns 0 on success or error status
  * @bus_name: return the bus name associated with the device (optional)
  *	vdev: the virtio_device
diff --git a/include/linux/watch_queue.h b/include/linux/watch_queue.h
index c994d1b2cdba..3b9a40ae8bdb 100644
--- a/include/linux/watch_queue.h
+++ b/include/linux/watch_queue.h
@@ -28,7 +28,8 @@ struct watch_type_filter {
 struct watch_filter {
 	union {
 		struct rcu_head	rcu;
-		unsigned long	type_filter[2];	/* Bitmask of accepted types */
+		/* Bitmask of accepted types */
+		DECLARE_BITMAP(type_filter, WATCH_TYPE__NR);
 	};
 	u32			nr_filters;	/* Number of filters */
 	struct watch_type_filter filters[];
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 49e5ece9361c..d784e76113b8 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -1056,7 +1056,6 @@ void dsa_unregister_switch(struct dsa_switch *ds);
 int dsa_register_switch(struct dsa_switch *ds);
 void dsa_switch_shutdown(struct dsa_switch *ds);
 struct dsa_switch *dsa_switch_find(int tree_index, int sw_index);
-void dsa_flush_workqueue(void);
 #ifdef CONFIG_PM_SLEEP
 int dsa_switch_suspend(struct dsa_switch *ds);
 int dsa_switch_resume(struct dsa_switch *ds);
diff --git a/include/net/esp.h b/include/net/esp.h
index 9c5637d41d95..90cd02ff77ef 100644
--- a/include/net/esp.h
+++ b/include/net/esp.h
@@ -4,6 +4,8 @@
 
 #include <linux/skbuff.h>
 
+#define ESP_SKB_FRAG_MAXSIZE (PAGE_SIZE << SKB_FRAG_PAGE_ORDER)
+
 struct ip_esp_hdr;
 
 static inline struct ip_esp_hdr *ip_esp_hdr(const struct sk_buff *skb)
diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 87c40517e822..e58dce93c661 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -578,9 +578,14 @@ phys_addr_t swiotlb_tbl_map_single(struct device *dev, phys_addr_t orig_addr,
 	for (i = 0; i < nr_slots(alloc_size + offset); i++)
 		mem->slots[index + i].orig_addr = slot_addr(orig_addr, i);
 	tlb_addr = slot_addr(mem->start, index) + offset;
-	if (!(attrs & DMA_ATTR_SKIP_CPU_SYNC) &&
-	    (dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL))
-		swiotlb_bounce(dev, tlb_addr, mapping_size, DMA_TO_DEVICE);
+	/*
+	 * When dir == DMA_FROM_DEVICE we could omit the copy from the orig
+	 * to the tlb buffer, if we knew for sure the device will
+	 * overwirte the entire current content. But we don't. Thus
+	 * unconditional bounce may prevent leaking swiotlb content (i.e.
+	 * kernel memory) to user-space.
+	 */
+	swiotlb_bounce(dev, tlb_addr, mapping_size, DMA_TO_DEVICE);
 	return tlb_addr;
 }
 
@@ -647,10 +652,13 @@ void swiotlb_tbl_unmap_single(struct device *dev, phys_addr_t tlb_addr,
 void swiotlb_sync_single_for_device(struct device *dev, phys_addr_t tlb_addr,
 		size_t size, enum dma_data_direction dir)
 {
-	if (dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL)
-		swiotlb_bounce(dev, tlb_addr, size, DMA_TO_DEVICE);
-	else
-		BUG_ON(dir != DMA_FROM_DEVICE);
+	/*
+	 * Unconditional bounce is necessary to avoid corruption on
+	 * sync_*_for_cpu or dma_ummap_* when the device didn't overwrite
+	 * the whole lengt of the bounce buffer.
+	 */
+	swiotlb_bounce(dev, tlb_addr, size, DMA_TO_DEVICE);
+	BUG_ON(!valid_dma_direction(dir));
 }
 
 void swiotlb_sync_single_for_cpu(struct device *dev, phys_addr_t tlb_addr,
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 86fb77c2ace5..01002656f1ae 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1496,10 +1496,12 @@ static int __init set_buf_size(char *str)
 	if (!str)
 		return 0;
 	buf_size = memparse(str, &str);
-	/* nr_entries can not be zero */
-	if (buf_size == 0)
-		return 0;
-	trace_buf_size = buf_size;
+	/*
+	 * nr_entries can not be zero and the startup
+	 * tests require some buffer space. Therefore
+	 * ensure we have at least 4096 bytes of buffer.
+	 */
+	trace_buf_size = max(4096UL, buf_size);
 	return 1;
 }
 __setup("trace_buf_size=", set_buf_size);
diff --git a/kernel/trace/trace_osnoise.c b/kernel/trace/trace_osnoise.c
index 65a518649997..93de784ee681 100644
--- a/kernel/trace/trace_osnoise.c
+++ b/kernel/trace/trace_osnoise.c
@@ -1195,6 +1195,26 @@ static int run_osnoise(void)
 					osnoise_stop_tracing();
 		}
 
+		/*
+		 * In some cases, notably when running on a nohz_full CPU with
+		 * a stopped tick PREEMPT_RCU has no way to account for QSs.
+		 * This will eventually cause unwarranted noise as PREEMPT_RCU
+		 * will force preemption as the means of ending the current
+		 * grace period. We avoid this problem by calling
+		 * rcu_momentary_dyntick_idle(), which performs a zero duration
+		 * EQS allowing PREEMPT_RCU to end the current grace period.
+		 * This call shouldn't be wrapped inside an RCU critical
+		 * section.
+		 *
+		 * Note that in non PREEMPT_RCU kernels QSs are handled through
+		 * cond_resched()
+		 */
+		if (IS_ENABLED(CONFIG_PREEMPT_RCU)) {
+			local_irq_disable();
+			rcu_momentary_dyntick_idle();
+			local_irq_enable();
+		}
+
 		/*
 		 * For the non-preemptive kernel config: let threads runs, if
 		 * they so wish.
@@ -1249,6 +1269,37 @@ static int run_osnoise(void)
 static struct cpumask osnoise_cpumask;
 static struct cpumask save_cpumask;
 
+/*
+ * osnoise_sleep - sleep until the next period
+ */
+static void osnoise_sleep(void)
+{
+	u64 interval;
+	ktime_t wake_time;
+
+	mutex_lock(&interface_lock);
+	interval = osnoise_data.sample_period - osnoise_data.sample_runtime;
+	mutex_unlock(&interface_lock);
+
+	/*
+	 * differently from hwlat_detector, the osnoise tracer can run
+	 * without a pause because preemption is on.
+	 */
+	if (!interval) {
+		/* Let synchronize_rcu_tasks() make progress */
+		cond_resched_tasks_rcu_qs();
+		return;
+	}
+
+	wake_time = ktime_add_us(ktime_get(), interval);
+	__set_current_state(TASK_INTERRUPTIBLE);
+
+	while (schedule_hrtimeout_range(&wake_time, 0, HRTIMER_MODE_ABS)) {
+		if (kthread_should_stop())
+			break;
+	}
+}
+
 /*
  * osnoise_main - The osnoise detection kernel thread
  *
@@ -1257,30 +1308,10 @@ static struct cpumask save_cpumask;
  */
 static int osnoise_main(void *data)
 {
-	u64 interval;
 
 	while (!kthread_should_stop()) {
-
 		run_osnoise();
-
-		mutex_lock(&interface_lock);
-		interval = osnoise_data.sample_period - osnoise_data.sample_runtime;
-		mutex_unlock(&interface_lock);
-
-		do_div(interval, USEC_PER_MSEC);
-
-		/*
-		 * differently from hwlat_detector, the osnoise tracer can run
-		 * without a pause because preemption is on.
-		 */
-		if (interval < 1) {
-			/* Let synchronize_rcu_tasks() make progress */
-			cond_resched_tasks_rcu_qs();
-			continue;
-		}
-
-		if (msleep_interruptible(interval))
-			break;
+		osnoise_sleep();
 	}
 
 	return 0;
diff --git a/kernel/watch_queue.c b/kernel/watch_queue.c
index 9c9eb20dd2c5..055bc20ecdda 100644
--- a/kernel/watch_queue.c
+++ b/kernel/watch_queue.c
@@ -54,6 +54,7 @@ static void watch_queue_pipe_buf_release(struct pipe_inode_info *pipe,
 	bit += page->index;
 
 	set_bit(bit, wqueue->notes_bitmap);
+	generic_pipe_buf_release(pipe, buf);
 }
 
 // No try_steal function => no stealing
@@ -112,7 +113,7 @@ static bool post_one_notification(struct watch_queue *wqueue,
 	buf->offset = offset;
 	buf->len = len;
 	buf->flags = PIPE_BUF_FLAG_WHOLE;
-	pipe->head = head + 1;
+	smp_store_release(&pipe->head, head + 1); /* vs pipe_read() */
 
 	if (!test_and_clear_bit(note, wqueue->notes_bitmap)) {
 		spin_unlock_irq(&pipe->rd_wait.lock);
@@ -243,7 +244,8 @@ long watch_queue_set_size(struct pipe_inode_info *pipe, unsigned int nr_notes)
 		goto error;
 	}
 
-	ret = pipe_resize_ring(pipe, nr_notes);
+	nr_notes = nr_pages * WATCH_QUEUE_NOTES_PER_PAGE;
+	ret = pipe_resize_ring(pipe, roundup_pow_of_two(nr_notes));
 	if (ret < 0)
 		goto error;
 
@@ -268,7 +270,7 @@ long watch_queue_set_size(struct pipe_inode_info *pipe, unsigned int nr_notes)
 	wqueue->notes = pages;
 	wqueue->notes_bitmap = bitmap;
 	wqueue->nr_pages = nr_pages;
-	wqueue->nr_notes = nr_pages * WATCH_QUEUE_NOTES_PER_PAGE;
+	wqueue->nr_notes = nr_notes;
 	return 0;
 
 error_p:
@@ -320,7 +322,7 @@ long watch_queue_set_filter(struct pipe_inode_info *pipe,
 		    tf[i].info_mask & WATCH_INFO_LENGTH)
 			goto err_filter;
 		/* Ignore any unknown types */
-		if (tf[i].type >= sizeof(wfilter->type_filter) * 8)
+		if (tf[i].type >= WATCH_TYPE__NR)
 			continue;
 		nr_filter++;
 	}
@@ -336,7 +338,7 @@ long watch_queue_set_filter(struct pipe_inode_info *pipe,
 
 	q = wfilter->filters;
 	for (i = 0; i < filter.nr_filters; i++) {
-		if (tf[i].type >= sizeof(wfilter->type_filter) * BITS_PER_LONG)
+		if (tf[i].type >= WATCH_TYPE__NR)
 			continue;
 
 		q->type			= tf[i].type;
@@ -371,6 +373,7 @@ static void __put_watch_queue(struct kref *kref)
 
 	for (i = 0; i < wqueue->nr_pages; i++)
 		__free_page(wqueue->notes[i]);
+	bitmap_free(wqueue->notes_bitmap);
 
 	wfilter = rcu_access_pointer(wqueue->filter);
 	if (wfilter)
@@ -566,7 +569,7 @@ void watch_queue_clear(struct watch_queue *wqueue)
 	rcu_read_lock();
 	spin_lock_bh(&wqueue->lock);
 
-	/* Prevent new additions and prevent notifications from happening */
+	/* Prevent new notifications from being stored. */
 	wqueue->defunct = true;
 
 	while (!hlist_empty(&wqueue->watches)) {
diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index ea3431ac46a1..735f29512163 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -87,6 +87,13 @@ static void ax25_kill_by_device(struct net_device *dev)
 	ax25_for_each(s, &ax25_list) {
 		if (s->ax25_dev == ax25_dev) {
 			sk = s->sk;
+			if (!sk) {
+				spin_unlock_bh(&ax25_list_lock);
+				s->ax25_dev = NULL;
+				ax25_disconnect(s, ENETUNREACH);
+				spin_lock_bh(&ax25_list_lock);
+				goto again;
+			}
 			sock_hold(sk);
 			spin_unlock_bh(&ax25_list_lock);
 			lock_sock(sk);
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index d7f9ee830d34..9e5657f63245 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -213,7 +213,7 @@ static ssize_t speed_show(struct device *dev,
 	if (!rtnl_trylock())
 		return restart_syscall();
 
-	if (netif_running(netdev)) {
+	if (netif_running(netdev) && netif_device_present(netdev)) {
 		struct ethtool_link_ksettings cmd;
 
 		if (!__ethtool_get_link_ksettings(netdev, &cmd))
diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index 4ff03fb262e0..41f36ad8b0ec 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -349,7 +349,6 @@ void dsa_flush_workqueue(void)
 {
 	flush_workqueue(dsa_owq);
 }
-EXPORT_SYMBOL_GPL(dsa_flush_workqueue);
 
 int dsa_devlink_param_get(struct devlink *dl, u32 id,
 			  struct devlink_param_gset_ctx *ctx)
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 33ab7d7af9eb..a5c9bc7b66c6 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -170,6 +170,7 @@ void dsa_tag_driver_put(const struct dsa_device_ops *ops);
 const struct dsa_device_ops *dsa_find_tagger_by_name(const char *buf);
 
 bool dsa_schedule_work(struct work_struct *work);
+void dsa_flush_workqueue(void);
 const char *dsa_tag_protocol_to_str(const struct dsa_device_ops *ops);
 
 static inline int dsa_tag_protocol_overhead(const struct dsa_device_ops *ops)
diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index e1b1d080e908..70e6c87fbe3d 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -446,6 +446,7 @@ int esp_output_head(struct xfrm_state *x, struct sk_buff *skb, struct esp_info *
 	struct page *page;
 	struct sk_buff *trailer;
 	int tailen = esp->tailen;
+	unsigned int allocsz;
 
 	/* this is non-NULL only with TCP/UDP Encapsulation */
 	if (x->encap) {
@@ -455,6 +456,10 @@ int esp_output_head(struct xfrm_state *x, struct sk_buff *skb, struct esp_info *
 			return err;
 	}
 
+	allocsz = ALIGN(skb->data_len + tailen, L1_CACHE_BYTES);
+	if (allocsz > ESP_SKB_FRAG_MAXSIZE)
+		goto cow;
+
 	if (!skb_cloned(skb)) {
 		if (tailen <= skb_tailroom(skb)) {
 			nfrags = 1;
diff --git a/net/ipv4/esp4_offload.c b/net/ipv4/esp4_offload.c
index 8e4e9aa12130..dad5d29a6a8d 100644
--- a/net/ipv4/esp4_offload.c
+++ b/net/ipv4/esp4_offload.c
@@ -159,6 +159,9 @@ static struct sk_buff *xfrm4_beet_gso_segment(struct xfrm_state *x,
 			skb_shinfo(skb)->gso_type |= SKB_GSO_TCPV4;
 	}
 
+	if (proto == IPPROTO_IPV6)
+		skb_shinfo(skb)->gso_type |= SKB_GSO_IPXIP4;
+
 	__skb_pull(skb, skb_transport_offset(skb));
 	ops = rcu_dereference(inet_offloads[proto]);
 	if (likely(ops && ops->callbacks.gso_segment))
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index e852bbc839dd..1fe27807e471 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -5000,6 +5000,7 @@ static int inet6_fill_ifaddr(struct sk_buff *skb, struct inet6_ifaddr *ifa,
 	    nla_put_s32(skb, IFA_TARGET_NETNSID, args->netnsid))
 		goto error;
 
+	spin_lock_bh(&ifa->lock);
 	if (!((ifa->flags&IFA_F_PERMANENT) &&
 	      (ifa->prefered_lft == INFINITY_LIFE_TIME))) {
 		preferred = ifa->prefered_lft;
@@ -5021,6 +5022,7 @@ static int inet6_fill_ifaddr(struct sk_buff *skb, struct inet6_ifaddr *ifa,
 		preferred = INFINITY_LIFE_TIME;
 		valid = INFINITY_LIFE_TIME;
 	}
+	spin_unlock_bh(&ifa->lock);
 
 	if (!ipv6_addr_any(&ifa->peer_addr)) {
 		if (nla_put_in6_addr(skb, IFA_LOCAL, &ifa->addr) < 0 ||
diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index 883b53fd7846..b7b573085bd5 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -483,6 +483,7 @@ int esp6_output_head(struct xfrm_state *x, struct sk_buff *skb, struct esp_info
 	struct page *page;
 	struct sk_buff *trailer;
 	int tailen = esp->tailen;
+	unsigned int allocsz;
 
 	if (x->encap) {
 		int err = esp6_output_encap(x, skb, esp);
@@ -491,6 +492,10 @@ int esp6_output_head(struct xfrm_state *x, struct sk_buff *skb, struct esp_info
 			return err;
 	}
 
+	allocsz = ALIGN(skb->data_len + tailen, L1_CACHE_BYTES);
+	if (allocsz > ESP_SKB_FRAG_MAXSIZE)
+		goto cow;
+
 	if (!skb_cloned(skb)) {
 		if (tailen <= skb_tailroom(skb)) {
 			nfrags = 1;
diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
index a349d4798077..302170882382 100644
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -198,6 +198,9 @@ static struct sk_buff *xfrm6_beet_gso_segment(struct xfrm_state *x,
 			ipv6_skip_exthdr(skb, 0, &proto, &frag);
 	}
 
+	if (proto == IPPROTO_IPIP)
+		skb_shinfo(skb)->gso_type |= SKB_GSO_IPXIP6;
+
 	__skb_pull(skb, skb_transport_offset(skb));
 	ops = rcu_dereference(inet6_offloads[proto]);
 	if (likely(ops && ops->callbacks.gso_segment))
diff --git a/net/sctp/diag.c b/net/sctp/diag.c
index 034e2c74497d..d9c6d8f30f09 100644
--- a/net/sctp/diag.c
+++ b/net/sctp/diag.c
@@ -61,10 +61,6 @@ static void inet_diag_msg_sctpasoc_fill(struct inet_diag_msg *r,
 		r->idiag_timer = SCTP_EVENT_TIMEOUT_T3_RTX;
 		r->idiag_retrans = asoc->rtx_data_chunks;
 		r->idiag_expires = jiffies_to_msecs(t3_rtx->expires - jiffies);
-	} else {
-		r->idiag_timer = 0;
-		r->idiag_retrans = 0;
-		r->idiag_expires = 0;
 	}
 }
 
@@ -144,13 +140,14 @@ static int inet_sctp_diag_fill(struct sock *sk, struct sctp_association *asoc,
 	r = nlmsg_data(nlh);
 	BUG_ON(!sk_fullsock(sk));
 
+	r->idiag_timer = 0;
+	r->idiag_retrans = 0;
+	r->idiag_expires = 0;
 	if (asoc) {
 		inet_diag_msg_sctpasoc_fill(r, sk, asoc);
 	} else {
 		inet_diag_msg_common_fill(r, sk);
 		r->idiag_state = sk->sk_state;
-		r->idiag_timer = 0;
-		r->idiag_retrans = 0;
 	}
 
 	if (inet_diag_msg_attrs_fill(sk, skb, r, ext, user_ns, net_admin))
diff --git a/net/tipc/bearer.c b/net/tipc/bearer.c
index 443f8e5b9477..36b466cfd9e1 100644
--- a/net/tipc/bearer.c
+++ b/net/tipc/bearer.c
@@ -352,16 +352,18 @@ static int tipc_enable_bearer(struct net *net, const char *name,
 		goto rejected;
 	}
 
-	test_and_set_bit_lock(0, &b->up);
-	rcu_assign_pointer(tn->bearer_list[bearer_id], b);
-	if (skb)
-		tipc_bearer_xmit_skb(net, bearer_id, skb, &b->bcast_addr);
-
+	/* Create monitoring data before accepting activate messages */
 	if (tipc_mon_create(net, bearer_id)) {
 		bearer_disable(net, b);
+		kfree_skb(skb);
 		return -ENOMEM;
 	}
 
+	test_and_set_bit_lock(0, &b->up);
+	rcu_assign_pointer(tn->bearer_list[bearer_id], b);
+	if (skb)
+		tipc_bearer_xmit_skb(net, bearer_id, skb, &b->bcast_addr);
+
 	pr_info("Enabled bearer <%s>, priority %u\n", name, prio);
 
 	return res;
diff --git a/net/tipc/link.c b/net/tipc/link.c
index 4e7936d9b442..115a4a7950f5 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -2285,6 +2285,11 @@ static int tipc_link_proto_rcv(struct tipc_link *l, struct sk_buff *skb,
 		break;
 
 	case STATE_MSG:
+		/* Validate Gap ACK blocks, drop if invalid */
+		glen = tipc_get_gap_ack_blks(&ga, l, hdr, true);
+		if (glen > dlen)
+			break;
+
 		l->rcv_nxt_state = msg_seqno(hdr) + 1;
 
 		/* Update own tolerance if peer indicates a non-zero value */
@@ -2310,10 +2315,6 @@ static int tipc_link_proto_rcv(struct tipc_link *l, struct sk_buff *skb,
 			break;
 		}
 
-		/* Receive Gap ACK blocks from peer if any */
-		glen = tipc_get_gap_ack_blks(&ga, l, hdr, true);
-		if(glen > dlen)
-			break;
 		tipc_mon_rcv(l->net, data + glen, dlen - glen, l->addr,
 			     &l->mon_state, l->bearer_id);
 
diff --git a/tools/testing/selftests/bpf/prog_tests/timer_crash.c b/tools/testing/selftests/bpf/prog_tests/timer_crash.c
new file mode 100644
index 000000000000..f74b82305da8
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/timer_crash.c
@@ -0,0 +1,32 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+#include "timer_crash.skel.h"
+
+enum {
+	MODE_ARRAY,
+	MODE_HASH,
+};
+
+static void test_timer_crash_mode(int mode)
+{
+	struct timer_crash *skel;
+
+	skel = timer_crash__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "timer_crash__open_and_load"))
+		return;
+	skel->bss->pid = getpid();
+	skel->bss->crash_map = mode;
+	if (!ASSERT_OK(timer_crash__attach(skel), "timer_crash__attach"))
+		goto end;
+	usleep(1);
+end:
+	timer_crash__destroy(skel);
+}
+
+void test_timer_crash(void)
+{
+	if (test__start_subtest("array"))
+		test_timer_crash_mode(MODE_ARRAY);
+	if (test__start_subtest("hash"))
+		test_timer_crash_mode(MODE_HASH);
+}
diff --git a/tools/testing/selftests/bpf/progs/timer_crash.c b/tools/testing/selftests/bpf/progs/timer_crash.c
new file mode 100644
index 000000000000..f8f7944e70da
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/timer_crash.c
@@ -0,0 +1,54 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <vmlinux.h>
+#include <bpf/bpf_tracing.h>
+#include <bpf/bpf_helpers.h>
+
+struct map_elem {
+	struct bpf_timer timer;
+	struct bpf_spin_lock lock;
+};
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 1);
+	__type(key, int);
+	__type(value, struct map_elem);
+} amap SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__uint(max_entries, 1);
+	__type(key, int);
+	__type(value, struct map_elem);
+} hmap SEC(".maps");
+
+int pid = 0;
+int crash_map = 0; /* 0 for amap, 1 for hmap */
+
+SEC("fentry/do_nanosleep")
+int sys_enter(void *ctx)
+{
+	struct map_elem *e, value = {};
+	void *map = crash_map ? (void *)&hmap : (void *)&amap;
+
+	if (bpf_get_current_task_btf()->tgid != pid)
+		return 0;
+
+	*(void **)&value = (void *)0xdeadcaf3;
+
+	bpf_map_update_elem(map, &(int){0}, &value, 0);
+	/* For array map, doing bpf_map_update_elem will do a
+	 * check_and_free_timer_in_array, which will trigger the crash if timer
+	 * pointer was overwritten, for hmap we need to use bpf_timer_cancel.
+	 */
+	if (crash_map == 1) {
+		e = bpf_map_lookup_elem(map, &(int){0});
+		if (!e)
+			return 0;
+		bpf_timer_cancel(&e->timer);
+	}
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/memfd/memfd_test.c b/tools/testing/selftests/memfd/memfd_test.c
index 192a2899bae8..94df2692e6e4 100644
--- a/tools/testing/selftests/memfd/memfd_test.c
+++ b/tools/testing/selftests/memfd/memfd_test.c
@@ -455,6 +455,7 @@ static void mfd_fail_write(int fd)
 			printf("mmap()+mprotect() didn't fail as expected\n");
 			abort();
 		}
+		munmap(p, mfd_def_size);
 	}
 
 	/* verify PUNCH_HOLE fails */
diff --git a/tools/testing/selftests/net/pmtu.sh b/tools/testing/selftests/net/pmtu.sh
index 543ad7513a8e..694732e4b344 100755
--- a/tools/testing/selftests/net/pmtu.sh
+++ b/tools/testing/selftests/net/pmtu.sh
@@ -374,6 +374,16 @@ run_cmd() {
 	return $rc
 }
 
+run_cmd_bg() {
+	cmd="$*"
+
+	if [ "$VERBOSE" = "1" ]; then
+		printf "    COMMAND: %s &\n" "${cmd}"
+	fi
+
+	$cmd 2>&1 &
+}
+
 # Find the auto-generated name for this namespace
 nsname() {
 	eval echo \$NS_$1
@@ -670,10 +680,10 @@ setup_nettest_xfrm() {
 	[ ${1} -eq 6 ] && proto="-6" || proto=""
 	port=${2}
 
-	run_cmd ${ns_a} nettest ${proto} -q -D -s -x -p ${port} -t 5 &
+	run_cmd_bg "${ns_a}" nettest "${proto}" -q -D -s -x -p "${port}" -t 5
 	nettest_pids="${nettest_pids} $!"
 
-	run_cmd ${ns_b} nettest ${proto} -q -D -s -x -p ${port} -t 5 &
+	run_cmd_bg "${ns_b}" nettest "${proto}" -q -D -s -x -p "${port}" -t 5
 	nettest_pids="${nettest_pids} $!"
 }
 
@@ -865,7 +875,6 @@ setup_ovs_bridge() {
 setup() {
 	[ "$(id -u)" -ne 0 ] && echo "  need to run as root" && return $ksft_skip
 
-	cleanup
 	for arg do
 		eval setup_${arg} || { echo "  ${arg} not supported"; return 1; }
 	done
@@ -876,7 +885,7 @@ trace() {
 
 	for arg do
 		[ "${ns_cmd}" = "" ] && ns_cmd="${arg}" && continue
-		${ns_cmd} tcpdump -s 0 -i "${arg}" -w "${name}_${arg}.pcap" 2> /dev/null &
+		${ns_cmd} tcpdump --immediate-mode -s 0 -i "${arg}" -w "${name}_${arg}.pcap" 2> /dev/null &
 		tcpdump_pids="${tcpdump_pids} $!"
 		ns_cmd=
 	done
@@ -1836,6 +1845,10 @@ run_test() {
 
 	unset IFS
 
+	# Since cleanup() relies on variables modified by this subshell, it
+	# has to run in this context.
+	trap cleanup EXIT
+
 	if [ "$VERBOSE" = "1" ]; then
 		printf "\n##########################################################################\n\n"
 	fi
diff --git a/tools/testing/selftests/vm/map_fixed_noreplace.c b/tools/testing/selftests/vm/map_fixed_noreplace.c
index d91bde511268..eed44322d1a6 100644
--- a/tools/testing/selftests/vm/map_fixed_noreplace.c
+++ b/tools/testing/selftests/vm/map_fixed_noreplace.c
@@ -17,9 +17,6 @@
 #define MAP_FIXED_NOREPLACE 0x100000
 #endif
 
-#define BASE_ADDRESS	(256ul * 1024 * 1024)
-
-
 static void dump_maps(void)
 {
 	char cmd[32];
@@ -28,18 +25,46 @@ static void dump_maps(void)
 	system(cmd);
 }
 
+static unsigned long find_base_addr(unsigned long size)
+{
+	void *addr;
+	unsigned long flags;
+
+	flags = MAP_PRIVATE | MAP_ANONYMOUS;
+	addr = mmap(NULL, size, PROT_NONE, flags, -1, 0);
+	if (addr == MAP_FAILED) {
+		printf("Error: couldn't map the space we need for the test\n");
+		return 0;
+	}
+
+	if (munmap(addr, size) != 0) {
+		printf("Error: couldn't map the space we need for the test\n");
+		return 0;
+	}
+	return (unsigned long)addr;
+}
+
 int main(void)
 {
+	unsigned long base_addr;
 	unsigned long flags, addr, size, page_size;
 	char *p;
 
 	page_size = sysconf(_SC_PAGE_SIZE);
 
+	//let's find a base addr that is free before we start the tests
+	size = 5 * page_size;
+	base_addr = find_base_addr(size);
+	if (!base_addr) {
+		printf("Error: couldn't map the space we need for the test\n");
+		return 1;
+	}
+
 	flags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED_NOREPLACE;
 
 	// Check we can map all the areas we need below
 	errno = 0;
-	addr = BASE_ADDRESS;
+	addr = base_addr;
 	size = 5 * page_size;
 	p = mmap((void *)addr, size, PROT_NONE, flags, -1, 0);
 
@@ -60,7 +85,7 @@ int main(void)
 	printf("unmap() successful\n");
 
 	errno = 0;
-	addr = BASE_ADDRESS + page_size;
+	addr = base_addr + page_size;
 	size = 3 * page_size;
 	p = mmap((void *)addr, size, PROT_NONE, flags, -1, 0);
 	printf("mmap() @ 0x%lx-0x%lx p=%p result=%m\n", addr, addr + size, p);
@@ -80,7 +105,7 @@ int main(void)
 	 *     +4 |  free  | new
 	 */
 	errno = 0;
-	addr = BASE_ADDRESS;
+	addr = base_addr;
 	size = 5 * page_size;
 	p = mmap((void *)addr, size, PROT_NONE, flags, -1, 0);
 	printf("mmap() @ 0x%lx-0x%lx p=%p result=%m\n", addr, addr + size, p);
@@ -101,7 +126,7 @@ int main(void)
 	 *     +4 |  free  |
 	 */
 	errno = 0;
-	addr = BASE_ADDRESS + (2 * page_size);
+	addr = base_addr + (2 * page_size);
 	size = page_size;
 	p = mmap((void *)addr, size, PROT_NONE, flags, -1, 0);
 	printf("mmap() @ 0x%lx-0x%lx p=%p result=%m\n", addr, addr + size, p);
@@ -121,7 +146,7 @@ int main(void)
 	 *     +4 |  free  | new
 	 */
 	errno = 0;
-	addr = BASE_ADDRESS + (3 * page_size);
+	addr = base_addr + (3 * page_size);
 	size = 2 * page_size;
 	p = mmap((void *)addr, size, PROT_NONE, flags, -1, 0);
 	printf("mmap() @ 0x%lx-0x%lx p=%p result=%m\n", addr, addr + size, p);
@@ -141,7 +166,7 @@ int main(void)
 	 *     +4 |  free  |
 	 */
 	errno = 0;
-	addr = BASE_ADDRESS;
+	addr = base_addr;
 	size = 2 * page_size;
 	p = mmap((void *)addr, size, PROT_NONE, flags, -1, 0);
 	printf("mmap() @ 0x%lx-0x%lx p=%p result=%m\n", addr, addr + size, p);
@@ -161,7 +186,7 @@ int main(void)
 	 *     +4 |  free  |
 	 */
 	errno = 0;
-	addr = BASE_ADDRESS;
+	addr = base_addr;
 	size = page_size;
 	p = mmap((void *)addr, size, PROT_NONE, flags, -1, 0);
 	printf("mmap() @ 0x%lx-0x%lx p=%p result=%m\n", addr, addr + size, p);
@@ -181,7 +206,7 @@ int main(void)
 	 *     +4 |  free  |  new
 	 */
 	errno = 0;
-	addr = BASE_ADDRESS + (4 * page_size);
+	addr = base_addr + (4 * page_size);
 	size = page_size;
 	p = mmap((void *)addr, size, PROT_NONE, flags, -1, 0);
 	printf("mmap() @ 0x%lx-0x%lx p=%p result=%m\n", addr, addr + size, p);
@@ -192,7 +217,7 @@ int main(void)
 		return 1;
 	}
 
-	addr = BASE_ADDRESS;
+	addr = base_addr;
 	size = 5 * page_size;
 	if (munmap((void *)addr, size) != 0) {
 		dump_maps();
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f8b42e19bc77..fcceb8443aa9 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5417,9 +5417,7 @@ static int kvm_suspend(void)
 static void kvm_resume(void)
 {
 	if (kvm_usage_count) {
-#ifdef CONFIG_LOCKDEP
-		WARN_ON(lockdep_is_held(&kvm_count_lock));
-#endif
+		lockdep_assert_not_held(&kvm_count_lock);
 		hardware_enable_nolock(NULL);
 	}
 }
