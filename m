Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 867E4205967
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 19:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387713AbgFWRkG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 13:40:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:33258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387517AbgFWRgP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 13:36:15 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6EB03207D0;
        Tue, 23 Jun 2020 17:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592933774;
        bh=vAxBLdt3Y/Y1TxUezjMBmZChx3eOzeg6eGD0u+ydckw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0jJr/4tweJeW2SRQRCrs7trquBwufJORXxkHurkSszYZJT/ujH+yGs0DLtOvPVs02
         6xf+pVt0WNY2yuYSKSVlrwdo0lzD63k+2BpN2JjTUXR2wu9RYnpcsAsxS8WU6YLYUV
         gW71YELkLwz3cxhbvWN8rzzF/v+I/R5ze7SIWME8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 12/24] pinctrl: qcom: spmi-gpio: fix warning about irq chip reusage
Date:   Tue, 23 Jun 2020 13:35:47 -0400
Message-Id: <20200623173559.1355728-12-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200623173559.1355728-1-sashal@kernel.org>
References: <20200623173559.1355728-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 5e50311556c9f409a85740e3cb4c4511e7e27da0 ]

Fix the following warnings caused by reusage of the same irq_chip
instance for all spmi-gpio gpio_irq_chip instances. Instead embed
irq_chip into pmic_gpio_state struct.

gpio gpiochip2: (c440000.qcom,spmi:pmic@2:gpio@c000): detected irqchip that is shared with multiple gpiochips: please fix the driver.
gpio gpiochip3: (c440000.qcom,spmi:pmic@4:gpio@c000): detected irqchip that is shared with multiple gpiochips: please fix the driver.
gpio gpiochip4: (c440000.qcom,spmi:pmic@a:gpio@c000): detected irqchip that is shared with multiple gpiochips: please fix the driver.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Acked-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20200604002817.667160-1-dmitry.baryshkov@linaro.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/qcom/pinctrl-spmi-gpio.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/pinctrl/qcom/pinctrl-spmi-gpio.c b/drivers/pinctrl/qcom/pinctrl-spmi-gpio.c
index f1fece5b9c06a..3769ad08eadfe 100644
--- a/drivers/pinctrl/qcom/pinctrl-spmi-gpio.c
+++ b/drivers/pinctrl/qcom/pinctrl-spmi-gpio.c
@@ -170,6 +170,7 @@ struct pmic_gpio_state {
 	struct regmap	*map;
 	struct pinctrl_dev *ctrl;
 	struct gpio_chip chip;
+	struct irq_chip irq;
 };
 
 static const struct pinconf_generic_params pmic_gpio_bindings[] = {
@@ -917,16 +918,6 @@ static int pmic_gpio_populate(struct pmic_gpio_state *state,
 	return 0;
 }
 
-static struct irq_chip pmic_gpio_irq_chip = {
-	.name = "spmi-gpio",
-	.irq_ack = irq_chip_ack_parent,
-	.irq_mask = irq_chip_mask_parent,
-	.irq_unmask = irq_chip_unmask_parent,
-	.irq_set_type = irq_chip_set_type_parent,
-	.irq_set_wake = irq_chip_set_wake_parent,
-	.flags = IRQCHIP_MASK_ON_SUSPEND,
-};
-
 static int pmic_gpio_domain_translate(struct irq_domain *domain,
 				      struct irq_fwspec *fwspec,
 				      unsigned long *hwirq,
@@ -1053,8 +1044,16 @@ static int pmic_gpio_probe(struct platform_device *pdev)
 	if (!parent_domain)
 		return -ENXIO;
 
+	state->irq.name = "spmi-gpio",
+	state->irq.irq_ack = irq_chip_ack_parent,
+	state->irq.irq_mask = irq_chip_mask_parent,
+	state->irq.irq_unmask = irq_chip_unmask_parent,
+	state->irq.irq_set_type = irq_chip_set_type_parent,
+	state->irq.irq_set_wake = irq_chip_set_wake_parent,
+	state->irq.flags = IRQCHIP_MASK_ON_SUSPEND,
+
 	girq = &state->chip.irq;
-	girq->chip = &pmic_gpio_irq_chip;
+	girq->chip = &state->irq;
 	girq->default_type = IRQ_TYPE_NONE;
 	girq->handler = handle_level_irq;
 	girq->fwnode = of_node_to_fwnode(state->dev->of_node);
-- 
2.25.1

