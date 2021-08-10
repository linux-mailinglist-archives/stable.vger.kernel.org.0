Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5655B3E81E4
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 20:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235258AbhHJSDf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 14:03:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:60846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237156AbhHJSBe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 14:01:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E10D613A3;
        Tue, 10 Aug 2021 17:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617632;
        bh=uI7adSp74S15+zQsLIx57ME6q8nqPuHrY0K4PGtLg4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xf7W1WFy3bpIfCRmotyBQ1M+1gloeFHjUHGOCy+PR1OJ84dTP90XDKG2G58AcAkRn
         yYe/KDRanMbM08R2UHpxo94NrIKoNpcqI0lblwvZ+jto89uRMA4Sq79MYJd9UrK6DE
         3Gv71wE7uhhR0txg0uaIo22Hr3pNLJMx5XlYNbCs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.13 145/175] io-wq: fix race between worker exiting and activating free worker
Date:   Tue, 10 Aug 2021 19:30:53 +0200
Message-Id: <20210810173005.743233009@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 83d6c39310b6d11199179f6384c2b0a415389597 upstream.

Nadav correctly reports that we have a race between a worker exiting,
and new work being queued. This can lead to work being queued behind
an existing worker that could be sleeping on an event before it can
run to completion, and hence introducing potential big latency gaps
if we hit this race condition:

cpu0					cpu1
----					----
					io_wqe_worker()
					schedule_timeout()
					 // timed out
io_wqe_enqueue()
io_wqe_wake_worker()
// work_flags & IO_WQ_WORK_CONCURRENT
io_wqe_activate_free_worker()
					 io_worker_exit()

Fix this by having the exiting worker go through the normal decrement
of a running worker, which will spawn a new one if needed.

The free worker activation is modified to only return success if we
were able to find a sleeping worker - if not, we keep looking through
the list. If we fail, we create a new worker as per usual.

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/io-uring/BFF746C0-FEDE-4646-A253-3021C57C26C9@gmail.com/
Reported-by: Nadav Amit <nadav.amit@gmail.com>
Tested-by: Nadav Amit <nadav.amit@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io-wq.c |   38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -131,6 +131,7 @@ struct io_cb_cancel_data {
 };
 
 static void create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index);
+static void io_wqe_dec_running(struct io_worker *worker);
 
 static bool io_worker_get(struct io_worker *worker)
 {
@@ -169,26 +170,21 @@ static void io_worker_exit(struct io_wor
 {
 	struct io_wqe *wqe = worker->wqe;
 	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
-	unsigned flags;
 
 	if (refcount_dec_and_test(&worker->ref))
 		complete(&worker->ref_done);
 	wait_for_completion(&worker->ref_done);
 
-	preempt_disable();
-	current->flags &= ~PF_IO_WORKER;
-	flags = worker->flags;
-	worker->flags = 0;
-	if (flags & IO_WORKER_F_RUNNING)
-		atomic_dec(&acct->nr_running);
-	worker->flags = 0;
-	preempt_enable();
-
 	raw_spin_lock_irq(&wqe->lock);
-	if (flags & IO_WORKER_F_FREE)
+	if (worker->flags & IO_WORKER_F_FREE)
 		hlist_nulls_del_rcu(&worker->nulls_node);
 	list_del_rcu(&worker->all_list);
 	acct->nr_workers--;
+	preempt_disable();
+	io_wqe_dec_running(worker);
+	worker->flags = 0;
+	current->flags &= ~PF_IO_WORKER;
+	preempt_enable();
 	raw_spin_unlock_irq(&wqe->lock);
 
 	kfree_rcu(worker, rcu);
@@ -215,15 +211,19 @@ static bool io_wqe_activate_free_worker(
 	struct hlist_nulls_node *n;
 	struct io_worker *worker;
 
-	n = rcu_dereference(hlist_nulls_first_rcu(&wqe->free_list));
-	if (is_a_nulls(n))
-		return false;
-
-	worker = hlist_nulls_entry(n, struct io_worker, nulls_node);
-	if (io_worker_get(worker)) {
-		wake_up_process(worker->task);
+	/*
+	 * Iterate free_list and see if we can find an idle worker to
+	 * activate. If a given worker is on the free_list but in the process
+	 * of exiting, keep trying.
+	 */
+	hlist_nulls_for_each_entry_rcu(worker, n, &wqe->free_list, nulls_node) {
+		if (!io_worker_get(worker))
+			continue;
+		if (wake_up_process(worker->task)) {
+			io_worker_release(worker);
+			return true;
+		}
 		io_worker_release(worker);
-		return true;
 	}
 
 	return false;


