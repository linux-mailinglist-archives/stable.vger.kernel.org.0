Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25DB4E32D9
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 14:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728684AbfJXMtO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 08:49:14 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51451 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729269AbfJXMtO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 08:49:14 -0400
Received: by mail-wm1-f66.google.com with SMTP id q70so2713782wme.1
        for <stable@vger.kernel.org>; Thu, 24 Oct 2019 05:49:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YWzoLxXtWbgB9RPT3uhHhCtIXIr1OLgjPS7QjmkdYNU=;
        b=gkhu5GzQP7oHNiLstPmcoNt+2xynVsDI0Mo3hr7LFAWZUOK61NH+7gG8gxRgB+ro8V
         kt7DDdmRo+HbRswGnuKe2R2WMa1l++/WeD1bGiyxW6h1p8V37knMxzj9v/G2koYBI26y
         B3r61wc5n+IRCOpFZINhTyz7Cm/vvImTD4a7SSAGLZzoIfT4QU0UOAK2tlxeqRYi6+rH
         KH1plaKf1srMREYjXt9gWkfobI+CBlh8RqP21yb0AXyZGcWh1f11aHHDc6EP9x/8RqTJ
         I3NrulNYgYJD/rqY/Ebig5ARtNrulbeQk39PBcuu28Z4NNxmcg3WQObVOzC9B+JeuoAn
         POmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YWzoLxXtWbgB9RPT3uhHhCtIXIr1OLgjPS7QjmkdYNU=;
        b=OZ6+sNtqtUzcPlqvFLYEW2dIy2RX4KYC2czif5zLGTtq8ctwvk0ucHSpVp+2y7oZ4Z
         mUHjjV1o9k1R9ihioe21prmWgLGApXGQbJn19jS6TSO6qbbNq8R4C7cVo80aKMufNmt/
         j1fb8Z40vU1qN10t8KZYvQjNUCvpX0me2mar9y9gfBB0WhNN68toAwHA9VcwbOgMYaVt
         Ws6F9j6zDy7nj+vQkB29civXSsjsrBpkjCIEriYv2R2As+3LT/i1GIMYIs2XAuZmiqoI
         oRksJ8jgE9gApEF0gfqIrYSl2u4Qfmnkl20AE3v0b+rXxeSuXYIFAgBmPt5/6nzHLOX7
         9lgQ==
X-Gm-Message-State: APjAAAVBZrPwXdfsJbbdzum2odSW2JNNKp0edX1Hdrq0a1Yctx4o9s+e
        01F4PYy/Pc9Isiul8t2YGV0UUPF7LyVEALnd
X-Google-Smtp-Source: APXvYqwhFWeQN0o+4pqP1G9jQS5lsYPuMB6O5/fxeaDkKf5UFIAFaRL8DtCMicGL/EmfcNdilX82rw==
X-Received: by 2002:a1c:f212:: with SMTP id s18mr4621167wmc.72.1571921351065;
        Thu, 24 Oct 2019 05:49:11 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-126-126.w90-88.abo.wanadoo.fr. [90.88.7.126])
        by smtp.gmail.com with ESMTPSA id j22sm29111038wrd.41.2019.10.24.05.49.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 05:49:09 -0700 (PDT)
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
Subject: [PATCH for-stable-4.14 15/48] arm64: capabilities: Unify the verification
Date:   Thu, 24 Oct 2019 14:48:00 +0200
Message-Id: <20191024124833.4158-16-ard.biesheuvel@linaro.org>
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

[ Upstream commit eaac4d83daa50fc1b9b7850346e9a62adfd4647e ]

Now that each capability describes how to treat the conflicts
of CPU cap state vs System wide cap state, we can unify the
verification logic to a single place.

Reviewed-by: Dave Martin <dave.martin@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/kernel/cpufeature.c | 91 +++++++++++++-------
 1 file changed, 58 insertions(+), 33 deletions(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 70b504d84683..e73fae0c0ca7 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1228,6 +1228,58 @@ static inline void set_sys_caps_initialised(void)
 	sys_caps_initialised = true;
 }
 
+/*
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
 /*
  * Check for CPU features that are used in early boot
  * based on the Boot CPU value.
@@ -1250,25 +1302,10 @@ verify_local_elf_hwcaps(const struct arm64_cpu_capabilities *caps)
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
@@ -1278,20 +1315,8 @@ verify_local_cpu_features(const struct arm64_cpu_capabilities *caps_list)
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
@@ -1315,7 +1340,7 @@ static void __init enable_errata_workarounds(void)
 static void verify_local_cpu_capabilities(void)
 {
 	verify_local_cpu_errata_workarounds();
-	verify_local_cpu_features(arm64_features);
+	verify_local_cpu_features();
 	verify_local_elf_hwcaps(arm64_elf_hwcaps);
 	if (system_supports_32bit_el0())
 		verify_local_elf_hwcaps(compat_elf_hwcaps);
-- 
2.20.1

