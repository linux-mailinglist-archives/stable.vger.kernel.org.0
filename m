Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29E7C6556EA
	for <lists+stable@lfdr.de>; Sat, 24 Dec 2022 02:29:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232401AbiLXB3j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Dec 2022 20:29:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231192AbiLXB3i (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Dec 2022 20:29:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8512BBE10;
        Fri, 23 Dec 2022 17:29:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D26661FA3;
        Sat, 24 Dec 2022 01:29:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 800EBC433F1;
        Sat, 24 Dec 2022 01:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671845376;
        bh=bPsOR11OZVIL37IPsgh68/1JSbEg6PvdNn0HBKzTsFU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VeX4KRo1QquAncjmxSrRdYXd+DYzj/aZvWl3ruuCRdYUnVt5PP15/lOPiiciupNlN
         TvIsUUW2o9BXNall6wU1nZG87InvOQvw5FiRulgQA086/W3/vd1Rwiqr7QZ6srL584
         OO+bp/piKBUY0toMmGNkPYjNe56hgwqIP4RuiU3cLX3BjwC4/X40BfGE1oycj2Y7UR
         55RZDYDhRVDq5TyAH6zLFdpAEgdSoF4cfaNneNRvMVzsnKJw5jamHFW18LEeHRYDWB
         wDYlzXmpOzupuk+Bo6RQCG4W8zNz/cDOyU8WRUwERkVfIrf7/Z/vFRJqmVdrcBFW/U
         gTc3fWuHakJFQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        Sasha Levin <sashal@kernel.org>, brgl@bgdev.pl,
        linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 03/26] gpiolib: of: tighten selection of gpio renaming quirks
Date:   Fri, 23 Dec 2022 20:29:07 -0500
Message-Id: <20221224012930.392358-3-sashal@kernel.org>
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

[ Upstream commit 307c593ba5f915e308fd23a2daae7e9a5209b604 ]

Tighten selection of legacy gpio renaming quirks so that they only
considered on more relevant configurations.

Suggested-by: Daniel Thompson <daniel.thompson@linaro.org>
Reviewed-by: Daniel Thompson <daniel.thompson@linaro.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-of.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
index 63c6fa3086f3..7d4bbf6484bc 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -385,18 +385,21 @@ static struct gpio_desc *of_find_gpio_rename(struct device_node *np,
 #if IS_ENABLED(CONFIG_MFD_ARIZONA)
 		{ "wlf,reset",	NULL,		NULL },
 #endif
-#if IS_ENABLED(CONFIG_REGULATOR)
+
 		/*
 		 * Some regulator bindings happened before we managed to
 		 * establish that GPIO properties should be named
 		 * "foo-gpios" so we have this special kludge for them.
 		 */
+#if IS_ENABLED(CONFIG_REGULATOR_ARIZONA_LDO1)
 		{ "wlf,ldoena",  NULL,		NULL }, /* Arizona */
+#endif
+#if IS_ENABLED(CONFIG_REGULATOR_WM8994)
 		{ "wlf,ldo1ena", NULL,		NULL }, /* WM8994 */
 		{ "wlf,ldo2ena", NULL,		NULL }, /* WM8994 */
 #endif
-#if IS_ENABLED(CONFIG_SPI_MASTER)
 
+#if IS_ENABLED(CONFIG_SPI_GPIO)
 		/*
 		 * The SPI GPIO bindings happened before we managed to
 		 * establish that GPIO properties should be named
@@ -405,6 +408,7 @@ static struct gpio_desc *of_find_gpio_rename(struct device_node *np,
 		{ "miso",	"gpio-miso",	"spi-gpio" },
 		{ "mosi",	"gpio-mosi",	"spi-gpio" },
 		{ "sck",	"gpio-sck",	"spi-gpio" },
+#endif
 
 		/*
 		 * The old Freescale bindings use simply "gpios" as name
@@ -412,10 +416,14 @@ static struct gpio_desc *of_find_gpio_rename(struct device_node *np,
 		 * all other SPI hardware. Allow this specifically for
 		 * Freescale and PPC devices.
 		 */
+#if IS_ENABLED(CONFIG_SPI_FSL_SPI)
 		{ "cs",		"gpios",	"fsl,spi" },
 		{ "cs",		"gpios",	"aeroflexgaisler,spictrl" },
+#endif
+#if IS_ENABLED(CONFIG_SPI_PPC4xx)
 		{ "cs",		"gpios",	"ibm,ppc4xx-spi" },
 #endif
+
 #if IS_ENABLED(CONFIG_TYPEC_FUSB302)
 		/*
 		 * Fairchild FUSB302 host is using undocumented "fcs,int_n"
-- 
2.35.1

