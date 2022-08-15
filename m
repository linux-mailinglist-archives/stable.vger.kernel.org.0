Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58EB9593DA2
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344484AbiHOTnR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:43:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344621AbiHOTlO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:41:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6969865566;
        Mon, 15 Aug 2022 11:47:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A6FC1611EC;
        Mon, 15 Aug 2022 18:47:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64C4CC433D7;
        Mon, 15 Aug 2022 18:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589237;
        bh=2SlUA2K4kh8vddRQQgvCpzFLKXrX5y1ZP1t2OfhpRwc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VMRD65oWpG7KfpGrZQ24PqlIzpBVe/JZzEqW26IDbGkOvtAbem4HLcnWoBJMJxuUv
         0JfmUqH5FL4H0EJYbOkUFCB2RV3KssdSYCY38tPvP/ytZBlwuv9wS2jUwPky6EojkG
         G0mUsLFWKIR5h6jaKtjRi3iE5HFPY4jeuD9eK36U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 655/779] sched/deadline: Merge dl_task_can_attach() and dl_cpu_busy()
Date:   Mon, 15 Aug 2022 20:04:59 +0200
Message-Id: <20220815180405.374160004@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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
index 012c037da58a..154506e4d1f5 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8760,8 +8760,11 @@ int task_can_attach(struct task_struct *p,
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
@@ -9045,8 +9048,10 @@ static void cpuset_cpu_active(void)
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
index ee673a205e22..147b757d162b 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -2864,41 +2864,6 @@ bool dl_param_changed(struct task_struct *p, const struct sched_attr *attr)
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
@@ -2920,7 +2885,7 @@ int dl_cpuset_cpumask_can_shrink(const struct cpumask *cur,
 	return ret;
 }
 
-bool dl_cpu_busy(unsigned int cpu)
+int dl_cpu_busy(int cpu, struct task_struct *p)
 {
 	unsigned long flags, cap;
 	struct dl_bw *dl_b;
@@ -2930,11 +2895,22 @@ bool dl_cpu_busy(unsigned int cpu)
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
index fe8be2f8a47d..2bbf1f006d63 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -348,9 +348,8 @@ extern void __setparam_dl(struct task_struct *p, const struct sched_attr *attr);
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



