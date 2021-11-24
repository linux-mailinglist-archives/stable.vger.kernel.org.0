Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8F345C45E
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:46:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351594AbhKXNrr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:47:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:39076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348743AbhKXNpl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:45:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 64D2D6120E;
        Wed, 24 Nov 2021 13:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758852;
        bh=G/6OuPdHtKC54/cCxXncHsWE5OclPWPXDhxIzo0lIdo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hH1GvjDCjH9C7VPpeQzIGY0iL5+3FRu5mgTb9Nn+ExMeffu7j3bu6YuxipAYnX8rh
         lyoIuoFQxF/U8j5CKkpPdoFP3LkKKHoQsCezNPjdE3QRVh8pRTxx1lgZ0H7NIf7V25
         3Ood4NOk2nvnFOd7ZD/vUr0A5KDd8h7xZynr2wfc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 018/279] bus: ti-sysc: Add quirk handling for reinit on context lost
Date:   Wed, 24 Nov 2021 12:55:05 +0100
Message-Id: <20211124115719.382960124@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index f47c7e20cc271..7c645754a82b1 100644
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
@@ -52,11 +53,18 @@ struct sysc_address {
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
@@ -2442,6 +2450,79 @@ static struct dev_pm_domain sysc_child_pm_domain = {
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
@@ -2941,12 +3022,14 @@ static int sysc_add_disabled(unsigned long base)
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
@@ -2962,6 +3045,7 @@ static int sysc_init_soc(struct sysc *ddata)
 
 	mutex_init(&sysc_soc->list_lock);
 	INIT_LIST_HEAD(&sysc_soc->disabled_modules);
+	INIT_LIST_HEAD(&sysc_soc->restored_modules);
 	sysc_soc->general_purpose = true;
 
 	pdata = dev_get_platdata(ddata->dev);
@@ -3026,15 +3110,24 @@ static int sysc_init_soc(struct sysc *ddata)
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
@@ -3102,7 +3195,7 @@ static int sysc_probe(struct platform_device *pdev)
 	ddata->dev = &pdev->dev;
 	platform_set_drvdata(pdev, ddata);
 
-	error = sysc_init_soc(ddata);
+	error = sysc_init_static_data(ddata);
 	if (error)
 		return error;
 
@@ -3200,6 +3293,9 @@ static int sysc_probe(struct platform_device *pdev)
 		pm_runtime_put(&pdev->dev);
 	}
 
+	if (ddata->cfg.quirks & SYSC_QUIRK_REINIT_ON_CTX_LOST)
+		sysc_add_restored(ddata);
+
 	return 0;
 
 err:
@@ -3281,7 +3377,7 @@ static void __exit sysc_exit(void)
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



