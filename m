Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB383C6D6C
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 11:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235139AbhGMJcn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Jul 2021 05:32:43 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:6808 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235071AbhGMJcn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Jul 2021 05:32:43 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GPFZR1MzTzWr15;
        Tue, 13 Jul 2021 17:24:15 +0800 (CST)
Received: from dggpemm500002.china.huawei.com (7.185.36.229) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 13 Jul 2021 17:29:51 +0800
Received: from linux-ibm.site (10.175.102.37) by
 dggpemm500002.china.huawei.com (7.185.36.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 13 Jul 2021 17:29:51 +0800
From:   Hanjun Guo <guohanjun@huawei.com>
To:     <stable@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Hanjun Guo <guohanjun@huawei.com>
Subject: [Backport for 5.10.y PATCH 4/7] io_uring: Convert personality_idr to XArray
Date:   Tue, 13 Jul 2021 17:18:34 +0800
Message-ID: <1626167917-11972-5-git-send-email-guohanjun@huawei.com>
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
---
 fs/io_uring.c | 59 ++++++++++++++++++++++++++++++-----------------------------
 1 file changed, 30 insertions(+), 29 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0cbf2a0..cd93bf5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -346,7 +346,8 @@ struct io_ring_ctx {
 
 	struct idr		io_buffer_idr;
 
-	struct idr		personality_idr;
+	struct xarray		personalities;
+	u32			pers_next;
 
 	struct {
 		unsigned		cached_cq_tail;
@@ -1212,7 +1213,7 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	init_completion(&ctx->ref_comp);
 	init_completion(&ctx->sq_thread_comp);
 	idr_init(&ctx->io_buffer_idr);
-	idr_init(&ctx->personality_idr);
+	xa_init_flags(&ctx->personalities, XA_FLAGS_ALLOC1);
 	mutex_init(&ctx->uring_lock);
 	init_waitqueue_head(&ctx->wait);
 	spin_lock_init(&ctx->completion_lock);
@@ -6629,7 +6630,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	if (id) {
 		struct io_identity *iod;
 
-		iod = idr_find(&ctx->personality_idr, id);
+		iod = xa_load(&ctx->personalities, id);
 		if (unlikely(!iod))
 			return -EINVAL;
 		refcount_inc(&iod->count);
@@ -8445,7 +8446,6 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	io_sqe_files_unregister(ctx);
 	io_eventfd_unregister(ctx);
 	io_destroy_buffers(ctx);
-	idr_destroy(&ctx->personality_idr);
 
 #if defined(CONFIG_UNIX)
 	if (ctx->ring_sock) {
@@ -8509,7 +8509,7 @@ static int io_unregister_personality(struct io_ring_ctx *ctx, unsigned id)
 {
 	struct io_identity *iod;
 
-	iod = idr_remove(&ctx->personality_idr, id);
+	iod = xa_erase(&ctx->personalities, id);
 	if (iod) {
 		put_cred(iod->creds);
 		if (refcount_dec_and_test(&iod->count))
@@ -8520,14 +8520,6 @@ static int io_unregister_personality(struct io_ring_ctx *ctx, unsigned id)
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
@@ -8554,6 +8546,9 @@ static bool io_cancel_ctx_cb(struct io_wq_work *work, void *data)
 
 static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 {
+	unsigned long index;
+	struct io_identify *iod;
+
 	mutex_lock(&ctx->uring_lock);
 	percpu_ref_kill(&ctx->refs);
 	/* if force is set, the ring is going away. always drop after that */
@@ -8574,7 +8569,8 @@ static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 
 	/* if we failed setting up the ctx, we might not have any rings */
 	io_iopoll_try_reap_events(ctx);
-	idr_for_each(&ctx->personality_idr, io_remove_personalities, ctx);
+	xa_for_each(&ctx->personalities, index, iod)
+		 io_unregister_personality(ctx, index);
 
 	/*
 	 * Do this upfront, so we won't have a grace period where the ring
@@ -9137,11 +9133,10 @@ static int io_sqpoll_wait_sq(struct io_ring_ctx *ctx)
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
@@ -9209,9 +9204,13 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
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
@@ -9597,21 +9596,23 @@ static int io_probe(struct io_ring_ctx *ctx, void __user *arg, unsigned nr_args)
 
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
 
-- 
1.7.12.4

