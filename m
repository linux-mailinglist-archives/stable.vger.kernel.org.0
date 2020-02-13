Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13AD615C2D8
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:39:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728366AbgBMPhd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:37:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:60224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387836AbgBMP3X (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:29:23 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BF042168B;
        Thu, 13 Feb 2020 15:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607762;
        bh=TaFRYpriDM/AUHejBc6XrY0Ki68FPo4gvMOXwfY6+CA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EAtT/UsdaUiAYbWSkMMm2b10nvtIf0s80U3yXBmIk3rylfWjR3I8jwNpj5iEbgFJH
         OpI28jjxKI2Bd3/qmW8LA52T6ZqqfOGRsM7Wi36olUOe7A3CyWTomZmOUiIDmZlpaA
         PpHm3SqiD8UfKNAdLm5nTMfIU/J/1DFgPteUX6sI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 5.5 109/120] pinctrl: baytrail: Allocate IRQ chip dynamic
Date:   Thu, 13 Feb 2020 07:21:45 -0800
Message-Id: <20200213151937.249913134@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151901.039700531@linuxfoundation.org>
References: <20200213151901.039700531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit 539d8bde72c22d760013bf81436d6bb94eb67aed upstream.

Keeping the IRQ chip definition static shares it with multiple instances
of the GPIO chip in the system. This is bad and now we get this warning
from GPIO library:

"detected irqchip that is shared with multiple gpiochips: please fix the driver."

Hence, move the IRQ chip definition from being driver static into the struct
intel_pinctrl. So a unique IRQ chip is used for each GPIO chip instance.

Fixes: 9f573b98ca50 ("pinctrl: baytrail: Update irq chip operations")
Depends-on: ca8a958e2acb ("pinctrl: baytrail: Pass irqchip when adding gpiochip")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pinctrl/intel/pinctrl-baytrail.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

--- a/drivers/pinctrl/intel/pinctrl-baytrail.c
+++ b/drivers/pinctrl/intel/pinctrl-baytrail.c
@@ -107,6 +107,7 @@ struct byt_gpio_pin_context {
 
 struct byt_gpio {
 	struct gpio_chip chip;
+	struct irq_chip irqchip;
 	struct platform_device *pdev;
 	struct pinctrl_dev *pctl_dev;
 	struct pinctrl_desc pctl_desc;
@@ -1395,15 +1396,6 @@ static int byt_irq_type(struct irq_data
 	return 0;
 }
 
-static struct irq_chip byt_irqchip = {
-	.name		= "BYT-GPIO",
-	.irq_ack	= byt_irq_ack,
-	.irq_mask	= byt_irq_mask,
-	.irq_unmask	= byt_irq_unmask,
-	.irq_set_type	= byt_irq_type,
-	.flags		= IRQCHIP_SKIP_SET_WAKE,
-};
-
 static void byt_gpio_irq_handler(struct irq_desc *desc)
 {
 	struct irq_data *data = irq_desc_get_irq_data(desc);
@@ -1551,8 +1543,15 @@ static int byt_gpio_probe(struct byt_gpi
 	if (irq_rc && irq_rc->start) {
 		struct gpio_irq_chip *girq;
 
+		vg->irqchip.name = "BYT-GPIO",
+		vg->irqchip.irq_ack = byt_irq_ack,
+		vg->irqchip.irq_mask = byt_irq_mask,
+		vg->irqchip.irq_unmask = byt_irq_unmask,
+		vg->irqchip.irq_set_type = byt_irq_type,
+		vg->irqchip.flags = IRQCHIP_SKIP_SET_WAKE,
+
 		girq = &gc->irq;
-		girq->chip = &byt_irqchip;
+		girq->chip = &vg->irqchip;
 		girq->init_hw = byt_gpio_irq_init_hw;
 		girq->parent_handler = byt_gpio_irq_handler;
 		girq->num_parents = 1;


