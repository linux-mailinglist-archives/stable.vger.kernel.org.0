Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8318818B62E
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:25:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730522AbgCSNYp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:24:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:51758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730516AbgCSNYp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:24:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC2B3208D6;
        Thu, 19 Mar 2020 13:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584624284;
        bh=asXXm5ZAx8rxI2HLm2+Hw9tDjWWR0JIUOZr83UcGhGM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z4lT9kf8I04rfPoge0N4X86ONRgqrHFuCb1Y2+AefnutU2g1JVr9ZZ70qRCvUqCkw
         /6I47ad5laVSRFMskcTuGaaCzUIqi/Zz+6Hie9mAc419P2G4QlpkDTHnGReYyXKHUa
         EsvLk3gMW2svBV+DVrjRsof0YT3Ch/SlO8TXAcqQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kevin Hao <haokexin@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 01/65] gpiolib: Add support for the irqdomain which doesnt use irq_fwspec as arg
Date:   Thu, 19 Mar 2020 14:03:43 +0100
Message-Id: <20200319123926.902914624@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123926.466988514@linuxfoundation.org>
References: <20200319123926.466988514@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kevin Hao <haokexin@gmail.com>

[ Upstream commit 242587616710576808dc8d7cdf18cfe0d7bf9831 ]

Some gpio's parent irqdomain may not use the struct irq_fwspec as
argument, such as msi irqdomain. So rename the callback
populate_parent_fwspec() to populate_parent_alloc_arg() and make it
allocate and populate the specific struct which is needed by the
parent irqdomain.

Signed-off-by: Kevin Hao <haokexin@gmail.com>
Link: https://lore.kernel.org/r/20200114082821.14015-3-haokexin@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-tegra186.c             | 13 +++++--
 drivers/gpio/gpiolib.c                   | 45 +++++++++++++++---------
 drivers/pinctrl/qcom/pinctrl-spmi-gpio.c |  2 +-
 drivers/pinctrl/qcom/pinctrl-ssbi-gpio.c |  2 +-
 include/linux/gpio/driver.h              | 21 +++++------
 5 files changed, 49 insertions(+), 34 deletions(-)

diff --git a/drivers/gpio/gpio-tegra186.c b/drivers/gpio/gpio-tegra186.c
index 55b43b7ce88db..de241263d4be3 100644
--- a/drivers/gpio/gpio-tegra186.c
+++ b/drivers/gpio/gpio-tegra186.c
@@ -448,17 +448,24 @@ static int tegra186_gpio_irq_domain_translate(struct irq_domain *domain,
 	return 0;
 }
 
-static void tegra186_gpio_populate_parent_fwspec(struct gpio_chip *chip,
-						 struct irq_fwspec *fwspec,
+static void *tegra186_gpio_populate_parent_fwspec(struct gpio_chip *chip,
 						 unsigned int parent_hwirq,
 						 unsigned int parent_type)
 {
 	struct tegra_gpio *gpio = gpiochip_get_data(chip);
+	struct irq_fwspec *fwspec;
 
+	fwspec = kmalloc(sizeof(*fwspec), GFP_KERNEL);
+	if (!fwspec)
+		return NULL;
+
+	fwspec->fwnode = chip->irq.parent_domain->fwnode;
 	fwspec->param_count = 3;
 	fwspec->param[0] = gpio->soc->instance;
 	fwspec->param[1] = parent_hwirq;
 	fwspec->param[2] = parent_type;
+
+	return fwspec;
 }
 
 static int tegra186_gpio_child_to_parent_hwirq(struct gpio_chip *chip,
@@ -621,7 +628,7 @@ static int tegra186_gpio_probe(struct platform_device *pdev)
 	irq->chip = &gpio->intc;
 	irq->fwnode = of_node_to_fwnode(pdev->dev.of_node);
 	irq->child_to_parent_hwirq = tegra186_gpio_child_to_parent_hwirq;
-	irq->populate_parent_fwspec = tegra186_gpio_populate_parent_fwspec;
+	irq->populate_parent_alloc_arg = tegra186_gpio_populate_parent_fwspec;
 	irq->child_offset_to_irq = tegra186_gpio_child_offset_to_irq;
 	irq->child_irq_domain_ops.translate = tegra186_gpio_irq_domain_translate;
 	irq->handler = handle_simple_irq;
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 175c6363cf611..cdbaa8bf72f74 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -2003,7 +2003,7 @@ static int gpiochip_hierarchy_irq_domain_alloc(struct irq_domain *d,
 	irq_hw_number_t hwirq;
 	unsigned int type = IRQ_TYPE_NONE;
 	struct irq_fwspec *fwspec = data;
-	struct irq_fwspec parent_fwspec;
+	void *parent_arg;
 	unsigned int parent_hwirq;
 	unsigned int parent_type;
 	struct gpio_irq_chip *girq = &gc->irq;
@@ -2042,24 +2042,21 @@ static int gpiochip_hierarchy_irq_domain_alloc(struct irq_domain *d,
 			    NULL, NULL);
 	irq_set_probe(irq);
 
-	/*
-	 * Create a IRQ fwspec to send up to the parent irqdomain:
-	 * specify the hwirq we address on the parent and tie it
-	 * all together up the chain.
-	 */
-	parent_fwspec.fwnode = d->parent->fwnode;
 	/* This parent only handles asserted level IRQs */
-	girq->populate_parent_fwspec(gc, &parent_fwspec, parent_hwirq,
-				     parent_type);
+	parent_arg = girq->populate_parent_alloc_arg(gc, parent_hwirq, parent_type);
+	if (!parent_arg)
+		return -ENOMEM;
+
 	chip_info(gc, "alloc_irqs_parent for %d parent hwirq %d\n",
 		  irq, parent_hwirq);
 	irq_set_lockdep_class(irq, gc->irq.lock_key, gc->irq.request_key);
-	ret = irq_domain_alloc_irqs_parent(d, irq, 1, &parent_fwspec);
+	ret = irq_domain_alloc_irqs_parent(d, irq, 1, parent_arg);
 	if (ret)
 		chip_err(gc,
 			 "failed to allocate parent hwirq %d for hwirq %lu\n",
 			 parent_hwirq, hwirq);
 
+	kfree(parent_arg);
 	return ret;
 }
 
@@ -2096,8 +2093,8 @@ static int gpiochip_hierarchy_add_domain(struct gpio_chip *gc)
 	if (!gc->irq.child_offset_to_irq)
 		gc->irq.child_offset_to_irq = gpiochip_child_offset_to_irq_noop;
 
-	if (!gc->irq.populate_parent_fwspec)
-		gc->irq.populate_parent_fwspec =
+	if (!gc->irq.populate_parent_alloc_arg)
+		gc->irq.populate_parent_alloc_arg =
 			gpiochip_populate_parent_fwspec_twocell;
 
 	gpiochip_hierarchy_setup_domain_ops(&gc->irq.child_irq_domain_ops);
@@ -2123,27 +2120,43 @@ static bool gpiochip_hierarchy_is_hierarchical(struct gpio_chip *gc)
 	return !!gc->irq.parent_domain;
 }
 
-void gpiochip_populate_parent_fwspec_twocell(struct gpio_chip *chip,
-					     struct irq_fwspec *fwspec,
+void *gpiochip_populate_parent_fwspec_twocell(struct gpio_chip *chip,
 					     unsigned int parent_hwirq,
 					     unsigned int parent_type)
 {
+	struct irq_fwspec *fwspec;
+
+	fwspec = kmalloc(sizeof(*fwspec), GFP_KERNEL);
+	if (!fwspec)
+		return NULL;
+
+	fwspec->fwnode = chip->irq.parent_domain->fwnode;
 	fwspec->param_count = 2;
 	fwspec->param[0] = parent_hwirq;
 	fwspec->param[1] = parent_type;
+
+	return fwspec;
 }
 EXPORT_SYMBOL_GPL(gpiochip_populate_parent_fwspec_twocell);
 
-void gpiochip_populate_parent_fwspec_fourcell(struct gpio_chip *chip,
-					      struct irq_fwspec *fwspec,
+void *gpiochip_populate_parent_fwspec_fourcell(struct gpio_chip *chip,
 					      unsigned int parent_hwirq,
 					      unsigned int parent_type)
 {
+	struct irq_fwspec *fwspec;
+
+	fwspec = kmalloc(sizeof(*fwspec), GFP_KERNEL);
+	if (!fwspec)
+		return NULL;
+
+	fwspec->fwnode = chip->irq.parent_domain->fwnode;
 	fwspec->param_count = 4;
 	fwspec->param[0] = 0;
 	fwspec->param[1] = parent_hwirq;
 	fwspec->param[2] = 0;
 	fwspec->param[3] = parent_type;
+
+	return fwspec;
 }
 EXPORT_SYMBOL_GPL(gpiochip_populate_parent_fwspec_fourcell);
 
diff --git a/drivers/pinctrl/qcom/pinctrl-spmi-gpio.c b/drivers/pinctrl/qcom/pinctrl-spmi-gpio.c
index 653d1095bfeaf..fe0be8a6ebb7b 100644
--- a/drivers/pinctrl/qcom/pinctrl-spmi-gpio.c
+++ b/drivers/pinctrl/qcom/pinctrl-spmi-gpio.c
@@ -1060,7 +1060,7 @@ static int pmic_gpio_probe(struct platform_device *pdev)
 	girq->fwnode = of_node_to_fwnode(state->dev->of_node);
 	girq->parent_domain = parent_domain;
 	girq->child_to_parent_hwirq = pmic_gpio_child_to_parent_hwirq;
-	girq->populate_parent_fwspec = gpiochip_populate_parent_fwspec_fourcell;
+	girq->populate_parent_alloc_arg = gpiochip_populate_parent_fwspec_fourcell;
 	girq->child_offset_to_irq = pmic_gpio_child_offset_to_irq;
 	girq->child_irq_domain_ops.translate = pmic_gpio_domain_translate;
 
diff --git a/drivers/pinctrl/qcom/pinctrl-ssbi-gpio.c b/drivers/pinctrl/qcom/pinctrl-ssbi-gpio.c
index dca86886b1f99..73d986a903f1b 100644
--- a/drivers/pinctrl/qcom/pinctrl-ssbi-gpio.c
+++ b/drivers/pinctrl/qcom/pinctrl-ssbi-gpio.c
@@ -794,7 +794,7 @@ static int pm8xxx_gpio_probe(struct platform_device *pdev)
 	girq->fwnode = of_node_to_fwnode(pctrl->dev->of_node);
 	girq->parent_domain = parent_domain;
 	girq->child_to_parent_hwirq = pm8xxx_child_to_parent_hwirq;
-	girq->populate_parent_fwspec = gpiochip_populate_parent_fwspec_fourcell;
+	girq->populate_parent_alloc_arg = gpiochip_populate_parent_fwspec_fourcell;
 	girq->child_offset_to_irq = pm8xxx_child_offset_to_irq;
 	girq->child_irq_domain_ops.translate = pm8xxx_domain_translate;
 
diff --git a/include/linux/gpio/driver.h b/include/linux/gpio/driver.h
index e2480ef94c559..9bb43467ed11d 100644
--- a/include/linux/gpio/driver.h
+++ b/include/linux/gpio/driver.h
@@ -94,16 +94,15 @@ struct gpio_irq_chip {
 				     unsigned int *parent_type);
 
 	/**
-	 * @populate_parent_fwspec:
+	 * @populate_parent_alloc_arg :
 	 *
-	 * This optional callback populates the &struct irq_fwspec for the
-	 * parent's IRQ domain. If this is not specified, then
+	 * This optional callback allocates and populates the specific struct
+	 * for the parent's IRQ domain. If this is not specified, then
 	 * &gpiochip_populate_parent_fwspec_twocell will be used. A four-cell
 	 * variant named &gpiochip_populate_parent_fwspec_fourcell is also
 	 * available.
 	 */
-	void (*populate_parent_fwspec)(struct gpio_chip *chip,
-				       struct irq_fwspec *fwspec,
+	void *(*populate_parent_alloc_arg)(struct gpio_chip *chip,
 				       unsigned int parent_hwirq,
 				       unsigned int parent_type);
 
@@ -537,26 +536,22 @@ struct bgpio_pdata {
 
 #ifdef CONFIG_IRQ_DOMAIN_HIERARCHY
 
-void gpiochip_populate_parent_fwspec_twocell(struct gpio_chip *chip,
-					     struct irq_fwspec *fwspec,
+void *gpiochip_populate_parent_fwspec_twocell(struct gpio_chip *chip,
 					     unsigned int parent_hwirq,
 					     unsigned int parent_type);
-void gpiochip_populate_parent_fwspec_fourcell(struct gpio_chip *chip,
-					      struct irq_fwspec *fwspec,
+void *gpiochip_populate_parent_fwspec_fourcell(struct gpio_chip *chip,
 					      unsigned int parent_hwirq,
 					      unsigned int parent_type);
 
 #else
 
-static inline void gpiochip_populate_parent_fwspec_twocell(struct gpio_chip *chip,
-						    struct irq_fwspec *fwspec,
+static inline void *gpiochip_populate_parent_fwspec_twocell(struct gpio_chip *chip,
 						    unsigned int parent_hwirq,
 						    unsigned int parent_type)
 {
 }
 
-static inline void gpiochip_populate_parent_fwspec_fourcell(struct gpio_chip *chip,
-						     struct irq_fwspec *fwspec,
+static inline void *gpiochip_populate_parent_fwspec_fourcell(struct gpio_chip *chip,
 						     unsigned int parent_hwirq,
 						     unsigned int parent_type)
 {
-- 
2.20.1



