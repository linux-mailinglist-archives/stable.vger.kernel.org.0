Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC127594207
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243163AbiHOVJl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347963AbiHOVHt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:07:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D2D52DF5;
        Mon, 15 Aug 2022 12:17:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F04996009B;
        Mon, 15 Aug 2022 19:17:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 057BEC433D6;
        Mon, 15 Aug 2022 19:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591024;
        bh=4cp7xliMzBn+/YidW4XUZ9qJ3YykQDoffQ5NM1pymH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SBS1lX+if8MzYvkmtWkL7VpvTIEWZ1UKkfOYYQDuRhot1XYCHU2VMac1nMt+8/L57
         K9ivliSlYjJ8bDy3hJnvKGoGzoLx0s1DhVauuwvvBmTrH8mNkZho8qT+SkD/Ov/ECD
         Aixwoi26OHzb9z1Xf216swcR01YtP320JlROGgD4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0448/1095] mt76: mt7615: fix throughput regression on DFS channels
Date:   Mon, 15 Aug 2022 19:57:27 +0200
Message-Id: <20220815180448.160646959@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit aac86cebb4a09e3fa2c07589f79f7d0e07e8c9a4 ]

For some reason, mt7615 reacts badly to repeatedly enabling/disabling the radar
detector without also switching the channel.
This results in very bad throughput on DFS channels, because
hw->conf.radar_enabled can get toggled a few times after CAC ends.
Fix this by always leaving the DFS detector enabled on DFS channels and instead
suppress unwanted detection events.

Fixes: 2c86f6752046 ("mt76: mt7615: fix/rewrite the dfs state handling logic")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7615/mac.c   |  7 ++++---
 .../net/wireless/mediatek/mt76/mt7615/main.c  | 21 -------------------
 .../net/wireless/mediatek/mt76/mt7615/mcu.c   |  3 +++
 .../wireless/mediatek/mt76/mt7615/mt7615.h    |  1 -
 4 files changed, 7 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
index bd687f7de628..9e832b27170f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
@@ -2282,6 +2282,7 @@ mt7615_dfs_init_radar_specs(struct mt7615_phy *phy)
 
 int mt7615_dfs_init_radar_detector(struct mt7615_phy *phy)
 {
+	struct cfg80211_chan_def *chandef = &phy->mt76->chandef;
 	struct mt7615_dev *dev = phy->dev;
 	bool ext_phy = phy != &dev->phy;
 	enum mt76_dfs_state dfs_state, prev_state;
@@ -2292,13 +2293,13 @@ int mt7615_dfs_init_radar_detector(struct mt7615_phy *phy)
 
 	prev_state = phy->mt76->dfs_state;
 	dfs_state = mt76_phy_dfs_state(phy->mt76);
+	if ((chandef->chan->flags & IEEE80211_CHAN_RADAR) &&
+	    dfs_state < MT_DFS_STATE_CAC)
+		dfs_state = MT_DFS_STATE_ACTIVE;
 
 	if (prev_state == dfs_state)
 		return 0;
 
-	if (prev_state == MT_DFS_STATE_UNKNOWN)
-		mt7615_dfs_stop_radar_detector(phy);
-
 	if (dfs_state == MT_DFS_STATE_DISABLED)
 		goto stop;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/main.c b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
index 6b8e3e7ae4a2..36990637a8a2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
@@ -282,26 +282,6 @@ static void mt7615_remove_interface(struct ieee80211_hw *hw,
 	mt76_packet_id_flush(&dev->mt76, &mvif->sta.wcid);
 }
 
-static void mt7615_init_dfs_state(struct mt7615_phy *phy)
-{
-	struct mt76_phy *mphy = phy->mt76;
-	struct ieee80211_hw *hw = mphy->hw;
-	struct cfg80211_chan_def *chandef = &hw->conf.chandef;
-
-	if (hw->conf.flags & IEEE80211_CONF_OFFCHANNEL)
-		return;
-
-	if (!(chandef->chan->flags & IEEE80211_CHAN_RADAR) &&
-	    !(mphy->chandef.chan->flags & IEEE80211_CHAN_RADAR))
-		return;
-
-	if (mphy->chandef.chan->center_freq == chandef->chan->center_freq &&
-	    mphy->chandef.width == chandef->width)
-		return;
-
-	phy->dfs_state = -1;
-}
-
 int mt7615_set_channel(struct mt7615_phy *phy)
 {
 	struct mt7615_dev *dev = phy->dev;
@@ -314,7 +294,6 @@ int mt7615_set_channel(struct mt7615_phy *phy)
 
 	set_bit(MT76_RESET, &phy->mt76->state);
 
-	mt7615_init_dfs_state(phy);
 	mt76_set_channel(phy->mt76);
 
 	if (is_mt7615(&dev->mt76) && dev->flash_eeprom) {
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
index 6f3efec58afe..7127d6007ae0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
@@ -403,6 +403,9 @@ mt7615_mcu_rx_radar_detected(struct mt7615_dev *dev, struct sk_buff *skb)
 	if (r->band_idx && dev->mt76.phy2)
 		mphy = dev->mt76.phy2;
 
+	if (mt76_phy_dfs_state(mphy) < MT_DFS_STATE_CAC)
+		return;
+
 	ieee80211_radar_detected(mphy->hw);
 	dev->hw_pattern++;
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h b/drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h
index 2e91f6a27d0f..082c73b571ae 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h
@@ -177,7 +177,6 @@ struct mt7615_phy {
 
 	u8 chfreq;
 	u8 rdd_state;
-	int dfs_state;
 
 	u32 rx_ampdu_ts;
 	u32 ampdu_ref;
-- 
2.35.1



