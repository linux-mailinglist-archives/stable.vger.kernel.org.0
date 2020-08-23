Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B826A24ED23
	for <lists+stable@lfdr.de>; Sun, 23 Aug 2020 14:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbgHWMPu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Aug 2020 08:15:50 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:32913 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727096AbgHWMPr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Aug 2020 08:15:47 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 964F419411C3;
        Sun, 23 Aug 2020 08:15:46 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sun, 23 Aug 2020 08:15:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=1n/6SQ
        EmRA/nPLEtIJdC3ZaWAhHZ0OCTRvY0kDi59nE=; b=VZQduFKtYOi268wRQvkfZ6
        dgZwgC7QV6DyNFRTfgwUeFS3YRK/zimDNYu0POYU0u7jTwVVgyCXHK19FL6EtTbl
        19SUmohbig/9cudt9aMZtTXOf1tHVGzSlOP4UQJhFkbXR1+8oy5C3ORwyC7Zz50L
        mJLZxjAYrek9DYUDQzKHWAdiheKIUFRx81kK6gbakm2r/Dt9Dmi6V6R/SWBHhnE5
        Yit3xnlosbmv/oAGOS/vsVUtuu64bQZ0yEELv21uGWvZuZm79KtwGEOmtFwbELd3
        2xVMc49lamopHMIGF38LJ9b5OPHFs7hVj4liFe5YC/a9KhZWhWT8pu9XxzipLm+A
        ==
X-ME-Sender: <xms:8l1CXwQdWpROOnto-Eyc__SdZma0VeAZDEDzBm0EroGOnhjrrlpoKg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudduiedggeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:8l1CX9wOFqAohHcFji7B7f4QcnmVDLphnPpWGr3MYAQgBhD60K5IIA>
    <xmx:8l1CX91T7myDRHtY_gTVqNIVf1CvkHN7PCv4SsZ_r09STziXns2ybw>
    <xmx:8l1CX0CvcbteSm6N0Agoue3cFuQ-OrCfKLrBbxJBURTPi4Hj1fq3jg>
    <xmx:8l1CXzfBoo-gL-oL4W4FvMw0iE4SspWlMsiOnETd59Ks8A7YKJfeEA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id E61F33280059;
        Sun, 23 Aug 2020 08:15:45 -0400 (EDT)
Subject: FAILED: patch "[PATCH] io_uring: find and cancel head link async work on files exit" failed to apply to 5.7-stable tree
To:     axboe@kernel.dk, asml.silence@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Aug 2020 14:16:06 +0200
Message-ID: <159818496684216@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.7-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b711d4eaf0c408a811311ee3e94d6e9e5a230a9a Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Sun, 16 Aug 2020 08:23:05 -0700
Subject: [PATCH] io_uring: find and cancel head link async work on files exit

Commit f254ac04c874 ("io_uring: enable lookup of links holding inflight files")
only handled 2 out of the three head link cases we have, we also need to
lookup and cancel work that is blocked in io-wq if that work has a link
that's holding a reference to the files structure.

Put the "cancel head links that hold this request pending" logic into
io_attempt_cancel(), which will to through the motions of finding and
canceling head links that hold the current inflight files stable request
pending.

Cc: stable@vger.kernel.org
Reported-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index dc506b75659c..346a3eb84785 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8063,6 +8063,33 @@ static bool io_timeout_remove_link(struct io_ring_ctx *ctx,
 	return found;
 }
 
+static bool io_cancel_link_cb(struct io_wq_work *work, void *data)
+{
+	return io_match_link(container_of(work, struct io_kiocb, work), data);
+}
+
+static void io_attempt_cancel(struct io_ring_ctx *ctx, struct io_kiocb *req)
+{
+	enum io_wq_cancel cret;
+
+	/* cancel this particular work, if it's running */
+	cret = io_wq_cancel_work(ctx->io_wq, &req->work);
+	if (cret != IO_WQ_CANCEL_NOTFOUND)
+		return;
+
+	/* find links that hold this pending, cancel those */
+	cret = io_wq_cancel_cb(ctx->io_wq, io_cancel_link_cb, req, true);
+	if (cret != IO_WQ_CANCEL_NOTFOUND)
+		return;
+
+	/* if we have a poll link holding this pending, cancel that */
+	if (io_poll_remove_link(ctx, req))
+		return;
+
+	/* final option, timeout link is holding this req pending */
+	io_timeout_remove_link(ctx, req);
+}
+
 static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 				  struct files_struct *files)
 {
@@ -8116,10 +8143,8 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 				continue;
 			}
 		} else {
-			io_wq_cancel_work(ctx->io_wq, &cancel_req->work);
-			/* could be a link, check and remove if it is */
-			if (!io_poll_remove_link(ctx, cancel_req))
-				io_timeout_remove_link(ctx, cancel_req);
+			/* cancel this request, or head link requests */
+			io_attempt_cancel(ctx, cancel_req);
 			io_put_req(cancel_req);
 		}
 

