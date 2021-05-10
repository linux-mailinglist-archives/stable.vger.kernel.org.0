Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC43B378716
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233768AbhEJLNd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:13:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:46208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235941AbhEJLHB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:07:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C18561878;
        Mon, 10 May 2021 10:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644225;
        bh=hiZcWMCdWSw6/FErK8cQnJktIXVnvcHwqbLoqb+Di6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sy4wqwAcfjxw49oMj5mrPegkQIIXUflP9gMV69nNnGYVhVPnK9tH1WQOwjZ1/g/DW
         wrXQ426lMQctyW/EwXazIdNUoYuRqQL6efaRfTMDET6U64Cbleytno04hPnUs/J8YR
         310H4ET51w2FKG8WSXKrhv4DDjGiSjMLSLUV90jE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?=E5=91=A8=E7=90=B0=E6=9D=B0=20 ?= 
        <zhouyanjie@wanyeetech.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Paul Cercueil <paul@crapouillou.net>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.11 339/342] pinctrl: Ingenic: Add support for read the pin configuration of X1830.
Date:   Mon, 10 May 2021 12:22:09 +0200
Message-Id: <20210510102021.308541433@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: 周琰杰 (Zhou Yanjie) <zhouyanjie@wanyeetech.com>

commit 1d0bd580ef83b78a10c0b37f3313eaa59d8c80db upstream.

Add X1830 support in "ingenic_pinconf_get()", so that it can read the
configuration of X1830 SoC correctly.

Fixes: d7da2a1e4e08 ("pinctrl: Ingenic: Add pinctrl driver for X1830.")
Cc: <stable@vger.kernel.org>
Signed-off-by: 周琰杰 (Zhou Yanjie) <zhouyanjie@wanyeetech.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Paul Cercueil <paul@crapouillou.net>
Link: https://lore.kernel.org/r/1618757073-1724-3-git-send-email-zhouyanjie@wanyeetech.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/pinctrl-ingenic.c |   40 +++++++++++++++++++++++++++++---------
 1 file changed, 31 insertions(+), 9 deletions(-)

--- a/drivers/pinctrl/pinctrl-ingenic.c
+++ b/drivers/pinctrl/pinctrl-ingenic.c
@@ -2089,26 +2089,48 @@ static int ingenic_pinconf_get(struct pi
 	enum pin_config_param param = pinconf_to_config_param(*config);
 	unsigned int idx = pin % PINS_PER_GPIO_CHIP;
 	unsigned int offt = pin / PINS_PER_GPIO_CHIP;
-	bool pull;
+	unsigned int bias;
+	bool pull, pullup, pulldown;
 
-	if (jzpc->info->version >= ID_JZ4770)
-		pull = !ingenic_get_pin_config(jzpc, pin, JZ4770_GPIO_PEN);
-	else
-		pull = !ingenic_get_pin_config(jzpc, pin, JZ4740_GPIO_PULL_DIS);
+	if (jzpc->info->version >= ID_X1830) {
+		unsigned int half = PINS_PER_GPIO_CHIP / 2;
+		unsigned int idxh = (pin % half) * 2;
+
+		if (idx < half)
+			regmap_read(jzpc->map, offt * jzpc->info->reg_offset +
+					X1830_GPIO_PEL, &bias);
+		else
+			regmap_read(jzpc->map, offt * jzpc->info->reg_offset +
+					X1830_GPIO_PEH, &bias);
+
+		bias = (bias >> idxh) & (GPIO_PULL_UP | GPIO_PULL_DOWN);
+
+		pullup = (bias == GPIO_PULL_UP) && (jzpc->info->pull_ups[offt] & BIT(idx));
+		pulldown = (bias == GPIO_PULL_DOWN) && (jzpc->info->pull_downs[offt] & BIT(idx));
+
+	} else {
+		if (jzpc->info->version >= ID_JZ4770)
+			pull = !ingenic_get_pin_config(jzpc, pin, JZ4770_GPIO_PEN);
+		else
+			pull = !ingenic_get_pin_config(jzpc, pin, JZ4740_GPIO_PULL_DIS);
+
+		pullup = pull && (jzpc->info->pull_ups[offt] & BIT(idx));
+		pulldown = pull && (jzpc->info->pull_downs[offt] & BIT(idx));
+	}
 
 	switch (param) {
 	case PIN_CONFIG_BIAS_DISABLE:
-		if (pull)
+		if (pullup || pulldown)
 			return -EINVAL;
 		break;
 
 	case PIN_CONFIG_BIAS_PULL_UP:
-		if (!pull || !(jzpc->info->pull_ups[offt] & BIT(idx)))
+		if (!pullup)
 			return -EINVAL;
 		break;
 
 	case PIN_CONFIG_BIAS_PULL_DOWN:
-		if (!pull || !(jzpc->info->pull_downs[offt] & BIT(idx)))
+		if (!pulldown)
 			return -EINVAL;
 		break;
 
@@ -2126,7 +2148,7 @@ static void ingenic_set_bias(struct inge
 	if (jzpc->info->version >= ID_X1830) {
 		unsigned int idx = pin % PINS_PER_GPIO_CHIP;
 		unsigned int half = PINS_PER_GPIO_CHIP / 2;
-		unsigned int idxh = pin % half * 2;
+		unsigned int idxh = (pin % half) * 2;
 		unsigned int offt = pin / PINS_PER_GPIO_CHIP;
 
 		if (idx < half) {


