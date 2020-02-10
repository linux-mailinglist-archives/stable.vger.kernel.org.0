Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21EF115834B
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 20:09:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727079AbgBJTJS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 14:09:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:41702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727003AbgBJTJS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 14:09:18 -0500
Received: from localhost (unknown [104.132.1.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D1902051A;
        Mon, 10 Feb 2020 19:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581361756;
        bh=kC4ga1DgMVTf4MXoajjis+Bm2loWhLnCJMkSF6r25Fw=;
        h=Subject:To:From:Date:From;
        b=FW/CECOQn6eoJV+vYs07DBNwcO5Z6CvzVkgO+TO3i2iydCJ+2WpP+17cYkSLcP1Tn
         dfzzvMZzAaC6xaMNy692Q0zavH1u3NSOTXnYRtZGcbcipl6ufKzh2M0jk6QCIUUzgC
         YN3ylefoKF2twsypOf0a1nLlPZfPWc2TdBqZ5p9Y=
Subject: patch "USB: hub: Fix the broken detection of USB3 device in SMSC hub" added to usb-linus
To:     hgajjar@de.adit-jv.com, erosca@de.adit-jv.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org,
        stern@rowland.harvard.edu
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 10 Feb 2020 11:09:16 -0800
Message-ID: <1581361756138134@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: hub: Fix the broken detection of USB3 device in SMSC hub

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 1208f9e1d758c991b0a46a1bd60c616b906bbe27 Mon Sep 17 00:00:00 2001
From: Hardik Gajjar <hgajjar@de.adit-jv.com>
Date: Thu, 6 Feb 2020 12:49:23 +0100
Subject: USB: hub: Fix the broken detection of USB3 device in SMSC hub

Renesas R-Car H3ULCB + Kingfisher Infotainment Board is either not able
to detect the USB3.0 mass storage devices or is detecting those as
USB2.0 high speed devices.

The explanation given by Renesas is that, due to a HW issue, the XHCI
driver does not wake up after going to sleep on connecting a USB3.0
device.

In order to mitigate that, disable the auto-suspend feature
specifically for SMSC hubs from hub_probe() function, as a quirk.

Renesas Kingfisher Infotainment Board has two USB3.0 ports (CN2) which
are connected via USB5534B 4-port SuperSpeed/Hi-Speed, low-power,
configurable hub controller.

[1] SanDisk USB 3.0 device detected as USB-2.0 before the patch
 [   74.036390] usb 5-1.1: new high-speed USB device number 4 using xhci-hcd
 [   74.061598] usb 5-1.1: New USB device found, idVendor=0781, idProduct=5581, bcdDevice= 1.00
 [   74.069976] usb 5-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
 [   74.077303] usb 5-1.1: Product: Ultra
 [   74.080980] usb 5-1.1: Manufacturer: SanDisk
 [   74.085263] usb 5-1.1: SerialNumber: 4C530001110208116550

[2] SanDisk USB 3.0 device detected as USB-3.0 after the patch
 [   34.565078] usb 6-1.1: new SuperSpeed Gen 1 USB device number 3 using xhci-hcd
 [   34.588719] usb 6-1.1: New USB device found, idVendor=0781, idProduct=5581, bcdDevice= 1.00
 [   34.597098] usb 6-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
 [   34.604430] usb 6-1.1: Product: Ultra
 [   34.608110] usb 6-1.1: Manufacturer: SanDisk
 [   34.612397] usb 6-1.1: SerialNumber: 4C530001110208116550

Suggested-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Hardik Gajjar <hgajjar@de.adit-jv.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: Eugeniu Rosca <erosca@de.adit-jv.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/1580989763-32291-1-git-send-email-hgajjar@de.adit-jv.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/hub.c | 15 +++++++++++++++
 drivers/usb/core/hub.h |  1 +
 2 files changed, 16 insertions(+)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 3405b146edc9..de94fa4a4ca7 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -38,7 +38,9 @@
 #include "otg_whitelist.h"
 
 #define USB_VENDOR_GENESYS_LOGIC		0x05e3
+#define USB_VENDOR_SMSC				0x0424
 #define HUB_QUIRK_CHECK_PORT_AUTOSUSPEND	0x01
+#define HUB_QUIRK_DISABLE_AUTOSUSPEND		0x02
 
 #define USB_TP_TRANSMISSION_DELAY	40	/* ns */
 #define USB_TP_TRANSMISSION_DELAY_MAX	65535	/* ns */
@@ -1731,6 +1733,10 @@ static void hub_disconnect(struct usb_interface *intf)
 	kfree(hub->buffer);
 
 	pm_suspend_ignore_children(&intf->dev, false);
+
+	if (hub->quirk_disable_autosuspend)
+		usb_autopm_put_interface(intf);
+
 	kref_put(&hub->kref, hub_release);
 }
 
@@ -1863,6 +1869,11 @@ static int hub_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	if (id->driver_info & HUB_QUIRK_CHECK_PORT_AUTOSUSPEND)
 		hub->quirk_check_port_auto_suspend = 1;
 
+	if (id->driver_info & HUB_QUIRK_DISABLE_AUTOSUSPEND) {
+		hub->quirk_disable_autosuspend = 1;
+		usb_autopm_get_interface(intf);
+	}
+
 	if (hub_configure(hub, &desc->endpoint[0].desc) >= 0)
 		return 0;
 
@@ -5599,6 +5610,10 @@ static void hub_event(struct work_struct *work)
 }
 
 static const struct usb_device_id hub_id_table[] = {
+    { .match_flags = USB_DEVICE_ID_MATCH_VENDOR | USB_DEVICE_ID_MATCH_INT_CLASS,
+      .idVendor = USB_VENDOR_SMSC,
+      .bInterfaceClass = USB_CLASS_HUB,
+      .driver_info = HUB_QUIRK_DISABLE_AUTOSUSPEND},
     { .match_flags = USB_DEVICE_ID_MATCH_VENDOR
 			| USB_DEVICE_ID_MATCH_INT_CLASS,
       .idVendor = USB_VENDOR_GENESYS_LOGIC,
diff --git a/drivers/usb/core/hub.h b/drivers/usb/core/hub.h
index a9e24e4b8df1..a97dd1ba964e 100644
--- a/drivers/usb/core/hub.h
+++ b/drivers/usb/core/hub.h
@@ -61,6 +61,7 @@ struct usb_hub {
 	unsigned		quiescing:1;
 	unsigned		disconnected:1;
 	unsigned		in_reset:1;
+	unsigned		quirk_disable_autosuspend:1;
 
 	unsigned		quirk_check_port_auto_suspend:1;
 
-- 
2.25.0


