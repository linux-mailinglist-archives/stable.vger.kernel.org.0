Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E496161161
	for <lists+stable@lfdr.de>; Mon, 17 Feb 2020 12:48:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728799AbgBQLsd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Feb 2020 06:48:33 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:52961 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728779AbgBQLsd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Feb 2020 06:48:33 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 2DBCE2201F;
        Mon, 17 Feb 2020 06:48:33 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 17 Feb 2020 06:48:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=74AyOt
        JjuXVPEAZGTO+mhQL//o14u9SLbIHwd2HzeO0=; b=xt3DpzmXw2XOpPeILbZeDI
        wvdLxC4+5jkcJOW6yl7Nd2pIRJBWPgTSEJGz+E1sBCK6aws2IE+aFHgbVEB9nQpb
        0+eO2tWgWoaFoOJPKEyU8cVh9Ebi/d0hGYdRQjL84/jo5J9RrvY02I4KmT+e37UD
        ZSoPJ49SPueVIp+1Xb1u4c4PeAuh4LVMLfyD/qjfk9NNTNe9CWCnYSxfVZSbQbyQ
        RoocgLfjNdIIXPQmlojeJKzR1eSYpFoZEpK92KIS19B16zZk7Tc8A1MYElfImzoG
        8+Mp2DVtyAlqSa8APIx01u2HSgKJ4L4oquBQayg6WvQ5d+yZJ0wYFIUkgrkD7gJw
        ==
X-ME-Sender: <xms:kX1KXrTrZCOrRaXNmdx6Dwl9EtHQe88lSD4MNjD3H6yghfWD9ZBftg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrjeeigdefvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepvdenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:kX1KXn4Ek5bkwoDLrMoLt-pxcrxoixPeNM7fxxEBYgUbdMvM6ArY3A>
    <xmx:kX1KXrJNPnLMgTii-20OTQuz9k1CW76YeE-Qc2qvr6hBKtyYN5GaKA>
    <xmx:kX1KXnn4NTmgPDvqn6advf3JFs9PIEB58ixgMuZLblTI1BrTPmwOtw>
    <xmx:kX1KXlQvhxhI3TiHUMMLMfv3MtM9zA_0PpUg89gyd49dPVmUIIMqDA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C42DD3060C28;
        Mon, 17 Feb 2020 06:48:32 -0500 (EST)
Subject: FAILED: patch "[PATCH] io_uring: grab ->fs as part of async preparation" failed to apply to 5.4-stable tree
To:     axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 Feb 2020 12:48:23 +0100
Message-ID: <1581940103465@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
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

