Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02493D0A92
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 11:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbfJIJLc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 05:11:32 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36441 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726579AbfJIJLc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Oct 2019 05:11:32 -0400
Received: by mail-wr1-f65.google.com with SMTP id y19so1871198wrd.3
        for <stable@vger.kernel.org>; Wed, 09 Oct 2019 02:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PyXw4Rzm0ftsEsUZfWixzlGpwvRQoRt4tHV8vvVc8GI=;
        b=oFz9NYvPmm0XoJxzYU2BBZ/x4wcao0Y2GhJSerAbsMOB6dxlFWMYD6qdw1HJnpau7H
         BtToLCT5ig2dgcSWfy0ZDbaOtC/wGkRWjDTuueL2SkdanXWhHsexXk9eHkBeEEFnWkYi
         lC4tBDCfZvpLF5GQ9Jht79g1hU2z4Rc2kFd8PSkTEg2aD3oqhn1BxhCPumkhCp0JIBkD
         4aWKtJ0Z8hmnvnQMEfiELtiHeU3hME3Mt/o4wp29gqz4J9M3x9iAthwFXM+tm4r2D2eH
         0rj7ztXqe2nCaj5fghSbowFqqoRz+FFzL60XrXQrc5j370aV/A7i02RTRKdGk8UnL3u/
         Ve8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PyXw4Rzm0ftsEsUZfWixzlGpwvRQoRt4tHV8vvVc8GI=;
        b=YKj39Y21e967fygzG+l3norxdX+Ap0jZp46YsZBj1fiJnea77nhPEWuloI3mTuuMip
         xCppNm0kU0jsz6wXLcRnOb6Calcc7CJsr2XzpQQm3gQe1fGF2AF6RCk8e6Gc5jOXH4lX
         rpvMKjMvSpd1fiP+S4/Qxo5qUeoacDjO2pVE+LwJH+3lhCnXxbTP5O/229rKETYKtHmH
         RJFPoSp9bFv2MofdoB71oV4IqCIm/Cz3Ocnwqq3zDhu9EwesXX2NoBvNCE7sQVFip4w+
         We6wBuxn0OIddTcaOyyo95zDvasAb5Tq3bzFq53JQm9d8zMeTnW/6R3okgQuJhmY2bp1
         82Hg==
X-Gm-Message-State: APjAAAWrPx/dAh7wjyV9DyOhplzKjsypHBDn23fFNAAQbufxK9SOX7pj
        j3wLe4PniIW8H7FSVwOnsKrjW+omiY53NKzK
X-Google-Smtp-Source: APXvYqwwcZEcr4PXocajtGRRKat3sfaithxto57O+yJwg+8bTJcTYY90Fy9Jpow1+35VUy3HtWoatw==
X-Received: by 2002:adf:dbcf:: with SMTP id e15mr2053288wrj.134.1570612289050;
        Wed, 09 Oct 2019 02:11:29 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:ed77:413c:ec9e:7229])
        by smtp.gmail.com with ESMTPSA id j26sm2237837wrd.2.2019.10.09.02.11.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Oct 2019 02:11:28 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     stable@vger.kernel.org
Cc:     jeremy.linton@arm.com, catalin.marinas@arm.com,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Will Deacon <will.deacon@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH for-stable-4.19] arm64/speculation: Support 'mitigations=' cmdline option
Date:   Wed,  9 Oct 2019 11:11:21 +0200
Message-Id: <20191009091121.19434-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
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
index cc2f5c9a8161..16607b178b47 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2503,8 +2503,8 @@
 			http://repo.or.cz/w/linux-2.6/mini2440.git
 
 	mitigations=
-			[X86,PPC,S390] Control optional mitigations for CPU
-			vulnerabilities.  This is a set of curated,
+			[X86,PPC,S390,ARM64] Control optional mitigations for
+			CPU vulnerabilities.  This is a set of curated,
 			arch-independent options, each of which is an
 			aggregation of existing arch-specific options.
 
@@ -2513,12 +2513,14 @@
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
index c623b58a7e2b..e53d7f2edcdb 100644
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
@@ -355,6 +356,9 @@ static bool has_ssbd_mitigation(const struct arm64_cpu_capabilities *entry,
 
 	WARN_ON(scope != SCOPE_LOCAL_CPU || preemptible());
 
+	if (cpu_mitigations_off())
+		ssbd_state = ARM64_SSBD_FORCE_DISABLE;
+
 	/* delay setting __ssb_safe until we get a firmware response */
 	if (is_midr_in_range_list(read_cpuid_id(), entry->midr_range_list))
 		this_cpu_safe = true;
@@ -572,7 +576,7 @@ check_branch_predictor(const struct arm64_cpu_capabilities *entry, int scope)
 	}
 
 	/* forced off */
-	if (__nospectre_v2) {
+	if (__nospectre_v2 || cpu_mitigations_off()) {
 		pr_info_once("spectrev2 mitigation disabled by command line option\n");
 		__hardenbp_enab = false;
 		return false;
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index e93bbadc0cf1..04e660debd42 100644
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
@@ -907,7 +908,7 @@ static bool unmap_kernel_at_el0(const struct arm64_cpu_capabilities *entry,
 		MIDR_ALL_VERSIONS(MIDR_CORTEX_A73),
 		{ /* sentinel */ }
 	};
-	char const *str = "command line option";
+	char const *str = "kpti command line option";
 	bool meltdown_safe;
 
 	meltdown_safe = is_midr_in_range_list(read_cpuid_id(), kpti_safe_list);
@@ -937,6 +938,11 @@ static bool unmap_kernel_at_el0(const struct arm64_cpu_capabilities *entry,
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

