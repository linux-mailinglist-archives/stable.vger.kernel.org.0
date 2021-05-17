Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D55EA38318D
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241017AbhEQOhX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:37:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:34064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240861AbhEQOfU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:35:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB5AF6192C;
        Mon, 17 May 2021 14:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261025;
        bh=rzPKGCCyOWG0IsVFzJvEuH9ieNnkx1wr7i4wPvLTRjQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EsC2ij8mSB1XZUX/J8Uyhbjm3YnVck9Z0zkJBRClEfgKEDPgw1FjgwA8HzSY5QC3e
         8v/OO3l9xlB7JK48jsvT6XdV9he4zPDmZUpeeqHZOtnlj+wtrCoPY96Vxt6l+Q70Fk
         Y27zLuCqQSWCfsYBrsro0wmavcYfW9HxJBA/9E+4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 058/329] mt76: mt7615: fix key set/delete issues
Date:   Mon, 17 May 2021 15:59:29 +0200
Message-Id: <20210517140304.030920861@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 730d6d0da8d8f5905faafe645a5b3c08ac3f5a8f ]

There were multiple issues in the current key set/remove code:
- deleting a key with the previous key index deletes the current key
- BIP key would only be uploaded correctly initially and corrupted on rekey

Rework the code to better keep track of multiple keys and check for the
key index before deleting the current key

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76.h     |  1 +
 .../net/wireless/mediatek/mt76/mt7615/mac.c   | 97 ++++++++++---------
 .../net/wireless/mediatek/mt76/mt7615/main.c  | 18 ++--
 3 files changed, 65 insertions(+), 51 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 5da6b74687ed..7a551811d203 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -222,6 +222,7 @@ struct mt76_wcid {
 
 	u16 idx;
 	u8 hw_key_idx;
+	u8 hw_key_idx2;
 
 	u8 sta:1;
 	u8 ext_phy:1;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
index 2cb24c26a074..b2f6cda5a681 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
@@ -1031,7 +1031,7 @@ EXPORT_SYMBOL_GPL(mt7615_mac_set_rates);
 static int
 mt7615_mac_wtbl_update_key(struct mt7615_dev *dev, struct mt76_wcid *wcid,
 			   struct ieee80211_key_conf *key,
-			   enum mt7615_cipher_type cipher,
+			   enum mt7615_cipher_type cipher, u16 cipher_mask,
 			   enum set_key_cmd cmd)
 {
 	u32 addr = mt7615_mac_wtbl_addr(dev, wcid->idx) + 30 * 4;
@@ -1048,22 +1048,22 @@ mt7615_mac_wtbl_update_key(struct mt7615_dev *dev, struct mt76_wcid *wcid,
 			memcpy(data + 16, key->key + 24, 8);
 			memcpy(data + 24, key->key + 16, 8);
 		} else {
-			if (cipher != MT_CIPHER_BIP_CMAC_128 && wcid->cipher)
-				memmove(data + 16, data, 16);
-			if (cipher != MT_CIPHER_BIP_CMAC_128 || !wcid->cipher)
+			if (cipher_mask == BIT(cipher))
 				memcpy(data, key->key, key->keylen);
-			else if (cipher == MT_CIPHER_BIP_CMAC_128)
+			else if (cipher != MT_CIPHER_BIP_CMAC_128)
+				memcpy(data, key->key, 16);
+			if (cipher == MT_CIPHER_BIP_CMAC_128)
 				memcpy(data + 16, key->key, 16);
 		}
 	} else {
-		if (wcid->cipher & ~BIT(cipher)) {
-			if (cipher != MT_CIPHER_BIP_CMAC_128)
-				memmove(data, data + 16, 16);
+		if (cipher == MT_CIPHER_BIP_CMAC_128)
 			memset(data + 16, 0, 16);
-		} else {
+		else if (cipher_mask)
+			memset(data, 0, 16);
+		if (!cipher_mask)
 			memset(data, 0, sizeof(data));
-		}
 	}
+
 	mt76_wr_copy(dev, addr, data, sizeof(data));
 
 	return 0;
@@ -1071,7 +1071,7 @@ mt7615_mac_wtbl_update_key(struct mt7615_dev *dev, struct mt76_wcid *wcid,
 
 static int
 mt7615_mac_wtbl_update_pk(struct mt7615_dev *dev, struct mt76_wcid *wcid,
-			  enum mt7615_cipher_type cipher,
+			  enum mt7615_cipher_type cipher, u16 cipher_mask,
 			  int keyidx, enum set_key_cmd cmd)
 {
 	u32 addr = mt7615_mac_wtbl_addr(dev, wcid->idx), w0, w1;
@@ -1081,20 +1081,23 @@ mt7615_mac_wtbl_update_pk(struct mt7615_dev *dev, struct mt76_wcid *wcid,
 
 	w0 = mt76_rr(dev, addr);
 	w1 = mt76_rr(dev, addr + 4);
-	if (cmd == SET_KEY) {
-		w0 |= MT_WTBL_W0_RX_KEY_VALID |
-		      FIELD_PREP(MT_WTBL_W0_RX_IK_VALID,
-				 cipher == MT_CIPHER_BIP_CMAC_128);
-		if (cipher != MT_CIPHER_BIP_CMAC_128 ||
-		    !wcid->cipher)
-			w0 |= FIELD_PREP(MT_WTBL_W0_KEY_IDX, keyidx);
-	}  else {
-		if (!(wcid->cipher & ~BIT(cipher)))
-			w0 &= ~(MT_WTBL_W0_RX_KEY_VALID |
-				MT_WTBL_W0_KEY_IDX);
-		if (cipher == MT_CIPHER_BIP_CMAC_128)
-			w0 &= ~MT_WTBL_W0_RX_IK_VALID;
+
+	if (cipher_mask)
+		w0 |= MT_WTBL_W0_RX_KEY_VALID;
+	else
+		w0 &= ~(MT_WTBL_W0_RX_KEY_VALID | MT_WTBL_W0_KEY_IDX);
+	if (cipher_mask & BIT(MT_CIPHER_BIP_CMAC_128))
+		w0 |= MT_WTBL_W0_RX_IK_VALID;
+	else
+		w0 &= ~MT_WTBL_W0_RX_IK_VALID;
+
+	if (cmd == SET_KEY &&
+	    (cipher != MT_CIPHER_BIP_CMAC_128 ||
+	     cipher_mask == BIT(cipher))) {
+		w0 &= ~MT_WTBL_W0_KEY_IDX;
+		w0 |= FIELD_PREP(MT_WTBL_W0_KEY_IDX, keyidx);
 	}
+
 	mt76_wr(dev, MT_WTBL_RICR0, w0);
 	mt76_wr(dev, MT_WTBL_RICR1, w1);
 
@@ -1107,24 +1110,25 @@ mt7615_mac_wtbl_update_pk(struct mt7615_dev *dev, struct mt76_wcid *wcid,
 
 static void
 mt7615_mac_wtbl_update_cipher(struct mt7615_dev *dev, struct mt76_wcid *wcid,
-			      enum mt7615_cipher_type cipher,
+			      enum mt7615_cipher_type cipher, u16 cipher_mask,
 			      enum set_key_cmd cmd)
 {
 	u32 addr = mt7615_mac_wtbl_addr(dev, wcid->idx);
 
-	if (cmd == SET_KEY) {
-		if (cipher != MT_CIPHER_BIP_CMAC_128 || !wcid->cipher)
-			mt76_rmw(dev, addr + 2 * 4, MT_WTBL_W2_KEY_TYPE,
-				 FIELD_PREP(MT_WTBL_W2_KEY_TYPE, cipher));
-	} else {
-		if (cipher != MT_CIPHER_BIP_CMAC_128 &&
-		    wcid->cipher & BIT(MT_CIPHER_BIP_CMAC_128))
-			mt76_rmw(dev, addr + 2 * 4, MT_WTBL_W2_KEY_TYPE,
-				 FIELD_PREP(MT_WTBL_W2_KEY_TYPE,
-					    MT_CIPHER_BIP_CMAC_128));
-		else if (!(wcid->cipher & ~BIT(cipher)))
-			mt76_clear(dev, addr + 2 * 4, MT_WTBL_W2_KEY_TYPE);
+	if (!cipher_mask) {
+		mt76_clear(dev, addr + 2 * 4, MT_WTBL_W2_KEY_TYPE);
+		return;
 	}
+
+	if (cmd != SET_KEY)
+		return;
+
+	if (cipher == MT_CIPHER_BIP_CMAC_128 &&
+	    cipher_mask & ~BIT(MT_CIPHER_BIP_CMAC_128))
+		return;
+
+	mt76_rmw(dev, addr + 2 * 4, MT_WTBL_W2_KEY_TYPE,
+		 FIELD_PREP(MT_WTBL_W2_KEY_TYPE, cipher));
 }
 
 int __mt7615_mac_wtbl_set_key(struct mt7615_dev *dev,
@@ -1133,25 +1137,30 @@ int __mt7615_mac_wtbl_set_key(struct mt7615_dev *dev,
 			      enum set_key_cmd cmd)
 {
 	enum mt7615_cipher_type cipher;
+	u16 cipher_mask = wcid->cipher;
 	int err;
 
 	cipher = mt7615_mac_get_cipher(key->cipher);
 	if (cipher == MT_CIPHER_NONE)
 		return -EOPNOTSUPP;
 
-	mt7615_mac_wtbl_update_cipher(dev, wcid, cipher, cmd);
-	err = mt7615_mac_wtbl_update_key(dev, wcid, key, cipher, cmd);
+	if (cmd == SET_KEY)
+		cipher_mask |= BIT(cipher);
+	else
+		cipher_mask &= ~BIT(cipher);
+
+	mt7615_mac_wtbl_update_cipher(dev, wcid, cipher, cipher_mask, cmd);
+	err = mt7615_mac_wtbl_update_key(dev, wcid, key, cipher, cipher_mask,
+					 cmd);
 	if (err < 0)
 		return err;
 
-	err = mt7615_mac_wtbl_update_pk(dev, wcid, cipher, key->keyidx, cmd);
+	err = mt7615_mac_wtbl_update_pk(dev, wcid, cipher, cipher_mask,
+					key->keyidx, cmd);
 	if (err < 0)
 		return err;
 
-	if (cmd == SET_KEY)
-		wcid->cipher |= BIT(cipher);
-	else
-		wcid->cipher &= ~BIT(cipher);
+	wcid->cipher = cipher_mask;
 
 	return 0;
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/main.c b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
index 0ec836af211c..cbfcf00377db 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
@@ -347,7 +347,8 @@ static int mt7615_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	struct mt7615_sta *msta = sta ? (struct mt7615_sta *)sta->drv_priv :
 				  &mvif->sta;
 	struct mt76_wcid *wcid = &msta->wcid;
-	int idx = key->keyidx, err;
+	int idx = key->keyidx, err = 0;
+	u8 *wcid_keyidx = &wcid->hw_key_idx;
 
 	/* The hardware does not support per-STA RX GTK, fallback
 	 * to software mode for these.
@@ -362,6 +363,7 @@ static int mt7615_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	/* fall back to sw encryption for unsupported ciphers */
 	switch (key->cipher) {
 	case WLAN_CIPHER_SUITE_AES_CMAC:
+		wcid_keyidx = &wcid->hw_key_idx2;
 		key->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIE;
 		break;
 	case WLAN_CIPHER_SUITE_TKIP:
@@ -379,12 +381,13 @@ static int mt7615_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 
 	mt7615_mutex_acquire(dev);
 
-	if (cmd == SET_KEY) {
-		key->hw_key_idx = wcid->idx;
-		wcid->hw_key_idx = idx;
-	} else if (idx == wcid->hw_key_idx) {
-		wcid->hw_key_idx = -1;
-	}
+	if (cmd == SET_KEY)
+		*wcid_keyidx = idx;
+	else if (idx == *wcid_keyidx)
+		*wcid_keyidx = -1;
+	else
+		goto out;
+
 	mt76_wcid_key_setup(&dev->mt76, wcid,
 			    cmd == SET_KEY ? key : NULL);
 
@@ -393,6 +396,7 @@ static int mt7615_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	else
 		err = __mt7615_mac_wtbl_set_key(dev, wcid, key, cmd);
 
+out:
 	mt7615_mutex_release(dev);
 
 	return err;
-- 
2.30.2



