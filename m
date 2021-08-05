Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 278143E10BB
	for <lists+stable@lfdr.de>; Thu,  5 Aug 2021 11:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238356AbhHEJCt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Aug 2021 05:02:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:60222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232517AbhHEJCt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Aug 2021 05:02:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B519861029;
        Thu,  5 Aug 2021 09:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628154155;
        bh=H6o4eoPYw/7dQuor+RnHhXMF4VLVMSRjGMf6yCYb/rE=;
        h=Subject:To:From:Date:From;
        b=FvUarn0r6NxfTuqcda2IR3IxEj8zvhodqF8ibjwuKoWM/rPR+t+MLcO/oYZz5yk/m
         mC3RaTvMwjgpLRENnX7QsDsiiR6ZbFFIuefNrMm5RB6K1ddYbHGj8fkDH4eWMUez4w
         /GTexszXcLHYZqQEFe14UwLso/RwFi2lX22WPuak=
Subject: patch "usb: dwc3: gadget: Avoid runtime resume if disabling pullup" added to usb-linus
To:     wcheng@codeaurora.org, balbi@kernel.org,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 05 Aug 2021 11:02:24 +0200
Message-ID: <162815414450243@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: dwc3: gadget: Avoid runtime resume if disabling pullup

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From cb10f68ad8150f243964b19391711aaac5e8ff42 Mon Sep 17 00:00:00 2001
From: Wesley Cheng <wcheng@codeaurora.org>
Date: Tue, 3 Aug 2021 23:24:05 -0700
Subject: usb: dwc3: gadget: Avoid runtime resume if disabling pullup

If the device is already in the runtime suspended state, any call to
the pullup routine will issue a runtime resume on the DWC3 core
device.  If the USB gadget is disabling the pullup, then avoid having
to issue a runtime resume, as DWC3 gadget has already been
halted/stopped.

This fixes an issue where the following condition occurs:

usb_gadget_remove_driver()
-->usb_gadget_disconnect()
 -->dwc3_gadget_pullup(0)
  -->pm_runtime_get_sync() -> ret = 0
  -->pm_runtime_put() [async]
-->usb_gadget_udc_stop()
 -->dwc3_gadget_stop()
  -->dwc->gadget_driver = NULL
...

dwc3_suspend_common()
-->dwc3_gadget_suspend()
 -->DWC3 halt/stop routine skipped, driver_data == NULL

This leads to a situation where the DWC3 gadget is not properly
stopped, as the runtime resume would have re-enabled EP0 and event
interrupts, and since we avoided the DWC3 gadget suspend, these
resources were never disabled.

Fixes: 77adb8bdf422 ("usb: dwc3: gadget: Allow runtime suspend if UDC unbinded")
Cc: stable <stable@vger.kernel.org>
Acked-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Wesley Cheng <wcheng@codeaurora.org>
Link: https://lore.kernel.org/r/1628058245-30692-1-git-send-email-wcheng@codeaurora.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index a1b262669574..b8d4b2d327b2 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2256,6 +2256,17 @@ static int dwc3_gadget_pullup(struct usb_gadget *g, int is_on)
 		}
 	}
 
+	/*
+	 * Avoid issuing a runtime resume if the device is already in the
+	 * suspended state during gadget disconnect.  DWC3 gadget was already
+	 * halted/stopped during runtime suspend.
+	 */
+	if (!is_on) {
+		pm_runtime_barrier(dwc->dev);
+		if (pm_runtime_suspended(dwc->dev))
+			return 0;
+	}
+
 	/*
 	 * Check the return value for successful resume, or error.  For a
 	 * successful resume, the DWC3 runtime PM resume routine will handle
-- 
2.32.0


