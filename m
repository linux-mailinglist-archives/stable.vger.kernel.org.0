Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75764E647B
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 18:23:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727674AbfJ0RXF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 13:23:05 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:51141 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727667AbfJ0RXF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Oct 2019 13:23:05 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 6080422171;
        Sun, 27 Oct 2019 13:23:04 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 27 Oct 2019 13:23:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=i+RTkq
        VChvhFAsFjS9dmhqaPOv5lHJ8DBF/bfwyBd+s=; b=XJvUkWeYKBnwPQ8N4vBPso
        0+hCDywMZC9/4/xYJZ1CkYZeiRZhMSAFS2ZlvLBtJQSDspCUHEGBn4Hf5czHncu7
        X/mdrEPcWC0Rb43pU8bUxiJq6BQTFMl+CVRx718cVwjoYnFVegXv0ldPsyE94nPI
        z+F0tA0x3O5hPVC4O8MlDHKzKjm2CHjRIqsx3I1glhaMtGl5ymxjCr3hcxWInDwL
        pfUWNiYNCVx7MzW87TNlz4zoZ5lxeIMUdMvU1oJ628DWl1YkknIZMV2mL+1IXHcc
        Uv4I6J2WbGL0xDX7rXVc8zVXTZPTXAtlBMzy5OPqwARINQPrGPQFJ6kGpM610Ylw
        ==
X-ME-Sender: <xms:eNK1XWwckqX2LjcHM9iB6I2UAwLzAQaDGWh2y_0uhImI_pGSKiOxFg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrleejgddutdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeejjedrudehkedrhedtrddutddtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpeei
X-ME-Proxy: <xmx:eNK1Xd3IYGY5ITlPc2ogl9A85-PPzvwE_wr9OhmED4rZr37maW2Bag>
    <xmx:eNK1XYWwYisB7iqtAwNsKLe6XfLM2oqqWCDsRJBJ_Rwr4GQuWD9H-g>
    <xmx:eNK1XReaiTYK_J0U4TpV9e_9cqsBfISjBBeorC8cNUxU2RUluGxP_g>
    <xmx:eNK1XRz0tO-vpyCELJAzDWfapQgc7_2Rnq1DiNtRzIDsc6Mx_kp1cg>
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        by mail.messagingengine.com (Postfix) with ESMTPA id C3CE2D6005F;
        Sun, 27 Oct 2019 13:23:03 -0400 (EDT)
Subject: FAILED: patch "[PATCH] io_uring: fix up O_NONBLOCK handling for sockets" failed to apply to 5.3-stable tree
To:     axboe@kernel.dk, zeba.hrvoje@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 27 Oct 2019 16:53:55 +0100
Message-ID: <1572191635100175@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.3-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 491381ce07ca57f68c49c79a8a43da5b60749e32 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Thu, 17 Oct 2019 09:20:46 -0600
Subject: [PATCH] io_uring: fix up O_NONBLOCK handling for sockets

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

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d2cb277da2f4..b7d4085d6ffd 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -322,6 +322,8 @@ struct io_kiocb {
 #define REQ_F_FAIL_LINK		256	/* fail rest of links */
 #define REQ_F_SHADOW_DRAIN	512	/* link-drain shadow req */
 #define REQ_F_TIMEOUT		1024	/* timeout request */
+#define REQ_F_ISREG		2048	/* regular file */
+#define REQ_F_MUST_PUNT		4096	/* must be punted even for NONBLOCK */
 	u64			user_data;
 	u32			result;
 	u32			sequence;
@@ -914,26 +916,26 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, unsigned *nr_events,
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
@@ -945,7 +947,8 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
 {
 	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw);
 
-	kiocb_end_write(kiocb);
+	if (kiocb->ki_flags & IOCB_WRITE)
+		kiocb_end_write(req);
 
 	if ((req->flags & REQ_F_LINK) && res != req->result)
 		req->flags |= REQ_F_FAIL_LINK;
@@ -1059,8 +1062,17 @@ static int io_prep_rw(struct io_kiocb *req, const struct sqe_submit *s,
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
@@ -1081,7 +1093,8 @@ static int io_prep_rw(struct io_kiocb *req, const struct sqe_submit *s,
 		return ret;
 
 	/* don't allow async punt if RWF_NOWAIT was requested */
-	if (kiocb->ki_flags & IOCB_NOWAIT)
+	if ((kiocb->ki_flags & IOCB_NOWAIT) ||
+	    (req->file->f_flags & O_NONBLOCK))
 		req->flags |= REQ_F_NOWAIT;
 
 	if (force_nonblock)
@@ -1382,7 +1395,9 @@ static int io_read(struct io_kiocb *req, const struct sqe_submit *s,
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
@@ -1447,7 +1462,7 @@ static int io_write(struct io_kiocb *req, const struct sqe_submit *s,
 		 * released so that it doesn't complain about the held lock when
 		 * we return to userspace.
 		 */
-		if (S_ISREG(file_inode(file)->i_mode)) {
+		if (req->flags & REQ_F_ISREG) {
 			__sb_start_write(file_inode(file)->i_sb,
 						SB_FREEZE_WRITE, true);
 			__sb_writers_release(file_inode(file)->i_sb,
@@ -2282,7 +2297,13 @@ static int __io_queue_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	int ret;
 
 	ret = __io_submit_sqe(ctx, req, s, force_nonblock);
-	if (ret == -EAGAIN && !(req->flags & REQ_F_NOWAIT)) {
+
+	/*
+	 * We async punt it if the file wasn't marked NOWAIT, or if the file
+	 * doesn't support non-blocking read/write attempts
+	 */
+	if (ret == -EAGAIN && (!(req->flags & REQ_F_NOWAIT) ||
+	    (req->flags & REQ_F_MUST_PUNT))) {
 		struct io_uring_sqe *sqe_copy;
 
 		sqe_copy = kmemdup(s->sqe, sizeof(*sqe_copy), GFP_KERNEL);

