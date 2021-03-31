Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4DB34C738
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232500AbhC2INU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:13:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:56008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232823AbhC2IMM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:12:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 780EB61481;
        Mon, 29 Mar 2021 08:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005532;
        bh=uxChkiT9kwx0wJFCpkTuGEJciCORHWx3NueifW3y3oU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZhX4lYxeX8Mx2gSu8CiFudgSH5i/+b5qGd727nUmJCU1vv94tXItDyZboKmNGG6zH
         C0P98DsvwosTi+1r/1DR2oWm9LsWhSSIQHukL4a86hhOooQmuvxizIgeE1euGLdDdj
         3CXrq9FcjyH5u5Na9Y5hlay4smRLdrz889PEOaFM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hayes Wang <hayeswang@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 006/111] Revert "r8152: adjust the settings about MAC clock speed down for RTL8153"
Date:   Mon, 29 Mar 2021 09:57:14 +0200
Message-Id: <20210329075615.405527510@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075615.186199980@linuxfoundation.org>
References: <20210329075615.186199980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>

[ Upstream commit 4b5dc1a94d4f92b5845e98bd9ae344b26d933aad ]

This reverts commit 134f98bcf1b898fb9d6f2b91bc85dd2e5478b4b8.

The r8153_mac_clk_spd() is used for RTL8153A only, because the register
table of RTL8153B is different from RTL8153A. However, this function would
be called when RTL8153B calls r8153_first_init() and r8153_enter_oob().
That causes RTL8153B becomes unstable when suspending and resuming. The
worst case may let the device stop working.

Besides, revert this commit to disable MAC clock speed down for RTL8153A.
It would avoid the known issue when enabling U1. The data of the first
control transfer may be wrong when exiting U1.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/r8152.c | 35 ++++++-----------------------------
 1 file changed, 6 insertions(+), 29 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 22f093797f41..486cf511d2bf 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -2836,29 +2836,6 @@ static void __rtl_set_wol(struct r8152 *tp, u32 wolopts)
 		device_set_wakeup_enable(&tp->udev->dev, false);
 }
 
-static void r8153_mac_clk_spd(struct r8152 *tp, bool enable)
-{
-	/* MAC clock speed down */
-	if (enable) {
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL,
-			       ALDPS_SPDWN_RATIO);
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL2,
-			       EEE_SPDWN_RATIO);
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL3,
-			       PKT_AVAIL_SPDWN_EN | SUSPEND_SPDWN_EN |
-			       U1U2_SPDWN_EN | L1_SPDWN_EN);
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL4,
-			       PWRSAVE_SPDWN_EN | RXDV_SPDWN_EN | TX10MIDLE_EN |
-			       TP100_SPDWN_EN | TP500_SPDWN_EN | EEE_SPDWN_EN |
-			       TP1000_SPDWN_EN);
-	} else {
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL, 0);
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL2, 0);
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL3, 0);
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL4, 0);
-	}
-}
-
 static void r8153_u1u2en(struct r8152 *tp, bool enable)
 {
 	u8 u1u2[8];
@@ -3158,11 +3135,9 @@ static void rtl8153_runtime_enable(struct r8152 *tp, bool enable)
 	if (enable) {
 		r8153_u1u2en(tp, false);
 		r8153_u2p3en(tp, false);
-		r8153_mac_clk_spd(tp, true);
 		rtl_runtime_suspend_enable(tp, true);
 	} else {
 		rtl_runtime_suspend_enable(tp, false);
-		r8153_mac_clk_spd(tp, false);
 
 		switch (tp->version) {
 		case RTL_VER_03:
@@ -3727,7 +3702,6 @@ static void r8153_first_init(struct r8152 *tp)
 	u32 ocp_data;
 	int i;
 
-	r8153_mac_clk_spd(tp, false);
 	rxdy_gated_en(tp, true);
 	r8153_teredo_off(tp);
 
@@ -3789,8 +3763,6 @@ static void r8153_enter_oob(struct r8152 *tp)
 	u32 ocp_data;
 	int i;
 
-	r8153_mac_clk_spd(tp, true);
-
 	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL);
 	ocp_data &= ~NOW_IS_OOB;
 	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL, ocp_data);
@@ -4498,9 +4470,14 @@ static void r8153_init(struct r8152 *tp)
 
 	ocp_write_word(tp, MCU_TYPE_USB, USB_CONNECT_TIMER, 0x0001);
 
+	/* MAC clock speed down */
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL, 0);
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL2, 0);
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL3, 0);
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL4, 0);
+
 	r8153_power_cut_en(tp, false);
 	r8153_u1u2en(tp, true);
-	r8153_mac_clk_spd(tp, false);
 	usb_enable_lpm(tp->udev);
 
 	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_CONFIG6);
-- 
2.30.1



