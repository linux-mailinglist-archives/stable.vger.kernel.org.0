Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1E7247D563
	for <lists+stable@lfdr.de>; Wed, 22 Dec 2021 17:48:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233710AbhLVQsn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Dec 2021 11:48:43 -0500
Received: from mga09.intel.com ([134.134.136.24]:14136 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230008AbhLVQsn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Dec 2021 11:48:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640191723; x=1671727723;
  h=from:to:cc:subject:date:message-id;
  bh=sBH0mJvV8ASyw6f8QYQiDZ+ABUL46mfxPyYtRfsyFlM=;
  b=gk4xQzQ9MIDmiqalTn1syycNQOYxy3jXzpnBORIq/18IlF/fgY3is2rK
   GuZRkwMUzUM/NOXTre9x4s5DY5zo/kXTUQorxtdoJERGHkQfy5SiAJGCD
   96PxUK9PYOv9MOD6olOoV0z8iT4G4IZ49T+zvd90z5I5OLYYp6yO84RoP
   iOYrJgyLSYyYELpOvbkzIGzB9FCogIJnKjFq/mxXRANE/ltflJ7tc9Uqg
   lFMY+5XjOYHUo1bnlE8vni6aHXqyZjDcClJCxtS+qZj7u20f0eVrXhIE/
   DhxqmYCCapgBiBxG/K5vCYykL0XV7MF4Gv6CWLzHtixLrZ/MjqDuhNGaK
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10206"; a="240464143"
X-IronPort-AV: E=Sophos;i="5.88,227,1635231600"; 
   d="scan'208";a="240464143"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2021 08:48:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,227,1635231600"; 
   d="scan'208";a="484812830"
Received: from srpawnik.iind.intel.com ([10.223.107.57])
  by orsmga002.jf.intel.com with ESMTP; 22 Dec 2021 08:48:41 -0800
From:   Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>
To:     sumeet.r.pawnikar@intel.com
Cc:     stable@vger.kernel.org
Subject: [PATCH] thermal/drivers/int340x: add functions for mbox read and write commands
Date:   Wed, 22 Dec 2021 22:18:03 +0530
Message-Id: <20211222164803.6379-1-sumeet.r.pawnikar@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The existing mail mechanism only supports writing of workload types.
But mailbox command for RFIM (cmd = 0x08) also requires write operation
which was ignored. This results in failing to store RFI restriction.
This requires enhancing mailbox writes for non workload commands also.
So, remove the check for MBOX_CMD_WORKLOAD_TYPE_WRITE in mailbox write,
with this other write commands also can be supoorted. But at the same
time, we have to make sure that there is no impact on read commands,
by not writing anything in mailbox data register.
To properly implement, add two separate functions for mbox read and write
command for processor thermal workload command type. This helps to
differentiate the read and write workload command types while sending mbox
command.

Fixes: 5d6fbc96bd36 ("thermal/drivers/int340x: processor_thermal: Export additional attributes")
Signed-off-by: Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>
Cc: stable@vger.kernel.org # 5.14+
---
 .../processor_thermal_device.h                |   3 +-
 .../int340x_thermal/processor_thermal_mbox.c  | 101 +++++++++++-------
 .../int340x_thermal/processor_thermal_rfim.c  |  23 ++--
 3 files changed, 74 insertions(+), 53 deletions(-)

diff --git a/drivers/thermal/intel/int340x_thermal/processor_thermal_device.h b/drivers/thermal/intel/int340x_thermal/processor_thermal_device.h
index be27f633e40a..43def8c5d2ce 100644
--- a/drivers/thermal/intel/int340x_thermal/processor_thermal_device.h
+++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_device.h
@@ -80,7 +80,8 @@ void proc_thermal_rfim_remove(struct pci_dev *pdev);
 int proc_thermal_mbox_add(struct pci_dev *pdev, struct proc_thermal_device *proc_priv);
 void proc_thermal_mbox_remove(struct pci_dev *pdev);
 
-int processor_thermal_send_mbox_cmd(struct pci_dev *pdev, u16 cmd_id, u32 cmd_data, u64 *cmd_resp);
+int processor_thermal_send_mbox_read_cmd(struct pci_dev *pdev, u16 id, u32 data, u64 *resp);
+int processor_thermal_send_mbox_write_cmd(struct pci_dev *pdev, u16 id, u32 data);
 int proc_thermal_add(struct device *dev, struct proc_thermal_device *priv);
 void proc_thermal_remove(struct proc_thermal_device *proc_priv);
 int proc_thermal_suspend(struct device *dev);
diff --git a/drivers/thermal/intel/int340x_thermal/processor_thermal_mbox.c b/drivers/thermal/intel/int340x_thermal/processor_thermal_mbox.c
index 01008ae00e7f..26bae0434829 100644
--- a/drivers/thermal/intel/int340x_thermal/processor_thermal_mbox.c
+++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_mbox.c
@@ -24,19 +24,15 @@
 
 static DEFINE_MUTEX(mbox_lock);
 
-static int send_mbox_cmd(struct pci_dev *pdev, u16 cmd_id, u32 cmd_data, u64 *cmd_resp)
+static int wait_for_mbox_ready(struct proc_thermal_device *proc_priv)
 {
-	struct proc_thermal_device *proc_priv;
 	u32 retries, data;
 	int ret;
 
-	mutex_lock(&mbox_lock);
-	proc_priv = pci_get_drvdata(pdev);
-
 	/* Poll for rb bit == 0 */
 	retries = MBOX_RETRY_COUNT;
 	do {
-		data = readl((void __iomem *) (proc_priv->mmio_base + MBOX_OFFSET_INTERFACE));
+		data = readl(proc_priv->mmio_base + MBOX_OFFSET_INTERFACE);
 		if (data & BIT_ULL(MBOX_BUSY_BIT)) {
 			ret = -EBUSY;
 			continue;
@@ -45,53 +41,79 @@ static int send_mbox_cmd(struct pci_dev *pdev, u16 cmd_id, u32 cmd_data, u64 *cm
 		break;
 	} while (--retries);
 
+	return ret;
+}
+
+static int send_mbox_write_cmd(struct pci_dev *pdev, u16 id, u32 data)
+{
+	struct proc_thermal_device *proc_priv;
+	u32 reg_data;
+	int ret;
+
+	proc_priv = pci_get_drvdata(pdev);
+
+	mutex_lock(&mbox_lock);
+
+	ret = wait_for_mbox_ready(proc_priv);
 	if (ret)
 		goto unlock_mbox;
 
-	if (cmd_id == MBOX_CMD_WORKLOAD_TYPE_WRITE)
-		writel(cmd_data, (void __iomem *) ((proc_priv->mmio_base + MBOX_OFFSET_DATA)));
-
+	writel(data, (proc_priv->mmio_base + MBOX_OFFSET_DATA));
 	/* Write command register */
-	data = BIT_ULL(MBOX_BUSY_BIT) | cmd_id;
-	writel(data, (void __iomem *) ((proc_priv->mmio_base + MBOX_OFFSET_INTERFACE)));
+	reg_data = BIT_ULL(MBOX_BUSY_BIT) | id;
+	writel(reg_data, (proc_priv->mmio_base + MBOX_OFFSET_INTERFACE));
 
-	/* Poll for rb bit == 0 */
-	retries = MBOX_RETRY_COUNT;
-	do {
-		data = readl((void __iomem *) (proc_priv->mmio_base + MBOX_OFFSET_INTERFACE));
-		if (data & BIT_ULL(MBOX_BUSY_BIT)) {
-			ret = -EBUSY;
-			continue;
-		}
+	ret = wait_for_mbox_ready(proc_priv);
 
-		if (data) {
-			ret = -ENXIO;
-			goto unlock_mbox;
-		}
+unlock_mbox:
+	mutex_unlock(&mbox_lock);
+	return ret;
+}
 
-		ret = 0;
+static int send_mbox_read_cmd(struct pci_dev *pdev, u16 id, u32 data, u64 *resp)
+{
+	struct proc_thermal_device *proc_priv;
+	u32 reg_data;
+	int ret;
 
-		if (!cmd_resp)
-			break;
+	proc_priv = pci_get_drvdata(pdev);
 
-		if (cmd_id == MBOX_CMD_WORKLOAD_TYPE_READ)
-			*cmd_resp = readl((void __iomem *) (proc_priv->mmio_base + MBOX_OFFSET_DATA));
-		else
-			*cmd_resp = readq((void __iomem *) (proc_priv->mmio_base + MBOX_OFFSET_DATA));
+	mutex_lock(&mbox_lock);
 
-		break;
-	} while (--retries);
+	ret = wait_for_mbox_ready(proc_priv);
+	if (ret)
+		goto unlock_mbox;
+
+	writel(data, (proc_priv->mmio_base + MBOX_OFFSET_DATA));
+	/* Write command register */
+	reg_data = BIT_ULL(MBOX_BUSY_BIT) | id;
+	writel(reg_data, (proc_priv->mmio_base + MBOX_OFFSET_INTERFACE));
+
+	ret = wait_for_mbox_ready(proc_priv);
+	if (ret)
+		goto unlock_mbox;
+
+	if (id == MBOX_CMD_WORKLOAD_TYPE_READ)
+		*resp = readl(proc_priv->mmio_base + MBOX_OFFSET_DATA);
+	else
+		*resp = readq(proc_priv->mmio_base + MBOX_OFFSET_DATA);
 
 unlock_mbox:
 	mutex_unlock(&mbox_lock);
 	return ret;
 }
 
-int processor_thermal_send_mbox_cmd(struct pci_dev *pdev, u16 cmd_id, u32 cmd_data, u64 *cmd_resp)
+int processor_thermal_send_mbox_read_cmd(struct pci_dev *pdev, u16 id, u32 data, u64 *resp)
 {
-	return send_mbox_cmd(pdev, cmd_id, cmd_data, cmd_resp);
+	return send_mbox_read_cmd(pdev, id, data, resp);
 }
-EXPORT_SYMBOL_GPL(processor_thermal_send_mbox_cmd);
+EXPORT_SYMBOL_NS_GPL(processor_thermal_send_mbox_read_cmd, INT340X_THERMAL);
+
+int processor_thermal_send_mbox_write_cmd(struct pci_dev *pdev, u16 id, u32 data)
+{
+	return send_mbox_write_cmd(pdev, id, data);
+}
+EXPORT_SYMBOL_NS_GPL(processor_thermal_send_mbox_write_cmd, INT340X_THERMAL);
 
 /* List of workload types */
 static const char * const workload_types[] = {
@@ -104,7 +126,6 @@ static const char * const workload_types[] = {
 	NULL
 };
 
-
 static ssize_t workload_available_types_show(struct device *dev,
 					       struct device_attribute *attr,
 					       char *buf)
@@ -146,7 +167,7 @@ static ssize_t workload_type_store(struct device *dev,
 
 	data |= ret;
 
-	ret = send_mbox_cmd(pdev, MBOX_CMD_WORKLOAD_TYPE_WRITE, data, NULL);
+	ret = send_mbox_write_cmd(pdev, MBOX_CMD_WORKLOAD_TYPE_WRITE, data);
 	if (ret)
 		return false;
 
@@ -161,7 +182,7 @@ static ssize_t workload_type_show(struct device *dev,
 	u64 cmd_resp;
 	int ret;
 
-	ret = send_mbox_cmd(pdev, MBOX_CMD_WORKLOAD_TYPE_READ, 0, &cmd_resp);
+	ret = send_mbox_read_cmd(pdev, MBOX_CMD_WORKLOAD_TYPE_READ, 0, &cmd_resp);
 	if (ret)
 		return false;
 
@@ -186,8 +207,6 @@ static const struct attribute_group workload_req_attribute_group = {
 	.name = "workload_request"
 };
 
-
-
 static bool workload_req_created;
 
 int proc_thermal_mbox_add(struct pci_dev *pdev, struct proc_thermal_device *proc_priv)
@@ -196,7 +215,7 @@ int proc_thermal_mbox_add(struct pci_dev *pdev, struct proc_thermal_device *proc
 	int ret;
 
 	/* Check if there is a mailbox support, if fails return success */
-	ret = send_mbox_cmd(pdev, MBOX_CMD_WORKLOAD_TYPE_READ, 0, &cmd_resp);
+	ret = send_mbox_read_cmd(pdev, MBOX_CMD_WORKLOAD_TYPE_READ, 0, &cmd_resp);
 	if (ret)
 		return 0;
 
diff --git a/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c b/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c
index e693ec8234fb..bebc7aaf3433 100644
--- a/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c
+++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c
@@ -9,6 +9,8 @@
 #include <linux/pci.h>
 #include "processor_thermal_device.h"
 
+MODULE_IMPORT_NS(INT340X_THERMAL);
+
 struct mmio_reg {
 	int read_only;
 	u32 offset;
@@ -194,8 +196,7 @@ static ssize_t rfi_restriction_store(struct device *dev,
 				     struct device_attribute *attr,
 				     const char *buf, size_t count)
 {
-	u16 cmd_id = 0x0008;
-	u64 cmd_resp;
+	u16 id = 0x0008;
 	u32 input;
 	int ret;
 
@@ -203,7 +204,7 @@ static ssize_t rfi_restriction_store(struct device *dev,
 	if (ret)
 		return ret;
 
-	ret = processor_thermal_send_mbox_cmd(to_pci_dev(dev), cmd_id, input, &cmd_resp);
+	ret = processor_thermal_send_mbox_write_cmd(to_pci_dev(dev), id, input);
 	if (ret)
 		return ret;
 
@@ -214,30 +215,30 @@ static ssize_t rfi_restriction_show(struct device *dev,
 				    struct device_attribute *attr,
 				    char *buf)
 {
-	u16 cmd_id = 0x0007;
-	u64 cmd_resp;
+	u16 id = 0x0007;
+	u64 resp;
 	int ret;
 
-	ret = processor_thermal_send_mbox_cmd(to_pci_dev(dev), cmd_id, 0, &cmd_resp);
+	ret = processor_thermal_send_mbox_read_cmd(to_pci_dev(dev), id, 0, &resp);
 	if (ret)
 		return ret;
 
-	return sprintf(buf, "%llu\n", cmd_resp);
+	return sprintf(buf, "%llu\n", resp);
 }
 
 static ssize_t ddr_data_rate_show(struct device *dev,
 				  struct device_attribute *attr,
 				  char *buf)
 {
-	u16 cmd_id = 0x0107;
-	u64 cmd_resp;
+	u16 id = 0x0107;
+	u64 resp;
 	int ret;
 
-	ret = processor_thermal_send_mbox_cmd(to_pci_dev(dev), cmd_id, 0, &cmd_resp);
+	ret = processor_thermal_send_mbox_read_cmd(to_pci_dev(dev), id, 0, &resp);
 	if (ret)
 		return ret;
 
-	return sprintf(buf, "%llu\n", cmd_resp);
+	return sprintf(buf, "%llu\n", resp);
 }
 
 static DEVICE_ATTR_RW(rfi_restriction);
-- 
2.17.1

