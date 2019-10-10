Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78EFDD2418
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 10:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389713AbfJJItA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:49:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:55350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389731AbfJJIs7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:48:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1908D218AC;
        Thu, 10 Oct 2019 08:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570697337;
        bh=FwfZPGAk5k2aXhVoQMbOGLDLpIQ+GKcriv79nfKQ7mo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g2irBCh9gSyiqTT7y7h49ILL6lbUX5su3w+GZGTjrmhYwXz++wsx/LNhfY46eyo7P
         fCjwmbRf4GgZVrWKzCzjrcQQkuZlPNMVvBY4sWZSHaBhrJXf2ZL7MrbRTyaLF3P3ze
         8uYxZXsmL+34cOhujsPzMkqtWJET/7ssjOMyEdMQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
        Will Deacon <will.deacon@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 4.19 105/114] arm64/speculation: Support mitigations= cmdline option
Date:   Thu, 10 Oct 2019 10:36:52 +0200
Message-Id: <20191010083613.783241526@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083544.711104709@linuxfoundation.org>
References: <20191010083544.711104709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@redhat.com>

commit a111b7c0f20e13b54df2fa959b3dc0bdf1925ae6 upstream.

Configure arm64 runtime CPU speculation bug mitigations in accordance
with the 'mitigations=' cmdline option.  This affects Meltdown, Spectre
v2, and Speculative Store Bypass.

The default behavior is unchanged.

Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
[will: reorder checks so KASLR implies KPTI and SSBS is affected by cmdline]
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/admin-guide/kernel-parameters.txt |    8 +++++---
 arch/arm64/kernel/cpu_errata.c                  |    6 +++++-
 arch/arm64/kernel/cpufeature.c                  |    8 +++++++-
 3 files changed, 17 insertions(+), 5 deletions(-)

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
@@ -355,6 +356,9 @@ static bool has_ssbd_mitigation(const st
 
 	WARN_ON(scope != SCOPE_LOCAL_CPU || preemptible());
 
+	if (cpu_mitigations_off())
+		ssbd_state = ARM64_SSBD_FORCE_DISABLE;
+
 	/* delay setting __ssb_safe until we get a firmware response */
 	if (is_midr_in_range_list(read_cpuid_id(), entry->midr_range_list))
 		this_cpu_safe = true;
@@ -600,7 +604,7 @@ check_branch_predictor(const struct arm6
 	}
 
 	/* forced off */
-	if (__nospectre_v2) {
+	if (__nospectre_v2 || cpu_mitigations_off()) {
 		pr_info_once("spectrev2 mitigation disabled by command line option\n");
 		__hardenbp_enab = false;
 		return false;
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
@@ -907,7 +908,7 @@ static bool unmap_kernel_at_el0(const st
 		MIDR_ALL_VERSIONS(MIDR_CORTEX_A73),
 		{ /* sentinel */ }
 	};
-	char const *str = "command line option";
+	char const *str = "kpti command line option";
 	bool meltdown_safe;
 
 	meltdown_safe = is_midr_in_range_list(read_cpuid_id(), kpti_safe_list);
@@ -937,6 +938,11 @@ static bool unmap_kernel_at_el0(const st
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


