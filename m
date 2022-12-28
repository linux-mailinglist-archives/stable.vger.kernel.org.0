Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F4B065842D
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:55:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235273AbiL1QzS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:55:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233747AbiL1Qyx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:54:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08A4B1C411
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:49:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 949E4B816F4
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:49:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0111CC433F0;
        Wed, 28 Dec 2022 16:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246177;
        bh=Nfs8AStVoXtuJLiwJLbWWDkqY/o4XJz9nMnz2BkHqWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vKuq/neusg9vpasm/9zEXALWCt+VXp1CV5UjGXSlinOBuQ0rKEodk9qtZpnG1KitL
         D4muMVBVLeoTHCN+oc8Z0skuTC6VHUse9wL8TsYtTCxVcLsEgT/aKXA4B2IQLb2kiM
         xTKdC5ELUbpggjsllBhS0U+Dt3o8YR7x/PRCMNAM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mia Kanashi <chad@redpilled.dev>,
        Andreas Grosse <andig.mail@t-online.de>,
        =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0993/1146] HID: uclogic: Add support for XP-PEN Deco LW
Date:   Wed, 28 Dec 2022 15:42:12 +0100
Message-Id: <20221228144357.338537155@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: José Expósito <jose.exposito89@gmail.com>

[ Upstream commit f9ce4db0ec2b6301f4264ba8627863e2632c922b ]

The XP-PEN Deco LW is a UGEE v2 device with a frame with 8 buttons.
Its pen has 2 buttons, supports tilt and pressure.

It can be connected by USB cable or using a USB Bluetooth dongle to use
it in wireless mode. When it is connected using the dongle, the device
battery is used to power it.

Its vendor, product and version are identical to the Deco L. The only
difference reported by its firmware is the product name.
In order to add support for battery reporting, add a new HID descriptor
and a quirk to detect the wireless version of the tablet.

Link: https://github.com/DIGImend/digimend-kernel-drivers/issues/635
Tested-by: Mia Kanashi <chad@redpilled.dev>
Tested-by: Andreas Grosse <andig.mail@t-online.de>
Tested-by: Mia Kanashi <chad@redpilled.dev>
Signed-off-by: José Expósito <jose.exposito89@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-uclogic-params.c | 73 ++++++++++++++++++++++++++++++++
 drivers/hid/hid-uclogic-rdesc.c  | 34 +++++++++++++++
 drivers/hid/hid-uclogic-rdesc.h  |  7 +++
 3 files changed, 114 insertions(+)

diff --git a/drivers/hid/hid-uclogic-params.c b/drivers/hid/hid-uclogic-params.c
index 34fa991e6267..cd1233d7e253 100644
--- a/drivers/hid/hid-uclogic-params.c
+++ b/drivers/hid/hid-uclogic-params.c
@@ -18,6 +18,7 @@
 #include "usbhid/usbhid.h"
 #include "hid-ids.h"
 #include <linux/ctype.h>
+#include <linux/string.h>
 #include <asm/unaligned.h>
 
 /**
@@ -1211,6 +1212,69 @@ static int uclogic_params_ugee_v2_init_frame_mouse(struct uclogic_params *p)
 	return rc;
 }
 
+/**
+ * uclogic_params_ugee_v2_has_battery() - check whether a UGEE v2 device has
+ * battery or not.
+ * @hdev:	The HID device of the tablet interface.
+ *
+ * Returns:
+ *	True if the device has battery, false otherwise.
+ */
+static bool uclogic_params_ugee_v2_has_battery(struct hid_device *hdev)
+{
+	/* The XP-PEN Deco LW vendor, product and version are identical to the
+	 * Deco L. The only difference reported by their firmware is the product
+	 * name. Add a quirk to support battery reporting on the wireless
+	 * version.
+	 */
+	if (hdev->vendor == USB_VENDOR_ID_UGEE &&
+	    hdev->product == USB_DEVICE_ID_UGEE_XPPEN_TABLET_DECO_L) {
+		struct usb_device *udev = hid_to_usb_dev(hdev);
+
+		if (strstarts(udev->product, "Deco LW"))
+			return true;
+	}
+
+	return false;
+}
+
+/**
+ * uclogic_params_ugee_v2_init_battery() - initialize UGEE v2 battery reporting.
+ * @hdev:	The HID device of the tablet interface, cannot be NULL.
+ * @p:		Parameters to fill in, cannot be NULL.
+ *
+ * Returns:
+ *	Zero, if successful. A negative errno code on error.
+ */
+static int uclogic_params_ugee_v2_init_battery(struct hid_device *hdev,
+					       struct uclogic_params *p)
+{
+	int rc = 0;
+
+	if (!hdev || !p)
+		return -EINVAL;
+
+	/* Some tablets contain invalid characters in hdev->uniq, throwing a
+	 * "hwmon: '<name>' is not a valid name attribute, please fix" error.
+	 * Use the device vendor and product IDs instead.
+	 */
+	snprintf(hdev->uniq, sizeof(hdev->uniq), "%x-%x", hdev->vendor,
+		 hdev->product);
+
+	rc = uclogic_params_frame_init_with_desc(&p->frame_list[1],
+						 uclogic_rdesc_ugee_v2_battery_template_arr,
+						 uclogic_rdesc_ugee_v2_battery_template_size,
+						 UCLOGIC_RDESC_UGEE_V2_BATTERY_ID);
+	if (rc)
+		return rc;
+
+	p->frame_list[1].suffix = "Battery";
+	p->pen.subreport_list[1].value = 0xf2;
+	p->pen.subreport_list[1].id = UCLOGIC_RDESC_UGEE_V2_BATTERY_ID;
+
+	return rc;
+}
+
 /**
  * uclogic_params_ugee_v2_init() - initialize a UGEE graphics tablets by
  * discovering their parameters.
@@ -1334,6 +1398,15 @@ static int uclogic_params_ugee_v2_init(struct uclogic_params *params,
 	if (rc)
 		goto cleanup;
 
+	/* Initialize the battery interface*/
+	if (uclogic_params_ugee_v2_has_battery(hdev)) {
+		rc = uclogic_params_ugee_v2_init_battery(hdev, &p);
+		if (rc) {
+			hid_err(hdev, "error initializing battery: %d\n", rc);
+			goto cleanup;
+		}
+	}
+
 output:
 	/* Output parameters */
 	memcpy(params, &p, sizeof(*params));
diff --git a/drivers/hid/hid-uclogic-rdesc.c b/drivers/hid/hid-uclogic-rdesc.c
index 6b73eb0df6bd..fb40775f5f5b 100644
--- a/drivers/hid/hid-uclogic-rdesc.c
+++ b/drivers/hid/hid-uclogic-rdesc.c
@@ -1035,6 +1035,40 @@ const __u8 uclogic_rdesc_ugee_v2_frame_mouse_template_arr[] = {
 const size_t uclogic_rdesc_ugee_v2_frame_mouse_template_size =
 			sizeof(uclogic_rdesc_ugee_v2_frame_mouse_template_arr);
 
+/* Fixed report descriptor template for UGEE v2 battery reports */
+const __u8 uclogic_rdesc_ugee_v2_battery_template_arr[] = {
+	0x05, 0x01,         /*  Usage Page (Desktop),                   */
+	0x09, 0x07,         /*  Usage (Keypad),                         */
+	0xA1, 0x01,         /*  Collection (Application),               */
+	0x85, UCLOGIC_RDESC_UGEE_V2_BATTERY_ID,
+			    /*      Report ID,                          */
+	0x75, 0x08,         /*      Report Size (8),                    */
+	0x95, 0x02,         /*      Report Count (2),                   */
+	0x81, 0x01,         /*      Input (Constant),                   */
+	0x05, 0x84,         /*      Usage Page (Power Device),          */
+	0x05, 0x85,         /*      Usage Page (Battery System),        */
+	0x09, 0x65,         /*      Usage Page (AbsoluteStateOfCharge), */
+	0x75, 0x08,         /*      Report Size (8),                    */
+	0x95, 0x01,         /*      Report Count (1),                   */
+	0x15, 0x00,         /*      Logical Minimum (0),                */
+	0x26, 0xff, 0x00,   /*      Logical Maximum (255),              */
+	0x81, 0x02,         /*      Input (Variable),                   */
+	0x75, 0x01,         /*      Report Size (1),                    */
+	0x95, 0x01,         /*      Report Count (1),                   */
+	0x15, 0x00,         /*      Logical Minimum (0),                */
+	0x25, 0x01,         /*      Logical Maximum (1),                */
+	0x09, 0x44,         /*      Usage Page (Charging),              */
+	0x81, 0x02,         /*      Input (Variable),                   */
+	0x95, 0x07,         /*      Report Count (7),                   */
+	0x81, 0x01,         /*      Input (Constant),                   */
+	0x75, 0x08,         /*      Report Size (8),                    */
+	0x95, 0x07,         /*      Report Count (7),                   */
+	0x81, 0x01,         /*      Input (Constant),                   */
+	0xC0                /*  End Collection                          */
+};
+const size_t uclogic_rdesc_ugee_v2_battery_template_size =
+			sizeof(uclogic_rdesc_ugee_v2_battery_template_arr);
+
 /* Fixed report descriptor for Ugee EX07 frame */
 const __u8 uclogic_rdesc_ugee_ex07_frame_arr[] = {
 	0x05, 0x01,             /*  Usage Page (Desktop),                   */
diff --git a/drivers/hid/hid-uclogic-rdesc.h b/drivers/hid/hid-uclogic-rdesc.h
index 0502a0656496..a1f78c07293f 100644
--- a/drivers/hid/hid-uclogic-rdesc.h
+++ b/drivers/hid/hid-uclogic-rdesc.h
@@ -161,6 +161,9 @@ extern const size_t uclogic_rdesc_v2_frame_dial_size;
 /* Device ID byte offset in v2 frame dial reports */
 #define UCLOGIC_RDESC_V2_FRAME_DIAL_DEV_ID_BYTE	0x4
 
+/* Report ID for tweaked UGEE v2 battery reports */
+#define UCLOGIC_RDESC_UGEE_V2_BATTERY_ID 0xba
+
 /* Fixed report descriptor template for UGEE v2 pen reports */
 extern const __u8 uclogic_rdesc_ugee_v2_pen_template_arr[];
 extern const size_t uclogic_rdesc_ugee_v2_pen_template_size;
@@ -177,6 +180,10 @@ extern const size_t uclogic_rdesc_ugee_v2_frame_dial_template_size;
 extern const __u8 uclogic_rdesc_ugee_v2_frame_mouse_template_arr[];
 extern const size_t uclogic_rdesc_ugee_v2_frame_mouse_template_size;
 
+/* Fixed report descriptor template for UGEE v2 battery reports */
+extern const __u8 uclogic_rdesc_ugee_v2_battery_template_arr[];
+extern const size_t uclogic_rdesc_ugee_v2_battery_template_size;
+
 /* Fixed report descriptor for Ugee EX07 frame */
 extern const __u8 uclogic_rdesc_ugee_ex07_frame_arr[];
 extern const size_t uclogic_rdesc_ugee_ex07_frame_size;
-- 
2.35.1



