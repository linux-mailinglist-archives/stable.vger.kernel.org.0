Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DCB14D83FA
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:21:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241164AbiCNMW2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:22:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242892AbiCNMTv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:19:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5480650E3D;
        Mon, 14 Mar 2022 05:14:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43F4AB80DF4;
        Mon, 14 Mar 2022 12:14:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81C9EC340E9;
        Mon, 14 Mar 2022 12:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647260088;
        bh=YfpmRIDi6jRVe/IYxm/SbOg5cyruW3iEv4Tg+KggpLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OFaqFpgmxR5LuLZN23sp23QD0BDQATthzeWoHo90VqksMxL41ncptDhN+6j1cFwze
         t5Bz9ysET6wyP++H0/Q9w5iWf+lKK0yQWxcD4jIX9YJvHekdM9bGlr9Hk3AiAYjG4B
         Cj2uUlTS9OmMPCgqFyXzQLhXkMtbKQ770PM4bKBc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Featherston <mark@embeddedTS.com>,
        Kris Bahnsen <kris@embeddedTS.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 052/121] gpio: ts4900: Do not set DAT and OE together
Date:   Mon, 14 Mar 2022 12:53:55 +0100
Message-Id: <20220314112745.579079298@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112744.120491875@linuxfoundation.org>
References: <20220314112744.120491875@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Featherston <mark@embeddedTS.com>

[ Upstream commit 03fe003547975680fdb9ff5ab0e41cb68276c4f2 ]

This works around an issue with the hardware where both OE and
DAT are exposed in the same register. If both are updated
simultaneously, the harware makes no guarantees that OE or DAT
will actually change in any given order and may result in a
glitch of a few ns on a GPIO pin when changing direction and value
in a single write.

Setting direction to input now only affects OE bit. Setting
direction to output updates DAT first, then OE.

Fixes: 9c6686322d74 ("gpio: add Technologic I2C-FPGA gpio support")
Signed-off-by: Mark Featherston <mark@embeddedTS.com>
Signed-off-by: Kris Bahnsen <kris@embeddedTS.com>
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-ts4900.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/gpio/gpio-ts4900.c b/drivers/gpio/gpio-ts4900.c
index d885032cf814..d918d2df4de2 100644
--- a/drivers/gpio/gpio-ts4900.c
+++ b/drivers/gpio/gpio-ts4900.c
@@ -1,7 +1,7 @@
 /*
  * Digital I/O driver for Technologic Systems I2C FPGA Core
  *
- * Copyright (C) 2015 Technologic Systems
+ * Copyright (C) 2015, 2018 Technologic Systems
  * Copyright (C) 2016 Savoir-Faire Linux
  *
  * This program is free software; you can redistribute it and/or
@@ -55,19 +55,33 @@ static int ts4900_gpio_direction_input(struct gpio_chip *chip,
 {
 	struct ts4900_gpio_priv *priv = gpiochip_get_data(chip);
 
-	/*
-	 * This will clear the output enable bit, the other bits are
-	 * dontcare when this is cleared
+	/* Only clear the OE bit here, requires a RMW. Prevents potential issue
+	 * with OE and data getting to the physical pin at different times.
 	 */
-	return regmap_write(priv->regmap, offset, 0);
+	return regmap_update_bits(priv->regmap, offset, TS4900_GPIO_OE, 0);
 }
 
 static int ts4900_gpio_direction_output(struct gpio_chip *chip,
 					unsigned int offset, int value)
 {
 	struct ts4900_gpio_priv *priv = gpiochip_get_data(chip);
+	unsigned int reg;
 	int ret;
 
+	/* If changing from an input to an output, we need to first set the
+	 * proper data bit to what is requested and then set OE bit. This
+	 * prevents a glitch that can occur on the IO line
+	 */
+	regmap_read(priv->regmap, offset, &reg);
+	if (!(reg & TS4900_GPIO_OE)) {
+		if (value)
+			reg = TS4900_GPIO_OUT;
+		else
+			reg &= ~TS4900_GPIO_OUT;
+
+		regmap_write(priv->regmap, offset, reg);
+	}
+
 	if (value)
 		ret = regmap_write(priv->regmap, offset, TS4900_GPIO_OE |
 							 TS4900_GPIO_OUT);
-- 
2.34.1



