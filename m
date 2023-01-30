Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3AFE680F9A
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 14:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236410AbjA3NzK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 08:55:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236479AbjA3NzF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 08:55:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1C2539B96
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 05:55:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F25261011
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 13:55:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79CE0C433EF;
        Mon, 30 Jan 2023 13:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675086902;
        bh=HYtlti4cbpVN1R78Q4GFXYkbp2Zkx1HuduP2P+SWyzI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yr+4wIjBLBdwkPcMy+s12zskJWrI75nCkff45z2VtWOTU72HQGMCu860GGehsWpxc
         AbQlZvG1IuS5elr3tRp/r2HCUYE6PYMpMJ7qE/4VyuSlU/VO8mZqoHgKRII4WGIo9z
         GqsOn8mFPeCEzJy0WF3dBQY9BzZQVuzaZYWJfyQQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Lucas Stach <l.stach@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 007/313] soc: imx: imx8mp-blk-ctrl: enable global pixclk with HDMI_TX_PHY PD
Date:   Mon, 30 Jan 2023 14:47:22 +0100
Message-Id: <20230130134336.993937954@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lucas Stach <l.stach@pengutronix.de>

[ Upstream commit b814eda949c324791580003303aa608761cfde3f ]

NXP internal information shows that the PHY refclk is gated by the
GLOBAL_TX_PIX_CLK_EN bit, so to allow the PHY PLL to lock without the
LCDIF being already active, tie this bit to the HDMI_TX_PHY power
domain.

Fixes: e3442022f543 ("soc: imx: add i.MX8MP HDMI blk-ctrl")
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/imx/imx8mp-blk-ctrl.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/imx/imx8mp-blk-ctrl.c b/drivers/soc/imx/imx8mp-blk-ctrl.c
index 0e3b6ba22f94..9852714eb2a4 100644
--- a/drivers/soc/imx/imx8mp-blk-ctrl.c
+++ b/drivers/soc/imx/imx8mp-blk-ctrl.c
@@ -212,7 +212,7 @@ static void imx8mp_hdmi_blk_ctrl_power_on(struct imx8mp_blk_ctrl *bc,
 		break;
 	case IMX8MP_HDMIBLK_PD_LCDIF:
 		regmap_set_bits(bc->regmap, HDMI_RTX_CLK_CTL0,
-				BIT(7) | BIT(16) | BIT(17) | BIT(18) |
+				BIT(16) | BIT(17) | BIT(18) |
 				BIT(19) | BIT(20));
 		regmap_set_bits(bc->regmap, HDMI_RTX_CLK_CTL1, BIT(11));
 		regmap_set_bits(bc->regmap, HDMI_RTX_RESET_CTL0,
@@ -241,6 +241,7 @@ static void imx8mp_hdmi_blk_ctrl_power_on(struct imx8mp_blk_ctrl *bc,
 		regmap_set_bits(bc->regmap, HDMI_TX_CONTROL0, BIT(1));
 		break;
 	case IMX8MP_HDMIBLK_PD_HDMI_TX_PHY:
+		regmap_set_bits(bc->regmap, HDMI_RTX_CLK_CTL0, BIT(7));
 		regmap_set_bits(bc->regmap, HDMI_RTX_CLK_CTL1, BIT(22) | BIT(24));
 		regmap_set_bits(bc->regmap, HDMI_RTX_RESET_CTL0, BIT(12));
 		regmap_clear_bits(bc->regmap, HDMI_TX_CONTROL0, BIT(3));
@@ -270,7 +271,7 @@ static void imx8mp_hdmi_blk_ctrl_power_off(struct imx8mp_blk_ctrl *bc,
 				  BIT(4) | BIT(5) | BIT(6));
 		regmap_clear_bits(bc->regmap, HDMI_RTX_CLK_CTL1, BIT(11));
 		regmap_clear_bits(bc->regmap, HDMI_RTX_CLK_CTL0,
-				  BIT(7) | BIT(16) | BIT(17) | BIT(18) |
+				  BIT(16) | BIT(17) | BIT(18) |
 				  BIT(19) | BIT(20));
 		break;
 	case IMX8MP_HDMIBLK_PD_PAI:
@@ -298,6 +299,7 @@ static void imx8mp_hdmi_blk_ctrl_power_off(struct imx8mp_blk_ctrl *bc,
 	case IMX8MP_HDMIBLK_PD_HDMI_TX_PHY:
 		regmap_set_bits(bc->regmap, HDMI_TX_CONTROL0, BIT(3));
 		regmap_clear_bits(bc->regmap, HDMI_RTX_RESET_CTL0, BIT(12));
+		regmap_clear_bits(bc->regmap, HDMI_RTX_CLK_CTL0, BIT(7));
 		regmap_clear_bits(bc->regmap, HDMI_RTX_CLK_CTL1, BIT(22) | BIT(24));
 		break;
 	case IMX8MP_HDMIBLK_PD_HDCP:
-- 
2.39.0



