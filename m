Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5B7F3C52B4
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344972AbhGLHss (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:48:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:53604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346776AbhGLHql (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:46:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CEE5461166;
        Mon, 12 Jul 2021 07:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075724;
        bh=R3ZpydeS6PxatrGUmM2BtuVbxAACD8oFk5ZMkqCNFcQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rB57wUOaE5ERM0u/NdYPkql/6UhkyUUx2q2UVImAQWx9ZiuK2aS5QpYAgFRdJbGa0
         NDk3p1l8OEqfmGBMgz7mx4BxtK0Dw+6Xn9HhYkV1nkppCArNp90rxJ3H8zcE8uF0xV
         2MVso5aVHg8rLSCLadoT2kXLPVhhzaSSNGrA2YaA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Will Deacon <will@kernel.org>,
        Valentin Schneider <valentin.schneider@arm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 295/800] sched: Dont defer CPU pick to migration_cpu_stop()
Date:   Mon, 12 Jul 2021 08:05:18 +0200
Message-Id: <20210712060956.492699043@linuxfoundation.org>
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

From: Valentin Schneider <valentin.schneider@arm.com>

[ Upstream commit 475ea6c60279e9f2ddf7e4cf2648cd8ae0608361 ]

Will reported that the 'XXX __migrate_task() can fail' in migration_cpu_stop()
can happen, and it *is* sort of a big deal. Looking at it some more, one
will note there is a glaring hole in the deferred CPU selection:

  (w/ CONFIG_CPUSET=n, so that the affinity mask passed via taskset doesn't
  get AND'd with cpu_online_mask)

  $ taskset -pc 0-2 $PID
  # offline CPUs 3-4
  $ taskset -pc 3-5 $PID
    `\
      $PID may stay on 0-2 due to the cpumask_any_distribute() picking an
      offline CPU and __migrate_task() refusing to do anything due to
      cpu_is_allowed().

set_cpus_allowed_ptr() goes to some length to pick a dest_cpu that matches
the right constraints vs affinity and the online/active state of the
CPUs. Reuse that instead of discarding it in the affine_move_task() case.

Fixes: 6d337eab041d ("sched: Fix migrate_disable() vs set_cpus_allowed_ptr()")
Reported-by: Will Deacon <will@kernel.org>
Signed-off-by: Valentin Schneider <valentin.schneider@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20210526205751.842360-2-valentin.schneider@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 94002cb551c4..6e0ebc0781d1 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1929,7 +1929,6 @@ static int migration_cpu_stop(void *data)
 	struct migration_arg *arg = data;
 	struct set_affinity_pending *pending = arg->pending;
 	struct task_struct *p = arg->task;
-	int dest_cpu = arg->dest_cpu;
 	struct rq *rq = this_rq();
 	bool complete = false;
 	struct rq_flags rf;
@@ -1967,19 +1966,15 @@ static int migration_cpu_stop(void *data)
 		if (pending) {
 			p->migration_pending = NULL;
 			complete = true;
-		}
 
-		if (dest_cpu < 0) {
 			if (cpumask_test_cpu(task_cpu(p), &p->cpus_mask))
 				goto out;
-
-			dest_cpu = cpumask_any_distribute(&p->cpus_mask);
 		}
 
 		if (task_on_rq_queued(p))
-			rq = __migrate_task(rq, &rf, p, dest_cpu);
+			rq = __migrate_task(rq, &rf, p, arg->dest_cpu);
 		else
-			p->wake_cpu = dest_cpu;
+			p->wake_cpu = arg->dest_cpu;
 
 		/*
 		 * XXX __migrate_task() can fail, at which point we might end
@@ -2262,7 +2257,7 @@ static int affine_move_task(struct rq *rq, struct task_struct *p, struct rq_flag
 			init_completion(&my_pending.done);
 			my_pending.arg = (struct migration_arg) {
 				.task = p,
-				.dest_cpu = -1,		/* any */
+				.dest_cpu = dest_cpu,
 				.pending = &my_pending,
 			};
 
@@ -2270,6 +2265,15 @@ static int affine_move_task(struct rq *rq, struct task_struct *p, struct rq_flag
 		} else {
 			pending = p->migration_pending;
 			refcount_inc(&pending->refs);
+			/*
+			 * Affinity has changed, but we've already installed a
+			 * pending. migration_cpu_stop() *must* see this, else
+			 * we risk a completion of the pending despite having a
+			 * task on a disallowed CPU.
+			 *
+			 * Serialized by p->pi_lock, so this is safe.
+			 */
+			pending->arg.dest_cpu = dest_cpu;
 		}
 	}
 	pending = p->migration_pending;
-- 
2.30.2



