Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB4D7A18DC
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 13:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727308AbfH2LgQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 07:36:16 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:45937 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727233AbfH2LgQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Aug 2019 07:36:16 -0400
Received: by mail-pf1-f195.google.com with SMTP id w26so1847126pfq.12
        for <stable@vger.kernel.org>; Thu, 29 Aug 2019 04:36:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mSGnDnoJppey6/ef3bclxREaifXq44bcCaQXzmdFJKI=;
        b=nXcOnYdYMdRjWarWiT6SdA55JtdySdi8Xl5GquX5MxjKkQzJ9KFmEQOzRPFYPJRpSr
         wcuvNVoh2ZQkX3w9Jqr+g20rf272MKrogLKH2Wrfiys31R+f+e0s7EyJHAR4Kso0QYIS
         D62puFY/Dy7VzsKWWPCHiYGubvMeKmzHHbTV2hy0Q1t2neSTTqrNWBUjJ7J2NFNyojm3
         fAeRLY7nruyHOH+YaJ6yqANeyXlx7xxx7AkgtM4lgAPhxc4CdzNBWyE094lmFoa2YSnv
         J1AOKcOp+FBmNBohefYmwPPT8iW56v6bLb33jf1J+pliVneLKuX3WU7741dOLqkstbL6
         KWeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mSGnDnoJppey6/ef3bclxREaifXq44bcCaQXzmdFJKI=;
        b=pV4Nu0ggnSlCaykQ/7zJ/FkqWyn1TF7ZYnAYRQMkEuZ1VAZpqL/YdM+6fTCi52Geut
         KqJ/CtD0tY7kLMHfjgy7qNY7FRhp/MnZ0Cwh8JiK25vUMeHMWJj+/R1Zdr/7Hkk5CJ2n
         ppiJM32WRZWBm8fbrNOse16OQ36Ga8ueSGGVi8aCjg/OgHJ1mBWtzhkh0N4jK3YOnFA8
         nHC5LdF2DlhU+uKCSMdpD+IKvPUfaFBLD3SA8yCWrzohH05jiT2hexV9ETRqrBNRYvgC
         tL6MeoU6oGu40qMIIc0euRs0reDsxpzExuI9CKgqEyF1OYLA2EgF6q0IQH9dZ9NX90jh
         G4GQ==
X-Gm-Message-State: APjAAAWBcrN5DfaUFe8zgl85u4r/uvyFz1mFUpYqsJzl7+ky3CmJ/bm3
        mHziXkPPAKoBDlw+7kgL8PGvYt+QzNw=
X-Google-Smtp-Source: APXvYqwiI0awlFwDAqhtfv3LBUFB5YmO7b8fmUBrTEao08/A4jmooMnqHqSxK3ghbhVIkCohUz/TXg==
X-Received: by 2002:a17:90a:8c94:: with SMTP id b20mr7222310pjo.127.1567078575132;
        Thu, 29 Aug 2019 04:36:15 -0700 (PDT)
Received: from localhost ([122.167.132.221])
        by smtp.gmail.com with ESMTPSA id u4sm2734902pfh.186.2019.08.29.04.36.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 04:36:14 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     stable@vger.kernel.org, Julien Thierry <Julien.Thierry@arm.com>,
        Mark Rutland <mark.rutland@arm.com>
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
Subject: [PATCH ARM64 v4.4 V3 31/44] arm64: Implement branch predictor hardening for affected Cortex-A CPUs
Date:   Thu, 29 Aug 2019 17:04:16 +0530
Message-Id: <13a05e3ef8a5b63df9eae88bc995f81c925e81fc.1567077734.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1567077734.git.viresh.kumar@linaro.org>
References: <cover.1567077734.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>

commit aa6acde65e03186b5add8151e1ffe36c3c62639b upstream.

Cortex-A57, A72, A73 and A75 are susceptible to branch predictor aliasing
and can theoretically be attacked by malicious code.

This patch implements a PSCI-based mitigation for these CPUs when available.
The call into firmware will invalidate the branch predictor state, preventing
any malicious entries from affecting other victim contexts.

Co-developed-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm64/kernel/bpi.S        | 24 +++++++++++++++++++
 arch/arm64/kernel/cpu_errata.c | 42 ++++++++++++++++++++++++++++++++++
 2 files changed, 66 insertions(+)

diff --git a/arch/arm64/kernel/bpi.S b/arch/arm64/kernel/bpi.S
index 06a931eb2673..dec95bd82e31 100644
--- a/arch/arm64/kernel/bpi.S
+++ b/arch/arm64/kernel/bpi.S
@@ -53,3 +53,27 @@ ENTRY(__bp_harden_hyp_vecs_start)
 	vectors __kvm_hyp_vector
 	.endr
 ENTRY(__bp_harden_hyp_vecs_end)
+ENTRY(__psci_hyp_bp_inval_start)
+	sub	sp, sp, #(8 * 18)
+	stp	x16, x17, [sp, #(16 * 0)]
+	stp	x14, x15, [sp, #(16 * 1)]
+	stp	x12, x13, [sp, #(16 * 2)]
+	stp	x10, x11, [sp, #(16 * 3)]
+	stp	x8, x9, [sp, #(16 * 4)]
+	stp	x6, x7, [sp, #(16 * 5)]
+	stp	x4, x5, [sp, #(16 * 6)]
+	stp	x2, x3, [sp, #(16 * 7)]
+	stp	x0, x1, [sp, #(16 * 8)]
+	mov	x0, #0x84000000
+	smc	#0
+	ldp	x16, x17, [sp, #(16 * 0)]
+	ldp	x14, x15, [sp, #(16 * 1)]
+	ldp	x12, x13, [sp, #(16 * 2)]
+	ldp	x10, x11, [sp, #(16 * 3)]
+	ldp	x8, x9, [sp, #(16 * 4)]
+	ldp	x6, x7, [sp, #(16 * 5)]
+	ldp	x4, x5, [sp, #(16 * 6)]
+	ldp	x2, x3, [sp, #(16 * 7)]
+	ldp	x0, x1, [sp, #(16 * 8)]
+	add	sp, sp, #(8 * 18)
+ENTRY(__psci_hyp_bp_inval_end)
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 80765feae955..dbd7b944a37e 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -50,6 +50,8 @@ is_affected_midr_range(const struct arm64_cpu_capabilities *entry, int scope)
 DEFINE_PER_CPU_READ_MOSTLY(struct bp_hardening_data, bp_hardening_data);
 
 #ifdef CONFIG_KVM
+extern char __psci_hyp_bp_inval_start[], __psci_hyp_bp_inval_end[];
+
 static void __copy_hyp_vect_bpi(int slot, const char *hyp_vecs_start,
 				const char *hyp_vecs_end)
 {
@@ -91,6 +93,9 @@ static void __install_bp_hardening_cb(bp_hardening_cb_t fn,
 	spin_unlock(&bp_lock);
 }
 #else
+#define __psci_hyp_bp_inval_start	NULL
+#define __psci_hyp_bp_inval_end		NULL
+
 static void __install_bp_hardening_cb(bp_hardening_cb_t fn,
 				      const char *hyp_vecs_start,
 				      const char *hyp_vecs_end)
@@ -115,6 +120,21 @@ static void  install_bp_hardening_cb(const struct arm64_cpu_capabilities *entry,
 
 	__install_bp_hardening_cb(fn, hyp_vecs_start, hyp_vecs_end);
 }
+
+#include <linux/psci.h>
+
+static int enable_psci_bp_hardening(void *data)
+{
+	const struct arm64_cpu_capabilities *entry = data;
+
+	if (psci_ops.get_version)
+		install_bp_hardening_cb(entry,
+				       (bp_hardening_cb_t)psci_ops.get_version,
+				       __psci_hyp_bp_inval_start,
+				       __psci_hyp_bp_inval_end);
+
+	return 0;
+}
 #endif	/* CONFIG_HARDEN_BRANCH_PREDICTOR */
 
 #define MIDR_RANGE(model, min, max) \
@@ -192,6 +212,28 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		MIDR_RANGE(MIDR_THUNDERX, 0x00,
 			   (1 << MIDR_VARIANT_SHIFT) | 1),
 	},
+#endif
+#ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
+	{
+		.capability = ARM64_HARDEN_BRANCH_PREDICTOR,
+		MIDR_ALL_VERSIONS(MIDR_CORTEX_A57),
+		.enable = enable_psci_bp_hardening,
+	},
+	{
+		.capability = ARM64_HARDEN_BRANCH_PREDICTOR,
+		MIDR_ALL_VERSIONS(MIDR_CORTEX_A72),
+		.enable = enable_psci_bp_hardening,
+	},
+	{
+		.capability = ARM64_HARDEN_BRANCH_PREDICTOR,
+		MIDR_ALL_VERSIONS(MIDR_CORTEX_A73),
+		.enable = enable_psci_bp_hardening,
+	},
+	{
+		.capability = ARM64_HARDEN_BRANCH_PREDICTOR,
+		MIDR_ALL_VERSIONS(MIDR_CORTEX_A75),
+		.enable = enable_psci_bp_hardening,
+	},
 #endif
 	{
 	}
-- 
2.21.0.rc0.269.g1a574e7a288b

