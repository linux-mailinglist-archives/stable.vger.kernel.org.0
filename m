Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42D5E303B78
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 12:23:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392330AbhAZLWn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 06:22:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392304AbhAZLVo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jan 2021 06:21:44 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B66E5C0613ED
        for <stable@vger.kernel.org>; Tue, 26 Jan 2021 03:21:03 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id bx12so19260145edb.8
        for <stable@vger.kernel.org>; Tue, 26 Jan 2021 03:21:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7/1fbzJNHjtwlf7qCbLHZQFGUrVOA3+SGTkQr7SgJH0=;
        b=TQCbK9KRzVURYJdyiTHTOFPuk5nC51Bph7wARDKZMo85/kp0ZV64O2hxZG6cxRs7Z5
         ucMTjVbsbH15fsDbjQzsui76ExJN94UU6PsQIaVwV2NeoR1fKz5k4rXNEhATnTliNFk4
         JkFeu5dgUU0jG03kRNKv4t1gwmPnZ6fV9kPLg+UkfXXVlBMWIbmp7TF7e4w8e2N8Drya
         Q4s1G8TztRaTTjr49x1asb7bcEtO+xw/6dDiA0qSr5urbnrL993l5Om87ziBLaH2f1uv
         AnIWfNVn9wYcO35puvlbItY+3oFtXPWA1zPQsrbQQT2zC550Zma9c2mXrhg9gRuMHaBr
         dOlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7/1fbzJNHjtwlf7qCbLHZQFGUrVOA3+SGTkQr7SgJH0=;
        b=jkhlZtbSyiVasz9KdNCgEIUPK7u0TycLi7DHozjuu42GCt90pJIDQTQLNA5SOUj0zF
         KBn1kXruOzSCsCJohwtwODyRuTCTpL6pYAkhm9xjh0JpP/JJsLKdAQk7F5GUM11zQyMw
         GSGxmTX6BFCzAIPJQRIcZQwp9GD9ep74QtsnJ0dOgC/jT9lQFP3kovWoDi1IybVNP4if
         lUUW5ODKuniTSyRvbL+2DEEaSfhv+EEwZGlqQaS/FHKAb37UrpPOfEIhZk5iU+zS70J1
         +xShu/fChwZa0gOR8fhc26xCHNnF5wSqpmRmXp4hUiTCI3Om4fz4kuJwU4U1VPLDAzsf
         ++Hg==
X-Gm-Message-State: AOAM533tj5ECDu7kIaW0yT11Qf5ul1Swcjg/Z//REAJcXEmuW9YFyYSa
        yxejoyRQIDCOpoEjFhgl/YS28LMpHsIEEw==
X-Google-Smtp-Source: ABdhPJyUozs0/b4Sj/4sFeYd3Y9W23s6exl9AGUNx1pN5BwzrZjroLLtV/SOcOiArW8y5u0tKsiRJA==
X-Received: by 2002:a05:6402:1398:: with SMTP id b24mr4005952edv.108.1611660062183;
        Tue, 26 Jan 2021 03:21:02 -0800 (PST)
Received: from localhost.localdomain ([148.252.129.161])
        by smtp.gmail.com with ESMTPSA id o17sm12167128edr.17.2021.01.26.03.21.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 03:21:01 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH stable 04/11] io_uring: stop SQPOLL submit on creator's death
Date:   Tue, 26 Jan 2021 11:17:03 +0000
Message-Id: <ae5ab03b2e1c4e7ffde7dea41b5e5849e62ebafb.1611659564.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1611659564.git.asml.silence@gmail.com>
References: <cover.1611659564.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit d9d05217cb6990b9a56e13b56e7a1b71e2551f6c ]

When the creator of SQPOLL io_uring dies (i.e. sqo_task), we don't want
its internals like ->files and ->mm to be poked by the SQPOLL task, it
have never been nice and recently got racy. That can happen when the
owner undergoes destruction and SQPOLL tasks tries to submit new
requests in parallel, and so calls io_sq_thread_acquire*().

That patch halts SQPOLL submissions when sqo_task dies by introducing
sqo_dead flag. Once set, the SQPOLL task must not do any submission,
which is synchronised by uring_lock as well as the new flag.

The tricky part is to make sure that disabling always happens, that
means either the ring is discovered by creator's do_exit() -> cancel,
or if the final close() happens before it's done by the creator. The
last is guaranteed by the fact that for SQPOLL the creator task and only
it holds exactly one file note, so either it pins up to do_exit() or
removed by the creator on the final put in flush. (see comments in
uring_flush() around file->f_count == 2).

One more place that can trigger io_sq_thread_acquire_*() is
__io_req_task_submit(). Shoot off requests on sqo_dead there, even
though actually we don't need to. That's because cancellation of
sqo_task should wait for the request before going any further.

note 1: io_disable_sqo_submit() does io_ring_set_wakeup_flag() so the
caller would enter the ring to get an error, but it still doesn't
guarantee that the flag won't be cleared.

note 2: if final __userspace__ close happens not from the creator
task, the file note will pin the ring until the task dies.

Cc: stable@vger.kernel.org # 5.5+
Fixed: b1b6b5a30dce8 ("kernel/io_uring: cancel io_uring before task works")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 58 ++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 50 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4dfba3d44a3c..723e1eb5349a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -260,6 +260,7 @@ struct io_ring_ctx {
 		unsigned int		drain_next: 1;
 		unsigned int		eventfd_async: 1;
 		unsigned int		restricted: 1;
+		unsigned int		sqo_dead: 1;
 
 		/*
 		 * Ring buffer of indices into array of io_uring_sqe, which is
@@ -2063,11 +2064,9 @@ static void io_req_task_cancel(struct callback_head *cb)
 static void __io_req_task_submit(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	bool fail;
 
-	fail = __io_sq_thread_acquire_mm(ctx);
 	mutex_lock(&ctx->uring_lock);
-	if (!fail)
+	if (!ctx->sqo_dead && !__io_sq_thread_acquire_mm(ctx))
 		__io_queue_sqe(req, NULL);
 	else
 		__io_req_task_cancel(req, -EFAULT);
@@ -6765,7 +6764,7 @@ static enum sq_ret __io_sq_thread(struct io_ring_ctx *ctx,
 		to_submit = 8;
 
 	mutex_lock(&ctx->uring_lock);
-	if (likely(!percpu_ref_is_dying(&ctx->refs)))
+	if (likely(!percpu_ref_is_dying(&ctx->refs) && !ctx->sqo_dead))
 		ret = io_submit_sqes(ctx, to_submit);
 	mutex_unlock(&ctx->uring_lock);
 
@@ -8456,6 +8455,10 @@ static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 	mutex_lock(&ctx->uring_lock);
 	percpu_ref_kill(&ctx->refs);
 	/* if force is set, the ring is going away. always drop after that */
+
+	if (WARN_ON_ONCE((ctx->flags & IORING_SETUP_SQPOLL) && !ctx->sqo_dead))
+		ctx->sqo_dead = 1;
+
 	ctx->cq_overflow_flushed = 1;
 	if (ctx->rings)
 		__io_cqring_overflow_flush(ctx, true, NULL, NULL);
@@ -8714,6 +8717,18 @@ static bool __io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
 	return ret;
 }
 
+static void io_disable_sqo_submit(struct io_ring_ctx *ctx)
+{
+	WARN_ON_ONCE(ctx->sqo_task != current);
+
+	mutex_lock(&ctx->uring_lock);
+	ctx->sqo_dead = 1;
+	mutex_unlock(&ctx->uring_lock);
+
+	/* make sure callers enter the ring to get error */
+	io_ring_set_wakeup_flag(ctx);
+}
+
 /*
  * We need to iteratively cancel requests, in case a request has dependent
  * hard links. These persist even for failure of cancelations, hence keep
@@ -8725,6 +8740,8 @@ static void io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
 	struct task_struct *task = current;
 
 	if ((ctx->flags & IORING_SETUP_SQPOLL) && ctx->sq_data) {
+		/* for SQPOLL only sqo_task has task notes */
+		io_disable_sqo_submit(ctx);
 		task = ctx->sq_data->thread;
 		atomic_inc(&task->io_uring->in_idle);
 		io_sq_thread_park(ctx->sq_data);
@@ -8896,6 +8913,7 @@ void __io_uring_task_cancel(void)
 static int io_uring_flush(struct file *file, void *data)
 {
 	struct io_uring_task *tctx = current->io_uring;
+	struct io_ring_ctx *ctx = file->private_data;
 
 	if (!tctx)
 		return 0;
@@ -8911,7 +8929,16 @@ static int io_uring_flush(struct file *file, void *data)
 	if (atomic_long_read(&file->f_count) != 2)
 		return 0;
 
-	io_uring_del_task_file(file);
+	if (ctx->flags & IORING_SETUP_SQPOLL) {
+		/* there is only one file note, which is owned by sqo_task */
+		WARN_ON_ONCE((ctx->sqo_task == current) ==
+			     !xa_load(&tctx->xa, (unsigned long)file));
+
+		io_disable_sqo_submit(ctx);
+	}
+
+	if (!(ctx->flags & IORING_SETUP_SQPOLL) || ctx->sqo_task == current)
+		io_uring_del_task_file(file);
 	return 0;
 }
 
@@ -8985,8 +9012,9 @@ static unsigned long io_uring_nommu_get_unmapped_area(struct file *file,
 
 #endif /* !CONFIG_MMU */
 
-static void io_sqpoll_wait_sq(struct io_ring_ctx *ctx)
+static int io_sqpoll_wait_sq(struct io_ring_ctx *ctx)
 {
+	int ret = 0;
 	DEFINE_WAIT(wait);
 
 	do {
@@ -8995,6 +9023,11 @@ static void io_sqpoll_wait_sq(struct io_ring_ctx *ctx)
 
 		prepare_to_wait(&ctx->sqo_sq_wait, &wait, TASK_INTERRUPTIBLE);
 
+		if (unlikely(ctx->sqo_dead)) {
+			ret = -EOWNERDEAD;
+			goto out;
+		}
+
 		if (!io_sqring_full(ctx))
 			break;
 
@@ -9002,6 +9035,8 @@ static void io_sqpoll_wait_sq(struct io_ring_ctx *ctx)
 	} while (!signal_pending(current));
 
 	finish_wait(&ctx->sqo_sq_wait, &wait);
+out:
+	return ret;
 }
 
 SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
@@ -9045,10 +9080,16 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
 		io_cqring_overflow_flush(ctx, false, NULL, NULL);
 
+		ret = -EOWNERDEAD;
+		if (unlikely(ctx->sqo_dead))
+			goto out;
 		if (flags & IORING_ENTER_SQ_WAKEUP)
 			wake_up(&ctx->sq_data->wait);
-		if (flags & IORING_ENTER_SQ_WAIT)
-			io_sqpoll_wait_sq(ctx);
+		if (flags & IORING_ENTER_SQ_WAIT) {
+			ret = io_sqpoll_wait_sq(ctx);
+			if (ret)
+				goto out;
+		}
 		submitted = to_submit;
 	} else if (to_submit) {
 		ret = io_uring_add_task_file(ctx, f.file);
@@ -9467,6 +9508,7 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 	trace_io_uring_create(ret, ctx, p->sq_entries, p->cq_entries, p->flags);
 	return ret;
 err:
+	io_disable_sqo_submit(ctx);
 	io_ring_ctx_wait_and_kill(ctx);
 	return ret;
 }
-- 
2.24.0

