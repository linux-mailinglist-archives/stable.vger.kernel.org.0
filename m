Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6C02463E4
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 12:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbgHQKBb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 06:01:31 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:44701 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726403AbgHQKBb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Aug 2020 06:01:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597658489;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Oey9JRiYEuJaAPCIyzOPgCDsyCsWoSR1mfvYFwGCsxY=;
        b=R2OYTjWUWoecbyC0quUyq3cR3VfoutJ3D3BdTVLF7zTQHQdKaYPINWDu0Swvzc5MD1WQ6k
        qcFGZyOaFWvn5wzdd46E83OBO913QCacR/S34umXpPiJV8YNHaVfIL0UhTB2TXgCBpIUsU
        cQMx3+YHSDIQbOv/jIt7XpVlT2R1EDc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-263-KOsg4tPZPHas_PpKi2n_uA-1; Mon, 17 Aug 2020 06:01:24 -0400
X-MC-Unique: KOsg4tPZPHas_PpKi2n_uA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8DA5481F00A;
        Mon, 17 Aug 2020 10:01:23 +0000 (UTC)
Received: from localhost (ovpn-13-146.pek2.redhat.com [10.72.13.146])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BA52F5D9E2;
        Mon, 17 Aug 2020 10:01:19 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>,
        David Jeffery <djeffery@redhat.com>,
        kernel test robot <rong.a.chen@intel.com>,
        stable@vger.kernel.org
Subject: [PATCH RESEND] blk-mq: order adding requests to hctx->dispatch and checking SCHED_RESTART
Date:   Mon, 17 Aug 2020 18:01:15 +0800
Message-Id: <20200817100115.2495988-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SCHED_RESTART code path is relied to re-run queue for dispatch requests
in hctx->dispatch. Meantime the SCHED_RSTART flag is checked when adding
requests to hctx->dispatch.

memory barriers have to be used for ordering the following two pair of OPs:

1) adding requests to hctx->dispatch and checking SCHED_RESTART in
blk_mq_dispatch_rq_list()

2) clearing SCHED_RESTART and checking if there is request in hctx->dispatch
in blk_mq_sched_restart().

Without the added memory barrier, either:

1) blk_mq_sched_restart() may miss requests added to hctx->dispatch meantime
blk_mq_dispatch_rq_list() observes SCHED_RESTART, and not run queue in
dispatch side

or

2) blk_mq_dispatch_rq_list still sees SCHED_RESTART, and not run queue
in dispatch side, meantime checking if there is request in
hctx->dispatch from blk_mq_sched_restart() is missed.

IO hang in ltp/fs_fill test is reported by kernel test robot:

	https://lkml.org/lkml/2020/7/26/77

Turns out it is caused by the above out-of-order OPs. And the IO hang
can't be observed any more after applying this patch.

Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: David Jeffery <djeffery@redhat.com>
Reported-by: kernel test robot <rong.a.chen@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-mq-sched.c | 9 +++++++++
 block/blk-mq.c       | 9 +++++++++
 2 files changed, 18 insertions(+)

diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index a19cdf159b75..d2790e5b06d1 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -78,6 +78,15 @@ void blk_mq_sched_restart(struct blk_mq_hw_ctx *hctx)
 		return;
 	clear_bit(BLK_MQ_S_SCHED_RESTART, &hctx->state);
 
+	/*
+	 * Order clearing SCHED_RESTART and list_empty_careful(&hctx->dispatch)
+	 * in blk_mq_run_hw_queue(). Its pair is the barrier in
+	 * blk_mq_dispatch_rq_list(). So dispatch code won't see SCHED_RESTART,
+	 * meantime new request added to hctx->dispatch is missed to check in
+	 * blk_mq_run_hw_queue().
+	 */
+	smp_mb();
+
 	blk_mq_run_hw_queue(hctx, true);
 }
 
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 0015a1892153..6c1c3ad175a9 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1437,6 +1437,15 @@ bool blk_mq_dispatch_rq_list(struct blk_mq_hw_ctx *hctx, struct list_head *list,
 		list_splice_tail_init(list, &hctx->dispatch);
 		spin_unlock(&hctx->lock);
 
+		/*
+		 * Order adding requests to hctx->dispatch and checking
+		 * SCHED_RESTART flag. The pair of this smp_mb() is the one
+		 * in blk_mq_sched_restart(). Avoid restart code path to
+		 * miss the new added requests to hctx->dispatch, meantime
+		 * SCHED_RESTART is observed here.
+		 */
+		smp_mb();
+
 		/*
 		 * If SCHED_RESTART was set by the caller of this function and
 		 * it is no longer set that means that it was cleared by another
-- 
2.25.2

