Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D715C4B23A0
	for <lists+stable@lfdr.de>; Fri, 11 Feb 2022 11:45:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343864AbiBKKpK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Feb 2022 05:45:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349050AbiBKKpJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Feb 2022 05:45:09 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0280D54
        for <stable@vger.kernel.org>; Fri, 11 Feb 2022 02:45:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644576307; x=1676112307;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=vgLME1VzGnusMKF94o/72BwpF0H9m2fjPmwuvOH4gU0=;
  b=VeBH9k0gW71Cb45ReK3Xpxbo7gVPdcIc2cAkAPRiN2wlYCbGI2Ct/0cU
   AV027CqSPR21vsPATbcfEwGPP6+GDHtPs3RzvSQ9vygIZXkVh3uqrNc+S
   UW6uVQVBeWpT2H/Di7JZnhuuQPJ20nW0B5bGRxcFQxCso61Rqz/n8HYsu
   gpmkhifNrYqA5C/2Y5WC1bvxPKiHmPN7RZ2MH7fh2pKHQzfT9E+ulDm77
   aBzXCjhmnsmAqLdTqjyJwXJfRKMJu9L8Sz+s9VEUNNUivme0Gh2sOKL5W
   mth6sTd2rF0YEOfJt5f9V62WoAHFhgj13CYShNZCufZGqypkV/m9aS6f6
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10254"; a="233265716"
X-IronPort-AV: E=Sophos;i="5.88,360,1635231600"; 
   d="scan'208";a="233265716"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2022 02:45:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,360,1635231600"; 
   d="scan'208";a="623186886"
Received: from srpawnik-desktop.iind.intel.com ([10.223.141.132])
  by FMSMGA003.fm.intel.com with ESMTP; 11 Feb 2022 02:45:05 -0800
From:   Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        rafael.j.wysocki@intel.com, srinivas.pandruvada@linux.intel.com
Cc:     sumeet.r.pawnikar@intel.com
Subject: [PATCH V2 2/4] thermal/drivers/int340x: processor_thermal: Suppot 64 bit RFIM responses
Date:   Fri, 11 Feb 2022 16:34:33 +0530
Message-Id: <20220211110435.3724-3-sumeet.r.pawnikar@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220211110435.3724-1-sumeet.r.pawnikar@intel.com>
References: <20220211110435.3724-1-sumeet.r.pawnikar@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

commit aeb58c860dc516794fdf7ff89d96ead2644d5889 upstream.

Some of the RFIM mail box command returns 64 bit values. So enhance
mailbox interface to return 64 bit values and use them for RFIM
commands.

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Fixes: 5d6fbc96bd36 ("thermal/drivers/int340x: processor_thermal: Export additional attributes")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>
---
Changes in V2 from V1:
 - Added upstream commit id from Linus's tree.
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

