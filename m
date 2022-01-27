Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC7E49EA06
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 19:11:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245309AbiA0SLi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 13:11:38 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59442 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245113AbiA0SK5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 13:10:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39A8DB820C9;
        Thu, 27 Jan 2022 18:10:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 481B7C340E4;
        Thu, 27 Jan 2022 18:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643307054;
        bh=j3arMY1qJJ8GVLwQU2G8HH/yot4BsIRcGLhPY2c7zwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2QaGLAAcTcrv1PgXoJ3d+gM69UTcTbkfdBWTOafEm4s6mvwS0LaZscCBG9GHIlA0F
         pP6OzTEsLTG/LqeVsiP+/RVCr/BwMdtLyMIic9po3qFCBEi7R1PZ4ydiOCfSl1xPd7
         WQuqNsRfAQigWEBArg4amc7/39+pubnUmW7tjq7o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 03/12] io_uring: fix not released cached task refs
Date:   Thu, 27 Jan 2022 19:09:27 +0100
Message-Id: <20220127180259.192225979@linuxfoundation.org>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20220127180259.078563735@linuxfoundation.org>
References: <20220127180259.078563735@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit 3cc7fdb9f90a25ae92250bf9e6cf3b9556b230e9 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   34 +++++++++++++++++++++-------------
 1 file changed, 21 insertions(+), 13 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1760,6 +1760,18 @@ static inline void io_get_task_refs(int
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
 				     long res, unsigned int cflags)
 {
@@ -2200,6 +2212,10 @@ static void tctx_task_work(struct callba
 	}
 
 	ctx_flush_and_put(ctx, &locked);
+
+	/* relaxed read is enough as only the task itself sets ->in_idle */
+	if (unlikely(atomic_read(&tctx->in_idle)))
+		io_uring_drop_tctx_refs(current);
 }
 
 static void io_req_task_work_add(struct io_kiocb *req)
@@ -9766,18 +9782,6 @@ static s64 tctx_inflight(struct io_uring
 	return percpu_counter_sum(&tctx->inflight);
 }
 
-static void io_uring_drop_tctx_refs(struct task_struct *task)
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
  * requests. @sqd should be not-null IFF it's an SQPOLL thread cancellation.
@@ -9834,10 +9838,14 @@ static void io_uring_cancel_generic(bool
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


