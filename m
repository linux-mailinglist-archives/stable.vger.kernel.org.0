Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66B8FE689F
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731189AbfJ0VSG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:18:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:38176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731205AbfJ0VSE (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:18:04 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00939208C0;
        Sun, 27 Oct 2019 21:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211083;
        bh=KllF1Vd9QjJ+moQw4J7Yv+052X+bzOtxMFBqtCgyhEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MmSa8qLk0Mis/iN3/vLQd8zPuuN2homikEB/uIQJU/YHmhePo/2XBFRq+VHyViI/v
         z3PTckGXaAjCqdcz/WggfXWxNDiG8x6M268cgcuxCCquMuhSxhz+U/XgVujLMPg5cj
         kfr/G3whOcJW24FJBMKE8E+7hLedq0QFVqL2TPew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>,
        Dave Chinner <dchinner@redhat.com>,
        =?UTF-8?q?Javier=20Gonz=C3=A1lez?= <javier@javigon.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 026/197] blk-mq: honor IO scheduler for multiqueue devices
Date:   Sun, 27 Oct 2019 21:59:04 +0100
Message-Id: <20191027203353.126808171@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit a12de1d42d74ef3c80e9fb9a2da94daaef747869 ]

If a device is using multiple queues, the IO scheduler may be bypassed.
This may hurt performance for some slow MQ devices, and it also breaks
zoned devices which depend on mq-deadline for respecting the write order
in one zone.

Don't bypass io scheduler if we have one setup.

This patch can double sequential write performance basically on MQ
scsi_debug when mq-deadline is applied.

Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Javier González <javier@javigon.com>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index a79b9ad1aba18..ed41cde93641c 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1998,6 +1998,8 @@ static blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio)
 		}
 
 		blk_add_rq_to_plug(plug, rq);
+	} else if (q->elevator) {
+		blk_mq_sched_insert_request(rq, false, true, true);
 	} else if (plug && !blk_queue_nomerges(q)) {
 		/*
 		 * We do limited plugging. If the bio can be merged, do that.
@@ -2021,8 +2023,8 @@ static blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio)
 			blk_mq_try_issue_directly(data.hctx, same_queue_rq,
 					&cookie);
 		}
-	} else if ((q->nr_hw_queues > 1 && is_sync) || (!q->elevator &&
-			!data.hctx->dispatch_busy)) {
+	} else if ((q->nr_hw_queues > 1 && is_sync) ||
+			!data.hctx->dispatch_busy) {
 		blk_mq_try_issue_directly(data.hctx, rq, &cookie);
 	} else {
 		blk_mq_sched_insert_request(rq, false, true, true);
-- 
2.20.1



