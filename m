Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8B0E382F36
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236589AbhEQOOz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:14:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:44940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238747AbhEQOMU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:12:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9AFD2613C3;
        Mon, 17 May 2021 14:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260488;
        bh=Trd0JJwDgDYGYiJyGxOi67JsTy68AChB3NgyOQtk2Ik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GZPMUychhQjmp+F0E8/p8Y7o5RMzDcPRjcEAPuB4Yxh6XMLWEdMsLCAbB0xV4baz7
         BFakOTphIX7YHftwHqqJQDN1euw+JTo6FWpHpX9DINBNXa8W8eEpP0CBfun76jrned
         Y2ElAqq+H3b0W0KeDmqoErQDG8W1iU1S2hOmST2A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 068/363] mt76: mt7915: fix key set/delete issue
Date:   Mon, 17 May 2021 15:58:54 +0200
Message-Id: <20210517140304.901564817@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 1da4fd48d28436f8b690cdc2879603dede6d8355 ]

Deleting a key with the previous key index deletes the current key
Rework the code to better keep track of multiple keys and check for the
key index before deleting the current key

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7915/main.c  | 25 +++++++++++++------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/main.c b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
index 98f4b49642a8..bf032d943f74 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
@@ -317,7 +317,9 @@ static int mt7915_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	struct mt7915_sta *msta = sta ? (struct mt7915_sta *)sta->drv_priv :
 				  &mvif->sta;
 	struct mt76_wcid *wcid = &msta->wcid;
+	u8 *wcid_keyidx = &wcid->hw_key_idx;
 	int idx = key->keyidx;
+	int err = 0;
 
 	/* The hardware does not support per-STA RX GTK, fallback
 	 * to software mode for these.
@@ -332,6 +334,7 @@ static int mt7915_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	/* fall back to sw encryption for unsupported ciphers */
 	switch (key->cipher) {
 	case WLAN_CIPHER_SUITE_AES_CMAC:
+		wcid_keyidx = &wcid->hw_key_idx2;
 		key->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIE;
 		break;
 	case WLAN_CIPHER_SUITE_TKIP:
@@ -347,16 +350,24 @@ static int mt7915_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		return -EOPNOTSUPP;
 	}
 
-	if (cmd == SET_KEY) {
-		key->hw_key_idx = wcid->idx;
-		wcid->hw_key_idx = idx;
-	} else if (idx == wcid->hw_key_idx) {
-		wcid->hw_key_idx = -1;
-	}
+	mutex_lock(&dev->mt76.mutex);
+
+	if (cmd == SET_KEY)
+		*wcid_keyidx = idx;
+	else if (idx == *wcid_keyidx)
+		*wcid_keyidx = -1;
+	else
+		goto out;
+
 	mt76_wcid_key_setup(&dev->mt76, wcid,
 			    cmd == SET_KEY ? key : NULL);
 
-	return mt7915_mcu_add_key(dev, vif, msta, key, cmd);
+	err = mt7915_mcu_add_key(dev, vif, msta, key, cmd);
+
+out:
+	mutex_unlock(&dev->mt76.mutex);
+
+	return err;
 }
 
 static int mt7915_config(struct ieee80211_hw *hw, u32 changed)
-- 
2.30.2



