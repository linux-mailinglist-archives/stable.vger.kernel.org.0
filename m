Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9377016141A
	for <lists+stable@lfdr.de>; Mon, 17 Feb 2020 15:04:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbgBQOEw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Feb 2020 09:04:52 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:49637 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726401AbgBQOEw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Feb 2020 09:04:52 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 54C2E2207F;
        Mon, 17 Feb 2020 09:04:51 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 17 Feb 2020 09:04:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=1Sz7gN
        cyxlyypYGlwpeAJwS5LPGI3VrZJ8IOj7FHJJ8=; b=WtD353Hu0lztxSUN1VlHd+
        rUnTtyBlc7two2ZHkDyrFjh/1FfLS41NBZpn9Laed9cGx0N3N76boRTtxJVX9Xu8
        Wg7ltP0tV89e0Ua7oz0oMF9hm83EjAUU7JKSqWfpPiozJ/SpzhLqK+RBzDTEm7wT
        Fg0vZjTiL9chEf/kMCtSfFysogqi80FEUIuuv9yb+IMpJ9ZkVvySNQmo0kew2gsL
        kcFdKHg1/Ki/DP/zcMZZGuvll1ByyUWwbw512EUEwbzzZT6ClOR+r2OlduhtcXkr
        Nut8k9wLilYCPkefKit8TwHCsEa0PZ/hl7WLdBYd6PH3OtWS7u5GPKErOow/X/XQ
        ==
X-ME-Sender: <xms:gp1KXoRL7jxx5AX67P6_gpDB8WyXgGZJN-NqaXUCOMdsBWyyHGqfew>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrjeeigdehlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:gp1KXkFjRnvZXWzuF62PQcK3DSyFeZkQNXqRSYL7AQlrXRf2QPu4cQ>
    <xmx:gp1KXsGqtm5xq33XzDhXRCaGjFxtpLypXtVrjtGHZkoY38eq78boHQ>
    <xmx:gp1KXgXTbnnG8MEeS0i5zcDiGAExFpRYMeoxs6y5VpS4uI73NmO1tA>
    <xmx:g51KXgtHLaCYMxI_PWgVSeSuCIngDP15Z1iCeSQlX4dF_7fcPDhfqA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A34F7328005D;
        Mon, 17 Feb 2020 09:04:50 -0500 (EST)
Subject: FAILED: patch "[PATCH] io_uring: fix double prep iovec leak" failed to apply to 5.5-stable tree
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 Feb 2020 15:04:49 +0100
Message-ID: <158194828922495@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.5-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5f798beaf35d79355cbf18019c1993a84475a2c3 Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Sat, 8 Feb 2020 13:28:02 +0300
Subject: [PATCH] io_uring: fix double prep iovec leak

Requests may be prepared multiple times with ->io allocated (i.e. async
prepared). Preparation functions don't handle it and forget about
previously allocated resources. This may happen in case of:
- spurious defer_check
- non-head (i.e. async prepared) request executed in sync (via nxt).

Make the handlers check, whether they already allocated resources, which
is true IFF REQ_F_NEED_CLEANUP is set.

Cc: stable@vger.kernel.org # 5.5
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 759301bdb19b..097701782339 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2205,7 +2205,8 @@ static int io_read_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	if (unlikely(!(req->file->f_mode & FMODE_READ)))
 		return -EBADF;
 
-	if (!req->io)
+	/* either don't need iovec imported or already have it */
+	if (!req->io || req->flags & REQ_F_NEED_CLEANUP)
 		return 0;
 
 	io = req->io;
@@ -2293,7 +2294,8 @@ static int io_write_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	if (unlikely(!(req->file->f_mode & FMODE_WRITE)))
 		return -EBADF;
 
-	if (!req->io)
+	/* either don't need iovec imported or already have it */
+	if (!req->io || req->flags & REQ_F_NEED_CLEANUP)
 		return 0;
 
 	io = req->io;
@@ -2993,6 +2995,9 @@ static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	if (!io || req->opcode == IORING_OP_SEND)
 		return 0;
+	/* iovec is already imported */
+	if (req->flags & REQ_F_NEED_CLEANUP)
+		return 0;
 
 	io->msg.iov = io->msg.fast_iov;
 	ret = sendmsg_copy_msghdr(&io->msg.msg, sr->msg, sr->msg_flags,
@@ -3143,6 +3148,9 @@ static int io_recvmsg_prep(struct io_kiocb *req,
 
 	if (!io || req->opcode == IORING_OP_RECV)
 		return 0;
+	/* iovec is already imported */
+	if (req->flags & REQ_F_NEED_CLEANUP)
+		return 0;
 
 	io->msg.iov = io->msg.fast_iov;
 	ret = recvmsg_copy_msghdr(&io->msg.msg, sr->msg, sr->msg_flags,

