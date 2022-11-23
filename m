Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17E9A635836
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:52:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238146AbiKWJur (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:50:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238218AbiKWJuC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:50:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 922BDA19E
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:47:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15A16B81EEB
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:47:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37F6EC433D6;
        Wed, 23 Nov 2022 09:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196842;
        bh=PDdayDWsln3sTnzeIamZPAf90vMe0dMrsX1cuJBei+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JZnHLOKaI0Re26j9FOeLEknBL7JEIF9z/KTLm15ITqb7GxlPgFfNgiA4gP+1q85Uq
         ZJ7oRpr31Nj8G7W0V0LM3iYEBQJEqLdZwYJqqoVlVdSrZJ6w+xX8rTSgbJy3+Gyw9G
         o8RSLe9JeNgxDhtKV9SWcS/ElOtgEFfymJCOxfEE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Quentin Schulz <quentin.schulz@theobroma-systems.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 108/314] pinctrl: rockchip: list all pins in a possible mux route for PX30
Date:   Wed, 23 Nov 2022 09:49:13 +0100
Message-Id: <20221123084630.394058855@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quentin Schulz <quentin.schulz@theobroma-systems.com>

[ Upstream commit bee55f2e7a44e7a7676e264b42f026e34bd244d9 ]

The mux routes are incomplete for the PX30. This was discovered because
we had a HW design using cif-clkoutm1 with the correct pinmux in the
Device Tree but the clock would still not work.

There are actually two muxing required: the pin muxing (performed by the
usual Device Tree pinctrl nodes) and the "function" muxing (m0 vs m1;
performed by the mux routing inside the driver). The pin muxing was
correct but the function muxing was not.

This adds the missing pins and their configuration for the mux routes
that are already specified in the driver.

Note that there are some "conflicts": it is possible *in Device Tree* to
(attempt to) mux the pins for e.g. clkoutm1 and clkinm0 at the same time
but this is actually not possible in hardware (because both share the
same bit for the function muxing). Since it is an impossible hardware
design, it is not deemed necessary to prevent the user from attempting
to "misconfigure" the pins/functions.

Fixes: 87065ca9b8e5 ("pinctrl: rockchip: Add pinctrl support for PX30")
Signed-off-by: Quentin Schulz <quentin.schulz@theobroma-systems.com>
Link: https://lore.kernel.org/r/20221017-upstream-px30-cif-clkoutm1-v1-0-4ea1389237f7@theobroma-systems.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-rockchip.c | 40 ++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-rockchip.c b/drivers/pinctrl/pinctrl-rockchip.c
index c84bd0e1ce5a..f4d2b64c0670 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -632,14 +632,54 @@ static void rockchip_get_recalced_mux(struct rockchip_pin_bank *bank, int pin,
 }
 
 static struct rockchip_mux_route_data px30_mux_route_data[] = {
+	RK_MUXROUTE_SAME(2, RK_PB4, 1, 0x184, BIT(16 + 7)), /* cif-d0m0 */
+	RK_MUXROUTE_SAME(3, RK_PA1, 3, 0x184, BIT(16 + 7) | BIT(7)), /* cif-d0m1 */
+	RK_MUXROUTE_SAME(2, RK_PB6, 1, 0x184, BIT(16 + 7)), /* cif-d1m0 */
+	RK_MUXROUTE_SAME(3, RK_PA2, 3, 0x184, BIT(16 + 7) | BIT(7)), /* cif-d1m1 */
 	RK_MUXROUTE_SAME(2, RK_PA0, 1, 0x184, BIT(16 + 7)), /* cif-d2m0 */
 	RK_MUXROUTE_SAME(3, RK_PA3, 3, 0x184, BIT(16 + 7) | BIT(7)), /* cif-d2m1 */
+	RK_MUXROUTE_SAME(2, RK_PA1, 1, 0x184, BIT(16 + 7)), /* cif-d3m0 */
+	RK_MUXROUTE_SAME(3, RK_PA5, 3, 0x184, BIT(16 + 7) | BIT(7)), /* cif-d3m1 */
+	RK_MUXROUTE_SAME(2, RK_PA2, 1, 0x184, BIT(16 + 7)), /* cif-d4m0 */
+	RK_MUXROUTE_SAME(3, RK_PA7, 3, 0x184, BIT(16 + 7) | BIT(7)), /* cif-d4m1 */
+	RK_MUXROUTE_SAME(2, RK_PA3, 1, 0x184, BIT(16 + 7)), /* cif-d5m0 */
+	RK_MUXROUTE_SAME(3, RK_PB0, 3, 0x184, BIT(16 + 7) | BIT(7)), /* cif-d5m1 */
+	RK_MUXROUTE_SAME(2, RK_PA4, 1, 0x184, BIT(16 + 7)), /* cif-d6m0 */
+	RK_MUXROUTE_SAME(3, RK_PB1, 3, 0x184, BIT(16 + 7) | BIT(7)), /* cif-d6m1 */
+	RK_MUXROUTE_SAME(2, RK_PA5, 1, 0x184, BIT(16 + 7)), /* cif-d7m0 */
+	RK_MUXROUTE_SAME(3, RK_PB4, 3, 0x184, BIT(16 + 7) | BIT(7)), /* cif-d7m1 */
+	RK_MUXROUTE_SAME(2, RK_PA6, 1, 0x184, BIT(16 + 7)), /* cif-d8m0 */
+	RK_MUXROUTE_SAME(3, RK_PB6, 3, 0x184, BIT(16 + 7) | BIT(7)), /* cif-d8m1 */
+	RK_MUXROUTE_SAME(2, RK_PA7, 1, 0x184, BIT(16 + 7)), /* cif-d9m0 */
+	RK_MUXROUTE_SAME(3, RK_PB7, 3, 0x184, BIT(16 + 7) | BIT(7)), /* cif-d9m1 */
+	RK_MUXROUTE_SAME(2, RK_PB7, 1, 0x184, BIT(16 + 7)), /* cif-d10m0 */
+	RK_MUXROUTE_SAME(3, RK_PC6, 3, 0x184, BIT(16 + 7) | BIT(7)), /* cif-d10m1 */
+	RK_MUXROUTE_SAME(2, RK_PC0, 1, 0x184, BIT(16 + 7)), /* cif-d11m0 */
+	RK_MUXROUTE_SAME(3, RK_PC7, 3, 0x184, BIT(16 + 7) | BIT(7)), /* cif-d11m1 */
+	RK_MUXROUTE_SAME(2, RK_PB0, 1, 0x184, BIT(16 + 7)), /* cif-vsyncm0 */
+	RK_MUXROUTE_SAME(3, RK_PD1, 3, 0x184, BIT(16 + 7) | BIT(7)), /* cif-vsyncm1 */
+	RK_MUXROUTE_SAME(2, RK_PB1, 1, 0x184, BIT(16 + 7)), /* cif-hrefm0 */
+	RK_MUXROUTE_SAME(3, RK_PD2, 3, 0x184, BIT(16 + 7) | BIT(7)), /* cif-hrefm1 */
+	RK_MUXROUTE_SAME(2, RK_PB2, 1, 0x184, BIT(16 + 7)), /* cif-clkinm0 */
+	RK_MUXROUTE_SAME(3, RK_PD3, 3, 0x184, BIT(16 + 7) | BIT(7)), /* cif-clkinm1 */
+	RK_MUXROUTE_SAME(2, RK_PB3, 1, 0x184, BIT(16 + 7)), /* cif-clkoutm0 */
+	RK_MUXROUTE_SAME(3, RK_PD0, 3, 0x184, BIT(16 + 7) | BIT(7)), /* cif-clkoutm1 */
 	RK_MUXROUTE_SAME(3, RK_PC6, 2, 0x184, BIT(16 + 8)), /* pdm-m0 */
 	RK_MUXROUTE_SAME(2, RK_PC6, 1, 0x184, BIT(16 + 8) | BIT(8)), /* pdm-m1 */
+	RK_MUXROUTE_SAME(3, RK_PD3, 2, 0x184, BIT(16 + 8)), /* pdm-sdi0m0 */
+	RK_MUXROUTE_SAME(2, RK_PC5, 2, 0x184, BIT(16 + 8) | BIT(8)), /* pdm-sdi0m1 */
 	RK_MUXROUTE_SAME(1, RK_PD3, 2, 0x184, BIT(16 + 10)), /* uart2-rxm0 */
 	RK_MUXROUTE_SAME(2, RK_PB6, 2, 0x184, BIT(16 + 10) | BIT(10)), /* uart2-rxm1 */
+	RK_MUXROUTE_SAME(1, RK_PD2, 2, 0x184, BIT(16 + 10)), /* uart2-txm0 */
+	RK_MUXROUTE_SAME(2, RK_PB4, 2, 0x184, BIT(16 + 10) | BIT(10)), /* uart2-txm1 */
 	RK_MUXROUTE_SAME(0, RK_PC1, 2, 0x184, BIT(16 + 9)), /* uart3-rxm0 */
 	RK_MUXROUTE_SAME(1, RK_PB7, 2, 0x184, BIT(16 + 9) | BIT(9)), /* uart3-rxm1 */
+	RK_MUXROUTE_SAME(0, RK_PC0, 2, 0x184, BIT(16 + 9)), /* uart3-txm0 */
+	RK_MUXROUTE_SAME(1, RK_PB6, 2, 0x184, BIT(16 + 9) | BIT(9)), /* uart3-txm1 */
+	RK_MUXROUTE_SAME(0, RK_PC2, 2, 0x184, BIT(16 + 9)), /* uart3-ctsm0 */
+	RK_MUXROUTE_SAME(1, RK_PB4, 2, 0x184, BIT(16 + 9) | BIT(9)), /* uart3-ctsm1 */
+	RK_MUXROUTE_SAME(0, RK_PC3, 2, 0x184, BIT(16 + 9)), /* uart3-rtsm0 */
+	RK_MUXROUTE_SAME(1, RK_PB5, 2, 0x184, BIT(16 + 9) | BIT(9)), /* uart3-rtsm1 */
 };
 
 static struct rockchip_mux_route_data rk3128_mux_route_data[] = {
-- 
2.35.1



