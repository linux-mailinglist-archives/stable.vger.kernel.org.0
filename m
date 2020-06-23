Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B3B5206334
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389752AbgFWUTF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:19:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:36102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389750AbgFWUTE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:19:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C7E42064B;
        Tue, 23 Jun 2020 20:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943544;
        bh=87Y+p+s1ikRtX3kRd0XJX39foUwqZUy7+rOdz91WDnM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wF65P1l8W3gVt3KXPpASzzBXuRieSl+OVxXrtoJFKr14VepRt0+B8YcqTxiEfwsEQ
         gbOYZPkuYU1Ac+ZZ0eZuJaSiX6QqJIlumuXKGzbrWzSZO+R9B++00YCImI29e+9VJP
         2Sx4z8sUAPqIPH4hQeOOAXhbGP1WiHeDtbarWk6k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.7 432/477] io_uring: add memory barrier to synchronize io_kiocbs result and iopoll_completed
Date:   Tue, 23 Jun 2020 21:57:09 +0200
Message-Id: <20200623195427.951230674@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>

[ Upstream commit bbde017a32b32d2fa8d5fddca25fade20132abf8 ]

In io_complete_rw_iopoll(), stores to io_kiocb's result and iopoll
completed are two independent store operations, to ensure that once
iopoll_completed is ture and then req->result must been perceived by
the cpu executing io_do_iopoll(), proper memory barrier should be used.

And in io_do_iopoll(), we check whether req->result is EAGAIN, if it is,
we'll need to issue this io request using io-wq again. In order to just
issue a single smp_rmb() on the completion side, move the re-submit work
to io_iopoll_complete().

Cc: stable@vger.kernel.org
Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
[axboe: don't set ->iopoll_completed for -EAGAIN retry]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   53 +++++++++++++++++++++++++++++------------------------
 1 file changed, 29 insertions(+), 24 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1690,6 +1690,18 @@ static int io_put_kbuf(struct io_kiocb *
 	return cflags;
 }
 
+static void io_iopoll_queue(struct list_head *again)
+{
+	struct io_kiocb *req;
+
+	do {
+		req = list_first_entry(again, struct io_kiocb, list);
+		list_del(&req->list);
+		refcount_inc(&req->refs);
+		io_queue_async_work(req);
+	} while (!list_empty(again));
+}
+
 /*
  * Find and free completed poll iocbs
  */
@@ -1698,12 +1710,21 @@ static void io_iopoll_complete(struct io
 {
 	struct req_batch rb;
 	struct io_kiocb *req;
+	LIST_HEAD(again);
+
+	/* order with ->result store in io_complete_rw_iopoll() */
+	smp_rmb();
 
 	rb.to_free = rb.need_iter = 0;
 	while (!list_empty(done)) {
 		int cflags = 0;
 
 		req = list_first_entry(done, struct io_kiocb, list);
+		if (READ_ONCE(req->result) == -EAGAIN) {
+			req->iopoll_completed = 0;
+			list_move_tail(&req->list, &again);
+			continue;
+		}
 		list_del(&req->list);
 
 		if (req->flags & REQ_F_BUFFER_SELECTED)
@@ -1721,18 +1742,9 @@ static void io_iopoll_complete(struct io
 	if (ctx->flags & IORING_SETUP_SQPOLL)
 		io_cqring_ev_posted(ctx);
 	io_free_req_many(ctx, &rb);
-}
 
-static void io_iopoll_queue(struct list_head *again)
-{
-	struct io_kiocb *req;
-
-	do {
-		req = list_first_entry(again, struct io_kiocb, list);
-		list_del(&req->list);
-		refcount_inc(&req->refs);
-		io_queue_async_work(req);
-	} while (!list_empty(again));
+	if (!list_empty(&again))
+		io_iopoll_queue(&again);
 }
 
 static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
@@ -1740,7 +1752,6 @@ static int io_do_iopoll(struct io_ring_c
 {
 	struct io_kiocb *req, *tmp;
 	LIST_HEAD(done);
-	LIST_HEAD(again);
 	bool spin;
 	int ret;
 
@@ -1766,13 +1777,6 @@ static int io_do_iopoll(struct io_ring_c
 		if (!list_empty(&done))
 			break;
 
-		if (req->result == -EAGAIN) {
-			list_move_tail(&req->list, &again);
-			continue;
-		}
-		if (!list_empty(&again))
-			break;
-
 		ret = kiocb->ki_filp->f_op->iopoll(kiocb, spin);
 		if (ret < 0)
 			break;
@@ -1785,9 +1789,6 @@ static int io_do_iopoll(struct io_ring_c
 	if (!list_empty(&done))
 		io_iopoll_complete(ctx, nr_events, &done);
 
-	if (!list_empty(&again))
-		io_iopoll_queue(&again);
-
 	return ret;
 }
 
@@ -1938,9 +1939,13 @@ static void io_complete_rw_iopoll(struct
 
 	if (res != -EAGAIN && res != req->result)
 		req_set_fail_links(req);
-	req->result = res;
-	if (res != -EAGAIN)
+
+	WRITE_ONCE(req->result, res);
+	/* order with io_poll_complete() checking ->result */
+	if (res != -EAGAIN) {
+		smp_wmb();
 		WRITE_ONCE(req->iopoll_completed, 1);
+	}
 }
 
 /*


