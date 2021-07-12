Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 261D03C5416
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345147AbhGLH46 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:56:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:40586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352116AbhGLHwa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:52:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 379CF6054E;
        Mon, 12 Jul 2021 07:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076181;
        bh=eGzSN00GiFfqTy3Ki4+llqfOX5fkH5UApbsovZH9q50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AcvLHy1J3BGrYnCBLwBKswdzb0xoH0boCIJgvgG9FLpr/YC+ZW6EiR87//K0WkUoH
         qhKZe5wcJqV/cVOHWRW1rtoNnUU18ECliT7k59DM4z3bPth3ZqsTfKbl3RJn9Zbmkf
         XPb+YHJXVj8fNDmWjzOvhNuCf6C/kkZEMf0pAx7g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Po-Hao Huang <phhuang@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 534/800] rtw88: 8822c: fix lc calibration timing
Date:   Mon, 12 Jul 2021 08:09:17 +0200
Message-Id: <20210712061024.149471871@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
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
index 6cb593cc33c2..6d06f26a4894 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
@@ -4371,26 +4371,28 @@ static void rtw8822c_pwrtrack_set(struct rtw_dev *rtwdev, u8 rf_path)
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
 
@@ -4401,12 +4403,12 @@ static void __rtw8822c_pwr_track(struct rtw_dev *rtwdev)
 
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



