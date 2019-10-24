Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC049E32FA
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 14:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502143AbfJXMt6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 08:49:58 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39921 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502116AbfJXMt6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 08:49:58 -0400
Received: by mail-wm1-f67.google.com with SMTP id r141so2476574wme.4
        for <stable@vger.kernel.org>; Thu, 24 Oct 2019 05:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=g2Zsqrc//i/JLADDP/HYxz1nyRfqYR6RzPTnN2UOUgM=;
        b=cRVImgZPI4cDr+SdYtc+5e0bRLvE06CRbZFetILdxYGAmvffnzY3sI3Um/WXbSRZri
         c+SMpxJXYVS4YBCq5sDI2DfIbYYSmEVe93RGOwYiv3kgCJLa6P8nntd5Mhgf5qUSn+pQ
         T3FtfVinO5sqLGt3QxSCbz94Lj+CTWNtI0cAlsdkh7KwNR6AnLoe1EvlTJOt1fkfvmUj
         VvIyTlEijSuUp+q7CcTwB5EMG0Z7J1lfc6PTHyqwJDYOCaonSrAT6p+QpBBmjJvA7s6S
         uE/Pfzb4Wia7Xdb+PaI1NCT72t0PLo+Rf3yp47pCimjqjUtqIs//PInE/BUxcEWMTdez
         61Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g2Zsqrc//i/JLADDP/HYxz1nyRfqYR6RzPTnN2UOUgM=;
        b=lCVy1kTcCMxeZjXdgA3+r/vect8y0VyYjefavO6/gnN2ybENHRFWGtL/9OLXOu2/u7
         3usQlhKJRPShPs6GYAMc0HmLbxlM40rJHLZUsVvr4bTE5xrg5hl4SAszFn6a4nnk411r
         Kg3R+cyUOsykbHiwauZ/MPAZWl0KG7sPjiYpp3F7/fyrXULbFrwv4LThu/9bNyNZ7cQZ
         ngSXcI3BvR1T1xejz8skVhjsqxiN1rp4PkDaGROIoBEW5EaFxOFYlJ28cfVU8E1kigGj
         0SAno43bSeKmwm+/bwgNkk1O51ie/cOzJMTl8R9jLO1NJ1SKnLbTLahbLsERMZaTj4mR
         WDBg==
X-Gm-Message-State: APjAAAWSilItT5xPb1azM7chIfybvjOzQTDHSaTNb0NGYan3tsB1hlTF
        bywJStHFE9y/hSKo+9CEmgU67zO016/3ELxo
X-Google-Smtp-Source: APXvYqx17zsMAAZtDPW/FE4NeQYlFAmxXqR3SjlNG/ANA4Ef39n3F0f7d1Nnv1YYzOJNcNq3pnnbVA==
X-Received: by 2002:a1c:f401:: with SMTP id z1mr4681069wma.66.1571921395897;
        Thu, 24 Oct 2019 05:49:55 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-126-126.w90-88.abo.wanadoo.fr. [90.88.7.126])
        by smtp.gmail.com with ESMTPSA id j22sm29111038wrd.41.2019.10.24.05.49.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 05:49:55 -0700 (PDT)
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
        Stefan Wahren <stefan.wahren@i2se.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH for-stable-4.14 43/48] arm64: add sysfs vulnerability show for spectre-v2
Date:   Thu, 24 Oct 2019 14:48:28 +0200
Message-Id: <20191024124833.4158-44-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191024124833.4158-1-ard.biesheuvel@linaro.org>
References: <20191024124833.4158-1-ard.biesheuvel@linaro.org>
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
index 647c533cfd90..809a736f38a9 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -456,6 +456,10 @@ static bool has_ssbd_mitigation(const struct arm64_cpu_capabilities *entry,
 	.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,			\
 	CAP_MIDR_RANGE_LIST(midr_list)
 
+/* Track overall mitigation state. We are only mitigated if all cores are ok */
+static bool __hardenbp_enab = true;
+static bool __spectrev2_safe = true;
+
 /*
  * List of CPUs that do not need any Spectre-v2 mitigation at all.
  */
@@ -466,6 +470,10 @@ static const struct midr_range spectre_v2_safe_list[] = {
 	{ /* sentinel */ }
 };
 
+/*
+ * Track overall bp hardening for all heterogeneous cores in the machine.
+ * We are only considered "safe" if all booted cores are known safe.
+ */
 static bool __maybe_unused
 check_branch_predictor(const struct arm64_cpu_capabilities *entry, int scope)
 {
@@ -487,6 +495,8 @@ check_branch_predictor(const struct arm64_cpu_capabilities *entry, int scope)
 	if (!need_wa)
 		return false;
 
+	__spectrev2_safe = false;
+
 	if (!IS_ENABLED(CONFIG_HARDEN_BRANCH_PREDICTOR)) {
 		pr_warn_once("spectrev2 mitigation disabled by kernel configuration\n");
 		__hardenbp_enab = false;
@@ -496,11 +506,14 @@ check_branch_predictor(const struct arm64_cpu_capabilities *entry, int scope)
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
@@ -663,3 +676,15 @@ ssize_t cpu_show_spectre_v1(struct device *dev, struct device_attribute *attr,
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

