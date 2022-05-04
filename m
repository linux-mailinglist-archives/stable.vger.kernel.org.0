Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29DCD51A6E0
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 18:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354653AbiEDRBW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355297AbiEDQ7w (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 12:59:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D5B2496AD;
        Wed,  4 May 2022 09:51:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF957617E7;
        Wed,  4 May 2022 16:51:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45BB8C385A5;
        Wed,  4 May 2022 16:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683085;
        bh=1NXmhjDJG8sVMXeuR7P7595+33BQJhz9J+Aca7pXwWs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bqJG6Rl3LrJzhG/CRDPc4E2jhUKvt/FSyjSD/a6tDtA71mL697TsILmw7qKwZGi8C
         lj/gK4wJz3smLx5ea9HEA10vBVjpiO1x43mK4xCM/rvUt2ZbO5u6bCT+dAW+m2jPLc
         9q173br2Y5JEpm/oLlKdg7DmbRSY+fTnXmpslBwc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luca Ceresoli <luca.ceresoli@bootlin.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 066/129] pinctrl: rockchip: fix RK3308 pinmux bits
Date:   Wed,  4 May 2022 18:44:18 +0200
Message-Id: <20220504153026.508369870@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153021.299025455@linuxfoundation.org>
References: <20220504153021.299025455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luca Ceresoli <luca.ceresoli@bootlin.com>

[ Upstream commit 1f3e25a068832f8892a5ff71467622d012f5bc9f ]

Some of the pinmuxing bits described in rk3308_mux_recalced_data are wrong,
pointing to non-existing registers.

Fix the entire table.

Also add a comment in front of each entry with the same string that appears
in the datasheet to make the table easier to compare with the docs.

This fix has been tested on real hardware for the gpio3b3_sel entry.

Fixes: 7825aeb7b208 ("pinctrl: rockchip: add rk3308 SoC support")
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20220420142432.248565-1-luca.ceresoli@bootlin.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-rockchip.c | 45 ++++++++++++++++++++----------
 1 file changed, 30 insertions(+), 15 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-rockchip.c b/drivers/pinctrl/pinctrl-rockchip.c
index 9df48e0cf4cb..07b1204174bf 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -663,95 +663,110 @@ static  struct rockchip_mux_recalced_data rk3128_mux_recalced_data[] = {
 
 static struct rockchip_mux_recalced_data rk3308_mux_recalced_data[] = {
 	{
+		/* gpio1b6_sel */
 		.num = 1,
 		.pin = 14,
 		.reg = 0x28,
 		.bit = 12,
 		.mask = 0xf
 	}, {
+		/* gpio1b7_sel */
 		.num = 1,
 		.pin = 15,
 		.reg = 0x2c,
 		.bit = 0,
 		.mask = 0x3
 	}, {
+		/* gpio1c2_sel */
 		.num = 1,
 		.pin = 18,
 		.reg = 0x30,
 		.bit = 4,
 		.mask = 0xf
 	}, {
+		/* gpio1c3_sel */
 		.num = 1,
 		.pin = 19,
 		.reg = 0x30,
 		.bit = 8,
 		.mask = 0xf
 	}, {
+		/* gpio1c4_sel */
 		.num = 1,
 		.pin = 20,
 		.reg = 0x30,
 		.bit = 12,
 		.mask = 0xf
 	}, {
+		/* gpio1c5_sel */
 		.num = 1,
 		.pin = 21,
 		.reg = 0x34,
 		.bit = 0,
 		.mask = 0xf
 	}, {
+		/* gpio1c6_sel */
 		.num = 1,
 		.pin = 22,
 		.reg = 0x34,
 		.bit = 4,
 		.mask = 0xf
 	}, {
+		/* gpio1c7_sel */
 		.num = 1,
 		.pin = 23,
 		.reg = 0x34,
 		.bit = 8,
 		.mask = 0xf
 	}, {
+		/* gpio3b4_sel */
 		.num = 3,
 		.pin = 12,
 		.reg = 0x68,
 		.bit = 8,
 		.mask = 0xf
 	}, {
+		/* gpio3b5_sel */
 		.num = 3,
 		.pin = 13,
 		.reg = 0x68,
 		.bit = 12,
 		.mask = 0xf
 	}, {
+		/* gpio2a2_sel */
 		.num = 2,
 		.pin = 2,
-		.reg = 0x608,
-		.bit = 0,
-		.mask = 0x7
+		.reg = 0x40,
+		.bit = 4,
+		.mask = 0x3
 	}, {
+		/* gpio2a3_sel */
 		.num = 2,
 		.pin = 3,
-		.reg = 0x608,
-		.bit = 4,
-		.mask = 0x7
+		.reg = 0x40,
+		.bit = 6,
+		.mask = 0x3
 	}, {
+		/* gpio2c0_sel */
 		.num = 2,
 		.pin = 16,
-		.reg = 0x610,
-		.bit = 8,
-		.mask = 0x7
+		.reg = 0x50,
+		.bit = 0,
+		.mask = 0x3
 	}, {
+		/* gpio3b2_sel */
 		.num = 3,
 		.pin = 10,
-		.reg = 0x610,
-		.bit = 0,
-		.mask = 0x7
+		.reg = 0x68,
+		.bit = 4,
+		.mask = 0x3
 	}, {
+		/* gpio3b3_sel */
 		.num = 3,
 		.pin = 11,
-		.reg = 0x610,
-		.bit = 4,
-		.mask = 0x7
+		.reg = 0x68,
+		.bit = 6,
+		.mask = 0x3
 	},
 };
 
-- 
2.35.1



