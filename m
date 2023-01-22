Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE98676F02
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:16:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231133AbjAVPQs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:16:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230520AbjAVPQr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:16:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14E2D22021
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:16:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3DFD60C5C
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:16:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6195C433EF;
        Sun, 22 Jan 2023 15:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400606;
        bh=18DmUBkfpAST8cLTNjiiH0jC1UoGKBxwGmfIYGGsf1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ISHiJF7R83/ZljQk0pgVWtJhUDuLhw2W8BX2iS2haqYHJT98Ru79+FRhPK1KkFgbi
         AQZWQZzNlFLWPOiQAyITT/3m5kv8d1YUgdUnnMqjfp6qNhLM9kT0R/LwBhCk4yqhrI
         R0fZBfX9t4ZMGg5JGxnt+vV6oNd83Ji3/pqIzzuE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Constantine Gavrilov <constantine.gavrilov@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 032/117] io_uring: ensure recv and recvmsg handle MSG_WAITALL correctly
Date:   Sun, 22 Jan 2023 16:03:42 +0100
Message-Id: <20230122150234.059931638@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150232.736358800@linuxfoundation.org>
References: <20230122150232.736358800@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

commit 7ba89d2af17aa879dda30f5d5d3f152e587fc551 upstream.

We currently don't attempt to get the full asked for length even if
MSG_WAITALL is set, if we get a partial receive. If we do see a partial
receive, then just note how many bytes we did and return -EAGAIN to
get it retried.

The iov is advanced appropriately for the vector based case, and we
manually bump the buffer and remainder for the non-vector case.

Cc: stable@vger.kernel.org
Reported-by: Constantine Gavrilov <constantine.gavrilov@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 93023562d548..04441e981624 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -578,6 +578,7 @@ struct io_sr_msg {
 	int				msg_flags;
 	int				bgid;
 	size_t				len;
+	size_t				done_io;
 	struct io_buffer		*kbuf;
 };
 
@@ -5063,12 +5064,21 @@ static int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (req->ctx->compat)
 		sr->msg_flags |= MSG_CMSG_COMPAT;
 #endif
+	sr->done_io = 0;
 	return 0;
 }
 
+static bool io_net_retry(struct socket *sock, int flags)
+{
+	if (!(flags & MSG_WAITALL))
+		return false;
+	return sock->type == SOCK_STREAM || sock->type == SOCK_SEQPACKET;
+}
+
 static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_async_msghdr iomsg, *kmsg;
+	struct io_sr_msg *sr = &req->sr_msg;
 	struct socket *sock;
 	struct io_buffer *kbuf;
 	unsigned flags;
@@ -5111,6 +5121,10 @@ static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 			return io_setup_async_msg(req, kmsg);
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
+		if (ret > 0 && io_net_retry(sock, flags)) {
+			sr->done_io += ret;
+			return io_setup_async_msg(req, kmsg);
+		}
 		req_set_fail(req);
 	} else if ((flags & MSG_WAITALL) && (kmsg->msg.msg_flags & (MSG_TRUNC | MSG_CTRUNC))) {
 		req_set_fail(req);
@@ -5122,6 +5136,10 @@ static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 	if (kmsg->free_iov)
 		kfree(kmsg->free_iov);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
+	if (ret >= 0)
+		ret += sr->done_io;
+	else if (sr->done_io)
+		ret = sr->done_io;
 	__io_req_complete(req, issue_flags, ret, cflags);
 	return 0;
 }
@@ -5174,12 +5192,22 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 			return -EAGAIN;
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
+		if (ret > 0 && io_net_retry(sock, flags)) {
+			sr->len -= ret;
+			sr->buf += ret;
+			sr->done_io += ret;
+			return -EAGAIN;
+		}
 		req_set_fail(req);
 	} else if ((flags & MSG_WAITALL) && (msg.msg_flags & (MSG_TRUNC | MSG_CTRUNC))) {
 		req_set_fail(req);
 	}
 	if (req->flags & REQ_F_BUFFER_SELECTED)
 		cflags = io_put_recv_kbuf(req);
+	if (ret >= 0)
+		ret += sr->done_io;
+	else if (sr->done_io)
+		ret = sr->done_io;
 	__io_req_complete(req, issue_flags, ret, cflags);
 	return 0;
 }
-- 
2.39.0



