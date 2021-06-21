Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D54603AF022
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231375AbhFUQq1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:46:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:37716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233378AbhFUQoP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:44:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9FB1261457;
        Mon, 21 Jun 2021 16:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624293138;
        bh=Ao7lxb27DTkGsJCknxVJABQY/MmedhbPMCw/GVW6RqU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZGrMmhNfGT9raf0vJhnwYFrftcdQOlVpMhh6/R8Lz4VlrMprYLPZzYTf6OPQyxo0Y
         oPAiaw3BYon3oK52tsIj3IZafFgHaFSpDgu2ENEHaR2jYX3hBFs8I0z8UpqNXl6Fmq
         o6hLIqzi0f4Rkb+thqAK9+oPncOMdmP5HRtRPJyU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Odin Ugedal <odin@uged.al>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 112/178] sched/fair: Correctly insert cfs_rqs to list on unthrottle
Date:   Mon, 21 Jun 2021 18:15:26 +0200
Message-Id: <20210621154926.575675294@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
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
index 47fcc3fe9dc5..56e2334fe66b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3293,6 +3293,24 @@ static inline void cfs_rq_util_change(struct cfs_rq *cfs_rq, int flags)
 
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
+	if (cfs_rq->avg.runnable_sum)
+		return false;
+
+	return true;
+}
+
 /**
  * update_tg_load_avg - update the tg's load avg
  * @cfs_rq: the cfs_rq whose avg changed
@@ -4086,6 +4104,11 @@ static inline void update_misfit_status(struct task_struct *p, struct rq *rq)
 
 #else /* CONFIG_SMP */
 
+static inline bool cfs_rq_is_decayed(struct cfs_rq *cfs_rq)
+{
+	return true;
+}
+
 #define UPDATE_TG	0x0
 #define SKIP_AGE_LOAD	0x0
 #define DO_ATTACH	0x0
@@ -4744,8 +4767,8 @@ static int tg_unthrottle_up(struct task_group *tg, void *data)
 		cfs_rq->throttled_clock_task_time += rq_clock_task(rq) -
 					     cfs_rq->throttled_clock_task;
 
-		/* Add cfs_rq with already running entity in the list */
-		if (cfs_rq->nr_running >= 1)
+		/* Add cfs_rq with load or one or more already running entities to the list */
+		if (!cfs_rq_is_decayed(cfs_rq) || cfs_rq->nr_running)
 			list_add_leaf_cfs_rq(cfs_rq);
 	}
 
@@ -7972,23 +7995,6 @@ static bool __update_blocked_others(struct rq *rq, bool *done)
 
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
-	if (cfs_rq->avg.runnable_sum)
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



