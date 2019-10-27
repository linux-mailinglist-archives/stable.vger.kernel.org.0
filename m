Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F1E8E6922
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:34:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729680AbfJ0VKU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:10:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:56678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729670AbfJ0VKR (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:10:17 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CE6E20873;
        Sun, 27 Oct 2019 21:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210616;
        bh=KnbIuc4hH1+dOvfd4Ox4/W1RZYw4LgzElBn/oUflloQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yyQnBEZXIxXNqnB0MFPJpREY20GHbP1H5l7zMHM6cHAF6EPjHe7yKI6y7Ao3K0YMI
         fPi00YzHQCspfWovhd+jSiGStI4CMimXTCQ30Tz2bLXcTaHD3ztoOqCJ7o3b77jZH/
         qLaf3lE4rvWUtel0lvwnf7tg4S9geUiTA53RNa8Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Will Deacon <will.deacon@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 4.14 077/119] arm64: Advertise mitigation of Spectre-v2, or lack thereof
Date:   Sun, 27 Oct 2019 22:00:54 +0100
Message-Id: <20191027203343.582225094@linuxfoundation.org>
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

From: Marc Zyngier <marc.zyngier@arm.com>

[ Upstream commit 73f38166095947f3b86b02fbed6bd592223a7ac8 ]

We currently have a list of CPUs affected by Spectre-v2, for which
we check that the firmware implements ARCH_WORKAROUND_1. It turns
out that not all firmwares do implement the required mitigation,
and that we fail to let the user know about it.

Instead, let's slightly revamp our checks, and rely on a whitelist
of cores that are known to be non-vulnerable, and let the user know
the status of the mitigation in the kernel log.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Tested-by: Stefan Wahren <stefan.wahren@i2se.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/cpu_errata.c |  108 +++++++++++++++++++++--------------------
 1 file changed, 56 insertions(+), 52 deletions(-)

--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -98,9 +98,9 @@ static void __copy_hyp_vect_bpi(int slot
 	flush_icache_range((uintptr_t)dst, (uintptr_t)dst + SZ_2K);
 }
 
-static void __install_bp_hardening_cb(bp_hardening_cb_t fn,
-				      const char *hyp_vecs_start,
-				      const char *hyp_vecs_end)
+static void install_bp_hardening_cb(bp_hardening_cb_t fn,
+				    const char *hyp_vecs_start,
+				    const char *hyp_vecs_end)
 {
 	static int last_slot = -1;
 	static DEFINE_SPINLOCK(bp_lock);
@@ -130,7 +130,7 @@ static void __install_bp_hardening_cb(bp
 #define __smccc_workaround_1_smc_start		NULL
 #define __smccc_workaround_1_smc_end		NULL
 
-static void __install_bp_hardening_cb(bp_hardening_cb_t fn,
+static void install_bp_hardening_cb(bp_hardening_cb_t fn,
 				      const char *hyp_vecs_start,
 				      const char *hyp_vecs_end)
 {
@@ -138,23 +138,6 @@ static void __install_bp_hardening_cb(bp
 }
 #endif	/* CONFIG_KVM */
 
-static void  install_bp_hardening_cb(const struct arm64_cpu_capabilities *entry,
-				     bp_hardening_cb_t fn,
-				     const char *hyp_vecs_start,
-				     const char *hyp_vecs_end)
-{
-	u64 pfr0;
-
-	if (!entry->matches(entry, SCOPE_LOCAL_CPU))
-		return;
-
-	pfr0 = read_cpuid(ID_AA64PFR0_EL1);
-	if (cpuid_feature_extract_unsigned_field(pfr0, ID_AA64PFR0_CSV2_SHIFT))
-		return;
-
-	__install_bp_hardening_cb(fn, hyp_vecs_start, hyp_vecs_end);
-}
-
 #include <uapi/linux/psci.h>
 #include <linux/arm-smccc.h>
 #include <linux/psci.h>
@@ -189,31 +172,27 @@ static int __init parse_nospectre_v2(cha
 }
 early_param("nospectre_v2", parse_nospectre_v2);
 
-static void
-enable_smccc_arch_workaround_1(const struct arm64_cpu_capabilities *entry)
+/*
+ * -1: No workaround
+ *  0: No workaround required
+ *  1: Workaround installed
+ */
+static int detect_harden_bp_fw(void)
 {
 	bp_hardening_cb_t cb;
 	void *smccc_start, *smccc_end;
 	struct arm_smccc_res res;
 	u32 midr = read_cpuid_id();
 
-	if (!entry->matches(entry, SCOPE_LOCAL_CPU))
-		return;
-
-	if (__nospectre_v2) {
-		pr_info_once("spectrev2 mitigation disabled by command line option\n");
-		return;
-	}
-
 	if (psci_ops.smccc_version == SMCCC_VERSION_1_0)
-		return;
+		return -1;
 
 	switch (psci_ops.conduit) {
 	case PSCI_CONDUIT_HVC:
 		arm_smccc_1_1_hvc(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
 				  ARM_SMCCC_ARCH_WORKAROUND_1, &res);
 		if ((int)res.a0 < 0)
-			return;
+			return -1;
 		cb = call_hvc_arch_workaround_1;
 		/* This is a guest, no need to patch KVM vectors */
 		smccc_start = NULL;
@@ -224,23 +203,23 @@ enable_smccc_arch_workaround_1(const str
 		arm_smccc_1_1_smc(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
 				  ARM_SMCCC_ARCH_WORKAROUND_1, &res);
 		if ((int)res.a0 < 0)
-			return;
+			return -1;
 		cb = call_smc_arch_workaround_1;
 		smccc_start = __smccc_workaround_1_smc_start;
 		smccc_end = __smccc_workaround_1_smc_end;
 		break;
 
 	default:
-		return;
+		return -1;
 	}
 
 	if (((midr & MIDR_CPU_MODEL_MASK) == MIDR_QCOM_FALKOR) ||
 	    ((midr & MIDR_CPU_MODEL_MASK) == MIDR_QCOM_FALKOR_V1))
 		cb = qcom_link_stack_sanitization;
 
-	install_bp_hardening_cb(entry, cb, smccc_start, smccc_end);
+	install_bp_hardening_cb(cb, smccc_start, smccc_end);
 
-	return;
+	return 1;
 }
 #endif	/* CONFIG_HARDEN_BRANCH_PREDICTOR */
 
@@ -479,23 +458,48 @@ out_printmsg:
 	CAP_MIDR_RANGE_LIST(midr_list)
 
 #ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
-
 /*
- * List of CPUs where we need to issue a psci call to
- * harden the branch predictor.
+ * List of CPUs that do not need any Spectre-v2 mitigation at all.
  */
-static const struct midr_range arm64_bp_harden_smccc_cpus[] = {
-	MIDR_ALL_VERSIONS(MIDR_CORTEX_A57),
-	MIDR_ALL_VERSIONS(MIDR_CORTEX_A72),
-	MIDR_ALL_VERSIONS(MIDR_CORTEX_A73),
-	MIDR_ALL_VERSIONS(MIDR_CORTEX_A75),
-	MIDR_ALL_VERSIONS(MIDR_BRCM_VULCAN),
-	MIDR_ALL_VERSIONS(MIDR_CAVIUM_THUNDERX2),
-	MIDR_ALL_VERSIONS(MIDR_QCOM_FALKOR_V1),
-	MIDR_ALL_VERSIONS(MIDR_QCOM_FALKOR),
-	{},
+static const struct midr_range spectre_v2_safe_list[] = {
+	MIDR_ALL_VERSIONS(MIDR_CORTEX_A35),
+	MIDR_ALL_VERSIONS(MIDR_CORTEX_A53),
+	MIDR_ALL_VERSIONS(MIDR_CORTEX_A55),
+	{ /* sentinel */ }
 };
 
+static bool __maybe_unused
+check_branch_predictor(const struct arm64_cpu_capabilities *entry, int scope)
+{
+	int need_wa;
+
+	WARN_ON(scope != SCOPE_LOCAL_CPU || preemptible());
+
+	/* If the CPU has CSV2 set, we're safe */
+	if (cpuid_feature_extract_unsigned_field(read_cpuid(ID_AA64PFR0_EL1),
+						 ID_AA64PFR0_CSV2_SHIFT))
+		return false;
+
+	/* Alternatively, we have a list of unaffected CPUs */
+	if (is_midr_in_range_list(read_cpuid_id(), spectre_v2_safe_list))
+		return false;
+
+	/* Fallback to firmware detection */
+	need_wa = detect_harden_bp_fw();
+	if (!need_wa)
+		return false;
+
+	/* forced off */
+	if (__nospectre_v2) {
+		pr_info_once("spectrev2 mitigation disabled by command line option\n");
+		return false;
+	}
+
+	if (need_wa < 0)
+		pr_warn_once("ARM_SMCCC_ARCH_WORKAROUND_1 missing from firmware\n");
+
+	return (need_wa > 0);
+}
 #endif
 
 const struct arm64_cpu_capabilities arm64_errata[] = {
@@ -639,8 +643,8 @@ const struct arm64_cpu_capabilities arm6
 #ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
 	{
 		.capability = ARM64_HARDEN_BRANCH_PREDICTOR,
-		ERRATA_MIDR_RANGE_LIST(arm64_bp_harden_smccc_cpus),
-		.cpu_enable = enable_smccc_arch_workaround_1,
+		.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
+		.matches = check_branch_predictor,
 	},
 #endif
 	{


