Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D216E6663
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:11:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbfJ0VLY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:11:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:57910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729885AbfJ0VLX (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:11:23 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 348292064A;
        Sun, 27 Oct 2019 21:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210682;
        bh=UTcCIdR8dOyw3mZVzhZCZjFxq1nwhPvMlyrOLwdBEIE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DkwLbmJHMy0Mpfvpo2GTxx09EsWOWWu0aJp8xy3tzWYxzdmIrLNK+5fD6bsbkTfE9
         LANRCzi+y2BxbXFt/bQ0+VF2tQEwRfI5dst1+1OTqPUQbjAHp2KvQzya53SLjM4mHI
         VH+XSjlWGqkseJ5Y5ukCBUyPy6JpBler8oHEcUSg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Martin <dave.martin@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 4.14 056/119] arm64: capabilities: Group handling of features and errata workarounds
Date:   Sun, 27 Oct 2019 22:00:33 +0100
Message-Id: <20191027203324.480386814@linuxfoundation.org>
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

[ Upstream commit ed478b3f9e4ac97fdbe07007fb2662415de8fe25 ]

Now that the features and errata workarounds have the same
rules and flow, group the handling of the tables.

Reviewed-by: Dave Martin <dave.martin@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/cpufeature.c |   73 +++++++++++++++++++++++------------------
 1 file changed, 42 insertions(+), 31 deletions(-)

--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -485,9 +485,7 @@ static void __init init_cpu_ftr_reg(u32
 }
 
 extern const struct arm64_cpu_capabilities arm64_errata[];
-static const struct arm64_cpu_capabilities arm64_features[];
-static void update_cpu_capabilities(const struct arm64_cpu_capabilities *caps,
-				    u16 scope_mask, const char *info);
+static void update_cpu_capabilities(u16 scope_mask);
 
 void __init init_cpu_features(struct cpuinfo_arm64 *info)
 {
@@ -530,9 +528,7 @@ void __init init_cpu_features(struct cpu
 	 * Run the errata work around and local feature checks on the
 	 * boot CPU, once we have initialised the cpu feature infrastructure.
 	 */
-	update_cpu_capabilities(arm64_errata, SCOPE_LOCAL_CPU,
-				"enabling workaround for");
-	update_cpu_capabilities(arm64_features, SCOPE_LOCAL_CPU, "detected:");
+	update_cpu_capabilities(SCOPE_LOCAL_CPU);
 }
 
 static void update_cpu_ftr_reg(struct arm64_ftr_reg *reg, u64 new)
@@ -1167,8 +1163,8 @@ static bool __this_cpu_has_cap(const str
 	return false;
 }
 
-static void update_cpu_capabilities(const struct arm64_cpu_capabilities *caps,
-				    u16 scope_mask, const char *info)
+static void __update_cpu_capabilities(const struct arm64_cpu_capabilities *caps,
+				      u16 scope_mask, const char *info)
 {
 	scope_mask &= ARM64_CPUCAP_SCOPE_MASK;
 	for (; caps->matches; caps++) {
@@ -1182,6 +1178,13 @@ static void update_cpu_capabilities(cons
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
@@ -1195,8 +1198,8 @@ static int __enable_cpu_capability(void
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
@@ -1221,6 +1224,12 @@ enable_cpu_capabilities(const struct arm
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
@@ -1294,6 +1303,12 @@ __verify_local_cpu_caps(const struct arm
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
@@ -1327,15 +1342,9 @@ verify_local_elf_hwcaps(const struct arm
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
 


