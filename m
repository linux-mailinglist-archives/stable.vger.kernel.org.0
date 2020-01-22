Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5FC4145694
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:36:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728792AbgAVN1x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:27:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:49614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731670AbgAVN1x (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:27:53 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F35252467C;
        Wed, 22 Jan 2020 13:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699671;
        bh=e8Cw5CEz40XxjFFTY++GYnQ9BsmtmQKiYE+BZgp/8zw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OUecjRxIKs+j5axh7/A1gOydNZyKtnkcVBk19kJhRHrgiW0WZKw49QYy8qOf0LhXA
         KAWjYFBWFSZTqMuFQgxXUS4gwuyR7wxAEJpMOGzIqOACrWjGbti3ZbyT87t8jb462n
         3tpkaQNHlDB+W2ILpR1UcKrwmE5eJCbf7zdmuKEw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tzu-En Huang <tehuang@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.4 214/222] rtw88: fix potential read outside array boundary
Date:   Wed, 22 Jan 2020 10:30:00 +0100
Message-Id: <20200122092849.017723181@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tzu-En Huang <tehuang@realtek.com>

commit 18a0696e85fde169e0109aa61d0505b2b935b59d upstream.

The level of cckpd is from 0 to 4, and it is the index of
array pd_lvl[] and cs_lvl[]. However, the length of both arrays
are 4, which is smaller than the possible maximum input index.
Enumerate cck level to make sure the max level will not be wrong
if new level is added in future.

Fixes: 479c4ee931a6 ("rtw88: add dynamic cck pd mechanism")
Signed-off-by: Tzu-En Huang <tehuang@realtek.com>
Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/realtek/rtw88/phy.c      |   17 ++++++++---------
 drivers/net/wireless/realtek/rtw88/phy.h      |    9 +++++++++
 drivers/net/wireless/realtek/rtw88/rtw8822c.c |    4 ++--
 3 files changed, 19 insertions(+), 11 deletions(-)

--- a/drivers/net/wireless/realtek/rtw88/phy.c
+++ b/drivers/net/wireless/realtek/rtw88/phy.c
@@ -118,7 +118,7 @@ static void rtw_phy_cck_pd_init(struct r
 
 	for (i = 0; i <= RTW_CHANNEL_WIDTH_40; i++) {
 		for (j = 0; j < RTW_RF_PATH_MAX; j++)
-			dm_info->cck_pd_lv[i][j] = 0;
+			dm_info->cck_pd_lv[i][j] = CCK_PD_LV0;
 	}
 
 	dm_info->cck_fa_avg = CCK_FA_AVG_RESET;
@@ -461,7 +461,6 @@ static void rtw_phy_dpk_track(struct rtw
 		chip->ops->dpk_track(rtwdev);
 }
 
-#define CCK_PD_LV_MAX		5
 #define CCK_PD_FA_LV1_MIN	1000
 #define CCK_PD_FA_LV0_MAX	500
 
@@ -471,10 +470,10 @@ static u8 rtw_phy_cck_pd_lv_unlink(struc
 	u32 cck_fa_avg = dm_info->cck_fa_avg;
 
 	if (cck_fa_avg > CCK_PD_FA_LV1_MIN)
-		return 1;
+		return CCK_PD_LV1;
 
 	if (cck_fa_avg < CCK_PD_FA_LV0_MAX)
-		return 0;
+		return CCK_PD_LV0;
 
 	return CCK_PD_LV_MAX;
 }
@@ -494,15 +493,15 @@ static u8 rtw_phy_cck_pd_lv_link(struct
 	u32 cck_fa_avg = dm_info->cck_fa_avg;
 
 	if (igi > CCK_PD_IGI_LV4_VAL && rssi > CCK_PD_RSSI_LV4_VAL)
-		return 4;
+		return CCK_PD_LV4;
 	if (igi > CCK_PD_IGI_LV3_VAL && rssi > CCK_PD_RSSI_LV3_VAL)
-		return 3;
+		return CCK_PD_LV3;
 	if (igi > CCK_PD_IGI_LV2_VAL || rssi > CCK_PD_RSSI_LV2_VAL)
-		return 2;
+		return CCK_PD_LV2;
 	if (cck_fa_avg > CCK_PD_FA_LV1_MIN)
-		return 1;
+		return CCK_PD_LV1;
 	if (cck_fa_avg < CCK_PD_FA_LV0_MAX)
-		return 0;
+		return CCK_PD_LV0;
 
 	return CCK_PD_LV_MAX;
 }
--- a/drivers/net/wireless/realtek/rtw88/phy.h
+++ b/drivers/net/wireless/realtek/rtw88/phy.h
@@ -125,6 +125,15 @@ rtw_get_tx_power_params(struct rtw_dev *
 			u8 rate, u8 bw, u8 ch, u8 regd,
 			struct rtw_power_params *pwr_param);
 
+enum rtw_phy_cck_pd_lv {
+	CCK_PD_LV0,
+	CCK_PD_LV1,
+	CCK_PD_LV2,
+	CCK_PD_LV3,
+	CCK_PD_LV4,
+	CCK_PD_LV_MAX,
+};
+
 #define	MASKBYTE0		0xff
 #define	MASKBYTE1		0xff00
 #define	MASKBYTE2		0xff0000
--- a/drivers/net/wireless/realtek/rtw88/rtw8822c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
@@ -3168,8 +3168,8 @@ rtw8822c_phy_cck_pd_set_reg(struct rtw_d
 static void rtw8822c_phy_cck_pd_set(struct rtw_dev *rtwdev, u8 new_lvl)
 {
 	struct rtw_dm_info *dm_info = &rtwdev->dm_info;
-	s8 pd_lvl[4] = {2, 4, 6, 8};
-	s8 cs_lvl[4] = {2, 2, 2, 4};
+	s8 pd_lvl[CCK_PD_LV_MAX] = {0, 2, 4, 6, 8};
+	s8 cs_lvl[CCK_PD_LV_MAX] = {0, 2, 2, 2, 4};
 	u8 cur_lvl;
 	u8 nrx, bw;
 


