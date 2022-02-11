Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 242894B214F
	for <lists+stable@lfdr.de>; Fri, 11 Feb 2022 10:16:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236624AbiBKJPL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Feb 2022 04:15:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233855AbiBKJPL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Feb 2022 04:15:11 -0500
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 557C1102D
        for <stable@vger.kernel.org>; Fri, 11 Feb 2022 01:15:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644570910; x=1676106910;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=kkc4297rLOCg5FWlxGy3JmBn4KHYMQqqbRLhTm2dyIw=;
  b=Q4nMLQ6kQjjMl/kD4b5PDM5ZyZyZsTLVn0c2gXh9GnJf1inG2a6++V64
   cw+Q/f5fpBSS7plYkrSHR7LMr64DKWo9IR1MR822WHWJsxfAU2ocUUqn/
   IC8WfvYHtB2E5lasLO+ij+cGbTxDwiq5i+Vb439R5lA0sHQPhU5UvQR2a
   oeEmN0chybhHzYQUwfQQwPFEz5Pybe+ScAb7RdrzfvXVjl0N0aBSas/yi
   lyCaXyHZ3EhrULAHiImc0U+aCv7FBmZG2y5pECkTzIUut1XIEEkDw2+Vh
   egSkqPxqzYn8LA03QlpeaZ9xOd0NKZd7mRsvOWpdBYxw1RO3jbnVZ6Rzq
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10254"; a="310432786"
X-IronPort-AV: E=Sophos;i="5.88,360,1635231600"; 
   d="scan'208";a="310432786"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2022 01:15:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,360,1635231600"; 
   d="scan'208";a="702037636"
Received: from srpawnik-desktop.iind.intel.com ([10.223.141.132])
  by orsmga005.jf.intel.com with ESMTP; 11 Feb 2022 01:15:08 -0800
From:   Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        rafael.j.wysocki@intel.com, srinivas.pandruvada@linux.intel.com
Cc:     sumeet.r.pawnikar@intel.com
Subject: [PATCH  2/4] thermal/drivers/int340x: processor_thermal: Suppot 64 bit RFIM responses
Date:   Fri, 11 Feb 2022 15:04:35 +0530
Message-Id: <20220211093437.8713-3-sumeet.r.pawnikar@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220211093437.8713-1-sumeet.r.pawnikar@intel.com>
References: <20220211093437.8713-1-sumeet.r.pawnikar@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

Some of the RFIM mail box command returns 64 bit values. So enhance
mailbox interface to return 64 bit values and use them for RFIM
commands.

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Fixes: 5d6fbc96bd36 ("thermal/drivers/int340x: processor_thermal: Export additional attributes")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>
---
 .../processor_thermal_device.h                |  2 +-
 .../int340x_thermal/processor_thermal_mbox.c  | 22 +++++++++++--------
 .../int340x_thermal/processor_thermal_rfim.c  | 10 ++++-----
 3 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/drivers/thermal/intel/int340x_thermal/processor_thermal_device.h b/drivers/thermal/intel/int340x_thermal/processor_thermal_device.h
index c1d8de6dc3d1..be27f633e40a 100644
--- a/drivers/thermal/intel/int340x_thermal/processor_thermal_device.h
+++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_device.h
@@ -80,7 +80,7 @@ void proc_thermal_rfim_remove(struct pci_dev *pdev);
 int proc_thermal_mbox_add(struct pci_dev *pdev, struct proc_thermal_device *proc_priv);
 void proc_thermal_mbox_remove(struct pci_dev *pdev);
 
-int processor_thermal_send_mbox_cmd(struct pci_dev *pdev, u16 cmd_id, u32 cmd_data, u32 *cmd_resp);
+int processor_thermal_send_mbox_cmd(struct pci_dev *pdev, u16 cmd_id, u32 cmd_data, u64 *cmd_resp);
 int proc_thermal_add(struct device *dev, struct proc_thermal_device *priv);
 void proc_thermal_remove(struct proc_thermal_device *proc_priv);
 int proc_thermal_suspend(struct device *dev);
diff --git a/drivers/thermal/intel/int340x_thermal/processor_thermal_mbox.c b/drivers/thermal/intel/int340x_thermal/processor_thermal_mbox.c
index 66cd0190bc03..01008ae00e7f 100644
--- a/drivers/thermal/intel/int340x_thermal/processor_thermal_mbox.c
+++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_mbox.c
@@ -24,7 +24,7 @@
 
 static DEFINE_MUTEX(mbox_lock);
 
-static int send_mbox_cmd(struct pci_dev *pdev, u16 cmd_id, u32 cmd_data, u32 *cmd_resp)
+static int send_mbox_cmd(struct pci_dev *pdev, u16 cmd_id, u32 cmd_data, u64 *cmd_resp)
 {
 	struct proc_thermal_device *proc_priv;
 	u32 retries, data;
@@ -69,12 +69,16 @@ static int send_mbox_cmd(struct pci_dev *pdev, u16 cmd_id, u32 cmd_data, u32 *cm
 			goto unlock_mbox;
 		}
 
-		if (cmd_id == MBOX_CMD_WORKLOAD_TYPE_READ) {
-			data = readl((void __iomem *) (proc_priv->mmio_base + MBOX_OFFSET_DATA));
-			*cmd_resp = data & 0xff;
-		}
-
 		ret = 0;
+
+		if (!cmd_resp)
+			break;
+
+		if (cmd_id == MBOX_CMD_WORKLOAD_TYPE_READ)
+			*cmd_resp = readl((void __iomem *) (proc_priv->mmio_base + MBOX_OFFSET_DATA));
+		else
+			*cmd_resp = readq((void __iomem *) (proc_priv->mmio_base + MBOX_OFFSET_DATA));
+
 		break;
 	} while (--retries);
 
@@ -83,7 +87,7 @@ static int send_mbox_cmd(struct pci_dev *pdev, u16 cmd_id, u32 cmd_data, u32 *cm
 	return ret;
 }
 
-int processor_thermal_send_mbox_cmd(struct pci_dev *pdev, u16 cmd_id, u32 cmd_data, u32 *cmd_resp)
+int processor_thermal_send_mbox_cmd(struct pci_dev *pdev, u16 cmd_id, u32 cmd_data, u64 *cmd_resp)
 {
 	return send_mbox_cmd(pdev, cmd_id, cmd_data, cmd_resp);
 }
@@ -154,7 +158,7 @@ static ssize_t workload_type_show(struct device *dev,
 				   char *buf)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
-	u32 cmd_resp;
+	u64 cmd_resp;
 	int ret;
 
 	ret = send_mbox_cmd(pdev, MBOX_CMD_WORKLOAD_TYPE_READ, 0, &cmd_resp);
@@ -188,7 +192,7 @@ static bool workload_req_created;
 
 int proc_thermal_mbox_add(struct pci_dev *pdev, struct proc_thermal_device *proc_priv)
 {
-	u32 cmd_resp;
+	u64 cmd_resp;
 	int ret;
 
 	/* Check if there is a mailbox support, if fails return success */
diff --git a/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c b/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c
index 3b3e81f99a34..e693ec8234fb 100644
--- a/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c
+++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c
@@ -195,7 +195,7 @@ static ssize_t rfi_restriction_store(struct device *dev,
 				     const char *buf, size_t count)
 {
 	u16 cmd_id = 0x0008;
-	u32 cmd_resp;
+	u64 cmd_resp;
 	u32 input;
 	int ret;
 
@@ -215,14 +215,14 @@ static ssize_t rfi_restriction_show(struct device *dev,
 				    char *buf)
 {
 	u16 cmd_id = 0x0007;
-	u32 cmd_resp;
+	u64 cmd_resp;
 	int ret;
 
 	ret = processor_thermal_send_mbox_cmd(to_pci_dev(dev), cmd_id, 0, &cmd_resp);
 	if (ret)
 		return ret;
 
-	return sprintf(buf, "%u\n", cmd_resp);
+	return sprintf(buf, "%llu\n", cmd_resp);
 }
 
 static ssize_t ddr_data_rate_show(struct device *dev,
@@ -230,14 +230,14 @@ static ssize_t ddr_data_rate_show(struct device *dev,
 				  char *buf)
 {
 	u16 cmd_id = 0x0107;
-	u32 cmd_resp;
+	u64 cmd_resp;
 	int ret;
 
 	ret = processor_thermal_send_mbox_cmd(to_pci_dev(dev), cmd_id, 0, &cmd_resp);
 	if (ret)
 		return ret;
 
-	return sprintf(buf, "%u\n", cmd_resp);
+	return sprintf(buf, "%llu\n", cmd_resp);
 }
 
 static DEVICE_ATTR_RW(rfi_restriction);
-- 
2.17.1

