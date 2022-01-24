Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B702E499754
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:27:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390120AbiAXVM5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:12:57 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:60762 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446482AbiAXVIb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:08:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7CBED61361;
        Mon, 24 Jan 2022 21:08:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CEAEC340E5;
        Mon, 24 Jan 2022 21:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058509;
        bh=HXjDHTULbYoyZnnI4A4Z2OtgSDnzKFFpNgxUn8IpImg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JnWj9FJu/MDmrkd4UKwauROOfa4KMSjuQq84Gtg6VMgPO+mrk+E34IllnwgY1DniX
         sVi+h18oUWAIMrt34aXc4liDzU2USJVV715ciA0nELWQi9lTn0y/F9KB0vQpnCopeV
         PEwdJxo8us5FLIccwBafG5KcVjWgXfyL8FqFZLdk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0313/1039] mt76: mt7921: move mt76_connac_mcu_set_hif_suspend to bus-related files
Date:   Mon, 24 Jan 2022 19:35:02 +0100
Message-Id: <20220124184135.825063313@linuxfoundation.org>
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

[ Upstream commit 6906aa93eb93d54a42ce1902f00d6ea04ecb039b ]

This is a preliminary patch for the following patch
("mt76: mt7921s: fix the device cannot sleep deeply in suspend).

mt76_connac_mcu_set_hif_suspend eventually would be handled in each
bus-level suspend/resume handler in either mt7921/sdio.c or mt7921/pci.c
depending on what type of the bus the device is running on. We can move
mt76_connac_mcu_set_hif_suspend to bus-related files to simplify the logic.

Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7921/main.c   | 13 ++-----------
 .../net/wireless/mediatek/mt76/mt7921/pci.c    | 18 +++++-------------
 .../net/wireless/mediatek/mt76/mt7921/sdio.c   | 18 +++++-------------
 3 files changed, 12 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index b144f5491798a..e022251b40069 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -1232,7 +1232,6 @@ static int mt7921_suspend(struct ieee80211_hw *hw,
 {
 	struct mt7921_dev *dev = mt7921_hw_dev(hw);
 	struct mt7921_phy *phy = mt7921_hw_phy(hw);
-	int err;
 
 	cancel_delayed_work_sync(&phy->scan_work);
 	cancel_delayed_work_sync(&phy->mt76->mac_work);
@@ -1250,25 +1249,18 @@ static int mt7921_suspend(struct ieee80211_hw *hw,
 					    mt76_connac_mcu_set_suspend_iter,
 					    &dev->mphy);
 
-	err = mt76_connac_mcu_set_hif_suspend(&dev->mt76, true);
-
 	mt7921_mutex_release(dev);
 
-	return err;
+	return 0;
 }
 
 static int mt7921_resume(struct ieee80211_hw *hw)
 {
 	struct mt7921_dev *dev = mt7921_hw_dev(hw);
 	struct mt7921_phy *phy = mt7921_hw_phy(hw);
-	int err;
 
 	mt7921_mutex_acquire(dev);
 
-	err = mt76_connac_mcu_set_hif_suspend(&dev->mt76, false);
-	if (err < 0)
-		goto out;
-
 	set_bit(MT76_STATE_RUNNING, &phy->mt76->state);
 	clear_bit(MT76_STATE_SUSPEND, &phy->mt76->state);
 	ieee80211_iterate_active_interfaces(hw,
@@ -1278,11 +1270,10 @@ static int mt7921_resume(struct ieee80211_hw *hw)
 
 	ieee80211_queue_delayed_work(hw, &phy->mt76->mac_work,
 				     MT7921_WATCHDOG_TIME);
-out:
 
 	mt7921_mutex_release(dev);
 
-	return err;
+	return 0;
 }
 
 static void mt7921_set_wakeup(struct ieee80211_hw *hw, bool enabled)
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
index 305b63fa1a8a9..c29dde23d4ab1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
@@ -235,7 +235,6 @@ static int mt7921_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 	struct mt76_dev *mdev = pci_get_drvdata(pdev);
 	struct mt7921_dev *dev = container_of(mdev, struct mt7921_dev, mt76);
 	struct mt76_connac_pm *pm = &dev->pm;
-	bool hif_suspend;
 	int i, err;
 
 	pm->suspended = true;
@@ -246,12 +245,9 @@ static int mt7921_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 	if (err < 0)
 		goto restore_suspend;
 
-	hif_suspend = !test_bit(MT76_STATE_SUSPEND, &dev->mphy.state);
-	if (hif_suspend) {
-		err = mt76_connac_mcu_set_hif_suspend(mdev, true);
-		if (err)
-			goto restore_suspend;
-	}
+	err = mt76_connac_mcu_set_hif_suspend(mdev, true);
+	if (err)
+		goto restore_suspend;
 
 	/* always enable deep sleep during suspend to reduce
 	 * power consumption
@@ -302,8 +298,7 @@ restore_napi:
 	if (!pm->ds_enable)
 		mt76_connac_mcu_set_deep_sleep(&dev->mt76, false);
 
-	if (hif_suspend)
-		mt76_connac_mcu_set_hif_suspend(mdev, false);
+	mt76_connac_mcu_set_hif_suspend(mdev, false);
 
 restore_suspend:
 	pm->suspended = false;
@@ -356,10 +351,7 @@ static int mt7921_pci_resume(struct pci_dev *pdev)
 	if (!pm->ds_enable)
 		mt76_connac_mcu_set_deep_sleep(&dev->mt76, false);
 
-	if (!test_bit(MT76_STATE_SUSPEND, &dev->mphy.state))
-		err = mt76_connac_mcu_set_hif_suspend(mdev, false);
-
-	return err;
+	return mt76_connac_mcu_set_hif_suspend(mdev, false);
 }
 #endif /* CONFIG_PM */
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/sdio.c b/drivers/net/wireless/mediatek/mt76/mt7921/sdio.c
index ddf0eeb8b6889..5fee489c7a998 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/sdio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/sdio.c
@@ -203,7 +203,6 @@ static int mt7921s_suspend(struct device *__dev)
 	struct mt7921_dev *dev = sdio_get_drvdata(func);
 	struct mt76_connac_pm *pm = &dev->pm;
 	struct mt76_dev *mdev = &dev->mt76;
-	bool hif_suspend;
 	int err;
 
 	pm->suspended = true;
@@ -214,12 +213,9 @@ static int mt7921s_suspend(struct device *__dev)
 	if (err < 0)
 		goto restore_suspend;
 
-	hif_suspend = !test_bit(MT76_STATE_SUSPEND, &dev->mphy.state);
-	if (hif_suspend) {
-		err = mt76_connac_mcu_set_hif_suspend(mdev, true);
-		if (err)
-			goto restore_suspend;
-	}
+	err = mt76_connac_mcu_set_hif_suspend(mdev, true);
+	if (err)
+		goto restore_suspend;
 
 	/* always enable deep sleep during suspend to reduce
 	 * power consumption
@@ -253,8 +249,7 @@ restore_worker:
 	if (!pm->ds_enable)
 		mt76_connac_mcu_set_deep_sleep(mdev, false);
 
-	if (hif_suspend)
-		mt76_connac_mcu_set_hif_suspend(mdev, false);
+	mt76_connac_mcu_set_hif_suspend(mdev, false);
 
 restore_suspend:
 	pm->suspended = false;
@@ -285,10 +280,7 @@ static int mt7921s_resume(struct device *__dev)
 	if (!pm->ds_enable)
 		mt76_connac_mcu_set_deep_sleep(mdev, false);
 
-	if (!test_bit(MT76_STATE_SUSPEND, &dev->mphy.state))
-		err = mt76_connac_mcu_set_hif_suspend(mdev, false);
-
-	return err;
+	return mt76_connac_mcu_set_hif_suspend(mdev, false);
 }
 
 static const struct dev_pm_ops mt7921s_pm_ops = {
-- 
2.34.1



