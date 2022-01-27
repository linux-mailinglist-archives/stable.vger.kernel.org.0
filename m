Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4734F49EA19
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 19:12:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239709AbiA0SMK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 13:12:10 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:48870 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244975AbiA0SL2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 13:11:28 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1BA6361CF0;
        Thu, 27 Jan 2022 18:11:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE75EC340E4;
        Thu, 27 Jan 2022 18:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643307087;
        bh=Q6gtYBWh20QTzdtIvpE+Y06bBHguzvKmFY61qyYFYSM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vKMzvjCwJk+bba2unFTVn1FuwdKFZL/+rPir7SR638FFn/B+zlfw2L/+qDcyuhGyM
         Oq6k0TVm5wi9PKTNM8m1rV4ILqLvbEwqDO5fCHneZ8AvoNYfYV5jheowa1XNnXEN3w
         3H/yaq46BJI2q8k6RnD7H8w3t0tnGTfjaYLHjZnI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.16 3/9] io_uring: fix not released cached task refs
Date:   Thu, 27 Jan 2022 19:09:38 +0100
Message-Id: <20220127180259.001727110@linuxfoundation.org>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20220127180258.892788582@linuxfoundation.org>
References: <20220127180258.892788582@linuxfoundation.org>
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
@@ -1830,6 +1830,18 @@ static inline void io_get_task_refs(int
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
@@ -2250,6 +2262,10 @@ static void tctx_task_work(struct callba
 	}
 
 	ctx_flush_and_put(ctx, &locked);
+
+	/* relaxed read is enough as only the task itself sets ->in_idle */
+	if (unlikely(atomic_read(&tctx->in_idle)))
+		io_uring_drop_tctx_refs(current);
 }
 
 static void io_req_task_work_add(struct io_kiocb *req)
@@ -9818,18 +9834,6 @@ static s64 tctx_inflight(struct io_uring
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
  * requests. @sqd should be not-null IFF it's an SQPOLL thread cancellation.
@@ -9887,10 +9891,14 @@ static __cold void io_uring_cancel_gener
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


