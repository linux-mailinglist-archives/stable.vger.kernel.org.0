Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70F4BE32D7
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 14:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727913AbfJXMtJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 08:49:09 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42541 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728684AbfJXMtI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 08:49:08 -0400
Received: by mail-wr1-f67.google.com with SMTP id r1so16139544wrs.9
        for <stable@vger.kernel.org>; Thu, 24 Oct 2019 05:49:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CXPr/BDLhB8VgHesX559NGxXMEjwYFeQywhBIXkvp8M=;
        b=cikGTBdPCjQ44Aa9bWbYKu9zjRu4yYFDTg30vWHwVZIgug8e1hjosT+FneFALm+Rex
         C0N1ZxW5//wEFS7mdzZy5qeFtSuc1cQlGmrBGYPeHGQk42iefcs9DZCigtMymuibN7Gb
         2SYgJItTwv5MjWGFpvEL2VWQ4pcJPzaUD800YICtyE/sqyGbyslXJvC+1vL0JySppDon
         0ZSH7m+GA4PEKNNdUqH8XBGowbT+wA27+Pbue3/KGgJsfIor1EK3gqb+OG8EPtE+f8zt
         nZwcNcI636BlAy6WYR7UwnpZbrepCgoZpLJSkS/j/YIgrmX7XyrpPViA5UmfiYK+G2LW
         Acxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CXPr/BDLhB8VgHesX559NGxXMEjwYFeQywhBIXkvp8M=;
        b=Lbu08Yt5iREVroAd/T8gRsROPnab0kuYdtPHvRNBy3ynJzAtU2J7hjmyaqdDBpGREH
         Knr5ZxbTEMoXFtlFH+9uW9bgDTpeWGoOAXD5t3ppugiarVbX2BdvkTEsFJ4pnuuYu8aX
         MY3Y96LTWofw2EL/HLZN2KPxhv1UIl9xbqxyD3NdL34CsBtv46WsP40zGTdnD46q8lsh
         ybPFP2PoNiuWW70rnhcUL3k5KqeX7HsB8KaJD6tuxDmhe1e/sUlgIHLQadYWgeiV0aX+
         x7b4W1OUE3NTiNMbWdmzbUXcIwoTX1kB9QWPv1DNny/P4TRI2sJlPBGUw+P1vHADhdmo
         6AJQ==
X-Gm-Message-State: APjAAAUmbBF6q4VLyc8tH4pNz+Z0EQwzxbYP65Di+dpQGCg8zSiGA6lu
        vGWsfLjRhA6Vp+MLxWJqJIBMuEJ3YpMA5W/6
X-Google-Smtp-Source: APXvYqy5Wp6WqU86RBNGxSe80rGwzz3FGbAU0qbnBS4bEUVxvYOqfo+T1dXyMXVWABuxdHb0loBPBA==
X-Received: by 2002:adf:e982:: with SMTP id h2mr3525294wrm.53.1571921346487;
        Thu, 24 Oct 2019 05:49:06 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-126-126.w90-88.abo.wanadoo.fr. [90.88.7.126])
        by smtp.gmail.com with ESMTPSA id j22sm29111038wrd.41.2019.10.24.05.49.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 05:49:05 -0700 (PDT)
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
        Marc Zyngier <marc.zyngier@arm.com>,
        Dave Martin <dave.martin@arm.com>
Subject: [PATCH for-stable-4.14 12/48] arm64: capabilities: Move errata processing code
Date:   Thu, 24 Oct 2019 14:47:57 +0200
Message-Id: <20191024124833.4158-13-ard.biesheuvel@linaro.org>
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
---
 arch/arm64/include/asm/cpufeature.h |  7 ----
 arch/arm64/kernel/cpu_errata.c      | 33 ---------------
 arch/arm64/kernel/cpufeature.c      | 43 ++++++++++++++++++--
 3 files changed, 40 insertions(+), 43 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index bff4d95db039..22ebede86100 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -230,15 +230,8 @@ static inline bool id_aa64pfr0_32bit_el0(u64 pfr0)
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
 
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 3c2a68d766a2..f1885beb2588 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -621,36 +621,3 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
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
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 1269d496db0a..353464b82d61 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -484,6 +484,9 @@ static void __init init_cpu_ftr_reg(u32 sys_reg, u64 new)
 	reg->user_mask = user_mask;
 }
 
+extern const struct arm64_cpu_capabilities arm64_errata[];
+static void update_cpu_errata_workarounds(void);
+
 void __init init_cpu_features(struct cpuinfo_arm64 *info)
 {
 	/* Before we start using the tables, make sure it is sorted */
@@ -1160,8 +1163,8 @@ static bool __this_cpu_has_cap(const struct arm64_cpu_capabilities *cap_array,
 	return false;
 }
 
-void update_cpu_capabilities(const struct arm64_cpu_capabilities *caps,
-			    const char *info)
+static void update_cpu_capabilities(const struct arm64_cpu_capabilities *caps,
+				    const char *info)
 {
 	for (; caps->matches; caps++) {
 		if (!caps->matches(caps, caps->def_scope))
@@ -1185,7 +1188,8 @@ static int __enable_cpu_capability(void *arg)
  * Run through the enabled capabilities and enable() it on all active
  * CPUs
  */
-void __init enable_cpu_capabilities(const struct arm64_cpu_capabilities *caps)
+static void __init
+enable_cpu_capabilities(const struct arm64_cpu_capabilities *caps)
 {
 	for (; caps->matches; caps++) {
 		unsigned int num = caps->capability;
@@ -1267,6 +1271,39 @@ verify_local_cpu_features(const struct arm64_cpu_capabilities *caps_list)
 	}
 }
 
+/*
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
 /*
  * Run through the enabled system capabilities and enable() it on this CPU.
  * The capabilities were decided based on the available CPUs at the boot time.
-- 
2.20.1

