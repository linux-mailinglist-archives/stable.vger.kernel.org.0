Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0FCA3CA7B5
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241856AbhGOSz6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:55:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:57842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240599AbhGOSyA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:54:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDCB9613D0;
        Thu, 15 Jul 2021 18:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375067;
        bh=PolS+7aZnFZs1pDZxZ9Fgg0SpLVGAqOvR8aCwenTItE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V6JcmSufoRXvTOGmMSPsWrPuwa2VE+XtEACvx/JAs2BGOyj1RP8mfcZDMQ7f0bOeX
         AaM5zsEijjJvUU0WsLooN8CW52mVCg4BklRtXWZLpCHiSbnLLbbdEss9BIteYVcN4C
         pvXUVfrHQMo5dQSvhLnFJok31EmbtxyuKadSvMRk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        yangerkun <yangerkun@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Jens Axboe <axboe@kernel.dk>, Hanjun Guo <guohanjun@huawei.com>
Subject: [PATCH 5.10 143/215] io_uring: convert io_buffer_idr to XArray
Date:   Thu, 15 Jul 2021 20:38:35 +0200
Message-Id: <20210715182624.875109621@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182558.381078833@linuxfoundation.org>
References: <20210715182558.381078833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 9e15c3a0ced5a61f320b989072c24983cb1620c1 upstream.

Like we did for the personality idr, convert the IO buffer idr to use
XArray. This avoids a use-after-free on removal of entries, since idr
doesn't like doing so from inside an iterator, and it nicely reduces
the amount of code we need to support this feature.

Fixes: 5a2e745d4d43 ("io_uring: buffer registration infrastructure")
Cc: stable@vger.kernel.org
Cc: Matthew Wilcox <willy@infradead.org>
Cc: yangerkun <yangerkun@huawei.com>
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Hanjun Guo <guohanjun@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   43 +++++++++++++++----------------------------
 1 file changed, 15 insertions(+), 28 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -344,7 +344,7 @@ struct io_ring_ctx {
 	struct socket		*ring_sock;
 #endif
 
-	struct idr		io_buffer_idr;
+	struct xarray		io_buffers;
 
 	struct xarray		personalities;
 	u32			pers_next;
@@ -1212,7 +1212,7 @@ static struct io_ring_ctx *io_ring_ctx_a
 	INIT_LIST_HEAD(&ctx->cq_overflow_list);
 	init_completion(&ctx->ref_comp);
 	init_completion(&ctx->sq_thread_comp);
-	idr_init(&ctx->io_buffer_idr);
+	xa_init_flags(&ctx->io_buffers, XA_FLAGS_ALLOC1);
 	xa_init_flags(&ctx->personalities, XA_FLAGS_ALLOC1);
 	mutex_init(&ctx->uring_lock);
 	init_waitqueue_head(&ctx->wait);
@@ -2990,7 +2990,7 @@ static struct io_buffer *io_buffer_selec
 
 	lockdep_assert_held(&req->ctx->uring_lock);
 
-	head = idr_find(&req->ctx->io_buffer_idr, bgid);
+	head = xa_load(&req->ctx->io_buffers, bgid);
 	if (head) {
 		if (!list_empty(&head->list)) {
 			kbuf = list_last_entry(&head->list, struct io_buffer,
@@ -2998,7 +2998,7 @@ static struct io_buffer *io_buffer_selec
 			list_del(&kbuf->list);
 		} else {
 			kbuf = head;
-			idr_remove(&req->ctx->io_buffer_idr, bgid);
+			xa_erase(&req->ctx->io_buffers, bgid);
 		}
 		if (*len > kbuf->len)
 			*len = kbuf->len;
@@ -3960,7 +3960,7 @@ static int __io_remove_buffers(struct io
 	}
 	i++;
 	kfree(buf);
-	idr_remove(&ctx->io_buffer_idr, bgid);
+	xa_erase(&ctx->io_buffers, bgid);
 
 	return i;
 }
@@ -3978,7 +3978,7 @@ static int io_remove_buffers(struct io_k
 	lockdep_assert_held(&ctx->uring_lock);
 
 	ret = -ENOENT;
-	head = idr_find(&ctx->io_buffer_idr, p->bgid);
+	head = xa_load(&ctx->io_buffers, p->bgid);
 	if (head)
 		ret = __io_remove_buffers(ctx, head, p->bgid, p->nbufs);
 	if (ret < 0)
@@ -4069,21 +4069,14 @@ static int io_provide_buffers(struct io_
 
 	lockdep_assert_held(&ctx->uring_lock);
 
-	list = head = idr_find(&ctx->io_buffer_idr, p->bgid);
+	list = head = xa_load(&ctx->io_buffers, p->bgid);
 
 	ret = io_add_buffers(p, &head);
-	if (ret < 0)
-		goto out;
-
-	if (!list) {
-		ret = idr_alloc(&ctx->io_buffer_idr, head, p->bgid, p->bgid + 1,
-					GFP_KERNEL);
-		if (ret < 0) {
+	if (ret >= 0 && !list) {
+		ret = xa_insert(&ctx->io_buffers, p->bgid, head, GFP_KERNEL);
+		if (ret < 0)
 			__io_remove_buffers(ctx, head, p->bgid, -1U);
-			goto out;
-		}
 	}
-out:
 	if (ret < 0)
 		req_set_fail_links(req);
 
@@ -8411,19 +8404,13 @@ static int io_eventfd_unregister(struct
 	return -ENXIO;
 }
 
-static int __io_destroy_buffers(int id, void *p, void *data)
-{
-	struct io_ring_ctx *ctx = data;
-	struct io_buffer *buf = p;
-
-	__io_remove_buffers(ctx, buf, id, -1U);
-	return 0;
-}
-
 static void io_destroy_buffers(struct io_ring_ctx *ctx)
 {
-	idr_for_each(&ctx->io_buffer_idr, __io_destroy_buffers, ctx);
-	idr_destroy(&ctx->io_buffer_idr);
+	struct io_buffer *buf;
+	unsigned long index;
+
+	xa_for_each(&ctx->io_buffers, index, buf)
+		__io_remove_buffers(ctx, buf, index, -1U);
 }
 
 static void io_ring_ctx_free(struct io_ring_ctx *ctx)


