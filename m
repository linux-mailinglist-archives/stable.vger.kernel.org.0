Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5930DE6928
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:35:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727705AbfJ0VJj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:09:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:56010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729526AbfJ0VJh (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:09:37 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D232F20B7C;
        Sun, 27 Oct 2019 21:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210576;
        bh=2Tm025q60FD5I3jiV3zIiNPcK3/Z1MfyALmUKtw5ohY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P/0WlbuObWsvrk+uyYB1bYeq+S5HYJdjvQ1SoqhUG+EE5kMnYNg2T0Gnh9j6cAvPW
         3VNsVYxA2/J7vqr8TqAlSn5PbYFRcCUfl2B+eFhrdboOpOqXBz8WONbt1ivsb9+1rZ
         XDz4rt0plA6IPwFUq9qkxKAExHQgvJ5YLdpavizg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Will Deacon <will.deacon@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Dave Martin <dave.martin@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 4.14 064/119] arm64: capabilities: Add support for checks based on a list of MIDRs
Date:   Sun, 27 Oct 2019 22:00:41 +0100
Message-Id: <20191027203329.548231857@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203259.948006506@linuxfoundation.org>
References: <20191027203259.948006506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suzuki K Poulose <suzuki.poulose@arm.com>

[ Upstream commit be5b299830c63ed76e0357473c4218c85fb388b3 ]

Add helpers for detecting an errata on list of midr ranges
of affected CPUs, with the same work around.

Cc: Will Deacon <will.deacon@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Reviewed-by: Dave Martin <dave.martin@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
[ardb: add Cortex-A35 to kpti_safe_list[] as well]
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/cpufeature.h |    1 
 arch/arm64/include/asm/cputype.h    |    9 ++++
 arch/arm64/kernel/cpu_errata.c      |   81 +++++++++++++++++++-----------------
 arch/arm64/kernel/cpufeature.c      |   21 +++++----
 4 files changed, 66 insertions(+), 46 deletions(-)

--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -306,6 +306,7 @@ struct arm64_cpu_capabilities {
 			struct midr_range midr_range;
 		};
 
+		const struct midr_range *midr_range_list;
 		struct {	/* Feature register checking */
 			u32 sys_reg;
 			u8 field_pos;
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -159,6 +159,15 @@ static inline bool is_midr_in_range(u32
 				 range->rv_min, range->rv_max);
 }
 
+static inline bool
+is_midr_in_range_list(u32 midr, struct midr_range const *ranges)
+{
+	while (ranges->model)
+		if (is_midr_in_range(midr, ranges++))
+			return true;
+	return false;
+}
+
 /*
  * The CPU ID never changes at run time, so we might as well tell the
  * compiler that it's constant.  Use this function to read the CPU ID
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -33,6 +33,14 @@ is_affected_midr_range(const struct arm6
 }
 
 static bool __maybe_unused
+is_affected_midr_range_list(const struct arm64_cpu_capabilities *entry,
+			    int scope)
+{
+	WARN_ON(scope != SCOPE_LOCAL_CPU || preemptible());
+	return is_midr_in_range_list(read_cpuid_id(), entry->midr_range_list);
+}
+
+static bool __maybe_unused
 is_kryo_midr(const struct arm64_cpu_capabilities *entry, int scope)
 {
 	u32 model;
@@ -420,6 +428,10 @@ static bool has_ssbd_mitigation(const st
 	.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,				\
 	CAP_MIDR_RANGE(model, v_min, r_min, v_max, r_max)
 
+#define CAP_MIDR_RANGE_LIST(list)				\
+	.matches = is_affected_midr_range_list,			\
+	.midr_range_list = list
+
 /* Errata affecting a range of revisions of  given model variant */
 #define ERRATA_MIDR_REV_RANGE(m, var, r_min, r_max)	 \
 	ERRATA_MIDR_RANGE(m, var, r_min, var, r_max)
@@ -433,6 +445,35 @@ static bool has_ssbd_mitigation(const st
 	.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,			\
 	CAP_MIDR_ALL_VERSIONS(model)
 
+/* Errata affecting a list of midr ranges, with same work around */
+#define ERRATA_MIDR_RANGE_LIST(midr_list)			\
+	.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,			\
+	CAP_MIDR_RANGE_LIST(midr_list)
+
+#ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
+
+/*
+ * List of CPUs where we need to issue a psci call to
+ * harden the branch predictor.
+ */
+static const struct midr_range arm64_bp_harden_smccc_cpus[] = {
+	MIDR_ALL_VERSIONS(MIDR_CORTEX_A57),
+	MIDR_ALL_VERSIONS(MIDR_CORTEX_A72),
+	MIDR_ALL_VERSIONS(MIDR_CORTEX_A73),
+	MIDR_ALL_VERSIONS(MIDR_CORTEX_A75),
+	MIDR_ALL_VERSIONS(MIDR_BRCM_VULCAN),
+	MIDR_ALL_VERSIONS(MIDR_CAVIUM_THUNDERX2),
+	{},
+};
+
+static const struct midr_range qcom_bp_harden_cpus[] = {
+	MIDR_ALL_VERSIONS(MIDR_QCOM_FALKOR_V1),
+	MIDR_ALL_VERSIONS(MIDR_QCOM_FALKOR),
+	{},
+};
+
+#endif
+
 const struct arm64_cpu_capabilities arm64_errata[] = {
 #if	defined(CONFIG_ARM64_ERRATUM_826319) || \
 	defined(CONFIG_ARM64_ERRATUM_827319) || \
@@ -574,51 +615,17 @@ const struct arm64_cpu_capabilities arm6
 #ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
 	{
 		.capability = ARM64_HARDEN_BRANCH_PREDICTOR,
-		ERRATA_MIDR_ALL_VERSIONS(MIDR_CORTEX_A57),
-		.cpu_enable = enable_smccc_arch_workaround_1,
-	},
-	{
-		.capability = ARM64_HARDEN_BRANCH_PREDICTOR,
-		ERRATA_MIDR_ALL_VERSIONS(MIDR_CORTEX_A72),
-		.cpu_enable = enable_smccc_arch_workaround_1,
-	},
-	{
-		.capability = ARM64_HARDEN_BRANCH_PREDICTOR,
-		ERRATA_MIDR_ALL_VERSIONS(MIDR_CORTEX_A73),
+		ERRATA_MIDR_RANGE_LIST(arm64_bp_harden_smccc_cpus),
 		.cpu_enable = enable_smccc_arch_workaround_1,
 	},
 	{
 		.capability = ARM64_HARDEN_BRANCH_PREDICTOR,
-		ERRATA_MIDR_ALL_VERSIONS(MIDR_CORTEX_A75),
-		.cpu_enable = enable_smccc_arch_workaround_1,
-	},
-	{
-		.capability = ARM64_HARDEN_BRANCH_PREDICTOR,
-		ERRATA_MIDR_ALL_VERSIONS(MIDR_QCOM_FALKOR_V1),
-		.cpu_enable = qcom_enable_link_stack_sanitization,
-	},
-	{
-		.capability = ARM64_HARDEN_BP_POST_GUEST_EXIT,
-		ERRATA_MIDR_ALL_VERSIONS(MIDR_QCOM_FALKOR_V1),
-	},
-	{
-		.capability = ARM64_HARDEN_BRANCH_PREDICTOR,
-		ERRATA_MIDR_ALL_VERSIONS(MIDR_QCOM_FALKOR),
+		ERRATA_MIDR_RANGE_LIST(qcom_bp_harden_cpus),
 		.cpu_enable = qcom_enable_link_stack_sanitization,
 	},
 	{
 		.capability = ARM64_HARDEN_BP_POST_GUEST_EXIT,
-		ERRATA_MIDR_ALL_VERSIONS(MIDR_QCOM_FALKOR),
-	},
-	{
-		.capability = ARM64_HARDEN_BRANCH_PREDICTOR,
-		ERRATA_MIDR_ALL_VERSIONS(MIDR_BRCM_VULCAN),
-		.cpu_enable = enable_smccc_arch_workaround_1,
-	},
-	{
-		.capability = ARM64_HARDEN_BRANCH_PREDICTOR,
-		ERRATA_MIDR_ALL_VERSIONS(MIDR_CAVIUM_THUNDERX2),
-		.cpu_enable = enable_smccc_arch_workaround_1,
+		ERRATA_MIDR_RANGE_LIST(qcom_bp_harden_cpus),
 	},
 #endif
 #ifdef CONFIG_ARM64_SSBD
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -826,6 +826,17 @@ static int __kpti_forced; /* 0: not forc
 static bool unmap_kernel_at_el0(const struct arm64_cpu_capabilities *entry,
 				int scope)
 {
+	/* List of CPUs that are not vulnerable and don't need KPTI */
+	static const struct midr_range kpti_safe_list[] = {
+		MIDR_ALL_VERSIONS(MIDR_CAVIUM_THUNDERX2),
+		MIDR_ALL_VERSIONS(MIDR_BRCM_VULCAN),
+		MIDR_ALL_VERSIONS(MIDR_CORTEX_A35),
+		MIDR_ALL_VERSIONS(MIDR_CORTEX_A53),
+		MIDR_ALL_VERSIONS(MIDR_CORTEX_A55),
+		MIDR_ALL_VERSIONS(MIDR_CORTEX_A57),
+		MIDR_ALL_VERSIONS(MIDR_CORTEX_A72),
+		MIDR_ALL_VERSIONS(MIDR_CORTEX_A73),
+	};
 	char const *str = "command line option";
 
 	/*
@@ -850,16 +861,8 @@ static bool unmap_kernel_at_el0(const st
 		return true;
 
 	/* Don't force KPTI for CPUs that are not vulnerable */
-	switch (read_cpuid_id() & MIDR_CPU_MODEL_MASK) {
-	case MIDR_CAVIUM_THUNDERX2:
-	case MIDR_BRCM_VULCAN:
-	case MIDR_CORTEX_A53:
-	case MIDR_CORTEX_A55:
-	case MIDR_CORTEX_A57:
-	case MIDR_CORTEX_A72:
-	case MIDR_CORTEX_A73:
+	if (is_midr_in_range_list(read_cpuid_id(), kpti_safe_list))
 		return false;
-	}
 
 	/* Defer to CPU feature registers */
 	return !has_cpuid_feature(entry, scope);


