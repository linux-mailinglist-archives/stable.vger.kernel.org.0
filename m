Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8759E6908
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:34:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729799AbfJ0VK4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:10:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:57412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729792AbfJ0VKz (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:10:55 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70739214E0;
        Sun, 27 Oct 2019 21:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210654;
        bh=Eplurz0Sr4O86edDYblfv3yLCH43g66Otz7gO3cbtnQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pqCmFwhVjW+X5/qjuqdyUbopVSqbMblYSF3dyy5UUEFGqfwOQbkO6m8cwChI9pajy
         W6V9D2nHg70v9/IOwxZIT9irQE0qxYCkJ0JYrMBgBScIGcQp3DvDSTSfShzzWZKkX5
         WYqfxinlSi0vCW/BkGbaCH8Zw8/ZcQboFOT9G21o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Martin <dave.martin@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 4.14 053/119] arm64: capabilities: Prepare for grouping features and errata work arounds
Date:   Sun, 27 Oct 2019 22:00:30 +0100
Message-Id: <20191027203323.136720420@linuxfoundation.org>
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

[ Upstream commit 600b9c919c2f4d07a7bf67864086aa3432224674 ]

We are about to group the handling of all capabilities (features
and errata workarounds). This patch open codes the wrapper routines
to make it easier to merge the handling.

Reviewed-by: Dave Martin <dave.martin@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/cpufeature.c |   58 ++++++++++++-----------------------------
 1 file changed, 18 insertions(+), 40 deletions(-)

--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -485,7 +485,8 @@ static void __init init_cpu_ftr_reg(u32
 }
 
 extern const struct arm64_cpu_capabilities arm64_errata[];
-static void update_cpu_errata_workarounds(void);
+static void update_cpu_capabilities(const struct arm64_cpu_capabilities *caps,
+				    u16 scope_mask, const char *info);
 
 void __init init_cpu_features(struct cpuinfo_arm64 *info)
 {
@@ -528,7 +529,8 @@ void __init init_cpu_features(struct cpu
 	 * Run the errata work around checks on the boot CPU, once we have
 	 * initialised the cpu feature infrastructure.
 	 */
-	update_cpu_errata_workarounds();
+	update_cpu_capabilities(arm64_errata, SCOPE_ALL,
+				"enabling workaround for");
 }
 
 static void update_cpu_ftr_reg(struct arm64_ftr_reg *reg, u64 new)
@@ -1312,33 +1314,6 @@ verify_local_elf_hwcaps(const struct arm
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
@@ -1350,8 +1325,15 @@ static void __init enable_errata_workaro
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
 


