Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 996B773F05
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728588AbfGXTed (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:34:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:56984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728514AbfGXTec (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:34:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 678BB20659;
        Wed, 24 Jul 2019 19:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563996870;
        bh=9aeB6NRZVdSP5RGshcwkg63BhAw+StrHy+O20RXgD+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wFhSbnlL+hBaQmabA5Odx06+P9naOC6+yZV+ENJPkkP65UJvb2rDxh0qgicVTQWAP
         9y8cuSsGVkjE2GgSKWVHB8Lx8yK5vEIvMdeOZhdgHZc2JQ+SfGDDuN+PvwR0j3bid3
         hLal4LGglm46USyHAfVJwK4HGzLltWNIBykG7p10=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 244/413] net: hns3: fix __QUEUE_STATE_STACK_XOFF not cleared issue
Date:   Wed, 24 Jul 2019 21:18:55 +0200
Message-Id: <20190724191752.917807392@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit f96315f2f17e7b2580d2fec7c4d6a706a131d904 ]

When change MTU or other operations, which just calling .reset_notify
to do HNAE3_DOWN_CLIENT and HNAE3_UP_CLIENT, then
the netdev_tx_reset_queue() in the hns3_clear_all_ring() will be
ignored. So the dev_watchdog() may misdiagnose a TX timeout.

This patch separates netdev_tx_reset_queue() from
hns3_clear_all_ring(), and unifies hns3_clear_all_ring() and
hns3_force_clear_all_ring into one, since they are doing
similar things.

Fixes: 3a30964a2eef ("net: hns3: delay ring buffer clearing during reset")
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 54 +++++++++----------
 1 file changed, 26 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index e0d3e2f9801d..66b691b7221f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -27,8 +27,7 @@
 #define hns3_set_field(origin, shift, val)	((origin) |= ((val) << (shift)))
 #define hns3_tx_bd_count(S)	DIV_ROUND_UP(S, HNS3_MAX_BD_SIZE)
 
-static void hns3_clear_all_ring(struct hnae3_handle *h);
-static void hns3_force_clear_all_ring(struct hnae3_handle *h);
+static void hns3_clear_all_ring(struct hnae3_handle *h, bool force);
 static void hns3_remove_hw_addr(struct net_device *netdev);
 
 static const char hns3_driver_name[] = "hns3";
@@ -466,6 +465,20 @@ static int hns3_nic_net_open(struct net_device *netdev)
 	return 0;
 }
 
+static void hns3_reset_tx_queue(struct hnae3_handle *h)
+{
+	struct net_device *ndev = h->kinfo.netdev;
+	struct hns3_nic_priv *priv = netdev_priv(ndev);
+	struct netdev_queue *dev_queue;
+	u32 i;
+
+	for (i = 0; i < h->kinfo.num_tqps; i++) {
+		dev_queue = netdev_get_tx_queue(ndev,
+						priv->ring_data[i].queue_index);
+		netdev_tx_reset_queue(dev_queue);
+	}
+}
+
 static void hns3_nic_net_down(struct net_device *netdev)
 {
 	struct hns3_nic_priv *priv = netdev_priv(netdev);
@@ -496,7 +509,9 @@ static void hns3_nic_net_down(struct net_device *netdev)
 	 * to disable the ring through firmware when downing the netdev.
 	 */
 	if (!hns3_nic_resetting(netdev))
-		hns3_clear_all_ring(priv->ae_handle);
+		hns3_clear_all_ring(priv->ae_handle, false);
+
+	hns3_reset_tx_queue(priv->ae_handle);
 }
 
 static int hns3_nic_net_stop(struct net_device *netdev)
@@ -3888,7 +3903,7 @@ static void hns3_client_uninit(struct hnae3_handle *handle, bool reset)
 
 	hns3_del_all_fd_rules(netdev, true);
 
-	hns3_force_clear_all_ring(handle);
+	hns3_clear_all_ring(handle, true);
 
 	hns3_uninit_phy(netdev);
 
@@ -4060,43 +4075,26 @@ static void hns3_force_clear_rx_ring(struct hns3_enet_ring *ring)
 	}
 }
 
-static void hns3_force_clear_all_ring(struct hnae3_handle *h)
-{
-	struct net_device *ndev = h->kinfo.netdev;
-	struct hns3_nic_priv *priv = netdev_priv(ndev);
-	struct hns3_enet_ring *ring;
-	u32 i;
-
-	for (i = 0; i < h->kinfo.num_tqps; i++) {
-		ring = priv->ring_data[i].ring;
-		hns3_clear_tx_ring(ring);
-
-		ring = priv->ring_data[i + h->kinfo.num_tqps].ring;
-		hns3_force_clear_rx_ring(ring);
-	}
-}
-
-static void hns3_clear_all_ring(struct hnae3_handle *h)
+static void hns3_clear_all_ring(struct hnae3_handle *h, bool force)
 {
 	struct net_device *ndev = h->kinfo.netdev;
 	struct hns3_nic_priv *priv = netdev_priv(ndev);
 	u32 i;
 
 	for (i = 0; i < h->kinfo.num_tqps; i++) {
-		struct netdev_queue *dev_queue;
 		struct hns3_enet_ring *ring;
 
 		ring = priv->ring_data[i].ring;
 		hns3_clear_tx_ring(ring);
-		dev_queue = netdev_get_tx_queue(ndev,
-						priv->ring_data[i].queue_index);
-		netdev_tx_reset_queue(dev_queue);
 
 		ring = priv->ring_data[i + h->kinfo.num_tqps].ring;
 		/* Continue to clear other rings even if clearing some
 		 * rings failed.
 		 */
-		hns3_clear_rx_ring(ring);
+		if (force)
+			hns3_force_clear_rx_ring(ring);
+		else
+			hns3_clear_rx_ring(ring);
 	}
 }
 
@@ -4305,8 +4303,8 @@ static int hns3_reset_notify_uninit_enet(struct hnae3_handle *handle)
 		return 0;
 	}
 
-	hns3_clear_all_ring(handle);
-	hns3_force_clear_all_ring(handle);
+	hns3_clear_all_ring(handle, true);
+	hns3_reset_tx_queue(priv->ae_handle);
 
 	hns3_nic_uninit_vector_data(priv);
 
-- 
2.20.1



