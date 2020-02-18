Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E43C16322C
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 21:06:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbgBRUGT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 15:06:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:39834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728376AbgBRUAd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 15:00:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB56D2465D;
        Tue, 18 Feb 2020 20:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582056032;
        bh=AvAoxOwl8RH6toj6B/bYYgQhwV9RU4hQAOceSW9wlZs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eSxlsQ+LgGoIiipaMqUUi0mXDU6fh6rUx0cMyJqESFWSWd1gKPVy5g3GThWkEMFVP
         sq6N4L88PTOuBQI4J8HDQP4PWTTIai5/A71cUe6EGMLXjvnZGppodUO6/oo8JXUYe9
         kjrz8h60ZjV/u9dMnBazmaSvBwTI1Reu2P/PKl3U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.5 01/80] io_uring: fix deferred req iovec leak
Date:   Tue, 18 Feb 2020 20:54:22 +0100
Message-Id: <20200218190432.175397429@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200218190432.043414522@linuxfoundation.org>
References: <20200218190432.043414522@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit 1e95081cb5b4cf77065d37866f57cf3c90a3df78 upstream.

After defer, a request will be prepared, that includes allocating iovec
if needed, and then submitted through io_wq_submit_work() but not custom
handler (e.g. io_rw_async()/io_sendrecv_async()). However, it'll leak
iovec, as it's in io-wq and the code goes as follows:

io_read() {
	if (!io_wq_current_is_worker())
		kfree(iovec);
}

Put all deallocation logic in io_{read,write,send,recv}(), which will
leave the memory, if going async with -EAGAIN.

It also fixes a leak after failed io_alloc_async_ctx() in
io_{recv,send}_msg().

Cc: stable@vger.kernel.org # 5.5
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |   47 ++++++++++++-----------------------------------
 1 file changed, 12 insertions(+), 35 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1786,17 +1786,6 @@ static int io_alloc_async_ctx(struct io_
 	return req->io == NULL;
 }
 
-static void io_rw_async(struct io_wq_work **workptr)
-{
-	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
-	struct iovec *iov = NULL;
-
-	if (req->io->rw.iov != req->io->rw.fast_iov)
-		iov = req->io->rw.iov;
-	io_wq_submit_work(workptr);
-	kfree(iov);
-}
-
 static int io_setup_async_rw(struct io_kiocb *req, ssize_t io_size,
 			     struct iovec *iovec, struct iovec *fast_iov,
 			     struct iov_iter *iter)
@@ -1810,7 +1799,6 @@ static int io_setup_async_rw(struct io_k
 
 		io_req_map_rw(req, io_size, iovec, fast_iov, iter);
 	}
-	req->work.func = io_rw_async;
 	return 0;
 }
 
@@ -1897,8 +1885,7 @@ copy_iov:
 		}
 	}
 out_free:
-	if (!io_wq_current_is_worker())
-		kfree(iovec);
+	kfree(iovec);
 	return ret;
 }
 
@@ -2003,8 +1990,7 @@ copy_iov:
 		}
 	}
 out_free:
-	if (!io_wq_current_is_worker())
-		kfree(iovec);
+	kfree(iovec);
 	return ret;
 }
 
@@ -2174,19 +2160,6 @@ static int io_sync_file_range(struct io_
 	return 0;
 }
 
-#if defined(CONFIG_NET)
-static void io_sendrecv_async(struct io_wq_work **workptr)
-{
-	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
-	struct iovec *iov = NULL;
-
-	if (req->io->rw.iov != req->io->rw.fast_iov)
-		iov = req->io->msg.iov;
-	io_wq_submit_work(workptr);
-	kfree(iov);
-}
-#endif
-
 static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 #if defined(CONFIG_NET)
@@ -2254,17 +2227,19 @@ static int io_sendmsg(struct io_kiocb *r
 		if (force_nonblock && ret == -EAGAIN) {
 			if (req->io)
 				return -EAGAIN;
-			if (io_alloc_async_ctx(req))
+			if (io_alloc_async_ctx(req)) {
+				if (kmsg && kmsg->iov != kmsg->fast_iov)
+					kfree(kmsg->iov);
 				return -ENOMEM;
+			}
 			memcpy(&req->io->msg, &io.msg, sizeof(io.msg));
-			req->work.func = io_sendrecv_async;
 			return -EAGAIN;
 		}
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
 	}
 
-	if (!io_wq_current_is_worker() && kmsg && kmsg->iov != kmsg->fast_iov)
+	if (kmsg && kmsg->iov != kmsg->fast_iov)
 		kfree(kmsg->iov);
 	io_cqring_add_event(req, ret);
 	if (ret < 0)
@@ -2346,17 +2321,19 @@ static int io_recvmsg(struct io_kiocb *r
 		if (force_nonblock && ret == -EAGAIN) {
 			if (req->io)
 				return -EAGAIN;
-			if (io_alloc_async_ctx(req))
+			if (io_alloc_async_ctx(req)) {
+				if (kmsg && kmsg->iov != kmsg->fast_iov)
+					kfree(kmsg->iov);
 				return -ENOMEM;
+			}
 			memcpy(&req->io->msg, &io.msg, sizeof(io.msg));
-			req->work.func = io_sendrecv_async;
 			return -EAGAIN;
 		}
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
 	}
 
-	if (!io_wq_current_is_worker() && kmsg && kmsg->iov != kmsg->fast_iov)
+	if (kmsg && kmsg->iov != kmsg->fast_iov)
 		kfree(kmsg->iov);
 	io_cqring_add_event(req, ret);
 	if (ret < 0)


