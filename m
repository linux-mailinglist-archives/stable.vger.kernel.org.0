Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 660E3F7E78
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728784AbfKKSnp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:43:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:35146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729648AbfKKSnm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:43:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A04320659;
        Mon, 11 Nov 2019 18:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497821;
        bh=LeSW+nA1C/mdMbUqhaZ3bV3dUN0zhMt/01LMgdpLGbk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=njT7YFY9ZQms8QwSML0Q/DpHc0NIMvtKWG8BoCK0Yky96M4mRnGXpOcxORfQPUlfT
         D361XSK8FWFLmtbDQ0lKRBGNAEWppeRWkCIE4bvZ8a+UwD+LTqL2DBpWCeMEBObfyl
         uikicHIhalHkeoZ83DYqLIUD07SPm+5fy4M3rVsg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <cai@lca.pw>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ben Segall <bsegall@google.com>,
        Dave Chiluk <chiluk+linux@indeed.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, pauld@redhat.com,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 4.19 066/125] sched/fair: Fix -Wunused-but-set-variable warnings
Date:   Mon, 11 Nov 2019 19:28:25 +0100
Message-Id: <20191111181449.035205987@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181438.945353076@linuxfoundation.org>
References: <20191111181438.945353076@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <cai@lca.pw>

commit 763a9ec06c409dcde2a761aac4bb83ff3938e0b3 upstream.

Commit:

   de53fd7aedb1 ("sched/fair: Fix low cpu usage with high throttling by removing expiration of cpu-local slices")

introduced a few compilation warnings:

  kernel/sched/fair.c: In function '__refill_cfs_bandwidth_runtime':
  kernel/sched/fair.c:4365:6: warning: variable 'now' set but not used [-Wunused-but-set-variable]
  kernel/sched/fair.c: In function 'start_cfs_bandwidth':
  kernel/sched/fair.c:4992:6: warning: variable 'overrun' set but not used [-Wunused-but-set-variable]

Also, __refill_cfs_bandwidth_runtime() does no longer update the
expiration time, so fix the comments accordingly.

Signed-off-by: Qian Cai <cai@lca.pw>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Ben Segall <bsegall@google.com>
Reviewed-by: Dave Chiluk <chiluk+linux@indeed.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: pauld@redhat.com
Fixes: de53fd7aedb1 ("sched/fair: Fix low cpu usage with high throttling by removing expiration of cpu-local slices")
Link: https://lkml.kernel.org/r/1566326455-8038-1-git-send-email-cai@lca.pw
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 kernel/sched/fair.c |   19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4305,21 +4305,16 @@ static inline u64 sched_cfs_bandwidth_sl
 }
 
 /*
- * Replenish runtime according to assigned quota and update expiration time.
- * We use sched_clock_cpu directly instead of rq->clock to avoid adding
- * additional synchronization around rq->lock.
+ * Replenish runtime according to assigned quota. We use sched_clock_cpu
+ * directly instead of rq->clock to avoid adding additional synchronization
+ * around rq->lock.
  *
  * requires cfs_b->lock
  */
 void __refill_cfs_bandwidth_runtime(struct cfs_bandwidth *cfs_b)
 {
-	u64 now;
-
-	if (cfs_b->quota == RUNTIME_INF)
-		return;
-
-	now = sched_clock_cpu(smp_processor_id());
-	cfs_b->runtime = cfs_b->quota;
+	if (cfs_b->quota != RUNTIME_INF)
+		cfs_b->runtime = cfs_b->quota;
 }
 
 static inline struct cfs_bandwidth *tg_cfs_bandwidth(struct task_group *tg)
@@ -4924,15 +4919,13 @@ static void init_cfs_rq_runtime(struct c
 
 void start_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
 {
-	u64 overrun;
-
 	lockdep_assert_held(&cfs_b->lock);
 
 	if (cfs_b->period_active)
 		return;
 
 	cfs_b->period_active = 1;
-	overrun = hrtimer_forward_now(&cfs_b->period_timer, cfs_b->period);
+	hrtimer_forward_now(&cfs_b->period_timer, cfs_b->period);
 	hrtimer_start_expires(&cfs_b->period_timer, HRTIMER_MODE_ABS_PINNED);
 }
 


