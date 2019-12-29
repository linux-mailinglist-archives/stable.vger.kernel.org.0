Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E14E112C988
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:18:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731222AbfL2SJk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 13:09:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:54862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730933AbfL2Rpj (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:45:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7451F20718;
        Sun, 29 Dec 2019 17:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641537;
        bh=CINXEsn/s0PgBrigrICqTQm++L4Ttl4F7O0mQP9k+PU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dU3rj2pRY7E2zWLYtAWCAO0bPpf1WVe55/ubmIuXwg7TNRr9hw9BPMdBYTutuJYRu
         KvKvLb6DOHKjXnz9Tm3XD7UD4uBrSohFUJMaBpQtoiYovfdvta9fxTZtr7FMe0PIR2
         BFHsZImW2uLr1JmNbWcEHTcIRYzfqt1LJUXlhoRg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 068/434] Revert "pinctrl: sh-pfc: r8a77990: Fix MOD_SEL1 bit30 when using SSI_SCK2 and SSI_WS2"
Date:   Sun, 29 Dec 2019 18:22:01 +0100
Message-Id: <20191229172706.236247150@linuxfoundation.org>
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 3672bc7093434621c83299ef27ea3b3225a67600 ]

This reverts commit e87882eb9be10b2b9e28156922c2a47d877f5db4.

According to the R-Car Gen3 Hardware Manual Errata for Rev 1.00 of Aug
24, 2018, the SEL_SSI2_{0,1} definition was to be deleted.  However,
this errata merely fixed an accidental double definition in the Hardware
User's Manual Rev. 1.00.  The real definition is still present in later
revisions of the manual (Rev. 1.50 and Rev. 2.00).

Hence revert the commit to recover the definition.

Based on a patch in the BSP by Takeshi Kihara
<takeshi.kihara.df@renesas.com>.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
Link: https://lore.kernel.org/r/20190904121658.2617-3-geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/sh-pfc/pfc-r8a77990.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/pinctrl/sh-pfc/pfc-r8a77990.c b/drivers/pinctrl/sh-pfc/pfc-r8a77990.c
index 2dfb8d9cfda1..3808409cab38 100644
--- a/drivers/pinctrl/sh-pfc/pfc-r8a77990.c
+++ b/drivers/pinctrl/sh-pfc/pfc-r8a77990.c
@@ -448,6 +448,7 @@ FM(IP12_31_28)	IP12_31_28	FM(IP13_31_28)	IP13_31_28	FM(IP14_31_28)	IP14_31_28	FM
 #define MOD_SEL0_1_0	   REV4(FM(SEL_SPEED_PULSE_IF_0),	FM(SEL_SPEED_PULSE_IF_1),	FM(SEL_SPEED_PULSE_IF_2),	F_(0, 0))
 
 /* MOD_SEL1 */			/* 0 */				/* 1 */				/* 2 */				/* 3 */			/* 4 */			/* 5 */		/* 6 */		/* 7 */
+#define MOD_SEL1_30		FM(SEL_SSI2_0)			FM(SEL_SSI2_1)
 #define MOD_SEL1_29		FM(SEL_TIMER_TMU_0)		FM(SEL_TIMER_TMU_1)
 #define MOD_SEL1_28		FM(SEL_USB_20_CH0_0)		FM(SEL_USB_20_CH0_1)
 #define MOD_SEL1_26		FM(SEL_DRIF2_0)			FM(SEL_DRIF2_1)
@@ -468,7 +469,7 @@ FM(IP12_31_28)	IP12_31_28	FM(IP13_31_28)	IP13_31_28	FM(IP14_31_28)	IP14_31_28	FM
 
 #define PINMUX_MOD_SELS	\
 \
-MOD_SEL0_30_29 \
+MOD_SEL0_30_29		MOD_SEL1_30 \
 			MOD_SEL1_29 \
 MOD_SEL0_28		MOD_SEL1_28 \
 MOD_SEL0_27_26 \
@@ -1058,7 +1059,7 @@ static const u16 pinmux_data[] = {
 	PINMUX_IPSR_MSEL(IP10_27_24,		RIF0_CLK_B,	SEL_DRIF0_1),
 	PINMUX_IPSR_MSEL(IP10_27_24,		SCL2_B,		SEL_I2C2_1),
 	PINMUX_IPSR_MSEL(IP10_27_24,		TCLK1_A,	SEL_TIMER_TMU_0),
-	PINMUX_IPSR_GPSR(IP10_27_24,		SSI_SCK2_B),
+	PINMUX_IPSR_MSEL(IP10_27_24,		SSI_SCK2_B,	SEL_SSI2_1),
 	PINMUX_IPSR_GPSR(IP10_27_24,		TS_SCK0),
 
 	PINMUX_IPSR_GPSR(IP10_31_28,		SD0_WP),
@@ -1067,7 +1068,7 @@ static const u16 pinmux_data[] = {
 	PINMUX_IPSR_MSEL(IP10_31_28,		RIF0_D0_B,	SEL_DRIF0_1),
 	PINMUX_IPSR_MSEL(IP10_31_28,		SDA2_B,		SEL_I2C2_1),
 	PINMUX_IPSR_MSEL(IP10_31_28,		TCLK2_A,	SEL_TIMER_TMU_0),
-	PINMUX_IPSR_GPSR(IP10_31_28,		SSI_WS2_B),
+	PINMUX_IPSR_MSEL(IP10_31_28,		SSI_WS2_B,	SEL_SSI2_1),
 	PINMUX_IPSR_GPSR(IP10_31_28,		TS_SDAT0),
 
 	/* IPSR11 */
@@ -1085,13 +1086,13 @@ static const u16 pinmux_data[] = {
 
 	PINMUX_IPSR_MSEL(IP11_11_8,		RX0_A,		SEL_SCIF0_0),
 	PINMUX_IPSR_MSEL(IP11_11_8,		HRX1_A,		SEL_HSCIF1_0),
-	PINMUX_IPSR_GPSR(IP11_11_8,		SSI_SCK2_A),
+	PINMUX_IPSR_MSEL(IP11_11_8,		SSI_SCK2_A,	SEL_SSI2_0),
 	PINMUX_IPSR_GPSR(IP11_11_8,		RIF1_SYNC),
 	PINMUX_IPSR_GPSR(IP11_11_8,		TS_SCK1),
 
 	PINMUX_IPSR_MSEL(IP11_15_12,		TX0_A,		SEL_SCIF0_0),
 	PINMUX_IPSR_GPSR(IP11_15_12,		HTX1_A),
-	PINMUX_IPSR_GPSR(IP11_15_12,		SSI_WS2_A),
+	PINMUX_IPSR_MSEL(IP11_15_12,		SSI_WS2_A,	SEL_SSI2_0),
 	PINMUX_IPSR_GPSR(IP11_15_12,		RIF1_D0),
 	PINMUX_IPSR_GPSR(IP11_15_12,		TS_SDAT1),
 
@@ -4957,11 +4958,12 @@ static const struct pinmux_cfg_reg pinmux_config_regs[] = {
 		MOD_SEL0_1_0 ))
 	},
 	{ PINMUX_CFG_REG_VAR("MOD_SEL1", 0xe6060504, 32,
-			     GROUP(2, 1, 1, 1, 1, 1, 3, 3, 1, 1, 1, 1,
-				   2, 2, 2, 1, 1, 2, 1, 4),
+			     GROUP(1, 1, 1, 1, 1, 1, 1, 3, 3, 1, 1, 1,
+				   1, 2, 2, 2, 1, 1, 2, 1, 4),
 			     GROUP(
-		/* RESERVED 31, 30 */
-		0, 0, 0, 0,
+		/* RESERVED 31 */
+		0, 0,
+		MOD_SEL1_30
 		MOD_SEL1_29
 		MOD_SEL1_28
 		/* RESERVED 27 */
-- 
2.20.1



