Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56DB26B49C0
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:15:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234004AbjCJPP2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:15:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234123AbjCJPOz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:14:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86CDC16AC0
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:06:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC79E61982
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:05:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C135BC433D2;
        Fri, 10 Mar 2023 15:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678460719;
        bh=YwKlZlN2yfv1u9w0U/R/EUE/SVb0huevL8Ivxt0iWro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uxL89HL/Vv6Qp1G3qTmc0SmBGZVPgH0FdINn/v7tbEOrBXKu3f40SdzQ/QICeqd3d
         DrH45ADqje+4mdmDY2e98ooXCdhKxjq+YrREO3yznQMgzstfQeDEgcsNnWzVnIkgmQ
         jL9sX4MtC6fcoeLvo9Ao+YabjL+qGTKHsSCq8wg4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jonas Karlman <jonas@kwiboo.se>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.10 428/529] pinctrl: rockchip: fix mux route data for rk3568
Date:   Fri, 10 Mar 2023 14:39:31 +0100
Message-Id: <20230310133824.804027182@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonas Karlman <jonas@kwiboo.se>

commit 431d1531466033909d2e8c754a7dc3704b70843f upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/pinctrl-rockchip.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -954,19 +954,19 @@ static struct rockchip_mux_route_data rk
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
@@ -992,7 +992,7 @@ static struct rockchip_mux_route_data rk
 	RK_MUXROUTE_GRF(4, RK_PC3, 1, 0x0308, WRITE_MASK_VAL(12, 12, 1)), /* PWM15 IO mux M1 */
 	RK_MUXROUTE_GRF(3, RK_PD2, 3, 0x0308, WRITE_MASK_VAL(14, 14, 0)), /* SDMMC2 IO mux M0 */
 	RK_MUXROUTE_GRF(3, RK_PA5, 5, 0x0308, WRITE_MASK_VAL(14, 14, 1)), /* SDMMC2 IO mux M1 */
-	RK_MUXROUTE_PMU(0, RK_PB5, 2, 0x030c, WRITE_MASK_VAL(0, 0, 0)), /* SPI0 IO mux M0 */
+	RK_MUXROUTE_GRF(0, RK_PB5, 2, 0x030c, WRITE_MASK_VAL(0, 0, 0)), /* SPI0 IO mux M0 */
 	RK_MUXROUTE_GRF(2, RK_PD3, 3, 0x030c, WRITE_MASK_VAL(0, 0, 1)), /* SPI0 IO mux M1 */
 	RK_MUXROUTE_GRF(2, RK_PB5, 3, 0x030c, WRITE_MASK_VAL(2, 2, 0)), /* SPI1 IO mux M0 */
 	RK_MUXROUTE_GRF(3, RK_PC3, 3, 0x030c, WRITE_MASK_VAL(2, 2, 1)), /* SPI1 IO mux M1 */
@@ -1001,8 +1001,8 @@ static struct rockchip_mux_route_data rk
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
@@ -1032,13 +1032,13 @@ static struct rockchip_mux_route_data rk
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


