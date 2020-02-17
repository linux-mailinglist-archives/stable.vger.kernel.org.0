Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5C116115F
	for <lists+stable@lfdr.de>; Mon, 17 Feb 2020 12:48:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728798AbgBQLs2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Feb 2020 06:48:28 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:46127 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728779AbgBQLs1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Feb 2020 06:48:27 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id ABA9921FFC;
        Mon, 17 Feb 2020 06:48:26 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 17 Feb 2020 06:48:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=DGQj7x
        lZ8j3zsQ3SAFG408MasdswMK4pDh1Ji0H8o34=; b=pqtuqJ6UYy6UoHwl6JjE21
        jzR0qATmqDHhiSik6ph/R7n3kkygg7w1IEEDjRNfeklT6IoKgij5fxd14s5fB9Qn
        APZEHqoGMShgtJ0iecPaSH2gv9sqQ8XW+IHrtHOlBURB+CGRXVO2qVvHYKcdnajC
        WqV+++9A5f4c8x2DW1h2tFckmb3ZQCLs/vkCabEilZAsGUrcJSmclwXBc7rY8O73
        +VJxfdNHHf7dWQy87Xo8c+WrP4H5Lz2uaX/IIEsuFTSB/9fOrXWhQh+nrb7FcKd4
        PkMSzrxBRTd/WAk3St5yEdFO4A/MJlb5nPN7KKUNvEexnEexqaZ2edkCL4u05u5A
        ==
X-ME-Sender: <xms:in1KXm2cPO-9IpEWr9QuTd7PH1hJlcF8NcQT0_LwvUglz-w7fiLWxw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrjeeigdefvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepudenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:in1KXoCN_58N1Q6mcOYpLVvP6iZq-jFjsG89ZXypN4AsxOGzZtTfQw>
    <xmx:in1KXq-yml6Eq3_lfI7VRQ2G-dY9mLRKBU0OwA7noHzk-8VdMMBUiw>
    <xmx:in1KXrW-niALzY5RhtkBhNhF-vFIQk5-yRlENiLkK4JHqV2SEQ0HiQ>
    <xmx:in1KXqpn_4ZI1yDXHFt2cyt1otMYgG8WinXTNnz0HgrK-gf4HFnhJA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4CF40328005D;
        Mon, 17 Feb 2020 06:48:26 -0500 (EST)
Subject: FAILED: patch "[PATCH] io_uring: grab ->fs as part of async preparation" failed to apply to 5.5-stable tree
To:     axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 Feb 2020 12:48:23 +0100
Message-ID: <158194010352105@kroah.com>
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

From ff002b30181d30cdfbca316dadd099c3ca0d739c Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Fri, 7 Feb 2020 16:05:21 -0700
Subject: [PATCH] io_uring: grab ->fs as part of async preparation

This passes it in to io-wq, so it assumes the right fs_struct when
executing async work that may need to do lookups.

Cc: stable@vger.kernel.org # 5.3+
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1a3ca6577a10..2a7bb178986e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -75,6 +75,7 @@
 #include <linux/fsnotify.h>
 #include <linux/fadvise.h>
 #include <linux/eventpoll.h>
+#include <linux/fs_struct.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/io_uring.h>
@@ -611,6 +612,8 @@ struct io_op_def {
 	unsigned		not_supported : 1;
 	/* needs file table */
 	unsigned		file_table : 1;
+	/* needs ->fs */
+	unsigned		needs_fs : 1;
 };
 
 static const struct io_op_def io_op_defs[] = {
@@ -653,12 +656,14 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_mm		= 1,
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
+		.needs_fs		= 1,
 	},
 	[IORING_OP_RECVMSG] = {
 		.async_ctx		= 1,
 		.needs_mm		= 1,
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
+		.needs_fs		= 1,
 	},
 	[IORING_OP_TIMEOUT] = {
 		.async_ctx		= 1,
@@ -689,6 +694,7 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_file		= 1,
 		.fd_non_neg		= 1,
 		.file_table		= 1,
+		.needs_fs		= 1,
 	},
 	[IORING_OP_CLOSE] = {
 		.needs_file		= 1,
@@ -702,6 +708,7 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_mm		= 1,
 		.needs_file		= 1,
 		.fd_non_neg		= 1,
+		.needs_fs		= 1,
 	},
 	[IORING_OP_READ] = {
 		.needs_mm		= 1,
@@ -733,6 +740,7 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_file		= 1,
 		.fd_non_neg		= 1,
 		.file_table		= 1,
+		.needs_fs		= 1,
 	},
 	[IORING_OP_EPOLL_CTL] = {
 		.unbound_nonreg_file	= 1,
@@ -907,6 +915,16 @@ static inline void io_req_work_grab_env(struct io_kiocb *req,
 	}
 	if (!req->work.creds)
 		req->work.creds = get_current_cred();
+	if (!req->work.fs && def->needs_fs) {
+		spin_lock(&current->fs->lock);
+		if (!current->fs->in_exec) {
+			req->work.fs = current->fs;
+			req->work.fs->users++;
+		} else {
+			req->work.flags |= IO_WQ_WORK_CANCEL;
+		}
+		spin_unlock(&current->fs->lock);
+	}
 }
 
 static inline void io_req_work_drop_env(struct io_kiocb *req)
@@ -919,6 +937,16 @@ static inline void io_req_work_drop_env(struct io_kiocb *req)
 		put_cred(req->work.creds);
 		req->work.creds = NULL;
 	}
+	if (req->work.fs) {
+		struct fs_struct *fs = req->work.fs;
+
+		spin_lock(&req->work.fs->lock);
+		if (--fs->users)
+			fs = NULL;
+		spin_unlock(&req->work.fs->lock);
+		if (fs)
+			free_fs_struct(fs);
+	}
 }
 
 static inline bool io_prep_async_work(struct io_kiocb *req,

