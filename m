Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 107A93C524B
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345806AbhGLHpY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:45:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:51356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346844AbhGLHmk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:42:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E32386115A;
        Mon, 12 Jul 2021 07:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075592;
        bh=0OFL4N10rEiwQSZSmGcXrtiPHmfuMmmN/yYuJSRHC0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w1SEuap8yKTpawxg5tcTJrAwu9z2tqBihOmSAPufliInouSU6QADabjCwjm7bU7fi
         TMMgLG/eahl7hltmH9YYNYBunbv3kAex8G0uJNrYfGMbOsiiekZPUhJgudmfIxTQyt
         AeJJfafiCW5TShghTaXWpofN2CB5IOqZtqh8Jqhk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qais Yousef <qais.yousef@arm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 279/800] sched/uclamp: Fix wrong implementation of cpu.uclamp.min
Date:   Mon, 12 Jul 2021 08:05:02 +0200
Message-Id: <20210712060954.179288697@linuxfoundation.org>
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

From: Qais Yousef <qais.yousef@arm.com>

[ Upstream commit 0c18f2ecfcc274a4bcc1d122f79ebd4001c3b445 ]

cpu.uclamp.min is a protection as described in cgroup-v2 Resource
Distribution Model

	Documentation/admin-guide/cgroup-v2.rst

which means we try our best to preserve the minimum performance point of
tasks in this group. See full description of cpu.uclamp.min in the
cgroup-v2.rst.

But the current implementation makes it a limit, which is not what was
intended.

For example:

	tg->cpu.uclamp.min = 20%

	p0->uclamp[UCLAMP_MIN] = 0
	p1->uclamp[UCLAMP_MIN] = 50%

	Previous Behavior (limit):

		p0->effective_uclamp = 0
		p1->effective_uclamp = 20%

	New Behavior (Protection):

		p0->effective_uclamp = 20%
		p1->effective_uclamp = 50%

Which is inline with how protections should work.

With this change the cgroup and per-task behaviors are the same, as
expected.

Additionally, we remove the confusing relationship between cgroup and
!user_defined flag.

We don't want for example RT tasks that are boosted by default to max to
change their boost value when they attach to a cgroup. If a cgroup wants
to limit the max performance point of tasks attached to it, then
cpu.uclamp.max must be set accordingly.

Or if they want to set different boost value based on cgroup, then
sysctl_sched_util_clamp_min_rt_default must be used to NOT boost to max
and set the right cpu.uclamp.min for each group to let the RT tasks
obtain the desired boost value when attached to that group.

As it stands the dependency on !user_defined flag adds an extra layer of
complexity that is not required now cpu.uclamp.min behaves properly as
a protection.

The propagation model of effective cpu.uclamp.min in child cgroups as
implemented by cpu_util_update_eff() is still correct. The parent
protection sets an upper limit of what the child cgroups will
effectively get.

Fixes: 3eac870a3247 (sched/uclamp: Use TG's clamps to restrict TASK's clamps)
Signed-off-by: Qais Yousef <qais.yousef@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20210510145032.1934078-2-qais.yousef@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 9724dd30ad44..49b713da023d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1067,7 +1067,6 @@ uclamp_tg_restrict(struct task_struct *p, enum uclamp_id clamp_id)
 {
 	struct uclamp_se uc_req = p->uclamp_req[clamp_id];
 #ifdef CONFIG_UCLAMP_TASK_GROUP
-	struct uclamp_se uc_max;
 
 	/*
 	 * Tasks in autogroups or root task group will be
@@ -1078,9 +1077,23 @@ uclamp_tg_restrict(struct task_struct *p, enum uclamp_id clamp_id)
 	if (task_group(p) == &root_task_group)
 		return uc_req;
 
-	uc_max = task_group(p)->uclamp[clamp_id];
-	if (uc_req.value > uc_max.value || !uc_req.user_defined)
-		return uc_max;
+	switch (clamp_id) {
+	case UCLAMP_MIN: {
+		struct uclamp_se uc_min = task_group(p)->uclamp[clamp_id];
+		if (uc_req.value < uc_min.value)
+			return uc_min;
+		break;
+	}
+	case UCLAMP_MAX: {
+		struct uclamp_se uc_max = task_group(p)->uclamp[clamp_id];
+		if (uc_req.value > uc_max.value)
+			return uc_max;
+		break;
+	}
+	default:
+		WARN_ON_ONCE(1);
+		break;
+	}
 #endif
 
 	return uc_req;
-- 
2.30.2



