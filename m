Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9334B156A79
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 14:06:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727698AbgBINGz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 08:06:55 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:38395 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727473AbgBINGz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Feb 2020 08:06:55 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 081BC21EBC;
        Sun,  9 Feb 2020 08:06:54 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 09 Feb 2020 08:06:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=6t679B
        LY+UJSzWR24hDYRaQwJUdipmO0k3BKqh2/yT8=; b=4ISguw58WlF6RLOMdzfgbA
        yOys270ub0X05LntWAOT8uaRS2gk5QwPT7K44RRT7PXCEnTJDgcQtHZ2OqmpTOT4
        c4DXw2DOne6T8HEyj2ibF8UyoNPLXyUj7NPjlFcGdA598Nm33yJgFsp3Hnvjjeqq
        Ur/9ClrL072AY5uQj+fUDcaCZopciC5r5vzK8WhHwiHRV5ZGyNLCYHk589iW8pcH
        wNp9eDKjkBdrPAiEAQ9f10gSYvBw9p24gmbc/gBTaQNDZXaq26HCb8XvW0mUU9u+
        1XFEo/bxeQZLetyhtFDlOZhz9+wZM8+pDz50fuUXUPkB7n6k9kTkg5YE/B9b4cDQ
        ==
X-ME-Sender: <xms:7QNAXhBd0O1eHRWgd6xcCOO833JGx26H-h9SUYeBcZSQ9IGLUAJoGQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheelgddvhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepfeekrdelkedrfeejrddufeehnecuvehluhhsthgvrhfuihiivgepjeenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:7QNAXr_1CYmvWHPEFCK_NiZ8dwYlpepqYz6_fa_5RVX1itphJkf8Zw>
    <xmx:7QNAXolQXtmoKzsWAavQn1kDku-XrCbzjrw3Aj1EQN8NS89M5LDgBg>
    <xmx:7QNAXtMLWEg26tLD6ZbWFnEUenLZtxdIA5-jkXnR5Jo9hppe_LiZpA>
    <xmx:7gNAXtKbM3rf7IyByb7uEyxKHBgjo30_swDANS3-wMJRxDMCWt0ScQ>
Received: from localhost (unknown [38.98.37.135])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3F6C030606E9;
        Sun,  9 Feb 2020 08:06:52 -0500 (EST)
Subject: FAILED: patch "[PATCH] io_uring: prevent potential eventfd recursion on poll" failed to apply to 5.4-stable tree
To:     axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 Feb 2020 12:52:50 +0100
Message-ID: <15812491701283@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f0b493e6b9a8959356983f57112229e69c2f7b8c Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Sat, 1 Feb 2020 21:30:11 -0700
Subject: [PATCH] io_uring: prevent potential eventfd recursion on poll

If we have nested or circular eventfd wakeups, then we can deadlock if
we run them inline from our poll waitqueue wakeup handler. It's also
possible to have very long chains of notifications, to the extent where
we could risk blowing the stack.

Check the eventfd recursion count before calling eventfd_signal(). If
it's non-zero, then punt the signaling to async context. This is always
safe, as it takes us out-of-line in terms of stack and locking context.

Cc: stable@vger.kernel.org # 5.1+
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 217721c7bc41..43f3b7d90299 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1020,21 +1020,28 @@ static struct io_uring_cqe *io_get_cqring(struct io_ring_ctx *ctx)
 
 static inline bool io_should_trigger_evfd(struct io_ring_ctx *ctx)
 {
+	if (!ctx->cq_ev_fd)
+		return false;
 	if (!ctx->eventfd_async)
 		return true;
 	return io_wq_current_is_worker() || in_interrupt();
 }
 
-static void io_cqring_ev_posted(struct io_ring_ctx *ctx)
+static void __io_cqring_ev_posted(struct io_ring_ctx *ctx, bool trigger_ev)
 {
 	if (waitqueue_active(&ctx->wait))
 		wake_up(&ctx->wait);
 	if (waitqueue_active(&ctx->sqo_wait))
 		wake_up(&ctx->sqo_wait);
-	if (ctx->cq_ev_fd && io_should_trigger_evfd(ctx))
+	if (trigger_ev)
 		eventfd_signal(ctx->cq_ev_fd, 1);
 }
 
+static void io_cqring_ev_posted(struct io_ring_ctx *ctx)
+{
+	__io_cqring_ev_posted(ctx, io_should_trigger_evfd(ctx));
+}
+
 /* Returns true if there are no backlogged entries after the flush */
 static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 {
@@ -3561,6 +3568,14 @@ static void io_poll_flush(struct io_wq_work **workptr)
 		__io_poll_flush(req->ctx, nodes);
 }
 
+static void io_poll_trigger_evfd(struct io_wq_work **workptr)
+{
+	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
+
+	eventfd_signal(req->ctx->cq_ev_fd, 1);
+	io_put_req(req);
+}
+
 static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 			void *key)
 {
@@ -3586,14 +3601,22 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 
 		if (llist_empty(&ctx->poll_llist) &&
 		    spin_trylock_irqsave(&ctx->completion_lock, flags)) {
+			bool trigger_ev;
+
 			hash_del(&req->hash_node);
 			io_poll_complete(req, mask, 0);
-			req->flags |= REQ_F_COMP_LOCKED;
-			io_put_req(req);
-			spin_unlock_irqrestore(&ctx->completion_lock, flags);
 
-			io_cqring_ev_posted(ctx);
-			req = NULL;
+			trigger_ev = io_should_trigger_evfd(ctx);
+			if (trigger_ev && eventfd_signal_count()) {
+				trigger_ev = false;
+				req->work.func = io_poll_trigger_evfd;
+			} else {
+				req->flags |= REQ_F_COMP_LOCKED;
+				io_put_req(req);
+				req = NULL;
+			}
+			spin_unlock_irqrestore(&ctx->completion_lock, flags);
+			__io_cqring_ev_posted(ctx, trigger_ev);
 		} else {
 			req->result = mask;
 			req->llist_node.next = NULL;

