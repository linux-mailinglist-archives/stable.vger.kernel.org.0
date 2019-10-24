Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC017E32DF
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 14:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729266AbfJXMtY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 08:49:24 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44643 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729573AbfJXMtY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 08:49:24 -0400
Received: by mail-wr1-f67.google.com with SMTP id z11so2563839wro.11
        for <stable@vger.kernel.org>; Thu, 24 Oct 2019 05:49:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=O2zNYFbnMvpY3xoUztn0Z4MsjJ2EFCrConIw3IljyBI=;
        b=bvY5v49SC6C96ulnUzZ4+aOqXtQZYWWNH+TXkwk7UmjppgRpUD4Y6Q5lTlIHuxXX11
         O2PWqx6BjE+BWft0xyU1li4XmMaX1z2iXA8dxNw7ea8ojDIAYVAtg9jzevtG5oGB3bBb
         ThMAAtEO22MIhHUZwl073HubQlDdVQ7mckNJ4fvN5OVvFnWkHryuJ4RNR5EcCAqEFoyr
         MQJGuFVicHs/jpjzuM7JNTEfg7fDh0rfq+wBYLJdmRzRGb7RhrHgzhDAvOs+XmlaVJ5U
         TdyRuxqsRYSwbqsYIVBJKHUhrDo2fxWz26WK//1KUR8SzDGw4Yn4YzKG2y8eb2LBJzsE
         mYkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O2zNYFbnMvpY3xoUztn0Z4MsjJ2EFCrConIw3IljyBI=;
        b=e67Yh0NyhIOsZDHXDhH/NkVJ5yAUK6QhMQ7vSr4MPw1o+RgOzwSZEs0pB/SU/k/THN
         CxohvEe9LbG0h09YRQYZIvD0CIAay26Dl/nEkNh3Xq3n1QMvVRoGHkKRq1BqhvrbSf3c
         r3J4YoRIiijCtwb2qAS3LFdPGxf8J7AnrevyMvNnZpLkFHsGGAq1YcNLua4yRxb+9u5l
         XsAkj7Dt+0B+tjRFC8dvQXJMDajkIQVaL0QcrMH4IxXCbHQgtUfKr+WFcfYCsF0UqZ5P
         ifAxH82eD2y3km796O3y2FsCAAhFzj+1tUxuaM6G/Ps3Es44uBt1Eelbcb9yOWLAW+J8
         tmXQ==
X-Gm-Message-State: APjAAAUn/lmneY05Hs0l+kSDC5WG5H+Fg6E/UB8P9DTa1KSOMeAyJlK4
        oLiDZMN8EyWqp2A8SbX0JU5myHqJUyDLRoIm
X-Google-Smtp-Source: APXvYqzqjMAUp13OiDskaECL9M6UDTJssrijNZQOO6r0RBd4wXx40yxon7PX0b9M2IDCLdy7VeniNQ==
X-Received: by 2002:adf:e982:: with SMTP id h2mr3526044wrm.53.1571921360155;
        Thu, 24 Oct 2019 05:49:20 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-126-126.w90-88.abo.wanadoo.fr. [90.88.7.126])
        by smtp.gmail.com with ESMTPSA id j22sm29111038wrd.41.2019.10.24.05.49.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 05:49:19 -0700 (PDT)
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
Subject: [PATCH for-stable-4.14 20/48] arm64: capabilities: Group handling of features and errata workarounds
Date:   Thu, 24 Oct 2019 14:48:05 +0200
Message-Id: <20191024124833.4158-21-ard.biesheuvel@linaro.org>
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

[ Upstream commit ed478b3f9e4ac97fdbe07007fb2662415de8fe25 ]

Now that the features and errata workarounds have the same
rules and flow, group the handling of the tables.

Reviewed-by: Dave Martin <dave.martin@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/kernel/cpufeature.c | 73 +++++++++++---------
 1 file changed, 42 insertions(+), 31 deletions(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index dda06f3436c2..f4d640dc7f8b 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -485,9 +485,7 @@ static void __init init_cpu_ftr_reg(u32 sys_reg, u64 new)
 }
 
 extern const struct arm64_cpu_capabilities arm64_errata[];
-static const struct arm64_cpu_capabilities arm64_features[];
-static void update_cpu_capabilities(const struct arm64_cpu_capabilities *caps,
-				    u16 scope_mask, const char *info);
+static void update_cpu_capabilities(u16 scope_mask);
 
 void __init init_cpu_features(struct cpuinfo_arm64 *info)
 {
@@ -530,9 +528,7 @@ void __init init_cpu_features(struct cpuinfo_arm64 *info)
 	 * Run the errata work around and local feature checks on the
 	 * boot CPU, once we have initialised the cpu feature infrastructure.
 	 */
-	update_cpu_capabilities(arm64_errata, SCOPE_LOCAL_CPU,
-				"enabling workaround for");
-	update_cpu_capabilities(arm64_features, SCOPE_LOCAL_CPU, "detected:");
+	update_cpu_capabilities(SCOPE_LOCAL_CPU);
 }
 
 static void update_cpu_ftr_reg(struct arm64_ftr_reg *reg, u64 new)
@@ -1167,8 +1163,8 @@ static bool __this_cpu_has_cap(const struct arm64_cpu_capabilities *cap_array,
 	return false;
 }
 
-static void update_cpu_capabilities(const struct arm64_cpu_capabilities *caps,
-				    u16 scope_mask, const char *info)
+static void __update_cpu_capabilities(const struct arm64_cpu_capabilities *caps,
+				      u16 scope_mask, const char *info)
 {
 	scope_mask &= ARM64_CPUCAP_SCOPE_MASK;
 	for (; caps->matches; caps++) {
@@ -1182,6 +1178,13 @@ static void update_cpu_capabilities(const struct arm64_cpu_capabilities *caps,
 	}
 }
 
+static void update_cpu_capabilities(u16 scope_mask)
+{
+	__update_cpu_capabilities(arm64_features, scope_mask, "detected:");
+	__update_cpu_capabilities(arm64_errata, scope_mask,
+				  "enabling workaround for");
+}
+
 static int __enable_cpu_capability(void *arg)
 {
 	const struct arm64_cpu_capabilities *cap = arg;
@@ -1195,8 +1198,8 @@ static int __enable_cpu_capability(void *arg)
  * CPUs
  */
 static void __init
-enable_cpu_capabilities(const struct arm64_cpu_capabilities *caps,
-			u16 scope_mask)
+__enable_cpu_capabilities(const struct arm64_cpu_capabilities *caps,
+			  u16 scope_mask)
 {
 	scope_mask &= ARM64_CPUCAP_SCOPE_MASK;
 	for (; caps->matches; caps++) {
@@ -1221,6 +1224,12 @@ enable_cpu_capabilities(const struct arm64_cpu_capabilities *caps,
 	}
 }
 
+static void __init enable_cpu_capabilities(u16 scope_mask)
+{
+	__enable_cpu_capabilities(arm64_features, scope_mask);
+	__enable_cpu_capabilities(arm64_errata, scope_mask);
+}
+
 /*
  * Flag to indicate if we have computed the system wide
  * capabilities based on the boot time active CPUs. This
@@ -1294,6 +1303,12 @@ __verify_local_cpu_caps(const struct arm64_cpu_capabilities *caps_list,
 	return true;
 }
 
+static bool verify_local_cpu_caps(u16 scope_mask)
+{
+	return __verify_local_cpu_caps(arm64_errata, scope_mask) &&
+	       __verify_local_cpu_caps(arm64_features, scope_mask);
+}
+
 /*
  * Check for CPU features that are used in early boot
  * based on the Boot CPU value.
@@ -1327,15 +1342,9 @@ verify_local_elf_hwcaps(const struct arm64_cpu_capabilities *caps)
  */
 static void verify_local_cpu_capabilities(void)
 {
-	/*
-	 * The CPU Errata work arounds are detected and applied at boot time
-	 * and the related information is freed soon after. If the new CPU
-	 * requires an errata not detected at boot, fail this CPU.
-	 */
-	if (!__verify_local_cpu_caps(arm64_errata, SCOPE_ALL))
-		cpu_die_early();
-	if (!__verify_local_cpu_caps(arm64_features, SCOPE_ALL))
+	if (!verify_local_cpu_caps(SCOPE_ALL))
 		cpu_die_early();
+
 	verify_local_elf_hwcaps(arm64_elf_hwcaps);
 	if (system_supports_32bit_el0())
 		verify_local_elf_hwcaps(compat_elf_hwcaps);
@@ -1355,14 +1364,10 @@ void check_local_cpu_capabilities(void)
 	 * Otherwise, this CPU should verify that it has all the system
 	 * advertised capabilities.
 	 */
-	if (!sys_caps_initialised) {
-		update_cpu_capabilities(arm64_errata, SCOPE_LOCAL_CPU,
-					"enabling workaround for");
-		update_cpu_capabilities(arm64_features, SCOPE_LOCAL_CPU,
-					"detected:");
-	} else {
+	if (!sys_caps_initialised)
+		update_cpu_capabilities(SCOPE_LOCAL_CPU);
+	else
 		verify_local_cpu_capabilities();
-	}
 }
 
 DEFINE_STATIC_KEY_FALSE(arm64_const_caps_ready);
@@ -1381,17 +1386,23 @@ bool this_cpu_has_cap(unsigned int cap)
 		__this_cpu_has_cap(arm64_errata, cap));
 }
 
+static void __init setup_system_capabilities(void)
+{
+	/*
+	 * We have finalised the system-wide safe feature
+	 * registers, finalise the capabilities that depend
+	 * on it. Also enable all the available capabilities.
+	 */
+	update_cpu_capabilities(SCOPE_SYSTEM);
+	enable_cpu_capabilities(SCOPE_ALL);
+}
+
 void __init setup_cpu_features(void)
 {
 	u32 cwg;
 	int cls;
 
-	/* Set the CPU feature capabilies */
-	update_cpu_capabilities(arm64_features, SCOPE_SYSTEM, "detected:");
-	update_cpu_capabilities(arm64_errata, SCOPE_SYSTEM,
-				"enabling workaround for");
-	enable_cpu_capabilities(arm64_features, SCOPE_ALL);
-	enable_cpu_capabilities(arm64_errata, SCOPE_ALL);
+	setup_system_capabilities();
 	mark_const_caps_ready();
 	setup_elf_hwcaps(arm64_elf_hwcaps);
 
-- 
2.20.1

