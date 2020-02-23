Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56E3416935E
	for <lists+stable@lfdr.de>; Sun, 23 Feb 2020 03:22:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728274AbgBWCWn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Feb 2020 21:22:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:51792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728267AbgBWCWn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 22 Feb 2020 21:22:43 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97AA02465D;
        Sun, 23 Feb 2020 02:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582424562;
        bh=siUPiCtxQBOzvDJ1cMGRJ/OOCF/Egl1VKvdrHIIzJWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0NTdJ2CaBezUYOn0PFinYWED9L0ibBxfWimft2hW4DbyZK10cb5IEtmGV40lGKDC6
         k6qjWmap6RqEXwXhYFqyamL7JaTgXhyNRkJrzgCIuegaEB3JHvrVeYgxQ9Lvv2wn9P
         07+V+M81cmUTNhFHVUtTmS/gEqdHbPC2v2W1rHNQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vincent Guittot <vincent.guittot@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Ben Segall <bsegall@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 05/50] sched/fair: Prevent unlimited runtime on throttled group
Date:   Sat, 22 Feb 2020 21:21:50 -0500
Message-Id: <20200223022235.1404-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200223022235.1404-1-sashal@kernel.org>
References: <20200223022235.1404-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Guittot <vincent.guittot@linaro.org>

[ Upstream commit 2a4b03ffc69f2dedc6388e9a6438b5f4c133a40d ]

When a running task is moved on a throttled task group and there is no
other task enqueued on the CPU, the task can keep running using 100% CPU
whatever the allocated bandwidth for the group and although its cfs rq is
throttled. Furthermore, the group entity of the cfs_rq and its parents are
not enqueued but only set as curr on their respective cfs_rqs.

We have the following sequence:

sched_move_task
  -dequeue_task: dequeue task and group_entities.
  -put_prev_task: put task and group entities.
  -sched_change_group: move task to new group.
  -enqueue_task: enqueue only task but not group entities because cfs_rq is
    throttled.
  -set_next_task : set task and group_entities as current sched_entity of
    their cfs_rq.

Another impact is that the root cfs_rq runnable_load_avg at root rq stays
null because the group_entities are not enqueued. This situation will stay
the same until an "external" event triggers a reschedule. Let trigger it
immediately instead.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Ben Segall <bsegall@google.com>
Link: https://lkml.kernel.org/r/1579011236-31256-1-git-send-email-vincent.guittot@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index a6eeca7021621..be146a1220e33 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7057,8 +7057,15 @@ void sched_move_task(struct task_struct *tsk)
 
 	if (queued)
 		enqueue_task(rq, tsk, queue_flags);
-	if (running)
+	if (running) {
 		set_next_task(rq, tsk);
+		/*
+		 * After changing group, the running task may have joined a
+		 * throttled one but it's still the running task. Trigger a
+		 * resched to make sure that task can still run.
+		 */
+		resched_curr(rq);
+	}
 
 	task_rq_unlock(rq, tsk, &rf);
 }
-- 
2.20.1

