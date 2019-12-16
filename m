Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86E01121535
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:20:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731947AbfLPSTc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:19:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:48030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731945AbfLPSTc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:19:32 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 010CF21835;
        Mon, 16 Dec 2019 18:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576520371;
        bh=ftSUF9rQfpuhuW0x47/BZ8HPE4U+C48zwwL/o4E7juw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P/tNMG57NKaxkao+J5l7Bo9YIk2wBlymMcX2MxDPht6kHIXXAFWZ2ovjX5JKPWise
         6znl3IZ/gTNQtwVmm2nHeRvtuVFeE6MPsMfvPyBk4wlWe32lUCyI6sPs0qQQHPAC1i
         ff6Wp1KyuIsuQs/wYbJdozuxCOLxyotaQDaDYNjA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.4 125/177] ACPI: LPSS: Add dmi quirk for skipping _DEP check for some device-links
Date:   Mon, 16 Dec 2019 18:49:41 +0100
Message-Id: <20191216174843.808178010@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174811.158424118@linuxfoundation.org>
References: <20191216174811.158424118@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit 6025e2fae3dde3c3d789d08f8ceacbdd9f90d471 upstream.

The iGPU / GFX0 device's _PS0 method on the ASUS T200TA depends on the
I2C1 controller (which is connected to the embedded controller). But unlike
in the T100TA/T100CHI this dependency is not listed in the _DEP of the GFX0
device.

This results in the dev_WARN_ONCE(..., "Transfer while suspended\n") call
in i2c-designware-master.c triggering and the AML code not working as it
should.

This commit fixes this by adding a dmi based quirk mechanism for devices
which miss a _DEP, and adding a quirk for the LNXVIDEO depending on the
I2C1 device on the Asus T200TA.

Fixes: 2d71ee0ce72f ("ACPI / LPSS: Add a device link from the GPU to the BYT I2C5 controller")
Tested-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: 4.20+ <stable@vger.kernel.org> # 4.20+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/acpi_lpss.c |   22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

--- a/drivers/acpi/acpi_lpss.c
+++ b/drivers/acpi/acpi_lpss.c
@@ -10,6 +10,7 @@
 #include <linux/acpi.h>
 #include <linux/clkdev.h>
 #include <linux/clk-provider.h>
+#include <linux/dmi.h>
 #include <linux/err.h>
 #include <linux/io.h>
 #include <linux/mutex.h>
@@ -463,6 +464,18 @@ struct lpss_device_links {
 	const char *consumer_hid;
 	const char *consumer_uid;
 	u32 flags;
+	const struct dmi_system_id *dep_missing_ids;
+};
+
+/* Please keep this list sorted alphabetically by vendor and model */
+static const struct dmi_system_id i2c1_dep_missing_dmi_ids[] = {
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "T200TA"),
+		},
+	},
+	{}
 };
 
 /*
@@ -478,7 +491,8 @@ static const struct lpss_device_links lp
 	/* CHT iGPU depends on PMIC I2C controller */
 	{"808622C1", "7", "LNXVIDEO", NULL, DL_FLAG_PM_RUNTIME},
 	/* BYT iGPU depends on the Embedded Controller I2C controller (UID 1) */
-	{"80860F41", "1", "LNXVIDEO", NULL, DL_FLAG_PM_RUNTIME},
+	{"80860F41", "1", "LNXVIDEO", NULL, DL_FLAG_PM_RUNTIME,
+	 i2c1_dep_missing_dmi_ids},
 	/* BYT CR iGPU depends on PMIC I2C controller (UID 5 on CR) */
 	{"80860F41", "5", "LNXVIDEO", NULL, DL_FLAG_PM_RUNTIME},
 	/* BYT iGPU depends on PMIC I2C controller (UID 7 on non CR) */
@@ -577,7 +591,8 @@ static void acpi_lpss_link_consumer(stru
 	if (!dev2)
 		return;
 
-	if (acpi_lpss_dep(ACPI_COMPANION(dev2), ACPI_HANDLE(dev1)))
+	if ((link->dep_missing_ids && dmi_check_system(link->dep_missing_ids))
+	    || acpi_lpss_dep(ACPI_COMPANION(dev2), ACPI_HANDLE(dev1)))
 		device_link_add(dev2, dev1, link->flags);
 
 	put_device(dev2);
@@ -592,7 +607,8 @@ static void acpi_lpss_link_supplier(stru
 	if (!dev2)
 		return;
 
-	if (acpi_lpss_dep(ACPI_COMPANION(dev1), ACPI_HANDLE(dev2)))
+	if ((link->dep_missing_ids && dmi_check_system(link->dep_missing_ids))
+	    || acpi_lpss_dep(ACPI_COMPANION(dev1), ACPI_HANDLE(dev2)))
 		device_link_add(dev1, dev2, link->flags);
 
 	put_device(dev2);


