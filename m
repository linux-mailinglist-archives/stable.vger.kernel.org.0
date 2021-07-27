Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3787A3D76A4
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 15:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237107AbhG0NaS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 09:30:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:56490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236731AbhG0NUQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Jul 2021 09:20:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B11361AAB;
        Tue, 27 Jul 2021 13:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627391976;
        bh=4ZLX4XJ26jnLuU5vLhlPGEH53YsuyPOzz4KeEG4Y3/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RfNfpxlQR6IlypCqTZWFq3mBoSQvFFPAQYPBfii+shQEUv/IoGs7OUJvqfmJBChzz
         pOueGOUZ/2S4YXee+P+sqllgy67UHoyUGzZwYnmEMGLrLUopTGboVRyPLn58QRv1fS
         x4pkrV67tBJvyIBQWWRZt7l9350cy6OLAQi74PvTSnFW8zlOBSWbaaw6cBbn5JJoIx
         Ir6xMsDjbwAbD5XfeOkauT9t/30V3HJwyPrKfGUElHKSy0aNQi7TPqf5IoSvBWWTAV
         mVf0EKAfbS4Q/a+F0AtdjVP/c0RtE0eM49ohCDqqJ1Jpyr/XX9hvyS6GhY35nLugUe
         CuObKyS64rayw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 20/21] io_uring: explicitly catch any illegal async queue attempt
Date:   Tue, 27 Jul 2021 09:19:07 -0400
Message-Id: <20210727131908.834086-20-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210727131908.834086-1-sashal@kernel.org>
References: <20210727131908.834086-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 7ae6043e7909..5f6514185a3a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1273,6 +1273,17 @@ static void io_queue_async_work(struct io_kiocb *req)
 
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

