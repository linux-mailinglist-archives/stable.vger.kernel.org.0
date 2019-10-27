Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4566E6639
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:09:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729568AbfJ0VJw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:09:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:56258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728832AbfJ0VJv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:09:51 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DD7520873;
        Sun, 27 Oct 2019 21:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210590;
        bh=t74p8N9ci9kwCGvfHTXx7zxJ4/yXagwEI90cMiviUfY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tIJvHdDMTP2HtXc1tmorRaLQ0EoTuszHEuXxL+VX2sDppia0JeoDLEZYp0WYAjYrg
         WDHks0pN57dQYt83EwkxNz1rc2qfCjdULbXO5KpaWz76gfJpJl8WcuCmDcU28sSIMr
         Z5DMyi2nXg39xCJjKfFoYQSnIZlzQtts+QPmtpUQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Martin <dave.martin@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 4.14 051/119] arm64: capabilities: Unify the verification
Date:   Sun, 27 Oct 2019 22:00:28 +0100
Message-Id: <20191027203321.576169722@linuxfoundation.org>
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

[ Upstream commit eaac4d83daa50fc1b9b7850346e9a62adfd4647e ]

Now that each capability describes how to treat the conflicts
of CPU cap state vs System wide cap state, we can unify the
verification logic to a single place.

Reviewed-by: Dave Martin <dave.martin@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/cpufeature.c |   91 ++++++++++++++++++++++++++---------------
 1 file changed, 58 insertions(+), 33 deletions(-)

--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1229,6 +1229,58 @@ static inline void set_sys_caps_initiali
 }
 
 /*
+ * Run through the list of capabilities to check for conflicts.
+ * If the system has already detected a capability, take necessary
+ * action on this CPU.
+ *
+ * Returns "false" on conflicts.
+ */
+static bool
+__verify_local_cpu_caps(const struct arm64_cpu_capabilities *caps_list)
+{
+	bool cpu_has_cap, system_has_cap;
+	const struct arm64_cpu_capabilities *caps;
+
+	for (caps = caps_list; caps->matches; caps++) {
+		cpu_has_cap = __this_cpu_has_cap(caps_list, caps->capability);
+		system_has_cap = cpus_have_cap(caps->capability);
+
+		if (system_has_cap) {
+			/*
+			 * Check if the new CPU misses an advertised feature,
+			 * which is not safe to miss.
+			 */
+			if (!cpu_has_cap && !cpucap_late_cpu_optional(caps))
+				break;
+			/*
+			 * We have to issue cpu_enable() irrespective of
+			 * whether the CPU has it or not, as it is enabeld
+			 * system wide. It is upto the call back to take
+			 * appropriate action on this CPU.
+			 */
+			if (caps->cpu_enable)
+				caps->cpu_enable(caps);
+		} else {
+			/*
+			 * Check if the CPU has this capability if it isn't
+			 * safe to have when the system doesn't.
+			 */
+			if (cpu_has_cap && !cpucap_late_cpu_permitted(caps))
+				break;
+		}
+	}
+
+	if (caps->matches) {
+		pr_crit("CPU%d: Detected conflict for capability %d (%s), System: %d, CPU: %d\n",
+			smp_processor_id(), caps->capability,
+			caps->desc, system_has_cap, cpu_has_cap);
+		return false;
+	}
+
+	return true;
+}
+
+/*
  * Check for CPU features that are used in early boot
  * based on the Boot CPU value.
  */
@@ -1250,25 +1302,10 @@ verify_local_elf_hwcaps(const struct arm
 		}
 }
 
-static void
-verify_local_cpu_features(const struct arm64_cpu_capabilities *caps_list)
+static void verify_local_cpu_features(void)
 {
-	const struct arm64_cpu_capabilities *caps = caps_list;
-	for (; caps->matches; caps++) {
-		if (!cpus_have_cap(caps->capability))
-			continue;
-		/*
-		 * If the new CPU misses an advertised feature, we cannot proceed
-		 * further, park the cpu.
-		 */
-		if (!__this_cpu_has_cap(caps_list, caps->capability)) {
-			pr_crit("CPU%d: missing feature: %s\n",
-					smp_processor_id(), caps->desc);
-			cpu_die_early();
-		}
-		if (caps->cpu_enable)
-			caps->cpu_enable(caps);
-	}
+	if (!__verify_local_cpu_caps(arm64_features))
+		cpu_die_early();
 }
 
 /*
@@ -1278,20 +1315,8 @@ verify_local_cpu_features(const struct a
  */
 static void verify_local_cpu_errata_workarounds(void)
 {
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
+	if (!__verify_local_cpu_caps(arm64_errata))
+		cpu_die_early();
 }
 
 static void update_cpu_errata_workarounds(void)
@@ -1315,7 +1340,7 @@ static void __init enable_errata_workaro
 static void verify_local_cpu_capabilities(void)
 {
 	verify_local_cpu_errata_workarounds();
-	verify_local_cpu_features(arm64_features);
+	verify_local_cpu_features();
 	verify_local_elf_hwcaps(arm64_elf_hwcaps);
 	if (system_supports_32bit_el0())
 		verify_local_elf_hwcaps(compat_elf_hwcaps);


