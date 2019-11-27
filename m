Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B6CB10BAA2
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:07:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731835AbfK0VFH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:05:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:58722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732239AbfK0VFF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:05:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1337A215F1;
        Wed, 27 Nov 2019 21:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888704;
        bh=7OulJToC3ID37K3TZ0A6doTFja8MgrIrJLk12PldQks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vlHq6WFfRgEYSTHC+blgGH6OCIPZVxQ/G9Gvjw/iAvHjqOpDccwdIn0blSu2MEgea
         0nZQqVTPPxdBUFtkQz0z/9dZ/NOxk9f5EfcF2dpV4KLo8tAA4MorCsA9bc5JX/56C9
         eKD9I+tTvShXCqiD3i8AjR+62e4MMaQfi3Gh2Brw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Len Brown <len.brown@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 194/306] tools/power turbosat: fix AMD APIC-id output
Date:   Wed, 27 Nov 2019 21:30:44 +0100
Message-Id: <20191127203129.378914053@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Len Brown <len.brown@intel.com>

[ Upstream commit 3404155190ce09a1e5d8407e968fc19aac4493e3 ]

turbostat recently gained a feature adding APIC and X2APIC columns.
While they are disabled by-default, they are enabled with --debug
or when explicitly requested, eg.

$ sudo turbostat --quiet --show Package,Node,Core,CPU,APIC,X2APIC date

But these columns erroneously showed zeros on AMD hardware.
This patch corrects the APIC and X2APIC [sic] columns on AMD.

Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.c | 93 +++++++++++++++++----------
 1 file changed, 60 insertions(+), 33 deletions(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 823bbc741ad7a..02d123871ef95 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -1,6 +1,6 @@
 /*
  * turbostat -- show CPU frequency and C-state residency
- * on modern Intel turbo-capable processors.
+ * on modern Intel and AMD processors.
  *
  * Copyright (c) 2013 Intel Corporation.
  * Len Brown <len.brown@intel.com>
@@ -71,6 +71,8 @@ unsigned int do_irtl_snb;
 unsigned int do_irtl_hsw;
 unsigned int units = 1000000;	/* MHz etc */
 unsigned int genuine_intel;
+unsigned int authentic_amd;
+unsigned int max_level, max_extended_level;
 unsigned int has_invariant_tsc;
 unsigned int do_nhm_platform_info;
 unsigned int no_MSR_MISC_PWR_MGMT;
@@ -1667,30 +1669,51 @@ int get_mp(int cpu, struct msr_counter *mp, unsigned long long *counterp)
 
 void get_apic_id(struct thread_data *t)
 {
-	unsigned int eax, ebx, ecx, edx, max_level;
+	unsigned int eax, ebx, ecx, edx;
 
-	eax = ebx = ecx = edx = 0;
+	if (DO_BIC(BIC_APIC)) {
+		eax = ebx = ecx = edx = 0;
+		__cpuid(1, eax, ebx, ecx, edx);
 
-	if (!genuine_intel)
+		t->apic_id = (ebx >> 24) & 0xff;
+	}
+
+	if (!DO_BIC(BIC_X2APIC))
 		return;
 
-	__cpuid(0, max_level, ebx, ecx, edx);
+	if (authentic_amd) {
+		unsigned int topology_extensions;
 
-	__cpuid(1, eax, ebx, ecx, edx);
-	t->apic_id = (ebx >> 24) & 0xf;
+		if (max_extended_level < 0x8000001e)
+			return;
 
-	if (max_level < 0xb)
+		eax = ebx = ecx = edx = 0;
+		__cpuid(0x80000001, eax, ebx, ecx, edx);
+			topology_extensions = ecx & (1 << 22);
+
+		if (topology_extensions == 0)
+			return;
+
+		eax = ebx = ecx = edx = 0;
+		__cpuid(0x8000001e, eax, ebx, ecx, edx);
+
+		t->x2apic_id = eax;
 		return;
+	}
 
-	if (!DO_BIC(BIC_X2APIC))
+	if (!genuine_intel)
+		return;
+
+	if (max_level < 0xb)
 		return;
 
 	ecx = 0;
 	__cpuid(0xb, eax, ebx, ecx, edx);
 	t->x2apic_id = edx;
 
-	if (debug && (t->apic_id != t->x2apic_id))
-		fprintf(outf, "cpu%d: apic 0x%x x2apic 0x%x\n", t->cpu_id, t->apic_id, t->x2apic_id);
+	if (debug && (t->apic_id != (t->x2apic_id & 0xff)))
+		fprintf(outf, "cpu%d: BIOS BUG: apic 0x%x x2apic 0x%x\n",
+				t->cpu_id, t->apic_id, t->x2apic_id);
 }
 
 /*
@@ -4439,16 +4462,18 @@ void decode_c6_demotion_policy_msr(void)
 
 void process_cpuid()
 {
-	unsigned int eax, ebx, ecx, edx, max_level, max_extended_level;
-	unsigned int fms, family, model, stepping;
+	unsigned int eax, ebx, ecx, edx;
+	unsigned int fms, family, model, stepping, ecx_flags, edx_flags;
 	unsigned int has_turbo;
 
 	eax = ebx = ecx = edx = 0;
 
 	__cpuid(0, max_level, ebx, ecx, edx);
 
-	if (ebx == 0x756e6547 && edx == 0x49656e69 && ecx == 0x6c65746e)
+	if (ebx == 0x756e6547 && ecx == 0x6c65746e && edx == 0x49656e69)
 		genuine_intel = 1;
+	else if (ebx == 0x68747541 && ecx == 0x444d4163 && edx == 0x69746e65)
+		authentic_amd = 1;
 
 	if (!quiet)
 		fprintf(outf, "CPUID(0): %.4s%.4s%.4s ",
@@ -4462,25 +4487,8 @@ void process_cpuid()
 		family += (fms >> 20) & 0xff;
 	if (family >= 6)
 		model += ((fms >> 16) & 0xf) << 4;
-
-	if (!quiet) {
-		fprintf(outf, "%d CPUID levels; family:model:stepping 0x%x:%x:%x (%d:%d:%d)\n",
-			max_level, family, model, stepping, family, model, stepping);
-		fprintf(outf, "CPUID(1): %s %s %s %s %s %s %s %s %s %s\n",
-			ecx & (1 << 0) ? "SSE3" : "-",
-			ecx & (1 << 3) ? "MONITOR" : "-",
-			ecx & (1 << 6) ? "SMX" : "-",
-			ecx & (1 << 7) ? "EIST" : "-",
-			ecx & (1 << 8) ? "TM2" : "-",
-			edx & (1 << 4) ? "TSC" : "-",
-			edx & (1 << 5) ? "MSR" : "-",
-			edx & (1 << 22) ? "ACPI-TM" : "-",
-			edx & (1 << 28) ? "HT" : "-",
-			edx & (1 << 29) ? "TM" : "-");
-	}
-
-	if (!(edx & (1 << 5)))
-		errx(1, "CPUID: no MSR");
+	ecx_flags = ecx;
+	edx_flags = edx;
 
 	/*
 	 * check max extended function levels of CPUID.
@@ -4490,6 +4498,25 @@ void process_cpuid()
 	ebx = ecx = edx = 0;
 	__cpuid(0x80000000, max_extended_level, ebx, ecx, edx);
 
+	if (!quiet) {
+		fprintf(outf, "0x%x CPUID levels; 0x%x xlevels; family:model:stepping 0x%x:%x:%x (%d:%d:%d)\n",
+			max_level, max_extended_level, family, model, stepping, family, model, stepping);
+		fprintf(outf, "CPUID(1): %s %s %s %s %s %s %s %s %s %s\n",
+			ecx_flags & (1 << 0) ? "SSE3" : "-",
+			ecx_flags & (1 << 3) ? "MONITOR" : "-",
+			ecx_flags & (1 << 6) ? "SMX" : "-",
+			ecx_flags & (1 << 7) ? "EIST" : "-",
+			ecx_flags & (1 << 8) ? "TM2" : "-",
+			edx_flags & (1 << 4) ? "TSC" : "-",
+			edx_flags & (1 << 5) ? "MSR" : "-",
+			edx_flags & (1 << 22) ? "ACPI-TM" : "-",
+			edx_flags & (1 << 28) ? "HT" : "-",
+			edx_flags & (1 << 29) ? "TM" : "-");
+	}
+
+	if (!(edx_flags & (1 << 5)))
+		errx(1, "CPUID: no MSR");
+
 	if (max_extended_level >= 0x80000007) {
 
 		/*
-- 
2.20.1



