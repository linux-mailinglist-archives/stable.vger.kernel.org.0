Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5D037D242
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 20:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239596AbhELSHp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 14:07:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:50176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352060AbhELSC0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 14:02:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2EF2361428;
        Wed, 12 May 2021 18:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620842478;
        bh=sRCDHEtlOYRoF0ugZsq88Egozlq1CUEd7jWG6ONVEmY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ee3bF04DpMn/VbSGh1qeZyndcEpsY6FQiAwMrd48Z+x7o4MuxF+vrYSuwFqCAYwp+
         AyTBOp7c3Brnyeoi4nOncP+RjBe0HXK+62l4QcOur2MCi10w5Xy0yolJRD6FSOFVEq
         UeqAWhE8Vpc2CWhdKPdO682a9NYRcdq0nAiVo7TbWYMTwhaH0LBBa57cJvpkoM2MnO
         ZY5D6F90rz3DL2WVxwhimcNofUFjezg9mSC0IYuY6+RPHrMtdPN9vhSHWg2GMlP07H
         S9gH2fK3jqRoXyBvg2plfZoqv4W8lXp865qgx+5A65QFmiakS5L1pMhsKVw68dFF01
         3oOoiQfoXsVYA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 09/37] Input: elants_i2c - do not bind to i2c-hid compatible ACPI instantiated devices
Date:   Wed, 12 May 2021 14:00:36 -0400
Message-Id: <20210512180104.664121-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210512180104.664121-1-sashal@kernel.org>
References: <20210512180104.664121-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 65299e8bfb24774e6340e93ae49f6626598917c8 ]

Several users have been reporting that elants_i2c gives several errors
during probe and that their touchscreen does not work on their Lenovo AMD
based laptops with a touchscreen with a ELAN0001 ACPI hardware-id:

[    0.550596] elants_i2c i2c-ELAN0001:00: i2c-ELAN0001:00 supply vcc33 not found, using dummy regulator
[    0.551836] elants_i2c i2c-ELAN0001:00: i2c-ELAN0001:00 supply vccio not found, using dummy regulator
[    0.560932] elants_i2c i2c-ELAN0001:00: elants_i2c_send failed (77 77 77 77): -121
[    0.562427] elants_i2c i2c-ELAN0001:00: software reset failed: -121
[    0.595925] elants_i2c i2c-ELAN0001:00: elants_i2c_send failed (77 77 77 77): -121
[    0.597974] elants_i2c i2c-ELAN0001:00: software reset failed: -121
[    0.621893] elants_i2c i2c-ELAN0001:00: elants_i2c_send failed (77 77 77 77): -121
[    0.622504] elants_i2c i2c-ELAN0001:00: software reset failed: -121
[    0.632650] elants_i2c i2c-ELAN0001:00: elants_i2c_send failed (4d 61 69 6e): -121
[    0.634256] elants_i2c i2c-ELAN0001:00: boot failed: -121
[    0.699212] elants_i2c i2c-ELAN0001:00: invalid 'hello' packet: 00 00 ff ff
[    1.630506] elants_i2c i2c-ELAN0001:00: Failed to read fw id: -121
[    1.645508] elants_i2c i2c-ELAN0001:00: unknown packet 00 00 ff ff

Despite these errors, the elants_i2c driver stays bound to the device
(it returns 0 from its probe method despite the errors), blocking the
i2c-hid driver from binding.

Manually unbinding the elants_i2c driver and binding the i2c-hid driver
makes the touchscreen work.

Check if the ACPI-fwnode for the touchscreen contains one of the i2c-hid
compatiblity-id strings and if it has the I2C-HID spec's DSM to get the
HID descriptor address, If it has both then make elants_i2c not bind,
so that the i2c-hid driver can bind.

This assumes that non of the (older) elan touchscreens which actually
need the elants_i2c driver falsely advertise an i2c-hid compatiblity-id
+ DSM in their ACPI-fwnodes. If some of them actually do have this
false advertising, then this change may lead to regressions.

While at it also drop the unnecessary DEVICE_NAME prefixing of the
"I2C check functionality error", dev_err already outputs the driver-name.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=207759
Acked-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20210405202756.16830-1-hdegoede@redhat.com

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/elants_i2c.c | 44 ++++++++++++++++++++++++--
 1 file changed, 42 insertions(+), 2 deletions(-)

diff --git a/drivers/input/touchscreen/elants_i2c.c b/drivers/input/touchscreen/elants_i2c.c
index 5f7706febcb0..17540bdb1eaf 100644
--- a/drivers/input/touchscreen/elants_i2c.c
+++ b/drivers/input/touchscreen/elants_i2c.c
@@ -38,6 +38,7 @@
 #include <linux/of.h>
 #include <linux/gpio/consumer.h>
 #include <linux/regulator/consumer.h>
+#include <linux/uuid.h>
 #include <asm/unaligned.h>
 
 /* Device, Driver information */
@@ -1334,6 +1335,40 @@ static void elants_i2c_power_off(void *_data)
 	}
 }
 
+#ifdef CONFIG_ACPI
+static const struct acpi_device_id i2c_hid_ids[] = {
+	{"ACPI0C50", 0 },
+	{"PNP0C50", 0 },
+	{ },
+};
+
+static const guid_t i2c_hid_guid =
+	GUID_INIT(0x3CDFF6F7, 0x4267, 0x4555,
+		  0xAD, 0x05, 0xB3, 0x0A, 0x3D, 0x89, 0x38, 0xDE);
+
+static bool elants_acpi_is_hid_device(struct device *dev)
+{
+	acpi_handle handle = ACPI_HANDLE(dev);
+	union acpi_object *obj;
+
+	if (acpi_match_device_ids(ACPI_COMPANION(dev), i2c_hid_ids))
+		return false;
+
+	obj = acpi_evaluate_dsm_typed(handle, &i2c_hid_guid, 1, 1, NULL, ACPI_TYPE_INTEGER);
+	if (obj) {
+		ACPI_FREE(obj);
+		return true;
+	}
+
+	return false;
+}
+#else
+static bool elants_acpi_is_hid_device(struct device *dev)
+{
+	return false;
+}
+#endif
+
 static int elants_i2c_probe(struct i2c_client *client,
 			    const struct i2c_device_id *id)
 {
@@ -1342,9 +1377,14 @@ static int elants_i2c_probe(struct i2c_client *client,
 	unsigned long irqflags;
 	int error;
 
+	/* Don't bind to i2c-hid compatible devices, these are handled by the i2c-hid drv. */
+	if (elants_acpi_is_hid_device(&client->dev)) {
+		dev_warn(&client->dev, "This device appears to be an I2C-HID device, not binding\n");
+		return -ENODEV;
+	}
+
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
-		dev_err(&client->dev,
-			"%s: i2c check functionality error\n", DEVICE_NAME);
+		dev_err(&client->dev, "I2C check functionality error\n");
 		return -ENXIO;
 	}
 
-- 
2.30.2

