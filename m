Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8B59171ECA
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:30:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387988AbgB0OaV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:30:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:41740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733260AbgB0OFJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:05:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B600E20801;
        Thu, 27 Feb 2020 14:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812309;
        bh=owgbSkQuyuKWV97co5YSL6DxPE/cE2jQQs4y/xcXZ/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PAm4P1V9EbSRcIsUYXJr7lWVoUblpv4yl2Zi2b4yMbOOGu7vNf6kSPmNBzwBpcy0l
         ANv+3NDjI1B/JegSD8zYR2AxcyGOXdAXpCyxgzO0vxYqLEV1vXLDyWLM2HIQGUns3T
         CBSQnhKyyPK+AOyxwUV7bKMmoSBLjF7UyMfnyy1M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Hardik Gajjar <hgajjar@de.adit-jv.com>,
        Eugeniu Rosca <erosca@de.adit-jv.com>
Subject: [PATCH 4.19 28/97] USB: hub: Fix the broken detection of USB3 device in SMSC hub
Date:   Thu, 27 Feb 2020 14:36:36 +0100
Message-Id: <20200227132219.193999847@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132214.553656188@linuxfoundation.org>
References: <20200227132214.553656188@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hardik Gajjar <hgajjar@de.adit-jv.com>

commit 1208f9e1d758c991b0a46a1bd60c616b906bbe27 upstream.

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
 drivers/usb/core/hub.c |   15 +++++++++++++++
 drivers/usb/core/hub.h |    1 +
 2 files changed, 16 insertions(+)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -36,7 +36,9 @@
 #include "otg_whitelist.h"
 
 #define USB_VENDOR_GENESYS_LOGIC		0x05e3
+#define USB_VENDOR_SMSC				0x0424
 #define HUB_QUIRK_CHECK_PORT_AUTOSUSPEND	0x01
+#define HUB_QUIRK_DISABLE_AUTOSUSPEND		0x02
 
 #define USB_TP_TRANSMISSION_DELAY	40	/* ns */
 #define USB_TP_TRANSMISSION_DELAY_MAX	65535	/* ns */
@@ -1695,6 +1697,10 @@ static void hub_disconnect(struct usb_in
 	kfree(hub->buffer);
 
 	pm_suspend_ignore_children(&intf->dev, false);
+
+	if (hub->quirk_disable_autosuspend)
+		usb_autopm_put_interface(intf);
+
 	kref_put(&hub->kref, hub_release);
 }
 
@@ -1825,6 +1831,11 @@ static int hub_probe(struct usb_interfac
 	if (id->driver_info & HUB_QUIRK_CHECK_PORT_AUTOSUSPEND)
 		hub->quirk_check_port_auto_suspend = 1;
 
+	if (id->driver_info & HUB_QUIRK_DISABLE_AUTOSUSPEND) {
+		hub->quirk_disable_autosuspend = 1;
+		usb_autopm_get_interface(intf);
+	}
+
 	if (hub_configure(hub, &desc->endpoint[0].desc) >= 0)
 		return 0;
 
@@ -5405,6 +5416,10 @@ out_hdev_lock:
 }
 
 static const struct usb_device_id hub_id_table[] = {
+    { .match_flags = USB_DEVICE_ID_MATCH_VENDOR | USB_DEVICE_ID_MATCH_INT_CLASS,
+      .idVendor = USB_VENDOR_SMSC,
+      .bInterfaceClass = USB_CLASS_HUB,
+      .driver_info = HUB_QUIRK_DISABLE_AUTOSUSPEND},
     { .match_flags = USB_DEVICE_ID_MATCH_VENDOR
 			| USB_DEVICE_ID_MATCH_INT_CLASS,
       .idVendor = USB_VENDOR_GENESYS_LOGIC,
--- a/drivers/usb/core/hub.h
+++ b/drivers/usb/core/hub.h
@@ -61,6 +61,7 @@ struct usb_hub {
 	unsigned		quiescing:1;
 	unsigned		disconnected:1;
 	unsigned		in_reset:1;
+	unsigned		quirk_disable_autosuspend:1;
 
 	unsigned		quirk_check_port_auto_suspend:1;
 


