Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B63AC333DA1
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:25:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232844AbhCJNYg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:24:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:45330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232278AbhCJNYE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:24:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4632A64FE0;
        Wed, 10 Mar 2021 13:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382644;
        bh=ENstH27CUNladLuZnZwsenEwh0rFLoExl2hmXKK0tNY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D5yozgFaqkkG3Ndbx77q4tnrOyIFF71zhUfXH5fAJrMyZzt0tPBVtipX6yr26NQkc
         lJiNs1huTjDwdm+uGxTT15nxjAir/gOO3MszalViRrmMPoGxNq0eRh7Gs5FI/TE0xz
         N1AmVhQaYE7DDyh0T1iW5mbeKxCHxXnNgrg7dydQ=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 5.11 05/36] io_uring: deduplicate failing task_work_add
Date:   Wed, 10 Mar 2021 14:23:18 +0100
Message-Id: <20210310132320.691024604@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132320.510840709@linuxfoundation.org>
References: <20210310132320.510840709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Pavel Begunkov <asml.silence@gmail.com>

commit eab30c4d20dc761d463445e5130421863ff81505 upstream

When io_req_task_work_add() fails, the request will be cancelled by
enqueueing via task_works of io-wq. Extract a function for that.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   46 +++++++++++++++++-----------------------------
 1 file changed, 17 insertions(+), 29 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2172,6 +2172,16 @@ static int io_req_task_work_add(struct i
 	return ret;
 }
 
+static void io_req_task_work_add_fallback(struct io_kiocb *req,
+					  void (*cb)(struct callback_head *))
+{
+	struct task_struct *tsk = io_wq_get_task(req->ctx->io_wq);
+
+	init_task_work(&req->task_work, cb);
+	task_work_add(tsk, &req->task_work, TWA_NONE);
+	wake_up_process(tsk);
+}
+
 static void __io_req_task_cancel(struct io_kiocb *req, int error)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -2229,14 +2239,8 @@ static void io_req_task_queue(struct io_
 	percpu_ref_get(&req->ctx->refs);
 
 	ret = io_req_task_work_add(req);
-	if (unlikely(ret)) {
-		struct task_struct *tsk;
-
-		init_task_work(&req->task_work, io_req_task_cancel);
-		tsk = io_wq_get_task(req->ctx->io_wq);
-		task_work_add(tsk, &req->task_work, TWA_NONE);
-		wake_up_process(tsk);
-	}
+	if (unlikely(ret))
+		io_req_task_work_add_fallback(req, io_req_task_cancel);
 }
 
 static inline void io_queue_next(struct io_kiocb *req)
@@ -2354,13 +2358,8 @@ static void io_free_req_deferred(struct
 
 	init_task_work(&req->task_work, io_put_req_deferred_cb);
 	ret = io_req_task_work_add(req);
-	if (unlikely(ret)) {
-		struct task_struct *tsk;
-
-		tsk = io_wq_get_task(req->ctx->io_wq);
-		task_work_add(tsk, &req->task_work, TWA_NONE);
-		wake_up_process(tsk);
-	}
+	if (unlikely(ret))
+		io_req_task_work_add_fallback(req, io_put_req_deferred_cb);
 }
 
 static inline void io_put_req_deferred(struct io_kiocb *req, int refs)
@@ -3439,15 +3438,8 @@ static int io_async_buf_func(struct wait
 	/* submit ref gets dropped, acquire a new one */
 	refcount_inc(&req->refs);
 	ret = io_req_task_work_add(req);
-	if (unlikely(ret)) {
-		struct task_struct *tsk;
-
-		/* queue just for cancelation */
-		init_task_work(&req->task_work, io_req_task_cancel);
-		tsk = io_wq_get_task(req->ctx->io_wq);
-		task_work_add(tsk, &req->task_work, TWA_NONE);
-		wake_up_process(tsk);
-	}
+	if (unlikely(ret))
+		io_req_task_work_add_fallback(req, io_req_task_cancel);
 	return 1;
 }
 
@@ -5159,12 +5151,8 @@ static int __io_async_wake(struct io_kio
 	 */
 	ret = io_req_task_work_add(req);
 	if (unlikely(ret)) {
-		struct task_struct *tsk;
-
 		WRITE_ONCE(poll->canceled, true);
-		tsk = io_wq_get_task(req->ctx->io_wq);
-		task_work_add(tsk, &req->task_work, TWA_NONE);
-		wake_up_process(tsk);
+		io_req_task_work_add_fallback(req, func);
 	}
 	return 1;
 }


