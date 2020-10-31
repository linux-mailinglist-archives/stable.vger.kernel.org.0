Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06C282A164A
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:44:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727757AbgJaLoD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:44:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:44212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728092AbgJaLoA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:44:00 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5EF8C20731;
        Sat, 31 Oct 2020 11:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144640;
        bh=rEnBkTSpGPRpp+R0p+iiDUWxVjbCZ3g87SpKhyJDfbc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zPt5fJfiUTeo0o3Mn3FzlSLB5ognnLuLJX3ujCIdju6Q9gdbPj0afr6vfL2+CDttZ
         OYrW+xa1yexVsh8y2CZhZ0j3VNxAKS5uhDsgzEQ+fIEZj4aoZ8l2fx87WattvyJCQk
         HT2kwnIJMgT9BOEUFCKoo4EVg2GvB3NiB8C5hO2k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.9 07/74] io_uring: return cancelation status from poll/timeout/files handlers
Date:   Sat, 31 Oct 2020 12:35:49 +0100
Message-Id: <20201031113500.389730131@linuxfoundation.org>
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

commit 76e1b6427fd8246376a97e3227049d49188dfb9c upstream.

Return whether we found and canceled requests or not. This is in
preparation for using this information, no functional changes in this
patch.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1229,16 +1229,23 @@ static bool io_task_match(struct io_kioc
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
 	list_for_each_entry_safe(req, tmp, &ctx->timeout_list, timeout.list) {
-		if (io_task_match(req, tsk))
+		if (io_task_match(req, tsk)) {
 			io_kill_timeout(req);
+			canceled++;
+		}
 	}
 	spin_unlock_irq(&ctx->completion_lock);
+	return canceled != 0;
 }
 
 static void __io_queue_deferred(struct io_ring_ctx *ctx)
@@ -5013,7 +5020,10 @@ static bool io_poll_remove_one(struct io
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
@@ -5033,6 +5043,8 @@ static void io_poll_remove_all(struct io
 
 	if (posted)
 		io_cqring_ev_posted(ctx);
+
+	return posted != 0;
 }
 
 static int io_poll_cancel(struct io_ring_ctx *ctx, __u64 sqe_addr)
@@ -8178,11 +8190,14 @@ static void io_cancel_defer_files(struct
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
@@ -8218,6 +8233,8 @@ static void io_uring_cancel_files(struct
 		schedule();
 		finish_wait(&ctx->inflight_wait, &wait);
 	}
+
+	return true;
 }
 
 static bool io_cancel_task_cb(struct io_wq_work *work, void *data)


