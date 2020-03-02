Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19073176227
	for <lists+stable@lfdr.de>; Mon,  2 Mar 2020 19:13:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbgCBSNR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Mar 2020 13:13:17 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:33643 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727433AbgCBSNQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Mar 2020 13:13:16 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 271F07E6;
        Mon,  2 Mar 2020 13:13:16 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 02 Mar 2020 13:13:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=IO//S2
        W5GC+4zHb9JjN7NI0lJuETqjOl0yb1/8xXn+8=; b=javPn+Xj5BRfnq3HMG4sNH
        FTp/U9yeIGw5/ZAXYx/RP8OCGnqAYlxB+H+x1eHfYWhGv2S1PwnnVmkTgRKcEEY4
        ZWiBYg0QvJOguZnh6d/R7Swjd+Eiiy4nSqTY7hjw5t5uCHVUfGNrFgEMtftXZC8y
        B38BXaBPATkA13iD3MCdUHAIhHKcz2LNaktp8avqpIrEJQWOcaSLCZMh4WU1VrAh
        88gns0qvQ21wwZU5GEgiG0GQhh8gpNv1vmQ2fwsIj21skTQurg0n7d2NYWMSfur6
        8dyhNTKZ1f2pT8hiZnCB1QabqLhhpNgj0z3wvaEDlbF1t4x7RcvCSo0vaNaUWSbQ
        ==
X-ME-Sender: <xms:u0xdXt5zwPiAyNWKLJNV67uoISCILpfeV2NzdftJGmD0A6p1zAuFDQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedruddtgedgudduudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepud
    enucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:u0xdXuraR755Y6946pcQv84OLsMN0c1p5LOY9xeU6q3zL2aBpHr-Gg>
    <xmx:u0xdXqB9zfVqYkGILY3qbpNYqG8-aZxFg9jN5LsbuxaP7SNTtXLBgg>
    <xmx:u0xdXo1qyoBZAGcb1PQFh4fzFkNAWM4UTjn6haP4QA34pk68M9N9Yw>
    <xmx:u0xdXqcFgtqubqLMRvRrsV3pawa8_8roWc0ThKapCwim-t4baOPJ4g>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 66423328005E;
        Mon,  2 Mar 2020 13:13:15 -0500 (EST)
Subject: FAILED: patch "[PATCH] io_uring: fix 32-bit compatability with sendmsg/recvmsg" failed to apply to 5.5-stable tree
To:     axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 02 Mar 2020 19:13:06 +0100
Message-ID: <15831727869827@kroah.com>
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

From d876836204897b6d7d911f942084f69a1e9d5c4d Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Thu, 27 Feb 2020 14:17:49 -0700
Subject: [PATCH] io_uring: fix 32-bit compatability with sendmsg/recvmsg

We must set MSG_CMSG_COMPAT if we're in compatability mode, otherwise
the iovec import for these commands will not do the right thing and fail
the command with -EINVAL.

Found by running the test suite compiled as 32-bit.

Cc: stable@vger.kernel.org
Fixes: aa1fa28fc73e ("io_uring: add support for recvmsg()")
Fixes: 0fa03c624d8f ("io_uring: add support for sendmsg()")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 05eea06f5421..6a595c13e108 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3001,6 +3001,11 @@ static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	sr->msg = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	sr->len = READ_ONCE(sqe->len);
 
+#ifdef CONFIG_COMPAT
+	if (req->ctx->compat)
+		sr->msg_flags |= MSG_CMSG_COMPAT;
+#endif
+
 	if (!io || req->opcode == IORING_OP_SEND)
 		return 0;
 	/* iovec is already imported */
@@ -3153,6 +3158,11 @@ static int io_recvmsg_prep(struct io_kiocb *req,
 	sr->msg = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	sr->len = READ_ONCE(sqe->len);
 
+#ifdef CONFIG_COMPAT
+	if (req->ctx->compat)
+		sr->msg_flags |= MSG_CMSG_COMPAT;
+#endif
+
 	if (!io || req->opcode == IORING_OP_RECV)
 		return 0;
 	/* iovec is already imported */

