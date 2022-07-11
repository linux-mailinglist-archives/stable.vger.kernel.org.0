Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72AF656FCE3
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233660AbiGKJsn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:48:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233665AbiGKJsH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:48:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D922AAC05A;
        Mon, 11 Jul 2022 02:23:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 124C56134C;
        Mon, 11 Jul 2022 09:23:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C952C34115;
        Mon, 11 Jul 2022 09:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531407;
        bh=TfdIL7rU0ltrXpRZtd8xYeEWIr2ewaX2dINJEnxfA1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lIBefv5ZQebgiD+7YMbbXcmN8zLTL+KUiztar/gpY2a60cks4+QkR5GV+eRROprb7
         ceyoG96MLvbfKgwwwmqdKv68pruk7Am7PD8TiGaBengxMw0BTTH3Ui3QU1XKkvhiC9
         9GjNhopk+dtyX80RgCxM8J5maUl7DTUMDwkoquNg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 044/230] mt76: mt7921: introduce mt7921_mcu_set_beacon_filter utility routine
Date:   Mon, 11 Jul 2022 11:05:00 +0200
Message-Id: <20220711090605.332748198@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 890809ca1986e63d29dd1591090af67b655ed89c ]

Introduce mt7921_mcu_set_beacon_filter utility routine in order to
remove duplicated code for hw beacon filtering.
Move mt7921_pm_interface_iter in debugfs since it is just used there.
Make the following routine static:
- mt7921_pm_interface_iter
- mt7921_mcu_uni_bss_bcnft
- mt7921_mcu_set_bss_pm

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/mediatek/mt76/mt7921/debugfs.c   | 20 +++++---
 .../net/wireless/mediatek/mt76/mt7921/main.c  | 33 +------------
 .../net/wireless/mediatek/mt76/mt7921/mcu.c   | 47 ++++++++++---------
 .../wireless/mediatek/mt76/mt7921/mt7921.h    |  8 ++--
 4 files changed, 45 insertions(+), 63 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c
index 8d5e261cd10f..82fb2585f413 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c
@@ -262,30 +262,38 @@ mt7921_txpwr(struct seq_file *s, void *data)
 	return 0;
 }
 
+static void
+mt7921_pm_interface_iter(void *priv, u8 *mac, struct ieee80211_vif *vif)
+{
+	struct mt7921_dev *dev = priv;
+
+	mt7921_mcu_set_beacon_filter(dev, vif, dev->pm.enable);
+}
+
 static int
 mt7921_pm_set(void *data, u64 val)
 {
 	struct mt7921_dev *dev = data;
 	struct mt76_connac_pm *pm = &dev->pm;
-	struct mt76_phy *mphy = dev->phy.mt76;
-
-	if (val == pm->enable)
-		return 0;
 
 	mt7921_mutex_acquire(dev);
 
+	if (val == pm->enable)
+		goto out;
+
 	if (!pm->enable) {
 		pm->stats.last_wake_event = jiffies;
 		pm->stats.last_doze_event = jiffies;
 	}
 	pm->enable = val;
 
-	ieee80211_iterate_active_interfaces(mphy->hw,
+	ieee80211_iterate_active_interfaces(mt76_hw(dev),
 					    IEEE80211_IFACE_ITER_RESUME_ALL,
-					    mt7921_pm_interface_iter, mphy->priv);
+					    mt7921_pm_interface_iter, dev);
 
 	mt76_connac_mcu_set_deep_sleep(&dev->mt76, pm->ds_enable);
 
+out:
 	mt7921_mutex_release(dev);
 
 	return 0;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index 30252f408ddc..13a7ae3d8351 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -528,36 +528,6 @@ static void mt7921_configure_filter(struct ieee80211_hw *hw,
 	mt7921_mutex_release(dev);
 }
 
-static int
-mt7921_bss_bcnft_apply(struct mt7921_dev *dev, struct ieee80211_vif *vif,
-		       bool assoc)
-{
-	int ret;
-
-	if (!dev->pm.enable)
-		return 0;
-
-	if (assoc) {
-		ret = mt7921_mcu_uni_bss_bcnft(dev, vif, true);
-		if (ret)
-			return ret;
-
-		vif->driver_flags |= IEEE80211_VIF_BEACON_FILTER;
-		mt76_set(dev, MT_WF_RFCR(0), MT_WF_RFCR_DROP_OTHER_BEACON);
-
-		return 0;
-	}
-
-	ret = mt7921_mcu_set_bss_pm(dev, vif, false);
-	if (ret)
-		return ret;
-
-	vif->driver_flags &= ~IEEE80211_VIF_BEACON_FILTER;
-	mt76_clear(dev, MT_WF_RFCR(0), MT_WF_RFCR_DROP_OTHER_BEACON);
-
-	return 0;
-}
-
 static void mt7921_bss_info_changed(struct ieee80211_hw *hw,
 				    struct ieee80211_vif *vif,
 				    struct ieee80211_bss_conf *info,
@@ -587,7 +557,8 @@ static void mt7921_bss_info_changed(struct ieee80211_hw *hw,
 	if (changed & BSS_CHANGED_ASSOC) {
 		mt7921_mcu_sta_update(dev, NULL, vif, true,
 				      MT76_STA_INFO_STATE_ASSOC);
-		mt7921_bss_bcnft_apply(dev, vif, info->assoc);
+		if (dev->pm.enable)
+			mt7921_mcu_set_beacon_filter(dev, vif, info->assoc);
 	}
 
 	if (changed & BSS_CHANGED_ARP_FILTER) {
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
index 4119f8efd896..dabc0de2ec65 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -1205,8 +1205,9 @@ int mt7921_mcu_uni_bss_ps(struct mt7921_dev *dev, struct ieee80211_vif *vif)
 				 &ps_req, sizeof(ps_req), true);
 }
 
-int mt7921_mcu_uni_bss_bcnft(struct mt7921_dev *dev, struct ieee80211_vif *vif,
-			     bool enable)
+static int
+mt7921_mcu_uni_bss_bcnft(struct mt7921_dev *dev, struct ieee80211_vif *vif,
+			 bool enable)
 {
 	struct mt7921_vif *mvif = (struct mt7921_vif *)vif->drv_priv;
 	struct {
@@ -1240,8 +1241,9 @@ int mt7921_mcu_uni_bss_bcnft(struct mt7921_dev *dev, struct ieee80211_vif *vif,
 				 &bcnft_req, sizeof(bcnft_req), true);
 }
 
-int mt7921_mcu_set_bss_pm(struct mt7921_dev *dev, struct ieee80211_vif *vif,
-			  bool enable)
+static int
+mt7921_mcu_set_bss_pm(struct mt7921_dev *dev, struct ieee80211_vif *vif,
+		      bool enable)
 {
 	struct mt7921_vif *mvif = (struct mt7921_vif *)vif->drv_priv;
 	struct {
@@ -1390,31 +1392,34 @@ int mt7921_mcu_fw_pmctrl(struct mt7921_dev *dev)
 	return err;
 }
 
-void
-mt7921_pm_interface_iter(void *priv, u8 *mac, struct ieee80211_vif *vif)
+int mt7921_mcu_set_beacon_filter(struct mt7921_dev *dev,
+				 struct ieee80211_vif *vif,
+				 bool enable)
 {
-	struct mt7921_phy *phy = priv;
-	struct mt7921_dev *dev = phy->dev;
 	struct ieee80211_hw *hw = mt76_hw(dev);
-	int ret;
-
-	if (dev->pm.enable)
-		ret = mt7921_mcu_uni_bss_bcnft(dev, vif, true);
-	else
-		ret = mt7921_mcu_set_bss_pm(dev, vif, false);
+	int err;
 
-	if (ret)
-		return;
+	if (enable) {
+		err = mt7921_mcu_uni_bss_bcnft(dev, vif, true);
+		if (err)
+			return err;
 
-	if (dev->pm.enable) {
 		vif->driver_flags |= IEEE80211_VIF_BEACON_FILTER;
 		ieee80211_hw_set(hw, CONNECTION_MONITOR);
 		mt76_set(dev, MT_WF_RFCR(0), MT_WF_RFCR_DROP_OTHER_BEACON);
-	} else {
-		vif->driver_flags &= ~IEEE80211_VIF_BEACON_FILTER;
-		__clear_bit(IEEE80211_HW_CONNECTION_MONITOR, hw->flags);
-		mt76_clear(dev, MT_WF_RFCR(0), MT_WF_RFCR_DROP_OTHER_BEACON);
+
+		return 0;
 	}
+
+	err = mt7921_mcu_set_bss_pm(dev, vif, false);
+	if (err)
+		return err;
+
+	vif->driver_flags &= ~IEEE80211_VIF_BEACON_FILTER;
+	__clear_bit(IEEE80211_HW_CONNECTION_MONITOR, hw->flags);
+	mt76_clear(dev, MT_WF_RFCR(0), MT_WF_RFCR_DROP_OTHER_BEACON);
+
+	return 0;
 }
 
 int mt7921_get_txpwr_info(struct mt7921_dev *dev, struct mt7921_txpwr *txpwr)
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h b/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
index 1aafd8723b3a..32d4f2cab94e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
@@ -363,6 +363,9 @@ void mt7921_set_stream_he_caps(struct mt7921_phy *phy);
 void mt7921_update_channel(struct mt76_phy *mphy);
 int mt7921_init_debugfs(struct mt7921_dev *dev);
 
+int mt7921_mcu_set_beacon_filter(struct mt7921_dev *dev,
+				 struct ieee80211_vif *vif,
+				 bool enable);
 int mt7921_mcu_uni_tx_ba(struct mt7921_dev *dev,
 			 struct ieee80211_ampdu_params *params,
 			 bool enable);
@@ -371,17 +374,12 @@ int mt7921_mcu_uni_rx_ba(struct mt7921_dev *dev,
 			 bool enable);
 void mt7921_scan_work(struct work_struct *work);
 int mt7921_mcu_uni_bss_ps(struct mt7921_dev *dev, struct ieee80211_vif *vif);
-int mt7921_mcu_uni_bss_bcnft(struct mt7921_dev *dev, struct ieee80211_vif *vif,
-			     bool enable);
-int mt7921_mcu_set_bss_pm(struct mt7921_dev *dev, struct ieee80211_vif *vif,
-			  bool enable);
 int __mt7921_mcu_drv_pmctrl(struct mt7921_dev *dev);
 int mt7921_mcu_drv_pmctrl(struct mt7921_dev *dev);
 int mt7921_mcu_fw_pmctrl(struct mt7921_dev *dev);
 void mt7921_pm_wake_work(struct work_struct *work);
 void mt7921_pm_power_save_work(struct work_struct *work);
 bool mt7921_wait_for_mcu_init(struct mt7921_dev *dev);
-void mt7921_pm_interface_iter(void *priv, u8 *mac, struct ieee80211_vif *vif);
 void mt7921_coredump_work(struct work_struct *work);
 int mt7921_wfsys_reset(struct mt7921_dev *dev);
 int mt7921_get_txpwr_info(struct mt7921_dev *dev, struct mt7921_txpwr *txpwr);
-- 
2.35.1



