Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF5E644B686
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:25:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344274AbhKIW1s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:27:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:49758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344349AbhKIWZ6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:25:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 13C2961151;
        Tue,  9 Nov 2021 22:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496380;
        bh=+6MaLoaHGFm8kGosi0/I/7u7cIJZ+Yq9vV4GgxgLzGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tJJ11OOSv5J5RcqePfmwDfT7yFOUo00Xq28bsq0uV7due1A7fxGU+hbT/r7G4OeMK
         f14L2pVSuyyHiF4aNiBkwujKgi5Sq+LN8IqFj3G8d72IhBqVt6IbBG7PjqmVWFH21Z
         eb4xfP0X0lfv1hoDwo+sM8Oy4G8RG8IR58gT/hmDFqUSDKxydzksLv+hRvWxcX6x9E
         aSRIxFtJECC7mj2py1DfFW5QWqaUo9ZcSHubjEj44rPyX40kOCHM+s69AhVSRzJolX
         upWFOh404Rhx7AV0qHMX8nHL6/TG/CYdfDHMWDaKw+XebNxejKbn37vEVITrRF7P0N
         LlZLD/xTumvCQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.14 18/75] bus: ti-sysc: Add quirk handling for reinit on context lost
Date:   Tue,  9 Nov 2021 17:18:08 -0500
Message-Id: <20211109221905.1234094-18-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109221905.1234094-1-sashal@kernel.org>
References: <20211109221905.1234094-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 9d881361206ebcf6285c2ec2ef275aff80875347 ]

Some interconnect target modules such as otg and gpmc on am335x need a
re-init after resume. As we also have PM runtime cases where the context
may be lost, let's handle these all with cpu_pm.

For the am335x resume path, we already have cpu_pm_resume() call
cpu_pm_cluster_exit().

Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/ti-sysc.c                 | 108 ++++++++++++++++++++++++--
 include/linux/platform_data/ti-sysc.h |   1 +
 2 files changed, 103 insertions(+), 6 deletions(-)

diff --git a/drivers/bus/ti-sysc.c b/drivers/bus/ti-sysc.c
index 418ada474a85d..51f67223d2514 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -6,6 +6,7 @@
 #include <linux/io.h>
 #include <linux/clk.h>
 #include <linux/clkdev.h>
+#include <linux/cpu_pm.h>
 #include <linux/delay.h>
 #include <linux/list.h>
 #include <linux/module.h>
@@ -51,11 +52,18 @@ struct sysc_address {
 	struct list_head node;
 };
 
+struct sysc_module {
+	struct sysc *ddata;
+	struct list_head node;
+};
+
 struct sysc_soc_info {
 	unsigned long general_purpose:1;
 	enum sysc_soc soc;
-	struct mutex list_lock;			/* disabled modules list lock */
+	struct mutex list_lock;	/* disabled and restored modules list lock */
 	struct list_head disabled_modules;
+	struct list_head restored_modules;
+	struct notifier_block nb;
 };
 
 enum sysc_clocks {
@@ -2402,6 +2410,79 @@ static struct dev_pm_domain sysc_child_pm_domain = {
 	}
 };
 
+/* Caller needs to take list_lock if ever used outside of cpu_pm */
+static void sysc_reinit_modules(struct sysc_soc_info *soc)
+{
+	struct sysc_module *module;
+	struct list_head *pos;
+	struct sysc *ddata;
+	int error = 0;
+
+	list_for_each(pos, &sysc_soc->restored_modules) {
+		module = list_entry(pos, struct sysc_module, node);
+		ddata = module->ddata;
+		error = sysc_reinit_module(ddata, ddata->enabled);
+	}
+}
+
+/**
+ * sysc_context_notifier - optionally reset and restore module after idle
+ * @nb: notifier block
+ * @cmd: unused
+ * @v: unused
+ *
+ * Some interconnect target modules need to be restored, or reset and restored
+ * on CPU_PM CPU_PM_CLUSTER_EXIT notifier. This is needed at least for am335x
+ * OTG and GPMC target modules even if the modules are unused.
+ */
+static int sysc_context_notifier(struct notifier_block *nb, unsigned long cmd,
+				 void *v)
+{
+	struct sysc_soc_info *soc;
+
+	soc = container_of(nb, struct sysc_soc_info, nb);
+
+	switch (cmd) {
+	case CPU_CLUSTER_PM_ENTER:
+		break;
+	case CPU_CLUSTER_PM_ENTER_FAILED:	/* No need to restore context */
+		break;
+	case CPU_CLUSTER_PM_EXIT:
+		sysc_reinit_modules(soc);
+		break;
+	}
+
+	return NOTIFY_OK;
+}
+
+/**
+ * sysc_add_restored - optionally add reset and restore quirk hanlling
+ * @ddata: device data
+ */
+static void sysc_add_restored(struct sysc *ddata)
+{
+	struct sysc_module *restored_module;
+
+	restored_module = kzalloc(sizeof(*restored_module), GFP_KERNEL);
+	if (!restored_module)
+		return;
+
+	restored_module->ddata = ddata;
+
+	mutex_lock(&sysc_soc->list_lock);
+
+	list_add(&restored_module->node, &sysc_soc->restored_modules);
+
+	if (sysc_soc->nb.notifier_call)
+		goto out_unlock;
+
+	sysc_soc->nb.notifier_call = sysc_context_notifier;
+	cpu_pm_register_notifier(&sysc_soc->nb);
+
+out_unlock:
+	mutex_unlock(&sysc_soc->list_lock);
+}
+
 /**
  * sysc_legacy_idle_quirk - handle children in omap_device compatible way
  * @ddata: device driver data
@@ -2901,12 +2982,14 @@ static int sysc_add_disabled(unsigned long base)
 }
 
 /*
- * One time init to detect the booted SoC and disable unavailable features.
+ * One time init to detect the booted SoC, disable unavailable features
+ * and initialize list for optional cpu_pm notifier.
+ *
  * Note that we initialize static data shared across all ti-sysc instances
  * so ddata is only used for SoC type. This can be called from module_init
  * once we no longer need to rely on platform data.
  */
-static int sysc_init_soc(struct sysc *ddata)
+static int sysc_init_static_data(struct sysc *ddata)
 {
 	const struct soc_device_attribute *match;
 	struct ti_sysc_platform_data *pdata;
@@ -2922,6 +3005,7 @@ static int sysc_init_soc(struct sysc *ddata)
 
 	mutex_init(&sysc_soc->list_lock);
 	INIT_LIST_HEAD(&sysc_soc->disabled_modules);
+	INIT_LIST_HEAD(&sysc_soc->restored_modules);
 	sysc_soc->general_purpose = true;
 
 	pdata = dev_get_platdata(ddata->dev);
@@ -2986,15 +3070,24 @@ static int sysc_init_soc(struct sysc *ddata)
 	return 0;
 }
 
-static void sysc_cleanup_soc(void)
+static void sysc_cleanup_static_data(void)
 {
+	struct sysc_module *restored_module;
 	struct sysc_address *disabled_module;
 	struct list_head *pos, *tmp;
 
 	if (!sysc_soc)
 		return;
 
+	if (sysc_soc->nb.notifier_call)
+		cpu_pm_unregister_notifier(&sysc_soc->nb);
+
 	mutex_lock(&sysc_soc->list_lock);
+	list_for_each_safe(pos, tmp, &sysc_soc->restored_modules) {
+		restored_module = list_entry(pos, struct sysc_module, node);
+		list_del(pos);
+		kfree(restored_module);
+	}
 	list_for_each_safe(pos, tmp, &sysc_soc->disabled_modules) {
 		disabled_module = list_entry(pos, struct sysc_address, node);
 		list_del(pos);
@@ -3062,7 +3155,7 @@ static int sysc_probe(struct platform_device *pdev)
 	ddata->dev = &pdev->dev;
 	platform_set_drvdata(pdev, ddata);
 
-	error = sysc_init_soc(ddata);
+	error = sysc_init_static_data(ddata);
 	if (error)
 		return error;
 
@@ -3161,6 +3254,9 @@ static int sysc_probe(struct platform_device *pdev)
 		pm_runtime_put(&pdev->dev);
 	}
 
+	if (ddata->cfg.quirks & SYSC_QUIRK_REINIT_ON_CTX_LOST)
+		sysc_add_restored(ddata);
+
 	return 0;
 
 err:
@@ -3243,7 +3339,7 @@ static void __exit sysc_exit(void)
 {
 	bus_unregister_notifier(&platform_bus_type, &sysc_nb);
 	platform_driver_unregister(&sysc_driver);
-	sysc_cleanup_soc();
+	sysc_cleanup_static_data();
 }
 module_exit(sysc_exit);
 
diff --git a/include/linux/platform_data/ti-sysc.h b/include/linux/platform_data/ti-sysc.h
index 9837fb011f2fb..989aa30c598dc 100644
--- a/include/linux/platform_data/ti-sysc.h
+++ b/include/linux/platform_data/ti-sysc.h
@@ -50,6 +50,7 @@ struct sysc_regbits {
 	s8 emufree_shift;
 };
 
+#define SYSC_QUIRK_REINIT_ON_CTX_LOST	BIT(28)
 #define SYSC_QUIRK_REINIT_ON_RESUME	BIT(27)
 #define SYSC_QUIRK_GPMC_DEBUG		BIT(26)
 #define SYSC_MODULE_QUIRK_ENA_RESETDONE	BIT(25)
-- 
2.33.0

