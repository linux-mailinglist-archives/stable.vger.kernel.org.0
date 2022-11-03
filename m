Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5BF618072
	for <lists+stable@lfdr.de>; Thu,  3 Nov 2022 16:04:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231808AbiKCPEI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Nov 2022 11:04:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231815AbiKCPCm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Nov 2022 11:02:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0C581A3BF;
        Thu,  3 Nov 2022 08:02:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 350A5B8286C;
        Thu,  3 Nov 2022 15:02:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32C85C433D7;
        Thu,  3 Nov 2022 15:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667487753;
        bh=aoZXSMOLGXz1aABAEwaFXHU9pMYwsQbnm+dJfi9Y5j4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OJy3z7o6Gp0p1uaT1A+Xkx/n0/V06Bmi7Jwoz7h6nFXH9QOQGrRILMwnaK5qokYtW
         O65g2uB3rZWuvK9O2C79jVIeANIxAGNXYQbTHb+8HsnxFqI+sngzhmdDveZbxoVcVW
         dKUQHS3OpXcE0JL5ohlrInkVFw96/LFoRDTEwbR8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.10.153
Date:   Fri,  4 Nov 2022 00:03:06 +0900
Message-Id: <166748778551243@kroah.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <166748778521563@kroah.com>
References: <166748778521563@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index a0750d051982..d1cd7539105d 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 10
-SUBLEVEL = 152
+SUBLEVEL = 153
 EXTRAVERSION =
 NAME = Dare mighty things
 
diff --git a/arch/arc/include/asm/io.h b/arch/arc/include/asm/io.h
index 8f777d6441a5..80347382a380 100644
--- a/arch/arc/include/asm/io.h
+++ b/arch/arc/include/asm/io.h
@@ -32,7 +32,7 @@ static inline void ioport_unmap(void __iomem *addr)
 {
 }
 
-extern void iounmap(const void __iomem *addr);
+extern void iounmap(const volatile void __iomem *addr);
 
 /*
  * io{read,write}{16,32}be() macros
diff --git a/arch/arc/mm/ioremap.c b/arch/arc/mm/ioremap.c
index 95c649fbc95a..d3b1ea16e9cd 100644
--- a/arch/arc/mm/ioremap.c
+++ b/arch/arc/mm/ioremap.c
@@ -93,7 +93,7 @@ void __iomem *ioremap_prot(phys_addr_t paddr, unsigned long size,
 EXPORT_SYMBOL(ioremap_prot);
 
 
-void iounmap(const void __iomem *addr)
+void iounmap(const volatile void __iomem *addr)
 {
 	/* weird double cast to handle phys_addr_t > 32 bits */
 	if (arc_uncached_addr_space((phys_addr_t)(u32)addr))
diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 423f9b40e4d9..31ba0ac7db63 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -648,7 +648,8 @@ static inline bool system_supports_4kb_granule(void)
 	val = cpuid_feature_extract_unsigned_field(mmfr0,
 						ID_AA64MMFR0_TGRAN4_SHIFT);
 
-	return val == ID_AA64MMFR0_TGRAN4_SUPPORTED;
+	return (val >= ID_AA64MMFR0_TGRAN4_SUPPORTED_MIN) &&
+	       (val <= ID_AA64MMFR0_TGRAN4_SUPPORTED_MAX);
 }
 
 static inline bool system_supports_64kb_granule(void)
@@ -660,7 +661,8 @@ static inline bool system_supports_64kb_granule(void)
 	val = cpuid_feature_extract_unsigned_field(mmfr0,
 						ID_AA64MMFR0_TGRAN64_SHIFT);
 
-	return val == ID_AA64MMFR0_TGRAN64_SUPPORTED;
+	return (val >= ID_AA64MMFR0_TGRAN64_SUPPORTED_MIN) &&
+	       (val <= ID_AA64MMFR0_TGRAN64_SUPPORTED_MAX);
 }
 
 static inline bool system_supports_16kb_granule(void)
@@ -672,7 +674,8 @@ static inline bool system_supports_16kb_granule(void)
 	val = cpuid_feature_extract_unsigned_field(mmfr0,
 						ID_AA64MMFR0_TGRAN16_SHIFT);
 
-	return val == ID_AA64MMFR0_TGRAN16_SUPPORTED;
+	return (val >= ID_AA64MMFR0_TGRAN16_SUPPORTED_MIN) &&
+	       (val <= ID_AA64MMFR0_TGRAN16_SUPPORTED_MAX);
 }
 
 static inline bool system_supports_mixed_endian_el0(void)
diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index 39f5c1672f48..457b6bb276bb 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -60,6 +60,7 @@
 #define ARM_CPU_IMP_FUJITSU		0x46
 #define ARM_CPU_IMP_HISI		0x48
 #define ARM_CPU_IMP_APPLE		0x61
+#define ARM_CPU_IMP_AMPERE		0xC0
 
 #define ARM_CPU_PART_AEM_V8		0xD0F
 #define ARM_CPU_PART_FOUNDATION		0xD00
@@ -112,6 +113,8 @@
 #define APPLE_CPU_PART_M1_ICESTORM	0x022
 #define APPLE_CPU_PART_M1_FIRESTORM	0x023
 
+#define AMPERE_CPU_PART_AMPERE1		0xAC3
+
 #define MIDR_CORTEX_A53 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A53)
 #define MIDR_CORTEX_A57 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A57)
 #define MIDR_CORTEX_A72 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A72)
@@ -151,6 +154,7 @@
 #define MIDR_HISI_TSV110 MIDR_CPU_MODEL(ARM_CPU_IMP_HISI, HISI_CPU_PART_TSV110)
 #define MIDR_APPLE_M1_ICESTORM MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M1_ICESTORM)
 #define MIDR_APPLE_M1_FIRESTORM MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M1_FIRESTORM)
+#define MIDR_AMPERE1 MIDR_CPU_MODEL(ARM_CPU_IMP_AMPERE, AMPERE_CPU_PART_AMPERE1)
 
 /* Fujitsu Erratum 010001 affects A64FX 1.0 and 1.1, (v0r0 and v1r0) */
 #define MIDR_FUJITSU_ERRATUM_010001		MIDR_FUJITSU_A64FX
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 1f2209ad2cca..06755fad3830 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -786,15 +786,24 @@
 #define ID_AA64MMFR0_ASID_SHIFT		4
 #define ID_AA64MMFR0_PARANGE_SHIFT	0
 
-#define ID_AA64MMFR0_TGRAN4_NI		0xf
-#define ID_AA64MMFR0_TGRAN4_SUPPORTED	0x0
-#define ID_AA64MMFR0_TGRAN64_NI		0xf
-#define ID_AA64MMFR0_TGRAN64_SUPPORTED	0x0
-#define ID_AA64MMFR0_TGRAN16_NI		0x0
-#define ID_AA64MMFR0_TGRAN16_SUPPORTED	0x1
+#define ID_AA64MMFR0_TGRAN4_NI			0xf
+#define ID_AA64MMFR0_TGRAN4_SUPPORTED_MIN	0x0
+#define ID_AA64MMFR0_TGRAN4_SUPPORTED_MAX	0x7
+#define ID_AA64MMFR0_TGRAN64_NI			0xf
+#define ID_AA64MMFR0_TGRAN64_SUPPORTED_MIN	0x0
+#define ID_AA64MMFR0_TGRAN64_SUPPORTED_MAX	0x7
+#define ID_AA64MMFR0_TGRAN16_NI			0x0
+#define ID_AA64MMFR0_TGRAN16_SUPPORTED_MIN	0x1
+#define ID_AA64MMFR0_TGRAN16_SUPPORTED_MAX	0xf
+
 #define ID_AA64MMFR0_PARANGE_48		0x5
 #define ID_AA64MMFR0_PARANGE_52		0x6
 
+#define ID_AA64MMFR0_TGRAN_2_SUPPORTED_DEFAULT	0x0
+#define ID_AA64MMFR0_TGRAN_2_SUPPORTED_NONE	0x1
+#define ID_AA64MMFR0_TGRAN_2_SUPPORTED_MIN	0x2
+#define ID_AA64MMFR0_TGRAN_2_SUPPORTED_MAX	0x7
+
 #ifdef CONFIG_ARM64_PA_BITS_52
 #define ID_AA64MMFR0_PARANGE_MAX	ID_AA64MMFR0_PARANGE_52
 #else
@@ -955,14 +964,17 @@
 #define ID_PFR1_PROGMOD_SHIFT		0
 
 #if defined(CONFIG_ARM64_4K_PAGES)
-#define ID_AA64MMFR0_TGRAN_SHIFT	ID_AA64MMFR0_TGRAN4_SHIFT
-#define ID_AA64MMFR0_TGRAN_SUPPORTED	ID_AA64MMFR0_TGRAN4_SUPPORTED
+#define ID_AA64MMFR0_TGRAN_SHIFT		ID_AA64MMFR0_TGRAN4_SHIFT
+#define ID_AA64MMFR0_TGRAN_SUPPORTED_MIN	ID_AA64MMFR0_TGRAN4_SUPPORTED_MIN
+#define ID_AA64MMFR0_TGRAN_SUPPORTED_MAX	ID_AA64MMFR0_TGRAN4_SUPPORTED_MAX
 #elif defined(CONFIG_ARM64_16K_PAGES)
-#define ID_AA64MMFR0_TGRAN_SHIFT	ID_AA64MMFR0_TGRAN16_SHIFT
-#define ID_AA64MMFR0_TGRAN_SUPPORTED	ID_AA64MMFR0_TGRAN16_SUPPORTED
+#define ID_AA64MMFR0_TGRAN_SHIFT		ID_AA64MMFR0_TGRAN16_SHIFT
+#define ID_AA64MMFR0_TGRAN_SUPPORTED_MIN	ID_AA64MMFR0_TGRAN16_SUPPORTED_MIN
+#define ID_AA64MMFR0_TGRAN_SUPPORTED_MAX	ID_AA64MMFR0_TGRAN16_SUPPORTED_MAX
 #elif defined(CONFIG_ARM64_64K_PAGES)
-#define ID_AA64MMFR0_TGRAN_SHIFT	ID_AA64MMFR0_TGRAN64_SHIFT
-#define ID_AA64MMFR0_TGRAN_SUPPORTED	ID_AA64MMFR0_TGRAN64_SUPPORTED
+#define ID_AA64MMFR0_TGRAN_SHIFT		ID_AA64MMFR0_TGRAN64_SHIFT
+#define ID_AA64MMFR0_TGRAN_SUPPORTED_MIN	ID_AA64MMFR0_TGRAN64_SUPPORTED_MIN
+#define ID_AA64MMFR0_TGRAN_SUPPORTED_MAX	ID_AA64MMFR0_TGRAN64_SUPPORTED_MAX
 #endif
 
 #define MVFR2_FPMISC_SHIFT		4
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index f9119eea735e..e1c25fa3b8e6 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -797,8 +797,10 @@ SYM_FUNC_END(__secondary_too_slow)
 SYM_FUNC_START(__enable_mmu)
 	mrs	x2, ID_AA64MMFR0_EL1
 	ubfx	x2, x2, #ID_AA64MMFR0_TGRAN_SHIFT, 4
-	cmp	x2, #ID_AA64MMFR0_TGRAN_SUPPORTED
-	b.ne	__no_granule_support
+	cmp     x2, #ID_AA64MMFR0_TGRAN_SUPPORTED_MIN
+	b.lt    __no_granule_support
+	cmp     x2, #ID_AA64MMFR0_TGRAN_SUPPORTED_MAX
+	b.gt    __no_granule_support
 	update_early_cpu_boot_status 0, x2, x3
 	adrp	x2, idmap_pg_dir
 	phys_to_ttbr x1, x1
diff --git a/arch/arm64/kernel/proton-pack.c b/arch/arm64/kernel/proton-pack.c
index 6ae53d8cd576..faa8a6bf2376 100644
--- a/arch/arm64/kernel/proton-pack.c
+++ b/arch/arm64/kernel/proton-pack.c
@@ -876,6 +876,10 @@ u8 spectre_bhb_loop_affected(int scope)
 			MIDR_ALL_VERSIONS(MIDR_NEOVERSE_N1),
 			{},
 		};
+		static const struct midr_range spectre_bhb_k11_list[] = {
+			MIDR_ALL_VERSIONS(MIDR_AMPERE1),
+			{},
+		};
 		static const struct midr_range spectre_bhb_k8_list[] = {
 			MIDR_ALL_VERSIONS(MIDR_CORTEX_A72),
 			MIDR_ALL_VERSIONS(MIDR_CORTEX_A57),
@@ -886,6 +890,8 @@ u8 spectre_bhb_loop_affected(int scope)
 			k = 32;
 		else if (is_midr_in_range_list(read_cpuid_id(), spectre_bhb_k24_list))
 			k = 24;
+		else if (is_midr_in_range_list(read_cpuid_id(), spectre_bhb_k11_list))
+			k = 11;
 		else if (is_midr_in_range_list(read_cpuid_id(), spectre_bhb_k8_list))
 			k =  8;
 
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 204c62debf06..6f85c1821c3f 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -397,16 +397,18 @@ int kvm_set_ipa_limit(void)
 	}
 
 	switch (cpuid_feature_extract_unsigned_field(mmfr0, tgran_2)) {
-	default:
-	case 1:
+	case ID_AA64MMFR0_TGRAN_2_SUPPORTED_NONE:
 		kvm_err("PAGE_SIZE not supported at Stage-2, giving up\n");
 		return -EINVAL;
-	case 0:
+	case ID_AA64MMFR0_TGRAN_2_SUPPORTED_DEFAULT:
 		kvm_debug("PAGE_SIZE supported at Stage-2 (default)\n");
 		break;
-	case 2:
+	case ID_AA64MMFR0_TGRAN_2_SUPPORTED_MIN ... ID_AA64MMFR0_TGRAN_2_SUPPORTED_MAX:
 		kvm_debug("PAGE_SIZE supported at Stage-2 (advertised)\n");
 		break;
+	default:
+		kvm_err("Unsupported value for TGRAN_2, giving up\n");
+		return -EINVAL;
 	}
 
 	kvm_ipa_limit = id_aa64mmfr0_parange_to_phys_shift(parange);
diff --git a/arch/s390/include/asm/futex.h b/arch/s390/include/asm/futex.h
index 26f9144562c9..e1d0b2aaaddd 100644
--- a/arch/s390/include/asm/futex.h
+++ b/arch/s390/include/asm/futex.h
@@ -16,7 +16,8 @@
 		"3: jl    1b\n"						\
 		"   lhi   %0,0\n"					\
 		"4: sacf  768\n"					\
-		EX_TABLE(0b,4b) EX_TABLE(2b,4b) EX_TABLE(3b,4b)		\
+		EX_TABLE(0b,4b) EX_TABLE(1b,4b)				\
+		EX_TABLE(2b,4b) EX_TABLE(3b,4b)				\
 		: "=d" (ret), "=&d" (oldval), "=&d" (newval),		\
 		  "=m" (*uaddr)						\
 		: "0" (-EFAULT), "d" (oparg), "a" (uaddr),		\
diff --git a/arch/s390/pci/pci_mmio.c b/arch/s390/pci/pci_mmio.c
index 37b1bbd1a27c..1ec8076209ca 100644
--- a/arch/s390/pci/pci_mmio.c
+++ b/arch/s390/pci/pci_mmio.c
@@ -64,7 +64,7 @@ static inline int __pcistg_mio_inuser(
 	asm volatile (
 		"       sacf    256\n"
 		"0:     llgc    %[tmp],0(%[src])\n"
-		"       sllg    %[val],%[val],8\n"
+		"4:	sllg	%[val],%[val],8\n"
 		"       aghi    %[src],1\n"
 		"       ogr     %[val],%[tmp]\n"
 		"       brctg   %[cnt],0b\n"
@@ -72,7 +72,7 @@ static inline int __pcistg_mio_inuser(
 		"2:     ipm     %[cc]\n"
 		"       srl     %[cc],28\n"
 		"3:     sacf    768\n"
-		EX_TABLE(0b, 3b) EX_TABLE(1b, 3b) EX_TABLE(2b, 3b)
+		EX_TABLE(0b, 3b) EX_TABLE(4b, 3b) EX_TABLE(1b, 3b) EX_TABLE(2b, 3b)
 		:
 		[src] "+a" (src), [cnt] "+d" (cnt),
 		[val] "+d" (val), [tmp] "=d" (tmp),
@@ -222,10 +222,10 @@ static inline int __pcilg_mio_inuser(
 		"2:     ahi     %[shift],-8\n"
 		"       srlg    %[tmp],%[val],0(%[shift])\n"
 		"3:     stc     %[tmp],0(%[dst])\n"
-		"       aghi    %[dst],1\n"
+		"5:	aghi	%[dst],1\n"
 		"       brctg   %[cnt],2b\n"
 		"4:     sacf    768\n"
-		EX_TABLE(0b, 4b) EX_TABLE(1b, 4b) EX_TABLE(3b, 4b)
+		EX_TABLE(0b, 4b) EX_TABLE(1b, 4b) EX_TABLE(3b, 4b) EX_TABLE(5b, 4b)
 		:
 		[cc] "+d" (cc), [val] "=d" (val), [len] "+d" (len),
 		[dst] "+a" (dst), [cnt] "+d" (cnt), [tmp] "=d" (tmp),
diff --git a/arch/x86/events/intel/lbr.c b/arch/x86/events/intel/lbr.c
index 42173a7be3bb..4b6c39c5facb 100644
--- a/arch/x86/events/intel/lbr.c
+++ b/arch/x86/events/intel/lbr.c
@@ -1847,7 +1847,7 @@ void __init intel_pmu_arch_lbr_init(void)
 	return;
 
 clear_arch_lbr:
-	clear_cpu_cap(&boot_cpu_data, X86_FEATURE_ARCH_LBR);
+	setup_clear_cpu_cap(X86_FEATURE_ARCH_LBR);
 }
 
 /**
diff --git a/arch/x86/kernel/unwind_orc.c b/arch/x86/kernel/unwind_orc.c
index cc071c4c6524..d557a545f4bc 100644
--- a/arch/x86/kernel/unwind_orc.c
+++ b/arch/x86/kernel/unwind_orc.c
@@ -697,7 +697,7 @@ void __unwind_start(struct unwind_state *state, struct task_struct *task,
 	/* Otherwise, skip ahead to the user-specified starting frame: */
 	while (!unwind_done(state) &&
 	       (!on_stack(&state->stack_info, first_frame, sizeof(long)) ||
-			state->sp < (unsigned long)first_frame))
+			state->sp <= (unsigned long)first_frame))
 		unwind_next_frame(state);
 
 	return;
diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
index 743268996336..d0ba5459ce0b 100644
--- a/drivers/base/power/domain.c
+++ b/drivers/base/power/domain.c
@@ -2789,6 +2789,10 @@ static int genpd_iterate_idle_states(struct device_node *dn,
 		np = it.node;
 		if (!of_match_node(idle_state_match, np))
 			continue;
+
+		if (!of_device_is_available(np))
+			continue;
+
 		if (states) {
 			ret = genpd_parse_state(&states[i], np);
 			if (ret) {
diff --git a/drivers/counter/microchip-tcb-capture.c b/drivers/counter/microchip-tcb-capture.c
index 710acc0a3704..85fbbac06d31 100644
--- a/drivers/counter/microchip-tcb-capture.c
+++ b/drivers/counter/microchip-tcb-capture.c
@@ -29,7 +29,6 @@ struct mchp_tc_data {
 	int qdec_mode;
 	int num_channels;
 	int channel[2];
-	bool trig_inverted;
 };
 
 enum mchp_tc_count_function {
@@ -163,7 +162,7 @@ static int mchp_tc_count_signal_read(struct counter_device *counter,
 
 	regmap_read(priv->regmap, ATMEL_TC_REG(priv->channel[0], SR), &sr);
 
-	if (priv->trig_inverted)
+	if (signal->id == 1)
 		sigstatus = (sr & ATMEL_TC_MTIOB);
 	else
 		sigstatus = (sr & ATMEL_TC_MTIOA);
@@ -181,6 +180,17 @@ static int mchp_tc_count_action_get(struct counter_device *counter,
 	struct mchp_tc_data *const priv = counter->priv;
 	u32 cmr;
 
+	if (priv->qdec_mode) {
+		*action = COUNTER_SYNAPSE_ACTION_BOTH_EDGES;
+		return 0;
+	}
+
+	/* Only TIOA signal is evaluated in non-QDEC mode */
+	if (synapse->signal->id != 0) {
+		*action = COUNTER_SYNAPSE_ACTION_NONE;
+		return 0;
+	}
+
 	regmap_read(priv->regmap, ATMEL_TC_REG(priv->channel[0], CMR), &cmr);
 
 	switch (cmr & ATMEL_TC_ETRGEDG) {
@@ -209,8 +219,8 @@ static int mchp_tc_count_action_set(struct counter_device *counter,
 	struct mchp_tc_data *const priv = counter->priv;
 	u32 edge = ATMEL_TC_ETRGEDG_NONE;
 
-	/* QDEC mode is rising edge only */
-	if (priv->qdec_mode)
+	/* QDEC mode is rising edge only; only TIOA handled in non-QDEC mode */
+	if (priv->qdec_mode || synapse->signal->id != 0)
 		return -EINVAL;
 
 	switch (action) {
diff --git a/drivers/firmware/efi/libstub/arm64-stub.c b/drivers/firmware/efi/libstub/arm64-stub.c
index 415a971e7694..7f4bafcd9d33 100644
--- a/drivers/firmware/efi/libstub/arm64-stub.c
+++ b/drivers/firmware/efi/libstub/arm64-stub.c
@@ -24,7 +24,7 @@ efi_status_t check_platform_features(void)
 		return EFI_SUCCESS;
 
 	tg = (read_cpuid(ID_AA64MMFR0_EL1) >> ID_AA64MMFR0_TGRAN_SHIFT) & 0xf;
-	if (tg != ID_AA64MMFR0_TGRAN_SUPPORTED) {
+	if (tg < ID_AA64MMFR0_TGRAN_SUPPORTED_MIN || tg > ID_AA64MMFR0_TGRAN_SUPPORTED_MAX) {
 		if (IS_ENABLED(CONFIG_ARM64_64K_PAGES))
 			efi_err("This 64 KB granular kernel is not supported by your CPU\n");
 		else
diff --git a/drivers/gpu/drm/msm/disp/mdp4/mdp4_lvds_connector.c b/drivers/gpu/drm/msm/disp/mdp4/mdp4_lvds_connector.c
index 7288041dd86a..7444b75c4215 100644
--- a/drivers/gpu/drm/msm/disp/mdp4/mdp4_lvds_connector.c
+++ b/drivers/gpu/drm/msm/disp/mdp4/mdp4_lvds_connector.c
@@ -56,8 +56,9 @@ static int mdp4_lvds_connector_get_modes(struct drm_connector *connector)
 	return ret;
 }
 
-static int mdp4_lvds_connector_mode_valid(struct drm_connector *connector,
-				 struct drm_display_mode *mode)
+static enum drm_mode_status
+mdp4_lvds_connector_mode_valid(struct drm_connector *connector,
+			       struct drm_display_mode *mode)
 {
 	struct mdp4_lvds_connector *mdp4_lvds_connector =
 			to_mdp4_lvds_connector(connector);
diff --git a/drivers/gpu/drm/msm/dp/dp_display.c b/drivers/gpu/drm/msm/dp/dp_display.c
index a3de1d0523ea..5a152d505dfb 100644
--- a/drivers/gpu/drm/msm/dp/dp_display.c
+++ b/drivers/gpu/drm/msm/dp/dp_display.c
@@ -1201,7 +1201,7 @@ int dp_display_request_irq(struct msm_dp *dp_display)
 		return -EINVAL;
 	}
 
-	rc = devm_request_irq(&dp->pdev->dev, dp->irq,
+	rc = devm_request_irq(dp_display->drm_dev->dev, dp->irq,
 			dp_display_irq_handler,
 			IRQF_TRIGGER_HIGH, "dp_display_isr", dp);
 	if (rc < 0) {
diff --git a/drivers/gpu/drm/msm/dsi/dsi.c b/drivers/gpu/drm/msm/dsi/dsi.c
index f845333593da..7377596a13f4 100644
--- a/drivers/gpu/drm/msm/dsi/dsi.c
+++ b/drivers/gpu/drm/msm/dsi/dsi.c
@@ -205,6 +205,12 @@ int msm_dsi_modeset_init(struct msm_dsi *msm_dsi, struct drm_device *dev,
 		return -EINVAL;
 
 	priv = dev->dev_private;
+
+	if (priv->num_bridges == ARRAY_SIZE(priv->bridges)) {
+		DRM_DEV_ERROR(dev->dev, "too many bridges\n");
+		return -ENOSPC;
+	}
+
 	msm_dsi->dev = dev;
 
 	ret = msm_dsi_host_modeset_init(msm_dsi->host, dev);
diff --git a/drivers/gpu/drm/msm/hdmi/hdmi.c b/drivers/gpu/drm/msm/hdmi/hdmi.c
index 28b33b35a30c..47796e12b432 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi.c
+++ b/drivers/gpu/drm/msm/hdmi/hdmi.c
@@ -293,6 +293,11 @@ int msm_hdmi_modeset_init(struct hdmi *hdmi,
 	struct platform_device *pdev = hdmi->pdev;
 	int ret;
 
+	if (priv->num_bridges == ARRAY_SIZE(priv->bridges)) {
+		DRM_DEV_ERROR(dev->dev, "too many bridges\n");
+		return -ENOSPC;
+	}
+
 	hdmi->dev = dev;
 	hdmi->encoder = encoder;
 
diff --git a/drivers/iio/light/tsl2583.c b/drivers/iio/light/tsl2583.c
index 40b7dd266b31..e39d512145a6 100644
--- a/drivers/iio/light/tsl2583.c
+++ b/drivers/iio/light/tsl2583.c
@@ -856,7 +856,7 @@ static int tsl2583_probe(struct i2c_client *clientp,
 					 TSL2583_POWER_OFF_DELAY_MS);
 	pm_runtime_use_autosuspend(&clientp->dev);
 
-	ret = devm_iio_device_register(indio_dev->dev.parent, indio_dev);
+	ret = iio_device_register(indio_dev);
 	if (ret) {
 		dev_err(&clientp->dev, "%s: iio registration failed\n",
 			__func__);
diff --git a/drivers/iio/temperature/ltc2983.c b/drivers/iio/temperature/ltc2983.c
index 3b4a0e60e605..8306daa77908 100644
--- a/drivers/iio/temperature/ltc2983.c
+++ b/drivers/iio/temperature/ltc2983.c
@@ -1376,13 +1376,6 @@ static int ltc2983_setup(struct ltc2983_data *st, bool assign_iio)
 		return ret;
 	}
 
-	st->iio_chan = devm_kzalloc(&st->spi->dev,
-				    st->iio_channels * sizeof(*st->iio_chan),
-				    GFP_KERNEL);
-
-	if (!st->iio_chan)
-		return -ENOMEM;
-
 	ret = regmap_update_bits(st->regmap, LTC2983_GLOBAL_CONFIG_REG,
 				 LTC2983_NOTCH_FREQ_MASK,
 				 LTC2983_NOTCH_FREQ(st->filter_notch_freq));
@@ -1494,6 +1487,12 @@ static int ltc2983_probe(struct spi_device *spi)
 	if (ret)
 		return ret;
 
+	st->iio_chan = devm_kzalloc(&spi->dev,
+				    st->iio_channels * sizeof(*st->iio_chan),
+				    GFP_KERNEL);
+	if (!st->iio_chan)
+		return -ENOMEM;
+
 	ret = ltc2983_setup(st, true);
 	if (ret)
 		return ret;
diff --git a/drivers/media/test-drivers/vivid/vivid-core.c b/drivers/media/test-drivers/vivid/vivid-core.c
index 1e356dc65d31..761d2abd4006 100644
--- a/drivers/media/test-drivers/vivid/vivid-core.c
+++ b/drivers/media/test-drivers/vivid/vivid-core.c
@@ -330,6 +330,28 @@ static int vidioc_g_fbuf(struct file *file, void *fh, struct v4l2_framebuffer *a
 	return vivid_vid_out_g_fbuf(file, fh, a);
 }
 
+/*
+ * Only support the framebuffer of one of the vivid instances.
+ * Anything else is rejected.
+ */
+bool vivid_validate_fb(const struct v4l2_framebuffer *a)
+{
+	struct vivid_dev *dev;
+	int i;
+
+	for (i = 0; i < n_devs; i++) {
+		dev = vivid_devs[i];
+		if (!dev || !dev->video_pbase)
+			continue;
+		if ((unsigned long)a->base == dev->video_pbase &&
+		    a->fmt.width <= dev->display_width &&
+		    a->fmt.height <= dev->display_height &&
+		    a->fmt.bytesperline <= dev->display_byte_stride)
+			return true;
+	}
+	return false;
+}
+
 static int vidioc_s_fbuf(struct file *file, void *fh, const struct v4l2_framebuffer *a)
 {
 	struct video_device *vdev = video_devdata(file);
@@ -850,8 +872,12 @@ static int vivid_detect_feature_set(struct vivid_dev *dev, int inst,
 
 	/* how many inputs do we have and of what type? */
 	dev->num_inputs = num_inputs[inst];
-	if (dev->num_inputs < 1)
-		dev->num_inputs = 1;
+	if (node_type & 0x20007) {
+		if (dev->num_inputs < 1)
+			dev->num_inputs = 1;
+	} else {
+		dev->num_inputs = 0;
+	}
 	if (dev->num_inputs >= MAX_INPUTS)
 		dev->num_inputs = MAX_INPUTS;
 	for (i = 0; i < dev->num_inputs; i++) {
@@ -868,8 +894,12 @@ static int vivid_detect_feature_set(struct vivid_dev *dev, int inst,
 
 	/* how many outputs do we have and of what type? */
 	dev->num_outputs = num_outputs[inst];
-	if (dev->num_outputs < 1)
-		dev->num_outputs = 1;
+	if (node_type & 0x40300) {
+		if (dev->num_outputs < 1)
+			dev->num_outputs = 1;
+	} else {
+		dev->num_outputs = 0;
+	}
 	if (dev->num_outputs >= MAX_OUTPUTS)
 		dev->num_outputs = MAX_OUTPUTS;
 	for (i = 0; i < dev->num_outputs; i++) {
diff --git a/drivers/media/test-drivers/vivid/vivid-core.h b/drivers/media/test-drivers/vivid/vivid-core.h
index 99e69b8f770f..6aa32c8e6fb5 100644
--- a/drivers/media/test-drivers/vivid/vivid-core.h
+++ b/drivers/media/test-drivers/vivid/vivid-core.h
@@ -609,4 +609,6 @@ static inline bool vivid_is_hdmi_out(const struct vivid_dev *dev)
 	return dev->output_type[dev->output] == HDMI;
 }
 
+bool vivid_validate_fb(const struct v4l2_framebuffer *a);
+
 #endif
diff --git a/drivers/media/test-drivers/vivid/vivid-vid-cap.c b/drivers/media/test-drivers/vivid/vivid-vid-cap.c
index eadf28ab1e39..d493bd17481b 100644
--- a/drivers/media/test-drivers/vivid/vivid-vid-cap.c
+++ b/drivers/media/test-drivers/vivid/vivid-vid-cap.c
@@ -452,6 +452,12 @@ void vivid_update_format_cap(struct vivid_dev *dev, bool keep_controls)
 	tpg_reset_source(&dev->tpg, dev->src_rect.width, dev->src_rect.height, dev->field_cap);
 	dev->crop_cap = dev->src_rect;
 	dev->crop_bounds_cap = dev->src_rect;
+	if (dev->bitmap_cap &&
+	    (dev->compose_cap.width != dev->crop_cap.width ||
+	     dev->compose_cap.height != dev->crop_cap.height)) {
+		vfree(dev->bitmap_cap);
+		dev->bitmap_cap = NULL;
+	}
 	dev->compose_cap = dev->crop_cap;
 	if (V4L2_FIELD_HAS_T_OR_B(dev->field_cap))
 		dev->compose_cap.height /= 2;
@@ -909,6 +915,8 @@ int vivid_vid_cap_s_selection(struct file *file, void *fh, struct v4l2_selection
 	struct vivid_dev *dev = video_drvdata(file);
 	struct v4l2_rect *crop = &dev->crop_cap;
 	struct v4l2_rect *compose = &dev->compose_cap;
+	unsigned orig_compose_w = compose->width;
+	unsigned orig_compose_h = compose->height;
 	unsigned factor = V4L2_FIELD_HAS_T_OR_B(dev->field_cap) ? 2 : 1;
 	int ret;
 
@@ -1025,17 +1033,17 @@ int vivid_vid_cap_s_selection(struct file *file, void *fh, struct v4l2_selection
 			s->r.height /= factor;
 		}
 		v4l2_rect_map_inside(&s->r, &dev->fmt_cap_rect);
-		if (dev->bitmap_cap && (compose->width != s->r.width ||
-					compose->height != s->r.height)) {
-			vfree(dev->bitmap_cap);
-			dev->bitmap_cap = NULL;
-		}
 		*compose = s->r;
 		break;
 	default:
 		return -EINVAL;
 	}
 
+	if (dev->bitmap_cap && (compose->width != orig_compose_w ||
+				compose->height != orig_compose_h)) {
+		vfree(dev->bitmap_cap);
+		dev->bitmap_cap = NULL;
+	}
 	tpg_s_crop_compose(&dev->tpg, crop, compose);
 	return 0;
 }
@@ -1276,7 +1284,14 @@ int vivid_vid_cap_s_fbuf(struct file *file, void *fh,
 		return -EINVAL;
 	if (a->fmt.bytesperline < (a->fmt.width * fmt->bit_depth[0]) / 8)
 		return -EINVAL;
-	if (a->fmt.height * a->fmt.bytesperline < a->fmt.sizeimage)
+	if (a->fmt.bytesperline > a->fmt.sizeimage / a->fmt.height)
+		return -EINVAL;
+
+	/*
+	 * Only support the framebuffer of one of the vivid instances.
+	 * Anything else is rejected.
+	 */
+	if (!vivid_validate_fb(a))
 		return -EINVAL;
 
 	dev->fb_vbase_cap = phys_to_virt((unsigned long)a->base);
diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c b/drivers/media/v4l2-core/v4l2-dv-timings.c
index af48705c704f..003c32fed3f7 100644
--- a/drivers/media/v4l2-core/v4l2-dv-timings.c
+++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
@@ -161,6 +161,20 @@ bool v4l2_valid_dv_timings(const struct v4l2_dv_timings *t,
 	    (bt->interlaced && !(caps & V4L2_DV_BT_CAP_INTERLACED)) ||
 	    (!bt->interlaced && !(caps & V4L2_DV_BT_CAP_PROGRESSIVE)))
 		return false;
+
+	/* sanity checks for the blanking timings */
+	if (!bt->interlaced &&
+	    (bt->il_vbackporch || bt->il_vsync || bt->il_vfrontporch))
+		return false;
+	if (bt->hfrontporch > 2 * bt->width ||
+	    bt->hsync > 1024 || bt->hbackporch > 1024)
+		return false;
+	if (bt->vfrontporch > 4096 ||
+	    bt->vsync > 128 || bt->vbackporch > 4096)
+		return false;
+	if (bt->interlaced && (bt->il_vfrontporch > 4096 ||
+	    bt->il_vsync > 128 || bt->il_vbackporch > 4096))
+		return false;
 	return fnc == NULL || fnc(t, fnc_handle);
 }
 EXPORT_SYMBOL_GPL(v4l2_valid_dv_timings);
diff --git a/drivers/mmc/core/sdio_bus.c b/drivers/mmc/core/sdio_bus.c
index 3d709029e07c..a448535c1265 100644
--- a/drivers/mmc/core/sdio_bus.c
+++ b/drivers/mmc/core/sdio_bus.c
@@ -292,7 +292,8 @@ static void sdio_release_func(struct device *dev)
 {
 	struct sdio_func *func = dev_to_sdio_func(dev);
 
-	sdio_free_func_cis(func);
+	if (!(func->card->quirks & MMC_QUIRK_NONSTD_SDIO))
+		sdio_free_func_cis(func);
 
 	kfree(func->info);
 	kfree(func->tmpbuf);
diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index 30ff42fd173e..82e1fbd6b2ff 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -1079,9 +1079,10 @@ config MMC_SDHCI_OMAP
 
 config MMC_SDHCI_AM654
 	tristate "Support for the SDHCI Controller in TI's AM654 SOCs"
-	depends on MMC_SDHCI_PLTFM && OF && REGMAP_MMIO
+	depends on MMC_SDHCI_PLTFM && OF
 	select MMC_SDHCI_IO_ACCESSORS
 	select MMC_CQHCI
+	select REGMAP_MMIO
 	help
 	  This selects the Secure Digital Host Controller Interface (SDHCI)
 	  support present in TI's AM654 SOCs. The controller supports
diff --git a/drivers/mtd/nand/raw/marvell_nand.c b/drivers/mtd/nand/raw/marvell_nand.c
index d00c916f133b..dce35f81e0a5 100644
--- a/drivers/mtd/nand/raw/marvell_nand.c
+++ b/drivers/mtd/nand/raw/marvell_nand.c
@@ -2672,7 +2672,7 @@ static int marvell_nand_chip_init(struct device *dev, struct marvell_nfc *nfc,
 	chip->controller = &nfc->controller;
 	nand_set_flash_node(chip, np);
 
-	if (!of_property_read_bool(np, "marvell,nand-keep-config"))
+	if (of_property_read_bool(np, "marvell,nand-keep-config"))
 		chip->options |= NAND_KEEP_TIMINGS;
 
 	mtd = nand_to_mtd(chip);
diff --git a/drivers/net/can/mscan/mpc5xxx_can.c b/drivers/net/can/mscan/mpc5xxx_can.c
index e254e04ae257..ef649764f9b4 100644
--- a/drivers/net/can/mscan/mpc5xxx_can.c
+++ b/drivers/net/can/mscan/mpc5xxx_can.c
@@ -325,14 +325,14 @@ static int mpc5xxx_can_probe(struct platform_device *ofdev)
 					       &mscan_clksrc);
 	if (!priv->can.clock.freq) {
 		dev_err(&ofdev->dev, "couldn't get MSCAN clock properties\n");
-		goto exit_free_mscan;
+		goto exit_put_clock;
 	}
 
 	err = register_mscandev(dev, mscan_clksrc);
 	if (err) {
 		dev_err(&ofdev->dev, "registering %s failed (err=%d)\n",
 			DRV_NAME, err);
-		goto exit_free_mscan;
+		goto exit_put_clock;
 	}
 
 	dev_info(&ofdev->dev, "MSCAN at 0x%p, irq %d, clock %d Hz\n",
@@ -340,7 +340,9 @@ static int mpc5xxx_can_probe(struct platform_device *ofdev)
 
 	return 0;
 
-exit_free_mscan:
+exit_put_clock:
+	if (data->put_clock)
+		data->put_clock(ofdev);
 	free_candev(dev);
 exit_dispose_irq:
 	irq_dispose_mapping(irq);
diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index 67f0f14e2bf4..c61534a2a2d3 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -1075,7 +1075,7 @@ static irqreturn_t rcar_canfd_global_interrupt(int irq, void *dev_id)
 	struct rcar_canfd_global *gpriv = dev_id;
 	struct net_device *ndev;
 	struct rcar_canfd_channel *priv;
-	u32 sts, gerfl;
+	u32 sts, cc, gerfl;
 	u32 ch, ridx;
 
 	/* Global error interrupts still indicate a condition specific
@@ -1093,7 +1093,9 @@ static irqreturn_t rcar_canfd_global_interrupt(int irq, void *dev_id)
 
 		/* Handle Rx interrupts */
 		sts = rcar_canfd_read(priv->base, RCANFD_RFSTS(ridx));
-		if (likely(sts & RCANFD_RFSTS_RFIF)) {
+		cc = rcar_canfd_read(priv->base, RCANFD_RFCC(ridx));
+		if (likely(sts & RCANFD_RFSTS_RFIF &&
+			   cc & RCANFD_RFCC_RFIE)) {
 			if (napi_schedule_prep(&priv->napi)) {
 				/* Disable Rx FIFO interrupts */
 				rcar_canfd_clear_bit(priv->base,
diff --git a/drivers/net/can/spi/mcp251x.c b/drivers/net/can/spi/mcp251x.c
index 5dde3c42d241..ffcb04aac972 100644
--- a/drivers/net/can/spi/mcp251x.c
+++ b/drivers/net/can/spi/mcp251x.c
@@ -1419,11 +1419,14 @@ static int mcp251x_can_probe(struct spi_device *spi)
 
 	ret = mcp251x_gpio_setup(priv);
 	if (ret)
-		goto error_probe;
+		goto out_unregister_candev;
 
 	netdev_info(net, "MCP%x successfully initialized.\n", priv->model);
 	return 0;
 
+out_unregister_candev:
+	unregister_candev(net);
+
 error_probe:
 	destroy_workqueue(priv->wq);
 	priv->wq = NULL;
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
index 5d642458bac5..45d278724883 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
@@ -1845,7 +1845,7 @@ static int kvaser_usb_hydra_start_chip(struct kvaser_usb_net_priv *priv)
 {
 	int err;
 
-	init_completion(&priv->start_comp);
+	reinit_completion(&priv->start_comp);
 
 	err = kvaser_usb_hydra_send_simple_cmd(priv->dev, CMD_START_CHIP_REQ,
 					       priv->channel);
@@ -1863,7 +1863,7 @@ static int kvaser_usb_hydra_stop_chip(struct kvaser_usb_net_priv *priv)
 {
 	int err;
 
-	init_completion(&priv->stop_comp);
+	reinit_completion(&priv->stop_comp);
 
 	/* Make sure we do not report invalid BUS_OFF from CMD_CHIP_STATE_EVENT
 	 * see comment in kvaser_usb_hydra_update_state()
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
index 78d52a5e8fd5..15380cc08ee6 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
@@ -1324,7 +1324,7 @@ static int kvaser_usb_leaf_start_chip(struct kvaser_usb_net_priv *priv)
 {
 	int err;
 
-	init_completion(&priv->start_comp);
+	reinit_completion(&priv->start_comp);
 
 	err = kvaser_usb_leaf_send_simple_cmd(priv->dev, CMD_START_CHIP,
 					      priv->channel);
@@ -1342,7 +1342,7 @@ static int kvaser_usb_leaf_stop_chip(struct kvaser_usb_net_priv *priv)
 {
 	int err;
 
-	init_completion(&priv->stop_comp);
+	reinit_completion(&priv->stop_comp);
 
 	err = kvaser_usb_leaf_send_simple_cmd(priv->dev, CMD_STOP_CHIP,
 					      priv->channel);
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
index 213769054391..a7166cd1179f 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
@@ -239,6 +239,7 @@ enum xgbe_sfp_speed {
 #define XGBE_SFP_BASE_BR_1GBE_MAX		0x0d
 #define XGBE_SFP_BASE_BR_10GBE_MIN		0x64
 #define XGBE_SFP_BASE_BR_10GBE_MAX		0x68
+#define XGBE_MOLEX_SFP_BASE_BR_10GBE_MAX	0x78
 
 #define XGBE_SFP_BASE_CU_CABLE_LEN		18
 
@@ -284,6 +285,8 @@ struct xgbe_sfp_eeprom {
 #define XGBE_BEL_FUSE_VENDOR	"BEL-FUSE        "
 #define XGBE_BEL_FUSE_PARTNO	"1GBT-SFP06      "
 
+#define XGBE_MOLEX_VENDOR	"Molex Inc.      "
+
 struct xgbe_sfp_ascii {
 	union {
 		char vendor[XGBE_SFP_BASE_VENDOR_NAME_LEN + 1];
@@ -834,7 +837,11 @@ static bool xgbe_phy_sfp_bit_rate(struct xgbe_sfp_eeprom *sfp_eeprom,
 		break;
 	case XGBE_SFP_SPEED_10000:
 		min = XGBE_SFP_BASE_BR_10GBE_MIN;
-		max = XGBE_SFP_BASE_BR_10GBE_MAX;
+		if (memcmp(&sfp_eeprom->base[XGBE_SFP_BASE_VENDOR_NAME],
+			   XGBE_MOLEX_VENDOR, XGBE_SFP_BASE_VENDOR_NAME_LEN) == 0)
+			max = XGBE_MOLEX_SFP_BASE_BR_10GBE_MAX;
+		else
+			max = XGBE_SFP_BASE_BR_10GBE_MAX;
 		break;
 	default:
 		return false;
@@ -1151,7 +1158,10 @@ static void xgbe_phy_sfp_parse_eeprom(struct xgbe_prv_data *pdata)
 	}
 
 	/* Determine the type of SFP */
-	if (sfp_base[XGBE_SFP_BASE_10GBE_CC] & XGBE_SFP_BASE_10GBE_CC_SR)
+	if (phy_data->sfp_cable == XGBE_SFP_CABLE_PASSIVE &&
+	    xgbe_phy_sfp_bit_rate(sfp_eeprom, XGBE_SFP_SPEED_10000))
+		phy_data->sfp_base = XGBE_SFP_BASE_10000_CR;
+	else if (sfp_base[XGBE_SFP_BASE_10GBE_CC] & XGBE_SFP_BASE_10GBE_CC_SR)
 		phy_data->sfp_base = XGBE_SFP_BASE_10000_SR;
 	else if (sfp_base[XGBE_SFP_BASE_10GBE_CC] & XGBE_SFP_BASE_10GBE_CC_LR)
 		phy_data->sfp_base = XGBE_SFP_BASE_10000_LR;
@@ -1167,9 +1177,6 @@ static void xgbe_phy_sfp_parse_eeprom(struct xgbe_prv_data *pdata)
 		phy_data->sfp_base = XGBE_SFP_BASE_1000_CX;
 	else if (sfp_base[XGBE_SFP_BASE_1GBE_CC] & XGBE_SFP_BASE_1GBE_CC_T)
 		phy_data->sfp_base = XGBE_SFP_BASE_1000_T;
-	else if ((phy_data->sfp_cable == XGBE_SFP_CABLE_PASSIVE) &&
-		 xgbe_phy_sfp_bit_rate(sfp_eeprom, XGBE_SFP_SPEED_10000))
-		phy_data->sfp_base = XGBE_SFP_BASE_10000_CR;
 
 	switch (phy_data->sfp_base) {
 	case XGBE_SFP_BASE_1000_T:
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c b/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
index 4a6dfac857ca..7c6e0811f2e6 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
@@ -1451,26 +1451,57 @@ static void aq_check_txsa_expiration(struct aq_nic_s *nic)
 			egress_sa_threshold_expired);
 }
 
+#define AQ_LOCKED_MDO_DEF(mdo)						\
+static int aq_locked_mdo_##mdo(struct macsec_context *ctx)		\
+{									\
+	struct aq_nic_s *nic = netdev_priv(ctx->netdev);		\
+	int ret;							\
+	mutex_lock(&nic->macsec_mutex);					\
+	ret = aq_mdo_##mdo(ctx);					\
+	mutex_unlock(&nic->macsec_mutex);				\
+	return ret;							\
+}
+
+AQ_LOCKED_MDO_DEF(dev_open)
+AQ_LOCKED_MDO_DEF(dev_stop)
+AQ_LOCKED_MDO_DEF(add_secy)
+AQ_LOCKED_MDO_DEF(upd_secy)
+AQ_LOCKED_MDO_DEF(del_secy)
+AQ_LOCKED_MDO_DEF(add_rxsc)
+AQ_LOCKED_MDO_DEF(upd_rxsc)
+AQ_LOCKED_MDO_DEF(del_rxsc)
+AQ_LOCKED_MDO_DEF(add_rxsa)
+AQ_LOCKED_MDO_DEF(upd_rxsa)
+AQ_LOCKED_MDO_DEF(del_rxsa)
+AQ_LOCKED_MDO_DEF(add_txsa)
+AQ_LOCKED_MDO_DEF(upd_txsa)
+AQ_LOCKED_MDO_DEF(del_txsa)
+AQ_LOCKED_MDO_DEF(get_dev_stats)
+AQ_LOCKED_MDO_DEF(get_tx_sc_stats)
+AQ_LOCKED_MDO_DEF(get_tx_sa_stats)
+AQ_LOCKED_MDO_DEF(get_rx_sc_stats)
+AQ_LOCKED_MDO_DEF(get_rx_sa_stats)
+
 const struct macsec_ops aq_macsec_ops = {
-	.mdo_dev_open = aq_mdo_dev_open,
-	.mdo_dev_stop = aq_mdo_dev_stop,
-	.mdo_add_secy = aq_mdo_add_secy,
-	.mdo_upd_secy = aq_mdo_upd_secy,
-	.mdo_del_secy = aq_mdo_del_secy,
-	.mdo_add_rxsc = aq_mdo_add_rxsc,
-	.mdo_upd_rxsc = aq_mdo_upd_rxsc,
-	.mdo_del_rxsc = aq_mdo_del_rxsc,
-	.mdo_add_rxsa = aq_mdo_add_rxsa,
-	.mdo_upd_rxsa = aq_mdo_upd_rxsa,
-	.mdo_del_rxsa = aq_mdo_del_rxsa,
-	.mdo_add_txsa = aq_mdo_add_txsa,
-	.mdo_upd_txsa = aq_mdo_upd_txsa,
-	.mdo_del_txsa = aq_mdo_del_txsa,
-	.mdo_get_dev_stats = aq_mdo_get_dev_stats,
-	.mdo_get_tx_sc_stats = aq_mdo_get_tx_sc_stats,
-	.mdo_get_tx_sa_stats = aq_mdo_get_tx_sa_stats,
-	.mdo_get_rx_sc_stats = aq_mdo_get_rx_sc_stats,
-	.mdo_get_rx_sa_stats = aq_mdo_get_rx_sa_stats,
+	.mdo_dev_open = aq_locked_mdo_dev_open,
+	.mdo_dev_stop = aq_locked_mdo_dev_stop,
+	.mdo_add_secy = aq_locked_mdo_add_secy,
+	.mdo_upd_secy = aq_locked_mdo_upd_secy,
+	.mdo_del_secy = aq_locked_mdo_del_secy,
+	.mdo_add_rxsc = aq_locked_mdo_add_rxsc,
+	.mdo_upd_rxsc = aq_locked_mdo_upd_rxsc,
+	.mdo_del_rxsc = aq_locked_mdo_del_rxsc,
+	.mdo_add_rxsa = aq_locked_mdo_add_rxsa,
+	.mdo_upd_rxsa = aq_locked_mdo_upd_rxsa,
+	.mdo_del_rxsa = aq_locked_mdo_del_rxsa,
+	.mdo_add_txsa = aq_locked_mdo_add_txsa,
+	.mdo_upd_txsa = aq_locked_mdo_upd_txsa,
+	.mdo_del_txsa = aq_locked_mdo_del_txsa,
+	.mdo_get_dev_stats = aq_locked_mdo_get_dev_stats,
+	.mdo_get_tx_sc_stats = aq_locked_mdo_get_tx_sc_stats,
+	.mdo_get_tx_sa_stats = aq_locked_mdo_get_tx_sa_stats,
+	.mdo_get_rx_sc_stats = aq_locked_mdo_get_rx_sc_stats,
+	.mdo_get_rx_sa_stats = aq_locked_mdo_get_rx_sa_stats,
 };
 
 int aq_macsec_init(struct aq_nic_s *nic)
@@ -1492,6 +1523,7 @@ int aq_macsec_init(struct aq_nic_s *nic)
 
 	nic->ndev->features |= NETIF_F_HW_MACSEC;
 	nic->ndev->macsec_ops = &aq_macsec_ops;
+	mutex_init(&nic->macsec_mutex);
 
 	return 0;
 }
@@ -1515,7 +1547,7 @@ int aq_macsec_enable(struct aq_nic_s *nic)
 	if (!nic->macsec_cfg)
 		return 0;
 
-	rtnl_lock();
+	mutex_lock(&nic->macsec_mutex);
 
 	if (nic->aq_fw_ops->send_macsec_req) {
 		struct macsec_cfg_request cfg = { 0 };
@@ -1564,7 +1596,7 @@ int aq_macsec_enable(struct aq_nic_s *nic)
 	ret = aq_apply_macsec_cfg(nic);
 
 unlock:
-	rtnl_unlock();
+	mutex_unlock(&nic->macsec_mutex);
 	return ret;
 }
 
@@ -1576,9 +1608,9 @@ void aq_macsec_work(struct aq_nic_s *nic)
 	if (!netif_carrier_ok(nic->ndev))
 		return;
 
-	rtnl_lock();
+	mutex_lock(&nic->macsec_mutex);
 	aq_check_txsa_expiration(nic);
-	rtnl_unlock();
+	mutex_unlock(&nic->macsec_mutex);
 }
 
 int aq_macsec_rx_sa_cnt(struct aq_nic_s *nic)
@@ -1589,21 +1621,30 @@ int aq_macsec_rx_sa_cnt(struct aq_nic_s *nic)
 	if (!cfg)
 		return 0;
 
+	mutex_lock(&nic->macsec_mutex);
+
 	for (i = 0; i < AQ_MACSEC_MAX_SC; i++) {
 		if (!test_bit(i, &cfg->rxsc_idx_busy))
 			continue;
 		cnt += hweight_long(cfg->aq_rxsc[i].rx_sa_idx_busy);
 	}
 
+	mutex_unlock(&nic->macsec_mutex);
 	return cnt;
 }
 
 int aq_macsec_tx_sc_cnt(struct aq_nic_s *nic)
 {
+	int cnt;
+
 	if (!nic->macsec_cfg)
 		return 0;
 
-	return hweight_long(nic->macsec_cfg->txsc_idx_busy);
+	mutex_lock(&nic->macsec_mutex);
+	cnt = hweight_long(nic->macsec_cfg->txsc_idx_busy);
+	mutex_unlock(&nic->macsec_mutex);
+
+	return cnt;
 }
 
 int aq_macsec_tx_sa_cnt(struct aq_nic_s *nic)
@@ -1614,12 +1655,15 @@ int aq_macsec_tx_sa_cnt(struct aq_nic_s *nic)
 	if (!cfg)
 		return 0;
 
+	mutex_lock(&nic->macsec_mutex);
+
 	for (i = 0; i < AQ_MACSEC_MAX_SC; i++) {
 		if (!test_bit(i, &cfg->txsc_idx_busy))
 			continue;
 		cnt += hweight_long(cfg->aq_txsc[i].tx_sa_idx_busy);
 	}
 
+	mutex_unlock(&nic->macsec_mutex);
 	return cnt;
 }
 
@@ -1691,6 +1735,8 @@ u64 *aq_macsec_get_stats(struct aq_nic_s *nic, u64 *data)
 	if (!cfg)
 		return data;
 
+	mutex_lock(&nic->macsec_mutex);
+
 	aq_macsec_update_stats(nic);
 
 	common_stats = &cfg->stats;
@@ -1773,5 +1819,7 @@ u64 *aq_macsec_get_stats(struct aq_nic_s *nic, u64 *data)
 
 	data += i;
 
+	mutex_unlock(&nic->macsec_mutex);
+
 	return data;
 }
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h b/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
index 926cca9a0c83..6da3efa289a3 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
@@ -152,6 +152,8 @@ struct aq_nic_s {
 	struct mutex fwreq_mutex;
 #if IS_ENABLED(CONFIG_MACSEC)
 	struct aq_macsec_cfg *macsec_cfg;
+	/* mutex to protect data in macsec_cfg */
+	struct mutex macsec_mutex;
 #endif
 	/* PTP support */
 	struct aq_ptp_s *aq_ptp;
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 4af253825957..ca62c72eb772 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1241,7 +1241,12 @@ static void enetc_setup_rxbdr(struct enetc_hw *hw, struct enetc_bdr *rx_ring)
 
 	enetc_rxbdr_wr(hw, idx, ENETC_RBBSR, ENETC_RXB_DMA_SIZE);
 
+	/* Also prepare the consumer index in case page allocation never
+	 * succeeds. In that case, hardware will never advance producer index
+	 * to match consumer index, and will drop all frames.
+	 */
 	enetc_rxbdr_wr(hw, idx, ENETC_RBPIR, 0);
+	enetc_rxbdr_wr(hw, idx, ENETC_RBCIR, 1);
 
 	/* enable Rx ints by setting pkt thr to 1 */
 	enetc_rxbdr_wr(hw, idx, ENETC_RBICR0, ENETC_RBICR0_ICEN | 0x1);
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index d8bdaf2e5365..e183caf38176 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -2251,6 +2251,31 @@ static u32 fec_enet_register_offset[] = {
 	IEEE_R_DROP, IEEE_R_FRAME_OK, IEEE_R_CRC, IEEE_R_ALIGN, IEEE_R_MACERR,
 	IEEE_R_FDXFC, IEEE_R_OCTETS_OK
 };
+/* for i.MX6ul */
+static u32 fec_enet_register_offset_6ul[] = {
+	FEC_IEVENT, FEC_IMASK, FEC_R_DES_ACTIVE_0, FEC_X_DES_ACTIVE_0,
+	FEC_ECNTRL, FEC_MII_DATA, FEC_MII_SPEED, FEC_MIB_CTRLSTAT, FEC_R_CNTRL,
+	FEC_X_CNTRL, FEC_ADDR_LOW, FEC_ADDR_HIGH, FEC_OPD, FEC_TXIC0, FEC_RXIC0,
+	FEC_HASH_TABLE_HIGH, FEC_HASH_TABLE_LOW, FEC_GRP_HASH_TABLE_HIGH,
+	FEC_GRP_HASH_TABLE_LOW, FEC_X_WMRK, FEC_R_DES_START_0,
+	FEC_X_DES_START_0, FEC_R_BUFF_SIZE_0, FEC_R_FIFO_RSFL, FEC_R_FIFO_RSEM,
+	FEC_R_FIFO_RAEM, FEC_R_FIFO_RAFL, FEC_RACC,
+	RMON_T_DROP, RMON_T_PACKETS, RMON_T_BC_PKT, RMON_T_MC_PKT,
+	RMON_T_CRC_ALIGN, RMON_T_UNDERSIZE, RMON_T_OVERSIZE, RMON_T_FRAG,
+	RMON_T_JAB, RMON_T_COL, RMON_T_P64, RMON_T_P65TO127, RMON_T_P128TO255,
+	RMON_T_P256TO511, RMON_T_P512TO1023, RMON_T_P1024TO2047,
+	RMON_T_P_GTE2048, RMON_T_OCTETS,
+	IEEE_T_DROP, IEEE_T_FRAME_OK, IEEE_T_1COL, IEEE_T_MCOL, IEEE_T_DEF,
+	IEEE_T_LCOL, IEEE_T_EXCOL, IEEE_T_MACERR, IEEE_T_CSERR, IEEE_T_SQE,
+	IEEE_T_FDXFC, IEEE_T_OCTETS_OK,
+	RMON_R_PACKETS, RMON_R_BC_PKT, RMON_R_MC_PKT, RMON_R_CRC_ALIGN,
+	RMON_R_UNDERSIZE, RMON_R_OVERSIZE, RMON_R_FRAG, RMON_R_JAB,
+	RMON_R_RESVD_O, RMON_R_P64, RMON_R_P65TO127, RMON_R_P128TO255,
+	RMON_R_P256TO511, RMON_R_P512TO1023, RMON_R_P1024TO2047,
+	RMON_R_P_GTE2048, RMON_R_OCTETS,
+	IEEE_R_DROP, IEEE_R_FRAME_OK, IEEE_R_CRC, IEEE_R_ALIGN, IEEE_R_MACERR,
+	IEEE_R_FDXFC, IEEE_R_OCTETS_OK
+};
 #else
 static __u32 fec_enet_register_version = 1;
 static u32 fec_enet_register_offset[] = {
@@ -2275,7 +2300,24 @@ static void fec_enet_get_regs(struct net_device *ndev,
 	u32 *buf = (u32 *)regbuf;
 	u32 i, off;
 	int ret;
+#if defined(CONFIG_M523x) || defined(CONFIG_M527x) || defined(CONFIG_M528x) || \
+	defined(CONFIG_M520x) || defined(CONFIG_M532x) || defined(CONFIG_ARM) || \
+	defined(CONFIG_ARM64) || defined(CONFIG_COMPILE_TEST)
+	u32 *reg_list;
+	u32 reg_cnt;
 
+	if (!of_machine_is_compatible("fsl,imx6ul")) {
+		reg_list = fec_enet_register_offset;
+		reg_cnt = ARRAY_SIZE(fec_enet_register_offset);
+	} else {
+		reg_list = fec_enet_register_offset_6ul;
+		reg_cnt = ARRAY_SIZE(fec_enet_register_offset_6ul);
+	}
+#else
+	/* coldfire */
+	static u32 *reg_list = fec_enet_register_offset;
+	static const u32 reg_cnt = ARRAY_SIZE(fec_enet_register_offset);
+#endif
 	ret = pm_runtime_resume_and_get(dev);
 	if (ret < 0)
 		return;
@@ -2284,8 +2326,8 @@ static void fec_enet_get_regs(struct net_device *ndev,
 
 	memset(buf, 0, regs->len);
 
-	for (i = 0; i < ARRAY_SIZE(fec_enet_register_offset); i++) {
-		off = fec_enet_register_offset[i];
+	for (i = 0; i < reg_cnt; i++) {
+		off = reg_list[i];
 
 		if ((off == FEC_R_BOUND || off == FEC_R_FSTART) &&
 		    !(fep->quirks & FEC_QUIRK_HAS_FRREG))
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_debugfs.c b/drivers/net/ethernet/huawei/hinic/hinic_debugfs.c
index 19eb839177ec..061952c6c21a 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_debugfs.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_debugfs.c
@@ -85,6 +85,7 @@ static int hinic_dbg_get_func_table(struct hinic_dev *nic_dev, int idx)
 	struct tag_sml_funcfg_tbl *funcfg_table_elem;
 	struct hinic_cmd_lt_rd *read_data;
 	u16 out_size = sizeof(*read_data);
+	int ret = ~0;
 	int err;
 
 	read_data = kzalloc(sizeof(*read_data), GFP_KERNEL);
@@ -111,20 +112,25 @@ static int hinic_dbg_get_func_table(struct hinic_dev *nic_dev, int idx)
 
 	switch (idx) {
 	case VALID:
-		return funcfg_table_elem->dw0.bs.valid;
+		ret = funcfg_table_elem->dw0.bs.valid;
+		break;
 	case RX_MODE:
-		return funcfg_table_elem->dw0.bs.nic_rx_mode;
+		ret = funcfg_table_elem->dw0.bs.nic_rx_mode;
+		break;
 	case MTU:
-		return funcfg_table_elem->dw1.bs.mtu;
+		ret = funcfg_table_elem->dw1.bs.mtu;
+		break;
 	case RQ_DEPTH:
-		return funcfg_table_elem->dw13.bs.cfg_rq_depth;
+		ret = funcfg_table_elem->dw13.bs.cfg_rq_depth;
+		break;
 	case QUEUE_NUM:
-		return funcfg_table_elem->dw13.bs.cfg_q_num;
+		ret = funcfg_table_elem->dw13.bs.cfg_q_num;
+		break;
 	}
 
 	kfree(read_data);
 
-	return ~0;
+	return ret;
 }
 
 static ssize_t hinic_dbg_cmd_read(struct file *filp, char __user *buffer, size_t count,
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c
index 21b8235952d3..dff979f5d08b 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c
@@ -929,7 +929,7 @@ int hinic_init_cmdqs(struct hinic_cmdqs *cmdqs, struct hinic_hwif *hwif,
 
 err_set_cmdq_depth:
 	hinic_ceq_unregister_cb(&func_to_io->ceqs, HINIC_CEQ_CMDQ);
-
+	free_cmdq(&cmdqs->cmdq[HINIC_CMDQ_SYNC]);
 err_cmdq_ctxt:
 	hinic_wqs_cmdq_free(&cmdqs->cmdq_pages, cmdqs->saved_wqs,
 			    HINIC_MAX_CMDQ_TYPES);
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
index 799b85c88eff..bcf2476512a5 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
@@ -892,7 +892,7 @@ int hinic_set_interrupt_cfg(struct hinic_hwdev *hwdev,
 	if (err)
 		return -EINVAL;
 
-	interrupt_info->lli_credit_cnt = temp_info.lli_timer_cnt;
+	interrupt_info->lli_credit_cnt = temp_info.lli_credit_cnt;
 	interrupt_info->lli_timer_cnt = temp_info.lli_timer_cnt;
 
 	err = hinic_msg_to_mgmt(&pfhwdev->pf_to_mgmt, HINIC_MOD_COMM,
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_sriov.c b/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
index f8a26459ff65..4d82ebfe27f9 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
@@ -1178,7 +1178,6 @@ int hinic_vf_func_init(struct hinic_hwdev *hwdev)
 			dev_err(&hwdev->hwif->pdev->dev,
 				"Failed to register VF, err: %d, status: 0x%x, out size: 0x%x\n",
 				err, register_info.status, out_size);
-			hinic_unregister_vf_mbox_cb(hwdev, HINIC_MOD_L2NIC);
 			return -EIO;
 		}
 	} else {
diff --git a/drivers/net/ethernet/ibm/ehea/ehea_main.c b/drivers/net/ethernet/ibm/ehea/ehea_main.c
index f63066736425..28a5f8d73a61 100644
--- a/drivers/net/ethernet/ibm/ehea/ehea_main.c
+++ b/drivers/net/ethernet/ibm/ehea/ehea_main.c
@@ -2897,6 +2897,7 @@ static struct device *ehea_register_port(struct ehea_port *port,
 	ret = of_device_register(&port->ofdev);
 	if (ret) {
 		pr_err("failed to register device. ret=%d\n", ret);
+		put_device(&port->ofdev.dev);
 		goto out;
 	}
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index cc5f5c237774..144c4824b5e8 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -3083,10 +3083,17 @@ static int i40e_get_rss_hash_opts(struct i40e_pf *pf, struct ethtool_rxnfc *cmd)
 
 		if (cmd->flow_type == TCP_V4_FLOW ||
 		    cmd->flow_type == UDP_V4_FLOW) {
-			if (i_set & I40E_L3_SRC_MASK)
-				cmd->data |= RXH_IP_SRC;
-			if (i_set & I40E_L3_DST_MASK)
-				cmd->data |= RXH_IP_DST;
+			if (hw->mac.type == I40E_MAC_X722) {
+				if (i_set & I40E_X722_L3_SRC_MASK)
+					cmd->data |= RXH_IP_SRC;
+				if (i_set & I40E_X722_L3_DST_MASK)
+					cmd->data |= RXH_IP_DST;
+			} else {
+				if (i_set & I40E_L3_SRC_MASK)
+					cmd->data |= RXH_IP_SRC;
+				if (i_set & I40E_L3_DST_MASK)
+					cmd->data |= RXH_IP_DST;
+			}
 		} else if (cmd->flow_type == TCP_V6_FLOW ||
 			  cmd->flow_type == UDP_V6_FLOW) {
 			if (i_set & I40E_L3_V6_SRC_MASK)
@@ -3393,12 +3400,15 @@ static int i40e_get_rxnfc(struct net_device *netdev, struct ethtool_rxnfc *cmd,
 
 /**
  * i40e_get_rss_hash_bits - Read RSS Hash bits from register
+ * @hw: hw structure
  * @nfc: pointer to user request
  * @i_setc: bits currently set
  *
  * Returns value of bits to be set per user request
  **/
-static u64 i40e_get_rss_hash_bits(struct ethtool_rxnfc *nfc, u64 i_setc)
+static u64 i40e_get_rss_hash_bits(struct i40e_hw *hw,
+				  struct ethtool_rxnfc *nfc,
+				  u64 i_setc)
 {
 	u64 i_set = i_setc;
 	u64 src_l3 = 0, dst_l3 = 0;
@@ -3417,8 +3427,13 @@ static u64 i40e_get_rss_hash_bits(struct ethtool_rxnfc *nfc, u64 i_setc)
 		dst_l3 = I40E_L3_V6_DST_MASK;
 	} else if (nfc->flow_type == TCP_V4_FLOW ||
 		  nfc->flow_type == UDP_V4_FLOW) {
-		src_l3 = I40E_L3_SRC_MASK;
-		dst_l3 = I40E_L3_DST_MASK;
+		if (hw->mac.type == I40E_MAC_X722) {
+			src_l3 = I40E_X722_L3_SRC_MASK;
+			dst_l3 = I40E_X722_L3_DST_MASK;
+		} else {
+			src_l3 = I40E_L3_SRC_MASK;
+			dst_l3 = I40E_L3_DST_MASK;
+		}
 	} else {
 		/* Any other flow type are not supported here */
 		return i_set;
@@ -3436,6 +3451,7 @@ static u64 i40e_get_rss_hash_bits(struct ethtool_rxnfc *nfc, u64 i_setc)
 	return i_set;
 }
 
+#define FLOW_PCTYPES_SIZE 64
 /**
  * i40e_set_rss_hash_opt - Enable/Disable flow types for RSS hash
  * @pf: pointer to the physical function struct
@@ -3448,9 +3464,11 @@ static int i40e_set_rss_hash_opt(struct i40e_pf *pf, struct ethtool_rxnfc *nfc)
 	struct i40e_hw *hw = &pf->hw;
 	u64 hena = (u64)i40e_read_rx_ctl(hw, I40E_PFQF_HENA(0)) |
 		   ((u64)i40e_read_rx_ctl(hw, I40E_PFQF_HENA(1)) << 32);
-	u8 flow_pctype = 0;
+	DECLARE_BITMAP(flow_pctypes, FLOW_PCTYPES_SIZE);
 	u64 i_set, i_setc;
 
+	bitmap_zero(flow_pctypes, FLOW_PCTYPES_SIZE);
+
 	if (pf->flags & I40E_FLAG_MFP_ENABLED) {
 		dev_err(&pf->pdev->dev,
 			"Change of RSS hash input set is not supported when MFP mode is enabled\n");
@@ -3466,36 +3484,35 @@ static int i40e_set_rss_hash_opt(struct i40e_pf *pf, struct ethtool_rxnfc *nfc)
 
 	switch (nfc->flow_type) {
 	case TCP_V4_FLOW:
-		flow_pctype = I40E_FILTER_PCTYPE_NONF_IPV4_TCP;
+		set_bit(I40E_FILTER_PCTYPE_NONF_IPV4_TCP, flow_pctypes);
 		if (pf->hw_features & I40E_HW_MULTIPLE_TCP_UDP_RSS_PCTYPE)
-			hena |=
-			  BIT_ULL(I40E_FILTER_PCTYPE_NONF_IPV4_TCP_SYN_NO_ACK);
+			set_bit(I40E_FILTER_PCTYPE_NONF_IPV4_TCP_SYN_NO_ACK,
+				flow_pctypes);
 		break;
 	case TCP_V6_FLOW:
-		flow_pctype = I40E_FILTER_PCTYPE_NONF_IPV6_TCP;
-		if (pf->hw_features & I40E_HW_MULTIPLE_TCP_UDP_RSS_PCTYPE)
-			hena |=
-			  BIT_ULL(I40E_FILTER_PCTYPE_NONF_IPV4_TCP_SYN_NO_ACK);
+		set_bit(I40E_FILTER_PCTYPE_NONF_IPV6_TCP, flow_pctypes);
 		if (pf->hw_features & I40E_HW_MULTIPLE_TCP_UDP_RSS_PCTYPE)
-			hena |=
-			  BIT_ULL(I40E_FILTER_PCTYPE_NONF_IPV6_TCP_SYN_NO_ACK);
+			set_bit(I40E_FILTER_PCTYPE_NONF_IPV6_TCP_SYN_NO_ACK,
+				flow_pctypes);
 		break;
 	case UDP_V4_FLOW:
-		flow_pctype = I40E_FILTER_PCTYPE_NONF_IPV4_UDP;
-		if (pf->hw_features & I40E_HW_MULTIPLE_TCP_UDP_RSS_PCTYPE)
-			hena |=
-			  BIT_ULL(I40E_FILTER_PCTYPE_NONF_UNICAST_IPV4_UDP) |
-			  BIT_ULL(I40E_FILTER_PCTYPE_NONF_MULTICAST_IPV4_UDP);
-
+		set_bit(I40E_FILTER_PCTYPE_NONF_IPV4_UDP, flow_pctypes);
+		if (pf->hw_features & I40E_HW_MULTIPLE_TCP_UDP_RSS_PCTYPE) {
+			set_bit(I40E_FILTER_PCTYPE_NONF_UNICAST_IPV4_UDP,
+				flow_pctypes);
+			set_bit(I40E_FILTER_PCTYPE_NONF_MULTICAST_IPV4_UDP,
+				flow_pctypes);
+		}
 		hena |= BIT_ULL(I40E_FILTER_PCTYPE_FRAG_IPV4);
 		break;
 	case UDP_V6_FLOW:
-		flow_pctype = I40E_FILTER_PCTYPE_NONF_IPV6_UDP;
-		if (pf->hw_features & I40E_HW_MULTIPLE_TCP_UDP_RSS_PCTYPE)
-			hena |=
-			  BIT_ULL(I40E_FILTER_PCTYPE_NONF_UNICAST_IPV6_UDP) |
-			  BIT_ULL(I40E_FILTER_PCTYPE_NONF_MULTICAST_IPV6_UDP);
-
+		set_bit(I40E_FILTER_PCTYPE_NONF_IPV6_UDP, flow_pctypes);
+		if (pf->hw_features & I40E_HW_MULTIPLE_TCP_UDP_RSS_PCTYPE) {
+			set_bit(I40E_FILTER_PCTYPE_NONF_UNICAST_IPV6_UDP,
+				flow_pctypes);
+			set_bit(I40E_FILTER_PCTYPE_NONF_MULTICAST_IPV6_UDP,
+				flow_pctypes);
+		}
 		hena |= BIT_ULL(I40E_FILTER_PCTYPE_FRAG_IPV6);
 		break;
 	case AH_ESP_V4_FLOW:
@@ -3528,17 +3545,20 @@ static int i40e_set_rss_hash_opt(struct i40e_pf *pf, struct ethtool_rxnfc *nfc)
 		return -EINVAL;
 	}
 
-	if (flow_pctype) {
-		i_setc = (u64)i40e_read_rx_ctl(hw, I40E_GLQF_HASH_INSET(0,
-					       flow_pctype)) |
-			((u64)i40e_read_rx_ctl(hw, I40E_GLQF_HASH_INSET(1,
-					       flow_pctype)) << 32);
-		i_set = i40e_get_rss_hash_bits(nfc, i_setc);
-		i40e_write_rx_ctl(hw, I40E_GLQF_HASH_INSET(0, flow_pctype),
-				  (u32)i_set);
-		i40e_write_rx_ctl(hw, I40E_GLQF_HASH_INSET(1, flow_pctype),
-				  (u32)(i_set >> 32));
-		hena |= BIT_ULL(flow_pctype);
+	if (bitmap_weight(flow_pctypes, FLOW_PCTYPES_SIZE)) {
+		u8 flow_id;
+
+		for_each_set_bit(flow_id, flow_pctypes, FLOW_PCTYPES_SIZE) {
+			i_setc = (u64)i40e_read_rx_ctl(hw, I40E_GLQF_HASH_INSET(0, flow_id)) |
+				 ((u64)i40e_read_rx_ctl(hw, I40E_GLQF_HASH_INSET(1, flow_id)) << 32);
+			i_set = i40e_get_rss_hash_bits(&pf->hw, nfc, i_setc);
+
+			i40e_write_rx_ctl(hw, I40E_GLQF_HASH_INSET(0, flow_id),
+					  (u32)i_set);
+			i40e_write_rx_ctl(hw, I40E_GLQF_HASH_INSET(1, flow_id),
+					  (u32)(i_set >> 32));
+			hena |= BIT_ULL(flow_id);
+		}
 	}
 
 	i40e_write_rx_ctl(hw, I40E_PFQF_HENA(0), (u32)hena);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_type.h b/drivers/net/ethernet/intel/i40e/i40e_type.h
index 446672a7e39f..0872448c0e80 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_type.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_type.h
@@ -1404,6 +1404,10 @@ struct i40e_lldp_variables {
 #define I40E_PFQF_CTL_0_HASHLUTSIZE_512	0x00010000
 
 /* INPUT SET MASK for RSS, flow director, and flexible payload */
+#define I40E_X722_L3_SRC_SHIFT		49
+#define I40E_X722_L3_SRC_MASK		(0x3ULL << I40E_X722_L3_SRC_SHIFT)
+#define I40E_X722_L3_DST_SHIFT		41
+#define I40E_X722_L3_DST_MASK		(0x3ULL << I40E_X722_L3_DST_SHIFT)
 #define I40E_L3_SRC_SHIFT		47
 #define I40E_L3_SRC_MASK		(0x3ULL << I40E_L3_SRC_SHIFT)
 #define I40E_L3_V6_SRC_SHIFT		43
diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index ffff7de801af..381b28a08746 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -1483,10 +1483,12 @@ bool i40e_reset_vf(struct i40e_vf *vf, bool flr)
 	if (test_bit(__I40E_VF_RESETS_DISABLED, pf->state))
 		return true;
 
-	/* If the VFs have been disabled, this means something else is
-	 * resetting the VF, so we shouldn't continue.
-	 */
-	if (test_and_set_bit(__I40E_VF_DISABLE, pf->state))
+	/* Bail out if VFs are disabled. */
+	if (test_bit(__I40E_VF_DISABLE, pf->state))
+		return true;
+
+	/* If VF is being reset already we don't need to continue. */
+	if (test_and_set_bit(I40E_VF_STATE_RESETTING, &vf->vf_states))
 		return true;
 
 	i40e_trigger_vf_reset(vf, flr);
@@ -1523,7 +1525,7 @@ bool i40e_reset_vf(struct i40e_vf *vf, bool flr)
 	i40e_cleanup_reset_vf(vf);
 
 	i40e_flush(hw);
-	clear_bit(__I40E_VF_DISABLE, pf->state);
+	clear_bit(I40E_VF_STATE_RESETTING, &vf->vf_states);
 
 	return true;
 }
@@ -1556,8 +1558,12 @@ bool i40e_reset_all_vfs(struct i40e_pf *pf, bool flr)
 		return false;
 
 	/* Begin reset on all VFs at once */
-	for (v = 0; v < pf->num_alloc_vfs; v++)
-		i40e_trigger_vf_reset(&pf->vf[v], flr);
+	for (v = 0; v < pf->num_alloc_vfs; v++) {
+		vf = &pf->vf[v];
+		/* If VF is being reset no need to trigger reset again */
+		if (!test_bit(I40E_VF_STATE_RESETTING, &vf->vf_states))
+			i40e_trigger_vf_reset(&pf->vf[v], flr);
+	}
 
 	/* HW requires some time to make sure it can flush the FIFO for a VF
 	 * when it resets it. Poll the VPGEN_VFRSTAT register for each VF in
@@ -1573,9 +1579,11 @@ bool i40e_reset_all_vfs(struct i40e_pf *pf, bool flr)
 		 */
 		while (v < pf->num_alloc_vfs) {
 			vf = &pf->vf[v];
-			reg = rd32(hw, I40E_VPGEN_VFRSTAT(vf->vf_id));
-			if (!(reg & I40E_VPGEN_VFRSTAT_VFRD_MASK))
-				break;
+			if (!test_bit(I40E_VF_STATE_RESETTING, &vf->vf_states)) {
+				reg = rd32(hw, I40E_VPGEN_VFRSTAT(vf->vf_id));
+				if (!(reg & I40E_VPGEN_VFRSTAT_VFRD_MASK))
+					break;
+			}
 
 			/* If the current VF has finished resetting, move on
 			 * to the next VF in sequence.
@@ -1603,6 +1611,10 @@ bool i40e_reset_all_vfs(struct i40e_pf *pf, bool flr)
 		if (pf->vf[v].lan_vsi_idx == 0)
 			continue;
 
+		/* If VF is reset in another thread just continue */
+		if (test_bit(I40E_VF_STATE_RESETTING, &vf->vf_states))
+			continue;
+
 		i40e_vsi_stop_rings_no_wait(pf->vsi[pf->vf[v].lan_vsi_idx]);
 	}
 
@@ -1614,6 +1626,10 @@ bool i40e_reset_all_vfs(struct i40e_pf *pf, bool flr)
 		if (pf->vf[v].lan_vsi_idx == 0)
 			continue;
 
+		/* If VF is reset in another thread just continue */
+		if (test_bit(I40E_VF_STATE_RESETTING, &vf->vf_states))
+			continue;
+
 		i40e_vsi_wait_queues_disabled(pf->vsi[pf->vf[v].lan_vsi_idx]);
 	}
 
@@ -1623,8 +1639,13 @@ bool i40e_reset_all_vfs(struct i40e_pf *pf, bool flr)
 	mdelay(50);
 
 	/* Finish the reset on each VF */
-	for (v = 0; v < pf->num_alloc_vfs; v++)
+	for (v = 0; v < pf->num_alloc_vfs; v++) {
+		/* If VF is reset in another thread just continue */
+		if (test_bit(I40E_VF_STATE_RESETTING, &vf->vf_states))
+			continue;
+
 		i40e_cleanup_reset_vf(&pf->vf[v]);
+	}
 
 	i40e_flush(hw);
 	clear_bit(__I40E_VF_DISABLE, pf->state);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h
index a554d0a0b09b..358bbdb58795 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h
@@ -39,6 +39,7 @@ enum i40e_vf_states {
 	I40E_VF_STATE_MC_PROMISC,
 	I40E_VF_STATE_UC_PROMISC,
 	I40E_VF_STATE_PRE_ENABLE,
+	I40E_VF_STATE_RESETTING
 };
 
 /* VF capabilities */
diff --git a/drivers/net/ethernet/lantiq_etop.c b/drivers/net/ethernet/lantiq_etop.c
index 2d0c52f7106b..5ea626b1e578 100644
--- a/drivers/net/ethernet/lantiq_etop.c
+++ b/drivers/net/ethernet/lantiq_etop.c
@@ -466,7 +466,6 @@ ltq_etop_tx(struct sk_buff *skb, struct net_device *dev)
 	len = skb->len < ETH_ZLEN ? ETH_ZLEN : skb->len;
 
 	if ((desc->ctl & (LTQ_DMA_OWN | LTQ_DMA_C)) || ch->skb[ch->dma.desc]) {
-		dev_kfree_skb_any(skb);
 		netdev_err(dev, "tx ring full\n");
 		netif_tx_stop_queue(txq);
 		return NETDEV_TX_BUSY;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 94426d29025e..6612b2c0be48 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -1853,7 +1853,7 @@ void mlx5_cmd_init_async_ctx(struct mlx5_core_dev *dev,
 	ctx->dev = dev;
 	/* Starts at 1 to avoid doing wake_up if we are not cleaning up */
 	atomic_set(&ctx->num_inflight, 1);
-	init_waitqueue_head(&ctx->wait);
+	init_completion(&ctx->inflight_done);
 }
 EXPORT_SYMBOL(mlx5_cmd_init_async_ctx);
 
@@ -1867,8 +1867,8 @@ EXPORT_SYMBOL(mlx5_cmd_init_async_ctx);
  */
 void mlx5_cmd_cleanup_async_ctx(struct mlx5_async_ctx *ctx)
 {
-	atomic_dec(&ctx->num_inflight);
-	wait_event(ctx->wait, atomic_read(&ctx->num_inflight) == 0);
+	if (!atomic_dec_and_test(&ctx->num_inflight))
+		wait_for_completion(&ctx->inflight_done);
 }
 EXPORT_SYMBOL(mlx5_cmd_cleanup_async_ctx);
 
@@ -1879,7 +1879,7 @@ static void mlx5_cmd_exec_cb_handler(int status, void *_work)
 
 	work->user_callback(status, work);
 	if (atomic_dec_and_test(&ctx->num_inflight))
-		wake_up(&ctx->wait);
+		complete(&ctx->inflight_done);
 }
 
 int mlx5_cmd_exec_cb(struct mlx5_async_ctx *ctx, void *in, int in_size,
@@ -1895,7 +1895,7 @@ int mlx5_cmd_exec_cb(struct mlx5_async_ctx *ctx, void *in, int in_size,
 	ret = cmd_exec(ctx->dev, in, in_size, out, out_size,
 		       mlx5_cmd_exec_cb_handler, work, false);
 	if (ret && atomic_dec_and_test(&ctx->num_inflight))
-		wake_up(&ctx->wait);
+		complete(&ctx->inflight_done);
 
 	return ret;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 26f7fab109d9..d08bd22dc569 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -113,7 +113,6 @@ static bool mlx5e_ipsec_update_esn_state(struct mlx5e_ipsec_sa_entry *sa_entry)
 	struct xfrm_replay_state_esn *replay_esn;
 	u32 seq_bottom = 0;
 	u8 overlap;
-	u32 *esn;
 
 	if (!(sa_entry->x->props.flags & XFRM_STATE_ESN)) {
 		sa_entry->esn_state.trigger = 0;
@@ -128,11 +127,9 @@ static bool mlx5e_ipsec_update_esn_state(struct mlx5e_ipsec_sa_entry *sa_entry)
 
 	sa_entry->esn_state.esn = xfrm_replay_seqhi(sa_entry->x,
 						    htonl(seq_bottom));
-	esn = &sa_entry->esn_state.esn;
 
 	sa_entry->esn_state.trigger = 1;
 	if (unlikely(overlap && seq_bottom < MLX5E_IPSEC_ESN_SCOPE_MID)) {
-		++(*esn);
 		sa_entry->esn_state.overlap = 0;
 		return true;
 	} else if (unlikely(!overlap &&
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/mpfs.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/mpfs.c
index 839a01da110f..8ff16318e32d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/mpfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/mpfs.c
@@ -122,7 +122,7 @@ void mlx5_mpfs_cleanup(struct mlx5_core_dev *dev)
 {
 	struct mlx5_mpfs *mpfs = dev->priv.mpfs;
 
-	if (!MLX5_ESWITCH_MANAGER(dev))
+	if (!mpfs)
 		return;
 
 	WARN_ON(!hlist_empty(mpfs->hash));
@@ -137,7 +137,7 @@ int mlx5_mpfs_add_mac(struct mlx5_core_dev *dev, u8 *mac)
 	int err = 0;
 	u32 index;
 
-	if (!MLX5_ESWITCH_MANAGER(dev))
+	if (!mpfs)
 		return 0;
 
 	mutex_lock(&mpfs->lock);
@@ -185,7 +185,7 @@ int mlx5_mpfs_del_mac(struct mlx5_core_dev *dev, u8 *mac)
 	int err = 0;
 	u32 index;
 
-	if (!MLX5_ESWITCH_MANAGER(dev))
+	if (!mpfs)
 		return 0;
 
 	mutex_lock(&mpfs->lock);
diff --git a/drivers/net/ethernet/micrel/ksz884x.c b/drivers/net/ethernet/micrel/ksz884x.c
index 9ed264ed7070..1fa16064142d 100644
--- a/drivers/net/ethernet/micrel/ksz884x.c
+++ b/drivers/net/ethernet/micrel/ksz884x.c
@@ -6923,7 +6923,7 @@ static int pcidev_init(struct pci_dev *pdev, const struct pci_device_id *id)
 	char banner[sizeof(version)];
 	struct ksz_switch *sw = NULL;
 
-	result = pci_enable_device(pdev);
+	result = pcim_enable_device(pdev);
 	if (result)
 		return result;
 
diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index ef3634d1b9f7..b9acee214bb6 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -1958,11 +1958,13 @@ static int netsec_register_mdio(struct netsec_priv *priv, u32 phy_addr)
 			ret = PTR_ERR(priv->phydev);
 			dev_err(priv->dev, "get_phy_device err(%d)\n", ret);
 			priv->phydev = NULL;
+			mdiobus_unregister(bus);
 			return -ENODEV;
 		}
 
 		ret = phy_device_register(priv->phydev);
 		if (ret) {
+			phy_device_free(priv->phydev);
 			mdiobus_unregister(bus);
 			dev_err(priv->dev,
 				"phy_device_register err(%d)\n", ret);
diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index d0407f44de78..61b9dc511d90 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -3262,11 +3262,34 @@ struct fc_function_template qla2xxx_transport_vport_functions = {
 	.bsg_timeout = qla24xx_bsg_timeout,
 };
 
+static uint
+qla2x00_get_host_supported_speeds(scsi_qla_host_t *vha, uint speeds)
+{
+	uint supported_speeds = FC_PORTSPEED_UNKNOWN;
+
+	if (speeds & FDMI_PORT_SPEED_64GB)
+		supported_speeds |= FC_PORTSPEED_64GBIT;
+	if (speeds & FDMI_PORT_SPEED_32GB)
+		supported_speeds |= FC_PORTSPEED_32GBIT;
+	if (speeds & FDMI_PORT_SPEED_16GB)
+		supported_speeds |= FC_PORTSPEED_16GBIT;
+	if (speeds & FDMI_PORT_SPEED_8GB)
+		supported_speeds |= FC_PORTSPEED_8GBIT;
+	if (speeds & FDMI_PORT_SPEED_4GB)
+		supported_speeds |= FC_PORTSPEED_4GBIT;
+	if (speeds & FDMI_PORT_SPEED_2GB)
+		supported_speeds |= FC_PORTSPEED_2GBIT;
+	if (speeds & FDMI_PORT_SPEED_1GB)
+		supported_speeds |= FC_PORTSPEED_1GBIT;
+
+	return supported_speeds;
+}
+
 void
 qla2x00_init_host_attr(scsi_qla_host_t *vha)
 {
 	struct qla_hw_data *ha = vha->hw;
-	u32 speeds = FC_PORTSPEED_UNKNOWN;
+	u32 speeds = 0, fdmi_speed = 0;
 
 	fc_host_dev_loss_tmo(vha->host) = ha->port_down_retry_count;
 	fc_host_node_name(vha->host) = wwn_to_u64(vha->node_name);
@@ -3276,7 +3299,8 @@ qla2x00_init_host_attr(scsi_qla_host_t *vha)
 	fc_host_max_npiv_vports(vha->host) = ha->max_npiv_vports;
 	fc_host_npiv_vports_inuse(vha->host) = ha->cur_vport_count;
 
-	speeds = qla25xx_fdmi_port_speed_capability(ha);
+	fdmi_speed = qla25xx_fdmi_port_speed_capability(ha);
+	speeds = qla2x00_get_host_supported_speeds(vha, fdmi_speed);
 
 	fc_host_supported_speeds(vha->host) = speeds;
 }
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index bd068d3bb455..58f66176bcb2 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1074,6 +1074,7 @@ static blk_status_t sd_setup_write_same_cmnd(struct scsi_cmnd *cmd)
 	struct bio *bio = rq->bio;
 	u64 lba = sectors_to_logical(sdp, blk_rq_pos(rq));
 	u32 nr_blocks = sectors_to_logical(sdp, blk_rq_sectors(rq));
+	unsigned int nr_bytes = blk_rq_bytes(rq);
 	blk_status_t ret;
 
 	if (sdkp->device->no_write_same)
@@ -1110,7 +1111,7 @@ static blk_status_t sd_setup_write_same_cmnd(struct scsi_cmnd *cmd)
 	 */
 	rq->__data_len = sdp->sector_size;
 	ret = scsi_alloc_sgtables(cmd);
-	rq->__data_len = blk_rq_bytes(rq);
+	rq->__data_len = nr_bytes;
 
 	return ret;
 }
diff --git a/drivers/tty/serial/8250/8250_omap.c b/drivers/tty/serial/8250/8250_omap.c
index 537bee8d2258..f3744ac805ec 100644
--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -342,6 +342,9 @@ static void omap8250_restore_regs(struct uart_8250_port *up)
 	omap8250_update_mdr1(up, priv);
 
 	up->port.ops->set_mctrl(&up->port, up->port.mctrl);
+
+	if (up->port.rs485.flags & SER_RS485_ENABLED)
+		serial8250_em485_stop_tx(up);
 }
 
 /*
diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
index df10cc606582..b6656898699d 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -1531,7 +1531,6 @@ static int pci_fintek_init(struct pci_dev *dev)
 	resource_size_t bar_data[3];
 	u8 config_base;
 	struct serial_private *priv = pci_get_drvdata(dev);
-	struct uart_8250_port *port;
 
 	if (!(pci_resource_flags(dev, 5) & IORESOURCE_IO) ||
 			!(pci_resource_flags(dev, 4) & IORESOURCE_IO) ||
@@ -1578,13 +1577,7 @@ static int pci_fintek_init(struct pci_dev *dev)
 
 		pci_write_config_byte(dev, config_base + 0x06, dev->irq);
 
-		if (priv) {
-			/* re-apply RS232/485 mode when
-			 * pciserial_resume_ports()
-			 */
-			port = serial8250_get_port(priv->line[i]);
-			pci_fintek_rs485_config(&port->port, NULL);
-		} else {
+		if (!priv) {
 			/* First init without port data
 			 * force init to RS232 Mode
 			 */
diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
index 71d143c00248..8b3756e4bb05 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -592,7 +592,7 @@ EXPORT_SYMBOL_GPL(serial8250_rpm_put);
 static int serial8250_em485_init(struct uart_8250_port *p)
 {
 	if (p->em485)
-		return 0;
+		goto deassert_rts;
 
 	p->em485 = kmalloc(sizeof(struct uart_8250_em485), GFP_ATOMIC);
 	if (!p->em485)
@@ -608,7 +608,9 @@ static int serial8250_em485_init(struct uart_8250_port *p)
 	p->em485->active_timer = NULL;
 	p->em485->tx_stopped = true;
 
-	p->rs485_stop_tx(p);
+deassert_rts:
+	if (p->em485->tx_stopped)
+		p->rs485_stop_tx(p);
 
 	return 0;
 }
@@ -2030,6 +2032,9 @@ EXPORT_SYMBOL_GPL(serial8250_do_set_mctrl);
 
 static void serial8250_set_mctrl(struct uart_port *port, unsigned int mctrl)
 {
+	if (port->rs485.flags & SER_RS485_ENABLED)
+		return;
+
 	if (port->set_mctrl)
 		port->set_mctrl(port, mctrl);
 	else
@@ -3161,9 +3166,6 @@ static void serial8250_config_port(struct uart_port *port, int flags)
 	if (flags & UART_CONFIG_TYPE)
 		autoconfig(up);
 
-	if (port->rs485.flags & SER_RS485_ENABLED)
-		port->rs485_config(port, &port->rs485);
-
 	/* if access method is AU, it is a 16550 with a quirk */
 	if (port->type == PORT_16550A && port->iotype == UPIO_AU)
 		up->bugs |= UART_BUG_NOMSR;
diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index 269d1e3a025d..43aca5a2ef0f 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -2669,10 +2669,6 @@ static int lpuart_probe(struct platform_device *pdev)
 	if (ret)
 		goto failed_irq_request;
 
-	ret = uart_add_one_port(&lpuart_reg, &sport->port);
-	if (ret)
-		goto failed_attach_port;
-
 	ret = uart_get_rs485_mode(&sport->port);
 	if (ret)
 		goto failed_get_rs485;
@@ -2684,7 +2680,9 @@ static int lpuart_probe(struct platform_device *pdev)
 	    sport->port.rs485.delay_rts_after_send)
 		dev_err(&pdev->dev, "driver doesn't support RTS delays\n");
 
-	sport->port.rs485_config(&sport->port, &sport->port.rs485);
+	ret = uart_add_one_port(&lpuart_reg, &sport->port);
+	if (ret)
+		goto failed_attach_port;
 
 	return 0;
 
diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index bfbca711bbf9..cf3d53165776 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -398,8 +398,7 @@ static void imx_uart_rts_active(struct imx_port *sport, u32 *ucr2)
 {
 	*ucr2 &= ~(UCR2_CTSC | UCR2_CTS);
 
-	sport->port.mctrl |= TIOCM_RTS;
-	mctrl_gpio_set(sport->gpios, sport->port.mctrl);
+	mctrl_gpio_set(sport->gpios, sport->port.mctrl | TIOCM_RTS);
 }
 
 /* called with port.lock taken and irqs caller dependent */
@@ -408,8 +407,7 @@ static void imx_uart_rts_inactive(struct imx_port *sport, u32 *ucr2)
 	*ucr2 &= ~UCR2_CTSC;
 	*ucr2 |= UCR2_CTS;
 
-	sport->port.mctrl &= ~TIOCM_RTS;
-	mctrl_gpio_set(sport->gpios, sport->port.mctrl);
+	mctrl_gpio_set(sport->gpios, sport->port.mctrl & ~TIOCM_RTS);
 }
 
 static void start_hrtimer_ms(struct hrtimer *hrt, unsigned long msec)
@@ -2381,8 +2379,6 @@ static int imx_uart_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev,
 			"low-active RTS not possible when receiver is off, enabling receiver\n");
 
-	imx_uart_rs485_config(&sport->port, &sport->port.rs485);
-
 	/* Disable interrupts before requesting them */
 	ucr1 = imx_uart_readl(sport, UCR1);
 	ucr1 &= ~(UCR1_ADEN | UCR1_TRDYEN | UCR1_IDEN | UCR1_RRDYEN | UCR1_RTSDEN);
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index b578f7090b63..605f928f0636 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -42,6 +42,11 @@ static struct lock_class_key port_lock_key;
 
 #define HIGH_BITS_OFFSET	((sizeof(long)-sizeof(int))*8)
 
+/*
+ * Max time with active RTS before/after data is sent.
+ */
+#define RS485_MAX_RTS_DELAY	100 /* msecs */
+
 static void uart_change_speed(struct tty_struct *tty, struct uart_state *state,
 					struct ktermios *old_termios);
 static void uart_wait_until_sent(struct tty_struct *tty, int timeout);
@@ -144,15 +149,10 @@ uart_update_mctrl(struct uart_port *port, unsigned int set, unsigned int clear)
 	unsigned long flags;
 	unsigned int old;
 
-	if (port->rs485.flags & SER_RS485_ENABLED) {
-		set &= ~TIOCM_RTS;
-		clear &= ~TIOCM_RTS;
-	}
-
 	spin_lock_irqsave(&port->lock, flags);
 	old = port->mctrl;
 	port->mctrl = (old & ~clear) | set;
-	if (old != port->mctrl)
+	if (old != port->mctrl && !(port->rs485.flags & SER_RS485_ENABLED))
 		port->ops->set_mctrl(port, port->mctrl);
 	spin_unlock_irqrestore(&port->lock, flags);
 }
@@ -1326,8 +1326,41 @@ static int uart_set_rs485_config(struct uart_port *port,
 	if (copy_from_user(&rs485, rs485_user, sizeof(*rs485_user)))
 		return -EFAULT;
 
+	/* pick sane settings if the user hasn't */
+	if (!(rs485.flags & SER_RS485_RTS_ON_SEND) ==
+	    !(rs485.flags & SER_RS485_RTS_AFTER_SEND)) {
+		dev_warn_ratelimited(port->dev,
+			"%s (%d): invalid RTS setting, using RTS_ON_SEND instead\n",
+			port->name, port->line);
+		rs485.flags |= SER_RS485_RTS_ON_SEND;
+		rs485.flags &= ~SER_RS485_RTS_AFTER_SEND;
+	}
+
+	if (rs485.delay_rts_before_send > RS485_MAX_RTS_DELAY) {
+		rs485.delay_rts_before_send = RS485_MAX_RTS_DELAY;
+		dev_warn_ratelimited(port->dev,
+			"%s (%d): RTS delay before sending clamped to %u ms\n",
+			port->name, port->line, rs485.delay_rts_before_send);
+	}
+
+	if (rs485.delay_rts_after_send > RS485_MAX_RTS_DELAY) {
+		rs485.delay_rts_after_send = RS485_MAX_RTS_DELAY;
+		dev_warn_ratelimited(port->dev,
+			"%s (%d): RTS delay after sending clamped to %u ms\n",
+			port->name, port->line, rs485.delay_rts_after_send);
+	}
+	/* Return clean padding area to userspace */
+	memset(rs485.padding, 0, sizeof(rs485.padding));
+
 	spin_lock_irqsave(&port->lock, flags);
 	ret = port->rs485_config(port, &rs485);
+	if (!ret) {
+		port->rs485 = rs485;
+
+		/* Reset RTS and other mctrl lines when disabling RS485 */
+		if (!(rs485.flags & SER_RS485_ENABLED))
+			port->ops->set_mctrl(port, port->mctrl);
+	}
 	spin_unlock_irqrestore(&port->lock, flags);
 	if (ret)
 		return ret;
@@ -2302,7 +2335,8 @@ int uart_resume_port(struct uart_driver *drv, struct uart_port *uport)
 
 		uart_change_pm(state, UART_PM_STATE_ON);
 		spin_lock_irq(&uport->lock);
-		ops->set_mctrl(uport, 0);
+		if (!(uport->rs485.flags & SER_RS485_ENABLED))
+			ops->set_mctrl(uport, 0);
 		spin_unlock_irq(&uport->lock);
 		if (console_suspend_enabled || !uart_console(uport)) {
 			/* Protected by port mutex for now */
@@ -2313,7 +2347,10 @@ int uart_resume_port(struct uart_driver *drv, struct uart_port *uport)
 				if (tty)
 					uart_change_speed(tty, state, NULL);
 				spin_lock_irq(&uport->lock);
-				ops->set_mctrl(uport, uport->mctrl);
+				if (!(uport->rs485.flags & SER_RS485_ENABLED))
+					ops->set_mctrl(uport, uport->mctrl);
+				else
+					uport->rs485_config(uport, &uport->rs485);
 				ops->start_tx(uport);
 				spin_unlock_irq(&uport->lock);
 				tty_port_set_initialized(port, 1);
@@ -2411,10 +2448,10 @@ uart_configure_port(struct uart_driver *drv, struct uart_state *state,
 		 */
 		spin_lock_irqsave(&port->lock, flags);
 		port->mctrl &= TIOCM_DTR;
-		if (port->rs485.flags & SER_RS485_ENABLED &&
-		    !(port->rs485.flags & SER_RS485_RTS_AFTER_SEND))
-			port->mctrl |= TIOCM_RTS;
-		port->ops->set_mctrl(port, port->mctrl);
+		if (!(port->rs485.flags & SER_RS485_ENABLED))
+			port->ops->set_mctrl(port, port->mctrl);
+		else
+			port->rs485_config(port, &port->rs485);
 		spin_unlock_irqrestore(&port->lock, flags);
 
 		/*
diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index 03473e20e218..eb3ea45d5d13 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -388,6 +388,15 @@ static const struct usb_device_id usb_quirk_list[] = {
 	/* Kingston DataTraveler 3.0 */
 	{ USB_DEVICE(0x0951, 0x1666), .driver_info = USB_QUIRK_NO_LPM },
 
+	/* NVIDIA Jetson devices in Force Recovery mode */
+	{ USB_DEVICE(0x0955, 0x7018), .driver_info = USB_QUIRK_RESET_RESUME },
+	{ USB_DEVICE(0x0955, 0x7019), .driver_info = USB_QUIRK_RESET_RESUME },
+	{ USB_DEVICE(0x0955, 0x7418), .driver_info = USB_QUIRK_RESET_RESUME },
+	{ USB_DEVICE(0x0955, 0x7721), .driver_info = USB_QUIRK_RESET_RESUME },
+	{ USB_DEVICE(0x0955, 0x7c18), .driver_info = USB_QUIRK_RESET_RESUME },
+	{ USB_DEVICE(0x0955, 0x7e19), .driver_info = USB_QUIRK_RESET_RESUME },
+	{ USB_DEVICE(0x0955, 0x7f21), .driver_info = USB_QUIRK_RESET_RESUME },
+
 	/* X-Rite/Gretag-Macbeth Eye-One Pro display colorimeter */
 	{ USB_DEVICE(0x0971, 0x2000), .driver_info = USB_QUIRK_NO_SET_INTF },
 
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 41ed2f6f8a8d..347ba7e4bd81 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1064,8 +1064,8 @@ static void dwc3_prepare_one_trb(struct dwc3_ep *dep,
 			trb->ctrl = DWC3_TRBCTL_ISOCHRONOUS;
 		}
 
-		/* always enable Interrupt on Missed ISOC */
-		trb->ctrl |= DWC3_TRB_CTRL_ISP_IMI;
+		if (!no_interrupt && !chain)
+			trb->ctrl |= DWC3_TRB_CTRL_ISP_IMI;
 		break;
 
 	case USB_ENDPOINT_XFER_BULK:
@@ -2800,6 +2800,10 @@ static int dwc3_gadget_ep_reclaim_completed_trb(struct dwc3_ep *dep,
 	if (event->status & DEPEVT_STATUS_SHORT && !chain)
 		return 1;
 
+	if ((trb->ctrl & DWC3_TRB_CTRL_ISP_IMI) &&
+	    DWC3_TRB_SIZE_TRBSTS(trb->size) == DWC3_TRBSTS_MISSED_ISOC)
+		return 1;
+
 	if ((trb->ctrl & DWC3_TRB_CTRL_IOC) ||
 	    (trb->ctrl & DWC3_TRB_CTRL_LST))
 		return 1;
diff --git a/drivers/usb/gadget/udc/bdc/bdc_udc.c b/drivers/usb/gadget/udc/bdc/bdc_udc.c
index 248426a3e88a..5f0b3fd93631 100644
--- a/drivers/usb/gadget/udc/bdc/bdc_udc.c
+++ b/drivers/usb/gadget/udc/bdc/bdc_udc.c
@@ -151,6 +151,7 @@ static void bdc_uspc_disconnected(struct bdc *bdc, bool reinit)
 	bdc->delayed_status = false;
 	bdc->reinit = reinit;
 	bdc->test_mode = false;
+	usb_gadget_set_state(&bdc->gadget, USB_STATE_NOTATTACHED);
 }
 
 /* TNotify wkaeup timer */
diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index 1fba5605a88e..d1a42300ae58 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -915,15 +915,19 @@ void xhci_free_virt_device(struct xhci_hcd *xhci, int slot_id)
 		if (dev->eps[i].stream_info)
 			xhci_free_stream_info(xhci,
 					dev->eps[i].stream_info);
-		/* Endpoints on the TT/root port lists should have been removed
-		 * when usb_disable_device() was called for the device.
-		 * We can't drop them anyway, because the udev might have gone
-		 * away by this point, and we can't tell what speed it was.
+		/*
+		 * Endpoints are normally deleted from the bandwidth list when
+		 * endpoints are dropped, before device is freed.
+		 * If host is dying or being removed then endpoints aren't
+		 * dropped cleanly, so delete the endpoint from list here.
+		 * Only applicable for hosts with software bandwidth checking.
 		 */
-		if (!list_empty(&dev->eps[i].bw_endpoint_list))
-			xhci_warn(xhci, "Slot %u endpoint %u "
-					"not removed from BW list!\n",
-					slot_id, i);
+
+		if (!list_empty(&dev->eps[i].bw_endpoint_list)) {
+			list_del_init(&dev->eps[i].bw_endpoint_list);
+			xhci_dbg(xhci, "Slot %u endpoint %u not removed from BW list!\n",
+				 slot_id, i);
+		}
 	}
 	/* If this is a hub, free the TT(s) from the TT list */
 	xhci_free_tt_info(xhci, dev, slot_id);
diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 8952492d43be..64d5a593682b 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -253,6 +253,10 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 	     pdev->device == PCI_DEVICE_ID_INTEL_DNV_XHCI))
 		xhci->quirks |= XHCI_MISSING_CAS;
 
+	if (pdev->vendor == PCI_VENDOR_ID_INTEL &&
+	    pdev->device == PCI_DEVICE_ID_INTEL_ALDER_LAKE_PCH_XHCI)
+		xhci->quirks |= XHCI_RESET_TO_DEFAULT;
+
 	if (pdev->vendor == PCI_VENDOR_ID_INTEL &&
 	    (pdev->device == PCI_DEVICE_ID_INTEL_ALPINE_RIDGE_2C_XHCI ||
 	     pdev->device == PCI_DEVICE_ID_INTEL_ALPINE_RIDGE_4C_XHCI ||
@@ -302,8 +306,14 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 	}
 
 	if (pdev->vendor == PCI_VENDOR_ID_ASMEDIA &&
-		pdev->device == PCI_DEVICE_ID_ASMEDIA_1042_XHCI)
+		pdev->device == PCI_DEVICE_ID_ASMEDIA_1042_XHCI) {
+		/*
+		 * try to tame the ASMedia 1042 controller which reports 0.96
+		 * but appears to behave more like 1.0
+		 */
+		xhci->quirks |= XHCI_SPURIOUS_SUCCESS;
 		xhci->quirks |= XHCI_BROKEN_STREAMS;
+	}
 	if (pdev->vendor == PCI_VENDOR_ID_ASMEDIA &&
 		pdev->device == PCI_DEVICE_ID_ASMEDIA_1042A_XHCI) {
 		xhci->quirks |= XHCI_TRUST_TX_LENGTH;
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 8918e6ae5c4b..c968dd865314 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -794,9 +794,15 @@ void xhci_shutdown(struct usb_hcd *hcd)
 
 	spin_lock_irq(&xhci->lock);
 	xhci_halt(xhci);
-	/* Workaround for spurious wakeups at shutdown with HSW */
-	if (xhci->quirks & XHCI_SPURIOUS_WAKEUP)
+
+	/*
+	 * Workaround for spurious wakeps at shutdown with HSW, and for boot
+	 * firmware delay in ADL-P PCH if port are left in U3 at shutdown
+	 */
+	if (xhci->quirks & XHCI_SPURIOUS_WAKEUP ||
+	    xhci->quirks & XHCI_RESET_TO_DEFAULT)
 		xhci_reset(xhci, XHCI_RESET_SHORT_USEC);
+
 	spin_unlock_irq(&xhci->lock);
 
 	xhci_cleanup_msix(xhci);
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index e668740000b2..059050f13522 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1889,6 +1889,7 @@ struct xhci_hcd {
 #define XHCI_NO_SOFT_RETRY	BIT_ULL(40)
 #define XHCI_EP_CTX_BROKEN_DCS	BIT_ULL(42)
 #define XHCI_SUSPEND_RESUME_CLKS	BIT_ULL(43)
+#define XHCI_RESET_TO_DEFAULT	BIT_ULL(44)
 
 	unsigned int		num_active_eps;
 	unsigned int		limit_active_eps;
diff --git a/drivers/video/fbdev/smscufx.c b/drivers/video/fbdev/smscufx.c
index 7673db5da26b..5fa3f1e5dfe8 100644
--- a/drivers/video/fbdev/smscufx.c
+++ b/drivers/video/fbdev/smscufx.c
@@ -97,7 +97,6 @@ struct ufx_data {
 	struct kref kref;
 	int fb_count;
 	bool virtualized; /* true when physical usb device not present */
-	struct delayed_work free_framebuffer_work;
 	atomic_t usb_active; /* 0 = update virtual buffer, but no usb traffic */
 	atomic_t lost_pixels; /* 1 = a render op failed. Need screen refresh */
 	u8 *edid; /* null until we read edid from hw or get from sysfs */
@@ -1116,15 +1115,24 @@ static void ufx_free(struct kref *kref)
 {
 	struct ufx_data *dev = container_of(kref, struct ufx_data, kref);
 
-	/* this function will wait for all in-flight urbs to complete */
-	if (dev->urbs.count > 0)
-		ufx_free_urb_list(dev);
+	kfree(dev);
+}
 
-	pr_debug("freeing ufx_data %p", dev);
+static void ufx_ops_destory(struct fb_info *info)
+{
+	struct ufx_data *dev = info->par;
+	int node = info->node;
 
-	kfree(dev);
+	/* Assume info structure is freed after this point */
+	framebuffer_release(info);
+
+	pr_debug("fb_info for /dev/fb%d has been freed", node);
+
+	/* release reference taken by kref_init in probe() */
+	kref_put(&dev->kref, ufx_free);
 }
 
+
 static void ufx_release_urb_work(struct work_struct *work)
 {
 	struct urb_node *unode = container_of(work, struct urb_node,
@@ -1133,14 +1141,9 @@ static void ufx_release_urb_work(struct work_struct *work)
 	up(&unode->dev->urbs.limit_sem);
 }
 
-static void ufx_free_framebuffer_work(struct work_struct *work)
+static void ufx_free_framebuffer(struct ufx_data *dev)
 {
-	struct ufx_data *dev = container_of(work, struct ufx_data,
-					    free_framebuffer_work.work);
 	struct fb_info *info = dev->info;
-	int node = info->node;
-
-	unregister_framebuffer(info);
 
 	if (info->cmap.len != 0)
 		fb_dealloc_cmap(&info->cmap);
@@ -1152,11 +1155,6 @@ static void ufx_free_framebuffer_work(struct work_struct *work)
 
 	dev->info = NULL;
 
-	/* Assume info structure is freed after this point */
-	framebuffer_release(info);
-
-	pr_debug("fb_info for /dev/fb%d has been freed", node);
-
 	/* ref taken in probe() as part of registering framebfufer */
 	kref_put(&dev->kref, ufx_free);
 }
@@ -1168,11 +1166,13 @@ static int ufx_ops_release(struct fb_info *info, int user)
 {
 	struct ufx_data *dev = info->par;
 
+	mutex_lock(&disconnect_mutex);
+
 	dev->fb_count--;
 
 	/* We can't free fb_info here - fbmem will touch it when we return */
 	if (dev->virtualized && (dev->fb_count == 0))
-		schedule_delayed_work(&dev->free_framebuffer_work, HZ);
+		ufx_free_framebuffer(dev);
 
 	if ((dev->fb_count == 0) && (info->fbdefio)) {
 		fb_deferred_io_cleanup(info);
@@ -1185,6 +1185,8 @@ static int ufx_ops_release(struct fb_info *info, int user)
 
 	kref_put(&dev->kref, ufx_free);
 
+	mutex_unlock(&disconnect_mutex);
+
 	return 0;
 }
 
@@ -1291,6 +1293,7 @@ static const struct fb_ops ufx_ops = {
 	.fb_blank = ufx_ops_blank,
 	.fb_check_var = ufx_ops_check_var,
 	.fb_set_par = ufx_ops_set_par,
+	.fb_destroy = ufx_ops_destory,
 };
 
 /* Assumes &info->lock held by caller
@@ -1672,9 +1675,6 @@ static int ufx_usb_probe(struct usb_interface *interface,
 		goto destroy_modedb;
 	}
 
-	INIT_DELAYED_WORK(&dev->free_framebuffer_work,
-			  ufx_free_framebuffer_work);
-
 	retval = ufx_reg_read(dev, 0x3000, &id_rev);
 	check_warn_goto_error(retval, "error %d reading 0x3000 register from device", retval);
 	dev_dbg(dev->gdev, "ID_REV register value 0x%08x", id_rev);
@@ -1747,10 +1747,12 @@ static int ufx_usb_probe(struct usb_interface *interface,
 static void ufx_usb_disconnect(struct usb_interface *interface)
 {
 	struct ufx_data *dev;
+	struct fb_info *info;
 
 	mutex_lock(&disconnect_mutex);
 
 	dev = usb_get_intfdata(interface);
+	info = dev->info;
 
 	pr_debug("USB disconnect starting\n");
 
@@ -1764,12 +1766,15 @@ static void ufx_usb_disconnect(struct usb_interface *interface)
 
 	/* if clients still have us open, will be freed on last close */
 	if (dev->fb_count == 0)
-		schedule_delayed_work(&dev->free_framebuffer_work, 0);
+		ufx_free_framebuffer(dev);
 
-	/* release reference taken by kref_init in probe() */
-	kref_put(&dev->kref, ufx_free);
+	/* this function will wait for all in-flight urbs to complete */
+	if (dev->urbs.count > 0)
+		ufx_free_urb_list(dev);
 
-	/* consider ufx_data freed */
+	pr_debug("freeing ufx_data %p", dev);
+
+	unregister_framebuffer(info);
 
 	mutex_unlock(&disconnect_mutex);
 }
diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index ff195b571763..16acddaff9ae 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -360,8 +360,7 @@ int gntdev_map_grant_pages(struct gntdev_grant_map *map)
 	for (i = 0; i < map->count; i++) {
 		if (map->map_ops[i].status == GNTST_okay) {
 			map->unmap_ops[i].handle = map->map_ops[i].handle;
-			if (!use_ptemod)
-				alloced++;
+			alloced++;
 		} else if (!err)
 			err = -EINVAL;
 
@@ -370,8 +369,7 @@ int gntdev_map_grant_pages(struct gntdev_grant_map *map)
 
 		if (use_ptemod) {
 			if (map->kmap_ops[i].status == GNTST_okay) {
-				if (map->map_ops[i].status == GNTST_okay)
-					alloced++;
+				alloced++;
 				map->kunmap_ops[i].handle = map->kmap_ops[i].handle;
 			} else if (!err)
 				err = -EINVAL;
@@ -387,20 +385,42 @@ static void __unmap_grant_pages_done(int result,
 	unsigned int i;
 	struct gntdev_grant_map *map = data->data;
 	unsigned int offset = data->unmap_ops - map->unmap_ops;
+	int successful_unmaps = 0;
+	int live_grants;
 
 	for (i = 0; i < data->count; i++) {
+		if (map->unmap_ops[offset + i].status == GNTST_okay &&
+		    map->unmap_ops[offset + i].handle != -1)
+			successful_unmaps++;
+
 		WARN_ON(map->unmap_ops[offset+i].status &&
 			map->unmap_ops[offset+i].handle != -1);
 		pr_debug("unmap handle=%d st=%d\n",
 			map->unmap_ops[offset+i].handle,
 			map->unmap_ops[offset+i].status);
 		map->unmap_ops[offset+i].handle = -1;
+		if (use_ptemod) {
+			if (map->kunmap_ops[offset + i].status == GNTST_okay &&
+			    map->kunmap_ops[offset + i].handle != -1)
+				successful_unmaps++;
+
+			WARN_ON(map->kunmap_ops[offset+i].status &&
+				map->kunmap_ops[offset+i].handle != -1);
+			pr_debug("kunmap handle=%u st=%d\n",
+				 map->kunmap_ops[offset+i].handle,
+				 map->kunmap_ops[offset+i].status);
+			map->kunmap_ops[offset+i].handle = -1;
+		}
 	}
+
 	/*
 	 * Decrease the live-grant counter.  This must happen after the loop to
 	 * prevent premature reuse of the grants by gnttab_mmap().
 	 */
-	atomic_sub(data->count, &map->live_grants);
+	live_grants = atomic_sub_return(successful_unmaps, &map->live_grants);
+	if (WARN_ON(live_grants < 0))
+		pr_err("%s: live_grants became negative (%d) after unmapping %d pages!\n",
+		       __func__, live_grants, successful_unmaps);
 
 	/* Release reference taken by __unmap_grant_pages */
 	gntdev_put_map(NULL, map);
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 213864bc7e8c..ccc4c6d8a578 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -907,7 +907,7 @@ static int load_elf_binary(struct linux_binprm *bprm)
 		interp_elf_ex = kmalloc(sizeof(*interp_elf_ex), GFP_KERNEL);
 		if (!interp_elf_ex) {
 			retval = -ENOMEM;
-			goto out_free_ph;
+			goto out_free_file;
 		}
 
 		/* Get the exec headers */
@@ -1328,6 +1328,7 @@ static int load_elf_binary(struct linux_binprm *bprm)
 out_free_dentry:
 	kfree(interp_elf_ex);
 	kfree(interp_elf_phdata);
+out_free_file:
 	allow_write_access(interpreter);
 	if (interpreter)
 		fput(interpreter);
diff --git a/fs/exec.c b/fs/exec.c
index b56bc4b4016e..983295c0b8ac 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1198,11 +1198,11 @@ static int unshare_sighand(struct task_struct *me)
 			return -ENOMEM;
 
 		refcount_set(&newsighand->count, 1);
-		memcpy(newsighand->action, oldsighand->action,
-		       sizeof(newsighand->action));
 
 		write_lock_irq(&tasklist_lock);
 		spin_lock(&oldsighand->siglock);
+		memcpy(newsighand->action, oldsighand->action,
+		       sizeof(newsighand->action));
 		rcu_assign_pointer(me->sighand, newsighand);
 		spin_unlock(&oldsighand->siglock);
 		write_unlock_irq(&tasklist_lock);
diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index afb39e1bbe3b..8b3c86a502da 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -1519,8 +1519,11 @@ int kernfs_remove_by_name_ns(struct kernfs_node *parent, const char *name,
 	mutex_lock(&kernfs_mutex);
 
 	kn = kernfs_find_ns(parent, name, ns);
-	if (kn)
+	if (kn) {
+		kernfs_get(kn);
 		__kernfs_remove(kn);
+		kernfs_put(kn);
+	}
 
 	mutex_unlock(&kernfs_mutex);
 
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 41fbb4793394..ae88362216a4 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -899,7 +899,7 @@ void mlx5_cmd_allowed_opcode(struct mlx5_core_dev *dev, u16 opcode);
 struct mlx5_async_ctx {
 	struct mlx5_core_dev *dev;
 	atomic_t num_inflight;
-	struct wait_queue_head wait;
+	struct completion inflight_done;
 };
 
 struct mlx5_async_work;
diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
index a3083529b698..2e53ee1c8db4 100644
--- a/include/media/v4l2-common.h
+++ b/include/media/v4l2-common.h
@@ -175,7 +175,8 @@ struct v4l2_subdev *v4l2_i2c_new_subdev_board(struct v4l2_device *v4l2_dev,
  *
  * @sd: pointer to &struct v4l2_subdev
  * @client: pointer to struct i2c_client
- * @devname: the name of the device; if NULL, the I²C device's name will be used
+ * @devname: the name of the device; if NULL, the I²C device drivers's name
+ *           will be used
  * @postfix: sub-device specific string to put right after the I²C device name;
  *	     may be NULL
  */
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 534eaa4d39bc..b28817c59fdf 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1552,7 +1552,8 @@ struct v4l2_bt_timings {
 	((bt)->width + V4L2_DV_BT_BLANKING_WIDTH(bt))
 #define V4L2_DV_BT_BLANKING_HEIGHT(bt) \
 	((bt)->vfrontporch + (bt)->vsync + (bt)->vbackporch + \
-	 (bt)->il_vfrontporch + (bt)->il_vsync + (bt)->il_vbackporch)
+	 ((bt)->interlaced ? \
+	  ((bt)->il_vfrontporch + (bt)->il_vsync + (bt)->il_vbackporch) : 0))
 #define V4L2_DV_BT_FRAME_HEIGHT(bt) \
 	((bt)->height + V4L2_DV_BT_BLANKING_HEIGHT(bt))
 
diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index 522cb1387462..59a1b126c369 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -637,7 +637,7 @@ static void power_down(void)
 	int error;
 
 	if (hibernation_mode == HIBERNATION_SUSPEND) {
-		error = suspend_devices_and_enter(PM_SUSPEND_MEM);
+		error = suspend_devices_and_enter(mem_sleep_current);
 		if (error) {
 			hibernation_mode = hibernation_ops ?
 						HIBERNATION_PLATFORM :
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index c57c165bfbbc..d8c63d79af20 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2387,11 +2387,11 @@ struct page *alloc_huge_page(struct vm_area_struct *vma,
 		page = alloc_buddy_huge_page_with_mpol(h, vma, addr);
 		if (!page)
 			goto out_uncharge_cgroup;
+		spin_lock(&hugetlb_lock);
 		if (!avoid_reserve && vma_has_reserves(vma, gbl_chg)) {
 			SetPagePrivate(page);
 			h->resv_huge_pages--;
 		}
-		spin_lock(&hugetlb_lock);
 		list_add(&page->lru, &h->hugepage_activelist);
 		/* Fall through */
 	}
diff --git a/mm/memory.c b/mm/memory.c
index cc50fa0f4590..cbc0a163d705 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -823,6 +823,17 @@ copy_present_page(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma
 	if (likely(!page_maybe_dma_pinned(page)))
 		return 1;
 
+	/*
+	 * The vma->anon_vma of the child process may be NULL
+	 * because the entire vma does not contain anonymous pages.
+	 * A BUG will occur when the copy_present_page() passes
+	 * a copy of a non-anonymous page of that vma to the
+	 * page_add_new_anon_rmap() to set up new anonymous rmap.
+	 * Return 1 if the page is not an anonymous page.
+	 */
+	if (!PageAnon(page))
+		return 1;
+
 	new_page = *prealloc;
 	if (!new_page)
 		return -EAGAIN;
diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index 2830a12a4dd1..78f6a9110699 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -338,10 +338,12 @@ static void j1939_session_skb_drop_old(struct j1939_session *session)
 		__skb_unlink(do_skb, &session->skb_queue);
 		/* drop ref taken in j1939_session_skb_queue() */
 		skb_unref(do_skb);
+		spin_unlock_irqrestore(&session->skb_queue.lock, flags);
 
 		kfree_skb(do_skb);
+	} else {
+		spin_unlock_irqrestore(&session->skb_queue.lock, flags);
 	}
-	spin_unlock_irqrestore(&session->skb_queue.lock, flags);
 }
 
 void j1939_session_skb_queue(struct j1939_session *session,
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index cbff7d94b993..a3b7d965e9c0 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -135,6 +135,7 @@ static int net_assign_generic(struct net *net, unsigned int id, void *data)
 
 static int ops_init(const struct pernet_operations *ops, struct net *net)
 {
+	struct net_generic *ng;
 	int err = -ENOMEM;
 	void *data = NULL;
 
@@ -153,7 +154,13 @@ static int ops_init(const struct pernet_operations *ops, struct net *net)
 	if (!err)
 		return 0;
 
+	if (ops->id && ops->size) {
 cleanup:
+		ng = rcu_dereference_protected(net->gen,
+					       lockdep_is_held(&pernet_ops_rwsem));
+		ng->ptr[*ops->id] = NULL;
+	}
+
 	kfree(data);
 
 out:
diff --git a/net/ieee802154/socket.c b/net/ieee802154/socket.c
index ecc0d5fbde04..d4c275e56d82 100644
--- a/net/ieee802154/socket.c
+++ b/net/ieee802154/socket.c
@@ -503,8 +503,10 @@ static int dgram_bind(struct sock *sk, struct sockaddr *uaddr, int len)
 	if (err < 0)
 		goto out;
 
-	if (addr->family != AF_IEEE802154)
+	if (addr->family != AF_IEEE802154) {
+		err = -EINVAL;
 		goto out;
+	}
 
 	ieee802154_addr_from_sa(&haddr, &addr->addr);
 	dev = ieee802154_get_dev(sock_net(sk), &haddr);
diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 2a17dc9413ae..7a0102a4b1de 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -1346,7 +1346,7 @@ static int nh_create_ipv4(struct net *net, struct nexthop *nh,
 	if (!err) {
 		nh->nh_flags = fib_nh->fib_nh_flags;
 		fib_info_update_nhc_saddr(net, &fib_nh->nh_common,
-					  fib_nh->fib_nh_scope);
+					  !fib_nh->fib_nh_scope ? 0 : fib_nh->fib_nh_scope - 1);
 	} else {
 		fib_nh_release(net, fib_nh);
 	}
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 377cba9b124d..541758cd0b81 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2175,7 +2175,8 @@ void tcp_enter_loss(struct sock *sk)
  */
 static bool tcp_check_sack_reneging(struct sock *sk, int flag)
 {
-	if (flag & FLAG_SACK_RENEGING) {
+	if (flag & FLAG_SACK_RENEGING &&
+	    flag & FLAG_SND_UNA_ADVANCED) {
 		struct tcp_sock *tp = tcp_sk(sk);
 		unsigned long delay = max(usecs_to_jiffies(tp->srtt_us >> 4),
 					  msecs_to_jiffies(10));
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 5c1e6b0687e2..31a8009f74ee 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1770,8 +1770,7 @@ int tcp_v4_early_demux(struct sk_buff *skb)
 
 bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb)
 {
-	u32 limit = READ_ONCE(sk->sk_rcvbuf) + READ_ONCE(sk->sk_sndbuf);
-	u32 tail_gso_size, tail_gso_segs;
+	u32 limit, tail_gso_size, tail_gso_segs;
 	struct skb_shared_info *shinfo;
 	const struct tcphdr *th;
 	struct tcphdr *thtail;
@@ -1874,11 +1873,13 @@ bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb)
 	__skb_push(skb, hdrlen);
 
 no_coalesce:
+	limit = (u32)READ_ONCE(sk->sk_rcvbuf) + (u32)(READ_ONCE(sk->sk_sndbuf) >> 1);
+
 	/* Only socket owner can try to collapse/prune rx queues
 	 * to reduce memory overhead, so add a little headroom here.
 	 * Few sockets backlog are possibly concurrently non empty.
 	 */
-	limit += 64*1024;
+	limit += 64 * 1024;
 
 	if (unlikely(sk_add_backlog(sk, skb, limit))) {
 		bh_unlock_sock(sk);
diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index 9e0890738d93..0010f9e54f13 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -1153,14 +1153,16 @@ static void ip6gre_tnl_link_config_route(struct ip6_tnl *t, int set_mtu,
 				dev->needed_headroom = dst_len;
 
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
index 3a2741569b84..0d4cab94c5dd 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1476,8 +1476,8 @@ static void ip6_tnl_link_config(struct ip6_tnl *t)
 	struct net_device *tdev = NULL;
 	struct __ip6_tnl_parm *p = &t->parms;
 	struct flowi6 *fl6 = &t->fl.u.ip6;
-	unsigned int mtu;
 	int t_hlen;
+	int mtu;
 
 	memcpy(dev->dev_addr, &p->laddr, sizeof(struct in6_addr));
 	memcpy(dev->broadcast, &p->raddr, sizeof(struct in6_addr));
@@ -1524,12 +1524,13 @@ static void ip6_tnl_link_config(struct ip6_tnl *t)
 			dev->hard_header_len = tdev->hard_header_len + t_hlen;
 			mtu = min_t(unsigned int, tdev->mtu, IP6_MAX_MTU);
 
-			dev->mtu = mtu - t_hlen;
+			mtu = mtu - t_hlen;
 			if (!(t->parms.flags & IP6_TNL_F_IGN_ENCAP_LIMIT))
-				dev->mtu -= 8;
+				mtu -= 8;
 
-			if (dev->mtu < IPV6_MIN_MTU)
-				dev->mtu = IPV6_MIN_MTU;
+			if (mtu < IPV6_MIN_MTU)
+				mtu = IPV6_MIN_MTU;
+			WRITE_ONCE(dev->mtu, mtu);
 		}
 	}
 }
diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 3c92e8cacbba..1ce486a9bc07 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -1123,10 +1123,12 @@ static void ipip6_tunnel_bind_dev(struct net_device *dev)
 
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
 
diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index 18469f1f707e..6b362b362f79 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -161,7 +161,8 @@ static void kcm_rcv_ready(struct kcm_sock *kcm)
 	/* Buffer limit is okay now, add to ready list */
 	list_add_tail(&kcm->wait_rx_list,
 		      &kcm->mux->kcm_rx_waiters);
-	kcm->rx_wait = true;
+	/* paired with lockless reads in kcm_rfree() */
+	WRITE_ONCE(kcm->rx_wait, true);
 }
 
 static void kcm_rfree(struct sk_buff *skb)
@@ -177,7 +178,7 @@ static void kcm_rfree(struct sk_buff *skb)
 	/* For reading rx_wait and rx_psock without holding lock */
 	smp_mb__after_atomic();
 
-	if (!kcm->rx_wait && !kcm->rx_psock &&
+	if (!READ_ONCE(kcm->rx_wait) && !READ_ONCE(kcm->rx_psock) &&
 	    sk_rmem_alloc_get(sk) < sk->sk_rcvlowat) {
 		spin_lock_bh(&mux->rx_lock);
 		kcm_rcv_ready(kcm);
@@ -236,7 +237,8 @@ static void requeue_rx_msgs(struct kcm_mux *mux, struct sk_buff_head *head)
 		if (kcm_queue_rcv_skb(&kcm->sk, skb)) {
 			/* Should mean socket buffer full */
 			list_del(&kcm->wait_rx_list);
-			kcm->rx_wait = false;
+			/* paired with lockless reads in kcm_rfree() */
+			WRITE_ONCE(kcm->rx_wait, false);
 
 			/* Commit rx_wait to read in kcm_free */
 			smp_wmb();
@@ -279,10 +281,12 @@ static struct kcm_sock *reserve_rx_kcm(struct kcm_psock *psock,
 	kcm = list_first_entry(&mux->kcm_rx_waiters,
 			       struct kcm_sock, wait_rx_list);
 	list_del(&kcm->wait_rx_list);
-	kcm->rx_wait = false;
+	/* paired with lockless reads in kcm_rfree() */
+	WRITE_ONCE(kcm->rx_wait, false);
 
 	psock->rx_kcm = kcm;
-	kcm->rx_psock = psock;
+	/* paired with lockless reads in kcm_rfree() */
+	WRITE_ONCE(kcm->rx_psock, psock);
 
 	spin_unlock_bh(&mux->rx_lock);
 
@@ -309,7 +313,8 @@ static void unreserve_rx_kcm(struct kcm_psock *psock,
 	spin_lock_bh(&mux->rx_lock);
 
 	psock->rx_kcm = NULL;
-	kcm->rx_psock = NULL;
+	/* paired with lockless reads in kcm_rfree() */
+	WRITE_ONCE(kcm->rx_psock, NULL);
 
 	/* Commit kcm->rx_psock before sk_rmem_alloc_get to sync with
 	 * kcm_rfree
@@ -1239,7 +1244,8 @@ static void kcm_recv_disable(struct kcm_sock *kcm)
 	if (!kcm->rx_psock) {
 		if (kcm->rx_wait) {
 			list_del(&kcm->wait_rx_list);
-			kcm->rx_wait = false;
+			/* paired with lockless reads in kcm_rfree() */
+			WRITE_ONCE(kcm->rx_wait, false);
 		}
 
 		requeue_rx_msgs(mux, &kcm->sk.sk_receive_queue);
@@ -1792,7 +1798,8 @@ static void kcm_done(struct kcm_sock *kcm)
 
 	if (kcm->rx_wait) {
 		list_del(&kcm->wait_rx_list);
-		kcm->rx_wait = false;
+		/* paired with lockless reads in kcm_rfree() */
+		WRITE_ONCE(kcm->rx_wait, false);
 	}
 	/* Move any pending receive messages to other kcm sockets */
 	requeue_rx_msgs(mux, &sk->sk_receive_queue);
diff --git a/net/mac802154/rx.c b/net/mac802154/rx.c
index c439125ef2b9..726b47a4611b 100644
--- a/net/mac802154/rx.c
+++ b/net/mac802154/rx.c
@@ -132,7 +132,7 @@ static int
 ieee802154_parse_frame_start(struct sk_buff *skb, struct ieee802154_hdr *hdr)
 {
 	int hlen;
-	struct ieee802154_mac_cb *cb = mac_cb_init(skb);
+	struct ieee802154_mac_cb *cb = mac_cb(skb);
 
 	skb_reset_mac_header(skb);
 
@@ -294,8 +294,9 @@ void
 ieee802154_rx_irqsafe(struct ieee802154_hw *hw, struct sk_buff *skb, u8 lqi)
 {
 	struct ieee802154_local *local = hw_to_local(hw);
+	struct ieee802154_mac_cb *cb = mac_cb_init(skb);
 
-	mac_cb(skb)->lqi = lqi;
+	cb->lqi = lqi;
 	skb->pkt_type = IEEE802154_RX_MSG;
 	skb_queue_tail(&local->skb_queue, skb);
 	tasklet_schedule(&local->tasklet);
diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 6b5c0abf7f1b..7ed97dc0b561 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -1592,7 +1592,8 @@ static void ovs_dp_reset_user_features(struct sk_buff *skb,
 	if (IS_ERR(dp))
 		return;
 
-	WARN(dp->user_features, "Dropping previously announced user features\n");
+	pr_warn("%s: Dropping previously announced user features\n",
+		ovs_dp_name(dp));
 	dp->user_features = 0;
 }
 
diff --git a/net/tipc/topsrv.c b/net/tipc/topsrv.c
index d9e2c0fea3f2..561e709ae06a 100644
--- a/net/tipc/topsrv.c
+++ b/net/tipc/topsrv.c
@@ -450,12 +450,19 @@ static void tipc_conn_data_ready(struct sock *sk)
 static void tipc_topsrv_accept(struct work_struct *work)
 {
 	struct tipc_topsrv *srv = container_of(work, struct tipc_topsrv, awork);
-	struct socket *lsock = srv->listener;
-	struct socket *newsock;
+	struct socket *newsock, *lsock;
 	struct tipc_conn *con;
 	struct sock *newsk;
 	int ret;
 
+	spin_lock_bh(&srv->idr_lock);
+	if (!srv->listener) {
+		spin_unlock_bh(&srv->idr_lock);
+		return;
+	}
+	lsock = srv->listener;
+	spin_unlock_bh(&srv->idr_lock);
+
 	while (1) {
 		ret = kernel_accept(lsock, &newsock, O_NONBLOCK);
 		if (ret < 0)
@@ -489,7 +496,7 @@ static void tipc_topsrv_listener_data_ready(struct sock *sk)
 
 	read_lock_bh(&sk->sk_callback_lock);
 	srv = sk->sk_user_data;
-	if (srv->listener)
+	if (srv)
 		queue_work(srv->rcv_wq, &srv->awork);
 	read_unlock_bh(&sk->sk_callback_lock);
 }
@@ -699,8 +706,9 @@ static void tipc_topsrv_stop(struct net *net)
 	__module_get(lsock->sk->sk_prot_creator->owner);
 	srv->listener = NULL;
 	spin_unlock_bh(&srv->idr_lock);
-	sock_release(lsock);
+
 	tipc_topsrv_work_stop(srv);
+	sock_release(lsock);
 	idr_destroy(&srv->conn_idr);
 	kfree(srv);
 }
diff --git a/sound/aoa/soundbus/i2sbus/core.c b/sound/aoa/soundbus/i2sbus/core.c
index faf6b03131ee..51ed2f34b276 100644
--- a/sound/aoa/soundbus/i2sbus/core.c
+++ b/sound/aoa/soundbus/i2sbus/core.c
@@ -147,6 +147,7 @@ static int i2sbus_get_and_fixup_rsrc(struct device_node *np, int index,
 	return rc;
 }
 
+/* Returns 1 if added, 0 for otherwise; don't return a negative value! */
 /* FIXME: look at device node refcounting */
 static int i2sbus_add_dev(struct macio_dev *macio,
 			  struct i2sbus_control *control,
@@ -213,7 +214,7 @@ static int i2sbus_add_dev(struct macio_dev *macio,
 	 * either as the second one in that case is just a modem. */
 	if (!ok) {
 		kfree(dev);
-		return -ENODEV;
+		return 0;
 	}
 
 	mutex_init(&dev->lock);
@@ -302,6 +303,10 @@ static int i2sbus_add_dev(struct macio_dev *macio,
 
 	if (soundbus_add_one(&dev->sound)) {
 		printk(KERN_DEBUG "i2sbus: device registration error!\n");
+		if (dev->sound.ofdev.dev.kobj.state_initialized) {
+			soundbus_dev_put(&dev->sound);
+			return 0;
+		}
 		goto err;
 	}
 
diff --git a/sound/pci/ac97/ac97_codec.c b/sound/pci/ac97/ac97_codec.c
index 963731cf0d8c..cd66632bf1c3 100644
--- a/sound/pci/ac97/ac97_codec.c
+++ b/sound/pci/ac97/ac97_codec.c
@@ -1946,6 +1946,7 @@ static int snd_ac97_dev_register(struct snd_device *device)
 		     snd_ac97_get_short_name(ac97));
 	if ((err = device_register(&ac97->dev)) < 0) {
 		ac97_err(ac97, "Can't register ac97 bus\n");
+		put_device(&ac97->dev);
 		ac97->dev.bus = NULL;
 		return err;
 	}
diff --git a/sound/pci/au88x0/au88x0.h b/sound/pci/au88x0/au88x0.h
index 0aa7af049b1b..6cbb2bc4a048 100644
--- a/sound/pci/au88x0/au88x0.h
+++ b/sound/pci/au88x0/au88x0.h
@@ -141,7 +141,7 @@ struct snd_vortex {
 #ifndef CHIP_AU8810
 	stream_t dma_wt[NR_WT];
 	wt_voice_t wt_voice[NR_WT];	/* WT register cache. */
-	char mixwt[(NR_WT / NR_WTPB) * 6];	/* WT mixin objects */
+	s8 mixwt[(NR_WT / NR_WTPB) * 6];	/* WT mixin objects */
 #endif
 
 	/* Global resources */
@@ -235,8 +235,8 @@ static int vortex_alsafmt_aspfmt(snd_pcm_format_t alsafmt, vortex_t *v);
 static void vortex_connect_default(vortex_t * vortex, int en);
 static int vortex_adb_allocroute(vortex_t * vortex, int dma, int nr_ch,
 				 int dir, int type, int subdev);
-static char vortex_adb_checkinout(vortex_t * vortex, int resmap[], int out,
-				  int restype);
+static int vortex_adb_checkinout(vortex_t * vortex, int resmap[], int out,
+				 int restype);
 #ifndef CHIP_AU8810
 static int vortex_wt_allocroute(vortex_t * vortex, int dma, int nr_ch);
 static void vortex_wt_connect(vortex_t * vortex, int en);
diff --git a/sound/pci/au88x0/au88x0_core.c b/sound/pci/au88x0/au88x0_core.c
index 5180f1bd1326..0b04436ac017 100644
--- a/sound/pci/au88x0/au88x0_core.c
+++ b/sound/pci/au88x0/au88x0_core.c
@@ -1998,7 +1998,7 @@ static const int resnum[VORTEX_RESOURCE_LAST] =
  out: Mean checkout if != 0. Else mean Checkin resource.
  restype: Indicates type of resource to be checked in or out.
 */
-static char
+static int
 vortex_adb_checkinout(vortex_t * vortex, int resmap[], int out, int restype)
 {
 	int i, qty = resnum[restype], resinuse = 0;
diff --git a/sound/pci/rme9652/hdsp.c b/sound/pci/rme9652/hdsp.c
index 4aee30db034d..954347424500 100644
--- a/sound/pci/rme9652/hdsp.c
+++ b/sound/pci/rme9652/hdsp.c
@@ -436,7 +436,7 @@ struct hdsp_midi {
     struct snd_rawmidi           *rmidi;
     struct snd_rawmidi_substream *input;
     struct snd_rawmidi_substream *output;
-    char                     istimer; /* timer in use */
+    signed char		     istimer; /* timer in use */
     struct timer_list	     timer;
     spinlock_t               lock;
     int			     pending;
@@ -479,7 +479,7 @@ struct hdsp {
 	pid_t                 playback_pid;
 	int                   running;
 	int                   system_sample_rate;
-	const char           *channel_map;
+	const signed char    *channel_map;
 	int                   dev;
 	int                   irq;
 	unsigned long         port;
@@ -501,7 +501,7 @@ struct hdsp {
    where the data for that channel can be read/written from/to.
 */
 
-static const char channel_map_df_ss[HDSP_MAX_CHANNELS] = {
+static const signed char channel_map_df_ss[HDSP_MAX_CHANNELS] = {
 	0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17,
 	18, 19, 20, 21, 22, 23, 24, 25
 };
@@ -516,7 +516,7 @@ static const char channel_map_mf_ss[HDSP_MAX_CHANNELS] = { /* Multiface */
 	-1, -1, -1, -1, -1, -1, -1, -1
 };
 
-static const char channel_map_ds[HDSP_MAX_CHANNELS] = {
+static const signed char channel_map_ds[HDSP_MAX_CHANNELS] = {
 	/* ADAT channels are remapped */
 	1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23,
 	/* channels 12 and 13 are S/PDIF */
@@ -525,7 +525,7 @@ static const char channel_map_ds[HDSP_MAX_CHANNELS] = {
 	-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1
 };
 
-static const char channel_map_H9632_ss[HDSP_MAX_CHANNELS] = {
+static const signed char channel_map_H9632_ss[HDSP_MAX_CHANNELS] = {
 	/* ADAT channels */
 	0, 1, 2, 3, 4, 5, 6, 7,
 	/* SPDIF */
@@ -539,7 +539,7 @@ static const char channel_map_H9632_ss[HDSP_MAX_CHANNELS] = {
 	-1, -1
 };
 
-static const char channel_map_H9632_ds[HDSP_MAX_CHANNELS] = {
+static const signed char channel_map_H9632_ds[HDSP_MAX_CHANNELS] = {
 	/* ADAT */
 	1, 3, 5, 7,
 	/* SPDIF */
@@ -553,7 +553,7 @@ static const char channel_map_H9632_ds[HDSP_MAX_CHANNELS] = {
 	-1, -1, -1, -1, -1, -1
 };
 
-static const char channel_map_H9632_qs[HDSP_MAX_CHANNELS] = {
+static const signed char channel_map_H9632_qs[HDSP_MAX_CHANNELS] = {
 	/* ADAT is disabled in this mode */
 	/* SPDIF */
 	8, 9,
@@ -3869,7 +3869,7 @@ static snd_pcm_uframes_t snd_hdsp_hw_pointer(struct snd_pcm_substream *substream
 	return hdsp_hw_pointer(hdsp);
 }
 
-static char *hdsp_channel_buffer_location(struct hdsp *hdsp,
+static signed char *hdsp_channel_buffer_location(struct hdsp *hdsp,
 					     int stream,
 					     int channel)
 
@@ -3893,7 +3893,7 @@ static int snd_hdsp_playback_copy(struct snd_pcm_substream *substream,
 				  void __user *src, unsigned long count)
 {
 	struct hdsp *hdsp = snd_pcm_substream_chip(substream);
-	char *channel_buf;
+	signed char *channel_buf;
 
 	if (snd_BUG_ON(pos + count > HDSP_CHANNEL_BUFFER_BYTES))
 		return -EINVAL;
@@ -3911,7 +3911,7 @@ static int snd_hdsp_playback_copy_kernel(struct snd_pcm_substream *substream,
 					 void *src, unsigned long count)
 {
 	struct hdsp *hdsp = snd_pcm_substream_chip(substream);
-	char *channel_buf;
+	signed char *channel_buf;
 
 	channel_buf = hdsp_channel_buffer_location(hdsp, substream->pstr->stream, channel);
 	if (snd_BUG_ON(!channel_buf))
@@ -3925,7 +3925,7 @@ static int snd_hdsp_capture_copy(struct snd_pcm_substream *substream,
 				 void __user *dst, unsigned long count)
 {
 	struct hdsp *hdsp = snd_pcm_substream_chip(substream);
-	char *channel_buf;
+	signed char *channel_buf;
 
 	if (snd_BUG_ON(pos + count > HDSP_CHANNEL_BUFFER_BYTES))
 		return -EINVAL;
@@ -3943,7 +3943,7 @@ static int snd_hdsp_capture_copy_kernel(struct snd_pcm_substream *substream,
 					void *dst, unsigned long count)
 {
 	struct hdsp *hdsp = snd_pcm_substream_chip(substream);
-	char *channel_buf;
+	signed char *channel_buf;
 
 	channel_buf = hdsp_channel_buffer_location(hdsp, substream->pstr->stream, channel);
 	if (snd_BUG_ON(!channel_buf))
@@ -3957,7 +3957,7 @@ static int snd_hdsp_hw_silence(struct snd_pcm_substream *substream,
 			       unsigned long count)
 {
 	struct hdsp *hdsp = snd_pcm_substream_chip(substream);
-	char *channel_buf;
+	signed char *channel_buf;
 
 	channel_buf = hdsp_channel_buffer_location (hdsp, substream->pstr->stream, channel);
 	if (snd_BUG_ON(!channel_buf))
diff --git a/sound/pci/rme9652/rme9652.c b/sound/pci/rme9652/rme9652.c
index 8def24673f35..459696844b8c 100644
--- a/sound/pci/rme9652/rme9652.c
+++ b/sound/pci/rme9652/rme9652.c
@@ -229,7 +229,7 @@ struct snd_rme9652 {
 	int last_spdif_sample_rate;	/* so that we can catch externally ... */
 	int last_adat_sample_rate;	/* ... induced rate changes            */
 
-	const char *channel_map;
+	const signed char *channel_map;
 
 	struct snd_card *card;
 	struct snd_pcm *pcm;
@@ -246,12 +246,12 @@ struct snd_rme9652 {
    where the data for that channel can be read/written from/to.
 */
 
-static const char channel_map_9652_ss[26] = {
+static const signed char channel_map_9652_ss[26] = {
 	0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17,
 	18, 19, 20, 21, 22, 23, 24, 25
 };
 
-static const char channel_map_9636_ss[26] = {
+static const signed char channel_map_9636_ss[26] = {
 	0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 
 	/* channels 16 and 17 are S/PDIF */
 	24, 25,
@@ -259,7 +259,7 @@ static const char channel_map_9636_ss[26] = {
 	-1, -1, -1, -1, -1, -1, -1, -1
 };
 
-static const char channel_map_9652_ds[26] = {
+static const signed char channel_map_9652_ds[26] = {
 	/* ADAT channels are remapped */
 	1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23,
 	/* channels 12 and 13 are S/PDIF */
@@ -268,7 +268,7 @@ static const char channel_map_9652_ds[26] = {
 	-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1
 };
 
-static const char channel_map_9636_ds[26] = {
+static const signed char channel_map_9636_ds[26] = {
 	/* ADAT channels are remapped */
 	1, 3, 5, 7, 9, 11, 13, 15,
 	/* channels 8 and 9 are S/PDIF */
@@ -1841,7 +1841,7 @@ static snd_pcm_uframes_t snd_rme9652_hw_pointer(struct snd_pcm_substream *substr
 	return rme9652_hw_pointer(rme9652);
 }
 
-static char *rme9652_channel_buffer_location(struct snd_rme9652 *rme9652,
+static signed char *rme9652_channel_buffer_location(struct snd_rme9652 *rme9652,
 					     int stream,
 					     int channel)
 
@@ -1869,7 +1869,7 @@ static int snd_rme9652_playback_copy(struct snd_pcm_substream *substream,
 				     void __user *src, unsigned long count)
 {
 	struct snd_rme9652 *rme9652 = snd_pcm_substream_chip(substream);
-	char *channel_buf;
+	signed char *channel_buf;
 
 	if (snd_BUG_ON(pos + count > RME9652_CHANNEL_BUFFER_BYTES))
 		return -EINVAL;
@@ -1889,7 +1889,7 @@ static int snd_rme9652_playback_copy_kernel(struct snd_pcm_substream *substream,
 					    void *src, unsigned long count)
 {
 	struct snd_rme9652 *rme9652 = snd_pcm_substream_chip(substream);
-	char *channel_buf;
+	signed char *channel_buf;
 
 	channel_buf = rme9652_channel_buffer_location(rme9652,
 						      substream->pstr->stream,
@@ -1905,7 +1905,7 @@ static int snd_rme9652_capture_copy(struct snd_pcm_substream *substream,
 				    void __user *dst, unsigned long count)
 {
 	struct snd_rme9652 *rme9652 = snd_pcm_substream_chip(substream);
-	char *channel_buf;
+	signed char *channel_buf;
 
 	if (snd_BUG_ON(pos + count > RME9652_CHANNEL_BUFFER_BYTES))
 		return -EINVAL;
@@ -1925,7 +1925,7 @@ static int snd_rme9652_capture_copy_kernel(struct snd_pcm_substream *substream,
 					   void *dst, unsigned long count)
 {
 	struct snd_rme9652 *rme9652 = snd_pcm_substream_chip(substream);
-	char *channel_buf;
+	signed char *channel_buf;
 
 	channel_buf = rme9652_channel_buffer_location(rme9652,
 						      substream->pstr->stream,
@@ -1941,7 +1941,7 @@ static int snd_rme9652_hw_silence(struct snd_pcm_substream *substream,
 				  unsigned long count)
 {
 	struct snd_rme9652 *rme9652 = snd_pcm_substream_chip(substream);
-	char *channel_buf;
+	signed char *channel_buf;
 
 	channel_buf = rme9652_channel_buffer_location (rme9652,
 						       substream->pstr->stream,
diff --git a/sound/soc/qcom/lpass-cpu.c b/sound/soc/qcom/lpass-cpu.c
index 03abb3d719d0..ecd6c049ace2 100644
--- a/sound/soc/qcom/lpass-cpu.c
+++ b/sound/soc/qcom/lpass-cpu.c
@@ -745,10 +745,20 @@ static bool lpass_hdmi_regmap_volatile(struct device *dev, unsigned int reg)
 		return true;
 	if (reg == LPASS_HDMI_TX_LEGACY_ADDR(v))
 		return true;
+	if (reg == LPASS_HDMI_TX_VBIT_CTL_ADDR(v))
+		return true;
+	if (reg == LPASS_HDMI_TX_PARITY_ADDR(v))
+		return true;
 
 	for (i = 0; i < v->hdmi_rdma_channels; ++i) {
 		if (reg == LPAIF_HDMI_RDMACURR_REG(v, i))
 			return true;
+		if (reg == LPASS_HDMI_TX_DMA_ADDR(v, i))
+			return true;
+		if (reg == LPASS_HDMI_TX_CH_LSB_ADDR(v, i))
+			return true;
+		if (reg == LPASS_HDMI_TX_CH_MSB_ADDR(v, i))
+			return true;
 	}
 	return false;
 }
diff --git a/sound/synth/emux/emux.c b/sound/synth/emux/emux.c
index 6695530bba9b..c60ff81390a4 100644
--- a/sound/synth/emux/emux.c
+++ b/sound/synth/emux/emux.c
@@ -125,15 +125,10 @@ EXPORT_SYMBOL(snd_emux_register);
  */
 int snd_emux_free(struct snd_emux *emu)
 {
-	unsigned long flags;
-
 	if (! emu)
 		return -EINVAL;
 
-	spin_lock_irqsave(&emu->voice_lock, flags);
-	if (emu->timer_active)
-		del_timer(&emu->tlist);
-	spin_unlock_irqrestore(&emu->voice_lock, flags);
+	del_timer_sync(&emu->tlist);
 
 	snd_emux_proc_free(emu);
 	snd_emux_delete_virmidi(emu);
diff --git a/tools/iio/iio_utils.c b/tools/iio/iio_utils.c
index 7399eb7f1378..d66b18c54606 100644
--- a/tools/iio/iio_utils.c
+++ b/tools/iio/iio_utils.c
@@ -543,6 +543,10 @@ static int calc_digits(int num)
 {
 	int count = 0;
 
+	/* It takes a digit to represent zero */
+	if (!num)
+		return 1;
+
 	while (num != 0) {
 		num /= 10;
 		count++;
diff --git a/tools/perf/util/auxtrace.c b/tools/perf/util/auxtrace.c
index d3c15b53495d..d96e86ddd2c5 100644
--- a/tools/perf/util/auxtrace.c
+++ b/tools/perf/util/auxtrace.c
@@ -2164,11 +2164,19 @@ struct sym_args {
 	bool		near;
 };
 
+static bool kern_sym_name_match(const char *kname, const char *name)
+{
+	size_t n = strlen(name);
+
+	return !strcmp(kname, name) ||
+	       (!strncmp(kname, name, n) && kname[n] == '\t');
+}
+
 static bool kern_sym_match(struct sym_args *args, const char *name, char type)
 {
 	/* A function with the same name, and global or the n'th found or any */
 	return kallsyms__is_function(type) &&
-	       !strcmp(name, args->name) &&
+	       kern_sym_name_match(name, args->name) &&
 	       ((args->global && isupper(type)) ||
 		(args->selected && ++(args->cnt) == args->idx) ||
 		(!args->global && !args->selected));
