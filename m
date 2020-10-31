Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 576902A15FC
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727463AbgJaLkl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:40:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:39390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727454AbgJaLkk (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:40:40 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B03820739;
        Sat, 31 Oct 2020 11:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144438;
        bh=J6GCv3ZtnRkcV8sVrLCriEC8sqPrcpGQdXTohxh3sjE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f9d+wT/7TH1dsmc28g7P6zyiHVqJDvNGTNYGwcN7stbObjC9t9AOWewPVCjY2pjyj
         P6BdsY9CLEld/X1gN86AtNQ4APRShazmI9D6zTXQ2iYg5ouekJBNrdgBj80qFZC/3Y
         DnTWIAx2VMtrufFKpyNM+/dWRUevPjQfJu3ePeyQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.8 03/70] io_uring: allow timeout/poll/files killing to take task into account
Date:   Sat, 31 Oct 2020 12:35:35 +0100
Message-Id: <20201031113459.652536951@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113459.481803250@linuxfoundation.org>
References: <20201031113459.481803250@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit f3606e3a92ddd36299642c78592fc87609abb1f6 upstream.

We currently cancel these when the ring exits, and we cancel all of
them. This is in preparation for killing only the ones associated
with a given task.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1141,13 +1141,25 @@ static void io_kill_timeout(struct io_ki
 	}
 }
 
-static void io_kill_timeouts(struct io_ring_ctx *ctx)
+static bool io_task_match(struct io_kiocb *req, struct task_struct *tsk)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+
+	if (!tsk || req->task == tsk)
+		return true;
+	if ((ctx->flags & IORING_SETUP_SQPOLL) && req->task == ctx->sqo_thread)
+		return true;
+	return false;
+}
+
+static void io_kill_timeouts(struct io_ring_ctx *ctx, struct task_struct *tsk)
 {
 	struct io_kiocb *req, *tmp;
 
 	spin_lock_irq(&ctx->completion_lock);
 	list_for_each_entry_safe(req, tmp, &ctx->timeout_list, list)
-		io_kill_timeout(req);
+		if (io_task_match(req, tsk))
+			io_kill_timeout(req);
 	spin_unlock_irq(&ctx->completion_lock);
 }
 
@@ -4641,7 +4653,7 @@ static bool io_poll_remove_one(struct io
 	return do_complete;
 }
 
-static void io_poll_remove_all(struct io_ring_ctx *ctx)
+static void io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk)
 {
 	struct hlist_node *tmp;
 	struct io_kiocb *req;
@@ -4652,8 +4664,10 @@ static void io_poll_remove_all(struct io
 		struct hlist_head *list;
 
 		list = &ctx->cancel_hash[i];
-		hlist_for_each_entry_safe(req, tmp, list, hash_node)
-			posted += io_poll_remove_one(req);
+		hlist_for_each_entry_safe(req, tmp, list, hash_node) {
+			if (io_task_match(req, tsk))
+				posted += io_poll_remove_one(req);
+		}
 	}
 	spin_unlock_irq(&ctx->completion_lock);
 
@@ -7556,8 +7570,8 @@ static void io_ring_ctx_wait_and_kill(st
 	percpu_ref_kill(&ctx->refs);
 	mutex_unlock(&ctx->uring_lock);
 
-	io_kill_timeouts(ctx);
-	io_poll_remove_all(ctx);
+	io_kill_timeouts(ctx, NULL);
+	io_poll_remove_all(ctx, NULL);
 
 	if (ctx->io_wq)
 		io_wq_cancel_all(ctx->io_wq);
@@ -7809,7 +7823,7 @@ static bool io_cancel_task_cb(struct io_
 	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
 	struct task_struct *task = data;
 
-	return req->task == task;
+	return io_task_match(req, task);
 }
 
 static int io_uring_flush(struct file *file, void *data)


