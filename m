Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 345C4CFDDD
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 17:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728185AbfJHPk2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 11:40:28 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46729 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728132AbfJHPk2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 11:40:28 -0400
Received: by mail-wr1-f68.google.com with SMTP id o18so19926564wrv.13
        for <stable@vger.kernel.org>; Tue, 08 Oct 2019 08:40:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xVW9YVfjij9vCoDvPQUdIJ4SaHECQBvveZX1DwTyL70=;
        b=CkH3V+Bg52IIiejwB7MJHrut8r0ZNm/pGILs03lNlE/a/HfmcdZspkl0VlLvPve04Z
         rFjR4bEabYl6kAu3KdPXO3SMd9wGbj8wnvGhpicK2sxxyu0cBi5Wcr9QFs2uaRmx5Gtn
         /Xu+1Le5EZmEZIrb80P3rhiAB+73kHsnCsfrO5wJQmfpe/WxaLxFz4gm94RwlGCjQkfL
         yhPCi2wQtSHA0uQ3UXcJyHASuZv8P4mnAb5DNXSKLaNRCohQFf4uCWKrul1znbjNqjQF
         lTjEK5b1HzS52S2OuNQJOUGgw87xRKyuZ7R7IxwixKcUg42UQgG/F1ZpXwARnPKkrqbj
         XU2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xVW9YVfjij9vCoDvPQUdIJ4SaHECQBvveZX1DwTyL70=;
        b=rDs19DCOBzx4hF9if/4eeZK+JpFQwsMz4Z1yql2XzCeQ4BXi+EQcH+29sLmp7Gnbrw
         mLYs1q2QFKLK7y9ncWkqQ2ZV0E1nVxdBFE1E5E8VAsIaJ/M0HIjEnwxiJuEmldJ6zvWU
         JcqKiKg9f16VU280Po6KvYFJki2kd6lN5CLGNVZ4sfoz4G4SNDmSzVlEOfjLL2PBwjet
         Kiaf+n+h7XbWxPT79dYMCdTwjwxJ754J76HQo4sRsQwX+64Av+/KA+7nyeHLHXZSbZvG
         ZDPG+eq8rE8cFk8qkzx5jGqvG7gklN1RrKlkETPp1HVwZRmqMjmZrhubnopbzecgo7lJ
         z0uw==
X-Gm-Message-State: APjAAAWdljhzGq+anlFouBncPfE4mSlmzPwjewpjAO6K508CzoAKtrk8
        Jguia7LtmyRgTI/ltjrzpK5qCappVPCBuA==
X-Google-Smtp-Source: APXvYqxY7FvHpXzJq5ystEi0wfi4ZtwP/LXHDf5gXkYHV+IYHsw8WJxXWk2V+v3Auzj4gvXkzeFLjg==
X-Received: by 2002:a5d:4043:: with SMTP id w3mr28849130wrp.318.1570549226179;
        Tue, 08 Oct 2019 08:40:26 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id x16sm16784723wrl.32.2019.10.08.08.40.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 08:40:25 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-arm-kernel@lists.infradead.org
Cc:     stable@vger.kernel.org, Jeremy Linton <jeremy.linton@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Will Deacon <will.deacon@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH for-stable-v4.19 13/16] arm64: add sysfs vulnerability show for spectre-v2
Date:   Tue,  8 Oct 2019 17:39:27 +0200
Message-Id: <20191008153930.15386-14-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191008153930.15386-1-ard.biesheuvel@linaro.org>
References: <20191008153930.15386-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeremy Linton <jeremy.linton@arm.com>

[ Upstream commit d2532e27b5638bb2e2dd52b80b7ea2ec65135377 ]

Track whether all the cores in the machine are vulnerable to Spectre-v2,
and whether all the vulnerable cores have been mitigated. We then expose
this information to userspace via sysfs.

Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Tested-by: Stefan Wahren <stefan.wahren@i2se.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/kernel/cpu_errata.c | 27 +++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 96b0319dd0d6..b29d0b3b18b2 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -480,6 +480,10 @@ has_cortex_a76_erratum_1463225(const struct arm64_cpu_capabilities *entry,
 	.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,			\
 	CAP_MIDR_RANGE_LIST(midr_list)
 
+/* Track overall mitigation state. We are only mitigated if all cores are ok */
+static bool __hardenbp_enab = true;
+static bool __spectrev2_safe = true;
+
 /*
  * Generic helper for handling capabilties with multiple (match,enable) pairs
  * of call backs, sharing the same capability bit.
@@ -522,6 +526,10 @@ static const struct midr_range spectre_v2_safe_list[] = {
 	{ /* sentinel */ }
 };
 
+/*
+ * Track overall bp hardening for all heterogeneous cores in the machine.
+ * We are only considered "safe" if all booted cores are known safe.
+ */
 static bool __maybe_unused
 check_branch_predictor(const struct arm64_cpu_capabilities *entry, int scope)
 {
@@ -543,6 +551,8 @@ check_branch_predictor(const struct arm64_cpu_capabilities *entry, int scope)
 	if (!need_wa)
 		return false;
 
+	__spectrev2_safe = false;
+
 	if (!IS_ENABLED(CONFIG_HARDEN_BRANCH_PREDICTOR)) {
 		pr_warn_once("spectrev2 mitigation disabled by kernel configuration\n");
 		__hardenbp_enab = false;
@@ -552,11 +562,14 @@ check_branch_predictor(const struct arm64_cpu_capabilities *entry, int scope)
 	/* forced off */
 	if (__nospectre_v2) {
 		pr_info_once("spectrev2 mitigation disabled by command line option\n");
+		__hardenbp_enab = false;
 		return false;
 	}
 
-	if (need_wa < 0)
+	if (need_wa < 0) {
 		pr_warn_once("ARM_SMCCC_ARCH_WORKAROUND_1 missing from firmware\n");
+		__hardenbp_enab = false;
+	}
 
 	return (need_wa > 0);
 }
@@ -753,3 +766,15 @@ ssize_t cpu_show_spectre_v1(struct device *dev, struct device_attribute *attr,
 {
 	return sprintf(buf, "Mitigation: __user pointer sanitization\n");
 }
+
+ssize_t cpu_show_spectre_v2(struct device *dev, struct device_attribute *attr,
+		char *buf)
+{
+	if (__spectrev2_safe)
+		return sprintf(buf, "Not affected\n");
+
+	if (__hardenbp_enab)
+		return sprintf(buf, "Mitigation: Branch predictor hardening\n");
+
+	return sprintf(buf, "Vulnerable\n");
+}
-- 
2.20.1

