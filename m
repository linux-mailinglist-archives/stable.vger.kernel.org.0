Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4844F37C815
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238413AbhELQEi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:04:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:48386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235455AbhELP7y (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:59:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA8A361CC8;
        Wed, 12 May 2021 15:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833545;
        bh=xQ7JJKljKye7E4VXcnFMRPqTY7ARUXpzKOFkrNL9TVo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LBlYYX2UjsR9im9dm/8zT/Uf6FBT/iEMbQVyWSKo9LkkCqxE3IQXNT1UE80VEc7Gl
         6VTZwWHLTx3jYi0mgATvG+bV44BepbKgMP/l//Tdd45sfWoukcXD9nBWdKNxGjOtbD
         QZhn5I59aJBHre9iEsCAafMdEV20YVPF9D/okD0o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 193/601] usb: gadget: pch_udc: Check if driver is present before calling ->setup()
Date:   Wed, 12 May 2021 16:44:30 +0200
Message-Id: <20210512144834.188972194@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit fbdbbe6d3ee502b3bdeb4f255196bb45003614be ]

Since we have a separate routine for VBUS sense, the interrupt may occur
before gadget driver is present. Hence, ->setup() call may oops the kernel:

[   55.245843] BUG: kernel NULL pointer dereference, address: 00000010
...
[   55.245843] EIP: pch_udc_isr.cold+0x162/0x33f
...
[   55.245843]  <IRQ>
[   55.245843]  ? pch_udc_svc_data_out+0x160/0x160

Check if driver is present before calling ->setup().

Fixes: f646cf94520e ("USB device driver of Topcliff PCH")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20210323153626.54908-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/pch_udc.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/gadget/udc/pch_udc.c b/drivers/usb/gadget/udc/pch_udc.c
index f6f8965c4f8c..b46e9bdc720f 100644
--- a/drivers/usb/gadget/udc/pch_udc.c
+++ b/drivers/usb/gadget/udc/pch_udc.c
@@ -2307,6 +2307,21 @@ static void pch_udc_svc_data_out(struct pch_udc_dev *dev, int ep_num)
 		pch_udc_set_dma(dev, DMA_DIR_RX);
 }
 
+static int pch_udc_gadget_setup(struct pch_udc_dev *dev)
+	__must_hold(&dev->lock)
+{
+	int rc;
+
+	/* In some cases we can get an interrupt before driver gets setup */
+	if (!dev->driver)
+		return -ESHUTDOWN;
+
+	spin_unlock(&dev->lock);
+	rc = dev->driver->setup(&dev->gadget, &dev->setup_data);
+	spin_lock(&dev->lock);
+	return rc;
+}
+
 /**
  * pch_udc_svc_control_in() - Handle Control IN endpoint interrupts
  * @dev:	Reference to the device structure
@@ -2378,15 +2393,12 @@ static void pch_udc_svc_control_out(struct pch_udc_dev *dev)
 			dev->gadget.ep0 = &dev->ep[UDC_EP0IN_IDX].ep;
 		else /* OUT */
 			dev->gadget.ep0 = &ep->ep;
-		spin_lock(&dev->lock);
 		/* If Mass storage Reset */
 		if ((dev->setup_data.bRequestType == 0x21) &&
 		    (dev->setup_data.bRequest == 0xFF))
 			dev->prot_stall = 0;
 		/* call gadget with setup data received */
-		setup_supported = dev->driver->setup(&dev->gadget,
-						     &dev->setup_data);
-		spin_unlock(&dev->lock);
+		setup_supported = pch_udc_gadget_setup(dev);
 
 		if (dev->setup_data.bRequestType & USB_DIR_IN) {
 			ep->td_data->status = (ep->td_data->status &
@@ -2634,9 +2646,7 @@ static void pch_udc_svc_intf_interrupt(struct pch_udc_dev *dev)
 		dev->ep[i].halted = 0;
 	}
 	dev->stall = 0;
-	spin_unlock(&dev->lock);
-	dev->driver->setup(&dev->gadget, &dev->setup_data);
-	spin_lock(&dev->lock);
+	pch_udc_gadget_setup(dev);
 }
 
 /**
@@ -2671,9 +2681,7 @@ static void pch_udc_svc_cfg_interrupt(struct pch_udc_dev *dev)
 	dev->stall = 0;
 
 	/* call gadget zero with setup data received */
-	spin_unlock(&dev->lock);
-	dev->driver->setup(&dev->gadget, &dev->setup_data);
-	spin_lock(&dev->lock);
+	pch_udc_gadget_setup(dev);
 }
 
 /**
-- 
2.30.2



