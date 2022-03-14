Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A55004D8107
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 12:37:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239334AbiCNLit (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 07:38:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239637AbiCNLid (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 07:38:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB7B441F98;
        Mon, 14 Mar 2022 04:37:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D92DB80DB7;
        Mon, 14 Mar 2022 11:37:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C875C340E9;
        Mon, 14 Mar 2022 11:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647257841;
        bh=Tyw5QrVnfC1kAJr4FzLxEeD45l5eRSblJilYfTF51P0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CHC2JSx9+IwQlcQE+RaesYl36fzKGh0s8Ru/0KP6UjlcHfP3VSWLhyg6fZubPimm7
         iCiYA8rA7dLM7RY3agXttb+RLldUD9Bi5J3Mdtxhshmk9qfXEiYgWM/ko3YOXEaRvK
         8BknJTf6mdJ/8GU4sbusItfCRvdi2+dvIe1SLbzs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Featherston <mark@embeddedTS.com>,
        Kris Bahnsen <kris@embeddedTS.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 09/23] gpio: ts4900: Do not set DAT and OE together
Date:   Mon, 14 Mar 2022 12:34:22 +0100
Message-Id: <20220314112731.327807263@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112731.050583127@linuxfoundation.org>
References: <20220314112731.050583127@linuxfoundation.org>
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
index 5bd21725e604..930a6098b758 100644
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
@@ -52,19 +52,33 @@ static int ts4900_gpio_direction_input(struct gpio_chip *chip,
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



