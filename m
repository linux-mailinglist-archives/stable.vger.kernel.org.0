Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8477A371C45
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233469AbhECQvw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:51:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:32774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234552AbhECQu2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:50:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BBFBB61928;
        Mon,  3 May 2021 16:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060051;
        bh=X0ztbT66m6cLWU+n93r0NCVtDZUYpJmLSUJAMFrRu40=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CWh9dQ0ZW2Mma8TeCsSO5kc0uUw8cW0ZWuwSwYCTRNSTYJQ6Vy5roEo+8vlYNxdr7
         GaIAF6v7kDeCK37dAhZ7L4Wjm7zl7KDC6jnFK2quvJ5dGmymplVAn8YTr9Vtm/aXfE
         W+xQv9LCDztOEP4IFSH6Cc7tUviSfUrn1GC4MMjWZiuSYvSpSLKZXGn+qlV8tNp/Av
         Cm4TN8Xo8aCZnIoJ9EuvQ8WFlPhBQzJTKO+QoieUNzH9DmRXOEhu+fe8FqQoZZSiZR
         hs8ctT4xrDyw7Dvs/Admk/SMJVXmWMxbkH8VXeB1Hvx0Q2hBFTF9NzflPAACftYu0u
         us0dhkmCfihdg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lingutla Chandrasekhar <clingutla@codeaurora.org>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 46/57] sched/fair: Ignore percpu threads for imbalance pulls
Date:   Mon,  3 May 2021 12:39:30 -0400
Message-Id: <20210503163941.2853291-46-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163941.2853291-1-sashal@kernel.org>
References: <20210503163941.2853291-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lingutla Chandrasekhar <clingutla@codeaurora.org>

[ Upstream commit 9bcb959d05eeb564dfc9cac13a59843a4fb2edf2 ]

During load balance, LBF_SOME_PINNED will be set if any candidate task
cannot be detached due to CPU affinity constraints. This can result in
setting env->sd->parent->sgc->group_imbalance, which can lead to a group
being classified as group_imbalanced (rather than any of the other, lower
group_type) when balancing at a higher level.

In workloads involving a single task per CPU, LBF_SOME_PINNED can often be
set due to per-CPU kthreads being the only other runnable tasks on any
given rq. This results in changing the group classification during
load-balance at higher levels when in reality there is nothing that can be
done for this affinity constraint: per-CPU kthreads, as the name implies,
don't get to move around (modulo hotplug shenanigans).

It's not as clear for userspace tasks - a task could be in an N-CPU cpuset
with N-1 offline CPUs, making it an "accidental" per-CPU task rather than
an intended one. KTHREAD_IS_PER_CPU gives us an indisputable signal which
we can leverage here to not set LBF_SOME_PINNED.

Note that the aforementioned classification to group_imbalance (when
nothing can be done) is especially problematic on big.LITTLE systems, which
have a topology the likes of:

  DIE [          ]
  MC  [    ][    ]
       0  1  2  3
       L  L  B  B

  arch_scale_cpu_capacity(L) < arch_scale_cpu_capacity(B)

Here, setting LBF_SOME_PINNED due to a per-CPU kthread when balancing at MC
level on CPUs [0-1] will subsequently prevent CPUs [2-3] from classifying
the [0-1] group as group_misfit_task when balancing at DIE level. Thus, if
CPUs [0-1] are running CPU-bound (misfit) tasks, ill-timed per-CPU kthreads
can significantly delay the upgmigration of said misfit tasks. Systems
relying on ASYM_PACKING are likely to face similar issues.

Signed-off-by: Lingutla Chandrasekhar <clingutla@codeaurora.org>
[Use kthread_is_per_cpu() rather than p->nr_cpus_allowed]
[Reword changelog]
Signed-off-by: Valentin Schneider <valentin.schneider@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Link: https://lkml.kernel.org/r/20210407220628.3798191-2-valentin.schneider@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 611adca1e6d0..93ab546b6e16 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -7300,6 +7300,10 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
 	if (throttled_lb_pair(task_group(p), env->src_cpu, env->dst_cpu))
 		return 0;
 
+	/* Disregard pcpu kthreads; they are where they need to be. */
+	if ((p->flags & PF_KTHREAD) && kthread_is_per_cpu(p))
+		return 0;
+
 	if (!cpumask_test_cpu(env->dst_cpu, p->cpus_ptr)) {
 		int cpu;
 
-- 
2.30.2

