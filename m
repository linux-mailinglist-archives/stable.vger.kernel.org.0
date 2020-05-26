Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30EBA1E2D73
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404001AbgEZTKf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:10:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:39832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403989AbgEZTKe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:10:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27F7C20776;
        Tue, 26 May 2020 19:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520234;
        bh=9acOtv4KC3duxoHSeM86NeKSDTxTvOvBPOBPYuW2Srg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wmn/jmaZyLi4UYh+KswzS+rebjGyu3kpg7gVOPuIojAO7hbpLLcOF5UdniRWQh5Pf
         r9TTEpENZTU1Q6lQrJ1xZLiG+cCVRvioVaGU7Us3mYaq8AdPt1v9gbiRVyq73VgHBH
         lFKEIuLJzbEtJesiP+W8SYclCksL2a5RZrooyndM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Guittot <vincent.guittot@linaro.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 110/111] sched/fair: Fix reordering of enqueue/dequeue_task_fair()
Date:   Tue, 26 May 2020 20:54:08 +0200
Message-Id: <20200526183943.334089577@linuxfoundation.org>
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

[ Upstream commit 5ab297bab984310267734dfbcc8104566658ebef ]

Even when a cgroup is throttled, the group se of a child cgroup can still
be enqueued and its gse->on_rq stays true. When a task is enqueued on such
child, we still have to update the load_avg and increase
h_nr_running of the throttled cfs. Nevertheless, the 1st
for_each_sched_entity() loop is skipped because of gse->on_rq == true and the
2nd loop because the cfs is throttled whereas we have to update both
load_avg with the old h_nr_running and increase h_nr_running in such case.

The same sequence can happen during dequeue when se moves to parent before
breaking in the 1st loop.

Note that the update of load_avg will effectively happen only once in order
to sync up to the throttled time. Next call for updating load_avg will stop
early because the clock stays unchanged.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Fixes: 6d4d22468dae ("sched/fair: Reorder enqueue/dequeue_task_fair path")
Link: https://lkml.kernel.org/r/20200306084208.12583-1-vincent.guittot@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 0e042e847ed3..42cc3de24dcc 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5245,15 +5245,15 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 	for_each_sched_entity(se) {
 		cfs_rq = cfs_rq_of(se);
 
-		/* end evaluation on encountering a throttled cfs_rq */
-		if (cfs_rq_throttled(cfs_rq))
-			goto enqueue_throttle;
-
 		update_load_avg(cfs_rq, se, UPDATE_TG);
 		update_cfs_group(se);
 
 		cfs_rq->h_nr_running++;
 		cfs_rq->idle_h_nr_running += idle_h_nr_running;
+
+		/* end evaluation on encountering a throttled cfs_rq */
+		if (cfs_rq_throttled(cfs_rq))
+			goto enqueue_throttle;
 	}
 
 enqueue_throttle:
@@ -5341,15 +5341,16 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 	for_each_sched_entity(se) {
 		cfs_rq = cfs_rq_of(se);
 
-		/* end evaluation on encountering a throttled cfs_rq */
-		if (cfs_rq_throttled(cfs_rq))
-			goto dequeue_throttle;
-
 		update_load_avg(cfs_rq, se, UPDATE_TG);
 		update_cfs_group(se);
 
 		cfs_rq->h_nr_running--;
 		cfs_rq->idle_h_nr_running -= idle_h_nr_running;
+
+		/* end evaluation on encountering a throttled cfs_rq */
+		if (cfs_rq_throttled(cfs_rq))
+			goto dequeue_throttle;
+
 	}
 
 dequeue_throttle:
-- 
2.25.1



