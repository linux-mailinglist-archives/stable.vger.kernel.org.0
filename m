Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7530E657851
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:49:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232958AbiL1OtS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:49:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232935AbiL1OtR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:49:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01C2C3AB
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:49:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B0ACFB8171C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:49:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 297AAC433EF;
        Wed, 28 Dec 2022 14:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672238953;
        bh=51SR3cgmQ9NrNe9rZ1Im14jN1BWzg+BKcbDbE734HZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N4PGvIkO7EyUWO33hjKS+Gkk2NKd89vFlYAh5wLuoqBz7u+mXeRh1DJCBf7EavT2o
         lFlDhnReDkV527TJjYLs2pr8Z/9sXZjCTjAisRe0uQ307Jw9blakWFMYKLtXEascTS
         9Q4wXklnXflwCXGqZAU/5677l4E56mKBqMFnHiRQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 072/731] sched/core: Introduce sched_asym_cpucap_active()
Date:   Wed, 28 Dec 2022 15:32:59 +0100
Message-Id: <20221228144258.637952426@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dietmar Eggemann <dietmar.eggemann@arm.com>

[ Upstream commit 740cf8a760b73e8375bfb4bedcbe9746183350f9 ]

Create an inline helper for conditional code to be only executed on
asymmetric CPU capacity systems. This makes these (currently ~10 and
future) conditions a lot more readable.

Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20220729111305.1275158-2-dietmar.eggemann@arm.com
Stable-dep-of: a2e7f03ed28f ("sched/uclamp: Make asym_fits_capacity() use util_fits_cpu()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/cpudeadline.c | 2 +-
 kernel/sched/deadline.c    | 4 ++--
 kernel/sched/fair.c        | 8 ++++----
 kernel/sched/rt.c          | 4 ++--
 kernel/sched/sched.h       | 5 +++++
 5 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/kernel/sched/cpudeadline.c b/kernel/sched/cpudeadline.c
index ceb03d76c0cc..221ca1050573 100644
--- a/kernel/sched/cpudeadline.c
+++ b/kernel/sched/cpudeadline.c
@@ -124,7 +124,7 @@ int cpudl_find(struct cpudl *cp, struct task_struct *p,
 		unsigned long cap, max_cap = 0;
 		int cpu, max_cpu = -1;
 
-		if (!static_branch_unlikely(&sched_asym_cpucapacity))
+		if (!sched_asym_cpucap_active())
 			return 1;
 
 		/* Ensure the capacity of the CPUs fits the task. */
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 147b757d162b..2a2f32eaffcc 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -112,7 +112,7 @@ static inline unsigned long __dl_bw_capacity(int i)
  */
 static inline unsigned long dl_bw_capacity(int i)
 {
-	if (!static_branch_unlikely(&sched_asym_cpucapacity) &&
+	if (!sched_asym_cpucap_active() &&
 	    capacity_orig_of(i) == SCHED_CAPACITY_SCALE) {
 		return dl_bw_cpus(i) << SCHED_CAPACITY_SHIFT;
 	} else {
@@ -1703,7 +1703,7 @@ select_task_rq_dl(struct task_struct *p, int cpu, int flags)
 	 * Take the capacity of the CPU into account to
 	 * ensure it fits the requirement of the task.
 	 */
-	if (static_branch_unlikely(&sched_asym_cpucapacity))
+	if (sched_asym_cpucap_active())
 		select_rq |= !dl_task_fits_capacity(p, cpu);
 
 	if (select_rq) {
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index d706c1a8453a..619fc7bd65e2 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4253,7 +4253,7 @@ static inline int task_fits_cpu(struct task_struct *p, int cpu)
 
 static inline void update_misfit_status(struct task_struct *p, struct rq *rq)
 {
-	if (!static_branch_unlikely(&sched_asym_cpucapacity))
+	if (!sched_asym_cpucap_active())
 		return;
 
 	if (!p || p->nr_cpus_allowed == 1) {
@@ -6528,7 +6528,7 @@ select_idle_capacity(struct task_struct *p, struct sched_domain *sd, int target)
 
 static inline bool asym_fits_capacity(unsigned long task_util, int cpu)
 {
-	if (static_branch_unlikely(&sched_asym_cpucapacity))
+	if (sched_asym_cpucap_active())
 		return fits_capacity(task_util, capacity_of(cpu));
 
 	return true;
@@ -6548,7 +6548,7 @@ static int select_idle_sibling(struct task_struct *p, int prev, int target)
 	 * On asymmetric system, update task utilization because we will check
 	 * that the task fits with cpu's capacity.
 	 */
-	if (static_branch_unlikely(&sched_asym_cpucapacity)) {
+	if (sched_asym_cpucap_active()) {
 		sync_entity_load_avg(&p->se);
 		task_util = uclamp_task_util(p);
 	}
@@ -6602,7 +6602,7 @@ static int select_idle_sibling(struct task_struct *p, int prev, int target)
 	 * For asymmetric CPU capacity systems, our domain of interest is
 	 * sd_asym_cpucapacity rather than sd_llc.
 	 */
-	if (static_branch_unlikely(&sched_asym_cpucapacity)) {
+	if (sched_asym_cpucap_active()) {
 		sd = rcu_dereference(per_cpu(sd_asym_cpucapacity, target));
 		/*
 		 * On an asymmetric CPU capacity system where an exclusive
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index f75dcd3537b8..add67f811e00 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -473,7 +473,7 @@ static inline bool rt_task_fits_capacity(struct task_struct *p, int cpu)
 	unsigned int cpu_cap;
 
 	/* Only heterogeneous systems can benefit from this check */
-	if (!static_branch_unlikely(&sched_asym_cpucapacity))
+	if (!sched_asym_cpucap_active())
 		return true;
 
 	min_cap = uclamp_eff_value(p, UCLAMP_MIN);
@@ -1736,7 +1736,7 @@ static int find_lowest_rq(struct task_struct *task)
 	 * If we're on asym system ensure we consider the different capacities
 	 * of the CPUs when searching for the lowest_mask.
 	 */
-	if (static_branch_unlikely(&sched_asym_cpucapacity)) {
+	if (sched_asym_cpucap_active()) {
 
 		ret = cpupri_find_fitness(&task_rq(task)->rd->cpupri,
 					  task, lowest_mask,
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 4a98bb9fd881..fffb45bdddcc 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1788,6 +1788,11 @@ DECLARE_PER_CPU(struct sched_domain __rcu *, sd_asym_packing);
 DECLARE_PER_CPU(struct sched_domain __rcu *, sd_asym_cpucapacity);
 extern struct static_key_false sched_asym_cpucapacity;
 
+static __always_inline bool sched_asym_cpucap_active(void)
+{
+	return static_branch_unlikely(&sched_asym_cpucapacity);
+}
+
 struct sched_group_capacity {
 	atomic_t		ref;
 	/*
-- 
2.35.1



