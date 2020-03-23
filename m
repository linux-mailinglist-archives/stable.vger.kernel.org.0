Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3951418F706
	for <lists+stable@lfdr.de>; Mon, 23 Mar 2020 15:36:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgCWOgT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Mar 2020 10:36:19 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:38785 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725830AbgCWOgT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Mar 2020 10:36:19 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 4229750F;
        Mon, 23 Mar 2020 10:36:18 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 23 Mar 2020 10:36:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=VStryR
        +sFsYE8w86tPmnkuJUM+Ictvy5Zz3+DABFIDY=; b=souLEtpCz2JNWPO7mHGZMi
        JZcxvzk6uNKIsi9h34DbNf/6nlz3aakD0PsDZUr1R5jSI7IrF2PaoIwxvkq9J58R
        s+cRMqRnzRkX93HJMWAG8QoWHfcJV4SdPLWmrYZ2CTt7C/JT65QIzkVfuQBMzev/
        iPQh8zqQPBXEnXLfbPpD8rC5h0H+CUOsamZshhf9A0ZP4VID1N4QKSulzTyYhTFL
        JMWPDCRpIPLwkJ2Tsld+cQ4k0YK4zH4vKQB143gA7Ny3mb8KHuFwSEWAFd58oSSL
        cecHQgeQ0aThOXe+u8WeLRY1G67Uef+2URA0GnVPR7T+Tgz1EGnCLZdpqEg6DaUQ
        ==
X-ME-Sender: <xms:Ycl4XofjEpYnAjx-4I_IqQzR_wSGYhqmD16WPU3EvDl7wqzYsf1_kQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudegkedgieehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:Ycl4XhUxh95O7GyC_WXkQMloBdHbiuiOSLefnlGu_YWgcSqNgsKYHg>
    <xmx:Ycl4Xr2anG7Rmtt0oGoaHh6GTIAQ45bdJnVUIH3Qb3KgxVfzsjZnKg>
    <xmx:Ycl4XmtTMfFObqXGBCrPDMVqZMV-HKgKeniEVjBkidupNNKIF4Osgg>
    <xmx:Ycl4XjyF3vRCh2N8o-gg_YUlR9tkxxTvMc2JBlT4Wogep6R6KU0Kzw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 255563062A4E;
        Mon, 23 Mar 2020 10:36:17 -0400 (EDT)
Subject: FAILED: patch "[PATCH] io_uring: NULL-deref for IOSQE_{ASYNC,DRAIN}" failed to apply to 5.5-stable tree
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 23 Mar 2020 15:36:15 +0100
Message-ID: <158497417567105@kroah.com>
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

From f1d96a8fcbbbb22d4fbc1d69eaaa678bbb0ff6e2 Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Fri, 13 Mar 2020 22:29:14 +0300
Subject: [PATCH] io_uring: NULL-deref for IOSQE_{ASYNC,DRAIN}

Processing links, io_submit_sqe() prepares requests, drops sqes, and
passes them with sqe=NULL to io_queue_sqe(). There IOSQE_DRAIN and/or
IOSQE_ASYNC requests will go through the same prep, which doesn't expect
sqe=NULL and fail with NULL pointer deference.

Always do full prepare including io_alloc_async_ctx() for linked
requests, and then it can skip the second preparation.

Cc: stable@vger.kernel.org # 5.5
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1b2517291b78..b1fbc4424aa6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4131,6 +4131,9 @@ static int io_req_defer_prep(struct io_kiocb *req,
 {
 	ssize_t ret = 0;
 
+	if (!sqe)
+		return 0;
+
 	if (io_op_defs[req->opcode].file_table) {
 		ret = io_grab_files(req);
 		if (unlikely(ret))
@@ -4907,6 +4910,11 @@ static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		if (sqe_flags & (IOSQE_IO_LINK|IOSQE_IO_HARDLINK)) {
 			req->flags |= REQ_F_LINK;
 			INIT_LIST_HEAD(&req->link_list);
+
+			if (io_alloc_async_ctx(req)) {
+				ret = -EAGAIN;
+				goto err_req;
+			}
 			ret = io_req_defer_prep(req, sqe);
 			if (ret)
 				req->flags |= REQ_F_FAIL_LINK;

