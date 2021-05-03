Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF5493719A3
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231618AbhECQhN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:37:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:37694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231519AbhECQgm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:36:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C9D7611CD;
        Mon,  3 May 2021 16:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059748;
        bh=JMheqsyEfXy+44rATLLzsT4x/MHGF6ef774zlWLaA0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S41bunyHYJUs79oEnmueuxy2LwpWO8n8ILJn7K15JXMqpQSzGIuPHR0tCedvEDx95
         +WIPACbknRS0CWsYsWuCHL+LtKyI2u83UIRHe793vmVzfHNOPP9nkA4RmUGDDZCEwE
         cC0FnpB8KbIen+d9epcLmHU/k5ZSM0nPN6qYcJxI0BDp0oMQ4B57ShQJ0dxwkOv2Rq
         tfPqB7mPBRCzv+a8XySxWZjo5xMPxG1q7wtBvGHBDrdJnpuVEdFnHd2Kmx8IsHnAR1
         xUn6hACTWz7CuFwJMic7FfJ5epUJE7Rwh1wtV/xqyDsvGOTKOa9WxM/M5vmgKa2hZL
         it5Nkgt2whAXw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vincent Donnefort <vincent.donnefort@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.12 022/134] sched/pelt: Fix task util_est update filtering
Date:   Mon,  3 May 2021 12:33:21 -0400
Message-Id: <20210503163513.2851510-22-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163513.2851510-1-sashal@kernel.org>
References: <20210503163513.2851510-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Donnefort <vincent.donnefort@arm.com>

[ Upstream commit b89997aa88f0b07d8a6414c908af75062103b8c9 ]

Being called for each dequeue, util_est reduces the number of its updates
by filtering out when the EWMA signal is different from the task util_avg
by less than 1%. It is a problem for a sudden util_avg ramp-up. Due to the
decay from a previous high util_avg, EWMA might now be close enough to
the new util_avg. No update would then happen while it would leave
ue.enqueued with an out-of-date value.

Taking into consideration the two util_est members, EWMA and enqueued for
the filtering, ensures, for both, an up-to-date value.

This is for now an issue only for the trace probe that might return the
stale value. Functional-wise, it isn't a problem, as the value is always
accessed through max(enqueued, ewma).

This problem has been observed using LISA's UtilConvergence:test_means on
the sd845c board.

No regression observed with Hackbench on sd845c and Perf-bench sched pipe
on hikey/hikey960.

Signed-off-by: Vincent Donnefort <vincent.donnefort@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Link: https://lkml.kernel.org/r/20210225165820.1377125-1-vincent.donnefort@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index e3c2dcb1b015..2a4041e3178f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3941,6 +3941,8 @@ static inline void util_est_dequeue(struct cfs_rq *cfs_rq,
 	trace_sched_util_est_cfs_tp(cfs_rq);
 }
 
+#define UTIL_EST_MARGIN (SCHED_CAPACITY_SCALE / 100)
+
 /*
  * Check if a (signed) value is within a specified (unsigned) margin,
  * based on the observation that:
@@ -3958,7 +3960,7 @@ static inline void util_est_update(struct cfs_rq *cfs_rq,
 				   struct task_struct *p,
 				   bool task_sleep)
 {
-	long last_ewma_diff;
+	long last_ewma_diff, last_enqueued_diff;
 	struct util_est ue;
 
 	if (!sched_feat(UTIL_EST))
@@ -3979,6 +3981,8 @@ static inline void util_est_update(struct cfs_rq *cfs_rq,
 	if (ue.enqueued & UTIL_AVG_UNCHANGED)
 		return;
 
+	last_enqueued_diff = ue.enqueued;
+
 	/*
 	 * Reset EWMA on utilization increases, the moving average is used only
 	 * to smooth utilization decreases.
@@ -3992,12 +3996,17 @@ static inline void util_est_update(struct cfs_rq *cfs_rq,
 	}
 
 	/*
-	 * Skip update of task's estimated utilization when its EWMA is
+	 * Skip update of task's estimated utilization when its members are
 	 * already ~1% close to its last activation value.
 	 */
 	last_ewma_diff = ue.enqueued - ue.ewma;
-	if (within_margin(last_ewma_diff, (SCHED_CAPACITY_SCALE / 100)))
+	last_enqueued_diff -= ue.enqueued;
+	if (within_margin(last_ewma_diff, UTIL_EST_MARGIN)) {
+		if (!within_margin(last_enqueued_diff, UTIL_EST_MARGIN))
+			goto done;
+
 		return;
+	}
 
 	/*
 	 * To avoid overestimation of actual task utilization, skip updates if
-- 
2.30.2

