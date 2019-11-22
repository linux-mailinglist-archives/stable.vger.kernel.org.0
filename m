Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0AD4106CC3
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728882AbfKVKyp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:54:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:40606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730359AbfKVKyo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:54:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE83820706;
        Fri, 22 Nov 2019 10:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420083;
        bh=dGEC+nqkPb1i9AgxpXOdAXvdLV5Tx+gdoEhw72xa2Qo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=snC3ioPRpPydJOIQMlfreeKAs9g150HhEECkDdsX+etNKpbAk9TwjrgOqkSUkFj32
         xvnKwOGko+tTS1oHLMAL7Eorva02X8pvnJr3doReDfto4DVTw4xpG9lLcav29QiU7V
         CzjfvWMAjsBtSQi3nvhIeHcton+8sJnbcJ/OK6Jw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 109/122] pinctrl: gemini: Fix up TVC clock group
Date:   Fri, 22 Nov 2019 11:29:22 +0100
Message-Id: <20191122100833.536604851@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100722.177052205@linuxfoundation.org>
References: <20191122100722.177052205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit a85c928f6a7856a09e47d9b37faa3407c7ac6a8e ]

The previous fix made the TVC clock get muxed in on the
D-Link DIR-685 instead of giving nagging warnings of this
not working. Not good. We didn't want that, as it breaks
video.

Create a specific group for the TVC CLK, and break out
a specific GPIO group for it on the SL3516 so we can use
that line as GPIO if we don't need the TVC CLK.

Fixes: d17f477c5bc6 ("pinctrl: gemini: Mask and set properly")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-gemini.c | 44 ++++++++++++++++++++++++++------
 1 file changed, 36 insertions(+), 8 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-gemini.c b/drivers/pinctrl/pinctrl-gemini.c
index 05441dc2519d2..78fa26c1a89f3 100644
--- a/drivers/pinctrl/pinctrl-gemini.c
+++ b/drivers/pinctrl/pinctrl-gemini.c
@@ -551,13 +551,16 @@ static const unsigned int tvc_3512_pins[] = {
 	319, /* TVC_DATA[1] */
 	301, /* TVC_DATA[2] */
 	283, /* TVC_DATA[3] */
-	265, /* TVC_CLK */
 	320, /* TVC_DATA[4] */
 	302, /* TVC_DATA[5] */
 	284, /* TVC_DATA[6] */
 	266, /* TVC_DATA[7] */
 };
 
+static const unsigned int tvc_clk_3512_pins[] = {
+	265, /* TVC_CLK */
+};
+
 /* NAND flash pins */
 static const unsigned int nflash_3512_pins[] = {
 	199, 200, 201, 202, 216, 217, 218, 219, 220, 234, 235, 236, 237, 252,
@@ -589,7 +592,7 @@ static const unsigned int pflash_3512_pins_extended[] = {
 /* Serial flash pins CE0, CE1, DI, DO, CK */
 static const unsigned int sflash_3512_pins[] = { 230, 231, 232, 233, 211 };
 
-/* The GPIO0A (0) pin overlap with TVC and extended parallel flash */
+/* The GPIO0A (0) pin overlap with TVC CLK and extended parallel flash */
 static const unsigned int gpio0a_3512_pins[] = { 265 };
 
 /* The GPIO0B (1-4) pins overlap with TVC and ICE */
@@ -772,7 +775,13 @@ static const struct gemini_pin_group gemini_3512_pin_groups[] = {
 		.num_pins = ARRAY_SIZE(tvc_3512_pins),
 		/* Conflict with character LCD and ICE */
 		.mask = LCD_PADS_ENABLE,
-		.value = TVC_PADS_ENABLE | TVC_CLK_PAD_ENABLE,
+		.value = TVC_PADS_ENABLE,
+	},
+	{
+		.name = "tvcclkgrp",
+		.pins = tvc_clk_3512_pins,
+		.num_pins = ARRAY_SIZE(tvc_clk_3512_pins),
+		.value = TVC_CLK_PAD_ENABLE,
 	},
 	/*
 	 * The construction is done such that it is possible to use a serial
@@ -809,8 +818,8 @@ static const struct gemini_pin_group gemini_3512_pin_groups[] = {
 		.name = "gpio0agrp",
 		.pins = gpio0a_3512_pins,
 		.num_pins = ARRAY_SIZE(gpio0a_3512_pins),
-		/* Conflict with TVC */
-		.mask = TVC_PADS_ENABLE,
+		/* Conflict with TVC CLK */
+		.mask = TVC_CLK_PAD_ENABLE,
 	},
 	{
 		.name = "gpio0bgrp",
@@ -1476,13 +1485,16 @@ static const unsigned int tvc_3516_pins[] = {
 	311, /* TVC_DATA[1] */
 	394, /* TVC_DATA[2] */
 	374, /* TVC_DATA[3] */
-	333, /* TVC_CLK */
 	354, /* TVC_DATA[4] */
 	395, /* TVC_DATA[5] */
 	312, /* TVC_DATA[6] */
 	334, /* TVC_DATA[7] */
 };
 
+static const unsigned int tvc_clk_3516_pins[] = {
+	333, /* TVC_CLK */
+};
+
 /* NAND flash pins */
 static const unsigned int nflash_3516_pins[] = {
 	243, 260, 261, 224, 280, 262, 281, 264, 300, 263, 282, 301, 320, 283,
@@ -1515,7 +1527,7 @@ static const unsigned int pflash_3516_pins_extended[] = {
 static const unsigned int sflash_3516_pins[] = { 296, 338, 295, 359, 339 };
 
 /* The GPIO0A (0-4) pins overlap with TVC and extended parallel flash */
-static const unsigned int gpio0a_3516_pins[] = { 333, 354, 395, 312, 334 };
+static const unsigned int gpio0a_3516_pins[] = { 354, 395, 312, 334 };
 
 /* The GPIO0B (5-7) pins overlap with ICE */
 static const unsigned int gpio0b_3516_pins[] = { 375, 396, 376 };
@@ -1547,6 +1559,9 @@ static const unsigned int gpio0j_3516_pins[] = { 359, 339 };
 /* The GPIO0K (30,31) pins overlap with NAND flash */
 static const unsigned int gpio0k_3516_pins[] = { 275, 298 };
 
+/* The GPIO0L (0) pins overlap with TVC_CLK */
+static const unsigned int gpio0l_3516_pins[] = { 333 };
+
 /* The GPIO1A (0-4) pins that overlap with IDE and parallel flash */
 static const unsigned int gpio1a_3516_pins[] = { 221, 200, 222, 201, 220 };
 
@@ -1693,7 +1708,13 @@ static const struct gemini_pin_group gemini_3516_pin_groups[] = {
 		.num_pins = ARRAY_SIZE(tvc_3516_pins),
 		/* Conflict with character LCD */
 		.mask = LCD_PADS_ENABLE,
-		.value = TVC_PADS_ENABLE | TVC_CLK_PAD_ENABLE,
+		.value = TVC_PADS_ENABLE,
+	},
+	{
+		.name = "tvcclkgrp",
+		.pins = tvc_clk_3516_pins,
+		.num_pins = ARRAY_SIZE(tvc_clk_3516_pins),
+		.value = TVC_CLK_PAD_ENABLE,
 	},
 	/*
 	 * The construction is done such that it is possible to use a serial
@@ -1804,6 +1825,13 @@ static const struct gemini_pin_group gemini_3516_pin_groups[] = {
 		/* Conflict with parallel and NAND flash */
 		.value = PFLASH_PADS_DISABLE | NAND_PADS_DISABLE,
 	},
+	{
+		.name = "gpio0lgrp",
+		.pins = gpio0l_3516_pins,
+		.num_pins = ARRAY_SIZE(gpio0l_3516_pins),
+		/* Conflict with TVE CLK */
+		.mask = TVC_CLK_PAD_ENABLE,
+	},
 	{
 		.name = "gpio1agrp",
 		.pins = gpio1a_3516_pins,
-- 
2.20.1



