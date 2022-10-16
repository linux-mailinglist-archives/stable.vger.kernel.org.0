Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91FAC5FFDB7
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 09:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbiJPHGL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 03:06:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbiJPHGL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 03:06:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD52238A08
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 00:06:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98079B80B78
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 07:06:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11BCBC433C1;
        Sun, 16 Oct 2022 07:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665903967;
        bh=6Y+4gH7cUy17HmY/xft0KaU9KG/wn88evKar3dQRCBM=;
        h=Subject:To:Cc:From:Date:From;
        b=bDx5Cz08W8Bv0Y+GhbIjIWeRK/SDBW/fr5yTiwTkGx1EHUh7iHgrb41hQF5hCvORG
         fDYzkTcgYB2Uq5aNN/xVFrkJNpbJ92pX176g40VkZMwLXMH3CpP9t9+31oeSENYOik
         gND2hs017CvPi3HOAu+UYxznrO0iDwcKL6jK+vXU=
Subject: FAILED: patch "[PATCH] io_uring/net: don't skip notifs for failed requests" failed to apply to 6.0-stable tree
To:     asml.silence@gmail.com, axboe@kernel.dk, metze@samba.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 Oct 2022 09:06:48 +0200
Message-ID: <166590400827154@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.0-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

6ae91ac9a6aa ("io_uring/net: don't skip notifs for failed requests")
a75155faef4e ("io_uring/net: fix UAF in io_sendrecv_fail()")
493108d95f14 ("io_uring/net: zerocopy sendmsg")
c4c0009e0b56 ("io_uring/net: combine fail handlers")
b0e9b5517eb1 ("io_uring/net: rename io_sendzc()")
516e82f0e043 ("io_uring/net: support non-zerocopy sendto")
6ae61b7aa2c7 ("io_uring/net: refactor io_setup_async_addr")
5693bcce892d ("io_uring/net: don't lose partial send_zc on fail")
7e6b638ed501 ("io_uring/net: don't lose partial send/recv on fail")
ac9e5784bbe7 ("io_uring/net: use io_sr_msg for sendzc")
0b048557db76 ("io_uring/net: refactor io_sr_msg types")
6bf8ad25fcd4 ("io_uring/net: io_async_msghdr caches for sendzc")
95eafc74be5e ("io_uring/net: reshuffle error handling")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6ae91ac9a6aa7d6005c3c6d0f4d263fbab9f377f Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Wed, 28 Sep 2022 00:51:49 +0100
Subject: [PATCH] io_uring/net: don't skip notifs for failed requests

We currently only add a notification CQE when the send succeded, i.e.
cqe.res >= 0. However, it'd be more robust to do buffer notifications
for failed requests as well in case drivers decide do something fanky.

Always return a buffer notification after initial prep, don't hide it.
This behaviour is better aligned with documentation and the patch also
helps the userspace to respect it.

Cc: stable@vger.kernel.org # 6.0
Suggested-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/9c8bead87b2b980fcec441b8faef52188b4a6588.1664292100.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/io_uring/net.c b/io_uring/net.c
index 6b69eff6887e..5058a9fc9e9c 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -916,7 +916,6 @@ void io_send_zc_cleanup(struct io_kiocb *req)
 			kfree(io->free_iov);
 	}
 	if (zc->notif) {
-		zc->notif->flags |= REQ_F_CQE_SKIP;
 		io_notif_flush(zc->notif);
 		zc->notif = NULL;
 	}
@@ -1047,7 +1046,7 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
 	struct msghdr msg;
 	struct iovec iov;
 	struct socket *sock;
-	unsigned msg_flags, cflags;
+	unsigned msg_flags;
 	int ret, min_ret = 0;
 
 	sock = sock_from_file(req->file);
@@ -1115,8 +1114,6 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
 			req->flags |= REQ_F_PARTIAL_IO;
 			return io_setup_async_addr(req, &__address, issue_flags);
 		}
-		if (ret < 0 && !zc->done_io)
-			zc->notif->flags |= REQ_F_CQE_SKIP;
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
 		req_set_fail(req);
@@ -1129,8 +1126,7 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
 
 	io_notif_flush(zc->notif);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
-	cflags = ret >= 0 ? IORING_CQE_F_MORE : 0;
-	io_req_set_res(req, ret, cflags);
+	io_req_set_res(req, ret, IORING_CQE_F_MORE);
 	return IOU_OK;
 }
 
@@ -1139,7 +1135,7 @@ int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct io_async_msghdr iomsg, *kmsg;
 	struct socket *sock;
-	unsigned flags, cflags;
+	unsigned flags;
 	int ret, min_ret = 0;
 
 	sock = sock_from_file(req->file);
@@ -1178,8 +1174,6 @@ int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags)
 			req->flags |= REQ_F_PARTIAL_IO;
 			return io_setup_async_msg(req, kmsg, issue_flags);
 		}
-		if (ret < 0 && !sr->done_io)
-			sr->notif->flags |= REQ_F_CQE_SKIP;
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
 		req_set_fail(req);
@@ -1196,27 +1190,20 @@ int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags)
 
 	io_notif_flush(sr->notif);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
-	cflags = ret >= 0 ? IORING_CQE_F_MORE : 0;
-	io_req_set_res(req, ret, cflags);
+	io_req_set_res(req, ret, IORING_CQE_F_MORE);
 	return IOU_OK;
 }
 
 void io_sendrecv_fail(struct io_kiocb *req)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
-	int res = req->cqe.res;
 
 	if (req->flags & REQ_F_PARTIAL_IO)
-		res = sr->done_io;
+		req->cqe.res = sr->done_io;
+
 	if ((req->flags & REQ_F_NEED_CLEANUP) &&
-	    (req->opcode == IORING_OP_SEND_ZC || req->opcode == IORING_OP_SENDMSG_ZC)) {
-		/* preserve notification for partial I/O */
-		if (res < 0)
-			sr->notif->flags |= REQ_F_CQE_SKIP;
-		io_notif_flush(sr->notif);
-		sr->notif = NULL;
-	}
-	io_req_set_res(req, res, req->cqe.flags);
+	    (req->opcode == IORING_OP_SEND_ZC || req->opcode == IORING_OP_SENDMSG_ZC))
+		req->cqe.flags |= IORING_CQE_F_MORE;
 }
 
 int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)

