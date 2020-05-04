Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3542A1C3642
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 11:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728444AbgEDJ4E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 05:56:04 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:52631 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726666AbgEDJ4E (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 May 2020 05:56:04 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 47198613;
        Mon,  4 May 2020 05:56:03 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 04 May 2020 05:56:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=hazg3t
        uGPVyg0D/Bx6J0v8XEwsNOUuNBNWzEx6nQNwA=; b=XTNjxgmB39UWs33ks8kmsy
        wzntAcOh58nPk/sdFUXrkdyptTxAJKSIEKnHbsIBw9OFXdZ3MgLuahaTOTAWolrd
        u+T9y1SOCP9PvYHSmHysmexYgpWonOg5DFK061+MxNNvYP9BvStNFIl8XXV08Y8N
        0ECfUfFHEIez5OjY9v14cV7Ec0BJuRe8LSu6md3pXJ3bH/1bn3A7Hb7rNGRfrwev
        S6nm8gBWT3/Hyd5aqN/fvGqUmRiwybXoseCB1HYWvo0V6bEQJ59ahygZCsTp/XIo
        J6jRXCWFx+WFHsO4E3Wo32U0DPNm+oo7cN3Zj1QjGGQ14cUEFjj8ArJqEV9mnuAw
        ==
X-ME-Sender: <xms:suavXnFIoOYdmsi3SaY_Yc5akZsnjOdY2dnLri2sQLx0IzVwh_RSlA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrjeeggddvtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgv
    rhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:suavXkSf4fjVRahBTMDzOnfWCua1GwJR0HCVKZx8512b6C_kYr9OYQ>
    <xmx:suavXksG2YcFgvhLxyy-rbaiMwmXrKe89kehjoFjmwPcQSAIPaxcAA>
    <xmx:suavXqBk-wZYkAgD63l6T0dfJOyIuhtqlR8aj9aovfy4zM-Teq7dzQ>
    <xmx:suavXnj9q11HqARU1KcfDocRi7bqRct1j7jTfxxXPgjH7M1nyUGaMxac7Yo>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 311413280059;
        Mon,  4 May 2020 05:56:02 -0400 (EDT)
Subject: FAILED: patch "[PATCH] io_uring: statx must grab the file table for valid fd" failed to apply to 5.6-stable tree
To:     axboe@kernel.dk, bugs@claycon.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 04 May 2020 11:56:01 +0200
Message-ID: <1588586161159248@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.6-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5b0bbee4732cbd58aa98213d4c11a366356bba3d Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Mon, 27 Apr 2020 10:41:22 -0600
Subject: [PATCH] io_uring: statx must grab the file table for valid fd

Clay reports that OP_STATX fails for a test case with a valid fd
and empty path:

 -- Test 0: statx:fd 3: SUCCEED, file mode 100755
 -- Test 1: statx:path ./uring_statx: SUCCEED, file mode 100755
 -- Test 2: io_uring_statx:fd 3: FAIL, errno 9: Bad file descriptor
 -- Test 3: io_uring_statx:path ./uring_statx: SUCCEED, file mode 100755

This is due to statx not grabbing the process file table, hence we can't
lookup the fd in async context. If the fd is valid, ensure that we grab
the file table so we can grab the file from async context.

Cc: stable@vger.kernel.org # v5.6
Reported-by: Clay Harris <bugs@claycon.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c687f57fb651..084dfade5cda 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -524,6 +524,7 @@ enum {
 	REQ_F_OVERFLOW_BIT,
 	REQ_F_POLLED_BIT,
 	REQ_F_BUFFER_SELECTED_BIT,
+	REQ_F_NO_FILE_TABLE_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -577,6 +578,8 @@ enum {
 	REQ_F_POLLED		= BIT(REQ_F_POLLED_BIT),
 	/* buffer already selected */
 	REQ_F_BUFFER_SELECTED	= BIT(REQ_F_BUFFER_SELECTED_BIT),
+	/* doesn't need file table for this request */
+	REQ_F_NO_FILE_TABLE	= BIT(REQ_F_NO_FILE_TABLE_BIT),
 };
 
 struct async_poll {
@@ -799,6 +802,7 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_file		= 1,
 		.fd_non_neg		= 1,
 		.needs_fs		= 1,
+		.file_table		= 1,
 	},
 	[IORING_OP_READ] = {
 		.needs_mm		= 1,
@@ -3355,8 +3359,12 @@ static int io_statx(struct io_kiocb *req, bool force_nonblock)
 	struct kstat stat;
 	int ret;
 
-	if (force_nonblock)
+	if (force_nonblock) {
+		/* only need file table for an actual valid fd */
+		if (ctx->dfd == -1 || ctx->dfd == AT_FDCWD)
+			req->flags |= REQ_F_NO_FILE_TABLE;
 		return -EAGAIN;
+	}
 
 	if (vfs_stat_set_lookup_flags(&lookup_flags, ctx->how.flags))
 		return -EINVAL;
@@ -5429,7 +5437,7 @@ static int io_grab_files(struct io_kiocb *req)
 	int ret = -EBADF;
 	struct io_ring_ctx *ctx = req->ctx;
 
-	if (req->work.files)
+	if (req->work.files || (req->flags & REQ_F_NO_FILE_TABLE))
 		return 0;
 	if (!ctx->ring_file)
 		return -EBADF;

