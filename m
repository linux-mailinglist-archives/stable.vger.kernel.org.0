Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9141814ECA0
	for <lists+stable@lfdr.de>; Fri, 31 Jan 2020 13:46:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728511AbgAaMqG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jan 2020 07:46:06 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45759 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728500AbgAaMqG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Jan 2020 07:46:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580474765;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=6qiGPF/Z1p6Akif2GSoTRgfPZrAOsZtMrxGTd5HGIEA=;
        b=VGtNc5jhR5WJpVecgAK7Lj0TB0/ZFIOUNkVMQydG5vLEEI0dYhEbSezkFTh96SpPLT980d
        z1DJeI9k7/EUQPuta9EVBbxiBxVy9KFdh/DmC+pxRI9Q/inNJrEyssOviX6mSCFhB8rSuh
        4dp0VsnSQZo7KothoP7Nm87wql7nIWA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-325-CFiNWOhOPduBelE7tIwGzA-1; Fri, 31 Jan 2020 07:46:03 -0500
X-MC-Unique: CFiNWOhOPduBelE7tIwGzA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EF6831005516;
        Fri, 31 Jan 2020 12:46:01 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-112-56.ams2.redhat.com [10.36.112.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AAA341001B3F;
        Fri, 31 Jan 2020 12:45:57 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Hans de Goede <hdegoede@redhat.com>, linux-input@vger.kernel.org,
        stable@vger.kernel.org,
        =?UTF-8?q?Zden=C4=9Bk=20Rampas?= <zdenda.rampas@gmail.com>
Subject: [PATCH] HID: ite: Only bind to keyboard USB interface on Acer SW5-012 keyboard dock
Date:   Fri, 31 Jan 2020 13:45:53 +0100
Message-Id: <20200131124553.27796-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 8f18eca9ebc5 ("HID: ite: Add USB id match for Acer SW5-012 keyboar=
d
dock") added the USB id for the Acer SW5-012's keyboard dock to the
hid-ite driver to fix the rfkill driver not working.

Most keyboard docks with an ITE 8595 keyboard/touchpad controller have th=
e
"Wireless Radio Control" bits which need the special hid-ite driver on th=
e
second USB interface (the mouse interface) and their touchpad only suppor=
ts
mouse emulation, so using generic hid-input handling for anything but
the "Wireless Radio Control" bits is fine. On these devices we simply bin=
d
to all USB interfaces.

But unlike other ITE8595 using keyboard docks, the Acer Aspire Switch 10
(SW5-012)'s touchpad not only does mouse emulation it also supports
HID-multitouch and all the keys including the "Wireless Radio Control"
bits have been moved to the first USB interface (the keyboard intf).

So we need hid-ite to handle the first (keyboard) USB interface and have
it NOT bind to the second (mouse) USB interface so that that can be
handled by hid-multitouch.c and we get proper multi-touch support.

This commit adds a match callback to hid-ite which makes it only
match the first USB interface when running on the Acer SW5-012,
fixing the regression to mouse-emulation mode introduced by adding the
keyboard dock USB id.

Note the match function only does the special only bind to the first
USB interface on the Acer SW5-012, on other devices the hid-ite driver
actually must bind to the second interface as that is where the
"Wireless Radio Control" bits are.

Cc: stable@vger.kernel.org
Fixes: 8f18eca9ebc5 ("HID: ite: Add USB id match for Acer SW5-012 keyboar=
d dock")
Reported-by: Zden=C4=9Bk Rampas <zdenda.rampas@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/hid/hid-ite.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/hid/hid-ite.c b/drivers/hid/hid-ite.c
index c436e12feb23..69a4ddfd033d 100644
--- a/drivers/hid/hid-ite.c
+++ b/drivers/hid/hid-ite.c
@@ -8,9 +8,12 @@
 #include <linux/input.h>
 #include <linux/hid.h>
 #include <linux/module.h>
+#include <linux/usb.h>
=20
 #include "hid-ids.h"
=20
+#define ITE8595_KBD_USB_INTF		0
+
 static int ite_event(struct hid_device *hdev, struct hid_field *field,
 		     struct hid_usage *usage, __s32 value)
 {
@@ -37,6 +40,36 @@ static int ite_event(struct hid_device *hdev, struct h=
id_field *field,
 	return 0;
 }
=20
+static bool ite_match(struct hid_device *hdev, bool ignore_special_drive=
r)
+{
+	struct usb_interface *intf;
+
+	if (ignore_special_driver)
+		return false;
+
+	/*
+	 * Most keyboard docks with an ITE 8595 keyboard/touchpad controller
+	 * have the "Wireless Radio Control" bits which need this special
+	 * driver on the second USB interface (the mouse interface). On
+	 * these devices we simply bind to all USB interfaces.
+	 *
+	 * The Acer Aspire Switch 10 (SW5-012) is special, its touchpad
+	 * not only does mouse emulation it also supports HID-multitouch
+	 * and all the keys including the "Wireless Radio Control" bits
+	 * have been moved to the first USB interface (the keyboard intf).
+	 *
+	 * We want the hid-multitouch driver to bind to the touchpad, so on
+	 * the Acer SW5-012 we should only bind to the keyboard USB intf.
+	 */
+	if (hdev->bus !=3D BUS_USB || hdev->vendor !=3D USB_VENDOR_ID_SYNAPTICS=
 ||
+		     hdev->product !=3D USB_DEVICE_ID_SYNAPTICS_ACER_SWITCH5_012)
+		return true;
+
+	intf =3D to_usb_interface(hdev->dev.parent);
+
+	return intf->altsetting->desc.bInterfaceNumber =3D=3D ITE8595_KBD_USB_I=
NTF;
+}
+
 static const struct hid_device_id ite_devices[] =3D {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ITE, USB_DEVICE_ID_ITE8595) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_258A, USB_DEVICE_ID_258A_6A88) },
@@ -50,6 +83,7 @@ MODULE_DEVICE_TABLE(hid, ite_devices);
 static struct hid_driver ite_driver =3D {
 	.name =3D "itetech",
 	.id_table =3D ite_devices,
+	.match =3D ite_match,
 	.event =3D ite_event,
 };
 module_hid_driver(ite_driver);
--=20
2.23.0

