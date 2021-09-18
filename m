Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6FFD41066E
	for <lists+stable@lfdr.de>; Sat, 18 Sep 2021 14:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233508AbhIRMfl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Sep 2021 08:35:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:55132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233314AbhIRMfk (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 Sep 2021 08:35:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C0186127A;
        Sat, 18 Sep 2021 12:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631968454;
        bh=KP1OXcj0UsRDjCWwGohhIQR6Q833qCddDFzCU/Glq/U=;
        h=Subject:To:Cc:From:Date:From;
        b=1YAwsS1NEph2n8qPr9cSYm/CuogMEwiNNv+BAM0NoQyXGMjhunxwHVhjhkON+jdMe
         4I1Fjizp8yNR4xe2WMYjMejD7hhzkzg7Ax3W0YaXVCpXOmZpiPN9ttQJktTXVpAzxw
         oM35p40yiuOO68b+rFdpPqEMcSbFV0sU128nfSpU=
Subject: FAILED: patch "[PATCH] io_uring: allow retry for O_NONBLOCK if async is supported" failed to apply to 5.14-stable tree
To:     axboe@kernel.dk, dmm@fb.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 18 Sep 2021 14:34:11 +0200
Message-ID: <1631968451106199@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5d329e1286b0a040264e239b80257c937f6e685f Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Tue, 14 Sep 2021 11:08:37 -0600
Subject: [PATCH] io_uring: allow retry for O_NONBLOCK if async is supported

A common complaint is that using O_NONBLOCK files with io_uring can be a
bit of a pain. Be a bit nicer and allow normal retry IFF the file does
support async behavior. This makes it possible to use io_uring more
reliably with O_NONBLOCK files, for use cases where it either isn't
possible or feasible to modify the file flags.

Cc: stable@vger.kernel.org
Reported-and-tested-by: Dan Melnic <dmm@fb.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ae489ab275dd..3077f85a2638 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2843,7 +2843,8 @@ static bool io_file_supports_nowait(struct io_kiocb *req, int rw)
 	return __io_file_supports_nowait(req->file, rw);
 }
 
-static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
+		      int rw)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct kiocb *kiocb = &req->rw.kiocb;
@@ -2865,8 +2866,13 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (unlikely(ret))
 		return ret;
 
-	/* don't allow async punt for O_NONBLOCK or RWF_NOWAIT */
-	if ((kiocb->ki_flags & IOCB_NOWAIT) || (file->f_flags & O_NONBLOCK))
+	/*
+	 * If the file is marked O_NONBLOCK, still allow retry for it if it
+	 * supports async. Otherwise it's impossible to use O_NONBLOCK files
+	 * reliably. If not, or it IOCB_NOWAIT is set, don't retry.
+	 */
+	if ((kiocb->ki_flags & IOCB_NOWAIT) ||
+	    ((file->f_flags & O_NONBLOCK) && !io_file_supports_nowait(req, rw)))
 		req->flags |= REQ_F_NOWAIT;
 
 	ioprio = READ_ONCE(sqe->ioprio);
@@ -3349,7 +3355,7 @@ static int io_read_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	if (unlikely(!(req->file->f_mode & FMODE_READ)))
 		return -EBADF;
-	return io_prep_rw(req, sqe);
+	return io_prep_rw(req, sqe, READ);
 }
 
 /*
@@ -3542,7 +3548,7 @@ static int io_write_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	if (unlikely(!(req->file->f_mode & FMODE_WRITE)))
 		return -EBADF;
-	return io_prep_rw(req, sqe);
+	return io_prep_rw(req, sqe, WRITE);
 }
 
 static int io_write(struct io_kiocb *req, unsigned int issue_flags)

