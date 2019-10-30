Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C283E9F96
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 16:51:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727541AbfJ3Pt4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Oct 2019 11:49:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:50470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727515AbfJ3Ptw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Oct 2019 11:49:52 -0400
Received: from sasha-vm.mshome.net (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5878F20874;
        Wed, 30 Oct 2019 15:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572450591;
        bh=E+OCrg1Hgz1vdAv/f74VlJJK7oGTL8UsyW2/kOx4ziE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AOQhhjZTDXtE7i6uuq59IqpMkZKcz/Rx1sOeVSiXei7b2+YPFczbId1svAUIetMg6
         tur89H0BMF02EnZFGT6OWuCr3rujw3GNstdqnVjs9w2PxzbLu9ExsJRTurjRvUyzqP
         TXBepfBxBTVm6i5+mvuiwgUmfmT1BahfCZbDq0Ng=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Federico Ricchiuto <fed.ricchiuto@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 11/81] pinctrl: intel: Allocate IRQ chip dynamic
Date:   Wed, 30 Oct 2019 11:48:17 -0400
Message-Id: <20191030154928.9432-11-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191030154928.9432-1-sashal@kernel.org>
References: <20191030154928.9432-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 57ff2df1b952c7934d7b0e1d3a2ec403ec76edec ]

Keeping the IRQ chip definition static shares it with multiple instances of
the GPIO chip in the system. This is bad and now we get this warning from
GPIO library:

"detected irqchip that is shared with multiple gpiochips: please fix the driver."

Hence, move the IRQ chip definition from being driver static into the struct
intel_pinctrl. So a unique IRQ chip is used for each GPIO chip instance.

Fixes: ee1a6ca43dba ("pinctrl: intel: Add Intel Broxton pin controller support")
Depends-on: 5ff56b015e85 ("pinctrl: intel: Disable GPIO pin interrupts in suspend")
Reported-by: Federico Ricchiuto <fed.ricchiuto@gmail.com>
Suggested-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/intel/pinctrl-intel.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/pinctrl/intel/pinctrl-intel.c b/drivers/pinctrl/intel/pinctrl-intel.c
index a18d6eefe6726..4323796cbe118 100644
--- a/drivers/pinctrl/intel/pinctrl-intel.c
+++ b/drivers/pinctrl/intel/pinctrl-intel.c
@@ -96,6 +96,7 @@ struct intel_pinctrl_context {
  * @pctldesc: Pin controller description
  * @pctldev: Pointer to the pin controller device
  * @chip: GPIO chip in this pin controller
+ * @irqchip: IRQ chip in this pin controller
  * @soc: SoC/PCH specific pin configuration data
  * @communities: All communities in this pin controller
  * @ncommunities: Number of communities in this pin controller
@@ -108,6 +109,7 @@ struct intel_pinctrl {
 	struct pinctrl_desc pctldesc;
 	struct pinctrl_dev *pctldev;
 	struct gpio_chip chip;
+	struct irq_chip irqchip;
 	const struct intel_pinctrl_soc_data *soc;
 	struct intel_community *communities;
 	size_t ncommunities;
@@ -1081,16 +1083,6 @@ static irqreturn_t intel_gpio_irq(int irq, void *data)
 	return ret;
 }
 
-static struct irq_chip intel_gpio_irqchip = {
-	.name = "intel-gpio",
-	.irq_ack = intel_gpio_irq_ack,
-	.irq_mask = intel_gpio_irq_mask,
-	.irq_unmask = intel_gpio_irq_unmask,
-	.irq_set_type = intel_gpio_irq_type,
-	.irq_set_wake = intel_gpio_irq_wake,
-	.flags = IRQCHIP_MASK_ON_SUSPEND,
-};
-
 static int intel_gpio_add_pin_ranges(struct intel_pinctrl *pctrl,
 				     const struct intel_community *community)
 {
@@ -1140,12 +1132,22 @@ static int intel_gpio_probe(struct intel_pinctrl *pctrl, int irq)
 
 	pctrl->chip = intel_gpio_chip;
 
+	/* Setup GPIO chip */
 	pctrl->chip.ngpio = intel_gpio_ngpio(pctrl);
 	pctrl->chip.label = dev_name(pctrl->dev);
 	pctrl->chip.parent = pctrl->dev;
 	pctrl->chip.base = -1;
 	pctrl->irq = irq;
 
+	/* Setup IRQ chip */
+	pctrl->irqchip.name = dev_name(pctrl->dev);
+	pctrl->irqchip.irq_ack = intel_gpio_irq_ack;
+	pctrl->irqchip.irq_mask = intel_gpio_irq_mask;
+	pctrl->irqchip.irq_unmask = intel_gpio_irq_unmask;
+	pctrl->irqchip.irq_set_type = intel_gpio_irq_type;
+	pctrl->irqchip.irq_set_wake = intel_gpio_irq_wake;
+	pctrl->irqchip.flags = IRQCHIP_MASK_ON_SUSPEND;
+
 	ret = devm_gpiochip_add_data(pctrl->dev, &pctrl->chip, pctrl);
 	if (ret) {
 		dev_err(pctrl->dev, "failed to register gpiochip\n");
@@ -1175,15 +1177,14 @@ static int intel_gpio_probe(struct intel_pinctrl *pctrl, int irq)
 		return ret;
 	}
 
-	ret = gpiochip_irqchip_add(&pctrl->chip, &intel_gpio_irqchip, 0,
+	ret = gpiochip_irqchip_add(&pctrl->chip, &pctrl->irqchip, 0,
 				   handle_bad_irq, IRQ_TYPE_NONE);
 	if (ret) {
 		dev_err(pctrl->dev, "failed to add irqchip\n");
 		return ret;
 	}
 
-	gpiochip_set_chained_irqchip(&pctrl->chip, &intel_gpio_irqchip, irq,
-				     NULL);
+	gpiochip_set_chained_irqchip(&pctrl->chip, &pctrl->irqchip, irq, NULL);
 	return 0;
 }
 
-- 
2.20.1

