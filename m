Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F16DB2A1645
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:43:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728082AbgJaLnx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:43:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:43954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728079AbgJaLnv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:43:51 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A282E2074F;
        Sat, 31 Oct 2020 11:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144630;
        bh=iTrrphnkDfTH1Xx5RII1kb/JoUpbtyHN8J+B/addeWw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IwSDjzSvV0VlpuJ5PPsEa/KSM5zMGTKgYfnmAXv3iTiSEYi8VVqVEwH+ebN+XOSXy
         TPdrN16p0gEwv2rIXnnqwOxRqOQbnPYiQyU1J5Y++58kIXFmE0dWsoXKfpCnixQUit
         nsKyGigfO3yr8Ev2hAIfFdgPWGVP+TKprz74p3Ik=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.9 03/74] io_uring: allow timeout/poll/files killing to take task into account
Date:   Sat, 31 Oct 2020 12:35:45 +0100
Message-Id: <20201031113500.202920716@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113500.031279088@linuxfoundation.org>
References: <20201031113500.031279088@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 07d3ca52b0056f25eef61b1c896d089f8d365468 upstream.

We currently cancel these when the ring exits, and we cancel all of
them. This is in preparation for killing only the ones associated
with a given task.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   33 ++++++++++++++++++++++++---------
 1 file changed, 24 insertions(+), 9 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1226,13 +1226,26 @@ static void io_kill_timeout(struct io_ki
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
-	list_for_each_entry_safe(req, tmp, &ctx->timeout_list, timeout.list)
-		io_kill_timeout(req);
+	list_for_each_entry_safe(req, tmp, &ctx->timeout_list, timeout.list) {
+		if (io_task_match(req, tsk))
+			io_kill_timeout(req);
+	}
 	spin_unlock_irq(&ctx->completion_lock);
 }
 
@@ -5017,7 +5030,7 @@ static bool io_poll_remove_one(struct io
 	return do_complete;
 }
 
-static void io_poll_remove_all(struct io_ring_ctx *ctx)
+static void io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk)
 {
 	struct hlist_node *tmp;
 	struct io_kiocb *req;
@@ -5028,8 +5041,10 @@ static void io_poll_remove_all(struct io
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
 
@@ -7989,8 +8004,8 @@ static void io_ring_ctx_wait_and_kill(st
 	percpu_ref_kill(&ctx->refs);
 	mutex_unlock(&ctx->uring_lock);
 
-	io_kill_timeouts(ctx);
-	io_poll_remove_all(ctx);
+	io_kill_timeouts(ctx, NULL);
+	io_poll_remove_all(ctx, NULL);
 
 	if (ctx->io_wq)
 		io_wq_cancel_all(ctx->io_wq);
@@ -8221,7 +8236,7 @@ static bool io_cancel_task_cb(struct io_
 	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
 	struct task_struct *task = data;
 
-	return req->task == task;
+	return io_task_match(req, task);
 }
 
 static int io_uring_flush(struct file *file, void *data)


