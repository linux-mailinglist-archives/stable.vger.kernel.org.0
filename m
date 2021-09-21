Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 235C9413580
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 16:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233621AbhIUOkJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 10:40:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:34686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233606AbhIUOkJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Sep 2021 10:40:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2BB9B60F6E;
        Tue, 21 Sep 2021 14:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632235120;
        bh=YwsPvQ3KNTQpV14OdD5UQKybu2xIpUABeibO5Pemy5Y=;
        h=Subject:To:From:Date:From;
        b=voKZHCY74taRWxrMhFNlSJWCjONVqfkED+/uHMeIpX0FSfh4Jv+334spaPzbXEU9D
         cttQbuqjur5P47DbhsjoMZfNiJeL29mhvNY94tgsUHCZ323nmGQakX4RzoCPFDoF+7
         GuXl833uIdoTzaz5jBSodqnERzebapfzAQCvZCeM=
Subject: patch "usb-storage: Add quirk for ScanLogic SL11R-IDE older than 2.6c" added to usb-linus
To:     linux@zary.sk, gregkh@linuxfoundation.org, stable@vger.kernel.org,
        stern@rowland.harvard.edu
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 21 Sep 2021 16:38:30 +0200
Message-ID: <1632235110699@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb-storage: Add quirk for ScanLogic SL11R-IDE older than 2.6c

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From b55d37ef6b7db3eda9b4495a8d9b0a944ee8c67d Mon Sep 17 00:00:00 2001
From: Ondrej Zary <linux@zary.sk>
Date: Mon, 13 Sep 2021 23:01:06 +0200
Subject: usb-storage: Add quirk for ScanLogic SL11R-IDE older than 2.6c

ScanLogic SL11R-IDE with firmware older than 2.6c (the latest one) has
broken tag handling, preventing the device from working at all:
usb 1-1: new full-speed USB device number 2 using uhci_hcd
usb 1-1: New USB device found, idVendor=04ce, idProduct=0002, bcdDevice= 2.60
usb 1-1: New USB device strings: Mfr=1, Product=1, SerialNumber=0
usb 1-1: Product: USB Device
usb 1-1: Manufacturer: USB Device
usb-storage 1-1:1.0: USB Mass Storage device detected
scsi host2: usb-storage 1-1:1.0
usbcore: registered new interface driver usb-storage
usb 1-1: reset full-speed USB device number 2 using uhci_hcd
usb 1-1: reset full-speed USB device number 2 using uhci_hcd
usb 1-1: reset full-speed USB device number 2 using uhci_hcd
usb 1-1: reset full-speed USB device number 2 using uhci_hcd

Add US_FL_BULK_IGNORE_TAG to fix it. Also update my e-mail address.

2.6c is the only firmware that claims Linux compatibility.
The firmware can be upgraded using ezotgdbg utility:
https://github.com/asciilifeform/ezotgdbg

Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Ondrej Zary <linux@zary.sk>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210913210106.12717-1-linux@zary.sk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/storage/unusual_devs.h | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index efa972be2ee3..c6b3fcf90180 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -416,9 +416,16 @@ UNUSUAL_DEV(  0x04cb, 0x0100, 0x0000, 0x2210,
 		USB_SC_UFI, USB_PR_DEVICE, NULL, US_FL_FIX_INQUIRY | US_FL_SINGLE_LUN),
 
 /*
- * Reported by Ondrej Zary <linux@rainbow-software.org>
+ * Reported by Ondrej Zary <linux@zary.sk>
  * The device reports one sector more and breaks when that sector is accessed
+ * Firmwares older than 2.6c (the latest one and the only that claims Linux
+ * support) have also broken tag handling
  */
+UNUSUAL_DEV(  0x04ce, 0x0002, 0x0000, 0x026b,
+		"ScanLogic",
+		"SL11R-IDE",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_FIX_CAPACITY | US_FL_BULK_IGNORE_TAG),
 UNUSUAL_DEV(  0x04ce, 0x0002, 0x026c, 0x026c,
 		"ScanLogic",
 		"SL11R-IDE",
-- 
2.33.0


