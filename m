Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 375EE268E06
	for <lists+stable@lfdr.de>; Mon, 14 Sep 2020 16:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726098AbgINOmM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Sep 2020 10:42:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:32952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726639AbgINNFm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Sep 2020 09:05:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2B3B22242;
        Mon, 14 Sep 2020 13:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600088694;
        bh=Uox0Mw/hPEWcP5BEoQnhTdAVlwYXQ+URXE9EsGe4ogg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SA3QLqx5sEyjATdMzdewsXR3n+p8c+qU/1SyRcTxGfTMNu4l2CNzpGiqCuorPJXS2
         OFQrpqqPM0+W3ENa7ZPia+FK8ImNkhF7H5wEXkWqN6OEzw89+/jXDWNW5GrwdXTINa
         0z1viUNHB3SKxf8DOuoM0YAbILH/oXJH2SGKJ8wM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Omar Sandoval <osandov@fb.com>, Yang Yang <yang.yang@vivo.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 16/22] block: only call sched requeue_request() for scheduled requests
Date:   Mon, 14 Sep 2020 09:04:28 -0400
Message-Id: <20200914130434.1804478-16-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200914130434.1804478-1-sashal@kernel.org>
References: <20200914130434.1804478-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

[ Upstream commit e8a8a185051a460e3eb0617dca33f996f4e31516 ]

Yang Yang reported the following crash caused by requeueing a flush
request in Kyber:

  [    2.517297] Unable to handle kernel paging request at virtual address ffffffd8071c0b00
  ...
  [    2.517468] pc : clear_bit+0x18/0x2c
  [    2.517502] lr : sbitmap_queue_clear+0x40/0x228
  [    2.517503] sp : ffffff800832bc60 pstate : 00c00145
  ...
  [    2.517599] Process ksoftirqd/5 (pid: 51, stack limit = 0xffffff8008328000)
  [    2.517602] Call trace:
  [    2.517606]  clear_bit+0x18/0x2c
  [    2.517619]  kyber_finish_request+0x74/0x80
  [    2.517627]  blk_mq_requeue_request+0x3c/0xc0
  [    2.517637]  __scsi_queue_insert+0x11c/0x148
  [    2.517640]  scsi_softirq_done+0x114/0x130
  [    2.517643]  blk_done_softirq+0x7c/0xb0
  [    2.517651]  __do_softirq+0x208/0x3bc
  [    2.517657]  run_ksoftirqd+0x34/0x60
  [    2.517663]  smpboot_thread_fn+0x1c4/0x2c0
  [    2.517667]  kthread+0x110/0x120
  [    2.517669]  ret_from_fork+0x10/0x18

This happens because Kyber doesn't track flush requests, so
kyber_finish_request() reads a garbage domain token. Only call the
scheduler's requeue_request() hook if RQF_ELVPRIV is set (like we do for
the finish_request() hook in blk_mq_free_request()). Now that we're
handling it in blk-mq, also remove the check from BFQ.

Reported-by: Yang Yang <yang.yang@vivo.com>
Signed-off-by: Omar Sandoval <osandov@fb.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bfq-iosched.c  | 12 ------------
 block/blk-mq-sched.h |  2 +-
 2 files changed, 1 insertion(+), 13 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 88497bff1135f..ba32adaeefdd0 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -5890,18 +5890,6 @@ static void bfq_finish_requeue_request(struct request *rq)
 	struct bfq_queue *bfqq = RQ_BFQQ(rq);
 	struct bfq_data *bfqd;
 
-	/*
-	 * Requeue and finish hooks are invoked in blk-mq without
-	 * checking whether the involved request is actually still
-	 * referenced in the scheduler. To handle this fact, the
-	 * following two checks make this function exit in case of
-	 * spurious invocations, for which there is nothing to do.
-	 *
-	 * First, check whether rq has nothing to do with an elevator.
-	 */
-	if (unlikely(!(rq->rq_flags & RQF_ELVPRIV)))
-		return;
-
 	/*
 	 * rq either is not associated with any icq, or is an already
 	 * requeued request that has not (yet) been re-inserted into
diff --git a/block/blk-mq-sched.h b/block/blk-mq-sched.h
index 126021fc3a11f..e81ca1bf6e10b 100644
--- a/block/blk-mq-sched.h
+++ b/block/blk-mq-sched.h
@@ -66,7 +66,7 @@ static inline void blk_mq_sched_requeue_request(struct request *rq)
 	struct request_queue *q = rq->q;
 	struct elevator_queue *e = q->elevator;
 
-	if (e && e->type->ops.requeue_request)
+	if ((rq->rq_flags & RQF_ELVPRIV) && e && e->type->ops.requeue_request)
 		e->type->ops.requeue_request(rq);
 }
 
-- 
2.25.1

