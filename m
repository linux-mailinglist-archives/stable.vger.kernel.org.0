Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39F6353CF0D
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345395AbiFCRw1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:52:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345621AbiFCRuD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:50:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB9D4583A8;
        Fri,  3 Jun 2022 10:46:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63AC4B82430;
        Fri,  3 Jun 2022 17:46:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3222C385A9;
        Fri,  3 Jun 2022 17:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278365;
        bh=+8/rSL0dktqyZfvWABToCYxgk0Wct5z+yxpZFfy6gak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zJ/NNyNU/7l2cmiYZuIfTHFcVsKspw4e+c7V2mcpT18KBr14Sh9JVt3w2EJUerTnh
         559KHU80WwuzuQghDUQLMxwylpY0eBG7KCQhPibiwzjy20i5WOPe1uAWR6HU9oowfE
         ee3gK5nHXJB81eiHYZsLe41PTR4BfGMPjd5ou37g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, IotaHydrae <writeforever@foxmail.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 01/53] pinctrl: sunxi: fix f1c100s uart2 function
Date:   Fri,  3 Jun 2022 19:42:46 +0200
Message-Id: <20220603173818.760924525@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173818.716010877@linuxfoundation.org>
References: <20220603173818.716010877@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
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



