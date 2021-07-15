Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B16B53CAAD2
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244262AbhGOTPk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:15:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:50954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244236AbhGOTOh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:14:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D032D61370;
        Thu, 15 Jul 2021 19:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626376192;
        bh=wnTsomYnCGOELAZ0AQCx5ATOgWQGSdNf0X4ppMtv3h0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RMqHsFPMA1iVZ2efc+HaXpL1duzF2CQ5Evl0tAlmGYSvcd4H0M7gUnrodt89bwXED
         rAX3K52rNgKmbmWks7MWMOvySKXYbmbFsRAp0jLnd7T8EqhsliPshr24V3cg7AgEYv
         9HCyTVOIUrM37tmFqZVNpCcuBzRQfrz5IE0j8fdc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Deren.Wu" <deren.wu@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 124/266] mt76: mt7921: enable hw offloading for wep keys
Date:   Thu, 15 Jul 2021 20:37:59 +0200
Message-Id: <20210715182635.794504242@linuxfoundation.org>
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

[ Upstream commit a60951d4faa0ef2e475797dd217c2eaee32ed1c2 ]

Enable wep key hw offloading for sta mode. This patch fixes
WoW support for wep connections.

Tested-by: Deren.Wu <deren.wu@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7921/main.c  | 22 ++++++++++++++-----
 .../wireless/mediatek/mt76/mt7921/mt7921.h    |  2 ++
 2 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index bd77a04a15fb..992a74e122e5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -376,6 +376,10 @@ static int mt7921_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		key->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIE;
 		wcid_keyidx = &wcid->hw_key_idx2;
 		break;
+	case WLAN_CIPHER_SUITE_WEP40:
+	case WLAN_CIPHER_SUITE_WEP104:
+		if (!mvif->wep_sta)
+			return -EOPNOTSUPP;
 	case WLAN_CIPHER_SUITE_TKIP:
 	case WLAN_CIPHER_SUITE_CCMP:
 	case WLAN_CIPHER_SUITE_CCMP_256:
@@ -383,8 +387,6 @@ static int mt7921_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	case WLAN_CIPHER_SUITE_GCMP_256:
 	case WLAN_CIPHER_SUITE_SMS4:
 		break;
-	case WLAN_CIPHER_SUITE_WEP40:
-	case WLAN_CIPHER_SUITE_WEP104:
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -402,6 +404,12 @@ static int mt7921_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 			    cmd == SET_KEY ? key : NULL);
 
 	err = mt7921_mcu_add_key(dev, vif, msta, key, cmd);
+	if (err)
+		goto out;
+
+	if (key->cipher == WLAN_CIPHER_SUITE_WEP104 ||
+	    key->cipher == WLAN_CIPHER_SUITE_WEP40)
+		err = mt7921_mcu_add_key(dev, vif, mvif->wep_sta, key, cmd);
 out:
 	mt7921_mutex_release(dev);
 
@@ -608,9 +616,12 @@ int mt7921_mac_sta_add(struct mt76_dev *mdev, struct ieee80211_vif *vif,
 	if (ret)
 		return ret;
 
-	if (vif->type == NL80211_IFTYPE_STATION && !sta->tdls)
-		mt76_connac_mcu_uni_add_bss(&dev->mphy, vif, &mvif->sta.wcid,
-					    true);
+	if (vif->type == NL80211_IFTYPE_STATION) {
+		mvif->wep_sta = msta;
+		if (!sta->tdls)
+			mt76_connac_mcu_uni_add_bss(&dev->mphy, vif,
+						    &mvif->sta.wcid, true);
+	}
 
 	mt7921_mac_wtbl_update(dev, idx,
 			       MT_WTBL_UPDATE_ADM_COUNT_CLEAR);
@@ -640,6 +651,7 @@ void mt7921_mac_sta_remove(struct mt76_dev *mdev, struct ieee80211_vif *vif,
 	if (vif->type == NL80211_IFTYPE_STATION) {
 		struct mt7921_vif *mvif = (struct mt7921_vif *)vif->drv_priv;
 
+		mvif->wep_sta = NULL;
 		ewma_rssi_init(&mvif->rssi);
 		if (!sta->tdls)
 			mt76_connac_mcu_uni_add_bss(&dev->mphy, vif,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h b/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
index 710ad242fd53..957084c3ca43 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
@@ -100,6 +100,8 @@ struct mt7921_vif {
 	struct mt76_vif mt76; /* must be first */
 
 	struct mt7921_sta sta;
+	struct mt7921_sta *wep_sta;
+
 	struct mt7921_phy *phy;
 
 	struct ewma_rssi rssi;
-- 
2.30.2



