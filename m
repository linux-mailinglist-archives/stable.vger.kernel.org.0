Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C40DB408A43
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 13:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239584AbhIMLc1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 07:32:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:35568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239630AbhIMLcY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 07:32:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF07B60ED8;
        Mon, 13 Sep 2021 11:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631532669;
        bh=Eki/ddec1w2JIt2RPY3gHb9tdKVU+tEgtjSsF+opFA0=;
        h=Subject:To:Cc:From:Date:From;
        b=KNo5Op6Cj63eUWtxNBdL1mbwEYVa4zhiqtblVV+adCpYsjRI2zQ94cQAdu/QOPBJs
         jt20e7SsayIyRxzD5S0EuWrx4bHIdyVzrTJB/XXICE/ijN5JQU4SlKQ+9bBS/0RPHw
         F46py9Nsd3HqrYoRFy6fRaw7N6fKMvNCtlbZeJSs=
Subject: FAILED: patch "[PATCH] io-wq: check max_worker limits if a worker transitions bound" failed to apply to 5.10-stable tree
To:     axboe@kernel.dk, johalun0@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 13 Sep 2021 13:31:04 +0200
Message-ID: <1631532664142194@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ecc53c48c13d995e6fe5559e30ffee48d92784fd Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Sun, 29 Aug 2021 16:13:03 -0600
Subject: [PATCH] io-wq: check max_worker limits if a worker transitions bound
 state

For the two places where new workers are created, we diligently check if
we are allowed to create a new worker. If we're currently at the limit
of how many workers of a given type we can have, then we don't create
any new ones.

If you have a mixed workload with various types of bound and unbounded
work, then it can happen that a worker finishes one type of work and
is then transitioned to the other type. For this case, we don't check
if we are actually allowed to do so. This can cause io-wq to temporarily
exceed the allowed number of workers for a given type.

When retrieving work, check that the types match. If they don't, check
if we are allowed to transition to the other type. If not, then don't
handle the new work.

Cc: stable@vger.kernel.org
Reported-by: Johannes Lundberg <johalun0@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 4b5fc621ab39..da3ad45028f9 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -424,7 +424,28 @@ static void io_wait_on_hash(struct io_wqe *wqe, unsigned int hash)
 	spin_unlock(&wq->hash->wait.lock);
 }
 
-static struct io_wq_work *io_get_next_work(struct io_wqe *wqe)
+/*
+ * We can always run the work if the worker is currently the same type as
+ * the work (eg both are bound, or both are unbound). If they are not the
+ * same, only allow it if incrementing the worker count would be allowed.
+ */
+static bool io_worker_can_run_work(struct io_worker *worker,
+				   struct io_wq_work *work)
+{
+	struct io_wqe_acct *acct;
+
+	if (!(worker->flags & IO_WORKER_F_BOUND) !=
+	    !(work->flags & IO_WQ_WORK_UNBOUND))
+		return true;
+
+	/* not the same type, check if we'd go over the limit */
+	acct = io_work_get_acct(worker->wqe, work);
+	return acct->nr_workers < acct->max_workers;
+}
+
+static struct io_wq_work *io_get_next_work(struct io_wqe *wqe,
+					   struct io_worker *worker,
+					   bool *stalled)
 	__must_hold(wqe->lock)
 {
 	struct io_wq_work_node *node, *prev;
@@ -436,6 +457,9 @@ static struct io_wq_work *io_get_next_work(struct io_wqe *wqe)
 
 		work = container_of(node, struct io_wq_work, list);
 
+		if (!io_worker_can_run_work(worker, work))
+			break;
+
 		/* not hashed, can run anytime */
 		if (!io_wq_is_hashed(work)) {
 			wq_list_del(&wqe->work_list, node, prev);
@@ -462,6 +486,7 @@ static struct io_wq_work *io_get_next_work(struct io_wqe *wqe)
 		raw_spin_unlock(&wqe->lock);
 		io_wait_on_hash(wqe, stall_hash);
 		raw_spin_lock(&wqe->lock);
+		*stalled = true;
 	}
 
 	return NULL;
@@ -501,6 +526,7 @@ static void io_worker_handle_work(struct io_worker *worker)
 
 	do {
 		struct io_wq_work *work;
+		bool stalled;
 get_next:
 		/*
 		 * If we got some work, mark us as busy. If we didn't, but
@@ -509,10 +535,11 @@ static void io_worker_handle_work(struct io_worker *worker)
 		 * can't make progress, any work completion or insertion will
 		 * clear the stalled flag.
 		 */
-		work = io_get_next_work(wqe);
+		stalled = false;
+		work = io_get_next_work(wqe, worker, &stalled);
 		if (work)
 			__io_worker_busy(wqe, worker, work);
-		else if (!wq_list_empty(&wqe->work_list))
+		else if (stalled)
 			wqe->flags |= IO_WQE_FLAG_STALLED;
 
 		raw_spin_unlock_irq(&wqe->lock);

