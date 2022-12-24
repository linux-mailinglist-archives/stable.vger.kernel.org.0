Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6056D6556E8
	for <lists+stable@lfdr.de>; Sat, 24 Dec 2022 02:29:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbiLXB3i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Dec 2022 20:29:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230458AbiLXB3h (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Dec 2022 20:29:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DE04558C;
        Fri, 23 Dec 2022 17:29:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8DFDD61FA3;
        Sat, 24 Dec 2022 01:29:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F721C433EF;
        Sat, 24 Dec 2022 01:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671845375;
        bh=hUSrTmXIKFW4331AhvpvM4KA6GeeVP8pSshLIOm5HNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YlX4Cb1ZVt5Ye7uxZWQuHOGbSACprAfbM6ZUldDqxx7uExnF/iIOBwdZKDERJKice
         ro6Q/UgK42pDAgYvRB5dpQCfNEpcG/d8zzFkIFxacu4N6zMcrdfiyiZ9zuBXwERRhE
         TXLfOx9EYkNd7NiHIsEGFJN8bXHDvEn7VjCdH8YjwCNY/8LCIxNfKNHsgdXsBvpuIC
         WITTG90laaAFq0PHqsFMnBnv05VMrvHLGGiwzJ1XR49ZnD/QM4hvoJ2iZC5Z+4CBbP
         Y4m9wd6yh5ajh8YiYTM4CROpalzZTNeG58SG750wLaB49Vy1fr0g2QY/ytwj8Bn2BU
         P6bkyeu9GmhTw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        Sasha Levin <sashal@kernel.org>, brgl@bgdev.pl,
        linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 02/26] gpiolib: of: consolidate simple renames into a single quirk
Date:   Fri, 23 Dec 2022 20:29:06 -0500
Message-Id: <20221224012930.392358-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221224012930.392358-1-sashal@kernel.org>
References: <20221224012930.392358-1-sashal@kernel.org>
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

[ Upstream commit b311c5cba779a87e85525d351965bbd2c18111de ]

This consolidates all quirks doing simple renames (either allowing
suffix-less names or trivial renames, when index changes are not
required) into a single quirk.

Reviewed-by: Daniel Thompson <daniel.thompson@linaro.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-of.c | 183 +++++++++++++++-----------------------
 1 file changed, 71 insertions(+), 112 deletions(-)

diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
index cef4f6634125..63c6fa3086f3 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -365,127 +365,90 @@ struct gpio_desc *gpiod_get_from_of_node(const struct device_node *node,
 }
 EXPORT_SYMBOL_GPL(gpiod_get_from_of_node);
 
-/*
- * The SPI GPIO bindings happened before we managed to establish that GPIO
- * properties should be named "foo-gpios" so we have this special kludge for
- * them.
- */
-static struct gpio_desc *of_find_spi_gpio(struct device_node *np,
-					  const char *con_id,
-					  unsigned int idx,
-					  enum of_gpio_flags *of_flags)
-{
-	char prop_name[32]; /* 32 is max size of property name */
-
-	/*
-	 * Hopefully the compiler stubs the rest of the function if this
-	 * is false.
-	 */
-	if (!IS_ENABLED(CONFIG_SPI_MASTER))
-		return ERR_PTR(-ENOENT);
-
-	/* Allow this specifically for "spi-gpio" devices */
-	if (!of_device_is_compatible(np, "spi-gpio") || !con_id)
-		return ERR_PTR(-ENOENT);
-
-	/* Will be "gpio-sck", "gpio-mosi" or "gpio-miso" */
-	snprintf(prop_name, sizeof(prop_name), "%s-%s", "gpio", con_id);
-
-	return of_get_named_gpiod_flags(np, prop_name, idx, of_flags);
-}
-
-/*
- * The old Freescale bindings use simply "gpios" as name for the chip select
- * lines rather than "cs-gpios" like all other SPI hardware. Account for this
- * with a special quirk.
- */
-static struct gpio_desc *of_find_spi_cs_gpio(struct device_node *np,
+static struct gpio_desc *of_find_gpio_rename(struct device_node *np,
 					     const char *con_id,
 					     unsigned int idx,
 					     enum of_gpio_flags *of_flags)
 {
-	if (!IS_ENABLED(CONFIG_SPI_MASTER))
-		return ERR_PTR(-ENOENT);
-
-	/* Allow this specifically for Freescale and PPC devices */
-	if (!of_device_is_compatible(np, "fsl,spi") &&
-	    !of_device_is_compatible(np, "aeroflexgaisler,spictrl") &&
-	    !of_device_is_compatible(np, "ibm,ppc4xx-spi"))
-		return ERR_PTR(-ENOENT);
-	/* Allow only if asking for "cs-gpios" */
-	if (!con_id || strcmp(con_id, "cs"))
-		return ERR_PTR(-ENOENT);
+	static const struct of_rename_gpio {
+		const char *con_id;
+		const char *legacy_id;	/* NULL - same as con_id */
+		/*
+		 * Compatible string can be set to NULL in case where
+		 * matching to a particular compatible is not practical,
+		 * but it should only be done for gpio names that have
+		 * vendor prefix to reduce risk of false positives.
+		 * Addition of such entries is strongly discouraged.
+		 */
+		const char *compatible;
+	} gpios[] = {
+#if IS_ENABLED(CONFIG_MFD_ARIZONA)
+		{ "wlf,reset",	NULL,		NULL },
+#endif
+#if IS_ENABLED(CONFIG_REGULATOR)
+		/*
+		 * Some regulator bindings happened before we managed to
+		 * establish that GPIO properties should be named
+		 * "foo-gpios" so we have this special kludge for them.
+		 */
+		{ "wlf,ldoena",  NULL,		NULL }, /* Arizona */
+		{ "wlf,ldo1ena", NULL,		NULL }, /* WM8994 */
+		{ "wlf,ldo2ena", NULL,		NULL }, /* WM8994 */
+#endif
+#if IS_ENABLED(CONFIG_SPI_MASTER)
 
-	/*
-	 * While all other SPI controllers use "cs-gpios" the Freescale
-	 * uses just "gpios" so translate to that when "cs-gpios" is
-	 * requested.
-	 */
-	return of_get_named_gpiod_flags(np, "gpios", idx, of_flags);
-}
+		/*
+		 * The SPI GPIO bindings happened before we managed to
+		 * establish that GPIO properties should be named
+		 * "foo-gpios" so we have this special kludge for them.
+		 */
+		{ "miso",	"gpio-miso",	"spi-gpio" },
+		{ "mosi",	"gpio-mosi",	"spi-gpio" },
+		{ "sck",	"gpio-sck",	"spi-gpio" },
 
-/*
- * Some regulator bindings happened before we managed to establish that GPIO
- * properties should be named "foo-gpios" so we have this special kludge for
- * them.
- */
-static struct gpio_desc *of_find_regulator_gpio(struct device_node *np,
-						const char *con_id,
-						unsigned int idx,
-						enum of_gpio_flags *of_flags)
-{
-	/* These are the connection IDs we accept as legacy GPIO phandles */
-	const char *whitelist[] = {
-		"wlf,ldoena", /* Arizona */
-		"wlf,ldo1ena", /* WM8994 */
-		"wlf,ldo2ena", /* WM8994 */
+		/*
+		 * The old Freescale bindings use simply "gpios" as name
+		 * for the chip select lines rather than "cs-gpios" like
+		 * all other SPI hardware. Allow this specifically for
+		 * Freescale and PPC devices.
+		 */
+		{ "cs",		"gpios",	"fsl,spi" },
+		{ "cs",		"gpios",	"aeroflexgaisler,spictrl" },
+		{ "cs",		"gpios",	"ibm,ppc4xx-spi" },
+#endif
+#if IS_ENABLED(CONFIG_TYPEC_FUSB302)
+		/*
+		 * Fairchild FUSB302 host is using undocumented "fcs,int_n"
+		 * property without the compulsory "-gpios" suffix.
+		 */
+		{ "fcs,int_n",	NULL,		"fcs,fusb302" },
+#endif
 	};
-	int i;
-
-	if (!IS_ENABLED(CONFIG_REGULATOR))
-		return ERR_PTR(-ENOENT);
+	struct gpio_desc *desc;
+	const char *legacy_id;
+	unsigned int i;
 
 	if (!con_id)
 		return ERR_PTR(-ENOENT);
 
-	i = match_string(whitelist, ARRAY_SIZE(whitelist), con_id);
-	if (i < 0)
-		return ERR_PTR(-ENOENT);
-
-	return of_get_named_gpiod_flags(np, con_id, idx, of_flags);
-}
-
-static struct gpio_desc *of_find_arizona_gpio(struct device_node *np,
-					      const char *con_id,
-					      unsigned int idx,
-					      enum of_gpio_flags *of_flags)
-{
-	if (!IS_ENABLED(CONFIG_MFD_ARIZONA))
-		return ERR_PTR(-ENOENT);
-
-	if (!con_id || strcmp(con_id, "wlf,reset"))
-		return ERR_PTR(-ENOENT);
-
-	return of_get_named_gpiod_flags(np, con_id, idx, of_flags);
-}
+	for (i = 0; i < ARRAY_SIZE(gpios); i++) {
+		if (strcmp(con_id, gpios[i].con_id))
+			continue;
 
-static struct gpio_desc *of_find_usb_gpio(struct device_node *np,
-					  const char *con_id,
-					  unsigned int idx,
-					  enum of_gpio_flags *of_flags)
-{
-	/*
-	 * Currently this USB quirk is only for the Fairchild FUSB302 host
-	 * which is using an undocumented DT GPIO line named "fcs,int_n"
-	 * without the compulsory "-gpios" suffix.
-	 */
-	if (!IS_ENABLED(CONFIG_TYPEC_FUSB302))
-		return ERR_PTR(-ENOENT);
+		if (gpios[i].compatible &&
+		    !of_device_is_compatible(np, gpios[i].compatible))
+			continue;
 
-	if (!con_id || strcmp(con_id, "fcs,int_n"))
-		return ERR_PTR(-ENOENT);
+		legacy_id = gpios[i].legacy_id ?: gpios[i].con_id;
+		desc = of_get_named_gpiod_flags(np, legacy_id, idx, of_flags);
+		if (!gpiod_not_found(desc)) {
+			pr_info("%s uses legacy gpio name '%s' instead of '%s-gpios'\n",
+				of_node_full_name(np), legacy_id, con_id);
+			return desc;
+		}
+	}
 
-	return of_get_named_gpiod_flags(np, con_id, idx, of_flags);
+	return ERR_PTR(-ENOENT);
 }
 
 static struct gpio_desc *of_find_mt2701_gpio(struct device_node *np,
@@ -525,11 +488,7 @@ typedef struct gpio_desc *(*of_find_gpio_quirk)(struct device_node *np,
 						unsigned int idx,
 						enum of_gpio_flags *of_flags);
 static const of_find_gpio_quirk of_find_gpio_quirks[] = {
-	of_find_spi_gpio,
-	of_find_spi_cs_gpio,
-	of_find_regulator_gpio,
-	of_find_arizona_gpio,
-	of_find_usb_gpio,
+	of_find_gpio_rename,
 	of_find_mt2701_gpio,
 	NULL
 };
-- 
2.35.1

