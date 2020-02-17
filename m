Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF4B16115C
	for <lists+stable@lfdr.de>; Mon, 17 Feb 2020 12:48:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728797AbgBQLs0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Feb 2020 06:48:26 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:48523 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728779AbgBQLsZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Feb 2020 06:48:25 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id E338D21F83;
        Mon, 17 Feb 2020 06:48:24 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 17 Feb 2020 06:48:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=50qF98
        VoAMIVvf64ALHMkZoQ7kAGsOaojP9w5tM0EG0=; b=ez6Q3OUAm+dhTMHgBfXwsr
        aWhGoPd7Zt9LR1XPeeiPdRA3TOxUqCmwmkqKBmL7LRSxWbJeCrmn+UzAEvCLLUCp
        vxfBx7sEkwO+n5bATECPJSH5cMp8hiWnPXhC4g+kSgu3pRAIJ/WS40P29fdQcDjb
        Fu1hMKECsU2NkORSjPwORznIMpGUzWPfWiokxJoxmqfpTs5bxmPNYclcRLMbsOWZ
        EmUXW/CUJsKY1y/CvmQfABDNJs1rF8eDoZbaQBFPoMMaxpyJ0wUW4HAcgvFcXHZt
        Ct71DJTKUEC9PxCpX3pgQvLylqbxWTg7Sb3I9cB1pmtl33s7R0c0PFGK62YjkM/A
        ==
X-ME-Sender: <xms:iH1KXl4IucDxEzLAYWng7rccFy3a1ys0gbAtbRotgCJ43zEAKlZj0w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrjeeigdefvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepmhhsghdrfhgrshhtnecukfhppeekfedrkeeirdekledruddtje
    enucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgv
    gheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:iH1KXsENptbiTxmArpy_AUr1qK8reBAYS4zc_2QVe_-1WsykoIREQA>
    <xmx:iH1KXmkiqZ69mNu-iwcr9kDIJVivxBb6W7tqhCW9OOsaIYzzSRp0cw>
    <xmx:iH1KXvBP3YbLqt7saguS-TxXzcdSmghoOpA6HbzPfgMqRpQhuEQLPg>
    <xmx:iH1KXi2Dbe1JwIcBRYJq7dkf8hlo8Y7kMGefgtUbM4Mnhw_AY_f7YQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 855CE328005A;
        Mon, 17 Feb 2020 06:48:24 -0500 (EST)
Subject: FAILED: patch "[PATCH] io_uring: retain sockaddr_storage across send/recvmsg async" failed to apply to 5.4-stable tree
To:     axboe@kernel.dk, jonas@norrbonn.se
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 Feb 2020 12:48:16 +0100
Message-ID: <1581940096188131@kroah.com>
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

From b537916ca5107c3a8714b8ab3099c0ec205aec12 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Sun, 9 Feb 2020 11:29:15 -0700
Subject: [PATCH] io_uring: retain sockaddr_storage across send/recvmsg async
 punt

Jonas reports that he sometimes sees -97/-22 error returns from
sendmsg, if it gets punted async. This is due to not retaining the
sockaddr_storage between calls. Include that in the state we copy when
going async.

Cc: stable@vger.kernel.org # 5.3+
Reported-by: Jonas Bonn <jonas@norrbonn.se>
Tested-by: Jonas Bonn <jonas@norrbonn.se>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 971d51c50151..6d4e20d59729 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -442,6 +442,7 @@ struct io_async_msghdr {
 	struct iovec			*iov;
 	struct sockaddr __user		*uaddr;
 	struct msghdr			msg;
+	struct sockaddr_storage		addr;
 };
 
 struct io_async_rw {
@@ -3032,12 +3033,11 @@ static int io_sendmsg(struct io_kiocb *req, struct io_kiocb **nxt,
 	sock = sock_from_file(req->file, &ret);
 	if (sock) {
 		struct io_async_ctx io;
-		struct sockaddr_storage addr;
 		unsigned flags;
 
 		if (req->io) {
 			kmsg = &req->io->msg;
-			kmsg->msg.msg_name = &addr;
+			kmsg->msg.msg_name = &req->io->msg.addr;
 			/* if iov is set, it's allocated already */
 			if (!kmsg->iov)
 				kmsg->iov = kmsg->fast_iov;
@@ -3046,7 +3046,7 @@ static int io_sendmsg(struct io_kiocb *req, struct io_kiocb **nxt,
 			struct io_sr_msg *sr = &req->sr_msg;
 
 			kmsg = &io.msg;
-			kmsg->msg.msg_name = &addr;
+			kmsg->msg.msg_name = &io.msg.addr;
 
 			io.msg.iov = io.msg.fast_iov;
 			ret = sendmsg_copy_msghdr(&io.msg.msg, sr->msg,
@@ -3185,12 +3185,11 @@ static int io_recvmsg(struct io_kiocb *req, struct io_kiocb **nxt,
 	sock = sock_from_file(req->file, &ret);
 	if (sock) {
 		struct io_async_ctx io;
-		struct sockaddr_storage addr;
 		unsigned flags;
 
 		if (req->io) {
 			kmsg = &req->io->msg;
-			kmsg->msg.msg_name = &addr;
+			kmsg->msg.msg_name = &req->io->msg.addr;
 			/* if iov is set, it's allocated already */
 			if (!kmsg->iov)
 				kmsg->iov = kmsg->fast_iov;
@@ -3199,7 +3198,7 @@ static int io_recvmsg(struct io_kiocb *req, struct io_kiocb **nxt,
 			struct io_sr_msg *sr = &req->sr_msg;
 
 			kmsg = &io.msg;
-			kmsg->msg.msg_name = &addr;
+			kmsg->msg.msg_name = &io.msg.addr;
 
 			io.msg.iov = io.msg.fast_iov;
 			ret = recvmsg_copy_msghdr(&io.msg.msg, sr->msg,

