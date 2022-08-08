Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1815058BFA9
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242738AbiHHBm3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:42:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242719AbiHHBko (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:40:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C07A712748;
        Sun,  7 Aug 2022 18:34:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 56526B80E0D;
        Mon,  8 Aug 2022 01:34:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01330C43470;
        Mon,  8 Aug 2022 01:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922491;
        bh=Us5azn9z/bhsRcCBR8T73DvmbNO0Qh6ELubzdyA/PTc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IhcEQMCpl6cLobrgSlHfRq3Pp+PRWYopnBpENN/xn5PjDSXeCrNuz/nZh+oUtLvNC
         iQWWOz386+k8dLc9Y4oSphq3NDh3MNGar3vqz/RhnMQA1sA3zbJXEwW8yE7PRJxcXS
         2ljafzhhJ4zx3Rwryzuiwvvt1e1xojyYava1Skajd3QUEelq4QScCvj2bU8Vt272Jt
         PX0aOeUnwhMOWUUdxwUySrLPtfoDYtGkpwI7tjH7qDc943fJWFtTl3nB3JymgR3ebU
         BXjf64aBITMjZrujG+dNFL9KJS11w//1IQz+HfHb9oFcGJ4Ybh4yZdLwBRNvOjZpZa
         AIu34T/0L9gAw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vincent Guittot <vincent.guittot@linaro.org>,
        David Chen <david.chen@nutanix.com>,
        Zhang Qiao <zhangqiao22@huawei.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>, mingo@redhat.com,
        juri.lelli@redhat.com
Subject: [PATCH AUTOSEL 5.18 18/53] sched/fair: fix case with reduced capacity CPU
Date:   Sun,  7 Aug 2022 21:33:13 -0400
Message-Id: <20220808013350.314757-18-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013350.314757-1-sashal@kernel.org>
References: <20220808013350.314757-1-sashal@kernel.org>
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
index ef2d8690fe18..46f6674a0979 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -7628,8 +7628,8 @@ enum group_type {
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
@@ -8712,6 +8712,19 @@ sched_asym(struct lb_env *env, struct sd_lb_stats *sds,  struct sg_lb_stats *sgs
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
@@ -8734,8 +8747,9 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 
 	for_each_cpu_and(i, sched_group_span(group), env->cpus) {
 		struct rq *rq = cpu_rq(i);
+		unsigned long load = cpu_load(rq);
 
-		sgs->group_load += cpu_load(rq);
+		sgs->group_load += load;
 		sgs->group_util += cpu_util_cfs(i);
 		sgs->group_runnable += cpu_runnable(rq);
 		sgs->sum_h_nr_running += rq->cfs.h_nr_running;
@@ -8765,11 +8779,17 @@ static inline void update_sg_lb_stats(struct lb_env *env,
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
 
@@ -8822,7 +8842,8 @@ static bool update_sd_pick_busiest(struct lb_env *env,
 	 * CPUs in the group should either be possible to resolve
 	 * internally or be covered by avg_load imbalance (eventually).
 	 */
-	if (sgs->group_type == group_misfit_task &&
+	if ((env->sd->flags & SD_ASYM_CPUCAPACITY) &&
+	    (sgs->group_type == group_misfit_task) &&
 	    (!capacity_greater(capacity_of(env->dst_cpu), sg->sgc->max_capacity) ||
 	     sds->local_stat.group_type != group_has_spare))
 		return false;
@@ -9443,9 +9464,18 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
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

