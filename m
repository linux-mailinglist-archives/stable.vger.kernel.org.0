Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 547A42474C1
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390753AbgHQTO6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:14:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:48552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387465AbgHQPkM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:40:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0237422C9F;
        Mon, 17 Aug 2020 15:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678792;
        bh=BFM0aHLr6cc0jtGytIfnjTesWK9Evh4IARFIdsrE21A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QZ9LX1xz7xWX5uC3yt7JRcahS1UoMGUJcb1LquL4en/eHzbmh4ekIaF2SXa5osj0K
         h7tdwAb6JSceOCzlFOWqSPmUI+H7Z0150/V7kr/7DRLjMbiWpJLqJcO6L8mJ9H42PN
         3RQo9baAQE/HX/ZezqGsGIppbYRTja3e1cvfkfX4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef <josef.grieb@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.8 425/464] io_uring: use TWA_SIGNAL for task_work uncondtionally
Date:   Mon, 17 Aug 2020 17:16:18 +0200
Message-Id: <20200817143854.133460948@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 0ba9c9edcd152158a0e321a4c13ac1dfc571ff3d upstream.

An earlier commit:

b7db41c9e03b ("io_uring: fix regression with always ignoring signals in io_cqring_wait()")

ensured that we didn't get stuck waiting for eventfd reads when it's
registered with the io_uring ring for event notification, but we still
have cases where the task can be waiting on other events in the kernel and
need a bigger nudge to make forward progress. Or the task could be in the
kernel and running, but on its way to blocking.

This means that TWA_RESUME cannot reliably be used to ensure we make
progress. Use TWA_SIGNAL unconditionally.

Cc: stable@vger.kernel.org # v5.7+
Reported-by: Josef <josef.grieb@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4100,22 +4100,22 @@ static int io_req_task_work_add(struct i
 {
 	struct task_struct *tsk = req->task;
 	struct io_ring_ctx *ctx = req->ctx;
-	int ret, notify = TWA_RESUME;
+	int ret, notify;
 
 	/*
-	 * SQPOLL kernel thread doesn't need notification, just a wakeup.
-	 * If we're not using an eventfd, then TWA_RESUME is always fine,
-	 * as we won't have dependencies between request completions for
-	 * other kernel wait conditions.
+	 * SQPOLL kernel thread doesn't need notification, just a wakeup. For
+	 * all other cases, use TWA_SIGNAL unconditionally to ensure we're
+	 * processing task_work. There's no reliable way to tell if TWA_RESUME
+	 * will do the job.
 	 */
-	if (ctx->flags & IORING_SETUP_SQPOLL)
-		notify = 0;
-	else if (ctx->cq_ev_fd)
+	notify = 0;
+	if (!(ctx->flags & IORING_SETUP_SQPOLL))
 		notify = TWA_SIGNAL;
 
 	ret = task_work_add(tsk, cb, notify);
 	if (!ret)
 		wake_up_process(tsk);
+
 	return ret;
 }
 


