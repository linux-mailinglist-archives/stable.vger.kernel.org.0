Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2BA4177EFF
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:57:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731467AbgCCRsI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:48:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:55174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730375AbgCCRsH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:48:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 233872146E;
        Tue,  3 Mar 2020 17:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583257685;
        bh=t0ILfPI1THySAeKMScXdX+yW20YuVW1b/Uuz9HQq564=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TahGh3qUtHJaIRm0It0vHgNQkb5fQz0Qptm3bxXg14wJt9wHH9yQOeqT0m+Cupwpp
         WB+f4Hd8I05748FDnNsnVMI2VnkHLjjoAlkecTa+pVjOGaQPF2hNMZgy4wnJ92H5ac
         la8tR59AEGeMRRr8sD3kUhH6wvQt9MWT+nN2JB+A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Zden=C4=9Bk=20Rampas?= <zdenda.rampas@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH 5.5 090/176] HID: ite: Only bind to keyboard USB interface on Acer SW5-012 keyboard dock
Date:   Tue,  3 Mar 2020 18:42:34 +0100
Message-Id: <20200303174315.209175263@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174304.593872177@linuxfoundation.org>
References: <20200303174304.593872177@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit beae56192a2570578ae45050e73c5ff9254f63e6 upstream.

Commit 8f18eca9ebc5 ("HID: ite: Add USB id match for Acer SW5-012 keyboard
dock") added the USB id for the Acer SW5-012's keyboard dock to the
hid-ite driver to fix the rfkill driver not working.

Most keyboard docks with an ITE 8595 keyboard/touchpad controller have the
"Wireless Radio Control" bits which need the special hid-ite driver on the
second USB interface (the mouse interface) and their touchpad only supports
mouse emulation, so using generic hid-input handling for anything but
the "Wireless Radio Control" bits is fine. On these devices we simply bind
to all USB interfaces.

But unlike other ITE8595 using keyboard docks, the Acer Aspire Switch 10
(SW5-012)'s touchpad not only does mouse emulation it also supports
HID-multitouch and all the keys including the "Wireless Radio Control"
bits have been moved to the first USB interface (the keyboard intf).

So we need hid-ite to handle the first (keyboard) USB interface and have
it NOT bind to the second (mouse) USB interface so that that can be
handled by hid-multitouch.c and we get proper multi-touch support.

This commit changes the hid_device_id for the SW5-012 keyboard dock to
only match on hid devices from the HID_GROUP_GENERIC group, this way
hid-ite will not bind the the mouse/multi-touch interface which has
HID_GROUP_MULTITOUCH_WIN_8 as group.
This fixes the regression to mouse-emulation mode introduced by adding
the keyboard dock USB id.

Cc: stable@vger.kernel.org
Fixes: 8f18eca9ebc5 ("HID: ite: Add USB id match for Acer SW5-012 keyboard dock")
Reported-by: Zdeněk Rampas <zdenda.rampas@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-ite.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/hid/hid-ite.c
+++ b/drivers/hid/hid-ite.c
@@ -41,8 +41,9 @@ static const struct hid_device_id ite_de
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ITE, USB_DEVICE_ID_ITE8595) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_258A, USB_DEVICE_ID_258A_6A88) },
 	/* ITE8595 USB kbd ctlr, with Synaptics touchpad connected to it. */
-	{ HID_USB_DEVICE(USB_VENDOR_ID_SYNAPTICS,
-			 USB_DEVICE_ID_SYNAPTICS_ACER_SWITCH5_012) },
+	{ HID_DEVICE(BUS_USB, HID_GROUP_GENERIC,
+		     USB_VENDOR_ID_SYNAPTICS,
+		     USB_DEVICE_ID_SYNAPTICS_ACER_SWITCH5_012) },
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, ite_devices);


