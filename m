Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08EF8676EA9
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:12:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbjAVPM5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:12:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230396AbjAVPM4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:12:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F96816333
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:12:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C41660C48
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:12:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EE44C433EF;
        Sun, 22 Jan 2023 15:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400374;
        bh=RXF1lnGIL+k0Nej5e4MKpNe7tZknygygAHVNp0enycc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xkOLjC1LXo48M+a3ykdETaZT84klHy+K5tG2XHOfE8lOwqaM1WBujtGsm9bPNgiFn
         AcyHc7koxO1LBa7hvG75TwEeYvYbqokNj7K6d9t9IcO+PFe0Zvg+M2f/zlfu5le+F4
         5N9LLrr6p8l01qKTA8DoKBBLhvAGq4JyOgL8JqEo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 21/98] io_uring: improve send/recv error handling
Date:   Sun, 22 Jan 2023 16:03:37 +0100
Message-Id: <20230122150230.344144048@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150229.351631432@linuxfoundation.org>
References: <20230122150229.351631432@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit 7297ce3d59449de49d3c9e1f64ae25488750a1fc upstream.

Hide all error handling under common if block, removes two extra ifs on
the success path and keeps the handling more condensed.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/5761545158a12968f3caf30f747eea65ed75dfc1.1637524285.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 55 +++++++++++++++++++++++++--------------------
 1 file changed, 31 insertions(+), 24 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 0c4d16afb9ef..34dd6267679a 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -4706,17 +4706,18 @@ static int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 		min_ret = iov_iter_count(&kmsg->msg.msg_iter);
 
 	ret = __sys_sendmsg_sock(sock, &kmsg->msg, flags);
-	if ((issue_flags & IO_URING_F_NONBLOCK) && ret == -EAGAIN)
-		return io_setup_async_msg(req, kmsg);
-	if (ret == -ERESTARTSYS)
-		ret = -EINTR;
 
+	if (ret < min_ret) {
+		if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK))
+			return io_setup_async_msg(req, kmsg);
+		if (ret == -ERESTARTSYS)
+			ret = -EINTR;
+		req_set_fail(req);
+	}
 	/* fast path, check for non-NULL to avoid function call */
 	if (kmsg->free_iov)
 		kfree(kmsg->free_iov);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
-	if (ret < min_ret)
-		req_set_fail(req);
 	__io_req_complete(req, issue_flags, ret, 0);
 	return 0;
 }
@@ -4752,13 +4753,13 @@ static int io_send(struct io_kiocb *req, unsigned int issue_flags)
 
 	msg.msg_flags = flags;
 	ret = sock_sendmsg(sock, &msg);
-	if ((issue_flags & IO_URING_F_NONBLOCK) && ret == -EAGAIN)
-		return -EAGAIN;
-	if (ret == -ERESTARTSYS)
-		ret = -EINTR;
-
-	if (ret < min_ret)
+	if (ret < min_ret) {
+		if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK))
+			return -EAGAIN;
+		if (ret == -ERESTARTSYS)
+			ret = -EINTR;
 		req_set_fail(req);
+	}
 	__io_req_complete(req, issue_flags, ret, 0);
 	return 0;
 }
@@ -4945,10 +4946,15 @@ static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 
 	ret = __sys_recvmsg_sock(sock, &kmsg->msg, req->sr_msg.umsg,
 					kmsg->uaddr, flags);
-	if (force_nonblock && ret == -EAGAIN)
-		return io_setup_async_msg(req, kmsg);
-	if (ret == -ERESTARTSYS)
-		ret = -EINTR;
+	if (ret < min_ret) {
+		if (ret == -EAGAIN && force_nonblock)
+			return io_setup_async_msg(req, kmsg);
+		if (ret == -ERESTARTSYS)
+			ret = -EINTR;
+		req_set_fail(req);
+	} else if ((flags & MSG_WAITALL) && (kmsg->msg.msg_flags & (MSG_TRUNC | MSG_CTRUNC))) {
+		req_set_fail(req);
+	}
 
 	if (req->flags & REQ_F_BUFFER_SELECTED)
 		cflags = io_put_recv_kbuf(req);
@@ -4956,8 +4962,6 @@ static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 	if (kmsg->free_iov)
 		kfree(kmsg->free_iov);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
-	if (ret < min_ret || ((flags & MSG_WAITALL) && (kmsg->msg.msg_flags & (MSG_TRUNC | MSG_CTRUNC))))
-		req_set_fail(req);
 	__io_req_complete(req, issue_flags, ret, cflags);
 	return 0;
 }
@@ -5004,15 +5008,18 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 		min_ret = iov_iter_count(&msg.msg_iter);
 
 	ret = sock_recvmsg(sock, &msg, flags);
-	if (force_nonblock && ret == -EAGAIN)
-		return -EAGAIN;
-	if (ret == -ERESTARTSYS)
-		ret = -EINTR;
 out_free:
+	if (ret < min_ret) {
+		if (ret == -EAGAIN && force_nonblock)
+			return -EAGAIN;
+		if (ret == -ERESTARTSYS)
+			ret = -EINTR;
+		req_set_fail(req);
+	} else if ((flags & MSG_WAITALL) && (msg.msg_flags & (MSG_TRUNC | MSG_CTRUNC))) {
+		req_set_fail(req);
+	}
 	if (req->flags & REQ_F_BUFFER_SELECTED)
 		cflags = io_put_recv_kbuf(req);
-	if (ret < min_ret || ((flags & MSG_WAITALL) && (msg.msg_flags & (MSG_TRUNC | MSG_CTRUNC))))
-		req_set_fail(req);
 	__io_req_complete(req, issue_flags, ret, cflags);
 	return 0;
 }
-- 
2.39.0



