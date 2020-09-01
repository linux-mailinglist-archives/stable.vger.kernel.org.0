Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17ACC259357
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729968AbgIAPYj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:24:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:48660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729967AbgIAPYh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:24:37 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C2DB207D3;
        Tue,  1 Sep 2020 15:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598973876;
        bh=pS29Ox82J1uQr3H8vy0OUqnnoTghniXWdICI/rwgabE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ygwGowK4lHyD7NM35AkRWvv7iPgsayLlwnco1kty2Kj/QOdF4JqaEGcM0XNRMvejb
         IXQcw6xig+S6LjcDk82f7kQdpKjXw+PGLcJs/VW3E7sUnXoKLvzmMrep348HEEm507
         ZGxpOgfwR9YdRd/fS6wwXuQk+VQctJOgY/p9Uq+E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <rong.a.chen@intel.com>,
        Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        David Jeffery <djeffery@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4.19 082/125] blk-mq: order adding requests to hctx->dispatch and checking SCHED_RESTART
Date:   Tue,  1 Sep 2020 17:10:37 +0200
Message-Id: <20200901150938.597429566@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150934.576210879@linuxfoundation.org>
References: <20200901150934.576210879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

commit d7d8535f377e9ba87edbf7fbbd634ac942f3f54f upstream.

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

Fixes: bd166ef183c2 ("blk-mq-sched: add framework for MQ capable IO schedulers")
Reported-by: kernel test robot <rong.a.chen@intel.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: David Jeffery <djeffery@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/blk-mq-sched.c |    9 +++++++++
 block/blk-mq.c       |    9 +++++++++
 2 files changed, 18 insertions(+)

--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -69,6 +69,15 @@ void blk_mq_sched_restart(struct blk_mq_
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
 
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1222,6 +1222,15 @@ bool blk_mq_dispatch_rq_list(struct requ
 		spin_unlock(&hctx->lock);
 
 		/*
+		 * Order adding requests to hctx->dispatch and checking
+		 * SCHED_RESTART flag. The pair of this smp_mb() is the one
+		 * in blk_mq_sched_restart(). Avoid restart code path to
+		 * miss the new added requests to hctx->dispatch, meantime
+		 * SCHED_RESTART is observed here.
+		 */
+		smp_mb();
+
+		/*
 		 * If SCHED_RESTART was set by the caller of this function and
 		 * it is no longer set that means that it was cleared by another
 		 * thread and hence that a queue rerun is needed.


