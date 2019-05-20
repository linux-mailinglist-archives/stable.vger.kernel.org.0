Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0212367C
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389147AbfETMZs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:25:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:41046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389159AbfETMZr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:25:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B197221721;
        Mon, 20 May 2019 12:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355146;
        bh=nWmg/s1/FQ755ovfqfFkxBad9yHVhOJI5H577iZ6ch4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XTDjNfZQY+EBwFjOUnmhuwjz6LKjIUhFEmNFC3cczMhwpN78GrJ/sJYfmYur8nkIo
         qPXuTaASnZb7ulWrEaw56PZr0WUHJ2ApJ5a1E1J6o984iDgSrUsWcTGw9CY1AwRI61
         bjCdIIwVgN40S5/RQy2uGtdfhhKyaGmXnRZcld+c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Waiman Long <longman@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Will Deacon <will.deacon@arm.com>,
        huang ying <huang.ying.caritas@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 001/123] locking/rwsem: Prevent decrement of reader count before increment
Date:   Mon, 20 May 2019 14:13:01 +0200
Message-Id: <20190520115245.506883428@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115245.439864225@linuxfoundation.org>
References: <20190520115245.439864225@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit a9e9bcb45b1525ba7aea26ed9441e8632aeeda58 ]

During my rwsem testing, it was found that after a down_read(), the
reader count may occasionally become 0 or even negative. Consequently,
a writer may steal the lock at that time and execute with the reader
in parallel thus breaking the mutual exclusion guarantee of the write
lock. In other words, both readers and writer can become rwsem owners
simultaneously.

The current reader wakeup code does it in one pass to clear waiter->task
and put them into wake_q before fully incrementing the reader count.
Once waiter->task is cleared, the corresponding reader may see it,
finish the critical section and do unlock to decrement the count before
the count is incremented. This is not a problem if there is only one
reader to wake up as the count has been pre-incremented by 1.  It is
a problem if there are more than one readers to be woken up and writer
can steal the lock.

The wakeup was actually done in 2 passes before the following v4.9 commit:

  70800c3c0cc5 ("locking/rwsem: Scan the wait_list for readers only once")

To fix this problem, the wakeup is now done in two passes
again. In the first pass, we collect the readers and count them.
The reader count is then fully incremented. In the second pass, the
waiter->task is then cleared and they are put into wake_q to be woken
up later.

Signed-off-by: Waiman Long <longman@redhat.com>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: huang ying <huang.ying.caritas@gmail.com>
Fixes: 70800c3c0cc5 ("locking/rwsem: Scan the wait_list for readers only once")
Link: http://lkml.kernel.org/r/20190428212557.13482-2-longman@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/locking/rwsem-xadd.c | 44 +++++++++++++++++++++++++------------
 1 file changed, 30 insertions(+), 14 deletions(-)

diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
index 50d9af615dc49..115860164c365 100644
--- a/kernel/locking/rwsem-xadd.c
+++ b/kernel/locking/rwsem-xadd.c
@@ -130,6 +130,7 @@ static void __rwsem_mark_wake(struct rw_semaphore *sem,
 {
 	struct rwsem_waiter *waiter, *tmp;
 	long oldcount, woken = 0, adjustment = 0;
+	struct list_head wlist;
 
 	/*
 	 * Take a peek at the queue head waiter such that we can determine
@@ -188,18 +189,42 @@ static void __rwsem_mark_wake(struct rw_semaphore *sem,
 	 * of the queue. We know that woken will be at least 1 as we accounted
 	 * for above. Note we increment the 'active part' of the count by the
 	 * number of readers before waking any processes up.
+	 *
+	 * We have to do wakeup in 2 passes to prevent the possibility that
+	 * the reader count may be decremented before it is incremented. It
+	 * is because the to-be-woken waiter may not have slept yet. So it
+	 * may see waiter->task got cleared, finish its critical section and
+	 * do an unlock before the reader count increment.
+	 *
+	 * 1) Collect the read-waiters in a separate list, count them and
+	 *    fully increment the reader count in rwsem.
+	 * 2) For each waiters in the new list, clear waiter->task and
+	 *    put them into wake_q to be woken up later.
 	 */
-	list_for_each_entry_safe(waiter, tmp, &sem->wait_list, list) {
-		struct task_struct *tsk;
-
+	list_for_each_entry(waiter, &sem->wait_list, list) {
 		if (waiter->type == RWSEM_WAITING_FOR_WRITE)
 			break;
 
 		woken++;
-		tsk = waiter->task;
+	}
+	list_cut_before(&wlist, &sem->wait_list, &waiter->list);
+
+	adjustment = woken * RWSEM_ACTIVE_READ_BIAS - adjustment;
+	if (list_empty(&sem->wait_list)) {
+		/* hit end of list above */
+		adjustment -= RWSEM_WAITING_BIAS;
+	}
+
+	if (adjustment)
+		atomic_long_add(adjustment, &sem->count);
+
+	/* 2nd pass */
+	list_for_each_entry_safe(waiter, tmp, &wlist, list) {
+		struct task_struct *tsk;
 
+		tsk = waiter->task;
 		get_task_struct(tsk);
-		list_del(&waiter->list);
+
 		/*
 		 * Ensure calling get_task_struct() before setting the reader
 		 * waiter to nil such that rwsem_down_read_failed() cannot
@@ -215,15 +240,6 @@ static void __rwsem_mark_wake(struct rw_semaphore *sem,
 		/* wake_q_add() already take the task ref */
 		put_task_struct(tsk);
 	}
-
-	adjustment = woken * RWSEM_ACTIVE_READ_BIAS - adjustment;
-	if (list_empty(&sem->wait_list)) {
-		/* hit end of list above */
-		adjustment -= RWSEM_WAITING_BIAS;
-	}
-
-	if (adjustment)
-		atomic_long_add(adjustment, &sem->count);
 }
 
 /*
-- 
2.20.1



