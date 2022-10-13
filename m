Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11D345FCF76
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 02:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbiJMASR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 20:18:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiJMARo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 20:17:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17150197F86;
        Wed, 12 Oct 2022 17:17:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45F1161684;
        Thu, 13 Oct 2022 00:16:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E457EC433C1;
        Thu, 13 Oct 2022 00:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620209;
        bh=6mTtkkM2X54TK5ED9VusK05TamqkZxpTOCWQriOcCro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BuARYp3LZ8fuUjzm7LaTvPAoDYYyDePArbvJQ+1A7JyQ4+OpVttbBMuqfxoFHRutS
         FOq0B3v3F3nMPRneRG9/cXJ5kxRljVANdPhOXzeP2qt+7KJHj608bknHDb47A0W/S+
         SPtgsPEdsrNsQEchs2bRuXJOSuvMbnq7PklI1eirLZd1fQpxp2yg3D7AQHqqXCbDG/
         xvvYrk4oXlVHRkx6sbK1N3NBxV3lXMZGEW+unqFzNbbsB4oILneYNb6c7ZFYkvEYOR
         UvGd13xu4W2tebN21uiI3QRncTDd+4AWea5QTC8YBnHUhv1UY9hVYmjyURQlFAacu8
         r+0rA7zhypbvw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 22/67] gpiolib: of: make Freescale SPI quirk similar to all others
Date:   Wed, 12 Oct 2022 20:15:03 -0400
Message-Id: <20221013001554.1892206-22-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013001554.1892206-1-sashal@kernel.org>
References: <20221013001554.1892206-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit 984914ec4f4bfa9ee8f067b06293bc12bef20137 ]

There is no need for of_find_spi_cs_gpio() to be different from other
quirks: the only variant of property actually used in DTS is "gpios"
(plural) so we can use of_get_named_gpiod_flags() instead of recursing
into of_find_gpio() again.

This will allow us consolidate quirk handling down the road.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-of.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
index c08564948bf9..30b89b694530 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -407,7 +407,7 @@ static struct gpio_desc *of_find_spi_gpio(struct device *dev,
 static struct gpio_desc *of_find_spi_cs_gpio(struct device *dev,
 					     const char *con_id,
 					     unsigned int idx,
-					     unsigned long *flags)
+					     enum of_gpio_flags *of_flags)
 {
 	const struct device_node *np = dev->of_node;
 
@@ -428,7 +428,7 @@ static struct gpio_desc *of_find_spi_cs_gpio(struct device *dev,
 	 * uses just "gpios" so translate to that when "cs-gpios" is
 	 * requested.
 	 */
-	return of_find_gpio(dev, NULL, idx, flags);
+	return of_get_named_gpiod_flags(dev->of_node, "gpios", idx, of_flags);
 }
 
 /*
@@ -527,12 +527,8 @@ struct gpio_desc *of_find_gpio(struct device *dev, const char *con_id,
 		desc = of_find_spi_gpio(dev, con_id, idx, &of_flags);
 	}
 
-	if (gpiod_not_found(desc)) {
-		/* This quirk looks up flags and all */
-		desc = of_find_spi_cs_gpio(dev, con_id, idx, flags);
-		if (!IS_ERR(desc))
-			return desc;
-	}
+	if (gpiod_not_found(desc))
+		desc = of_find_spi_cs_gpio(dev, con_id, idx, &of_flags);
 
 	if (gpiod_not_found(desc)) {
 		/* Special handling for regulator GPIOs if used */
-- 
2.35.1

