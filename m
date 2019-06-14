Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3804528E
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 05:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbfFNDNu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 23:13:50 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:38188 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726705AbfFNDNu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 23:13:50 -0400
Received: by mail-pg1-f193.google.com with SMTP id v11so679060pgl.5
        for <stable@vger.kernel.org>; Thu, 13 Jun 2019 20:13:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AWHPUBB3ixlXuGv+k0bkvZFjFDMYGzP6IksF+WhcPsw=;
        b=PKtJSvl7jEEaS+KAJnnItlRSBzgFPcvNacURq042QNfvpy2cUe5UTwO6kraPn7+Lbi
         jlxci1UhA3Rho59bTpzl/1OllJ3wfyPfNHHDOeExNGNwErw+LyzqgNQ2l157Xy/YpISM
         TfLHEjCt0OD4O3IDsXJCtnAQ1QiXv2ML6KkpXCtb8g08FsmTzCHwulyba/c0gq5YDI/E
         raXCx2497zdc9gBCNNASMQWvOJyymUHHgmM8LR1tzaQp9oMf8tCcJJ+vr/PUiOckO9U2
         taVNEWQ8jvhPKlR81BiQfQNhY2+83c1Q4dmDuQWEflTnT1iHHxyVC1MYYpjHrZDqTE/3
         ZPoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AWHPUBB3ixlXuGv+k0bkvZFjFDMYGzP6IksF+WhcPsw=;
        b=FNDEIPl+qX+Hz3ifx+cl/cJuIUb40krS0/d5xKQHUDbC0NbWg5H6DtXp7HRrelCOpY
         0Idich278tuisbIyroqPb/yJkUQvTa0njrlwta++U6Z6DKPbDaf4WHezwQ94fyw6+FZ/
         0Q20HxDaMYm+RlW78nEzzDzb4BGYvsxz2sBtV7Jn+SrgwLSCVMYvrs5yNCAjFWyAiOOD
         Zd1LnhWUj+k9KiHKujejS17EP6yHOPUM+Weqi74/gl9s/5pKob75NAT4ny8p7jsL9DOm
         kWXPeVTHbv4dcBLaW5B4CeSzTJlIM+eR18eCQcqBrCU+bLXTjUnmKVpZTBb5PkzEvnrb
         xZ9g==
X-Gm-Message-State: APjAAAUyYlWZiVsfSxrMb7OSxSzU66USueF1rIBBdl/hKNu1Xi8ko8nr
        lfJX+9cePlEaRVsv2Vh5ZHWBWw==
X-Google-Smtp-Source: APXvYqwOmTyfi1VeIbUlXauf+wL1jE5w3jP/lBDkJoKG2slBik2MP6qS+UEi6rwmNYywOtAFl2MXPw==
X-Received: by 2002:a63:490a:: with SMTP id w10mr33227135pga.6.1560482029343;
        Thu, 13 Jun 2019 20:13:49 -0700 (PDT)
Received: from localhost ([122.172.66.84])
        by smtp.gmail.com with ESMTPSA id 25sm1051970pfp.76.2019.06.13.20.13.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 20:13:48 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     linux-arm-kernel@lists.infradead.org,
        Julien Thierry <Julien.Thierry@arm.com>
Cc:     Viresh Kumar <viresh.kumar@linaro.org>, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
Subject: [PATCH v4.4 44/45] arm64: Kill PSCI_GET_VERSION as a variant-2 workaround
Date:   Fri, 14 Jun 2019 08:38:27 +0530
Message-Id: <c30381b166496955e75ed238e1c8f20867b1e862.1560480942.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1560480942.git.viresh.kumar@linaro.org>
References: <cover.1560480942.git.viresh.kumar@linaro.org>
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
index 506b339b91bb..c9a2c5a1e0aa 100644
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

