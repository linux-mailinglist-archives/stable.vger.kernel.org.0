Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAE823CA7A6
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241471AbhGOSzt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:55:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:55914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240454AbhGOSx7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:53:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E763613CF;
        Thu, 15 Jul 2021 18:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375064;
        bh=mzIhBdU7ALCjhBTSqRWH2HaTlHDvIODYITh1t62usKQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ELwAb0V6K9z2yTi3y3fn1fZNoJ3xrMZwpe3j3OoXCXILjY44bEOEzp8A7kVX4p9SV
         JNU7KwiZK9a4gVYwdGsbFJf7ElSRFn+xCjdcKCewFYCUGHVqVa/la52ENwH6lEqHhp
         zkh8Dw/LWI8ULHDNPfGmQmguf2jmZridBnCadVFA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        yangerkun <yangerkun@huawei.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Hanjun Guo <guohanjun@huawei.com>
Subject: [PATCH 5.10 142/215] io_uring: Convert personality_idr to XArray
Date:   Thu, 15 Jul 2021 20:38:34 +0200
Message-Id: <20210715182624.702615495@linuxfoundation.org>
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

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

commit 61cf93700fe6359552848ed5e3becba6cd760efa upstream.

You can't call idr_remove() from within a idr_for_each() callback,
but you can call xa_erase() from an xa_for_each() loop, so switch the
entire personality_idr from the IDR to the XArray.  This manifests as a
use-after-free as idr_for_each() attempts to walk the rest of the node
after removing the last entry from it.

Fixes: 071698e13ac6 ("io_uring: allow registering credentials")
Cc: stable@vger.kernel.org # 5.6+
Reported-by: yangerkun <yangerkun@huawei.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
[Pavel: rebased (creds load was moved into io_init_req())]
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/7ccff36e1375f2b0ebf73d957f037b43becc0dde.1615212806.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Hanjun Guo <guohanjun@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   59 +++++++++++++++++++++++++++++-----------------------------
 1 file changed, 30 insertions(+), 29 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -346,7 +346,8 @@ struct io_ring_ctx {
 
 	struct idr		io_buffer_idr;
 
-	struct idr		personality_idr;
+	struct xarray		personalities;
+	u32			pers_next;
 
 	struct {
 		unsigned		cached_cq_tail;
@@ -1212,7 +1213,7 @@ static struct io_ring_ctx *io_ring_ctx_a
 	init_completion(&ctx->ref_comp);
 	init_completion(&ctx->sq_thread_comp);
 	idr_init(&ctx->io_buffer_idr);
-	idr_init(&ctx->personality_idr);
+	xa_init_flags(&ctx->personalities, XA_FLAGS_ALLOC1);
 	mutex_init(&ctx->uring_lock);
 	init_waitqueue_head(&ctx->wait);
 	spin_lock_init(&ctx->completion_lock);
@@ -6629,7 +6630,7 @@ static int io_init_req(struct io_ring_ct
 	if (id) {
 		struct io_identity *iod;
 
-		iod = idr_find(&ctx->personality_idr, id);
+		iod = xa_load(&ctx->personalities, id);
 		if (unlikely(!iod))
 			return -EINVAL;
 		refcount_inc(&iod->count);
@@ -8445,7 +8446,6 @@ static void io_ring_ctx_free(struct io_r
 	io_sqe_files_unregister(ctx);
 	io_eventfd_unregister(ctx);
 	io_destroy_buffers(ctx);
-	idr_destroy(&ctx->personality_idr);
 
 #if defined(CONFIG_UNIX)
 	if (ctx->ring_sock) {
@@ -8509,7 +8509,7 @@ static int io_unregister_personality(str
 {
 	struct io_identity *iod;
 
-	iod = idr_remove(&ctx->personality_idr, id);
+	iod = xa_erase(&ctx->personalities, id);
 	if (iod) {
 		put_cred(iod->creds);
 		if (refcount_dec_and_test(&iod->count))
@@ -8520,14 +8520,6 @@ static int io_unregister_personality(str
 	return -EINVAL;
 }
 
-static int io_remove_personalities(int id, void *p, void *data)
-{
-	struct io_ring_ctx *ctx = data;
-
-	io_unregister_personality(ctx, id);
-	return 0;
-}
-
 static void io_ring_exit_work(struct work_struct *work)
 {
 	struct io_ring_ctx *ctx = container_of(work, struct io_ring_ctx,
@@ -8554,6 +8546,9 @@ static bool io_cancel_ctx_cb(struct io_w
 
 static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 {
+	unsigned long index;
+	struct io_identify *iod;
+
 	mutex_lock(&ctx->uring_lock);
 	percpu_ref_kill(&ctx->refs);
 	/* if force is set, the ring is going away. always drop after that */
@@ -8574,7 +8569,8 @@ static void io_ring_ctx_wait_and_kill(st
 
 	/* if we failed setting up the ctx, we might not have any rings */
 	io_iopoll_try_reap_events(ctx);
-	idr_for_each(&ctx->personality_idr, io_remove_personalities, ctx);
+	xa_for_each(&ctx->personalities, index, iod)
+		 io_unregister_personality(ctx, index);
 
 	/*
 	 * Do this upfront, so we won't have a grace period where the ring
@@ -9137,11 +9133,10 @@ out_fput:
 }
 
 #ifdef CONFIG_PROC_FS
-static int io_uring_show_cred(int id, void *p, void *data)
+static int io_uring_show_cred(struct seq_file *m, unsigned int id,
+		const struct io_identity *iod)
 {
-	struct io_identity *iod = p;
 	const struct cred *cred = iod->creds;
-	struct seq_file *m = data;
 	struct user_namespace *uns = seq_user_ns(m);
 	struct group_info *gi;
 	kernel_cap_t cap;
@@ -9209,9 +9204,13 @@ static void __io_uring_show_fdinfo(struc
 		seq_printf(m, "%5u: 0x%llx/%u\n", i, buf->ubuf,
 						(unsigned int) buf->len);
 	}
-	if (has_lock && !idr_is_empty(&ctx->personality_idr)) {
+	if (has_lock && !xa_empty(&ctx->personalities)) {
+		unsigned long index;
+		const struct io_identity *iod;
+
 		seq_printf(m, "Personalities:\n");
-		idr_for_each(&ctx->personality_idr, io_uring_show_cred, m);
+		xa_for_each(&ctx->personalities, index, iod)
+			io_uring_show_cred(m, index, iod);
 	}
 	seq_printf(m, "PollList:\n");
 	spin_lock_irq(&ctx->completion_lock);
@@ -9597,21 +9596,23 @@ out:
 
 static int io_register_personality(struct io_ring_ctx *ctx)
 {
-	struct io_identity *id;
+	struct io_identity *iod;
+	u32 id;
 	int ret;
 
-	id = kmalloc(sizeof(*id), GFP_KERNEL);
-	if (unlikely(!id))
+	iod = kmalloc(sizeof(*iod), GFP_KERNEL);
+	if (unlikely(!iod))
 		return -ENOMEM;
 
-	io_init_identity(id);
-	id->creds = get_current_cred();
+	io_init_identity(iod);
+	iod->creds = get_current_cred();
 
-	ret = idr_alloc_cyclic(&ctx->personality_idr, id, 1, USHRT_MAX, GFP_KERNEL);
-	if (ret < 0) {
-		put_cred(id->creds);
-		kfree(id);
-	}
+	ret = xa_alloc_cyclic(&ctx->personalities, &id, (void *)iod,
+			XA_LIMIT(0, USHRT_MAX), &ctx->pers_next, GFP_KERNEL);
+	if (!ret)
+		return id;
+	put_cred(iod->creds);
+	kfree(iod);
 	return ret;
 }
 


