Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B1CA45279
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 05:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726649AbfFNDNB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 23:13:01 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36959 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbfFNDNB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 23:13:01 -0400
Received: by mail-pg1-f193.google.com with SMTP id 20so680597pgr.4
        for <stable@vger.kernel.org>; Thu, 13 Jun 2019 20:13:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PiIAa6Q4cfsybCsVqpR97J+SEY4HmIlUIBQq6F4zyFg=;
        b=txKgJlWMiGHcJGw4VtHy1MXtbdLzlj5qSPE6zgDUbNjqiezwxhLUSyFJQBD0qDIavp
         il6QwxqKtZBTOapQ+t8jId90cX3QYH9CMIhyZ12r/0zXVstGgb0v1o5ka8WBCP2F1IXX
         cbnQ61clKLXVh6/yaTS5eZRSydpb05F1jP0y4HGGhx3qH7rdhohpVNoEZMNqRJpxxB1i
         XRCKWSRDqq1LUkv7Wqg+TQNa/x0STL9SEHqUQnqZpPVON3V44ncjPJ9FH8OO0z446OCw
         SyjqExAqoPUBplTNnOFJDKhLK9kifjlBJDLeVAzcB+2Ifte8pApTfWm7rRkNuNed/S03
         4gpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PiIAa6Q4cfsybCsVqpR97J+SEY4HmIlUIBQq6F4zyFg=;
        b=ZFh6Ux9Ul3mO4OMluWYB600gE0EV3YJutieZWk68ezEdeV653HBl1sv2wtZlz04IxL
         Whg1tMzT/MxP1z/TVoG6Tm9VnN0vWD43Z+C8toHKJTOjQSlYkfwqHI4Ut7Oh4XTluvsk
         jbq8QM9b7l7H3/DIDJHIF1GJAKj8r7J7HYY8Rhmm8JquQWefLQGOi3qV5HEPamY/mVLX
         39fLWfliJdJtp+UblB0M4pbZE2YLFXhLX411XhXanptRgSThee8JuHOKjrxt0iAQmVc1
         DZKppraUv8bruclT4aaxMTq68I2hjT3/7JeXZqSZj4Cm7CwdlBy8spFQWjKVvXxPvucr
         1Qxg==
X-Gm-Message-State: APjAAAWnOmbVzbC9M6Dl8t2pKacskT22nW6hZvOtJ/ajTaYDnadHwrlu
        +KaanEvtdsVlsN5qDi2/fMf7Ww==
X-Google-Smtp-Source: APXvYqw9wZ6D+N+hkuZvdTJLHEcZWbkJs2NOAiExTU2wqynPKyy1FERok1FIZGrWbwIW/iGlsSqEwg==
X-Received: by 2002:a17:90a:cb87:: with SMTP id a7mr9021902pju.130.1560481980685;
        Thu, 13 Jun 2019 20:13:00 -0700 (PDT)
Received: from localhost ([122.172.66.84])
        by smtp.gmail.com with ESMTPSA id 133sm1056831pfa.92.2019.06.13.20.12.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 20:13:00 -0700 (PDT)
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
Subject: [PATCH v4.4 25/45] arm64: Implement branch predictor hardening for affected Cortex-A CPUs
Date:   Fri, 14 Jun 2019 08:38:08 +0530
Message-Id: <5c2d88d87e6639249d2cd58e359ce40613ee9aee.1560480942.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1560480942.git.viresh.kumar@linaro.org>
References: <cover.1560480942.git.viresh.kumar@linaro.org>
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
index c05135cd53fe..aa9cd47b5c6f 100644
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

