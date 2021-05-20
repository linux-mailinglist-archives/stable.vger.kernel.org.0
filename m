Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 550AE38A356
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234633AbhETJvX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:51:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:48672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234350AbhETJtT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:49:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA21C61481;
        Thu, 20 May 2021 09:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503303;
        bh=qrCIjCqBCL6KkOZGcS0ZphTMXqW3/gzowVoBWCTVNEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XCdXEjRmqJJbuAdrJayuogfCEZewlPl4VFMqY4Gxn2kuk2O4TmBcUWkgrviAmfkM8
         brCwp8dSfmz86LS/fvN6Y4TCHEocJ2fGPBjRS5SSRhLcFw80wEFHk4BYftq/Mv5jMJ
         E+T+e6LMAf1g16uFi97sXG/e5H2tb9tAbS+s0wXI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Iago Abal <mail@iagoabal.eu>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 4.19 161/425] usb: gadget: pch_udc: Revert d3cb25a12138 completely
Date:   Thu, 20 May 2021 11:18:50 +0200
Message-Id: <20210520092136.747889678@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit 50a318cc9b54a36f00beadf77e578a50f3620477 upstream.

The commit d3cb25a12138 ("usb: gadget: udc: fix spin_lock in pch_udc")
obviously was not thought through and had made the situation even worse
than it was before. Two changes after almost reverted it. but a few
leftovers have been left as it. With this revert d3cb25a12138 completely.

While at it, narrow down the scope of unlocked section to prevent
potential race when prot_stall is assigned.

Fixes: d3cb25a12138 ("usb: gadget: udc: fix spin_lock in pch_udc")
Fixes: 9903b6bedd38 ("usb: gadget: pch-udc: fix lock")
Fixes: 1d23d16a88e6 ("usb: gadget: pch_udc: reorder spin_[un]lock to avoid deadlock")
Cc: Iago Abal <mail@iagoabal.eu>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20210323153626.54908-5-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/pch_udc.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/drivers/usb/gadget/udc/pch_udc.c
+++ b/drivers/usb/gadget/udc/pch_udc.c
@@ -600,18 +600,22 @@ static void pch_udc_reconnect(struct pch
 static inline void pch_udc_vbus_session(struct pch_udc_dev *dev,
 					  int is_active)
 {
+	unsigned long		iflags;
+
+	spin_lock_irqsave(&dev->lock, iflags);
 	if (is_active) {
 		pch_udc_reconnect(dev);
 		dev->vbus_session = 1;
 	} else {
 		if (dev->driver && dev->driver->disconnect) {
-			spin_lock(&dev->lock);
+			spin_unlock_irqrestore(&dev->lock, iflags);
 			dev->driver->disconnect(&dev->gadget);
-			spin_unlock(&dev->lock);
+			spin_lock_irqsave(&dev->lock, iflags);
 		}
 		pch_udc_set_disconnect(dev);
 		dev->vbus_session = 0;
 	}
+	spin_unlock_irqrestore(&dev->lock, iflags);
 }
 
 /**
@@ -1168,20 +1172,25 @@ static int pch_udc_pcd_selfpowered(struc
 static int pch_udc_pcd_pullup(struct usb_gadget *gadget, int is_on)
 {
 	struct pch_udc_dev	*dev;
+	unsigned long		iflags;
 
 	if (!gadget)
 		return -EINVAL;
+
 	dev = container_of(gadget, struct pch_udc_dev, gadget);
+
+	spin_lock_irqsave(&dev->lock, iflags);
 	if (is_on) {
 		pch_udc_reconnect(dev);
 	} else {
 		if (dev->driver && dev->driver->disconnect) {
-			spin_lock(&dev->lock);
+			spin_unlock_irqrestore(&dev->lock, iflags);
 			dev->driver->disconnect(&dev->gadget);
-			spin_unlock(&dev->lock);
+			spin_lock_irqsave(&dev->lock, iflags);
 		}
 		pch_udc_set_disconnect(dev);
 	}
+	spin_unlock_irqrestore(&dev->lock, iflags);
 
 	return 0;
 }


