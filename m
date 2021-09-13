Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4B3409609
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346073AbhIMOrV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:47:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:60464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346227AbhIMOpS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:45:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07946619EA;
        Mon, 13 Sep 2021 13:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541494;
        bh=PEzcHtqFC7oZw+xmy2y2rPKeywLpKGwnMwJK2w7KoW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vQN8KgS5o/kVRuz5oBjxecae4rTzDFRqo4EseToe28dnuW3bYpdCapPx31na0isCu
         qhRNND7deSq2mWs56tYoad8pPg+985eSrV6vCKNCI1zAk506ap0K99DWWY/slbLIxD
         O4Y0I5Q/++m3A/k/4IvyL6gBtY+lM+o3gZgmzPu4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Lundberg <johalun0@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.14 320/334] io-wq: check max_worker limits if a worker transitions bound state
Date:   Mon, 13 Sep 2021 15:16:14 +0200
Message-Id: <20210913131124.247988603@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit ecc53c48c13d995e6fe5559e30ffee48d92784fd upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io-wq.c |   33 ++++++++++++++++++++++++++++++---
 1 file changed, 30 insertions(+), 3 deletions(-)

--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -423,7 +423,28 @@ static void io_wait_on_hash(struct io_wq
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
@@ -435,6 +456,9 @@ static struct io_wq_work *io_get_next_wo
 
 		work = container_of(node, struct io_wq_work, list);
 
+		if (!io_worker_can_run_work(worker, work))
+			break;
+
 		/* not hashed, can run anytime */
 		if (!io_wq_is_hashed(work)) {
 			wq_list_del(&wqe->work_list, node, prev);
@@ -461,6 +485,7 @@ static struct io_wq_work *io_get_next_wo
 		raw_spin_unlock(&wqe->lock);
 		io_wait_on_hash(wqe, stall_hash);
 		raw_spin_lock(&wqe->lock);
+		*stalled = true;
 	}
 
 	return NULL;
@@ -500,6 +525,7 @@ static void io_worker_handle_work(struct
 
 	do {
 		struct io_wq_work *work;
+		bool stalled;
 get_next:
 		/*
 		 * If we got some work, mark us as busy. If we didn't, but
@@ -508,10 +534,11 @@ get_next:
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


