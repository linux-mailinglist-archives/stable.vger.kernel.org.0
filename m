Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AEC55FD019
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 02:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230459AbiJMAYg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 20:24:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230221AbiJMAXD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 20:23:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C04A26386;
        Wed, 12 Oct 2022 17:19:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2908EB81CBD;
        Thu, 13 Oct 2022 00:19:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25119C433C1;
        Thu, 13 Oct 2022 00:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620378;
        bh=pmWOWDJYR5SGomkgV//bEm7u1P1MRTxlvb6qhk2QzdI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BnoVQqcO1OtUHGVNWV/cabkeDstIz6bBJGvkxE9NuRfw5OH7qG8iVX0OhVX8sQdDu
         ehik3RTFAGYetgAaSIEqiH/rbA3qRzjxt3CZE9iOREFNyAjgXtfACVu/V6axVuaKh0
         +lzwfceNRW3RwUkjSk8SU/mze+CYsWFQB1n+yPbmNWFqJLGdn2dSZPOmpmQDesTsZd
         n6FCrt96QSPm4Y6LloYom2uEkhhZDfYe98/jRtLQX0Ucx2PgB9HxlqzKCEdetoobM3
         S+PTuWVsLg1I18Bub4Ks3qnn4lnzFvRA2fYY8uSPhVesgOanmzy2NnHxISXmyQsw5R
         7+rQpymbOURrQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 21/63] gpiolib: of: do not ignore requested index when applying quirks
Date:   Wed, 12 Oct 2022 20:17:55 -0400
Message-Id: <20221013001842.1893243-21-sashal@kernel.org>
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
index de100b0217da..b43c8bec24c2 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -369,7 +369,9 @@ EXPORT_SYMBOL_GPL(gpiod_get_from_of_node);
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
@@ -390,7 +392,7 @@ static struct gpio_desc *of_find_spi_gpio(struct device *dev, const char *con_id
 	/* Will be "gpio-sck", "gpio-mosi" or "gpio-miso" */
 	snprintf(prop_name, sizeof(prop_name), "%s-%s", "gpio", con_id);
 
-	desc = of_get_named_gpiod_flags(np, prop_name, 0, of_flags);
+	desc = of_get_named_gpiod_flags(np, prop_name, idx, of_flags);
 	return desc;
 }
 
@@ -431,7 +433,9 @@ static struct gpio_desc *of_find_spi_cs_gpio(struct device *dev,
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
@@ -454,12 +458,13 @@ static struct gpio_desc *of_find_regulator_gpio(struct device *dev, const char *
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
@@ -468,17 +473,18 @@ static struct gpio_desc *of_find_arizona_gpio(struct device *dev,
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
@@ -486,7 +492,7 @@ static struct gpio_desc *of_find_usb_gpio(struct device *dev,
 	if (!con_id || strcmp(con_id, "fcs,int_n"))
 		return ERR_PTR(-ENOENT);
 
-	return of_get_named_gpiod_flags(dev->of_node, con_id, 0, of_flags);
+	return of_get_named_gpiod_flags(dev->of_node, con_id, idx, of_flags);
 }
 
 struct gpio_desc *of_find_gpio(struct device *dev, const char *con_id,
@@ -515,7 +521,7 @@ struct gpio_desc *of_find_gpio(struct device *dev, const char *con_id,
 
 	if (gpiod_not_found(desc)) {
 		/* Special handling for SPI GPIOs if used */
-		desc = of_find_spi_gpio(dev, con_id, &of_flags);
+		desc = of_find_spi_gpio(dev, con_id, idx, &of_flags);
 	}
 
 	if (gpiod_not_found(desc)) {
@@ -527,14 +533,14 @@ struct gpio_desc *of_find_gpio(struct device *dev, const char *con_id,
 
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

