Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8A28147B3B
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:42:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731809AbgAXJly (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:41:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:39470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731675AbgAXJlx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:41:53 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70E9421556;
        Fri, 24 Jan 2020 09:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579858912;
        bh=5KaAIMkJ6gMEzrwfSHsXucmw+DcKAeTRBjq9Y7V1UWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RLBq39WEv6XWttUY18dSb152nYZOCyloDp+GyvcBnw9BAJ6n6UUFXbTmpdAS5UrwX
         jPTsk71CERXGluBi/shm2tQO/E5JjPdGgxE9KCLHiia3w8oshaeNhqvKfGTzN7Vicy
         OoSA3/pS7vwCoa0cmqAQVT+a+zLAF762RwlAep+A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Doug Smythies <dsmythies@telus.net>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, juri.lelli@redhat.com,
        linux-pm@vger.kernel.org, mgorman@suse.de, rostedt@goodmis.org,
        sargun@sargun.me, srinivas.pandruvada@linux.intel.com,
        tj@kernel.org, xiexiuqi@huawei.com, xiezhipeng1@huawei.com,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 089/102] sched/cpufreq: Move the cfs_rq_util_change() call to cpufreq_update_util()
Date:   Fri, 24 Jan 2020 10:31:30 +0100
Message-Id: <20200124092820.108025708@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092806.004582306@linuxfoundation.org>
References: <20200124092806.004582306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Guittot <vincent.guittot@linaro.org>

[ Upstream commit bef69dd87828ef5d8ecdab8d857cd3a33cf98675 ]

update_cfs_rq_load_avg() calls cfs_rq_util_change() every time PELT decays,
which might be inefficient when the cpufreq driver has rate limitation.

When a task is attached on a CPU, we have this call path:

update_load_avg()
  update_cfs_rq_load_avg()
    cfs_rq_util_change -- > trig frequency update
  attach_entity_load_avg()
    cfs_rq_util_change -- > trig frequency update

The 1st frequency update will not take into account the utilization of the
newly attached task and the 2nd one might be discarded because of rate
limitation of the cpufreq driver.

update_cfs_rq_load_avg() is only called by update_blocked_averages()
and update_load_avg() so we can move the call to
cfs_rq_util_change/cpufreq_update_util() into these two functions.

It's also interesting to note that update_load_avg() already calls
cfs_rq_util_change() directly for the !SMP case.

This change will also ensure that cpufreq_update_util() is called even
when there is no more CFS rq in the leaf_cfs_rq_list to update, but only
IRQ, RT or DL PELT signals.

[ mingo: Minor updates. ]

Reported-by: Doug Smythies <dsmythies@telus.net>
Tested-by: Doug Smythies <dsmythies@telus.net>
Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: juri.lelli@redhat.com
Cc: linux-pm@vger.kernel.org
Cc: mgorman@suse.de
Cc: rostedt@goodmis.org
Cc: sargun@sargun.me
Cc: srinivas.pandruvada@linux.intel.com
Cc: tj@kernel.org
Cc: xiexiuqi@huawei.com
Cc: xiezhipeng1@huawei.com
Fixes: 039ae8bcf7a5 ("sched/fair: Fix O(nr_cgroups) in the load balancing path")
Link: https://lkml.kernel.org/r/1574083279-799-1-git-send-email-vincent.guittot@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 111 +++++++++++++++++++++++++-------------------
 1 file changed, 62 insertions(+), 49 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 2b7034e6fa241..c87a798d14562 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3504,9 +3504,6 @@ update_cfs_rq_load_avg(u64 now, struct cfs_rq *cfs_rq)
 	cfs_rq->load_last_update_time_copy = sa->last_update_time;
 #endif
 
-	if (decayed)
-		cfs_rq_util_change(cfs_rq, 0);
-
 	return decayed;
 }
 
@@ -3616,8 +3613,12 @@ static inline void update_load_avg(struct cfs_rq *cfs_rq, struct sched_entity *s
 		attach_entity_load_avg(cfs_rq, se, SCHED_CPUFREQ_MIGRATION);
 		update_tg_load_avg(cfs_rq, 0);
 
-	} else if (decayed && (flags & UPDATE_TG))
-		update_tg_load_avg(cfs_rq, 0);
+	} else if (decayed) {
+		cfs_rq_util_change(cfs_rq, 0);
+
+		if (flags & UPDATE_TG)
+			update_tg_load_avg(cfs_rq, 0);
+	}
 }
 
 #ifndef CONFIG_64BIT
@@ -7517,6 +7518,28 @@ static inline bool others_have_blocked(struct rq *rq) { return false; }
 static inline void update_blocked_load_status(struct rq *rq, bool has_blocked) {}
 #endif
 
+static bool __update_blocked_others(struct rq *rq, bool *done)
+{
+	const struct sched_class *curr_class;
+	u64 now = rq_clock_pelt(rq);
+	bool decayed;
+
+	/*
+	 * update_load_avg() can call cpufreq_update_util(). Make sure that RT,
+	 * DL and IRQ signals have been updated before updating CFS.
+	 */
+	curr_class = rq->curr->sched_class;
+
+	decayed = update_rt_rq_load_avg(now, rq, curr_class == &rt_sched_class) |
+		  update_dl_rq_load_avg(now, rq, curr_class == &dl_sched_class) |
+		  update_irq_load_avg(rq, 0);
+
+	if (others_have_blocked(rq))
+		*done = false;
+
+	return decayed;
+}
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
 
 static inline bool cfs_rq_is_decayed(struct cfs_rq *cfs_rq)
@@ -7536,29 +7559,11 @@ static inline bool cfs_rq_is_decayed(struct cfs_rq *cfs_rq)
 	return true;
 }
 
-static void update_blocked_averages(int cpu)
+static bool __update_blocked_fair(struct rq *rq, bool *done)
 {
-	struct rq *rq = cpu_rq(cpu);
 	struct cfs_rq *cfs_rq, *pos;
-	const struct sched_class *curr_class;
-	struct rq_flags rf;
-	bool done = true;
-
-	rq_lock_irqsave(rq, &rf);
-	update_rq_clock(rq);
-
-	/*
-	 * update_cfs_rq_load_avg() can call cpufreq_update_util(). Make sure
-	 * that RT, DL and IRQ signals have been updated before updating CFS.
-	 */
-	curr_class = rq->curr->sched_class;
-	update_rt_rq_load_avg(rq_clock_pelt(rq), rq, curr_class == &rt_sched_class);
-	update_dl_rq_load_avg(rq_clock_pelt(rq), rq, curr_class == &dl_sched_class);
-	update_irq_load_avg(rq, 0);
-
-	/* Don't need periodic decay once load/util_avg are null */
-	if (others_have_blocked(rq))
-		done = false;
+	bool decayed = false;
+	int cpu = cpu_of(rq);
 
 	/*
 	 * Iterates the task_group tree in a bottom up fashion, see
@@ -7567,9 +7572,13 @@ static void update_blocked_averages(int cpu)
 	for_each_leaf_cfs_rq_safe(rq, cfs_rq, pos) {
 		struct sched_entity *se;
 
-		if (update_cfs_rq_load_avg(cfs_rq_clock_pelt(cfs_rq), cfs_rq))
+		if (update_cfs_rq_load_avg(cfs_rq_clock_pelt(cfs_rq), cfs_rq)) {
 			update_tg_load_avg(cfs_rq, 0);
 
+			if (cfs_rq == &rq->cfs)
+				decayed = true;
+		}
+
 		/* Propagate pending load changes to the parent, if any: */
 		se = cfs_rq->tg->se[cpu];
 		if (se && !skip_blocked_update(se))
@@ -7584,11 +7593,10 @@ static void update_blocked_averages(int cpu)
 
 		/* Don't need periodic decay once load/util_avg are null */
 		if (cfs_rq_has_blocked(cfs_rq))
-			done = false;
+			*done = false;
 	}
 
-	update_blocked_load_status(rq, !done);
-	rq_unlock_irqrestore(rq, &rf);
+	return decayed;
 }
 
 /*
@@ -7638,29 +7646,16 @@ static unsigned long task_h_load(struct task_struct *p)
 			cfs_rq_load_avg(cfs_rq) + 1);
 }
 #else
-static inline void update_blocked_averages(int cpu)
+static bool __update_blocked_fair(struct rq *rq, bool *done)
 {
-	struct rq *rq = cpu_rq(cpu);
 	struct cfs_rq *cfs_rq = &rq->cfs;
-	const struct sched_class *curr_class;
-	struct rq_flags rf;
-
-	rq_lock_irqsave(rq, &rf);
-	update_rq_clock(rq);
-
-	/*
-	 * update_cfs_rq_load_avg() can call cpufreq_update_util(). Make sure
-	 * that RT, DL and IRQ signals have been updated before updating CFS.
-	 */
-	curr_class = rq->curr->sched_class;
-	update_rt_rq_load_avg(rq_clock_pelt(rq), rq, curr_class == &rt_sched_class);
-	update_dl_rq_load_avg(rq_clock_pelt(rq), rq, curr_class == &dl_sched_class);
-	update_irq_load_avg(rq, 0);
+	bool decayed;
 
-	update_cfs_rq_load_avg(cfs_rq_clock_pelt(cfs_rq), cfs_rq);
+	decayed = update_cfs_rq_load_avg(cfs_rq_clock_pelt(cfs_rq), cfs_rq);
+	if (cfs_rq_has_blocked(cfs_rq))
+		*done = false;
 
-	update_blocked_load_status(rq, cfs_rq_has_blocked(cfs_rq) || others_have_blocked(rq));
-	rq_unlock_irqrestore(rq, &rf);
+	return decayed;
 }
 
 static unsigned long task_h_load(struct task_struct *p)
@@ -7669,6 +7664,24 @@ static unsigned long task_h_load(struct task_struct *p)
 }
 #endif
 
+static void update_blocked_averages(int cpu)
+{
+	bool decayed = false, done = true;
+	struct rq *rq = cpu_rq(cpu);
+	struct rq_flags rf;
+
+	rq_lock_irqsave(rq, &rf);
+	update_rq_clock(rq);
+
+	decayed |= __update_blocked_others(rq, &done);
+	decayed |= __update_blocked_fair(rq, &done);
+
+	update_blocked_load_status(rq, !done);
+	if (decayed)
+		cpufreq_update_util(rq, 0);
+	rq_unlock_irqrestore(rq, &rf);
+}
+
 /********** Helpers for find_busiest_group ************************/
 
 /*
-- 
2.20.1



