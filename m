Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54204E6646
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729692AbfJ0VKX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:10:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:56776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729670AbfJ0VKW (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:10:22 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E3A22064A;
        Sun, 27 Oct 2019 21:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210621;
        bh=LwU4NPpiiTWWki5dyovJzzJTpL45yAe7Vi9hAtVmcg4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ByW0vT8X/RwWMRznRInPMDMGzYqPwYD5tt5R8Bt2Bx0x/5K/mauq/63W7X+8B3WjE
         sHZF6j7m4PNbiBJOaQMiuzSzF8HJhimiXpejHFnFPi2UyW9mwCGcyq0Ka9kG7x0wtZ
         onMk3pJ5vodXmsLZqd+/zxX2oOgmjTzW7tnP9W+M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Will Deacon <will.deacon@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Dave Martin <dave.martin@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 4.14 052/119] arm64: capabilities: Filter the entries based on a given mask
Date:   Sun, 27 Oct 2019 22:00:29 +0100
Message-Id: <20191027203322.468518194@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203259.948006506@linuxfoundation.org>
References: <20191027203259.948006506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/cpufeature.h |    1 +
 arch/arm64/kernel/cpufeature.c      |   33 ++++++++++++++++++++++-----------
 2 files changed, 23 insertions(+), 11 deletions(-)

--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -207,6 +207,7 @@ extern struct arm64_ftr_reg arm64_ftr_re
 
 #define SCOPE_SYSTEM				ARM64_CPUCAP_SCOPE_SYSTEM
 #define SCOPE_LOCAL_CPU				ARM64_CPUCAP_SCOPE_LOCAL_CPU
+#define SCOPE_ALL				ARM64_CPUCAP_SCOPE_MASK
 
 /*
  * Is it permitted for a late CPU to have this capability when system
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1164,10 +1164,12 @@ static bool __this_cpu_has_cap(const str
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
@@ -1189,12 +1191,14 @@ static int __enable_cpu_capability(void
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
@@ -1236,12 +1240,18 @@ static inline void set_sys_caps_initiali
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
 
@@ -1304,7 +1314,7 @@ verify_local_elf_hwcaps(const struct arm
 
 static void verify_local_cpu_features(void)
 {
-	if (!__verify_local_cpu_caps(arm64_features))
+	if (!__verify_local_cpu_caps(arm64_features, SCOPE_ALL))
 		cpu_die_early();
 }
 
@@ -1315,18 +1325,19 @@ static void verify_local_cpu_features(vo
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


