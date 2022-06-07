Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD3C54066A
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347348AbiFGRe6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:34:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346929AbiFGR3s (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:29:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFEB011990D;
        Tue,  7 Jun 2022 10:25:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 812B8B8220B;
        Tue,  7 Jun 2022 17:25:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8E29C385A5;
        Tue,  7 Jun 2022 17:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654622703;
        bh=3BC5bYMYuQeVfy7aRNPDQC8/dHLF6z9uKXDBXN/E6/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X6BHAnprlI20aMi4jIfifGu1E3nc4B2ldpgSXAymikkr6ttoeUWHcEXC2JQPzBZLV
         SUvpbj8uZh9xPx5YA7nUs4jWMMUAewZFV8gBH7Of5SDkDkv1wIgnVE4B3FTJ0htPsb
         uBmJBCDOIVM8QW8AvQJNyEvswbt8gni8h006hsss=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chengming Zhou <zhouchengming@bytedance.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ben Segall <bsegall@google.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 152/452] sched/fair: Fix cfs_rq_clock_pelt() for throttled cfs_rq
Date:   Tue,  7 Jun 2022 19:00:09 +0200
Message-Id: <20220607164913.087782338@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chengming Zhou <zhouchengming@bytedance.com>

[ Upstream commit 64eaf50731ac0a8c76ce2fedd50ef6652aabc5ff ]

Since commit 23127296889f ("sched/fair: Update scale invariance of PELT")
change to use rq_clock_pelt() instead of rq_clock_task(), we should also
use rq_clock_pelt() for throttled_clock_task_time and throttled_clock_task
accounting to get correct cfs_rq_clock_pelt() of throttled cfs_rq. And
rename throttled_clock_task(_time) to be clock_pelt rather than clock_task.

Fixes: 23127296889f ("sched/fair: Update scale invariance of PELT")
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Ben Segall <bsegall@google.com>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Link: https://lore.kernel.org/r/20220408115309.81603-1-zhouchengming@bytedance.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c  | 8 ++++----
 kernel/sched/pelt.h  | 4 ++--
 kernel/sched/sched.h | 4 ++--
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 1a306ef51bbe..bca0efc03a51 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4758,8 +4758,8 @@ static int tg_unthrottle_up(struct task_group *tg, void *data)
 
 	cfs_rq->throttle_count--;
 	if (!cfs_rq->throttle_count) {
-		cfs_rq->throttled_clock_task_time += rq_clock_task(rq) -
-					     cfs_rq->throttled_clock_task;
+		cfs_rq->throttled_clock_pelt_time += rq_clock_pelt(rq) -
+					     cfs_rq->throttled_clock_pelt;
 
 		/* Add cfs_rq with already running entity in the list */
 		if (cfs_rq->nr_running >= 1)
@@ -4776,7 +4776,7 @@ static int tg_throttle_down(struct task_group *tg, void *data)
 
 	/* group is entering throttled state, stop time */
 	if (!cfs_rq->throttle_count) {
-		cfs_rq->throttled_clock_task = rq_clock_task(rq);
+		cfs_rq->throttled_clock_pelt = rq_clock_pelt(rq);
 		list_del_leaf_cfs_rq(cfs_rq);
 	}
 	cfs_rq->throttle_count++;
@@ -5194,7 +5194,7 @@ static void sync_throttle(struct task_group *tg, int cpu)
 	pcfs_rq = tg->parent->cfs_rq[cpu];
 
 	cfs_rq->throttle_count = pcfs_rq->throttle_count;
-	cfs_rq->throttled_clock_task = rq_clock_task(cpu_rq(cpu));
+	cfs_rq->throttled_clock_pelt = rq_clock_pelt(cpu_rq(cpu));
 }
 
 /* conditionally throttle active cfs_rq's from put_prev_entity() */
diff --git a/kernel/sched/pelt.h b/kernel/sched/pelt.h
index 45bf08e22207..89150ced09cf 100644
--- a/kernel/sched/pelt.h
+++ b/kernel/sched/pelt.h
@@ -145,9 +145,9 @@ static inline u64 rq_clock_pelt(struct rq *rq)
 static inline u64 cfs_rq_clock_pelt(struct cfs_rq *cfs_rq)
 {
 	if (unlikely(cfs_rq->throttle_count))
-		return cfs_rq->throttled_clock_task - cfs_rq->throttled_clock_task_time;
+		return cfs_rq->throttled_clock_pelt - cfs_rq->throttled_clock_pelt_time;
 
-	return rq_clock_pelt(rq_of(cfs_rq)) - cfs_rq->throttled_clock_task_time;
+	return rq_clock_pelt(rq_of(cfs_rq)) - cfs_rq->throttled_clock_pelt_time;
 }
 #else
 static inline u64 cfs_rq_clock_pelt(struct cfs_rq *cfs_rq)
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 08db8e095e48..8d39f5d99172 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -599,8 +599,8 @@ struct cfs_rq {
 	s64			runtime_remaining;
 
 	u64			throttled_clock;
-	u64			throttled_clock_task;
-	u64			throttled_clock_task_time;
+	u64			throttled_clock_pelt;
+	u64			throttled_clock_pelt_time;
 	int			throttled;
 	int			throttle_count;
 	struct list_head	throttled_list;
-- 
2.35.1



