Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 496343C4920
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235444AbhGLGmA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:42:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:33150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235347AbhGLGk7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:40:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16106610CD;
        Mon, 12 Jul 2021 06:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071890;
        bh=0lw/VCqilOT3QZ8ippwrN+frmOq3y3LU6Q6oQyYOvTA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s6Y3weYhCIE+sk5AIZJCdKJ+wvsZIumC/F65oRTRcY2AdUK5RwQhd9Oi2ifyf3kqO
         EzAuuLoTxND/EiJx94SHlvh7ZAtdaC2bqg2CsX51AE4wP71XDb3jaA3t7H2pRxJonz
         W8WqFcMV+UXVCVO2z2lLp0BJ77LgniGrkKVbVcgI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Donnefort <vincent.donnefort@arm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 264/593] sched/rt: Fix RT utilization tracking during policy change
Date:   Mon, 12 Jul 2021 08:07:04 +0200
Message-Id: <20210712060912.414201952@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Donnefort <vincent.donnefort@arm.com>

[ Upstream commit fecfcbc288e9f4923f40fd23ca78a6acdc7fdf6c ]

RT keeps track of the utilization on a per-rq basis with the structure
avg_rt. This utilization is updated during task_tick_rt(),
put_prev_task_rt() and set_next_task_rt(). However, when the current
running task changes its policy, set_next_task_rt() which would usually
take care of updating the utilization when the rq starts running RT tasks,
will not see a such change, leaving the avg_rt structure outdated. When
that very same task will be dequeued later, put_prev_task_rt() will then
update the utilization, based on a wrong last_update_time, leading to a
huge spike in the RT utilization signal.

The signal would eventually recover from this issue after few ms. Even if
no RT tasks are run, avg_rt is also updated in __update_blocked_others().
But as the CPU capacity depends partly on the avg_rt, this issue has
nonetheless a significant impact on the scheduler.

Fix this issue by ensuring a load update when a running task changes
its policy to RT.

Fixes: 371bf427 ("sched/rt: Add rt_rq utilization tracking")
Signed-off-by: Vincent Donnefort <vincent.donnefort@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Link: https://lore.kernel.org/r/1624271872-211872-2-git-send-email-vincent.donnefort@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/rt.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 49ec096a8aa1..b5cf418e2e3f 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -2291,13 +2291,20 @@ void __init init_sched_rt_class(void)
 static void switched_to_rt(struct rq *rq, struct task_struct *p)
 {
 	/*
-	 * If we are already running, then there's nothing
-	 * that needs to be done. But if we are not running
-	 * we may need to preempt the current running task.
-	 * If that current running task is also an RT task
+	 * If we are running, update the avg_rt tracking, as the running time
+	 * will now on be accounted into the latter.
+	 */
+	if (task_current(rq, p)) {
+		update_rt_rq_load_avg(rq_clock_pelt(rq), rq, 0);
+		return;
+	}
+
+	/*
+	 * If we are not running we may need to preempt the current
+	 * running task. If that current running task is also an RT task
 	 * then see if we can move to another run queue.
 	 */
-	if (task_on_rq_queued(p) && rq->curr != p) {
+	if (task_on_rq_queued(p)) {
 #ifdef CONFIG_SMP
 		if (p->nr_cpus_allowed > 1 && rq->rt.overloaded)
 			rt_queue_push_tasks(rq);
-- 
2.30.2



