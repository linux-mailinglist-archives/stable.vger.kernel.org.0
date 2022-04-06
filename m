Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67EC54F6AC4
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 22:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233720AbiDFUEm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 16:04:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235839AbiDFUD4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 16:03:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CC1C27C587;
        Wed,  6 Apr 2022 11:28:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3927761B89;
        Wed,  6 Apr 2022 18:28:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4776AC385A3;
        Wed,  6 Apr 2022 18:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649269684;
        bh=D7zWcree4wrkW9PxMZGiVr2Pt1StTq4M2uLNQXZ56w8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d3p6VZdeYObSIbhadP3kuqwbWKYWMBn2Evvwf9CI3epOouLbLLOz9TeTkkCa5cMfJ
         VHLVR98aTamVVmJLenjMdqfb43J9kFIpj7ydswexnj7AzV/KpP6pSMwGTM/CyWJiIN
         bWOuloK2qj4v9tFCYk1ygkMBoCZEj44KS6czbi6s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Dave Martin <dave.martin@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        James Morse <james.morse@arm.com>
Subject: [PATCH 4.9 06/43] arm64: capabilities: Move errata processing code
Date:   Wed,  6 Apr 2022 20:26:15 +0200
Message-Id: <20220406182436.864812555@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220406182436.675069715@linuxfoundation.org>
References: <20220406182436.675069715@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suzuki K Poulose <suzuki.poulose@arm.com>

[ Upstream commit 1e89baed5d50d2b8d9fd420830902570270703f1 ]

We have errata work around processing code in cpu_errata.c,
which calls back into helpers defined in cpufeature.c. Now
that we are going to make the handling of capabilities
generic, by adding the information to each capability,
move the errata work around specific processing code.
No functional changes.

Cc: Will Deacon <will.deacon@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Dave Martin <dave.martin@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/cpufeature.h |    7 -----
 arch/arm64/kernel/cpu_errata.c      |   33 ---------------------------
 arch/arm64/kernel/cpufeature.c      |   43 +++++++++++++++++++++++++++++++++---
 3 files changed, 40 insertions(+), 43 deletions(-)

--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -200,15 +200,8 @@ static inline bool id_aa64pfr0_32bit_el0
 }
 
 void __init setup_cpu_features(void);
-
-void update_cpu_capabilities(const struct arm64_cpu_capabilities *caps,
-			    const char *info);
-void enable_cpu_capabilities(const struct arm64_cpu_capabilities *caps);
 void check_local_cpu_capabilities(void);
 
-void update_cpu_errata_workarounds(void);
-void __init enable_errata_workarounds(void);
-void verify_local_cpu_errata_workarounds(void);
 
 u64 read_system_reg(u32 id);
 
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -512,36 +512,3 @@ const struct arm64_cpu_capabilities arm6
 	{
 	}
 };
-
-/*
- * The CPU Errata work arounds are detected and applied at boot time
- * and the related information is freed soon after. If the new CPU requires
- * an errata not detected at boot, fail this CPU.
- */
-void verify_local_cpu_errata_workarounds(void)
-{
-	const struct arm64_cpu_capabilities *caps = arm64_errata;
-
-	for (; caps->matches; caps++) {
-		if (cpus_have_cap(caps->capability)) {
-			if (caps->cpu_enable)
-				caps->cpu_enable(caps);
-		} else if (caps->matches(caps, SCOPE_LOCAL_CPU)) {
-			pr_crit("CPU%d: Requires work around for %s, not detected"
-					" at boot time\n",
-				smp_processor_id(),
-				caps->desc ? : "an erratum");
-			cpu_die_early();
-		}
-	}
-}
-
-void update_cpu_errata_workarounds(void)
-{
-	update_cpu_capabilities(arm64_errata, "enabling workaround for");
-}
-
-void __init enable_errata_workarounds(void)
-{
-	enable_cpu_capabilities(arm64_errata);
-}
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -439,6 +439,9 @@ static void __init init_cpu_ftr_reg(u32
 	reg->strict_mask = strict_mask;
 }
 
+extern const struct arm64_cpu_capabilities arm64_errata[];
+static void update_cpu_errata_workarounds(void);
+
 void __init init_cpu_features(struct cpuinfo_arm64 *info)
 {
 	/* Before we start using the tables, make sure it is sorted */
@@ -1066,8 +1069,8 @@ static bool __this_cpu_has_cap(const str
 	return false;
 }
 
-void update_cpu_capabilities(const struct arm64_cpu_capabilities *caps,
-			    const char *info)
+static void update_cpu_capabilities(const struct arm64_cpu_capabilities *caps,
+				    const char *info)
 {
 	for (; caps->matches; caps++) {
 		if (!caps->matches(caps, caps->def_scope))
@@ -1091,7 +1094,8 @@ static int __enable_cpu_capability(void
  * Run through the enabled capabilities and enable() it on all active
  * CPUs
  */
-void __init enable_cpu_capabilities(const struct arm64_cpu_capabilities *caps)
+static void __init
+enable_cpu_capabilities(const struct arm64_cpu_capabilities *caps)
 {
 	for (; caps->matches; caps++) {
 		unsigned int num = caps->capability;
@@ -1174,6 +1178,39 @@ verify_local_cpu_features(const struct a
 }
 
 /*
+ * The CPU Errata work arounds are detected and applied at boot time
+ * and the related information is freed soon after. If the new CPU requires
+ * an errata not detected at boot, fail this CPU.
+ */
+static void verify_local_cpu_errata_workarounds(void)
+{
+	const struct arm64_cpu_capabilities *caps = arm64_errata;
+
+	for (; caps->matches; caps++) {
+		if (cpus_have_cap(caps->capability)) {
+			if (caps->cpu_enable)
+				caps->cpu_enable(caps);
+		} else if (caps->matches(caps, SCOPE_LOCAL_CPU)) {
+			pr_crit("CPU%d: Requires work around for %s, not detected"
+					" at boot time\n",
+				smp_processor_id(),
+				caps->desc ? : "an erratum");
+			cpu_die_early();
+		}
+	}
+}
+
+static void update_cpu_errata_workarounds(void)
+{
+	update_cpu_capabilities(arm64_errata, "enabling workaround for");
+}
+
+static void __init enable_errata_workarounds(void)
+{
+	enable_cpu_capabilities(arm64_errata);
+}
+
+/*
  * Run through the enabled system capabilities and enable() it on this CPU.
  * The capabilities were decided based on the available CPUs at the boot time.
  * Any new CPU should match the system wide status of the capability. If the


