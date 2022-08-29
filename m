Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCF505A48BE
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbiH2LPK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:15:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231563AbiH2LOG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:14:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BDAC63F15;
        Mon, 29 Aug 2022 04:10:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E6EC611C2;
        Mon, 29 Aug 2022 11:07:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9730CC433D6;
        Mon, 29 Aug 2022 11:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771270;
        bh=2jqoQJ423K4tztFRdNO+0o7cvRFn3+7ghfhrBOmWg9Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xqM/g+uRClzJasfOMljJ/2Mw+i7OrU9qHSLaQccXejkmzRcutZZdEi2PO3z2FdWUJ
         rEfnkvnPFT5ZWVwHwSg2z0A1NYOK+M6EjwCSwlg/B6irjTqPVi/GgK9Eh8feT8FM4r
         bGmqYmp0JO5h0yUrwPCfiT00xpEe7hjuSxboA+tI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Deren Wu <deren.wu@mediatek.com>, Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 5.19 011/158] mt76: mt7921: fix command timeout in AP stop period
Date:   Mon, 29 Aug 2022 12:57:41 +0200
Message-Id: <20220829105809.301913190@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Deren Wu <deren.wu@mediatek.com>

commit 9d958b60ebc2434f2b7eae83d77849e22d1059eb upstream.

Due to AP stop improperly, mt7921 driver would face random command timeout
by chip fw problem. Migrate AP start/stop process to .start_ap/.stop_ap and
congiure BSS network settings in both hooks.

The new flow is shown below.
* AP start
    .start_ap()
      configure BSS network resource
      set BSS to connected state
    .bss_info_changed()
      enable fw beacon offload

* AP stop
    .bss_info_changed()
      disable fw beacon offload (skip this command)
    .stop_ap()
      set BSS to disconnected state (beacon offload disabled automatically)
      destroy BSS network resource

Fixes: 116c69603b01 ("mt76: mt7921: Add AP mode support")
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Deren Wu <deren.wu@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c |    2 
 drivers/net/wireless/mediatek/mt76/mt7921/main.c     |   47 +++++++++++++++----
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c      |    5 --
 drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h   |    2 
 4 files changed, 43 insertions(+), 13 deletions(-)

--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
@@ -1403,6 +1403,8 @@ int mt76_connac_mcu_uni_add_bss(struct m
 		else
 			conn_type = CONNECTION_INFRA_AP;
 		basic_req.basic.conn_type = cpu_to_le32(conn_type);
+		/* Fully active/deactivate BSS network in AP mode only */
+		basic_req.basic.active = enable;
 		break;
 	case NL80211_IFTYPE_STATION:
 		if (vif->p2p)
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -653,15 +653,6 @@ static void mt7921_bss_info_changed(stru
 		}
 	}
 
-	if (changed & BSS_CHANGED_BEACON_ENABLED && info->enable_beacon) {
-		struct mt7921_vif *mvif = (struct mt7921_vif *)vif->drv_priv;
-
-		mt76_connac_mcu_uni_add_bss(phy->mt76, vif, &mvif->sta.wcid,
-					    true);
-		mt7921_mcu_sta_update(dev, NULL, vif, true,
-				      MT76_STA_INFO_STATE_NONE);
-	}
-
 	if (changed & (BSS_CHANGED_BEACON |
 		       BSS_CHANGED_BEACON_ENABLED))
 		mt7921_mcu_uni_add_beacon_offload(dev, hw, vif,
@@ -1500,6 +1491,42 @@ mt7921_channel_switch_beacon(struct ieee
 	mt7921_mutex_release(dev);
 }
 
+static int
+mt7921_start_ap(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
+{
+	struct mt7921_vif *mvif = (struct mt7921_vif *)vif->drv_priv;
+	struct mt7921_phy *phy = mt7921_hw_phy(hw);
+	struct mt7921_dev *dev = mt7921_hw_dev(hw);
+	int err;
+
+	err = mt76_connac_mcu_uni_add_bss(phy->mt76, vif, &mvif->sta.wcid,
+					  true);
+	if (err)
+		return err;
+
+	err = mt7921_mcu_set_bss_pm(dev, vif, true);
+	if (err)
+		return err;
+
+	return mt7921_mcu_sta_update(dev, NULL, vif, true,
+				     MT76_STA_INFO_STATE_NONE);
+}
+
+static void
+mt7921_stop_ap(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
+{
+	struct mt7921_vif *mvif = (struct mt7921_vif *)vif->drv_priv;
+	struct mt7921_phy *phy = mt7921_hw_phy(hw);
+	struct mt7921_dev *dev = mt7921_hw_dev(hw);
+	int err;
+
+	err = mt7921_mcu_set_bss_pm(dev, vif, false);
+	if (err)
+		return;
+
+	mt76_connac_mcu_uni_add_bss(phy->mt76, vif, &mvif->sta.wcid, false);
+}
+
 const struct ieee80211_ops mt7921_ops = {
 	.tx = mt7921_tx,
 	.start = mt7921_start,
@@ -1510,6 +1537,8 @@ const struct ieee80211_ops mt7921_ops =
 	.conf_tx = mt7921_conf_tx,
 	.configure_filter = mt7921_configure_filter,
 	.bss_info_changed = mt7921_bss_info_changed,
+	.start_ap = mt7921_start_ap,
+	.stop_ap = mt7921_stop_ap,
 	.sta_state = mt7921_sta_state,
 	.sta_pre_rcu_remove = mt76_sta_pre_rcu_remove,
 	.set_key = mt7921_set_key,
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -1020,7 +1020,7 @@ mt7921_mcu_uni_bss_bcnft(struct mt7921_d
 				 &bcnft_req, sizeof(bcnft_req), true);
 }
 
-static int
+int
 mt7921_mcu_set_bss_pm(struct mt7921_dev *dev, struct ieee80211_vif *vif,
 		      bool enable)
 {
@@ -1049,9 +1049,6 @@ mt7921_mcu_set_bss_pm(struct mt7921_dev
 	};
 	int err;
 
-	if (vif->type != NL80211_IFTYPE_STATION)
-		return 0;
-
 	err = mt76_mcu_send_msg(&dev->mt76, MCU_CE_CMD(SET_BSS_ABORT),
 				&req_hdr, sizeof(req_hdr), false);
 	if (err < 0 || !enable)
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
@@ -280,6 +280,8 @@ int mt7921_wpdma_reset(struct mt7921_dev
 int mt7921_wpdma_reinit_cond(struct mt7921_dev *dev);
 void mt7921_dma_cleanup(struct mt7921_dev *dev);
 int mt7921_run_firmware(struct mt7921_dev *dev);
+int mt7921_mcu_set_bss_pm(struct mt7921_dev *dev, struct ieee80211_vif *vif,
+			  bool enable);
 int mt7921_mcu_sta_update(struct mt7921_dev *dev, struct ieee80211_sta *sta,
 			  struct ieee80211_vif *vif, bool enable,
 			  enum mt76_sta_info_state state);


