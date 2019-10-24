Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55A4DE32DB
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 14:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729507AbfJXMtQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 08:49:16 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44621 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729266AbfJXMtQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 08:49:16 -0400
Received: by mail-wr1-f65.google.com with SMTP id z11so2563383wro.11
        for <stable@vger.kernel.org>; Thu, 24 Oct 2019 05:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pKC8njkJSJQYH3ulUymEqE4RKZit0KDY0/L2rZ93cqQ=;
        b=Mck9JJmO9PIyAUkYXWvG1SZk7K/VvmWi8qqrdG9N+u4hgUQV1TvvNoz6felzsVzCH+
         GXlSUWQekS/vMnM3i3S3zzkvIOtxf9hH/LXzCUSFZmogLOYE5gLmyuBgTPVHDBd6BToK
         Bvy0Lp2KYi+Xgn+X8I1th+wHem/uM4OQZ/+PdgtA8FsAUXoYiI9+rM3Txn1NjbGnpDoI
         1W3sd1m6i91S/Te7AKuof/uYEWa+WFJYrgMmTbLwOw45uiUN2/RcZwCIhR/caA+eAFNz
         h2W0yAWXESR5M+CK2DNCaUkoN0iXajSzgqHcFng/Rf4ovT/tH03sz1iuhAjepQCxOa9S
         qgYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pKC8njkJSJQYH3ulUymEqE4RKZit0KDY0/L2rZ93cqQ=;
        b=CwLi6+qyEFUeAxBz+iPPw/GtVE9cKGaoKiV0+Rtkarob29fG15bRTeBqbn5HFtMGSr
         vLCQXXhjQq9vZ01lwcEdK5xDjibDY0P+JmLfWknPFxemR4ggOtmby+Kqj09cF/OawTGW
         aGpbH5jWAe8TmS2U9ctxPxFsJTYaMf0kOeQhds2yBTx2A2DOXCKCUUEeu74SPQwdVt+u
         46aRP/yQh14cRJOZ5rX0zLvJaJ/WZPpzC1Zvbhzjvo06Zmi/QHY2IGBIiq8k3OAye0Ns
         5wWUxPMDiwiM8g34WVi7TQWedSfBLsIMTXTk9QBHZY2uODmKmYwh+TOvhM4clfgRFrz7
         yvig==
X-Gm-Message-State: APjAAAXZ3WDc+B6KtWqFNTmqGbIJHmq8UQXpoQ6S4CiCcme7a3xy7YJr
        jdsv6/Ok7hXtIbSfsLsP8BgF196V+nKQB+v7
X-Google-Smtp-Source: APXvYqxYHog+kVDQUsx3zfi3QmJzOMzelDwUd0ZW2DdRzPcu5nl2p0ptsjpw6CHFU4OIMTRJbWTw9A==
X-Received: by 2002:adf:f90d:: with SMTP id b13mr3615022wrr.316.1571921352696;
        Thu, 24 Oct 2019 05:49:12 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-126-126.w90-88.abo.wanadoo.fr. [90.88.7.126])
        by smtp.gmail.com with ESMTPSA id j22sm29111038wrd.41.2019.10.24.05.49.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 05:49:11 -0700 (PDT)
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
        Will Deacon <will.deacon@arm.com>,
        Dave Martin <dave.martin@arm.com>
Subject: [PATCH for-stable-4.14 16/48] arm64: capabilities: Filter the entries based on a given mask
Date:   Thu, 24 Oct 2019 14:48:01 +0200
Message-Id: <20191024124833.4158-17-ard.biesheuvel@linaro.org>
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

[ Upstream commit cce360b54ce6ca1bcf4b0a870ec076d83606775e ]

While processing the list of capabilities, it is useful to
filter out some of the entries based on the given mask for the
scope of the capabilities to allow better control. This can be
used later for handling LOCAL vs SYSTEM wide capabilities and more.
All capabilities should have their scope set to either LOCAL_CPU or
SYSTEM. No functional/flow change.

Cc: Will Deacon <will.deacon@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Dave Martin <dave.martin@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/include/asm/cpufeature.h |  1 +
 arch/arm64/kernel/cpufeature.c      | 33 +++++++++++++-------
 2 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 89aeeeaf81bb..b19dd89bcce9 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -207,6 +207,7 @@ extern struct arm64_ftr_reg arm64_ftr_reg_ctrel0;
 
 #define SCOPE_SYSTEM				ARM64_CPUCAP_SCOPE_SYSTEM
 #define SCOPE_LOCAL_CPU				ARM64_CPUCAP_SCOPE_LOCAL_CPU
+#define SCOPE_ALL				ARM64_CPUCAP_SCOPE_MASK
 
 /*
  * Is it permitted for a late CPU to have this capability when system
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index e73fae0c0ca7..b88871d5f179 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1164,10 +1164,12 @@ static bool __this_cpu_has_cap(const struct arm64_cpu_capabilities *cap_array,
 }
 
 static void update_cpu_capabilities(const struct arm64_cpu_capabilities *caps,
-				    const char *info)
+				    u16 scope_mask, const char *info)
 {
+	scope_mask &= ARM64_CPUCAP_SCOPE_MASK;
 	for (; caps->matches; caps++) {
-		if (!caps->matches(caps, cpucap_default_scope(caps)))
+		if (!(caps->type & scope_mask) ||
+		    !caps->matches(caps, cpucap_default_scope(caps)))
 			continue;
 
 		if (!cpus_have_cap(caps->capability) && caps->desc)
@@ -1189,12 +1191,14 @@ static int __enable_cpu_capability(void *arg)
  * CPUs
  */
 static void __init
-enable_cpu_capabilities(const struct arm64_cpu_capabilities *caps)
+enable_cpu_capabilities(const struct arm64_cpu_capabilities *caps,
+			u16 scope_mask)
 {
+	scope_mask &= ARM64_CPUCAP_SCOPE_MASK;
 	for (; caps->matches; caps++) {
 		unsigned int num = caps->capability;
 
-		if (!cpus_have_cap(num))
+		if (!(caps->type & scope_mask) || !cpus_have_cap(num))
 			continue;
 
 		/* Ensure cpus_have_const_cap(num) works */
@@ -1236,12 +1240,18 @@ static inline void set_sys_caps_initialised(void)
  * Returns "false" on conflicts.
  */
 static bool
-__verify_local_cpu_caps(const struct arm64_cpu_capabilities *caps_list)
+__verify_local_cpu_caps(const struct arm64_cpu_capabilities *caps_list,
+			u16 scope_mask)
 {
 	bool cpu_has_cap, system_has_cap;
 	const struct arm64_cpu_capabilities *caps;
 
+	scope_mask &= ARM64_CPUCAP_SCOPE_MASK;
+
 	for (caps = caps_list; caps->matches; caps++) {
+		if (!(caps->type & scope_mask))
+			continue;
+
 		cpu_has_cap = __this_cpu_has_cap(caps_list, caps->capability);
 		system_has_cap = cpus_have_cap(caps->capability);
 
@@ -1304,7 +1314,7 @@ verify_local_elf_hwcaps(const struct arm64_cpu_capabilities *caps)
 
 static void verify_local_cpu_features(void)
 {
-	if (!__verify_local_cpu_caps(arm64_features))
+	if (!__verify_local_cpu_caps(arm64_features, SCOPE_ALL))
 		cpu_die_early();
 }
 
@@ -1315,18 +1325,19 @@ static void verify_local_cpu_features(void)
  */
 static void verify_local_cpu_errata_workarounds(void)
 {
-	if (!__verify_local_cpu_caps(arm64_errata))
+	if (!__verify_local_cpu_caps(arm64_errata, SCOPE_ALL))
 		cpu_die_early();
 }
 
 static void update_cpu_errata_workarounds(void)
 {
-	update_cpu_capabilities(arm64_errata, "enabling workaround for");
+	update_cpu_capabilities(arm64_errata, SCOPE_ALL,
+				"enabling workaround for");
 }
 
 static void __init enable_errata_workarounds(void)
 {
-	enable_cpu_capabilities(arm64_errata);
+	enable_cpu_capabilities(arm64_errata, SCOPE_ALL);
 }
 
 /*
@@ -1368,8 +1379,8 @@ void check_local_cpu_capabilities(void)
 
 static void __init setup_feature_capabilities(void)
 {
-	update_cpu_capabilities(arm64_features, "detected feature:");
-	enable_cpu_capabilities(arm64_features);
+	update_cpu_capabilities(arm64_features, SCOPE_ALL, "detected:");
+	enable_cpu_capabilities(arm64_features, SCOPE_ALL);
 }
 
 DEFINE_STATIC_KEY_FALSE(arm64_const_caps_ready);
-- 
2.20.1

