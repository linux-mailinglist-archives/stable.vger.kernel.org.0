Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95712B8711
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405689AbfISWKd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:10:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:48930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405681AbfISWKc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:10:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D3D021920;
        Thu, 19 Sep 2019 22:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931030;
        bh=6k0UVRVuV3BzhmWx/7jUTuLa0+39oNOFja5xFGJCkng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UwfkDDxnpZ6tOLWvMYjuNJIpW55DaUsqUdS3nDMY7Eq3EzKyyUP6pYS9trnJqpmty
         dgl/J3nN18g2ZRYr+aasZbZZ1PN5qbkQ2DRwug3gzjIYft2UyTD0necl9X5CbSIjAG
         52pSTiojpdZuAKihsHzWbY+dvdeWf4zY90/EK5Y4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Len Brown <len.brown@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 101/124] tools/power turbostat: Fix CPU%C1 display value
Date:   Fri, 20 Sep 2019 00:03:09 +0200
Message-Id: <20190919214822.884237497@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214819.198419517@linuxfoundation.org>
References: <20190919214819.198419517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

[ Upstream commit 1e9042b9c8d46ada9ee7b3339a31f50d12e5d291 ]

In some case C1% will be wrong value, when platform doesn't have MSR for
C1 residency.

For example:
Core    CPU     CPU%c1
-       -       100.00
0       0       100.00
0       2       100.00
1       1       100.00
1       3       100.00

But adding Busy% will fix this
Core    CPU     Busy%   CPU%c1
-       -       99.77   0.23
0       0       99.77   0.23
0       2       99.77   0.23
1       1       99.77   0.23
1       3       99.77   0.23

This issue can be reproduced on most of the recent systems including
Broadwell, Skylake and later.

This is because if we don't select Busy% or Avg_MHz or Bzy_MHz then
mperf value will not be read from MSR, so it will be 0. But this
is required for C1% calculation when MSR for C1 residency is not present.
Same is true for C3, C6 and C7 column selection.

So add another define DO_BIC_READ(), which doesn't depend on user
column selection and use for mperf, C3, C6 and C7 related counters.
So when there is no platform support for C1 residency counters,
we still read these counters, if the CPU has support and user selected
display of CPU%c1.

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 0a80f3cc24e31..5c0154cf190cc 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -506,6 +506,7 @@ unsigned long long bic_enabled = (0xFFFFFFFFFFFFFFFFULL & ~BIC_DISABLED_BY_DEFAU
 unsigned long long bic_present = BIC_USEC | BIC_TOD | BIC_sysfs | BIC_APIC | BIC_X2APIC;
 
 #define DO_BIC(COUNTER_NAME) (bic_enabled & bic_present & COUNTER_NAME)
+#define DO_BIC_READ(COUNTER_NAME) (bic_present & COUNTER_NAME)
 #define ENABLE_BIC(COUNTER_NAME) (bic_enabled |= COUNTER_NAME)
 #define BIC_PRESENT(COUNTER_BIT) (bic_present |= COUNTER_BIT)
 #define BIC_NOT_PRESENT(COUNTER_BIT) (bic_present &= ~COUNTER_BIT)
@@ -1287,6 +1288,14 @@ delta_core(struct core_data *new, struct core_data *old)
 	}
 }
 
+int soft_c1_residency_display(int bic)
+{
+	if (!DO_BIC(BIC_CPU_c1) || use_c1_residency_msr)
+		return 0;
+
+	return DO_BIC_READ(bic);
+}
+
 /*
  * old = new - old
  */
@@ -1322,7 +1331,8 @@ delta_thread(struct thread_data *new, struct thread_data *old,
 
 	old->c1 = new->c1 - old->c1;
 
-	if (DO_BIC(BIC_Avg_MHz) || DO_BIC(BIC_Busy) || DO_BIC(BIC_Bzy_MHz)) {
+	if (DO_BIC(BIC_Avg_MHz) || DO_BIC(BIC_Busy) || DO_BIC(BIC_Bzy_MHz) ||
+	    soft_c1_residency_display(BIC_Avg_MHz)) {
 		if ((new->aperf > old->aperf) && (new->mperf > old->mperf)) {
 			old->aperf = new->aperf - old->aperf;
 			old->mperf = new->mperf - old->mperf;
@@ -1774,7 +1784,8 @@ int get_counters(struct thread_data *t, struct core_data *c, struct pkg_data *p)
 retry:
 	t->tsc = rdtsc();	/* we are running on local CPU of interest */
 
-	if (DO_BIC(BIC_Avg_MHz) || DO_BIC(BIC_Busy) || DO_BIC(BIC_Bzy_MHz)) {
+	if (DO_BIC(BIC_Avg_MHz) || DO_BIC(BIC_Busy) || DO_BIC(BIC_Bzy_MHz) ||
+	    soft_c1_residency_display(BIC_Avg_MHz)) {
 		unsigned long long tsc_before, tsc_between, tsc_after, aperf_time, mperf_time;
 
 		/*
@@ -1851,20 +1862,20 @@ retry:
 	if (!(t->flags & CPU_IS_FIRST_THREAD_IN_CORE))
 		goto done;
 
-	if (DO_BIC(BIC_CPU_c3)) {
+	if (DO_BIC(BIC_CPU_c3) || soft_c1_residency_display(BIC_CPU_c3)) {
 		if (get_msr(cpu, MSR_CORE_C3_RESIDENCY, &c->c3))
 			return -6;
 	}
 
-	if (DO_BIC(BIC_CPU_c6) && !do_knl_cstates) {
+	if ((DO_BIC(BIC_CPU_c6) || soft_c1_residency_display(BIC_CPU_c6)) && !do_knl_cstates) {
 		if (get_msr(cpu, MSR_CORE_C6_RESIDENCY, &c->c6))
 			return -7;
-	} else if (do_knl_cstates) {
+	} else if (do_knl_cstates || soft_c1_residency_display(BIC_CPU_c6)) {
 		if (get_msr(cpu, MSR_KNL_CORE_C6_RESIDENCY, &c->c6))
 			return -7;
 	}
 
-	if (DO_BIC(BIC_CPU_c7))
+	if (DO_BIC(BIC_CPU_c7) || soft_c1_residency_display(BIC_CPU_c7))
 		if (get_msr(cpu, MSR_CORE_C7_RESIDENCY, &c->c7))
 			return -8;
 
-- 
2.20.1



