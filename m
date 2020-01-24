Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02ADF147F5D
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:01:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731807AbgAXLBp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:01:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:34732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731514AbgAXLBo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:01:44 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1911214DB;
        Fri, 24 Jan 2020 11:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579863703;
        bh=b2gcdWP08K953ANq89598SNOcQgLnr9KVTe1AexgTLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QybG26HKlxEOCR9ZitDsyE3TUiearI68HxX3Jeyu2cEQYFe1uh3hdY/R9M6Wj40l3
         rw0+IxSbb7RcmKWZ7/1f//a9dRfcTcO6p2YWw/yye8dXdAAkIzG9dOVNzgkxaW1xgB
         52L4TEi20HM0Q4xyQOCGoyLP+IgVcy8xTWBamoYw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 052/639] rtlwifi: rtl8821ae: replace _rtl8821ae_mrate_idx_to_arfr_id with generic version
Date:   Fri, 24 Jan 2020 10:23:42 +0100
Message-Id: <20200124093053.924695752@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit c894696188d5c2af1e636e458190e80c53fb893d ]

Function _rtl8821ae_mrate_idx_to_arfr_id is functionally identical to
the generic version rtl_mrate_idx_to_arfr_id, so remove
_rtl8821ae_mrate_idx_to_arfr_id and use the generic one instead.

This also fixes a missing break statement found by CoverityScan in
_rtl8821ae_mrate_idx_to_arfr_id, namely: CID#1167237 ("Missing break
in switch")

Thanks to Joe Perches for spotting this when I submitted an earlier patch.

Fixes: 3c05bedb5fef ("Staging: rtl8812ae: Add Realtek 8821 PCI WIFI driver")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
ACKed-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/realtek/rtlwifi/rtl8821ae/hw.c   | 71 +------------------
 1 file changed, 1 insertion(+), 70 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
index 317c1b3101dad..ba258318ee9f3 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
@@ -3404,75 +3404,6 @@ static void rtl8821ae_update_hal_rate_table(struct ieee80211_hw *hw,
 		 "%x\n", rtl_read_dword(rtlpriv, REG_ARFR0));
 }
 
-static u8 _rtl8821ae_mrate_idx_to_arfr_id(
-	struct ieee80211_hw *hw, u8 rate_index,
-	enum wireless_mode wirelessmode)
-{
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_phy *rtlphy = &rtlpriv->phy;
-	u8 ret = 0;
-	switch (rate_index) {
-	case RATR_INX_WIRELESS_NGB:
-		if (rtlphy->rf_type == RF_1T1R)
-			ret = 1;
-		else
-			ret = 0;
-		; break;
-	case RATR_INX_WIRELESS_N:
-	case RATR_INX_WIRELESS_NG:
-		if (rtlphy->rf_type == RF_1T1R)
-			ret = 5;
-		else
-			ret = 4;
-		; break;
-	case RATR_INX_WIRELESS_NB:
-		if (rtlphy->rf_type == RF_1T1R)
-			ret = 3;
-		else
-			ret = 2;
-		; break;
-	case RATR_INX_WIRELESS_GB:
-		ret = 6;
-		break;
-	case RATR_INX_WIRELESS_G:
-		ret = 7;
-		break;
-	case RATR_INX_WIRELESS_B:
-		ret = 8;
-		break;
-	case RATR_INX_WIRELESS_MC:
-		if ((wirelessmode == WIRELESS_MODE_B)
-			|| (wirelessmode == WIRELESS_MODE_G)
-			|| (wirelessmode == WIRELESS_MODE_N_24G)
-			|| (wirelessmode == WIRELESS_MODE_AC_24G))
-			ret = 6;
-		else
-			ret = 7;
-	case RATR_INX_WIRELESS_AC_5N:
-		if (rtlphy->rf_type == RF_1T1R)
-			ret = 10;
-		else
-			ret = 9;
-		break;
-	case RATR_INX_WIRELESS_AC_24N:
-		if (rtlphy->current_chan_bw == HT_CHANNEL_WIDTH_80) {
-			if (rtlphy->rf_type == RF_1T1R)
-				ret = 10;
-			else
-				ret = 9;
-		} else {
-			if (rtlphy->rf_type == RF_1T1R)
-				ret = 11;
-			else
-				ret = 12;
-		}
-		break;
-	default:
-		ret = 0; break;
-	}
-	return ret;
-}
-
 static u32 _rtl8821ae_rate_to_bitmap_2ssvht(__le16 vht_rate)
 {
 	u8 i, j, tmp_rate;
@@ -3761,7 +3692,7 @@ static void rtl8821ae_update_hal_rate_mask(struct ieee80211_hw *hw,
 		break;
 	}
 
-	ratr_index = _rtl8821ae_mrate_idx_to_arfr_id(hw, ratr_index, wirelessmode);
+	ratr_index = rtl_mrate_idx_to_arfr_id(hw, ratr_index, wirelessmode);
 	sta_entry->ratr_index = ratr_index;
 	ratr_bitmap = _rtl8821ae_set_ra_vht_ratr_bitmap(hw, wirelessmode,
 							ratr_bitmap);
-- 
2.20.1



