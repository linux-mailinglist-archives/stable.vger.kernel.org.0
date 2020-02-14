Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6231B15F526
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:39:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729708AbgBNPtH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:49:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:51502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729661AbgBNPtF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:49:05 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60093217F4;
        Fri, 14 Feb 2020 15:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695345;
        bh=3pIb4yfT4IjHSbrhI4mKZgerReA1bKjGWWVF/yKGFvU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UjrOGllDdQ+j1+HGlpIkcCXtNfpCOQJJuj0ziaCxl3+/t0TjtU8TrAlac56mHVYtK
         ybvzc69TDWXvCe/4tUnVn3jg6v2DxPISc8GQ0f6WapaS6oVWKNi8Z3eSS5airpT/eU
         Tdp4RRlFIn4ld0dHaTnFPkxhneaDbCKHMrz9qjxQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 008/542] pinctrl: baytrail: Allocate IRQ chip dynamic
Date:   Fri, 14 Feb 2020 10:40:00 -0500
Message-Id: <20200214154854.6746-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 539d8bde72c22d760013bf81436d6bb94eb67aed ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/intel/pinctrl-baytrail.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/pinctrl/intel/pinctrl-baytrail.c b/drivers/pinctrl/intel/pinctrl-baytrail.c
index 55141d5de29e6..72ffd19448e50 100644
--- a/drivers/pinctrl/intel/pinctrl-baytrail.c
+++ b/drivers/pinctrl/intel/pinctrl-baytrail.c
@@ -107,6 +107,7 @@ struct byt_gpio_pin_context {
 
 struct byt_gpio {
 	struct gpio_chip chip;
+	struct irq_chip irqchip;
 	struct platform_device *pdev;
 	struct pinctrl_dev *pctl_dev;
 	struct pinctrl_desc pctl_desc;
@@ -1395,15 +1396,6 @@ static int byt_irq_type(struct irq_data *d, unsigned int type)
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
@@ -1551,8 +1543,15 @@ static int byt_gpio_probe(struct byt_gpio *vg)
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
-- 
2.20.1

