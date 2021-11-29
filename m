Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0A2B46276E
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 00:03:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236248AbhK2XFu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 18:05:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237014AbhK2XFL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 18:05:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16A69C12BCF4;
        Mon, 29 Nov 2021 10:35:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2F6AB81600;
        Mon, 29 Nov 2021 18:35:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE8EEC53FC7;
        Mon, 29 Nov 2021 18:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210910;
        bh=y+4h0nia0EejekE2XvIkQW7NRN7wK5JjLNx7XnHf7q8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P2jRNBUC2dFL2P/Vnn+riG5DelEnq8ZYmfs6pFaYXWd7daOZnmYAn92CSkOa2QUyq
         JirkP3/GNIXE4rUqf28Vbls6hgcA8+ll+kryyrqXtZSd1mm8uFX7Zy2MJwggKibHLZ
         VSTrn57Z7+Otp+DfZDWGd7JHB1hv7CdNRdQi8B3w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, stable@kernel.org
Subject: [PATCH 5.15 038/179] io_uring: correct link-list traversal locking
Date:   Mon, 29 Nov 2021 19:17:12 +0100
Message-Id: <20211129181720.215225353@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit 674ee8e1b4a41d2fdffc885c55350c3fbb38c22a upstream.

As io_remove_next_linked() is now under ->timeout_lock (see
io_link_timeout_fn), we should update locking around io_for_each_link()
and io_match_task() to use the new lock.

Cc: stable@kernel.org # 5.15+
Fixes: 89850fce16a1a ("io_uring: run timeouts from task_work")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/b54541cedf7de59cb5ae36109e58529ca16e66aa.1637631883.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1430,10 +1430,10 @@ static void io_prep_async_link(struct io
 	if (req->flags & REQ_F_LINK_TIMEOUT) {
 		struct io_ring_ctx *ctx = req->ctx;
 
-		spin_lock(&ctx->completion_lock);
+		spin_lock_irq(&ctx->timeout_lock);
 		io_for_each_link(cur, req)
 			io_prep_async_work(cur);
-		spin_unlock(&ctx->completion_lock);
+		spin_unlock_irq(&ctx->timeout_lock);
 	} else {
 		io_for_each_link(cur, req)
 			io_prep_async_work(cur);
@@ -5697,6 +5697,7 @@ static bool io_poll_remove_all(struct io
 	int posted = 0, i;
 
 	spin_lock(&ctx->completion_lock);
+	spin_lock_irq(&ctx->timeout_lock);
 	for (i = 0; i < (1U << ctx->cancel_hash_bits); i++) {
 		struct hlist_head *list;
 
@@ -5706,6 +5707,7 @@ static bool io_poll_remove_all(struct io
 				posted += io_poll_remove_one(req);
 		}
 	}
+	spin_unlock_irq(&ctx->timeout_lock);
 	spin_unlock(&ctx->completion_lock);
 
 	if (posted)
@@ -9523,9 +9525,9 @@ static bool io_cancel_task_cb(struct io_
 		struct io_ring_ctx *ctx = req->ctx;
 
 		/* protect against races with linked timeouts */
-		spin_lock(&ctx->completion_lock);
+		spin_lock_irq(&ctx->timeout_lock);
 		ret = io_match_task(req, cancel->task, cancel->all);
-		spin_unlock(&ctx->completion_lock);
+		spin_unlock_irq(&ctx->timeout_lock);
 	} else {
 		ret = io_match_task(req, cancel->task, cancel->all);
 	}
@@ -9539,12 +9541,14 @@ static bool io_cancel_defer_files(struct
 	LIST_HEAD(list);
 
 	spin_lock(&ctx->completion_lock);
+	spin_lock_irq(&ctx->timeout_lock);
 	list_for_each_entry_reverse(de, &ctx->defer_list, list) {
 		if (io_match_task(de->req, task, cancel_all)) {
 			list_cut_position(&list, &ctx->defer_list, &de->list);
 			break;
 		}
 	}
+	spin_unlock_irq(&ctx->timeout_lock);
 	spin_unlock(&ctx->completion_lock);
 	if (list_empty(&list))
 		return false;


