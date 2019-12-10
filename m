Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09FB3118D1D
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 16:57:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727330AbfLJP5t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 10:57:49 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:37782 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727178AbfLJP5s (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Dec 2019 10:57:48 -0500
Received: by mail-io1-f66.google.com with SMTP id k24so19315424ioc.4
        for <stable@vger.kernel.org>; Tue, 10 Dec 2019 07:57:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sCwLcLXQDmwoHa3uJcFN6zc4t5M1kqNoojcyizO0Yxo=;
        b=KRJCkv4vJv/P66/BIfc6th5esCC5dM6jgZJCwJo5wWx5V82CyEUDRLp5TkHe9HmV/m
         X5VE+Hj0nvdFJyarwD0AejRpx3+8utfdo+H3610q/Sbh0JLATsB0Qm8bOM0IajJML0ZN
         Nrj2FG7AqIlxYfbhjoD5UEKYL0a/NFkFHoaH81/FMOsqOdCKj6NE++0N69F89TWYGZfa
         ZH2df0ajGioxsIVb9nw62y/hDUuNVjjpz+DsyJM+URmnXMx4xoWa/kIski3N9IR0ZVih
         +GH9r9YeYW757Ty7btMIgCiqeCvcLFGet4cLLxLnBKOKu2+YdSfrgXWpenwVhQxDYvun
         NV9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sCwLcLXQDmwoHa3uJcFN6zc4t5M1kqNoojcyizO0Yxo=;
        b=aeMQI/qO3O35ezxO8El/o/tEY8qcdjAANI/SCAo+x8+PbPPZ9Ru5yLhgxCDDYsJt0E
         X3VkNhG55x5LHIlUSeu3xAux1S55uxTne+dR7nBBHbC7Kd49DmdL/EmZk4D6lHnnFTa0
         yXIqx13Sy6+GtLhxF5wBQiVDUqiVrxvKfJWGzu9p/MMr9RDa9ZNBtQ1k+sydi/fgnTRF
         ZyLOAbWSPZ3/AXByqRV+8toSPwLT9x6IdxDC3TOjJT9jbkUKE/ZI8EDBti0jBI9BWIpH
         yFaBhg//LD8xEbourFn9v4Rfb9RleB4icLOrzpN90bAfhjKfHkzgWU8g25JoNKzQmsOh
         w5OQ==
X-Gm-Message-State: APjAAAVbcJ3QbvB/675oThLThUxkmMNPtzcgxKxeR80BiLUGv3fw1Z3B
        /eQR7pQUfYMvYjiotC3U9/tO2w==
X-Google-Smtp-Source: APXvYqy9miDFPXxUaElRKRoerNLROzr2xgF8IELPq1+xq0Dt1sV8QgZR1WN4mFBdw17pUfS+4SM/fw==
X-Received: by 2002:a02:7301:: with SMTP id y1mr26722201jab.52.1575993467684;
        Tue, 10 Dec 2019 07:57:47 -0800 (PST)
Received: from x1.thefacebook.com ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id w6sm770953ioa.16.2019.12.10.07.57.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 07:57:46 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, stable@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>,
        =?UTF-8?q?=E6=9D=8E=E9=80=9A=E6=B4=B2?= <carter.li@eoitek.com>
Subject: [PATCH 01/11] io_uring: allow unbreakable links
Date:   Tue, 10 Dec 2019 08:57:32 -0700
Message-Id: <20191210155742.5844-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191210155742.5844-1-axboe@kernel.dk>
References: <20191210155742.5844-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: Pavel Begunkov <asml.silence@gmail.com>
Reported-by: 李通洲 <carter.li@eoitek.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c                 | 96 ++++++++++++++++++++---------------
 include/uapi/linux/io_uring.h |  1 +
 2 files changed, 56 insertions(+), 41 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 405be10da73d..4cda61fe67da 100644
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
@@ -2655,13 +2660,19 @@ static int io_timeout_prep(struct io_kiocb *req, struct io_async_ctx *io,
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->buf_index || sqe->len != 1)
+	if (sqe->ioprio || sqe->buf_index || sqe->len != 1) {
+		printk("1\n");
 		return -EINVAL;
-	if (sqe->off && is_timeout_link)
+	}
+	if (sqe->off && is_timeout_link) {
+		printk("2\n");
 		return -EINVAL;
+	}
 	flags = READ_ONCE(sqe->timeout_flags);
-	if (flags & ~IORING_TIMEOUT_ABS)
+	if (flags & ~IORING_TIMEOUT_ABS) {
+		printk("3\n");
 		return -EINVAL;
+	}
 
 	data = &io->timeout;
 	data->req = req;
@@ -2822,8 +2833,8 @@ static void io_async_find_and_cancel(struct io_ring_ctx *ctx,
 	spin_unlock_irqrestore(&ctx->completion_lock, flags);
 	io_cqring_ev_posted(ctx);
 
-	if (ret < 0 && (req->flags & REQ_F_LINK))
-		req->flags |= REQ_F_FAIL_LINK;
+	if (ret < 0)
+		req_set_fail_links(req);
 	io_put_req_find_next(req, nxt);
 }
 
@@ -3044,8 +3055,7 @@ static void io_wq_submit_work(struct io_wq_work **workptr)
 	io_put_req(req);
 
 	if (ret) {
-		if (req->flags & REQ_F_LINK)
-			req->flags |= REQ_F_FAIL_LINK;
+		req_set_fail_links(req);
 		io_cqring_add_event(req, ret);
 		io_put_req(req);
 	}
@@ -3179,8 +3189,7 @@ static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
 	spin_unlock_irqrestore(&ctx->completion_lock, flags);
 
 	if (prev) {
-		if (prev->flags & REQ_F_LINK)
-			prev->flags |= REQ_F_FAIL_LINK;
+		req_set_fail_links(prev);
 		io_async_find_and_cancel(ctx, req, prev->user_data, NULL,
 						-ETIME);
 		io_put_req(prev);
@@ -3273,8 +3282,7 @@ static void __io_queue_sqe(struct io_kiocb *req)
 	/* and drop final reference, if we failed */
 	if (ret) {
 		io_cqring_add_event(req, ret);
-		if (req->flags & REQ_F_LINK)
-			req->flags |= REQ_F_FAIL_LINK;
+		req_set_fail_links(req);
 		io_put_req(req);
 	}
 }
@@ -3293,8 +3301,7 @@ static void io_queue_sqe(struct io_kiocb *req)
 	if (ret) {
 		if (ret != -EIOCBQUEUED) {
 			io_cqring_add_event(req, ret);
-			if (req->flags & REQ_F_LINK)
-				req->flags |= REQ_F_FAIL_LINK;
+			req_set_fail_links(req);
 			io_double_put_req(req);
 		}
 	} else
@@ -3311,7 +3318,8 @@ static inline void io_queue_link_head(struct io_kiocb *req)
 }
 
 
-#define SQE_VALID_FLAGS	(IOSQE_FIXED_FILE|IOSQE_IO_DRAIN|IOSQE_IO_LINK)
+#define SQE_VALID_FLAGS	(IOSQE_FIXED_FILE|IOSQE_IO_DRAIN|IOSQE_IO_LINK|	\
+				IOSQE_IO_HARDLINK)
 
 static bool io_submit_sqe(struct io_kiocb *req, struct io_submit_state *state,
 			  struct io_kiocb **link)
@@ -3349,6 +3357,9 @@ static bool io_submit_sqe(struct io_kiocb *req, struct io_submit_state *state,
 		if (req->sqe->flags & IOSQE_IO_DRAIN)
 			(*link)->flags |= REQ_F_DRAIN_LINK | REQ_F_IO_DRAIN;
 
+		if (req->sqe->flags & IOSQE_IO_HARDLINK)
+			req->flags |= REQ_F_HARDLINK;
+
 		io = kmalloc(sizeof(*io), GFP_KERNEL);
 		if (!io) {
 			ret = -EAGAIN;
@@ -3358,13 +3369,16 @@ static bool io_submit_sqe(struct io_kiocb *req, struct io_submit_state *state,
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
-- 
2.24.0

