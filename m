Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD52B111FE4
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:16:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727993AbfLCWj7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:39:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:51148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728329AbfLCWj6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:39:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A4EC20684;
        Tue,  3 Dec 2019 22:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575412797;
        bh=tgTqtjQG6NGfPPv7jrHYBh94wvo1lsYwTXU/+/CmpLE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P1yBEB9MMJWGDPGTdJrHKSUvsGgnYfZgp4PeipxFNOzaofdmnlhPTvQJ12dpsoNM4
         WZ8mq+kGZisbCf44kPD5DuOFVfR3uzjmjtpodAgtNiOAKmwParHnUaBnWRHJv5HyWz
         cL0hzKNxfTnKF8l3NzPSmTIhPP9NBbDFcVhf5I9E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 020/135] pinctrl: cherryview: Allocate IRQ chip dynamic
Date:   Tue,  3 Dec 2019 23:34:20 +0100
Message-Id: <20191203213009.800350907@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203213005.828543156@linuxfoundation.org>
References: <20191203213005.828543156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 67d33aecd030226f0a577eb683aaa6853ecf8f91 ]

Keeping the IRQ chip definition static shares it with multiple instances
of the GPIO chip in the system. This is bad and now we get this warning
from GPIO library:

"detected irqchip that is shared with multiple gpiochips: please fix the driver."

Hence, move the IRQ chip definition from being driver static into the struct
intel_pinctrl. So a unique IRQ chip is used for each GPIO chip instance.

This patch is heavily based on the attachment to the bug by Christoph Marz.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=202543
Fixes: 6e08d6bbebeb ("pinctrl: Add Intel Cherryview/Braswell pin controller support")
Depends-on: 83b9dc11312f ("pinctrl: cherryview: Associate IRQ descriptors to irqdomain")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/intel/pinctrl-cherryview.c | 24 +++++++++++-----------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/pinctrl/intel/pinctrl-cherryview.c b/drivers/pinctrl/intel/pinctrl-cherryview.c
index 17a248b723b9b..8dfaf8e8c3a09 100644
--- a/drivers/pinctrl/intel/pinctrl-cherryview.c
+++ b/drivers/pinctrl/intel/pinctrl-cherryview.c
@@ -147,6 +147,7 @@ struct chv_pin_context {
  * @pctldesc: Pin controller description
  * @pctldev: Pointer to the pin controller device
  * @chip: GPIO chip in this pin controller
+ * @irqchip: IRQ chip in this pin controller
  * @regs: MMIO registers
  * @intr_lines: Stores mapping between 16 HW interrupt wires and GPIO
  *		offset (in GPIO number space)
@@ -162,6 +163,7 @@ struct chv_pinctrl {
 	struct pinctrl_desc pctldesc;
 	struct pinctrl_dev *pctldev;
 	struct gpio_chip chip;
+	struct irq_chip irqchip;
 	void __iomem *regs;
 	unsigned intr_lines[16];
 	const struct chv_community *community;
@@ -1466,16 +1468,6 @@ static int chv_gpio_irq_type(struct irq_data *d, unsigned int type)
 	return 0;
 }
 
-static struct irq_chip chv_gpio_irqchip = {
-	.name = "chv-gpio",
-	.irq_startup = chv_gpio_irq_startup,
-	.irq_ack = chv_gpio_irq_ack,
-	.irq_mask = chv_gpio_irq_mask,
-	.irq_unmask = chv_gpio_irq_unmask,
-	.irq_set_type = chv_gpio_irq_type,
-	.flags = IRQCHIP_SKIP_SET_WAKE,
-};
-
 static void chv_gpio_irq_handler(struct irq_desc *desc)
 {
 	struct gpio_chip *gc = irq_desc_get_handler_data(desc);
@@ -1615,7 +1607,15 @@ static int chv_gpio_probe(struct chv_pinctrl *pctrl, int irq)
 		}
 	}
 
-	ret = gpiochip_irqchip_add(chip, &chv_gpio_irqchip, 0,
+	pctrl->irqchip.name = "chv-gpio";
+	pctrl->irqchip.irq_startup = chv_gpio_irq_startup;
+	pctrl->irqchip.irq_ack = chv_gpio_irq_ack;
+	pctrl->irqchip.irq_mask = chv_gpio_irq_mask;
+	pctrl->irqchip.irq_unmask = chv_gpio_irq_unmask;
+	pctrl->irqchip.irq_set_type = chv_gpio_irq_type;
+	pctrl->irqchip.flags = IRQCHIP_SKIP_SET_WAKE;
+
+	ret = gpiochip_irqchip_add(chip, &pctrl->irqchip, 0,
 				   handle_bad_irq, IRQ_TYPE_NONE);
 	if (ret) {
 		dev_err(pctrl->dev, "failed to add IRQ chip\n");
@@ -1632,7 +1632,7 @@ static int chv_gpio_probe(struct chv_pinctrl *pctrl, int irq)
 		}
 	}
 
-	gpiochip_set_chained_irqchip(chip, &chv_gpio_irqchip, irq,
+	gpiochip_set_chained_irqchip(chip, &pctrl->irqchip, irq,
 				     chv_gpio_irq_handler);
 	return 0;
 }
-- 
2.20.1



