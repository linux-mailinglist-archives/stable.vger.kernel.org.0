Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B5932F7979
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:38:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387918AbhAOMhB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:37:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:43284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387914AbhAOMhA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:37:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F9CF23A75;
        Fri, 15 Jan 2021 12:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714204;
        bh=TFqjZ57Pmhq8srJH767p/dfTiVTkDuUr9be7WQ8AvSs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vv121lPPZUl7l1beROPElWWlmcmPersbQXY+Os+5tn8SHn+Wbgh1VMigw5iaMWPRq
         3U9rEzVJ1m+qWgI8Pccarz7P4wZqZZL742cM0qSdBP2QsDFaaJfJ46AJW2v8yy7Jf8
         N2Z+hFQ/kspg4o1X/asaLEd/FcxwaaNC0N9sQ1Jw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 004/103] io_uring: patch up IOPOLL overflow_flush sync
Date:   Fri, 15 Jan 2021 13:26:57 +0100
Message-Id: <20210115122006.268011559@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115122006.047132306@linuxfoundation.org>
References: <20210115122006.047132306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit 6c503150ae33ee19036255cfda0998463613352c upstream

IOPOLL skips completion locking but keeps it under uring_lock, thus
io_cqring_overflow_flush() and so io_cqring_events() need additional
locking with uring_lock in some cases for IOPOLL.

Remove __io_cqring_overflow_flush() from io_cqring_events(), introduce a
wrapper around flush doing needed synchronisation and call it by hand.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 78 +++++++++++++++++++++++++++------------------------
 1 file changed, 41 insertions(+), 37 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5ba312ab99786..492492a010a2f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1625,9 +1625,9 @@ static bool io_match_files(struct io_kiocb *req,
 }
 
 /* Returns true if there are no backlogged entries after the flush */
-static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force,
-				     struct task_struct *tsk,
-				     struct files_struct *files)
+static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force,
+				       struct task_struct *tsk,
+				       struct files_struct *files)
 {
 	struct io_rings *rings = ctx->rings;
 	struct io_kiocb *req, *tmp;
@@ -1681,6 +1681,20 @@ static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force,
 	return cqe != NULL;
 }
 
+static void io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force,
+				     struct task_struct *tsk,
+				     struct files_struct *files)
+{
+	if (test_bit(0, &ctx->cq_check_overflow)) {
+		/* iopoll syncs against uring_lock, not completion_lock */
+		if (ctx->flags & IORING_SETUP_IOPOLL)
+			mutex_lock(&ctx->uring_lock);
+		__io_cqring_overflow_flush(ctx, force, tsk, files);
+		if (ctx->flags & IORING_SETUP_IOPOLL)
+			mutex_unlock(&ctx->uring_lock);
+	}
+}
+
 static void __io_cqring_fill_event(struct io_kiocb *req, long res, long cflags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -2235,22 +2249,10 @@ static void io_double_put_req(struct io_kiocb *req)
 		io_free_req(req);
 }
 
-static unsigned io_cqring_events(struct io_ring_ctx *ctx, bool noflush)
+static unsigned io_cqring_events(struct io_ring_ctx *ctx)
 {
 	struct io_rings *rings = ctx->rings;
 
-	if (test_bit(0, &ctx->cq_check_overflow)) {
-		/*
-		 * noflush == true is from the waitqueue handler, just ensure
-		 * we wake up the task, and the next invocation will flush the
-		 * entries. We cannot safely to it from here.
-		 */
-		if (noflush)
-			return -1U;
-
-		io_cqring_overflow_flush(ctx, false, NULL, NULL);
-	}
-
 	/* See comment at the top of this file */
 	smp_rmb();
 	return ctx->cached_cq_tail - READ_ONCE(rings->cq.head);
@@ -2475,7 +2477,9 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
 		 * If we do, we can potentially be spinning for commands that
 		 * already triggered a CQE (eg in error).
 		 */
-		if (io_cqring_events(ctx, false))
+		if (test_bit(0, &ctx->cq_check_overflow))
+			__io_cqring_overflow_flush(ctx, false, NULL, NULL);
+		if (io_cqring_events(ctx))
 			break;
 
 		/*
@@ -6578,7 +6582,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 
 	/* if we have a backlog and couldn't flush it all, return BUSY */
 	if (test_bit(0, &ctx->sq_check_overflow)) {
-		if (!io_cqring_overflow_flush(ctx, false, NULL, NULL))
+		if (!__io_cqring_overflow_flush(ctx, false, NULL, NULL))
 			return -EBUSY;
 	}
 
@@ -6867,7 +6871,7 @@ struct io_wait_queue {
 	unsigned nr_timeouts;
 };
 
-static inline bool io_should_wake(struct io_wait_queue *iowq, bool noflush)
+static inline bool io_should_wake(struct io_wait_queue *iowq)
 {
 	struct io_ring_ctx *ctx = iowq->ctx;
 
@@ -6876,7 +6880,7 @@ static inline bool io_should_wake(struct io_wait_queue *iowq, bool noflush)
 	 * started waiting. For timeouts, we always want to return to userspace,
 	 * regardless of event count.
 	 */
-	return io_cqring_events(ctx, noflush) >= iowq->to_wait ||
+	return io_cqring_events(ctx) >= iowq->to_wait ||
 			atomic_read(&ctx->cq_timeouts) != iowq->nr_timeouts;
 }
 
@@ -6886,11 +6890,13 @@ static int io_wake_function(struct wait_queue_entry *curr, unsigned int mode,
 	struct io_wait_queue *iowq = container_of(curr, struct io_wait_queue,
 							wq);
 
-	/* use noflush == true, as we can't safely rely on locking context */
-	if (!io_should_wake(iowq, true))
-		return -1;
-
-	return autoremove_wake_function(curr, mode, wake_flags, key);
+	/*
+	 * Cannot safely flush overflowed CQEs from here, ensure we wake up
+	 * the task, and the next invocation will do it.
+	 */
+	if (io_should_wake(iowq) || test_bit(0, &iowq->ctx->cq_check_overflow))
+		return autoremove_wake_function(curr, mode, wake_flags, key);
+	return -1;
 }
 
 static int io_run_task_work_sig(void)
@@ -6929,7 +6935,8 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 	int ret = 0;
 
 	do {
-		if (io_cqring_events(ctx, false) >= min_events)
+		io_cqring_overflow_flush(ctx, false, NULL, NULL);
+		if (io_cqring_events(ctx) >= min_events)
 			return 0;
 		if (!io_run_task_work())
 			break;
@@ -6951,6 +6958,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 	iowq.nr_timeouts = atomic_read(&ctx->cq_timeouts);
 	trace_io_uring_cqring_wait(ctx, min_events);
 	do {
+		io_cqring_overflow_flush(ctx, false, NULL, NULL);
 		prepare_to_wait_exclusive(&ctx->wait, &iowq.wq,
 						TASK_INTERRUPTIBLE);
 		/* make sure we run task_work before checking for signals */
@@ -6959,8 +6967,10 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 			continue;
 		else if (ret < 0)
 			break;
-		if (io_should_wake(&iowq, false))
+		if (io_should_wake(&iowq))
 			break;
+		if (test_bit(0, &ctx->cq_check_overflow))
+			continue;
 		schedule();
 	} while (1);
 	finish_wait(&ctx->wait, &iowq.wq);
@@ -8385,7 +8395,8 @@ static __poll_t io_uring_poll(struct file *file, poll_table *wait)
 	smp_rmb();
 	if (!io_sqring_full(ctx))
 		mask |= EPOLLOUT | EPOLLWRNORM;
-	if (io_cqring_events(ctx, false))
+	io_cqring_overflow_flush(ctx, false, NULL, NULL);
+	if (io_cqring_events(ctx))
 		mask |= EPOLLIN | EPOLLRDNORM;
 
 	return mask;
@@ -8443,7 +8454,7 @@ static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 	/* if force is set, the ring is going away. always drop after that */
 	ctx->cq_overflow_flushed = 1;
 	if (ctx->rings)
-		io_cqring_overflow_flush(ctx, true, NULL, NULL);
+		__io_cqring_overflow_flush(ctx, true, NULL, NULL);
 	mutex_unlock(&ctx->uring_lock);
 
 	io_kill_timeouts(ctx, NULL);
@@ -8716,9 +8727,7 @@ static void io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
 	}
 
 	io_cancel_defer_files(ctx, task, files);
-	io_ring_submit_lock(ctx, (ctx->flags & IORING_SETUP_IOPOLL));
 	io_cqring_overflow_flush(ctx, true, task, files);
-	io_ring_submit_unlock(ctx, (ctx->flags & IORING_SETUP_IOPOLL));
 
 	while (__io_uring_cancel_task_requests(ctx, task, files)) {
 		io_run_task_work();
@@ -9024,13 +9033,8 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 	 */
 	ret = 0;
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
-		if (!list_empty_careful(&ctx->cq_overflow_list)) {
-			bool needs_lock = ctx->flags & IORING_SETUP_IOPOLL;
+		io_cqring_overflow_flush(ctx, false, NULL, NULL);
 
-			io_ring_submit_lock(ctx, needs_lock);
-			io_cqring_overflow_flush(ctx, false, NULL, NULL);
-			io_ring_submit_unlock(ctx, needs_lock);
-		}
 		if (flags & IORING_ENTER_SQ_WAKEUP)
 			wake_up(&ctx->sq_data->wait);
 		if (flags & IORING_ENTER_SQ_WAIT)
-- 
2.27.0



