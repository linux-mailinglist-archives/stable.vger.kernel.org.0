Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 023E6E32FF
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 14:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502139AbfJXMuG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 08:50:06 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52299 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502116AbfJXMuG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 08:50:06 -0400
Received: by mail-wm1-f68.google.com with SMTP id p21so1256168wmg.2
        for <stable@vger.kernel.org>; Thu, 24 Oct 2019 05:50:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QmCjICzY2i9rUIUTi7UhbZQWZwT1wFzhpUhnqyvWKvM=;
        b=D1IhCgoMed2V7PBVHajI0HpwYi6E8eujUPdq3imfhL1fXvnjwMkyq1bAR5Gx04KqUe
         VVzu+T4mV5w4ipJSUC1jBt8icy1zWGio7A27Ccu7RqGcWhbgzPV97HpiWmEcewc6JbRa
         La8wuCaTKeP+96MPFgiqoP1KqIfVdXBTws7FuElbTauDrCckLXpzuLinO6xC3PlBatn/
         Kw8C3ZwYTkyUHO8AKpu4GGqpAUK0gQHQgCgT1M5eMavasrLOwTdHuVPnn63SfLguSHtH
         /8O0cpdVNjaBv/nW0oWcty86ySOkBrv+usP/rYruWPyVctzLNHD3LF33GrekUz7KDNlB
         q/jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QmCjICzY2i9rUIUTi7UhbZQWZwT1wFzhpUhnqyvWKvM=;
        b=c4WJrjhLZ2lrfCknxokLsN6/nv7UJPnMcQjT1jo4xy9MonNyTY58Bj40irhwMU+JjZ
         qQyyl+0C48iXAvpZCLGHdDJODQ61P14CCO8QRSdjbW+s2yThQdADLP7VxOGB8ILD0qP+
         yb6hBg8Mt0aAxVwlCWrP736ZiXkUaaJsUlJg+b2LG38sPt4c0jWh3iY51Khve0G1zDjd
         kysy7sXhY7K5hYOOVhE4uddWrhf6xKcs5OtfvNuNNVed2TXAMOx12Uj0+u+zlrOzXHjK
         1S7GWBxa/NybBXjV1nL7pcchRt+TrJ8KdbIQeoPB/BDib9AiUofcz0hvqjVj0a0OlBXD
         yTcQ==
X-Gm-Message-State: APjAAAWTmsHOAyCUFl4k2WolFA1cQMlPTr/7x81SSfB72djOvIop8++e
        5HFBjiSdTdLEqdEi0t+bfAh0hvxOslcuXVze
X-Google-Smtp-Source: APXvYqzWUOYzCO/gwN5GG0nL0l3OXSjfPs5LKkOOp+WdvVmIMwsQmlI/3bZcIwSw9g7OrZ1RpsUmhA==
X-Received: by 2002:a1c:6a07:: with SMTP id f7mr5125517wmc.124.1571921403109;
        Thu, 24 Oct 2019 05:50:03 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-126-126.w90-88.abo.wanadoo.fr. [90.88.7.126])
        by smtp.gmail.com with ESMTPSA id j22sm29111038wrd.41.2019.10.24.05.50.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 05:50:02 -0700 (PDT)
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
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH for-stable-4.14 48/48] arm64/speculation: Support 'mitigations=' cmdline option
Date:   Thu, 24 Oct 2019 14:48:33 +0200
Message-Id: <20191024124833.4158-49-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191024124833.4158-1-ard.biesheuvel@linaro.org>
References: <20191024124833.4158-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@redhat.com>

[ Upstream commit a111b7c0f20e13b54df2fa959b3dc0bdf1925ae6 ]

Configure arm64 runtime CPU speculation bug mitigations in accordance
with the 'mitigations=' cmdline option.  This affects Meltdown, Spectre
v2, and Speculative Store Bypass.

The default behavior is unchanged.

Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
[will: reorder checks so KASLR implies KPTI and SSBS is affected by cmdline]
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 Documentation/admin-guide/kernel-parameters.txt | 8 +++++---
 arch/arm64/kernel/cpu_errata.c                  | 6 +++++-
 arch/arm64/kernel/cpufeature.c                  | 8 +++++++-
 3 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 5205740ed39b..b67a6cd08ca1 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2389,8 +2389,8 @@
 			http://repo.or.cz/w/linux-2.6/mini2440.git
 
 	mitigations=
-			[X86,PPC,S390] Control optional mitigations for CPU
-			vulnerabilities.  This is a set of curated,
+			[X86,PPC,S390,ARM64] Control optional mitigations for
+			CPU vulnerabilities.  This is a set of curated,
 			arch-independent options, each of which is an
 			aggregation of existing arch-specific options.
 
@@ -2399,12 +2399,14 @@
 				improves system performance, but it may also
 				expose users to several CPU vulnerabilities.
 				Equivalent to: nopti [X86,PPC]
+					       kpti=0 [ARM64]
 					       nospectre_v1 [PPC]
 					       nobp=0 [S390]
 					       nospectre_v1 [X86]
-					       nospectre_v2 [X86,PPC,S390]
+					       nospectre_v2 [X86,PPC,S390,ARM64]
 					       spectre_v2_user=off [X86]
 					       spec_store_bypass_disable=off [X86,PPC]
+					       ssbd=force-off [ARM64]
 					       l1tf=off [X86]
 					       mds=off [X86]
 
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index ca718250d5bd..7d15f4cb6393 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -19,6 +19,7 @@
 #include <linux/arm-smccc.h>
 #include <linux/psci.h>
 #include <linux/types.h>
+#include <linux/cpu.h>
 #include <asm/cpu.h>
 #include <asm/cputype.h>
 #include <asm/cpufeature.h>
@@ -347,6 +348,9 @@ static bool has_ssbd_mitigation(const struct arm64_cpu_capabilities *entry,
 
 	WARN_ON(scope != SCOPE_LOCAL_CPU || preemptible());
 
+	if (cpu_mitigations_off())
+		ssbd_state = ARM64_SSBD_FORCE_DISABLE;
+
 	/* delay setting __ssb_safe until we get a firmware response */
 	if (is_midr_in_range_list(read_cpuid_id(), entry->midr_range_list))
 		this_cpu_safe = true;
@@ -544,7 +548,7 @@ check_branch_predictor(const struct arm64_cpu_capabilities *entry, int scope)
 	}
 
 	/* forced off */
-	if (__nospectre_v2) {
+	if (__nospectre_v2 || cpu_mitigations_off()) {
 		pr_info_once("spectrev2 mitigation disabled by command line option\n");
 		__hardenbp_enab = false;
 		return false;
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index b782e98633da..15ce2c8b9ee2 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -24,6 +24,7 @@
 #include <linux/stop_machine.h>
 #include <linux/types.h>
 #include <linux/mm.h>
+#include <linux/cpu.h>
 #include <asm/cpu.h>
 #include <asm/cpufeature.h>
 #include <asm/cpu_ops.h>
@@ -841,7 +842,7 @@ static bool unmap_kernel_at_el0(const struct arm64_cpu_capabilities *entry,
 		MIDR_ALL_VERSIONS(MIDR_CORTEX_A72),
 		MIDR_ALL_VERSIONS(MIDR_CORTEX_A73),
 	};
-	char const *str = "command line option";
+	char const *str = "kpti command line option";
 	bool meltdown_safe;
 
 	meltdown_safe = is_midr_in_range_list(read_cpuid_id(), kpti_safe_list);
@@ -871,6 +872,11 @@ static bool unmap_kernel_at_el0(const struct arm64_cpu_capabilities *entry,
 		}
 	}
 
+	if (cpu_mitigations_off() && !__kpti_forced) {
+		str = "mitigations=off";
+		__kpti_forced = -1;
+	}
+
 	if (!IS_ENABLED(CONFIG_UNMAP_KERNEL_AT_EL0)) {
 		pr_info_once("kernel page table isolation disabled by kernel configuration\n");
 		return false;
-- 
2.20.1

