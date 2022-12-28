Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBB8165799A
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:03:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233409AbiL1PDJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:03:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233428AbiL1PCt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:02:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41E00E7D
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:02:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D10796153C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:02:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E13E9C433EF;
        Wed, 28 Dec 2022 15:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239767;
        bh=h0IEwXda+EjroiBPLPlZxFoKkZG2lqNiJJ+R5Y6/wiI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wG9Kf1DMo9oD2K4EUub6iQEThxPc24xWwvExWuclk5xJI5SEA8O5xyHMBZBpdI3fm
         oJklJoG8QtFGVCt5mkKDIztn6RAEvDZqNqyPwTFmsRXaSGyl0IGxDQUm1hNsT57JYM
         tPqNtuEYPOYb2iDN8dEzOoSL4Bt6d1CFsH0PZeGs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xing Song <xing.song@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 268/731] mt76: stop the radar detector after leaving dfs channel
Date:   Wed, 28 Dec 2022 15:36:15 +0100
Message-Id: <20221228144304.336776420@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xing Song <xing.song@mediatek.com>

[ Upstream commit 4e58ef4b6d727abdb071f7799aef763f8d6f2ad8 ]

The radar detctor is used for dfs channel. So it will start after switching
to dfs channel and will stop after leaving. The TX will be blocked if radar
detctor isn't stopped in non-dfs channel.

This patch resets the dfs state to indicate the radar detector needs to be
stopped.

Signed-off-by: Xing Song <xing.song@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/main.c | 3 ++-
 drivers/net/wireless/mediatek/mt76/mt7915/main.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/main.c b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
index 8f1338dae211..96667b7d722d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
@@ -290,7 +290,8 @@ static void mt7615_init_dfs_state(struct mt7615_phy *phy)
 	if (hw->conf.flags & IEEE80211_CONF_OFFCHANNEL)
 		return;
 
-	if (!(chandef->chan->flags & IEEE80211_CHAN_RADAR))
+	if (!(chandef->chan->flags & IEEE80211_CHAN_RADAR) &&
+	    !(mphy->chandef.chan->flags & IEEE80211_CHAN_RADAR))
 		return;
 
 	if (mphy->chandef.chan->center_freq == chandef->chan->center_freq &&
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/main.c b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
index 6aca470e2401..7a4f277a1622 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
@@ -302,7 +302,8 @@ static void mt7915_init_dfs_state(struct mt7915_phy *phy)
 	if (hw->conf.flags & IEEE80211_CONF_OFFCHANNEL)
 		return;
 
-	if (!(chandef->chan->flags & IEEE80211_CHAN_RADAR))
+	if (!(chandef->chan->flags & IEEE80211_CHAN_RADAR) &&
+	    !(mphy->chandef.chan->flags & IEEE80211_CHAN_RADAR))
 		return;
 
 	if (mphy->chandef.chan->center_freq == chandef->chan->center_freq &&
-- 
2.35.1



