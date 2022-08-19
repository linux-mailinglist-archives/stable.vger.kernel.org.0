Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A17359A27F
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353175AbiHSQhH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353593AbiHSQgc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:36:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8BE71230BC;
        Fri, 19 Aug 2022 09:07:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E4B7B82816;
        Fri, 19 Aug 2022 16:07:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 977C0C433C1;
        Fri, 19 Aug 2022 16:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925243;
        bh=1nK8ZEsp66fPcxrMcCwgO8x+4qYaTVJvobrwhjo0BWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fPV/2tkAWzjEurGYiN0koplzHF5hRqqTVwrg8WGf/o8eRLB3F6R/6AalOVJ6Q7X6P
         53ng6FNz+UhAi9AxW2KCDa13H/vb3Wiam7SRIzvOWwdoeAzgvTsUTaSKHNvKD+RXmu
         7RvcyTjHdEEY0sjXHiksltSk4rmfZz8KtPvOdHUU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 429/545] sched/deadline: Merge dl_task_can_attach() and dl_cpu_busy()
Date:   Fri, 19 Aug 2022 17:43:19 +0200
Message-Id: <20220819153848.601645403@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dietmar Eggemann <dietmar.eggemann@arm.com>

[ Upstream commit 772b6539fdda31462cc08368e78df60b31a58bab ]

Both functions are doing almost the same, that is checking if admission
control is still respected.

With exclusive cpusets, dl_task_can_attach() checks if the destination
cpuset (i.e. its root domain) has enough CPU capacity to accommodate the
task.
dl_cpu_busy() checks if there is enough CPU capacity in the cpuset in
case the CPU is hot-plugged out.

dl_task_can_attach() is used to check if a task can be admitted while
dl_cpu_busy() is used to check if a CPU can be hotplugged out.

Make dl_cpu_busy() able to deal with a task and use it instead of
dl_task_can_attach() in task_can_attach().

Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Juri Lelli <juri.lelli@redhat.com>
Link: https://lore.kernel.org/r/20220302183433.333029-4-dietmar.eggemann@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c     | 13 +++++++----
 kernel/sched/deadline.c | 52 +++++++++++------------------------------
 kernel/sched/sched.h    |  3 +--
 3 files changed, 24 insertions(+), 44 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index e437d946b27b..042efabf5378 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6605,8 +6605,11 @@ int task_can_attach(struct task_struct *p,
 	}
 
 	if (dl_task(p) && !cpumask_intersects(task_rq(p)->rd->span,
-					      cs_cpus_allowed))
-		ret = dl_task_can_attach(p, cs_cpus_allowed);
+					      cs_cpus_allowed)) {
+		int cpu = cpumask_any_and(cpu_active_mask, cs_cpus_allowed);
+
+		ret = dl_cpu_busy(cpu, p);
+	}
 
 out:
 	return ret;
@@ -6865,8 +6868,10 @@ static void cpuset_cpu_active(void)
 static int cpuset_cpu_inactive(unsigned int cpu)
 {
 	if (!cpuhp_tasks_frozen) {
-		if (dl_cpu_busy(cpu))
-			return -EBUSY;
+		int ret = dl_cpu_busy(cpu, NULL);
+
+		if (ret)
+			return ret;
 		cpuset_update_active_cpus();
 	} else {
 		num_cpus_frozen++;
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 933706106b98..aaf98771f935 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -2825,41 +2825,6 @@ bool dl_param_changed(struct task_struct *p, const struct sched_attr *attr)
 }
 
 #ifdef CONFIG_SMP
-int dl_task_can_attach(struct task_struct *p, const struct cpumask *cs_cpus_allowed)
-{
-	unsigned long flags, cap;
-	unsigned int dest_cpu;
-	struct dl_bw *dl_b;
-	bool overflow;
-	int ret;
-
-	dest_cpu = cpumask_any_and(cpu_active_mask, cs_cpus_allowed);
-
-	rcu_read_lock_sched();
-	dl_b = dl_bw_of(dest_cpu);
-	raw_spin_lock_irqsave(&dl_b->lock, flags);
-	cap = dl_bw_capacity(dest_cpu);
-	overflow = __dl_overflow(dl_b, cap, 0, p->dl.dl_bw);
-	if (overflow) {
-		ret = -EBUSY;
-	} else {
-		/*
-		 * We reserve space for this task in the destination
-		 * root_domain, as we can't fail after this point.
-		 * We will free resources in the source root_domain
-		 * later on (see set_cpus_allowed_dl()).
-		 */
-		int cpus = dl_bw_cpus(dest_cpu);
-
-		__dl_add(dl_b, p->dl.dl_bw, cpus);
-		ret = 0;
-	}
-	raw_spin_unlock_irqrestore(&dl_b->lock, flags);
-	rcu_read_unlock_sched();
-
-	return ret;
-}
-
 int dl_cpuset_cpumask_can_shrink(const struct cpumask *cur,
 				 const struct cpumask *trial)
 {
@@ -2881,7 +2846,7 @@ int dl_cpuset_cpumask_can_shrink(const struct cpumask *cur,
 	return ret;
 }
 
-bool dl_cpu_busy(unsigned int cpu)
+int dl_cpu_busy(int cpu, struct task_struct *p)
 {
 	unsigned long flags, cap;
 	struct dl_bw *dl_b;
@@ -2891,11 +2856,22 @@ bool dl_cpu_busy(unsigned int cpu)
 	dl_b = dl_bw_of(cpu);
 	raw_spin_lock_irqsave(&dl_b->lock, flags);
 	cap = dl_bw_capacity(cpu);
-	overflow = __dl_overflow(dl_b, cap, 0, 0);
+	overflow = __dl_overflow(dl_b, cap, 0, p ? p->dl.dl_bw : 0);
+
+	if (!overflow && p) {
+		/*
+		 * We reserve space for this task in the destination
+		 * root_domain, as we can't fail after this point.
+		 * We will free resources in the source root_domain
+		 * later on (see set_cpus_allowed_dl()).
+		 */
+		__dl_add(dl_b, p->dl.dl_bw, dl_bw_cpus(cpu));
+	}
+
 	raw_spin_unlock_irqrestore(&dl_b->lock, flags);
 	rcu_read_unlock_sched();
 
-	return overflow;
+	return overflow ? -EBUSY : 0;
 }
 #endif
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 8d39f5d99172..12c65628801c 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -347,9 +347,8 @@ extern void __setparam_dl(struct task_struct *p, const struct sched_attr *attr);
 extern void __getparam_dl(struct task_struct *p, struct sched_attr *attr);
 extern bool __checkparam_dl(const struct sched_attr *attr);
 extern bool dl_param_changed(struct task_struct *p, const struct sched_attr *attr);
-extern int  dl_task_can_attach(struct task_struct *p, const struct cpumask *cs_cpus_allowed);
 extern int  dl_cpuset_cpumask_can_shrink(const struct cpumask *cur, const struct cpumask *trial);
-extern bool dl_cpu_busy(unsigned int cpu);
+extern int  dl_cpu_busy(int cpu, struct task_struct *p);
 
 #ifdef CONFIG_CGROUP_SCHED
 
-- 
2.35.1



