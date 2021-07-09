Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A14D3C24F3
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 15:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233134AbhGINZ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 09:25:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:58168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232827AbhGINZk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 09:25:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1142D608FE;
        Fri,  9 Jul 2021 13:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625836976;
        bh=XO8Yp9PMQsY+qQaDyXNPeu9TgoSo09TtmnbfGiiU2U8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s6B6hucw1ePYXokEs48GyawDg8/PF3Fe85ndnZbleZ7by1RdRcEr17O7M25+qvIvh
         TgFPofdqgRUonHUnRr0LRVBSa8yD5L54m91HfMYcCQaOPtZyhKQJI8eQ2Ht42+bJ7V
         xuFJQ4mSoVzjrdqDSgWRmNFAYbDdRzD5ITt+YYas=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Deren Wu <Deren.Wu@mediatek.com>
Subject: [PATCH 5.12 09/11] mt76: mt7921: add wifi reset support
Date:   Fri,  9 Jul 2021 15:21:46 +0200
Message-Id: <20210709131602.257415100@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210709131549.679160341@linuxfoundation.org>
References: <20210709131549.679160341@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

commit 0c1ce988460765ece1ba8eacd00533eefb6e666a upstream.

Introduce wifi chip reset support for mt7921 device to recover mcu
hangs.

Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Cc: Deren Wu <Deren.Wu@mediatek.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/mediatek/mt76/mt7921/init.c   |    3 
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c    |  203 +++++++++++++++------
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    |    3 
 drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h |    4 
 drivers/net/wireless/mediatek/mt76/mt7921/regs.h   |    4 
 5 files changed, 156 insertions(+), 61 deletions(-)

--- a/drivers/net/wireless/mediatek/mt76/mt7921/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/init.c
@@ -142,7 +142,7 @@ mt7921_mac_init_band(struct mt7921_dev *
 	mt76_clear(dev, MT_DMA_DCR0(band), MT_DMA_DCR0_RXD_G5_EN);
 }
 
-static void mt7921_mac_init(struct mt7921_dev *dev)
+void mt7921_mac_init(struct mt7921_dev *dev)
 {
 	int i;
 
@@ -232,7 +232,6 @@ int mt7921_register_device(struct mt7921
 	INIT_LIST_HEAD(&dev->sta_poll_list);
 	spin_lock_init(&dev->sta_poll_lock);
 
-	init_waitqueue_head(&dev->reset_wait);
 	INIT_WORK(&dev->reset_work, mt7921_mac_reset_work);
 
 	ret = mt7921_init_hardware(dev);
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
@@ -1184,43 +1184,77 @@ void mt7921_update_channel(struct mt76_d
 	mt76_connac_power_save_sched(&dev->mphy, &dev->pm);
 }
 
-static bool
-mt7921_wait_reset_state(struct mt7921_dev *dev, u32 state)
+static int
+mt7921_wfsys_reset(struct mt7921_dev *dev)
 {
-	bool ret;
+	mt76_set(dev, 0x70002600, BIT(0));
+	msleep(200);
+	mt76_clear(dev, 0x70002600, BIT(0));
 
-	ret = wait_event_timeout(dev->reset_wait,
-				 (READ_ONCE(dev->reset_state) & state),
-				 MT7921_RESET_TIMEOUT);
-
-	WARN(!ret, "Timeout waiting for MCU reset state %x\n", state);
-	return ret;
+	return __mt76_poll_msec(&dev->mt76, MT_WFSYS_SW_RST_B,
+				WFSYS_SW_INIT_DONE, WFSYS_SW_INIT_DONE, 500);
 }
 
 static void
-mt7921_dma_reset(struct mt7921_phy *phy)
+mt7921_dma_reset(struct mt7921_dev *dev)
 {
-	struct mt7921_dev *dev = phy->dev;
 	int i;
 
-	mt76_clear(dev, MT_WFDMA0_GLO_CFG,
-		   MT_WFDMA0_GLO_CFG_TX_DMA_EN | MT_WFDMA0_GLO_CFG_RX_DMA_EN);
+	/* reset */
+	mt76_clear(dev, MT_WFDMA0_RST,
+		   MT_WFDMA0_RST_DMASHDL_ALL_RST | MT_WFDMA0_RST_LOGIC_RST);
+
+	mt76_set(dev, MT_WFDMA0_RST,
+		 MT_WFDMA0_RST_DMASHDL_ALL_RST | MT_WFDMA0_RST_LOGIC_RST);
 
-	usleep_range(1000, 2000);
+	/* disable WFDMA0 */
+	mt76_clear(dev, MT_WFDMA0_GLO_CFG,
+		   MT_WFDMA0_GLO_CFG_TX_DMA_EN | MT_WFDMA0_GLO_CFG_RX_DMA_EN |
+		   MT_WFDMA0_GLO_CFG_CSR_DISP_BASE_PTR_CHAIN_EN |
+		   MT_WFDMA0_GLO_CFG_OMIT_TX_INFO |
+		   MT_WFDMA0_GLO_CFG_OMIT_RX_INFO |
+		   MT_WFDMA0_GLO_CFG_OMIT_RX_INFO_PFET2);
+
+	mt76_poll(dev, MT_WFDMA0_GLO_CFG,
+		  MT_WFDMA0_GLO_CFG_TX_DMA_BUSY |
+		  MT_WFDMA0_GLO_CFG_RX_DMA_BUSY, 0, 1000);
 
-	mt76_queue_tx_cleanup(dev, dev->mt76.q_mcu[MT_MCUQ_WA], true);
+	/* reset hw queues */
 	for (i = 0; i < __MT_TXQ_MAX; i++)
-		mt76_queue_tx_cleanup(dev, phy->mt76->q_tx[i], true);
+		mt76_queue_reset(dev, dev->mphy.q_tx[i]);
 
-	mt76_for_each_q_rx(&dev->mt76, i) {
-		mt76_queue_rx_reset(dev, i);
-	}
+	for (i = 0; i < __MT_MCUQ_MAX; i++)
+		mt76_queue_reset(dev, dev->mt76.q_mcu[i]);
 
-	/* re-init prefetch settings after reset */
+	mt76_for_each_q_rx(&dev->mt76, i)
+		mt76_queue_reset(dev, &dev->mt76.q_rx[i]);
+
+	/* configure perfetch settings */
 	mt7921_dma_prefetch(dev);
 
+	/* reset dma idx */
+	mt76_wr(dev, MT_WFDMA0_RST_DTX_PTR, ~0);
+
+	/* configure delay interrupt */
+	mt76_wr(dev, MT_WFDMA0_PRI_DLY_INT_CFG0, 0);
+
+	mt76_set(dev, MT_WFDMA0_GLO_CFG,
+		 MT_WFDMA0_GLO_CFG_TX_WB_DDONE |
+		 MT_WFDMA0_GLO_CFG_FIFO_LITTLE_ENDIAN |
+		 MT_WFDMA0_GLO_CFG_CLK_GAT_DIS |
+		 MT_WFDMA0_GLO_CFG_OMIT_TX_INFO |
+		 MT_WFDMA0_GLO_CFG_CSR_DISP_BASE_PTR_CHAIN_EN |
+		 MT_WFDMA0_GLO_CFG_OMIT_RX_INFO_PFET2);
+
 	mt76_set(dev, MT_WFDMA0_GLO_CFG,
 		 MT_WFDMA0_GLO_CFG_TX_DMA_EN | MT_WFDMA0_GLO_CFG_RX_DMA_EN);
+
+	mt76_set(dev, 0x54000120, BIT(1));
+
+	/* enable interrupts for TX/RX rings */
+	mt7921_irq_enable(dev,
+			  MT_INT_RX_DONE_ALL | MT_INT_TX_DONE_ALL |
+			  MT_INT_MCU_CMD);
 }
 
 void mt7921_tx_token_put(struct mt7921_dev *dev)
@@ -1244,71 +1278,125 @@ void mt7921_tx_token_put(struct mt7921_d
 	idr_destroy(&dev->token);
 }
 
-/* system error recovery */
-void mt7921_mac_reset_work(struct work_struct *work)
+static void
+mt7921_vif_connect_iter(void *priv, u8 *mac,
+			struct ieee80211_vif *vif)
 {
-	struct mt7921_dev *dev;
+	struct mt7921_vif *mvif = (struct mt7921_vif *)vif->drv_priv;
+	struct mt7921_dev *dev = mvif->phy->dev;
 
-	dev = container_of(work, struct mt7921_dev, reset_work);
+	ieee80211_disconnect(vif, true);
 
-	if (!(READ_ONCE(dev->reset_state) & MT_MCU_CMD_STOP_DMA))
-		return;
+	mt76_connac_mcu_uni_add_dev(&dev->mphy, vif, &mvif->sta.wcid, true);
+	mt7921_mcu_set_tx(dev, vif);
+}
+
+static int
+mt7921_mac_reset(struct mt7921_dev *dev)
+{
+	int i, err;
 
-	ieee80211_stop_queues(mt76_hw(dev));
+	mt76_connac_free_pending_tx_skbs(&dev->pm, NULL);
+
+	mt76_wr(dev, MT_WFDMA0_HOST_INT_ENA, 0);
+	mt76_wr(dev, MT_PCIE_MAC_INT_ENABLE, 0x0);
 
-	set_bit(MT76_RESET, &dev->mphy.state);
 	set_bit(MT76_MCU_RESET, &dev->mphy.state);
 	wake_up(&dev->mt76.mcu.wait);
-	cancel_delayed_work_sync(&dev->mphy.mac_work);
+	skb_queue_purge(&dev->mt76.mcu.res_q);
 
-	/* lock/unlock all queues to ensure that no tx is pending */
 	mt76_txq_schedule_all(&dev->mphy);
 
 	mt76_worker_disable(&dev->mt76.tx_worker);
-	napi_disable(&dev->mt76.napi[0]);
-	napi_disable(&dev->mt76.napi[1]);
-	napi_disable(&dev->mt76.napi[2]);
+	napi_disable(&dev->mt76.napi[MT_RXQ_MAIN]);
+	napi_disable(&dev->mt76.napi[MT_RXQ_MCU]);
+	napi_disable(&dev->mt76.napi[MT_RXQ_MCU_WA]);
 	napi_disable(&dev->mt76.tx_napi);
 
-	mt7921_mutex_acquire(dev);
-
-	mt76_wr(dev, MT_MCU_INT_EVENT, MT_MCU_INT_EVENT_DMA_STOPPED);
-
 	mt7921_tx_token_put(dev);
 	idr_init(&dev->token);
 
-	if (mt7921_wait_reset_state(dev, MT_MCU_CMD_RESET_DONE)) {
-		mt7921_dma_reset(&dev->phy);
+	/* clean up hw queues */
+	for (i = 0; i < ARRAY_SIZE(dev->mt76.phy.q_tx); i++)
+		mt76_queue_tx_cleanup(dev, dev->mphy.q_tx[i], true);
 
-		mt76_wr(dev, MT_MCU_INT_EVENT, MT_MCU_INT_EVENT_DMA_INIT);
-		mt7921_wait_reset_state(dev, MT_MCU_CMD_RECOVERY_DONE);
-	}
+	for (i = 0; i < ARRAY_SIZE(dev->mt76.q_mcu); i++)
+		mt76_queue_tx_cleanup(dev, dev->mt76.q_mcu[i], true);
 
-	clear_bit(MT76_MCU_RESET, &dev->mphy.state);
-	clear_bit(MT76_RESET, &dev->mphy.state);
+	mt76_for_each_q_rx(&dev->mt76, i)
+		mt76_queue_rx_cleanup(dev, &dev->mt76.q_rx[i]);
+
+	mt7921_wfsys_reset(dev);
+	mt7921_dma_reset(dev);
+
+	mt76_for_each_q_rx(&dev->mt76, i) {
+		mt76_queue_rx_reset(dev, i);
+		napi_enable(&dev->mt76.napi[i]);
+		napi_schedule(&dev->mt76.napi[i]);
+	}
 
-	mt76_worker_enable(&dev->mt76.tx_worker);
 	napi_enable(&dev->mt76.tx_napi);
 	napi_schedule(&dev->mt76.tx_napi);
+	mt76_worker_enable(&dev->mt76.tx_worker);
 
-	napi_enable(&dev->mt76.napi[0]);
-	napi_schedule(&dev->mt76.napi[0]);
+	clear_bit(MT76_MCU_RESET, &dev->mphy.state);
 
-	napi_enable(&dev->mt76.napi[1]);
-	napi_schedule(&dev->mt76.napi[1]);
+	mt76_wr(dev, MT_WFDMA0_HOST_INT_ENA, 0);
+	mt76_wr(dev, MT_PCIE_MAC_INT_ENABLE, 0xff);
+	mt7921_irq_enable(dev,
+			  MT_INT_RX_DONE_ALL | MT_INT_TX_DONE_ALL |
+			  MT_INT_MCU_CMD);
 
-	napi_enable(&dev->mt76.napi[2]);
-	napi_schedule(&dev->mt76.napi[2]);
+	err = mt7921_run_firmware(dev);
+	if (err)
+		return err;
 
-	ieee80211_wake_queues(mt76_hw(dev));
+	err = mt7921_mcu_set_eeprom(dev);
+	if (err)
+		return err;
 
-	mt76_wr(dev, MT_MCU_INT_EVENT, MT_MCU_INT_EVENT_RESET_DONE);
-	mt7921_wait_reset_state(dev, MT_MCU_CMD_NORMAL_STATE);
+	mt7921_mac_init(dev);
+	return __mt7921_start(&dev->phy);
+}
 
-	mt7921_mutex_release(dev);
+/* system error recovery */
+void mt7921_mac_reset_work(struct work_struct *work)
+{
+	struct ieee80211_hw *hw;
+	struct mt7921_dev *dev;
+	int i;
 
-	ieee80211_queue_delayed_work(mt76_hw(dev), &dev->mphy.mac_work,
-				     MT7921_WATCHDOG_TIME);
+	dev = container_of(work, struct mt7921_dev, reset_work);
+	hw = mt76_hw(dev);
+
+	dev_err(dev->mt76.dev, "chip reset\n");
+	ieee80211_stop_queues(hw);
+
+	cancel_delayed_work_sync(&dev->mphy.mac_work);
+	cancel_delayed_work_sync(&dev->pm.ps_work);
+	cancel_work_sync(&dev->pm.wake_work);
+
+	mutex_lock(&dev->mt76.mutex);
+	for (i = 0; i < 10; i++) {
+		if (!mt7921_mac_reset(dev))
+			break;
+	}
+	mutex_unlock(&dev->mt76.mutex);
+
+	if (i == 10)
+		dev_err(dev->mt76.dev, "chip reset failed\n");
+
+	ieee80211_wake_queues(hw);
+	ieee80211_iterate_active_interfaces(hw,
+					    IEEE80211_IFACE_ITER_RESUME_ALL,
+					    mt7921_vif_connect_iter, 0);
+}
+
+void mt7921_reset(struct mt76_dev *mdev)
+{
+	struct mt7921_dev *dev = container_of(mdev, struct mt7921_dev, mt76);
+
+	queue_work(dev->mt76.wq, &dev->reset_work);
 }
 
 static void
@@ -1505,4 +1593,5 @@ void mt7921_coredump_work(struct work_st
 	}
 	dev_coredumpv(dev->mt76.dev, dump, MT76_CONNAC_COREDUMP_SZ,
 		      GFP_KERNEL);
+	mt7921_reset(&dev->mt76);
 }
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -952,6 +952,7 @@ int mt7921_mcu_init(struct mt7921_dev *d
 		.mcu_skb_send_msg = mt7921_mcu_send_message,
 		.mcu_parse_response = mt7921_mcu_parse_response,
 		.mcu_restart = mt7921_mcu_restart,
+		.mcu_reset = mt7921_reset,
 	};
 
 	dev->mt76.mcu_ops = &mt7921_mcu_ops;
@@ -1269,6 +1270,7 @@ int mt7921_mcu_drv_pmctrl(struct mt7921_
 
 	if (i == MT7921_DRV_OWN_RETRY_COUNT) {
 		dev_err(dev->mt76.dev, "driver own failed\n");
+		mt7921_reset(&dev->mt76);
 		return -EIO;
 	}
 
@@ -1295,6 +1297,7 @@ int mt7921_mcu_fw_pmctrl(struct mt7921_d
 
 	if (i == MT7921_DRV_OWN_RETRY_COUNT) {
 		dev_err(dev->mt76.dev, "firmware own failed\n");
+		mt7921_reset(&dev->mt76);
 		return -EIO;
 	}
 
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
@@ -151,8 +151,6 @@ struct mt7921_dev {
 
 	struct work_struct init_work;
 	struct work_struct reset_work;
-	wait_queue_head_t reset_wait;
-	u32 reset_state;
 
 	struct list_head sta_poll_list;
 	spinlock_t sta_poll_lock;
@@ -283,6 +281,7 @@ mt7921_l1_rmw(struct mt7921_dev *dev, u3
 #define mt7921_l1_set(dev, addr, val)	mt7921_l1_rmw(dev, addr, 0, val)
 #define mt7921_l1_clear(dev, addr, val)	mt7921_l1_rmw(dev, addr, val, 0)
 
+void mt7921_mac_init(struct mt7921_dev *dev);
 bool mt7921_mac_wtbl_update(struct mt7921_dev *dev, int idx, u32 mask);
 void mt7921_mac_reset_counters(struct mt7921_phy *phy);
 void mt7921_mac_write_txwi(struct mt7921_dev *dev, __le32 *txwi,
@@ -298,6 +297,7 @@ void mt7921_mac_sta_remove(struct mt76_d
 			   struct ieee80211_sta *sta);
 void mt7921_mac_work(struct work_struct *work);
 void mt7921_mac_reset_work(struct work_struct *work);
+void mt7921_reset(struct mt76_dev *mdev);
 int mt7921_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 			  enum mt76_txq_id qid, struct mt76_wcid *wcid,
 			  struct ieee80211_sta *sta,
--- a/drivers/net/wireless/mediatek/mt76/mt7921/regs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/regs.h
@@ -418,6 +418,10 @@
 #define PCIE_LPCR_HOST_CLR_OWN		BIT(1)
 #define PCIE_LPCR_HOST_SET_OWN		BIT(0)
 
+#define MT_WFSYS_SW_RST_B		0x18000140
+#define WFSYS_SW_RST_B			BIT(0)
+#define WFSYS_SW_INIT_DONE		BIT(4)
+
 #define MT_CONN_ON_MISC			0x7c0600f0
 #define MT_TOP_MISC2_FW_N9_RDY		GENMASK(1, 0)
 


