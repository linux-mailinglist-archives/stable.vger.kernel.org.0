Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F04B333B84
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 12:37:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231682AbhCJLf5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 06:35:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232078AbhCJLf3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 06:35:29 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDD81C0613D7
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 03:34:58 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id u14so22932645wri.3
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 03:34:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tsF7/5uGGNtKSeIbUwB9la5ui6d5Vch6n8mUko4oifU=;
        b=Auw9Zw9jKS8DjfOydaOYYfkT7wNR/YfmfzfeUyIkm/UcBnm2hYa1IXxyQhYOYg2mq9
         aExirm2SZm4YW9sW946Hw/i8NxZcBJfqaJ7cRxHsDh8dq93pU4WmUyXcsEGBHQ5QcMyD
         pNmUrGDmSZyIutHdOFTnSY6pk3LABI2CPc90hg/WC37li7Svg3UF1SV4XNN5Rk4sW05y
         yLG6FoE6YyMFpIX0XnsW2Ley/bTMewIGoN3z7YKM5dwwrfs0oEghdfqFHbDjVwOJgoJv
         M6qAKTv31+NjF5uc/EXoyW6sSaoRr90HcqeenIy49wpvwCbF3C8fDu79AQflqBFo+ULM
         1EsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tsF7/5uGGNtKSeIbUwB9la5ui6d5Vch6n8mUko4oifU=;
        b=pS/Pgg5etGK7wELEYHfbuouZ/+EL5dlPs5PfPMGa4yjj/f9z33NRxa6PFRp6voHTXo
         pXvxQHWRaMR2mupK32jNs2rQJ8QupVc2z3EBDIAtym77gbisDjNImPA383rIopABAXLX
         puOKVxzHePIbbECe0BGllDNI8bloaGSaOVDtX1Kpc6qcYJGBNvneziJI1HfYH9J4Jmlo
         WuIp8vrFxdQ3/s/2WBwOrYTu7iKQwe1eufgQzv5h/Jp7+BFf0AepNOGUIlQo+lXGeX8n
         VaMOAIIfvzCi42A8Krvg1Qm8izYVLBeFXrhyvCUmMmOtB2vGmL579RorbD07Acpwvw44
         +o7g==
X-Gm-Message-State: AOAM5300+xMUoMh06Uc8cyDHIvRJJ5wshvz0GYpYq54sZZTcaAgjoGzp
        EwpPirk3xpn8rxrqS1fjrpQZeAFDTC1vpQ==
X-Google-Smtp-Source: ABdhPJzDSLbvNNaCCJdfSfX+tqb9Si6KvtT7k6+YrVqpHphwhwAD61FfyBXh50NCW94KbIAkgjnq9w==
X-Received: by 2002:adf:ba87:: with SMTP id p7mr3140027wrg.298.1615376097306;
        Wed, 10 Mar 2021 03:34:57 -0800 (PST)
Received: from localhost.localdomain ([85.255.232.55])
        by smtp.gmail.com with ESMTPSA id s18sm25179078wrr.27.2021.03.10.03.34.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 03:34:56 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6/9] io_uring: get rid of intermediate IORING_OP_CLOSE stage
Date:   Wed, 10 Mar 2021 11:30:42 +0000
Message-Id: <89cbacd2635e9e91db0139cf2d3906621afa399a.1615375332.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1615375332.git.asml.silence@gmail.com>
References: <cover.1615375332.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 9eac1904d3364254d622bf2c771c4f85cd435fc2 upstream

We currently split the close into two, in case we have a ->flush op
that we can't safely handle from non-blocking context. This requires
us to flag the op as uncancelable if we do need to punt it async, and
that means special handling for just this op type.

Use __close_fd_get_file() and grab the files lock so we can get the file
and check if we need to go async in one atomic operation. That gets rid
of the need for splitting this into two steps, and hence the need for
IO_WQ_WORK_NO_CANCEL.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 64 ++++++++++++++++++++++++++++-----------------------
 1 file changed, 35 insertions(+), 29 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bc76929e0031..7d03689d0e47 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -411,7 +411,6 @@ struct io_poll_remove {
 
 struct io_close {
 	struct file			*file;
-	struct file			*put_file;
 	int				fd;
 };
 
@@ -908,8 +907,6 @@ static const struct io_op_def io_op_defs[] = {
 						IO_WQ_WORK_FS | IO_WQ_WORK_MM,
 	},
 	[IORING_OP_CLOSE] = {
-		.needs_file		= 1,
-		.needs_file_no_error	= 1,
 		.work_flags		= IO_WQ_WORK_FILES | IO_WQ_WORK_BLKCG,
 	},
 	[IORING_OP_FILES_UPDATE] = {
@@ -4473,13 +4470,6 @@ static int io_statx(struct io_kiocb *req, bool force_nonblock)
 
 static int io_close_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	/*
-	 * If we queue this for async, it must not be cancellable. That would
-	 * leave the 'file' in an undeterminate state, and here need to modify
-	 * io_wq_work.flags, so initialize io_wq_work firstly.
-	 */
-	io_req_init_async(req);
-
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
 	if (sqe->ioprio || sqe->off || sqe->addr || sqe->len ||
@@ -4489,43 +4479,59 @@ static int io_close_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return -EBADF;
 
 	req->close.fd = READ_ONCE(sqe->fd);
-	if ((req->file && req->file->f_op == &io_uring_fops))
-		return -EBADF;
-
-	req->close.put_file = NULL;
 	return 0;
 }
 
 static int io_close(struct io_kiocb *req, bool force_nonblock,
 		    struct io_comp_state *cs)
 {
+	struct files_struct *files = current->files;
 	struct io_close *close = &req->close;
+	struct fdtable *fdt;
+	struct file *file;
 	int ret;
 
-	/* might be already done during nonblock submission */
-	if (!close->put_file) {
-		ret = close_fd_get_file(close->fd, &close->put_file);
-		if (ret < 0)
-			return (ret == -ENOENT) ? -EBADF : ret;
+	file = NULL;
+	ret = -EBADF;
+	spin_lock(&files->file_lock);
+	fdt = files_fdtable(files);
+	if (close->fd >= fdt->max_fds) {
+		spin_unlock(&files->file_lock);
+		goto err;
+	}
+	file = fdt->fd[close->fd];
+	if (!file) {
+		spin_unlock(&files->file_lock);
+		goto err;
+	}
+
+	if (file->f_op == &io_uring_fops) {
+		spin_unlock(&files->file_lock);
+		file = NULL;
+		goto err;
 	}
 
 	/* if the file has a flush method, be safe and punt to async */
-	if (close->put_file->f_op->flush && force_nonblock) {
-		/* not safe to cancel at this point */
-		req->work.flags |= IO_WQ_WORK_NO_CANCEL;
-		/* was never set, but play safe */
-		req->flags &= ~REQ_F_NOWAIT;
-		/* avoid grabbing files - we don't need the files */
-		req->flags |= REQ_F_NO_FILE_TABLE;
+	if (file->f_op->flush && force_nonblock) {
+		spin_unlock(&files->file_lock);
 		return -EAGAIN;
 	}
 
+	ret = __close_fd_get_file(close->fd, &file);
+	spin_unlock(&files->file_lock);
+	if (ret < 0) {
+		if (ret == -ENOENT)
+			ret = -EBADF;
+		goto err;
+	}
+
 	/* No ->flush() or already async, safely close from here */
-	ret = filp_close(close->put_file, req->work.identity->files);
+	ret = filp_close(file, current->files);
+err:
 	if (ret < 0)
 		req_set_fail_links(req);
-	fput(close->put_file);
-	close->put_file = NULL;
+	if (file)
+		fput(file);
 	__io_req_complete(req, ret, 0, cs);
 	return 0;
 }
-- 
2.24.0

