Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9897240E5CC
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242951AbhIPRPh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:15:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:39922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350710AbhIPRMD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:12:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BBF46140A;
        Thu, 16 Sep 2021 16:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810309;
        bh=ok+fuA4dato3FKC1J7L3luDz2EmLvG0cvX85bnbgvMw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qypHYInt0Oj0TkuYu9x+I+x4M0DPp/beAmOb9ss80UDEGtdiVo7NNqWCLed6uQ8eY
         4KFOkZjBHjwCbpaXUz1/1LMALvTMqgQK8JywNxVngZCpN0dJqxx5ol64x0E6Atd8B2
         GkaWSJ2ydv5aM5lskgKfGEP6QcJFgfAJTpTssoao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sebastian Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.14 061/432] sched: Prevent balance_push() on remote runqueues
Date:   Thu, 16 Sep 2021 17:56:50 +0200
Message-Id: <20210916155812.853791406@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 868ad33bfa3bf39960982682ad3a0f8ebda1656e upstream.

sched_setscheduler() and rt_mutex_setprio() invoke the run-queue balance
callback after changing priorities or the scheduling class of a task. The
run-queue for which the callback is invoked can be local or remote.

That's not a problem for the regular rq::push_work which is serialized with
a busy flag in the run-queue struct, but for the balance_push() work which
is only valid to be invoked on the outgoing CPU that's wrong. It not only
triggers the debug warning, but also leaves the per CPU variable push_work
unprotected, which can result in double enqueues on the stop machine list.

Remove the warning and validate that the function is invoked on the
outgoing CPU.

Fixes: ae7927023243 ("sched: Optimize finish_lock_switch()")
Reported-by: Sebastian Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/87zgt1hdw7.ffs@tglx
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8536,7 +8536,6 @@ static void balance_push(struct rq *rq)
 	struct task_struct *push_task = rq->curr;
 
 	lockdep_assert_rq_held(rq);
-	SCHED_WARN_ON(rq->cpu != smp_processor_id());
 
 	/*
 	 * Ensure the thing is persistent until balance_push_set(.on = false);
@@ -8544,9 +8543,10 @@ static void balance_push(struct rq *rq)
 	rq->balance_callback = &balance_push_callback;
 
 	/*
-	 * Only active while going offline.
+	 * Only active while going offline and when invoked on the outgoing
+	 * CPU.
 	 */
-	if (!cpu_dying(rq->cpu))
+	if (!cpu_dying(rq->cpu) || rq != this_rq())
 		return;
 
 	/*


