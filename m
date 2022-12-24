Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 101276556F2
	for <lists+stable@lfdr.de>; Sat, 24 Dec 2022 02:29:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233277AbiLXB3w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Dec 2022 20:29:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232495AbiLXB3l (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Dec 2022 20:29:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ADE8165B1;
        Fri, 23 Dec 2022 17:29:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0BF43B80A26;
        Sat, 24 Dec 2022 01:29:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDAE2C433EF;
        Sat, 24 Dec 2022 01:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671845377;
        bh=nQ3gqylzIAb0FxqjlgJvdP9xrDdNm7W917Iu9KRjr50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yvb/HLbyFXShDUWEUdMz2sci4dXSXif8ige/QwzQ4LvNZsIKPsm09Aa2bLB9Tnxih
         ihAKiXnmjYKPL7xizWaF4TmBMIhN4TgBrbwjF4w+odktY67ca7ADTeseig3Pa02sak
         Bpd198MU+6GU/QA3ZvtVZH6V/XR+J87tJarGq42MMMV7UOcycERzSUD57VECfFfT1q
         WjOL8UzsTFlM+9o8b56asOyfF9T2t5ovJ5KiXPQmbQ/Ww3ghdXh9WFQUv0EjHGd6Zx
         z23IRzggjmWl6FzkQjTiTkOuWu6BevPCmPdHcSop2k4fFe+V7G6Ljt43DJxpALjPgr
         fyDHQqKh5V+5w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        Sasha Levin <sashal@kernel.org>, brgl@bgdev.pl,
        linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 04/26] gpiolib: of: add quirk for locating reset lines with legacy bindings
Date:   Fri, 23 Dec 2022 20:29:08 -0500
Message-Id: <20221224012930.392358-4-sashal@kernel.org>
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

[ Upstream commit fbbbcd177a27508a47c5136b31de5cf4c8d0ab1c ]

Some legacy mappings used "gpio[s]-reset" instead of "reset-gpios",
add a quirk so that gpiod API will still work on unmodified DTSes.

Reviewed-by: Daniel Thompson <daniel.thompson@linaro.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-of.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
index 7d4bbf6484bc..2b5d1b3095c7 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -382,9 +382,18 @@ static struct gpio_desc *of_find_gpio_rename(struct device_node *np,
 		 */
 		const char *compatible;
 	} gpios[] = {
+#if !IS_ENABLED(CONFIG_LCD_HX8357)
+		/* Himax LCD controllers used "gpios-reset" */
+		{ "reset",	"gpios-reset",	"himax,hx8357" },
+		{ "reset",	"gpios-reset",	"himax,hx8369" },
+#endif
 #if IS_ENABLED(CONFIG_MFD_ARIZONA)
 		{ "wlf,reset",	NULL,		NULL },
 #endif
+#if !IS_ENABLED(CONFIG_PCI_LANTIQ)
+		/* MIPS Lantiq PCI */
+		{ "reset",	"gpios-reset",	"lantiq,pci-xway" },
+#endif
 
 		/*
 		 * Some regulator bindings happened before we managed to
@@ -399,6 +408,13 @@ static struct gpio_desc *of_find_gpio_rename(struct device_node *np,
 		{ "wlf,ldo2ena", NULL,		NULL }, /* WM8994 */
 #endif
 
+#if IS_ENABLED(CONFIG_SND_SOC_TLV320AIC3X)
+		{ "reset",	"gpio-reset",	"ti,tlv320aic3x" },
+		{ "reset",	"gpio-reset",	"ti,tlv320aic33" },
+		{ "reset",	"gpio-reset",	"ti,tlv320aic3007" },
+		{ "reset",	"gpio-reset",	"ti,tlv320aic3104" },
+		{ "reset",	"gpio-reset",	"ti,tlv320aic3106" },
+#endif
 #if IS_ENABLED(CONFIG_SPI_GPIO)
 		/*
 		 * The SPI GPIO bindings happened before we managed to
-- 
2.35.1

