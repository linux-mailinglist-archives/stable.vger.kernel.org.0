Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8842C106D08
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727790AbfKVK5G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:57:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:45690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730392AbfKVK5F (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:57:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5AEC220721;
        Fri, 22 Nov 2019 10:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420224;
        bh=NPj3KS7jPS6DFE0QMHAWCTIWXh2ANjzmGwTADLlKwZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fGB0IO0IruMwTWM8qVNBz5rRIelcy6Exww2siy9RPqNsb8pOxfObsJZRFPl0DGuOO
         /2I8jJr0D08rjmLiUHDJcpL2rWahM8vtSd+A1IA0kTCWKj+Pky92qqJnjR+PyttxLk
         3Gyz5SxngZUZTt6yZlgHKus6nHXR/jTQg0APkz4Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 027/220] ACPI / LPSS: Resume BYT/CHT I2C controllers from resume_noirq
Date:   Fri, 22 Nov 2019 11:26:32 +0100
Message-Id: <20191122100914.404150543@linuxfoundation.org>
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

[ Upstream commit 48402cee6889fb3fce58e95fea1471626286dc63 ]

On some Cherry Trail systems the GPU ACPI fwnode has power-resources which
point to the PMIC, which is connected over a LPSS I2C controller.

We add a device-link to make sure that the I2C controller is resumed before
the GPU is. But the pci-core changes the power-state of PCI devices from
D3 to D0 at noirq time (to restore the PCI config registers) and before
this commit we were bringing up the I2C controllers from a resume_early
handler which runs later. More specifically the pm-core will first run
all resume_noirq handlers in order and then all resume_early handlers.

So we must not only make sure that the handlers are run in the right order,
but also that the resume of the I2C controller is done at noirq time.

The behavior before this commit, resuming the I2C controller from a
resume_early handler leads to the following errors:

 i2c_designware 808622C1:06: controller timed out
 ACPI Error: AE_ERROR, Returned by Handler for [UserDefinedRegion]
 ACPI Error: Method parse/execution failed \_SB.P18W._ON, AE_ERROR
 video LNXVIDEO:00: Failed to change power state to D0

This commit changes the acpi_lpss.c code to resume the BYT/CHT I2C
controllers at resume_noirq time fixing this.

Tested-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_lpss.c | 61 +++++++++++++++++++++++++++++++++++++---
 1 file changed, 57 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/acpi_lpss.c b/drivers/acpi/acpi_lpss.c
index 3ef22d50df302..dec9024fc49ec 100644
--- a/drivers/acpi/acpi_lpss.c
+++ b/drivers/acpi/acpi_lpss.c
@@ -84,6 +84,7 @@ struct lpss_device_desc {
 	size_t prv_size_override;
 	struct property_entry *properties;
 	void (*setup)(struct lpss_private_data *pdata);
+	bool resume_from_noirq;
 };
 
 static const struct lpss_device_desc lpss_dma_desc = {
@@ -293,12 +294,14 @@ static const struct lpss_device_desc byt_i2c_dev_desc = {
 	.flags = LPSS_CLK | LPSS_SAVE_CTX,
 	.prv_offset = 0x800,
 	.setup = byt_i2c_setup,
+	.resume_from_noirq = true,
 };
 
 static const struct lpss_device_desc bsw_i2c_dev_desc = {
 	.flags = LPSS_CLK | LPSS_SAVE_CTX | LPSS_NO_D3_DELAY,
 	.prv_offset = 0x800,
 	.setup = byt_i2c_setup,
+	.resume_from_noirq = true,
 };
 
 static const struct lpss_device_desc bsw_spi_dev_desc = {
@@ -1031,7 +1034,7 @@ static int acpi_lpss_resume(struct device *dev)
 }
 
 #ifdef CONFIG_PM_SLEEP
-static int acpi_lpss_suspend_late(struct device *dev)
+static int acpi_lpss_do_suspend_late(struct device *dev)
 {
 	int ret;
 
@@ -1042,12 +1045,62 @@ static int acpi_lpss_suspend_late(struct device *dev)
 	return ret ? ret : acpi_lpss_suspend(dev, device_may_wakeup(dev));
 }
 
-static int acpi_lpss_resume_early(struct device *dev)
+static int acpi_lpss_suspend_late(struct device *dev)
+{
+	struct lpss_private_data *pdata = acpi_driver_data(ACPI_COMPANION(dev));
+
+	if (pdata->dev_desc->resume_from_noirq)
+		return 0;
+
+	return acpi_lpss_do_suspend_late(dev);
+}
+
+static int acpi_lpss_suspend_noirq(struct device *dev)
+{
+	struct lpss_private_data *pdata = acpi_driver_data(ACPI_COMPANION(dev));
+	int ret;
+
+	if (pdata->dev_desc->resume_from_noirq) {
+		ret = acpi_lpss_do_suspend_late(dev);
+		if (ret)
+			return ret;
+	}
+
+	return acpi_subsys_suspend_noirq(dev);
+}
+
+static int acpi_lpss_do_resume_early(struct device *dev)
 {
 	int ret = acpi_lpss_resume(dev);
 
 	return ret ? ret : pm_generic_resume_early(dev);
 }
+
+static int acpi_lpss_resume_early(struct device *dev)
+{
+	struct lpss_private_data *pdata = acpi_driver_data(ACPI_COMPANION(dev));
+
+	if (pdata->dev_desc->resume_from_noirq)
+		return 0;
+
+	return acpi_lpss_do_resume_early(dev);
+}
+
+static int acpi_lpss_resume_noirq(struct device *dev)
+{
+	struct lpss_private_data *pdata = acpi_driver_data(ACPI_COMPANION(dev));
+	int ret;
+
+	ret = acpi_subsys_resume_noirq(dev);
+	if (ret)
+		return ret;
+
+	if (!dev_pm_may_skip_resume(dev) && pdata->dev_desc->resume_from_noirq)
+		ret = acpi_lpss_do_resume_early(dev);
+
+	return ret;
+}
+
 #endif /* CONFIG_PM_SLEEP */
 
 static int acpi_lpss_runtime_suspend(struct device *dev)
@@ -1077,8 +1130,8 @@ static struct dev_pm_domain acpi_lpss_pm_domain = {
 		.complete = acpi_subsys_complete,
 		.suspend = acpi_subsys_suspend,
 		.suspend_late = acpi_lpss_suspend_late,
-		.suspend_noirq = acpi_subsys_suspend_noirq,
-		.resume_noirq = acpi_subsys_resume_noirq,
+		.suspend_noirq = acpi_lpss_suspend_noirq,
+		.resume_noirq = acpi_lpss_resume_noirq,
 		.resume_early = acpi_lpss_resume_early,
 		.freeze = acpi_subsys_freeze,
 		.freeze_late = acpi_subsys_freeze_late,
-- 
2.20.1



