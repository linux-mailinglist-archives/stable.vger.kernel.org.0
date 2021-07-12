Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD1633C4557
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 08:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235413AbhGLGZH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:25:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:40098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234990AbhGLGYZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:24:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1859861154;
        Mon, 12 Jul 2021 06:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626070859;
        bh=FX+H5o5Ly9F0lbRZPz+w+UG+tLvnhPv/eFZjn/gs03A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ggxpspNpR8EoBxJgh6ysQzcVqM9D9cX+D1wQRWfaE9VaR0oILjbw9qeYDMYWvA3nv
         KVRMGSVwUmsKHZzXsbiBhFay+AwNuzxxd2WQfWXjxa44lH5kpH+Thmdi6ceOSD6eoj
         dW8cGSTfM4Fc0zA/yJlClNRF3L5AbrNhlz9pMPQ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xuewen Yan <xuewen.yan94@gmail.com>,
        Qais Yousef <qais.yousef@arm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 172/348] sched/uclamp: Fix uclamp_tg_restrict()
Date:   Mon, 12 Jul 2021 08:09:16 +0200
Message-Id: <20210712060723.694138109@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qais Yousef <qais.yousef@arm.com>

[ Upstream commit 0213b7083e81f4acd69db32cb72eb4e5f220329a ]

Now cpu.uclamp.min acts as a protection, we need to make sure that the
uclamp request of the task is within the allowed range of the cgroup,
that is it is clamp()'ed correctly by tg->uclamp[UCLAMP_MIN] and
tg->uclamp[UCLAMP_MAX].

As reported by Xuewen [1] we can have some corner cases where there's
inversion between uclamp requested by task (p) and the uclamp values of
the taskgroup it's attached to (tg). Following table demonstrates
2 corner cases:

	           |  p  |  tg  |  effective
	-----------+-----+------+-----------
	CASE 1
	-----------+-----+------+-----------
	uclamp_min | 60% | 0%   |  60%
	-----------+-----+------+-----------
	uclamp_max | 80% | 50%  |  50%
	-----------+-----+------+-----------
	CASE 2
	-----------+-----+------+-----------
	uclamp_min | 0%  | 30%  |  30%
	-----------+-----+------+-----------
	uclamp_max | 20% | 50%  |  20%
	-----------+-----+------+-----------

With this fix we get:

	           |  p  |  tg  |  effective
	-----------+-----+------+-----------
	CASE 1
	-----------+-----+------+-----------
	uclamp_min | 60% | 0%   |  50%
	-----------+-----+------+-----------
	uclamp_max | 80% | 50%  |  50%
	-----------+-----+------+-----------
	CASE 2
	-----------+-----+------+-----------
	uclamp_min | 0%  | 30%  |  30%
	-----------+-----+------+-----------
	uclamp_max | 20% | 50%  |  30%
	-----------+-----+------+-----------

Additionally uclamp_update_active_tasks() must now unconditionally
update both UCLAMP_MIN/MAX because changing the tg's UCLAMP_MAX for
instance could have an impact on the effective UCLAMP_MIN of the tasks.

	           |  p  |  tg  |  effective
	-----------+-----+------+-----------
	old
	-----------+-----+------+-----------
	uclamp_min | 60% | 0%   |  50%
	-----------+-----+------+-----------
	uclamp_max | 80% | 50%  |  50%
	-----------+-----+------+-----------
	*new*
	-----------+-----+------+-----------
	uclamp_min | 60% | 0%   | *60%*
	-----------+-----+------+-----------
	uclamp_max | 80% |*70%* | *70%*
	-----------+-----+------+-----------

[1] https://lore.kernel.org/lkml/CAB8ipk_a6VFNjiEnHRHkUMBKbA+qzPQvhtNjJ_YNzQhqV_o8Zw@mail.gmail.com/

Fixes: 0c18f2ecfcc2 ("sched/uclamp: Fix wrong implementation of cpu.uclamp.min")
Reported-by: Xuewen Yan <xuewen.yan94@gmail.com>
Signed-off-by: Qais Yousef <qais.yousef@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20210617165155.3774110-1-qais.yousef@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c | 49 +++++++++++++++++----------------------------
 1 file changed, 18 insertions(+), 31 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b23e70db3b6e..8294debf68c4 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -894,8 +894,10 @@ unsigned int uclamp_rq_max_value(struct rq *rq, enum uclamp_id clamp_id,
 static inline struct uclamp_se
 uclamp_tg_restrict(struct task_struct *p, enum uclamp_id clamp_id)
 {
+	/* Copy by value as we could modify it */
 	struct uclamp_se uc_req = p->uclamp_req[clamp_id];
 #ifdef CONFIG_UCLAMP_TASK_GROUP
+	unsigned int tg_min, tg_max, value;
 
 	/*
 	 * Tasks in autogroups or root task group will be
@@ -906,23 +908,11 @@ uclamp_tg_restrict(struct task_struct *p, enum uclamp_id clamp_id)
 	if (task_group(p) == &root_task_group)
 		return uc_req;
 
-	switch (clamp_id) {
-	case UCLAMP_MIN: {
-		struct uclamp_se uc_min = task_group(p)->uclamp[clamp_id];
-		if (uc_req.value < uc_min.value)
-			return uc_min;
-		break;
-	}
-	case UCLAMP_MAX: {
-		struct uclamp_se uc_max = task_group(p)->uclamp[clamp_id];
-		if (uc_req.value > uc_max.value)
-			return uc_max;
-		break;
-	}
-	default:
-		WARN_ON_ONCE(1);
-		break;
-	}
+	tg_min = task_group(p)->uclamp[UCLAMP_MIN].value;
+	tg_max = task_group(p)->uclamp[UCLAMP_MAX].value;
+	value = uc_req.value;
+	value = clamp(value, tg_min, tg_max);
+	uclamp_se_set(&uc_req, value, false);
 #endif
 
 	return uc_req;
@@ -1121,8 +1111,9 @@ static inline void uclamp_rq_dec(struct rq *rq, struct task_struct *p)
 }
 
 static inline void
-uclamp_update_active(struct task_struct *p, enum uclamp_id clamp_id)
+uclamp_update_active(struct task_struct *p)
 {
+	enum uclamp_id clamp_id;
 	struct rq_flags rf;
 	struct rq *rq;
 
@@ -1142,9 +1133,11 @@ uclamp_update_active(struct task_struct *p, enum uclamp_id clamp_id)
 	 * affecting a valid clamp bucket, the next time it's enqueued,
 	 * it will already see the updated clamp bucket value.
 	 */
-	if (p->uclamp[clamp_id].active) {
-		uclamp_rq_dec_id(rq, p, clamp_id);
-		uclamp_rq_inc_id(rq, p, clamp_id);
+	for_each_clamp_id(clamp_id) {
+		if (p->uclamp[clamp_id].active) {
+			uclamp_rq_dec_id(rq, p, clamp_id);
+			uclamp_rq_inc_id(rq, p, clamp_id);
+		}
 	}
 
 	task_rq_unlock(rq, p, &rf);
@@ -1152,20 +1145,14 @@ uclamp_update_active(struct task_struct *p, enum uclamp_id clamp_id)
 
 #ifdef CONFIG_UCLAMP_TASK_GROUP
 static inline void
-uclamp_update_active_tasks(struct cgroup_subsys_state *css,
-			   unsigned int clamps)
+uclamp_update_active_tasks(struct cgroup_subsys_state *css)
 {
-	enum uclamp_id clamp_id;
 	struct css_task_iter it;
 	struct task_struct *p;
 
 	css_task_iter_start(css, 0, &it);
-	while ((p = css_task_iter_next(&it))) {
-		for_each_clamp_id(clamp_id) {
-			if ((0x1 << clamp_id) & clamps)
-				uclamp_update_active(p, clamp_id);
-		}
-	}
+	while ((p = css_task_iter_next(&it)))
+		uclamp_update_active(p);
 	css_task_iter_end(&it);
 }
 
@@ -7328,7 +7315,7 @@ static void cpu_util_update_eff(struct cgroup_subsys_state *css)
 		}
 
 		/* Immediately update descendants RUNNABLE tasks */
-		uclamp_update_active_tasks(css, clamps);
+		uclamp_update_active_tasks(css);
 	}
 }
 
-- 
2.30.2



