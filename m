Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79A5327C5E1
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729915AbgI2Ljr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:39:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:34386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730482AbgI2Ljf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:39:35 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A65DD2074A;
        Tue, 29 Sep 2020 11:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379561;
        bh=2Tf3zgpSVukYlNlSee2szXJUKUQnMg6ZoWjteapx+o8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BCCX65KT3S8fyB3HTTsSb2drpYAtyTOEIDhoo8p5qoXHJkYvnqXnw3P3i7HCEf/mR
         jup4DfOucvzx37uFSUdeD+u3Usoj1ZwxN8hbA3r9nH2o/qteyBBNK5SJTmyL3sVFWz
         BFYvbUyOfu6YtaAZfrIYybYb2OorPBHClxJVC7LI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 189/388] net: axienet: Propagate failure of DMA descriptor setup
Date:   Tue, 29 Sep 2020 12:58:40 +0200
Message-Id: <20200929110019.629877089@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andre Przywara <andre.przywara@arm.com>

[ Upstream commit ee44d0b78839b21591501424fd3cb3648cc803b5 ]

When we fail allocating the DMA buffers in axienet_dma_bd_init(), we
report this error, but carry on with initialisation nevertheless.

This leads to a kernel panic when the driver later wants to send a
packet, as it uses uninitialised data structures.

Make the axienet_device_reset() routine return an error value, as it
contains the DMA buffer initialisation. Make sure we propagate the error
up the chain and eventually fail the driver initialisation, to avoid
relying on non-initialised buffers.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 26 ++++++++++++++-----
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 345a795666e92..bb6e52f3bdf9b 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -437,9 +437,10 @@ static void axienet_setoptions(struct net_device *ndev, u32 options)
 	lp->options |= options;
 }
 
-static void __axienet_device_reset(struct axienet_local *lp)
+static int __axienet_device_reset(struct axienet_local *lp)
 {
 	u32 timeout;
+
 	/* Reset Axi DMA. This would reset Axi Ethernet core as well. The reset
 	 * process of Axi DMA takes a while to complete as all pending
 	 * commands/transfers will be flushed or completed during this
@@ -455,9 +456,11 @@ static void __axienet_device_reset(struct axienet_local *lp)
 		if (--timeout == 0) {
 			netdev_err(lp->ndev, "%s: DMA reset timeout!\n",
 				   __func__);
-			break;
+			return -ETIMEDOUT;
 		}
 	}
+
+	return 0;
 }
 
 /**
@@ -470,13 +473,17 @@ static void __axienet_device_reset(struct axienet_local *lp)
  * areconnected to Axi Ethernet reset lines, this in turn resets the Axi
  * Ethernet core. No separate hardware reset is done for the Axi Ethernet
  * core.
+ * Returns 0 on success or a negative error number otherwise.
  */
-static void axienet_device_reset(struct net_device *ndev)
+static int axienet_device_reset(struct net_device *ndev)
 {
 	u32 axienet_status;
 	struct axienet_local *lp = netdev_priv(ndev);
+	int ret;
 
-	__axienet_device_reset(lp);
+	ret = __axienet_device_reset(lp);
+	if (ret)
+		return ret;
 
 	lp->max_frm_size = XAE_MAX_VLAN_FRAME_SIZE;
 	lp->options |= XAE_OPTION_VLAN;
@@ -491,9 +498,11 @@ static void axienet_device_reset(struct net_device *ndev)
 			lp->options |= XAE_OPTION_JUMBO;
 	}
 
-	if (axienet_dma_bd_init(ndev)) {
+	ret = axienet_dma_bd_init(ndev);
+	if (ret) {
 		netdev_err(ndev, "%s: descriptor allocation failed\n",
 			   __func__);
+		return ret;
 	}
 
 	axienet_status = axienet_ior(lp, XAE_RCW1_OFFSET);
@@ -518,6 +527,8 @@ static void axienet_device_reset(struct net_device *ndev)
 	axienet_setoptions(ndev, lp->options);
 
 	netif_trans_update(ndev);
+
+	return 0;
 }
 
 /**
@@ -921,8 +932,9 @@ static int axienet_open(struct net_device *ndev)
 	 */
 	mutex_lock(&lp->mii_bus->mdio_lock);
 	axienet_mdio_disable(lp);
-	axienet_device_reset(ndev);
-	ret = axienet_mdio_enable(lp);
+	ret = axienet_device_reset(ndev);
+	if (ret == 0)
+		ret = axienet_mdio_enable(lp);
 	mutex_unlock(&lp->mii_bus->mdio_lock);
 	if (ret < 0)
 		return ret;
-- 
2.25.1



