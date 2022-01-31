Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEB7C4A42C6
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:14:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376845AbiAaLN5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:13:57 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:45430 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359663AbiAaLLz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:11:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D33A60B28;
        Mon, 31 Jan 2022 11:11:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E50C6C36AE3;
        Mon, 31 Jan 2022 11:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627513;
        bh=CDQvcNd51qORtHk1aEkLx93b0VacLGE0an/9B/R4oO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L412AXBMKqGOc+zzVEiVU5m6nMrBpWyJbYqGfyWd7/z1GBAtwLxU4jkaKIFAwQwtF
         A2+4doWwPIZ8kv242aqdHAiSGNfQ6uBIds98eF/E4xarbTgejlrKJU7O50N2rHUfKX
         WfWSfaj2T/QQGGXLueQ/byv/zGmAt7y0zWqN95Q4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rick Yiu <rickyiu@google.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Sachin Sant <sachinp@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 109/171] sched/pelt: Relax the sync of util_sum with util_avg
Date:   Mon, 31 Jan 2022 11:56:14 +0100
Message-Id: <20220131105233.728252176@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Guittot <vincent.guittot@linaro.org>

[ Upstream commit 98b0d890220d45418cfbc5157b3382e6da5a12ab ]

Rick reported performance regressions in bugzilla because of cpu frequency
being lower than before:
    https://bugzilla.kernel.org/show_bug.cgi?id=215045

He bisected the problem to:
commit 1c35b07e6d39 ("sched/fair: Ensure _sum and _avg values stay consistent")

This commit forces util_sum to be synced with the new util_avg after
removing the contribution of a task and before the next periodic sync. By
doing so util_sum is rounded to its lower bound and might lost up to
LOAD_AVG_MAX-1 of accumulated contribution which has not yet been
reflected in util_avg.

Instead of always setting util_sum to the low bound of util_avg, which can
significantly lower the utilization of root cfs_rq after propagating the
change down into the hierarchy, we revert the change of util_sum and
propagate the difference.

In addition, we also check that cfs's util_sum always stays above the
lower bound for a given util_avg as it has been observed that
sched_entity's util_sum is sometimes above cfs one.

Fixes: 1c35b07e6d39 ("sched/fair: Ensure _sum and _avg values stay consistent")
Reported-by: Rick Yiu <rickyiu@google.com>
Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Tested-by: Sachin Sant <sachinp@linux.ibm.com>
Link: https://lkml.kernel.org/r/20220111134659.24961-2-vincent.guittot@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 16 +++++++++++++---
 kernel/sched/pelt.h |  4 +++-
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index d41f966f5866a..6420580f2730b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3422,7 +3422,6 @@ void set_task_rq_fair(struct sched_entity *se,
 	se->avg.last_update_time = n_last_update_time;
 }
 
-
 /*
  * When on migration a sched_entity joins/leaves the PELT hierarchy, we need to
  * propagate its contribution. The key to this propagation is the invariant
@@ -3490,7 +3489,6 @@ void set_task_rq_fair(struct sched_entity *se,
  * XXX: only do this for the part of runnable > running ?
  *
  */
-
 static inline void
 update_tg_cfs_util(struct cfs_rq *cfs_rq, struct sched_entity *se, struct cfs_rq *gcfs_rq)
 {
@@ -3722,7 +3720,19 @@ update_cfs_rq_load_avg(u64 now, struct cfs_rq *cfs_rq)
 
 		r = removed_util;
 		sub_positive(&sa->util_avg, r);
-		sa->util_sum = sa->util_avg * divider;
+		sub_positive(&sa->util_sum, r * divider);
+		/*
+		 * Because of rounding, se->util_sum might ends up being +1 more than
+		 * cfs->util_sum. Although this is not a problem by itself, detaching
+		 * a lot of tasks with the rounding problem between 2 updates of
+		 * util_avg (~1ms) can make cfs->util_sum becoming null whereas
+		 * cfs_util_avg is not.
+		 * Check that util_sum is still above its lower bound for the new
+		 * util_avg. Given that period_contrib might have moved since the last
+		 * sync, we are only sure that util_sum must be above or equal to
+		 *    util_avg * minimum possible divider
+		 */
+		sa->util_sum = max_t(u32, sa->util_sum, sa->util_avg * PELT_MIN_DIVIDER);
 
 		r = removed_runnable;
 		sub_positive(&sa->runnable_avg, r);
diff --git a/kernel/sched/pelt.h b/kernel/sched/pelt.h
index e06071bf3472c..c336f5f481bca 100644
--- a/kernel/sched/pelt.h
+++ b/kernel/sched/pelt.h
@@ -37,9 +37,11 @@ update_irq_load_avg(struct rq *rq, u64 running)
 }
 #endif
 
+#define PELT_MIN_DIVIDER	(LOAD_AVG_MAX - 1024)
+
 static inline u32 get_pelt_divider(struct sched_avg *avg)
 {
-	return LOAD_AVG_MAX - 1024 + avg->period_contrib;
+	return PELT_MIN_DIVIDER + avg->period_contrib;
 }
 
 static inline void cfs_se_util_change(struct sched_avg *avg)
-- 
2.34.1



