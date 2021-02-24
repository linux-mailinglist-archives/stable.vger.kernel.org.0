Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB99D323CB8
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:05:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235331AbhBXMx4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 07:53:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:50300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235207AbhBXMwf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 07:52:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 34A3764F18;
        Wed, 24 Feb 2021 12:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171068;
        bh=4J4+JGDHIE+fjh3gJynlk0zfTNpvQKopMBNCXWDDB48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nd9bINZ+CBKII4NgWui98KyZPIXYnawMq+vtVw46IFPrgbM2j+dp42UIARMA8CCj+
         PxQrNWkFSalnLQ7gAjZH0YkWALZVNfAxzN+/s4jeMtAd7CHvgUa4bhByYCvJhcFpIu
         +qX0Gk9uu9wV/CTzeckqguSP262UuFkxTTknsTznd3NTV6A1IuyDhsV2KWUmTfDdFh
         glP6U3zlTa8lF27g5Cm4NSLqDuDLFtKGZmvrUbAXetIiLVl7fHYQPWqrQG67hZGqi9
         U/XG+MnwiAP+yfxZbeeYqU6qaSKXuQKijUvB/1rUfMLUXmMuccgrZnt6O88ZG0S7Cr
         qDUAICufynk4A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        syzbot+cb3b69ae80afd6535b0e@syzkaller.appspotmail.com,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.11 30/67] sched/core: Allow try_invoke_on_locked_down_task() with irqs disabled
Date:   Wed, 24 Feb 2021 07:49:48 -0500
Message-Id: <20210224125026.481804-30-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125026.481804-1-sashal@kernel.org>
References: <20210224125026.481804-1-sashal@kernel.org>
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
index ff74fca39ed21..22f6748c16f68 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3478,7 +3478,7 @@ try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
 
 /**
  * try_invoke_on_locked_down_task - Invoke a function on task in fixed state
- * @p: Process for which the function is to be invoked.
+ * @p: Process for which the function is to be invoked, can be @current.
  * @func: Function to invoke.
  * @arg: Argument to function.
  *
@@ -3496,12 +3496,11 @@ try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
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
@@ -3518,7 +3517,7 @@ bool try_invoke_on_locked_down_task(struct task_struct *p, bool (*func)(struct t
 				ret = func(p, arg);
 		}
 	}
-	raw_spin_unlock_irq(&p->pi_lock);
+	raw_spin_unlock_irqrestore(&p->pi_lock, rf.flags);
 	return ret;
 }
 
-- 
2.27.0

