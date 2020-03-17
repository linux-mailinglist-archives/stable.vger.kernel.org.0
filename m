Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C497318811A
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:16:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbgCQLKV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:10:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:53118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728745AbgCQLKU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:10:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8723B20714;
        Tue, 17 Mar 2020 11:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443420;
        bh=PqWD8O81LYKtCIQk9TxWpkpd8TvOh8TUSwA3cRe6/Ek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zi/jIPNRmxJyL8pDPnkG9l3Yi3bZOk9Dwi2GLZH4ptVPqRD2jtDuEBFQN5XRpEyyd
         s5tUGTTvN5YM+XSMXsTH7l6uaWxJWqL0G7Um9iiJL4ZKBxZ9fYl1PEAzYNZoUkyCoI
         nhwIYB56g5uXdp11xNysBBb2PSjqWTX1A7BEfLg8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
        Jens Axboe <axboe@kernel.dk>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: [PATCH 5.5 077/151] virtio-blk: fix hw_queue stopped on arbitrary error
Date:   Tue, 17 Mar 2020 11:54:47 +0100
Message-Id: <20200317103331.950977130@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103326.593639086@linuxfoundation.org>
References: <20200317103326.593639086@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Halil Pasic <pasic@linux.ibm.com>

commit f5f6b95c72f7f8bb46eace8c5306c752d0133daa upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/virtio_blk.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -339,10 +339,12 @@ static blk_status_t virtio_queue_rq(stru
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
 			return BLK_STS_DEV_RESOURCE;
 		return BLK_STS_IOERR;


