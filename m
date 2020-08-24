Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3CA24F4B9
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 10:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbgHXIju (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:39:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:56036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728057AbgHXIjs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:39:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F21D52177B;
        Mon, 24 Aug 2020 08:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258387;
        bh=AY1Wd5d8rcsxrNNRZxVaVVoFUSHtlLhCmreUEkQy4Wc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZRYqmYSFyJkHmSJqH6JmvZZ28h4AZs1zilEcPkSzWgv4y1yrFo/S6+CqLqcfOmldC
         u6v4B0rXqCelEcbLoRwtJPM3EZwZ49kydxgwtt0CstkZIXrohTlbxATVE8D4KcRwD/
         12FISmJ6p/5XUkHRxaC1yTx+aWPHcks1bL9wccg0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 029/124] io-wq: add an option to cancel all matched reqs
Date:   Mon, 24 Aug 2020 10:29:23 +0200
Message-Id: <20200824082410.846221778@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082409.368269240@linuxfoundation.org>
References: <20200824082409.368269240@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 4f26bda1522c35d2701fc219368c7101c17005c1 ]

This adds support for cancelling all io-wq works matching a predicate.
It isn't used yet, so no change in observable behaviour.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io-wq.c    | 60 +++++++++++++++++++++++++++++----------------------
 fs/io-wq.h    |  2 +-
 fs/io_uring.c |  2 +-
 3 files changed, 36 insertions(+), 28 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 3283f8c5b5a18..6d2e8ccc229e3 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -907,13 +907,15 @@ void io_wq_cancel_all(struct io_wq *wq)
 struct io_cb_cancel_data {
 	work_cancel_fn *fn;
 	void *data;
+	int nr_running;
+	int nr_pending;
+	bool cancel_all;
 };
 
 static bool io_wq_worker_cancel(struct io_worker *worker, void *data)
 {
 	struct io_cb_cancel_data *match = data;
 	unsigned long flags;
-	bool ret = false;
 
 	/*
 	 * Hold the lock to avoid ->cur_work going out of scope, caller
@@ -924,55 +926,55 @@ static bool io_wq_worker_cancel(struct io_worker *worker, void *data)
 	    !(worker->cur_work->flags & IO_WQ_WORK_NO_CANCEL) &&
 	    match->fn(worker->cur_work, match->data)) {
 		send_sig(SIGINT, worker->task, 1);
-		ret = true;
+		match->nr_running++;
 	}
 	spin_unlock_irqrestore(&worker->lock, flags);
 
-	return ret;
+	return match->nr_running && !match->cancel_all;
 }
 
-static bool io_wqe_cancel_pending_work(struct io_wqe *wqe,
+static void io_wqe_cancel_pending_work(struct io_wqe *wqe,
 				       struct io_cb_cancel_data *match)
 {
 	struct io_wq_work_node *node, *prev;
 	struct io_wq_work *work;
 	unsigned long flags;
-	bool found = false;
 
+retry:
 	spin_lock_irqsave(&wqe->lock, flags);
 	wq_list_for_each(node, prev, &wqe->work_list) {
 		work = container_of(node, struct io_wq_work, list);
+		if (!match->fn(work, match->data))
+			continue;
 
-		if (match->fn(work, match->data)) {
-			wq_list_del(&wqe->work_list, node, prev);
-			found = true;
-			break;
-		}
+		wq_list_del(&wqe->work_list, node, prev);
+		spin_unlock_irqrestore(&wqe->lock, flags);
+		io_run_cancel(work, wqe);
+		match->nr_pending++;
+		if (!match->cancel_all)
+			return;
+
+		/* not safe to continue after unlock */
+		goto retry;
 	}
 	spin_unlock_irqrestore(&wqe->lock, flags);
-
-	if (found)
-		io_run_cancel(work, wqe);
-	return found;
 }
 
-static bool io_wqe_cancel_running_work(struct io_wqe *wqe,
+static void io_wqe_cancel_running_work(struct io_wqe *wqe,
 				       struct io_cb_cancel_data *match)
 {
-	bool found;
-
 	rcu_read_lock();
-	found = io_wq_for_each_worker(wqe, io_wq_worker_cancel, match);
+	io_wq_for_each_worker(wqe, io_wq_worker_cancel, match);
 	rcu_read_unlock();
-	return found;
 }
 
 enum io_wq_cancel io_wq_cancel_cb(struct io_wq *wq, work_cancel_fn *cancel,
-				  void *data)
+				  void *data, bool cancel_all)
 {
 	struct io_cb_cancel_data match = {
-		.fn	= cancel,
-		.data	= data,
+		.fn		= cancel,
+		.data		= data,
+		.cancel_all	= cancel_all,
 	};
 	int node;
 
@@ -984,7 +986,8 @@ enum io_wq_cancel io_wq_cancel_cb(struct io_wq *wq, work_cancel_fn *cancel,
 	for_each_node(node) {
 		struct io_wqe *wqe = wq->wqes[node];
 
-		if (io_wqe_cancel_pending_work(wqe, &match))
+		io_wqe_cancel_pending_work(wqe, &match);
+		if (match.nr_pending && !match.cancel_all)
 			return IO_WQ_CANCEL_OK;
 	}
 
@@ -997,10 +1000,15 @@ enum io_wq_cancel io_wq_cancel_cb(struct io_wq *wq, work_cancel_fn *cancel,
 	for_each_node(node) {
 		struct io_wqe *wqe = wq->wqes[node];
 
-		if (io_wqe_cancel_running_work(wqe, &match))
+		io_wqe_cancel_running_work(wqe, &match);
+		if (match.nr_running && !match.cancel_all)
 			return IO_WQ_CANCEL_RUNNING;
 	}
 
+	if (match.nr_running)
+		return IO_WQ_CANCEL_RUNNING;
+	if (match.nr_pending)
+		return IO_WQ_CANCEL_OK;
 	return IO_WQ_CANCEL_NOTFOUND;
 }
 
@@ -1011,7 +1019,7 @@ static bool io_wq_io_cb_cancel_data(struct io_wq_work *work, void *data)
 
 enum io_wq_cancel io_wq_cancel_work(struct io_wq *wq, struct io_wq_work *cwork)
 {
-	return io_wq_cancel_cb(wq, io_wq_io_cb_cancel_data, (void *)cwork);
+	return io_wq_cancel_cb(wq, io_wq_io_cb_cancel_data, (void *)cwork, false);
 }
 
 static bool io_wq_pid_match(struct io_wq_work *work, void *data)
@@ -1025,7 +1033,7 @@ enum io_wq_cancel io_wq_cancel_pid(struct io_wq *wq, pid_t pid)
 {
 	void *data = (void *) (unsigned long) pid;
 
-	return io_wq_cancel_cb(wq, io_wq_pid_match, data);
+	return io_wq_cancel_cb(wq, io_wq_pid_match, data, false);
 }
 
 struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
diff --git a/fs/io-wq.h b/fs/io-wq.h
index 5ba12de7572f0..8902903831f25 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -134,7 +134,7 @@ enum io_wq_cancel io_wq_cancel_pid(struct io_wq *wq, pid_t pid);
 typedef bool (work_cancel_fn)(struct io_wq_work *, void *);
 
 enum io_wq_cancel io_wq_cancel_cb(struct io_wq *wq, work_cancel_fn *cancel,
-					void *data);
+					void *data, bool cancel_all);
 
 struct task_struct *io_wq_get_task(struct io_wq *wq);
 
diff --git a/fs/io_uring.c b/fs/io_uring.c
index b33d4a97a8774..cf32705546773 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5023,7 +5023,7 @@ static int io_async_cancel_one(struct io_ring_ctx *ctx, void *sqe_addr)
 	enum io_wq_cancel cancel_ret;
 	int ret = 0;
 
-	cancel_ret = io_wq_cancel_cb(ctx->io_wq, io_cancel_cb, sqe_addr);
+	cancel_ret = io_wq_cancel_cb(ctx->io_wq, io_cancel_cb, sqe_addr, false);
 	switch (cancel_ret) {
 	case IO_WQ_CANCEL_OK:
 		ret = 0;
-- 
2.25.1



