Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE9B582E6C
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241523AbiG0RMd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:12:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241566AbiG0RLv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:11:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91E175073D;
        Wed, 27 Jul 2022 09:41:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5CF6B821D5;
        Wed, 27 Jul 2022 16:41:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13399C433B5;
        Wed, 27 Jul 2022 16:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940096;
        bh=75Zf2TJhZZOBtHD1hLzRORjmMYG60PXKLcJYV2d+7+c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A1rYxXPe4gIkGO5c+y3XYetCWAHONNcUzYl7YymWTtiJXpdv4JgKgy1sCIOBPAVOS
         yciK9vK86wlvOkiznRmHqmwPmtlmBacDxG+aPGSSEO2ZzSdxoglpHWljkuFUPLR2bN
         ZUvJ6S887gEwdWO9wvJ3AWix6cEjCOkpaB1GQpq8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 102/201] pinctrl: armada-37xx: Use temporary variable for struct device
Date:   Wed, 27 Jul 2022 18:10:06 +0200
Message-Id: <20220727161031.966419418@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 50cf2ed284e49028a885aa56c3ea50714c635879 ]

Use temporary variable for struct device to make code neater.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mvebu/pinctrl-armada-37xx.c | 56 +++++++++------------
 1 file changed, 23 insertions(+), 33 deletions(-)

diff --git a/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c b/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
index 85a0052bb0e6..e1f76b4ddf23 100644
--- a/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
+++ b/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
@@ -341,12 +341,12 @@ static int armada_37xx_pmx_set_by_name(struct pinctrl_dev *pctldev,
 				       struct armada_37xx_pin_group *grp)
 {
 	struct armada_37xx_pinctrl *info = pinctrl_dev_get_drvdata(pctldev);
+	struct device *dev = info->dev;
 	unsigned int reg = SELECTION;
 	unsigned int mask = grp->reg_mask;
 	int func, val;
 
-	dev_dbg(info->dev, "enable function %s group %s\n",
-		name, grp->name);
+	dev_dbg(dev, "enable function %s group %s\n", name, grp->name);
 
 	func = match_string(grp->funcs, NB_FUNCS, name);
 	if (func < 0)
@@ -722,16 +722,16 @@ static unsigned int armada_37xx_irq_startup(struct irq_data *d)
 static int armada_37xx_irqchip_register(struct platform_device *pdev,
 					struct armada_37xx_pinctrl *info)
 {
-	struct device_node *np = info->dev->of_node;
 	struct gpio_chip *gc = &info->gpio_chip;
 	struct irq_chip *irqchip = &info->irq_chip;
 	struct gpio_irq_chip *girq = &gc->irq;
 	struct device *dev = &pdev->dev;
+	struct device_node *np;
 	struct resource res;
 	int ret = -ENODEV, i, nr_irq_parent;
 
 	/* Check if we have at least one gpio-controller child node */
-	for_each_child_of_node(info->dev->of_node, np) {
+	for_each_child_of_node(dev->of_node, np) {
 		if (of_property_read_bool(np, "gpio-controller")) {
 			ret = 0;
 			break;
@@ -750,12 +750,12 @@ static int armada_37xx_irqchip_register(struct platform_device *pdev,
 		return 0;
 	}
 
-	if (of_address_to_resource(info->dev->of_node, 1, &res)) {
+	if (of_address_to_resource(dev->of_node, 1, &res)) {
 		dev_err(dev, "cannot find IO resource\n");
 		return -ENOENT;
 	}
 
-	info->base = devm_ioremap_resource(info->dev, &res);
+	info->base = devm_ioremap_resource(dev, &res);
 	if (IS_ERR(info->base))
 		return PTR_ERR(info->base);
 
@@ -774,8 +774,7 @@ static int armada_37xx_irqchip_register(struct platform_device *pdev,
 	 * the chained irq with all of them.
 	 */
 	girq->num_parents = nr_irq_parent;
-	girq->parents = devm_kcalloc(&pdev->dev, nr_irq_parent,
-				     sizeof(*girq->parents), GFP_KERNEL);
+	girq->parents = devm_kcalloc(dev, nr_irq_parent, sizeof(*girq->parents), GFP_KERNEL);
 	if (!girq->parents)
 		return -ENOMEM;
 	for (i = 0; i < nr_irq_parent; i++) {
@@ -794,11 +793,12 @@ static int armada_37xx_irqchip_register(struct platform_device *pdev,
 static int armada_37xx_gpiochip_register(struct platform_device *pdev,
 					struct armada_37xx_pinctrl *info)
 {
+	struct device *dev = &pdev->dev;
 	struct device_node *np;
 	struct gpio_chip *gc;
 	int ret = -ENODEV;
 
-	for_each_child_of_node(info->dev->of_node, np) {
+	for_each_child_of_node(dev->of_node, np) {
 		if (of_find_property(np, "gpio-controller", NULL)) {
 			ret = 0;
 			break;
@@ -811,19 +811,16 @@ static int armada_37xx_gpiochip_register(struct platform_device *pdev,
 
 	gc = &info->gpio_chip;
 	gc->ngpio = info->data->nr_pins;
-	gc->parent = &pdev->dev;
+	gc->parent = dev;
 	gc->base = -1;
 	gc->of_node = np;
 	gc->label = info->data->name;
 
 	ret = armada_37xx_irqchip_register(pdev, info);
-	if (ret)
-		return ret;
-	ret = devm_gpiochip_add_data(&pdev->dev, gc, info);
 	if (ret)
 		return ret;
 
-	return 0;
+	return devm_gpiochip_add_data(dev, gc, info);
 }
 
 /**
@@ -874,13 +871,13 @@ static int armada_37xx_add_function(struct armada_37xx_pmx_func *funcs,
 static int armada_37xx_fill_group(struct armada_37xx_pinctrl *info)
 {
 	int n, num = 0, funcsize = info->data->nr_pins;
+	struct device *dev = info->dev;
 
 	for (n = 0; n < info->ngroups; n++) {
 		struct armada_37xx_pin_group *grp = &info->groups[n];
 		int i, j, f;
 
-		grp->pins = devm_kcalloc(info->dev,
-					 grp->npins + grp->extra_npins,
+		grp->pins = devm_kcalloc(dev, grp->npins + grp->extra_npins,
 					 sizeof(*grp->pins),
 					 GFP_KERNEL);
 		if (!grp->pins)
@@ -898,8 +895,7 @@ static int armada_37xx_fill_group(struct armada_37xx_pinctrl *info)
 			ret = armada_37xx_add_function(info->funcs, &funcsize,
 					    grp->funcs[f]);
 			if (ret == -EOVERFLOW)
-				dev_err(info->dev,
-					"More functions than pins(%d)\n",
+				dev_err(dev, "More functions than pins(%d)\n",
 					info->data->nr_pins);
 			if (ret < 0)
 				continue;
@@ -925,6 +921,7 @@ static int armada_37xx_fill_group(struct armada_37xx_pinctrl *info)
 static int armada_37xx_fill_func(struct armada_37xx_pinctrl *info)
 {
 	struct armada_37xx_pmx_func *funcs = info->funcs;
+	struct device *dev = info->dev;
 	int n;
 
 	for (n = 0; n < info->nfuncs; n++) {
@@ -932,8 +929,7 @@ static int armada_37xx_fill_func(struct armada_37xx_pinctrl *info)
 		const char **groups;
 		int g;
 
-		funcs[n].groups = devm_kcalloc(info->dev,
-					       funcs[n].ngroups,
+		funcs[n].groups = devm_kcalloc(dev, funcs[n].ngroups,
 					       sizeof(*(funcs[n].groups)),
 					       GFP_KERNEL);
 		if (!funcs[n].groups)
@@ -962,6 +958,7 @@ static int armada_37xx_pinctrl_register(struct platform_device *pdev,
 	const struct armada_37xx_pin_data *pin_data = info->data;
 	struct pinctrl_desc *ctrldesc = &info->pctl;
 	struct pinctrl_pin_desc *pindesc, *pdesc;
+	struct device *dev = &pdev->dev;
 	int pin, ret;
 
 	info->groups = pin_data->groups;
@@ -973,9 +970,7 @@ static int armada_37xx_pinctrl_register(struct platform_device *pdev,
 	ctrldesc->pmxops = &armada_37xx_pmx_ops;
 	ctrldesc->confops = &armada_37xx_pinconf_ops;
 
-	pindesc = devm_kcalloc(&pdev->dev,
-			       pin_data->nr_pins, sizeof(*pindesc),
-			       GFP_KERNEL);
+	pindesc = devm_kcalloc(dev, pin_data->nr_pins, sizeof(*pindesc), GFP_KERNEL);
 	if (!pindesc)
 		return -ENOMEM;
 
@@ -994,14 +989,10 @@ static int armada_37xx_pinctrl_register(struct platform_device *pdev,
 	 * we allocate functions for number of pins and hope there are
 	 * fewer unique functions than pins available
 	 */
-	info->funcs = devm_kcalloc(&pdev->dev,
-				   pin_data->nr_pins,
-				   sizeof(struct armada_37xx_pmx_func),
-				   GFP_KERNEL);
+	info->funcs = devm_kcalloc(dev, pin_data->nr_pins, sizeof(*info->funcs), GFP_KERNEL);
 	if (!info->funcs)
 		return -ENOMEM;
 
-
 	ret = armada_37xx_fill_group(info);
 	if (ret)
 		return ret;
@@ -1010,9 +1001,9 @@ static int armada_37xx_pinctrl_register(struct platform_device *pdev,
 	if (ret)
 		return ret;
 
-	info->pctl_dev = devm_pinctrl_register(&pdev->dev, ctrldesc, info);
+	info->pctl_dev = devm_pinctrl_register(dev, ctrldesc, info);
 	if (IS_ERR(info->pctl_dev)) {
-		dev_err(&pdev->dev, "could not register pinctrl driver\n");
+		dev_err(dev, "could not register pinctrl driver\n");
 		return PTR_ERR(info->pctl_dev);
 	}
 
@@ -1143,8 +1134,7 @@ static int __init armada_37xx_pinctrl_probe(struct platform_device *pdev)
 	struct regmap *regmap;
 	int ret;
 
-	info = devm_kzalloc(dev, sizeof(struct armada_37xx_pinctrl),
-			    GFP_KERNEL);
+	info = devm_kzalloc(dev, sizeof(*info), GFP_KERNEL);
 	if (!info)
 		return -ENOMEM;
 
@@ -1152,7 +1142,7 @@ static int __init armada_37xx_pinctrl_probe(struct platform_device *pdev)
 
 	regmap = syscon_node_to_regmap(np);
 	if (IS_ERR(regmap)) {
-		dev_err(&pdev->dev, "cannot get regmap\n");
+		dev_err(dev, "cannot get regmap\n");
 		return PTR_ERR(regmap);
 	}
 	info->regmap = regmap;
-- 
2.35.1



