Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A21F323D43
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:08:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234487AbhBXNGd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:06:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:54608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230019AbhBXM7R (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 07:59:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E11B564F4C;
        Wed, 24 Feb 2021 12:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171164;
        bh=LSqG/AgBKzhrBYsEh38qHjLpJTdNkRR67jS3bAEubLI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gE7v9nKiN58KRclPAh8vX91IGr5OU2diKHUoQRIFmNB++7Qqlp1OhqHEGFo7Z0SYm
         z35cgzYaklnXLol4+UWvhH0WKNieMSdVLYaHjpnWeBr+oddiYsgh01HH8QNC/9rm3m
         EzUCWRCwn15a/o+3VBZ/YO6SSruq7QfmSLHI+kaRwqxKNQNx5c4xh/ZFnsvWSM6c4Q
         1YtGQDAAtd6JVi/3LpJtRbmt1f/k/HAjQEZ7tEN2QLoRZWXNgDHXaPS88x5zRVA7BW
         qSqA6ASWrZDgabLl2K0IUe9MV/+QuX3sIOTFx2nEfTnZ5AoNCWOZiERoO/y2o0fovG
         7l4t3WSzNH/8A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        syzbot+cb3b69ae80afd6535b0e@syzkaller.appspotmail.com,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 24/56] sched/core: Allow try_invoke_on_locked_down_task() with irqs disabled
Date:   Wed, 24 Feb 2021 07:51:40 -0500
Message-Id: <20210224125212.482485-24-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125212.482485-1-sashal@kernel.org>
References: <20210224125212.482485-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 1b7af295541d75535374325fd617944534853919 ]

The try_invoke_on_locked_down_task() function currently requires
that interrupts be enabled, but it is called with interrupts
disabled from rcu_print_task_stall(), resulting in an "IRQs not
enabled as expected" diagnostic.  This commit therefore updates
try_invoke_on_locked_down_task() to use raw_spin_lock_irqsave() instead
of raw_spin_lock_irq(), thus allowing use from either context.

Link: https://lore.kernel.org/lkml/000000000000903d5805ab908fc4@google.com/
Link: https://lore.kernel.org/lkml/20200928075729.GC2611@hirez.programming.kicks-ass.net/
Reported-by: syzbot+cb3b69ae80afd6535b0e@syzkaller.appspotmail.com
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 77aa0e788b9b7..269165bf440af 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2989,7 +2989,7 @@ try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
 
 /**
  * try_invoke_on_locked_down_task - Invoke a function on task in fixed state
- * @p: Process for which the function is to be invoked.
+ * @p: Process for which the function is to be invoked, can be @current.
  * @func: Function to invoke.
  * @arg: Argument to function.
  *
@@ -3007,12 +3007,11 @@ try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
  */
 bool try_invoke_on_locked_down_task(struct task_struct *p, bool (*func)(struct task_struct *t, void *arg), void *arg)
 {
-	bool ret = false;
 	struct rq_flags rf;
+	bool ret = false;
 	struct rq *rq;
 
-	lockdep_assert_irqs_enabled();
-	raw_spin_lock_irq(&p->pi_lock);
+	raw_spin_lock_irqsave(&p->pi_lock, rf.flags);
 	if (p->on_rq) {
 		rq = __task_rq_lock(p, &rf);
 		if (task_rq(p) == rq)
@@ -3029,7 +3028,7 @@ bool try_invoke_on_locked_down_task(struct task_struct *p, bool (*func)(struct t
 				ret = func(p, arg);
 		}
 	}
-	raw_spin_unlock_irq(&p->pi_lock);
+	raw_spin_unlock_irqrestore(&p->pi_lock, rf.flags);
 	return ret;
 }
 
-- 
2.27.0

