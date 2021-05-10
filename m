Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D44D1378820
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238994AbhEJLUr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:20:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:46278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236738AbhEJLIl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:08:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 830AF61288;
        Mon, 10 May 2021 11:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644630;
        bh=KbovOLRRUE0WSNtuDpHWNJi8YIVsQfrApWzUylI6s9k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CcyWnUBJyuRcanT4wJtI24GuILgXiSrP8U/kog8YR2dF/MphhYkMXypL6Sv3zq69O
         t6rijVZISTjoAa3nCtLqmfixYCq43Z6q0SOryOTsJM5rHle82zNReIuPSaGjdq1Jvn
         8y0M06Sx1JkjgV58Vm+nXbjiANI+BkTf2jV4zmxQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Donnefort <vincent.donnefort@arm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Quentin Perret <qperret@google.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 161/384] sched/fair: Fix task utilization accountability in compute_energy()
Date:   Mon, 10 May 2021 12:19:10 +0200
Message-Id: <20210510102020.180588713@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Donnefort <vincent.donnefort@arm.com>

[ Upstream commit 0372e1cf70c28de6babcba38ef97b6ae3400b101 ]

find_energy_efficient_cpu() (feec()) computes for each perf_domain (pd) an
energy delta as follows:

  feec(task)
    for_each_pd
      base_energy = compute_energy(task, -1, pd)
        -> for_each_cpu(pd)
           -> cpu_util_next(cpu, task, -1)

      energy_delta = compute_energy(task, dst_cpu, pd)
        -> for_each_cpu(pd)
           -> cpu_util_next(cpu, task, dst_cpu)
      energy_delta -= base_energy

Then it picks the best CPU as being the one that minimizes energy_delta.

cpu_util_next() estimates the CPU utilization that would happen if the
task was placed on dst_cpu as follows:

  max(cpu_util + task_util, cpu_util_est + _task_util_est)

The task contribution to the energy delta can then be either:

  (1) _task_util_est, on a mostly idle CPU, where cpu_util is close to 0
      and _task_util_est > cpu_util.
  (2) task_util, on a mostly busy CPU, where cpu_util > _task_util_est.

  (cpu_util_est doesn't appear here. It is 0 when a CPU is idle and
   otherwise must be small enough so that feec() takes the CPU as a
   potential target for the task placement)

This is problematic for feec(), as cpu_util_next() might give an unfair
advantage to a CPU which is mostly busy (2) compared to one which is
mostly idle (1). _task_util_est being always bigger than task_util in
feec() (as the task is waking up), the task contribution to the energy
might look smaller on certain CPUs (2) and this breaks the energy
comparison.

This issue is, moreover, not sporadic. By starving idle CPUs, it keeps
their cpu_util < _task_util_est (1) while others will maintain cpu_util >
_task_util_est (2).

Fix this problem by always using max(task_util, _task_util_est) as a task
contribution to the energy (ENERGY_UTIL). The new estimated CPU
utilization for the energy would then be:

  max(cpu_util, cpu_util_est) + max(task_util, _task_util_est)

compute_energy() still needs to know which OPP would be selected if the
task would be migrated in the perf_domain (FREQUENCY_UTIL). Hence,
cpu_util_next() is still used to estimate the maximum util within the pd.

Signed-off-by: Vincent Donnefort <vincent.donnefort@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Quentin Perret <qperret@google.com>
Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Link: https://lkml.kernel.org/r/20210225083612.1113823-2-vincent.donnefort@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 794c2cb945f8..e3c2dcb1b015 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6518,8 +6518,24 @@ compute_energy(struct task_struct *p, int dst_cpu, struct perf_domain *pd)
 	 * its pd list and will not be accounted by compute_energy().
 	 */
 	for_each_cpu_and(cpu, pd_mask, cpu_online_mask) {
-		unsigned long cpu_util, util_cfs = cpu_util_next(cpu, p, dst_cpu);
-		struct task_struct *tsk = cpu == dst_cpu ? p : NULL;
+		unsigned long util_freq = cpu_util_next(cpu, p, dst_cpu);
+		unsigned long cpu_util, util_running = util_freq;
+		struct task_struct *tsk = NULL;
+
+		/*
+		 * When @p is placed on @cpu:
+		 *
+		 * util_running = max(cpu_util, cpu_util_est) +
+		 *		  max(task_util, _task_util_est)
+		 *
+		 * while cpu_util_next is: max(cpu_util + task_util,
+		 *			       cpu_util_est + _task_util_est)
+		 */
+		if (cpu == dst_cpu) {
+			tsk = p;
+			util_running =
+				cpu_util_next(cpu, p, -1) + task_util_est(p);
+		}
 
 		/*
 		 * Busy time computation: utilization clamping is not
@@ -6527,7 +6543,7 @@ compute_energy(struct task_struct *p, int dst_cpu, struct perf_domain *pd)
 		 * is already enough to scale the EM reported power
 		 * consumption at the (eventually clamped) cpu_capacity.
 		 */
-		sum_util += effective_cpu_util(cpu, util_cfs, cpu_cap,
+		sum_util += effective_cpu_util(cpu, util_running, cpu_cap,
 					       ENERGY_UTIL, NULL);
 
 		/*
@@ -6537,7 +6553,7 @@ compute_energy(struct task_struct *p, int dst_cpu, struct perf_domain *pd)
 		 * NOTE: in case RT tasks are running, by default the
 		 * FREQUENCY_UTIL's utilization can be max OPP.
 		 */
-		cpu_util = effective_cpu_util(cpu, util_cfs, cpu_cap,
+		cpu_util = effective_cpu_util(cpu, util_freq, cpu_cap,
 					      FREQUENCY_UTIL, tsk);
 		max_util = max(max_util, cpu_util);
 	}
-- 
2.30.2



