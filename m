Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1F12F3D91
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 01:44:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438014AbhALVhE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 16:37:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437150AbhALVVz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jan 2021 16:21:55 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA68DC061795
        for <stable@vger.kernel.org>; Tue, 12 Jan 2021 13:21:14 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id c124so3149511wma.5
        for <stable@vger.kernel.org>; Tue, 12 Jan 2021 13:21:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VKdW4WkmrvRNVM/Vb5+GBiSNUwdBp53cxZDvRw7T1J8=;
        b=j0ol5F01puV6aJKdp3QZdw9IlKnKpA3ZMWXbyJe6/LUTijPyedgIk0XMPziDKzP8Cl
         qcQXiNPj2B88itO+FaPq4y7BhVCHMgOGqDzAi8/kxAvETxKyBFgBq5EIaINHW+tTxkvm
         iLcAsH7ob0NqHTpZlPC0ANh2tiOQIQB/W2WDz3kFLICzVDAt7dsGiNALVyVGY3gg/KQb
         MkOLNU5AOeO5CTeN23RzOTgN5QSghw6GevbeK4w7jCCQ7YwBsgAAu9rieRdzrRMcGDre
         sDP1Imz7xGQd0g+yp8bRq44isv94I88dpFAgC0QYeXUcoJnho/h5Dzi+8eJ5iPPCs5/x
         8XMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VKdW4WkmrvRNVM/Vb5+GBiSNUwdBp53cxZDvRw7T1J8=;
        b=OM8y2kK0TvCTopDbxDPj4yz5hDfb8aGqGDjHrDWdjqI9x2nY0AzNT1Nr7Flv80J9Vp
         L6cWtUESxXCaJqWDS3e79E8zH9T5t7fFHOj3ld2gCZtskWl8ifZGJLAtyk66U6GaNY/Q
         6vM1axzKyp+fr0BafGsOgvDYtI60Kg2O1rSd6fQQYvF2YVb/qmRCJlyRmrN1uXDKXxL5
         7IBfn+detGis4H/XdH0xGbZKZyOYMVo05xfl7sXaj6GLduvQQLn1Nfc4thSvj8Eu3t7g
         +GL0NqakiVW3z2HOd84qe6AKz2CW01sYOG4q1dGaJ11zRagXNmVYibQBWCGf/7BIj3fS
         EBAQ==
X-Gm-Message-State: AOAM530huBItMnXyuWXP2GpyaAdUYXvOshBwakXguXtwG5GWQxFdMlKx
        JuL7mFblgj3Fptk4ZfN2JssL3KxcL+rPVw==
X-Google-Smtp-Source: ABdhPJxqobPcujkf8LJL8IzuocOy5n6J/PkoUrZnIY3uA3pZuuqvnruxLAgGBkrXVQ1JEybrjTzCIw==
X-Received: by 2002:a7b:ce17:: with SMTP id m23mr1027654wmc.117.1610486473558;
        Tue, 12 Jan 2021 13:21:13 -0800 (PST)
Received: from localhost.localdomain ([85.255.235.134])
        by smtp.gmail.com with ESMTPSA id y13sm7166093wrl.63.2021.01.12.13.21.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jan 2021 13:21:13 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10-stable 3/3] io_uring: patch up IOPOLL overflow_flush sync
Date:   Tue, 12 Jan 2021 21:17:26 +0000
Message-Id: <033b9defb5fbbf412675489fd1df42e7cbc1cd9a.1610485688.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1610485688.git.asml.silence@gmail.com>
References: <cover.1610485688.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 6c503150ae33ee19036255cfda0998463613352c upstream

IOPOLL skips completion locking but keeps it under uring_lock, thus
io_cqring_overflow_flush() and so io_cqring_events() need additional
locking with uring_lock in some cases for IOPOLL.

Remove __io_cqring_overflow_flush() from io_cqring_events(), introduce a
wrapper around flush doing needed synchronisation and call it by hand.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 78 +++++++++++++++++++++++++++------------------------
 1 file changed, 41 insertions(+), 37 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5ba312ab9978..492492a010a2 100644
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
2.24.0

