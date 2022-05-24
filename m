Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0768532E04
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 18:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239200AbiEXP7t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 11:59:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239191AbiEXP7r (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 11:59:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D1079B1BF;
        Tue, 24 May 2022 08:59:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F02AB81A50;
        Tue, 24 May 2022 15:59:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5BB6C34119;
        Tue, 24 May 2022 15:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653407983;
        bh=+8/rSL0dktqyZfvWABToCYxgk0Wct5z+yxpZFfy6gak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JV6Y+kYzlxA50DwabvFq0xTfWb0dmxTYBk0BS1gmdBWXT1R6IA6xIY4UgPX7YzvtV
         rTrk8DYPY7TZNIQrKKzX3K5Qy3QOeKcA9eyPMMRQyVmq8Sd1UTrshRDHNZ5g8tqPaT
         vq0i9FRyQhVKE4itrgQQ9j8eBkFHRYNVQfqitxFqOLTuOdEW+TDsTgrC7HkFT2lxjk
         kp4TOCodAt4vwWb0p1zzBNtYFvAqWq/w/plED49/YYD2LN3yY1xsbpn9tSrfLtqQvJ
         LHHKtobHptxhfXwCP50xujCoCjWKvNKrHsu2OtEerFiAILGHlLG/PXVYiK6bDyZg9g
         z6mDhkt+l4d5g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     IotaHydrae <writeforever@foxmail.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, wens@csie.org,
        jernej.skrabec@gmail.com, samuel@sholland.org,
        linux-gpio@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@lists.linux.dev
Subject: [PATCH AUTOSEL 5.17 04/12] pinctrl: sunxi: fix f1c100s uart2 function
Date:   Tue, 24 May 2022 11:59:18 -0400
Message-Id: <20220524155929.826793-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220524155929.826793-1-sashal@kernel.org>
References: <20220524155929.826793-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: IotaHydrae <writeforever@foxmail.com>

[ Upstream commit fa8785e5931367e2b43f2c507f26bcf3e281c0ca ]

Change suniv f1c100s pinctrl,PD14 multiplexing function lvds1 to uart2

When the pin PD13 and PD14 is setting up to uart2 function in dts,
there's an error occurred:
1c20800.pinctrl: unsupported function uart2 on pin PD14

Because 'uart2' is not any one multiplexing option of PD14,
and pinctrl don't know how to configure it.

So change the pin PD14 lvds1 function to uart2.

Signed-off-by: IotaHydrae <writeforever@foxmail.com>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Link: https://lore.kernel.org/r/tencent_70C1308DDA794C81CAEF389049055BACEC09@qq.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/sunxi/pinctrl-suniv-f1c100s.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/sunxi/pinctrl-suniv-f1c100s.c b/drivers/pinctrl/sunxi/pinctrl-suniv-f1c100s.c
index 2801ca706273..68a5b627fb9b 100644
--- a/drivers/pinctrl/sunxi/pinctrl-suniv-f1c100s.c
+++ b/drivers/pinctrl/sunxi/pinctrl-suniv-f1c100s.c
@@ -204,7 +204,7 @@ static const struct sunxi_desc_pin suniv_f1c100s_pins[] = {
 		  SUNXI_FUNCTION(0x0, "gpio_in"),
 		  SUNXI_FUNCTION(0x1, "gpio_out"),
 		  SUNXI_FUNCTION(0x2, "lcd"),		/* D20 */
-		  SUNXI_FUNCTION(0x3, "lvds1"),		/* RX */
+		  SUNXI_FUNCTION(0x3, "uart2"),		/* RX */
 		  SUNXI_FUNCTION_IRQ_BANK(0x6, 0, 14)),
 	SUNXI_PIN(SUNXI_PINCTRL_PIN(D, 15),
 		  SUNXI_FUNCTION(0x0, "gpio_in"),
-- 
2.35.1

