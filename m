Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E29A92839FA
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727728AbgJEPaH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:30:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:56180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727194AbgJEP36 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:29:58 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D71D2085B;
        Mon,  5 Oct 2020 15:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601911797;
        bh=BsY/V1JlSmPOX1FckZNI8kjOlHLIdVse29hqLSQ6Y5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tyZysqq/3aGl5asclEJKnnRug9azI+dX0QQpxgfw/gdUuBRa3jEQXVjuqRa2m4r0N
         Rpa5/U8niZb6K5UJKYFMw3u62fynAtkuAVkuNn8BPLjErKOV9QFfy3lnWLuw79f2T4
         pz/IHfsp4LRN5ifIc8o05mr9c6fYUQTExDvO+W+Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeremy Kerr <jk@codeconstruct.com.au>,
        Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>,
        Rob Herring <robh@kernel.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 40/57] gpio/aspeed-sgpio: enable access to all 80 input & output sgpios
Date:   Mon,  5 Oct 2020 17:26:52 +0200
Message-Id: <20201005142111.736728982@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142109.796046410@linuxfoundation.org>
References: <20201005142109.796046410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeremy Kerr <jk@codeconstruct.com.au>

[ Upstream commit ac67b07e268d46eba675a60c37051bb3e59fd201 ]

Currently, the aspeed-sgpio driver exposes up to 80 GPIO lines,
corresponding to the 80 status bits available in hardware. Each of these
lines can be configured as either an input or an output.

However, each of these GPIOs is actually an input *and* an output; we
actually have 80 inputs plus 80 outputs.

This change expands the maximum number of GPIOs to 160; the lower half
of this range are the input-only GPIOs, the upper half are the outputs.
We fix the GPIO directions to correspond to this mapping.

This also fixes a bug when setting GPIOs - we were reading from the
input register, making it impossible to set more than one output GPIO.

Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
Fixes: 7db47faae79b ("gpio: aspeed: Add SGPIO driver")
Reviewed-by: Joel Stanley <joel@jms.id.au>
Reviewed-by: Andrew Jeffery <andrew@aj.id.au>
Acked-by: Rob Herring <robh@kernel.org>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/gpio/sgpio-aspeed.txt |   5 +-
 drivers/gpio/sgpio-aspeed.c                   | 126 ++++++++++++------
 2 files changed, 87 insertions(+), 44 deletions(-)

diff --git a/Documentation/devicetree/bindings/gpio/sgpio-aspeed.txt b/Documentation/devicetree/bindings/gpio/sgpio-aspeed.txt
index d4d83916c09dd..be329ea4794f8 100644
--- a/Documentation/devicetree/bindings/gpio/sgpio-aspeed.txt
+++ b/Documentation/devicetree/bindings/gpio/sgpio-aspeed.txt
@@ -20,8 +20,9 @@ Required properties:
 - gpio-controller : Marks the device node as a GPIO controller
 - interrupts : Interrupt specifier, see interrupt-controller/interrupts.txt
 - interrupt-controller : Mark the GPIO controller as an interrupt-controller
-- ngpios : number of GPIO lines, see gpio.txt
-  (should be multiple of 8, up to 80 pins)
+- ngpios : number of *hardware* GPIO lines, see gpio.txt. This will expose
+  2 software GPIOs per hardware GPIO: one for hardware input, one for hardware
+  output. Up to 80 pins, must be a multiple of 8.
 - clocks : A phandle to the APB clock for SGPM clock division
 - bus-frequency : SGPM CLK frequency
 
diff --git a/drivers/gpio/sgpio-aspeed.c b/drivers/gpio/sgpio-aspeed.c
index 8319812593e31..7cd86d5e8dc90 100644
--- a/drivers/gpio/sgpio-aspeed.c
+++ b/drivers/gpio/sgpio-aspeed.c
@@ -17,7 +17,17 @@
 #include <linux/spinlock.h>
 #include <linux/string.h>
 
-#define MAX_NR_SGPIO			80
+/*
+ * MAX_NR_HW_GPIO represents the number of actual hardware-supported GPIOs (ie,
+ * slots within the clocked serial GPIO data). Since each HW GPIO is both an
+ * input and an output, we provide MAX_NR_HW_GPIO * 2 lines on our gpiochip
+ * device.
+ *
+ * We use SGPIO_OUTPUT_OFFSET to define the split between the inputs and
+ * outputs; the inputs start at line 0, the outputs start at OUTPUT_OFFSET.
+ */
+#define MAX_NR_HW_SGPIO			80
+#define SGPIO_OUTPUT_OFFSET		MAX_NR_HW_SGPIO
 
 #define ASPEED_SGPIO_CTRL		0x54
 
@@ -30,8 +40,8 @@ struct aspeed_sgpio {
 	struct clk *pclk;
 	spinlock_t lock;
 	void __iomem *base;
-	uint32_t dir_in[3];
 	int irq;
+	int n_sgpio;
 };
 
 struct aspeed_sgpio_bank {
@@ -111,31 +121,69 @@ static void __iomem *bank_reg(struct aspeed_sgpio *gpio,
 	}
 }
 
-#define GPIO_BANK(x)    ((x) >> 5)
-#define GPIO_OFFSET(x)  ((x) & 0x1f)
+#define GPIO_BANK(x)    ((x % SGPIO_OUTPUT_OFFSET) >> 5)
+#define GPIO_OFFSET(x)  ((x % SGPIO_OUTPUT_OFFSET) & 0x1f)
 #define GPIO_BIT(x)     BIT(GPIO_OFFSET(x))
 
 static const struct aspeed_sgpio_bank *to_bank(unsigned int offset)
 {
-	unsigned int bank = GPIO_BANK(offset);
+	unsigned int bank;
+
+	bank = GPIO_BANK(offset);
 
 	WARN_ON(bank >= ARRAY_SIZE(aspeed_sgpio_banks));
 	return &aspeed_sgpio_banks[bank];
 }
 
+static int aspeed_sgpio_init_valid_mask(struct gpio_chip *gc,
+		unsigned long *valid_mask, unsigned int ngpios)
+{
+	struct aspeed_sgpio *sgpio = gpiochip_get_data(gc);
+	int n = sgpio->n_sgpio;
+	int c = SGPIO_OUTPUT_OFFSET - n;
+
+	WARN_ON(ngpios < MAX_NR_HW_SGPIO * 2);
+
+	/* input GPIOs in the lower range */
+	bitmap_set(valid_mask, 0, n);
+	bitmap_clear(valid_mask, n, c);
+
+	/* output GPIOS above SGPIO_OUTPUT_OFFSET */
+	bitmap_set(valid_mask, SGPIO_OUTPUT_OFFSET, n);
+	bitmap_clear(valid_mask, SGPIO_OUTPUT_OFFSET + n, c);
+
+	return 0;
+}
+
+static void aspeed_sgpio_irq_init_valid_mask(struct gpio_chip *gc,
+		unsigned long *valid_mask, unsigned int ngpios)
+{
+	struct aspeed_sgpio *sgpio = gpiochip_get_data(gc);
+	int n = sgpio->n_sgpio;
+
+	WARN_ON(ngpios < MAX_NR_HW_SGPIO * 2);
+
+	/* input GPIOs in the lower range */
+	bitmap_set(valid_mask, 0, n);
+	bitmap_clear(valid_mask, n, ngpios - n);
+}
+
+static bool aspeed_sgpio_is_input(unsigned int offset)
+{
+	return offset < SGPIO_OUTPUT_OFFSET;
+}
+
 static int aspeed_sgpio_get(struct gpio_chip *gc, unsigned int offset)
 {
 	struct aspeed_sgpio *gpio = gpiochip_get_data(gc);
 	const struct aspeed_sgpio_bank *bank = to_bank(offset);
 	unsigned long flags;
 	enum aspeed_sgpio_reg reg;
-	bool is_input;
 	int rc = 0;
 
 	spin_lock_irqsave(&gpio->lock, flags);
 
-	is_input = gpio->dir_in[GPIO_BANK(offset)] & GPIO_BIT(offset);
-	reg = is_input ? reg_val : reg_rdata;
+	reg = aspeed_sgpio_is_input(offset) ? reg_val : reg_rdata;
 	rc = !!(ioread32(bank_reg(gpio, bank, reg)) & GPIO_BIT(offset));
 
 	spin_unlock_irqrestore(&gpio->lock, flags);
@@ -143,22 +191,31 @@ static int aspeed_sgpio_get(struct gpio_chip *gc, unsigned int offset)
 	return rc;
 }
 
-static void sgpio_set_value(struct gpio_chip *gc, unsigned int offset, int val)
+static int sgpio_set_value(struct gpio_chip *gc, unsigned int offset, int val)
 {
 	struct aspeed_sgpio *gpio = gpiochip_get_data(gc);
 	const struct aspeed_sgpio_bank *bank = to_bank(offset);
-	void __iomem *addr;
+	void __iomem *addr_r, *addr_w;
 	u32 reg = 0;
 
-	addr = bank_reg(gpio, bank, reg_val);
-	reg = ioread32(addr);
+	if (aspeed_sgpio_is_input(offset))
+		return -EINVAL;
+
+	/* Since this is an output, read the cached value from rdata, then
+	 * update val. */
+	addr_r = bank_reg(gpio, bank, reg_rdata);
+	addr_w = bank_reg(gpio, bank, reg_val);
+
+	reg = ioread32(addr_r);
 
 	if (val)
 		reg |= GPIO_BIT(offset);
 	else
 		reg &= ~GPIO_BIT(offset);
 
-	iowrite32(reg, addr);
+	iowrite32(reg, addr_w);
+
+	return 0;
 }
 
 static void aspeed_sgpio_set(struct gpio_chip *gc, unsigned int offset, int val)
@@ -175,43 +232,28 @@ static void aspeed_sgpio_set(struct gpio_chip *gc, unsigned int offset, int val)
 
 static int aspeed_sgpio_dir_in(struct gpio_chip *gc, unsigned int offset)
 {
-	struct aspeed_sgpio *gpio = gpiochip_get_data(gc);
-	unsigned long flags;
-
-	spin_lock_irqsave(&gpio->lock, flags);
-	gpio->dir_in[GPIO_BANK(offset)] |= GPIO_BIT(offset);
-	spin_unlock_irqrestore(&gpio->lock, flags);
-
-	return 0;
+	return aspeed_sgpio_is_input(offset) ? 0 : -EINVAL;
 }
 
 static int aspeed_sgpio_dir_out(struct gpio_chip *gc, unsigned int offset, int val)
 {
 	struct aspeed_sgpio *gpio = gpiochip_get_data(gc);
 	unsigned long flags;
+	int rc;
 
-	spin_lock_irqsave(&gpio->lock, flags);
-
-	gpio->dir_in[GPIO_BANK(offset)] &= ~GPIO_BIT(offset);
-	sgpio_set_value(gc, offset, val);
+	/* No special action is required for setting the direction; we'll
+	 * error-out in sgpio_set_value if this isn't an output GPIO */
 
+	spin_lock_irqsave(&gpio->lock, flags);
+	rc = sgpio_set_value(gc, offset, val);
 	spin_unlock_irqrestore(&gpio->lock, flags);
 
-	return 0;
+	return rc;
 }
 
 static int aspeed_sgpio_get_direction(struct gpio_chip *gc, unsigned int offset)
 {
-	int dir_status;
-	struct aspeed_sgpio *gpio = gpiochip_get_data(gc);
-	unsigned long flags;
-
-	spin_lock_irqsave(&gpio->lock, flags);
-	dir_status = gpio->dir_in[GPIO_BANK(offset)] & GPIO_BIT(offset);
-	spin_unlock_irqrestore(&gpio->lock, flags);
-
-	return dir_status;
-
+	return !!aspeed_sgpio_is_input(offset);
 }
 
 static void irqd_to_aspeed_sgpio_data(struct irq_data *d,
@@ -402,6 +444,7 @@ static int aspeed_sgpio_setup_irqs(struct aspeed_sgpio *gpio,
 
 	irq = &gpio->chip.irq;
 	irq->chip = &aspeed_sgpio_irqchip;
+	irq->init_valid_mask = aspeed_sgpio_irq_init_valid_mask;
 	irq->handler = handle_bad_irq;
 	irq->default_type = IRQ_TYPE_NONE;
 	irq->parent_handler = aspeed_sgpio_irq_handler;
@@ -452,11 +495,12 @@ static int __init aspeed_sgpio_probe(struct platform_device *pdev)
 	if (rc < 0) {
 		dev_err(&pdev->dev, "Could not read ngpios property\n");
 		return -EINVAL;
-	} else if (nr_gpios > MAX_NR_SGPIO) {
+	} else if (nr_gpios > MAX_NR_HW_SGPIO) {
 		dev_err(&pdev->dev, "Number of GPIOs exceeds the maximum of %d: %d\n",
-			MAX_NR_SGPIO, nr_gpios);
+			MAX_NR_HW_SGPIO, nr_gpios);
 		return -EINVAL;
 	}
+	gpio->n_sgpio = nr_gpios;
 
 	rc = of_property_read_u32(pdev->dev.of_node, "bus-frequency", &sgpio_freq);
 	if (rc < 0) {
@@ -497,7 +541,8 @@ static int __init aspeed_sgpio_probe(struct platform_device *pdev)
 	spin_lock_init(&gpio->lock);
 
 	gpio->chip.parent = &pdev->dev;
-	gpio->chip.ngpio = nr_gpios;
+	gpio->chip.ngpio = MAX_NR_HW_SGPIO * 2;
+	gpio->chip.init_valid_mask = aspeed_sgpio_init_valid_mask;
 	gpio->chip.direction_input = aspeed_sgpio_dir_in;
 	gpio->chip.direction_output = aspeed_sgpio_dir_out;
 	gpio->chip.get_direction = aspeed_sgpio_get_direction;
@@ -509,9 +554,6 @@ static int __init aspeed_sgpio_probe(struct platform_device *pdev)
 	gpio->chip.label = dev_name(&pdev->dev);
 	gpio->chip.base = -1;
 
-	/* set all SGPIO pins as input (1). */
-	memset(gpio->dir_in, 0xff, sizeof(gpio->dir_in));
-
 	aspeed_sgpio_setup_irqs(gpio, pdev);
 
 	rc = devm_gpiochip_add_data(&pdev->dev, &gpio->chip, gpio);
-- 
2.25.1



