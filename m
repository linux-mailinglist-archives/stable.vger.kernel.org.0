Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F16415E5A8
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:44:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393104AbgBNQVv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:21:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:56724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404904AbgBNQVt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:21:49 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2B54246C5;
        Fri, 14 Feb 2020 16:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697308;
        bh=ajpB8eecB8S6mcm+Ep69bc4C07rF0kg9REsPpgf97+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VxkshYGsZ4frBNTLtRJPmvmGWSly/LyhGp71zAZ5xERCnRwE0m5BD7I8qMhiDOXzM
         5tFod9h0OuUdmJ13EwPbVwuwmAhqNyh+FpZUaiLeKEhvXyGYkuvssxUoUBoDD4Omre
         PB/EvR7i58ew/VkipBhn4wdG/UBHpdcRndmy12e8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jia-Ju Bai <baijiaju1990@gmail.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 020/141] usb: gadget: udc: fix possible sleep-in-atomic-context bugs in gr_probe()
Date:   Fri, 14 Feb 2020 11:19:20 -0500
Message-Id: <20200214162122.19794-20-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214162122.19794-1-sashal@kernel.org>
References: <20200214162122.19794-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

