Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFC976DEDEE
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbjDLIiM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:38:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbjDLIh5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:37:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEBC2768F
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:36:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 14A6062F9F
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:35:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9FD8C433D2;
        Wed, 12 Apr 2023 08:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681288519;
        bh=o9hwL+0GgzPIuVTpRxl5tM4vHUNfdmReHPz40HzZaGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yf+sW0Hfof/U7/xJpxljFoRuLCzjFQJeJk8W3ioVHlWLFZu/SnWTTKVaJWvURe6U5
         swrxpAD/HU9GOB4/E5v2HI5hhxaHCJe+w8tBt6BuRC6kgdb/aAkkDZdOztSl5Ac5f1
         oWciLrZ8RMxtQQW8R94X3dEVapyBX2MBDBc0wOTw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Greentime Hu <greentime.hu@sifive.com>,
        Zong Li <zong.li@sifive.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 01/93] soc: sifive: ccache: Rename SiFive L2 cache to Composable cache.
Date:   Wed, 12 Apr 2023 10:33:02 +0200
Message-Id: <20230412082823.103777810@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082823.045155996@linuxfoundation.org>
References: <20230412082823.045155996@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greentime Hu <greentime.hu@sifive.com>

[ Upstream commit ca120a79cf5a3323172c82e77efd70ae10d120ef ]

Since composable cache may be L3 cache if there is a L2 cache, we should
use its original name composable cache to prevent confusion.

There are some new lines were generated due to adding the compatible
"sifive,ccache0" into ID table and indent requirement.

The sifive L2 has been renamed to sifive CCACHE, EDAC driver needs to
apply the change as well.

Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
Signed-off-by: Zong Li <zong.li@sifive.com>
Co-developed-by: Zong Li <zong.li@sifive.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/r/20220913061817.22564-3-zong.li@sifive.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Stable-dep-of: 73e770f08502 ("soc: sifive: ccache: fix missing iounmap() in error path in sifive_ccache_init()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/Kconfig                 |   2 +-
 drivers/edac/sifive_edac.c           |  12 +-
 drivers/soc/sifive/Kconfig           |   6 +-
 drivers/soc/sifive/Makefile          |   2 +-
 drivers/soc/sifive/sifive_ccache.c   | 245 +++++++++++++++++++++++++++
 drivers/soc/sifive/sifive_l2_cache.c | 237 --------------------------
 include/soc/sifive/sifive_ccache.h   |  16 ++
 include/soc/sifive/sifive_l2_cache.h |  16 --
 8 files changed, 272 insertions(+), 264 deletions(-)
 create mode 100644 drivers/soc/sifive/sifive_ccache.c
 delete mode 100644 drivers/soc/sifive/sifive_l2_cache.c
 create mode 100644 include/soc/sifive/sifive_ccache.h
 delete mode 100644 include/soc/sifive/sifive_l2_cache.h

diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
index 2fc4c3f91fd54..0e1ed09ec5b72 100644
--- a/drivers/edac/Kconfig
+++ b/drivers/edac/Kconfig
@@ -471,7 +471,7 @@ config EDAC_ALTERA_SDMMC
 
 config EDAC_SIFIVE
 	bool "Sifive platform EDAC driver"
-	depends on EDAC=y && SIFIVE_L2
+	depends on EDAC=y && SIFIVE_CCACHE
 	help
 	  Support for error detection and correction on the SiFive SoCs.
 
diff --git a/drivers/edac/sifive_edac.c b/drivers/edac/sifive_edac.c
index 3a3dcb14ed99d..a759a56ad34de 100644
--- a/drivers/edac/sifive_edac.c
+++ b/drivers/edac/sifive_edac.c
@@ -2,7 +2,7 @@
 /*
  * SiFive Platform EDAC Driver
  *
- * Copyright (C) 2018-2019 SiFive, Inc.
+ * Copyright (C) 2018-2022 SiFive, Inc.
  *
  * This driver is partially based on octeon_edac-pc.c
  *
@@ -10,7 +10,7 @@
 #include <linux/edac.h>
 #include <linux/platform_device.h>
 #include "edac_module.h"
-#include <soc/sifive/sifive_l2_cache.h>
+#include <soc/sifive/sifive_ccache.h>
 
 #define DRVNAME "sifive_edac"
 
@@ -32,9 +32,9 @@ int ecc_err_event(struct notifier_block *this, unsigned long event, void *ptr)
 
 	p = container_of(this, struct sifive_edac_priv, notifier);
 
-	if (event == SIFIVE_L2_ERR_TYPE_UE)
+	if (event == SIFIVE_CCACHE_ERR_TYPE_UE)
 		edac_device_handle_ue(p->dci, 0, 0, msg);
-	else if (event == SIFIVE_L2_ERR_TYPE_CE)
+	else if (event == SIFIVE_CCACHE_ERR_TYPE_CE)
 		edac_device_handle_ce(p->dci, 0, 0, msg);
 
 	return NOTIFY_OK;
@@ -67,7 +67,7 @@ static int ecc_register(struct platform_device *pdev)
 		goto err;
 	}
 
-	register_sifive_l2_error_notifier(&p->notifier);
+	register_sifive_ccache_error_notifier(&p->notifier);
 
 	return 0;
 
@@ -81,7 +81,7 @@ static int ecc_unregister(struct platform_device *pdev)
 {
 	struct sifive_edac_priv *p = platform_get_drvdata(pdev);
 
-	unregister_sifive_l2_error_notifier(&p->notifier);
+	unregister_sifive_ccache_error_notifier(&p->notifier);
 	edac_device_del_device(&pdev->dev);
 	edac_device_free_ctl_info(p->dci);
 
diff --git a/drivers/soc/sifive/Kconfig b/drivers/soc/sifive/Kconfig
index 58cf8c40d08d5..ed4c571f8771b 100644
--- a/drivers/soc/sifive/Kconfig
+++ b/drivers/soc/sifive/Kconfig
@@ -2,9 +2,9 @@
 
 if SOC_SIFIVE
 
-config SIFIVE_L2
-	bool "Sifive L2 Cache controller"
+config SIFIVE_CCACHE
+	bool "Sifive Composable Cache controller"
 	help
-	  Support for the L2 cache controller on SiFive platforms.
+	  Support for the composable cache controller on SiFive platforms.
 
 endif
diff --git a/drivers/soc/sifive/Makefile b/drivers/soc/sifive/Makefile
index b5caff77938f6..1f5dc339bf827 100644
--- a/drivers/soc/sifive/Makefile
+++ b/drivers/soc/sifive/Makefile
@@ -1,3 +1,3 @@
 # SPDX-License-Identifier: GPL-2.0
 
-obj-$(CONFIG_SIFIVE_L2)	+= sifive_l2_cache.o
+obj-$(CONFIG_SIFIVE_CCACHE)	+= sifive_ccache.o
diff --git a/drivers/soc/sifive/sifive_ccache.c b/drivers/soc/sifive/sifive_ccache.c
new file mode 100644
index 0000000000000..949b824e89adf
--- /dev/null
+++ b/drivers/soc/sifive/sifive_ccache.c
@@ -0,0 +1,245 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * SiFive composable cache controller Driver
+ *
+ * Copyright (C) 2018-2022 SiFive, Inc.
+ *
+ */
+#include <linux/debugfs.h>
+#include <linux/interrupt.h>
+#include <linux/of_irq.h>
+#include <linux/of_address.h>
+#include <linux/device.h>
+#include <asm/cacheinfo.h>
+#include <soc/sifive/sifive_ccache.h>
+
+#define SIFIVE_CCACHE_DIRECCFIX_LOW 0x100
+#define SIFIVE_CCACHE_DIRECCFIX_HIGH 0x104
+#define SIFIVE_CCACHE_DIRECCFIX_COUNT 0x108
+
+#define SIFIVE_CCACHE_DIRECCFAIL_LOW 0x120
+#define SIFIVE_CCACHE_DIRECCFAIL_HIGH 0x124
+#define SIFIVE_CCACHE_DIRECCFAIL_COUNT 0x128
+
+#define SIFIVE_CCACHE_DATECCFIX_LOW 0x140
+#define SIFIVE_CCACHE_DATECCFIX_HIGH 0x144
+#define SIFIVE_CCACHE_DATECCFIX_COUNT 0x148
+
+#define SIFIVE_CCACHE_DATECCFAIL_LOW 0x160
+#define SIFIVE_CCACHE_DATECCFAIL_HIGH 0x164
+#define SIFIVE_CCACHE_DATECCFAIL_COUNT 0x168
+
+#define SIFIVE_CCACHE_CONFIG 0x00
+#define SIFIVE_CCACHE_WAYENABLE 0x08
+#define SIFIVE_CCACHE_ECCINJECTERR 0x40
+
+#define SIFIVE_CCACHE_MAX_ECCINTR 4
+
+static void __iomem *ccache_base;
+static int g_irq[SIFIVE_CCACHE_MAX_ECCINTR];
+static struct riscv_cacheinfo_ops ccache_cache_ops;
+
+enum {
+	DIR_CORR = 0,
+	DATA_CORR,
+	DATA_UNCORR,
+	DIR_UNCORR,
+};
+
+#ifdef CONFIG_DEBUG_FS
+static struct dentry *sifive_test;
+
+static ssize_t ccache_write(struct file *file, const char __user *data,
+			    size_t count, loff_t *ppos)
+{
+	unsigned int val;
+
+	if (kstrtouint_from_user(data, count, 0, &val))
+		return -EINVAL;
+	if ((val < 0xFF) || (val >= 0x10000 && val < 0x100FF))
+		writel(val, ccache_base + SIFIVE_CCACHE_ECCINJECTERR);
+	else
+		return -EINVAL;
+	return count;
+}
+
+static const struct file_operations ccache_fops = {
+	.owner = THIS_MODULE,
+	.open = simple_open,
+	.write = ccache_write
+};
+
+static void setup_sifive_debug(void)
+{
+	sifive_test = debugfs_create_dir("sifive_ccache_cache", NULL);
+
+	debugfs_create_file("sifive_debug_inject_error", 0200,
+			    sifive_test, NULL, &ccache_fops);
+}
+#endif
+
+static void ccache_config_read(void)
+{
+	u32 regval, val;
+
+	regval = readl(ccache_base + SIFIVE_CCACHE_CONFIG);
+	val = regval & 0xFF;
+	pr_info("CCACHE: No. of Banks in the cache: %d\n", val);
+	val = (regval & 0xFF00) >> 8;
+	pr_info("CCACHE: No. of ways per bank: %d\n", val);
+	val = (regval & 0xFF0000) >> 16;
+	pr_info("CCACHE: Sets per bank: %llu\n", (uint64_t)1 << val);
+	val = (regval & 0xFF000000) >> 24;
+	pr_info("CCACHE: Bytes per cache block: %llu\n", (uint64_t)1 << val);
+
+	regval = readl(ccache_base + SIFIVE_CCACHE_WAYENABLE);
+	pr_info("CCACHE: Index of the largest way enabled: %d\n", regval);
+}
+
+static const struct of_device_id sifive_ccache_ids[] = {
+	{ .compatible = "sifive,fu540-c000-ccache" },
+	{ .compatible = "sifive,fu740-c000-ccache" },
+	{ .compatible = "sifive,ccache0" },
+	{ /* end of table */ }
+};
+
+static ATOMIC_NOTIFIER_HEAD(ccache_err_chain);
+
+int register_sifive_ccache_error_notifier(struct notifier_block *nb)
+{
+	return atomic_notifier_chain_register(&ccache_err_chain, nb);
+}
+EXPORT_SYMBOL_GPL(register_sifive_ccache_error_notifier);
+
+int unregister_sifive_ccache_error_notifier(struct notifier_block *nb)
+{
+	return atomic_notifier_chain_unregister(&ccache_err_chain, nb);
+}
+EXPORT_SYMBOL_GPL(unregister_sifive_ccache_error_notifier);
+
+static int ccache_largest_wayenabled(void)
+{
+	return readl(ccache_base + SIFIVE_CCACHE_WAYENABLE) & 0xFF;
+}
+
+static ssize_t number_of_ways_enabled_show(struct device *dev,
+					   struct device_attribute *attr,
+					   char *buf)
+{
+	return sprintf(buf, "%u\n", ccache_largest_wayenabled());
+}
+
+static DEVICE_ATTR_RO(number_of_ways_enabled);
+
+static struct attribute *priv_attrs[] = {
+	&dev_attr_number_of_ways_enabled.attr,
+	NULL,
+};
+
+static const struct attribute_group priv_attr_group = {
+	.attrs = priv_attrs,
+};
+
+static const struct attribute_group *ccache_get_priv_group(struct cacheinfo
+							   *this_leaf)
+{
+	/* We want to use private group for composable cache only */
+	if (this_leaf->level == 2)
+		return &priv_attr_group;
+	else
+		return NULL;
+}
+
+static irqreturn_t ccache_int_handler(int irq, void *device)
+{
+	unsigned int add_h, add_l;
+
+	if (irq == g_irq[DIR_CORR]) {
+		add_h = readl(ccache_base + SIFIVE_CCACHE_DIRECCFIX_HIGH);
+		add_l = readl(ccache_base + SIFIVE_CCACHE_DIRECCFIX_LOW);
+		pr_err("CCACHE: DirError @ 0x%08X.%08X\n", add_h, add_l);
+		/* Reading this register clears the DirError interrupt sig */
+		readl(ccache_base + SIFIVE_CCACHE_DIRECCFIX_COUNT);
+		atomic_notifier_call_chain(&ccache_err_chain,
+					   SIFIVE_CCACHE_ERR_TYPE_CE,
+					   "DirECCFix");
+	}
+	if (irq == g_irq[DIR_UNCORR]) {
+		add_h = readl(ccache_base + SIFIVE_CCACHE_DIRECCFAIL_HIGH);
+		add_l = readl(ccache_base + SIFIVE_CCACHE_DIRECCFAIL_LOW);
+		/* Reading this register clears the DirFail interrupt sig */
+		readl(ccache_base + SIFIVE_CCACHE_DIRECCFAIL_COUNT);
+		atomic_notifier_call_chain(&ccache_err_chain,
+					   SIFIVE_CCACHE_ERR_TYPE_UE,
+					   "DirECCFail");
+		panic("CCACHE: DirFail @ 0x%08X.%08X\n", add_h, add_l);
+	}
+	if (irq == g_irq[DATA_CORR]) {
+		add_h = readl(ccache_base + SIFIVE_CCACHE_DATECCFIX_HIGH);
+		add_l = readl(ccache_base + SIFIVE_CCACHE_DATECCFIX_LOW);
+		pr_err("CCACHE: DataError @ 0x%08X.%08X\n", add_h, add_l);
+		/* Reading this register clears the DataError interrupt sig */
+		readl(ccache_base + SIFIVE_CCACHE_DATECCFIX_COUNT);
+		atomic_notifier_call_chain(&ccache_err_chain,
+					   SIFIVE_CCACHE_ERR_TYPE_CE,
+					   "DatECCFix");
+	}
+	if (irq == g_irq[DATA_UNCORR]) {
+		add_h = readl(ccache_base + SIFIVE_CCACHE_DATECCFAIL_HIGH);
+		add_l = readl(ccache_base + SIFIVE_CCACHE_DATECCFAIL_LOW);
+		pr_err("CCACHE: DataFail @ 0x%08X.%08X\n", add_h, add_l);
+		/* Reading this register clears the DataFail interrupt sig */
+		readl(ccache_base + SIFIVE_CCACHE_DATECCFAIL_COUNT);
+		atomic_notifier_call_chain(&ccache_err_chain,
+					   SIFIVE_CCACHE_ERR_TYPE_UE,
+					   "DatECCFail");
+	}
+
+	return IRQ_HANDLED;
+}
+
+static int __init sifive_ccache_init(void)
+{
+	struct device_node *np;
+	struct resource res;
+	int i, rc, intr_num;
+
+	np = of_find_matching_node(NULL, sifive_ccache_ids);
+	if (!np)
+		return -ENODEV;
+
+	if (of_address_to_resource(np, 0, &res))
+		return -ENODEV;
+
+	ccache_base = ioremap(res.start, resource_size(&res));
+	if (!ccache_base)
+		return -ENOMEM;
+
+	intr_num = of_property_count_u32_elems(np, "interrupts");
+	if (!intr_num) {
+		pr_err("CCACHE: no interrupts property\n");
+		return -ENODEV;
+	}
+
+	for (i = 0; i < intr_num; i++) {
+		g_irq[i] = irq_of_parse_and_map(np, i);
+		rc = request_irq(g_irq[i], ccache_int_handler, 0, "ccache_ecc",
+				 NULL);
+		if (rc) {
+			pr_err("CCACHE: Could not request IRQ %d\n", g_irq[i]);
+			return rc;
+		}
+	}
+
+	ccache_config_read();
+
+	ccache_cache_ops.get_priv_group = ccache_get_priv_group;
+	riscv_set_cacheinfo_ops(&ccache_cache_ops);
+
+#ifdef CONFIG_DEBUG_FS
+	setup_sifive_debug();
+#endif
+	return 0;
+}
+
+device_initcall(sifive_ccache_init);
diff --git a/drivers/soc/sifive/sifive_l2_cache.c b/drivers/soc/sifive/sifive_l2_cache.c
deleted file mode 100644
index 59640a1d0b28a..0000000000000
--- a/drivers/soc/sifive/sifive_l2_cache.c
+++ /dev/null
@@ -1,237 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * SiFive L2 cache controller Driver
- *
- * Copyright (C) 2018-2019 SiFive, Inc.
- *
- */
-#include <linux/debugfs.h>
-#include <linux/interrupt.h>
-#include <linux/of_irq.h>
-#include <linux/of_address.h>
-#include <linux/device.h>
-#include <asm/cacheinfo.h>
-#include <soc/sifive/sifive_l2_cache.h>
-
-#define SIFIVE_L2_DIRECCFIX_LOW 0x100
-#define SIFIVE_L2_DIRECCFIX_HIGH 0x104
-#define SIFIVE_L2_DIRECCFIX_COUNT 0x108
-
-#define SIFIVE_L2_DIRECCFAIL_LOW 0x120
-#define SIFIVE_L2_DIRECCFAIL_HIGH 0x124
-#define SIFIVE_L2_DIRECCFAIL_COUNT 0x128
-
-#define SIFIVE_L2_DATECCFIX_LOW 0x140
-#define SIFIVE_L2_DATECCFIX_HIGH 0x144
-#define SIFIVE_L2_DATECCFIX_COUNT 0x148
-
-#define SIFIVE_L2_DATECCFAIL_LOW 0x160
-#define SIFIVE_L2_DATECCFAIL_HIGH 0x164
-#define SIFIVE_L2_DATECCFAIL_COUNT 0x168
-
-#define SIFIVE_L2_CONFIG 0x00
-#define SIFIVE_L2_WAYENABLE 0x08
-#define SIFIVE_L2_ECCINJECTERR 0x40
-
-#define SIFIVE_L2_MAX_ECCINTR 4
-
-static void __iomem *l2_base;
-static int g_irq[SIFIVE_L2_MAX_ECCINTR];
-static struct riscv_cacheinfo_ops l2_cache_ops;
-
-enum {
-	DIR_CORR = 0,
-	DATA_CORR,
-	DATA_UNCORR,
-	DIR_UNCORR,
-};
-
-#ifdef CONFIG_DEBUG_FS
-static struct dentry *sifive_test;
-
-static ssize_t l2_write(struct file *file, const char __user *data,
-			size_t count, loff_t *ppos)
-{
-	unsigned int val;
-
-	if (kstrtouint_from_user(data, count, 0, &val))
-		return -EINVAL;
-	if ((val < 0xFF) || (val >= 0x10000 && val < 0x100FF))
-		writel(val, l2_base + SIFIVE_L2_ECCINJECTERR);
-	else
-		return -EINVAL;
-	return count;
-}
-
-static const struct file_operations l2_fops = {
-	.owner = THIS_MODULE,
-	.open = simple_open,
-	.write = l2_write
-};
-
-static void setup_sifive_debug(void)
-{
-	sifive_test = debugfs_create_dir("sifive_l2_cache", NULL);
-
-	debugfs_create_file("sifive_debug_inject_error", 0200,
-			    sifive_test, NULL, &l2_fops);
-}
-#endif
-
-static void l2_config_read(void)
-{
-	u32 regval, val;
-
-	regval = readl(l2_base + SIFIVE_L2_CONFIG);
-	val = regval & 0xFF;
-	pr_info("L2CACHE: No. of Banks in the cache: %d\n", val);
-	val = (regval & 0xFF00) >> 8;
-	pr_info("L2CACHE: No. of ways per bank: %d\n", val);
-	val = (regval & 0xFF0000) >> 16;
-	pr_info("L2CACHE: Sets per bank: %llu\n", (uint64_t)1 << val);
-	val = (regval & 0xFF000000) >> 24;
-	pr_info("L2CACHE: Bytes per cache block: %llu\n", (uint64_t)1 << val);
-
-	regval = readl(l2_base + SIFIVE_L2_WAYENABLE);
-	pr_info("L2CACHE: Index of the largest way enabled: %d\n", regval);
-}
-
-static const struct of_device_id sifive_l2_ids[] = {
-	{ .compatible = "sifive,fu540-c000-ccache" },
-	{ .compatible = "sifive,fu740-c000-ccache" },
-	{ /* end of table */ },
-};
-
-static ATOMIC_NOTIFIER_HEAD(l2_err_chain);
-
-int register_sifive_l2_error_notifier(struct notifier_block *nb)
-{
-	return atomic_notifier_chain_register(&l2_err_chain, nb);
-}
-EXPORT_SYMBOL_GPL(register_sifive_l2_error_notifier);
-
-int unregister_sifive_l2_error_notifier(struct notifier_block *nb)
-{
-	return atomic_notifier_chain_unregister(&l2_err_chain, nb);
-}
-EXPORT_SYMBOL_GPL(unregister_sifive_l2_error_notifier);
-
-static int l2_largest_wayenabled(void)
-{
-	return readl(l2_base + SIFIVE_L2_WAYENABLE) & 0xFF;
-}
-
-static ssize_t number_of_ways_enabled_show(struct device *dev,
-					   struct device_attribute *attr,
-					   char *buf)
-{
-	return sprintf(buf, "%u\n", l2_largest_wayenabled());
-}
-
-static DEVICE_ATTR_RO(number_of_ways_enabled);
-
-static struct attribute *priv_attrs[] = {
-	&dev_attr_number_of_ways_enabled.attr,
-	NULL,
-};
-
-static const struct attribute_group priv_attr_group = {
-	.attrs = priv_attrs,
-};
-
-static const struct attribute_group *l2_get_priv_group(struct cacheinfo *this_leaf)
-{
-	/* We want to use private group for L2 cache only */
-	if (this_leaf->level == 2)
-		return &priv_attr_group;
-	else
-		return NULL;
-}
-
-static irqreturn_t l2_int_handler(int irq, void *device)
-{
-	unsigned int add_h, add_l;
-
-	if (irq == g_irq[DIR_CORR]) {
-		add_h = readl(l2_base + SIFIVE_L2_DIRECCFIX_HIGH);
-		add_l = readl(l2_base + SIFIVE_L2_DIRECCFIX_LOW);
-		pr_err("L2CACHE: DirError @ 0x%08X.%08X\n", add_h, add_l);
-		/* Reading this register clears the DirError interrupt sig */
-		readl(l2_base + SIFIVE_L2_DIRECCFIX_COUNT);
-		atomic_notifier_call_chain(&l2_err_chain, SIFIVE_L2_ERR_TYPE_CE,
-					   "DirECCFix");
-	}
-	if (irq == g_irq[DIR_UNCORR]) {
-		add_h = readl(l2_base + SIFIVE_L2_DIRECCFAIL_HIGH);
-		add_l = readl(l2_base + SIFIVE_L2_DIRECCFAIL_LOW);
-		/* Reading this register clears the DirFail interrupt sig */
-		readl(l2_base + SIFIVE_L2_DIRECCFAIL_COUNT);
-		atomic_notifier_call_chain(&l2_err_chain, SIFIVE_L2_ERR_TYPE_UE,
-					   "DirECCFail");
-		panic("L2CACHE: DirFail @ 0x%08X.%08X\n", add_h, add_l);
-	}
-	if (irq == g_irq[DATA_CORR]) {
-		add_h = readl(l2_base + SIFIVE_L2_DATECCFIX_HIGH);
-		add_l = readl(l2_base + SIFIVE_L2_DATECCFIX_LOW);
-		pr_err("L2CACHE: DataError @ 0x%08X.%08X\n", add_h, add_l);
-		/* Reading this register clears the DataError interrupt sig */
-		readl(l2_base + SIFIVE_L2_DATECCFIX_COUNT);
-		atomic_notifier_call_chain(&l2_err_chain, SIFIVE_L2_ERR_TYPE_CE,
-					   "DatECCFix");
-	}
-	if (irq == g_irq[DATA_UNCORR]) {
-		add_h = readl(l2_base + SIFIVE_L2_DATECCFAIL_HIGH);
-		add_l = readl(l2_base + SIFIVE_L2_DATECCFAIL_LOW);
-		pr_err("L2CACHE: DataFail @ 0x%08X.%08X\n", add_h, add_l);
-		/* Reading this register clears the DataFail interrupt sig */
-		readl(l2_base + SIFIVE_L2_DATECCFAIL_COUNT);
-		atomic_notifier_call_chain(&l2_err_chain, SIFIVE_L2_ERR_TYPE_UE,
-					   "DatECCFail");
-	}
-
-	return IRQ_HANDLED;
-}
-
-static int __init sifive_l2_init(void)
-{
-	struct device_node *np;
-	struct resource res;
-	int i, rc, intr_num;
-
-	np = of_find_matching_node(NULL, sifive_l2_ids);
-	if (!np)
-		return -ENODEV;
-
-	if (of_address_to_resource(np, 0, &res))
-		return -ENODEV;
-
-	l2_base = ioremap(res.start, resource_size(&res));
-	if (!l2_base)
-		return -ENOMEM;
-
-	intr_num = of_property_count_u32_elems(np, "interrupts");
-	if (!intr_num) {
-		pr_err("L2CACHE: no interrupts property\n");
-		return -ENODEV;
-	}
-
-	for (i = 0; i < intr_num; i++) {
-		g_irq[i] = irq_of_parse_and_map(np, i);
-		rc = request_irq(g_irq[i], l2_int_handler, 0, "l2_ecc", NULL);
-		if (rc) {
-			pr_err("L2CACHE: Could not request IRQ %d\n", g_irq[i]);
-			return rc;
-		}
-	}
-
-	l2_config_read();
-
-	l2_cache_ops.get_priv_group = l2_get_priv_group;
-	riscv_set_cacheinfo_ops(&l2_cache_ops);
-
-#ifdef CONFIG_DEBUG_FS
-	setup_sifive_debug();
-#endif
-	return 0;
-}
-device_initcall(sifive_l2_init);
diff --git a/include/soc/sifive/sifive_ccache.h b/include/soc/sifive/sifive_ccache.h
new file mode 100644
index 0000000000000..4d4ed49388a0a
--- /dev/null
+++ b/include/soc/sifive/sifive_ccache.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * SiFive Composable Cache Controller header file
+ *
+ */
+
+#ifndef __SOC_SIFIVE_CCACHE_H
+#define __SOC_SIFIVE_CCACHE_H
+
+extern int register_sifive_ccache_error_notifier(struct notifier_block *nb);
+extern int unregister_sifive_ccache_error_notifier(struct notifier_block *nb);
+
+#define SIFIVE_CCACHE_ERR_TYPE_CE 0
+#define SIFIVE_CCACHE_ERR_TYPE_UE 1
+
+#endif /* __SOC_SIFIVE_CCACHE_H */
diff --git a/include/soc/sifive/sifive_l2_cache.h b/include/soc/sifive/sifive_l2_cache.h
deleted file mode 100644
index 92ade10ed67e9..0000000000000
--- a/include/soc/sifive/sifive_l2_cache.h
+++ /dev/null
@@ -1,16 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/*
- * SiFive L2 Cache Controller header file
- *
- */
-
-#ifndef __SOC_SIFIVE_L2_CACHE_H
-#define __SOC_SIFIVE_L2_CACHE_H
-
-extern int register_sifive_l2_error_notifier(struct notifier_block *nb);
-extern int unregister_sifive_l2_error_notifier(struct notifier_block *nb);
-
-#define SIFIVE_L2_ERR_TYPE_CE 0
-#define SIFIVE_L2_ERR_TYPE_UE 1
-
-#endif /* __SOC_SIFIVE_L2_CACHE_H */
-- 
2.39.2



