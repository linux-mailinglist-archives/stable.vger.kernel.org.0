Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 507FDA8BD9
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731810AbfIDQGv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 12:06:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:38092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731726AbfIDQCP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 12:02:15 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C26122DBF;
        Wed,  4 Sep 2019 16:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612934;
        bh=mxeu4uLj13ZdTwyKcHula4thozA5vnCkalosJXisIRE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ha6S5afEjT0N0FVJTdLU7kpyRkSctTP2P4ei+I/SnGXCqGsFfwQWND2Et/VOVPwoK
         6GEIL61LWYnRE+WWrvobXwAI2uS26vA+MhjL6Fp0CJci45JgRQOY1Geh/tnwIAsFPT
         4gHIyGZGLR7Ji8w96TC02D0pMTp47Oi+9TQ0+yOo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ben Hutchings <ben@decadent.org.uk>,
        Len Brown <len.brown@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 33/36] tools/power x86_energy_perf_policy: Fix "uninitialized variable" warnings at -O2
Date:   Wed,  4 Sep 2019 12:01:19 -0400
Message-Id: <20190904160122.4179-33-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904160122.4179-1-sashal@kernel.org>
References: <20190904160122.4179-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>

[ Upstream commit adb8049097a9ec4acd09fbd3aa8636199a78df8a ]

x86_energy_perf_policy first uses __get_cpuid() to check the maximum
CPUID level and exits if it is too low.  It then assumes that later
calls will succeed (which I think is architecturally guaranteed).  It
also assumes that CPUID works at all (which is not guaranteed on
x86_32).

If optimisations are enabled, gcc warns about potentially
uninitialized variables.  Fix this by adding an exit-on-error after
every call to __get_cpuid() instead of just checking the maximum
level.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../x86_energy_perf_policy.c                  | 26 +++++++++++--------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c b/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
index 65bbe627a425f..bbef8bcf44d6d 100644
--- a/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
+++ b/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
@@ -1260,6 +1260,15 @@ void probe_dev_msr(void)
 		if (system("/sbin/modprobe msr > /dev/null 2>&1"))
 			err(-5, "no /dev/cpu/0/msr, Try \"# modprobe msr\" ");
 }
+
+static void get_cpuid_or_exit(unsigned int leaf,
+			     unsigned int *eax, unsigned int *ebx,
+			     unsigned int *ecx, unsigned int *edx)
+{
+	if (!__get_cpuid(leaf, eax, ebx, ecx, edx))
+		errx(1, "Processor not supported\n");
+}
+
 /*
  * early_cpuid()
  * initialize turbo_is_enabled, has_hwp, has_epb
@@ -1267,15 +1276,10 @@ void probe_dev_msr(void)
  */
 void early_cpuid(void)
 {
-	unsigned int eax, ebx, ecx, edx, max_level;
+	unsigned int eax, ebx, ecx, edx;
 	unsigned int fms, family, model;
 
-	__get_cpuid(0, &max_level, &ebx, &ecx, &edx);
-
-	if (max_level < 6)
-		errx(1, "Processor not supported\n");
-
-	__get_cpuid(1, &fms, &ebx, &ecx, &edx);
+	get_cpuid_or_exit(1, &fms, &ebx, &ecx, &edx);
 	family = (fms >> 8) & 0xf;
 	model = (fms >> 4) & 0xf;
 	if (family == 6 || family == 0xf)
@@ -1289,7 +1293,7 @@ void early_cpuid(void)
 		bdx_highest_ratio = msr & 0xFF;
 	}
 
-	__get_cpuid(0x6, &eax, &ebx, &ecx, &edx);
+	get_cpuid_or_exit(0x6, &eax, &ebx, &ecx, &edx);
 	turbo_is_enabled = (eax >> 1) & 1;
 	has_hwp = (eax >> 7) & 1;
 	has_epb = (ecx >> 3) & 1;
@@ -1307,7 +1311,7 @@ void parse_cpuid(void)
 
 	eax = ebx = ecx = edx = 0;
 
-	__get_cpuid(0, &max_level, &ebx, &ecx, &edx);
+	get_cpuid_or_exit(0, &max_level, &ebx, &ecx, &edx);
 
 	if (ebx == 0x756e6547 && edx == 0x49656e69 && ecx == 0x6c65746e)
 		genuine_intel = 1;
@@ -1316,7 +1320,7 @@ void parse_cpuid(void)
 		fprintf(stderr, "CPUID(0): %.4s%.4s%.4s ",
 			(char *)&ebx, (char *)&edx, (char *)&ecx);
 
-	__get_cpuid(1, &fms, &ebx, &ecx, &edx);
+	get_cpuid_or_exit(1, &fms, &ebx, &ecx, &edx);
 	family = (fms >> 8) & 0xf;
 	model = (fms >> 4) & 0xf;
 	stepping = fms & 0xf;
@@ -1341,7 +1345,7 @@ void parse_cpuid(void)
 		errx(1, "CPUID: no MSR");
 
 
-	__get_cpuid(0x6, &eax, &ebx, &ecx, &edx);
+	get_cpuid_or_exit(0x6, &eax, &ebx, &ecx, &edx);
 	/* turbo_is_enabled already set */
 	/* has_hwp already set */
 	has_hwp_notify = eax & (1 << 8);
-- 
2.20.1

