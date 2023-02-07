Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57D7768D835
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:07:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232206AbjBGNHk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:07:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232214AbjBGNHj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:07:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5E1635246
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:07:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 76F7CB818E8
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:06:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC444C433EF;
        Tue,  7 Feb 2023 13:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775172;
        bh=zs3eS/gc82oxlqyBtAntTvrWRIJpO7o0OutcSgAAh0Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lKcr7JYpQe0S1P7abw2NHQLwT0HKsDZVkaDubgRloT0u3iLpHBnzKoRNhNAiPzotM
         BR/JK2G+mZlSj6exSy+ypeTFzxBnMtKu0auCAZU+dFHyTZhTntU2b3cxAQL+IIFK/y
         xWcaKWOEIYPtb2nd/0yvRDjJUeVsL6m5HMosHCJY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, stable <stable@kernel.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6.1 161/208] usb: gadget: udc: do not clear gadget driver.bus
Date:   Tue,  7 Feb 2023 13:56:55 +0100
Message-Id: <20230207125641.713719096@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aaro Koskinen <aaro.koskinen@iki.fi>

commit 30d09b3131f5b1b9d54ad9b7ee171a45e21362b3 upstream.

Before the commit fc274c1e9973 ("USB: gadget: Add a new bus for gadgets")
gadget driver.bus was unused. For whatever reason, many UDC drivers set
this field explicitly to NULL in udc_start(). With the newly added gadget
bus, doing this will crash the driver during the attach.

The problem was first reported, fixed and tested with OMAP UDC and g_ether.
Other drivers are changed based on code analysis only.

Fixes: fc274c1e9973 ("USB: gadget: Add a new bus for gadgets")
Cc: stable <stable@kernel.org>
Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20230201220125.GD2415@darkstar.musicnaut.iki.fi
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/bcm63xx_udc.c   |    1 -
 drivers/usb/gadget/udc/fotg210-udc.c   |    1 -
 drivers/usb/gadget/udc/fsl_qe_udc.c    |    1 -
 drivers/usb/gadget/udc/fsl_udc_core.c  |    1 -
 drivers/usb/gadget/udc/fusb300_udc.c   |    1 -
 drivers/usb/gadget/udc/goku_udc.c      |    1 -
 drivers/usb/gadget/udc/gr_udc.c        |    1 -
 drivers/usb/gadget/udc/m66592-udc.c    |    1 -
 drivers/usb/gadget/udc/max3420_udc.c   |    1 -
 drivers/usb/gadget/udc/mv_u3d_core.c   |    1 -
 drivers/usb/gadget/udc/mv_udc_core.c   |    1 -
 drivers/usb/gadget/udc/net2272.c       |    1 -
 drivers/usb/gadget/udc/net2280.c       |    1 -
 drivers/usb/gadget/udc/omap_udc.c      |    1 -
 drivers/usb/gadget/udc/pch_udc.c       |    1 -
 drivers/usb/gadget/udc/snps_udc_core.c |    1 -
 16 files changed, 16 deletions(-)

--- a/drivers/usb/gadget/udc/bcm63xx_udc.c
+++ b/drivers/usb/gadget/udc/bcm63xx_udc.c
@@ -1830,7 +1830,6 @@ static int bcm63xx_udc_start(struct usb_
 	bcm63xx_select_phy_mode(udc, true);
 
 	udc->driver = driver;
-	driver->driver.bus = NULL;
 	udc->gadget.dev.of_node = udc->dev->of_node;
 
 	spin_unlock_irqrestore(&udc->lock, flags);
--- a/drivers/usb/gadget/udc/fotg210-udc.c
+++ b/drivers/usb/gadget/udc/fotg210-udc.c
@@ -1009,7 +1009,6 @@ static int fotg210_udc_start(struct usb_
 	u32 value;
 
 	/* hook up the driver */
-	driver->driver.bus = NULL;
 	fotg210->driver = driver;
 
 	/* enable device global interrupt */
--- a/drivers/usb/gadget/udc/fsl_qe_udc.c
+++ b/drivers/usb/gadget/udc/fsl_qe_udc.c
@@ -2285,7 +2285,6 @@ static int fsl_qe_start(struct usb_gadge
 	/* lock is needed but whether should use this lock or another */
 	spin_lock_irqsave(&udc->lock, flags);
 
-	driver->driver.bus = NULL;
 	/* hook up the driver */
 	udc->driver = driver;
 	udc->gadget.speed = driver->max_speed;
--- a/drivers/usb/gadget/udc/fsl_udc_core.c
+++ b/drivers/usb/gadget/udc/fsl_udc_core.c
@@ -1943,7 +1943,6 @@ static int fsl_udc_start(struct usb_gadg
 	/* lock is needed but whether should use this lock or another */
 	spin_lock_irqsave(&udc_controller->lock, flags);
 
-	driver->driver.bus = NULL;
 	/* hook up the driver */
 	udc_controller->driver = driver;
 	spin_unlock_irqrestore(&udc_controller->lock, flags);
--- a/drivers/usb/gadget/udc/fusb300_udc.c
+++ b/drivers/usb/gadget/udc/fusb300_udc.c
@@ -1311,7 +1311,6 @@ static int fusb300_udc_start(struct usb_
 	struct fusb300 *fusb300 = to_fusb300(g);
 
 	/* hook up the driver */
-	driver->driver.bus = NULL;
 	fusb300->driver = driver;
 
 	return 0;
--- a/drivers/usb/gadget/udc/goku_udc.c
+++ b/drivers/usb/gadget/udc/goku_udc.c
@@ -1375,7 +1375,6 @@ static int goku_udc_start(struct usb_gad
 	struct goku_udc	*dev = to_goku_udc(g);
 
 	/* hook up the driver */
-	driver->driver.bus = NULL;
 	dev->driver = driver;
 
 	/*
--- a/drivers/usb/gadget/udc/gr_udc.c
+++ b/drivers/usb/gadget/udc/gr_udc.c
@@ -1906,7 +1906,6 @@ static int gr_udc_start(struct usb_gadge
 	spin_lock(&dev->lock);
 
 	/* Hook up the driver */
-	driver->driver.bus = NULL;
 	dev->driver = driver;
 
 	/* Get ready for host detection */
--- a/drivers/usb/gadget/udc/m66592-udc.c
+++ b/drivers/usb/gadget/udc/m66592-udc.c
@@ -1454,7 +1454,6 @@ static int m66592_udc_start(struct usb_g
 	struct m66592 *m66592 = to_m66592(g);
 
 	/* hook up the driver */
-	driver->driver.bus = NULL;
 	m66592->driver = driver;
 
 	m66592_bset(m66592, M66592_VBSE | M66592_URST, M66592_INTENB0);
--- a/drivers/usb/gadget/udc/max3420_udc.c
+++ b/drivers/usb/gadget/udc/max3420_udc.c
@@ -1108,7 +1108,6 @@ static int max3420_udc_start(struct usb_
 
 	spin_lock_irqsave(&udc->lock, flags);
 	/* hook up the driver */
-	driver->driver.bus = NULL;
 	udc->driver = driver;
 	udc->gadget.speed = USB_SPEED_FULL;
 
--- a/drivers/usb/gadget/udc/mv_u3d_core.c
+++ b/drivers/usb/gadget/udc/mv_u3d_core.c
@@ -1243,7 +1243,6 @@ static int mv_u3d_start(struct usb_gadge
 	}
 
 	/* hook up the driver ... */
-	driver->driver.bus = NULL;
 	u3d->driver = driver;
 
 	u3d->ep0_dir = USB_DIR_OUT;
--- a/drivers/usb/gadget/udc/mv_udc_core.c
+++ b/drivers/usb/gadget/udc/mv_udc_core.c
@@ -1359,7 +1359,6 @@ static int mv_udc_start(struct usb_gadge
 	spin_lock_irqsave(&udc->lock, flags);
 
 	/* hook up the driver ... */
-	driver->driver.bus = NULL;
 	udc->driver = driver;
 
 	udc->usb_state = USB_STATE_ATTACHED;
--- a/drivers/usb/gadget/udc/net2272.c
+++ b/drivers/usb/gadget/udc/net2272.c
@@ -1451,7 +1451,6 @@ static int net2272_start(struct usb_gadg
 		dev->ep[i].irqs = 0;
 	/* hook up the driver ... */
 	dev->softconnect = 1;
-	driver->driver.bus = NULL;
 	dev->driver = driver;
 
 	/* ... then enable host detection and ep0; and we're ready
--- a/drivers/usb/gadget/udc/net2280.c
+++ b/drivers/usb/gadget/udc/net2280.c
@@ -2423,7 +2423,6 @@ static int net2280_start(struct usb_gadg
 		dev->ep[i].irqs = 0;
 
 	/* hook up the driver ... */
-	driver->driver.bus = NULL;
 	dev->driver = driver;
 
 	retval = device_create_file(&dev->pdev->dev, &dev_attr_function);
--- a/drivers/usb/gadget/udc/omap_udc.c
+++ b/drivers/usb/gadget/udc/omap_udc.c
@@ -2066,7 +2066,6 @@ static int omap_udc_start(struct usb_gad
 	udc->softconnect = 1;
 
 	/* hook up the driver */
-	driver->driver.bus = NULL;
 	udc->driver = driver;
 	spin_unlock_irqrestore(&udc->lock, flags);
 
--- a/drivers/usb/gadget/udc/pch_udc.c
+++ b/drivers/usb/gadget/udc/pch_udc.c
@@ -2908,7 +2908,6 @@ static int pch_udc_start(struct usb_gadg
 {
 	struct pch_udc_dev	*dev = to_pch_udc(g);
 
-	driver->driver.bus = NULL;
 	dev->driver = driver;
 
 	/* get ready for ep0 traffic */
--- a/drivers/usb/gadget/udc/snps_udc_core.c
+++ b/drivers/usb/gadget/udc/snps_udc_core.c
@@ -1933,7 +1933,6 @@ static int amd5536_udc_start(struct usb_
 	struct udc *dev = to_amd5536_udc(g);
 	u32 tmp;
 
-	driver->driver.bus = NULL;
 	dev->driver = driver;
 
 	/* Some gadget drivers use both ep0 directions.


