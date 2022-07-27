Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA87583035
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237698AbiG0RfH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:35:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237827AbiG0ReI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:34:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 000EC82F97;
        Wed, 27 Jul 2022 09:48:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3EBE7B821D4;
        Wed, 27 Jul 2022 16:48:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90834C43140;
        Wed, 27 Jul 2022 16:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940534;
        bh=y453DtRhy183YpSqmE6b9Z4EHubiK9dU8CyYUEyJbTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VWvTySu3UVYnrSgft7JzSsUfa1a4DhFbUFNUsxAy6xoSr5IcChMP2Xv5WrdvkiCGI
         fam4RfFSXXgjGP1d9PCabO7+3AQHk6mxcslq70OKjq0SytK8QXlHytQJ0xpjmtqydK
         2M+rjJ33gueOR++QSVq8weeTTnEDn1YqJt3tprJk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 057/158] pinctrl: ocelot: Fix pincfg for lan966x
Date:   Wed, 27 Jul 2022 18:12:01 +0200
Message-Id: <20220727161023.795967960@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Horatiu Vultur <horatiu.vultur@microchip.com>

[ Upstream commit dc62db7138aa9365480254dda4c3e1316b1b1bbc ]

The blamed commit introduce support for lan966x which use the same
pinconf_ops as sparx5. The problem is that pinconf_ops is specific to
sparx5. More precisely the offset of the bits in the pincfg register are
different and also lan966x doesn't have support for
PIN_CONFIG_INPUT_SCHMITT_ENABLE.

Fix this by making pinconf_ops more generic such that it can be also
used by lan966x. This is done by introducing 'ocelot_pincfg_data' which
contains the offset and what is supported for each SOC.

Fixes: 531d6ab36571 ("pinctrl: ocelot: Extend support for lan966x")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20220713193750.4079621-2-horatiu.vultur@microchip.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-ocelot.c | 195 ++++++++++++++++++++-----------
 1 file changed, 124 insertions(+), 71 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-ocelot.c b/drivers/pinctrl/pinctrl-ocelot.c
index 6a956ee94494..2866365132fd 100644
--- a/drivers/pinctrl/pinctrl-ocelot.c
+++ b/drivers/pinctrl/pinctrl-ocelot.c
@@ -28,19 +28,12 @@
 #define ocelot_clrsetbits(addr, clear, set) \
 	writel((readl(addr) & ~(clear)) | (set), (addr))
 
-/* PINCONFIG bits (sparx5 only) */
 enum {
 	PINCONF_BIAS,
 	PINCONF_SCHMITT,
 	PINCONF_DRIVE_STRENGTH,
 };
 
-#define BIAS_PD_BIT BIT(4)
-#define BIAS_PU_BIT BIT(3)
-#define BIAS_BITS   (BIAS_PD_BIT|BIAS_PU_BIT)
-#define SCHMITT_BIT BIT(2)
-#define DRIVE_BITS  GENMASK(1, 0)
-
 /* GPIO standard registers */
 #define OCELOT_GPIO_OUT_SET	0x0
 #define OCELOT_GPIO_OUT_CLR	0x4
@@ -314,6 +307,13 @@ struct ocelot_pin_caps {
 	unsigned char a_functions[OCELOT_FUNC_PER_PIN];	/* Additional functions */
 };
 
+struct ocelot_pincfg_data {
+	u8 pd_bit;
+	u8 pu_bit;
+	u8 drive_bits;
+	u8 schmitt_bit;
+};
+
 struct ocelot_pinctrl {
 	struct device *dev;
 	struct pinctrl_dev *pctl;
@@ -321,10 +321,16 @@ struct ocelot_pinctrl {
 	struct regmap *map;
 	struct regmap *pincfg;
 	struct pinctrl_desc *desc;
+	const struct ocelot_pincfg_data *pincfg_data;
 	struct ocelot_pmx_func func[FUNC_MAX];
 	u8 stride;
 };
 
+struct ocelot_match_data {
+	struct pinctrl_desc desc;
+	struct ocelot_pincfg_data pincfg_data;
+};
+
 #define LUTON_P(p, f0, f1)						\
 static struct ocelot_pin_caps luton_pin_##p = {				\
 	.pin = p,							\
@@ -1318,6 +1324,7 @@ static int ocelot_hw_get_value(struct ocelot_pinctrl *info,
 	int ret = -EOPNOTSUPP;
 
 	if (info->pincfg) {
+		const struct ocelot_pincfg_data *opd = info->pincfg_data;
 		u32 regcfg;
 
 		ret = regmap_read(info->pincfg, pin, &regcfg);
@@ -1327,15 +1334,15 @@ static int ocelot_hw_get_value(struct ocelot_pinctrl *info,
 		ret = 0;
 		switch (reg) {
 		case PINCONF_BIAS:
-			*val = regcfg & BIAS_BITS;
+			*val = regcfg & (opd->pd_bit | opd->pu_bit);
 			break;
 
 		case PINCONF_SCHMITT:
-			*val = regcfg & SCHMITT_BIT;
+			*val = regcfg & opd->schmitt_bit;
 			break;
 
 		case PINCONF_DRIVE_STRENGTH:
-			*val = regcfg & DRIVE_BITS;
+			*val = regcfg & opd->drive_bits;
 			break;
 
 		default:
@@ -1372,23 +1379,27 @@ static int ocelot_hw_set_value(struct ocelot_pinctrl *info,
 	int ret = -EOPNOTSUPP;
 
 	if (info->pincfg) {
+		const struct ocelot_pincfg_data *opd = info->pincfg_data;
 
 		ret = 0;
 		switch (reg) {
 		case PINCONF_BIAS:
-			ret = ocelot_pincfg_clrsetbits(info, pin, BIAS_BITS,
+			ret = ocelot_pincfg_clrsetbits(info, pin,
+						       opd->pd_bit | opd->pu_bit,
 						       val);
 			break;
 
 		case PINCONF_SCHMITT:
-			ret = ocelot_pincfg_clrsetbits(info, pin, SCHMITT_BIT,
+			ret = ocelot_pincfg_clrsetbits(info, pin,
+						       opd->schmitt_bit,
 						       val);
 			break;
 
 		case PINCONF_DRIVE_STRENGTH:
 			if (val <= 3)
 				ret = ocelot_pincfg_clrsetbits(info, pin,
-							       DRIVE_BITS, val);
+							       opd->drive_bits,
+							       val);
 			else
 				ret = -EINVAL;
 			break;
@@ -1418,17 +1429,20 @@ static int ocelot_pinconf_get(struct pinctrl_dev *pctldev,
 		if (param == PIN_CONFIG_BIAS_DISABLE)
 			val = (val == 0);
 		else if (param == PIN_CONFIG_BIAS_PULL_DOWN)
-			val = (val & BIAS_PD_BIT ? true : false);
+			val = !!(val & info->pincfg_data->pd_bit);
 		else    /* PIN_CONFIG_BIAS_PULL_UP */
-			val = (val & BIAS_PU_BIT ? true : false);
+			val = !!(val & info->pincfg_data->pu_bit);
 		break;
 
 	case PIN_CONFIG_INPUT_SCHMITT_ENABLE:
+		if (!info->pincfg_data->schmitt_bit)
+			return -EOPNOTSUPP;
+
 		err = ocelot_hw_get_value(info, pin, PINCONF_SCHMITT, &val);
 		if (err)
 			return err;
 
-		val = (val & SCHMITT_BIT ? true : false);
+		val = !!(val & info->pincfg_data->schmitt_bit);
 		break;
 
 	case PIN_CONFIG_DRIVE_STRENGTH:
@@ -1472,6 +1486,7 @@ static int ocelot_pinconf_set(struct pinctrl_dev *pctldev, unsigned int pin,
 			      unsigned long *configs, unsigned int num_configs)
 {
 	struct ocelot_pinctrl *info = pinctrl_dev_get_drvdata(pctldev);
+	const struct ocelot_pincfg_data *opd = info->pincfg_data;
 	u32 param, arg, p;
 	int cfg, err = 0;
 
@@ -1484,8 +1499,8 @@ static int ocelot_pinconf_set(struct pinctrl_dev *pctldev, unsigned int pin,
 		case PIN_CONFIG_BIAS_PULL_UP:
 		case PIN_CONFIG_BIAS_PULL_DOWN:
 			arg = (param == PIN_CONFIG_BIAS_DISABLE) ? 0 :
-			(param == PIN_CONFIG_BIAS_PULL_UP) ? BIAS_PU_BIT :
-			BIAS_PD_BIT;
+			      (param == PIN_CONFIG_BIAS_PULL_UP) ?
+				opd->pu_bit : opd->pd_bit;
 
 			err = ocelot_hw_set_value(info, pin, PINCONF_BIAS, arg);
 			if (err)
@@ -1494,7 +1509,10 @@ static int ocelot_pinconf_set(struct pinctrl_dev *pctldev, unsigned int pin,
 			break;
 
 		case PIN_CONFIG_INPUT_SCHMITT_ENABLE:
-			arg = arg ? SCHMITT_BIT : 0;
+			if (!opd->schmitt_bit)
+				return -EOPNOTSUPP;
+
+			arg = arg ? opd->schmitt_bit : 0;
 			err = ocelot_hw_set_value(info, pin, PINCONF_SCHMITT,
 						  arg);
 			if (err)
@@ -1555,69 +1573,94 @@ static const struct pinctrl_ops ocelot_pctl_ops = {
 	.dt_free_map = pinconf_generic_dt_free_map,
 };
 
-static struct pinctrl_desc luton_desc = {
-	.name = "luton-pinctrl",
-	.pins = luton_pins,
-	.npins = ARRAY_SIZE(luton_pins),
-	.pctlops = &ocelot_pctl_ops,
-	.pmxops = &ocelot_pmx_ops,
-	.owner = THIS_MODULE,
+static struct ocelot_match_data luton_desc = {
+	.desc = {
+		.name = "luton-pinctrl",
+		.pins = luton_pins,
+		.npins = ARRAY_SIZE(luton_pins),
+		.pctlops = &ocelot_pctl_ops,
+		.pmxops = &ocelot_pmx_ops,
+		.owner = THIS_MODULE,
+	},
 };
 
-static struct pinctrl_desc serval_desc = {
-	.name = "serval-pinctrl",
-	.pins = serval_pins,
-	.npins = ARRAY_SIZE(serval_pins),
-	.pctlops = &ocelot_pctl_ops,
-	.pmxops = &ocelot_pmx_ops,
-	.owner = THIS_MODULE,
+static struct ocelot_match_data serval_desc = {
+	.desc = {
+		.name = "serval-pinctrl",
+		.pins = serval_pins,
+		.npins = ARRAY_SIZE(serval_pins),
+		.pctlops = &ocelot_pctl_ops,
+		.pmxops = &ocelot_pmx_ops,
+		.owner = THIS_MODULE,
+	},
 };
 
-static struct pinctrl_desc ocelot_desc = {
-	.name = "ocelot-pinctrl",
-	.pins = ocelot_pins,
-	.npins = ARRAY_SIZE(ocelot_pins),
-	.pctlops = &ocelot_pctl_ops,
-	.pmxops = &ocelot_pmx_ops,
-	.owner = THIS_MODULE,
+static struct ocelot_match_data ocelot_desc = {
+	.desc = {
+		.name = "ocelot-pinctrl",
+		.pins = ocelot_pins,
+		.npins = ARRAY_SIZE(ocelot_pins),
+		.pctlops = &ocelot_pctl_ops,
+		.pmxops = &ocelot_pmx_ops,
+		.owner = THIS_MODULE,
+	},
 };
 
-static struct pinctrl_desc jaguar2_desc = {
-	.name = "jaguar2-pinctrl",
-	.pins = jaguar2_pins,
-	.npins = ARRAY_SIZE(jaguar2_pins),
-	.pctlops = &ocelot_pctl_ops,
-	.pmxops = &ocelot_pmx_ops,
-	.owner = THIS_MODULE,
+static struct ocelot_match_data jaguar2_desc = {
+	.desc = {
+		.name = "jaguar2-pinctrl",
+		.pins = jaguar2_pins,
+		.npins = ARRAY_SIZE(jaguar2_pins),
+		.pctlops = &ocelot_pctl_ops,
+		.pmxops = &ocelot_pmx_ops,
+		.owner = THIS_MODULE,
+	},
 };
 
-static struct pinctrl_desc servalt_desc = {
-	.name = "servalt-pinctrl",
-	.pins = servalt_pins,
-	.npins = ARRAY_SIZE(servalt_pins),
-	.pctlops = &ocelot_pctl_ops,
-	.pmxops = &ocelot_pmx_ops,
-	.owner = THIS_MODULE,
+static struct ocelot_match_data servalt_desc = {
+	.desc = {
+		.name = "servalt-pinctrl",
+		.pins = servalt_pins,
+		.npins = ARRAY_SIZE(servalt_pins),
+		.pctlops = &ocelot_pctl_ops,
+		.pmxops = &ocelot_pmx_ops,
+		.owner = THIS_MODULE,
+	},
 };
 
-static struct pinctrl_desc sparx5_desc = {
-	.name = "sparx5-pinctrl",
-	.pins = sparx5_pins,
-	.npins = ARRAY_SIZE(sparx5_pins),
-	.pctlops = &ocelot_pctl_ops,
-	.pmxops = &ocelot_pmx_ops,
-	.confops = &ocelot_confops,
-	.owner = THIS_MODULE,
+static struct ocelot_match_data sparx5_desc = {
+	.desc = {
+		.name = "sparx5-pinctrl",
+		.pins = sparx5_pins,
+		.npins = ARRAY_SIZE(sparx5_pins),
+		.pctlops = &ocelot_pctl_ops,
+		.pmxops = &ocelot_pmx_ops,
+		.confops = &ocelot_confops,
+		.owner = THIS_MODULE,
+	},
+	.pincfg_data = {
+		.pd_bit = BIT(4),
+		.pu_bit = BIT(3),
+		.drive_bits = GENMASK(1, 0),
+		.schmitt_bit = BIT(2),
+	},
 };
 
-static struct pinctrl_desc lan966x_desc = {
-	.name = "lan966x-pinctrl",
-	.pins = lan966x_pins,
-	.npins = ARRAY_SIZE(lan966x_pins),
-	.pctlops = &ocelot_pctl_ops,
-	.pmxops = &lan966x_pmx_ops,
-	.confops = &ocelot_confops,
-	.owner = THIS_MODULE,
+static struct ocelot_match_data lan966x_desc = {
+	.desc = {
+		.name = "lan966x-pinctrl",
+		.pins = lan966x_pins,
+		.npins = ARRAY_SIZE(lan966x_pins),
+		.pctlops = &ocelot_pctl_ops,
+		.pmxops = &lan966x_pmx_ops,
+		.confops = &ocelot_confops,
+		.owner = THIS_MODULE,
+	},
+	.pincfg_data = {
+		.pd_bit = BIT(3),
+		.pu_bit = BIT(2),
+		.drive_bits = GENMASK(1, 0),
+	},
 };
 
 static int ocelot_create_group_func_map(struct device *dev,
@@ -1906,6 +1949,7 @@ static struct regmap *ocelot_pinctrl_create_pincfg(struct platform_device *pdev)
 
 static int ocelot_pinctrl_probe(struct platform_device *pdev)
 {
+	const struct ocelot_match_data *data;
 	struct device *dev = &pdev->dev;
 	struct ocelot_pinctrl *info;
 	struct regmap *pincfg;
@@ -1921,7 +1965,16 @@ static int ocelot_pinctrl_probe(struct platform_device *pdev)
 	if (!info)
 		return -ENOMEM;
 
-	info->desc = (struct pinctrl_desc *)device_get_match_data(dev);
+	data = device_get_match_data(dev);
+	if (!data)
+		return -EINVAL;
+
+	info->desc = devm_kmemdup(dev, &data->desc, sizeof(*info->desc),
+				  GFP_KERNEL);
+	if (!info->desc)
+		return -ENOMEM;
+
+	info->pincfg_data = &data->pincfg_data;
 
 	base = devm_ioremap_resource(dev,
 			platform_get_resource(pdev, IORESOURCE_MEM, 0));
-- 
2.35.1



