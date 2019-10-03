Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6611ACA833
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389690AbfJCQWy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:22:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:51708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390402AbfJCQWx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:22:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D23D6222C4;
        Thu,  3 Oct 2019 16:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119772;
        bh=z0Dw7UJEjKkF9qw7/K7UEE7NM0AqBub6wivHOHrpKPI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tdI8KwJrzluwgIVXvdJmO701sBRFuCgrRllrpUUgp9TTqhhXaYIlPPENqHi0t+zNL
         dNkiEbQXyStoillRzR/rg4Jka5bwwfjGF9rJ9hllU+vuN2sjriz3wi4alkxH3V8VYp
         td3b0dQCmqehplVW5jrTNLB+ueVm5pwjkwYX1liU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Keith Busch <keith.busch@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Ming Lei <ming.lei@redhat.com>, Bob Liu <bob.liu@oracle.com>,
        Yufen Yu <yuyufen@huawei.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4.19 186/211] block: fix null pointer dereference in blk_mq_rq_timed_out()
Date:   Thu,  3 Oct 2019 17:54:12 +0200
Message-Id: <20191003154527.990189469@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154447.010950442@linuxfoundation.org>
References: <20191003154447.010950442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yufen Yu <yuyufen@huawei.com>

commit 8d6996630c03d7ceeabe2611378fea5ca1c3f1b3 upstream.

We got a null pointer deference BUG_ON in blk_mq_rq_timed_out()
as following:

[  108.825472] BUG: kernel NULL pointer dereference, address: 0000000000000040
[  108.827059] PGD 0 P4D 0
[  108.827313] Oops: 0000 [#1] SMP PTI
[  108.827657] CPU: 6 PID: 198 Comm: kworker/6:1H Not tainted 5.3.0-rc8+ #431
[  108.829503] Workqueue: kblockd blk_mq_timeout_work
[  108.829913] RIP: 0010:blk_mq_check_expired+0x258/0x330
[  108.838191] Call Trace:
[  108.838406]  bt_iter+0x74/0x80
[  108.838665]  blk_mq_queue_tag_busy_iter+0x204/0x450
[  108.839074]  ? __switch_to_asm+0x34/0x70
[  108.839405]  ? blk_mq_stop_hw_queue+0x40/0x40
[  108.839823]  ? blk_mq_stop_hw_queue+0x40/0x40
[  108.840273]  ? syscall_return_via_sysret+0xf/0x7f
[  108.840732]  blk_mq_timeout_work+0x74/0x200
[  108.841151]  process_one_work+0x297/0x680
[  108.841550]  worker_thread+0x29c/0x6f0
[  108.841926]  ? rescuer_thread+0x580/0x580
[  108.842344]  kthread+0x16a/0x1a0
[  108.842666]  ? kthread_flush_work+0x170/0x170
[  108.843100]  ret_from_fork+0x35/0x40

The bug is caused by the race between timeout handle and completion for
flush request.

When timeout handle function blk_mq_rq_timed_out() try to read
'req->q->mq_ops', the 'req' have completed and reinitiated by next
flush request, which would call blk_rq_init() to clear 'req' as 0.

After commit 12f5b93145 ("blk-mq: Remove generation seqeunce"),
normal requests lifetime are protected by refcount. Until 'rq->ref'
drop to zero, the request can really be free. Thus, these requests
cannot been reused before timeout handle finish.

However, flush request has defined .end_io and rq->end_io() is still
called even if 'rq->ref' doesn't drop to zero. After that, the 'flush_rq'
can be reused by the next flush request handle, resulting in null
pointer deference BUG ON.

We fix this problem by covering flush request with 'rq->ref'.
If the refcount is not zero, flush_end_io() return and wait the
last holder recall it. To record the request status, we add a new
entry 'rq_status', which will be used in flush_end_io().

Cc: Christoph Hellwig <hch@infradead.org>
Cc: Keith Busch <keith.busch@intel.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: stable@vger.kernel.org # v4.18+
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Bob Liu <bob.liu@oracle.com>
Signed-off-by: Yufen Yu <yuyufen@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

-------
v2:
 - move rq_status from struct request to struct blk_flush_queue
v3:
 - remove unnecessary '{}' pair.
v4:
 - let spinlock to protect 'fq->rq_status'
v5:
 - move rq_status after flush_running_idx member of struct blk_flush_queue
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---
 block/blk-flush.c |   10 ++++++++++
 block/blk-mq.c    |    5 ++++-
 block/blk.h       |    7 +++++++
 3 files changed, 21 insertions(+), 1 deletion(-)

--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -232,6 +232,16 @@ static void flush_end_io(struct request
 
 		/* release the tag's ownership to the req cloned from */
 		spin_lock_irqsave(&fq->mq_flush_lock, flags);
+
+		if (!refcount_dec_and_test(&flush_rq->ref)) {
+			fq->rq_status = error;
+			spin_unlock_irqrestore(&fq->mq_flush_lock, flags);
+			return;
+		}
+
+		if (fq->rq_status != BLK_STS_OK)
+			error = fq->rq_status;
+
 		hctx = blk_mq_map_queue(q, flush_rq->mq_ctx->cpu);
 		if (!q->elevator) {
 			blk_mq_tag_set_rq(hctx, flush_rq->tag, fq->orig_rq);
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -844,7 +844,10 @@ static void blk_mq_check_expired(struct
 	 */
 	if (blk_mq_req_expired(rq, next))
 		blk_mq_rq_timed_out(rq, reserved);
-	if (refcount_dec_and_test(&rq->ref))
+
+	if (is_flush_rq(rq, hctx))
+		rq->end_io(rq, 0);
+	else if (refcount_dec_and_test(&rq->ref))
 		__blk_mq_free_request(rq);
 }
 
--- a/block/blk.h
+++ b/block/blk.h
@@ -23,6 +23,7 @@ struct blk_flush_queue {
 	unsigned int		flush_queue_delayed:1;
 	unsigned int		flush_pending_idx:1;
 	unsigned int		flush_running_idx:1;
+	blk_status_t 		rq_status;
 	unsigned long		flush_pending_since;
 	struct list_head	flush_queue[2];
 	struct list_head	flush_data_in_flight;
@@ -123,6 +124,12 @@ static inline void __blk_get_queue(struc
 	kobject_get(&q->kobj);
 }
 
+static inline bool
+is_flush_rq(struct request *req, struct blk_mq_hw_ctx *hctx)
+{
+	return hctx->fq->flush_rq == req;
+}
+
 struct blk_flush_queue *blk_alloc_flush_queue(struct request_queue *q,
 		int node, int cmd_size, gfp_t flags);
 void blk_free_flush_queue(struct blk_flush_queue *q);


