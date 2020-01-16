Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0B8913E104
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:47:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729368AbgAPQrL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:47:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:56848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729862AbgAPQrI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:47:08 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B9CB21582;
        Thu, 16 Jan 2020 16:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193228;
        bh=Yy84DGQLF/tHpAhgKO6JE9/YdrRcR9e+usfeH9XJYXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0duIkbEIGjIYHrud0BUWfk22jYXm9tdhBucvSHYYp6CGK/wNbVLi/CtbrYiLX7Vd2
         kjpiGy9oX7kJdldVCh++RZQTgYe21usdK/LPSRgFO6Q+Cvq4dwZQWtzO/rXmdTEX5z
         1OWlO0Z0ACtItmqlhOw4PzzwtM2TEOE6JXCxAfQg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 050/205] ACPI: platform: Unregister stale platform devices
Date:   Thu, 16 Jan 2020 11:40:25 -0500
Message-Id: <20200116164300.6705-50-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
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
index 00ec4f2bf015..c05050f474cd 100644
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
index aad6be5c0af0..915650bf519f 100644
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

