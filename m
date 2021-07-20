Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB413CFD07
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 17:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240162AbhGTO1s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 10:27:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:52198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240175AbhGTOBV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Jul 2021 10:01:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C84F611CE;
        Tue, 20 Jul 2021 14:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626792118;
        bh=pARNap/9e6vwcYqJl95KLcQu9vdgO/iy9b/33zXqJ30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KB1F6jQqi4CqXHnXdFTGgxNdoYnpcWqSeQA4ctsilQmTWSNMV34YsfHGRTnzEiFfP
         IL4jphzbfREBlOgRZeIEIGoz2LOnFEINXLeZHE8tWQLKN/nHwAKm6IFbOK2qR3stug
         5Mw4cUkqGY1agIUoVVcw5k9dbTQ9KJu5naPNSjdY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.14.240
Date:   Tue, 20 Jul 2021 16:41:47 +0200
Message-Id: <162679210762236@kroah.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <1626792107180179@kroah.com>
References: <1626792107180179@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 3bb379664a96..c76ad4490eaf 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 14
-SUBLEVEL = 239
+SUBLEVEL = 240
 EXTRAVERSION =
 NAME = Petit Gorille
 
diff --git a/arch/arm/boot/dts/am335x-cm-t335.dts b/arch/arm/boot/dts/am335x-cm-t335.dts
index 947c81b7aaaf..56a04d3086c3 100644
--- a/arch/arm/boot/dts/am335x-cm-t335.dts
+++ b/arch/arm/boot/dts/am335x-cm-t335.dts
@@ -552,7 +552,7 @@ status = "okay";
 	status = "okay";
 	pinctrl-names = "default";
 	pinctrl-0 = <&spi0_pins>;
-	ti,pindir-d0-out-d1-in = <1>;
+	ti,pindir-d0-out-d1-in;
 	/* WLS1271 WiFi */
 	wlcore: wlcore@1 {
 		compatible = "ti,wl1271";
diff --git a/arch/arm/boot/dts/bcm5301x.dtsi b/arch/arm/boot/dts/bcm5301x.dtsi
index dffa8b9bd536..165fd1c1461a 100644
--- a/arch/arm/boot/dts/bcm5301x.dtsi
+++ b/arch/arm/boot/dts/bcm5301x.dtsi
@@ -432,27 +432,27 @@
 		      <0x1811b408 0x004>,
 		      <0x180293a0 0x01c>;
 		reg-names = "mspi", "bspi", "intr_regs", "intr_status_reg";
-		interrupts = <GIC_SPI 72 IRQ_TYPE_LEVEL_HIGH>,
+		interrupts = <GIC_SPI 77 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 78 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 72 IRQ_TYPE_LEVEL_HIGH>,
 			     <GIC_SPI 73 IRQ_TYPE_LEVEL_HIGH>,
 			     <GIC_SPI 74 IRQ_TYPE_LEVEL_HIGH>,
 			     <GIC_SPI 75 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 76 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 77 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 78 IRQ_TYPE_LEVEL_HIGH>;
-		interrupt-names = "spi_lr_fullness_reached",
+			     <GIC_SPI 76 IRQ_TYPE_LEVEL_HIGH>;
+		interrupt-names = "mspi_done",
+				  "mspi_halted",
+				  "spi_lr_fullness_reached",
 				  "spi_lr_session_aborted",
 				  "spi_lr_impatient",
 				  "spi_lr_session_done",
-				  "spi_lr_overhead",
-				  "mspi_done",
-				  "mspi_halted";
+				  "spi_lr_overread";
 		clocks = <&iprocmed>;
 		clock-names = "iprocmed";
 		num-cs = <2>;
 		#address-cells = <1>;
 		#size-cells = <0>;
 
-		spi_nor: spi-nor@0 {
+		spi_nor: flash@0 {
 			compatible = "jedec,spi-nor";
 			reg = <0>;
 			spi-max-frequency = <20000000>;
diff --git a/arch/arm/boot/dts/exynos5422-odroidxu4.dts b/arch/arm/boot/dts/exynos5422-odroidxu4.dts
index 2faf88627a48..b45e2a0c3908 100644
--- a/arch/arm/boot/dts/exynos5422-odroidxu4.dts
+++ b/arch/arm/boot/dts/exynos5422-odroidxu4.dts
@@ -26,7 +26,7 @@
 			label = "blue:heartbeat";
 			pwms = <&pwm 2 2000000 0>;
 			pwm-names = "pwm2";
-			max_brightness = <255>;
+			max-brightness = <255>;
 			linux,default-trigger = "heartbeat";
 		};
 	};
diff --git a/arch/arm/boot/dts/exynos54xx-odroidxu-leds.dtsi b/arch/arm/boot/dts/exynos54xx-odroidxu-leds.dtsi
index 0ed30206625c..f547f67f2783 100644
--- a/arch/arm/boot/dts/exynos54xx-odroidxu-leds.dtsi
+++ b/arch/arm/boot/dts/exynos54xx-odroidxu-leds.dtsi
@@ -25,7 +25,7 @@
 			 * Green LED is much brighter than the others
 			 * so limit its max brightness
 			 */
-			max_brightness = <127>;
+			max-brightness = <127>;
 			linux,default-trigger = "mmc0";
 		};
 
@@ -33,7 +33,7 @@
 			label = "blue:heartbeat";
 			pwms = <&pwm 2 2000000 0>;
 			pwm-names = "pwm2";
-			max_brightness = <255>;
+			max-brightness = <255>;
 			linux,default-trigger = "heartbeat";
 		};
 	};
diff --git a/arch/arm/boot/dts/r8a7779-marzen.dts b/arch/arm/boot/dts/r8a7779-marzen.dts
index 9412a86f9b30..8cae7a656cec 100644
--- a/arch/arm/boot/dts/r8a7779-marzen.dts
+++ b/arch/arm/boot/dts/r8a7779-marzen.dts
@@ -136,7 +136,7 @@
 	status = "okay";
 
 	clocks = <&mstp1_clks R8A7779_CLK_DU>, <&x3_clk>;
-	clock-names = "du", "dclkin.0";
+	clock-names = "du.0", "dclkin.0";
 
 	ports {
 		port@0 {
diff --git a/arch/arm/boot/dts/r8a7779.dtsi b/arch/arm/boot/dts/r8a7779.dtsi
index 2face089d65b..138cc43911d6 100644
--- a/arch/arm/boot/dts/r8a7779.dtsi
+++ b/arch/arm/boot/dts/r8a7779.dtsi
@@ -432,6 +432,7 @@
 		reg = <0xfff80000 0x40000>;
 		interrupts = <GIC_SPI 31 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&mstp1_clks R8A7779_CLK_DU>;
+		clock-names = "du.0";
 		power-domains = <&sysc R8A7779_PD_ALWAYS_ON>;
 		status = "disabled";
 
diff --git a/arch/arm/boot/dts/sama5d4.dtsi b/arch/arm/boot/dts/sama5d4.dtsi
index 81b526085097..e15cf0aa584f 100644
--- a/arch/arm/boot/dts/sama5d4.dtsi
+++ b/arch/arm/boot/dts/sama5d4.dtsi
@@ -1374,7 +1374,7 @@
 					0xffffffff 0x3ffcfe7c 0x1c010101	/* pioA */
 					0x7fffffff 0xfffccc3a 0x3f00cc3a	/* pioB */
 					0xffffffff 0x3ff83fff 0xff00ffff	/* pioC */
-					0x0003ff00 0x8002a800 0x00000000	/* pioD */
+					0xb003ff00 0x8002a800 0x00000000	/* pioD */
 					0xffffffff 0x7fffffff 0x76fff1bf	/* pioE */
 					>;
 
diff --git a/arch/arm/probes/kprobes/test-thumb.c b/arch/arm/probes/kprobes/test-thumb.c
index b683b4517458..4254391f3906 100644
--- a/arch/arm/probes/kprobes/test-thumb.c
+++ b/arch/arm/probes/kprobes/test-thumb.c
@@ -444,21 +444,21 @@ void kprobe_thumb32_test_cases(void)
 		"3:	mvn	r0, r0	\n\t"
 		"2:	nop		\n\t")
 
-	TEST_RX("tbh	[pc, r",7, (9f-(1f+4))>>1,"]",
+	TEST_RX("tbh	[pc, r",7, (9f-(1f+4))>>1,", lsl #1]",
 		"9:			\n\t"
 		".short	(2f-1b-4)>>1	\n\t"
 		".short	(3f-1b-4)>>1	\n\t"
 		"3:	mvn	r0, r0	\n\t"
 		"2:	nop		\n\t")
 
-	TEST_RX("tbh	[pc, r",12, ((9f-(1f+4))>>1)+1,"]",
+	TEST_RX("tbh	[pc, r",12, ((9f-(1f+4))>>1)+1,", lsl #1]",
 		"9:			\n\t"
 		".short	(2f-1b-4)>>1	\n\t"
 		".short	(3f-1b-4)>>1	\n\t"
 		"3:	mvn	r0, r0	\n\t"
 		"2:	nop		\n\t")
 
-	TEST_RRX("tbh	[r",1,9f, ", r",14,1,"]",
+	TEST_RRX("tbh	[r",1,9f, ", r",14,1,", lsl #1]",
 		"9:			\n\t"
 		".short	(2f-1b-4)>>1	\n\t"
 		".short	(3f-1b-4)>>1	\n\t"
@@ -471,10 +471,10 @@ void kprobe_thumb32_test_cases(void)
 
 	TEST_UNSUPPORTED("strexb	r0, r1, [r2]")
 	TEST_UNSUPPORTED("strexh	r0, r1, [r2]")
-	TEST_UNSUPPORTED("strexd	r0, r1, [r2]")
+	TEST_UNSUPPORTED("strexd	r0, r1, r2, [r2]")
 	TEST_UNSUPPORTED("ldrexb	r0, [r1]")
 	TEST_UNSUPPORTED("ldrexh	r0, [r1]")
-	TEST_UNSUPPORTED("ldrexd	r0, [r1]")
+	TEST_UNSUPPORTED("ldrexd	r0, r1, [r1]")
 
 	TEST_GROUP("Data-processing (shifted register) and (modified immediate)")
 
diff --git a/arch/hexagon/kernel/vmlinux.lds.S b/arch/hexagon/kernel/vmlinux.lds.S
index ec87e67feb19..22c10102712a 100644
--- a/arch/hexagon/kernel/vmlinux.lds.S
+++ b/arch/hexagon/kernel/vmlinux.lds.S
@@ -71,13 +71,8 @@ SECTIONS
 
 	_end = .;
 
-	/DISCARD/ : {
-		EXIT_TEXT
-		EXIT_DATA
-		EXIT_CALL
-	}
-
 	STABS_DEBUG
 	DWARF_DEBUG
 
+	DISCARDS
 }
diff --git a/arch/ia64/kernel/mca_drv.c b/arch/ia64/kernel/mca_drv.c
index 94f8bf777afa..3503d488e9b3 100644
--- a/arch/ia64/kernel/mca_drv.c
+++ b/arch/ia64/kernel/mca_drv.c
@@ -343,7 +343,7 @@ init_record_index_pools(void)
 
 	/* - 2 - */
 	sect_min_size = sal_log_sect_min_sizes[0];
-	for (i = 1; i < sizeof sal_log_sect_min_sizes/sizeof(size_t); i++)
+	for (i = 1; i < ARRAY_SIZE(sal_log_sect_min_sizes); i++)
 		if (sect_min_size > sal_log_sect_min_sizes[i])
 			sect_min_size = sal_log_sect_min_sizes[i];
 
diff --git a/arch/mips/boot/compressed/Makefile b/arch/mips/boot/compressed/Makefile
index 516e593a8ee9..b5f08fac5ddc 100644
--- a/arch/mips/boot/compressed/Makefile
+++ b/arch/mips/boot/compressed/Makefile
@@ -33,7 +33,7 @@ KBUILD_AFLAGS := $(KBUILD_AFLAGS) -D__ASSEMBLY__ \
 KCOV_INSTRUMENT		:= n
 
 # decompressor objects (linked with vmlinuz)
-vmlinuzobjs-y := $(obj)/head.o $(obj)/decompress.o $(obj)/string.o
+vmlinuzobjs-y := $(obj)/head.o $(obj)/decompress.o $(obj)/string.o $(obj)/bswapsi.o
 
 ifdef CONFIG_DEBUG_ZBOOT
 vmlinuzobjs-$(CONFIG_DEBUG_ZBOOT)		   += $(obj)/dbg.o
@@ -47,7 +47,7 @@ extra-y += uart-ath79.c
 $(obj)/uart-ath79.c: $(srctree)/arch/mips/ath79/early_printk.c
 	$(call cmd,shipped)
 
-vmlinuzobjs-$(CONFIG_KERNEL_XZ) += $(obj)/ashldi3.o $(obj)/bswapsi.o
+vmlinuzobjs-$(CONFIG_KERNEL_XZ) += $(obj)/ashldi3.o
 
 extra-y += ashldi3.c bswapsi.c
 $(obj)/ashldi3.o $(obj)/bswapsi.o: KBUILD_CFLAGS += -I$(srctree)/arch/mips/lib
diff --git a/arch/mips/boot/compressed/decompress.c b/arch/mips/boot/compressed/decompress.c
index 3a015e41b762..66096c766a60 100644
--- a/arch/mips/boot/compressed/decompress.c
+++ b/arch/mips/boot/compressed/decompress.c
@@ -11,6 +11,8 @@
  * option) any later version.
  */
 
+#define DISABLE_BRANCH_PROFILING
+
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
diff --git a/arch/mips/include/asm/hugetlb.h b/arch/mips/include/asm/hugetlb.h
index 982bc0685330..4747a4694669 100644
--- a/arch/mips/include/asm/hugetlb.h
+++ b/arch/mips/include/asm/hugetlb.h
@@ -67,7 +67,13 @@ static inline pte_t huge_ptep_get_and_clear(struct mm_struct *mm,
 static inline void huge_ptep_clear_flush(struct vm_area_struct *vma,
 					 unsigned long addr, pte_t *ptep)
 {
-	flush_tlb_page(vma, addr & huge_page_mask(hstate_vma(vma)));
+	/*
+	 * clear the huge pte entry firstly, so that the other smp threads will
+	 * not get old pte entry after finishing flush_tlb_page and before
+	 * setting new huge pte entry
+	 */
+	huge_ptep_get_and_clear(vma->vm_mm, addr, ptep);
+	flush_tlb_page(vma, addr);
 }
 
 static inline int huge_pte_none(pte_t pte)
diff --git a/arch/mips/include/asm/pgalloc.h b/arch/mips/include/asm/pgalloc.h
index 39b9f311c4ef..f800872f867b 100644
--- a/arch/mips/include/asm/pgalloc.h
+++ b/arch/mips/include/asm/pgalloc.h
@@ -93,11 +93,15 @@ do {							\
 
 static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address)
 {
-	pmd_t *pmd;
+	pmd_t *pmd = NULL;
+	struct page *pg;
 
-	pmd = (pmd_t *) __get_free_pages(GFP_KERNEL, PMD_ORDER);
-	if (pmd)
+	pg = alloc_pages(GFP_KERNEL | __GFP_ACCOUNT, PMD_ORDER);
+	if (pg) {
+		pgtable_pmd_page_ctor(pg);
+		pmd = (pmd_t *)page_address(pg);
 		pmd_init((unsigned long)pmd, (unsigned long)invalid_pte_table);
+	}
 	return pmd;
 }
 
diff --git a/arch/mips/vdso/vdso.h b/arch/mips/vdso/vdso.h
index cfb1be441dec..921589b45bc2 100644
--- a/arch/mips/vdso/vdso.h
+++ b/arch/mips/vdso/vdso.h
@@ -81,7 +81,7 @@ static inline const union mips_vdso_data *get_vdso_data(void)
 
 static inline void __iomem *get_gic(const union mips_vdso_data *data)
 {
-	return (void __iomem *)data - PAGE_SIZE;
+	return (void __iomem *)((unsigned long)data & PAGE_MASK) - PAGE_SIZE;
 }
 
 #endif /* CONFIG_CLKSRC_MIPS_GIC */
diff --git a/arch/powerpc/boot/devtree.c b/arch/powerpc/boot/devtree.c
index a7e21a35c03a..27c84b82b588 100644
--- a/arch/powerpc/boot/devtree.c
+++ b/arch/powerpc/boot/devtree.c
@@ -17,6 +17,7 @@
 #include "string.h"
 #include "stdio.h"
 #include "ops.h"
+#include "of.h"
 
 void dt_fixup_memory(u64 start, u64 size)
 {
@@ -27,21 +28,25 @@ void dt_fixup_memory(u64 start, u64 size)
 	root = finddevice("/");
 	if (getprop(root, "#address-cells", &naddr, sizeof(naddr)) < 0)
 		naddr = 2;
+	else
+		naddr = be32_to_cpu(naddr);
 	if (naddr < 1 || naddr > 2)
 		fatal("Can't cope with #address-cells == %d in /\n\r", naddr);
 
 	if (getprop(root, "#size-cells", &nsize, sizeof(nsize)) < 0)
 		nsize = 1;
+	else
+		nsize = be32_to_cpu(nsize);
 	if (nsize < 1 || nsize > 2)
 		fatal("Can't cope with #size-cells == %d in /\n\r", nsize);
 
 	i = 0;
 	if (naddr == 2)
-		memreg[i++] = start >> 32;
-	memreg[i++] = start & 0xffffffff;
+		memreg[i++] = cpu_to_be32(start >> 32);
+	memreg[i++] = cpu_to_be32(start & 0xffffffff);
 	if (nsize == 2)
-		memreg[i++] = size >> 32;
-	memreg[i++] = size & 0xffffffff;
+		memreg[i++] = cpu_to_be32(size >> 32);
+	memreg[i++] = cpu_to_be32(size & 0xffffffff);
 
 	memory = finddevice("/memory");
 	if (! memory) {
@@ -49,9 +54,9 @@ void dt_fixup_memory(u64 start, u64 size)
 		setprop_str(memory, "device_type", "memory");
 	}
 
-	printf("Memory <- <0x%x", memreg[0]);
+	printf("Memory <- <0x%x", be32_to_cpu(memreg[0]));
 	for (i = 1; i < (naddr + nsize); i++)
-		printf(" 0x%x", memreg[i]);
+		printf(" 0x%x", be32_to_cpu(memreg[i]));
 	printf("> (%ldMB)\n\r", (unsigned long)(size >> 20));
 
 	setprop(memory, "reg", memreg, (naddr + nsize)*sizeof(u32));
@@ -69,10 +74,10 @@ void dt_fixup_cpu_clocks(u32 cpu, u32 tb, u32 bus)
 		printf("CPU bus-frequency <- 0x%x (%dMHz)\n\r", bus, MHZ(bus));
 
 	while ((devp = find_node_by_devtype(devp, "cpu"))) {
-		setprop_val(devp, "clock-frequency", cpu);
-		setprop_val(devp, "timebase-frequency", tb);
+		setprop_val(devp, "clock-frequency", cpu_to_be32(cpu));
+		setprop_val(devp, "timebase-frequency", cpu_to_be32(tb));
 		if (bus > 0)
-			setprop_val(devp, "bus-frequency", bus);
+			setprop_val(devp, "bus-frequency", cpu_to_be32(bus));
 	}
 
 	timebase_period_ns = 1000000000 / tb;
@@ -84,7 +89,7 @@ void dt_fixup_clock(const char *path, u32 freq)
 
 	if (devp) {
 		printf("%s: clock-frequency <- %x (%dMHz)\n\r", path, freq, MHZ(freq));
-		setprop_val(devp, "clock-frequency", freq);
+		setprop_val(devp, "clock-frequency", cpu_to_be32(freq));
 	}
 }
 
@@ -137,8 +142,12 @@ void dt_get_reg_format(void *node, u32 *naddr, u32 *nsize)
 {
 	if (getprop(node, "#address-cells", naddr, 4) != 4)
 		*naddr = 2;
+	else
+		*naddr = be32_to_cpu(*naddr);
 	if (getprop(node, "#size-cells", nsize, 4) != 4)
 		*nsize = 1;
+	else
+		*nsize = be32_to_cpu(*nsize);
 }
 
 static void copy_val(u32 *dest, u32 *src, int naddr)
@@ -167,9 +176,9 @@ static int add_reg(u32 *reg, u32 *add, int naddr)
 	int i, carry = 0;
 
 	for (i = MAX_ADDR_CELLS - 1; i >= MAX_ADDR_CELLS - naddr; i--) {
-		u64 tmp = (u64)reg[i] + add[i] + carry;
+		u64 tmp = (u64)be32_to_cpu(reg[i]) + be32_to_cpu(add[i]) + carry;
 		carry = tmp >> 32;
-		reg[i] = (u32)tmp;
+		reg[i] = cpu_to_be32((u32)tmp);
 	}
 
 	return !carry;
@@ -184,18 +193,18 @@ static int compare_reg(u32 *reg, u32 *range, u32 *rangesize)
 	u32 end;
 
 	for (i = 0; i < MAX_ADDR_CELLS; i++) {
-		if (reg[i] < range[i])
+		if (be32_to_cpu(reg[i]) < be32_to_cpu(range[i]))
 			return 0;
-		if (reg[i] > range[i])
+		if (be32_to_cpu(reg[i]) > be32_to_cpu(range[i]))
 			break;
 	}
 
 	for (i = 0; i < MAX_ADDR_CELLS; i++) {
-		end = range[i] + rangesize[i];
+		end = be32_to_cpu(range[i]) + be32_to_cpu(rangesize[i]);
 
-		if (reg[i] < end)
+		if (be32_to_cpu(reg[i]) < end)
 			break;
-		if (reg[i] > end)
+		if (be32_to_cpu(reg[i]) > end)
 			return 0;
 	}
 
@@ -244,7 +253,6 @@ static int dt_xlate(void *node, int res, int reglen, unsigned long *addr,
 		return 0;
 
 	dt_get_reg_format(parent, &naddr, &nsize);
-
 	if (nsize > 2)
 		return 0;
 
@@ -256,10 +264,10 @@ static int dt_xlate(void *node, int res, int reglen, unsigned long *addr,
 
 	copy_val(last_addr, prop_buf + offset, naddr);
 
-	ret_size = prop_buf[offset + naddr];
+	ret_size = be32_to_cpu(prop_buf[offset + naddr]);
 	if (nsize == 2) {
 		ret_size <<= 32;
-		ret_size |= prop_buf[offset + naddr + 1];
+		ret_size |= be32_to_cpu(prop_buf[offset + naddr + 1]);
 	}
 
 	for (;;) {
@@ -282,7 +290,6 @@ static int dt_xlate(void *node, int res, int reglen, unsigned long *addr,
 
 		offset = find_range(last_addr, prop_buf, prev_naddr,
 		                    naddr, prev_nsize, buflen / 4);
-
 		if (offset < 0)
 			return 0;
 
@@ -300,8 +307,7 @@ static int dt_xlate(void *node, int res, int reglen, unsigned long *addr,
 	if (naddr > 2)
 		return 0;
 
-	ret_addr = ((u64)last_addr[2] << 32) | last_addr[3];
-
+	ret_addr = ((u64)be32_to_cpu(last_addr[2]) << 32) | be32_to_cpu(last_addr[3]);
 	if (sizeof(void *) == 4 &&
 	    (ret_addr >= 0x100000000ULL || ret_size > 0x100000000ULL ||
 	     ret_addr + ret_size > 0x100000000ULL))
@@ -354,11 +360,14 @@ int dt_is_compatible(void *node, const char *compat)
 int dt_get_virtual_reg(void *node, void **addr, int nres)
 {
 	unsigned long xaddr;
-	int n;
+	int n, i;
 
 	n = getprop(node, "virtual-reg", addr, nres * 4);
-	if (n > 0)
+	if (n > 0) {
+		for (i = 0; i < n/4; i ++)
+			((u32 *)addr)[i] = be32_to_cpu(((u32 *)addr)[i]);
 		return n / 4;
+	}
 
 	for (n = 0; n < nres; n++) {
 		if (!dt_xlate_reg(node, n, &xaddr, NULL))
diff --git a/arch/powerpc/boot/ns16550.c b/arch/powerpc/boot/ns16550.c
index b0da4466d419..f16d2be1d0f3 100644
--- a/arch/powerpc/boot/ns16550.c
+++ b/arch/powerpc/boot/ns16550.c
@@ -15,6 +15,7 @@
 #include "stdio.h"
 #include "io.h"
 #include "ops.h"
+#include "of.h"
 
 #define UART_DLL	0	/* Out: Divisor Latch Low */
 #define UART_DLM	1	/* Out: Divisor Latch High */
@@ -58,16 +59,20 @@ int ns16550_console_init(void *devp, struct serial_console_data *scdp)
 	int n;
 	u32 reg_offset;
 
-	if (dt_get_virtual_reg(devp, (void **)&reg_base, 1) < 1)
+	if (dt_get_virtual_reg(devp, (void **)&reg_base, 1) < 1) {
+		printf("virt reg parse fail...\r\n");
 		return -1;
+	}
 
 	n = getprop(devp, "reg-offset", &reg_offset, sizeof(reg_offset));
 	if (n == sizeof(reg_offset))
-		reg_base += reg_offset;
+		reg_base += be32_to_cpu(reg_offset);
 
 	n = getprop(devp, "reg-shift", &reg_shift, sizeof(reg_shift));
 	if (n != sizeof(reg_shift))
 		reg_shift = 0;
+	else
+		reg_shift = be32_to_cpu(reg_shift);
 
 	scdp->open = ns16550_open;
 	scdp->putc = ns16550_putc;
diff --git a/arch/powerpc/include/asm/barrier.h b/arch/powerpc/include/asm/barrier.h
index 449474f667c4..19aee8cce495 100644
--- a/arch/powerpc/include/asm/barrier.h
+++ b/arch/powerpc/include/asm/barrier.h
@@ -42,6 +42,8 @@
 #    define SMPWMB      eieio
 #endif
 
+/* clang defines this macro for a builtin, which will not work with runtime patching */
+#undef __lwsync
 #define __lwsync()	__asm__ __volatile__ (stringify_in_c(LWSYNC) : : :"memory")
 #define dma_rmb()	__lwsync()
 #define dma_wmb()	__asm__ __volatile__ (stringify_in_c(SMPWMB) : : :"memory")
diff --git a/arch/powerpc/include/asm/ps3.h b/arch/powerpc/include/asm/ps3.h
index 17ee719e799f..013d24d246d6 100644
--- a/arch/powerpc/include/asm/ps3.h
+++ b/arch/powerpc/include/asm/ps3.h
@@ -83,6 +83,7 @@ struct ps3_dma_region_ops;
  * @bus_addr: The 'translated' bus address of the region.
  * @len: The length in bytes of the region.
  * @offset: The offset from the start of memory of the region.
+ * @dma_mask: Device dma_mask.
  * @ioid: The IOID of the device who owns this region
  * @chunk_list: Opaque variable used by the ioc page manager.
  * @region_ops: struct ps3_dma_region_ops - dma region operations
@@ -97,6 +98,7 @@ struct ps3_dma_region {
 	enum ps3_dma_region_type region_type;
 	unsigned long len;
 	unsigned long offset;
+	u64 dma_mask;
 
 	/* driver variables  (set by ps3_dma_region_create) */
 	unsigned long bus_addr;
diff --git a/arch/powerpc/platforms/ps3/mm.c b/arch/powerpc/platforms/ps3/mm.c
index 19bae78b1f25..76cbf1be9962 100644
--- a/arch/powerpc/platforms/ps3/mm.c
+++ b/arch/powerpc/platforms/ps3/mm.c
@@ -18,6 +18,7 @@
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
+#include <linux/dma-mapping.h>
 #include <linux/kernel.h>
 #include <linux/export.h>
 #include <linux/memblock.h>
@@ -1132,6 +1133,7 @@ int ps3_dma_region_init(struct ps3_system_bus_device *dev,
 	enum ps3_dma_region_type region_type, void *addr, unsigned long len)
 {
 	unsigned long lpar_addr;
+	int result;
 
 	lpar_addr = addr ? ps3_mm_phys_to_lpar(__pa(addr)) : 0;
 
@@ -1143,6 +1145,16 @@ int ps3_dma_region_init(struct ps3_system_bus_device *dev,
 		r->offset -= map.r1.offset;
 	r->len = len ? len : _ALIGN_UP(map.total, 1 << r->page_size);
 
+	dev->core.dma_mask = &r->dma_mask;
+
+	result = dma_set_mask_and_coherent(&dev->core, DMA_BIT_MASK(32));
+
+	if (result < 0) {
+		dev_err(&dev->core, "%s:%d: dma_set_mask_and_coherent failed: %d\n",
+			__func__, __LINE__, result);
+		return result;
+	}
+
 	switch (dev->dev_type) {
 	case PS3_DEVICE_TYPE_SB:
 		r->region_ops =  (USE_DYNAMIC_DMA)
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 49fb6614ea8c..8dbadad1117c 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -892,7 +892,7 @@ config CMM_IUCV
 config APPLDATA_BASE
 	def_bool n
 	prompt "Linux - VM Monitor Stream, base infrastructure"
-	depends on PROC_FS
+	depends on PROC_SYSCTL
 	help
 	  This provides a kernel interface for creating and updating z/VM APPLDATA
 	  monitor records. The monitor records are updated at certain time
diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index 42025e33a4e0..ceaee215e243 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -140,7 +140,7 @@ static void __init set_preferred_console(void)
 	else if (CONSOLE_IS_3270)
 		add_preferred_console("tty3270", 0, NULL);
 	else if (CONSOLE_IS_VT220)
-		add_preferred_console("ttyS", 1, NULL);
+		add_preferred_console("ttysclp", 0, NULL);
 	else if (CONSOLE_IS_HVC)
 		add_preferred_console("hvc", 0, NULL);
 }
diff --git a/arch/um/drivers/chan_user.c b/arch/um/drivers/chan_user.c
index 3fd7c3efdb18..feb7f5ab4084 100644
--- a/arch/um/drivers/chan_user.c
+++ b/arch/um/drivers/chan_user.c
@@ -256,7 +256,8 @@ static int winch_tramp(int fd, struct tty_port *port, int *fd_out,
 		goto out_close;
 	}
 
-	if (os_set_fd_block(*fd_out, 0)) {
+	err = os_set_fd_block(*fd_out, 0);
+	if (err) {
 		printk(UM_KERN_ERR "winch_tramp: failed to set thread_fd "
 		       "non-blocking.\n");
 		goto out_close;
diff --git a/arch/um/drivers/slip_user.c b/arch/um/drivers/slip_user.c
index 0d6b66c64a81..76d155631c5d 100644
--- a/arch/um/drivers/slip_user.c
+++ b/arch/um/drivers/slip_user.c
@@ -145,7 +145,8 @@ static int slip_open(void *data)
 	}
 	sfd = err;
 
-	if (set_up_tty(sfd))
+	err = set_up_tty(sfd);
+	if (err)
 		goto out_close2;
 
 	pri->slave = sfd;
diff --git a/arch/x86/include/asm/fpu/internal.h b/arch/x86/include/asm/fpu/internal.h
index fa2c93cb42a2..b8c935033d21 100644
--- a/arch/x86/include/asm/fpu/internal.h
+++ b/arch/x86/include/asm/fpu/internal.h
@@ -103,6 +103,7 @@ static inline void fpstate_init_fxstate(struct fxregs_state *fx)
 }
 extern void fpstate_sanitize_xstate(struct fpu *fpu);
 
+/* Returns 0 or the negated trap number, which results in -EFAULT for #PF */
 #define user_insn(insn, output, input...)				\
 ({									\
 	int err;							\
@@ -110,14 +111,14 @@ extern void fpstate_sanitize_xstate(struct fpu *fpu);
 	might_fault();							\
 									\
 	asm volatile(ASM_STAC "\n"					\
-		     "1:" #insn "\n\t"					\
+		     "1: " #insn "\n"					\
 		     "2: " ASM_CLAC "\n"				\
 		     ".section .fixup,\"ax\"\n"				\
-		     "3:  movl $-1,%[err]\n"				\
+		     "3:  negl %%eax\n"					\
 		     "    jmp  2b\n"					\
 		     ".previous\n"					\
-		     _ASM_EXTABLE(1b, 3b)				\
-		     : [err] "=r" (err), output				\
+		     _ASM_EXTABLE_FAULT(1b, 3b)				\
+		     : [err] "=a" (err), output				\
 		     : "0"(0), input);					\
 	err;								\
 })
@@ -221,16 +222,20 @@ static inline void copy_fxregs_to_kernel(struct fpu *fpu)
 #define XRSTOR		".byte " REX_PREFIX "0x0f,0xae,0x2f"
 #define XRSTORS		".byte " REX_PREFIX "0x0f,0xc7,0x1f"
 
+/*
+ * After this @err contains 0 on success or the negated trap number when
+ * the operation raises an exception. For faults this results in -EFAULT.
+ */
 #define XSTATE_OP(op, st, lmask, hmask, err)				\
 	asm volatile("1:" op "\n\t"					\
 		     "xor %[err], %[err]\n"				\
 		     "2:\n\t"						\
 		     ".pushsection .fixup,\"ax\"\n\t"			\
-		     "3: movl $-2,%[err]\n\t"				\
+		     "3: negl %%eax\n\t"				\
 		     "jmp 2b\n\t"					\
 		     ".popsection\n\t"					\
-		     _ASM_EXTABLE(1b, 3b)				\
-		     : [err] "=r" (err)					\
+		     _ASM_EXTABLE_FAULT(1b, 3b)				\
+		     : [err] "=a" (err)					\
 		     : "D" (st), "m" (*st), "a" (lmask), "d" (hmask)	\
 		     : "memory")
 
diff --git a/arch/x86/kernel/fpu/regset.c b/arch/x86/kernel/fpu/regset.c
index bc02f5144b95..621d249ded0b 100644
--- a/arch/x86/kernel/fpu/regset.c
+++ b/arch/x86/kernel/fpu/regset.c
@@ -128,7 +128,7 @@ int xstateregs_set(struct task_struct *target, const struct user_regset *regset,
 	/*
 	 * A whole standard-format XSAVE buffer is needed:
 	 */
-	if ((pos != 0) || (count < fpu_user_xstate_size))
+	if (pos != 0 || count != fpu_user_xstate_size)
 		return -EFAULT;
 
 	xsave = &fpu->state.xsave;
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 6ec1cfd0addd..7e1ab0e0f3f2 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -649,8 +649,14 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 		unsigned virt_as = max((entry->eax >> 8) & 0xff, 48U);
 		unsigned phys_as = entry->eax & 0xff;
 
-		if (!g_phys_as)
+		/*
+		 * Use bare metal's MAXPHADDR if the CPU doesn't report guest
+		 * MAXPHYADDR separately, or if TDP (NPT) is disabled, as the
+		 * guest version "applies only to guests using nested paging".
+		 */
+		if (!g_phys_as || !tdp_enabled)
 			g_phys_as = phys_as;
+
 		entry->eax = g_phys_as | (virt_as << 8);
 		entry->edx = 0;
 		/*
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6a6f1788c882..37d826acd017 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7237,6 +7237,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		set_debugreg(vcpu->arch.eff_db[3], 3);
 		set_debugreg(vcpu->arch.dr6, 6);
 		vcpu->arch.switch_db_regs &= ~KVM_DEBUGREG_RELOAD;
+	} else if (unlikely(hw_breakpoint_active())) {
+		set_debugreg(0, 7);
 	}
 
 	kvm_x86_ops->run(vcpu);
diff --git a/crypto/shash.c b/crypto/shash.c
index a04145e5306a..55e7a2f63b34 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -25,12 +25,24 @@
 
 static const struct crypto_type crypto_shash_type;
 
-int shash_no_setkey(struct crypto_shash *tfm, const u8 *key,
-		    unsigned int keylen)
+static int shash_no_setkey(struct crypto_shash *tfm, const u8 *key,
+			   unsigned int keylen)
 {
 	return -ENOSYS;
 }
-EXPORT_SYMBOL_GPL(shash_no_setkey);
+
+/*
+ * Check whether an shash algorithm has a setkey function.
+ *
+ * For CFI compatibility, this must not be an inline function.  This is because
+ * when CFI is enabled, modules won't get the same address for shash_no_setkey
+ * (if it were exported, which inlining would require) as the core kernel will.
+ */
+bool crypto_shash_alg_has_setkey(struct shash_alg *alg)
+{
+	return alg->setkey != shash_no_setkey;
+}
+EXPORT_SYMBOL_GPL(crypto_shash_alg_has_setkey);
 
 static int shash_setkey_unaligned(struct crypto_shash *tfm, const u8 *key,
 				  unsigned int keylen)
diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
index cd1abc9bc325..f9df9541f2ce 100644
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -8,6 +8,11 @@ ccflags-$(CONFIG_ACPI_DEBUG)	+= -DACPI_DEBUG_OUTPUT
 #
 # ACPI Boot-Time Table Parsing
 #
+ifeq ($(CONFIG_ACPI_CUSTOM_DSDT),y)
+tables.o: $(src)/../../include/$(subst $\",,$(CONFIG_ACPI_CUSTOM_DSDT_FILE)) ;
+
+endif
+
 obj-$(CONFIG_ACPI)		+= tables.o
 obj-$(CONFIG_X86)		+= blacklist.o
 
diff --git a/drivers/acpi/acpi_amba.c b/drivers/acpi/acpi_amba.c
index 7f77c071709a..eb09ee71ceb2 100644
--- a/drivers/acpi/acpi_amba.c
+++ b/drivers/acpi/acpi_amba.c
@@ -70,6 +70,7 @@ static int amba_handler_attach(struct acpi_device *adev,
 		case IORESOURCE_MEM:
 			if (!address_found) {
 				dev->res = *rentry->res;
+				dev->res.name = dev_name(&dev->dev);
 				address_found = true;
 			}
 			break;
diff --git a/drivers/acpi/acpi_video.c b/drivers/acpi/acpi_video.c
index 7df7abde1fcb..5a69260edf80 100644
--- a/drivers/acpi/acpi_video.c
+++ b/drivers/acpi/acpi_video.c
@@ -556,6 +556,15 @@ static const struct dmi_system_id video_dmi_table[] = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "Vostro V131"),
 		},
 	},
+	{
+	 .callback = video_set_report_key_events,
+	 .driver_data = (void *)((uintptr_t)REPORT_BRIGHTNESS_KEY_EVENTS),
+	 .ident = "Dell Vostro 3350",
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "Vostro 3350"),
+		},
+	},
 	/*
 	 * Some machines change the brightness themselves when a brightness
 	 * hotkey gets pressed, despite us telling them not to. In this case
diff --git a/drivers/acpi/acpica/nsrepair2.c b/drivers/acpi/acpica/nsrepair2.c
index 06037e044694..78b802b5f7d3 100644
--- a/drivers/acpi/acpica/nsrepair2.c
+++ b/drivers/acpi/acpica/nsrepair2.c
@@ -409,6 +409,13 @@ acpi_ns_repair_CID(struct acpi_evaluate_info *info,
 
 			(*element_ptr)->common.reference_count =
 			    original_ref_count;
+
+			/*
+			 * The original_element holds a reference from the package object
+			 * that represents _HID. Since a new element was created by _HID,
+			 * remove the reference from the _CID package.
+			 */
+			acpi_ut_remove_reference(original_element);
 		}
 
 		element_ptr++;
diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index 1cb7c6a52f61..7ea02bb50c73 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -1249,6 +1249,7 @@ static int __init acpi_init(void)
 	init_acpi_device_notify();
 	result = acpi_bus_init();
 	if (result) {
+		kobject_put(acpi_kobj);
 		disable_acpi();
 		return result;
 	}
diff --git a/drivers/acpi/device_sysfs.c b/drivers/acpi/device_sysfs.c
index 6d7ff5ef702c..9f4743d9804b 100644
--- a/drivers/acpi/device_sysfs.c
+++ b/drivers/acpi/device_sysfs.c
@@ -452,7 +452,7 @@ static ssize_t description_show(struct device *dev,
 		(wchar_t *)acpi_dev->pnp.str_obj->buffer.pointer,
 		acpi_dev->pnp.str_obj->buffer.length,
 		UTF16_LITTLE_ENDIAN, buf,
-		PAGE_SIZE);
+		PAGE_SIZE - 1);
 
 	buf[result++] = '\n';
 
diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 37aacb39e692..f8fc30be6871 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -1886,6 +1886,22 @@ static const struct dmi_system_id ec_dmi_table[] __initconst = {
 	DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
 	DMI_MATCH(DMI_PRODUCT_NAME, "GL702VMK"),}, NULL},
 	{
+	ec_honor_ecdt_gpe, "ASUSTeK COMPUTER INC. X505BA", {
+	DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+	DMI_MATCH(DMI_PRODUCT_NAME, "X505BA"),}, NULL},
+	{
+	ec_honor_ecdt_gpe, "ASUSTeK COMPUTER INC. X505BP", {
+	DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+	DMI_MATCH(DMI_PRODUCT_NAME, "X505BP"),}, NULL},
+	{
+	ec_honor_ecdt_gpe, "ASUSTeK COMPUTER INC. X542BA", {
+	DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+	DMI_MATCH(DMI_PRODUCT_NAME, "X542BA"),}, NULL},
+	{
+	ec_honor_ecdt_gpe, "ASUSTeK COMPUTER INC. X542BP", {
+	DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+	DMI_MATCH(DMI_PRODUCT_NAME, "X542BP"),}, NULL},
+	{
 	ec_honor_ecdt_gpe, "ASUS X550VXK", {
 	DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
 	DMI_MATCH(DMI_PRODUCT_NAME, "X550VXK"),}, NULL},
diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index d50a7b6ccddd..590eeca2419f 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -29,6 +29,7 @@
 #include <linux/acpi.h>
 #include <linux/dmi.h>
 #include <linux/sched.h>       /* need_resched() */
+#include <linux/sort.h>
 #include <linux/tick.h>
 #include <linux/cpuidle.h>
 #include <linux/cpu.h>
@@ -540,10 +541,37 @@ static void acpi_processor_power_verify_c3(struct acpi_processor *pr,
 	return;
 }
 
+static int acpi_cst_latency_cmp(const void *a, const void *b)
+{
+	const struct acpi_processor_cx *x = a, *y = b;
+
+	if (!(x->valid && y->valid))
+		return 0;
+	if (x->latency > y->latency)
+		return 1;
+	if (x->latency < y->latency)
+		return -1;
+	return 0;
+}
+static void acpi_cst_latency_swap(void *a, void *b, int n)
+{
+	struct acpi_processor_cx *x = a, *y = b;
+	u32 tmp;
+
+	if (!(x->valid && y->valid))
+		return;
+	tmp = x->latency;
+	x->latency = y->latency;
+	y->latency = tmp;
+}
+
 static int acpi_processor_power_verify(struct acpi_processor *pr)
 {
 	unsigned int i;
 	unsigned int working = 0;
+	unsigned int last_latency = 0;
+	unsigned int last_type = 0;
+	bool buggy_latency = false;
 
 	pr->power.timer_broadcast_on_state = INT_MAX;
 
@@ -567,12 +595,24 @@ static int acpi_processor_power_verify(struct acpi_processor *pr)
 		}
 		if (!cx->valid)
 			continue;
+		if (cx->type >= last_type && cx->latency < last_latency)
+			buggy_latency = true;
+		last_latency = cx->latency;
+		last_type = cx->type;
 
 		lapic_timer_check_state(i, pr, cx);
 		tsc_check_state(cx->type);
 		working++;
 	}
 
+	if (buggy_latency) {
+		pr_notice("FW issue: working around C-state latencies out of order\n");
+		sort(&pr->power.states[1], max_cstate,
+		     sizeof(struct acpi_processor_cx),
+		     acpi_cst_latency_cmp,
+		     acpi_cst_latency_swap);
+	}
+
 	lapic_timer_propagate_broadcast(pr);
 
 	return (working);
diff --git a/drivers/ata/ahci_sunxi.c b/drivers/ata/ahci_sunxi.c
index b26437430163..98b4f0d898d6 100644
--- a/drivers/ata/ahci_sunxi.c
+++ b/drivers/ata/ahci_sunxi.c
@@ -165,7 +165,7 @@ static void ahci_sunxi_start_engine(struct ata_port *ap)
 }
 
 static const struct ata_port_info ahci_sunxi_port_info = {
-	.flags		= AHCI_FLAG_COMMON | ATA_FLAG_NCQ,
+	.flags		= AHCI_FLAG_COMMON | ATA_FLAG_NCQ | ATA_FLAG_NO_DIPM,
 	.pio_mask	= ATA_PIO4,
 	.udma_mask	= ATA_UDMA6,
 	.port_ops	= &ahci_platform_ops,
diff --git a/drivers/ata/pata_ep93xx.c b/drivers/ata/pata_ep93xx.c
index cc6d06c1b2c7..7ce62cdb63a5 100644
--- a/drivers/ata/pata_ep93xx.c
+++ b/drivers/ata/pata_ep93xx.c
@@ -927,7 +927,7 @@ static int ep93xx_pata_probe(struct platform_device *pdev)
 	/* INT[3] (IRQ_EP93XX_EXT3) line connected as pull down */
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0) {
-		err = -ENXIO;
+		err = irq;
 		goto err_rel_gpio;
 	}
 
diff --git a/drivers/ata/pata_octeon_cf.c b/drivers/ata/pata_octeon_cf.c
index d3d851b014a3..ac3b1fda820f 100644
--- a/drivers/ata/pata_octeon_cf.c
+++ b/drivers/ata/pata_octeon_cf.c
@@ -898,10 +898,11 @@ static int octeon_cf_probe(struct platform_device *pdev)
 					return -EINVAL;
 				}
 
-				irq_handler = octeon_cf_interrupt;
 				i = platform_get_irq(dma_dev, 0);
-				if (i > 0)
+				if (i > 0) {
 					irq = i;
+					irq_handler = octeon_cf_interrupt;
+				}
 			}
 			of_node_put(dma_node);
 		}
diff --git a/drivers/ata/pata_rb532_cf.c b/drivers/ata/pata_rb532_cf.c
index 653b9a0bf727..0416a390b94c 100644
--- a/drivers/ata/pata_rb532_cf.c
+++ b/drivers/ata/pata_rb532_cf.c
@@ -120,10 +120,12 @@ static int rb532_pata_driver_probe(struct platform_device *pdev)
 	}
 
 	irq = platform_get_irq(pdev, 0);
-	if (irq <= 0) {
+	if (irq < 0) {
 		dev_err(&pdev->dev, "no IRQ resource found\n");
-		return -ENOENT;
+		return irq;
 	}
+	if (!irq)
+		return -EINVAL;
 
 	pdata = dev_get_platdata(&pdev->dev);
 	if (!pdata) {
diff --git a/drivers/ata/sata_highbank.c b/drivers/ata/sata_highbank.c
index e67815b896fc..1dd47a05b34b 100644
--- a/drivers/ata/sata_highbank.c
+++ b/drivers/ata/sata_highbank.c
@@ -483,10 +483,12 @@ static int ahci_highbank_probe(struct platform_device *pdev)
 	}
 
 	irq = platform_get_irq(pdev, 0);
-	if (irq <= 0) {
+	if (irq < 0) {
 		dev_err(dev, "no irq\n");
-		return -EINVAL;
+		return irq;
 	}
+	if (!irq)
+		return -EINVAL;
 
 	hpriv = devm_kzalloc(dev, sizeof(*hpriv), GFP_KERNEL);
 	if (!hpriv) {
diff --git a/drivers/atm/iphase.c b/drivers/atm/iphase.c
index 2b29598791e8..16eb0266a59a 100644
--- a/drivers/atm/iphase.c
+++ b/drivers/atm/iphase.c
@@ -3301,7 +3301,7 @@ static void __exit ia_module_exit(void)
 {
 	pci_unregister_driver(&ia_driver);
 
-        del_timer(&ia_timer);
+	del_timer_sync(&ia_timer);
 }
 
 module_init(ia_module_init);
diff --git a/drivers/atm/nicstar.c b/drivers/atm/nicstar.c
index 7b2c5019bfcd..52b735e23ba9 100644
--- a/drivers/atm/nicstar.c
+++ b/drivers/atm/nicstar.c
@@ -298,7 +298,7 @@ static void __exit nicstar_cleanup(void)
 {
 	XPRINTK("nicstar: nicstar_cleanup() called.\n");
 
-	del_timer(&ns_timer);
+	del_timer_sync(&ns_timer);
 
 	pci_unregister_driver(&nicstar_driver);
 
@@ -526,6 +526,15 @@ static int ns_init_card(int i, struct pci_dev *pcidev)
 	/* Set the VPI/VCI MSb mask to zero so we can receive OAM cells */
 	writel(0x00000000, card->membase + VPM);
 
+	card->intcnt = 0;
+	if (request_irq
+	    (pcidev->irq, &ns_irq_handler, IRQF_SHARED, "nicstar", card) != 0) {
+		pr_err("nicstar%d: can't allocate IRQ %d.\n", i, pcidev->irq);
+		error = 9;
+		ns_init_card_error(card, error);
+		return error;
+	}
+
 	/* Initialize TSQ */
 	card->tsq.org = dma_alloc_coherent(&card->pcidev->dev,
 					   NS_TSQSIZE + NS_TSQ_ALIGNMENT,
@@ -752,15 +761,6 @@ static int ns_init_card(int i, struct pci_dev *pcidev)
 
 	card->efbie = 1;
 
-	card->intcnt = 0;
-	if (request_irq
-	    (pcidev->irq, &ns_irq_handler, IRQF_SHARED, "nicstar", card) != 0) {
-		printk("nicstar%d: can't allocate IRQ %d.\n", i, pcidev->irq);
-		error = 9;
-		ns_init_card_error(card, error);
-		return error;
-	}
-
 	/* Register device */
 	card->atmdev = atm_dev_register("nicstar", &card->pcidev->dev, &atm_ops,
 					-1, NULL);
@@ -838,10 +838,12 @@ static void ns_init_card_error(ns_dev *card, int error)
 			dev_kfree_skb_any(hb);
 	}
 	if (error >= 12) {
-		kfree(card->rsq.org);
+		dma_free_coherent(&card->pcidev->dev, NS_RSQSIZE + NS_RSQ_ALIGNMENT,
+				card->rsq.org, card->rsq.dma);
 	}
 	if (error >= 11) {
-		kfree(card->tsq.org);
+		dma_free_coherent(&card->pcidev->dev, NS_TSQSIZE + NS_TSQ_ALIGNMENT,
+				card->tsq.org, card->tsq.dma);
 	}
 	if (error >= 10) {
 		free_irq(card->pcidev->irq, card);
diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 2f15e38fb3f8..437d43747c6d 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -931,6 +931,8 @@ static int virtblk_freeze(struct virtio_device *vdev)
 	blk_mq_quiesce_queue(vblk->disk->queue);
 
 	vdev->config->del_vqs(vdev);
+	kfree(vblk->vqs);
+
 	return 0;
 }
 
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 424f399cc79b..f2e84e09c970 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -2614,6 +2614,11 @@ static int btusb_setup_qca_download_fw(struct hci_dev *hdev,
 	sent += size;
 	count -= size;
 
+	/* ep2 need time to switch from function acl to function dfu,
+	 * so we add 20ms delay here.
+	 */
+	msleep(20);
+
 	while (count) {
 		size = min_t(size_t, count, QCA_DFU_PACKET_LEN);
 
diff --git a/drivers/char/ipmi/ipmi_watchdog.c b/drivers/char/ipmi/ipmi_watchdog.c
index 3d832d0362a4..9e9bf7ab3cb5 100644
--- a/drivers/char/ipmi/ipmi_watchdog.c
+++ b/drivers/char/ipmi/ipmi_watchdog.c
@@ -394,16 +394,18 @@ static int i_ipmi_set_timeout(struct ipmi_smi_msg  *smi_msg,
 	data[0] = 0;
 	WDOG_SET_TIMER_USE(data[0], WDOG_TIMER_USE_SMS_OS);
 
-	if ((ipmi_version_major > 1)
-	    || ((ipmi_version_major == 1) && (ipmi_version_minor >= 5))) {
-		/* This is an IPMI 1.5-only feature. */
-		data[0] |= WDOG_DONT_STOP_ON_SET;
-	} else if (ipmi_watchdog_state != WDOG_TIMEOUT_NONE) {
-		/*
-		 * In ipmi 1.0, setting the timer stops the watchdog, we
-		 * need to start it back up again.
-		 */
-		hbnow = 1;
+	if (ipmi_watchdog_state != WDOG_TIMEOUT_NONE) {
+		if ((ipmi_version_major > 1) ||
+		    ((ipmi_version_major == 1) && (ipmi_version_minor >= 5))) {
+			/* This is an IPMI 1.5-only feature. */
+			data[0] |= WDOG_DONT_STOP_ON_SET;
+		} else {
+			/*
+			 * In ipmi 1.0, setting the timer stops the watchdog, we
+			 * need to start it back up again.
+			 */
+			hbnow = 1;
+		}
 	}
 
 	data[1] = 0;
diff --git a/drivers/char/pcmcia/cm4000_cs.c b/drivers/char/pcmcia/cm4000_cs.c
index cd53771b9ae7..432e161efe5d 100644
--- a/drivers/char/pcmcia/cm4000_cs.c
+++ b/drivers/char/pcmcia/cm4000_cs.c
@@ -544,6 +544,10 @@ static int set_protocol(struct cm4000_dev *dev, struct ptsreq *ptsreq)
 		io_read_num_rec_bytes(iobase, &num_bytes_read);
 		if (num_bytes_read >= 4) {
 			DEBUGP(2, dev, "NumRecBytes = %i\n", num_bytes_read);
+			if (num_bytes_read > 4) {
+				rc = -EIO;
+				goto exit_setprotocol;
+			}
 			break;
 		}
 		mdelay(10);
diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index 6a57237e46db..0fb3a8e62e62 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -489,7 +489,7 @@ static struct port_buffer *get_inbuf(struct port *port)
 
 	buf = virtqueue_get_buf(port->in_vq, &len);
 	if (buf) {
-		buf->len = len;
+		buf->len = min_t(size_t, len, buf->size);
 		buf->offset = 0;
 		port->stats.bytes_received += len;
 	}
@@ -1755,7 +1755,7 @@ static void control_work_handler(struct work_struct *work)
 	while ((buf = virtqueue_get_buf(vq, &len))) {
 		spin_unlock(&portdev->c_ivq_lock);
 
-		buf->len = len;
+		buf->len = min_t(size_t, len, buf->size);
 		buf->offset = 0;
 
 		handle_control_message(vq->vdev, portdev, buf);
diff --git a/drivers/clk/renesas/r8a77995-cpg-mssr.c b/drivers/clk/renesas/r8a77995-cpg-mssr.c
index 8434d5530fb1..4a3633ebcc6b 100644
--- a/drivers/clk/renesas/r8a77995-cpg-mssr.c
+++ b/drivers/clk/renesas/r8a77995-cpg-mssr.c
@@ -73,6 +73,7 @@ static const struct cpg_core_clk r8a77995_core_clks[] __initconst = {
 	DEF_FIXED(".sdsrc",    CLK_SDSRC,          CLK_PLL1,       2, 1),
 
 	/* Core Clock Outputs */
+	DEF_FIXED("za2",       R8A77995_CLK_ZA2,   CLK_PLL0D3,     2, 1),
 	DEF_FIXED("z2",        R8A77995_CLK_Z2,    CLK_PLL0D3,     1, 1),
 	DEF_FIXED("ztr",       R8A77995_CLK_ZTR,   CLK_PLL1,       6, 1),
 	DEF_FIXED("zt",        R8A77995_CLK_ZT,    CLK_PLL1,       4, 1),
diff --git a/drivers/clk/tegra/clk-pll.c b/drivers/clk/tegra/clk-pll.c
index dc87866233b9..ed3b725ff102 100644
--- a/drivers/clk/tegra/clk-pll.c
+++ b/drivers/clk/tegra/clk-pll.c
@@ -1091,7 +1091,8 @@ static int clk_pllu_enable(struct clk_hw *hw)
 	if (pll->lock)
 		spin_lock_irqsave(pll->lock, flags);
 
-	_clk_pll_enable(hw);
+	if (!clk_pll_is_enabled(hw))
+		_clk_pll_enable(hw);
 
 	ret = clk_pll_wait_for_lock(pll);
 	if (ret < 0)
@@ -1708,7 +1709,8 @@ static int clk_pllu_tegra114_enable(struct clk_hw *hw)
 	if (pll->lock)
 		spin_lock_irqsave(pll->lock, flags);
 
-	_clk_pll_enable(hw);
+	if (!clk_pll_is_enabled(hw))
+		_clk_pll_enable(hw);
 
 	ret = clk_pll_wait_for_lock(pll);
 	if (ret < 0)
diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
index 9859aa683a28..e820d99c555f 100644
--- a/drivers/crypto/ccp/sp-pci.c
+++ b/drivers/crypto/ccp/sp-pci.c
@@ -173,7 +173,7 @@ static int sp_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		if (ret) {
 			dev_err(dev, "dma_set_mask_and_coherent failed (%d)\n",
 				ret);
-			goto e_err;
+			goto free_irqs;
 		}
 	}
 
@@ -181,12 +181,14 @@ static int sp_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	ret = sp_init(sp);
 	if (ret)
-		goto e_err;
+		goto free_irqs;
 
 	dev_notice(dev, "enabled\n");
 
 	return 0;
 
+free_irqs:
+	sp_free_irqs(sp);
 e_err:
 	dev_notice(dev, "initialization failed\n");
 	return ret;
diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index 4b6773c345ab..a2266334297b 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -333,7 +333,7 @@ static void free_buf_chain(struct device *dev, struct buffer_desc *buf,u32 phys)
 
 		buf1 = buf->next;
 		phys1 = buf->phys_next;
-		dma_unmap_single(dev, buf->phys_next, buf->buf_len, buf->dir);
+		dma_unmap_single(dev, buf->phys_addr, buf->buf_len, buf->dir);
 		dma_pool_free(buffer_pool, buf, phys);
 		buf = buf1;
 		phys = phys1;
diff --git a/drivers/crypto/nx/nx-842-pseries.c b/drivers/crypto/nx/nx-842-pseries.c
index cddc6d8b55d9..1b8c87770645 100644
--- a/drivers/crypto/nx/nx-842-pseries.c
+++ b/drivers/crypto/nx/nx-842-pseries.c
@@ -553,13 +553,15 @@ static int nx842_OF_set_defaults(struct nx842_devdata *devdata)
  * The status field indicates if the device is enabled when the status
  * is 'okay'.  Otherwise the device driver will be disabled.
  *
- * @prop - struct property point containing the maxsyncop for the update
+ * @devdata: struct nx842_devdata to use for dev_info
+ * @prop: struct property point containing the maxsyncop for the update
  *
  * Returns:
  *  0 - Device is available
  *  -ENODEV - Device is not available
  */
-static int nx842_OF_upd_status(struct property *prop)
+static int nx842_OF_upd_status(struct nx842_devdata *devdata,
+			       struct property *prop)
 {
 	const char *status = (const char *)prop->value;
 
@@ -773,7 +775,7 @@ static int nx842_OF_upd(struct property *new_prop)
 		goto out;
 
 	/* Perform property updates */
-	ret = nx842_OF_upd_status(status);
+	ret = nx842_OF_upd_status(new_devdata, status);
 	if (ret)
 		goto error_out;
 
@@ -1086,6 +1088,7 @@ static struct vio_device_id nx842_vio_driver_ids[] = {
 	{"ibm,compression-v1", "ibm,compression"},
 	{"", ""},
 };
+MODULE_DEVICE_TABLE(vio, nx842_vio_driver_ids);
 
 static struct vio_driver nx842_vio_driver = {
 	.name = KBUILD_MODNAME,
diff --git a/drivers/crypto/qat/qat_common/qat_hal.c b/drivers/crypto/qat/qat_common/qat_hal.c
index 8c4fd255a601..cdf80c16a033 100644
--- a/drivers/crypto/qat/qat_common/qat_hal.c
+++ b/drivers/crypto/qat/qat_common/qat_hal.c
@@ -1255,7 +1255,11 @@ static int qat_hal_put_rel_wr_xfer(struct icp_qat_fw_loader_handle *handle,
 		pr_err("QAT: bad xfrAddr=0x%x\n", xfr_addr);
 		return -EINVAL;
 	}
-	qat_hal_rd_rel_reg(handle, ae, ctx, ICP_GPB_REL, gprnum, &gprval);
+	status = qat_hal_rd_rel_reg(handle, ae, ctx, ICP_GPB_REL, gprnum, &gprval);
+	if (status) {
+		pr_err("QAT: failed to read register");
+		return status;
+	}
 	gpr_addr = qat_hal_get_reg_addr(ICP_GPB_REL, gprnum);
 	data16low = 0xffff & data;
 	data16hi = 0xffff & (data >> 0x10);
diff --git a/drivers/crypto/qat/qat_common/qat_uclo.c b/drivers/crypto/qat/qat_common/qat_uclo.c
index 4f1cd83bf56f..a8e3191e5185 100644
--- a/drivers/crypto/qat/qat_common/qat_uclo.c
+++ b/drivers/crypto/qat/qat_common/qat_uclo.c
@@ -385,7 +385,6 @@ static int qat_uclo_init_umem_seg(struct icp_qat_fw_loader_handle *handle,
 	return 0;
 }
 
-#define ICP_DH895XCC_PESRAM_BAR_SIZE 0x80000
 static int qat_uclo_init_ae_memory(struct icp_qat_fw_loader_handle *handle,
 				   struct icp_qat_uof_initmem *init_mem)
 {
diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index 17c8e2b28c42..7500ec9efa6a 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -1006,6 +1006,7 @@ static int hash_hw_final(struct ahash_request *req)
 			goto out;
 		}
 	} else if (req->nbytes == 0 && ctx->keylen > 0) {
+		ret = -EPERM;
 		dev_err(device_data->dev, "%s: Empty message with keylength > 0, NOT supported\n",
 			__func__);
 		goto out;
diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
index b9b48d45a6dc..17d426829f5d 100644
--- a/drivers/extcon/extcon-max8997.c
+++ b/drivers/extcon/extcon-max8997.c
@@ -783,3 +783,4 @@ module_platform_driver(max8997_muic_driver);
 MODULE_DESCRIPTION("Maxim MAX8997 Extcon driver");
 MODULE_AUTHOR("Donggeun Kim <dg77.kim@samsung.com>");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:max8997-muic");
diff --git a/drivers/extcon/extcon-sm5502.c b/drivers/extcon/extcon-sm5502.c
index 1a1ee3db3455..431538a14ec8 100644
--- a/drivers/extcon/extcon-sm5502.c
+++ b/drivers/extcon/extcon-sm5502.c
@@ -92,7 +92,6 @@ static struct reg_data sm5502_reg_data[] = {
 			| SM5502_REG_INTM2_MHL_MASK,
 		.invert = true,
 	},
-	{ }
 };
 
 /* List of detectable cables */
diff --git a/drivers/firmware/qemu_fw_cfg.c b/drivers/firmware/qemu_fw_cfg.c
index c53c7ac992f8..586dedadb2f0 100644
--- a/drivers/firmware/qemu_fw_cfg.c
+++ b/drivers/firmware/qemu_fw_cfg.c
@@ -192,15 +192,13 @@ static int fw_cfg_do_platform_probe(struct platform_device *pdev)
 /* fw_cfg revision attribute, in /sys/firmware/qemu_fw_cfg top-level dir. */
 static u32 fw_cfg_rev;
 
-static ssize_t fw_cfg_showrev(struct kobject *k, struct attribute *a, char *buf)
+static ssize_t fw_cfg_showrev(struct kobject *k, struct kobj_attribute *a,
+			      char *buf)
 {
 	return sprintf(buf, "%u\n", fw_cfg_rev);
 }
 
-static const struct {
-	struct attribute attr;
-	ssize_t (*show)(struct kobject *k, struct attribute *a, char *buf);
-} fw_cfg_rev_attr = {
+static const struct kobj_attribute fw_cfg_rev_attr = {
 	.attr = { .name = "rev", .mode = S_IRUSR },
 	.show = fw_cfg_showrev,
 };
diff --git a/drivers/gpio/gpio-zynq.c b/drivers/gpio/gpio-zynq.c
index f1d7066b6637..e8295519fa7d 100644
--- a/drivers/gpio/gpio-zynq.c
+++ b/drivers/gpio/gpio-zynq.c
@@ -900,8 +900,11 @@ static int zynq_gpio_probe(struct platform_device *pdev)
 static int zynq_gpio_remove(struct platform_device *pdev)
 {
 	struct zynq_gpio *gpio = platform_get_drvdata(pdev);
+	int ret;
 
-	pm_runtime_get_sync(&pdev->dev);
+	ret = pm_runtime_get_sync(&pdev->dev);
+	if (ret < 0)
+		dev_warn(&pdev->dev, "pm_runtime_get_sync() Failed\n");
 	gpiochip_remove(&gpio->chip);
 	clk_disable_unprepare(gpio->clk);
 	device_set_wakeup_capable(&pdev->dev, 0);
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index bc746a6e0ecc..076b22c44122 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -1823,7 +1823,7 @@ static int amdgpu_sriov_reinit_early(struct amdgpu_device *adev)
 		AMD_IP_BLOCK_TYPE_IH,
 	};
 
-	for (i = 0; i < ARRAY_SIZE(ip_order); i++) {
+	for (i = 0; i < adev->num_ip_blocks; i++) {
 		int j;
 		struct amdgpu_ip_block *block;
 
diff --git a/drivers/gpu/drm/mxsfb/Kconfig b/drivers/gpu/drm/mxsfb/Kconfig
index e9a8d90e6723..3ed6849d63cb 100644
--- a/drivers/gpu/drm/mxsfb/Kconfig
+++ b/drivers/gpu/drm/mxsfb/Kconfig
@@ -9,7 +9,6 @@ config DRM_MXSFB
 	depends on COMMON_CLK
 	select DRM_MXS
 	select DRM_KMS_HELPER
-	select DRM_KMS_FB_HELPER
 	select DRM_KMS_CMA_HELPER
 	select DRM_PANEL
 	help
diff --git a/drivers/gpu/drm/qxl/qxl_dumb.c b/drivers/gpu/drm/qxl/qxl_dumb.c
index 11085ab01374..9a0c92d8a1eb 100644
--- a/drivers/gpu/drm/qxl/qxl_dumb.c
+++ b/drivers/gpu/drm/qxl/qxl_dumb.c
@@ -57,6 +57,8 @@ int qxl_mode_dumb_create(struct drm_file *file_priv,
 	surf.height = args->height;
 	surf.stride = pitch;
 	surf.format = format;
+	surf.data = 0;
+
 	r = qxl_gem_object_create_with_handle(qdev, file_priv,
 					      QXL_GEM_DOMAIN_VRAM,
 					      args->size, &surf, &qobj,
diff --git a/drivers/gpu/drm/radeon/radeon_display.c b/drivers/gpu/drm/radeon/radeon_display.c
index b2334349799d..173439a8c881 100644
--- a/drivers/gpu/drm/radeon/radeon_display.c
+++ b/drivers/gpu/drm/radeon/radeon_display.c
@@ -1347,6 +1347,7 @@ radeon_user_framebuffer_create(struct drm_device *dev,
 	/* Handle is imported dma-buf, so cannot be migrated to VRAM for scanout */
 	if (obj->import_attach) {
 		DRM_DEBUG_KMS("Cannot create framebuffer from imported dma_buf\n");
+		drm_gem_object_put(obj);
 		return ERR_PTR(-EINVAL);
 	}
 
diff --git a/drivers/gpu/drm/rockchip/cdn-dp-core.c b/drivers/gpu/drm/rockchip/cdn-dp-core.c
index a57da051f516..97ce3c5c3fce 100644
--- a/drivers/gpu/drm/rockchip/cdn-dp-core.c
+++ b/drivers/gpu/drm/rockchip/cdn-dp-core.c
@@ -83,6 +83,7 @@ static int cdn_dp_grf_write(struct cdn_dp_device *dp,
 	ret = regmap_write(dp->grf, reg, val);
 	if (ret) {
 		DRM_DEV_ERROR(dp->dev, "Could not write to GRF: %d\n", ret);
+		clk_disable_unprepare(dp->grf_clk);
 		return ret;
 	}
 
diff --git a/drivers/gpu/drm/virtio/virtgpu_kms.c b/drivers/gpu/drm/virtio/virtgpu_kms.c
index bed450fbb216..5251c29966d3 100644
--- a/drivers/gpu/drm/virtio/virtgpu_kms.c
+++ b/drivers/gpu/drm/virtio/virtgpu_kms.c
@@ -237,6 +237,7 @@ int virtio_gpu_driver_load(struct drm_device *dev, unsigned long flags)
 err_vbufs:
 	vgdev->vdev->config->del_vqs(vgdev->vdev);
 err_vqs:
+	dev->dev_private = NULL;
 	kfree(vgdev);
 	return ret;
 }
diff --git a/drivers/gpu/drm/zte/Kconfig b/drivers/gpu/drm/zte/Kconfig
index 5b36421ef3e5..75b70126d2d3 100644
--- a/drivers/gpu/drm/zte/Kconfig
+++ b/drivers/gpu/drm/zte/Kconfig
@@ -2,7 +2,6 @@ config DRM_ZTE
 	tristate "DRM Support for ZTE SoCs"
 	depends on DRM && ARCH_ZX
 	select DRM_KMS_CMA_HELPER
-	select DRM_KMS_FB_HELPER
 	select DRM_KMS_HELPER
 	select SND_SOC_HDMI_CODEC if SND_SOC
 	select VIDEOMODE_HELPERS
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 381ab96c1e38..a3656a158ba3 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -2613,12 +2613,8 @@ static int hid_device_remove(struct device *dev)
 {
 	struct hid_device *hdev = to_hid_device(dev);
 	struct hid_driver *hdrv;
-	int ret = 0;
 
-	if (down_interruptible(&hdev->driver_input_lock)) {
-		ret = -EINTR;
-		goto end;
-	}
+	down(&hdev->driver_input_lock);
 	hdev->io_started = false;
 
 	hdrv = hdev->driver;
@@ -2633,8 +2629,8 @@ static int hid_device_remove(struct device *dev)
 
 	if (!hdev->io_started)
 		up(&hdev->driver_input_lock);
-end:
-	return ret;
+
+	return 0;
 }
 
 static ssize_t modalias_show(struct device *dev, struct device_attribute *a,
diff --git a/drivers/hid/wacom_wac.h b/drivers/hid/wacom_wac.h
index d2fe7af2c152..55b542a6a66b 100644
--- a/drivers/hid/wacom_wac.h
+++ b/drivers/hid/wacom_wac.h
@@ -121,7 +121,7 @@
 #define WACOM_HID_WD_TOUCHONOFF         (WACOM_HID_UP_WACOMDIGITIZER | 0x0454)
 #define WACOM_HID_WD_BATTERY_LEVEL      (WACOM_HID_UP_WACOMDIGITIZER | 0x043b)
 #define WACOM_HID_WD_EXPRESSKEY00       (WACOM_HID_UP_WACOMDIGITIZER | 0x0910)
-#define WACOM_HID_WD_EXPRESSKEYCAP00    (WACOM_HID_UP_WACOMDIGITIZER | 0x0950)
+#define WACOM_HID_WD_EXPRESSKEYCAP00    (WACOM_HID_UP_WACOMDIGITIZER | 0x0940)
 #define WACOM_HID_WD_MODE_CHANGE        (WACOM_HID_UP_WACOMDIGITIZER | 0x0980)
 #define WACOM_HID_WD_MUTE_DEVICE        (WACOM_HID_UP_WACOMDIGITIZER | 0x0981)
 #define WACOM_HID_WD_CONTROLPANEL       (WACOM_HID_UP_WACOMDIGITIZER | 0x0982)
diff --git a/drivers/hv/hv_util.c b/drivers/hv/hv_util.c
index 14dce25c104f..8b2ebcab1518 100644
--- a/drivers/hv/hv_util.c
+++ b/drivers/hv/hv_util.c
@@ -545,8 +545,8 @@ static int hv_timesync_init(struct hv_util_service *srv)
 	 */
 	hv_ptp_clock = ptp_clock_register(&ptp_hyperv_info, NULL);
 	if (IS_ERR_OR_NULL(hv_ptp_clock)) {
-		pr_err("cannot register PTP clock: %ld\n",
-		       PTR_ERR(hv_ptp_clock));
+		pr_err("cannot register PTP clock: %d\n",
+		       PTR_ERR_OR_ZERO(hv_ptp_clock));
 		hv_ptp_clock = NULL;
 	}
 
diff --git a/drivers/hwmon/max31722.c b/drivers/hwmon/max31722.c
index 30a100e70a0d..877c3d7dca01 100644
--- a/drivers/hwmon/max31722.c
+++ b/drivers/hwmon/max31722.c
@@ -9,7 +9,6 @@
  * directory of this archive for more details.
  */
 
-#include <linux/acpi.h>
 #include <linux/hwmon.h>
 #include <linux/hwmon-sysfs.h>
 #include <linux/kernel.h>
@@ -138,20 +137,12 @@ static const struct spi_device_id max31722_spi_id[] = {
 	{"max31723", 0},
 	{}
 };
-
-static const struct acpi_device_id __maybe_unused max31722_acpi_id[] = {
-	{"MAX31722", 0},
-	{"MAX31723", 0},
-	{}
-};
-
 MODULE_DEVICE_TABLE(spi, max31722_spi_id);
 
 static struct spi_driver max31722_driver = {
 	.driver = {
 		.name = "max31722",
 		.pm = &max31722_pm_ops,
-		.acpi_match_table = ACPI_PTR(max31722_acpi_id),
 	},
 	.probe =            max31722_probe,
 	.remove =           max31722_remove,
diff --git a/drivers/hwmon/max31790.c b/drivers/hwmon/max31790.c
index 281491cca510..66cf772de7d2 100644
--- a/drivers/hwmon/max31790.c
+++ b/drivers/hwmon/max31790.c
@@ -179,7 +179,7 @@ static int max31790_read_fan(struct device *dev, u32 attr, int channel,
 
 	switch (attr) {
 	case hwmon_fan_input:
-		sr = get_tach_period(data->fan_dynamics[channel]);
+		sr = get_tach_period(data->fan_dynamics[channel % NR_CHANNEL]);
 		rpm = RPM_FROM_REG(data->tach[channel], sr);
 		*val = rpm;
 		return 0;
diff --git a/drivers/hwtracing/intel_th/core.c b/drivers/hwtracing/intel_th/core.c
index 6a451b4fc04d..4b270ed7f27b 100644
--- a/drivers/hwtracing/intel_th/core.c
+++ b/drivers/hwtracing/intel_th/core.c
@@ -223,6 +223,22 @@ static ssize_t port_show(struct device *dev, struct device_attribute *attr,
 
 static DEVICE_ATTR_RO(port);
 
+static void intel_th_trace_prepare(struct intel_th_device *thdev)
+{
+	struct intel_th_device *hub = to_intel_th_hub(thdev);
+	struct intel_th_driver *hubdrv = to_intel_th_driver(hub->dev.driver);
+
+	if (hub->type != INTEL_TH_SWITCH)
+		return;
+
+	if (thdev->type != INTEL_TH_OUTPUT)
+		return;
+
+	pm_runtime_get_sync(&thdev->dev);
+	hubdrv->prepare(hub, &thdev->output);
+	pm_runtime_put(&thdev->dev);
+}
+
 static int intel_th_output_activate(struct intel_th_device *thdev)
 {
 	struct intel_th_driver *thdrv =
@@ -243,6 +259,7 @@ static int intel_th_output_activate(struct intel_th_device *thdev)
 	if (ret)
 		goto fail_put;
 
+	intel_th_trace_prepare(thdev);
 	if (thdrv->activate)
 		ret = thdrv->activate(thdev);
 	else
diff --git a/drivers/hwtracing/intel_th/gth.c b/drivers/hwtracing/intel_th/gth.c
index 79473ba48d0c..4edc54448f31 100644
--- a/drivers/hwtracing/intel_th/gth.c
+++ b/drivers/hwtracing/intel_th/gth.c
@@ -521,6 +521,21 @@ static void gth_tscu_resync(struct gth_device *gth)
 	iowrite32(reg, gth->base + REG_TSCU_TSUCTRL);
 }
 
+static void intel_th_gth_prepare(struct intel_th_device *thdev,
+				 struct intel_th_output *output)
+{
+	struct gth_device *gth = dev_get_drvdata(&thdev->dev);
+	int count;
+
+	/*
+	 * Wait until the output port is in reset before we start
+	 * programming it.
+	 */
+	for (count = GTH_PLE_WAITLOOP_DEPTH;
+	     count && !(gth_output_get(gth, output->port) & BIT(5)); count--)
+		cpu_relax();
+}
+
 /**
  * intel_th_gth_enable() - enable tracing to an output device
  * @thdev:	GTH device
@@ -742,6 +757,7 @@ static struct intel_th_driver intel_th_gth_driver = {
 	.assign		= intel_th_gth_assign,
 	.unassign	= intel_th_gth_unassign,
 	.set_output	= intel_th_gth_set_output,
+	.prepare	= intel_th_gth_prepare,
 	.enable		= intel_th_gth_enable,
 	.disable	= intel_th_gth_disable,
 	.driver	= {
diff --git a/drivers/hwtracing/intel_th/intel_th.h b/drivers/hwtracing/intel_th/intel_th.h
index 99ad563fc40d..093a89e29ce6 100644
--- a/drivers/hwtracing/intel_th/intel_th.h
+++ b/drivers/hwtracing/intel_th/intel_th.h
@@ -140,6 +140,7 @@ intel_th_output_assigned(struct intel_th_device *thdev)
  * @remove:	remove method
  * @assign:	match a given output type device against available outputs
  * @unassign:	deassociate an output type device from an output port
+ * @prepare:	prepare output port for tracing
  * @enable:	enable tracing for a given output device
  * @disable:	disable tracing for a given output device
  * @irq:	interrupt callback
@@ -161,6 +162,8 @@ struct intel_th_driver {
 					  struct intel_th_device *othdev);
 	void			(*unassign)(struct intel_th_device *thdev,
 					    struct intel_th_device *othdev);
+	void			(*prepare)(struct intel_th_device *thdev,
+					   struct intel_th_output *output);
 	void			(*enable)(struct intel_th_device *thdev,
 					  struct intel_th_output *output);
 	void			(*disable)(struct intel_th_device *thdev,
diff --git a/drivers/i2c/i2c-core-base.c b/drivers/i2c/i2c-core-base.c
index 39065a5d50fc..b7fe8075f2b8 100644
--- a/drivers/i2c/i2c-core-base.c
+++ b/drivers/i2c/i2c-core-base.c
@@ -31,6 +31,7 @@
 #include <linux/i2c.h>
 #include <linux/idr.h>
 #include <linux/init.h>
+#include <linux/interrupt.h>
 #include <linux/irqflags.h>
 #include <linux/jump_label.h>
 #include <linux/kernel.h>
@@ -452,6 +453,8 @@ static void i2c_device_shutdown(struct device *dev)
 	driver = to_i2c_driver(dev->driver);
 	if (driver->shutdown)
 		driver->shutdown(client);
+	else if (client->irq > 0)
+		disable_irq(client->irq);
 }
 
 static void i2c_client_dev_release(struct device *dev)
diff --git a/drivers/iio/accel/bma180.c b/drivers/iio/accel/bma180.c
index 3dec972ca672..dabe4717961f 100644
--- a/drivers/iio/accel/bma180.c
+++ b/drivers/iio/accel/bma180.c
@@ -121,7 +121,11 @@ struct bma180_data {
 	int scale;
 	int bw;
 	bool pmode;
-	u8 buff[16]; /* 3x 16-bit + 8-bit + padding + timestamp */
+	/* Ensure timestamp is naturally aligned */
+	struct {
+		s16 chan[4];
+		s64 timestamp __aligned(8);
+	} scan;
 };
 
 enum bma180_chan {
@@ -668,12 +672,12 @@ static irqreturn_t bma180_trigger_handler(int irq, void *p)
 			mutex_unlock(&data->mutex);
 			goto err;
 		}
-		((s16 *)data->buff)[i++] = ret;
+		data->scan.chan[i++] = ret;
 	}
 
 	mutex_unlock(&data->mutex);
 
-	iio_push_to_buffers_with_timestamp(indio_dev, data->buff, time_ns);
+	iio_push_to_buffers_with_timestamp(indio_dev, &data->scan, time_ns);
 err:
 	iio_trigger_notify_done(indio_dev->trig);
 
diff --git a/drivers/iio/accel/bma220_spi.c b/drivers/iio/accel/bma220_spi.c
index 5099f295dd37..a96f2d530ae3 100644
--- a/drivers/iio/accel/bma220_spi.c
+++ b/drivers/iio/accel/bma220_spi.c
@@ -76,7 +76,11 @@ static const int bma220_scale_table[][4] = {
 struct bma220_data {
 	struct spi_device *spi_device;
 	struct mutex lock;
-	s8 buffer[16]; /* 3x8-bit channels + 5x8 padding + 8x8 timestamp */
+	struct {
+		s8 chans[3];
+		/* Ensure timestamp is naturally aligned. */
+		s64 timestamp __aligned(8);
+	} scan;
 	u8 tx_buf[2] ____cacheline_aligned;
 };
 
@@ -107,12 +111,12 @@ static irqreturn_t bma220_trigger_handler(int irq, void *p)
 
 	mutex_lock(&data->lock);
 	data->tx_buf[0] = BMA220_REG_ACCEL_X | BMA220_READ_MASK;
-	ret = spi_write_then_read(spi, data->tx_buf, 1, data->buffer,
+	ret = spi_write_then_read(spi, data->tx_buf, 1, &data->scan.chans,
 				  ARRAY_SIZE(bma220_channels) - 1);
 	if (ret < 0)
 		goto err;
 
-	iio_push_to_buffers_with_timestamp(indio_dev, data->buffer,
+	iio_push_to_buffers_with_timestamp(indio_dev, &data->scan,
 					   pf->timestamp);
 err:
 	mutex_unlock(&data->lock);
diff --git a/drivers/iio/accel/hid-sensor-accel-3d.c b/drivers/iio/accel/hid-sensor-accel-3d.c
index f573d9c61fc3..fc210d88bba9 100644
--- a/drivers/iio/accel/hid-sensor-accel-3d.c
+++ b/drivers/iio/accel/hid-sensor-accel-3d.c
@@ -42,8 +42,11 @@ struct accel_3d_state {
 	struct hid_sensor_hub_callbacks callbacks;
 	struct hid_sensor_common common_attributes;
 	struct hid_sensor_hub_attribute_info accel[ACCEL_3D_CHANNEL_MAX];
-	/* Reserve for 3 channels + padding + timestamp */
-	u32 accel_val[ACCEL_3D_CHANNEL_MAX + 3];
+	/* Ensure timestamp is naturally aligned */
+	struct {
+		u32 accel_val[3];
+		s64 timestamp __aligned(8);
+	} scan;
 	int scale_pre_decml;
 	int scale_post_decml;
 	int scale_precision;
@@ -255,8 +258,8 @@ static int accel_3d_proc_event(struct hid_sensor_hub_device *hsdev,
 			accel_state->timestamp = iio_get_time_ns(indio_dev);
 
 		hid_sensor_push_data(indio_dev,
-				     accel_state->accel_val,
-				     sizeof(accel_state->accel_val),
+				     &accel_state->scan,
+				     sizeof(accel_state->scan),
 				     accel_state->timestamp);
 
 		accel_state->timestamp = 0;
@@ -281,7 +284,7 @@ static int accel_3d_capture_sample(struct hid_sensor_hub_device *hsdev,
 	case HID_USAGE_SENSOR_ACCEL_Y_AXIS:
 	case HID_USAGE_SENSOR_ACCEL_Z_AXIS:
 		offset = usage_id - HID_USAGE_SENSOR_ACCEL_X_AXIS;
-		accel_state->accel_val[CHANNEL_SCAN_INDEX_X + offset] =
+		accel_state->scan.accel_val[CHANNEL_SCAN_INDEX_X + offset] =
 						*(u32 *)raw_data;
 		ret = 0;
 	break;
diff --git a/drivers/iio/accel/kxcjk-1013.c b/drivers/iio/accel/kxcjk-1013.c
index 92a73ada8e4a..296fd00f0e97 100644
--- a/drivers/iio/accel/kxcjk-1013.c
+++ b/drivers/iio/accel/kxcjk-1013.c
@@ -97,12 +97,23 @@ enum kx_acpi_type {
 	ACPI_KIOX010A,
 };
 
+enum kxcjk1013_axis {
+	AXIS_X,
+	AXIS_Y,
+	AXIS_Z,
+	AXIS_MAX
+};
+
 struct kxcjk1013_data {
 	struct i2c_client *client;
 	struct iio_trigger *dready_trig;
 	struct iio_trigger *motion_trig;
 	struct mutex mutex;
-	s16 buffer[8];
+	/* Ensure timestamp naturally aligned */
+	struct {
+		s16 chans[AXIS_MAX];
+		s64 timestamp __aligned(8);
+	} scan;
 	u8 odr_bits;
 	u8 range;
 	int wake_thres;
@@ -116,13 +127,6 @@ struct kxcjk1013_data {
 	enum kx_acpi_type acpi_type;
 };
 
-enum kxcjk1013_axis {
-	AXIS_X,
-	AXIS_Y,
-	AXIS_Z,
-	AXIS_MAX,
-};
-
 enum kxcjk1013_mode {
 	STANDBY,
 	OPERATION,
@@ -1005,12 +1009,12 @@ static irqreturn_t kxcjk1013_trigger_handler(int irq, void *p)
 	ret = i2c_smbus_read_i2c_block_data_or_emulated(data->client,
 							KXCJK1013_REG_XOUT_L,
 							AXIS_MAX * 2,
-							(u8 *)data->buffer);
+							(u8 *)data->scan.chans);
 	mutex_unlock(&data->mutex);
 	if (ret < 0)
 		goto err;
 
-	iio_push_to_buffers_with_timestamp(indio_dev, data->buffer,
+	iio_push_to_buffers_with_timestamp(indio_dev, &data->scan,
 					   data->timestamp);
 err:
 	iio_trigger_notify_done(indio_dev->trig);
diff --git a/drivers/iio/accel/stk8312.c b/drivers/iio/accel/stk8312.c
index e31023dc5f1b..24a7499049f1 100644
--- a/drivers/iio/accel/stk8312.c
+++ b/drivers/iio/accel/stk8312.c
@@ -106,7 +106,11 @@ struct stk8312_data {
 	u8 mode;
 	struct iio_trigger *dready_trig;
 	bool dready_trigger_on;
-	s8 buffer[16]; /* 3x8-bit channels + 5x8 padding + 64-bit timestamp */
+	/* Ensure timestamp is naturally aligned */
+	struct {
+		s8 chans[3];
+		s64 timestamp __aligned(8);
+	} scan;
 };
 
 static IIO_CONST_ATTR(in_accel_scale_available, STK8312_SCALE_AVAIL);
@@ -443,7 +447,7 @@ static irqreturn_t stk8312_trigger_handler(int irq, void *p)
 		ret = i2c_smbus_read_i2c_block_data(data->client,
 						    STK8312_REG_XOUT,
 						    STK8312_ALL_CHANNEL_SIZE,
-						    data->buffer);
+						    data->scan.chans);
 		if (ret < STK8312_ALL_CHANNEL_SIZE) {
 			dev_err(&data->client->dev, "register read failed\n");
 			mutex_unlock(&data->lock);
@@ -457,12 +461,12 @@ static irqreturn_t stk8312_trigger_handler(int irq, void *p)
 				mutex_unlock(&data->lock);
 				goto err;
 			}
-			data->buffer[i++] = ret;
+			data->scan.chans[i++] = ret;
 		}
 	}
 	mutex_unlock(&data->lock);
 
-	iio_push_to_buffers_with_timestamp(indio_dev, data->buffer,
+	iio_push_to_buffers_with_timestamp(indio_dev, &data->scan,
 					   pf->timestamp);
 err:
 	iio_trigger_notify_done(indio_dev->trig);
diff --git a/drivers/iio/accel/stk8ba50.c b/drivers/iio/accel/stk8ba50.c
index 300d955bad00..5ca179cea2fb 100644
--- a/drivers/iio/accel/stk8ba50.c
+++ b/drivers/iio/accel/stk8ba50.c
@@ -94,12 +94,11 @@ struct stk8ba50_data {
 	u8 sample_rate_idx;
 	struct iio_trigger *dready_trig;
 	bool dready_trigger_on;
-	/*
-	 * 3 x 16-bit channels (10-bit data, 6-bit padding) +
-	 * 1 x 16 padding +
-	 * 4 x 16 64-bit timestamp
-	 */
-	s16 buffer[8];
+	/* Ensure timestamp is naturally aligned */
+	struct {
+		s16 chans[3];
+		s64 timetamp __aligned(8);
+	} scan;
 };
 
 #define STK8BA50_ACCEL_CHANNEL(index, reg, axis) {			\
@@ -329,7 +328,7 @@ static irqreturn_t stk8ba50_trigger_handler(int irq, void *p)
 		ret = i2c_smbus_read_i2c_block_data(data->client,
 						    STK8BA50_REG_XOUT,
 						    STK8BA50_ALL_CHANNEL_SIZE,
-						    (u8 *)data->buffer);
+						    (u8 *)data->scan.chans);
 		if (ret < STK8BA50_ALL_CHANNEL_SIZE) {
 			dev_err(&data->client->dev, "register read failed\n");
 			goto err;
@@ -342,10 +341,10 @@ static irqreturn_t stk8ba50_trigger_handler(int irq, void *p)
 			if (ret < 0)
 				goto err;
 
-			data->buffer[i++] = ret;
+			data->scan.chans[i++] = ret;
 		}
 	}
-	iio_push_to_buffers_with_timestamp(indio_dev, data->buffer,
+	iio_push_to_buffers_with_timestamp(indio_dev, &data->scan,
 					   pf->timestamp);
 err:
 	mutex_unlock(&data->lock);
diff --git a/drivers/iio/adc/mxs-lradc-adc.c b/drivers/iio/adc/mxs-lradc-adc.c
index d32b34638c2f..8c193d006967 100644
--- a/drivers/iio/adc/mxs-lradc-adc.c
+++ b/drivers/iio/adc/mxs-lradc-adc.c
@@ -124,7 +124,8 @@ struct mxs_lradc_adc {
 	struct device		*dev;
 
 	void __iomem		*base;
-	u32			buffer[10];
+	/* Maximum of 8 channels + 8 byte ts */
+	u32			buffer[10] __aligned(8);
 	struct iio_trigger	*trig;
 	struct completion	completion;
 	spinlock_t		lock;
diff --git a/drivers/iio/adc/ti-ads1015.c b/drivers/iio/adc/ti-ads1015.c
index df71c6105353..007898d3b3a9 100644
--- a/drivers/iio/adc/ti-ads1015.c
+++ b/drivers/iio/adc/ti-ads1015.c
@@ -392,10 +392,14 @@ static irqreturn_t ads1015_trigger_handler(int irq, void *p)
 	struct iio_poll_func *pf = p;
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct ads1015_data *data = iio_priv(indio_dev);
-	s16 buf[8]; /* 1x s16 ADC val + 3x s16 padding +  4x s16 timestamp */
+	/* Ensure natural alignment of timestamp */
+	struct {
+		s16 chan;
+		s64 timestamp __aligned(8);
+	} scan;
 	int chan, ret, res;
 
-	memset(buf, 0, sizeof(buf));
+	memset(&scan, 0, sizeof(scan));
 
 	mutex_lock(&data->lock);
 	chan = find_first_bit(indio_dev->active_scan_mask,
@@ -406,10 +410,10 @@ static irqreturn_t ads1015_trigger_handler(int irq, void *p)
 		goto err;
 	}
 
-	buf[0] = res;
+	scan.chan = res;
 	mutex_unlock(&data->lock);
 
-	iio_push_to_buffers_with_timestamp(indio_dev, buf,
+	iio_push_to_buffers_with_timestamp(indio_dev, &scan,
 					   iio_get_time_ns(indio_dev));
 
 err:
diff --git a/drivers/iio/adc/vf610_adc.c b/drivers/iio/adc/vf610_adc.c
index c168e0db329a..d4409366e3c6 100644
--- a/drivers/iio/adc/vf610_adc.c
+++ b/drivers/iio/adc/vf610_adc.c
@@ -180,7 +180,11 @@ struct vf610_adc {
 	u32 sample_freq_avail[5];
 
 	struct completion completion;
-	u16 buffer[8];
+	/* Ensure the timestamp is naturally aligned */
+	struct {
+		u16 chan;
+		s64 timestamp __aligned(8);
+	} scan;
 };
 
 static const u32 vf610_hw_avgs[] = { 1, 4, 8, 16, 32 };
@@ -592,9 +596,9 @@ static irqreturn_t vf610_adc_isr(int irq, void *dev_id)
 	if (coco & VF610_ADC_HS_COCO0) {
 		info->value = vf610_adc_read_data(info);
 		if (iio_buffer_enabled(indio_dev)) {
-			info->buffer[0] = info->value;
+			info->scan.chan = info->value;
 			iio_push_to_buffers_with_timestamp(indio_dev,
-					info->buffer,
+					&info->scan,
 					iio_get_time_ns(indio_dev));
 			iio_trigger_notify_done(indio_dev->trig);
 		} else
diff --git a/drivers/iio/gyro/bmg160_core.c b/drivers/iio/gyro/bmg160_core.c
index b5a5517e3ce1..ec2830c16433 100644
--- a/drivers/iio/gyro/bmg160_core.c
+++ b/drivers/iio/gyro/bmg160_core.c
@@ -104,7 +104,11 @@ struct bmg160_data {
 	struct iio_trigger *dready_trig;
 	struct iio_trigger *motion_trig;
 	struct mutex mutex;
-	s16 buffer[8];
+	/* Ensure naturally aligned timestamp */
+	struct {
+		s16 chans[3];
+		s64 timestamp __aligned(8);
+	} scan;
 	u32 dps_range;
 	int ev_enable_state;
 	int slope_thres;
@@ -874,12 +878,12 @@ static irqreturn_t bmg160_trigger_handler(int irq, void *p)
 
 	mutex_lock(&data->mutex);
 	ret = regmap_bulk_read(data->regmap, BMG160_REG_XOUT_L,
-			       data->buffer, AXIS_MAX * 2);
+			       data->scan.chans, AXIS_MAX * 2);
 	mutex_unlock(&data->mutex);
 	if (ret < 0)
 		goto err;
 
-	iio_push_to_buffers_with_timestamp(indio_dev, data->buffer,
+	iio_push_to_buffers_with_timestamp(indio_dev, &data->scan,
 					   pf->timestamp);
 err:
 	iio_trigger_notify_done(indio_dev->trig);
diff --git a/drivers/iio/humidity/am2315.c b/drivers/iio/humidity/am2315.c
index ff96b6d0fdae..77513fd84b99 100644
--- a/drivers/iio/humidity/am2315.c
+++ b/drivers/iio/humidity/am2315.c
@@ -36,7 +36,11 @@
 struct am2315_data {
 	struct i2c_client *client;
 	struct mutex lock;
-	s16 buffer[8]; /* 2x16-bit channels + 2x16 padding + 4x16 timestamp */
+	/* Ensure timestamp is naturally aligned */
+	struct {
+		s16 chans[2];
+		s64 timestamp __aligned(8);
+	} scan;
 };
 
 struct am2315_sensor_data {
@@ -170,20 +174,20 @@ static irqreturn_t am2315_trigger_handler(int irq, void *p)
 
 	mutex_lock(&data->lock);
 	if (*(indio_dev->active_scan_mask) == AM2315_ALL_CHANNEL_MASK) {
-		data->buffer[0] = sensor_data.hum_data;
-		data->buffer[1] = sensor_data.temp_data;
+		data->scan.chans[0] = sensor_data.hum_data;
+		data->scan.chans[1] = sensor_data.temp_data;
 	} else {
 		i = 0;
 		for_each_set_bit(bit, indio_dev->active_scan_mask,
 				 indio_dev->masklength) {
-			data->buffer[i] = (bit ? sensor_data.temp_data :
-						 sensor_data.hum_data);
+			data->scan.chans[i] = (bit ? sensor_data.temp_data :
+					       sensor_data.hum_data);
 			i++;
 		}
 	}
 	mutex_unlock(&data->lock);
 
-	iio_push_to_buffers_with_timestamp(indio_dev, data->buffer,
+	iio_push_to_buffers_with_timestamp(indio_dev, &data->scan,
 					   pf->timestamp);
 err:
 	iio_trigger_notify_done(indio_dev->trig);
diff --git a/drivers/iio/imu/adis_buffer.c b/drivers/iio/imu/adis_buffer.c
index 9de553e8c214..625f54d9e382 100644
--- a/drivers/iio/imu/adis_buffer.c
+++ b/drivers/iio/imu/adis_buffer.c
@@ -83,9 +83,6 @@ static irqreturn_t adis_trigger_handler(int irq, void *p)
 	struct adis *adis = iio_device_get_drvdata(indio_dev);
 	int ret;
 
-	if (!adis->buffer)
-		return -ENOMEM;
-
 	if (adis->data->has_paging) {
 		mutex_lock(&adis->txrx_lock);
 		if (adis->current_page != 0) {
diff --git a/drivers/iio/light/isl29125.c b/drivers/iio/light/isl29125.c
index 1d2c0c8a1d4f..207b856cef8c 100644
--- a/drivers/iio/light/isl29125.c
+++ b/drivers/iio/light/isl29125.c
@@ -54,7 +54,11 @@
 struct isl29125_data {
 	struct i2c_client *client;
 	u8 conf1;
-	u16 buffer[8]; /* 3x 16-bit, padding, 8 bytes timestamp */
+	/* Ensure timestamp is naturally aligned */
+	struct {
+		u16 chans[3];
+		s64 timestamp __aligned(8);
+	} scan;
 };
 
 #define ISL29125_CHANNEL(_color, _si) { \
@@ -187,10 +191,10 @@ static irqreturn_t isl29125_trigger_handler(int irq, void *p)
 		if (ret < 0)
 			goto done;
 
-		data->buffer[j++] = ret;
+		data->scan.chans[j++] = ret;
 	}
 
-	iio_push_to_buffers_with_timestamp(indio_dev, data->buffer,
+	iio_push_to_buffers_with_timestamp(indio_dev, &data->scan,
 		iio_get_time_ns(indio_dev));
 
 done:
diff --git a/drivers/iio/light/ltr501.c b/drivers/iio/light/ltr501.c
index 7a9358049659..3d75e155bd3e 100644
--- a/drivers/iio/light/ltr501.c
+++ b/drivers/iio/light/ltr501.c
@@ -35,9 +35,12 @@
 #define LTR501_PART_ID 0x86
 #define LTR501_MANUFAC_ID 0x87
 #define LTR501_ALS_DATA1 0x88 /* 16-bit, little endian */
+#define LTR501_ALS_DATA1_UPPER 0x89 /* upper 8 bits of LTR501_ALS_DATA1 */
 #define LTR501_ALS_DATA0 0x8a /* 16-bit, little endian */
+#define LTR501_ALS_DATA0_UPPER 0x8b /* upper 8 bits of LTR501_ALS_DATA0 */
 #define LTR501_ALS_PS_STATUS 0x8c
 #define LTR501_PS_DATA 0x8d /* 16-bit, little endian */
+#define LTR501_PS_DATA_UPPER 0x8e /* upper 8 bits of LTR501_PS_DATA */
 #define LTR501_INTR 0x8f /* output mode, polarity, mode */
 #define LTR501_PS_THRESH_UP 0x90 /* 11 bit, ps upper threshold */
 #define LTR501_PS_THRESH_LOW 0x92 /* 11 bit, ps lower threshold */
@@ -408,18 +411,19 @@ static int ltr501_read_als(struct ltr501_data *data, __le16 buf[2])
 
 static int ltr501_read_ps(struct ltr501_data *data)
 {
-	int ret, status;
+	__le16 status;
+	int ret;
 
 	ret = ltr501_drdy(data, LTR501_STATUS_PS_RDY);
 	if (ret < 0)
 		return ret;
 
 	ret = regmap_bulk_read(data->regmap, LTR501_PS_DATA,
-			       &status, 2);
+			       &status, sizeof(status));
 	if (ret < 0)
 		return ret;
 
-	return status;
+	return le16_to_cpu(status);
 }
 
 static int ltr501_read_intr_prst(struct ltr501_data *data,
@@ -1211,7 +1215,7 @@ static struct ltr501_chip_info ltr501_chip_info_tbl[] = {
 		.als_gain_tbl_size = ARRAY_SIZE(ltr559_als_gain_tbl),
 		.ps_gain = ltr559_ps_gain_tbl,
 		.ps_gain_tbl_size = ARRAY_SIZE(ltr559_ps_gain_tbl),
-		.als_mode_active = BIT(1),
+		.als_mode_active = BIT(0),
 		.als_gain_mask = BIT(2) | BIT(3) | BIT(4),
 		.als_gain_shift = 2,
 		.info = &ltr501_info,
@@ -1360,9 +1364,12 @@ static bool ltr501_is_volatile_reg(struct device *dev, unsigned int reg)
 {
 	switch (reg) {
 	case LTR501_ALS_DATA1:
+	case LTR501_ALS_DATA1_UPPER:
 	case LTR501_ALS_DATA0:
+	case LTR501_ALS_DATA0_UPPER:
 	case LTR501_ALS_PS_STATUS:
 	case LTR501_PS_DATA:
+	case LTR501_PS_DATA_UPPER:
 		return true;
 	default:
 		return false;
diff --git a/drivers/iio/light/tcs3414.c b/drivers/iio/light/tcs3414.c
index a795afb7667b..b51cd43ef824 100644
--- a/drivers/iio/light/tcs3414.c
+++ b/drivers/iio/light/tcs3414.c
@@ -56,7 +56,11 @@ struct tcs3414_data {
 	u8 control;
 	u8 gain;
 	u8 timing;
-	u16 buffer[8]; /* 4x 16-bit + 8 bytes timestamp */
+	/* Ensure timestamp is naturally aligned */
+	struct {
+		u16 chans[4];
+		s64 timestamp __aligned(8);
+	} scan;
 };
 
 #define TCS3414_CHANNEL(_color, _si, _addr) { \
@@ -212,10 +216,10 @@ static irqreturn_t tcs3414_trigger_handler(int irq, void *p)
 		if (ret < 0)
 			goto done;
 
-		data->buffer[j++] = ret;
+		data->scan.chans[j++] = ret;
 	}
 
-	iio_push_to_buffers_with_timestamp(indio_dev, data->buffer,
+	iio_push_to_buffers_with_timestamp(indio_dev, &data->scan,
 		iio_get_time_ns(indio_dev));
 
 done:
diff --git a/drivers/iio/potentiostat/lmp91000.c b/drivers/iio/potentiostat/lmp91000.c
index afa8de3418d0..cb67edf53ab4 100644
--- a/drivers/iio/potentiostat/lmp91000.c
+++ b/drivers/iio/potentiostat/lmp91000.c
@@ -79,8 +79,8 @@ struct lmp91000_data {
 
 	struct completion completion;
 	u8 chan_select;
-
-	u32 buffer[4]; /* 64-bit data + 64-bit timestamp */
+	/* 64-bit data + 64-bit naturally aligned timestamp */
+	u32 buffer[4] __aligned(8);
 };
 
 static const struct iio_chan_spec lmp91000_channels[] = {
diff --git a/drivers/iio/proximity/as3935.c b/drivers/iio/proximity/as3935.c
index 4a48b7ba3a1c..105fe680e8ca 100644
--- a/drivers/iio/proximity/as3935.c
+++ b/drivers/iio/proximity/as3935.c
@@ -70,7 +70,11 @@ struct as3935_state {
 	unsigned long noise_tripped;
 	u32 tune_cap;
 	u32 nflwdth_reg;
-	u8 buffer[16]; /* 8-bit data + 56-bit padding + 64-bit timestamp */
+	/* Ensure timestamp is naturally aligned */
+	struct {
+		u8 chan;
+		s64 timestamp __aligned(8);
+	} scan;
 	u8 buf[2] ____cacheline_aligned;
 };
 
@@ -237,8 +241,8 @@ static irqreturn_t as3935_trigger_handler(int irq, void *private)
 	if (ret)
 		goto err_read;
 
-	st->buffer[0] = val & AS3935_DATA_MASK;
-	iio_push_to_buffers_with_timestamp(indio_dev, &st->buffer,
+	st->scan.chan = val & AS3935_DATA_MASK;
+	iio_push_to_buffers_with_timestamp(indio_dev, &st->scan,
 					   iio_get_time_ns(indio_dev));
 err_read:
 	iio_trigger_notify_done(indio_dev->trig);
diff --git a/drivers/iio/proximity/pulsedlight-lidar-lite-v2.c b/drivers/iio/proximity/pulsedlight-lidar-lite-v2.c
index c033db701bb5..07f69b47f739 100644
--- a/drivers/iio/proximity/pulsedlight-lidar-lite-v2.c
+++ b/drivers/iio/proximity/pulsedlight-lidar-lite-v2.c
@@ -51,7 +51,11 @@ struct lidar_data {
 	int (*xfer)(struct lidar_data *data, u8 reg, u8 *val, int len);
 	int i2c_enabled;
 
-	u16 buffer[8]; /* 2 byte distance + 8 byte timestamp */
+	/* Ensure timestamp is naturally aligned */
+	struct {
+		u16 chan;
+		s64 timestamp __aligned(8);
+	} scan;
 };
 
 static const struct iio_chan_spec lidar_channels[] = {
@@ -236,9 +240,9 @@ static irqreturn_t lidar_trigger_handler(int irq, void *private)
 	struct lidar_data *data = iio_priv(indio_dev);
 	int ret;
 
-	ret = lidar_get_measurement(data, data->buffer);
+	ret = lidar_get_measurement(data, &data->scan.chan);
 	if (!ret) {
-		iio_push_to_buffers_with_timestamp(indio_dev, data->buffer,
+		iio_push_to_buffers_with_timestamp(indio_dev, &data->scan,
 						   iio_get_time_ns(indio_dev));
 	} else if (ret != -EINVAL) {
 		dev_err(&data->client->dev, "cannot read LIDAR measurement");
diff --git a/drivers/iio/proximity/srf08.c b/drivers/iio/proximity/srf08.c
index 9380d545aab1..d36f634a22d6 100644
--- a/drivers/iio/proximity/srf08.c
+++ b/drivers/iio/proximity/srf08.c
@@ -66,11 +66,11 @@ struct srf08_data {
 	int			range_mm;
 	struct mutex		lock;
 
-	/*
-	 * triggered buffer
-	 * 1x16-bit channel + 3x16 padding + 4x16 timestamp
-	 */
-	s16			buffer[8];
+	/* Ensure timestamp is naturally aligned */
+	struct {
+		s16 chan;
+		s64 timestamp __aligned(8);
+	} scan;
 
 	/* Sensor-Type */
 	enum srf08_sensor_type	sensor_type;
@@ -193,9 +193,9 @@ static irqreturn_t srf08_trigger_handler(int irq, void *p)
 
 	mutex_lock(&data->lock);
 
-	data->buffer[0] = sensor_data;
+	data->scan.chan = sensor_data;
 	iio_push_to_buffers_with_timestamp(indio_dev,
-						data->buffer, pf->timestamp);
+					   &data->scan, pf->timestamp);
 
 	mutex_unlock(&data->lock);
 err:
diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 6e8af2b91492..dd00530675d0 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -2478,7 +2478,8 @@ static int cma_resolve_ib_route(struct rdma_id_private *id_priv, int timeout_ms)
 	work->new_state = RDMA_CM_ROUTE_RESOLVED;
 	work->event.event = RDMA_CM_EVENT_ROUTE_RESOLVED;
 
-	route->path_rec = kmalloc(sizeof *route->path_rec, GFP_KERNEL);
+	if (!route->path_rec)
+		route->path_rec = kmalloc(sizeof *route->path_rec, GFP_KERNEL);
 	if (!route->path_rec) {
 		ret = -ENOMEM;
 		goto err1;
diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index 15a867d62d02..325561580729 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -277,6 +277,7 @@ static int create_qp(struct c4iw_rdev *rdev, struct t4_wq *wq,
 	if (user && (!wq->sq.bar2_pa || !wq->rq.bar2_pa)) {
 		pr_warn("%s: sqid %u or rqid %u not in BAR2 range\n",
 			pci_name(rdev->lldi.pdev), wq->sq.qid, wq->rq.qid);
+		ret = -EINVAL;
 		goto free_dma;
 	}
 
diff --git a/drivers/infiniband/sw/rxe/rxe_mr.c b/drivers/infiniband/sw/rxe/rxe_mr.c
index a0d2a2350c7e..cf18e61934f7 100644
--- a/drivers/infiniband/sw/rxe/rxe_mr.c
+++ b/drivers/infiniband/sw/rxe/rxe_mr.c
@@ -175,7 +175,7 @@ int rxe_mem_init_user(struct rxe_dev *rxe, struct rxe_pd *pd, u64 start,
 	if (IS_ERR(umem)) {
 		pr_warn("err %d from rxe_umem_get\n",
 			(int)PTR_ERR(umem));
-		err = -EINVAL;
+		err = PTR_ERR(umem);
 		goto err1;
 	}
 
diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
index 24a68a9da8be..4aeed31d8e04 100644
--- a/drivers/infiniband/sw/rxe/rxe_net.c
+++ b/drivers/infiniband/sw/rxe/rxe_net.c
@@ -269,10 +269,8 @@ static struct socket *rxe_setup_udp_tunnel(struct net *net, __be16 port,
 
 	/* Create UDP socket */
 	err = udp_sock_create(net, &udp_cfg, &sock);
-	if (err < 0) {
-		pr_err("failed to create udp socket. err = %d\n", err);
+	if (err < 0)
 		return ERR_PTR(err);
-	}
 
 	tnl_cfg.encap_type = 1;
 	tnl_cfg.encap_rcv = rxe_udp_encap_recv;
@@ -696,6 +694,12 @@ static int rxe_net_ipv6_init(void)
 
 	recv_sockets.sk6 = rxe_setup_udp_tunnel(&init_net,
 						htons(ROCE_V2_UDP_DPORT), true);
+	if (PTR_ERR(recv_sockets.sk6) == -EAFNOSUPPORT) {
+		recv_sockets.sk6 = NULL;
+		pr_warn("IPv6 is not supported, can not create a UDPv6 socket\n");
+		return 0;
+	}
+
 	if (IS_ERR(recv_sockets.sk6)) {
 		recv_sockets.sk6 = NULL;
 		pr_err("Failed to create IPv6 UDP tunnel\n");
diff --git a/drivers/input/joydev.c b/drivers/input/joydev.c
index 48e6e5df9859..0e70bc711e7d 100644
--- a/drivers/input/joydev.c
+++ b/drivers/input/joydev.c
@@ -504,7 +504,7 @@ static int joydev_handle_JSIOCSBTNMAP(struct joydev *joydev,
 	memcpy(joydev->keypam, keypam, len);
 
 	for (i = 0; i < joydev->nkey; i++)
-		joydev->keymap[keypam[i] - BTN_MISC] = i;
+		joydev->keymap[joydev->keypam[i] - BTN_MISC] = i;
 
  out:
 	kfree(keypam);
diff --git a/drivers/input/keyboard/hil_kbd.c b/drivers/input/keyboard/hil_kbd.c
index bb29a7c9a1c0..54afb38601b9 100644
--- a/drivers/input/keyboard/hil_kbd.c
+++ b/drivers/input/keyboard/hil_kbd.c
@@ -512,6 +512,7 @@ static int hil_dev_connect(struct serio *serio, struct serio_driver *drv)
 		    HIL_IDD_NUM_AXES_PER_SET(*idd)) {
 			printk(KERN_INFO PREFIX
 				"combo devices are not supported.\n");
+			error = -EINVAL;
 			goto bail1;
 		}
 
diff --git a/drivers/input/touchscreen/usbtouchscreen.c b/drivers/input/touchscreen/usbtouchscreen.c
index 499402a975b3..c5d34a782372 100644
--- a/drivers/input/touchscreen/usbtouchscreen.c
+++ b/drivers/input/touchscreen/usbtouchscreen.c
@@ -266,7 +266,7 @@ static int e2i_init(struct usbtouch_usb *usbtouch)
 	int ret;
 	struct usb_device *udev = interface_to_usbdev(usbtouch->interface);
 
-	ret = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
+	ret = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
 	                      0x01, 0x02, 0x0000, 0x0081,
 	                      NULL, 0, USB_CTRL_SET_TIMEOUT);
 
@@ -462,7 +462,7 @@ static int mtouch_init(struct usbtouch_usb *usbtouch)
 	int ret, i;
 	struct usb_device *udev = interface_to_usbdev(usbtouch->interface);
 
-	ret = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
+	ret = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
 	                      MTOUCHUSB_RESET,
 	                      USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 	                      1, 0, NULL, 0, USB_CTRL_SET_TIMEOUT);
@@ -474,7 +474,7 @@ static int mtouch_init(struct usbtouch_usb *usbtouch)
 	msleep(150);
 
 	for (i = 0; i < 3; i++) {
-		ret = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
+		ret = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
 				      MTOUCHUSB_ASYNC_REPORT,
 				      USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 				      1, 1, NULL, 0, USB_CTRL_SET_TIMEOUT);
@@ -645,7 +645,7 @@ static int dmc_tsc10_init(struct usbtouch_usb *usbtouch)
 	}
 
 	/* start sending data */
-	ret = usb_control_msg(dev, usb_rcvctrlpipe (dev, 0),
+	ret = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
 	                      TSC10_CMD_DATA1,
 	                      USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 	                      0, 0, NULL, 0, USB_CTRL_SET_TIMEOUT);
diff --git a/drivers/ipack/carriers/tpci200.c b/drivers/ipack/carriers/tpci200.c
index 9b23843dcad4..7ba1a94497f5 100644
--- a/drivers/ipack/carriers/tpci200.c
+++ b/drivers/ipack/carriers/tpci200.c
@@ -591,8 +591,11 @@ static int tpci200_pci_probe(struct pci_dev *pdev,
 
 out_err_bus_register:
 	tpci200_uninstall(tpci200);
+	/* tpci200->info->cfg_regs is unmapped in tpci200_uninstall */
+	tpci200->info->cfg_regs = NULL;
 out_err_install:
-	iounmap(tpci200->info->cfg_regs);
+	if (tpci200->info->cfg_regs)
+		iounmap(tpci200->info->cfg_regs);
 out_err_ioremap:
 	pci_release_region(pdev, TPCI200_CFG_MEM_BAR);
 out_err_pci_request:
diff --git a/drivers/isdn/hardware/mISDN/hfcpci.c b/drivers/isdn/hardware/mISDN/hfcpci.c
index d2e401a8090e..3e73cb5b8304 100644
--- a/drivers/isdn/hardware/mISDN/hfcpci.c
+++ b/drivers/isdn/hardware/mISDN/hfcpci.c
@@ -2349,7 +2349,7 @@ static void __exit
 HFC_cleanup(void)
 {
 	if (timer_pending(&hfc_tl))
-		del_timer(&hfc_tl);
+		del_timer_sync(&hfc_tl);
 
 	pci_unregister_driver(&hfc_driver);
 }
diff --git a/drivers/leds/leds-as3645a.c b/drivers/leds/leds-as3645a.c
index 9a257f969300..8109972998b7 100644
--- a/drivers/leds/leds-as3645a.c
+++ b/drivers/leds/leds-as3645a.c
@@ -564,6 +564,7 @@ static int as3645a_parse_node(struct as3645a *flash,
 	if (!flash->indicator_node) {
 		dev_warn(&flash->client->dev,
 			 "can't find indicator node\n");
+		rval = -ENODEV;
 		goto out_err;
 	}
 
diff --git a/drivers/leds/leds-ktd2692.c b/drivers/leds/leds-ktd2692.c
index 45296aaca9da..02738b5b1dbf 100644
--- a/drivers/leds/leds-ktd2692.c
+++ b/drivers/leds/leds-ktd2692.c
@@ -259,6 +259,17 @@ static void ktd2692_setup(struct ktd2692_context *led)
 				 | KTD2692_REG_FLASH_CURRENT_BASE);
 }
 
+static void regulator_disable_action(void *_data)
+{
+	struct device *dev = _data;
+	struct ktd2692_context *led = dev_get_drvdata(dev);
+	int ret;
+
+	ret = regulator_disable(led->regulator);
+	if (ret)
+		dev_err(dev, "Failed to disable supply: %d\n", ret);
+}
+
 static int ktd2692_parse_dt(struct ktd2692_context *led, struct device *dev,
 			    struct ktd2692_led_config_data *cfg)
 {
@@ -289,8 +300,14 @@ static int ktd2692_parse_dt(struct ktd2692_context *led, struct device *dev,
 
 	if (led->regulator) {
 		ret = regulator_enable(led->regulator);
-		if (ret)
+		if (ret) {
 			dev_err(dev, "Failed to enable supply: %d\n", ret);
+		} else {
+			ret = devm_add_action_or_reset(dev,
+						regulator_disable_action, dev);
+			if (ret)
+				return ret;
+		}
 	}
 
 	child_node = of_get_next_available_child(np, NULL);
@@ -380,17 +397,9 @@ static int ktd2692_probe(struct platform_device *pdev)
 static int ktd2692_remove(struct platform_device *pdev)
 {
 	struct ktd2692_context *led = platform_get_drvdata(pdev);
-	int ret;
 
 	led_classdev_flash_unregister(&led->fled_cdev);
 
-	if (led->regulator) {
-		ret = regulator_disable(led->regulator);
-		if (ret)
-			dev_err(&pdev->dev,
-				"Failed to disable supply: %d\n", ret);
-	}
-
 	mutex_destroy(&led->lock);
 
 	return 0;
diff --git a/drivers/md/persistent-data/dm-btree-remove.c b/drivers/md/persistent-data/dm-btree-remove.c
index eff04fa23dfa..9e4d1212f4c1 100644
--- a/drivers/md/persistent-data/dm-btree-remove.c
+++ b/drivers/md/persistent-data/dm-btree-remove.c
@@ -549,7 +549,8 @@ int dm_btree_remove(struct dm_btree_info *info, dm_block_t root,
 		delete_at(n, index);
 	}
 
-	*new_root = shadow_root(&spine);
+	if (!r)
+		*new_root = shadow_root(&spine);
 	exit_shadow_spine(&spine);
 
 	return r;
diff --git a/drivers/md/persistent-data/dm-space-map-disk.c b/drivers/md/persistent-data/dm-space-map-disk.c
index bf4c5e2ccb6f..e0acae7a3815 100644
--- a/drivers/md/persistent-data/dm-space-map-disk.c
+++ b/drivers/md/persistent-data/dm-space-map-disk.c
@@ -171,6 +171,14 @@ static int sm_disk_new_block(struct dm_space_map *sm, dm_block_t *b)
 	 * Any block we allocate has to be free in both the old and current ll.
 	 */
 	r = sm_ll_find_common_free_block(&smd->old_ll, &smd->ll, smd->begin, smd->ll.nr_blocks, b);
+	if (r == -ENOSPC) {
+		/*
+		 * There's no free block between smd->begin and the end of the metadata device.
+		 * We search before smd->begin in case something has been freed.
+		 */
+		r = sm_ll_find_common_free_block(&smd->old_ll, &smd->ll, 0, smd->begin, b);
+	}
+
 	if (r)
 		return r;
 
@@ -199,7 +207,6 @@ static int sm_disk_commit(struct dm_space_map *sm)
 		return r;
 
 	memcpy(&smd->old_ll, &smd->ll, sizeof(smd->old_ll));
-	smd->begin = 0;
 	smd->nr_allocated_this_transaction = 0;
 
 	r = sm_disk_get_nr_free(sm, &nr_free);
diff --git a/drivers/md/persistent-data/dm-space-map-metadata.c b/drivers/md/persistent-data/dm-space-map-metadata.c
index 31a999458be9..b3ded452e573 100644
--- a/drivers/md/persistent-data/dm-space-map-metadata.c
+++ b/drivers/md/persistent-data/dm-space-map-metadata.c
@@ -451,6 +451,14 @@ static int sm_metadata_new_block_(struct dm_space_map *sm, dm_block_t *b)
 	 * Any block we allocate has to be free in both the old and current ll.
 	 */
 	r = sm_ll_find_common_free_block(&smm->old_ll, &smm->ll, smm->begin, smm->ll.nr_blocks, b);
+	if (r == -ENOSPC) {
+		/*
+		 * There's no free block between smm->begin and the end of the metadata device.
+		 * We search before smm->begin in case something has been freed.
+		 */
+		r = sm_ll_find_common_free_block(&smm->old_ll, &smm->ll, 0, smm->begin, b);
+	}
+
 	if (r)
 		return r;
 
@@ -502,7 +510,6 @@ static int sm_metadata_commit(struct dm_space_map *sm)
 		return r;
 
 	memcpy(&smm->old_ll, &smm->ll, sizeof(smm->old_ll));
-	smm->begin = 0;
 	smm->allocated_this_transaction = 0;
 
 	return 0;
diff --git a/drivers/media/common/siano/smscoreapi.c b/drivers/media/common/siano/smscoreapi.c
index e7a0d7798d5b..963289e21598 100644
--- a/drivers/media/common/siano/smscoreapi.c
+++ b/drivers/media/common/siano/smscoreapi.c
@@ -910,7 +910,7 @@ static int smscore_load_firmware_family2(struct smscore_device_t *coredev,
 					 void *buffer, size_t size)
 {
 	struct sms_firmware *firmware = (struct sms_firmware *) buffer;
-	struct sms_msg_data4 *msg;
+	struct sms_msg_data5 *msg;
 	u32 mem_address,  calc_checksum = 0;
 	u32 i, *ptr;
 	u8 *payload = firmware->payload;
@@ -991,24 +991,20 @@ static int smscore_load_firmware_family2(struct smscore_device_t *coredev,
 		goto exit_fw_download;
 
 	if (coredev->mode == DEVICE_MODE_NONE) {
-		struct sms_msg_data *trigger_msg =
-			(struct sms_msg_data *) msg;
-
 		pr_debug("sending MSG_SMS_SWDOWNLOAD_TRIGGER_REQ\n");
 		SMS_INIT_MSG(&msg->x_msg_header,
 				MSG_SMS_SWDOWNLOAD_TRIGGER_REQ,
-				sizeof(struct sms_msg_hdr) +
-				sizeof(u32) * 5);
+				sizeof(*msg));
 
-		trigger_msg->msg_data[0] = firmware->start_address;
+		msg->msg_data[0] = firmware->start_address;
 					/* Entry point */
-		trigger_msg->msg_data[1] = 6; /* Priority */
-		trigger_msg->msg_data[2] = 0x200; /* Stack size */
-		trigger_msg->msg_data[3] = 0; /* Parameter */
-		trigger_msg->msg_data[4] = 4; /* Task ID */
+		msg->msg_data[1] = 6; /* Priority */
+		msg->msg_data[2] = 0x200; /* Stack size */
+		msg->msg_data[3] = 0; /* Parameter */
+		msg->msg_data[4] = 4; /* Task ID */
 
-		rc = smscore_sendrequest_and_wait(coredev, trigger_msg,
-					trigger_msg->x_msg_header.msg_length,
+		rc = smscore_sendrequest_and_wait(coredev, msg,
+					msg->x_msg_header.msg_length,
 					&coredev->trigger_done);
 	} else {
 		SMS_INIT_MSG(&msg->x_msg_header, MSG_SW_RELOAD_EXEC_REQ,
diff --git a/drivers/media/common/siano/smscoreapi.h b/drivers/media/common/siano/smscoreapi.h
index 4cc39e4a8318..55d02c27f124 100644
--- a/drivers/media/common/siano/smscoreapi.h
+++ b/drivers/media/common/siano/smscoreapi.h
@@ -636,9 +636,9 @@ struct sms_msg_data2 {
 	u32 msg_data[2];
 };
 
-struct sms_msg_data4 {
+struct sms_msg_data5 {
 	struct sms_msg_hdr x_msg_header;
-	u32 msg_data[4];
+	u32 msg_data[5];
 };
 
 struct sms_data_download {
diff --git a/drivers/media/common/siano/smsdvb-main.c b/drivers/media/common/siano/smsdvb-main.c
index 15e895c9f2e0..cbe5f08ae9ad 100644
--- a/drivers/media/common/siano/smsdvb-main.c
+++ b/drivers/media/common/siano/smsdvb-main.c
@@ -1187,6 +1187,10 @@ static int smsdvb_hotplug(struct smscore_device_t *coredev,
 	return 0;
 
 media_graph_error:
+	mutex_lock(&g_smsdvb_clientslock);
+	list_del(&client->entry);
+	mutex_unlock(&g_smsdvb_clientslock);
+
 	smsdvb_debugfs_release(client);
 
 client_error:
diff --git a/drivers/media/dvb-core/dvb_net.c b/drivers/media/dvb-core/dvb_net.c
index 06b0dcc13695..280f941ca97d 100644
--- a/drivers/media/dvb-core/dvb_net.c
+++ b/drivers/media/dvb-core/dvb_net.c
@@ -56,6 +56,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
+#include <linux/nospec.h>
 #include <linux/etherdevice.h>
 #include <linux/dvb/net.h>
 #include <linux/uio.h>
@@ -1481,14 +1482,20 @@ static int dvb_net_do_ioctl(struct file *file,
 		struct net_device *netdev;
 		struct dvb_net_priv *priv_data;
 		struct dvb_net_if *dvbnetif = parg;
+		int if_num = dvbnetif->if_num;
 
-		if (dvbnetif->if_num >= DVB_NET_DEVICES_MAX ||
-		    !dvbnet->state[dvbnetif->if_num]) {
+		if (if_num >= DVB_NET_DEVICES_MAX) {
 			ret = -EINVAL;
 			goto ioctl_error;
 		}
+		if_num = array_index_nospec(if_num, DVB_NET_DEVICES_MAX);
 
-		netdev = dvbnet->device[dvbnetif->if_num];
+		if (!dvbnet->state[if_num]) {
+			ret = -EINVAL;
+			goto ioctl_error;
+		}
+
+		netdev = dvbnet->device[if_num];
 
 		priv_data = netdev_priv(netdev);
 		dvbnetif->pid=priv_data->pid;
@@ -1541,14 +1548,20 @@ static int dvb_net_do_ioctl(struct file *file,
 		struct net_device *netdev;
 		struct dvb_net_priv *priv_data;
 		struct __dvb_net_if_old *dvbnetif = parg;
+		int if_num = dvbnetif->if_num;
+
+		if (if_num >= DVB_NET_DEVICES_MAX) {
+			ret = -EINVAL;
+			goto ioctl_error;
+		}
+		if_num = array_index_nospec(if_num, DVB_NET_DEVICES_MAX);
 
-		if (dvbnetif->if_num >= DVB_NET_DEVICES_MAX ||
-		    !dvbnet->state[dvbnetif->if_num]) {
+		if (!dvbnet->state[if_num]) {
 			ret = -EINVAL;
 			goto ioctl_error;
 		}
 
-		netdev = dvbnet->device[dvbnetif->if_num];
+		netdev = dvbnet->device[if_num];
 
 		priv_data = netdev_priv(netdev);
 		dvbnetif->pid=priv_data->pid;
diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-core.c b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
index cdc4f2392ef9..e7a107ecd219 100644
--- a/drivers/media/i2c/s5c73m3/s5c73m3-core.c
+++ b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
@@ -1394,7 +1394,7 @@ static int __s5c73m3_power_on(struct s5c73m3 *state)
 	s5c73m3_gpio_deassert(state, STBY);
 	usleep_range(100, 200);
 
-	s5c73m3_gpio_deassert(state, RST);
+	s5c73m3_gpio_deassert(state, RSET);
 	usleep_range(50, 100);
 
 	return 0;
@@ -1409,7 +1409,7 @@ static int __s5c73m3_power_off(struct s5c73m3 *state)
 {
 	int i, ret;
 
-	if (s5c73m3_gpio_assert(state, RST))
+	if (s5c73m3_gpio_assert(state, RSET))
 		usleep_range(10, 50);
 
 	if (s5c73m3_gpio_assert(state, STBY))
@@ -1614,7 +1614,7 @@ static int s5c73m3_get_platform_data(struct s5c73m3 *state)
 
 		state->mclk_frequency = pdata->mclk_frequency;
 		state->gpio[STBY] = pdata->gpio_stby;
-		state->gpio[RST] = pdata->gpio_reset;
+		state->gpio[RSET] = pdata->gpio_reset;
 		return 0;
 	}
 
diff --git a/drivers/media/i2c/s5c73m3/s5c73m3.h b/drivers/media/i2c/s5c73m3/s5c73m3.h
index 653f68e7ea07..e267b2522149 100644
--- a/drivers/media/i2c/s5c73m3/s5c73m3.h
+++ b/drivers/media/i2c/s5c73m3/s5c73m3.h
@@ -361,7 +361,7 @@ struct s5c73m3_ctrls {
 
 enum s5c73m3_gpio_id {
 	STBY,
-	RST,
+	RSET,
 	GPIO_NUM,
 };
 
diff --git a/drivers/media/i2c/s5k4ecgx.c b/drivers/media/i2c/s5k4ecgx.c
index 6ebcf254989a..75fb13a33eab 100644
--- a/drivers/media/i2c/s5k4ecgx.c
+++ b/drivers/media/i2c/s5k4ecgx.c
@@ -177,7 +177,7 @@ static const char * const s5k4ecgx_supply_names[] = {
 
 enum s5k4ecgx_gpio_id {
 	STBY,
-	RST,
+	RSET,
 	GPIO_NUM,
 };
 
@@ -482,7 +482,7 @@ static int __s5k4ecgx_power_on(struct s5k4ecgx *priv)
 	if (s5k4ecgx_gpio_set_value(priv, STBY, priv->gpio[STBY].level))
 		usleep_range(30, 50);
 
-	if (s5k4ecgx_gpio_set_value(priv, RST, priv->gpio[RST].level))
+	if (s5k4ecgx_gpio_set_value(priv, RSET, priv->gpio[RSET].level))
 		usleep_range(30, 50);
 
 	return 0;
@@ -490,7 +490,7 @@ static int __s5k4ecgx_power_on(struct s5k4ecgx *priv)
 
 static int __s5k4ecgx_power_off(struct s5k4ecgx *priv)
 {
-	if (s5k4ecgx_gpio_set_value(priv, RST, !priv->gpio[RST].level))
+	if (s5k4ecgx_gpio_set_value(priv, RSET, !priv->gpio[RSET].level))
 		usleep_range(30, 50);
 
 	if (s5k4ecgx_gpio_set_value(priv, STBY, !priv->gpio[STBY].level))
@@ -878,7 +878,7 @@ static int s5k4ecgx_config_gpios(struct s5k4ecgx *priv,
 	int ret;
 
 	priv->gpio[STBY].gpio = -EINVAL;
-	priv->gpio[RST].gpio  = -EINVAL;
+	priv->gpio[RSET].gpio  = -EINVAL;
 
 	ret = s5k4ecgx_config_gpio(gpio->gpio, gpio->level, "S5K4ECGX_STBY");
 
@@ -897,7 +897,7 @@ static int s5k4ecgx_config_gpios(struct s5k4ecgx *priv,
 		s5k4ecgx_free_gpios(priv);
 		return ret;
 	}
-	priv->gpio[RST] = *gpio;
+	priv->gpio[RSET] = *gpio;
 	if (gpio_is_valid(gpio->gpio))
 		gpio_set_value(gpio->gpio, 0);
 
diff --git a/drivers/media/i2c/s5k5baf.c b/drivers/media/i2c/s5k5baf.c
index ff46d2c96cea..18a88eb50ad8 100644
--- a/drivers/media/i2c/s5k5baf.c
+++ b/drivers/media/i2c/s5k5baf.c
@@ -238,7 +238,7 @@ struct s5k5baf_gpio {
 
 enum s5k5baf_gpio_id {
 	STBY,
-	RST,
+	RSET,
 	NUM_GPIOS,
 };
 
@@ -973,7 +973,7 @@ static int s5k5baf_power_on(struct s5k5baf *state)
 
 	s5k5baf_gpio_deassert(state, STBY);
 	usleep_range(50, 100);
-	s5k5baf_gpio_deassert(state, RST);
+	s5k5baf_gpio_deassert(state, RSET);
 	return 0;
 
 err_reg_dis:
@@ -991,7 +991,7 @@ static int s5k5baf_power_off(struct s5k5baf *state)
 	state->apply_cfg = 0;
 	state->apply_crop = 0;
 
-	s5k5baf_gpio_assert(state, RST);
+	s5k5baf_gpio_assert(state, RSET);
 	s5k5baf_gpio_assert(state, STBY);
 
 	if (!IS_ERR(state->clock))
diff --git a/drivers/media/i2c/s5k6aa.c b/drivers/media/i2c/s5k6aa.c
index 13c10b5e2b45..e9c6e41cd44d 100644
--- a/drivers/media/i2c/s5k6aa.c
+++ b/drivers/media/i2c/s5k6aa.c
@@ -181,7 +181,7 @@ static const char * const s5k6aa_supply_names[] = {
 
 enum s5k6aa_gpio_id {
 	STBY,
-	RST,
+	RSET,
 	GPIO_NUM,
 };
 
@@ -845,7 +845,7 @@ static int __s5k6aa_power_on(struct s5k6aa *s5k6aa)
 		ret = s5k6aa->s_power(1);
 	usleep_range(4000, 5000);
 
-	if (s5k6aa_gpio_deassert(s5k6aa, RST))
+	if (s5k6aa_gpio_deassert(s5k6aa, RSET))
 		msleep(20);
 
 	return ret;
@@ -855,7 +855,7 @@ static int __s5k6aa_power_off(struct s5k6aa *s5k6aa)
 {
 	int ret;
 
-	if (s5k6aa_gpio_assert(s5k6aa, RST))
+	if (s5k6aa_gpio_assert(s5k6aa, RSET))
 		usleep_range(100, 150);
 
 	if (s5k6aa->s_power) {
@@ -1514,7 +1514,7 @@ static int s5k6aa_configure_gpios(struct s5k6aa *s5k6aa,
 	int ret;
 
 	s5k6aa->gpio[STBY].gpio = -EINVAL;
-	s5k6aa->gpio[RST].gpio  = -EINVAL;
+	s5k6aa->gpio[RSET].gpio  = -EINVAL;
 
 	gpio = &pdata->gpio_stby;
 	if (gpio_is_valid(gpio->gpio)) {
@@ -1537,7 +1537,7 @@ static int s5k6aa_configure_gpios(struct s5k6aa *s5k6aa,
 		if (ret < 0)
 			return ret;
 
-		s5k6aa->gpio[RST] = *gpio;
+		s5k6aa->gpio[RSET] = *gpio;
 	}
 
 	return 0;
diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index f74c4f6814eb..b294433c8345 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -1806,6 +1806,7 @@ static int tc358743_probe_of(struct tc358743_state *state)
 	bps_pr_lane = 2 * endpoint->link_frequencies[0];
 	if (bps_pr_lane < 62500000U || bps_pr_lane > 1000000000U) {
 		dev_err(dev, "unsupported bps per lane: %u bps\n", bps_pr_lane);
+		ret = -EINVAL;
 		goto disable_clk;
 	}
 
diff --git a/drivers/media/pci/bt8xx/bt878.c b/drivers/media/pci/bt8xx/bt878.c
index d4bc78b4fcb5..cbf855d78785 100644
--- a/drivers/media/pci/bt8xx/bt878.c
+++ b/drivers/media/pci/bt8xx/bt878.c
@@ -494,6 +494,9 @@ static int bt878_probe(struct pci_dev *dev, const struct pci_device_id *pci_id)
 	btwrite(0, BT878_AINT_MASK);
 	bt878_num++;
 
+	if (!bt->tasklet.func)
+		tasklet_disable(&bt->tasklet);
+
 	return 0;
 
       fail2:
diff --git a/drivers/media/pci/cobalt/cobalt-driver.c b/drivers/media/pci/cobalt/cobalt-driver.c
index 98b6cb9505d1..0c827f488317 100644
--- a/drivers/media/pci/cobalt/cobalt-driver.c
+++ b/drivers/media/pci/cobalt/cobalt-driver.c
@@ -687,6 +687,7 @@ static int cobalt_probe(struct pci_dev *pci_dev,
 		return -ENOMEM;
 	cobalt->pci_dev = pci_dev;
 	cobalt->instance = i;
+	mutex_init(&cobalt->pci_lock);
 
 	retval = v4l2_device_register(&pci_dev->dev, &cobalt->v4l2_dev);
 	if (retval) {
diff --git a/drivers/media/pci/cobalt/cobalt-driver.h b/drivers/media/pci/cobalt/cobalt-driver.h
index 00f773ec359a..9f8db7eaa43c 100644
--- a/drivers/media/pci/cobalt/cobalt-driver.h
+++ b/drivers/media/pci/cobalt/cobalt-driver.h
@@ -262,6 +262,8 @@ struct cobalt {
 	int instance;
 	struct pci_dev *pci_dev;
 	struct v4l2_device v4l2_dev;
+	/* serialize PCI access in cobalt_s_bit_sysctrl() */
+	struct mutex pci_lock;
 
 	void __iomem *bar0, *bar1;
 
@@ -331,10 +333,13 @@ static inline u32 cobalt_g_sysctrl(struct cobalt *cobalt)
 static inline void cobalt_s_bit_sysctrl(struct cobalt *cobalt,
 					int bit, int val)
 {
-	u32 ctrl = cobalt_read_bar1(cobalt, COBALT_SYS_CTRL_BASE);
+	u32 ctrl;
 
+	mutex_lock(&cobalt->pci_lock);
+	ctrl = cobalt_read_bar1(cobalt, COBALT_SYS_CTRL_BASE);
 	cobalt_write_bar1(cobalt, COBALT_SYS_CTRL_BASE,
 			(ctrl & ~(1UL << bit)) | (val << bit));
+	mutex_unlock(&cobalt->pci_lock);
 }
 
 static inline u32 cobalt_g_sysstat(struct cobalt *cobalt)
diff --git a/drivers/media/platform/exynos4-is/fimc-isp-video.c b/drivers/media/platform/exynos4-is/fimc-isp-video.c
index 39340abefd14..c9ef74ee476a 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp-video.c
+++ b/drivers/media/platform/exynos4-is/fimc-isp-video.c
@@ -308,17 +308,20 @@ static int isp_video_release(struct file *file)
 	struct fimc_is_video *ivc = &isp->video_capture;
 	struct media_entity *entity = &ivc->ve.vdev.entity;
 	struct media_device *mdev = entity->graph_obj.mdev;
+	bool is_singular_file;
 
 	mutex_lock(&isp->video_lock);
 
-	if (v4l2_fh_is_singular_file(file) && ivc->streaming) {
+	is_singular_file = v4l2_fh_is_singular_file(file);
+
+	if (is_singular_file && ivc->streaming) {
 		media_pipeline_stop(entity);
 		ivc->streaming = 0;
 	}
 
 	_vb2_fop_release(file, NULL);
 
-	if (v4l2_fh_is_singular_file(file)) {
+	if (is_singular_file) {
 		fimc_pipeline_call(&ivc->ve, close);
 
 		mutex_lock(&mdev->graph_mutex);
diff --git a/drivers/media/platform/s5p-cec/s5p_cec.c b/drivers/media/platform/s5p-cec/s5p_cec.c
index 8837e2678bde..3032247c63a5 100644
--- a/drivers/media/platform/s5p-cec/s5p_cec.c
+++ b/drivers/media/platform/s5p-cec/s5p_cec.c
@@ -55,7 +55,7 @@ static int s5p_cec_adap_enable(struct cec_adapter *adap, bool enable)
 	} else {
 		s5p_cec_mask_tx_interrupts(cec);
 		s5p_cec_mask_rx_interrupts(cec);
-		pm_runtime_disable(cec->dev);
+		pm_runtime_put(cec->dev);
 	}
 
 	return 0;
diff --git a/drivers/media/platform/s5p-g2d/g2d.c b/drivers/media/platform/s5p-g2d/g2d.c
index 770100d40372..4b745138b363 100644
--- a/drivers/media/platform/s5p-g2d/g2d.c
+++ b/drivers/media/platform/s5p-g2d/g2d.c
@@ -283,6 +283,9 @@ static int g2d_release(struct file *file)
 	struct g2d_dev *dev = video_drvdata(file);
 	struct g2d_ctx *ctx = fh2ctx(file->private_data);
 
+	mutex_lock(&dev->mutex);
+	v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
+	mutex_unlock(&dev->mutex);
 	v4l2_ctrl_handler_free(&ctx->ctrl_handler);
 	v4l2_fh_del(&ctx->fh);
 	v4l2_fh_exit(&ctx->fh);
diff --git a/drivers/media/platform/sti/hva/hva-hw.c b/drivers/media/platform/sti/hva/hva-hw.c
index 1185f6b6721e..3bb4d55c2058 100644
--- a/drivers/media/platform/sti/hva/hva-hw.c
+++ b/drivers/media/platform/sti/hva/hva-hw.c
@@ -130,8 +130,7 @@ static irqreturn_t hva_hw_its_irq_thread(int irq, void *arg)
 	ctx_id = (hva->sts_reg & 0xFF00) >> 8;
 	if (ctx_id >= HVA_MAX_INSTANCES) {
 		dev_err(dev, "%s     %s: bad context identifier: %d\n",
-			ctx->name, __func__, ctx_id);
-		ctx->hw_err = true;
+			HVA_PREFIX, __func__, ctx_id);
 		goto out;
 	}
 
diff --git a/drivers/media/usb/cpia2/cpia2.h b/drivers/media/usb/cpia2/cpia2.h
index 81f72c0b561f..7259d0f75ddf 100644
--- a/drivers/media/usb/cpia2/cpia2.h
+++ b/drivers/media/usb/cpia2/cpia2.h
@@ -438,6 +438,7 @@ int cpia2_send_command(struct camera_data *cam, struct cpia2_command *cmd);
 int cpia2_do_command(struct camera_data *cam,
 		     unsigned int command,
 		     unsigned char direction, unsigned char param);
+void cpia2_deinit_camera_struct(struct camera_data *cam, struct usb_interface *intf);
 struct camera_data *cpia2_init_camera_struct(struct usb_interface *intf);
 int cpia2_init_camera(struct camera_data *cam);
 int cpia2_allocate_buffers(struct camera_data *cam);
diff --git a/drivers/media/usb/cpia2/cpia2_core.c b/drivers/media/usb/cpia2/cpia2_core.c
index 0efba0da0a45..d82d6c1d7654 100644
--- a/drivers/media/usb/cpia2/cpia2_core.c
+++ b/drivers/media/usb/cpia2/cpia2_core.c
@@ -2172,6 +2172,18 @@ static void reset_camera_struct(struct camera_data *cam)
 	cam->height = cam->params.roi.height;
 }
 
+/******************************************************************************
+ *
+ *  cpia2_init_camera_struct
+ *
+ *  Deinitialize camera struct
+ *****************************************************************************/
+void cpia2_deinit_camera_struct(struct camera_data *cam, struct usb_interface *intf)
+{
+	v4l2_device_unregister(&cam->v4l2_dev);
+	kfree(cam);
+}
+
 /******************************************************************************
  *
  *  cpia2_init_camera_struct
diff --git a/drivers/media/usb/cpia2/cpia2_usb.c b/drivers/media/usb/cpia2/cpia2_usb.c
index 91b9eaa9b2ad..6475f992c2b2 100644
--- a/drivers/media/usb/cpia2/cpia2_usb.c
+++ b/drivers/media/usb/cpia2/cpia2_usb.c
@@ -852,15 +852,13 @@ static int cpia2_usb_probe(struct usb_interface *intf,
 	ret = set_alternate(cam, USBIF_CMDONLY);
 	if (ret < 0) {
 		ERR("%s: usb_set_interface error (ret = %d)\n", __func__, ret);
-		kfree(cam);
-		return ret;
+		goto alt_err;
 	}
 
 
 	if((ret = cpia2_init_camera(cam)) < 0) {
 		ERR("%s: failed to initialize cpia2 camera (ret = %d)\n", __func__, ret);
-		kfree(cam);
-		return ret;
+		goto alt_err;
 	}
 	LOG("  CPiA Version: %d.%02d (%d.%d)\n",
 	       cam->params.version.firmware_revision_hi,
@@ -880,11 +878,14 @@ static int cpia2_usb_probe(struct usb_interface *intf,
 	ret = cpia2_register_camera(cam);
 	if (ret < 0) {
 		ERR("%s: Failed to register cpia2 camera (ret = %d)\n", __func__, ret);
-		kfree(cam);
-		return ret;
+		goto alt_err;
 	}
 
 	return 0;
+
+alt_err:
+	cpia2_deinit_camera_struct(cam, intf);
+	return ret;
 }
 
 /******************************************************************************
diff --git a/drivers/media/usb/dvb-usb/cinergyT2-core.c b/drivers/media/usb/dvb-usb/cinergyT2-core.c
index 6131aa7914a9..fb59dda7547a 100644
--- a/drivers/media/usb/dvb-usb/cinergyT2-core.c
+++ b/drivers/media/usb/dvb-usb/cinergyT2-core.c
@@ -88,6 +88,8 @@ static int cinergyt2_frontend_attach(struct dvb_usb_adapter *adap)
 
 	ret = dvb_usb_generic_rw(d, st->data, 1, st->data, 3, 0);
 	if (ret < 0) {
+		if (adap->fe_adap[0].fe)
+			adap->fe_adap[0].fe->ops.release(adap->fe_adap[0].fe);
 		deb_rc("cinergyt2_power_ctrl() Failed to retrieve sleep state info\n");
 	}
 	mutex_unlock(&d->data_mutex);
diff --git a/drivers/media/usb/dvb-usb/cxusb.c b/drivers/media/usb/dvb-usb/cxusb.c
index 47a9a791ee7d..e2cdf1e41005 100644
--- a/drivers/media/usb/dvb-usb/cxusb.c
+++ b/drivers/media/usb/dvb-usb/cxusb.c
@@ -1739,7 +1739,7 @@ static struct dvb_usb_device_properties cxusb_bluebird_lgz201_properties = {
 
 	.size_of_priv     = sizeof(struct cxusb_state),
 
-	.num_adapters = 2,
+	.num_adapters = 1,
 	.adapter = {
 		{
 		.num_frontends = 1,
diff --git a/drivers/media/usb/dvb-usb/dtv5100.c b/drivers/media/usb/dvb-usb/dtv5100.c
index 2fa2abd3e726..07fd0bbf9b80 100644
--- a/drivers/media/usb/dvb-usb/dtv5100.c
+++ b/drivers/media/usb/dvb-usb/dtv5100.c
@@ -35,6 +35,7 @@ static int dtv5100_i2c_msg(struct dvb_usb_device *d, u8 addr,
 			   u8 *wbuf, u16 wlen, u8 *rbuf, u16 rlen)
 {
 	struct dtv5100_state *st = d->priv;
+	unsigned int pipe;
 	u8 request;
 	u8 type;
 	u16 value;
@@ -43,6 +44,7 @@ static int dtv5100_i2c_msg(struct dvb_usb_device *d, u8 addr,
 	switch (wlen) {
 	case 1:
 		/* write { reg }, read { value } */
+		pipe = usb_rcvctrlpipe(d->udev, 0);
 		request = (addr == DTV5100_DEMOD_ADDR ? DTV5100_DEMOD_READ :
 							DTV5100_TUNER_READ);
 		type = USB_TYPE_VENDOR | USB_DIR_IN;
@@ -50,6 +52,7 @@ static int dtv5100_i2c_msg(struct dvb_usb_device *d, u8 addr,
 		break;
 	case 2:
 		/* write { reg, value } */
+		pipe = usb_sndctrlpipe(d->udev, 0);
 		request = (addr == DTV5100_DEMOD_ADDR ? DTV5100_DEMOD_WRITE :
 							DTV5100_TUNER_WRITE);
 		type = USB_TYPE_VENDOR | USB_DIR_OUT;
@@ -63,7 +66,7 @@ static int dtv5100_i2c_msg(struct dvb_usb_device *d, u8 addr,
 
 	memcpy(st->data, rbuf, rlen);
 	msleep(1); /* avoid I2C errors */
-	return usb_control_msg(d->udev, usb_rcvctrlpipe(d->udev, 0), request,
+	return usb_control_msg(d->udev, pipe, request,
 			       type, value, index, st->data, rlen,
 			       DTV5100_USB_TIMEOUT);
 }
@@ -150,7 +153,7 @@ static int dtv5100_probe(struct usb_interface *intf,
 
 	/* initialize non qt1010/zl10353 part? */
 	for (i = 0; dtv5100_init[i].request; i++) {
-		ret = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
+		ret = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
 				      dtv5100_init[i].request,
 				      USB_TYPE_VENDOR | USB_DIR_OUT,
 				      dtv5100_init[i].value,
diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
index 046223de1e91..b8c94b4ad232 100644
--- a/drivers/media/usb/em28xx/em28xx-input.c
+++ b/drivers/media/usb/em28xx/em28xx-input.c
@@ -710,7 +710,8 @@ static int em28xx_ir_init(struct em28xx *dev)
 			dev->board.has_ir_i2c = 0;
 			dev_warn(&dev->intf->dev,
 				 "No i2c IR remote control device found.\n");
-			return -ENODEV;
+			err = -ENODEV;
+			goto ref_put;
 		}
 	}
 
@@ -725,7 +726,7 @@ static int em28xx_ir_init(struct em28xx *dev)
 
 	ir = kzalloc(sizeof(*ir), GFP_KERNEL);
 	if (!ir)
-		return -ENOMEM;
+		goto ref_put;
 	rc = rc_allocate_device(RC_DRIVER_SCANCODE);
 	if (!rc)
 		goto error;
@@ -836,6 +837,9 @@ static int em28xx_ir_init(struct em28xx *dev)
 	dev->ir = NULL;
 	rc_free_device(rc);
 	kfree(ir);
+ref_put:
+	em28xx_shutdown_buttons(dev);
+	kref_put(&dev->ref, em28xx_free_device);
 	return err;
 }
 
diff --git a/drivers/media/usb/gspca/sq905.c b/drivers/media/usb/gspca/sq905.c
index ec03d18e057f..b6b62707c5ef 100644
--- a/drivers/media/usb/gspca/sq905.c
+++ b/drivers/media/usb/gspca/sq905.c
@@ -125,7 +125,7 @@ static int sq905_command(struct gspca_dev *gspca_dev, u16 index)
 	}
 
 	ret = usb_control_msg(gspca_dev->dev,
-			      usb_sndctrlpipe(gspca_dev->dev, 0),
+			      usb_rcvctrlpipe(gspca_dev->dev, 0),
 			      USB_REQ_SYNCH_FRAME,                /* request */
 			      USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 			      SQ905_PING, 0, gspca_dev->usb_buf, 1,
diff --git a/drivers/media/usb/gspca/sunplus.c b/drivers/media/usb/gspca/sunplus.c
index d87fcff38310..2a23a3e9cb32 100644
--- a/drivers/media/usb/gspca/sunplus.c
+++ b/drivers/media/usb/gspca/sunplus.c
@@ -251,6 +251,10 @@ static void reg_r(struct gspca_dev *gspca_dev,
 		PERR("reg_r: buffer overflow\n");
 		return;
 	}
+	if (len == 0) {
+		PERR("reg_r: zero-length read\n");
+		return;
+	}
 	if (gspca_dev->usb_err < 0)
 		return;
 	ret = usb_control_msg(gspca_dev->dev,
@@ -259,7 +263,7 @@ static void reg_r(struct gspca_dev *gspca_dev,
 			USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 			0,		/* value */
 			index,
-			len ? gspca_dev->usb_buf : NULL, len,
+			gspca_dev->usb_buf, len,
 			500);
 	if (ret < 0) {
 		pr_err("reg_r err %d\n", ret);
@@ -734,7 +738,7 @@ static int sd_start(struct gspca_dev *gspca_dev)
 		case MegaImageVI:
 			reg_w_riv(gspca_dev, 0xf0, 0, 0);
 			spca504B_WaitCmdStatus(gspca_dev);
-			reg_r(gspca_dev, 0xf0, 4, 0);
+			reg_w_riv(gspca_dev, 0xf0, 4, 0);
 			spca504B_WaitCmdStatus(gspca_dev);
 			break;
 		default:
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
index 18db7aaafcd6..fd1bd94cd78f 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
@@ -2670,9 +2670,8 @@ void pvr2_hdw_destroy(struct pvr2_hdw *hdw)
 		pvr2_stream_destroy(hdw->vid_stream);
 		hdw->vid_stream = NULL;
 	}
-	pvr2_i2c_core_done(hdw);
 	v4l2_device_unregister(&hdw->v4l2_dev);
-	pvr2_hdw_remove_usb_stuff(hdw);
+	pvr2_hdw_disconnect(hdw);
 	mutex_lock(&pvr2_unit_mtx);
 	do {
 		if ((hdw->unit_number >= 0) &&
@@ -2699,6 +2698,7 @@ void pvr2_hdw_disconnect(struct pvr2_hdw *hdw)
 {
 	pvr2_trace(PVR2_TRACE_INIT,"pvr2_hdw_disconnect(hdw=%p)",hdw);
 	LOCK_TAKE(hdw->big_lock);
+	pvr2_i2c_core_done(hdw);
 	LOCK_TAKE(hdw->ctl_lock);
 	pvr2_hdw_remove_usb_stuff(hdw);
 	LOCK_GIVE(hdw->ctl_lock);
diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index 393371916381..ce0a18019144 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -89,10 +89,37 @@ int uvc_query_ctrl(struct uvc_device *dev, __u8 query, __u8 unit,
 static void uvc_fixup_video_ctrl(struct uvc_streaming *stream,
 	struct uvc_streaming_control *ctrl)
 {
+	static const struct usb_device_id elgato_cam_link_4k = {
+		USB_DEVICE(0x0fd9, 0x0066)
+	};
 	struct uvc_format *format = NULL;
 	struct uvc_frame *frame = NULL;
 	unsigned int i;
 
+	/*
+	 * The response of the Elgato Cam Link 4K is incorrect: The second byte
+	 * contains bFormatIndex (instead of being the second byte of bmHint).
+	 * The first byte is always zero. The third byte is always 1.
+	 *
+	 * The UVC 1.5 class specification defines the first five bits in the
+	 * bmHint bitfield. The remaining bits are reserved and should be zero.
+	 * Therefore a valid bmHint will be less than 32.
+	 *
+	 * Latest Elgato Cam Link 4K firmware as of 2021-03-23 needs this fix.
+	 * MCU: 20.02.19, FPGA: 67
+	 */
+	if (usb_match_one_id(stream->dev->intf, &elgato_cam_link_4k) &&
+	    ctrl->bmHint > 255) {
+		u8 corrected_format_index = ctrl->bmHint >> 8;
+
+		/* uvc_dbg(stream->dev, VIDEO,
+			"Correct USB video probe response from {bmHint: 0x%04x, bFormatIndex: %u} to {bmHint: 0x%04x, bFormatIndex: %u}\n",
+			ctrl->bmHint, ctrl->bFormatIndex,
+			1, corrected_format_index); */
+		ctrl->bmHint = 1;
+		ctrl->bFormatIndex = corrected_format_index;
+	}
+
 	for (i = 0; i < stream->nformats; ++i) {
 		if (stream->format[i].index == ctrl->bFormatIndex) {
 			format = &stream->format[i];
diff --git a/drivers/media/usb/zr364xx/zr364xx.c b/drivers/media/usb/zr364xx/zr364xx.c
index d30f129a9db7..6afa49cb9520 100644
--- a/drivers/media/usb/zr364xx/zr364xx.c
+++ b/drivers/media/usb/zr364xx/zr364xx.c
@@ -1061,6 +1061,7 @@ static int zr364xx_start_readpipe(struct zr364xx_camera *cam)
 	DBG("submitting URB %p\n", pipe_info->stream_urb);
 	retval = usb_submit_urb(pipe_info->stream_urb, GFP_KERNEL);
 	if (retval) {
+		usb_free_urb(pipe_info->stream_urb);
 		printk(KERN_ERR KBUILD_MODNAME ": start read pipe failed\n");
 		return retval;
 	}
diff --git a/drivers/media/v4l2-core/v4l2-fh.c b/drivers/media/v4l2-core/v4l2-fh.c
index c91a7bd3ecfc..ac8282d059fc 100644
--- a/drivers/media/v4l2-core/v4l2-fh.c
+++ b/drivers/media/v4l2-core/v4l2-fh.c
@@ -104,6 +104,7 @@ int v4l2_fh_release(struct file *filp)
 		v4l2_fh_del(fh);
 		v4l2_fh_exit(fh);
 		kfree(fh);
+		filp->private_data = NULL;
 	}
 	return 0;
 }
diff --git a/drivers/memory/atmel-ebi.c b/drivers/memory/atmel-ebi.c
index b907865d4664..2b9283d4fcb1 100644
--- a/drivers/memory/atmel-ebi.c
+++ b/drivers/memory/atmel-ebi.c
@@ -579,8 +579,10 @@ static int atmel_ebi_probe(struct platform_device *pdev)
 				child);
 
 			ret = atmel_ebi_dev_disable(ebi, child);
-			if (ret)
+			if (ret) {
+				of_node_put(child);
 				return ret;
+			}
 		}
 	}
 
diff --git a/drivers/memory/fsl_ifc.c b/drivers/memory/fsl_ifc.c
index 1b182b117f9c..38b945eb410f 100644
--- a/drivers/memory/fsl_ifc.c
+++ b/drivers/memory/fsl_ifc.c
@@ -109,7 +109,6 @@ static int fsl_ifc_ctrl_remove(struct platform_device *dev)
 	iounmap(ctrl->gregs);
 
 	dev_set_drvdata(&dev->dev, NULL);
-	kfree(ctrl);
 
 	return 0;
 }
@@ -221,7 +220,8 @@ static int fsl_ifc_ctrl_probe(struct platform_device *dev)
 
 	dev_info(&dev->dev, "Freescale Integrated Flash Controller\n");
 
-	fsl_ifc_ctrl_dev = kzalloc(sizeof(*fsl_ifc_ctrl_dev), GFP_KERNEL);
+	fsl_ifc_ctrl_dev = devm_kzalloc(&dev->dev, sizeof(*fsl_ifc_ctrl_dev),
+					GFP_KERNEL);
 	if (!fsl_ifc_ctrl_dev)
 		return -ENOMEM;
 
@@ -231,8 +231,7 @@ static int fsl_ifc_ctrl_probe(struct platform_device *dev)
 	fsl_ifc_ctrl_dev->gregs = of_iomap(dev->dev.of_node, 0);
 	if (!fsl_ifc_ctrl_dev->gregs) {
 		dev_err(&dev->dev, "failed to get memory region\n");
-		ret = -ENODEV;
-		goto err;
+		return -ENODEV;
 	}
 
 	if (of_property_read_bool(dev->dev.of_node, "little-endian")) {
@@ -308,6 +307,7 @@ static int fsl_ifc_ctrl_probe(struct platform_device *dev)
 	free_irq(fsl_ifc_ctrl_dev->irq, fsl_ifc_ctrl_dev);
 	irq_dispose_mapping(fsl_ifc_ctrl_dev->irq);
 err:
+	iounmap(fsl_ifc_ctrl_dev->gregs);
 	return ret;
 }
 
diff --git a/drivers/mfd/da9052-i2c.c b/drivers/mfd/da9052-i2c.c
index 578e881067a5..4094f97ec7dc 100644
--- a/drivers/mfd/da9052-i2c.c
+++ b/drivers/mfd/da9052-i2c.c
@@ -118,6 +118,7 @@ static const struct i2c_device_id da9052_i2c_id[] = {
 	{"da9053-bc", DA9053_BC},
 	{}
 };
+MODULE_DEVICE_TABLE(i2c, da9052_i2c_id);
 
 #ifdef CONFIG_OF
 static const struct of_device_id dialog_dt_ids[] = {
diff --git a/drivers/mfd/stmpe-i2c.c b/drivers/mfd/stmpe-i2c.c
index 863c39a3353c..d284df25c76b 100644
--- a/drivers/mfd/stmpe-i2c.c
+++ b/drivers/mfd/stmpe-i2c.c
@@ -109,7 +109,7 @@ static const struct i2c_device_id stmpe_i2c_id[] = {
 	{ "stmpe2403", STMPE2403 },
 	{ }
 };
-MODULE_DEVICE_TABLE(i2c, stmpe_id);
+MODULE_DEVICE_TABLE(i2c, stmpe_i2c_id);
 
 static struct i2c_driver stmpe_i2c_driver = {
 	.driver = {
diff --git a/drivers/misc/eeprom/idt_89hpesx.c b/drivers/misc/eeprom/idt_89hpesx.c
index 34a5a41578d7..b972b5425654 100644
--- a/drivers/misc/eeprom/idt_89hpesx.c
+++ b/drivers/misc/eeprom/idt_89hpesx.c
@@ -1165,6 +1165,7 @@ static void idt_get_fw_data(struct idt_89hpesx_dev *pdev)
 	else /* if (!fwnode_property_read_bool(node, "read-only")) */
 		pdev->eero = false;
 
+	fwnode_handle_put(fwnode);
 	dev_info(dev, "EEPROM of %d bytes found by 0x%x",
 		pdev->eesize, pdev->eeaddr);
 }
diff --git a/drivers/misc/ibmasm/module.c b/drivers/misc/ibmasm/module.c
index c5a456b0a564..5bd62eebbb8a 100644
--- a/drivers/misc/ibmasm/module.c
+++ b/drivers/misc/ibmasm/module.c
@@ -123,7 +123,7 @@ static int ibmasm_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	result = ibmasm_init_remote_input_dev(sp);
 	if (result) {
 		dev_err(sp->dev, "Failed to initialize remote queue\n");
-		goto error_send_message;
+		goto error_init_remote;
 	}
 
 	result = ibmasm_send_driver_vpd(sp);
@@ -143,8 +143,9 @@ static int ibmasm_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	return 0;
 
 error_send_message:
-	disable_sp_interrupts(sp->base_address);
 	ibmasm_free_remote_input_dev(sp);
+error_init_remote:
+	disable_sp_interrupts(sp->base_address);
 	free_irq(sp->irq, (void *)sp);
 error_request_irq:
 	iounmap(sp->base_address);
diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index fa2c75c19e51..bf66df6f0efb 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -992,11 +992,14 @@ int mmc_execute_tuning(struct mmc_card *card)
 
 	err = host->ops->execute_tuning(host, opcode);
 
-	if (err)
+	if (err) {
 		pr_err("%s: tuning execution failed: %d\n",
 			mmc_hostname(host), err);
-	else
+	} else {
+		host->retune_now = 0;
+		host->need_retune = 0;
 		mmc_retune_enable(host);
+	}
 
 	return err;
 }
diff --git a/drivers/mmc/core/sd.c b/drivers/mmc/core/sd.c
index 188df3d02d14..942dc358b9fd 100644
--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -787,11 +787,13 @@ int mmc_sd_get_cid(struct mmc_host *host, u32 ocr, u32 *cid, u32 *rocr)
 		return err;
 
 	/*
-	 * In case CCS and S18A in the response is set, start Signal Voltage
-	 * Switch procedure. SPI mode doesn't support CMD11.
+	 * In case the S18A bit is set in the response, let's start the signal
+	 * voltage switch procedure. SPI mode doesn't support CMD11.
+	 * Note that, according to the spec, the S18A bit is not valid unless
+	 * the CCS bit is set as well. We deliberately deviate from the spec in
+	 * regards to this, which allows UHS-I to be supported for SDSC cards.
 	 */
-	if (!mmc_host_is_spi(host) && rocr &&
-	   ((*rocr & 0x41000000) == 0x41000000)) {
+	if (!mmc_host_is_spi(host) && rocr && (*rocr & 0x01000000)) {
 		err = mmc_set_uhs_voltage(host, pocr);
 		if (err == -EAGAIN) {
 			retries--;
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 33028099d3a0..ee3ce0d34dfc 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1293,6 +1293,10 @@ static u16 sdhci_get_preset_value(struct sdhci_host *host)
 	u16 preset = 0;
 
 	switch (host->timing) {
+	case MMC_TIMING_MMC_HS:
+	case MMC_TIMING_SD_HS:
+		preset = sdhci_readw(host, SDHCI_PRESET_FOR_HIGH_SPEED);
+		break;
 	case MMC_TIMING_UHS_SDR12:
 		preset = sdhci_readw(host, SDHCI_PRESET_FOR_SDR12);
 		break;
diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
index c0d5458c36d4..fa10293655ae 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -252,6 +252,7 @@
 
 /* 60-FB reserved */
 
+#define SDHCI_PRESET_FOR_HIGH_SPEED	0x64
 #define SDHCI_PRESET_FOR_SDR12 0x66
 #define SDHCI_PRESET_FOR_SDR25 0x68
 #define SDHCI_PRESET_FOR_SDR50 0x6A
diff --git a/drivers/mmc/host/usdhi6rol0.c b/drivers/mmc/host/usdhi6rol0.c
index 76e31a30b0cf..d27ee9eb2eac 100644
--- a/drivers/mmc/host/usdhi6rol0.c
+++ b/drivers/mmc/host/usdhi6rol0.c
@@ -1809,6 +1809,7 @@ static int usdhi6_probe(struct platform_device *pdev)
 
 	version = usdhi6_read(host, USDHI6_VERSION);
 	if ((version & 0xfff) != 0xa0d) {
+		ret = -EPERM;
 		dev_err(dev, "Version not recognized %x\n", version);
 		goto e_clk_off;
 	}
diff --git a/drivers/mmc/host/via-sdmmc.c b/drivers/mmc/host/via-sdmmc.c
index 8c0e348c6053..4e5043657ee2 100644
--- a/drivers/mmc/host/via-sdmmc.c
+++ b/drivers/mmc/host/via-sdmmc.c
@@ -865,6 +865,9 @@ static void via_sdc_data_isr(struct via_crdr_mmc_host *host, u16 intmask)
 {
 	BUG_ON(intmask == 0);
 
+	if (!host->data)
+		return;
+
 	if (intmask & VIA_CRDR_SDSTS_DT)
 		host->data->error = -ETIMEDOUT;
 	else if (intmask & (VIA_CRDR_SDSTS_RC | VIA_CRDR_SDSTS_WC))
diff --git a/drivers/mmc/host/vub300.c b/drivers/mmc/host/vub300.c
index 8f569d257405..7978ba98d047 100644
--- a/drivers/mmc/host/vub300.c
+++ b/drivers/mmc/host/vub300.c
@@ -2289,7 +2289,7 @@ static int vub300_probe(struct usb_interface *interface,
 	if (retval < 0)
 		goto error5;
 	retval =
-		usb_control_msg(vub300->udev, usb_rcvctrlpipe(vub300->udev, 0),
+		usb_control_msg(vub300->udev, usb_sndctrlpipe(vub300->udev, 0),
 				SET_ROM_WAIT_STATES,
 				USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 				firmware_rom_wait_states, 0x0000, NULL, 0, HZ);
diff --git a/drivers/net/can/peak_canfd/peak_canfd.c b/drivers/net/can/peak_canfd/peak_canfd.c
index a38dc6d9c978..96a7c281175d 100644
--- a/drivers/net/can/peak_canfd/peak_canfd.c
+++ b/drivers/net/can/peak_canfd/peak_canfd.c
@@ -346,8 +346,8 @@ static int pucan_handle_status(struct peak_canfd_priv *priv,
 				return err;
 		}
 
-		/* start network queue (echo_skb array is empty) */
-		netif_start_queue(ndev);
+		/* wake network queue up (echo_skb array is empty) */
+		netif_wake_queue(ndev);
 
 		return 0;
 	}
diff --git a/drivers/net/can/usb/ems_usb.c b/drivers/net/can/usb/ems_usb.c
index d0846ae9e0e4..022a9b3c7d4e 100644
--- a/drivers/net/can/usb/ems_usb.c
+++ b/drivers/net/can/usb/ems_usb.c
@@ -1064,7 +1064,6 @@ static void ems_usb_disconnect(struct usb_interface *intf)
 
 	if (dev) {
 		unregister_netdev(dev->netdev);
-		free_candev(dev->netdev);
 
 		unlink_all_urbs(dev);
 
@@ -1072,6 +1071,8 @@ static void ems_usb_disconnect(struct usb_interface *intf)
 
 		kfree(dev->intr_in_buffer);
 		kfree(dev->tx_msg_buffer);
+
+		free_candev(dev->netdev);
 	}
 }
 
diff --git a/drivers/net/ethernet/aeroflex/greth.c b/drivers/net/ethernet/aeroflex/greth.c
index 4309be3724ad..a20e95b39cf7 100644
--- a/drivers/net/ethernet/aeroflex/greth.c
+++ b/drivers/net/ethernet/aeroflex/greth.c
@@ -1546,10 +1546,11 @@ static int greth_of_remove(struct platform_device *of_dev)
 	mdiobus_unregister(greth->mdio);
 
 	unregister_netdev(ndev);
-	free_netdev(ndev);
 
 	of_iounmap(&of_dev->resource[0], greth->regs, resource_size(&of_dev->resource[0]));
 
+	free_netdev(ndev);
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 5855ffec4952..ce89c43ced8a 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -3765,3 +3765,4 @@ MODULE_AUTHOR("Broadcom Corporation");
 MODULE_DESCRIPTION("Broadcom GENET Ethernet controller driver");
 MODULE_ALIAS("platform:bcmgenet");
 MODULE_LICENSE("GPL");
+MODULE_SOFTDEP("pre: mdio-bcm-unimac");
diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c b/drivers/net/ethernet/broadcom/genet/bcmmii.c
index fca9da1b1363..72fad2a63c62 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -414,6 +414,10 @@ static int bcmgenet_mii_register(struct bcmgenet_priv *priv)
 	int id, ret;
 
 	pres = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!pres) {
+		dev_err(&pdev->dev, "Invalid resource\n");
+		return -EINVAL;
+	}
 	memset(&res, 0, sizeof(res));
 	memset(&ppd, 0, sizeof(ppd));
 
diff --git a/drivers/net/ethernet/ezchip/nps_enet.c b/drivers/net/ethernet/ezchip/nps_enet.c
index 659f1ad37e96..70ccbd11b9e7 100644
--- a/drivers/net/ethernet/ezchip/nps_enet.c
+++ b/drivers/net/ethernet/ezchip/nps_enet.c
@@ -623,7 +623,7 @@ static s32 nps_enet_probe(struct platform_device *pdev)
 
 	/* Get IRQ number */
 	priv->irq = platform_get_irq(pdev, 0);
-	if (!priv->irq) {
+	if (priv->irq < 0) {
 		dev_err(dev, "failed to retrieve <irq Rx-Tx> value from device tree\n");
 		err = -ENODEV;
 		goto out_netdev;
@@ -658,8 +658,8 @@ static s32 nps_enet_remove(struct platform_device *pdev)
 	struct nps_enet_priv *priv = netdev_priv(ndev);
 
 	unregister_netdev(ndev);
-	free_netdev(ndev);
 	netif_napi_del(&priv->napi);
+	free_netdev(ndev);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/ibm/ehea/ehea_main.c b/drivers/net/ethernet/ibm/ehea/ehea_main.c
index 373deb247ac0..a754e2ce7730 100644
--- a/drivers/net/ethernet/ibm/ehea/ehea_main.c
+++ b/drivers/net/ethernet/ibm/ehea/ehea_main.c
@@ -2647,10 +2647,8 @@ static int ehea_restart_qps(struct net_device *dev)
 	u16 dummy16 = 0;
 
 	cb0 = (void *)get_zeroed_page(GFP_KERNEL);
-	if (!cb0) {
-		ret = -ENOMEM;
-		goto out;
-	}
+	if (!cb0)
+		return -ENOMEM;
 
 	for (i = 0; i < (port->num_def_qps); i++) {
 		struct ehea_port_res *pr =  &port->port_res[i];
@@ -2670,6 +2668,7 @@ static int ehea_restart_qps(struct net_device *dev)
 					    cb0);
 		if (hret != H_SUCCESS) {
 			netdev_err(dev, "query_ehea_qp failed (1)\n");
+			ret = -EFAULT;
 			goto out;
 		}
 
@@ -2682,6 +2681,7 @@ static int ehea_restart_qps(struct net_device *dev)
 					     &dummy64, &dummy16, &dummy16);
 		if (hret != H_SUCCESS) {
 			netdev_err(dev, "modify_ehea_qp failed (1)\n");
+			ret = -EFAULT;
 			goto out;
 		}
 
@@ -2690,6 +2690,7 @@ static int ehea_restart_qps(struct net_device *dev)
 					    cb0);
 		if (hret != H_SUCCESS) {
 			netdev_err(dev, "query_ehea_qp failed (2)\n");
+			ret = -EFAULT;
 			goto out;
 		}
 
diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 66fddc4ba56b..76ab6c0d40cf 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -898,6 +898,11 @@ static int __ibmvnic_open(struct net_device *netdev)
 
 	netif_tx_start_all_queues(netdev);
 
+	if (prev_state == VNIC_CLOSED) {
+		for (i = 0; i < adapter->req_rx_queues; i++)
+			napi_schedule(&adapter->napi[i]);
+	}
+
 	adapter->state = VNIC_OPEN;
 	return rc;
 }
diff --git a/drivers/net/ethernet/intel/e100.c b/drivers/net/ethernet/intel/e100.c
index 90974462743b..a73102357bbd 100644
--- a/drivers/net/ethernet/intel/e100.c
+++ b/drivers/net/ethernet/intel/e100.c
@@ -1423,7 +1423,7 @@ static int e100_phy_check_without_mii(struct nic *nic)
 	u8 phy_type;
 	int without_mii;
 
-	phy_type = (nic->eeprom[eeprom_phy_iface] >> 8) & 0x0f;
+	phy_type = (le16_to_cpu(nic->eeprom[eeprom_phy_iface]) >> 8) & 0x0f;
 
 	switch (phy_type) {
 	case NoSuchPhy: /* Non-MII PHY; UNTESTED! */
@@ -1543,7 +1543,7 @@ static int e100_phy_init(struct nic *nic)
 		mdio_write(netdev, nic->mii.phy_id, MII_BMCR, bmcr);
 	} else if ((nic->mac >= mac_82550_D102) || ((nic->flags & ich) &&
 	   (mdio_read(netdev, nic->mii.phy_id, MII_TPISTATUS) & 0x8000) &&
-		(nic->eeprom[eeprom_cnfg_mdix] & eeprom_mdix_enabled))) {
+	   (le16_to_cpu(nic->eeprom[eeprom_cnfg_mdix]) & eeprom_mdix_enabled))) {
 		/* enable/disable MDI/MDI-X auto-switching. */
 		mdio_write(netdev, nic->mii.phy_id, MII_NCONFIG,
 				nic->mii.force_media ? 0 : NCONFIG_AUTO_SWITCH);
@@ -2290,9 +2290,9 @@ static int e100_asf(struct nic *nic)
 {
 	/* ASF can be enabled from eeprom */
 	return (nic->pdev->device >= 0x1050) && (nic->pdev->device <= 0x1057) &&
-	   (nic->eeprom[eeprom_config_asf] & eeprom_asf) &&
-	   !(nic->eeprom[eeprom_config_asf] & eeprom_gcl) &&
-	   ((nic->eeprom[eeprom_smbus_addr] & 0xFF) != 0xFE);
+	   (le16_to_cpu(nic->eeprom[eeprom_config_asf]) & eeprom_asf) &&
+	   !(le16_to_cpu(nic->eeprom[eeprom_config_asf]) & eeprom_gcl) &&
+	   ((le16_to_cpu(nic->eeprom[eeprom_smbus_addr]) & 0xFF) != 0xFE);
 }
 
 static int e100_up(struct nic *nic)
@@ -2948,7 +2948,7 @@ static int e100_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	/* Wol magic packet can be enabled from eeprom */
 	if ((nic->mac >= mac_82558_D101_A4) &&
-	   (nic->eeprom[eeprom_id] & eeprom_id_wol)) {
+	   (le16_to_cpu(nic->eeprom[eeprom_id]) & eeprom_id_wol)) {
 		nic->flags |= wol_magic;
 		device_set_wakeup_enable(&pdev->dev, true);
 	}
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index e25bb667fb59..65c17e39c405 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -5755,6 +5755,8 @@ int i40e_vsi_open(struct i40e_vsi *vsi)
 			 dev_driver_string(&pf->pdev->dev),
 			 dev_name(&pf->pdev->dev));
 		err = i40e_vsi_request_irq(vsi, int_name);
+		if (err)
+			goto err_setup_rx;
 
 	} else {
 		err = -EINVAL;
diff --git a/drivers/net/ethernet/micrel/ks8842.c b/drivers/net/ethernet/micrel/ks8842.c
index e3d7c74d47bb..5282c5754ac1 100644
--- a/drivers/net/ethernet/micrel/ks8842.c
+++ b/drivers/net/ethernet/micrel/ks8842.c
@@ -1150,6 +1150,10 @@ static int ks8842_probe(struct platform_device *pdev)
 	unsigned i;
 
 	iomem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!iomem) {
+		dev_err(&pdev->dev, "Invalid resource\n");
+		return -EINVAL;
+	}
 	if (!request_mem_region(iomem->start, resource_size(iomem), DRV_NAME))
 		goto err_mem_region;
 
diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
index 5ae9681a2da7..22e63ae80a10 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
@@ -124,7 +124,7 @@ static int pch_ptp_match(struct sk_buff *skb, u16 uid_hi, u32 uid_lo, u16 seqid)
 {
 	u8 *data = skb->data;
 	unsigned int offset;
-	u16 *hi, *id;
+	u16 hi, id;
 	u32 lo;
 
 	if (ptp_classify_raw(skb) == PTP_CLASS_NONE)
@@ -135,14 +135,11 @@ static int pch_ptp_match(struct sk_buff *skb, u16 uid_hi, u32 uid_lo, u16 seqid)
 	if (skb->len < offset + OFF_PTP_SEQUENCE_ID + sizeof(seqid))
 		return 0;
 
-	hi = (u16 *)(data + offset + OFF_PTP_SOURCE_UUID);
-	id = (u16 *)(data + offset + OFF_PTP_SEQUENCE_ID);
+	hi = get_unaligned_be16(data + offset + OFF_PTP_SOURCE_UUID + 0);
+	lo = get_unaligned_be32(data + offset + OFF_PTP_SOURCE_UUID + 2);
+	id = get_unaligned_be16(data + offset + OFF_PTP_SEQUENCE_ID);
 
-	memcpy(&lo, &hi[1], sizeof(lo));
-
-	return (uid_hi == *hi &&
-		uid_lo == lo &&
-		seqid  == *id);
+	return (uid_hi == hi && uid_lo == lo && seqid == id);
 }
 
 static void
@@ -152,7 +149,6 @@ pch_rx_timestamp(struct pch_gbe_adapter *adapter, struct sk_buff *skb)
 	struct pci_dev *pdev;
 	u64 ns;
 	u32 hi, lo, val;
-	u16 uid, seq;
 
 	if (!adapter->hwts_rx_en)
 		return;
@@ -168,10 +164,7 @@ pch_rx_timestamp(struct pch_gbe_adapter *adapter, struct sk_buff *skb)
 	lo = pch_src_uuid_lo_read(pdev);
 	hi = pch_src_uuid_hi_read(pdev);
 
-	uid = hi & 0xffff;
-	seq = (hi >> 16) & 0xffff;
-
-	if (!pch_ptp_match(skb, htons(uid), htonl(lo), htons(seq)))
+	if (!pch_ptp_match(skb, hi, lo, hi >> 16))
 		goto out;
 
 	ns = pch_rx_snap_read(pdev);
@@ -2599,9 +2592,13 @@ static int pch_gbe_probe(struct pci_dev *pdev,
 	adapter->pdev = pdev;
 	adapter->hw.back = adapter;
 	adapter->hw.reg = pcim_iomap_table(pdev)[PCH_GBE_PCI_BAR];
+
 	adapter->pdata = (struct pch_gbe_privdata *)pci_id->driver_data;
-	if (adapter->pdata && adapter->pdata->platform_init)
-		adapter->pdata->platform_init(pdev);
+	if (adapter->pdata && adapter->pdata->platform_init) {
+		ret = adapter->pdata->platform_init(pdev);
+		if (ret)
+			goto err_free_netdev;
+	}
 
 	adapter->ptp_pdev = pci_get_bus_and_slot(adapter->pdev->bus->number,
 					       PCI_DEVFN(12, 4));
@@ -2696,7 +2693,7 @@ static int pch_gbe_probe(struct pci_dev *pdev,
  */
 static int pch_gbe_minnow_platform_init(struct pci_dev *pdev)
 {
-	unsigned long flags = GPIOF_DIR_OUT | GPIOF_INIT_HIGH | GPIOF_EXPORT;
+	unsigned long flags = GPIOF_OUT_INIT_HIGH;
 	unsigned gpio = MINNOW_PHY_RESET_GPIO;
 	int ret;
 
diff --git a/drivers/net/ethernet/sfc/ef10_sriov.c b/drivers/net/ethernet/sfc/ef10_sriov.c
index 019cef1d3cf7..2f36b18fd109 100644
--- a/drivers/net/ethernet/sfc/ef10_sriov.c
+++ b/drivers/net/ethernet/sfc/ef10_sriov.c
@@ -406,12 +406,17 @@ static int efx_ef10_pci_sriov_enable(struct efx_nic *efx, int num_vfs)
 	return rc;
 }
 
+/* Disable SRIOV and remove VFs
+ * If some VFs are attached to a guest (using Xen, only) nothing is
+ * done if force=false, and vports are freed if force=true (for the non
+ * attachedc ones, only) but SRIOV is not disabled and VFs are not
+ * removed in either case.
+ */
 static int efx_ef10_pci_sriov_disable(struct efx_nic *efx, bool force)
 {
 	struct pci_dev *dev = efx->pci_dev;
-	unsigned int vfs_assigned = 0;
-
-	vfs_assigned = pci_vfs_assigned(dev);
+	unsigned int vfs_assigned = pci_vfs_assigned(dev);
+	int rc = 0;
 
 	if (vfs_assigned && !force) {
 		netif_info(efx, drv, efx->net_dev, "VFs are assigned to guests; "
@@ -421,10 +426,12 @@ static int efx_ef10_pci_sriov_disable(struct efx_nic *efx, bool force)
 
 	if (!vfs_assigned)
 		pci_disable_sriov(dev);
+	else
+		rc = -EBUSY;
 
 	efx_ef10_sriov_free_vf_vswitching(efx);
 	efx->vf_count = 0;
-	return 0;
+	return rc;
 }
 
 int efx_ef10_sriov_configure(struct efx_nic *efx, int num_vfs)
@@ -443,7 +450,6 @@ int efx_ef10_sriov_init(struct efx_nic *efx)
 void efx_ef10_sriov_fini(struct efx_nic *efx)
 {
 	struct efx_ef10_nic_data *nic_data = efx->nic_data;
-	unsigned int i;
 	int rc;
 
 	if (!nic_data->vf) {
@@ -453,14 +459,7 @@ void efx_ef10_sriov_fini(struct efx_nic *efx)
 		return;
 	}
 
-	/* Remove any VFs in the host */
-	for (i = 0; i < efx->vf_count; ++i) {
-		struct efx_nic *vf_efx = nic_data->vf[i].efx;
-
-		if (vf_efx)
-			vf_efx->pci_dev->driver->remove(vf_efx->pci_dev);
-	}
-
+	/* Disable SRIOV and remove any VFs in the host */
 	rc = efx_ef10_pci_sriov_disable(efx, true);
 	if (rc)
 		netif_dbg(efx, drv, efx->net_dev,
diff --git a/drivers/net/fjes/fjes_main.c b/drivers/net/fjes/fjes_main.c
index 314e3eac09b9..26d3051591da 100644
--- a/drivers/net/fjes/fjes_main.c
+++ b/drivers/net/fjes/fjes_main.c
@@ -1277,6 +1277,10 @@ static int fjes_probe(struct platform_device *plat_dev)
 	adapter->interrupt_watch_enable = false;
 
 	res = platform_get_resource(plat_dev, IORESOURCE_MEM, 0);
+	if (!res) {
+		err = -EINVAL;
+		goto err_free_control_wq;
+	}
 	hw->hw_res.start = res->start;
 	hw->hw_res.size = resource_size(res);
 	hw->hw_res.irq = platform_get_irq(plat_dev, 0);
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 2d2a307c0231..c8abbf81ef52 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1262,7 +1262,7 @@ static int xmit_skb(struct send_queue *sq, struct sk_buff *skb)
 	if (virtio_net_hdr_from_skb(skb, &hdr->hdr,
 				    virtio_is_little_endian(vi->vdev), false,
 				    0))
-		BUG();
+		return -EPROTO;
 
 	if (vi->mergeable_rx_bufs)
 		hdr->num_buffers = 0;
@@ -2765,8 +2765,11 @@ static __maybe_unused int virtnet_restore(struct virtio_device *vdev)
 	virtnet_set_queues(vi, vi->curr_queue_pairs);
 
 	err = virtnet_cpu_notif_add(vi);
-	if (err)
+	if (err) {
+		virtnet_freeze_down(vdev);
+		remove_vq_common(vi);
 		return err;
+	}
 
 	return 0;
 }
diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 94a9add2fc87..066a4654e838 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -1681,6 +1681,7 @@ static int neigh_reduce(struct net_device *dev, struct sk_buff *skb, __be32 vni)
 	struct neighbour *n;
 	struct nd_msg *msg;
 
+	rcu_read_lock();
 	in6_dev = __in6_dev_get(dev);
 	if (!in6_dev)
 		goto out;
@@ -1732,6 +1733,7 @@ static int neigh_reduce(struct net_device *dev, struct sk_buff *skb, __be32 vni)
 	}
 
 out:
+	rcu_read_unlock();
 	consume_skb(skb);
 	return NETDEV_TX_OK;
 }
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index aa5bec5a3676..e42546bc99ef 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -5061,6 +5061,7 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 
 	if (arvif->nohwcrypt &&
 	    !test_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags)) {
+		ret = -EINVAL;
 		ath10k_warn(ar, "cryptmode module param needed for sw crypto\n");
 		goto err;
 	}
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 8e084670c3c2..a678dd8035f3 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -303,6 +303,11 @@ static int ath_reset_internal(struct ath_softc *sc, struct ath9k_channel *hchan)
 		hchan = ah->curchan;
 	}
 
+	if (!hchan) {
+		fastcc = false;
+		hchan = ath9k_cmn_get_channel(sc->hw, ah, &sc->cur_chan->chandef);
+	}
+
 	if (!ath_prepare_reset(sc))
 		fastcc = false;
 
diff --git a/drivers/net/wireless/ath/carl9170/Kconfig b/drivers/net/wireless/ath/carl9170/Kconfig
index 2e34baeaf764..2b782db20fde 100644
--- a/drivers/net/wireless/ath/carl9170/Kconfig
+++ b/drivers/net/wireless/ath/carl9170/Kconfig
@@ -15,13 +15,11 @@ config CARL9170
 
 config CARL9170_LEDS
 	bool "SoftLED Support"
-	depends on CARL9170
-	select MAC80211_LEDS
-	select LEDS_CLASS
-	select NEW_LEDS
 	default y
+	depends on CARL9170
+	depends on MAC80211_LEDS
 	help
-	  This option is necessary, if you want your device' LEDs to blink
+	  This option is necessary, if you want your device's LEDs to blink.
 
 	  Say Y, unless you need the LEDs for firmware debugging.
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
index 66f1f41b1380..c82e53145c2c 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
@@ -1223,6 +1223,7 @@ static int brcms_bcma_probe(struct bcma_device *pdev)
 {
 	struct brcms_info *wl;
 	struct ieee80211_hw *hw;
+	int ret;
 
 	dev_info(&pdev->dev, "mfg %x core %x rev %d class %d irq %d\n",
 		 pdev->id.manuf, pdev->id.id, pdev->id.rev, pdev->id.class,
@@ -1247,11 +1248,16 @@ static int brcms_bcma_probe(struct bcma_device *pdev)
 	wl = brcms_attach(pdev);
 	if (!wl) {
 		pr_err("%s: brcms_attach failed!\n", __func__);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto err_free_ieee80211;
 	}
 	brcms_led_register(wl);
 
 	return 0;
+
+err_free_ieee80211:
+	ieee80211_free_hw(hw);
+	return ret;
 }
 
 static int brcms_suspend(struct bcma_device *pdev)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 9aab9a026954..d82d8cfe2e41 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -3270,6 +3270,7 @@ static int iwl_mvm_roc(struct ieee80211_hw *hw,
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	struct cfg80211_chan_def chandef;
 	struct iwl_mvm_phy_ctxt *phy_ctxt;
+	bool band_change_removal;
 	int ret, i;
 
 	IWL_DEBUG_MAC80211(mvm, "enter (%d, %d, %d)\n", channel->hw_value,
@@ -3335,19 +3336,30 @@ static int iwl_mvm_roc(struct ieee80211_hw *hw,
 	cfg80211_chandef_create(&chandef, channel, NL80211_CHAN_NO_HT);
 
 	/*
-	 * Change the PHY context configuration as it is currently referenced
-	 * only by the P2P Device MAC
+	 * Check if the remain-on-channel is on a different band and that
+	 * requires context removal, see iwl_mvm_phy_ctxt_changed(). If
+	 * so, we'll need to release and then re-configure here, since we
+	 * must not remove a PHY context that's part of a binding.
 	 */
-	if (mvmvif->phy_ctxt->ref == 1) {
+	band_change_removal =
+		fw_has_capa(&mvm->fw->ucode_capa,
+			    IWL_UCODE_TLV_CAPA_BINDING_CDB_SUPPORT) &&
+		mvmvif->phy_ctxt->channel->band != chandef.chan->band;
+
+	if (mvmvif->phy_ctxt->ref == 1 && !band_change_removal) {
+		/*
+		 * Change the PHY context configuration as it is currently
+		 * referenced only by the P2P Device MAC (and we can modify it)
+		 */
 		ret = iwl_mvm_phy_ctxt_changed(mvm, mvmvif->phy_ctxt,
 					       &chandef, 1, 1);
 		if (ret)
 			goto out_unlock;
 	} else {
 		/*
-		 * The PHY context is shared with other MACs. Need to remove the
-		 * P2P Device from the binding, allocate an new PHY context and
-		 * create a new binding
+		 * The PHY context is shared with other MACs (or we're trying to
+		 * switch bands), so remove the P2P Device from the binding,
+		 * allocate an new PHY context and create a new binding.
 		 */
 		phy_ctxt = iwl_mvm_get_free_phy_ctxt(mvm);
 		if (!phy_ctxt) {
diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 7f615ad98aca..5b12d5191acc 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -1070,7 +1070,7 @@ static int mwifiex_pcie_delete_cmdrsp_buf(struct mwifiex_adapter *adapter)
 static int mwifiex_pcie_alloc_sleep_cookie_buf(struct mwifiex_adapter *adapter)
 {
 	struct pcie_service_card *card = adapter->card;
-	u32 tmp;
+	u32 *cookie;
 
 	card->sleep_cookie_vbase = pci_alloc_consistent(card->dev, sizeof(u32),
 						     &card->sleep_cookie_pbase);
@@ -1079,13 +1079,11 @@ static int mwifiex_pcie_alloc_sleep_cookie_buf(struct mwifiex_adapter *adapter)
 			    "pci_alloc_consistent failed!\n");
 		return -ENOMEM;
 	}
+	cookie = (u32 *)card->sleep_cookie_vbase;
 	/* Init val of Sleep Cookie */
-	tmp = FW_AWAKE_COOKIE;
-	put_unaligned(tmp, card->sleep_cookie_vbase);
+	*cookie = FW_AWAKE_COOKIE;
 
-	mwifiex_dbg(adapter, INFO,
-		    "alloc_scook: sleep cookie=0x%x\n",
-		    get_unaligned(card->sleep_cookie_vbase));
+	mwifiex_dbg(adapter, INFO, "alloc_scook: sleep cookie=0x%x\n", *cookie);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/rsi/rsi_91x_hal.c b/drivers/net/wireless/rsi/rsi_91x_hal.c
index d205947c4c55..1257ef308e8c 100644
--- a/drivers/net/wireless/rsi/rsi_91x_hal.c
+++ b/drivers/net/wireless/rsi/rsi_91x_hal.c
@@ -386,9 +386,9 @@ int rsi_prepare_beacon(struct rsi_common *common, struct sk_buff *skb)
 	}
 
 	if (common->band == NL80211_BAND_2GHZ)
-		bcn_frm->bbp_info |= cpu_to_le16(RSI_RATE_1);
+		bcn_frm->rate_info |= cpu_to_le16(RSI_RATE_1);
 	else
-		bcn_frm->bbp_info |= cpu_to_le16(RSI_RATE_6);
+		bcn_frm->rate_info |= cpu_to_le16(RSI_RATE_6);
 
 	if (mac_bcn->data[tim_offset + 2] == 0)
 		bcn_frm->frame_info |= cpu_to_le16(RSI_DATA_DESC_DTIM_BEACON);
diff --git a/drivers/net/wireless/st/cw1200/cw1200_sdio.c b/drivers/net/wireless/st/cw1200/cw1200_sdio.c
index 1037ec62659d..ee86436bf152 100644
--- a/drivers/net/wireless/st/cw1200/cw1200_sdio.c
+++ b/drivers/net/wireless/st/cw1200/cw1200_sdio.c
@@ -63,6 +63,7 @@ static const struct sdio_device_id cw1200_sdio_ids[] = {
 	{ SDIO_DEVICE(SDIO_VENDOR_ID_STE, SDIO_DEVICE_ID_STE_CW1200) },
 	{ /* end: all zeroes */			},
 };
+MODULE_DEVICE_TABLE(sdio, cw1200_sdio_ids);
 
 /* hwbus_ops implemetation */
 
diff --git a/drivers/net/wireless/ti/wl1251/cmd.c b/drivers/net/wireless/ti/wl1251/cmd.c
index 9547aea01b0f..ea0215246c5c 100644
--- a/drivers/net/wireless/ti/wl1251/cmd.c
+++ b/drivers/net/wireless/ti/wl1251/cmd.c
@@ -466,9 +466,12 @@ int wl1251_cmd_scan(struct wl1251 *wl, u8 *ssid, size_t ssid_len,
 		cmd->channels[i].channel = channels[i]->hw_value;
 	}
 
-	cmd->params.ssid_len = ssid_len;
-	if (ssid)
-		memcpy(cmd->params.ssid, ssid, ssid_len);
+	if (ssid) {
+		int len = clamp_val(ssid_len, 0, IEEE80211_MAX_SSID_LEN);
+
+		cmd->params.ssid_len = len;
+		memcpy(cmd->params.ssid, ssid, len);
+	}
 
 	ret = wl1251_cmd_send(wl, CMD_SCAN, cmd, sizeof(*cmd));
 	if (ret < 0) {
diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index 9bd635ec7827..72991d3a55f1 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -1516,6 +1516,13 @@ static int wl12xx_get_fuse_mac(struct wl1271 *wl)
 	u32 mac1, mac2;
 	int ret;
 
+	/* Device may be in ELP from the bootloader or kexec */
+	ret = wlcore_write32(wl, WL12XX_WELP_ARM_COMMAND, WELP_ARM_COMMAND_VAL);
+	if (ret < 0)
+		goto out;
+
+	usleep_range(500000, 700000);
+
 	ret = wlcore_set_partition(wl, &wl->ptable[PART_DRPW]);
 	if (ret < 0)
 		goto out;
diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 6337c394bfe3..b0bf2cb4f548 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -607,11 +607,11 @@ static int __init __reserved_mem_reserve_reg(unsigned long node,
 
 		if (size &&
 		    early_init_dt_reserve_memory_arch(base, size, nomap) == 0)
-			pr_debug("Reserved memory: reserved region for node '%s': base %pa, size %ld MiB\n",
-				uname, &base, (unsigned long)size / SZ_1M);
+			pr_debug("Reserved memory: reserved region for node '%s': base %pa, size %lu MiB\n",
+				uname, &base, (unsigned long)(size / SZ_1M));
 		else
-			pr_info("Reserved memory: failed to reserve memory for node '%s': base %pa, size %ld MiB\n",
-				uname, &base, (unsigned long)size / SZ_1M);
+			pr_info("Reserved memory: failed to reserve memory for node '%s': base %pa, size %lu MiB\n",
+				uname, &base, (unsigned long)(size / SZ_1M));
 
 		len -= t_len;
 		if (first) {
diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index 55cbafdb93ae..41589eb1bd8b 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -158,9 +158,9 @@ static int __init __reserved_mem_alloc_size(unsigned long node,
 			ret = early_init_dt_alloc_reserved_memory_arch(size,
 					align, start, end, nomap, &base);
 			if (ret == 0) {
-				pr_debug("allocated memory for '%s' node: base %pa, size %ld MiB\n",
+				pr_debug("allocated memory for '%s' node: base %pa, size %lu MiB\n",
 					uname, &base,
-					(unsigned long)size / SZ_1M);
+					(unsigned long)(size / SZ_1M));
 				break;
 			}
 			len -= t_len;
@@ -170,8 +170,8 @@ static int __init __reserved_mem_alloc_size(unsigned long node,
 		ret = early_init_dt_alloc_reserved_memory_arch(size, align,
 							0, 0, nomap, &base);
 		if (ret == 0)
-			pr_debug("allocated memory for '%s' node: base %pa, size %ld MiB\n",
-				uname, &base, (unsigned long)size / SZ_1M);
+			pr_debug("allocated memory for '%s' node: base %pa, size %lu MiB\n",
+				uname, &base, (unsigned long)(size / SZ_1M));
 	}
 
 	if (base == 0) {
diff --git a/drivers/pci/host/pci-aardvark.c b/drivers/pci/host/pci-aardvark.c
index c1db09fbbe04..a3a28e38430a 100644
--- a/drivers/pci/host/pci-aardvark.c
+++ b/drivers/pci/host/pci-aardvark.c
@@ -185,7 +185,8 @@
 	(PCIE_CONF_BUS(bus) | PCIE_CONF_DEV(PCI_SLOT(devfn))	| \
 	 PCIE_CONF_FUNC(PCI_FUNC(devfn)) | PCIE_CONF_REG(where))
 
-#define PIO_TIMEOUT_MS			1
+#define PIO_RETRY_CNT			500
+#define PIO_RETRY_DELAY			2 /* 2 us*/
 
 #define LINK_WAIT_MAX_RETRIES		10
 #define LINK_WAIT_USLEEP_MIN		90000
@@ -413,23 +414,51 @@ static void advk_pcie_check_pio_status(struct advk_pcie *pcie)
 static int advk_pcie_wait_pio(struct advk_pcie *pcie)
 {
 	struct device *dev = &pcie->pdev->dev;
-	unsigned long timeout;
-
-	timeout = jiffies + msecs_to_jiffies(PIO_TIMEOUT_MS);
+	int i;
 
-	while (time_before(jiffies, timeout)) {
+	for (i = 0; i < PIO_RETRY_CNT; i++) {
 		u32 start, isr;
 
 		start = advk_readl(pcie, PIO_START);
 		isr = advk_readl(pcie, PIO_ISR);
 		if (!start && isr)
 			return 0;
+		udelay(PIO_RETRY_DELAY);
 	}
 
-	dev_err(dev, "config read/write timed out\n");
+	dev_err(dev, "PIO read/write transfer time out\n");
 	return -ETIMEDOUT;
 }
 
+static bool advk_pcie_pio_is_running(struct advk_pcie *pcie)
+{
+	struct device *dev = &pcie->pdev->dev;
+
+	/*
+	 * Trying to start a new PIO transfer when previous has not completed
+	 * cause External Abort on CPU which results in kernel panic:
+	 *
+	 *     SError Interrupt on CPU0, code 0xbf000002 -- SError
+	 *     Kernel panic - not syncing: Asynchronous SError Interrupt
+	 *
+	 * Functions advk_pcie_rd_conf() and advk_pcie_wr_conf() are protected
+	 * by raw_spin_lock_irqsave() at pci_lock_config() level to prevent
+	 * concurrent calls at the same time. But because PIO transfer may take
+	 * about 1.5s when link is down or card is disconnected, it means that
+	 * advk_pcie_wait_pio() does not always have to wait for completion.
+	 *
+	 * Some versions of ARM Trusted Firmware handles this External Abort at
+	 * EL3 level and mask it to prevent kernel panic. Relevant TF-A commit:
+	 * https://git.trustedfirmware.org/TF-A/trusted-firmware-a.git/commit/?id=3c7dcdac5c50
+	 */
+	if (advk_readl(pcie, PIO_START)) {
+		dev_err(dev, "Previous PIO read/write transfer is still running\n");
+		return true;
+	}
+
+	return false;
+}
+
 static int advk_pcie_rd_conf(struct pci_bus *bus, u32 devfn,
 			     int where, int size, u32 *val)
 {
@@ -442,9 +471,10 @@ static int advk_pcie_rd_conf(struct pci_bus *bus, u32 devfn,
 		return PCIBIOS_DEVICE_NOT_FOUND;
 	}
 
-	/* Start PIO */
-	advk_writel(pcie, 0, PIO_START);
-	advk_writel(pcie, 1, PIO_ISR);
+	if (advk_pcie_pio_is_running(pcie)) {
+		*val = 0xffffffff;
+		return PCIBIOS_SET_FAILED;
+	}
 
 	/* Program the control register */
 	reg = advk_readl(pcie, PIO_CTRL);
@@ -463,7 +493,8 @@ static int advk_pcie_rd_conf(struct pci_bus *bus, u32 devfn,
 	/* Program the data strobe */
 	advk_writel(pcie, 0xf, PIO_WR_DATA_STRB);
 
-	/* Start the transfer */
+	/* Clear PIO DONE ISR and start the transfer */
+	advk_writel(pcie, 1, PIO_ISR);
 	advk_writel(pcie, 1, PIO_START);
 
 	ret = advk_pcie_wait_pio(pcie);
@@ -497,9 +528,8 @@ static int advk_pcie_wr_conf(struct pci_bus *bus, u32 devfn,
 	if (where % size)
 		return PCIBIOS_SET_FAILED;
 
-	/* Start PIO */
-	advk_writel(pcie, 0, PIO_START);
-	advk_writel(pcie, 1, PIO_ISR);
+	if (advk_pcie_pio_is_running(pcie))
+		return PCIBIOS_SET_FAILED;
 
 	/* Program the control register */
 	reg = advk_readl(pcie, PIO_CTRL);
@@ -526,7 +556,8 @@ static int advk_pcie_wr_conf(struct pci_bus *bus, u32 devfn,
 	/* Program the data strobe */
 	advk_writel(pcie, data_strobe, PIO_WR_DATA_STRB);
 
-	/* Start the transfer */
+	/* Clear PIO DONE ISR and start the transfer */
+	advk_writel(pcie, 1, PIO_ISR);
 	advk_writel(pcie, 1, PIO_START);
 
 	ret = advk_pcie_wait_pio(pcie);
diff --git a/drivers/pci/pci-label.c b/drivers/pci/pci-label.c
index a961a71d950f..6beafc1bee96 100644
--- a/drivers/pci/pci-label.c
+++ b/drivers/pci/pci-label.c
@@ -161,7 +161,7 @@ static void dsm_label_utf16s_to_utf8s(union acpi_object *obj, char *buf)
 	len = utf16s_to_utf8s((const wchar_t *)obj->buffer.pointer,
 			      obj->buffer.length,
 			      UTF16_LITTLE_ENDIAN,
-			      buf, PAGE_SIZE);
+			      buf, PAGE_SIZE - 1);
 	buf[len] = '\n';
 }
 
diff --git a/drivers/phy/ti/phy-dm816x-usb.c b/drivers/phy/ti/phy-dm816x-usb.c
index cbcce7cf0028..2ed5fe20d779 100644
--- a/drivers/phy/ti/phy-dm816x-usb.c
+++ b/drivers/phy/ti/phy-dm816x-usb.c
@@ -246,19 +246,28 @@ static int dm816x_usb_phy_probe(struct platform_device *pdev)
 
 	pm_runtime_enable(phy->dev);
 	generic_phy = devm_phy_create(phy->dev, NULL, &ops);
-	if (IS_ERR(generic_phy))
-		return PTR_ERR(generic_phy);
+	if (IS_ERR(generic_phy)) {
+		error = PTR_ERR(generic_phy);
+		goto clk_unprepare;
+	}
 
 	phy_set_drvdata(generic_phy, phy);
 
 	phy_provider = devm_of_phy_provider_register(phy->dev,
 						     of_phy_simple_xlate);
-	if (IS_ERR(phy_provider))
-		return PTR_ERR(phy_provider);
+	if (IS_ERR(phy_provider)) {
+		error = PTR_ERR(phy_provider);
+		goto clk_unprepare;
+	}
 
 	usb_add_phy_dev(&phy->phy);
 
 	return 0;
+
+clk_unprepare:
+	pm_runtime_disable(phy->dev);
+	clk_unprepare(phy->refclk);
+	return error;
 }
 
 static int dm816x_usb_phy_remove(struct platform_device *pdev)
diff --git a/drivers/pinctrl/pinctrl-amd.c b/drivers/pinctrl/pinctrl-amd.c
index cfa4a833304a..34d9148d2766 100644
--- a/drivers/pinctrl/pinctrl-amd.c
+++ b/drivers/pinctrl/pinctrl-amd.c
@@ -920,6 +920,7 @@ static int amd_gpio_remove(struct platform_device *pdev)
 static const struct acpi_device_id amd_gpio_acpi_match[] = {
 	{ "AMD0030", 0 },
 	{ "AMDI0030", 0},
+	{ "AMDI0031", 0},
 	{ },
 };
 MODULE_DEVICE_TABLE(acpi, amd_gpio_acpi_match);
diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index 25955b4d80b0..61eccbb900e0 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -2861,6 +2861,7 @@ static int toshiba_acpi_setup_keyboard(struct toshiba_acpi_dev *dev)
 
 	if (!dev->info_supported && !dev->system_event_supported) {
 		pr_warn("No hotkey query interface found\n");
+		error = -EINVAL;
 		goto err_remove_filter;
 	}
 
diff --git a/drivers/power/reset/gpio-poweroff.c b/drivers/power/reset/gpio-poweroff.c
index be3d81ff51cc..a44e3427fdeb 100644
--- a/drivers/power/reset/gpio-poweroff.c
+++ b/drivers/power/reset/gpio-poweroff.c
@@ -84,6 +84,7 @@ static const struct of_device_id of_gpio_poweroff_match[] = {
 	{ .compatible = "gpio-poweroff", },
 	{},
 };
+MODULE_DEVICE_TABLE(of, of_gpio_poweroff_match);
 
 static struct platform_driver gpio_poweroff_driver = {
 	.probe = gpio_poweroff_probe,
diff --git a/drivers/power/supply/Kconfig b/drivers/power/supply/Kconfig
index 24163cf8612c..645908ccb710 100644
--- a/drivers/power/supply/Kconfig
+++ b/drivers/power/supply/Kconfig
@@ -596,7 +596,8 @@ config BATTERY_GOLDFISH
 
 config BATTERY_RT5033
 	tristate "RT5033 fuel gauge support"
-	depends on MFD_RT5033
+	depends on I2C
+	select REGMAP_I2C
 	help
 	  This adds support for battery fuel gauge in Richtek RT5033 PMIC.
 	  The fuelgauge calculates and determines the battery state of charge
diff --git a/drivers/power/supply/ab8500_btemp.c b/drivers/power/supply/ab8500_btemp.c
index f7a35ebfbab2..97423a04fc0f 100644
--- a/drivers/power/supply/ab8500_btemp.c
+++ b/drivers/power/supply/ab8500_btemp.c
@@ -1177,6 +1177,7 @@ static const struct of_device_id ab8500_btemp_match[] = {
 	{ .compatible = "stericsson,ab8500-btemp", },
 	{ },
 };
+MODULE_DEVICE_TABLE(of, ab8500_btemp_match);
 
 static struct platform_driver ab8500_btemp_driver = {
 	.probe = ab8500_btemp_probe,
diff --git a/drivers/power/supply/ab8500_charger.c b/drivers/power/supply/ab8500_charger.c
index 5a76c6d343de..fe2341e92be9 100644
--- a/drivers/power/supply/ab8500_charger.c
+++ b/drivers/power/supply/ab8500_charger.c
@@ -409,6 +409,14 @@ static void ab8500_enable_disable_sw_fallback(struct ab8500_charger *di,
 static void ab8500_power_supply_changed(struct ab8500_charger *di,
 					struct power_supply *psy)
 {
+	/*
+	 * This happens if we get notifications or interrupts and
+	 * the platform has been configured not to support one or
+	 * other type of charging.
+	 */
+	if (!psy)
+		return;
+
 	if (di->autopower_cfg) {
 		if (!di->usb.charger_connected &&
 		    !di->ac.charger_connected &&
@@ -435,7 +443,15 @@ static void ab8500_charger_set_usb_connected(struct ab8500_charger *di,
 		if (!connected)
 			di->flags.vbus_drop_end = false;
 
-		sysfs_notify(&di->usb_chg.psy->dev.kobj, NULL, "present");
+		/*
+		 * Sometimes the platform is configured not to support
+		 * USB charging and no psy has been created, but we still
+		 * will get these notifications.
+		 */
+		if (di->usb_chg.psy) {
+			sysfs_notify(&di->usb_chg.psy->dev.kobj, NULL,
+				     "present");
+		}
 
 		if (connected) {
 			mutex_lock(&di->charger_attached_mutex);
@@ -3736,6 +3752,7 @@ static const struct of_device_id ab8500_charger_match[] = {
 	{ .compatible = "stericsson,ab8500-charger", },
 	{ },
 };
+MODULE_DEVICE_TABLE(of, ab8500_charger_match);
 
 static struct platform_driver ab8500_charger_driver = {
 	.probe = ab8500_charger_probe,
diff --git a/drivers/power/supply/ab8500_fg.c b/drivers/power/supply/ab8500_fg.c
index b87768238b70..2677592ed7af 100644
--- a/drivers/power/supply/ab8500_fg.c
+++ b/drivers/power/supply/ab8500_fg.c
@@ -3229,6 +3229,7 @@ static const struct of_device_id ab8500_fg_match[] = {
 	{ .compatible = "stericsson,ab8500-fg", },
 	{ },
 };
+MODULE_DEVICE_TABLE(of, ab8500_fg_match);
 
 static struct platform_driver ab8500_fg_driver = {
 	.probe = ab8500_fg_probe,
diff --git a/drivers/power/supply/charger-manager.c b/drivers/power/supply/charger-manager.c
index f60dfc213257..5edd0824ef70 100644
--- a/drivers/power/supply/charger-manager.c
+++ b/drivers/power/supply/charger-manager.c
@@ -1484,6 +1484,7 @@ static const struct of_device_id charger_manager_match[] = {
 	},
 	{},
 };
+MODULE_DEVICE_TABLE(of, charger_manager_match);
 
 static struct charger_desc *of_cm_parse_desc(struct device *dev)
 {
diff --git a/drivers/power/supply/max17042_battery.c b/drivers/power/supply/max17042_battery.c
index 9c7eaaeda343..911d42366ef1 100644
--- a/drivers/power/supply/max17042_battery.c
+++ b/drivers/power/supply/max17042_battery.c
@@ -1051,7 +1051,7 @@ static int max17042_probe(struct i2c_client *client,
 	}
 
 	if (client->irq) {
-		unsigned int flags = IRQF_TRIGGER_FALLING | IRQF_ONESHOT;
+		unsigned int flags = IRQF_ONESHOT;
 
 		/*
 		 * On ACPI systems the IRQ may be handled by ACPI-event code,
diff --git a/drivers/power/supply/rt5033_battery.c b/drivers/power/supply/rt5033_battery.c
index bcdd83048492..9310b85f3405 100644
--- a/drivers/power/supply/rt5033_battery.c
+++ b/drivers/power/supply/rt5033_battery.c
@@ -167,9 +167,16 @@ static const struct i2c_device_id rt5033_battery_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, rt5033_battery_id);
 
+static const struct of_device_id rt5033_battery_of_match[] = {
+	{ .compatible = "richtek,rt5033-battery", },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, rt5033_battery_of_match);
+
 static struct i2c_driver rt5033_battery_driver = {
 	.driver = {
 		.name = "rt5033-battery",
+		.of_match_table = rt5033_battery_of_match,
 	},
 	.probe = rt5033_battery_probe,
 	.remove = rt5033_battery_remove,
diff --git a/drivers/pwm/pwm-spear.c b/drivers/pwm/pwm-spear.c
index 6c6b44fd3f43..2d11ac277de8 100644
--- a/drivers/pwm/pwm-spear.c
+++ b/drivers/pwm/pwm-spear.c
@@ -231,10 +231,6 @@ static int spear_pwm_probe(struct platform_device *pdev)
 static int spear_pwm_remove(struct platform_device *pdev)
 {
 	struct spear_pwm_chip *pc = platform_get_drvdata(pdev);
-	int i;
-
-	for (i = 0; i < NUM_PWM; i++)
-		pwm_disable(&pc->chip.pwms[i]);
 
 	/* clk was prepared in probe, hence unprepare it here */
 	clk_unprepare(pc->clk);
diff --git a/drivers/pwm/pwm-tegra.c b/drivers/pwm/pwm-tegra.c
index f8ebbece57b7..6be14e0f1dc3 100644
--- a/drivers/pwm/pwm-tegra.c
+++ b/drivers/pwm/pwm-tegra.c
@@ -245,7 +245,6 @@ static int tegra_pwm_probe(struct platform_device *pdev)
 static int tegra_pwm_remove(struct platform_device *pdev)
 {
 	struct tegra_pwm_chip *pc = platform_get_drvdata(pdev);
-	unsigned int i;
 	int err;
 
 	if (WARN_ON(!pc))
@@ -255,18 +254,6 @@ static int tegra_pwm_remove(struct platform_device *pdev)
 	if (err < 0)
 		return err;
 
-	for (i = 0; i < pc->chip.npwm; i++) {
-		struct pwm_device *pwm = &pc->chip.pwms[i];
-
-		if (!pwm_is_enabled(pwm))
-			if (clk_prepare_enable(pc->clk) < 0)
-				continue;
-
-		pwm_writel(pc, i, 0);
-
-		clk_disable_unprepare(pc->clk);
-	}
-
 	reset_control_assert(pc->rst);
 	clk_disable_unprepare(pc->clk);
 
diff --git a/drivers/regulator/da9052-regulator.c b/drivers/regulator/da9052-regulator.c
index 9ececfef42d6..bd91c95f73e0 100644
--- a/drivers/regulator/da9052-regulator.c
+++ b/drivers/regulator/da9052-regulator.c
@@ -258,7 +258,8 @@ static int da9052_regulator_set_voltage_time_sel(struct regulator_dev *rdev,
 	case DA9052_ID_BUCK3:
 	case DA9052_ID_LDO2:
 	case DA9052_ID_LDO3:
-		ret = (new_sel - old_sel) * info->step_uV / 6250;
+		ret = DIV_ROUND_UP(abs(new_sel - old_sel) * info->step_uV,
+				   6250);
 		break;
 	}
 
diff --git a/drivers/reset/core.c b/drivers/reset/core.c
index 7e0a14211c88..d941fb4050bb 100644
--- a/drivers/reset/core.c
+++ b/drivers/reset/core.c
@@ -398,7 +398,10 @@ static struct reset_control *__reset_control_get_internal(
 	if (!rstc)
 		return ERR_PTR(-ENOMEM);
 
-	try_module_get(rcdev->owner);
+	if (!try_module_get(rcdev->owner)) {
+		kfree(rstc);
+		return ERR_PTR(-ENODEV);
+	}
 
 	rstc->rcdev = rcdev;
 	list_add(&rstc->list, &rcdev->reset_control_head);
diff --git a/drivers/reset/reset-a10sr.c b/drivers/reset/reset-a10sr.c
index 37496bd27fa2..306fba5b3519 100644
--- a/drivers/reset/reset-a10sr.c
+++ b/drivers/reset/reset-a10sr.c
@@ -129,6 +129,7 @@ static struct platform_driver a10sr_reset_driver = {
 	.probe	= a10sr_reset_probe,
 	.driver = {
 		.name		= "altr_a10sr_reset",
+		.of_match_table	= a10sr_reset_of_match,
 	},
 };
 module_platform_driver(a10sr_reset_driver);
diff --git a/drivers/rtc/rtc-proc.c b/drivers/rtc/rtc-proc.c
index 31e7e23cc5be..9396b69f75e8 100644
--- a/drivers/rtc/rtc-proc.c
+++ b/drivers/rtc/rtc-proc.c
@@ -26,8 +26,8 @@ static bool is_rtc_hctosys(struct rtc_device *rtc)
 	int size;
 	char name[NAME_SIZE];
 
-	size = scnprintf(name, NAME_SIZE, "rtc%d", rtc->id);
-	if (size > NAME_SIZE)
+	size = snprintf(name, NAME_SIZE, "rtc%d", rtc->id);
+	if (size >= NAME_SIZE)
 		return false;
 
 	return !strncmp(name, CONFIG_RTC_HCTOSYS_DEVICE, NAME_SIZE);
diff --git a/drivers/rtc/rtc-stm32.c b/drivers/rtc/rtc-stm32.c
index 3a5c3d7d0c77..34e09f43ac95 100644
--- a/drivers/rtc/rtc-stm32.c
+++ b/drivers/rtc/rtc-stm32.c
@@ -636,7 +636,7 @@ static int stm32_rtc_probe(struct platform_device *pdev)
 	 */
 	ret = stm32_rtc_init(pdev, rtc);
 	if (ret)
-		goto err;
+		goto err_no_rtc_ck;
 
 	rtc->irq_alarm = platform_get_irq(pdev, 0);
 	if (rtc->irq_alarm <= 0) {
@@ -680,10 +680,12 @@ static int stm32_rtc_probe(struct platform_device *pdev)
 		dev_warn(&pdev->dev, "Date/Time must be initialized\n");
 
 	return 0;
+
 err:
+	clk_disable_unprepare(rtc->rtc_ck);
+err_no_rtc_ck:
 	if (rtc->data->has_pclk)
 		clk_disable_unprepare(rtc->pclk);
-	clk_disable_unprepare(rtc->rtc_ck);
 
 	regmap_update_bits(rtc->dbp, PWR_CR, PWR_CR_DBP, 0);
 
diff --git a/drivers/s390/char/sclp_vt220.c b/drivers/s390/char/sclp_vt220.c
index e84395d71389..0b9a83d51e2b 100644
--- a/drivers/s390/char/sclp_vt220.c
+++ b/drivers/s390/char/sclp_vt220.c
@@ -35,8 +35,8 @@
 #define SCLP_VT220_MINOR		65
 #define SCLP_VT220_DRIVER_NAME		"sclp_vt220"
 #define SCLP_VT220_DEVICE_NAME		"ttysclp"
-#define SCLP_VT220_CONSOLE_NAME		"ttyS"
-#define SCLP_VT220_CONSOLE_INDEX	1	/* console=ttyS1 */
+#define SCLP_VT220_CONSOLE_NAME		"ttysclp"
+#define SCLP_VT220_CONSOLE_INDEX	0	/* console=ttysclp0 */
 
 /* Representation of a single write request */
 struct sclp_vt220_request {
diff --git a/drivers/s390/cio/chp.c b/drivers/s390/cio/chp.c
index f4166f80c4d4..80859a55b90f 100644
--- a/drivers/s390/cio/chp.c
+++ b/drivers/s390/cio/chp.c
@@ -254,6 +254,9 @@ static ssize_t chp_status_write(struct device *dev,
 	if (!num_args)
 		return count;
 
+	/* Wait until previous actions have settled. */
+	css_wait_for_slow_path();
+
 	if (!strncasecmp(cmd, "on", 2) || !strcmp(cmd, "1")) {
 		mutex_lock(&cp->lock);
 		error = s390_vary_chpid(cp->chpid, 1);
diff --git a/drivers/s390/cio/chsc.c b/drivers/s390/cio/chsc.c
index 69687c16a150..2b8c3f1a45f3 100644
--- a/drivers/s390/cio/chsc.c
+++ b/drivers/s390/cio/chsc.c
@@ -769,8 +769,6 @@ int chsc_chp_vary(struct chp_id chpid, int on)
 {
 	struct channel_path *chp = chpid_to_chp(chpid);
 
-	/* Wait until previous actions have settled. */
-	css_wait_for_slow_path();
 	/*
 	 * Redo PathVerification on the devices the chpid connects to
 	 */
diff --git a/drivers/scsi/FlashPoint.c b/drivers/scsi/FlashPoint.c
index 867b864f5047..4bca37d52bad 100644
--- a/drivers/scsi/FlashPoint.c
+++ b/drivers/scsi/FlashPoint.c
@@ -40,7 +40,7 @@ struct sccb_mgr_info {
 	u16 si_per_targ_ultra_nego;
 	u16 si_per_targ_no_disc;
 	u16 si_per_targ_wide_nego;
-	u16 si_flags;
+	u16 si_mflags;
 	unsigned char si_card_family;
 	unsigned char si_bustype;
 	unsigned char si_card_model[3];
@@ -1070,22 +1070,22 @@ static int FlashPoint_ProbeHostAdapter(struct sccb_mgr_info *pCardInfo)
 		ScamFlg =
 		    (unsigned char)FPT_utilEERead(ioport, SCAM_CONFIG / 2);
 
-	pCardInfo->si_flags = 0x0000;
+	pCardInfo->si_mflags = 0x0000;
 
 	if (i & 0x01)
-		pCardInfo->si_flags |= SCSI_PARITY_ENA;
+		pCardInfo->si_mflags |= SCSI_PARITY_ENA;
 
 	if (!(i & 0x02))
-		pCardInfo->si_flags |= SOFT_RESET;
+		pCardInfo->si_mflags |= SOFT_RESET;
 
 	if (i & 0x10)
-		pCardInfo->si_flags |= EXTENDED_TRANSLATION;
+		pCardInfo->si_mflags |= EXTENDED_TRANSLATION;
 
 	if (ScamFlg & SCAM_ENABLED)
-		pCardInfo->si_flags |= FLAG_SCAM_ENABLED;
+		pCardInfo->si_mflags |= FLAG_SCAM_ENABLED;
 
 	if (ScamFlg & SCAM_LEVEL2)
-		pCardInfo->si_flags |= FLAG_SCAM_LEVEL2;
+		pCardInfo->si_mflags |= FLAG_SCAM_LEVEL2;
 
 	j = (RD_HARPOON(ioport + hp_bm_ctrl) & ~SCSI_TERM_ENA_L);
 	if (i & 0x04) {
@@ -1101,7 +1101,7 @@ static int FlashPoint_ProbeHostAdapter(struct sccb_mgr_info *pCardInfo)
 
 	if (!(RD_HARPOON(ioport + hp_page_ctrl) & NARROW_SCSI_CARD))
 
-		pCardInfo->si_flags |= SUPPORT_16TAR_32LUN;
+		pCardInfo->si_mflags |= SUPPORT_16TAR_32LUN;
 
 	pCardInfo->si_card_family = HARPOON_FAMILY;
 	pCardInfo->si_bustype = BUSTYPE_PCI;
@@ -1137,15 +1137,15 @@ static int FlashPoint_ProbeHostAdapter(struct sccb_mgr_info *pCardInfo)
 
 	if (pCardInfo->si_card_model[1] == '3') {
 		if (RD_HARPOON(ioport + hp_ee_ctrl) & BIT(7))
-			pCardInfo->si_flags |= LOW_BYTE_TERM;
+			pCardInfo->si_mflags |= LOW_BYTE_TERM;
 	} else if (pCardInfo->si_card_model[2] == '0') {
 		temp = RD_HARPOON(ioport + hp_xfer_pad);
 		WR_HARPOON(ioport + hp_xfer_pad, (temp & ~BIT(4)));
 		if (RD_HARPOON(ioport + hp_ee_ctrl) & BIT(7))
-			pCardInfo->si_flags |= LOW_BYTE_TERM;
+			pCardInfo->si_mflags |= LOW_BYTE_TERM;
 		WR_HARPOON(ioport + hp_xfer_pad, (temp | BIT(4)));
 		if (RD_HARPOON(ioport + hp_ee_ctrl) & BIT(7))
-			pCardInfo->si_flags |= HIGH_BYTE_TERM;
+			pCardInfo->si_mflags |= HIGH_BYTE_TERM;
 		WR_HARPOON(ioport + hp_xfer_pad, temp);
 	} else {
 		temp = RD_HARPOON(ioport + hp_ee_ctrl);
@@ -1163,9 +1163,9 @@ static int FlashPoint_ProbeHostAdapter(struct sccb_mgr_info *pCardInfo)
 		WR_HARPOON(ioport + hp_ee_ctrl, temp);
 		WR_HARPOON(ioport + hp_xfer_pad, temp2);
 		if (!(temp3 & BIT(7)))
-			pCardInfo->si_flags |= LOW_BYTE_TERM;
+			pCardInfo->si_mflags |= LOW_BYTE_TERM;
 		if (!(temp3 & BIT(6)))
-			pCardInfo->si_flags |= HIGH_BYTE_TERM;
+			pCardInfo->si_mflags |= HIGH_BYTE_TERM;
 	}
 
 	ARAM_ACCESS(ioport);
@@ -1272,7 +1272,7 @@ static void *FlashPoint_HardwareResetHostAdapter(struct sccb_mgr_info
 	WR_HARPOON(ioport + hp_arb_id, pCardInfo->si_id);
 	CurrCard->ourId = pCardInfo->si_id;
 
-	i = (unsigned char)pCardInfo->si_flags;
+	i = (unsigned char)pCardInfo->si_mflags;
 	if (i & SCSI_PARITY_ENA)
 		WR_HARPOON(ioport + hp_portctrl_1, (HOST_MODE8 | CHK_SCSI_P));
 
@@ -1286,14 +1286,14 @@ static void *FlashPoint_HardwareResetHostAdapter(struct sccb_mgr_info
 		j |= SCSI_TERM_ENA_H;
 	WR_HARPOON(ioport + hp_ee_ctrl, j);
 
-	if (!(pCardInfo->si_flags & SOFT_RESET)) {
+	if (!(pCardInfo->si_mflags & SOFT_RESET)) {
 
 		FPT_sresb(ioport, thisCard);
 
 		FPT_scini(thisCard, pCardInfo->si_id, 0);
 	}
 
-	if (pCardInfo->si_flags & POST_ALL_UNDERRRUNS)
+	if (pCardInfo->si_mflags & POST_ALL_UNDERRRUNS)
 		CurrCard->globalFlags |= F_NO_FILTER;
 
 	if (pCurrNvRam) {
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index b4542e7e2ad5..a1fd8a7fa48c 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -412,7 +412,7 @@ static struct beiscsi_hba *beiscsi_hba_alloc(struct pci_dev *pcidev)
 			"beiscsi_hba_alloc - iscsi_host_alloc failed\n");
 		return NULL;
 	}
-	shost->max_id = BE2_MAX_SESSIONS;
+	shost->max_id = BE2_MAX_SESSIONS - 1;
 	shost->max_channel = 0;
 	shost->max_cmd_len = BEISCSI_MAX_CMD_LEN;
 	shost->max_lun = BEISCSI_NUM_MAX_LUN;
@@ -5303,7 +5303,7 @@ static int beiscsi_enable_port(struct beiscsi_hba *phba)
 	/* Re-enable UER. If different TPE occurs then it is recoverable. */
 	beiscsi_set_uer_feature(phba);
 
-	phba->shost->max_id = phba->params.cxns_per_ctrl;
+	phba->shost->max_id = phba->params.cxns_per_ctrl - 1;
 	phba->shost->can_queue = phba->params.ios_per_ctrl;
 	ret = beiscsi_init_port(phba);
 	if (ret < 0) {
@@ -5737,6 +5737,7 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 	pci_disable_msix(phba->pcidev);
 	pci_dev_put(phba->pcidev);
 	iscsi_host_free(phba->shost);
+	pci_disable_pcie_error_reporting(pcidev);
 	pci_set_drvdata(pcidev, NULL);
 disable_pci:
 	pci_release_regions(pcidev);
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index b832bd0ce202..737fc2130e7d 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -793,7 +793,7 @@ struct bnx2i_hba *bnx2i_alloc_hba(struct cnic_dev *cnic)
 		return NULL;
 	shost->dma_boundary = cnic->pcidev->dma_mask;
 	shost->transportt = bnx2i_scsi_xport_template;
-	shost->max_id = ISCSI_MAX_CONNS_PER_HBA;
+	shost->max_id = ISCSI_MAX_CONNS_PER_HBA - 1;
 	shost->max_channel = 0;
 	shost->max_lun = 512;
 	shost->max_cmd_len = 16;
diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index 0d45658f163a..5bc343af58a1 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -339,7 +339,7 @@ void cxgbi_hbas_remove(struct cxgbi_device *cdev)
 EXPORT_SYMBOL_GPL(cxgbi_hbas_remove);
 
 int cxgbi_hbas_add(struct cxgbi_device *cdev, u64 max_lun,
-		unsigned int max_id, struct scsi_host_template *sht,
+		unsigned int max_conns, struct scsi_host_template *sht,
 		struct scsi_transport_template *stt)
 {
 	struct cxgbi_hba *chba;
@@ -359,7 +359,7 @@ int cxgbi_hbas_add(struct cxgbi_device *cdev, u64 max_lun,
 
 		shost->transportt = stt;
 		shost->max_lun = max_lun;
-		shost->max_id = max_id;
+		shost->max_id = max_conns - 1;
 		shost->max_channel = 0;
 		shost->max_cmd_len = 16;
 
diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 5788a2ce3571..ec976b93341c 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -213,6 +213,9 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 		goto fail;
 	}
 
+	shost->cmd_per_lun = min_t(short, shost->cmd_per_lun,
+				   shost->can_queue);
+
 	error = scsi_init_sense_cache(shost);
 	if (error)
 		goto fail;
@@ -499,6 +502,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 		shost_printk(KERN_WARNING, shost,
 			"error handler thread failed to spawn, error = %ld\n",
 			PTR_ERR(shost->ehandler));
+		shost->ehandler = NULL;
 		goto fail;
 	}
 
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 21efe27ebfcc..f3dfec02abec 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1385,7 +1385,6 @@ void iscsi_session_failure(struct iscsi_session *session,
 			   enum iscsi_err err)
 {
 	struct iscsi_conn *conn;
-	struct device *dev;
 
 	spin_lock_bh(&session->frwd_lock);
 	conn = session->leadconn;
@@ -1394,10 +1393,8 @@ void iscsi_session_failure(struct iscsi_session *session,
 		return;
 	}
 
-	dev = get_device(&conn->cls_conn->dev);
+	iscsi_get_conn(conn->cls_conn);
 	spin_unlock_bh(&session->frwd_lock);
-	if (!dev)
-	        return;
 	/*
 	 * if the host is being removed bypass the connection
 	 * recovery initialization because we are going to kill
@@ -1407,7 +1404,7 @@ void iscsi_session_failure(struct iscsi_session *session,
 		iscsi_conn_error_event(conn->cls_conn, err);
 	else
 		iscsi_conn_failure(conn, err);
-	put_device(dev);
+	iscsi_put_conn(conn->cls_conn);
 }
 EXPORT_SYMBOL_GPL(iscsi_session_failure);
 
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 566e8d07cb05..8dc60961e47e 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1170,6 +1170,15 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			phba->fcf.fcf_redisc_attempted = 0; /* reset */
 			goto out;
 		}
+	} else if (vport->port_state > LPFC_FLOGI &&
+		   vport->fc_flag & FC_PT2PT) {
+		/*
+		 * In a p2p topology, it is possible that discovery has
+		 * already progressed, and this completion can be ignored.
+		 * Recheck the indicated topology.
+		 */
+		if (!sp->cmn.fPort)
+			goto out;
 	}
 
 flogifail:
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 27578816d852..20deb6715c36 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -7032,7 +7032,7 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 				"0393 Error %d during rpi post operation\n",
 				rc);
 		rc = -ENODEV;
-		goto out_destroy_queue;
+		goto out_free_iocblist;
 	}
 	lpfc_sli4_node_prep(phba);
 
@@ -7157,8 +7157,9 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 out_unset_queue:
 	/* Unset all the queues set up in this routine when error out */
 	lpfc_sli4_queue_unset(phba);
-out_destroy_queue:
+out_free_iocblist:
 	lpfc_free_iocb_list(phba);
+out_destroy_queue:
 	lpfc_sli4_queue_destroy(phba);
 out_stop_timers:
 	lpfc_stop_hba_timers(phba);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 400c055167b0..332ea3af69ec 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -5236,8 +5236,10 @@ _scsih_expander_add(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 	    handle, parent_handle, (unsigned long long)
 	    sas_expander->sas_address, sas_expander->num_phys);
 
-	if (!sas_expander->num_phys)
+	if (!sas_expander->num_phys) {
+		rc = -1;
 		goto out_fail;
+	}
 	sas_expander->phy = kcalloc(sas_expander->num_phys,
 	    sizeof(struct _sas_phy), GFP_KERNEL);
 	if (!sas_expander->phy) {
diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index e8f2c662471e..662444bb67f6 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -1474,7 +1474,7 @@ static void qedi_tmf_work(struct work_struct *work)
 
 ldel_exit:
 	spin_lock_bh(&qedi_conn->tmf_work_lock);
-	if (!qedi_cmd->list_tmf_work) {
+	if (qedi_cmd->list_tmf_work) {
 		list_del_init(&list_work->list);
 		qedi_cmd->list_tmf_work = NULL;
 		kfree(list_work);
diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index b0a404d4e676..06958a192a5b 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -628,7 +628,7 @@ static struct qedi_ctx *qedi_host_alloc(struct pci_dev *pdev)
 		goto exit_setup_shost;
 	}
 
-	shost->max_id = QEDI_MAX_ISCSI_CONNS_PER_HBA;
+	shost->max_id = QEDI_MAX_ISCSI_CONNS_PER_HBA - 1;
 	shost->max_channel = 0;
 	shost->max_lun = ~0;
 	shost->max_cmd_len = 16;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 6e0981b09c58..fccda61e768c 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -971,6 +971,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 				case 0x07: /* operation in progress */
 				case 0x08: /* Long write in progress */
 				case 0x09: /* self test in progress */
+				case 0x11: /* notify (enable spinup) required */
 				case 0x14: /* space allocation in progress */
 					action = ACTION_DELAYED_RETRY;
 					break;
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index d385eddb1a43..95c61fb4b81b 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2306,6 +2306,18 @@ int iscsi_destroy_conn(struct iscsi_cls_conn *conn)
 }
 EXPORT_SYMBOL_GPL(iscsi_destroy_conn);
 
+void iscsi_put_conn(struct iscsi_cls_conn *conn)
+{
+	put_device(&conn->dev);
+}
+EXPORT_SYMBOL_GPL(iscsi_put_conn);
+
+void iscsi_get_conn(struct iscsi_cls_conn *conn)
+{
+	get_device(&conn->dev);
+}
+EXPORT_SYMBOL_GPL(iscsi_get_conn);
+
 /*
  * iscsi interface functions
  */
diff --git a/drivers/spi/spi-loopback-test.c b/drivers/spi/spi-loopback-test.c
index b9a7117b6dce..85d3475915dd 100644
--- a/drivers/spi/spi-loopback-test.c
+++ b/drivers/spi/spi-loopback-test.c
@@ -877,7 +877,7 @@ static int spi_test_run_iter(struct spi_device *spi,
 		test.transfers[i].len = len;
 		if (test.transfers[i].tx_buf)
 			test.transfers[i].tx_buf += tx_off;
-		if (test.transfers[i].tx_buf)
+		if (test.transfers[i].rx_buf)
 			test.transfers[i].rx_buf += rx_off;
 	}
 
diff --git a/drivers/spi/spi-omap-100k.c b/drivers/spi/spi-omap-100k.c
index 1eccdc4a4581..2eeb0fe2eed2 100644
--- a/drivers/spi/spi-omap-100k.c
+++ b/drivers/spi/spi-omap-100k.c
@@ -251,7 +251,7 @@ static int omap1_spi100k_setup_transfer(struct spi_device *spi,
 	else
 		word_len = spi->bits_per_word;
 
-	if (spi->bits_per_word > 32)
+	if (word_len > 32)
 		return -EINVAL;
 	cs->word_len = word_len;
 
diff --git a/drivers/spi/spi-sun6i.c b/drivers/spi/spi-sun6i.c
index 21a22d42818c..ef62366899ad 100644
--- a/drivers/spi/spi-sun6i.c
+++ b/drivers/spi/spi-sun6i.c
@@ -301,6 +301,10 @@ static int sun6i_spi_transfer_one(struct spi_master *master,
 	}
 
 	sun6i_spi_write(sspi, SUN6I_CLK_CTL_REG, reg);
+	/* Finally enable the bus - doing so before might raise SCK to HIGH */
+	reg = sun6i_spi_read(sspi, SUN6I_GBL_CTL_REG);
+	reg |= SUN6I_GBL_CTL_BUS_ENABLE;
+	sun6i_spi_write(sspi, SUN6I_GBL_CTL_REG, reg);
 
 	/* Setup the transfer now... */
 	if (sspi->tx_buf)
@@ -409,7 +413,7 @@ static int sun6i_spi_runtime_resume(struct device *dev)
 	}
 
 	sun6i_spi_write(sspi, SUN6I_GBL_CTL_REG,
-			SUN6I_GBL_CTL_BUS_ENABLE | SUN6I_GBL_CTL_MASTER | SUN6I_GBL_CTL_TP);
+			SUN6I_GBL_CTL_MASTER | SUN6I_GBL_CTL_TP);
 
 	return 0;
 
diff --git a/drivers/spi/spi-topcliff-pch.c b/drivers/spi/spi-topcliff-pch.c
index fa730a871d25..f3ffcb9ce5e3 100644
--- a/drivers/spi/spi-topcliff-pch.c
+++ b/drivers/spi/spi-topcliff-pch.c
@@ -585,8 +585,10 @@ static void pch_spi_set_tx(struct pch_spi_data *data, int *bpw)
 	data->pkt_tx_buff = kzalloc(size, GFP_KERNEL);
 	if (data->pkt_tx_buff != NULL) {
 		data->pkt_rx_buff = kzalloc(size, GFP_KERNEL);
-		if (!data->pkt_rx_buff)
+		if (!data->pkt_rx_buff) {
 			kfree(data->pkt_tx_buff);
+			data->pkt_tx_buff = NULL;
+		}
 	}
 
 	if (!data->pkt_rx_buff) {
diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index da71a53b0df7..71f74015efb9 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1670,6 +1670,7 @@ of_register_spi_device(struct spi_controller *ctlr, struct device_node *nc)
 	/* Store a pointer to the node in the device structure */
 	of_node_get(nc);
 	spi->dev.of_node = nc;
+	spi->dev.fwnode = of_fwnode_handle(nc);
 
 	/* Register the new device */
 	rc = spi_add_device(spi);
diff --git a/drivers/ssb/sdio.c b/drivers/ssb/sdio.c
index 2278e43614bd..5e10514ef80c 100644
--- a/drivers/ssb/sdio.c
+++ b/drivers/ssb/sdio.c
@@ -411,7 +411,6 @@ static void ssb_sdio_block_write(struct ssb_device *dev, const void *buffer,
 	sdio_claim_host(bus->host_sdio);
 	if (unlikely(ssb_sdio_switch_core(bus, dev))) {
 		error = -EIO;
-		memset((void *)buffer, 0xff, count);
 		goto err_out;
 	}
 	offset |= bus->sdio_sbaddr & 0xffff;
diff --git a/drivers/staging/gdm724x/gdm_lte.c b/drivers/staging/gdm724x/gdm_lte.c
index 9ab6ce231f11..ed0c5fd2d640 100644
--- a/drivers/staging/gdm724x/gdm_lte.c
+++ b/drivers/staging/gdm724x/gdm_lte.c
@@ -614,10 +614,12 @@ static void gdm_lte_netif_rx(struct net_device *dev, char *buf,
 						  * bytes (99,130,83,99 dec)
 						  */
 			} __packed;
-			void *addr = buf + sizeof(struct iphdr) +
-				sizeof(struct udphdr) +
-				offsetof(struct dhcp_packet, chaddr);
-			ether_addr_copy(nic->dest_mac_addr, addr);
+			int offset = sizeof(struct iphdr) +
+				     sizeof(struct udphdr) +
+				     offsetof(struct dhcp_packet, chaddr);
+			if (offset + ETH_ALEN > len)
+				return;
+			ether_addr_copy(nic->dest_mac_addr, buf + offset);
 		}
 	}
 
@@ -680,6 +682,7 @@ static void gdm_lte_multi_sdu_pkt(struct phy_dev *phy_dev, char *buf, int len)
 	struct sdu *sdu = NULL;
 	struct gdm_endian *endian = phy_dev->get_endian(phy_dev->priv_dev);
 	u8 *data = (u8 *)multi_sdu->data;
+	int copied;
 	u16 i = 0;
 	u16 num_packet;
 	u16 hci_len;
@@ -691,6 +694,12 @@ static void gdm_lte_multi_sdu_pkt(struct phy_dev *phy_dev, char *buf, int len)
 	num_packet = gdm_dev16_to_cpu(endian, multi_sdu->num_packet);
 
 	for (i = 0; i < num_packet; i++) {
+		copied = data - multi_sdu->data;
+		if (len < copied + sizeof(*sdu)) {
+			pr_err("rx prevent buffer overflow");
+			return;
+		}
+
 		sdu = (struct sdu *)data;
 
 		cmd_evt  = gdm_dev16_to_cpu(endian, sdu->cmd_evt);
@@ -701,7 +710,8 @@ static void gdm_lte_multi_sdu_pkt(struct phy_dev *phy_dev, char *buf, int len)
 			pr_err("rx sdu wrong hci %04x\n", cmd_evt);
 			return;
 		}
-		if (hci_len < 12) {
+		if (hci_len < 12 ||
+		    len < copied + sizeof(*sdu) + (hci_len - 12)) {
 			pr_err("rx sdu invalid len %d\n", hci_len);
 			return;
 		}
diff --git a/drivers/staging/rtl8723bs/hal/odm.h b/drivers/staging/rtl8723bs/hal/odm.h
index 87a76bafecb3..7424c25b52ce 100644
--- a/drivers/staging/rtl8723bs/hal/odm.h
+++ b/drivers/staging/rtl8723bs/hal/odm.h
@@ -209,10 +209,7 @@ typedef struct _ODM_RATE_ADAPTIVE {
 
 #define AVG_THERMAL_NUM		8
 #define IQK_Matrix_REG_NUM	8
-#define IQK_Matrix_Settings_NUM	(14 + 24 + 21) /*   Channels_2_4G_NUM
-						* + Channels_5G_20M_NUM
-						* + Channels_5G
-						*/
+#define IQK_Matrix_Settings_NUM	14 /* Channels_2_4G_NUM */
 
 #define		DM_Type_ByFW			0
 #define		DM_Type_ByDriver		1
diff --git a/drivers/tty/nozomi.c b/drivers/tty/nozomi.c
index 39b3723a32a6..0c424624a00c 100644
--- a/drivers/tty/nozomi.c
+++ b/drivers/tty/nozomi.c
@@ -1416,7 +1416,7 @@ static int nozomi_card_init(struct pci_dev *pdev,
 			NOZOMI_NAME, dc);
 	if (unlikely(ret)) {
 		dev_err(&pdev->dev, "can't request irq %d\n", pdev->irq);
-		goto err_free_kfifo;
+		goto err_free_all_kfifo;
 	}
 
 	DBG1("base_addr: %p", dc->base_addr);
@@ -1454,12 +1454,15 @@ static int nozomi_card_init(struct pci_dev *pdev,
 	return 0;
 
 err_free_tty:
-	for (i = 0; i < MAX_PORT; ++i) {
+	for (i--; i >= 0; i--) {
 		tty_unregister_device(ntty_driver, dc->index_start + i);
 		tty_port_destroy(&dc->port[i].port);
 	}
+	free_irq(pdev->irq, dc);
+err_free_all_kfifo:
+	i = MAX_PORT;
 err_free_kfifo:
-	for (i = 0; i < MAX_PORT; i++)
+	for (i--; i >= PORT_MDM; i--)
 		kfifo_free(&dc->port[i].fifo_ul);
 err_free_sbuf:
 	kfree(dc->send_buf);
diff --git a/drivers/tty/serial/8250/serial_cs.c b/drivers/tty/serial/8250/serial_cs.c
index 8106353ce7aa..3747991024d5 100644
--- a/drivers/tty/serial/8250/serial_cs.c
+++ b/drivers/tty/serial/8250/serial_cs.c
@@ -305,6 +305,7 @@ static int serial_resume(struct pcmcia_device *link)
 static int serial_probe(struct pcmcia_device *link)
 {
 	struct serial_info *info;
+	int ret;
 
 	dev_dbg(&link->dev, "serial_attach()\n");
 
@@ -319,7 +320,15 @@ static int serial_probe(struct pcmcia_device *link)
 	if (do_sound)
 		link->config_flags |= CONF_ENABLE_SPKR;
 
-	return serial_config(link);
+	ret = serial_config(link);
+	if (ret)
+		goto free_info;
+
+	return 0;
+
+free_info:
+	kfree(info);
+	return ret;
 }
 
 static void serial_detach(struct pcmcia_device *link)
@@ -779,6 +788,7 @@ static const struct pcmcia_device_id serial_ids[] = {
 	PCMCIA_DEVICE_PROD_ID12("Multi-Tech", "MT2834LT", 0x5f73be51, 0x4cd7c09e),
 	PCMCIA_DEVICE_PROD_ID12("OEM      ", "C288MX     ", 0xb572d360, 0xd2385b7a),
 	PCMCIA_DEVICE_PROD_ID12("Option International", "V34bis GSM/PSTN Data/Fax Modem", 0x9d7cd6f5, 0x5cb8bf41),
+	PCMCIA_DEVICE_PROD_ID12("Option International", "GSM-Ready 56K/ISDN", 0x9d7cd6f5, 0xb23844aa),
 	PCMCIA_DEVICE_PROD_ID12("PCMCIA   ", "C336MX     ", 0x99bcafe9, 0xaa25bcab),
 	PCMCIA_DEVICE_PROD_ID12("Quatech Inc", "PCMCIA Dual RS-232 Serial Port Card", 0xc4420b35, 0x92abc92f),
 	PCMCIA_DEVICE_PROD_ID12("Quatech Inc", "Dual RS-232 Serial Port PC Card", 0xc4420b35, 0x031a380d),
@@ -806,7 +816,6 @@ static const struct pcmcia_device_id serial_ids[] = {
 	PCMCIA_DEVICE_CIS_PROD_ID12("ADVANTECH", "COMpad-32/85B-4", 0x96913a85, 0xcec8f102, "cis/COMpad4.cis"),
 	PCMCIA_DEVICE_CIS_PROD_ID123("ADVANTECH", "COMpad-32/85", "1.0", 0x96913a85, 0x8fbe92ae, 0x0877b627, "cis/COMpad2.cis"),
 	PCMCIA_DEVICE_CIS_PROD_ID2("RS-COM 2P", 0xad20b156, "cis/RS-COM-2P.cis"),
-	PCMCIA_DEVICE_CIS_MANF_CARD(0x0013, 0x0000, "cis/GLOBETROTTER.cis"),
 	PCMCIA_DEVICE_PROD_ID12("ELAN DIGITAL SYSTEMS LTD, c1997.", "SERIAL CARD: SL100  1.00.", 0x19ca78af, 0xf964f42b),
 	PCMCIA_DEVICE_PROD_ID12("ELAN DIGITAL SYSTEMS LTD, c1997.", "SERIAL CARD: SL100", 0x19ca78af, 0x71d98e83),
 	PCMCIA_DEVICE_PROD_ID12("ELAN DIGITAL SYSTEMS LTD, c1997.", "SERIAL CARD: SL232  1.00.", 0x19ca78af, 0x69fb7490),
diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index cebebdcd091c..3d5fe53988e5 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -1998,6 +1998,9 @@ lpuart32_console_get_options(struct lpuart_port *sport, int *baud,
 
 	bd = lpuart32_read(&sport->port, UARTBAUD);
 	bd &= UARTBAUD_SBR_MASK;
+	if (!bd)
+		return;
+
 	sbr = bd;
 	uartclk = clk_get_rate(sport->clk);
 	/*
diff --git a/drivers/tty/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c
index 3a2e312039a4..21f81dc08139 100644
--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -581,6 +581,14 @@ static void sci_stop_tx(struct uart_port *port)
 	ctrl &= ~SCSCR_TIE;
 
 	serial_port_out(port, SCSCR, ctrl);
+
+#ifdef CONFIG_SERIAL_SH_SCI_DMA
+	if (to_sci_port(port)->chan_tx &&
+	    !dma_submit_error(to_sci_port(port)->cookie_tx)) {
+		dmaengine_terminate_async(to_sci_port(port)->chan_tx);
+		to_sci_port(port)->cookie_tx = -EINVAL;
+	}
+#endif
 }
 
 static void sci_start_rx(struct uart_port *port)
diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index fbf7cb8d34e7..bd9a11782e15 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -2014,6 +2014,11 @@ static const struct usb_device_id acm_ids[] = {
 	.driver_info = IGNORE_DEVICE,
 	},
 
+	/* Exclude Heimann Sensor GmbH USB appset demo */
+	{ USB_DEVICE(0x32a7, 0x0000),
+	.driver_info = IGNORE_DEVICE,
+	},
+
 	/* control interfaces without any protocol set */
 	{ USB_INTERFACE_INFO(USB_CLASS_COMM, USB_CDC_SUBCLASS_ACM,
 		USB_CDC_PROTO_NONE) },
diff --git a/drivers/usb/gadget/function/f_eem.c b/drivers/usb/gadget/function/f_eem.c
index 5abc27f12a41..b8fcc202e0a3 100644
--- a/drivers/usb/gadget/function/f_eem.c
+++ b/drivers/usb/gadget/function/f_eem.c
@@ -34,6 +34,11 @@ struct f_eem {
 	u8				ctrl_id;
 };
 
+struct in_context {
+	struct sk_buff	*skb;
+	struct usb_ep	*ep;
+};
+
 static inline struct f_eem *func_to_eem(struct usb_function *f)
 {
 	return container_of(f, struct f_eem, port.func);
@@ -327,9 +332,12 @@ static int eem_bind(struct usb_configuration *c, struct usb_function *f)
 
 static void eem_cmd_complete(struct usb_ep *ep, struct usb_request *req)
 {
-	struct sk_buff *skb = (struct sk_buff *)req->context;
+	struct in_context *ctx = req->context;
 
-	dev_kfree_skb_any(skb);
+	dev_kfree_skb_any(ctx->skb);
+	kfree(req->buf);
+	usb_ep_free_request(ctx->ep, req);
+	kfree(ctx);
 }
 
 /*
@@ -417,7 +425,9 @@ static int eem_unwrap(struct gether *port,
 		 * b15:		bmType (0 == data, 1 == command)
 		 */
 		if (header & BIT(15)) {
-			struct usb_request	*req = cdev->req;
+			struct usb_request	*req;
+			struct in_context	*ctx;
+			struct usb_ep		*ep;
 			u16			bmEEMCmd;
 
 			/* EEM command packet format:
@@ -446,11 +456,36 @@ static int eem_unwrap(struct gether *port,
 				skb_trim(skb2, len);
 				put_unaligned_le16(BIT(15) | BIT(11) | len,
 							skb_push(skb2, 2));
+
+				ep = port->in_ep;
+				req = usb_ep_alloc_request(ep, GFP_ATOMIC);
+				if (!req) {
+					dev_kfree_skb_any(skb2);
+					goto next;
+				}
+
+				req->buf = kmalloc(skb2->len, GFP_KERNEL);
+				if (!req->buf) {
+					usb_ep_free_request(ep, req);
+					dev_kfree_skb_any(skb2);
+					goto next;
+				}
+
+				ctx = kmalloc(sizeof(*ctx), GFP_KERNEL);
+				if (!ctx) {
+					kfree(req->buf);
+					usb_ep_free_request(ep, req);
+					dev_kfree_skb_any(skb2);
+					goto next;
+				}
+				ctx->skb = skb2;
+				ctx->ep = ep;
+
 				skb_copy_bits(skb2, 0, req->buf, skb2->len);
 				req->length = skb2->len;
 				req->complete = eem_cmd_complete;
 				req->zero = 1;
-				req->context = skb2;
+				req->context = ctx;
 				if (usb_ep_queue(port->in_ep, req, GFP_ATOMIC))
 					DBG(cdev, "echo response queue fail\n");
 				break;
diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 458c5dc296ac..5dfe926c251a 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -247,8 +247,8 @@ EXPORT_SYMBOL_GPL(ffs_lock);
 static struct ffs_dev *_ffs_find_dev(const char *name);
 static struct ffs_dev *_ffs_alloc_dev(void);
 static void _ffs_free_dev(struct ffs_dev *dev);
-static void *ffs_acquire_dev(const char *dev_name);
-static void ffs_release_dev(struct ffs_data *ffs_data);
+static int ffs_acquire_dev(const char *dev_name, struct ffs_data *ffs_data);
+static void ffs_release_dev(struct ffs_dev *ffs_dev);
 static int ffs_ready(struct ffs_data *ffs);
 static void ffs_closed(struct ffs_data *ffs);
 
@@ -1505,7 +1505,6 @@ ffs_fs_mount(struct file_system_type *t, int flags,
 	};
 	struct dentry *rv;
 	int ret;
-	void *ffs_dev;
 	struct ffs_data	*ffs;
 
 	ENTER();
@@ -1526,19 +1525,16 @@ ffs_fs_mount(struct file_system_type *t, int flags,
 		return ERR_PTR(-ENOMEM);
 	}
 
-	ffs_dev = ffs_acquire_dev(dev_name);
-	if (IS_ERR(ffs_dev)) {
+	ret = ffs_acquire_dev(dev_name, ffs);
+	if (ret) {
 		ffs_data_put(ffs);
-		return ERR_CAST(ffs_dev);
+		return ERR_PTR(ret);
 	}
-	ffs->private_data = ffs_dev;
 	data.ffs_data = ffs;
 
 	rv = mount_nodev(t, flags, &data, ffs_sb_fill);
-	if (IS_ERR(rv) && data.ffs_data) {
-		ffs_release_dev(data.ffs_data);
+	if (IS_ERR(rv) && data.ffs_data)
 		ffs_data_put(data.ffs_data);
-	}
 	return rv;
 }
 
@@ -1548,10 +1544,8 @@ ffs_fs_kill_sb(struct super_block *sb)
 	ENTER();
 
 	kill_litter_super(sb);
-	if (sb->s_fs_info) {
-		ffs_release_dev(sb->s_fs_info);
+	if (sb->s_fs_info)
 		ffs_data_closed(sb->s_fs_info);
-	}
 }
 
 static struct file_system_type ffs_fs_type = {
@@ -1620,6 +1614,7 @@ static void ffs_data_put(struct ffs_data *ffs)
 	if (unlikely(refcount_dec_and_test(&ffs->ref))) {
 		pr_info("%s(): freeing\n", __func__);
 		ffs_data_clear(ffs);
+		ffs_release_dev(ffs->private_data);
 		BUG_ON(waitqueue_active(&ffs->ev.waitq) ||
 		       waitqueue_active(&ffs->ep0req_completion.wait) ||
 		       waitqueue_active(&ffs->wait));
@@ -2924,6 +2919,7 @@ static inline struct f_fs_opts *ffs_do_functionfs_bind(struct usb_function *f,
 	struct ffs_function *func = ffs_func_from_usb(f);
 	struct f_fs_opts *ffs_opts =
 		container_of(f->fi, struct f_fs_opts, func_inst);
+	struct ffs_data *ffs_data;
 	int ret;
 
 	ENTER();
@@ -2938,12 +2934,13 @@ static inline struct f_fs_opts *ffs_do_functionfs_bind(struct usb_function *f,
 	if (!ffs_opts->no_configfs)
 		ffs_dev_lock();
 	ret = ffs_opts->dev->desc_ready ? 0 : -ENODEV;
-	func->ffs = ffs_opts->dev->ffs_data;
+	ffs_data = ffs_opts->dev->ffs_data;
 	if (!ffs_opts->no_configfs)
 		ffs_dev_unlock();
 	if (ret)
 		return ERR_PTR(ret);
 
+	func->ffs = ffs_data;
 	func->conf = c;
 	func->gadget = c->cdev->gadget;
 
@@ -3398,6 +3395,7 @@ static void ffs_free_inst(struct usb_function_instance *f)
 	struct f_fs_opts *opts;
 
 	opts = to_f_fs_opts(f);
+	ffs_release_dev(opts->dev);
 	ffs_dev_lock();
 	_ffs_free_dev(opts->dev);
 	ffs_dev_unlock();
@@ -3585,47 +3583,48 @@ static void _ffs_free_dev(struct ffs_dev *dev)
 {
 	list_del(&dev->entry);
 
-	/* Clear the private_data pointer to stop incorrect dev access */
-	if (dev->ffs_data)
-		dev->ffs_data->private_data = NULL;
-
 	kfree(dev);
 	if (list_empty(&ffs_devices))
 		functionfs_cleanup();
 }
 
-static void *ffs_acquire_dev(const char *dev_name)
+static int ffs_acquire_dev(const char *dev_name, struct ffs_data *ffs_data)
 {
+	int ret = 0;
 	struct ffs_dev *ffs_dev;
 
 	ENTER();
 	ffs_dev_lock();
 
 	ffs_dev = _ffs_find_dev(dev_name);
-	if (!ffs_dev)
-		ffs_dev = ERR_PTR(-ENOENT);
-	else if (ffs_dev->mounted)
-		ffs_dev = ERR_PTR(-EBUSY);
-	else if (ffs_dev->ffs_acquire_dev_callback &&
-	    ffs_dev->ffs_acquire_dev_callback(ffs_dev))
-		ffs_dev = ERR_PTR(-ENOENT);
-	else
+	if (!ffs_dev) {
+		ret = -ENOENT;
+	} else if (ffs_dev->mounted) {
+		ret = -EBUSY;
+	} else if (ffs_dev->ffs_acquire_dev_callback &&
+		   ffs_dev->ffs_acquire_dev_callback(ffs_dev)) {
+		ret = -ENOENT;
+	} else {
 		ffs_dev->mounted = true;
+		ffs_dev->ffs_data = ffs_data;
+		ffs_data->private_data = ffs_dev;
+	}
 
 	ffs_dev_unlock();
-	return ffs_dev;
+	return ret;
 }
 
-static void ffs_release_dev(struct ffs_data *ffs_data)
+static void ffs_release_dev(struct ffs_dev *ffs_dev)
 {
-	struct ffs_dev *ffs_dev;
-
 	ENTER();
 	ffs_dev_lock();
 
-	ffs_dev = ffs_data->private_data;
-	if (ffs_dev) {
+	if (ffs_dev && ffs_dev->mounted) {
 		ffs_dev->mounted = false;
+		if (ffs_dev->ffs_data) {
+			ffs_dev->ffs_data->private_data = NULL;
+			ffs_dev->ffs_data = NULL;
+		}
 
 		if (ffs_dev->ffs_release_dev_callback)
 			ffs_dev->ffs_release_dev_callback(ffs_dev);
@@ -3653,7 +3652,6 @@ static int ffs_ready(struct ffs_data *ffs)
 	}
 
 	ffs_obj->desc_ready = true;
-	ffs_obj->ffs_data = ffs;
 
 	if (ffs_obj->ffs_ready_callback) {
 		ret = ffs_obj->ffs_ready_callback(ffs);
@@ -3681,7 +3679,6 @@ static void ffs_closed(struct ffs_data *ffs)
 		goto done;
 
 	ffs_obj->desc_ready = false;
-	ffs_obj->ffs_data = NULL;
 
 	if (test_and_clear_bit(FFS_FL_CALL_CLOSED_CALLBACK, &ffs->flags) &&
 	    ffs_obj->ffs_closed_callback)
diff --git a/drivers/usb/gadget/function/f_hid.c b/drivers/usb/gadget/function/f_hid.c
index 77d1183775ef..e9b772a9902b 100644
--- a/drivers/usb/gadget/function/f_hid.c
+++ b/drivers/usb/gadget/function/f_hid.c
@@ -92,7 +92,7 @@ static struct usb_interface_descriptor hidg_interface_desc = {
 static struct hid_descriptor hidg_desc = {
 	.bLength			= sizeof hidg_desc,
 	.bDescriptorType		= HID_DT_HID,
-	.bcdHID				= 0x0101,
+	.bcdHID				= cpu_to_le16(0x0101),
 	.bCountryCode			= 0x00,
 	.bNumDescriptors		= 0x1,
 	/*.desc[0].bDescriptorType	= DYNAMIC */
diff --git a/drivers/usb/gadget/legacy/hid.c b/drivers/usb/gadget/legacy/hid.c
index a71a884f79fc..cccbb948821b 100644
--- a/drivers/usb/gadget/legacy/hid.c
+++ b/drivers/usb/gadget/legacy/hid.c
@@ -175,8 +175,10 @@ static int hid_bind(struct usb_composite_dev *cdev)
 		struct usb_descriptor_header *usb_desc;
 
 		usb_desc = usb_otg_descriptor_alloc(gadget);
-		if (!usb_desc)
+		if (!usb_desc) {
+			status = -ENOMEM;
 			goto put;
+		}
 		usb_otg_descriptor_init(gadget, usb_desc);
 		otg_desc[0] = usb_desc;
 		otg_desc[1] = NULL;
diff --git a/drivers/video/backlight/lm3630a_bl.c b/drivers/video/backlight/lm3630a_bl.c
index ef2553f452ca..f17e5a8860fa 100644
--- a/drivers/video/backlight/lm3630a_bl.c
+++ b/drivers/video/backlight/lm3630a_bl.c
@@ -184,7 +184,7 @@ static int lm3630a_bank_a_update_status(struct backlight_device *bl)
 	if ((pwm_ctrl & LM3630A_PWM_BANK_A) != 0) {
 		lm3630a_pwm_ctrl(pchip, bl->props.brightness,
 				 bl->props.max_brightness);
-		return bl->props.brightness;
+		return 0;
 	}
 
 	/* disable sleep */
@@ -204,8 +204,8 @@ static int lm3630a_bank_a_update_status(struct backlight_device *bl)
 	return 0;
 
 out_i2c_err:
-	dev_err(pchip->dev, "i2c failed to access\n");
-	return bl->props.brightness;
+	dev_err(pchip->dev, "i2c failed to access (%pe)\n", ERR_PTR(ret));
+	return ret;
 }
 
 static int lm3630a_bank_a_get_brightness(struct backlight_device *bl)
@@ -261,7 +261,7 @@ static int lm3630a_bank_b_update_status(struct backlight_device *bl)
 	if ((pwm_ctrl & LM3630A_PWM_BANK_B) != 0) {
 		lm3630a_pwm_ctrl(pchip, bl->props.brightness,
 				 bl->props.max_brightness);
-		return bl->props.brightness;
+		return 0;
 	}
 
 	/* disable sleep */
@@ -281,8 +281,8 @@ static int lm3630a_bank_b_update_status(struct backlight_device *bl)
 	return 0;
 
 out_i2c_err:
-	dev_err(pchip->dev, "i2c failed to access REG_CTRL\n");
-	return bl->props.brightness;
+	dev_err(pchip->dev, "i2c failed to access (%pe)\n", ERR_PTR(ret));
+	return ret;
 }
 
 static int lm3630a_bank_b_get_brightness(struct backlight_device *bl)
diff --git a/drivers/w1/slaves/w1_ds2438.c b/drivers/w1/slaves/w1_ds2438.c
index 7c4e33dbee4d..b005dda9c697 100644
--- a/drivers/w1/slaves/w1_ds2438.c
+++ b/drivers/w1/slaves/w1_ds2438.c
@@ -64,13 +64,13 @@ static int w1_ds2438_get_page(struct w1_slave *sl, int pageno, u8 *buf)
 		if (w1_reset_select_slave(sl))
 			continue;
 		w1_buf[0] = W1_DS2438_RECALL_MEMORY;
-		w1_buf[1] = 0x00;
+		w1_buf[1] = (u8)pageno;
 		w1_write_block(sl->master, w1_buf, 2);
 
 		if (w1_reset_select_slave(sl))
 			continue;
 		w1_buf[0] = W1_DS2438_READ_SCRATCH;
-		w1_buf[1] = 0x00;
+		w1_buf[1] = (u8)pageno;
 		w1_write_block(sl->master, w1_buf, 2);
 
 		count = w1_read_block(sl->master, buf, DS2438_PAGE_SIZE + 1);
diff --git a/drivers/watchdog/aspeed_wdt.c b/drivers/watchdog/aspeed_wdt.c
index f5835cbd5d41..5c13659cc89a 100644
--- a/drivers/watchdog/aspeed_wdt.c
+++ b/drivers/watchdog/aspeed_wdt.c
@@ -147,7 +147,7 @@ static int aspeed_wdt_set_timeout(struct watchdog_device *wdd,
 
 	wdd->timeout = timeout;
 
-	actual = min(timeout, wdd->max_hw_heartbeat_ms * 1000);
+	actual = min(timeout, wdd->max_hw_heartbeat_ms / 1000);
 
 	writel(actual * WDT_RATE_1MHZ, wdt->base + WDT_RELOAD_VALUE);
 	writel(WDT_RESTART_MAGIC, wdt->base + WDT_RESTART);
diff --git a/drivers/watchdog/iTCO_wdt.c b/drivers/watchdog/iTCO_wdt.c
index 347f0389b089..059c9eddb546 100644
--- a/drivers/watchdog/iTCO_wdt.c
+++ b/drivers/watchdog/iTCO_wdt.c
@@ -75,6 +75,8 @@
 #define TCOBASE(p)	((p)->tco_res->start)
 /* SMI Control and Enable Register */
 #define SMI_EN(p)	((p)->smi_res->start)
+#define TCO_EN		(1 << 13)
+#define GBL_SMI_EN	(1 << 0)
 
 #define TCO_RLD(p)	(TCOBASE(p) + 0x00) /* TCO Timer Reload/Curr. Value */
 #define TCOv1_TMR(p)	(TCOBASE(p) + 0x01) /* TCOv1 Timer Initial Value*/
@@ -330,8 +332,12 @@ static int iTCO_wdt_set_timeout(struct watchdog_device *wd_dev, unsigned int t)
 
 	tmrval = seconds_to_ticks(p, t);
 
-	/* For TCO v1 the timer counts down twice before rebooting */
-	if (p->iTCO_version == 1)
+	/*
+	 * If TCO SMIs are off, the timer counts down twice before rebooting.
+	 * Otherwise, the BIOS generally reboots when the SMI triggers.
+	 */
+	if (p->smi_res &&
+	    (SMI_EN(p) & (TCO_EN | GBL_SMI_EN)) != (TCO_EN | GBL_SMI_EN))
 		tmrval /= 2;
 
 	/* from the specs: */
@@ -493,7 +499,7 @@ static int iTCO_wdt_probe(struct platform_device *pdev)
 		 * Disables TCO logic generating an SMI#
 		 */
 		val32 = inl(SMI_EN(p));
-		val32 &= 0xffffdfff;	/* Turn off SMI clearing watchdog */
+		val32 &= ~TCO_EN;	/* Turn off SMI clearing watchdog */
 		outl(val32, SMI_EN(p));
 	}
 
diff --git a/drivers/watchdog/lpc18xx_wdt.c b/drivers/watchdog/lpc18xx_wdt.c
index 3b8bb59adf02..e9deeda1fdbf 100644
--- a/drivers/watchdog/lpc18xx_wdt.c
+++ b/drivers/watchdog/lpc18xx_wdt.c
@@ -300,7 +300,7 @@ static int lpc18xx_wdt_remove(struct platform_device *pdev)
 	struct lpc18xx_wdt_dev *lpc18xx_wdt = platform_get_drvdata(pdev);
 
 	dev_warn(&pdev->dev, "I quit now, hardware will probably reboot!\n");
-	del_timer(&lpc18xx_wdt->timer);
+	del_timer_sync(&lpc18xx_wdt->timer);
 
 	watchdog_unregister_device(&lpc18xx_wdt->wdt_dev);
 	clk_disable_unprepare(lpc18xx_wdt->wdt_clk);
diff --git a/drivers/watchdog/sbc60xxwdt.c b/drivers/watchdog/sbc60xxwdt.c
index 2eef58a0cf05..152db059d5aa 100644
--- a/drivers/watchdog/sbc60xxwdt.c
+++ b/drivers/watchdog/sbc60xxwdt.c
@@ -152,7 +152,7 @@ static void wdt_startup(void)
 static void wdt_turnoff(void)
 {
 	/* Stop the timer */
-	del_timer(&timer);
+	del_timer_sync(&timer);
 	inb_p(wdt_stop);
 	pr_info("Watchdog timer is now disabled...\n");
 }
diff --git a/drivers/watchdog/sc520_wdt.c b/drivers/watchdog/sc520_wdt.c
index 1cfd3f6a13d5..08500db8324f 100644
--- a/drivers/watchdog/sc520_wdt.c
+++ b/drivers/watchdog/sc520_wdt.c
@@ -190,7 +190,7 @@ static int wdt_startup(void)
 static int wdt_turnoff(void)
 {
 	/* Stop the timer */
-	del_timer(&timer);
+	del_timer_sync(&timer);
 
 	/* Stop the watchdog */
 	wdt_config(0);
diff --git a/drivers/watchdog/w83877f_wdt.c b/drivers/watchdog/w83877f_wdt.c
index f0483c75ed32..4b52cf321747 100644
--- a/drivers/watchdog/w83877f_wdt.c
+++ b/drivers/watchdog/w83877f_wdt.c
@@ -170,7 +170,7 @@ static void wdt_startup(void)
 static void wdt_turnoff(void)
 {
 	/* Stop the timer */
-	del_timer(&timer);
+	del_timer_sync(&timer);
 
 	wdt_change(WDT_DISABLE);
 
diff --git a/fs/btrfs/Kconfig b/fs/btrfs/Kconfig
index a26c63b4ad68..9dd07eb88455 100644
--- a/fs/btrfs/Kconfig
+++ b/fs/btrfs/Kconfig
@@ -11,6 +11,8 @@ config BTRFS_FS
 	select RAID6_PQ
 	select XOR_BLOCKS
 	select SRCU
+	depends on !PPC_256K_PAGES	# powerpc
+	depends on !PAGE_SIZE_256KB	# hexagon
 
 	help
 	  Btrfs is a general purpose copy-on-write filesystem with extents,
diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 416fb50a5378..9f276d1dd29c 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1064,12 +1064,10 @@ static int __btrfs_update_delayed_inode(struct btrfs_trans_handle *trans,
 	nofs_flag = memalloc_nofs_save();
 	ret = btrfs_lookup_inode(trans, root, path, &key, mod);
 	memalloc_nofs_restore(nofs_flag);
-	if (ret > 0) {
-		btrfs_release_path(path);
-		return -ENOENT;
-	} else if (ret < 0) {
-		return ret;
-	}
+	if (ret > 0)
+		ret = -ENOENT;
+	if (ret < 0)
+		goto out;
 
 	leaf = path->nodes[0];
 	inode_item = btrfs_item_ptr(leaf, path->slots[0],
@@ -1107,6 +1105,14 @@ static int __btrfs_update_delayed_inode(struct btrfs_trans_handle *trans,
 	btrfs_delayed_inode_release_metadata(fs_info, node);
 	btrfs_release_delayed_inode(node);
 
+	/*
+	 * If we fail to update the delayed inode we need to abort the
+	 * transaction, because we could leave the inode with the improper
+	 * counts behind.
+	 */
+	if (ret && ret != -ENOENT)
+		btrfs_abort_transaction(trans, ret);
+
 	return ret;
 
 search:
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 447976579ed2..ad570c3b6a0b 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -4078,6 +4078,17 @@ static int process_recorded_refs(struct send_ctx *sctx, int *pending_move)
 				if (ret < 0)
 					goto out;
 			} else {
+				/*
+				 * If we previously orphanized a directory that
+				 * collided with a new reference that we already
+				 * processed, recompute the current path because
+				 * that directory may be part of the path.
+				 */
+				if (orphanized_dir) {
+					ret = refresh_ref_path(sctx, cur);
+					if (ret < 0)
+						goto out;
+				}
 				ret = send_unlink(sctx, cur->full_path);
 				if (ret < 0)
 					goto out;
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index a066ad581976..da40912fe086 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1319,8 +1319,10 @@ int btrfs_defrag_root(struct btrfs_root *root)
 
 	while (1) {
 		trans = btrfs_start_transaction(root, 0);
-		if (IS_ERR(trans))
-			return PTR_ERR(trans);
+		if (IS_ERR(trans)) {
+			ret = PTR_ERR(trans);
+			break;
+		}
 
 		ret = btrfs_defrag_leaves(trans, root);
 
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index f890fdb59915..fbcfee38583b 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -5957,6 +5957,7 @@ int btrfs_recover_log_trees(struct btrfs_root *log_root_tree)
 error:
 	if (wc.trans)
 		btrfs_end_transaction(wc.trans);
+	clear_bit(BTRFS_FS_LOG_RECOVERING, &fs_info->flags);
 	btrfs_free_path(path);
 	return ret;
 }
diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index ae1435c12d2b..1dba2b95fe8e 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -74,10 +74,6 @@ static int ceph_set_page_dirty(struct page *page)
 	struct inode *inode;
 	struct ceph_inode_info *ci;
 	struct ceph_snap_context *snapc;
-	int ret;
-
-	if (unlikely(!mapping))
-		return !TestSetPageDirty(page);
 
 	if (PageDirty(page)) {
 		dout("%p set_page_dirty %p idx %lu -- already dirty\n",
@@ -123,11 +119,7 @@ static int ceph_set_page_dirty(struct page *page)
 	page->private = (unsigned long)snapc;
 	SetPagePrivate(page);
 
-	ret = __set_page_dirty_nobuffers(page);
-	WARN_ON(!PageLocked(page));
-	WARN_ON(!page->mapping);
-
-	return ret;
+	return __set_page_dirty_nobuffers(page);
 }
 
 /*
diff --git a/fs/configfs/file.c b/fs/configfs/file.c
index 50b7c4c4310e..38eb80e29715 100644
--- a/fs/configfs/file.c
+++ b/fs/configfs/file.c
@@ -496,13 +496,13 @@ static int configfs_release_bin_file(struct inode *inode, struct file *file)
 					buffer->bin_buffer_size);
 		}
 		up_read(&frag->frag_sem);
-		/* vfree on NULL is safe */
-		vfree(buffer->bin_buffer);
-		buffer->bin_buffer = NULL;
-		buffer->bin_buffer_size = 0;
-		buffer->needs_read_fill = 1;
 	}
 
+	vfree(buffer->bin_buffer);
+	buffer->bin_buffer = NULL;
+	buffer->bin_buffer_size = 0;
+	buffer->needs_read_fill = 1;
+
 	configfs_release(inode, file);
 	return 0;
 }
diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
index 8606da1df0aa..08b13ddba93e 100644
--- a/fs/crypto/fname.c
+++ b/fs/crypto/fname.c
@@ -304,13 +304,8 @@ int fscrypt_fname_disk_to_usr(struct inode *inode,
 					   oname->name);
 		return 0;
 	}
-	if (hash) {
-		digested_name.hash = hash;
-		digested_name.minor_hash = minor_hash;
-	} else {
-		digested_name.hash = 0;
-		digested_name.minor_hash = 0;
-	}
+	digested_name.hash = hash;
+	digested_name.minor_hash = minor_hash;
 	memcpy(digested_name.digest,
 	       FSCRYPT_FNAME_DIGEST(iname->name, iname->len),
 	       FSCRYPT_FNAME_DIGEST_SIZE);
diff --git a/fs/dlm/config.c b/fs/dlm/config.c
index 472f4f835d3e..4fb070b7f00f 100644
--- a/fs/dlm/config.c
+++ b/fs/dlm/config.c
@@ -80,6 +80,9 @@ struct dlm_cluster {
 	unsigned int cl_new_rsb_count;
 	unsigned int cl_recover_callbacks;
 	char cl_cluster_name[DLM_LOCKSPACE_LEN];
+
+	struct dlm_spaces *sps;
+	struct dlm_comms *cms;
 };
 
 static struct dlm_cluster *config_item_to_cluster(struct config_item *i)
@@ -356,6 +359,9 @@ static struct config_group *make_cluster(struct config_group *g,
 	if (!cl || !sps || !cms)
 		goto fail;
 
+	cl->sps = sps;
+	cl->cms = cms;
+
 	config_group_init_type_name(&cl->group, name, &cluster_type);
 	config_group_init_type_name(&sps->ss_group, "spaces", &spaces_type);
 	config_group_init_type_name(&cms->cs_group, "comms", &comms_type);
@@ -405,6 +411,9 @@ static void drop_cluster(struct config_group *g, struct config_item *i)
 static void release_cluster(struct config_item *i)
 {
 	struct dlm_cluster *cl = config_item_to_cluster(i);
+
+	kfree(cl->sps);
+	kfree(cl->cms);
 	kfree(cl);
 }
 
diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 4813d0e0cd9b..af17fcd798c8 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -595,7 +595,7 @@ static void close_connection(struct connection *con, bool and_other,
 	}
 	if (con->othercon && and_other) {
 		/* Will only re-enter once. */
-		close_connection(con->othercon, false, true, true);
+		close_connection(con->othercon, false, tx, rx);
 	}
 	if (con->rx_page) {
 		__free_page(con->rx_page);
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 17f6d995576f..652d16f90beb 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -870,6 +870,7 @@ int ext4_ext_tree_init(handle_t *handle, struct inode *inode)
 	eh->eh_entries = 0;
 	eh->eh_magic = EXT4_EXT_MAGIC;
 	eh->eh_max = cpu_to_le16(ext4_ext_space_root(inode, 0));
+	eh->eh_generation = 0;
 	ext4_mark_inode_dirty(handle, inode);
 	return 0;
 }
@@ -1126,6 +1127,7 @@ static int ext4_ext_split(handle_t *handle, struct inode *inode,
 	neh->eh_max = cpu_to_le16(ext4_ext_space_block(inode, 0));
 	neh->eh_magic = EXT4_EXT_MAGIC;
 	neh->eh_depth = 0;
+	neh->eh_generation = 0;
 
 	/* move remainder of path[depth] to the new leaf */
 	if (unlikely(path[depth].p_hdr->eh_entries !=
@@ -1203,6 +1205,7 @@ static int ext4_ext_split(handle_t *handle, struct inode *inode,
 		neh->eh_magic = EXT4_EXT_MAGIC;
 		neh->eh_max = cpu_to_le16(ext4_ext_space_block_idx(inode, 0));
 		neh->eh_depth = cpu_to_le16(depth - i);
+		neh->eh_generation = 0;
 		fidx = EXT_FIRST_INDEX(neh);
 		fidx->ei_block = border;
 		ext4_idx_store_pblock(fidx, oldblock);
diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index 763ef185dd17..e89be95a4c8c 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -1081,11 +1081,9 @@ static unsigned long ext4_es_scan(struct shrinker *shrink,
 	ret = percpu_counter_read_positive(&sbi->s_es_stats.es_stats_shk_cnt);
 	trace_ext4_es_shrink_scan_enter(sbi->s_sb, nr_to_scan, ret);
 
-	if (!nr_to_scan)
-		return ret;
-
 	nr_shrunk = __es_shrink(sbi, nr_to_scan, NULL);
 
+	ret = percpu_counter_read_positive(&sbi->s_es_stats.es_stats_shk_cnt);
 	trace_ext4_es_shrink_scan_exit(sbi->s_sb, nr_shrunk, ret);
 	return nr_shrunk;
 }
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 53525694cadf..e6520627a84a 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -407,7 +407,7 @@ static void get_orlov_stats(struct super_block *sb, ext4_group_t g,
  *
  * We always try to spread first-level directories.
  *
- * If there are blockgroups with both free inodes and free blocks counts
+ * If there are blockgroups with both free inodes and free clusters counts
  * not worse than average we return one with smallest directory count.
  * Otherwise we simply return a random group.
  *
@@ -416,7 +416,7 @@ static void get_orlov_stats(struct super_block *sb, ext4_group_t g,
  * It's OK to put directory into a group unless
  * it has too many directories already (max_dirs) or
  * it has too few free inodes left (min_inodes) or
- * it has too few free blocks left (min_blocks) or
+ * it has too few free clusters left (min_clusters) or
  * Parent's group is preferred, if it doesn't satisfy these
  * conditions we search cyclically through the rest. If none
  * of the groups look good we just look for a group with more
@@ -432,7 +432,7 @@ static int find_group_orlov(struct super_block *sb, struct inode *parent,
 	ext4_group_t real_ngroups = ext4_get_groups_count(sb);
 	int inodes_per_group = EXT4_INODES_PER_GROUP(sb);
 	unsigned int freei, avefreei, grp_free;
-	ext4_fsblk_t freeb, avefreec;
+	ext4_fsblk_t freec, avefreec;
 	unsigned int ndirs;
 	int max_dirs, min_inodes;
 	ext4_grpblk_t min_clusters;
@@ -451,9 +451,8 @@ static int find_group_orlov(struct super_block *sb, struct inode *parent,
 
 	freei = percpu_counter_read_positive(&sbi->s_freeinodes_counter);
 	avefreei = freei / ngroups;
-	freeb = EXT4_C2B(sbi,
-		percpu_counter_read_positive(&sbi->s_freeclusters_counter));
-	avefreec = freeb;
+	freec = percpu_counter_read_positive(&sbi->s_freeclusters_counter);
+	avefreec = freec;
 	do_div(avefreec, ngroups);
 	ndirs = percpu_counter_read_positive(&sbi->s_dirs_counter);
 
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index b4da63f24093..c40d3c44a1d6 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1558,10 +1558,11 @@ static int mb_find_extent(struct ext4_buddy *e4b, int block,
 	if (ex->fe_start + ex->fe_len > EXT4_CLUSTERS_PER_GROUP(e4b->bd_sb)) {
 		/* Should never happen! (but apparently sometimes does?!?) */
 		WARN_ON(1);
-		ext4_error(e4b->bd_sb, "corruption or bug in mb_find_extent "
-			   "block=%d, order=%d needed=%d ex=%u/%d/%d@%u",
-			   block, order, needed, ex->fe_group, ex->fe_start,
-			   ex->fe_len, ex->fe_logical);
+		ext4_grp_locked_error(e4b->bd_sb, e4b->bd_group, 0, 0,
+			"corruption or bug in mb_find_extent "
+			"block=%d, order=%d needed=%d ex=%u/%d/%d@%u",
+			block, order, needed, ex->fe_group, ex->fe_start,
+			ex->fe_len, ex->fe_logical);
 		ex->fe_len = 0;
 		ex->fe_start = 0;
 		ex->fe_group = 0;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index ae1aa6065d04..660469befb7f 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2614,8 +2614,15 @@ static void ext4_orphan_cleanup(struct super_block *sb,
 			inode_lock(inode);
 			truncate_inode_pages(inode->i_mapping, inode->i_size);
 			ret = ext4_truncate(inode);
-			if (ret)
+			if (ret) {
+				/*
+				 * We need to clean up the in-core orphan list
+				 * manually if ext4_truncate() failed to get a
+				 * transaction handle.
+				 */
+				ext4_orphan_del(NULL, inode);
 				ext4_std_error(inode->i_sb, ret);
+			}
 			inode_unlock(inode);
 			nr_truncates++;
 		} else {
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 990339c538b0..b2c747f53c0c 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -2896,4 +2896,5 @@ module_exit(exit_f2fs_fs)
 MODULE_AUTHOR("Samsung Electronics's Praesto Team");
 MODULE_DESCRIPTION("Flash Friendly File System");
 MODULE_LICENSE("GPL");
+MODULE_SOFTDEP("pre: crc32");
 
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index fde277be2642..1e583e24dd5d 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -512,9 +512,14 @@ static void inode_switch_wbs(struct inode *inode, int new_wb_id)
 	/* find and pin the new wb */
 	rcu_read_lock();
 	memcg_css = css_from_id(new_wb_id, &memory_cgrp_subsys);
-	if (memcg_css)
-		isw->new_wb = wb_get_create(bdi, memcg_css, GFP_ATOMIC);
+	if (memcg_css && !css_tryget(memcg_css))
+		memcg_css = NULL;
 	rcu_read_unlock();
+	if (!memcg_css)
+		goto out_free;
+
+	isw->new_wb = wb_get_create(bdi, memcg_css, GFP_ATOMIC);
+	css_put(memcg_css);
 	if (!isw->new_wb)
 		goto out_free;
 
@@ -2082,28 +2087,6 @@ int dirtytime_interval_handler(struct ctl_table *table, int write,
 	return ret;
 }
 
-static noinline void block_dump___mark_inode_dirty(struct inode *inode)
-{
-	if (inode->i_ino || strcmp(inode->i_sb->s_id, "bdev")) {
-		struct dentry *dentry;
-		const char *name = "?";
-
-		dentry = d_find_alias(inode);
-		if (dentry) {
-			spin_lock(&dentry->d_lock);
-			name = (const char *) dentry->d_name.name;
-		}
-		printk(KERN_DEBUG
-		       "%s(%d): dirtied inode %lu (%s) on %s\n",
-		       current->comm, task_pid_nr(current), inode->i_ino,
-		       name, inode->i_sb->s_id);
-		if (dentry) {
-			spin_unlock(&dentry->d_lock);
-			dput(dentry);
-		}
-	}
-}
-
 /**
  * __mark_inode_dirty -	internal function
  *
@@ -2163,9 +2146,6 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 	    (dirtytime && (inode->i_state & I_DIRTY_INODE)))
 		return;
 
-	if (unlikely(block_dump))
-		block_dump___mark_inode_dirty(inode);
-
 	spin_lock(&inode->i_lock);
 	if (dirtytime && (inode->i_state & I_DIRTY_INODE))
 		goto out_unlock_inode;
diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index cfc19140f2a0..b6f2a10663a0 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1304,6 +1304,15 @@ static ssize_t fuse_dev_do_read(struct fuse_dev *fud, struct file *file,
 		goto restart;
 	}
 	spin_lock(&fpq->lock);
+	/*
+	 *  Must not put request on fpq->io queue after having been shut down by
+	 *  fuse_abort_conn()
+	 */
+	if (!fpq->connected) {
+		req->out.h.error = err = -ECONNABORTED;
+		goto out_end;
+
+	}
 	list_add(&req->list, &fpq->io);
 	spin_unlock(&fpq->lock);
 	cs->req = req;
@@ -1880,7 +1889,7 @@ static ssize_t fuse_dev_do_write(struct fuse_dev *fud,
 	}
 
 	err = -EINVAL;
-	if (oh.error <= -1000 || oh.error > 0)
+	if (oh.error <= -512 || oh.error > 0)
 		goto err_finish;
 
 	spin_lock(&fpq->lock);
diff --git a/fs/jfs/inode.c b/fs/jfs/inode.c
index 054cc761b426..87b41edc800d 100644
--- a/fs/jfs/inode.c
+++ b/fs/jfs/inode.c
@@ -161,7 +161,8 @@ void jfs_evict_inode(struct inode *inode)
 			if (test_cflag(COMMIT_Freewmap, inode))
 				jfs_free_zero_link(inode);
 
-			diFree(inode);
+			if (JFS_SBI(inode->i_sb)->ipimap)
+				diFree(inode);
 
 			/*
 			 * Free the inode from the quota allocation.
diff --git a/fs/jfs/jfs_logmgr.c b/fs/jfs/jfs_logmgr.c
index 0e5d412c0b01..794c2acb6822 100644
--- a/fs/jfs/jfs_logmgr.c
+++ b/fs/jfs/jfs_logmgr.c
@@ -1338,6 +1338,7 @@ int lmLogInit(struct jfs_log * log)
 		} else {
 			if (memcmp(logsuper->uuid, log->uuid, 16)) {
 				jfs_warn("wrong uuid on JFS log device");
+				rc = -EINVAL;
 				goto errout20;
 			}
 			log->size = le32_to_cpu(logsuper->size);
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 33cc69687792..ad01d4fb795e 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -972,6 +972,7 @@ EXPORT_SYMBOL_GPL(nfs_inode_attach_open_context);
 void nfs_file_set_open_context(struct file *filp, struct nfs_open_context *ctx)
 {
 	filp->private_data = get_nfs_open_context(ctx);
+	set_bit(NFS_CONTEXT_FILE_OPEN, &ctx->flags);
 	if (list_empty(&ctx->list))
 		nfs_inode_attach_open_context(ctx);
 }
@@ -991,6 +992,8 @@ struct nfs_open_context *nfs_find_open_context(struct inode *inode, struct rpc_c
 			continue;
 		if ((pos->mode & (FMODE_READ|FMODE_WRITE)) != mode)
 			continue;
+		if (!test_bit(NFS_CONTEXT_FILE_OPEN, &pos->flags))
+			continue;
 		ctx = get_nfs_open_context(pos);
 		break;
 	}
@@ -1005,6 +1008,7 @@ void nfs_file_clear_open_context(struct file *filp)
 	if (ctx) {
 		struct inode *inode = d_inode(ctx->dentry);
 
+		clear_bit(NFS_CONTEXT_FILE_OPEN, &ctx->flags);
 		/*
 		 * We fatal error on write before. Try to writeback
 		 * every page again.
diff --git a/fs/nfs/nfs3proc.c b/fs/nfs/nfs3proc.c
index bc673fb47fb3..65f9a8ae2845 100644
--- a/fs/nfs/nfs3proc.c
+++ b/fs/nfs/nfs3proc.c
@@ -357,7 +357,7 @@ nfs3_proc_create(struct inode *dir, struct dentry *dentry, struct iattr *sattr,
 				break;
 
 			case NFS3_CREATE_UNCHECKED:
-				goto out;
+				goto out_release_acls;
 		}
 		nfs_fattr_init(data->res.dir_attr);
 		nfs_fattr_init(data->res.fattr);
@@ -702,7 +702,7 @@ nfs3_proc_mknod(struct inode *dir, struct dentry *dentry, struct iattr *sattr,
 		break;
 	default:
 		status = -EINVAL;
-		goto out;
+		goto out_release_acls;
 	}
 
 	status = nfs3_do_create(dir, dentry, data);
diff --git a/fs/nfs/pnfs_nfs.c b/fs/nfs/pnfs_nfs.c
index b0ef37f3e2dd..29bdf1525d82 100644
--- a/fs/nfs/pnfs_nfs.c
+++ b/fs/nfs/pnfs_nfs.c
@@ -555,19 +555,16 @@ nfs4_pnfs_ds_add(struct list_head *dsaddrs, gfp_t gfp_flags)
 }
 EXPORT_SYMBOL_GPL(nfs4_pnfs_ds_add);
 
-static void nfs4_wait_ds_connect(struct nfs4_pnfs_ds *ds)
+static int nfs4_wait_ds_connect(struct nfs4_pnfs_ds *ds)
 {
 	might_sleep();
-	wait_on_bit(&ds->ds_state, NFS4DS_CONNECTING,
-			TASK_KILLABLE);
+	return wait_on_bit(&ds->ds_state, NFS4DS_CONNECTING, TASK_KILLABLE);
 }
 
 static void nfs4_clear_ds_conn_bit(struct nfs4_pnfs_ds *ds)
 {
 	smp_mb__before_atomic();
-	clear_bit(NFS4DS_CONNECTING, &ds->ds_state);
-	smp_mb__after_atomic();
-	wake_up_bit(&ds->ds_state, NFS4DS_CONNECTING);
+	clear_and_wake_up_bit(NFS4DS_CONNECTING, &ds->ds_state);
 }
 
 static struct nfs_client *(*get_v3_ds_connect)(
@@ -728,30 +725,33 @@ int nfs4_pnfs_ds_connect(struct nfs_server *mds_srv, struct nfs4_pnfs_ds *ds,
 {
 	int err;
 
-again:
-	err = 0;
-	if (test_and_set_bit(NFS4DS_CONNECTING, &ds->ds_state) == 0) {
-		if (version == 3) {
-			err = _nfs4_pnfs_v3_ds_connect(mds_srv, ds, timeo,
-						       retrans);
-		} else if (version == 4) {
-			err = _nfs4_pnfs_v4_ds_connect(mds_srv, ds, timeo,
-						       retrans, minor_version);
-		} else {
-			dprintk("%s: unsupported DS version %d\n", __func__,
-				version);
-			err = -EPROTONOSUPPORT;
-		}
+	do {
+		err = nfs4_wait_ds_connect(ds);
+		if (err || ds->ds_clp)
+			goto out;
+		if (nfs4_test_deviceid_unavailable(devid))
+			return -ENODEV;
+	} while (test_and_set_bit(NFS4DS_CONNECTING, &ds->ds_state) != 0);
 
-		nfs4_clear_ds_conn_bit(ds);
-	} else {
-		nfs4_wait_ds_connect(ds);
+	if (ds->ds_clp)
+		goto connect_done;
 
-		/* what was waited on didn't connect AND didn't mark unavail */
-		if (!ds->ds_clp && !nfs4_test_deviceid_unavailable(devid))
-			goto again;
+	switch (version) {
+	case 3:
+		err = _nfs4_pnfs_v3_ds_connect(mds_srv, ds, timeo, retrans);
+		break;
+	case 4:
+		err = _nfs4_pnfs_v4_ds_connect(mds_srv, ds, timeo, retrans,
+					       minor_version);
+		break;
+	default:
+		dprintk("%s: unsupported DS version %d\n", __func__, version);
+		err = -EPROTONOSUPPORT;
 	}
 
+connect_done:
+	nfs4_clear_ds_conn_bit(ds);
+out:
 	/*
 	 * At this point the ds->ds_clp should be ready, but it might have
 	 * hit an error.
diff --git a/fs/ntfs/inode.c b/fs/ntfs/inode.c
index a4fa548785d6..8cd134750ebb 100644
--- a/fs/ntfs/inode.c
+++ b/fs/ntfs/inode.c
@@ -502,7 +502,7 @@ static int ntfs_is_extended_system_file(ntfs_attr_search_ctx *ctx)
 		}
 		file_name_attr = (FILE_NAME_ATTR*)((u8*)attr +
 				le16_to_cpu(attr->data.resident.value_offset));
-		p2 = (u8*)attr + le32_to_cpu(attr->data.resident.value_length);
+		p2 = (u8 *)file_name_attr + le32_to_cpu(attr->data.resident.value_length);
 		if (p2 < (u8*)attr || p2 > p)
 			goto err_corrupt_attr;
 		/* This attribute is ok, but is it in the $Extend directory? */
diff --git a/fs/ocfs2/filecheck.c b/fs/ocfs2/filecheck.c
index 2cabbcf2f28e..5571268b681c 100644
--- a/fs/ocfs2/filecheck.c
+++ b/fs/ocfs2/filecheck.c
@@ -431,11 +431,7 @@ static ssize_t ocfs2_filecheck_show(struct kobject *kobj,
 		ret = snprintf(buf + total, remain, "%lu\t\t%u\t%s\n",
 			       p->fe_ino, p->fe_done,
 			       ocfs2_filecheck_error(p->fe_status));
-		if (ret < 0) {
-			total = ret;
-			break;
-		}
-		if (ret == remain) {
+		if (ret >= remain) {
 			/* snprintf() didn't fit */
 			total = -E2BIG;
 			break;
diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
index c4b029c43464..e7eb08ac4215 100644
--- a/fs/ocfs2/stackglue.c
+++ b/fs/ocfs2/stackglue.c
@@ -510,11 +510,7 @@ static ssize_t ocfs2_loaded_cluster_plugins_show(struct kobject *kobj,
 	list_for_each_entry(p, &ocfs2_stack_list, sp_list) {
 		ret = snprintf(buf, remain, "%s\n",
 			       p->sp_name);
-		if (ret < 0) {
-			total = ret;
-			break;
-		}
-		if (ret == remain) {
+		if (ret >= remain) {
 			/* snprintf() didn't fit */
 			total = -E2BIG;
 			break;
@@ -541,7 +537,7 @@ static ssize_t ocfs2_active_cluster_plugin_show(struct kobject *kobj,
 	if (active_stack) {
 		ret = snprintf(buf, PAGE_SIZE, "%s\n",
 			       active_stack->sp_name);
-		if (ret == PAGE_SIZE)
+		if (ret >= PAGE_SIZE)
 			ret = -E2BIG;
 	}
 	spin_unlock(&ocfs2_stack_lock);
diff --git a/fs/orangefs/super.c b/fs/orangefs/super.c
index 1997ce49ab46..e5f7df28793d 100644
--- a/fs/orangefs/super.c
+++ b/fs/orangefs/super.c
@@ -197,7 +197,7 @@ static int orangefs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_bavail = (sector_t) new_op->downcall.resp.statfs.blocks_avail;
 	buf->f_files = (sector_t) new_op->downcall.resp.statfs.files_total;
 	buf->f_ffree = (sector_t) new_op->downcall.resp.statfs.files_avail;
-	buf->f_frsize = sb->s_blocksize;
+	buf->f_frsize = 0;
 
 out_op_release:
 	op_release(new_op);
diff --git a/fs/reiserfs/journal.c b/fs/reiserfs/journal.c
index 2be907231375..1a6e6343fed3 100644
--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -2769,6 +2769,20 @@ int journal_init(struct super_block *sb, const char *j_dev_name,
 		goto free_and_return;
 	}
 
+	/*
+	 * Sanity check to see if journal first block is correct.
+	 * If journal first block is invalid it can cause
+	 * zeroing important superblock members.
+	 */
+	if (!SB_ONDISK_JOURNAL_DEVICE(sb) &&
+	    SB_ONDISK_JOURNAL_1st_BLOCK(sb) < SB_JOURNAL_1st_RESERVED_BLOCK(sb)) {
+		reiserfs_warning(sb, "journal-1393",
+				 "journal 1st super block is invalid: 1st reserved block %d, but actual 1st block is %d",
+				 SB_JOURNAL_1st_RESERVED_BLOCK(sb),
+				 SB_ONDISK_JOURNAL_1st_BLOCK(sb));
+		goto free_and_return;
+	}
+
 	if (journal_init_dev(sb, journal, j_dev_name) != 0) {
 		reiserfs_warning(sb, "sh-462",
 				 "unable to initialize journal device");
diff --git a/fs/seq_file.c b/fs/seq_file.c
index eea09f6d8830..6cb1144421bb 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -26,6 +26,9 @@ static void seq_set_overflow(struct seq_file *m)
 
 static void *seq_buf_alloc(unsigned long size)
 {
+	if (unlikely(size > MAX_RW_COUNT))
+		return NULL;
+
 	return kvmalloc(size, GFP_KERNEL);
 }
 
diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index 9d5face7fdc0..de0d63a347ac 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -1408,7 +1408,10 @@ static int do_rename(struct inode *old_dir, struct dentry *old_dentry,
 			goto out_release;
 		}
 
+		spin_lock(&whiteout->i_lock);
 		whiteout->i_state |= I_LINKABLE;
+		spin_unlock(&whiteout->i_lock);
+
 		whiteout_ui = ubifs_inode(whiteout);
 		whiteout_ui->data = dev;
 		whiteout_ui->data_len = ubifs_encode_dev(dev, MKDEV(0, 0));
@@ -1501,7 +1504,11 @@ static int do_rename(struct inode *old_dir, struct dentry *old_dentry,
 
 		inc_nlink(whiteout);
 		mark_inode_dirty(whiteout);
+
+		spin_lock(&whiteout->i_lock);
 		whiteout->i_state &= ~I_LINKABLE;
+		spin_unlock(&whiteout->i_lock);
+
 		iput(whiteout);
 	}
 
diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index 041bf34f781f..d5516f025bad 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -956,6 +956,10 @@ static int udf_symlink(struct inode *dir, struct dentry *dentry,
 				iinfo->i_location.partitionReferenceNum,
 				0);
 		epos.bh = udf_tgetblk(sb, block);
+		if (unlikely(!epos.bh)) {
+			err = -ENOMEM;
+			goto out_no_entry;
+		}
 		lock_buffer(epos.bh);
 		memset(epos.bh->b_data, 0x00, bsize);
 		set_buffer_uptodate(epos.bh);
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index 27040a46d50a..556b40fee2d1 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -82,13 +82,7 @@ int ahash_register_instance(struct crypto_template *tmpl,
 			    struct ahash_instance *inst);
 void ahash_free_instance(struct crypto_instance *inst);
 
-int shash_no_setkey(struct crypto_shash *tfm, const u8 *key,
-		    unsigned int keylen);
-
-static inline bool crypto_shash_alg_has_setkey(struct shash_alg *alg)
-{
-	return alg->setkey != shash_no_setkey;
-}
+bool crypto_shash_alg_has_setkey(struct shash_alg *alg);
 
 bool crypto_hash_alg_has_setkey(struct hash_alg_common *halg);
 
diff --git a/include/linux/mfd/abx500/ux500_chargalg.h b/include/linux/mfd/abx500/ux500_chargalg.h
index 67703f23e7ba..821a3b9bc16e 100644
--- a/include/linux/mfd/abx500/ux500_chargalg.h
+++ b/include/linux/mfd/abx500/ux500_chargalg.h
@@ -15,7 +15,7 @@
  * - POWER_SUPPLY_TYPE_USB,
  * because only them store as drv_data pointer to struct ux500_charger.
  */
-#define psy_to_ux500_charger(x) power_supply_get_drvdata(psy)
+#define psy_to_ux500_charger(x) power_supply_get_drvdata(x)
 
 /* Forward declaration */
 struct ux500_charger;
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index f0015f801a78..e51292d9e1a2 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -77,6 +77,7 @@ struct nfs_open_context {
 #define NFS_CONTEXT_RESEND_WRITES	(1)
 #define NFS_CONTEXT_BAD			(2)
 #define NFS_CONTEXT_UNLOCK	(3)
+#define NFS_CONTEXT_FILE_OPEN		(4)
 	int error;
 
 	struct list_head list;
diff --git a/include/linux/prandom.h b/include/linux/prandom.h
index cc1e71334e53..e20339c78a84 100644
--- a/include/linux/prandom.h
+++ b/include/linux/prandom.h
@@ -93,7 +93,7 @@ static inline u32 __seed(u32 x, u32 m)
  */
 static inline void prandom_seed_state(struct rnd_state *state, u64 seed)
 {
-	u32 i = (seed >> 32) ^ (seed << 10) ^ seed;
+	u32 i = ((seed >> 32) ^ (seed << 10) ^ seed) & 0xffffffffUL;
 
 	state->s1 = __seed(i,   2U);
 	state->s2 = __seed(i,   8U);
diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index c1f71dd464d3..5831a304e61b 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -441,7 +441,7 @@ struct sctp_af {
 					 int saddr);
 	void		(*from_sk)	(union sctp_addr *,
 					 struct sock *sk);
-	void		(*from_addr_param) (union sctp_addr *,
+	bool		(*from_addr_param) (union sctp_addr *,
 					    union sctp_addr_param *,
 					    __be16 port, int iif);
 	int		(*to_addr_param) (const union sctp_addr *,
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index b266d2a3bcb1..484e9787d817 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -436,6 +436,8 @@ extern void iscsi_remove_session(struct iscsi_cls_session *session);
 extern void iscsi_free_session(struct iscsi_cls_session *session);
 extern struct iscsi_cls_conn *iscsi_create_conn(struct iscsi_cls_session *sess,
 						int dd_size, uint32_t cid);
+extern void iscsi_put_conn(struct iscsi_cls_conn *conn);
+extern void iscsi_get_conn(struct iscsi_cls_conn *conn);
 extern int iscsi_destroy_conn(struct iscsi_cls_conn *conn);
 extern void iscsi_unblock_session(struct iscsi_cls_session *session);
 extern void iscsi_block_session(struct iscsi_cls_session *session);
diff --git a/kernel/cpu.c b/kernel/cpu.c
index e1d10629022a..f3b231cb6b65 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -30,6 +30,7 @@
 #include <linux/relay.h>
 #include <linux/slab.h>
 #include <linux/percpu-rwsem.h>
+#include <linux/cpuset.h>
 
 #include <trace/events/power.h>
 #define CREATE_TRACE_POINTS
@@ -771,6 +772,52 @@ void __init cpuhp_threads_init(void)
 	kthread_unpark(this_cpu_read(cpuhp_state.thread));
 }
 
+/*
+ *
+ * Serialize hotplug trainwrecks outside of the cpu_hotplug_lock
+ * protected region.
+ *
+ * The operation is still serialized against concurrent CPU hotplug via
+ * cpu_add_remove_lock, i.e. CPU map protection.  But it is _not_
+ * serialized against other hotplug related activity like adding or
+ * removing of state callbacks and state instances, which invoke either the
+ * startup or the teardown callback of the affected state.
+ *
+ * This is required for subsystems which are unfixable vs. CPU hotplug and
+ * evade lock inversion problems by scheduling work which has to be
+ * completed _before_ cpu_up()/_cpu_down() returns.
+ *
+ * Don't even think about adding anything to this for any new code or even
+ * drivers. It's only purpose is to keep existing lock order trainwrecks
+ * working.
+ *
+ * For cpu_down() there might be valid reasons to finish cleanups which are
+ * not required to be done under cpu_hotplug_lock, but that's a different
+ * story and would be not invoked via this.
+ */
+static void cpu_up_down_serialize_trainwrecks(bool tasks_frozen)
+{
+	/*
+	 * cpusets delegate hotplug operations to a worker to "solve" the
+	 * lock order problems. Wait for the worker, but only if tasks are
+	 * _not_ frozen (suspend, hibernate) as that would wait forever.
+	 *
+	 * The wait is required because otherwise the hotplug operation
+	 * returns with inconsistent state, which could even be observed in
+	 * user space when a new CPU is brought up. The CPU plug uevent
+	 * would be delivered and user space reacting on it would fail to
+	 * move tasks to the newly plugged CPU up to the point where the
+	 * work has finished because up to that point the newly plugged CPU
+	 * is not assignable in cpusets/cgroups. On unplug that's not
+	 * necessarily a visible issue, but it is still inconsistent state,
+	 * which is the real problem which needs to be "fixed". This can't
+	 * prevent the transient state between scheduling the work and
+	 * returning from waiting for it.
+	 */
+	if (!tasks_frozen)
+		cpuset_wait_for_hotplug();
+}
+
 #ifdef CONFIG_HOTPLUG_CPU
 #ifndef arch_clear_mm_cpumask_cpu
 #define arch_clear_mm_cpumask_cpu(cpu, mm) cpumask_clear_cpu(cpu, mm_cpumask(mm))
@@ -1010,6 +1057,7 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen,
 	 */
 	lockup_detector_cleanup();
 	arch_smt_update();
+	cpu_up_down_serialize_trainwrecks(tasks_frozen);
 	return ret;
 }
 
@@ -1145,6 +1193,7 @@ static int _cpu_up(unsigned int cpu, int tasks_frozen, enum cpuhp_state target)
 out:
 	cpus_write_unlock();
 	arch_smt_update();
+	cpu_up_down_serialize_trainwrecks(tasks_frozen);
 	return ret;
 }
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 0cc67bc0666e..552104837845 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4750,37 +4750,20 @@ static const struct file_operations tracing_readme_fops = {
 
 static void *saved_tgids_next(struct seq_file *m, void *v, loff_t *pos)
 {
-	int *ptr = v;
+	int pid = ++(*pos);
 
-	if (*pos || m->count)
-		ptr++;
-
-	(*pos)++;
-
-	for (; ptr <= &tgid_map[PID_MAX_DEFAULT]; ptr++) {
-		if (trace_find_tgid(*ptr))
-			return ptr;
-	}
+	if (pid > PID_MAX_DEFAULT)
+		return NULL;
 
-	return NULL;
+	return &tgid_map[pid];
 }
 
 static void *saved_tgids_start(struct seq_file *m, loff_t *pos)
 {
-	void *v;
-	loff_t l = 0;
-
-	if (!tgid_map)
+	if (!tgid_map || *pos > PID_MAX_DEFAULT)
 		return NULL;
 
-	v = &tgid_map[0];
-	while (l <= *pos) {
-		v = saved_tgids_next(m, v, &l);
-		if (!v)
-			return NULL;
-	}
-
-	return v;
+	return &tgid_map[*pos];
 }
 
 static void saved_tgids_stop(struct seq_file *m, void *v)
@@ -4789,9 +4772,14 @@ static void saved_tgids_stop(struct seq_file *m, void *v)
 
 static int saved_tgids_show(struct seq_file *m, void *v)
 {
-	int pid = (int *)v - tgid_map;
+	int *entry = (int *)v;
+	int pid = entry - tgid_map;
+	int tgid = *entry;
+
+	if (tgid == 0)
+		return SEQ_SKIP;
 
-	seq_printf(m, "%d %d\n", pid, trace_find_tgid(pid));
+	seq_printf(m, "%d %d\n", pid, tgid);
 	return 0;
 }
 
diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index e8c9eba9b1e7..df94c32a44f3 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -375,7 +375,9 @@ static struct hist_field *create_hist_field(struct ftrace_event_field *field,
 	if (WARN_ON_ONCE(!field))
 		goto out;
 
-	if (is_string_field(field)) {
+	/* Pointers to strings are just pointers and dangerous to dereference */
+	if (is_string_field(field) &&
+	    (field->filter_type != FILTER_PTR_STRING)) {
 		flags |= HIST_FIELD_FL_STRING;
 
 		if (field->filter_type == FILTER_STATIC_STRING)
@@ -864,8 +866,6 @@ static inline void add_to_key(char *compound_key, void *key,
 		field = key_field->field;
 		if (field->filter_type == FILTER_DYN_STRING)
 			size = *(u32 *)(rec + field->offset) >> 16;
-		else if (field->filter_type == FILTER_PTR_STRING)
-			size = strlen(key);
 		else if (field->filter_type == FILTER_STATIC_STRING)
 			size = field->size;
 
diff --git a/lib/decompress_unlz4.c b/lib/decompress_unlz4.c
index 1b0baf3008ea..b202aa864c48 100644
--- a/lib/decompress_unlz4.c
+++ b/lib/decompress_unlz4.c
@@ -115,6 +115,9 @@ STATIC inline int INIT unlz4(u8 *input, long in_len,
 				error("data corrupted");
 				goto exit_2;
 			}
+		} else if (size < 4) {
+			/* empty or end-of-file */
+			goto exit_3;
 		}
 
 		chunksize = get_unaligned_le32(inp);
@@ -128,6 +131,10 @@ STATIC inline int INIT unlz4(u8 *input, long in_len,
 			continue;
 		}
 
+		if (!fill && chunksize == 0) {
+			/* empty or end-of-file */
+			goto exit_3;
+		}
 
 		if (posp)
 			*posp += 4;
@@ -187,6 +194,7 @@ STATIC inline int INIT unlz4(u8 *input, long in_len,
 		}
 	}
 
+exit_3:
 	ret = 0;
 exit_2:
 	if (!input)
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 7b2fd5f251f2..9bdc797ef257 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -417,7 +417,7 @@ int iov_iter_fault_in_readable(struct iov_iter *i, size_t bytes)
 	int err;
 	struct iovec v;
 
-	if (!(i->type & (ITER_BVEC|ITER_KVEC))) {
+	if (iter_is_iovec(i)) {
 		iterate_iovec(i, bytes, v, iov, skip, ({
 			err = fault_in_pages_readable(v.iov_base, v.iov_len);
 			if (unlikely(err))
diff --git a/lib/kstrtox.c b/lib/kstrtox.c
index 661a1e807bd1..1a02b87b19c7 100644
--- a/lib/kstrtox.c
+++ b/lib/kstrtox.c
@@ -39,20 +39,22 @@ const char *_parse_integer_fixup_radix(const char *s, unsigned int *base)
 
 /*
  * Convert non-negative integer string representation in explicitly given radix
- * to an integer.
+ * to an integer. A maximum of max_chars characters will be converted.
+ *
  * Return number of characters consumed maybe or-ed with overflow bit.
  * If overflow occurs, result integer (incorrect) is still returned.
  *
  * Don't you dare use this function.
  */
-unsigned int _parse_integer(const char *s, unsigned int base, unsigned long long *p)
+unsigned int _parse_integer_limit(const char *s, unsigned int base, unsigned long long *p,
+				  size_t max_chars)
 {
 	unsigned long long res;
 	unsigned int rv;
 
 	res = 0;
 	rv = 0;
-	while (1) {
+	while (max_chars--) {
 		unsigned int c = *s;
 		unsigned int lc = c | 0x20; /* don't tolower() this line */
 		unsigned int val;
@@ -82,6 +84,11 @@ unsigned int _parse_integer(const char *s, unsigned int base, unsigned long long
 	return rv;
 }
 
+unsigned int _parse_integer(const char *s, unsigned int base, unsigned long long *p)
+{
+	return _parse_integer_limit(s, base, p, INT_MAX);
+}
+
 static int _kstrtoull(const char *s, unsigned int base, unsigned long long *res)
 {
 	unsigned long long _res;
diff --git a/lib/kstrtox.h b/lib/kstrtox.h
index 3b4637bcd254..158c400ca865 100644
--- a/lib/kstrtox.h
+++ b/lib/kstrtox.h
@@ -4,6 +4,8 @@
 
 #define KSTRTOX_OVERFLOW	(1U << 31)
 const char *_parse_integer_fixup_radix(const char *s, unsigned int *base);
+unsigned int _parse_integer_limit(const char *s, unsigned int base, unsigned long long *res,
+				  size_t max_chars);
 unsigned int _parse_integer(const char *s, unsigned int base, unsigned long long *res);
 
 #endif
diff --git a/lib/seq_buf.c b/lib/seq_buf.c
index 6aabb609dd87..562e53c93b7b 100644
--- a/lib/seq_buf.c
+++ b/lib/seq_buf.c
@@ -228,8 +228,10 @@ int seq_buf_putmem_hex(struct seq_buf *s, const void *mem,
 
 	WARN_ON(s->size == 0);
 
+	BUILD_BUG_ON(MAX_MEMHEX_BYTES * 2 >= HEX_CHARS);
+
 	while (len) {
-		start_len = min(len, HEX_CHARS - 1);
+		start_len = min(len, MAX_MEMHEX_BYTES);
 #ifdef __BIG_ENDIAN
 		for (i = 0, j = 0; i < start_len; i++) {
 #else
@@ -242,12 +244,14 @@ int seq_buf_putmem_hex(struct seq_buf *s, const void *mem,
 			break;
 
 		/* j increments twice per loop */
-		len -= j / 2;
 		hex[j++] = ' ';
 
 		seq_buf_putmem(s, hex, j);
 		if (seq_buf_has_overflowed(s))
 			return -1;
+
+		len -= start_len;
+		data += start_len;
 	}
 	return 0;
 }
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 4a990f3fd345..83b164707e5c 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -46,6 +46,31 @@
 #include <linux/string_helpers.h>
 #include "kstrtox.h"
 
+static unsigned long long simple_strntoull(const char *startp, size_t max_chars,
+					   char **endp, unsigned int base)
+{
+	const char *cp;
+	unsigned long long result = 0ULL;
+	size_t prefix_chars;
+	unsigned int rv;
+
+	cp = _parse_integer_fixup_radix(startp, &base);
+	prefix_chars = cp - startp;
+	if (prefix_chars < max_chars) {
+		rv = _parse_integer_limit(cp, base, &result, max_chars - prefix_chars);
+		/* FIXME */
+		cp += (rv & ~KSTRTOX_OVERFLOW);
+	} else {
+		/* Field too short for prefix + digit, skip over without converting */
+		cp = startp + max_chars;
+	}
+
+	if (endp)
+		*endp = (char *)cp;
+
+	return result;
+}
+
 /**
  * simple_strtoull - convert a string to an unsigned long long
  * @cp: The start of the string
@@ -56,18 +81,7 @@
  */
 unsigned long long simple_strtoull(const char *cp, char **endp, unsigned int base)
 {
-	unsigned long long result;
-	unsigned int rv;
-
-	cp = _parse_integer_fixup_radix(cp, &base);
-	rv = _parse_integer(cp, base, &result);
-	/* FIXME */
-	cp += (rv & ~KSTRTOX_OVERFLOW);
-
-	if (endp)
-		*endp = (char *)cp;
-
-	return result;
+	return simple_strntoull(cp, INT_MAX, endp, base);
 }
 EXPORT_SYMBOL(simple_strtoull);
 
@@ -102,6 +116,21 @@ long simple_strtol(const char *cp, char **endp, unsigned int base)
 }
 EXPORT_SYMBOL(simple_strtol);
 
+static long long simple_strntoll(const char *cp, size_t max_chars, char **endp,
+				 unsigned int base)
+{
+	/*
+	 * simple_strntoull() safely handles receiving max_chars==0 in the
+	 * case cp[0] == '-' && max_chars == 1.
+	 * If max_chars == 0 we can drop through and pass it to simple_strntoull()
+	 * and the content of *cp is irrelevant.
+	 */
+	if (*cp == '-' && max_chars > 0)
+		return -simple_strntoull(cp + 1, max_chars - 1, endp, base);
+
+	return simple_strntoull(cp, max_chars, endp, base);
+}
+
 /**
  * simple_strtoll - convert a string to a signed long long
  * @cp: The start of the string
@@ -112,10 +141,7 @@ EXPORT_SYMBOL(simple_strtol);
  */
 long long simple_strtoll(const char *cp, char **endp, unsigned int base)
 {
-	if (*cp == '-')
-		return -simple_strtoull(cp + 1, endp, base);
-
-	return simple_strtoull(cp, endp, base);
+	return simple_strntoll(cp, INT_MAX, endp, base);
 }
 EXPORT_SYMBOL(simple_strtoll);
 
@@ -2943,25 +2969,13 @@ int vsscanf(const char *buf, const char *fmt, va_list args)
 			break;
 
 		if (is_sign)
-			val.s = qualifier != 'L' ?
-				simple_strtol(str, &next, base) :
-				simple_strtoll(str, &next, base);
+			val.s = simple_strntoll(str,
+						field_width >= 0 ? field_width : INT_MAX,
+						&next, base);
 		else
-			val.u = qualifier != 'L' ?
-				simple_strtoul(str, &next, base) :
-				simple_strtoull(str, &next, base);
-
-		if (field_width > 0 && next - str > field_width) {
-			if (base == 0)
-				_parse_integer_fixup_radix(str, &base);
-			while (next - str > field_width) {
-				if (is_sign)
-					val.s = div_s64(val.s, base);
-				else
-					val.u = div_u64(val.u, base);
-				--next;
-			}
-		}
+			val.u = simple_strntoull(str,
+						 field_width >= 0 ? field_width : INT_MAX,
+						 &next, base);
 
 		switch (qualifier) {
 		case 'H':	/* that's 'hh' in format */
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index f5a5e9f82b22..f130d529824b 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -247,8 +247,8 @@ static int __init default_bdi_init(void)
 {
 	int err;
 
-	bdi_wq = alloc_workqueue("writeback", WQ_MEM_RECLAIM | WQ_FREEZABLE |
-					      WQ_UNBOUND | WQ_SYSFS, 0);
+	bdi_wq = alloc_workqueue("writeback", WQ_MEM_RECLAIM | WQ_UNBOUND |
+				 WQ_SYSFS, 0);
 	if (!bdi_wq)
 		return -ENOMEM;
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 972893908bcd..928ae18b1c13 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1624,7 +1624,7 @@ bool madvise_free_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	 * If other processes are mapping this page, we couldn't discard
 	 * the page unless they all do MADV_FREE so let's skip the page.
 	 */
-	if (page_mapcount(page) != 1)
+	if (total_mapcount(page) != 1)
 		goto out;
 
 	if (!trylock_page(page))
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index ba5c899d1edf..0958dbdd2906 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1569,14 +1569,6 @@ int hci_dev_do_close(struct hci_dev *hdev)
 
 	BT_DBG("%s %p", hdev->name, hdev);
 
-	if (!hci_dev_test_flag(hdev, HCI_UNREGISTER) &&
-	    !hci_dev_test_flag(hdev, HCI_USER_CHANNEL) &&
-	    test_bit(HCI_UP, &hdev->flags)) {
-		/* Execute vendor specific shutdown routine */
-		if (hdev->shutdown)
-			hdev->shutdown(hdev);
-	}
-
 	cancel_delayed_work(&hdev->power_off);
 
 	hci_request_cancel_all(hdev);
@@ -1644,6 +1636,14 @@ int hci_dev_do_close(struct hci_dev *hdev)
 		clear_bit(HCI_INIT, &hdev->flags);
 	}
 
+	if (!hci_dev_test_flag(hdev, HCI_UNREGISTER) &&
+	    !hci_dev_test_flag(hdev, HCI_USER_CHANNEL) &&
+	    test_bit(HCI_UP, &hdev->flags)) {
+		/* Execute vendor specific shutdown routine */
+		if (hdev->shutdown)
+			hdev->shutdown(hdev);
+	}
+
 	/* flush cmd  work */
 	flush_work(&hdev->cmd_work);
 
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index bca1408f815f..7aef6d23bc77 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -219,12 +219,15 @@ static u8 mgmt_status_table[] = {
 	MGMT_STATUS_TIMEOUT,		/* Instant Passed */
 	MGMT_STATUS_NOT_SUPPORTED,	/* Pairing Not Supported */
 	MGMT_STATUS_FAILED,		/* Transaction Collision */
+	MGMT_STATUS_FAILED,		/* Reserved for future use */
 	MGMT_STATUS_INVALID_PARAMS,	/* Unacceptable Parameter */
 	MGMT_STATUS_REJECTED,		/* QoS Rejected */
 	MGMT_STATUS_NOT_SUPPORTED,	/* Classification Not Supported */
 	MGMT_STATUS_REJECTED,		/* Insufficient Security */
 	MGMT_STATUS_INVALID_PARAMS,	/* Parameter Out Of Range */
+	MGMT_STATUS_FAILED,		/* Reserved for future use */
 	MGMT_STATUS_BUSY,		/* Role Switch Pending */
+	MGMT_STATUS_FAILED,		/* Reserved for future use */
 	MGMT_STATUS_FAILED,		/* Slot Violation */
 	MGMT_STATUS_FAILED,		/* Role Switch Failed */
 	MGMT_STATUS_INVALID_PARAMS,	/* EIR Too Large */
@@ -6087,6 +6090,9 @@ static bool tlv_data_is_valid(struct hci_dev *hdev, u32 adv_flags, u8 *data,
 	for (i = 0, cur_len = 0; i < len; i += (cur_len + 1)) {
 		cur_len = data[i];
 
+		if (!cur_len)
+			continue;
+
 		if (data[i + 1] == EIR_FLAGS &&
 		    (!is_adv_data || flags_managed(adv_flags)))
 			return false;
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index b24782d53474..4e3ff0b55ec1 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1763,7 +1763,9 @@ static void br_multicast_pim(struct net_bridge *br,
 	    pim_hdr_type(pimhdr) != PIM_TYPE_HELLO)
 		return;
 
+	spin_lock(&br->multicast_lock);
 	br_multicast_mark_router(br, port);
+	spin_unlock(&br->multicast_lock);
 }
 
 static int br_multicast_ipv4_rcv(struct net_bridge *br,
diff --git a/net/can/bcm.c b/net/can/bcm.c
index 8c8b02e54432..324c4cdc003e 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -841,6 +841,7 @@ static int bcm_delete_rx_op(struct list_head *ops, struct bcm_msg_head *mh,
 						  bcm_rx_handler, op);
 
 			list_del(&op->list);
+			synchronize_rcu();
 			bcm_remove_op(op);
 			return 1; /* done */
 		}
@@ -1594,9 +1595,13 @@ static int bcm_release(struct socket *sock)
 					  REGMASK(op->can_id),
 					  bcm_rx_handler, op);
 
-		bcm_remove_op(op);
 	}
 
+	synchronize_rcu();
+
+	list_for_each_entry_safe(op, next, &bo->rx_ops, list)
+		bcm_remove_op(op);
+
 #if IS_ENABLED(CONFIG_PROC_FS)
 	/* remove procfs entry */
 	if (net->can.bcmproc_dir && bo->bcm_proc_read)
diff --git a/net/can/gw.c b/net/can/gw.c
index 5114b8f07fd4..4db0b1819890 100644
--- a/net/can/gw.c
+++ b/net/can/gw.c
@@ -494,6 +494,7 @@ static int cgw_notifier(struct notifier_block *nb,
 			if (gwj->src.dev == dev || gwj->dst.dev == dev) {
 				hlist_del(&gwj->list);
 				cgw_unregister_filter(net, gwj);
+				synchronize_rcu();
 				kmem_cache_free(cgw_cache, gwj);
 			}
 		}
@@ -941,6 +942,7 @@ static void cgw_remove_all_jobs(struct net *net)
 	hlist_for_each_entry_safe(gwj, nx, &net->can.cgw_list, list) {
 		hlist_del(&gwj->list);
 		cgw_unregister_filter(net, gwj);
+		synchronize_rcu();
 		kmem_cache_free(cgw_cache, gwj);
 	}
 }
@@ -1010,6 +1012,7 @@ static int cgw_remove_job(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 		hlist_del(&gwj->list);
 		cgw_unregister_filter(net, gwj);
+		synchronize_rcu();
 		kmem_cache_free(cgw_cache, gwj);
 		err = 0;
 		break;
diff --git a/net/core/dev.c b/net/core/dev.c
index 7ee89125cd53..aa419f3162b8 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5277,11 +5277,18 @@ EXPORT_SYMBOL(napi_schedule_prep);
  * __napi_schedule_irqoff - schedule for receive
  * @n: entry to schedule
  *
- * Variant of __napi_schedule() assuming hard irqs are masked
+ * Variant of __napi_schedule() assuming hard irqs are masked.
+ *
+ * On PREEMPT_RT enabled kernels this maps to __napi_schedule()
+ * because the interrupt disabled assumption might not be true
+ * due to force-threaded interrupts and spinlock substitution.
  */
 void __napi_schedule_irqoff(struct napi_struct *n)
 {
-	____napi_schedule(this_cpu_ptr(&softnet_data), n);
+	if (!IS_ENABLED(CONFIG_PREEMPT_RT))
+		____napi_schedule(this_cpu_ptr(&softnet_data), n);
+	else
+		__napi_schedule(n);
 }
 EXPORT_SYMBOL(__napi_schedule_irqoff);
 
diff --git a/net/ipv6/output_core.c b/net/ipv6/output_core.c
index 868ae23dbae1..3829b565c645 100644
--- a/net/ipv6/output_core.c
+++ b/net/ipv6/output_core.c
@@ -14,29 +14,11 @@ static u32 __ipv6_select_ident(struct net *net,
 			       const struct in6_addr *dst,
 			       const struct in6_addr *src)
 {
-	const struct {
-		struct in6_addr dst;
-		struct in6_addr src;
-	} __aligned(SIPHASH_ALIGNMENT) combined = {
-		.dst = *dst,
-		.src = *src,
-	};
-	u32 hash, id;
-
-	/* Note the following code is not safe, but this is okay. */
-	if (unlikely(siphash_key_is_zero(&net->ipv4.ip_id_key)))
-		get_random_bytes(&net->ipv4.ip_id_key,
-				 sizeof(net->ipv4.ip_id_key));
-
-	hash = siphash(&combined, sizeof(combined), &net->ipv4.ip_id_key);
-
-	/* Treat id of 0 as unset and if we get 0 back from ip_idents_reserve,
-	 * set the hight order instead thus minimizing possible future
-	 * collisions.
-	 */
-	id = ip_idents_reserve(hash, 1);
-	if (unlikely(!id))
-		id = 1 << 31;
+	u32 id;
+
+	do {
+		id = prandom_u32();
+	} while (!id);
 
 	return id;
 }
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index ac2c52709e1c..87926c6fe0bf 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2404,7 +2404,7 @@ ieee80211_deliver_skb(struct ieee80211_rx_data *rx)
 #endif
 
 	if (skb) {
-		struct ethhdr *ehdr = (void *)skb_mac_header(skb);
+		struct ethhdr *ehdr = (struct ethhdr *)skb->data;
 
 		/* deliver to local stack */
 		skb->protocol = eth_type_trans(skb, dev);
diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index a0a93d987a3b..a301d3bbd3fa 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -46,6 +46,9 @@ static void nft_exthdr_ipv6_eval(const struct nft_expr *expr,
 	unsigned int offset = 0;
 	int err;
 
+	if (pkt->skb->protocol != htons(ETH_P_IPV6))
+		goto err;
+
 	err = ipv6_find_hdr(pkt->skb, &offset, priv->type, NULL, NULL);
 	if (priv->flags & NFT_EXTHDR_F_PRESENT) {
 		*dest = (err >= 0);
diff --git a/net/netlabel/netlabel_mgmt.c b/net/netlabel/netlabel_mgmt.c
index 21e0095b1d14..71ba69cb50c9 100644
--- a/net/netlabel/netlabel_mgmt.c
+++ b/net/netlabel/netlabel_mgmt.c
@@ -90,6 +90,7 @@ static const struct nla_policy netlbl_mgmt_genl_policy[NLBL_MGMT_A_MAX + 1] = {
 static int netlbl_mgmt_add_common(struct genl_info *info,
 				  struct netlbl_audit *audit_info)
 {
+	void *pmap = NULL;
 	int ret_val = -EINVAL;
 	struct netlbl_domaddr_map *addrmap = NULL;
 	struct cipso_v4_doi *cipsov4 = NULL;
@@ -189,6 +190,7 @@ static int netlbl_mgmt_add_common(struct genl_info *info,
 			ret_val = -ENOMEM;
 			goto add_free_addrmap;
 		}
+		pmap = map;
 		map->list.addr = addr->s_addr & mask->s_addr;
 		map->list.mask = mask->s_addr;
 		map->list.valid = 1;
@@ -197,10 +199,8 @@ static int netlbl_mgmt_add_common(struct genl_info *info,
 			map->def.cipso = cipsov4;
 
 		ret_val = netlbl_af4list_add(&map->list, &addrmap->list4);
-		if (ret_val != 0) {
-			kfree(map);
-			goto add_free_addrmap;
-		}
+		if (ret_val != 0)
+			goto add_free_map;
 
 		entry->family = AF_INET;
 		entry->def.type = NETLBL_NLTYPE_ADDRSELECT;
@@ -237,6 +237,7 @@ static int netlbl_mgmt_add_common(struct genl_info *info,
 			ret_val = -ENOMEM;
 			goto add_free_addrmap;
 		}
+		pmap = map;
 		map->list.addr = *addr;
 		map->list.addr.s6_addr32[0] &= mask->s6_addr32[0];
 		map->list.addr.s6_addr32[1] &= mask->s6_addr32[1];
@@ -249,10 +250,8 @@ static int netlbl_mgmt_add_common(struct genl_info *info,
 			map->def.calipso = calipso;
 
 		ret_val = netlbl_af6list_add(&map->list, &addrmap->list6);
-		if (ret_val != 0) {
-			kfree(map);
-			goto add_free_addrmap;
-		}
+		if (ret_val != 0)
+			goto add_free_map;
 
 		entry->family = AF_INET6;
 		entry->def.type = NETLBL_NLTYPE_ADDRSELECT;
@@ -262,10 +261,12 @@ static int netlbl_mgmt_add_common(struct genl_info *info,
 
 	ret_val = netlbl_domhsh_add(entry, audit_info);
 	if (ret_val != 0)
-		goto add_free_addrmap;
+		goto add_free_map;
 
 	return 0;
 
+add_free_map:
+	kfree(pmap);
 add_free_addrmap:
 	kfree(addrmap);
 add_doi_put_def:
diff --git a/net/sched/cls_tcindex.c b/net/sched/cls_tcindex.c
index 5b119efb20ee..9314a739c170 100644
--- a/net/sched/cls_tcindex.c
+++ b/net/sched/cls_tcindex.c
@@ -297,7 +297,7 @@ static int tcindex_alloc_perfect_hash(struct tcindex_data *cp)
 	int i, err = 0;
 
 	cp->perfect = kcalloc(cp->hash, sizeof(struct tcindex_filter_result),
-			      GFP_KERNEL);
+			      GFP_KERNEL | __GFP_NOWARN);
 	if (!cp->perfect)
 		return -ENOMEM;
 
diff --git a/net/sched/sch_qfq.c b/net/sched/sch_qfq.c
index 6ddfd4991108..1e1d6146189f 100644
--- a/net/sched/sch_qfq.c
+++ b/net/sched/sch_qfq.c
@@ -496,11 +496,6 @@ static int qfq_change_class(struct Qdisc *sch, u32 classid, u32 parentid,
 
 	if (cl->qdisc != &noop_qdisc)
 		qdisc_hash_add(cl->qdisc, true);
-	sch_tree_lock(sch);
-	qdisc_class_hash_insert(&q->clhash, &cl->common);
-	sch_tree_unlock(sch);
-
-	qdisc_class_hash_grow(sch, &q->clhash);
 
 set_change_agg:
 	sch_tree_lock(sch);
@@ -518,8 +513,11 @@ static int qfq_change_class(struct Qdisc *sch, u32 classid, u32 parentid,
 	}
 	if (existing)
 		qfq_deact_rm_from_agg(q, cl);
+	else
+		qdisc_class_hash_insert(&q->clhash, &cl->common);
 	qfq_add_to_agg(q, new_agg, cl);
 	sch_tree_unlock(sch);
+	qdisc_class_hash_grow(sch, &q->clhash);
 
 	*arg = (unsigned long)cl;
 	return 0;
diff --git a/net/sctp/bind_addr.c b/net/sctp/bind_addr.c
index 38d01cfb313e..f8a283245672 100644
--- a/net/sctp/bind_addr.c
+++ b/net/sctp/bind_addr.c
@@ -285,22 +285,19 @@ int sctp_raw_to_bind_addrs(struct sctp_bind_addr *bp, __u8 *raw_addr_list,
 		rawaddr = (union sctp_addr_param *)raw_addr_list;
 
 		af = sctp_get_af_specific(param_type2af(param->type));
-		if (unlikely(!af)) {
+		if (unlikely(!af) ||
+		    !af->from_addr_param(&addr, rawaddr, htons(port), 0)) {
 			retval = -EINVAL;
-			sctp_bind_addr_clean(bp);
-			break;
+			goto out_err;
 		}
 
-		af->from_addr_param(&addr, rawaddr, htons(port), 0);
 		if (sctp_bind_addr_state(bp, &addr) != -1)
 			goto next;
 		retval = sctp_add_bind_addr(bp, &addr, sizeof(addr),
 					    SCTP_ADDR_SRC, gfp);
-		if (retval) {
+		if (retval)
 			/* Can't finish building the list, clean up. */
-			sctp_bind_addr_clean(bp);
-			break;
-		}
+			goto out_err;
 
 next:
 		len = ntohs(param->length);
@@ -309,6 +306,12 @@ int sctp_raw_to_bind_addrs(struct sctp_bind_addr *bp, __u8 *raw_addr_list,
 	}
 
 	return retval;
+
+out_err:
+	if (retval)
+		sctp_bind_addr_clean(bp);
+
+	return retval;
 }
 
 /********************************************************************
diff --git a/net/sctp/input.c b/net/sctp/input.c
index fab6a34fb89f..1af35b69e99e 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -1081,7 +1081,8 @@ static struct sctp_association *__sctp_rcv_init_lookup(struct net *net,
 		if (!af)
 			continue;
 
-		af->from_addr_param(paddr, params.addr, sh->source, 0);
+		if (!af->from_addr_param(paddr, params.addr, sh->source, 0))
+			continue;
 
 		asoc = __sctp_lookup_association(net, laddr, paddr, transportp);
 		if (asoc)
@@ -1124,7 +1125,8 @@ static struct sctp_association *__sctp_rcv_asconf_lookup(
 	if (unlikely(!af))
 		return NULL;
 
-	af->from_addr_param(&paddr, param, peer_port, 0);
+	if (af->from_addr_param(&paddr, param, peer_port, 0))
+		return NULL;
 
 	return __sctp_lookup_association(net, laddr, &paddr, transportp);
 }
@@ -1195,7 +1197,7 @@ static struct sctp_association *__sctp_rcv_walk_lookup(struct net *net,
 
 		ch = (struct sctp_chunkhdr *)ch_end;
 		chunk_num++;
-	} while (ch_end < skb_tail_pointer(skb));
+	} while (ch_end + sizeof(*ch) < skb_tail_pointer(skb));
 
 	return asoc;
 }
diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index b61e9ed109f6..295466379ea0 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -490,15 +490,20 @@ static void sctp_v6_to_sk_daddr(union sctp_addr *addr, struct sock *sk)
 }
 
 /* Initialize a sctp_addr from an address parameter. */
-static void sctp_v6_from_addr_param(union sctp_addr *addr,
+static bool sctp_v6_from_addr_param(union sctp_addr *addr,
 				    union sctp_addr_param *param,
 				    __be16 port, int iif)
 {
+	if (ntohs(param->v6.param_hdr.length) < sizeof(struct sctp_ipv6addr_param))
+		return false;
+
 	addr->v6.sin6_family = AF_INET6;
 	addr->v6.sin6_port = port;
 	addr->v6.sin6_flowinfo = 0; /* BUG */
 	addr->v6.sin6_addr = param->v6.addr;
 	addr->v6.sin6_scope_id = iif;
+
+	return true;
 }
 
 /* Initialize an address parameter from a sctp_addr and return the length
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 8fe9c0646205..d5cf05efddfd 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -279,14 +279,19 @@ static void sctp_v4_to_sk_daddr(union sctp_addr *addr, struct sock *sk)
 }
 
 /* Initialize a sctp_addr from an address parameter. */
-static void sctp_v4_from_addr_param(union sctp_addr *addr,
+static bool sctp_v4_from_addr_param(union sctp_addr *addr,
 				    union sctp_addr_param *param,
 				    __be16 port, int iif)
 {
+	if (ntohs(param->v4.param_hdr.length) < sizeof(struct sctp_ipv4addr_param))
+		return false;
+
 	addr->v4.sin_family = AF_INET;
 	addr->v4.sin_port = port;
 	addr->v4.sin_addr.s_addr = param->v4.addr.s_addr;
 	memset(addr->v4.sin_zero, 0, sizeof(addr->v4.sin_zero));
+
+	return true;
 }
 
 /* Initialize an address parameter from a sctp_addr and return the length
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 1cd22a38fe42..3a7bee87054a 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -2341,11 +2341,13 @@ int sctp_process_init(struct sctp_association *asoc, struct sctp_chunk *chunk,
 
 	/* Process the initialization parameters.  */
 	sctp_walk_params(param, peer_init, init_hdr.params) {
-		if (!src_match && (param.p->type == SCTP_PARAM_IPV4_ADDRESS ||
-		    param.p->type == SCTP_PARAM_IPV6_ADDRESS)) {
+		if (!src_match &&
+		    (param.p->type == SCTP_PARAM_IPV4_ADDRESS ||
+		     param.p->type == SCTP_PARAM_IPV6_ADDRESS)) {
 			af = sctp_get_af_specific(param_type2af(param.p->type));
-			af->from_addr_param(&addr, param.addr,
-					    chunk->sctp_hdr->source, 0);
+			if (!af->from_addr_param(&addr, param.addr,
+						 chunk->sctp_hdr->source, 0))
+				continue;
 			if (sctp_cmp_addr_exact(sctp_source(chunk), &addr))
 				src_match = 1;
 		}
@@ -2523,7 +2525,8 @@ static int sctp_process_param(struct sctp_association *asoc,
 			break;
 do_addr_param:
 		af = sctp_get_af_specific(param_type2af(param.p->type));
-		af->from_addr_param(&addr, param.addr, htons(asoc->peer.port), 0);
+		if (!af->from_addr_param(&addr, param.addr, htons(asoc->peer.port), 0))
+			break;
 		scope = sctp_scope(peer_addr);
 		if (sctp_in_scope(net, &addr, scope))
 			if (!sctp_assoc_add_peer(asoc, &addr, gfp, SCTP_UNCONFIRMED))
@@ -2620,15 +2623,13 @@ static int sctp_process_param(struct sctp_association *asoc,
 		addr_param = param.v + sizeof(struct sctp_addip_param);
 
 		af = sctp_get_af_specific(param_type2af(addr_param->p.type));
-		if (af == NULL)
+		if (!af)
 			break;
 
-		af->from_addr_param(&addr, addr_param,
-				    htons(asoc->peer.port), 0);
+		if (!af->from_addr_param(&addr, addr_param,
+					 htons(asoc->peer.port), 0))
+			break;
 
-		/* if the address is invalid, we can't process it.
-		 * XXX: see spec for what to do.
-		 */
 		if (!af->addr_valid(&addr, NULL, NULL))
 			break;
 
@@ -3045,7 +3046,8 @@ static __be16 sctp_process_asconf_param(struct sctp_association *asoc,
 	if (unlikely(!af))
 		return SCTP_ERROR_DNS_FAILED;
 
-	af->from_addr_param(&addr, addr_param, htons(asoc->peer.port), 0);
+	if (!af->from_addr_param(&addr, addr_param, htons(asoc->peer.port), 0))
+		return SCTP_ERROR_DNS_FAILED;
 
 	/* ADDIP 4.2.1  This parameter MUST NOT contain a broadcast
 	 * or multicast address.
@@ -3310,7 +3312,8 @@ static void sctp_asconf_param_success(struct sctp_association *asoc,
 
 	/* We have checked the packet before, so we do not check again.	*/
 	af = sctp_get_af_specific(param_type2af(addr_param->p.type));
-	af->from_addr_param(&addr, addr_param, htons(bp->port), 0);
+	if (!af->from_addr_param(&addr, addr_param, htons(bp->port), 0))
+		return;
 
 	switch (asconf_param->param_hdr.type) {
 	case SCTP_PARAM_ADD_IP:
diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
index aff76fb43430..253132130c42 100644
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -486,11 +486,21 @@ static struct rpc_task *__rpc_find_next_queued_priority(struct rpc_wait_queue *q
 	struct list_head *q;
 	struct rpc_task *task;
 
+	/*
+	 * Service the privileged queue.
+	 */
+	q = &queue->tasks[RPC_NR_PRIORITY - 1];
+	if (queue->maxpriority > RPC_PRIORITY_PRIVILEGED && !list_empty(q)) {
+		task = list_first_entry(q, struct rpc_task, u.tk_wait.list);
+		goto out;
+	}
+
 	/*
 	 * Service a batch of tasks from a single owner.
 	 */
 	q = &queue->tasks[queue->priority];
-	if (!list_empty(q) && --queue->nr) {
+	if (!list_empty(q) && queue->nr) {
+		queue->nr--;
 		task = list_first_entry(q, struct rpc_task, u.tk_wait.list);
 		goto out;
 	}
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index ae85a5e5648b..02a171916dd2 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1232,7 +1232,7 @@ static int vsock_stream_connect(struct socket *sock, struct sockaddr *addr,
 
 		if (signal_pending(current)) {
 			err = sock_intr_errno(timeout);
-			sk->sk_state = TCP_CLOSE;
+			sk->sk_state = sk->sk_state == TCP_ESTABLISHED ? TCP_CLOSING : TCP_CLOSE;
 			sock->state = SS_UNCONNECTED;
 			vsock_transport_cancel_pkt(vsk);
 			goto out_wait;
diff --git a/net/wireless/wext-spy.c b/net/wireless/wext-spy.c
index 33bef22e44e9..b379a0371653 100644
--- a/net/wireless/wext-spy.c
+++ b/net/wireless/wext-spy.c
@@ -120,8 +120,8 @@ int iw_handler_set_thrspy(struct net_device *	dev,
 		return -EOPNOTSUPP;
 
 	/* Just do it */
-	memcpy(&(spydata->spy_thr_low), &(threshold->low),
-	       2 * sizeof(struct iw_quality));
+	spydata->spy_thr_low = threshold->low;
+	spydata->spy_thr_high = threshold->high;
 
 	/* Clear flag */
 	memset(spydata->spy_thr_under, '\0', sizeof(spydata->spy_thr_under));
@@ -147,8 +147,8 @@ int iw_handler_get_thrspy(struct net_device *	dev,
 		return -EOPNOTSUPP;
 
 	/* Just do it */
-	memcpy(&(threshold->low), &(spydata->spy_thr_low),
-	       2 * sizeof(struct iw_quality));
+	threshold->low = spydata->spy_thr_low;
+	threshold->high = spydata->spy_thr_high;
 
 	return 0;
 }
@@ -173,10 +173,10 @@ static void iw_send_thrspy_event(struct net_device *	dev,
 	memcpy(threshold.addr.sa_data, address, ETH_ALEN);
 	threshold.addr.sa_family = ARPHRD_ETHER;
 	/* Copy stats */
-	memcpy(&(threshold.qual), wstats, sizeof(struct iw_quality));
+	threshold.qual = *wstats;
 	/* Copy also thresholds */
-	memcpy(&(threshold.low), &(spydata->spy_thr_low),
-	       2 * sizeof(struct iw_quality));
+	threshold.low = spydata->spy_thr_low;
+	threshold.high = spydata->spy_thr_high;
 
 	/* Send event to user space */
 	wireless_send_event(dev, SIOCGIWTHRSPY, &wrqu, (char *) &threshold);
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 86084086a472..321fd881c638 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -566,6 +566,20 @@ static struct xfrm_state *xfrm_state_construct(struct net *net,
 
 	copy_from_user_state(x, p);
 
+	if (attrs[XFRMA_ENCAP]) {
+		x->encap = kmemdup(nla_data(attrs[XFRMA_ENCAP]),
+				   sizeof(*x->encap), GFP_KERNEL);
+		if (x->encap == NULL)
+			goto error;
+	}
+
+	if (attrs[XFRMA_COADDR]) {
+		x->coaddr = kmemdup(nla_data(attrs[XFRMA_COADDR]),
+				    sizeof(*x->coaddr), GFP_KERNEL);
+		if (x->coaddr == NULL)
+			goto error;
+	}
+
 	if (attrs[XFRMA_SA_EXTRA_FLAGS])
 		x->props.extra_flags = nla_get_u32(attrs[XFRMA_SA_EXTRA_FLAGS]);
 
@@ -586,23 +600,9 @@ static struct xfrm_state *xfrm_state_construct(struct net *net,
 				   attrs[XFRMA_ALG_COMP])))
 		goto error;
 
-	if (attrs[XFRMA_ENCAP]) {
-		x->encap = kmemdup(nla_data(attrs[XFRMA_ENCAP]),
-				   sizeof(*x->encap), GFP_KERNEL);
-		if (x->encap == NULL)
-			goto error;
-	}
-
 	if (attrs[XFRMA_TFCPAD])
 		x->tfcpad = nla_get_u32(attrs[XFRMA_TFCPAD]);
 
-	if (attrs[XFRMA_COADDR]) {
-		x->coaddr = kmemdup(nla_data(attrs[XFRMA_COADDR]),
-				    sizeof(*x->coaddr), GFP_KERNEL);
-		if (x->coaddr == NULL)
-			goto error;
-	}
-
 	xfrm_mark_get(attrs, &x->mark);
 
 	if (attrs[XFRMA_OUTPUT_MARK])
diff --git a/samples/bpf/xdp_redirect_user.c b/samples/bpf/xdp_redirect_user.c
index 4475d837bf2c..bd9fa7a55a30 100644
--- a/samples/bpf/xdp_redirect_user.c
+++ b/samples/bpf/xdp_redirect_user.c
@@ -139,5 +139,5 @@ int main(int argc, char **argv)
 	poll_stats(2, ifindex_out);
 
 out:
-	return 0;
+	return ret;
 }
diff --git a/security/selinux/avc.c b/security/selinux/avc.c
index 23f387b30ece..af70b4210f99 100644
--- a/security/selinux/avc.c
+++ b/security/selinux/avc.c
@@ -346,26 +346,27 @@ static struct avc_xperms_decision_node
 	struct avc_xperms_decision_node *xpd_node;
 	struct extended_perms_decision *xpd;
 
-	xpd_node = kmem_cache_zalloc(avc_xperms_decision_cachep, GFP_NOWAIT);
+	xpd_node = kmem_cache_zalloc(avc_xperms_decision_cachep,
+				     GFP_NOWAIT | __GFP_NOWARN);
 	if (!xpd_node)
 		return NULL;
 
 	xpd = &xpd_node->xpd;
 	if (which & XPERMS_ALLOWED) {
 		xpd->allowed = kmem_cache_zalloc(avc_xperms_data_cachep,
-						GFP_NOWAIT);
+						GFP_NOWAIT | __GFP_NOWARN);
 		if (!xpd->allowed)
 			goto error;
 	}
 	if (which & XPERMS_AUDITALLOW) {
 		xpd->auditallow = kmem_cache_zalloc(avc_xperms_data_cachep,
-						GFP_NOWAIT);
+						GFP_NOWAIT | __GFP_NOWARN);
 		if (!xpd->auditallow)
 			goto error;
 	}
 	if (which & XPERMS_DONTAUDIT) {
 		xpd->dontaudit = kmem_cache_zalloc(avc_xperms_data_cachep,
-						GFP_NOWAIT);
+						GFP_NOWAIT | __GFP_NOWARN);
 		if (!xpd->dontaudit)
 			goto error;
 	}
@@ -393,7 +394,7 @@ static struct avc_xperms_node *avc_xperms_alloc(void)
 {
 	struct avc_xperms_node *xp_node;
 
-	xp_node = kmem_cache_zalloc(avc_xperms_cachep, GFP_NOWAIT);
+	xp_node = kmem_cache_zalloc(avc_xperms_cachep, GFP_NOWAIT | __GFP_NOWARN);
 	if (!xp_node)
 		return xp_node;
 	INIT_LIST_HEAD(&xp_node->xpd_head);
@@ -546,7 +547,7 @@ static struct avc_node *avc_alloc_node(void)
 {
 	struct avc_node *node;
 
-	node = kmem_cache_zalloc(avc_node_cachep, GFP_NOWAIT);
+	node = kmem_cache_zalloc(avc_node_cachep, GFP_NOWAIT | __GFP_NOWARN);
 	if (!node)
 		goto out;
 
diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index 4f8c1a272df0..009e83ee2d00 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -883,6 +883,8 @@ static ssize_t smk_set_cipso(struct file *file, const char __user *buf,
 	if (format == SMK_FIXED24_FMT &&
 	    (count < SMK_CIPSOMIN || count > SMK_CIPSOMAX))
 		return -EINVAL;
+	if (count > PAGE_SIZE)
+		return -EINVAL;
 
 	data = memdup_user_nul(buf, count);
 	if (IS_ERR(data))
diff --git a/sound/firewire/Kconfig b/sound/firewire/Kconfig
index a2ed164d80b4..f7b26b1d7084 100644
--- a/sound/firewire/Kconfig
+++ b/sound/firewire/Kconfig
@@ -37,7 +37,7 @@ config SND_OXFW
 	   * Mackie(Loud) Onyx 1640i (former model)
 	   * Mackie(Loud) Onyx Satellite
 	   * Mackie(Loud) Tapco Link.Firewire
-	   * Mackie(Loud) d.4 pro
+	   * Mackie(Loud) d.2 pro/d.4 pro (built-in FireWire card with OXFW971 ASIC)
 	   * Mackie(Loud) U.420/U.420d
 	   * TASCAM FireOne
 	   * Stanton Controllers & Systems 1 Deck/Mixer
@@ -83,7 +83,7 @@ config SND_BEBOB
 	  * PreSonus FIREBOX/FIREPOD/FP10/Inspire1394
 	  * BridgeCo RDAudio1/Audio5
 	  * Mackie Onyx 1220/1620/1640 (FireWire I/O Card)
-	  * Mackie d.2 (FireWire Option) and d.2 Pro
+	  * Mackie d.2 (optional FireWire card with DM1000 ASIC)
 	  * Stanton FinalScratch 2 (ScratchAmp)
 	  * Tascam IF-FW/DM
 	  * Behringer XENIX UFX 1204/1604
@@ -109,6 +109,7 @@ config SND_BEBOB
 	  * M-Audio Ozonic/NRV10/ProfireLightBridge
 	  * M-Audio FireWire 1814/ProjectMix IO
 	  * Digidesign Mbox 2 Pro
+	  * ToneWeal FW66
 
           To compile this driver as a module, choose M here: the module
           will be called snd-bebob.
diff --git a/sound/firewire/bebob/bebob.c b/sound/firewire/bebob/bebob.c
index 2bcfeee75853..eac3ff24e55d 100644
--- a/sound/firewire/bebob/bebob.c
+++ b/sound/firewire/bebob/bebob.c
@@ -60,6 +60,7 @@ static DECLARE_BITMAP(devices_used, SNDRV_CARDS);
 #define VEN_MAUDIO1	0x00000d6c
 #define VEN_MAUDIO2	0x000007f5
 #define VEN_DIGIDESIGN	0x00a07e
+#define OUI_SHOUYO	0x002327
 
 #define MODEL_FOCUSRITE_SAFFIRE_BOTH	0x00000000
 #define MODEL_MAUDIO_AUDIOPHILE_BOTH	0x00010060
@@ -414,7 +415,7 @@ static const struct ieee1394_device_id bebob_id_table[] = {
 	SND_BEBOB_DEV_ENTRY(VEN_BRIDGECO, 0x00010049, &spec_normal),
 	/* Mackie, Onyx 1220/1620/1640 (Firewire I/O Card) */
 	SND_BEBOB_DEV_ENTRY(VEN_MACKIE2, 0x00010065, &spec_normal),
-	// Mackie, d.2 (Firewire option card) and d.2 Pro (the card is built-in).
+	// Mackie, d.2 (optional Firewire card with DM1000).
 	SND_BEBOB_DEV_ENTRY(VEN_MACKIE1, 0x00010067, &spec_normal),
 	/* Stanton, ScratchAmp */
 	SND_BEBOB_DEV_ENTRY(VEN_STANTON, 0x00000001, &spec_normal),
@@ -513,6 +514,8 @@ static const struct ieee1394_device_id bebob_id_table[] = {
 			    &maudio_special_spec),
 	/* Digidesign Mbox 2 Pro */
 	SND_BEBOB_DEV_ENTRY(VEN_DIGIDESIGN, 0x0000a9, &spec_normal),
+	// Toneweal FW66.
+	SND_BEBOB_DEV_ENTRY(OUI_SHOUYO, 0x020002, &spec_normal),
 	/* IDs are unknown but able to be supported */
 	/*  Apogee, Mini-ME Firewire */
 	/*  Apogee, Mini-DAC Firewire */
diff --git a/sound/firewire/oxfw/oxfw.c b/sound/firewire/oxfw/oxfw.c
index a52021af4467..74d588bea6a4 100644
--- a/sound/firewire/oxfw/oxfw.c
+++ b/sound/firewire/oxfw/oxfw.c
@@ -406,7 +406,7 @@ static const struct ieee1394_device_id oxfw_id_table[] = {
 	 *  Onyx-i series (former models):	0x081216
 	 *  Mackie Onyx Satellite:		0x00200f
 	 *  Tapco LINK.firewire 4x6:		0x000460
-	 *  d.4 pro:				Unknown
+	 *  d.2 pro/d.4 pro (built-in card):	Unknown
 	 *  U.420:				Unknown
 	 *  U.420d:				Unknown
 	 */
diff --git a/sound/isa/cmi8330.c b/sound/isa/cmi8330.c
index 6b8c46942efb..75b3d76eb852 100644
--- a/sound/isa/cmi8330.c
+++ b/sound/isa/cmi8330.c
@@ -564,7 +564,7 @@ static int snd_cmi8330_probe(struct snd_card *card, int dev)
 	}
 	if (acard->sb->hardware != SB_HW_16) {
 		snd_printk(KERN_ERR PFX "SB16 not found during probe\n");
-		return err;
+		return -ENODEV;
 	}
 
 	snd_wss_out(acard->wss, CS4231_MISC_INFO, 0x40); /* switch on MODE2 */
diff --git a/sound/isa/sb/sb16_csp.c b/sound/isa/sb/sb16_csp.c
index 5450f58e4f2e..69f392cf67b6 100644
--- a/sound/isa/sb/sb16_csp.c
+++ b/sound/isa/sb/sb16_csp.c
@@ -1086,10 +1086,14 @@ static void snd_sb_qsound_destroy(struct snd_sb_csp * p)
 	card = p->chip->card;	
 	
 	down_write(&card->controls_rwsem);
-	if (p->qsound_switch)
+	if (p->qsound_switch) {
 		snd_ctl_remove(card, p->qsound_switch);
-	if (p->qsound_space)
+		p->qsound_switch = NULL;
+	}
+	if (p->qsound_space) {
 		snd_ctl_remove(card, p->qsound_space);
+		p->qsound_space = NULL;
+	}
 	up_write(&card->controls_rwsem);
 
 	/* cancel pending transfer of QSound parameters */
diff --git a/sound/pci/hda/hda_tegra.c b/sound/pci/hda/hda_tegra.c
index e85fb04ec7be..b567c4bdae00 100644
--- a/sound/pci/hda/hda_tegra.c
+++ b/sound/pci/hda/hda_tegra.c
@@ -363,6 +363,9 @@ static int hda_tegra_first_init(struct azx *chip, struct platform_device *pdev)
 	unsigned short gcap;
 	int irq_id = platform_get_irq(pdev, 0);
 
+	if (irq_id < 0)
+		return irq_id;
+
 	err = hda_tegra_init_chip(chip, pdev);
 	if (err)
 		return err;
diff --git a/sound/ppc/powermac.c b/sound/ppc/powermac.c
index 33c6be9fb388..7c70ba5e2540 100644
--- a/sound/ppc/powermac.c
+++ b/sound/ppc/powermac.c
@@ -90,7 +90,11 @@ static int snd_pmac_probe(struct platform_device *devptr)
 		sprintf(card->shortname, "PowerMac %s", name_ext);
 		sprintf(card->longname, "%s (Dev %d) Sub-frame %d",
 			card->shortname, chip->device_id, chip->subframe);
-		if ( snd_pmac_tumbler_init(chip) < 0 || snd_pmac_tumbler_post_init() < 0)
+		err = snd_pmac_tumbler_init(chip);
+		if (err < 0)
+			goto __error;
+		err = snd_pmac_tumbler_post_init();
+		if (err < 0)
 			goto __error;
 		break;
 	case PMAC_AWACS:
diff --git a/sound/soc/codecs/cs42l42.h b/sound/soc/codecs/cs42l42.h
index 3d5fa343db96..72d3778e10ad 100644
--- a/sound/soc/codecs/cs42l42.h
+++ b/sound/soc/codecs/cs42l42.h
@@ -81,7 +81,7 @@
 #define CS42L42_HP_PDN_SHIFT		3
 #define CS42L42_HP_PDN_MASK		(1 << CS42L42_HP_PDN_SHIFT)
 #define CS42L42_ADC_PDN_SHIFT		2
-#define CS42L42_ADC_PDN_MASK		(1 << CS42L42_HP_PDN_SHIFT)
+#define CS42L42_ADC_PDN_MASK		(1 << CS42L42_ADC_PDN_SHIFT)
 #define CS42L42_PDN_ALL_SHIFT		0
 #define CS42L42_PDN_ALL_MASK		(1 << CS42L42_PDN_ALL_SHIFT)
 
diff --git a/sound/soc/hisilicon/hi6210-i2s.c b/sound/soc/hisilicon/hi6210-i2s.c
index 0c8f86d4020e..d8d14cdee786 100644
--- a/sound/soc/hisilicon/hi6210-i2s.c
+++ b/sound/soc/hisilicon/hi6210-i2s.c
@@ -111,18 +111,15 @@ static int hi6210_i2s_startup(struct snd_pcm_substream *substream,
 
 	for (n = 0; n < i2s->clocks; n++) {
 		ret = clk_prepare_enable(i2s->clk[n]);
-		if (ret) {
-			while (n--)
-				clk_disable_unprepare(i2s->clk[n]);
-			return ret;
-		}
+		if (ret)
+			goto err_unprepare_clk;
 	}
 
 	ret = clk_set_rate(i2s->clk[CLK_I2S_BASE], 49152000);
 	if (ret) {
 		dev_err(i2s->dev, "%s: setting 49.152MHz base rate failed %d\n",
 			__func__, ret);
-		return ret;
+		goto err_unprepare_clk;
 	}
 
 	/* enable clock before frequency division */
@@ -174,6 +171,11 @@ static int hi6210_i2s_startup(struct snd_pcm_substream *substream,
 	hi6210_write_reg(i2s, HII2S_SW_RST_N, val);
 
 	return 0;
+
+err_unprepare_clk:
+	while (n--)
+		clk_disable_unprepare(i2s->clk[n]);
+	return ret;
 }
 
 static void hi6210_i2s_shutdown(struct snd_pcm_substream *substream,
diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index 42c2a3065b77..2a172de37466 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -4046,7 +4046,7 @@ int snd_soc_of_parse_audio_routing(struct snd_soc_card *card,
 	if (!routes) {
 		dev_err(card->dev,
 			"ASoC: Could not allocate DAPM route table\n");
-		return -EINVAL;
+		return -ENOMEM;
 	}
 
 	for (i = 0; i < num_routes; i++) {
diff --git a/sound/soc/tegra/tegra_alc5632.c b/sound/soc/tegra/tegra_alc5632.c
index 5197d6b18cb6..f9536876223f 100644
--- a/sound/soc/tegra/tegra_alc5632.c
+++ b/sound/soc/tegra/tegra_alc5632.c
@@ -137,6 +137,7 @@ static struct snd_soc_dai_link tegra_alc5632_dai = {
 
 static struct snd_soc_card snd_soc_tegra_alc5632 = {
 	.name = "tegra-alc5632",
+	.driver_name = "tegra",
 	.owner = THIS_MODULE,
 	.dai_link = &tegra_alc5632_dai,
 	.num_links = 1,
diff --git a/sound/soc/tegra/tegra_max98090.c b/sound/soc/tegra/tegra_max98090.c
index cf142e2c7bd7..10998d703dcd 100644
--- a/sound/soc/tegra/tegra_max98090.c
+++ b/sound/soc/tegra/tegra_max98090.c
@@ -188,6 +188,7 @@ static struct snd_soc_dai_link tegra_max98090_dai = {
 
 static struct snd_soc_card snd_soc_tegra_max98090 = {
 	.name = "tegra-max98090",
+	.driver_name = "tegra",
 	.owner = THIS_MODULE,
 	.dai_link = &tegra_max98090_dai,
 	.num_links = 1,
diff --git a/sound/soc/tegra/tegra_rt5640.c b/sound/soc/tegra/tegra_rt5640.c
index fc81b48aa9d6..e0cbe85b6d46 100644
--- a/sound/soc/tegra/tegra_rt5640.c
+++ b/sound/soc/tegra/tegra_rt5640.c
@@ -138,6 +138,7 @@ static struct snd_soc_dai_link tegra_rt5640_dai = {
 
 static struct snd_soc_card snd_soc_tegra_rt5640 = {
 	.name = "tegra-rt5640",
+	.driver_name = "tegra",
 	.owner = THIS_MODULE,
 	.dai_link = &tegra_rt5640_dai,
 	.num_links = 1,
diff --git a/sound/soc/tegra/tegra_rt5677.c b/sound/soc/tegra/tegra_rt5677.c
index 0e4805c7b4ca..50e5f9769eed 100644
--- a/sound/soc/tegra/tegra_rt5677.c
+++ b/sound/soc/tegra/tegra_rt5677.c
@@ -181,6 +181,7 @@ static struct snd_soc_dai_link tegra_rt5677_dai = {
 
 static struct snd_soc_card snd_soc_tegra_rt5677 = {
 	.name = "tegra-rt5677",
+	.driver_name = "tegra",
 	.owner = THIS_MODULE,
 	.dai_link = &tegra_rt5677_dai,
 	.num_links = 1,
diff --git a/sound/soc/tegra/tegra_sgtl5000.c b/sound/soc/tegra/tegra_sgtl5000.c
index 901457da25ec..e6cbc89eaa92 100644
--- a/sound/soc/tegra/tegra_sgtl5000.c
+++ b/sound/soc/tegra/tegra_sgtl5000.c
@@ -103,6 +103,7 @@ static struct snd_soc_dai_link tegra_sgtl5000_dai = {
 
 static struct snd_soc_card snd_soc_tegra_sgtl5000 = {
 	.name = "tegra-sgtl5000",
+	.driver_name = "tegra",
 	.owner = THIS_MODULE,
 	.dai_link = &tegra_sgtl5000_dai,
 	.num_links = 1,
diff --git a/sound/soc/tegra/tegra_wm8753.c b/sound/soc/tegra/tegra_wm8753.c
index 23a810e3bacc..3fa0e991308a 100644
--- a/sound/soc/tegra/tegra_wm8753.c
+++ b/sound/soc/tegra/tegra_wm8753.c
@@ -110,6 +110,7 @@ static struct snd_soc_dai_link tegra_wm8753_dai = {
 
 static struct snd_soc_card snd_soc_tegra_wm8753 = {
 	.name = "tegra-wm8753",
+	.driver_name = "tegra",
 	.owner = THIS_MODULE,
 	.dai_link = &tegra_wm8753_dai,
 	.num_links = 1,
diff --git a/sound/soc/tegra/tegra_wm8903.c b/sound/soc/tegra/tegra_wm8903.c
index 18bdae59a4df..161e53029ae8 100644
--- a/sound/soc/tegra/tegra_wm8903.c
+++ b/sound/soc/tegra/tegra_wm8903.c
@@ -222,6 +222,7 @@ static struct snd_soc_dai_link tegra_wm8903_dai = {
 
 static struct snd_soc_card snd_soc_tegra_wm8903 = {
 	.name = "tegra-wm8903",
+	.driver_name = "tegra",
 	.owner = THIS_MODULE,
 	.dai_link = &tegra_wm8903_dai,
 	.num_links = 1,
diff --git a/sound/soc/tegra/tegra_wm9712.c b/sound/soc/tegra/tegra_wm9712.c
index 864a3345972e..7175e6eea911 100644
--- a/sound/soc/tegra/tegra_wm9712.c
+++ b/sound/soc/tegra/tegra_wm9712.c
@@ -59,6 +59,7 @@ static struct snd_soc_dai_link tegra_wm9712_dai = {
 
 static struct snd_soc_card snd_soc_tegra_wm9712 = {
 	.name = "tegra-wm9712",
+	.driver_name = "tegra",
 	.owner = THIS_MODULE,
 	.dai_link = &tegra_wm9712_dai,
 	.num_links = 1,
diff --git a/sound/soc/tegra/trimslice.c b/sound/soc/tegra/trimslice.c
index 99bcdd979eb2..47ef6d6f4ae1 100644
--- a/sound/soc/tegra/trimslice.c
+++ b/sound/soc/tegra/trimslice.c
@@ -103,6 +103,7 @@ static struct snd_soc_dai_link trimslice_tlv320aic23_dai = {
 
 static struct snd_soc_card snd_soc_trimslice = {
 	.name = "tegra-trimslice",
+	.driver_name = "tegra",
 	.owner = THIS_MODULE,
 	.dai_link = &trimslice_tlv320aic23_dai,
 	.num_links = 1,
diff --git a/sound/usb/format.c b/sound/usb/format.c
index 06190e3fd919..56b5baee6552 100644
--- a/sound/usb/format.c
+++ b/sound/usb/format.c
@@ -189,9 +189,11 @@ static int parse_audio_format_rates_v1(struct snd_usb_audio *chip, struct audiof
 				continue;
 			/* C-Media CM6501 mislabels its 96 kHz altsetting */
 			/* Terratec Aureon 7.1 USB C-Media 6206, too */
+			/* Ozone Z90 USB C-Media, too */
 			if (rate == 48000 && nr_rates == 1 &&
 			    (chip->usb_id == USB_ID(0x0d8c, 0x0201) ||
 			     chip->usb_id == USB_ID(0x0d8c, 0x0102) ||
+			     chip->usb_id == USB_ID(0x0d8c, 0x0078) ||
 			     chip->usb_id == USB_ID(0x0ccd, 0x00b1)) &&
 			    fp->altsetting == 5 && fp->maxpacksize == 392)
 				rate = 96000;
diff --git a/tools/testing/selftests/powerpc/pmu/ebb/no_handler_test.c b/tools/testing/selftests/powerpc/pmu/ebb/no_handler_test.c
index 8341d7778d5e..87630d44fb4c 100644
--- a/tools/testing/selftests/powerpc/pmu/ebb/no_handler_test.c
+++ b/tools/testing/selftests/powerpc/pmu/ebb/no_handler_test.c
@@ -50,8 +50,6 @@ static int no_handler_test(void)
 
 	event_close(&event);
 
-	dump_ebb_state();
-
 	/* The real test is that we never took an EBB at 0x0 */
 
 	return 0;
diff --git a/tools/testing/selftests/x86/protection_keys.c b/tools/testing/selftests/x86/protection_keys.c
index b8778960da10..27661302a698 100644
--- a/tools/testing/selftests/x86/protection_keys.c
+++ b/tools/testing/selftests/x86/protection_keys.c
@@ -613,7 +613,6 @@ int alloc_random_pkey(void)
 	int nr_alloced = 0;
 	int random_index;
 	memset(alloced_pkeys, 0, sizeof(alloced_pkeys));
-	srand((unsigned int)time(NULL));
 
 	/* allocate every possible key and make a note of which ones we got */
 	max_nr_pkey_allocs = NR_PKEYS;
@@ -1479,6 +1478,8 @@ int main(void)
 {
 	int nr_iterations = 22;
 
+	srand((unsigned int)time(NULL));
+
 	setup_handlers();
 
 	printf("has pku: %d\n", cpu_has_pku());
