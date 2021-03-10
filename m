Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C59F333B88
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 12:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231139AbhCJLf4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 06:35:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231858AbhCJLe7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 06:34:59 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5A16C061762
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 03:34:53 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id a18so22900251wrc.13
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 03:34:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+ijlZVJYK+b/yAKln3IkbcGaaW8ctS3e6ofTaEAvaeU=;
        b=OsjBMTTracZZeCnaPoumKr4tpqfpw3IP/iBj5qeJONkiduk8N7XM2ulrDjEqdLKKA+
         4FazRCmkJQpJ2Ef/qZHdSaFkdvhevD4xsMPzDRZsKaA9kwapweYW4pNYXt2CMB9WFmrJ
         luJRwO+fqXLrZfHJxc25szQC5I7UwmNIgJcwZE0lb05OQpBj3JtOzfn6Xb27UI7skYEd
         uMEgDx615memDTcjC0IP1YTo+77swCigZRe/YIj1iKbUfoit9+J3xqelBD4oJb67+iVr
         ynvzL+Tfj2uagfFOiYTXD7WspbwqHOXNbTTRfm7AcmbmVcUuD4LAInr6IAbD3Gl5ODAJ
         V0fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+ijlZVJYK+b/yAKln3IkbcGaaW8ctS3e6ofTaEAvaeU=;
        b=MF7Onc+Fibw1qMRqohjNu47elMLen9yo5YAlrr9Y7mPUvWk+RjdPjCDZg28tlm50ro
         CYG50DW2Ocm16Z9pPinMIkxeebGs4AGxaIkPLbcTeIwPCorMHsEsTDn4W4vavLknfzGL
         jfe2gilxAp0uanvN/liPbA3Y3d72OtjXzsLzCL2Lwlwra18rvw18OvG/veSJO0UULn7+
         DwzZTDKtx6Nh+IARd0OszLP3Bph6eMfWCy+Ze7rWgBU6gmDhHcsrZVMnQKhbEeLtpkTb
         MN5hR5Xp5lqmlKGyWboASBHI4Z+oyZRv0N+UFHTW4LQnoNYlNi1WF1AiGpFWz8Gtop6n
         5w9Q==
X-Gm-Message-State: AOAM531kCBGrQRktzw+psm+6IAk6o8bVoSirvd9qE6n7m4PYUChwoz3/
        AhyyuN22quUxllDKv/nI4dUIBLfNp+b0FQ==
X-Google-Smtp-Source: ABdhPJxm9/aTg9JE6MQMjcmHrBfrk6MmUKjBtHXwbbGcR3IRt9mknaeaUlNJUIAJscW88XmdRiJP7g==
X-Received: by 2002:a5d:4fcb:: with SMTP id h11mr3208917wrw.66.1615376092384;
        Wed, 10 Mar 2021 03:34:52 -0800 (PST)
Received: from localhost.localdomain ([85.255.232.55])
        by smtp.gmail.com with ESMTPSA id s18sm25179078wrr.27.2021.03.10.03.34.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 03:34:51 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/9] io_uring: deduplicate core cancellations sequence
Date:   Wed, 10 Mar 2021 11:30:38 +0000
Message-Id: <b4d938bd6cd39991672cbe5e7aae63de4f06cc49.1615375332.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1615375332.git.asml.silence@gmail.com>
References: <cover.1615375332.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 9936c7c2bc76a0b2276f6d19de6d1d92f03deeab upstream

Files and task cancellations go over same steps trying to cancel
requests in io-wq, poll, etc. Deduplicate it with a helper.

note: new io_uring_try_cancel_requests() is former
__io_uring_cancel_task_requests() with files passed as an agrument and
flushing overflowed requests.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 85 ++++++++++++++++++++++++---------------------------
 1 file changed, 40 insertions(+), 45 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a1d08b641d0f..cbcd4023cf7a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -996,9 +996,9 @@ enum io_mem_account {
 	ACCT_PINNED,
 };
 
-static void __io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
-					    struct task_struct *task);
-
+static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
+					 struct task_struct *task,
+					 struct files_struct *files);
 static void destroy_fixed_file_ref_node(struct fixed_file_ref_node *ref_node);
 static struct fixed_file_ref_node *alloc_fixed_file_ref_node(
 			struct io_ring_ctx *ctx);
@@ -8780,7 +8780,7 @@ static void io_ring_exit_work(struct work_struct *work)
 	 * as nobody else will be looking for them.
 	 */
 	do {
-		__io_uring_cancel_task_requests(ctx, NULL);
+		io_uring_try_cancel_requests(ctx, NULL, NULL);
 	} while (!wait_for_completion_timeout(&ctx->ref_comp, HZ/20));
 	io_ring_ctx_free(ctx);
 }
@@ -8894,6 +8894,40 @@ static void io_cancel_defer_files(struct io_ring_ctx *ctx,
 	}
 }
 
+static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
+					 struct task_struct *task,
+					 struct files_struct *files)
+{
+	struct io_task_cancel cancel = { .task = task, .files = files, };
+
+	while (1) {
+		enum io_wq_cancel cret;
+		bool ret = false;
+
+		if (ctx->io_wq) {
+			cret = io_wq_cancel_cb(ctx->io_wq, io_cancel_task_cb,
+					       &cancel, true);
+			ret |= (cret != IO_WQ_CANCEL_NOTFOUND);
+		}
+
+		/* SQPOLL thread does its own polling */
+		if (!(ctx->flags & IORING_SETUP_SQPOLL) && !files) {
+			while (!list_empty_careful(&ctx->iopoll_list)) {
+				io_iopoll_try_reap_events(ctx);
+				ret = true;
+			}
+		}
+
+		ret |= io_poll_remove_all(ctx, task, files);
+		ret |= io_kill_timeouts(ctx, task, files);
+		ret |= io_run_task_work();
+		io_cqring_overflow_flush(ctx, true, task, files);
+		if (!ret)
+			break;
+		cond_resched();
+	}
+}
+
 static int io_uring_count_inflight(struct io_ring_ctx *ctx,
 				   struct task_struct *task,
 				   struct files_struct *files)
@@ -8913,7 +8947,6 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 				  struct files_struct *files)
 {
 	while (!list_empty_careful(&ctx->inflight_list)) {
-		struct io_task_cancel cancel = { .task = task, .files = files };
 		DEFINE_WAIT(wait);
 		int inflight;
 
@@ -8921,13 +8954,7 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 		if (!inflight)
 			break;
 
-		io_wq_cancel_cb(ctx->io_wq, io_cancel_task_cb, &cancel, true);
-		io_poll_remove_all(ctx, task, files);
-		io_kill_timeouts(ctx, task, files);
-		io_cqring_overflow_flush(ctx, true, task, files);
-		/* cancellations _may_ trigger task work */
-		io_run_task_work();
-
+		io_uring_try_cancel_requests(ctx, task, files);
 		prepare_to_wait(&task->io_uring->wait, &wait,
 				TASK_UNINTERRUPTIBLE);
 		if (inflight == io_uring_count_inflight(ctx, task, files))
@@ -8936,37 +8963,6 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 	}
 }
 
-static void __io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
-					    struct task_struct *task)
-{
-	while (1) {
-		struct io_task_cancel cancel = { .task = task, .files = NULL, };
-		enum io_wq_cancel cret;
-		bool ret = false;
-
-		if (ctx->io_wq) {
-			cret = io_wq_cancel_cb(ctx->io_wq, io_cancel_task_cb,
-					       &cancel, true);
-			ret |= (cret != IO_WQ_CANCEL_NOTFOUND);
-		}
-
-		/* SQPOLL thread does its own polling */
-		if (!(ctx->flags & IORING_SETUP_SQPOLL)) {
-			while (!list_empty_careful(&ctx->iopoll_list)) {
-				io_iopoll_try_reap_events(ctx);
-				ret = true;
-			}
-		}
-
-		ret |= io_poll_remove_all(ctx, task, NULL);
-		ret |= io_kill_timeouts(ctx, task, NULL);
-		ret |= io_run_task_work();
-		if (!ret)
-			break;
-		cond_resched();
-	}
-}
-
 static void io_disable_sqo_submit(struct io_ring_ctx *ctx)
 {
 	mutex_lock(&ctx->uring_lock);
@@ -8996,11 +8992,10 @@ static void io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
 	}
 
 	io_cancel_defer_files(ctx, task, files);
-	io_cqring_overflow_flush(ctx, true, task, files);
 
 	io_uring_cancel_files(ctx, task, files);
 	if (!files)
-		__io_uring_cancel_task_requests(ctx, task);
+		io_uring_try_cancel_requests(ctx, task, NULL);
 
 	if ((ctx->flags & IORING_SETUP_SQPOLL) && ctx->sq_data) {
 		atomic_dec(&task->io_uring->in_idle);
-- 
2.24.0

