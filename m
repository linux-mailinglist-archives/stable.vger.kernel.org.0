Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA453C51B7
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245006AbhGLHm7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:42:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:46040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347695AbhGLHkB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:40:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D3C16145E;
        Mon, 12 Jul 2021 07:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075351;
        bh=yaW7+70CuaDLoBk5O5YDDWAkIkBx39uUB+sEvBYbA7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xgSIlOKD9jRV16S91AzLkVadALoDjei9MNNoKN7bi5p9i7ubnlq8Ct6KcK7c+ZOPN
         BaKj68OE+Z5Xez49kkp4Rz+pSFER3ZSINdTJkZWLLPlelQ33Wufwry+bMA0SR1ruPk
         HKr7uRR3pIFB96N6qv4V0CeOC9WIgHgGi9twmGpY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukasz Luba <lukasz.luba@arm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 190/800] sched/fair: Take thermal pressure into account while estimating energy
Date:   Mon, 12 Jul 2021 08:03:33 +0200
Message-Id: <20210712060939.759530282@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukasz Luba <lukasz.luba@arm.com>

[ Upstream commit 489f16459e0008c7a5c4c5af34bd80898aa82c2d ]

Energy Aware Scheduling (EAS) needs to be able to predict the frequency
requests made by the SchedUtil governor to properly estimate energy used
in the future. It has to take into account CPUs utilization and forecast
Performance Domain (PD) frequency. There is a corner case when the max
allowed frequency might be reduced due to thermal. SchedUtil is aware of
that reduced frequency, so it should be taken into account also in EAS
estimations.

SchedUtil, as a CPUFreq governor, knows the maximum allowed frequency of
a CPU, thanks to cpufreq_driver_resolve_freq() and internal clamping
to 'policy::max'. SchedUtil is responsible to respect that upper limit
while setting the frequency through CPUFreq drivers. This effective
frequency is stored internally in 'sugov_policy::next_freq' and EAS has
to predict that value.

In the existing code the raw value of arch_scale_cpu_capacity() is used
for clamping the returned CPU utilization from effective_cpu_util().
This patch fixes issue with too big single CPU utilization, by introducing
clamping to the allowed CPU capacity. The allowed CPU capacity is a CPU
capacity reduced by thermal pressure raw value.

Thanks to knowledge about allowed CPU capacity, we don't get too big value
for a single CPU utilization, which is then added to the util sum. The
util sum is used as a source of information for estimating whole PD energy.
To avoid wrong energy estimation in EAS (due to capped frequency), make
sure that the calculation of util sum is aware of allowed CPU capacity.

This thermal pressure might be visible in scenarios where the CPUs are not
heavily loaded, but some other component (like GPU) drastically reduced
available power budget and increased the SoC temperature. Thus, we still
use EAS for task placement and CPUs are not over-utilized.

Signed-off-by: Lukasz Luba <lukasz.luba@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Link: https://lore.kernel.org/r/20210614191128.22735-1-lukasz.luba@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 190ae8004a22..e807b743353d 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6620,8 +6620,11 @@ compute_energy(struct task_struct *p, int dst_cpu, struct perf_domain *pd)
 	struct cpumask *pd_mask = perf_domain_span(pd);
 	unsigned long cpu_cap = arch_scale_cpu_capacity(cpumask_first(pd_mask));
 	unsigned long max_util = 0, sum_util = 0;
+	unsigned long _cpu_cap = cpu_cap;
 	int cpu;
 
+	_cpu_cap -= arch_scale_thermal_pressure(cpumask_first(pd_mask));
+
 	/*
 	 * The capacity state of CPUs of the current rd can be driven by CPUs
 	 * of another rd if they belong to the same pd. So, account for the
@@ -6657,8 +6660,10 @@ compute_energy(struct task_struct *p, int dst_cpu, struct perf_domain *pd)
 		 * is already enough to scale the EM reported power
 		 * consumption at the (eventually clamped) cpu_capacity.
 		 */
-		sum_util += effective_cpu_util(cpu, util_running, cpu_cap,
-					       ENERGY_UTIL, NULL);
+		cpu_util = effective_cpu_util(cpu, util_running, cpu_cap,
+					      ENERGY_UTIL, NULL);
+
+		sum_util += min(cpu_util, _cpu_cap);
 
 		/*
 		 * Performance domain frequency: utilization clamping
@@ -6669,7 +6674,7 @@ compute_energy(struct task_struct *p, int dst_cpu, struct perf_domain *pd)
 		 */
 		cpu_util = effective_cpu_util(cpu, util_freq, cpu_cap,
 					      FREQUENCY_UTIL, tsk);
-		max_util = max(max_util, cpu_util);
+		max_util = max(max_util, min(cpu_util, _cpu_cap));
 	}
 
 	return em_cpu_energy(pd->em_pd, max_util, sum_util);
-- 
2.30.2



