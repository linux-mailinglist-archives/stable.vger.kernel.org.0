Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABDEE4F00DB
	for <lists+stable@lfdr.de>; Sat,  2 Apr 2022 12:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240318AbiDBK6c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Apr 2022 06:58:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354592AbiDBK6a (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Apr 2022 06:58:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4751A16E216;
        Sat,  2 Apr 2022 03:56:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A626DB8069E;
        Sat,  2 Apr 2022 10:56:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7F8DC340EE;
        Sat,  2 Apr 2022 10:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648896988;
        bh=ehauqmbKPSb+wKODTyIT76KlsTPwFErD52eN4HuN+78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PK1Qb3kpPlDZH0e+EB1/YfS6skqT3KZSi1bEtTuIsIyQka3mvryPr+zV5xWmW2yxK
         S3E8CDRMkxS+rvGicWE6MP1HVqsxLgjo4FQT9f2rhg+CDactpzXqHcZModCMr+2aMq
         SWa7yejwktqgoUTLxADFsN6k4cZZV6R81lX55p9I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.14.275
Date:   Sat,  2 Apr 2022 12:56:17 +0200
Message-Id: <1648896976251115@kroah.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <16488969765616@kroah.com>
References: <16488969765616@kroah.com>
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

diff --git a/Documentation/arm64/silicon-errata.txt b/Documentation/arm64/silicon-errata.txt
index e4fe6adc372b..42f5672e8917 100644
--- a/Documentation/arm64/silicon-errata.txt
+++ b/Documentation/arm64/silicon-errata.txt
@@ -56,6 +56,7 @@ stable kernels.
 | ARM            | Cortex-A72      | #853709         | N/A                         |
 | ARM            | Cortex-A73      | #858921         | ARM64_ERRATUM_858921        |
 | ARM            | Cortex-A55      | #1024718        | ARM64_ERRATUM_1024718       |
+| ARM            | Cortex-A76      | #1188873        | ARM64_ERRATUM_1188873       |
 | ARM            | MMU-500         | #841119,#826419 | N/A                         |
 |                |                 |                 |                             |
 | Cavium         | ThunderX ITS    | #22375, #24313  | CAVIUM_ERRATUM_22375        |
diff --git a/Makefile b/Makefile
index a06abc38f35d..cad522127bb9 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 14
-SUBLEVEL = 274
+SUBLEVEL = 275
 EXTRAVERSION =
 NAME = Petit Gorille
 
diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index b60232639984..dbd9615b428c 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -26,6 +26,7 @@
 #include <asm/kvm_asm.h>
 #include <asm/kvm_mmio.h>
 #include <asm/fpstate.h>
+#include <asm/spectre.h>
 #include <kvm/arm_arch_timer.h>
 
 #define __KVM_HAVE_ARCH_INTC_INITIALIZED
@@ -324,4 +325,9 @@ static inline int kvm_arm_have_ssbd(void)
 	return KVM_SSBD_UNKNOWN;
 }
 
+static inline int kvm_arm_get_spectre_bhb_state(void)
+{
+	/* 32bit guests don't need firmware for this */
+	return SPECTRE_VULNERABLE; /* aka SMCCC_RET_NOT_SUPPORTED */
+}
 #endif /* __ARM_KVM_HOST_H__ */
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index e76f74874a42..7605d2f00d55 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -458,6 +458,20 @@ config ARM64_ERRATUM_1024718
 
 	  If unsure, say Y.
 
+config ARM64_ERRATUM_1188873
+	bool "Cortex-A76: MRC read following MRRC read of specific Generic Timer in AArch32 might give incorrect result"
+	default y
+	depends on COMPAT
+	select ARM_ARCH_TIMER_OOL_WORKAROUND
+	help
+	  This option adds work arounds for ARM Cortex-A76 erratum 1188873
+
+	  Affected Cortex-A76 cores (r0p0, r1p0, r2p0) could cause
+	  register corruption when accessing the timer registers from
+	  AArch32 userspace.
+
+	  If unsure, say Y.
+
 config CAVIUM_ERRATUM_22375
 	bool "Cavium erratum 22375, 24313"
 	default y
@@ -858,6 +872,16 @@ config ARM64_SSBD
 
 	  If unsure, say Y.
 
+config MITIGATE_SPECTRE_BRANCH_HISTORY
+	bool "Mitigate Spectre style attacks against branch history" if EXPERT
+	default y
+	depends on HARDEN_BRANCH_PREDICTOR || !KVM
+	help
+	  Speculation attacks against some high-performance processors can
+	  make use of branch history to influence future speculation.
+	  When taking an exception from user-space, a sequence of branches
+	  or a firmware call overwrites the branch history.
+
 menuconfig ARMV8_DEPRECATED
 	bool "Emulate deprecated/obsolete ARMv8 instructions"
 	depends on COMPAT
diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index 02d73d83f0de..6b38f3b3095a 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -103,6 +103,13 @@
 	hint	#20
 	.endm
 
+/*
+ * Clear Branch History instruction
+ */
+	.macro clearbhb
+	hint	#22
+	.endm
+
 /*
  * Sanitise a 64-bit bounded index wrt speculation, returning zero if out
  * of bounds.
@@ -549,4 +556,31 @@ alternative_endif
 .Ldone\@:
 	.endm
 
+	.macro __mitigate_spectre_bhb_loop      tmp
+#ifdef CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY
+alternative_cb  spectre_bhb_patch_loop_iter
+	mov	\tmp, #32		// Patched to correct the immediate
+alternative_cb_end
+.Lspectre_bhb_loop\@:
+	b	. + 4
+	subs	\tmp, \tmp, #1
+	b.ne	.Lspectre_bhb_loop\@
+	dsb	nsh
+	isb
+#endif /* CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY */
+	.endm
+
+	/* Save/restores x0-x3 to the stack */
+	.macro __mitigate_spectre_bhb_fw
+#ifdef CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY
+	stp	x0, x1, [sp, #-16]!
+	stp	x2, x3, [sp, #-16]!
+	mov	w0, #ARM_SMCCC_ARCH_WORKAROUND_3
+alternative_cb	arm64_update_smccc_conduit
+	nop					// Patched to SMC/HVC #0
+alternative_cb_end
+	ldp	x2, x3, [sp], #16
+	ldp	x0, x1, [sp], #16
+#endif /* CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY */
+	.endm
 #endif	/* __ASM_ASSEMBLER_H */
diff --git a/arch/arm64/include/asm/cpu.h b/arch/arm64/include/asm/cpu.h
index 889226b4c6e1..c7f17e663e72 100644
--- a/arch/arm64/include/asm/cpu.h
+++ b/arch/arm64/include/asm/cpu.h
@@ -36,6 +36,7 @@ struct cpuinfo_arm64 {
 	u64		reg_id_aa64dfr1;
 	u64		reg_id_aa64isar0;
 	u64		reg_id_aa64isar1;
+	u64		reg_id_aa64isar2;
 	u64		reg_id_aa64mmfr0;
 	u64		reg_id_aa64mmfr1;
 	u64		reg_id_aa64mmfr2;
diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index 2f8bd0388905..20ca422eb094 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -45,7 +45,9 @@
 #define ARM64_SSBD				25
 #define ARM64_MISMATCHED_CACHE_TYPE		26
 #define ARM64_SSBS				27
+#define ARM64_WORKAROUND_1188873		28
+#define ARM64_SPECTRE_BHB			29
 
-#define ARM64_NCAPS				28
+#define ARM64_NCAPS				30
 
 #endif /* __ASM_CPUCAPS_H */
diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 166f81b7afee..3e9d042d1b1e 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -456,6 +456,34 @@ static inline bool cpu_supports_mixed_endian_el0(void)
 	return id_aa64mmfr0_mixed_endian_el0(read_cpuid(ID_AA64MMFR0_EL1));
 }
 
+static inline bool supports_csv2p3(int scope)
+{
+	u64 pfr0;
+	u8 csv2_val;
+
+	if (scope == SCOPE_LOCAL_CPU)
+		pfr0 = read_sysreg_s(SYS_ID_AA64PFR0_EL1);
+	else
+		pfr0 = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
+
+	csv2_val = cpuid_feature_extract_unsigned_field(pfr0,
+							ID_AA64PFR0_CSV2_SHIFT);
+	return csv2_val == 3;
+}
+
+static inline bool supports_clearbhb(int scope)
+{
+	u64 isar2;
+
+	if (scope == SCOPE_LOCAL_CPU)
+		isar2 = read_sysreg_s(SYS_ID_AA64ISAR2_EL1);
+	else
+		isar2 = read_sanitised_ftr_reg(SYS_ID_AA64ISAR2_EL1);
+
+	return cpuid_feature_extract_unsigned_field(isar2,
+						    ID_AA64ISAR2_CLEARBHB_SHIFT);
+}
+
 static inline bool system_supports_32bit_el0(void)
 {
 	return cpus_have_const_cap(ARM64_HAS_32BIT_EL0);
@@ -495,6 +523,17 @@ static inline int arm64_get_ssbd_state(void)
 
 void arm64_set_ssbd_mitigation(bool state);
 
+/* Watch out, ordering is important here. */
+enum mitigation_state {
+	SPECTRE_UNAFFECTED,
+	SPECTRE_MITIGATED,
+	SPECTRE_VULNERABLE,
+};
+
+enum mitigation_state arm64_get_spectre_bhb_state(void);
+bool is_spectre_bhb_affected(const struct arm64_cpu_capabilities *entry, int scope);
+u8 spectre_bhb_loop_affected(int scope);
+void spectre_bhb_enable_mitigation(const struct arm64_cpu_capabilities *__unused);
 #endif /* __ASSEMBLY__ */
 
 #endif
diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index b23456035eac..401088d9cd82 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -87,6 +87,16 @@
 #define ARM_CPU_PART_CORTEX_A75		0xD0A
 #define ARM_CPU_PART_CORTEX_A35		0xD04
 #define ARM_CPU_PART_CORTEX_A55		0xD05
+#define ARM_CPU_PART_CORTEX_A76		0xD0B
+#define ARM_CPU_PART_NEOVERSE_N1	0xD0C
+#define ARM_CPU_PART_CORTEX_A77		0xD0D
+#define ARM_CPU_PART_NEOVERSE_V1	0xD40
+#define ARM_CPU_PART_CORTEX_A78		0xD41
+#define ARM_CPU_PART_CORTEX_X1		0xD44
+#define ARM_CPU_PART_CORTEX_A710	0xD47
+#define ARM_CPU_PART_CORTEX_X2		0xD48
+#define ARM_CPU_PART_NEOVERSE_N2	0xD49
+#define ARM_CPU_PART_CORTEX_A78C	0xD4B
 
 #define APM_CPU_PART_POTENZA		0x000
 
@@ -112,6 +122,16 @@
 #define MIDR_CORTEX_A75 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A75)
 #define MIDR_CORTEX_A35 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A35)
 #define MIDR_CORTEX_A55 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A55)
+#define MIDR_CORTEX_A76	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A76)
+#define MIDR_NEOVERSE_N1 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_N1)
+#define MIDR_CORTEX_A77	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A77)
+#define MIDR_NEOVERSE_V1	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_V1)
+#define MIDR_CORTEX_A78	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A78)
+#define MIDR_CORTEX_X1	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_X1)
+#define MIDR_CORTEX_A710 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A710)
+#define MIDR_CORTEX_X2 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_X2)
+#define MIDR_NEOVERSE_N2 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_N2)
+#define MIDR_CORTEX_A78C	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A78C)
 #define MIDR_THUNDERX	MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX)
 #define MIDR_THUNDERX_81XX MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX_81XX)
 #define MIDR_THUNDERX_83XX MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX_83XX)
diff --git a/arch/arm64/include/asm/fixmap.h b/arch/arm64/include/asm/fixmap.h
index ec1e6d6fa14c..3c962ef081f8 100644
--- a/arch/arm64/include/asm/fixmap.h
+++ b/arch/arm64/include/asm/fixmap.h
@@ -59,9 +59,11 @@ enum fixed_addresses {
 #endif /* CONFIG_ACPI_APEI_GHES */
 
 #ifdef CONFIG_UNMAP_KERNEL_AT_EL0
+	FIX_ENTRY_TRAMP_TEXT3,
+	FIX_ENTRY_TRAMP_TEXT2,
+	FIX_ENTRY_TRAMP_TEXT1,
 	FIX_ENTRY_TRAMP_DATA,
-	FIX_ENTRY_TRAMP_TEXT,
-#define TRAMP_VALIAS		(__fix_to_virt(FIX_ENTRY_TRAMP_TEXT))
+#define TRAMP_VALIAS		(__fix_to_virt(FIX_ENTRY_TRAMP_TEXT1))
 #endif /* CONFIG_UNMAP_KERNEL_AT_EL0 */
 	__end_of_permanent_fixed_addresses,
 
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 8d94404829f0..be82119ed24a 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -450,4 +450,9 @@ static inline int kvm_arm_have_ssbd(void)
 	}
 }
 
+static inline enum mitigation_state kvm_arm_get_spectre_bhb_state(void)
+{
+	return arm64_get_spectre_bhb_state();
+}
+
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 47ba6a57dc45..04c7c4596240 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -358,7 +358,7 @@ static inline void *kvm_get_hyp_vector(void)
 	struct bp_hardening_data *data = arm64_get_bp_hardening_data();
 	void *vect = kvm_ksym_ref(__kvm_hyp_vector);
 
-	if (data->fn) {
+	if (data->template_start) {
 		vect = __bp_harden_hyp_vecs_start +
 		       data->hyp_vectors_slot * SZ_2K;
 
diff --git a/arch/arm64/include/asm/mmu.h b/arch/arm64/include/asm/mmu.h
index 6dd83d75b82a..5a77dc775cc3 100644
--- a/arch/arm64/include/asm/mmu.h
+++ b/arch/arm64/include/asm/mmu.h
@@ -35,7 +35,7 @@ typedef struct {
  */
 #define ASID(mm)	((mm)->context.id.counter & 0xffff)
 
-static inline bool arm64_kernel_unmapped_at_el0(void)
+static __always_inline bool arm64_kernel_unmapped_at_el0(void)
 {
 	return IS_ENABLED(CONFIG_UNMAP_KERNEL_AT_EL0) &&
 	       cpus_have_const_cap(ARM64_UNMAP_KERNEL_AT_EL0);
@@ -46,6 +46,12 @@ typedef void (*bp_hardening_cb_t)(void);
 struct bp_hardening_data {
 	int			hyp_vectors_slot;
 	bp_hardening_cb_t	fn;
+
+	/*
+	 * template_start is only used by the BHB mitigation to identify the
+	 * hyp_vectors_slot sequence.
+	 */
+	const char *template_start;
 };
 
 #ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
diff --git a/arch/arm64/include/asm/sections.h b/arch/arm64/include/asm/sections.h
index 941267caa39c..8d3f1eab58e0 100644
--- a/arch/arm64/include/asm/sections.h
+++ b/arch/arm64/include/asm/sections.h
@@ -28,5 +28,11 @@ extern char __initdata_begin[], __initdata_end[];
 extern char __inittext_begin[], __inittext_end[];
 extern char __irqentry_text_start[], __irqentry_text_end[];
 extern char __mmuoff_data_start[], __mmuoff_data_end[];
+extern char __entry_tramp_text_start[], __entry_tramp_text_end[];
+
+static inline size_t entry_tramp_text_size(void)
+{
+	return __entry_tramp_text_end - __entry_tramp_text_start;
+}
 
 #endif /* __ASM_SECTIONS_H */
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 2564dd429ab6..3bbf0dc5ecad 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -157,6 +157,7 @@
 
 #define SYS_ID_AA64ISAR0_EL1		sys_reg(3, 0, 0, 6, 0)
 #define SYS_ID_AA64ISAR1_EL1		sys_reg(3, 0, 0, 6, 1)
+#define SYS_ID_AA64ISAR2_EL1		sys_reg(3, 0, 0, 6, 2)
 
 #define SYS_ID_AA64MMFR0_EL1		sys_reg(3, 0, 0, 7, 0)
 #define SYS_ID_AA64MMFR1_EL1		sys_reg(3, 0, 0, 7, 1)
@@ -403,6 +404,9 @@
 #define ID_AA64ISAR1_JSCVT_SHIFT	12
 #define ID_AA64ISAR1_DPB_SHIFT		0
 
+/* id_aa64isar2 */
+#define ID_AA64ISAR2_CLEARBHB_SHIFT	28
+
 /* id_aa64pfr0 */
 #define ID_AA64PFR0_CSV3_SHIFT		60
 #define ID_AA64PFR0_CSV2_SHIFT		56
@@ -448,6 +452,7 @@
 #define ID_AA64MMFR0_TGRAN16_SUPPORTED	0x1
 
 /* id_aa64mmfr1 */
+#define ID_AA64MMFR1_ECBHB_SHIFT	60
 #define ID_AA64MMFR1_PAN_SHIFT		20
 #define ID_AA64MMFR1_LOR_SHIFT		16
 #define ID_AA64MMFR1_HPD_SHIFT		12
diff --git a/arch/arm64/include/asm/vectors.h b/arch/arm64/include/asm/vectors.h
new file mode 100644
index 000000000000..695583b9a145
--- /dev/null
+++ b/arch/arm64/include/asm/vectors.h
@@ -0,0 +1,74 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2022 ARM Ltd.
+ */
+#ifndef __ASM_VECTORS_H
+#define __ASM_VECTORS_H
+
+#include <linux/bug.h>
+#include <linux/percpu.h>
+
+#include <asm/fixmap.h>
+#include <asm/mmu.h>
+
+extern char vectors[];
+extern char tramp_vectors[];
+extern char __bp_harden_el1_vectors[];
+
+/*
+ * Note: the order of this enum corresponds to two arrays in entry.S:
+ * tramp_vecs and __bp_harden_el1_vectors. By default the canonical
+ * 'full fat' vectors are used directly.
+ */
+enum arm64_bp_harden_el1_vectors {
+#ifdef CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY
+	/*
+	 * Perform the BHB loop mitigation, before branching to the canonical
+	 * vectors.
+	 */
+	EL1_VECTOR_BHB_LOOP,
+
+	/*
+	 * Make the SMC call for firmware mitigation, before branching to the
+	 * canonical vectors.
+	 */
+	EL1_VECTOR_BHB_FW,
+
+	/*
+	 * Use the ClearBHB instruction, before branching to the canonical
+	 * vectors.
+	 */
+	EL1_VECTOR_BHB_CLEAR_INSN,
+#endif /* CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY */
+
+	/*
+	 * Remap the kernel before branching to the canonical vectors.
+	 */
+	EL1_VECTOR_KPTI,
+};
+
+#ifndef CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY
+#define EL1_VECTOR_BHB_LOOP		-1
+#define EL1_VECTOR_BHB_FW		-1
+#define EL1_VECTOR_BHB_CLEAR_INSN	-1
+#endif /* !CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY */
+
+/* The vectors to use on return from EL0. e.g. to remap the kernel */
+DECLARE_PER_CPU_READ_MOSTLY(const char *, this_cpu_vector);
+
+#ifndef CONFIG_UNMAP_KERNEL_AT_EL0
+#define TRAMP_VALIAS	0
+#endif
+
+static inline const char *
+arm64_get_bp_hardening_vector(enum arm64_bp_harden_el1_vectors slot)
+{
+	if (arm64_kernel_unmapped_at_el0())
+		return (char *)TRAMP_VALIAS + SZ_2K * slot;
+
+	WARN_ON_ONCE(slot == EL1_VECTOR_KPTI);
+
+	return __bp_harden_el1_vectors + SZ_2K * slot;
+}
+
+#endif /* __ASM_VECTORS_H */
diff --git a/arch/arm64/kernel/bpi.S b/arch/arm64/kernel/bpi.S
index 4cae34e5a24e..bd6ef8750f44 100644
--- a/arch/arm64/kernel/bpi.S
+++ b/arch/arm64/kernel/bpi.S
@@ -66,3 +66,58 @@ ENTRY(__smccc_workaround_1_smc_start)
 	ldp	x0, x1, [sp, #(8 * 2)]
 	add	sp, sp, #(8 * 4)
 ENTRY(__smccc_workaround_1_smc_end)
+
+ENTRY(__smccc_workaround_3_smc_start)
+	sub     sp, sp, #(8 * 4)
+	stp     x2, x3, [sp, #(8 * 0)]
+	stp     x0, x1, [sp, #(8 * 2)]
+	mov     w0, #ARM_SMCCC_ARCH_WORKAROUND_3
+	smc     #0
+	ldp     x2, x3, [sp, #(8 * 0)]
+	ldp     x0, x1, [sp, #(8 * 2)]
+	add     sp, sp, #(8 * 4)
+ENTRY(__smccc_workaround_3_smc_end)
+
+ENTRY(__spectre_bhb_loop_k8_start)
+	sub     sp, sp, #(8 * 2)
+	stp     x0, x1, [sp, #(8 * 0)]
+	mov     x0, #8
+2:	b       . + 4
+	subs    x0, x0, #1
+	b.ne    2b
+	dsb     nsh
+	isb
+	ldp     x0, x1, [sp, #(8 * 0)]
+	add     sp, sp, #(8 * 2)
+ENTRY(__spectre_bhb_loop_k8_end)
+
+ENTRY(__spectre_bhb_loop_k24_start)
+	sub     sp, sp, #(8 * 2)
+	stp     x0, x1, [sp, #(8 * 0)]
+	mov     x0, #24
+2:	b       . + 4
+	subs    x0, x0, #1
+	b.ne    2b
+	dsb     nsh
+	isb
+	ldp     x0, x1, [sp, #(8 * 0)]
+	add     sp, sp, #(8 * 2)
+ENTRY(__spectre_bhb_loop_k24_end)
+
+ENTRY(__spectre_bhb_loop_k32_start)
+	sub     sp, sp, #(8 * 2)
+	stp     x0, x1, [sp, #(8 * 0)]
+	mov     x0, #32
+2:	b       . + 4
+	subs    x0, x0, #1
+	b.ne    2b
+	dsb     nsh
+	isb
+	ldp     x0, x1, [sp, #(8 * 0)]
+	add     sp, sp, #(8 * 2)
+ENTRY(__spectre_bhb_loop_k32_end)
+
+ENTRY(__spectre_bhb_clearbhb_start)
+	hint	#22	/* aka clearbhb */
+	isb
+ENTRY(__spectre_bhb_clearbhb_end)
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 7d15f4cb6393..ed627d44746a 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -23,6 +23,7 @@
 #include <asm/cpu.h>
 #include <asm/cputype.h>
 #include <asm/cpufeature.h>
+#include <asm/vectors.h>
 
 static bool __maybe_unused
 is_affected_midr_range(const struct arm64_cpu_capabilities *entry, int scope)
@@ -85,6 +86,16 @@ DEFINE_PER_CPU_READ_MOSTLY(struct bp_hardening_data, bp_hardening_data);
 #ifdef CONFIG_KVM
 extern char __smccc_workaround_1_smc_start[];
 extern char __smccc_workaround_1_smc_end[];
+extern char __smccc_workaround_3_smc_start[];
+extern char __smccc_workaround_3_smc_end[];
+extern char __spectre_bhb_loop_k8_start[];
+extern char __spectre_bhb_loop_k8_end[];
+extern char __spectre_bhb_loop_k24_start[];
+extern char __spectre_bhb_loop_k24_end[];
+extern char __spectre_bhb_loop_k32_start[];
+extern char __spectre_bhb_loop_k32_end[];
+extern char __spectre_bhb_clearbhb_start[];
+extern char __spectre_bhb_clearbhb_end[];
 
 static void __copy_hyp_vect_bpi(int slot, const char *hyp_vecs_start,
 				const char *hyp_vecs_end)
@@ -98,12 +109,14 @@ static void __copy_hyp_vect_bpi(int slot, const char *hyp_vecs_start,
 	flush_icache_range((uintptr_t)dst, (uintptr_t)dst + SZ_2K);
 }
 
+static DEFINE_SPINLOCK(bp_lock);
+static int last_slot = -1;
+
 static void install_bp_hardening_cb(bp_hardening_cb_t fn,
 				    const char *hyp_vecs_start,
 				    const char *hyp_vecs_end)
 {
-	static int last_slot = -1;
-	static DEFINE_SPINLOCK(bp_lock);
+
 	int cpu, slot = -1;
 
 	spin_lock(&bp_lock);
@@ -124,6 +137,7 @@ static void install_bp_hardening_cb(bp_hardening_cb_t fn,
 
 	__this_cpu_write(bp_hardening_data.hyp_vectors_slot, slot);
 	__this_cpu_write(bp_hardening_data.fn, fn);
+	__this_cpu_write(bp_hardening_data.template_start, hyp_vecs_start);
 	spin_unlock(&bp_lock);
 }
 #else
@@ -712,6 +726,21 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		.matches = has_ssbd_mitigation,
 		.midr_range_list = arm64_ssb_cpus,
 	},
+#ifdef CONFIG_ARM64_ERRATUM_1188873
+	{
+		/* Cortex-A76 r0p0 to r2p0 */
+		.desc = "ARM erratum 1188873",
+		.capability = ARM64_WORKAROUND_1188873,
+		ERRATA_MIDR_RANGE(MIDR_CORTEX_A76, 0, 0, 2, 0),
+	},
+#endif
+	{
+		.desc = "Spectre-BHB",
+		.capability = ARM64_SPECTRE_BHB,
+		.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
+		.matches = is_spectre_bhb_affected,
+		.cpu_enable = spectre_bhb_enable_mitigation,
+	},
 	{
 	}
 };
@@ -722,14 +751,39 @@ ssize_t cpu_show_spectre_v1(struct device *dev, struct device_attribute *attr,
 	return sprintf(buf, "Mitigation: __user pointer sanitization\n");
 }
 
+static const char *get_bhb_affected_string(enum mitigation_state bhb_state)
+{
+	switch (bhb_state) {
+	case SPECTRE_UNAFFECTED:
+		return "";
+	default:
+	case SPECTRE_VULNERABLE:
+		return ", but not BHB";
+	case SPECTRE_MITIGATED:
+		return ", BHB";
+	}
+}
+
 ssize_t cpu_show_spectre_v2(struct device *dev, struct device_attribute *attr,
 		char *buf)
 {
-	if (__spectrev2_safe)
-		return sprintf(buf, "Not affected\n");
+	enum mitigation_state bhb_state = arm64_get_spectre_bhb_state();
+	const char *bhb_str = get_bhb_affected_string(bhb_state);
+	const char *v2_str = "Branch predictor hardening";
+
+	if (__spectrev2_safe) {
+		if (bhb_state == SPECTRE_UNAFFECTED)
+			return sprintf(buf, "Not affected\n");
+
+		/*
+		 * Platforms affected by Spectre-BHB can't report
+		 * "Not affected" for Spectre-v2.
+		 */
+		v2_str = "CSV2";
+	}
 
 	if (__hardenbp_enab)
-		return sprintf(buf, "Mitigation: Branch predictor hardening\n");
+		return sprintf(buf, "Mitigation: %s%s\n", v2_str, bhb_str);
 
 	return sprintf(buf, "Vulnerable\n");
 }
@@ -750,3 +804,334 @@ ssize_t cpu_show_spec_store_bypass(struct device *dev,
 
 	return sprintf(buf, "Vulnerable\n");
 }
+
+/*
+ * We try to ensure that the mitigation state can never change as the result of
+ * onlining a late CPU.
+ */
+static void update_mitigation_state(enum mitigation_state *oldp,
+				    enum mitigation_state new)
+{
+	enum mitigation_state state;
+
+	do {
+		state = READ_ONCE(*oldp);
+		if (new <= state)
+			break;
+	} while (cmpxchg_relaxed(oldp, state, new) != state);
+}
+
+/*
+ * Spectre BHB.
+ *
+ * A CPU is either:
+ * - Mitigated by a branchy loop a CPU specific number of times, and listed
+ *   in our "loop mitigated list".
+ * - Mitigated in software by the firmware Spectre v2 call.
+ * - Has the ClearBHB instruction to perform the mitigation.
+ * - Has the 'Exception Clears Branch History Buffer' (ECBHB) feature, so no
+ *   software mitigation in the vectors is needed.
+ * - Has CSV2.3, so is unaffected.
+ */
+static enum mitigation_state spectre_bhb_state;
+
+enum mitigation_state arm64_get_spectre_bhb_state(void)
+{
+	return spectre_bhb_state;
+}
+
+/*
+ * This must be called with SCOPE_LOCAL_CPU for each type of CPU, before any
+ * SCOPE_SYSTEM call will give the right answer.
+ */
+u8 spectre_bhb_loop_affected(int scope)
+{
+	u8 k = 0;
+	static u8 max_bhb_k;
+
+	if (scope == SCOPE_LOCAL_CPU) {
+		static const struct midr_range spectre_bhb_k32_list[] = {
+			MIDR_ALL_VERSIONS(MIDR_CORTEX_A78),
+			MIDR_ALL_VERSIONS(MIDR_CORTEX_A78C),
+			MIDR_ALL_VERSIONS(MIDR_CORTEX_X1),
+			MIDR_ALL_VERSIONS(MIDR_CORTEX_A710),
+			MIDR_ALL_VERSIONS(MIDR_CORTEX_X2),
+			MIDR_ALL_VERSIONS(MIDR_NEOVERSE_N2),
+			MIDR_ALL_VERSIONS(MIDR_NEOVERSE_V1),
+			{},
+		};
+		static const struct midr_range spectre_bhb_k24_list[] = {
+			MIDR_ALL_VERSIONS(MIDR_CORTEX_A77),
+			MIDR_ALL_VERSIONS(MIDR_CORTEX_A76),
+			MIDR_ALL_VERSIONS(MIDR_NEOVERSE_N1),
+			{},
+		};
+		static const struct midr_range spectre_bhb_k8_list[] = {
+			MIDR_ALL_VERSIONS(MIDR_CORTEX_A72),
+			MIDR_ALL_VERSIONS(MIDR_CORTEX_A57),
+			{},
+		};
+
+		if (is_midr_in_range_list(read_cpuid_id(), spectre_bhb_k32_list))
+			k = 32;
+		else if (is_midr_in_range_list(read_cpuid_id(), spectre_bhb_k24_list))
+			k = 24;
+		else if (is_midr_in_range_list(read_cpuid_id(), spectre_bhb_k8_list))
+			k =  8;
+
+		max_bhb_k = max(max_bhb_k, k);
+	} else {
+		k = max_bhb_k;
+	}
+
+	return k;
+}
+
+static enum mitigation_state spectre_bhb_get_cpu_fw_mitigation_state(void)
+{
+	int ret;
+	struct arm_smccc_res res;
+
+	if (psci_ops.smccc_version == SMCCC_VERSION_1_0)
+		return SPECTRE_VULNERABLE;
+
+	switch (psci_ops.conduit) {
+	case PSCI_CONDUIT_HVC:
+		arm_smccc_1_1_hvc(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
+				  ARM_SMCCC_ARCH_WORKAROUND_3, &res);
+		break;
+
+	case PSCI_CONDUIT_SMC:
+		arm_smccc_1_1_smc(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
+				  ARM_SMCCC_ARCH_WORKAROUND_3, &res);
+		break;
+
+	default:
+		return SPECTRE_VULNERABLE;
+	}
+
+	ret = res.a0;
+	switch (ret) {
+	case SMCCC_RET_SUCCESS:
+		return SPECTRE_MITIGATED;
+	case SMCCC_ARCH_WORKAROUND_RET_UNAFFECTED:
+		return SPECTRE_UNAFFECTED;
+	default:
+	case SMCCC_RET_NOT_SUPPORTED:
+		return SPECTRE_VULNERABLE;
+	}
+}
+
+static bool is_spectre_bhb_fw_affected(int scope)
+{
+	static bool system_affected;
+	enum mitigation_state fw_state;
+	bool has_smccc = (psci_ops.smccc_version >= SMCCC_VERSION_1_1);
+	static const struct midr_range spectre_bhb_firmware_mitigated_list[] = {
+		MIDR_ALL_VERSIONS(MIDR_CORTEX_A73),
+		MIDR_ALL_VERSIONS(MIDR_CORTEX_A75),
+		{},
+	};
+	bool cpu_in_list = is_midr_in_range_list(read_cpuid_id(),
+					 spectre_bhb_firmware_mitigated_list);
+
+	if (scope != SCOPE_LOCAL_CPU)
+		return system_affected;
+
+	fw_state = spectre_bhb_get_cpu_fw_mitigation_state();
+	if (cpu_in_list || (has_smccc && fw_state == SPECTRE_MITIGATED)) {
+		system_affected = true;
+		return true;
+	}
+
+	return false;
+}
+
+static bool supports_ecbhb(int scope)
+{
+	u64 mmfr1;
+
+	if (scope == SCOPE_LOCAL_CPU)
+		mmfr1 = read_sysreg_s(SYS_ID_AA64MMFR1_EL1);
+	else
+		mmfr1 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
+
+	return cpuid_feature_extract_unsigned_field(mmfr1,
+						    ID_AA64MMFR1_ECBHB_SHIFT);
+}
+
+bool is_spectre_bhb_affected(const struct arm64_cpu_capabilities *entry,
+			     int scope)
+{
+	WARN_ON(scope != SCOPE_LOCAL_CPU || preemptible());
+
+	if (supports_csv2p3(scope))
+		return false;
+
+	if (supports_clearbhb(scope))
+		return true;
+
+	if (spectre_bhb_loop_affected(scope))
+		return true;
+
+	if (is_spectre_bhb_fw_affected(scope))
+		return true;
+
+	return false;
+}
+
+static void this_cpu_set_vectors(enum arm64_bp_harden_el1_vectors slot)
+{
+	const char *v = arm64_get_bp_hardening_vector(slot);
+
+	if (slot < 0)
+		return;
+
+	__this_cpu_write(this_cpu_vector, v);
+
+	/*
+	 * When KPTI is in use, the vectors are switched when exiting to
+	 * user-space.
+	 */
+	if (arm64_kernel_unmapped_at_el0())
+		return;
+
+	write_sysreg(v, vbar_el1);
+	isb();
+}
+
+#ifdef CONFIG_KVM
+static const char *kvm_bhb_get_vecs_end(const char *start)
+{
+	if (start == __smccc_workaround_3_smc_start)
+		return __smccc_workaround_3_smc_end;
+	else if (start == __spectre_bhb_loop_k8_start)
+		return __spectre_bhb_loop_k8_end;
+	else if (start == __spectre_bhb_loop_k24_start)
+		return __spectre_bhb_loop_k24_end;
+	else if (start == __spectre_bhb_loop_k32_start)
+		return __spectre_bhb_loop_k32_end;
+	else if (start == __spectre_bhb_clearbhb_start)
+		return __spectre_bhb_clearbhb_end;
+
+	return NULL;
+}
+
+static void kvm_setup_bhb_slot(const char *hyp_vecs_start)
+{
+	int cpu, slot = -1;
+	const char *hyp_vecs_end;
+
+	if (!IS_ENABLED(CONFIG_KVM) || !is_hyp_mode_available())
+		return;
+
+	hyp_vecs_end = kvm_bhb_get_vecs_end(hyp_vecs_start);
+	if (WARN_ON_ONCE(!hyp_vecs_start || !hyp_vecs_end))
+		return;
+
+	spin_lock(&bp_lock);
+	for_each_possible_cpu(cpu) {
+		if (per_cpu(bp_hardening_data.template_start, cpu) == hyp_vecs_start) {
+			slot = per_cpu(bp_hardening_data.hyp_vectors_slot, cpu);
+			break;
+		}
+	}
+
+	if (slot == -1) {
+		last_slot++;
+		BUG_ON(((__bp_harden_hyp_vecs_end - __bp_harden_hyp_vecs_start)
+			/ SZ_2K) <= last_slot);
+		slot = last_slot;
+		__copy_hyp_vect_bpi(slot, hyp_vecs_start, hyp_vecs_end);
+	}
+
+	__this_cpu_write(bp_hardening_data.hyp_vectors_slot, slot);
+	__this_cpu_write(bp_hardening_data.template_start, hyp_vecs_start);
+	spin_unlock(&bp_lock);
+}
+#else
+#define __smccc_workaround_3_smc_start NULL
+#define __spectre_bhb_loop_k8_start NULL
+#define __spectre_bhb_loop_k24_start NULL
+#define __spectre_bhb_loop_k32_start NULL
+#define __spectre_bhb_clearbhb_start NULL
+
+static void kvm_setup_bhb_slot(const char *hyp_vecs_start) { };
+#endif
+
+void spectre_bhb_enable_mitigation(const struct arm64_cpu_capabilities *entry)
+{
+	enum mitigation_state fw_state, state = SPECTRE_VULNERABLE;
+
+	if (!is_spectre_bhb_affected(entry, SCOPE_LOCAL_CPU))
+		return;
+
+	if (!__spectrev2_safe &&  !__hardenbp_enab) {
+		/* No point mitigating Spectre-BHB alone. */
+	} else if (!IS_ENABLED(CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY)) {
+		pr_info_once("spectre-bhb mitigation disabled by compile time option\n");
+	} else if (cpu_mitigations_off()) {
+		pr_info_once("spectre-bhb mitigation disabled by command line option\n");
+	} else if (supports_ecbhb(SCOPE_LOCAL_CPU)) {
+		state = SPECTRE_MITIGATED;
+	} else if (supports_clearbhb(SCOPE_LOCAL_CPU)) {
+		kvm_setup_bhb_slot(__spectre_bhb_clearbhb_start);
+		this_cpu_set_vectors(EL1_VECTOR_BHB_CLEAR_INSN);
+
+		state = SPECTRE_MITIGATED;
+	} else if (spectre_bhb_loop_affected(SCOPE_LOCAL_CPU)) {
+		switch (spectre_bhb_loop_affected(SCOPE_SYSTEM)) {
+		case 8:
+			kvm_setup_bhb_slot(__spectre_bhb_loop_k8_start);
+			break;
+		case 24:
+			kvm_setup_bhb_slot(__spectre_bhb_loop_k24_start);
+			break;
+		case 32:
+			kvm_setup_bhb_slot(__spectre_bhb_loop_k32_start);
+			break;
+		default:
+			WARN_ON_ONCE(1);
+		}
+		this_cpu_set_vectors(EL1_VECTOR_BHB_LOOP);
+
+		state = SPECTRE_MITIGATED;
+	} else if (is_spectre_bhb_fw_affected(SCOPE_LOCAL_CPU)) {
+		fw_state = spectre_bhb_get_cpu_fw_mitigation_state();
+		if (fw_state == SPECTRE_MITIGATED) {
+			kvm_setup_bhb_slot(__smccc_workaround_3_smc_start);
+			this_cpu_set_vectors(EL1_VECTOR_BHB_FW);
+
+			/*
+			 * With WA3 in the vectors, the WA1 calls can be
+			 * removed.
+			 */
+			__this_cpu_write(bp_hardening_data.fn, NULL);
+
+			state = SPECTRE_MITIGATED;
+		}
+	}
+
+	update_mitigation_state(&spectre_bhb_state, state);
+}
+
+/* Patched to correct the immediate */
+void __init spectre_bhb_patch_loop_iter(struct alt_instr *alt,
+					__le32 *origptr, __le32 *updptr, int nr_inst)
+{
+	u8 rd;
+	u32 insn;
+	u16 loop_count = spectre_bhb_loop_affected(SCOPE_SYSTEM);
+
+	BUG_ON(nr_inst != 1); /* MOV -> MOV */
+
+	if (!IS_ENABLED(CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY))
+		return;
+
+	insn = le32_to_cpu(*origptr);
+	rd = aarch64_insn_decode_register(AARCH64_INSN_REGTYPE_RD, insn);
+	insn = aarch64_insn_gen_movewide(rd, loop_count, 0,
+					 AARCH64_INSN_VARIANT_64BIT,
+					 AARCH64_INSN_MOVEWIDE_ZERO);
+	*updptr++ = cpu_to_le32(insn);
+}
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 1481e18aa5ca..b6922f33d306 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -20,11 +20,13 @@
 
 #include <linux/bsearch.h>
 #include <linux/cpumask.h>
+#include <linux/percpu.h>
 #include <linux/sort.h>
 #include <linux/stop_machine.h>
 #include <linux/types.h>
 #include <linux/mm.h>
 #include <linux/cpu.h>
+
 #include <asm/cpu.h>
 #include <asm/cpufeature.h>
 #include <asm/cpu_ops.h>
@@ -32,6 +34,7 @@
 #include <asm/processor.h>
 #include <asm/sysreg.h>
 #include <asm/traps.h>
+#include <asm/vectors.h>
 #include <asm/virt.h>
 
 unsigned long elf_hwcap __read_mostly;
@@ -50,6 +53,8 @@ unsigned int compat_elf_hwcap2 __read_mostly;
 DECLARE_BITMAP(cpu_hwcaps, ARM64_NCAPS);
 EXPORT_SYMBOL(cpu_hwcaps);
 
+DEFINE_PER_CPU_READ_MOSTLY(const char *, this_cpu_vector) = vectors;
+
 static int dump_cpu_hwcaps(struct notifier_block *self, unsigned long v, void *p)
 {
 	/* file-wide pr_fmt adds "CPU features: " prefix */
@@ -129,6 +134,11 @@ static const struct arm64_ftr_bits ftr_id_aa64isar1[] = {
 	ARM64_FTR_END,
 };
 
+static const struct arm64_ftr_bits ftr_id_aa64isar2[] = {
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_HIGHER_SAFE, ID_AA64ISAR2_CLEARBHB_SHIFT, 4, 0),
+	ARM64_FTR_END,
+};
+
 static const struct arm64_ftr_bits ftr_id_aa64pfr0[] = {
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR0_CSV3_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR0_CSV2_SHIFT, 4, 0),
@@ -356,6 +366,7 @@ static const struct __ftr_reg_entry {
 	/* Op1 = 0, CRn = 0, CRm = 6 */
 	ARM64_FTR_REG(SYS_ID_AA64ISAR0_EL1, ftr_id_aa64isar0),
 	ARM64_FTR_REG(SYS_ID_AA64ISAR1_EL1, ftr_id_aa64isar1),
+	ARM64_FTR_REG(SYS_ID_AA64ISAR2_EL1, ftr_id_aa64isar2),
 
 	/* Op1 = 0, CRn = 0, CRm = 7 */
 	ARM64_FTR_REG(SYS_ID_AA64MMFR0_EL1, ftr_id_aa64mmfr0),
@@ -501,6 +512,7 @@ void __init init_cpu_features(struct cpuinfo_arm64 *info)
 	init_cpu_ftr_reg(SYS_ID_AA64DFR1_EL1, info->reg_id_aa64dfr1);
 	init_cpu_ftr_reg(SYS_ID_AA64ISAR0_EL1, info->reg_id_aa64isar0);
 	init_cpu_ftr_reg(SYS_ID_AA64ISAR1_EL1, info->reg_id_aa64isar1);
+	init_cpu_ftr_reg(SYS_ID_AA64ISAR2_EL1, info->reg_id_aa64isar2);
 	init_cpu_ftr_reg(SYS_ID_AA64MMFR0_EL1, info->reg_id_aa64mmfr0);
 	init_cpu_ftr_reg(SYS_ID_AA64MMFR1_EL1, info->reg_id_aa64mmfr1);
 	init_cpu_ftr_reg(SYS_ID_AA64MMFR2_EL1, info->reg_id_aa64mmfr2);
@@ -612,6 +624,8 @@ void update_cpu_features(int cpu,
 				      info->reg_id_aa64isar0, boot->reg_id_aa64isar0);
 	taint |= check_update_ftr_reg(SYS_ID_AA64ISAR1_EL1, cpu,
 				      info->reg_id_aa64isar1, boot->reg_id_aa64isar1);
+	taint |= check_update_ftr_reg(SYS_ID_AA64ISAR2_EL1, cpu,
+				      info->reg_id_aa64isar2, boot->reg_id_aa64isar2);
 
 	/*
 	 * Differing PARange support is fine as long as all peripherals and
@@ -732,6 +746,7 @@ static u64 __read_sysreg_by_encoding(u32 sys_id)
 	read_sysreg_case(SYS_ID_AA64MMFR2_EL1);
 	read_sysreg_case(SYS_ID_AA64ISAR0_EL1);
 	read_sysreg_case(SYS_ID_AA64ISAR1_EL1);
+	read_sysreg_case(SYS_ID_AA64ISAR2_EL1);
 
 	read_sysreg_case(SYS_CNTFRQ_EL0);
 	read_sysreg_case(SYS_CTR_EL0);
@@ -892,6 +907,12 @@ kpti_install_ng_mappings(const struct arm64_cpu_capabilities *__unused)
 	static bool kpti_applied = false;
 	int cpu = smp_processor_id();
 
+	if (__this_cpu_read(this_cpu_vector) == vectors) {
+		const char *v = arm64_get_bp_hardening_vector(EL1_VECTOR_KPTI);
+
+		__this_cpu_write(this_cpu_vector, v);
+	}
+
 	if (kpti_applied)
 		return;
 
diff --git a/arch/arm64/kernel/cpuinfo.c b/arch/arm64/kernel/cpuinfo.c
index 9ff64e04e63d..6b7db546efda 100644
--- a/arch/arm64/kernel/cpuinfo.c
+++ b/arch/arm64/kernel/cpuinfo.c
@@ -333,6 +333,7 @@ static void __cpuinfo_store_cpu(struct cpuinfo_arm64 *info)
 	info->reg_id_aa64dfr1 = read_cpuid(ID_AA64DFR1_EL1);
 	info->reg_id_aa64isar0 = read_cpuid(ID_AA64ISAR0_EL1);
 	info->reg_id_aa64isar1 = read_cpuid(ID_AA64ISAR1_EL1);
+	info->reg_id_aa64isar2 = read_cpuid(ID_AA64ISAR2_EL1);
 	info->reg_id_aa64mmfr0 = read_cpuid(ID_AA64MMFR0_EL1);
 	info->reg_id_aa64mmfr1 = read_cpuid(ID_AA64MMFR1_EL1);
 	info->reg_id_aa64mmfr2 = read_cpuid(ID_AA64MMFR2_EL1);
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index c1ffa95c0ad2..f526148d14bd 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -74,18 +74,21 @@
 
 	.macro kernel_ventry, el, label, regsize = 64
 	.align 7
-#ifdef CONFIG_UNMAP_KERNEL_AT_EL0
-alternative_if ARM64_UNMAP_KERNEL_AT_EL0
+.Lventry_start\@:
 	.if	\el == 0
+	/*
+	 * This must be the first instruction of the EL0 vector entries. It is
+	 * skipped by the trampoline vectors, to trigger the cleanup.
+	 */
+	b	.Lskip_tramp_vectors_cleanup\@
 	.if	\regsize == 64
 	mrs	x30, tpidrro_el0
 	msr	tpidrro_el0, xzr
 	.else
 	mov	x30, xzr
 	.endif
+.Lskip_tramp_vectors_cleanup\@:
 	.endif
-alternative_else_nop_endif
-#endif
 
 	sub	sp, sp, #S_FRAME_SIZE
 #ifdef CONFIG_VMAP_STACK
@@ -131,11 +134,15 @@ alternative_else_nop_endif
 	mrs	x0, tpidrro_el0
 #endif
 	b	el\()\el\()_\label
+.org .Lventry_start\@ + 128	// Did we overflow the ventry slot?
 	.endm
 
-	.macro tramp_alias, dst, sym
+	.macro tramp_alias, dst, sym, tmp
 	mov_q	\dst, TRAMP_VALIAS
-	add	\dst, \dst, #(\sym - .entry.tramp.text)
+	adr_l	\tmp, \sym
+	add	\dst, \dst, \tmp
+	adr_l	\tmp, .entry.tramp.text
+	sub	\dst, \dst, \tmp
 	.endm
 
 	// This macro corrupts x0-x3. It is the caller's duty
@@ -350,21 +357,25 @@ alternative_else_nop_endif
 	ldp	x24, x25, [sp, #16 * 12]
 	ldp	x26, x27, [sp, #16 * 13]
 	ldp	x28, x29, [sp, #16 * 14]
-	ldr	lr, [sp, #S_LR]
-	add	sp, sp, #S_FRAME_SIZE		// restore sp
 
 	.if	\el == 0
-alternative_insn eret, nop, ARM64_UNMAP_KERNEL_AT_EL0
+alternative_if_not ARM64_UNMAP_KERNEL_AT_EL0
+	ldr	lr, [sp, #S_LR]
+	add	sp, sp, #S_FRAME_SIZE		// restore sp
+	eret
+alternative_else_nop_endif
 #ifdef CONFIG_UNMAP_KERNEL_AT_EL0
 	bne	4f
-	msr	far_el1, x30
-	tramp_alias	x30, tramp_exit_native
+	msr	far_el1, x29
+	tramp_alias	x30, tramp_exit_native, x29
 	br	x30
 4:
-	tramp_alias	x30, tramp_exit_compat
+	tramp_alias	x30, tramp_exit_compat, x29
 	br	x30
 #endif
 	.else
+	ldr	lr, [sp, #S_LR]
+	add	sp, sp, #S_FRAME_SIZE		// restore sp
 	eret
 	.endif
 	.endm
@@ -972,12 +983,7 @@ __ni_sys_trace:
 
 	.popsection				// .entry.text
 
-#ifdef CONFIG_UNMAP_KERNEL_AT_EL0
-/*
- * Exception vectors trampoline.
- */
-	.pushsection ".entry.tramp.text", "ax"
-
+	// Move from tramp_pg_dir to swapper_pg_dir
 	.macro tramp_map_kernel, tmp
 	mrs	\tmp, ttbr1_el1
 	sub	\tmp, \tmp, #(SWAPPER_DIR_SIZE + RESERVED_TTBR0_SIZE)
@@ -1009,12 +1015,47 @@ alternative_else_nop_endif
 	 */
 	.endm
 
-	.macro tramp_ventry, regsize = 64
+	.macro tramp_data_page	dst
+	adr_l	\dst, .entry.tramp.text
+	sub	\dst, \dst, PAGE_SIZE
+	.endm
+
+	.macro tramp_data_read_var	dst, var
+#ifdef CONFIG_RANDOMIZE_BASE
+	tramp_data_page		\dst
+	add	\dst, \dst, #:lo12:__entry_tramp_data_\var
+	ldr	\dst, [\dst]
+#else
+	ldr	\dst, =\var
+#endif
+	.endm
+
+#define BHB_MITIGATION_NONE	0
+#define BHB_MITIGATION_LOOP	1
+#define BHB_MITIGATION_FW	2
+#define BHB_MITIGATION_INSN	3
+
+	.macro tramp_ventry, vector_start, regsize, kpti, bhb
 	.align	7
 1:
 	.if	\regsize == 64
 	msr	tpidrro_el0, x30	// Restored in kernel_ventry
 	.endif
+
+	.if	\bhb == BHB_MITIGATION_LOOP
+	/*
+	 * This sequence must appear before the first indirect branch. i.e. the
+	 * ret out of tramp_ventry. It appears here because x30 is free.
+	 */
+	__mitigate_spectre_bhb_loop	x30
+	.endif // \bhb == BHB_MITIGATION_LOOP
+
+	.if	\bhb == BHB_MITIGATION_INSN
+	clearbhb
+	isb
+	.endif // \bhb == BHB_MITIGATION_INSN
+
+	.if	\kpti == 1
 	/*
 	 * Defend against branch aliasing attacks by pushing a dummy
 	 * entry onto the return stack and using a RET instruction to
@@ -1024,43 +1065,75 @@ alternative_else_nop_endif
 	b	.
 2:
 	tramp_map_kernel	x30
-#ifdef CONFIG_RANDOMIZE_BASE
-	adr	x30, tramp_vectors + PAGE_SIZE
 alternative_insn isb, nop, ARM64_WORKAROUND_QCOM_FALKOR_E1003
-	ldr	x30, [x30]
-#else
-	ldr	x30, =vectors
-#endif
-	prfm	plil1strm, [x30, #(1b - tramp_vectors)]
+	tramp_data_read_var	x30, vectors
+	prfm	plil1strm, [x30, #(1b - \vector_start)]
 	msr	vbar_el1, x30
-	add	x30, x30, #(1b - tramp_vectors)
 	isb
+	.else
+	ldr	x30, =vectors
+	.endif // \kpti == 1
+
+	.if	\bhb == BHB_MITIGATION_FW
+	/*
+	 * The firmware sequence must appear before the first indirect branch.
+	 * i.e. the ret out of tramp_ventry. But it also needs the stack to be
+	 * mapped to save/restore the registers the SMC clobbers.
+	 */
+	__mitigate_spectre_bhb_fw
+	.endif // \bhb == BHB_MITIGATION_FW
+
+	add	x30, x30, #(1b - \vector_start + 4)
 	ret
+.org 1b + 128	// Did we overflow the ventry slot?
 	.endm
 
 	.macro tramp_exit, regsize = 64
-	adr	x30, tramp_vectors
+	tramp_data_read_var	x30, this_cpu_vector
+alternative_if_not ARM64_HAS_VIRT_HOST_EXTN
+	mrs	x29, tpidr_el1
+alternative_else
+	mrs	x29, tpidr_el2
+alternative_endif
+	ldr	x30, [x30, x29]
+
 	msr	vbar_el1, x30
-	tramp_unmap_kernel	x30
+	ldr	lr, [sp, #S_LR]
+	tramp_unmap_kernel	x29
 	.if	\regsize == 64
-	mrs	x30, far_el1
+	mrs	x29, far_el1
 	.endif
+	add	sp, sp, #S_FRAME_SIZE		// restore sp
 	eret
 	.endm
 
-	.align	11
-ENTRY(tramp_vectors)
+	.macro	generate_tramp_vector,	kpti, bhb
+.Lvector_start\@:
 	.space	0x400
 
-	tramp_ventry
-	tramp_ventry
-	tramp_ventry
-	tramp_ventry
+	.rept	4
+	tramp_ventry	.Lvector_start\@, 64, \kpti, \bhb
+	.endr
+	.rept	4
+	tramp_ventry	.Lvector_start\@, 32, \kpti, \bhb
+	.endr
+	.endm
 
-	tramp_ventry	32
-	tramp_ventry	32
-	tramp_ventry	32
-	tramp_ventry	32
+#ifdef CONFIG_UNMAP_KERNEL_AT_EL0
+/*
+ * Exception vectors trampoline.
+ * The order must match __bp_harden_el1_vectors and the
+ * arm64_bp_harden_el1_vectors enum.
+ */
+	.pushsection ".entry.tramp.text", "ax"
+	.align	11
+ENTRY(tramp_vectors)
+#ifdef CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY
+	generate_tramp_vector	kpti=1, bhb=BHB_MITIGATION_LOOP
+	generate_tramp_vector	kpti=1, bhb=BHB_MITIGATION_FW
+	generate_tramp_vector	kpti=1, bhb=BHB_MITIGATION_INSN
+#endif /* CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY */
+	generate_tramp_vector	kpti=1, bhb=BHB_MITIGATION_NONE
 END(tramp_vectors)
 
 ENTRY(tramp_exit_native)
@@ -1078,11 +1151,54 @@ END(tramp_exit_compat)
 	.align PAGE_SHIFT
 	.globl	__entry_tramp_data_start
 __entry_tramp_data_start:
+__entry_tramp_data_vectors:
 	.quad	vectors
+#ifdef CONFIG_ARM_SDE_INTERFACE
+__entry_tramp_data___sdei_asm_trampoline_next_handler:
+	.quad	__sdei_asm_handler
+#endif /* CONFIG_ARM_SDE_INTERFACE */
+__entry_tramp_data_this_cpu_vector:
+	.quad	this_cpu_vector
 	.popsection				// .rodata
 #endif /* CONFIG_RANDOMIZE_BASE */
 #endif /* CONFIG_UNMAP_KERNEL_AT_EL0 */
 
+/*
+ * Exception vectors for spectre mitigations on entry from EL1 when
+ * kpti is not in use.
+ */
+	.macro generate_el1_vector, bhb
+.Lvector_start\@:
+	kernel_ventry	1, sync_invalid			// Synchronous EL1t
+	kernel_ventry	1, irq_invalid			// IRQ EL1t
+	kernel_ventry	1, fiq_invalid			// FIQ EL1t
+	kernel_ventry	1, error_invalid		// Error EL1t
+
+	kernel_ventry	1, sync				// Synchronous EL1h
+	kernel_ventry	1, irq				// IRQ EL1h
+	kernel_ventry	1, fiq_invalid			// FIQ EL1h
+	kernel_ventry	1, error_invalid		// Error EL1h
+
+	.rept	4
+	tramp_ventry	.Lvector_start\@, 64, 0, \bhb
+	.endr
+	.rept 4
+	tramp_ventry	.Lvector_start\@, 32, 0, \bhb
+	.endr
+	.endm
+
+/* The order must match tramp_vecs and the arm64_bp_harden_el1_vectors enum. */
+	.pushsection ".entry.text", "ax"
+	.align	11
+ENTRY(__bp_harden_el1_vectors)
+#ifdef CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY
+	generate_el1_vector	bhb=BHB_MITIGATION_LOOP
+	generate_el1_vector	bhb=BHB_MITIGATION_FW
+	generate_el1_vector	bhb=BHB_MITIGATION_INSN
+#endif /* CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY */
+END(__bp_harden_el1_vectors)
+	.popsection
+
 /*
  * Special system call wrappers.
  */
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index 4c11d3e64aef..6543c58f26ec 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -258,7 +258,7 @@ ASSERT(__hibernate_exit_text_end - (__hibernate_exit_text_start & ~(SZ_4K - 1))
 	<= SZ_4K, "Hibernate exit text too big or misaligned")
 #endif
 #ifdef CONFIG_UNMAP_KERNEL_AT_EL0
-ASSERT((__entry_tramp_text_end - __entry_tramp_text_start) == PAGE_SIZE,
+ASSERT((__entry_tramp_text_end - __entry_tramp_text_start) <= 3*PAGE_SIZE,
 	"Entry trampoline text too big")
 #endif
 /*
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index 5e041eabdd03..8086294aedea 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -135,6 +135,10 @@ el1_hvc_guest:
 	/* ARM_SMCCC_ARCH_WORKAROUND_2 handling */
 	eor	w1, w1, #(ARM_SMCCC_ARCH_WORKAROUND_1 ^ \
 			  ARM_SMCCC_ARCH_WORKAROUND_2)
+	cbz	w1, wa_epilogue
+
+	eor	w1, w1, #(ARM_SMCCC_ARCH_WORKAROUND_2 ^ \
+			  ARM_SMCCC_ARCH_WORKAROUND_3)
 	cbnz	w1, el1_trap
 
 #ifdef CONFIG_ARM64_SSBD
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 99ae75a43985..0f05f402e04a 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -27,6 +27,7 @@
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_hyp.h>
 #include <asm/fpsimd.h>
+#include <asm/vectors.h>
 
 extern struct exception_table_entry __start___kvm_ex_table;
 extern struct exception_table_entry __stop___kvm_ex_table;
@@ -110,17 +111,21 @@ static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
 
 static void __hyp_text __deactivate_traps_vhe(void)
 {
-	extern char vectors[];	/* kernel exception vectors */
+	const char *host_vectors = vectors;
 	u64 mdcr_el2 = read_sysreg(mdcr_el2);
 
 	mdcr_el2 &= MDCR_EL2_HPMN_MASK |
 		    MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT |
 		    MDCR_EL2_TPMS;
 
+
 	write_sysreg(mdcr_el2, mdcr_el2);
 	write_sysreg(HCR_HOST_VHE_FLAGS, hcr_el2);
 	write_sysreg(CPACR_EL1_FPEN, cpacr_el1);
-	write_sysreg(vectors, vbar_el1);
+
+	if (!arm64_kernel_unmapped_at_el0())
+		host_vectors = __this_cpu_read(this_cpu_vector);
+	write_sysreg(host_vectors, vbar_el1);
 }
 
 static void __hyp_text __deactivate_traps_nvhe(void)
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index e02a6326c800..4d472907194d 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -532,6 +532,7 @@ early_param("rodata", parse_rodata);
 #ifdef CONFIG_UNMAP_KERNEL_AT_EL0
 static int __init map_entry_trampoline(void)
 {
+	int i;
 	extern char __entry_tramp_text_start[];
 
 	pgprot_t prot = rodata_enabled ? PAGE_KERNEL_ROX : PAGE_KERNEL_EXEC;
@@ -542,11 +543,15 @@ static int __init map_entry_trampoline(void)
 
 	/* Map only the text into the trampoline page table */
 	memset(tramp_pg_dir, 0, PGD_SIZE);
-	__create_pgd_mapping(tramp_pg_dir, pa_start, TRAMP_VALIAS, PAGE_SIZE,
-			     prot, pgd_pgtable_alloc, 0);
+	__create_pgd_mapping(tramp_pg_dir, pa_start, TRAMP_VALIAS,
+			     entry_tramp_text_size(), prot, pgd_pgtable_alloc,
+			     0);
 
 	/* Map both the text and data into the kernel page table */
-	__set_fixmap(FIX_ENTRY_TRAMP_TEXT, pa_start, prot);
+	for (i = 0; i < DIV_ROUND_UP(entry_tramp_text_size(), PAGE_SIZE); i++)
+		__set_fixmap(FIX_ENTRY_TRAMP_TEXT1 - i,
+			     pa_start + i * PAGE_SIZE, prot);
+
 	if (IS_ENABLED(CONFIG_RANDOMIZE_BASE)) {
 		extern char __entry_tramp_data_start[];
 
diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 2c5913057b87..439a4d005812 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -298,6 +298,13 @@ static u64 notrace arm64_858921_read_cntvct_el0(void)
 }
 #endif
 
+#ifdef CONFIG_ARM64_ERRATUM_1188873
+static u64 notrace arm64_1188873_read_cntvct_el0(void)
+{
+	return read_sysreg(cntvct_el0);
+}
+#endif
+
 #ifdef CONFIG_ARM_ARCH_TIMER_OOL_WORKAROUND
 DEFINE_PER_CPU(const struct arch_timer_erratum_workaround *,
 	       timer_unstable_counter_workaround);
@@ -381,6 +388,14 @@ static const struct arch_timer_erratum_workaround ool_workarounds[] = {
 		.read_cntvct_el0 = arm64_858921_read_cntvct_el0,
 	},
 #endif
+#ifdef CONFIG_ARM64_ERRATUM_1188873
+	{
+		.match_type = ate_match_local_cap_id,
+		.id = (void *)ARM64_WORKAROUND_1188873,
+		.desc = "ARM erratum 1188873",
+		.read_cntvct_el0 = arm64_1188873_read_cntvct_el0,
+	},
+#endif
 };
 
 typedef bool (*ate_match_fn_t)(const struct arch_timer_erratum_workaround *,
diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index 6366b04c7d5f..040266891414 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -85,6 +85,13 @@
 			   ARM_SMCCC_SMC_32,				\
 			   0, 0x7fff)
 
+#define ARM_SMCCC_ARCH_WORKAROUND_3					\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_32,				\
+			   0, 0x3fff)
+
+#define SMCCC_ARCH_WORKAROUND_RET_UNAFFECTED	1
+
 #ifndef __ASSEMBLY__
 
 #include <linux/linkage.h>
diff --git a/virt/kvm/arm/psci.c b/virt/kvm/arm/psci.c
index c95ab4c5a475..129b755824e1 100644
--- a/virt/kvm/arm/psci.c
+++ b/virt/kvm/arm/psci.c
@@ -433,6 +433,18 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 				break;
 			}
 			break;
+		case ARM_SMCCC_ARCH_WORKAROUND_3:
+			switch (kvm_arm_get_spectre_bhb_state()) {
+			case SPECTRE_VULNERABLE:
+				break;
+			case SPECTRE_MITIGATED:
+				val = SMCCC_RET_SUCCESS;
+				break;
+			case SPECTRE_UNAFFECTED:
+				val = SMCCC_ARCH_WORKAROUND_RET_UNAFFECTED;
+				break;
+			}
+			break;
 		}
 		break;
 	default:
