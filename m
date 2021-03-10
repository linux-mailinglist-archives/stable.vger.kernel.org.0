Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12620333DA2
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:25:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232856AbhCJNYh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:24:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:45374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232718AbhCJNYH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:24:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 45D0964FDA;
        Wed, 10 Mar 2021 13:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382647;
        bh=HOnZyrl+e1tKtDOdwbOp+TkVF0JaTyTbnFXkUxaz5pw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eWfS5VQQQwE5dZ+MLRVVtFpwzt5eJXOo4bgjDUwZKUdk4bTbXj6zZW/DCCO6m94ZH
         0NAo3p59Y0Vf5YBZl1rQcgFJgMKyGhnkQOAOG4OjoAHJhhvtCMjrKWZjeR5VJj2VKb
         bQ53vN1/Ph+HUiYNOzbN9NwYSj5Ok+hE+OBgeCa8=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 5.11 07/36] io_uring: get rid of intermediate IORING_OP_CLOSE stage
Date:   Wed, 10 Mar 2021 14:23:20 +0100
Message-Id: <20210310132320.752862116@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132320.510840709@linuxfoundation.org>
References: <20210310132320.510840709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   64 +++++++++++++++++++++++++++++++---------------------------
 1 file changed, 35 insertions(+), 29 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -411,7 +411,6 @@ struct io_poll_remove {
 
 struct io_close {
 	struct file			*file;
-	struct file			*put_file;
 	int				fd;
 };
 
@@ -908,8 +907,6 @@ static const struct io_op_def io_op_defs
 						IO_WQ_WORK_FS | IO_WQ_WORK_MM,
 	},
 	[IORING_OP_CLOSE] = {
-		.needs_file		= 1,
-		.needs_file_no_error	= 1,
 		.work_flags		= IO_WQ_WORK_FILES | IO_WQ_WORK_BLKCG,
 	},
 	[IORING_OP_FILES_UPDATE] = {
@@ -4473,13 +4470,6 @@ static int io_statx(struct io_kiocb *req
 
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
@@ -4489,43 +4479,59 @@ static int io_close_prep(struct io_kiocb
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


