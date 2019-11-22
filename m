Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C96A21063D9
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:13:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729389AbfKVGNc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 01:13:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:50740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728196AbfKVGNa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 01:13:30 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7731A20718;
        Fri, 22 Nov 2019 06:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574403210;
        bh=BqVsHACs9+7+lZeoAk6GX44pHVXMYXWdvDuAsqeR2SY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QA2zoasa9nNf0P/EP0RiV6UTaOkQ35TpiBU9z20pPXTtP9BupM3k6cge/T6RhgzVs
         ontE82pjc9El0fvOXLXoSr6iUYGQ7/yUpsF9PiMjrSrteG48h4xQzu/lZ7GteB0rkZ
         yEzJ03+IwQXu/mLNcMJV2LHi8eVG7I2Yx4HHMa4o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        Sasha Levin <sashal@kernel.org>,
        linux-renesas-soc@vger.kernel.org, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 25/68] pinctrl: sh-pfc: sh7734: Fix shifted values in IPSR10
Date:   Fri, 22 Nov 2019 01:12:18 -0500
Message-Id: <20191122061301.4947-24-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122061301.4947-1-sashal@kernel.org>
References: <20191122061301.4947-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 054f2400f706327f96770219c3065b5131f8f154 ]

Some values in the Peripheral Function Select Register 10 descriptor are
shifted by one position, which may cause a peripheral function to be
programmed incorrectly.

Fixing this makes all HSCIF0 pins use Function 4 (value 3), like was
already the case for the HSCK0 pin in field IP10[5:3].

Fixes: ac1ebc2190f575fc ("sh-pfc: Add sh7734 pinmux support")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/sh-pfc/pfc-sh7734.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/pinctrl/sh-pfc/pfc-sh7734.c b/drivers/pinctrl/sh-pfc/pfc-sh7734.c
index 9842bb1067969..c691b2e343746 100644
--- a/drivers/pinctrl/sh-pfc/pfc-sh7734.c
+++ b/drivers/pinctrl/sh-pfc/pfc-sh7734.c
@@ -2218,22 +2218,22 @@ static const struct pinmux_cfg_reg pinmux_config_regs[] = {
 	    /* IP10_22 [1] */
 		FN_CAN_CLK_A, FN_RX4_D,
 	    /* IP10_21_19 [3] */
-		FN_AUDIO_CLKOUT, FN_TX1_E, FN_HRTS0_C, FN_FSE_B,
-		FN_LCD_M_DISP_B, 0, 0, 0,
+		FN_AUDIO_CLKOUT, FN_TX1_E, 0, FN_HRTS0_C, FN_FSE_B,
+		FN_LCD_M_DISP_B, 0, 0,
 	    /* IP10_18_16 [3] */
-		FN_AUDIO_CLKC, FN_SCK1_E, FN_HCTS0_C, FN_FRB_B,
-		FN_LCD_VEPWC_B, 0, 0, 0,
+		FN_AUDIO_CLKC, FN_SCK1_E, 0, FN_HCTS0_C, FN_FRB_B,
+		FN_LCD_VEPWC_B, 0, 0,
 	    /* IP10_15 [1] */
 		FN_AUDIO_CLKB_A, FN_LCD_CLK_B,
 	    /* IP10_14_12 [3] */
 		FN_AUDIO_CLKA_A, FN_VI1_CLK_B, FN_SCK1_D, FN_IECLK_B,
 		FN_LCD_FLM_B, 0, 0, 0,
 	    /* IP10_11_9 [3] */
-		FN_SSI_SDATA3, FN_VI1_7_B, FN_HTX0_C, FN_FWE_B,
-		FN_LCD_CL2_B, 0, 0, 0,
+		FN_SSI_SDATA3, FN_VI1_7_B, 0, FN_HTX0_C, FN_FWE_B,
+		FN_LCD_CL2_B, 0, 0,
 	    /* IP10_8_6 [3] */
-		FN_SSI_SDATA2, FN_VI1_6_B, FN_HRX0_C, FN_FRE_B,
-		FN_LCD_CL1_B, 0, 0, 0,
+		FN_SSI_SDATA2, FN_VI1_6_B, 0, FN_HRX0_C, FN_FRE_B,
+		FN_LCD_CL1_B, 0, 0,
 	    /* IP10_5_3 [3] */
 		FN_SSI_WS23, FN_VI1_5_B, FN_TX1_D, FN_HSCK0_C, FN_FALE_B,
 		FN_LCD_DON_B, 0, 0, 0,
-- 
2.20.1

