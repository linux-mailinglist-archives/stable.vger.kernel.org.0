Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DC2E351FD6
	for <lists+stable@lfdr.de>; Thu,  1 Apr 2021 21:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234133AbhDAT3m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Apr 2021 15:29:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234606AbhDAT3V (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Apr 2021 15:29:21 -0400
Received: from mail-oo1-xc34.google.com (mail-oo1-xc34.google.com [IPv6:2607:f8b0:4864:20::c34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 304A8C061794;
        Thu,  1 Apr 2021 12:27:39 -0700 (PDT)
Received: by mail-oo1-xc34.google.com with SMTP id n12-20020a4ad12c0000b02901b63e7bc1b4so808911oor.5;
        Thu, 01 Apr 2021 12:27:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wjPjc+8FIq2AYvHo2qH4COY12GYN3E777K47Jzp6c34=;
        b=VExv72LV857S/Uy1xIU8MAdpJFOhQYJbN5qUaHDO/2kNla1Eai3j+umg2DPw/0X7m9
         NZ8J+09EZod3rcvaFChyCh0laQk0DzwyeUVUbKRSJ6DppjlZVZbpy8OIFr8zj1l2Nm/v
         TP7q0AUaB5VMMDf4dqWRg0mOs4JqkvY7Q5QJeI+XVRxKNTYhuvugcrLYPTdOTLr9jwIx
         SIH8O68qUIxf+yc2DpBXy/kCC9HheUpa9SECw+CxtXstRj9wcX8JxSgeNuCYNxLn7H0m
         7YlTmddx7RE2RkTxIRGgL6nek+4jWazf7ddxbwAIszoDh/4KlvL9DLO0opsfl8SHTMgs
         poSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=wjPjc+8FIq2AYvHo2qH4COY12GYN3E777K47Jzp6c34=;
        b=S9bf8zuotX0NAQy7cFBua6hVcsul8lt4JktydqdmcZTZ4lbGhiLZL8vvCUmVVwRyP7
         IH94w4pSF3QpFeRhPxjt82FK4pWnwCDG5ZRlEQmv5ayFp4D3SEdPS1zvFnvcSqSV80Ic
         17bsgHpXXw/44TD0NQzowJNI1AsEdzDM6vVrlbVqgbb9Z2W3uJTqcuSWuproaLq7PwmC
         idCihoPXyI0bGVuWLcCDQf0K61Qz0H4NMeKcvJ+B2ecS0kljuVHMEOyWa6mwxXFozaFh
         f8rhrEr2rWusVt8ex5kdyXJxkGuLheLb8Y1DriVNtLZGESMl3NQyeejJqwDM/0/2j6Id
         Ocxg==
X-Gm-Message-State: AOAM531xsqnINwky1+NHDhSQEwh0AeWQy7o94ASfIXqYjmQJNyJNdtGw
        Z+/Q4jzg6Kc8YzxaTUdNuoz3OO82GtM=
X-Google-Smtp-Source: ABdhPJxas3D3FDsqR3ov8vKXX3UgCJZLSKFyEwFVKiBEYOgk8tvCj8v+xopL0sBPwoRLNE9x4Nl85Q==
X-Received: by 2002:a4a:e058:: with SMTP id v24mr8532572oos.83.1617305258480;
        Thu, 01 Apr 2021 12:27:38 -0700 (PDT)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id y194sm1274683ooa.19.2021.04.01.12.27.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 12:27:37 -0700 (PDT)
Sender: Larry Finger <larry.finger@gmail.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        =?UTF-8?q?=D0=91=D0=BE=D0=B3=D0=B4=D0=B0=D0=BD=20=D0=9F=D0=B8=D0=BB=D0=B8=D0=BF=D0=B5=D0=BD=D0=BA=D0=BE?= 
        <bogdan.pylypenko107@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Stable <stable@vger.kernel.org>
Subject: [PATCH] rtw88: Fix array overrun in rtw_get_tx_power_params()
Date:   Thu,  1 Apr 2021 14:27:17 -0500
Message-Id: <20210401192717.28927-1-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ping-Ke Shih <pkshih@realtek.com>

Using a kernel with the Undefined Behaviour Sanity Checker (UBSAN) enabled, the
following array overrun is logged:

================================================================================
UBSAN: array-index-out-of-bounds in /home/finger/wireless-drivers-next/drivers/net/wireless/realtek/rtw88/phy.c:1789:34
index 5 is out of range for type 'u8 [5]'
CPU: 2 PID: 84 Comm: kworker/u16:3 Tainted: G           O      5.12.0-rc5-00086-gd88bba47038e-dirty #651
Hardware name: TOSHIBA TECRA A50-A/TECRA A50-A, BIOS Version 4.50   09/29/2014
Workqueue: phy0 ieee80211_scan_work [mac80211]
Call Trace:
 dump_stack+0x64/0x7c
 ubsan_epilogue+0x5/0x40
 __ubsan_handle_out_of_bounds.cold+0x43/0x48
 rtw_get_tx_power_params+0x83a/drivers/net/wireless/realtek/rtw88/0xad0 [rtw_core]
 ? rtw_pci_read16+0x20/0x20 [rtw_pci]
 ? check_hw_ready+0x50/0x90 [rtw_core]
 rtw_phy_get_tx_power_index+0x4d/0xd0 [rtw_core]
 rtw_phy_set_tx_power_level+0xee/0x1b0 [rtw_core]
 rtw_set_channel+0xab/0x110 [rtw_core]
 rtw_ops_config+0x87/0xc0 [rtw_core]
 ieee80211_hw_config+0x9d/0x130 [mac80211]
 ieee80211_scan_state_set_channel+0x81/0x170 [mac80211]
 ieee80211_scan_work+0x19f/0x2a0 [mac80211]
 process_one_work+0x1dd/0x3a0
 worker_thread+0x49/0x330
 ? rescuer_thread+0x3a0/0x3a0
 kthread+0x134/0x150
 ? kthread_create_worker_on_cpu+0x70/0x70
 ret_from_fork+0x22/0x30
================================================================================

The statement where an array is being overrun is shown in the following snippet:

	if (rate <= DESC_RATE11M)
		tx_power = pwr_idx_2g->cck_base[group];
	else
====>		tx_power = pwr_idx_2g->bw40_base[group];

The associated arrays are defined in main.h as follows:

struct rtw_2g_txpwr_idx {
	u8 cck_base[6];
	u8 bw40_base[5];
	struct rtw_2g_1s_pwr_idx_diff ht_1s_diff;
	struct rtw_2g_ns_pwr_idx_diff ht_2s_diff;
	struct rtw_2g_ns_pwr_idx_diff ht_3s_diff;
	struct rtw_2g_ns_pwr_idx_diff ht_4s_diff;
};

The problem arises because the value of group is 5 for channel 14. The trivial
increase in the dimension of bw40_base fails as this struct must match the layout of
efuse. The fix is to add the rate as an argument to rtw_get_channel_group() and set
the group for channel 14 to 4 if rate <= DESC_RATE11M.

This patch fixes commit fa6dfe6bff24 ("rtw88: resolve order of tx power setting routines")

Fixes: fa6dfe6bff24 ("rtw88: resolve order of tx power setting routines")
Reported-by: Богдан Пилипенко <bogdan.pylypenko107@gmail.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Cc: Stable <stable@vger.kernel.org>
---
 drivers/net/wireless/realtek/rtw88/phy.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/phy.c b/drivers/net/wireless/realtek/rtw88/phy.c
index e114ddecac09..0b3da5bef703 100644
--- a/drivers/net/wireless/realtek/rtw88/phy.c
+++ b/drivers/net/wireless/realtek/rtw88/phy.c
@@ -1584,7 +1584,7 @@ void rtw_phy_load_tables(struct rtw_dev *rtwdev)
 }
 EXPORT_SYMBOL(rtw_phy_load_tables);
 
-static u8 rtw_get_channel_group(u8 channel)
+static u8 rtw_get_channel_group(u8 channel, u8 rate)
 {
 	switch (channel) {
 	default:
@@ -1628,6 +1628,7 @@ static u8 rtw_get_channel_group(u8 channel)
 	case 106:
 		return 4;
 	case 14:
+		return rate <= DESC_RATE11M ? 5 : 4;
 	case 108:
 	case 110:
 	case 112:
@@ -1879,7 +1880,7 @@ void rtw_get_tx_power_params(struct rtw_dev *rtwdev, u8 path, u8 rate, u8 bw,
 	s8 *remnant = &pwr_param->pwr_remnant;
 
 	pwr_idx = &rtwdev->efuse.txpwr_idx_table[path];
-	group = rtw_get_channel_group(ch);
+	group = rtw_get_channel_group(ch, rate);
 
 	/* base power index for 2.4G/5G */
 	if (IS_CH_2G_BAND(ch)) {
-- 
2.30.2

