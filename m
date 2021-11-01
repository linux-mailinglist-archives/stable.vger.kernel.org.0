Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3A84416CA
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:27:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232609AbhKAJ3u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:29:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:58580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232198AbhKAJ05 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:26:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 346D36115B;
        Mon,  1 Nov 2021 09:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758550;
        bh=3Wz2oQ5ODzrXuaXYIO4ceHW9s5XR2RXg5ILDM9NdOuU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nhiacxf6D17MGI0fFUguhO7Nj1uR23HOc1nv2cKTkiqz00Yb1mXPzNJg5i+cqrWh9
         pa3aZPN7cbjSEwKR1VNmpcfZsKfn/6+Fq2vrUlmgzQv6n5t6FdPQA1LhzEZ4lEvQ3F
         WEqtrXs1eSZ7RXOzr6FPjn1BhTdCsUQxMR6qR+Ys=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.4 10/51] Revert "pinctrl: bcm: ns: support updated DT binding as syscon subnode"
Date:   Mon,  1 Nov 2021 10:17:14 +0100
Message-Id: <20211101082502.363941616@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082500.203657870@linuxfoundation.org>
References: <20211101082500.203657870@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

commit 6dba4bdfd7a30e77b848a45404b224588bf989e5 upstream.

This reverts commit a49d784d5a8272d0f63c448fe8dc69e589db006e.

The updated binding was wrong / invalid and has been reverted. There
isn't any upstream kernel DTS using it and Broadcom isn't known to use
it neither. There is close to zero chance this will cause regression for
anyone.

Actually in-kernel bcm5301x.dtsi still uses the old good binding and so
it's broken since the driver update. This revert fixes it.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Link: https://lore.kernel.org/r/20211008205938.29925-3-zajec5@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/bcm/pinctrl-ns.c |   29 ++++++++++-------------------
 1 file changed, 10 insertions(+), 19 deletions(-)

--- a/drivers/pinctrl/bcm/pinctrl-ns.c
+++ b/drivers/pinctrl/bcm/pinctrl-ns.c
@@ -5,7 +5,6 @@
 
 #include <linux/err.h>
 #include <linux/io.h>
-#include <linux/mfd/syscon.h>
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
@@ -13,7 +12,6 @@
 #include <linux/pinctrl/pinctrl.h>
 #include <linux/pinctrl/pinmux.h>
 #include <linux/platform_device.h>
-#include <linux/regmap.h>
 #include <linux/slab.h>
 
 #define FLAG_BCM4708		BIT(1)
@@ -24,8 +22,7 @@ struct ns_pinctrl {
 	struct device *dev;
 	unsigned int chipset_flag;
 	struct pinctrl_dev *pctldev;
-	struct regmap *regmap;
-	u32 offset;
+	void __iomem *base;
 
 	struct pinctrl_desc pctldesc;
 	struct ns_pinctrl_group *groups;
@@ -232,9 +229,9 @@ static int ns_pinctrl_set_mux(struct pin
 		unset |= BIT(pin_number);
 	}
 
-	regmap_read(ns_pinctrl->regmap, ns_pinctrl->offset, &tmp);
+	tmp = readl(ns_pinctrl->base);
 	tmp &= ~unset;
-	regmap_write(ns_pinctrl->regmap, ns_pinctrl->offset, tmp);
+	writel(tmp, ns_pinctrl->base);
 
 	return 0;
 }
@@ -266,13 +263,13 @@ static const struct of_device_id ns_pinc
 static int ns_pinctrl_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
-	struct device_node *np = dev->of_node;
 	const struct of_device_id *of_id;
 	struct ns_pinctrl *ns_pinctrl;
 	struct pinctrl_desc *pctldesc;
 	struct pinctrl_pin_desc *pin;
 	struct ns_pinctrl_group *group;
 	struct ns_pinctrl_function *function;
+	struct resource *res;
 	int i;
 
 	ns_pinctrl = devm_kzalloc(dev, sizeof(*ns_pinctrl), GFP_KERNEL);
@@ -290,18 +287,12 @@ static int ns_pinctrl_probe(struct platf
 		return -EINVAL;
 	ns_pinctrl->chipset_flag = (uintptr_t)of_id->data;
 
-	ns_pinctrl->regmap = syscon_node_to_regmap(of_get_parent(np));
-	if (IS_ERR(ns_pinctrl->regmap)) {
-		int err = PTR_ERR(ns_pinctrl->regmap);
-
-		dev_err(dev, "Failed to map pinctrl regs: %d\n", err);
-
-		return err;
-	}
-
-	if (of_property_read_u32(np, "offset", &ns_pinctrl->offset)) {
-		dev_err(dev, "Failed to get register offset\n");
-		return -ENOENT;
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
+					   "cru_gpio_control");
+	ns_pinctrl->base = devm_ioremap_resource(dev, res);
+	if (IS_ERR(ns_pinctrl->base)) {
+		dev_err(dev, "Failed to map pinctrl regs\n");
+		return PTR_ERR(ns_pinctrl->base);
 	}
 
 	memcpy(pctldesc, &ns_pinctrl_desc, sizeof(*pctldesc));


