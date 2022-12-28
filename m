Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC8A6579EB
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:06:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233550AbiL1PGC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:06:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233555AbiL1PGB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:06:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17013B871
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:06:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0BA7B816D9
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:05:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AB6DC433D2;
        Wed, 28 Dec 2022 15:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239957;
        bh=vfGrz+FCW62brEmNCAg84GXIKRi4XfavBgspuACcLFY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nn2ZyKibA8BENu8R2oyDcCyxM2stGxTA7Dv2pF3JoIAJda/GNgoJ+DN988gRmxfSr
         JkKD6mqOedVswfjcN/U5dAgr0IeZevgqH6CRECReLF6oeQvbk0FV/lDZMOO+jEf8Bj
         53OAphcc/iLrjQPPnxHDnFzq9Mw0fSgun7OuxCzU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0098/1073] sched/core: Introduce sched_asym_cpucap_active()
Date:   Wed, 28 Dec 2022 15:28:06 +0100
Message-Id: <20221228144330.711649007@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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
index 02d970a879ed..57c92d751bcd 100644
--- a/kernel/sched/cpudeadline.c
+++ b/kernel/sched/cpudeadline.c
@@ -123,7 +123,7 @@ int cpudl_find(struct cpudl *cp, struct task_struct *p,
 		unsigned long cap, max_cap = 0;
 		int cpu, max_cpu = -1;
 
-		if (!static_branch_unlikely(&sched_asym_cpucapacity))
+		if (!sched_asym_cpucap_active())
 			return 1;
 
 		/* Ensure the capacity of the CPUs fits the task. */
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 0ab79d819a0d..8bebc36a1b71 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -144,7 +144,7 @@ static inline unsigned long __dl_bw_capacity(int i)
  */
 static inline unsigned long dl_bw_capacity(int i)
 {
-	if (!static_branch_unlikely(&sched_asym_cpucapacity) &&
+	if (!sched_asym_cpucap_active() &&
 	    capacity_orig_of(i) == SCHED_CAPACITY_SCALE) {
 		return dl_bw_cpus(i) << SCHED_CAPACITY_SHIFT;
 	} else {
@@ -1849,7 +1849,7 @@ select_task_rq_dl(struct task_struct *p, int cpu, int flags)
 	 * Take the capacity of the CPU into account to
 	 * ensure it fits the requirement of the task.
 	 */
-	if (static_branch_unlikely(&sched_asym_cpucapacity))
+	if (sched_asym_cpucap_active())
 		select_rq |= !dl_task_fits_capacity(p, cpu);
 
 	if (select_rq) {
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 892ea83864a7..1fe3f3b96251 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4387,7 +4387,7 @@ static inline int task_fits_cpu(struct task_struct *p, int cpu)
 
 static inline void update_misfit_status(struct task_struct *p, struct rq *rq)
 {
-	if (!static_branch_unlikely(&sched_asym_cpucapacity))
+	if (!sched_asym_cpucap_active())
 		return;
 
 	if (!p || p->nr_cpus_allowed == 1) {
@@ -6633,7 +6633,7 @@ select_idle_capacity(struct task_struct *p, struct sched_domain *sd, int target)
 
 static inline bool asym_fits_capacity(unsigned long task_util, int cpu)
 {
-	if (static_branch_unlikely(&sched_asym_cpucapacity))
+	if (sched_asym_cpucap_active())
 		return fits_capacity(task_util, capacity_of(cpu));
 
 	return true;
@@ -6653,7 +6653,7 @@ static int select_idle_sibling(struct task_struct *p, int prev, int target)
 	 * On asymmetric system, update task utilization because we will check
 	 * that the task fits with cpu's capacity.
 	 */
-	if (static_branch_unlikely(&sched_asym_cpucapacity)) {
+	if (sched_asym_cpucap_active()) {
 		sync_entity_load_avg(&p->se);
 		task_util = uclamp_task_util(p);
 	}
@@ -6707,7 +6707,7 @@ static int select_idle_sibling(struct task_struct *p, int prev, int target)
 	 * For asymmetric CPU capacity systems, our domain of interest is
 	 * sd_asym_cpucapacity rather than sd_llc.
 	 */
-	if (static_branch_unlikely(&sched_asym_cpucapacity)) {
+	if (sched_asym_cpucap_active()) {
 		sd = rcu_dereference(per_cpu(sd_asym_cpucapacity, target));
 		/*
 		 * On an asymmetric CPU capacity system where an exclusive
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 55f39c8f4203..054b6711e961 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -509,7 +509,7 @@ static inline bool rt_task_fits_capacity(struct task_struct *p, int cpu)
 	unsigned int cpu_cap;
 
 	/* Only heterogeneous systems can benefit from this check */
-	if (!static_branch_unlikely(&sched_asym_cpucapacity))
+	if (!sched_asym_cpucap_active())
 		return true;
 
 	min_cap = uclamp_eff_value(p, UCLAMP_MIN);
@@ -1897,7 +1897,7 @@ static int find_lowest_rq(struct task_struct *task)
 	 * If we're on asym system ensure we consider the different capacities
 	 * of the CPUs when searching for the lowest_mask.
 	 */
-	if (static_branch_unlikely(&sched_asym_cpucapacity)) {
+	if (sched_asym_cpucap_active()) {
 
 		ret = cpupri_find_fitness(&task_rq(task)->rd->cpupri,
 					  task, lowest_mask,
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 0dfcd12e184a..2fcb7eb56c01 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1815,6 +1815,11 @@ DECLARE_PER_CPU(struct sched_domain __rcu *, sd_asym_packing);
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



