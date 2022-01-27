Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1643F49E9D0
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 19:10:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245041AbiA0SKP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 13:10:15 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58976 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245040AbiA0SJ6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 13:09:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23108B820C8;
        Thu, 27 Jan 2022 18:09:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D5A3C340EA;
        Thu, 27 Jan 2022 18:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643306996;
        bh=ylg8kqnBPW7+lr+1ZYjjF8PMqVyBsduSyQYntsokWZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pKtfD2QZbEb7yzu3lhjnDwaoLwKFTTlLZWNqpefh5F544kSQX1O4me2HXQn1QQJIW
         4iysrA5cRjt55/+ZN53T0ZNHRN/YfpjBKulw0mBXcJJu9T2eg99RS+3m3fYpdc4I0S
         95Vd1/bP+ZXSYAvHHLiD/HzzCQoicjemTWhNKUok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 5.4 05/11] pinctrl: bcm2835: Add support for all GPIOs on BCM2711
Date:   Thu, 27 Jan 2022 19:09:06 +0100
Message-Id: <20220127180258.541081419@linuxfoundation.org>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20220127180258.362000607@linuxfoundation.org>
References: <20220127180258.362000607@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Wahren <stefan.wahren@i2se.com>

commit b1d84a3d0a26c5844a22bc09a42704b9371208bb upstream

The BCM2711 supports 58 GPIOs. So extend pinctrl and GPIOs accordingly.

Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
Link: https://lore.kernel.org/r/1581166975-22949-4-git-send-email-stefan.wahren@i2se.com
Reviewed-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/bcm/pinctrl-bcm2835.c |   54 ++++++++++++++++++++++++++--------
 1 file changed, 42 insertions(+), 12 deletions(-)

--- a/drivers/pinctrl/bcm/pinctrl-bcm2835.c
+++ b/drivers/pinctrl/bcm/pinctrl-bcm2835.c
@@ -37,6 +37,7 @@
 
 #define MODULE_NAME "pinctrl-bcm2835"
 #define BCM2835_NUM_GPIOS 54
+#define BCM2711_NUM_GPIOS 58
 #define BCM2835_NUM_BANKS 2
 #define BCM2835_NUM_IRQS  3
 
@@ -78,7 +79,7 @@ struct bcm2835_pinctrl {
 
 	/* note: locking assumes each bank will have its own unsigned long */
 	unsigned long enabled_irq_map[BCM2835_NUM_BANKS];
-	unsigned int irq_type[BCM2835_NUM_GPIOS];
+	unsigned int irq_type[BCM2711_NUM_GPIOS];
 
 	struct pinctrl_dev *pctl_dev;
 	struct gpio_chip gpio_chip;
@@ -145,6 +146,10 @@ static struct pinctrl_pin_desc bcm2835_g
 	BCM2835_GPIO_PIN(51),
 	BCM2835_GPIO_PIN(52),
 	BCM2835_GPIO_PIN(53),
+	BCM2835_GPIO_PIN(54),
+	BCM2835_GPIO_PIN(55),
+	BCM2835_GPIO_PIN(56),
+	BCM2835_GPIO_PIN(57),
 };
 
 /* one pin per group */
@@ -203,6 +208,10 @@ static const char * const bcm2835_gpio_g
 	"gpio51",
 	"gpio52",
 	"gpio53",
+	"gpio54",
+	"gpio55",
+	"gpio56",
+	"gpio57",
 };
 
 enum bcm2835_fsel {
@@ -353,6 +362,22 @@ static const struct gpio_chip bcm2835_gp
 	.can_sleep = false,
 };
 
+static const struct gpio_chip bcm2711_gpio_chip = {
+	.label = "pinctrl-bcm2711",
+	.owner = THIS_MODULE,
+	.request = gpiochip_generic_request,
+	.free = gpiochip_generic_free,
+	.direction_input = bcm2835_gpio_direction_input,
+	.direction_output = bcm2835_gpio_direction_output,
+	.get_direction = bcm2835_gpio_get_direction,
+	.get = bcm2835_gpio_get,
+	.set = bcm2835_gpio_set,
+	.set_config = gpiochip_generic_config,
+	.base = -1,
+	.ngpio = BCM2711_NUM_GPIOS,
+	.can_sleep = false,
+};
+
 static void bcm2835_gpio_irq_handle_bank(struct bcm2835_pinctrl *pc,
 					 unsigned int bank, u32 mask)
 {
@@ -399,7 +424,7 @@ static void bcm2835_gpio_irq_handler(str
 		bcm2835_gpio_irq_handle_bank(pc, 0, 0xf0000000);
 		bcm2835_gpio_irq_handle_bank(pc, 1, 0x00003fff);
 		break;
-	case 2: /* IRQ2 covers GPIOs 46-53 */
+	case 2: /* IRQ2 covers GPIOs 46-57 */
 		bcm2835_gpio_irq_handle_bank(pc, 1, 0x003fc000);
 		break;
 	}
@@ -618,7 +643,7 @@ static struct irq_chip bcm2835_gpio_irq_
 
 static int bcm2835_pctl_get_groups_count(struct pinctrl_dev *pctldev)
 {
-	return ARRAY_SIZE(bcm2835_gpio_groups);
+	return BCM2835_NUM_GPIOS;
 }
 
 static const char *bcm2835_pctl_get_group_name(struct pinctrl_dev *pctldev,
@@ -776,7 +801,7 @@ static int bcm2835_pctl_dt_node_to_map(s
 		err = of_property_read_u32_index(np, "brcm,pins", i, &pin);
 		if (err)
 			goto out;
-		if (pin >= ARRAY_SIZE(bcm2835_gpio_pins)) {
+		if (pin >= pc->pctl_desc.npins) {
 			dev_err(pc->dev, "%pOF: invalid brcm,pins value %d\n",
 				np, pin);
 			err = -EINVAL;
@@ -852,7 +877,7 @@ static int bcm2835_pmx_get_function_grou
 {
 	/* every pin can do every function */
 	*groups = bcm2835_gpio_groups;
-	*num_groups = ARRAY_SIZE(bcm2835_gpio_groups);
+	*num_groups = BCM2835_NUM_GPIOS;
 
 	return 0;
 }
@@ -1055,7 +1080,7 @@ static const struct pinconf_ops bcm2711_
 static const struct pinctrl_desc bcm2835_pinctrl_desc = {
 	.name = MODULE_NAME,
 	.pins = bcm2835_gpio_pins,
-	.npins = ARRAY_SIZE(bcm2835_gpio_pins),
+	.npins = BCM2835_NUM_GPIOS,
 	.pctlops = &bcm2835_pctl_ops,
 	.pmxops = &bcm2835_pmx_ops,
 	.confops = &bcm2835_pinconf_ops,
@@ -1063,9 +1088,9 @@ static const struct pinctrl_desc bcm2835
 };
 
 static const struct pinctrl_desc bcm2711_pinctrl_desc = {
-	.name = MODULE_NAME,
+	.name = "pinctrl-bcm2711",
 	.pins = bcm2835_gpio_pins,
-	.npins = ARRAY_SIZE(bcm2835_gpio_pins),
+	.npins = BCM2711_NUM_GPIOS,
 	.pctlops = &bcm2835_pctl_ops,
 	.pmxops = &bcm2835_pmx_ops,
 	.confops = &bcm2711_pinconf_ops,
@@ -1077,6 +1102,11 @@ static const struct pinctrl_gpio_range b
 	.npins = BCM2835_NUM_GPIOS,
 };
 
+static const struct pinctrl_gpio_range bcm2711_pinctrl_gpio_range = {
+	.name = "pinctrl-bcm2711",
+	.npins = BCM2711_NUM_GPIOS,
+};
+
 struct bcm_plat_data {
 	const struct gpio_chip *gpio_chip;
 	const struct pinctrl_desc *pctl_desc;
@@ -1090,9 +1120,9 @@ static const struct bcm_plat_data bcm283
 };
 
 static const struct bcm_plat_data bcm2711_plat_data = {
-	.gpio_chip = &bcm2835_gpio_chip,
+	.gpio_chip = &bcm2711_gpio_chip,
 	.pctl_desc = &bcm2711_pinctrl_desc,
-	.gpio_range = &bcm2835_pinctrl_gpio_range,
+	.gpio_range = &bcm2711_pinctrl_gpio_range,
 };
 
 static const struct of_device_id bcm2835_pinctrl_match[] = {
@@ -1118,8 +1148,8 @@ static int bcm2835_pinctrl_probe(struct
 	int err, i;
 	const struct of_device_id *match;
 
-	BUILD_BUG_ON(ARRAY_SIZE(bcm2835_gpio_pins) != BCM2835_NUM_GPIOS);
-	BUILD_BUG_ON(ARRAY_SIZE(bcm2835_gpio_groups) != BCM2835_NUM_GPIOS);
+	BUILD_BUG_ON(ARRAY_SIZE(bcm2835_gpio_pins) != BCM2711_NUM_GPIOS);
+	BUILD_BUG_ON(ARRAY_SIZE(bcm2835_gpio_groups) != BCM2711_NUM_GPIOS);
 
 	pc = devm_kzalloc(dev, sizeof(*pc), GFP_KERNEL);
 	if (!pc)


