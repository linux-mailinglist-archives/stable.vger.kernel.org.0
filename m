Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E648F11F74F
	for <lists+stable@lfdr.de>; Sun, 15 Dec 2019 12:02:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbfLOLC1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 06:02:27 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:47659 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726083AbfLOLC0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Dec 2019 06:02:26 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 400B965F;
        Sun, 15 Dec 2019 06:02:24 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 15 Dec 2019 06:02:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=D6jsPA
        pqdSpzVOZ4DhosCJPmxyYR/k7gBUx6QjxKO+U=; b=V4ZAnWuTyOHAxZEdvcrQXE
        3cL/1dK2zeFHPZNeQs+VohRJ54gB7vgbT4G3ZUzIrhJoYRxv4zpO5M3sD9Cv3mF5
        SkBADYNArfduk9dot5M/9vTcObMvbVDwMWTHtnTQV/QmN/L1FuLiaqQw9IEBMmsg
        SfX5q7+0FqEy6+YIt3OIR4yEKbqujoBwE3e6P4afoALRjJJ74pUk8mrTD5AtDk06
        FAsNYmOg9jML8oSe6zgVVy9LbrcKDYcnhTkmupAvti4qKdRLgiXajpZ20Pq96ANz
        hi5/EbJeM3uU8ktYT/tF0ksOjHVL86jnnF8n5LCs68pHqGrR2asFI512yGAwHvqg
        ==
X-ME-Sender: <xms:vxL2XfChd5ZqG3-Rs0-4fX68fgEeE0pGTG9n8PcUHgCvmchGxAlHuQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddtfedgvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:wBL2XVxIT8Bt7oYLIqSLdqX0FRTJvvZAEfL_sfGk4IE65xOmN7a5jQ>
    <xmx:wBL2XTcqwxPYZ-AZwWIOA3bej4RbL7mTRywjNz8UEIn4wijjkHjP5w>
    <xmx:wBL2XVpIKJFCpezRBewyCf3EV6zMB39jpzQMKVQc3yJ_HmEpkyTb3w>
    <xmx:wBL2Xdvq3PXah5vjl4f1uD2ARzjO_ie5RPT_7sulC6FNBD6Bjzg7CA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8FBF28005B;
        Sun, 15 Dec 2019 06:02:23 -0500 (EST)
Subject: FAILED: patch "[PATCH] io_uring: allow unbreakable links" failed to apply to 5.4-stable tree
To:     axboe@kernel.dk, asml.silence@gmail.com, carter.li@eoitek.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 15 Dec 2019 12:02:21 +0100
Message-ID: <15764077414946@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4e88d6e7793f2f445f43bd608828541d7f43b608 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Sat, 7 Dec 2019 20:59:47 -0700
Subject: [PATCH] io_uring: allow unbreakable links
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Some commands will invariably end in a failure in the sense that the
completion result will be less than zero. One such example is timeouts
that don't have a completion count set, they will always complete with
-ETIME unless cancelled.

For linked commands, we sever links and fail the rest of the chain if
the result is less than zero. Since we have commands where we know that
will happen, add IOSQE_IO_HARDLINK as a stronger link that doesn't sever
regardless of the completion result. Note that the link will still sever
if we fail submitting the parent request, hard links are only resilient
in the presence of completion results for requests that did submit
correctly.

Cc: stable@vger.kernel.org # v5.4
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Reported-by: 李通洲 <carter.li@eoitek.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 405be10da73d..040e6c11ff37 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -377,6 +377,7 @@ struct io_kiocb {
 #define REQ_F_TIMEOUT_NOSEQ	8192	/* no timeout sequence */
 #define REQ_F_INFLIGHT		16384	/* on inflight list */
 #define REQ_F_COMP_LOCKED	32768	/* completion under lock */
+#define REQ_F_HARDLINK		65536	/* doesn't sever on completion < 0 */
 	u64			user_data;
 	u32			result;
 	u32			sequence;
@@ -1292,6 +1293,12 @@ static void kiocb_end_write(struct io_kiocb *req)
 	file_end_write(req->file);
 }
 
+static inline void req_set_fail_links(struct io_kiocb *req)
+{
+	if ((req->flags & (REQ_F_LINK | REQ_F_HARDLINK)) == REQ_F_LINK)
+		req->flags |= REQ_F_FAIL_LINK;
+}
+
 static void io_complete_rw_common(struct kiocb *kiocb, long res)
 {
 	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw);
@@ -1299,8 +1306,8 @@ static void io_complete_rw_common(struct kiocb *kiocb, long res)
 	if (kiocb->ki_flags & IOCB_WRITE)
 		kiocb_end_write(req);
 
-	if ((req->flags & REQ_F_LINK) && res != req->result)
-		req->flags |= REQ_F_FAIL_LINK;
+	if (res != req->result)
+		req_set_fail_links(req);
 	io_cqring_add_event(req, res);
 }
 
@@ -1330,8 +1337,8 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
 	if (kiocb->ki_flags & IOCB_WRITE)
 		kiocb_end_write(req);
 
-	if ((req->flags & REQ_F_LINK) && res != req->result)
-		req->flags |= REQ_F_FAIL_LINK;
+	if (res != req->result)
+		req_set_fail_links(req);
 	req->result = res;
 	if (res != -EAGAIN)
 		req->flags |= REQ_F_IOPOLL_COMPLETED;
@@ -1956,8 +1963,8 @@ static int io_fsync(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 				end > 0 ? end : LLONG_MAX,
 				fsync_flags & IORING_FSYNC_DATASYNC);
 
-	if (ret < 0 && (req->flags & REQ_F_LINK))
-		req->flags |= REQ_F_FAIL_LINK;
+	if (ret < 0)
+		req_set_fail_links(req);
 	io_cqring_add_event(req, ret);
 	io_put_req_find_next(req, nxt);
 	return 0;
@@ -2003,8 +2010,8 @@ static int io_sync_file_range(struct io_kiocb *req,
 
 	ret = sync_file_range(req->rw.ki_filp, sqe_off, sqe_len, flags);
 
-	if (ret < 0 && (req->flags & REQ_F_LINK))
-		req->flags |= REQ_F_FAIL_LINK;
+	if (ret < 0)
+		req_set_fail_links(req);
 	io_cqring_add_event(req, ret);
 	io_put_req_find_next(req, nxt);
 	return 0;
@@ -2079,8 +2086,8 @@ static int io_sendmsg(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 
 out:
 	io_cqring_add_event(req, ret);
-	if (ret < 0 && (req->flags & REQ_F_LINK))
-		req->flags |= REQ_F_FAIL_LINK;
+	if (ret < 0)
+		req_set_fail_links(req);
 	io_put_req_find_next(req, nxt);
 	return 0;
 #else
@@ -2161,8 +2168,8 @@ static int io_recvmsg(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 
 out:
 	io_cqring_add_event(req, ret);
-	if (ret < 0 && (req->flags & REQ_F_LINK))
-		req->flags |= REQ_F_FAIL_LINK;
+	if (ret < 0)
+		req_set_fail_links(req);
 	io_put_req_find_next(req, nxt);
 	return 0;
 #else
@@ -2196,8 +2203,8 @@ static int io_accept(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	}
 	if (ret == -ERESTARTSYS)
 		ret = -EINTR;
-	if (ret < 0 && (req->flags & REQ_F_LINK))
-		req->flags |= REQ_F_FAIL_LINK;
+	if (ret < 0)
+		req_set_fail_links(req);
 	io_cqring_add_event(req, ret);
 	io_put_req_find_next(req, nxt);
 	return 0;
@@ -2263,8 +2270,8 @@ static int io_connect(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	if (ret == -ERESTARTSYS)
 		ret = -EINTR;
 out:
-	if (ret < 0 && (req->flags & REQ_F_LINK))
-		req->flags |= REQ_F_FAIL_LINK;
+	if (ret < 0)
+		req_set_fail_links(req);
 	io_cqring_add_event(req, ret);
 	io_put_req_find_next(req, nxt);
 	return 0;
@@ -2340,8 +2347,8 @@ static int io_poll_remove(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	spin_unlock_irq(&ctx->completion_lock);
 
 	io_cqring_add_event(req, ret);
-	if (ret < 0 && (req->flags & REQ_F_LINK))
-		req->flags |= REQ_F_FAIL_LINK;
+	if (ret < 0)
+		req_set_fail_links(req);
 	io_put_req(req);
 	return 0;
 }
@@ -2399,8 +2406,8 @@ static void io_poll_complete_work(struct io_wq_work **workptr)
 
 	io_cqring_ev_posted(ctx);
 
-	if (ret < 0 && req->flags & REQ_F_LINK)
-		req->flags |= REQ_F_FAIL_LINK;
+	if (ret < 0)
+		req_set_fail_links(req);
 	io_put_req_find_next(req, &nxt);
 	if (nxt)
 		*workptr = &nxt->work;
@@ -2582,8 +2589,7 @@ static enum hrtimer_restart io_timeout_fn(struct hrtimer *timer)
 	spin_unlock_irqrestore(&ctx->completion_lock, flags);
 
 	io_cqring_ev_posted(ctx);
-	if (req->flags & REQ_F_LINK)
-		req->flags |= REQ_F_FAIL_LINK;
+	req_set_fail_links(req);
 	io_put_req(req);
 	return HRTIMER_NORESTART;
 }
@@ -2608,8 +2614,7 @@ static int io_timeout_cancel(struct io_ring_ctx *ctx, __u64 user_data)
 	if (ret == -1)
 		return -EALREADY;
 
-	if (req->flags & REQ_F_LINK)
-		req->flags |= REQ_F_FAIL_LINK;
+	req_set_fail_links(req);
 	io_cqring_fill_event(req, -ECANCELED);
 	io_put_req(req);
 	return 0;
@@ -2640,8 +2645,8 @@ static int io_timeout_remove(struct io_kiocb *req,
 	io_commit_cqring(ctx);
 	spin_unlock_irq(&ctx->completion_lock);
 	io_cqring_ev_posted(ctx);
-	if (ret < 0 && req->flags & REQ_F_LINK)
-		req->flags |= REQ_F_FAIL_LINK;
+	if (ret < 0)
+		req_set_fail_links(req);
 	io_put_req(req);
 	return 0;
 }
@@ -2822,8 +2827,8 @@ static void io_async_find_and_cancel(struct io_ring_ctx *ctx,
 	spin_unlock_irqrestore(&ctx->completion_lock, flags);
 	io_cqring_ev_posted(ctx);
 
-	if (ret < 0 && (req->flags & REQ_F_LINK))
-		req->flags |= REQ_F_FAIL_LINK;
+	if (ret < 0)
+		req_set_fail_links(req);
 	io_put_req_find_next(req, nxt);
 }
 
@@ -3044,8 +3049,7 @@ static void io_wq_submit_work(struct io_wq_work **workptr)
 	io_put_req(req);
 
 	if (ret) {
-		if (req->flags & REQ_F_LINK)
-			req->flags |= REQ_F_FAIL_LINK;
+		req_set_fail_links(req);
 		io_cqring_add_event(req, ret);
 		io_put_req(req);
 	}
@@ -3179,8 +3183,7 @@ static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
 	spin_unlock_irqrestore(&ctx->completion_lock, flags);
 
 	if (prev) {
-		if (prev->flags & REQ_F_LINK)
-			prev->flags |= REQ_F_FAIL_LINK;
+		req_set_fail_links(prev);
 		io_async_find_and_cancel(ctx, req, prev->user_data, NULL,
 						-ETIME);
 		io_put_req(prev);
@@ -3273,8 +3276,7 @@ static void __io_queue_sqe(struct io_kiocb *req)
 	/* and drop final reference, if we failed */
 	if (ret) {
 		io_cqring_add_event(req, ret);
-		if (req->flags & REQ_F_LINK)
-			req->flags |= REQ_F_FAIL_LINK;
+		req_set_fail_links(req);
 		io_put_req(req);
 	}
 }
@@ -3293,8 +3295,7 @@ static void io_queue_sqe(struct io_kiocb *req)
 	if (ret) {
 		if (ret != -EIOCBQUEUED) {
 			io_cqring_add_event(req, ret);
-			if (req->flags & REQ_F_LINK)
-				req->flags |= REQ_F_FAIL_LINK;
+			req_set_fail_links(req);
 			io_double_put_req(req);
 		}
 	} else
@@ -3311,7 +3312,8 @@ static inline void io_queue_link_head(struct io_kiocb *req)
 }
 
 
-#define SQE_VALID_FLAGS	(IOSQE_FIXED_FILE|IOSQE_IO_DRAIN|IOSQE_IO_LINK)
+#define SQE_VALID_FLAGS	(IOSQE_FIXED_FILE|IOSQE_IO_DRAIN|IOSQE_IO_LINK|	\
+				IOSQE_IO_HARDLINK)
 
 static bool io_submit_sqe(struct io_kiocb *req, struct io_submit_state *state,
 			  struct io_kiocb **link)
@@ -3349,6 +3351,9 @@ static bool io_submit_sqe(struct io_kiocb *req, struct io_submit_state *state,
 		if (req->sqe->flags & IOSQE_IO_DRAIN)
 			(*link)->flags |= REQ_F_DRAIN_LINK | REQ_F_IO_DRAIN;
 
+		if (req->sqe->flags & IOSQE_IO_HARDLINK)
+			req->flags |= REQ_F_HARDLINK;
+
 		io = kmalloc(sizeof(*io), GFP_KERNEL);
 		if (!io) {
 			ret = -EAGAIN;
@@ -3358,13 +3363,16 @@ static bool io_submit_sqe(struct io_kiocb *req, struct io_submit_state *state,
 		ret = io_req_defer_prep(req, io);
 		if (ret) {
 			kfree(io);
+			/* fail even hard links since we don't submit */
 			prev->flags |= REQ_F_FAIL_LINK;
 			goto err_req;
 		}
 		trace_io_uring_link(ctx, req, prev);
 		list_add_tail(&req->link_list, &prev->link_list);
-	} else if (req->sqe->flags & IOSQE_IO_LINK) {
+	} else if (req->sqe->flags & (IOSQE_IO_LINK|IOSQE_IO_HARDLINK)) {
 		req->flags |= REQ_F_LINK;
+		if (req->sqe->flags & IOSQE_IO_HARDLINK)
+			req->flags |= REQ_F_HARDLINK;
 
 		INIT_LIST_HEAD(&req->link_list);
 		*link = req;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index eabccb46edd1..ea231366f5fd 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -48,6 +48,7 @@ struct io_uring_sqe {
 #define IOSQE_FIXED_FILE	(1U << 0)	/* use fixed fileset */
 #define IOSQE_IO_DRAIN		(1U << 1)	/* issue after inflight IO */
 #define IOSQE_IO_LINK		(1U << 2)	/* links next sqe */
+#define IOSQE_IO_HARDLINK	(1U << 3)	/* like LINK, but stronger */
 
 /*
  * io_uring_setup() flags

