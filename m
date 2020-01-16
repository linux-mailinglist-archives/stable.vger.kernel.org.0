Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF7913F456
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:49:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437028AbgAPStE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:49:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:45600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389701AbgAPRJc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:09:32 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D14702081E;
        Thu, 16 Jan 2020 17:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194571;
        bh=B5gsY/tTFv5kvvkpeM+jRp38ykFFb+cvoqjTkeKt+DE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VCYH5DhPhoAA2zKYnLCPeiWkyyJWCgafERyK3+P3/P1jsKbD5XzLa69v+SqNrBzoe
         5Vjk6qfvAk6J5FNMFtDS7OmBxeuztCfvA+QRmyUcgNEJr1Ae3gA5xwjLKM3freo4cM
         fOY+C+QgBjWfkMSYwWLpmxzIJJ9tob5JCUpHTKZg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 448/671] ACPI: PM: Simplify and fix PM domain hibernation callbacks
Date:   Thu, 16 Jan 2020 12:01:26 -0500
Message-Id: <20200116170509.12787-185-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

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
index 30ccd94f87d2..11c460ab9de9 100644
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
index 11b7a1632e5a..5a88a63e902d 100644
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
index df1252e22dcf..32fabeeda5e3 100644
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

