Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF5E1364292
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239529AbhDSNKJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:10:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:44618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239698AbhDSNJr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:09:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6666961245;
        Mon, 19 Apr 2021 13:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618837757;
        bh=jEukYEUhaFyVfZevnjU1DgH7B2qU4S3Hom0+Adu5m4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KM143fiQsf02Svz69i9XoXbTnOlDbITdd85F/871+C8UiASJripp5GQzBhjNrn6H7
         cLAiWkscOOjOBdDpnsEn7SYO5BWV+DsnaJr0JyoE3QAoU4ccdhZ8kAhG/U2QBR5W0m
         g8Y32pq9I3nxf56OA8xim6IxPXsqhy/n/ouffsfc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Mack <daniel@zonque.org>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 026/122] net: axienet: allow setups without MDIO
Date:   Mon, 19 Apr 2021 15:05:06 +0200
Message-Id: <20210419130531.056140591@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130530.166331793@linuxfoundation.org>
References: <20210419130530.166331793@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Mack <daniel@zonque.org>

[ Upstream commit de9c7854e6e1589f639c6352112956d08243b659 ]

In setups with fixed-link settings there is no mdio node in DTS.
axienet_probe() already handles that gracefully but lp->mii_bus is
then NULL.

Fix code that tries to blindly grab the MDIO lock by introducing two helper
functions that make the locking conditional.

Signed-off-by: Daniel Mack <daniel@zonque.org>
Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/xilinx_axienet.h      | 12 ++++++++++++
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 12 ++++++------
 2 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
index a03c3ca1b28d..9e2cddba3b5b 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
@@ -497,6 +497,18 @@ static inline u32 axinet_ior_read_mcr(struct axienet_local *lp)
 	return axienet_ior(lp, XAE_MDIO_MCR_OFFSET);
 }
 
+static inline void axienet_lock_mii(struct axienet_local *lp)
+{
+	if (lp->mii_bus)
+		mutex_lock(&lp->mii_bus->mdio_lock);
+}
+
+static inline void axienet_unlock_mii(struct axienet_local *lp)
+{
+	if (lp->mii_bus)
+		mutex_unlock(&lp->mii_bus->mdio_lock);
+}
+
 /**
  * axienet_iow - Memory mapped Axi Ethernet register write
  * @lp:         Pointer to axienet local structure
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 4cd701a9277d..82176dd2cdf3 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1053,9 +1053,9 @@ static int axienet_open(struct net_device *ndev)
 	 * including the MDIO. MDIO must be disabled before resetting.
 	 * Hold MDIO bus lock to avoid MDIO accesses during the reset.
 	 */
-	mutex_lock(&lp->mii_bus->mdio_lock);
+	axienet_lock_mii(lp);
 	ret = axienet_device_reset(ndev);
-	mutex_unlock(&lp->mii_bus->mdio_lock);
+	axienet_unlock_mii(lp);
 
 	ret = phylink_of_phy_connect(lp->phylink, lp->dev->of_node, 0);
 	if (ret) {
@@ -1148,9 +1148,9 @@ static int axienet_stop(struct net_device *ndev)
 	}
 
 	/* Do a reset to ensure DMA is really stopped */
-	mutex_lock(&lp->mii_bus->mdio_lock);
+	axienet_lock_mii(lp);
 	__axienet_device_reset(lp);
-	mutex_unlock(&lp->mii_bus->mdio_lock);
+	axienet_unlock_mii(lp);
 
 	cancel_work_sync(&lp->dma_err_task);
 
@@ -1664,9 +1664,9 @@ static void axienet_dma_err_handler(struct work_struct *work)
 	 * including the MDIO. MDIO must be disabled before resetting.
 	 * Hold MDIO bus lock to avoid MDIO accesses during the reset.
 	 */
-	mutex_lock(&lp->mii_bus->mdio_lock);
+	axienet_lock_mii(lp);
 	__axienet_device_reset(lp);
-	mutex_unlock(&lp->mii_bus->mdio_lock);
+	axienet_unlock_mii(lp);
 
 	for (i = 0; i < lp->tx_bd_num; i++) {
 		cur_p = &lp->tx_bd_v[i];
-- 
2.30.2



