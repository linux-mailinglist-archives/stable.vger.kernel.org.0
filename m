Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 863763F651E
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233753AbhHXRK2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:10:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:51264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239632AbhHXRIW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:08:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFA8761A0C;
        Tue, 24 Aug 2021 17:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824408;
        bh=3rnFfFn8f1zA1hhyO0GjMwkdS2GNtCIbod8MnKi4j9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DM7doCgSaNc4VSvXw9rpMDFEG61iJzPQvyIZHGRNS4UdIS2vd9ZfHX7JTSgw2sh7U
         LQnT9GEGbYvyBj1hcaISojMBrjAe0INgDD2voduiZjn3kJ/i2IXWKEdUDc/t87lLJG
         Ftj/7a86ADNamD6vcbG1fxg0zYvftRWzCzNoS0MTXb0tZuoGkWUn1I3e2ohXYjT3FE
         5v7Am3vV2nmyvA2RfFuJNUmFyrlHXgkhKcomqWZ4Jr6xUXXAyU0M1KgXyPQov76OJk
         VoT+TV44Qbc65pGHz0eV8bQ3c46A3bvUOm3QyT3I0CHH6s75M4JHuKuv6L1EFCiUN+
         kXjw3HRdGQvWA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Ivan <ivan@prestigetransportation.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 59/98] virtio-net: use NETIF_F_GRO_HW instead of NETIF_F_LRO
Date:   Tue, 24 Aug 2021 12:58:29 -0400
Message-Id: <20210824165908.709932-60-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165908.709932-1-sashal@kernel.org>
References: <20210824165908.709932-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.61-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.61-rc1
X-KernelTest-Deadline: 2021-08-26T16:58+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>

[ Upstream commit dbcf24d153884439dad30484a0e3f02350692e4c ]

Commit a02e8964eaf92 ("virtio-net: ethtool configurable LRO")
maps LRO to virtio guest offloading features and allows the
administrator to enable and disable those features via ethtool.

This leads to several issues:

- For a device that doesn't support control guest offloads, the "LRO"
  can't be disabled triggering WARN in dev_disable_lro() when turning
  off LRO or when enabling forwarding bridging etc.

- For a device that supports control guest offloads, the guest
  offloads are disabled in cases of bridging, forwarding etc slowing
  down the traffic.

Fix this by using NETIF_F_GRO_HW instead. Though the spec does not
guarantee packets to be re-segmented as the original ones,
we can add that to the spec, possibly with a flag for devices to
differentiate between GRO and LRO.

Further, we never advertised LRO historically before a02e8964eaf92
("virtio-net: ethtool configurable LRO") and so bridged/forwarded
configs effectively always relied on virtio receive offloads behaving
like GRO - thus even if this breaks any configs it is at least not
a regression.

Fixes: a02e8964eaf92 ("virtio-net: ethtool configurable LRO")
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Reported-by: Ivan <ivan@prestigetransportation.com>
Tested-by: Ivan <ivan@prestigetransportation.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/virtio_net.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index a47cf77a0b08..cbe47eed7cc3 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -63,7 +63,7 @@ static const unsigned long guest_offloads[] = {
 	VIRTIO_NET_F_GUEST_CSUM
 };
 
-#define GUEST_OFFLOAD_LRO_MASK ((1ULL << VIRTIO_NET_F_GUEST_TSO4) | \
+#define GUEST_OFFLOAD_GRO_HW_MASK ((1ULL << VIRTIO_NET_F_GUEST_TSO4) | \
 				(1ULL << VIRTIO_NET_F_GUEST_TSO6) | \
 				(1ULL << VIRTIO_NET_F_GUEST_ECN)  | \
 				(1ULL << VIRTIO_NET_F_GUEST_UFO))
@@ -2466,7 +2466,7 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 	        virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_ECN) ||
 		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_UFO) ||
 		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_CSUM))) {
-		NL_SET_ERR_MSG_MOD(extack, "Can't set XDP while host is implementing LRO/CSUM, disable LRO/CSUM first");
+		NL_SET_ERR_MSG_MOD(extack, "Can't set XDP while host is implementing GRO_HW/CSUM, disable GRO_HW/CSUM first");
 		return -EOPNOTSUPP;
 	}
 
@@ -2597,15 +2597,15 @@ static int virtnet_set_features(struct net_device *dev,
 	u64 offloads;
 	int err;
 
-	if ((dev->features ^ features) & NETIF_F_LRO) {
+	if ((dev->features ^ features) & NETIF_F_GRO_HW) {
 		if (vi->xdp_enabled)
 			return -EBUSY;
 
-		if (features & NETIF_F_LRO)
+		if (features & NETIF_F_GRO_HW)
 			offloads = vi->guest_offloads_capable;
 		else
 			offloads = vi->guest_offloads_capable &
-				   ~GUEST_OFFLOAD_LRO_MASK;
+				   ~GUEST_OFFLOAD_GRO_HW_MASK;
 
 		err = virtnet_set_guest_offloads(vi, offloads);
 		if (err)
@@ -3080,9 +3080,9 @@ static int virtnet_probe(struct virtio_device *vdev)
 		dev->features |= NETIF_F_RXCSUM;
 	if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4) ||
 	    virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO6))
-		dev->features |= NETIF_F_LRO;
+		dev->features |= NETIF_F_GRO_HW;
 	if (virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS))
-		dev->hw_features |= NETIF_F_LRO;
+		dev->hw_features |= NETIF_F_GRO_HW;
 
 	dev->vlan_features = dev->features;
 
-- 
2.30.2

