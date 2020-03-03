Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC112178171
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:02:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388217AbgCCSC1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 13:02:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:47006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388209AbgCCSC0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 13:02:26 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E0C220656;
        Tue,  3 Mar 2020 18:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258545;
        bh=zqnSYrLFmnPMPr3yKDPaWchUSGueNL68ipVdFfOnoWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qPUHJuxIrzzGWgZBW6rc3oZMgJbLRMTTA6Xd4UCfQp71OZp500gkBciyxxhNoegDq
         wSa66VDayCdg1n8xrBn7FtMm1JmvjcwNmC5nOROXoWilg/CDN4iPYNNFng5RXUCaiS
         abqbE9zTvy2sPcVeR1h4LXJ2nLBLpoBby0UZlenk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Guittot <vincent.guittot@linaro.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, sargun@sargun.me,
        tj@kernel.org, xiexiuqi@huawei.com, xiezhipeng1@huawei.com,
        Ingo Molnar <mingo@kernel.org>,
        Vishnu Rangayyan <vishnu.rangayyan@apple.com>
Subject: [PATCH 4.19 72/87] sched/fair: Optimize update_blocked_averages()
Date:   Tue,  3 Mar 2020 18:44:03 +0100
Message-Id: <20200303174356.734322622@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174349.075101355@linuxfoundation.org>
References: <20200303174349.075101355@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Guittot <vincent.guittot@linaro.org>

commit 31bc6aeaab1d1de8959b67edbed5c7a4b3cdbe7c upstream.

Removing a cfs_rq from rq->leaf_cfs_rq_list can break the parent/child
ordering of the list when it will be added back. In order to remove an
empty and fully decayed cfs_rq, we must remove its children too, so they
will be added back in the right order next time.

With a normal decay of PELT, a parent will be empty and fully decayed
if all children are empty and fully decayed too. In such a case, we just
have to ensure that the whole branch will be added when a new task is
enqueued. This is default behavior since :

  commit f6783319737f ("sched/fair: Fix insertion in rq->leaf_cfs_rq_list")

In case of throttling, the PELT of throttled cfs_rq will not be updated
whereas the parent will. This breaks the assumption made above unless we
remove the children of a cfs_rq that is throttled. Then, they will be
added back when unthrottled and a sched_entity will be enqueued.

As throttled cfs_rq are now removed from the list, we can remove the
associated test in update_blocked_averages().

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: sargun@sargun.me
Cc: tj@kernel.org
Cc: xiexiuqi@huawei.com
Cc: xiezhipeng1@huawei.com
Link: https://lkml.kernel.org/r/1549469662-13614-2-git-send-email-vincent.guittot@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Vishnu Rangayyan <vishnu.rangayyan@apple.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/sched/fair.c |   26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -353,6 +353,18 @@ static inline bool list_add_leaf_cfs_rq(
 static inline void list_del_leaf_cfs_rq(struct cfs_rq *cfs_rq)
 {
 	if (cfs_rq->on_list) {
+		struct rq *rq = rq_of(cfs_rq);
+
+		/*
+		 * With cfs_rq being unthrottled/throttled during an enqueue,
+		 * it can happen the tmp_alone_branch points the a leaf that
+		 * we finally want to del. In this case, tmp_alone_branch moves
+		 * to the prev element but it will point to rq->leaf_cfs_rq_list
+		 * at the end of the enqueue.
+		 */
+		if (rq->tmp_alone_branch == &cfs_rq->leaf_cfs_rq_list)
+			rq->tmp_alone_branch = cfs_rq->leaf_cfs_rq_list.prev;
+
 		list_del_rcu(&cfs_rq->leaf_cfs_rq_list);
 		cfs_rq->on_list = 0;
 	}
@@ -4441,6 +4453,10 @@ static int tg_unthrottle_up(struct task_
 		/* adjust cfs_rq_clock_task() */
 		cfs_rq->throttled_clock_task_time += rq_clock_task(rq) -
 					     cfs_rq->throttled_clock_task;
+
+		/* Add cfs_rq with already running entity in the list */
+		if (cfs_rq->nr_running >= 1)
+			list_add_leaf_cfs_rq(cfs_rq);
 	}
 
 	return 0;
@@ -4452,8 +4468,10 @@ static int tg_throttle_down(struct task_
 	struct cfs_rq *cfs_rq = tg->cfs_rq[cpu_of(rq)];
 
 	/* group is entering throttled state, stop time */
-	if (!cfs_rq->throttle_count)
+	if (!cfs_rq->throttle_count) {
 		cfs_rq->throttled_clock_task = rq_clock_task(rq);
+		list_del_leaf_cfs_rq(cfs_rq);
+	}
 	cfs_rq->throttle_count++;
 
 	return 0;
@@ -4556,6 +4574,8 @@ void unthrottle_cfs_rq(struct cfs_rq *cf
 			break;
 	}
 
+	assert_list_leaf_cfs_rq(rq);
+
 	if (!se)
 		add_nr_running(rq, task_delta);
 
@@ -7459,10 +7479,6 @@ static void update_blocked_averages(int
 	for_each_leaf_cfs_rq(rq, cfs_rq) {
 		struct sched_entity *se;
 
-		/* throttled entities do not contribute to load */
-		if (throttled_hierarchy(cfs_rq))
-			continue;
-
 		if (update_cfs_rq_load_avg(cfs_rq_clock_task(cfs_rq), cfs_rq))
 			update_tg_load_avg(cfs_rq, 0);
 


