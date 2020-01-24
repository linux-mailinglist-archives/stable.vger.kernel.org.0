Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B0B714823F
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:26:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391550AbgAXL03 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:26:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:41242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391545AbgAXL02 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:26:28 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59123214AF;
        Fri, 24 Jan 2020 11:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865187;
        bh=4f4RpwB9h5gcsRe9rrdc/k8izgAmNBcHc4Ay2V5xdRI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0l3WpJpg5x+BGvjkOsjN5AUFK62HhICwjR2YVcGlNf1juZNLGGWrjmpDo5Uk1x2GZ
         IfoCjHYA+D4WUW/7cDYNAGWz0Y3gLa+OtmV5X4bPluLJksS/A9VFUxe85zHH4MxOgA
         IbRkeShTfjithoh2sp+dDOuVLoobxPgybmpotRLk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 464/639] ACPI: PM: Introduce "poweroff" callbacks for ACPI PM domain and LPSS
Date:   Fri, 24 Jan 2020 10:30:34 +0100
Message-Id: <20200124093145.347933550@linuxfoundation.org>
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

[ Upstream commit c95b7595f85c688d5c569ddbbd6ab6a4bdae2f36 ]

In general, it is not correct to call pm_generic_suspend(),
pm_generic_suspend_late() and pm_generic_suspend_noirq() during the
hibernation's "poweroff" transition, because device drivers may
provide special callbacks to be invoked then and the wrappers in
question cause system suspend callbacks to be run.  Unfortunately,
that happens in the ACPI PM domain and ACPI LPSS.

To address this potential issue, introduce "poweroff" callbacks
for the ACPI PM and LPSS that will use pm_generic_poweroff(),
pm_generic_poweroff_late() and pm_generic_poweroff_noirq() as
appropriate.

Fixes: 05087360fd7a (ACPI / PM: Take SMART_SUSPEND driver flag into account)
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_lpss.c | 50 +++++++++++++++++++++++++++++++---
 drivers/acpi/device_pm.c | 58 +++++++++++++++++++++++++++++++++++++---
 include/linux/acpi.h     |  2 ++
 3 files changed, 104 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/acpi_lpss.c b/drivers/acpi/acpi_lpss.c
index 11c460ab9de9c..ded6c5c17fd73 100644
--- a/drivers/acpi/acpi_lpss.c
+++ b/drivers/acpi/acpi_lpss.c
@@ -1056,6 +1056,13 @@ static int acpi_lpss_suspend_noirq(struct device *dev)
 	int ret;
 
 	if (pdata->dev_desc->resume_from_noirq) {
+		/*
+		 * The driver's ->suspend_late callback will be invoked by
+		 * acpi_lpss_do_suspend_late(), with the assumption that the
+		 * driver really wanted to run that code in ->suspend_noirq, but
+		 * it could not run after acpi_dev_suspend() and the driver
+		 * expected the latter to be called in the "late" phase.
+		 */
 		ret = acpi_lpss_do_suspend_late(dev);
 		if (ret)
 			return ret;
@@ -1142,6 +1149,43 @@ static int acpi_lpss_restore_noirq(struct device *dev)
 	/* This is analogous to what happens in acpi_lpss_resume_noirq(). */
 	return acpi_lpss_do_restore_early(dev);
 }
+
+static int acpi_lpss_do_poweroff_late(struct device *dev)
+{
+	int ret = pm_generic_poweroff_late(dev);
+
+	return ret ? ret : acpi_lpss_suspend(dev, device_may_wakeup(dev));
+}
+
+static int acpi_lpss_poweroff_late(struct device *dev)
+{
+	struct lpss_private_data *pdata = acpi_driver_data(ACPI_COMPANION(dev));
+
+	if (dev_pm_smart_suspend_and_suspended(dev))
+		return 0;
+
+	if (pdata->dev_desc->resume_from_noirq)
+		return 0;
+
+	return acpi_lpss_do_poweroff_late(dev);
+}
+
+static int acpi_lpss_poweroff_noirq(struct device *dev)
+{
+	struct lpss_private_data *pdata = acpi_driver_data(ACPI_COMPANION(dev));
+
+	if (dev_pm_smart_suspend_and_suspended(dev))
+		return 0;
+
+	if (pdata->dev_desc->resume_from_noirq) {
+		/* This is analogous to the acpi_lpss_suspend_noirq() case. */
+		int ret = acpi_lpss_do_poweroff_late(dev);
+		if (ret)
+			return ret;
+	}
+
+	return pm_generic_poweroff_noirq(dev);
+}
 #endif /* CONFIG_PM_SLEEP */
 
 static int acpi_lpss_runtime_suspend(struct device *dev)
@@ -1175,9 +1219,9 @@ static struct dev_pm_domain acpi_lpss_pm_domain = {
 		.resume_noirq = acpi_lpss_resume_noirq,
 		.resume_early = acpi_lpss_resume_early,
 		.freeze = acpi_subsys_freeze,
-		.poweroff = acpi_subsys_suspend,
-		.poweroff_late = acpi_lpss_suspend_late,
-		.poweroff_noirq = acpi_lpss_suspend_noirq,
+		.poweroff = acpi_subsys_poweroff,
+		.poweroff_late = acpi_lpss_poweroff_late,
+		.poweroff_noirq = acpi_lpss_poweroff_noirq,
 		.restore_noirq = acpi_lpss_restore_noirq,
 		.restore_early = acpi_lpss_restore_early,
 #endif
diff --git a/drivers/acpi/device_pm.c b/drivers/acpi/device_pm.c
index 5a88a63e902dd..54b6547d32b24 100644
--- a/drivers/acpi/device_pm.c
+++ b/drivers/acpi/device_pm.c
@@ -1137,6 +1137,58 @@ int acpi_subsys_restore_early(struct device *dev)
 	return ret ? ret : pm_generic_restore_early(dev);
 }
 EXPORT_SYMBOL_GPL(acpi_subsys_restore_early);
+
+/**
+ * acpi_subsys_poweroff - Run the device driver's poweroff callback.
+ * @dev: Device to handle.
+ *
+ * Follow PCI and resume devices from runtime suspend before running their
+ * system poweroff callbacks, unless the driver can cope with runtime-suspended
+ * devices during system suspend and there are no ACPI-specific reasons for
+ * resuming them.
+ */
+int acpi_subsys_poweroff(struct device *dev)
+{
+	if (!dev_pm_test_driver_flags(dev, DPM_FLAG_SMART_SUSPEND) ||
+	    acpi_dev_needs_resume(dev, ACPI_COMPANION(dev)))
+		pm_runtime_resume(dev);
+
+	return pm_generic_poweroff(dev);
+}
+EXPORT_SYMBOL_GPL(acpi_subsys_poweroff);
+
+/**
+ * acpi_subsys_poweroff_late - Run the device driver's poweroff callback.
+ * @dev: Device to handle.
+ *
+ * Carry out the generic late poweroff procedure for @dev and use ACPI to put
+ * it into a low-power state during system transition into a sleep state.
+ */
+static int acpi_subsys_poweroff_late(struct device *dev)
+{
+	int ret;
+
+	if (dev_pm_smart_suspend_and_suspended(dev))
+		return 0;
+
+	ret = pm_generic_poweroff_late(dev);
+	if (ret)
+		return ret;
+
+	return acpi_dev_suspend(dev, device_may_wakeup(dev));
+}
+
+/**
+ * acpi_subsys_poweroff_noirq - Run the driver's "noirq" poweroff callback.
+ * @dev: Device to suspend.
+ */
+static int acpi_subsys_poweroff_noirq(struct device *dev)
+{
+	if (dev_pm_smart_suspend_and_suspended(dev))
+		return 0;
+
+	return pm_generic_poweroff_noirq(dev);
+}
 #endif /* CONFIG_PM_SLEEP */
 
 static struct dev_pm_domain acpi_general_pm_domain = {
@@ -1152,9 +1204,9 @@ static struct dev_pm_domain acpi_general_pm_domain = {
 		.resume_noirq = acpi_subsys_resume_noirq,
 		.resume_early = acpi_subsys_resume_early,
 		.freeze = acpi_subsys_freeze,
-		.poweroff = acpi_subsys_suspend,
-		.poweroff_late = acpi_subsys_suspend_late,
-		.poweroff_noirq = acpi_subsys_suspend_noirq,
+		.poweroff = acpi_subsys_poweroff,
+		.poweroff_late = acpi_subsys_poweroff_late,
+		.poweroff_noirq = acpi_subsys_poweroff_noirq,
 		.restore_early = acpi_subsys_restore_early,
 #endif
 	},
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 32fabeeda5e30..cd412817654fa 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -919,6 +919,7 @@ int acpi_subsys_suspend_late(struct device *dev);
 int acpi_subsys_suspend_noirq(struct device *dev);
 int acpi_subsys_suspend(struct device *dev);
 int acpi_subsys_freeze(struct device *dev);
+int acpi_subsys_poweroff(struct device *dev);
 #else
 static inline int acpi_dev_resume_early(struct device *dev) { return 0; }
 static inline int acpi_subsys_prepare(struct device *dev) { return 0; }
@@ -927,6 +928,7 @@ static inline int acpi_subsys_suspend_late(struct device *dev) { return 0; }
 static inline int acpi_subsys_suspend_noirq(struct device *dev) { return 0; }
 static inline int acpi_subsys_suspend(struct device *dev) { return 0; }
 static inline int acpi_subsys_freeze(struct device *dev) { return 0; }
+static inline int acpi_subsys_poweroff(struct device *dev) { return 0; }
 #endif
 
 #ifdef CONFIG_ACPI
-- 
2.20.1



