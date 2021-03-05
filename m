Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE5932E80B
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:25:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbhCEMYn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:24:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:59154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230409AbhCEMYY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:24:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3C4665023;
        Fri,  5 Mar 2021 12:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947064;
        bh=GM+0cx1RspxAZTGMRF4bmBrImrhA1SdxQTfGeOTsh7c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y6IUzLGlHf9RlgGLroovLtTaMRFoCu8OK9f87K7ABZ0QsVEsU+Z0B9jGrGKqCyvWo
         /RrBuhKAfpGvr+3HppaUd3pxgKrkCdlxljZGMF//Yt4oLQ3iYzQtqzKv8uXBTkwt+d
         Ij1c3EPjArzFINmGwfs3rE4zJkri6KalLrNkSLlc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+cb3b69ae80afd6535b0e@syzkaller.appspotmail.com,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@kernel.org>
Subject: [PATCH 5.11 005/104] sched/core: Allow try_invoke_on_locked_down_task() with irqs disabled
Date:   Fri,  5 Mar 2021 13:20:10 +0100
Message-Id: <20210305120903.441413880@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120903.166929741@linuxfoundation.org>
References: <20210305120903.166929741@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit 1b7af295541d75535374325fd617944534853919 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/core.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3478,7 +3478,7 @@ out:
 
 /**
  * try_invoke_on_locked_down_task - Invoke a function on task in fixed state
- * @p: Process for which the function is to be invoked.
+ * @p: Process for which the function is to be invoked, can be @current.
  * @func: Function to invoke.
  * @arg: Argument to function.
  *
@@ -3496,12 +3496,11 @@ out:
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
@@ -3518,7 +3517,7 @@ bool try_invoke_on_locked_down_task(stru
 				ret = func(p, arg);
 		}
 	}
-	raw_spin_unlock_irq(&p->pi_lock);
+	raw_spin_unlock_irqrestore(&p->pi_lock, rf.flags);
 	return ret;
 }
 


