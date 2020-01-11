Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85D25138078
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730928AbgAKKaO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:30:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:40274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728889AbgAKKaN (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:30:13 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED4892087F;
        Sat, 11 Jan 2020 10:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738612;
        bh=nDGNkb97TAMHMFhdA+qF/xMW2/R1B4L6cCRGHxKUuhI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zAr7JYWbmMrj/qPIEPXxrM5yxPYlvjdZoh45f8OKHYpI71/24kKyvkZFszM+I5uaW
         LG+JqqPLwyuk8MXcrFZsT5wb4vPhAGkevTZHeZwRp5da18obF1CDQqo1jr9FPO7ji7
         4Bib2tcysQCgXe6hLd4wLR2nEbZ4C4BqGu9K2r9U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 125/165] block: Fix a lockdep complaint triggered by request queue flushing
Date:   Sat, 11 Jan 2020 10:50:44 +0100
Message-Id: <20200111094934.717071949@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
References: <20200111094921.347491861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit b3c6a59975415bde29cfd76ff1ab008edbf614a9 ]

Avoid that running test nvme/012 from the blktests suite triggers the
following false positive lockdep complaint:

============================================
WARNING: possible recursive locking detected
5.0.0-rc3-xfstests-00015-g1236f7d60242 #841 Not tainted
--------------------------------------------
ksoftirqd/1/16 is trying to acquire lock:
000000000282032e (&(&fq->mq_flush_lock)->rlock){..-.}, at: flush_end_io+0x4e/0x1d0

but task is already holding lock:
00000000cbadcbc2 (&(&fq->mq_flush_lock)->rlock){..-.}, at: flush_end_io+0x4e/0x1d0

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&(&fq->mq_flush_lock)->rlock);
  lock(&(&fq->mq_flush_lock)->rlock);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

1 lock held by ksoftirqd/1/16:
 #0: 00000000cbadcbc2 (&(&fq->mq_flush_lock)->rlock){..-.}, at: flush_end_io+0x4e/0x1d0

stack backtrace:
CPU: 1 PID: 16 Comm: ksoftirqd/1 Not tainted 5.0.0-rc3-xfstests-00015-g1236f7d60242 #841
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 dump_stack+0x67/0x90
 __lock_acquire.cold.45+0x2b4/0x313
 lock_acquire+0x98/0x160
 _raw_spin_lock_irqsave+0x3b/0x80
 flush_end_io+0x4e/0x1d0
 blk_mq_complete_request+0x76/0x110
 nvmet_req_complete+0x15/0x110 [nvmet]
 nvmet_bio_done+0x27/0x50 [nvmet]
 blk_update_request+0xd7/0x2d0
 blk_mq_end_request+0x1a/0x100
 blk_flush_complete_seq+0xe5/0x350
 flush_end_io+0x12f/0x1d0
 blk_done_softirq+0x9f/0xd0
 __do_softirq+0xca/0x440
 run_ksoftirqd+0x24/0x50
 smpboot_thread_fn+0x113/0x1e0
 kthread+0x121/0x140
 ret_from_fork+0x3a/0x50

Cc: Christoph Hellwig <hch@infradead.org>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-flush.c | 5 +++++
 block/blk.h       | 1 +
 2 files changed, 6 insertions(+)

diff --git a/block/blk-flush.c b/block/blk-flush.c
index 1eec9cbe5a0a..b1f0a1ac505c 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -69,6 +69,7 @@
 #include <linux/blkdev.h>
 #include <linux/gfp.h>
 #include <linux/blk-mq.h>
+#include <linux/lockdep.h>
 
 #include "blk.h"
 #include "blk-mq.h"
@@ -492,6 +493,9 @@ struct blk_flush_queue *blk_alloc_flush_queue(struct request_queue *q,
 	INIT_LIST_HEAD(&fq->flush_queue[1]);
 	INIT_LIST_HEAD(&fq->flush_data_in_flight);
 
+	lockdep_register_key(&fq->key);
+	lockdep_set_class(&fq->mq_flush_lock, &fq->key);
+
 	return fq;
 
  fail_rq:
@@ -506,6 +510,7 @@ void blk_free_flush_queue(struct blk_flush_queue *fq)
 	if (!fq)
 		return;
 
+	lockdep_unregister_key(&fq->key);
 	kfree(fq->flush_rq);
 	kfree(fq);
 }
diff --git a/block/blk.h b/block/blk.h
index 47fba9362e60..ffea1691470e 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -30,6 +30,7 @@ struct blk_flush_queue {
 	 * at the same time
 	 */
 	struct request		*orig_rq;
+	struct lock_class_key	key;
 	spinlock_t		mq_flush_lock;
 };
 
-- 
2.20.1



