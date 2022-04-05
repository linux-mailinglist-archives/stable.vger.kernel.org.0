Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1664F35A7
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232010AbiDEKx3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:53:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346003AbiDEJoR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:44:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08F41C6ECA;
        Tue,  5 Apr 2022 02:29:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A21661675;
        Tue,  5 Apr 2022 09:29:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 825EBC385A2;
        Tue,  5 Apr 2022 09:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150996;
        bh=JeOP9O0E13lguv3kCPlsFj5DsdY61KNTlXlTpq8ZoHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u0KFBdEa1sKOUoMB3JNQPf8wruU8+0i0PeidgXQJwXnwTvStNpe9ajwf1QwoW1KVy
         vnfh4EpubePbi/EEEJHEF4gClv2tSsvlsb/of8e+Bc0mhGlRuMmSwI+vwC8AgtIe/y
         uUkzpQCef/zBSCVAMdbm9mdT4CBOURAOQfGzYwFI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Keeping <john@metanate.com>,
        Valentin Schneider <valentin.schneider@arm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 257/913] sched/rt: Plug rt_mutex_setprio() vs push_rt_task() race
Date:   Tue,  5 Apr 2022 09:21:59 +0200
Message-Id: <20220405070347.559092278@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Valentin Schneider <valentin.schneider@arm.com>

[ Upstream commit 49bef33e4b87b743495627a529029156c6e09530 ]

John reported that push_rt_task() can end up invoking
find_lowest_rq(rq->curr) when curr is not an RT task (in this case a CFS
one), which causes mayhem down convert_prio().

This can happen when current gets demoted to e.g. CFS when releasing an
rt_mutex, and the local CPU gets hit with an rto_push_work irqwork before
getting the chance to reschedule. Exactly who triggers this work isn't
entirely clear to me - switched_from_rt() only invokes rt_queue_pull_task()
if there are no RT tasks on the local RQ, which means the local CPU can't
be in the rto_mask.

My current suspected sequence is something along the lines of the below,
with the demoted task being current.

  mark_wakeup_next_waiter()
    rt_mutex_adjust_prio()
      rt_mutex_setprio() // deboost originally-CFS task
	check_class_changed()
	  switched_from_rt() // Only rt_queue_pull_task() if !rq->rt.rt_nr_running
	  switched_to_fair() // Sets need_resched
      __balance_callbacks() // if pull_rt_task(), tell_cpu_to_push() can't select local CPU per the above
      raw_spin_rq_unlock(rq)

       // need_resched is set, so task_woken_rt() can't
       // invoke push_rt_tasks(). Best I can come up with is
       // local CPU has rt_nr_migratory >= 2 after the demotion, so stays
       // in the rto_mask, and then:

       <some other CPU running rto_push_irq_work_func() queues rto_push_work on this CPU>
	 push_rt_task()
	   // breakage follows here as rq->curr is CFS

Move an existing check to check rq->curr vs the next pushable task's
priority before getting anywhere near find_lowest_rq(). While at it, add an
explicit sched_class of rq->curr check prior to invoking
find_lowest_rq(rq->curr). Align the DL logic to also reschedule regardless
of next_task's migratability.

Fixes: a7c81556ec4d ("sched: Fix migrate_disable() vs rt/dl balancing")
Reported-by: John Keeping <john@metanate.com>
Signed-off-by: Valentin Schneider <valentin.schneider@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Tested-by: John Keeping <john@metanate.com>
Link: https://lore.kernel.org/r/20220127154059.974729-1-valentin.schneider@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/deadline.c | 12 ++++++------
 kernel/sched/rt.c       | 32 ++++++++++++++++++++++----------
 2 files changed, 28 insertions(+), 16 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index e94314633b39..1f811b375bf0 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -2145,12 +2145,6 @@ static int push_dl_task(struct rq *rq)
 		return 0;
 
 retry:
-	if (is_migration_disabled(next_task))
-		return 0;
-
-	if (WARN_ON(next_task == rq->curr))
-		return 0;
-
 	/*
 	 * If next_task preempts rq->curr, and rq->curr
 	 * can move away, it makes sense to just reschedule
@@ -2163,6 +2157,12 @@ static int push_dl_task(struct rq *rq)
 		return 0;
 	}
 
+	if (is_migration_disabled(next_task))
+		return 0;
+
+	if (WARN_ON(next_task == rq->curr))
+		return 0;
+
 	/* We might release rq lock */
 	get_task_struct(next_task);
 
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 54f9bb3f1560..2758cf5f7987 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1900,6 +1900,16 @@ static int push_rt_task(struct rq *rq, bool pull)
 		return 0;
 
 retry:
+	/*
+	 * It's possible that the next_task slipped in of
+	 * higher priority than current. If that's the case
+	 * just reschedule current.
+	 */
+	if (unlikely(next_task->prio < rq->curr->prio)) {
+		resched_curr(rq);
+		return 0;
+	}
+
 	if (is_migration_disabled(next_task)) {
 		struct task_struct *push_task = NULL;
 		int cpu;
@@ -1907,6 +1917,18 @@ static int push_rt_task(struct rq *rq, bool pull)
 		if (!pull || rq->push_busy)
 			return 0;
 
+		/*
+		 * Invoking find_lowest_rq() on anything but an RT task doesn't
+		 * make sense. Per the above priority check, curr has to
+		 * be of higher priority than next_task, so no need to
+		 * reschedule when bailing out.
+		 *
+		 * Note that the stoppers are masqueraded as SCHED_FIFO
+		 * (cf. sched_set_stop_task()), so we can't rely on rt_task().
+		 */
+		if (rq->curr->sched_class != &rt_sched_class)
+			return 0;
+
 		cpu = find_lowest_rq(rq->curr);
 		if (cpu == -1 || cpu == rq->cpu)
 			return 0;
@@ -1931,16 +1953,6 @@ static int push_rt_task(struct rq *rq, bool pull)
 	if (WARN_ON(next_task == rq->curr))
 		return 0;
 
-	/*
-	 * It's possible that the next_task slipped in of
-	 * higher priority than current. If that's the case
-	 * just reschedule current.
-	 */
-	if (unlikely(next_task->prio < rq->curr->prio)) {
-		resched_curr(rq);
-		return 0;
-	}
-
 	/* We might release rq lock */
 	get_task_struct(next_task);
 
-- 
2.34.1



