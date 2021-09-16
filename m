Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2684A40DF12
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233147AbhIPQGd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:06:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:45402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240407AbhIPQGM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:06:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BAAD66124E;
        Thu, 16 Sep 2021 16:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808292;
        bh=ZPVTUMI1DeQv5If5e9GoVfi3Uu5gIAvAJL/7m5lpXz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d2unJC2A6i80EalMD0tzHIPuiOeqbX1QDnArCRY86mDnqaFSioiscsefac94y6JMO
         tWZGsh3vDoOf1ul0czhGlHmIHBMoCUwFwXAPiJpcSKxzi44Fwx5uZWHQGd1ZjVyfiq
         FSseEddM5MWNb5r+LBOhxXG6mMpod8308UDxxQdY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 004/306] io_uring: add ->splice_fd_in checks
Date:   Thu, 16 Sep 2021 17:55:49 +0200
Message-Id: <20210916155754.062207164@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit 26578cda3db983b17cabe4e577af26306beb9987 upstream.

->splice_fd_in is used only by splice/tee, but no other request checks
it for validity. Add the check for most of request types excluding
reads/writes/sends/recvs, we don't want overhead for them and can leave
them be as is until the field is actually used.

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/f44bc2acd6777d932de3d71a5692235b5b2b7397.1629451684.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   40 ++++++++++++++++++++++++----------------
 1 file changed, 24 insertions(+), 16 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3746,7 +3746,8 @@ static int io_prep_fsync(struct io_kiocb
 
 	if (unlikely(ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (unlikely(sqe->addr || sqe->ioprio || sqe->buf_index))
+	if (unlikely(sqe->addr || sqe->ioprio || sqe->buf_index ||
+		     sqe->splice_fd_in))
 		return -EINVAL;
 
 	req->sync.flags = READ_ONCE(sqe->fsync_flags);
@@ -3779,7 +3780,8 @@ static int io_fsync(struct io_kiocb *req
 static int io_fallocate_prep(struct io_kiocb *req,
 			     const struct io_uring_sqe *sqe)
 {
-	if (sqe->ioprio || sqe->buf_index || sqe->rw_flags)
+	if (sqe->ioprio || sqe->buf_index || sqe->rw_flags ||
+	    sqe->splice_fd_in)
 		return -EINVAL;
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
@@ -3810,7 +3812,7 @@ static int __io_openat_prep(struct io_ki
 	const char __user *fname;
 	int ret;
 
-	if (unlikely(sqe->ioprio || sqe->buf_index))
+	if (unlikely(sqe->ioprio || sqe->buf_index || sqe->splice_fd_in))
 		return -EINVAL;
 	if (unlikely(req->flags & REQ_F_FIXED_FILE))
 		return -EBADF;
@@ -3926,7 +3928,8 @@ static int io_remove_buffers_prep(struct
 	struct io_provide_buf *p = &req->pbuf;
 	u64 tmp;
 
-	if (sqe->ioprio || sqe->rw_flags || sqe->addr || sqe->len || sqe->off)
+	if (sqe->ioprio || sqe->rw_flags || sqe->addr || sqe->len || sqe->off ||
+	    sqe->splice_fd_in)
 		return -EINVAL;
 
 	tmp = READ_ONCE(sqe->fd);
@@ -4002,7 +4005,7 @@ static int io_provide_buffers_prep(struc
 	struct io_provide_buf *p = &req->pbuf;
 	u64 tmp;
 
-	if (sqe->ioprio || sqe->rw_flags)
+	if (sqe->ioprio || sqe->rw_flags || sqe->splice_fd_in)
 		return -EINVAL;
 
 	tmp = READ_ONCE(sqe->fd);
@@ -4095,7 +4098,7 @@ static int io_epoll_ctl_prep(struct io_k
 			     const struct io_uring_sqe *sqe)
 {
 #if defined(CONFIG_EPOLL)
-	if (sqe->ioprio || sqe->buf_index)
+	if (sqe->ioprio || sqe->buf_index || sqe->splice_fd_in)
 		return -EINVAL;
 	if (unlikely(req->ctx->flags & (IORING_SETUP_IOPOLL | IORING_SETUP_SQPOLL)))
 		return -EINVAL;
@@ -4141,7 +4144,7 @@ static int io_epoll_ctl(struct io_kiocb
 static int io_madvise_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 #if defined(CONFIG_ADVISE_SYSCALLS) && defined(CONFIG_MMU)
-	if (sqe->ioprio || sqe->buf_index || sqe->off)
+	if (sqe->ioprio || sqe->buf_index || sqe->off || sqe->splice_fd_in)
 		return -EINVAL;
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
@@ -4176,7 +4179,7 @@ static int io_madvise(struct io_kiocb *r
 
 static int io_fadvise_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	if (sqe->ioprio || sqe->buf_index || sqe->addr)
+	if (sqe->ioprio || sqe->buf_index || sqe->addr || sqe->splice_fd_in)
 		return -EINVAL;
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
@@ -4214,7 +4217,7 @@ static int io_statx_prep(struct io_kiocb
 {
 	if (unlikely(req->ctx->flags & (IORING_SETUP_IOPOLL | IORING_SETUP_SQPOLL)))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->buf_index)
+	if (sqe->ioprio || sqe->buf_index || sqe->splice_fd_in)
 		return -EINVAL;
 	if (req->flags & REQ_F_FIXED_FILE)
 		return -EBADF;
@@ -4261,7 +4264,7 @@ static int io_close_prep(struct io_kiocb
 	if (unlikely(req->ctx->flags & (IORING_SETUP_IOPOLL|IORING_SETUP_SQPOLL)))
 		return -EINVAL;
 	if (sqe->ioprio || sqe->off || sqe->addr || sqe->len ||
-	    sqe->rw_flags || sqe->buf_index)
+	    sqe->rw_flags || sqe->buf_index || sqe->splice_fd_in)
 		return -EINVAL;
 	if (req->flags & REQ_F_FIXED_FILE)
 		return -EBADF;
@@ -4317,7 +4320,8 @@ static int io_prep_sfr(struct io_kiocb *
 
 	if (unlikely(ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (unlikely(sqe->addr || sqe->ioprio || sqe->buf_index))
+	if (unlikely(sqe->addr || sqe->ioprio || sqe->buf_index ||
+		     sqe->splice_fd_in))
 		return -EINVAL;
 
 	req->sync.off = READ_ONCE(sqe->off);
@@ -4760,7 +4764,7 @@ static int io_accept_prep(struct io_kioc
 
 	if (unlikely(req->ctx->flags & (IORING_SETUP_IOPOLL|IORING_SETUP_SQPOLL)))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->len || sqe->buf_index)
+	if (sqe->ioprio || sqe->len || sqe->buf_index || sqe->splice_fd_in)
 		return -EINVAL;
 
 	accept->addr = u64_to_user_ptr(READ_ONCE(sqe->addr));
@@ -4801,7 +4805,8 @@ static int io_connect_prep(struct io_kio
 
 	if (unlikely(req->ctx->flags & (IORING_SETUP_IOPOLL|IORING_SETUP_SQPOLL)))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->len || sqe->buf_index || sqe->rw_flags)
+	if (sqe->ioprio || sqe->len || sqe->buf_index || sqe->rw_flags ||
+	    sqe->splice_fd_in)
 		return -EINVAL;
 
 	conn->addr = u64_to_user_ptr(READ_ONCE(sqe->addr));
@@ -5553,7 +5558,8 @@ static int io_timeout_remove_prep(struct
 		return -EINVAL;
 	if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->buf_index || sqe->len || sqe->timeout_flags)
+	if (sqe->ioprio || sqe->buf_index || sqe->len || sqe->timeout_flags |
+	    sqe->splice_fd_in)
 		return -EINVAL;
 
 	req->timeout_rem.addr = READ_ONCE(sqe->addr);
@@ -5590,7 +5596,8 @@ static int io_timeout_prep(struct io_kio
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->buf_index || sqe->len != 1)
+	if (sqe->ioprio || sqe->buf_index || sqe->len != 1 ||
+	    sqe->splice_fd_in)
 		return -EINVAL;
 	if (off && is_timeout_link)
 		return -EINVAL;
@@ -5734,7 +5741,8 @@ static int io_async_cancel_prep(struct i
 		return -EINVAL;
 	if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->off || sqe->len || sqe->cancel_flags)
+	if (sqe->ioprio || sqe->off || sqe->len || sqe->cancel_flags ||
+	    sqe->splice_fd_in)
 		return -EINVAL;
 
 	req->cancel.addr = READ_ONCE(sqe->addr);


