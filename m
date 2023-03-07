Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 304806AEBF0
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:50:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232196AbjCGRui (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:50:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232200AbjCGRuN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:50:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D16E9DE24
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:44:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD374614FF
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:44:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDD22C433D2;
        Tue,  7 Mar 2023 17:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211098;
        bh=+3f8T4HSjcAE9HJ+B1k4HNRX0H7RQZejv7iygWq+upQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nOw7Bius+/O9ChdbPySYwcntb1x4Dk3Z0BZ9ePbmLcdv8FJ1J9CnsKFgcLi8xytPz
         fNZltsoaPGHFkGamOdp2oMuM/XxsI+ldZLBVAHSISqvqwc7zkDV0GvEw6HLhnC+aSd
         EKyj92gmCJNY5tVKhUCzjv2uiO4wyQWYsrbE6CD0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Denis Pauk <pauk.denis@gmail.com>,
        Ahmad Khalifa <ahmad@khalifa.ws>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0725/1001] hwmon: (nct6775) Directly call ASUS ACPI WMI method
Date:   Tue,  7 Mar 2023 17:58:17 +0100
Message-Id: <20230307170053.161576088@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Denis Pauk <pauk.denis@gmail.com>

[ Upstream commit c3b3747d02f571da2543e719066a50dd966989d8 ]

New ASUS B650/B660/X670 boards firmware have not exposed WMI monitoring
GUID  and entrypoint method WMBD could be implemented for different device
UID.

Implement the direct call to entrypoint method for monitoring the device
UID of B550/X570 boards.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=204807
Signed-off-by: Denis Pauk <pauk.denis@gmail.com>
Co-developed-by: Ahmad Khalifa <ahmad@khalifa.ws>
Signed-off-by: Ahmad Khalifa <ahmad@khalifa.ws>
Link: https://lore.kernel.org/r/20230111212241.7456-1-pauk.denis@gmail.com
[groeck: Fix multi-line formatting]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/Kconfig            |  2 +-
 drivers/hwmon/nct6775-platform.c | 98 ++++++++++++++++++++++----------
 2 files changed, 70 insertions(+), 30 deletions(-)

diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 3176c33af6c69..300ce8115ce4f 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -1516,7 +1516,7 @@ config SENSORS_NCT6775_CORE
 config SENSORS_NCT6775
 	tristate "Platform driver for Nuvoton NCT6775F and compatibles"
 	depends on !PPC
-	depends on ACPI_WMI || ACPI_WMI=n
+	depends on ACPI || ACPI=n
 	select HWMON_VID
 	select SENSORS_NCT6775_CORE
 	help
diff --git a/drivers/hwmon/nct6775-platform.c b/drivers/hwmon/nct6775-platform.c
index bf43f73dc835f..e5d4a79cd5f7d 100644
--- a/drivers/hwmon/nct6775-platform.c
+++ b/drivers/hwmon/nct6775-platform.c
@@ -17,7 +17,6 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/regmap.h>
-#include <linux/wmi.h>
 
 #include "nct6775.h"
 
@@ -107,40 +106,50 @@ struct nct6775_sio_data {
 	void (*sio_exit)(struct nct6775_sio_data *sio_data);
 };
 
-#define ASUSWMI_MONITORING_GUID		"466747A0-70EC-11DE-8A39-0800200C9A66"
+#define ASUSWMI_METHOD			"WMBD"
 #define ASUSWMI_METHODID_RSIO		0x5253494F
 #define ASUSWMI_METHODID_WSIO		0x5753494F
 #define ASUSWMI_METHODID_RHWM		0x5248574D
 #define ASUSWMI_METHODID_WHWM		0x5748574D
 #define ASUSWMI_UNSUPPORTED_METHOD	0xFFFFFFFE
+#define ASUSWMI_DEVICE_HID		"PNP0C14"
+#define ASUSWMI_DEVICE_UID		"ASUSWMI"
+
+#if IS_ENABLED(CONFIG_ACPI)
+/*
+ * ASUS boards have only one device with WMI "WMBD" method and have provided
+ * access to only one SuperIO chip at 0x0290.
+ */
+static struct acpi_device *asus_acpi_dev;
+#endif
 
 static int nct6775_asuswmi_evaluate_method(u32 method_id, u8 bank, u8 reg, u8 val, u32 *retval)
 {
-#if IS_ENABLED(CONFIG_ACPI_WMI)
+#if IS_ENABLED(CONFIG_ACPI)
+	acpi_handle handle = acpi_device_handle(asus_acpi_dev);
 	u32 args = bank | (reg << 8) | (val << 16);
-	struct acpi_buffer input = { (acpi_size) sizeof(args), &args };
-	struct acpi_buffer output = { ACPI_ALLOCATE_BUFFER, NULL };
+	struct acpi_object_list input;
+	union acpi_object params[3];
+	unsigned long long result;
 	acpi_status status;
-	union acpi_object *obj;
-	u32 tmp = ASUSWMI_UNSUPPORTED_METHOD;
-
-	status = wmi_evaluate_method(ASUSWMI_MONITORING_GUID, 0,
-				     method_id, &input, &output);
 
+	params[0].type = ACPI_TYPE_INTEGER;
+	params[0].integer.value = 0;
+	params[1].type = ACPI_TYPE_INTEGER;
+	params[1].integer.value = method_id;
+	params[2].type = ACPI_TYPE_BUFFER;
+	params[2].buffer.length = sizeof(args);
+	params[2].buffer.pointer = (void *)&args;
+	input.count = 3;
+	input.pointer = params;
+
+	status = acpi_evaluate_integer(handle, ASUSWMI_METHOD, &input, &result);
 	if (ACPI_FAILURE(status))
 		return -EIO;
 
-	obj = output.pointer;
-	if (obj && obj->type == ACPI_TYPE_INTEGER)
-		tmp = obj->integer.value;
-
 	if (retval)
-		*retval = tmp;
+		*retval = (u32)result & 0xFFFFFFFF;
 
-	kfree(obj);
-
-	if (tmp == ASUSWMI_UNSUPPORTED_METHOD)
-		return -ENODEV;
 	return 0;
 #else
 	return -EOPNOTSUPP;
@@ -1099,6 +1108,45 @@ static const char * const asus_wmi_boards[] = {
 	"TUF GAMING Z490-PLUS (WI-FI)",
 };
 
+#if IS_ENABLED(CONFIG_ACPI)
+/*
+ * Callback for acpi_bus_for_each_dev() to find the right device
+ * by _UID and _HID and return 1 to stop iteration.
+ */
+static int nct6775_asuswmi_device_match(struct device *dev, void *data)
+{
+	struct acpi_device *adev = to_acpi_device(dev);
+	const char *uid = acpi_device_uid(adev);
+	const char *hid = acpi_device_hid(adev);
+
+	if (hid && !strcmp(hid, ASUSWMI_DEVICE_HID) && uid && !strcmp(uid, data)) {
+		asus_acpi_dev = adev;
+		return 1;
+	}
+
+	return 0;
+}
+#endif
+
+static enum sensor_access nct6775_determine_access(const char *device_uid)
+{
+#if IS_ENABLED(CONFIG_ACPI)
+	u8 tmp;
+
+	acpi_bus_for_each_dev(nct6775_asuswmi_device_match, (void *)device_uid);
+	if (!asus_acpi_dev)
+		return access_direct;
+
+	/* if reading chip id via ACPI succeeds, use WMI "WMBD" method for access */
+	if (!nct6775_asuswmi_read(0, NCT6775_PORT_CHIPID, &tmp) && tmp) {
+		pr_debug("Using Asus WMBD method of %s to access %#x chip.\n", device_uid, tmp);
+		return access_asuswmi;
+	}
+#endif
+
+	return access_direct;
+}
+
 static int __init sensors_nct6775_platform_init(void)
 {
 	int i, err;
@@ -1109,7 +1157,6 @@ static int __init sensors_nct6775_platform_init(void)
 	int sioaddr[2] = { 0x2e, 0x4e };
 	enum sensor_access access = access_direct;
 	const char *board_vendor, *board_name;
-	u8 tmp;
 
 	err = platform_driver_register(&nct6775_driver);
 	if (err)
@@ -1122,15 +1169,8 @@ static int __init sensors_nct6775_platform_init(void)
 	    !strcmp(board_vendor, "ASUSTeK COMPUTER INC.")) {
 		err = match_string(asus_wmi_boards, ARRAY_SIZE(asus_wmi_boards),
 				   board_name);
-		if (err >= 0) {
-			/* if reading chip id via WMI succeeds, use WMI */
-			if (!nct6775_asuswmi_read(0, NCT6775_PORT_CHIPID, &tmp) && tmp) {
-				pr_info("Using Asus WMI to access %#x chip.\n", tmp);
-				access = access_asuswmi;
-			} else {
-				pr_err("Can't read ChipID by Asus WMI.\n");
-			}
-		}
+		if (err >= 0)
+			access = nct6775_determine_access(ASUSWMI_DEVICE_UID);
 	}
 
 	/*
-- 
2.39.2



