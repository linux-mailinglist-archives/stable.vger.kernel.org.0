Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C246D32C9B4
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 02:19:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242394AbhCDBLn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 20:11:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377147AbhCDAfH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Mar 2021 19:35:07 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66BB3C0610E1
        for <stable@vger.kernel.org>; Wed,  3 Mar 2021 16:27:38 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id p21so17617144pgl.12
        for <stable@vger.kernel.org>; Wed, 03 Mar 2021 16:27:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MdOQXO5s1LRmfJZAlCCQoY3A32Jz6+Xg1d+y3FqmJPI=;
        b=T6VxujvHaMvH+E5gqVKJkG+Ho+9ShHRUazQEIfMcVwHMa/uPDJPG9laZkp1/e+A9Cp
         3g21brf6VXxdQKRH4NwZW+YczOCiujUrQfLDhpwhPK3TRnSuNlABHPyYLYTHo3VIMsvk
         n3ZEvyPqWSykxWn1b4D6T3e+PRhlyxI8ImJ1fA2lHtZbmIzRYKcFAmw6DuY9MMETauyH
         lQc+u1w2doLWmS3kEv5dRkU/FdxzaUHaDfBgd2uRt5sTcz1ovEGzIcRTnlreorR5VVUn
         SuNVUxzTeDo7sYMkGhfeguga9pGVrbJumB4TgnQPwDkg6AVSPjM4SOSj0k2LTpcOP47G
         7mnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MdOQXO5s1LRmfJZAlCCQoY3A32Jz6+Xg1d+y3FqmJPI=;
        b=JW4OPQ3SAmxVoCyUGaHTP5h72HZRjRCeHIhmItGLlek/r4TwfA8GQ3SbN7Q4gGzRmt
         6KwydRLFOCSwQzs1Ofike9qpeOMFjv0sx8mqbCAahA3pYye6xw8mNxALnEDIRGfkhk/i
         mLXR0p1QL9yAfCeiBbzfPrpdt1rrWGDbSGdFB45rKCDIGPz3vra5YjsJ3CQDKkc4DRpH
         XS1GZV3Ab4Q0lqVw99bMr414KiAxiGsCE8RAyMhFDWj8fgqdUEnrgVHo0KRQLJStXnCA
         CF4fIJkJGq3xGr1DNiR4OgC4bNGp1F80ORiCHVcjC+BFa78oNbiL13BfnZORj+eYKlnB
         iiPw==
X-Gm-Message-State: AOAM530vLRT0p8AqDMt+fJOv92J7hygOIWKLCsawUSeWq3gc7roPRMQ0
        UVRy7bLzHl0MCfqITttiTbgMXLR3mWBOMjRR
X-Google-Smtp-Source: ABdhPJwMA7G/UHXtaBFiqoy0t/I/fAu/As2+Az9KgbEO7UbmpfSsPRGZry8Qpn6uXbZ1I31k3ueSdw==
X-Received: by 2002:aa7:8b59:0:b029:1e9:8229:c100 with SMTP id i25-20020aa78b590000b02901e98229c100mr1584607pfd.19.1614817657928;
        Wed, 03 Mar 2021 16:27:37 -0800 (PST)
Received: from localhost.localdomain ([2600:380:7540:52b5:3f01:150c:3b2:bf47])
        by smtp.gmail.com with ESMTPSA id b6sm23456983pgt.69.2021.03.03.16.27.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 16:27:37 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, stable@vger.kernel.org,
        Abaci Robot <abaci@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: [PATCH 27/33] io_uring: fix -EAGAIN retry with IOPOLL
Date:   Wed,  3 Mar 2021 17:26:54 -0700
Message-Id: <20210304002700.374417-28-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210304002700.374417-1-axboe@kernel.dk>
References: <20210304002700.374417-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We no longer revert the iovec on -EIOCBQUEUED, see commit ab2125df921d,
and this started causing issues for IOPOLL on devies that run out of
request slots. Turns out what outside of needing a revert for those, we
also had a bug where we didn't properly setup retry inside the submission
path. That could cause re-import of the iovec, if any, and that could lead
to spurious results if the application had those allocated on the stack.

Catch -EAGAIN retry and make the iovec stable for IOPOLL, just like we do
for !IOPOLL retries.

Cc: <stable@vger.kernel.org> # 5.9+
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Reported-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 36 +++++++++++++++++++++++++++++++-----
 1 file changed, 31 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 28a360aac4a3..c765b7fba8a1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2423,23 +2423,32 @@ static bool io_resubmit_prep(struct io_kiocb *req)
 		return false;
 	return !io_setup_async_rw(req, iovec, inline_vecs, &iter, false);
 }
-#endif
 
-static bool io_rw_reissue(struct io_kiocb *req)
+static bool io_rw_should_reissue(struct io_kiocb *req)
 {
-#ifdef CONFIG_BLOCK
 	umode_t mode = file_inode(req->file)->i_mode;
+	struct io_ring_ctx *ctx = req->ctx;
 
 	if (!S_ISBLK(mode) && !S_ISREG(mode))
 		return false;
-	if ((req->flags & REQ_F_NOWAIT) || io_wq_current_is_worker())
+	if ((req->flags & REQ_F_NOWAIT) || (io_wq_current_is_worker() &&
+	    !(ctx->flags & IORING_SETUP_IOPOLL)))
 		return false;
 	/*
 	 * If ref is dying, we might be running poll reap from the exit work.
 	 * Don't attempt to reissue from that path, just let it fail with
 	 * -EAGAIN.
 	 */
-	if (percpu_ref_is_dying(&req->ctx->refs))
+	if (percpu_ref_is_dying(&ctx->refs))
+		return false;
+	return true;
+}
+#endif
+
+static bool io_rw_reissue(struct io_kiocb *req)
+{
+#ifdef CONFIG_BLOCK
+	if (!io_rw_should_reissue(req))
 		return false;
 
 	lockdep_assert_held(&req->ctx->uring_lock);
@@ -2482,6 +2491,19 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
 {
 	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
 
+#ifdef CONFIG_BLOCK
+	/* Rewind iter, if we have one. iopoll path resubmits as usual */
+	if (res == -EAGAIN && io_rw_should_reissue(req)) {
+		struct io_async_rw *rw = req->async_data;
+
+		if (rw)
+			iov_iter_revert(&rw->iter,
+					req->result - iov_iter_count(&rw->iter));
+		else if (!io_resubmit_prep(req))
+			res = -EIO;
+	}
+#endif
+
 	if (kiocb->ki_flags & IOCB_WRITE)
 		kiocb_end_write(req);
 
@@ -3230,6 +3252,8 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 	ret = io_iter_do_read(req, iter);
 
 	if (ret == -EIOCBQUEUED) {
+		if (req->async_data)
+			iov_iter_revert(iter, io_size - iov_iter_count(iter));
 		goto out_free;
 	} else if (ret == -EAGAIN) {
 		/* IOPOLL retry should happen for io-wq threads */
@@ -3361,6 +3385,8 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	/* no retry on NONBLOCK nor RWF_NOWAIT */
 	if (ret2 == -EAGAIN && (req->flags & REQ_F_NOWAIT))
 		goto done;
+	if (ret2 == -EIOCBQUEUED && req->async_data)
+		iov_iter_revert(iter, io_size - iov_iter_count(iter));
 	if (!force_nonblock || ret2 != -EAGAIN) {
 		/* IOPOLL retry should happen for io-wq threads */
 		if ((req->ctx->flags & IORING_SETUP_IOPOLL) && ret2 == -EAGAIN)
-- 
2.30.1

