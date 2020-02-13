Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21F1415B885
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 05:23:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729652AbgBMEXj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Feb 2020 23:23:39 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:35875 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729562AbgBMEXj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Feb 2020 23:23:39 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id ACDBB9DE;
        Wed, 12 Feb 2020 23:23:38 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 12 Feb 2020 23:23:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=mY1goK
        JEjsLN6P0abQSDS1jaO7Q7UNF18e6sfKiv/14=; b=TZ8Or2rtKm+5pZZGLStxGe
        xt2LIgXIEQPkHmi5y6UvBNlrRZr/Gw5IvJ4qTD93KqgVAuIJHVMOPwGPbEYhONIi
        UnRXeIzofJy0Ua69GJLXyzsAcL8KOvsWYgg7nKJtltFFf7JXwOBYGSktUK1py+gW
        aKOfVQHzLxX3PIyy3qGCaRYzOkJVby2FG6MuE2eCBgIFtLP8U59jPXxUMzKJ1jq/
        lWvhv2GieDvvn24maMSYe4PfFUzyQs9zxEQPHbojVauMXJJGR/E0DlC84tNGG/w3
        fyWSLOdziN53JJcGGVm4fIi4fK7mWWqHOfAOWo6lUxd3Sqq/z+wNMSvZnuUYpFuQ
        ==
X-ME-Sender: <xms:Ss9EXlnv7OzxcnyZwdRnuGLLtMFrvPv6fWr8B1c5XvppKEErKZxK-Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrieejgdejvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepvddtledrfeejrdeljedrudelgeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:Ss9EXsst-2_wzDu732XJUjqBZYmPl4MVwfGsBpVD4D6-dtu21krUhQ>
    <xmx:Ss9EXnLITqMh0NvJz-by8GLFm6umDJqlOm7q4ey_u4fzWIjvqjiQXA>
    <xmx:Ss9EXpiuLElFlsPHrFb6M1SAGhyudcx8IZs_Zd74dAD2HFJ9FJ_zqg>
    <xmx:Ss9EXv8kCOTIbQpEXY0g5RzHU39OBXgsZATOlEgEH19lSC0YnvzlAg>
Received: from localhost (unknown [209.37.97.194])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0430330606E9;
        Wed, 12 Feb 2020 23:23:37 -0500 (EST)
Subject: FAILED: patch "[PATCH] pinctrl: baytrail: Allocate IRQ chip dynamic" failed to apply to 4.9-stable tree
To:     andriy.shevchenko@linux.intel.com, mika.westerberg@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 Feb 2020 20:23:35 -0800
Message-ID: <1581567815128192@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 539d8bde72c22d760013bf81436d6bb94eb67aed Mon Sep 17 00:00:00 2001
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Thu, 24 Oct 2019 17:33:42 +0300
Subject: [PATCH] pinctrl: baytrail: Allocate IRQ chip dynamic

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

diff --git a/drivers/pinctrl/intel/pinctrl-baytrail.c b/drivers/pinctrl/intel/pinctrl-baytrail.c
index 55141d5de29e..72ffd19448e5 100644
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

