Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5F7F37C70B
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231774AbhELP56 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:57:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:50380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234773AbhELPw2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:52:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE92A619F1;
        Wed, 12 May 2021 15:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833206;
        bh=7gCOdZ1xzeW1azhkyGAh3K5QBRaNPeD6VUQQMWK8U2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JTzPu2NVOKrPA9iW8l1+9sa6Ps0msg2k6TryfR6B5zzagOImMUs3o3dKZ27X/zpIk
         MZYB7YqPITZcAALeumRpgEOvTZIJsNOYD+PCZXCO1IQkENzrxe8ShJiBc2TOhkfZBB
         q5wtnN3tOh92zd4ksw84ZMjb82wb2WZC/ICXgVBI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?=D0=91=D0=BE=D0=B3=D0=B4=D0=B0=D0=BD=20=D0=9F=D0=B8=D0=BB=D0=B8=D0=BF=D0=B5=D0=BD=D0=BA=D0=BE?= 
        <bogdan.pylypenko107@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.11 059/601] rtw88: Fix array overrun in rtw_get_tx_power_params()
Date:   Wed, 12 May 2021 16:42:16 +0200
Message-Id: <20210512144829.758191061@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ping-Ke Shih <pkshih@realtek.com>

commit 2ff25985ea9ccc6c9af2c77b0b49045adcc62e0e upstream.

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
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210401192717.28927-1-Larry.Finger@lwfinger.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtw88/phy.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/realtek/rtw88/phy.c
+++ b/drivers/net/wireless/realtek/rtw88/phy.c
@@ -1524,7 +1524,7 @@ void rtw_phy_load_tables(struct rtw_dev
 }
 EXPORT_SYMBOL(rtw_phy_load_tables);
 
-static u8 rtw_get_channel_group(u8 channel)
+static u8 rtw_get_channel_group(u8 channel, u8 rate)
 {
 	switch (channel) {
 	default:
@@ -1568,6 +1568,7 @@ static u8 rtw_get_channel_group(u8 chann
 	case 106:
 		return 4;
 	case 14:
+		return rate <= DESC_RATE11M ? 5 : 4;
 	case 108:
 	case 110:
 	case 112:
@@ -1819,7 +1820,7 @@ void rtw_get_tx_power_params(struct rtw_
 	s8 *remnant = &pwr_param->pwr_remnant;
 
 	pwr_idx = &rtwdev->efuse.txpwr_idx_table[path];
-	group = rtw_get_channel_group(ch);
+	group = rtw_get_channel_group(ch, rate);
 
 	/* base power index for 2.4G/5G */
 	if (IS_CH_2G_BAND(ch)) {


