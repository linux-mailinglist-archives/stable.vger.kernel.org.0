Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B25A337CE62
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240848AbhELRFF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:05:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:35488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244292AbhELQmw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5EF5461D37;
        Wed, 12 May 2021 16:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835924;
        bh=3t3zC9WRI3kaAdmf0rP5FLO3jWmu5QW2X3t2gVj2qhY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LpLXLbxWAgC4oHkgm+EL4WwRFsX/0ugZS+w7vtjrnw7MiYO+bGLjJELstGXGPsK4R
         d+bG7aIMrqiRurQNgB+tTU4+CxDQi0rRfd1ORM0MNPy65wCar17odkreOjRa38bhfl
         xqJ4cXniyYXBrhwxYplUe1p86lVLm2BP0AKPZirc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ryder Lee <ryder.lee@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 540/677] mt76: mt7915: cleanup mcu tx queue in mt7915_dma_reset()
Date:   Wed, 12 May 2021 16:49:46 +0200
Message-Id: <20210512144855.307943288@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ryder Lee <ryder.lee@mediatek.com>

[ Upstream commit 1ebea45ef027ee31cd50ed92903071391e792edb ]

Cleanup mcu queues in mt7915_mac_reset_work().

Fixes: e637763b606b ("mt76: move mcu queues to mt76_dev q_mcu array")
Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
index 555274a2f436..819670767521 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -1470,9 +1470,8 @@ mt7915_update_beacons(struct mt7915_dev *dev)
 }
 
 static void
-mt7915_dma_reset(struct mt7915_phy *phy)
+mt7915_dma_reset(struct mt7915_dev *dev)
 {
-	struct mt7915_dev *dev = phy->dev;
 	struct mt76_phy *mphy_ext = dev->mt76.phy2;
 	u32 hif1_ofs = MT_WFDMA1_PCIE1_BASE - MT_WFDMA1_BASE;
 	int i;
@@ -1489,18 +1488,20 @@ mt7915_dma_reset(struct mt7915_phy *phy)
 			   (MT_WFDMA1_GLO_CFG_TX_DMA_EN |
 			    MT_WFDMA1_GLO_CFG_RX_DMA_EN));
 	}
+
 	usleep_range(1000, 2000);
 
-	mt76_queue_tx_cleanup(dev, dev->mt76.q_mcu[MT_MCUQ_WA], true);
 	for (i = 0; i < __MT_TXQ_MAX; i++) {
-		mt76_queue_tx_cleanup(dev, phy->mt76->q_tx[i], true);
+		mt76_queue_tx_cleanup(dev, dev->mphy.q_tx[i], true);
 		if (mphy_ext)
 			mt76_queue_tx_cleanup(dev, mphy_ext->q_tx[i], true);
 	}
 
-	mt76_for_each_q_rx(&dev->mt76, i) {
+	for (i = 0; i < __MT_MCUQ_MAX; i++)
+		mt76_queue_tx_cleanup(dev, dev->mt76.q_mcu[i], true);
+
+	mt76_for_each_q_rx(&dev->mt76, i)
 		mt76_queue_rx_reset(dev, i);
-	}
 
 	/* re-init prefetch settings after reset */
 	mt7915_dma_prefetch(dev);
@@ -1584,7 +1585,7 @@ void mt7915_mac_reset_work(struct work_struct *work)
 	idr_init(&dev->token);
 
 	if (mt7915_wait_reset_state(dev, MT_MCU_CMD_RESET_DONE)) {
-		mt7915_dma_reset(&dev->phy);
+		mt7915_dma_reset(dev);
 
 		mt76_wr(dev, MT_MCU_INT_EVENT, MT_MCU_INT_EVENT_DMA_INIT);
 		mt7915_wait_reset_state(dev, MT_MCU_CMD_RECOVERY_DONE);
-- 
2.30.2



