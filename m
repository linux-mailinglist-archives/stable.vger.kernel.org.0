Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2796E66654
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 07:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726106AbfGLFaz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 01:30:55 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:36070 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbfGLFaz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jul 2019 01:30:55 -0400
Received: by mail-pl1-f195.google.com with SMTP id k8so4217698plt.3
        for <stable@vger.kernel.org>; Thu, 11 Jul 2019 22:30:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m7Z7PXFPW5Gv6ootIm47hhE0F8LqdUBx5pxecROmwG4=;
        b=IFy7IxpLpQ7mZGfysErd7rdDzsZ4mK6B4xG7u8XFs3k32EOl64TQ5KK6UQ87+LLAbx
         7NVCBF3JXQPP7U6h70wZfTU+EH3+lIdbGrOfjRJo6phHPuMmc6XbQwY2iWYl3r5Zgs04
         SbumIclSYAfLElYb8breL/3fF22q00bXm5OcxC6ioeiGDaTyk1BKl1zVdYtlOdKVIAZZ
         H078vOOqXzTouFMv0mFCG8Mfc9ue74EmKhzw9U6UxWn6N/89w+wI19wcXBegDObDMDET
         bHrSORp5oaAVfrdUY5x/Uv34Ly4dMO4J8osJSM/yF+XIhQRxwx3wZhErTI1xgOql2OLa
         FiEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m7Z7PXFPW5Gv6ootIm47hhE0F8LqdUBx5pxecROmwG4=;
        b=b0zrzY3ALk5OkU7HEJC72w8zPPtPeiETNlrNcmB5dzvT1s3F54NEsg0ku+jh0Ty379
         YJSCfzVguVE+lIXl5VqI6+NcNdso8blnOjoTCxBxecU22rffeUEN+Cbw4OaQeRqJkiyS
         vwdVfr/oAYM3u2vyVABBp6UcUEtUrsHMJId7W8qlDyTVnIPrd6rGSSKTbuHC6+pX6Z8Q
         r4EPdilkdH66EoTESxnOmSf86vmM92lMRnJJvuFq3L5NnCdXcezcOn8rJdSIZiSBnsyQ
         eEubPqnWFcJT0BnK1KG5y0PkJUVY9YXzwjX/3t+/SI0L0oKPxd6xIXlxgVxdP/x10Qog
         APHQ==
X-Gm-Message-State: APjAAAWDR/juFGVd/6BkhIZQnIBkG2B1RZYxNRdVqF+pstpKXiUBR+Ct
        mYTgm7tUXVUvAXhB6AK6RPs0q+8Wc0Y=
X-Google-Smtp-Source: APXvYqxmyTkV8mDt7oI+iMooEOst/1tYr70YNqI9kOH5pIJ09E0iwfnn28jJXEIHDH3YyCEtjd+wEg==
X-Received: by 2002:a17:902:e6:: with SMTP id a93mr9116084pla.175.1562909454186;
        Thu, 11 Jul 2019 22:30:54 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id 195sm11846592pfu.75.2019.07.11.22.30.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jul 2019 22:30:53 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     stable@vger.kernel.org, Julien Thierry <Julien.Thierry@arm.com>
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
Subject: [PATCH v4.4 V2 42/43] arm64: Kill PSCI_GET_VERSION as a variant-2 workaround
Date:   Fri, 12 Jul 2019 10:58:30 +0530
Message-Id: <e6ae4dd9fe11fe90e240f79d9414b35ecdce0c28.1562908075.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1562908074.git.viresh.kumar@linaro.org>
References: <cover.1562908074.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <marc.zyngier@arm.com>

commit 3a0a397ff5ff8b56ca9f7908b75dee6bf0b5fabb upstream.

Now that we've standardised on SMCCC v1.1 to perform the branch
prediction invalidation, let's drop the previous band-aid.
If vendors haven't updated their firmware to do SMCCC 1.1, they
haven't updated PSCI either, so we don't loose anything.

Tested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
[ v4.4: Dropped switch.c changes ]
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm64/kernel/bpi.S        | 24 ------------------
 arch/arm64/kernel/cpu_errata.c | 45 ++++++++++------------------------
 2 files changed, 13 insertions(+), 56 deletions(-)

diff --git a/arch/arm64/kernel/bpi.S b/arch/arm64/kernel/bpi.S
index c72f261f4b64..dc4eb154e33b 100644
--- a/arch/arm64/kernel/bpi.S
+++ b/arch/arm64/kernel/bpi.S
@@ -54,30 +54,6 @@ ENTRY(__bp_harden_hyp_vecs_start)
 	vectors __kvm_hyp_vector
 	.endr
 ENTRY(__bp_harden_hyp_vecs_end)
-ENTRY(__psci_hyp_bp_inval_start)
-	sub	sp, sp, #(8 * 18)
-	stp	x16, x17, [sp, #(16 * 0)]
-	stp	x14, x15, [sp, #(16 * 1)]
-	stp	x12, x13, [sp, #(16 * 2)]
-	stp	x10, x11, [sp, #(16 * 3)]
-	stp	x8, x9, [sp, #(16 * 4)]
-	stp	x6, x7, [sp, #(16 * 5)]
-	stp	x4, x5, [sp, #(16 * 6)]
-	stp	x2, x3, [sp, #(16 * 7)]
-	stp	x0, x1, [sp, #(16 * 8)]
-	mov	x0, #0x84000000
-	smc	#0
-	ldp	x16, x17, [sp, #(16 * 0)]
-	ldp	x14, x15, [sp, #(16 * 1)]
-	ldp	x12, x13, [sp, #(16 * 2)]
-	ldp	x10, x11, [sp, #(16 * 3)]
-	ldp	x8, x9, [sp, #(16 * 4)]
-	ldp	x6, x7, [sp, #(16 * 5)]
-	ldp	x4, x5, [sp, #(16 * 6)]
-	ldp	x2, x3, [sp, #(16 * 7)]
-	ldp	x0, x1, [sp, #(16 * 8)]
-	add	sp, sp, #(8 * 18)
-ENTRY(__psci_hyp_bp_inval_end)
 
 .macro smccc_workaround_1 inst
 	sub	sp, sp, #(8 * 4)
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index d5fd7be563bc..2a17789bb963 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -50,7 +50,6 @@ is_affected_midr_range(const struct arm64_cpu_capabilities *entry, int scope)
 DEFINE_PER_CPU_READ_MOSTLY(struct bp_hardening_data, bp_hardening_data);
 
 #ifdef CONFIG_KVM
-extern char __psci_hyp_bp_inval_start[], __psci_hyp_bp_inval_end[];
 extern char __smccc_workaround_1_smc_start[];
 extern char __smccc_workaround_1_smc_end[];
 extern char __smccc_workaround_1_hvc_start[];
@@ -97,8 +96,6 @@ static void __install_bp_hardening_cb(bp_hardening_cb_t fn,
 	spin_unlock(&bp_lock);
 }
 #else
-#define __psci_hyp_bp_inval_start	NULL
-#define __psci_hyp_bp_inval_end		NULL
 #define __smccc_workaround_1_smc_start		NULL
 #define __smccc_workaround_1_smc_end		NULL
 #define __smccc_workaround_1_hvc_start		NULL
@@ -143,24 +140,25 @@ static void call_hvc_arch_workaround_1(void)
 	arm_smccc_1_1_hvc(ARM_SMCCC_ARCH_WORKAROUND_1, NULL);
 }
 
-static bool check_smccc_arch_workaround_1(const struct arm64_cpu_capabilities *entry)
+static int enable_smccc_arch_workaround_1(void *data)
 {
+	const struct arm64_cpu_capabilities *entry = data;
 	bp_hardening_cb_t cb;
 	void *smccc_start, *smccc_end;
 	struct arm_smccc_res res;
 
 	if (!entry->matches(entry, SCOPE_LOCAL_CPU))
-		return false;
+		return 0;
 
 	if (psci_ops.smccc_version == SMCCC_VERSION_1_0)
-		return false;
+		return 0;
 
 	switch (psci_ops.conduit) {
 	case PSCI_CONDUIT_HVC:
 		arm_smccc_1_1_hvc(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
 				  ARM_SMCCC_ARCH_WORKAROUND_1, &res);
 		if (res.a0)
-			return false;
+			return 0;
 		cb = call_hvc_arch_workaround_1;
 		smccc_start = __smccc_workaround_1_hvc_start;
 		smccc_end = __smccc_workaround_1_hvc_end;
@@ -170,35 +168,18 @@ static bool check_smccc_arch_workaround_1(const struct arm64_cpu_capabilities *e
 		arm_smccc_1_1_smc(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
 				  ARM_SMCCC_ARCH_WORKAROUND_1, &res);
 		if (res.a0)
-			return false;
+			return 0;
 		cb = call_smc_arch_workaround_1;
 		smccc_start = __smccc_workaround_1_smc_start;
 		smccc_end = __smccc_workaround_1_smc_end;
 		break;
 
 	default:
-		return false;
+		return 0;
 	}
 
 	install_bp_hardening_cb(entry, cb, smccc_start, smccc_end);
 
-	return true;
-}
-
-static int enable_psci_bp_hardening(void *data)
-{
-	const struct arm64_cpu_capabilities *entry = data;
-
-	if (psci_ops.get_version) {
-		if (check_smccc_arch_workaround_1(entry))
-			return 0;
-
-		install_bp_hardening_cb(entry,
-				       (bp_hardening_cb_t)psci_ops.get_version,
-				       __psci_hyp_bp_inval_start,
-				       __psci_hyp_bp_inval_end);
-	}
-
 	return 0;
 }
 #endif	/* CONFIG_HARDEN_BRANCH_PREDICTOR */
@@ -283,32 +264,32 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 	{
 		.capability = ARM64_HARDEN_BRANCH_PREDICTOR,
 		MIDR_ALL_VERSIONS(MIDR_CORTEX_A57),
-		.enable = enable_psci_bp_hardening,
+		.enable = enable_smccc_arch_workaround_1,
 	},
 	{
 		.capability = ARM64_HARDEN_BRANCH_PREDICTOR,
 		MIDR_ALL_VERSIONS(MIDR_CORTEX_A72),
-		.enable = enable_psci_bp_hardening,
+		.enable = enable_smccc_arch_workaround_1,
 	},
 	{
 		.capability = ARM64_HARDEN_BRANCH_PREDICTOR,
 		MIDR_ALL_VERSIONS(MIDR_CORTEX_A73),
-		.enable = enable_psci_bp_hardening,
+		.enable = enable_smccc_arch_workaround_1,
 	},
 	{
 		.capability = ARM64_HARDEN_BRANCH_PREDICTOR,
 		MIDR_ALL_VERSIONS(MIDR_CORTEX_A75),
-		.enable = enable_psci_bp_hardening,
+		.enable = enable_smccc_arch_workaround_1,
 	},
 	{
 		.capability = ARM64_HARDEN_BRANCH_PREDICTOR,
 		MIDR_ALL_VERSIONS(MIDR_BRCM_VULCAN),
-		.enable = enable_psci_bp_hardening,
+		.enable = enable_smccc_arch_workaround_1,
 	},
 	{
 		.capability = ARM64_HARDEN_BRANCH_PREDICTOR,
 		MIDR_ALL_VERSIONS(MIDR_CAVIUM_THUNDERX2),
-		.enable = enable_psci_bp_hardening,
+		.enable = enable_smccc_arch_workaround_1,
 	},
 #endif
 	{
-- 
2.21.0.rc0.269.g1a574e7a288b

