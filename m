Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7399E6556F3
	for <lists+stable@lfdr.de>; Sat, 24 Dec 2022 02:29:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232783AbiLXB3x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Dec 2022 20:29:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232881AbiLXB3n (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Dec 2022 20:29:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFE3A1705E;
        Fri, 23 Dec 2022 17:29:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7957A61FAB;
        Sat, 24 Dec 2022 01:29:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14F0DC433F2;
        Sat, 24 Dec 2022 01:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671845381;
        bh=IAks9GWBJ69lvrtruKdzo2aohCxAvyK28p6EhgBP8Bg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EqA2zXbEgawhIZf8GbOzC+ikB7a8RswVGiUKtfAxUMTnOEkNUrLSIIUKvJtko33th
         af9pyNbKKJBtpX5YWEkWjYwfQJepYJ9utoJ5XGEMtBZdvZX+OztiU6qwUprOhlIPkJ
         LZDpNOV4XqepzHDrN/1L54X6VJIOfRY/fYTt/zTR2OpwfbWPOeUGSirWGomLyGE5f3
         8j2cgOe8RctH51LP0I+6bXCfKdOna9GLx+Oklm7gGI71tsPx/LAaponOdmPecSqFg9
         S7EBAVhkOLWUtlcdzybTXgOrnOZe6hLVIHVr3AVaqQZQT8wmg/R1D3VxD9IbL8BM0w
         voIfKw9vaSgIA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linus.walleij@linaro.org,
        brgl@bgdev.pl, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 07/26] gpiolib: of: add a quirk for legacy names in MOXA ART RTC
Date:   Fri, 23 Dec 2022 20:29:11 -0500
Message-Id: <20221224012930.392358-7-sashal@kernel.org>
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

[ Upstream commit eaf1a29665cda1c767cac0d523828892bd77a842 ]

The driver is using non-standard "gpio-rtc-data", "gpio-rtc-sclk", and
"gpio-rtc-reset" names for properties describing its gpios. In
preparation to converting to the standard naming ("rtc-*-gpios") and
switching the driver to gpiod API add a quirk to gpiolib to keep
compatibility with existing DTSes.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-of.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
index ffdbac2eeaa6..d22498c72a67 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -390,6 +390,11 @@ static struct gpio_desc *of_find_gpio_rename(struct device_node *np,
 #if IS_ENABLED(CONFIG_MFD_ARIZONA)
 		{ "wlf,reset",	NULL,		NULL },
 #endif
+#if IS_ENABLED(CONFIG_RTC_DRV_MOXART)
+		{ "rtc-data",	"gpio-rtc-data",	"moxa,moxart-rtc" },
+		{ "rtc-sclk",	"gpio-rtc-sclk",	"moxa,moxart-rtc" },
+		{ "rtc-reset",	"gpio-rtc-reset",	"moxa,moxart-rtc" },
+#endif
 #if IS_ENABLED(CONFIG_NFC_MRVL_I2C)
 		{ "reset",	"reset-n-io",	"marvell,nfc-i2c" },
 #endif
-- 
2.35.1

