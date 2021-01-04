Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4EC2EA0D5
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 00:32:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727209AbhADXbP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 18:31:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726930AbhADXbO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jan 2021 18:31:14 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E52DC061793;
        Mon,  4 Jan 2021 15:30:34 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id a6so738602wmc.2;
        Mon, 04 Jan 2021 15:30:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AT0KaanAHQpX/yi7u0zSE1SQN69yvyDd46YRWgQ6kQs=;
        b=gsd0c/UlNljEANw7TjEIu4gwDWDenqLgI1VUVGfaDuJf5c2CW2TIJIlZAJy+1Hgzhg
         h+ttPqZY8WdsZI2Iz9R3lA4AE7oytyLRXZF5t0lsb8j2UbXUMrWxt4nuq3gJtcdNohZc
         lXI6mJ4wd7uxPkfoKXSYBODV9vuSgR+yAhLrTAjIdVnpKTEIkoHMW9YEWA7KHKoqAiEo
         O+sAfPN/pu5UR1MctNSniPcu+0PWvQ7tcbjarCbC8btiWvahMCamiNz6IRX53VB5kR+D
         4JvFl8C4hOhLJgQigeP0TSFWWvEmdFu/b6o0YUhEKjFJu4rq4TibaUyxjQMNUHBGXb/G
         bEBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AT0KaanAHQpX/yi7u0zSE1SQN69yvyDd46YRWgQ6kQs=;
        b=ggAVzX59LFG0+HuHY6hWqOLfisAev1nBHleFZjJ0sVF2WGiBy2DRUJPPaBOyQ/Hjdh
         bU9Flg/xaZ3aHqewVV2lKf3q6SdoSSaYeobmFuNXwE1y1gBcT449Ces21WFfoNb19ZQI
         aUJypx5SbwLaSrKyJhLvBKhupoy9Pf+vU9U8BPTR7U0scI7QqKIOwZb6UrcdO7PX5/E2
         6Z6olxtbqMiDQtaF1+ktMDqB5qFY16du46LrL1H9cy+/sJRs1zM/hLbOP6iW0eqmo9fT
         7YNtuuK7BWdk8Av9OmJ7W86Dl3QwwkKv0GfongqMqnGiSyBF1d5bjLnqRB/5cI+od0dF
         icYA==
X-Gm-Message-State: AOAM531xuro02XtWQMDhmzFHKCsM3/abULQAXGJKvs2HDtra1BmvusFT
        nqMybBJHFsn7r7kcsSxV6WwxfSvn0kGFKQ==
X-Google-Smtp-Source: ABdhPJw0Md6WprYfcBGMCMVJ86M0wOizibVI8Ao//VpdFaKAwgfDqvcqBbAkb6gMdqEPyo4fNq8m5g==
X-Received: by 2002:a1c:5406:: with SMTP id i6mr527234wmb.137.1609792814179;
        Mon, 04 Jan 2021 12:40:14 -0800 (PST)
Received: from localhost.localdomain ([85.255.233.205])
        by smtp.gmail.com with ESMTPSA id w21sm734483wmi.45.2021.01.04.12.40.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 12:40:13 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH v3 2/2] io_uring: patch up IOPOLL overflow_flush sync
Date:   Mon,  4 Jan 2021 20:36:36 +0000
Message-Id: <b11b0ab3920e4da79ce54e565cfb2b7f4ebbc0d3.1609789890.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1609789890.git.asml.silence@gmail.com>
References: <cover.1609789890.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

IOPOLL skips completion locking but keeps it under uring_lock, thus
io_cqring_overflow_flush() and so io_cqring_events() need additional
locking with uring_lock in some cases for IOPOLL.

Remove __io_cqring_overflow_flush() from io_cqring_events(), introduce a
wrapper around flush doing needed synchronisation and call it by hand.

Cc: stable@vger.kernel.org # 5.5+
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 78 +++++++++++++++++++++++++++------------------------
 1 file changed, 41 insertions(+), 37 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5be33fd8b6bc..445035b24a50 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1713,9 +1713,9 @@ static void io_cqring_ev_posted(struct io_ring_ctx *ctx)
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
@@ -1768,6 +1768,20 @@ static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force,
 	return all_flushed;
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
@@ -2314,20 +2328,8 @@ static void io_double_put_req(struct io_kiocb *req)
 		io_free_req(req);
 }
 
-static unsigned io_cqring_events(struct io_ring_ctx *ctx, bool noflush)
+static unsigned io_cqring_events(struct io_ring_ctx *ctx)
 {
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
 	return __io_cqring_events(ctx);
@@ -2552,7 +2554,9 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
 		 * If we do, we can potentially be spinning for commands that
 		 * already triggered a CQE (eg in error).
 		 */
-		if (io_cqring_events(ctx, false))
+		if (test_bit(0, &ctx->cq_check_overflow))
+			__io_cqring_overflow_flush(ctx, false, NULL, NULL);
+		if (io_cqring_events(ctx))
 			break;
 
 		/*
@@ -6827,7 +6831,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 
 	/* if we have a backlog and couldn't flush it all, return BUSY */
 	if (test_bit(0, &ctx->sq_check_overflow)) {
-		if (!io_cqring_overflow_flush(ctx, false, NULL, NULL))
+		if (!__io_cqring_overflow_flush(ctx, false, NULL, NULL))
 			return -EBUSY;
 	}
 
@@ -7090,7 +7094,7 @@ struct io_wait_queue {
 	unsigned nr_timeouts;
 };
 
-static inline bool io_should_wake(struct io_wait_queue *iowq, bool noflush)
+static inline bool io_should_wake(struct io_wait_queue *iowq)
 {
 	struct io_ring_ctx *ctx = iowq->ctx;
 
@@ -7099,7 +7103,7 @@ static inline bool io_should_wake(struct io_wait_queue *iowq, bool noflush)
 	 * started waiting. For timeouts, we always want to return to userspace,
 	 * regardless of event count.
 	 */
-	return io_cqring_events(ctx, noflush) >= iowq->to_wait ||
+	return io_cqring_events(ctx) >= iowq->to_wait ||
 			atomic_read(&ctx->cq_timeouts) != iowq->nr_timeouts;
 }
 
@@ -7109,11 +7113,13 @@ static int io_wake_function(struct wait_queue_entry *curr, unsigned int mode,
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
@@ -7150,7 +7156,8 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 	int ret = 0;
 
 	do {
-		if (io_cqring_events(ctx, false) >= min_events)
+		io_cqring_overflow_flush(ctx, false, NULL, NULL);
+		if (io_cqring_events(ctx) >= min_events)
 			return 0;
 		if (!io_run_task_work())
 			break;
@@ -7178,6 +7185,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 	iowq.nr_timeouts = atomic_read(&ctx->cq_timeouts);
 	trace_io_uring_cqring_wait(ctx, min_events);
 	do {
+		io_cqring_overflow_flush(ctx, false, NULL, NULL);
 		prepare_to_wait_exclusive(&ctx->wait, &iowq.wq,
 						TASK_INTERRUPTIBLE);
 		/* make sure we run task_work before checking for signals */
@@ -7186,8 +7194,10 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 			continue;
 		else if (ret < 0)
 			break;
-		if (io_should_wake(&iowq, false))
+		if (io_should_wake(&iowq))
 			break;
+		if (test_bit(0, &ctx->cq_check_overflow))
+			continue;
 		if (uts) {
 			timeout = schedule_timeout(timeout);
 			if (timeout == 0) {
@@ -8625,7 +8635,8 @@ static __poll_t io_uring_poll(struct file *file, poll_table *wait)
 	smp_rmb();
 	if (!io_sqring_full(ctx))
 		mask |= EPOLLOUT | EPOLLWRNORM;
-	if (io_cqring_events(ctx, false))
+	io_cqring_overflow_flush(ctx, false, NULL, NULL);
+	if (io_cqring_events(ctx))
 		mask |= EPOLLIN | EPOLLRDNORM;
 
 	return mask;
@@ -8683,7 +8694,7 @@ static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 	/* if force is set, the ring is going away. always drop after that */
 	ctx->cq_overflow_flushed = 1;
 	if (ctx->rings)
-		io_cqring_overflow_flush(ctx, true, NULL, NULL);
+		__io_cqring_overflow_flush(ctx, true, NULL, NULL);
 	mutex_unlock(&ctx->uring_lock);
 
 	io_kill_timeouts(ctx, NULL, NULL);
@@ -8857,9 +8868,7 @@ static void io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
 	}
 
 	io_cancel_defer_files(ctx, task, files);
-	io_ring_submit_lock(ctx, (ctx->flags & IORING_SETUP_IOPOLL));
 	io_cqring_overflow_flush(ctx, true, task, files);
-	io_ring_submit_unlock(ctx, (ctx->flags & IORING_SETUP_IOPOLL));
 
 	if (!files)
 		__io_uring_cancel_task_requests(ctx, task);
@@ -9195,13 +9204,8 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
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
2.24.0

