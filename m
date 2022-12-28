Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 518F8657E43
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:52:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234211AbiL1Pw1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:52:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230413AbiL1PwI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:52:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC72D18E0A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:51:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 497CF61560
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:51:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58E4BC433D2;
        Wed, 28 Dec 2022 15:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242715;
        bh=bfVACty6wrQMY9FGTLJ2CbgpKEkw+xMGqWk0IQOrlSU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Faa935DeRcVmMA7bhpQrfYQ8yeA97rigpGjFt6NkRCy1w4P8Sl3waMo68OssnOy3t
         eQb7lGSiUxWAL+Pqfy4ASvMN891uY5+1aIe4jz52BQKvGym9/mQcFRlMwH/Ma+/KmL
         RaSyTh7nG8UmcGboMT18gQY34KEK6MPD+3eqjuTI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shayne Chen <shayne.chen@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0443/1073] wifi: mt76: mt7915: rework eeprom tx paths and streams init
Date:   Wed, 28 Dec 2022 15:33:51 +0100
Message-Id: <20221228144340.063511114@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Shayne Chen <shayne.chen@mediatek.com>

[ Upstream commit a7ec8bcf00034ce84d4c9a15dffd7577fbed4db2 ]

Rework tx paths and streams init part to improve readability, and make
sure that the available tx streams should be smaller than or equal to
the available tx paths.

Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Stable-dep-of: de147cc28985 ("wifi: mt76: mt7915: Fix chainmask calculation on mt7915 DBDC")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/mediatek/mt76/mt7915/eeprom.c    | 57 ++++++++-----------
 .../wireless/mediatek/mt76/mt7915/eeprom.h    |  5 --
 2 files changed, 23 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c
index 4b1a9811646f..83bced0c0785 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c
@@ -173,60 +173,49 @@ static void mt7915_eeprom_parse_band_config(struct mt7915_phy *phy)
 void mt7915_eeprom_parse_hw_cap(struct mt7915_dev *dev,
 				struct mt7915_phy *phy)
 {
-	u8 nss, nss_band, nss_band_max, *eeprom = dev->mt76.eeprom.data;
+	u8 path, nss, nss_max = 4, *eeprom = dev->mt76.eeprom.data;
 	struct mt76_phy *mphy = phy->mt76;
-	bool ext_phy = phy != &dev->phy;
 
 	mt7915_eeprom_parse_band_config(phy);
 
-	/* read tx/rx mask from eeprom */
+	/* read tx/rx path from eeprom */
 	if (is_mt7915(&dev->mt76)) {
-		nss = FIELD_GET(MT_EE_WIFI_CONF0_TX_PATH,
-				eeprom[MT_EE_WIFI_CONF]);
+		path = FIELD_GET(MT_EE_WIFI_CONF0_TX_PATH,
+				 eeprom[MT_EE_WIFI_CONF]);
 	} else {
-		nss = FIELD_GET(MT_EE_WIFI_CONF0_TX_PATH,
-				eeprom[MT_EE_WIFI_CONF + phy->band_idx]);
+		path = FIELD_GET(MT_EE_WIFI_CONF0_TX_PATH,
+				 eeprom[MT_EE_WIFI_CONF + phy->band_idx]);
 	}
 
-	if (!nss || nss > 4)
-		nss = 4;
+	if (!path || path > 4)
+		path = 4;
 
 	/* read tx/rx stream */
-	nss_band = nss;
-
+	nss = path;
 	if (dev->dbdc_support) {
 		if (is_mt7915(&dev->mt76)) {
-			nss_band = FIELD_GET(MT_EE_WIFI_CONF3_TX_PATH_B0,
-					     eeprom[MT_EE_WIFI_CONF + 3]);
+			nss = FIELD_GET(MT_EE_WIFI_CONF3_TX_PATH_B0,
+					eeprom[MT_EE_WIFI_CONF + 3]);
 			if (phy->band_idx)
-				nss_band = FIELD_GET(MT_EE_WIFI_CONF3_TX_PATH_B1,
-						     eeprom[MT_EE_WIFI_CONF + 3]);
+				nss = FIELD_GET(MT_EE_WIFI_CONF3_TX_PATH_B1,
+						eeprom[MT_EE_WIFI_CONF + 3]);
 		} else {
-			nss_band = FIELD_GET(MT_EE_WIFI_CONF_STREAM_NUM,
-					     eeprom[MT_EE_WIFI_CONF + 2 + phy->band_idx]);
+			nss = FIELD_GET(MT_EE_WIFI_CONF_STREAM_NUM,
+					eeprom[MT_EE_WIFI_CONF + 2 + phy->band_idx]);
 		}
 
-		nss_band_max = is_mt7986(&dev->mt76) ?
-			       MT_EE_NSS_MAX_DBDC_MA7986 : MT_EE_NSS_MAX_DBDC_MA7915;
-	} else {
-		nss_band_max = is_mt7986(&dev->mt76) ?
-			       MT_EE_NSS_MAX_MA7986 : MT_EE_NSS_MAX_MA7915;
+		if (!is_mt7986(&dev->mt76))
+			nss_max = 2;
 	}
 
-	if (!nss_band || nss_band > nss_band_max)
-		nss_band = nss_band_max;
-
-	if (nss_band > nss) {
-		dev_warn(dev->mt76.dev,
-			 "nss mismatch, nss(%d) nss_band(%d) band(%d) ext_phy(%d)\n",
-			 nss, nss_band, phy->band_idx, ext_phy);
-		nss = nss_band;
-	}
+	if (!nss)
+		nss = nss_max;
+	nss = min_t(u8, min_t(u8, nss_max, nss), path);
 
-	mphy->chainmask = BIT(nss) - 1;
-	if (ext_phy)
+	mphy->chainmask = BIT(path) - 1;
+	if (phy->band_idx)
 		mphy->chainmask <<= dev->chainshift;
-	mphy->antenna_mask = BIT(nss_band) - 1;
+	mphy->antenna_mask = BIT(nss) - 1;
 	dev->chainmask |= mphy->chainmask;
 	dev->chainshift = hweight8(dev->mphy.chainmask);
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.h b/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.h
index 7578ac6d0be6..f3e56817d36e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.h
@@ -58,11 +58,6 @@ enum mt7915_eeprom_field {
 #define MT_EE_RATE_DELTA_SIGN			BIT(6)
 #define MT_EE_RATE_DELTA_EN			BIT(7)
 
-#define MT_EE_NSS_MAX_MA7915			4
-#define MT_EE_NSS_MAX_DBDC_MA7915		2
-#define MT_EE_NSS_MAX_MA7986			4
-#define MT_EE_NSS_MAX_DBDC_MA7986		4
-
 enum mt7915_adie_sku {
 	MT7976_ONE_ADIE_DBDC = 0x7,
 	MT7975_ONE_ADIE	= 0x8,
-- 
2.35.1



