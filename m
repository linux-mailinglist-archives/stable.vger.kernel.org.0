Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD502471EF
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391168AbgHQSfs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:35:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:46922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730976AbgHQP7k (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:59:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2544C20888;
        Mon, 17 Aug 2020 15:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679979;
        bh=ebDReBXON6r/dYIuzaxLcyZBV47Ar2EBxcl3ETii/CA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q2RHcG9SV27bICgVgxax1XOwCtmOulhVWDgDTeJ2oV2z9wNK35WfQ94HI3+cJql2R
         zut3wpjFltaKywAJpqPiuxFHJbS3uux7gOZI5UO4lH2FGHD4EejUmEGf/Uopfd3gdQ
         wEsiV5NkQ85XEX3QqPDV/4/nGlu71l0bJeEbQUog=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+9b260fc33297966f5a8e@syzkaller.appspotmail.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.7 393/393] io_uring: hold ctx reference around task_work queue + execute
Date:   Mon, 17 Aug 2020 17:17:23 +0200
Message-Id: <20200817143838.652346152@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 6d816e088c359866f9867057e04f244c608c42fe upstream.

We're holding the request reference, but we need to go one higher
to ensure that the ctx remains valid after the request has finished.
If the ring is closed with pending task_work inflight, and the
given io_kiocb finishes sync during issue, then we need a reference
to the ring itself around the task_work execution cycle.

Cc: stable@vger.kernel.org # v5.7+
Reported-by: syzbot+9b260fc33297966f5a8e@syzkaller.appspotmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 fs/io_uring.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4214,6 +4214,8 @@ static int __io_async_wake(struct io_kio
 	tsk = req->task;
 	req->result = mask;
 	init_task_work(&req->task_work, func);
+	percpu_ref_get(&req->ctx->refs);
+
 	/*
 	 * If this fails, then the task is exiting. When a task exits, the
 	 * work gets canceled, so just cancel this request as well instead
@@ -4313,6 +4315,7 @@ static void io_poll_task_handler(struct
 static void io_poll_task_func(struct callback_head *cb)
 {
 	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
+	struct io_ring_ctx *ctx = req->ctx;
 	struct io_kiocb *nxt = NULL;
 
 	io_poll_task_handler(req, &nxt);
@@ -4323,6 +4326,7 @@ static void io_poll_task_func(struct cal
 		__io_queue_sqe(nxt, NULL);
 		mutex_unlock(&ctx->uring_lock);
 	}
+	percpu_ref_put(&ctx->refs);
 }
 
 static int io_poll_double_wake(struct wait_queue_entry *wait, unsigned mode,
@@ -4439,6 +4443,7 @@ static void io_async_task_func(struct ca
 
 	if (io_poll_rewait(req, &apoll->poll)) {
 		spin_unlock_irq(&ctx->completion_lock);
+		percpu_ref_put(&ctx->refs);
 		return;
 	}
 
@@ -4476,6 +4481,7 @@ end_req:
 
 	kfree(apoll->double_poll);
 	kfree(apoll);
+	percpu_ref_put(&ctx->refs);
 }
 
 static int io_async_wake(struct wait_queue_entry *wait, unsigned mode, int sync,


