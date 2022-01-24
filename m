Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6F0499753
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:27:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377795AbiAXVMv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:12:51 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59086 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446500AbiAXVIe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:08:34 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A937C6142C;
        Mon, 24 Jan 2022 21:08:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F430C340E5;
        Mon, 24 Jan 2022 21:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058513;
        bh=+loTW4ROEUTm1KnXswrf01fFT/KXwETwI7b4IKgZbf4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xb+LyZSkYDBoTJeO87GyDT0uoovvJOojFb4qHzuBow7n+6/zXMutjc/lJFdHe9s+U
         yZ6yqK1jC2BEQNOiaLs9KFsZyUGShONzc0CGx5650dsfaJH/T0MaKmyk7vy/w704Hl
         T4bo3Chi06UFws17se9O2OnN0YVObi478LGEZ/Ew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Yen <leon.yen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0314/1039] mt76: mt7921s: fix the device cannot sleep deeply in suspend
Date:   Mon, 24 Jan 2022 19:35:03 +0100
Message-Id: <20220124184135.855240081@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit 5ad4faca7690a88b4529238c757b6b8ead8056ec ]

According to the MT7921S firmware, the cmd MCU_UNI_CMD_HIF_CTRL have to
be last MCU command to execute in suspend handler and all data traffic
have to be stopped before the cmd MCU_UNI_CMD_HIF_CTRL starts as well
in order that mt7921 can successfully fall into the deep sleep mode.

Where we reuse the flag MT76_STATE_SUSPEND and avoid creating
another global flag to stop all of the traffic onto the SDIO bus.

Fixes: 48fab5bbef40 ("mt76: mt7921: introduce mt7921s support")
Reported-by: Leon Yen <leon.yen@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/mediatek/mt76/mt76_connac_mcu.c  |  2 +-
 .../net/wireless/mediatek/mt76/mt7921/main.c  |  3 --
 .../net/wireless/mediatek/mt76/mt7921/sdio.c  | 34 ++++++++++++-------
 drivers/net/wireless/mediatek/mt76/sdio.c     |  3 +-
 .../net/wireless/mediatek/mt76/sdio_txrx.c    |  3 +-
 5 files changed, 27 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
index 26b4b875dcc02..61c4c86e79c88 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
@@ -2461,7 +2461,7 @@ void mt76_connac_mcu_set_suspend_iter(void *priv, u8 *mac,
 				      struct ieee80211_vif *vif)
 {
 	struct mt76_phy *phy = priv;
-	bool suspend = test_bit(MT76_STATE_SUSPEND, &phy->state);
+	bool suspend = !test_bit(MT76_STATE_RUNNING, &phy->state);
 	struct ieee80211_hw *hw = phy->hw;
 	struct cfg80211_wowlan *wowlan = hw->wiphy->wowlan_config;
 	int i;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index e022251b40069..0b2a6b7f22eae 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -1242,8 +1242,6 @@ static int mt7921_suspend(struct ieee80211_hw *hw,
 	mt7921_mutex_acquire(dev);
 
 	clear_bit(MT76_STATE_RUNNING, &phy->mt76->state);
-
-	set_bit(MT76_STATE_SUSPEND, &phy->mt76->state);
 	ieee80211_iterate_active_interfaces(hw,
 					    IEEE80211_IFACE_ITER_RESUME_ALL,
 					    mt76_connac_mcu_set_suspend_iter,
@@ -1262,7 +1260,6 @@ static int mt7921_resume(struct ieee80211_hw *hw)
 	mt7921_mutex_acquire(dev);
 
 	set_bit(MT76_STATE_RUNNING, &phy->mt76->state);
-	clear_bit(MT76_STATE_SUSPEND, &phy->mt76->state);
 	ieee80211_iterate_active_interfaces(hw,
 					    IEEE80211_IFACE_ITER_RESUME_ALL,
 					    mt76_connac_mcu_set_suspend_iter,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/sdio.c b/drivers/net/wireless/mediatek/mt76/mt7921/sdio.c
index 5fee489c7a998..5c88b6b8d0979 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/sdio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/sdio.c
@@ -206,6 +206,8 @@ static int mt7921s_suspend(struct device *__dev)
 	int err;
 
 	pm->suspended = true;
+	set_bit(MT76_STATE_SUSPEND, &mdev->phy.state);
+
 	cancel_delayed_work_sync(&pm->ps_work);
 	cancel_work_sync(&pm->wake_work);
 
@@ -213,10 +215,6 @@ static int mt7921s_suspend(struct device *__dev)
 	if (err < 0)
 		goto restore_suspend;
 
-	err = mt76_connac_mcu_set_hif_suspend(mdev, true);
-	if (err)
-		goto restore_suspend;
-
 	/* always enable deep sleep during suspend to reduce
 	 * power consumption
 	 */
@@ -224,34 +222,45 @@ static int mt7921s_suspend(struct device *__dev)
 
 	mt76_txq_schedule_all(&dev->mphy);
 	mt76_worker_disable(&mdev->tx_worker);
-	mt76_worker_disable(&mdev->sdio.txrx_worker);
 	mt76_worker_disable(&mdev->sdio.status_worker);
-	mt76_worker_disable(&mdev->sdio.net_worker);
 	cancel_work_sync(&mdev->sdio.stat_work);
 	clear_bit(MT76_READING_STATS, &dev->mphy.state);
-
 	mt76_tx_status_check(mdev, true);
 
-	err = mt7921_mcu_fw_pmctrl(dev);
+	mt76_worker_schedule(&mdev->sdio.txrx_worker);
+	wait_event_timeout(dev->mt76.sdio.wait,
+			   mt76s_txqs_empty(&dev->mt76), 5 * HZ);
+
+	/* It is supposed that SDIO bus is idle at the point */
+	err = mt76_connac_mcu_set_hif_suspend(mdev, true);
 	if (err)
 		goto restore_worker;
 
+	mt76_worker_disable(&mdev->sdio.txrx_worker);
+	mt76_worker_disable(&mdev->sdio.net_worker);
+
+	err = mt7921_mcu_fw_pmctrl(dev);
+	if (err)
+		goto restore_txrx_worker;
+
 	sdio_set_host_pm_flags(func, MMC_PM_KEEP_POWER);
 
 	return 0;
 
+restore_txrx_worker:
+	mt76_worker_enable(&mdev->sdio.net_worker);
+	mt76_worker_enable(&mdev->sdio.txrx_worker);
+	mt76_connac_mcu_set_hif_suspend(mdev, false);
+
 restore_worker:
 	mt76_worker_enable(&mdev->tx_worker);
-	mt76_worker_enable(&mdev->sdio.txrx_worker);
 	mt76_worker_enable(&mdev->sdio.status_worker);
-	mt76_worker_enable(&mdev->sdio.net_worker);
 
 	if (!pm->ds_enable)
 		mt76_connac_mcu_set_deep_sleep(mdev, false);
 
-	mt76_connac_mcu_set_hif_suspend(mdev, false);
-
 restore_suspend:
+	clear_bit(MT76_STATE_SUSPEND, &mdev->phy.state);
 	pm->suspended = false;
 
 	return err;
@@ -266,6 +275,7 @@ static int mt7921s_resume(struct device *__dev)
 	int err;
 
 	pm->suspended = false;
+	clear_bit(MT76_STATE_SUSPEND, &mdev->phy.state);
 
 	err = mt7921_mcu_drv_pmctrl(dev);
 	if (err < 0)
diff --git a/drivers/net/wireless/mediatek/mt76/sdio.c b/drivers/net/wireless/mediatek/mt76/sdio.c
index c99acc21225e1..b0bc7be0fb1fc 100644
--- a/drivers/net/wireless/mediatek/mt76/sdio.c
+++ b/drivers/net/wireless/mediatek/mt76/sdio.c
@@ -479,7 +479,8 @@ static void mt76s_status_worker(struct mt76_worker *w)
 			resched = true;
 
 		if (dev->drv->tx_status_data &&
-		    !test_and_set_bit(MT76_READING_STATS, &dev->phy.state))
+		    !test_and_set_bit(MT76_READING_STATS, &dev->phy.state) &&
+		    !test_bit(MT76_STATE_SUSPEND, &dev->phy.state))
 			queue_work(dev->wq, &dev->sdio.stat_work);
 	} while (nframes > 0);
 
diff --git a/drivers/net/wireless/mediatek/mt76/sdio_txrx.c b/drivers/net/wireless/mediatek/mt76/sdio_txrx.c
index 649a56790b89d..801590a0a334f 100644
--- a/drivers/net/wireless/mediatek/mt76/sdio_txrx.c
+++ b/drivers/net/wireless/mediatek/mt76/sdio_txrx.c
@@ -317,7 +317,8 @@ void mt76s_txrx_worker(struct mt76_sdio *sdio)
 		if (ret > 0)
 			nframes += ret;
 
-		if (test_bit(MT76_MCU_RESET, &dev->phy.state)) {
+		if (test_bit(MT76_MCU_RESET, &dev->phy.state) ||
+		    test_bit(MT76_STATE_SUSPEND, &dev->phy.state)) {
 			if (!mt76s_txqs_empty(dev))
 				continue;
 			else
-- 
2.34.1



