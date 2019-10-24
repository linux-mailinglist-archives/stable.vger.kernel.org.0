Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 578EAE32E8
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 14:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502109AbfJXMti (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 08:49:38 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54050 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502111AbfJXMti (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 08:49:38 -0400
Received: by mail-wm1-f65.google.com with SMTP id n7so1870100wmc.3
        for <stable@vger.kernel.org>; Thu, 24 Oct 2019 05:49:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=L64nOCW6FM4Pk/zxESTcpq0V01x1u3ymKSxGXQkczyU=;
        b=hVdiExzbCUXEvD7/FH6760jMucPAtkoIYyQ5TKc4C6AjLdMUmeNeTV3TGOZkOZhjWI
         84jZS/AVeukDKR4X/MRByiBYy55dRJEfy2vpiWU8/4HqUJhKAWPDhdAqYMcWNjkho0lK
         LU9ATwxCJr57wA9eqqYrHMDfbclM3gM0V1irCoRHJ+ws89Emb1lMRsCHTGODKiuGuhk5
         J1UVfVuncV1iE7KATTirlAqUVASaGtOLvAKPRZlPXNAH8YSAyBsntHj+nJyxTb7bd8yQ
         TpfKGyGflOKuM2VAfSfaAvRxV14NCNXM+4DjvtWuOA5OVEUAYiY5rqdVpTeam44J750O
         t5Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L64nOCW6FM4Pk/zxESTcpq0V01x1u3ymKSxGXQkczyU=;
        b=q+gVlC5e9zCBu7AR9+GR/5Y5dOsGf0ybz5bv+aPf7XhY6nTxl80I71QfLWRVAqHlrJ
         X+Px8b48b8hxJMP6ucGfoXJcPX0Phe6HLajqdZ3O0a3s+Xj/t55Lkn9DnN5tXgWgyOt/
         bL/mb5B88eK01JoXGGIRpaWfLCYJzNWCWBLa4SecPQq4W5E/ObKIDWRcY5oH1bpzhQMi
         x2qDrLRzELlGj85Z0P9Q7i4eF0c9jlOquPwfS6CPU8FNye2DioUjAxqOfDNDi0nY+GQy
         uzbcrp1Cd5Lar6eBUKoUQh6OcMqrFoqeVoec4NIhVpsfpR5IkJhW+YAPAqjZcpVmjEGx
         I9Lw==
X-Gm-Message-State: APjAAAVYXmSCa3TOQJi7Cp9SkZVF2wTYWUrc5t3+Zl8Ht+hOli3nZ4Rt
        b3wJKXAXOqCkZMof/iF18nV0qxwjsvsWtqhH
X-Google-Smtp-Source: APXvYqw+pa3bOTTwESaERSUPb5Kv+spjrO2jp3KZAf7Eagvk2ygl0DI/wYHSowIASZE+msy4AGqgWg==
X-Received: by 2002:a1c:f212:: with SMTP id s18mr4622576wmc.72.1571921375358;
        Thu, 24 Oct 2019 05:49:35 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-126-126.w90-88.abo.wanadoo.fr. [90.88.7.126])
        by smtp.gmail.com with ESMTPSA id j22sm29111038wrd.41.2019.10.24.05.49.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 05:49:34 -0700 (PDT)
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
        Shanker Donthineni <shankerd@codeaurora.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH for-stable-4.14 29/48] arm64: KVM: Use SMCCC_ARCH_WORKAROUND_1 for Falkor BP hardening
Date:   Thu, 24 Oct 2019 14:48:14 +0200
Message-Id: <20191024124833.4158-30-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191024124833.4158-1-ard.biesheuvel@linaro.org>
References: <20191024124833.4158-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shanker Donthineni <shankerd@codeaurora.org>

[ Upstream commit 4bc352ffb39e4eec253e70f8c076f2f48a6c1926 ]

The function SMCCC_ARCH_WORKAROUND_1 was introduced as part of SMC
V1.1 Calling Convention to mitigate CVE-2017-5715. This patch uses
the standard call SMCCC_ARCH_WORKAROUND_1 for Falkor chips instead
of Silicon provider service ID 0xC2001700.

Cc: <stable@vger.kernel.org> # 4.14+
Signed-off-by: Shanker Donthineni <shankerd@codeaurora.org>
[maz: reworked errata framework integration]
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/include/asm/cpucaps.h |  7 ++-
 arch/arm64/include/asm/kvm_asm.h |  2 -
 arch/arm64/kernel/bpi.S          |  7 ---
 arch/arm64/kernel/cpu_errata.c   | 54 ++++++--------------
 arch/arm64/kvm/hyp/entry.S       | 12 -----
 arch/arm64/kvm/hyp/switch.c      | 10 ----
 6 files changed, 20 insertions(+), 72 deletions(-)

diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index 7d6425d426ac..0ed9f7951097 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -42,10 +42,9 @@
 #define ARM64_HAS_DCPOP				21
 #define ARM64_UNMAP_KERNEL_AT_EL0		23
 #define ARM64_HARDEN_BRANCH_PREDICTOR		24
-#define ARM64_HARDEN_BP_POST_GUEST_EXIT		25
-#define ARM64_SSBD				26
-#define ARM64_MISMATCHED_CACHE_TYPE		27
+#define ARM64_SSBD				25
+#define ARM64_MISMATCHED_CACHE_TYPE		26
 
-#define ARM64_NCAPS				28
+#define ARM64_NCAPS				27
 
 #endif /* __ASM_CPUCAPS_H */
diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 1a6d02350fc6..c59e81b65132 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -70,8 +70,6 @@ extern u32 __kvm_get_mdcr_el2(void);
 
 extern u32 __init_stage2_translation(void);
 
-extern void __qcom_hyp_sanitize_btac_predictors(void);
-
 /* Home-grown __this_cpu_{ptr,read} variants that always work at HYP */
 #define __hyp_this_cpu_ptr(sym)						\
 	({								\
diff --git a/arch/arm64/kernel/bpi.S b/arch/arm64/kernel/bpi.S
index e5de33513b5d..0af46cfdbbf3 100644
--- a/arch/arm64/kernel/bpi.S
+++ b/arch/arm64/kernel/bpi.S
@@ -55,13 +55,6 @@ ENTRY(__bp_harden_hyp_vecs_start)
 	.endr
 ENTRY(__bp_harden_hyp_vecs_end)
 
-ENTRY(__qcom_hyp_sanitize_link_stack_start)
-	stp     x29, x30, [sp, #-16]!
-	.rept	16
-	bl	. + 4
-	.endr
-	ldp	x29, x30, [sp], #16
-ENTRY(__qcom_hyp_sanitize_link_stack_end)
 
 .macro smccc_workaround_1 inst
 	sub	sp, sp, #(8 * 4)
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 096a679510ad..4204b668df7a 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -83,8 +83,6 @@ cpu_enable_trap_ctr_access(const struct arm64_cpu_capabilities *__unused)
 DEFINE_PER_CPU_READ_MOSTLY(struct bp_hardening_data, bp_hardening_data);
 
 #ifdef CONFIG_KVM
-extern char __qcom_hyp_sanitize_link_stack_start[];
-extern char __qcom_hyp_sanitize_link_stack_end[];
 extern char __smccc_workaround_1_smc_start[];
 extern char __smccc_workaround_1_smc_end[];
 extern char __smccc_workaround_1_hvc_start[];
@@ -131,8 +129,6 @@ static void __install_bp_hardening_cb(bp_hardening_cb_t fn,
 	spin_unlock(&bp_lock);
 }
 #else
-#define __qcom_hyp_sanitize_link_stack_start	NULL
-#define __qcom_hyp_sanitize_link_stack_end	NULL
 #define __smccc_workaround_1_smc_start		NULL
 #define __smccc_workaround_1_smc_end		NULL
 #define __smccc_workaround_1_hvc_start		NULL
@@ -177,12 +173,25 @@ static void call_hvc_arch_workaround_1(void)
 	arm_smccc_1_1_hvc(ARM_SMCCC_ARCH_WORKAROUND_1, NULL);
 }
 
+static void qcom_link_stack_sanitization(void)
+{
+	u64 tmp;
+
+	asm volatile("mov	%0, x30		\n"
+		     ".rept	16		\n"
+		     "bl	. + 4		\n"
+		     ".endr			\n"
+		     "mov	x30, %0		\n"
+		     : "=&r" (tmp));
+}
+
 static void
 enable_smccc_arch_workaround_1(const struct arm64_cpu_capabilities *entry)
 {
 	bp_hardening_cb_t cb;
 	void *smccc_start, *smccc_end;
 	struct arm_smccc_res res;
+	u32 midr = read_cpuid_id();
 
 	if (!entry->matches(entry, SCOPE_LOCAL_CPU))
 		return;
@@ -215,30 +224,14 @@ enable_smccc_arch_workaround_1(const struct arm64_cpu_capabilities *entry)
 		return;
 	}
 
+	if (((midr & MIDR_CPU_MODEL_MASK) == MIDR_QCOM_FALKOR) ||
+	    ((midr & MIDR_CPU_MODEL_MASK) == MIDR_QCOM_FALKOR_V1))
+		cb = qcom_link_stack_sanitization;
+
 	install_bp_hardening_cb(entry, cb, smccc_start, smccc_end);
 
 	return;
 }
-
-static void qcom_link_stack_sanitization(void)
-{
-	u64 tmp;
-
-	asm volatile("mov	%0, x30		\n"
-		     ".rept	16		\n"
-		     "bl	. + 4		\n"
-		     ".endr			\n"
-		     "mov	x30, %0		\n"
-		     : "=&r" (tmp));
-}
-
-static void
-qcom_enable_link_stack_sanitization(const struct arm64_cpu_capabilities *entry)
-{
-	install_bp_hardening_cb(entry, qcom_link_stack_sanitization,
-				__qcom_hyp_sanitize_link_stack_start,
-				__qcom_hyp_sanitize_link_stack_end);
-}
 #endif	/* CONFIG_HARDEN_BRANCH_PREDICTOR */
 
 #ifdef CONFIG_ARM64_SSBD
@@ -463,10 +456,6 @@ static const struct midr_range arm64_bp_harden_smccc_cpus[] = {
 	MIDR_ALL_VERSIONS(MIDR_CORTEX_A75),
 	MIDR_ALL_VERSIONS(MIDR_BRCM_VULCAN),
 	MIDR_ALL_VERSIONS(MIDR_CAVIUM_THUNDERX2),
-	{},
-};
-
-static const struct midr_range qcom_bp_harden_cpus[] = {
 	MIDR_ALL_VERSIONS(MIDR_QCOM_FALKOR_V1),
 	MIDR_ALL_VERSIONS(MIDR_QCOM_FALKOR),
 	{},
@@ -618,15 +607,6 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		ERRATA_MIDR_RANGE_LIST(arm64_bp_harden_smccc_cpus),
 		.cpu_enable = enable_smccc_arch_workaround_1,
 	},
-	{
-		.capability = ARM64_HARDEN_BRANCH_PREDICTOR,
-		ERRATA_MIDR_RANGE_LIST(qcom_bp_harden_cpus),
-		.cpu_enable = qcom_enable_link_stack_sanitization,
-	},
-	{
-		.capability = ARM64_HARDEN_BP_POST_GUEST_EXIT,
-		ERRATA_MIDR_RANGE_LIST(qcom_bp_harden_cpus),
-	},
 #endif
 #ifdef CONFIG_ARM64_SSBD
 	{
diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index a7b3c198d4de..a360ac6e89e9 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -196,15 +196,3 @@ alternative_endif
 
 	eret
 ENDPROC(__fpsimd_guest_restore)
-
-ENTRY(__qcom_hyp_sanitize_btac_predictors)
-	/**
-	 * Call SMC64 with Silicon provider serviceID 23<<8 (0xc2001700)
-	 * 0xC2000000-0xC200FFFF: assigned to SiP Service Calls
-	 * b15-b0: contains SiP functionID
-	 */
-	movz    x0, #0x1700
-	movk    x0, #0xc200, lsl #16
-	smc     #0
-	ret
-ENDPROC(__qcom_hyp_sanitize_btac_predictors)
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 44845996b554..4a8fdbb29286 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -405,16 +405,6 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	__set_host_arch_workaround_state(vcpu);
 
-	if (cpus_have_const_cap(ARM64_HARDEN_BP_POST_GUEST_EXIT)) {
-		u32 midr = read_cpuid_id();
-
-		/* Apply BTAC predictors mitigation to all Falkor chips */
-		if (((midr & MIDR_CPU_MODEL_MASK) == MIDR_QCOM_FALKOR) ||
-		    ((midr & MIDR_CPU_MODEL_MASK) == MIDR_QCOM_FALKOR_V1)) {
-			__qcom_hyp_sanitize_btac_predictors();
-		}
-	}
-
 	fp_enabled = __fpsimd_enabled();
 
 	__sysreg_save_guest_state(guest_ctxt);
-- 
2.20.1

