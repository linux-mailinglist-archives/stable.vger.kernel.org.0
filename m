Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88F762474B5
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730653AbgHQTOD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:14:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:48882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729854AbgHQPkN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:40:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DFA67208E4;
        Mon, 17 Aug 2020 15:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678812;
        bh=RwQ4Vqbzdx4dhV3g5K9L294CZeBevf6Y+pNielysLTg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FX51fbEBjJalD0zdzs2+xjAy0MZnI9Hi8A3Jlfsvy7o0WfSoZtynTJaFuzriOmP3k
         xnfNmKNa89ujnOpdhtdn3v9/PPagICw8TIvY+xwvKOaLBNvo+r1RRSdlNpEb6Qlbyn
         yR67NXxSy2qYpj/G2eg8GVBZurxddLBUvse8h+CY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef <josef.grieb@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.8 463/464] io_uring: enable lookup of links holding inflight files
Date:   Mon, 17 Aug 2020 17:16:56 +0200
Message-Id: <20200817143855.956807968@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit f254ac04c8744cf7bfed012717eac34eacc65dfb upstream.

When a process exits, we cancel whatever requests it has pending that
are referencing the file table. However, if a link is holding a
reference, then we cannot find it by simply looking at the inflight
list.

Enable checking of the poll and timeout list to find the link, and
cancel it appropriately.

Cc: stable@vger.kernel.org
Reported-by: Josef <josef.grieb@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 fs/io_uring.c |   97 ++++++++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 87 insertions(+), 10 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4586,6 +4586,7 @@ static bool io_poll_remove_one(struct io
 		io_cqring_fill_event(req, -ECANCELED);
 		io_commit_cqring(req->ctx);
 		req->flags |= REQ_F_COMP_LOCKED;
+		req_set_fail_links(req);
 		io_put_req(req);
 	}
 
@@ -4759,6 +4760,23 @@ static enum hrtimer_restart io_timeout_f
 	return HRTIMER_NORESTART;
 }
 
+static int __io_timeout_cancel(struct io_kiocb *req)
+{
+	int ret;
+
+	list_del_init(&req->list);
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
@@ -4766,7 +4784,6 @@ static int io_timeout_cancel(struct io_r
 
 	list_for_each_entry(req, &ctx->timeout_list, list) {
 		if (user_data == req->user_data) {
-			list_del_init(&req->list);
 			ret = 0;
 			break;
 		}
@@ -4775,15 +4792,7 @@ static int io_timeout_cancel(struct io_r
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
@@ -7535,6 +7544,71 @@ static bool io_wq_files_match(struct io_
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
+	list_for_each_entry(preq, &ctx->timeout_list, list) {
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
@@ -7592,6 +7666,9 @@ static void io_uring_cancel_files(struct
 			}
 		} else {
 			io_wq_cancel_work(ctx->io_wq, &cancel_req->work);
+			/* could be a link, check and remove if it is */
+			if (!io_poll_remove_link(ctx, cancel_req))
+				io_timeout_remove_link(ctx, cancel_req);
 			io_put_req(cancel_req);
 		}
 


