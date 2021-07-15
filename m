Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28AA43CAA7A
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242824AbhGOTNY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:13:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:46122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242938AbhGOTLI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:11:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B774461285;
        Thu, 15 Jul 2021 19:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626376094;
        bh=WW0f6yr/kmOY2VFZsN6kWkCwtZSc7Qxz13BLP8ROPGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZovDURrVPptnomtEzx5SYb8YHsA/49YbQzbRMeYnM2C4YY47cXQE2Bo2e5JaBGIf5
         PWFUisfKk3uiz0hLmsY4uTUF7LrIwXc+jDA/XlkXJuw1h6eX1IgQ0Omx1rW4dNb1fa
         gal4u3dmV+xI6GCkJ/kmqZMO/6xFu4MZ/kgyBFeQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Deren Wu <deren.wu@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 125/266] mt76: connac: fix UC entry is being overwritten
Date:   Thu, 15 Jul 2021 20:38:00 +0200
Message-Id: <20210715182635.978178798@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 82453b1cbf9ef166364c12b5464251f16bac5f51 ]

Fix UC entry is being overwritten by BC entry

Tested-by: Deren Wu <deren.wu@mediatek.com>
Co-developed-by: Deren Wu <deren.wu@mediatek.com>
Signed-off-by: Deren Wu <deren.wu@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c      |  8 +++++---
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c | 10 ++++++----
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h |  1 +
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c      |  1 +
 4 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
index ae2191371f51..257a2c4ddf36 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
@@ -1123,12 +1123,14 @@ mt7615_mcu_sta_rx_ba(struct mt7615_dev *dev,
 
 static int
 __mt7615_mcu_add_sta(struct mt76_phy *phy, struct ieee80211_vif *vif,
-		     struct ieee80211_sta *sta, bool enable, int cmd)
+		     struct ieee80211_sta *sta, bool enable, int cmd,
+		     bool offload_fw)
 {
 	struct mt7615_vif *mvif = (struct mt7615_vif *)vif->drv_priv;
 	struct mt76_sta_cmd_info info = {
 		.sta = sta,
 		.vif = vif,
+		.offload_fw = offload_fw,
 		.enable = enable,
 		.cmd = cmd,
 	};
@@ -1142,7 +1144,7 @@ mt7615_mcu_add_sta(struct mt7615_phy *phy, struct ieee80211_vif *vif,
 		   struct ieee80211_sta *sta, bool enable)
 {
 	return __mt7615_mcu_add_sta(phy->mt76, vif, sta, enable,
-				    MCU_EXT_CMD_STA_REC_UPDATE);
+				    MCU_EXT_CMD_STA_REC_UPDATE, false);
 }
 
 static const struct mt7615_mcu_ops sta_update_ops = {
@@ -1283,7 +1285,7 @@ mt7615_mcu_uni_add_sta(struct mt7615_phy *phy, struct ieee80211_vif *vif,
 		       struct ieee80211_sta *sta, bool enable)
 {
 	return __mt7615_mcu_add_sta(phy->mt76, vif, sta, enable,
-				    MCU_UNI_CMD_STA_REC_UPDATE);
+				    MCU_UNI_CMD_STA_REC_UPDATE, true);
 }
 
 static int
diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
index eb19721f9d79..e5721603586f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
@@ -841,10 +841,12 @@ int mt76_connac_mcu_add_sta_cmd(struct mt76_phy *phy,
 	if (IS_ERR(skb))
 		return PTR_ERR(skb);
 
-	mt76_connac_mcu_sta_basic_tlv(skb, info->vif, info->sta, info->enable);
-	if (info->enable && info->sta)
-		mt76_connac_mcu_sta_tlv(phy, skb, info->sta, info->vif,
-					info->rcpi);
+	if (info->sta || !info->offload_fw)
+		mt76_connac_mcu_sta_basic_tlv(skb, info->vif, info->sta,
+					      info->enable);
+	if (info->sta && info->enable)
+		mt76_connac_mcu_sta_tlv(phy, skb, info->sta,
+					info->vif, info->rcpi);
 
 	sta_wtbl = mt76_connac_mcu_add_tlv(skb, STA_REC_WTBL,
 					   sizeof(struct tlv));
diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
index 3bcae732872e..0450d8c1c181 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
@@ -899,6 +899,7 @@ struct mt76_sta_cmd_info {
 
 	struct ieee80211_vif *vif;
 
+	bool offload_fw;
 	bool enable;
 	int cmd;
 	u8 rcpi;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
index 06209d58ce27..9bc35ce80153 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -1289,6 +1289,7 @@ int mt7921_mcu_sta_add(struct mt7921_dev *dev, struct ieee80211_sta *sta,
 		.vif = vif,
 		.enable = enable,
 		.cmd = MCU_UNI_CMD_STA_REC_UPDATE,
+		.offload_fw = true,
 		.rcpi = to_rcpi(rssi),
 	};
 	struct mt7921_sta *msta;
-- 
2.30.2



