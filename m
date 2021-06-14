Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F8093A6349
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233319AbhFNLLw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:11:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:42802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234782AbhFNLJI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:09:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E40C610CD;
        Mon, 14 Jun 2021 10:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667601;
        bh=wm+nFo0Rp1fYTk0SJkdAKWlBoaDmmAKbbqzfic9taVw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dX8fo+g4Ra6IB9Tcpz0K6+m53DoxaplwdDe5x+vfGaeKEemWYoiqQRlFvS9pQaRhA
         mfNgbJ58w/BA3fPDDSLN2keBlX6yRfV4HDf9qww91jrLYpoC/PQxpaEIyF8+1KjW9p
         +fZaCaKBwSlIe1RCg2U0I/252LDRdyr+IgnOZmHE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Xuewen Yan <xuewen.yan@unisoc.com>,
        Vincent Donnefort <vincent.donnefort@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH 5.10 116/131] sched/fair: Fix util_est UTIL_AVG_UNCHANGED handling
Date:   Mon, 14 Jun 2021 12:27:57 +0200
Message-Id: <20210614102656.964162939@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102652.964395392@linuxfoundation.org>
References: <20210614102652.964395392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dietmar Eggemann <dietmar.eggemann@arm.com>

commit 68d7a190682aa4eb02db477328088ebad15acc83 upstream.

The util_est internal UTIL_AVG_UNCHANGED flag which is used to prevent
unnecessary util_est updates uses the LSB of util_est.enqueued. It is
exposed via _task_util_est() (and task_util_est()).

Commit 92a801e5d5b7 ("sched/fair: Mask UTIL_AVG_UNCHANGED usages")
mentions that the LSB is lost for util_est resolution but
find_energy_efficient_cpu() checks if task_util_est() returns 0 to
return prev_cpu early.

_task_util_est() returns the max value of util_est.ewma and
util_est.enqueued or'ed w/ UTIL_AVG_UNCHANGED.
So task_util_est() returning the max of task_util() and
_task_util_est() will never return 0 under the default
SCHED_FEAT(UTIL_EST, true).

To fix this use the MSB of util_est.enqueued instead and keep the flag
util_est internal, i.e. don't export it via _task_util_est().

The maximal possible util_avg value for a task is 1024 so the MSB of
'unsigned int util_est.enqueued' isn't used to store a util value.

As a caveat the code behind the util_est_se trace point has to filter
UTIL_AVG_UNCHANGED to see the real util_est.enqueued value which should
be easy to do.

This also fixes an issue report by Xuewen Yan that util_est_update()
only used UTIL_AVG_UNCHANGED for the subtrahend of the equation:

  last_enqueued_diff = ue.enqueued - (task_util() | UTIL_AVG_UNCHANGED)

Fixes: b89997aa88f0b sched/pelt: Fix task util_est update filtering
Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Xuewen Yan <xuewen.yan@unisoc.com>
Reviewed-by: Vincent Donnefort <vincent.donnefort@arm.com>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Link: https://lore.kernel.org/r/20210602145808.1562603-1-dietmar.eggemann@arm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/sched.h |    8 ++++++++
 kernel/sched/debug.c  |    3 ++-
 kernel/sched/fair.c   |    5 +++--
 kernel/sched/pelt.h   |   11 +----------
 4 files changed, 14 insertions(+), 13 deletions(-)

--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -348,11 +348,19 @@ struct load_weight {
  * Only for tasks we track a moving average of the past instantaneous
  * estimated utilization. This allows to absorb sporadic drops in utilization
  * of an otherwise almost periodic task.
+ *
+ * The UTIL_AVG_UNCHANGED flag is used to synchronize util_est with util_avg
+ * updates. When a task is dequeued, its util_est should not be updated if its
+ * util_avg has not been updated in the meantime.
+ * This information is mapped into the MSB bit of util_est.enqueued at dequeue
+ * time. Since max value of util_est.enqueued for a task is 1024 (PELT util_avg
+ * for a task) it is safe to use MSB.
  */
 struct util_est {
 	unsigned int			enqueued;
 	unsigned int			ewma;
 #define UTIL_EST_WEIGHT_SHIFT		2
+#define UTIL_AVG_UNCHANGED		0x80000000
 } __attribute__((__aligned__(sizeof(u64))));
 
 /*
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -888,6 +888,7 @@ __initcall(init_sched_debug_procfs);
 #define __PS(S, F) SEQ_printf(m, "%-45s:%21Ld\n", S, (long long)(F))
 #define __P(F) __PS(#F, F)
 #define   P(F) __PS(#F, p->F)
+#define   PM(F, M) __PS(#F, p->F & (M))
 #define __PSN(S, F) SEQ_printf(m, "%-45s:%14Ld.%06ld\n", S, SPLIT_NS((long long)(F)))
 #define __PN(F) __PSN(#F, F)
 #define   PN(F) __PSN(#F, p->F)
@@ -1014,7 +1015,7 @@ void proc_sched_show_task(struct task_st
 	P(se.avg.util_avg);
 	P(se.avg.last_update_time);
 	P(se.avg.util_est.ewma);
-	P(se.avg.util_est.enqueued);
+	PM(se.avg.util_est.enqueued, ~UTIL_AVG_UNCHANGED);
 #endif
 #ifdef CONFIG_UCLAMP_TASK
 	__PS("uclamp.min", p->uclamp_req[UCLAMP_MIN].value);
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3903,7 +3903,7 @@ static inline unsigned long _task_util_e
 {
 	struct util_est ue = READ_ONCE(p->se.avg.util_est);
 
-	return (max(ue.ewma, ue.enqueued) | UTIL_AVG_UNCHANGED);
+	return max(ue.ewma, (ue.enqueued & ~UTIL_AVG_UNCHANGED));
 }
 
 static inline unsigned long task_util_est(struct task_struct *p)
@@ -4003,7 +4003,7 @@ static inline void util_est_update(struc
 	 * Reset EWMA on utilization increases, the moving average is used only
 	 * to smooth utilization decreases.
 	 */
-	ue.enqueued = (task_util(p) | UTIL_AVG_UNCHANGED);
+	ue.enqueued = task_util(p);
 	if (sched_feat(UTIL_EST_FASTUP)) {
 		if (ue.ewma < ue.enqueued) {
 			ue.ewma = ue.enqueued;
@@ -4052,6 +4052,7 @@ static inline void util_est_update(struc
 	ue.ewma  += last_ewma_diff;
 	ue.ewma >>= UTIL_EST_WEIGHT_SHIFT;
 done:
+	ue.enqueued |= UTIL_AVG_UNCHANGED;
 	WRITE_ONCE(p->se.avg.util_est, ue);
 
 	trace_sched_util_est_se_tp(&p->se);
--- a/kernel/sched/pelt.h
+++ b/kernel/sched/pelt.h
@@ -42,15 +42,6 @@ static inline u32 get_pelt_divider(struc
 	return LOAD_AVG_MAX - 1024 + avg->period_contrib;
 }
 
-/*
- * When a task is dequeued, its estimated utilization should not be update if
- * its util_avg has not been updated at least once.
- * This flag is used to synchronize util_avg updates with util_est updates.
- * We map this information into the LSB bit of the utilization saved at
- * dequeue time (i.e. util_est.dequeued).
- */
-#define UTIL_AVG_UNCHANGED 0x1
-
 static inline void cfs_se_util_change(struct sched_avg *avg)
 {
 	unsigned int enqueued;
@@ -58,7 +49,7 @@ static inline void cfs_se_util_change(st
 	if (!sched_feat(UTIL_EST))
 		return;
 
-	/* Avoid store if the flag has been already set */
+	/* Avoid store if the flag has been already reset */
 	enqueued = avg->util_est.enqueued;
 	if (!(enqueued & UTIL_AVG_UNCHANGED))
 		return;


