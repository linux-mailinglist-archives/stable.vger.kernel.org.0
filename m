Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E721A398D76
	for <lists+stable@lfdr.de>; Wed,  2 Jun 2021 16:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbhFBOw4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Jun 2021 10:52:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:33712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230029AbhFBOwz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 2 Jun 2021 10:52:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93571613AD;
        Wed,  2 Jun 2021 14:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622645472;
        bh=MoofaNMPSrJx2DYfO5c3J16PHX/4qCv0f1dHWFHh4ls=;
        h=Subject:To:From:Date:From;
        b=AOZ1arbIuej6esZMKqMfY9mhxc9VP2t0aqbRiKWxH0+WzLs8qHTR6hnY9QEf9IHCK
         rQSZMl4DTJzJzOb8/OXsXjgt0AsSPegKv8oFKlxXOOPSh4TrnRaG5lbeLM3Qvx95Cb
         NroYpVyC5vvWFt9Tzvs1DAgjliICuH4/fCNbcSq8=
Subject: patch "usb: dwc3: gadget: Bail from dwc3_gadget_exit() if dwc->gadget is" added to usb-linus
To:     jackp@codeaurora.org, gregkh@linuxfoundation.org,
        peter.chen@kernel.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 02 Jun 2021 16:51:09 +0200
Message-ID: <162264546935130@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: dwc3: gadget: Bail from dwc3_gadget_exit() if dwc->gadget is

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 03715ea2e3dbbc56947137ce3b4ac18a726b2f87 Mon Sep 17 00:00:00 2001
From: Jack Pham <jackp@codeaurora.org>
Date: Fri, 28 May 2021 09:04:05 -0700
Subject: usb: dwc3: gadget: Bail from dwc3_gadget_exit() if dwc->gadget is
 NULL

There exists a possible scenario in which dwc3_gadget_init() can fail:
during during host -> peripheral mode switch in dwc3_set_mode(), and
a pending gadget driver fails to bind.  Then, if the DRD undergoes
another mode switch from peripheral->host the resulting
dwc3_gadget_exit() will attempt to reference an invalid and dangling
dwc->gadget pointer as well as call dma_free_coherent() on unmapped
DMA pointers.

The exact scenario can be reproduced as follows:
 - Start DWC3 in peripheral mode
 - Configure ConfigFS gadget with FunctionFS instance (or use g_ffs)
 - Run FunctionFS userspace application (open EPs, write descriptors, etc)
 - Bind gadget driver to DWC3's UDC
 - Switch DWC3 to host mode
   => dwc3_gadget_exit() is called. usb_del_gadget() will put the
	ConfigFS driver instance on the gadget_driver_pending_list
 - Stop FunctionFS application (closes the ep files)
 - Switch DWC3 to peripheral mode
   => dwc3_gadget_init() fails as usb_add_gadget() calls
	check_pending_gadget_drivers() and attempts to rebind the UDC
	to the ConfigFS gadget but fails with -19 (-ENODEV) because the
	FFS instance is not in FFS_ACTIVE state (userspace has not
	re-opened and written the descriptors yet, i.e. desc_ready!=0).
 - Switch DWC3 back to host mode
   => dwc3_gadget_exit() is called again, but this time dwc->gadget
	is invalid.

Although it can be argued that userspace should take responsibility
for ensuring that the FunctionFS application be ready prior to
allowing the composite driver bind to the UDC, failure to do so
should not result in a panic from the kernel driver.

Fix this by setting dwc->gadget to NULL in the failure path of
dwc3_gadget_init() and add a check to dwc3_gadget_exit() to bail out
unless the gadget pointer is valid.

Fixes: e81a7018d93a ("usb: dwc3: allocate gadget structure dynamically")
Cc: <stable@vger.kernel.org>
Reviewed-by: Peter Chen <peter.chen@kernel.org>
Signed-off-by: Jack Pham <jackp@codeaurora.org>
Link: https://lore.kernel.org/r/20210528160405.17550-1-jackp@codeaurora.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 2577488456da..88270eee8a48 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -4045,6 +4045,7 @@ int dwc3_gadget_init(struct dwc3 *dwc)
 	dwc3_gadget_free_endpoints(dwc);
 err4:
 	usb_put_gadget(dwc->gadget);
+	dwc->gadget = NULL;
 err3:
 	dma_free_coherent(dwc->sysdev, DWC3_BOUNCE_SIZE, dwc->bounce,
 			dwc->bounce_addr);
@@ -4064,6 +4065,9 @@ int dwc3_gadget_init(struct dwc3 *dwc)
 
 void dwc3_gadget_exit(struct dwc3 *dwc)
 {
+	if (!dwc->gadget)
+		return;
+
 	usb_del_gadget(dwc->gadget);
 	dwc3_gadget_free_endpoints(dwc);
 	usb_put_gadget(dwc->gadget);
-- 
2.31.1


