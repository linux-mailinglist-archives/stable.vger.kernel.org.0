Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E4FA3F65C8
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240042AbhHXRQi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:16:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:55606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240404AbhHXROn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:14:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4B2361A8A;
        Tue, 24 Aug 2021 17:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824504;
        bh=pdfOPGlNDuzzmXhSCF6aeSrwzt4evmp+6WUXhcTbLeo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LLMVpMLh7G6lXbWESWODcUFRqyLILb0zAyWdM5T4VjkO/EbpN5Jpe0dcctFJqSxa4
         K3rtb/+VJROB2FTQrITECjqAvBjsH16d9n/DPjRTnYSvuTO8VVl0Laop5rWU0c7m0Z
         aRHWadH6HIHO9ysAY/Gh4n2bg0sKVWMX7KqmFDXDBNHEzEeZ7nE0+xljsz/UtajU5X
         OVVzlTySM7UY02TVP9s/PBnwpyze5zFszYXFzEPE1nKP6n777QyBQRodfQVRWe4Qur
         gKptx3mMLh5zi7mMOxe3Xj6BsG23MLk7X8/h/947TZrQdzdKWeYG1ObbByYWw9K/Yn
         fNLfYfQPUJh5A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Dust Li <dust.li@linux.alibaba.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 37/61] virtio-net: support XDP when not more queues
Date:   Tue, 24 Aug 2021 13:00:42 -0400
Message-Id: <20210824170106.710221-38-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170106.710221-1-sashal@kernel.org>
References: <20210824170106.710221-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.143-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.143-rc1
X-KernelTest-Deadline: 2021-08-26T17:01+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>

[ Upstream commit 97c2c69e1926260c78c7f1c0b2c987934f1dc7a1 ]

The number of queues implemented by many virtio backends is limited,
especially some machines have a large number of CPUs. In this case, it
is often impossible to allocate a separate queue for
XDP_TX/XDP_REDIRECT, then xdp cannot be loaded to work, even xdp does
not use the XDP_TX/XDP_REDIRECT.

This patch allows XDP_TX/XDP_REDIRECT to run by reuse the existing SQ
with __netif_tx_lock() hold when there are not enough queues.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/virtio_net.c | 62 +++++++++++++++++++++++++++++++---------
 1 file changed, 49 insertions(+), 13 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 15453d6fcc23..36f8aeb113a8 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -195,6 +195,9 @@ struct virtnet_info {
 	/* # of XDP queue pairs currently used by the driver */
 	u16 xdp_queue_pairs;
 
+	/* xdp_queue_pairs may be 0, when xdp is already loaded. So add this. */
+	bool xdp_enabled;
+
 	/* I like... big packets and I cannot lie! */
 	bool big_packets;
 
@@ -485,12 +488,41 @@ static int __virtnet_xdp_xmit_one(struct virtnet_info *vi,
 	return 0;
 }
 
-static struct send_queue *virtnet_xdp_sq(struct virtnet_info *vi)
-{
-	unsigned int qp;
-
-	qp = vi->curr_queue_pairs - vi->xdp_queue_pairs + smp_processor_id();
-	return &vi->sq[qp];
+/* when vi->curr_queue_pairs > nr_cpu_ids, the txq/sq is only used for xdp tx on
+ * the current cpu, so it does not need to be locked.
+ *
+ * Here we use marco instead of inline functions because we have to deal with
+ * three issues at the same time: 1. the choice of sq. 2. judge and execute the
+ * lock/unlock of txq 3. make sparse happy. It is difficult for two inline
+ * functions to perfectly solve these three problems at the same time.
+ */
+#define virtnet_xdp_get_sq(vi) ({                                       \
+	struct netdev_queue *txq;                                       \
+	typeof(vi) v = (vi);                                            \
+	unsigned int qp;                                                \
+									\
+	if (v->curr_queue_pairs > nr_cpu_ids) {                         \
+		qp = v->curr_queue_pairs - v->xdp_queue_pairs;          \
+		qp += smp_processor_id();                               \
+		txq = netdev_get_tx_queue(v->dev, qp);                  \
+		__netif_tx_acquire(txq);                                \
+	} else {                                                        \
+		qp = smp_processor_id() % v->curr_queue_pairs;          \
+		txq = netdev_get_tx_queue(v->dev, qp);                  \
+		__netif_tx_lock(txq, raw_smp_processor_id());           \
+	}                                                               \
+	v->sq + qp;                                                     \
+})
+
+#define virtnet_xdp_put_sq(vi, q) {                                     \
+	struct netdev_queue *txq;                                       \
+	typeof(vi) v = (vi);                                            \
+									\
+	txq = netdev_get_tx_queue(v->dev, (q) - v->sq);                 \
+	if (v->curr_queue_pairs > nr_cpu_ids)                           \
+		__netif_tx_release(txq);                                \
+	else                                                            \
+		__netif_tx_unlock(txq);                                 \
 }
 
 static int virtnet_xdp_xmit(struct net_device *dev,
@@ -516,7 +548,7 @@ static int virtnet_xdp_xmit(struct net_device *dev,
 	if (!xdp_prog)
 		return -ENXIO;
 
-	sq = virtnet_xdp_sq(vi);
+	sq = virtnet_xdp_get_sq(vi);
 
 	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK)) {
 		ret = -EINVAL;
@@ -564,12 +596,13 @@ out:
 	sq->stats.kicks += kicks;
 	u64_stats_update_end(&sq->stats.syncp);
 
+	virtnet_xdp_put_sq(vi, sq);
 	return ret;
 }
 
 static unsigned int virtnet_get_headroom(struct virtnet_info *vi)
 {
-	return vi->xdp_queue_pairs ? VIRTIO_XDP_HEADROOM : 0;
+	return vi->xdp_enabled ? VIRTIO_XDP_HEADROOM : 0;
 }
 
 /* We copy the packet for XDP in the following cases:
@@ -1458,12 +1491,13 @@ static int virtnet_poll(struct napi_struct *napi, int budget)
 		xdp_do_flush_map();
 
 	if (xdp_xmit & VIRTIO_XDP_TX) {
-		sq = virtnet_xdp_sq(vi);
+		sq = virtnet_xdp_get_sq(vi);
 		if (virtqueue_kick_prepare(sq->vq) && virtqueue_notify(sq->vq)) {
 			u64_stats_update_begin(&sq->stats.syncp);
 			sq->stats.kicks++;
 			u64_stats_update_end(&sq->stats.syncp);
 		}
+		virtnet_xdp_put_sq(vi, sq);
 	}
 
 	return received;
@@ -2480,10 +2514,9 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 
 	/* XDP requires extra queues for XDP_TX */
 	if (curr_qp + xdp_qp > vi->max_queue_pairs) {
-		NL_SET_ERR_MSG_MOD(extack, "Too few free TX rings available");
-		netdev_warn(dev, "request %i queues but max is %i\n",
+		netdev_warn(dev, "XDP request %i queues but max is %i. XDP_TX and XDP_REDIRECT will operate in a slower locked tx mode.\n",
 			    curr_qp + xdp_qp, vi->max_queue_pairs);
-		return -ENOMEM;
+		xdp_qp = 0;
 	}
 
 	old_prog = rtnl_dereference(vi->rq[0].xdp_prog);
@@ -2520,11 +2553,14 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 	vi->xdp_queue_pairs = xdp_qp;
 
 	if (prog) {
+		vi->xdp_enabled = true;
 		for (i = 0; i < vi->max_queue_pairs; i++) {
 			rcu_assign_pointer(vi->rq[i].xdp_prog, prog);
 			if (i == 0 && !old_prog)
 				virtnet_clear_guest_offloads(vi);
 		}
+	} else {
+		vi->xdp_enabled = false;
 	}
 
 	for (i = 0; i < vi->max_queue_pairs; i++) {
@@ -2609,7 +2645,7 @@ static int virtnet_set_features(struct net_device *dev,
 	int err;
 
 	if ((dev->features ^ features) & NETIF_F_LRO) {
-		if (vi->xdp_queue_pairs)
+		if (vi->xdp_enabled)
 			return -EBUSY;
 
 		if (features & NETIF_F_LRO)
-- 
2.30.2

