Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4059C35AFC8
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 20:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235027AbhDJSzN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Apr 2021 14:55:13 -0400
Received: from out28-173.mail.aliyun.com ([115.124.28.173]:34185 "EHLO
        out28-173.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234997AbhDJSzL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Apr 2021 14:55:11 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.1303128|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.0547366-0.000210722-0.945053;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047204;MF=zhouyanjie@wanyeetech.com;NM=1;PH=DS;RN=15;RT=15;SR=0;TI=SMTPD_---.Jy13RN2_1618080886;
Received: from zhouyanjie-virtual-machine.localdomain(mailfrom:zhouyanjie@wanyeetech.com fp:SMTPD_---.Jy13RN2_1618080886)
          by smtp.aliyun-inc.com(10.147.42.241);
          Sun, 11 Apr 2021 02:54:53 +0800
From:   =?UTF-8?q?=E5=91=A8=E7=90=B0=E6=9D=B0=20=28Zhou=20Yanjie=29?= 
        <zhouyanjie@wanyeetech.com>
To:     linus.walleij@linaro.org, robh+dt@kernel.org, paul@crapouillou.net
Cc:     linux-gpio@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        hns@goldelico.com, paul@boddie.org.uk, andy.shevchenko@gmail.com,
        dongsheng.qiu@ingenic.com, aric.pzqi@ingenic.com,
        rick.tyliu@ingenic.com, sernia.zhou@foxmail.com,
        stable@vger.kernel.org
Subject: [PATCH v4 02/11] pinctrl: Ingenic: Add support for read the pin configuration of X1830.
Date:   Sun, 11 Apr 2021 02:54:37 +0800
Message-Id: <1618080886-32061-3-git-send-email-zhouyanjie@wanyeetech.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1618080886-32061-1-git-send-email-zhouyanjie@wanyeetech.com>
References: <1618080886-32061-1-git-send-email-zhouyanjie@wanyeetech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Add X1830 support in "ingenic_pinconf_get()", so that it can read the
configuration of X1830 SoC correctly.

Fixes: d7da2a1e4e08 ("pinctrl: Ingenic: Add pinctrl driver for X1830.")
Cc: <stable@vger.kernel.org>
Signed-off-by: 周琰杰 (Zhou Yanjie) <zhouyanjie@wanyeetech.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Paul Cercueil <paul@crapouillou.net>
---

Notes:
    v2:
    New patch.
    
    v2->v3:
    1.Add fixes tag.
    2.Adjust the code, simplify the ingenic_pinconf_get() function.
    
    v3->v4:
    1.Add parentheses around the '%' to make it more obvious.
    2.Add Cc: <stable@vger.kernel.org>.
    3.Add Andy Shevchenko's Reviewed-by.
    4.Add Paul Cercueil's Reviewed-by.

 drivers/pinctrl/pinctrl-ingenic.c | 40 ++++++++++++++++++++++++++++++---------
 1 file changed, 31 insertions(+), 9 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-ingenic.c b/drivers/pinctrl/pinctrl-ingenic.c
index 05dfa0a..3de0f76 100644
--- a/drivers/pinctrl/pinctrl-ingenic.c
+++ b/drivers/pinctrl/pinctrl-ingenic.c
@@ -2109,26 +2109,48 @@ static int ingenic_pinconf_get(struct pinctrl_dev *pctldev,
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
 
@@ -2146,7 +2168,7 @@ static void ingenic_set_bias(struct ingenic_pinctrl *jzpc,
 	if (jzpc->info->version >= ID_X1830) {
 		unsigned int idx = pin % PINS_PER_GPIO_CHIP;
 		unsigned int half = PINS_PER_GPIO_CHIP / 2;
-		unsigned int idxh = pin % half * 2;
+		unsigned int idxh = (pin % half) * 2;
 		unsigned int offt = pin / PINS_PER_GPIO_CHIP;
 
 		if (idx < half) {
-- 
2.7.4

