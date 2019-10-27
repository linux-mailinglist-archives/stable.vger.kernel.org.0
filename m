Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1C58E6929
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:35:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729534AbfJ0VJl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:09:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:56066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726944AbfJ0VJk (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:09:40 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82D06208C0;
        Sun, 27 Oct 2019 21:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210579;
        bh=At+FQ12EKlZJ3YHTALtJGE3NFUpwi7l5a+KXMdnLByw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uJKdBMMz7cSgeaYfVUUff7dcLrWLpOMVZn7RYRoqZnTzPaBET9J890zXsy4KHQNAr
         nbmycXF+GfXjA5eYXOnZTmm4Ut8eL6kL6ubCMw6YUkibSgtZVKF0MIPLNQCj1OZark
         LA6NspiUffED1z3rmAeuzfsvyPlROhVyh7JYlW8g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shanker Donthineni <shankerd@codeaurora.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 4.14 065/119] arm64: KVM: Use SMCCC_ARCH_WORKAROUND_1 for Falkor BP hardening
Date:   Sun, 27 Oct 2019 22:00:42 +0100
Message-Id: <20191027203330.640377109@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/cpucaps.h |    7 ++---
 arch/arm64/include/asm/kvm_asm.h |    2 -
 arch/arm64/kernel/bpi.S          |    7 -----
 arch/arm64/kernel/cpu_errata.c   |   54 ++++++++++++---------------------------
 arch/arm64/kvm/hyp/entry.S       |   12 --------
 arch/arm64/kvm/hyp/switch.c      |   10 -------
 6 files changed, 20 insertions(+), 72 deletions(-)

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
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -70,8 +70,6 @@ extern u32 __kvm_get_mdcr_el2(void);
 
 extern u32 __init_stage2_translation(void);
 
-extern void __qcom_hyp_sanitize_btac_predictors(void);
-
 /* Home-grown __this_cpu_{ptr,read} variants that always work at HYP */
 #define __hyp_this_cpu_ptr(sym)						\
 	({								\
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
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -83,8 +83,6 @@ cpu_enable_trap_ctr_access(const struct
 DEFINE_PER_CPU_READ_MOSTLY(struct bp_hardening_data, bp_hardening_data);
 
 #ifdef CONFIG_KVM
-extern char __qcom_hyp_sanitize_link_stack_start[];
-extern char __qcom_hyp_sanitize_link_stack_end[];
 extern char __smccc_workaround_1_smc_start[];
 extern char __smccc_workaround_1_smc_end[];
 extern char __smccc_workaround_1_hvc_start[];
@@ -131,8 +129,6 @@ static void __install_bp_hardening_cb(bp
 	spin_unlock(&bp_lock);
 }
 #else
-#define __qcom_hyp_sanitize_link_stack_start	NULL
-#define __qcom_hyp_sanitize_link_stack_end	NULL
 #define __smccc_workaround_1_smc_start		NULL
 #define __smccc_workaround_1_smc_end		NULL
 #define __smccc_workaround_1_hvc_start		NULL
@@ -177,12 +173,25 @@ static void call_hvc_arch_workaround_1(v
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
@@ -215,30 +224,14 @@ enable_smccc_arch_workaround_1(const str
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
@@ -463,10 +456,6 @@ static const struct midr_range arm64_bp_
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
@@ -618,15 +607,6 @@ const struct arm64_cpu_capabilities arm6
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
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -405,16 +405,6 @@ again:
 
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


