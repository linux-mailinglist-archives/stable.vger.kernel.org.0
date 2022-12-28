Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32709657A8F
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232999AbiL1PNH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:13:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233017AbiL1PMm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:12:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C0AB13F0D
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:12:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C255461551
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:12:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6CA1C433F0;
        Wed, 28 Dec 2022 15:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240335;
        bh=k9LLY1pJ1U5vUDf/AvM+SOtZqFGEm3mmF6Nmg3tXhgw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r+ulSW95K6gbBP8oXh1Y9FLSYdXxOgdzY2fSa27DbGQV6kOTfNEgXqmcHl/U6/PNN
         DiEO9y2/J17sNQM/mIFGNti2ZudPak2zlE6rfaOBeFsSjJJcqGINaHz6jnoXvYlAza
         IBCRgWqBxwmnB5hC3KPPfqrw4GUNFh9Sgj78ue1c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Qais Yousef <qais.yousef@arm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0110/1146] sched/uclamp: Make asym_fits_capacity() use util_fits_cpu()
Date:   Wed, 28 Dec 2022 15:27:29 +0100
Message-Id: <20221228144333.141366434@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Qais Yousef <qais.yousef@arm.com>

[ Upstream commit a2e7f03ed28fce26c78b985f87913b6ce3accf9d ]

Use the new util_fits_cpu() to ensure migration margin and capacity
pressure are taken into account correctly when uclamp is being used
otherwise we will fail to consider CPUs as fitting in scenarios where
they should.

s/asym_fits_capacity/asym_fits_cpu/ to better reflect what it does now.

Fixes: b4c9c9f15649 ("sched/fair: Prefer prev cpu in asymmetric wakeup path")
Signed-off-by: Qais Yousef <qais.yousef@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20220804143609.515789-6-qais.yousef@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c877bbfe5deb..cabbdac97eaa 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6807,10 +6807,13 @@ select_idle_capacity(struct task_struct *p, struct sched_domain *sd, int target)
 	return best_cpu;
 }
 
-static inline bool asym_fits_capacity(unsigned long task_util, int cpu)
+static inline bool asym_fits_cpu(unsigned long util,
+				 unsigned long util_min,
+				 unsigned long util_max,
+				 int cpu)
 {
 	if (sched_asym_cpucap_active())
-		return fits_capacity(task_util, capacity_of(cpu));
+		return util_fits_cpu(util, util_min, util_max, cpu);
 
 	return true;
 }
@@ -6822,7 +6825,7 @@ static int select_idle_sibling(struct task_struct *p, int prev, int target)
 {
 	bool has_idle_core = false;
 	struct sched_domain *sd;
-	unsigned long task_util;
+	unsigned long task_util, util_min, util_max;
 	int i, recent_used_cpu;
 
 	/*
@@ -6831,7 +6834,9 @@ static int select_idle_sibling(struct task_struct *p, int prev, int target)
 	 */
 	if (sched_asym_cpucap_active()) {
 		sync_entity_load_avg(&p->se);
-		task_util = uclamp_task_util(p);
+		task_util = task_util_est(p);
+		util_min = uclamp_eff_value(p, UCLAMP_MIN);
+		util_max = uclamp_eff_value(p, UCLAMP_MAX);
 	}
 
 	/*
@@ -6840,7 +6845,7 @@ static int select_idle_sibling(struct task_struct *p, int prev, int target)
 	lockdep_assert_irqs_disabled();
 
 	if ((available_idle_cpu(target) || sched_idle_cpu(target)) &&
-	    asym_fits_capacity(task_util, target))
+	    asym_fits_cpu(task_util, util_min, util_max, target))
 		return target;
 
 	/*
@@ -6848,7 +6853,7 @@ static int select_idle_sibling(struct task_struct *p, int prev, int target)
 	 */
 	if (prev != target && cpus_share_cache(prev, target) &&
 	    (available_idle_cpu(prev) || sched_idle_cpu(prev)) &&
-	    asym_fits_capacity(task_util, prev))
+	    asym_fits_cpu(task_util, util_min, util_max, prev))
 		return prev;
 
 	/*
@@ -6863,7 +6868,7 @@ static int select_idle_sibling(struct task_struct *p, int prev, int target)
 	    in_task() &&
 	    prev == smp_processor_id() &&
 	    this_rq()->nr_running <= 1 &&
-	    asym_fits_capacity(task_util, prev)) {
+	    asym_fits_cpu(task_util, util_min, util_max, prev)) {
 		return prev;
 	}
 
@@ -6875,7 +6880,7 @@ static int select_idle_sibling(struct task_struct *p, int prev, int target)
 	    cpus_share_cache(recent_used_cpu, target) &&
 	    (available_idle_cpu(recent_used_cpu) || sched_idle_cpu(recent_used_cpu)) &&
 	    cpumask_test_cpu(p->recent_used_cpu, p->cpus_ptr) &&
-	    asym_fits_capacity(task_util, recent_used_cpu)) {
+	    asym_fits_cpu(task_util, util_min, util_max, recent_used_cpu)) {
 		return recent_used_cpu;
 	}
 
-- 
2.35.1



