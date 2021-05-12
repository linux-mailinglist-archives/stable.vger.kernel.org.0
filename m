Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D079A37C423
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231451AbhELP3E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:29:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:58726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233875AbhELPWk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:22:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9369619B7;
        Wed, 12 May 2021 15:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832173;
        bh=d1IpXGukdJzawMYsXGhYceQVPe1rJOFaGMpvacD/6yk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pPf+eKPa9JWUF1byW+XmL/94mqNxhlmdQ4ipQ1a7eXib9rjOF1uu9nnLm+UirlIf+
         7xninmsPUbb8kuisg9lMFO7Nz3jKFDgRmqNR3fDl8Vv+MSlZyuOkE3+ryKbHHzLwjq
         SxDjxVN8O4iv5vVf+xabtaKGpcObUTTtYN1SdQjs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 171/530] usb: gadget: pch_udc: Initialize device pointer before use
Date:   Wed, 12 May 2021 16:44:41 +0200
Message-Id: <20210512144825.458066031@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 971d080212be4ce2b91047d25a657f46d3e39635 ]

During conversion to use GPIO descriptors the device pointer,
which is applied to devm_gpiod_get(), is not yet initialized.

Move initialization in the ->probe() in order to have it set before use.

Fixes: e20849a8c883 ("usb: gadget: pch_udc: Convert to use GPIO descriptors")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20210323153626.54908-6-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/pch_udc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/udc/pch_udc.c b/drivers/usb/gadget/udc/pch_udc.c
index 29e89ed6aad5..a39122f01cdb 100644
--- a/drivers/usb/gadget/udc/pch_udc.c
+++ b/drivers/usb/gadget/udc/pch_udc.c
@@ -1369,6 +1369,7 @@ static irqreturn_t pch_vbus_gpio_irq(int irq, void *data)
  */
 static int pch_vbus_gpio_init(struct pch_udc_dev *dev)
 {
+	struct device *d = &dev->pdev->dev;
 	int err;
 	int irq_num = 0;
 	struct gpio_desc *gpiod;
@@ -1377,7 +1378,7 @@ static int pch_vbus_gpio_init(struct pch_udc_dev *dev)
 	dev->vbus_gpio.intr = 0;
 
 	/* Retrieve the GPIO line from the USB gadget device */
-	gpiod = devm_gpiod_get(dev->gadget.dev.parent, NULL, GPIOD_IN);
+	gpiod = devm_gpiod_get(d, NULL, GPIOD_IN);
 	if (IS_ERR(gpiod))
 		return PTR_ERR(gpiod);
 	gpiod_set_consumer_name(gpiod, "pch_vbus");
@@ -3080,6 +3081,7 @@ static int pch_udc_probe(struct pci_dev *pdev,
 	if (retval)
 		return retval;
 
+	dev->pdev = pdev;
 	pci_set_drvdata(pdev, dev);
 
 	/* Determine BAR based on PCI ID */
@@ -3121,7 +3123,6 @@ static int pch_udc_probe(struct pci_dev *pdev,
 
 	/* device struct setup */
 	spin_lock_init(&dev->lock);
-	dev->pdev = pdev;
 	dev->gadget.ops = &pch_udc_ops;
 
 	retval = init_dma_pools(dev);
-- 
2.30.2



