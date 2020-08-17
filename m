Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BBCE2464AD
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 12:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726161AbgHQKm4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 06:42:56 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:44943 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726151AbgHQKmz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Aug 2020 06:42:55 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id CBEF71941BEE;
        Mon, 17 Aug 2020 06:42:54 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 17 Aug 2020 06:42:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=RBen5N
        3GoCjWcrJvLqcvJ2CldR6/zpk7C6f4y4YUfLY=; b=E63VsYLrzM6D5vwk9WfFF+
        PRIKxcdsYeh9MbeMOn/pK7CIo48NTu6FKmLms7fWopYDJJGSSZZlvAARVGv/XZLw
        VPvVJJClSB36qdyfneWtbZLM9lPwl5vNJbrLypHnGCzyg6uJvM2ETNAcv0HXgeTM
        KPlYtYPzS07IOeKCKMF476ewXMO7qgAEW3IGO9AGbaU0xlPJ3L+he/DVhz9UIjB1
        xlRq8IGTFXy8R/bwuWdXIo7kH72KEbmru0roSUS5IhmV/p4pWMIOPpOaXE0eZLOX
        lWyQmFLIjj4lu+xjJqNBhqzqVtpUH49XDgenfDKVLi/xju6evCGf+p9svCYJBlOA
        ==
X-ME-Sender: <xms:Ll86X-Ekyrntzh_VQat8kuQex0f6msH67_wcfCCOH6MpKHJGjBUIlg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtfedgfedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:Ll86X_X1lR24gv-nbEYmo12jOFQbqXjcNxhRO5HJJp3jbNLr9MjqYA>
    <xmx:Ll86X4IvEH8t-wrp-B9PYPbDvjuVU-yZnYcmNRBbRrLzfFDRJ6NkXA>
    <xmx:Ll86X4FyTnEkVJ8kxXyoUqdhj0i_jxzlxghbn8YPwqeX5naNCZQlyw>
    <xmx:Ll86X8jqyx9DNqu0-2lcjJsSU6Ww72eoG0fTxVLljJatIIOlpc93yA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 345BB3280063;
        Mon, 17 Aug 2020 06:42:54 -0400 (EDT)
Subject: FAILED: patch "[PATCH] io_uring: sanitize double poll handling" failed to apply to 5.7-stable tree
To:     axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 Aug 2020 12:43:14 +0200
Message-ID: <1597660994188250@kroah.com>
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

From d4e7cd36a90e38e0276d6ce0c20f5ccef17ec38c Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Sat, 15 Aug 2020 11:44:50 -0700
Subject: [PATCH] io_uring: sanitize double poll handling

There's a bit of confusion on the matching pairs of poll vs double poll,
depending on if the request is a pure poll (IORING_OP_POLL_ADD) or
poll driven retry.

Add io_poll_get_double() that returns the double poll waitqueue, if any,
and io_poll_get_single() that returns the original poll waitqueue. With
that, remove the argument to io_poll_remove_double().

Finally ensure that wait->private is cleared once the double poll handler
has run, so that remove knows it's already been seen.

Cc: stable@vger.kernel.org # v5.8
Reported-by: syzbot+7f617d4a9369028b8a2c@syzkaller.appspotmail.com
Fixes: 18bceab101ad ("io_uring: allow POLL_ADD with double poll_wait() users")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7dd6df15bc49..cb030912bf5e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4649,9 +4649,24 @@ static bool io_poll_rewait(struct io_kiocb *req, struct io_poll_iocb *poll)
 	return false;
 }
 
-static void io_poll_remove_double(struct io_kiocb *req, void *data)
+static struct io_poll_iocb *io_poll_get_double(struct io_kiocb *req)
 {
-	struct io_poll_iocb *poll = data;
+	/* pure poll stashes this in ->io, poll driven retry elsewhere */
+	if (req->opcode == IORING_OP_POLL_ADD)
+		return (struct io_poll_iocb *) req->io;
+	return req->apoll->double_poll;
+}
+
+static struct io_poll_iocb *io_poll_get_single(struct io_kiocb *req)
+{
+	if (req->opcode == IORING_OP_POLL_ADD)
+		return &req->poll;
+	return &req->apoll->poll;
+}
+
+static void io_poll_remove_double(struct io_kiocb *req)
+{
+	struct io_poll_iocb *poll = io_poll_get_double(req);
 
 	lockdep_assert_held(&req->ctx->completion_lock);
 
@@ -4671,7 +4686,7 @@ static void io_poll_complete(struct io_kiocb *req, __poll_t mask, int error)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
-	io_poll_remove_double(req, req->io);
+	io_poll_remove_double(req);
 	req->poll.done = true;
 	io_cqring_fill_event(req, error ? error : mangle_poll(mask));
 	io_commit_cqring(ctx);
@@ -4711,7 +4726,7 @@ static int io_poll_double_wake(struct wait_queue_entry *wait, unsigned mode,
 			       int sync, void *key)
 {
 	struct io_kiocb *req = wait->private;
-	struct io_poll_iocb *poll = req->apoll->double_poll;
+	struct io_poll_iocb *poll = io_poll_get_single(req);
 	__poll_t mask = key_to_poll(key);
 
 	/* for instances that support it check for an event match first: */
@@ -4725,6 +4740,8 @@ static int io_poll_double_wake(struct wait_queue_entry *wait, unsigned mode,
 		done = list_empty(&poll->wait.entry);
 		if (!done)
 			list_del_init(&poll->wait.entry);
+		/* make sure double remove sees this as being gone */
+		wait->private = NULL;
 		spin_unlock(&poll->head->lock);
 		if (!done)
 			__io_async_wake(req, poll, mask, io_poll_task_func);
@@ -4808,7 +4825,7 @@ static void io_async_task_func(struct callback_head *cb)
 	if (hash_hashed(&req->hash_node))
 		hash_del(&req->hash_node);
 
-	io_poll_remove_double(req, apoll->double_poll);
+	io_poll_remove_double(req);
 	spin_unlock_irq(&ctx->completion_lock);
 
 	if (!READ_ONCE(apoll->poll.canceled))
@@ -4919,7 +4936,7 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
 	ret = __io_arm_poll_handler(req, &apoll->poll, &ipt, mask,
 					io_async_wake);
 	if (ret || ipt.error) {
-		io_poll_remove_double(req, apoll->double_poll);
+		io_poll_remove_double(req);
 		spin_unlock_irq(&ctx->completion_lock);
 		kfree(apoll->double_poll);
 		kfree(apoll);
@@ -4951,14 +4968,13 @@ static bool io_poll_remove_one(struct io_kiocb *req)
 {
 	bool do_complete;
 
+	io_poll_remove_double(req);
+
 	if (req->opcode == IORING_OP_POLL_ADD) {
-		io_poll_remove_double(req, req->io);
 		do_complete = __io_poll_remove_one(req, &req->poll);
 	} else {
 		struct async_poll *apoll = req->apoll;
 
-		io_poll_remove_double(req, apoll->double_poll);
-
 		/* non-poll requests have submit ref still */
 		do_complete = __io_poll_remove_one(req, &apoll->poll);
 		if (do_complete) {

