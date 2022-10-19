Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 255516040B6
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 12:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231672AbiJSKM7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 06:12:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232151AbiJSKMd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 06:12:33 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C68CE09C4;
        Wed, 19 Oct 2022 02:52:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 16B65CE21A3;
        Wed, 19 Oct 2022 09:09:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B89CC433B5;
        Wed, 19 Oct 2022 09:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170595;
        bh=44uRYNzLL2dyaeADFwbtAehncvGKf6ItaLtVtAl1DKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rOa9WMUBAm2LNOfyNlwnnp0ebKdGdaPzWYuPk+R1kXxZe/1c7NrSd0+37hLTcEHNM
         wwT48trz+E9eJLZ2dDYCE1zZTJcoihgjL/In5Tw0Col1Oe4kBQcMxcRUaCSlhz7TN6
         WcesL+OwyTyIr1JxPwQzOuA5gCdlLlrboqH5z9aU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Po-Hao Huang <phhuang@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 707/862] wifi: rtw89: fix rx filter after scan
Date:   Wed, 19 Oct 2022 10:33:14 +0200
Message-Id: <20221019083321.204392155@linuxfoundation.org>
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

From: Po-Hao Huang <phhuang@realtek.com>

[ Upstream commit 812825c2b204c491f1a5586c602e4ac75060493a ]

In monitor mode we should be able to received all packets even if it's not
destined to us. But after scan, the configuration was wrongly set, so we
fix it.

Signed-off-by: Po-Hao Huang <phhuang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20220916033811.13862-7-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/fw.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index 6473015a6b2a..c993fe9cf6b4 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -2289,6 +2289,7 @@ void rtw89_hw_scan_start(struct rtw89_dev *rtwdev, struct ieee80211_vif *vif,
 {
 	struct rtw89_vif *rtwvif = (struct rtw89_vif *)vif->drv_priv;
 	struct cfg80211_scan_request *req = &scan_req->req;
+	u32 rx_fltr = rtwdev->hal.rx_fltr;
 	u8 mac_addr[ETH_ALEN];
 
 	rtwdev->scan_info.scanning_vif = vif;
@@ -2303,13 +2304,13 @@ void rtw89_hw_scan_start(struct rtw89_dev *rtwdev, struct ieee80211_vif *vif,
 		ether_addr_copy(mac_addr, vif->addr);
 	rtw89_core_scan_start(rtwdev, rtwvif, mac_addr, true);
 
-	rtwdev->hal.rx_fltr &= ~B_AX_A_BCN_CHK_EN;
-	rtwdev->hal.rx_fltr &= ~B_AX_A_BC;
-	rtwdev->hal.rx_fltr &= ~B_AX_A_A1_MATCH;
+	rx_fltr &= ~B_AX_A_BCN_CHK_EN;
+	rx_fltr &= ~B_AX_A_BC;
+	rx_fltr &= ~B_AX_A_A1_MATCH;
 	rtw89_write32_mask(rtwdev,
 			   rtw89_mac_reg_by_idx(R_AX_RX_FLTR_OPT, RTW89_MAC_0),
 			   B_AX_RX_FLTR_CFG_MASK,
-			   rtwdev->hal.rx_fltr);
+			   rx_fltr);
 }
 
 void rtw89_hw_scan_complete(struct rtw89_dev *rtwdev, struct ieee80211_vif *vif,
@@ -2323,9 +2324,6 @@ void rtw89_hw_scan_complete(struct rtw89_dev *rtwdev, struct ieee80211_vif *vif,
 	if (!vif)
 		return;
 
-	rtwdev->hal.rx_fltr |= B_AX_A_BCN_CHK_EN;
-	rtwdev->hal.rx_fltr |= B_AX_A_BC;
-	rtwdev->hal.rx_fltr |= B_AX_A_A1_MATCH;
 	rtw89_write32_mask(rtwdev,
 			   rtw89_mac_reg_by_idx(R_AX_RX_FLTR_OPT, RTW89_MAC_0),
 			   B_AX_RX_FLTR_CFG_MASK,
-- 
2.35.1



