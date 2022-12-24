Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B59686556EE
	for <lists+stable@lfdr.de>; Sat, 24 Dec 2022 02:29:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232748AbiLXB3l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Dec 2022 20:29:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232624AbiLXB3k (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Dec 2022 20:29:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32772165AB;
        Fri, 23 Dec 2022 17:29:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF75961EF2;
        Sat, 24 Dec 2022 01:29:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A194C433F0;
        Sat, 24 Dec 2022 01:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671845379;
        bh=Xvy8sH+o6FVAqnqZgRVxOGN9pNBp/CXiiIJpqdZMAYQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qljJv27nbd3FzvkDo43nKpF/MN4jnPYv73y6Nt//Q97Y99LYMw+AL4HpK+x96j//L
         vAM5W9K0wqJbuk2Viw6QTlONFAH4RaKzmB2mF5N0rXpwEUITuqRt8Dw5ZBMN8U8M9c
         td57+OO8XZ4WqOrbr5E/NWsvcL6Ywa3CrYb21ZXWlXdUHrUnmqx/c1gMuZWE3Ebezz
         rqYl/SqeLESvIFCqDAxxejD65POs4S5AUxUap2DJjoFy+WRnQntY2+sECZIK8SAf3D
         uuG+ieo40z2pBhTpIChR8bZxtm5cL8eaLMo0g99+Rz7k1o3n7YCEzKxXn+94qQ8RYR
         Z00/c3t8pjVAQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linus.walleij@linaro.org,
        brgl@bgdev.pl, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 05/26] gpiolib: of: add a quirk for reset line for Marvell NFC controller
Date:   Fri, 23 Dec 2022 20:29:09 -0500
Message-Id: <20221224012930.392358-5-sashal@kernel.org>
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

[ Upstream commit 9c2cc7171e08eef52110d272fdf2225d6dcd81b6 ]

The controller is using non-standard "reset-n-io" name for its reset
gpio property, whereas gpiod API expects "<name>-gpios". Add a quirk
so that gpiod API will still work on unmodified DTSes.

Reviewed-by: Daniel Thompson <daniel.thompson@linaro.org>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-of.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
index 2b5d1b3095c7..a9cedc39a245 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -390,6 +390,16 @@ static struct gpio_desc *of_find_gpio_rename(struct device_node *np,
 #if IS_ENABLED(CONFIG_MFD_ARIZONA)
 		{ "wlf,reset",	NULL,		NULL },
 #endif
+#if IS_ENABLED(CONFIG_NFC_MRVL_I2C)
+		{ "reset",	"reset-n-io",	"marvell,nfc-i2c" },
+#endif
+#if IS_ENABLED(CONFIG_NFC_MRVL_SPI)
+		{ "reset",	"reset-n-io",	"marvell,nfc-spi" },
+#endif
+#if IS_ENABLED(CONFIG_NFC_MRVL_UART)
+		{ "reset",	"reset-n-io",	"marvell,nfc-uart" },
+		{ "reset",	"reset-n-io",	"mrvl,nfc-uart" },
+#endif
 #if !IS_ENABLED(CONFIG_PCI_LANTIQ)
 		/* MIPS Lantiq PCI */
 		{ "reset",	"gpios-reset",	"lantiq,pci-xway" },
-- 
2.35.1

