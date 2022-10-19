Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8525A60486F
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 15:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232218AbiJSN4b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 09:56:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230297AbiJSNxQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 09:53:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A74361C883B;
        Wed, 19 Oct 2022 06:36:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2E74B82322;
        Wed, 19 Oct 2022 08:51:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02488C433D7;
        Wed, 19 Oct 2022 08:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169464;
        bh=wde+d8xYopnhbnQaBQyev8/m4C8AapAZ0029aEYLjS4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T0+vtTQdBenIxFwumBYKCmeOyfk8K23dpNoJJS4dOOmPA3ALloQrfcXDO53lv061m
         0vibgIvZd0t5mztji29kowHCZiMeDDgjrk8/EPZs3Yfu/0srqd/FyswC4+GhFRJd31
         JbgSsF+2+o1m7Ry/rWfX2Tz46emwGEJoC1PKIyoA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 286/862] wifi: mt76: mt7921: add mt7921_mutex_acquire at mt7921_[start, stop]_ap
Date:   Wed, 19 Oct 2022 10:26:13 +0200
Message-Id: <20221019083302.651159389@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit 52b44015f031f629f1ce1d73415a2017593c7ade ]

Add mt7921_mutex_acquire at mt7921_[start, stop]_ap to fix the race
with the context holding dev->muxtex and the driver might access the
device in low power state.

Fixes: 9d958b60ebc2 ("mt76: mt7921: fix command timeout in AP stop period")
Tested-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7921/main.c  | 21 ++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index 1438a9f8d1fd..63fd33dcd3af 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -1526,17 +1526,23 @@ mt7921_start_ap(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	struct mt7921_dev *dev = mt7921_hw_dev(hw);
 	int err;
 
+	mt7921_mutex_acquire(dev);
+
 	err = mt76_connac_mcu_uni_add_bss(phy->mt76, vif, &mvif->sta.wcid,
 					  true);
 	if (err)
-		return err;
+		goto out;
 
 	err = mt7921_mcu_set_bss_pm(dev, vif, true);
 	if (err)
-		return err;
+		goto out;
+
+	err = mt7921_mcu_sta_update(dev, NULL, vif, true,
+				    MT76_STA_INFO_STATE_NONE);
+out:
+	mt7921_mutex_release(dev);
 
-	return mt7921_mcu_sta_update(dev, NULL, vif, true,
-				     MT76_STA_INFO_STATE_NONE);
+	return err;
 }
 
 static void
@@ -1548,11 +1554,16 @@ mt7921_stop_ap(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	struct mt7921_dev *dev = mt7921_hw_dev(hw);
 	int err;
 
+	mt7921_mutex_acquire(dev);
+
 	err = mt7921_mcu_set_bss_pm(dev, vif, false);
 	if (err)
-		return;
+		goto out;
 
 	mt76_connac_mcu_uni_add_bss(phy->mt76, vif, &mvif->sta.wcid, false);
+
+out:
+	mt7921_mutex_release(dev);
 }
 
 const struct ieee80211_ops mt7921_ops = {
-- 
2.35.1



