Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BBA75FCF87
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 02:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbiJMATI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 20:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbiJMASK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 20:18:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 338D4142CA5;
        Wed, 12 Oct 2022 17:17:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 11552616BF;
        Thu, 13 Oct 2022 00:16:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9D54C4347C;
        Thu, 13 Oct 2022 00:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620208;
        bh=d6jkjASgVXAkl7lBTVsKdA2WsoOOWJ4LdlNvP17lzg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fxKp0yabJpa4m66lLp2gF1fscXniUq+XwxO4+0InVEbggbQEYsW1Ff7zs7zugu1iy
         alR2x2barGHNwUM18xLiISmFrUMSls696INeGIExaWWn8xMVMiVlSar1q4xRuXP1gj
         E+OHYbL0fKxFjmQ/3gSa6YVCI8yA+zdjcOcFNqnmJN04gRSYW8ig+QJgtSMjuat202
         MJbJ3y2Ax0rdgfKgOBhWQL5pf3A2oK/k0lubEyT2X+BmeXjzwjbaVsC/zhZE8ATPby
         GdxDczrEtZ4le6PWJj6VM2ZdUI7LV7t2zq57zFSipMfOOXBI7g07fFC7cd/0LDpk4p
         VY0uRpUqgKODg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 21/67] gpiolib: of: do not ignore requested index when applying quirks
Date:   Wed, 12 Oct 2022 20:15:02 -0400
Message-Id: <20221013001554.1892206-21-sashal@kernel.org>
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

[ Upstream commit 98c3c940ea5c3957056717e8b77a91c7d94536ad ]

We should not ignore index passed into of_find_gpio() when handling
quirks. While in practice this change will not have any effect, it
will allow consolidate quirk handling.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-of.c | 32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
index a037b50bef33..c08564948bf9 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -372,7 +372,9 @@ EXPORT_SYMBOL_GPL(gpiod_get_from_of_node);
  * properties should be named "foo-gpios" so we have this special kludge for
  * them.
  */
-static struct gpio_desc *of_find_spi_gpio(struct device *dev, const char *con_id,
+static struct gpio_desc *of_find_spi_gpio(struct device *dev,
+					  const char *con_id,
+					  unsigned int idx,
 					  enum of_gpio_flags *of_flags)
 {
 	char prop_name[32]; /* 32 is max size of property name */
@@ -393,7 +395,7 @@ static struct gpio_desc *of_find_spi_gpio(struct device *dev, const char *con_id
 	/* Will be "gpio-sck", "gpio-mosi" or "gpio-miso" */
 	snprintf(prop_name, sizeof(prop_name), "%s-%s", "gpio", con_id);
 
-	desc = of_get_named_gpiod_flags(np, prop_name, 0, of_flags);
+	desc = of_get_named_gpiod_flags(np, prop_name, idx, of_flags);
 	return desc;
 }
 
@@ -434,7 +436,9 @@ static struct gpio_desc *of_find_spi_cs_gpio(struct device *dev,
  * properties should be named "foo-gpios" so we have this special kludge for
  * them.
  */
-static struct gpio_desc *of_find_regulator_gpio(struct device *dev, const char *con_id,
+static struct gpio_desc *of_find_regulator_gpio(struct device *dev,
+						const char *con_id,
+						unsigned int idx,
 						enum of_gpio_flags *of_flags)
 {
 	/* These are the connection IDs we accept as legacy GPIO phandles */
@@ -457,12 +461,13 @@ static struct gpio_desc *of_find_regulator_gpio(struct device *dev, const char *
 	if (i < 0)
 		return ERR_PTR(-ENOENT);
 
-	desc = of_get_named_gpiod_flags(np, con_id, 0, of_flags);
+	desc = of_get_named_gpiod_flags(np, con_id, idx, of_flags);
 	return desc;
 }
 
 static struct gpio_desc *of_find_arizona_gpio(struct device *dev,
 					      const char *con_id,
+					      unsigned int idx,
 					      enum of_gpio_flags *of_flags)
 {
 	if (!IS_ENABLED(CONFIG_MFD_ARIZONA))
@@ -471,17 +476,18 @@ static struct gpio_desc *of_find_arizona_gpio(struct device *dev,
 	if (!con_id || strcmp(con_id, "wlf,reset"))
 		return ERR_PTR(-ENOENT);
 
-	return of_get_named_gpiod_flags(dev->of_node, con_id, 0, of_flags);
+	return of_get_named_gpiod_flags(dev->of_node, con_id, idx, of_flags);
 }
 
 static struct gpio_desc *of_find_usb_gpio(struct device *dev,
 					  const char *con_id,
+					  unsigned int idx,
 					  enum of_gpio_flags *of_flags)
 {
 	/*
-	 * Currently this USB quirk is only for the Fairchild FUSB302 host which is using
-	 * an undocumented DT GPIO line named "fcs,int_n" without the compulsory "-gpios"
-	 * suffix.
+	 * Currently this USB quirk is only for the Fairchild FUSB302 host
+	 * which is using an undocumented DT GPIO line named "fcs,int_n"
+	 * without the compulsory "-gpios" suffix.
 	 */
 	if (!IS_ENABLED(CONFIG_TYPEC_FUSB302))
 		return ERR_PTR(-ENOENT);
@@ -489,7 +495,7 @@ static struct gpio_desc *of_find_usb_gpio(struct device *dev,
 	if (!con_id || strcmp(con_id, "fcs,int_n"))
 		return ERR_PTR(-ENOENT);
 
-	return of_get_named_gpiod_flags(dev->of_node, con_id, 0, of_flags);
+	return of_get_named_gpiod_flags(dev->of_node, con_id, idx, of_flags);
 }
 
 struct gpio_desc *of_find_gpio(struct device *dev, const char *con_id,
@@ -518,7 +524,7 @@ struct gpio_desc *of_find_gpio(struct device *dev, const char *con_id,
 
 	if (gpiod_not_found(desc)) {
 		/* Special handling for SPI GPIOs if used */
-		desc = of_find_spi_gpio(dev, con_id, &of_flags);
+		desc = of_find_spi_gpio(dev, con_id, idx, &of_flags);
 	}
 
 	if (gpiod_not_found(desc)) {
@@ -530,14 +536,14 @@ struct gpio_desc *of_find_gpio(struct device *dev, const char *con_id,
 
 	if (gpiod_not_found(desc)) {
 		/* Special handling for regulator GPIOs if used */
-		desc = of_find_regulator_gpio(dev, con_id, &of_flags);
+		desc = of_find_regulator_gpio(dev, con_id, idx, &of_flags);
 	}
 
 	if (gpiod_not_found(desc))
-		desc = of_find_arizona_gpio(dev, con_id, &of_flags);
+		desc = of_find_arizona_gpio(dev, con_id, idx, &of_flags);
 
 	if (gpiod_not_found(desc))
-		desc = of_find_usb_gpio(dev, con_id, &of_flags);
+		desc = of_find_usb_gpio(dev, con_id, idx, &of_flags);
 
 	if (IS_ERR(desc))
 		return desc;
-- 
2.35.1

