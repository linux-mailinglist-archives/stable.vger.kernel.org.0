Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1042B18A53C
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 22:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728319AbgCRU7z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 16:59:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:57894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728656AbgCRU4m (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Mar 2020 16:56:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1BD421707;
        Wed, 18 Mar 2020 20:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584565001;
        bh=oY0SUiEeXSxBkyGUXp0/nvA1R5EflvNU30qHwxT+EX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bKaW29Cl6wLJK+RXjhAqvvpsYsQNWM4L6DraYK9u7vR7/RU3rAm9IOLXeX35zx9li
         M3vqIy9mIpE2oFw+2xHvWhE6Lp9r74Ub8Ape0YI/pvQYnN5AAGuMtv4Yz0kKHxssyf
         sdN/pF7OHoYXOWLkUAeLecLCdfbe8OE3Gqkg1ci4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Halil Pasic <pasic@linux.ibm.com>, Jens Axboe <axboe@kernel.dk>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        virtualization@lists.linux-foundation.org,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 10/15] virtio-blk: fix hw_queue stopped on arbitrary error
Date:   Wed, 18 Mar 2020 16:56:24 -0400
Message-Id: <20200318205629.17750-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200318205629.17750-1-sashal@kernel.org>
References: <20200318205629.17750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Halil Pasic <pasic@linux.ibm.com>

[ Upstream commit f5f6b95c72f7f8bb46eace8c5306c752d0133daa ]

Since nobody else is going to restart our hw_queue for us, the
blk_mq_start_stopped_hw_queues() is in virtblk_done() is not sufficient
necessarily sufficient to ensure that the queue will get started again.
In case of global resource outage (-ENOMEM because mapping failure,
because of swiotlb full) our virtqueue may be empty and we can get
stuck with a stopped hw_queue.

Let us not stop the queue on arbitrary errors, but only on -EONSPC which
indicates a full virtqueue, where the hw_queue is guaranteed to get
started by virtblk_done() before when it makes sense to carry on
submitting requests. Let us also remove a stale comment.

Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
Cc: Jens Axboe <axboe@kernel.dk>
Fixes: f7728002c1c7 ("virtio_ring: fix return code on DMA mapping fails")
Link: https://lore.kernel.org/r/20200213123728.61216-2-pasic@linux.ibm.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/virtio_blk.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 44ef1d66caa68..f287eec36b282 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -215,10 +215,12 @@ static int virtio_queue_rq(struct blk_mq_hw_ctx *hctx,
 	err = __virtblk_add_req(vblk->vqs[qid].vq, vbr, vbr->sg, num);
 	if (err) {
 		virtqueue_kick(vblk->vqs[qid].vq);
-		blk_mq_stop_hw_queue(hctx);
+		/* Don't stop the queue if -ENOMEM: we may have failed to
+		 * bounce the buffer due to global resource outage.
+		 */
+		if (err == -ENOSPC)
+			blk_mq_stop_hw_queue(hctx);
 		spin_unlock_irqrestore(&vblk->vqs[qid].lock, flags);
-		/* Out of mem doesn't actually happen, since we fall back
-		 * to direct descriptors */
 		if (err == -ENOMEM || err == -ENOSPC)
 			return BLK_MQ_RQ_QUEUE_BUSY;
 		return BLK_MQ_RQ_QUEUE_ERROR;
-- 
2.20.1

