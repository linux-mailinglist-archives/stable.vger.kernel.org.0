Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23BC92B6303
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:34:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732151AbgKQNeL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:34:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:44410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732145AbgKQNeJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:34:09 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8AC521534;
        Tue, 17 Nov 2020 13:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620049;
        bh=qktcrXO1GaWL/O4V7+CeTR/kVWYpxGZNq/ZxM/0WlnU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L2em04GjzK/ug+JAE9rRE9u9n1hi5zG4TaaanXv+QM5Dzw6R3rvU3E17yUA3+TYQL
         92jo7XJMjzBJFyUvwJTD5idt4vZDHvkQUhhXMplcmrzhi0tkus+3HnqI6BbLJV39I2
         P9Dqsza821pjkHhPmJmB5tuPY19aCMpnVN7WbP+s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+b57abf7ee60829090495@syzkaller.appspotmail.com,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 061/255] io_uring: ensure consistent view of original task ->mm from SQPOLL
Date:   Tue, 17 Nov 2020 14:03:21 +0100
Message-Id: <20201117122141.921183318@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 4b70cf9dea4cd239b425f3282fa56ce19e234c8a ]

Ensure we get a valid view of the task mm, by using task_lock() when
attempting to grab the original task mm.

Reported-by: syzbot+b57abf7ee60829090495@syzkaller.appspotmail.com
Fixes: 2aede0e417db ("io_uring: stash ctx task reference for SQPOLL")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1033e0e18f24f..2d5ca9476814d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -952,20 +952,33 @@ static void io_sq_thread_drop_mm(void)
 	if (mm) {
 		kthread_unuse_mm(mm);
 		mmput(mm);
+		current->mm = NULL;
 	}
 }
 
 static int __io_sq_thread_acquire_mm(struct io_ring_ctx *ctx)
 {
-	if (!current->mm) {
-		if (unlikely(!(ctx->flags & IORING_SETUP_SQPOLL) ||
-			     !ctx->sqo_task->mm ||
-			     !mmget_not_zero(ctx->sqo_task->mm)))
-			return -EFAULT;
-		kthread_use_mm(ctx->sqo_task->mm);
+	struct mm_struct *mm;
+
+	if (current->mm)
+		return 0;
+
+	/* Should never happen */
+	if (unlikely(!(ctx->flags & IORING_SETUP_SQPOLL)))
+		return -EFAULT;
+
+	task_lock(ctx->sqo_task);
+	mm = ctx->sqo_task->mm;
+	if (unlikely(!mm || !mmget_not_zero(mm)))
+		mm = NULL;
+	task_unlock(ctx->sqo_task);
+
+	if (mm) {
+		kthread_use_mm(mm);
+		return 0;
 	}
 
-	return 0;
+	return -EFAULT;
 }
 
 static int io_sq_thread_acquire_mm(struct io_ring_ctx *ctx,
-- 
2.27.0



