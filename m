Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 970FF328F52
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:50:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235838AbhCATsv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:48:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:53028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241731AbhCATix (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:38:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2504665193;
        Mon,  1 Mar 2021 17:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618670;
        bh=yQcpQpQxm3SqxHncQGW+9e/uD+98cxQ8uk7KhyF5b6Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zXnRb8CbfPDsm2hwGQxHKn2EkNfuTPlSvB/xAOWm4i/6BDLLv231TIyG0g+5iYqjO
         bRPimEZVjENJ7O7Ix/YDekvF7+X6UZg4BlQG31sE8REtY/AvceAG+/lf2CzbEW9QZv
         odud2C46C1gaIQks7a+8vjdOd08EJAoZyQleyTRw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xuewen Yan <xuewen.yan@unisoc.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 174/663] sched/fair: Avoid stale CPU util_est value for schedutil in task dequeue
Date:   Mon,  1 Mar 2021 17:07:02 +0100
Message-Id: <20210301161150.394437521@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xuewen Yan <xuewen.yan@unisoc.com>

[ Upstream commit 8c1f560c1ea3f19e22ba356f62680d9d449c9ec2 ]

CPU (root cfs_rq) estimated utilization (util_est) is currently used in
dequeue_task_fair() to drive frequency selection before it is updated.

with:

CPU_util        : rq->cfs.avg.util_avg
CPU_util_est    : rq->cfs.avg.util_est
CPU_utilization : max(CPU_util, CPU_util_est)
task_util       : p->se.avg.util_avg
task_util_est   : p->se.avg.util_est

dequeue_task_fair():

    /* (1) CPU_util and task_util update + inform schedutil about
           CPU_utilization changes */
    for_each_sched_entity() /* 2 loops */
        (dequeue_entity() ->) update_load_avg() -> cfs_rq_util_change()
         -> cpufreq_update_util() ->...-> sugov_update_[shared\|single]
         -> sugov_get_util() -> cpu_util_cfs()

    /* (2) CPU_util_est and task_util_est update */
    util_est_dequeue()

cpu_util_cfs() uses CPU_utilization which could lead to a false (too
high) utilization value for schedutil in task ramp-down or ramp-up
scenarios during task dequeue.

To mitigate the issue split the util_est update (2) into:

 (A) CPU_util_est update in util_est_dequeue()
 (B) task_util_est update in util_est_update()

Place (A) before (1) and keep (B) where (2) is. The latter is necessary
since (B) relies on task_util update in (1).

Fixes: 7f65ea42eb00 ("sched/fair: Add util_est on top of PELT")
Signed-off-by: Xuewen Yan <xuewen.yan@unisoc.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Link: https://lkml.kernel.org/r/1608283672-18240-1-git-send-email-xuewen.yan94@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 43 ++++++++++++++++++++++++++++---------------
 1 file changed, 28 insertions(+), 15 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index ae7ceba8fd4f2..f3a1b7ac4458b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3932,6 +3932,22 @@ static inline void util_est_enqueue(struct cfs_rq *cfs_rq,
 	trace_sched_util_est_cfs_tp(cfs_rq);
 }
 
+static inline void util_est_dequeue(struct cfs_rq *cfs_rq,
+				    struct task_struct *p)
+{
+	unsigned int enqueued;
+
+	if (!sched_feat(UTIL_EST))
+		return;
+
+	/* Update root cfs_rq's estimated utilization */
+	enqueued  = cfs_rq->avg.util_est.enqueued;
+	enqueued -= min_t(unsigned int, enqueued, _task_util_est(p));
+	WRITE_ONCE(cfs_rq->avg.util_est.enqueued, enqueued);
+
+	trace_sched_util_est_cfs_tp(cfs_rq);
+}
+
 /*
  * Check if a (signed) value is within a specified (unsigned) margin,
  * based on the observation that:
@@ -3945,23 +3961,16 @@ static inline bool within_margin(int value, int margin)
 	return ((unsigned int)(value + margin - 1) < (2 * margin - 1));
 }
 
-static void
-util_est_dequeue(struct cfs_rq *cfs_rq, struct task_struct *p, bool task_sleep)
+static inline void util_est_update(struct cfs_rq *cfs_rq,
+				   struct task_struct *p,
+				   bool task_sleep)
 {
 	long last_ewma_diff;
 	struct util_est ue;
-	int cpu;
 
 	if (!sched_feat(UTIL_EST))
 		return;
 
-	/* Update root cfs_rq's estimated utilization */
-	ue.enqueued  = cfs_rq->avg.util_est.enqueued;
-	ue.enqueued -= min_t(unsigned int, ue.enqueued, _task_util_est(p));
-	WRITE_ONCE(cfs_rq->avg.util_est.enqueued, ue.enqueued);
-
-	trace_sched_util_est_cfs_tp(cfs_rq);
-
 	/*
 	 * Skip update of task's estimated utilization when the task has not
 	 * yet completed an activation, e.g. being migrated.
@@ -4001,8 +4010,7 @@ util_est_dequeue(struct cfs_rq *cfs_rq, struct task_struct *p, bool task_sleep)
 	 * To avoid overestimation of actual task utilization, skip updates if
 	 * we cannot grant there is idle time in this CPU.
 	 */
-	cpu = cpu_of(rq_of(cfs_rq));
-	if (task_util(p) > capacity_orig_of(cpu))
+	if (task_util(p) > capacity_orig_of(cpu_of(rq_of(cfs_rq))))
 		return;
 
 	/*
@@ -4085,8 +4093,11 @@ static inline void
 util_est_enqueue(struct cfs_rq *cfs_rq, struct task_struct *p) {}
 
 static inline void
-util_est_dequeue(struct cfs_rq *cfs_rq, struct task_struct *p,
-		 bool task_sleep) {}
+util_est_dequeue(struct cfs_rq *cfs_rq, struct task_struct *p) {}
+
+static inline void
+util_est_update(struct cfs_rq *cfs_rq, struct task_struct *p,
+		bool task_sleep) {}
 static inline void update_misfit_status(struct task_struct *p, struct rq *rq) {}
 
 #endif /* CONFIG_SMP */
@@ -5589,6 +5600,8 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 	int idle_h_nr_running = task_has_idle_policy(p);
 	bool was_sched_idle = sched_idle_rq(rq);
 
+	util_est_dequeue(&rq->cfs, p);
+
 	for_each_sched_entity(se) {
 		cfs_rq = cfs_rq_of(se);
 		dequeue_entity(cfs_rq, se, flags);
@@ -5639,7 +5652,7 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 		rq->next_balance = jiffies;
 
 dequeue_throttle:
-	util_est_dequeue(&rq->cfs, p, task_sleep);
+	util_est_update(&rq->cfs, p, task_sleep);
 	hrtick_update(rq);
 }
 
-- 
2.27.0



