Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1773E66642
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 07:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726092AbfGLFaW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 01:30:22 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:38066 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbfGLFaV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jul 2019 01:30:21 -0400
Received: by mail-pl1-f194.google.com with SMTP id az7so4204775plb.5
        for <stable@vger.kernel.org>; Thu, 11 Jul 2019 22:30:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mSGnDnoJppey6/ef3bclxREaifXq44bcCaQXzmdFJKI=;
        b=AzrkWM5iIo1ZtcqhzA8o8nP1Av4xp/bxDcLghhm5ED764ZwvHpspBZwqV9oK7PBbXD
         D7jWNli9CznjZyErdy++iBfdrqmaLoyVLCMlLWCq1DqhFE9CLVeoIsW3NjXOqkSjrIwE
         iynF9AxwDbCmGQCS5Hc/zz0lxvzaX/EvKRlXiXuY2b1H5ZQ6EeMCDhw7aHkj+4Pdqe35
         OzSiMpInWMu6THdHPi7vgYmegdi/JbkvDz2P+eWPotUmU7WBOpQY7aydtSs7Tf7P93Z9
         tWtZ/A7jgtwsqiQrHDgefKkba57bgJ15fEUYv+hgxvRZOBK8k69wQwaygYzfP4i0JKqh
         PfPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mSGnDnoJppey6/ef3bclxREaifXq44bcCaQXzmdFJKI=;
        b=RoPxS/YekXWGUYMcLXr33nBZXUewTQpIOl3629RLqZc+CXseb64GtvMKiEMVtQUn5S
         E7cf3MwwUKs117h4mjXcZElUeXEHqsvYURviemti1AbeDxPUiZlKDecMhjCxQtA1mvSP
         8goAN7u6umSol3R1BGgZ8nAeqIWRacskGkOiOWt863RPA14blEZk/8YIoef5zIzroOtH
         LnzVLqDAWZKdczEnKUL7okZv7HNiR99bEwMIadwOHgGnWeTrydRScjpBostZYxxOKDVb
         7kw3kt9dh6eeyKOcQ4L3sGmqboomVXRprxpntSBJwiOE+zuEJ5vTG/byADzhuqug2+6s
         WGsQ==
X-Gm-Message-State: APjAAAUEgtLUT6SuZk4nvNsrMS9x+BHw31QmLO2F8s/gNf2rtGJMwvF1
        33sp35Oq2dVifwkUcyuaFW1CHQpGp/k=
X-Google-Smtp-Source: APXvYqy8cQfZ9iiEsPFM2ANyBiTRPycOuNDfwTGL3TD8RjFzF/umNpZBZcvlayrEgrWEh3z2wMMJ7Q==
X-Received: by 2002:a17:902:7083:: with SMTP id z3mr9264552plk.278.1562909420730;
        Thu, 11 Jul 2019 22:30:20 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id i124sm14749991pfe.61.2019.07.11.22.30.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jul 2019 22:30:20 -0700 (PDT)
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
Subject: [PATCH v4.4 V2 30/43] arm64: Implement branch predictor hardening for affected Cortex-A CPUs
Date:   Fri, 12 Jul 2019 10:58:18 +0530
Message-Id: <8565dc5d671ce50168b4873cedaf899190c24663.1562908075.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1562908074.git.viresh.kumar@linaro.org>
References: <cover.1562908074.git.viresh.kumar@linaro.org>
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

