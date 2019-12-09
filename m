Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 798F6117B58
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 00:19:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbfLIXTA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Dec 2019 18:19:00 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:39669 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726592AbfLIXS7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Dec 2019 18:18:59 -0500
Received: by mail-pl1-f193.google.com with SMTP id o9so6444962plk.6
        for <stable@vger.kernel.org>; Mon, 09 Dec 2019 15:18:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=waapf5h2uHYJbaaBf0r0YT7gMdHycWDpDiHFiRGSW34=;
        b=Guv3HUP7yHsywFuiDOkyJrD9fzUkoyO/ADhEPycOjmM0ZdIYnxiRMJGN1xYxC57ko/
         lFxR6Usyy6/oK9ZIZnxzsvI8b1p2vNzoRGQVJQWh8LzOMjQ5kDZVIxyXIH2SWrTytyL/
         9J1NDUAC9TPgtPUqIL6F9FniSnwrVSHLxGLupgobrvoCQmria8LZFnpWspOoNtJatPL2
         CtHGUpWf8ZTG89aG3umbUZVx7lawt7Tt/MRxdw+vA9XM/XSRgwYwgDRjOCASh0/k0Rrk
         4r84JDoz4G/E1WLgCYqKQHjgAF9gXzu1V53OGG80neMAYrYMcIW8PoUWt7V930egKOdv
         9mUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=waapf5h2uHYJbaaBf0r0YT7gMdHycWDpDiHFiRGSW34=;
        b=TlBGMuabdDN6533DXRmnvEDKIlvNFLUgXVRnwlynbgEPA4kWa4yNTyorbk4kpchz2w
         vn1TawBnkzY++Q5Rw50YanyJL5PCJRlj6HSUd/70rpDiaSAY2NMshv0RfANYNBI9TpL0
         QZI+568d6QpDebRjOc80goLRo2u2yhtH94+d51o5LgluVs/LTBIRaRxeQd4FiGRNaZ0X
         3h2IDva5M6qYcBGZPAhtkuYDUSNl40Pih1Lm4QaKg0Bfs7rTPluhKgkL/BdKHmZzZZPq
         ET0nVzC1avfGzB3uT0ZqvzCV2i2Qh6naj7Omt73QwWJ5/+xQWibKcu0PrdNV6TJd6KVR
         uUpA==
X-Gm-Message-State: APjAAAXqgSLtW13Wb3mH8c9QtfdEkcLiqs7F7+adhBxCodexF30MT2uM
        N+xLahtcKOIh2moBejk33Mr0idrgQnA=
X-Google-Smtp-Source: APXvYqwnxMCRUMNeoefltm4u3IChuj9z3XEUW0aZxp/fnNUSJalgBS92Gyj2JFHgWdIkKVYF5CVvSw==
X-Received: by 2002:a17:902:70cb:: with SMTP id l11mr32569613plt.216.1575933538517;
        Mon, 09 Dec 2019 15:18:58 -0800 (PST)
Received: from x1.thefacebook.com ([2620:10d:c090:180::e5cf])
        by smtp.gmail.com with ESMTPSA id 16sm515662pfh.182.2019.12.09.15.18.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2019 15:18:57 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, stable@vger.kernel.org,
        =?UTF-8?q?=E6=9D=8E=E9=80=9A=E6=B4=B2?= <carter.li@eoitek.com>
Subject: [PATCH 1/4] io_uring: allow unbreakable links
Date:   Mon,  9 Dec 2019 16:18:51 -0700
Message-Id: <20191209231854.3767-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191209231854.3767-1-axboe@kernel.dk>
References: <20191209231854.3767-1-axboe@kernel.dk>
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
Reported-by: 李通洲 <carter.li@eoitek.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c                 | 54 +++++++++++++++++++++--------------
 include/uapi/linux/io_uring.h |  1 +
 2 files changed, 33 insertions(+), 22 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 405be10da73d..662404854571 100644
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
@@ -941,7 +942,7 @@ static void io_req_link_next(struct io_kiocb *req, struct io_kiocb **nxtptr)
 
 		list_del_init(&req->link_list);
 		if (!list_empty(&nxt->link_list))
-			nxt->flags |= REQ_F_LINK;
+			nxt->flags |= req->flags & (REQ_F_LINK|REQ_F_HARDLINK);
 		*nxtptr = nxt;
 		break;
 	}
@@ -1292,6 +1293,11 @@ static void kiocb_end_write(struct io_kiocb *req)
 	file_end_write(req->file);
 }
 
+static inline bool req_fail_links(struct io_kiocb *req)
+{
+	return (req->flags & (REQ_F_LINK | REQ_F_HARDLINK)) == REQ_F_LINK;
+}
+
 static void io_complete_rw_common(struct kiocb *kiocb, long res)
 {
 	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw);
@@ -1299,7 +1305,7 @@ static void io_complete_rw_common(struct kiocb *kiocb, long res)
 	if (kiocb->ki_flags & IOCB_WRITE)
 		kiocb_end_write(req);
 
-	if ((req->flags & REQ_F_LINK) && res != req->result)
+	if (res != req->result && req_fail_links(req))
 		req->flags |= REQ_F_FAIL_LINK;
 	io_cqring_add_event(req, res);
 }
@@ -1330,7 +1336,7 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
 	if (kiocb->ki_flags & IOCB_WRITE)
 		kiocb_end_write(req);
 
-	if ((req->flags & REQ_F_LINK) && res != req->result)
+	if (res != req->result && req_fail_links(req))
 		req->flags |= REQ_F_FAIL_LINK;
 	req->result = res;
 	if (res != -EAGAIN)
@@ -1956,7 +1962,7 @@ static int io_fsync(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 				end > 0 ? end : LLONG_MAX,
 				fsync_flags & IORING_FSYNC_DATASYNC);
 
-	if (ret < 0 && (req->flags & REQ_F_LINK))
+	if (ret < 0 && req_fail_links(req))
 		req->flags |= REQ_F_FAIL_LINK;
 	io_cqring_add_event(req, ret);
 	io_put_req_find_next(req, nxt);
@@ -2003,7 +2009,7 @@ static int io_sync_file_range(struct io_kiocb *req,
 
 	ret = sync_file_range(req->rw.ki_filp, sqe_off, sqe_len, flags);
 
-	if (ret < 0 && (req->flags & REQ_F_LINK))
+	if (ret < 0 && req_fail_links(req))
 		req->flags |= REQ_F_FAIL_LINK;
 	io_cqring_add_event(req, ret);
 	io_put_req_find_next(req, nxt);
@@ -2079,7 +2085,7 @@ static int io_sendmsg(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 
 out:
 	io_cqring_add_event(req, ret);
-	if (ret < 0 && (req->flags & REQ_F_LINK))
+	if (ret < 0 && req_fail_links(req))
 		req->flags |= REQ_F_FAIL_LINK;
 	io_put_req_find_next(req, nxt);
 	return 0;
@@ -2161,7 +2167,7 @@ static int io_recvmsg(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 
 out:
 	io_cqring_add_event(req, ret);
-	if (ret < 0 && (req->flags & REQ_F_LINK))
+	if (ret < 0 && req_fail_links(req))
 		req->flags |= REQ_F_FAIL_LINK;
 	io_put_req_find_next(req, nxt);
 	return 0;
@@ -2196,7 +2202,7 @@ static int io_accept(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	}
 	if (ret == -ERESTARTSYS)
 		ret = -EINTR;
-	if (ret < 0 && (req->flags & REQ_F_LINK))
+	if (ret < 0 && req_fail_links(req))
 		req->flags |= REQ_F_FAIL_LINK;
 	io_cqring_add_event(req, ret);
 	io_put_req_find_next(req, nxt);
@@ -2263,7 +2269,7 @@ static int io_connect(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	if (ret == -ERESTARTSYS)
 		ret = -EINTR;
 out:
-	if (ret < 0 && (req->flags & REQ_F_LINK))
+	if (ret < 0 && req_fail_links(req))
 		req->flags |= REQ_F_FAIL_LINK;
 	io_cqring_add_event(req, ret);
 	io_put_req_find_next(req, nxt);
@@ -2340,7 +2346,7 @@ static int io_poll_remove(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	spin_unlock_irq(&ctx->completion_lock);
 
 	io_cqring_add_event(req, ret);
-	if (ret < 0 && (req->flags & REQ_F_LINK))
+	if (ret < 0 && req_fail_links(req))
 		req->flags |= REQ_F_FAIL_LINK;
 	io_put_req(req);
 	return 0;
@@ -2399,7 +2405,7 @@ static void io_poll_complete_work(struct io_wq_work **workptr)
 
 	io_cqring_ev_posted(ctx);
 
-	if (ret < 0 && req->flags & REQ_F_LINK)
+	if (ret < 0 && req_fail_links(req))
 		req->flags |= REQ_F_FAIL_LINK;
 	io_put_req_find_next(req, &nxt);
 	if (nxt)
@@ -2582,7 +2588,7 @@ static enum hrtimer_restart io_timeout_fn(struct hrtimer *timer)
 	spin_unlock_irqrestore(&ctx->completion_lock, flags);
 
 	io_cqring_ev_posted(ctx);
-	if (req->flags & REQ_F_LINK)
+	if (req_fail_links(req))
 		req->flags |= REQ_F_FAIL_LINK;
 	io_put_req(req);
 	return HRTIMER_NORESTART;
@@ -2608,7 +2614,7 @@ static int io_timeout_cancel(struct io_ring_ctx *ctx, __u64 user_data)
 	if (ret == -1)
 		return -EALREADY;
 
-	if (req->flags & REQ_F_LINK)
+	if (req_fail_links(req))
 		req->flags |= REQ_F_FAIL_LINK;
 	io_cqring_fill_event(req, -ECANCELED);
 	io_put_req(req);
@@ -2640,7 +2646,7 @@ static int io_timeout_remove(struct io_kiocb *req,
 	io_commit_cqring(ctx);
 	spin_unlock_irq(&ctx->completion_lock);
 	io_cqring_ev_posted(ctx);
-	if (ret < 0 && req->flags & REQ_F_LINK)
+	if (ret < 0 && req_fail_links(req))
 		req->flags |= REQ_F_FAIL_LINK;
 	io_put_req(req);
 	return 0;
@@ -2822,7 +2828,7 @@ static void io_async_find_and_cancel(struct io_ring_ctx *ctx,
 	spin_unlock_irqrestore(&ctx->completion_lock, flags);
 	io_cqring_ev_posted(ctx);
 
-	if (ret < 0 && (req->flags & REQ_F_LINK))
+	if (ret < 0 && req_fail_links(req))
 		req->flags |= REQ_F_FAIL_LINK;
 	io_put_req_find_next(req, nxt);
 }
@@ -3044,7 +3050,7 @@ static void io_wq_submit_work(struct io_wq_work **workptr)
 	io_put_req(req);
 
 	if (ret) {
-		if (req->flags & REQ_F_LINK)
+		if (req_fail_links(req))
 			req->flags |= REQ_F_FAIL_LINK;
 		io_cqring_add_event(req, ret);
 		io_put_req(req);
@@ -3179,7 +3185,7 @@ static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
 	spin_unlock_irqrestore(&ctx->completion_lock, flags);
 
 	if (prev) {
-		if (prev->flags & REQ_F_LINK)
+		if (req_fail_links(prev))
 			prev->flags |= REQ_F_FAIL_LINK;
 		io_async_find_and_cancel(ctx, req, prev->user_data, NULL,
 						-ETIME);
@@ -3273,7 +3279,7 @@ static void __io_queue_sqe(struct io_kiocb *req)
 	/* and drop final reference, if we failed */
 	if (ret) {
 		io_cqring_add_event(req, ret);
-		if (req->flags & REQ_F_LINK)
+		if (req_fail_links(req))
 			req->flags |= REQ_F_FAIL_LINK;
 		io_put_req(req);
 	}
@@ -3293,7 +3299,7 @@ static void io_queue_sqe(struct io_kiocb *req)
 	if (ret) {
 		if (ret != -EIOCBQUEUED) {
 			io_cqring_add_event(req, ret);
-			if (req->flags & REQ_F_LINK)
+			if (req_fail_links(req))
 				req->flags |= REQ_F_FAIL_LINK;
 			io_double_put_req(req);
 		}
@@ -3311,7 +3317,8 @@ static inline void io_queue_link_head(struct io_kiocb *req)
 }
 
 
-#define SQE_VALID_FLAGS	(IOSQE_FIXED_FILE|IOSQE_IO_DRAIN|IOSQE_IO_LINK)
+#define SQE_VALID_FLAGS	(IOSQE_FIXED_FILE|IOSQE_IO_DRAIN|IOSQE_IO_LINK|	\
+				IOSQE_IO_HARDLINK)
 
 static bool io_submit_sqe(struct io_kiocb *req, struct io_submit_state *state,
 			  struct io_kiocb **link)
@@ -3358,13 +3365,16 @@ static bool io_submit_sqe(struct io_kiocb *req, struct io_submit_state *state,
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
@@ -3518,7 +3528,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 		 * If previous wasn't linked and we have a linked command,
 		 * that's the end of the chain. Submit the previous link.
 		 */
-		if (!(sqe_flags & IOSQE_IO_LINK) && link) {
+		if (!(sqe_flags & (IOSQE_IO_LINK|IOSQE_IO_HARDLINK)) && link) {
 			io_queue_link_head(link);
 			link = NULL;
 		}
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index eabccb46edd1..f296a5e77661 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -48,6 +48,7 @@ struct io_uring_sqe {
 #define IOSQE_FIXED_FILE	(1U << 0)	/* use fixed fileset */
 #define IOSQE_IO_DRAIN		(1U << 1)	/* issue after inflight IO */
 #define IOSQE_IO_LINK		(1U << 2)	/* links next sqe */
+#define IOSQE_IO_HARDLINK	(1U << 3)	/* link LINK, but stronger */
 
 /*
  * io_uring_setup() flags
-- 
2.24.0

