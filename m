Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65D452A16BC
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:48:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728104AbgJaLoD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:44:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:44084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727567AbgJaLnz (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:43:55 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4EAC20731;
        Sat, 31 Oct 2020 11:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144635;
        bh=uLd6lIkTdyUYT3WD0iHQvS8GmMYq1OvABqX3cynZ7ME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QgxkO8jXaGdo1iA5RLfzQg9woHcJ9OiYZE74Ffze4hhE0PL/SfiqB6eWCL37bskdI
         UyIQCE1ytca9r5bB1fRouTIcNWVyM954jZB7TPKccPP7VMDvq+2x64y2AIjWybd5WV
         QQT1LBzsT0qfO/LobXY9+PCORAfUOcf3vLrF2MJk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.9 05/74] io_uring: stash ctx task reference for SQPOLL
Date:   Sat, 31 Oct 2020 12:35:47 +0100
Message-Id: <20201031113500.297738073@linuxfoundation.org>
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

commit 2aede0e417db846793c276c7a1bbf7262c8349b0 upstream.

We can grab a reference to the task instead of stashing away the task
files_struct. This is doable without creating a circular reference
between the ring fd and the task itself.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   47 ++++++++++++++++++++++++++++++++++-------------
 1 file changed, 34 insertions(+), 13 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -265,7 +265,16 @@ struct io_ring_ctx {
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
@@ -969,9 +978,10 @@ static int __io_sq_thread_acquire_mm(str
 {
 	if (!current->mm) {
 		if (unlikely(!(ctx->flags & IORING_SETUP_SQPOLL) ||
-			     !mmget_not_zero(ctx->sqo_mm)))
+			     !ctx->sqo_task->mm ||
+			     !mmget_not_zero(ctx->sqo_task->mm)))
 			return -EFAULT;
-		kthread_use_mm(ctx->sqo_mm);
+		kthread_use_mm(ctx->sqo_task->mm);
 	}
 
 	return 0;
@@ -7591,11 +7601,11 @@ static void io_unaccount_mem(struct io_r
 	if (ctx->limit_mem)
 		__io_unaccount_mem(ctx->user, nr_pages);
 
-	if (ctx->sqo_mm) {
+	if (ctx->mm_account) {
 		if (acct == ACCT_LOCKED)
-			ctx->sqo_mm->locked_vm -= nr_pages;
+			ctx->mm_account->locked_vm -= nr_pages;
 		else if (acct == ACCT_PINNED)
-			atomic64_sub(nr_pages, &ctx->sqo_mm->pinned_vm);
+			atomic64_sub(nr_pages, &ctx->mm_account->pinned_vm);
 	}
 }
 
@@ -7610,11 +7620,11 @@ static int io_account_mem(struct io_ring
 			return ret;
 	}
 
-	if (ctx->sqo_mm) {
+	if (ctx->mm_account) {
 		if (acct == ACCT_LOCKED)
-			ctx->sqo_mm->locked_vm += nr_pages;
+			ctx->mm_account->locked_vm += nr_pages;
 		else if (acct == ACCT_PINNED)
-			atomic64_add(nr_pages, &ctx->sqo_mm->pinned_vm);
+			atomic64_add(nr_pages, &ctx->mm_account->pinned_vm);
 	}
 
 	return 0;
@@ -7918,9 +7928,12 @@ static void io_ring_ctx_free(struct io_r
 {
 	io_finish_async(ctx);
 	io_sqe_buffer_unregister(ctx);
-	if (ctx->sqo_mm) {
-		mmdrop(ctx->sqo_mm);
-		ctx->sqo_mm = NULL;
+
+	if (ctx->sqo_task) {
+		put_task_struct(ctx->sqo_task);
+		ctx->sqo_task = NULL;
+		mmdrop(ctx->mm_account);
+		ctx->mm_account = NULL;
 	}
 
 	io_sqe_files_unregister(ctx);
@@ -8665,8 +8678,16 @@ static int io_uring_create(unsigned entr
 	ctx->user = user;
 	ctx->creds = get_current_cred();
 
+	ctx->sqo_task = get_task_struct(current);
+
+	/*
+	 * This is just grabbed for accounting purposes. When a process exits,
+	 * the mm is exited and dropped before the files, hence we need to hang
+	 * on to this mm purely for the purposes of being able to unaccount
+	 * memory (locked/pinned vm). It's not used for anything else.
+	 */
 	mmgrab(current->mm);
-	ctx->sqo_mm = current->mm;
+	ctx->mm_account = current->mm;
 
 	/*
 	 * Account memory _before_ installing the file descriptor. Once


