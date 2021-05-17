Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C068B382F4E
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236705AbhEQOPG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:15:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:46438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238173AbhEQOMz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:12:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AEBA613DA;
        Mon, 17 May 2021 14:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260492;
        bh=iOKA6xzjmNWup0nc0mCEE6Ox7/7RVKM49ZXrU/Gum0c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WUbgSSX4vkVM3mgWTdR9qS5Bss3WyySpbUl5JxtWi8+LPCtM0vAXDdodD8RALTvK6
         rCMt2B0PeWcKXxiyDpANEFgIOuwg4FxII4gndV4a4VuDdcih2MPiJDJWDcdrkH5twJ
         XJJnYJ9owYhzTkrxgRY+7Up5fYSsX4f4mdQZY4DU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 070/363] mt76: mt7921: fix key set/delete issue
Date:   Mon, 17 May 2021 15:58:56 +0200
Message-Id: <20210517140304.963905516@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 60468f7fd7072c804b2613f1cadabace8d77d311 ]

Similar to the mt7915 driver, deleting a key with the previous key index
deletes the current key. Rework the code to better keep track of
multiple keys and check for the key index before deleting the current
key

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7921/main.c  | 25 +++++++++++++------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index cd9fd0e24e3e..ada943c7a950 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -413,7 +413,8 @@ static int mt7921_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	struct mt7921_sta *msta = sta ? (struct mt7921_sta *)sta->drv_priv :
 				  &mvif->sta;
 	struct mt76_wcid *wcid = &msta->wcid;
-	int idx = key->keyidx;
+	u8 *wcid_keyidx = &wcid->hw_key_idx;
+	int idx = key->keyidx, err = 0;
 
 	/* The hardware does not support per-STA RX GTK, fallback
 	 * to software mode for these.
@@ -429,6 +430,7 @@ static int mt7921_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	switch (key->cipher) {
 	case WLAN_CIPHER_SUITE_AES_CMAC:
 		key->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIE;
+		wcid_keyidx = &wcid->hw_key_idx2;
 		break;
 	case WLAN_CIPHER_SUITE_TKIP:
 	case WLAN_CIPHER_SUITE_CCMP:
@@ -443,16 +445,23 @@ static int mt7921_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		return -EOPNOTSUPP;
 	}
 
-	if (cmd == SET_KEY) {
-		key->hw_key_idx = wcid->idx;
-		wcid->hw_key_idx = idx;
-	} else if (idx == wcid->hw_key_idx) {
-		wcid->hw_key_idx = -1;
-	}
+	mt7921_mutex_acquire(dev);
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
 
-	return mt7921_mcu_add_key(dev, vif, msta, key, cmd);
+	err = mt7921_mcu_add_key(dev, vif, msta, key, cmd);
+out:
+	mt7921_mutex_release(dev);
+
+	return err;
 }
 
 static int mt7921_config(struct ieee80211_hw *hw, u32 changed)
-- 
2.30.2



