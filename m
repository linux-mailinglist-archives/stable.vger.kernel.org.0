Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1FA1FEDF9
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 10:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728633AbgFRInT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jun 2020 04:43:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:56670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728320AbgFRInP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jun 2020 04:43:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95E362089D;
        Thu, 18 Jun 2020 08:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592469795;
        bh=+hvO12hkRrRso7HGjM+ZnsR3lJYBF/O06Xn2EGKDvgY=;
        h=Subject:To:From:Date:From;
        b=IZ6pp4wp2Z8OdwQGPsMjR1T5uAjxLIRjw4H0VN7lLfZPf47xfOQo85D+weitRpy+R
         19q2JODgCaf11jLeEj3+onhwj+thMEq4ys2laTW/ZatITCUgZHVlfw2VHeyb4/71y0
         iFiCvr26LjkY+uCqOJc6jbJ7wqkHWc8s8C42D7lQ=
Subject: patch "usb: dwc2: Postponed gadget registration to the udc class driver" added to usb-linus
To:     Minas.Harutyunyan@synopsys.com, gregkh@linuxfoundation.org,
        hminas@synopsys.com, lkp@intel.com, marex@denx.de,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 18 Jun 2020 10:43:05 +0200
Message-ID: <1592469785250114@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: dwc2: Postponed gadget registration to the udc class driver

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 207324a321a866401b098cadf19e4a2dd6584622 Mon Sep 17 00:00:00 2001
From: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Date: Tue, 9 Jun 2020 12:28:11 +0400
Subject: usb: dwc2: Postponed gadget registration to the udc class driver

During dwc2 driver probe, after gadget registration to the udc class
driver, if exist any builtin function driver it immediately bound to
dwc2 and after init host side (dwc2_hcd_init()) stucked in host mode.
Patch postpone gadget registration after host side initialization done.

Fixes: 117777b2c3bb9 ("usb: dwc2: Move gadget probe function into platform code")
Reported-by: kbuild test robot <lkp@intel.com>
Tested-by: Marek Vasut <marex@denx.de>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Minas Harutyunyan <hminas@synopsys.com>
Link: https://lore.kernel.org/r/f21cb38fecc72a230b86155d94c7e60c9cb66f58.1591690938.git.hminas@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc2/gadget.c   |  6 ------
 drivers/usb/dwc2/platform.c | 11 +++++++++++
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index 12b98b466287..7faf5f8c056d 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -4920,12 +4920,6 @@ int dwc2_gadget_init(struct dwc2_hsotg *hsotg)
 					  epnum, 0);
 	}
 
-	ret = usb_add_gadget_udc(dev, &hsotg->gadget);
-	if (ret) {
-		dwc2_hsotg_ep_free_request(&hsotg->eps_out[0]->ep,
-					   hsotg->ctrl_req);
-		return ret;
-	}
 	dwc2_hsotg_dump(hsotg);
 
 	return 0;
diff --git a/drivers/usb/dwc2/platform.c b/drivers/usb/dwc2/platform.c
index e571c8ae65ec..c347d93eae64 100644
--- a/drivers/usb/dwc2/platform.c
+++ b/drivers/usb/dwc2/platform.c
@@ -575,6 +575,17 @@ static int dwc2_driver_probe(struct platform_device *dev)
 	if (hsotg->dr_mode == USB_DR_MODE_PERIPHERAL)
 		dwc2_lowlevel_hw_disable(hsotg);
 
+#if IS_ENABLED(CONFIG_USB_DWC2_PERIPHERAL) || \
+	IS_ENABLED(CONFIG_USB_DWC2_DUAL_ROLE)
+	/* Postponed adding a new gadget to the udc class driver list */
+	if (hsotg->gadget_enabled) {
+		retval = usb_add_gadget_udc(hsotg->dev, &hsotg->gadget);
+		if (retval) {
+			dwc2_hsotg_remove(hsotg);
+			goto error_init;
+		}
+	}
+#endif /* CONFIG_USB_DWC2_PERIPHERAL || CONFIG_USB_DWC2_DUAL_ROLE */
 	return 0;
 
 error_init:
-- 
2.27.0


