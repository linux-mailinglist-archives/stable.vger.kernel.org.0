Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA4AD6810A4
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:05:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237054AbjA3OFY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:05:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237059AbjA3OFV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:05:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EC6C1F5E6
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:05:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C4669B81132
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:05:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 209E4C433EF;
        Mon, 30 Jan 2023 14:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087517;
        bh=U6uvrp33YWiHXyyne+1WMFhq5/IADpvUTMZrmfymyro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IoF061Z74XFMzgG+cFICRDcq+iNyE4YYkpiriikVGQmiUoT8LjvnonyfOJLlNC5Uh
         Dcj4g402u0pSePh/Gp0Sah0TooJFOdnyFYY7W2Q5IUV7afcfD/6QgN3WYSstZ7NrQ0
         s/9HpoFWQCyZRRkBMf1IiyKh+n93wUNEKoRPrw0o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, kernel test robot <lkp@intel.com>,
        Dan Carpenter <error27@gmail.com>,
        "Qais Yousef (Google)" <qyousef@layalina.io>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 205/313] sched/uclamp: Fix a uninitialized variable warnings
Date:   Mon, 30 Jan 2023 14:50:40 +0100
Message-Id: <20230130134346.251654203@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
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

From: Qais Yousef <qyousef@layalina.io>

[ Upstream commit e26fd28db82899be71b4b949527373d0a6be1e65 ]

Addresses the following warnings:

> config: riscv-randconfig-m031-20221111
> compiler: riscv64-linux-gcc (GCC) 12.1.0
>
> smatch warnings:
> kernel/sched/fair.c:7263 find_energy_efficient_cpu() error: uninitialized symbol 'util_min'.
> kernel/sched/fair.c:7263 find_energy_efficient_cpu() error: uninitialized symbol 'util_max'.

Fixes: 244226035a1f ("sched/uclamp: Fix fits_capacity() check in feec()")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Qais Yousef (Google) <qyousef@layalina.io>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Link: https://lore.kernel.org/r/20230112122708.330667-2-qyousef@layalina.io
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 35 ++++++++++++++++-------------------
 1 file changed, 16 insertions(+), 19 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index bb04ca795fc3..2c3d0d49c80e 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -7213,10 +7213,10 @@ static int find_energy_efficient_cpu(struct task_struct *p, int prev_cpu)
 	eenv_task_busy_time(&eenv, p, prev_cpu);
 
 	for (; pd; pd = pd->next) {
+		unsigned long util_min = p_util_min, util_max = p_util_max;
 		unsigned long cpu_cap, cpu_thermal_cap, util;
 		unsigned long cur_delta, max_spare_cap = 0;
 		unsigned long rq_util_min, rq_util_max;
-		unsigned long util_min, util_max;
 		unsigned long prev_spare_cap = 0;
 		int max_spare_cap_cpu = -1;
 		unsigned long base_energy;
@@ -7235,6 +7235,8 @@ static int find_energy_efficient_cpu(struct task_struct *p, int prev_cpu)
 		eenv.pd_cap = 0;
 
 		for_each_cpu(cpu, cpus) {
+			struct rq *rq = cpu_rq(cpu);
+
 			eenv.pd_cap += cpu_thermal_cap;
 
 			if (!cpumask_test_cpu(cpu, sched_domain_span(sd)))
@@ -7253,24 +7255,19 @@ static int find_energy_efficient_cpu(struct task_struct *p, int prev_cpu)
 			 * much capacity we can get out of the CPU; this is
 			 * aligned with sched_cpu_util().
 			 */
-			if (uclamp_is_used()) {
-				if (uclamp_rq_is_idle(cpu_rq(cpu))) {
-					util_min = p_util_min;
-					util_max = p_util_max;
-				} else {
-					/*
-					 * Open code uclamp_rq_util_with() except for
-					 * the clamp() part. Ie: apply max aggregation
-					 * only. util_fits_cpu() logic requires to
-					 * operate on non clamped util but must use the
-					 * max-aggregated uclamp_{min, max}.
-					 */
-					rq_util_min = uclamp_rq_get(cpu_rq(cpu), UCLAMP_MIN);
-					rq_util_max = uclamp_rq_get(cpu_rq(cpu), UCLAMP_MAX);
-
-					util_min = max(rq_util_min, p_util_min);
-					util_max = max(rq_util_max, p_util_max);
-				}
+			if (uclamp_is_used() && !uclamp_rq_is_idle(rq)) {
+				/*
+				 * Open code uclamp_rq_util_with() except for
+				 * the clamp() part. Ie: apply max aggregation
+				 * only. util_fits_cpu() logic requires to
+				 * operate on non clamped util but must use the
+				 * max-aggregated uclamp_{min, max}.
+				 */
+				rq_util_min = uclamp_rq_get(rq, UCLAMP_MIN);
+				rq_util_max = uclamp_rq_get(rq, UCLAMP_MAX);
+
+				util_min = max(rq_util_min, p_util_min);
+				util_max = max(rq_util_max, p_util_max);
 			}
 			if (!util_fits_cpu(util, util_min, util_max, cpu))
 				continue;
-- 
2.39.0



