Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FCFD32AED5
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235957AbhCCAGi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:06:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:56514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1837220AbhCBHke (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 02:40:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D99B961477;
        Tue,  2 Mar 2021 07:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614670787;
        bh=7Jt8IBi7RDbHQ/ZeWq5Aah5ApDZhtS9N4cgib63cRRw=;
        h=Subject:To:From:Date:From;
        b=ArKGUn9g3aH2jC3aV2u54/YSZ9rmGPrZqKXT7inWeq5ahDwK93U/mVBOn7ACUMGnC
         crKYbU+ekbeW/+NgYVdbjeK+p8JaNqGy02X2P0oZTAw5CUvbu5GYTt9NMnh8fO2Ec2
         mxa7ut6Cpfjv4rQq2sMVkqTAbXN8K89Yl7GDp3Qk=
Subject: patch "Goodix Fingerprint device is not a modem" added to usb-linus
To:     ydewid@gmail.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 02 Mar 2021 08:39:44 +0100
Message-ID: <1614670784142251@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Goodix Fingerprint device is not a modem

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From c9de574e76bc3862f34b9fca77dfb88ceffd2556 Mon Sep 17 00:00:00 2001
From: Yorick de Wid <ydewid@gmail.com>
Date: Sat, 13 Feb 2021 15:49:02 +0100
Subject: Goodix Fingerprint device is not a modem

The CDC ACM driver is false matching the Goodix Fingerprint device
against the USB_CDC_ACM_PROTO_AT_V25TER.

The Goodix Fingerprint device is a biometrics sensor that should be
handled in user-space. libfprint has some support for Goodix
fingerprint sensors, although not for this particular one. It is
possible that the vendor allocates a PID per OEM (Lenovo, Dell etc).
If this happens to be the case then more devices from the same vendor
could potentially match the ACM modem module table.

Signed-off-by: Yorick de Wid <ydewid@gmail.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210213144901.53199-1-ydewid@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-acm.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 37f824b59daa..39ddb5585ded 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1935,6 +1935,11 @@ static const struct usb_device_id acm_ids[] = {
 	.driver_info = SEND_ZERO_PACKET,
 	},
 
+	/* Exclude Goodix Fingerprint Reader */
+	{ USB_DEVICE(0x27c6, 0x5395),
+	.driver_info = IGNORE_DEVICE,
+	},
+
 	/* control interfaces without any protocol set */
 	{ USB_INTERFACE_INFO(USB_CLASS_COMM, USB_CDC_SUBCLASS_ACM,
 		USB_CDC_PROTO_NONE) },
-- 
2.30.1


