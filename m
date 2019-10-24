Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82B54E32DE
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 14:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502059AbfJXMtW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 08:49:22 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55002 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729266AbfJXMtW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 08:49:22 -0400
Received: by mail-wm1-f67.google.com with SMTP id g7so2689601wmk.4
        for <stable@vger.kernel.org>; Thu, 24 Oct 2019 05:49:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sLjpPo16BUXqgtETbNvCqL8m7bz3Xv6uHZcWSOprkhQ=;
        b=jvMa2mUeTs/AokHLcpBZw5HvSADZmzz0PSxskVwkIsxU5+wE0E1Ym+p4MhWXVNjJR8
         NP75mE/6Xq1W9hlQ8vGIvdqsT35CHMWwaog/yXZzvTuQ+hyFJZ40x1BiE/QPLh/q+5dj
         sWYbEr17BQfnbz76ouKtQgZSx02+K55IrgpMExAjDFyfKm3dg3qyhW14/8tBETGV6QXS
         WV4/DSBYVlNbEomlEcpUUZjYDvW8lmMaMuq7n+bO0AyjKXhAOQ2Lv1X8eqZPRHiZOIVn
         z1qY9b683aSj/91WXK0J9BbLeqSYxOCVN4/jBXpl8+lm1YCOA5TMYFCzAZkX+rgI5eRu
         eOHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sLjpPo16BUXqgtETbNvCqL8m7bz3Xv6uHZcWSOprkhQ=;
        b=B6gWkkcTaR/06CD+/odbUM8NhvSp2nOCFs0ucKB+/pkSY7mLtCx52pqQdTWJqYwCij
         iuRR9f1yNshzEG9b+koZJRbM/yutMpufvH4OiYQPx1ySE5GHwDUW4Et2p9KzN1VMMbMv
         1HobsqslOz8DRoqyg6cxHcVTtLAw9vcBXBhxMiUj4JzdauATRKzhTYBB8E44TOlc53IV
         /sKRqniaqOhJobrUfpCJTi9hwPrIKU4N8QFSaYBeqvWgn0omuAst8NDpI50wAAtmPeqm
         52KPCFQWeHF2J120EYXVNPGd5KsoN8rpEK9Gsf93nwDp3ei0LGb9cbfLbRKUL7pvrQPN
         74hA==
X-Gm-Message-State: APjAAAU4tqwTARypU00hMEE+BEGOZYJCWQmkgqpiOIFkwE2Nbw4+708H
        1LcZl6Bw1cspnWjC8fsVNPSoj0Oh7T7dy4gK
X-Google-Smtp-Source: APXvYqwM01+2sv0iPghKTRdurYEJjgAw+k1lrU+XtxxKWBwyX5SmZBlMlOpGeRrMSX3vq75voywbDg==
X-Received: by 2002:a1c:4d14:: with SMTP id o20mr4981709wmh.7.1571921357128;
        Thu, 24 Oct 2019 05:49:17 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-126-126.w90-88.abo.wanadoo.fr. [90.88.7.126])
        by smtp.gmail.com with ESMTPSA id j22sm29111038wrd.41.2019.10.24.05.49.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 05:49:16 -0700 (PDT)
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
Subject: [PATCH for-stable-4.14 19/48] arm64: capabilities: Allow features based on local CPU scope
Date:   Thu, 24 Oct 2019 14:48:04 +0200
Message-Id: <20191024124833.4158-20-ard.biesheuvel@linaro.org>
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

[ Upstream commit fbd890b9b8497bab04c1d338bd97579a7bc53fab ]

So far we have treated the feature capabilities as system wide
and this wouldn't help with features that could be detected locally
on one or more CPUs (e.g, KPTI, Software prefetch). This patch
splits the feature detection to two phases :

 1) Local CPU features are checked on all boot time active CPUs.
 2) System wide features are checked only once after all CPUs are
    active.

Reviewed-by: Dave Martin <dave.martin@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/kernel/cpufeature.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 291f8899b37f..dda06f3436c2 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -485,6 +485,7 @@ static void __init init_cpu_ftr_reg(u32 sys_reg, u64 new)
 }
 
 extern const struct arm64_cpu_capabilities arm64_errata[];
+static const struct arm64_cpu_capabilities arm64_features[];
 static void update_cpu_capabilities(const struct arm64_cpu_capabilities *caps,
 				    u16 scope_mask, const char *info);
 
@@ -526,11 +527,12 @@ void __init init_cpu_features(struct cpuinfo_arm64 *info)
 	}
 
 	/*
-	 * Run the errata work around checks on the boot CPU, once we have
-	 * initialised the cpu feature infrastructure.
+	 * Run the errata work around and local feature checks on the
+	 * boot CPU, once we have initialised the cpu feature infrastructure.
 	 */
 	update_cpu_capabilities(arm64_errata, SCOPE_LOCAL_CPU,
 				"enabling workaround for");
+	update_cpu_capabilities(arm64_features, SCOPE_LOCAL_CPU, "detected:");
 }
 
 static void update_cpu_ftr_reg(struct arm64_ftr_reg *reg, u64 new)
@@ -1349,15 +1351,18 @@ void check_local_cpu_capabilities(void)
 
 	/*
 	 * If we haven't finalised the system capabilities, this CPU gets
-	 * a chance to update the errata work arounds.
+	 * a chance to update the errata work arounds and local features.
 	 * Otherwise, this CPU should verify that it has all the system
 	 * advertised capabilities.
 	 */
-	if (!sys_caps_initialised)
+	if (!sys_caps_initialised) {
 		update_cpu_capabilities(arm64_errata, SCOPE_LOCAL_CPU,
 					"enabling workaround for");
-	else
+		update_cpu_capabilities(arm64_features, SCOPE_LOCAL_CPU,
+					"detected:");
+	} else {
 		verify_local_cpu_capabilities();
+	}
 }
 
 DEFINE_STATIC_KEY_FALSE(arm64_const_caps_ready);
@@ -1382,7 +1387,7 @@ void __init setup_cpu_features(void)
 	int cls;
 
 	/* Set the CPU feature capabilies */
-	update_cpu_capabilities(arm64_features, SCOPE_ALL, "detected:");
+	update_cpu_capabilities(arm64_features, SCOPE_SYSTEM, "detected:");
 	update_cpu_capabilities(arm64_errata, SCOPE_SYSTEM,
 				"enabling workaround for");
 	enable_cpu_capabilities(arm64_features, SCOPE_ALL);
-- 
2.20.1

