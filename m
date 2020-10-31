Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0795E2A163C
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbgJaLnZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:43:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:43338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728011AbgJaLnY (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:43:24 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85A1020731;
        Sat, 31 Oct 2020 11:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144603;
        bh=QgJFfLnOzOofuNdS8m7cZmKXXDdt2+u+CpPr6JWmcG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lxX7K1e7aUWYjRPnJGJrGjHAfjQRg2pT6xthsn8vqiNky0lH0geMxMzlI+riRYdJX
         mnyI8jaGR62yG+5OURB6+DI2qJgxLPD3mJQIMrMRBgqBDCOCvgqJ6xa/aQ+LvwQYaC
         jdqaEx18WTGGmzur3SgHri1GATmZ+pMjI+eu7BWw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.9 11/74] io_wq: Make io_wqe::lock a raw_spinlock_t
Date:   Sat, 31 Oct 2020 12:35:53 +0100
Message-Id: <20201031113500.586376005@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113500.031279088@linuxfoundation.org>
References: <20201031113500.031279088@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

commit 95da84659226d75698a1ab958be0af21d9cc2a9c upstream.

During a context switch the scheduler invokes wq_worker_sleeping() with
disabled preemption. Disabling preemption is needed because it protects
access to `worker->sleeping'. As an optimisation it avoids invoking
schedule() within the schedule path as part of possible wake up (thus
preempt_enable_no_resched() afterwards).

The io-wq has been added to the mix in the same section with disabled
preemption. This breaks on PREEMPT_RT because io_wq_worker_sleeping()
acquires a spinlock_t. Also within the schedule() the spinlock_t must be
acquired after tsk_is_pi_blocked() otherwise it will block on the
sleeping lock again while scheduling out.

While playing with `io_uring-bench' I didn't notice a significant
latency spike after converting io_wqe::lock to a raw_spinlock_t. The
latency was more or less the same.

In order to keep the spinlock_t it would have to be moved after the
tsk_is_pi_blocked() check which would introduce a branch instruction
into the hot path.

The lock is used to maintain the `work_list' and wakes one task up at
most.
Should io_wqe_cancel_pending_work() cause latency spikes, while
searching for a specific item, then it would need to drop the lock
during iterations.
revert_creds() is also invoked under the lock. According to debug
cred::non_rcu is 0. Otherwise it should be moved outside of the locked
section because put_cred_rcu()->free_uid() acquires a sleeping lock.

Convert io_wqe::lock to a raw_spinlock_t.c

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io-wq.c |   52 ++++++++++++++++++++++++++--------------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -88,7 +88,7 @@ enum {
  */
 struct io_wqe {
 	struct {
-		spinlock_t lock;
+		raw_spinlock_t lock;
 		struct io_wq_work_list work_list;
 		unsigned long hash_map;
 		unsigned flags;
@@ -149,7 +149,7 @@ static bool __io_worker_unuse(struct io_
 
 	if (current->files != worker->restore_files) {
 		__acquire(&wqe->lock);
-		spin_unlock_irq(&wqe->lock);
+		raw_spin_unlock_irq(&wqe->lock);
 		dropped_lock = true;
 
 		task_lock(current);
@@ -168,7 +168,7 @@ static bool __io_worker_unuse(struct io_
 	if (worker->mm) {
 		if (!dropped_lock) {
 			__acquire(&wqe->lock);
-			spin_unlock_irq(&wqe->lock);
+			raw_spin_unlock_irq(&wqe->lock);
 			dropped_lock = true;
 		}
 		__set_current_state(TASK_RUNNING);
@@ -222,17 +222,17 @@ static void io_worker_exit(struct io_wor
 	worker->flags = 0;
 	preempt_enable();
 
-	spin_lock_irq(&wqe->lock);
+	raw_spin_lock_irq(&wqe->lock);
 	hlist_nulls_del_rcu(&worker->nulls_node);
 	list_del_rcu(&worker->all_list);
 	if (__io_worker_unuse(wqe, worker)) {
 		__release(&wqe->lock);
-		spin_lock_irq(&wqe->lock);
+		raw_spin_lock_irq(&wqe->lock);
 	}
 	acct->nr_workers--;
 	nr_workers = wqe->acct[IO_WQ_ACCT_BOUND].nr_workers +
 			wqe->acct[IO_WQ_ACCT_UNBOUND].nr_workers;
-	spin_unlock_irq(&wqe->lock);
+	raw_spin_unlock_irq(&wqe->lock);
 
 	/* all workers gone, wq exit can proceed */
 	if (!nr_workers && refcount_dec_and_test(&wqe->wq->refs))
@@ -508,7 +508,7 @@ get_next:
 		else if (!wq_list_empty(&wqe->work_list))
 			wqe->flags |= IO_WQE_FLAG_STALLED;
 
-		spin_unlock_irq(&wqe->lock);
+		raw_spin_unlock_irq(&wqe->lock);
 		if (!work)
 			break;
 		io_assign_current_work(worker, work);
@@ -542,17 +542,17 @@ get_next:
 				io_wqe_enqueue(wqe, linked);
 
 			if (hash != -1U && !next_hashed) {
-				spin_lock_irq(&wqe->lock);
+				raw_spin_lock_irq(&wqe->lock);
 				wqe->hash_map &= ~BIT_ULL(hash);
 				wqe->flags &= ~IO_WQE_FLAG_STALLED;
 				/* skip unnecessary unlock-lock wqe->lock */
 				if (!work)
 					goto get_next;
-				spin_unlock_irq(&wqe->lock);
+				raw_spin_unlock_irq(&wqe->lock);
 			}
 		} while (work);
 
-		spin_lock_irq(&wqe->lock);
+		raw_spin_lock_irq(&wqe->lock);
 	} while (1);
 }
 
@@ -567,7 +567,7 @@ static int io_wqe_worker(void *data)
 	while (!test_bit(IO_WQ_BIT_EXIT, &wq->state)) {
 		set_current_state(TASK_INTERRUPTIBLE);
 loop:
-		spin_lock_irq(&wqe->lock);
+		raw_spin_lock_irq(&wqe->lock);
 		if (io_wqe_run_queue(wqe)) {
 			__set_current_state(TASK_RUNNING);
 			io_worker_handle_work(worker);
@@ -578,7 +578,7 @@ loop:
 			__release(&wqe->lock);
 			goto loop;
 		}
-		spin_unlock_irq(&wqe->lock);
+		raw_spin_unlock_irq(&wqe->lock);
 		if (signal_pending(current))
 			flush_signals(current);
 		if (schedule_timeout(WORKER_IDLE_TIMEOUT))
@@ -590,11 +590,11 @@ loop:
 	}
 
 	if (test_bit(IO_WQ_BIT_EXIT, &wq->state)) {
-		spin_lock_irq(&wqe->lock);
+		raw_spin_lock_irq(&wqe->lock);
 		if (!wq_list_empty(&wqe->work_list))
 			io_worker_handle_work(worker);
 		else
-			spin_unlock_irq(&wqe->lock);
+			raw_spin_unlock_irq(&wqe->lock);
 	}
 
 	io_worker_exit(worker);
@@ -634,9 +634,9 @@ void io_wq_worker_sleeping(struct task_s
 
 	worker->flags &= ~IO_WORKER_F_RUNNING;
 
-	spin_lock_irq(&wqe->lock);
+	raw_spin_lock_irq(&wqe->lock);
 	io_wqe_dec_running(wqe, worker);
-	spin_unlock_irq(&wqe->lock);
+	raw_spin_unlock_irq(&wqe->lock);
 }
 
 static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
@@ -660,7 +660,7 @@ static bool create_io_worker(struct io_w
 		return false;
 	}
 
-	spin_lock_irq(&wqe->lock);
+	raw_spin_lock_irq(&wqe->lock);
 	hlist_nulls_add_head_rcu(&worker->nulls_node, &wqe->free_list);
 	list_add_tail_rcu(&worker->all_list, &wqe->all_list);
 	worker->flags |= IO_WORKER_F_FREE;
@@ -669,7 +669,7 @@ static bool create_io_worker(struct io_w
 	if (!acct->nr_workers && (worker->flags & IO_WORKER_F_BOUND))
 		worker->flags |= IO_WORKER_F_FIXED;
 	acct->nr_workers++;
-	spin_unlock_irq(&wqe->lock);
+	raw_spin_unlock_irq(&wqe->lock);
 
 	if (index == IO_WQ_ACCT_UNBOUND)
 		atomic_inc(&wq->user->processes);
@@ -724,12 +724,12 @@ static int io_wq_manager(void *data)
 			if (!node_online(node))
 				continue;
 
-			spin_lock_irq(&wqe->lock);
+			raw_spin_lock_irq(&wqe->lock);
 			if (io_wqe_need_worker(wqe, IO_WQ_ACCT_BOUND))
 				fork_worker[IO_WQ_ACCT_BOUND] = true;
 			if (io_wqe_need_worker(wqe, IO_WQ_ACCT_UNBOUND))
 				fork_worker[IO_WQ_ACCT_UNBOUND] = true;
-			spin_unlock_irq(&wqe->lock);
+			raw_spin_unlock_irq(&wqe->lock);
 			if (fork_worker[IO_WQ_ACCT_BOUND])
 				create_io_worker(wq, wqe, IO_WQ_ACCT_BOUND);
 			if (fork_worker[IO_WQ_ACCT_UNBOUND])
@@ -825,10 +825,10 @@ static void io_wqe_enqueue(struct io_wqe
 	}
 
 	work_flags = work->flags;
-	spin_lock_irqsave(&wqe->lock, flags);
+	raw_spin_lock_irqsave(&wqe->lock, flags);
 	io_wqe_insert_work(wqe, work);
 	wqe->flags &= ~IO_WQE_FLAG_STALLED;
-	spin_unlock_irqrestore(&wqe->lock, flags);
+	raw_spin_unlock_irqrestore(&wqe->lock, flags);
 
 	if ((work_flags & IO_WQ_WORK_CONCURRENT) ||
 	    !atomic_read(&acct->nr_running))
@@ -955,13 +955,13 @@ static void io_wqe_cancel_pending_work(s
 	unsigned long flags;
 
 retry:
-	spin_lock_irqsave(&wqe->lock, flags);
+	raw_spin_lock_irqsave(&wqe->lock, flags);
 	wq_list_for_each(node, prev, &wqe->work_list) {
 		work = container_of(node, struct io_wq_work, list);
 		if (!match->fn(work, match->data))
 			continue;
 		io_wqe_remove_pending(wqe, work, prev);
-		spin_unlock_irqrestore(&wqe->lock, flags);
+		raw_spin_unlock_irqrestore(&wqe->lock, flags);
 		io_run_cancel(work, wqe);
 		match->nr_pending++;
 		if (!match->cancel_all)
@@ -970,7 +970,7 @@ retry:
 		/* not safe to continue after unlock */
 		goto retry;
 	}
-	spin_unlock_irqrestore(&wqe->lock, flags);
+	raw_spin_unlock_irqrestore(&wqe->lock, flags);
 }
 
 static void io_wqe_cancel_running_work(struct io_wqe *wqe,
@@ -1078,7 +1078,7 @@ struct io_wq *io_wq_create(unsigned boun
 		}
 		atomic_set(&wqe->acct[IO_WQ_ACCT_UNBOUND].nr_running, 0);
 		wqe->wq = wq;
-		spin_lock_init(&wqe->lock);
+		raw_spin_lock_init(&wqe->lock);
 		INIT_WQ_LIST(&wqe->work_list);
 		INIT_HLIST_NULLS_HEAD(&wqe->free_list, 0);
 		INIT_LIST_HEAD(&wqe->all_list);


