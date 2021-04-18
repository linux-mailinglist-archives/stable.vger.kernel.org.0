Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC2943635BF
	for <lists+stable@lfdr.de>; Sun, 18 Apr 2021 15:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230470AbhDRNwu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Apr 2021 09:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbhDRNwt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Apr 2021 09:52:49 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69EB0C061760;
        Sun, 18 Apr 2021 06:52:21 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id o21-20020a1c4d150000b029012e52898006so7001619wmh.0;
        Sun, 18 Apr 2021 06:52:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jvc6wOfAhuptfNvgUyE5utiM3n5M2Mer/TQrKGGfMAc=;
        b=PJib7R6rmjnJXh6xx/v6XjHOEKcsg6hITImHj6pJsu0ZCLLZNNtSXSMUS8pSzhQEUo
         r6gvTgmQoMHgkRNCOfREcTbiO7Mz3IRkj7Ue8J2TbeMWP8+bpnX0SWmUISWPKvgIC/Bc
         YDixq2LoPk9/TnX+9lnpZFJ/Kbn9akiFVpioBYOyKfOxGu4O3yJUf0a7+zKvufjHsAe4
         1U/wytO3q1MA/uzCrOw905XIr0YSXr20JCrowpVng4Sr08dwtD9SBsE7iU9YD94qyfQG
         g78sWq10iKaxoG5JbQAd7Heb5Mat0jNspASxZyHmWDzikQANsG7FSHFpcxz2kJRz+qTt
         GGUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jvc6wOfAhuptfNvgUyE5utiM3n5M2Mer/TQrKGGfMAc=;
        b=DIsABqXv3HpiZupQtCaoAli4POsjQ3fcghLQ8MA5uIAmX/r9oeBu6kauS0nuNcGcks
         TDKNCCCSooZPHpiw3SCefa8j13EOltCAvJ9CEv4THiREe+/bpe3Feu0ElhwBso3ghUvX
         6qU/rw+4NpojNLysFH4H6bG3+nPmD+EjbdGLTam/zl1aYNyVHahLHaLFcdaN8Y+u47v0
         BsGM7dv65StCGtAcjmVYoxENz9rewIv//jESitFFAPNqbEGHqRW+6UwVpS6DfIWPJ015
         qXHF0TqK39DIPge5nYujlRyKnlAIm5tPykczlrwAoyGF5pmxeeI9xDwSm5t7MItyvGL0
         UESA==
X-Gm-Message-State: AOAM532AnGVxzP4XxqjaPSkySMNhGoUSQFjkUS4Ai8o5pXg6hKy9IyyO
        /TS75xqdAVE+RzqTv7rsp18=
X-Google-Smtp-Source: ABdhPJxpkQR+PeniNWOn8j2VjIKvEioyN7DMj3BodYAOGJI939rUUT49DBUO4mkgQjhD5gW+/YWstg==
X-Received: by 2002:a05:600c:4a18:: with SMTP id c24mr16617731wmp.70.1618753940194;
        Sun, 18 Apr 2021 06:52:20 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.62])
        by smtp.gmail.com with ESMTPSA id f11sm16320397wmc.6.2021.04.18.06.52.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Apr 2021 06:52:19 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Joakim Hassila <joj@mac.com>, stable@vger.kernel.org
Subject: [PATCH 2/2] io_uring: fix shared sqpoll cancellation hangs
Date:   Sun, 18 Apr 2021 14:52:09 +0100
Message-Id: <1bded7e6c6b32e0bae25fce36be2868e46b116a0.1618752958.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1618752958.git.asml.silence@gmail.com>
References: <cover.1618752958.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[  736.982891] INFO: task iou-sqp-4294:4295 blocked for more than 122 seconds.
[  736.982897] Call Trace:
[  736.982901]  schedule+0x68/0xe0
[  736.982903]  io_uring_cancel_sqpoll+0xdb/0x110
[  736.982908]  io_sqpoll_cancel_cb+0x24/0x30
[  736.982911]  io_run_task_work_head+0x28/0x50
[  736.982913]  io_sq_thread+0x4e3/0x720

We call io_uring_cancel_sqpoll() one by one for each ctx either in
sq_thread() itself or via task works, and it's intended to cancel all
requests of a specified context. However the function uses per-task
counters to track the number of inflight requests, so it counts more
requests than available via currect io_uring ctx and goes to sleep for
them to appear (e.g. from IRQ), that will never happen.

Cancel a bit more than before, i.e. all ctxs that share sqpoll
and continue to use shared counters. Don't forget that we should not
remove ctx from the list before running that task_work sqpoll-cancel,
otherwise the function wouldn't be able to find the context and will
hang.

Reported-by: Joakim Hassila <joj@mac.com>
Reported-by: Jens Axboe <axboe@kernel.dk>
Fixes: 37d1e2e3642e2 ("io_uring: move SQPOLL thread io-wq forked worker")
Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index fb41725204f0..99e55f7f6c34 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1022,7 +1022,7 @@ static void io_uring_del_task_file(unsigned long index);
 static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 					 struct task_struct *task,
 					 struct files_struct *files);
-static void io_uring_cancel_sqpoll(struct io_ring_ctx *ctx);
+static void io_uring_cancel_sqpoll(struct io_sq_data *sqd);
 static struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx);
 
 static bool io_cqring_fill_event(struct io_kiocb *req, long res, unsigned cflags);
@@ -6867,15 +6867,14 @@ static int io_sq_thread(void *data)
 		timeout = jiffies + sqd->sq_thread_idle;
 	}
 
-	list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
-		io_uring_cancel_sqpoll(ctx);
+	io_uring_cancel_sqpoll(sqd);
 	sqd->thread = NULL;
 	list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
 		io_ring_set_wakeup_flag(ctx);
-	mutex_unlock(&sqd->lock);
-
 	io_run_task_work();
 	io_run_task_work_head(&sqd->park_task_work);
+	mutex_unlock(&sqd->lock);
+
 	complete(&sqd->exited);
 	do_exit(0);
 }
@@ -8867,11 +8866,11 @@ static s64 tctx_inflight(struct io_uring_task *tctx, bool tracked)
 static void io_sqpoll_cancel_cb(struct callback_head *cb)
 {
 	struct io_tctx_exit *work = container_of(cb, struct io_tctx_exit, task_work);
-	struct io_ring_ctx *ctx = work->ctx;
-	struct io_sq_data *sqd = ctx->sq_data;
+	struct io_sq_data *sqd = work->ctx->sq_data;
 
 	if (sqd->thread)
-		io_uring_cancel_sqpoll(ctx);
+		io_uring_cancel_sqpoll(sqd);
+	list_del_init(&work->ctx->sqd_list);
 	complete(&work->completion);
 }
 
@@ -8882,7 +8881,6 @@ static void io_sqpoll_cancel_sync(struct io_ring_ctx *ctx)
 	struct task_struct *task;
 
 	io_sq_thread_park(sqd);
-	list_del_init(&ctx->sqd_list);
 	io_sqd_update_thread_idle(sqd);
 	task = sqd->thread;
 	if (task) {
@@ -8890,6 +8888,8 @@ static void io_sqpoll_cancel_sync(struct io_ring_ctx *ctx)
 		init_task_work(&work.task_work, io_sqpoll_cancel_cb);
 		io_task_work_add_head(&sqd->park_task_work, &work.task_work);
 		wake_up_process(task);
+	} else {
+		list_del_init(&ctx->sqd_list);
 	}
 	io_sq_thread_unpark(sqd);
 
@@ -8915,14 +8915,14 @@ static void io_uring_try_cancel(struct files_struct *files)
 }
 
 /* should only be called by SQPOLL task */
-static void io_uring_cancel_sqpoll(struct io_ring_ctx *ctx)
+static void io_uring_cancel_sqpoll(struct io_sq_data *sqd)
 {
-	struct io_sq_data *sqd = ctx->sq_data;
 	struct io_uring_task *tctx = current->io_uring;
+	struct io_ring_ctx *ctx;
 	s64 inflight;
 	DEFINE_WAIT(wait);
 
-	WARN_ON_ONCE(!sqd || ctx->sq_data->thread != current);
+	WARN_ON_ONCE(!sqd || sqd->thread != current);
 
 	atomic_inc(&tctx->in_idle);
 	do {
@@ -8930,7 +8930,8 @@ static void io_uring_cancel_sqpoll(struct io_ring_ctx *ctx)
 		inflight = tctx_inflight(tctx, false);
 		if (!inflight)
 			break;
-		io_uring_try_cancel_requests(ctx, current, NULL);
+		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
+			io_uring_try_cancel_requests(ctx, current, NULL);
 
 		prepare_to_wait(&tctx->wait, &wait, TASK_UNINTERRUPTIBLE);
 		/*
-- 
2.31.1

