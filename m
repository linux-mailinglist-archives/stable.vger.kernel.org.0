Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA9B4999A1
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:46:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1455869AbiAXVgi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:36:38 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:46086 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443867AbiAXV1F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:27:05 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54888614B8;
        Mon, 24 Jan 2022 21:27:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68BDBC340E4;
        Mon, 24 Jan 2022 21:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059624;
        bh=3+demyXxz1HqrShCU0iSOzn9gxlNu+2vJqtRcEcN270=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PbCyQZoc8f0Y383/1nFgVx77mt3c7kjcoEEYzTkhmoEdlup/xcghwqasj1c2TLfwl
         jofNxmJXfoaL+xQpAmw28Aisth4ooesYdStUSM+BJ3WZFoTloM7YPp9f4BCECvpeFv
         RrNFTTvl4CQ3Uciy1+I8OqQOBNeTaqAecmZ9GCuU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Po-Hao Huang <phhuang@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0678/1039] rtw88: 8822c: update rx settings to prevent potential hw deadlock
Date:   Mon, 24 Jan 2022 19:41:07 +0100
Message-Id: <20220124184148.153062248@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Po-Hao Huang <phhuang@realtek.com>

[ Upstream commit c1afb26727d9e507d3e17a9890e7aaf7fc85cd55 ]

These settings enables mac to detect and recover when rx fifo
circuit deadlock occurs. Previous version missed this, so we fix it.

Signed-off-by: Po-Hao Huang <phhuang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20211217012708.8623-1-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/main.c     | 2 +-
 drivers/net/wireless/realtek/rtw88/rtw8821c.h | 2 +-
 drivers/net/wireless/realtek/rtw88/rtw8822b.c | 2 +-
 drivers/net/wireless/realtek/rtw88/rtw8822c.c | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index a0d4d6e31fb49..dbf1ce3daeb8e 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -1868,7 +1868,7 @@ int rtw_core_init(struct rtw_dev *rtwdev)
 
 	/* default rx filter setting */
 	rtwdev->hal.rcr = BIT_APP_FCS | BIT_APP_MIC | BIT_APP_ICV |
-			  BIT_HTC_LOC_CTRL | BIT_APP_PHYSTS |
+			  BIT_PKTCTL_DLEN | BIT_HTC_LOC_CTRL | BIT_APP_PHYSTS |
 			  BIT_AB | BIT_AM | BIT_APM;
 
 	ret = rtw_load_firmware(rtwdev, RTW_NORMAL_FW);
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8821c.h b/drivers/net/wireless/realtek/rtw88/rtw8821c.h
index 112faa60f653e..d9fbddd7b0f35 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8821c.h
+++ b/drivers/net/wireless/realtek/rtw88/rtw8821c.h
@@ -131,7 +131,7 @@ _rtw_write32s_mask(struct rtw_dev *rtwdev, u32 addr, u32 mask, u32 data)
 #define WLAN_TX_FUNC_CFG2		0x30
 #define WLAN_MAC_OPT_NORM_FUNC1		0x98
 #define WLAN_MAC_OPT_LB_FUNC1		0x80
-#define WLAN_MAC_OPT_FUNC2		0x30810041
+#define WLAN_MAC_OPT_FUNC2		0xb0810041
 
 #define WLAN_SIFS_CFG	(WLAN_SIFS_CCK_CONT_TX | \
 			(WLAN_SIFS_OFDM_CONT_TX << BIT_SHIFT_SIFS_OFDM_CTX) | \
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822b.c b/drivers/net/wireless/realtek/rtw88/rtw8822b.c
index c409c8c29ec8b..e870ad7518342 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822b.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822b.c
@@ -205,7 +205,7 @@ static void rtw8822b_phy_set_param(struct rtw_dev *rtwdev)
 #define WLAN_TX_FUNC_CFG2		0x30
 #define WLAN_MAC_OPT_NORM_FUNC1		0x98
 #define WLAN_MAC_OPT_LB_FUNC1		0x80
-#define WLAN_MAC_OPT_FUNC2		0x30810041
+#define WLAN_MAC_OPT_FUNC2		0xb0810041
 
 #define WLAN_SIFS_CFG	(WLAN_SIFS_CCK_CONT_TX | \
 			(WLAN_SIFS_OFDM_CONT_TX << BIT_SHIFT_SIFS_OFDM_CTX) | \
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.c b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
index 46b881e8e4feb..0e1c5d95d4649 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
@@ -1962,7 +1962,7 @@ static void rtw8822c_phy_set_param(struct rtw_dev *rtwdev)
 #define WLAN_TX_FUNC_CFG2		0x30
 #define WLAN_MAC_OPT_NORM_FUNC1		0x98
 #define WLAN_MAC_OPT_LB_FUNC1		0x80
-#define WLAN_MAC_OPT_FUNC2		0x30810041
+#define WLAN_MAC_OPT_FUNC2		0xb0810041
 #define WLAN_MAC_INT_MIG_CFG		0x33330000
 
 #define WLAN_SIFS_CFG	(WLAN_SIFS_CCK_CONT_TX | \
-- 
2.34.1



