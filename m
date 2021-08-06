Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 626223E25C4
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 10:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242200AbhHFIWW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 04:22:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:51700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244322AbhHFIVM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 04:21:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22BD761205;
        Fri,  6 Aug 2021 08:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628238049;
        bh=vgE5cqUa0/MbQouB594T94j6IeodtRa1FmfWGzzBqyg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=03X/1QODRhKxL1eagZ+9XIaxsXRVYRUjklREf7XzBzNFfBS19RBTf9Y89bjQL2/4v
         cK19zRATuYspjgbGXkp+NOmxjDctDLVNFQmHMWpH1qZ+Jg/g3yfrp1yVLCvNT1evDF
         Je0/N7W70eZ3Sfk2m78IGsx7AzGxUPzPQTy1e4wA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 31/35] io_uring: explicitly catch any illegal async queue attempt
Date:   Fri,  6 Aug 2021 10:17:14 +0200
Message-Id: <20210806081114.747625953@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210806081113.718626745@linuxfoundation.org>
References: <20210806081113.718626745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 991468dcf198bb87f24da330676724a704912b47 ]

Catch an illegal case to queue async from an unrelated task that got
the ring fd passed to it. This should not be possible to hit, but
better be proactive and catch it explicitly. io-wq is extended to
check for early IO_WQ_WORK_CANCEL being set on a work item as well,
so it can run the request through the normal cancelation path.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io-wq.c    |  7 ++++++-
 fs/io_uring.c | 11 +++++++++++
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 60f58efdb5f4..9efecdf025b9 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -736,7 +736,12 @@ static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
 	int work_flags;
 	unsigned long flags;
 
-	if (test_bit(IO_WQ_BIT_EXIT, &wqe->wq->state)) {
+	/*
+	 * If io-wq is exiting for this task, or if the request has explicitly
+	 * been marked as one that should not get executed, cancel it here.
+	 */
+	if (test_bit(IO_WQ_BIT_EXIT, &wqe->wq->state) ||
+	    (work->flags & IO_WQ_WORK_CANCEL)) {
 		io_run_cancel(work, wqe);
 		return;
 	}
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 86f609fa761c..32f3df13a812 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1282,6 +1282,17 @@ static void io_queue_async_work(struct io_kiocb *req)
 
 	/* init ->work of the whole link before punting */
 	io_prep_async_link(req);
+
+	/*
+	 * Not expected to happen, but if we do have a bug where this _can_
+	 * happen, catch it here and ensure the request is marked as
+	 * canceled. That will make io-wq go through the usual work cancel
+	 * procedure rather than attempt to run this request (or create a new
+	 * worker for it).
+	 */
+	if (WARN_ON_ONCE(!same_thread_group(req->task, current)))
+		req->work.flags |= IO_WQ_WORK_CANCEL;
+
 	trace_io_uring_queue_async_work(ctx, io_wq_is_hashed(&req->work), req,
 					&req->work, req->flags);
 	io_wq_enqueue(tctx->io_wq, &req->work);
-- 
2.30.2



