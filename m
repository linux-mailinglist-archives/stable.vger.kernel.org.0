Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85CEC16115A
	for <lists+stable@lfdr.de>; Mon, 17 Feb 2020 12:48:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728792AbgBQLsW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Feb 2020 06:48:22 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:35737 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728779AbgBQLsW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Feb 2020 06:48:22 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 634CA21EAF;
        Mon, 17 Feb 2020 06:48:21 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 17 Feb 2020 06:48:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=P2lbOF
        sYkXb75tZG5zljzPMaQPZDykvBxGCZcIY8n0w=; b=02Bjv3RybJ9FPowMhd4atK
        5eQL/WLV7A5kWMZ6J4Ij2c3dMOVpdbTgnYhzzfCXq6ksqoa02Xhg5dN8GggRCaqd
        gEJEchfvsp47ImdS+PYwpumLwfxeN15xTYM6ph+6C8HWyfWovQrs+pfTrC8x73AL
        CsluYQ/EpraSWT9wwS6AZqjND7HpArLzWdyL7w77XFca743ZM0ZebpZJcntu2a4Y
        Kh4xkYzUSQOwu1pEzHdKOsdqftZK3DlTuE6IXeo3TbullRtEMhOaVaYrF2+d1rPw
        eR/RErq8aIsN1AR0tbUyNMZN7Jd2kORNz9sHr0gKYCfDnu8XZfSTk8HEfntMFu3Q
        ==
X-ME-Sender: <xms:hX1KXt4yERqiLGyhiqlsE3fShqt-viNU0iLk1ovKRFXSpiFJV-XVpg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrjeeigdefvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepmhhsghdrfhgrshhtnecukfhppeekfedrkeeirdekledruddtje
    enucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgv
    gheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:hX1KXlcqmGN6faqvxBejDImOWPYs9V5wVBGFCUyaeR_OVoq0zS-oqg>
    <xmx:hX1KXhA_KHExtfEWP2Beh37YJCqg1gIOMDziMP3UE7Q7xoRf1l9mXg>
    <xmx:hX1KXo9vzAbhTZHIwLllD9ABjyB2KINl0hh0PagoyF6N7vsQsHqw6w>
    <xmx:hX1KXsC-L0hJeYCBxbFWZyAxOPOiVlx22mODVepUfDdpzDg65Sk1NA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C63523280064;
        Mon, 17 Feb 2020 06:48:20 -0500 (EST)
Subject: FAILED: patch "[PATCH] io_uring: retain sockaddr_storage across send/recvmsg async" failed to apply to 5.5-stable tree
To:     axboe@kernel.dk, jonas@norrbonn.se
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 Feb 2020 12:48:16 +0100
Message-ID: <158194009625194@kroah.com>
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

