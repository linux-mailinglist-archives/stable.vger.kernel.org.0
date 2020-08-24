Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC1824F4B8
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 10:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728677AbgHXIjq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:39:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:55908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728665AbgHXIjp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:39:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B14F5221E2;
        Mon, 24 Aug 2020 08:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258384;
        bh=f+eJYYMbONiJeb1v9bjRb1whw7sxNoF7XtF8OaQ7S1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xv2k2z9CxQutNGp9smaH7MdRjaWVplTtKzfijkc5VtoSH1FiUa+g2RxjlYS9eGeV2
         10kHlercUfHgeZVU22+gtfcD7nPfdeDIjo/0m+DnnCkOoTevHasvesqq1rGR/dCzEM
         k+S+yhDcdxL6XNklQZ1N5Pi98TVDAmzD7JkS7o64=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 028/124] io-wq: reorder cancellation pending -> running
Date:   Mon, 24 Aug 2020 10:29:22 +0200
Message-Id: <20200824082410.797298921@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082409.368269240@linuxfoundation.org>
References: <20200824082409.368269240@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit f4c2665e33f48904f2766d644df33fb3fd54b5ec ]

Go all over all pending lists and cancel works there, and only then
try to match running requests. No functional changes here, just a
preparation for bulk cancellation.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io-wq.c | 54 ++++++++++++++++++++++++++++++++----------------------
 1 file changed, 32 insertions(+), 22 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 4023c98468608..3283f8c5b5a18 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -931,19 +931,14 @@ static bool io_wq_worker_cancel(struct io_worker *worker, void *data)
 	return ret;
 }
 
-static enum io_wq_cancel io_wqe_cancel_work(struct io_wqe *wqe,
-					    struct io_cb_cancel_data *match)
+static bool io_wqe_cancel_pending_work(struct io_wqe *wqe,
+				       struct io_cb_cancel_data *match)
 {
 	struct io_wq_work_node *node, *prev;
 	struct io_wq_work *work;
 	unsigned long flags;
 	bool found = false;
 
-	/*
-	 * First check pending list, if we're lucky we can just remove it
-	 * from there. CANCEL_OK means that the work is returned as-new,
-	 * no completion will be posted for it.
-	 */
 	spin_lock_irqsave(&wqe->lock, flags);
 	wq_list_for_each(node, prev, &wqe->work_list) {
 		work = container_of(node, struct io_wq_work, list);
@@ -956,21 +951,20 @@ static enum io_wq_cancel io_wqe_cancel_work(struct io_wqe *wqe,
 	}
 	spin_unlock_irqrestore(&wqe->lock, flags);
 
-	if (found) {
+	if (found)
 		io_run_cancel(work, wqe);
-		return IO_WQ_CANCEL_OK;
-	}
+	return found;
+}
+
+static bool io_wqe_cancel_running_work(struct io_wqe *wqe,
+				       struct io_cb_cancel_data *match)
+{
+	bool found;
 
-	/*
-	 * Now check if a free (going busy) or busy worker has the work
-	 * currently running. If we find it there, we'll return CANCEL_RUNNING
-	 * as an indication that we attempt to signal cancellation. The
-	 * completion will run normally in this case.
-	 */
 	rcu_read_lock();
 	found = io_wq_for_each_worker(wqe, io_wq_worker_cancel, match);
 	rcu_read_unlock();
-	return found ? IO_WQ_CANCEL_RUNNING : IO_WQ_CANCEL_NOTFOUND;
+	return found;
 }
 
 enum io_wq_cancel io_wq_cancel_cb(struct io_wq *wq, work_cancel_fn *cancel,
@@ -980,18 +974,34 @@ enum io_wq_cancel io_wq_cancel_cb(struct io_wq *wq, work_cancel_fn *cancel,
 		.fn	= cancel,
 		.data	= data,
 	};
-	enum io_wq_cancel ret = IO_WQ_CANCEL_NOTFOUND;
 	int node;
 
+	/*
+	 * First check pending list, if we're lucky we can just remove it
+	 * from there. CANCEL_OK means that the work is returned as-new,
+	 * no completion will be posted for it.
+	 */
 	for_each_node(node) {
 		struct io_wqe *wqe = wq->wqes[node];
 
-		ret = io_wqe_cancel_work(wqe, &match);
-		if (ret != IO_WQ_CANCEL_NOTFOUND)
-			break;
+		if (io_wqe_cancel_pending_work(wqe, &match))
+			return IO_WQ_CANCEL_OK;
 	}
 
-	return ret;
+	/*
+	 * Now check if a free (going busy) or busy worker has the work
+	 * currently running. If we find it there, we'll return CANCEL_RUNNING
+	 * as an indication that we attempt to signal cancellation. The
+	 * completion will run normally in this case.
+	 */
+	for_each_node(node) {
+		struct io_wqe *wqe = wq->wqes[node];
+
+		if (io_wqe_cancel_running_work(wqe, &match))
+			return IO_WQ_CANCEL_RUNNING;
+	}
+
+	return IO_WQ_CANCEL_NOTFOUND;
 }
 
 static bool io_wq_io_cb_cancel_data(struct io_wq_work *work, void *data)
-- 
2.25.1



