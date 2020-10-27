Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BBCE29B824
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:08:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1799663AbgJ0Pcp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:32:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:49994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1799659AbgJ0Pcn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:32:43 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22B2E206FA;
        Tue, 27 Oct 2020 15:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812762;
        bh=B8lNb6u+SU8W/9LC2gW89z7ougz/1R8+dpodDTiMx98=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Hpmu8+sm70m7sUmXK2RXVuCqSiN2Yu2uT6h0umm1EIFBqtMKTBsJeoREXo3zFQWN
         vu7jxxslJtb5tnh9YBg+t+wJfVYV9HHoA9N+R1zUTvhwK01d0gTijw1VhP5DXVvYOG
         X02xpnHlIGbeJ5RUpueVUXUxcA129a/MoIJ5BqKg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 322/757] mt76: mt7615: move drv_own/fw_own in mt7615_mcu_ops
Date:   Tue, 27 Oct 2020 14:49:32 +0100
Message-Id: <20201027135505.641628980@linuxfoundation.org>
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

[ Upstream commit 186b659c0859704ef3b2fb634a659724f020889a ]

Introduce set_drv_ctrl and set_fw_ctrl function pointers in
mt7615_mcu_ops data structure. This is a preliminary patch to enable
runtime-pm for non-pci chipsets

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7615/mac.c   |   4 +-
 .../net/wireless/mediatek/mt76/mt7615/mcu.c   | 158 +++++++++---------
 .../wireless/mediatek/mt76/mt7615/mt7615.h    |   6 +-
 .../net/wireless/mediatek/mt76/mt7615/pci.c   |   4 +-
 4 files changed, 89 insertions(+), 83 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
index 2be127018df6a..019031d436de8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
@@ -1845,7 +1845,7 @@ void mt7615_pm_wake_work(struct work_struct *work)
 						pm.wake_work);
 	mphy = dev->phy.mt76;
 
-	if (mt7615_driver_own(dev)) {
+	if (mt7615_mcu_set_drv_ctrl(dev)) {
 		dev_err(mphy->dev->dev, "failed to wake device\n");
 		goto out;
 	}
@@ -1944,7 +1944,7 @@ void mt7615_pm_power_save_work(struct work_struct *work)
 		goto out;
 	}
 
-	if (!mt7615_firmware_own(dev))
+	if (!mt7615_mcu_set_fw_ctrl(dev))
 		return;
 out:
 	queue_delayed_work(dev->mt76.wq, &dev->pm.ps_work, delta);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
index bd316dbd9041d..82b6edd7a9f67 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
@@ -324,6 +324,79 @@ int mt7615_rf_wr(struct mt7615_dev *dev, u32 wf, u32 reg, u32 val)
 				   sizeof(req), false);
 }
 
+static void mt7622_trigger_hif_int(struct mt7615_dev *dev, bool en)
+{
+	if (!is_mt7622(&dev->mt76))
+		return;
+
+	regmap_update_bits(dev->infracfg, MT_INFRACFG_MISC,
+			   MT_INFRACFG_MISC_AP2CONN_WAKE,
+			   !en * MT_INFRACFG_MISC_AP2CONN_WAKE);
+}
+
+static int mt7615_mcu_drv_pmctrl(struct mt7615_dev *dev)
+{
+	struct mt76_phy *mphy = &dev->mt76.phy;
+	struct mt76_dev *mdev = &dev->mt76;
+	int i;
+
+	if (!test_and_clear_bit(MT76_STATE_PM, &mphy->state))
+		goto out;
+
+	mt7622_trigger_hif_int(dev, true);
+
+	for (i = 0; i < MT7615_DRV_OWN_RETRY_COUNT; i++) {
+		u32 addr;
+
+		addr = is_mt7663(mdev) ? MT_PCIE_DOORBELL_PUSH : MT_CFG_LPCR_HOST;
+		mt76_wr(dev, addr, MT_CFG_LPCR_HOST_DRV_OWN);
+
+		addr = is_mt7663(mdev) ? MT_CONN_HIF_ON_LPCTL : MT_CFG_LPCR_HOST;
+		if (mt76_poll_msec(dev, addr, MT_CFG_LPCR_HOST_FW_OWN, 0, 50))
+			break;
+	}
+
+	mt7622_trigger_hif_int(dev, false);
+
+	if (i == MT7615_DRV_OWN_RETRY_COUNT) {
+		dev_err(mdev->dev, "driver own failed\n");
+		set_bit(MT76_STATE_PM, &mphy->state);
+		return -EIO;
+	}
+
+out:
+	dev->pm.last_activity = jiffies;
+
+	return 0;
+}
+
+static int mt7615_mcu_fw_pmctrl(struct mt7615_dev *dev)
+{
+	struct mt76_phy *mphy = &dev->mt76.phy;
+	int err = 0;
+	u32 addr;
+
+	if (test_and_set_bit(MT76_STATE_PM, &mphy->state))
+		return 0;
+
+	mt7622_trigger_hif_int(dev, true);
+
+	addr = is_mt7663(&dev->mt76) ? MT_CONN_HIF_ON_LPCTL : MT_CFG_LPCR_HOST;
+	mt76_wr(dev, addr, MT_CFG_LPCR_HOST_FW_OWN);
+
+	if (is_mt7622(&dev->mt76) &&
+	    !mt76_poll_msec(dev, addr, MT_CFG_LPCR_HOST_FW_OWN,
+			    MT_CFG_LPCR_HOST_FW_OWN, 300)) {
+		dev_err(dev->mt76.dev, "Timeout for firmware own\n");
+		clear_bit(MT76_STATE_PM, &mphy->state);
+		err = -EIO;
+	}
+
+	mt7622_trigger_hif_int(dev, false);
+
+	return err;
+}
+
 static void
 mt7615_mcu_csa_finish(void *priv, u8 *mac, struct ieee80211_vif *vif)
 {
@@ -1314,6 +1387,8 @@ static const struct mt7615_mcu_ops wtbl_update_ops = {
 	.add_tx_ba = mt7615_mcu_wtbl_tx_ba,
 	.add_rx_ba = mt7615_mcu_wtbl_rx_ba,
 	.sta_add = mt7615_mcu_wtbl_sta_add,
+	.set_drv_ctrl = mt7615_mcu_drv_pmctrl,
+	.set_fw_ctrl = mt7615_mcu_fw_pmctrl,
 };
 
 static int
@@ -1410,6 +1485,8 @@ static const struct mt7615_mcu_ops sta_update_ops = {
 	.add_tx_ba = mt7615_mcu_sta_tx_ba,
 	.add_rx_ba = mt7615_mcu_sta_rx_ba,
 	.sta_add = mt7615_mcu_add_sta,
+	.set_drv_ctrl = mt7615_mcu_drv_pmctrl,
+	.set_fw_ctrl = mt7615_mcu_fw_pmctrl,
 };
 
 static int
@@ -1823,6 +1900,8 @@ static const struct mt7615_mcu_ops uni_update_ops = {
 	.add_tx_ba = mt7615_mcu_uni_tx_ba,
 	.add_rx_ba = mt7615_mcu_uni_rx_ba,
 	.sta_add = mt7615_mcu_uni_add_sta,
+	.set_drv_ctrl = mt7615_mcu_drv_pmctrl,
+	.set_fw_ctrl = mt7615_mcu_fw_pmctrl,
 };
 
 static int mt7615_mcu_send_firmware(struct mt7615_dev *dev, const void *data,
@@ -1895,81 +1974,6 @@ static int mt7615_mcu_start_patch(struct mt7615_dev *dev)
 				   &req, sizeof(req), true);
 }
 
-static void mt7622_trigger_hif_int(struct mt7615_dev *dev, bool en)
-{
-	if (!is_mt7622(&dev->mt76))
-		return;
-
-	regmap_update_bits(dev->infracfg, MT_INFRACFG_MISC,
-			   MT_INFRACFG_MISC_AP2CONN_WAKE,
-			   !en * MT_INFRACFG_MISC_AP2CONN_WAKE);
-}
-
-int mt7615_driver_own(struct mt7615_dev *dev)
-{
-	struct mt76_phy *mphy = &dev->mt76.phy;
-	struct mt76_dev *mdev = &dev->mt76;
-	int i;
-
-	if (!test_and_clear_bit(MT76_STATE_PM, &mphy->state))
-		goto out;
-
-	mt7622_trigger_hif_int(dev, true);
-
-	for (i = 0; i < MT7615_DRV_OWN_RETRY_COUNT; i++) {
-		u32 addr;
-
-		addr = is_mt7663(mdev) ? MT_PCIE_DOORBELL_PUSH : MT_CFG_LPCR_HOST;
-		mt76_wr(dev, addr, MT_CFG_LPCR_HOST_DRV_OWN);
-
-		addr = is_mt7663(mdev) ? MT_CONN_HIF_ON_LPCTL : MT_CFG_LPCR_HOST;
-		if (mt76_poll_msec(dev, addr, MT_CFG_LPCR_HOST_FW_OWN, 0, 50))
-			break;
-	}
-
-	mt7622_trigger_hif_int(dev, false);
-
-	if (i == MT7615_DRV_OWN_RETRY_COUNT) {
-		dev_err(mdev->dev, "driver own failed\n");
-		set_bit(MT76_STATE_PM, &mphy->state);
-		return -EIO;
-	}
-
-out:
-	dev->pm.last_activity = jiffies;
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(mt7615_driver_own);
-
-int mt7615_firmware_own(struct mt7615_dev *dev)
-{
-	struct mt76_phy *mphy = &dev->mt76.phy;
-	int err = 0;
-	u32 addr;
-
-	if (test_and_set_bit(MT76_STATE_PM, &mphy->state))
-		return 0;
-
-	mt7622_trigger_hif_int(dev, true);
-
-	addr = is_mt7663(&dev->mt76) ? MT_CONN_HIF_ON_LPCTL : MT_CFG_LPCR_HOST;
-	mt76_wr(dev, addr, MT_CFG_LPCR_HOST_FW_OWN);
-
-	if (is_mt7622(&dev->mt76) &&
-	    !mt76_poll_msec(dev, addr, MT_CFG_LPCR_HOST_FW_OWN,
-			    MT_CFG_LPCR_HOST_FW_OWN, 300)) {
-		dev_err(dev->mt76.dev, "Timeout for firmware own\n");
-		clear_bit(MT76_STATE_PM, &mphy->state);
-		err = -EIO;
-	}
-
-	mt7622_trigger_hif_int(dev, false);
-
-	return err;
-}
-EXPORT_SYMBOL_GPL(mt7615_firmware_own);
-
 static int mt7615_load_patch(struct mt7615_dev *dev, u32 addr, const char *name)
 {
 	const struct mt7615_patch_hdr *hdr;
@@ -2452,7 +2456,7 @@ int mt7615_mcu_init(struct mt7615_dev *dev)
 
 	dev->mt76.mcu_ops = &mt7615_mcu_ops,
 
-	ret = mt7615_driver_own(dev);
+	ret = mt7615_mcu_drv_pmctrl(dev);
 	if (ret)
 		return ret;
 
@@ -2482,7 +2486,7 @@ EXPORT_SYMBOL_GPL(mt7615_mcu_init);
 void mt7615_mcu_exit(struct mt7615_dev *dev)
 {
 	__mt76_mcu_restart(&dev->mt76);
-	mt7615_firmware_own(dev);
+	mt7615_mcu_set_fw_ctrl(dev);
 	skb_queue_purge(&dev->mt76.mcu.res_q);
 }
 EXPORT_SYMBOL_GPL(mt7615_mcu_exit);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h b/drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h
index 571eadc033a3b..c2e1cfb071a82 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h
@@ -220,6 +220,8 @@ struct mt7615_phy {
 #define mt7615_mcu_add_bss_info(phy, ...) (phy->dev)->mcu_ops->add_bss_info((phy),  __VA_ARGS__)
 #define mt7615_mcu_add_beacon(dev, ...)	(dev)->mcu_ops->add_beacon_offload((dev),  __VA_ARGS__)
 #define mt7615_mcu_set_pm(dev, ...)	(dev)->mcu_ops->set_pm_state((dev),  __VA_ARGS__)
+#define mt7615_mcu_set_drv_ctrl(dev)	(dev)->mcu_ops->set_drv_ctrl((dev))
+#define mt7615_mcu_set_fw_ctrl(dev)	(dev)->mcu_ops->set_fw_ctrl((dev))
 struct mt7615_mcu_ops {
 	int (*add_tx_ba)(struct mt7615_dev *dev,
 			 struct ieee80211_ampdu_params *params,
@@ -238,6 +240,8 @@ struct mt7615_mcu_ops {
 				  struct ieee80211_hw *hw,
 				  struct ieee80211_vif *vif, bool enable);
 	int (*set_pm_state)(struct mt7615_dev *dev, int band, int state);
+	int (*set_drv_ctrl)(struct mt7615_dev *dev);
+	int (*set_fw_ctrl)(struct mt7615_dev *dev);
 };
 
 struct mt7615_dev {
@@ -638,8 +642,6 @@ int mt7615_mcu_set_p2p_oppps(struct ieee80211_hw *hw,
 			     struct ieee80211_vif *vif);
 int mt7615_mcu_set_roc(struct mt7615_phy *phy, struct ieee80211_vif *vif,
 		       struct ieee80211_channel *chan, int duration);
-int mt7615_firmware_own(struct mt7615_dev *dev);
-int mt7615_driver_own(struct mt7615_dev *dev);
 
 int mt7615_init_debugfs(struct mt7615_dev *dev);
 int mt7615_mcu_wait_response(struct mt7615_dev *dev, int cmd, int seq);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/pci.c b/drivers/net/wireless/mediatek/mt76/mt7615/pci.c
index 2328d78e06a10..b9794f8a8df41 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/pci.c
@@ -118,7 +118,7 @@ static int mt7615_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 	if (err)
 		goto restore;
 
-	err = mt7615_firmware_own(dev);
+	err = mt7615_mcu_set_fw_ctrl(dev);
 	if (err)
 		goto restore;
 
@@ -142,7 +142,7 @@ static int mt7615_pci_resume(struct pci_dev *pdev)
 	bool pdma_reset;
 	int i, err;
 
-	err = mt7615_driver_own(dev);
+	err = mt7615_mcu_set_drv_ctrl(dev);
 	if (err < 0)
 		return err;
 
-- 
2.25.1



