Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ED6629B76B
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:33:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1799671AbgJ0Pcr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:32:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:50056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1799666AbgJ0Pcq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:32:46 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01EA2206FA;
        Tue, 27 Oct 2020 15:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812765;
        bh=fMbqTVsE0deic9wx97G3oUoHDVgRGwpbYVWo6FMQ0zo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y1AGcmL+P6OCYWwHgBqk6cCd5vidb1ew/dZggMmP+Ga9EzENipxELqn1G/aoszTbW
         G4CnHdwVhfasjVzKlkyWqpb/AmQnppNN7dMj9npwMRH7Ypmw07Esvpj94f9VCoSzwb
         k4QxGGuK9tvIfGoZE1ucjqLnFtKyvZcdjrjYRjq0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shayne Chen <shayne.chen@mediatek.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 323/757] mt76: mt7622: fix fw hang on mt7622
Date:   Tue, 27 Oct 2020 14:49:33 +0100
Message-Id: <20201027135505.691365490@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 6892555dbe71ed551d3779aa20747484dc9b6ad5 ]

Set poll timeout to 3s for mt7622 devices in order to avoid fw hangs.
Swap mt7622_trigger_hif_int and doorbell configuration order in
mt7615_mcu_drv_pmctrl routine.
Introduce mt7615_mcu_lp_drv_pmctrl routine to take care of drv_own
configuration for runtime-pm.

Fixes: 08523a2a1db5 ("mt76: mt7615: add mt7615_pm_wake utility routine")
Fixes: 894b7767ec2f ("mt76: mt7615: improve mt7615_driver_own reliability")
Fixes: 757b0e7fd6f4 ("mt76: mt7615: avoid polling in fw_own for mt7663")
Co-developed-by: Shayne Chen <shayne.chen@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Co-developed-by: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7615/mcu.c   | 46 +++++++++++++------
 1 file changed, 32 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
index 82b6edd7a9f67..f42a69ee5635a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
@@ -338,28 +338,46 @@ static int mt7615_mcu_drv_pmctrl(struct mt7615_dev *dev)
 {
 	struct mt76_phy *mphy = &dev->mt76.phy;
 	struct mt76_dev *mdev = &dev->mt76;
-	int i;
+	u32 addr;
+	int err;
 
-	if (!test_and_clear_bit(MT76_STATE_PM, &mphy->state))
-		goto out;
+	addr = is_mt7663(mdev) ? MT_PCIE_DOORBELL_PUSH : MT_CFG_LPCR_HOST;
+	mt76_wr(dev, addr, MT_CFG_LPCR_HOST_DRV_OWN);
 
 	mt7622_trigger_hif_int(dev, true);
 
-	for (i = 0; i < MT7615_DRV_OWN_RETRY_COUNT; i++) {
-		u32 addr;
+	addr = is_mt7663(mdev) ? MT_CONN_HIF_ON_LPCTL : MT_CFG_LPCR_HOST;
+	err = !mt76_poll_msec(dev, addr, MT_CFG_LPCR_HOST_FW_OWN, 0, 3000);
 
-		addr = is_mt7663(mdev) ? MT_PCIE_DOORBELL_PUSH : MT_CFG_LPCR_HOST;
-		mt76_wr(dev, addr, MT_CFG_LPCR_HOST_DRV_OWN);
+	mt7622_trigger_hif_int(dev, false);
 
-		addr = is_mt7663(mdev) ? MT_CONN_HIF_ON_LPCTL : MT_CFG_LPCR_HOST;
-		if (mt76_poll_msec(dev, addr, MT_CFG_LPCR_HOST_FW_OWN, 0, 50))
-			break;
+	if (err) {
+		dev_err(mdev->dev, "driver own failed\n");
+		return -ETIMEDOUT;
 	}
 
-	mt7622_trigger_hif_int(dev, false);
+	clear_bit(MT76_STATE_PM, &mphy->state);
+
+	return 0;
+}
+
+static int mt7615_mcu_lp_drv_pmctrl(struct mt7615_dev *dev)
+{
+	struct mt76_phy *mphy = &dev->mt76.phy;
+	int i;
+
+	if (!test_and_clear_bit(MT76_STATE_PM, &mphy->state))
+		goto out;
+
+	for (i = 0; i < MT7615_DRV_OWN_RETRY_COUNT; i++) {
+		mt76_wr(dev, MT_PCIE_DOORBELL_PUSH, MT_CFG_LPCR_HOST_DRV_OWN);
+		if (mt76_poll_msec(dev, MT_CONN_HIF_ON_LPCTL,
+				   MT_CFG_LPCR_HOST_FW_OWN, 0, 50))
+			break;
+	}
 
 	if (i == MT7615_DRV_OWN_RETRY_COUNT) {
-		dev_err(mdev->dev, "driver own failed\n");
+		dev_err(dev->mt76.dev, "driver own failed\n");
 		set_bit(MT76_STATE_PM, &mphy->state);
 		return -EIO;
 	}
@@ -386,7 +404,7 @@ static int mt7615_mcu_fw_pmctrl(struct mt7615_dev *dev)
 
 	if (is_mt7622(&dev->mt76) &&
 	    !mt76_poll_msec(dev, addr, MT_CFG_LPCR_HOST_FW_OWN,
-			    MT_CFG_LPCR_HOST_FW_OWN, 300)) {
+			    MT_CFG_LPCR_HOST_FW_OWN, 3000)) {
 		dev_err(dev->mt76.dev, "Timeout for firmware own\n");
 		clear_bit(MT76_STATE_PM, &mphy->state);
 		err = -EIO;
@@ -1900,7 +1918,7 @@ static const struct mt7615_mcu_ops uni_update_ops = {
 	.add_tx_ba = mt7615_mcu_uni_tx_ba,
 	.add_rx_ba = mt7615_mcu_uni_rx_ba,
 	.sta_add = mt7615_mcu_uni_add_sta,
-	.set_drv_ctrl = mt7615_mcu_drv_pmctrl,
+	.set_drv_ctrl = mt7615_mcu_lp_drv_pmctrl,
 	.set_fw_ctrl = mt7615_mcu_fw_pmctrl,
 };
 
-- 
2.25.1



