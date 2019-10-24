Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E856EE32DC
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 14:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729570AbfJXMtQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 08:49:16 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37078 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729502AbfJXMtQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 08:49:16 -0400
Received: by mail-wr1-f68.google.com with SMTP id e11so17238062wrv.4
        for <stable@vger.kernel.org>; Thu, 24 Oct 2019 05:49:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=l/0r/zgR6xJuYBaKWXZiKnEuixSvKC06vXoCFw+H5e4=;
        b=bXm2C9dj2eGIy0kN2RVPrrZdiBlrjgGpEejRJfdDgCCZBdKjARXhHmEP/HEEauVLtB
         ozQC+4STIsgUMtsLa+rhrR27NkgTFvH7frHJ/G/wJPiZ65QrQ5xv0gWDAVfxgVrYmlY4
         8IyTmCdwowh7bPXOcUAe1Drypes6sQy1hPiD5raETsryS1yy8zWTbBX6BThuJc7Oz6jH
         KJilwLFsAVJmgiNpqccduU+drQ8CTwEugKh31DGCqO0g4IcFDzatpb3lfRDEIQm730KL
         f5J+wPV86FJO4HNuTMUekHqCuZ5SzudE0hHxT6v5nvs8UaG87HDnkk08oeLGIOUvtCJf
         kWbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l/0r/zgR6xJuYBaKWXZiKnEuixSvKC06vXoCFw+H5e4=;
        b=GNJq5dkHzHms38L5wCxd8PiM5JLkGaDXJcbOkQJ89sgdQDvHj73FJ2ILb/DTlPQS0k
         /O44jn3KulhZJSeTwd3lHjQvhNUvaucnl5dTbHW1hFc2ykva/SA5u1tk2MNXvEvF0VV0
         2y4/8L1aiCBNyxabprhPlePukRgSmEwnSVCeHfOQJ/3vbdt+aeHLiEK5UkTGzP9dU1oY
         D7AJJWlFDo6ZeD+0qfrUu9vLJdHq7OqOmMHl1FKaw10iooq8DpWgJPwEEpDCl9806OOK
         hgGaTHvnKP3tdCQzKlR4DQNiMkHn6YZwGAUQ7qJcLIlNmaW9kCzkzcwojuQnU/qAVFK5
         mInw==
X-Gm-Message-State: APjAAAUkHv8TLR7bDNubjVgxmLywoPcMaz8Rr0F2lppXQWdMex9zyOWb
        dROZ6aLnL03foJ7sIHHx3zXVL6t70iqDh5k/
X-Google-Smtp-Source: APXvYqzWIVFu3arp2monmXqOzuSGsYRmc8wGt5UUPX43IR7JuM65esS8kadbFIvMDH/Au3JKVLYGZQ==
X-Received: by 2002:adf:fe81:: with SMTP id l1mr3609124wrr.165.1571921354250;
        Thu, 24 Oct 2019 05:49:14 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-126-126.w90-88.abo.wanadoo.fr. [90.88.7.126])
        by smtp.gmail.com with ESMTPSA id j22sm29111038wrd.41.2019.10.24.05.49.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 05:49:13 -0700 (PDT)
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
Subject: [PATCH for-stable-4.14 17/48] arm64: capabilities: Prepare for grouping features and errata work arounds
Date:   Thu, 24 Oct 2019 14:48:02 +0200
Message-Id: <20191024124833.4158-18-ard.biesheuvel@linaro.org>
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

[ Upstream commit 600b9c919c2f4d07a7bf67864086aa3432224674 ]

We are about to group the handling of all capabilities (features
and errata workarounds). This patch open codes the wrapper routines
to make it easier to merge the handling.

Reviewed-by: Dave Martin <dave.martin@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/kernel/cpufeature.c | 58 ++++++--------------
 1 file changed, 18 insertions(+), 40 deletions(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index b88871d5f179..bc76597abe7b 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -485,7 +485,8 @@ static void __init init_cpu_ftr_reg(u32 sys_reg, u64 new)
 }
 
 extern const struct arm64_cpu_capabilities arm64_errata[];
-static void update_cpu_errata_workarounds(void);
+static void update_cpu_capabilities(const struct arm64_cpu_capabilities *caps,
+				    u16 scope_mask, const char *info);
 
 void __init init_cpu_features(struct cpuinfo_arm64 *info)
 {
@@ -528,7 +529,8 @@ void __init init_cpu_features(struct cpuinfo_arm64 *info)
 	 * Run the errata work around checks on the boot CPU, once we have
 	 * initialised the cpu feature infrastructure.
 	 */
-	update_cpu_errata_workarounds();
+	update_cpu_capabilities(arm64_errata, SCOPE_ALL,
+				"enabling workaround for");
 }
 
 static void update_cpu_ftr_reg(struct arm64_ftr_reg *reg, u64 new)
@@ -1312,33 +1314,6 @@ verify_local_elf_hwcaps(const struct arm64_cpu_capabilities *caps)
 		}
 }
 
-static void verify_local_cpu_features(void)
-{
-	if (!__verify_local_cpu_caps(arm64_features, SCOPE_ALL))
-		cpu_die_early();
-}
-
-/*
- * The CPU Errata work arounds are detected and applied at boot time
- * and the related information is freed soon after. If the new CPU requires
- * an errata not detected at boot, fail this CPU.
- */
-static void verify_local_cpu_errata_workarounds(void)
-{
-	if (!__verify_local_cpu_caps(arm64_errata, SCOPE_ALL))
-		cpu_die_early();
-}
-
-static void update_cpu_errata_workarounds(void)
-{
-	update_cpu_capabilities(arm64_errata, SCOPE_ALL,
-				"enabling workaround for");
-}
-
-static void __init enable_errata_workarounds(void)
-{
-	enable_cpu_capabilities(arm64_errata, SCOPE_ALL);
-}
 
 /*
  * Run through the enabled system capabilities and enable() it on this CPU.
@@ -1350,8 +1325,15 @@ static void __init enable_errata_workarounds(void)
  */
 static void verify_local_cpu_capabilities(void)
 {
-	verify_local_cpu_errata_workarounds();
-	verify_local_cpu_features();
+	/*
+	 * The CPU Errata work arounds are detected and applied at boot time
+	 * and the related information is freed soon after. If the new CPU
+	 * requires an errata not detected at boot, fail this CPU.
+	 */
+	if (!__verify_local_cpu_caps(arm64_errata, SCOPE_ALL))
+		cpu_die_early();
+	if (!__verify_local_cpu_caps(arm64_features, SCOPE_ALL))
+		cpu_die_early();
 	verify_local_elf_hwcaps(arm64_elf_hwcaps);
 	if (system_supports_32bit_el0())
 		verify_local_elf_hwcaps(compat_elf_hwcaps);
@@ -1372,17 +1354,12 @@ void check_local_cpu_capabilities(void)
 	 * advertised capabilities.
 	 */
 	if (!sys_caps_initialised)
-		update_cpu_errata_workarounds();
+		update_cpu_capabilities(arm64_errata, SCOPE_ALL,
+					"enabling workaround for");
 	else
 		verify_local_cpu_capabilities();
 }
 
-static void __init setup_feature_capabilities(void)
-{
-	update_cpu_capabilities(arm64_features, SCOPE_ALL, "detected:");
-	enable_cpu_capabilities(arm64_features, SCOPE_ALL);
-}
-
 DEFINE_STATIC_KEY_FALSE(arm64_const_caps_ready);
 EXPORT_SYMBOL(arm64_const_caps_ready);
 
@@ -1405,8 +1382,9 @@ void __init setup_cpu_features(void)
 	int cls;
 
 	/* Set the CPU feature capabilies */
-	setup_feature_capabilities();
-	enable_errata_workarounds();
+	update_cpu_capabilities(arm64_features, SCOPE_ALL, "detected:");
+	enable_cpu_capabilities(arm64_features, SCOPE_ALL);
+	enable_cpu_capabilities(arm64_errata, SCOPE_ALL);
 	mark_const_caps_ready();
 	setup_elf_hwcaps(arm64_elf_hwcaps);
 
-- 
2.20.1

