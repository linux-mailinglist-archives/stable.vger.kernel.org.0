Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3111670AE
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 08:47:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728475AbgBUHrS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:47:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:42934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728258AbgBUHrJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:47:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B618024673;
        Fri, 21 Feb 2020 07:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271229;
        bh=j5FNwqbiDd3zQGbUoiAPV81bz+Jo7tUnvf567ZMQT54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y0hw9TGNjHHkOel62rS5KwV3JA2CZhsFr1vP/hcpQLSQsR7d0UqQxYL4HTfVV86Yx
         +t5f159w8iP3w+HrRect//1Uajp1uHechkq+V7vrgTwfcACZk4xqykznLBiSumSejH
         iBwD+Bi2vk17BLjLzRufZF0bBEXPz+RQyu6i00/A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Chris Chiu <chiu@endlessm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 088/399] rtw88: fix rate mask for 1SS chip
Date:   Fri, 21 Feb 2020 08:36:53 +0100
Message-Id: <20200221072410.889008864@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit 35a68fa5f96a80797e11b6952a47c5a84939a7bf ]

The rate mask is used to tell firmware the supported rate depends on
negotiation. We loop 2 times for all VHT/HT 2SS rate mask first, and then
only keep the part according to chip's NSS.

This commit fixes the logic error of '&' operations for VHT/HT rate, and
we should run this logic before adding legacy rate.

To access HT MCS map, index 0/1 represent MCS 0-7/8-15 respectively. Use
NL80211_BAND_xxx is incorrect, so fix it as well.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Reviewed-by: Chris Chiu <chiu@endlessm.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/main.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index ae61415e16654..f369ddca953af 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -706,8 +706,8 @@ void rtw_update_sta_info(struct rtw_dev *rtwdev, struct rtw_sta_info *si)
 		if (sta->vht_cap.cap & IEEE80211_VHT_CAP_SHORT_GI_80)
 			is_support_sgi = true;
 	} else if (sta->ht_cap.ht_supported) {
-		ra_mask |= (sta->ht_cap.mcs.rx_mask[NL80211_BAND_5GHZ] << 20) |
-			   (sta->ht_cap.mcs.rx_mask[NL80211_BAND_2GHZ] << 12);
+		ra_mask |= (sta->ht_cap.mcs.rx_mask[1] << 20) |
+			   (sta->ht_cap.mcs.rx_mask[0] << 12);
 		if (sta->ht_cap.cap & IEEE80211_HT_CAP_RX_STBC)
 			stbc_en = HT_STBC_EN;
 		if (sta->ht_cap.cap & IEEE80211_HT_CAP_LDPC_CODING)
@@ -717,6 +717,9 @@ void rtw_update_sta_info(struct rtw_dev *rtwdev, struct rtw_sta_info *si)
 			is_support_sgi = true;
 	}
 
+	if (efuse->hw_cap.nss == 1)
+		ra_mask &= RA_MASK_VHT_RATES_1SS | RA_MASK_HT_RATES_1SS;
+
 	if (hal->current_band_type == RTW_BAND_5G) {
 		ra_mask |= (u64)sta->supp_rates[NL80211_BAND_5GHZ] << 4;
 		if (sta->vht_cap.vht_supported) {
@@ -750,11 +753,6 @@ void rtw_update_sta_info(struct rtw_dev *rtwdev, struct rtw_sta_info *si)
 		wireless_set = 0;
 	}
 
-	if (efuse->hw_cap.nss == 1) {
-		ra_mask &= RA_MASK_VHT_RATES_1SS;
-		ra_mask &= RA_MASK_HT_RATES_1SS;
-	}
-
 	switch (sta->bandwidth) {
 	case IEEE80211_STA_RX_BW_80:
 		bw_mode = RTW_CHANNEL_WIDTH_80;
-- 
2.20.1



