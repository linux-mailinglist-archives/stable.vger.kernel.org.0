Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADCF91E2D96
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403807AbgEZTWJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:22:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:39790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391944AbgEZTKd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:10:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B271B20888;
        Tue, 26 May 2020 19:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520232;
        bh=VC4Bv9HXXuWdCyESRJnXGXY9Lh5TYXispNRAl3SqAuw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tux5KwsnvfRJpNb9B2nzCSsaq0ea7D4pRo6mq47Sqnf4e6pfi4G+5DZFlTxe8RqrR
         1bcHG7ASCedSVdKl5bhNWS7bAPq0ywoRWFY9dIr4cFukDJW2/iEcV3xJRB+L6FuyQl
         0hrVew69ejAMuNgwVaw7zdN/XPA0kIEON8PoRHs4=
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
Subject: [PATCH 5.4 109/111] sched/fair: Reorder enqueue/dequeue_task_fair path
Date:   Tue, 26 May 2020 20:54:07 +0200
Message-Id: <20200526183943.226370333@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183932.245016380@linuxfoundation.org>
References: <20200526183932.245016380@linuxfoundation.org>
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
index eeaf34d65742..0e042e847ed3 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5232,32 +5232,31 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
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
@@ -5317,17 +5316,13 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
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
@@ -5345,16 +5340,19 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 
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



