Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 191DB412524
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353542AbhITSll (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:41:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:52158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353092AbhITShD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:37:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D065563322;
        Mon, 20 Sep 2021 17:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158983;
        bh=MwLgoaxQ710nxayWGUIn6POkndliC9rSgcVdZwxI3l4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UZGmshzVJUS7XZVUieHV1pj8vq87Bg5bxJENJ8uPBjbI8T7k6gGgXs+LwsFeNJ7tx
         T8NfoiHN/gB0VzuqxEneqJL+koPdKYANWNFKsySVeXUSZiWZSuNlHWEr4tgapQgY+g
         zouwx2GM2k4Q/Kly3ITZOTdixaMvX9Y2kQqwsdj0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Dan Melnic <dmm@fb.com>
Subject: [PATCH 5.14 022/168] io_uring: allow retry for O_NONBLOCK if async is supported
Date:   Mon, 20 Sep 2021 18:42:40 +0200
Message-Id: <20210920163922.377541288@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 5d329e1286b0a040264e239b80257c937f6e685f upstream.

A common complaint is that using O_NONBLOCK files with io_uring can be a
bit of a pain. Be a bit nicer and allow normal retry IFF the file does
support async behavior. This makes it possible to use io_uring more
reliably with O_NONBLOCK files, for use cases where it either isn't
possible or feasible to modify the file flags.

Cc: stable@vger.kernel.org
Reported-and-tested-by: Dan Melnic <dmm@fb.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2683,7 +2683,8 @@ static bool io_file_supports_async(struc
 	return __io_file_supports_async(req->file, rw);
 }
 
-static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
+		      int rw)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct kiocb *kiocb = &req->rw.kiocb;
@@ -2705,8 +2706,13 @@ static int io_prep_rw(struct io_kiocb *r
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
+	    ((file->f_flags & O_NONBLOCK) && !io_file_supports_async(req, rw)))
 		req->flags |= REQ_F_NOWAIT;
 
 	ioprio = READ_ONCE(sqe->ioprio);
@@ -3193,7 +3199,7 @@ static int io_read_prep(struct io_kiocb
 {
 	if (unlikely(!(req->file->f_mode & FMODE_READ)))
 		return -EBADF;
-	return io_prep_rw(req, sqe);
+	return io_prep_rw(req, sqe, READ);
 }
 
 /*
@@ -3382,7 +3388,7 @@ static int io_write_prep(struct io_kiocb
 {
 	if (unlikely(!(req->file->f_mode & FMODE_WRITE)))
 		return -EBADF;
-	return io_prep_rw(req, sqe);
+	return io_prep_rw(req, sqe, WRITE);
 }
 
 static int io_write(struct io_kiocb *req, unsigned int issue_flags)


