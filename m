Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 274E92A1717
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:51:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727281AbgJaLur (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:50:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:39668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727518AbgJaLkw (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:40:52 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12CD720739;
        Sat, 31 Oct 2020 11:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144451;
        bh=sbV1ozBo4TkNufEQwqEsGw3AMzh5139dabfedMKsIE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zNZBUdmqven0hghDfwITPH4qVPgVAGzZrE1PzCesd5c0h5KPixBwcFH6PipZUiy1Y
         xVCEHyYOs5kUKMG2qBpPo5Wr6VIgZRQE0OAfPUVV1uitjkJJvtle5OoupPZ3g5EMoM
         AIFsr+rnnZJFe8XaDHJORGdnYjLJNm4C8VnLNv9g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.8 08/70] io_uring: enable task/files specific overflow flushing
Date:   Sat, 31 Oct 2020 12:35:40 +0100
Message-Id: <20201031113459.896411795@linuxfoundation.org>
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

commit e6c8aa9ac33bd7c968af7816240fc081401fddcd upstream.

This allows us to selectively flush out pending overflows, depending on
the task and/or files_struct being passed in.

No intended functional changes in this patch.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   41 ++++++++++++++++++++++++++---------------
 1 file changed, 26 insertions(+), 15 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1240,12 +1240,24 @@ static void io_cqring_ev_posted(struct i
 		eventfd_signal(ctx->cq_ev_fd, 1);
 }
 
+static inline bool io_match_files(struct io_kiocb *req,
+				       struct files_struct *files)
+{
+	if (!files)
+		return true;
+	if (req->flags & REQ_F_WORK_INITIALIZED)
+		return req->work.files == files;
+	return false;
+}
+
 /* Returns true if there are no backlogged entries after the flush */
-static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
+static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force,
+				     struct task_struct *tsk,
+				     struct files_struct *files)
 {
 	struct io_rings *rings = ctx->rings;
+	struct io_kiocb *req, *tmp;
 	struct io_uring_cqe *cqe;
-	struct io_kiocb *req;
 	unsigned long flags;
 	LIST_HEAD(list);
 
@@ -1264,7 +1276,12 @@ static bool io_cqring_overflow_flush(str
 		ctx->cq_overflow_flushed = 1;
 
 	cqe = NULL;
-	while (!list_empty(&ctx->cq_overflow_list)) {
+	list_for_each_entry_safe(req, tmp, &ctx->cq_overflow_list, list) {
+		if (tsk && req->task != tsk)
+			continue;
+		if (!io_match_files(req, files))
+			continue;
+
 		cqe = io_get_cqring(ctx);
 		if (!cqe && !force)
 			break;
@@ -1734,7 +1751,7 @@ static unsigned io_cqring_events(struct
 		if (noflush && !list_empty(&ctx->cq_overflow_list))
 			return -1U;
 
-		io_cqring_overflow_flush(ctx, false);
+		io_cqring_overflow_flush(ctx, false, NULL, NULL);
 	}
 
 	/* See comment at the top of this file */
@@ -6095,7 +6112,7 @@ static int io_submit_sqes(struct io_ring
 	/* if we have a backlog and couldn't flush it all, return BUSY */
 	if (test_bit(0, &ctx->sq_check_overflow)) {
 		if (!list_empty(&ctx->cq_overflow_list) &&
-		    !io_cqring_overflow_flush(ctx, false))
+		    !io_cqring_overflow_flush(ctx, false, NULL, NULL))
 			return -EBUSY;
 	}
 
@@ -7556,7 +7573,7 @@ static void io_ring_exit_work(struct wor
 
 	ctx = container_of(work, struct io_ring_ctx, exit_work);
 	if (ctx->rings)
-		io_cqring_overflow_flush(ctx, true);
+		io_cqring_overflow_flush(ctx, true, NULL, NULL);
 
 	/*
 	 * If we're doing polled IO and end up having requests being
@@ -7567,7 +7584,7 @@ static void io_ring_exit_work(struct wor
 	while (!wait_for_completion_timeout(&ctx->ref_comp, HZ/20)) {
 		io_iopoll_reap_events(ctx);
 		if (ctx->rings)
-			io_cqring_overflow_flush(ctx, true);
+			io_cqring_overflow_flush(ctx, true, NULL, NULL);
 	}
 	io_ring_ctx_free(ctx);
 }
@@ -7587,7 +7604,7 @@ static void io_ring_ctx_wait_and_kill(st
 	io_iopoll_reap_events(ctx);
 	/* if we failed setting up the ctx, we might not have any rings */
 	if (ctx->rings)
-		io_cqring_overflow_flush(ctx, true);
+		io_cqring_overflow_flush(ctx, true, NULL, NULL);
 	idr_for_each(&ctx->personality_idr, io_remove_personalities, ctx);
 
 	/*
@@ -7637,12 +7654,6 @@ static bool io_match_link(struct io_kioc
 	return false;
 }
 
-static inline bool io_match_files(struct io_kiocb *req,
-				       struct files_struct *files)
-{
-	return (req->flags & REQ_F_WORK_INITIALIZED) && req->work.files == files;
-}
-
 static bool io_match_link_files(struct io_kiocb *req,
 				struct files_struct *files)
 {
@@ -7959,7 +7970,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned
 	ret = 0;
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
 		if (!list_empty_careful(&ctx->cq_overflow_list))
-			io_cqring_overflow_flush(ctx, false);
+			io_cqring_overflow_flush(ctx, false, NULL, NULL);
 		if (flags & IORING_ENTER_SQ_WAKEUP)
 			wake_up(&ctx->sqo_wait);
 		submitted = to_submit;


