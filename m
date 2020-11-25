Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 970582C4394
	for <lists+stable@lfdr.de>; Wed, 25 Nov 2020 16:39:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731440AbgKYPjK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Nov 2020 10:39:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:56620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731337AbgKYPiM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 25 Nov 2020 10:38:12 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BCD422201;
        Wed, 25 Nov 2020 15:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606318690;
        bh=5YCaTIGt0pGSGrR46cs0dlfiRR8qH3EbDLsDvJXbbSA=;
        h=From:To:Cc:Subject:Date:From;
        b=gXb1AvdArbe7u4Lzx/svv2uaS5SkAYeLL/n13GGwPYKr8iIFFU1Zx+3m1ANQoVs53
         EhPOEg9zgEh1kzZ+uSfTGHMYInQNeaVe5Lrlmv9q2qpnuAPPT9wIrNwUd8rya17tOt
         4A6faTTybP795F4wR+pqGVkiPEpS9YFvJe0cfxaU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Frank Yang <puilp0502@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 1/8] HID: cypress: Support Varmilo Keyboards' media hotkeys
Date:   Wed, 25 Nov 2020 10:38:01 -0500
Message-Id: <20201125153808.811104-1-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frank Yang <puilp0502@gmail.com>

[ Upstream commit 652f3d00de523a17b0cebe7b90debccf13aa8c31 ]

The Varmilo VA104M Keyboard (04b4:07b1, reported as Varmilo Z104M)
exposes media control hotkeys as a USB HID consumer control device, but
these keys do not work in the current (5.8-rc1) kernel due to the
incorrect HID report descriptor. Fix the problem by modifying the
internal HID report descriptor.

More specifically, the keyboard report descriptor specifies the
logical boundary as 572~10754 (0x023c ~ 0x2a02) while the usage
boundary is specified as 0~10754 (0x00 ~ 0x2a02). This results in an
incorrect interpretation of input reports, causing inputs to be ignored.
By setting the Logical Minimum to zero, we align the logical boundary
with the Usage ID boundary.

Some notes:

* There seem to be multiple variants of the VA104M keyboard. This
  patch specifically targets 04b4:07b1 variant.

* The device works out-of-the-box on Windows platform with the generic
  consumer control device driver (hidserv.inf). This suggests that
  Windows either ignores the Logical Minimum/Logical Maximum or
  interprets the Usage ID assignment differently from the linux
  implementation; Maybe there are other devices out there that only
  works on Windows due to this problem?

Signed-off-by: Frank Yang <puilp0502@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-cypress.c | 44 ++++++++++++++++++++++++++++++++++-----
 drivers/hid/hid-ids.h     |  2 ++
 2 files changed, 41 insertions(+), 5 deletions(-)

diff --git a/drivers/hid/hid-cypress.c b/drivers/hid/hid-cypress.c
index 1689568b597d4..12c5d7c96527a 100644
--- a/drivers/hid/hid-cypress.c
+++ b/drivers/hid/hid-cypress.c
@@ -26,19 +26,17 @@
 #define CP_2WHEEL_MOUSE_HACK		0x02
 #define CP_2WHEEL_MOUSE_HACK_ON		0x04
 
+#define VA_INVAL_LOGICAL_BOUNDARY	0x08
+
 /*
  * Some USB barcode readers from cypress have usage min and usage max in
  * the wrong order
  */
-static __u8 *cp_report_fixup(struct hid_device *hdev, __u8 *rdesc,
+static __u8 *cp_rdesc_fixup(struct hid_device *hdev, __u8 *rdesc,
 		unsigned int *rsize)
 {
-	unsigned long quirks = (unsigned long)hid_get_drvdata(hdev);
 	unsigned int i;
 
-	if (!(quirks & CP_RDESC_SWAPPED_MIN_MAX))
-		return rdesc;
-
 	if (*rsize < 4)
 		return rdesc;
 
@@ -51,6 +49,40 @@ static __u8 *cp_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 	return rdesc;
 }
 
+static __u8 *va_logical_boundary_fixup(struct hid_device *hdev, __u8 *rdesc,
+		unsigned int *rsize)
+{
+	/*
+	 * Varmilo VA104M (with VID Cypress and device ID 07B1) incorrectly
+	 * reports Logical Minimum of its Consumer Control device as 572
+	 * (0x02 0x3c). Fix this by setting its Logical Minimum to zero.
+	 */
+	if (*rsize == 25 &&
+			rdesc[0] == 0x05 && rdesc[1] == 0x0c &&
+			rdesc[2] == 0x09 && rdesc[3] == 0x01 &&
+			rdesc[6] == 0x19 && rdesc[7] == 0x00 &&
+			rdesc[11] == 0x16 && rdesc[12] == 0x3c && rdesc[13] == 0x02) {
+		hid_info(hdev,
+			 "fixing up varmilo VA104M consumer control report descriptor\n");
+		rdesc[12] = 0x00;
+		rdesc[13] = 0x00;
+	}
+	return rdesc;
+}
+
+static __u8 *cp_report_fixup(struct hid_device *hdev, __u8 *rdesc,
+		unsigned int *rsize)
+{
+	unsigned long quirks = (unsigned long)hid_get_drvdata(hdev);
+
+	if (quirks & CP_RDESC_SWAPPED_MIN_MAX)
+		rdesc = cp_rdesc_fixup(hdev, rdesc, rsize);
+	if (quirks & VA_INVAL_LOGICAL_BOUNDARY)
+		rdesc = va_logical_boundary_fixup(hdev, rdesc, rsize);
+
+	return rdesc;
+}
+
 static int cp_input_mapped(struct hid_device *hdev, struct hid_input *hi,
 		struct hid_field *field, struct hid_usage *usage,
 		unsigned long **bit, int *max)
@@ -131,6 +163,8 @@ static const struct hid_device_id cp_devices[] = {
 		.driver_data = CP_RDESC_SWAPPED_MIN_MAX },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CYPRESS, USB_DEVICE_ID_CYPRESS_MOUSE),
 		.driver_data = CP_2WHEEL_MOUSE_HACK },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_CYPRESS, USB_DEVICE_ID_CYPRESS_VARMILO_VA104M_07B1),
+		.driver_data = VA_INVAL_LOGICAL_BOUNDARY },
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, cp_devices);
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 33d2b5948d7fc..773452c6edfab 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -279,6 +279,8 @@
 #define USB_DEVICE_ID_CYPRESS_BARCODE_4	0xed81
 #define USB_DEVICE_ID_CYPRESS_TRUETOUCH	0xc001
 
+#define USB_DEVICE_ID_CYPRESS_VARMILO_VA104M_07B1   0X07b1
+
 #define USB_VENDOR_ID_DATA_MODUL	0x7374
 #define USB_VENDOR_ID_DATA_MODUL_EASYMAXTOUCH	0x1201
 
-- 
2.27.0

