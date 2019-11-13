Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F4189FA648
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:28:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727463AbfKMBum (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:50:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:37494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727458AbfKMBul (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:50:41 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69B5122459;
        Wed, 13 Nov 2019 01:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573609841;
        bh=MbvfzHdLIyxp1OB5gLuB0mj1aev0t0AolzqUnsL+2KU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cl/jQo9/ViDXPVhIDJ3g6WQkUxeYY4Qu+JPI9vClFV+AMHBautMO2sFhw4WjZlneF
         v+6jHKvH4hoNSMgxewwOQMxlpQrvrL8S2wL4LFdffE9hEDmdOPWroiVOhvBdi9reHM
         gl6VImlM4ALdHGdstpEr4AFqCuWVBGp3DLmZ7fA4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 013/209] ACPI / LPSS: Make acpi_lpss_find_device() also find PCI devices
Date:   Tue, 12 Nov 2019 20:47:09 -0500
Message-Id: <20191113015025.9685-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 1e30124ac60abc41d74793900f8b4034f29bcb3d ]

On some Cherry Trail systems the GPU ACPI fwnode has power-resources which
point to the PMIC, which is connected over one of the LPSS I2C controllers.

To get the suspend/resume ordering correct for this we need to be able to
add device-links between the GPU and the I2c controller. The GPU is a PCI
device, so this requires acpi_lpss_find_device() to also work on PCI devs.

Tested-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_lpss.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/acpi_lpss.c b/drivers/acpi/acpi_lpss.c
index c651e206d7960..924b9f089e79f 100644
--- a/drivers/acpi/acpi_lpss.c
+++ b/drivers/acpi/acpi_lpss.c
@@ -16,6 +16,7 @@
 #include <linux/err.h>
 #include <linux/io.h>
 #include <linux/mutex.h>
+#include <linux/pci.h>
 #include <linux/platform_device.h>
 #include <linux/platform_data/clk-lpss.h>
 #include <linux/platform_data/x86/pmc_atom.h>
@@ -494,12 +495,18 @@ static int match_hid_uid(struct device *dev, void *data)
 
 static struct device *acpi_lpss_find_device(const char *hid, const char *uid)
 {
+	struct device *dev;
+
 	struct hid_uid data = {
 		.hid = hid,
 		.uid = uid,
 	};
 
-	return bus_find_device(&platform_bus_type, NULL, &data, match_hid_uid);
+	dev = bus_find_device(&platform_bus_type, NULL, &data, match_hid_uid);
+	if (dev)
+		return dev;
+
+	return bus_find_device(&pci_bus_type, NULL, &data, match_hid_uid);
 }
 
 static bool acpi_lpss_dep(struct acpi_device *adev, acpi_handle handle)
-- 
2.20.1

