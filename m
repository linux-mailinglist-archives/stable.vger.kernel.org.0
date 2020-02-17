Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE2E161159
	for <lists+stable@lfdr.de>; Mon, 17 Feb 2020 12:48:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728757AbgBQLsK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Feb 2020 06:48:10 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:45571 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728792AbgBQLsK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Feb 2020 06:48:10 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 8689B21EF0;
        Mon, 17 Feb 2020 06:48:09 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 17 Feb 2020 06:48:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=hvqeHB
        4oUwKl/MGdoKDtc170qfA7VItu6N5kKYThV+E=; b=Ij0+o2lW9xGwbCUDIyc/Mc
        nhV71c1V7ymlV0xcSdfATdjvC2nxWH3u6F1p/WpwhYMUVH/ZJVAFbIWWOQZW+7iN
        7F/Ap2LuSBFT4dzI/eZdHKW3DwtHvpltgWJo+9Uo/5lJbXrTE9oTGX8+cnwhgioz
        XQCQuCR1Ky9KTbtHrjngNaiZyhFPR3j92kWjj1q+/qjIruFT//x823rTxgDpa7Yx
        9Ib69RETsWeiNLScMitTJpwxcehZEuIzaPrKKBhssg2+xXtNTPNWGF7Mvz2c9mW3
        2UOR6ZeVubhJYr7ysHsQuhFTgzyiFLhscj72mb9duc0kKXN0PfVWzfY0zPAMjVdA
        ==
X-ME-Sender: <xms:eX1KXktFqeh_2L4D_9b_FW4KgNPMAaXdLCGRmqlm18XgWf6vSI6gRw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrjeeigdefvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:eX1KXqEmxgbiISzYEgOGXBpbsfWJN-YBF7t4CVz3U8E7kG4y37VjQQ>
    <xmx:eX1KXnPrYxpTxb7qnbrUuHXT3XbWuCpwE2qTWY11LcjS35tdWUOTgw>
    <xmx:eX1KXhKt45msqI7jmdULN98hZZBDb0fupx1N1u3NVztERoDeQD3X-Q>
    <xmx:eX1KXgfMUIz-8tZlw93_NKGbhoHNmdvHNgw9SwVcgaZxNzpeC65dDg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id EC74B3060BE4;
        Mon, 17 Feb 2020 06:48:08 -0500 (EST)
Subject: FAILED: patch "[PATCH] io_uring: fix iovec leaks" failed to apply to 5.5-stable tree
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 Feb 2020 12:48:06 +0100
Message-ID: <158194008675180@kroah.com>
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

From 99bc4c38537d774e667d043c520914082da19abf Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Fri, 7 Feb 2020 22:04:45 +0300
Subject: [PATCH] io_uring: fix iovec leaks

Allocated iovec is freed only in io_{read,write,send,recv)(), and just
leaves it if an error occured. There are plenty of such cases:
- cancellation of non-head requests
- fail grabbing files in __io_queue_sqe()
- set REQ_F_NOWAIT and returning in __io_queue_sqe()

Add REQ_F_NEED_CLEANUP, which will force such requests with custom
allocated resourses go through cleanup handlers on put.

Cc: stable@vger.kernel.org # 5.5
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ebf3b43fb91b..5353e96029c7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -478,6 +478,7 @@ enum {
 	REQ_F_MUST_PUNT_BIT,
 	REQ_F_TIMEOUT_NOSEQ_BIT,
 	REQ_F_COMP_LOCKED_BIT,
+	REQ_F_NEED_CLEANUP_BIT,
 };
 
 enum {
@@ -516,6 +517,8 @@ enum {
 	REQ_F_TIMEOUT_NOSEQ	= BIT(REQ_F_TIMEOUT_NOSEQ_BIT),
 	/* completion under lock */
 	REQ_F_COMP_LOCKED	= BIT(REQ_F_COMP_LOCKED_BIT),
+	/* needs cleanup */
+	REQ_F_NEED_CLEANUP	= BIT(REQ_F_NEED_CLEANUP_BIT),
 };
 
 /*
@@ -748,6 +751,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 				 unsigned nr_args);
 static int io_grab_files(struct io_kiocb *req);
 static void io_ring_file_ref_flush(struct fixed_file_data *data);
+static void io_cleanup_req(struct io_kiocb *req);
 
 static struct kmem_cache *req_cachep;
 
@@ -1235,6 +1239,9 @@ static void __io_free_req(struct io_kiocb *req)
 {
 	__io_req_aux_free(req);
 
+	if (req->flags & REQ_F_NEED_CLEANUP)
+		io_cleanup_req(req);
+
 	if (req->flags & REQ_F_INFLIGHT) {
 		struct io_ring_ctx *ctx = req->ctx;
 		unsigned long flags;
@@ -2128,6 +2135,8 @@ static void io_req_map_rw(struct io_kiocb *req, ssize_t io_size,
 		req->io->rw.iov = req->io->rw.fast_iov;
 		memcpy(req->io->rw.iov, fast_iov,
 			sizeof(struct iovec) * iter->nr_segs);
+	} else {
+		req->flags |= REQ_F_NEED_CLEANUP;
 	}
 }
 
@@ -2238,6 +2247,7 @@ static int io_read(struct io_kiocb *req, struct io_kiocb **nxt,
 	}
 out_free:
 	kfree(iovec);
+	req->flags &= ~REQ_F_NEED_CLEANUP;
 	return ret;
 }
 
@@ -2342,6 +2352,7 @@ static int io_write(struct io_kiocb *req, struct io_kiocb **nxt,
 		}
 	}
 out_free:
+	req->flags &= ~REQ_F_NEED_CLEANUP;
 	kfree(iovec);
 	return ret;
 }
@@ -2948,6 +2959,7 @@ static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 #if defined(CONFIG_NET)
 	struct io_sr_msg *sr = &req->sr_msg;
 	struct io_async_ctx *io = req->io;
+	int ret;
 
 	sr->msg_flags = READ_ONCE(sqe->msg_flags);
 	sr->msg = u64_to_user_ptr(READ_ONCE(sqe->addr));
@@ -2957,8 +2969,11 @@ static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return 0;
 
 	io->msg.iov = io->msg.fast_iov;
-	return sendmsg_copy_msghdr(&io->msg.msg, sr->msg, sr->msg_flags,
+	ret = sendmsg_copy_msghdr(&io->msg.msg, sr->msg, sr->msg_flags,
 					&io->msg.iov);
+	if (!ret)
+		req->flags |= REQ_F_NEED_CLEANUP;
+	return ret;
 #else
 	return -EOPNOTSUPP;
 #endif
@@ -3016,6 +3031,7 @@ static int io_sendmsg(struct io_kiocb *req, struct io_kiocb **nxt,
 					kfree(kmsg->iov);
 				return -ENOMEM;
 			}
+			req->flags |= REQ_F_NEED_CLEANUP;
 			memcpy(&req->io->msg, &io.msg, sizeof(io.msg));
 			return -EAGAIN;
 		}
@@ -3025,6 +3041,7 @@ static int io_sendmsg(struct io_kiocb *req, struct io_kiocb **nxt,
 
 	if (kmsg && kmsg->iov != kmsg->fast_iov)
 		kfree(kmsg->iov);
+	req->flags &= ~REQ_F_NEED_CLEANUP;
 	io_cqring_add_event(req, ret);
 	if (ret < 0)
 		req_set_fail_links(req);
@@ -3092,6 +3109,7 @@ static int io_recvmsg_prep(struct io_kiocb *req,
 #if defined(CONFIG_NET)
 	struct io_sr_msg *sr = &req->sr_msg;
 	struct io_async_ctx *io = req->io;
+	int ret;
 
 	sr->msg_flags = READ_ONCE(sqe->msg_flags);
 	sr->msg = u64_to_user_ptr(READ_ONCE(sqe->addr));
@@ -3101,8 +3119,11 @@ static int io_recvmsg_prep(struct io_kiocb *req,
 		return 0;
 
 	io->msg.iov = io->msg.fast_iov;
-	return recvmsg_copy_msghdr(&io->msg.msg, sr->msg, sr->msg_flags,
+	ret = recvmsg_copy_msghdr(&io->msg.msg, sr->msg, sr->msg_flags,
 					&io->msg.uaddr, &io->msg.iov);
+	if (!ret)
+		req->flags |= REQ_F_NEED_CLEANUP;
+	return ret;
 #else
 	return -EOPNOTSUPP;
 #endif
@@ -3163,6 +3184,7 @@ static int io_recvmsg(struct io_kiocb *req, struct io_kiocb **nxt,
 				return -ENOMEM;
 			}
 			memcpy(&req->io->msg, &io.msg, sizeof(io.msg));
+			req->flags |= REQ_F_NEED_CLEANUP;
 			return -EAGAIN;
 		}
 		if (ret == -ERESTARTSYS)
@@ -3171,6 +3193,7 @@ static int io_recvmsg(struct io_kiocb *req, struct io_kiocb **nxt,
 
 	if (kmsg && kmsg->iov != kmsg->fast_iov)
 		kfree(kmsg->iov);
+	req->flags &= ~REQ_F_NEED_CLEANUP;
 	io_cqring_add_event(req, ret);
 	if (ret < 0)
 		req_set_fail_links(req);
@@ -4181,6 +4204,30 @@ static int io_req_defer(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return -EIOCBQUEUED;
 }
 
+static void io_cleanup_req(struct io_kiocb *req)
+{
+	struct io_async_ctx *io = req->io;
+
+	switch (req->opcode) {
+	case IORING_OP_READV:
+	case IORING_OP_READ_FIXED:
+	case IORING_OP_READ:
+	case IORING_OP_WRITEV:
+	case IORING_OP_WRITE_FIXED:
+	case IORING_OP_WRITE:
+		if (io->rw.iov != io->rw.fast_iov)
+			kfree(io->rw.iov);
+		break;
+	case IORING_OP_SENDMSG:
+	case IORING_OP_RECVMSG:
+		if (io->msg.iov != io->msg.fast_iov)
+			kfree(io->msg.iov);
+		break;
+	}
+
+	req->flags &= ~REQ_F_NEED_CLEANUP;
+}
+
 static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			struct io_kiocb **nxt, bool force_nonblock)
 {

