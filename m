Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F166638341C
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240960AbhEQPF3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:05:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:32846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241684AbhEQPDE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:03:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A16A61A06;
        Mon, 17 May 2021 14:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261673;
        bh=/SzXmTGqbDyxVH+gy01NWuzrI1L3UAsKsg/UFD0dWOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bd8lkvTV9CbWiaG4ugBxjsTQaKsROGkb/8rF17qJR7BECajPTnvfyCn6RUOoBb+9D
         cX3wbjM7DRU+Bo1UARbmzEjFIvRcwac4k/dGMuVrJZKy2OEgXt99BnEv7SV9k9sl8G
         w30b9PI8YdW43wcx+j1N2XuwsiEvYgP0XLrwbnx8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shayne Chen <shayne.chen@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 050/289] mt76: mt7915: fix txpower init for TSSI off chips
Date:   Mon, 17 May 2021 15:59:35 +0200
Message-Id: <20210517140306.882608717@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shayne Chen <shayne.chen@mediatek.com>

[ Upstream commit a226ccd04c479ccd23d6927c64bad1b441707f70 ]

Fix incorrect txpower init value for TSSI off chips which causes
too small txpower.

Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/mediatek/mt76/mt7915/eeprom.c    | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c
index 7deba7ebd68a..e4c5f968f706 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c
@@ -104,7 +104,7 @@ int mt7915_eeprom_get_target_power(struct mt7915_dev *dev,
 				   struct ieee80211_channel *chan,
 				   u8 chain_idx)
 {
-	int index;
+	int index, target_power;
 	bool tssi_on;
 
 	if (chain_idx > 3)
@@ -113,15 +113,22 @@ int mt7915_eeprom_get_target_power(struct mt7915_dev *dev,
 	tssi_on = mt7915_tssi_enabled(dev, chan->band);
 
 	if (chan->band == NL80211_BAND_2GHZ) {
-		index = MT_EE_TX0_POWER_2G + chain_idx * 3 + !tssi_on;
+		index = MT_EE_TX0_POWER_2G + chain_idx * 3;
+		target_power = mt7915_eeprom_read(dev, index);
+
+		if (!tssi_on)
+			target_power += mt7915_eeprom_read(dev, index + 1);
 	} else {
-		int group = tssi_on ?
-			    mt7915_get_channel_group(chan->hw_value) : 8;
+		int group = mt7915_get_channel_group(chan->hw_value);
+
+		index = MT_EE_TX0_POWER_5G + chain_idx * 12;
+		target_power = mt7915_eeprom_read(dev, index + group);
 
-		index = MT_EE_TX0_POWER_5G + chain_idx * 12 + group;
+		if (!tssi_on)
+			target_power += mt7915_eeprom_read(dev, index + 8);
 	}
 
-	return mt7915_eeprom_read(dev, index);
+	return target_power;
 }
 
 static const u8 sku_cck_delta_map[] = {
-- 
2.30.2



