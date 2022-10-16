Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9CF55FFDB8
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 09:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbiJPHGQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 03:06:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbiJPHGO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 03:06:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D61C38A08
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 00:06:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2CDECB80B78
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 07:06:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DBD5C433C1;
        Sun, 16 Oct 2022 07:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665903970;
        bh=G/e+NeehEEZ4FbFAlNdOsPwCqje9QQOImHIa068lTOE=;
        h=Subject:To:Cc:From:Date:From;
        b=z45yKgjU9IXY0UdKASADiMS8Ml2jw80x7sQ2sBKmuU1gnCVlCaFjHRUBNoo5o65pn
         kJlmgWFEi/EHQEtevhxtXXUGv+9FKcyBRBkBbtO/PHSJ8va9smBQL4YBacNQaYweDb
         JBqcldx9tnK2vSoCcpNyZsoaixpPltSUwne4cPOs=
Subject: FAILED: patch "[PATCH] io_uring/net: fix notif cqe reordering" failed to apply to 6.0-stable tree
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 Oct 2022 09:06:55 +0200
Message-ID: <1665904015154101@kroah.com>
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

108893ddcc4d ("io_uring/net: fix notif cqe reordering")
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

From 108893ddcc4d3aa0a4a02aeb02d478e997001227 Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Thu, 29 Sep 2022 22:23:19 +0100
Subject: [PATCH] io_uring/net: fix notif cqe reordering

send zc is not restricted to !IO_URING_F_UNLOCKED anymore and so
we can't use task-tw ordering trick to order notification cqes
with requests completions. In this case leave it alone and let
io_send_zc_cleanup() flush it.

Cc: stable@vger.kernel.org
Fixes: 53bdc88aac9a2 ("io_uring/notif: order notif vs send CQEs")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/0031f3a00d492e814a4a0935a2029a46d9c9ba06.1664486545.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/io_uring/net.c b/io_uring/net.c
index 604eac5f7a34..caa6a803cb72 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1127,8 +1127,14 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
 	else if (zc->done_io)
 		ret = zc->done_io;
 
-	io_notif_flush(zc->notif);
-	req->flags &= ~REQ_F_NEED_CLEANUP;
+	/*
+	 * If we're in io-wq we can't rely on tw ordering guarantees, defer
+	 * flushing notif to io_send_zc_cleanup()
+	 */
+	if (!(issue_flags & IO_URING_F_UNLOCKED)) {
+		io_notif_flush(zc->notif);
+		req->flags &= ~REQ_F_NEED_CLEANUP;
+	}
 	io_req_set_res(req, ret, IORING_CQE_F_MORE);
 	return IOU_OK;
 }
@@ -1182,8 +1188,10 @@ int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags)
 		req_set_fail(req);
 	}
 	/* fast path, check for non-NULL to avoid function call */
-	if (kmsg->free_iov)
+	if (kmsg->free_iov) {
 		kfree(kmsg->free_iov);
+		kmsg->free_iov = NULL;
+	}
 
 	io_netmsg_recycle(req, issue_flags);
 	if (ret >= 0)
@@ -1191,8 +1199,14 @@ int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags)
 	else if (sr->done_io)
 		ret = sr->done_io;
 
-	io_notif_flush(sr->notif);
-	req->flags &= ~REQ_F_NEED_CLEANUP;
+	/*
+	 * If we're in io-wq we can't rely on tw ordering guarantees, defer
+	 * flushing notif to io_send_zc_cleanup()
+	 */
+	if (!(issue_flags & IO_URING_F_UNLOCKED)) {
+		io_notif_flush(sr->notif);
+		req->flags &= ~REQ_F_NEED_CLEANUP;
+	}
 	io_req_set_res(req, ret, IORING_CQE_F_MORE);
 	return IOU_OK;
 }

