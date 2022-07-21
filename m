Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A84E57D44A
	for <lists+stable@lfdr.de>; Thu, 21 Jul 2022 21:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbiGUTi6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jul 2022 15:38:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiGUTi5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Jul 2022 15:38:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97C1537F9F;
        Thu, 21 Jul 2022 12:38:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7ED93620A7;
        Thu, 21 Jul 2022 19:38:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A2B4C3411E;
        Thu, 21 Jul 2022 19:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658432331;
        bh=dOec9OwXdoYDioAxRRYncZWPSzIUISnG3i93nGRccws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ITJyiYRz6riuULuTIVPTuawHOY16FN+p8/q/ezJ0hP8kBkIOx6B2z9sNlMjf2c1Q+
         QO1kYj381aCS5ENp9/9OY+fvu46pbDdy3+B9+Y3tHgiPHR2pPxeEzW4Mh0y4R0/LrW
         PnDgSRZiawNArUZ3zX7QAoICxvHEtbI6qHZcmgfo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.56
Date:   Thu, 21 Jul 2022 21:28:22 +0200
Message-Id: <165843170147164@kroah.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <165843170118@kroah.com>
References: <165843170118@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_FILL_THIS_FORM_SHORT autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Documentation/driver-api/firmware/other_interfaces.rst b/Documentation/driver-api/firmware/other_interfaces.rst
index b81794e0cfbb..06ac89adaafb 100644
--- a/Documentation/driver-api/firmware/other_interfaces.rst
+++ b/Documentation/driver-api/firmware/other_interfaces.rst
@@ -13,6 +13,12 @@ EDD Interfaces
 .. kernel-doc:: drivers/firmware/edd.c
    :internal:
 
+Generic System Framebuffers Interface
+-------------------------------------
+
+.. kernel-doc:: drivers/firmware/sysfb.c
+   :export:
+
 Intel Stratix10 SoC Service Layer
 ---------------------------------
 Some features of the Intel Stratix10 SoC require a level of privilege
diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index d91ab28718d4..b8b67041f955 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -1063,7 +1063,7 @@ cipso_cache_enable - BOOLEAN
 cipso_cache_bucket_size - INTEGER
 	The CIPSO label cache consists of a fixed size hash table with each
 	hash bucket containing a number of cache entries.  This variable limits
-	the number of entries in each hash bucket; the larger the value the
+	the number of entries in each hash bucket; the larger the value is, the
 	more CIPSO label mappings that can be cached.  When the number of
 	entries in a given hash bucket reaches this limit adding new entries
 	causes the oldest entry in the bucket to be removed to make room.
@@ -1157,7 +1157,7 @@ ip_autobind_reuse - BOOLEAN
 	option should only be set by experts.
 	Default: 0
 
-ip_dynaddr - BOOLEAN
+ip_dynaddr - INTEGER
 	If set non-zero, enables support for dynamic addresses.
 	If set to a non-zero value larger than 1, a kernel log
 	message will be printed when dynamic address rewriting
diff --git a/Makefile b/Makefile
index c95f0f59885f..2ce44168b1b5 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 55
+SUBLEVEL = 56
 EXTRAVERSION =
 NAME = Trick or Treat
 
diff --git a/arch/arm/boot/dts/imx6qdl-ts7970.dtsi b/arch/arm/boot/dts/imx6qdl-ts7970.dtsi
index fded07f370b3..d6ba4b2a60f6 100644
--- a/arch/arm/boot/dts/imx6qdl-ts7970.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-ts7970.dtsi
@@ -226,7 +226,7 @@ gpio8: gpio@28 {
 		reg = <0x28>;
 		#gpio-cells = <2>;
 		gpio-controller;
-		ngpio = <32>;
+		ngpios = <62>;
 	};
 
 	sgtl5000: codec@a {
diff --git a/arch/arm/boot/dts/sama5d2.dtsi b/arch/arm/boot/dts/sama5d2.dtsi
index de88eb484718..4c87c2aa8fc8 100644
--- a/arch/arm/boot/dts/sama5d2.dtsi
+++ b/arch/arm/boot/dts/sama5d2.dtsi
@@ -1125,7 +1125,7 @@ AT91_XDMAC_DT_PERID(33))>,
 				clocks = <&pmc PMC_TYPE_PERIPHERAL 55>, <&pmc PMC_TYPE_GCK 55>;
 				clock-names = "pclk", "gclk";
 				assigned-clocks = <&pmc PMC_TYPE_CORE PMC_I2S1_MUX>;
-				assigned-parrents = <&pmc PMC_TYPE_GCK 55>;
+				assigned-clock-parents = <&pmc PMC_TYPE_GCK 55>;
 				status = "disabled";
 			};
 
diff --git a/arch/arm/boot/dts/stm32mp151.dtsi b/arch/arm/boot/dts/stm32mp151.dtsi
index a9b65b3bfda5..e0d483318798 100644
--- a/arch/arm/boot/dts/stm32mp151.dtsi
+++ b/arch/arm/boot/dts/stm32mp151.dtsi
@@ -553,7 +553,7 @@ cec: cec@40016000 {
 			compatible = "st,stm32-cec";
 			reg = <0x40016000 0x400>;
 			interrupts = <GIC_SPI 94 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&rcc CEC_K>, <&clk_lse>;
+			clocks = <&rcc CEC_K>, <&rcc CEC>;
 			clock-names = "cec", "hdmi-cec";
 			status = "disabled";
 		};
diff --git a/arch/arm/boot/dts/sun8i-h2-plus-orangepi-zero.dts b/arch/arm/boot/dts/sun8i-h2-plus-orangepi-zero.dts
index f19ed981da9d..3706216ffb40 100644
--- a/arch/arm/boot/dts/sun8i-h2-plus-orangepi-zero.dts
+++ b/arch/arm/boot/dts/sun8i-h2-plus-orangepi-zero.dts
@@ -169,7 +169,7 @@ &spi0 {
 	flash@0 {
 		#address-cells = <1>;
 		#size-cells = <1>;
-		compatible = "mxicy,mx25l1606e", "winbond,w25q128";
+		compatible = "mxicy,mx25l1606e", "jedec,spi-nor";
 		reg = <0>;
 		spi-max-frequency = <40000000>;
 	};
diff --git a/arch/arm/include/asm/mach/map.h b/arch/arm/include/asm/mach/map.h
index 92282558caf7..2b8970d8e5a2 100644
--- a/arch/arm/include/asm/mach/map.h
+++ b/arch/arm/include/asm/mach/map.h
@@ -27,6 +27,7 @@ enum {
 	MT_HIGH_VECTORS,
 	MT_MEMORY_RWX,
 	MT_MEMORY_RW,
+	MT_MEMORY_RO,
 	MT_ROM,
 	MT_MEMORY_RWX_NONCACHED,
 	MT_MEMORY_RW_DTCM,
diff --git a/arch/arm/include/asm/ptrace.h b/arch/arm/include/asm/ptrace.h
index 93051e2f402c..1408a6a15d0e 100644
--- a/arch/arm/include/asm/ptrace.h
+++ b/arch/arm/include/asm/ptrace.h
@@ -163,5 +163,31 @@ static inline unsigned long user_stack_pointer(struct pt_regs *regs)
 		((current_stack_pointer | (THREAD_SIZE - 1)) - 7) - 1;	\
 })
 
+
+/*
+ * Update ITSTATE after normal execution of an IT block instruction.
+ *
+ * The 8 IT state bits are split into two parts in CPSR:
+ *	ITSTATE<1:0> are in CPSR<26:25>
+ *	ITSTATE<7:2> are in CPSR<15:10>
+ */
+static inline unsigned long it_advance(unsigned long cpsr)
+{
+	if ((cpsr & 0x06000400) == 0) {
+		/* ITSTATE<2:0> == 0 means end of IT block, so clear IT state */
+		cpsr &= ~PSR_IT_MASK;
+	} else {
+		/* We need to shift left ITSTATE<4:0> */
+		const unsigned long mask = 0x06001c00;  /* Mask ITSTATE<4:0> */
+		unsigned long it = cpsr & mask;
+		it <<= 1;
+		it |= it >> (27 - 10);  /* Carry ITSTATE<2> to correct place */
+		it &= mask;
+		cpsr &= ~mask;
+		cpsr |= it;
+	}
+	return cpsr;
+}
+
 #endif /* __ASSEMBLY__ */
 #endif
diff --git a/arch/arm/mm/alignment.c b/arch/arm/mm/alignment.c
index ea81e89e7740..bcefe3f51744 100644
--- a/arch/arm/mm/alignment.c
+++ b/arch/arm/mm/alignment.c
@@ -935,6 +935,9 @@ do_alignment(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 	if (type == TYPE_LDST)
 		do_alignment_finish_ldst(addr, instr, regs, offset);
 
+	if (thumb_mode(regs))
+		regs->ARM_cpsr = it_advance(regs->ARM_cpsr);
+
 	return 0;
 
  bad_or_fault:
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index 5e2be37a198e..cd17e324aa51 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -296,6 +296,13 @@ static struct mem_type mem_types[] __ro_after_init = {
 		.prot_sect = PMD_TYPE_SECT | PMD_SECT_AP_WRITE,
 		.domain    = DOMAIN_KERNEL,
 	},
+	[MT_MEMORY_RO] = {
+		.prot_pte  = L_PTE_PRESENT | L_PTE_YOUNG | L_PTE_DIRTY |
+			     L_PTE_XN | L_PTE_RDONLY,
+		.prot_l1   = PMD_TYPE_TABLE,
+		.prot_sect = PMD_TYPE_SECT,
+		.domain    = DOMAIN_KERNEL,
+	},
 	[MT_ROM] = {
 		.prot_sect = PMD_TYPE_SECT,
 		.domain    = DOMAIN_KERNEL,
@@ -489,6 +496,7 @@ static void __init build_mem_type_table(void)
 
 			/* Also setup NX memory mapping */
 			mem_types[MT_MEMORY_RW].prot_sect |= PMD_SECT_XN;
+			mem_types[MT_MEMORY_RO].prot_sect |= PMD_SECT_XN;
 		}
 		if (cpu_arch >= CPU_ARCH_ARMv7 && (cr & CR_TRE)) {
 			/*
@@ -568,6 +576,7 @@ static void __init build_mem_type_table(void)
 		mem_types[MT_ROM].prot_sect |= PMD_SECT_APX|PMD_SECT_AP_WRITE;
 		mem_types[MT_MINICLEAN].prot_sect |= PMD_SECT_APX|PMD_SECT_AP_WRITE;
 		mem_types[MT_CACHECLEAN].prot_sect |= PMD_SECT_APX|PMD_SECT_AP_WRITE;
+		mem_types[MT_MEMORY_RO].prot_sect |= PMD_SECT_APX|PMD_SECT_AP_WRITE;
 #endif
 
 		/*
@@ -587,6 +596,8 @@ static void __init build_mem_type_table(void)
 			mem_types[MT_MEMORY_RWX].prot_pte |= L_PTE_SHARED;
 			mem_types[MT_MEMORY_RW].prot_sect |= PMD_SECT_S;
 			mem_types[MT_MEMORY_RW].prot_pte |= L_PTE_SHARED;
+			mem_types[MT_MEMORY_RO].prot_sect |= PMD_SECT_S;
+			mem_types[MT_MEMORY_RO].prot_pte |= L_PTE_SHARED;
 			mem_types[MT_MEMORY_DMA_READY].prot_pte |= L_PTE_SHARED;
 			mem_types[MT_MEMORY_RWX_NONCACHED].prot_sect |= PMD_SECT_S;
 			mem_types[MT_MEMORY_RWX_NONCACHED].prot_pte |= L_PTE_SHARED;
@@ -647,6 +658,8 @@ static void __init build_mem_type_table(void)
 	mem_types[MT_MEMORY_RWX].prot_pte |= kern_pgprot;
 	mem_types[MT_MEMORY_RW].prot_sect |= ecc_mask | cp->pmd;
 	mem_types[MT_MEMORY_RW].prot_pte |= kern_pgprot;
+	mem_types[MT_MEMORY_RO].prot_sect |= ecc_mask | cp->pmd;
+	mem_types[MT_MEMORY_RO].prot_pte |= kern_pgprot;
 	mem_types[MT_MEMORY_DMA_READY].prot_pte |= kern_pgprot;
 	mem_types[MT_MEMORY_RWX_NONCACHED].prot_sect |= ecc_mask;
 	mem_types[MT_ROM].prot_sect |= cp->pmd;
@@ -1360,7 +1373,7 @@ static void __init devicemaps_init(const struct machine_desc *mdesc)
 		map.pfn = __phys_to_pfn(__atags_pointer & SECTION_MASK);
 		map.virtual = FDT_FIXED_BASE;
 		map.length = FDT_FIXED_SIZE;
-		map.type = MT_ROM;
+		map.type = MT_MEMORY_RO;
 		create_mapping(&map);
 	}
 
diff --git a/arch/arm/mm/proc-v7-bugs.c b/arch/arm/mm/proc-v7-bugs.c
index fb9f3eb6bf48..8bc7a2d6d6c7 100644
--- a/arch/arm/mm/proc-v7-bugs.c
+++ b/arch/arm/mm/proc-v7-bugs.c
@@ -108,8 +108,7 @@ static unsigned int spectre_v2_install_workaround(unsigned int method)
 #else
 static unsigned int spectre_v2_install_workaround(unsigned int method)
 {
-	pr_info("CPU%u: Spectre V2: workarounds disabled by configuration\n",
-		smp_processor_id());
+	pr_info_once("Spectre V2: workarounds disabled by configuration\n");
 
 	return SPECTRE_VULNERABLE;
 }
@@ -209,10 +208,10 @@ static int spectre_bhb_install_workaround(int method)
 			return SPECTRE_VULNERABLE;
 
 		spectre_bhb_method = method;
-	}
 
-	pr_info("CPU%u: Spectre BHB: using %s workaround\n",
-		smp_processor_id(), spectre_bhb_method_name(method));
+		pr_info("CPU%u: Spectre BHB: enabling %s workaround for all CPUs\n",
+			smp_processor_id(), spectre_bhb_method_name(method));
+	}
 
 	return SPECTRE_MITIGATED;
 }
diff --git a/arch/arm/probes/decode.h b/arch/arm/probes/decode.h
index 973173598992..facc889d05ee 100644
--- a/arch/arm/probes/decode.h
+++ b/arch/arm/probes/decode.h
@@ -14,6 +14,7 @@
 #include <linux/types.h>
 #include <linux/stddef.h>
 #include <asm/probes.h>
+#include <asm/ptrace.h>
 #include <asm/kprobes.h>
 
 void __init arm_probes_decode_init(void);
@@ -35,31 +36,6 @@ void __init find_str_pc_offset(void);
 #endif
 
 
-/*
- * Update ITSTATE after normal execution of an IT block instruction.
- *
- * The 8 IT state bits are split into two parts in CPSR:
- *	ITSTATE<1:0> are in CPSR<26:25>
- *	ITSTATE<7:2> are in CPSR<15:10>
- */
-static inline unsigned long it_advance(unsigned long cpsr)
-	{
-	if ((cpsr & 0x06000400) == 0) {
-		/* ITSTATE<2:0> == 0 means end of IT block, so clear IT state */
-		cpsr &= ~PSR_IT_MASK;
-	} else {
-		/* We need to shift left ITSTATE<4:0> */
-		const unsigned long mask = 0x06001c00;  /* Mask ITSTATE<4:0> */
-		unsigned long it = cpsr & mask;
-		it <<= 1;
-		it |= it >> (27 - 10);  /* Carry ITSTATE<2> to correct place */
-		it &= mask;
-		cpsr &= ~mask;
-		cpsr |= it;
-	}
-	return cpsr;
-}
-
 static inline void __kprobes bx_write_pc(long pcv, struct pt_regs *regs)
 {
 	long cpsr = regs->ARM_cpsr;
diff --git a/arch/arm64/boot/dts/broadcom/bcm4908/bcm4906.dtsi b/arch/arm64/boot/dts/broadcom/bcm4908/bcm4906.dtsi
index 66023d553524..d084c33d5ca8 100644
--- a/arch/arm64/boot/dts/broadcom/bcm4908/bcm4906.dtsi
+++ b/arch/arm64/boot/dts/broadcom/bcm4908/bcm4906.dtsi
@@ -9,6 +9,14 @@ cpus {
 		/delete-node/ cpu@3;
 	};
 
+	timer {
+		compatible = "arm,armv8-timer";
+		interrupts = <GIC_PPI 13 (GIC_CPU_MASK_SIMPLE(2) | IRQ_TYPE_LEVEL_LOW)>,
+			     <GIC_PPI 14 (GIC_CPU_MASK_SIMPLE(2) | IRQ_TYPE_LEVEL_LOW)>,
+			     <GIC_PPI 11 (GIC_CPU_MASK_SIMPLE(2) | IRQ_TYPE_LEVEL_LOW)>,
+			     <GIC_PPI 10 (GIC_CPU_MASK_SIMPLE(2) | IRQ_TYPE_LEVEL_LOW)>;
+	};
+
 	pmu {
 		compatible = "arm,cortex-a53-pmu";
 		interrupts = <GIC_SPI 9 IRQ_TYPE_LEVEL_HIGH>,
diff --git a/arch/arm64/boot/dts/broadcom/bcm4908/bcm4908.dtsi b/arch/arm64/boot/dts/broadcom/bcm4908/bcm4908.dtsi
index e8907d3fe2d1..e510a6961cf9 100644
--- a/arch/arm64/boot/dts/broadcom/bcm4908/bcm4908.dtsi
+++ b/arch/arm64/boot/dts/broadcom/bcm4908/bcm4908.dtsi
@@ -29,6 +29,8 @@ cpu0: cpu@0 {
 			device_type = "cpu";
 			compatible = "brcm,brahma-b53";
 			reg = <0x0>;
+			enable-method = "spin-table";
+			cpu-release-addr = <0x0 0xfff8>;
 			next-level-cache = <&l2>;
 		};
 
diff --git a/arch/powerpc/sysdev/xive/spapr.c b/arch/powerpc/sysdev/xive/spapr.c
index a82f32fbe772..583b2c6df390 100644
--- a/arch/powerpc/sysdev/xive/spapr.c
+++ b/arch/powerpc/sysdev/xive/spapr.c
@@ -13,6 +13,7 @@
 #include <linux/of.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
+#include <linux/bitmap.h>
 #include <linux/cpumask.h>
 #include <linux/mm.h>
 #include <linux/delay.h>
@@ -55,7 +56,7 @@ static int xive_irq_bitmap_add(int base, int count)
 	spin_lock_init(&xibm->lock);
 	xibm->base = base;
 	xibm->count = count;
-	xibm->bitmap = kzalloc(xibm->count, GFP_KERNEL);
+	xibm->bitmap = bitmap_zalloc(xibm->count, GFP_KERNEL);
 	if (!xibm->bitmap) {
 		kfree(xibm);
 		return -ENOMEM;
@@ -73,7 +74,7 @@ static void xive_irq_bitmap_remove_all(void)
 
 	list_for_each_entry_safe(xibm, tmp, &xive_irq_bitmaps, list) {
 		list_del(&xibm->list);
-		kfree(xibm->bitmap);
+		bitmap_free(xibm->bitmap);
 		kfree(xibm);
 	}
 }
diff --git a/arch/sh/include/asm/io.h b/arch/sh/include/asm/io.h
index cf9a3ec32406..fba90e670ed4 100644
--- a/arch/sh/include/asm/io.h
+++ b/arch/sh/include/asm/io.h
@@ -271,8 +271,12 @@ static inline void __iomem *ioremap_prot(phys_addr_t offset, unsigned long size,
 #endif /* CONFIG_HAVE_IOREMAP_PROT */
 
 #else /* CONFIG_MMU */
-#define iounmap(addr)		do { } while (0)
-#define ioremap(offset, size)	((void __iomem *)(unsigned long)(offset))
+static inline void __iomem *ioremap(phys_addr_t offset, size_t size)
+{
+	return (void __iomem *)(unsigned long)offset;
+}
+
+static inline void iounmap(volatile void __iomem *addr) { }
 #endif /* CONFIG_MMU */
 
 #define ioremap_uc	ioremap
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index de01903c3735..5036104d5470 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -418,6 +418,8 @@ static void __init clear_bss(void)
 {
 	memset(__bss_start, 0,
 	       (unsigned long) __bss_stop - (unsigned long) __bss_start);
+	memset(__brk_base, 0,
+	       (unsigned long) __brk_limit - (unsigned long) __brk_base);
 }
 
 static unsigned long get_cmd_line_ptr(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8974884ef2ad..732c3f2f8ded 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8713,15 +8713,17 @@ static int kvm_pv_clock_pairing(struct kvm_vcpu *vcpu, gpa_t paddr,
  */
 static void kvm_pv_kick_cpu_op(struct kvm *kvm, unsigned long flags, int apicid)
 {
-	struct kvm_lapic_irq lapic_irq;
-
-	lapic_irq.shorthand = APIC_DEST_NOSHORT;
-	lapic_irq.dest_mode = APIC_DEST_PHYSICAL;
-	lapic_irq.level = 0;
-	lapic_irq.dest_id = apicid;
-	lapic_irq.msi_redir_hint = false;
+	/*
+	 * All other fields are unused for APIC_DM_REMRD, but may be consumed by
+	 * common code, e.g. for tracing. Defer initialization to the compiler.
+	 */
+	struct kvm_lapic_irq lapic_irq = {
+		.delivery_mode = APIC_DM_REMRD,
+		.dest_mode = APIC_DEST_PHYSICAL,
+		.shorthand = APIC_DEST_NOSHORT,
+		.dest_id = apicid,
+	};
 
-	lapic_irq.delivery_mode = APIC_DM_REMRD;
 	kvm_irq_delivery_to_apic(kvm, NULL, &lapic_irq, NULL);
 }
 
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 23a14d82e783..0e3667e529ab 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -78,10 +78,20 @@ static uint8_t __pte2cachemode_tbl[8] = {
 	[__pte2cm_idx(_PAGE_PWT | _PAGE_PCD | _PAGE_PAT)] = _PAGE_CACHE_MODE_UC,
 };
 
-/* Check that the write-protect PAT entry is set for write-protect */
+/*
+ * Check that the write-protect PAT entry is set for write-protect.
+ * To do this without making assumptions how PAT has been set up (Xen has
+ * another layout than the kernel), translate the _PAGE_CACHE_MODE_WP cache
+ * mode via the __cachemode2pte_tbl[] into protection bits (those protection
+ * bits will select a cache mode of WP or better), and then translate the
+ * protection bits back into the cache mode using __pte2cm_idx() and the
+ * __pte2cachemode_tbl[] array. This will return the really used cache mode.
+ */
 bool x86_has_pat_wp(void)
 {
-	return __pte2cachemode_tbl[_PAGE_CACHE_MODE_WP] == _PAGE_CACHE_MODE_WP;
+	uint16_t prot = __cachemode2pte_tbl[_PAGE_CACHE_MODE_WP];
+
+	return __pte2cachemode_tbl[__pte2cm_idx(prot)] == _PAGE_CACHE_MODE_WP;
 }
 
 enum page_cache_mode pgprot2cachemode(pgprot_t pgprot)
diff --git a/drivers/acpi/acpi_video.c b/drivers/acpi/acpi_video.c
index 007deb3a8ea3..390af28f6faf 100644
--- a/drivers/acpi/acpi_video.c
+++ b/drivers/acpi/acpi_video.c
@@ -73,7 +73,7 @@ module_param(device_id_scheme, bool, 0444);
 static int only_lcd = -1;
 module_param(only_lcd, int, 0444);
 
-static bool has_backlight;
+static bool may_report_brightness_keys;
 static int register_count;
 static DEFINE_MUTEX(register_count_mutex);
 static DEFINE_MUTEX(video_list_lock);
@@ -1224,7 +1224,7 @@ acpi_video_bus_get_one_device(struct acpi_device *device,
 	acpi_video_device_find_cap(data);
 
 	if (data->cap._BCM && data->cap._BCL)
-		has_backlight = true;
+		may_report_brightness_keys = true;
 
 	mutex_lock(&video->device_list_lock);
 	list_add_tail(&data->entry, &video->video_device_list);
@@ -1693,6 +1693,9 @@ static void acpi_video_device_notify(acpi_handle handle, u32 event, void *data)
 		break;
 	}
 
+	if (keycode)
+		may_report_brightness_keys = true;
+
 	acpi_notifier_call_chain(device, event, 0);
 
 	if (keycode && (report_key_events & REPORT_BRIGHTNESS_KEY_EVENTS)) {
@@ -2255,7 +2258,7 @@ void acpi_video_unregister(void)
 	if (register_count) {
 		acpi_bus_unregister_driver(&acpi_video_bus);
 		register_count = 0;
-		has_backlight = false;
+		may_report_brightness_keys = false;
 	}
 	mutex_unlock(&register_count_mutex);
 }
@@ -2277,7 +2280,7 @@ void acpi_video_unregister_backlight(void)
 
 bool acpi_video_handles_brightness_key_presses(void)
 {
-	return has_backlight &&
+	return may_report_brightness_keys &&
 	       (report_key_events & REPORT_BRIGHTNESS_KEY_EVENTS);
 }
 EXPORT_SYMBOL(acpi_video_handles_brightness_key_presses);
diff --git a/drivers/cpufreq/pmac32-cpufreq.c b/drivers/cpufreq/pmac32-cpufreq.c
index 4f20c6a9108d..8e41fe9ee870 100644
--- a/drivers/cpufreq/pmac32-cpufreq.c
+++ b/drivers/cpufreq/pmac32-cpufreq.c
@@ -470,6 +470,10 @@ static int pmac_cpufreq_init_MacRISC3(struct device_node *cpunode)
 	if (slew_done_gpio_np)
 		slew_done_gpio = read_gpio(slew_done_gpio_np);
 
+	of_node_put(volt_gpio_np);
+	of_node_put(freq_gpio_np);
+	of_node_put(slew_done_gpio_np);
+
 	/* If we use the frequency GPIOs, calculate the min/max speeds based
 	 * on the bus frequencies
 	 */
diff --git a/drivers/firmware/sysfb.c b/drivers/firmware/sysfb.c
index 2bfbb05f7d89..1f276f108cc9 100644
--- a/drivers/firmware/sysfb.c
+++ b/drivers/firmware/sysfb.c
@@ -34,21 +34,59 @@
 #include <linux/screen_info.h>
 #include <linux/sysfb.h>
 
+static struct platform_device *pd;
+static DEFINE_MUTEX(disable_lock);
+static bool disabled;
+
+static bool sysfb_unregister(void)
+{
+	if (IS_ERR_OR_NULL(pd))
+		return false;
+
+	platform_device_unregister(pd);
+	pd = NULL;
+
+	return true;
+}
+
+/**
+ * sysfb_disable() - disable the Generic System Framebuffers support
+ *
+ * This disables the registration of system framebuffer devices that match the
+ * generic drivers that make use of the system framebuffer set up by firmware.
+ *
+ * It also unregisters a device if this was already registered by sysfb_init().
+ *
+ * Context: The function can sleep. A @disable_lock mutex is acquired to serialize
+ *          against sysfb_init(), that registers a system framebuffer device.
+ */
+void sysfb_disable(void)
+{
+	mutex_lock(&disable_lock);
+	sysfb_unregister();
+	disabled = true;
+	mutex_unlock(&disable_lock);
+}
+EXPORT_SYMBOL_GPL(sysfb_disable);
+
 static __init int sysfb_init(void)
 {
 	struct screen_info *si = &screen_info;
 	struct simplefb_platform_data mode;
-	struct platform_device *pd;
 	const char *name;
 	bool compatible;
-	int ret;
+	int ret = 0;
+
+	mutex_lock(&disable_lock);
+	if (disabled)
+		goto unlock_mutex;
 
 	/* try to create a simple-framebuffer device */
 	compatible = sysfb_parse_mode(si, &mode);
 	if (compatible) {
-		ret = sysfb_create_simplefb(si, &mode);
-		if (!ret)
-			return 0;
+		pd = sysfb_create_simplefb(si, &mode);
+		if (!IS_ERR(pd))
+			goto unlock_mutex;
 	}
 
 	/* if the FB is incompatible, create a legacy framebuffer device */
@@ -60,8 +98,10 @@ static __init int sysfb_init(void)
 		name = "platform-framebuffer";
 
 	pd = platform_device_alloc(name, 0);
-	if (!pd)
-		return -ENOMEM;
+	if (!pd) {
+		ret = -ENOMEM;
+		goto unlock_mutex;
+	}
 
 	sysfb_apply_efi_quirks(pd);
 
@@ -73,9 +113,11 @@ static __init int sysfb_init(void)
 	if (ret)
 		goto err;
 
-	return 0;
+	goto unlock_mutex;
 err:
 	platform_device_put(pd);
+unlock_mutex:
+	mutex_unlock(&disable_lock);
 	return ret;
 }
 
diff --git a/drivers/firmware/sysfb_simplefb.c b/drivers/firmware/sysfb_simplefb.c
index 757cc8b9f3de..eac51c2a27ba 100644
--- a/drivers/firmware/sysfb_simplefb.c
+++ b/drivers/firmware/sysfb_simplefb.c
@@ -57,8 +57,8 @@ __init bool sysfb_parse_mode(const struct screen_info *si,
 	return false;
 }
 
-__init int sysfb_create_simplefb(const struct screen_info *si,
-				 const struct simplefb_platform_data *mode)
+__init struct platform_device *sysfb_create_simplefb(const struct screen_info *si,
+						     const struct simplefb_platform_data *mode)
 {
 	struct platform_device *pd;
 	struct resource res;
@@ -76,7 +76,7 @@ __init int sysfb_create_simplefb(const struct screen_info *si,
 		base |= (u64)si->ext_lfb_base << 32;
 	if (!base || (u64)(resource_size_t)base != base) {
 		printk(KERN_DEBUG "sysfb: inaccessible VRAM base\n");
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
 	}
 
 	/*
@@ -93,7 +93,7 @@ __init int sysfb_create_simplefb(const struct screen_info *si,
 	length = mode->height * mode->stride;
 	if (length > size) {
 		printk(KERN_WARNING "sysfb: VRAM smaller than advertised\n");
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
 	}
 	length = PAGE_ALIGN(length);
 
@@ -104,11 +104,11 @@ __init int sysfb_create_simplefb(const struct screen_info *si,
 	res.start = base;
 	res.end = res.start + length - 1;
 	if (res.end <= res.start)
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
 
 	pd = platform_device_alloc("simple-framebuffer", 0);
 	if (!pd)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	sysfb_apply_efi_quirks(pd);
 
@@ -124,10 +124,10 @@ __init int sysfb_create_simplefb(const struct screen_info *si,
 	if (ret)
 		goto err_put_device;
 
-	return 0;
+	return pd;
 
 err_put_device:
 	platform_device_put(pd);
 
-	return ret;
+	return ERR_PTR(ret);
 }
diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
index 82f1f27baaf3..188556e41b9d 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -1062,12 +1062,13 @@ bool resource_build_scaling_params(struct pipe_ctx *pipe_ctx)
 	 * on certain displays, such as the Sharp 4k. 36bpp is needed
 	 * to support SURFACE_PIXEL_FORMAT_GRPH_ARGB16161616 and
 	 * SURFACE_PIXEL_FORMAT_GRPH_ABGR16161616 with actual > 10 bpc
-	 * precision on at least DCN display engines. However, at least
-	 * Carrizo with DCE_VERSION_11_0 does not like 36 bpp lb depth,
-	 * so use only 30 bpp on DCE_VERSION_11_0. Testing with DCE 11.2 and 8.3
-	 * did not show such problems, so this seems to be the exception.
+	 * precision on DCN display engines, but apparently not for DCE, as
+	 * far as testing on DCE-11.2 and DCE-8 showed. Various DCE parts have
+	 * problems: Carrizo with DCE_VERSION_11_0 does not like 36 bpp lb depth,
+	 * neither do DCE-8 at 4k resolution, or DCE-11.2 (broken identify pixel
+	 * passthrough). Therefore only use 36 bpp on DCN where it is actually needed.
 	 */
-	if (plane_state->ctx->dce_version > DCE_VERSION_11_0)
+	if (plane_state->ctx->dce_version > DCE_VERSION_MAX)
 		pipe_ctx->plane_res.scl_data.lb_params.depth = LB_PIXEL_DEPTH_36BPP;
 	else
 		pipe_ctx->plane_res.scl_data.lb_params.depth = LB_PIXEL_DEPTH_30BPP;
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c
index e6c93396434f..614c3d049514 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c
@@ -1235,6 +1235,8 @@ int smu_v11_0_set_fan_speed_rpm(struct smu_context *smu,
 	uint32_t crystal_clock_freq = 2500;
 	uint32_t tach_period;
 
+	if (speed == 0)
+		return -EINVAL;
 	/*
 	 * To prevent from possible overheat, some ASICs may have requirement
 	 * for minimum fan speed:
diff --git a/drivers/gpu/drm/drm_aperture.c b/drivers/gpu/drm/drm_aperture.c
index 74bd4a76b253..059fd71424f6 100644
--- a/drivers/gpu/drm/drm_aperture.c
+++ b/drivers/gpu/drm/drm_aperture.c
@@ -329,7 +329,20 @@ int drm_aperture_remove_conflicting_pci_framebuffers(struct pci_dev *pdev,
 						     const struct drm_driver *req_driver)
 {
 	resource_size_t base, size;
-	int bar, ret = 0;
+	int bar, ret;
+
+	/*
+	 * WARNING: Apparently we must kick fbdev drivers before vgacon,
+	 * otherwise the vga fbdev driver falls over.
+	 */
+#if IS_REACHABLE(CONFIG_FB)
+	ret = remove_conflicting_pci_framebuffers(pdev, req_driver->name);
+	if (ret)
+		return ret;
+#endif
+	ret = vga_remove_vgacon(pdev);
+	if (ret)
+		return ret;
 
 	for (bar = 0; bar < PCI_STD_NUM_BARS; ++bar) {
 		if (!(pci_resource_flags(pdev, bar) & IORESOURCE_MEM))
@@ -339,15 +352,6 @@ int drm_aperture_remove_conflicting_pci_framebuffers(struct pci_dev *pdev,
 		drm_aperture_detach_drivers(base, size);
 	}
 
-	/*
-	 * WARNING: Apparently we must kick fbdev drivers before vgacon,
-	 * otherwise the vga fbdev driver falls over.
-	 */
-#if IS_REACHABLE(CONFIG_FB)
-	ret = remove_conflicting_pci_framebuffers(pdev, req_driver->name);
-#endif
-	if (ret == 0)
-		ret = vga_remove_vgacon(pdev);
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL(drm_aperture_remove_conflicting_pci_framebuffers);
diff --git a/drivers/gpu/drm/i915/display/intel_dp_mst.c b/drivers/gpu/drm/i915/display/intel_dp_mst.c
index 8d13d7b26a25..2a20487effcc 100644
--- a/drivers/gpu/drm/i915/display/intel_dp_mst.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_mst.c
@@ -817,6 +817,7 @@ static struct drm_connector *intel_dp_add_mst_connector(struct drm_dp_mst_topolo
 	ret = drm_connector_init(dev, connector, &intel_dp_mst_connector_funcs,
 				 DRM_MODE_CONNECTOR_DisplayPort);
 	if (ret) {
+		drm_dp_mst_put_port_malloc(port);
 		intel_connector_free(intel_connector);
 		return NULL;
 	}
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
index 1aa249908b64..0d480867fc0c 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
@@ -1060,6 +1060,47 @@ static inline struct i915_ggtt *cache_to_ggtt(struct reloc_cache *cache)
 	return &i915->ggtt;
 }
 
+static void reloc_cache_unmap(struct reloc_cache *cache)
+{
+	void *vaddr;
+
+	if (!cache->vaddr)
+		return;
+
+	vaddr = unmask_page(cache->vaddr);
+	if (cache->vaddr & KMAP)
+		kunmap_atomic(vaddr);
+	else
+		io_mapping_unmap_atomic((void __iomem *)vaddr);
+}
+
+static void reloc_cache_remap(struct reloc_cache *cache,
+			      struct drm_i915_gem_object *obj)
+{
+	void *vaddr;
+
+	if (!cache->vaddr)
+		return;
+
+	if (cache->vaddr & KMAP) {
+		struct page *page = i915_gem_object_get_page(obj, cache->page);
+
+		vaddr = kmap_atomic(page);
+		cache->vaddr = unmask_flags(cache->vaddr) |
+			(unsigned long)vaddr;
+	} else {
+		struct i915_ggtt *ggtt = cache_to_ggtt(cache);
+		unsigned long offset;
+
+		offset = cache->node.start;
+		if (!drm_mm_node_allocated(&cache->node))
+			offset += cache->page << PAGE_SHIFT;
+
+		cache->vaddr = (unsigned long)
+			io_mapping_map_atomic_wc(&ggtt->iomap, offset);
+	}
+}
+
 static void reloc_cache_reset(struct reloc_cache *cache, struct i915_execbuffer *eb)
 {
 	void *vaddr;
@@ -1324,10 +1365,17 @@ eb_relocate_entry(struct i915_execbuffer *eb,
 		 * batchbuffers.
 		 */
 		if (reloc->write_domain == I915_GEM_DOMAIN_INSTRUCTION &&
-		    GRAPHICS_VER(eb->i915) == 6) {
+		    GRAPHICS_VER(eb->i915) == 6 &&
+		    !i915_vma_is_bound(target->vma, I915_VMA_GLOBAL_BIND)) {
+			struct i915_vma *vma = target->vma;
+
+			reloc_cache_unmap(&eb->reloc_cache);
+			mutex_lock(&vma->vm->mutex);
 			err = i915_vma_bind(target->vma,
 					    target->vma->obj->cache_level,
 					    PIN_GLOBAL, NULL);
+			mutex_unlock(&vma->vm->mutex);
+			reloc_cache_remap(&eb->reloc_cache, ev->vma->obj);
 			if (err)
 				return err;
 		}
diff --git a/drivers/gpu/drm/i915/gt/intel_gt.c b/drivers/gpu/drm/i915/gt/intel_gt.c
index e1e1d17d49fd..3a76000d15bf 100644
--- a/drivers/gpu/drm/i915/gt/intel_gt.c
+++ b/drivers/gpu/drm/i915/gt/intel_gt.c
@@ -970,6 +970,20 @@ void intel_gt_invalidate_tlbs(struct intel_gt *gt)
 	mutex_lock(&gt->tlb_invalidate_lock);
 	intel_uncore_forcewake_get(uncore, FORCEWAKE_ALL);
 
+	spin_lock_irq(&uncore->lock); /* serialise invalidate with GT reset */
+
+	for_each_engine(engine, gt, id) {
+		struct reg_and_bit rb;
+
+		rb = get_reg_and_bit(engine, regs == gen8_regs, regs, num);
+		if (!i915_mmio_reg_offset(rb.reg))
+			continue;
+
+		intel_uncore_write_fw(uncore, rb.reg, rb.bit);
+	}
+
+	spin_unlock_irq(&uncore->lock);
+
 	for_each_engine(engine, gt, id) {
 		/*
 		 * HW architecture suggest typical invalidation time at 40us,
@@ -984,7 +998,6 @@ void intel_gt_invalidate_tlbs(struct intel_gt *gt)
 		if (!i915_mmio_reg_offset(rb.reg))
 			continue;
 
-		intel_uncore_write_fw(uncore, rb.reg, rb.bit);
 		if (__intel_wait_for_register_fw(uncore,
 						 rb.reg, rb.bit, 0,
 						 timeout_us, timeout_ms,
diff --git a/drivers/gpu/drm/i915/gt/intel_reset.c b/drivers/gpu/drm/i915/gt/intel_reset.c
index 91200c43951f..18b0e57c58c1 100644
--- a/drivers/gpu/drm/i915/gt/intel_reset.c
+++ b/drivers/gpu/drm/i915/gt/intel_reset.c
@@ -293,9 +293,9 @@ static int gen6_hw_domain_reset(struct intel_gt *gt, u32 hw_domain_mask)
 	return err;
 }
 
-static int gen6_reset_engines(struct intel_gt *gt,
-			      intel_engine_mask_t engine_mask,
-			      unsigned int retry)
+static int __gen6_reset_engines(struct intel_gt *gt,
+				intel_engine_mask_t engine_mask,
+				unsigned int retry)
 {
 	static const u32 hw_engine_mask[] = {
 		[RCS0]  = GEN6_GRDOM_RENDER,
@@ -322,6 +322,20 @@ static int gen6_reset_engines(struct intel_gt *gt,
 	return gen6_hw_domain_reset(gt, hw_mask);
 }
 
+static int gen6_reset_engines(struct intel_gt *gt,
+			      intel_engine_mask_t engine_mask,
+			      unsigned int retry)
+{
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&gt->uncore->lock, flags);
+	ret = __gen6_reset_engines(gt, engine_mask, retry);
+	spin_unlock_irqrestore(&gt->uncore->lock, flags);
+
+	return ret;
+}
+
 static struct intel_engine_cs *find_sfc_paired_vecs_engine(struct intel_engine_cs *engine)
 {
 	int vecs_id;
@@ -488,9 +502,9 @@ static void gen11_unlock_sfc(struct intel_engine_cs *engine)
 	rmw_clear_fw(uncore, sfc_lock.lock_reg, sfc_lock.lock_bit);
 }
 
-static int gen11_reset_engines(struct intel_gt *gt,
-			       intel_engine_mask_t engine_mask,
-			       unsigned int retry)
+static int __gen11_reset_engines(struct intel_gt *gt,
+				 intel_engine_mask_t engine_mask,
+				 unsigned int retry)
 {
 	static const u32 hw_engine_mask[] = {
 		[RCS0]  = GEN11_GRDOM_RENDER,
@@ -601,8 +615,11 @@ static int gen8_reset_engines(struct intel_gt *gt,
 	struct intel_engine_cs *engine;
 	const bool reset_non_ready = retry >= 1;
 	intel_engine_mask_t tmp;
+	unsigned long flags;
 	int ret;
 
+	spin_lock_irqsave(&gt->uncore->lock, flags);
+
 	for_each_engine_masked(engine, gt, engine_mask, tmp) {
 		ret = gen8_engine_reset_prepare(engine);
 		if (ret && !reset_non_ready)
@@ -623,15 +640,26 @@ static int gen8_reset_engines(struct intel_gt *gt,
 		 */
 	}
 
+	/*
+	 * Wa_22011100796:dg2, whenever Full soft reset is required,
+	 * reset all individual engines firstly, and then do a full soft reset.
+	 *
+	 * This is best effort, so ignore any error from the initial reset.
+	 */
+	if (IS_DG2(gt->i915) && engine_mask == ALL_ENGINES)
+		__gen11_reset_engines(gt, gt->info.engine_mask, 0);
+
 	if (GRAPHICS_VER(gt->i915) >= 11)
-		ret = gen11_reset_engines(gt, engine_mask, retry);
+		ret = __gen11_reset_engines(gt, engine_mask, retry);
 	else
-		ret = gen6_reset_engines(gt, engine_mask, retry);
+		ret = __gen6_reset_engines(gt, engine_mask, retry);
 
 skip_reset:
 	for_each_engine_masked(engine, gt, engine_mask, tmp)
 		gen8_engine_reset_cancel(engine);
 
+	spin_unlock_irqrestore(&gt->uncore->lock, flags);
+
 	return ret;
 }
 
diff --git a/drivers/gpu/drm/i915/gt/selftest_lrc.c b/drivers/gpu/drm/i915/gt/selftest_lrc.c
index b0977a3b699b..bc2950fbbaf9 100644
--- a/drivers/gpu/drm/i915/gt/selftest_lrc.c
+++ b/drivers/gpu/drm/i915/gt/selftest_lrc.c
@@ -153,8 +153,8 @@ static int live_lrc_layout(void *arg)
 			continue;
 
 		hw = shmem_pin_map(engine->default_state);
-		if (IS_ERR(hw)) {
-			err = PTR_ERR(hw);
+		if (!hw) {
+			err = -ENOMEM;
 			break;
 		}
 		hw += LRC_STATE_OFFSET / sizeof(*hw);
@@ -329,8 +329,8 @@ static int live_lrc_fixed(void *arg)
 			continue;
 
 		hw = shmem_pin_map(engine->default_state);
-		if (IS_ERR(hw)) {
-			err = PTR_ERR(hw);
+		if (!hw) {
+			err = -ENOMEM;
 			break;
 		}
 		hw += LRC_STATE_OFFSET / sizeof(*hw);
diff --git a/drivers/gpu/drm/i915/gt/uc/intel_guc_fw.c b/drivers/gpu/drm/i915/gt/uc/intel_guc_fw.c
index 76fe766ad1bc..bb951b8d5203 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_fw.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_fw.c
@@ -159,6 +159,6 @@ int intel_guc_fw_upload(struct intel_guc *guc)
 	return 0;
 
 out:
-	intel_uc_fw_change_status(&guc->fw, INTEL_UC_FIRMWARE_FAIL);
+	intel_uc_fw_change_status(&guc->fw, INTEL_UC_FIRMWARE_LOAD_FAIL);
 	return ret;
 }
diff --git a/drivers/gpu/drm/i915/gt/uc/intel_huc.c b/drivers/gpu/drm/i915/gt/uc/intel_huc.c
index fc5387b410a2..9ee22ac92540 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_huc.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_huc.c
@@ -191,7 +191,7 @@ int intel_huc_auth(struct intel_huc *huc)
 
 fail:
 	i915_probe_error(gt->i915, "HuC: Authentication failed %d\n", ret);
-	intel_uc_fw_change_status(&huc->fw, INTEL_UC_FIRMWARE_FAIL);
+	intel_uc_fw_change_status(&huc->fw, INTEL_UC_FIRMWARE_LOAD_FAIL);
 	return ret;
 }
 
diff --git a/drivers/gpu/drm/i915/gt/uc/intel_uc_fw.c b/drivers/gpu/drm/i915/gt/uc/intel_uc_fw.c
index 3a16d08608a5..6be7fbf9d18a 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_uc_fw.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_uc_fw.c
@@ -526,7 +526,7 @@ int intel_uc_fw_upload(struct intel_uc_fw *uc_fw, u32 dst_offset, u32 dma_flags)
 	i915_probe_error(gt->i915, "Failed to load %s firmware %s (%d)\n",
 			 intel_uc_fw_type_repr(uc_fw->type), uc_fw->path,
 			 err);
-	intel_uc_fw_change_status(uc_fw, INTEL_UC_FIRMWARE_FAIL);
+	intel_uc_fw_change_status(uc_fw, INTEL_UC_FIRMWARE_LOAD_FAIL);
 	return err;
 }
 
@@ -544,7 +544,7 @@ int intel_uc_fw_init(struct intel_uc_fw *uc_fw)
 	if (err) {
 		DRM_DEBUG_DRIVER("%s fw pin-pages err=%d\n",
 				 intel_uc_fw_type_repr(uc_fw->type), err);
-		intel_uc_fw_change_status(uc_fw, INTEL_UC_FIRMWARE_FAIL);
+		intel_uc_fw_change_status(uc_fw, INTEL_UC_FIRMWARE_INIT_FAIL);
 	}
 
 	return err;
diff --git a/drivers/gpu/drm/i915/gt/uc/intel_uc_fw.h b/drivers/gpu/drm/i915/gt/uc/intel_uc_fw.h
index 99bb1fe1af66..c1a7246fb7d6 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_uc_fw.h
+++ b/drivers/gpu/drm/i915/gt/uc/intel_uc_fw.h
@@ -31,11 +31,12 @@ struct intel_gt;
  * |            |    MISSING <--/    |    \--> ERROR                |
  * |   fetch    |                    V                              |
  * |            |                 AVAILABLE                         |
- * +------------+-                   |                             -+
+ * +------------+-                   |   \                         -+
+ * |            |                    |    \--> INIT FAIL            |
  * |   init     |                    V                              |
  * |            |        /------> LOADABLE <----<-----------\       |
  * +------------+-       \         /    \        \           \     -+
- * |            |         FAIL <--<      \--> TRANSFERRED     \     |
+ * |            |    LOAD FAIL <--<      \--> TRANSFERRED     \     |
  * |   upload   |                  \           /   \          /     |
  * |            |                   \---------/     \--> RUNNING    |
  * +------------+---------------------------------------------------+
@@ -49,8 +50,9 @@ enum intel_uc_fw_status {
 	INTEL_UC_FIRMWARE_MISSING, /* blob not found on the system */
 	INTEL_UC_FIRMWARE_ERROR, /* invalid format or version */
 	INTEL_UC_FIRMWARE_AVAILABLE, /* blob found and copied in mem */
+	INTEL_UC_FIRMWARE_INIT_FAIL, /* failed to prepare fw objects for load */
 	INTEL_UC_FIRMWARE_LOADABLE, /* all fw-required objects are ready */
-	INTEL_UC_FIRMWARE_FAIL, /* failed to xfer or init/auth the fw */
+	INTEL_UC_FIRMWARE_LOAD_FAIL, /* failed to xfer or init/auth the fw */
 	INTEL_UC_FIRMWARE_TRANSFERRED, /* dma xfer done */
 	INTEL_UC_FIRMWARE_RUNNING /* init/auth done */
 };
@@ -121,10 +123,12 @@ const char *intel_uc_fw_status_repr(enum intel_uc_fw_status status)
 		return "ERROR";
 	case INTEL_UC_FIRMWARE_AVAILABLE:
 		return "AVAILABLE";
+	case INTEL_UC_FIRMWARE_INIT_FAIL:
+		return "INIT FAIL";
 	case INTEL_UC_FIRMWARE_LOADABLE:
 		return "LOADABLE";
-	case INTEL_UC_FIRMWARE_FAIL:
-		return "FAIL";
+	case INTEL_UC_FIRMWARE_LOAD_FAIL:
+		return "LOAD FAIL";
 	case INTEL_UC_FIRMWARE_TRANSFERRED:
 		return "TRANSFERRED";
 	case INTEL_UC_FIRMWARE_RUNNING:
@@ -146,7 +150,8 @@ static inline int intel_uc_fw_status_to_error(enum intel_uc_fw_status status)
 		return -ENOENT;
 	case INTEL_UC_FIRMWARE_ERROR:
 		return -ENOEXEC;
-	case INTEL_UC_FIRMWARE_FAIL:
+	case INTEL_UC_FIRMWARE_INIT_FAIL:
+	case INTEL_UC_FIRMWARE_LOAD_FAIL:
 		return -EIO;
 	case INTEL_UC_FIRMWARE_SELECTED:
 		return -ESTALE;
diff --git a/drivers/gpu/drm/i915/gvt/cmd_parser.c b/drivers/gpu/drm/i915/gvt/cmd_parser.c
index c4118b808268..11971ee929f8 100644
--- a/drivers/gpu/drm/i915/gvt/cmd_parser.c
+++ b/drivers/gpu/drm/i915/gvt/cmd_parser.c
@@ -3115,9 +3115,9 @@ void intel_gvt_update_reg_whitelist(struct intel_vgpu *vgpu)
 			continue;
 
 		vaddr = shmem_pin_map(engine->default_state);
-		if (IS_ERR(vaddr)) {
-			gvt_err("failed to map %s->default state, err:%zd\n",
-				engine->name, PTR_ERR(vaddr));
+		if (!vaddr) {
+			gvt_err("failed to map %s->default state\n",
+				engine->name);
 			return;
 		}
 
diff --git a/drivers/gpu/drm/i915/i915_vma.c b/drivers/gpu/drm/i915/i915_vma.c
index dfd20060812b..3df304edabc7 100644
--- a/drivers/gpu/drm/i915/i915_vma.c
+++ b/drivers/gpu/drm/i915/i915_vma.c
@@ -376,6 +376,7 @@ int i915_vma_bind(struct i915_vma *vma,
 	u32 bind_flags;
 	u32 vma_flags;
 
+	lockdep_assert_held(&vma->vm->mutex);
 	GEM_BUG_ON(!drm_mm_node_allocated(&vma->node));
 	GEM_BUG_ON(vma->size > vma->node.size);
 
diff --git a/drivers/gpu/drm/panfrost/panfrost_drv.c b/drivers/gpu/drm/panfrost/panfrost_drv.c
index 1ffaef5ec5ff..de533f372764 100644
--- a/drivers/gpu/drm/panfrost/panfrost_drv.c
+++ b/drivers/gpu/drm/panfrost/panfrost_drv.c
@@ -422,8 +422,8 @@ static int panfrost_ioctl_madvise(struct drm_device *dev, void *data,
 
 	if (args->retained) {
 		if (args->madv == PANFROST_MADV_DONTNEED)
-			list_add_tail(&bo->base.madv_list,
-				      &pfdev->shrinker_list);
+			list_move_tail(&bo->base.madv_list,
+				       &pfdev->shrinker_list);
 		else if (args->madv == PANFROST_MADV_WILLNEED)
 			list_del_init(&bo->base.madv_list);
 	}
diff --git a/drivers/gpu/drm/panfrost/panfrost_mmu.c b/drivers/gpu/drm/panfrost/panfrost_mmu.c
index dfe5f1d29763..c0189cc9a2f1 100644
--- a/drivers/gpu/drm/panfrost/panfrost_mmu.c
+++ b/drivers/gpu/drm/panfrost/panfrost_mmu.c
@@ -501,7 +501,7 @@ static int panfrost_mmu_map_fault_addr(struct panfrost_device *pfdev, int as,
 err_pages:
 	drm_gem_shmem_put_pages(&bo->base);
 err_bo:
-	drm_gem_object_put(&bo->base.base);
+	panfrost_gem_mapping_put(bomapping);
 	return ret;
 }
 
diff --git a/drivers/irqchip/irq-or1k-pic.c b/drivers/irqchip/irq-or1k-pic.c
index 03d2366118dd..d5f1fabc45d7 100644
--- a/drivers/irqchip/irq-or1k-pic.c
+++ b/drivers/irqchip/irq-or1k-pic.c
@@ -66,7 +66,6 @@ static struct or1k_pic_dev or1k_pic_level = {
 		.name = "or1k-PIC-level",
 		.irq_unmask = or1k_pic_unmask,
 		.irq_mask = or1k_pic_mask,
-		.irq_mask_ack = or1k_pic_mask_ack,
 	},
 	.handle = handle_level_irq,
 	.flags = IRQ_LEVEL | IRQ_NOPROBE,
diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
index 262b783d1df8..a2e751f0ae0b 100644
--- a/drivers/net/can/xilinx_can.c
+++ b/drivers/net/can/xilinx_can.c
@@ -259,7 +259,7 @@ static const struct can_bittiming_const xcan_bittiming_const_canfd2 = {
 	.tseg2_min = 1,
 	.tseg2_max = 128,
 	.sjw_max = 128,
-	.brp_min = 2,
+	.brp_min = 1,
 	.brp_max = 256,
 	.brp_inc = 1,
 };
@@ -272,7 +272,7 @@ static const struct can_bittiming_const xcan_data_bittiming_const_canfd2 = {
 	.tseg2_min = 1,
 	.tseg2_max = 16,
 	.sjw_max = 16,
-	.brp_min = 2,
+	.brp_min = 1,
 	.brp_max = 256,
 	.brp_inc = 1,
 };
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
index 831833911a52..8647125d60ae 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
@@ -379,7 +379,7 @@ static void aq_pci_shutdown(struct pci_dev *pdev)
 	}
 }
 
-static int aq_suspend_common(struct device *dev, bool deep)
+static int aq_suspend_common(struct device *dev)
 {
 	struct aq_nic_s *nic = pci_get_drvdata(to_pci_dev(dev));
 
@@ -392,17 +392,15 @@ static int aq_suspend_common(struct device *dev, bool deep)
 	if (netif_running(nic->ndev))
 		aq_nic_stop(nic);
 
-	if (deep) {
-		aq_nic_deinit(nic, !nic->aq_hw->aq_nic_cfg->wol);
-		aq_nic_set_power(nic);
-	}
+	aq_nic_deinit(nic, !nic->aq_hw->aq_nic_cfg->wol);
+	aq_nic_set_power(nic);
 
 	rtnl_unlock();
 
 	return 0;
 }
 
-static int atl_resume_common(struct device *dev, bool deep)
+static int atl_resume_common(struct device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct aq_nic_s *nic;
@@ -415,11 +413,6 @@ static int atl_resume_common(struct device *dev, bool deep)
 	pci_set_power_state(pdev, PCI_D0);
 	pci_restore_state(pdev);
 
-	if (deep) {
-		/* Reinitialize Nic/Vecs objects */
-		aq_nic_deinit(nic, !nic->aq_hw->aq_nic_cfg->wol);
-	}
-
 	if (netif_running(nic->ndev)) {
 		ret = aq_nic_init(nic);
 		if (ret)
@@ -444,22 +437,22 @@ static int atl_resume_common(struct device *dev, bool deep)
 
 static int aq_pm_freeze(struct device *dev)
 {
-	return aq_suspend_common(dev, true);
+	return aq_suspend_common(dev);
 }
 
 static int aq_pm_suspend_poweroff(struct device *dev)
 {
-	return aq_suspend_common(dev, true);
+	return aq_suspend_common(dev);
 }
 
 static int aq_pm_thaw(struct device *dev)
 {
-	return atl_resume_common(dev, true);
+	return atl_resume_common(dev);
 }
 
 static int aq_pm_resume_restore(struct device *dev)
 {
-	return atl_resume_common(dev, true);
+	return atl_resume_common(dev);
 }
 
 static const struct dev_pm_ops aq_pm_ops = {
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index cb5314945589..6962abe2358b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -9806,7 +9806,8 @@ static int bnxt_hwrm_if_change(struct bnxt *bp, bool up)
 
 	if (flags & FUNC_DRV_IF_CHANGE_RESP_FLAGS_RESC_CHANGE)
 		resc_reinit = true;
-	if (flags & FUNC_DRV_IF_CHANGE_RESP_FLAGS_HOT_FW_RESET_DONE)
+	if (flags & FUNC_DRV_IF_CHANGE_RESP_FLAGS_HOT_FW_RESET_DONE ||
+	    test_bit(BNXT_STATE_FW_RESET_DET, &bp->state))
 		fw_reset = true;
 	else if (bp->fw_health && !bp->fw_health->status_reliable)
 		bnxt_try_map_fw_health_reg(bp);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
index 62a931de5b1a..a78cc65a38f2 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
@@ -61,14 +61,23 @@ static int bnxt_refclk_read(struct bnxt *bp, struct ptp_system_timestamp *sts,
 			    u64 *ns)
 {
 	struct bnxt_ptp_cfg *ptp = bp->ptp_cfg;
+	u32 high_before, high_now, low;
 
 	if (test_bit(BNXT_STATE_IN_FW_RESET, &bp->state))
 		return -EIO;
 
+	high_before = readl(bp->bar0 + ptp->refclk_mapped_regs[1]);
 	ptp_read_system_prets(sts);
-	*ns = readl(bp->bar0 + ptp->refclk_mapped_regs[0]);
+	low = readl(bp->bar0 + ptp->refclk_mapped_regs[0]);
 	ptp_read_system_postts(sts);
-	*ns |= (u64)readl(bp->bar0 + ptp->refclk_mapped_regs[1]) << 32;
+	high_now = readl(bp->bar0 + ptp->refclk_mapped_regs[1]);
+	if (high_now != high_before) {
+		ptp_read_system_prets(sts);
+		low = readl(bp->bar0 + ptp->refclk_mapped_regs[0]);
+		ptp_read_system_postts(sts);
+	}
+	*ns = ((u64)high_now << 32) | low;
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
index 0b833572205f..4a2dadb91f02 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -1746,6 +1746,19 @@ static int ftgmac100_setup_clk(struct ftgmac100 *priv)
 	return rc;
 }
 
+static bool ftgmac100_has_child_node(struct device_node *np, const char *name)
+{
+	struct device_node *child_np = of_get_child_by_name(np, name);
+	bool ret = false;
+
+	if (child_np) {
+		ret = true;
+		of_node_put(child_np);
+	}
+
+	return ret;
+}
+
 static int ftgmac100_probe(struct platform_device *pdev)
 {
 	struct resource *res;
@@ -1865,7 +1878,7 @@ static int ftgmac100_probe(struct platform_device *pdev)
 
 		/* Display what we found */
 		phy_attached_info(phy);
-	} else if (np && !of_get_child_by_name(np, "mdio")) {
+	} else if (np && !ftgmac100_has_child_node(np, "mdio")) {
 		/* Support legacy ASPEED devicetree descriptions that decribe a
 		 * MAC with an embedded MDIO controller but have no "mdio"
 		 * child node. Automatically scan the MDIO bus for available
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
index 15711814d2d2..d92b97c56f4c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
@@ -231,8 +231,7 @@ mlx5e_set_ktls_rx_priv_ctx(struct tls_context *tls_ctx,
 	struct mlx5e_ktls_offload_context_rx **ctx =
 		__tls_driver_ctx(tls_ctx, TLS_OFFLOAD_CTX_DIR_RX);
 
-	BUILD_BUG_ON(sizeof(struct mlx5e_ktls_offload_context_rx *) >
-		     TLS_OFFLOAD_CONTEXT_SIZE_RX);
+	BUILD_BUG_ON(sizeof(priv_rx) > TLS_DRIVER_STATE_SIZE_RX);
 
 	*ctx = priv_rx;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index 9ad3459fb63a..dadb71081ed0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -68,8 +68,7 @@ mlx5e_set_ktls_tx_priv_ctx(struct tls_context *tls_ctx,
 	struct mlx5e_ktls_offload_context_tx **ctx =
 		__tls_driver_ctx(tls_ctx, TLS_OFFLOAD_CTX_DIR_TX);
 
-	BUILD_BUG_ON(sizeof(struct mlx5e_ktls_offload_context_tx *) >
-		     TLS_OFFLOAD_CONTEXT_SIZE_TX);
+	BUILD_BUG_ON(sizeof(priv_tx) > TLS_DRIVER_STATE_SIZE_TX);
 
 	*ctx = priv_tx;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index e1dd17019030..5a5c6eda29d2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -614,7 +614,7 @@ static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(vnic_env)
 	u32 in[MLX5_ST_SZ_DW(query_vnic_env_in)] = {};
 	struct mlx5_core_dev *mdev = priv->mdev;
 
-	if (!MLX5_CAP_GEN(priv->mdev, nic_receive_steering_discard))
+	if (!mlx5e_stats_grp_vnic_env_num_stats(priv))
 		return;
 
 	MLX5_SET(query_vnic_env_in, in, opcode, MLX5_CMD_OP_QUERY_VNIC_ENV);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index 7fd33b356cc8..1544d4c2c636 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -429,6 +429,26 @@ static void mlx5e_tx_check_stop(struct mlx5e_txqsq *sq)
 	}
 }
 
+static void mlx5e_tx_flush(struct mlx5e_txqsq *sq)
+{
+	struct mlx5e_tx_wqe_info *wi;
+	struct mlx5e_tx_wqe *wqe;
+	u16 pi;
+
+	/* Must not be called when a MPWQE session is active but empty. */
+	mlx5e_tx_mpwqe_ensure_complete(sq);
+
+	pi = mlx5_wq_cyc_ctr2ix(&sq->wq, sq->pc);
+	wi = &sq->db.wqe_info[pi];
+
+	*wi = (struct mlx5e_tx_wqe_info) {
+		.num_wqebbs = 1,
+	};
+
+	wqe = mlx5e_post_nop(&sq->wq, sq->sqn, &sq->pc);
+	mlx5e_notify_hw(&sq->wq, sq->pc, sq->uar_map, &wqe->ctrl);
+}
+
 static inline void
 mlx5e_txwqe_complete(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 		     const struct mlx5e_tx_attr *attr,
@@ -521,6 +541,7 @@ mlx5e_sq_xmit_wqe(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 err_drop:
 	stats->dropped++;
 	dev_kfree_skb_any(skb);
+	mlx5e_tx_flush(sq);
 }
 
 static bool mlx5e_tx_skb_supports_mpwqe(struct sk_buff *skb, struct mlx5e_tx_attr *attr)
@@ -622,6 +643,13 @@ mlx5e_sq_xmit_mpwqe(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 	struct mlx5_wqe_ctrl_seg *cseg;
 	struct mlx5e_xmit_data txd;
 
+	txd.data = skb->data;
+	txd.len = skb->len;
+
+	txd.dma_addr = dma_map_single(sq->pdev, txd.data, txd.len, DMA_TO_DEVICE);
+	if (unlikely(dma_mapping_error(sq->pdev, txd.dma_addr)))
+		goto err_unmap;
+
 	if (!mlx5e_tx_mpwqe_session_is_active(sq)) {
 		mlx5e_tx_mpwqe_session_start(sq, eseg);
 	} else if (!mlx5e_tx_mpwqe_same_eseg(sq, eseg)) {
@@ -631,18 +659,9 @@ mlx5e_sq_xmit_mpwqe(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 
 	sq->stats->xmit_more += xmit_more;
 
-	txd.data = skb->data;
-	txd.len = skb->len;
-
-	txd.dma_addr = dma_map_single(sq->pdev, txd.data, txd.len, DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(sq->pdev, txd.dma_addr)))
-		goto err_unmap;
 	mlx5e_dma_push(sq, txd.dma_addr, txd.len, MLX5E_DMA_MAP_SINGLE);
-
 	mlx5e_skb_fifo_push(&sq->db.skb_fifo, skb);
-
 	mlx5e_tx_mpwqe_add_dseg(sq, &txd);
-
 	mlx5e_tx_skb_update_hwts_flags(skb);
 
 	if (unlikely(mlx5e_tx_mpwqe_is_full(&sq->mpwqe))) {
@@ -664,6 +683,7 @@ mlx5e_sq_xmit_mpwqe(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 	mlx5e_dma_unmap_wqe_err(sq, 1);
 	sq->stats->dropped++;
 	dev_kfree_skb_any(skb);
+	mlx5e_tx_flush(sq);
 }
 
 void mlx5e_tx_mpwqe_ensure_complete(struct mlx5e_txqsq *sq)
@@ -1033,5 +1053,6 @@ void mlx5i_sq_xmit(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 err_drop:
 	stats->dropped++;
 	dev_kfree_skb_any(skb);
+	mlx5e_tx_flush(sq);
 }
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c
index 0c4c743ca31e..3a2575dc5355 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c
@@ -11,6 +11,7 @@
 #include "mlx5_core.h"
 #include "eswitch.h"
 #include "fs_core.h"
+#include "fs_ft_pool.h"
 #include "esw/qos.h"
 
 enum {
@@ -95,8 +96,7 @@ static int esw_create_legacy_fdb_table(struct mlx5_eswitch *esw)
 	if (!flow_group_in)
 		return -ENOMEM;
 
-	table_size = BIT(MLX5_CAP_ESW_FLOWTABLE_FDB(dev, log_max_ft_size));
-	ft_attr.max_fte = table_size;
+	ft_attr.max_fte = POOL_NEXT_SIZE;
 	ft_attr.prio = LEGACY_FDB_PRIO;
 	fdb = mlx5_create_flow_table(root_ns, &ft_attr);
 	if (IS_ERR(fdb)) {
@@ -105,6 +105,7 @@ static int esw_create_legacy_fdb_table(struct mlx5_eswitch *esw)
 		goto out;
 	}
 	esw->fdb_table.legacy.fdb = fdb;
+	table_size = fdb->max_fte;
 
 	/* Addresses group : Full match unicast/multicast addresses */
 	MLX5_SET(create_flow_group_in, flow_group_in, match_criteria_enable,
diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index c1cd1c97f09d..056c24ec1249 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -1932,7 +1932,10 @@ static int efx_ef10_try_update_nic_stats_vf(struct efx_nic *efx)
 
 	efx_update_sw_stats(efx, stats);
 out:
+	/* releasing a DMA coherent buffer with BH disabled can panic */
+	spin_unlock_bh(&efx->stats_lock);
 	efx_nic_free_buffer(efx, &stats_buf);
+	spin_lock_bh(&efx->stats_lock);
 	return rc;
 }
 
diff --git a/drivers/net/ethernet/sfc/ef10_sriov.c b/drivers/net/ethernet/sfc/ef10_sriov.c
index 752d6406f07e..f488461a23d1 100644
--- a/drivers/net/ethernet/sfc/ef10_sriov.c
+++ b/drivers/net/ethernet/sfc/ef10_sriov.c
@@ -408,8 +408,9 @@ static int efx_ef10_pci_sriov_enable(struct efx_nic *efx, int num_vfs)
 static int efx_ef10_pci_sriov_disable(struct efx_nic *efx, bool force)
 {
 	struct pci_dev *dev = efx->pci_dev;
+	struct efx_ef10_nic_data *nic_data = efx->nic_data;
 	unsigned int vfs_assigned = pci_vfs_assigned(dev);
-	int rc = 0;
+	int i, rc = 0;
 
 	if (vfs_assigned && !force) {
 		netif_info(efx, drv, efx->net_dev, "VFs are assigned to guests; "
@@ -417,10 +418,13 @@ static int efx_ef10_pci_sriov_disable(struct efx_nic *efx, bool force)
 		return -EBUSY;
 	}
 
-	if (!vfs_assigned)
+	if (!vfs_assigned) {
+		for (i = 0; i < efx->vf_count; i++)
+			nic_data->vf[i].pci_dev = NULL;
 		pci_disable_sriov(dev);
-	else
+	} else {
 		rc = -EBUSY;
+	}
 
 	efx_ef10_sriov_free_vf_vswitching(efx);
 	efx->vf_count = 0;
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
index bc91fd867dcd..358fc26f8d1f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
@@ -361,6 +361,7 @@ static int tegra_eqos_probe(struct platform_device *pdev,
 	data->fix_mac_speed = tegra_eqos_fix_speed;
 	data->init = tegra_eqos_init;
 	data->bsp_priv = eqos;
+	data->sph_disable = 1;
 
 	err = tegra_eqos_init(pdev, eqos);
 	if (err < 0)
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-ingenic.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-ingenic.c
index 9a6d819b84ae..378b4dd826bb 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-ingenic.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-ingenic.c
@@ -273,7 +273,8 @@ static int ingenic_mac_probe(struct platform_device *pdev)
 			mac->tx_delay = tx_delay_ps * 1000;
 		} else {
 			dev_err(&pdev->dev, "Invalid TX clock delay: %dps\n", tx_delay_ps);
-			return -EINVAL;
+			ret = -EINVAL;
+			goto err_remove_config_dt;
 		}
 	}
 
@@ -283,7 +284,8 @@ static int ingenic_mac_probe(struct platform_device *pdev)
 			mac->rx_delay = rx_delay_ps * 1000;
 		} else {
 			dev_err(&pdev->dev, "Invalid RX clock delay: %dps\n", rx_delay_ps);
-			return -EINVAL;
+			ret = -EINVAL;
+			goto err_remove_config_dt;
 		}
 	}
 
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index ea9d073e87fa..901571c2626a 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2467,7 +2467,6 @@ static int am65_cpsw_nuss_register_devlink(struct am65_cpsw_common *common)
 				port->port_id, ret);
 			goto dl_port_unreg;
 		}
-		devlink_port_type_eth_set(dl_port, port->ndev);
 	}
 
 	return ret;
@@ -2514,6 +2513,7 @@ static void am65_cpsw_unregister_devlink(struct am65_cpsw_common *common)
 static int am65_cpsw_nuss_register_ndevs(struct am65_cpsw_common *common)
 {
 	struct device *dev = common->dev;
+	struct devlink_port *dl_port;
 	struct am65_cpsw_port *port;
 	int ret = 0, i;
 
@@ -2530,6 +2530,10 @@ static int am65_cpsw_nuss_register_ndevs(struct am65_cpsw_common *common)
 		return ret;
 	}
 
+	ret = am65_cpsw_nuss_register_devlink(common);
+	if (ret)
+		return ret;
+
 	for (i = 0; i < common->port_num; i++) {
 		port = &common->ports[i];
 
@@ -2542,25 +2546,24 @@ static int am65_cpsw_nuss_register_ndevs(struct am65_cpsw_common *common)
 				i, ret);
 			goto err_cleanup_ndev;
 		}
+
+		dl_port = &port->devlink_port;
+		devlink_port_type_eth_set(dl_port, port->ndev);
 	}
 
 	ret = am65_cpsw_register_notifiers(common);
 	if (ret)
 		goto err_cleanup_ndev;
 
-	ret = am65_cpsw_nuss_register_devlink(common);
-	if (ret)
-		goto clean_unregister_notifiers;
-
 	/* can't auto unregister ndev using devm_add_action() due to
 	 * devres release sequence in DD core for DMA
 	 */
 
 	return 0;
-clean_unregister_notifiers:
-	am65_cpsw_unregister_notifiers(common);
+
 err_cleanup_ndev:
 	am65_cpsw_nuss_cleanup_ndev(common);
+	am65_cpsw_unregister_devlink(common);
 
 	return ret;
 }
diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 90dfefc1f5f8..028a5df5c538 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -2504,7 +2504,7 @@ static int sfp_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, sfp);
 
-	err = devm_add_action(sfp->dev, sfp_cleanup, sfp);
+	err = devm_add_action_or_reset(sfp->dev, sfp_cleanup, sfp);
 	if (err < 0)
 		return err;
 
diff --git a/drivers/net/xen-netback/rx.c b/drivers/net/xen-netback/rx.c
index dbac4c03d21a..a0335407be42 100644
--- a/drivers/net/xen-netback/rx.c
+++ b/drivers/net/xen-netback/rx.c
@@ -495,6 +495,7 @@ void xenvif_rx_action(struct xenvif_queue *queue)
 	queue->rx_copy.completed = &completed_skbs;
 
 	while (xenvif_rx_ring_slots_available(queue) &&
+	       !skb_queue_empty(&queue->rx_queue) &&
 	       work_done < RX_BATCH_SIZE) {
 		xenvif_rx_skb(queue);
 		work_done++;
diff --git a/drivers/nfc/nxp-nci/i2c.c b/drivers/nfc/nxp-nci/i2c.c
index e8f3b35afbee..ae2ba08d8ac3 100644
--- a/drivers/nfc/nxp-nci/i2c.c
+++ b/drivers/nfc/nxp-nci/i2c.c
@@ -122,7 +122,9 @@ static int nxp_nci_i2c_fw_read(struct nxp_nci_i2c_phy *phy,
 	skb_put_data(*skb, &header, NXP_NCI_FW_HDR_LEN);
 
 	r = i2c_master_recv(client, skb_put(*skb, frame_len), frame_len);
-	if (r != frame_len) {
+	if (r < 0) {
+		goto fw_read_exit_free_skb;
+	} else if (r != frame_len) {
 		nfc_err(&client->dev,
 			"Invalid frame length: %u (expected %zu)\n",
 			r, frame_len);
@@ -166,7 +168,9 @@ static int nxp_nci_i2c_nci_read(struct nxp_nci_i2c_phy *phy,
 		return 0;
 
 	r = i2c_master_recv(client, skb_put(*skb, header.plen), header.plen);
-	if (r != header.plen) {
+	if (r < 0) {
+		goto nci_read_exit_free_skb;
+	} else if (r != header.plen) {
 		nfc_err(&client->dev,
 			"Invalid frame payload length: %u (expected %u)\n",
 			r, header.plen);
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 19054b791c67..29b56ea01132 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4385,6 +4385,8 @@ void nvme_stop_ctrl(struct nvme_ctrl *ctrl)
 	nvme_stop_failfast_work(ctrl);
 	flush_work(&ctrl->async_event_work);
 	cancel_work_sync(&ctrl->fw_act_work);
+	if (ctrl->ops->stop_ctrl)
+		ctrl->ops->stop_ctrl(ctrl);
 }
 EXPORT_SYMBOL_GPL(nvme_stop_ctrl);
 
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 72bcd7e5716e..75a7e7baa1fc 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -495,6 +495,7 @@ struct nvme_ctrl_ops {
 	void (*free_ctrl)(struct nvme_ctrl *ctrl);
 	void (*submit_async_event)(struct nvme_ctrl *ctrl);
 	void (*delete_ctrl)(struct nvme_ctrl *ctrl);
+	void (*stop_ctrl)(struct nvme_ctrl *ctrl);
 	int (*get_address)(struct nvme_ctrl *ctrl, char *buf, int size);
 };
 
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index c3db9f12dac3..d820131d39b2 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3337,7 +3337,8 @@ static const struct pci_device_id nvme_id_table[] = {
 				NVME_QUIRK_DISABLE_WRITE_ZEROES|
 				NVME_QUIRK_IGNORE_DEV_SUBNQN, },
 	{ PCI_DEVICE(0x1987, 0x5016),	/* Phison E16 */
-		.driver_data = NVME_QUIRK_IGNORE_DEV_SUBNQN, },
+		.driver_data = NVME_QUIRK_IGNORE_DEV_SUBNQN |
+				NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x1b4b, 0x1092),	/* Lexar 256 GB SSD */
 		.driver_data = NVME_QUIRK_NO_NS_DESC_LIST |
 				NVME_QUIRK_IGNORE_DEV_SUBNQN, },
diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index d51f52e296f5..2db9c166a1b7 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -1049,6 +1049,14 @@ static void nvme_rdma_teardown_io_queues(struct nvme_rdma_ctrl *ctrl,
 	}
 }
 
+static void nvme_rdma_stop_ctrl(struct nvme_ctrl *nctrl)
+{
+	struct nvme_rdma_ctrl *ctrl = to_rdma_ctrl(nctrl);
+
+	cancel_work_sync(&ctrl->err_work);
+	cancel_delayed_work_sync(&ctrl->reconnect_work);
+}
+
 static void nvme_rdma_free_ctrl(struct nvme_ctrl *nctrl)
 {
 	struct nvme_rdma_ctrl *ctrl = to_rdma_ctrl(nctrl);
@@ -2230,9 +2238,6 @@ static const struct blk_mq_ops nvme_rdma_admin_mq_ops = {
 
 static void nvme_rdma_shutdown_ctrl(struct nvme_rdma_ctrl *ctrl, bool shutdown)
 {
-	cancel_work_sync(&ctrl->err_work);
-	cancel_delayed_work_sync(&ctrl->reconnect_work);
-
 	nvme_rdma_teardown_io_queues(ctrl, shutdown);
 	blk_mq_quiesce_queue(ctrl->ctrl.admin_q);
 	if (shutdown)
@@ -2282,6 +2287,7 @@ static const struct nvme_ctrl_ops nvme_rdma_ctrl_ops = {
 	.submit_async_event	= nvme_rdma_submit_async_event,
 	.delete_ctrl		= nvme_rdma_delete_ctrl,
 	.get_address		= nvmf_get_address,
+	.stop_ctrl		= nvme_rdma_stop_ctrl,
 };
 
 /*
diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 10882d3d554c..20138e132558 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1162,8 +1162,7 @@ static int nvme_tcp_try_send(struct nvme_tcp_queue *queue)
 	} else if (ret < 0) {
 		dev_err(queue->ctrl->ctrl.device,
 			"failed to send request %d\n", ret);
-		if (ret != -EPIPE && ret != -ECONNRESET)
-			nvme_tcp_fail_request(queue->request);
+		nvme_tcp_fail_request(queue->request);
 		nvme_tcp_done_send_req(queue);
 	}
 	return ret;
@@ -2164,9 +2163,6 @@ static void nvme_tcp_error_recovery_work(struct work_struct *work)
 
 static void nvme_tcp_teardown_ctrl(struct nvme_ctrl *ctrl, bool shutdown)
 {
-	cancel_work_sync(&to_tcp_ctrl(ctrl)->err_work);
-	cancel_delayed_work_sync(&to_tcp_ctrl(ctrl)->connect_work);
-
 	nvme_tcp_teardown_io_queues(ctrl, shutdown);
 	blk_mq_quiesce_queue(ctrl->admin_q);
 	if (shutdown)
@@ -2206,6 +2202,12 @@ static void nvme_reset_ctrl_work(struct work_struct *work)
 	nvme_tcp_reconnect_or_remove(ctrl);
 }
 
+static void nvme_tcp_stop_ctrl(struct nvme_ctrl *ctrl)
+{
+	cancel_work_sync(&to_tcp_ctrl(ctrl)->err_work);
+	cancel_delayed_work_sync(&to_tcp_ctrl(ctrl)->connect_work);
+}
+
 static void nvme_tcp_free_ctrl(struct nvme_ctrl *nctrl)
 {
 	struct nvme_tcp_ctrl *ctrl = to_tcp_ctrl(nctrl);
@@ -2529,6 +2531,7 @@ static const struct nvme_ctrl_ops nvme_tcp_ctrl_ops = {
 	.submit_async_event	= nvme_tcp_submit_async_event,
 	.delete_ctrl		= nvme_tcp_delete_ctrl,
 	.get_address		= nvmf_get_address,
+	.stop_ctrl		= nvme_tcp_stop_ctrl,
 };
 
 static bool
diff --git a/drivers/pinctrl/aspeed/pinctrl-aspeed.c b/drivers/pinctrl/aspeed/pinctrl-aspeed.c
index c94e24aadf92..83d47ff1cea8 100644
--- a/drivers/pinctrl/aspeed/pinctrl-aspeed.c
+++ b/drivers/pinctrl/aspeed/pinctrl-aspeed.c
@@ -236,11 +236,11 @@ int aspeed_pinmux_set_mux(struct pinctrl_dev *pctldev, unsigned int function,
 		const struct aspeed_sig_expr **funcs;
 		const struct aspeed_sig_expr ***prios;
 
-		pr_debug("Muxing pin %s for %s\n", pdesc->name, pfunc->name);
-
 		if (!pdesc)
 			return -EINVAL;
 
+		pr_debug("Muxing pin %s for %s\n", pdesc->name, pfunc->name);
+
 		prios = pdesc->prios;
 
 		if (!prios)
diff --git a/drivers/platform/x86/hp-wmi.c b/drivers/platform/x86/hp-wmi.c
index 027a1467d009..1cd168e32810 100644
--- a/drivers/platform/x86/hp-wmi.c
+++ b/drivers/platform/x86/hp-wmi.c
@@ -63,6 +63,7 @@ enum hp_wmi_event_ids {
 	HPWMI_BACKLIT_KB_BRIGHTNESS	= 0x0D,
 	HPWMI_PEAKSHIFT_PERIOD		= 0x0F,
 	HPWMI_BATTERY_CHARGE_PERIOD	= 0x10,
+	HPWMI_SANITIZATION_MODE		= 0x17,
 };
 
 struct bios_args {
@@ -638,6 +639,8 @@ static void hp_wmi_notify(u32 value, void *context)
 		break;
 	case HPWMI_BATTERY_CHARGE_PERIOD:
 		break;
+	case HPWMI_SANITIZATION_MODE:
+		break;
 	default:
 		pr_info("Unknown event_id - %d - 0x%x\n", event_id, event_data);
 		break;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 1f5e0688c0c8..15c7451fb30f 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2758,6 +2758,7 @@ static int slave_configure_v3_hw(struct scsi_device *sdev)
 	struct hisi_hba *hisi_hba = shost_priv(shost);
 	struct device *dev = hisi_hba->dev;
 	int ret = sas_slave_configure(sdev);
+	unsigned int max_sectors;
 
 	if (ret)
 		return ret;
@@ -2775,6 +2776,12 @@ static int slave_configure_v3_hw(struct scsi_device *sdev)
 		}
 	}
 
+	/* Set according to IOMMU IOVA caching limit */
+	max_sectors = min_t(size_t, queue_max_hw_sectors(sdev->request_queue),
+			    (PAGE_SIZE * 32) >> SECTOR_SHIFT);
+
+	blk_queue_max_hw_sectors(sdev->request_queue, max_sectors);
+
 	return 0;
 }
 
diff --git a/drivers/soc/ixp4xx/ixp4xx-npe.c b/drivers/soc/ixp4xx/ixp4xx-npe.c
index f490c4ca51f5..a0159805d061 100644
--- a/drivers/soc/ixp4xx/ixp4xx-npe.c
+++ b/drivers/soc/ixp4xx/ixp4xx-npe.c
@@ -743,7 +743,7 @@ static const struct of_device_id ixp4xx_npe_of_match[] = {
 static struct platform_driver ixp4xx_npe_driver = {
 	.driver = {
 		.name           = "ixp4xx-npe",
-		.of_match_table = of_match_ptr(ixp4xx_npe_of_match),
+		.of_match_table = ixp4xx_npe_of_match,
 	},
 	.probe = ixp4xx_npe_probe,
 	.remove = ixp4xx_npe_remove,
diff --git a/drivers/spi/spi-amd.c b/drivers/spi/spi-amd.c
index 3cf76096a76d..39dbe9903da2 100644
--- a/drivers/spi/spi-amd.c
+++ b/drivers/spi/spi-amd.c
@@ -28,6 +28,7 @@
 #define AMD_SPI_RX_COUNT_REG	0x4B
 #define AMD_SPI_STATUS_REG	0x4C
 
+#define AMD_SPI_FIFO_SIZE	70
 #define AMD_SPI_MEM_SIZE	200
 
 /* M_CMD OP codes for SPI */
@@ -245,6 +246,11 @@ static int amd_spi_master_transfer(struct spi_master *master,
 	return 0;
 }
 
+static size_t amd_spi_max_transfer_size(struct spi_device *spi)
+{
+	return AMD_SPI_FIFO_SIZE;
+}
+
 static int amd_spi_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -275,6 +281,8 @@ static int amd_spi_probe(struct platform_device *pdev)
 	master->flags = SPI_MASTER_HALF_DUPLEX;
 	master->setup = amd_spi_master_setup;
 	master->transfer_one_message = amd_spi_master_transfer;
+	master->max_transfer_size = amd_spi_max_transfer_size;
+	master->max_message_size = amd_spi_max_transfer_size;
 
 	/* Register the controller with SPI framework */
 	err = devm_spi_register_master(dev, master);
diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index 1ce193daea7f..30b7890645ac 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -23,6 +23,7 @@
 #include <linux/sysrq.h>
 #include <linux/delay.h>
 #include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
 #include <linux/tty.h>
 #include <linux/ratelimit.h>
 #include <linux/tty_flip.h>
@@ -561,6 +562,9 @@ serial8250_register_ports(struct uart_driver *drv, struct device *dev)
 
 		up->port.dev = dev;
 
+		if (uart_console_enabled(&up->port))
+			pm_runtime_get_sync(up->port.dev);
+
 		serial8250_apply_quirks(up);
 		uart_add_one_port(drv, &up->port);
 	}
diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
index df9731f73746..4f66825abe67 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -2982,8 +2982,10 @@ static int serial8250_request_std_resource(struct uart_8250_port *up)
 	case UPIO_MEM32BE:
 	case UPIO_MEM16:
 	case UPIO_MEM:
-		if (!port->mapbase)
+		if (!port->mapbase) {
+			ret = -EINVAL;
 			break;
+		}
 
 		if (!request_mem_region(port->mapbase, size, "serial")) {
 			ret = -EBUSY;
diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index 0e908061b5d7..300a8bbb4b80 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -1372,6 +1372,15 @@ static void pl011_stop_rx(struct uart_port *port)
 	pl011_dma_rx_stop(uap);
 }
 
+static void pl011_throttle_rx(struct uart_port *port)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&port->lock, flags);
+	pl011_stop_rx(port);
+	spin_unlock_irqrestore(&port->lock, flags);
+}
+
 static void pl011_enable_ms(struct uart_port *port)
 {
 	struct uart_amba_port *uap =
@@ -1793,9 +1802,10 @@ static int pl011_allocate_irq(struct uart_amba_port *uap)
  */
 static void pl011_enable_interrupts(struct uart_amba_port *uap)
 {
+	unsigned long flags;
 	unsigned int i;
 
-	spin_lock_irq(&uap->port.lock);
+	spin_lock_irqsave(&uap->port.lock, flags);
 
 	/* Clear out any spuriously appearing RX interrupts */
 	pl011_write(UART011_RTIS | UART011_RXIS, uap, REG_ICR);
@@ -1817,7 +1827,14 @@ static void pl011_enable_interrupts(struct uart_amba_port *uap)
 	if (!pl011_dma_rx_running(uap))
 		uap->im |= UART011_RXIM;
 	pl011_write(uap->im, uap, REG_IMSC);
-	spin_unlock_irq(&uap->port.lock);
+	spin_unlock_irqrestore(&uap->port.lock, flags);
+}
+
+static void pl011_unthrottle_rx(struct uart_port *port)
+{
+	struct uart_amba_port *uap = container_of(port, struct uart_amba_port, port);
+
+	pl011_enable_interrupts(uap);
 }
 
 static int pl011_startup(struct uart_port *port)
@@ -2245,6 +2262,8 @@ static const struct uart_ops amba_pl011_pops = {
 	.stop_tx	= pl011_stop_tx,
 	.start_tx	= pl011_start_tx,
 	.stop_rx	= pl011_stop_rx,
+	.throttle	= pl011_throttle_rx,
+	.unthrottle	= pl011_unthrottle_rx,
 	.enable_ms	= pl011_enable_ms,
 	.break_ctl	= pl011_break_ctl,
 	.startup	= pl011_startup,
diff --git a/drivers/tty/serial/samsung_tty.c b/drivers/tty/serial/samsung_tty.c
index 319533b3c32a..f460b47ff6f2 100644
--- a/drivers/tty/serial/samsung_tty.c
+++ b/drivers/tty/serial/samsung_tty.c
@@ -378,8 +378,7 @@ static void enable_tx_dma(struct s3c24xx_uart_port *ourport)
 	/* Enable tx dma mode */
 	ucon = rd_regl(port, S3C2410_UCON);
 	ucon &= ~(S3C64XX_UCON_TXBURST_MASK | S3C64XX_UCON_TXMODE_MASK);
-	ucon |= (dma_get_cache_alignment() >= 16) ?
-		S3C64XX_UCON_TXBURST_16 : S3C64XX_UCON_TXBURST_1;
+	ucon |= S3C64XX_UCON_TXBURST_1;
 	ucon |= S3C64XX_UCON_TXMODE_DMA;
 	wr_regl(port,  S3C2410_UCON, ucon);
 
@@ -675,7 +674,7 @@ static void enable_rx_dma(struct s3c24xx_uart_port *ourport)
 			S3C64XX_UCON_DMASUS_EN |
 			S3C64XX_UCON_TIMEOUT_EN |
 			S3C64XX_UCON_RXMODE_MASK);
-	ucon |= S3C64XX_UCON_RXBURST_16 |
+	ucon |= S3C64XX_UCON_RXBURST_1 |
 			0xf << S3C64XX_UCON_TIMEOUT_SHIFT |
 			S3C64XX_UCON_EMPTYINT_EN |
 			S3C64XX_UCON_TIMEOUT_EN |
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 4d3ad4c6c60f..82ddbb92d07d 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1912,11 +1912,6 @@ static int uart_proc_show(struct seq_file *m, void *v)
 }
 #endif
 
-static inline bool uart_console_enabled(struct uart_port *port)
-{
-	return uart_console(port) && (port->cons->flags & CON_ENABLED);
-}
-
 static void uart_port_spin_lock_init(struct uart_port *port)
 {
 	spin_lock_init(&port->lock);
diff --git a/drivers/tty/serial/stm32-usart.c b/drivers/tty/serial/stm32-usart.c
index 10e9f983de62..fc166cc2c856 100644
--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -71,6 +71,8 @@ static void stm32_usart_config_reg_rs485(u32 *cr1, u32 *cr3, u32 delay_ADE,
 	*cr3 |= USART_CR3_DEM;
 	over8 = *cr1 & USART_CR1_OVER8;
 
+	*cr1 &= ~(USART_CR1_DEDT_MASK | USART_CR1_DEAT_MASK);
+
 	if (over8)
 		rs485_deat_dedt = delay_ADE * baud * 8;
 	else
diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 7359c3e80d63..55283a7f973f 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -855,7 +855,7 @@ static void delete_char(struct vc_data *vc, unsigned int nr)
 	unsigned short *p = (unsigned short *) vc->vc_pos;
 
 	vc_uniscr_delete(vc, nr);
-	scr_memcpyw(p, p + nr, (vc->vc_cols - vc->state.x - nr) * 2);
+	scr_memmovew(p, p + nr, (vc->vc_cols - vc->state.x - nr) * 2);
 	scr_memsetw(p + vc->vc_cols - vc->state.x - nr, vc->vc_video_erase_char,
 			nr * 2);
 	vc->vc_need_wrap = 0;
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 99d0372ed840..e534b98205ca 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -4149,7 +4149,6 @@ static irqreturn_t dwc3_process_event_buf(struct dwc3_event_buffer *evt)
 	}
 
 	evt->count = 0;
-	evt->flags &= ~DWC3_EVENT_PENDING;
 	ret = IRQ_HANDLED;
 
 	/* Unmask interrupt */
@@ -4162,6 +4161,9 @@ static irqreturn_t dwc3_process_event_buf(struct dwc3_event_buffer *evt)
 		dwc3_writel(dwc->regs, DWC3_DEV_IMOD(0), dwc->imod_interval);
 	}
 
+	/* Keep the clearing of DWC3_EVENT_PENDING at the end */
+	evt->flags &= ~DWC3_EVENT_PENDING;
+
 	return ret;
 }
 
diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 7e852561d55c..e2a8c33f0cae 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1023,6 +1023,9 @@ static const struct usb_device_id id_table_combined[] = {
 	{ USB_DEVICE(FTDI_VID, CHETCO_SEASMART_DISPLAY_PID) },
 	{ USB_DEVICE(FTDI_VID, CHETCO_SEASMART_LITE_PID) },
 	{ USB_DEVICE(FTDI_VID, CHETCO_SEASMART_ANALOG_PID) },
+	/* Belimo Automation devices */
+	{ USB_DEVICE(FTDI_VID, BELIMO_ZTH_PID) },
+	{ USB_DEVICE(FTDI_VID, BELIMO_ZIP_PID) },
 	/* ICP DAS I-756xU devices */
 	{ USB_DEVICE(ICPDAS_VID, ICPDAS_I7560U_PID) },
 	{ USB_DEVICE(ICPDAS_VID, ICPDAS_I7561U_PID) },
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index d1a9564697a4..4e92c165c86b 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -1568,6 +1568,12 @@
 #define CHETCO_SEASMART_LITE_PID	0xA5AE /* SeaSmart Lite USB Adapter */
 #define CHETCO_SEASMART_ANALOG_PID	0xA5AF /* SeaSmart Analog Adapter */
 
+/*
+ * Belimo Automation
+ */
+#define BELIMO_ZTH_PID			0x8050
+#define BELIMO_ZIP_PID			0xC811
+
 /*
  * Unjo AB
  */
diff --git a/drivers/usb/typec/class.c b/drivers/usb/typec/class.c
index aeef453aa658..ff6c14d7b1a8 100644
--- a/drivers/usb/typec/class.c
+++ b/drivers/usb/typec/class.c
@@ -1718,6 +1718,7 @@ void typec_set_pwr_opmode(struct typec_port *port,
 			partner->usb_pd = 1;
 			sysfs_notify(&partner_dev->kobj, NULL,
 				     "supports_usb_power_delivery");
+			kobject_uevent(&partner_dev->kobj, KOBJ_CHANGE);
 		}
 		put_device(partner_dev);
 	}
diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 467a349dc26c..e748c00789f0 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1898,7 +1898,6 @@ static int verify_driver_features(struct mlx5_vdpa_dev *mvdev, u64 features)
 static int setup_virtqueues(struct mlx5_vdpa_dev *mvdev)
 {
 	struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
-	struct mlx5_control_vq *cvq = &mvdev->cvq;
 	int err;
 	int i;
 
@@ -1908,16 +1907,6 @@ static int setup_virtqueues(struct mlx5_vdpa_dev *mvdev)
 			goto err_vq;
 	}
 
-	if (mvdev->actual_features & BIT_ULL(VIRTIO_NET_F_CTRL_VQ)) {
-		err = vringh_init_iotlb(&cvq->vring, mvdev->actual_features,
-					MLX5_CVQ_MAX_ENT, false,
-					(struct vring_desc *)(uintptr_t)cvq->desc_addr,
-					(struct vring_avail *)(uintptr_t)cvq->driver_addr,
-					(struct vring_used *)(uintptr_t)cvq->device_addr);
-		if (err)
-			goto err_vq;
-	}
-
 	return 0;
 
 err_vq:
@@ -2184,6 +2173,21 @@ static void clear_vqs_ready(struct mlx5_vdpa_net *ndev)
 	ndev->mvdev.cvq.ready = false;
 }
 
+static int setup_cvq_vring(struct mlx5_vdpa_dev *mvdev)
+{
+	struct mlx5_control_vq *cvq = &mvdev->cvq;
+	int err = 0;
+
+	if (mvdev->actual_features & BIT_ULL(VIRTIO_NET_F_CTRL_VQ))
+		err = vringh_init_iotlb(&cvq->vring, mvdev->actual_features,
+					MLX5_CVQ_MAX_ENT, false,
+					(struct vring_desc *)(uintptr_t)cvq->desc_addr,
+					(struct vring_avail *)(uintptr_t)cvq->driver_addr,
+					(struct vring_used *)(uintptr_t)cvq->device_addr);
+
+	return err;
+}
+
 static void mlx5_vdpa_set_status(struct vdpa_device *vdev, u8 status)
 {
 	struct mlx5_vdpa_dev *mvdev = to_mvdev(vdev);
@@ -2194,6 +2198,11 @@ static void mlx5_vdpa_set_status(struct vdpa_device *vdev, u8 status)
 
 	if ((status ^ ndev->mvdev.status) & VIRTIO_CONFIG_S_DRIVER_OK) {
 		if (status & VIRTIO_CONFIG_S_DRIVER_OK) {
+			err = setup_cvq_vring(mvdev);
+			if (err) {
+				mlx5_vdpa_warn(mvdev, "failed to setup control VQ vring\n");
+				goto err_setup;
+			}
 			err = setup_driver(mvdev);
 			if (err) {
 				mlx5_vdpa_warn(mvdev, "failed to setup driver\n");
diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
index 9270398caf15..73e67fa88972 100644
--- a/drivers/vdpa/vdpa_user/vduse_dev.c
+++ b/drivers/vdpa/vdpa_user/vduse_dev.c
@@ -1466,16 +1466,12 @@ static char *vduse_devnode(struct device *dev, umode_t *mode)
 	return kasprintf(GFP_KERNEL, "vduse/%s", dev_name(dev));
 }
 
-static void vduse_mgmtdev_release(struct device *dev)
-{
-}
-
-static struct device vduse_mgmtdev = {
-	.init_name = "vduse",
-	.release = vduse_mgmtdev_release,
+struct vduse_mgmt_dev {
+	struct vdpa_mgmt_dev mgmt_dev;
+	struct device dev;
 };
 
-static struct vdpa_mgmt_dev mgmt_dev;
+static struct vduse_mgmt_dev *vduse_mgmt;
 
 static int vduse_dev_init_vdpa(struct vduse_dev *dev, const char *name)
 {
@@ -1500,7 +1496,7 @@ static int vduse_dev_init_vdpa(struct vduse_dev *dev, const char *name)
 	}
 	set_dma_ops(&vdev->vdpa.dev, &vduse_dev_dma_ops);
 	vdev->vdpa.dma_dev = &vdev->vdpa.dev;
-	vdev->vdpa.mdev = &mgmt_dev;
+	vdev->vdpa.mdev = &vduse_mgmt->mgmt_dev;
 
 	return 0;
 }
@@ -1545,34 +1541,52 @@ static struct virtio_device_id id_table[] = {
 	{ 0 },
 };
 
-static struct vdpa_mgmt_dev mgmt_dev = {
-	.device = &vduse_mgmtdev,
-	.id_table = id_table,
-	.ops = &vdpa_dev_mgmtdev_ops,
-};
+static void vduse_mgmtdev_release(struct device *dev)
+{
+	struct vduse_mgmt_dev *mgmt_dev;
+
+	mgmt_dev = container_of(dev, struct vduse_mgmt_dev, dev);
+	kfree(mgmt_dev);
+}
 
 static int vduse_mgmtdev_init(void)
 {
 	int ret;
 
-	ret = device_register(&vduse_mgmtdev);
-	if (ret)
+	vduse_mgmt = kzalloc(sizeof(*vduse_mgmt), GFP_KERNEL);
+	if (!vduse_mgmt)
+		return -ENOMEM;
+
+	ret = dev_set_name(&vduse_mgmt->dev, "vduse");
+	if (ret) {
+		kfree(vduse_mgmt);
 		return ret;
+	}
 
-	ret = vdpa_mgmtdev_register(&mgmt_dev);
+	vduse_mgmt->dev.release = vduse_mgmtdev_release;
+
+	ret = device_register(&vduse_mgmt->dev);
 	if (ret)
-		goto err;
+		goto dev_reg_err;
 
-	return 0;
-err:
-	device_unregister(&vduse_mgmtdev);
+	vduse_mgmt->mgmt_dev.id_table = id_table;
+	vduse_mgmt->mgmt_dev.ops = &vdpa_dev_mgmtdev_ops;
+	vduse_mgmt->mgmt_dev.device = &vduse_mgmt->dev;
+	ret = vdpa_mgmtdev_register(&vduse_mgmt->mgmt_dev);
+	if (ret)
+		device_unregister(&vduse_mgmt->dev);
+
+	return ret;
+
+dev_reg_err:
+	put_device(&vduse_mgmt->dev);
 	return ret;
 }
 
 static void vduse_mgmtdev_exit(void)
 {
-	vdpa_mgmtdev_unregister(&mgmt_dev);
-	device_unregister(&vduse_mgmtdev);
+	vdpa_mgmtdev_unregister(&vduse_mgmt->mgmt_dev);
+	device_unregister(&vduse_mgmt->dev);
 }
 
 static int vduse_init(void)
diff --git a/drivers/video/fbdev/core/fbmem.c b/drivers/video/fbdev/core/fbmem.c
index 6d7868cc1fca..528c87ff14d8 100644
--- a/drivers/video/fbdev/core/fbmem.c
+++ b/drivers/video/fbdev/core/fbmem.c
@@ -19,6 +19,7 @@
 #include <linux/kernel.h>
 #include <linux/major.h>
 #include <linux/slab.h>
+#include <linux/sysfb.h>
 #include <linux/mm.h>
 #include <linux/mman.h>
 #include <linux/vt.h>
@@ -1786,6 +1787,17 @@ int remove_conflicting_framebuffers(struct apertures_struct *a,
 		do_free = true;
 	}
 
+	/*
+	 * If a driver asked to unregister a platform device registered by
+	 * sysfb, then can be assumed that this is a driver for a display
+	 * that is set up by the system firmware and has a generic driver.
+	 *
+	 * Drivers for devices that don't have a generic driver will never
+	 * ask for this, so let's assume that a real driver for the display
+	 * was already probed and prevent sysfb to register devices later.
+	 */
+	sysfb_disable();
+
 	mutex_lock(&registration_lock);
 	do_remove_conflicting_framebuffers(a, name, primary);
 	mutex_unlock(&registration_lock);
diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
index 1dd396d4bebb..fe696aafaed8 100644
--- a/drivers/virtio/virtio_mmio.c
+++ b/drivers/virtio/virtio_mmio.c
@@ -62,6 +62,7 @@
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
+#include <linux/pm.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/virtio.h>
@@ -543,6 +544,28 @@ static const struct virtio_config_ops virtio_mmio_config_ops = {
 	.get_shm_region = vm_get_shm_region,
 };
 
+#ifdef CONFIG_PM_SLEEP
+static int virtio_mmio_freeze(struct device *dev)
+{
+	struct virtio_mmio_device *vm_dev = dev_get_drvdata(dev);
+
+	return virtio_device_freeze(&vm_dev->vdev);
+}
+
+static int virtio_mmio_restore(struct device *dev)
+{
+	struct virtio_mmio_device *vm_dev = dev_get_drvdata(dev);
+
+	if (vm_dev->version == 1)
+		writel(PAGE_SIZE, vm_dev->base + VIRTIO_MMIO_GUEST_PAGE_SIZE);
+
+	return virtio_device_restore(&vm_dev->vdev);
+}
+
+static const struct dev_pm_ops virtio_mmio_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(virtio_mmio_freeze, virtio_mmio_restore)
+};
+#endif
 
 static void virtio_mmio_release_dev(struct device *_d)
 {
@@ -786,6 +809,9 @@ static struct platform_driver virtio_mmio_driver = {
 		.name	= "virtio-mmio",
 		.of_match_table	= virtio_mmio_match,
 		.acpi_match_table = ACPI_PTR(virtio_mmio_acpi_match),
+#ifdef CONFIG_PM_SLEEP
+		.pm	= &virtio_mmio_pm_ops,
+#endif
 	},
 };
 
diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index 4b56c39f766d..84b143eef395 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -396,13 +396,15 @@ static void __unmap_grant_pages_done(int result,
 	unsigned int offset = data->unmap_ops - map->unmap_ops;
 
 	for (i = 0; i < data->count; i++) {
-		WARN_ON(map->unmap_ops[offset+i].status);
+		WARN_ON(map->unmap_ops[offset + i].status != GNTST_okay &&
+			map->unmap_ops[offset + i].handle != INVALID_GRANT_HANDLE);
 		pr_debug("unmap handle=%d st=%d\n",
 			map->unmap_ops[offset+i].handle,
 			map->unmap_ops[offset+i].status);
 		map->unmap_ops[offset+i].handle = INVALID_GRANT_HANDLE;
 		if (use_ptemod) {
-			WARN_ON(map->kunmap_ops[offset+i].status);
+			WARN_ON(map->kunmap_ops[offset + i].status != GNTST_okay &&
+				map->kunmap_ops[offset + i].handle != INVALID_GRANT_HANDLE);
 			pr_debug("kunmap handle=%u st=%d\n",
 				 map->kunmap_ops[offset+i].handle,
 				 map->kunmap_ops[offset+i].status);
diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 86816088927f..81b11124b67a 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -1455,7 +1455,7 @@ static int btrfsic_map_block(struct btrfsic_state *state, u64 bytenr, u32 len,
 	struct btrfs_fs_info *fs_info = state->fs_info;
 	int ret;
 	u64 length;
-	struct btrfs_bio *multi = NULL;
+	struct btrfs_io_context *multi = NULL;
 	struct btrfs_device *device;
 
 	length = len;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index f11616f61dd6..e3514f9a4e8d 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1266,7 +1266,7 @@ static int btrfs_issue_discard(struct block_device *bdev, u64 start, u64 len,
 	return ret;
 }
 
-static int do_discard_extent(struct btrfs_bio_stripe *stripe, u64 *bytes)
+static int do_discard_extent(struct btrfs_io_stripe *stripe, u64 *bytes)
 {
 	struct btrfs_device *dev = stripe->dev;
 	struct btrfs_fs_info *fs_info = dev->fs_info;
@@ -1313,22 +1313,21 @@ int btrfs_discard_extent(struct btrfs_fs_info *fs_info, u64 bytenr,
 	u64 discarded_bytes = 0;
 	u64 end = bytenr + num_bytes;
 	u64 cur = bytenr;
-	struct btrfs_bio *bbio = NULL;
-
+	struct btrfs_io_context *bioc = NULL;
 
 	/*
-	 * Avoid races with device replace and make sure our bbio has devices
+	 * Avoid races with device replace and make sure our bioc has devices
 	 * associated to its stripes that don't go away while we are discarding.
 	 */
 	btrfs_bio_counter_inc_blocked(fs_info);
 	while (cur < end) {
-		struct btrfs_bio_stripe *stripe;
+		struct btrfs_io_stripe *stripe;
 		int i;
 
 		num_bytes = end - cur;
 		/* Tell the block device(s) that the sectors can be discarded */
 		ret = btrfs_map_block(fs_info, BTRFS_MAP_DISCARD, cur,
-				      &num_bytes, &bbio, 0);
+				      &num_bytes, &bioc, 0);
 		/*
 		 * Error can be -ENOMEM, -ENOENT (no such chunk mapping) or
 		 * -EOPNOTSUPP. For any such error, @num_bytes is not updated,
@@ -1337,8 +1336,8 @@ int btrfs_discard_extent(struct btrfs_fs_info *fs_info, u64 bytenr,
 		if (ret < 0)
 			goto out;
 
-		stripe = bbio->stripes;
-		for (i = 0; i < bbio->num_stripes; i++, stripe++) {
+		stripe = bioc->stripes;
+		for (i = 0; i < bioc->num_stripes; i++, stripe++) {
 			u64 bytes;
 			struct btrfs_device *device = stripe->dev;
 
@@ -1361,7 +1360,7 @@ int btrfs_discard_extent(struct btrfs_fs_info *fs_info, u64 bytenr,
 				 * And since there are two loops, explicitly
 				 * go to out to avoid confusion.
 				 */
-				btrfs_put_bbio(bbio);
+				btrfs_put_bioc(bioc);
 				goto out;
 			}
 
@@ -1372,7 +1371,7 @@ int btrfs_discard_extent(struct btrfs_fs_info *fs_info, u64 bytenr,
 			 */
 			ret = 0;
 		}
-		btrfs_put_bbio(bbio);
+		btrfs_put_bioc(bioc);
 		cur += num_bytes;
 	}
 out:
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 059bd0753e27..b791e280af0c 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2290,7 +2290,7 @@ int repair_io_failure(struct btrfs_fs_info *fs_info, u64 ino, u64 start,
 	struct btrfs_device *dev;
 	u64 map_length = 0;
 	u64 sector;
-	struct btrfs_bio *bbio = NULL;
+	struct btrfs_io_context *bioc = NULL;
 	int ret;
 
 	ASSERT(!(fs_info->sb->s_flags & SB_RDONLY));
@@ -2304,7 +2304,7 @@ int repair_io_failure(struct btrfs_fs_info *fs_info, u64 ino, u64 start,
 	map_length = length;
 
 	/*
-	 * Avoid races with device replace and make sure our bbio has devices
+	 * Avoid races with device replace and make sure our bioc has devices
 	 * associated to its stripes that don't go away while we are doing the
 	 * read repair operation.
 	 */
@@ -2317,28 +2317,28 @@ int repair_io_failure(struct btrfs_fs_info *fs_info, u64 ino, u64 start,
 		 * stripe's dev and sector.
 		 */
 		ret = btrfs_map_block(fs_info, BTRFS_MAP_READ, logical,
-				      &map_length, &bbio, 0);
+				      &map_length, &bioc, 0);
 		if (ret) {
 			btrfs_bio_counter_dec(fs_info);
 			bio_put(bio);
 			return -EIO;
 		}
-		ASSERT(bbio->mirror_num == 1);
+		ASSERT(bioc->mirror_num == 1);
 	} else {
 		ret = btrfs_map_block(fs_info, BTRFS_MAP_WRITE, logical,
-				      &map_length, &bbio, mirror_num);
+				      &map_length, &bioc, mirror_num);
 		if (ret) {
 			btrfs_bio_counter_dec(fs_info);
 			bio_put(bio);
 			return -EIO;
 		}
-		BUG_ON(mirror_num != bbio->mirror_num);
+		BUG_ON(mirror_num != bioc->mirror_num);
 	}
 
-	sector = bbio->stripes[bbio->mirror_num - 1].physical >> 9;
+	sector = bioc->stripes[bioc->mirror_num - 1].physical >> 9;
 	bio->bi_iter.bi_sector = sector;
-	dev = bbio->stripes[bbio->mirror_num - 1].dev;
-	btrfs_put_bbio(bbio);
+	dev = bioc->stripes[bioc->mirror_num - 1].dev;
+	btrfs_put_bioc(bioc);
 	if (!dev || !dev->bdev ||
 	    !test_bit(BTRFS_DEV_STATE_WRITEABLE, &dev->dev_state)) {
 		btrfs_bio_counter_dec(fs_info);
diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 4a8e02f7b6c7..5a36add21305 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -360,7 +360,7 @@ static void extent_map_device_set_bits(struct extent_map *em, unsigned bits)
 	int i;
 
 	for (i = 0; i < map->num_stripes; i++) {
-		struct btrfs_bio_stripe *stripe = &map->stripes[i];
+		struct btrfs_io_stripe *stripe = &map->stripes[i];
 		struct btrfs_device *device = stripe->dev;
 
 		set_extent_bits_nowait(&device->alloc_state, stripe->physical,
@@ -375,7 +375,7 @@ static void extent_map_device_clear_bits(struct extent_map *em, unsigned bits)
 	int i;
 
 	for (i = 0; i < map->num_stripes; i++) {
-		struct btrfs_bio_stripe *stripe = &map->stripes[i];
+		struct btrfs_io_stripe *stripe = &map->stripes[i];
 		struct btrfs_device *device = stripe->dev;
 
 		__clear_extent_bit(&device->alloc_state, stripe->physical,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d644dcaf3004..ea7262050790 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7957,7 +7957,19 @@ static int btrfs_dio_iomap_begin(struct inode *inode, loff_t start,
 	if (test_bit(EXTENT_FLAG_COMPRESSED, &em->flags) ||
 	    em->block_start == EXTENT_MAP_INLINE) {
 		free_extent_map(em);
-		ret = -ENOTBLK;
+		/*
+		 * If we are in a NOWAIT context, return -EAGAIN in order to
+		 * fallback to buffered IO. This is not only because we can
+		 * block with buffered IO (no support for NOWAIT semantics at
+		 * the moment) but also to avoid returning short reads to user
+		 * space - this happens if we were able to read some data from
+		 * previous non-compressed extents and then when we fallback to
+		 * buffered IO, at btrfs_file_read_iter() by calling
+		 * filemap_read(), we fail to fault in pages for the read buffer,
+		 * in which case filemap_read() returns a short read (the number
+		 * of bytes previously read is > 0, so it does not return -EFAULT).
+		 */
+		ret = (flags & IOMAP_NOWAIT) ? -EAGAIN : -ENOTBLK;
 		goto unlock_err;
 	}
 
diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index d8d268ca8aa7..893d93e3c516 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -61,7 +61,7 @@ enum btrfs_rbio_ops {
 
 struct btrfs_raid_bio {
 	struct btrfs_fs_info *fs_info;
-	struct btrfs_bio *bbio;
+	struct btrfs_io_context *bioc;
 
 	/* while we're doing rmw on a stripe
 	 * we put it into a hash table so we can
@@ -271,7 +271,7 @@ static void cache_rbio_pages(struct btrfs_raid_bio *rbio)
  */
 static int rbio_bucket(struct btrfs_raid_bio *rbio)
 {
-	u64 num = rbio->bbio->raid_map[0];
+	u64 num = rbio->bioc->raid_map[0];
 
 	/*
 	 * we shift down quite a bit.  We're using byte
@@ -559,8 +559,7 @@ static int rbio_can_merge(struct btrfs_raid_bio *last,
 	    test_bit(RBIO_CACHE_BIT, &cur->flags))
 		return 0;
 
-	if (last->bbio->raid_map[0] !=
-	    cur->bbio->raid_map[0])
+	if (last->bioc->raid_map[0] != cur->bioc->raid_map[0])
 		return 0;
 
 	/* we can't merge with different operations */
@@ -673,7 +672,7 @@ static noinline int lock_stripe_add(struct btrfs_raid_bio *rbio)
 
 	spin_lock_irqsave(&h->lock, flags);
 	list_for_each_entry(cur, &h->hash_list, hash_list) {
-		if (cur->bbio->raid_map[0] != rbio->bbio->raid_map[0])
+		if (cur->bioc->raid_map[0] != rbio->bioc->raid_map[0])
 			continue;
 
 		spin_lock(&cur->bio_list_lock);
@@ -838,7 +837,7 @@ static void __free_raid_bio(struct btrfs_raid_bio *rbio)
 		}
 	}
 
-	btrfs_put_bbio(rbio->bbio);
+	btrfs_put_bioc(rbio->bioc);
 	kfree(rbio);
 }
 
@@ -906,7 +905,7 @@ static void raid_write_end_io(struct bio *bio)
 
 	/* OK, we have read all the stripes we need to. */
 	max_errors = (rbio->operation == BTRFS_RBIO_PARITY_SCRUB) ?
-		     0 : rbio->bbio->max_errors;
+		     0 : rbio->bioc->max_errors;
 	if (atomic_read(&rbio->error) > max_errors)
 		err = BLK_STS_IOERR;
 
@@ -961,12 +960,12 @@ static unsigned long rbio_nr_pages(unsigned long stripe_len, int nr_stripes)
  * this does not allocate any pages for rbio->pages.
  */
 static struct btrfs_raid_bio *alloc_rbio(struct btrfs_fs_info *fs_info,
-					 struct btrfs_bio *bbio,
+					 struct btrfs_io_context *bioc,
 					 u64 stripe_len)
 {
 	struct btrfs_raid_bio *rbio;
 	int nr_data = 0;
-	int real_stripes = bbio->num_stripes - bbio->num_tgtdevs;
+	int real_stripes = bioc->num_stripes - bioc->num_tgtdevs;
 	int num_pages = rbio_nr_pages(stripe_len, real_stripes);
 	int stripe_npages = DIV_ROUND_UP(stripe_len, PAGE_SIZE);
 	void *p;
@@ -987,7 +986,7 @@ static struct btrfs_raid_bio *alloc_rbio(struct btrfs_fs_info *fs_info,
 	spin_lock_init(&rbio->bio_list_lock);
 	INIT_LIST_HEAD(&rbio->stripe_cache);
 	INIT_LIST_HEAD(&rbio->hash_list);
-	rbio->bbio = bbio;
+	rbio->bioc = bioc;
 	rbio->fs_info = fs_info;
 	rbio->stripe_len = stripe_len;
 	rbio->nr_pages = num_pages;
@@ -1015,9 +1014,9 @@ static struct btrfs_raid_bio *alloc_rbio(struct btrfs_fs_info *fs_info,
 	CONSUME_ALLOC(rbio->finish_pbitmap, BITS_TO_LONGS(stripe_npages));
 #undef  CONSUME_ALLOC
 
-	if (bbio->map_type & BTRFS_BLOCK_GROUP_RAID5)
+	if (bioc->map_type & BTRFS_BLOCK_GROUP_RAID5)
 		nr_data = real_stripes - 1;
-	else if (bbio->map_type & BTRFS_BLOCK_GROUP_RAID6)
+	else if (bioc->map_type & BTRFS_BLOCK_GROUP_RAID6)
 		nr_data = real_stripes - 2;
 	else
 		BUG();
@@ -1077,10 +1076,10 @@ static int rbio_add_io_page(struct btrfs_raid_bio *rbio,
 	struct bio *last = bio_list->tail;
 	int ret;
 	struct bio *bio;
-	struct btrfs_bio_stripe *stripe;
+	struct btrfs_io_stripe *stripe;
 	u64 disk_start;
 
-	stripe = &rbio->bbio->stripes[stripe_nr];
+	stripe = &rbio->bioc->stripes[stripe_nr];
 	disk_start = stripe->physical + (page_index << PAGE_SHIFT);
 
 	/* if the device is missing, just fail this stripe */
@@ -1155,7 +1154,7 @@ static void index_rbio_pages(struct btrfs_raid_bio *rbio)
 		int i = 0;
 
 		start = bio->bi_iter.bi_sector << 9;
-		stripe_offset = start - rbio->bbio->raid_map[0];
+		stripe_offset = start - rbio->bioc->raid_map[0];
 		page_index = stripe_offset >> PAGE_SHIFT;
 
 		if (bio_flagged(bio, BIO_CLONED))
@@ -1179,7 +1178,7 @@ static void index_rbio_pages(struct btrfs_raid_bio *rbio)
  */
 static noinline void finish_rmw(struct btrfs_raid_bio *rbio)
 {
-	struct btrfs_bio *bbio = rbio->bbio;
+	struct btrfs_io_context *bioc = rbio->bioc;
 	void **pointers = rbio->finish_pointers;
 	int nr_data = rbio->nr_data;
 	int stripe;
@@ -1284,11 +1283,11 @@ static noinline void finish_rmw(struct btrfs_raid_bio *rbio)
 		}
 	}
 
-	if (likely(!bbio->num_tgtdevs))
+	if (likely(!bioc->num_tgtdevs))
 		goto write_data;
 
 	for (stripe = 0; stripe < rbio->real_stripes; stripe++) {
-		if (!bbio->tgtdev_map[stripe])
+		if (!bioc->tgtdev_map[stripe])
 			continue;
 
 		for (pagenr = 0; pagenr < rbio->stripe_npages; pagenr++) {
@@ -1302,7 +1301,7 @@ static noinline void finish_rmw(struct btrfs_raid_bio *rbio)
 			}
 
 			ret = rbio_add_io_page(rbio, &bio_list, page,
-					       rbio->bbio->tgtdev_map[stripe],
+					       rbio->bioc->tgtdev_map[stripe],
 					       pagenr, rbio->stripe_len);
 			if (ret)
 				goto cleanup;
@@ -1339,12 +1338,12 @@ static int find_bio_stripe(struct btrfs_raid_bio *rbio,
 {
 	u64 physical = bio->bi_iter.bi_sector;
 	int i;
-	struct btrfs_bio_stripe *stripe;
+	struct btrfs_io_stripe *stripe;
 
 	physical <<= 9;
 
-	for (i = 0; i < rbio->bbio->num_stripes; i++) {
-		stripe = &rbio->bbio->stripes[i];
+	for (i = 0; i < rbio->bioc->num_stripes; i++) {
+		stripe = &rbio->bioc->stripes[i];
 		if (in_range(physical, stripe->physical, rbio->stripe_len) &&
 		    stripe->dev->bdev && bio->bi_bdev == stripe->dev->bdev) {
 			return i;
@@ -1365,7 +1364,7 @@ static int find_logical_bio_stripe(struct btrfs_raid_bio *rbio,
 	int i;
 
 	for (i = 0; i < rbio->nr_data; i++) {
-		u64 stripe_start = rbio->bbio->raid_map[i];
+		u64 stripe_start = rbio->bioc->raid_map[i];
 
 		if (in_range(logical, stripe_start, rbio->stripe_len))
 			return i;
@@ -1456,7 +1455,7 @@ static void raid_rmw_end_io(struct bio *bio)
 	if (!atomic_dec_and_test(&rbio->stripes_pending))
 		return;
 
-	if (atomic_read(&rbio->error) > rbio->bbio->max_errors)
+	if (atomic_read(&rbio->error) > rbio->bioc->max_errors)
 		goto cleanup;
 
 	/*
@@ -1538,8 +1537,8 @@ static int raid56_rmw_stripe(struct btrfs_raid_bio *rbio)
 	}
 
 	/*
-	 * the bbio may be freed once we submit the last bio.  Make sure
-	 * not to touch it after that
+	 * The bioc may be freed once we submit the last bio. Make sure not to
+	 * touch it after that.
 	 */
 	atomic_set(&rbio->stripes_pending, bios_to_read);
 	while ((bio = bio_list_pop(&bio_list))) {
@@ -1720,16 +1719,16 @@ static void btrfs_raid_unplug(struct blk_plug_cb *cb, bool from_schedule)
  * our main entry point for writes from the rest of the FS.
  */
 int raid56_parity_write(struct btrfs_fs_info *fs_info, struct bio *bio,
-			struct btrfs_bio *bbio, u64 stripe_len)
+			struct btrfs_io_context *bioc, u64 stripe_len)
 {
 	struct btrfs_raid_bio *rbio;
 	struct btrfs_plug_cb *plug = NULL;
 	struct blk_plug_cb *cb;
 	int ret;
 
-	rbio = alloc_rbio(fs_info, bbio, stripe_len);
+	rbio = alloc_rbio(fs_info, bioc, stripe_len);
 	if (IS_ERR(rbio)) {
-		btrfs_put_bbio(bbio);
+		btrfs_put_bioc(bioc);
 		return PTR_ERR(rbio);
 	}
 	bio_list_add(&rbio->bio_list, bio);
@@ -1842,7 +1841,7 @@ static void __raid_recover_end_io(struct btrfs_raid_bio *rbio)
 		}
 
 		/* all raid6 handling here */
-		if (rbio->bbio->map_type & BTRFS_BLOCK_GROUP_RAID6) {
+		if (rbio->bioc->map_type & BTRFS_BLOCK_GROUP_RAID6) {
 			/*
 			 * single failure, rebuild from parity raid5
 			 * style
@@ -1874,8 +1873,8 @@ static void __raid_recover_end_io(struct btrfs_raid_bio *rbio)
 			 * here due to a crc mismatch and we can't give them the
 			 * data they want
 			 */
-			if (rbio->bbio->raid_map[failb] == RAID6_Q_STRIPE) {
-				if (rbio->bbio->raid_map[faila] ==
+			if (rbio->bioc->raid_map[failb] == RAID6_Q_STRIPE) {
+				if (rbio->bioc->raid_map[faila] ==
 				    RAID5_P_STRIPE) {
 					err = BLK_STS_IOERR;
 					goto cleanup;
@@ -1887,7 +1886,7 @@ static void __raid_recover_end_io(struct btrfs_raid_bio *rbio)
 				goto pstripe;
 			}
 
-			if (rbio->bbio->raid_map[failb] == RAID5_P_STRIPE) {
+			if (rbio->bioc->raid_map[failb] == RAID5_P_STRIPE) {
 				raid6_datap_recov(rbio->real_stripes,
 						  PAGE_SIZE, faila, pointers);
 			} else {
@@ -2006,7 +2005,7 @@ static void raid_recover_end_io(struct bio *bio)
 	if (!atomic_dec_and_test(&rbio->stripes_pending))
 		return;
 
-	if (atomic_read(&rbio->error) > rbio->bbio->max_errors)
+	if (atomic_read(&rbio->error) > rbio->bioc->max_errors)
 		rbio_orig_end_io(rbio, BLK_STS_IOERR);
 	else
 		__raid_recover_end_io(rbio);
@@ -2074,7 +2073,7 @@ static int __raid56_parity_recover(struct btrfs_raid_bio *rbio)
 		 * were up to date, or we might have no bios to read because
 		 * the devices were gone.
 		 */
-		if (atomic_read(&rbio->error) <= rbio->bbio->max_errors) {
+		if (atomic_read(&rbio->error) <= rbio->bioc->max_errors) {
 			__raid_recover_end_io(rbio);
 			return 0;
 		} else {
@@ -2083,8 +2082,8 @@ static int __raid56_parity_recover(struct btrfs_raid_bio *rbio)
 	}
 
 	/*
-	 * the bbio may be freed once we submit the last bio.  Make sure
-	 * not to touch it after that
+	 * The bioc may be freed once we submit the last bio. Make sure not to
+	 * touch it after that.
 	 */
 	atomic_set(&rbio->stripes_pending, bios_to_read);
 	while ((bio = bio_list_pop(&bio_list))) {
@@ -2117,21 +2116,21 @@ static int __raid56_parity_recover(struct btrfs_raid_bio *rbio)
  * of the drive.
  */
 int raid56_parity_recover(struct btrfs_fs_info *fs_info, struct bio *bio,
-			  struct btrfs_bio *bbio, u64 stripe_len,
+			  struct btrfs_io_context *bioc, u64 stripe_len,
 			  int mirror_num, int generic_io)
 {
 	struct btrfs_raid_bio *rbio;
 	int ret;
 
 	if (generic_io) {
-		ASSERT(bbio->mirror_num == mirror_num);
+		ASSERT(bioc->mirror_num == mirror_num);
 		btrfs_io_bio(bio)->mirror_num = mirror_num;
 	}
 
-	rbio = alloc_rbio(fs_info, bbio, stripe_len);
+	rbio = alloc_rbio(fs_info, bioc, stripe_len);
 	if (IS_ERR(rbio)) {
 		if (generic_io)
-			btrfs_put_bbio(bbio);
+			btrfs_put_bioc(bioc);
 		return PTR_ERR(rbio);
 	}
 
@@ -2142,11 +2141,11 @@ int raid56_parity_recover(struct btrfs_fs_info *fs_info, struct bio *bio,
 	rbio->faila = find_logical_bio_stripe(rbio, bio);
 	if (rbio->faila == -1) {
 		btrfs_warn(fs_info,
-	"%s could not find the bad stripe in raid56 so that we cannot recover any more (bio has logical %llu len %llu, bbio has map_type %llu)",
+"%s could not find the bad stripe in raid56 so that we cannot recover any more (bio has logical %llu len %llu, bioc has map_type %llu)",
 			   __func__, bio->bi_iter.bi_sector << 9,
-			   (u64)bio->bi_iter.bi_size, bbio->map_type);
+			   (u64)bio->bi_iter.bi_size, bioc->map_type);
 		if (generic_io)
-			btrfs_put_bbio(bbio);
+			btrfs_put_bioc(bioc);
 		kfree(rbio);
 		return -EIO;
 	}
@@ -2155,7 +2154,7 @@ int raid56_parity_recover(struct btrfs_fs_info *fs_info, struct bio *bio,
 		btrfs_bio_counter_inc_noblocked(fs_info);
 		rbio->generic_bio_cnt = 1;
 	} else {
-		btrfs_get_bbio(bbio);
+		btrfs_get_bioc(bioc);
 	}
 
 	/*
@@ -2214,7 +2213,7 @@ static void read_rebuild_work(struct btrfs_work *work)
 /*
  * The following code is used to scrub/replace the parity stripe
  *
- * Caller must have already increased bio_counter for getting @bbio.
+ * Caller must have already increased bio_counter for getting @bioc.
  *
  * Note: We need make sure all the pages that add into the scrub/replace
  * raid bio are correct and not be changed during the scrub/replace. That
@@ -2223,14 +2222,14 @@ static void read_rebuild_work(struct btrfs_work *work)
 
 struct btrfs_raid_bio *
 raid56_parity_alloc_scrub_rbio(struct btrfs_fs_info *fs_info, struct bio *bio,
-			       struct btrfs_bio *bbio, u64 stripe_len,
+			       struct btrfs_io_context *bioc, u64 stripe_len,
 			       struct btrfs_device *scrub_dev,
 			       unsigned long *dbitmap, int stripe_nsectors)
 {
 	struct btrfs_raid_bio *rbio;
 	int i;
 
-	rbio = alloc_rbio(fs_info, bbio, stripe_len);
+	rbio = alloc_rbio(fs_info, bioc, stripe_len);
 	if (IS_ERR(rbio))
 		return NULL;
 	bio_list_add(&rbio->bio_list, bio);
@@ -2242,12 +2241,12 @@ raid56_parity_alloc_scrub_rbio(struct btrfs_fs_info *fs_info, struct bio *bio,
 	rbio->operation = BTRFS_RBIO_PARITY_SCRUB;
 
 	/*
-	 * After mapping bbio with BTRFS_MAP_WRITE, parities have been sorted
+	 * After mapping bioc with BTRFS_MAP_WRITE, parities have been sorted
 	 * to the end position, so this search can start from the first parity
 	 * stripe.
 	 */
 	for (i = rbio->nr_data; i < rbio->real_stripes; i++) {
-		if (bbio->stripes[i].dev == scrub_dev) {
+		if (bioc->stripes[i].dev == scrub_dev) {
 			rbio->scrubp = i;
 			break;
 		}
@@ -2260,7 +2259,7 @@ raid56_parity_alloc_scrub_rbio(struct btrfs_fs_info *fs_info, struct bio *bio,
 	bitmap_copy(rbio->dbitmap, dbitmap, stripe_nsectors);
 
 	/*
-	 * We have already increased bio_counter when getting bbio, record it
+	 * We have already increased bio_counter when getting bioc, record it
 	 * so we can free it at rbio_orig_end_io().
 	 */
 	rbio->generic_bio_cnt = 1;
@@ -2275,10 +2274,10 @@ void raid56_add_scrub_pages(struct btrfs_raid_bio *rbio, struct page *page,
 	int stripe_offset;
 	int index;
 
-	ASSERT(logical >= rbio->bbio->raid_map[0]);
-	ASSERT(logical + PAGE_SIZE <= rbio->bbio->raid_map[0] +
+	ASSERT(logical >= rbio->bioc->raid_map[0]);
+	ASSERT(logical + PAGE_SIZE <= rbio->bioc->raid_map[0] +
 				rbio->stripe_len * rbio->nr_data);
-	stripe_offset = (int)(logical - rbio->bbio->raid_map[0]);
+	stripe_offset = (int)(logical - rbio->bioc->raid_map[0]);
 	index = stripe_offset >> PAGE_SHIFT;
 	rbio->bio_pages[index] = page;
 }
@@ -2312,7 +2311,7 @@ static int alloc_rbio_essential_pages(struct btrfs_raid_bio *rbio)
 static noinline void finish_parity_scrub(struct btrfs_raid_bio *rbio,
 					 int need_check)
 {
-	struct btrfs_bio *bbio = rbio->bbio;
+	struct btrfs_io_context *bioc = rbio->bioc;
 	void **pointers = rbio->finish_pointers;
 	unsigned long *pbitmap = rbio->finish_pbitmap;
 	int nr_data = rbio->nr_data;
@@ -2335,7 +2334,7 @@ static noinline void finish_parity_scrub(struct btrfs_raid_bio *rbio,
 	else
 		BUG();
 
-	if (bbio->num_tgtdevs && bbio->tgtdev_map[rbio->scrubp]) {
+	if (bioc->num_tgtdevs && bioc->tgtdev_map[rbio->scrubp]) {
 		is_replace = 1;
 		bitmap_copy(pbitmap, rbio->dbitmap, rbio->stripe_npages);
 	}
@@ -2435,7 +2434,7 @@ static noinline void finish_parity_scrub(struct btrfs_raid_bio *rbio,
 
 		page = rbio_stripe_page(rbio, rbio->scrubp, pagenr);
 		ret = rbio_add_io_page(rbio, &bio_list, page,
-				       bbio->tgtdev_map[rbio->scrubp],
+				       bioc->tgtdev_map[rbio->scrubp],
 				       pagenr, rbio->stripe_len);
 		if (ret)
 			goto cleanup;
@@ -2483,7 +2482,7 @@ static inline int is_data_stripe(struct btrfs_raid_bio *rbio, int stripe)
  */
 static void validate_rbio_for_parity_scrub(struct btrfs_raid_bio *rbio)
 {
-	if (atomic_read(&rbio->error) > rbio->bbio->max_errors)
+	if (atomic_read(&rbio->error) > rbio->bioc->max_errors)
 		goto cleanup;
 
 	if (rbio->faila >= 0 || rbio->failb >= 0) {
@@ -2504,7 +2503,7 @@ static void validate_rbio_for_parity_scrub(struct btrfs_raid_bio *rbio)
 		 * the data, so the capability of the repair is declined.
 		 * (In the case of RAID5, we can not repair anything)
 		 */
-		if (dfail > rbio->bbio->max_errors - 1)
+		if (dfail > rbio->bioc->max_errors - 1)
 			goto cleanup;
 
 		/*
@@ -2625,8 +2624,8 @@ static void raid56_parity_scrub_stripe(struct btrfs_raid_bio *rbio)
 	}
 
 	/*
-	 * the bbio may be freed once we submit the last bio.  Make sure
-	 * not to touch it after that
+	 * The bioc may be freed once we submit the last bio. Make sure not to
+	 * touch it after that.
 	 */
 	atomic_set(&rbio->stripes_pending, bios_to_read);
 	while ((bio = bio_list_pop(&bio_list))) {
@@ -2671,11 +2670,11 @@ void raid56_parity_submit_scrub_rbio(struct btrfs_raid_bio *rbio)
 
 struct btrfs_raid_bio *
 raid56_alloc_missing_rbio(struct btrfs_fs_info *fs_info, struct bio *bio,
-			  struct btrfs_bio *bbio, u64 length)
+			  struct btrfs_io_context *bioc, u64 length)
 {
 	struct btrfs_raid_bio *rbio;
 
-	rbio = alloc_rbio(fs_info, bbio, length);
+	rbio = alloc_rbio(fs_info, bioc, length);
 	if (IS_ERR(rbio))
 		return NULL;
 
@@ -2695,7 +2694,7 @@ raid56_alloc_missing_rbio(struct btrfs_fs_info *fs_info, struct bio *bio,
 	}
 
 	/*
-	 * When we get bbio, we have already increased bio_counter, record it
+	 * When we get bioc, we have already increased bio_counter, record it
 	 * so we can free it at rbio_orig_end_io()
 	 */
 	rbio->generic_bio_cnt = 1;
diff --git a/fs/btrfs/raid56.h b/fs/btrfs/raid56.h
index 2503485db859..838d3a5e07ef 100644
--- a/fs/btrfs/raid56.h
+++ b/fs/btrfs/raid56.h
@@ -31,24 +31,24 @@ struct btrfs_raid_bio;
 struct btrfs_device;
 
 int raid56_parity_recover(struct btrfs_fs_info *fs_info, struct bio *bio,
-			  struct btrfs_bio *bbio, u64 stripe_len,
+			  struct btrfs_io_context *bioc, u64 stripe_len,
 			  int mirror_num, int generic_io);
 int raid56_parity_write(struct btrfs_fs_info *fs_info, struct bio *bio,
-			       struct btrfs_bio *bbio, u64 stripe_len);
+			struct btrfs_io_context *bioc, u64 stripe_len);
 
 void raid56_add_scrub_pages(struct btrfs_raid_bio *rbio, struct page *page,
 			    u64 logical);
 
 struct btrfs_raid_bio *
 raid56_parity_alloc_scrub_rbio(struct btrfs_fs_info *fs_info, struct bio *bio,
-			       struct btrfs_bio *bbio, u64 stripe_len,
+			       struct btrfs_io_context *bioc, u64 stripe_len,
 			       struct btrfs_device *scrub_dev,
 			       unsigned long *dbitmap, int stripe_nsectors);
 void raid56_parity_submit_scrub_rbio(struct btrfs_raid_bio *rbio);
 
 struct btrfs_raid_bio *
 raid56_alloc_missing_rbio(struct btrfs_fs_info *fs_info, struct bio *bio,
-			  struct btrfs_bio *bbio, u64 length);
+			  struct btrfs_io_context *bioc, u64 length);
 void raid56_submit_missing_rbio(struct btrfs_raid_bio *rbio);
 
 int btrfs_alloc_stripe_hash_table(struct btrfs_fs_info *info);
diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
index 06713a8fe26b..eb96fdc3be25 100644
--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -227,7 +227,7 @@ int btree_readahead_hook(struct extent_buffer *eb, int err)
 }
 
 static struct reada_zone *reada_find_zone(struct btrfs_device *dev, u64 logical,
-					  struct btrfs_bio *bbio)
+					  struct btrfs_io_context *bioc)
 {
 	struct btrfs_fs_info *fs_info = dev->fs_info;
 	int ret;
@@ -275,11 +275,11 @@ static struct reada_zone *reada_find_zone(struct btrfs_device *dev, u64 logical,
 	kref_init(&zone->refcnt);
 	zone->elems = 0;
 	zone->device = dev; /* our device always sits at index 0 */
-	for (i = 0; i < bbio->num_stripes; ++i) {
+	for (i = 0; i < bioc->num_stripes; ++i) {
 		/* bounds have already been checked */
-		zone->devs[i] = bbio->stripes[i].dev;
+		zone->devs[i] = bioc->stripes[i].dev;
 	}
-	zone->ndevs = bbio->num_stripes;
+	zone->ndevs = bioc->num_stripes;
 
 	spin_lock(&fs_info->reada_lock);
 	ret = radix_tree_insert(&dev->reada_zones,
@@ -309,7 +309,7 @@ static struct reada_extent *reada_find_extent(struct btrfs_fs_info *fs_info,
 	int ret;
 	struct reada_extent *re = NULL;
 	struct reada_extent *re_exist = NULL;
-	struct btrfs_bio *bbio = NULL;
+	struct btrfs_io_context *bioc = NULL;
 	struct btrfs_device *dev;
 	struct btrfs_device *prev_dev;
 	u64 length;
@@ -345,28 +345,28 @@ static struct reada_extent *reada_find_extent(struct btrfs_fs_info *fs_info,
 	 */
 	length = fs_info->nodesize;
 	ret = btrfs_map_block(fs_info, BTRFS_MAP_GET_READ_MIRRORS, logical,
-			&length, &bbio, 0);
-	if (ret || !bbio || length < fs_info->nodesize)
+			      &length, &bioc, 0);
+	if (ret || !bioc || length < fs_info->nodesize)
 		goto error;
 
-	if (bbio->num_stripes > BTRFS_MAX_MIRRORS) {
+	if (bioc->num_stripes > BTRFS_MAX_MIRRORS) {
 		btrfs_err(fs_info,
 			   "readahead: more than %d copies not supported",
 			   BTRFS_MAX_MIRRORS);
 		goto error;
 	}
 
-	real_stripes = bbio->num_stripes - bbio->num_tgtdevs;
+	real_stripes = bioc->num_stripes - bioc->num_tgtdevs;
 	for (nzones = 0; nzones < real_stripes; ++nzones) {
 		struct reada_zone *zone;
 
-		dev = bbio->stripes[nzones].dev;
+		dev = bioc->stripes[nzones].dev;
 
 		/* cannot read ahead on missing device. */
 		if (!dev->bdev)
 			continue;
 
-		zone = reada_find_zone(dev, logical, bbio);
+		zone = reada_find_zone(dev, logical, bioc);
 		if (!zone)
 			continue;
 
@@ -464,7 +464,7 @@ static struct reada_extent *reada_find_extent(struct btrfs_fs_info *fs_info,
 	if (!have_zone)
 		goto error;
 
-	btrfs_put_bbio(bbio);
+	btrfs_put_bioc(bioc);
 	return re;
 
 error:
@@ -488,7 +488,7 @@ static struct reada_extent *reada_find_extent(struct btrfs_fs_info *fs_info,
 		kref_put(&zone->refcnt, reada_zone_release);
 		spin_unlock(&fs_info->reada_lock);
 	}
-	btrfs_put_bbio(bbio);
+	btrfs_put_bioc(bioc);
 	kfree(re);
 	return re_exist;
 }
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 6f2787b21530..0785d9d645fc 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -57,7 +57,7 @@ struct scrub_ctx;
 
 struct scrub_recover {
 	refcount_t		refs;
-	struct btrfs_bio	*bbio;
+	struct btrfs_io_context	*bioc;
 	u64			map_length;
 };
 
@@ -254,7 +254,7 @@ static void scrub_put_ctx(struct scrub_ctx *sctx);
 static inline int scrub_is_page_on_raid56(struct scrub_page *spage)
 {
 	return spage->recover &&
-	       (spage->recover->bbio->map_type & BTRFS_BLOCK_GROUP_RAID56_MASK);
+	       (spage->recover->bioc->map_type & BTRFS_BLOCK_GROUP_RAID56_MASK);
 }
 
 static void scrub_pending_bio_inc(struct scrub_ctx *sctx)
@@ -798,7 +798,7 @@ static inline void scrub_put_recover(struct btrfs_fs_info *fs_info,
 {
 	if (refcount_dec_and_test(&recover->refs)) {
 		btrfs_bio_counter_dec(fs_info);
-		btrfs_put_bbio(recover->bbio);
+		btrfs_put_bioc(recover->bioc);
 		kfree(recover);
 	}
 }
@@ -1027,8 +1027,7 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 			sblock_other = sblocks_for_recheck + mirror_index;
 		} else {
 			struct scrub_recover *r = sblock_bad->pagev[0]->recover;
-			int max_allowed = r->bbio->num_stripes -
-						r->bbio->num_tgtdevs;
+			int max_allowed = r->bioc->num_stripes - r->bioc->num_tgtdevs;
 
 			if (mirror_index >= max_allowed)
 				break;
@@ -1218,14 +1217,14 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 	return 0;
 }
 
-static inline int scrub_nr_raid_mirrors(struct btrfs_bio *bbio)
+static inline int scrub_nr_raid_mirrors(struct btrfs_io_context *bioc)
 {
-	if (bbio->map_type & BTRFS_BLOCK_GROUP_RAID5)
+	if (bioc->map_type & BTRFS_BLOCK_GROUP_RAID5)
 		return 2;
-	else if (bbio->map_type & BTRFS_BLOCK_GROUP_RAID6)
+	else if (bioc->map_type & BTRFS_BLOCK_GROUP_RAID6)
 		return 3;
 	else
-		return (int)bbio->num_stripes;
+		return (int)bioc->num_stripes;
 }
 
 static inline void scrub_stripe_index_and_offset(u64 logical, u64 map_type,
@@ -1269,7 +1268,7 @@ static int scrub_setup_recheck_block(struct scrub_block *original_sblock,
 	u64 flags = original_sblock->pagev[0]->flags;
 	u64 have_csum = original_sblock->pagev[0]->have_csum;
 	struct scrub_recover *recover;
-	struct btrfs_bio *bbio;
+	struct btrfs_io_context *bioc;
 	u64 sublen;
 	u64 mapped_length;
 	u64 stripe_offset;
@@ -1288,7 +1287,7 @@ static int scrub_setup_recheck_block(struct scrub_block *original_sblock,
 	while (length > 0) {
 		sublen = min_t(u64, length, fs_info->sectorsize);
 		mapped_length = sublen;
-		bbio = NULL;
+		bioc = NULL;
 
 		/*
 		 * With a length of sectorsize, each returned stripe represents
@@ -1296,27 +1295,27 @@ static int scrub_setup_recheck_block(struct scrub_block *original_sblock,
 		 */
 		btrfs_bio_counter_inc_blocked(fs_info);
 		ret = btrfs_map_sblock(fs_info, BTRFS_MAP_GET_READ_MIRRORS,
-				logical, &mapped_length, &bbio);
-		if (ret || !bbio || mapped_length < sublen) {
-			btrfs_put_bbio(bbio);
+				       logical, &mapped_length, &bioc);
+		if (ret || !bioc || mapped_length < sublen) {
+			btrfs_put_bioc(bioc);
 			btrfs_bio_counter_dec(fs_info);
 			return -EIO;
 		}
 
 		recover = kzalloc(sizeof(struct scrub_recover), GFP_NOFS);
 		if (!recover) {
-			btrfs_put_bbio(bbio);
+			btrfs_put_bioc(bioc);
 			btrfs_bio_counter_dec(fs_info);
 			return -ENOMEM;
 		}
 
 		refcount_set(&recover->refs, 1);
-		recover->bbio = bbio;
+		recover->bioc = bioc;
 		recover->map_length = mapped_length;
 
 		BUG_ON(page_index >= SCRUB_MAX_PAGES_PER_BLOCK);
 
-		nmirrors = min(scrub_nr_raid_mirrors(bbio), BTRFS_MAX_MIRRORS);
+		nmirrors = min(scrub_nr_raid_mirrors(bioc), BTRFS_MAX_MIRRORS);
 
 		for (mirror_index = 0; mirror_index < nmirrors;
 		     mirror_index++) {
@@ -1348,17 +1347,17 @@ static int scrub_setup_recheck_block(struct scrub_block *original_sblock,
 				       sctx->fs_info->csum_size);
 
 			scrub_stripe_index_and_offset(logical,
-						      bbio->map_type,
-						      bbio->raid_map,
+						      bioc->map_type,
+						      bioc->raid_map,
 						      mapped_length,
-						      bbio->num_stripes -
-						      bbio->num_tgtdevs,
+						      bioc->num_stripes -
+						      bioc->num_tgtdevs,
 						      mirror_index,
 						      &stripe_index,
 						      &stripe_offset);
-			spage->physical = bbio->stripes[stripe_index].physical +
+			spage->physical = bioc->stripes[stripe_index].physical +
 					 stripe_offset;
-			spage->dev = bbio->stripes[stripe_index].dev;
+			spage->dev = bioc->stripes[stripe_index].dev;
 
 			BUG_ON(page_index >= original_sblock->page_count);
 			spage->physical_for_dev_replace =
@@ -1401,7 +1400,7 @@ static int scrub_submit_raid56_bio_wait(struct btrfs_fs_info *fs_info,
 	bio->bi_end_io = scrub_bio_wait_endio;
 
 	mirror_num = spage->sblock->pagev[0]->mirror_num;
-	ret = raid56_parity_recover(fs_info, bio, spage->recover->bbio,
+	ret = raid56_parity_recover(fs_info, bio, spage->recover->bioc,
 				    spage->recover->map_length,
 				    mirror_num, 0);
 	if (ret)
@@ -2203,7 +2202,7 @@ static void scrub_missing_raid56_pages(struct scrub_block *sblock)
 	struct btrfs_fs_info *fs_info = sctx->fs_info;
 	u64 length = sblock->page_count * PAGE_SIZE;
 	u64 logical = sblock->pagev[0]->logical;
-	struct btrfs_bio *bbio = NULL;
+	struct btrfs_io_context *bioc = NULL;
 	struct bio *bio;
 	struct btrfs_raid_bio *rbio;
 	int ret;
@@ -2211,19 +2210,19 @@ static void scrub_missing_raid56_pages(struct scrub_block *sblock)
 
 	btrfs_bio_counter_inc_blocked(fs_info);
 	ret = btrfs_map_sblock(fs_info, BTRFS_MAP_GET_READ_MIRRORS, logical,
-			&length, &bbio);
-	if (ret || !bbio || !bbio->raid_map)
-		goto bbio_out;
+			       &length, &bioc);
+	if (ret || !bioc || !bioc->raid_map)
+		goto bioc_out;
 
 	if (WARN_ON(!sctx->is_dev_replace ||
-		    !(bbio->map_type & BTRFS_BLOCK_GROUP_RAID56_MASK))) {
+		    !(bioc->map_type & BTRFS_BLOCK_GROUP_RAID56_MASK))) {
 		/*
 		 * We shouldn't be scrubbing a missing device. Even for dev
 		 * replace, we should only get here for RAID 5/6. We either
 		 * managed to mount something with no mirrors remaining or
 		 * there's a bug in scrub_remap_extent()/btrfs_map_block().
 		 */
-		goto bbio_out;
+		goto bioc_out;
 	}
 
 	bio = btrfs_io_bio_alloc(0);
@@ -2231,7 +2230,7 @@ static void scrub_missing_raid56_pages(struct scrub_block *sblock)
 	bio->bi_private = sblock;
 	bio->bi_end_io = scrub_missing_raid56_end_io;
 
-	rbio = raid56_alloc_missing_rbio(fs_info, bio, bbio, length);
+	rbio = raid56_alloc_missing_rbio(fs_info, bio, bioc, length);
 	if (!rbio)
 		goto rbio_out;
 
@@ -2249,9 +2248,9 @@ static void scrub_missing_raid56_pages(struct scrub_block *sblock)
 
 rbio_out:
 	bio_put(bio);
-bbio_out:
+bioc_out:
 	btrfs_bio_counter_dec(fs_info);
-	btrfs_put_bbio(bbio);
+	btrfs_put_bioc(bioc);
 	spin_lock(&sctx->stat_lock);
 	sctx->stat.malloc_errors++;
 	spin_unlock(&sctx->stat_lock);
@@ -2826,7 +2825,7 @@ static void scrub_parity_check_and_repair(struct scrub_parity *sparity)
 	struct btrfs_fs_info *fs_info = sctx->fs_info;
 	struct bio *bio;
 	struct btrfs_raid_bio *rbio;
-	struct btrfs_bio *bbio = NULL;
+	struct btrfs_io_context *bioc = NULL;
 	u64 length;
 	int ret;
 
@@ -2838,16 +2837,16 @@ static void scrub_parity_check_and_repair(struct scrub_parity *sparity)
 
 	btrfs_bio_counter_inc_blocked(fs_info);
 	ret = btrfs_map_sblock(fs_info, BTRFS_MAP_WRITE, sparity->logic_start,
-			       &length, &bbio);
-	if (ret || !bbio || !bbio->raid_map)
-		goto bbio_out;
+			       &length, &bioc);
+	if (ret || !bioc || !bioc->raid_map)
+		goto bioc_out;
 
 	bio = btrfs_io_bio_alloc(0);
 	bio->bi_iter.bi_sector = sparity->logic_start >> 9;
 	bio->bi_private = sparity;
 	bio->bi_end_io = scrub_parity_bio_endio;
 
-	rbio = raid56_parity_alloc_scrub_rbio(fs_info, bio, bbio,
+	rbio = raid56_parity_alloc_scrub_rbio(fs_info, bio, bioc,
 					      length, sparity->scrub_dev,
 					      sparity->dbitmap,
 					      sparity->nsectors);
@@ -2860,9 +2859,9 @@ static void scrub_parity_check_and_repair(struct scrub_parity *sparity)
 
 rbio_out:
 	bio_put(bio);
-bbio_out:
+bioc_out:
 	btrfs_bio_counter_dec(fs_info);
-	btrfs_put_bbio(bbio);
+	btrfs_put_bioc(bioc);
 	bitmap_or(sparity->ebitmap, sparity->ebitmap, sparity->dbitmap,
 		  sparity->nsectors);
 	spin_lock(&sctx->stat_lock);
@@ -2901,7 +2900,7 @@ static noinline_for_stack int scrub_raid56_parity(struct scrub_ctx *sctx,
 	struct btrfs_root *root = fs_info->extent_root;
 	struct btrfs_root *csum_root = fs_info->csum_root;
 	struct btrfs_extent_item *extent;
-	struct btrfs_bio *bbio = NULL;
+	struct btrfs_io_context *bioc = NULL;
 	u64 flags;
 	int ret;
 	int slot;
@@ -3044,22 +3043,22 @@ static noinline_for_stack int scrub_raid56_parity(struct scrub_ctx *sctx,
 						       extent_len);
 
 			mapped_length = extent_len;
-			bbio = NULL;
+			bioc = NULL;
 			ret = btrfs_map_block(fs_info, BTRFS_MAP_READ,
-					extent_logical, &mapped_length, &bbio,
+					extent_logical, &mapped_length, &bioc,
 					0);
 			if (!ret) {
-				if (!bbio || mapped_length < extent_len)
+				if (!bioc || mapped_length < extent_len)
 					ret = -EIO;
 			}
 			if (ret) {
-				btrfs_put_bbio(bbio);
+				btrfs_put_bioc(bioc);
 				goto out;
 			}
-			extent_physical = bbio->stripes[0].physical;
-			extent_mirror_num = bbio->mirror_num;
-			extent_dev = bbio->stripes[0].dev;
-			btrfs_put_bbio(bbio);
+			extent_physical = bioc->stripes[0].physical;
+			extent_mirror_num = bioc->mirror_num;
+			extent_dev = bioc->stripes[0].dev;
+			btrfs_put_bioc(bioc);
 
 			ret = btrfs_lookup_csums_range(csum_root,
 						extent_logical,
@@ -4311,20 +4310,20 @@ static void scrub_remap_extent(struct btrfs_fs_info *fs_info,
 			       int *extent_mirror_num)
 {
 	u64 mapped_length;
-	struct btrfs_bio *bbio = NULL;
+	struct btrfs_io_context *bioc = NULL;
 	int ret;
 
 	mapped_length = extent_len;
 	ret = btrfs_map_block(fs_info, BTRFS_MAP_READ, extent_logical,
-			      &mapped_length, &bbio, 0);
-	if (ret || !bbio || mapped_length < extent_len ||
-	    !bbio->stripes[0].dev->bdev) {
-		btrfs_put_bbio(bbio);
+			      &mapped_length, &bioc, 0);
+	if (ret || !bioc || mapped_length < extent_len ||
+	    !bioc->stripes[0].dev->bdev) {
+		btrfs_put_bioc(bioc);
 		return;
 	}
 
-	*extent_physical = bbio->stripes[0].physical;
-	*extent_mirror_num = bbio->mirror_num;
-	*extent_dev = bbio->stripes[0].dev;
-	btrfs_put_bbio(bbio);
+	*extent_physical = bioc->stripes[0].physical;
+	*extent_mirror_num = bioc->mirror_num;
+	*extent_dev = bioc->stripes[0].dev;
+	btrfs_put_bioc(bioc);
 }
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 89ce0b449c22..2a93d80be9bf 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -251,7 +251,7 @@ static void btrfs_dev_stat_print_on_load(struct btrfs_device *device);
 static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 			     enum btrfs_map_op op,
 			     u64 logical, u64 *length,
-			     struct btrfs_bio **bbio_ret,
+			     struct btrfs_io_context **bioc_ret,
 			     int mirror_num, int need_raid_map);
 
 /*
@@ -5868,7 +5868,7 @@ static int find_live_mirror(struct btrfs_fs_info *fs_info,
 }
 
 /* Bubble-sort the stripe set to put the parity/syndrome stripes last */
-static void sort_parity_stripes(struct btrfs_bio *bbio, int num_stripes)
+static void sort_parity_stripes(struct btrfs_io_context *bioc, int num_stripes)
 {
 	int i;
 	int again = 1;
@@ -5877,52 +5877,53 @@ static void sort_parity_stripes(struct btrfs_bio *bbio, int num_stripes)
 		again = 0;
 		for (i = 0; i < num_stripes - 1; i++) {
 			/* Swap if parity is on a smaller index */
-			if (bbio->raid_map[i] > bbio->raid_map[i + 1]) {
-				swap(bbio->stripes[i], bbio->stripes[i + 1]);
-				swap(bbio->raid_map[i], bbio->raid_map[i + 1]);
+			if (bioc->raid_map[i] > bioc->raid_map[i + 1]) {
+				swap(bioc->stripes[i], bioc->stripes[i + 1]);
+				swap(bioc->raid_map[i], bioc->raid_map[i + 1]);
 				again = 1;
 			}
 		}
 	}
 }
 
-static struct btrfs_bio *alloc_btrfs_bio(int total_stripes, int real_stripes)
+static struct btrfs_io_context *alloc_btrfs_io_context(int total_stripes,
+						       int real_stripes)
 {
-	struct btrfs_bio *bbio = kzalloc(
-		 /* the size of the btrfs_bio */
-		sizeof(struct btrfs_bio) +
-		/* plus the variable array for the stripes */
-		sizeof(struct btrfs_bio_stripe) * (total_stripes) +
-		/* plus the variable array for the tgt dev */
+	struct btrfs_io_context *bioc = kzalloc(
+		 /* The size of btrfs_io_context */
+		sizeof(struct btrfs_io_context) +
+		/* Plus the variable array for the stripes */
+		sizeof(struct btrfs_io_stripe) * (total_stripes) +
+		/* Plus the variable array for the tgt dev */
 		sizeof(int) * (real_stripes) +
 		/*
-		 * plus the raid_map, which includes both the tgt dev
-		 * and the stripes
+		 * Plus the raid_map, which includes both the tgt dev
+		 * and the stripes.
 		 */
 		sizeof(u64) * (total_stripes),
 		GFP_NOFS|__GFP_NOFAIL);
 
-	atomic_set(&bbio->error, 0);
-	refcount_set(&bbio->refs, 1);
+	atomic_set(&bioc->error, 0);
+	refcount_set(&bioc->refs, 1);
 
-	bbio->tgtdev_map = (int *)(bbio->stripes + total_stripes);
-	bbio->raid_map = (u64 *)(bbio->tgtdev_map + real_stripes);
+	bioc->tgtdev_map = (int *)(bioc->stripes + total_stripes);
+	bioc->raid_map = (u64 *)(bioc->tgtdev_map + real_stripes);
 
-	return bbio;
+	return bioc;
 }
 
-void btrfs_get_bbio(struct btrfs_bio *bbio)
+void btrfs_get_bioc(struct btrfs_io_context *bioc)
 {
-	WARN_ON(!refcount_read(&bbio->refs));
-	refcount_inc(&bbio->refs);
+	WARN_ON(!refcount_read(&bioc->refs));
+	refcount_inc(&bioc->refs);
 }
 
-void btrfs_put_bbio(struct btrfs_bio *bbio)
+void btrfs_put_bioc(struct btrfs_io_context *bioc)
 {
-	if (!bbio)
+	if (!bioc)
 		return;
-	if (refcount_dec_and_test(&bbio->refs))
-		kfree(bbio);
+	if (refcount_dec_and_test(&bioc->refs))
+		kfree(bioc);
 }
 
 /* can REQ_OP_DISCARD be sent with other REQ like REQ_OP_WRITE? */
@@ -5932,11 +5933,11 @@ void btrfs_put_bbio(struct btrfs_bio *bbio)
  */
 static int __btrfs_map_block_for_discard(struct btrfs_fs_info *fs_info,
 					 u64 logical, u64 *length_ret,
-					 struct btrfs_bio **bbio_ret)
+					 struct btrfs_io_context **bioc_ret)
 {
 	struct extent_map *em;
 	struct map_lookup *map;
-	struct btrfs_bio *bbio;
+	struct btrfs_io_context *bioc;
 	u64 length = *length_ret;
 	u64 offset;
 	u64 stripe_nr;
@@ -5955,8 +5956,8 @@ static int __btrfs_map_block_for_discard(struct btrfs_fs_info *fs_info,
 	int ret = 0;
 	int i;
 
-	/* discard always return a bbio */
-	ASSERT(bbio_ret);
+	/* Discard always returns a bioc. */
+	ASSERT(bioc_ret);
 
 	em = btrfs_get_chunk_map(fs_info, logical, length);
 	if (IS_ERR(em))
@@ -6019,26 +6020,25 @@ static int __btrfs_map_block_for_discard(struct btrfs_fs_info *fs_info,
 					&stripe_index);
 	}
 
-	bbio = alloc_btrfs_bio(num_stripes, 0);
-	if (!bbio) {
+	bioc = alloc_btrfs_io_context(num_stripes, 0);
+	if (!bioc) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
 	for (i = 0; i < num_stripes; i++) {
-		bbio->stripes[i].physical =
+		bioc->stripes[i].physical =
 			map->stripes[stripe_index].physical +
 			stripe_offset + stripe_nr * map->stripe_len;
-		bbio->stripes[i].dev = map->stripes[stripe_index].dev;
+		bioc->stripes[i].dev = map->stripes[stripe_index].dev;
 
 		if (map->type & (BTRFS_BLOCK_GROUP_RAID0 |
 				 BTRFS_BLOCK_GROUP_RAID10)) {
-			bbio->stripes[i].length = stripes_per_dev *
+			bioc->stripes[i].length = stripes_per_dev *
 				map->stripe_len;
 
 			if (i / sub_stripes < remaining_stripes)
-				bbio->stripes[i].length +=
-					map->stripe_len;
+				bioc->stripes[i].length += map->stripe_len;
 
 			/*
 			 * Special for the first stripe and
@@ -6049,19 +6049,17 @@ static int __btrfs_map_block_for_discard(struct btrfs_fs_info *fs_info,
 			 *    off     end_off
 			 */
 			if (i < sub_stripes)
-				bbio->stripes[i].length -=
-					stripe_offset;
+				bioc->stripes[i].length -= stripe_offset;
 
 			if (stripe_index >= last_stripe &&
 			    stripe_index <= (last_stripe +
 					     sub_stripes - 1))
-				bbio->stripes[i].length -=
-					stripe_end_offset;
+				bioc->stripes[i].length -= stripe_end_offset;
 
 			if (i == sub_stripes - 1)
 				stripe_offset = 0;
 		} else {
-			bbio->stripes[i].length = length;
+			bioc->stripes[i].length = length;
 		}
 
 		stripe_index++;
@@ -6071,9 +6069,9 @@ static int __btrfs_map_block_for_discard(struct btrfs_fs_info *fs_info,
 		}
 	}
 
-	*bbio_ret = bbio;
-	bbio->map_type = map->type;
-	bbio->num_stripes = num_stripes;
+	*bioc_ret = bioc;
+	bioc->map_type = map->type;
+	bioc->num_stripes = num_stripes;
 out:
 	free_extent_map(em);
 	return ret;
@@ -6097,7 +6095,7 @@ static int get_extra_mirror_from_replace(struct btrfs_fs_info *fs_info,
 					 u64 srcdev_devid, int *mirror_num,
 					 u64 *physical)
 {
-	struct btrfs_bio *bbio = NULL;
+	struct btrfs_io_context *bioc = NULL;
 	int num_stripes;
 	int index_srcdev = 0;
 	int found = 0;
@@ -6106,20 +6104,20 @@ static int get_extra_mirror_from_replace(struct btrfs_fs_info *fs_info,
 	int ret = 0;
 
 	ret = __btrfs_map_block(fs_info, BTRFS_MAP_GET_READ_MIRRORS,
-				logical, &length, &bbio, 0, 0);
+				logical, &length, &bioc, 0, 0);
 	if (ret) {
-		ASSERT(bbio == NULL);
+		ASSERT(bioc == NULL);
 		return ret;
 	}
 
-	num_stripes = bbio->num_stripes;
+	num_stripes = bioc->num_stripes;
 	if (*mirror_num > num_stripes) {
 		/*
 		 * BTRFS_MAP_GET_READ_MIRRORS does not contain this mirror,
 		 * that means that the requested area is not left of the left
 		 * cursor
 		 */
-		btrfs_put_bbio(bbio);
+		btrfs_put_bioc(bioc);
 		return -EIO;
 	}
 
@@ -6129,7 +6127,7 @@ static int get_extra_mirror_from_replace(struct btrfs_fs_info *fs_info,
 	 * pointer to the one of the target drive.
 	 */
 	for (i = 0; i < num_stripes; i++) {
-		if (bbio->stripes[i].dev->devid != srcdev_devid)
+		if (bioc->stripes[i].dev->devid != srcdev_devid)
 			continue;
 
 		/*
@@ -6137,15 +6135,15 @@ static int get_extra_mirror_from_replace(struct btrfs_fs_info *fs_info,
 		 * mirror with the lowest physical address
 		 */
 		if (found &&
-		    physical_of_found <= bbio->stripes[i].physical)
+		    physical_of_found <= bioc->stripes[i].physical)
 			continue;
 
 		index_srcdev = i;
 		found = 1;
-		physical_of_found = bbio->stripes[i].physical;
+		physical_of_found = bioc->stripes[i].physical;
 	}
 
-	btrfs_put_bbio(bbio);
+	btrfs_put_bioc(bioc);
 
 	ASSERT(found);
 	if (!found)
@@ -6176,12 +6174,12 @@ static bool is_block_group_to_copy(struct btrfs_fs_info *fs_info, u64 logical)
 }
 
 static void handle_ops_on_dev_replace(enum btrfs_map_op op,
-				      struct btrfs_bio **bbio_ret,
+				      struct btrfs_io_context **bioc_ret,
 				      struct btrfs_dev_replace *dev_replace,
 				      u64 logical,
 				      int *num_stripes_ret, int *max_errors_ret)
 {
-	struct btrfs_bio *bbio = *bbio_ret;
+	struct btrfs_io_context *bioc = *bioc_ret;
 	u64 srcdev_devid = dev_replace->srcdev->devid;
 	int tgtdev_indexes = 0;
 	int num_stripes = *num_stripes_ret;
@@ -6211,17 +6209,17 @@ static void handle_ops_on_dev_replace(enum btrfs_map_op op,
 		 */
 		index_where_to_add = num_stripes;
 		for (i = 0; i < num_stripes; i++) {
-			if (bbio->stripes[i].dev->devid == srcdev_devid) {
+			if (bioc->stripes[i].dev->devid == srcdev_devid) {
 				/* write to new disk, too */
-				struct btrfs_bio_stripe *new =
-					bbio->stripes + index_where_to_add;
-				struct btrfs_bio_stripe *old =
-					bbio->stripes + i;
+				struct btrfs_io_stripe *new =
+					bioc->stripes + index_where_to_add;
+				struct btrfs_io_stripe *old =
+					bioc->stripes + i;
 
 				new->physical = old->physical;
 				new->length = old->length;
 				new->dev = dev_replace->tgtdev;
-				bbio->tgtdev_map[i] = index_where_to_add;
+				bioc->tgtdev_map[i] = index_where_to_add;
 				index_where_to_add++;
 				max_errors++;
 				tgtdev_indexes++;
@@ -6241,30 +6239,29 @@ static void handle_ops_on_dev_replace(enum btrfs_map_op op,
 		 * full copy of the source drive.
 		 */
 		for (i = 0; i < num_stripes; i++) {
-			if (bbio->stripes[i].dev->devid == srcdev_devid) {
+			if (bioc->stripes[i].dev->devid == srcdev_devid) {
 				/*
 				 * In case of DUP, in order to keep it simple,
 				 * only add the mirror with the lowest physical
 				 * address
 				 */
 				if (found &&
-				    physical_of_found <=
-				     bbio->stripes[i].physical)
+				    physical_of_found <= bioc->stripes[i].physical)
 					continue;
 				index_srcdev = i;
 				found = 1;
-				physical_of_found = bbio->stripes[i].physical;
+				physical_of_found = bioc->stripes[i].physical;
 			}
 		}
 		if (found) {
-			struct btrfs_bio_stripe *tgtdev_stripe =
-				bbio->stripes + num_stripes;
+			struct btrfs_io_stripe *tgtdev_stripe =
+				bioc->stripes + num_stripes;
 
 			tgtdev_stripe->physical = physical_of_found;
 			tgtdev_stripe->length =
-				bbio->stripes[index_srcdev].length;
+				bioc->stripes[index_srcdev].length;
 			tgtdev_stripe->dev = dev_replace->tgtdev;
-			bbio->tgtdev_map[index_srcdev] = num_stripes;
+			bioc->tgtdev_map[index_srcdev] = num_stripes;
 
 			tgtdev_indexes++;
 			num_stripes++;
@@ -6273,8 +6270,8 @@ static void handle_ops_on_dev_replace(enum btrfs_map_op op,
 
 	*num_stripes_ret = num_stripes;
 	*max_errors_ret = max_errors;
-	bbio->num_tgtdevs = tgtdev_indexes;
-	*bbio_ret = bbio;
+	bioc->num_tgtdevs = tgtdev_indexes;
+	*bioc_ret = bioc;
 }
 
 static bool need_full_stripe(enum btrfs_map_op op)
@@ -6377,7 +6374,7 @@ int btrfs_get_io_geometry(struct btrfs_fs_info *fs_info, struct extent_map *em,
 static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 			     enum btrfs_map_op op,
 			     u64 logical, u64 *length,
-			     struct btrfs_bio **bbio_ret,
+			     struct btrfs_io_context **bioc_ret,
 			     int mirror_num, int need_raid_map)
 {
 	struct extent_map *em;
@@ -6392,7 +6389,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 	int num_stripes;
 	int max_errors = 0;
 	int tgtdev_indexes = 0;
-	struct btrfs_bio *bbio = NULL;
+	struct btrfs_io_context *bioc = NULL;
 	struct btrfs_dev_replace *dev_replace = &fs_info->dev_replace;
 	int dev_replace_is_ongoing = 0;
 	int num_alloc_stripes;
@@ -6401,7 +6398,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 	u64 raid56_full_stripe_start = (u64)-1;
 	struct btrfs_io_geometry geom;
 
-	ASSERT(bbio_ret);
+	ASSERT(bioc_ret);
 	ASSERT(op != BTRFS_MAP_DISCARD);
 
 	em = btrfs_get_chunk_map(fs_info, logical, *length);
@@ -6545,20 +6542,20 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 		tgtdev_indexes = num_stripes;
 	}
 
-	bbio = alloc_btrfs_bio(num_alloc_stripes, tgtdev_indexes);
-	if (!bbio) {
+	bioc = alloc_btrfs_io_context(num_alloc_stripes, tgtdev_indexes);
+	if (!bioc) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
 	for (i = 0; i < num_stripes; i++) {
-		bbio->stripes[i].physical = map->stripes[stripe_index].physical +
+		bioc->stripes[i].physical = map->stripes[stripe_index].physical +
 			stripe_offset + stripe_nr * map->stripe_len;
-		bbio->stripes[i].dev = map->stripes[stripe_index].dev;
+		bioc->stripes[i].dev = map->stripes[stripe_index].dev;
 		stripe_index++;
 	}
 
-	/* build raid_map */
+	/* Build raid_map */
 	if (map->type & BTRFS_BLOCK_GROUP_RAID56_MASK && need_raid_map &&
 	    (need_full_stripe(op) || mirror_num > 1)) {
 		u64 tmp;
@@ -6570,15 +6567,15 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 		/* Fill in the logical address of each stripe */
 		tmp = stripe_nr * data_stripes;
 		for (i = 0; i < data_stripes; i++)
-			bbio->raid_map[(i+rot) % num_stripes] =
+			bioc->raid_map[(i + rot) % num_stripes] =
 				em->start + (tmp + i) * map->stripe_len;
 
-		bbio->raid_map[(i+rot) % map->num_stripes] = RAID5_P_STRIPE;
+		bioc->raid_map[(i + rot) % map->num_stripes] = RAID5_P_STRIPE;
 		if (map->type & BTRFS_BLOCK_GROUP_RAID6)
-			bbio->raid_map[(i+rot+1) % num_stripes] =
+			bioc->raid_map[(i + rot + 1) % num_stripes] =
 				RAID6_Q_STRIPE;
 
-		sort_parity_stripes(bbio, num_stripes);
+		sort_parity_stripes(bioc, num_stripes);
 	}
 
 	if (need_full_stripe(op))
@@ -6586,15 +6583,15 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 
 	if (dev_replace_is_ongoing && dev_replace->tgtdev != NULL &&
 	    need_full_stripe(op)) {
-		handle_ops_on_dev_replace(op, &bbio, dev_replace, logical,
+		handle_ops_on_dev_replace(op, &bioc, dev_replace, logical,
 					  &num_stripes, &max_errors);
 	}
 
-	*bbio_ret = bbio;
-	bbio->map_type = map->type;
-	bbio->num_stripes = num_stripes;
-	bbio->max_errors = max_errors;
-	bbio->mirror_num = mirror_num;
+	*bioc_ret = bioc;
+	bioc->map_type = map->type;
+	bioc->num_stripes = num_stripes;
+	bioc->max_errors = max_errors;
+	bioc->mirror_num = mirror_num;
 
 	/*
 	 * this is the case that REQ_READ && dev_replace_is_ongoing &&
@@ -6603,9 +6600,9 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 	 */
 	if (patch_the_first_stripe_for_dev_replace && num_stripes > 0) {
 		WARN_ON(num_stripes > 1);
-		bbio->stripes[0].dev = dev_replace->tgtdev;
-		bbio->stripes[0].physical = physical_to_patch_in_first_stripe;
-		bbio->mirror_num = map->num_stripes + 1;
+		bioc->stripes[0].dev = dev_replace->tgtdev;
+		bioc->stripes[0].physical = physical_to_patch_in_first_stripe;
+		bioc->mirror_num = map->num_stripes + 1;
 	}
 out:
 	if (dev_replace_is_ongoing) {
@@ -6619,40 +6616,40 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 
 int btrfs_map_block(struct btrfs_fs_info *fs_info, enum btrfs_map_op op,
 		      u64 logical, u64 *length,
-		      struct btrfs_bio **bbio_ret, int mirror_num)
+		      struct btrfs_io_context **bioc_ret, int mirror_num)
 {
 	if (op == BTRFS_MAP_DISCARD)
 		return __btrfs_map_block_for_discard(fs_info, logical,
-						     length, bbio_ret);
+						     length, bioc_ret);
 
-	return __btrfs_map_block(fs_info, op, logical, length, bbio_ret,
+	return __btrfs_map_block(fs_info, op, logical, length, bioc_ret,
 				 mirror_num, 0);
 }
 
 /* For Scrub/replace */
 int btrfs_map_sblock(struct btrfs_fs_info *fs_info, enum btrfs_map_op op,
 		     u64 logical, u64 *length,
-		     struct btrfs_bio **bbio_ret)
+		     struct btrfs_io_context **bioc_ret)
 {
-	return __btrfs_map_block(fs_info, op, logical, length, bbio_ret, 0, 1);
+	return __btrfs_map_block(fs_info, op, logical, length, bioc_ret, 0, 1);
 }
 
-static inline void btrfs_end_bbio(struct btrfs_bio *bbio, struct bio *bio)
+static inline void btrfs_end_bioc(struct btrfs_io_context *bioc, struct bio *bio)
 {
-	bio->bi_private = bbio->private;
-	bio->bi_end_io = bbio->end_io;
+	bio->bi_private = bioc->private;
+	bio->bi_end_io = bioc->end_io;
 	bio_endio(bio);
 
-	btrfs_put_bbio(bbio);
+	btrfs_put_bioc(bioc);
 }
 
 static void btrfs_end_bio(struct bio *bio)
 {
-	struct btrfs_bio *bbio = bio->bi_private;
+	struct btrfs_io_context *bioc = bio->bi_private;
 	int is_orig_bio = 0;
 
 	if (bio->bi_status) {
-		atomic_inc(&bbio->error);
+		atomic_inc(&bioc->error);
 		if (bio->bi_status == BLK_STS_IOERR ||
 		    bio->bi_status == BLK_STS_TARGET) {
 			struct btrfs_device *dev = btrfs_io_bio(bio)->device;
@@ -6670,22 +6667,22 @@ static void btrfs_end_bio(struct bio *bio)
 		}
 	}
 
-	if (bio == bbio->orig_bio)
+	if (bio == bioc->orig_bio)
 		is_orig_bio = 1;
 
-	btrfs_bio_counter_dec(bbio->fs_info);
+	btrfs_bio_counter_dec(bioc->fs_info);
 
-	if (atomic_dec_and_test(&bbio->stripes_pending)) {
+	if (atomic_dec_and_test(&bioc->stripes_pending)) {
 		if (!is_orig_bio) {
 			bio_put(bio);
-			bio = bbio->orig_bio;
+			bio = bioc->orig_bio;
 		}
 
-		btrfs_io_bio(bio)->mirror_num = bbio->mirror_num;
+		btrfs_io_bio(bio)->mirror_num = bioc->mirror_num;
 		/* only send an error to the higher layers if it is
 		 * beyond the tolerance of the btrfs bio
 		 */
-		if (atomic_read(&bbio->error) > bbio->max_errors) {
+		if (atomic_read(&bioc->error) > bioc->max_errors) {
 			bio->bi_status = BLK_STS_IOERR;
 		} else {
 			/*
@@ -6695,18 +6692,18 @@ static void btrfs_end_bio(struct bio *bio)
 			bio->bi_status = BLK_STS_OK;
 		}
 
-		btrfs_end_bbio(bbio, bio);
+		btrfs_end_bioc(bioc, bio);
 	} else if (!is_orig_bio) {
 		bio_put(bio);
 	}
 }
 
-static void submit_stripe_bio(struct btrfs_bio *bbio, struct bio *bio,
+static void submit_stripe_bio(struct btrfs_io_context *bioc, struct bio *bio,
 			      u64 physical, struct btrfs_device *dev)
 {
-	struct btrfs_fs_info *fs_info = bbio->fs_info;
+	struct btrfs_fs_info *fs_info = bioc->fs_info;
 
-	bio->bi_private = bbio;
+	bio->bi_private = bioc;
 	btrfs_io_bio(bio)->device = dev;
 	bio->bi_end_io = btrfs_end_bio;
 	bio->bi_iter.bi_sector = physical >> 9;
@@ -6736,20 +6733,20 @@ static void submit_stripe_bio(struct btrfs_bio *bbio, struct bio *bio,
 	btrfsic_submit_bio(bio);
 }
 
-static void bbio_error(struct btrfs_bio *bbio, struct bio *bio, u64 logical)
+static void bioc_error(struct btrfs_io_context *bioc, struct bio *bio, u64 logical)
 {
-	atomic_inc(&bbio->error);
-	if (atomic_dec_and_test(&bbio->stripes_pending)) {
+	atomic_inc(&bioc->error);
+	if (atomic_dec_and_test(&bioc->stripes_pending)) {
 		/* Should be the original bio. */
-		WARN_ON(bio != bbio->orig_bio);
+		WARN_ON(bio != bioc->orig_bio);
 
-		btrfs_io_bio(bio)->mirror_num = bbio->mirror_num;
+		btrfs_io_bio(bio)->mirror_num = bioc->mirror_num;
 		bio->bi_iter.bi_sector = logical >> 9;
-		if (atomic_read(&bbio->error) > bbio->max_errors)
+		if (atomic_read(&bioc->error) > bioc->max_errors)
 			bio->bi_status = BLK_STS_IOERR;
 		else
 			bio->bi_status = BLK_STS_OK;
-		btrfs_end_bbio(bbio, bio);
+		btrfs_end_bioc(bioc, bio);
 	}
 }
 
@@ -6764,35 +6761,35 @@ blk_status_t btrfs_map_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
 	int ret;
 	int dev_nr;
 	int total_devs;
-	struct btrfs_bio *bbio = NULL;
+	struct btrfs_io_context *bioc = NULL;
 
 	length = bio->bi_iter.bi_size;
 	map_length = length;
 
 	btrfs_bio_counter_inc_blocked(fs_info);
 	ret = __btrfs_map_block(fs_info, btrfs_op(bio), logical,
-				&map_length, &bbio, mirror_num, 1);
+				&map_length, &bioc, mirror_num, 1);
 	if (ret) {
 		btrfs_bio_counter_dec(fs_info);
 		return errno_to_blk_status(ret);
 	}
 
-	total_devs = bbio->num_stripes;
-	bbio->orig_bio = first_bio;
-	bbio->private = first_bio->bi_private;
-	bbio->end_io = first_bio->bi_end_io;
-	bbio->fs_info = fs_info;
-	atomic_set(&bbio->stripes_pending, bbio->num_stripes);
+	total_devs = bioc->num_stripes;
+	bioc->orig_bio = first_bio;
+	bioc->private = first_bio->bi_private;
+	bioc->end_io = first_bio->bi_end_io;
+	bioc->fs_info = fs_info;
+	atomic_set(&bioc->stripes_pending, bioc->num_stripes);
 
-	if ((bbio->map_type & BTRFS_BLOCK_GROUP_RAID56_MASK) &&
+	if ((bioc->map_type & BTRFS_BLOCK_GROUP_RAID56_MASK) &&
 	    ((btrfs_op(bio) == BTRFS_MAP_WRITE) || (mirror_num > 1))) {
 		/* In this case, map_length has been set to the length of
 		   a single stripe; not the whole write */
 		if (btrfs_op(bio) == BTRFS_MAP_WRITE) {
-			ret = raid56_parity_write(fs_info, bio, bbio,
+			ret = raid56_parity_write(fs_info, bio, bioc,
 						  map_length);
 		} else {
-			ret = raid56_parity_recover(fs_info, bio, bbio,
+			ret = raid56_parity_recover(fs_info, bio, bioc,
 						    map_length, mirror_num, 1);
 		}
 
@@ -6808,12 +6805,12 @@ blk_status_t btrfs_map_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
 	}
 
 	for (dev_nr = 0; dev_nr < total_devs; dev_nr++) {
-		dev = bbio->stripes[dev_nr].dev;
+		dev = bioc->stripes[dev_nr].dev;
 		if (!dev || !dev->bdev || test_bit(BTRFS_DEV_STATE_MISSING,
 						   &dev->dev_state) ||
 		    (btrfs_op(first_bio) == BTRFS_MAP_WRITE &&
 		    !test_bit(BTRFS_DEV_STATE_WRITEABLE, &dev->dev_state))) {
-			bbio_error(bbio, first_bio, logical);
+			bioc_error(bioc, first_bio, logical);
 			continue;
 		}
 
@@ -6822,7 +6819,7 @@ blk_status_t btrfs_map_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
 		else
 			bio = first_bio;
 
-		submit_stripe_bio(bbio, bio, bbio->stripes[dev_nr].physical, dev);
+		submit_stripe_bio(bioc, bio, bioc->stripes[dev_nr].physical, dev);
 	}
 	btrfs_bio_counter_dec(fs_info);
 	return BLK_STS_OK;
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 30288b728bbb..dfd7457709b3 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -306,11 +306,11 @@ struct btrfs_fs_devices {
 /*
  * we need the mirror number and stripe index to be passed around
  * the call chain while we are processing end_io (especially errors).
- * Really, what we need is a btrfs_bio structure that has this info
+ * Really, what we need is a btrfs_io_context structure that has this info
  * and is properly sized with its stripe array, but we're not there
  * quite yet.  We have our own btrfs bioset, and all of the bios
  * we allocate are actually btrfs_io_bios.  We'll cram as much of
- * struct btrfs_bio as we can into this over time.
+ * struct btrfs_io_context as we can into this over time.
  */
 struct btrfs_io_bio {
 	unsigned int mirror_num;
@@ -339,13 +339,29 @@ static inline void btrfs_io_bio_free_csum(struct btrfs_io_bio *io_bio)
 	}
 }
 
-struct btrfs_bio_stripe {
+struct btrfs_io_stripe {
 	struct btrfs_device *dev;
 	u64 physical;
 	u64 length; /* only used for discard mappings */
 };
 
-struct btrfs_bio {
+/*
+ * Context for IO subsmission for device stripe.
+ *
+ * - Track the unfinished mirrors for mirror based profiles
+ *   Mirror based profiles are SINGLE/DUP/RAID1/RAID10.
+ *
+ * - Contain the logical -> physical mapping info
+ *   Used by submit_stripe_bio() for mapping logical bio
+ *   into physical device address.
+ *
+ * - Contain device replace info
+ *   Used by handle_ops_on_dev_replace() to copy logical bios
+ *   into the new device.
+ *
+ * - Contain RAID56 full stripe logical bytenrs
+ */
+struct btrfs_io_context {
 	refcount_t refs;
 	atomic_t stripes_pending;
 	struct btrfs_fs_info *fs_info;
@@ -365,7 +381,7 @@ struct btrfs_bio {
 	 * so raid_map[0] is the start of our full stripe
 	 */
 	u64 *raid_map;
-	struct btrfs_bio_stripe stripes[];
+	struct btrfs_io_stripe stripes[];
 };
 
 struct btrfs_device_info {
@@ -400,11 +416,11 @@ struct map_lookup {
 	int num_stripes;
 	int sub_stripes;
 	int verified_stripes; /* For mount time dev extent verification */
-	struct btrfs_bio_stripe stripes[];
+	struct btrfs_io_stripe stripes[];
 };
 
 #define map_lookup_size(n) (sizeof(struct map_lookup) + \
-			    (sizeof(struct btrfs_bio_stripe) * (n)))
+			    (sizeof(struct btrfs_io_stripe) * (n)))
 
 struct btrfs_balance_args;
 struct btrfs_balance_progress;
@@ -457,14 +473,14 @@ static inline enum btrfs_map_op btrfs_op(struct bio *bio)
 	}
 }
 
-void btrfs_get_bbio(struct btrfs_bio *bbio);
-void btrfs_put_bbio(struct btrfs_bio *bbio);
+void btrfs_get_bioc(struct btrfs_io_context *bioc);
+void btrfs_put_bioc(struct btrfs_io_context *bioc);
 int btrfs_map_block(struct btrfs_fs_info *fs_info, enum btrfs_map_op op,
 		    u64 logical, u64 *length,
-		    struct btrfs_bio **bbio_ret, int mirror_num);
+		    struct btrfs_io_context **bioc_ret, int mirror_num);
 int btrfs_map_sblock(struct btrfs_fs_info *fs_info, enum btrfs_map_op op,
 		     u64 logical, u64 *length,
-		     struct btrfs_bio **bbio_ret);
+		     struct btrfs_io_context **bioc_ret);
 int btrfs_get_io_geometry(struct btrfs_fs_info *fs_info, struct extent_map *map,
 			  enum btrfs_map_op op, u64 logical,
 			  struct btrfs_io_geometry *io_geom);
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 3bc2f92cd197..574769f921a2 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1502,27 +1502,29 @@ int btrfs_zoned_issue_zeroout(struct btrfs_device *device, u64 physical, u64 len
 static int read_zone_info(struct btrfs_fs_info *fs_info, u64 logical,
 			  struct blk_zone *zone)
 {
-	struct btrfs_bio *bbio = NULL;
+	struct btrfs_io_context *bioc = NULL;
 	u64 mapped_length = PAGE_SIZE;
 	unsigned int nofs_flag;
 	int nmirrors;
 	int i, ret;
 
 	ret = btrfs_map_sblock(fs_info, BTRFS_MAP_GET_READ_MIRRORS, logical,
-			       &mapped_length, &bbio);
-	if (ret || !bbio || mapped_length < PAGE_SIZE) {
-		btrfs_put_bbio(bbio);
-		return -EIO;
+			       &mapped_length, &bioc);
+	if (ret || !bioc || mapped_length < PAGE_SIZE) {
+		ret = -EIO;
+		goto out_put_bioc;
 	}
 
-	if (bbio->map_type & BTRFS_BLOCK_GROUP_RAID56_MASK)
-		return -EINVAL;
+	if (bioc->map_type & BTRFS_BLOCK_GROUP_RAID56_MASK) {
+		ret = -EINVAL;
+		goto out_put_bioc;
+	}
 
 	nofs_flag = memalloc_nofs_save();
-	nmirrors = (int)bbio->num_stripes;
+	nmirrors = (int)bioc->num_stripes;
 	for (i = 0; i < nmirrors; i++) {
-		u64 physical = bbio->stripes[i].physical;
-		struct btrfs_device *dev = bbio->stripes[i].dev;
+		u64 physical = bioc->stripes[i].physical;
+		struct btrfs_device *dev = bioc->stripes[i].dev;
 
 		/* Missing device */
 		if (!dev->bdev)
@@ -1535,7 +1537,8 @@ static int read_zone_info(struct btrfs_fs_info *fs_info, u64 logical,
 		break;
 	}
 	memalloc_nofs_restore(nofs_flag);
-
+out_put_bioc:
+	btrfs_put_bioc(bioc);
 	return ret;
 }
 
diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 99b80b5c7a93..b218a26291b8 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -179,7 +179,7 @@ static int ceph_releasepage(struct page *page, gfp_t gfp)
 
 static void ceph_netfs_expand_readahead(struct netfs_read_request *rreq)
 {
-	struct inode *inode = rreq->mapping->host;
+	struct inode *inode = rreq->inode;
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_file_layout *lo = &ci->i_layout;
 	u32 blockoff;
@@ -196,7 +196,7 @@ static void ceph_netfs_expand_readahead(struct netfs_read_request *rreq)
 
 static bool ceph_netfs_clamp_length(struct netfs_read_subrequest *subreq)
 {
-	struct inode *inode = subreq->rreq->mapping->host;
+	struct inode *inode = subreq->rreq->inode;
 	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	u64 objno, objoff;
@@ -242,7 +242,7 @@ static void finish_netfs_read(struct ceph_osd_request *req)
 static void ceph_netfs_issue_op(struct netfs_read_subrequest *subreq)
 {
 	struct netfs_read_request *rreq = subreq->rreq;
-	struct inode *inode = rreq->mapping->host;
+	struct inode *inode = rreq->inode;
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
 	struct ceph_osd_request *req;
diff --git a/fs/exec.c b/fs/exec.c
index 29e865c59854..76196ddefbdd 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1298,7 +1298,7 @@ int begin_new_exec(struct linux_binprm * bprm)
 	bprm->mm = NULL;
 
 #ifdef CONFIG_POSIX_TIMERS
-	exit_itimers(me->signal);
+	exit_itimers(me);
 	flush_itimer_signals();
 #endif
 
diff --git a/fs/ksmbd/transport_tcp.c b/fs/ksmbd/transport_tcp.c
index 82a1429bbe12..755329c295ca 100644
--- a/fs/ksmbd/transport_tcp.c
+++ b/fs/ksmbd/transport_tcp.c
@@ -230,7 +230,7 @@ static int ksmbd_kthread_fn(void *p)
 			break;
 		}
 		ret = kernel_accept(iface->ksmbd_socket, &client_sk,
-				    O_NONBLOCK);
+				    SOCK_NONBLOCK);
 		mutex_unlock(&iface->sock_release_lock);
 		if (ret) {
 			if (ret == -EAGAIN)
diff --git a/fs/lockd/svcsubs.c b/fs/lockd/svcsubs.c
index 0a22a2faf552..e1c4617de771 100644
--- a/fs/lockd/svcsubs.c
+++ b/fs/lockd/svcsubs.c
@@ -176,7 +176,7 @@ nlm_delete_file(struct nlm_file *file)
 	}
 }
 
-static int nlm_unlock_files(struct nlm_file *file)
+static int nlm_unlock_files(struct nlm_file *file, fl_owner_t owner)
 {
 	struct file_lock lock;
 
@@ -184,6 +184,7 @@ static int nlm_unlock_files(struct nlm_file *file)
 	lock.fl_type  = F_UNLCK;
 	lock.fl_start = 0;
 	lock.fl_end   = OFFSET_MAX;
+	lock.fl_owner = owner;
 	if (file->f_file[O_RDONLY] &&
 	    vfs_lock_file(file->f_file[O_RDONLY], F_SETLK, &lock, NULL))
 		goto out_err;
@@ -225,7 +226,7 @@ nlm_traverse_locks(struct nlm_host *host, struct nlm_file *file,
 		if (match(lockhost, host)) {
 
 			spin_unlock(&flctx->flc_lock);
-			if (nlm_unlock_files(file))
+			if (nlm_unlock_files(file, fl->fl_owner))
 				return 1;
 			goto again;
 		}
@@ -282,11 +283,10 @@ nlm_file_inuse(struct nlm_file *file)
 
 static void nlm_close_files(struct nlm_file *file)
 {
-	struct file *f;
-
-	for (f = file->f_file[0]; f <= file->f_file[1]; f++)
-		if (f)
-			nlmsvc_ops->fclose(f);
+	if (file->f_file[O_RDONLY])
+		nlmsvc_ops->fclose(file->f_file[O_RDONLY]);
+	if (file->f_file[O_WRONLY])
+		nlmsvc_ops->fclose(file->f_file[O_WRONLY]);
 }
 
 /*
diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index 7dcb77d38759..aceb8aadca14 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -198,6 +198,9 @@ static inline int nilfs_acl_chmod(struct inode *inode)
 
 static inline int nilfs_init_acl(struct inode *inode, struct inode *dir)
 {
+	if (S_ISLNK(inode->i_mode))
+		return 0;
+
 	inode->i_mode &= ~current_umask();
 	return 0;
 }
diff --git a/fs/remap_range.c b/fs/remap_range.c
index 6d4a9beaa097..e69bafb96f09 100644
--- a/fs/remap_range.c
+++ b/fs/remap_range.c
@@ -71,7 +71,8 @@ static int generic_remap_checks(struct file *file_in, loff_t pos_in,
 	 * Otherwise, make sure the count is also block-aligned, having
 	 * already confirmed the starting offsets' block alignment.
 	 */
-	if (pos_in + count == size_in) {
+	if (pos_in + count == size_in &&
+	    (!(remap_flags & REMAP_FILE_DEDUP) || pos_out + count == size_out)) {
 		bcount = ALIGN(size_in, bs) - pos_in;
 	} else {
 		if (!IS_ALIGNED(count, bs))
diff --git a/fs/xfs/xfs_bio_io.c b/fs/xfs/xfs_bio_io.c
index 667e297f59b1..17f36db2f792 100644
--- a/fs/xfs/xfs_bio_io.c
+++ b/fs/xfs/xfs_bio_io.c
@@ -9,41 +9,6 @@ static inline unsigned int bio_max_vecs(unsigned int count)
 	return bio_max_segs(howmany(count, PAGE_SIZE));
 }
 
-static void
-xfs_flush_bdev_async_endio(
-	struct bio	*bio)
-{
-	complete(bio->bi_private);
-}
-
-/*
- * Submit a request for an async cache flush to run. If the request queue does
- * not require flush operations, just skip it altogether. If the caller needs
- * to wait for the flush completion at a later point in time, they must supply a
- * valid completion. This will be signalled when the flush completes.  The
- * caller never sees the bio that is issued here.
- */
-void
-xfs_flush_bdev_async(
-	struct bio		*bio,
-	struct block_device	*bdev,
-	struct completion	*done)
-{
-	struct request_queue	*q = bdev->bd_disk->queue;
-
-	if (!test_bit(QUEUE_FLAG_WC, &q->queue_flags)) {
-		complete(done);
-		return;
-	}
-
-	bio_init(bio, NULL, 0);
-	bio_set_dev(bio, bdev);
-	bio->bi_opf = REQ_OP_WRITE | REQ_PREFLUSH | REQ_SYNC;
-	bio->bi_private = done;
-	bio->bi_end_io = xfs_flush_bdev_async_endio;
-
-	submit_bio(bio);
-}
 int
 xfs_rw_bdev(
 	struct block_device	*bdev,
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 33e26690a8c4..710e857bb825 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -434,7 +434,7 @@ xfs_reserve_blocks(
 	error = -ENOSPC;
 	do {
 		free = percpu_counter_sum(&mp->m_fdblocks) -
-						mp->m_alloc_set_aside;
+						xfs_fdblocks_unavailable(mp);
 		if (free <= 0)
 			break;
 
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index 09a8fba84ff9..cb9105d667db 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -197,8 +197,6 @@ static inline uint64_t howmany_64(uint64_t x, uint32_t y)
 
 int xfs_rw_bdev(struct block_device *bdev, sector_t sector, unsigned int count,
 		char *data, unsigned int op);
-void xfs_flush_bdev_async(struct bio *bio, struct block_device *bdev,
-		struct completion *done);
 
 #define ASSERT_ALWAYS(expr)	\
 	(likely(expr) ? (void)0 : assfail(NULL, #expr, __FILE__, __LINE__))
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index f6cd2d4aa770..0fb7d05ca308 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -487,7 +487,10 @@ xfs_log_reserve(
  * Run all the pending iclog callbacks and wake log force waiters and iclog
  * space waiters so they can process the newly set shutdown state. We really
  * don't care what order we process callbacks here because the log is shut down
- * and so state cannot change on disk anymore.
+ * and so state cannot change on disk anymore. However, we cannot wake waiters
+ * until the callbacks have been processed because we may be in unmount and
+ * we must ensure that all AIL operations the callbacks perform have completed
+ * before we tear down the AIL.
  *
  * We avoid processing actively referenced iclogs so that we don't run callbacks
  * while the iclog owner might still be preparing the iclog for IO submssion.
@@ -501,7 +504,6 @@ xlog_state_shutdown_callbacks(
 	struct xlog_in_core	*iclog;
 	LIST_HEAD(cb_list);
 
-	spin_lock(&log->l_icloglock);
 	iclog = log->l_iclog;
 	do {
 		if (atomic_read(&iclog->ic_refcnt)) {
@@ -509,26 +511,22 @@ xlog_state_shutdown_callbacks(
 			continue;
 		}
 		list_splice_init(&iclog->ic_callbacks, &cb_list);
+		spin_unlock(&log->l_icloglock);
+
+		xlog_cil_process_committed(&cb_list);
+
+		spin_lock(&log->l_icloglock);
 		wake_up_all(&iclog->ic_write_wait);
 		wake_up_all(&iclog->ic_force_wait);
 	} while ((iclog = iclog->ic_next) != log->l_iclog);
 
 	wake_up_all(&log->l_flush_wait);
-	spin_unlock(&log->l_icloglock);
-
-	xlog_cil_process_committed(&cb_list);
 }
 
 /*
  * Flush iclog to disk if this is the last reference to the given iclog and the
  * it is in the WANT_SYNC state.
  *
- * If the caller passes in a non-zero @old_tail_lsn and the current log tail
- * does not match, there may be metadata on disk that must be persisted before
- * this iclog is written.  To satisfy that requirement, set the
- * XLOG_ICL_NEED_FLUSH flag as a condition for writing this iclog with the new
- * log tail value.
- *
  * If XLOG_ICL_NEED_FUA is already set on the iclog, we need to ensure that the
  * log tail is updated correctly. NEED_FUA indicates that the iclog will be
  * written to stable storage, and implies that a commit record is contained
@@ -545,12 +543,10 @@ xlog_state_shutdown_callbacks(
  * always capture the tail lsn on the iclog on the first NEED_FUA release
  * regardless of the number of active reference counts on this iclog.
  */
-
 int
 xlog_state_release_iclog(
 	struct xlog		*log,
-	struct xlog_in_core	*iclog,
-	xfs_lsn_t		old_tail_lsn)
+	struct xlog_in_core	*iclog)
 {
 	xfs_lsn_t		tail_lsn;
 	bool			last_ref;
@@ -561,18 +557,14 @@ xlog_state_release_iclog(
 	/*
 	 * Grabbing the current log tail needs to be atomic w.r.t. the writing
 	 * of the tail LSN into the iclog so we guarantee that the log tail does
-	 * not move between deciding if a cache flush is required and writing
-	 * the LSN into the iclog below.
+	 * not move between the first time we know that the iclog needs to be
+	 * made stable and when we eventually submit it.
 	 */
-	if (old_tail_lsn || iclog->ic_state == XLOG_STATE_WANT_SYNC) {
+	if ((iclog->ic_state == XLOG_STATE_WANT_SYNC ||
+	     (iclog->ic_flags & XLOG_ICL_NEED_FUA)) &&
+	    !iclog->ic_header.h_tail_lsn) {
 		tail_lsn = xlog_assign_tail_lsn(log->l_mp);
-
-		if (old_tail_lsn && tail_lsn != old_tail_lsn)
-			iclog->ic_flags |= XLOG_ICL_NEED_FLUSH;
-
-		if ((iclog->ic_flags & XLOG_ICL_NEED_FUA) &&
-		    !iclog->ic_header.h_tail_lsn)
-			iclog->ic_header.h_tail_lsn = cpu_to_be64(tail_lsn);
+		iclog->ic_header.h_tail_lsn = cpu_to_be64(tail_lsn);
 	}
 
 	last_ref = atomic_dec_and_test(&iclog->ic_refcnt);
@@ -583,11 +575,8 @@ xlog_state_release_iclog(
 		 * pending iclog callbacks that were waiting on the release of
 		 * this iclog.
 		 */
-		if (last_ref) {
-			spin_unlock(&log->l_icloglock);
+		if (last_ref)
 			xlog_state_shutdown_callbacks(log);
-			spin_lock(&log->l_icloglock);
-		}
 		return -EIO;
 	}
 
@@ -600,8 +589,6 @@ xlog_state_release_iclog(
 	}
 
 	iclog->ic_state = XLOG_STATE_SYNCING;
-	if (!iclog->ic_header.h_tail_lsn)
-		iclog->ic_header.h_tail_lsn = cpu_to_be64(tail_lsn);
 	xlog_verify_tail_lsn(log, iclog);
 	trace_xlog_iclog_syncing(iclog, _RET_IP_);
 
@@ -874,7 +861,7 @@ xlog_force_iclog(
 	iclog->ic_flags |= XLOG_ICL_NEED_FLUSH | XLOG_ICL_NEED_FUA;
 	if (iclog->ic_state == XLOG_STATE_ACTIVE)
 		xlog_state_switch_iclogs(iclog->ic_log, iclog, 0);
-	return xlog_state_release_iclog(iclog->ic_log, iclog, 0);
+	return xlog_state_release_iclog(iclog->ic_log, iclog);
 }
 
 /*
@@ -2412,7 +2399,7 @@ xlog_write_copy_finish(
 		ASSERT(iclog->ic_state == XLOG_STATE_WANT_SYNC ||
 			xlog_is_shutdown(log));
 release_iclog:
-	error = xlog_state_release_iclog(log, iclog, 0);
+	error = xlog_state_release_iclog(log, iclog);
 	spin_unlock(&log->l_icloglock);
 	return error;
 }
@@ -2629,7 +2616,7 @@ xlog_write(
 
 	spin_lock(&log->l_icloglock);
 	xlog_state_finish_copy(log, iclog, record_cnt, data_cnt);
-	error = xlog_state_release_iclog(log, iclog, 0);
+	error = xlog_state_release_iclog(log, iclog);
 	spin_unlock(&log->l_icloglock);
 
 	return error;
@@ -3053,7 +3040,7 @@ xlog_state_get_iclog_space(
 		 * reference to the iclog.
 		 */
 		if (!atomic_add_unless(&iclog->ic_refcnt, -1, 1))
-			error = xlog_state_release_iclog(log, iclog, 0);
+			error = xlog_state_release_iclog(log, iclog);
 		spin_unlock(&log->l_icloglock);
 		if (error)
 			return error;
@@ -3904,7 +3891,10 @@ xlog_force_shutdown(
 	wake_up_all(&log->l_cilp->xc_start_wait);
 	wake_up_all(&log->l_cilp->xc_commit_wait);
 	spin_unlock(&log->l_cilp->xc_push_lock);
+
+	spin_lock(&log->l_icloglock);
 	xlog_state_shutdown_callbacks(log);
+	spin_unlock(&log->l_icloglock);
 
 	return log_error;
 }
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index b59cc9c0961c..eafe30843ff0 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -681,11 +681,21 @@ xlog_cil_set_ctx_write_state(
 		 * The LSN we need to pass to the log items on transaction
 		 * commit is the LSN reported by the first log vector write, not
 		 * the commit lsn. If we use the commit record lsn then we can
-		 * move the tail beyond the grant write head.
+		 * move the grant write head beyond the tail LSN and overwrite
+		 * it.
 		 */
 		ctx->start_lsn = lsn;
 		wake_up_all(&cil->xc_start_wait);
 		spin_unlock(&cil->xc_push_lock);
+
+		/*
+		 * Make sure the metadata we are about to overwrite in the log
+		 * has been flushed to stable storage before this iclog is
+		 * issued.
+		 */
+		spin_lock(&cil->xc_log->l_icloglock);
+		iclog->ic_flags |= XLOG_ICL_NEED_FLUSH;
+		spin_unlock(&cil->xc_log->l_icloglock);
 		return;
 	}
 
@@ -864,10 +874,7 @@ xlog_cil_push_work(
 	struct xfs_trans_header thdr;
 	struct xfs_log_iovec	lhdr;
 	struct xfs_log_vec	lvhdr = { NULL };
-	xfs_lsn_t		preflush_tail_lsn;
 	xfs_csn_t		push_seq;
-	struct bio		bio;
-	DECLARE_COMPLETION_ONSTACK(bdev_flush);
 	bool			push_commit_stable;
 
 	new_ctx = xlog_cil_ctx_alloc();
@@ -937,23 +944,6 @@ xlog_cil_push_work(
 	list_add(&ctx->committing, &cil->xc_committing);
 	spin_unlock(&cil->xc_push_lock);
 
-	/*
-	 * The CIL is stable at this point - nothing new will be added to it
-	 * because we hold the flush lock exclusively. Hence we can now issue
-	 * a cache flush to ensure all the completed metadata in the journal we
-	 * are about to overwrite is on stable storage.
-	 *
-	 * Because we are issuing this cache flush before we've written the
-	 * tail lsn to the iclog, we can have metadata IO completions move the
-	 * tail forwards between the completion of this flush and the iclog
-	 * being written. In this case, we need to re-issue the cache flush
-	 * before the iclog write. To detect whether the log tail moves, sample
-	 * the tail LSN *before* we issue the flush.
-	 */
-	preflush_tail_lsn = atomic64_read(&log->l_tail_lsn);
-	xfs_flush_bdev_async(&bio, log->l_mp->m_ddev_targp->bt_bdev,
-				&bdev_flush);
-
 	/*
 	 * Pull all the log vectors off the items in the CIL, and remove the
 	 * items from the CIL. We don't need the CIL lock here because it's only
@@ -1030,12 +1020,6 @@ xlog_cil_push_work(
 	lvhdr.lv_iovecp = &lhdr;
 	lvhdr.lv_next = ctx->lv_chain;
 
-	/*
-	 * Before we format and submit the first iclog, we have to ensure that
-	 * the metadata writeback ordering cache flush is complete.
-	 */
-	wait_for_completion(&bdev_flush);
-
 	error = xlog_cil_write_chain(ctx, &lvhdr);
 	if (error)
 		goto out_abort_free_ticket;
@@ -1094,7 +1078,7 @@ xlog_cil_push_work(
 	if (push_commit_stable &&
 	    ctx->commit_iclog->ic_state == XLOG_STATE_ACTIVE)
 		xlog_state_switch_iclogs(log, ctx->commit_iclog, 0);
-	xlog_state_release_iclog(log, ctx->commit_iclog, preflush_tail_lsn);
+	xlog_state_release_iclog(log, ctx->commit_iclog);
 
 	/* Not safe to reference ctx now! */
 
@@ -1115,7 +1099,7 @@ xlog_cil_push_work(
 		return;
 	}
 	spin_lock(&log->l_icloglock);
-	xlog_state_release_iclog(log, ctx->commit_iclog, 0);
+	xlog_state_release_iclog(log, ctx->commit_iclog);
 	/* Not safe to reference ctx now! */
 	spin_unlock(&log->l_icloglock);
 }
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 844fbeec3545..f3d68ca39f45 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -524,8 +524,7 @@ void	xfs_log_ticket_regrant(struct xlog *log, struct xlog_ticket *ticket);
 
 void xlog_state_switch_iclogs(struct xlog *log, struct xlog_in_core *iclog,
 		int eventual_size);
-int xlog_state_release_iclog(struct xlog *log, struct xlog_in_core *iclog,
-		xfs_lsn_t log_tail_lsn);
+int xlog_state_release_iclog(struct xlog *log, struct xlog_in_core *iclog);
 
 /*
  * When we crack an atomic LSN, we sample it first so that the value will not
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 10562ecbd9ea..581aeb288b32 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -27,7 +27,7 @@
 #include "xfs_buf_item.h"
 #include "xfs_ag.h"
 #include "xfs_quota.h"
-
+#include "xfs_reflink.h"
 
 #define BLK_AVG(blk1, blk2)	((blk1+blk2) >> 1)
 
@@ -3502,6 +3502,28 @@ xlog_recover_finish(
 
 	xlog_recover_process_iunlinks(log);
 	xlog_recover_check_summary(log);
+
+	/*
+	 * Recover any CoW staging blocks that are still referenced by the
+	 * ondisk refcount metadata.  During mount there cannot be any live
+	 * staging extents as we have not permitted any user modifications.
+	 * Therefore, it is safe to free them all right now, even on a
+	 * read-only mount.
+	 */
+	error = xfs_reflink_recover_cow(log->l_mp);
+	if (error) {
+		xfs_alert(log->l_mp,
+	"Failed to recover leftover CoW staging extents, err %d.",
+				error);
+		/*
+		 * If we get an error here, make sure the log is shut down
+		 * but return zero so that any log items committed since the
+		 * end of intents processing can be pushed through the CIL
+		 * and AIL.
+		 */
+		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
+	}
+
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 06dac09eddbd..76056de83971 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -922,15 +922,6 @@ xfs_mountfs(
 			xfs_warn(mp,
 	"Unable to allocate reserve blocks. Continuing without reserve pool.");
 
-		/* Recover any CoW blocks that never got remapped. */
-		error = xfs_reflink_recover_cow(mp);
-		if (error) {
-			xfs_err(mp,
-	"Error %d recovering leftover CoW allocations.", error);
-			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
-			goto out_quota;
-		}
-
 		/* Reserve AG blocks for future btree expansion. */
 		error = xfs_fs_reserve_ag_blocks(mp);
 		if (error && error != -ENOSPC)
@@ -941,7 +932,6 @@ xfs_mountfs(
 
  out_agresv:
 	xfs_fs_unreserve_ag_blocks(mp);
- out_quota:
 	xfs_qm_unmount_quotas(mp);
  out_rtunmount:
 	xfs_rtunmount_inodes(mp);
@@ -1142,7 +1132,7 @@ xfs_mod_fdblocks(
 	 * problems (i.e. transaction abort, pagecache discards, etc.) than
 	 * slightly premature -ENOSPC.
 	 */
-	set_aside = mp->m_alloc_set_aside + atomic64_read(&mp->m_allocbt_blks);
+	set_aside = xfs_fdblocks_unavailable(mp);
 	percpu_counter_add_batch(&mp->m_fdblocks, delta, batch);
 	if (__percpu_counter_compare(&mp->m_fdblocks, set_aside,
 				     XFS_FDBLOCKS_BATCH) >= 0) {
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index e091f3b3fa15..86564295fce6 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -478,6 +478,21 @@ extern void	xfs_unmountfs(xfs_mount_t *);
  */
 #define XFS_FDBLOCKS_BATCH	1024
 
+/*
+ * Estimate the amount of free space that is not available to userspace and is
+ * not explicitly reserved from the incore fdblocks.  This includes:
+ *
+ * - The minimum number of blocks needed to support splitting a bmap btree
+ * - The blocks currently in use by the freespace btrees because they record
+ *   the actual blocks that will fill per-AG metadata space reservations
+ */
+static inline uint64_t
+xfs_fdblocks_unavailable(
+	struct xfs_mount	*mp)
+{
+	return mp->m_alloc_set_aside + atomic64_read(&mp->m_allocbt_blks);
+}
+
 extern int	xfs_mod_fdblocks(struct xfs_mount *mp, int64_t delta,
 				 bool reserved);
 extern int	xfs_mod_frextents(struct xfs_mount *mp, int64_t delta);
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 76355f293488..36832e4bc803 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -749,7 +749,10 @@ xfs_reflink_end_cow(
 }
 
 /*
- * Free leftover CoW reservations that didn't get cleaned out.
+ * Free all CoW staging blocks that are still referenced by the ondisk refcount
+ * metadata.  The ondisk metadata does not track which inode created the
+ * staging extent, so callers must ensure that there are no cached inodes with
+ * live CoW staging extents.
  */
 int
 xfs_reflink_recover_cow(
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index e8d19916ba99..5410bf0ab426 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1742,15 +1742,6 @@ xfs_remount_rw(
 	 */
 	xfs_restore_resvblks(mp);
 	xfs_log_work_queue(mp);
-
-	/* Recover any CoW blocks that never got remapped. */
-	error = xfs_reflink_recover_cow(mp);
-	if (error) {
-		xfs_err(mp,
-			"Error %d recovering leftover CoW allocations.", error);
-		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
-		return error;
-	}
 	xfs_blockgc_start(mp);
 
 	/* Create the per-AG metadata reservation pool .*/
diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index db2e147e069f..cd8b8bd5ec4d 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -264,7 +264,8 @@ struct css_set {
 	 * List of csets participating in the on-going migration either as
 	 * source or destination.  Protected by cgroup_mutex.
 	 */
-	struct list_head mg_preload_node;
+	struct list_head mg_src_preload_node;
+	struct list_head mg_dst_preload_node;
 	struct list_head mg_node;
 
 	/*
diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index 33be67c2f7ff..cf042d41c87b 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -452,6 +452,12 @@ static inline int kexec_crash_loaded(void) { return 0; }
 #define kexec_in_progress false
 #endif /* CONFIG_KEXEC_CORE */
 
+#ifdef CONFIG_KEXEC_SIG
+void set_kexec_sig_enforced(void);
+#else
+static inline void set_kexec_sig_enforced(void) {}
+#endif
+
 #endif /* !defined(__ASSEBMLY__) */
 
 #endif /* LINUX_KEXEC_H */
diff --git a/include/linux/reset.h b/include/linux/reset.h
index db0e6115a2f6..7bb583737528 100644
--- a/include/linux/reset.h
+++ b/include/linux/reset.h
@@ -711,7 +711,7 @@ static inline int __must_check
 devm_reset_control_bulk_get_optional_exclusive(struct device *dev, int num_rstcs,
 					       struct reset_control_bulk_data *rstcs)
 {
-	return __devm_reset_control_bulk_get(dev, num_rstcs, rstcs, true, false, true);
+	return __devm_reset_control_bulk_get(dev, num_rstcs, rstcs, false, true, true);
 }
 
 /**
diff --git a/include/linux/sched/task.h b/include/linux/sched/task.h
index 8db25fcc1eba..caae8e045160 100644
--- a/include/linux/sched/task.h
+++ b/include/linux/sched/task.h
@@ -81,7 +81,7 @@ static inline void exit_thread(struct task_struct *tsk)
 extern void do_group_exit(int);
 
 extern void exit_files(struct task_struct *);
-extern void exit_itimers(struct signal_struct *);
+extern void exit_itimers(struct task_struct *);
 
 extern pid_t kernel_clone(struct kernel_clone_args *kargs);
 struct task_struct *create_io_thread(int (*fn)(void *), void *arg, int node);
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 8c32935e1059..6d07b5f9e3b8 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -388,6 +388,11 @@ static const bool earlycon_acpi_spcr_enable EARLYCON_USED_OR_UNUSED;
 static inline int setup_earlycon(char *buf) { return 0; }
 #endif
 
+static inline bool uart_console_enabled(struct uart_port *port)
+{
+	return uart_console(port) && (port->cons->flags & CON_ENABLED);
+}
+
 struct uart_port *uart_get_console(struct uart_port *ports, int nr,
 				   struct console *c);
 int uart_parse_earlycon(char *p, unsigned char *iotype, resource_size_t *addr,
diff --git a/include/linux/sysfb.h b/include/linux/sysfb.h
index b0dcfa26d07b..8ba8b5be5567 100644
--- a/include/linux/sysfb.h
+++ b/include/linux/sysfb.h
@@ -55,6 +55,18 @@ struct efifb_dmi_info {
 	int flags;
 };
 
+#ifdef CONFIG_SYSFB
+
+void sysfb_disable(void);
+
+#else /* CONFIG_SYSFB */
+
+static inline void sysfb_disable(void)
+{
+}
+
+#endif /* CONFIG_SYSFB */
+
 #ifdef CONFIG_EFI
 
 extern struct efifb_dmi_info efifb_dmi_list[];
@@ -72,8 +84,8 @@ static inline void sysfb_apply_efi_quirks(struct platform_device *pd)
 
 bool sysfb_parse_mode(const struct screen_info *si,
 		      struct simplefb_platform_data *mode);
-int sysfb_create_simplefb(const struct screen_info *si,
-			  const struct simplefb_platform_data *mode);
+struct platform_device *sysfb_create_simplefb(const struct screen_info *si,
+					      const struct simplefb_platform_data *mode);
 
 #else /* CONFIG_SYSFB_SIMPLE */
 
@@ -83,10 +95,10 @@ static inline bool sysfb_parse_mode(const struct screen_info *si,
 	return false;
 }
 
-static inline int sysfb_create_simplefb(const struct screen_info *si,
-					 const struct simplefb_platform_data *mode)
+static inline struct platform_device *sysfb_create_simplefb(const struct screen_info *si,
+							    const struct simplefb_platform_data *mode)
 {
-	return -EINVAL;
+	return ERR_PTR(-EINVAL);
 }
 
 #endif /* CONFIG_SYSFB_SIMPLE */
diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index bcfee89012a1..f56a1071c005 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -642,18 +642,22 @@ static inline void nft_set_ext_prepare(struct nft_set_ext_tmpl *tmpl)
 	tmpl->len = sizeof(struct nft_set_ext);
 }
 
-static inline void nft_set_ext_add_length(struct nft_set_ext_tmpl *tmpl, u8 id,
-					  unsigned int len)
+static inline int nft_set_ext_add_length(struct nft_set_ext_tmpl *tmpl, u8 id,
+					 unsigned int len)
 {
 	tmpl->len	 = ALIGN(tmpl->len, nft_set_ext_types[id].align);
-	BUG_ON(tmpl->len > U8_MAX);
+	if (tmpl->len > U8_MAX)
+		return -EINVAL;
+
 	tmpl->offset[id] = tmpl->len;
 	tmpl->len	+= nft_set_ext_types[id].len + len;
+
+	return 0;
 }
 
-static inline void nft_set_ext_add(struct nft_set_ext_tmpl *tmpl, u8 id)
+static inline int nft_set_ext_add(struct nft_set_ext_tmpl *tmpl, u8 id)
 {
-	nft_set_ext_add_length(tmpl, id, 0);
+	return nft_set_ext_add_length(tmpl, id, 0);
 }
 
 static inline void nft_set_ext_init(struct nft_set_ext *ext,
diff --git a/include/net/raw.h b/include/net/raw.h
index 8ad8df594853..c51a635671a7 100644
--- a/include/net/raw.h
+++ b/include/net/raw.h
@@ -75,7 +75,7 @@ static inline bool raw_sk_bound_dev_eq(struct net *net, int bound_dev_if,
 				       int dif, int sdif)
 {
 #if IS_ENABLED(CONFIG_NET_L3_MASTER_DEV)
-	return inet_bound_dev_eq(!!net->ipv4.sysctl_raw_l3mdev_accept,
+	return inet_bound_dev_eq(READ_ONCE(net->ipv4.sysctl_raw_l3mdev_accept),
 				 bound_dev_if, dif, sdif);
 #else
 	return inet_bound_dev_eq(true, bound_dev_if, dif, sdif);
diff --git a/include/net/sock.h b/include/net/sock.h
index 7d49196a3880..96f51d4b1649 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1484,7 +1484,7 @@ void __sk_mem_reclaim(struct sock *sk, int amount);
 /* sysctl_mem values are in pages, we convert them in SK_MEM_QUANTUM units */
 static inline long sk_prot_mem_limits(const struct sock *sk, int index)
 {
-	long val = sk->sk_prot->sysctl_mem[index];
+	long val = READ_ONCE(sk->sk_prot->sysctl_mem[index]);
 
 #if PAGE_SIZE > SK_MEM_QUANTUM
 	val <<= PAGE_SHIFT - SK_MEM_QUANTUM_SHIFT;
diff --git a/include/net/tls.h b/include/net/tls.h
index 1fffb206f09f..bf3d63a52788 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -707,7 +707,7 @@ int tls_sw_fallback_init(struct sock *sk,
 			 struct tls_crypto_info *crypto_info);
 
 #ifdef CONFIG_TLS_DEVICE
-void tls_device_init(void);
+int tls_device_init(void);
 void tls_device_cleanup(void);
 void tls_device_sk_destruct(struct sock *sk);
 int tls_set_device_offload(struct sock *sk, struct tls_context *ctx);
@@ -727,7 +727,7 @@ static inline bool tls_is_sk_rx_device_offloaded(struct sock *sk)
 	return tls_get_ctx(sk)->rx_conf == TLS_HW;
 }
 #else
-static inline void tls_device_init(void) {}
+static inline int tls_device_init(void) { return 0; }
 static inline void tls_device_cleanup(void) {}
 
 static inline int
diff --git a/include/trace/events/sock.h b/include/trace/events/sock.h
index 12c315782766..777ee6cbe933 100644
--- a/include/trace/events/sock.h
+++ b/include/trace/events/sock.h
@@ -98,7 +98,7 @@ TRACE_EVENT(sock_exceed_buf_limit,
 
 	TP_STRUCT__entry(
 		__array(char, name, 32)
-		__field(long *, sysctl_mem)
+		__array(long, sysctl_mem, 3)
 		__field(long, allocated)
 		__field(int, sysctl_rmem)
 		__field(int, rmem_alloc)
@@ -110,7 +110,9 @@ TRACE_EVENT(sock_exceed_buf_limit,
 
 	TP_fast_assign(
 		strncpy(__entry->name, prot->name, 32);
-		__entry->sysctl_mem = prot->sysctl_mem;
+		__entry->sysctl_mem[0] = READ_ONCE(prot->sysctl_mem[0]);
+		__entry->sysctl_mem[1] = READ_ONCE(prot->sysctl_mem[1]);
+		__entry->sysctl_mem[2] = READ_ONCE(prot->sysctl_mem[2]);
 		__entry->allocated = allocated;
 		__entry->sysctl_rmem = sk_get_rmem0(sk, prot);
 		__entry->rmem_alloc = atomic_read(&sk->sk_rmem_alloc);
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index de8b4fa1e1fd..e7c3b0e586f2 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -764,7 +764,8 @@ struct css_set init_css_set = {
 	.task_iters		= LIST_HEAD_INIT(init_css_set.task_iters),
 	.threaded_csets		= LIST_HEAD_INIT(init_css_set.threaded_csets),
 	.cgrp_links		= LIST_HEAD_INIT(init_css_set.cgrp_links),
-	.mg_preload_node	= LIST_HEAD_INIT(init_css_set.mg_preload_node),
+	.mg_src_preload_node	= LIST_HEAD_INIT(init_css_set.mg_src_preload_node),
+	.mg_dst_preload_node	= LIST_HEAD_INIT(init_css_set.mg_dst_preload_node),
 	.mg_node		= LIST_HEAD_INIT(init_css_set.mg_node),
 
 	/*
@@ -1239,7 +1240,8 @@ static struct css_set *find_css_set(struct css_set *old_cset,
 	INIT_LIST_HEAD(&cset->threaded_csets);
 	INIT_HLIST_NODE(&cset->hlist);
 	INIT_LIST_HEAD(&cset->cgrp_links);
-	INIT_LIST_HEAD(&cset->mg_preload_node);
+	INIT_LIST_HEAD(&cset->mg_src_preload_node);
+	INIT_LIST_HEAD(&cset->mg_dst_preload_node);
 	INIT_LIST_HEAD(&cset->mg_node);
 
 	/* Copy the set of subsystem state objects generated in
@@ -2596,21 +2598,27 @@ int cgroup_migrate_vet_dst(struct cgroup *dst_cgrp)
  */
 void cgroup_migrate_finish(struct cgroup_mgctx *mgctx)
 {
-	LIST_HEAD(preloaded);
 	struct css_set *cset, *tmp_cset;
 
 	lockdep_assert_held(&cgroup_mutex);
 
 	spin_lock_irq(&css_set_lock);
 
-	list_splice_tail_init(&mgctx->preloaded_src_csets, &preloaded);
-	list_splice_tail_init(&mgctx->preloaded_dst_csets, &preloaded);
+	list_for_each_entry_safe(cset, tmp_cset, &mgctx->preloaded_src_csets,
+				 mg_src_preload_node) {
+		cset->mg_src_cgrp = NULL;
+		cset->mg_dst_cgrp = NULL;
+		cset->mg_dst_cset = NULL;
+		list_del_init(&cset->mg_src_preload_node);
+		put_css_set_locked(cset);
+	}
 
-	list_for_each_entry_safe(cset, tmp_cset, &preloaded, mg_preload_node) {
+	list_for_each_entry_safe(cset, tmp_cset, &mgctx->preloaded_dst_csets,
+				 mg_dst_preload_node) {
 		cset->mg_src_cgrp = NULL;
 		cset->mg_dst_cgrp = NULL;
 		cset->mg_dst_cset = NULL;
-		list_del_init(&cset->mg_preload_node);
+		list_del_init(&cset->mg_dst_preload_node);
 		put_css_set_locked(cset);
 	}
 
@@ -2652,7 +2660,7 @@ void cgroup_migrate_add_src(struct css_set *src_cset,
 
 	src_cgrp = cset_cgroup_from_root(src_cset, dst_cgrp->root);
 
-	if (!list_empty(&src_cset->mg_preload_node))
+	if (!list_empty(&src_cset->mg_src_preload_node))
 		return;
 
 	WARN_ON(src_cset->mg_src_cgrp);
@@ -2663,7 +2671,7 @@ void cgroup_migrate_add_src(struct css_set *src_cset,
 	src_cset->mg_src_cgrp = src_cgrp;
 	src_cset->mg_dst_cgrp = dst_cgrp;
 	get_css_set(src_cset);
-	list_add_tail(&src_cset->mg_preload_node, &mgctx->preloaded_src_csets);
+	list_add_tail(&src_cset->mg_src_preload_node, &mgctx->preloaded_src_csets);
 }
 
 /**
@@ -2688,7 +2696,7 @@ int cgroup_migrate_prepare_dst(struct cgroup_mgctx *mgctx)
 
 	/* look up the dst cset for each src cset and link it to src */
 	list_for_each_entry_safe(src_cset, tmp_cset, &mgctx->preloaded_src_csets,
-				 mg_preload_node) {
+				 mg_src_preload_node) {
 		struct css_set *dst_cset;
 		struct cgroup_subsys *ss;
 		int ssid;
@@ -2707,7 +2715,7 @@ int cgroup_migrate_prepare_dst(struct cgroup_mgctx *mgctx)
 		if (src_cset == dst_cset) {
 			src_cset->mg_src_cgrp = NULL;
 			src_cset->mg_dst_cgrp = NULL;
-			list_del_init(&src_cset->mg_preload_node);
+			list_del_init(&src_cset->mg_src_preload_node);
 			put_css_set(src_cset);
 			put_css_set(dst_cset);
 			continue;
@@ -2715,8 +2723,8 @@ int cgroup_migrate_prepare_dst(struct cgroup_mgctx *mgctx)
 
 		src_cset->mg_dst_cset = dst_cset;
 
-		if (list_empty(&dst_cset->mg_preload_node))
-			list_add_tail(&dst_cset->mg_preload_node,
+		if (list_empty(&dst_cset->mg_dst_preload_node))
+			list_add_tail(&dst_cset->mg_dst_preload_node,
 				      &mgctx->preloaded_dst_csets);
 		else
 			put_css_set(dst_cset);
@@ -2962,7 +2970,8 @@ static int cgroup_update_dfl_csses(struct cgroup *cgrp)
 		goto out_finish;
 
 	spin_lock_irq(&css_set_lock);
-	list_for_each_entry(src_cset, &mgctx.preloaded_src_csets, mg_preload_node) {
+	list_for_each_entry(src_cset, &mgctx.preloaded_src_csets,
+			    mg_src_preload_node) {
 		struct task_struct *task, *ntask;
 
 		/* all tasks in src_csets need to be migrated */
diff --git a/kernel/exit.c b/kernel/exit.c
index 91a43e57a32e..aefe7445508d 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -796,7 +796,7 @@ void __noreturn do_exit(long code)
 
 #ifdef CONFIG_POSIX_TIMERS
 		hrtimer_cancel(&tsk->signal->real_timer);
-		exit_itimers(tsk->signal);
+		exit_itimers(tsk);
 #endif
 		if (tsk->mm)
 			setmax_mm_hiwater_rss(&tsk->signal->maxrss, tsk->mm);
diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
index e289e60ba3ad..f7a4fd4d243f 100644
--- a/kernel/kexec_file.c
+++ b/kernel/kexec_file.c
@@ -29,6 +29,15 @@
 #include <linux/vmalloc.h>
 #include "kexec_internal.h"
 
+#ifdef CONFIG_KEXEC_SIG
+static bool sig_enforce = IS_ENABLED(CONFIG_KEXEC_SIG_FORCE);
+
+void set_kexec_sig_enforced(void)
+{
+	sig_enforce = true;
+}
+#endif
+
 static int kexec_calculate_store_digests(struct kimage *image);
 
 /*
@@ -159,7 +168,7 @@ kimage_validate_signature(struct kimage *image)
 					   image->kernel_buf_len);
 	if (ret) {
 
-		if (IS_ENABLED(CONFIG_KEXEC_SIG_FORCE)) {
+		if (sig_enforce) {
 			pr_notice("Enforced kernel signature verification failed (%d).\n", ret);
 			return ret;
 		}
diff --git a/kernel/signal.c b/kernel/signal.c
index d831f0aec56e..c7dbb19219b9 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2027,12 +2027,12 @@ bool do_notify_parent(struct task_struct *tsk, int sig)
 	bool autoreap = false;
 	u64 utime, stime;
 
-	BUG_ON(sig == -1);
+	WARN_ON_ONCE(sig == -1);
 
- 	/* do_notify_parent_cldstop should have been called instead.  */
- 	BUG_ON(task_is_stopped_or_traced(tsk));
+	/* do_notify_parent_cldstop should have been called instead.  */
+	WARN_ON_ONCE(task_is_stopped_or_traced(tsk));
 
-	BUG_ON(!tsk->ptrace &&
+	WARN_ON_ONCE(!tsk->ptrace &&
 	       (tsk->group_leader != tsk || !thread_group_empty(tsk)));
 
 	/* Wake up all pidfd waiters */
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 0586047f7323..25c18b2df684 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -566,14 +566,14 @@ static int do_proc_dointvec_conv(bool *negp, unsigned long *lvalp,
 		if (*negp) {
 			if (*lvalp > (unsigned long) INT_MAX + 1)
 				return -EINVAL;
-			*valp = -*lvalp;
+			WRITE_ONCE(*valp, -*lvalp);
 		} else {
 			if (*lvalp > (unsigned long) INT_MAX)
 				return -EINVAL;
-			*valp = *lvalp;
+			WRITE_ONCE(*valp, *lvalp);
 		}
 	} else {
-		int val = *valp;
+		int val = READ_ONCE(*valp);
 		if (val < 0) {
 			*negp = true;
 			*lvalp = -(unsigned long)val;
@@ -592,9 +592,9 @@ static int do_proc_douintvec_conv(unsigned long *lvalp,
 	if (write) {
 		if (*lvalp > UINT_MAX)
 			return -EINVAL;
-		*valp = *lvalp;
+		WRITE_ONCE(*valp, *lvalp);
 	} else {
-		unsigned int val = *valp;
+		unsigned int val = READ_ONCE(*valp);
 		*lvalp = (unsigned long)val;
 	}
 	return 0;
@@ -988,7 +988,7 @@ static int do_proc_dointvec_minmax_conv(bool *negp, unsigned long *lvalp,
 		if ((param->min && *param->min > tmp) ||
 		    (param->max && *param->max < tmp))
 			return -EINVAL;
-		*valp = tmp;
+		WRITE_ONCE(*valp, tmp);
 	}
 
 	return 0;
@@ -1054,7 +1054,7 @@ static int do_proc_douintvec_minmax_conv(unsigned long *lvalp,
 		    (param->max && *param->max < tmp))
 			return -ERANGE;
 
-		*valp = tmp;
+		WRITE_ONCE(*valp, tmp);
 	}
 
 	return 0;
@@ -1138,13 +1138,13 @@ int proc_dou8vec_minmax(struct ctl_table *table, int write,
 
 	tmp.maxlen = sizeof(val);
 	tmp.data = &val;
-	val = *data;
+	val = READ_ONCE(*data);
 	res = do_proc_douintvec(&tmp, write, buffer, lenp, ppos,
 				do_proc_douintvec_minmax_conv, &param);
 	if (res)
 		return res;
 	if (write)
-		*data = val;
+		WRITE_ONCE(*data, val);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(proc_dou8vec_minmax);
@@ -1281,9 +1281,9 @@ static int __do_proc_doulongvec_minmax(void *data, struct ctl_table *table,
 				err = -EINVAL;
 				break;
 			}
-			*i = val;
+			WRITE_ONCE(*i, val);
 		} else {
-			val = convdiv * (*i) / convmul;
+			val = convdiv * READ_ONCE(*i) / convmul;
 			if (!first)
 				proc_put_char(&buffer, &left, '\t');
 			proc_put_long(&buffer, &left, val, false);
@@ -1364,9 +1364,12 @@ static int do_proc_dointvec_jiffies_conv(bool *negp, unsigned long *lvalp,
 	if (write) {
 		if (*lvalp > INT_MAX / HZ)
 			return 1;
-		*valp = *negp ? -(*lvalp*HZ) : (*lvalp*HZ);
+		if (*negp)
+			WRITE_ONCE(*valp, -*lvalp * HZ);
+		else
+			WRITE_ONCE(*valp, *lvalp * HZ);
 	} else {
-		int val = *valp;
+		int val = READ_ONCE(*valp);
 		unsigned long lval;
 		if (val < 0) {
 			*negp = true;
@@ -1412,9 +1415,9 @@ static int do_proc_dointvec_ms_jiffies_conv(bool *negp, unsigned long *lvalp,
 
 		if (jif > INT_MAX)
 			return 1;
-		*valp = (int)jif;
+		WRITE_ONCE(*valp, (int)jif);
 	} else {
-		int val = *valp;
+		int val = READ_ONCE(*valp);
 		unsigned long lval;
 		if (val < 0) {
 			*negp = true;
@@ -1482,8 +1485,8 @@ int proc_dointvec_userhz_jiffies(struct ctl_table *table, int write,
  * @ppos: the current position in the file
  *
  * Reads/writes up to table->maxlen/sizeof(unsigned int) integer
- * values from/to the user buffer, treated as an ASCII string. 
- * The values read are assumed to be in 1/1000 seconds, and 
+ * values from/to the user buffer, treated as an ASCII string.
+ * The values read are assumed to be in 1/1000 seconds, and
  * are converted into jiffies.
  *
  * Returns 0 on success.
@@ -2849,6 +2852,17 @@ static struct ctl_table vm_table[] = {
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= &two_hundred,
 	},
+#ifdef CONFIG_NUMA
+	{
+		.procname	= "numa_stat",
+		.data		= &sysctl_vm_numa_stat,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= sysctl_vm_numa_stat_handler,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
+#endif
 #ifdef CONFIG_HUGETLB_PAGE
 	{
 		.procname	= "nr_hugepages",
@@ -2865,15 +2879,6 @@ static struct ctl_table vm_table[] = {
 		.mode           = 0644,
 		.proc_handler   = &hugetlb_mempolicy_sysctl_handler,
 	},
-	{
-		.procname		= "numa_stat",
-		.data			= &sysctl_vm_numa_stat,
-		.maxlen			= sizeof(int),
-		.mode			= 0644,
-		.proc_handler	= sysctl_vm_numa_stat_handler,
-		.extra1			= SYSCTL_ZERO,
-		.extra2			= SYSCTL_ONE,
-	},
 #endif
 	 {
 		.procname	= "hugetlb_shm_group",
diff --git a/kernel/time/posix-timers.c b/kernel/time/posix-timers.c
index 1cd10b102c51..5dead89308b7 100644
--- a/kernel/time/posix-timers.c
+++ b/kernel/time/posix-timers.c
@@ -1051,15 +1051,24 @@ static void itimer_delete(struct k_itimer *timer)
 }
 
 /*
- * This is called by do_exit or de_thread, only when there are no more
- * references to the shared signal_struct.
+ * This is called by do_exit or de_thread, only when nobody else can
+ * modify the signal->posix_timers list. Yet we need sighand->siglock
+ * to prevent the race with /proc/pid/timers.
  */
-void exit_itimers(struct signal_struct *sig)
+void exit_itimers(struct task_struct *tsk)
 {
+	struct list_head timers;
 	struct k_itimer *tmr;
 
-	while (!list_empty(&sig->posix_timers)) {
-		tmr = list_entry(sig->posix_timers.next, struct k_itimer, list);
+	if (list_empty(&tsk->signal->posix_timers))
+		return;
+
+	spin_lock_irq(&tsk->sighand->siglock);
+	list_replace_init(&tsk->signal->posix_timers, &timers);
+	spin_unlock_irq(&tsk->sighand->siglock);
+
+	while (!list_empty(&timers)) {
+		tmr = list_first_entry(&timers, struct k_itimer, list);
 		itimer_delete(tmr);
 	}
 }
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 518ce39a878d..f752f2574630 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -9831,6 +9831,12 @@ void trace_init_global_iter(struct trace_iterator *iter)
 	/* Output in nanoseconds only if we are using a clock in nanoseconds. */
 	if (trace_clocks[iter->tr->clock_id].in_ns)
 		iter->iter_flags |= TRACE_FILE_TIME_IN_NS;
+
+	/* Can not use kmalloc for iter.temp and iter.fmt */
+	iter->temp = static_temp_buf;
+	iter->temp_size = STATIC_TEMP_BUF_SIZE;
+	iter->fmt = static_fmt_buf;
+	iter->fmt_size = STATIC_FMT_BUF_SIZE;
 }
 
 void ftrace_dump(enum ftrace_dump_mode oops_dump_mode)
@@ -9863,11 +9869,6 @@ void ftrace_dump(enum ftrace_dump_mode oops_dump_mode)
 
 	/* Simulate the iterator */
 	trace_init_global_iter(&iter);
-	/* Can not use kmalloc for iter.temp and iter.fmt */
-	iter.temp = static_temp_buf;
-	iter.temp_size = STATIC_TEMP_BUF_SIZE;
-	iter.fmt = static_fmt_buf;
-	iter.fmt_size = STATIC_FMT_BUF_SIZE;
 
 	for_each_tracing_cpu(cpu) {
 		atomic_inc(&per_cpu_ptr(iter.array_buffer->data, cpu)->disabled);
diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index 45a78e9c65c9..d5c7b9a37ed5 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -4056,6 +4056,8 @@ static int parse_var_defs(struct hist_trigger_data *hist_data)
 
 			s = kstrdup(field_str, GFP_KERNEL);
 			if (!s) {
+				kfree(hist_data->attrs->var_defs.name[n_vars]);
+				hist_data->attrs->var_defs.name[n_vars] = NULL;
 				ret = -ENOMEM;
 				goto free;
 			}
diff --git a/mm/memory.c b/mm/memory.c
index 26d115ded4ab..036eb765c4e8 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4487,6 +4487,19 @@ static inline vm_fault_t wp_huge_pmd(struct vm_fault *vmf)
 
 static vm_fault_t create_huge_pud(struct vm_fault *vmf)
 {
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE) &&			\
+	defined(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
+	/* No support for anonymous transparent PUD pages yet */
+	if (vma_is_anonymous(vmf->vma))
+		return VM_FAULT_FALLBACK;
+	if (vmf->vma->vm_ops->huge_fault)
+		return vmf->vma->vm_ops->huge_fault(vmf, PE_SIZE_PUD);
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
+	return VM_FAULT_FALLBACK;
+}
+
+static vm_fault_t wp_huge_pud(struct vm_fault *vmf, pud_t orig_pud)
+{
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) &&			\
 	defined(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
 	/* No support for anonymous transparent PUD pages yet */
@@ -4501,19 +4514,7 @@ static vm_fault_t create_huge_pud(struct vm_fault *vmf)
 split:
 	/* COW or write-notify not handled on PUD level: split pud.*/
 	__split_huge_pud(vmf->vma, vmf->pud, vmf->address);
-#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
-	return VM_FAULT_FALLBACK;
-}
-
-static vm_fault_t wp_huge_pud(struct vm_fault *vmf, pud_t orig_pud)
-{
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	/* No support for anonymous transparent PUD pages yet */
-	if (vma_is_anonymous(vmf->vma))
-		return VM_FAULT_FALLBACK;
-	if (vmf->vma->vm_ops->huge_fault)
-		return vmf->vma->vm_ops->huge_fault(vmf, PE_SIZE_PUD);
-#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE && CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
 	return VM_FAULT_FALLBACK;
 }
 
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index c9bab48856c6..3bbaf5f5353e 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -227,7 +227,10 @@ static int mcontinue_atomic_pte(struct mm_struct *dst_mm,
 	struct page *page;
 	int ret;
 
-	ret = shmem_getpage(inode, pgoff, &page, SGP_READ);
+	ret = shmem_getpage(inode, pgoff, &page, SGP_NOALLOC);
+	/* Our caller expects us to return -EFAULT if we failed to find page. */
+	if (ret == -ENOENT)
+		ret = -EFAULT;
 	if (ret)
 		goto out;
 	if (!page) {
diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index 68c0d0f92890..10a2c7bca719 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -1012,9 +1012,24 @@ int br_nf_hook_thresh(unsigned int hook, struct net *net,
 		return okfn(net, sk, skb);
 
 	ops = nf_hook_entries_get_hook_ops(e);
-	for (i = 0; i < e->num_hook_entries &&
-	      ops[i]->priority <= NF_BR_PRI_BRNF; i++)
-		;
+	for (i = 0; i < e->num_hook_entries; i++) {
+		/* These hooks have already been called */
+		if (ops[i]->priority < NF_BR_PRI_BRNF)
+			continue;
+
+		/* These hooks have not been called yet, run them. */
+		if (ops[i]->priority > NF_BR_PRI_BRNF)
+			break;
+
+		/* take a closer look at NF_BR_PRI_BRNF. */
+		if (ops[i]->hook == br_nf_pre_routing) {
+			/* This hook diverted the skb to this function,
+			 * hooks after this have not been run yet.
+			 */
+			i++;
+			break;
+		}
+	}
 
 	nf_hook_state_init(&state, hook, NFPROTO_BRIDGE, indev, outdev,
 			   sk, net, okfn);
diff --git a/net/core/filter.c b/net/core/filter.c
index d1e2ef77ce4c..8b2bc855714b 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5851,7 +5851,6 @@ static int bpf_push_seg6_encap(struct sk_buff *skb, u32 type, void *hdr, u32 len
 	if (err)
 		return err;
 
-	ipv6_hdr(skb)->payload_len = htons(skb->len - sizeof(struct ipv6hdr));
 	skb_set_transport_header(skb, sizeof(struct ipv6hdr));
 
 	return seg6_lookup_nexthop(skb, NULL, 0);
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 77534b44b8c7..44f21278003d 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1251,7 +1251,7 @@ static int inet_sk_reselect_saddr(struct sock *sk)
 	if (new_saddr == old_saddr)
 		return 0;
 
-	if (sock_net(sk)->ipv4.sysctl_ip_dynaddr > 1) {
+	if (READ_ONCE(sock_net(sk)->ipv4.sysctl_ip_dynaddr) > 1) {
 		pr_info("%s(): shifting inet->saddr from %pI4 to %pI4\n",
 			__func__, &old_saddr, &new_saddr);
 	}
@@ -1306,7 +1306,7 @@ int inet_sk_rebuild_header(struct sock *sk)
 		 * Other protocols have to map its equivalent state to TCP_SYN_SENT.
 		 * DCCP maps its DCCP_REQUESTING state to TCP_SYN_SENT. -acme
 		 */
-		if (!sock_net(sk)->ipv4.sysctl_ip_dynaddr ||
+		if (!READ_ONCE(sock_net(sk)->ipv4.sysctl_ip_dynaddr) ||
 		    sk->sk_state != TCP_SYN_SENT ||
 		    (sk->sk_userlocks & SOCK_BINDADDR_LOCK) ||
 		    (err = inet_sk_reselect_saddr(sk)) != 0)
diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
index 099259fc826a..75ac14525344 100644
--- a/net/ipv4/cipso_ipv4.c
+++ b/net/ipv4/cipso_ipv4.c
@@ -239,7 +239,7 @@ static int cipso_v4_cache_check(const unsigned char *key,
 	struct cipso_v4_map_cache_entry *prev_entry = NULL;
 	u32 hash;
 
-	if (!cipso_v4_cache_enabled)
+	if (!READ_ONCE(cipso_v4_cache_enabled))
 		return -ENOENT;
 
 	hash = cipso_v4_map_cache_hash(key, key_len);
@@ -296,13 +296,14 @@ static int cipso_v4_cache_check(const unsigned char *key,
 int cipso_v4_cache_add(const unsigned char *cipso_ptr,
 		       const struct netlbl_lsm_secattr *secattr)
 {
+	int bkt_size = READ_ONCE(cipso_v4_cache_bucketsize);
 	int ret_val = -EPERM;
 	u32 bkt;
 	struct cipso_v4_map_cache_entry *entry = NULL;
 	struct cipso_v4_map_cache_entry *old_entry = NULL;
 	u32 cipso_ptr_len;
 
-	if (!cipso_v4_cache_enabled || cipso_v4_cache_bucketsize <= 0)
+	if (!READ_ONCE(cipso_v4_cache_enabled) || bkt_size <= 0)
 		return 0;
 
 	cipso_ptr_len = cipso_ptr[1];
@@ -322,7 +323,7 @@ int cipso_v4_cache_add(const unsigned char *cipso_ptr,
 
 	bkt = entry->hash & (CIPSO_V4_CACHE_BUCKETS - 1);
 	spin_lock_bh(&cipso_v4_cache[bkt].lock);
-	if (cipso_v4_cache[bkt].size < cipso_v4_cache_bucketsize) {
+	if (cipso_v4_cache[bkt].size < bkt_size) {
 		list_add(&entry->list, &cipso_v4_cache[bkt].list);
 		cipso_v4_cache[bkt].size += 1;
 	} else {
@@ -1199,7 +1200,8 @@ static int cipso_v4_gentag_rbm(const struct cipso_v4_doi *doi_def,
 		/* This will send packets using the "optimized" format when
 		 * possible as specified in  section 3.4.2.6 of the
 		 * CIPSO draft. */
-		if (cipso_v4_rbm_optfmt && ret_val > 0 && ret_val <= 10)
+		if (READ_ONCE(cipso_v4_rbm_optfmt) && ret_val > 0 &&
+		    ret_val <= 10)
 			tag_len = 14;
 		else
 			tag_len = 4 + ret_val;
@@ -1603,7 +1605,7 @@ int cipso_v4_validate(const struct sk_buff *skb, unsigned char **option)
 			 * all the CIPSO validations here but it doesn't
 			 * really specify _exactly_ what we need to validate
 			 * ... so, just make it a sysctl tunable. */
-			if (cipso_v4_rbm_strictvalid) {
+			if (READ_ONCE(cipso_v4_rbm_strictvalid)) {
 				if (cipso_v4_map_lvl_valid(doi_def,
 							   tag[3]) < 0) {
 					err_offset = opt_iter + 3;
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index b5563f5ff176..674694d8ac61 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -1228,7 +1228,7 @@ static int fib_check_nh_nongw(struct net *net, struct fib_nh *nh,
 
 	nh->fib_nh_dev = in_dev->dev;
 	dev_hold(nh->fib_nh_dev);
-	nh->fib_nh_scope = RT_SCOPE_HOST;
+	nh->fib_nh_scope = RT_SCOPE_LINK;
 	if (!netif_carrier_ok(nh->fib_nh_dev))
 		nh->fib_nh_flags |= RTNH_F_LINKDOWN;
 	err = 0;
@@ -1829,7 +1829,7 @@ int fib_dump_info(struct sk_buff *skb, u32 portid, u32 seq, int event,
 			goto nla_put_failure;
 		if (nexthop_is_blackhole(fi->nh))
 			rtm->rtm_type = RTN_BLACKHOLE;
-		if (!fi->fib_net->ipv4.sysctl_nexthop_compat_mode)
+		if (!READ_ONCE(fi->fib_net->ipv4.sysctl_nexthop_compat_mode))
 			goto offload;
 	}
 
diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index f7f74d5c14da..a9cd9c2bd84e 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -497,7 +497,7 @@ static void tnode_free(struct key_vector *tn)
 		tn = container_of(head, struct tnode, rcu)->kv;
 	}
 
-	if (tnode_free_size >= sysctl_fib_sync_mem) {
+	if (tnode_free_size >= READ_ONCE(sysctl_fib_sync_mem)) {
 		tnode_free_size = 0;
 		synchronize_rcu();
 	}
diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index b7e277d8a84d..a5cc89506c1e 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -261,11 +261,12 @@ bool icmp_global_allow(void)
 	spin_lock(&icmp_global.lock);
 	delta = min_t(u32, now - icmp_global.stamp, HZ);
 	if (delta >= HZ / 50) {
-		incr = sysctl_icmp_msgs_per_sec * delta / HZ ;
+		incr = READ_ONCE(sysctl_icmp_msgs_per_sec) * delta / HZ;
 		if (incr)
 			WRITE_ONCE(icmp_global.stamp, now);
 	}
-	credit = min_t(u32, icmp_global.credit + incr, sysctl_icmp_msgs_burst);
+	credit = min_t(u32, icmp_global.credit + incr,
+		       READ_ONCE(sysctl_icmp_msgs_burst));
 	if (credit) {
 		/* We want to use a credit of one in average, but need to randomize
 		 * it for security reasons.
@@ -289,7 +290,7 @@ static bool icmpv4_mask_allow(struct net *net, int type, int code)
 		return true;
 
 	/* Limit if icmp type is enabled in ratemask. */
-	if (!((1 << type) & net->ipv4.sysctl_icmp_ratemask))
+	if (!((1 << type) & READ_ONCE(net->ipv4.sysctl_icmp_ratemask)))
 		return true;
 
 	return false;
@@ -327,7 +328,8 @@ static bool icmpv4_xrlim_allow(struct net *net, struct rtable *rt,
 
 	vif = l3mdev_master_ifindex(dst->dev);
 	peer = inet_getpeer_v4(net->ipv4.peers, fl4->daddr, vif, 1);
-	rc = inet_peer_xrlim_allow(peer, net->ipv4.sysctl_icmp_ratelimit);
+	rc = inet_peer_xrlim_allow(peer,
+				   READ_ONCE(net->ipv4.sysctl_icmp_ratelimit));
 	if (peer)
 		inet_putpeer(peer);
 out:
@@ -701,7 +703,7 @@ void __icmp_send(struct sk_buff *skb_in, int type, int code, __be32 info,
 
 		rcu_read_lock();
 		if (rt_is_input_route(rt) &&
-		    net->ipv4.sysctl_icmp_errors_use_inbound_ifaddr)
+		    READ_ONCE(net->ipv4.sysctl_icmp_errors_use_inbound_ifaddr))
 			dev = dev_get_by_index_rcu(net, inet_iif(skb_in));
 
 		if (dev)
@@ -938,7 +940,7 @@ static bool icmp_unreach(struct sk_buff *skb)
 	 *	get the other vendor to fix their kit.
 	 */
 
-	if (!net->ipv4.sysctl_icmp_ignore_bogus_error_responses &&
+	if (!READ_ONCE(net->ipv4.sysctl_icmp_ignore_bogus_error_responses) &&
 	    inet_addr_type_dev_table(net, skb->dev, iph->daddr) == RTN_BROADCAST) {
 		net_warn_ratelimited("%pI4 sent an invalid ICMP type %u, code %u error to a broadcast: %pI4 on %s\n",
 				     &ip_hdr(skb)->saddr,
@@ -1033,7 +1035,7 @@ bool icmp_build_probe(struct sk_buff *skb, struct icmphdr *icmphdr)
 	u16 ident_len;
 	u8 status;
 
-	if (!net->ipv4.sysctl_icmp_echo_enable_probe)
+	if (!READ_ONCE(net->ipv4.sysctl_icmp_echo_enable_probe))
 		return false;
 
 	/* We currently only support probing interfaces on the proxy node
diff --git a/net/ipv4/inetpeer.c b/net/ipv4/inetpeer.c
index da21dfce24d7..e9fed83e9b3c 100644
--- a/net/ipv4/inetpeer.c
+++ b/net/ipv4/inetpeer.c
@@ -141,16 +141,20 @@ static void inet_peer_gc(struct inet_peer_base *base,
 			 struct inet_peer *gc_stack[],
 			 unsigned int gc_cnt)
 {
+	int peer_threshold, peer_maxttl, peer_minttl;
 	struct inet_peer *p;
 	__u32 delta, ttl;
 	int i;
 
-	if (base->total >= inet_peer_threshold)
+	peer_threshold = READ_ONCE(inet_peer_threshold);
+	peer_maxttl = READ_ONCE(inet_peer_maxttl);
+	peer_minttl = READ_ONCE(inet_peer_minttl);
+
+	if (base->total >= peer_threshold)
 		ttl = 0; /* be aggressive */
 	else
-		ttl = inet_peer_maxttl
-				- (inet_peer_maxttl - inet_peer_minttl) / HZ *
-					base->total / inet_peer_threshold * HZ;
+		ttl = peer_maxttl - (peer_maxttl - peer_minttl) / HZ *
+			base->total / peer_threshold * HZ;
 	for (i = 0; i < gc_cnt; i++) {
 		p = gc_stack[i];
 
diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 5dbd4b5505eb..cc8f120149f6 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -1857,7 +1857,7 @@ static void __remove_nexthop_fib(struct net *net, struct nexthop *nh)
 		/* __ip6_del_rt does a release, so do a hold here */
 		fib6_info_hold(f6i);
 		ipv6_stub->ip6_del_rt(net, f6i,
-				      !net->ipv4.sysctl_nexthop_compat_mode);
+				      !READ_ONCE(net->ipv4.sysctl_nexthop_compat_mode));
 	}
 }
 
@@ -2362,7 +2362,8 @@ static int insert_nexthop(struct net *net, struct nexthop *new_nh,
 	if (!rc) {
 		nh_base_seq_inc(net);
 		nexthop_notify(RTM_NEWNEXTHOP, new_nh, &cfg->nlinfo);
-		if (replace_notify && net->ipv4.sysctl_nexthop_compat_mode)
+		if (replace_notify &&
+		    READ_ONCE(net->ipv4.sysctl_nexthop_compat_mode))
 			nexthop_replace_notify(net, new_nh, &cfg->nlinfo);
 	}
 
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 6f1e64d49232..616658e7c796 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -639,6 +639,8 @@ static struct ctl_table ipv4_net_table[] = {
 		.maxlen		= sizeof(u8),
 		.mode		= 0644,
 		.proc_handler	= proc_dou8vec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE
 	},
 	{
 		.procname	= "icmp_errors_use_inbound_ifaddr",
@@ -646,6 +648,8 @@ static struct ctl_table ipv4_net_table[] = {
 		.maxlen		= sizeof(u8),
 		.mode		= 0644,
 		.proc_handler	= proc_dou8vec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE
 	},
 	{
 		.procname	= "icmp_ratelimit",
@@ -692,6 +696,8 @@ static struct ctl_table ipv4_net_table[] = {
 		.maxlen		= sizeof(u8),
 		.mode		= 0644,
 		.proc_handler	= proc_dou8vec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
 	},
 	{
 		.procname	= "ip_dynaddr",
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index f79b5a98888c..4ac53c8f0583 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2714,7 +2714,8 @@ static void tcp_orphan_update(struct timer_list *unused)
 
 static bool tcp_too_many_orphans(int shift)
 {
-	return READ_ONCE(tcp_orphan_cache) << shift > sysctl_tcp_max_orphans;
+	return READ_ONCE(tcp_orphan_cache) << shift >
+		READ_ONCE(sysctl_tcp_max_orphans);
 }
 
 bool tcp_check_oom(struct sock *sk, int shift)
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index dc3b4668fcde..509aab1b7ac9 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -346,7 +346,7 @@ static void tcp_ecn_send_syn(struct sock *sk, struct sk_buff *skb)
 
 static void tcp_ecn_clear_syn(struct sock *sk, struct sk_buff *skb)
 {
-	if (sock_net(sk)->ipv4.sysctl_tcp_ecn_fallback)
+	if (READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_ecn_fallback))
 		/* tp->ecn_flags are cleared at a later point in time when
 		 * SYN ACK is ultimatively being received.
 		 */
diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index 96c5cc0f30ce..716e7717fe8f 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -927,7 +927,7 @@ static int icmpv6_rcv(struct sk_buff *skb)
 		break;
 	case ICMPV6_EXT_ECHO_REQUEST:
 		if (!net->ipv6.sysctl.icmpv6_echo_ignore_all &&
-		    net->ipv4.sysctl_icmp_echo_enable_probe)
+		    READ_ONCE(net->ipv4.sysctl_icmp_echo_enable_probe))
 			icmpv6_echo_reply(skb);
 		break;
 
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 4ca754c360a3..27274fc3619a 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5756,7 +5756,7 @@ static int rt6_fill_node(struct net *net, struct sk_buff *skb,
 		if (nexthop_is_blackhole(rt->nh))
 			rtm->rtm_type = RTN_BLACKHOLE;
 
-		if (net->ipv4.sysctl_nexthop_compat_mode &&
+		if (READ_ONCE(net->ipv4.sysctl_nexthop_compat_mode) &&
 		    rt6_fill_node_nexthop(skb, rt->nh, &nh_flags) < 0)
 			goto nla_put_failure;
 
diff --git a/net/ipv6/seg6_iptunnel.c b/net/ipv6/seg6_iptunnel.c
index d64855010948..e756ba705fd9 100644
--- a/net/ipv6/seg6_iptunnel.c
+++ b/net/ipv6/seg6_iptunnel.c
@@ -189,6 +189,8 @@ int seg6_do_srh_encap(struct sk_buff *skb, struct ipv6_sr_hdr *osrh, int proto)
 	}
 #endif
 
+	hdr->payload_len = htons(skb->len - sizeof(struct ipv6hdr));
+
 	skb_postpush_rcsum(skb, hdr, tot_len);
 
 	return 0;
@@ -241,6 +243,8 @@ int seg6_do_srh_inline(struct sk_buff *skb, struct ipv6_sr_hdr *osrh)
 	}
 #endif
 
+	hdr->payload_len = htons(skb->len - sizeof(struct ipv6hdr));
+
 	skb_postpush_rcsum(skb, hdr, sizeof(struct ipv6hdr) + hdrlen);
 
 	return 0;
@@ -302,7 +306,6 @@ static int seg6_do_srh(struct sk_buff *skb)
 		break;
 	}
 
-	ipv6_hdr(skb)->payload_len = htons(skb->len - sizeof(struct ipv6hdr));
 	skb_set_transport_header(skb, sizeof(struct ipv6hdr));
 	nf_reset_ct(skb);
 
diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
index ef88489c71f5..59454285d5c5 100644
--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -824,7 +824,6 @@ static int input_action_end_b6(struct sk_buff *skb, struct seg6_local_lwt *slwt)
 	if (err)
 		goto drop;
 
-	ipv6_hdr(skb)->payload_len = htons(skb->len - sizeof(struct ipv6hdr));
 	skb_set_transport_header(skb, sizeof(struct ipv6hdr));
 
 	seg6_lookup_nexthop(skb, NULL, 0);
@@ -856,7 +855,6 @@ static int input_action_end_b6_encap(struct sk_buff *skb,
 	if (err)
 		goto drop;
 
-	ipv6_hdr(skb)->payload_len = htons(skb->len - sizeof(struct ipv6hdr));
 	skb_set_transport_header(skb, sizeof(struct ipv6hdr));
 
 	seg6_lookup_nexthop(skb, NULL, 0);
diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index 62c6733e0792..d50480b31750 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -147,8 +147,8 @@ u16 __ieee80211_select_queue(struct ieee80211_sub_if_data *sdata,
 	bool qos;
 
 	/* all mesh/ocb stations are required to support WME */
-	if (sdata->vif.type == NL80211_IFTYPE_MESH_POINT ||
-	    sdata->vif.type == NL80211_IFTYPE_OCB)
+	if (sta && (sdata->vif.type == NL80211_IFTYPE_MESH_POINT ||
+		    sdata->vif.type == NL80211_IFTYPE_OCB))
 		qos = true;
 	else if (sta)
 		qos = sta->sta.wme;
diff --git a/net/netfilter/nf_log_syslog.c b/net/netfilter/nf_log_syslog.c
index 13234641cdb3..7000e069bc07 100644
--- a/net/netfilter/nf_log_syslog.c
+++ b/net/netfilter/nf_log_syslog.c
@@ -61,7 +61,7 @@ dump_arp_packet(struct nf_log_buf *m,
 	unsigned int logflags;
 	struct arphdr _arph;
 
-	ah = skb_header_pointer(skb, 0, sizeof(_arph), &_arph);
+	ah = skb_header_pointer(skb, nhoff, sizeof(_arph), &_arph);
 	if (!ah) {
 		nf_log_buf_add(m, "TRUNCATED");
 		return;
@@ -90,7 +90,7 @@ dump_arp_packet(struct nf_log_buf *m,
 	    ah->ar_pln != sizeof(__be32))
 		return;
 
-	ap = skb_header_pointer(skb, sizeof(_arph), sizeof(_arpp), &_arpp);
+	ap = skb_header_pointer(skb, nhoff + sizeof(_arph), sizeof(_arpp), &_arpp);
 	if (!ap) {
 		nf_log_buf_add(m, " INCOMPLETE [%zu bytes]",
 			       skb->len - sizeof(_arph));
@@ -144,7 +144,7 @@ static void nf_log_arp_packet(struct net *net, u_int8_t pf,
 
 	nf_log_dump_packet_common(m, pf, hooknum, skb, in, out, loginfo,
 				  prefix);
-	dump_arp_packet(m, loginfo, skb, 0);
+	dump_arp_packet(m, loginfo, skb, skb_network_offset(skb));
 
 	nf_log_buf_close(m);
 }
@@ -829,7 +829,7 @@ static void nf_log_ip_packet(struct net *net, u_int8_t pf,
 	if (in)
 		dump_ipv4_mac_header(m, loginfo, skb);
 
-	dump_ipv4_packet(net, m, loginfo, skb, 0);
+	dump_ipv4_packet(net, m, loginfo, skb, skb_network_offset(skb));
 
 	nf_log_buf_close(m);
 }
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 65d96439e2be..a32acf056e32 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5736,8 +5736,11 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	if (!nla[NFTA_SET_ELEM_KEY] && !(flags & NFT_SET_ELEM_CATCHALL))
 		return -EINVAL;
 
-	if (flags != 0)
-		nft_set_ext_add(&tmpl, NFT_SET_EXT_FLAGS);
+	if (flags != 0) {
+		err = nft_set_ext_add(&tmpl, NFT_SET_EXT_FLAGS);
+		if (err < 0)
+			return err;
+	}
 
 	if (set->flags & NFT_SET_MAP) {
 		if (nla[NFTA_SET_ELEM_DATA] == NULL &&
@@ -5846,7 +5849,9 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		if (err < 0)
 			goto err_set_elem_expr;
 
-		nft_set_ext_add_length(&tmpl, NFT_SET_EXT_KEY, set->klen);
+		err = nft_set_ext_add_length(&tmpl, NFT_SET_EXT_KEY, set->klen);
+		if (err < 0)
+			goto err_parse_key;
 	}
 
 	if (nla[NFTA_SET_ELEM_KEY_END]) {
@@ -5855,22 +5860,31 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		if (err < 0)
 			goto err_parse_key;
 
-		nft_set_ext_add_length(&tmpl, NFT_SET_EXT_KEY_END, set->klen);
+		err = nft_set_ext_add_length(&tmpl, NFT_SET_EXT_KEY_END, set->klen);
+		if (err < 0)
+			goto err_parse_key_end;
 	}
 
 	if (timeout > 0) {
-		nft_set_ext_add(&tmpl, NFT_SET_EXT_EXPIRATION);
-		if (timeout != set->timeout)
-			nft_set_ext_add(&tmpl, NFT_SET_EXT_TIMEOUT);
+		err = nft_set_ext_add(&tmpl, NFT_SET_EXT_EXPIRATION);
+		if (err < 0)
+			goto err_parse_key_end;
+
+		if (timeout != set->timeout) {
+			err = nft_set_ext_add(&tmpl, NFT_SET_EXT_TIMEOUT);
+			if (err < 0)
+				goto err_parse_key_end;
+		}
 	}
 
 	if (num_exprs) {
 		for (i = 0; i < num_exprs; i++)
 			size += expr_array[i]->ops->size;
 
-		nft_set_ext_add_length(&tmpl, NFT_SET_EXT_EXPRESSIONS,
-				       sizeof(struct nft_set_elem_expr) +
-				       size);
+		err = nft_set_ext_add_length(&tmpl, NFT_SET_EXT_EXPRESSIONS,
+					     sizeof(struct nft_set_elem_expr) + size);
+		if (err < 0)
+			goto err_parse_key_end;
 	}
 
 	if (nla[NFTA_SET_ELEM_OBJREF] != NULL) {
@@ -5885,7 +5899,9 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			err = PTR_ERR(obj);
 			goto err_parse_key_end;
 		}
-		nft_set_ext_add(&tmpl, NFT_SET_EXT_OBJREF);
+		err = nft_set_ext_add(&tmpl, NFT_SET_EXT_OBJREF);
+		if (err < 0)
+			goto err_parse_key_end;
 	}
 
 	if (nla[NFTA_SET_ELEM_DATA] != NULL) {
@@ -5919,7 +5935,9 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 							  NFT_VALIDATE_NEED);
 		}
 
-		nft_set_ext_add_length(&tmpl, NFT_SET_EXT_DATA, desc.len);
+		err = nft_set_ext_add_length(&tmpl, NFT_SET_EXT_DATA, desc.len);
+		if (err < 0)
+			goto err_parse_data;
 	}
 
 	/* The full maximum length of userdata can exceed the maximum
@@ -5929,9 +5947,12 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	ulen = 0;
 	if (nla[NFTA_SET_ELEM_USERDATA] != NULL) {
 		ulen = nla_len(nla[NFTA_SET_ELEM_USERDATA]);
-		if (ulen > 0)
-			nft_set_ext_add_length(&tmpl, NFT_SET_EXT_USERDATA,
-					       ulen);
+		if (ulen > 0) {
+			err = nft_set_ext_add_length(&tmpl, NFT_SET_EXT_USERDATA,
+						     ulen);
+			if (err < 0)
+				goto err_parse_data;
+		}
 	}
 
 	err = -ENOMEM;
@@ -6157,8 +6178,11 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 
 	nft_set_ext_prepare(&tmpl);
 
-	if (flags != 0)
-		nft_set_ext_add(&tmpl, NFT_SET_EXT_FLAGS);
+	if (flags != 0) {
+		err = nft_set_ext_add(&tmpl, NFT_SET_EXT_FLAGS);
+		if (err < 0)
+			return err;
+	}
 
 	if (nla[NFTA_SET_ELEM_KEY]) {
 		err = nft_setelem_parse_key(ctx, set, &elem.key.val,
@@ -6166,16 +6190,20 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 		if (err < 0)
 			return err;
 
-		nft_set_ext_add_length(&tmpl, NFT_SET_EXT_KEY, set->klen);
+		err = nft_set_ext_add_length(&tmpl, NFT_SET_EXT_KEY, set->klen);
+		if (err < 0)
+			goto fail_elem;
 	}
 
 	if (nla[NFTA_SET_ELEM_KEY_END]) {
 		err = nft_setelem_parse_key(ctx, set, &elem.key_end.val,
 					    nla[NFTA_SET_ELEM_KEY_END]);
 		if (err < 0)
-			return err;
+			goto fail_elem;
 
-		nft_set_ext_add_length(&tmpl, NFT_SET_EXT_KEY_END, set->klen);
+		err = nft_set_ext_add_length(&tmpl, NFT_SET_EXT_KEY_END, set->klen);
+		if (err < 0)
+			goto fail_elem_key_end;
 	}
 
 	err = -ENOMEM;
@@ -6183,7 +6211,7 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 				      elem.key_end.val.data, NULL, 0, 0,
 				      GFP_KERNEL);
 	if (elem.priv == NULL)
-		goto fail_elem;
+		goto fail_elem_key_end;
 
 	ext = nft_set_elem_ext(set, elem.priv);
 	if (flags)
@@ -6207,6 +6235,8 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 	kfree(trans);
 fail_trans:
 	kfree(elem.priv);
+fail_elem_key_end:
+	nft_data_release(&elem.key_end.val, NFT_DATA_VALUE);
 fail_elem:
 	nft_data_release(&elem.key.val, NFT_DATA_VALUE);
 	return err;
diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 17f8c523e33b..43509c7e90fc 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -502,6 +502,7 @@ static int tipc_sk_create(struct net *net, struct socket *sock,
 	sock_init_data(sock, sk);
 	tipc_set_sk_state(sk, TIPC_OPEN);
 	if (tipc_sk_insert(tsk)) {
+		sk_free(sk);
 		pr_warn("Socket create failed; port number exhausted\n");
 		return -EINVAL;
 	}
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index f3e3d009cf1c..4775431cbd38 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -1394,9 +1394,9 @@ static struct notifier_block tls_dev_notifier = {
 	.notifier_call	= tls_dev_event,
 };
 
-void __init tls_device_init(void)
+int __init tls_device_init(void)
 {
-	register_netdevice_notifier(&tls_dev_notifier);
+	return register_netdevice_notifier(&tls_dev_notifier);
 }
 
 void __exit tls_device_cleanup(void)
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 62b1c5e32bbd..a947cfb100bd 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -910,7 +910,12 @@ static int __init tls_register(void)
 	if (err)
 		return err;
 
-	tls_device_init();
+	err = tls_device_init();
+	if (err) {
+		unregister_pernet_subsys(&tls_proc_ops);
+		return err;
+	}
+
 	tcp_register_ulp(&tcp_tls_ulp_ops);
 
 	return 0;
diff --git a/security/integrity/evm/evm_crypto.c b/security/integrity/evm/evm_crypto.c
index 0450d79afdc8..b862f0f919bf 100644
--- a/security/integrity/evm/evm_crypto.c
+++ b/security/integrity/evm/evm_crypto.c
@@ -75,7 +75,7 @@ static struct shash_desc *init_desc(char type, uint8_t hash_algo)
 {
 	long rc;
 	const char *algo;
-	struct crypto_shash **tfm, *tmp_tfm = NULL;
+	struct crypto_shash **tfm, *tmp_tfm;
 	struct shash_desc *desc;
 
 	if (type == EVM_XATTR_HMAC) {
@@ -120,16 +120,13 @@ static struct shash_desc *init_desc(char type, uint8_t hash_algo)
 alloc:
 	desc = kmalloc(sizeof(*desc) + crypto_shash_descsize(*tfm),
 			GFP_KERNEL);
-	if (!desc) {
-		crypto_free_shash(tmp_tfm);
+	if (!desc)
 		return ERR_PTR(-ENOMEM);
-	}
 
 	desc->tfm = *tfm;
 
 	rc = crypto_shash_init(desc);
 	if (rc) {
-		crypto_free_shash(tmp_tfm);
 		kfree(desc);
 		return ERR_PTR(rc);
 	}
diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index dbba51583e7c..ed04bb7c7512 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -408,7 +408,8 @@ int ima_appraise_measurement(enum ima_hooks func,
 		goto out;
 	}
 
-	status = evm_verifyxattr(dentry, XATTR_NAME_IMA, xattr_value, rc, iint);
+	status = evm_verifyxattr(dentry, XATTR_NAME_IMA, xattr_value,
+				 rc < 0 ? 0 : rc, iint);
 	switch (status) {
 	case INTEGRITY_PASS:
 	case INTEGRITY_PASS_IMMUTABLE:
diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
index a7206cc1d7d1..64499056648a 100644
--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -205,6 +205,7 @@ int __init ima_init_crypto(void)
 
 		crypto_free_shash(ima_algo_array[i].tfm);
 	}
+	kfree(ima_algo_array);
 out:
 	crypto_free_shash(ima_shash_tfm);
 	return rc;
diff --git a/security/integrity/ima/ima_efi.c b/security/integrity/ima/ima_efi.c
index 71786d01946f..9db66fe310d4 100644
--- a/security/integrity/ima/ima_efi.c
+++ b/security/integrity/ima/ima_efi.c
@@ -67,6 +67,8 @@ const char * const *arch_get_ima_policy(void)
 	if (IS_ENABLED(CONFIG_IMA_ARCH_POLICY) && arch_ima_get_secureboot()) {
 		if (IS_ENABLED(CONFIG_MODULE_SIG))
 			set_module_sig_enforced();
+		if (IS_ENABLED(CONFIG_KEXEC_SIG))
+			set_kexec_sig_enforced();
 		return sb_arch_rules;
 	}
 	return NULL;
diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index 0b7d500249f6..8c68e6e1387e 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -944,6 +944,7 @@ static const struct snd_pci_quirk cxt5066_fixups[] = {
 	SND_PCI_QUIRK(0x103c, 0x828c, "HP EliteBook 840 G4", CXT_FIXUP_HP_DOCK),
 	SND_PCI_QUIRK(0x103c, 0x8299, "HP 800 G3 SFF", CXT_FIXUP_HP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x829a, "HP 800 G3 DM", CXT_FIXUP_HP_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x103c, 0x82b4, "HP ProDesk 600 G3", CXT_FIXUP_HP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x836e, "HP ProBook 455 G5", CXT_FIXUP_MUTE_LED_GPIO),
 	SND_PCI_QUIRK(0x103c, 0x837f, "HP ProBook 470 G5", CXT_FIXUP_MUTE_LED_GPIO),
 	SND_PCI_QUIRK(0x103c, 0x83b2, "HP EliteBook 840 G5", CXT_FIXUP_HP_DOCK),
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 3c3eac2399da..f3fa35b302ce 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6780,6 +6780,7 @@ enum {
 	ALC298_FIXUP_LENOVO_SPK_VOLUME,
 	ALC256_FIXUP_DELL_INSPIRON_7559_SUBWOOFER,
 	ALC269_FIXUP_ATIV_BOOK_8,
+	ALC221_FIXUP_HP_288PRO_MIC_NO_PRESENCE,
 	ALC221_FIXUP_HP_MIC_NO_PRESENCE,
 	ALC256_FIXUP_ASUS_HEADSET_MODE,
 	ALC256_FIXUP_ASUS_MIC,
@@ -7707,6 +7708,16 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chained = true,
 		.chain_id = ALC269_FIXUP_NO_SHUTUP
 	},
+	[ALC221_FIXUP_HP_288PRO_MIC_NO_PRESENCE] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x19, 0x01a1913c }, /* use as headset mic, without its own jack detect */
+			{ 0x1a, 0x01813030 }, /* use as headphone mic, without its own jack detect */
+			{ }
+		},
+		.chained = true,
+		.chain_id = ALC269_FIXUP_HEADSET_MODE
+	},
 	[ALC221_FIXUP_HP_MIC_NO_PRESENCE] = {
 		.type = HDA_FIXUP_PINS,
 		.v.pins = (const struct hda_pintbl[]) {
@@ -8695,6 +8706,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1025, 0x1290, "Acer Veriton Z4860G", ALC286_FIXUP_ACER_AIO_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x1291, "Acer Veriton Z4660G", ALC286_FIXUP_ACER_AIO_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x129c, "Acer SWIFT SF314-55", ALC256_FIXUP_ACER_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1025, 0x129d, "Acer SWIFT SF313-51", ALC256_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x1300, "Acer SWIFT SF314-56", ALC256_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x1308, "Acer Aspire Z24-890", ALC286_FIXUP_ACER_AIO_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x132a, "Acer TravelMate B114-21", ALC233_FIXUP_ACER_HEADSET_MIC),
@@ -8704,6 +8716,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1025, 0x1430, "Acer TravelMate B311R-31", ALC256_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x1466, "Acer Aspire A515-56", ALC255_FIXUP_ACER_HEADPHONE_AND_MIC),
 	SND_PCI_QUIRK(0x1028, 0x0470, "Dell M101z", ALC269_FIXUP_DELL_M101Z),
+	SND_PCI_QUIRK(0x1028, 0x053c, "Dell Latitude E5430", ALC292_FIXUP_DELL_E7X),
 	SND_PCI_QUIRK(0x1028, 0x054b, "Dell XPS one 2710", ALC275_FIXUP_DELL_XPS),
 	SND_PCI_QUIRK(0x1028, 0x05bd, "Dell Latitude E6440", ALC292_FIXUP_DELL_E7X),
 	SND_PCI_QUIRK(0x1028, 0x05be, "Dell Latitude E6540", ALC292_FIXUP_DELL_E7X),
@@ -8818,6 +8831,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x2335, "HP", ALC269_FIXUP_HP_MUTE_LED_MIC1),
 	SND_PCI_QUIRK(0x103c, 0x2336, "HP", ALC269_FIXUP_HP_MUTE_LED_MIC1),
 	SND_PCI_QUIRK(0x103c, 0x2337, "HP", ALC269_FIXUP_HP_MUTE_LED_MIC1),
+	SND_PCI_QUIRK(0x103c, 0x2b5e, "HP 288 Pro G2 MT", ALC221_FIXUP_HP_288PRO_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x802e, "HP Z240 SFF", ALC221_FIXUP_HP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x802f, "HP Z240", ALC221_FIXUP_HP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x8077, "HP", ALC256_FIXUP_HP_HEADSET_MIC),
@@ -8885,6 +8899,10 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x89c3, "HP", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x89ca, "HP", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8a78, "HP Dev One", ALC285_FIXUP_HP_LIMIT_INT_MIC_BOOST),
+	SND_PCI_QUIRK(0x103c, 0x8aa0, "HP ProBook 440 G9 (MB 8A9E)", ALC236_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8aa3, "HP ProBook 450 G9 (MB 8AA1)", ALC236_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8aa8, "HP EliteBook 640 G9 (MB 8AA6)", ALC236_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8aab, "HP EliteBook 650 G9 (MB 8AA9)", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x1043, 0x103e, "ASUS X540SA", ALC256_FIXUP_ASUS_MIC),
 	SND_PCI_QUIRK(0x1043, 0x103f, "ASUS TX300", ALC282_FIXUP_ASUS_TX300),
 	SND_PCI_QUIRK(0x1043, 0x106d, "Asus K53BE", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
@@ -9140,6 +9158,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1d72, 0x1602, "RedmiBook", ALC255_FIXUP_XIAOMI_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d72, 0x1701, "XiaomiNotebook Pro", ALC298_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1d72, 0x1901, "RedmiBook 14", ALC256_FIXUP_ASUS_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1d72, 0x1945, "Redmi G", ALC256_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d72, 0x1947, "RedmiBook Air", ALC255_FIXUP_XIAOMI_HEADSET_MIC),
 	SND_PCI_QUIRK(0x8086, 0x2074, "Intel NUC 8", ALC233_FIXUP_INTEL_NUC8_DMIC),
 	SND_PCI_QUIRK(0x8086, 0x2080, "Intel NUC 8 Rugged", ALC256_FIXUP_INTEL_NUC8_RUGGED),
@@ -11001,6 +11020,7 @@ static const struct snd_pci_quirk alc662_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x1632, "HP RP5800", ALC662_FIXUP_HP_RP5800),
 	SND_PCI_QUIRK(0x103c, 0x8719, "HP", ALC897_FIXUP_HP_HSMIC_VERB),
 	SND_PCI_QUIRK(0x103c, 0x873e, "HP", ALC671_FIXUP_HP_HEADSET_MIC2),
+	SND_PCI_QUIRK(0x103c, 0x877e, "HP 288 Pro G6", ALC671_FIXUP_HP_HEADSET_MIC2),
 	SND_PCI_QUIRK(0x103c, 0x885f, "HP 288 Pro G8", ALC671_FIXUP_HP_HEADSET_MIC2),
 	SND_PCI_QUIRK(0x1043, 0x1080, "Asus UX501VW", ALC668_FIXUP_HEADSET_MODE),
 	SND_PCI_QUIRK(0x1043, 0x11cd, "Asus N550", ALC662_FIXUP_ASUS_Nx50),
diff --git a/sound/soc/codecs/cs47l15.c b/sound/soc/codecs/cs47l15.c
index 1ee83160b83f..ac9ccdea15b5 100644
--- a/sound/soc/codecs/cs47l15.c
+++ b/sound/soc/codecs/cs47l15.c
@@ -122,6 +122,9 @@ static int cs47l15_in1_adc_put(struct snd_kcontrol *kcontrol,
 		snd_soc_kcontrol_component(kcontrol);
 	struct cs47l15 *cs47l15 = snd_soc_component_get_drvdata(component);
 
+	if (!!ucontrol->value.integer.value[0] == cs47l15->in1_lp_mode)
+		return 0;
+
 	switch (ucontrol->value.integer.value[0]) {
 	case 0:
 		/* Set IN1 to normal mode */
@@ -150,7 +153,7 @@ static int cs47l15_in1_adc_put(struct snd_kcontrol *kcontrol,
 		break;
 	}
 
-	return 0;
+	return 1;
 }
 
 static const struct snd_kcontrol_new cs47l15_snd_controls[] = {
diff --git a/sound/soc/codecs/madera.c b/sound/soc/codecs/madera.c
index f4ed7e04673f..fd4fa1d5d2d1 100644
--- a/sound/soc/codecs/madera.c
+++ b/sound/soc/codecs/madera.c
@@ -618,7 +618,13 @@ int madera_out1_demux_put(struct snd_kcontrol *kcontrol,
 end:
 	snd_soc_dapm_mutex_unlock(dapm);
 
-	return snd_soc_dapm_mux_update_power(dapm, kcontrol, mux, e, NULL);
+	ret = snd_soc_dapm_mux_update_power(dapm, kcontrol, mux, e, NULL);
+	if (ret < 0) {
+		dev_err(madera->dev, "Failed to update demux power state: %d\n", ret);
+		return ret;
+	}
+
+	return change;
 }
 EXPORT_SYMBOL_GPL(madera_out1_demux_put);
 
@@ -893,7 +899,7 @@ static int madera_adsp_rate_put(struct snd_kcontrol *kcontrol,
 	struct soc_enum *e = (struct soc_enum *)kcontrol->private_value;
 	const int adsp_num = e->shift_l;
 	const unsigned int item = ucontrol->value.enumerated.item[0];
-	int ret;
+	int ret = 0;
 
 	if (item >= e->items)
 		return -EINVAL;
@@ -910,10 +916,10 @@ static int madera_adsp_rate_put(struct snd_kcontrol *kcontrol,
 			 "Cannot change '%s' while in use by active audio paths\n",
 			 kcontrol->id.name);
 		ret = -EBUSY;
-	} else {
+	} else if (priv->adsp_rate_cache[adsp_num] != e->values[item]) {
 		/* Volatile register so defer until the codec is powered up */
 		priv->adsp_rate_cache[adsp_num] = e->values[item];
-		ret = 0;
+		ret = 1;
 	}
 
 	mutex_unlock(&priv->rate_lock);
diff --git a/sound/soc/codecs/max98373-sdw.c b/sound/soc/codecs/max98373-sdw.c
index dc520effc61c..12323d4b5bfa 100644
--- a/sound/soc/codecs/max98373-sdw.c
+++ b/sound/soc/codecs/max98373-sdw.c
@@ -862,6 +862,16 @@ static int max98373_sdw_probe(struct sdw_slave *slave,
 	return max98373_init(slave, regmap);
 }
 
+static int max98373_sdw_remove(struct sdw_slave *slave)
+{
+	struct max98373_priv *max98373 = dev_get_drvdata(&slave->dev);
+
+	if (max98373->first_hw_init)
+		pm_runtime_disable(&slave->dev);
+
+	return 0;
+}
+
 #if defined(CONFIG_OF)
 static const struct of_device_id max98373_of_match[] = {
 	{ .compatible = "maxim,max98373", },
@@ -893,7 +903,7 @@ static struct sdw_driver max98373_sdw_driver = {
 		.pm = &max98373_pm,
 	},
 	.probe = max98373_sdw_probe,
-	.remove = NULL,
+	.remove = max98373_sdw_remove,
 	.ops = &max98373_slave_ops,
 	.id_table = max98373_id,
 };
diff --git a/sound/soc/codecs/rt1308-sdw.c b/sound/soc/codecs/rt1308-sdw.c
index f716668de640..8472d855c325 100644
--- a/sound/soc/codecs/rt1308-sdw.c
+++ b/sound/soc/codecs/rt1308-sdw.c
@@ -683,6 +683,16 @@ static int rt1308_sdw_probe(struct sdw_slave *slave,
 	return 0;
 }
 
+static int rt1308_sdw_remove(struct sdw_slave *slave)
+{
+	struct rt1308_sdw_priv *rt1308 = dev_get_drvdata(&slave->dev);
+
+	if (rt1308->first_hw_init)
+		pm_runtime_disable(&slave->dev);
+
+	return 0;
+}
+
 static const struct sdw_device_id rt1308_id[] = {
 	SDW_SLAVE_ENTRY_EXT(0x025d, 0x1308, 0x2, 0, 0),
 	{},
@@ -742,6 +752,7 @@ static struct sdw_driver rt1308_sdw_driver = {
 		.pm = &rt1308_pm,
 	},
 	.probe = rt1308_sdw_probe,
+	.remove = rt1308_sdw_remove,
 	.ops = &rt1308_slave_ops,
 	.id_table = rt1308_id,
 };
diff --git a/sound/soc/codecs/rt1316-sdw.c b/sound/soc/codecs/rt1316-sdw.c
index 09b4914bba1b..09cf3ca86fa4 100644
--- a/sound/soc/codecs/rt1316-sdw.c
+++ b/sound/soc/codecs/rt1316-sdw.c
@@ -675,6 +675,16 @@ static int rt1316_sdw_probe(struct sdw_slave *slave,
 	return rt1316_sdw_init(&slave->dev, regmap, slave);
 }
 
+static int rt1316_sdw_remove(struct sdw_slave *slave)
+{
+	struct rt1316_sdw_priv *rt1316 = dev_get_drvdata(&slave->dev);
+
+	if (rt1316->first_hw_init)
+		pm_runtime_disable(&slave->dev);
+
+	return 0;
+}
+
 static const struct sdw_device_id rt1316_id[] = {
 	SDW_SLAVE_ENTRY_EXT(0x025d, 0x1316, 0x3, 0x1, 0),
 	{},
@@ -734,6 +744,7 @@ static struct sdw_driver rt1316_sdw_driver = {
 		.pm = &rt1316_pm,
 	},
 	.probe = rt1316_sdw_probe,
+	.remove = rt1316_sdw_remove,
 	.ops = &rt1316_slave_ops,
 	.id_table = rt1316_id,
 };
diff --git a/sound/soc/codecs/rt5682-sdw.c b/sound/soc/codecs/rt5682-sdw.c
index 31a4f286043e..a030c9987b92 100644
--- a/sound/soc/codecs/rt5682-sdw.c
+++ b/sound/soc/codecs/rt5682-sdw.c
@@ -719,9 +719,12 @@ static int rt5682_sdw_remove(struct sdw_slave *slave)
 {
 	struct rt5682_priv *rt5682 = dev_get_drvdata(&slave->dev);
 
-	if (rt5682 && rt5682->hw_init)
+	if (rt5682->hw_init)
 		cancel_delayed_work_sync(&rt5682->jack_detect_work);
 
+	if (rt5682->first_hw_init)
+		pm_runtime_disable(&slave->dev);
+
 	return 0;
 }
 
diff --git a/sound/soc/codecs/rt700-sdw.c b/sound/soc/codecs/rt700-sdw.c
index bda594899664..f7439e40ca8b 100644
--- a/sound/soc/codecs/rt700-sdw.c
+++ b/sound/soc/codecs/rt700-sdw.c
@@ -13,6 +13,7 @@
 #include <linux/soundwire/sdw_type.h>
 #include <linux/soundwire/sdw_registers.h>
 #include <linux/module.h>
+#include <linux/pm_runtime.h>
 #include <linux/regmap.h>
 #include <sound/soc.h>
 #include "rt700.h"
@@ -463,11 +464,14 @@ static int rt700_sdw_remove(struct sdw_slave *slave)
 {
 	struct rt700_priv *rt700 = dev_get_drvdata(&slave->dev);
 
-	if (rt700 && rt700->hw_init) {
+	if (rt700->hw_init) {
 		cancel_delayed_work_sync(&rt700->jack_detect_work);
 		cancel_delayed_work_sync(&rt700->jack_btn_check_work);
 	}
 
+	if (rt700->first_hw_init)
+		pm_runtime_disable(&slave->dev);
+
 	return 0;
 }
 
diff --git a/sound/soc/codecs/rt700.c b/sound/soc/codecs/rt700.c
index 614a40247679..e049d672ccfd 100644
--- a/sound/soc/codecs/rt700.c
+++ b/sound/soc/codecs/rt700.c
@@ -162,7 +162,7 @@ static void rt700_jack_detect_handler(struct work_struct *work)
 	if (!rt700->hs_jack)
 		return;
 
-	if (!rt700->component->card->instantiated)
+	if (!rt700->component->card || !rt700->component->card->instantiated)
 		return;
 
 	reg = RT700_VERB_GET_PIN_SENSE | RT700_HP_OUT;
@@ -1124,6 +1124,11 @@ int rt700_init(struct device *dev, struct regmap *sdw_regmap,
 
 	mutex_init(&rt700->disable_irq_lock);
 
+	INIT_DELAYED_WORK(&rt700->jack_detect_work,
+			  rt700_jack_detect_handler);
+	INIT_DELAYED_WORK(&rt700->jack_btn_check_work,
+			  rt700_btn_check_handler);
+
 	/*
 	 * Mark hw_init to false
 	 * HW init will be performed when device reports present
@@ -1218,13 +1223,6 @@ int rt700_io_init(struct device *dev, struct sdw_slave *slave)
 	/* Finish Initial Settings, set power to D3 */
 	regmap_write(rt700->regmap, RT700_SET_AUDIO_POWER_STATE, AC_PWRST_D3);
 
-	if (!rt700->first_hw_init) {
-		INIT_DELAYED_WORK(&rt700->jack_detect_work,
-			rt700_jack_detect_handler);
-		INIT_DELAYED_WORK(&rt700->jack_btn_check_work,
-			rt700_btn_check_handler);
-	}
-
 	/*
 	 * if set_jack callback occurred early than io_init,
 	 * we set up the jack detection function now
diff --git a/sound/soc/codecs/rt711-sdca-sdw.c b/sound/soc/codecs/rt711-sdca-sdw.c
index aaf5af153d3f..a085b2f530aa 100644
--- a/sound/soc/codecs/rt711-sdca-sdw.c
+++ b/sound/soc/codecs/rt711-sdca-sdw.c
@@ -11,6 +11,7 @@
 #include <linux/mod_devicetable.h>
 #include <linux/soundwire/sdw_registers.h>
 #include <linux/module.h>
+#include <linux/pm_runtime.h>
 
 #include "rt711-sdca.h"
 #include "rt711-sdca-sdw.h"
@@ -364,11 +365,17 @@ static int rt711_sdca_sdw_remove(struct sdw_slave *slave)
 {
 	struct rt711_sdca_priv *rt711 = dev_get_drvdata(&slave->dev);
 
-	if (rt711 && rt711->hw_init) {
+	if (rt711->hw_init) {
 		cancel_delayed_work_sync(&rt711->jack_detect_work);
 		cancel_delayed_work_sync(&rt711->jack_btn_check_work);
 	}
 
+	if (rt711->first_hw_init)
+		pm_runtime_disable(&slave->dev);
+
+	mutex_destroy(&rt711->calibrate_mutex);
+	mutex_destroy(&rt711->disable_irq_lock);
+
 	return 0;
 }
 
diff --git a/sound/soc/codecs/rt711-sdca.c b/sound/soc/codecs/rt711-sdca.c
index c15fb98eac86..3b5df3ea2f60 100644
--- a/sound/soc/codecs/rt711-sdca.c
+++ b/sound/soc/codecs/rt711-sdca.c
@@ -34,7 +34,7 @@ static int rt711_sdca_index_write(struct rt711_sdca_priv *rt711,
 
 	ret = regmap_write(regmap, addr, value);
 	if (ret < 0)
-		dev_err(rt711->component->dev,
+		dev_err(&rt711->slave->dev,
 			"Failed to set private value: %06x <= %04x ret=%d\n",
 			addr, value, ret);
 
@@ -50,7 +50,7 @@ static int rt711_sdca_index_read(struct rt711_sdca_priv *rt711,
 
 	ret = regmap_read(regmap, addr, value);
 	if (ret < 0)
-		dev_err(rt711->component->dev,
+		dev_err(&rt711->slave->dev,
 			"Failed to get private value: %06x => %04x ret=%d\n",
 			addr, *value, ret);
 
@@ -294,7 +294,7 @@ static void rt711_sdca_jack_detect_handler(struct work_struct *work)
 	if (!rt711->hs_jack)
 		return;
 
-	if (!rt711->component->card->instantiated)
+	if (!rt711->component->card || !rt711->component->card->instantiated)
 		return;
 
 	/* SDW_SCP_SDCA_INT_SDCA_0 is used for jack detection */
@@ -1414,8 +1414,12 @@ int rt711_sdca_init(struct device *dev, struct regmap *regmap,
 	rt711->regmap = regmap;
 	rt711->mbq_regmap = mbq_regmap;
 
+	mutex_init(&rt711->calibrate_mutex);
 	mutex_init(&rt711->disable_irq_lock);
 
+	INIT_DELAYED_WORK(&rt711->jack_detect_work, rt711_sdca_jack_detect_handler);
+	INIT_DELAYED_WORK(&rt711->jack_btn_check_work, rt711_sdca_btn_check_handler);
+
 	/*
 	 * Mark hw_init to false
 	 * HW init will be performed when device reports present
@@ -1547,14 +1551,6 @@ int rt711_sdca_io_init(struct device *dev, struct sdw_slave *slave)
 	rt711_sdca_index_update_bits(rt711, RT711_VENDOR_HDA_CTL,
 		RT711_PUSH_BTN_INT_CTL0, 0x20, 0x00);
 
-	if (!rt711->first_hw_init) {
-		INIT_DELAYED_WORK(&rt711->jack_detect_work,
-			rt711_sdca_jack_detect_handler);
-		INIT_DELAYED_WORK(&rt711->jack_btn_check_work,
-			rt711_sdca_btn_check_handler);
-		mutex_init(&rt711->calibrate_mutex);
-	}
-
 	/* calibration */
 	ret = rt711_sdca_calibration(rt711);
 	if (ret < 0)
diff --git a/sound/soc/codecs/rt711-sdw.c b/sound/soc/codecs/rt711-sdw.c
index bda2cc9439c9..4fe68bcf2a7c 100644
--- a/sound/soc/codecs/rt711-sdw.c
+++ b/sound/soc/codecs/rt711-sdw.c
@@ -13,6 +13,7 @@
 #include <linux/soundwire/sdw_type.h>
 #include <linux/soundwire/sdw_registers.h>
 #include <linux/module.h>
+#include <linux/pm_runtime.h>
 #include <linux/regmap.h>
 #include <sound/soc.h>
 #include "rt711.h"
@@ -464,12 +465,18 @@ static int rt711_sdw_remove(struct sdw_slave *slave)
 {
 	struct rt711_priv *rt711 = dev_get_drvdata(&slave->dev);
 
-	if (rt711 && rt711->hw_init) {
+	if (rt711->hw_init) {
 		cancel_delayed_work_sync(&rt711->jack_detect_work);
 		cancel_delayed_work_sync(&rt711->jack_btn_check_work);
 		cancel_work_sync(&rt711->calibration_work);
 	}
 
+	if (rt711->first_hw_init)
+		pm_runtime_disable(&slave->dev);
+
+	mutex_destroy(&rt711->calibrate_mutex);
+	mutex_destroy(&rt711->disable_irq_lock);
+
 	return 0;
 }
 
diff --git a/sound/soc/codecs/rt711.c b/sound/soc/codecs/rt711.c
index fafb0ba8349f..51a98e730fc8 100644
--- a/sound/soc/codecs/rt711.c
+++ b/sound/soc/codecs/rt711.c
@@ -242,7 +242,7 @@ static void rt711_jack_detect_handler(struct work_struct *work)
 	if (!rt711->hs_jack)
 		return;
 
-	if (!rt711->component->card->instantiated)
+	if (!rt711->component->card || !rt711->component->card->instantiated)
 		return;
 
 	reg = RT711_VERB_GET_PIN_SENSE | RT711_HP_OUT;
@@ -1199,8 +1199,13 @@ int rt711_init(struct device *dev, struct regmap *sdw_regmap,
 	rt711->sdw_regmap = sdw_regmap;
 	rt711->regmap = regmap;
 
+	mutex_init(&rt711->calibrate_mutex);
 	mutex_init(&rt711->disable_irq_lock);
 
+	INIT_DELAYED_WORK(&rt711->jack_detect_work, rt711_jack_detect_handler);
+	INIT_DELAYED_WORK(&rt711->jack_btn_check_work, rt711_btn_check_handler);
+	INIT_WORK(&rt711->calibration_work, rt711_calibration_work);
+
 	/*
 	 * Mark hw_init to false
 	 * HW init will be performed when device reports present
@@ -1308,15 +1313,8 @@ int rt711_io_init(struct device *dev, struct sdw_slave *slave)
 
 	if (rt711->first_hw_init)
 		rt711_calibration(rt711);
-	else {
-		INIT_DELAYED_WORK(&rt711->jack_detect_work,
-			rt711_jack_detect_handler);
-		INIT_DELAYED_WORK(&rt711->jack_btn_check_work,
-			rt711_btn_check_handler);
-		mutex_init(&rt711->calibrate_mutex);
-		INIT_WORK(&rt711->calibration_work, rt711_calibration_work);
+	else
 		schedule_work(&rt711->calibration_work);
-	}
 
 	/*
 	 * if set_jack callback occurred early than io_init,
diff --git a/sound/soc/codecs/rt715-sdca-sdw.c b/sound/soc/codecs/rt715-sdca-sdw.c
index a5c673f43d82..0f4354eafef2 100644
--- a/sound/soc/codecs/rt715-sdca-sdw.c
+++ b/sound/soc/codecs/rt715-sdca-sdw.c
@@ -13,6 +13,7 @@
 #include <linux/soundwire/sdw_type.h>
 #include <linux/soundwire/sdw_registers.h>
 #include <linux/module.h>
+#include <linux/pm_runtime.h>
 #include <linux/regmap.h>
 #include <sound/soc.h>
 #include "rt715-sdca.h"
@@ -195,6 +196,16 @@ static int rt715_sdca_sdw_probe(struct sdw_slave *slave,
 	return rt715_sdca_init(&slave->dev, mbq_regmap, regmap, slave);
 }
 
+static int rt715_sdca_sdw_remove(struct sdw_slave *slave)
+{
+	struct rt715_sdca_priv *rt715 = dev_get_drvdata(&slave->dev);
+
+	if (rt715->first_hw_init)
+		pm_runtime_disable(&slave->dev);
+
+	return 0;
+}
+
 static const struct sdw_device_id rt715_sdca_id[] = {
 	SDW_SLAVE_ENTRY_EXT(0x025d, 0x715, 0x3, 0x1, 0),
 	SDW_SLAVE_ENTRY_EXT(0x025d, 0x714, 0x3, 0x1, 0),
@@ -269,6 +280,7 @@ static struct sdw_driver rt715_sdw_driver = {
 		.pm = &rt715_pm,
 	},
 	.probe = rt715_sdca_sdw_probe,
+	.remove = rt715_sdca_sdw_remove,
 	.ops = &rt715_sdca_slave_ops,
 	.id_table = rt715_sdca_id,
 };
diff --git a/sound/soc/codecs/rt715-sdw.c b/sound/soc/codecs/rt715-sdw.c
index a7b21b03c08b..b047bf87a100 100644
--- a/sound/soc/codecs/rt715-sdw.c
+++ b/sound/soc/codecs/rt715-sdw.c
@@ -14,6 +14,7 @@
 #include <linux/soundwire/sdw_type.h>
 #include <linux/soundwire/sdw_registers.h>
 #include <linux/module.h>
+#include <linux/pm_runtime.h>
 #include <linux/of.h>
 #include <linux/regmap.h>
 #include <sound/soc.h>
@@ -514,6 +515,16 @@ static int rt715_sdw_probe(struct sdw_slave *slave,
 	return 0;
 }
 
+static int rt715_sdw_remove(struct sdw_slave *slave)
+{
+	struct rt715_priv *rt715 = dev_get_drvdata(&slave->dev);
+
+	if (rt715->first_hw_init)
+		pm_runtime_disable(&slave->dev);
+
+	return 0;
+}
+
 static const struct sdw_device_id rt715_id[] = {
 	SDW_SLAVE_ENTRY_EXT(0x025d, 0x714, 0x2, 0, 0),
 	SDW_SLAVE_ENTRY_EXT(0x025d, 0x715, 0x2, 0, 0),
@@ -575,6 +586,7 @@ static struct sdw_driver rt715_sdw_driver = {
 		   .pm = &rt715_pm,
 		   },
 	.probe = rt715_sdw_probe,
+	.remove = rt715_sdw_remove,
 	.ops = &rt715_slave_ops,
 	.id_table = rt715_id,
 };
diff --git a/sound/soc/codecs/sgtl5000.c b/sound/soc/codecs/sgtl5000.c
index 97bf1f222805..dc56e6c6b668 100644
--- a/sound/soc/codecs/sgtl5000.c
+++ b/sound/soc/codecs/sgtl5000.c
@@ -1797,6 +1797,9 @@ static int sgtl5000_i2c_remove(struct i2c_client *client)
 {
 	struct sgtl5000_priv *sgtl5000 = i2c_get_clientdata(client);
 
+	regmap_write(sgtl5000->regmap, SGTL5000_CHIP_DIG_POWER, SGTL5000_DIG_POWER_DEFAULT);
+	regmap_write(sgtl5000->regmap, SGTL5000_CHIP_ANA_POWER, SGTL5000_ANA_POWER_DEFAULT);
+
 	clk_disable_unprepare(sgtl5000->mclk);
 	regulator_bulk_disable(sgtl5000->num_supplies, sgtl5000->supplies);
 	regulator_bulk_free(sgtl5000->num_supplies, sgtl5000->supplies);
@@ -1804,6 +1807,11 @@ static int sgtl5000_i2c_remove(struct i2c_client *client)
 	return 0;
 }
 
+static void sgtl5000_i2c_shutdown(struct i2c_client *client)
+{
+	sgtl5000_i2c_remove(client);
+}
+
 static const struct i2c_device_id sgtl5000_id[] = {
 	{"sgtl5000", 0},
 	{},
@@ -1824,6 +1832,7 @@ static struct i2c_driver sgtl5000_i2c_driver = {
 	},
 	.probe = sgtl5000_i2c_probe,
 	.remove = sgtl5000_i2c_remove,
+	.shutdown = sgtl5000_i2c_shutdown,
 	.id_table = sgtl5000_id,
 };
 
diff --git a/sound/soc/codecs/sgtl5000.h b/sound/soc/codecs/sgtl5000.h
index 56ec5863f250..3a808c762299 100644
--- a/sound/soc/codecs/sgtl5000.h
+++ b/sound/soc/codecs/sgtl5000.h
@@ -80,6 +80,7 @@
 /*
  * SGTL5000_CHIP_DIG_POWER
  */
+#define SGTL5000_DIG_POWER_DEFAULT		0x0000
 #define SGTL5000_ADC_EN				0x0040
 #define SGTL5000_DAC_EN				0x0020
 #define SGTL5000_DAP_POWERUP			0x0010
diff --git a/sound/soc/codecs/tas2764.c b/sound/soc/codecs/tas2764.c
index 9265af41c235..ec13ba01e522 100644
--- a/sound/soc/codecs/tas2764.c
+++ b/sound/soc/codecs/tas2764.c
@@ -42,10 +42,12 @@ static void tas2764_reset(struct tas2764_priv *tas2764)
 		gpiod_set_value_cansleep(tas2764->reset_gpio, 0);
 		msleep(20);
 		gpiod_set_value_cansleep(tas2764->reset_gpio, 1);
+		usleep_range(1000, 2000);
 	}
 
 	snd_soc_component_write(tas2764->component, TAS2764_SW_RST,
 				TAS2764_RST);
+	usleep_range(1000, 2000);
 }
 
 static int tas2764_set_bias_level(struct snd_soc_component *component,
@@ -107,8 +109,10 @@ static int tas2764_codec_resume(struct snd_soc_component *component)
 	struct tas2764_priv *tas2764 = snd_soc_component_get_drvdata(component);
 	int ret;
 
-	if (tas2764->sdz_gpio)
+	if (tas2764->sdz_gpio) {
 		gpiod_set_value_cansleep(tas2764->sdz_gpio, 1);
+		usleep_range(1000, 2000);
+	}
 
 	ret = snd_soc_component_update_bits(component, TAS2764_PWR_CTRL,
 					    TAS2764_PWR_CTRL_MASK,
@@ -131,7 +135,8 @@ static const char * const tas2764_ASI1_src[] = {
 };
 
 static SOC_ENUM_SINGLE_DECL(
-	tas2764_ASI1_src_enum, TAS2764_TDM_CFG2, 4, tas2764_ASI1_src);
+	tas2764_ASI1_src_enum, TAS2764_TDM_CFG2, TAS2764_TDM_CFG2_SCFG_SHIFT,
+	tas2764_ASI1_src);
 
 static const struct snd_kcontrol_new tas2764_asi1_mux =
 	SOC_DAPM_ENUM("ASI1 Source", tas2764_ASI1_src_enum);
@@ -329,20 +334,22 @@ static int tas2764_set_fmt(struct snd_soc_dai *dai, unsigned int fmt)
 {
 	struct snd_soc_component *component = dai->component;
 	struct tas2764_priv *tas2764 = snd_soc_component_get_drvdata(component);
-	u8 tdm_rx_start_slot = 0, asi_cfg_1 = 0;
-	int iface;
+	u8 tdm_rx_start_slot = 0, asi_cfg_0 = 0, asi_cfg_1 = 0;
 	int ret;
 
 	switch (fmt & SND_SOC_DAIFMT_INV_MASK) {
+	case SND_SOC_DAIFMT_NB_IF:
+		asi_cfg_0 ^= TAS2764_TDM_CFG0_FRAME_START;
+		fallthrough;
 	case SND_SOC_DAIFMT_NB_NF:
 		asi_cfg_1 = TAS2764_TDM_CFG1_RX_RISING;
 		break;
+	case SND_SOC_DAIFMT_IB_IF:
+		asi_cfg_0 ^= TAS2764_TDM_CFG0_FRAME_START;
+		fallthrough;
 	case SND_SOC_DAIFMT_IB_NF:
 		asi_cfg_1 = TAS2764_TDM_CFG1_RX_FALLING;
 		break;
-	default:
-		dev_err(tas2764->dev, "ASI format Inverse is not found\n");
-		return -EINVAL;
 	}
 
 	ret = snd_soc_component_update_bits(component, TAS2764_TDM_CFG1,
@@ -353,13 +360,13 @@ static int tas2764_set_fmt(struct snd_soc_dai *dai, unsigned int fmt)
 
 	switch (fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
 	case SND_SOC_DAIFMT_I2S:
+		asi_cfg_0 ^= TAS2764_TDM_CFG0_FRAME_START;
+		fallthrough;
 	case SND_SOC_DAIFMT_DSP_A:
-		iface = TAS2764_TDM_CFG2_SCFG_I2S;
 		tdm_rx_start_slot = 1;
 		break;
 	case SND_SOC_DAIFMT_DSP_B:
 	case SND_SOC_DAIFMT_LEFT_J:
-		iface = TAS2764_TDM_CFG2_SCFG_LEFT_J;
 		tdm_rx_start_slot = 0;
 		break;
 	default:
@@ -368,14 +375,15 @@ static int tas2764_set_fmt(struct snd_soc_dai *dai, unsigned int fmt)
 		return -EINVAL;
 	}
 
-	ret = snd_soc_component_update_bits(component, TAS2764_TDM_CFG1,
-					    TAS2764_TDM_CFG1_MASK,
-					    (tdm_rx_start_slot << TAS2764_TDM_CFG1_51_SHIFT));
+	ret = snd_soc_component_update_bits(component, TAS2764_TDM_CFG0,
+					    TAS2764_TDM_CFG0_FRAME_START,
+					    asi_cfg_0);
 	if (ret < 0)
 		return ret;
 
-	ret = snd_soc_component_update_bits(component, TAS2764_TDM_CFG2,
-					    TAS2764_TDM_CFG2_SCFG_MASK, iface);
+	ret = snd_soc_component_update_bits(component, TAS2764_TDM_CFG1,
+					    TAS2764_TDM_CFG1_MASK,
+					    (tdm_rx_start_slot << TAS2764_TDM_CFG1_51_SHIFT));
 	if (ret < 0)
 		return ret;
 
@@ -501,8 +509,10 @@ static int tas2764_codec_probe(struct snd_soc_component *component)
 
 	tas2764->component = component;
 
-	if (tas2764->sdz_gpio)
+	if (tas2764->sdz_gpio) {
 		gpiod_set_value_cansleep(tas2764->sdz_gpio, 1);
+		usleep_range(1000, 2000);
+	}
 
 	tas2764_reset(tas2764);
 
@@ -526,12 +536,12 @@ static int tas2764_codec_probe(struct snd_soc_component *component)
 }
 
 static DECLARE_TLV_DB_SCALE(tas2764_digital_tlv, 1100, 50, 0);
-static DECLARE_TLV_DB_SCALE(tas2764_playback_volume, -10000, 50, 0);
+static DECLARE_TLV_DB_SCALE(tas2764_playback_volume, -10050, 50, 1);
 
 static const struct snd_kcontrol_new tas2764_snd_controls[] = {
 	SOC_SINGLE_TLV("Speaker Volume", TAS2764_DVC, 0,
 		       TAS2764_DVC_MAX, 1, tas2764_playback_volume),
-	SOC_SINGLE_TLV("Amp Gain Volume", TAS2764_CHNL_0, 0, 0x14, 0,
+	SOC_SINGLE_TLV("Amp Gain Volume", TAS2764_CHNL_0, 1, 0x14, 0,
 		       tas2764_digital_tlv),
 };
 
@@ -556,7 +566,7 @@ static const struct reg_default tas2764_reg_defaults[] = {
 	{ TAS2764_SW_RST, 0x00 },
 	{ TAS2764_PWR_CTRL, 0x1a },
 	{ TAS2764_DVC, 0x00 },
-	{ TAS2764_CHNL_0, 0x00 },
+	{ TAS2764_CHNL_0, 0x28 },
 	{ TAS2764_TDM_CFG0, 0x09 },
 	{ TAS2764_TDM_CFG1, 0x02 },
 	{ TAS2764_TDM_CFG2, 0x0a },
diff --git a/sound/soc/codecs/tas2764.h b/sound/soc/codecs/tas2764.h
index 67d6fd903c42..f015f22a083b 100644
--- a/sound/soc/codecs/tas2764.h
+++ b/sound/soc/codecs/tas2764.h
@@ -47,6 +47,7 @@
 #define TAS2764_TDM_CFG0_MASK		GENMASK(3, 1)
 #define TAS2764_TDM_CFG0_44_1_48KHZ	BIT(3)
 #define TAS2764_TDM_CFG0_88_2_96KHZ	(BIT(3) | BIT(1))
+#define TAS2764_TDM_CFG0_FRAME_START	BIT(0)
 
 /* TDM Configuration Reg1 */
 #define TAS2764_TDM_CFG1		TAS2764_REG(0X0, 0x09)
@@ -66,10 +67,7 @@
 #define TAS2764_TDM_CFG2_RXS_16BITS	0x0
 #define TAS2764_TDM_CFG2_RXS_24BITS	BIT(0)
 #define TAS2764_TDM_CFG2_RXS_32BITS	BIT(1)
-#define TAS2764_TDM_CFG2_SCFG_MASK	GENMASK(5, 4)
-#define TAS2764_TDM_CFG2_SCFG_I2S	0x0
-#define TAS2764_TDM_CFG2_SCFG_LEFT_J	BIT(4)
-#define TAS2764_TDM_CFG2_SCFG_RIGHT_J	BIT(5)
+#define TAS2764_TDM_CFG2_SCFG_SHIFT	4
 
 /* TDM Configuration Reg3 */
 #define TAS2764_TDM_CFG3		TAS2764_REG(0X0, 0x0c)
diff --git a/sound/soc/codecs/wcd938x.c b/sound/soc/codecs/wcd938x.c
index 4480c118ed5d..8cdc45e669f2 100644
--- a/sound/soc/codecs/wcd938x.c
+++ b/sound/soc/codecs/wcd938x.c
@@ -2517,6 +2517,9 @@ static int wcd938x_tx_mode_put(struct snd_kcontrol *kcontrol,
 	struct soc_enum *e = (struct soc_enum *)kcontrol->private_value;
 	int path = e->shift_l;
 
+	if (wcd938x->tx_mode[path] == ucontrol->value.enumerated.item[0])
+		return 0;
+
 	wcd938x->tx_mode[path] = ucontrol->value.enumerated.item[0];
 
 	return 1;
@@ -2539,6 +2542,9 @@ static int wcd938x_rx_hph_mode_put(struct snd_kcontrol *kcontrol,
 	struct snd_soc_component *component = snd_soc_kcontrol_component(kcontrol);
 	struct wcd938x_priv *wcd938x = snd_soc_component_get_drvdata(component);
 
+	if (wcd938x->hph_mode == ucontrol->value.enumerated.item[0])
+		return 0;
+
 	wcd938x->hph_mode = ucontrol->value.enumerated.item[0];
 
 	return 1;
@@ -2630,6 +2636,9 @@ static int wcd938x_ldoh_put(struct snd_kcontrol *kcontrol,
 	struct snd_soc_component *component = snd_soc_kcontrol_component(kcontrol);
 	struct wcd938x_priv *wcd938x = snd_soc_component_get_drvdata(component);
 
+	if (wcd938x->ldoh == ucontrol->value.integer.value[0])
+		return 0;
+
 	wcd938x->ldoh = ucontrol->value.integer.value[0];
 
 	return 1;
@@ -2652,6 +2661,9 @@ static int wcd938x_bcs_put(struct snd_kcontrol *kcontrol,
 	struct snd_soc_component *component = snd_soc_kcontrol_component(kcontrol);
 	struct wcd938x_priv *wcd938x = snd_soc_component_get_drvdata(component);
 
+	if (wcd938x->bcs_dis == ucontrol->value.integer.value[0])
+		return 0;
+
 	wcd938x->bcs_dis = ucontrol->value.integer.value[0];
 
 	return 1;
diff --git a/sound/soc/codecs/wm5110.c b/sound/soc/codecs/wm5110.c
index 5c2d45d05c97..7c6e01720d65 100644
--- a/sound/soc/codecs/wm5110.c
+++ b/sound/soc/codecs/wm5110.c
@@ -413,6 +413,7 @@ static int wm5110_put_dre(struct snd_kcontrol *kcontrol,
 	unsigned int rnew = (!!ucontrol->value.integer.value[1]) << mc->rshift;
 	unsigned int lold, rold;
 	unsigned int lena, rena;
+	bool change = false;
 	int ret;
 
 	snd_soc_dapm_mutex_lock(dapm);
@@ -440,8 +441,8 @@ static int wm5110_put_dre(struct snd_kcontrol *kcontrol,
 		goto err;
 	}
 
-	ret = regmap_update_bits(arizona->regmap, ARIZONA_DRE_ENABLE,
-				 mask, lnew | rnew);
+	ret = regmap_update_bits_check(arizona->regmap, ARIZONA_DRE_ENABLE,
+				       mask, lnew | rnew, &change);
 	if (ret) {
 		dev_err(arizona->dev, "Failed to set DRE: %d\n", ret);
 		goto err;
@@ -454,6 +455,9 @@ static int wm5110_put_dre(struct snd_kcontrol *kcontrol,
 	if (!rnew && rold)
 		wm5110_clear_pga_volume(arizona, mc->rshift);
 
+	if (change)
+		ret = 1;
+
 err:
 	snd_soc_dapm_mutex_unlock(dapm);
 
diff --git a/sound/soc/intel/boards/bytcr_wm5102.c b/sound/soc/intel/boards/bytcr_wm5102.c
index 580d5fddae5a..bb669d58eb8b 100644
--- a/sound/soc/intel/boards/bytcr_wm5102.c
+++ b/sound/soc/intel/boards/bytcr_wm5102.c
@@ -421,8 +421,17 @@ static int snd_byt_wm5102_mc_probe(struct platform_device *pdev)
 	priv->spkvdd_en_gpio = gpiod_get(codec_dev, "wlf,spkvdd-ena", GPIOD_OUT_LOW);
 	put_device(codec_dev);
 
-	if (IS_ERR(priv->spkvdd_en_gpio))
-		return dev_err_probe(dev, PTR_ERR(priv->spkvdd_en_gpio), "getting spkvdd-GPIO\n");
+	if (IS_ERR(priv->spkvdd_en_gpio)) {
+		ret = PTR_ERR(priv->spkvdd_en_gpio);
+		/*
+		 * The spkvdd gpio-lookup is registered by: drivers/mfd/arizona-spi.c,
+		 * so -ENOENT means that arizona-spi hasn't probed yet.
+		 */
+		if (ret == -ENOENT)
+			ret = -EPROBE_DEFER;
+
+		return dev_err_probe(dev, ret, "getting spkvdd-GPIO\n");
+	}
 
 	/* override platform name, if required */
 	byt_wm5102_card.dev = dev;
diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index 0bf3e56e1d58..abe39a0ef14b 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -1323,6 +1323,33 @@ static struct snd_soc_card card_sof_sdw = {
 	.late_probe = sof_sdw_card_late_probe,
 };
 
+static void mc_dailink_exit_loop(struct snd_soc_card *card)
+{
+	struct snd_soc_dai_link *link;
+	int ret;
+	int i, j;
+
+	for (i = 0; i < ARRAY_SIZE(codec_info_list); i++) {
+		if (!codec_info_list[i].exit)
+			continue;
+		/*
+		 * We don't need to call .exit function if there is no matched
+		 * dai link found.
+		 */
+		for_each_card_prelinks(card, j, link) {
+			if (!strcmp(link->codecs[0].dai_name,
+				    codec_info_list[i].dai_name)) {
+				ret = codec_info_list[i].exit(card, link);
+				if (ret)
+					dev_warn(card->dev,
+						 "codec exit failed %d\n",
+						 ret);
+				break;
+			}
+		}
+	}
+}
+
 static int mc_probe(struct platform_device *pdev)
 {
 	struct snd_soc_card *card = &card_sof_sdw;
@@ -1387,6 +1414,7 @@ static int mc_probe(struct platform_device *pdev)
 	ret = devm_snd_soc_register_card(&pdev->dev, card);
 	if (ret) {
 		dev_err(card->dev, "snd_soc_register_card failed %d\n", ret);
+		mc_dailink_exit_loop(card);
 		return ret;
 	}
 
@@ -1398,29 +1426,8 @@ static int mc_probe(struct platform_device *pdev)
 static int mc_remove(struct platform_device *pdev)
 {
 	struct snd_soc_card *card = platform_get_drvdata(pdev);
-	struct snd_soc_dai_link *link;
-	int ret;
-	int i, j;
 
-	for (i = 0; i < ARRAY_SIZE(codec_info_list); i++) {
-		if (!codec_info_list[i].exit)
-			continue;
-		/*
-		 * We don't need to call .exit function if there is no matched
-		 * dai link found.
-		 */
-		for_each_card_prelinks(card, j, link) {
-			if (!strcmp(link->codecs[0].dai_name,
-				    codec_info_list[i].dai_name)) {
-				ret = codec_info_list[i].exit(card, link);
-				if (ret)
-					dev_warn(&pdev->dev,
-						 "codec exit failed %d\n",
-						 ret);
-				break;
-			}
-		}
-	}
+	mc_dailink_exit_loop(card);
 
 	return 0;
 }
diff --git a/sound/soc/intel/skylake/skl-nhlt.c b/sound/soc/intel/skylake/skl-nhlt.c
index 64226072f0ee..74f60f5dfaef 100644
--- a/sound/soc/intel/skylake/skl-nhlt.c
+++ b/sound/soc/intel/skylake/skl-nhlt.c
@@ -201,7 +201,6 @@ static void skl_get_ssp_clks(struct skl_dev *skl, struct skl_ssp_clk *ssp_clks,
 	struct nhlt_fmt_cfg *fmt_cfg;
 	struct wav_fmt_ext *wav_fmt;
 	unsigned long rate;
-	bool present = false;
 	int rate_index = 0;
 	u16 channels, bps;
 	u8 clk_src;
@@ -214,9 +213,12 @@ static void skl_get_ssp_clks(struct skl_dev *skl, struct skl_ssp_clk *ssp_clks,
 	if (fmt->fmt_count == 0)
 		return;
 
+	fmt_cfg = (struct nhlt_fmt_cfg *)fmt->fmt_config;
 	for (i = 0; i < fmt->fmt_count; i++) {
-		fmt_cfg = &fmt->fmt_config[i];
-		wav_fmt = &fmt_cfg->fmt_ext;
+		struct nhlt_fmt_cfg *saved_fmt_cfg = fmt_cfg;
+		bool present = false;
+
+		wav_fmt = &saved_fmt_cfg->fmt_ext;
 
 		channels = wav_fmt->fmt.channels;
 		bps = wav_fmt->fmt.bits_per_sample;
@@ -234,12 +236,18 @@ static void skl_get_ssp_clks(struct skl_dev *skl, struct skl_ssp_clk *ssp_clks,
 		 * derive the rate.
 		 */
 		for (j = i; j < fmt->fmt_count; j++) {
-			fmt_cfg = &fmt->fmt_config[j];
-			wav_fmt = &fmt_cfg->fmt_ext;
+			struct nhlt_fmt_cfg *tmp_fmt_cfg = fmt_cfg;
+
+			wav_fmt = &tmp_fmt_cfg->fmt_ext;
 			if ((fs == wav_fmt->fmt.samples_per_sec) &&
-			   (bps == wav_fmt->fmt.bits_per_sample))
+			   (bps == wav_fmt->fmt.bits_per_sample)) {
 				channels = max_t(u16, channels,
 						wav_fmt->fmt.channels);
+				saved_fmt_cfg = tmp_fmt_cfg;
+			}
+			/* Move to the next nhlt_fmt_cfg */
+			tmp_fmt_cfg = (struct nhlt_fmt_cfg *)(tmp_fmt_cfg->config.caps +
+							      tmp_fmt_cfg->config.size);
 		}
 
 		rate = channels * bps * fs;
@@ -255,8 +263,11 @@ static void skl_get_ssp_clks(struct skl_dev *skl, struct skl_ssp_clk *ssp_clks,
 
 		/* Fill rate and parent for sclk/sclkfs */
 		if (!present) {
+			struct nhlt_fmt_cfg *first_fmt_cfg;
+
+			first_fmt_cfg = (struct nhlt_fmt_cfg *)fmt->fmt_config;
 			i2s_config_ext = (struct skl_i2s_config_blob_ext *)
-						fmt->fmt_config[0].config.caps;
+						first_fmt_cfg->config.caps;
 
 			/* MCLK Divider Source Select */
 			if (is_legacy_blob(i2s_config_ext->hdr.sig)) {
@@ -270,6 +281,9 @@ static void skl_get_ssp_clks(struct skl_dev *skl, struct skl_ssp_clk *ssp_clks,
 
 			parent = skl_get_parent_clk(clk_src);
 
+			/* Move to the next nhlt_fmt_cfg */
+			fmt_cfg = (struct nhlt_fmt_cfg *)(fmt_cfg->config.caps +
+							  fmt_cfg->config.size);
 			/*
 			 * Do not copy the config data if there is no parent
 			 * clock available for this clock source select
@@ -278,9 +292,9 @@ static void skl_get_ssp_clks(struct skl_dev *skl, struct skl_ssp_clk *ssp_clks,
 				continue;
 
 			sclk[id].rate_cfg[rate_index].rate = rate;
-			sclk[id].rate_cfg[rate_index].config = fmt_cfg;
+			sclk[id].rate_cfg[rate_index].config = saved_fmt_cfg;
 			sclkfs[id].rate_cfg[rate_index].rate = rate;
-			sclkfs[id].rate_cfg[rate_index].config = fmt_cfg;
+			sclkfs[id].rate_cfg[rate_index].config = saved_fmt_cfg;
 			sclk[id].parent_name = parent->name;
 			sclkfs[id].parent_name = parent->name;
 
@@ -294,13 +308,13 @@ static void skl_get_mclk(struct skl_dev *skl, struct skl_ssp_clk *mclk,
 {
 	struct skl_i2s_config_blob_ext *i2s_config_ext;
 	struct skl_i2s_config_blob_legacy *i2s_config;
-	struct nhlt_specific_cfg *fmt_cfg;
+	struct nhlt_fmt_cfg *fmt_cfg;
 	struct skl_clk_parent_src *parent;
 	u32 clkdiv, div_ratio;
 	u8 clk_src;
 
-	fmt_cfg = &fmt->fmt_config[0].config;
-	i2s_config_ext = (struct skl_i2s_config_blob_ext *)fmt_cfg->caps;
+	fmt_cfg = (struct nhlt_fmt_cfg *)fmt->fmt_config;
+	i2s_config_ext = (struct skl_i2s_config_blob_ext *)fmt_cfg->config.caps;
 
 	/* MCLK Divider Source Select and divider */
 	if (is_legacy_blob(i2s_config_ext->hdr.sig)) {
@@ -329,7 +343,7 @@ static void skl_get_mclk(struct skl_dev *skl, struct skl_ssp_clk *mclk,
 		return;
 
 	mclk[id].rate_cfg[0].rate = parent->rate/div_ratio;
-	mclk[id].rate_cfg[0].config = &fmt->fmt_config[0];
+	mclk[id].rate_cfg[0].config = fmt_cfg;
 	mclk[id].parent_name = parent->name;
 }
 
diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index 47b85ba5b7d6..b957049bae33 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -62,6 +62,8 @@ struct snd_soc_dapm_widget *
 snd_soc_dapm_new_control_unlocked(struct snd_soc_dapm_context *dapm,
 			 const struct snd_soc_dapm_widget *widget);
 
+static unsigned int soc_dapm_read(struct snd_soc_dapm_context *dapm, int reg);
+
 /* dapm power sequences - make this per codec in the future */
 static int dapm_up_seq[] = {
 	[snd_soc_dapm_pre] = 1,
@@ -442,6 +444,9 @@ static int dapm_kcontrol_data_alloc(struct snd_soc_dapm_widget *widget,
 
 			snd_soc_dapm_add_path(widget->dapm, data->widget,
 					      widget, NULL, NULL);
+		} else if (e->reg != SND_SOC_NOPM) {
+			data->value = soc_dapm_read(widget->dapm, e->reg) &
+				      (e->mask << e->shift_l);
 		}
 		break;
 	default:
diff --git a/sound/soc/soc-ops.c b/sound/soc/soc-ops.c
index f32ba64c5dda..e73360e9de8f 100644
--- a/sound/soc/soc-ops.c
+++ b/sound/soc/soc-ops.c
@@ -526,7 +526,7 @@ int snd_soc_put_volsw_range(struct snd_kcontrol *kcontrol,
 		return -EINVAL;
 	if (mc->platform_max && tmp > mc->platform_max)
 		return -EINVAL;
-	if (tmp > mc->max - mc->min + 1)
+	if (tmp > mc->max - mc->min)
 		return -EINVAL;
 
 	if (invert)
@@ -547,7 +547,7 @@ int snd_soc_put_volsw_range(struct snd_kcontrol *kcontrol,
 			return -EINVAL;
 		if (mc->platform_max && tmp > mc->platform_max)
 			return -EINVAL;
-		if (tmp > mc->max - mc->min + 1)
+		if (tmp > mc->max - mc->min)
 			return -EINVAL;
 
 		if (invert)
diff --git a/sound/soc/sof/intel/hda-loader.c b/sound/soc/sof/intel/hda-loader.c
index 14469e087b00..ee09393d42cb 100644
--- a/sound/soc/sof/intel/hda-loader.c
+++ b/sound/soc/sof/intel/hda-loader.c
@@ -80,9 +80,9 @@ static struct hdac_ext_stream *cl_stream_prepare(struct snd_sof_dev *sdev, unsig
 }
 
 /*
- * first boot sequence has some extra steps. core 0 waits for power
- * status on core 1, so power up core 1 also momentarily, keep it in
- * reset/stall and then turn it off
+ * first boot sequence has some extra steps.
+ * power on all host managed cores and only unstall/run the boot core to boot the
+ * DSP then turn off all non boot cores (if any) is powered on.
  */
 static int cl_dsp_init(struct snd_sof_dev *sdev, int stream_tag)
 {
@@ -117,7 +117,7 @@ static int cl_dsp_init(struct snd_sof_dev *sdev, int stream_tag)
 			  ((stream_tag - 1) << 9)));
 
 	/* step 3: unset core 0 reset state & unstall/run core 0 */
-	ret = hda_dsp_core_run(sdev, BIT(0));
+	ret = hda_dsp_core_run(sdev, chip->init_core_mask);
 	if (ret < 0) {
 		if (hda->boot_iteration == HDA_FW_BOOT_ATTEMPTS)
 			dev_err(sdev->dev,
diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index 4f56e1784932..f93201a830b5 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -3802,6 +3802,54 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 	}
 },
 
+/*
+ * MacroSilicon MS2100/MS2106 based AV capture cards
+ *
+ * These claim 96kHz 1ch in the descriptors, but are actually 48kHz 2ch.
+ * They also need QUIRK_FLAG_ALIGN_TRANSFER, which makes one wonder if
+ * they pretend to be 96kHz mono as a workaround for stereo being broken
+ * by that...
+ *
+ * They also have an issue with initial stream alignment that causes the
+ * channels to be swapped and out of phase, which is dealt with in quirks.c.
+ */
+{
+	USB_AUDIO_DEVICE(0x534d, 0x0021),
+	.driver_info = (unsigned long) &(const struct snd_usb_audio_quirk) {
+		.vendor_name = "MacroSilicon",
+		.product_name = "MS210x",
+		.ifnum = QUIRK_ANY_INTERFACE,
+		.type = QUIRK_COMPOSITE,
+		.data = &(const struct snd_usb_audio_quirk[]) {
+			{
+				.ifnum = 2,
+				.type = QUIRK_AUDIO_STANDARD_MIXER,
+			},
+			{
+				.ifnum = 3,
+				.type = QUIRK_AUDIO_FIXED_ENDPOINT,
+				.data = &(const struct audioformat) {
+					.formats = SNDRV_PCM_FMTBIT_S16_LE,
+					.channels = 2,
+					.iface = 3,
+					.altsetting = 1,
+					.altset_idx = 1,
+					.attributes = 0,
+					.endpoint = 0x82,
+					.ep_attr = USB_ENDPOINT_XFER_ISOC |
+						USB_ENDPOINT_SYNC_ASYNC,
+					.rates = SNDRV_PCM_RATE_CONTINUOUS,
+					.rate_min = 48000,
+					.rate_max = 48000,
+				}
+			},
+			{
+				.ifnum = -1
+			}
+		}
+	}
+},
+
 /*
  * MacroSilicon MS2109 based HDMI capture cards
  *
@@ -4119,6 +4167,206 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 		}
 	}
 },
+{
+	/*
+	 * Fiero SC-01 (firmware v1.0.0 @ 48 kHz)
+	 */
+	USB_DEVICE(0x2b53, 0x0023),
+	.driver_info = (unsigned long) &(const struct snd_usb_audio_quirk) {
+		.vendor_name = "Fiero",
+		.product_name = "SC-01",
+		.ifnum = QUIRK_ANY_INTERFACE,
+		.type = QUIRK_COMPOSITE,
+		.data = &(const struct snd_usb_audio_quirk[]) {
+			{
+				.ifnum = 0,
+				.type = QUIRK_AUDIO_STANDARD_INTERFACE
+			},
+			/* Playback */
+			{
+				.ifnum = 1,
+				.type = QUIRK_AUDIO_FIXED_ENDPOINT,
+				.data = &(const struct audioformat) {
+					.formats = SNDRV_PCM_FMTBIT_S32_LE,
+					.channels = 2,
+					.fmt_bits = 24,
+					.iface = 1,
+					.altsetting = 1,
+					.altset_idx = 1,
+					.endpoint = 0x01,
+					.ep_attr = USB_ENDPOINT_XFER_ISOC |
+						   USB_ENDPOINT_SYNC_ASYNC,
+					.rates = SNDRV_PCM_RATE_48000,
+					.rate_min = 48000,
+					.rate_max = 48000,
+					.nr_rates = 1,
+					.rate_table = (unsigned int[]) { 48000 },
+					.clock = 0x29
+				}
+			},
+			/* Capture */
+			{
+				.ifnum = 2,
+				.type = QUIRK_AUDIO_FIXED_ENDPOINT,
+				.data = &(const struct audioformat) {
+					.formats = SNDRV_PCM_FMTBIT_S32_LE,
+					.channels = 2,
+					.fmt_bits = 24,
+					.iface = 2,
+					.altsetting = 1,
+					.altset_idx = 1,
+					.endpoint = 0x82,
+					.ep_attr = USB_ENDPOINT_XFER_ISOC |
+						   USB_ENDPOINT_SYNC_ASYNC |
+						   USB_ENDPOINT_USAGE_IMPLICIT_FB,
+					.rates = SNDRV_PCM_RATE_48000,
+					.rate_min = 48000,
+					.rate_max = 48000,
+					.nr_rates = 1,
+					.rate_table = (unsigned int[]) { 48000 },
+					.clock = 0x29
+				}
+			},
+			{
+				.ifnum = -1
+			}
+		}
+	}
+},
+{
+	/*
+	 * Fiero SC-01 (firmware v1.0.0 @ 96 kHz)
+	 */
+	USB_DEVICE(0x2b53, 0x0024),
+	.driver_info = (unsigned long) &(const struct snd_usb_audio_quirk) {
+		.vendor_name = "Fiero",
+		.product_name = "SC-01",
+		.ifnum = QUIRK_ANY_INTERFACE,
+		.type = QUIRK_COMPOSITE,
+		.data = &(const struct snd_usb_audio_quirk[]) {
+			{
+				.ifnum = 0,
+				.type = QUIRK_AUDIO_STANDARD_INTERFACE
+			},
+			/* Playback */
+			{
+				.ifnum = 1,
+				.type = QUIRK_AUDIO_FIXED_ENDPOINT,
+				.data = &(const struct audioformat) {
+					.formats = SNDRV_PCM_FMTBIT_S32_LE,
+					.channels = 2,
+					.fmt_bits = 24,
+					.iface = 1,
+					.altsetting = 1,
+					.altset_idx = 1,
+					.endpoint = 0x01,
+					.ep_attr = USB_ENDPOINT_XFER_ISOC |
+						   USB_ENDPOINT_SYNC_ASYNC,
+					.rates = SNDRV_PCM_RATE_96000,
+					.rate_min = 96000,
+					.rate_max = 96000,
+					.nr_rates = 1,
+					.rate_table = (unsigned int[]) { 96000 },
+					.clock = 0x29
+				}
+			},
+			/* Capture */
+			{
+				.ifnum = 2,
+				.type = QUIRK_AUDIO_FIXED_ENDPOINT,
+				.data = &(const struct audioformat) {
+					.formats = SNDRV_PCM_FMTBIT_S32_LE,
+					.channels = 2,
+					.fmt_bits = 24,
+					.iface = 2,
+					.altsetting = 1,
+					.altset_idx = 1,
+					.endpoint = 0x82,
+					.ep_attr = USB_ENDPOINT_XFER_ISOC |
+						   USB_ENDPOINT_SYNC_ASYNC |
+						   USB_ENDPOINT_USAGE_IMPLICIT_FB,
+					.rates = SNDRV_PCM_RATE_96000,
+					.rate_min = 96000,
+					.rate_max = 96000,
+					.nr_rates = 1,
+					.rate_table = (unsigned int[]) { 96000 },
+					.clock = 0x29
+				}
+			},
+			{
+				.ifnum = -1
+			}
+		}
+	}
+},
+{
+	/*
+	 * Fiero SC-01 (firmware v1.1.0)
+	 */
+	USB_DEVICE(0x2b53, 0x0031),
+	.driver_info = (unsigned long) &(const struct snd_usb_audio_quirk) {
+		.vendor_name = "Fiero",
+		.product_name = "SC-01",
+		.ifnum = QUIRK_ANY_INTERFACE,
+		.type = QUIRK_COMPOSITE,
+		.data = &(const struct snd_usb_audio_quirk[]) {
+			{
+				.ifnum = 0,
+				.type = QUIRK_AUDIO_STANDARD_INTERFACE
+			},
+			/* Playback */
+			{
+				.ifnum = 1,
+				.type = QUIRK_AUDIO_FIXED_ENDPOINT,
+				.data = &(const struct audioformat) {
+					.formats = SNDRV_PCM_FMTBIT_S32_LE,
+					.channels = 2,
+					.fmt_bits = 24,
+					.iface = 1,
+					.altsetting = 1,
+					.altset_idx = 1,
+					.endpoint = 0x01,
+					.ep_attr = USB_ENDPOINT_XFER_ISOC |
+						   USB_ENDPOINT_SYNC_ASYNC,
+					.rates = SNDRV_PCM_RATE_48000 |
+						 SNDRV_PCM_RATE_96000,
+					.rate_min = 48000,
+					.rate_max = 96000,
+					.nr_rates = 2,
+					.rate_table = (unsigned int[]) { 48000, 96000 },
+					.clock = 0x29
+				}
+			},
+			/* Capture */
+			{
+				.ifnum = 2,
+				.type = QUIRK_AUDIO_FIXED_ENDPOINT,
+				.data = &(const struct audioformat) {
+					.formats = SNDRV_PCM_FMTBIT_S32_LE,
+					.channels = 2,
+					.fmt_bits = 24,
+					.iface = 2,
+					.altsetting = 1,
+					.altset_idx = 1,
+					.endpoint = 0x82,
+					.ep_attr = USB_ENDPOINT_XFER_ISOC |
+						   USB_ENDPOINT_SYNC_ASYNC |
+						   USB_ENDPOINT_USAGE_IMPLICIT_FB,
+					.rates = SNDRV_PCM_RATE_48000 |
+						 SNDRV_PCM_RATE_96000,
+					.rate_min = 48000,
+					.rate_max = 96000,
+					.nr_rates = 2,
+					.rate_table = (unsigned int[]) { 48000, 96000 },
+					.clock = 0x29
+				}
+			},
+			{
+				.ifnum = -1
+			}
+		}
+	}
+},
 
 #undef USB_DEVICE_VENDOR_SPEC
 #undef USB_AUDIO_DEVICE
diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 12ce69b04f63..968d90caeefa 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1478,6 +1478,7 @@ void snd_usb_set_format_quirk(struct snd_usb_substream *subs,
 	case USB_ID(0x041e, 0x3f19): /* E-Mu 0204 USB */
 		set_format_emu_quirk(subs, fmt);
 		break;
+	case USB_ID(0x534d, 0x0021): /* MacroSilicon MS2100/MS2106 */
 	case USB_ID(0x534d, 0x2109): /* MacroSilicon MS2109 */
 		subs->stream_offset_adj = 2;
 		break;
@@ -1908,10 +1909,18 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_IGNORE_CTL_ERROR),
 	DEVICE_FLG(0x413c, 0xa506, /* Dell AE515 sound bar */
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
+	DEVICE_FLG(0x534d, 0x0021, /* MacroSilicon MS2100/MS2106 */
+		   QUIRK_FLAG_ALIGN_TRANSFER),
 	DEVICE_FLG(0x534d, 0x2109, /* MacroSilicon MS2109 */
 		   QUIRK_FLAG_ALIGN_TRANSFER),
 	DEVICE_FLG(0x1224, 0x2a25, /* Jieli Technology USB PHY 2.0 */
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
+	DEVICE_FLG(0x2b53, 0x0023, /* Fiero SC-01 (firmware v1.0.0 @ 48 kHz) */
+		   QUIRK_FLAG_GENERIC_IMPLICIT_FB),
+	DEVICE_FLG(0x2b53, 0x0024, /* Fiero SC-01 (firmware v1.0.0 @ 96 kHz) */
+		   QUIRK_FLAG_GENERIC_IMPLICIT_FB),
+	DEVICE_FLG(0x2b53, 0x0031, /* Fiero SC-01 (firmware v1.1.0) */
+		   QUIRK_FLAG_GENERIC_IMPLICIT_FB),
 
 	/* Vendor matches */
 	VENDOR_FLG(0x045e, /* MS Lifecam */
