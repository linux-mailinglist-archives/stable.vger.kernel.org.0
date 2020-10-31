Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D76692A16D6
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:51:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727480AbgJaLko (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:40:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:39518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727435AbgJaLko (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:40:44 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D798420719;
        Sat, 31 Oct 2020 11:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144443;
        bh=p+AqIItu3keAflYv7ISR+e72Na8BOMiyF9hYw2YWCGY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RSddTE1mZ7k9D1RzWeTyxr2cyF6u6SUnnHjgjK+H0IcG/1dlHQikQh/6FLHA8OqMr
         Yx02UKgVKUG6dn8WgYm0l3faJuwHok9eemo3ZG+7ghNoQkr2MT78yyUbKI39rvwBHP
         WptuGemz6sLKNcVAtqnLVvDnV+ooEkXzQt7Purdo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.8 05/70] io_uring: stash ctx task reference for SQPOLL
Date:   Sat, 31 Oct 2020 12:35:37 +0100
Message-Id: <20201031113459.750820894@linuxfoundation.org>
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

commit 2aede0e417db846793c276c7a1bbf7262c8349b0 upstream.

We can grab a reference to the task instead of stashing away the task
files_struct. This is doable without creating a circular reference
between the ring fd and the task itself.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   39 +++++++++++++++++++++++++++++----------
 1 file changed, 29 insertions(+), 10 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -264,7 +264,16 @@ struct io_ring_ctx {
 	/* IO offload */
 	struct io_wq		*io_wq;
 	struct task_struct	*sqo_thread;	/* if using sq thread polling */
-	struct mm_struct	*sqo_mm;
+
+	/*
+	 * For SQPOLL usage - we hold a reference to the parent task, so we
+	 * have access to the ->files
+	 */
+	struct task_struct	*sqo_task;
+
+	/* Only used for accounting purposes */
+	struct mm_struct	*mm_account;
+
 	wait_queue_head_t	sqo_wait;
 
 	/*
@@ -4421,9 +4430,10 @@ static int io_sq_thread_acquire_mm(struc
 {
 	if (io_op_defs[req->opcode].needs_mm && !current->mm) {
 		if (unlikely(!(ctx->flags & IORING_SETUP_SQPOLL) ||
-			     !mmget_not_zero(ctx->sqo_mm)))
+			!ctx->sqo_task->mm ||
+			!mmget_not_zero(ctx->sqo_task->mm)))
 			return -EFAULT;
-		kthread_use_mm(ctx->sqo_mm);
+		kthread_use_mm(ctx->sqo_task->mm);
 	}
 
 	return 0;
@@ -7104,9 +7114,6 @@ static int io_sq_offload_start(struct io
 {
 	int ret;
 
-	mmgrab(current->mm);
-	ctx->sqo_mm = current->mm;
-
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
 		ret = -EPERM;
 		if (!capable(CAP_SYS_ADMIN))
@@ -7151,8 +7158,6 @@ static int io_sq_offload_start(struct io
 	return 0;
 err:
 	io_finish_async(ctx);
-	mmdrop(ctx->sqo_mm);
-	ctx->sqo_mm = NULL;
 	return ret;
 }
 
@@ -7482,8 +7487,12 @@ static void io_destroy_buffers(struct io
 static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 {
 	io_finish_async(ctx);
-	if (ctx->sqo_mm)
-		mmdrop(ctx->sqo_mm);
+	if (ctx->sqo_task) {
+		put_task_struct(ctx->sqo_task);
+		ctx->sqo_task = NULL;
+		mmdrop(ctx->mm_account);
+		ctx->mm_account = NULL;
+	}
 
 	io_iopoll_reap_events(ctx);
 	io_sqe_buffer_unregister(ctx);
@@ -8256,6 +8265,16 @@ static int io_uring_create(unsigned entr
 	ctx->user = user;
 	ctx->creds = get_current_cred();
 
+	ctx->sqo_task = get_task_struct(current);
+	/*
+	 * This is just grabbed for accounting purposes. When a process exits,
+	 * the mm is exited and dropped before the files, hence we need to hang
+	 * on to this mm purely for the purposes of being able to unaccount
+	 * memory (locked/pinned vm). It's not used for anything else.
+	 */
+	mmgrab(current->mm);
+	ctx->mm_account = current->mm;
+
 	ret = io_allocate_scq_urings(ctx, p);
 	if (ret)
 		goto err;


