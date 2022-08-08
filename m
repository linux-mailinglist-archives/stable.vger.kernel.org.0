Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA5458BEE6
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241902AbiHHBdq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:33:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242098AbiHHBdP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:33:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04C91DE86;
        Sun,  7 Aug 2022 18:32:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD118B80E0A;
        Mon,  8 Aug 2022 01:32:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7215FC433D6;
        Mon,  8 Aug 2022 01:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922353;
        bh=KevEOarrveuP8fPe+sKJzKOnhAYtNeLfYjkThID+/xs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YvxCSBxGSCzs3AfUsOmBpx7joBNbPOCjVfdVIIPnqpkFrvmCDzkerm+gYXUBBQrfm
         OlZ77IVKuXiz3sZpHUWvtcv1gjT11K9iqsLKt3QLQUdr29jorXYhYUCKOt8cJF+WQI
         PkTZBAqy0NE8ASWxz6N9vRb6EsdVHl1klOpg1oVJZ5laLCopvIClqAqTw67xC9yfI9
         aWe+KbVAFrWwxlbbMfQzzRWR7YSsinVT12fYA8dC0FoKDuQBcgEitvO5TJt9Qtrem2
         idSng7gOu9oWX9I8lYIvI4fJnB1YPWXre88qPpqkKhAxMvWzbnOHxsbVfeSevEvdg8
         Y8WnXVWWRQDyw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vincent Guittot <vincent.guittot@linaro.org>,
        David Chen <david.chen@nutanix.com>,
        Zhang Qiao <zhangqiao22@huawei.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>, mingo@redhat.com,
        juri.lelli@redhat.com
Subject: [PATCH AUTOSEL 5.19 20/58] sched/fair: fix case with reduced capacity CPU
Date:   Sun,  7 Aug 2022 21:30:38 -0400
Message-Id: <20220808013118.313965-20-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013118.313965-1-sashal@kernel.org>
References: <20220808013118.313965-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Guittot <vincent.guittot@linaro.org>

[ Upstream commit c82a69629c53eda5233f13fc11c3c01585ef48a2 ]

The capacity of the CPU available for CFS tasks can be reduced because of
other activities running on the latter. In such case, it's worth trying to
move CFS tasks on a CPU with more available capacity.

The rework of the load balance has filtered the case when the CPU is
classified to be fully busy but its capacity is reduced.

Check if CPU's capacity is reduced while gathering load balance statistic
and classify it group_misfit_task instead of group_fully_busy so we can
try to move the load on another CPU.

Reported-by: David Chen <david.chen@nutanix.com>
Reported-by: Zhang Qiao <zhangqiao22@huawei.com>
Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: David Chen <david.chen@nutanix.com>
Tested-by: Zhang Qiao <zhangqiao22@huawei.com>
Link: https://lkml.kernel.org/r/20220708154401.21411-1-vincent.guittot@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 54 +++++++++++++++++++++++++++++++++++----------
 1 file changed, 42 insertions(+), 12 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 3fb857a35b16..9d6058b0a3d4 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -7597,8 +7597,8 @@ enum group_type {
 	 */
 	group_fully_busy,
 	/*
-	 * SD_ASYM_CPUCAPACITY only: One task doesn't fit with CPU's capacity
-	 * and must be migrated to a more powerful CPU.
+	 * One task doesn't fit with CPU's capacity and must be migrated to a
+	 * more powerful CPU.
 	 */
 	group_misfit_task,
 	/*
@@ -8681,6 +8681,19 @@ sched_asym(struct lb_env *env, struct sd_lb_stats *sds,  struct sg_lb_stats *sgs
 	return sched_asym_prefer(env->dst_cpu, group->asym_prefer_cpu);
 }
 
+static inline bool
+sched_reduced_capacity(struct rq *rq, struct sched_domain *sd)
+{
+	/*
+	 * When there is more than 1 task, the group_overloaded case already
+	 * takes care of cpu with reduced capacity
+	 */
+	if (rq->cfs.h_nr_running != 1)
+		return false;
+
+	return check_cpu_capacity(rq, sd);
+}
+
 /**
  * update_sg_lb_stats - Update sched_group's statistics for load balancing.
  * @env: The load balancing environment.
@@ -8703,8 +8716,9 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 
 	for_each_cpu_and(i, sched_group_span(group), env->cpus) {
 		struct rq *rq = cpu_rq(i);
+		unsigned long load = cpu_load(rq);
 
-		sgs->group_load += cpu_load(rq);
+		sgs->group_load += load;
 		sgs->group_util += cpu_util_cfs(i);
 		sgs->group_runnable += cpu_runnable(rq);
 		sgs->sum_h_nr_running += rq->cfs.h_nr_running;
@@ -8734,11 +8748,17 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 		if (local_group)
 			continue;
 
-		/* Check for a misfit task on the cpu */
-		if (env->sd->flags & SD_ASYM_CPUCAPACITY &&
-		    sgs->group_misfit_task_load < rq->misfit_task_load) {
-			sgs->group_misfit_task_load = rq->misfit_task_load;
-			*sg_status |= SG_OVERLOAD;
+		if (env->sd->flags & SD_ASYM_CPUCAPACITY) {
+			/* Check for a misfit task on the cpu */
+			if (sgs->group_misfit_task_load < rq->misfit_task_load) {
+				sgs->group_misfit_task_load = rq->misfit_task_load;
+				*sg_status |= SG_OVERLOAD;
+			}
+		} else if ((env->idle != CPU_NOT_IDLE) &&
+			   sched_reduced_capacity(rq, env->sd)) {
+			/* Check for a task running on a CPU with reduced capacity */
+			if (sgs->group_misfit_task_load < load)
+				sgs->group_misfit_task_load = load;
 		}
 	}
 
@@ -8791,7 +8811,8 @@ static bool update_sd_pick_busiest(struct lb_env *env,
 	 * CPUs in the group should either be possible to resolve
 	 * internally or be covered by avg_load imbalance (eventually).
 	 */
-	if (sgs->group_type == group_misfit_task &&
+	if ((env->sd->flags & SD_ASYM_CPUCAPACITY) &&
+	    (sgs->group_type == group_misfit_task) &&
 	    (!capacity_greater(capacity_of(env->dst_cpu), sg->sgc->max_capacity) ||
 	     sds->local_stat.group_type != group_has_spare))
 		return false;
@@ -9412,9 +9433,18 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
 	busiest = &sds->busiest_stat;
 
 	if (busiest->group_type == group_misfit_task) {
-		/* Set imbalance to allow misfit tasks to be balanced. */
-		env->migration_type = migrate_misfit;
-		env->imbalance = 1;
+		if (env->sd->flags & SD_ASYM_CPUCAPACITY) {
+			/* Set imbalance to allow misfit tasks to be balanced. */
+			env->migration_type = migrate_misfit;
+			env->imbalance = 1;
+		} else {
+			/*
+			 * Set load imbalance to allow moving task from cpu
+			 * with reduced capacity.
+			 */
+			env->migration_type = migrate_load;
+			env->imbalance = busiest->group_misfit_task_load;
+		}
 		return;
 	}
 
-- 
2.35.1

