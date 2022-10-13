Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F191A5FD23E
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 03:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231549AbiJMBJS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 21:09:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232513AbiJMBIv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 21:08:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54547EE88A;
        Wed, 12 Oct 2022 18:06:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 37CE8B81CE1;
        Thu, 13 Oct 2022 00:22:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22C46C433C1;
        Thu, 13 Oct 2022 00:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620539;
        bh=JGLTKbsD/sdAt4qMN1vPrUfBqXQvtOwEO0dsNfJFF40=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KZ1Yx1++3iVsZyrfow5NMvWL2nNYEcqwIWQvQvBen1P03QT+y6pd4mibcR34yTQ0M
         1f4FDeQBUzRr29CM/M5OodF2jUpjw0eDM9+esPDYWOu8iVH/M03vmfj4puIEsvxWhN
         b1ZnBGVaHoJkv4Np2TsZxTnPZrEhFITSHbCCgSTgR0bKv9nQroQpqRSaljDmwJJrpR
         fmFFVD1MzT9LdJyX+DYWKCq+uDt1YvoYLghko833wNWiiOz37va5NoREdlbhyEU2cA
         JNuIfB1r3E6AGetXYY9jn3FokrriSENFFmy0/QhqdyhctfFz1PB9hJpCzcA2QgXg1d
         iaZpJawOhF1og==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 18/47] gpiolib: rework quirk handling in of_find_gpio()
Date:   Wed, 12 Oct 2022 20:20:53 -0400
Message-Id: <20221013002124.1894077-18-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013002124.1894077-1-sashal@kernel.org>
References: <20221013002124.1894077-1-sashal@kernel.org>
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

[ Upstream commit a2b5e207cade33b4d2dfd920f783f13b1f173e78 ]

Instead of having a string of "if" statements let's put all quirks into
an array and iterate over them.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-of.c | 62 ++++++++++++++++-----------------------
 1 file changed, 26 insertions(+), 36 deletions(-)

diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
index fe34061d918b..77fa14776078 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -369,14 +369,12 @@ EXPORT_SYMBOL_GPL(gpiod_get_from_of_node);
  * properties should be named "foo-gpios" so we have this special kludge for
  * them.
  */
-static struct gpio_desc *of_find_spi_gpio(struct device *dev,
+static struct gpio_desc *of_find_spi_gpio(struct device_node *np,
 					  const char *con_id,
 					  unsigned int idx,
 					  enum of_gpio_flags *of_flags)
 {
 	char prop_name[32]; /* 32 is max size of property name */
-	const struct device_node *np = dev->of_node;
-	struct gpio_desc *desc;
 
 	/*
 	 * Hopefully the compiler stubs the rest of the function if this
@@ -392,8 +390,7 @@ static struct gpio_desc *of_find_spi_gpio(struct device *dev,
 	/* Will be "gpio-sck", "gpio-mosi" or "gpio-miso" */
 	snprintf(prop_name, sizeof(prop_name), "%s-%s", "gpio", con_id);
 
-	desc = of_get_named_gpiod_flags(np, prop_name, idx, of_flags);
-	return desc;
+	return of_get_named_gpiod_flags(np, prop_name, idx, of_flags);
 }
 
 /*
@@ -401,13 +398,11 @@ static struct gpio_desc *of_find_spi_gpio(struct device *dev,
  * lines rather than "cs-gpios" like all other SPI hardware. Account for this
  * with a special quirk.
  */
-static struct gpio_desc *of_find_spi_cs_gpio(struct device *dev,
+static struct gpio_desc *of_find_spi_cs_gpio(struct device_node *np,
 					     const char *con_id,
 					     unsigned int idx,
 					     enum of_gpio_flags *of_flags)
 {
-	const struct device_node *np = dev->of_node;
-
 	if (!IS_ENABLED(CONFIG_SPI_MASTER))
 		return ERR_PTR(-ENOENT);
 
@@ -425,7 +420,7 @@ static struct gpio_desc *of_find_spi_cs_gpio(struct device *dev,
 	 * uses just "gpios" so translate to that when "cs-gpios" is
 	 * requested.
 	 */
-	return of_get_named_gpiod_flags(dev->of_node, "gpios", idx, of_flags);
+	return of_get_named_gpiod_flags(np, "gpios", idx, of_flags);
 }
 
 /*
@@ -433,7 +428,7 @@ static struct gpio_desc *of_find_spi_cs_gpio(struct device *dev,
  * properties should be named "foo-gpios" so we have this special kludge for
  * them.
  */
-static struct gpio_desc *of_find_regulator_gpio(struct device *dev,
+static struct gpio_desc *of_find_regulator_gpio(struct device_node *np,
 						const char *con_id,
 						unsigned int idx,
 						enum of_gpio_flags *of_flags)
@@ -444,8 +439,6 @@ static struct gpio_desc *of_find_regulator_gpio(struct device *dev,
 		"wlf,ldo1ena", /* WM8994 */
 		"wlf,ldo2ena", /* WM8994 */
 	};
-	const struct device_node *np = dev->of_node;
-	struct gpio_desc *desc;
 	int i;
 
 	if (!IS_ENABLED(CONFIG_REGULATOR))
@@ -458,11 +451,10 @@ static struct gpio_desc *of_find_regulator_gpio(struct device *dev,
 	if (i < 0)
 		return ERR_PTR(-ENOENT);
 
-	desc = of_get_named_gpiod_flags(np, con_id, idx, of_flags);
-	return desc;
+	return of_get_named_gpiod_flags(np, con_id, idx, of_flags);
 }
 
-static struct gpio_desc *of_find_arizona_gpio(struct device *dev,
+static struct gpio_desc *of_find_arizona_gpio(struct device_node *np,
 					      const char *con_id,
 					      unsigned int idx,
 					      enum of_gpio_flags *of_flags)
@@ -473,10 +465,10 @@ static struct gpio_desc *of_find_arizona_gpio(struct device *dev,
 	if (!con_id || strcmp(con_id, "wlf,reset"))
 		return ERR_PTR(-ENOENT);
 
-	return of_get_named_gpiod_flags(dev->of_node, con_id, idx, of_flags);
+	return of_get_named_gpiod_flags(np, con_id, idx, of_flags);
 }
 
-static struct gpio_desc *of_find_usb_gpio(struct device *dev,
+static struct gpio_desc *of_find_usb_gpio(struct device_node *np,
 					  const char *con_id,
 					  unsigned int idx,
 					  enum of_gpio_flags *of_flags)
@@ -492,14 +484,27 @@ static struct gpio_desc *of_find_usb_gpio(struct device *dev,
 	if (!con_id || strcmp(con_id, "fcs,int_n"))
 		return ERR_PTR(-ENOENT);
 
-	return of_get_named_gpiod_flags(dev->of_node, con_id, idx, of_flags);
+	return of_get_named_gpiod_flags(np, con_id, idx, of_flags);
 }
 
+typedef struct gpio_desc *(*of_find_gpio_quirk)(struct device_node *np,
+						const char *con_id,
+						unsigned int idx,
+						enum of_gpio_flags *of_flags);
+static const of_find_gpio_quirk of_find_gpio_quirks[] = {
+	of_find_spi_gpio,
+	of_find_spi_cs_gpio,
+	of_find_regulator_gpio,
+	of_find_arizona_gpio,
+	of_find_usb_gpio,
+};
+
 struct gpio_desc *of_find_gpio(struct device *dev, const char *con_id,
 			       unsigned int idx, unsigned long *flags)
 {
 	char prop_name[32]; /* 32 is max size of property name */
 	enum of_gpio_flags of_flags;
+	const of_find_gpio_quirk *q;
 	struct gpio_desc *desc;
 	unsigned int i;
 
@@ -519,24 +524,9 @@ struct gpio_desc *of_find_gpio(struct device *dev, const char *con_id,
 			break;
 	}
 
-	if (gpiod_not_found(desc)) {
-		/* Special handling for SPI GPIOs if used */
-		desc = of_find_spi_gpio(dev, con_id, idx, &of_flags);
-	}
-
-	if (gpiod_not_found(desc))
-		desc = of_find_spi_cs_gpio(dev, con_id, idx, &of_flags);
-
-	if (gpiod_not_found(desc)) {
-		/* Special handling for regulator GPIOs if used */
-		desc = of_find_regulator_gpio(dev, con_id, idx, &of_flags);
-	}
-
-	if (gpiod_not_found(desc))
-		desc = of_find_arizona_gpio(dev, con_id, idx, &of_flags);
-
-	if (gpiod_not_found(desc))
-		desc = of_find_usb_gpio(dev, con_id, idx, &of_flags);
+	/* Properly named GPIO was not found, try workarounds */
+	for (q = of_find_gpio_quirks; gpiod_not_found(desc) && *q; q++)
+		desc = (*q)(dev->of_node, con_id, idx, &of_flags);
 
 	if (IS_ERR(desc))
 		return desc;
-- 
2.35.1

