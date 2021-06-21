Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F86F3AEDAA
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbhFUQV7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:21:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:41900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230269AbhFUQU6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:20:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3035A6124B;
        Mon, 21 Jun 2021 16:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292323;
        bh=9Rty5lyc/POT2i5VL5MkOlYb2rME7YSmszF48H1AdDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iN6vAOLuRSoTDKW2HCiZjwtEu7W+5eVrEKIxyF/vJHEMzRQQxrZuQhb+18CFCy2uM
         x1PViStrmeQDb+DDzU8cgI3LmYy6lOM5jJtm4Hdsm3nee6V3/CP4/FxhXZx4XynJxF
         fnlejsJkuPj22VAeVmsGeZROGgOS3uRSjD5eUHBg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Odin Ugedal <odin@uged.al>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 49/90] sched/fair: Correctly insert cfs_rqs to list on unthrottle
Date:   Mon, 21 Jun 2021 18:15:24 +0200
Message-Id: <20210621154905.799543802@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154904.159672728@linuxfoundation.org>
References: <20210621154904.159672728@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Odin Ugedal <odin@uged.al>

[ Upstream commit a7b359fc6a37faaf472125867c8dc5a068c90982 ]

Fix an issue where fairness is decreased since cfs_rq's can end up not
being decayed properly. For two sibling control groups with the same
priority, this can often lead to a load ratio of 99/1 (!!).

This happens because when a cfs_rq is throttled, all the descendant
cfs_rq's will be removed from the leaf list. When they initial cfs_rq
is unthrottled, it will currently only re add descendant cfs_rq's if
they have one or more entities enqueued. This is not a perfect
heuristic.

Instead, we insert all cfs_rq's that contain one or more enqueued
entities, or it its load is not completely decayed.

Can often lead to situations like this for equally weighted control
groups:

  $ ps u -C stress
  USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
  root       10009 88.8  0.0   3676   100 pts/1    R+   11:04   0:13 stress --cpu 1
  root       10023  3.0  0.0   3676   104 pts/1    R+   11:04   0:00 stress --cpu 1

Fixes: 31bc6aeaab1d ("sched/fair: Optimize update_blocked_averages()")
[vingo: !SMP build fix]
Signed-off-by: Odin Ugedal <odin@uged.al>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Link: https://lore.kernel.org/r/20210612112815.61678-1-odin@uged.al
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 44 +++++++++++++++++++++++++-------------------
 1 file changed, 25 insertions(+), 19 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index d3f4113e87de..877672df822f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3131,6 +3131,24 @@ static inline void cfs_rq_util_change(struct cfs_rq *cfs_rq, int flags)
 
 #ifdef CONFIG_SMP
 #ifdef CONFIG_FAIR_GROUP_SCHED
+
+static inline bool cfs_rq_is_decayed(struct cfs_rq *cfs_rq)
+{
+	if (cfs_rq->load.weight)
+		return false;
+
+	if (cfs_rq->avg.load_sum)
+		return false;
+
+	if (cfs_rq->avg.util_sum)
+		return false;
+
+	if (cfs_rq->avg.runnable_load_sum)
+		return false;
+
+	return true;
+}
+
 /**
  * update_tg_load_avg - update the tg's load avg
  * @cfs_rq: the cfs_rq whose avg changed
@@ -3833,6 +3851,11 @@ static inline void update_misfit_status(struct task_struct *p, struct rq *rq)
 
 #else /* CONFIG_SMP */
 
+static inline bool cfs_rq_is_decayed(struct cfs_rq *cfs_rq)
+{
+	return true;
+}
+
 #define UPDATE_TG	0x0
 #define SKIP_AGE_LOAD	0x0
 #define DO_ATTACH	0x0
@@ -4488,8 +4511,8 @@ static int tg_unthrottle_up(struct task_group *tg, void *data)
 		cfs_rq->throttled_clock_task_time += rq_clock_task(rq) -
 					     cfs_rq->throttled_clock_task;
 
-		/* Add cfs_rq with already running entity in the list */
-		if (cfs_rq->nr_running >= 1)
+		/* Add cfs_rq with load or one or more already running entities to the list */
+		if (!cfs_rq_is_decayed(cfs_rq) || cfs_rq->nr_running)
 			list_add_leaf_cfs_rq(cfs_rq);
 	}
 
@@ -7620,23 +7643,6 @@ static bool __update_blocked_others(struct rq *rq, bool *done)
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 
-static inline bool cfs_rq_is_decayed(struct cfs_rq *cfs_rq)
-{
-	if (cfs_rq->load.weight)
-		return false;
-
-	if (cfs_rq->avg.load_sum)
-		return false;
-
-	if (cfs_rq->avg.util_sum)
-		return false;
-
-	if (cfs_rq->avg.runnable_load_sum)
-		return false;
-
-	return true;
-}
-
 static bool __update_blocked_fair(struct rq *rq, bool *done)
 {
 	struct cfs_rq *cfs_rq, *pos;
-- 
2.30.2



