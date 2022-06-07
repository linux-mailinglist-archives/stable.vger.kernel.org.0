Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84ACF5412D4
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356911AbiFGTya (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:54:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358471AbiFGTwb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:52:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A531613F432;
        Tue,  7 Jun 2022 11:20:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3264060C1C;
        Tue,  7 Jun 2022 18:20:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 421E2C385A2;
        Tue,  7 Jun 2022 18:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626038;
        bh=ooAOo6qzubkyPuV+2dvA1NqN7F60QjHbnl98BMtPDlw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jTmKjTo8sUHui0BxU3vLg+H0OIyG7OPqgyyOCJOpr4n/MjGoP9KP2SWaQ4wFLXY5O
         a3FPbEKOB/3Sq4PvOEZZ7h/1MXP4zYLblbg7cng99CnLXZfygGQNNLc3Gx22amCHNj
         v0r94zG51a/m9H35/DhfRl0nRDnlC3ctmjzYRLtY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <maxime@cerno.tech>,
        Marek Vasut <marex@denx.de>,
        Jagan Teki <jagan@amarulasolutions.com>,
        Robert Foss <robert.foss@linaro.org>,
        Sam Ravnborg <sam@ravnborg.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 235/772] drm: bridge: icn6211: Fix register layout
Date:   Tue,  7 Jun 2022 18:57:07 +0200
Message-Id: <20220607164955.957449017@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit 2dcec57b3734029cc1adc5cb872f61e21609eed4 ]

The chip register layout has nothing to do with MIPI DCS, the registers
incorrectly marked as MIPI DCS in the driver are regular chip registers
often with completely different function.

Fill in the actual register names and bits from [1] and [2] and add the
entire register layout, since the documentation for this chip is hard to
come by.

[1] https://github.com/rockchip-linux/kernel/blob/develop-4.19/drivers/gpu/drm/bridge/icn6211.c
[2] https://github.com/tdjastrzebski/ICN6211-Configurator

Acked-by: Maxime Ripard <maxime@cerno.tech>
Fixes: ce517f18944e3 ("drm: bridge: Add Chipone ICN6211 MIPI-DSI to RGB bridge")
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Jagan Teki <jagan@amarulasolutions.com>
Cc: Maxime Ripard <maxime@cerno.tech>
Cc: Robert Foss <robert.foss@linaro.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
To: dri-devel@lists.freedesktop.org
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20220331150509.9838-2-marex@denx.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/chipone-icn6211.c | 134 ++++++++++++++++++++---
 1 file changed, 117 insertions(+), 17 deletions(-)

diff --git a/drivers/gpu/drm/bridge/chipone-icn6211.c b/drivers/gpu/drm/bridge/chipone-icn6211.c
index a6151db95586..eb26615b2993 100644
--- a/drivers/gpu/drm/bridge/chipone-icn6211.c
+++ b/drivers/gpu/drm/bridge/chipone-icn6211.c
@@ -14,8 +14,19 @@
 #include <linux/of_device.h>
 #include <linux/regulator/consumer.h>
 
-#include <video/mipi_display.h>
-
+#define VENDOR_ID		0x00
+#define DEVICE_ID_H		0x01
+#define DEVICE_ID_L		0x02
+#define VERSION_ID		0x03
+#define FIRMWARE_VERSION	0x08
+#define CONFIG_FINISH		0x09
+#define PD_CTRL(n)		(0x0a + ((n) & 0x3)) /* 0..3 */
+#define RST_CTRL(n)		(0x0e + ((n) & 0x1)) /* 0..1 */
+#define SYS_CTRL(n)		(0x10 + ((n) & 0x7)) /* 0..4 */
+#define RGB_DRV(n)		(0x18 + ((n) & 0x3)) /* 0..3 */
+#define RGB_DLY(n)		(0x1c + ((n) & 0x1)) /* 0..1 */
+#define RGB_TEST_CTRL		0x1e
+#define ATE_PLL_EN		0x1f
 #define HACTIVE_LI		0x20
 #define VACTIVE_LI		0x21
 #define VACTIVE_HACTIVE_HI	0x22
@@ -26,6 +37,95 @@
 #define VFP			0x27
 #define VSYNC			0x28
 #define VBP			0x29
+#define BIST_POL		0x2a
+#define BIST_POL_BIST_MODE(n)		(((n) & 0xf) << 4)
+#define BIST_POL_BIST_GEN		BIT(3)
+#define BIST_POL_HSYNC_POL		BIT(2)
+#define BIST_POL_VSYNC_POL		BIT(1)
+#define BIST_POL_DE_POL			BIT(0)
+#define BIST_RED		0x2b
+#define BIST_GREEN		0x2c
+#define BIST_BLUE		0x2d
+#define BIST_CHESS_X		0x2e
+#define BIST_CHESS_Y		0x2f
+#define BIST_CHESS_XY_H		0x30
+#define BIST_FRAME_TIME_L	0x31
+#define BIST_FRAME_TIME_H	0x32
+#define FIFO_MAX_ADDR_LOW	0x33
+#define SYNC_EVENT_DLY		0x34
+#define HSW_MIN			0x35
+#define HFP_MIN			0x36
+#define LOGIC_RST_NUM		0x37
+#define OSC_CTRL(n)		(0x48 + ((n) & 0x7)) /* 0..5 */
+#define BG_CTRL			0x4e
+#define LDO_PLL			0x4f
+#define PLL_CTRL(n)		(0x50 + ((n) & 0xf)) /* 0..15 */
+#define PLL_CTRL_6_EXTERNAL		0x90
+#define PLL_CTRL_6_MIPI_CLK		0x92
+#define PLL_CTRL_6_INTERNAL		0x93
+#define PLL_REM(n)		(0x60 + ((n) & 0x3)) /* 0..2 */
+#define PLL_DIV(n)		(0x63 + ((n) & 0x3)) /* 0..2 */
+#define PLL_FRAC(n)		(0x66 + ((n) & 0x3)) /* 0..2 */
+#define PLL_INT(n)		(0x69 + ((n) & 0x1)) /* 0..1 */
+#define PLL_REF_DIV		0x6b
+#define PLL_REF_DIV_P(n)		((n) & 0xf)
+#define PLL_REF_DIV_Pe			BIT(4)
+#define PLL_REF_DIV_S(n)		(((n) & 0x7) << 5)
+#define PLL_SSC_P(n)		(0x6c + ((n) & 0x3)) /* 0..2 */
+#define PLL_SSC_STEP(n)		(0x6f + ((n) & 0x3)) /* 0..2 */
+#define PLL_SSC_OFFSET(n)	(0x72 + ((n) & 0x3)) /* 0..3 */
+#define GPIO_OEN		0x79
+#define MIPI_CFG_PW		0x7a
+#define MIPI_CFG_PW_CONFIG_DSI		0xc1
+#define MIPI_CFG_PW_CONFIG_I2C		0x3e
+#define GPIO_SEL(n)		(0x7b + ((n) & 0x1)) /* 0..1 */
+#define IRQ_SEL			0x7d
+#define DBG_SEL			0x7e
+#define DBG_SIGNAL		0x7f
+#define MIPI_ERR_VECTOR_L	0x80
+#define MIPI_ERR_VECTOR_H	0x81
+#define MIPI_ERR_VECTOR_EN_L	0x82
+#define MIPI_ERR_VECTOR_EN_H	0x83
+#define MIPI_MAX_SIZE_L		0x84
+#define MIPI_MAX_SIZE_H		0x85
+#define DSI_CTRL		0x86
+#define DSI_CTRL_UNKNOWN		0x28
+#define DSI_CTRL_DSI_LANES(n)		((n) & 0x3)
+#define MIPI_PN_SWAP		0x87
+#define MIPI_PN_SWAP_CLK		BIT(4)
+#define MIPI_PN_SWAP_D(n)		BIT((n) & 0x3)
+#define MIPI_SOT_SYNC_BIT_(n)	(0x88 + ((n) & 0x1)) /* 0..1 */
+#define MIPI_ULPS_CTRL		0x8a
+#define MIPI_CLK_CHK_VAR	0x8e
+#define MIPI_CLK_CHK_INI	0x8f
+#define MIPI_T_TERM_EN		0x90
+#define MIPI_T_HS_SETTLE	0x91
+#define MIPI_T_TA_SURE_PRE	0x92
+#define MIPI_T_LPX_SET		0x94
+#define MIPI_T_CLK_MISS		0x95
+#define MIPI_INIT_TIME_L	0x96
+#define MIPI_INIT_TIME_H	0x97
+#define MIPI_T_CLK_TERM_EN	0x99
+#define MIPI_T_CLK_SETTLE	0x9a
+#define MIPI_TO_HS_RX_L		0x9e
+#define MIPI_TO_HS_RX_H		0x9f
+#define MIPI_PHY_(n)		(0xa0 + ((n) & 0x7)) /* 0..5 */
+#define MIPI_PD_RX		0xb0
+#define MIPI_PD_TERM		0xb1
+#define MIPI_PD_HSRX		0xb2
+#define MIPI_PD_LPTX		0xb3
+#define MIPI_PD_LPRX		0xb4
+#define MIPI_PD_CK_LANE		0xb5
+#define MIPI_FORCE_0		0xb6
+#define MIPI_RST_CTRL		0xb7
+#define MIPI_RST_NUM		0xb8
+#define MIPI_DBG_SET_(n)	(0xc0 + ((n) & 0xf)) /* 0..9 */
+#define MIPI_DBG_SEL		0xe0
+#define MIPI_DBG_DATA		0xe1
+#define MIPI_ATE_TEST_SEL	0xe2
+#define MIPI_ATE_STATUS_(n)	(0xe3 + ((n) & 0x1)) /* 0..1 */
+#define MIPI_ATE_STATUS_1	0xe4
+#define ICN6211_MAX_REGISTER	MIPI_ATE_STATUS(1)
 
 struct chipone {
 	struct device *dev;
@@ -66,13 +166,13 @@ static void chipone_enable(struct drm_bridge *bridge)
 	struct chipone *icn = bridge_to_chipone(bridge);
 	struct drm_display_mode *mode = bridge_to_mode(bridge);
 
-	ICN6211_DSI(icn, 0x7a, 0xc1);
+	ICN6211_DSI(icn, MIPI_CFG_PW, MIPI_CFG_PW_CONFIG_DSI);
 
 	ICN6211_DSI(icn, HACTIVE_LI, mode->hdisplay & 0xff);
 
 	ICN6211_DSI(icn, VACTIVE_LI, mode->vdisplay & 0xff);
 
-	/**
+	/*
 	 * lsb nibble: 2nd nibble of hdisplay
 	 * msb nibble: 2nd nibble of vdisplay
 	 */
@@ -95,21 +195,21 @@ static void chipone_enable(struct drm_bridge *bridge)
 	ICN6211_DSI(icn, VBP, mode->vtotal - mode->vsync_end);
 
 	/* dsi specific sequence */
-	ICN6211_DSI(icn, MIPI_DCS_SET_TEAR_OFF, 0x80);
-	ICN6211_DSI(icn, MIPI_DCS_SET_ADDRESS_MODE, 0x28);
-	ICN6211_DSI(icn, 0xb5, 0xa0);
-	ICN6211_DSI(icn, 0x5c, 0xff);
-	ICN6211_DSI(icn, MIPI_DCS_SET_COLUMN_ADDRESS, 0x01);
-	ICN6211_DSI(icn, MIPI_DCS_GET_POWER_SAVE, 0x92);
-	ICN6211_DSI(icn, 0x6b, 0x71);
-	ICN6211_DSI(icn, 0x69, 0x2b);
-	ICN6211_DSI(icn, MIPI_DCS_ENTER_SLEEP_MODE, 0x40);
-	ICN6211_DSI(icn, MIPI_DCS_EXIT_SLEEP_MODE, 0x98);
+	ICN6211_DSI(icn, SYNC_EVENT_DLY, 0x80);
+	ICN6211_DSI(icn, HFP_MIN, 0x28);
+	ICN6211_DSI(icn, MIPI_PD_CK_LANE, 0xa0);
+	ICN6211_DSI(icn, PLL_CTRL(12), 0xff);
+	ICN6211_DSI(icn, BIST_POL, BIST_POL_DE_POL);
+	ICN6211_DSI(icn, PLL_CTRL(6), PLL_CTRL_6_MIPI_CLK);
+	ICN6211_DSI(icn, PLL_REF_DIV, 0x71);
+	ICN6211_DSI(icn, PLL_INT(0), 0x2b);
+	ICN6211_DSI(icn, SYS_CTRL(0), 0x40);
+	ICN6211_DSI(icn, SYS_CTRL(1), 0x98);
 
 	/* icn6211 specific sequence */
-	ICN6211_DSI(icn, 0xb6, 0x20);
-	ICN6211_DSI(icn, 0x51, 0x20);
-	ICN6211_DSI(icn, 0x09, 0x10);
+	ICN6211_DSI(icn, MIPI_FORCE_0, 0x20);
+	ICN6211_DSI(icn, PLL_CTRL(1), 0x20);
+	ICN6211_DSI(icn, CONFIG_FINISH, 0x10);
 
 	usleep_range(10000, 11000);
 }
-- 
2.35.1



