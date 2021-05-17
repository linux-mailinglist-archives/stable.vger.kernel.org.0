Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30B2A383708
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243719AbhEQPi4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:38:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:40234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244200AbhEQPgz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:36:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E305A61938;
        Mon, 17 May 2021 14:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262411;
        bh=QdJyTKmatMGFNKJuuwIabCfDipLP/aY6gwPXk8PKwQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NLMmG7E7vVkdWUqwRYb2s6i7UNk16Nk+OYNo40crMcBZ9Sks8ObAwQ4GRt86YE5f2
         zKeaL6+q/rx3z24AYWOV7nBvXjMS0dDImODKyE9zWj5AEVAudwKUtXREsnicMoB0iY
         xWRJufRaX7qcgxL2T9ZHZ4RhfVW9BMZm7h1i2vLs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Odin Ugedal <odin@uged.al>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 182/289] sched/fair: Fix unfairness caused by missing load decay
Date:   Mon, 17 May 2021 16:01:47 +0200
Message-Id: <20210517140311.236947899@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Odin Ugedal <odin@uged.al>

[ Upstream commit 0258bdfaff5bd13c4d2383150b7097aecd6b6d82 ]

This fixes an issue where old load on a cfs_rq is not properly decayed,
resulting in strange behavior where fairness can decrease drastically.
Real workloads with equally weighted control groups have ended up
getting a respective 99% and 1%(!!) of cpu time.

When an idle task is attached to a cfs_rq by attaching a pid to a cgroup,
the old load of the task is attached to the new cfs_rq and sched_entity by
attach_entity_cfs_rq. If the task is then moved to another cpu (and
therefore cfs_rq) before being enqueued/woken up, the load will be moved
to cfs_rq->removed from the sched_entity. Such a move will happen when
enforcing a cpuset on the task (eg. via a cgroup) that force it to move.

The load will however not be removed from the task_group itself, making
it look like there is a constant load on that cfs_rq. This causes the
vruntime of tasks on other sibling cfs_rq's to increase faster than they
are supposed to; causing severe fairness issues. If no other task is
started on the given cfs_rq, and due to the cpuset it would not happen,
this load would never be properly unloaded. With this patch the load
will be properly removed inside update_blocked_averages. This also
applies to tasks moved to the fair scheduling class and moved to another
cpu, and this path will also fix that. For fork, the entity is queued
right away, so this problem does not affect that.

This applies to cases where the new process is the first in the cfs_rq,
issue introduced 3d30544f0212 ("sched/fair: Apply more PELT fixes"), and
when there has previously been load on the cgroup but the cgroup was
removed from the leaflist due to having null PELT load, indroduced
in 039ae8bcf7a5 ("sched/fair: Fix O(nr_cgroups) in the load balancing
path").

For a simple cgroup hierarchy (as seen below) with two equally weighted
groups, that in theory should get 50/50 of cpu time each, it often leads
to a load of 60/40 or 70/30.

parent/
  cg-1/
    cpu.weight: 100
    cpuset.cpus: 1
  cg-2/
    cpu.weight: 100
    cpuset.cpus: 1

If the hierarchy is deeper (as seen below), while keeping cg-1 and cg-2
equally weighted, they should still get a 50/50 balance of cpu time.
This however sometimes results in a balance of 10/90 or 1/99(!!) between
the task groups.

$ ps u -C stress
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root       18568  1.1  0.0   3684   100 pts/12   R+   13:36   0:00 stress --cpu 1
root       18580 99.3  0.0   3684   100 pts/12   R+   13:36   0:09 stress --cpu 1

parent/
  cg-1/
    cpu.weight: 100
    sub-group/
      cpu.weight: 1
      cpuset.cpus: 1
  cg-2/
    cpu.weight: 100
    sub-group/
      cpu.weight: 10000
      cpuset.cpus: 1

This can be reproduced by attaching an idle process to a cgroup and
moving it to a given cpuset before it wakes up. The issue is evident in
many (if not most) container runtimes, and has been reproduced
with both crun and runc (and therefore docker and all its "derivatives"),
and with both cgroup v1 and v2.

Fixes: 3d30544f0212 ("sched/fair: Apply more PELT fixes")
Fixes: 039ae8bcf7a5 ("sched/fair: Fix O(nr_cgroups) in the load balancing path")
Signed-off-by: Odin Ugedal <odin@uged.al>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Link: https://lkml.kernel.org/r/20210501141950.23622-2-odin@uged.al
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c80d1a039d19..1ad0e52487f6 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -10840,16 +10840,22 @@ static void propagate_entity_cfs_rq(struct sched_entity *se)
 {
 	struct cfs_rq *cfs_rq;
 
+	list_add_leaf_cfs_rq(cfs_rq_of(se));
+
 	/* Start to propagate at parent */
 	se = se->parent;
 
 	for_each_sched_entity(se) {
 		cfs_rq = cfs_rq_of(se);
 
-		if (cfs_rq_throttled(cfs_rq))
-			break;
+		if (!cfs_rq_throttled(cfs_rq)){
+			update_load_avg(cfs_rq, se, UPDATE_TG);
+			list_add_leaf_cfs_rq(cfs_rq);
+			continue;
+		}
 
-		update_load_avg(cfs_rq, se, UPDATE_TG);
+		if (list_add_leaf_cfs_rq(cfs_rq))
+			break;
 	}
 }
 #else
-- 
2.30.2



