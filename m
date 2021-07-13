Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8F793C6D72
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 11:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235238AbhGMJcr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Jul 2021 05:32:47 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:11296 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235188AbhGMJcq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Jul 2021 05:32:46 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4GPFbq2KSZz78ws;
        Tue, 13 Jul 2021 17:25:27 +0800 (CST)
Received: from dggpemm500002.china.huawei.com (7.185.36.229) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 13 Jul 2021 17:29:52 +0800
Received: from linux-ibm.site (10.175.102.37) by
 dggpemm500002.china.huawei.com (7.185.36.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 13 Jul 2021 17:29:51 +0800
From:   Hanjun Guo <guohanjun@huawei.com>
To:     <stable@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Matthew Wilcox <willy@infradead.org>,
        yangerkun <yangerkun@huawei.com>,
        Hanjun Guo <guohanjun@huawei.com>
Subject: [Backport for 5.10.y PATCH 5/7] io_uring: convert io_buffer_idr to XArray
Date:   Tue, 13 Jul 2021 17:18:35 +0800
Message-ID: <1626167917-11972-6-git-send-email-guohanjun@huawei.com>
X-Mailer: git-send-email 1.7.12.4
In-Reply-To: <1626167917-11972-1-git-send-email-guohanjun@huawei.com>
References: <1626167917-11972-1-git-send-email-guohanjun@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.102.37]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500002.china.huawei.com (7.185.36.229)
X-CFilter-Loop: Reflected
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
---
 fs/io_uring.c | 43 +++++++++++++++----------------------------
 1 file changed, 15 insertions(+), 28 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index cd93bf5..fb63cc8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -344,7 +344,7 @@ struct io_ring_ctx {
 	struct socket		*ring_sock;
 #endif
 
-	struct idr		io_buffer_idr;
+	struct xarray		io_buffers;
 
 	struct xarray		personalities;
 	u32			pers_next;
@@ -1212,7 +1212,7 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_LIST_HEAD(&ctx->cq_overflow_list);
 	init_completion(&ctx->ref_comp);
 	init_completion(&ctx->sq_thread_comp);
-	idr_init(&ctx->io_buffer_idr);
+	xa_init_flags(&ctx->io_buffers, XA_FLAGS_ALLOC1);
 	xa_init_flags(&ctx->personalities, XA_FLAGS_ALLOC1);
 	mutex_init(&ctx->uring_lock);
 	init_waitqueue_head(&ctx->wait);
@@ -2990,7 +2990,7 @@ static struct io_buffer *io_buffer_select(struct io_kiocb *req, size_t *len,
 
 	lockdep_assert_held(&req->ctx->uring_lock);
 
-	head = idr_find(&req->ctx->io_buffer_idr, bgid);
+	head = xa_load(&req->ctx->io_buffers, bgid);
 	if (head) {
 		if (!list_empty(&head->list)) {
 			kbuf = list_last_entry(&head->list, struct io_buffer,
@@ -2998,7 +2998,7 @@ static struct io_buffer *io_buffer_select(struct io_kiocb *req, size_t *len,
 			list_del(&kbuf->list);
 		} else {
 			kbuf = head;
-			idr_remove(&req->ctx->io_buffer_idr, bgid);
+			xa_erase(&req->ctx->io_buffers, bgid);
 		}
 		if (*len > kbuf->len)
 			*len = kbuf->len;
@@ -3960,7 +3960,7 @@ static int __io_remove_buffers(struct io_ring_ctx *ctx, struct io_buffer *buf,
 	}
 	i++;
 	kfree(buf);
-	idr_remove(&ctx->io_buffer_idr, bgid);
+	xa_erase(&ctx->io_buffers, bgid);
 
 	return i;
 }
@@ -3978,7 +3978,7 @@ static int io_remove_buffers(struct io_kiocb *req, bool force_nonblock,
 	lockdep_assert_held(&ctx->uring_lock);
 
 	ret = -ENOENT;
-	head = idr_find(&ctx->io_buffer_idr, p->bgid);
+	head = xa_load(&ctx->io_buffers, p->bgid);
 	if (head)
 		ret = __io_remove_buffers(ctx, head, p->bgid, p->nbufs);
 	if (ret < 0)
@@ -4069,21 +4069,14 @@ static int io_provide_buffers(struct io_kiocb *req, bool force_nonblock,
 
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
 
@@ -8411,19 +8404,13 @@ static int io_eventfd_unregister(struct io_ring_ctx *ctx)
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
-- 
1.7.12.4

