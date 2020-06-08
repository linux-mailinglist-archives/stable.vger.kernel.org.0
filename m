Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2788E1F2CE1
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729050AbgFIA2n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:28:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:37656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729403AbgFHXQU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:16:20 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8EFDD20872;
        Mon,  8 Jun 2020 23:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658179;
        bh=2jPL/UbYewWsAEwE08ia4yDFpKrMQa6hoEZi5i09um8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hO+P0qgAzpdqJMLebZFLuePARzxjaTvm6qfGio88T7vQKVOz/kbx0bjsCrUXbNAuY
         UmQcFpMDJJMJIRGTV682w0zjnDHWasHD18KqegI9kg7aQKrGHSJR++jXsZZZi9Jji6
         hnRha2wQPAUVlAd5TJFeuMRQOKS6NuC+KcU/oPHo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vincent Guittot <vincent.guittot@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.6 204/606] sched/fair: Fix reordering of enqueue/dequeue_task_fair()
Date:   Mon,  8 Jun 2020 19:05:29 -0400
Message-Id: <20200608231211.3363633-204-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index a486bf3d5078..7cd86641b44b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5289,15 +5289,15 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
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
@@ -5386,15 +5386,16 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
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

