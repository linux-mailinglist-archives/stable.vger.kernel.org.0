Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AAADEEEA6
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:16:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388056AbfKDWED (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:04:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:34586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389160AbfKDWED (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:04:03 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41E212084D;
        Mon,  4 Nov 2019 22:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905041;
        bh=F7lxjdgHNmqKQvRAMhqCeeOLuyDz2AM61iEAzcXRGc0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MryXNlEMSOZuBDj4xaTH+d8BNetup0GLtnIrjNsP1XvOTCM8KxrQ/L+3+mgiL2a8D
         /qvD+qCRpyrETG/4v817kdiYgwmHN6UA840cS6DlCTS2YD8OEvs171QGUnyQhIIM8u
         Dp/lOwVeikziHOWuxvC0WEu2B0Ehv9Vlaz3aHTWU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hrvoje Zeba <zeba.hrvoje@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 001/163] io_uring: fix up O_NONBLOCK handling for sockets
Date:   Mon,  4 Nov 2019 22:43:11 +0100
Message-Id: <20191104212140.177676730@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212140.046021995@linuxfoundation.org>
References: <20191104212140.046021995@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 491381ce07ca57f68c49c79a8a43da5b60749e32 ]

We've got two issues with the non-regular file handling for non-blocking
IO:

1) We don't want to re-do a short read in full for a non-regular file,
   as we can't just read the data again.
2) For non-regular files that don't support non-blocking IO attempts,
   we need to punt to async context even if the file is opened as
   non-blocking. Otherwise the caller always gets -EAGAIN.

Add two new request flags to handle these cases. One is just a cache
of the inode S_ISREG() status, the other tells io_uring that we always
need to punt this request to async context, even if REQ_F_NOWAIT is set.

Cc: stable@vger.kernel.org
Reported-by: Hrvoje Zeba <zeba.hrvoje@gmail.com>
Tested-by: Hrvoje Zeba <zeba.hrvoje@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 57 +++++++++++++++++++++++++++++++++++----------------
 1 file changed, 39 insertions(+), 18 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ed223c33dd898..59925b6583ba0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -338,6 +338,8 @@ struct io_kiocb {
 #define REQ_F_LINK		64	/* linked sqes */
 #define REQ_F_LINK_DONE		128	/* linked sqes done */
 #define REQ_F_FAIL_LINK		256	/* fail rest of links */
+#define REQ_F_ISREG		2048	/* regular file */
+#define REQ_F_MUST_PUNT		4096	/* must be punted even for NONBLOCK */
 	u64			user_data;
 	u32			result;
 	u32			sequence;
@@ -885,26 +887,26 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, unsigned *nr_events,
 	return ret;
 }
 
-static void kiocb_end_write(struct kiocb *kiocb)
+static void kiocb_end_write(struct io_kiocb *req)
 {
-	if (kiocb->ki_flags & IOCB_WRITE) {
-		struct inode *inode = file_inode(kiocb->ki_filp);
+	/*
+	 * Tell lockdep we inherited freeze protection from submission
+	 * thread.
+	 */
+	if (req->flags & REQ_F_ISREG) {
+		struct inode *inode = file_inode(req->file);
 
-		/*
-		 * Tell lockdep we inherited freeze protection from submission
-		 * thread.
-		 */
-		if (S_ISREG(inode->i_mode))
-			__sb_writers_acquired(inode->i_sb, SB_FREEZE_WRITE);
-		file_end_write(kiocb->ki_filp);
+		__sb_writers_acquired(inode->i_sb, SB_FREEZE_WRITE);
 	}
+	file_end_write(req->file);
 }
 
 static void io_complete_rw(struct kiocb *kiocb, long res, long res2)
 {
 	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw);
 
-	kiocb_end_write(kiocb);
+	if (kiocb->ki_flags & IOCB_WRITE)
+		kiocb_end_write(req);
 
 	if ((req->flags & REQ_F_LINK) && res != req->result)
 		req->flags |= REQ_F_FAIL_LINK;
@@ -916,7 +918,8 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
 {
 	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw);
 
-	kiocb_end_write(kiocb);
+	if (kiocb->ki_flags & IOCB_WRITE)
+		kiocb_end_write(req);
 
 	if ((req->flags & REQ_F_LINK) && res != req->result)
 		req->flags |= REQ_F_FAIL_LINK;
@@ -1030,8 +1033,17 @@ static int io_prep_rw(struct io_kiocb *req, const struct sqe_submit *s,
 	if (!req->file)
 		return -EBADF;
 
-	if (force_nonblock && !io_file_supports_async(req->file))
-		force_nonblock = false;
+	if (S_ISREG(file_inode(req->file)->i_mode))
+		req->flags |= REQ_F_ISREG;
+
+	/*
+	 * If the file doesn't support async, mark it as REQ_F_MUST_PUNT so
+	 * we know to async punt it even if it was opened O_NONBLOCK
+	 */
+	if (force_nonblock && !io_file_supports_async(req->file)) {
+		req->flags |= REQ_F_MUST_PUNT;
+		return -EAGAIN;
+	}
 
 	kiocb->ki_pos = READ_ONCE(sqe->off);
 	kiocb->ki_flags = iocb_flags(kiocb->ki_filp);
@@ -1052,7 +1064,8 @@ static int io_prep_rw(struct io_kiocb *req, const struct sqe_submit *s,
 		return ret;
 
 	/* don't allow async punt if RWF_NOWAIT was requested */
-	if (kiocb->ki_flags & IOCB_NOWAIT)
+	if ((kiocb->ki_flags & IOCB_NOWAIT) ||
+	    (req->file->f_flags & O_NONBLOCK))
 		req->flags |= REQ_F_NOWAIT;
 
 	if (force_nonblock)
@@ -1286,7 +1299,9 @@ static int io_read(struct io_kiocb *req, const struct sqe_submit *s,
 		 * need async punt anyway, so it's more efficient to do it
 		 * here.
 		 */
-		if (force_nonblock && ret2 > 0 && ret2 < read_size)
+		if (force_nonblock && !(req->flags & REQ_F_NOWAIT) &&
+		    (req->flags & REQ_F_ISREG) &&
+		    ret2 > 0 && ret2 < read_size)
 			ret2 = -EAGAIN;
 		/* Catch -EAGAIN return for forced non-blocking submission */
 		if (!force_nonblock || ret2 != -EAGAIN) {
@@ -1353,7 +1368,7 @@ static int io_write(struct io_kiocb *req, const struct sqe_submit *s,
 		 * released so that it doesn't complain about the held lock when
 		 * we return to userspace.
 		 */
-		if (S_ISREG(file_inode(file)->i_mode)) {
+		if (req->flags & REQ_F_ISREG) {
 			__sb_start_write(file_inode(file)->i_sb,
 						SB_FREEZE_WRITE, true);
 			__sb_writers_release(file_inode(file)->i_sb,
@@ -2096,7 +2111,13 @@ static int io_queue_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	}
 
 	ret = __io_submit_sqe(ctx, req, s, true);
-	if (ret == -EAGAIN && !(req->flags & REQ_F_NOWAIT)) {
+
+	/*
+	 * We async punt it if the file wasn't marked NOWAIT, or if the file
+	 * doesn't support non-blocking read/write attempts
+	 */
+	if (ret == -EAGAIN && (!(req->flags & REQ_F_NOWAIT) ||
+	    (req->flags & REQ_F_MUST_PUNT))) {
 		struct io_uring_sqe *sqe_copy;
 
 		sqe_copy = kmalloc(sizeof(*sqe_copy), GFP_KERNEL);
-- 
2.20.1



