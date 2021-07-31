Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C762B3DC41B
	for <lists+stable@lfdr.de>; Sat, 31 Jul 2021 08:42:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232138AbhGaGmr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Jul 2021 02:42:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:45786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232079AbhGaGmr (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Jul 2021 02:42:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 423EE6103B;
        Sat, 31 Jul 2021 06:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627713761;
        bh=9wGIVuszExeJ2gEnpfAoqeDI+Jr5zjHIHigKPXjxvQg=;
        h=Subject:To:Cc:From:Date:From;
        b=jFwGy9h4mEcO22QiqY16Zrj5rJdGWDK16Kg5eHvYR4Y7ncZbkbG1gSdxSjHR0dg1q
         t1nwruoR4lTZw6GfA/2ptldOnqfHd39nY5DB0nNKMKFG2S3C4+Q6ycqWsA2WQ/deCn
         h77dTofiXVIE+x2xMAtKefAKDiPzG18LBurTMPZI=
Subject: FAILED: patch "[PATCH] io_uring: fix io_prep_async_link locking" failed to apply to 5.10-stable tree
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 31 Jul 2021 08:42:39 +0200
Message-ID: <1627713759198215@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 44eff40a32e8f5228ae041006352e32638ad2368 Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Mon, 26 Jul 2021 14:14:31 +0100
Subject: [PATCH] io_uring: fix io_prep_async_link locking

io_prep_async_link() may be called after arming a linked timeout,
automatically making it unsafe to traverse the linked list. Guard
with completion_lock if there was a linked timeout.

Cc: stable@vger.kernel.org # 5.9+
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/93f7c617e2b4f012a2a175b3dab6bc2f27cebc48.1627304436.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5a0fd6bcd318..c4d2b320cdd4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1279,8 +1279,17 @@ static void io_prep_async_link(struct io_kiocb *req)
 {
 	struct io_kiocb *cur;
 
-	io_for_each_link(cur, req)
-		io_prep_async_work(cur);
+	if (req->flags & REQ_F_LINK_TIMEOUT) {
+		struct io_ring_ctx *ctx = req->ctx;
+
+		spin_lock_irq(&ctx->completion_lock);
+		io_for_each_link(cur, req)
+			io_prep_async_work(cur);
+		spin_unlock_irq(&ctx->completion_lock);
+	} else {
+		io_for_each_link(cur, req)
+			io_prep_async_work(cur);
+	}
 }
 
 static void io_queue_async_work(struct io_kiocb *req)

