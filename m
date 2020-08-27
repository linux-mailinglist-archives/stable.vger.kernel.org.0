Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 672A3253F0A
	for <lists+stable@lfdr.de>; Thu, 27 Aug 2020 09:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727970AbgH0HZD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Aug 2020 03:25:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:34352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727792AbgH0HZC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Aug 2020 03:25:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3DE722BEA;
        Thu, 27 Aug 2020 07:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598513102;
        bh=/8HS1pz1I8NVSB3l27g387m1jYKubxzNOwgQDMh2NoM=;
        h=Subject:To:From:Date:From;
        b=u++omP4WRmm6+h/l2tsgg/JnB1wQnEUzhh0zkorl5dMRNiZXTb8ehazAQV0VSf7gW
         ZcKmKGoNPSJkCLs5+PMi0qodRDkbe7203zDMyLOo76bCwh89pvVxuC+k0oIYxjmQaH
         CMjIaK6SsOqDgJlFErdIfpBSzxSVcYI+IELY44m8=
Subject: patch "USB: quirks: Ignore duplicate endpoint on Sound Devices MixPre-D" added to usb-linus
To:     stern@rowland.harvard.edu, gregkh@linuxfoundation.org,
        jcbarnoud@gmail.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 27 Aug 2020 09:25:16 +0200
Message-ID: <159851311682184@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: quirks: Ignore duplicate endpoint on Sound Devices MixPre-D

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 068834a2773b6a12805105cfadbb3d4229fc6e0a Mon Sep 17 00:00:00 2001
From: Alan Stern <stern@rowland.harvard.edu>
Date: Wed, 26 Aug 2020 15:46:24 -0400
Subject: USB: quirks: Ignore duplicate endpoint on Sound Devices MixPre-D

The Sound Devices MixPre-D audio card suffers from the same defect
as the Sound Devices USBPre2: an endpoint shared between a normal
audio interface and a vendor-specific interface, in violation of the
USB spec.  Since the USB core now treats duplicated endpoints as bugs
and ignores them, the audio endpoint isn't available and the card
can't be used for audio capture.

Along the same lines as commit bdd1b147b802 ("USB: quirks: blacklist
duplicate ep on Sound Devices USBPre2"), this patch adds a quirks
entry saying to ignore ep5in for interface 1, leaving it available for
use with standard audio interface 2.

Reported-and-tested-by: Jean-Christophe Barnoud <jcbarnoud@gmail.com>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
CC: <stable@vger.kernel.org>
Fixes: 3e4f8e21c4f2 ("USB: core: fix check for duplicate endpoints")
Link: https://lore.kernel.org/r/20200826194624.GA412633@rowland.harvard.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index d1f38956b210..f232914de5fd 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -370,6 +370,10 @@ static const struct usb_device_id usb_quirk_list[] = {
 	{ USB_DEVICE(0x0926, 0x0202), .driver_info =
 			USB_QUIRK_ENDPOINT_IGNORE },
 
+	/* Sound Devices MixPre-D */
+	{ USB_DEVICE(0x0926, 0x0208), .driver_info =
+			USB_QUIRK_ENDPOINT_IGNORE },
+
 	/* Keytouch QWERTY Panel keyboard */
 	{ USB_DEVICE(0x0926, 0x3333), .driver_info =
 			USB_QUIRK_CONFIG_INTF_STRINGS },
@@ -511,6 +515,7 @@ static const struct usb_device_id usb_amd_resume_quirk_list[] = {
  */
 static const struct usb_device_id usb_endpoint_ignore[] = {
 	{ USB_DEVICE_INTERFACE_NUMBER(0x0926, 0x0202, 1), .driver_info = 0x85 },
+	{ USB_DEVICE_INTERFACE_NUMBER(0x0926, 0x0208, 1), .driver_info = 0x85 },
 	{ }
 };
 
-- 
2.28.0


