Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D68F531BC75
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:30:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbhBOP3I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:29:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:44910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230498AbhBOP2w (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:28:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 48E6964DBA;
        Mon, 15 Feb 2021 15:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613402890;
        bh=z3642jZG6m5Jc8G1cyh8KwHoQJ3tM/lEP/YLd3LmCAk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oOa6o/KHWtgVSjYos6L/R9opNl2qo+Xht9K8bbw+ExStsycK1i0n7o0QzkiLGNtIY
         vwQ1eWsELkuQIZqB/yE9F2brkOFQN7Ssf7GuwPR/96r5+gHcTVKFYyTpyGVH8mpzgY
         Y9bo+WIMa3dgUBot5ZIXVrmj0hRkLl9HoYY7yVrs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Sverdlin <alexander.sverdlin@gmail.com>,
        Nikita Shubin <nikita.shubin@maquefel.me>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 5.4 01/60] gpio: ep93xx: fix BUG_ON port F usage
Date:   Mon, 15 Feb 2021 16:26:49 +0100
Message-Id: <20210215152715.447698210@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152715.401453874@linuxfoundation.org>
References: <20210215152715.401453874@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikita Shubin <nikita.shubin@maquefel.me>

commit 8b81a7ab8055d01d827ef66374b126eeac3bd108 upstream.

Two index spaces and ep93xx_gpio_port are confusing.

Instead add a separate struct to store necessary data and remove
ep93xx_gpio_port.

- add struct to store IRQ related data for each IRQ capable chip
- replace offset array with defined offsets
- add IRQ registers offset for each IRQ capable chip into
  ep93xx_gpio_banks

------------[ cut here ]------------
kernel BUG at drivers/gpio/gpio-ep93xx.c:64!
---[ end trace 3f6544e133e9f5ae ]---

Fixes: fd935fc421e74 ("gpio: ep93xx: Do not pingpong irq numbers")
Cc: <stable@vger.kernel.org>
Reviewed-by: Alexander Sverdlin <alexander.sverdlin@gmail.com>
Tested-by: Alexander Sverdlin <alexander.sverdlin@gmail.com>
Signed-off-by: Nikita Shubin <nikita.shubin@maquefel.me>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-ep93xx.c |  186 +++++++++++++++++++++++----------------------
 1 file changed, 99 insertions(+), 87 deletions(-)

--- a/drivers/gpio/gpio-ep93xx.c
+++ b/drivers/gpio/gpio-ep93xx.c
@@ -25,6 +25,9 @@
 /* Maximum value for gpio line identifiers */
 #define EP93XX_GPIO_LINE_MAX 63
 
+/* Number of GPIO chips in EP93XX */
+#define EP93XX_GPIO_CHIP_NUM 8
+
 /* Maximum value for irq capable line identifiers */
 #define EP93XX_GPIO_LINE_MAX_IRQ 23
 
@@ -34,74 +37,74 @@
  */
 #define EP93XX_GPIO_F_IRQ_BASE 80
 
+struct ep93xx_gpio_irq_chip {
+	u8 irq_offset;
+	u8 int_unmasked;
+	u8 int_enabled;
+	u8 int_type1;
+	u8 int_type2;
+	u8 int_debounce;
+};
+
+struct ep93xx_gpio_chip {
+	struct gpio_chip		gc;
+	struct ep93xx_gpio_irq_chip	*eic;
+};
+
 struct ep93xx_gpio {
 	void __iomem		*base;
-	struct gpio_chip	gc[8];
+	struct ep93xx_gpio_chip	gc[EP93XX_GPIO_CHIP_NUM];
 };
 
-/*************************************************************************
- * Interrupt handling for EP93xx on-chip GPIOs
- *************************************************************************/
-static unsigned char gpio_int_unmasked[3];
-static unsigned char gpio_int_enabled[3];
-static unsigned char gpio_int_type1[3];
-static unsigned char gpio_int_type2[3];
-static unsigned char gpio_int_debounce[3];
+#define to_ep93xx_gpio_chip(x) container_of(x, struct ep93xx_gpio_chip, gc)
 
-/* Port ordering is: A B F */
-static const u8 int_type1_register_offset[3]	= { 0x90, 0xac, 0x4c };
-static const u8 int_type2_register_offset[3]	= { 0x94, 0xb0, 0x50 };
-static const u8 eoi_register_offset[3]		= { 0x98, 0xb4, 0x54 };
-static const u8 int_en_register_offset[3]	= { 0x9c, 0xb8, 0x58 };
-static const u8 int_debounce_register_offset[3]	= { 0xa8, 0xc4, 0x64 };
-
-static void ep93xx_gpio_update_int_params(struct ep93xx_gpio *epg, unsigned port)
+static struct ep93xx_gpio_irq_chip *to_ep93xx_gpio_irq_chip(struct gpio_chip *gc)
 {
-	BUG_ON(port > 2);
-
-	writeb_relaxed(0, epg->base + int_en_register_offset[port]);
+	struct ep93xx_gpio_chip *egc = to_ep93xx_gpio_chip(gc);
 
-	writeb_relaxed(gpio_int_type2[port],
-		       epg->base + int_type2_register_offset[port]);
-
-	writeb_relaxed(gpio_int_type1[port],
-		       epg->base + int_type1_register_offset[port]);
-
-	writeb(gpio_int_unmasked[port] & gpio_int_enabled[port],
-	       epg->base + int_en_register_offset[port]);
+	return egc->eic;
 }
 
-static int ep93xx_gpio_port(struct gpio_chip *gc)
-{
-	struct ep93xx_gpio *epg = gpiochip_get_data(gc);
-	int port = 0;
+/*************************************************************************
+ * Interrupt handling for EP93xx on-chip GPIOs
+ *************************************************************************/
+#define EP93XX_INT_TYPE1_OFFSET		0x00
+#define EP93XX_INT_TYPE2_OFFSET		0x04
+#define EP93XX_INT_EOI_OFFSET		0x08
+#define EP93XX_INT_EN_OFFSET		0x0c
+#define EP93XX_INT_STATUS_OFFSET	0x10
+#define EP93XX_INT_RAW_STATUS_OFFSET	0x14
+#define EP93XX_INT_DEBOUNCE_OFFSET	0x18
+
+static void ep93xx_gpio_update_int_params(struct ep93xx_gpio *epg,
+					  struct ep93xx_gpio_irq_chip *eic)
+{
+	writeb_relaxed(0, epg->base + eic->irq_offset + EP93XX_INT_EN_OFFSET);
 
-	while (port < ARRAY_SIZE(epg->gc) && gc != &epg->gc[port])
-		port++;
+	writeb_relaxed(eic->int_type2,
+		       epg->base + eic->irq_offset + EP93XX_INT_TYPE2_OFFSET);
 
-	/* This should not happen but is there as a last safeguard */
-	if (port == ARRAY_SIZE(epg->gc)) {
-		pr_crit("can't find the GPIO port\n");
-		return 0;
-	}
+	writeb_relaxed(eic->int_type1,
+		       epg->base + eic->irq_offset + EP93XX_INT_TYPE1_OFFSET);
 
-	return port;
+	writeb_relaxed(eic->int_unmasked & eic->int_enabled,
+		       epg->base + eic->irq_offset + EP93XX_INT_EN_OFFSET);
 }
 
 static void ep93xx_gpio_int_debounce(struct gpio_chip *gc,
 				     unsigned int offset, bool enable)
 {
 	struct ep93xx_gpio *epg = gpiochip_get_data(gc);
-	int port = ep93xx_gpio_port(gc);
+	struct ep93xx_gpio_irq_chip *eic = to_ep93xx_gpio_irq_chip(gc);
 	int port_mask = BIT(offset);
 
 	if (enable)
-		gpio_int_debounce[port] |= port_mask;
+		eic->int_debounce |= port_mask;
 	else
-		gpio_int_debounce[port] &= ~port_mask;
+		eic->int_debounce &= ~port_mask;
 
-	writeb(gpio_int_debounce[port],
-	       epg->base + int_debounce_register_offset[port]);
+	writeb(eic->int_debounce,
+	       epg->base + eic->irq_offset + EP93XX_INT_DEBOUNCE_OFFSET);
 }
 
 static void ep93xx_gpio_ab_irq_handler(struct irq_desc *desc)
@@ -122,12 +125,12 @@ static void ep93xx_gpio_ab_irq_handler(s
 	 */
 	stat = readb(epg->base + EP93XX_GPIO_A_INT_STATUS);
 	for_each_set_bit(offset, &stat, 8)
-		generic_handle_irq(irq_find_mapping(epg->gc[0].irq.domain,
+		generic_handle_irq(irq_find_mapping(epg->gc[0].gc.irq.domain,
 						    offset));
 
 	stat = readb(epg->base + EP93XX_GPIO_B_INT_STATUS);
 	for_each_set_bit(offset, &stat, 8)
-		generic_handle_irq(irq_find_mapping(epg->gc[1].irq.domain,
+		generic_handle_irq(irq_find_mapping(epg->gc[1].gc.irq.domain,
 						    offset));
 
 	chained_irq_exit(irqchip, desc);
@@ -153,52 +156,52 @@ static void ep93xx_gpio_f_irq_handler(st
 static void ep93xx_gpio_irq_ack(struct irq_data *d)
 {
 	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
+	struct ep93xx_gpio_irq_chip *eic = to_ep93xx_gpio_irq_chip(gc);
 	struct ep93xx_gpio *epg = gpiochip_get_data(gc);
-	int port = ep93xx_gpio_port(gc);
 	int port_mask = BIT(d->irq & 7);
 
 	if (irqd_get_trigger_type(d) == IRQ_TYPE_EDGE_BOTH) {
-		gpio_int_type2[port] ^= port_mask; /* switch edge direction */
-		ep93xx_gpio_update_int_params(epg, port);
+		eic->int_type2 ^= port_mask; /* switch edge direction */
+		ep93xx_gpio_update_int_params(epg, eic);
 	}
 
-	writeb(port_mask, epg->base + eoi_register_offset[port]);
+	writeb(port_mask, epg->base + eic->irq_offset + EP93XX_INT_EOI_OFFSET);
 }
 
 static void ep93xx_gpio_irq_mask_ack(struct irq_data *d)
 {
 	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
+	struct ep93xx_gpio_irq_chip *eic = to_ep93xx_gpio_irq_chip(gc);
 	struct ep93xx_gpio *epg = gpiochip_get_data(gc);
-	int port = ep93xx_gpio_port(gc);
 	int port_mask = BIT(d->irq & 7);
 
 	if (irqd_get_trigger_type(d) == IRQ_TYPE_EDGE_BOTH)
-		gpio_int_type2[port] ^= port_mask; /* switch edge direction */
+		eic->int_type2 ^= port_mask; /* switch edge direction */
 
-	gpio_int_unmasked[port] &= ~port_mask;
-	ep93xx_gpio_update_int_params(epg, port);
+	eic->int_unmasked &= ~port_mask;
+	ep93xx_gpio_update_int_params(epg, eic);
 
-	writeb(port_mask, epg->base + eoi_register_offset[port]);
+	writeb(port_mask, epg->base + eic->irq_offset + EP93XX_INT_EOI_OFFSET);
 }
 
 static void ep93xx_gpio_irq_mask(struct irq_data *d)
 {
 	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
+	struct ep93xx_gpio_irq_chip *eic = to_ep93xx_gpio_irq_chip(gc);
 	struct ep93xx_gpio *epg = gpiochip_get_data(gc);
-	int port = ep93xx_gpio_port(gc);
 
-	gpio_int_unmasked[port] &= ~BIT(d->irq & 7);
-	ep93xx_gpio_update_int_params(epg, port);
+	eic->int_unmasked &= ~BIT(d->irq & 7);
+	ep93xx_gpio_update_int_params(epg, eic);
 }
 
 static void ep93xx_gpio_irq_unmask(struct irq_data *d)
 {
 	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
+	struct ep93xx_gpio_irq_chip *eic = to_ep93xx_gpio_irq_chip(gc);
 	struct ep93xx_gpio *epg = gpiochip_get_data(gc);
-	int port = ep93xx_gpio_port(gc);
 
-	gpio_int_unmasked[port] |= BIT(d->irq & 7);
-	ep93xx_gpio_update_int_params(epg, port);
+	eic->int_unmasked |= BIT(d->irq & 7);
+	ep93xx_gpio_update_int_params(epg, eic);
 }
 
 /*
@@ -209,8 +212,8 @@ static void ep93xx_gpio_irq_unmask(struc
 static int ep93xx_gpio_irq_type(struct irq_data *d, unsigned int type)
 {
 	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
+	struct ep93xx_gpio_irq_chip *eic = to_ep93xx_gpio_irq_chip(gc);
 	struct ep93xx_gpio *epg = gpiochip_get_data(gc);
-	int port = ep93xx_gpio_port(gc);
 	int offset = d->irq & 7;
 	int port_mask = BIT(offset);
 	irq_flow_handler_t handler;
@@ -219,32 +222,32 @@ static int ep93xx_gpio_irq_type(struct i
 
 	switch (type) {
 	case IRQ_TYPE_EDGE_RISING:
-		gpio_int_type1[port] |= port_mask;
-		gpio_int_type2[port] |= port_mask;
+		eic->int_type1 |= port_mask;
+		eic->int_type2 |= port_mask;
 		handler = handle_edge_irq;
 		break;
 	case IRQ_TYPE_EDGE_FALLING:
-		gpio_int_type1[port] |= port_mask;
-		gpio_int_type2[port] &= ~port_mask;
+		eic->int_type1 |= port_mask;
+		eic->int_type2 &= ~port_mask;
 		handler = handle_edge_irq;
 		break;
 	case IRQ_TYPE_LEVEL_HIGH:
-		gpio_int_type1[port] &= ~port_mask;
-		gpio_int_type2[port] |= port_mask;
+		eic->int_type1 &= ~port_mask;
+		eic->int_type2 |= port_mask;
 		handler = handle_level_irq;
 		break;
 	case IRQ_TYPE_LEVEL_LOW:
-		gpio_int_type1[port] &= ~port_mask;
-		gpio_int_type2[port] &= ~port_mask;
+		eic->int_type1 &= ~port_mask;
+		eic->int_type2 &= ~port_mask;
 		handler = handle_level_irq;
 		break;
 	case IRQ_TYPE_EDGE_BOTH:
-		gpio_int_type1[port] |= port_mask;
+		eic->int_type1 |= port_mask;
 		/* set initial polarity based on current input level */
 		if (gc->get(gc, offset))
-			gpio_int_type2[port] &= ~port_mask; /* falling */
+			eic->int_type2 &= ~port_mask; /* falling */
 		else
-			gpio_int_type2[port] |= port_mask; /* rising */
+			eic->int_type2 |= port_mask; /* rising */
 		handler = handle_edge_irq;
 		break;
 	default:
@@ -253,9 +256,9 @@ static int ep93xx_gpio_irq_type(struct i
 
 	irq_set_handler_locked(d, handler);
 
-	gpio_int_enabled[port] |= port_mask;
+	eic->int_enabled |= port_mask;
 
-	ep93xx_gpio_update_int_params(epg, port);
+	ep93xx_gpio_update_int_params(epg, eic);
 
 	return 0;
 }
@@ -276,17 +279,19 @@ struct ep93xx_gpio_bank {
 	const char	*label;
 	int		data;
 	int		dir;
+	int		irq;
 	int		base;
 	bool		has_irq;
 	bool		has_hierarchical_irq;
 	unsigned int	irq_base;
 };
 
-#define EP93XX_GPIO_BANK(_label, _data, _dir, _base, _has_irq, _has_hier, _irq_base) \
+#define EP93XX_GPIO_BANK(_label, _data, _dir, _irq, _base, _has_irq, _has_hier, _irq_base) \
 	{							\
 		.label		= _label,			\
 		.data		= _data,			\
 		.dir		= _dir,				\
+		.irq		= _irq,				\
 		.base		= _base,			\
 		.has_irq	= _has_irq,			\
 		.has_hierarchical_irq = _has_hier,		\
@@ -295,16 +300,16 @@ struct ep93xx_gpio_bank {
 
 static struct ep93xx_gpio_bank ep93xx_gpio_banks[] = {
 	/* Bank A has 8 IRQs */
-	EP93XX_GPIO_BANK("A", 0x00, 0x10, 0, true, false, 64),
+	EP93XX_GPIO_BANK("A", 0x00, 0x10, 0x90, 0, true, false, 64),
 	/* Bank B has 8 IRQs */
-	EP93XX_GPIO_BANK("B", 0x04, 0x14, 8, true, false, 72),
-	EP93XX_GPIO_BANK("C", 0x08, 0x18, 40, false, false, 0),
-	EP93XX_GPIO_BANK("D", 0x0c, 0x1c, 24, false, false, 0),
-	EP93XX_GPIO_BANK("E", 0x20, 0x24, 32, false, false, 0),
+	EP93XX_GPIO_BANK("B", 0x04, 0x14, 0xac, 8, true, false, 72),
+	EP93XX_GPIO_BANK("C", 0x08, 0x18, 0x00, 40, false, false, 0),
+	EP93XX_GPIO_BANK("D", 0x0c, 0x1c, 0x00, 24, false, false, 0),
+	EP93XX_GPIO_BANK("E", 0x20, 0x24, 0x00, 32, false, false, 0),
 	/* Bank F has 8 IRQs */
-	EP93XX_GPIO_BANK("F", 0x30, 0x34, 16, false, true, 0),
-	EP93XX_GPIO_BANK("G", 0x38, 0x3c, 48, false, false, 0),
-	EP93XX_GPIO_BANK("H", 0x40, 0x44, 56, false, false, 0),
+	EP93XX_GPIO_BANK("F", 0x30, 0x34, 0x4c, 16, false, true, 0),
+	EP93XX_GPIO_BANK("G", 0x38, 0x3c, 0x00, 48, false, false, 0),
+	EP93XX_GPIO_BANK("H", 0x40, 0x44, 0x00, 56, false, false, 0),
 };
 
 static int ep93xx_gpio_set_config(struct gpio_chip *gc, unsigned offset,
@@ -326,13 +331,14 @@ static int ep93xx_gpio_f_to_irq(struct g
 	return EP93XX_GPIO_F_IRQ_BASE + offset;
 }
 
-static int ep93xx_gpio_add_bank(struct gpio_chip *gc,
+static int ep93xx_gpio_add_bank(struct ep93xx_gpio_chip *egc,
 				struct platform_device *pdev,
 				struct ep93xx_gpio *epg,
 				struct ep93xx_gpio_bank *bank)
 {
 	void __iomem *data = epg->base + bank->data;
 	void __iomem *dir = epg->base + bank->dir;
+	struct gpio_chip *gc = &egc->gc;
 	struct device *dev = &pdev->dev;
 	struct gpio_irq_chip *girq;
 	int err;
@@ -347,6 +353,12 @@ static int ep93xx_gpio_add_bank(struct g
 	girq = &gc->irq;
 	if (bank->has_irq || bank->has_hierarchical_irq) {
 		gc->set_config = ep93xx_gpio_set_config;
+		egc->eic = devm_kcalloc(dev, 1,
+					sizeof(*egc->eic),
+					GFP_KERNEL);
+		if (!egc->eic)
+			return -ENOMEM;
+		egc->eic->irq_offset = bank->irq;
 		girq->chip = &ep93xx_gpio_irq_chip;
 	}
 
@@ -415,7 +427,7 @@ static int ep93xx_gpio_probe(struct plat
 		return PTR_ERR(epg->base);
 
 	for (i = 0; i < ARRAY_SIZE(ep93xx_gpio_banks); i++) {
-		struct gpio_chip *gc = &epg->gc[i];
+		struct ep93xx_gpio_chip *gc = &epg->gc[i];
 		struct ep93xx_gpio_bank *bank = &ep93xx_gpio_banks[i];
 
 		if (ep93xx_gpio_add_bank(gc, pdev, epg, bank))


