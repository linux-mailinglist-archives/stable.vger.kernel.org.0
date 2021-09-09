Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50F184047E2
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 11:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233080AbhIIJjr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 05:39:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbhIIJjr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Sep 2021 05:39:47 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02033C061575;
        Thu,  9 Sep 2021 02:38:37 -0700 (PDT)
Date:   Thu, 09 Sep 2021 09:38:34 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1631180315;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lcNaP07PKMAmOJRYwyE4hu2hgVbleeLOp79xPo503QA=;
        b=FnhyKhFH5VbglJwVrG886b43A+BIuM4Gs4i43SgnnD8RxLQIJtStnZPlyvz5MuudKysy6z
        pIfg2ggyOZ0+A9A0+WIxltii5vYtXOokYqU+Vv3cyO7uLjJ5Jl/UGv97t04l02FudCgyfc
        j7XuqG2ZT4KyFufuRGaB2QFs/DQ1GzSbiUx0lZPoPwVvYn0MAjJnWpPize25dw2yOM+UCm
        FnTb1IDJ8FUBqhiHMzvNarY8BXd+hlN6qSFdvYPGpm6ll6mvgrsiPBejdGq0nfEYtBaAiF
        xwAXp+nwJOlAUNCA2FpWKioZtAx2418qX4ayfyCNQ9dxnOVvAiq22Q9WOye6jQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1631180315;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lcNaP07PKMAmOJRYwyE4hu2hgVbleeLOp79xPo503QA=;
        b=emY8EWEWXfYbLaCfIQBpbkzvY4MF+U8nS/0zEkj9DaVZoWvkyHc4GUJOEOe7CPleBM5y3S
        CimKJo6QSL7wDPCQ==
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: sched/urgent] sched: Prevent balance_push() on remote runqueues
Cc:     Sebastian Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <87zgt1hdw7.ffs@tglx>
References: <87zgt1hdw7.ffs@tglx>
MIME-Version: 1.0
Message-ID: <163118031401.25758.11404036783844944649.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the sched/urgent branch of tip:

Commit-ID:     868ad33bfa3bf39960982682ad3a0f8ebda1656e
Gitweb:        https://git.kernel.org/tip/868ad33bfa3bf39960982682ad3a0f8ebda1656e
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Sat, 28 Aug 2021 15:55:52 +02:00
Committer:     Peter Zijlstra <peterz@infradead.org>
CommitterDate: Thu, 09 Sep 2021 11:27:23 +02:00

sched: Prevent balance_push() on remote runqueues

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
---
 kernel/sched/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index f3b27c6..b21a185 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8523,7 +8523,6 @@ static void balance_push(struct rq *rq)
 	struct task_struct *push_task = rq->curr;
 
 	lockdep_assert_rq_held(rq);
-	SCHED_WARN_ON(rq->cpu != smp_processor_id());
 
 	/*
 	 * Ensure the thing is persistent until balance_push_set(.on = false);
@@ -8531,9 +8530,10 @@ static void balance_push(struct rq *rq)
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
