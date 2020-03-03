Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56849178226
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:03:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729117AbgCCSNv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 13:13:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:51522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730916AbgCCRp2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:45:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8930A2146E;
        Tue,  3 Mar 2020 17:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583257528;
        bh=3A9kwl5TKMwVP1EqZMueu/S+j3AgCJh1wr+utIdz7i8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xI7abLUZYzniF010/zdlMOUilX+Ou2ebbdnzg9mPGrAnv0OFdu2FVbY20oSBsgZJ3
         y7bol6ursFbNN+F5nGvZ2+HU0vBpSgC4CvjKocXwYC+iX/RNrWdxXo+0GfLihmRZOd
         hVBsB15xU/zkRex2T/+7CtwRCIPxxTWw7UVJ1pLA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Guittot <vincent.guittot@linaro.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Ben Segall <bsegall@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 029/176] sched/fair: Prevent unlimited runtime on throttled group
Date:   Tue,  3 Mar 2020 18:41:33 +0100
Message-Id: <20200303174307.871622078@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174304.593872177@linuxfoundation.org>
References: <20200303174304.593872177@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 65ed821335dd5..9e7768dbd92d2 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7068,8 +7068,15 @@ void sched_move_task(struct task_struct *tsk)
 
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



