Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF3DA8A88
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731732AbfIDP7r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 11:59:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:34306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732465AbfIDP7o (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 11:59:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B94CD20820;
        Wed,  4 Sep 2019 15:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612783;
        bh=gZSnvrdLULxwjHSAUZkDCTpkQxwg/SW7rI52snceEtM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BnKu8VcSp3lxODEFAdEQ8tvfBPM/mMgdgDMwgrcxlJ/nfO/C9x7t3d1fJOdS8TfJ+
         jA96yYwCl5QC3iXppgPvni4+5EAL5Ki1m7U84y8sxWrFWJReY3V/4P023ZkLVFkuM/
         JCvmeHaroolavxbBzEQW5vqAHS8F63UMn4djnRek=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ben Hutchings <ben@decadent.org.uk>,
        Len Brown <len.brown@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 79/94] tools/power x86_energy_perf_policy: Fix "uninitialized variable" warnings at -O2
Date:   Wed,  4 Sep 2019 11:57:24 -0400
Message-Id: <20190904155739.2816-79-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904155739.2816-1-sashal@kernel.org>
References: <20190904155739.2816-1-sashal@kernel.org>
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
index 34a796b303fe2..7663abef51e96 100644
--- a/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
+++ b/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
@@ -1259,6 +1259,15 @@ void probe_dev_msr(void)
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
@@ -1266,15 +1275,10 @@ void probe_dev_msr(void)
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
@@ -1288,7 +1292,7 @@ void early_cpuid(void)
 		bdx_highest_ratio = msr & 0xFF;
 	}
 
-	__get_cpuid(0x6, &eax, &ebx, &ecx, &edx);
+	get_cpuid_or_exit(0x6, &eax, &ebx, &ecx, &edx);
 	turbo_is_enabled = (eax >> 1) & 1;
 	has_hwp = (eax >> 7) & 1;
 	has_epb = (ecx >> 3) & 1;
@@ -1306,7 +1310,7 @@ void parse_cpuid(void)
 
 	eax = ebx = ecx = edx = 0;
 
-	__get_cpuid(0, &max_level, &ebx, &ecx, &edx);
+	get_cpuid_or_exit(0, &max_level, &ebx, &ecx, &edx);
 
 	if (ebx == 0x756e6547 && edx == 0x49656e69 && ecx == 0x6c65746e)
 		genuine_intel = 1;
@@ -1315,7 +1319,7 @@ void parse_cpuid(void)
 		fprintf(stderr, "CPUID(0): %.4s%.4s%.4s ",
 			(char *)&ebx, (char *)&edx, (char *)&ecx);
 
-	__get_cpuid(1, &fms, &ebx, &ecx, &edx);
+	get_cpuid_or_exit(1, &fms, &ebx, &ecx, &edx);
 	family = (fms >> 8) & 0xf;
 	model = (fms >> 4) & 0xf;
 	stepping = fms & 0xf;
@@ -1340,7 +1344,7 @@ void parse_cpuid(void)
 		errx(1, "CPUID: no MSR");
 
 
-	__get_cpuid(0x6, &eax, &ebx, &ecx, &edx);
+	get_cpuid_or_exit(0x6, &eax, &ebx, &ecx, &edx);
 	/* turbo_is_enabled already set */
 	/* has_hwp already set */
 	has_hwp_notify = eax & (1 << 8);
-- 
2.20.1

