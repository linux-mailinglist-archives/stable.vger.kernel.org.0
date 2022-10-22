Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68BD1608708
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232165AbiJVHzv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:55:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232195AbiJVHyW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:54:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BDA3951C9;
        Sat, 22 Oct 2022 00:47:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E83E2B82E1F;
        Sat, 22 Oct 2022 07:46:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DFB8C433D6;
        Sat, 22 Oct 2022 07:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424782;
        bh=u/+7TSvDsljNqBSiPYLaoz8YvmB2nRnkyRvQUBWU3+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YVK84GHyDIXinA6ZJParbRBOLInosDLhvEUIfRyWjFabsgb5b5dthVHsYuxff6yLe
         EsADctQkR5m6dP3oAOW23q9TCWhrnC4GaGepxGVJo65RDCHm/wbsF1IOVY0TrPCkJ4
         31R4zE85YA6YNKfnPXMeS46eSjunRPHjidAzBbZs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bitterblue Smith <rtl8821cerfe2@gmail.com>,
        Jes Sorensen <jes@trained-monkey.org>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 275/717] wifi: rtl8xxxu: gen2: Enable 40 MHz channel width
Date:   Sat, 22 Oct 2022 09:22:34 +0200
Message-Id: <20221022072502.922263635@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bitterblue Smith <rtl8821cerfe2@gmail.com>

[ Upstream commit a8b5aef2cca15b7fa533421d462e4e0a3429bd6f ]

The module parameter ht40_2g was supposed to enable 40 MHz operation,
but it didn't.

Tell the firmware about the channel width when updating the rate mask.
This makes it work with my gen 2 chip RTL8188FU.

I'm not sure if anything needs to be done for the gen 1 chips, if 40
MHz channel width already works or not. They update the rate mask with
a different structure which doesn't have a field for the channel width.

Also set the channel width correctly for sta_statistics.

Fixes: f653e69009c6 ("rtl8xxxu: Implement basic 8723b specific update_rate_mask() function")
Fixes: bd917b3d28c9 ("rtl8xxxu: fill up txrate info for gen1 chips")
Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Acked-by: Jes Sorensen <jes@trained-monkey.org>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/3a950997-7580-8a6b-97a0-e0a81a135456@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu.h  |  6 +++---
 .../wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 21 +++++++++++++------
 2 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 7ddce3c3f0c4..782b089a2e1b 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -1425,7 +1425,7 @@ struct rtl8xxxu_fileops {
 	void (*set_tx_power) (struct rtl8xxxu_priv *priv, int channel,
 			      bool ht40);
 	void (*update_rate_mask) (struct rtl8xxxu_priv *priv,
-				  u32 ramask, u8 rateid, int sgi);
+				  u32 ramask, u8 rateid, int sgi, int txbw_40mhz);
 	void (*report_connect) (struct rtl8xxxu_priv *priv,
 				u8 macid, bool connect);
 	void (*fill_txdesc) (struct ieee80211_hw *hw, struct ieee80211_hdr *hdr,
@@ -1511,9 +1511,9 @@ void rtl8xxxu_gen2_config_channel(struct ieee80211_hw *hw);
 void rtl8xxxu_gen1_usb_quirks(struct rtl8xxxu_priv *priv);
 void rtl8xxxu_gen2_usb_quirks(struct rtl8xxxu_priv *priv);
 void rtl8xxxu_update_rate_mask(struct rtl8xxxu_priv *priv,
-			       u32 ramask, u8 rateid, int sgi);
+			       u32 ramask, u8 rateid, int sgi, int txbw_40mhz);
 void rtl8xxxu_gen2_update_rate_mask(struct rtl8xxxu_priv *priv,
-				    u32 ramask, u8 rateid, int sgi);
+				    u32 ramask, u8 rateid, int sgi, int txbw_40mhz);
 void rtl8xxxu_gen1_report_connect(struct rtl8xxxu_priv *priv,
 				  u8 macid, bool connect);
 void rtl8xxxu_gen2_report_connect(struct rtl8xxxu_priv *priv,
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 472b00c70781..5f9d6cce1114 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -4320,7 +4320,7 @@ static void rtl8xxxu_sw_scan_complete(struct ieee80211_hw *hw,
 }
 
 void rtl8xxxu_update_rate_mask(struct rtl8xxxu_priv *priv,
-			       u32 ramask, u8 rateid, int sgi)
+			       u32 ramask, u8 rateid, int sgi, int txbw_40mhz)
 {
 	struct h2c_cmd h2c;
 
@@ -4340,10 +4340,15 @@ void rtl8xxxu_update_rate_mask(struct rtl8xxxu_priv *priv,
 }
 
 void rtl8xxxu_gen2_update_rate_mask(struct rtl8xxxu_priv *priv,
-				    u32 ramask, u8 rateid, int sgi)
+				    u32 ramask, u8 rateid, int sgi, int txbw_40mhz)
 {
 	struct h2c_cmd h2c;
-	u8 bw = RTL8XXXU_CHANNEL_WIDTH_20;
+	u8 bw;
+
+	if (txbw_40mhz)
+		bw = RTL8XXXU_CHANNEL_WIDTH_40;
+	else
+		bw = RTL8XXXU_CHANNEL_WIDTH_20;
 
 	memset(&h2c, 0, sizeof(struct h2c_cmd));
 
@@ -4621,7 +4626,11 @@ rtl8xxxu_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 						RATE_INFO_FLAGS_SHORT_GI;
 				}
 
-				rarpt->txrate.bw |= RATE_INFO_BW_20;
+				if (rtl8xxxu_ht40_2g &&
+				    (sta->deflink.ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40))
+					rarpt->txrate.bw = RATE_INFO_BW_40;
+				else
+					rarpt->txrate.bw = RATE_INFO_BW_20;
 			}
 			bit_rate = cfg80211_calculate_bitrate(&rarpt->txrate);
 			rarpt->bit_rate = bit_rate;
@@ -4630,7 +4639,7 @@ rtl8xxxu_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			priv->vif = vif;
 			priv->rssi_level = RTL8XXXU_RATR_STA_INIT;
 
-			priv->fops->update_rate_mask(priv, ramask, 0, sgi);
+			priv->fops->update_rate_mask(priv, ramask, 0, sgi, rarpt->txrate.bw == RATE_INFO_BW_40);
 
 			rtl8xxxu_write8(priv, REG_BCN_MAX_ERR, 0xff);
 
@@ -6343,7 +6352,7 @@ static void rtl8xxxu_refresh_rate_mask(struct rtl8xxxu_priv *priv,
 		}
 
 		priv->rssi_level = rssi_level;
-		priv->fops->update_rate_mask(priv, rate_bitmap, ratr_idx, sgi);
+		priv->fops->update_rate_mask(priv, rate_bitmap, ratr_idx, sgi, txbw_40mhz);
 	}
 }
 
-- 
2.35.1



