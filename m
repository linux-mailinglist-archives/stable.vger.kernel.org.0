Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8459A3D7794
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 15:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232201AbhG0N4A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 09:56:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:51034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232185AbhG0Nz7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Jul 2021 09:55:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98C4361A8D;
        Tue, 27 Jul 2021 13:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627394159;
        bh=HIcbdGOgjlznJDMRmqDvBgc338dD0wxpA32QFKMCvYQ=;
        h=Subject:To:From:Date:From;
        b=dO/V0d1ULQM1h2JGUcbutSxLm9Yli6+chvUmVZWmIBsp86ngVw1n46ihobpo0sk34
         gMPTDzIoq77jHowwDQkXLdyQKvkp3dutNsX2Oi53th76iRRp4vUUBcuKOFkeoMjva0
         wnbR1OAc1DpPXq+TLTTvye3dX7ADq/zAeMvmWJ2Y=
Subject: patch "usb: gadget: remove leaked entry from udc driver list" added to usb-linus
To:     zhangqilong3@huawei.com, balbi@kernel.org,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 27 Jul 2021 15:55:57 +0200
Message-ID: <162739415778155@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: gadget: remove leaked entry from udc driver list

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From fa4a8dcfd51b911f101ebc461dfe22230b74dd64 Mon Sep 17 00:00:00 2001
From: Zhang Qilong <zhangqilong3@huawei.com>
Date: Tue, 27 Jul 2021 15:31:42 +0800
Subject: usb: gadget: remove leaked entry from udc driver list

The usb_add_gadget_udc will add a new gadget to the udc class
driver list. Not calling usb_del_gadget_udc in error branch
will result in residual gadget entry in the udc driver list.
We fix it by calling usb_del_gadget_udc to clean it when error
return.

Fixes: 48ba02b2e2b1 ("usb: gadget: add udc driver for max3420")
Acked-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Link: https://lore.kernel.org/r/20210727073142.84666-1-zhangqilong3@huawei.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/max3420_udc.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/gadget/udc/max3420_udc.c b/drivers/usb/gadget/udc/max3420_udc.c
index 34f4db554977..d2a2b20cc1ad 100644
--- a/drivers/usb/gadget/udc/max3420_udc.c
+++ b/drivers/usb/gadget/udc/max3420_udc.c
@@ -1255,12 +1255,14 @@ static int max3420_probe(struct spi_device *spi)
 	err = devm_request_irq(&spi->dev, irq, max3420_irq_handler, 0,
 			       "max3420", udc);
 	if (err < 0)
-		return err;
+		goto del_gadget;
 
 	udc->thread_task = kthread_create(max3420_thread, udc,
 					  "max3420-thread");
-	if (IS_ERR(udc->thread_task))
-		return PTR_ERR(udc->thread_task);
+	if (IS_ERR(udc->thread_task)) {
+		err = PTR_ERR(udc->thread_task);
+		goto del_gadget;
+	}
 
 	irq = of_irq_get_byname(spi->dev.of_node, "vbus");
 	if (irq <= 0) { /* no vbus irq implies self-powered design */
@@ -1280,10 +1282,14 @@ static int max3420_probe(struct spi_device *spi)
 		err = devm_request_irq(&spi->dev, irq,
 				       max3420_vbus_handler, 0, "vbus", udc);
 		if (err < 0)
-			return err;
+			goto del_gadget;
 	}
 
 	return 0;
+
+del_gadget:
+	usb_del_gadget_udc(&udc->gadget);
+	return err;
 }
 
 static int max3420_remove(struct spi_device *spi)
-- 
2.32.0


