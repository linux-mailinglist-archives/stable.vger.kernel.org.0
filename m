Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF1851483F7
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:41:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731514AbgAXLjP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:39:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:40520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403758AbgAXL0G (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:26:06 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BC572075D;
        Fri, 24 Jan 2020 11:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865165;
        bh=x93ckPFzgvDqJaL4wUMSQhMufzfjYtPQ2T3p1ALndo8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xU2Ti3fhauip6MZB95iPBt/tnTGzUL8DRiXuygbDCaseApOg4rKp7UNIgjnW2e16k
         QUJGFhSvU06GHjV+0XHcaR1ij4i7tEFtwWECFS3vvcg3frtNo8LgEOmHwJAcGeg+Uk
         C2NNcgM+9drNXUG+1816LSje8mBOMRXbHTvrl0s8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 463/639] ACPI: PM: Simplify and fix PM domain hibernation callbacks
Date:   Fri, 24 Jan 2020 10:30:33 +0100
Message-Id: <20200124093145.217524712@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 3cd7957e85e67120bb9f6bfb75d81dcc19af282b ]

First, after a previous change causing all runtime-suspended devices
in the ACPI PM domain (and ACPI LPSS devices) to be resumed before
creating a snapshot image of memory during hibernation, it is not
necessary to worry about the case in which them might be left in
runtime-suspend any more, so get rid of the code related to that from
ACPI PM domain and ACPI LPSS hibernation callbacks.

Second, it is not correct to use pm_generic_resume_early() and
acpi_subsys_resume_noirq() in hibernation "restore" callbacks (which
currently happens in the ACPI PM domain and ACPI LPSS), so introduce
proper _restore_late and _restore_noirq callbacks for the ACPI PM
domain and ACPI LPSS.

Fixes: 05087360fd7a (ACPI / PM: Take SMART_SUSPEND driver flag into account)
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_lpss.c | 61 ++++++++++++++++++++++++++++++++++------
 drivers/acpi/device_pm.c | 61 ++++++----------------------------------
 include/linux/acpi.h     | 10 -------
 3 files changed, 61 insertions(+), 71 deletions(-)

diff --git a/drivers/acpi/acpi_lpss.c b/drivers/acpi/acpi_lpss.c
index 30ccd94f87d24..11c460ab9de9c 100644
--- a/drivers/acpi/acpi_lpss.c
+++ b/drivers/acpi/acpi_lpss.c
@@ -1086,16 +1086,62 @@ static int acpi_lpss_resume_noirq(struct device *dev)
 	struct lpss_private_data *pdata = acpi_driver_data(ACPI_COMPANION(dev));
 	int ret;
 
-	ret = acpi_subsys_resume_noirq(dev);
+	/* Follow acpi_subsys_resume_noirq(). */
+	if (dev_pm_may_skip_resume(dev))
+		return 0;
+
+	if (dev_pm_smart_suspend_and_suspended(dev))
+		pm_runtime_set_active(dev);
+
+	ret = pm_generic_resume_noirq(dev);
 	if (ret)
 		return ret;
 
-	if (!dev_pm_may_skip_resume(dev) && pdata->dev_desc->resume_from_noirq)
-		ret = acpi_lpss_do_resume_early(dev);
+	if (!pdata->dev_desc->resume_from_noirq)
+		return 0;
 
-	return ret;
+	/*
+	 * The driver's ->resume_early callback will be invoked by
+	 * acpi_lpss_do_resume_early(), with the assumption that the driver
+	 * really wanted to run that code in ->resume_noirq, but it could not
+	 * run before acpi_dev_resume() and the driver expected the latter to be
+	 * called in the "early" phase.
+	 */
+	return acpi_lpss_do_resume_early(dev);
+}
+
+static int acpi_lpss_do_restore_early(struct device *dev)
+{
+	int ret = acpi_lpss_resume(dev);
+
+	return ret ? ret : pm_generic_restore_early(dev);
+}
+
+static int acpi_lpss_restore_early(struct device *dev)
+{
+	struct lpss_private_data *pdata = acpi_driver_data(ACPI_COMPANION(dev));
+
+	if (pdata->dev_desc->resume_from_noirq)
+		return 0;
+
+	return acpi_lpss_do_restore_early(dev);
 }
 
+static int acpi_lpss_restore_noirq(struct device *dev)
+{
+	struct lpss_private_data *pdata = acpi_driver_data(ACPI_COMPANION(dev));
+	int ret;
+
+	ret = pm_generic_restore_noirq(dev);
+	if (ret)
+		return ret;
+
+	if (!pdata->dev_desc->resume_from_noirq)
+		return 0;
+
+	/* This is analogous to what happens in acpi_lpss_resume_noirq(). */
+	return acpi_lpss_do_restore_early(dev);
+}
 #endif /* CONFIG_PM_SLEEP */
 
 static int acpi_lpss_runtime_suspend(struct device *dev)
@@ -1129,14 +1175,11 @@ static struct dev_pm_domain acpi_lpss_pm_domain = {
 		.resume_noirq = acpi_lpss_resume_noirq,
 		.resume_early = acpi_lpss_resume_early,
 		.freeze = acpi_subsys_freeze,
-		.freeze_late = acpi_subsys_freeze_late,
-		.freeze_noirq = acpi_subsys_freeze_noirq,
-		.thaw_noirq = acpi_subsys_thaw_noirq,
 		.poweroff = acpi_subsys_suspend,
 		.poweroff_late = acpi_lpss_suspend_late,
 		.poweroff_noirq = acpi_lpss_suspend_noirq,
-		.restore_noirq = acpi_lpss_resume_noirq,
-		.restore_early = acpi_lpss_resume_early,
+		.restore_noirq = acpi_lpss_restore_noirq,
+		.restore_early = acpi_lpss_restore_early,
 #endif
 		.runtime_suspend = acpi_lpss_runtime_suspend,
 		.runtime_resume = acpi_lpss_runtime_resume,
diff --git a/drivers/acpi/device_pm.c b/drivers/acpi/device_pm.c
index 11b7a1632e5aa..5a88a63e902dd 100644
--- a/drivers/acpi/device_pm.c
+++ b/drivers/acpi/device_pm.c
@@ -1077,7 +1077,7 @@ EXPORT_SYMBOL_GPL(acpi_subsys_suspend_noirq);
  * acpi_subsys_resume_noirq - Run the device driver's "noirq" resume callback.
  * @dev: Device to handle.
  */
-int acpi_subsys_resume_noirq(struct device *dev)
+static int acpi_subsys_resume_noirq(struct device *dev)
 {
 	if (dev_pm_may_skip_resume(dev))
 		return 0;
@@ -1092,7 +1092,6 @@ int acpi_subsys_resume_noirq(struct device *dev)
 
 	return pm_generic_resume_noirq(dev);
 }
-EXPORT_SYMBOL_GPL(acpi_subsys_resume_noirq);
 
 /**
  * acpi_subsys_resume_early - Resume device using ACPI.
@@ -1102,12 +1101,11 @@ EXPORT_SYMBOL_GPL(acpi_subsys_resume_noirq);
  * generic early resume procedure for it during system transition into the
  * working state.
  */
-int acpi_subsys_resume_early(struct device *dev)
+static int acpi_subsys_resume_early(struct device *dev)
 {
 	int ret = acpi_dev_resume(dev);
 	return ret ? ret : pm_generic_resume_early(dev);
 }
-EXPORT_SYMBOL_GPL(acpi_subsys_resume_early);
 
 /**
  * acpi_subsys_freeze - Run the device driver's freeze callback.
@@ -1130,52 +1128,15 @@ int acpi_subsys_freeze(struct device *dev)
 EXPORT_SYMBOL_GPL(acpi_subsys_freeze);
 
 /**
- * acpi_subsys_freeze_late - Run the device driver's "late" freeze callback.
- * @dev: Device to handle.
- */
-int acpi_subsys_freeze_late(struct device *dev)
-{
-
-	if (dev_pm_smart_suspend_and_suspended(dev))
-		return 0;
-
-	return pm_generic_freeze_late(dev);
-}
-EXPORT_SYMBOL_GPL(acpi_subsys_freeze_late);
-
-/**
- * acpi_subsys_freeze_noirq - Run the device driver's "noirq" freeze callback.
- * @dev: Device to handle.
- */
-int acpi_subsys_freeze_noirq(struct device *dev)
-{
-
-	if (dev_pm_smart_suspend_and_suspended(dev))
-		return 0;
-
-	return pm_generic_freeze_noirq(dev);
-}
-EXPORT_SYMBOL_GPL(acpi_subsys_freeze_noirq);
-
-/**
- * acpi_subsys_thaw_noirq - Run the device driver's "noirq" thaw callback.
- * @dev: Device to handle.
+ * acpi_subsys_restore_early - Restore device using ACPI.
+ * @dev: Device to restore.
  */
-int acpi_subsys_thaw_noirq(struct device *dev)
+int acpi_subsys_restore_early(struct device *dev)
 {
-	/*
-	 * If the device is in runtime suspend, the "thaw" code may not work
-	 * correctly with it, so skip the driver callback and make the PM core
-	 * skip all of the subsequent "thaw" callbacks for the device.
-	 */
-	if (dev_pm_smart_suspend_and_suspended(dev)) {
-		dev_pm_skip_next_resume_phases(dev);
-		return 0;
-	}
-
-	return pm_generic_thaw_noirq(dev);
+	int ret = acpi_dev_resume(dev);
+	return ret ? ret : pm_generic_restore_early(dev);
 }
-EXPORT_SYMBOL_GPL(acpi_subsys_thaw_noirq);
+EXPORT_SYMBOL_GPL(acpi_subsys_restore_early);
 #endif /* CONFIG_PM_SLEEP */
 
 static struct dev_pm_domain acpi_general_pm_domain = {
@@ -1191,14 +1152,10 @@ static struct dev_pm_domain acpi_general_pm_domain = {
 		.resume_noirq = acpi_subsys_resume_noirq,
 		.resume_early = acpi_subsys_resume_early,
 		.freeze = acpi_subsys_freeze,
-		.freeze_late = acpi_subsys_freeze_late,
-		.freeze_noirq = acpi_subsys_freeze_noirq,
-		.thaw_noirq = acpi_subsys_thaw_noirq,
 		.poweroff = acpi_subsys_suspend,
 		.poweroff_late = acpi_subsys_suspend_late,
 		.poweroff_noirq = acpi_subsys_suspend_noirq,
-		.restore_noirq = acpi_subsys_resume_noirq,
-		.restore_early = acpi_subsys_resume_early,
+		.restore_early = acpi_subsys_restore_early,
 #endif
 	},
 };
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index df1252e22dcfd..32fabeeda5e30 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -917,26 +917,16 @@ int acpi_subsys_prepare(struct device *dev);
 void acpi_subsys_complete(struct device *dev);
 int acpi_subsys_suspend_late(struct device *dev);
 int acpi_subsys_suspend_noirq(struct device *dev);
-int acpi_subsys_resume_noirq(struct device *dev);
-int acpi_subsys_resume_early(struct device *dev);
 int acpi_subsys_suspend(struct device *dev);
 int acpi_subsys_freeze(struct device *dev);
-int acpi_subsys_freeze_late(struct device *dev);
-int acpi_subsys_freeze_noirq(struct device *dev);
-int acpi_subsys_thaw_noirq(struct device *dev);
 #else
 static inline int acpi_dev_resume_early(struct device *dev) { return 0; }
 static inline int acpi_subsys_prepare(struct device *dev) { return 0; }
 static inline void acpi_subsys_complete(struct device *dev) {}
 static inline int acpi_subsys_suspend_late(struct device *dev) { return 0; }
 static inline int acpi_subsys_suspend_noirq(struct device *dev) { return 0; }
-static inline int acpi_subsys_resume_noirq(struct device *dev) { return 0; }
-static inline int acpi_subsys_resume_early(struct device *dev) { return 0; }
 static inline int acpi_subsys_suspend(struct device *dev) { return 0; }
 static inline int acpi_subsys_freeze(struct device *dev) { return 0; }
-static inline int acpi_subsys_freeze_late(struct device *dev) { return 0; }
-static inline int acpi_subsys_freeze_noirq(struct device *dev) { return 0; }
-static inline int acpi_subsys_thaw_noirq(struct device *dev) { return 0; }
 #endif
 
 #ifdef CONFIG_ACPI
-- 
2.20.1



