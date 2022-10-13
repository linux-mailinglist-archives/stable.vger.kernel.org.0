Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF2D5FD060
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 02:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbiJMA0h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 20:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230432AbiJMAYg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 20:24:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13AD1102DD2;
        Wed, 12 Oct 2022 17:24:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65841B81CD3;
        Thu, 13 Oct 2022 00:19:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64B54C433D7;
        Thu, 13 Oct 2022 00:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620380;
        bh=by6FMdDofPUT9KDymGYTqqO8fl71j0ukQyxsG6MWRcI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZXNFN8M1Nnf2kfXBSSlHGyF6rzuQCy1f45VIRW0xPOemu8/Vs31fxHDWsNZO3PeCX
         Yo3VC//SQh/I0q/yjth3xW13bEXwHlDeQFv/JBKChYyiVyi091zSwmI0usPTqCRONA
         LdHVFIEIrUx9aN5+O2IzlReG+Ln6gYY0ogJjPmj7/sS/PiQ0zhEGvewa8mv3LLtgqE
         LryndFosLC2g8y56qVCxyuNaPUp4rMCv1vVHeHYzkiTbGI7qqUY0W+9bi5UAOzBfbc
         yIrdpYZHuA3fkuNeTfyk2gPsoU2umdmkYxM4IRNMVhlro32KFvJraD3fLHrVDkh8vy
         T7jHI/9lZiJig==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 22/63] gpiolib: of: make Freescale SPI quirk similar to all others
Date:   Wed, 12 Oct 2022 20:17:56 -0400
Message-Id: <20221013001842.1893243-22-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013001842.1893243-1-sashal@kernel.org>
References: <20221013001842.1893243-1-sashal@kernel.org>
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
index b43c8bec24c2..a5b4abb980de 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -404,7 +404,7 @@ static struct gpio_desc *of_find_spi_gpio(struct device *dev,
 static struct gpio_desc *of_find_spi_cs_gpio(struct device *dev,
 					     const char *con_id,
 					     unsigned int idx,
-					     unsigned long *flags)
+					     enum of_gpio_flags *of_flags)
 {
 	const struct device_node *np = dev->of_node;
 
@@ -425,7 +425,7 @@ static struct gpio_desc *of_find_spi_cs_gpio(struct device *dev,
 	 * uses just "gpios" so translate to that when "cs-gpios" is
 	 * requested.
 	 */
-	return of_find_gpio(dev, NULL, idx, flags);
+	return of_get_named_gpiod_flags(dev->of_node, "gpios", idx, of_flags);
 }
 
 /*
@@ -524,12 +524,8 @@ struct gpio_desc *of_find_gpio(struct device *dev, const char *con_id,
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

