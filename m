Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9960973F91
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728541AbfGXT1l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:27:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:45542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728080AbfGXT1l (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:27:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90711218EA;
        Wed, 24 Jul 2019 19:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563996460;
        bh=ED7hnx6HUwGZbqDhY1vz2QqYCp0uzYpIRTHG37mbnTM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RHTtAvvA0nD++bzUkZCYQdmYO69Hp5wrbi/uvi8HOOitT/wDQDcpmGHtPhfd2hYiF
         n3vnkcdwKZXSeyEXya9rT/sRLyS7rsP7VUTOGaZ1OZm3y5xzdaOE9IPm8lAe4sbHJn
         N85TRuYPc597Bcx8LfQKiyU4HZaxe7o1pj+1ILvA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yunsheng Lin <linyunsheng@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 104/413] net: hns3: delay ring buffer clearing during reset
Date:   Wed, 24 Jul 2019 21:16:35 +0200
Message-Id: <20190724191742.693780169@linuxfoundation.org>
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

[ Upstream commit 3a30964a2eef6aabd3ab18b979ea0eacf1147731 ]

The driver may not be able to disable the ring through firmware
when downing the netdev during reset process, which may cause
hardware accessing freed buffer problem.

This patch delays the ring buffer clearing to reset uninit
process because hardware will not access the ring buffer after
hardware reset is completed.

Fixes: bb6b94a896d4 ("net: hns3: Add reset interface implementation in client")
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index d18ad7b48a31..e0d3e2f9801d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -28,7 +28,7 @@
 #define hns3_tx_bd_count(S)	DIV_ROUND_UP(S, HNS3_MAX_BD_SIZE)
 
 static void hns3_clear_all_ring(struct hnae3_handle *h);
-static void hns3_force_clear_all_rx_ring(struct hnae3_handle *h);
+static void hns3_force_clear_all_ring(struct hnae3_handle *h);
 static void hns3_remove_hw_addr(struct net_device *netdev);
 
 static const char hns3_driver_name[] = "hns3";
@@ -491,7 +491,12 @@ static void hns3_nic_net_down(struct net_device *netdev)
 	/* free irq resources */
 	hns3_nic_uninit_irq(priv);
 
-	hns3_clear_all_ring(priv->ae_handle);
+	/* delay ring buffer clearing to hns3_reset_notify_uninit_enet
+	 * during reset process, because driver may not be able
+	 * to disable the ring through firmware when downing the netdev.
+	 */
+	if (!hns3_nic_resetting(netdev))
+		hns3_clear_all_ring(priv->ae_handle);
 }
 
 static int hns3_nic_net_stop(struct net_device *netdev)
@@ -3883,7 +3888,7 @@ static void hns3_client_uninit(struct hnae3_handle *handle, bool reset)
 
 	hns3_del_all_fd_rules(netdev, true);
 
-	hns3_force_clear_all_rx_ring(handle);
+	hns3_force_clear_all_ring(handle);
 
 	hns3_uninit_phy(netdev);
 
@@ -4055,7 +4060,7 @@ static void hns3_force_clear_rx_ring(struct hns3_enet_ring *ring)
 	}
 }
 
-static void hns3_force_clear_all_rx_ring(struct hnae3_handle *h)
+static void hns3_force_clear_all_ring(struct hnae3_handle *h)
 {
 	struct net_device *ndev = h->kinfo.netdev;
 	struct hns3_nic_priv *priv = netdev_priv(ndev);
@@ -4063,6 +4068,9 @@ static void hns3_force_clear_all_rx_ring(struct hnae3_handle *h)
 	u32 i;
 
 	for (i = 0; i < h->kinfo.num_tqps; i++) {
+		ring = priv->ring_data[i].ring;
+		hns3_clear_tx_ring(ring);
+
 		ring = priv->ring_data[i + h->kinfo.num_tqps].ring;
 		hns3_force_clear_rx_ring(ring);
 	}
@@ -4297,7 +4305,8 @@ static int hns3_reset_notify_uninit_enet(struct hnae3_handle *handle)
 		return 0;
 	}
 
-	hns3_force_clear_all_rx_ring(handle);
+	hns3_clear_all_ring(handle);
+	hns3_force_clear_all_ring(handle);
 
 	hns3_nic_uninit_vector_data(priv);
 
-- 
2.20.1



