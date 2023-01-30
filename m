Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35D1668115B
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:12:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237250AbjA3OMf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:12:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237246AbjA3OMe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:12:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAF213BD92
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:12:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6DA4161022
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:12:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8045EC433D2;
        Mon, 30 Jan 2023 14:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087941;
        bh=fG1+aZn1NsV1iwzPT9lR7ru+1SpUbImCA2F6fUU2RlQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SmAOORYDKKNKX4mnSGwnYzI7SANIBvoFBHONVVzmxuNWH4rbSvbqahdfgMKeePLBR
         +xcG8CPPX5W8tMfJ8klmF3VVzWNrUDgkFEJVMzr+y8rF2yCdlRcZ+6s++l6DGpp3nP
         3UK5VRQw07r/QLgE8LHt3cYS4669qcDDdV57KGZM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jonas Karlman <jonas@kwiboo.se>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 061/204] pinctrl: rockchip: fix mux route data for rk3568
Date:   Mon, 30 Jan 2023 14:50:26 +0100
Message-Id: <20230130134318.991294792@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75 autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonas Karlman <jonas@kwiboo.se>

[ Upstream commit 431d1531466033909d2e8c754a7dc3704b70843f ]

IO mux selection is configured in PMU_GRF_SOC_CON4 and GRF_IOFUNC_SEL0-5
regs on RK3568. pwm0-2 is configured in PMU_GRF reg and the rest is
configured in GRF_IOFUNC regs according to TRM [1].

Update mux route data to reflect this and use proper detection pin for
UART1 IO mux M1.

This fixes HDMITX IO mux M1 selection and makes it possible to enable
HDMI CEC on my Radxa ROCK 3 Model A v1.31 board.

[1] http://opensource.rock-chips.com/images/2/26/Rockchip_RK3568_TRM_Part1_V1.3-20220930P.PDF

Fixes: c0dadc0e47a8 ("pinctrl: rockchip: add support for rk3568")
Signed-off-by: Jonas Karlman <jonas@kwiboo.se>
Link: https://lore.kernel.org/r/20230110084636.1141740-1-jonas@kwiboo.se
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-rockchip.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-rockchip.c b/drivers/pinctrl/pinctrl-rockchip.c
index 0ca830fcf371..c33cbf7568db 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -758,19 +758,19 @@ static struct rockchip_mux_route_data rk3568_mux_route_data[] = {
 	RK_MUXROUTE_PMU(0, RK_PB5, 4, 0x0110, WRITE_MASK_VAL(3, 2, 1)), /* PWM1 IO mux M1 */
 	RK_MUXROUTE_PMU(0, RK_PC1, 1, 0x0110, WRITE_MASK_VAL(5, 4, 0)), /* PWM2 IO mux M0 */
 	RK_MUXROUTE_PMU(0, RK_PB6, 4, 0x0110, WRITE_MASK_VAL(5, 4, 1)), /* PWM2 IO mux M1 */
-	RK_MUXROUTE_PMU(0, RK_PB3, 2, 0x0300, WRITE_MASK_VAL(0, 0, 0)), /* CAN0 IO mux M0 */
+	RK_MUXROUTE_GRF(0, RK_PB3, 2, 0x0300, WRITE_MASK_VAL(0, 0, 0)), /* CAN0 IO mux M0 */
 	RK_MUXROUTE_GRF(2, RK_PA1, 4, 0x0300, WRITE_MASK_VAL(0, 0, 1)), /* CAN0 IO mux M1 */
 	RK_MUXROUTE_GRF(1, RK_PA1, 3, 0x0300, WRITE_MASK_VAL(2, 2, 0)), /* CAN1 IO mux M0 */
 	RK_MUXROUTE_GRF(4, RK_PC3, 3, 0x0300, WRITE_MASK_VAL(2, 2, 1)), /* CAN1 IO mux M1 */
 	RK_MUXROUTE_GRF(4, RK_PB5, 3, 0x0300, WRITE_MASK_VAL(4, 4, 0)), /* CAN2 IO mux M0 */
 	RK_MUXROUTE_GRF(2, RK_PB2, 4, 0x0300, WRITE_MASK_VAL(4, 4, 1)), /* CAN2 IO mux M1 */
 	RK_MUXROUTE_GRF(4, RK_PC4, 1, 0x0300, WRITE_MASK_VAL(6, 6, 0)), /* HPDIN IO mux M0 */
-	RK_MUXROUTE_PMU(0, RK_PC2, 2, 0x0300, WRITE_MASK_VAL(6, 6, 1)), /* HPDIN IO mux M1 */
+	RK_MUXROUTE_GRF(0, RK_PC2, 2, 0x0300, WRITE_MASK_VAL(6, 6, 1)), /* HPDIN IO mux M1 */
 	RK_MUXROUTE_GRF(3, RK_PB1, 3, 0x0300, WRITE_MASK_VAL(8, 8, 0)), /* GMAC1 IO mux M0 */
 	RK_MUXROUTE_GRF(4, RK_PA7, 3, 0x0300, WRITE_MASK_VAL(8, 8, 1)), /* GMAC1 IO mux M1 */
 	RK_MUXROUTE_GRF(4, RK_PD1, 1, 0x0300, WRITE_MASK_VAL(10, 10, 0)), /* HDMITX IO mux M0 */
-	RK_MUXROUTE_PMU(0, RK_PC7, 1, 0x0300, WRITE_MASK_VAL(10, 10, 1)), /* HDMITX IO mux M1 */
-	RK_MUXROUTE_PMU(0, RK_PB6, 1, 0x0300, WRITE_MASK_VAL(14, 14, 0)), /* I2C2 IO mux M0 */
+	RK_MUXROUTE_GRF(0, RK_PC7, 1, 0x0300, WRITE_MASK_VAL(10, 10, 1)), /* HDMITX IO mux M1 */
+	RK_MUXROUTE_GRF(0, RK_PB6, 1, 0x0300, WRITE_MASK_VAL(14, 14, 0)), /* I2C2 IO mux M0 */
 	RK_MUXROUTE_GRF(4, RK_PB4, 1, 0x0300, WRITE_MASK_VAL(14, 14, 1)), /* I2C2 IO mux M1 */
 	RK_MUXROUTE_GRF(1, RK_PA0, 1, 0x0304, WRITE_MASK_VAL(0, 0, 0)), /* I2C3 IO mux M0 */
 	RK_MUXROUTE_GRF(3, RK_PB6, 4, 0x0304, WRITE_MASK_VAL(0, 0, 1)), /* I2C3 IO mux M1 */
@@ -796,7 +796,7 @@ static struct rockchip_mux_route_data rk3568_mux_route_data[] = {
 	RK_MUXROUTE_GRF(4, RK_PC3, 1, 0x0308, WRITE_MASK_VAL(12, 12, 1)), /* PWM15 IO mux M1 */
 	RK_MUXROUTE_GRF(3, RK_PD2, 3, 0x0308, WRITE_MASK_VAL(14, 14, 0)), /* SDMMC2 IO mux M0 */
 	RK_MUXROUTE_GRF(3, RK_PA5, 5, 0x0308, WRITE_MASK_VAL(14, 14, 1)), /* SDMMC2 IO mux M1 */
-	RK_MUXROUTE_PMU(0, RK_PB5, 2, 0x030c, WRITE_MASK_VAL(0, 0, 0)), /* SPI0 IO mux M0 */
+	RK_MUXROUTE_GRF(0, RK_PB5, 2, 0x030c, WRITE_MASK_VAL(0, 0, 0)), /* SPI0 IO mux M0 */
 	RK_MUXROUTE_GRF(2, RK_PD3, 3, 0x030c, WRITE_MASK_VAL(0, 0, 1)), /* SPI0 IO mux M1 */
 	RK_MUXROUTE_GRF(2, RK_PB5, 3, 0x030c, WRITE_MASK_VAL(2, 2, 0)), /* SPI1 IO mux M0 */
 	RK_MUXROUTE_GRF(3, RK_PC3, 3, 0x030c, WRITE_MASK_VAL(2, 2, 1)), /* SPI1 IO mux M1 */
@@ -805,8 +805,8 @@ static struct rockchip_mux_route_data rk3568_mux_route_data[] = {
 	RK_MUXROUTE_GRF(4, RK_PB3, 4, 0x030c, WRITE_MASK_VAL(6, 6, 0)), /* SPI3 IO mux M0 */
 	RK_MUXROUTE_GRF(4, RK_PC2, 2, 0x030c, WRITE_MASK_VAL(6, 6, 1)), /* SPI3 IO mux M1 */
 	RK_MUXROUTE_GRF(2, RK_PB4, 2, 0x030c, WRITE_MASK_VAL(8, 8, 0)), /* UART1 IO mux M0 */
-	RK_MUXROUTE_PMU(0, RK_PD1, 1, 0x030c, WRITE_MASK_VAL(8, 8, 1)), /* UART1 IO mux M1 */
-	RK_MUXROUTE_PMU(0, RK_PD1, 1, 0x030c, WRITE_MASK_VAL(10, 10, 0)), /* UART2 IO mux M0 */
+	RK_MUXROUTE_GRF(3, RK_PD6, 4, 0x030c, WRITE_MASK_VAL(8, 8, 1)), /* UART1 IO mux M1 */
+	RK_MUXROUTE_GRF(0, RK_PD1, 1, 0x030c, WRITE_MASK_VAL(10, 10, 0)), /* UART2 IO mux M0 */
 	RK_MUXROUTE_GRF(1, RK_PD5, 2, 0x030c, WRITE_MASK_VAL(10, 10, 1)), /* UART2 IO mux M1 */
 	RK_MUXROUTE_GRF(1, RK_PA1, 2, 0x030c, WRITE_MASK_VAL(12, 12, 0)), /* UART3 IO mux M0 */
 	RK_MUXROUTE_GRF(3, RK_PB7, 4, 0x030c, WRITE_MASK_VAL(12, 12, 1)), /* UART3 IO mux M1 */
@@ -836,13 +836,13 @@ static struct rockchip_mux_route_data rk3568_mux_route_data[] = {
 	RK_MUXROUTE_GRF(3, RK_PD6, 5, 0x0314, WRITE_MASK_VAL(1, 0, 1)), /* PDM IO mux M1 */
 	RK_MUXROUTE_GRF(4, RK_PA0, 4, 0x0314, WRITE_MASK_VAL(1, 0, 1)), /* PDM IO mux M1 */
 	RK_MUXROUTE_GRF(3, RK_PC4, 5, 0x0314, WRITE_MASK_VAL(1, 0, 2)), /* PDM IO mux M2 */
-	RK_MUXROUTE_PMU(0, RK_PA5, 3, 0x0314, WRITE_MASK_VAL(3, 2, 0)), /* PCIE20 IO mux M0 */
+	RK_MUXROUTE_GRF(0, RK_PA5, 3, 0x0314, WRITE_MASK_VAL(3, 2, 0)), /* PCIE20 IO mux M0 */
 	RK_MUXROUTE_GRF(2, RK_PD0, 4, 0x0314, WRITE_MASK_VAL(3, 2, 1)), /* PCIE20 IO mux M1 */
 	RK_MUXROUTE_GRF(1, RK_PB0, 4, 0x0314, WRITE_MASK_VAL(3, 2, 2)), /* PCIE20 IO mux M2 */
-	RK_MUXROUTE_PMU(0, RK_PA4, 3, 0x0314, WRITE_MASK_VAL(5, 4, 0)), /* PCIE30X1 IO mux M0 */
+	RK_MUXROUTE_GRF(0, RK_PA4, 3, 0x0314, WRITE_MASK_VAL(5, 4, 0)), /* PCIE30X1 IO mux M0 */
 	RK_MUXROUTE_GRF(2, RK_PD2, 4, 0x0314, WRITE_MASK_VAL(5, 4, 1)), /* PCIE30X1 IO mux M1 */
 	RK_MUXROUTE_GRF(1, RK_PA5, 4, 0x0314, WRITE_MASK_VAL(5, 4, 2)), /* PCIE30X1 IO mux M2 */
-	RK_MUXROUTE_PMU(0, RK_PA6, 2, 0x0314, WRITE_MASK_VAL(7, 6, 0)), /* PCIE30X2 IO mux M0 */
+	RK_MUXROUTE_GRF(0, RK_PA6, 2, 0x0314, WRITE_MASK_VAL(7, 6, 0)), /* PCIE30X2 IO mux M0 */
 	RK_MUXROUTE_GRF(2, RK_PD4, 4, 0x0314, WRITE_MASK_VAL(7, 6, 1)), /* PCIE30X2 IO mux M1 */
 	RK_MUXROUTE_GRF(4, RK_PC2, 4, 0x0314, WRITE_MASK_VAL(7, 6, 2)), /* PCIE30X2 IO mux M2 */
 };
-- 
2.39.0



