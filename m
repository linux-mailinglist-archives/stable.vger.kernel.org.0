Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD76211965B
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:26:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727814AbfLJV0Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:26:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:56986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729558AbfLJVZk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:25:40 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CBF13205C9;
        Tue, 10 Dec 2019 21:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576013139;
        bh=cNL+w5hmyJtoWwvZWcLJMvw4ijDgt/IQp22TT2F5qTw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JqXTVTMo2THfpflIOE6fz6PGZTETMszWMkvxwPphBVDb7e7QKfk9VhSLyeLqsTHow
         ka+9syrf8tBYxL6NCHEz5jAXAVj4xbItwGdwvvN+0xjrn2aaxoYpK7rBFUhYWKFlep
         gQ+fKnZNAKxURP/pjeueyy3ND1mTzuSAcrl0BJe4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        Sasha Levin <sashal@kernel.org>,
        linux-renesas-soc@vger.kernel.org, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 023/292] Revert "pinctrl: sh-pfc: r8a77990: Fix MOD_SEL1 bit31 when using SIM0_D"
Date:   Tue, 10 Dec 2019 16:20:42 -0500
Message-Id: <20191210212511.11392-23-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210212511.11392-1-sashal@kernel.org>
References: <20191210212511.11392-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 7666dfd533d4c55733037775d47a8e3551b341a2 ]

This reverts commit e167d723e1a472d252e5c4baf823b77ce5543b05.

According to the R-Car Gen3 Hardware Manual Errata for Rev 1.00 of Aug
24, 2018, the SEL_SIMCARD_{0,1} definition was to be deleted.  However,
this errata merely fixed an accidental double definition in the Hardware
User's Manual Rev. 1.00.  The real definition is still present in later
revisions of the manual (Rev. 1.50 and Rev. 2.00).

Hence revert the commit to recover the definition.

Based on a patch in the BSP by Takeshi Kihara
<takeshi.kihara.df@renesas.com>.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
Link: https://lore.kernel.org/r/20190904121658.2617-4-geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/sh-pfc/pfc-r8a77990.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/sh-pfc/pfc-r8a77990.c b/drivers/pinctrl/sh-pfc/pfc-r8a77990.c
index 3808409cab385..5200dadd6b3ef 100644
--- a/drivers/pinctrl/sh-pfc/pfc-r8a77990.c
+++ b/drivers/pinctrl/sh-pfc/pfc-r8a77990.c
@@ -448,6 +448,7 @@ FM(IP12_31_28)	IP12_31_28	FM(IP13_31_28)	IP13_31_28	FM(IP14_31_28)	IP14_31_28	FM
 #define MOD_SEL0_1_0	   REV4(FM(SEL_SPEED_PULSE_IF_0),	FM(SEL_SPEED_PULSE_IF_1),	FM(SEL_SPEED_PULSE_IF_2),	F_(0, 0))
 
 /* MOD_SEL1 */			/* 0 */				/* 1 */				/* 2 */				/* 3 */			/* 4 */			/* 5 */		/* 6 */		/* 7 */
+#define MOD_SEL1_31		FM(SEL_SIMCARD_0)		FM(SEL_SIMCARD_1)
 #define MOD_SEL1_30		FM(SEL_SSI2_0)			FM(SEL_SSI2_1)
 #define MOD_SEL1_29		FM(SEL_TIMER_TMU_0)		FM(SEL_TIMER_TMU_1)
 #define MOD_SEL1_28		FM(SEL_USB_20_CH0_0)		FM(SEL_USB_20_CH0_1)
@@ -469,6 +470,7 @@ FM(IP12_31_28)	IP12_31_28	FM(IP13_31_28)	IP13_31_28	FM(IP14_31_28)	IP14_31_28	FM
 
 #define PINMUX_MOD_SELS	\
 \
+			MOD_SEL1_31 \
 MOD_SEL0_30_29		MOD_SEL1_30 \
 			MOD_SEL1_29 \
 MOD_SEL0_28		MOD_SEL1_28 \
@@ -1197,7 +1199,7 @@ static const u16 pinmux_data[] = {
 	PINMUX_IPSR_MSEL(IP13_19_16,		RIF0_D1_A,	SEL_DRIF0_0),
 	PINMUX_IPSR_MSEL(IP13_19_16,		SDA1_B,		SEL_I2C1_1),
 	PINMUX_IPSR_MSEL(IP13_19_16,		TCLK2_B,	SEL_TIMER_TMU_1),
-	PINMUX_IPSR_GPSR(IP13_19_16,		SIM0_D_A),
+	PINMUX_IPSR_MSEL(IP13_19_16,		SIM0_D_A,	SEL_SIMCARD_0),
 
 	PINMUX_IPSR_GPSR(IP13_23_20,		MLB_DAT),
 	PINMUX_IPSR_MSEL(IP13_23_20,		TX0_B,		SEL_SCIF0_1),
@@ -1265,7 +1267,7 @@ static const u16 pinmux_data[] = {
 	PINMUX_IPSR_GPSR(IP15_15_12,		TPU0TO2),
 	PINMUX_IPSR_MSEL(IP15_15_12,		SDA1_D,		SEL_I2C1_3),
 	PINMUX_IPSR_MSEL(IP15_15_12,		FSO_CFE_1_N_B,	SEL_FSO_1),
-	PINMUX_IPSR_GPSR(IP15_15_12,		SIM0_D_B),
+	PINMUX_IPSR_MSEL(IP15_15_12,		SIM0_D_B,	SEL_SIMCARD_1),
 
 	PINMUX_IPSR_GPSR(IP15_19_16,		SSI_SDATA6),
 	PINMUX_IPSR_MSEL(IP15_19_16,		HRTS2_N_A,	SEL_HSCIF2_0),
@@ -4961,8 +4963,7 @@ static const struct pinmux_cfg_reg pinmux_config_regs[] = {
 			     GROUP(1, 1, 1, 1, 1, 1, 1, 3, 3, 1, 1, 1,
 				   1, 2, 2, 2, 1, 1, 2, 1, 4),
 			     GROUP(
-		/* RESERVED 31 */
-		0, 0,
+		MOD_SEL1_31
 		MOD_SEL1_30
 		MOD_SEL1_29
 		MOD_SEL1_28
-- 
2.20.1

