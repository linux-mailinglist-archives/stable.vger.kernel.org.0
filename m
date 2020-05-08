Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5057E1CB031
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727932AbgEHMgy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:36:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:50696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727924AbgEHMgw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:36:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96267215A4;
        Fri,  8 May 2020 12:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941412;
        bh=R5/MnEENW1ugJTHzrpdiTghDXLkx8GSyE7iLbcIFaws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xld9MRgSE+NFJJgI6CI2R/uqqJJr3WHI+VPPV7q+t+pFRtD6aKSRMnZYhJgd89ubD
         U1JAgo7g5Cx+huCFLiCcHlryI8R6s4pg22C9rBWQhbZTy0M/WtJN4Bc6nMP7/PKMZ6
         jMETkjvOnn3R0Y8unz/Zeriy5BJekX79vNGtm+s8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>
Subject: [PATCH 4.4 006/312] usb: gadged: pch_udc: get rid of redundant assignments
Date:   Fri,  8 May 2020 14:29:57 +0200
Message-Id: <20200508123124.973066152@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit 6b968737c3efe7cdaa5407afec972cd7c7d3ca35 upstream.

It seems there are leftovers of some assignments which are not used
anymore.  Compiler even warns us about:

drivers/usb/gadget/udc/pch_udc.c:2022:22: warning: variable ‘dev’ set \
but not used [-Wunused-but-set-variable]

drivers/usb/gadget/udc/pch_udc.c:2639:9: warning: variable ‘ret’ set \
but not used [-Wunused-but-set-variable]

Remove them and shut compiler about.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/udc/pch_udc.c |   18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

--- a/drivers/usb/gadget/udc/pch_udc.c
+++ b/drivers/usb/gadget/udc/pch_udc.c
@@ -1731,14 +1731,12 @@ static int pch_udc_pcd_ep_enable(struct
 static int pch_udc_pcd_ep_disable(struct usb_ep *usbep)
 {
 	struct pch_udc_ep	*ep;
-	struct pch_udc_dev	*dev;
 	unsigned long	iflags;
 
 	if (!usbep)
 		return -EINVAL;
 
 	ep = container_of(usbep, struct pch_udc_ep, ep);
-	dev = ep->dev;
 	if ((usbep->name == ep0_string) || !ep->ep.desc)
 		return -EINVAL;
 
@@ -1769,12 +1767,10 @@ static struct usb_request *pch_udc_alloc
 	struct pch_udc_request		*req;
 	struct pch_udc_ep		*ep;
 	struct pch_udc_data_dma_desc	*dma_desc;
-	struct pch_udc_dev		*dev;
 
 	if (!usbep)
 		return NULL;
 	ep = container_of(usbep, struct pch_udc_ep, ep);
-	dev = ep->dev;
 	req = kzalloc(sizeof *req, gfp);
 	if (!req)
 		return NULL;
@@ -1947,12 +1943,10 @@ static int pch_udc_pcd_dequeue(struct us
 {
 	struct pch_udc_ep	*ep;
 	struct pch_udc_request	*req;
-	struct pch_udc_dev	*dev;
 	unsigned long		flags;
 	int ret = -EINVAL;
 
 	ep = container_of(usbep, struct pch_udc_ep, ep);
-	dev = ep->dev;
 	if (!usbep || !usbreq || (!ep->ep.desc && ep->num))
 		return ret;
 	req = container_of(usbreq, struct pch_udc_request, req);
@@ -1984,14 +1978,12 @@ static int pch_udc_pcd_dequeue(struct us
 static int pch_udc_pcd_set_halt(struct usb_ep *usbep, int halt)
 {
 	struct pch_udc_ep	*ep;
-	struct pch_udc_dev	*dev;
 	unsigned long iflags;
 	int ret;
 
 	if (!usbep)
 		return -EINVAL;
 	ep = container_of(usbep, struct pch_udc_ep, ep);
-	dev = ep->dev;
 	if (!ep->ep.desc && !ep->num)
 		return -EINVAL;
 	if (!ep->dev->driver || (ep->dev->gadget.speed == USB_SPEED_UNKNOWN))
@@ -2029,14 +2021,12 @@ static int pch_udc_pcd_set_halt(struct u
 static int pch_udc_pcd_set_wedge(struct usb_ep *usbep)
 {
 	struct pch_udc_ep	*ep;
-	struct pch_udc_dev	*dev;
 	unsigned long iflags;
 	int ret;
 
 	if (!usbep)
 		return -EINVAL;
 	ep = container_of(usbep, struct pch_udc_ep, ep);
-	dev = ep->dev;
 	if (!ep->ep.desc && !ep->num)
 		return -EINVAL;
 	if (!ep->dev->driver || (ep->dev->gadget.speed == USB_SPEED_UNKNOWN))
@@ -2646,7 +2636,7 @@ static void pch_udc_svc_enum_interrupt(s
 static void pch_udc_svc_intf_interrupt(struct pch_udc_dev *dev)
 {
 	u32 reg, dev_stat = 0;
-	int i, ret;
+	int i;
 
 	dev_stat = pch_udc_read_device_status(dev);
 	dev->cfg_data.cur_intf = (dev_stat & UDC_DEVSTS_INTF_MASK) >>
@@ -2675,7 +2665,7 @@ static void pch_udc_svc_intf_interrupt(s
 	}
 	dev->stall = 0;
 	spin_lock(&dev->lock);
-	ret = dev->driver->setup(&dev->gadget, &dev->setup_data);
+	dev->driver->setup(&dev->gadget, &dev->setup_data);
 	spin_unlock(&dev->lock);
 }
 
@@ -2686,7 +2676,7 @@ static void pch_udc_svc_intf_interrupt(s
  */
 static void pch_udc_svc_cfg_interrupt(struct pch_udc_dev *dev)
 {
-	int i, ret;
+	int i;
 	u32 reg, dev_stat = 0;
 
 	dev_stat = pch_udc_read_device_status(dev);
@@ -2712,7 +2702,7 @@ static void pch_udc_svc_cfg_interrupt(st
 
 	/* call gadget zero with setup data received */
 	spin_lock(&dev->lock);
-	ret = dev->driver->setup(&dev->gadget, &dev->setup_data);
+	dev->driver->setup(&dev->gadget, &dev->setup_data);
 	spin_unlock(&dev->lock);
 }
 


