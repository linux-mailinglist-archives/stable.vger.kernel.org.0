Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF6AF2464B5
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 12:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbgHQKne (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 06:43:34 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:58835 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726480AbgHQKnd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Aug 2020 06:43:33 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id EDB261941B59;
        Mon, 17 Aug 2020 06:43:31 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 17 Aug 2020 06:43:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=ul085L
        bE7ZTPA+lNO2YG9A52Z93IxcI/i5Xt0SABIC0=; b=MzR66ZfZrEQtA/KejfH/h2
        JTjXrodcYGrvIsOExXp2zTb51C3W4lxrdXsv4kl63MDqGVeOtMk5zkOvCvlYdo4g
        /d/QY3l3/HtbUt2X/MM0N7C/Osey1+C1zs+lgPU2EOtqseEOna7LcAs7mvX8R3Zd
        KJ9oE7TDouhe16gh98UEm0WX0tTUM6QemtxXSwz5wTO+fziSFfndQ5CigXu1X1Cs
        SqpHAZ/SpUOBPzYON1Kkq6M/C2O7Qe+gJYUzm+Sryv4fGSsEPV1MjQuQcm5kSfX4
        GYvbX6LX6Pu+6P0T2MYiDGw9bmribRe+ZuuFSyW2TLqZWTtmWZbwPt8AomC+9OQg
        ==
X-ME-Sender: <xms:U186X8_H4Ri_UYA0wbXKJaLrUkk4zKKSl-qTvf0jhet_XkeUy96l6A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtfedgfedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpeegnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:U186X0spcG5-WHvzqIWYQ9tRPzNOxVL_eBtIW5H2lcSM8_JlnToLLQ>
    <xmx:U186XyBPX92uvKDjIjlyTfuDLU2Bmv6yHOg7CLUc3INTIQ_uxHiHRA>
    <xmx:U186X8fcDtkLBQj0jHfRkxMIOGDNMavz7OzBACyHwI-87cBCNu74KQ>
    <xmx:U186X4YatuLSqWV7_MULFn2VGD1WjG82mgm9E-yfVYlqFEcJMCW7Wg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8D7533280063;
        Mon, 17 Aug 2020 06:43:31 -0400 (EDT)
Subject: FAILED: patch "[PATCH] io_uring: enable lookup of links holding inflight files" failed to apply to 5.8-stable tree
To:     axboe@kernel.dk, josef.grieb@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 Aug 2020 12:43:48 +0200
Message-ID: <159766102815889@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.8-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f254ac04c8744cf7bfed012717eac34eacc65dfb Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Wed, 12 Aug 2020 17:33:30 -0600
Subject: [PATCH] io_uring: enable lookup of links holding inflight files

When a process exits, we cancel whatever requests it has pending that
are referencing the file table. However, if a link is holding a
reference, then we cannot find it by simply looking at the inflight
list.

Enable checking of the poll and timeout list to find the link, and
cancel it appropriately.

Cc: stable@vger.kernel.org
Reported-by: Josef <josef.grieb@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8a2afd8c33c9..1ec25ee71372 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4937,6 +4937,7 @@ static bool io_poll_remove_one(struct io_kiocb *req)
 		io_cqring_fill_event(req, -ECANCELED);
 		io_commit_cqring(req->ctx);
 		req->flags |= REQ_F_COMP_LOCKED;
+		req_set_fail_links(req);
 		io_put_req(req);
 	}
 
@@ -5109,6 +5110,23 @@ static enum hrtimer_restart io_timeout_fn(struct hrtimer *timer)
 	return HRTIMER_NORESTART;
 }
 
+static int __io_timeout_cancel(struct io_kiocb *req)
+{
+	int ret;
+
+	list_del_init(&req->timeout.list);
+
+	ret = hrtimer_try_to_cancel(&req->io->timeout.timer);
+	if (ret == -1)
+		return -EALREADY;
+
+	req_set_fail_links(req);
+	req->flags |= REQ_F_COMP_LOCKED;
+	io_cqring_fill_event(req, -ECANCELED);
+	io_put_req(req);
+	return 0;
+}
+
 static int io_timeout_cancel(struct io_ring_ctx *ctx, __u64 user_data)
 {
 	struct io_kiocb *req;
@@ -5116,7 +5134,6 @@ static int io_timeout_cancel(struct io_ring_ctx *ctx, __u64 user_data)
 
 	list_for_each_entry(req, &ctx->timeout_list, timeout.list) {
 		if (user_data == req->user_data) {
-			list_del_init(&req->timeout.list);
 			ret = 0;
 			break;
 		}
@@ -5125,15 +5142,7 @@ static int io_timeout_cancel(struct io_ring_ctx *ctx, __u64 user_data)
 	if (ret == -ENOENT)
 		return ret;
 
-	ret = hrtimer_try_to_cancel(&req->io->timeout.timer);
-	if (ret == -1)
-		return -EALREADY;
-
-	req_set_fail_links(req);
-	req->flags |= REQ_F_COMP_LOCKED;
-	io_cqring_fill_event(req, -ECANCELED);
-	io_put_req(req);
-	return 0;
+	return __io_timeout_cancel(req);
 }
 
 static int io_timeout_remove_prep(struct io_kiocb *req,
@@ -7935,6 +7944,71 @@ static bool io_wq_files_match(struct io_wq_work *work, void *data)
 	return work->files == files;
 }
 
+/*
+ * Returns true if 'preq' is the link parent of 'req'
+ */
+static bool io_match_link(struct io_kiocb *preq, struct io_kiocb *req)
+{
+	struct io_kiocb *link;
+
+	if (!(preq->flags & REQ_F_LINK_HEAD))
+		return false;
+
+	list_for_each_entry(link, &preq->link_list, link_list) {
+		if (link == req)
+			return true;
+	}
+
+	return false;
+}
+
+/*
+ * We're looking to cancel 'req' because it's holding on to our files, but
+ * 'req' could be a link to another request. See if it is, and cancel that
+ * parent request if so.
+ */
+static bool io_poll_remove_link(struct io_ring_ctx *ctx, struct io_kiocb *req)
+{
+	struct hlist_node *tmp;
+	struct io_kiocb *preq;
+	bool found = false;
+	int i;
+
+	spin_lock_irq(&ctx->completion_lock);
+	for (i = 0; i < (1U << ctx->cancel_hash_bits); i++) {
+		struct hlist_head *list;
+
+		list = &ctx->cancel_hash[i];
+		hlist_for_each_entry_safe(preq, tmp, list, hash_node) {
+			found = io_match_link(preq, req);
+			if (found) {
+				io_poll_remove_one(preq);
+				break;
+			}
+		}
+	}
+	spin_unlock_irq(&ctx->completion_lock);
+	return found;
+}
+
+static bool io_timeout_remove_link(struct io_ring_ctx *ctx,
+				   struct io_kiocb *req)
+{
+	struct io_kiocb *preq;
+	bool found = false;
+
+	spin_lock_irq(&ctx->completion_lock);
+	list_for_each_entry(preq, &ctx->timeout_list, timeout.list) {
+		found = io_match_link(preq, req);
+		if (found) {
+			__io_timeout_cancel(preq);
+			break;
+		}
+	}
+	spin_unlock_irq(&ctx->completion_lock);
+	return found;
+}
+
 static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 				  struct files_struct *files)
 {
@@ -7989,6 +8063,9 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 			}
 		} else {
 			io_wq_cancel_work(ctx->io_wq, &cancel_req->work);
+			/* could be a link, check and remove if it is */
+			if (!io_poll_remove_link(ctx, cancel_req))
+				io_timeout_remove_link(ctx, cancel_req);
 			io_put_req(cancel_req);
 		}
 

