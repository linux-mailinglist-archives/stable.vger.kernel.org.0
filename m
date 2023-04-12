Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 158516DEFBC
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231230AbjDLIxf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:53:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231445AbjDLIx3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:53:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A36EF7283
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:53:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF813631C2
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:52:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E765BC433D2;
        Wed, 12 Apr 2023 08:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289559;
        bh=VKZbeBhYYpUvmAt9nynSOYckrFoXr2mWWtA73y9cS+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GtQCvkOT/zNRmH4wEwZYP7vMVUPDbyoNe3wFsmjkKeO/vc321m74s6FT+yabUnsnD
         vryjd27dLBqbQEvVXosq+6bWc97iNOc+1WoE7bMMkugVIM3nMEONNHISk7yIy1J1/M
         iuxm14wxrSp/w8FoDYH4TTqVNtfb2W/8nGbZHLLw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Felix Fietkau <nbd@nbd.name>,
        Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 6.2 145/173] wifi: mt76: ignore key disable commands
Date:   Wed, 12 Apr 2023 10:34:31 +0200
Message-Id: <20230412082843.961267190@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
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

From: Felix Fietkau <nbd@nbd.name>

commit e6db67fa871dee37d22701daba806bfcd4d9df49 upstream.

This helps avoid cleartext leakage of already queued or powersave buffered
packets, when a reassoc triggers the key deletion.

Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230330091259.61378-1-nbd@nbd.name
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7603/main.c   |   10 +--
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    |   70 ++++++---------------
 drivers/net/wireless/mediatek/mt76/mt7615/main.c   |   15 ++--
 drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h |    6 -
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c  |   18 ++---
 drivers/net/wireless/mediatek/mt76/mt7915/main.c   |   13 +--
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |   13 +--
 drivers/net/wireless/mediatek/mt76/mt7996/main.c   |   13 +--
 8 files changed, 62 insertions(+), 96 deletions(-)

--- a/drivers/net/wireless/mediatek/mt76/mt7603/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/main.c
@@ -512,15 +512,15 @@ mt7603_set_key(struct ieee80211_hw *hw,
 	    !(key->flags & IEEE80211_KEY_FLAG_PAIRWISE))
 		return -EOPNOTSUPP;
 
-	if (cmd == SET_KEY) {
-		key->hw_key_idx = wcid->idx;
-		wcid->hw_key_idx = idx;
-	} else {
+	if (cmd != SET_KEY) {
 		if (idx == wcid->hw_key_idx)
 			wcid->hw_key_idx = -1;
 
-		key = NULL;
+		return 0;
 	}
+
+	key->hw_key_idx = wcid->idx;
+	wcid->hw_key_idx = idx;
 	mt76_wcid_key_setup(&dev->mt76, wcid, key);
 
 	return mt7603_wtbl_set_key(dev, wcid->idx, key);
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
@@ -1193,8 +1193,7 @@ EXPORT_SYMBOL_GPL(mt7615_mac_enable_rtsc
 static int
 mt7615_mac_wtbl_update_key(struct mt7615_dev *dev, struct mt76_wcid *wcid,
 			   struct ieee80211_key_conf *key,
-			   enum mt76_cipher_type cipher, u16 cipher_mask,
-			   enum set_key_cmd cmd)
+			   enum mt76_cipher_type cipher, u16 cipher_mask)
 {
 	u32 addr = mt7615_mac_wtbl_addr(dev, wcid->idx) + 30 * 4;
 	u8 data[32] = {};
@@ -1203,27 +1202,18 @@ mt7615_mac_wtbl_update_key(struct mt7615
 		return -EINVAL;
 
 	mt76_rr_copy(dev, addr, data, sizeof(data));
-	if (cmd == SET_KEY) {
-		if (cipher == MT_CIPHER_TKIP) {
-			/* Rx/Tx MIC keys are swapped */
-			memcpy(data, key->key, 16);
-			memcpy(data + 16, key->key + 24, 8);
-			memcpy(data + 24, key->key + 16, 8);
-		} else {
-			if (cipher_mask == BIT(cipher))
-				memcpy(data, key->key, key->keylen);
-			else if (cipher != MT_CIPHER_BIP_CMAC_128)
-				memcpy(data, key->key, 16);
-			if (cipher == MT_CIPHER_BIP_CMAC_128)
-				memcpy(data + 16, key->key, 16);
-		}
+	if (cipher == MT_CIPHER_TKIP) {
+		/* Rx/Tx MIC keys are swapped */
+		memcpy(data, key->key, 16);
+		memcpy(data + 16, key->key + 24, 8);
+		memcpy(data + 24, key->key + 16, 8);
 	} else {
+		if (cipher_mask == BIT(cipher))
+			memcpy(data, key->key, key->keylen);
+		else if (cipher != MT_CIPHER_BIP_CMAC_128)
+			memcpy(data, key->key, 16);
 		if (cipher == MT_CIPHER_BIP_CMAC_128)
-			memset(data + 16, 0, 16);
-		else if (cipher_mask)
-			memset(data, 0, 16);
-		if (!cipher_mask)
-			memset(data, 0, sizeof(data));
+			memcpy(data + 16, key->key, 16);
 	}
 
 	mt76_wr_copy(dev, addr, data, sizeof(data));
@@ -1234,7 +1224,7 @@ mt7615_mac_wtbl_update_key(struct mt7615
 static int
 mt7615_mac_wtbl_update_pk(struct mt7615_dev *dev, struct mt76_wcid *wcid,
 			  enum mt76_cipher_type cipher, u16 cipher_mask,
-			  int keyidx, enum set_key_cmd cmd)
+			  int keyidx)
 {
 	u32 addr = mt7615_mac_wtbl_addr(dev, wcid->idx), w0, w1;
 
@@ -1253,9 +1243,7 @@ mt7615_mac_wtbl_update_pk(struct mt7615_
 	else
 		w0 &= ~MT_WTBL_W0_RX_IK_VALID;
 
-	if (cmd == SET_KEY &&
-	    (cipher != MT_CIPHER_BIP_CMAC_128 ||
-	     cipher_mask == BIT(cipher))) {
+	if (cipher != MT_CIPHER_BIP_CMAC_128 || cipher_mask == BIT(cipher)) {
 		w0 &= ~MT_WTBL_W0_KEY_IDX;
 		w0 |= FIELD_PREP(MT_WTBL_W0_KEY_IDX, keyidx);
 	}
@@ -1272,19 +1260,10 @@ mt7615_mac_wtbl_update_pk(struct mt7615_
 
 static void
 mt7615_mac_wtbl_update_cipher(struct mt7615_dev *dev, struct mt76_wcid *wcid,
-			      enum mt76_cipher_type cipher, u16 cipher_mask,
-			      enum set_key_cmd cmd)
+			      enum mt76_cipher_type cipher, u16 cipher_mask)
 {
 	u32 addr = mt7615_mac_wtbl_addr(dev, wcid->idx);
 
-	if (!cipher_mask) {
-		mt76_clear(dev, addr + 2 * 4, MT_WTBL_W2_KEY_TYPE);
-		return;
-	}
-
-	if (cmd != SET_KEY)
-		return;
-
 	if (cipher == MT_CIPHER_BIP_CMAC_128 &&
 	    cipher_mask & ~BIT(MT_CIPHER_BIP_CMAC_128))
 		return;
@@ -1295,8 +1274,7 @@ mt7615_mac_wtbl_update_cipher(struct mt7
 
 int __mt7615_mac_wtbl_set_key(struct mt7615_dev *dev,
 			      struct mt76_wcid *wcid,
-			      struct ieee80211_key_conf *key,
-			      enum set_key_cmd cmd)
+			      struct ieee80211_key_conf *key)
 {
 	enum mt76_cipher_type cipher;
 	u16 cipher_mask = wcid->cipher;
@@ -1306,19 +1284,14 @@ int __mt7615_mac_wtbl_set_key(struct mt7
 	if (cipher == MT_CIPHER_NONE)
 		return -EOPNOTSUPP;
 
-	if (cmd == SET_KEY)
-		cipher_mask |= BIT(cipher);
-	else
-		cipher_mask &= ~BIT(cipher);
-
-	mt7615_mac_wtbl_update_cipher(dev, wcid, cipher, cipher_mask, cmd);
-	err = mt7615_mac_wtbl_update_key(dev, wcid, key, cipher, cipher_mask,
-					 cmd);
+	cipher_mask |= BIT(cipher);
+	mt7615_mac_wtbl_update_cipher(dev, wcid, cipher, cipher_mask);
+	err = mt7615_mac_wtbl_update_key(dev, wcid, key, cipher, cipher_mask);
 	if (err < 0)
 		return err;
 
 	err = mt7615_mac_wtbl_update_pk(dev, wcid, cipher, cipher_mask,
-					key->keyidx, cmd);
+					key->keyidx);
 	if (err < 0)
 		return err;
 
@@ -1329,13 +1302,12 @@ int __mt7615_mac_wtbl_set_key(struct mt7
 
 int mt7615_mac_wtbl_set_key(struct mt7615_dev *dev,
 			    struct mt76_wcid *wcid,
-			    struct ieee80211_key_conf *key,
-			    enum set_key_cmd cmd)
+			    struct ieee80211_key_conf *key)
 {
 	int err;
 
 	spin_lock_bh(&dev->mt76.lock);
-	err = __mt7615_mac_wtbl_set_key(dev, wcid, key, cmd);
+	err = __mt7615_mac_wtbl_set_key(dev, wcid, key);
 	spin_unlock_bh(&dev->mt76.lock);
 
 	return err;
--- a/drivers/net/wireless/mediatek/mt76/mt7615/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
@@ -391,18 +391,17 @@ static int mt7615_set_key(struct ieee802
 
 	if (cmd == SET_KEY)
 		*wcid_keyidx = idx;
-	else if (idx == *wcid_keyidx)
-		*wcid_keyidx = -1;
-	else
+	else {
+		if (idx == *wcid_keyidx)
+			*wcid_keyidx = -1;
 		goto out;
+	}
 
-	mt76_wcid_key_setup(&dev->mt76, wcid,
-			    cmd == SET_KEY ? key : NULL);
-
+	mt76_wcid_key_setup(&dev->mt76, wcid, key);
 	if (mt76_is_mmio(&dev->mt76))
-		err = mt7615_mac_wtbl_set_key(dev, wcid, key, cmd);
+		err = mt7615_mac_wtbl_set_key(dev, wcid, key);
 	else
-		err = __mt7615_mac_wtbl_set_key(dev, wcid, key, cmd);
+		err = __mt7615_mac_wtbl_set_key(dev, wcid, key);
 
 out:
 	mt7615_mutex_release(dev);
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h
@@ -484,11 +484,9 @@ int mt7615_mac_write_txwi(struct mt7615_
 void mt7615_mac_set_timing(struct mt7615_phy *phy);
 int __mt7615_mac_wtbl_set_key(struct mt7615_dev *dev,
 			      struct mt76_wcid *wcid,
-			      struct ieee80211_key_conf *key,
-			      enum set_key_cmd cmd);
+			      struct ieee80211_key_conf *key);
 int mt7615_mac_wtbl_set_key(struct mt7615_dev *dev, struct mt76_wcid *wcid,
-			    struct ieee80211_key_conf *key,
-			    enum set_key_cmd cmd);
+			    struct ieee80211_key_conf *key);
 void mt7615_mac_reset_work(struct work_struct *work);
 u32 mt7615_mac_get_sta_tid_sn(struct mt7615_dev *dev, int wcid, u8 tid);
 
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -455,20 +455,20 @@ int mt76x02_set_key(struct ieee80211_hw
 	msta = sta ? (struct mt76x02_sta *)sta->drv_priv : NULL;
 	wcid = msta ? &msta->wcid : &mvif->group_wcid;
 
-	if (cmd == SET_KEY) {
-		key->hw_key_idx = wcid->idx;
-		wcid->hw_key_idx = idx;
-		if (key->flags & IEEE80211_KEY_FLAG_RX_MGMT) {
-			key->flags |= IEEE80211_KEY_FLAG_SW_MGMT_TX;
-			wcid->sw_iv = true;
-		}
-	} else {
+	if (cmd != SET_KEY) {
 		if (idx == wcid->hw_key_idx) {
 			wcid->hw_key_idx = -1;
 			wcid->sw_iv = false;
 		}
 
-		key = NULL;
+		return 0;
+	}
+
+	key->hw_key_idx = wcid->idx;
+	wcid->hw_key_idx = idx;
+	if (key->flags & IEEE80211_KEY_FLAG_RX_MGMT) {
+		key->flags |= IEEE80211_KEY_FLAG_SW_MGMT_TX;
+		wcid->sw_iv = true;
 	}
 	mt76_wcid_key_setup(&dev->mt76, wcid, key);
 
--- a/drivers/net/wireless/mediatek/mt76/mt7915/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
@@ -410,16 +410,15 @@ static int mt7915_set_key(struct ieee802
 		mt7915_mcu_add_bss_info(phy, vif, true);
 	}
 
-	if (cmd == SET_KEY)
+	if (cmd == SET_KEY) {
 		*wcid_keyidx = idx;
-	else if (idx == *wcid_keyidx)
-		*wcid_keyidx = -1;
-	else
+	} else {
+		if (idx == *wcid_keyidx)
+			*wcid_keyidx = -1;
 		goto out;
+	}
 
-	mt76_wcid_key_setup(&dev->mt76, wcid,
-			    cmd == SET_KEY ? key : NULL);
-
+	mt76_wcid_key_setup(&dev->mt76, wcid, key);
 	err = mt76_connac_mcu_add_key(&dev->mt76, vif, &msta->bip,
 				      key, MCU_EXT_CMD(STA_REC_UPDATE),
 				      &msta->wcid, cmd);
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -569,16 +569,15 @@ static int mt7921_set_key(struct ieee802
 
 	mt7921_mutex_acquire(dev);
 
-	if (cmd == SET_KEY)
+	if (cmd == SET_KEY) {
 		*wcid_keyidx = idx;
-	else if (idx == *wcid_keyidx)
-		*wcid_keyidx = -1;
-	else
+	} else {
+		if (idx == *wcid_keyidx)
+			*wcid_keyidx = -1;
 		goto out;
+	}
 
-	mt76_wcid_key_setup(&dev->mt76, wcid,
-			    cmd == SET_KEY ? key : NULL);
-
+	mt76_wcid_key_setup(&dev->mt76, wcid, key);
 	err = mt76_connac_mcu_add_key(&dev->mt76, vif, &msta->bip,
 				      key, MCU_UNI_CMD(STA_REC_UPDATE),
 				      &msta->wcid, cmd);
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -351,16 +351,15 @@ static int mt7996_set_key(struct ieee802
 		mt7996_mcu_add_bss_info(phy, vif, true);
 	}
 
-	if (cmd == SET_KEY)
+	if (cmd == SET_KEY) {
 		*wcid_keyidx = idx;
-	else if (idx == *wcid_keyidx)
-		*wcid_keyidx = -1;
-	else
+	} else {
+		if (idx == *wcid_keyidx)
+			*wcid_keyidx = -1;
 		goto out;
+	}
 
-	mt76_wcid_key_setup(&dev->mt76, wcid,
-			    cmd == SET_KEY ? key : NULL);
-
+	mt76_wcid_key_setup(&dev->mt76, wcid, key);
 	err = mt7996_mcu_add_key(&dev->mt76, vif, &msta->bip,
 				 key, MCU_WMWA_UNI_CMD(STA_REC_UPDATE),
 				 &msta->wcid, cmd);


