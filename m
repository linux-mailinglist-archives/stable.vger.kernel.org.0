Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 162A0205E35
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388977AbgFWUUw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:20:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:38306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389976AbgFWUUt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:20:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67C44206C3;
        Tue, 23 Jun 2020 20:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943649;
        bh=Iukx8MHBVWtcSwLg2WRSABdq1hB8fPEJiEsW6LJ67TM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YVqajGZu1kOAdy6YTtW1vJi5y5p2RPgpLmXAp2ecYxvnLTBUiviXqpn1KhvZutwGo
         aVzkJvsza34wPa/8V9eTg9fYYGaDctKoxczCH9N1JEvt6PMTO9kHnEHK5oJQJ856Bf
         s5p3evnDfALFkHjxD3dyPqKwRcJk10BlyKNusuzg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.7 433/477] io_uring: acquire mm for task_work for SQPOLL
Date:   Tue, 23 Jun 2020 21:57:10 +0200
Message-Id: <20200623195427.997145830@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 9d8426a09195e2dcf2aa249de2aaadd792d491c7 ]

If we're unlucky with timing, we could be running task_work after
having dropped the memory context in the sq thread. Since dropping
the context requires a runnable task state, we cannot reliably drop
it as part of our check-for-work loop in io_sq_thread(). Instead,
abstract out the mm acquire for the sq thread into a helper, and call
it from the async task work handler.

Cc: stable@vger.kernel.org # v5.7
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   44 +++++++++++++++++++++++++++++---------------
 1 file changed, 29 insertions(+), 15 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4302,6 +4302,28 @@ static void io_async_queue_proc(struct f
 	__io_queue_proc(&pt->req->apoll->poll, pt, head);
 }
 
+static void io_sq_thread_drop_mm(struct io_ring_ctx *ctx)
+{
+	struct mm_struct *mm = current->mm;
+
+	if (mm) {
+		unuse_mm(mm);
+		mmput(mm);
+	}
+}
+
+static int io_sq_thread_acquire_mm(struct io_ring_ctx *ctx,
+				   struct io_kiocb *req)
+{
+	if (io_op_defs[req->opcode].needs_mm && !current->mm) {
+		if (unlikely(!mmget_not_zero(ctx->sqo_mm)))
+			return -EFAULT;
+		use_mm(ctx->sqo_mm);
+	}
+
+	return 0;
+}
+
 static void io_async_task_func(struct callback_head *cb)
 {
 	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
@@ -4333,12 +4355,17 @@ static void io_async_task_func(struct ca
 	if (canceled) {
 		kfree(apoll);
 		io_cqring_ev_posted(ctx);
+end_req:
 		req_set_fail_links(req);
 		io_double_put_req(req);
 		return;
 	}
 
 	__set_current_state(TASK_RUNNING);
+	if (io_sq_thread_acquire_mm(ctx, req)) {
+		io_cqring_add_event(req, -EFAULT);
+		goto end_req;
+	}
 	mutex_lock(&ctx->uring_lock);
 	__io_queue_sqe(req, NULL);
 	mutex_unlock(&ctx->uring_lock);
@@ -5897,11 +5924,8 @@ static int io_init_req(struct io_ring_ct
 	if (unlikely(req->opcode >= IORING_OP_LAST))
 		return -EINVAL;
 
-	if (io_op_defs[req->opcode].needs_mm && !current->mm) {
-		if (unlikely(!mmget_not_zero(ctx->sqo_mm)))
-			return -EFAULT;
-		use_mm(ctx->sqo_mm);
-	}
+	if (unlikely(io_sq_thread_acquire_mm(ctx, req)))
+		return -EFAULT;
 
 	sqe_flags = READ_ONCE(sqe->flags);
 	/* enforce forwards compatibility on users */
@@ -6011,16 +6035,6 @@ fail_req:
 	return submitted;
 }
 
-static inline void io_sq_thread_drop_mm(struct io_ring_ctx *ctx)
-{
-	struct mm_struct *mm = current->mm;
-
-	if (mm) {
-		unuse_mm(mm);
-		mmput(mm);
-	}
-}
-
 static int io_sq_thread(void *data)
 {
 	struct io_ring_ctx *ctx = data;


