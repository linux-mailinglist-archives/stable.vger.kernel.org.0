Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11C6A5FFDCE
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 09:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbiJPHWc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 03:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiJPHWb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 03:22:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74FD695AE
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 00:22:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1125560A78
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 07:22:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 256A6C433D7;
        Sun, 16 Oct 2022 07:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665904949;
        bh=aT2rbvuTdv+Ciuehdiqof8KAFeiiJMBNSaisfCfEdI4=;
        h=Subject:To:Cc:From:Date:From;
        b=NtfpZNGUlPHplkLaUZPYWWt9FTG0K8XqLBBbsS3Y4lSHvPYQtzohTDPwdyakyoxga
         iLvIeEjXm34AXYsFEP1MNm6eNRx59qWeg15uRN93NzzzO22ogbAaQrbpg43suf7TVR
         aDFGrbm9jM/oMyWQNOFP0E6ixHFqZvVT1YqJCNuc=
Subject: FAILED: patch "[PATCH] io_uring/net: handle -EINPROGRESS correct for" failed to apply to 5.19-stable tree
To:     axboe@kernel.dk, aidansun05@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 Oct 2022 09:23:16 +0200
Message-ID: <166590499623534@kroah.com>
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


The patch below does not apply to the 5.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

3fb1bd688172 ("io_uring/net: handle -EINPROGRESS correct for IORING_OP_CONNECT")
f9ead18c1058 ("io_uring: split network related opcodes into its own file")
e0da14def1ee ("io_uring: move statx handling to its own file")
a9c210cebe13 ("io_uring: move epoll handler to its own file")
4cf90495281b ("io_uring: add a dummy -EOPNOTSUPP prep handler")
99f15d8d6136 ("io_uring: move uring_cmd handling to its own file")
cd40cae29ef8 ("io_uring: split out open/close operations")
453b329be5ea ("io_uring: separate out file table handling code")
f4c163dd7d4b ("io_uring: split out fadvise/madvise operations")
0d5847274037 ("io_uring: split out fs related sync/fallocate functions")
531113bbd5bf ("io_uring: split out splice related operations")
11aeb71406dd ("io_uring: split out filesystem related operations")
e28683bdfc2f ("io_uring: move nop into its own file")
5e2a18d93fec ("io_uring: move xattr related opcodes to its own file")
97b388d70b53 ("io_uring: handle completions in the core")
de23077eda61 ("io_uring: set completion results upfront")
e27f928ee1cb ("io_uring: add io_uring_types.h")
4d4c9cff4f70 ("io_uring: define a request type cleanup handler")
890968dc0336 ("io_uring: unify struct io_symlink and io_hardlink")
9a3a11f977f9 ("io_uring: convert iouring_cmd to io_cmd_type")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3fb1bd68817288729179444caf1fd5c5c4d2d65d Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Tue, 4 Oct 2022 20:29:48 -0600
Subject: [PATCH] io_uring/net: handle -EINPROGRESS correct for
 IORING_OP_CONNECT

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

diff --git a/io_uring/net.c b/io_uring/net.c
index caa6a803cb72..8c7226b5bf41 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -46,6 +46,7 @@ struct io_connect {
 	struct file			*file;
 	struct sockaddr __user		*addr;
 	int				addr_len;
+	bool				in_progress;
 };
 
 struct io_sr_msg {
@@ -1386,6 +1387,7 @@ int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	conn->addr = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	conn->addr_len =  READ_ONCE(sqe->addr2);
+	conn->in_progress = false;
 	return 0;
 }
 
@@ -1397,6 +1399,16 @@ int io_connect(struct io_kiocb *req, unsigned int issue_flags)
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
@@ -1413,13 +1425,17 @@ int io_connect(struct io_kiocb *req, unsigned int issue_flags)
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

