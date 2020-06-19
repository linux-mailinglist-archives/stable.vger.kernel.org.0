Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ADC220122F
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394001AbgFSPtm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:49:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:56740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393359AbgFSPY7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:24:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF7A921548;
        Fri, 19 Jun 2020 15:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580298;
        bh=+6kXrgQ4NVOvyd8KUFY2r+iOtJb5sRwbTKszCOGlshU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i0u3FSHFE7hcGBsYK/FeygP+WklbmbSSx+tK54w+5A1YDaN9INDX/1WjHSIKAnb18
         o/NBqr8AYKbBII0/nc9L3fZ7Nsxsftti1DebRDjsx/wnB1Ku/czlv8WeODAU6cWZdN
         TOnr8bZ4OiEGjyBI+xzensJmVF5a2ZMkM9gDrMRI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 179/376] mt76: mt7615: do not always reset the dfs state setting the channel
Date:   Fri, 19 Jun 2020 16:31:37 +0200
Message-Id: <20200619141718.830907647@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit fdb786cce0ef3615dcbb30d8baf06a1d4cb7a344 ]

mac80211/hostapd runs mt7615_set_channel with the same channel
parameters sending multiple rdd commands overwriting the previous ones.
This behaviour is causing tpt issues on dfs channels.
Fix the issue checking new channel freq/width with the running one.

Fixes: 5dabdf71e94e ("mt76: mt7615: add multiple wiphy support to the dfs support code")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7615/main.c  | 21 ++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/main.c b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
index 6586176c29af..f92ac9a916fc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
@@ -218,6 +218,25 @@ static void mt7615_remove_interface(struct ieee80211_hw *hw,
 	spin_unlock_bh(&dev->sta_poll_lock);
 }
 
+static void mt7615_init_dfs_state(struct mt7615_phy *phy)
+{
+	struct mt76_phy *mphy = phy->mt76;
+	struct ieee80211_hw *hw = mphy->hw;
+	struct cfg80211_chan_def *chandef = &hw->conf.chandef;
+
+	if (hw->conf.flags & IEEE80211_CONF_OFFCHANNEL)
+		return;
+
+	if (!(chandef->chan->flags & IEEE80211_CHAN_RADAR))
+		return;
+
+	if (mphy->chandef.chan->center_freq == chandef->chan->center_freq &&
+	    mphy->chandef.width == chandef->width)
+		return;
+
+	phy->dfs_state = -1;
+}
+
 static int mt7615_set_channel(struct mt7615_phy *phy)
 {
 	struct mt7615_dev *dev = phy->dev;
@@ -229,7 +248,7 @@ static int mt7615_set_channel(struct mt7615_phy *phy)
 	mutex_lock(&dev->mt76.mutex);
 	set_bit(MT76_RESET, &phy->mt76->state);
 
-	phy->dfs_state = -1;
+	mt7615_init_dfs_state(phy);
 	mt76_set_channel(phy->mt76);
 
 	ret = mt7615_mcu_set_chan_info(phy, MCU_EXT_CMD_CHANNEL_SWITCH);
-- 
2.25.1



