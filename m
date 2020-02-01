Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA5A14F7AE
	for <lists+stable@lfdr.de>; Sat,  1 Feb 2020 12:57:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726450AbgBAL5B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Feb 2020 06:57:01 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:35410 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726385AbgBAL5B (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 Feb 2020 06:57:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580558219;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=CgaEchis4MwdYCLh9FRqTFKGc6gMYpj98xz1QQaPf20=;
        b=HKypyKwl/DnhUNNtLV1wL8KcAKBPO/DcCSeBQtNzON3IfgK/Hiaqt+aKGoR4Boid1yIAsr
        VqAvneEz2u0TDEjQItbWVekFOFPxwcgzaUUZfY/0AmN4TltRr7SWvmhuSik/cMo8lak38l
        7o9IIrRf3vlk0AUKJw/6lf2MsCe6rKY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-7-xuEGNn6JMue8kJcAMFZHQQ-1; Sat, 01 Feb 2020 06:56:57 -0500
X-MC-Unique: xuEGNn6JMue8kJcAMFZHQQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B5B74800D41;
        Sat,  1 Feb 2020 11:56:55 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-112-16.ams2.redhat.com [10.36.112.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 73D5B7C3D9;
        Sat,  1 Feb 2020 11:56:51 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Hans de Goede <hdegoede@redhat.com>, linux-input@vger.kernel.org,
        stable@vger.kernel.org,
        =?UTF-8?q?Zden=C4=9Bk=20Rampas?= <zdenda.rampas@gmail.com>
Subject: [PATCH v2] HID: ite: Only bind to keyboard USB interface on Acer SW5-012 keyboard dock
Date:   Sat,  1 Feb 2020 12:56:48 +0100
Message-Id: <20200201115648.3934-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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

This commit changes the hid_device_id for the SW5-012 keyboard dock to
only match on hid devices from the HID_GROUP_GENERIC group, this way
hid-ite will not bind the the mouse/multi-touch interface which has
HID_GROUP_MULTITOUCH_WIN_8 as group.
This fixes the regression to mouse-emulation mode introduced by adding
the keyboard dock USB id.

Cc: stable@vger.kernel.org
Fixes: 8f18eca9ebc5 ("HID: ite: Add USB id match for Acer SW5-012 keyboar=
d dock")
Reported-by: Zden=C4=9Bk Rampas <zdenda.rampas@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
Changes in v2:
- Extend hid_device_id to also match on the HID_GROUP_GENERIC group,
  instead of adding a match callback which peeks at the USB descriptors
---
 drivers/hid/hid-ite.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-ite.c b/drivers/hid/hid-ite.c
index c436e12feb23..6c55682c5974 100644
--- a/drivers/hid/hid-ite.c
+++ b/drivers/hid/hid-ite.c
@@ -41,8 +41,9 @@ static const struct hid_device_id ite_devices[] =3D {
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
--=20
2.23.0

