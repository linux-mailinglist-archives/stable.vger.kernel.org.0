Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05531E6624
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:09:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727967AbfJ0VJB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:09:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:55330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729455AbfJ0VJB (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:09:01 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 841282064A;
        Sun, 27 Oct 2019 21:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210540;
        bh=JwJbmvmue4rSUIF6gaZB1bl6wcv45ZlgHlBozyiTPtA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1/YPhprMV9xrGYedamsbLpCSqfMG9RDk07lOAKbK6SnlZGwbv5j0I0uSSax9m7vYq
         HeB36d8hGBfHqFBKUrpn9x2k8FmttrRS2AS73Vy6tGta5BQoQv4fMMwfteN+wSsNDU
         LTusBUk7p6wfUdYHqXzbP5wl/6LQ/AXtTSy4+lOA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Will Deacon <will.deacon@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Dave Martin <dave.martin@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 4.14 048/119] arm64: capabilities: Move errata processing code
Date:   Sun, 27 Oct 2019 22:00:25 +0100
Message-Id: <20191027203319.576429658@linuxfoundation.org>
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
---
 arch/arm64/include/asm/cpufeature.h |    7 -----
 arch/arm64/kernel/cpu_errata.c      |   33 ---------------------------
 arch/arm64/kernel/cpufeature.c      |   43 +++++++++++++++++++++++++++++++++---
 3 files changed, 40 insertions(+), 43 deletions(-)

--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -230,15 +230,8 @@ static inline bool id_aa64pfr0_32bit_el0
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
 
 u64 read_sanitised_ftr_reg(u32 id);
 
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -621,36 +621,3 @@ const struct arm64_cpu_capabilities arm6
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
@@ -484,6 +484,9 @@ static void __init init_cpu_ftr_reg(u32
 	reg->user_mask = user_mask;
 }
 
+extern const struct arm64_cpu_capabilities arm64_errata[];
+static void update_cpu_errata_workarounds(void);
+
 void __init init_cpu_features(struct cpuinfo_arm64 *info)
 {
 	/* Before we start using the tables, make sure it is sorted */
@@ -1160,8 +1163,8 @@ static bool __this_cpu_has_cap(const str
 	return false;
 }
 
-void update_cpu_capabilities(const struct arm64_cpu_capabilities *caps,
-			    const char *info)
+static void update_cpu_capabilities(const struct arm64_cpu_capabilities *caps,
+				    const char *info)
 {
 	for (; caps->matches; caps++) {
 		if (!caps->matches(caps, caps->def_scope))
@@ -1185,7 +1188,8 @@ static int __enable_cpu_capability(void
  * Run through the enabled capabilities and enable() it on all active
  * CPUs
  */
-void __init enable_cpu_capabilities(const struct arm64_cpu_capabilities *caps)
+static void __init
+enable_cpu_capabilities(const struct arm64_cpu_capabilities *caps)
 {
 	for (; caps->matches; caps++) {
 		unsigned int num = caps->capability;
@@ -1268,6 +1272,39 @@ verify_local_cpu_features(const struct a
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


