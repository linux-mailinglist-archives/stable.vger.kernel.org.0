Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD563A8A90
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732498AbfIDP7y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 11:59:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:34484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732493AbfIDP7w (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 11:59:52 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1943023400;
        Wed,  4 Sep 2019 15:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612791;
        bh=OS31/P9UM5f8LU7jQO3txWjeXIeO7inu0+fDEMQeb8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AHeQQEDpDSiTqfPvalFVsUnqF8qaa+1pZbNYrhwD8yROQhv5cLUOfioZ6N+ITpOBq
         nW9MhU9Ep+HbIkk3K9SmdgNjZqLyRfenuZDC5sObBFAWPUsoTTd2O/j3qfKbekpfFn
         6j01Isx2tyihUGuVuCZk+J+xXqfL89oXxVat4RAk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Len Brown <len.brown@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 86/94] tools/power turbostat: Fix CPU%C1 display value
Date:   Wed,  4 Sep 2019 11:57:31 -0400
Message-Id: <20190904155739.2816-86-sashal@kernel.org>
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
index 9b0f35dd8c200..08d088366ceaf 100644
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
@@ -1851,20 +1862,20 @@ int get_counters(struct thread_data *t, struct core_data *c, struct pkg_data *p)
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

