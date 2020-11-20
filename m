Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 200C12BAEFC
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 16:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728397AbgKTPcW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 10:32:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:35890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728125AbgKTPcV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Nov 2020 10:32:21 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A10122D0A;
        Fri, 20 Nov 2020 15:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605886341;
        bh=LNejVOTz4b+SSz/UOzPECBdP4fj5rJBFfFWMUipnmpk=;
        h=Subject:To:From:Date:From;
        b=ksatC/izkOEPetZxV7YihwFs69Jovr/7wCe5bUwhmJB+6S8Ftf4lK0zXzui6RlU0g
         Vzz4CcQb0D0owhNwBORB5Czy5Mg10IoAXd21tV0vfeKDCpZh5y0bBPdNI5kvIZTrED
         rAt7jmu7EmGUO74y5sWoou6RhWe21bDBSVIvNa/g=
Subject: patch "USB: quirks: Add USB_QUIRK_DISCONNECT_SUSPEND quirk for Lenovo A630Z" added to usb-linus
To:     penghao@uniontech.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 20 Nov 2020 16:33:03 +0100
Message-ID: <1605886383241186@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: quirks: Add USB_QUIRK_DISCONNECT_SUSPEND quirk for Lenovo A630Z

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 9ca57518361418ad5ae7dc38a2128fbf4855e1a2 Mon Sep 17 00:00:00 2001
From: penghao <penghao@uniontech.com>
Date: Wed, 18 Nov 2020 20:30:39 +0800
Subject: USB: quirks: Add USB_QUIRK_DISCONNECT_SUSPEND quirk for Lenovo A630Z
 TIO built-in usb-audio card

Add a USB_QUIRK_DISCONNECT_SUSPEND quirk for the Lenovo TIO built-in
usb-audio. when A630Z going into S3,the system immediately wakeup 7-8
seconds later by usb-audio disconnect interrupt to avoids the issue.
eg dmesg:
....
[  626.974091 ] usb 7-1.1: USB disconnect, device number 3
....
....
[ 1774.486691] usb 7-1.1: new full-speed USB device number 5 using xhci_hcd
[ 1774.947742] usb 7-1.1: New USB device found, idVendor=17ef, idProduct=a012, bcdDevice= 0.55
[ 1774.956588] usb 7-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[ 1774.964339] usb 7-1.1: Product: Thinkcentre TIO24Gen3 for USB-audio
[ 1774.970999] usb 7-1.1: Manufacturer: Lenovo
[ 1774.975447] usb 7-1.1: SerialNumber: 000000000000
[ 1775.048590] usb 7-1.1: 2:1: cannot get freq at ep 0x1
.......
Seeking a better fix, we've tried a lot of things, including:
 - Check that the device's power/wakeup is disabled
 - Check that remote wakeup is off at the USB level
 - All the quirks in drivers/usb/core/quirks.c
   e.g. USB_QUIRK_RESET_RESUME,
        USB_QUIRK_RESET,
        USB_QUIRK_IGNORE_REMOTE_WAKEUP,
        USB_QUIRK_NO_LPM.

but none of that makes any difference.

There are no errors in the logs showing any suspend/resume-related issues.
When the system wakes up due to the modem, log-wise it appears to be a
normal resume.

Introduce a quirk to disable the port during suspend when the modem is
detected.

Signed-off-by: penghao <penghao@uniontech.com>
Link: https://lore.kernel.org/r/20201118123039.11696-1-penghao@uniontech.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index a1e3a037a289..f536ea9fe945 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -421,6 +421,10 @@ static const struct usb_device_id usb_quirk_list[] = {
 	{ USB_DEVICE(0x1532, 0x0116), .driver_info =
 			USB_QUIRK_LINEAR_UFRAME_INTR_BINTERVAL },
 
+	/* Lenovo ThinkCenter A630Z TI024Gen3 usb-audio */
+	{ USB_DEVICE(0x17ef, 0xa012), .driver_info =
+			USB_QUIRK_DISCONNECT_SUSPEND },
+
 	/* BUILDWIN Photo Frame */
 	{ USB_DEVICE(0x1908, 0x1315), .driver_info =
 			USB_QUIRK_HONOR_BNUMINTERFACES },
-- 
2.29.2


