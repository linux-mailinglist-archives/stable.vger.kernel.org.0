Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7011F23C3
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 01:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730206AbgFHXQW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:16:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:37660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729612AbgFHXQU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:16:20 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A17E520775;
        Mon,  8 Jun 2020 23:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658180;
        bh=kx3TrV2JbUKa+5KdldsNkanjDhdA6+qB50fP9MVXPMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vOCgadq7YszEENxvdyYBClhq69kGPeAT9zfgo3j6B3voo/+C/MykClxAIcEARiARN
         f4RTcWLglraPJ2HrBBxPiLBbxz0oeZ7viggbzUCzPQHNSVPuGxG5QKPmcuoMhcdX1H
         WglQDm5eP43+PxeLSE2EEC9C4/kmuMGb1SfRNWwk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Phil Auld <pauld@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.6 205/606] sched/fair: Fix enqueue_task_fair() warning some more
Date:   Mon,  8 Jun 2020 19:05:30 -0400
Message-Id: <20200608231211.3363633-205-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Phil Auld <pauld@redhat.com>

[ Upstream commit b34cb07dde7c2346dec73d053ce926aeaa087303 ]

sched/fair: Fix enqueue_task_fair warning some more

The recent patch, fe61468b2cb (sched/fair: Fix enqueue_task_fair warning)
did not fully resolve the issues with the rq->tmp_alone_branch !=
&rq->leaf_cfs_rq_list warning in enqueue_task_fair. There is a case where
the first for_each_sched_entity loop exits due to on_rq, having incompletely
updated the list.  In this case the second for_each_sched_entity loop can
further modify se. The later code to fix up the list management fails to do
what is needed because se does not point to the sched_entity which broke out
of the first loop. The list is not fixed up because the throttled parent was
already added back to the list by a task enqueue in a parallel child hierarchy.

Address this by calling list_add_leaf_cfs_rq if there are throttled parents
while doing the second for_each_sched_entity loop.

Fixes: fe61468b2cb ("sched/fair: Fix enqueue_task_fair warning")
Suggested-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Phil Auld <pauld@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Link: https://lkml.kernel.org/r/20200512135222.GC2201@lorien.usersys.redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7cd86641b44b..603d3d3cbf77 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5298,6 +5298,13 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 		/* end evaluation on encountering a throttled cfs_rq */
 		if (cfs_rq_throttled(cfs_rq))
 			goto enqueue_throttle;
+
+               /*
+                * One parent has been throttled and cfs_rq removed from the
+                * list. Add it back to not break the leaf list.
+                */
+               if (throttled_hierarchy(cfs_rq))
+                       list_add_leaf_cfs_rq(cfs_rq);
 	}
 
 enqueue_throttle:
-- 
2.25.1

