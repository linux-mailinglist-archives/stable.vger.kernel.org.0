Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A844A49721D
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 15:28:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236741AbiAWO2M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jan 2022 09:28:12 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38574 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232290AbiAWO2L (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jan 2022 09:28:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 683D060C97
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 14:28:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43A84C340E2;
        Sun, 23 Jan 2022 14:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642948090;
        bh=kjcEiUkC5uLZ0DqZQWlop2pxpx0kS47xtocMgQRnYuY=;
        h=Subject:To:Cc:From:Date:From;
        b=Xc1dIv68grVeknak+Nyd9bobJjO4Ddh4uQuK7oCtJdoENwJkoj2PnxdRes5wMAw3z
         Uqxla34A3WM9lQcZ82VbDD/vQQwSYV4U6A7r6AyDtTqbEPzjDL+Pnjrx5IESqfnzzp
         7YHd4H3OQjGsWyfZS09FBIsoY/NevJSR4P1yX1Kk=
Subject: FAILED: patch "[PATCH] io_uring: fix not released cached task refs" failed to apply to 5.16-stable tree
To:     asml.silence@gmail.com, axboe@kernel.dk, lukas.bulwahn@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Jan 2022 15:27:59 +0100
Message-ID: <164294807930124@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.16-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3cc7fdb9f90a25ae92250bf9e6cf3b9556b230e9 Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Sun, 9 Jan 2022 00:53:22 +0000
Subject: [PATCH] io_uring: fix not released cached task refs

tctx_task_work() may get run after io_uring cancellation and so there
will be no one to put cached in tctx task refs that may have been added
back by tw handlers using inline completion infra, Call
io_uring_drop_tctx_refs() at the end of the main tw handler to release
them.

Cc: stable@vger.kernel.org # 5.15+
Reported-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Fixes: e98e49b2bbf7 ("io_uring: extend task put optimisations")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/69f226b35fbdb996ab799a8bbc1c06bf634ccec1.1641688805.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index aed1625a26e1..684d77c179a0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1827,6 +1827,18 @@ static inline void io_get_task_refs(int nr)
 		io_task_refs_refill(tctx);
 }
 
+static __cold void io_uring_drop_tctx_refs(struct task_struct *task)
+{
+	struct io_uring_task *tctx = task->io_uring;
+	unsigned int refs = tctx->cached_refs;
+
+	if (refs) {
+		tctx->cached_refs = 0;
+		percpu_counter_sub(&tctx->inflight, refs);
+		put_task_struct_many(task, refs);
+	}
+}
+
 static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
 				     s32 res, u32 cflags)
 {
@@ -2319,6 +2331,10 @@ static void tctx_task_work(struct callback_head *cb)
 	}
 
 	ctx_flush_and_put(ctx, &uring_locked);
+
+	/* relaxed read is enough as only the task itself sets ->in_idle */
+	if (unlikely(atomic_read(&tctx->in_idle)))
+		io_uring_drop_tctx_refs(current);
 }
 
 static void io_req_task_work_add(struct io_kiocb *req, bool priority)
@@ -9803,18 +9819,6 @@ static s64 tctx_inflight(struct io_uring_task *tctx, bool tracked)
 	return percpu_counter_sum(&tctx->inflight);
 }
 
-static __cold void io_uring_drop_tctx_refs(struct task_struct *task)
-{
-	struct io_uring_task *tctx = task->io_uring;
-	unsigned int refs = tctx->cached_refs;
-
-	if (refs) {
-		tctx->cached_refs = 0;
-		percpu_counter_sub(&tctx->inflight, refs);
-		put_task_struct_many(task, refs);
-	}
-}
-
 /*
  * Find any io_uring ctx that this task has registered or done IO on, and cancel
  * requests. @sqd should be not-null IIF it's an SQPOLL thread cancellation.
@@ -9870,10 +9874,14 @@ static __cold void io_uring_cancel_generic(bool cancel_all,
 			schedule();
 		finish_wait(&tctx->wait, &wait);
 	} while (1);
-	atomic_dec(&tctx->in_idle);
 
 	io_uring_clean_tctx(tctx);
 	if (cancel_all) {
+		/*
+		 * We shouldn't run task_works after cancel, so just leave
+		 * ->in_idle set for normal exit.
+		 */
+		atomic_dec(&tctx->in_idle);
 		/* for exec all current's requests should be gone, kill tctx */
 		__io_uring_free(current);
 	}

