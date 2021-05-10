Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42C9337891C
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237919AbhEJLZh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:25:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:34962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238013AbhEJLQs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:16:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2AFA46144F;
        Mon, 10 May 2021 11:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620645122;
        bh=jjJPwdS8K1D01ETOZNuduVhSxI+zxPORR2wf5Nv5kbI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uf+VcRez0m32IM+k9PoWVsbSSYjnsbAXuse+ZV8Li4ZL4S8I4KZIr51KZ9x1nRIBT
         GEawFwxSK845c47IDuPraRt2UG1RdNSRXgmifOW1IhFnmyD2hQ5IvNchN/dQDMXnhV
         Sio3+6covTicO5uqTcH4WiEmhMnZGbgiNeuhmVWQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.12 361/384] io_uring: fix work_exit sqpoll cancellations
Date:   Mon, 10 May 2021 12:22:30 +0200
Message-Id: <20210510102026.656004341@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit 28090c133869b461c5366195a856d73469ab87d9 upstream.

After closing an SQPOLL ring, io_ring_exit_work() kicks in and starts
doing cancellations via io_uring_try_cancel_requests(). It will go
through io_uring_try_cancel_iowq(), which uses ctx->tctx_list, but as
SQPOLL task don't have a ctx note, its io-wq won't be reachable and so
is left not cancelled.

It will eventually cancelled when one of the tasks dies, but if a thread
group survives for long and changes rings, it will spawn lots of
unreclaimed resources and live locked works.

Cancel SQPOLL task's io-wq separately in io_ring_exit_work().

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/a71a7fe345135d684025bb529d5cb1d8d6b46e10.1619389911.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8571,6 +8571,13 @@ static void io_tctx_exit_cb(struct callb
 	complete(&work->completion);
 }
 
+static bool io_cancel_ctx_cb(struct io_wq_work *work, void *data)
+{
+	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
+
+	return req->ctx == data;
+}
+
 static void io_ring_exit_work(struct work_struct *work)
 {
 	struct io_ring_ctx *ctx = container_of(work, struct io_ring_ctx, exit_work);
@@ -8587,6 +8594,17 @@ static void io_ring_exit_work(struct wor
 	 */
 	do {
 		io_uring_try_cancel_requests(ctx, NULL, NULL);
+		if (ctx->sq_data) {
+			struct io_sq_data *sqd = ctx->sq_data;
+			struct task_struct *tsk;
+
+			io_sq_thread_park(sqd);
+			tsk = sqd->thread;
+			if (tsk && tsk->io_uring && tsk->io_uring->io_wq)
+				io_wq_cancel_cb(tsk->io_uring->io_wq,
+						io_cancel_ctx_cb, ctx, true);
+			io_sq_thread_unpark(sqd);
+		}
 
 		WARN_ON_ONCE(time_after(jiffies, timeout));
 	} while (!wait_for_completion_timeout(&ctx->ref_comp, HZ/20));
@@ -8731,13 +8749,6 @@ static bool io_cancel_defer_files(struct
 	return true;
 }
 
-static bool io_cancel_ctx_cb(struct io_wq_work *work, void *data)
-{
-	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
-
-	return req->ctx == data;
-}
-
 static bool io_uring_try_cancel_iowq(struct io_ring_ctx *ctx)
 {
 	struct io_tctx_node *node;


