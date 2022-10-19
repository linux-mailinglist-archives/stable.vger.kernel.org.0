Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61E52603BBD
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbiJSIjE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:39:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbiJSIik (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:38:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38EB38112C;
        Wed, 19 Oct 2022 01:38:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A9C17617AC;
        Wed, 19 Oct 2022 08:37:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4B48C43470;
        Wed, 19 Oct 2022 08:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666168676;
        bh=72hmIiOc3TIOnfmh7t6u3JsBy/1wx4DTVUeW+p9gm0g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NkIYhfVfVbR4TXah9qmoTWoVzVSwPzhX66EG4VzNFPVJLWdTWeWtQ/EUsvMvdua2L
         8eRg/iObNtg6PyzwieHahfyICEf24dugIFleWN/wj25Iycw663CmGRYtbDOE7mDoqV
         eIT2oJNCciQL5NutZWqCSq2W3443JEot21O/oBYg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aidan Sun <aidansun05@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.0 018/862] io_uring/net: handle -EINPROGRESS correct for IORING_OP_CONNECT
Date:   Wed, 19 Oct 2022 10:21:45 +0200
Message-Id: <20221019083250.812246178@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 3fb1bd68817288729179444caf1fd5c5c4d2d65d upstream.

We treat EINPROGRESS like EAGAIN, but if we're retrying post getting
EINPROGRESS, then we just need to check the socket for errors and
terminate the request.

This was exposed on a bluetooth connection request which ends up
taking a while and hitting EINPROGRESS, and yields a CQE result of
-EBADFD because we're retrying a connect on a socket that is now
connected.

Cc: stable@vger.kernel.org
Fixes: 87f80d623c6c ("io_uring: handle connect -EINPROGRESS like -EAGAIN")
Link: https://github.com/axboe/liburing/issues/671
Reported-by: Aidan Sun <aidansun05@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c |   28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -46,6 +46,7 @@ struct io_connect {
 	struct file			*file;
 	struct sockaddr __user		*addr;
 	int				addr_len;
+	bool				in_progress;
 };
 
 struct io_sr_msg {
@@ -1263,6 +1264,7 @@ int io_connect_prep(struct io_kiocb *req
 
 	conn->addr = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	conn->addr_len =  READ_ONCE(sqe->addr2);
+	conn->in_progress = false;
 	return 0;
 }
 
@@ -1274,6 +1276,16 @@ int io_connect(struct io_kiocb *req, uns
 	int ret;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 
+	if (connect->in_progress) {
+		struct socket *socket;
+
+		ret = -ENOTSOCK;
+		socket = sock_from_file(req->file);
+		if (socket)
+			ret = sock_error(socket->sk);
+		goto out;
+	}
+
 	if (req_has_async_data(req)) {
 		io = req->async_data;
 	} else {
@@ -1290,13 +1302,17 @@ int io_connect(struct io_kiocb *req, uns
 	ret = __sys_connect_file(req->file, &io->address,
 					connect->addr_len, file_flags);
 	if ((ret == -EAGAIN || ret == -EINPROGRESS) && force_nonblock) {
-		if (req_has_async_data(req))
-			return -EAGAIN;
-		if (io_alloc_async_data(req)) {
-			ret = -ENOMEM;
-			goto out;
+		if (ret == -EINPROGRESS) {
+			connect->in_progress = true;
+		} else {
+			if (req_has_async_data(req))
+				return -EAGAIN;
+			if (io_alloc_async_data(req)) {
+				ret = -ENOMEM;
+				goto out;
+			}
+			memcpy(req->async_data, &__io, sizeof(__io));
 		}
-		memcpy(req->async_data, &__io, sizeof(__io));
 		return -EAGAIN;
 	}
 	if (ret == -ERESTARTSYS)


