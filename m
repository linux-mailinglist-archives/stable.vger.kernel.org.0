Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BBDA3CE41E
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346176AbhGSPmP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:42:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:59806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349508AbhGSPf5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:35:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E794D600EF;
        Mon, 19 Jul 2021 16:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711396;
        bh=9YDCUJ3AdYByCpUBpPkZkGVlKmM8ibKSWiSBt6RR1GI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WiqCHnx+WdSP/b/mQ4VceS0rLUm3TK8SMBucjXThD3GhBiysCcWz+u4260X37y95B
         QK6A+Nu7lsQCa+O1pyJaPgMNwz4aLIfmcuXzEQ17Js8cMNSaqPKUh9Z8OulcelMYzI
         rUmtYNQYzPNGxc8L5UhM2eRy6172Xv5yzMF7vNNk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xuewen Yan <xuewen.yan@unisoc.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Qais Yousef <qais.yousef@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 338/351] sched/uclamp: Ignore max aggregation if rq is idle
Date:   Mon, 19 Jul 2021 16:54:44 +0200
Message-Id: <20210719144956.243799275@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xuewen Yan <xuewen.yan@unisoc.com>

[ Upstream commit 3e1493f46390618ea78607cb30c58fc19e2a5035 ]

When a task wakes up on an idle rq, uclamp_rq_util_with() would max
aggregate with rq value. But since there is no task enqueued yet, the
values are stale based on the last task that was running. When the new
task actually wakes up and enqueued, then the rq uclamp values should
reflect that of the newly woken up task effective uclamp values.

This is a problem particularly for uclamp_max because it default to
1024. If a task p with uclamp_max = 512 wakes up, then max aggregation
would ignore the capping that should apply when this task is enqueued,
which is wrong.

Fix that by ignoring max aggregation if the rq is idle since in that
case the effective uclamp value of the rq will be the ones of the task
that will wake up.

Fixes: 9d20ad7dfc9a ("sched/uclamp: Add uclamp_util_with()")
Signed-off-by: Xuewen Yan <xuewen.yan@unisoc.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Valentin Schneider <valentin.schneider@arm.com>
[qias: Changelog]
Reviewed-by: Qais Yousef <qais.yousef@arm.com>
Link: https://lore.kernel.org/r/20210630141204.8197-1-xuewen.yan94@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/sched.h | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index a189bec13729..35f7efed75c4 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -2539,20 +2539,27 @@ static __always_inline
 unsigned long uclamp_rq_util_with(struct rq *rq, unsigned long util,
 				  struct task_struct *p)
 {
-	unsigned long min_util;
-	unsigned long max_util;
+	unsigned long min_util = 0;
+	unsigned long max_util = 0;
 
 	if (!static_branch_likely(&sched_uclamp_used))
 		return util;
 
-	min_util = READ_ONCE(rq->uclamp[UCLAMP_MIN].value);
-	max_util = READ_ONCE(rq->uclamp[UCLAMP_MAX].value);
-
 	if (p) {
-		min_util = max(min_util, uclamp_eff_value(p, UCLAMP_MIN));
-		max_util = max(max_util, uclamp_eff_value(p, UCLAMP_MAX));
+		min_util = uclamp_eff_value(p, UCLAMP_MIN);
+		max_util = uclamp_eff_value(p, UCLAMP_MAX);
+
+		/*
+		 * Ignore last runnable task's max clamp, as this task will
+		 * reset it. Similarly, no need to read the rq's min clamp.
+		 */
+		if (rq->uclamp_flags & UCLAMP_FLAG_IDLE)
+			goto out;
 	}
 
+	min_util = max_t(unsigned long, min_util, READ_ONCE(rq->uclamp[UCLAMP_MIN].value));
+	max_util = max_t(unsigned long, max_util, READ_ONCE(rq->uclamp[UCLAMP_MAX].value));
+out:
 	/*
 	 * Since CPU's {min,max}_util clamps are MAX aggregated considering
 	 * RUNNABLE tasks with _different_ clamps, we can end up with an
-- 
2.30.2



