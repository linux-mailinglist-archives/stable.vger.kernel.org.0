Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDA9B3CDF2B
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345131AbhGSPIE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:08:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:60416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345582AbhGSPEm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:04:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 91DA561002;
        Mon, 19 Jul 2021 15:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709464;
        bh=MsuFiYr1B/vBs+rZ9Sy8lx3c5KEKHFIwYu/WAIBpf6w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MROTOiw85dvUhNdfUpSmWoTqAZajXVrHw2KyZISTp3gEZXwKOEWOa0yLq+ADNYnlC
         a8Re1EM+iDzg433lFElXFGtYVqnSTay59DCQL9h8A8ihk5tY9CIBF1FgwEgMn1zWY5
         UUdk/7sahjqyQ3rl+fn2+4tOiRyRStOhfdOyq4ek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 393/421] virtio_net: move tx vq operation under tx queue lock
Date:   Mon, 19 Jul 2021 16:53:24 +0200
Message-Id: <20210719144959.997457901@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael S. Tsirkin <mst@redhat.com>

[ Upstream commit 5a2f966d0f3fa0ef6dada7ab9eda74cacee96b8a ]

It's unsafe to operate a vq from multiple threads.
Unfortunately this is exactly what we do when invoking
clean tx poll from rx napi.
Same happens with napi-tx even without the
opportunistic cleaning from the receive interrupt: that races
with processing the vq in start_xmit.

As a fix move everything that deals with the vq to under tx lock.

Fixes: b92f1e6751a6 ("virtio-net: transmit napi")
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/virtio_net.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index bb11a1e30646..5e8b40630286 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1506,6 +1506,8 @@ static int virtnet_poll_tx(struct napi_struct *napi, int budget)
 	struct virtnet_info *vi = sq->vq->vdev->priv;
 	unsigned int index = vq2txq(sq->vq);
 	struct netdev_queue *txq;
+	int opaque;
+	bool done;
 
 	if (unlikely(is_xdp_raw_buffer_queue(vi, index))) {
 		/* We don't need to enable cb for XDP */
@@ -1515,10 +1517,28 @@ static int virtnet_poll_tx(struct napi_struct *napi, int budget)
 
 	txq = netdev_get_tx_queue(vi->dev, index);
 	__netif_tx_lock(txq, raw_smp_processor_id());
+	virtqueue_disable_cb(sq->vq);
 	free_old_xmit_skbs(sq, true);
+
+	opaque = virtqueue_enable_cb_prepare(sq->vq);
+
+	done = napi_complete_done(napi, 0);
+
+	if (!done)
+		virtqueue_disable_cb(sq->vq);
+
 	__netif_tx_unlock(txq);
 
-	virtqueue_napi_complete(napi, sq->vq, 0);
+	if (done) {
+		if (unlikely(virtqueue_poll(sq->vq, opaque))) {
+			if (napi_schedule_prep(napi)) {
+				__netif_tx_lock(txq, raw_smp_processor_id());
+				virtqueue_disable_cb(sq->vq);
+				__netif_tx_unlock(txq);
+				__napi_schedule(napi);
+			}
+		}
+	}
 
 	if (sq->vq->num_free >= 2 + MAX_SKB_FRAGS)
 		netif_tx_wake_queue(txq);
-- 
2.30.2



