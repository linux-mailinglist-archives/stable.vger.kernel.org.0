Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF2E62A1602
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:40:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727168AbgJaLky (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:40:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:39600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727498AbgJaLku (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:40:50 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BDB820719;
        Sat, 31 Oct 2020 11:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144448;
        bh=JQvI5Rk/d6St9vPLXEzLK1SBRQD9N9wzQA1u74yXnlE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mz2rnvnEXedl+W5VY6aqp3N+QXckAtUz2OwboPzme3FBVz3/Df1ya4ErprHhXxn9A
         EybUBJIxZaZARiT1Nu7Y8Kj7OtcR01L5AaE29lX1/vn5PwrYpAP9NevJ3Yn1qYwZF5
         OxBpyQYXVlkKEDZg0+Ymi+c9ad0veAAS/YcfwraQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.8 07/70] io_uring: return cancelation status from poll/timeout/files handlers
Date:   Sat, 31 Oct 2020 12:35:39 +0100
Message-Id: <20201031113459.847920459@linuxfoundation.org>
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

commit 76e1b6427fd8246376a97e3227049d49188dfb9c upstream.

Return whether we found and canceled requests or not. This is in
preparation for using this information, no functional changes in this
patch.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1143,15 +1143,23 @@ static bool io_task_match(struct io_kioc
 	return false;
 }
 
-static void io_kill_timeouts(struct io_ring_ctx *ctx, struct task_struct *tsk)
+/*
+ * Returns true if we found and killed one or more timeouts
+ */
+static bool io_kill_timeouts(struct io_ring_ctx *ctx, struct task_struct *tsk)
 {
 	struct io_kiocb *req, *tmp;
+	int canceled = 0;
 
 	spin_lock_irq(&ctx->completion_lock);
-	list_for_each_entry_safe(req, tmp, &ctx->timeout_list, list)
-		if (io_task_match(req, tsk))
+	list_for_each_entry_safe(req, tmp, &ctx->timeout_list, list) {
+		if (io_task_match(req, tsk)) {
 			io_kill_timeout(req);
+			canceled++;
+		}
+	}
 	spin_unlock_irq(&ctx->completion_lock);
+	return canceled != 0;
 }
 
 static void __io_queue_deferred(struct io_ring_ctx *ctx)
@@ -4650,7 +4658,10 @@ static bool io_poll_remove_one(struct io
 	return do_complete;
 }
 
-static void io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk)
+/*
+ * Returns true if we found and killed one or more poll requests
+ */
+static bool io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk)
 {
 	struct hlist_node *tmp;
 	struct io_kiocb *req;
@@ -4670,6 +4681,8 @@ static void io_poll_remove_all(struct io
 
 	if (posted)
 		io_cqring_ev_posted(ctx);
+
+	return posted != 0;
 }
 
 static int io_poll_cancel(struct io_ring_ctx *ctx, __u64 sqe_addr)
@@ -7744,11 +7757,14 @@ static void io_cancel_defer_files(struct
 	}
 }
 
-static void io_uring_cancel_files(struct io_ring_ctx *ctx,
+/*
+ * Returns true if we found and killed one or more files pinning requests
+ */
+static bool io_uring_cancel_files(struct io_ring_ctx *ctx,
 				  struct files_struct *files)
 {
 	if (list_empty_careful(&ctx->inflight_list))
-		return;
+		return false;
 
 	io_cancel_defer_files(ctx, files);
 	/* cancel all at once, should be faster than doing it one by one*/
@@ -7811,6 +7827,8 @@ static void io_uring_cancel_files(struct
 		schedule();
 		finish_wait(&ctx->inflight_wait, &wait);
 	}
+
+	return true;
 }
 
 static bool io_cancel_task_cb(struct io_wq_work *work, void *data)


