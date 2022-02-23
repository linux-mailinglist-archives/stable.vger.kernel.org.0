Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F07284C1264
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 13:08:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240327AbiBWMIL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Feb 2022 07:08:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240399AbiBWMIC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Feb 2022 07:08:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B29DF9AE41;
        Wed, 23 Feb 2022 04:07:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7802D60B4B;
        Wed, 23 Feb 2022 12:07:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C436AC340E7;
        Wed, 23 Feb 2022 12:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645618044;
        bh=5CEFtXWi6kSb8bGqlx212Y0SVWLy3baFBXqgcpu+8k8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rKLT/zbtFhg9KHtuSLZ7hGei+iHo/9d8JKh+KIDTZXZ882Jr9omH4kpHWch+zQSIK
         26izDEys/2W750tOQ9K09EAgNtXctIoRmKiXa8Kp2K3K5i+gYdVYCF3JXb0z3x7V36
         i3oG4Gg418lZoD02foICQU6qswxMLQZH3UUj1/As=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.25
Date:   Wed, 23 Feb 2022 13:07:14 +0100
Message-Id: <164561803321541@kroah.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <164561803311588@kroah.com>
References: <164561803311588@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index c726a33e922f..c50d4ec83be8 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 24
+SUBLEVEL = 25
 EXTRAVERSION =
 NAME = Trick or Treat
 
diff --git a/arch/arm/mach-omap2/display.c b/arch/arm/mach-omap2/display.c
index 6daaa645ae5d..21413a9b7b6c 100644
--- a/arch/arm/mach-omap2/display.c
+++ b/arch/arm/mach-omap2/display.c
@@ -263,9 +263,9 @@ static int __init omapdss_init_of(void)
 	}
 
 	r = of_platform_populate(node, NULL, NULL, &pdev->dev);
+	put_device(&pdev->dev);
 	if (r) {
 		pr_err("Unable to populate DSS submodule devices\n");
-		put_device(&pdev->dev);
 		return r;
 	}
 
diff --git a/arch/arm/mach-omap2/omap_hwmod.c b/arch/arm/mach-omap2/omap_hwmod.c
index 0c2936c7a379..a5e9cffcac10 100644
--- a/arch/arm/mach-omap2/omap_hwmod.c
+++ b/arch/arm/mach-omap2/omap_hwmod.c
@@ -752,8 +752,10 @@ static int __init _init_clkctrl_providers(void)
 
 	for_each_matching_node(np, ti_clkctrl_match_table) {
 		ret = _setup_clkctrl_provider(np);
-		if (ret)
+		if (ret) {
+			of_node_put(np);
 			break;
+		}
 	}
 
 	return ret;
diff --git a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
index 428449d98c0a..a3a1ea0f2134 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
@@ -107,6 +107,12 @@ secmon_reserved: secmon@5000000 {
 			no-map;
 		};
 
+		/* 32 MiB reserved for ARM Trusted Firmware (BL32) */
+		secmon_reserved_bl32: secmon@5300000 {
+			reg = <0x0 0x05300000 0x0 0x2000000>;
+			no-map;
+		};
+
 		linux,cma {
 			compatible = "shared-dma-pool";
 			reusable;
diff --git a/arch/arm64/boot/dts/amlogic/meson-g12a-sei510.dts b/arch/arm64/boot/dts/amlogic/meson-g12a-sei510.dts
index d8838dde0f0f..4fb31c2ba31c 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12a-sei510.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-g12a-sei510.dts
@@ -157,14 +157,6 @@ vddio_ao1v8: regulator-vddio_ao1v8 {
 		regulator-always-on;
 	};
 
-	reserved-memory {
-		/* TEE Reserved Memory */
-		bl32_reserved: bl32@5000000 {
-			reg = <0x0 0x05300000 0x0 0x2000000>;
-			no-map;
-		};
-	};
-
 	sdio_pwrseq: sdio-pwrseq {
 		compatible = "mmc-pwrseq-simple";
 		reset-gpios = <&gpio GPIOX_6 GPIO_ACTIVE_LOW>;
diff --git a/arch/arm64/boot/dts/amlogic/meson-gx.dtsi b/arch/arm64/boot/dts/amlogic/meson-gx.dtsi
index 6b457b2c30a4..aa14ea017a61 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gx.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gx.dtsi
@@ -49,6 +49,12 @@ secmon_reserved_alt: secmon@5000000 {
 			no-map;
 		};
 
+		/* 32 MiB reserved for ARM Trusted Firmware (BL32) */
+		secmon_reserved_bl32: secmon@5300000 {
+			reg = <0x0 0x05300000 0x0 0x2000000>;
+			no-map;
+		};
+
 		linux,cma {
 			compatible = "shared-dma-pool";
 			reusable;
diff --git a/arch/arm64/boot/dts/amlogic/meson-sm1-sei610.dts b/arch/arm64/boot/dts/amlogic/meson-sm1-sei610.dts
index 427475846fc7..a5d79f2f7c19 100644
--- a/arch/arm64/boot/dts/amlogic/meson-sm1-sei610.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-sm1-sei610.dts
@@ -203,14 +203,6 @@ vddio_ao1v8: regulator-vddio_ao1v8 {
 		regulator-always-on;
 	};
 
-	reserved-memory {
-		/* TEE Reserved Memory */
-		bl32_reserved: bl32@5000000 {
-			reg = <0x0 0x05300000 0x0 0x2000000>;
-			no-map;
-		};
-	};
-
 	sdio_pwrseq: sdio-pwrseq {
 		compatible = "mmc-pwrseq-simple";
 		reset-gpios = <&gpio GPIOX_6 GPIO_ACTIVE_LOW>;
diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
index 3198acb2aad8..7f3c87f7a0ce 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -106,7 +106,7 @@
 	msr_s	SYS_ICC_SRE_EL2, x0
 	isb					// Make sure SRE is now set
 	mrs_s	x0, SYS_ICC_SRE_EL2		// Read SRE back,
-	tbz	x0, #0, 1f			// and check that it sticks
+	tbz	x0, #0, .Lskip_gicv3_\@		// and check that it sticks
 	msr_s	SYS_ICH_HCR_EL2, xzr		// Reset ICC_HCR_EL2 to defaults
 .Lskip_gicv3_\@:
 .endm
diff --git a/arch/parisc/include/asm/bitops.h b/arch/parisc/include/asm/bitops.h
index aa4e883431c1..5779d463b341 100644
--- a/arch/parisc/include/asm/bitops.h
+++ b/arch/parisc/include/asm/bitops.h
@@ -12,6 +12,14 @@
 #include <asm/barrier.h>
 #include <linux/atomic.h>
 
+/* compiler build environment sanity checks: */
+#if !defined(CONFIG_64BIT) && defined(__LP64__)
+#error "Please use 'ARCH=parisc' to build the 32-bit kernel."
+#endif
+#if defined(CONFIG_64BIT) && !defined(__LP64__)
+#error "Please use 'ARCH=parisc64' to build the 64-bit kernel."
+#endif
+
 /* See http://marc.theaimsgroup.com/?t=108826637900003 for discussion
  * on use of volatile and __*_bit() (set/clear/change):
  *	*_bit() want use of volatile.
diff --git a/arch/parisc/lib/iomap.c b/arch/parisc/lib/iomap.c
index 367f6397bda7..860385058085 100644
--- a/arch/parisc/lib/iomap.c
+++ b/arch/parisc/lib/iomap.c
@@ -346,6 +346,16 @@ u64 ioread64be(const void __iomem *addr)
 	return *((u64 *)addr);
 }
 
+u64 ioread64_lo_hi(const void __iomem *addr)
+{
+	u32 low, high;
+
+	low = ioread32(addr);
+	high = ioread32(addr + sizeof(u32));
+
+	return low + ((u64)high << 32);
+}
+
 u64 ioread64_hi_lo(const void __iomem *addr)
 {
 	u32 low, high;
@@ -419,6 +429,12 @@ void iowrite64be(u64 datum, void __iomem *addr)
 	}
 }
 
+void iowrite64_lo_hi(u64 val, void __iomem *addr)
+{
+	iowrite32(val, addr);
+	iowrite32(val >> 32, addr + sizeof(u32));
+}
+
 void iowrite64_hi_lo(u64 val, void __iomem *addr)
 {
 	iowrite32(val >> 32, addr + sizeof(u32));
@@ -530,6 +546,7 @@ EXPORT_SYMBOL(ioread32);
 EXPORT_SYMBOL(ioread32be);
 EXPORT_SYMBOL(ioread64);
 EXPORT_SYMBOL(ioread64be);
+EXPORT_SYMBOL(ioread64_lo_hi);
 EXPORT_SYMBOL(ioread64_hi_lo);
 EXPORT_SYMBOL(iowrite8);
 EXPORT_SYMBOL(iowrite16);
@@ -538,6 +555,7 @@ EXPORT_SYMBOL(iowrite32);
 EXPORT_SYMBOL(iowrite32be);
 EXPORT_SYMBOL(iowrite64);
 EXPORT_SYMBOL(iowrite64be);
+EXPORT_SYMBOL(iowrite64_lo_hi);
 EXPORT_SYMBOL(iowrite64_hi_lo);
 EXPORT_SYMBOL(ioread8_rep);
 EXPORT_SYMBOL(ioread16_rep);
diff --git a/arch/parisc/mm/init.c b/arch/parisc/mm/init.c
index 65f50f072a87..e5c18313b5d4 100644
--- a/arch/parisc/mm/init.c
+++ b/arch/parisc/mm/init.c
@@ -341,9 +341,9 @@ static void __init setup_bootmem(void)
 
 static bool kernel_set_to_readonly;
 
-static void __init map_pages(unsigned long start_vaddr,
-			     unsigned long start_paddr, unsigned long size,
-			     pgprot_t pgprot, int force)
+static void __ref map_pages(unsigned long start_vaddr,
+			    unsigned long start_paddr, unsigned long size,
+			    pgprot_t pgprot, int force)
 {
 	pmd_t *pmd;
 	pte_t *pg_table;
@@ -453,7 +453,7 @@ void __init set_kernel_text_rw(int enable_read_write)
 	flush_tlb_all();
 }
 
-void __ref free_initmem(void)
+void free_initmem(void)
 {
 	unsigned long init_begin = (unsigned long)__init_begin;
 	unsigned long init_end = (unsigned long)__init_end;
@@ -467,7 +467,6 @@ void __ref free_initmem(void)
 	/* The init text pages are marked R-X.  We have to
 	 * flush the icache and mark them RW-
 	 *
-	 * This is tricky, because map_pages is in the init section.
 	 * Do a dummy remap of the data section first (the data
 	 * section is already PAGE_KERNEL) to pull in the TLB entries
 	 * for map_kernel */
diff --git a/arch/powerpc/kernel/head_book3s_32.S b/arch/powerpc/kernel/head_book3s_32.S
index 68e5c0a7e99d..2e2a8211b17b 100644
--- a/arch/powerpc/kernel/head_book3s_32.S
+++ b/arch/powerpc/kernel/head_book3s_32.S
@@ -421,14 +421,14 @@ InstructionTLBMiss:
  */
 	/* Get PTE (linux-style) and check access */
 	mfspr	r3,SPRN_IMISS
-#ifdef CONFIG_MODULES
+#if defined(CONFIG_MODULES) || defined(CONFIG_DEBUG_PAGEALLOC) || defined(CONFIG_KFENCE)
 	lis	r1, TASK_SIZE@h		/* check if kernel address */
 	cmplw	0,r1,r3
 #endif
 	mfspr	r2, SPRN_SDR1
 	li	r1,_PAGE_PRESENT | _PAGE_ACCESSED | _PAGE_EXEC | _PAGE_USER
 	rlwinm	r2, r2, 28, 0xfffff000
-#ifdef CONFIG_MODULES
+#if defined(CONFIG_MODULES) || defined(CONFIG_DEBUG_PAGEALLOC) || defined(CONFIG_KFENCE)
 	bgt-	112f
 	lis	r2, (swapper_pg_dir - PAGE_OFFSET)@ha	/* if kernel address, use */
 	li	r1,_PAGE_PRESENT | _PAGE_ACCESSED | _PAGE_EXEC
diff --git a/arch/powerpc/lib/sstep.c b/arch/powerpc/lib/sstep.c
index d8d5f901cee1..d8cc49f39fe4 100644
--- a/arch/powerpc/lib/sstep.c
+++ b/arch/powerpc/lib/sstep.c
@@ -3181,12 +3181,14 @@ void emulate_update_regs(struct pt_regs *regs, struct instruction_op *op)
 		case BARRIER_EIEIO:
 			eieio();
 			break;
+#ifdef CONFIG_PPC64
 		case BARRIER_LWSYNC:
 			asm volatile("lwsync" : : : "memory");
 			break;
 		case BARRIER_PTESYNC:
 			asm volatile("ptesync" : : : "memory");
 			break;
+#endif
 		}
 		break;
 
diff --git a/arch/x86/include/asm/bug.h b/arch/x86/include/asm/bug.h
index 84b87538a15d..bab883c0b6fe 100644
--- a/arch/x86/include/asm/bug.h
+++ b/arch/x86/include/asm/bug.h
@@ -22,7 +22,7 @@
 
 #ifdef CONFIG_DEBUG_BUGVERBOSE
 
-#define _BUG_FLAGS(ins, flags)						\
+#define _BUG_FLAGS(ins, flags, extra)					\
 do {									\
 	asm_inline volatile("1:\t" ins "\n"				\
 		     ".pushsection __bug_table,\"aw\"\n"		\
@@ -31,7 +31,8 @@ do {									\
 		     "\t.word %c1"        "\t# bug_entry::line\n"	\
 		     "\t.word %c2"        "\t# bug_entry::flags\n"	\
 		     "\t.org 2b+%c3\n"					\
-		     ".popsection"					\
+		     ".popsection\n"					\
+		     extra						\
 		     : : "i" (__FILE__), "i" (__LINE__),		\
 			 "i" (flags),					\
 			 "i" (sizeof(struct bug_entry)));		\
@@ -39,14 +40,15 @@ do {									\
 
 #else /* !CONFIG_DEBUG_BUGVERBOSE */
 
-#define _BUG_FLAGS(ins, flags)						\
+#define _BUG_FLAGS(ins, flags, extra)					\
 do {									\
 	asm_inline volatile("1:\t" ins "\n"				\
 		     ".pushsection __bug_table,\"aw\"\n"		\
 		     "2:\t" __BUG_REL(1b) "\t# bug_entry::bug_addr\n"	\
 		     "\t.word %c0"        "\t# bug_entry::flags\n"	\
 		     "\t.org 2b+%c1\n"					\
-		     ".popsection"					\
+		     ".popsection\n"					\
+		     extra						\
 		     : : "i" (flags),					\
 			 "i" (sizeof(struct bug_entry)));		\
 } while (0)
@@ -55,7 +57,7 @@ do {									\
 
 #else
 
-#define _BUG_FLAGS(ins, flags)  asm volatile(ins)
+#define _BUG_FLAGS(ins, flags, extra)  asm volatile(ins)
 
 #endif /* CONFIG_GENERIC_BUG */
 
@@ -63,8 +65,8 @@ do {									\
 #define BUG()							\
 do {								\
 	instrumentation_begin();				\
-	_BUG_FLAGS(ASM_UD2, 0);					\
-	unreachable();						\
+	_BUG_FLAGS(ASM_UD2, 0, "");				\
+	__builtin_unreachable();				\
 } while (0)
 
 /*
@@ -75,9 +77,9 @@ do {								\
  */
 #define __WARN_FLAGS(flags)					\
 do {								\
+	__auto_type f = BUGFLAG_WARNING|(flags);		\
 	instrumentation_begin();				\
-	_BUG_FLAGS(ASM_UD2, BUGFLAG_WARNING|(flags));		\
-	annotate_reachable();					\
+	_BUG_FLAGS(ASM_UD2, f, ASM_REACHABLE);			\
 	instrumentation_end();					\
 } while (0)
 
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 0772bad9165c..f256f01056bd 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -95,7 +95,7 @@ static void kvm_perf_overflow_intr(struct perf_event *perf_event,
 }
 
 static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
-				  unsigned config, bool exclude_user,
+				  u64 config, bool exclude_user,
 				  bool exclude_kernel, bool intr,
 				  bool in_tx, bool in_tx_cp)
 {
@@ -173,8 +173,8 @@ static bool pmc_resume_counter(struct kvm_pmc *pmc)
 
 void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
 {
-	unsigned config, type = PERF_TYPE_RAW;
-	u8 event_select, unit_mask;
+	u64 config;
+	u32 type = PERF_TYPE_RAW;
 	struct kvm *kvm = pmc->vcpu->kvm;
 	struct kvm_pmu_event_filter *filter;
 	int i;
@@ -206,23 +206,18 @@ void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
 	if (!allow_event)
 		return;
 
-	event_select = eventsel & ARCH_PERFMON_EVENTSEL_EVENT;
-	unit_mask = (eventsel & ARCH_PERFMON_EVENTSEL_UMASK) >> 8;
-
 	if (!(eventsel & (ARCH_PERFMON_EVENTSEL_EDGE |
 			  ARCH_PERFMON_EVENTSEL_INV |
 			  ARCH_PERFMON_EVENTSEL_CMASK |
 			  HSW_IN_TX |
 			  HSW_IN_TX_CHECKPOINTED))) {
-		config = kvm_x86_ops.pmu_ops->find_arch_event(pmc_to_pmu(pmc),
-						      event_select,
-						      unit_mask);
+		config = kvm_x86_ops.pmu_ops->pmc_perf_hw_id(pmc);
 		if (config != PERF_COUNT_HW_MAX)
 			type = PERF_TYPE_HARDWARE;
 	}
 
 	if (type == PERF_TYPE_RAW)
-		config = eventsel & X86_RAW_EVENT_MASK;
+		config = eventsel & AMD64_RAW_EVENT_MASK;
 
 	if (pmc->current_config == eventsel && pmc_resume_counter(pmc))
 		return;
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 0e4f2b1fa9fb..a06d95165ac7 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -24,8 +24,7 @@ struct kvm_event_hw_type_mapping {
 };
 
 struct kvm_pmu_ops {
-	unsigned (*find_arch_event)(struct kvm_pmu *pmu, u8 event_select,
-				    u8 unit_mask);
+	unsigned int (*pmc_perf_hw_id)(struct kvm_pmc *pmc);
 	unsigned (*find_fixed_event)(int idx);
 	bool (*pmc_is_enabled)(struct kvm_pmc *pmc);
 	struct kvm_pmc *(*pmc_idx_to_pmc)(struct kvm_pmu *pmu, int pmc_idx);
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 2fb6a6f00290..cdbb48e12745 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -342,8 +342,6 @@ int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu)
 		avic_kick_target_vcpus(vcpu->kvm, apic, icrl, icrh);
 		break;
 	case AVIC_IPI_FAILURE_INVALID_TARGET:
-		WARN_ONCE(1, "Invalid IPI target: index=%u, vcpu=%d, icr=%#0x:%#0x\n",
-			  index, vcpu->vcpu_id, icrh, icrl);
 		break;
 	case AVIC_IPI_FAILURE_INVALID_BACKING_PAGE:
 		WARN_ONCE(1, "Invalid backing page\n");
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index de80ae42d044..556e7a3f3562 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1357,18 +1357,6 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	    !nested_vmcb_valid_sregs(vcpu, save))
 		goto out_free;
 
-	/*
-	 * While the nested guest CR3 is already checked and set by
-	 * KVM_SET_SREGS, it was set when nested state was yet loaded,
-	 * thus MMU might not be initialized correctly.
-	 * Set it again to fix this.
-	 */
-
-	ret = nested_svm_load_cr3(&svm->vcpu, vcpu->arch.cr3,
-				  nested_npt_enabled(svm), false);
-	if (WARN_ON_ONCE(ret))
-		goto out_free;
-
 
 	/*
 	 * All checks done, we can enter guest mode. Userspace provides
@@ -1394,6 +1382,20 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 
 	svm_switch_vmcb(svm, &svm->nested.vmcb02);
 	nested_vmcb02_prepare_control(svm);
+
+	/*
+	 * While the nested guest CR3 is already checked and set by
+	 * KVM_SET_SREGS, it was set when nested state was yet loaded,
+	 * thus MMU might not be initialized correctly.
+	 * Set it again to fix this.
+	 */
+
+	ret = nested_svm_load_cr3(&svm->vcpu, vcpu->arch.cr3,
+				  nested_npt_enabled(svm), false);
+	if (WARN_ON_ONCE(ret))
+		goto out_free;
+
+
 	kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
 	ret = 0;
 out_free:
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index e152241d1d70..06f8034f62e4 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -134,10 +134,10 @@ static inline struct kvm_pmc *get_gp_pmc_amd(struct kvm_pmu *pmu, u32 msr,
 	return &pmu->gp_counters[msr_to_index(msr)];
 }
 
-static unsigned amd_find_arch_event(struct kvm_pmu *pmu,
-				    u8 event_select,
-				    u8 unit_mask)
+static unsigned int amd_pmc_perf_hw_id(struct kvm_pmc *pmc)
 {
+	u8 event_select = pmc->eventsel & ARCH_PERFMON_EVENTSEL_EVENT;
+	u8 unit_mask = (pmc->eventsel & ARCH_PERFMON_EVENTSEL_UMASK) >> 8;
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(amd_event_mapping); i++)
@@ -320,7 +320,7 @@ static void amd_pmu_reset(struct kvm_vcpu *vcpu)
 }
 
 struct kvm_pmu_ops amd_pmu_ops = {
-	.find_arch_event = amd_find_arch_event,
+	.pmc_perf_hw_id = amd_pmc_perf_hw_id,
 	.find_fixed_event = amd_find_fixed_event,
 	.pmc_is_enabled = amd_pmc_is_enabled,
 	.pmc_idx_to_pmc = amd_pmc_idx_to_pmc,
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f05aa7290267..26f2da1590ed 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1727,6 +1727,7 @@ void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	u64 hcr0 = cr0;
+	bool old_paging = is_paging(vcpu);
 
 #ifdef CONFIG_X86_64
 	if (vcpu->arch.efer & EFER_LME && !vcpu->arch.guest_state_protected) {
@@ -1743,8 +1744,11 @@ void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 #endif
 	vcpu->arch.cr0 = cr0;
 
-	if (!npt_enabled)
+	if (!npt_enabled) {
 		hcr0 |= X86_CR0_PG | X86_CR0_WP;
+		if (old_paging != is_paging(vcpu))
+			svm_set_cr4(vcpu, kvm_read_cr4(vcpu));
+	}
 
 	/*
 	 * re-enable caching here because the QEMU bios
@@ -1788,8 +1792,12 @@ void svm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 		svm_flush_tlb(vcpu);
 
 	vcpu->arch.cr4 = cr4;
-	if (!npt_enabled)
+	if (!npt_enabled) {
 		cr4 |= X86_CR4_PAE;
+
+		if (!is_paging(vcpu))
+			cr4 &= ~(X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_PKE);
+	}
 	cr4 |= host_cr4_mce;
 	to_svm(vcpu)->vmcb->save.cr4 = cr4;
 	vmcb_mark_dirty(to_svm(vcpu)->vmcb, VMCB_CR);
@@ -4384,10 +4392,17 @@ static int svm_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 	 * Enter the nested guest now
 	 */
 
+	vmcb_mark_all_dirty(svm->vmcb01.ptr);
+
 	vmcb12 = map.hva;
 	nested_load_control_from_vmcb12(svm, &vmcb12->control);
 	ret = enter_svm_guest_mode(vcpu, vmcb12_gpa, vmcb12, false);
 
+	if (ret)
+		goto unmap_save;
+
+	svm->nested.nested_run_pending = 1;
+
 unmap_save:
 	kvm_vcpu_unmap(vcpu, &map_save, true);
 unmap_map:
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 10cc4f65c4ef..6427d95de01c 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -68,10 +68,11 @@ static void global_ctrl_changed(struct kvm_pmu *pmu, u64 data)
 		reprogram_counter(pmu, bit);
 }
 
-static unsigned intel_find_arch_event(struct kvm_pmu *pmu,
-				      u8 event_select,
-				      u8 unit_mask)
+static unsigned int intel_pmc_perf_hw_id(struct kvm_pmc *pmc)
 {
+	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
+	u8 event_select = pmc->eventsel & ARCH_PERFMON_EVENTSEL_EVENT;
+	u8 unit_mask = (pmc->eventsel & ARCH_PERFMON_EVENTSEL_UMASK) >> 8;
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(intel_arch_events); i++)
@@ -706,7 +707,7 @@ static void intel_pmu_cleanup(struct kvm_vcpu *vcpu)
 }
 
 struct kvm_pmu_ops intel_pmu_ops = {
-	.find_arch_event = intel_find_arch_event,
+	.pmc_perf_hw_id = intel_pmc_perf_hw_id,
 	.find_fixed_event = intel_find_fixed_event,
 	.pmc_is_enabled = intel_pmc_is_enabled,
 	.pmc_idx_to_pmc = intel_pmc_idx_to_pmc,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 44da933a756b..322485ab9271 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7532,6 +7532,7 @@ static int vmx_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 		if (ret)
 			return ret;
 
+		vmx->nested.nested_run_pending = 1;
 		vmx->nested.smm.guest_mode = false;
 	}
 	return 0;
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 0787d6645573..ab9f88de6deb 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -93,32 +93,57 @@ static void kvm_xen_update_runstate(struct kvm_vcpu *v, int state)
 void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, int state)
 {
 	struct kvm_vcpu_xen *vx = &v->arch.xen;
+	struct gfn_to_hva_cache *ghc = &vx->runstate_cache;
+	struct kvm_memslots *slots = kvm_memslots(v->kvm);
+	bool atomic = (state == RUNSTATE_runnable);
 	uint64_t state_entry_time;
-	unsigned int offset;
+	int __user *user_state;
+	uint64_t __user *user_times;
 
 	kvm_xen_update_runstate(v, state);
 
 	if (!vx->runstate_set)
 		return;
 
-	BUILD_BUG_ON(sizeof(struct compat_vcpu_runstate_info) != 0x2c);
+	if (unlikely(slots->generation != ghc->generation || kvm_is_error_hva(ghc->hva)) &&
+	    kvm_gfn_to_hva_cache_init(v->kvm, ghc, ghc->gpa, ghc->len))
+		return;
+
+	/* We made sure it fits in a single page */
+	BUG_ON(!ghc->memslot);
+
+	if (atomic)
+		pagefault_disable();
 
-	offset = offsetof(struct compat_vcpu_runstate_info, state_entry_time);
-#ifdef CONFIG_X86_64
 	/*
-	 * The only difference is alignment of uint64_t in 32-bit.
-	 * So the first field 'state' is accessed directly using
-	 * offsetof() (where its offset happens to be zero), while the
-	 * remaining fields which are all uint64_t, start at 'offset'
-	 * which we tweak here by adding 4.
+	 * The only difference between 32-bit and 64-bit versions of the
+	 * runstate struct us the alignment of uint64_t in 32-bit, which
+	 * means that the 64-bit version has an additional 4 bytes of
+	 * padding after the first field 'state'.
+	 *
+	 * So we use 'int __user *user_state' to point to the state field,
+	 * and 'uint64_t __user *user_times' for runstate_entry_time. So
+	 * the actual array of time[] in each state starts at user_times[1].
 	 */
+	BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, state) != 0);
+	BUILD_BUG_ON(offsetof(struct compat_vcpu_runstate_info, state) != 0);
+	user_state = (int __user *)ghc->hva;
+
+	BUILD_BUG_ON(sizeof(struct compat_vcpu_runstate_info) != 0x2c);
+
+	user_times = (uint64_t __user *)(ghc->hva +
+					 offsetof(struct compat_vcpu_runstate_info,
+						  state_entry_time));
+#ifdef CONFIG_X86_64
 	BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, state_entry_time) !=
 		     offsetof(struct compat_vcpu_runstate_info, state_entry_time) + 4);
 	BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, time) !=
 		     offsetof(struct compat_vcpu_runstate_info, time) + 4);
 
 	if (v->kvm->arch.xen.long_mode)
-		offset = offsetof(struct vcpu_runstate_info, state_entry_time);
+		user_times = (uint64_t __user *)(ghc->hva +
+						 offsetof(struct vcpu_runstate_info,
+							  state_entry_time));
 #endif
 	/*
 	 * First write the updated state_entry_time at the appropriate
@@ -132,10 +157,8 @@ void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, int state)
 	BUILD_BUG_ON(sizeof(((struct compat_vcpu_runstate_info *)0)->state_entry_time) !=
 		     sizeof(state_entry_time));
 
-	if (kvm_write_guest_offset_cached(v->kvm, &v->arch.xen.runstate_cache,
-					  &state_entry_time, offset,
-					  sizeof(state_entry_time)))
-		return;
+	if (__put_user(state_entry_time, user_times))
+		goto out;
 	smp_wmb();
 
 	/*
@@ -149,11 +172,8 @@ void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, int state)
 	BUILD_BUG_ON(sizeof(((struct compat_vcpu_runstate_info *)0)->state) !=
 		     sizeof(vx->current_runstate));
 
-	if (kvm_write_guest_offset_cached(v->kvm, &v->arch.xen.runstate_cache,
-					  &vx->current_runstate,
-					  offsetof(struct vcpu_runstate_info, state),
-					  sizeof(vx->current_runstate)))
-		return;
+	if (__put_user(vx->current_runstate, user_state))
+		goto out;
 
 	/*
 	 * Write the actual runstate times immediately after the
@@ -168,24 +188,23 @@ void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, int state)
 	BUILD_BUG_ON(sizeof(((struct vcpu_runstate_info *)0)->time) !=
 		     sizeof(vx->runstate_times));
 
-	if (kvm_write_guest_offset_cached(v->kvm, &v->arch.xen.runstate_cache,
-					  &vx->runstate_times[0],
-					  offset + sizeof(u64),
-					  sizeof(vx->runstate_times)))
-		return;
-
+	if (__copy_to_user(user_times + 1, vx->runstate_times, sizeof(vx->runstate_times)))
+		goto out;
 	smp_wmb();
 
 	/*
 	 * Finally, clear the XEN_RUNSTATE_UPDATE bit in the guest's
 	 * runstate_entry_time field.
 	 */
-
 	state_entry_time &= ~XEN_RUNSTATE_UPDATE;
-	if (kvm_write_guest_offset_cached(v->kvm, &v->arch.xen.runstate_cache,
-					  &state_entry_time, offset,
-					  sizeof(state_entry_time)))
-		return;
+	__put_user(state_entry_time, user_times);
+	smp_wmb();
+
+ out:
+	mark_page_dirty_in_slot(v->kvm, ghc->memslot, ghc->gpa >> PAGE_SHIFT);
+
+	if (atomic)
+		pagefault_enable();
 }
 
 int __kvm_xen_has_interrupt(struct kvm_vcpu *v)
@@ -337,6 +356,12 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 			break;
 		}
 
+		/* It must fit within a single page */
+		if ((data->u.gpa & ~PAGE_MASK) + sizeof(struct vcpu_info) > PAGE_SIZE) {
+			r = -EINVAL;
+			break;
+		}
+
 		r = kvm_gfn_to_hva_cache_init(vcpu->kvm,
 					      &vcpu->arch.xen.vcpu_info_cache,
 					      data->u.gpa,
@@ -354,6 +379,12 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 			break;
 		}
 
+		/* It must fit within a single page */
+		if ((data->u.gpa & ~PAGE_MASK) + sizeof(struct pvclock_vcpu_time_info) > PAGE_SIZE) {
+			r = -EINVAL;
+			break;
+		}
+
 		r = kvm_gfn_to_hva_cache_init(vcpu->kvm,
 					      &vcpu->arch.xen.vcpu_time_info_cache,
 					      data->u.gpa,
@@ -375,6 +406,12 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 			break;
 		}
 
+		/* It must fit within a single page */
+		if ((data->u.gpa & ~PAGE_MASK) + sizeof(struct vcpu_runstate_info) > PAGE_SIZE) {
+			r = -EINVAL;
+			break;
+		}
+
 		r = kvm_gfn_to_hva_cache_init(vcpu->kvm,
 					      &vcpu->arch.xen.runstate_cache,
 					      data->u.gpa,
diff --git a/arch/x86/xen/enlighten_pv.c b/arch/x86/xen/enlighten_pv.c
index a7b7d674f500..133ef31639df 100644
--- a/arch/x86/xen/enlighten_pv.c
+++ b/arch/x86/xen/enlighten_pv.c
@@ -1364,10 +1364,6 @@ asmlinkage __visible void __init xen_start_kernel(void)
 
 		xen_acpi_sleep_register();
 
-		/* Avoid searching for BIOS MP tables */
-		x86_init.mpparse.find_smp_config = x86_init_noop;
-		x86_init.mpparse.get_smp_config = x86_init_uint_noop;
-
 		xen_boot_params_init_edd();
 
 #ifdef CONFIG_ACPI
diff --git a/arch/x86/xen/smp_pv.c b/arch/x86/xen/smp_pv.c
index 7ed56c6075b0..477c484eb202 100644
--- a/arch/x86/xen/smp_pv.c
+++ b/arch/x86/xen/smp_pv.c
@@ -148,28 +148,12 @@ int xen_smp_intr_init_pv(unsigned int cpu)
 	return rc;
 }
 
-static void __init xen_fill_possible_map(void)
-{
-	int i, rc;
-
-	if (xen_initial_domain())
-		return;
-
-	for (i = 0; i < nr_cpu_ids; i++) {
-		rc = HYPERVISOR_vcpu_op(VCPUOP_is_up, i, NULL);
-		if (rc >= 0) {
-			num_processors++;
-			set_cpu_possible(i, true);
-		}
-	}
-}
-
-static void __init xen_filter_cpu_maps(void)
+static void __init _get_smp_config(unsigned int early)
 {
 	int i, rc;
 	unsigned int subtract = 0;
 
-	if (!xen_initial_domain())
+	if (early)
 		return;
 
 	num_processors = 0;
@@ -210,7 +194,6 @@ static void __init xen_pv_smp_prepare_boot_cpu(void)
 		 * sure the old memory can be recycled. */
 		make_lowmem_page_readwrite(xen_initial_gdt);
 
-	xen_filter_cpu_maps();
 	xen_setup_vcpu_info_placement();
 
 	/*
@@ -486,5 +469,8 @@ static const struct smp_ops xen_smp_ops __initconst = {
 void __init xen_smp_init(void)
 {
 	smp_ops = xen_smp_ops;
-	xen_fill_possible_map();
+
+	/* Avoid searching for BIOS MP tables */
+	x86_init.mpparse.find_smp_config = x86_init_noop;
+	x86_init.mpparse.get_smp_config = _get_smp_config;
 }
diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index ea9a086d0498..e66970bf27db 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -6878,6 +6878,8 @@ static void bfq_exit_queue(struct elevator_queue *e)
 	spin_unlock_irq(&bfqd->lock);
 #endif
 
+	wbt_enable_default(bfqd->queue);
+
 	kfree(bfqd);
 }
 
diff --git a/block/blk-core.c b/block/blk-core.c
index d42a0f3ff736..42ac3a985c2d 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -350,13 +350,6 @@ void blk_queue_start_drain(struct request_queue *q)
 	wake_up_all(&q->mq_freeze_wq);
 }
 
-void blk_set_queue_dying(struct request_queue *q)
-{
-	blk_queue_flag_set(QUEUE_FLAG_DYING, q);
-	blk_queue_start_drain(q);
-}
-EXPORT_SYMBOL_GPL(blk_set_queue_dying);
-
 /**
  * blk_cleanup_queue - shutdown a request queue
  * @q: request queue to shutdown
@@ -374,7 +367,8 @@ void blk_cleanup_queue(struct request_queue *q)
 	WARN_ON_ONCE(blk_queue_registered(q));
 
 	/* mark @q DYING, no new request or merges will be allowed afterwards */
-	blk_set_queue_dying(q);
+	blk_queue_flag_set(QUEUE_FLAG_DYING, q);
+	blk_queue_start_drain(q);
 
 	blk_queue_flag_set(QUEUE_FLAG_NOMERGES, q);
 	blk_queue_flag_set(QUEUE_FLAG_NOXMERGES, q);
diff --git a/block/elevator.c b/block/elevator.c
index cd02ae332c4e..1b5e57f6115f 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -523,8 +523,6 @@ void elv_unregister_queue(struct request_queue *q)
 		kobject_del(&e->kobj);
 
 		e->registered = 0;
-		/* Re-enable throttling in case elevator disabled it */
-		wbt_enable_default(q);
 	}
 }
 
diff --git a/block/genhd.c b/block/genhd.c
index de789d1a1e3d..2dcedbe4ef04 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -544,6 +544,20 @@ int device_add_disk(struct device *parent, struct gendisk *disk,
 }
 EXPORT_SYMBOL(device_add_disk);
 
+/**
+ * blk_mark_disk_dead - mark a disk as dead
+ * @disk: disk to mark as dead
+ *
+ * Mark as disk as dead (e.g. surprise removed) and don't accept any new I/O
+ * to this disk.
+ */
+void blk_mark_disk_dead(struct gendisk *disk)
+{
+	set_bit(GD_DEAD, &disk->state);
+	blk_queue_start_drain(disk->queue);
+}
+EXPORT_SYMBOL_GPL(blk_mark_disk_dead);
+
 /**
  * del_gendisk - remove the gendisk
  * @disk: the struct gendisk to remove
diff --git a/drivers/acpi/x86/s2idle.c b/drivers/acpi/x86/s2idle.c
index 1c48358b43ba..e0185e841b2a 100644
--- a/drivers/acpi/x86/s2idle.c
+++ b/drivers/acpi/x86/s2idle.c
@@ -424,15 +424,11 @@ static int lps0_device_attach(struct acpi_device *adev,
 		mem_sleep_current = PM_SUSPEND_TO_IDLE;
 
 	/*
-	 * Some Intel based LPS0 systems, like ASUS Zenbook UX430UNR/i7-8550U don't
-	 * use intel-hid or intel-vbtn but require the EC GPE to be enabled while
-	 * suspended for certain wakeup devices to work, so mark it as wakeup-capable.
-	 *
-	 * Only enable on !AMD as enabling this universally causes problems for a number
-	 * of AMD based systems.
+	 * Some LPS0 systems, like ASUS Zenbook UX430UNR/i7-8550U, require the
+	 * EC GPE to be enabled while suspended for certain wakeup devices to
+	 * work, so mark it as wakeup-capable.
 	 */
-	if (!acpi_s2idle_vendor_amd())
-		acpi_ec_mark_gpe_for_wake();
+	acpi_ec_mark_gpe_for_wake();
 
 	return 0;
 }
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 4d848cfc406f..24b67d78cb83 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4014,6 +4014,7 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 
 	/* devices that don't properly handle TRIM commands */
 	{ "SuperSSpeed S238*",		NULL,	ATA_HORKAGE_NOTRIM, },
+	{ "M88V29*",			NULL,	ATA_HORKAGE_NOTRIM, },
 
 	/*
 	 * As defined, the DRAT (Deterministic Read After Trim) and RZAT
diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 901855717cb5..ba61e72741ea 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -4112,7 +4112,7 @@ static void mtip_pci_remove(struct pci_dev *pdev)
 			"Completion workers still active!\n");
 	}
 
-	blk_set_queue_dying(dd->queue);
+	blk_mark_disk_dead(dd->disk);
 	set_bit(MTIP_DDF_REMOVE_PENDING_BIT, &dd->dd_flag);
 
 	/* Clean up the block layer. */
diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index e65c9d706f6f..c4a52f33604d 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -7182,7 +7182,7 @@ static ssize_t do_rbd_remove(struct bus_type *bus,
 		 * IO to complete/fail.
 		 */
 		blk_mq_freeze_queue(rbd_dev->disk->queue);
-		blk_set_queue_dying(rbd_dev->disk->queue);
+		blk_mark_disk_dead(rbd_dev->disk);
 	}
 
 	del_gendisk(rbd_dev->disk);
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 4dbb71230d6e..3efd34195983 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -2128,7 +2128,7 @@ static void blkfront_closing(struct blkfront_info *info)
 
 	/* No more blkif_request(). */
 	blk_mq_stop_hw_queues(info->rq);
-	blk_set_queue_dying(info->rq);
+	blk_mark_disk_dead(info->gd);
 	set_capacity(info->gd, 0);
 
 	for_each_rinfo(info, rinfo, i) {
diff --git a/drivers/char/random.c b/drivers/char/random.c
index a27ae3999ff3..ebe86de9d0ac 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1963,7 +1963,10 @@ static long random_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
 		 */
 		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;
-		input_pool.entropy_count = 0;
+		if (xchg(&input_pool.entropy_count, 0) && random_write_wakeup_bits) {
+			wake_up_interruptible(&random_write_wait);
+			kill_fasync(&fasync, SIGIO, POLL_OUT);
+		}
 		return 0;
 	case RNDRESEEDCRNG:
 		if (!capable(CAP_SYS_ADMIN))
diff --git a/drivers/dma/ptdma/ptdma-dev.c b/drivers/dma/ptdma/ptdma-dev.c
index 8a6bf291a73f..daafea5bc35d 100644
--- a/drivers/dma/ptdma/ptdma-dev.c
+++ b/drivers/dma/ptdma/ptdma-dev.c
@@ -207,7 +207,7 @@ int pt_core_init(struct pt_device *pt)
 	if (!cmd_q->qbase) {
 		dev_err(dev, "unable to allocate command queue\n");
 		ret = -ENOMEM;
-		goto e_dma_alloc;
+		goto e_destroy_pool;
 	}
 
 	cmd_q->qidx = 0;
@@ -229,8 +229,10 @@ int pt_core_init(struct pt_device *pt)
 
 	/* Request an irq */
 	ret = request_irq(pt->pt_irq, pt_core_irq_handler, 0, dev_name(pt->dev), pt);
-	if (ret)
-		goto e_pool;
+	if (ret) {
+		dev_err(dev, "unable to allocate an IRQ\n");
+		goto e_free_dma;
+	}
 
 	/* Update the device registers with queue information. */
 	cmd_q->qcontrol &= ~CMD_Q_SIZE;
@@ -250,21 +252,20 @@ int pt_core_init(struct pt_device *pt)
 	/* Register the DMA engine support */
 	ret = pt_dmaengine_register(pt);
 	if (ret)
-		goto e_dmaengine;
+		goto e_free_irq;
 
 	/* Set up debugfs entries */
 	ptdma_debugfs_setup(pt);
 
 	return 0;
 
-e_dmaengine:
+e_free_irq:
 	free_irq(pt->pt_irq, pt);
 
-e_dma_alloc:
+e_free_dma:
 	dma_free_coherent(dev, cmd_q->qsize, cmd_q->qbase, cmd_q->qbase_dma);
 
-e_pool:
-	dev_err(dev, "unable to allocate an IRQ\n");
+e_destroy_pool:
 	dma_pool_destroy(pt->cmd_q.dma_pool);
 
 	return ret;
diff --git a/drivers/dma/sh/rcar-dmac.c b/drivers/dma/sh/rcar-dmac.c
index 6885b3dcd7a9..f4c46b3b6d9d 100644
--- a/drivers/dma/sh/rcar-dmac.c
+++ b/drivers/dma/sh/rcar-dmac.c
@@ -1868,8 +1868,13 @@ static int rcar_dmac_probe(struct platform_device *pdev)
 
 	dmac->dev = &pdev->dev;
 	platform_set_drvdata(pdev, dmac);
-	dma_set_max_seg_size(dmac->dev, RCAR_DMATCR_MASK);
-	dma_set_mask_and_coherent(dmac->dev, DMA_BIT_MASK(40));
+	ret = dma_set_max_seg_size(dmac->dev, RCAR_DMATCR_MASK);
+	if (ret)
+		return ret;
+
+	ret = dma_set_mask_and_coherent(dmac->dev, DMA_BIT_MASK(40));
+	if (ret)
+		return ret;
 
 	ret = rcar_dmac_parse_of(&pdev->dev, dmac);
 	if (ret < 0)
diff --git a/drivers/dma/stm32-dmamux.c b/drivers/dma/stm32-dmamux.c
index a42164389ebc..d5d55732adba 100644
--- a/drivers/dma/stm32-dmamux.c
+++ b/drivers/dma/stm32-dmamux.c
@@ -292,10 +292,12 @@ static int stm32_dmamux_probe(struct platform_device *pdev)
 	ret = of_dma_router_register(node, stm32_dmamux_route_allocate,
 				     &stm32_dmamux->dmarouter);
 	if (ret)
-		goto err_clk;
+		goto pm_disable;
 
 	return 0;
 
+pm_disable:
+	pm_runtime_disable(&pdev->dev);
 err_clk:
 	clk_disable_unprepare(stm32_dmamux->clk);
 
diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index 2c5975674723..a859ddd9d4a1 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -215,7 +215,7 @@ void *edac_align_ptr(void **p, unsigned int size, int n_elems)
 	else
 		return (char *)ptr;
 
-	r = (unsigned long)p % align;
+	r = (unsigned long)ptr % align;
 
 	if (r == 0)
 		return (char *)ptr;
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu.h b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
index f428f94b43c0..7e73ac6fb21d 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
@@ -1397,12 +1397,10 @@ int amdgpu_acpi_smart_shift_update(struct drm_device *dev, enum amdgpu_ss ss_sta
 int amdgpu_acpi_pcie_notify_device_ready(struct amdgpu_device *adev);
 
 void amdgpu_acpi_get_backlight_caps(struct amdgpu_dm_backlight_caps *caps);
-bool amdgpu_acpi_is_s0ix_active(struct amdgpu_device *adev);
 void amdgpu_acpi_detect(void);
 #else
 static inline int amdgpu_acpi_init(struct amdgpu_device *adev) { return 0; }
 static inline void amdgpu_acpi_fini(struct amdgpu_device *adev) { }
-static inline bool amdgpu_acpi_is_s0ix_active(struct amdgpu_device *adev) { return false; }
 static inline void amdgpu_acpi_detect(void) { }
 static inline bool amdgpu_acpi_is_power_shift_control_supported(void) { return false; }
 static inline int amdgpu_acpi_power_shift_control(struct amdgpu_device *adev,
@@ -1411,6 +1409,14 @@ static inline int amdgpu_acpi_smart_shift_update(struct drm_device *dev,
 						 enum amdgpu_ss ss_state) { return 0; }
 #endif
 
+#if defined(CONFIG_ACPI) && defined(CONFIG_SUSPEND)
+bool amdgpu_acpi_is_s3_active(struct amdgpu_device *adev);
+bool amdgpu_acpi_is_s0ix_active(struct amdgpu_device *adev);
+#else
+static inline bool amdgpu_acpi_is_s0ix_active(struct amdgpu_device *adev) { return false; }
+static inline bool amdgpu_acpi_is_s3_active(struct amdgpu_device *adev) { return false; }
+#endif
+
 int amdgpu_cs_find_mapping(struct amdgpu_cs_parser *parser,
 			   uint64_t addr, struct amdgpu_bo **bo,
 			   struct amdgpu_bo_va_mapping **mapping);
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
index 4811b0faafd9..0e12315fa0cb 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
@@ -1031,6 +1031,20 @@ void amdgpu_acpi_detect(void)
 	}
 }
 
+#if IS_ENABLED(CONFIG_SUSPEND)
+/**
+ * amdgpu_acpi_is_s3_active
+ *
+ * @adev: amdgpu_device_pointer
+ *
+ * returns true if supported, false if not.
+ */
+bool amdgpu_acpi_is_s3_active(struct amdgpu_device *adev)
+{
+	return !(adev->flags & AMD_IS_APU) ||
+		(pm_suspend_target_state == PM_SUSPEND_MEM);
+}
+
 /**
  * amdgpu_acpi_is_s0ix_active
  *
@@ -1040,11 +1054,24 @@ void amdgpu_acpi_detect(void)
  */
 bool amdgpu_acpi_is_s0ix_active(struct amdgpu_device *adev)
 {
-#if IS_ENABLED(CONFIG_AMD_PMC) && IS_ENABLED(CONFIG_SUSPEND)
-	if (acpi_gbl_FADT.flags & ACPI_FADT_LOW_POWER_S0) {
-		if (adev->flags & AMD_IS_APU)
-			return pm_suspend_target_state == PM_SUSPEND_TO_IDLE;
+	if (!(adev->flags & AMD_IS_APU) ||
+	    (pm_suspend_target_state != PM_SUSPEND_TO_IDLE))
+		return false;
+
+	if (!(acpi_gbl_FADT.flags & ACPI_FADT_LOW_POWER_S0)) {
+		dev_warn_once(adev->dev,
+			      "Power consumption will be higher as BIOS has not been configured for suspend-to-idle.\n"
+			      "To use suspend-to-idle change the sleep mode in BIOS setup.\n");
+		return false;
 	}
-#endif
+
+#if !IS_ENABLED(CONFIG_AMD_PMC)
+	dev_warn_once(adev->dev,
+		      "Power consumption will be higher as the kernel has not been compiled with CONFIG_AMD_PMC.\n");
 	return false;
+#else
+	return true;
+#endif /* CONFIG_AMD_PMC */
 }
+
+#endif /* CONFIG_SUSPEND */
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index 30059b7db0b2..b7509d3f7c1c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -1499,6 +1499,7 @@ static void amdgpu_drv_delayed_reset_work_handler(struct work_struct *work)
 static int amdgpu_pmops_prepare(struct device *dev)
 {
 	struct drm_device *drm_dev = dev_get_drvdata(dev);
+	struct amdgpu_device *adev = drm_to_adev(drm_dev);
 
 	/* Return a positive number here so
 	 * DPM_FLAG_SMART_SUSPEND works properly
@@ -1506,6 +1507,13 @@ static int amdgpu_pmops_prepare(struct device *dev)
 	if (amdgpu_device_supports_boco(drm_dev))
 		return pm_runtime_suspended(dev);
 
+	/* if we will not support s3 or s2i for the device
+	 *  then skip suspend
+	 */
+	if (!amdgpu_acpi_is_s0ix_active(adev) &&
+	    !amdgpu_acpi_is_s3_active(adev))
+		return 1;
+
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
index 94126dc39688..8132f66177c2 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -1892,7 +1892,7 @@ int amdgpu_copy_buffer(struct amdgpu_ring *ring, uint64_t src_offset,
 	unsigned i;
 	int r;
 
-	if (direct_submit && !ring->sched.ready) {
+	if (!direct_submit && !ring->sched.ready) {
 		DRM_ERROR("Trying to move memory with ring turned off.\n");
 		return -EINVAL;
 	}
diff --git a/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c b/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
index 8931000dcd41..e37948c15769 100644
--- a/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
@@ -2062,6 +2062,10 @@ static int sdma_v4_0_suspend(void *handle)
 {
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
 
+	/* SMU saves SDMA state for us */
+	if (adev->in_s0ix)
+		return 0;
+
 	return sdma_v4_0_hw_fini(adev);
 }
 
@@ -2069,6 +2073,10 @@ static int sdma_v4_0_resume(void *handle)
 {
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
 
+	/* SMU restores SDMA state for us */
+	if (adev->in_s0ix)
+		return 0;
+
 	return sdma_v4_0_hw_init(adev);
 }
 
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 16556ae892d4..5ae9b8133d6d 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -3230,7 +3230,7 @@ static int dcn10_register_irq_handlers(struct amdgpu_device *adev)
 
 	/* Use GRPH_PFLIP interrupt */
 	for (i = DCN_1_0__SRCID__HUBP0_FLIP_INTERRUPT;
-			i <= DCN_1_0__SRCID__HUBP0_FLIP_INTERRUPT + adev->mode_info.num_crtc - 1;
+			i <= DCN_1_0__SRCID__HUBP0_FLIP_INTERRUPT + dc->caps.max_otg_num - 1;
 			i++) {
 		r = amdgpu_irq_add_id(adev, SOC15_IH_CLIENTID_DCE, i, &adev->pageflip_irq);
 		if (r) {
diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn31/dcn31_smu.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn31/dcn31_smu.c
index 162ae7186124..21d2cbc3cbb2 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn31/dcn31_smu.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn31/dcn31_smu.c
@@ -120,7 +120,11 @@ int dcn31_smu_send_msg_with_param(
 	result = dcn31_smu_wait_for_response(clk_mgr, 10, 200000);
 
 	if (result == VBIOSSMC_Result_Failed) {
-		ASSERT(0);
+		if (msg_id == VBIOSSMC_MSG_TransferTableDram2Smu &&
+		    param == TABLE_WATERMARKS)
+			DC_LOG_WARNING("Watermarks table not configured properly by SMU");
+		else
+			ASSERT(0);
 		REG_WRITE(MP1_SMN_C2PMSG_91, VBIOSSMC_Result_OK);
 		return -1;
 	}
diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 1860ccc3f4f2..4fae73478840 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -1118,6 +1118,8 @@ struct dc *dc_create(const struct dc_init_data *init_params)
 
 		dc->caps.max_dp_protocol_version = DP_VERSION_1_4;
 
+		dc->caps.max_otg_num = dc->res_pool->res_cap->num_timing_generator;
+
 		if (dc->res_pool->dmcu != NULL)
 			dc->versions.dmcu_version = dc->res_pool->dmcu->dmcu_version;
 	}
diff --git a/drivers/gpu/drm/amd/display/dc/dc.h b/drivers/gpu/drm/amd/display/dc/dc.h
index 3ab52d9a82cf..e0f58fab5e8e 100644
--- a/drivers/gpu/drm/amd/display/dc/dc.h
+++ b/drivers/gpu/drm/amd/display/dc/dc.h
@@ -185,6 +185,7 @@ struct dc_caps {
 	struct dc_color_caps color;
 	bool vbios_lttpr_aware;
 	bool vbios_lttpr_enable;
+	uint32_t max_otg_num;
 };
 
 struct dc_bug_wa {
diff --git a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hubbub.c b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hubbub.c
index 90c73a1cb986..5e3bcaf12cac 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hubbub.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hubbub.c
@@ -138,8 +138,11 @@ static uint32_t convert_and_clamp(
 	ret_val = wm_ns * refclk_mhz;
 	ret_val /= 1000;
 
-	if (ret_val > clamp_value)
+	if (ret_val > clamp_value) {
+		/* clamping WMs is abnormal, unexpected and may lead to underflow*/
+		ASSERT(0);
 		ret_val = clamp_value;
+	}
 
 	return ret_val;
 }
@@ -159,7 +162,7 @@ static bool hubbub31_program_urgent_watermarks(
 	if (safe_to_lower || watermarks->a.urgent_ns > hubbub2->watermarks.a.urgent_ns) {
 		hubbub2->watermarks.a.urgent_ns = watermarks->a.urgent_ns;
 		prog_wm_value = convert_and_clamp(watermarks->a.urgent_ns,
-				refclk_mhz, 0x1fffff);
+				refclk_mhz, 0x3fff);
 		REG_SET(DCHUBBUB_ARB_DATA_URGENCY_WATERMARK_A, 0,
 				DCHUBBUB_ARB_DATA_URGENCY_WATERMARK_A, prog_wm_value);
 
@@ -193,7 +196,7 @@ static bool hubbub31_program_urgent_watermarks(
 	if (safe_to_lower || watermarks->a.urgent_latency_ns > hubbub2->watermarks.a.urgent_latency_ns) {
 		hubbub2->watermarks.a.urgent_latency_ns = watermarks->a.urgent_latency_ns;
 		prog_wm_value = convert_and_clamp(watermarks->a.urgent_latency_ns,
-				refclk_mhz, 0x1fffff);
+				refclk_mhz, 0x3fff);
 		REG_SET(DCHUBBUB_ARB_REFCYC_PER_TRIP_TO_MEMORY_A, 0,
 				DCHUBBUB_ARB_REFCYC_PER_TRIP_TO_MEMORY_A, prog_wm_value);
 	} else if (watermarks->a.urgent_latency_ns < hubbub2->watermarks.a.urgent_latency_ns)
@@ -203,7 +206,7 @@ static bool hubbub31_program_urgent_watermarks(
 	if (safe_to_lower || watermarks->b.urgent_ns > hubbub2->watermarks.b.urgent_ns) {
 		hubbub2->watermarks.b.urgent_ns = watermarks->b.urgent_ns;
 		prog_wm_value = convert_and_clamp(watermarks->b.urgent_ns,
-				refclk_mhz, 0x1fffff);
+				refclk_mhz, 0x3fff);
 		REG_SET(DCHUBBUB_ARB_DATA_URGENCY_WATERMARK_B, 0,
 				DCHUBBUB_ARB_DATA_URGENCY_WATERMARK_B, prog_wm_value);
 
@@ -237,7 +240,7 @@ static bool hubbub31_program_urgent_watermarks(
 	if (safe_to_lower || watermarks->b.urgent_latency_ns > hubbub2->watermarks.b.urgent_latency_ns) {
 		hubbub2->watermarks.b.urgent_latency_ns = watermarks->b.urgent_latency_ns;
 		prog_wm_value = convert_and_clamp(watermarks->b.urgent_latency_ns,
-				refclk_mhz, 0x1fffff);
+				refclk_mhz, 0x3fff);
 		REG_SET(DCHUBBUB_ARB_REFCYC_PER_TRIP_TO_MEMORY_B, 0,
 				DCHUBBUB_ARB_REFCYC_PER_TRIP_TO_MEMORY_B, prog_wm_value);
 	} else if (watermarks->b.urgent_latency_ns < hubbub2->watermarks.b.urgent_latency_ns)
@@ -247,7 +250,7 @@ static bool hubbub31_program_urgent_watermarks(
 	if (safe_to_lower || watermarks->c.urgent_ns > hubbub2->watermarks.c.urgent_ns) {
 		hubbub2->watermarks.c.urgent_ns = watermarks->c.urgent_ns;
 		prog_wm_value = convert_and_clamp(watermarks->c.urgent_ns,
-				refclk_mhz, 0x1fffff);
+				refclk_mhz, 0x3fff);
 		REG_SET(DCHUBBUB_ARB_DATA_URGENCY_WATERMARK_C, 0,
 				DCHUBBUB_ARB_DATA_URGENCY_WATERMARK_C, prog_wm_value);
 
@@ -281,7 +284,7 @@ static bool hubbub31_program_urgent_watermarks(
 	if (safe_to_lower || watermarks->c.urgent_latency_ns > hubbub2->watermarks.c.urgent_latency_ns) {
 		hubbub2->watermarks.c.urgent_latency_ns = watermarks->c.urgent_latency_ns;
 		prog_wm_value = convert_and_clamp(watermarks->c.urgent_latency_ns,
-				refclk_mhz, 0x1fffff);
+				refclk_mhz, 0x3fff);
 		REG_SET(DCHUBBUB_ARB_REFCYC_PER_TRIP_TO_MEMORY_C, 0,
 				DCHUBBUB_ARB_REFCYC_PER_TRIP_TO_MEMORY_C, prog_wm_value);
 	} else if (watermarks->c.urgent_latency_ns < hubbub2->watermarks.c.urgent_latency_ns)
@@ -291,7 +294,7 @@ static bool hubbub31_program_urgent_watermarks(
 	if (safe_to_lower || watermarks->d.urgent_ns > hubbub2->watermarks.d.urgent_ns) {
 		hubbub2->watermarks.d.urgent_ns = watermarks->d.urgent_ns;
 		prog_wm_value = convert_and_clamp(watermarks->d.urgent_ns,
-				refclk_mhz, 0x1fffff);
+				refclk_mhz, 0x3fff);
 		REG_SET(DCHUBBUB_ARB_DATA_URGENCY_WATERMARK_D, 0,
 				DCHUBBUB_ARB_DATA_URGENCY_WATERMARK_D, prog_wm_value);
 
@@ -325,7 +328,7 @@ static bool hubbub31_program_urgent_watermarks(
 	if (safe_to_lower || watermarks->d.urgent_latency_ns > hubbub2->watermarks.d.urgent_latency_ns) {
 		hubbub2->watermarks.d.urgent_latency_ns = watermarks->d.urgent_latency_ns;
 		prog_wm_value = convert_and_clamp(watermarks->d.urgent_latency_ns,
-				refclk_mhz, 0x1fffff);
+				refclk_mhz, 0x3fff);
 		REG_SET(DCHUBBUB_ARB_REFCYC_PER_TRIP_TO_MEMORY_D, 0,
 				DCHUBBUB_ARB_REFCYC_PER_TRIP_TO_MEMORY_D, prog_wm_value);
 	} else if (watermarks->d.urgent_latency_ns < hubbub2->watermarks.d.urgent_latency_ns)
@@ -351,7 +354,7 @@ static bool hubbub31_program_stutter_watermarks(
 				watermarks->a.cstate_pstate.cstate_enter_plus_exit_ns;
 		prog_wm_value = convert_and_clamp(
 				watermarks->a.cstate_pstate.cstate_enter_plus_exit_ns,
-				refclk_mhz, 0x1fffff);
+				refclk_mhz, 0xffff);
 		REG_SET(DCHUBBUB_ARB_ALLOW_SR_ENTER_WATERMARK_A, 0,
 				DCHUBBUB_ARB_ALLOW_SR_ENTER_WATERMARK_A, prog_wm_value);
 		DC_LOG_BANDWIDTH_CALCS("SR_ENTER_EXIT_WATERMARK_A calculated =%d\n"
@@ -367,7 +370,7 @@ static bool hubbub31_program_stutter_watermarks(
 				watermarks->a.cstate_pstate.cstate_exit_ns;
 		prog_wm_value = convert_and_clamp(
 				watermarks->a.cstate_pstate.cstate_exit_ns,
-				refclk_mhz, 0x1fffff);
+				refclk_mhz, 0xffff);
 		REG_SET(DCHUBBUB_ARB_ALLOW_SR_EXIT_WATERMARK_A, 0,
 				DCHUBBUB_ARB_ALLOW_SR_EXIT_WATERMARK_A, prog_wm_value);
 		DC_LOG_BANDWIDTH_CALCS("SR_EXIT_WATERMARK_A calculated =%d\n"
@@ -383,7 +386,7 @@ static bool hubbub31_program_stutter_watermarks(
 				watermarks->a.cstate_pstate.cstate_enter_plus_exit_z8_ns;
 		prog_wm_value = convert_and_clamp(
 				watermarks->a.cstate_pstate.cstate_enter_plus_exit_z8_ns,
-				refclk_mhz, 0x1fffff);
+				refclk_mhz, 0xffff);
 		REG_SET(DCHUBBUB_ARB_ALLOW_SR_ENTER_WATERMARK_Z8_A, 0,
 				DCHUBBUB_ARB_ALLOW_SR_ENTER_WATERMARK_Z8_A, prog_wm_value);
 		DC_LOG_BANDWIDTH_CALCS("SR_ENTER_WATERMARK_Z8_A calculated =%d\n"
@@ -399,7 +402,7 @@ static bool hubbub31_program_stutter_watermarks(
 				watermarks->a.cstate_pstate.cstate_exit_z8_ns;
 		prog_wm_value = convert_and_clamp(
 				watermarks->a.cstate_pstate.cstate_exit_z8_ns,
-				refclk_mhz, 0x1fffff);
+				refclk_mhz, 0xffff);
 		REG_SET(DCHUBBUB_ARB_ALLOW_SR_EXIT_WATERMARK_Z8_A, 0,
 				DCHUBBUB_ARB_ALLOW_SR_EXIT_WATERMARK_Z8_A, prog_wm_value);
 		DC_LOG_BANDWIDTH_CALCS("SR_EXIT_WATERMARK_Z8_A calculated =%d\n"
@@ -416,7 +419,7 @@ static bool hubbub31_program_stutter_watermarks(
 				watermarks->b.cstate_pstate.cstate_enter_plus_exit_ns;
 		prog_wm_value = convert_and_clamp(
 				watermarks->b.cstate_pstate.cstate_enter_plus_exit_ns,
-				refclk_mhz, 0x1fffff);
+				refclk_mhz, 0xffff);
 		REG_SET(DCHUBBUB_ARB_ALLOW_SR_ENTER_WATERMARK_B, 0,
 				DCHUBBUB_ARB_ALLOW_SR_ENTER_WATERMARK_B, prog_wm_value);
 		DC_LOG_BANDWIDTH_CALCS("SR_ENTER_EXIT_WATERMARK_B calculated =%d\n"
@@ -432,7 +435,7 @@ static bool hubbub31_program_stutter_watermarks(
 				watermarks->b.cstate_pstate.cstate_exit_ns;
 		prog_wm_value = convert_and_clamp(
 				watermarks->b.cstate_pstate.cstate_exit_ns,
-				refclk_mhz, 0x1fffff);
+				refclk_mhz, 0xffff);
 		REG_SET(DCHUBBUB_ARB_ALLOW_SR_EXIT_WATERMARK_B, 0,
 				DCHUBBUB_ARB_ALLOW_SR_EXIT_WATERMARK_B, prog_wm_value);
 		DC_LOG_BANDWIDTH_CALCS("SR_EXIT_WATERMARK_B calculated =%d\n"
@@ -448,7 +451,7 @@ static bool hubbub31_program_stutter_watermarks(
 				watermarks->b.cstate_pstate.cstate_enter_plus_exit_z8_ns;
 		prog_wm_value = convert_and_clamp(
 				watermarks->b.cstate_pstate.cstate_enter_plus_exit_z8_ns,
-				refclk_mhz, 0x1fffff);
+				refclk_mhz, 0xffff);
 		REG_SET(DCHUBBUB_ARB_ALLOW_SR_ENTER_WATERMARK_Z8_B, 0,
 				DCHUBBUB_ARB_ALLOW_SR_ENTER_WATERMARK_Z8_B, prog_wm_value);
 		DC_LOG_BANDWIDTH_CALCS("SR_ENTER_WATERMARK_Z8_B calculated =%d\n"
@@ -464,7 +467,7 @@ static bool hubbub31_program_stutter_watermarks(
 				watermarks->b.cstate_pstate.cstate_exit_z8_ns;
 		prog_wm_value = convert_and_clamp(
 				watermarks->b.cstate_pstate.cstate_exit_z8_ns,
-				refclk_mhz, 0x1fffff);
+				refclk_mhz, 0xffff);
 		REG_SET(DCHUBBUB_ARB_ALLOW_SR_EXIT_WATERMARK_Z8_B, 0,
 				DCHUBBUB_ARB_ALLOW_SR_EXIT_WATERMARK_Z8_B, prog_wm_value);
 		DC_LOG_BANDWIDTH_CALCS("SR_EXIT_WATERMARK_Z8_B calculated =%d\n"
@@ -481,7 +484,7 @@ static bool hubbub31_program_stutter_watermarks(
 				watermarks->c.cstate_pstate.cstate_enter_plus_exit_ns;
 		prog_wm_value = convert_and_clamp(
 				watermarks->c.cstate_pstate.cstate_enter_plus_exit_ns,
-				refclk_mhz, 0x1fffff);
+				refclk_mhz, 0xffff);
 		REG_SET(DCHUBBUB_ARB_ALLOW_SR_ENTER_WATERMARK_C, 0,
 				DCHUBBUB_ARB_ALLOW_SR_ENTER_WATERMARK_C, prog_wm_value);
 		DC_LOG_BANDWIDTH_CALCS("SR_ENTER_EXIT_WATERMARK_C calculated =%d\n"
@@ -497,7 +500,7 @@ static bool hubbub31_program_stutter_watermarks(
 				watermarks->c.cstate_pstate.cstate_exit_ns;
 		prog_wm_value = convert_and_clamp(
 				watermarks->c.cstate_pstate.cstate_exit_ns,
-				refclk_mhz, 0x1fffff);
+				refclk_mhz, 0xffff);
 		REG_SET(DCHUBBUB_ARB_ALLOW_SR_EXIT_WATERMARK_C, 0,
 				DCHUBBUB_ARB_ALLOW_SR_EXIT_WATERMARK_C, prog_wm_value);
 		DC_LOG_BANDWIDTH_CALCS("SR_EXIT_WATERMARK_C calculated =%d\n"
@@ -513,7 +516,7 @@ static bool hubbub31_program_stutter_watermarks(
 				watermarks->c.cstate_pstate.cstate_enter_plus_exit_z8_ns;
 		prog_wm_value = convert_and_clamp(
 				watermarks->c.cstate_pstate.cstate_enter_plus_exit_z8_ns,
-				refclk_mhz, 0x1fffff);
+				refclk_mhz, 0xffff);
 		REG_SET(DCHUBBUB_ARB_ALLOW_SR_ENTER_WATERMARK_Z8_C, 0,
 				DCHUBBUB_ARB_ALLOW_SR_ENTER_WATERMARK_Z8_C, prog_wm_value);
 		DC_LOG_BANDWIDTH_CALCS("SR_ENTER_WATERMARK_Z8_C calculated =%d\n"
@@ -529,7 +532,7 @@ static bool hubbub31_program_stutter_watermarks(
 				watermarks->c.cstate_pstate.cstate_exit_z8_ns;
 		prog_wm_value = convert_and_clamp(
 				watermarks->c.cstate_pstate.cstate_exit_z8_ns,
-				refclk_mhz, 0x1fffff);
+				refclk_mhz, 0xffff);
 		REG_SET(DCHUBBUB_ARB_ALLOW_SR_EXIT_WATERMARK_Z8_C, 0,
 				DCHUBBUB_ARB_ALLOW_SR_EXIT_WATERMARK_Z8_C, prog_wm_value);
 		DC_LOG_BANDWIDTH_CALCS("SR_EXIT_WATERMARK_Z8_C calculated =%d\n"
@@ -546,7 +549,7 @@ static bool hubbub31_program_stutter_watermarks(
 				watermarks->d.cstate_pstate.cstate_enter_plus_exit_ns;
 		prog_wm_value = convert_and_clamp(
 				watermarks->d.cstate_pstate.cstate_enter_plus_exit_ns,
-				refclk_mhz, 0x1fffff);
+				refclk_mhz, 0xffff);
 		REG_SET(DCHUBBUB_ARB_ALLOW_SR_ENTER_WATERMARK_D, 0,
 				DCHUBBUB_ARB_ALLOW_SR_ENTER_WATERMARK_D, prog_wm_value);
 		DC_LOG_BANDWIDTH_CALCS("SR_ENTER_EXIT_WATERMARK_D calculated =%d\n"
@@ -562,7 +565,7 @@ static bool hubbub31_program_stutter_watermarks(
 				watermarks->d.cstate_pstate.cstate_exit_ns;
 		prog_wm_value = convert_and_clamp(
 				watermarks->d.cstate_pstate.cstate_exit_ns,
-				refclk_mhz, 0x1fffff);
+				refclk_mhz, 0xffff);
 		REG_SET(DCHUBBUB_ARB_ALLOW_SR_EXIT_WATERMARK_D, 0,
 				DCHUBBUB_ARB_ALLOW_SR_EXIT_WATERMARK_D, prog_wm_value);
 		DC_LOG_BANDWIDTH_CALCS("SR_EXIT_WATERMARK_D calculated =%d\n"
@@ -578,7 +581,7 @@ static bool hubbub31_program_stutter_watermarks(
 				watermarks->d.cstate_pstate.cstate_enter_plus_exit_z8_ns;
 		prog_wm_value = convert_and_clamp(
 				watermarks->d.cstate_pstate.cstate_enter_plus_exit_z8_ns,
-				refclk_mhz, 0x1fffff);
+				refclk_mhz, 0xffff);
 		REG_SET(DCHUBBUB_ARB_ALLOW_SR_ENTER_WATERMARK_Z8_D, 0,
 				DCHUBBUB_ARB_ALLOW_SR_ENTER_WATERMARK_Z8_D, prog_wm_value);
 		DC_LOG_BANDWIDTH_CALCS("SR_ENTER_WATERMARK_Z8_D calculated =%d\n"
@@ -594,7 +597,7 @@ static bool hubbub31_program_stutter_watermarks(
 				watermarks->d.cstate_pstate.cstate_exit_z8_ns;
 		prog_wm_value = convert_and_clamp(
 				watermarks->d.cstate_pstate.cstate_exit_z8_ns,
-				refclk_mhz, 0x1fffff);
+				refclk_mhz, 0xffff);
 		REG_SET(DCHUBBUB_ARB_ALLOW_SR_EXIT_WATERMARK_Z8_D, 0,
 				DCHUBBUB_ARB_ALLOW_SR_EXIT_WATERMARK_Z8_D, prog_wm_value);
 		DC_LOG_BANDWIDTH_CALCS("SR_EXIT_WATERMARK_Z8_D calculated =%d\n"
@@ -625,7 +628,7 @@ static bool hubbub31_program_pstate_watermarks(
 				watermarks->a.cstate_pstate.pstate_change_ns;
 		prog_wm_value = convert_and_clamp(
 				watermarks->a.cstate_pstate.pstate_change_ns,
-				refclk_mhz, 0x1fffff);
+				refclk_mhz, 0xffff);
 		REG_SET(DCHUBBUB_ARB_ALLOW_DRAM_CLK_CHANGE_WATERMARK_A, 0,
 				DCHUBBUB_ARB_ALLOW_DRAM_CLK_CHANGE_WATERMARK_A, prog_wm_value);
 		DC_LOG_BANDWIDTH_CALCS("DRAM_CLK_CHANGE_WATERMARK_A calculated =%d\n"
@@ -642,7 +645,7 @@ static bool hubbub31_program_pstate_watermarks(
 				watermarks->b.cstate_pstate.pstate_change_ns;
 		prog_wm_value = convert_and_clamp(
 				watermarks->b.cstate_pstate.pstate_change_ns,
-				refclk_mhz, 0x1fffff);
+				refclk_mhz, 0xffff);
 		REG_SET(DCHUBBUB_ARB_ALLOW_DRAM_CLK_CHANGE_WATERMARK_B, 0,
 				DCHUBBUB_ARB_ALLOW_DRAM_CLK_CHANGE_WATERMARK_B, prog_wm_value);
 		DC_LOG_BANDWIDTH_CALCS("DRAM_CLK_CHANGE_WATERMARK_B calculated =%d\n"
@@ -659,7 +662,7 @@ static bool hubbub31_program_pstate_watermarks(
 				watermarks->c.cstate_pstate.pstate_change_ns;
 		prog_wm_value = convert_and_clamp(
 				watermarks->c.cstate_pstate.pstate_change_ns,
-				refclk_mhz, 0x1fffff);
+				refclk_mhz, 0xffff);
 		REG_SET(DCHUBBUB_ARB_ALLOW_DRAM_CLK_CHANGE_WATERMARK_C, 0,
 				DCHUBBUB_ARB_ALLOW_DRAM_CLK_CHANGE_WATERMARK_C, prog_wm_value);
 		DC_LOG_BANDWIDTH_CALCS("DRAM_CLK_CHANGE_WATERMARK_C calculated =%d\n"
@@ -676,7 +679,7 @@ static bool hubbub31_program_pstate_watermarks(
 				watermarks->d.cstate_pstate.pstate_change_ns;
 		prog_wm_value = convert_and_clamp(
 				watermarks->d.cstate_pstate.pstate_change_ns,
-				refclk_mhz, 0x1fffff);
+				refclk_mhz, 0xffff);
 		REG_SET(DCHUBBUB_ARB_ALLOW_DRAM_CLK_CHANGE_WATERMARK_D, 0,
 				DCHUBBUB_ARB_ALLOW_DRAM_CLK_CHANGE_WATERMARK_D, prog_wm_value);
 		DC_LOG_BANDWIDTH_CALCS("DRAM_CLK_CHANGE_WATERMARK_D calculated =%d\n"
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/yellow_carp_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/yellow_carp_ppt.c
index a403657151ba..0e1a843608e4 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/yellow_carp_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/yellow_carp_ppt.c
@@ -291,14 +291,9 @@ static int yellow_carp_post_smu_init(struct smu_context *smu)
 
 static int yellow_carp_mode_reset(struct smu_context *smu, int type)
 {
-	int ret = 0, index = 0;
-
-	index = smu_cmn_to_asic_specific_index(smu, CMN2ASIC_MAPPING_MSG,
-				SMU_MSG_GfxDeviceDriverReset);
-	if (index < 0)
-		return index == -EACCES ? 0 : index;
+	int ret = 0;
 
-	ret = smu_cmn_send_smc_msg_with_param(smu, (uint16_t)index, type, NULL);
+	ret = smu_cmn_send_smc_msg_with_param(smu, SMU_MSG_GfxDeviceDriverReset, type, NULL);
 	if (ret)
 		dev_err(smu->adev->dev, "Failed to mode reset!\n");
 
diff --git a/drivers/gpu/drm/drm_atomic_uapi.c b/drivers/gpu/drm/drm_atomic_uapi.c
index 909f31833181..f195c7013137 100644
--- a/drivers/gpu/drm/drm_atomic_uapi.c
+++ b/drivers/gpu/drm/drm_atomic_uapi.c
@@ -76,15 +76,17 @@ int drm_atomic_set_mode_for_crtc(struct drm_crtc_state *state,
 	state->mode_blob = NULL;
 
 	if (mode) {
+		struct drm_property_blob *blob;
+
 		drm_mode_convert_to_umode(&umode, mode);
-		state->mode_blob =
-			drm_property_create_blob(state->crtc->dev,
-						 sizeof(umode),
-						 &umode);
-		if (IS_ERR(state->mode_blob))
-			return PTR_ERR(state->mode_blob);
+		blob = drm_property_create_blob(crtc->dev,
+						sizeof(umode), &umode);
+		if (IS_ERR(blob))
+			return PTR_ERR(blob);
 
 		drm_mode_copy(&state->mode, mode);
+
+		state->mode_blob = blob;
 		state->enable = true;
 		drm_dbg_atomic(crtc->dev,
 			       "Set [MODE:%s] for [CRTC:%d:%s] state %p\n",
diff --git a/drivers/gpu/drm/drm_gem_cma_helper.c b/drivers/gpu/drm/drm_gem_cma_helper.c
index 9d05674550a4..6533efa84020 100644
--- a/drivers/gpu/drm/drm_gem_cma_helper.c
+++ b/drivers/gpu/drm/drm_gem_cma_helper.c
@@ -515,6 +515,7 @@ int drm_gem_cma_mmap(struct drm_gem_object *obj, struct vm_area_struct *vma)
 	 */
 	vma->vm_pgoff -= drm_vma_node_start(&obj->vma_node);
 	vma->vm_flags &= ~VM_PFNMAP;
+	vma->vm_flags |= VM_DONTEXPAND;
 
 	cma_obj = to_drm_gem_cma_obj(obj);
 
diff --git a/drivers/gpu/drm/i915/Kconfig b/drivers/gpu/drm/i915/Kconfig
index f960f5d7664e..fe6b34774483 100644
--- a/drivers/gpu/drm/i915/Kconfig
+++ b/drivers/gpu/drm/i915/Kconfig
@@ -101,6 +101,7 @@ config DRM_I915_USERPTR
 config DRM_I915_GVT
 	bool "Enable Intel GVT-g graphics virtualization host support"
 	depends on DRM_I915
+	depends on X86
 	depends on 64BIT
 	default n
 	help
diff --git a/drivers/gpu/drm/i915/display/intel_opregion.c b/drivers/gpu/drm/i915/display/intel_opregion.c
index 3855fba70980..f7f49b69830f 100644
--- a/drivers/gpu/drm/i915/display/intel_opregion.c
+++ b/drivers/gpu/drm/i915/display/intel_opregion.c
@@ -361,6 +361,21 @@ int intel_opregion_notify_encoder(struct intel_encoder *intel_encoder,
 		port++;
 	}
 
+	/*
+	 * The port numbering and mapping here is bizarre. The now-obsolete
+	 * swsci spec supports ports numbered [0..4]. Port E is handled as a
+	 * special case, but port F and beyond are not. The functionality is
+	 * supposed to be obsolete for new platforms. Just bail out if the port
+	 * number is out of bounds after mapping.
+	 */
+	if (port > 4) {
+		drm_dbg_kms(&dev_priv->drm,
+			    "[ENCODER:%d:%s] port %c (index %u) out of bounds for display power state notification\n",
+			    intel_encoder->base.base.id, intel_encoder->base.name,
+			    port_name(intel_encoder->port), port);
+		return -EINVAL;
+	}
+
 	if (!enable)
 		parm |= 4 << 8;
 
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_ttm.c b/drivers/gpu/drm/i915/gem/i915_gem_ttm.c
index 6ea13159bffc..4b823fbfe76a 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_ttm.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_ttm.c
@@ -759,11 +759,9 @@ static void i915_ttm_adjust_lru(struct drm_i915_gem_object *obj)
 	if (obj->mm.madv != I915_MADV_WILLNEED) {
 		bo->priority = I915_TTM_PRIO_PURGE;
 	} else if (!i915_gem_object_has_pages(obj)) {
-		if (bo->priority < I915_TTM_PRIO_HAS_PAGES)
-			bo->priority = I915_TTM_PRIO_HAS_PAGES;
+		bo->priority = I915_TTM_PRIO_NO_PAGES;
 	} else {
-		if (bo->priority > I915_TTM_PRIO_NO_PAGES)
-			bo->priority = I915_TTM_PRIO_NO_PAGES;
+		bo->priority = I915_TTM_PRIO_HAS_PAGES;
 	}
 
 	ttm_bo_move_to_lru_tail(bo, bo->resource, NULL);
diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
index aea4cc2b3486..8937bc8985d6 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -4844,7 +4844,7 @@ static bool check_mbus_joined(u8 active_pipes,
 {
 	int i;
 
-	for (i = 0; i < dbuf_slices[i].active_pipes; i++) {
+	for (i = 0; dbuf_slices[i].active_pipes != 0; i++) {
 		if (dbuf_slices[i].active_pipes == active_pipes)
 			return dbuf_slices[i].join_mbus;
 	}
@@ -4861,7 +4861,7 @@ static u8 compute_dbuf_slices(enum pipe pipe, u8 active_pipes, bool join_mbus,
 {
 	int i;
 
-	for (i = 0; i < dbuf_slices[i].active_pipes; i++) {
+	for (i = 0; dbuf_slices[i].active_pipes != 0; i++) {
 		if (dbuf_slices[i].active_pipes == active_pipes &&
 		    dbuf_slices[i].join_mbus == join_mbus)
 			return dbuf_slices[i].dbuf_mask[pipe];
diff --git a/drivers/gpu/drm/nouveau/nvkm/falcon/base.c b/drivers/gpu/drm/nouveau/nvkm/falcon/base.c
index 262641a014b0..c91130a6be2a 100644
--- a/drivers/gpu/drm/nouveau/nvkm/falcon/base.c
+++ b/drivers/gpu/drm/nouveau/nvkm/falcon/base.c
@@ -117,8 +117,12 @@ nvkm_falcon_disable(struct nvkm_falcon *falcon)
 int
 nvkm_falcon_reset(struct nvkm_falcon *falcon)
 {
-	nvkm_falcon_disable(falcon);
-	return nvkm_falcon_enable(falcon);
+	if (!falcon->func->reset) {
+		nvkm_falcon_disable(falcon);
+		return nvkm_falcon_enable(falcon);
+	}
+
+	return falcon->func->reset(falcon);
 }
 
 int
diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gm200.c b/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gm200.c
index 5968c7696596..40439e329aa9 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gm200.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gm200.c
@@ -23,9 +23,38 @@
  */
 #include "priv.h"
 
+static int
+gm200_pmu_flcn_reset(struct nvkm_falcon *falcon)
+{
+	struct nvkm_pmu *pmu = container_of(falcon, typeof(*pmu), falcon);
+
+	nvkm_falcon_wr32(falcon, 0x014, 0x0000ffff);
+	pmu->func->reset(pmu);
+	return nvkm_falcon_enable(falcon);
+}
+
+const struct nvkm_falcon_func
+gm200_pmu_flcn = {
+	.debug = 0xc08,
+	.fbif = 0xe00,
+	.load_imem = nvkm_falcon_v1_load_imem,
+	.load_dmem = nvkm_falcon_v1_load_dmem,
+	.read_dmem = nvkm_falcon_v1_read_dmem,
+	.bind_context = nvkm_falcon_v1_bind_context,
+	.wait_for_halt = nvkm_falcon_v1_wait_for_halt,
+	.clear_interrupt = nvkm_falcon_v1_clear_interrupt,
+	.set_start_addr = nvkm_falcon_v1_set_start_addr,
+	.start = nvkm_falcon_v1_start,
+	.enable = nvkm_falcon_v1_enable,
+	.disable = nvkm_falcon_v1_disable,
+	.reset = gm200_pmu_flcn_reset,
+	.cmdq = { 0x4a0, 0x4b0, 4 },
+	.msgq = { 0x4c8, 0x4cc, 0 },
+};
+
 static const struct nvkm_pmu_func
 gm200_pmu = {
-	.flcn = &gt215_pmu_flcn,
+	.flcn = &gm200_pmu_flcn,
 	.enabled = gf100_pmu_enabled,
 	.reset = gf100_pmu_reset,
 };
diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gm20b.c b/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gm20b.c
index 148706977eec..e1772211b0a4 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gm20b.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gm20b.c
@@ -211,7 +211,7 @@ gm20b_pmu_recv(struct nvkm_pmu *pmu)
 
 static const struct nvkm_pmu_func
 gm20b_pmu = {
-	.flcn = &gt215_pmu_flcn,
+	.flcn = &gm200_pmu_flcn,
 	.enabled = gf100_pmu_enabled,
 	.intr = gt215_pmu_intr,
 	.recv = gm20b_pmu_recv,
diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gp102.c b/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gp102.c
index 00da1b873ce8..6bf7fc1bd1e3 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gp102.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gp102.c
@@ -39,7 +39,7 @@ gp102_pmu_enabled(struct nvkm_pmu *pmu)
 
 static const struct nvkm_pmu_func
 gp102_pmu = {
-	.flcn = &gt215_pmu_flcn,
+	.flcn = &gm200_pmu_flcn,
 	.enabled = gp102_pmu_enabled,
 	.reset = gp102_pmu_reset,
 };
diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gp10b.c b/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gp10b.c
index 461f722656e2..ba1583bb618b 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gp10b.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gp10b.c
@@ -78,7 +78,7 @@ gp10b_pmu_acr = {
 
 static const struct nvkm_pmu_func
 gp10b_pmu = {
-	.flcn = &gt215_pmu_flcn,
+	.flcn = &gm200_pmu_flcn,
 	.enabled = gf100_pmu_enabled,
 	.intr = gt215_pmu_intr,
 	.recv = gm20b_pmu_recv,
diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/priv.h b/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/priv.h
index e7860d177353..bcaade758ff7 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/priv.h
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/priv.h
@@ -44,6 +44,8 @@ void gf100_pmu_reset(struct nvkm_pmu *);
 
 void gk110_pmu_pgob(struct nvkm_pmu *, bool);
 
+extern const struct nvkm_falcon_func gm200_pmu_flcn;
+
 void gm20b_pmu_acr_bld_patch(struct nvkm_acr *, u32, s64);
 void gm20b_pmu_acr_bld_write(struct nvkm_acr *, u32, struct nvkm_acr_lsfw *);
 int gm20b_pmu_acr_boot(struct nvkm_falcon *);
diff --git a/drivers/gpu/drm/radeon/atombios_encoders.c b/drivers/gpu/drm/radeon/atombios_encoders.c
index 0fce73b9a646..70bd84b7ef2b 100644
--- a/drivers/gpu/drm/radeon/atombios_encoders.c
+++ b/drivers/gpu/drm/radeon/atombios_encoders.c
@@ -198,7 +198,8 @@ void radeon_atom_backlight_init(struct radeon_encoder *radeon_encoder,
 	 * so don't register a backlight device
 	 */
 	if ((rdev->pdev->subsystem_vendor == PCI_VENDOR_ID_APPLE) &&
-	    (rdev->pdev->device == 0x6741))
+	    (rdev->pdev->device == 0x6741) &&
+	    !dmi_match(DMI_PRODUCT_NAME, "iMac12,1"))
 		return;
 
 	if (!radeon_encoder->enc_priv)
diff --git a/drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c b/drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c
index 830bdd5e9b7c..8677c8271678 100644
--- a/drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c
+++ b/drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c
@@ -529,13 +529,6 @@ static int dw_hdmi_rockchip_bind(struct device *dev, struct device *master,
 		return ret;
 	}
 
-	ret = clk_prepare_enable(hdmi->vpll_clk);
-	if (ret) {
-		DRM_DEV_ERROR(hdmi->dev, "Failed to enable HDMI vpll: %d\n",
-			      ret);
-		return ret;
-	}
-
 	hdmi->phy = devm_phy_optional_get(dev, "hdmi");
 	if (IS_ERR(hdmi->phy)) {
 		ret = PTR_ERR(hdmi->phy);
@@ -544,6 +537,13 @@ static int dw_hdmi_rockchip_bind(struct device *dev, struct device *master,
 		return ret;
 	}
 
+	ret = clk_prepare_enable(hdmi->vpll_clk);
+	if (ret) {
+		DRM_DEV_ERROR(hdmi->dev, "Failed to enable HDMI vpll: %d\n",
+			      ret);
+		return ret;
+	}
+
 	drm_encoder_helper_add(encoder, &dw_hdmi_rockchip_encoder_helper_funcs);
 	drm_simple_encoder_init(drm, encoder, DRM_MODE_ENCODER_TMDS);
 
diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
index 05c007b213f2..f7a4eaf3a2e0 100644
--- a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
@@ -36,11 +36,11 @@ static int amd_sfh_wait_response_v2(struct amd_mp2_dev *mp2, u8 sid, u32 sensor_
 {
 	union cmd_response cmd_resp;
 
-	/* Get response with status within a max of 800 ms timeout */
+	/* Get response with status within a max of 1600 ms timeout */
 	if (!readl_poll_timeout(mp2->mmio + AMD_P2C_MSG(0), cmd_resp.resp,
 				(cmd_resp.response_v2.response == sensor_sts &&
 				cmd_resp.response_v2.status == 0 && (sid == 0xff ||
-				cmd_resp.response_v2.sensor_id == sid)), 500, 800000))
+				cmd_resp.response_v2.sensor_id == sid)), 500, 1600000))
 		return cmd_resp.response_v2.response;
 
 	return SENSOR_DISABLED;
diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.h b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.h
index 1ff6f83cb6fd..9c9119227135 100644
--- a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.h
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.h
@@ -48,7 +48,7 @@ union sfh_cmd_base {
 	} s;
 	struct {
 		u32 cmd_id : 4;
-		u32 intr_enable : 1;
+		u32 intr_disable : 1;
 		u32 rsvd1 : 3;
 		u32 length : 7;
 		u32 mem_type : 1;
diff --git a/drivers/hid/amd-sfh-hid/hid_descriptor/amd_sfh_hid_desc.c b/drivers/hid/amd-sfh-hid/hid_descriptor/amd_sfh_hid_desc.c
index 0c3697219382..07eb3281b88d 100644
--- a/drivers/hid/amd-sfh-hid/hid_descriptor/amd_sfh_hid_desc.c
+++ b/drivers/hid/amd-sfh-hid/hid_descriptor/amd_sfh_hid_desc.c
@@ -26,6 +26,7 @@
 #define HID_USAGE_SENSOR_STATE_READY_ENUM                             0x02
 #define HID_USAGE_SENSOR_STATE_INITIALIZING_ENUM                      0x05
 #define HID_USAGE_SENSOR_EVENT_DATA_UPDATED_ENUM                      0x04
+#define ILLUMINANCE_MASK					GENMASK(14, 0)
 
 int get_report_descriptor(int sensor_idx, u8 *rep_desc)
 {
@@ -245,7 +246,8 @@ u8 get_input_report(u8 current_index, int sensor_idx, int report_id, struct amd_
 		get_common_inputs(&als_input.common_property, report_id);
 		/* For ALS ,V2 Platforms uses C2P_MSG5 register instead of DRAM access method */
 		if (supported_input == V2_STATUS)
-			als_input.illuminance_value = (int)readl(privdata->mmio + AMD_C2P_MSG(5));
+			als_input.illuminance_value =
+				readl(privdata->mmio + AMD_C2P_MSG(5)) & ILLUMINANCE_MASK;
 		else
 			als_input.illuminance_value =
 				(int)sensor_virt_addr[0] / AMD_SFH_FW_MULTIPLIER;
diff --git a/drivers/hid/hid-elo.c b/drivers/hid/hid-elo.c
index 8e960d7b233b..9b42b0cdeef0 100644
--- a/drivers/hid/hid-elo.c
+++ b/drivers/hid/hid-elo.c
@@ -262,6 +262,7 @@ static int elo_probe(struct hid_device *hdev, const struct hid_device_id *id)
 
 	return 0;
 err_free:
+	usb_put_dev(udev);
 	kfree(priv);
 	return ret;
 }
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index bdedf594e2d1..645a5f566d23 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -1353,6 +1353,7 @@
 #define USB_VENDOR_ID_UGTIZER			0x2179
 #define USB_DEVICE_ID_UGTIZER_TABLET_GP0610	0x0053
 #define USB_DEVICE_ID_UGTIZER_TABLET_GT5040	0x0077
+#define USB_DEVICE_ID_UGTIZER_TABLET_WP5540	0x0004
 
 #define USB_VENDOR_ID_VIEWSONIC			0x0543
 #define USB_DEVICE_ID_VIEWSONIC_PD1011		0xe621
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index 65b711476174..544d1197aca4 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -187,6 +187,7 @@ static const struct hid_device_id hid_quirks[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_TURBOX, USB_DEVICE_ID_TURBOX_KEYBOARD), HID_QUIRK_NOGET },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_UCLOGIC, USB_DEVICE_ID_UCLOGIC_TABLET_KNA5), HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_UCLOGIC, USB_DEVICE_ID_UCLOGIC_TABLET_TWA60), HID_QUIRK_MULTI_INPUT },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_UGTIZER, USB_DEVICE_ID_UGTIZER_TABLET_WP5540), HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_WALTOP, USB_DEVICE_ID_WALTOP_MEDIA_TABLET_10_6_INCH), HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_WALTOP, USB_DEVICE_ID_WALTOP_MEDIA_TABLET_14_1_INCH), HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_WALTOP, USB_DEVICE_ID_WALTOP_SIRIUS_BATTERY_FREE_TABLET), HID_QUIRK_MULTI_INPUT },
diff --git a/drivers/hid/i2c-hid/i2c-hid-of-goodix.c b/drivers/hid/i2c-hid/i2c-hid-of-goodix.c
index b4dad66fa954..ec6c73f75ffe 100644
--- a/drivers/hid/i2c-hid/i2c-hid-of-goodix.c
+++ b/drivers/hid/i2c-hid/i2c-hid-of-goodix.c
@@ -27,7 +27,6 @@ struct i2c_hid_of_goodix {
 
 	struct regulator *vdd;
 	struct notifier_block nb;
-	struct mutex regulator_mutex;
 	struct gpio_desc *reset_gpio;
 	const struct goodix_i2c_hid_timing_data *timings;
 };
@@ -67,8 +66,6 @@ static int ihid_goodix_vdd_notify(struct notifier_block *nb,
 		container_of(nb, struct i2c_hid_of_goodix, nb);
 	int ret = NOTIFY_OK;
 
-	mutex_lock(&ihid_goodix->regulator_mutex);
-
 	switch (event) {
 	case REGULATOR_EVENT_PRE_DISABLE:
 		gpiod_set_value_cansleep(ihid_goodix->reset_gpio, 1);
@@ -87,8 +84,6 @@ static int ihid_goodix_vdd_notify(struct notifier_block *nb,
 		break;
 	}
 
-	mutex_unlock(&ihid_goodix->regulator_mutex);
-
 	return ret;
 }
 
@@ -102,8 +97,6 @@ static int i2c_hid_of_goodix_probe(struct i2c_client *client,
 	if (!ihid_goodix)
 		return -ENOMEM;
 
-	mutex_init(&ihid_goodix->regulator_mutex);
-
 	ihid_goodix->ops.power_up = goodix_i2c_hid_power_up;
 	ihid_goodix->ops.power_down = goodix_i2c_hid_power_down;
 
@@ -130,25 +123,28 @@ static int i2c_hid_of_goodix_probe(struct i2c_client *client,
 	 *   long. Holding the controller in reset apparently draws extra
 	 *   power.
 	 */
-	mutex_lock(&ihid_goodix->regulator_mutex);
 	ihid_goodix->nb.notifier_call = ihid_goodix_vdd_notify;
 	ret = devm_regulator_register_notifier(ihid_goodix->vdd, &ihid_goodix->nb);
-	if (ret) {
-		mutex_unlock(&ihid_goodix->regulator_mutex);
+	if (ret)
 		return dev_err_probe(&client->dev, ret,
 			"regulator notifier request failed\n");
-	}
 
 	/*
 	 * If someone else is holding the regulator on (or the regulator is
 	 * an always-on one) we might never be told to deassert reset. Do it
-	 * now. Here we'll assume that someone else might have _just
-	 * barely_ turned the regulator on so we'll do the full
-	 * "post_power_delay" just in case.
+	 * now... and temporarily bump the regulator reference count just to
+	 * make sure it is impossible for this to race with our own notifier!
+	 * We also assume that someone else might have _just barely_ turned
+	 * the regulator on so we'll do the full "post_power_delay" just in
+	 * case.
 	 */
-	if (ihid_goodix->reset_gpio && regulator_is_enabled(ihid_goodix->vdd))
+	if (ihid_goodix->reset_gpio && regulator_is_enabled(ihid_goodix->vdd)) {
+		ret = regulator_enable(ihid_goodix->vdd);
+		if (ret)
+			return ret;
 		goodix_i2c_hid_deassert_reset(ihid_goodix, true);
-	mutex_unlock(&ihid_goodix->regulator_mutex);
+		regulator_disable(ihid_goodix->vdd);
+	}
 
 	return i2c_hid_core_probe(client, &ihid_goodix->ops, 0x0001, 0);
 }
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 392c1ac4f819..44bd0b6ff505 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -2027,8 +2027,10 @@ int vmbus_add_channel_kobj(struct hv_device *dev, struct vmbus_channel *channel)
 	kobj->kset = dev->channels_kset;
 	ret = kobject_init_and_add(kobj, &vmbus_chan_ktype, NULL,
 				   "%u", relid);
-	if (ret)
+	if (ret) {
+		kobject_put(kobj);
 		return ret;
+	}
 
 	ret = sysfs_create_group(kobj, &vmbus_chan_group);
 
@@ -2037,6 +2039,7 @@ int vmbus_add_channel_kobj(struct hv_device *dev, struct vmbus_channel *channel)
 		 * The calling functions' error handling paths will cleanup the
 		 * empty channel directory.
 		 */
+		kobject_put(kobj);
 		dev_err(device, "Unable to set up channel sysfs files\n");
 		return ret;
 	}
diff --git a/drivers/i2c/busses/i2c-brcmstb.c b/drivers/i2c/busses/i2c-brcmstb.c
index 490ee3962645..b00f35c0b066 100644
--- a/drivers/i2c/busses/i2c-brcmstb.c
+++ b/drivers/i2c/busses/i2c-brcmstb.c
@@ -673,7 +673,7 @@ static int brcmstb_i2c_probe(struct platform_device *pdev)
 
 	/* set the data in/out register size for compatible SoCs */
 	if (of_device_is_compatible(dev->device->of_node,
-				    "brcmstb,brcmper-i2c"))
+				    "brcm,brcmper-i2c"))
 		dev->data_regsz = sizeof(u8);
 	else
 		dev->data_regsz = sizeof(u32);
diff --git a/drivers/i2c/busses/i2c-qcom-cci.c b/drivers/i2c/busses/i2c-qcom-cci.c
index c1de8eb66169..cf54f1cb4c57 100644
--- a/drivers/i2c/busses/i2c-qcom-cci.c
+++ b/drivers/i2c/busses/i2c-qcom-cci.c
@@ -558,7 +558,7 @@ static int cci_probe(struct platform_device *pdev)
 		cci->master[idx].adap.quirks = &cci->data->quirks;
 		cci->master[idx].adap.algo = &cci_algo;
 		cci->master[idx].adap.dev.parent = dev;
-		cci->master[idx].adap.dev.of_node = child;
+		cci->master[idx].adap.dev.of_node = of_node_get(child);
 		cci->master[idx].master = idx;
 		cci->master[idx].cci = cci;
 
@@ -643,8 +643,10 @@ static int cci_probe(struct platform_device *pdev)
 			continue;
 
 		ret = i2c_add_adapter(&cci->master[i].adap);
-		if (ret < 0)
+		if (ret < 0) {
+			of_node_put(cci->master[i].adap.dev.of_node);
 			goto error_i2c;
+		}
 	}
 
 	pm_runtime_set_autosuspend_delay(dev, MSEC_PER_SEC);
@@ -655,9 +657,11 @@ static int cci_probe(struct platform_device *pdev)
 	return 0;
 
 error_i2c:
-	for (; i >= 0; i--) {
-		if (cci->master[i].cci)
+	for (--i ; i >= 0; i--) {
+		if (cci->master[i].cci) {
 			i2c_del_adapter(&cci->master[i].adap);
+			of_node_put(cci->master[i].adap.dev.of_node);
+		}
 	}
 error:
 	disable_irq(cci->irq);
@@ -673,8 +677,10 @@ static int cci_remove(struct platform_device *pdev)
 	int i;
 
 	for (i = 0; i < cci->data->num_masters; i++) {
-		if (cci->master[i].cci)
+		if (cci->master[i].cci) {
 			i2c_del_adapter(&cci->master[i].adap);
+			of_node_put(cci->master[i].adap.dev.of_node);
+		}
 		cci_halt(cci, i);
 	}
 
diff --git a/drivers/irqchip/irq-sifive-plic.c b/drivers/irqchip/irq-sifive-plic.c
index 259065d271ef..09cc98266d30 100644
--- a/drivers/irqchip/irq-sifive-plic.c
+++ b/drivers/irqchip/irq-sifive-plic.c
@@ -398,3 +398,4 @@ static int __init plic_init(struct device_node *node,
 
 IRQCHIP_DECLARE(sifive_plic, "sifive,plic-1.0.0", plic_init);
 IRQCHIP_DECLARE(riscv_plic0, "riscv,plic0", plic_init); /* for legacy systems */
+IRQCHIP_DECLARE(thead_c900_plic, "thead,c900-plic", plic_init); /* for firmware driver */
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index b75ff6b2b952..5f33700d1247 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2156,7 +2156,7 @@ static void __dm_destroy(struct mapped_device *md, bool wait)
 	set_bit(DMF_FREEING, &md->flags);
 	spin_unlock(&_minor_lock);
 
-	blk_set_queue_dying(md->queue);
+	blk_mark_disk_dead(md->disk);
 
 	/*
 	 * Take suspend_lock so that presuspend and postsuspend methods
diff --git a/drivers/mmc/core/block.c b/drivers/mmc/core/block.c
index 431af5e8be2f..b575d0bfd0d6 100644
--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -1682,31 +1682,31 @@ static void mmc_blk_read_single(struct mmc_queue *mq, struct request *req)
 	struct mmc_card *card = mq->card;
 	struct mmc_host *host = card->host;
 	blk_status_t error = BLK_STS_OK;
-	int retries = 0;
 
 	do {
 		u32 status;
 		int err;
+		int retries = 0;
 
-		mmc_blk_rw_rq_prep(mqrq, card, 1, mq);
+		while (retries++ <= MMC_READ_SINGLE_RETRIES) {
+			mmc_blk_rw_rq_prep(mqrq, card, 1, mq);
 
-		mmc_wait_for_req(host, mrq);
+			mmc_wait_for_req(host, mrq);
 
-		err = mmc_send_status(card, &status);
-		if (err)
-			goto error_exit;
-
-		if (!mmc_host_is_spi(host) &&
-		    !mmc_ready_for_data(status)) {
-			err = mmc_blk_fix_state(card, req);
+			err = mmc_send_status(card, &status);
 			if (err)
 				goto error_exit;
-		}
 
-		if (mrq->cmd->error && retries++ < MMC_READ_SINGLE_RETRIES)
-			continue;
+			if (!mmc_host_is_spi(host) &&
+			    !mmc_ready_for_data(status)) {
+				err = mmc_blk_fix_state(card, req);
+				if (err)
+					goto error_exit;
+			}
 
-		retries = 0;
+			if (!mrq->cmd->error)
+				break;
+		}
 
 		if (mrq->cmd->error ||
 		    mrq->data->error ||
diff --git a/drivers/mtd/devices/phram.c b/drivers/mtd/devices/phram.c
index 6ed6c51fac69..d503821a3e60 100644
--- a/drivers/mtd/devices/phram.c
+++ b/drivers/mtd/devices/phram.c
@@ -264,16 +264,20 @@ static int phram_setup(const char *val)
 		}
 	}
 
-	if (erasesize)
-		div_u64_rem(len, (uint32_t)erasesize, &rem);
-
 	if (len == 0 || erasesize == 0 || erasesize > len
-	    || erasesize > UINT_MAX || rem) {
+	    || erasesize > UINT_MAX) {
 		parse_err("illegal erasesize or len\n");
 		ret = -EINVAL;
 		goto error;
 	}
 
+	div_u64_rem(len, (uint32_t)erasesize, &rem);
+	if (rem) {
+		parse_err("len is not multiple of erasesize\n");
+		ret = -EINVAL;
+		goto error;
+	}
+
 	ret = register_device(name, start, len, (uint32_t)erasesize);
 	if (ret)
 		goto error;
diff --git a/drivers/mtd/nand/raw/brcmnand/brcmnand.c b/drivers/mtd/nand/raw/brcmnand/brcmnand.c
index f75929783b94..aee78f5f4f15 100644
--- a/drivers/mtd/nand/raw/brcmnand/brcmnand.c
+++ b/drivers/mtd/nand/raw/brcmnand/brcmnand.c
@@ -2106,7 +2106,7 @@ static int brcmnand_read_by_pio(struct mtd_info *mtd, struct nand_chip *chip,
 					mtd->oobsize / trans,
 					host->hwcfg.sector_size_1k);
 
-		if (!ret) {
+		if (ret != -EBADMSG) {
 			*err_addr = brcmnand_get_uncorrecc_addr(ctrl);
 
 			if (*err_addr)
diff --git a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c b/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
index 6e9f7d80ef8b..668d69fe4cf2 100644
--- a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
+++ b/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
@@ -2293,7 +2293,7 @@ static int gpmi_nfc_exec_op(struct nand_chip *chip,
 		this->hw.must_apply_timings = false;
 		ret = gpmi_nfc_apply_timings(this);
 		if (ret)
-			return ret;
+			goto out_pm;
 	}
 
 	dev_dbg(this->dev, "%s: %d instructions\n", __func__, op->ninstrs);
@@ -2422,6 +2422,7 @@ static int gpmi_nfc_exec_op(struct nand_chip *chip,
 
 	this->bch = false;
 
+out_pm:
 	pm_runtime_mark_last_busy(this->dev);
 	pm_runtime_put_autosuspend(this->dev);
 
diff --git a/drivers/mtd/nand/raw/ingenic/ingenic_ecc.c b/drivers/mtd/nand/raw/ingenic/ingenic_ecc.c
index efe0ffe4f1ab..9054559e52dd 100644
--- a/drivers/mtd/nand/raw/ingenic/ingenic_ecc.c
+++ b/drivers/mtd/nand/raw/ingenic/ingenic_ecc.c
@@ -68,9 +68,14 @@ static struct ingenic_ecc *ingenic_ecc_get(struct device_node *np)
 	struct ingenic_ecc *ecc;
 
 	pdev = of_find_device_by_node(np);
-	if (!pdev || !platform_get_drvdata(pdev))
+	if (!pdev)
 		return ERR_PTR(-EPROBE_DEFER);
 
+	if (!platform_get_drvdata(pdev)) {
+		put_device(&pdev->dev);
+		return ERR_PTR(-EPROBE_DEFER);
+	}
+
 	ecc = platform_get_drvdata(pdev);
 	clk_prepare_enable(ecc->clk);
 
diff --git a/drivers/mtd/nand/raw/qcom_nandc.c b/drivers/mtd/nand/raw/qcom_nandc.c
index 04e6f7b26706..0f41a9a42157 100644
--- a/drivers/mtd/nand/raw/qcom_nandc.c
+++ b/drivers/mtd/nand/raw/qcom_nandc.c
@@ -2,7 +2,6 @@
 /*
  * Copyright (c) 2016, The Linux Foundation. All rights reserved.
  */
-
 #include <linux/clk.h>
 #include <linux/slab.h>
 #include <linux/bitops.h>
@@ -3063,10 +3062,6 @@ static int qcom_nandc_probe(struct platform_device *pdev)
 	if (dma_mapping_error(dev, nandc->base_dma))
 		return -ENXIO;
 
-	ret = qcom_nandc_alloc(nandc);
-	if (ret)
-		goto err_nandc_alloc;
-
 	ret = clk_prepare_enable(nandc->core_clk);
 	if (ret)
 		goto err_core_clk;
@@ -3075,6 +3070,10 @@ static int qcom_nandc_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_aon_clk;
 
+	ret = qcom_nandc_alloc(nandc);
+	if (ret)
+		goto err_nandc_alloc;
+
 	ret = qcom_nandc_setup(nandc);
 	if (ret)
 		goto err_setup;
@@ -3086,15 +3085,14 @@ static int qcom_nandc_probe(struct platform_device *pdev)
 	return 0;
 
 err_setup:
+	qcom_nandc_unalloc(nandc);
+err_nandc_alloc:
 	clk_disable_unprepare(nandc->aon_clk);
 err_aon_clk:
 	clk_disable_unprepare(nandc->core_clk);
 err_core_clk:
-	qcom_nandc_unalloc(nandc);
-err_nandc_alloc:
 	dma_unmap_resource(dev, res->start, resource_size(res),
 			   DMA_BIDIRECTIONAL, 0);
-
 	return ret;
 }
 
diff --git a/drivers/mtd/parsers/qcomsmempart.c b/drivers/mtd/parsers/qcomsmempart.c
index 06a818cd2433..32ddfea70142 100644
--- a/drivers/mtd/parsers/qcomsmempart.c
+++ b/drivers/mtd/parsers/qcomsmempart.c
@@ -58,11 +58,11 @@ static int parse_qcomsmem_part(struct mtd_info *mtd,
 			       const struct mtd_partition **pparts,
 			       struct mtd_part_parser_data *data)
 {
+	size_t len = SMEM_FLASH_PTABLE_HDR_LEN;
+	int ret, i, j, tmpparts, numparts = 0;
 	struct smem_flash_pentry *pentry;
 	struct smem_flash_ptable *ptable;
-	size_t len = SMEM_FLASH_PTABLE_HDR_LEN;
 	struct mtd_partition *parts;
-	int ret, i, numparts;
 	char *name, *c;
 
 	if (IS_ENABLED(CONFIG_MTD_SPI_NOR_USE_4K_SECTORS)
@@ -87,8 +87,8 @@ static int parse_qcomsmem_part(struct mtd_info *mtd,
 	}
 
 	/* Ensure that # of partitions is less than the max we have allocated */
-	numparts = le32_to_cpu(ptable->numparts);
-	if (numparts > SMEM_FLASH_PTABLE_MAX_PARTS_V4) {
+	tmpparts = le32_to_cpu(ptable->numparts);
+	if (tmpparts > SMEM_FLASH_PTABLE_MAX_PARTS_V4) {
 		pr_err("Partition numbers exceed the max limit\n");
 		return -EINVAL;
 	}
@@ -116,11 +116,17 @@ static int parse_qcomsmem_part(struct mtd_info *mtd,
 		return PTR_ERR(ptable);
 	}
 
+	for (i = 0; i < tmpparts; i++) {
+		pentry = &ptable->pentry[i];
+		if (pentry->name[0] != '\0')
+			numparts++;
+	}
+
 	parts = kcalloc(numparts, sizeof(*parts), GFP_KERNEL);
 	if (!parts)
 		return -ENOMEM;
 
-	for (i = 0; i < numparts; i++) {
+	for (i = 0, j = 0; i < tmpparts; i++) {
 		pentry = &ptable->pentry[i];
 		if (pentry->name[0] == '\0')
 			continue;
@@ -135,24 +141,25 @@ static int parse_qcomsmem_part(struct mtd_info *mtd,
 		for (c = name; *c != '\0'; c++)
 			*c = tolower(*c);
 
-		parts[i].name = name;
-		parts[i].offset = le32_to_cpu(pentry->offset) * mtd->erasesize;
-		parts[i].mask_flags = pentry->attr;
-		parts[i].size = le32_to_cpu(pentry->length) * mtd->erasesize;
+		parts[j].name = name;
+		parts[j].offset = le32_to_cpu(pentry->offset) * mtd->erasesize;
+		parts[j].mask_flags = pentry->attr;
+		parts[j].size = le32_to_cpu(pentry->length) * mtd->erasesize;
 		pr_debug("%d: %s offs=0x%08x size=0x%08x attr:0x%08x\n",
 			 i, pentry->name, le32_to_cpu(pentry->offset),
 			 le32_to_cpu(pentry->length), pentry->attr);
+		j++;
 	}
 
 	pr_debug("SMEM partition table found: ver: %d len: %d\n",
-		 le32_to_cpu(ptable->version), numparts);
+		 le32_to_cpu(ptable->version), tmpparts);
 	*pparts = parts;
 
 	return numparts;
 
 out_free_parts:
-	while (--i >= 0)
-		kfree(parts[i].name);
+	while (--j >= 0)
+		kfree(parts[j].name);
 	kfree(parts);
 	*pparts = NULL;
 
@@ -166,6 +173,8 @@ static void parse_qcomsmem_cleanup(const struct mtd_partition *pparts,
 
 	for (i = 0; i < nr_parts; i++)
 		kfree(pparts[i].name);
+
+	kfree(pparts);
 }
 
 static const struct of_device_id qcomsmem_of_match_table[] = {
diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index 9fd1d6cba3cd..a86b1f71762e 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -225,7 +225,7 @@ static inline int __check_agg_selection_timer(struct port *port)
 	if (bond == NULL)
 		return 0;
 
-	return BOND_AD_INFO(bond).agg_select_timer ? 1 : 0;
+	return atomic_read(&BOND_AD_INFO(bond).agg_select_timer) ? 1 : 0;
 }
 
 /**
@@ -1995,7 +1995,7 @@ static void ad_marker_response_received(struct bond_marker *marker,
  */
 void bond_3ad_initiate_agg_selection(struct bonding *bond, int timeout)
 {
-	BOND_AD_INFO(bond).agg_select_timer = timeout;
+	atomic_set(&BOND_AD_INFO(bond).agg_select_timer, timeout);
 }
 
 /**
@@ -2278,6 +2278,28 @@ void bond_3ad_update_ad_actor_settings(struct bonding *bond)
 	spin_unlock_bh(&bond->mode_lock);
 }
 
+/**
+ * bond_agg_timer_advance - advance agg_select_timer
+ * @bond:  bonding structure
+ *
+ * Return true when agg_select_timer reaches 0.
+ */
+static bool bond_agg_timer_advance(struct bonding *bond)
+{
+	int val, nval;
+
+	while (1) {
+		val = atomic_read(&BOND_AD_INFO(bond).agg_select_timer);
+		if (!val)
+			return false;
+		nval = val - 1;
+		if (atomic_cmpxchg(&BOND_AD_INFO(bond).agg_select_timer,
+				   val, nval) == val)
+			break;
+	}
+	return nval == 0;
+}
+
 /**
  * bond_3ad_state_machine_handler - handle state machines timeout
  * @work: work context to fetch bonding struct to work on from
@@ -2313,9 +2335,7 @@ void bond_3ad_state_machine_handler(struct work_struct *work)
 	if (!bond_has_slaves(bond))
 		goto re_arm;
 
-	/* check if agg_select_timer timer after initialize is timed out */
-	if (BOND_AD_INFO(bond).agg_select_timer &&
-	    !(--BOND_AD_INFO(bond).agg_select_timer)) {
+	if (bond_agg_timer_advance(bond)) {
 		slave = bond_first_slave_rcu(bond);
 		port = slave ? &(SLAVE_AD_INFO(slave)->port) : NULL;
 
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 83cdaabd7b69..46c3301a5e07 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2377,10 +2377,9 @@ static int __bond_release_one(struct net_device *bond_dev,
 		bond_select_active_slave(bond);
 	}
 
-	if (!bond_has_slaves(bond)) {
-		bond_set_carrier(bond);
+	bond_set_carrier(bond);
+	if (!bond_has_slaves(bond))
 		eth_hw_addr_random(bond_dev);
-	}
 
 	unblock_netpoll_tx();
 	synchronize_rcu();
diff --git a/drivers/net/dsa/Kconfig b/drivers/net/dsa/Kconfig
index 9891b072b462..9428aac4a686 100644
--- a/drivers/net/dsa/Kconfig
+++ b/drivers/net/dsa/Kconfig
@@ -81,6 +81,7 @@ config NET_DSA_REALTEK_SMI
 
 config NET_DSA_SMSC_LAN9303
 	tristate
+	depends on VLAN_8021Q || VLAN_8021Q=n
 	select NET_DSA_TAG_LAN9303
 	select REGMAP
 	help
diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index 89f920289ae2..0b6f29ee87b5 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -10,6 +10,7 @@
 #include <linux/mii.h>
 #include <linux/phy.h>
 #include <linux/if_bridge.h>
+#include <linux/if_vlan.h>
 #include <linux/etherdevice.h>
 
 #include "lan9303.h"
@@ -1083,21 +1084,27 @@ static void lan9303_adjust_link(struct dsa_switch *ds, int port,
 static int lan9303_port_enable(struct dsa_switch *ds, int port,
 			       struct phy_device *phy)
 {
+	struct dsa_port *dp = dsa_to_port(ds, port);
 	struct lan9303 *chip = ds->priv;
 
-	if (!dsa_is_user_port(ds, port))
+	if (!dsa_port_is_user(dp))
 		return 0;
 
+	vlan_vid_add(dp->cpu_dp->master, htons(ETH_P_8021Q), port);
+
 	return lan9303_enable_processing_port(chip, port);
 }
 
 static void lan9303_port_disable(struct dsa_switch *ds, int port)
 {
+	struct dsa_port *dp = dsa_to_port(ds, port);
 	struct lan9303 *chip = ds->priv;
 
-	if (!dsa_is_user_port(ds, port))
+	if (!dsa_port_is_user(dp))
 		return;
 
+	vlan_vid_del(dp->cpu_dp->master, htons(ETH_P_8021Q), port);
+
 	lan9303_disable_processing_port(chip, port);
 	lan9303_phy_write(ds, chip->phy_addr_base + port, MII_BMCR, BMCR_PDOWN);
 }
@@ -1309,7 +1316,7 @@ static int lan9303_probe_reset_gpio(struct lan9303 *chip,
 				     struct device_node *np)
 {
 	chip->reset_gpio = devm_gpiod_get_optional(chip->dev, "reset",
-						   GPIOD_OUT_LOW);
+						   GPIOD_OUT_HIGH);
 	if (IS_ERR(chip->reset_gpio))
 		return PTR_ERR(chip->reset_gpio);
 
diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 503adf03d2fc..9e006a25b636 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -2201,8 +2201,8 @@ static int gswip_remove(struct platform_device *pdev)
 
 	if (priv->ds->slave_mii_bus) {
 		mdiobus_unregister(priv->ds->slave_mii_bus);
-		mdiobus_free(priv->ds->slave_mii_bus);
 		of_node_put(priv->ds->slave_mii_bus->dev.of_node);
+		mdiobus_free(priv->ds->slave_mii_bus);
 	}
 
 	for (i = 0; i < priv->num_gphy_fw; i++)
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 056e3b65cd27..263da7e2d6be 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2291,6 +2291,13 @@ static int mv88e6xxx_port_vlan_del(struct dsa_switch *ds, int port,
 	if (!mv88e6xxx_max_vid(chip))
 		return -EOPNOTSUPP;
 
+	/* The ATU removal procedure needs the FID to be mapped in the VTU,
+	 * but FDB deletion runs concurrently with VLAN deletion. Flush the DSA
+	 * switchdev workqueue to ensure that all FDB entries are deleted
+	 * before we remove the VLAN.
+	 */
+	dsa_flush_workqueue();
+
 	mv88e6xxx_reg_lock(chip);
 
 	err = mv88e6xxx_port_get_pvid(chip, port, &pvid);
diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index 3b51b172b317..5cbd815c737e 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -900,7 +900,7 @@ static void atl1c_clean_tx_ring(struct atl1c_adapter *adapter,
 		atl1c_clean_buffer(pdev, buffer_info);
 	}
 
-	netdev_reset_queue(adapter->netdev);
+	netdev_tx_reset_queue(netdev_get_tx_queue(adapter->netdev, queue));
 
 	/* Zero out Tx-buffers */
 	memset(tpd_ring->desc, 0, sizeof(struct atl1c_tpd_desc) *
diff --git a/drivers/net/ethernet/broadcom/bgmac-platform.c b/drivers/net/ethernet/broadcom/bgmac-platform.c
index df8ff839cc62..94eb3a42158e 100644
--- a/drivers/net/ethernet/broadcom/bgmac-platform.c
+++ b/drivers/net/ethernet/broadcom/bgmac-platform.c
@@ -172,6 +172,7 @@ static int bgmac_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
 	struct bgmac *bgmac;
+	struct resource *regs;
 	int ret;
 
 	bgmac = bgmac_alloc(&pdev->dev);
@@ -208,15 +209,23 @@ static int bgmac_probe(struct platform_device *pdev)
 	if (IS_ERR(bgmac->plat.base))
 		return PTR_ERR(bgmac->plat.base);
 
-	bgmac->plat.idm_base = devm_platform_ioremap_resource_byname(pdev, "idm_base");
-	if (IS_ERR(bgmac->plat.idm_base))
-		return PTR_ERR(bgmac->plat.idm_base);
-	else
+	/* The idm_base resource is optional for some platforms */
+	regs = platform_get_resource_byname(pdev, IORESOURCE_MEM, "idm_base");
+	if (regs) {
+		bgmac->plat.idm_base = devm_ioremap_resource(&pdev->dev, regs);
+		if (IS_ERR(bgmac->plat.idm_base))
+			return PTR_ERR(bgmac->plat.idm_base);
 		bgmac->feature_flags &= ~BGMAC_FEAT_IDM_MASK;
+	}
 
-	bgmac->plat.nicpm_base = devm_platform_ioremap_resource_byname(pdev, "nicpm_base");
-	if (IS_ERR(bgmac->plat.nicpm_base))
-		return PTR_ERR(bgmac->plat.nicpm_base);
+	/* The nicpm_base resource is optional for some platforms */
+	regs = platform_get_resource_byname(pdev, IORESOURCE_MEM, "nicpm_base");
+	if (regs) {
+		bgmac->plat.nicpm_base = devm_ioremap_resource(&pdev->dev,
+							       regs);
+		if (IS_ERR(bgmac->plat.nicpm_base))
+			return PTR_ERR(bgmac->plat.nicpm_base);
+	}
 
 	bgmac->read = platform_bgmac_read;
 	bgmac->write = platform_bgmac_write;
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index d13fb1d31821..d71c11a6282e 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4739,7 +4739,7 @@ static int macb_probe(struct platform_device *pdev)
 
 #ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
 	if (GEM_BFEXT(DAW64, gem_readl(bp, DCFG6))) {
-		dma_set_mask(&pdev->dev, DMA_BIT_MASK(44));
+		dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(44));
 		bp->hw_dma_cap |= HW_DMA_CAP_64B;
 	}
 #endif
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 110075336a75..8b7a29e1e221 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -4329,7 +4329,7 @@ static int dpaa2_eth_probe(struct fsl_mc_device *dpni_dev)
 	}
 
 	INIT_WORK(&priv->tx_onestep_tstamp, dpaa2_eth_tx_onestep_tstamp);
-
+	mutex_init(&priv->onestep_tstamp_lock);
 	skb_queue_head_init(&priv->tx_skbs);
 
 	priv->rx_copybreak = DPAA2_ETH_DEFAULT_COPYBREAK;
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
index d6eefbbf163f..cacd454ac696 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
@@ -532,6 +532,7 @@ static int dpaa2_switch_flower_parse_mirror_key(struct flow_cls_offload *cls,
 	struct flow_rule *rule = flow_cls_offload_flow_rule(cls);
 	struct flow_dissector *dissector = rule->match.dissector;
 	struct netlink_ext_ack *extack = cls->common.extack;
+	int ret = -EOPNOTSUPP;
 
 	if (dissector->used_keys &
 	    ~(BIT(FLOW_DISSECTOR_KEY_BASIC) |
@@ -561,9 +562,10 @@ static int dpaa2_switch_flower_parse_mirror_key(struct flow_cls_offload *cls,
 		}
 
 		*vlan = (u16)match.key->vlan_id;
+		ret = 0;
 	}
 
-	return 0;
+	return ret;
 }
 
 static int
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 62bf879dc623..8c08997dcef6 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -1521,6 +1521,12 @@ static void ice_vsi_set_rss_flow_fld(struct ice_vsi *vsi)
 	if (status)
 		dev_dbg(dev, "ice_add_rss_cfg failed for sctp6 flow, vsi = %d, error = %s\n",
 			vsi_num, ice_stat_str(status));
+
+	status = ice_add_rss_cfg(hw, vsi_handle, ICE_FLOW_HASH_ESP_SPI,
+				 ICE_FLOW_SEG_HDR_ESP);
+	if (status)
+		dev_dbg(dev, "ice_add_rss_cfg failed for esp/spi flow, vsi = %d, error = %d\n",
+			vsi_num, status);
 }
 
 /**
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c b/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
index dc7e5ea6ec15..148d431fcde4 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
@@ -145,9 +145,9 @@ static void sparx5_xtr_grp(struct sparx5 *sparx5, u8 grp, bool byte_swap)
 	skb_put(skb, byte_cnt - ETH_FCS_LEN);
 	eth_skb_pad(skb);
 	skb->protocol = eth_type_trans(skb, netdev);
-	netif_rx(skb);
 	netdev->stats.rx_bytes += skb->len;
 	netdev->stats.rx_packets++;
+	netif_rx(skb);
 }
 
 static int sparx5_inject(struct sparx5 *sparx5,
diff --git a/drivers/net/ieee802154/at86rf230.c b/drivers/net/ieee802154/at86rf230.c
index 7d67f41387f5..4f5ef8a9a9a8 100644
--- a/drivers/net/ieee802154/at86rf230.c
+++ b/drivers/net/ieee802154/at86rf230.c
@@ -100,6 +100,7 @@ struct at86rf230_local {
 	unsigned long cal_timeout;
 	bool is_tx;
 	bool is_tx_from_off;
+	bool was_tx;
 	u8 tx_retry;
 	struct sk_buff *tx_skb;
 	struct at86rf230_state_change tx;
@@ -343,7 +344,11 @@ at86rf230_async_error_recover_complete(void *context)
 	if (ctx->free)
 		kfree(ctx);
 
-	ieee802154_wake_queue(lp->hw);
+	if (lp->was_tx) {
+		lp->was_tx = 0;
+		dev_kfree_skb_any(lp->tx_skb);
+		ieee802154_wake_queue(lp->hw);
+	}
 }
 
 static void
@@ -352,7 +357,11 @@ at86rf230_async_error_recover(void *context)
 	struct at86rf230_state_change *ctx = context;
 	struct at86rf230_local *lp = ctx->lp;
 
-	lp->is_tx = 0;
+	if (lp->is_tx) {
+		lp->was_tx = 1;
+		lp->is_tx = 0;
+	}
+
 	at86rf230_async_state_change(lp, ctx, STATE_RX_AACK_ON,
 				     at86rf230_async_error_recover_complete);
 }
diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
index 97fbe850de9b..96592a20c61f 100644
--- a/drivers/net/ieee802154/ca8210.c
+++ b/drivers/net/ieee802154/ca8210.c
@@ -2977,8 +2977,8 @@ static void ca8210_hw_setup(struct ieee802154_hw *ca8210_hw)
 	ca8210_hw->phy->cca.opt = NL802154_CCA_OPT_ENERGY_CARRIER_AND;
 	ca8210_hw->phy->cca_ed_level = -9800;
 	ca8210_hw->phy->symbol_duration = 16;
-	ca8210_hw->phy->lifs_period = 40;
-	ca8210_hw->phy->sifs_period = 12;
+	ca8210_hw->phy->lifs_period = 40 * ca8210_hw->phy->symbol_duration;
+	ca8210_hw->phy->sifs_period = 12 * ca8210_hw->phy->symbol_duration;
 	ca8210_hw->flags =
 		IEEE802154_HW_AFILT |
 		IEEE802154_HW_OMIT_CKSUM |
diff --git a/drivers/net/netdevsim/fib.c b/drivers/net/netdevsim/fib.c
index 4300261e2f9e..378ee779061c 100644
--- a/drivers/net/netdevsim/fib.c
+++ b/drivers/net/netdevsim/fib.c
@@ -623,14 +623,14 @@ static int nsim_fib6_rt_append(struct nsim_fib_data *data,
 		if (err)
 			goto err_fib6_rt_nh_del;
 
-		fib6_event->rt_arr[i]->trap = true;
+		WRITE_ONCE(fib6_event->rt_arr[i]->trap, true);
 	}
 
 	return 0;
 
 err_fib6_rt_nh_del:
 	for (i--; i >= 0; i--) {
-		fib6_event->rt_arr[i]->trap = false;
+		WRITE_ONCE(fib6_event->rt_arr[i]->trap, false);
 		nsim_fib6_rt_nh_del(fib6_rt, fib6_event->rt_arr[i]);
 	}
 	return err;
diff --git a/drivers/net/phy/mediatek-ge.c b/drivers/net/phy/mediatek-ge.c
index b7a5ae20edd5..68ee434f9dea 100644
--- a/drivers/net/phy/mediatek-ge.c
+++ b/drivers/net/phy/mediatek-ge.c
@@ -55,9 +55,6 @@ static int mt7530_phy_config_init(struct phy_device *phydev)
 
 static int mt7531_phy_config_init(struct phy_device *phydev)
 {
-	if (phydev->interface != PHY_INTERFACE_MODE_INTERNAL)
-		return -EINVAL;
-
 	mtk_gephy_config_init(phydev);
 
 	/* PHY link down power saving enable */
diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 33ada2c59952..0c7f02ca6822 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1395,6 +1395,8 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x413c, 0x81d7, 0)},	/* Dell Wireless 5821e */
 	{QMI_FIXED_INTF(0x413c, 0x81d7, 1)},	/* Dell Wireless 5821e preproduction config */
 	{QMI_FIXED_INTF(0x413c, 0x81e0, 0)},	/* Dell Wireless 5821e with eSIM support*/
+	{QMI_FIXED_INTF(0x413c, 0x81e4, 0)},	/* Dell Wireless 5829e with eSIM support*/
+	{QMI_FIXED_INTF(0x413c, 0x81e6, 0)},	/* Dell Wireless 5829e */
 	{QMI_FIXED_INTF(0x03f0, 0x4e1d, 8)},	/* HP lt4111 LTE/EV-DO/HSPA+ Gobi 4G Module */
 	{QMI_FIXED_INTF(0x03f0, 0x9d1d, 1)},	/* HP lt4120 Snapdragon X5 LTE */
 	{QMI_FIXED_INTF(0x22de, 0x9061, 3)},	/* WeTelecom WPD-600N */
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
index 0eb13e5df517..d99140960a82 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
@@ -693,7 +693,7 @@ int brcmf_fw_get_firmwares(struct device *dev, struct brcmf_fw_request *req,
 {
 	struct brcmf_fw_item *first = &req->items[0];
 	struct brcmf_fw *fwctx;
-	char *alt_path;
+	char *alt_path = NULL;
 	int ret;
 
 	brcmf_dbg(TRACE, "enter: dev=%s\n", dev_name(dev));
@@ -712,7 +712,9 @@ int brcmf_fw_get_firmwares(struct device *dev, struct brcmf_fw_request *req,
 	fwctx->done = fw_cb;
 
 	/* First try alternative board-specific path if any */
-	alt_path = brcm_alt_fw_path(first->path, fwctx->req->board_type);
+	if (fwctx->req->board_type)
+		alt_path = brcm_alt_fw_path(first->path,
+					    fwctx->req->board_type);
 	if (alt_path) {
 		ret = request_firmware_nowait(THIS_MODULE, true, alt_path,
 					      fwctx->dev, GFP_KERNEL, fwctx,
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
index 1efac0b2a94d..9e00d1d7e146 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
  * Copyright (C) 2017 Intel Deutschland GmbH
- * Copyright (C) 2019-2021 Intel Corporation
+ * Copyright (C) 2019-2022 Intel Corporation
  */
 #include <linux/uuid.h>
 #include "iwl-drv.h"
@@ -814,10 +814,11 @@ bool iwl_sar_geo_support(struct iwl_fw_runtime *fwrt)
 	 * only one using version 36, so skip this version entirely.
 	 */
 	return IWL_UCODE_SERIAL(fwrt->fw->ucode_ver) >= 38 ||
-	       IWL_UCODE_SERIAL(fwrt->fw->ucode_ver) == 17 ||
-	       (IWL_UCODE_SERIAL(fwrt->fw->ucode_ver) == 29 &&
-		((fwrt->trans->hw_rev & CSR_HW_REV_TYPE_MSK) ==
-		 CSR_HW_REV_TYPE_7265D));
+		(IWL_UCODE_SERIAL(fwrt->fw->ucode_ver) == 17 &&
+		 fwrt->trans->hw_rev != CSR_HW_REV_TYPE_3160) ||
+		(IWL_UCODE_SERIAL(fwrt->fw->ucode_ver) == 29 &&
+		 ((fwrt->trans->hw_rev & CSR_HW_REV_TYPE_MSK) ==
+		  CSR_HW_REV_TYPE_7265D));
 }
 IWL_EXPORT_SYMBOL(iwl_sar_geo_support);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-csr.h b/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
index 845a09d0daba..c8dff76ac03c 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
 /*
- * Copyright (C) 2005-2014, 2018-2021 Intel Corporation
+ * Copyright (C) 2005-2014, 2018-2022 Intel Corporation
  * Copyright (C) 2013-2014 Intel Mobile Communications GmbH
  * Copyright (C) 2016 Intel Deutschland GmbH
  */
@@ -319,6 +319,7 @@ enum {
 #define CSR_HW_REV_TYPE_2x00		(0x0000100)
 #define CSR_HW_REV_TYPE_105		(0x0000110)
 #define CSR_HW_REV_TYPE_135		(0x0000120)
+#define CSR_HW_REV_TYPE_3160		(0x0000164)
 #define CSR_HW_REV_TYPE_7265D		(0x0000210)
 #define CSR_HW_REV_TYPE_NONE		(0x00001F0)
 #define CSR_HW_REV_TYPE_QNJ		(0x0000360)
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index b7f7b9c5b670..524b0ad87357 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1614,6 +1614,8 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
  out_unbind:
 	complete(&drv->request_firmware_complete);
 	device_release_driver(drv->trans->dev);
+	/* drv has just been freed by the release */
+	failure = false;
  free:
 	if (failure)
 		iwl_dealloc_ucode(drv);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 74404c96063b..bcc032c815dc 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -1572,7 +1572,7 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 	ret = iwl_mvm_sar_init(mvm);
 	if (ret == 0)
 		ret = iwl_mvm_sar_geo_init(mvm);
-	else if (ret < 0)
+	if (ret < 0)
 		goto error;
 
 	iwl_mvm_tas_init(mvm);
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
index bf0c32a74ca4..a9c19be29e92 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
@@ -408,8 +408,7 @@ int iwl_trans_pcie_gen2_start_fw(struct iwl_trans *trans,
 	/* This may fail if AMT took ownership of the device */
 	if (iwl_pcie_prepare_card_hw(trans)) {
 		IWL_WARN(trans, "Exit HW not ready\n");
-		ret = -EIO;
-		goto out;
+		return -EIO;
 	}
 
 	iwl_enable_rfkill_int(trans);
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index f252680f18e8..02da9cc8646c 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1273,8 +1273,7 @@ static int iwl_trans_pcie_start_fw(struct iwl_trans *trans,
 	/* This may fail if AMT took ownership of the device */
 	if (iwl_pcie_prepare_card_hw(trans)) {
 		IWL_WARN(trans, "Exit HW not ready\n");
-		ret = -EIO;
-		goto out;
+		return -EIO;
 	}
 
 	iwl_enable_rfkill_int(trans);
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index f8dd664b2eda..a480e1af48e8 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -131,7 +131,7 @@ static void nvme_set_queue_dying(struct nvme_ns *ns)
 	if (test_and_set_bit(NVME_NS_DEAD, &ns->flags))
 		return;
 
-	blk_set_queue_dying(ns->queue);
+	blk_mark_disk_dead(ns->disk);
 	blk_mq_unquiesce_queue(ns->queue);
 
 	set_capacity_and_notify(ns->disk, 0);
@@ -4187,7 +4187,14 @@ static void nvme_async_event_work(struct work_struct *work)
 		container_of(work, struct nvme_ctrl, async_event_work);
 
 	nvme_aen_uevent(ctrl);
-	ctrl->ops->submit_async_event(ctrl);
+
+	/*
+	 * The transport drivers must guarantee AER submission here is safe by
+	 * flushing ctrl async_event_work after changing the controller state
+	 * from LIVE and before freeing the admin queue.
+	*/
+	if (ctrl->state == NVME_CTRL_LIVE)
+		ctrl->ops->submit_async_event(ctrl);
 }
 
 static bool nvme_ctrl_pp_status(struct nvme_ctrl *ctrl)
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 2f76969408b2..727520c39710 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -792,7 +792,7 @@ void nvme_mpath_remove_disk(struct nvme_ns_head *head)
 {
 	if (!head->disk)
 		return;
-	blk_set_queue_dying(head->disk->queue);
+	blk_mark_disk_dead(head->disk);
 	/* make sure all pending bios are cleaned up */
 	kblockd_schedule_work(&head->requeue_work);
 	flush_work(&head->requeue_work);
diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 0498801542eb..d51f52e296f5 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -1192,6 +1192,7 @@ static void nvme_rdma_error_recovery_work(struct work_struct *work)
 			struct nvme_rdma_ctrl, err_work);
 
 	nvme_stop_keep_alive(&ctrl->ctrl);
+	flush_work(&ctrl->ctrl.async_event_work);
 	nvme_rdma_teardown_io_queues(ctrl, false);
 	nvme_start_queues(&ctrl->ctrl);
 	nvme_rdma_teardown_admin_queue(ctrl, false);
diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index efa9037da53c..ef65d24639c4 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -2105,6 +2105,7 @@ static void nvme_tcp_error_recovery_work(struct work_struct *work)
 	struct nvme_ctrl *ctrl = &tcp_ctrl->ctrl;
 
 	nvme_stop_keep_alive(ctrl);
+	flush_work(&ctrl->async_event_work);
 	nvme_tcp_teardown_io_queues(ctrl, false);
 	/* unquiesce to fail fast pending requests */
 	nvme_start_queues(ctrl);
diff --git a/drivers/parisc/ccio-dma.c b/drivers/parisc/ccio-dma.c
index 059566f54429..9be007c9420f 100644
--- a/drivers/parisc/ccio-dma.c
+++ b/drivers/parisc/ccio-dma.c
@@ -1003,7 +1003,7 @@ ccio_unmap_sg(struct device *dev, struct scatterlist *sglist, int nents,
 	ioc->usg_calls++;
 #endif
 
-	while(sg_dma_len(sglist) && nents--) {
+	while (nents && sg_dma_len(sglist)) {
 
 #ifdef CCIO_COLLECT_STATS
 		ioc->usg_pages += sg_dma_len(sglist) >> PAGE_SHIFT;
@@ -1011,6 +1011,7 @@ ccio_unmap_sg(struct device *dev, struct scatterlist *sglist, int nents,
 		ccio_unmap_page(dev, sg_dma_address(sglist),
 				  sg_dma_len(sglist), direction, 0);
 		++sglist;
+		nents--;
 	}
 
 	DBG_RUN_SG("%s() DONE (nents %d)\n", __func__, nents);
diff --git a/drivers/parisc/sba_iommu.c b/drivers/parisc/sba_iommu.c
index e60690d38d67..374b9199878d 100644
--- a/drivers/parisc/sba_iommu.c
+++ b/drivers/parisc/sba_iommu.c
@@ -1047,7 +1047,7 @@ sba_unmap_sg(struct device *dev, struct scatterlist *sglist, int nents,
 	spin_unlock_irqrestore(&ioc->res_lock, flags);
 #endif
 
-	while (sg_dma_len(sglist) && nents--) {
+	while (nents && sg_dma_len(sglist)) {
 
 		sba_unmap_page(dev, sg_dma_address(sglist), sg_dma_len(sglist),
 				direction, 0);
@@ -1056,6 +1056,7 @@ sba_unmap_sg(struct device *dev, struct scatterlist *sglist, int nents,
 		ioc->usingle_calls--;	/* kluge since call is unmap_sg() */
 #endif
 		++sglist;
+		nents--;
 	}
 
 	DBG_RUN_SG("%s() DONE (nents %d)\n", __func__,  nents);
diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller/pci-hyperv.c
index 67c46e52c0dc..9dd4502d32a4 100644
--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -1899,8 +1899,17 @@ static void hv_pci_assign_numa_node(struct hv_pcibus_device *hbus)
 		if (!hv_dev)
 			continue;
 
-		if (hv_dev->desc.flags & HV_PCI_DEVICE_FLAG_NUMA_AFFINITY)
-			set_dev_node(&dev->dev, hv_dev->desc.virtual_numa_node);
+		if (hv_dev->desc.flags & HV_PCI_DEVICE_FLAG_NUMA_AFFINITY &&
+		    hv_dev->desc.virtual_numa_node < num_possible_nodes())
+			/*
+			 * The kernel may boot with some NUMA nodes offline
+			 * (e.g. in a KDUMP kernel) or with NUMA disabled via
+			 * "numa=off". In those cases, adjust the host provided
+			 * NUMA node to a valid NUMA node used by the kernel.
+			 */
+			set_dev_node(&dev->dev,
+				     numa_map_to_online_node(
+					     hv_dev->desc.virtual_numa_node));
 
 		put_pcichild(hv_dev);
 	}
diff --git a/drivers/phy/broadcom/phy-brcm-usb.c b/drivers/phy/broadcom/phy-brcm-usb.c
index 116fb23aebd9..0f1deb6e0eab 100644
--- a/drivers/phy/broadcom/phy-brcm-usb.c
+++ b/drivers/phy/broadcom/phy-brcm-usb.c
@@ -18,6 +18,7 @@
 #include <linux/soc/brcmstb/brcmstb.h>
 #include <dt-bindings/phy/phy.h>
 #include <linux/mfd/syscon.h>
+#include <linux/suspend.h>
 
 #include "phy-brcm-usb-init.h"
 
@@ -70,12 +71,35 @@ struct brcm_usb_phy_data {
 	int			init_count;
 	int			wake_irq;
 	struct brcm_usb_phy	phys[BRCM_USB_PHY_ID_MAX];
+	struct notifier_block	pm_notifier;
+	bool			pm_active;
 };
 
 static s8 *node_reg_names[BRCM_REGS_MAX] = {
 	"crtl", "xhci_ec", "xhci_gbl", "usb_phy", "usb_mdio", "bdc_ec"
 };
 
+static int brcm_pm_notifier(struct notifier_block *notifier,
+			    unsigned long pm_event,
+			    void *unused)
+{
+	struct brcm_usb_phy_data *priv =
+		container_of(notifier, struct brcm_usb_phy_data, pm_notifier);
+
+	switch (pm_event) {
+	case PM_HIBERNATION_PREPARE:
+	case PM_SUSPEND_PREPARE:
+		priv->pm_active = true;
+		break;
+	case PM_POST_RESTORE:
+	case PM_POST_HIBERNATION:
+	case PM_POST_SUSPEND:
+		priv->pm_active = false;
+		break;
+	}
+	return NOTIFY_DONE;
+}
+
 static irqreturn_t brcm_usb_phy_wake_isr(int irq, void *dev_id)
 {
 	struct phy *gphy = dev_id;
@@ -91,6 +115,9 @@ static int brcm_usb_phy_init(struct phy *gphy)
 	struct brcm_usb_phy_data *priv =
 		container_of(phy, struct brcm_usb_phy_data, phys[phy->id]);
 
+	if (priv->pm_active)
+		return 0;
+
 	/*
 	 * Use a lock to make sure a second caller waits until
 	 * the base phy is inited before using it.
@@ -120,6 +147,9 @@ static int brcm_usb_phy_exit(struct phy *gphy)
 	struct brcm_usb_phy_data *priv =
 		container_of(phy, struct brcm_usb_phy_data, phys[phy->id]);
 
+	if (priv->pm_active)
+		return 0;
+
 	dev_dbg(&gphy->dev, "EXIT\n");
 	if (phy->id == BRCM_USB_PHY_2_0)
 		brcm_usb_uninit_eohci(&priv->ini);
@@ -488,6 +518,9 @@ static int brcm_usb_phy_probe(struct platform_device *pdev)
 	if (err)
 		return err;
 
+	priv->pm_notifier.notifier_call = brcm_pm_notifier;
+	register_pm_notifier(&priv->pm_notifier);
+
 	mutex_init(&priv->mutex);
 
 	/* make sure invert settings are correct */
@@ -528,7 +561,10 @@ static int brcm_usb_phy_probe(struct platform_device *pdev)
 
 static int brcm_usb_phy_remove(struct platform_device *pdev)
 {
+	struct brcm_usb_phy_data *priv = dev_get_drvdata(&pdev->dev);
+
 	sysfs_remove_group(&pdev->dev.kobj, &brcm_usb_phy_group);
+	unregister_pm_notifier(&priv->pm_notifier);
 
 	return 0;
 }
@@ -539,6 +575,7 @@ static int brcm_usb_phy_suspend(struct device *dev)
 	struct brcm_usb_phy_data *priv = dev_get_drvdata(dev);
 
 	if (priv->init_count) {
+		dev_dbg(dev, "SUSPEND\n");
 		priv->ini.wake_enabled = device_may_wakeup(dev);
 		if (priv->phys[BRCM_USB_PHY_3_0].inited)
 			brcm_usb_uninit_xhci(&priv->ini);
@@ -578,6 +615,7 @@ static int brcm_usb_phy_resume(struct device *dev)
 	 * Uninitialize anything that wasn't previously initialized.
 	 */
 	if (priv->init_count) {
+		dev_dbg(dev, "RESUME\n");
 		if (priv->wake_irq >= 0)
 			disable_irq_wake(priv->wake_irq);
 		brcm_usb_init_common(&priv->ini);
diff --git a/drivers/phy/mediatek/phy-mtk-tphy.c b/drivers/phy/mediatek/phy-mtk-tphy.c
index 98a942c607a6..db39b0c4649a 100644
--- a/drivers/phy/mediatek/phy-mtk-tphy.c
+++ b/drivers/phy/mediatek/phy-mtk-tphy.c
@@ -1125,7 +1125,7 @@ static int phy_efuse_get(struct mtk_tphy *tphy, struct mtk_phy_instance *instanc
 		/* no efuse, ignore it */
 		if (!instance->efuse_intr &&
 		    !instance->efuse_rx_imp &&
-		    !instance->efuse_rx_imp) {
+		    !instance->efuse_tx_imp) {
 			dev_warn(dev, "no u3 intr efuse, but dts enable it\n");
 			instance->efuse_sw_en = 0;
 			break;
diff --git a/drivers/pinctrl/bcm/Kconfig b/drivers/pinctrl/bcm/Kconfig
index c9c5efc92731..5973a279e6b8 100644
--- a/drivers/pinctrl/bcm/Kconfig
+++ b/drivers/pinctrl/bcm/Kconfig
@@ -35,6 +35,7 @@ config PINCTRL_BCM63XX
 	select PINCONF
 	select GENERIC_PINCONF
 	select GPIOLIB
+	select REGMAP
 	select GPIO_REGMAP
 
 config PINCTRL_BCM6318
diff --git a/drivers/platform/x86/intel/speed_select_if/isst_if_common.c b/drivers/platform/x86/intel/speed_select_if/isst_if_common.c
index c9a85eb2e860..e8424e70d81d 100644
--- a/drivers/platform/x86/intel/speed_select_if/isst_if_common.c
+++ b/drivers/platform/x86/intel/speed_select_if/isst_if_common.c
@@ -596,7 +596,10 @@ static long isst_if_def_ioctl(struct file *file, unsigned int cmd,
 	return ret;
 }
 
-static DEFINE_MUTEX(punit_misc_dev_lock);
+/* Lock to prevent module registration when already opened by user space */
+static DEFINE_MUTEX(punit_misc_dev_open_lock);
+/* Lock to allow one share misc device for all ISST interace */
+static DEFINE_MUTEX(punit_misc_dev_reg_lock);
 static int misc_usage_count;
 static int misc_device_ret;
 static int misc_device_open;
@@ -606,7 +609,7 @@ static int isst_if_open(struct inode *inode, struct file *file)
 	int i, ret = 0;
 
 	/* Fail open, if a module is going away */
-	mutex_lock(&punit_misc_dev_lock);
+	mutex_lock(&punit_misc_dev_open_lock);
 	for (i = 0; i < ISST_IF_DEV_MAX; ++i) {
 		struct isst_if_cmd_cb *cb = &punit_callbacks[i];
 
@@ -628,7 +631,7 @@ static int isst_if_open(struct inode *inode, struct file *file)
 	} else {
 		misc_device_open++;
 	}
-	mutex_unlock(&punit_misc_dev_lock);
+	mutex_unlock(&punit_misc_dev_open_lock);
 
 	return ret;
 }
@@ -637,7 +640,7 @@ static int isst_if_relase(struct inode *inode, struct file *f)
 {
 	int i;
 
-	mutex_lock(&punit_misc_dev_lock);
+	mutex_lock(&punit_misc_dev_open_lock);
 	misc_device_open--;
 	for (i = 0; i < ISST_IF_DEV_MAX; ++i) {
 		struct isst_if_cmd_cb *cb = &punit_callbacks[i];
@@ -645,7 +648,7 @@ static int isst_if_relase(struct inode *inode, struct file *f)
 		if (cb->registered)
 			module_put(cb->owner);
 	}
-	mutex_unlock(&punit_misc_dev_lock);
+	mutex_unlock(&punit_misc_dev_open_lock);
 
 	return 0;
 }
@@ -662,6 +665,43 @@ static struct miscdevice isst_if_char_driver = {
 	.fops		= &isst_if_char_driver_ops,
 };
 
+static int isst_misc_reg(void)
+{
+	mutex_lock(&punit_misc_dev_reg_lock);
+	if (misc_device_ret)
+		goto unlock_exit;
+
+	if (!misc_usage_count) {
+		misc_device_ret = isst_if_cpu_info_init();
+		if (misc_device_ret)
+			goto unlock_exit;
+
+		misc_device_ret = misc_register(&isst_if_char_driver);
+		if (misc_device_ret) {
+			isst_if_cpu_info_exit();
+			goto unlock_exit;
+		}
+	}
+	misc_usage_count++;
+
+unlock_exit:
+	mutex_unlock(&punit_misc_dev_reg_lock);
+
+	return misc_device_ret;
+}
+
+static void isst_misc_unreg(void)
+{
+	mutex_lock(&punit_misc_dev_reg_lock);
+	if (misc_usage_count)
+		misc_usage_count--;
+	if (!misc_usage_count && !misc_device_ret) {
+		misc_deregister(&isst_if_char_driver);
+		isst_if_cpu_info_exit();
+	}
+	mutex_unlock(&punit_misc_dev_reg_lock);
+}
+
 /**
  * isst_if_cdev_register() - Register callback for IOCTL
  * @device_type: The device type this callback handling.
@@ -679,38 +719,31 @@ static struct miscdevice isst_if_char_driver = {
  */
 int isst_if_cdev_register(int device_type, struct isst_if_cmd_cb *cb)
 {
-	if (misc_device_ret)
-		return misc_device_ret;
+	int ret;
 
 	if (device_type >= ISST_IF_DEV_MAX)
 		return -EINVAL;
 
-	mutex_lock(&punit_misc_dev_lock);
+	mutex_lock(&punit_misc_dev_open_lock);
+	/* Device is already open, we don't want to add new callbacks */
 	if (misc_device_open) {
-		mutex_unlock(&punit_misc_dev_lock);
+		mutex_unlock(&punit_misc_dev_open_lock);
 		return -EAGAIN;
 	}
-	if (!misc_usage_count) {
-		int ret;
-
-		misc_device_ret = misc_register(&isst_if_char_driver);
-		if (misc_device_ret)
-			goto unlock_exit;
-
-		ret = isst_if_cpu_info_init();
-		if (ret) {
-			misc_deregister(&isst_if_char_driver);
-			misc_device_ret = ret;
-			goto unlock_exit;
-		}
-	}
 	memcpy(&punit_callbacks[device_type], cb, sizeof(*cb));
 	punit_callbacks[device_type].registered = 1;
-	misc_usage_count++;
-unlock_exit:
-	mutex_unlock(&punit_misc_dev_lock);
+	mutex_unlock(&punit_misc_dev_open_lock);
 
-	return misc_device_ret;
+	ret = isst_misc_reg();
+	if (ret) {
+		/*
+		 * No need of mutex as the misc device register failed
+		 * as no one can open device yet. Hence no contention.
+		 */
+		punit_callbacks[device_type].registered = 0;
+		return ret;
+	}
+	return 0;
 }
 EXPORT_SYMBOL_GPL(isst_if_cdev_register);
 
@@ -725,16 +758,12 @@ EXPORT_SYMBOL_GPL(isst_if_cdev_register);
  */
 void isst_if_cdev_unregister(int device_type)
 {
-	mutex_lock(&punit_misc_dev_lock);
-	misc_usage_count--;
+	isst_misc_unreg();
+	mutex_lock(&punit_misc_dev_open_lock);
 	punit_callbacks[device_type].registered = 0;
 	if (device_type == ISST_IF_DEV_MBOX)
 		isst_delete_hash();
-	if (!misc_usage_count && !misc_device_ret) {
-		misc_deregister(&isst_if_char_driver);
-		isst_if_cpu_info_exit();
-	}
-	mutex_unlock(&punit_misc_dev_lock);
+	mutex_unlock(&punit_misc_dev_open_lock);
 }
 EXPORT_SYMBOL_GPL(isst_if_cdev_unregister);
 
diff --git a/drivers/platform/x86/touchscreen_dmi.c b/drivers/platform/x86/touchscreen_dmi.c
index 033f797861d8..c608078538a7 100644
--- a/drivers/platform/x86/touchscreen_dmi.c
+++ b/drivers/platform/x86/touchscreen_dmi.c
@@ -773,6 +773,21 @@ static const struct ts_dmi_data predia_basic_data = {
 	.properties	= predia_basic_props,
 };
 
+static const struct property_entry rwc_nanote_p8_props[] = {
+	PROPERTY_ENTRY_U32("touchscreen-min-y", 46),
+	PROPERTY_ENTRY_U32("touchscreen-size-x", 1728),
+	PROPERTY_ENTRY_U32("touchscreen-size-y", 1140),
+	PROPERTY_ENTRY_BOOL("touchscreen-inverted-y"),
+	PROPERTY_ENTRY_STRING("firmware-name", "gsl1680-rwc-nanote-p8.fw"),
+	PROPERTY_ENTRY_U32("silead,max-fingers", 10),
+	{ }
+};
+
+static const struct ts_dmi_data rwc_nanote_p8_data = {
+	.acpi_name = "MSSL1680:00",
+	.properties = rwc_nanote_p8_props,
+};
+
 static const struct property_entry schneider_sct101ctm_props[] = {
 	PROPERTY_ENTRY_U32("touchscreen-size-x", 1715),
 	PROPERTY_ENTRY_U32("touchscreen-size-y", 1140),
@@ -1379,6 +1394,15 @@ const struct dmi_system_id touchscreen_dmi_table[] = {
 			DMI_EXACT_MATCH(DMI_BOARD_NAME, "0E57"),
 		},
 	},
+	{
+		/* RWC NANOTE P8 */
+		.driver_data = (void *)&rwc_nanote_p8_data,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Default string"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "AY07J"),
+			DMI_MATCH(DMI_PRODUCT_SKU, "0001")
+		},
+	},
 	{
 		/* Schneider SCT101CTM */
 		.driver_data = (void *)&schneider_sct101ctm_data,
diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index f66ba64080a3..1044832b6054 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -593,6 +593,7 @@ struct lpfc_vport {
 #define FC_VPORT_LOGO_RCVD      0x200    /* LOGO received on vport */
 #define FC_RSCN_DISCOVERY       0x400	 /* Auth all devices after RSCN */
 #define FC_LOGO_RCVD_DID_CHNG   0x800    /* FDISC on phys port detect DID chng*/
+#define FC_PT2PT_NO_NVME        0x1000   /* Don't send NVME PRLI */
 #define FC_SCSI_SCAN_TMO        0x4000	 /* scsi scan timer running */
 #define FC_ABORT_DISCOVERY      0x8000	 /* we want to abort discovery */
 #define FC_NDISC_ACTIVE         0x10000	 /* NPort discovery active */
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 632b9cdabd14..9f3f7805f1f9 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -1315,6 +1315,9 @@ lpfc_issue_lip(struct Scsi_Host *shost)
 	pmboxq->u.mb.mbxCommand = MBX_DOWN_LINK;
 	pmboxq->u.mb.mbxOwner = OWN_HOST;
 
+	if ((vport->fc_flag & FC_PT2PT) && (vport->fc_flag & FC_PT2PT_NO_NVME))
+		vport->fc_flag &= ~FC_PT2PT_NO_NVME;
+
 	mbxstatus = lpfc_sli_issue_mbox_wait(phba, pmboxq, LPFC_MBOX_TMO * 2);
 
 	if ((mbxstatus == MBX_SUCCESS) &&
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index f08ab8269f44..886006ad12a2 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1072,7 +1072,8 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 
 		/* FLOGI failed, so there is no fabric */
 		spin_lock_irq(shost->host_lock);
-		vport->fc_flag &= ~(FC_FABRIC | FC_PUBLIC_LOOP);
+		vport->fc_flag &= ~(FC_FABRIC | FC_PUBLIC_LOOP |
+				    FC_PT2PT_NO_NVME);
 		spin_unlock_irq(shost->host_lock);
 
 		/* If private loop, then allow max outstanding els to be
@@ -4587,6 +4588,23 @@ lpfc_els_retry(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		/* Added for Vendor specifc support
 		 * Just keep retrying for these Rsn / Exp codes
 		 */
+		if ((vport->fc_flag & FC_PT2PT) &&
+		    cmd == ELS_CMD_NVMEPRLI) {
+			switch (stat.un.b.lsRjtRsnCode) {
+			case LSRJT_UNABLE_TPC:
+			case LSRJT_INVALID_CMD:
+			case LSRJT_LOGICAL_ERR:
+			case LSRJT_CMD_UNSUPPORTED:
+				lpfc_printf_vlog(vport, KERN_WARNING, LOG_ELS,
+						 "0168 NVME PRLI LS_RJT "
+						 "reason %x port doesn't "
+						 "support NVME, disabling NVME\n",
+						 stat.un.b.lsRjtRsnCode);
+				retry = 0;
+				vport->fc_flag |= FC_PT2PT_NO_NVME;
+				goto out_retry;
+			}
+		}
 		switch (stat.un.b.lsRjtRsnCode) {
 		case LSRJT_UNABLE_TPC:
 			/* The driver has a VALID PLOGI but the rport has
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 7d717a4ac14d..fdf5e777bf11 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -1961,8 +1961,9 @@ lpfc_cmpl_reglogin_reglogin_issue(struct lpfc_vport *vport,
 			 * is configured try it.
 			 */
 			ndlp->nlp_fc4_type |= NLP_FC4_FCP;
-			if ((vport->cfg_enable_fc4_type == LPFC_ENABLE_BOTH) ||
-			    (vport->cfg_enable_fc4_type == LPFC_ENABLE_NVME)) {
+			if ((!(vport->fc_flag & FC_PT2PT_NO_NVME)) &&
+			    (vport->cfg_enable_fc4_type == LPFC_ENABLE_BOTH ||
+			    vport->cfg_enable_fc4_type == LPFC_ENABLE_NVME)) {
 				ndlp->nlp_fc4_type |= NLP_FC4_NVME;
 				/* We need to update the localport also */
 				lpfc_nvme_update_localport(vport);
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 2978c61dc586..68d8e55c1205 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -8147,6 +8147,7 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 	struct lpfc_vport *vport = phba->pport;
 	struct lpfc_dmabuf *mp;
 	struct lpfc_rqb *rqbp;
+	u32 flg;
 
 	/* Perform a PCI function reset to start from clean */
 	rc = lpfc_pci_function_reset(phba);
@@ -8160,7 +8161,17 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 	else {
 		spin_lock_irq(&phba->hbalock);
 		phba->sli.sli_flag |= LPFC_SLI_ACTIVE;
+		flg = phba->sli.sli_flag;
 		spin_unlock_irq(&phba->hbalock);
+		/* Allow a little time after setting SLI_ACTIVE for any polled
+		 * MBX commands to complete via BSG.
+		 */
+		for (i = 0; i < 50 && (flg & LPFC_SLI_MBOX_ACTIVE); i++) {
+			msleep(20);
+			spin_lock_irq(&phba->hbalock);
+			flg = phba->sli.sli_flag;
+			spin_unlock_irq(&phba->hbalock);
+		}
 	}
 
 	lpfc_sli4_dip(phba);
@@ -9744,7 +9755,7 @@ lpfc_sli_issue_mbox_s4(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq,
 					"(%d):2541 Mailbox command x%x "
 					"(x%x/x%x) failure: "
 					"mqe_sta: x%x mcqe_sta: x%x/x%x "
-					"Data: x%x x%x\n,",
+					"Data: x%x x%x\n",
 					mboxq->vport ? mboxq->vport->vpi : 0,
 					mboxq->u.mb.mbxCommand,
 					lpfc_sli_config_mbox_subsys_get(phba,
@@ -9778,7 +9789,7 @@ lpfc_sli_issue_mbox_s4(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq,
 					"(%d):2597 Sync Mailbox command "
 					"x%x (x%x/x%x) failure: "
 					"mqe_sta: x%x mcqe_sta: x%x/x%x "
-					"Data: x%x x%x\n,",
+					"Data: x%x x%x\n",
 					mboxq->vport ? mboxq->vport->vpi : 0,
 					mboxq->u.mb.mbxCommand,
 					lpfc_sli_config_mbox_subsys_get(phba,
diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 880e1f356def..5e6b23da4157 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -2695,7 +2695,6 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	u32 tag = le32_to_cpu(psataPayload->tag);
 	u32 port_id = le32_to_cpu(psataPayload->port_id);
 	u32 dev_id = le32_to_cpu(psataPayload->device_id);
-	unsigned long flags;
 
 	ccb = &pm8001_ha->ccb_info[tag];
 
@@ -2735,8 +2734,6 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DATA_OVERRUN;
 		ts->residual = 0;
-		if (pm8001_dev)
-			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_XFER_ERROR_BREAK:
 		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_BREAK\n");
@@ -2778,7 +2775,6 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 				IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS);
 			ts->resp = SAS_TASK_COMPLETE;
 			ts->stat = SAS_QUEUE_FULL;
-			pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
 			return;
 		}
 		break;
@@ -2864,20 +2860,6 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		ts->stat = SAS_OPEN_TO;
 		break;
 	}
-	spin_lock_irqsave(&t->task_state_lock, flags);
-	t->task_state_flags &= ~SAS_TASK_STATE_PENDING;
-	t->task_state_flags &= ~SAS_TASK_AT_INITIATOR;
-	t->task_state_flags |= SAS_TASK_STATE_DONE;
-	if (unlikely((t->task_state_flags & SAS_TASK_STATE_ABORTED))) {
-		spin_unlock_irqrestore(&t->task_state_lock, flags);
-		pm8001_dbg(pm8001_ha, FAIL,
-			   "task 0x%p done with io_status 0x%x resp 0x%x stat 0x%x but aborted by upper layer!\n",
-			   t, event, ts->resp, ts->stat);
-		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
-	} else {
-		spin_unlock_irqrestore(&t->task_state_lock, flags);
-		pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
-	}
 }
 
 /*See the comments for mpi_ssp_completion */
diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index 32e60f0c3b14..491cecbbe1aa 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -753,8 +753,13 @@ static int pm8001_exec_internal_tmf_task(struct domain_device *dev,
 		res = -TMF_RESP_FUNC_FAILED;
 		/* Even TMF timed out, return direct. */
 		if (task->task_state_flags & SAS_TASK_STATE_ABORTED) {
+			struct pm8001_ccb_info *ccb = task->lldd_task;
+
 			pm8001_dbg(pm8001_ha, FAIL, "TMF task[%x]timeout.\n",
 				   tmf->tmf);
+
+			if (ccb)
+				ccb->task = NULL;
 			goto ex_err;
 		}
 
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index ed13e0e044b7..3056f3615ab8 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -2184,9 +2184,9 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		pm8001_dbg(pm8001_ha, FAIL,
 			   "task 0x%p done with io_status 0x%x resp 0x%x stat 0x%x but aborted by upper layer!\n",
 			   t, status, ts->resp, ts->stat);
+		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
 		if (t->slow_task)
 			complete(&t->slow_task->completion);
-		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
 	} else {
 		spin_unlock_irqrestore(&t->task_state_lock, flags);
 		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
@@ -2801,9 +2801,9 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha,
 		pm8001_dbg(pm8001_ha, FAIL,
 			   "task 0x%p done with io_status 0x%x resp 0x%x stat 0x%x but aborted by upper layer!\n",
 			   t, status, ts->resp, ts->stat);
+		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
 		if (t->slow_task)
 			complete(&t->slow_task->completion);
-		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
 	} else {
 		spin_unlock_irqrestore(&t->task_state_lock, flags);
 		spin_unlock_irqrestore(&circularQ->oq_lock,
@@ -2828,7 +2828,6 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha,
 	u32 tag = le32_to_cpu(psataPayload->tag);
 	u32 port_id = le32_to_cpu(psataPayload->port_id);
 	u32 dev_id = le32_to_cpu(psataPayload->device_id);
-	unsigned long flags;
 
 	ccb = &pm8001_ha->ccb_info[tag];
 
@@ -2866,8 +2865,6 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha,
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DATA_OVERRUN;
 		ts->residual = 0;
-		if (pm8001_dev)
-			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_XFER_ERROR_BREAK:
 		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_BREAK\n");
@@ -2916,11 +2913,6 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha,
 				IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS);
 			ts->resp = SAS_TASK_COMPLETE;
 			ts->stat = SAS_QUEUE_FULL;
-			spin_unlock_irqrestore(&circularQ->oq_lock,
-					circularQ->lock_flags);
-			pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
-			spin_lock_irqsave(&circularQ->oq_lock,
-					circularQ->lock_flags);
 			return;
 		}
 		break;
@@ -3020,24 +3012,6 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha,
 		ts->stat = SAS_OPEN_TO;
 		break;
 	}
-	spin_lock_irqsave(&t->task_state_lock, flags);
-	t->task_state_flags &= ~SAS_TASK_STATE_PENDING;
-	t->task_state_flags &= ~SAS_TASK_AT_INITIATOR;
-	t->task_state_flags |= SAS_TASK_STATE_DONE;
-	if (unlikely((t->task_state_flags & SAS_TASK_STATE_ABORTED))) {
-		spin_unlock_irqrestore(&t->task_state_lock, flags);
-		pm8001_dbg(pm8001_ha, FAIL,
-			   "task 0x%p done with io_status 0x%x resp 0x%x stat 0x%x but aborted by upper layer!\n",
-			   t, event, ts->resp, ts->stat);
-		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
-	} else {
-		spin_unlock_irqrestore(&t->task_state_lock, flags);
-		spin_unlock_irqrestore(&circularQ->oq_lock,
-				circularQ->lock_flags);
-		pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
-		spin_lock_irqsave(&circularQ->oq_lock,
-				circularQ->lock_flags);
-	}
 }
 
 /*See the comments for mpi_ssp_completion */
diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index d01cd829ef97..df9ce6ed52bf 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -772,11 +772,10 @@ static void qedi_process_cmd_cleanup_resp(struct qedi_ctx *qedi,
 			qedi_cmd->list_tmf_work = NULL;
 		}
 	}
+	spin_unlock_bh(&qedi_conn->tmf_work_lock);
 
-	if (!found) {
-		spin_unlock_bh(&qedi_conn->tmf_work_lock);
+	if (!found)
 		goto check_cleanup_reqs;
-	}
 
 	QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_SCSI_TM,
 		  "TMF work, cqe->tid=0x%x, tmf flags=0x%x, cid=0x%x\n",
@@ -807,7 +806,6 @@ static void qedi_process_cmd_cleanup_resp(struct qedi_ctx *qedi,
 	qedi_cmd->state = CLEANUP_RECV;
 unlock:
 	spin_unlock_bh(&conn->session->back_lock);
-	spin_unlock_bh(&qedi_conn->tmf_work_lock);
 	wake_up_interruptible(&qedi_conn->wait_queue);
 	return;
 
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index fe22191522a3..7266880c70c2 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -198,6 +198,48 @@ static void scsi_unlock_floptical(struct scsi_device *sdev,
 			 SCSI_TIMEOUT, 3, NULL);
 }
 
+static int scsi_realloc_sdev_budget_map(struct scsi_device *sdev,
+					unsigned int depth)
+{
+	int new_shift = sbitmap_calculate_shift(depth);
+	bool need_alloc = !sdev->budget_map.map;
+	bool need_free = false;
+	int ret;
+	struct sbitmap sb_backup;
+
+	/*
+	 * realloc if new shift is calculated, which is caused by setting
+	 * up one new default queue depth after calling ->slave_configure
+	 */
+	if (!need_alloc && new_shift != sdev->budget_map.shift)
+		need_alloc = need_free = true;
+
+	if (!need_alloc)
+		return 0;
+
+	/*
+	 * Request queue has to be frozen for reallocating budget map,
+	 * and here disk isn't added yet, so freezing is pretty fast
+	 */
+	if (need_free) {
+		blk_mq_freeze_queue(sdev->request_queue);
+		sb_backup = sdev->budget_map;
+	}
+	ret = sbitmap_init_node(&sdev->budget_map,
+				scsi_device_max_queue_depth(sdev),
+				new_shift, GFP_KERNEL,
+				sdev->request_queue->node, false, true);
+	if (need_free) {
+		if (ret)
+			sdev->budget_map = sb_backup;
+		else
+			sbitmap_free(&sb_backup);
+		ret = 0;
+		blk_mq_unfreeze_queue(sdev->request_queue);
+	}
+	return ret;
+}
+
 /**
  * scsi_alloc_sdev - allocate and setup a scsi_Device
  * @starget: which target to allocate a &scsi_device for
@@ -291,11 +333,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	 * default device queue depth to figure out sbitmap shift
 	 * since we use this queue depth most of times.
 	 */
-	if (sbitmap_init_node(&sdev->budget_map,
-				scsi_device_max_queue_depth(sdev),
-				sbitmap_calculate_shift(depth),
-				GFP_KERNEL, sdev->request_queue->node,
-				false, true)) {
+	if (scsi_realloc_sdev_budget_map(sdev, depth)) {
 		put_device(&starget->dev);
 		kfree(sdev);
 		goto out;
@@ -1001,6 +1039,13 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 			}
 			return SCSI_SCAN_NO_RESPONSE;
 		}
+
+		/*
+		 * The queue_depth is often changed in ->slave_configure.
+		 * Set up budget map again since memory consumption of
+		 * the map depends on actual queue depth.
+		 */
+		scsi_realloc_sdev_budget_map(sdev, sdev->queue_depth);
 	}
 
 	if (sdev->scsi_level >= SCSI_3)
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index f489954e4632..cdec85bcc4cc 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -125,8 +125,9 @@ EXPORT_SYMBOL_GPL(ufshcd_dump_regs);
 enum {
 	UFSHCD_MAX_CHANNEL	= 0,
 	UFSHCD_MAX_ID		= 1,
-	UFSHCD_CMD_PER_LUN	= 32,
-	UFSHCD_CAN_QUEUE	= 32,
+	UFSHCD_NUM_RESERVED	= 1,
+	UFSHCD_CMD_PER_LUN	= 32 - UFSHCD_NUM_RESERVED,
+	UFSHCD_CAN_QUEUE	= 32 - UFSHCD_NUM_RESERVED,
 };
 
 /* UFSHCD error handling flags */
@@ -2185,6 +2186,7 @@ static inline int ufshcd_hba_capabilities(struct ufs_hba *hba)
 	hba->nutrs = (hba->capabilities & MASK_TRANSFER_REQUESTS_SLOTS) + 1;
 	hba->nutmrs =
 	((hba->capabilities & MASK_TASK_MANAGEMENT_REQUEST_SLOTS) >> 16) + 1;
+	hba->reserved_slot = hba->nutrs - 1;
 
 	/* Read crypto capabilities */
 	err = ufshcd_hba_init_crypto_capabilities(hba);
@@ -2910,30 +2912,15 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba *hba,
 static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 		enum dev_cmd_type cmd_type, int timeout)
 {
-	struct request_queue *q = hba->cmd_queue;
 	DECLARE_COMPLETION_ONSTACK(wait);
-	struct request *req;
+	const u32 tag = hba->reserved_slot;
 	struct ufshcd_lrb *lrbp;
 	int err;
-	int tag;
 
-	down_read(&hba->clk_scaling_lock);
+	/* Protects use of hba->reserved_slot. */
+	lockdep_assert_held(&hba->dev_cmd.lock);
 
-	/*
-	 * Get free slot, sleep if slots are unavailable.
-	 * Even though we use wait_event() which sleeps indefinitely,
-	 * the maximum wait time is bounded by SCSI request timeout.
-	 */
-	req = blk_get_request(q, REQ_OP_DRV_OUT, 0);
-	if (IS_ERR(req)) {
-		err = PTR_ERR(req);
-		goto out_unlock;
-	}
-	tag = req->tag;
-	WARN_ONCE(tag < 0, "Invalid tag %d\n", tag);
-	/* Set the timeout such that the SCSI error handler is not activated. */
-	req->timeout = msecs_to_jiffies(2 * timeout);
-	blk_mq_start_request(req);
+	down_read(&hba->clk_scaling_lock);
 
 	lrbp = &hba->lrb[tag];
 	WARN_ON(lrbp->cmd);
@@ -2951,8 +2938,6 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 				    (struct utp_upiu_req *)lrbp->ucd_rsp_ptr);
 
 out:
-	blk_put_request(req);
-out_unlock:
 	up_read(&hba->clk_scaling_lock);
 	return err;
 }
@@ -6640,28 +6625,16 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 					enum dev_cmd_type cmd_type,
 					enum query_opcode desc_op)
 {
-	struct request_queue *q = hba->cmd_queue;
 	DECLARE_COMPLETION_ONSTACK(wait);
-	struct request *req;
+	const u32 tag = hba->reserved_slot;
 	struct ufshcd_lrb *lrbp;
 	int err = 0;
-	int tag;
 	u8 upiu_flags;
 
-	down_read(&hba->clk_scaling_lock);
-
-	req = blk_get_request(q, REQ_OP_DRV_OUT, 0);
-	if (IS_ERR(req)) {
-		err = PTR_ERR(req);
-		goto out_unlock;
-	}
-	tag = req->tag;
-	WARN_ONCE(tag < 0, "Invalid tag %d\n", tag);
+	/* Protects use of hba->reserved_slot. */
+	lockdep_assert_held(&hba->dev_cmd.lock);
 
-	if (unlikely(test_bit(tag, &hba->outstanding_reqs))) {
-		err = -EBUSY;
-		goto out;
-	}
+	down_read(&hba->clk_scaling_lock);
 
 	lrbp = &hba->lrb[tag];
 	WARN_ON(lrbp->cmd);
@@ -6730,9 +6703,6 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 	ufshcd_add_query_upiu_trace(hba, err ? UFS_QUERY_ERR : UFS_QUERY_COMP,
 				    (struct utp_upiu_req *)lrbp->ucd_rsp_ptr);
 
-out:
-	blk_put_request(req);
-out_unlock:
 	up_read(&hba->clk_scaling_lock);
 	return err;
 }
@@ -9423,8 +9393,8 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	/* Configure LRB */
 	ufshcd_host_memory_configure(hba);
 
-	host->can_queue = hba->nutrs;
-	host->cmd_per_lun = hba->nutrs;
+	host->can_queue = hba->nutrs - UFSHCD_NUM_RESERVED;
+	host->cmd_per_lun = hba->nutrs - UFSHCD_NUM_RESERVED;
 	host->max_id = UFSHCD_MAX_ID;
 	host->max_lun = UFS_MAX_LUNS;
 	host->max_channel = UFSHCD_MAX_CHANNEL;
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 07ada6676c3b..d470a52ff24c 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -725,6 +725,7 @@ struct ufs_hba_monitor {
  * @capabilities: UFS Controller Capabilities
  * @nutrs: Transfer Request Queue depth supported by controller
  * @nutmrs: Task Management Queue depth supported by controller
+ * @reserved_slot: Used to submit device commands. Protected by @dev_cmd.lock.
  * @ufs_version: UFS Version to which controller complies
  * @vops: pointer to variant specific operations
  * @priv: pointer to variant specific private data
@@ -813,6 +814,7 @@ struct ufs_hba {
 	u32 capabilities;
 	int nutrs;
 	int nutmrs;
+	u32 reserved_slot;
 	u32 ufs_version;
 	const struct ufs_hba_variant_ops *vops;
 	struct ufs_hba_variant_params *vps;
diff --git a/drivers/soc/aspeed/aspeed-lpc-ctrl.c b/drivers/soc/aspeed/aspeed-lpc-ctrl.c
index 72771e018c42..258894ed234b 100644
--- a/drivers/soc/aspeed/aspeed-lpc-ctrl.c
+++ b/drivers/soc/aspeed/aspeed-lpc-ctrl.c
@@ -306,10 +306,9 @@ static int aspeed_lpc_ctrl_probe(struct platform_device *pdev)
 	}
 
 	lpc_ctrl->clk = devm_clk_get(dev, NULL);
-	if (IS_ERR(lpc_ctrl->clk)) {
-		dev_err(dev, "couldn't get clock\n");
-		return PTR_ERR(lpc_ctrl->clk);
-	}
+	if (IS_ERR(lpc_ctrl->clk))
+		return dev_err_probe(dev, PTR_ERR(lpc_ctrl->clk),
+				     "couldn't get clock\n");
 	rc = clk_prepare_enable(lpc_ctrl->clk);
 	if (rc) {
 		dev_err(dev, "couldn't enable clock\n");
diff --git a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
index 967f10b9582a..ea9a53bdb417 100644
--- a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
+++ b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
@@ -1033,15 +1033,27 @@ service_callback(enum vchiq_reason reason, struct vchiq_header *header,
 
 	DEBUG_TRACE(SERVICE_CALLBACK_LINE);
 
+	rcu_read_lock();
 	service = handle_to_service(handle);
-	if (WARN_ON(!service))
+	if (WARN_ON(!service)) {
+		rcu_read_unlock();
 		return VCHIQ_SUCCESS;
+	}
 
 	user_service = (struct user_service *)service->base.userdata;
 	instance = user_service->instance;
 
-	if (!instance || instance->closing)
+	if (!instance || instance->closing) {
+		rcu_read_unlock();
 		return VCHIQ_SUCCESS;
+	}
+
+	/*
+	 * As hopping around different synchronization mechanism,
+	 * taking an extra reference results in simpler implementation.
+	 */
+	vchiq_service_get(service);
+	rcu_read_unlock();
 
 	vchiq_log_trace(vchiq_arm_log_level,
 		"%s - service %lx(%d,%p), reason %d, header %lx, instance %lx, bulk_userdata %lx",
@@ -1074,6 +1086,7 @@ service_callback(enum vchiq_reason reason, struct vchiq_header *header,
 					NULL, user_service, bulk_userdata);
 				if (status != VCHIQ_SUCCESS) {
 					DEBUG_TRACE(SERVICE_CALLBACK_LINE);
+					vchiq_service_put(service);
 					return status;
 				}
 			}
@@ -1084,11 +1097,13 @@ service_callback(enum vchiq_reason reason, struct vchiq_header *header,
 				vchiq_log_info(vchiq_arm_log_level,
 					"%s interrupted", __func__);
 				DEBUG_TRACE(SERVICE_CALLBACK_LINE);
+				vchiq_service_put(service);
 				return VCHIQ_RETRY;
 			} else if (instance->closing) {
 				vchiq_log_info(vchiq_arm_log_level,
 					"%s closing", __func__);
 				DEBUG_TRACE(SERVICE_CALLBACK_LINE);
+				vchiq_service_put(service);
 				return VCHIQ_ERROR;
 			}
 			DEBUG_TRACE(SERVICE_CALLBACK_LINE);
@@ -1117,6 +1132,7 @@ service_callback(enum vchiq_reason reason, struct vchiq_header *header,
 		header = NULL;
 	}
 	DEBUG_TRACE(SERVICE_CALLBACK_LINE);
+	vchiq_service_put(service);
 
 	if (skip_completion)
 		return VCHIQ_SUCCESS;
diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 451e02cd0637..de5b45de5040 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1963,7 +1963,7 @@ static bool canon_copy_from_read_buf(struct tty_struct *tty,
 		return false;
 
 	canon_head = smp_load_acquire(&ldata->canon_head);
-	n = min(*nr + 1, canon_head - ldata->read_tail);
+	n = min(*nr, canon_head - ldata->read_tail);
 
 	tail = ldata->read_tail & (N_TTY_BUF_SIZE - 1);
 	size = min_t(size_t, tail + n, N_TTY_BUF_SIZE);
@@ -1985,10 +1985,8 @@ static bool canon_copy_from_read_buf(struct tty_struct *tty,
 		n += N_TTY_BUF_SIZE;
 	c = n + found;
 
-	if (!found || read_buf(ldata, eol) != __DISABLED_CHAR) {
-		c = min(*nr, c);
+	if (!found || read_buf(ldata, eol) != __DISABLED_CHAR)
 		n = c;
-	}
 
 	n_tty_trace("%s: eol:%zu found:%d n:%zu c:%zu tail:%zu more:%zu\n",
 		    __func__, eol, found, n, c, tail, more);
diff --git a/drivers/tty/serial/8250/8250_gsc.c b/drivers/tty/serial/8250/8250_gsc.c
index 673cda3d011d..948d0a1c6ae8 100644
--- a/drivers/tty/serial/8250/8250_gsc.c
+++ b/drivers/tty/serial/8250/8250_gsc.c
@@ -26,7 +26,7 @@ static int __init serial_init_chip(struct parisc_device *dev)
 	unsigned long address;
 	int err;
 
-#ifdef CONFIG_64BIT
+#if defined(CONFIG_64BIT) && defined(CONFIG_IOSAPIC)
 	if (!dev->irq && (dev->id.sversion == 0xad))
 		dev->irq = iosapic_serial_irq(dev);
 #endif
diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index d029be40ea6f..bdbc310a8f8c 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -325,7 +325,7 @@ static int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 	set_blocksize(device->bdev, BTRFS_BDEV_BLOCKSIZE);
 	device->fs_devices = fs_info->fs_devices;
 
-	ret = btrfs_get_dev_zone_info(device);
+	ret = btrfs_get_dev_zone_info(device, false);
 	if (ret)
 		goto error;
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index e1a262120e02..2c3e106a0270 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3565,6 +3565,8 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 		goto fail_sysfs;
 	}
 
+	btrfs_free_zone_cache(fs_info);
+
 	if (!sb_rdonly(sb) && fs_info->fs_devices->missing_devices &&
 	    !btrfs_check_rw_degradable(fs_info, NULL)) {
 		btrfs_warn(fs_info,
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 72f9b865e847..5612e8bf2ace 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -4978,6 +4978,10 @@ static int put_file_data(struct send_ctx *sctx, u64 offset, u32 len)
 			lock_page(page);
 			if (!PageUptodate(page)) {
 				unlock_page(page);
+				btrfs_err(fs_info,
+			"send: IO error at offset %llu for inode %llu root %llu",
+					page_offset(page), sctx->cur_ino,
+					sctx->send_root->root_key.objectid);
 				put_page(page);
 				ret = -EIO;
 				break;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index c34efdc1ecdd..06a1a7c2254c 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2596,7 +2596,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	device->fs_info = fs_info;
 	device->bdev = bdev;
 
-	ret = btrfs_get_dev_zone_info(device);
+	ret = btrfs_get_dev_zone_info(device, false);
 	if (ret)
 		goto error_free_device;
 
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 5672c24a2d58..596b2148807d 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -4,6 +4,7 @@
 #include <linux/slab.h>
 #include <linux/blkdev.h>
 #include <linux/sched/mm.h>
+#include <linux/vmalloc.h>
 #include "ctree.h"
 #include "volumes.h"
 #include "zoned.h"
@@ -195,6 +196,8 @@ static int emulate_report_zones(struct btrfs_device *device, u64 pos,
 static int btrfs_get_dev_zones(struct btrfs_device *device, u64 pos,
 			       struct blk_zone *zones, unsigned int *nr_zones)
 {
+	struct btrfs_zoned_device_info *zinfo = device->zone_info;
+	u32 zno;
 	int ret;
 
 	if (!*nr_zones)
@@ -206,6 +209,34 @@ static int btrfs_get_dev_zones(struct btrfs_device *device, u64 pos,
 		return 0;
 	}
 
+	/* Check cache */
+	if (zinfo->zone_cache) {
+		unsigned int i;
+
+		ASSERT(IS_ALIGNED(pos, zinfo->zone_size));
+		zno = pos >> zinfo->zone_size_shift;
+		/*
+		 * We cannot report zones beyond the zone end. So, it is OK to
+		 * cap *nr_zones to at the end.
+		 */
+		*nr_zones = min_t(u32, *nr_zones, zinfo->nr_zones - zno);
+
+		for (i = 0; i < *nr_zones; i++) {
+			struct blk_zone *zone_info;
+
+			zone_info = &zinfo->zone_cache[zno + i];
+			if (!zone_info->len)
+				break;
+		}
+
+		if (i == *nr_zones) {
+			/* Cache hit on all the zones */
+			memcpy(zones, zinfo->zone_cache + zno,
+			       sizeof(*zinfo->zone_cache) * *nr_zones);
+			return 0;
+		}
+	}
+
 	ret = blkdev_report_zones(device->bdev, pos >> SECTOR_SHIFT, *nr_zones,
 				  copy_zone_info_cb, zones);
 	if (ret < 0) {
@@ -219,6 +250,11 @@ static int btrfs_get_dev_zones(struct btrfs_device *device, u64 pos,
 	if (!ret)
 		return -EIO;
 
+	/* Populate cache */
+	if (zinfo->zone_cache)
+		memcpy(zinfo->zone_cache + zno, zones,
+		       sizeof(*zinfo->zone_cache) * *nr_zones);
+
 	return 0;
 }
 
@@ -282,7 +318,7 @@ int btrfs_get_dev_zone_info_all_devices(struct btrfs_fs_info *fs_info)
 		if (!device->bdev)
 			continue;
 
-		ret = btrfs_get_dev_zone_info(device);
+		ret = btrfs_get_dev_zone_info(device, true);
 		if (ret)
 			break;
 	}
@@ -291,7 +327,7 @@ int btrfs_get_dev_zone_info_all_devices(struct btrfs_fs_info *fs_info)
 	return ret;
 }
 
-int btrfs_get_dev_zone_info(struct btrfs_device *device)
+int btrfs_get_dev_zone_info(struct btrfs_device *device, bool populate_cache)
 {
 	struct btrfs_fs_info *fs_info = device->fs_info;
 	struct btrfs_zoned_device_info *zone_info = NULL;
@@ -318,6 +354,8 @@ int btrfs_get_dev_zone_info(struct btrfs_device *device)
 	if (!zone_info)
 		return -ENOMEM;
 
+	device->zone_info = zone_info;
+
 	if (!bdev_is_zoned(bdev)) {
 		if (!fs_info->zone_size) {
 			ret = calculate_emulated_zone_size(fs_info);
@@ -369,6 +407,23 @@ int btrfs_get_dev_zone_info(struct btrfs_device *device)
 		goto out;
 	}
 
+	/*
+	 * Enable zone cache only for a zoned device. On a non-zoned device, we
+	 * fill the zone info with emulated CONVENTIONAL zones, so no need to
+	 * use the cache.
+	 */
+	if (populate_cache && bdev_is_zoned(device->bdev)) {
+		zone_info->zone_cache = vzalloc(sizeof(struct blk_zone) *
+						zone_info->nr_zones);
+		if (!zone_info->zone_cache) {
+			btrfs_err_in_rcu(device->fs_info,
+				"zoned: failed to allocate zone cache for %s",
+				rcu_str_deref(device->name));
+			ret = -ENOMEM;
+			goto out;
+		}
+	}
+
 	/* Get zones type */
 	while (sector < nr_sectors) {
 		nr_zones = BTRFS_REPORT_NR_ZONES;
@@ -444,8 +499,6 @@ int btrfs_get_dev_zone_info(struct btrfs_device *device)
 
 	kfree(zones);
 
-	device->zone_info = zone_info;
-
 	switch (bdev_zoned_model(bdev)) {
 	case BLK_ZONED_HM:
 		model = "host-managed zoned";
@@ -478,10 +531,7 @@ int btrfs_get_dev_zone_info(struct btrfs_device *device)
 out:
 	kfree(zones);
 out_free_zone_info:
-	bitmap_free(zone_info->empty_zones);
-	bitmap_free(zone_info->seq_zones);
-	kfree(zone_info);
-	device->zone_info = NULL;
+	btrfs_destroy_dev_zone_info(device);
 
 	return ret;
 }
@@ -495,6 +545,7 @@ void btrfs_destroy_dev_zone_info(struct btrfs_device *device)
 
 	bitmap_free(zone_info->seq_zones);
 	bitmap_free(zone_info->empty_zones);
+	vfree(zone_info->zone_cache);
 	kfree(zone_info);
 	device->zone_info = NULL;
 }
@@ -1551,3 +1602,21 @@ void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg)
 		fs_info->data_reloc_bg = 0;
 	spin_unlock(&fs_info->relocation_bg_lock);
 }
+
+void btrfs_free_zone_cache(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
+	struct btrfs_device *device;
+
+	if (!btrfs_is_zoned(fs_info))
+		return;
+
+	mutex_lock(&fs_devices->device_list_mutex);
+	list_for_each_entry(device, &fs_devices->devices, dev_list) {
+		if (device->zone_info) {
+			vfree(device->zone_info->zone_cache);
+			device->zone_info->zone_cache = NULL;
+		}
+	}
+	mutex_unlock(&fs_devices->device_list_mutex);
+}
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index 70b3be517599..813aa3cddc11 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -25,6 +25,7 @@ struct btrfs_zoned_device_info {
 	u32 nr_zones;
 	unsigned long *seq_zones;
 	unsigned long *empty_zones;
+	struct blk_zone *zone_cache;
 	struct blk_zone sb_zones[2 * BTRFS_SUPER_MIRROR_MAX];
 };
 
@@ -32,7 +33,7 @@ struct btrfs_zoned_device_info {
 int btrfs_get_dev_zone(struct btrfs_device *device, u64 pos,
 		       struct blk_zone *zone);
 int btrfs_get_dev_zone_info_all_devices(struct btrfs_fs_info *fs_info);
-int btrfs_get_dev_zone_info(struct btrfs_device *device);
+int btrfs_get_dev_zone_info(struct btrfs_device *device, bool populate_cache);
 void btrfs_destroy_dev_zone_info(struct btrfs_device *device);
 int btrfs_check_zoned_mode(struct btrfs_fs_info *fs_info);
 int btrfs_check_mountopts_zoned(struct btrfs_fs_info *info);
@@ -67,6 +68,7 @@ int btrfs_sync_zone_write_pointer(struct btrfs_device *tgt_dev, u64 logical,
 struct btrfs_device *btrfs_zoned_get_device(struct btrfs_fs_info *fs_info,
 					    u64 logical, u64 length);
 void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg);
+void btrfs_free_zone_cache(struct btrfs_fs_info *fs_info);
 #else /* CONFIG_BLK_DEV_ZONED */
 static inline int btrfs_get_dev_zone(struct btrfs_device *device, u64 pos,
 				     struct blk_zone *zone)
@@ -79,7 +81,8 @@ static inline int btrfs_get_dev_zone_info_all_devices(struct btrfs_fs_info *fs_i
 	return 0;
 }
 
-static inline int btrfs_get_dev_zone_info(struct btrfs_device *device)
+static inline int btrfs_get_dev_zone_info(struct btrfs_device *device,
+					  bool populate_cache)
 {
 	return 0;
 }
@@ -202,6 +205,7 @@ static inline struct btrfs_device *btrfs_zoned_get_device(
 
 static inline void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg) { }
 
+static inline void btrfs_free_zone_cache(struct btrfs_fs_info *fs_info) { }
 #endif
 
 static inline bool btrfs_dev_is_sequential(struct btrfs_device *device, u64 pos)
diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
index 0a2542286552..3b8ed36b3711 100644
--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -146,7 +146,7 @@ const struct fs_parameter_spec smb3_fs_parameters[] = {
 	fsparam_u32("echo_interval", Opt_echo_interval),
 	fsparam_u32("max_credits", Opt_max_credits),
 	fsparam_u32("handletimeout", Opt_handletimeout),
-	fsparam_u32("snapshot", Opt_snapshot),
+	fsparam_u64("snapshot", Opt_snapshot),
 	fsparam_u32("max_channels", Opt_max_channels),
 
 	/* Mount options which take string value */
@@ -1062,7 +1062,7 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 		ctx->echo_interval = result.uint_32;
 		break;
 	case Opt_snapshot:
-		ctx->snapshot_time = result.uint_32;
+		ctx->snapshot_time = result.uint_64;
 		break;
 	case Opt_max_credits:
 		if (result.uint_32 < 20 || result.uint_32 > 60000) {
diff --git a/fs/cifs/xattr.c b/fs/cifs/xattr.c
index 7d8b72d67c80..9d486fbbfbbd 100644
--- a/fs/cifs/xattr.c
+++ b/fs/cifs/xattr.c
@@ -175,11 +175,13 @@ static int cifs_xattr_set(const struct xattr_handler *handler,
 				switch (handler->flags) {
 				case XATTR_CIFS_NTSD_FULL:
 					aclflags = (CIFS_ACL_OWNER |
+						    CIFS_ACL_GROUP |
 						    CIFS_ACL_DACL |
 						    CIFS_ACL_SACL);
 					break;
 				case XATTR_CIFS_NTSD:
 					aclflags = (CIFS_ACL_OWNER |
+						    CIFS_ACL_GROUP |
 						    CIFS_ACL_DACL);
 					break;
 				case XATTR_CIFS_ACL:
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 993913c585fb..21fc8ce9405d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8820,10 +8820,9 @@ static void io_mem_free(void *ptr)
 
 static void *io_mem_alloc(size_t size)
 {
-	gfp_t gfp_flags = GFP_KERNEL | __GFP_ZERO | __GFP_NOWARN | __GFP_COMP |
-				__GFP_NORETRY | __GFP_ACCOUNT;
+	gfp_t gfp = GFP_KERNEL_ACCOUNT | __GFP_ZERO | __GFP_NOWARN | __GFP_COMP;
 
-	return (void *) __get_free_pages(gfp_flags, get_order(size));
+	return (void *) __get_free_pages(gfp, get_order(size));
 }
 
 static unsigned long rings_size(unsigned sq_entries, unsigned cq_entries,
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 70685cbbec8c..192d8308afc2 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -3422,9 +3422,9 @@ static int smb2_populate_readdir_entry(struct ksmbd_conn *conn, int info_level,
 		goto free_conv_name;
 	}
 
-	struct_sz = readdir_info_level_struct_sz(info_level);
-	next_entry_offset = ALIGN(struct_sz - 1 + conv_len,
-				  KSMBD_DIR_INFO_ALIGNMENT);
+	struct_sz = readdir_info_level_struct_sz(info_level) - 1 + conv_len;
+	next_entry_offset = ALIGN(struct_sz, KSMBD_DIR_INFO_ALIGNMENT);
+	d_info->last_entry_off_align = next_entry_offset - struct_sz;
 
 	if (next_entry_offset > d_info->out_buf_len) {
 		d_info->out_buf_len = 0;
@@ -3976,6 +3976,7 @@ int smb2_query_dir(struct ksmbd_work *work)
 		((struct file_directory_info *)
 		((char *)rsp->Buffer + d_info.last_entry_offset))
 		->NextEntryOffset = 0;
+		d_info.data_count -= d_info.last_entry_off_align;
 
 		rsp->StructureSize = cpu_to_le16(9);
 		rsp->OutputBufferOffset = cpu_to_le16(72);
diff --git a/fs/ksmbd/smb_common.c b/fs/ksmbd/smb_common.c
index 707490ab1f4c..f2e7e3a654b3 100644
--- a/fs/ksmbd/smb_common.c
+++ b/fs/ksmbd/smb_common.c
@@ -308,14 +308,17 @@ int ksmbd_populate_dot_dotdot_entries(struct ksmbd_work *work, int info_level,
 	for (i = 0; i < 2; i++) {
 		struct kstat kstat;
 		struct ksmbd_kstat ksmbd_kstat;
+		struct dentry *dentry;
 
 		if (!dir->dot_dotdot[i]) { /* fill dot entry info */
 			if (i == 0) {
 				d_info->name = ".";
 				d_info->name_len = 1;
+				dentry = dir->filp->f_path.dentry;
 			} else {
 				d_info->name = "..";
 				d_info->name_len = 2;
+				dentry = dir->filp->f_path.dentry->d_parent;
 			}
 
 			if (!match_pattern(d_info->name, d_info->name_len,
@@ -327,7 +330,7 @@ int ksmbd_populate_dot_dotdot_entries(struct ksmbd_work *work, int info_level,
 			ksmbd_kstat.kstat = &kstat;
 			ksmbd_vfs_fill_dentry_attrs(work,
 						    user_ns,
-						    dir->filp->f_path.dentry->d_parent,
+						    dentry,
 						    &ksmbd_kstat);
 			rc = fn(conn, info_level, d_info, &ksmbd_kstat);
 			if (rc)
diff --git a/fs/ksmbd/vfs.h b/fs/ksmbd/vfs.h
index b0d5b8feb4a3..432c94773177 100644
--- a/fs/ksmbd/vfs.h
+++ b/fs/ksmbd/vfs.h
@@ -86,6 +86,7 @@ struct ksmbd_dir_info {
 	int		last_entry_offset;
 	bool		hide_dot_file;
 	int		flags;
+	int		last_entry_off_align;
 };
 
 struct ksmbd_readdir_data {
diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index f6381c675cbe..9adc6f57a008 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1987,14 +1987,14 @@ int nfs_atomic_open(struct inode *dir, struct dentry *dentry,
 	if (!res) {
 		inode = d_inode(dentry);
 		if ((lookup_flags & LOOKUP_DIRECTORY) && inode &&
-		    !S_ISDIR(inode->i_mode))
+		    !(S_ISDIR(inode->i_mode) || S_ISLNK(inode->i_mode)))
 			res = ERR_PTR(-ENOTDIR);
 		else if (inode && S_ISREG(inode->i_mode))
 			res = ERR_PTR(-EOPENSTALE);
 	} else if (!IS_ERR(res)) {
 		inode = d_inode(res);
 		if ((lookup_flags & LOOKUP_DIRECTORY) && inode &&
-		    !S_ISDIR(inode->i_mode)) {
+		    !(S_ISDIR(inode->i_mode) || S_ISLNK(inode->i_mode))) {
 			dput(res);
 			res = ERR_PTR(-ENOTDIR);
 		} else if (inode && S_ISREG(inode->i_mode)) {
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index f9d3ad3acf11..410f87bc48cc 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -840,12 +840,9 @@ int nfs_getattr(struct user_namespace *mnt_userns, const struct path *path,
 	}
 
 	/* Flush out writes to the server in order to update c/mtime.  */
-	if ((request_mask & (STATX_CTIME|STATX_MTIME)) &&
-			S_ISREG(inode->i_mode)) {
-		err = filemap_write_and_wait(inode->i_mapping);
-		if (err)
-			goto out;
-	}
+	if ((request_mask & (STATX_CTIME | STATX_MTIME)) &&
+	    S_ISREG(inode->i_mode))
+		filemap_write_and_wait(inode->i_mapping);
 
 	/*
 	 * We may force a getattr if the user cares about atime.
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 389fa72d4ca9..53be03681f69 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1232,8 +1232,7 @@ nfs4_update_changeattr_locked(struct inode *inode,
 				NFS_INO_INVALID_ACCESS | NFS_INO_INVALID_ACL |
 				NFS_INO_INVALID_SIZE | NFS_INO_INVALID_OTHER |
 				NFS_INO_INVALID_BLOCKS | NFS_INO_INVALID_NLINK |
-				NFS_INO_INVALID_MODE | NFS_INO_INVALID_XATTR |
-				NFS_INO_REVAL_PAGECACHE;
+				NFS_INO_INVALID_MODE | NFS_INO_INVALID_XATTR;
 		nfsi->attrtimeo = NFS_MINATTRTIMEO(inode);
 	}
 	nfsi->attrtimeo_timestamp = jiffies;
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index cf25be3e0321..958fce7aee63 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -430,7 +430,8 @@ static void smaps_page_accumulate(struct mem_size_stats *mss,
 }
 
 static void smaps_account(struct mem_size_stats *mss, struct page *page,
-		bool compound, bool young, bool dirty, bool locked)
+		bool compound, bool young, bool dirty, bool locked,
+		bool migration)
 {
 	int i, nr = compound ? compound_nr(page) : 1;
 	unsigned long size = nr * PAGE_SIZE;
@@ -457,8 +458,15 @@ static void smaps_account(struct mem_size_stats *mss, struct page *page,
 	 * page_count(page) == 1 guarantees the page is mapped exactly once.
 	 * If any subpage of the compound page mapped with PTE it would elevate
 	 * page_count().
+	 *
+	 * The page_mapcount() is called to get a snapshot of the mapcount.
+	 * Without holding the page lock this snapshot can be slightly wrong as
+	 * we cannot always read the mapcount atomically.  It is not safe to
+	 * call page_mapcount() even with PTL held if the page is not mapped,
+	 * especially for migration entries.  Treat regular migration entries
+	 * as mapcount == 1.
 	 */
-	if (page_count(page) == 1) {
+	if ((page_count(page) == 1) || migration) {
 		smaps_page_accumulate(mss, page, size, size << PSS_SHIFT, dirty,
 			locked, true);
 		return;
@@ -495,6 +503,7 @@ static void smaps_pte_entry(pte_t *pte, unsigned long addr,
 	struct vm_area_struct *vma = walk->vma;
 	bool locked = !!(vma->vm_flags & VM_LOCKED);
 	struct page *page = NULL;
+	bool migration = false;
 
 	if (pte_present(*pte)) {
 		page = vm_normal_page(vma, addr, *pte);
@@ -514,8 +523,11 @@ static void smaps_pte_entry(pte_t *pte, unsigned long addr,
 			} else {
 				mss->swap_pss += (u64)PAGE_SIZE << PSS_SHIFT;
 			}
-		} else if (is_pfn_swap_entry(swpent))
+		} else if (is_pfn_swap_entry(swpent)) {
+			if (is_migration_entry(swpent))
+				migration = true;
 			page = pfn_swap_entry_to_page(swpent);
+		}
 	} else if (unlikely(IS_ENABLED(CONFIG_SHMEM) && mss->check_shmem_swap
 							&& pte_none(*pte))) {
 		page = xa_load(&vma->vm_file->f_mapping->i_pages,
@@ -528,7 +540,8 @@ static void smaps_pte_entry(pte_t *pte, unsigned long addr,
 	if (!page)
 		return;
 
-	smaps_account(mss, page, false, pte_young(*pte), pte_dirty(*pte), locked);
+	smaps_account(mss, page, false, pte_young(*pte), pte_dirty(*pte),
+		      locked, migration);
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
@@ -539,6 +552,7 @@ static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
 	struct vm_area_struct *vma = walk->vma;
 	bool locked = !!(vma->vm_flags & VM_LOCKED);
 	struct page *page = NULL;
+	bool migration = false;
 
 	if (pmd_present(*pmd)) {
 		/* FOLL_DUMP will return -EFAULT on huge zero page */
@@ -546,8 +560,10 @@ static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
 	} else if (unlikely(thp_migration_supported() && is_swap_pmd(*pmd))) {
 		swp_entry_t entry = pmd_to_swp_entry(*pmd);
 
-		if (is_migration_entry(entry))
+		if (is_migration_entry(entry)) {
+			migration = true;
 			page = pfn_swap_entry_to_page(entry);
+		}
 	}
 	if (IS_ERR_OR_NULL(page))
 		return;
@@ -559,7 +575,9 @@ static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
 		/* pass */;
 	else
 		mss->file_thp += HPAGE_PMD_SIZE;
-	smaps_account(mss, page, true, pmd_young(*pmd), pmd_dirty(*pmd), locked);
+
+	smaps_account(mss, page, true, pmd_young(*pmd), pmd_dirty(*pmd),
+		      locked, migration);
 }
 #else
 static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
@@ -1363,6 +1381,7 @@ static pagemap_entry_t pte_to_pagemap_entry(struct pagemapread *pm,
 {
 	u64 frame = 0, flags = 0;
 	struct page *page = NULL;
+	bool migration = false;
 
 	if (pte_present(pte)) {
 		if (pm->show_pfn)
@@ -1384,13 +1403,14 @@ static pagemap_entry_t pte_to_pagemap_entry(struct pagemapread *pm,
 			frame = swp_type(entry) |
 				(swp_offset(entry) << MAX_SWAPFILES_SHIFT);
 		flags |= PM_SWAP;
+		migration = is_migration_entry(entry);
 		if (is_pfn_swap_entry(entry))
 			page = pfn_swap_entry_to_page(entry);
 	}
 
 	if (page && !PageAnon(page))
 		flags |= PM_FILE;
-	if (page && page_mapcount(page) == 1)
+	if (page && !migration && page_mapcount(page) == 1)
 		flags |= PM_MMAP_EXCLUSIVE;
 	if (vma->vm_flags & VM_SOFTDIRTY)
 		flags |= PM_SOFT_DIRTY;
@@ -1406,8 +1426,9 @@ static int pagemap_pmd_range(pmd_t *pmdp, unsigned long addr, unsigned long end,
 	spinlock_t *ptl;
 	pte_t *pte, *orig_pte;
 	int err = 0;
-
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	bool migration = false;
+
 	ptl = pmd_trans_huge_lock(pmdp, vma);
 	if (ptl) {
 		u64 flags = 0, frame = 0;
@@ -1446,11 +1467,12 @@ static int pagemap_pmd_range(pmd_t *pmdp, unsigned long addr, unsigned long end,
 			if (pmd_swp_uffd_wp(pmd))
 				flags |= PM_UFFD_WP;
 			VM_BUG_ON(!is_pmd_migration_entry(pmd));
+			migration = is_migration_entry(entry);
 			page = pfn_swap_entry_to_page(entry);
 		}
 #endif
 
-		if (page && page_mapcount(page) == 1)
+		if (page && !migration && page_mapcount(page) == 1)
 			flags |= PM_MMAP_EXCLUSIVE;
 
 		for (; addr != end; addr += PAGE_SIZE) {
diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 22d904bde6ab..a74aef99bd3d 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -690,9 +690,14 @@ int dquot_quota_sync(struct super_block *sb, int type)
 	/* This is not very clever (and fast) but currently I don't know about
 	 * any other simple way of getting quota data to disk and we must get
 	 * them there for userspace to be visible... */
-	if (sb->s_op->sync_fs)
-		sb->s_op->sync_fs(sb, 1);
-	sync_blockdev(sb->s_bdev);
+	if (sb->s_op->sync_fs) {
+		ret = sb->s_op->sync_fs(sb, 1);
+		if (ret)
+			return ret;
+	}
+	ret = sync_blockdev(sb->s_bdev);
+	if (ret)
+		return ret;
 
 	/*
 	 * Now when everything is written we can discard the pagecache so
diff --git a/fs/super.c b/fs/super.c
index a1f82dfd1b39..87379bb1f7a3 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1616,11 +1616,9 @@ static void lockdep_sb_freeze_acquire(struct super_block *sb)
 		percpu_rwsem_acquire(sb->s_writers.rw_sem + level, 0, _THIS_IP_);
 }
 
-static void sb_freeze_unlock(struct super_block *sb)
+static void sb_freeze_unlock(struct super_block *sb, int level)
 {
-	int level;
-
-	for (level = SB_FREEZE_LEVELS - 1; level >= 0; level--)
+	for (level--; level >= 0; level--)
 		percpu_up_write(sb->s_writers.rw_sem + level);
 }
 
@@ -1691,7 +1689,14 @@ int freeze_super(struct super_block *sb)
 	sb_wait_write(sb, SB_FREEZE_PAGEFAULT);
 
 	/* All writers are done so after syncing there won't be dirty data */
-	sync_filesystem(sb);
+	ret = sync_filesystem(sb);
+	if (ret) {
+		sb->s_writers.frozen = SB_UNFROZEN;
+		sb_freeze_unlock(sb, SB_FREEZE_PAGEFAULT);
+		wake_up(&sb->s_writers.wait_unfrozen);
+		deactivate_locked_super(sb);
+		return ret;
+	}
 
 	/* Now wait for internal filesystem counter */
 	sb->s_writers.frozen = SB_FREEZE_FS;
@@ -1703,7 +1708,7 @@ int freeze_super(struct super_block *sb)
 			printk(KERN_ERR
 				"VFS:Filesystem freeze failed\n");
 			sb->s_writers.frozen = SB_UNFROZEN;
-			sb_freeze_unlock(sb);
+			sb_freeze_unlock(sb, SB_FREEZE_FS);
 			wake_up(&sb->s_writers.wait_unfrozen);
 			deactivate_locked_super(sb);
 			return ret;
@@ -1748,7 +1753,7 @@ static int thaw_super_locked(struct super_block *sb)
 	}
 
 	sb->s_writers.frozen = SB_UNFROZEN;
-	sb_freeze_unlock(sb);
+	sb_freeze_unlock(sb, SB_FREEZE_FS);
 out:
 	wake_up(&sb->s_writers.wait_unfrozen);
 	deactivate_locked_super(sb);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index be8e7a55d803..413c0148c0ce 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1184,7 +1184,8 @@ extern void blk_dump_rq_flags(struct request *, char *);
 
 bool __must_check blk_get_queue(struct request_queue *);
 extern void blk_put_queue(struct request_queue *);
-extern void blk_set_queue_dying(struct request_queue *);
+
+void blk_mark_disk_dead(struct gendisk *disk);
 
 #ifdef CONFIG_BLOCK
 /*
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 429dcebe2b99..0f7fd205ab7e 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -117,14 +117,6 @@ void ftrace_likely_update(struct ftrace_likely_data *f, int val,
  */
 #define __stringify_label(n) #n
 
-#define __annotate_reachable(c) ({					\
-	asm volatile(__stringify_label(c) ":\n\t"			\
-		     ".pushsection .discard.reachable\n\t"		\
-		     ".long " __stringify_label(c) "b - .\n\t"		\
-		     ".popsection\n\t" : : "i" (c));			\
-})
-#define annotate_reachable() __annotate_reachable(__COUNTER__)
-
 #define __annotate_unreachable(c) ({					\
 	asm volatile(__stringify_label(c) ":\n\t"			\
 		     ".pushsection .discard.unreachable\n\t"		\
@@ -133,24 +125,21 @@ void ftrace_likely_update(struct ftrace_likely_data *f, int val,
 })
 #define annotate_unreachable() __annotate_unreachable(__COUNTER__)
 
-#define ASM_UNREACHABLE							\
-	"999:\n\t"							\
-	".pushsection .discard.unreachable\n\t"				\
-	".long 999b - .\n\t"						\
+#define ASM_REACHABLE							\
+	"998:\n\t"							\
+	".pushsection .discard.reachable\n\t"				\
+	".long 998b - .\n\t"						\
 	".popsection\n\t"
 
 /* Annotate a C jump table to allow objtool to follow the code flow */
 #define __annotate_jump_table __section(".rodata..c_jump_table")
 
 #else
-#define annotate_reachable()
 #define annotate_unreachable()
+# define ASM_REACHABLE
 #define __annotate_jump_table
 #endif
 
-#ifndef ASM_UNREACHABLE
-# define ASM_UNREACHABLE
-#endif
 #ifndef unreachable
 # define unreachable() do {		\
 	annotate_unreachable();		\
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index fba54624191a..62ff09467776 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2149,7 +2149,7 @@ struct net_device {
 	struct netdev_queue	*_tx ____cacheline_aligned_in_smp;
 	unsigned int		num_tx_queues;
 	unsigned int		real_num_tx_queues;
-	struct Qdisc		*qdisc;
+	struct Qdisc __rcu	*qdisc;
 	unsigned int		tx_queue_len;
 	spinlock_t		tx_global_lock;
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index c1a927ddec64..76e869550646 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1675,7 +1675,6 @@ extern struct pid *cad_pid;
 #define PF_MEMALLOC		0x00000800	/* Allocating memory */
 #define PF_NPROC_EXCEEDED	0x00001000	/* set_user() noticed that RLIMIT_NPROC was exceeded */
 #define PF_USED_MATH		0x00002000	/* If unset the fpu must be initialized before use */
-#define PF_USED_ASYNC		0x00004000	/* Used async_schedule*(), used by module init */
 #define PF_NOFREEZE		0x00008000	/* This thread should not be frozen */
 #define PF_FROZEN		0x00010000	/* Frozen for system suspend */
 #define PF_KSWAPD		0x00020000	/* I am kswapd */
diff --git a/include/net/addrconf.h b/include/net/addrconf.h
index e7ce719838b5..59940e230b78 100644
--- a/include/net/addrconf.h
+++ b/include/net/addrconf.h
@@ -109,8 +109,6 @@ struct inet6_ifaddr *ipv6_get_ifaddr(struct net *net,
 int ipv6_dev_get_saddr(struct net *net, const struct net_device *dev,
 		       const struct in6_addr *daddr, unsigned int srcprefs,
 		       struct in6_addr *saddr);
-int __ipv6_get_lladdr(struct inet6_dev *idev, struct in6_addr *addr,
-		      u32 banned_flags);
 int ipv6_get_lladdr(struct net_device *dev, struct in6_addr *addr,
 		    u32 banned_flags);
 bool inet_rcv_saddr_equal(const struct sock *sk, const struct sock *sk2,
diff --git a/include/net/bond_3ad.h b/include/net/bond_3ad.h
index 38785d48baff..184105d68294 100644
--- a/include/net/bond_3ad.h
+++ b/include/net/bond_3ad.h
@@ -262,7 +262,7 @@ struct ad_system {
 struct ad_bond_info {
 	struct ad_system system;	/* 802.3ad system structure */
 	struct bond_3ad_stats stats;
-	u32 agg_select_timer;		/* Timer to select aggregator after all adapter's hand shakes */
+	atomic_t agg_select_timer;		/* Timer to select aggregator after all adapter's hand shakes */
 	u16 aggregator_identifier;
 };
 
diff --git a/include/net/dsa.h b/include/net/dsa.h
index d784e76113b8..49e5ece9361c 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -1056,6 +1056,7 @@ void dsa_unregister_switch(struct dsa_switch *ds);
 int dsa_register_switch(struct dsa_switch *ds);
 void dsa_switch_shutdown(struct dsa_switch *ds);
 struct dsa_switch *dsa_switch_find(int tree_index, int sw_index);
+void dsa_flush_workqueue(void);
 #ifdef CONFIG_PM_SLEEP
 int dsa_switch_suspend(struct dsa_switch *ds);
 int dsa_switch_resume(struct dsa_switch *ds);
diff --git a/include/net/ip6_fib.h b/include/net/ip6_fib.h
index c85b040728d7..bbb27639f293 100644
--- a/include/net/ip6_fib.h
+++ b/include/net/ip6_fib.h
@@ -189,14 +189,16 @@ struct fib6_info {
 	u32				fib6_metric;
 	u8				fib6_protocol;
 	u8				fib6_type;
+
+	u8				offload;
+	u8				trap;
+	u8				offload_failed;
+
 	u8				should_flush:1,
 					dst_nocount:1,
 					dst_nopolicy:1,
 					fib6_destroying:1,
-					offload:1,
-					trap:1,
-					offload_failed:1,
-					unused:1;
+					unused:4;
 
 	struct rcu_head			rcu;
 	struct nexthop			*nh;
diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index f2d0ecc257bb..359540dfc033 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -391,17 +391,20 @@ static inline void txopt_put(struct ipv6_txoptions *opt)
 		kfree_rcu(opt, rcu);
 }
 
+#if IS_ENABLED(CONFIG_IPV6)
 struct ip6_flowlabel *__fl6_sock_lookup(struct sock *sk, __be32 label);
 
 extern struct static_key_false_deferred ipv6_flowlabel_exclusive;
 static inline struct ip6_flowlabel *fl6_sock_lookup(struct sock *sk,
 						    __be32 label)
 {
-	if (static_branch_unlikely(&ipv6_flowlabel_exclusive.key))
+	if (static_branch_unlikely(&ipv6_flowlabel_exclusive.key) &&
+	    READ_ONCE(sock_net(sk)->ipv6.flowlabel_has_excl))
 		return __fl6_sock_lookup(sk, label) ? : ERR_PTR(-ENOENT);
 
 	return NULL;
 }
+#endif
 
 struct ipv6_txoptions *fl6_merge_options(struct ipv6_txoptions *opt_space,
 					 struct ip6_flowlabel *fl,
diff --git a/include/net/netns/ipv6.h b/include/net/netns/ipv6.h
index a4b550380316..6bd7e5a85ce7 100644
--- a/include/net/netns/ipv6.h
+++ b/include/net/netns/ipv6.h
@@ -77,9 +77,10 @@ struct netns_ipv6 {
 	spinlock_t		fib6_gc_lock;
 	unsigned int		 ip6_rt_gc_expire;
 	unsigned long		 ip6_rt_last_gc;
+	unsigned char		flowlabel_has_excl;
 #ifdef CONFIG_IPV6_MULTIPLE_TABLES
-	unsigned int		fib6_rules_require_fldissect;
 	bool			fib6_has_custom_rules;
+	unsigned int		fib6_rules_require_fldissect;
 #ifdef CONFIG_IPV6_SUBTREES
 	unsigned int		fib6_routes_require_src;
 #endif
diff --git a/kernel/async.c b/kernel/async.c
index b8d7a663497f..b2c4ba5686ee 100644
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -205,9 +205,6 @@ async_cookie_t async_schedule_node_domain(async_func_t func, void *data,
 	atomic_inc(&entry_count);
 	spin_unlock_irqrestore(&async_lock, flags);
 
-	/* mark that this task has queued an async job, used by module init */
-	current->flags |= PF_USED_ASYNC;
-
 	/* schedule for execution */
 	queue_work_node(node, system_unbound_wq, &entry->work);
 
diff --git a/kernel/cred.c b/kernel/cred.c
index 1ae0b4948a5a..933155c96922 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -665,26 +665,20 @@ EXPORT_SYMBOL(cred_fscmp);
 
 int set_cred_ucounts(struct cred *new)
 {
-	struct task_struct *task = current;
-	const struct cred *old = task->real_cred;
 	struct ucounts *new_ucounts, *old_ucounts = new->ucounts;
 
-	if (new->user == old->user && new->user_ns == old->user_ns)
-		return 0;
-
 	/*
 	 * This optimization is needed because alloc_ucounts() uses locks
 	 * for table lookups.
 	 */
-	if (old_ucounts && old_ucounts->ns == new->user_ns && uid_eq(old_ucounts->uid, new->euid))
+	if (old_ucounts->ns == new->user_ns && uid_eq(old_ucounts->uid, new->uid))
 		return 0;
 
-	if (!(new_ucounts = alloc_ucounts(new->user_ns, new->euid)))
+	if (!(new_ucounts = alloc_ucounts(new->user_ns, new->uid)))
 		return -EAGAIN;
 
 	new->ucounts = new_ucounts;
-	if (old_ucounts)
-		put_ucounts(old_ucounts);
+	put_ucounts(old_ucounts);
 
 	return 0;
 }
diff --git a/kernel/fork.c b/kernel/fork.c
index 10885c649ca4..28aee1a8875b 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2055,18 +2055,18 @@ static __latent_entropy struct task_struct *copy_process(
 #ifdef CONFIG_PROVE_LOCKING
 	DEBUG_LOCKS_WARN_ON(!p->softirqs_enabled);
 #endif
+	retval = copy_creds(p, clone_flags);
+	if (retval < 0)
+		goto bad_fork_free;
+
 	retval = -EAGAIN;
 	if (is_ucounts_overlimit(task_ucounts(p), UCOUNT_RLIMIT_NPROC, rlimit(RLIMIT_NPROC))) {
 		if (p->real_cred->user != INIT_USER &&
 		    !capable(CAP_SYS_RESOURCE) && !capable(CAP_SYS_ADMIN))
-			goto bad_fork_free;
+			goto bad_fork_cleanup_count;
 	}
 	current->flags &= ~PF_NPROC_EXCEEDED;
 
-	retval = copy_creds(p, clone_flags);
-	if (retval < 0)
-		goto bad_fork_free;
-
 	/*
 	 * If multiple threads are within copy_process(), then this check
 	 * triggers too late. This doesn't hurt, the check is only there
@@ -2353,10 +2353,6 @@ static __latent_entropy struct task_struct *copy_process(
 		goto bad_fork_cancel_cgroup;
 	}
 
-	/* past the last point of failure */
-	if (pidfile)
-		fd_install(pidfd, pidfile);
-
 	init_task_pid_links(p);
 	if (likely(p->pid)) {
 		ptrace_init_task(p, (clone_flags & CLONE_PTRACE) || trace);
@@ -2405,6 +2401,9 @@ static __latent_entropy struct task_struct *copy_process(
 	syscall_tracepoint_update(p);
 	write_unlock_irq(&tasklist_lock);
 
+	if (pidfile)
+		fd_install(pidfd, pidfile);
+
 	proc_fork_connector(p);
 	sched_post_fork(p, args);
 	cgroup_post_fork(p, args);
diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index d624231eab2b..92127296cf2b 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -3450,7 +3450,7 @@ struct lock_class *lock_chain_get_class(struct lock_chain *chain, int i)
 	u16 chain_hlock = chain_hlocks[chain->base + i];
 	unsigned int class_idx = chain_hlock_class_idx(chain_hlock);
 
-	return lock_classes + class_idx - 1;
+	return lock_classes + class_idx;
 }
 
 /*
@@ -3518,7 +3518,7 @@ static void print_chain_keys_chain(struct lock_chain *chain)
 		hlock_id = chain_hlocks[chain->base + i];
 		chain_key = print_chain_key_iteration(hlock_id, chain_key);
 
-		print_lock_name(lock_classes + chain_hlock_class_idx(hlock_id) - 1);
+		print_lock_name(lock_classes + chain_hlock_class_idx(hlock_id));
 		printk("\n");
 	}
 }
diff --git a/kernel/module.c b/kernel/module.c
index 5c26a76e800b..83991c2d5af9 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3683,12 +3683,6 @@ static noinline int do_init_module(struct module *mod)
 	}
 	freeinit->module_init = mod->init_layout.base;
 
-	/*
-	 * We want to find out whether @mod uses async during init.  Clear
-	 * PF_USED_ASYNC.  async_schedule*() will set it.
-	 */
-	current->flags &= ~PF_USED_ASYNC;
-
 	do_mod_ctors(mod);
 	/* Start the module */
 	if (mod->init != NULL)
@@ -3714,22 +3708,13 @@ static noinline int do_init_module(struct module *mod)
 
 	/*
 	 * We need to finish all async code before the module init sequence
-	 * is done.  This has potential to deadlock.  For example, a newly
-	 * detected block device can trigger request_module() of the
-	 * default iosched from async probing task.  Once userland helper
-	 * reaches here, async_synchronize_full() will wait on the async
-	 * task waiting on request_module() and deadlock.
-	 *
-	 * This deadlock is avoided by perfomring async_synchronize_full()
-	 * iff module init queued any async jobs.  This isn't a full
-	 * solution as it will deadlock the same if module loading from
-	 * async jobs nests more than once; however, due to the various
-	 * constraints, this hack seems to be the best option for now.
-	 * Please refer to the following thread for details.
+	 * is done. This has potential to deadlock if synchronous module
+	 * loading is requested from async (which is not allowed!).
 	 *
-	 * http://thread.gmane.org/gmane.linux.kernel/1420814
+	 * See commit 0fdff3ec6d87 ("async, kmod: warn on synchronous
+	 * request_module() from async workers") for more details.
 	 */
-	if (!mod->async_probe_requested && (current->flags & PF_USED_ASYNC))
+	if (!mod->async_probe_requested)
 		async_synchronize_full();
 
 	ftrace_free_mem(mod, mod->init_layout.base, mod->init_layout.base +
diff --git a/kernel/stackleak.c b/kernel/stackleak.c
index ce161a8e8d97..dd07239ddff9 100644
--- a/kernel/stackleak.c
+++ b/kernel/stackleak.c
@@ -48,7 +48,7 @@ int stack_erasing_sysctl(struct ctl_table *table, int write,
 #define skip_erasing()	false
 #endif /* CONFIG_STACKLEAK_RUNTIME_DISABLE */
 
-asmlinkage void notrace stackleak_erase(void)
+asmlinkage void noinstr stackleak_erase(void)
 {
 	/* It would be nice not to have 'kstack_ptr' and 'boundary' on stack */
 	unsigned long kstack_ptr = current->lowest_stack;
@@ -102,9 +102,8 @@ asmlinkage void notrace stackleak_erase(void)
 	/* Reset the 'lowest_stack' value for the next syscall */
 	current->lowest_stack = current_top_of_stack() - THREAD_SIZE/64;
 }
-NOKPROBE_SYMBOL(stackleak_erase);
 
-void __used __no_caller_saved_registers notrace stackleak_track_stack(void)
+void __used __no_caller_saved_registers noinstr stackleak_track_stack(void)
 {
 	unsigned long sp = current_stack_pointer;
 
diff --git a/kernel/sys.c b/kernel/sys.c
index 8fdac0d90504..3e4e8930fafc 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -472,6 +472,16 @@ static int set_user(struct cred *new)
 	if (!new_user)
 		return -EAGAIN;
 
+	free_uid(new->user);
+	new->user = new_user;
+	return 0;
+}
+
+static void flag_nproc_exceeded(struct cred *new)
+{
+	if (new->ucounts == current_ucounts())
+		return;
+
 	/*
 	 * We don't fail in case of NPROC limit excess here because too many
 	 * poorly written programs don't check set*uid() return code, assuming
@@ -480,15 +490,10 @@ static int set_user(struct cred *new)
 	 * failure to the execve() stage.
 	 */
 	if (is_ucounts_overlimit(new->ucounts, UCOUNT_RLIMIT_NPROC, rlimit(RLIMIT_NPROC)) &&
-			new_user != INIT_USER &&
-			!capable(CAP_SYS_RESOURCE) && !capable(CAP_SYS_ADMIN))
+			new->user != INIT_USER)
 		current->flags |= PF_NPROC_EXCEEDED;
 	else
 		current->flags &= ~PF_NPROC_EXCEEDED;
-
-	free_uid(new->user);
-	new->user = new_user;
-	return 0;
 }
 
 /*
@@ -563,6 +568,7 @@ long __sys_setreuid(uid_t ruid, uid_t euid)
 	if (retval < 0)
 		goto error;
 
+	flag_nproc_exceeded(new);
 	return commit_creds(new);
 
 error:
@@ -625,6 +631,7 @@ long __sys_setuid(uid_t uid)
 	if (retval < 0)
 		goto error;
 
+	flag_nproc_exceeded(new);
 	return commit_creds(new);
 
 error:
@@ -704,6 +711,7 @@ long __sys_setresuid(uid_t ruid, uid_t euid, uid_t suid)
 	if (retval < 0)
 		goto error;
 
+	flag_nproc_exceeded(new);
 	return commit_creds(new);
 
 error:
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 51a87a67e2ab..618c20ce2479 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -252,6 +252,10 @@ __setup("trace_clock=", set_trace_boot_clock);
 
 static int __init set_tracepoint_printk(char *str)
 {
+	/* Ignore the "tp_printk_stop_on_boot" param */
+	if (*str == '_')
+		return 0;
+
 	if ((strcmp(str, "=0") != 0 && strcmp(str, "=off") != 0))
 		tracepoint_printk = 1;
 	return 1;
diff --git a/kernel/ucount.c b/kernel/ucount.c
index 804f64799fc1..a1d67261501a 100644
--- a/kernel/ucount.c
+++ b/kernel/ucount.c
@@ -344,7 +344,8 @@ bool is_ucounts_overlimit(struct ucounts *ucounts, enum ucount_type type, unsign
 	if (rlimit > LONG_MAX)
 		max = LONG_MAX;
 	for (iter = ucounts; iter; iter = iter->ns->ucounts) {
-		if (get_ucounts_value(iter, type) > max)
+		long val = get_ucounts_value(iter, type);
+		if (val < 0 || val > max)
 			return true;
 		max = READ_ONCE(iter->ns->ucount_max[type]);
 	}
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 60b5e6edfbaa..c5b2f0f4b8a8 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -416,6 +416,7 @@ static size_t copy_page_to_iter_pipe(struct page *page, size_t offset, size_t by
 		return 0;
 
 	buf->ops = &page_cache_pipe_buf_ops;
+	buf->flags = 0;
 	get_page(page);
 	buf->page = page;
 	buf->offset = offset;
@@ -532,6 +533,7 @@ static size_t push_pipe(struct iov_iter *i, size_t size,
 			break;
 
 		buf->ops = &default_pipe_buf_ops;
+		buf->flags = 0;
 		buf->page = page;
 		buf->offset = 0;
 		buf->len = min_t(ssize_t, left, PAGE_SIZE);
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 883e2cc85cad..ed18dc49533f 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -94,7 +94,7 @@ static unsigned long change_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
 
 				/* Also skip shared copy-on-write pages */
 				if (is_cow_mapping(vma->vm_flags) &&
-				    page_mapcount(page) != 1)
+				    page_count(page) != 1)
 					continue;
 
 				/*
diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 7473e0cc6d46..ea3431ac46a1 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -77,6 +77,7 @@ static void ax25_kill_by_device(struct net_device *dev)
 {
 	ax25_dev *ax25_dev;
 	ax25_cb *s;
+	struct sock *sk;
 
 	if ((ax25_dev = ax25_dev_ax25dev(dev)) == NULL)
 		return;
@@ -85,13 +86,15 @@ static void ax25_kill_by_device(struct net_device *dev)
 again:
 	ax25_for_each(s, &ax25_list) {
 		if (s->ax25_dev == ax25_dev) {
+			sk = s->sk;
+			sock_hold(sk);
 			spin_unlock_bh(&ax25_list_lock);
-			lock_sock(s->sk);
+			lock_sock(sk);
 			s->ax25_dev = NULL;
-			release_sock(s->sk);
+			release_sock(sk);
 			ax25_disconnect(s, ENETUNREACH);
 			spin_lock_bh(&ax25_list_lock);
-
+			sock_put(sk);
 			/* The entry could have been deleted from the
 			 * list meanwhile and thus the next pointer is
 			 * no longer valid.  Play it safe and restart
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index de2409889489..db4f2641d1cd 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -82,6 +82,9 @@ static void br_multicast_find_del_pg(struct net_bridge *br,
 				     struct net_bridge_port_group *pg);
 static void __br_multicast_stop(struct net_bridge_mcast *brmctx);
 
+static int br_mc_disabled_update(struct net_device *dev, bool value,
+				 struct netlink_ext_ack *extack);
+
 static struct net_bridge_port_group *
 br_sg_port_find(struct net_bridge *br,
 		struct net_bridge_port_group_sg_key *sg_p)
@@ -1156,6 +1159,7 @@ struct net_bridge_mdb_entry *br_multicast_new_group(struct net_bridge *br,
 		return mp;
 
 	if (atomic_read(&br->mdb_hash_tbl.nelems) >= br->hash_max) {
+		br_mc_disabled_update(br->dev, false, NULL);
 		br_opt_toggle(br, BROPT_MULTICAST_ENABLED, false);
 		return ERR_PTR(-E2BIG);
 	}
diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 49442cae6f69..1d99b731e5b2 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -280,13 +280,17 @@ static void trace_napi_poll_hit(void *ignore, struct napi_struct *napi,
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(new_stat, &hw_stats_list, list) {
+		struct net_device *dev;
+
 		/*
 		 * only add a note to our monitor buffer if:
 		 * 1) this is the dev we received on
 		 * 2) its after the last_rx delta
 		 * 3) our rx_dropped count has gone up
 		 */
-		if ((new_stat->dev == napi->dev)  &&
+		/* Paired with WRITE_ONCE() in dropmon_net_event() */
+		dev = READ_ONCE(new_stat->dev);
+		if ((dev == napi->dev)  &&
 		    (time_after(jiffies, new_stat->last_rx + dm_hw_check_delta)) &&
 		    (napi->dev->stats.rx_dropped != new_stat->last_drop_val)) {
 			trace_drop_common(NULL, NULL);
@@ -1572,7 +1576,10 @@ static int dropmon_net_event(struct notifier_block *ev_block,
 		mutex_lock(&net_dm_mutex);
 		list_for_each_entry_safe(new_stat, tmp, &hw_stats_list, list) {
 			if (new_stat->dev == dev) {
-				new_stat->dev = NULL;
+
+				/* Paired with READ_ONCE() in trace_napi_poll_hit() */
+				WRITE_ONCE(new_stat->dev, NULL);
+
 				if (trace_state == TRACE_OFF) {
 					list_del_rcu(&new_stat->list);
 					kfree_rcu(new_stat, rcu);
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 198cc8b74dc3..91d7a5a5a08d 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1698,6 +1698,7 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
 {
 	struct ifinfomsg *ifm;
 	struct nlmsghdr *nlh;
+	struct Qdisc *qdisc;
 
 	ASSERT_RTNL();
 	nlh = nlmsg_put(skb, pid, seq, type, sizeof(*ifm), flags);
@@ -1715,6 +1716,7 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
 	if (tgt_netnsid >= 0 && nla_put_s32(skb, IFLA_TARGET_NETNSID, tgt_netnsid))
 		goto nla_put_failure;
 
+	qdisc = rtnl_dereference(dev->qdisc);
 	if (nla_put_string(skb, IFLA_IFNAME, dev->name) ||
 	    nla_put_u32(skb, IFLA_TXQLEN, dev->tx_queue_len) ||
 	    nla_put_u8(skb, IFLA_OPERSTATE,
@@ -1733,8 +1735,8 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
 #endif
 	    put_master_ifindex(skb, dev) ||
 	    nla_put_u8(skb, IFLA_CARRIER, netif_carrier_ok(dev)) ||
-	    (dev->qdisc &&
-	     nla_put_string(skb, IFLA_QDISC, dev->qdisc->ops->id)) ||
+	    (qdisc &&
+	     nla_put_string(skb, IFLA_QDISC, qdisc->ops->id)) ||
 	    nla_put_ifalias(skb, dev) ||
 	    nla_put_u32(skb, IFLA_CARRIER_CHANGES,
 			atomic_read(&dev->carrier_up_count) +
diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index 41f36ad8b0ec..4ff03fb262e0 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -349,6 +349,7 @@ void dsa_flush_workqueue(void)
 {
 	flush_workqueue(dsa_owq);
 }
+EXPORT_SYMBOL_GPL(dsa_flush_workqueue);
 
 int dsa_devlink_param_get(struct devlink *dl, u32 id,
 			  struct devlink_param_gset_ctx *ctx)
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index a5c9bc7b66c6..33ab7d7af9eb 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -170,7 +170,6 @@ void dsa_tag_driver_put(const struct dsa_device_ops *ops);
 const struct dsa_device_ops *dsa_find_tagger_by_name(const char *buf);
 
 bool dsa_schedule_work(struct work_struct *work);
-void dsa_flush_workqueue(void);
 const char *dsa_tag_protocol_to_str(const struct dsa_device_ops *ops);
 
 static inline int dsa_tag_protocol_overhead(const struct dsa_device_ops *ops)
diff --git a/net/dsa/tag_lan9303.c b/net/dsa/tag_lan9303.c
index cb548188f813..98d7d7120bab 100644
--- a/net/dsa/tag_lan9303.c
+++ b/net/dsa/tag_lan9303.c
@@ -77,7 +77,6 @@ static struct sk_buff *lan9303_xmit(struct sk_buff *skb, struct net_device *dev)
 
 static struct sk_buff *lan9303_rcv(struct sk_buff *skb, struct net_device *dev)
 {
-	__be16 *lan9303_tag;
 	u16 lan9303_tag1;
 	unsigned int source_port;
 
@@ -87,14 +86,15 @@ static struct sk_buff *lan9303_rcv(struct sk_buff *skb, struct net_device *dev)
 		return NULL;
 	}
 
-	lan9303_tag = dsa_etype_header_pos_rx(skb);
-
-	if (lan9303_tag[0] != htons(ETH_P_8021Q)) {
-		dev_warn_ratelimited(&dev->dev, "Dropping packet due to invalid VLAN marker\n");
-		return NULL;
+	if (skb_vlan_tag_present(skb)) {
+		lan9303_tag1 = skb_vlan_tag_get(skb);
+		__vlan_hwaccel_clear_tag(skb);
+	} else {
+		skb_push_rcsum(skb, ETH_HLEN);
+		__skb_vlan_pop(skb, &lan9303_tag1);
+		skb_pull_rcsum(skb, ETH_HLEN);
 	}
 
-	lan9303_tag1 = ntohs(lan9303_tag[1]);
 	source_port = lan9303_tag1 & 0x3;
 
 	skb->dev = dsa_master_find_slave(dev, 0, source_port);
@@ -103,13 +103,6 @@ static struct sk_buff *lan9303_rcv(struct sk_buff *skb, struct net_device *dev)
 		return NULL;
 	}
 
-	/* remove the special VLAN tag between the MAC addresses
-	 * and the current ethertype field.
-	 */
-	skb_pull_rcsum(skb, 2 + 2);
-
-	dsa_strip_etype_header(skb, LAN9303_TAG_LEN);
-
 	if (!(lan9303_tag1 & LAN9303_TAG_RX_TRAPPED_TO_CPU))
 		dsa_default_offload_fwd_mark(skb);
 
diff --git a/net/ipv4/fib_lookup.h b/net/ipv4/fib_lookup.h
index e184bcb19943..78e40ea42e58 100644
--- a/net/ipv4/fib_lookup.h
+++ b/net/ipv4/fib_lookup.h
@@ -16,10 +16,9 @@ struct fib_alias {
 	u8			fa_slen;
 	u32			tb_id;
 	s16			fa_default;
-	u8			offload:1,
-				trap:1,
-				offload_failed:1,
-				unused:5;
+	u8			offload;
+	u8			trap;
+	u8			offload_failed;
 	struct rcu_head		rcu;
 };
 
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 5dfb94abe7b1..d244c57b7303 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -524,9 +524,9 @@ void rtmsg_fib(int event, __be32 key, struct fib_alias *fa,
 	fri.dst_len = dst_len;
 	fri.tos = fa->fa_tos;
 	fri.type = fa->fa_type;
-	fri.offload = fa->offload;
-	fri.trap = fa->trap;
-	fri.offload_failed = fa->offload_failed;
+	fri.offload = READ_ONCE(fa->offload);
+	fri.trap = READ_ONCE(fa->trap);
+	fri.offload_failed = READ_ONCE(fa->offload_failed);
 	err = fib_dump_info(skb, info->portid, seq, event, &fri, nlm_flags);
 	if (err < 0) {
 		/* -EMSGSIZE implies BUG in fib_nlmsg_size() */
diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 8060524f4256..f7f74d5c14da 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -1047,19 +1047,23 @@ void fib_alias_hw_flags_set(struct net *net, const struct fib_rt_info *fri)
 	if (!fa_match)
 		goto out;
 
-	if (fa_match->offload == fri->offload && fa_match->trap == fri->trap &&
-	    fa_match->offload_failed == fri->offload_failed)
+	/* These are paired with the WRITE_ONCE() happening in this function.
+	 * The reason is that we are only protected by RCU at this point.
+	 */
+	if (READ_ONCE(fa_match->offload) == fri->offload &&
+	    READ_ONCE(fa_match->trap) == fri->trap &&
+	    READ_ONCE(fa_match->offload_failed) == fri->offload_failed)
 		goto out;
 
-	fa_match->offload = fri->offload;
-	fa_match->trap = fri->trap;
+	WRITE_ONCE(fa_match->offload, fri->offload);
+	WRITE_ONCE(fa_match->trap, fri->trap);
 
 	/* 2 means send notifications only if offload_failed was changed. */
 	if (net->ipv4.sysctl_fib_notify_on_flag_change == 2 &&
-	    fa_match->offload_failed == fri->offload_failed)
+	    READ_ONCE(fa_match->offload_failed) == fri->offload_failed)
 		goto out;
 
-	fa_match->offload_failed = fri->offload_failed;
+	WRITE_ONCE(fa_match->offload_failed, fri->offload_failed);
 
 	if (!net->ipv4.sysctl_fib_notify_on_flag_change)
 		goto out;
@@ -2297,9 +2301,9 @@ static int fn_trie_dump_leaf(struct key_vector *l, struct fib_table *tb,
 				fri.dst_len = KEYLENGTH - fa->fa_slen;
 				fri.tos = fa->fa_tos;
 				fri.type = fa->fa_type;
-				fri.offload = fa->offload;
-				fri.trap = fa->trap;
-				fri.offload_failed = fa->offload_failed;
+				fri.offload = READ_ONCE(fa->offload);
+				fri.trap = READ_ONCE(fa->trap);
+				fri.offload_failed = READ_ONCE(fa->offload_failed);
 				err = fib_dump_info(skb,
 						    NETLINK_CB(cb->skb).portid,
 						    cb->nlh->nlmsg_seq,
diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 086822cb1cc9..e3a159c8f231 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -172,16 +172,23 @@ static struct sock *ping_lookup(struct net *net, struct sk_buff *skb, u16 ident)
 	struct sock *sk = NULL;
 	struct inet_sock *isk;
 	struct hlist_nulls_node *hnode;
-	int dif = skb->dev->ifindex;
+	int dif, sdif;
 
 	if (skb->protocol == htons(ETH_P_IP)) {
+		dif = inet_iif(skb);
+		sdif = inet_sdif(skb);
 		pr_debug("try to find: num = %d, daddr = %pI4, dif = %d\n",
 			 (int)ident, &ip_hdr(skb)->daddr, dif);
 #if IS_ENABLED(CONFIG_IPV6)
 	} else if (skb->protocol == htons(ETH_P_IPV6)) {
+		dif = inet6_iif(skb);
+		sdif = inet6_sdif(skb);
 		pr_debug("try to find: num = %d, daddr = %pI6c, dif = %d\n",
 			 (int)ident, &ipv6_hdr(skb)->daddr, dif);
 #endif
+	} else {
+		pr_err("ping: protocol(%x) is not supported\n", ntohs(skb->protocol));
+		return NULL;
 	}
 
 	read_lock_bh(&ping_table.lock);
@@ -221,7 +228,7 @@ static struct sock *ping_lookup(struct net *net, struct sk_buff *skb, u16 ident)
 		}
 
 		if (sk->sk_bound_dev_if && sk->sk_bound_dev_if != dif &&
-		    sk->sk_bound_dev_if != inet_sdif(skb))
+		    sk->sk_bound_dev_if != sdif)
 			continue;
 
 		sock_hold(sk);
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index d6899ab5fb39..23833660584d 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -3401,8 +3401,8 @@ static int inet_rtm_getroute(struct sk_buff *in_skb, struct nlmsghdr *nlh,
 				    fa->fa_tos == fri.tos &&
 				    fa->fa_info == res.fi &&
 				    fa->fa_type == fri.type) {
-					fri.offload = fa->offload;
-					fri.trap = fa->trap;
+					fri.offload = READ_ONCE(fa->offload);
+					fri.trap = READ_ONCE(fa->trap);
 					break;
 				}
 			}
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index bf1386542634..c6e1989ab2ed 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1837,8 +1837,8 @@ int ipv6_dev_get_saddr(struct net *net, const struct net_device *dst_dev,
 }
 EXPORT_SYMBOL(ipv6_dev_get_saddr);
 
-int __ipv6_get_lladdr(struct inet6_dev *idev, struct in6_addr *addr,
-		      u32 banned_flags)
+static int __ipv6_get_lladdr(struct inet6_dev *idev, struct in6_addr *addr,
+			      u32 banned_flags)
 {
 	struct inet6_ifaddr *ifp;
 	int err = -EADDRNOTAVAIL;
diff --git a/net/ipv6/ip6_flowlabel.c b/net/ipv6/ip6_flowlabel.c
index aa673a6a7e43..ceb85c67ce39 100644
--- a/net/ipv6/ip6_flowlabel.c
+++ b/net/ipv6/ip6_flowlabel.c
@@ -450,8 +450,10 @@ fl_create(struct net *net, struct sock *sk, struct in6_flowlabel_req *freq,
 		err = -EINVAL;
 		goto done;
 	}
-	if (fl_shared_exclusive(fl) || fl->opt)
+	if (fl_shared_exclusive(fl) || fl->opt) {
+		WRITE_ONCE(sock_net(sk)->ipv6.flowlabel_has_excl, 1);
 		static_branch_deferred_inc(&ipv6_flowlabel_exclusive);
+	}
 	return fl;
 
 done:
diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index bed8155508c8..a8861db52c18 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -1759,7 +1759,7 @@ static struct sk_buff *mld_newpack(struct inet6_dev *idev, unsigned int mtu)
 	skb_reserve(skb, hlen);
 	skb_tailroom_reserve(skb, mtu, tlen);
 
-	if (__ipv6_get_lladdr(idev, &addr_buf, IFA_F_TENTATIVE)) {
+	if (ipv6_get_lladdr(dev, &addr_buf, IFA_F_TENTATIVE)) {
 		/* <draft-ietf-magma-mld-source-05.txt>:
 		 * use unspecified address as the source address
 		 * when a valid link-local address is not available.
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 3c5bb4969220..e0766bdf20e7 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5767,11 +5767,11 @@ static int rt6_fill_node(struct net *net, struct sk_buff *skb,
 	}
 
 	if (!dst) {
-		if (rt->offload)
+		if (READ_ONCE(rt->offload))
 			rtm->rtm_flags |= RTM_F_OFFLOAD;
-		if (rt->trap)
+		if (READ_ONCE(rt->trap))
 			rtm->rtm_flags |= RTM_F_TRAP;
-		if (rt->offload_failed)
+		if (READ_ONCE(rt->offload_failed))
 			rtm->rtm_flags |= RTM_F_OFFLOAD_FAILED;
 	}
 
@@ -6229,19 +6229,20 @@ void fib6_info_hw_flags_set(struct net *net, struct fib6_info *f6i,
 	struct sk_buff *skb;
 	int err;
 
-	if (f6i->offload == offload && f6i->trap == trap &&
-	    f6i->offload_failed == offload_failed)
+	if (READ_ONCE(f6i->offload) == offload &&
+	    READ_ONCE(f6i->trap) == trap &&
+	    READ_ONCE(f6i->offload_failed) == offload_failed)
 		return;
 
-	f6i->offload = offload;
-	f6i->trap = trap;
+	WRITE_ONCE(f6i->offload, offload);
+	WRITE_ONCE(f6i->trap, trap);
 
 	/* 2 means send notifications only if offload_failed was changed. */
 	if (net->ipv6.sysctl.fib_notify_on_flag_change == 2 &&
-	    f6i->offload_failed == offload_failed)
+	    READ_ONCE(f6i->offload_failed) == offload_failed)
 		return;
 
-	f6i->offload_failed = offload_failed;
+	WRITE_ONCE(f6i->offload_failed, offload_failed);
 
 	if (!rcu_access_pointer(f6i->fib6_node))
 		/* The route was removed from the tree, do not send
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 89c648b035b9..215948fb0d35 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -664,7 +664,7 @@ static void ieee80211_add_he_ie(struct ieee80211_sub_if_data *sdata,
 	ieee80211_ie_build_he_6ghz_cap(sdata, skb);
 }
 
-static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
+static int ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
@@ -684,6 +684,7 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 	enum nl80211_iftype iftype = ieee80211_vif_type_p2p(&sdata->vif);
 	const struct ieee80211_sband_iftype_data *iftd;
 	struct ieee80211_prep_tx_info info = {};
+	int ret;
 
 	/* we know it's writable, cast away the const */
 	if (assoc_data->ie_len)
@@ -697,7 +698,7 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
 	if (WARN_ON(!chanctx_conf)) {
 		rcu_read_unlock();
-		return;
+		return -EINVAL;
 	}
 	chan = chanctx_conf->def.chan;
 	rcu_read_unlock();
@@ -748,7 +749,7 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 			(iftd ? iftd->vendor_elems.len : 0),
 			GFP_KERNEL);
 	if (!skb)
-		return;
+		return -ENOMEM;
 
 	skb_reserve(skb, local->hw.extra_tx_headroom);
 
@@ -1029,15 +1030,22 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 		skb_put_data(skb, assoc_data->ie + offset, noffset - offset);
 	}
 
-	if (assoc_data->fils_kek_len &&
-	    fils_encrypt_assoc_req(skb, assoc_data) < 0) {
-		dev_kfree_skb(skb);
-		return;
+	if (assoc_data->fils_kek_len) {
+		ret = fils_encrypt_assoc_req(skb, assoc_data);
+		if (ret < 0) {
+			dev_kfree_skb(skb);
+			return ret;
+		}
 	}
 
 	pos = skb_tail_pointer(skb);
 	kfree(ifmgd->assoc_req_ies);
 	ifmgd->assoc_req_ies = kmemdup(ie_start, pos - ie_start, GFP_ATOMIC);
+	if (!ifmgd->assoc_req_ies) {
+		dev_kfree_skb(skb);
+		return -ENOMEM;
+	}
+
 	ifmgd->assoc_req_ies_len = pos - ie_start;
 
 	drv_mgd_prepare_tx(local, sdata, &info);
@@ -1047,6 +1055,8 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 		IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_CTL_REQ_TX_STATUS |
 						IEEE80211_TX_INTFL_MLME_CONN_TX;
 	ieee80211_tx_skb(sdata, skb);
+
+	return 0;
 }
 
 void ieee80211_send_pspoll(struct ieee80211_local *local,
@@ -4451,6 +4461,7 @@ static int ieee80211_do_assoc(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_mgd_assoc_data *assoc_data = sdata->u.mgd.assoc_data;
 	struct ieee80211_local *local = sdata->local;
+	int ret;
 
 	sdata_assert_lock(sdata);
 
@@ -4471,7 +4482,9 @@ static int ieee80211_do_assoc(struct ieee80211_sub_if_data *sdata)
 	sdata_info(sdata, "associate with %pM (try %d/%d)\n",
 		   assoc_data->bss->bssid, assoc_data->tries,
 		   IEEE80211_ASSOC_MAX_TRIES);
-	ieee80211_send_assoc(sdata);
+	ret = ieee80211_send_assoc(sdata);
+	if (ret)
+		return ret;
 
 	if (!ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS)) {
 		assoc_data->timeout = jiffies + IEEE80211_ASSOC_TIMEOUT;
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 2394238d01c9..5a936334b517 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -489,6 +489,15 @@ int nf_conntrack_sctp_packet(struct nf_conn *ct,
 			pr_debug("Setting vtag %x for dir %d\n",
 				 ih->init_tag, !dir);
 			ct->proto.sctp.vtag[!dir] = ih->init_tag;
+
+			/* don't renew timeout on init retransmit so
+			 * port reuse by client or NAT middlebox cannot
+			 * keep entry alive indefinitely (incl. nat info).
+			 */
+			if (new_state == SCTP_CONNTRACK_CLOSED &&
+			    old_state == SCTP_CONNTRACK_CLOSED &&
+			    nf_ct_is_confirmed(ct))
+				ignore = true;
 		}
 
 		ct->proto.sctp.state = new_state;
diff --git a/net/netfilter/nft_synproxy.c b/net/netfilter/nft_synproxy.c
index a0109fa1e92d..1133e06f3c40 100644
--- a/net/netfilter/nft_synproxy.c
+++ b/net/netfilter/nft_synproxy.c
@@ -191,8 +191,10 @@ static int nft_synproxy_do_init(const struct nft_ctx *ctx,
 		if (err)
 			goto nf_ct_failure;
 		err = nf_synproxy_ipv6_init(snet, ctx->net);
-		if (err)
+		if (err) {
+			nf_synproxy_ipv4_fini(snet, ctx->net);
 			goto nf_ct_failure;
+		}
 		break;
 	}
 
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 7dd3a2dc5fa4..7d53272727bf 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -728,15 +728,24 @@ int tcf_action_exec(struct sk_buff *skb, struct tc_action **actions,
 restart_act_graph:
 	for (i = 0; i < nr_actions; i++) {
 		const struct tc_action *a = actions[i];
+		int repeat_ttl;
 
 		if (jmp_prgcnt > 0) {
 			jmp_prgcnt -= 1;
 			continue;
 		}
+
+		repeat_ttl = 32;
 repeat:
 		ret = a->ops->act(skb, a, res);
-		if (ret == TC_ACT_REPEAT)
-			goto repeat;	/* we need a ttl - JHS */
+
+		if (unlikely(ret == TC_ACT_REPEAT)) {
+			if (--repeat_ttl != 0)
+				goto repeat;
+			/* suspicious opcode, stop pipeline */
+			net_warn_ratelimited("TC_ACT_REPEAT abuse ?\n");
+			return TC_ACT_OK;
+		}
 
 		if (TC_ACT_EXT_CMP(ret, TC_ACT_JUMP)) {
 			jmp_prgcnt = ret & TCA_ACT_MAX_PRIO_MASK;
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 56dba8519d7c..cd44cac7fbcf 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -1044,7 +1044,7 @@ static int __tcf_qdisc_find(struct net *net, struct Qdisc **q,
 
 	/* Find qdisc */
 	if (!*parent) {
-		*q = dev->qdisc;
+		*q = rcu_dereference(dev->qdisc);
 		*parent = (*q)->handle;
 	} else {
 		*q = qdisc_lookup_rcu(dev, TC_H_MAJ(*parent));
@@ -2587,7 +2587,7 @@ static int tc_dump_tfilter(struct sk_buff *skb, struct netlink_callback *cb)
 
 		parent = tcm->tcm_parent;
 		if (!parent)
-			q = dev->qdisc;
+			q = rtnl_dereference(dev->qdisc);
 		else
 			q = qdisc_lookup(dev, TC_H_MAJ(tcm->tcm_parent));
 		if (!q)
@@ -2962,7 +2962,7 @@ static int tc_dump_chain(struct sk_buff *skb, struct netlink_callback *cb)
 			return skb->len;
 
 		if (!tcm->tcm_parent)
-			q = dev->qdisc;
+			q = rtnl_dereference(dev->qdisc);
 		else
 			q = qdisc_lookup(dev, TC_H_MAJ(tcm->tcm_parent));
 
diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 8e629c356e69..0fb387c9d706 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -301,7 +301,7 @@ struct Qdisc *qdisc_lookup(struct net_device *dev, u32 handle)
 
 	if (!handle)
 		return NULL;
-	q = qdisc_match_from_root(dev->qdisc, handle);
+	q = qdisc_match_from_root(rtnl_dereference(dev->qdisc), handle);
 	if (q)
 		goto out;
 
@@ -320,7 +320,7 @@ struct Qdisc *qdisc_lookup_rcu(struct net_device *dev, u32 handle)
 
 	if (!handle)
 		return NULL;
-	q = qdisc_match_from_root(dev->qdisc, handle);
+	q = qdisc_match_from_root(rcu_dereference(dev->qdisc), handle);
 	if (q)
 		goto out;
 
@@ -1082,10 +1082,10 @@ static int qdisc_graft(struct net_device *dev, struct Qdisc *parent,
 skip:
 		if (!ingress) {
 			notify_and_destroy(net, skb, n, classid,
-					   dev->qdisc, new);
+					   rtnl_dereference(dev->qdisc), new);
 			if (new && !new->ops->attach)
 				qdisc_refcount_inc(new);
-			dev->qdisc = new ? : &noop_qdisc;
+			rcu_assign_pointer(dev->qdisc, new ? : &noop_qdisc);
 
 			if (new && new->ops->attach)
 				new->ops->attach(new);
@@ -1460,7 +1460,7 @@ static int tc_get_qdisc(struct sk_buff *skb, struct nlmsghdr *n,
 				q = dev_ingress_queue(dev)->qdisc_sleeping;
 			}
 		} else {
-			q = dev->qdisc;
+			q = rtnl_dereference(dev->qdisc);
 		}
 		if (!q) {
 			NL_SET_ERR_MSG(extack, "Cannot find specified qdisc on specified device");
@@ -1549,7 +1549,7 @@ static int tc_modify_qdisc(struct sk_buff *skb, struct nlmsghdr *n,
 				q = dev_ingress_queue(dev)->qdisc_sleeping;
 			}
 		} else {
-			q = dev->qdisc;
+			q = rtnl_dereference(dev->qdisc);
 		}
 
 		/* It may be default qdisc, ignore it */
@@ -1771,7 +1771,8 @@ static int tc_dump_qdisc(struct sk_buff *skb, struct netlink_callback *cb)
 			s_q_idx = 0;
 		q_idx = 0;
 
-		if (tc_dump_qdisc_root(dev->qdisc, skb, cb, &q_idx, s_q_idx,
+		if (tc_dump_qdisc_root(rtnl_dereference(dev->qdisc),
+				       skb, cb, &q_idx, s_q_idx,
 				       true, tca[TCA_DUMP_INVISIBLE]) < 0)
 			goto done;
 
@@ -2042,7 +2043,7 @@ static int tc_ctl_tclass(struct sk_buff *skb, struct nlmsghdr *n,
 		} else if (qid1) {
 			qid = qid1;
 		} else if (qid == 0)
-			qid = dev->qdisc->handle;
+			qid = rtnl_dereference(dev->qdisc)->handle;
 
 		/* Now qid is genuine qdisc handle consistent
 		 * both with parent and child.
@@ -2053,7 +2054,7 @@ static int tc_ctl_tclass(struct sk_buff *skb, struct nlmsghdr *n,
 			portid = TC_H_MAKE(qid, portid);
 	} else {
 		if (qid == 0)
-			qid = dev->qdisc->handle;
+			qid = rtnl_dereference(dev->qdisc)->handle;
 	}
 
 	/* OK. Locate qdisc */
@@ -2214,7 +2215,8 @@ static int tc_dump_tclass(struct sk_buff *skb, struct netlink_callback *cb)
 	s_t = cb->args[0];
 	t = 0;
 
-	if (tc_dump_tclass_root(dev->qdisc, skb, tcm, cb, &t, s_t, true) < 0)
+	if (tc_dump_tclass_root(rtnl_dereference(dev->qdisc),
+				skb, tcm, cb, &t, s_t, true) < 0)
 		goto done;
 
 	dev_queue = dev_ingress_queue(dev);
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 47ca76ba7ffa..30c29a9a2efd 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -1114,30 +1114,33 @@ static void attach_default_qdiscs(struct net_device *dev)
 	if (!netif_is_multiqueue(dev) ||
 	    dev->priv_flags & IFF_NO_QUEUE) {
 		netdev_for_each_tx_queue(dev, attach_one_default_qdisc, NULL);
-		dev->qdisc = txq->qdisc_sleeping;
-		qdisc_refcount_inc(dev->qdisc);
+		qdisc = txq->qdisc_sleeping;
+		rcu_assign_pointer(dev->qdisc, qdisc);
+		qdisc_refcount_inc(qdisc);
 	} else {
 		qdisc = qdisc_create_dflt(txq, &mq_qdisc_ops, TC_H_ROOT, NULL);
 		if (qdisc) {
-			dev->qdisc = qdisc;
+			rcu_assign_pointer(dev->qdisc, qdisc);
 			qdisc->ops->attach(qdisc);
 		}
 	}
+	qdisc = rtnl_dereference(dev->qdisc);
 
 	/* Detect default qdisc setup/init failed and fallback to "noqueue" */
-	if (dev->qdisc == &noop_qdisc) {
+	if (qdisc == &noop_qdisc) {
 		netdev_warn(dev, "default qdisc (%s) fail, fallback to %s\n",
 			    default_qdisc_ops->id, noqueue_qdisc_ops.id);
 		dev->priv_flags |= IFF_NO_QUEUE;
 		netdev_for_each_tx_queue(dev, attach_one_default_qdisc, NULL);
-		dev->qdisc = txq->qdisc_sleeping;
-		qdisc_refcount_inc(dev->qdisc);
+		qdisc = txq->qdisc_sleeping;
+		rcu_assign_pointer(dev->qdisc, qdisc);
+		qdisc_refcount_inc(qdisc);
 		dev->priv_flags ^= IFF_NO_QUEUE;
 	}
 
 #ifdef CONFIG_NET_SCHED
-	if (dev->qdisc != &noop_qdisc)
-		qdisc_hash_add(dev->qdisc, false);
+	if (qdisc != &noop_qdisc)
+		qdisc_hash_add(qdisc, false);
 #endif
 }
 
@@ -1167,7 +1170,7 @@ void dev_activate(struct net_device *dev)
 	 * and noqueue_qdisc for virtual interfaces
 	 */
 
-	if (dev->qdisc == &noop_qdisc)
+	if (rtnl_dereference(dev->qdisc) == &noop_qdisc)
 		attach_default_qdiscs(dev);
 
 	if (!netif_carrier_ok(dev))
@@ -1333,7 +1336,7 @@ static int qdisc_change_tx_queue_len(struct net_device *dev,
 void dev_qdisc_change_real_num_tx(struct net_device *dev,
 				  unsigned int new_real_tx)
 {
-	struct Qdisc *qdisc = dev->qdisc;
+	struct Qdisc *qdisc = rtnl_dereference(dev->qdisc);
 
 	if (qdisc->ops->change_real_num_tx)
 		qdisc->ops->change_real_num_tx(qdisc, new_real_tx);
@@ -1373,7 +1376,7 @@ static void dev_init_scheduler_queue(struct net_device *dev,
 
 void dev_init_scheduler(struct net_device *dev)
 {
-	dev->qdisc = &noop_qdisc;
+	rcu_assign_pointer(dev->qdisc, &noop_qdisc);
 	netdev_for_each_tx_queue(dev, dev_init_scheduler_queue, &noop_qdisc);
 	if (dev_ingress_queue(dev))
 		dev_init_scheduler_queue(dev, dev_ingress_queue(dev), &noop_qdisc);
@@ -1401,8 +1404,8 @@ void dev_shutdown(struct net_device *dev)
 	netdev_for_each_tx_queue(dev, shutdown_scheduler_queue, &noop_qdisc);
 	if (dev_ingress_queue(dev))
 		shutdown_scheduler_queue(dev, dev_ingress_queue(dev), &noop_qdisc);
-	qdisc_put(dev->qdisc);
-	dev->qdisc = &noop_qdisc;
+	qdisc_put(rtnl_dereference(dev->qdisc));
+	rcu_assign_pointer(dev->qdisc, &noop_qdisc);
 
 	WARN_ON(timer_pending(&dev->watchdog_timer));
 }
diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 96dee4a62385..eff22065e197 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -649,14 +649,17 @@ static void smc_fback_error_report(struct sock *clcsk)
 static int smc_switch_to_fallback(struct smc_sock *smc, int reason_code)
 {
 	struct sock *clcsk;
+	int rc = 0;
 
 	mutex_lock(&smc->clcsock_release_lock);
 	if (!smc->clcsock) {
-		mutex_unlock(&smc->clcsock_release_lock);
-		return -EBADF;
+		rc = -EBADF;
+		goto out;
 	}
 	clcsk = smc->clcsock->sk;
 
+	if (smc->use_fallback)
+		goto out;
 	smc->use_fallback = true;
 	smc->fallback_rsn = reason_code;
 	smc_stat_fallback(smc);
@@ -683,8 +686,9 @@ static int smc_switch_to_fallback(struct smc_sock *smc, int reason_code)
 		smc->clcsock->sk->sk_user_data =
 			(void *)((uintptr_t)smc | SK_USER_DATA_NOCOPY);
 	}
+out:
 	mutex_unlock(&smc->clcsock_release_lock);
-	return 0;
+	return rc;
 }
 
 /* fall back during connect */
diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index aaec3c9be8db..1295f9ab839f 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -438,6 +438,7 @@ static int rpcrdma_ep_create(struct rpcrdma_xprt *r_xprt)
 					      IB_POLL_WORKQUEUE);
 	if (IS_ERR(ep->re_attr.send_cq)) {
 		rc = PTR_ERR(ep->re_attr.send_cq);
+		ep->re_attr.send_cq = NULL;
 		goto out_destroy;
 	}
 
@@ -446,6 +447,7 @@ static int rpcrdma_ep_create(struct rpcrdma_xprt *r_xprt)
 					      IB_POLL_WORKQUEUE);
 	if (IS_ERR(ep->re_attr.recv_cq)) {
 		rc = PTR_ERR(ep->re_attr.recv_cq);
+		ep->re_attr.recv_cq = NULL;
 		goto out_destroy;
 	}
 	ep->re_receive_count = 0;
@@ -484,6 +486,7 @@ static int rpcrdma_ep_create(struct rpcrdma_xprt *r_xprt)
 	ep->re_pd = ib_alloc_pd(device, 0);
 	if (IS_ERR(ep->re_pd)) {
 		rc = PTR_ERR(ep->re_pd);
+		ep->re_pd = NULL;
 		goto out_destroy;
 	}
 
diff --git a/net/tipc/node.c b/net/tipc/node.c
index 9947b7dfe1d2..6ef95ce565bd 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -403,7 +403,7 @@ static void tipc_node_write_unlock(struct tipc_node *n)
 	u32 flags = n->action_flags;
 	struct list_head *publ_list;
 	struct tipc_uaddr ua;
-	u32 bearer_id;
+	u32 bearer_id, node;
 
 	if (likely(!flags)) {
 		write_unlock_bh(&n->lock);
@@ -413,7 +413,8 @@ static void tipc_node_write_unlock(struct tipc_node *n)
 	tipc_uaddr(&ua, TIPC_SERVICE_RANGE, TIPC_NODE_SCOPE,
 		   TIPC_LINK_STATE, n->addr, n->addr);
 	sk.ref = n->link_id;
-	sk.node = n->addr;
+	sk.node = tipc_own_addr(net);
+	node = n->addr;
 	bearer_id = n->link_id & 0xffff;
 	publ_list = &n->publ_list;
 
@@ -423,17 +424,17 @@ static void tipc_node_write_unlock(struct tipc_node *n)
 	write_unlock_bh(&n->lock);
 
 	if (flags & TIPC_NOTIFY_NODE_DOWN)
-		tipc_publ_notify(net, publ_list, sk.node, n->capabilities);
+		tipc_publ_notify(net, publ_list, node, n->capabilities);
 
 	if (flags & TIPC_NOTIFY_NODE_UP)
-		tipc_named_node_up(net, sk.node, n->capabilities);
+		tipc_named_node_up(net, node, n->capabilities);
 
 	if (flags & TIPC_NOTIFY_LINK_UP) {
-		tipc_mon_peer_up(net, sk.node, bearer_id);
+		tipc_mon_peer_up(net, node, bearer_id);
 		tipc_nametbl_publish(net, &ua, &sk, sk.ref);
 	}
 	if (flags & TIPC_NOTIFY_LINK_DOWN) {
-		tipc_mon_peer_down(net, sk.node, bearer_id);
+		tipc_mon_peer_down(net, node, bearer_id);
 		tipc_nametbl_withdraw(net, &ua, &sk, sk.ref);
 	}
 }
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index fa8c1b623fa2..91a5c65707ba 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1400,6 +1400,7 @@ static int vsock_connect(struct socket *sock, struct sockaddr *addr,
 			sk->sk_state = sk->sk_state == TCP_ESTABLISHED ? TCP_CLOSING : TCP_CLOSE;
 			sock->state = SS_UNCONNECTED;
 			vsock_transport_cancel_pkt(vsk);
+			vsock_remove_connected(vsk);
 			goto out_wait;
 		} else if (timeout == 0) {
 			err = -ETIMEDOUT;
diff --git a/net/wireless/core.c b/net/wireless/core.c
index eb297e1015e0..441136646f89 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -5,7 +5,7 @@
  * Copyright 2006-2010		Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
  * Copyright 2015-2017	Intel Deutschland GmbH
- * Copyright (C) 2018-2021 Intel Corporation
+ * Copyright (C) 2018-2022 Intel Corporation
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
@@ -332,29 +332,20 @@ static void cfg80211_event_work(struct work_struct *work)
 void cfg80211_destroy_ifaces(struct cfg80211_registered_device *rdev)
 {
 	struct wireless_dev *wdev, *tmp;
-	bool found = false;
 
 	ASSERT_RTNL();
 
-	list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list) {
+	list_for_each_entry_safe(wdev, tmp, &rdev->wiphy.wdev_list, list) {
 		if (wdev->nl_owner_dead) {
 			if (wdev->netdev)
 				dev_close(wdev->netdev);
-			found = true;
-		}
-	}
-
-	if (!found)
-		return;
 
-	wiphy_lock(&rdev->wiphy);
-	list_for_each_entry_safe(wdev, tmp, &rdev->wiphy.wdev_list, list) {
-		if (wdev->nl_owner_dead) {
+			wiphy_lock(&rdev->wiphy);
 			cfg80211_leave(rdev, wdev);
 			rdev_del_virtual_intf(rdev, wdev);
+			wiphy_unlock(&rdev->wiphy);
 		}
 	}
-	wiphy_unlock(&rdev->wiphy);
 }
 
 static void cfg80211_destroy_iface_wk(struct work_struct *work)
diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index cf72680cd769..4a828bca071e 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -983,14 +983,19 @@ static int conf_write_dep(const char *name)
 
 static int conf_touch_deps(void)
 {
-	const char *name;
+	const char *name, *tmp;
 	struct symbol *sym;
 	int res, i;
 
-	strcpy(depfile_path, "include/config/");
-	depfile_prefix_len = strlen(depfile_path);
-
 	name = conf_get_autoconfig_name();
+	tmp = strrchr(name, '/');
+	depfile_prefix_len = tmp ? tmp - name + 1 : 0;
+	if (depfile_prefix_len + 1 > sizeof(depfile_path))
+		return -1;
+
+	strncpy(depfile_path, name, depfile_prefix_len);
+	depfile_path[depfile_prefix_len] = 0;
+
 	conf_read_simple(name, S_DEF_AUTO);
 	sym_calc_value(modules_sym);
 
diff --git a/scripts/kconfig/preprocess.c b/scripts/kconfig/preprocess.c
index 0590f86df6e4..748da578b418 100644
--- a/scripts/kconfig/preprocess.c
+++ b/scripts/kconfig/preprocess.c
@@ -141,7 +141,7 @@ static char *do_lineno(int argc, char *argv[])
 static char *do_shell(int argc, char *argv[])
 {
 	FILE *p;
-	char buf[256];
+	char buf[4096];
 	char *cmd;
 	size_t nread;
 	int i;
diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 21fec82489bd..9e36f992605a 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -1611,6 +1611,7 @@ static const struct snd_pci_quirk probe_mask_list[] = {
 	/* forced codec slots */
 	SND_PCI_QUIRK(0x1043, 0x1262, "ASUS W5Fm", 0x103),
 	SND_PCI_QUIRK(0x1046, 0x1262, "ASUS W5F", 0x103),
+	SND_PCI_QUIRK(0x1558, 0x0351, "Schenker Dock 15", 0x105),
 	/* WinFast VP200 H (Teradici) user reported broken communication */
 	SND_PCI_QUIRK(0x3a21, 0x040d, "WinFast VP200 H", 0x101),
 	{}
@@ -1794,8 +1795,6 @@ static int azx_create(struct snd_card *card, struct pci_dev *pci,
 
 	assign_position_fix(chip, check_position_fix(chip, position_fix[dev]));
 
-	check_probe_mask(chip, dev);
-
 	if (single_cmd < 0) /* allow fallback to single_cmd at errors */
 		chip->fallback_to_single_cmd = 1;
 	else /* explicitly set to single_cmd or not */
@@ -1821,6 +1820,8 @@ static int azx_create(struct snd_card *card, struct pci_dev *pci,
 		chip->bus.core.needs_damn_long_delay = 1;
 	}
 
+	check_probe_mask(chip, dev);
+
 	err = snd_device_new(card, SNDRV_DEV_LOWLEVEL, chip, &ops);
 	if (err < 0) {
 		dev_err(card->dev, "Error creating device [card]!\n");
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 18f04137f61c..83b56c1ba399 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -133,6 +133,22 @@ struct alc_spec {
  * COEF access helper functions
  */
 
+static void coef_mutex_lock(struct hda_codec *codec)
+{
+	struct alc_spec *spec = codec->spec;
+
+	snd_hda_power_up_pm(codec);
+	mutex_lock(&spec->coef_mutex);
+}
+
+static void coef_mutex_unlock(struct hda_codec *codec)
+{
+	struct alc_spec *spec = codec->spec;
+
+	mutex_unlock(&spec->coef_mutex);
+	snd_hda_power_down_pm(codec);
+}
+
 static int __alc_read_coefex_idx(struct hda_codec *codec, hda_nid_t nid,
 				 unsigned int coef_idx)
 {
@@ -146,12 +162,11 @@ static int __alc_read_coefex_idx(struct hda_codec *codec, hda_nid_t nid,
 static int alc_read_coefex_idx(struct hda_codec *codec, hda_nid_t nid,
 			       unsigned int coef_idx)
 {
-	struct alc_spec *spec = codec->spec;
 	unsigned int val;
 
-	mutex_lock(&spec->coef_mutex);
+	coef_mutex_lock(codec);
 	val = __alc_read_coefex_idx(codec, nid, coef_idx);
-	mutex_unlock(&spec->coef_mutex);
+	coef_mutex_unlock(codec);
 	return val;
 }
 
@@ -168,11 +183,9 @@ static void __alc_write_coefex_idx(struct hda_codec *codec, hda_nid_t nid,
 static void alc_write_coefex_idx(struct hda_codec *codec, hda_nid_t nid,
 				 unsigned int coef_idx, unsigned int coef_val)
 {
-	struct alc_spec *spec = codec->spec;
-
-	mutex_lock(&spec->coef_mutex);
+	coef_mutex_lock(codec);
 	__alc_write_coefex_idx(codec, nid, coef_idx, coef_val);
-	mutex_unlock(&spec->coef_mutex);
+	coef_mutex_unlock(codec);
 }
 
 #define alc_write_coef_idx(codec, coef_idx, coef_val) \
@@ -193,11 +206,9 @@ static void alc_update_coefex_idx(struct hda_codec *codec, hda_nid_t nid,
 				  unsigned int coef_idx, unsigned int mask,
 				  unsigned int bits_set)
 {
-	struct alc_spec *spec = codec->spec;
-
-	mutex_lock(&spec->coef_mutex);
+	coef_mutex_lock(codec);
 	__alc_update_coefex_idx(codec, nid, coef_idx, mask, bits_set);
-	mutex_unlock(&spec->coef_mutex);
+	coef_mutex_unlock(codec);
 }
 
 #define alc_update_coef_idx(codec, coef_idx, mask, bits_set)	\
@@ -230,9 +241,7 @@ struct coef_fw {
 static void alc_process_coef_fw(struct hda_codec *codec,
 				const struct coef_fw *fw)
 {
-	struct alc_spec *spec = codec->spec;
-
-	mutex_lock(&spec->coef_mutex);
+	coef_mutex_lock(codec);
 	for (; fw->nid; fw++) {
 		if (fw->mask == (unsigned short)-1)
 			__alc_write_coefex_idx(codec, fw->nid, fw->idx, fw->val);
@@ -240,7 +249,7 @@ static void alc_process_coef_fw(struct hda_codec *codec,
 			__alc_update_coefex_idx(codec, fw->nid, fw->idx,
 						fw->mask, fw->val);
 	}
-	mutex_unlock(&spec->coef_mutex);
+	coef_mutex_unlock(codec);
 }
 
 /*
@@ -9013,6 +9022,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x3824, "Legion Y9000X 2020", ALC285_FIXUP_LEGION_Y9000X_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3827, "Ideapad S740", ALC285_FIXUP_IDEAPAD_S740_COEF),
 	SND_PCI_QUIRK(0x17aa, 0x3834, "Lenovo IdeaPad Slim 9i 14ITL5", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
+	SND_PCI_QUIRK(0x17aa, 0x383d, "Legion Y9000X 2019", ALC285_FIXUP_LEGION_Y9000X_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3843, "Yoga 9i", ALC287_FIXUP_IDEAPAD_BASS_SPK_AMP),
 	SND_PCI_QUIRK(0x17aa, 0x384a, "Lenovo Yoga 7 15ITL5", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3852, "Lenovo Yoga 7 14ITL5", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
diff --git a/sound/soc/codecs/tas2770.c b/sound/soc/codecs/tas2770.c
index 6549e7fef3e3..c5ea3b115966 100644
--- a/sound/soc/codecs/tas2770.c
+++ b/sound/soc/codecs/tas2770.c
@@ -38,10 +38,12 @@ static void tas2770_reset(struct tas2770_priv *tas2770)
 		gpiod_set_value_cansleep(tas2770->reset_gpio, 0);
 		msleep(20);
 		gpiod_set_value_cansleep(tas2770->reset_gpio, 1);
+		usleep_range(1000, 2000);
 	}
 
 	snd_soc_component_write(tas2770->component, TAS2770_SW_RST,
 		TAS2770_RST);
+	usleep_range(1000, 2000);
 }
 
 static int tas2770_set_bias_level(struct snd_soc_component *component,
@@ -110,6 +112,7 @@ static int tas2770_codec_resume(struct snd_soc_component *component)
 
 	if (tas2770->sdz_gpio) {
 		gpiod_set_value_cansleep(tas2770->sdz_gpio, 1);
+		usleep_range(1000, 2000);
 	} else {
 		ret = snd_soc_component_update_bits(component, TAS2770_PWR_CTRL,
 						    TAS2770_PWR_CTRL_MASK,
@@ -510,8 +513,10 @@ static int tas2770_codec_probe(struct snd_soc_component *component)
 
 	tas2770->component = component;
 
-	if (tas2770->sdz_gpio)
+	if (tas2770->sdz_gpio) {
 		gpiod_set_value_cansleep(tas2770->sdz_gpio, 1);
+		usleep_range(1000, 2000);
+	}
 
 	tas2770_reset(tas2770);
 
diff --git a/sound/soc/qcom/lpass-platform.c b/sound/soc/qcom/lpass-platform.c
index a59e9d20cb46..4b1773c1fb95 100644
--- a/sound/soc/qcom/lpass-platform.c
+++ b/sound/soc/qcom/lpass-platform.c
@@ -524,7 +524,7 @@ static int lpass_platform_pcmops_trigger(struct snd_soc_component *component,
 			return -EINVAL;
 		}
 
-		ret = regmap_update_bits(map, reg_irqclr, val_irqclr, val_irqclr);
+		ret = regmap_write_bits(map, reg_irqclr, val_irqclr, val_irqclr);
 		if (ret) {
 			dev_err(soc_runtime->dev, "error writing to irqclear reg: %d\n", ret);
 			return ret;
@@ -665,7 +665,7 @@ static irqreturn_t lpass_dma_interrupt_handler(
 	return -EINVAL;
 	}
 	if (interrupts & LPAIF_IRQ_PER(chan)) {
-		rv = regmap_update_bits(map, reg, mask, (LPAIF_IRQ_PER(chan) | val));
+		rv = regmap_write_bits(map, reg, mask, (LPAIF_IRQ_PER(chan) | val));
 		if (rv) {
 			dev_err(soc_runtime->dev,
 				"error writing to irqclear reg: %d\n", rv);
@@ -676,7 +676,7 @@ static irqreturn_t lpass_dma_interrupt_handler(
 	}
 
 	if (interrupts & LPAIF_IRQ_XRUN(chan)) {
-		rv = regmap_update_bits(map, reg, mask, (LPAIF_IRQ_XRUN(chan) | val));
+		rv = regmap_write_bits(map, reg, mask, (LPAIF_IRQ_XRUN(chan) | val));
 		if (rv) {
 			dev_err(soc_runtime->dev,
 				"error writing to irqclear reg: %d\n", rv);
@@ -688,7 +688,7 @@ static irqreturn_t lpass_dma_interrupt_handler(
 	}
 
 	if (interrupts & LPAIF_IRQ_ERR(chan)) {
-		rv = regmap_update_bits(map, reg, mask, (LPAIF_IRQ_ERR(chan) | val));
+		rv = regmap_write_bits(map, reg, mask, (LPAIF_IRQ_ERR(chan) | val));
 		if (rv) {
 			dev_err(soc_runtime->dev,
 				"error writing to irqclear reg: %d\n", rv);
diff --git a/sound/soc/soc-ops.c b/sound/soc/soc-ops.c
index dc0e7c8d31f3..53457a0d466d 100644
--- a/sound/soc/soc-ops.c
+++ b/sound/soc/soc-ops.c
@@ -308,7 +308,7 @@ int snd_soc_put_volsw(struct snd_kcontrol *kcontrol,
 	unsigned int sign_bit = mc->sign_bit;
 	unsigned int mask = (1 << fls(max)) - 1;
 	unsigned int invert = mc->invert;
-	int err;
+	int err, ret;
 	bool type_2r = false;
 	unsigned int val2 = 0;
 	unsigned int val, val_mask;
@@ -350,12 +350,18 @@ int snd_soc_put_volsw(struct snd_kcontrol *kcontrol,
 	err = snd_soc_component_update_bits(component, reg, val_mask, val);
 	if (err < 0)
 		return err;
+	ret = err;
 
-	if (type_2r)
+	if (type_2r) {
 		err = snd_soc_component_update_bits(component, reg2, val_mask,
-			val2);
+						    val2);
+		/* Don't discard any error code or drop change flag */
+		if (ret == 0 || err < 0) {
+			ret = err;
+		}
+	}
 
-	return err;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(snd_soc_put_volsw);
 
@@ -421,6 +427,7 @@ int snd_soc_put_volsw_sx(struct snd_kcontrol *kcontrol,
 	int min = mc->min;
 	unsigned int mask = (1U << (fls(min + max) - 1)) - 1;
 	int err = 0;
+	int ret;
 	unsigned int val, val_mask;
 
 	val = ucontrol->value.integer.value[0];
@@ -437,6 +444,7 @@ int snd_soc_put_volsw_sx(struct snd_kcontrol *kcontrol,
 	err = snd_soc_component_update_bits(component, reg, val_mask, val);
 	if (err < 0)
 		return err;
+	ret = err;
 
 	if (snd_soc_volsw_is_stereo(mc)) {
 		unsigned int val2;
@@ -447,6 +455,11 @@ int snd_soc_put_volsw_sx(struct snd_kcontrol *kcontrol,
 
 		err = snd_soc_component_update_bits(component, reg2, val_mask,
 			val2);
+
+		/* Don't discard any error code or drop change flag */
+		if (ret == 0 || err < 0) {
+			ret = err;
+		}
 	}
 	return err;
 }
@@ -506,7 +519,7 @@ int snd_soc_put_volsw_range(struct snd_kcontrol *kcontrol,
 	unsigned int mask = (1 << fls(max)) - 1;
 	unsigned int invert = mc->invert;
 	unsigned int val, val_mask;
-	int ret;
+	int err, ret;
 
 	if (invert)
 		val = (max - ucontrol->value.integer.value[0]) & mask;
@@ -515,9 +528,10 @@ int snd_soc_put_volsw_range(struct snd_kcontrol *kcontrol,
 	val_mask = mask << shift;
 	val = val << shift;
 
-	ret = snd_soc_component_update_bits(component, reg, val_mask, val);
-	if (ret < 0)
-		return ret;
+	err = snd_soc_component_update_bits(component, reg, val_mask, val);
+	if (err < 0)
+		return err;
+	ret = err;
 
 	if (snd_soc_volsw_is_stereo(mc)) {
 		if (invert)
@@ -527,8 +541,12 @@ int snd_soc_put_volsw_range(struct snd_kcontrol *kcontrol,
 		val_mask = mask << shift;
 		val = val << shift;
 
-		ret = snd_soc_component_update_bits(component, rreg, val_mask,
+		err = snd_soc_component_update_bits(component, rreg, val_mask,
 			val);
+		/* Don't discard any error code or drop change flag */
+		if (ret == 0 || err < 0) {
+			ret = err;
+		}
 	}
 
 	return ret;
@@ -877,6 +895,7 @@ int snd_soc_put_xr_sx(struct snd_kcontrol *kcontrol,
 	unsigned long mask = (1UL<<mc->nbits)-1;
 	long max = mc->max;
 	long val = ucontrol->value.integer.value[0];
+	int ret = 0;
 	unsigned int i;
 
 	if (val < mc->min || val > mc->max)
@@ -891,9 +910,11 @@ int snd_soc_put_xr_sx(struct snd_kcontrol *kcontrol,
 							regmask, regval);
 		if (err < 0)
 			return err;
+		if (err > 0)
+			ret = err;
 	}
 
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(snd_soc_put_xr_sx);
 
diff --git a/sound/usb/implicit.c b/sound/usb/implicit.c
index 70319c822c10..2d444ec74202 100644
--- a/sound/usb/implicit.c
+++ b/sound/usb/implicit.c
@@ -47,13 +47,13 @@ struct snd_usb_implicit_fb_match {
 static const struct snd_usb_implicit_fb_match playback_implicit_fb_quirks[] = {
 	/* Generic matching */
 	IMPLICIT_FB_GENERIC_DEV(0x0499, 0x1509), /* Steinberg UR22 */
-	IMPLICIT_FB_GENERIC_DEV(0x0763, 0x2080), /* M-Audio FastTrack Ultra */
-	IMPLICIT_FB_GENERIC_DEV(0x0763, 0x2081), /* M-Audio FastTrack Ultra */
 	IMPLICIT_FB_GENERIC_DEV(0x0763, 0x2030), /* M-Audio Fast Track C400 */
 	IMPLICIT_FB_GENERIC_DEV(0x0763, 0x2031), /* M-Audio Fast Track C600 */
 
 	/* Fixed EP */
 	/* FIXME: check the availability of generic matching */
+	IMPLICIT_FB_FIXED_DEV(0x0763, 0x2080, 0x81, 2), /* M-Audio FastTrack Ultra */
+	IMPLICIT_FB_FIXED_DEV(0x0763, 0x2081, 0x81, 2), /* M-Audio FastTrack Ultra */
 	IMPLICIT_FB_FIXED_DEV(0x2466, 0x8010, 0x81, 2), /* Fractal Audio Axe-Fx III */
 	IMPLICIT_FB_FIXED_DEV(0x31e9, 0x0001, 0x81, 2), /* Solid State Logic SSL2 */
 	IMPLICIT_FB_FIXED_DEV(0x31e9, 0x0002, 0x81, 2), /* Solid State Logic SSL2+ */
diff --git a/tools/lib/subcmd/subcmd-util.h b/tools/lib/subcmd/subcmd-util.h
index 794a375dad36..b2aec04fce8f 100644
--- a/tools/lib/subcmd/subcmd-util.h
+++ b/tools/lib/subcmd/subcmd-util.h
@@ -50,15 +50,8 @@ static NORETURN inline void die(const char *err, ...)
 static inline void *xrealloc(void *ptr, size_t size)
 {
 	void *ret = realloc(ptr, size);
-	if (!ret && !size)
-		ret = realloc(ptr, 1);
-	if (!ret) {
-		ret = realloc(ptr, size);
-		if (!ret && !size)
-			ret = realloc(ptr, 1);
-		if (!ret)
-			die("Out of memory, realloc failed");
-	}
+	if (!ret)
+		die("Out of memory, realloc failed");
 	return ret;
 }
 
diff --git a/tools/perf/util/bpf-loader.c b/tools/perf/util/bpf-loader.c
index fbb3c4057c30..71710a1da447 100644
--- a/tools/perf/util/bpf-loader.c
+++ b/tools/perf/util/bpf-loader.c
@@ -1214,9 +1214,10 @@ bpf__obj_config_map(struct bpf_object *obj,
 	pr_debug("ERROR: Invalid map config option '%s'\n", map_opt);
 	err = -BPF_LOADER_ERRNO__OBJCONF_MAP_OPT;
 out:
-	free(map_name);
 	if (!err)
 		*key_scan_pos += strlen(map_opt);
+
+	free(map_name);
 	return err;
 }
 
diff --git a/tools/testing/kunit/kunit_kernel.py b/tools/testing/kunit/kunit_kernel.py
index 2c6f916ccbaf..0874e512d109 100644
--- a/tools/testing/kunit/kunit_kernel.py
+++ b/tools/testing/kunit/kunit_kernel.py
@@ -6,6 +6,7 @@
 # Author: Felix Guo <felixguoxiuping@gmail.com>
 # Author: Brendan Higgins <brendanhiggins@google.com>
 
+import importlib.abc
 import importlib.util
 import logging
 import subprocess
diff --git a/tools/testing/selftests/clone3/clone3.c b/tools/testing/selftests/clone3/clone3.c
index 076cf4325f78..cd4582129c7d 100644
--- a/tools/testing/selftests/clone3/clone3.c
+++ b/tools/testing/selftests/clone3/clone3.c
@@ -126,8 +126,6 @@ static void test_clone3(uint64_t flags, size_t size, int expected,
 
 int main(int argc, char *argv[])
 {
-	pid_t pid;
-
 	uid_t uid = getuid();
 
 	ksft_print_header();
diff --git a/tools/testing/selftests/exec/Makefile b/tools/testing/selftests/exec/Makefile
index 12c5e27d32c1..2d7fca446c7f 100644
--- a/tools/testing/selftests/exec/Makefile
+++ b/tools/testing/selftests/exec/Makefile
@@ -3,8 +3,8 @@ CFLAGS = -Wall
 CFLAGS += -Wno-nonnull
 CFLAGS += -D_GNU_SOURCE
 
-TEST_PROGS := binfmt_script non-regular
-TEST_GEN_PROGS := execveat load_address_4096 load_address_2097152 load_address_16777216
+TEST_PROGS := binfmt_script
+TEST_GEN_PROGS := execveat load_address_4096 load_address_2097152 load_address_16777216 non-regular
 TEST_GEN_FILES := execveat.symlink execveat.denatured script subdir
 # Makefile is a run-time dependency, since it's accessed by the execveat test
 TEST_FILES := Makefile
diff --git a/tools/testing/selftests/kselftest_harness.h b/tools/testing/selftests/kselftest_harness.h
index 79a182cfa43a..78e59620d28d 100644
--- a/tools/testing/selftests/kselftest_harness.h
+++ b/tools/testing/selftests/kselftest_harness.h
@@ -875,7 +875,8 @@ static void __timeout_handler(int sig, siginfo_t *info, void *ucontext)
 	}
 
 	t->timed_out = true;
-	kill(t->pid, SIGKILL);
+	// signal process group
+	kill(-(t->pid), SIGKILL);
 }
 
 void __wait_for_test(struct __test_metadata *t)
@@ -985,6 +986,7 @@ void __run_test(struct __fixture_metadata *f,
 		ksft_print_msg("ERROR SPAWNING TEST CHILD\n");
 		t->passed = 0;
 	} else if (t->pid == 0) {
+		setpgrp();
 		t->fn(t, variant);
 		if (t->skip)
 			_exit(255);
diff --git a/tools/testing/selftests/mincore/mincore_selftest.c b/tools/testing/selftests/mincore/mincore_selftest.c
index e54106643337..4c88238fc8f0 100644
--- a/tools/testing/selftests/mincore/mincore_selftest.c
+++ b/tools/testing/selftests/mincore/mincore_selftest.c
@@ -207,15 +207,21 @@ TEST(check_file_mmap)
 
 	errno = 0;
 	fd = open(".", O_TMPFILE | O_RDWR, 0600);
-	ASSERT_NE(-1, fd) {
-		TH_LOG("Can't create temporary file: %s",
-			strerror(errno));
+	if (fd < 0) {
+		ASSERT_EQ(errno, EOPNOTSUPP) {
+			TH_LOG("Can't create temporary file: %s",
+			       strerror(errno));
+		}
+		SKIP(goto out_free, "O_TMPFILE not supported by filesystem.");
 	}
 	errno = 0;
 	retval = fallocate(fd, 0, 0, FILE_SIZE);
-	ASSERT_EQ(0, retval) {
-		TH_LOG("Error allocating space for the temporary file: %s",
-			strerror(errno));
+	if (retval) {
+		ASSERT_EQ(errno, EOPNOTSUPP) {
+			TH_LOG("Error allocating space for the temporary file: %s",
+			       strerror(errno));
+		}
+		SKIP(goto out_close, "fallocate not supported by filesystem.");
 	}
 
 	/*
@@ -271,7 +277,9 @@ TEST(check_file_mmap)
 	}
 
 	munmap(addr, FILE_SIZE);
+out_close:
 	close(fd);
+out_free:
 	free(vec);
 }
 
diff --git a/tools/testing/selftests/mount_setattr/mount_setattr_test.c b/tools/testing/selftests/mount_setattr/mount_setattr_test.c
index f31205f04ee0..8c5fea68ae67 100644
--- a/tools/testing/selftests/mount_setattr/mount_setattr_test.c
+++ b/tools/testing/selftests/mount_setattr/mount_setattr_test.c
@@ -1236,7 +1236,7 @@ static int get_userns_fd(unsigned long nsid, unsigned long hostid, unsigned long
 }
 
 /**
- * Validate that an attached mount in our mount namespace can be idmapped.
+ * Validate that an attached mount in our mount namespace cannot be idmapped.
  * (The kernel enforces that the mount's mount namespace and the caller's mount
  *  namespace match.)
  */
@@ -1259,7 +1259,7 @@ TEST_F(mount_setattr_idmapped, attached_mount_inside_current_mount_namespace)
 
 	attr.userns_fd	= get_userns_fd(0, 10000, 10000);
 	ASSERT_GE(attr.userns_fd, 0);
-	ASSERT_EQ(sys_mount_setattr(open_tree_fd, "", AT_EMPTY_PATH, &attr, sizeof(attr)), 0);
+	ASSERT_NE(sys_mount_setattr(open_tree_fd, "", AT_EMPTY_PATH, &attr, sizeof(attr)), 0);
 	ASSERT_EQ(close(attr.userns_fd), 0);
 	ASSERT_EQ(close(open_tree_fd), 0);
 }
diff --git a/tools/testing/selftests/netfilter/nft_concat_range.sh b/tools/testing/selftests/netfilter/nft_concat_range.sh
index 9313fa32bef1..b5eef5ffb58e 100755
--- a/tools/testing/selftests/netfilter/nft_concat_range.sh
+++ b/tools/testing/selftests/netfilter/nft_concat_range.sh
@@ -1583,4 +1583,4 @@ for name in ${TESTS}; do
 	done
 done
 
-[ ${passed} -eq 0 ] && exit ${KSELFTEST_SKIP}
+[ ${passed} -eq 0 ] && exit ${KSELFTEST_SKIP} || exit 0
diff --git a/tools/testing/selftests/netfilter/nft_fib.sh b/tools/testing/selftests/netfilter/nft_fib.sh
index 6caf6ac8c285..695a1958723f 100755
--- a/tools/testing/selftests/netfilter/nft_fib.sh
+++ b/tools/testing/selftests/netfilter/nft_fib.sh
@@ -174,6 +174,7 @@ test_ping() {
 ip netns exec ${nsrouter} sysctl net.ipv6.conf.all.forwarding=1 > /dev/null
 ip netns exec ${nsrouter} sysctl net.ipv4.conf.veth0.forwarding=1 > /dev/null
 ip netns exec ${nsrouter} sysctl net.ipv4.conf.veth1.forwarding=1 > /dev/null
+ip netns exec ${nsrouter} sysctl net.ipv4.conf.veth0.rp_filter=0 > /dev/null
 
 sleep 3
 
diff --git a/tools/testing/selftests/openat2/Makefile b/tools/testing/selftests/openat2/Makefile
index 4b93b1417b86..843ba56d8e49 100644
--- a/tools/testing/selftests/openat2/Makefile
+++ b/tools/testing/selftests/openat2/Makefile
@@ -5,4 +5,4 @@ TEST_GEN_PROGS := openat2_test resolve_test rename_attack_test
 
 include ../lib.mk
 
-$(TEST_GEN_PROGS): helpers.c
+$(TEST_GEN_PROGS): helpers.c helpers.h
diff --git a/tools/testing/selftests/openat2/helpers.h b/tools/testing/selftests/openat2/helpers.h
index a6ea27344db2..7056340b9339 100644
--- a/tools/testing/selftests/openat2/helpers.h
+++ b/tools/testing/selftests/openat2/helpers.h
@@ -9,6 +9,7 @@
 
 #define _GNU_SOURCE
 #include <stdint.h>
+#include <stdbool.h>
 #include <errno.h>
 #include <linux/types.h>
 #include "../kselftest.h"
@@ -62,11 +63,12 @@ bool needs_openat2(const struct open_how *how);
 					(similar to chroot(2)). */
 #endif /* RESOLVE_IN_ROOT */
 
-#define E_func(func, ...)						\
-	do {								\
-		if (func(__VA_ARGS__) < 0)				\
-			ksft_exit_fail_msg("%s:%d %s failed\n", \
-					   __FILE__, __LINE__, #func);\
+#define E_func(func, ...)						      \
+	do {								      \
+		errno = 0;						      \
+		if (func(__VA_ARGS__) < 0)				      \
+			ksft_exit_fail_msg("%s:%d %s failed - errno:%d\n",    \
+					   __FILE__, __LINE__, #func, errno); \
 	} while (0)
 
 #define E_asprintf(...)		E_func(asprintf,	__VA_ARGS__)
diff --git a/tools/testing/selftests/openat2/openat2_test.c b/tools/testing/selftests/openat2/openat2_test.c
index 1bddbe934204..7fb902099de4 100644
--- a/tools/testing/selftests/openat2/openat2_test.c
+++ b/tools/testing/selftests/openat2/openat2_test.c
@@ -259,6 +259,16 @@ void test_openat2_flags(void)
 		unlink(path);
 
 		fd = sys_openat2(AT_FDCWD, path, &test->how);
+		if (fd < 0 && fd == -EOPNOTSUPP) {
+			/*
+			 * Skip the testcase if it failed because not supported
+			 * by FS. (e.g. a valid O_TMPFILE combination on NFS)
+			 */
+			ksft_test_result_skip("openat2 with %s fails with %d (%s)\n",
+					      test->name, fd, strerror(-fd));
+			goto next;
+		}
+
 		if (test->err >= 0)
 			failed = (fd < 0);
 		else
@@ -303,7 +313,7 @@ void test_openat2_flags(void)
 		else
 			resultfn("openat2 with %s fails with %d (%s)\n",
 				 test->name, test->err, strerror(-test->err));
-
+next:
 		free(fdpath);
 		fflush(stdout);
 	}
diff --git a/tools/testing/selftests/pidfd/pidfd.h b/tools/testing/selftests/pidfd/pidfd.h
index 01f8d3c0cf2c..6922d6417e1c 100644
--- a/tools/testing/selftests/pidfd/pidfd.h
+++ b/tools/testing/selftests/pidfd/pidfd.h
@@ -68,7 +68,7 @@
 #define PIDFD_SKIP 3
 #define PIDFD_XFAIL 4
 
-int wait_for_pid(pid_t pid)
+static inline int wait_for_pid(pid_t pid)
 {
 	int status, ret;
 
@@ -78,13 +78,20 @@ int wait_for_pid(pid_t pid)
 		if (errno == EINTR)
 			goto again;
 
+		ksft_print_msg("waitpid returned -1, errno=%d\n", errno);
 		return -1;
 	}
 
-	if (!WIFEXITED(status))
+	if (!WIFEXITED(status)) {
+		ksft_print_msg(
+		       "waitpid !WIFEXITED, WIFSIGNALED=%d, WTERMSIG=%d\n",
+		       WIFSIGNALED(status), WTERMSIG(status));
 		return -1;
+	}
 
-	return WEXITSTATUS(status);
+	ret = WEXITSTATUS(status);
+	ksft_print_msg("waitpid WEXITSTATUS=%d\n", ret);
+	return ret;
 }
 
 static inline int sys_pidfd_open(pid_t pid, unsigned int flags)
diff --git a/tools/testing/selftests/pidfd/pidfd_fdinfo_test.c b/tools/testing/selftests/pidfd/pidfd_fdinfo_test.c
index 22558524f71c..3fd8e903118f 100644
--- a/tools/testing/selftests/pidfd/pidfd_fdinfo_test.c
+++ b/tools/testing/selftests/pidfd/pidfd_fdinfo_test.c
@@ -12,6 +12,7 @@
 #include <string.h>
 #include <syscall.h>
 #include <sys/wait.h>
+#include <sys/mman.h>
 
 #include "pidfd.h"
 #include "../kselftest.h"
@@ -80,7 +81,10 @@ static inline int error_check(struct error *err, const char *test_name)
 	return err->code;
 }
 
+#define CHILD_STACK_SIZE 8192
+
 struct child {
+	char *stack;
 	pid_t pid;
 	int   fd;
 };
@@ -89,17 +93,22 @@ static struct child clone_newns(int (*fn)(void *), void *args,
 				struct error *err)
 {
 	static int flags = CLONE_PIDFD | CLONE_NEWPID | CLONE_NEWNS | SIGCHLD;
-	size_t stack_size = 1024;
-	char *stack[1024] = { 0 };
 	struct child ret;
 
 	if (!(flags & CLONE_NEWUSER) && geteuid() != 0)
 		flags |= CLONE_NEWUSER;
 
+	ret.stack = mmap(NULL, CHILD_STACK_SIZE, PROT_READ | PROT_WRITE,
+			 MAP_PRIVATE | MAP_ANONYMOUS | MAP_STACK, -1, 0);
+	if (ret.stack == MAP_FAILED) {
+		error_set(err, -1, "mmap of stack failed (errno %d)", errno);
+		return ret;
+	}
+
 #ifdef __ia64__
-	ret.pid = __clone2(fn, stack, stack_size, flags, args, &ret.fd);
+	ret.pid = __clone2(fn, ret.stack, CHILD_STACK_SIZE, flags, args, &ret.fd);
 #else
-	ret.pid = clone(fn, stack + stack_size, flags, args, &ret.fd);
+	ret.pid = clone(fn, ret.stack + CHILD_STACK_SIZE, flags, args, &ret.fd);
 #endif
 
 	if (ret.pid < 0) {
@@ -129,6 +138,11 @@ static inline int child_join(struct child *child, struct error *err)
 	else if (r > 0)
 		error_set(err, r, "child %d reported: %d", child->pid, r);
 
+	if (munmap(child->stack, CHILD_STACK_SIZE)) {
+		error_set(err, -1, "munmap of child stack failed (errno %d)", errno);
+		r = -1;
+	}
+
 	return r;
 }
 
diff --git a/tools/testing/selftests/pidfd/pidfd_test.c b/tools/testing/selftests/pidfd/pidfd_test.c
index 529eb700ac26..9a2d64901d59 100644
--- a/tools/testing/selftests/pidfd/pidfd_test.c
+++ b/tools/testing/selftests/pidfd/pidfd_test.c
@@ -441,7 +441,6 @@ static void test_pidfd_poll_exec(int use_waitpid)
 {
 	int pid, pidfd = 0;
 	int status, ret;
-	pthread_t t1;
 	time_t prog_start = time(NULL);
 	const char *test_name = "pidfd_poll check for premature notification on child thread exec";
 
@@ -500,13 +499,14 @@ static int child_poll_leader_exit_test(void *args)
 	 */
 	*child_exit_secs = time(NULL);
 	syscall(SYS_exit, 0);
+	/* Never reached, but appeases compiler thinking we should return. */
+	exit(0);
 }
 
 static void test_pidfd_poll_leader_exit(int use_waitpid)
 {
 	int pid, pidfd = 0;
-	int status, ret;
-	time_t prog_start = time(NULL);
+	int status, ret = 0;
 	const char *test_name = "pidfd_poll check for premature notification on non-empty"
 				"group leader exit";
 
diff --git a/tools/testing/selftests/pidfd/pidfd_wait.c b/tools/testing/selftests/pidfd/pidfd_wait.c
index be2943f072f6..17999e082aa7 100644
--- a/tools/testing/selftests/pidfd/pidfd_wait.c
+++ b/tools/testing/selftests/pidfd/pidfd_wait.c
@@ -39,7 +39,7 @@ static int sys_waitid(int which, pid_t pid, siginfo_t *info, int options,
 
 TEST(wait_simple)
 {
-	int pidfd = -1, status = 0;
+	int pidfd = -1;
 	pid_t parent_tid = -1;
 	struct clone_args args = {
 		.parent_tid = ptr_to_u64(&parent_tid),
@@ -47,7 +47,6 @@ TEST(wait_simple)
 		.flags = CLONE_PIDFD | CLONE_PARENT_SETTID,
 		.exit_signal = SIGCHLD,
 	};
-	int ret;
 	pid_t pid;
 	siginfo_t info = {
 		.si_signo = 0,
@@ -88,7 +87,7 @@ TEST(wait_simple)
 
 TEST(wait_states)
 {
-	int pidfd = -1, status = 0;
+	int pidfd = -1;
 	pid_t parent_tid = -1;
 	struct clone_args args = {
 		.parent_tid = ptr_to_u64(&parent_tid),
diff --git a/tools/testing/selftests/rtc/settings b/tools/testing/selftests/rtc/settings
index ba4d85f74cd6..a953c96aa16e 100644
--- a/tools/testing/selftests/rtc/settings
+++ b/tools/testing/selftests/rtc/settings
@@ -1 +1 @@
-timeout=90
+timeout=180
diff --git a/tools/testing/selftests/vDSO/vdso_test_abi.c b/tools/testing/selftests/vDSO/vdso_test_abi.c
index 3d603f1394af..883ca85424bc 100644
--- a/tools/testing/selftests/vDSO/vdso_test_abi.c
+++ b/tools/testing/selftests/vDSO/vdso_test_abi.c
@@ -33,110 +33,114 @@ typedef long (*vdso_clock_gettime_t)(clockid_t clk_id, struct timespec *ts);
 typedef long (*vdso_clock_getres_t)(clockid_t clk_id, struct timespec *ts);
 typedef time_t (*vdso_time_t)(time_t *t);
 
-static int vdso_test_gettimeofday(void)
+#define VDSO_TEST_PASS_MSG()	"\n%s(): PASS\n", __func__
+#define VDSO_TEST_FAIL_MSG(x)	"\n%s(): %s FAIL\n", __func__, x
+#define VDSO_TEST_SKIP_MSG(x)	"\n%s(): SKIP: Could not find %s\n", __func__, x
+
+static void vdso_test_gettimeofday(void)
 {
 	/* Find gettimeofday. */
 	vdso_gettimeofday_t vdso_gettimeofday =
 		(vdso_gettimeofday_t)vdso_sym(version, name[0]);
 
 	if (!vdso_gettimeofday) {
-		printf("Could not find %s\n", name[0]);
-		return KSFT_SKIP;
+		ksft_test_result_skip(VDSO_TEST_SKIP_MSG(name[0]));
+		return;
 	}
 
 	struct timeval tv;
 	long ret = vdso_gettimeofday(&tv, 0);
 
 	if (ret == 0) {
-		printf("The time is %lld.%06lld\n",
-		       (long long)tv.tv_sec, (long long)tv.tv_usec);
+		ksft_print_msg("The time is %lld.%06lld\n",
+			       (long long)tv.tv_sec, (long long)tv.tv_usec);
+		ksft_test_result_pass(VDSO_TEST_PASS_MSG());
 	} else {
-		printf("%s failed\n", name[0]);
-		return KSFT_FAIL;
+		ksft_test_result_fail(VDSO_TEST_FAIL_MSG(name[0]));
 	}
-
-	return KSFT_PASS;
 }
 
-static int vdso_test_clock_gettime(clockid_t clk_id)
+static void vdso_test_clock_gettime(clockid_t clk_id)
 {
 	/* Find clock_gettime. */
 	vdso_clock_gettime_t vdso_clock_gettime =
 		(vdso_clock_gettime_t)vdso_sym(version, name[1]);
 
 	if (!vdso_clock_gettime) {
-		printf("Could not find %s\n", name[1]);
-		return KSFT_SKIP;
+		ksft_test_result_skip(VDSO_TEST_SKIP_MSG(name[1]));
+		return;
 	}
 
 	struct timespec ts;
 	long ret = vdso_clock_gettime(clk_id, &ts);
 
 	if (ret == 0) {
-		printf("The time is %lld.%06lld\n",
-		       (long long)ts.tv_sec, (long long)ts.tv_nsec);
+		ksft_print_msg("The time is %lld.%06lld\n",
+			       (long long)ts.tv_sec, (long long)ts.tv_nsec);
+		ksft_test_result_pass(VDSO_TEST_PASS_MSG());
 	} else {
-		printf("%s failed\n", name[1]);
-		return KSFT_FAIL;
+		ksft_test_result_fail(VDSO_TEST_FAIL_MSG(name[1]));
 	}
-
-	return KSFT_PASS;
 }
 
-static int vdso_test_time(void)
+static void vdso_test_time(void)
 {
 	/* Find time. */
 	vdso_time_t vdso_time =
 		(vdso_time_t)vdso_sym(version, name[2]);
 
 	if (!vdso_time) {
-		printf("Could not find %s\n", name[2]);
-		return KSFT_SKIP;
+		ksft_test_result_skip(VDSO_TEST_SKIP_MSG(name[2]));
+		return;
 	}
 
 	long ret = vdso_time(NULL);
 
 	if (ret > 0) {
-		printf("The time in hours since January 1, 1970 is %lld\n",
+		ksft_print_msg("The time in hours since January 1, 1970 is %lld\n",
 				(long long)(ret / 3600));
+		ksft_test_result_pass(VDSO_TEST_PASS_MSG());
 	} else {
-		printf("%s failed\n", name[2]);
-		return KSFT_FAIL;
+		ksft_test_result_fail(VDSO_TEST_FAIL_MSG(name[2]));
 	}
-
-	return KSFT_PASS;
 }
 
-static int vdso_test_clock_getres(clockid_t clk_id)
+static void vdso_test_clock_getres(clockid_t clk_id)
 {
+	int clock_getres_fail = 0;
+
 	/* Find clock_getres. */
 	vdso_clock_getres_t vdso_clock_getres =
 		(vdso_clock_getres_t)vdso_sym(version, name[3]);
 
 	if (!vdso_clock_getres) {
-		printf("Could not find %s\n", name[3]);
-		return KSFT_SKIP;
+		ksft_test_result_skip(VDSO_TEST_SKIP_MSG(name[3]));
+		return;
 	}
 
 	struct timespec ts, sys_ts;
 	long ret = vdso_clock_getres(clk_id, &ts);
 
 	if (ret == 0) {
-		printf("The resolution is %lld %lld\n",
-		       (long long)ts.tv_sec, (long long)ts.tv_nsec);
+		ksft_print_msg("The vdso resolution is %lld %lld\n",
+			       (long long)ts.tv_sec, (long long)ts.tv_nsec);
 	} else {
-		printf("%s failed\n", name[3]);
-		return KSFT_FAIL;
+		clock_getres_fail++;
 	}
 
 	ret = syscall(SYS_clock_getres, clk_id, &sys_ts);
 
-	if ((sys_ts.tv_sec != ts.tv_sec) || (sys_ts.tv_nsec != ts.tv_nsec)) {
-		printf("%s failed\n", name[3]);
-		return KSFT_FAIL;
-	}
+	ksft_print_msg("The syscall resolution is %lld %lld\n",
+			(long long)sys_ts.tv_sec, (long long)sys_ts.tv_nsec);
 
-	return KSFT_PASS;
+	if ((sys_ts.tv_sec != ts.tv_sec) || (sys_ts.tv_nsec != ts.tv_nsec))
+		clock_getres_fail++;
+
+	if (clock_getres_fail > 0) {
+		ksft_test_result_fail(VDSO_TEST_FAIL_MSG(name[3]));
+	} else {
+		ksft_test_result_pass(VDSO_TEST_PASS_MSG());
+	}
 }
 
 const char *vdso_clock_name[12] = {
@@ -158,36 +162,23 @@ const char *vdso_clock_name[12] = {
  * This function calls vdso_test_clock_gettime and vdso_test_clock_getres
  * with different values for clock_id.
  */
-static inline int vdso_test_clock(clockid_t clock_id)
+static inline void vdso_test_clock(clockid_t clock_id)
 {
-	int ret0, ret1;
-
-	ret0 = vdso_test_clock_gettime(clock_id);
-	/* A skipped test is considered passed */
-	if (ret0 == KSFT_SKIP)
-		ret0 = KSFT_PASS;
-
-	ret1 = vdso_test_clock_getres(clock_id);
-	/* A skipped test is considered passed */
-	if (ret1 == KSFT_SKIP)
-		ret1 = KSFT_PASS;
+	ksft_print_msg("\nclock_id: %s\n", vdso_clock_name[clock_id]);
 
-	ret0 += ret1;
+	vdso_test_clock_gettime(clock_id);
 
-	printf("clock_id: %s", vdso_clock_name[clock_id]);
-
-	if (ret0 > 0)
-		printf(" [FAIL]\n");
-	else
-		printf(" [PASS]\n");
-
-	return ret0;
+	vdso_test_clock_getres(clock_id);
 }
 
+#define VDSO_TEST_PLAN	16
+
 int main(int argc, char **argv)
 {
 	unsigned long sysinfo_ehdr = getauxval(AT_SYSINFO_EHDR);
-	int ret;
+
+	ksft_print_header();
+	ksft_set_plan(VDSO_TEST_PLAN);
 
 	if (!sysinfo_ehdr) {
 		printf("AT_SYSINFO_EHDR is not present!\n");
@@ -201,44 +192,42 @@ int main(int argc, char **argv)
 
 	vdso_init_from_sysinfo_ehdr(getauxval(AT_SYSINFO_EHDR));
 
-	ret = vdso_test_gettimeofday();
+	vdso_test_gettimeofday();
 
 #if _POSIX_TIMERS > 0
 
 #ifdef CLOCK_REALTIME
-	ret += vdso_test_clock(CLOCK_REALTIME);
+	vdso_test_clock(CLOCK_REALTIME);
 #endif
 
 #ifdef CLOCK_BOOTTIME
-	ret += vdso_test_clock(CLOCK_BOOTTIME);
+	vdso_test_clock(CLOCK_BOOTTIME);
 #endif
 
 #ifdef CLOCK_TAI
-	ret += vdso_test_clock(CLOCK_TAI);
+	vdso_test_clock(CLOCK_TAI);
 #endif
 
 #ifdef CLOCK_REALTIME_COARSE
-	ret += vdso_test_clock(CLOCK_REALTIME_COARSE);
+	vdso_test_clock(CLOCK_REALTIME_COARSE);
 #endif
 
 #ifdef CLOCK_MONOTONIC
-	ret += vdso_test_clock(CLOCK_MONOTONIC);
+	vdso_test_clock(CLOCK_MONOTONIC);
 #endif
 
 #ifdef CLOCK_MONOTONIC_RAW
-	ret += vdso_test_clock(CLOCK_MONOTONIC_RAW);
+	vdso_test_clock(CLOCK_MONOTONIC_RAW);
 #endif
 
 #ifdef CLOCK_MONOTONIC_COARSE
-	ret += vdso_test_clock(CLOCK_MONOTONIC_COARSE);
+	vdso_test_clock(CLOCK_MONOTONIC_COARSE);
 #endif
 
 #endif
 
-	ret += vdso_test_time();
-
-	if (ret > 0)
-		return KSFT_FAIL;
+	vdso_test_time();
 
-	return KSFT_PASS;
+	ksft_print_cnts();
+	return ksft_get_fail_cnt() == 0 ? KSFT_PASS : KSFT_FAIL;
 }
diff --git a/tools/testing/selftests/zram/zram.sh b/tools/testing/selftests/zram/zram.sh
index 232e958ec454..b0b91d9b0dc2 100755
--- a/tools/testing/selftests/zram/zram.sh
+++ b/tools/testing/selftests/zram/zram.sh
@@ -2,9 +2,6 @@
 # SPDX-License-Identifier: GPL-2.0
 TCID="zram.sh"
 
-# Kselftest framework requirement - SKIP code is 4.
-ksft_skip=4
-
 . ./zram_lib.sh
 
 run_zram () {
@@ -18,14 +15,4 @@ echo ""
 
 check_prereqs
 
-# check zram module exists
-MODULE_PATH=/lib/modules/`uname -r`/kernel/drivers/block/zram/zram.ko
-if [ -f $MODULE_PATH ]; then
-	run_zram
-elif [ -b /dev/zram0 ]; then
-	run_zram
-else
-	echo "$TCID : No zram.ko module or /dev/zram0 device file not found"
-	echo "$TCID : CONFIG_ZRAM is not set"
-	exit $ksft_skip
-fi
+run_zram
diff --git a/tools/testing/selftests/zram/zram01.sh b/tools/testing/selftests/zram/zram01.sh
index 114863d9fb87..8f4affe34f3e 100755
--- a/tools/testing/selftests/zram/zram01.sh
+++ b/tools/testing/selftests/zram/zram01.sh
@@ -33,9 +33,7 @@ zram_algs="lzo"
 
 zram_fill_fs()
 {
-	local mem_free0=$(free -m | awk 'NR==2 {print $4}')
-
-	for i in $(seq 0 $(($dev_num - 1))); do
+	for i in $(seq $dev_start $dev_end); do
 		echo "fill zram$i..."
 		local b=0
 		while [ true ]; do
@@ -45,29 +43,17 @@ zram_fill_fs()
 			b=$(($b + 1))
 		done
 		echo "zram$i can be filled with '$b' KB"
-	done
 
-	local mem_free1=$(free -m | awk 'NR==2 {print $4}')
-	local used_mem=$(($mem_free0 - $mem_free1))
+		local mem_used_total=`awk '{print $3}' "/sys/block/zram$i/mm_stat"`
+		local v=$((100 * 1024 * $b / $mem_used_total))
+		if [ "$v" -lt 100 ]; then
+			 echo "FAIL compression ratio: 0.$v:1"
+			 ERR_CODE=-1
+			 return
+		fi
 
-	local total_size=0
-	for sm in $zram_sizes; do
-		local s=$(echo $sm | sed 's/M//')
-		total_size=$(($total_size + $s))
+		echo "zram compression ratio: $(echo "scale=2; $v / 100 " | bc):1: OK"
 	done
-
-	echo "zram used ${used_mem}M, zram disk sizes ${total_size}M"
-
-	local v=$((100 * $total_size / $used_mem))
-
-	if [ "$v" -lt 100 ]; then
-		echo "FAIL compression ratio: 0.$v:1"
-		ERR_CODE=-1
-		zram_cleanup
-		return
-	fi
-
-	echo "zram compression ratio: $(echo "scale=2; $v / 100 " | bc):1: OK"
 }
 
 check_prereqs
@@ -81,7 +67,6 @@ zram_mount
 
 zram_fill_fs
 zram_cleanup
-zram_unload
 
 if [ $ERR_CODE -ne 0 ]; then
 	echo "$TCID : [FAIL]"
diff --git a/tools/testing/selftests/zram/zram02.sh b/tools/testing/selftests/zram/zram02.sh
index e83b404807c0..2418b0c4ed13 100755
--- a/tools/testing/selftests/zram/zram02.sh
+++ b/tools/testing/selftests/zram/zram02.sh
@@ -36,7 +36,6 @@ zram_set_memlimit
 zram_makeswap
 zram_swapoff
 zram_cleanup
-zram_unload
 
 if [ $ERR_CODE -ne 0 ]; then
 	echo "$TCID : [FAIL]"
diff --git a/tools/testing/selftests/zram/zram_lib.sh b/tools/testing/selftests/zram/zram_lib.sh
index 6f872f266fd1..21ec1966de76 100755
--- a/tools/testing/selftests/zram/zram_lib.sh
+++ b/tools/testing/selftests/zram/zram_lib.sh
@@ -5,12 +5,17 @@
 # Author: Alexey Kodanev <alexey.kodanev@oracle.com>
 # Modified: Naresh Kamboju <naresh.kamboju@linaro.org>
 
-MODULE=0
 dev_makeswap=-1
 dev_mounted=-1
-
+dev_start=0
+dev_end=-1
+module_load=-1
+sys_control=-1
 # Kselftest framework requirement - SKIP code is 4.
 ksft_skip=4
+kernel_version=`uname -r | cut -d'.' -f1,2`
+kernel_major=${kernel_version%.*}
+kernel_minor=${kernel_version#*.}
 
 trap INT
 
@@ -25,68 +30,104 @@ check_prereqs()
 	fi
 }
 
+kernel_gte()
+{
+	major=${1%.*}
+	minor=${1#*.}
+
+	if [ $kernel_major -gt $major ]; then
+		return 0
+	elif [[ $kernel_major -eq $major && $kernel_minor -ge $minor ]]; then
+		return 0
+	fi
+
+	return 1
+}
+
 zram_cleanup()
 {
 	echo "zram cleanup"
 	local i=
-	for i in $(seq 0 $dev_makeswap); do
+	for i in $(seq $dev_start $dev_makeswap); do
 		swapoff /dev/zram$i
 	done
 
-	for i in $(seq 0 $dev_mounted); do
+	for i in $(seq $dev_start $dev_mounted); do
 		umount /dev/zram$i
 	done
 
-	for i in $(seq 0 $(($dev_num - 1))); do
+	for i in $(seq $dev_start $dev_end); do
 		echo 1 > /sys/block/zram${i}/reset
 		rm -rf zram$i
 	done
 
-}
+	if [ $sys_control -eq 1 ]; then
+		for i in $(seq $dev_start $dev_end); do
+			echo $i > /sys/class/zram-control/hot_remove
+		done
+	fi
 
-zram_unload()
-{
-	if [ $MODULE -ne 0 ] ; then
-		echo "zram rmmod zram"
+	if [ $module_load -eq 1 ]; then
 		rmmod zram > /dev/null 2>&1
 	fi
 }
 
 zram_load()
 {
-	# check zram module exists
-	MODULE_PATH=/lib/modules/`uname -r`/kernel/drivers/block/zram/zram.ko
-	if [ -f $MODULE_PATH ]; then
-		MODULE=1
-		echo "create '$dev_num' zram device(s)"
-		modprobe zram num_devices=$dev_num
-		if [ $? -ne 0 ]; then
-			echo "failed to insert zram module"
-			exit 1
-		fi
-
-		dev_num_created=$(ls /dev/zram* | wc -w)
+	echo "create '$dev_num' zram device(s)"
+
+	# zram module loaded, new kernel
+	if [ -d "/sys/class/zram-control" ]; then
+		echo "zram modules already loaded, kernel supports" \
+			"zram-control interface"
+		dev_start=$(ls /dev/zram* | wc -w)
+		dev_end=$(($dev_start + $dev_num - 1))
+		sys_control=1
+
+		for i in $(seq $dev_start $dev_end); do
+			cat /sys/class/zram-control/hot_add > /dev/null
+		done
+
+		echo "all zram devices (/dev/zram$dev_start~$dev_end" \
+			"successfully created"
+		return 0
+	fi
 
-		if [ "$dev_num_created" -ne "$dev_num" ]; then
-			echo "unexpected num of devices: $dev_num_created"
-			ERR_CODE=-1
+	# detect old kernel or built-in
+	modprobe zram num_devices=$dev_num
+	if [ ! -d "/sys/class/zram-control" ]; then
+		if grep -q '^zram' /proc/modules; then
+			rmmod zram > /dev/null 2>&1
+			if [ $? -ne 0 ]; then
+				echo "zram module is being used on old kernel" \
+					"without zram-control interface"
+				exit $ksft_skip
+			fi
 		else
-			echo "zram load module successful"
+			echo "test needs CONFIG_ZRAM=m on old kernel without" \
+				"zram-control interface"
+			exit $ksft_skip
 		fi
-	elif [ -b /dev/zram0 ]; then
-		echo "/dev/zram0 device file found: OK"
-	else
-		echo "ERROR: No zram.ko module or no /dev/zram0 device found"
-		echo "$TCID : CONFIG_ZRAM is not set"
-		exit 1
+		modprobe zram num_devices=$dev_num
 	fi
+
+	module_load=1
+	dev_end=$(($dev_num - 1))
+	echo "all zram devices (/dev/zram0~$dev_end) successfully created"
 }
 
 zram_max_streams()
 {
 	echo "set max_comp_streams to zram device(s)"
 
-	local i=0
+	kernel_gte 4.7
+	if [ $? -eq 0 ]; then
+		echo "The device attribute max_comp_streams was"\
+		               "deprecated in 4.7"
+		return 0
+	fi
+
+	local i=$dev_start
 	for max_s in $zram_max_streams; do
 		local sys_path="/sys/block/zram${i}/max_comp_streams"
 		echo $max_s > $sys_path || \
@@ -98,7 +139,7 @@ zram_max_streams()
 			echo "FAIL can't set max_streams '$max_s', get $max_stream"
 
 		i=$(($i + 1))
-		echo "$sys_path = '$max_streams' ($i/$dev_num)"
+		echo "$sys_path = '$max_streams'"
 	done
 
 	echo "zram max streams: OK"
@@ -108,15 +149,16 @@ zram_compress_alg()
 {
 	echo "test that we can set compression algorithm"
 
-	local algs=$(cat /sys/block/zram0/comp_algorithm)
+	local i=$dev_start
+	local algs=$(cat /sys/block/zram${i}/comp_algorithm)
 	echo "supported algs: $algs"
-	local i=0
+
 	for alg in $zram_algs; do
 		local sys_path="/sys/block/zram${i}/comp_algorithm"
 		echo "$alg" >	$sys_path || \
 			echo "FAIL can't set '$alg' to $sys_path"
 		i=$(($i + 1))
-		echo "$sys_path = '$alg' ($i/$dev_num)"
+		echo "$sys_path = '$alg'"
 	done
 
 	echo "zram set compression algorithm: OK"
@@ -125,14 +167,14 @@ zram_compress_alg()
 zram_set_disksizes()
 {
 	echo "set disk size to zram device(s)"
-	local i=0
+	local i=$dev_start
 	for ds in $zram_sizes; do
 		local sys_path="/sys/block/zram${i}/disksize"
 		echo "$ds" >	$sys_path || \
 			echo "FAIL can't set '$ds' to $sys_path"
 
 		i=$(($i + 1))
-		echo "$sys_path = '$ds' ($i/$dev_num)"
+		echo "$sys_path = '$ds'"
 	done
 
 	echo "zram set disksizes: OK"
@@ -142,14 +184,14 @@ zram_set_memlimit()
 {
 	echo "set memory limit to zram device(s)"
 
-	local i=0
+	local i=$dev_start
 	for ds in $zram_mem_limits; do
 		local sys_path="/sys/block/zram${i}/mem_limit"
 		echo "$ds" >	$sys_path || \
 			echo "FAIL can't set '$ds' to $sys_path"
 
 		i=$(($i + 1))
-		echo "$sys_path = '$ds' ($i/$dev_num)"
+		echo "$sys_path = '$ds'"
 	done
 
 	echo "zram set memory limit: OK"
@@ -158,8 +200,8 @@ zram_set_memlimit()
 zram_makeswap()
 {
 	echo "make swap with zram device(s)"
-	local i=0
-	for i in $(seq 0 $(($dev_num - 1))); do
+	local i=$dev_start
+	for i in $(seq $dev_start $dev_end); do
 		mkswap /dev/zram$i > err.log 2>&1
 		if [ $? -ne 0 ]; then
 			cat err.log
@@ -182,7 +224,7 @@ zram_makeswap()
 zram_swapoff()
 {
 	local i=
-	for i in $(seq 0 $dev_makeswap); do
+	for i in $(seq $dev_start $dev_end); do
 		swapoff /dev/zram$i > err.log 2>&1
 		if [ $? -ne 0 ]; then
 			cat err.log
@@ -196,7 +238,7 @@ zram_swapoff()
 
 zram_makefs()
 {
-	local i=0
+	local i=$dev_start
 	for fs in $zram_filesystems; do
 		# if requested fs not supported default it to ext2
 		which mkfs.$fs > /dev/null 2>&1 || fs=ext2
@@ -215,7 +257,7 @@ zram_makefs()
 zram_mount()
 {
 	local i=0
-	for i in $(seq 0 $(($dev_num - 1))); do
+	for i in $(seq $dev_start $dev_end); do
 		echo "mount /dev/zram$i"
 		mkdir zram$i
 		mount /dev/zram$i zram$i > /dev/null || \
