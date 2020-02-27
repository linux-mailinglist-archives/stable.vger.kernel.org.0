Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 831D71720BD
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:45:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730545AbgB0Nqf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:46:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:42842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730535AbgB0Nqf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:46:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E12E621D7E;
        Thu, 27 Feb 2020 13:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811194;
        bh=ajpB8eecB8S6mcm+Ep69bc4C07rF0kg9REsPpgf97+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WPWF+s/ZBBC8WVACUrOUITSvOF2I4IzurtZQnwNu+PFOxci7TP01k/TFFWSr0FXPx
         TBkhSG4+zrK8U59E/NO7uilV8uFiAkWYA2jBL/GCiFhTWaaky81/EueYXJYYX9Ok8f
         HSHMQTQdwkkxWs7W8OkywQX3/w+geDMwgORTe8xo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 037/165] usb: gadget: udc: fix possible sleep-in-atomic-context bugs in gr_probe()
Date:   Thu, 27 Feb 2020 14:35:11 +0100
Message-Id: <20200227132236.608102745@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132230.840899170@linuxfoundation.org>
References: <20200227132230.840899170@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>

[ Upstream commit 9c1ed62ae0690dfe5d5e31d8f70e70a95cb48e52 ]

The driver may sleep while holding a spinlock.
The function call path (from bottom to top) in Linux 4.19 is:

drivers/usb/gadget/udc/core.c, 1175:
	kzalloc(GFP_KERNEL) in usb_add_gadget_udc_release
drivers/usb/gadget/udc/core.c, 1272:
	usb_add_gadget_udc_release in usb_add_gadget_udc
drivers/usb/gadget/udc/gr_udc.c, 2186:
	usb_add_gadget_udc in gr_probe
drivers/usb/gadget/udc/gr_udc.c, 2183:
	spin_lock in gr_probe

drivers/usb/gadget/udc/core.c, 1195:
	mutex_lock in usb_add_gadget_udc_release
drivers/usb/gadget/udc/core.c, 1272:
	usb_add_gadget_udc_release in usb_add_gadget_udc
drivers/usb/gadget/udc/gr_udc.c, 2186:
	usb_add_gadget_udc in gr_probe
drivers/usb/gadget/udc/gr_udc.c, 2183:
	spin_lock in gr_probe

drivers/usb/gadget/udc/gr_udc.c, 212:
	debugfs_create_file in gr_probe
drivers/usb/gadget/udc/gr_udc.c, 2197:
	gr_dfs_create in gr_probe
drivers/usb/gadget/udc/gr_udc.c, 2183:
    spin_lock in gr_probe

drivers/usb/gadget/udc/gr_udc.c, 2114:
	devm_request_threaded_irq in gr_request_irq
drivers/usb/gadget/udc/gr_udc.c, 2202:
	gr_request_irq in gr_probe
drivers/usb/gadget/udc/gr_udc.c, 2183:
    spin_lock in gr_probe

kzalloc(GFP_KERNEL), mutex_lock(), debugfs_create_file() and
devm_request_threaded_irq() can sleep at runtime.

To fix these possible bugs, usb_add_gadget_udc(), gr_dfs_create() and
gr_request_irq() are called without handling the spinlock.

These bugs are found by a static analysis tool STCheck written by myself.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/gr_udc.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/gadget/udc/gr_udc.c b/drivers/usb/gadget/udc/gr_udc.c
index 39b7136d31d9c..9e246d2e55ca3 100644
--- a/drivers/usb/gadget/udc/gr_udc.c
+++ b/drivers/usb/gadget/udc/gr_udc.c
@@ -2200,8 +2200,6 @@ static int gr_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	spin_lock(&dev->lock);
-
 	/* Inside lock so that no gadget can use this udc until probe is done */
 	retval = usb_add_gadget_udc(dev->dev, &dev->gadget);
 	if (retval) {
@@ -2210,15 +2208,21 @@ static int gr_probe(struct platform_device *pdev)
 	}
 	dev->added = 1;
 
+	spin_lock(&dev->lock);
+
 	retval = gr_udc_init(dev);
-	if (retval)
+	if (retval) {
+		spin_unlock(&dev->lock);
 		goto out;
-
-	gr_dfs_create(dev);
+	}
 
 	/* Clear all interrupt enables that might be left on since last boot */
 	gr_disable_interrupts_and_pullup(dev);
 
+	spin_unlock(&dev->lock);
+
+	gr_dfs_create(dev);
+
 	retval = gr_request_irq(dev, dev->irq);
 	if (retval) {
 		dev_err(dev->dev, "Failed to request irq %d\n", dev->irq);
@@ -2247,8 +2251,6 @@ static int gr_probe(struct platform_device *pdev)
 		dev_info(dev->dev, "regs: %p, irq %d\n", dev->regs, dev->irq);
 
 out:
-	spin_unlock(&dev->lock);
-
 	if (retval)
 		gr_remove(pdev);
 
-- 
2.20.1



