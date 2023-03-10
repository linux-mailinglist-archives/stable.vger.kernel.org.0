Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A7B56B48AD
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:05:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233741AbjCJPFi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:05:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233885AbjCJPFB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:05:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41C105F500
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:58:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7541FB822F6
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:51:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C4EBC4339E;
        Fri, 10 Mar 2023 14:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459907;
        bh=CWmTx8J30bMrHJAHWVAQOE1Tf8Oow9JocXy0P/rcmQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t5ECxZs4mN0w4IITlDtvynxw6HaMgBD2lVNc6ggFeGmNGUSxZEI7QnkzB9MuY7wuW
         cC+/3jVhAWbLXFtY4uNnatiVCqOVMB2JQwZubgm1dKyMzmTniyAJoIxRHUEc1UHmUP
         KCcMZUxuT+8vbJ5xKr0HUifld0BkDevbTDbF97gI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jianqun Xu <jay.xu@rock-chips.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 160/529] pinctrl: rockchip: add support for rk3568
Date:   Fri, 10 Mar 2023 14:35:03 +0100
Message-Id: <20230310133812.368050656@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jianqun Xu <jay.xu@rock-chips.com>

[ Upstream commit c0dadc0e47a895e95c17a4df1fa12737e1d57d6f ]

RK3568 SoCs have 5 gpio controllers, each gpio has 32 pins. GPIO supports
set iomux, pull, drive strength and schmitt.

Signed-off-by: Jianqun Xu <jay.xu@rock-chips.com>
Link: https://lore.kernel.org/r/20210319081441.368358-1-jay.xu@rock-chips.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Stable-dep-of: c818ae563bf9 ("pinctrl: rockchip: Fix refcount leak in rockchip_pinctrl_parse_groups")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-rockchip.c | 292 ++++++++++++++++++++++++++++-
 1 file changed, 290 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-rockchip.c b/drivers/pinctrl/pinctrl-rockchip.c
index 07b1204174bf1..38ea70f49cb07 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -61,8 +61,17 @@ enum rockchip_pinctrl_type {
 	RK3308,
 	RK3368,
 	RK3399,
+	RK3568,
 };
 
+
+/**
+ * Generate a bitmask for setting a value (v) with a write mask bit in hiword
+ * register 31:16 area.
+ */
+#define WRITE_MASK_VAL(h, l, v) \
+	(GENMASK(((h) + 16), ((l) + 16)) | (((v) << (l)) & GENMASK((h), (l))))
+
 /*
  * Encode variants of iomux registers into a type variable
  */
@@ -290,6 +299,25 @@ struct rockchip_pin_bank {
 		.pull_type[3] = pull3,					\
 	}
 
+#define PIN_BANK_MUX_ROUTE_FLAGS(ID, PIN, FUNC, REG, VAL, FLAG)		\
+	{								\
+		.bank_num	= ID,					\
+		.pin		= PIN,					\
+		.func		= FUNC,					\
+		.route_offset	= REG,					\
+		.route_val	= VAL,					\
+		.route_location	= FLAG,					\
+	}
+
+#define RK_MUXROUTE_SAME(ID, PIN, FUNC, REG, VAL)	\
+	PIN_BANK_MUX_ROUTE_FLAGS(ID, PIN, FUNC, REG, VAL, ROCKCHIP_ROUTE_SAME)
+
+#define RK_MUXROUTE_GRF(ID, PIN, FUNC, REG, VAL)	\
+	PIN_BANK_MUX_ROUTE_FLAGS(ID, PIN, FUNC, REG, VAL, ROCKCHIP_ROUTE_GRF)
+
+#define RK_MUXROUTE_PMU(ID, PIN, FUNC, REG, VAL)	\
+	PIN_BANK_MUX_ROUTE_FLAGS(ID, PIN, FUNC, REG, VAL, ROCKCHIP_ROUTE_PMU)
+
 /**
  * struct rockchip_mux_recalced_data: represent a pin iomux data.
  * @num: bank number.
@@ -1409,6 +1437,102 @@ static struct rockchip_mux_route_data rk3399_mux_route_data[] = {
 	},
 };
 
+static struct rockchip_mux_route_data rk3568_mux_route_data[] = {
+	RK_MUXROUTE_PMU(0, RK_PB7, 1, 0x0110, WRITE_MASK_VAL(1, 0, 0)), /* PWM0 IO mux M0 */
+	RK_MUXROUTE_PMU(0, RK_PC7, 2, 0x0110, WRITE_MASK_VAL(1, 0, 1)), /* PWM0 IO mux M1 */
+	RK_MUXROUTE_PMU(0, RK_PC0, 1, 0x0110, WRITE_MASK_VAL(3, 2, 0)), /* PWM1 IO mux M0 */
+	RK_MUXROUTE_PMU(0, RK_PB5, 4, 0x0110, WRITE_MASK_VAL(3, 2, 1)), /* PWM1 IO mux M1 */
+	RK_MUXROUTE_PMU(0, RK_PC1, 1, 0x0110, WRITE_MASK_VAL(5, 4, 0)), /* PWM2 IO mux M0 */
+	RK_MUXROUTE_PMU(0, RK_PB6, 4, 0x0110, WRITE_MASK_VAL(5, 4, 1)), /* PWM2 IO mux M1 */
+	RK_MUXROUTE_PMU(0, RK_PB3, 2, 0x0300, WRITE_MASK_VAL(0, 0, 0)), /* CAN0 IO mux M0 */
+	RK_MUXROUTE_GRF(2, RK_PA1, 4, 0x0300, WRITE_MASK_VAL(0, 0, 1)), /* CAN0 IO mux M1 */
+	RK_MUXROUTE_GRF(1, RK_PA1, 3, 0x0300, WRITE_MASK_VAL(2, 2, 0)), /* CAN1 IO mux M0 */
+	RK_MUXROUTE_GRF(4, RK_PC3, 3, 0x0300, WRITE_MASK_VAL(2, 2, 1)), /* CAN1 IO mux M1 */
+	RK_MUXROUTE_GRF(4, RK_PB5, 3, 0x0300, WRITE_MASK_VAL(4, 4, 0)), /* CAN2 IO mux M0 */
+	RK_MUXROUTE_GRF(2, RK_PB2, 4, 0x0300, WRITE_MASK_VAL(4, 4, 1)), /* CAN2 IO mux M1 */
+	RK_MUXROUTE_GRF(4, RK_PC4, 1, 0x0300, WRITE_MASK_VAL(6, 6, 0)), /* HPDIN IO mux M0 */
+	RK_MUXROUTE_PMU(0, RK_PC2, 2, 0x0300, WRITE_MASK_VAL(6, 6, 1)), /* HPDIN IO mux M1 */
+	RK_MUXROUTE_GRF(3, RK_PB1, 3, 0x0300, WRITE_MASK_VAL(8, 8, 0)), /* GMAC1 IO mux M0 */
+	RK_MUXROUTE_GRF(4, RK_PA7, 3, 0x0300, WRITE_MASK_VAL(8, 8, 1)), /* GMAC1 IO mux M1 */
+	RK_MUXROUTE_GRF(4, RK_PD1, 1, 0x0300, WRITE_MASK_VAL(10, 10, 0)), /* HDMITX IO mux M0 */
+	RK_MUXROUTE_PMU(0, RK_PC7, 1, 0x0300, WRITE_MASK_VAL(10, 10, 1)), /* HDMITX IO mux M1 */
+	RK_MUXROUTE_PMU(0, RK_PB6, 1, 0x0300, WRITE_MASK_VAL(14, 14, 0)), /* I2C2 IO mux M0 */
+	RK_MUXROUTE_GRF(4, RK_PB4, 1, 0x0300, WRITE_MASK_VAL(14, 14, 1)), /* I2C2 IO mux M1 */
+	RK_MUXROUTE_GRF(1, RK_PA0, 1, 0x0304, WRITE_MASK_VAL(0, 0, 0)), /* I2C3 IO mux M0 */
+	RK_MUXROUTE_GRF(3, RK_PB6, 4, 0x0304, WRITE_MASK_VAL(0, 0, 1)), /* I2C3 IO mux M1 */
+	RK_MUXROUTE_GRF(4, RK_PB2, 1, 0x0304, WRITE_MASK_VAL(2, 2, 0)), /* I2C4 IO mux M0 */
+	RK_MUXROUTE_GRF(2, RK_PB1, 2, 0x0304, WRITE_MASK_VAL(2, 2, 1)), /* I2C4 IO mux M1 */
+	RK_MUXROUTE_GRF(3, RK_PB4, 4, 0x0304, WRITE_MASK_VAL(4, 4, 0)), /* I2C5 IO mux M0 */
+	RK_MUXROUTE_GRF(4, RK_PD0, 2, 0x0304, WRITE_MASK_VAL(4, 4, 1)), /* I2C5 IO mux M1 */
+	RK_MUXROUTE_GRF(3, RK_PB1, 5, 0x0304, WRITE_MASK_VAL(14, 14, 0)), /* PWM8 IO mux M0 */
+	RK_MUXROUTE_GRF(1, RK_PD5, 4, 0x0304, WRITE_MASK_VAL(14, 14, 1)), /* PWM8 IO mux M1 */
+	RK_MUXROUTE_GRF(3, RK_PB2, 5, 0x0308, WRITE_MASK_VAL(0, 0, 0)), /* PWM9 IO mux M0 */
+	RK_MUXROUTE_GRF(1, RK_PD6, 4, 0x0308, WRITE_MASK_VAL(0, 0, 1)), /* PWM9 IO mux M1 */
+	RK_MUXROUTE_GRF(3, RK_PB5, 5, 0x0308, WRITE_MASK_VAL(2, 2, 0)), /* PWM10 IO mux M0 */
+	RK_MUXROUTE_GRF(2, RK_PA1, 2, 0x0308, WRITE_MASK_VAL(2, 2, 1)), /* PWM10 IO mux M1 */
+	RK_MUXROUTE_GRF(3, RK_PB6, 5, 0x0308, WRITE_MASK_VAL(4, 4, 0)), /* PWM11 IO mux M0 */
+	RK_MUXROUTE_GRF(4, RK_PC0, 3, 0x0308, WRITE_MASK_VAL(4, 4, 1)), /* PWM11 IO mux M1 */
+	RK_MUXROUTE_GRF(3, RK_PB7, 2, 0x0308, WRITE_MASK_VAL(6, 6, 0)), /* PWM12 IO mux M0 */
+	RK_MUXROUTE_GRF(4, RK_PC5, 1, 0x0308, WRITE_MASK_VAL(6, 6, 1)), /* PWM12 IO mux M1 */
+	RK_MUXROUTE_GRF(3, RK_PC0, 2, 0x0308, WRITE_MASK_VAL(8, 8, 0)), /* PWM13 IO mux M0 */
+	RK_MUXROUTE_GRF(4, RK_PC6, 1, 0x0308, WRITE_MASK_VAL(8, 8, 1)), /* PWM13 IO mux M1 */
+	RK_MUXROUTE_GRF(3, RK_PC4, 1, 0x0308, WRITE_MASK_VAL(10, 10, 0)), /* PWM14 IO mux M0 */
+	RK_MUXROUTE_GRF(4, RK_PC2, 1, 0x0308, WRITE_MASK_VAL(10, 10, 1)), /* PWM14 IO mux M1 */
+	RK_MUXROUTE_GRF(3, RK_PC5, 1, 0x0308, WRITE_MASK_VAL(12, 12, 0)), /* PWM15 IO mux M0 */
+	RK_MUXROUTE_GRF(4, RK_PC3, 1, 0x0308, WRITE_MASK_VAL(12, 12, 1)), /* PWM15 IO mux M1 */
+	RK_MUXROUTE_GRF(3, RK_PD2, 3, 0x0308, WRITE_MASK_VAL(14, 14, 0)), /* SDMMC2 IO mux M0 */
+	RK_MUXROUTE_GRF(3, RK_PA5, 5, 0x0308, WRITE_MASK_VAL(14, 14, 1)), /* SDMMC2 IO mux M1 */
+	RK_MUXROUTE_PMU(0, RK_PB5, 2, 0x030c, WRITE_MASK_VAL(0, 0, 0)), /* SPI0 IO mux M0 */
+	RK_MUXROUTE_GRF(2, RK_PD3, 3, 0x030c, WRITE_MASK_VAL(0, 0, 1)), /* SPI0 IO mux M1 */
+	RK_MUXROUTE_GRF(2, RK_PB5, 3, 0x030c, WRITE_MASK_VAL(2, 2, 0)), /* SPI1 IO mux M0 */
+	RK_MUXROUTE_GRF(3, RK_PC3, 3, 0x030c, WRITE_MASK_VAL(2, 2, 1)), /* SPI1 IO mux M1 */
+	RK_MUXROUTE_GRF(2, RK_PC1, 4, 0x030c, WRITE_MASK_VAL(4, 4, 0)), /* SPI2 IO mux M0 */
+	RK_MUXROUTE_GRF(3, RK_PA0, 3, 0x030c, WRITE_MASK_VAL(4, 4, 1)), /* SPI2 IO mux M1 */
+	RK_MUXROUTE_GRF(4, RK_PB3, 4, 0x030c, WRITE_MASK_VAL(6, 6, 0)), /* SPI3 IO mux M0 */
+	RK_MUXROUTE_GRF(4, RK_PC2, 2, 0x030c, WRITE_MASK_VAL(6, 6, 1)), /* SPI3 IO mux M1 */
+	RK_MUXROUTE_GRF(2, RK_PB4, 2, 0x030c, WRITE_MASK_VAL(8, 8, 0)), /* UART1 IO mux M0 */
+	RK_MUXROUTE_PMU(0, RK_PD1, 1, 0x030c, WRITE_MASK_VAL(8, 8, 1)), /* UART1 IO mux M1 */
+	RK_MUXROUTE_PMU(0, RK_PD1, 1, 0x030c, WRITE_MASK_VAL(10, 10, 0)), /* UART2 IO mux M0 */
+	RK_MUXROUTE_GRF(1, RK_PD5, 2, 0x030c, WRITE_MASK_VAL(10, 10, 1)), /* UART2 IO mux M1 */
+	RK_MUXROUTE_GRF(1, RK_PA1, 2, 0x030c, WRITE_MASK_VAL(12, 12, 0)), /* UART3 IO mux M0 */
+	RK_MUXROUTE_GRF(3, RK_PB7, 4, 0x030c, WRITE_MASK_VAL(12, 12, 1)), /* UART3 IO mux M1 */
+	RK_MUXROUTE_GRF(1, RK_PA6, 2, 0x030c, WRITE_MASK_VAL(14, 14, 0)), /* UART4 IO mux M0 */
+	RK_MUXROUTE_GRF(3, RK_PB2, 4, 0x030c, WRITE_MASK_VAL(14, 14, 1)), /* UART4 IO mux M1 */
+	RK_MUXROUTE_GRF(2, RK_PA2, 3, 0x0310, WRITE_MASK_VAL(0, 0, 0)), /* UART5 IO mux M0 */
+	RK_MUXROUTE_GRF(3, RK_PC2, 4, 0x0310, WRITE_MASK_VAL(0, 0, 1)), /* UART5 IO mux M1 */
+	RK_MUXROUTE_GRF(2, RK_PA4, 3, 0x0310, WRITE_MASK_VAL(2, 2, 0)), /* UART6 IO mux M0 */
+	RK_MUXROUTE_GRF(1, RK_PD5, 3, 0x0310, WRITE_MASK_VAL(2, 2, 1)), /* UART6 IO mux M1 */
+	RK_MUXROUTE_GRF(2, RK_PA6, 3, 0x0310, WRITE_MASK_VAL(5, 4, 0)), /* UART7 IO mux M0 */
+	RK_MUXROUTE_GRF(3, RK_PC4, 4, 0x0310, WRITE_MASK_VAL(5, 4, 1)), /* UART7 IO mux M1 */
+	RK_MUXROUTE_GRF(4, RK_PA2, 4, 0x0310, WRITE_MASK_VAL(5, 4, 2)), /* UART7 IO mux M2 */
+	RK_MUXROUTE_GRF(2, RK_PC5, 3, 0x0310, WRITE_MASK_VAL(6, 6, 0)), /* UART8 IO mux M0 */
+	RK_MUXROUTE_GRF(2, RK_PD7, 4, 0x0310, WRITE_MASK_VAL(6, 6, 1)), /* UART8 IO mux M1 */
+	RK_MUXROUTE_GRF(2, RK_PB0, 3, 0x0310, WRITE_MASK_VAL(9, 8, 0)), /* UART9 IO mux M0 */
+	RK_MUXROUTE_GRF(4, RK_PC5, 4, 0x0310, WRITE_MASK_VAL(9, 8, 1)), /* UART9 IO mux M1 */
+	RK_MUXROUTE_GRF(4, RK_PA4, 4, 0x0310, WRITE_MASK_VAL(9, 8, 2)), /* UART9 IO mux M2 */
+	RK_MUXROUTE_GRF(1, RK_PA2, 1, 0x0310, WRITE_MASK_VAL(11, 10, 0)), /* I2S1 IO mux M0 */
+	RK_MUXROUTE_GRF(3, RK_PC6, 4, 0x0310, WRITE_MASK_VAL(11, 10, 1)), /* I2S1 IO mux M1 */
+	RK_MUXROUTE_GRF(2, RK_PD0, 5, 0x0310, WRITE_MASK_VAL(11, 10, 2)), /* I2S1 IO mux M2 */
+	RK_MUXROUTE_GRF(2, RK_PC1, 1, 0x0310, WRITE_MASK_VAL(12, 12, 0)), /* I2S2 IO mux M0 */
+	RK_MUXROUTE_GRF(4, RK_PB6, 5, 0x0310, WRITE_MASK_VAL(12, 12, 1)), /* I2S2 IO mux M1 */
+	RK_MUXROUTE_GRF(3, RK_PA2, 4, 0x0310, WRITE_MASK_VAL(14, 14, 0)), /* I2S3 IO mux M0 */
+	RK_MUXROUTE_GRF(4, RK_PC2, 5, 0x0310, WRITE_MASK_VAL(14, 14, 1)), /* I2S3 IO mux M1 */
+	RK_MUXROUTE_GRF(1, RK_PA4, 3, 0x0314, WRITE_MASK_VAL(1, 0, 0)), /* PDM IO mux M0 */
+	RK_MUXROUTE_GRF(1, RK_PA6, 3, 0x0314, WRITE_MASK_VAL(1, 0, 0)), /* PDM IO mux M0 */
+	RK_MUXROUTE_GRF(3, RK_PD6, 5, 0x0314, WRITE_MASK_VAL(1, 0, 1)), /* PDM IO mux M1 */
+	RK_MUXROUTE_GRF(4, RK_PA0, 4, 0x0314, WRITE_MASK_VAL(1, 0, 1)), /* PDM IO mux M1 */
+	RK_MUXROUTE_GRF(3, RK_PC4, 5, 0x0314, WRITE_MASK_VAL(1, 0, 2)), /* PDM IO mux M2 */
+	RK_MUXROUTE_PMU(0, RK_PA5, 3, 0x0314, WRITE_MASK_VAL(3, 2, 0)), /* PCIE20 IO mux M0 */
+	RK_MUXROUTE_GRF(2, RK_PD0, 4, 0x0314, WRITE_MASK_VAL(3, 2, 1)), /* PCIE20 IO mux M1 */
+	RK_MUXROUTE_GRF(1, RK_PB0, 4, 0x0314, WRITE_MASK_VAL(3, 2, 2)), /* PCIE20 IO mux M2 */
+	RK_MUXROUTE_PMU(0, RK_PA4, 3, 0x0314, WRITE_MASK_VAL(5, 4, 0)), /* PCIE30X1 IO mux M0 */
+	RK_MUXROUTE_GRF(2, RK_PD2, 4, 0x0314, WRITE_MASK_VAL(5, 4, 1)), /* PCIE30X1 IO mux M1 */
+	RK_MUXROUTE_GRF(1, RK_PA5, 4, 0x0314, WRITE_MASK_VAL(5, 4, 2)), /* PCIE30X1 IO mux M2 */
+	RK_MUXROUTE_PMU(0, RK_PA6, 2, 0x0314, WRITE_MASK_VAL(7, 6, 0)), /* PCIE30X2 IO mux M0 */
+	RK_MUXROUTE_GRF(2, RK_PD4, 4, 0x0314, WRITE_MASK_VAL(7, 6, 1)), /* PCIE30X2 IO mux M1 */
+	RK_MUXROUTE_GRF(4, RK_PC2, 4, 0x0314, WRITE_MASK_VAL(7, 6, 2)), /* PCIE30X2 IO mux M2 */
+};
+
 static bool rockchip_get_mux_route(struct rockchip_pin_bank *bank, int pin,
 				   int mux, u32 *loc, u32 *reg, u32 *value)
 {
@@ -2117,6 +2241,68 @@ static void rk3399_calc_drv_reg_and_bit(struct rockchip_pin_bank *bank,
 		*bit = (pin_num % 8) * 2;
 }
 
+#define RK3568_PULL_PMU_OFFSET		0x20
+#define RK3568_PULL_GRF_OFFSET		0x80
+#define RK3568_PULL_BITS_PER_PIN	2
+#define RK3568_PULL_PINS_PER_REG	8
+#define RK3568_PULL_BANK_STRIDE		0x10
+
+static void rk3568_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
+					 int pin_num, struct regmap **regmap,
+					 int *reg, u8 *bit)
+{
+	struct rockchip_pinctrl *info = bank->drvdata;
+
+	if (bank->bank_num == 0) {
+		*regmap = info->regmap_pmu;
+		*reg = RK3568_PULL_PMU_OFFSET;
+		*reg += bank->bank_num * RK3568_PULL_BANK_STRIDE;
+		*reg += ((pin_num / RK3568_PULL_PINS_PER_REG) * 4);
+
+		*bit = pin_num % RK3568_PULL_PINS_PER_REG;
+		*bit *= RK3568_PULL_BITS_PER_PIN;
+	} else {
+		*regmap = info->regmap_base;
+		*reg = RK3568_PULL_GRF_OFFSET;
+		*reg += (bank->bank_num - 1) * RK3568_PULL_BANK_STRIDE;
+		*reg += ((pin_num / RK3568_PULL_PINS_PER_REG) * 4);
+
+		*bit = (pin_num % RK3568_PULL_PINS_PER_REG);
+		*bit *= RK3568_PULL_BITS_PER_PIN;
+	}
+}
+
+#define RK3568_DRV_PMU_OFFSET		0x70
+#define RK3568_DRV_GRF_OFFSET		0x200
+#define RK3568_DRV_BITS_PER_PIN		8
+#define RK3568_DRV_PINS_PER_REG		2
+#define RK3568_DRV_BANK_STRIDE		0x40
+
+static void rk3568_calc_drv_reg_and_bit(struct rockchip_pin_bank *bank,
+					int pin_num, struct regmap **regmap,
+					int *reg, u8 *bit)
+{
+	struct rockchip_pinctrl *info = bank->drvdata;
+
+	/* The first 32 pins of the first bank are located in PMU */
+	if (bank->bank_num == 0) {
+		*regmap = info->regmap_pmu;
+		*reg = RK3568_DRV_PMU_OFFSET;
+		*reg += ((pin_num / RK3568_DRV_PINS_PER_REG) * 4);
+
+		*bit = pin_num % RK3568_DRV_PINS_PER_REG;
+		*bit *= RK3568_DRV_BITS_PER_PIN;
+	} else {
+		*regmap = info->regmap_base;
+		*reg = RK3568_DRV_GRF_OFFSET;
+		*reg += (bank->bank_num - 1) * RK3568_DRV_BANK_STRIDE;
+		*reg += ((pin_num / RK3568_DRV_PINS_PER_REG) * 4);
+
+		*bit = (pin_num % RK3568_DRV_PINS_PER_REG);
+		*bit *= RK3568_DRV_BITS_PER_PIN;
+	}
+}
+
 static int rockchip_perpin_drv_list[DRV_TYPE_MAX][8] = {
 	{ 2, 4, 8, 12, -1, -1, -1, -1 },
 	{ 3, 6, 9, 12, -1, -1, -1, -1 },
@@ -2217,6 +2403,11 @@ static int rockchip_set_drive_perpin(struct rockchip_pin_bank *bank,
 		bank->bank_num, pin_num, strength);
 
 	ctrl->drv_calc_reg(bank, pin_num, &regmap, &reg, &bit);
+	if (ctrl->type == RK3568) {
+		rmask_bits = RK3568_DRV_BITS_PER_PIN;
+		ret = (1 << (strength + 1)) - 1;
+		goto config;
+	}
 
 	ret = -EINVAL;
 	for (i = 0; i < ARRAY_SIZE(rockchip_perpin_drv_list[drv_type]); i++) {
@@ -2286,6 +2477,7 @@ static int rockchip_set_drive_perpin(struct rockchip_pin_bank *bank,
 		return -EINVAL;
 	}
 
+config:
 	/* enable the write to the equivalent lower bits */
 	data = ((1 << rmask_bits) - 1) << (bit + 16);
 	rmask = data | (data >> 16);
@@ -2388,6 +2580,7 @@ static int rockchip_set_pull(struct rockchip_pin_bank *bank,
 	case RK3308:
 	case RK3368:
 	case RK3399:
+	case RK3568:
 		pull_type = bank->pull_type[pin_num / 8];
 		ret = -EINVAL;
 		for (i = 0; i < ARRAY_SIZE(rockchip_pull_list[pull_type]);
@@ -2397,6 +2590,14 @@ static int rockchip_set_pull(struct rockchip_pin_bank *bank,
 				break;
 			}
 		}
+		/*
+		 * In the TRM, pull-up being 1 for everything except the GPIO0_D0-D6,
+		 * where that pull up value becomes 3.
+		 */
+		if (ctrl->type == RK3568 && bank->bank_num == 0 && pin_num >= 27 && pin_num <= 30) {
+			if (ret == 1)
+				ret = 3;
+		}
 
 		if (ret < 0) {
 			dev_err(info->dev, "unsupported pull setting %d\n",
@@ -2441,6 +2642,35 @@ static int rk3328_calc_schmitt_reg_and_bit(struct rockchip_pin_bank *bank,
 	return 0;
 }
 
+#define RK3568_SCHMITT_BITS_PER_PIN		2
+#define RK3568_SCHMITT_PINS_PER_REG		8
+#define RK3568_SCHMITT_BANK_STRIDE		0x10
+#define RK3568_SCHMITT_GRF_OFFSET		0xc0
+#define RK3568_SCHMITT_PMUGRF_OFFSET		0x30
+
+static int rk3568_calc_schmitt_reg_and_bit(struct rockchip_pin_bank *bank,
+					   int pin_num,
+					   struct regmap **regmap,
+					   int *reg, u8 *bit)
+{
+	struct rockchip_pinctrl *info = bank->drvdata;
+
+	if (bank->bank_num == 0) {
+		*regmap = info->regmap_pmu;
+		*reg = RK3568_SCHMITT_PMUGRF_OFFSET;
+	} else {
+		*regmap = info->regmap_base;
+		*reg = RK3568_SCHMITT_GRF_OFFSET;
+		*reg += (bank->bank_num - 1) * RK3568_SCHMITT_BANK_STRIDE;
+	}
+
+	*reg += ((pin_num / RK3568_SCHMITT_PINS_PER_REG) * 4);
+	*bit = pin_num % RK3568_SCHMITT_PINS_PER_REG;
+	*bit *= RK3568_SCHMITT_BITS_PER_PIN;
+
+	return 0;
+}
+
 static int rockchip_get_schmitt(struct rockchip_pin_bank *bank, int pin_num)
 {
 	struct rockchip_pinctrl *info = bank->drvdata;
@@ -2459,6 +2689,13 @@ static int rockchip_get_schmitt(struct rockchip_pin_bank *bank, int pin_num)
 		return ret;
 
 	data >>= bit;
+	switch (ctrl->type) {
+	case RK3568:
+		return data & ((1 << RK3568_SCHMITT_BITS_PER_PIN) - 1);
+	default:
+		break;
+	}
+
 	return data & 0x1;
 }
 
@@ -2480,8 +2717,17 @@ static int rockchip_set_schmitt(struct rockchip_pin_bank *bank,
 		return ret;
 
 	/* enable the write to the equivalent lower bits */
-	data = BIT(bit + 16) | (enable << bit);
-	rmask = BIT(bit + 16) | BIT(bit);
+	switch (ctrl->type) {
+	case RK3568:
+		data = ((1 << RK3568_SCHMITT_BITS_PER_PIN) - 1) << (bit + 16);
+		rmask = data | (data >> 16);
+		data |= ((enable ? 0x2 : 0x1) << bit);
+		break;
+	default:
+		data = BIT(bit + 16) | (enable << bit);
+		rmask = BIT(bit + 16) | BIT(bit);
+		break;
+	}
 
 	return regmap_update_bits(regmap, reg, rmask, data);
 }
@@ -2655,6 +2901,7 @@ static bool rockchip_pinconf_pull_valid(struct rockchip_pin_ctrl *ctrl,
 	case RK3308:
 	case RK3368:
 	case RK3399:
+	case RK3568:
 		return (pull != PIN_CONFIG_BIAS_PULL_PIN_DEFAULT);
 	}
 
@@ -4230,6 +4477,45 @@ static struct rockchip_pin_ctrl rk3399_pin_ctrl = {
 		.drv_calc_reg		= rk3399_calc_drv_reg_and_bit,
 };
 
+static struct rockchip_pin_bank rk3568_pin_banks[] = {
+	PIN_BANK_IOMUX_FLAGS(0, 32, "gpio0", IOMUX_SOURCE_PMU | IOMUX_WIDTH_4BIT,
+					     IOMUX_SOURCE_PMU | IOMUX_WIDTH_4BIT,
+					     IOMUX_SOURCE_PMU | IOMUX_WIDTH_4BIT,
+					     IOMUX_SOURCE_PMU | IOMUX_WIDTH_4BIT),
+	PIN_BANK_IOMUX_FLAGS(1, 32, "gpio1", IOMUX_WIDTH_4BIT,
+					     IOMUX_WIDTH_4BIT,
+					     IOMUX_WIDTH_4BIT,
+					     IOMUX_WIDTH_4BIT),
+	PIN_BANK_IOMUX_FLAGS(2, 32, "gpio2", IOMUX_WIDTH_4BIT,
+					     IOMUX_WIDTH_4BIT,
+					     IOMUX_WIDTH_4BIT,
+					     IOMUX_WIDTH_4BIT),
+	PIN_BANK_IOMUX_FLAGS(3, 32, "gpio3", IOMUX_WIDTH_4BIT,
+					     IOMUX_WIDTH_4BIT,
+					     IOMUX_WIDTH_4BIT,
+					     IOMUX_WIDTH_4BIT),
+	PIN_BANK_IOMUX_FLAGS(4, 32, "gpio4", IOMUX_WIDTH_4BIT,
+					     IOMUX_WIDTH_4BIT,
+					     IOMUX_WIDTH_4BIT,
+					     IOMUX_WIDTH_4BIT),
+};
+
+static struct rockchip_pin_ctrl rk3568_pin_ctrl = {
+	.pin_banks		= rk3568_pin_banks,
+	.nr_banks		= ARRAY_SIZE(rk3568_pin_banks),
+	.label			= "RK3568-GPIO",
+	.type			= RK3568,
+	.grf_mux_offset		= 0x0,
+	.pmu_mux_offset		= 0x0,
+	.grf_drv_offset		= 0x0200,
+	.pmu_drv_offset		= 0x0070,
+	.iomux_routes		= rk3568_mux_route_data,
+	.niomux_routes		= ARRAY_SIZE(rk3568_mux_route_data),
+	.pull_calc_reg		= rk3568_calc_pull_reg_and_bit,
+	.drv_calc_reg		= rk3568_calc_drv_reg_and_bit,
+	.schmitt_calc_reg	= rk3568_calc_schmitt_reg_and_bit,
+};
+
 static const struct of_device_id rockchip_pinctrl_dt_match[] = {
 	{ .compatible = "rockchip,px30-pinctrl",
 		.data = &px30_pin_ctrl },
@@ -4259,6 +4545,8 @@ static const struct of_device_id rockchip_pinctrl_dt_match[] = {
 		.data = &rk3368_pin_ctrl },
 	{ .compatible = "rockchip,rk3399-pinctrl",
 		.data = &rk3399_pin_ctrl },
+	{ .compatible = "rockchip,rk3568-pinctrl",
+		.data = &rk3568_pin_ctrl },
 	{},
 };
 
-- 
2.39.2



