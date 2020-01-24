Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5FF147B00
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:40:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732257AbgAXJkI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:40:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:37402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732126AbgAXJkH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:40:07 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4C9920709;
        Fri, 24 Jan 2020 09:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579858806;
        bh=HIhvtltE0jmuJ32MPiF+CHYwbmqxye5QcbU6Yoq552k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VQo8Oz6ilu17LwVj8lNt3KFAi92DFRyDqBvcMsUpySeBzZnOEGSRZwkCTUAL/OcQX
         A34Xz3QqjBNlTFXUSkQqVlQYonrMh/l4l9TmvN/KFT1tGk+qSwFDZUUsr+E2ULVvAY
         tpKCBkAL/1LfZBtTJc3S0x1+jo1INC8M7q6skXxY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 061/102] ACPI: platform: Unregister stale platform devices
Date:   Fri, 24 Jan 2020 10:31:02 +0100
Message-Id: <20200124092815.541731799@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092806.004582306@linuxfoundation.org>
References: <20200124092806.004582306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit cb0701acfa7e3fe9e919cf2aa2aa939b7fd603c2 ]

When commit 68bdb6773289 ("ACPI: add support for ACPI reconfiguration
notifiers") introduced reconfiguration notifiers, it missed the point
that the ACPI table, which might be loaded and then unloaded via
ConfigFS, could contain devices that were not enumerated by their
parents.

In such cases, the stale platform device is dangling in the system
while the rest of the devices from the same table are already gone.

Introduce acpi_platform_device_remove_notify() notifier that, in
similar way to I²C or SPI buses, unregisters the platform devices
on table removal event.

Fixes: 68bdb6773289 ("ACPI: add support for ACPI reconfiguration notifiers")
Depends-on: 00500147cbd3 ("drivers: Introduce device lookup variants by ACPI_COMPANION device")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
[ rjw: Changelog & function rename ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_platform.c | 43 ++++++++++++++++++++++++++++++++++++
 drivers/acpi/scan.c          |  1 +
 2 files changed, 44 insertions(+)

diff --git a/drivers/acpi/acpi_platform.c b/drivers/acpi/acpi_platform.c
index 00ec4f2bf0157..c05050f474cd3 100644
--- a/drivers/acpi/acpi_platform.c
+++ b/drivers/acpi/acpi_platform.c
@@ -31,6 +31,44 @@ static const struct acpi_device_id forbidden_id_list[] = {
 	{"", 0},
 };
 
+static struct platform_device *acpi_platform_device_find_by_companion(struct acpi_device *adev)
+{
+	struct device *dev;
+
+	dev = bus_find_device_by_acpi_dev(&platform_bus_type, adev);
+	return dev ? to_platform_device(dev) : NULL;
+}
+
+static int acpi_platform_device_remove_notify(struct notifier_block *nb,
+					      unsigned long value, void *arg)
+{
+	struct acpi_device *adev = arg;
+	struct platform_device *pdev;
+
+	switch (value) {
+	case ACPI_RECONFIG_DEVICE_ADD:
+		/* Nothing to do here */
+		break;
+	case ACPI_RECONFIG_DEVICE_REMOVE:
+		if (!acpi_device_enumerated(adev))
+			break;
+
+		pdev = acpi_platform_device_find_by_companion(adev);
+		if (!pdev)
+			break;
+
+		platform_device_unregister(pdev);
+		put_device(&pdev->dev);
+		break;
+	}
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block acpi_platform_notifier = {
+	.notifier_call = acpi_platform_device_remove_notify,
+};
+
 static void acpi_platform_fill_resource(struct acpi_device *adev,
 	const struct resource *src, struct resource *dest)
 {
@@ -130,3 +168,8 @@ struct platform_device *acpi_create_platform_device(struct acpi_device *adev,
 	return pdev;
 }
 EXPORT_SYMBOL_GPL(acpi_create_platform_device);
+
+void __init acpi_platform_init(void)
+{
+	acpi_reconfig_notifier_register(&acpi_platform_notifier);
+}
diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index aad6be5c0af0a..915650bf519f8 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -2174,6 +2174,7 @@ int __init acpi_scan_init(void)
 	acpi_pci_root_init();
 	acpi_pci_link_init();
 	acpi_processor_init();
+	acpi_platform_init();
 	acpi_lpss_init();
 	acpi_apd_init();
 	acpi_cmos_rtc_init();
-- 
2.20.1



