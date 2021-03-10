Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A44F334BC6
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 23:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233841AbhCJWoj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 17:44:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233943AbhCJWoX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 17:44:23 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAC22C061764
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 14:44:22 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id ga23-20020a17090b0397b02900c0b81bbcd4so8059955pjb.0
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 14:44:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qcVOeUQhRs/9vWtpN/zYBknfy9jeviMZsnGOob8rcX4=;
        b=yiXwR/3w9+Ml2acRSMw8w5Mr6U2neEOITa+jqNqUZtftkkeuSfSI/siF4XCX+JN0l2
         MWQ3YopnNFb98vFlx/xQKCCcxuEaC/l1miaeg3KOqixLp1fnmcZ9xZ051Z4FNvKUJq1k
         uwzLgbV8PvxpidlYezJ2OMRu89sfu7ZzpHDM381BNvApYgqk5HXQ+qpEzkrZd1Ob3J1V
         dZvL5F+8KbcCxaEalhHBIG5r0mLWm7t23DEkumTge+NvrcRtKaszzo1L1zpBlREwsyXm
         S1gxbI+HTZ2MTxAWV06W7X9laX2m7udDFeOTWzS9BQyilJ0gkkaTgWX48IrxU2d5qzt5
         dUSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qcVOeUQhRs/9vWtpN/zYBknfy9jeviMZsnGOob8rcX4=;
        b=iTVSWkvM2jEodxDRn5BYOA5TSxMbqA3+DJ8hRdHjByvhdJiFYFx4WZr70do5z6bDWf
         DhoFXU92xE1e+3OHCMY7/IjNlcG+kEUpks62ExTVB3WXEpFPKh6bn6Hw+GyWPaX2iCmD
         0dsUPwgefKqCYfqrSzbG3WaOnSzsqcqqavWjzrGtQy2n8AmSSgd/057bsxaAMGmRfPk2
         NZUMWwMKHEogE6NXv9B2JPVpMhSbRHWGgJcxS/PyNNruIVb6a69V2z+2iJOqeCjApJhu
         pjsLy2jGfHYDD/2g/jT/1rOE5eAwK8iKYbGA0KVxMQMH0O07CIIp6ztrvZeNsV+Ec/ty
         F0kg==
X-Gm-Message-State: AOAM530h5m0RE/NC1zcohcXXiWP3Ysdhj/eNX2IXUZLPUa7qujeE5RG0
        60QDfTiIFcGwfeObu2lcQbymtOb7+OVl+A==
X-Google-Smtp-Source: ABdhPJwqRwsOmJkIDjqqLdWhQpNQV5jxrL++3lxgfzWHnlwDzeisv/ldet+Sbgo8tfTVSwtC/2yXqA==
X-Received: by 2002:a17:902:cec8:b029:e4:a497:da8d with SMTP id d8-20020a170902cec8b02900e4a497da8dmr5115754plg.16.1615416260794;
        Wed, 10 Mar 2021 14:44:20 -0800 (PST)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id j23sm475783pfn.94.2021.03.10.14.44.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 14:44:20 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        stable@vger.kernel.org, yangerkun <yangerkun@huawei.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 16/27] io_uring: Convert personality_idr to XArray
Date:   Wed, 10 Mar 2021 15:43:47 -0700
Message-Id: <20210310224358.1494503-17-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310224358.1494503-1-axboe@kernel.dk>
References: <20210310224358.1494503-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

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
---
 fs/io_uring.c | 47 ++++++++++++++++++++++++-----------------------
 1 file changed, 24 insertions(+), 23 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3f6db813d670..84eb499368a4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -406,7 +406,8 @@ struct io_ring_ctx {
 
 	struct idr		io_buffer_idr;
 
-	struct idr		personality_idr;
+	struct xarray		personalities;
+	u32			pers_next;
 
 	struct {
 		unsigned		cached_cq_tail;
@@ -1137,7 +1138,7 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	init_completion(&ctx->ref_comp);
 	init_completion(&ctx->sq_thread_comp);
 	idr_init(&ctx->io_buffer_idr);
-	idr_init(&ctx->personality_idr);
+	xa_init_flags(&ctx->personalities, XA_FLAGS_ALLOC1);
 	mutex_init(&ctx->uring_lock);
 	init_waitqueue_head(&ctx->wait);
 	spin_lock_init(&ctx->completion_lock);
@@ -6337,7 +6338,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	req->work.list.next = NULL;
 	personality = READ_ONCE(sqe->personality);
 	if (personality) {
-		req->work.creds = idr_find(&ctx->personality_idr, personality);
+		req->work.creds = xa_load(&ctx->personalities, personality);
 		if (!req->work.creds)
 			return -EINVAL;
 		get_cred(req->work.creds);
@@ -8355,7 +8356,6 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	mutex_unlock(&ctx->uring_lock);
 	io_eventfd_unregister(ctx);
 	io_destroy_buffers(ctx);
-	idr_destroy(&ctx->personality_idr);
 
 #if defined(CONFIG_UNIX)
 	if (ctx->ring_sock) {
@@ -8420,7 +8420,7 @@ static int io_unregister_personality(struct io_ring_ctx *ctx, unsigned id)
 {
 	const struct cred *creds;
 
-	creds = idr_remove(&ctx->personality_idr, id);
+	creds = xa_erase(&ctx->personalities, id);
 	if (creds) {
 		put_cred(creds);
 		return 0;
@@ -8429,14 +8429,6 @@ static int io_unregister_personality(struct io_ring_ctx *ctx, unsigned id)
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
 static bool io_run_ctx_fallback(struct io_ring_ctx *ctx)
 {
 	struct callback_head *work, *next;
@@ -8526,13 +8518,17 @@ static void io_ring_exit_work(struct work_struct *work)
 
 static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 {
+	unsigned long index;
+	struct creds *creds;
+
 	mutex_lock(&ctx->uring_lock);
 	percpu_ref_kill(&ctx->refs);
 	/* if force is set, the ring is going away. always drop after that */
 	ctx->cq_overflow_flushed = 1;
 	if (ctx->rings)
 		__io_cqring_overflow_flush(ctx, true, NULL, NULL);
-	idr_for_each(&ctx->personality_idr, io_remove_personalities, ctx);
+	xa_for_each(&ctx->personalities, index, creds)
+		io_unregister_personality(ctx, index);
 	mutex_unlock(&ctx->uring_lock);
 
 	io_kill_timeouts(ctx, NULL, NULL);
@@ -9162,10 +9158,9 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 }
 
 #ifdef CONFIG_PROC_FS
-static int io_uring_show_cred(int id, void *p, void *data)
+static int io_uring_show_cred(struct seq_file *m, unsigned int id,
+		const struct cred *cred)
 {
-	const struct cred *cred = p;
-	struct seq_file *m = data;
 	struct user_namespace *uns = seq_user_ns(m);
 	struct group_info *gi;
 	kernel_cap_t cap;
@@ -9233,9 +9228,13 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 		seq_printf(m, "%5u: 0x%llx/%u\n", i, buf->ubuf,
 						(unsigned int) buf->len);
 	}
-	if (has_lock && !idr_is_empty(&ctx->personality_idr)) {
+	if (has_lock && !xa_empty(&ctx->personalities)) {
+		unsigned long index;
+		const struct cred *cred;
+
 		seq_printf(m, "Personalities:\n");
-		idr_for_each(&ctx->personality_idr, io_uring_show_cred, m);
+		xa_for_each(&ctx->personalities, index, cred)
+			io_uring_show_cred(m, index, cred);
 	}
 	seq_printf(m, "PollList:\n");
 	spin_lock_irq(&ctx->completion_lock);
@@ -9564,14 +9563,16 @@ static int io_probe(struct io_ring_ctx *ctx, void __user *arg, unsigned nr_args)
 static int io_register_personality(struct io_ring_ctx *ctx)
 {
 	const struct cred *creds;
+	u32 id;
 	int ret;
 
 	creds = get_current_cred();
 
-	ret = idr_alloc_cyclic(&ctx->personality_idr, (void *) creds, 1,
-				USHRT_MAX, GFP_KERNEL);
-	if (ret < 0)
-		put_cred(creds);
+	ret = xa_alloc_cyclic(&ctx->personalities, &id, (void *)creds,
+			XA_LIMIT(0, USHRT_MAX), &ctx->pers_next, GFP_KERNEL);
+	if (!ret)
+		return id;
+	put_cred(creds);
 	return ret;
 }
 
-- 
2.30.2

