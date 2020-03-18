Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 173B418A567
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 22:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728813AbgCRVBQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 17:01:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:57158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727983AbgCRU4T (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Mar 2020 16:56:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 561D420B1F;
        Wed, 18 Mar 2020 20:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584564979;
        bh=42J0861Sc9p/xPMPpZePXMkomnaCTvjQRTecYhjzpUA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ycejR//NFAk/yqrhHfNbUyjL5gaXotJAFo45Hsss3odDq4bz3aO5KkpUa+Cx3DkLf
         gMSsTCPgpFNE8wtBO7E0tb5N6mVbnoKxQ8ZkxtVB7cY3L68eiMhoF0zfapLYlrO+Y5
         HzNcogGlNekaKFnZtaVaIEyUgdO0c8K3qgSypVOo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Halil Pasic <pasic@linux.ibm.com>, Jens Axboe <axboe@kernel.dk>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        virtualization@lists.linux-foundation.org,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 20/28] virtio-blk: fix hw_queue stopped on arbitrary error
Date:   Wed, 18 Mar 2020 16:55:47 -0400
Message-Id: <20200318205555.17447-20-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200318205555.17447-1-sashal@kernel.org>
References: <20200318205555.17447-1-sashal@kernel.org>
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
index 8767401f75e04..19d226ff15ef8 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -271,10 +271,12 @@ static blk_status_t virtio_queue_rq(struct blk_mq_hw_ctx *hctx,
 		err = virtblk_add_req(vblk->vqs[qid].vq, vbr, vbr->sg, num);
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
 			return BLK_STS_RESOURCE;
 		return BLK_STS_IOERR;
-- 
2.20.1

