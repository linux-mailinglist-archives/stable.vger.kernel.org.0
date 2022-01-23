Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5503D497214
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 15:26:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236704AbiAWO0A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jan 2022 09:26:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232290AbiAWO0A (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jan 2022 09:26:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8600CC06173B
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 06:26:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2587060C79
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 14:26:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBF65C340E2;
        Sun, 23 Jan 2022 14:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642947959;
        bh=bRwKoyxt6gTriJbPcy9NoSZ8M5uzr7nmFgok8xBMjYE=;
        h=Subject:To:Cc:From:Date:From;
        b=oo47ZIt0Rq8ry3+6TvO89MrW/3ByFUKwAObrMhWcoGtElviP2DmoQ8bFBUe5DVFZO
         djOEw6crfp/dcqaq99fn1ElaVIW3YrZHAH0W/WNapji0eaaMGWEchlfX/vEAmuJFUr
         Y5zzz01i9NH5yDcumLnEOgIRvUix5uitdxrGIOYE=
Subject: FAILED: patch "[PATCH] thermal/drivers/int340x: Fix RFIM mailbox write commands" failed to apply to 5.15-stable tree
To:     sumeet.r.pawnikar@intel.com, rafael.j.wysocki@intel.com,
        srinivas.pandruvada@linux.intel.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Jan 2022 15:25:56 +0100
Message-ID: <1642947956201220@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2685c77b80a80c57e2a25a726b82fb31e6e212ab Mon Sep 17 00:00:00 2001
From: Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>
Date: Thu, 23 Dec 2021 15:12:36 +0530
Subject: [PATCH] thermal/drivers/int340x: Fix RFIM mailbox write commands

The existing mail mechanism only supports writing of workload types.

However, mailbox command for RFIM (cmd = 0x08) also requires write
operation which is ignored. This results in failing to store RFI
restriction.

Fixint this requires enhancing mailbox writes for non workload
commands too, so remove the check for MBOX_CMD_WORKLOAD_TYPE_WRITE
in mailbox write to allow this other write commands to be supoorted.

At the same time, however, we have to make sure that there is no
impact on read commands, by avoiding to write anything into the
mailbox data register.

To properly implement that, add two separate functions for mbox read
and write commands for the processor thermal workload command type.
This helps to distinguish the read and write workload command types
from each other while sending mbox commands.

Fixes: 5d6fbc96bd36 ("thermal/drivers/int340x: processor_thermal: Export additional attributes")
Signed-off-by: Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>
Cc: 5.14+ <stable@vger.kernel.org> # 5.14+
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
[ rjw: Changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

diff --git a/drivers/thermal/intel/int340x_thermal/processor_thermal_device.h b/drivers/thermal/intel/int340x_thermal/processor_thermal_device.h
index be27f633e40a..9b2a64ef55d0 100644
--- a/drivers/thermal/intel/int340x_thermal/processor_thermal_device.h
+++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_device.h
@@ -80,7 +80,8 @@ void proc_thermal_rfim_remove(struct pci_dev *pdev);
 int proc_thermal_mbox_add(struct pci_dev *pdev, struct proc_thermal_device *proc_priv);
 void proc_thermal_mbox_remove(struct pci_dev *pdev);
 
-int processor_thermal_send_mbox_cmd(struct pci_dev *pdev, u16 cmd_id, u32 cmd_data, u64 *cmd_resp);
+int processor_thermal_send_mbox_read_cmd(struct pci_dev *pdev, u16 id, u64 *resp);
+int processor_thermal_send_mbox_write_cmd(struct pci_dev *pdev, u16 id, u32 data);
 int proc_thermal_add(struct device *dev, struct proc_thermal_device *priv);
 void proc_thermal_remove(struct proc_thermal_device *proc_priv);
 int proc_thermal_suspend(struct device *dev);
diff --git a/drivers/thermal/intel/int340x_thermal/processor_thermal_mbox.c b/drivers/thermal/intel/int340x_thermal/processor_thermal_mbox.c
index 01008ae00e7f..0b89a4340ff4 100644
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
@@ -45,53 +41,78 @@ static int send_mbox_cmd(struct pci_dev *pdev, u16 cmd_id, u32 cmd_data, u64 *cm
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
+static int send_mbox_read_cmd(struct pci_dev *pdev, u16 id, u64 *resp)
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
+int processor_thermal_send_mbox_read_cmd(struct pci_dev *pdev, u16 id, u64 *resp)
 {
-	return send_mbox_cmd(pdev, cmd_id, cmd_data, cmd_resp);
+	return send_mbox_read_cmd(pdev, id, resp);
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
@@ -104,7 +125,6 @@ static const char * const workload_types[] = {
 	NULL
 };
 
-
 static ssize_t workload_available_types_show(struct device *dev,
 					       struct device_attribute *attr,
 					       char *buf)
@@ -146,7 +166,7 @@ static ssize_t workload_type_store(struct device *dev,
 
 	data |= ret;
 
-	ret = send_mbox_cmd(pdev, MBOX_CMD_WORKLOAD_TYPE_WRITE, data, NULL);
+	ret = send_mbox_write_cmd(pdev, MBOX_CMD_WORKLOAD_TYPE_WRITE, data);
 	if (ret)
 		return false;
 
@@ -161,7 +181,7 @@ static ssize_t workload_type_show(struct device *dev,
 	u64 cmd_resp;
 	int ret;
 
-	ret = send_mbox_cmd(pdev, MBOX_CMD_WORKLOAD_TYPE_READ, 0, &cmd_resp);
+	ret = send_mbox_read_cmd(pdev, MBOX_CMD_WORKLOAD_TYPE_READ, &cmd_resp);
 	if (ret)
 		return false;
 
@@ -186,8 +206,6 @@ static const struct attribute_group workload_req_attribute_group = {
 	.name = "workload_request"
 };
 
-
-
 static bool workload_req_created;
 
 int proc_thermal_mbox_add(struct pci_dev *pdev, struct proc_thermal_device *proc_priv)
@@ -196,7 +214,7 @@ int proc_thermal_mbox_add(struct pci_dev *pdev, struct proc_thermal_device *proc
 	int ret;
 
 	/* Check if there is a mailbox support, if fails return success */
-	ret = send_mbox_cmd(pdev, MBOX_CMD_WORKLOAD_TYPE_READ, 0, &cmd_resp);
+	ret = send_mbox_read_cmd(pdev, MBOX_CMD_WORKLOAD_TYPE_READ, &cmd_resp);
 	if (ret)
 		return 0;
 
diff --git a/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c b/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c
index e693ec8234fb..8c42e7662033 100644
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
+	ret = processor_thermal_send_mbox_read_cmd(to_pci_dev(dev), id, &resp);
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
+	ret = processor_thermal_send_mbox_read_cmd(to_pci_dev(dev), id, &resp);
 	if (ret)
 		return ret;
 
-	return sprintf(buf, "%llu\n", cmd_resp);
+	return sprintf(buf, "%llu\n", resp);
 }
 
 static DEVICE_ATTR_RW(rfi_restriction);

