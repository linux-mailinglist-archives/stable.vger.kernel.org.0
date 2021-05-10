Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73F23378867
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234318AbhEJLVX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:21:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:53674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237102AbhEJLLV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:11:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C46D6162C;
        Mon, 10 May 2021 11:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644820;
        bh=JbsbZ5f0Kcd8U2y3kskYEHnL58BMlszrMDZs+59bbQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uXVoOXCcW/xBHaMxvdx46GnwF8qPOfN0cdrb+PdphRdYnMWBI/pyvrFm1wIoc0lE2
         qUaG2aYkfwY8jzantbpIXqXbHBJgwm9qIIQ8GaFT2lPH63PW8xMOb6rj+U0iE814aR
         V4ItgJtzC81Qcnw0AcU4/2DSNKTPMC169ESw5Luw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rik van Riel <riel@surriel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 238/384] sched/fair: Bring back select_idle_smt(), but differently
Date:   Mon, 10 May 2021 12:20:27 +0200
Message-Id: <20210510102022.728959681@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rik van Riel <riel@surriel.com>

[ Upstream commit c722f35b513f807629603bbf24640b1a48be21b5 ]

Mel Gorman did some nice work in 9fe1f127b913 ("sched/fair: Merge
select_idle_core/cpu()"), resulting in the kernel being more efficient
at finding an idle CPU, and in tasks spending less time waiting to be
run, both according to the schedstats run_delay numbers, and according
to measured application latencies. Yay.

The flip side of this is that we see more task migrations (about 30%
more), higher cache misses, higher memory bandwidth utilization, and
higher CPU use, for the same number of requests/second.

This is most pronounced on a memcache type workload, which saw a
consistent 1-3% increase in total CPU use on the system, due to those
increased task migrations leading to higher L2 cache miss numbers, and
higher memory utilization. The exclusive L3 cache on Skylake does us
no favors there.

On our web serving workload, that effect is usually negligible.

It appears that the increased number of CPU migrations is generally a
good thing, since it leads to lower cpu_delay numbers, reflecting the
fact that tasks get to run faster. However, the reduced locality and
the corresponding increase in L2 cache misses hurts a little.

The patch below appears to fix the regression, while keeping the
benefit of the lower cpu_delay numbers, by reintroducing
select_idle_smt with a twist: when a socket has no idle cores, check
to see if the sibling of "prev" is idle, before searching all the
other CPUs.

This fixes both the occasional 9% regression on the web serving
workload, and the continuous 2% CPU use regression on the memcache
type workload.

With Mel's patches and this patch together, task migrations are still
high, but L2 cache misses, memory bandwidth, and CPU time used are
back down to what they were before. The p95 and p99 response times for
the memcache type application improve by about 10% over what they were
before Mel's patches got merged.

Signed-off-by: Rik van Riel <riel@surriel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vincent Guittot <vincent.guittot@linaro.org>
Link: https://lkml.kernel.org/r/20210326151932.2c187840@imladris.surriel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 47 ++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 40 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 2a4041e3178f..54ca03bacddf 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6107,6 +6107,24 @@ static int select_idle_core(struct task_struct *p, int core, struct cpumask *cpu
 	return -1;
 }
 
+/*
+ * Scan the local SMT mask for idle CPUs.
+ */
+static int select_idle_smt(struct task_struct *p, struct sched_domain *sd, int target)
+{
+	int cpu;
+
+	for_each_cpu(cpu, cpu_smt_mask(target)) {
+		if (!cpumask_test_cpu(cpu, p->cpus_ptr) ||
+		    !cpumask_test_cpu(cpu, sched_domain_span(sd)))
+			continue;
+		if (available_idle_cpu(cpu) || sched_idle_cpu(cpu))
+			return cpu;
+	}
+
+	return -1;
+}
+
 #else /* CONFIG_SCHED_SMT */
 
 static inline void set_idle_cores(int cpu, int val)
@@ -6123,6 +6141,11 @@ static inline int select_idle_core(struct task_struct *p, int core, struct cpuma
 	return __select_idle_cpu(core);
 }
 
+static inline int select_idle_smt(struct task_struct *p, struct sched_domain *sd, int target)
+{
+	return -1;
+}
+
 #endif /* CONFIG_SCHED_SMT */
 
 /*
@@ -6130,11 +6153,10 @@ static inline int select_idle_core(struct task_struct *p, int core, struct cpuma
  * comparing the average scan cost (tracked in sd->avg_scan_cost) against the
  * average idle time for this rq (as found in rq->avg_idle).
  */
-static int select_idle_cpu(struct task_struct *p, struct sched_domain *sd, int target)
+static int select_idle_cpu(struct task_struct *p, struct sched_domain *sd, bool has_idle_core, int target)
 {
 	struct cpumask *cpus = this_cpu_cpumask_var_ptr(select_idle_mask);
 	int i, cpu, idle_cpu = -1, nr = INT_MAX;
-	bool smt = test_idle_cores(target, false);
 	int this = smp_processor_id();
 	struct sched_domain *this_sd;
 	u64 time;
@@ -6145,7 +6167,7 @@ static int select_idle_cpu(struct task_struct *p, struct sched_domain *sd, int t
 
 	cpumask_and(cpus, sched_domain_span(sd), p->cpus_ptr);
 
-	if (sched_feat(SIS_PROP) && !smt) {
+	if (sched_feat(SIS_PROP) && !has_idle_core) {
 		u64 avg_cost, avg_idle, span_avg;
 
 		/*
@@ -6165,7 +6187,7 @@ static int select_idle_cpu(struct task_struct *p, struct sched_domain *sd, int t
 	}
 
 	for_each_cpu_wrap(cpu, cpus, target) {
-		if (smt) {
+		if (has_idle_core) {
 			i = select_idle_core(p, cpu, cpus, &idle_cpu);
 			if ((unsigned int)i < nr_cpumask_bits)
 				return i;
@@ -6179,10 +6201,10 @@ static int select_idle_cpu(struct task_struct *p, struct sched_domain *sd, int t
 		}
 	}
 
-	if (smt)
+	if (has_idle_core)
 		set_idle_cores(this, false);
 
-	if (sched_feat(SIS_PROP) && !smt) {
+	if (sched_feat(SIS_PROP) && !has_idle_core) {
 		time = cpu_clock(this) - time;
 		update_avg(&this_sd->avg_scan_cost, time);
 	}
@@ -6237,6 +6259,7 @@ static inline bool asym_fits_capacity(int task_util, int cpu)
  */
 static int select_idle_sibling(struct task_struct *p, int prev, int target)
 {
+	bool has_idle_core = false;
 	struct sched_domain *sd;
 	unsigned long task_util;
 	int i, recent_used_cpu;
@@ -6316,7 +6339,17 @@ static int select_idle_sibling(struct task_struct *p, int prev, int target)
 	if (!sd)
 		return target;
 
-	i = select_idle_cpu(p, sd, target);
+	if (sched_smt_active()) {
+		has_idle_core = test_idle_cores(target, false);
+
+		if (!has_idle_core && cpus_share_cache(prev, target)) {
+			i = select_idle_smt(p, sd, prev);
+			if ((unsigned int)i < nr_cpumask_bits)
+				return i;
+		}
+	}
+
+	i = select_idle_cpu(p, sd, has_idle_core, target);
 	if ((unsigned)i < nr_cpumask_bits)
 		return i;
 
-- 
2.30.2



