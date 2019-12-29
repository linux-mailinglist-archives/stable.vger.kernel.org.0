Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F25BD12C962
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:18:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729585AbfL2SGx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 13:06:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:60908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731573AbfL2RtI (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:49:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41EB3207FF;
        Sun, 29 Dec 2019 17:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641746;
        bh=ws0R1g0j15YKhUMnG3lapPNN9B9BjO755A3NkHBUj7E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2bApEIE9RfIx+0n7yz0E2WAAePIF3BaojkRxPazGd5IBNeyK8VkukDVgQljkSzH9H
         Hca5hOZVwrv1LzrV0yW6kBtP8QqPHruyl4o0eFtZLD1XC73HxFq4JeM26r5x22BZCB
         msjKh4r1ilxJkjB7KSnC38vARyRn4LrX7+NWyhP8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 143/434] rtw88: coex: Set 4 slot mode for A2DP
Date:   Sun, 29 Dec 2019 18:23:16 +0100
Message-Id: <20191229172711.238593132@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit 12078aae453556a88fb46777b7cc5fc97f867b7c ]

With shallow buffer size, certain BT devices have active
A2DP flow control to fill buffer frequently. If the slot
is not at BT side, data can't be sent successfully to BT
devices, and will cause audio glitch.

To resolve this issue, this commit splits TUs into 4-slots
instead of 2-slot for all of the A2DP related coexistence
strategies. That makes BT have higher opportunity to fill
the A2DP buffer in time, and the audio quality could be
more stable and smooth.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/coex.c | 24 ++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/coex.c b/drivers/net/wireless/realtek/rtw88/coex.c
index 793b40bdbf7c..3e95ad198912 100644
--- a/drivers/net/wireless/realtek/rtw88/coex.c
+++ b/drivers/net/wireless/realtek/rtw88/coex.c
@@ -1308,6 +1308,7 @@ static void rtw_coex_action_bt_inquiry(struct rtw_dev *rtwdev)
 	struct rtw_chip_info *chip = rtwdev->chip;
 	bool wl_hi_pri = false;
 	u8 table_case, tdma_case;
+	u32 slot_type = 0;
 
 	if (coex_stat->wl_linkscan_proc || coex_stat->wl_hi_pri_task1 ||
 	    coex_stat->wl_hi_pri_task2)
@@ -1318,14 +1319,16 @@ static void rtw_coex_action_bt_inquiry(struct rtw_dev *rtwdev)
 		if (wl_hi_pri) {
 			table_case = 15;
 			if (coex_stat->bt_a2dp_exist &&
-			    !coex_stat->bt_pan_exist)
+			    !coex_stat->bt_pan_exist) {
+				slot_type = TDMA_4SLOT;
 				tdma_case = 11;
-			else if (coex_stat->wl_hi_pri_task1)
+			} else if (coex_stat->wl_hi_pri_task1) {
 				tdma_case = 6;
-			else if (!coex_stat->bt_page)
+			} else if (!coex_stat->bt_page) {
 				tdma_case = 8;
-			else
+			} else {
 				tdma_case = 9;
+			}
 		} else if (coex_stat->wl_connected) {
 			table_case = 10;
 			tdma_case = 10;
@@ -1361,7 +1364,7 @@ static void rtw_coex_action_bt_inquiry(struct rtw_dev *rtwdev)
 	rtw_coex_set_ant_path(rtwdev, false, COEX_SET_ANT_2G);
 	rtw_coex_set_rf_para(rtwdev, chip->wl_rf_para_rx[0]);
 	rtw_coex_table(rtwdev, table_case);
-	rtw_coex_tdma(rtwdev, false, tdma_case);
+	rtw_coex_tdma(rtwdev, false, tdma_case | slot_type);
 }
 
 static void rtw_coex_action_bt_hfp(struct rtw_dev *rtwdev)
@@ -1475,13 +1478,13 @@ static void rtw_coex_action_bt_a2dp(struct rtw_dev *rtwdev)
 
 	if (efuse->share_ant) {
 		/* Shared-Ant */
+		slot_type = TDMA_4SLOT;
+
 		if (coex_stat->wl_gl_busy && coex_stat->wl_noisy_level == 0)
 			table_case = 10;
 		else
 			table_case = 9;
 
-		slot_type = TDMA_4SLOT;
-
 		if (coex_stat->wl_gl_busy)
 			tdma_case = 13;
 		else
@@ -1585,13 +1588,14 @@ static void rtw_coex_action_bt_a2dp_hid(struct rtw_dev *rtwdev)
 
 	if (efuse->share_ant) {
 		/* Shared-Ant */
+		slot_type = TDMA_4SLOT;
+
 		if (coex_stat->bt_ble_exist)
 			table_case = 26;
 		else
 			table_case = 9;
 
 		if (coex_stat->wl_gl_busy) {
-			slot_type = TDMA_4SLOT;
 			tdma_case = 13;
 		} else {
 			tdma_case = 14;
@@ -1794,10 +1798,12 @@ static void rtw_coex_action_wl_linkscan(struct rtw_dev *rtwdev)
 	struct rtw_efuse *efuse = &rtwdev->efuse;
 	struct rtw_chip_info *chip = rtwdev->chip;
 	u8 table_case, tdma_case;
+	u32 slot_type = 0;
 
 	if (efuse->share_ant) {
 		/* Shared-Ant */
 		if (coex_stat->bt_a2dp_exist) {
+			slot_type = TDMA_4SLOT;
 			table_case = 9;
 			tdma_case = 11;
 		} else {
@@ -1818,7 +1824,7 @@ static void rtw_coex_action_wl_linkscan(struct rtw_dev *rtwdev)
 	rtw_coex_set_ant_path(rtwdev, true, COEX_SET_ANT_2G);
 	rtw_coex_set_rf_para(rtwdev, chip->wl_rf_para_rx[0]);
 	rtw_coex_table(rtwdev, table_case);
-	rtw_coex_tdma(rtwdev, false, tdma_case);
+	rtw_coex_tdma(rtwdev, false, tdma_case | slot_type);
 }
 
 static void rtw_coex_action_wl_not_connected(struct rtw_dev *rtwdev)
-- 
2.20.1



