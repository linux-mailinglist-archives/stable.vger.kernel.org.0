Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 573A63D7887
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 16:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236792AbhG0Obu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 10:31:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:60452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232467AbhG0Obu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Jul 2021 10:31:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52AA3603E7;
        Tue, 27 Jul 2021 14:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627396309;
        bh=v0n9S4IhGOpgRhN8AzQKLDfaAhSsCwzPiuCcR5UeXkw=;
        h=Subject:To:From:Date:From;
        b=zPhdwN0eAJmgF0jUl6cuW3EXAkAMQQq6Ii52PMhn6ynTTRbfVOCtcXswt9rJfBLrj
         2+/1gc/SHRQNLfNKPi0WBtoFtCtTsIEwuIgRdbhZwgs/2SMWWbdEInQrFTlwJ0o0WD
         rfJb0vxJ5ldNWs9EwjtZEQb2YC8XnU38i+JSdqxw=
Subject: patch "usb: host: ohci-at91: suspend/resume ports after/before OHCI accesses" added to usb-linus
To:     claudiu.beznea@microchip.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, stern@rowland.harvard.edu
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 27 Jul 2021 16:31:39 +0200
Message-ID: <162739629923153@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: host: ohci-at91: suspend/resume ports after/before OHCI accesses

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 00de6a572f30ee93cad7e0704ec4232e5e72bda8 Mon Sep 17 00:00:00 2001
From: Claudiu Beznea <claudiu.beznea@microchip.com>
Date: Wed, 21 Jul 2021 16:29:05 +0300
Subject: usb: host: ohci-at91: suspend/resume ports after/before OHCI accesses

On SAMA7G5 suspending ports will cut the access to OHCI registers and
any subsequent access to them will lead to CPU being blocked trying to
access that memory. Same thing happens on resume: if OHCI memory is
accessed before resuming ports the CPU will block on that access. The
OCHI memory is accessed on suspend/resume though
ohci_suspend()/ohci_resume().

Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210721132905.1970713-1-claudiu.beznea@microchip.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/ohci-at91.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/host/ohci-at91.c b/drivers/usb/host/ohci-at91.c
index 9bbd7ddd0003..a24aea3d2759 100644
--- a/drivers/usb/host/ohci-at91.c
+++ b/drivers/usb/host/ohci-at91.c
@@ -611,8 +611,6 @@ ohci_hcd_at91_drv_suspend(struct device *dev)
 	if (ohci_at91->wakeup)
 		enable_irq_wake(hcd->irq);
 
-	ohci_at91_port_suspend(ohci_at91->sfr_regmap, 1);
-
 	ret = ohci_suspend(hcd, ohci_at91->wakeup);
 	if (ret) {
 		if (ohci_at91->wakeup)
@@ -632,7 +630,10 @@ ohci_hcd_at91_drv_suspend(struct device *dev)
 		/* flush the writes */
 		(void) ohci_readl (ohci, &ohci->regs->control);
 		msleep(1);
+		ohci_at91_port_suspend(ohci_at91->sfr_regmap, 1);
 		at91_stop_clock(ohci_at91);
+	} else {
+		ohci_at91_port_suspend(ohci_at91->sfr_regmap, 1);
 	}
 
 	return ret;
@@ -644,6 +645,8 @@ ohci_hcd_at91_drv_resume(struct device *dev)
 	struct usb_hcd	*hcd = dev_get_drvdata(dev);
 	struct ohci_at91_priv *ohci_at91 = hcd_to_ohci_at91_priv(hcd);
 
+	ohci_at91_port_suspend(ohci_at91->sfr_regmap, 0);
+
 	if (ohci_at91->wakeup)
 		disable_irq_wake(hcd->irq);
 	else
@@ -651,8 +654,6 @@ ohci_hcd_at91_drv_resume(struct device *dev)
 
 	ohci_resume(hcd, false);
 
-	ohci_at91_port_suspend(ohci_at91->sfr_regmap, 0);
-
 	return 0;
 }
 
-- 
2.32.0


