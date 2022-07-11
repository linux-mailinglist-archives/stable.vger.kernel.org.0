Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4028556FC56
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233110AbiGKJmr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:42:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232557AbiGKJmR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:42:17 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFF2E9B9D5;
        Mon, 11 Jul 2022 02:21:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 269F1CE1256;
        Mon, 11 Jul 2022 09:21:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E27EC34115;
        Mon, 11 Jul 2022 09:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531272;
        bh=wct9TWBIQK2Q+mh6dK2ze1PHgs5Waxx3OF/u1J/ohq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LEh+7VUG6UDUhIFQZSZuML74eRbmLN3UmWT8pQ1uMF8ZM31geKPHCaB6QhR5ODEeS
         t7UJHo6BRd1pW5oIOmSpt5SW6W/2nhv8daia/OsJpQxaEH+WG2JucWkTOII5crEtnA
         Mc8Flac1nIALztNIgjkR5pE5OeXFze5UnpUbcrDo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 043/230] mt76: mt7921: get rid of mt7921_mac_set_beacon_filter
Date:   Mon, 11 Jul 2022 11:04:59 +0200
Message-Id: <20220711090605.304966389@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit b30363102a4122f6eed37927b64a2c7ac70b8859 ]

Remove mt7921_mac_set_beacon_filter routine since it is no longer used.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7921/mac.c   | 28 -------------------
 .../wireless/mediatek/mt76/mt7921/mt7921.h    |  3 --
 2 files changed, 31 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
index bef8d4a76ed9..426e7a32bdc8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
@@ -1573,34 +1573,6 @@ void mt7921_pm_power_save_work(struct work_struct *work)
 	queue_delayed_work(dev->mt76.wq, &dev->pm.ps_work, delta);
 }
 
-int mt7921_mac_set_beacon_filter(struct mt7921_phy *phy,
-				 struct ieee80211_vif *vif,
-				 bool enable)
-{
-	struct mt7921_dev *dev = phy->dev;
-	bool ext_phy = phy != &dev->phy;
-	int err;
-
-	if (!dev->pm.enable)
-		return -EOPNOTSUPP;
-
-	err = mt7921_mcu_set_bss_pm(dev, vif, enable);
-	if (err)
-		return err;
-
-	if (enable) {
-		vif->driver_flags |= IEEE80211_VIF_BEACON_FILTER;
-		mt76_set(dev, MT_WF_RFCR(ext_phy),
-			 MT_WF_RFCR_DROP_OTHER_BEACON);
-	} else {
-		vif->driver_flags &= ~IEEE80211_VIF_BEACON_FILTER;
-		mt76_clear(dev, MT_WF_RFCR(ext_phy),
-			   MT_WF_RFCR_DROP_OTHER_BEACON);
-	}
-
-	return 0;
-}
-
 void mt7921_coredump_work(struct work_struct *work)
 {
 	struct mt7921_dev *dev;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h b/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
index 2d8bd6bfc820..1aafd8723b3a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
@@ -381,9 +381,6 @@ int mt7921_mcu_fw_pmctrl(struct mt7921_dev *dev);
 void mt7921_pm_wake_work(struct work_struct *work);
 void mt7921_pm_power_save_work(struct work_struct *work);
 bool mt7921_wait_for_mcu_init(struct mt7921_dev *dev);
-int mt7921_mac_set_beacon_filter(struct mt7921_phy *phy,
-				 struct ieee80211_vif *vif,
-				 bool enable);
 void mt7921_pm_interface_iter(void *priv, u8 *mac, struct ieee80211_vif *vif);
 void mt7921_coredump_work(struct work_struct *work);
 int mt7921_wfsys_reset(struct mt7921_dev *dev);
-- 
2.35.1



