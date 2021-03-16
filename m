Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB5633D7A9
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 16:34:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237231AbhCPPe0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 11:34:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231983AbhCPPeK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Mar 2021 11:34:10 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFF86C06174A;
        Tue, 16 Mar 2021 08:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-Id:Date:Cc:To:From;
        bh=nA55vQsA1n3fDiIL6Chmq1jF4JdcglTh/9wwlpAPdQ4=; b=PNlhcUFFpD865y9Vpj1Ui4DQjB
        GCwyv1I9bibhJkoSQWe/kj828u/MlKOJJCF191sNGfIS1xdqGkvQOQCWYjvcFDZivVfOe/7vWyoNl
        TxF+SFmznliiwIhAqWa/QHKs1kGogHfkD6Da22J7pzdb7C/4F2GC80CnjtJAJQOT6biEFLI0DmlE3
        QUZ6OErGgp+pqe6PJt2BNaRkzumf7FWrai/VK17fXx3Rly34ulRVANmUNVttYSsJgW+vh7/JeptV4
        irUM/rXAyEsRrIUH/Q0hTYTUdhLcC3oc/xMvzzKckeU22peOCOCaTkPCcsaoRyM4DLGWyq0gtq5Gr
        MYzPXKF9g5qDPQPlD5UYFn7jB5myp5PNUIlvb2yFXlPiS2sNhXDkzDmm1lwVtvb0WG1pK6KIzsD4Q
        za6ysEXhmOVP1WRjhLy9eLLUy7k+aSfQb+ckJHOyP9AArMu84F4tUQVIVD1GqK1Xq0ZQfZugCBZ6K
        S0apD5Z0DCBDbYyJfR8m4E1X;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lMBhh-0000js-Nt; Tue, 16 Mar 2021 15:33:53 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     io-uring@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>, stable@vger.kernel.org
Subject: [PATCH 1/2] io_uring: call req_set_fail_links() on short send[msg]()/recv[msg]() calls
Date:   Tue, 16 Mar 2021 16:33:26 +0100
Message-Id: <c4e1a4cc0d905314f4d5dc567e65a7b09621aab3.1615908477.git.metze@samba.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1615908477.git.metze@samba.org>
References: <cover.1615908477.git.metze@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Without that it's not safe to use them in a linked combination with
others.

Now combinations like IORING_OP_SENDMSG followed by IORING_OP_SPLICE
should be possible.

We already handle short reads and writes for the following opcodes:

- IORING_OP_READV
- IORING_OP_READ_FIXED
- IORING_OP_READ
- IORING_OP_WRITEV
- IORING_OP_WRITE_FIXED
- IORING_OP_WRITE
- IORING_OP_SPLICE
- IORING_OP_TEE

Now we have it for these as well:

- IORING_OP_SENDMSG
- IORING_OP_SEND
- IORING_OP_RECVMSG
- IORING_OP_RECV

For IORING_OP_RECVMSG we also check for the MSG_TRUNC and MSG_CTRUNC
flags in order to call req_set_fail_links().

cc: stable@vger.kernel.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/io_uring.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e88d9f95d0aa..f8a6a629e4db 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4354,6 +4354,7 @@ static int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_async_msghdr iomsg, *kmsg;
 	struct socket *sock;
 	unsigned flags;
+	int expected_ret;
 	int ret;
 
 	sock = sock_from_file(req->file);
@@ -4374,6 +4375,9 @@ static int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 	else if (issue_flags & IO_URING_F_NONBLOCK)
 		flags |= MSG_DONTWAIT;
 
+	expected_ret = iov_iter_count(&kmsg->msg.msg_iter);
+	if (unlikely(expected_ret == MAX_RW_COUNT))
+		expected_ret += 1;
 	ret = __sys_sendmsg_sock(sock, &kmsg->msg, flags);
 	if ((issue_flags & IO_URING_F_NONBLOCK) && ret == -EAGAIN)
 		return io_setup_async_msg(req, kmsg);
@@ -4384,7 +4388,7 @@ static int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 	if (kmsg->free_iov)
 		kfree(kmsg->free_iov);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
-	if (ret < 0)
+	if (ret != expected_ret)
 		req_set_fail_links(req);
 	__io_req_complete(req, issue_flags, ret, 0);
 	return 0;
@@ -4425,7 +4429,7 @@ static int io_send(struct io_kiocb *req, unsigned int issue_flags)
 	if (ret == -ERESTARTSYS)
 		ret = -EINTR;
 
-	if (ret < 0)
+	if (ret != sr->len)
 		req_set_fail_links(req);
 	__io_req_complete(req, issue_flags, ret, 0);
 	return 0;
@@ -4577,6 +4581,7 @@ static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 	struct socket *sock;
 	struct io_buffer *kbuf;
 	unsigned flags;
+	int expected_ret;
 	int ret, cflags = 0;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 
@@ -4608,6 +4613,9 @@ static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 	else if (force_nonblock)
 		flags |= MSG_DONTWAIT;
 
+	expected_ret = iov_iter_count(&kmsg->msg.msg_iter);
+	if (unlikely(expected_ret == MAX_RW_COUNT))
+		expected_ret += 1;
 	ret = __sys_recvmsg_sock(sock, &kmsg->msg, req->sr_msg.umsg,
 					kmsg->uaddr, flags);
 	if (force_nonblock && ret == -EAGAIN)
@@ -4621,7 +4629,7 @@ static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 	if (kmsg->free_iov)
 		kfree(kmsg->free_iov);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
-	if (ret < 0)
+	if (ret != expected_ret || (kmsg->msg.msg_flags & (MSG_TRUNC | MSG_CTRUNC)))
 		req_set_fail_links(req);
 	__io_req_complete(req, issue_flags, ret, cflags);
 	return 0;
@@ -4675,7 +4683,7 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 out_free:
 	if (req->flags & REQ_F_BUFFER_SELECTED)
 		cflags = io_put_recv_kbuf(req);
-	if (ret < 0)
+	if (ret != sr->len)
 		req_set_fail_links(req);
 	__io_req_complete(req, issue_flags, ret, cflags);
 	return 0;
-- 
2.25.1

