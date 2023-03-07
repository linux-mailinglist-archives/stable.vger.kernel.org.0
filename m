Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE9FA6AE95A
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:23:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231395AbjCGRXR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:23:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231246AbjCGRWp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:22:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FE3A570B8
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:18:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D1536150F
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:18:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E78FDC433AA;
        Tue,  7 Mar 2023 17:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209497;
        bh=MeAWj6Pyy/rxDL+DCELItmLqxIh4NPgLYIE2PWFKp7M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yp5NrgCRT1UJH5WgJpeMkS/0mXkIBxSvv9oPjlMAv5xAtsEqjxHiuR2x7Q3dLgGGl
         zjWKub7OXX+afe32auH+ZssKOw2X59TZheqiedwJhZ8BFCKS1O086TscvZtqUGNqtL
         9iQbwBUAXpgmfv4w9hRgg57k5nUyNJo1khDBquls=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ryder Lee <ryder.lee@mediatek.com>,
        Howard Hsu <howard-yh.hsu@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0239/1001] wifi: mt76: mt7915: rework mt7915_mcu_set_thermal_throttling
Date:   Tue,  7 Mar 2023 17:50:11 +0100
Message-Id: <20230307170032.205048849@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Howard Hsu <howard-yh.hsu@mediatek.com>

[ Upstream commit 5ad42d19f6596e54b091827c397fdb7c091d45f7 ]

This patch includes 2 changes:
1. Firmware expects to disable thermal protect first before
reconfiguring.
2. Separate setting thermal_protect and setting thermal_tx_duty into
different functions. These two firmware commands do not need to send
together.

Fixes: 34b877d972be ("mt76: mt7915: add thermal cooling device support")
Reviewed-by: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: Howard Hsu <howard-yh.hsu@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7915/init.c  |  3 --
 .../net/wireless/mediatek/mt76/mt7915/main.c  |  5 ++
 .../net/wireless/mediatek/mt76/mt7915/mcu.c   | 54 +++++++++++--------
 .../wireless/mediatek/mt76/mt7915/mt7915.h    |  1 +
 4 files changed, 37 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/init.c b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
index 41019ba24a048..4c351bfd4b270 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
@@ -134,9 +134,6 @@ mt7915_thermal_set_cur_throttle_state(struct thermal_cooling_device *cdev,
 	if (state > MT7915_CDEV_THROTTLE_MAX)
 		return -EINVAL;
 
-	if (phy->throttle_temp[0] > phy->throttle_temp[1])
-		return 0;
-
 	if (state == phy->cdev_state)
 		return 0;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/main.c b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
index 98af032eba097..7589af4b3dab7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
@@ -60,6 +60,11 @@ int mt7915_run(struct ieee80211_hw *hw)
 	ret = mt7915_mcu_set_thermal_throttling(phy,
 						MT7915_THERMAL_THROTTLE_MAX);
 
+	if (ret)
+		goto out;
+
+	ret = mt7915_mcu_set_thermal_protect(phy);
+
 	if (ret)
 		goto out;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index d9d6846ba8e02..a861312ba3ed1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -3060,6 +3060,29 @@ int mt7915_mcu_get_temperature(struct mt7915_phy *phy)
 }
 
 int mt7915_mcu_set_thermal_throttling(struct mt7915_phy *phy, u8 state)
+{
+	struct mt7915_dev *dev = phy->dev;
+	struct mt7915_mcu_thermal_ctrl req = {
+		.band_idx = phy->mt76->band_idx,
+		.ctrl_id = THERMAL_PROTECT_DUTY_CONFIG,
+	};
+	int level, ret;
+
+	/* set duty cycle and level */
+	for (level = 0; level < 4; level++) {
+		req.duty.duty_level = level;
+		req.duty.duty_cycle = state;
+		state /= 2;
+
+		ret = mt76_mcu_send_msg(&dev->mt76, MCU_EXT_CMD(THERMAL_PROT),
+					&req, sizeof(req), false);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+
+int mt7915_mcu_set_thermal_protect(struct mt7915_phy *phy)
 {
 	struct mt7915_dev *dev = phy->dev;
 	struct {
@@ -3072,29 +3095,18 @@ int mt7915_mcu_set_thermal_throttling(struct mt7915_phy *phy, u8 state)
 	} __packed req = {
 		.ctrl = {
 			.band_idx = phy->mt76->band_idx,
+			.type.protect_type = 1,
+			.type.trigger_type = 1,
 		},
 	};
-	int level;
-
-	if (!state) {
-		req.ctrl.ctrl_id = THERMAL_PROTECT_DISABLE;
-		goto out;
-	}
-
-	/* set duty cycle and level */
-	for (level = 0; level < 4; level++) {
-		int ret;
+	int ret;
 
-		req.ctrl.ctrl_id = THERMAL_PROTECT_DUTY_CONFIG;
-		req.ctrl.duty.duty_level = level;
-		req.ctrl.duty.duty_cycle = state;
-		state /= 2;
+	req.ctrl.ctrl_id = THERMAL_PROTECT_DISABLE;
+	ret = mt76_mcu_send_msg(&dev->mt76, MCU_EXT_CMD(THERMAL_PROT),
+				&req, sizeof(req.ctrl), false);
 
-		ret = mt76_mcu_send_msg(&dev->mt76, MCU_EXT_CMD(THERMAL_PROT),
-					&req, sizeof(req.ctrl), false);
-		if (ret)
-			return ret;
-	}
+	if (ret)
+		return ret;
 
 	/* set high-temperature trigger threshold */
 	req.ctrl.ctrl_id = THERMAL_PROTECT_ENABLE;
@@ -3103,10 +3115,6 @@ int mt7915_mcu_set_thermal_throttling(struct mt7915_phy *phy, u8 state)
 	req.trigger_temp = cpu_to_le32(phy->throttle_temp[1]);
 	req.sustain_time = cpu_to_le16(10);
 
-out:
-	req.ctrl.type.protect_type = 1;
-	req.ctrl.type.trigger_type = 1;
-
 	return mt76_mcu_send_msg(&dev->mt76, MCU_EXT_CMD(THERMAL_PROT),
 				 &req, sizeof(req), false);
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h b/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h
index 6351feba6bdf9..855779f86bde0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h
@@ -543,6 +543,7 @@ int mt7915_mcu_apply_tx_dpd(struct mt7915_phy *phy);
 int mt7915_mcu_get_chan_mib_info(struct mt7915_phy *phy, bool chan_switch);
 int mt7915_mcu_get_temperature(struct mt7915_phy *phy);
 int mt7915_mcu_set_thermal_throttling(struct mt7915_phy *phy, u8 state);
+int mt7915_mcu_set_thermal_protect(struct mt7915_phy *phy);
 int mt7915_mcu_get_rx_rate(struct mt7915_phy *phy, struct ieee80211_vif *vif,
 			   struct ieee80211_sta *sta, struct rate_info *rate);
 int mt7915_mcu_rdd_background_enable(struct mt7915_phy *phy,
-- 
2.39.2



