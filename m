Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1BA32C9CDB
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:39:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387971AbgLAJD1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:03:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:40002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388167AbgLAJDY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:03:24 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9F1D206D8;
        Tue,  1 Dec 2020 09:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813388;
        bh=PhV5uaDhmqHw5CUW204MCd55v6G2ULGtBNvW9ZgaP6c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kSSWtFkPK0PcjaNHHHYeCqvmg9EPizbvJ+TjwSNPgFGkhLavr2uX7AZqZIOrxLEZs
         +kCVWymI9Mb0mqkisUh+EviOVKXGTO9Zq4IMSLTBo1cdYjrZ+aMeQoQ4bITXICrHJQ
         O2HbpcIs/akvj+VY196n2qsPuGSo+alM31OSsbdg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 22/98] HID: ite: Replace ABS_MISC 120/121 events with touchpad on/off keypresses
Date:   Tue,  1 Dec 2020 09:52:59 +0100
Message-Id: <20201201084655.485239190@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084652.827177826@linuxfoundation.org>
References: <20201201084652.827177826@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 3c785a06dee99501a17f8e8cf29b2b7e3f1e94ea ]

The usb-hid keyboard-dock for the Acer Switch 10 SW5-012 model declares
an application and hid-usage page of 0x0088 for the INPUT(4) report which
it sends. This reports contains 2 8-bit fields which are declared as
HID_MAIN_ITEM_VARIABLE.

The keyboard-touchpad combo never actually generates this report, except
when the touchpad is toggled on/off with the Fn + F7 hotkey combo. The
toggle on/off is handled inside the keyboard-dock, when the touchpad is
toggled off it simply stops sending events.

When the touchpad is toggled on/off an INPUT(4) report is generated with
the first content byte set to 120/121, before this commit the kernel
would report this as ABS_MISC 120/121 events.

Patch the descriptor to replace the HID_MAIN_ITEM_VARIABLE with
HID_MAIN_ITEM_RELATIVE (because no key-presss release events are send)
and add mappings for the 0x00880078 and 0x00880079 usages to generate
touchpad on/off key events when the touchpad is toggled on/off.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ite.c | 61 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 60 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-ite.c b/drivers/hid/hid-ite.c
index 044a93f3c1178..742c052b0110a 100644
--- a/drivers/hid/hid-ite.c
+++ b/drivers/hid/hid-ite.c
@@ -11,6 +11,48 @@
 
 #include "hid-ids.h"
 
+#define QUIRK_TOUCHPAD_ON_OFF_REPORT		BIT(0)
+
+static __u8 *ite_report_fixup(struct hid_device *hdev, __u8 *rdesc, unsigned int *rsize)
+{
+	unsigned long quirks = (unsigned long)hid_get_drvdata(hdev);
+
+	if (quirks & QUIRK_TOUCHPAD_ON_OFF_REPORT) {
+		if (*rsize == 188 && rdesc[162] == 0x81 && rdesc[163] == 0x02) {
+			hid_info(hdev, "Fixing up ITE keyboard report descriptor\n");
+			rdesc[163] = HID_MAIN_ITEM_RELATIVE;
+		}
+	}
+
+	return rdesc;
+}
+
+static int ite_input_mapping(struct hid_device *hdev,
+		struct hid_input *hi, struct hid_field *field,
+		struct hid_usage *usage, unsigned long **bit,
+		int *max)
+{
+
+	unsigned long quirks = (unsigned long)hid_get_drvdata(hdev);
+
+	if ((quirks & QUIRK_TOUCHPAD_ON_OFF_REPORT) &&
+	    (usage->hid & HID_USAGE_PAGE) == 0x00880000) {
+		if (usage->hid == 0x00880078) {
+			/* Touchpad on, userspace expects F22 for this */
+			hid_map_usage_clear(hi, usage, bit, max, EV_KEY, KEY_F22);
+			return 1;
+		}
+		if (usage->hid == 0x00880079) {
+			/* Touchpad off, userspace expects F23 for this */
+			hid_map_usage_clear(hi, usage, bit, max, EV_KEY, KEY_F23);
+			return 1;
+		}
+		return -1;
+	}
+
+	return 0;
+}
+
 static int ite_event(struct hid_device *hdev, struct hid_field *field,
 		     struct hid_usage *usage, __s32 value)
 {
@@ -37,13 +79,27 @@ static int ite_event(struct hid_device *hdev, struct hid_field *field,
 	return 0;
 }
 
+static int ite_probe(struct hid_device *hdev, const struct hid_device_id *id)
+{
+	int ret;
+
+	hid_set_drvdata(hdev, (void *)id->driver_data);
+
+	ret = hid_open_report(hdev);
+	if (ret)
+		return ret;
+
+	return hid_hw_start(hdev, HID_CONNECT_DEFAULT);
+}
+
 static const struct hid_device_id ite_devices[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ITE, USB_DEVICE_ID_ITE8595) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_258A, USB_DEVICE_ID_258A_6A88) },
 	/* ITE8595 USB kbd ctlr, with Synaptics touchpad connected to it. */
 	{ HID_DEVICE(BUS_USB, HID_GROUP_GENERIC,
 		     USB_VENDOR_ID_SYNAPTICS,
-		     USB_DEVICE_ID_SYNAPTICS_ACER_SWITCH5_012) },
+		     USB_DEVICE_ID_SYNAPTICS_ACER_SWITCH5_012),
+	  .driver_data = QUIRK_TOUCHPAD_ON_OFF_REPORT },
 	/* ITE8910 USB kbd ctlr, with Synaptics touchpad connected to it. */
 	{ HID_DEVICE(BUS_USB, HID_GROUP_GENERIC,
 		     USB_VENDOR_ID_SYNAPTICS,
@@ -55,6 +111,9 @@ MODULE_DEVICE_TABLE(hid, ite_devices);
 static struct hid_driver ite_driver = {
 	.name = "itetech",
 	.id_table = ite_devices,
+	.probe = ite_probe,
+	.report_fixup = ite_report_fixup,
+	.input_mapping = ite_input_mapping,
 	.event = ite_event,
 };
 module_hid_driver(ite_driver);
-- 
2.27.0



