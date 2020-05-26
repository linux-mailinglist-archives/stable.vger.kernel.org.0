Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE8611E2CB3
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392298AbgEZTQq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:16:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:47754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404493AbgEZTPt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:15:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BE9D2053B;
        Tue, 26 May 2020 19:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520548;
        bh=ArSUKznHQe9HVtC3B3Rux1wUN+mSMi63toyl8MmeAQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=14ffgYTtZAem+sO+6iAtKObZBl7eZ5ClkLay/Xj13tGKkZSNbw6PuTQkflEoVATft
         CDhTYCzCFl6jQSdTXXCG0czLf6pAlVkHS+gJtNeEocEMbD8VbcZX3Q+ka99+Pko0XX
         b1mkHYQFrLN6tzlkYPiax/lKLSsESTEBEpypS+lU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Juri Lelli <juri.lelli@redhat.com>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Phil Auld <pauld@redhat.com>, Hillf Danton <hdanton@sina.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 124/126] sched/fair: Reorder enqueue/dequeue_task_fair path
Date:   Tue, 26 May 2020 20:54:21 +0200
Message-Id: <20200526183947.729115870@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183937.471379031@linuxfoundation.org>
References: <20200526183937.471379031@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Guittot <vincent.guittot@linaro.org>

[ Upstream commit 6d4d22468dae3d8757af9f8b81b848a76ef4409d ]

The walk through the cgroup hierarchy during the enqueue/dequeue of a task
is split in 2 distinct parts for throttled cfs_rq without any added value
but making code less readable.

Change the code ordering such that everything related to a cfs_rq
(throttled or not) will be done in the same loop.

In addition, the same steps ordering is used when updating a cfs_rq:

 - update_load_avg
 - update_cfs_group
 - update *h_nr_running

This reordering enables the use of h_nr_running in PELT algorithm.

No functional and performance changes are expected and have been noticed
during tests.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: "Dietmar Eggemann <dietmar.eggemann@arm.com>"
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Valentin Schneider <valentin.schneider@arm.com>
Cc: Phil Auld <pauld@redhat.com>
Cc: Hillf Danton <hdanton@sina.com>
Link: https://lore.kernel.org/r/20200224095223.13361-5-mgorman@techsingularity.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 42 ++++++++++++++++++++----------------------
 1 file changed, 20 insertions(+), 22 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c76a20648b72..a486bf3d5078 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5276,32 +5276,31 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 		cfs_rq = cfs_rq_of(se);
 		enqueue_entity(cfs_rq, se, flags);
 
-		/*
-		 * end evaluation on encountering a throttled cfs_rq
-		 *
-		 * note: in the case of encountering a throttled cfs_rq we will
-		 * post the final h_nr_running increment below.
-		 */
-		if (cfs_rq_throttled(cfs_rq))
-			break;
 		cfs_rq->h_nr_running++;
 		cfs_rq->idle_h_nr_running += idle_h_nr_running;
 
+		/* end evaluation on encountering a throttled cfs_rq */
+		if (cfs_rq_throttled(cfs_rq))
+			goto enqueue_throttle;
+
 		flags = ENQUEUE_WAKEUP;
 	}
 
 	for_each_sched_entity(se) {
 		cfs_rq = cfs_rq_of(se);
-		cfs_rq->h_nr_running++;
-		cfs_rq->idle_h_nr_running += idle_h_nr_running;
 
+		/* end evaluation on encountering a throttled cfs_rq */
 		if (cfs_rq_throttled(cfs_rq))
-			break;
+			goto enqueue_throttle;
 
 		update_load_avg(cfs_rq, se, UPDATE_TG);
 		update_cfs_group(se);
+
+		cfs_rq->h_nr_running++;
+		cfs_rq->idle_h_nr_running += idle_h_nr_running;
 	}
 
+enqueue_throttle:
 	if (!se) {
 		add_nr_running(rq, 1);
 		/*
@@ -5362,17 +5361,13 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 		cfs_rq = cfs_rq_of(se);
 		dequeue_entity(cfs_rq, se, flags);
 
-		/*
-		 * end evaluation on encountering a throttled cfs_rq
-		 *
-		 * note: in the case of encountering a throttled cfs_rq we will
-		 * post the final h_nr_running decrement below.
-		*/
-		if (cfs_rq_throttled(cfs_rq))
-			break;
 		cfs_rq->h_nr_running--;
 		cfs_rq->idle_h_nr_running -= idle_h_nr_running;
 
+		/* end evaluation on encountering a throttled cfs_rq */
+		if (cfs_rq_throttled(cfs_rq))
+			goto dequeue_throttle;
+
 		/* Don't dequeue parent if it has other entities besides us */
 		if (cfs_rq->load.weight) {
 			/* Avoid re-evaluating load for this entity: */
@@ -5390,16 +5385,19 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 
 	for_each_sched_entity(se) {
 		cfs_rq = cfs_rq_of(se);
-		cfs_rq->h_nr_running--;
-		cfs_rq->idle_h_nr_running -= idle_h_nr_running;
 
+		/* end evaluation on encountering a throttled cfs_rq */
 		if (cfs_rq_throttled(cfs_rq))
-			break;
+			goto dequeue_throttle;
 
 		update_load_avg(cfs_rq, se, UPDATE_TG);
 		update_cfs_group(se);
+
+		cfs_rq->h_nr_running--;
+		cfs_rq->idle_h_nr_running -= idle_h_nr_running;
 	}
 
+dequeue_throttle:
 	if (!se)
 		sub_nr_running(rq, 1);
 
-- 
2.25.1



