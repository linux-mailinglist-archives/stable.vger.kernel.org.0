Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E0983C4E61
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244510AbhGLHS1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:18:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:55012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244151AbhGLHRW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:17:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3818E61249;
        Mon, 12 Jul 2021 07:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074074;
        bh=Nj8u04/u0OXXjp3ROqZYvnvteg8p192JBZOb0beQ41c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uj1F0sPUFFK4fLdPzAp/8K3skgWoE9cFHI/xzhJZvCRJZCoCixj1AnP5tG+LQrLw0
         mrU5Sg+KEBi7ob5k8a7B70F7ZlZ81FHajd84W5+5wVxut9Ah/pO+7i45/H20pNShDC
         ePxsK6UPrvI7qu620tQ3ewAhfFmCPu0HUQLre15M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Po-Hao Huang <phhuang@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 457/700] rtw88: 8822c: fix lc calibration timing
Date:   Mon, 12 Jul 2021 08:09:00 +0200
Message-Id: <20210712061025.163489019@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Po-Hao Huang <phhuang@realtek.com>

[ Upstream commit 05684fd583e1acc34dddea283838fbfbed4904a0 ]

Before this patch, we use value from 2 seconds ago to decide
whether we should do lc calibration.
Although this don't happen frequently, fix flow to the way it should be.

Fixes: 7ae7784ec2a8 ("rtw88: 8822c: add LC calibration for RTL8822C")
Signed-off-by: Po-Hao Huang <phhuang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210426013252.5665-3-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/rtw8822c.c | 22 ++++++++++---------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.c b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
index 448922cb2e63..10bb3b5a8c22 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
@@ -3529,26 +3529,28 @@ static void rtw8822c_pwrtrack_set(struct rtw_dev *rtwdev, u8 rf_path)
 	}
 }
 
-static void rtw8822c_pwr_track_path(struct rtw_dev *rtwdev,
-				    struct rtw_swing_table *swing_table,
-				    u8 path)
+static void rtw8822c_pwr_track_stats(struct rtw_dev *rtwdev, u8 path)
 {
-	struct rtw_dm_info *dm_info = &rtwdev->dm_info;
-	u8 thermal_value, delta;
+	u8 thermal_value;
 
 	if (rtwdev->efuse.thermal_meter[path] == 0xff)
 		return;
 
 	thermal_value = rtw_read_rf(rtwdev, path, RF_T_METER, 0x7e);
-
 	rtw_phy_pwrtrack_avg(rtwdev, thermal_value, path);
+}
 
-	delta = rtw_phy_pwrtrack_get_delta(rtwdev, path);
+static void rtw8822c_pwr_track_path(struct rtw_dev *rtwdev,
+				    struct rtw_swing_table *swing_table,
+				    u8 path)
+{
+	struct rtw_dm_info *dm_info = &rtwdev->dm_info;
+	u8 delta;
 
+	delta = rtw_phy_pwrtrack_get_delta(rtwdev, path);
 	dm_info->delta_power_index[path] =
 		rtw_phy_pwrtrack_get_pwridx(rtwdev, swing_table, path, path,
 					    delta);
-
 	rtw8822c_pwrtrack_set(rtwdev, path);
 }
 
@@ -3559,12 +3561,12 @@ static void __rtw8822c_pwr_track(struct rtw_dev *rtwdev)
 
 	rtw_phy_config_swing_table(rtwdev, &swing_table);
 
+	for (i = 0; i < rtwdev->hal.rf_path_num; i++)
+		rtw8822c_pwr_track_stats(rtwdev, i);
 	if (rtw_phy_pwrtrack_need_lck(rtwdev))
 		rtw8822c_do_lck(rtwdev);
-
 	for (i = 0; i < rtwdev->hal.rf_path_num; i++)
 		rtw8822c_pwr_track_path(rtwdev, &swing_table, i);
-
 }
 
 static void rtw8822c_pwr_track(struct rtw_dev *rtwdev)
-- 
2.30.2



