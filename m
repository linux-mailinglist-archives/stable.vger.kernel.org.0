Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FFA0106D58
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:59:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730896AbfKVK7V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:59:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:50252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730894AbfKVK7U (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:59:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E95420730;
        Fri, 22 Nov 2019 10:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420360;
        bh=GLgwkBO1KEs44BKp6ccObxLRmL9YCEqi1g0TfMe05Lw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rYEJf0TS8tITcz09UojQ/mwTpKEeymMloiGdyPQtMRDqoNWV5rJ2w4Y0E8DWFQLlN
         /ny7u8P0gQn2RtfoYsJ8Z56y1o9Ii2bCw2wRvy3siIKH17UmcTG2c2pS1fn1KpenB+
         SFyAmmcsiKfTNbHXDwZDFsfwkIryJMkX2PnItF58=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 026/220] ACPI / LPSS: Make acpi_lpss_find_device() also find PCI devices
Date:   Fri, 22 Nov 2019 11:26:31 +0100
Message-Id: <20191122100914.347957765@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 7eda27d43b482..3ef22d50df302 100644
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
@@ -512,12 +513,18 @@ static int match_hid_uid(struct device *dev, void *data)
 
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



