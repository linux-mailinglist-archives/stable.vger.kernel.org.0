Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0594CE32DA
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 14:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729269AbfJXMtO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 08:49:14 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39062 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729266AbfJXMtO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 08:49:14 -0400
Received: by mail-wr1-f67.google.com with SMTP id a11so9851204wra.6
        for <stable@vger.kernel.org>; Thu, 24 Oct 2019 05:49:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=x6wteSL3P8JpDImcoNNMPY/meQWi0f7VKhbsWognhyU=;
        b=mwQSebQIJj8oubpblU9ggu0yGSVJ0Zm6zMZhcSxcwhMpg9PFaAXd6pM+lB8bFR9kEj
         G6H2/3wwTDzZU/gYr3WVQZ0+4Z4s8FoH8L12a/v7OUiMdTl+R6zlu6czLyY4Z9yn+j0I
         I0jzKJQ45+u40R13wJ86y1ILDzsP+bYxpkOOXJPVW9EYrc4zwx2U6+OrID8JjPYlx4yT
         m1LeK0cHP80wRkBm2HN9rp50Y39kTLetMtfsFy7DgKxr7POiqdpP1rFhsc4HxUqVPtdB
         gu7s4QEkcsdP7E01NKzGzbqkBdCZvzjuOErnEWZizPFKd3NcWL+EU0UiMfGxcQLkjuCu
         +S1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x6wteSL3P8JpDImcoNNMPY/meQWi0f7VKhbsWognhyU=;
        b=bnnzwqzakBUD6/vxKR6O9lvg60KTRvkShUYWRDp1eXpGfCK0smezeddsdq1Io+N4TE
         oY/Yk/H4O2oY6wLX5IXvTwZI+5cdr7TioPuIUwbtZ63RbBMnVrLejfgoqREGFA4ID7RB
         nEsWUTRRWSjY90w/nTEGH7C+l1lPN8+RiPxzgMSCC8en3kASbdxN9WHh8Oqo1r3DeChQ
         kHqhQcZdqZn5FHhd9Lbn2G0MPgD8yaaqPitFe1scxeYLcuW8EFZjKfwnvpN56ARh1Mea
         KgtAlYLrHPkg9Rj0MHuODULNAAozPdZMVQ/ER34/jNsCwXf3kyckP/NanpYNwzsfyzlk
         OWnA==
X-Gm-Message-State: APjAAAVWpcSZRVqEMaIz24AVfGyZWOZtpyaGFZpPOh+JTL6YKWWxbyvn
        CuuLq7kV+O1ObEuGS6AuAJWSlu5uA5XxyzMz
X-Google-Smtp-Source: APXvYqzj4i2cHSoLq5RohSMlOGWqE7cHfsV+R7P/tq21VsRTHRKtbWtE5fLUcKTBdzexi4OC14/F4A==
X-Received: by 2002:a05:6000:114e:: with SMTP id d14mr3568954wrx.47.1571921347974;
        Thu, 24 Oct 2019 05:49:07 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-126-126.w90-88.abo.wanadoo.fr. [90.88.7.126])
        by smtp.gmail.com with ESMTPSA id j22sm29111038wrd.41.2019.10.24.05.49.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 05:49:07 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     stable@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Dave Martin <dave.martin@arm.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH for-stable-4.14 13/48] arm64: capabilities: Prepare for fine grained capabilities
Date:   Thu, 24 Oct 2019 14:47:58 +0200
Message-Id: <20191024124833.4158-14-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191024124833.4158-1-ard.biesheuvel@linaro.org>
References: <20191024124833.4158-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suzuki K Poulose <suzuki.poulose@arm.com>

[ Upstream commit 143ba05d867af34827faf99e0eed4de27106c7cb ]

We use arm64_cpu_capabilities to represent CPU ELF HWCAPs exposed
to the userspace and the CPU hwcaps used by the kernel, which
include cpu features and CPU errata work arounds. Capabilities
have some properties that decide how they should be treated :

 1) Detection, i.e scope : A cap could be "detected" either :
    - if it is present on at least one CPU (SCOPE_LOCAL_CPU)
	Or
    - if it is present on all the CPUs (SCOPE_SYSTEM)

 2) When is it enabled ? - A cap is treated as "enabled" when the
  system takes some action based on whether the capability is detected or
  not. e.g, setting some control register, patching the kernel code.
  Right now, we treat all caps are enabled at boot-time, after all
  the CPUs are brought up by the kernel. But there are certain caps,
  which are enabled early during the boot (e.g, VHE, GIC_CPUIF for NMI)
  and kernel starts using them, even before the secondary CPUs are brought
  up. We would need a way to describe this for each capability.

 3) Conflict on a late CPU - When a CPU is brought up, it is checked
  against the caps that are known to be enabled on the system (via
  verify_local_cpu_capabilities()). Based on the state of the capability
  on the CPU vs. that of System we could have the following combinations
  of conflict.

	x-----------------------------x
	| Type	| System   | Late CPU |
	------------------------------|
	|  a    |   y      |    n     |
	------------------------------|
	|  b    |   n      |    y     |
	x-----------------------------x

  Case (a) is not permitted for caps which are system features, which the
  system expects all the CPUs to have (e.g VHE). While (a) is ignored for
  all errata work arounds. However, there could be exceptions to the plain
  filtering approach. e.g, KPTI is an optional feature for a late CPU as
  long as the system already enables it.

  Case (b) is not permitted for errata work arounds which requires some
  work around, which cannot be delayed. And we ignore (b) for features.
  Here, yet again, KPTI is an exception, where if a late CPU needs KPTI we
  are too late to enable it (because we change the allocation of ASIDs
  etc).

So this calls for a lot more fine grained behavior for each capability.
And if we define all the attributes to control their behavior properly,
we may be able to use a single table for the CPU hwcaps (which cover
errata and features, not the ELF HWCAPs). This is a prepartory step
to get there. More bits would be added for the properties listed above.

We are going to use a bit-mask to encode all the properties of a
capabilities. This patch encodes the "SCOPE" of the capability.

As such there is no change in how the capabilities are treated.

Cc: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Dave Martin <dave.martin@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/include/asm/cpufeature.h | 105 ++++++++++++++++++--
 arch/arm64/kernel/cpu_errata.c      |  12 +--
 arch/arm64/kernel/cpufeature.c      |  34 +++----
 3 files changed, 122 insertions(+), 29 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 22ebede86100..909e005f9612 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -85,16 +85,104 @@ struct arm64_ftr_reg {
 
 extern struct arm64_ftr_reg arm64_ftr_reg_ctrel0;
 
-/* scope of capability check */
-enum {
-	SCOPE_SYSTEM,
-	SCOPE_LOCAL_CPU,
-};
+/*
+ * CPU capabilities:
+ *
+ * We use arm64_cpu_capabilities to represent system features, errata work
+ * arounds (both used internally by kernel and tracked in cpu_hwcaps) and
+ * ELF HWCAPs (which are exposed to user).
+ *
+ * To support systems with heterogeneous CPUs, we need to make sure that we
+ * detect the capabilities correctly on the system and take appropriate
+ * measures to ensure there are no incompatibilities.
+ *
+ * This comment tries to explain how we treat the capabilities.
+ * Each capability has the following list of attributes :
+ *
+ * 1) Scope of Detection : The system detects a given capability by
+ *    performing some checks at runtime. This could be, e.g, checking the
+ *    value of a field in CPU ID feature register or checking the cpu
+ *    model. The capability provides a call back ( @matches() ) to
+ *    perform the check. Scope defines how the checks should be performed.
+ *    There are two cases:
+ *
+ *     a) SCOPE_LOCAL_CPU: check all the CPUs and "detect" if at least one
+ *        matches. This implies, we have to run the check on all the
+ *        booting CPUs, until the system decides that state of the
+ *        capability is finalised. (See section 2 below)
+ *		Or
+ *     b) SCOPE_SYSTEM: check all the CPUs and "detect" if all the CPUs
+ *        matches. This implies, we run the check only once, when the
+ *        system decides to finalise the state of the capability. If the
+ *        capability relies on a field in one of the CPU ID feature
+ *        registers, we use the sanitised value of the register from the
+ *        CPU feature infrastructure to make the decision.
+ *
+ *    The process of detection is usually denoted by "update" capability
+ *    state in the code.
+ *
+ * 2) Finalise the state : The kernel should finalise the state of a
+ *    capability at some point during its execution and take necessary
+ *    actions if any. Usually, this is done, after all the boot-time
+ *    enabled CPUs are brought up by the kernel, so that it can make
+ *    better decision based on the available set of CPUs. However, there
+ *    are some special cases, where the action is taken during the early
+ *    boot by the primary boot CPU. (e.g, running the kernel at EL2 with
+ *    Virtualisation Host Extensions). The kernel usually disallows any
+ *    changes to the state of a capability once it finalises the capability
+ *    and takes any action, as it may be impossible to execute the actions
+ *    safely. A CPU brought up after a capability is "finalised" is
+ *    referred to as "Late CPU" w.r.t the capability. e.g, all secondary
+ *    CPUs are treated "late CPUs" for capabilities determined by the boot
+ *    CPU.
+ *
+ * 3) Verification: When a CPU is brought online (e.g, by user or by the
+ *    kernel), the kernel should make sure that it is safe to use the CPU,
+ *    by verifying that the CPU is compliant with the state of the
+ *    capabilities finalised already. This happens via :
+ *
+ *	secondary_start_kernel()-> check_local_cpu_capabilities()
+ *
+ *    As explained in (2) above, capabilities could be finalised at
+ *    different points in the execution. Each CPU is verified against the
+ *    "finalised" capabilities and if there is a conflict, the kernel takes
+ *    an action, based on the severity (e.g, a CPU could be prevented from
+ *    booting or cause a kernel panic). The CPU is allowed to "affect" the
+ *    state of the capability, if it has not been finalised already.
+ *
+ * 4) Action: As mentioned in (2), the kernel can take an action for each
+ *    detected capability, on all CPUs on the system. Appropriate actions
+ *    include, turning on an architectural feature, modifying the control
+ *    registers (e.g, SCTLR, TCR etc.) or patching the kernel via
+ *    alternatives. The kernel patching is batched and performed at later
+ *    point. The actions are always initiated only after the capability
+ *    is finalised. This is usally denoted by "enabling" the capability.
+ *    The actions are initiated as follows :
+ *	a) Action is triggered on all online CPUs, after the capability is
+ *	finalised, invoked within the stop_machine() context from
+ *	enable_cpu_capabilitie().
+ *
+ *	b) Any late CPU, brought up after (1), the action is triggered via:
+ *
+ *	  check_local_cpu_capabilities() -> verify_local_cpu_capabilities()
+ *
+ */
+
+
+/* Decide how the capability is detected. On a local CPU vs System wide */
+#define ARM64_CPUCAP_SCOPE_LOCAL_CPU		((u16)BIT(0))
+#define ARM64_CPUCAP_SCOPE_SYSTEM		((u16)BIT(1))
+#define ARM64_CPUCAP_SCOPE_MASK			\
+	(ARM64_CPUCAP_SCOPE_SYSTEM	|	\
+	 ARM64_CPUCAP_SCOPE_LOCAL_CPU)
+
+#define SCOPE_SYSTEM				ARM64_CPUCAP_SCOPE_SYSTEM
+#define SCOPE_LOCAL_CPU				ARM64_CPUCAP_SCOPE_LOCAL_CPU
 
 struct arm64_cpu_capabilities {
 	const char *desc;
 	u16 capability;
-	int def_scope;			/* default scope */
+	u16 type;
 	bool (*matches)(const struct arm64_cpu_capabilities *caps, int scope);
 	/*
 	 * Take the appropriate actions to enable this capability for this CPU.
@@ -119,6 +207,11 @@ struct arm64_cpu_capabilities {
 	};
 };
 
+static inline int cpucap_default_scope(const struct arm64_cpu_capabilities *cap)
+{
+	return cap->type & ARM64_CPUCAP_SCOPE_MASK;
+}
+
 extern DECLARE_BITMAP(cpu_hwcaps, ARM64_NCAPS);
 extern struct static_key_false cpu_hwcap_keys[ARM64_NCAPS];
 extern struct static_key_false arm64_const_caps_ready;
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index f1885beb2588..72f701da24c9 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -406,14 +406,14 @@ static bool has_ssbd_mitigation(const struct arm64_cpu_capabilities *entry,
 #endif	/* CONFIG_ARM64_SSBD */
 
 #define MIDR_RANGE(model, min, max) \
-	.def_scope = SCOPE_LOCAL_CPU, \
+	.type = ARM64_CPUCAP_SCOPE_LOCAL_CPU, \
 	.matches = is_affected_midr_range, \
 	.midr_model = model, \
 	.midr_range_min = min, \
 	.midr_range_max = max
 
 #define MIDR_ALL_VERSIONS(model) \
-	.def_scope = SCOPE_LOCAL_CPU, \
+	.type = ARM64_CPUCAP_SCOPE_LOCAL_CPU, \
 	.matches = is_affected_midr_range, \
 	.midr_model = model, \
 	.midr_range_min = 0, \
@@ -517,14 +517,14 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		.desc = "Mismatched cache line size",
 		.capability = ARM64_MISMATCHED_CACHE_LINE_SIZE,
 		.matches = has_mismatched_cache_type,
-		.def_scope = SCOPE_LOCAL_CPU,
+		.type = ARM64_CPUCAP_SCOPE_LOCAL_CPU,
 		.cpu_enable = cpu_enable_trap_ctr_access,
 	},
 	{
 		.desc = "Mismatched cache type",
 		.capability = ARM64_MISMATCHED_CACHE_TYPE,
 		.matches = has_mismatched_cache_type,
-		.def_scope = SCOPE_LOCAL_CPU,
+		.type = ARM64_CPUCAP_SCOPE_LOCAL_CPU,
 		.cpu_enable = cpu_enable_trap_ctr_access,
 	},
 #ifdef CONFIG_QCOM_FALKOR_ERRATUM_1003
@@ -538,7 +538,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 	{
 		.desc = "Qualcomm Technologies Kryo erratum 1003",
 		.capability = ARM64_WORKAROUND_QCOM_FALKOR_E1003,
-		.def_scope = SCOPE_LOCAL_CPU,
+		.type = ARM64_CPUCAP_SCOPE_LOCAL_CPU,
 		.midr_model = MIDR_QCOM_KRYO,
 		.matches = is_kryo_midr,
 	},
@@ -613,7 +613,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 #ifdef CONFIG_ARM64_SSBD
 	{
 		.desc = "Speculative Store Bypass Disable",
-		.def_scope = SCOPE_LOCAL_CPU,
+		.type = ARM64_CPUCAP_SCOPE_LOCAL_CPU,
 		.capability = ARM64_SSBD,
 		.matches = has_ssbd_mitigation,
 	},
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 353464b82d61..5a3becce5a3e 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -924,7 +924,7 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 	{
 		.desc = "GIC system register CPU interface",
 		.capability = ARM64_HAS_SYSREG_GIC_CPUIF,
-		.def_scope = SCOPE_SYSTEM,
+		.type = ARM64_CPUCAP_SCOPE_SYSTEM,
 		.matches = has_useable_gicv3_cpuif,
 		.sys_reg = SYS_ID_AA64PFR0_EL1,
 		.field_pos = ID_AA64PFR0_GIC_SHIFT,
@@ -935,7 +935,7 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 	{
 		.desc = "Privileged Access Never",
 		.capability = ARM64_HAS_PAN,
-		.def_scope = SCOPE_SYSTEM,
+		.type = ARM64_CPUCAP_SCOPE_SYSTEM,
 		.matches = has_cpuid_feature,
 		.sys_reg = SYS_ID_AA64MMFR1_EL1,
 		.field_pos = ID_AA64MMFR1_PAN_SHIFT,
@@ -948,7 +948,7 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 	{
 		.desc = "LSE atomic instructions",
 		.capability = ARM64_HAS_LSE_ATOMICS,
-		.def_scope = SCOPE_SYSTEM,
+		.type = ARM64_CPUCAP_SCOPE_SYSTEM,
 		.matches = has_cpuid_feature,
 		.sys_reg = SYS_ID_AA64ISAR0_EL1,
 		.field_pos = ID_AA64ISAR0_ATOMICS_SHIFT,
@@ -959,14 +959,14 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 	{
 		.desc = "Software prefetching using PRFM",
 		.capability = ARM64_HAS_NO_HW_PREFETCH,
-		.def_scope = SCOPE_SYSTEM,
+		.type = ARM64_CPUCAP_SCOPE_SYSTEM,
 		.matches = has_no_hw_prefetch,
 	},
 #ifdef CONFIG_ARM64_UAO
 	{
 		.desc = "User Access Override",
 		.capability = ARM64_HAS_UAO,
-		.def_scope = SCOPE_SYSTEM,
+		.type = ARM64_CPUCAP_SCOPE_SYSTEM,
 		.matches = has_cpuid_feature,
 		.sys_reg = SYS_ID_AA64MMFR2_EL1,
 		.field_pos = ID_AA64MMFR2_UAO_SHIFT,
@@ -980,21 +980,21 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 #ifdef CONFIG_ARM64_PAN
 	{
 		.capability = ARM64_ALT_PAN_NOT_UAO,
-		.def_scope = SCOPE_SYSTEM,
+		.type = ARM64_CPUCAP_SCOPE_SYSTEM,
 		.matches = cpufeature_pan_not_uao,
 	},
 #endif /* CONFIG_ARM64_PAN */
 	{
 		.desc = "Virtualization Host Extensions",
 		.capability = ARM64_HAS_VIRT_HOST_EXTN,
-		.def_scope = SCOPE_SYSTEM,
+		.type = ARM64_CPUCAP_SCOPE_SYSTEM,
 		.matches = runs_at_el2,
 		.cpu_enable = cpu_copy_el2regs,
 	},
 	{
 		.desc = "32-bit EL0 Support",
 		.capability = ARM64_HAS_32BIT_EL0,
-		.def_scope = SCOPE_SYSTEM,
+		.type = ARM64_CPUCAP_SCOPE_SYSTEM,
 		.matches = has_cpuid_feature,
 		.sys_reg = SYS_ID_AA64PFR0_EL1,
 		.sign = FTR_UNSIGNED,
@@ -1004,14 +1004,14 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 	{
 		.desc = "Reduced HYP mapping offset",
 		.capability = ARM64_HYP_OFFSET_LOW,
-		.def_scope = SCOPE_SYSTEM,
+		.type = ARM64_CPUCAP_SCOPE_SYSTEM,
 		.matches = hyp_offset_low,
 	},
 #ifdef CONFIG_UNMAP_KERNEL_AT_EL0
 	{
 		.desc = "Kernel page table isolation (KPTI)",
 		.capability = ARM64_UNMAP_KERNEL_AT_EL0,
-		.def_scope = SCOPE_SYSTEM,
+		.type = ARM64_CPUCAP_SCOPE_SYSTEM,
 		.matches = unmap_kernel_at_el0,
 		.cpu_enable = kpti_install_ng_mappings,
 	},
@@ -1019,7 +1019,7 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 	{
 		/* FP/SIMD is not implemented */
 		.capability = ARM64_HAS_NO_FPSIMD,
-		.def_scope = SCOPE_SYSTEM,
+		.type = ARM64_CPUCAP_SCOPE_SYSTEM,
 		.min_field_value = 0,
 		.matches = has_no_fpsimd,
 	},
@@ -1027,7 +1027,7 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 	{
 		.desc = "Data cache clean to Point of Persistence",
 		.capability = ARM64_HAS_DCPOP,
-		.def_scope = SCOPE_SYSTEM,
+		.type = ARM64_CPUCAP_SCOPE_SYSTEM,
 		.matches = has_cpuid_feature,
 		.sys_reg = SYS_ID_AA64ISAR1_EL1,
 		.field_pos = ID_AA64ISAR1_DPB_SHIFT,
@@ -1037,16 +1037,16 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 	{},
 };
 
-#define HWCAP_CAP(reg, field, s, min_value, type, cap)	\
+#define HWCAP_CAP(reg, field, s, min_value, cap_type, cap)	\
 	{							\
 		.desc = #cap,					\
-		.def_scope = SCOPE_SYSTEM,			\
+		.type = ARM64_CPUCAP_SCOPE_SYSTEM,		\
 		.matches = has_cpuid_feature,			\
 		.sys_reg = reg,					\
 		.field_pos = field,				\
 		.sign = s,					\
 		.min_field_value = min_value,			\
-		.hwcap_type = type,				\
+		.hwcap_type = cap_type,				\
 		.hwcap = cap,					\
 	}
 
@@ -1140,7 +1140,7 @@ static void __init setup_elf_hwcaps(const struct arm64_cpu_capabilities *hwcaps)
 	/* We support emulation of accesses to CPU ID feature registers */
 	elf_hwcap |= HWCAP_CPUID;
 	for (; hwcaps->matches; hwcaps++)
-		if (hwcaps->matches(hwcaps, hwcaps->def_scope))
+		if (hwcaps->matches(hwcaps, cpucap_default_scope(hwcaps)))
 			cap_set_elf_hwcap(hwcaps);
 }
 
@@ -1167,7 +1167,7 @@ static void update_cpu_capabilities(const struct arm64_cpu_capabilities *caps,
 				    const char *info)
 {
 	for (; caps->matches; caps++) {
-		if (!caps->matches(caps, caps->def_scope))
+		if (!caps->matches(caps, cpucap_default_scope(caps)))
 			continue;
 
 		if (!cpus_have_cap(caps->capability) && caps->desc)
-- 
2.20.1

