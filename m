Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3D3B850E
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406436AbfISWRK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:17:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:58164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406408AbfISWRJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:17:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CF88217D6;
        Thu, 19 Sep 2019 22:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931428;
        bh=mxeu4uLj13ZdTwyKcHula4thozA5vnCkalosJXisIRE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JDuu2CUtcareSGdyNAb/qVIh/YfBXcbxKMKActcMKAIYlAd7+Xi1rKUBqXUXPCgKO
         xSzy10Fkhnum1giA5al3v9XBGVFyZU9OADlDHJmBoMLJKXUB58W8FvFQSnotQZwE8H
         ymsQRFO4r8NHY/oT/7OUR96GSYWgm5Vkq6OJJZZA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        Len Brown <len.brown@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 43/59] tools/power x86_energy_perf_policy: Fix "uninitialized variable" warnings at -O2
Date:   Fri, 20 Sep 2019 00:03:58 +0200
Message-Id: <20190919214807.144422966@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214755.852282682@linuxfoundation.org>
References: <20190919214755.852282682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



