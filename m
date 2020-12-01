Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B956D2C9C34
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:18:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389014AbgLAJQR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:16:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:52950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390353AbgLAJOr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:14:47 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA8EA2222E;
        Tue,  1 Dec 2020 09:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606814066;
        bh=m16Ixw9m/Hz6gIr/MdVGeIOuTyfbfZNQt+Ug09g3Its=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yEVmSQZ2Xz1Bg50X3nQ/aDS9KCLksHWPlkNw0Xi/heoO6pFZ+962iyEwVS/LuNjMi
         gCrAqEJE2bP+JnBrIACEVrYjYR8cQzL1pDsw61icALwTHMxRFQdaaGkKL+gJPXrFYW
         Srt/rqVgwMu1NFJqCEwxiAzZs/qicvKI7VU8iiG8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, penghao <penghao@uniontech.com>
Subject: [PATCH 5.9 145/152] USB: quirks: Add USB_QUIRK_DISCONNECT_SUSPEND quirk for Lenovo A630Z TIO built-in usb-audio card
Date:   Tue,  1 Dec 2020 09:54:20 +0100
Message-Id: <20201201084730.837317148@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: penghao <penghao@uniontech.com>

commit 9ca57518361418ad5ae7dc38a2128fbf4855e1a2 upstream.

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
 drivers/usb/core/quirks.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -425,6 +425,10 @@ static const struct usb_device_id usb_qu
 	{ USB_DEVICE(0x1532, 0x0116), .driver_info =
 			USB_QUIRK_LINEAR_UFRAME_INTR_BINTERVAL },
 
+	/* Lenovo ThinkCenter A630Z TI024Gen3 usb-audio */
+	{ USB_DEVICE(0x17ef, 0xa012), .driver_info =
+			USB_QUIRK_DISCONNECT_SUSPEND },
+
 	/* BUILDWIN Photo Frame */
 	{ USB_DEVICE(0x1908, 0x1315), .driver_info =
 			USB_QUIRK_HONOR_BNUMINTERFACES },


