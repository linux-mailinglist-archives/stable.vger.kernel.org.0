Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9C472409E6
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727896AbgHJP0v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:26:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:60866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728672AbgHJP0u (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:26:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F08622D06;
        Mon, 10 Aug 2020 15:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597073209;
        bh=De/FtxHmDt+AkV5D0IIy89KGT8BuVq0ScKgRjr+EUOA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JRs+3sBnWSsQNQ/DiIJzm65a3xBss8syQqRdEw564evxR+xAU4FXkWGJEmi+yLYoB
         D4Z4l8LYDOO8xYAfynVUtHp7LFnsNiCAzGvOvYSTe9vn8qCwC6BbDgRe8lxLsmvv36
         gN+0I32wU12yh24WX/R0Er3WcU0oulgENb+aNdvA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liu Yong <pkfxxxing@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.4 06/67] io_uring: prevent re-read of sqe->opcode
Date:   Mon, 10 Aug 2020 17:20:53 +0200
Message-Id: <20200810151809.747275663@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810151809.438685785@linuxfoundation.org>
References: <20200810151809.438685785@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

Liu reports that he can trigger a NULL pointer dereference with
IORING_OP_SENDMSG, by changing the sqe->opcode after we've validated
that the previous opcode didn't need a file and didn't assign one.

Ensure we validate and read the opcode only once.

Reported-by: Liu Yong <pkfxxxing@gmail.com>
Tested-by: Liu Yong <pkfxxxing@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   59 +++++++++++++++++++++++-----------------------------------
 1 file changed, 24 insertions(+), 35 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -279,6 +279,7 @@ struct sqe_submit {
 	bool				has_user;
 	bool				needs_lock;
 	bool				needs_fixed_file;
+	u8				opcode;
 };
 
 /*
@@ -505,7 +506,7 @@ static inline void io_queue_async_work(s
 	int rw = 0;
 
 	if (req->submit.sqe) {
-		switch (req->submit.sqe->opcode) {
+		switch (req->submit.opcode) {
 		case IORING_OP_WRITEV:
 		case IORING_OP_WRITE_FIXED:
 			rw = !(req->rw.ki_flags & IOCB_DIRECT);
@@ -1254,23 +1255,15 @@ static int io_import_fixed(struct io_rin
 }
 
 static ssize_t io_import_iovec(struct io_ring_ctx *ctx, int rw,
-			       const struct sqe_submit *s, struct iovec **iovec,
+			       struct io_kiocb *req, struct iovec **iovec,
 			       struct iov_iter *iter)
 {
-	const struct io_uring_sqe *sqe = s->sqe;
+	const struct io_uring_sqe *sqe = req->submit.sqe;
 	void __user *buf = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	size_t sqe_len = READ_ONCE(sqe->len);
 	u8 opcode;
 
-	/*
-	 * We're reading ->opcode for the second time, but the first read
-	 * doesn't care whether it's _FIXED or not, so it doesn't matter
-	 * whether ->opcode changes concurrently. The first read does care
-	 * about whether it is a READ or a WRITE, so we don't trust this read
-	 * for that purpose and instead let the caller pass in the read/write
-	 * flag.
-	 */
-	opcode = READ_ONCE(sqe->opcode);
+	opcode = req->submit.opcode;
 	if (opcode == IORING_OP_READ_FIXED ||
 	    opcode == IORING_OP_WRITE_FIXED) {
 		ssize_t ret = io_import_fixed(ctx, rw, sqe, iter);
@@ -1278,7 +1271,7 @@ static ssize_t io_import_iovec(struct io
 		return ret;
 	}
 
-	if (!s->has_user)
+	if (!req->submit.has_user)
 		return -EFAULT;
 
 #ifdef CONFIG_COMPAT
@@ -1425,7 +1418,7 @@ static int io_read(struct io_kiocb *req,
 	if (unlikely(!(file->f_mode & FMODE_READ)))
 		return -EBADF;
 
-	ret = io_import_iovec(req->ctx, READ, s, &iovec, &iter);
+	ret = io_import_iovec(req->ctx, READ, req, &iovec, &iter);
 	if (ret < 0)
 		return ret;
 
@@ -1490,7 +1483,7 @@ static int io_write(struct io_kiocb *req
 	if (unlikely(!(file->f_mode & FMODE_WRITE)))
 		return -EBADF;
 
-	ret = io_import_iovec(req->ctx, WRITE, s, &iovec, &iter);
+	ret = io_import_iovec(req->ctx, WRITE, req, &iovec, &iter);
 	if (ret < 0)
 		return ret;
 
@@ -2109,15 +2102,14 @@ static int io_req_defer(struct io_ring_c
 static int __io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 			   const struct sqe_submit *s, bool force_nonblock)
 {
-	int ret, opcode;
+	int ret;
 
 	req->user_data = READ_ONCE(s->sqe->user_data);
 
 	if (unlikely(s->index >= ctx->sq_entries))
 		return -EINVAL;
 
-	opcode = READ_ONCE(s->sqe->opcode);
-	switch (opcode) {
+	switch (req->submit.opcode) {
 	case IORING_OP_NOP:
 		ret = io_nop(req, req->user_data);
 		break;
@@ -2181,10 +2173,10 @@ static int __io_submit_sqe(struct io_rin
 	return 0;
 }
 
-static struct async_list *io_async_list_from_sqe(struct io_ring_ctx *ctx,
-						 const struct io_uring_sqe *sqe)
+static struct async_list *io_async_list_from_req(struct io_ring_ctx *ctx,
+						 struct io_kiocb *req)
 {
-	switch (sqe->opcode) {
+	switch (req->submit.opcode) {
 	case IORING_OP_READV:
 	case IORING_OP_READ_FIXED:
 		return &ctx->pending_async[READ];
@@ -2196,12 +2188,10 @@ static struct async_list *io_async_list_
 	}
 }
 
-static inline bool io_sqe_needs_user(const struct io_uring_sqe *sqe)
+static inline bool io_req_needs_user(struct io_kiocb *req)
 {
-	u8 opcode = READ_ONCE(sqe->opcode);
-
-	return !(opcode == IORING_OP_READ_FIXED ||
-		 opcode == IORING_OP_WRITE_FIXED);
+	return !(req->submit.opcode == IORING_OP_READ_FIXED ||
+		req->submit.opcode == IORING_OP_WRITE_FIXED);
 }
 
 static void io_sq_wq_submit_work(struct work_struct *work)
@@ -2217,7 +2207,7 @@ static void io_sq_wq_submit_work(struct
 	int ret;
 
 	old_cred = override_creds(ctx->creds);
-	async_list = io_async_list_from_sqe(ctx, req->submit.sqe);
+	async_list = io_async_list_from_req(ctx, req);
 
 	allow_kernel_signal(SIGINT);
 restart:
@@ -2239,7 +2229,7 @@ restart:
 		}
 
 		ret = 0;
-		if (io_sqe_needs_user(sqe) && !cur_mm) {
+		if (io_req_needs_user(req) && !cur_mm) {
 			if (!mmget_not_zero(ctx->sqo_mm)) {
 				ret = -EFAULT;
 			} else {
@@ -2387,11 +2377,9 @@ static bool io_add_to_prev_work(struct a
 	return ret;
 }
 
-static bool io_op_needs_file(const struct io_uring_sqe *sqe)
+static bool io_op_needs_file(struct io_kiocb *req)
 {
-	int op = READ_ONCE(sqe->opcode);
-
-	switch (op) {
+	switch (req->submit.opcode) {
 	case IORING_OP_NOP:
 	case IORING_OP_POLL_REMOVE:
 	case IORING_OP_TIMEOUT:
@@ -2419,7 +2407,7 @@ static int io_req_set_file(struct io_rin
 	 */
 	req->sequence = s->sequence;
 
-	if (!io_op_needs_file(s->sqe))
+	if (!io_op_needs_file(req))
 		return 0;
 
 	if (flags & IOSQE_FIXED_FILE) {
@@ -2460,7 +2448,7 @@ static int __io_queue_sqe(struct io_ring
 
 			s->sqe = sqe_copy;
 			memcpy(&req->submit, s, sizeof(*s));
-			list = io_async_list_from_sqe(ctx, s->sqe);
+			list = io_async_list_from_req(ctx, req);
 			if (!io_add_to_prev_work(list, req)) {
 				if (list)
 					atomic_inc(&list->cnt);
@@ -2582,7 +2570,7 @@ err:
 	req->user_data = s->sqe->user_data;
 
 #if defined(CONFIG_NET)
-	switch (READ_ONCE(s->sqe->opcode)) {
+	switch (req->submit.opcode) {
 	case IORING_OP_SENDMSG:
 	case IORING_OP_RECVMSG:
 		spin_lock(&current->fs->lock);
@@ -2697,6 +2685,7 @@ static bool io_get_sqring(struct io_ring
 	if (head < ctx->sq_entries) {
 		s->index = head;
 		s->sqe = &ctx->sq_sqes[head];
+		s->opcode = READ_ONCE(s->sqe->opcode);
 		s->sequence = ctx->cached_sq_head;
 		ctx->cached_sq_head++;
 		return true;


