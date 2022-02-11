Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAF2F4B23A3
	for <lists+stable@lfdr.de>; Fri, 11 Feb 2022 11:45:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243765AbiBKKpK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Feb 2022 05:45:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343864AbiBKKpG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Feb 2022 05:45:06 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C06A1B81
        for <stable@vger.kernel.org>; Fri, 11 Feb 2022 02:45:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644576305; x=1676112305;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=H9mOwwO2MwLbdGXBfysaMIq+yqfsWJi8ZwjACdF+6yI=;
  b=JDx/RxwNgcLP12otp5yUYvlxBQq3X+53+d8auLQ6yFDqhjyBvi7mHoVQ
   c0Q2gS9+P6ecvqXNhnnXQDP+sszOxVAzrh/1wLtoldFesT8OTKpM/4MgH
   UGGmRgyZkizLwTbhGk3QFBHMwwkm1Vl6RFCOsiT6W09ZJeFZ+eAyRUrrE
   MXtjBjdlu815HoKMmLgWzpNm9D/aTNFlhYTncSoCri3Hx3hOcCE7Xlis2
   GmZ9MP3KD0xQL9BuM2wLYynfo78Y4Yaaw8kVMLDn3IFRGGuA2s29To4xP
   /FACX/zfhT3XQw0hFHIfR/rmLyjTywKFySyaro61MCNnGQ83FSxCGZFJv
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10254"; a="233265712"
X-IronPort-AV: E=Sophos;i="5.88,360,1635231600"; 
   d="scan'208";a="233265712"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2022 02:45:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,360,1635231600"; 
   d="scan'208";a="623186875"
Received: from srpawnik-desktop.iind.intel.com ([10.223.141.132])
  by FMSMGA003.fm.intel.com with ESMTP; 11 Feb 2022 02:45:03 -0800
From:   Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        rafael.j.wysocki@intel.com, srinivas.pandruvada@linux.intel.com
Cc:     sumeet.r.pawnikar@intel.com, Antoine Tenart <atenart@kernel.org>
Subject: [PATCH V2 1/4] thermal/drivers/int340x: Improve the tcc offset saving for suspend/resume
Date:   Fri, 11 Feb 2022 16:34:32 +0530
Message-Id: <20220211110435.3724-2-sumeet.r.pawnikar@intel.com>
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

From: Antoine Tenart <atenart@kernel.org>

commit c4fcf1ada4ae63e0aab6afd19ca2e7d16833302c upstream.

When the driver resumes, the tcc offset is set back to its previous
value. But this only works if the value was user defined as otherwise
the offset isn't saved. This asymmetric logic is harder to maintain and
introduced some issues.

Improve the logic by saving the tcc offset in a suspend op, so the right
value is always restored after a resume.

Signed-off-by: Antoine Tenart <atenart@kernel.org>
Reviewed-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Tested-by: Srinivas Pandruvada <srinivas.pI andruvada@linux.intel.com>
Link: https://lore.kernel.org/r/20210909085613.5577-3-atenart@kernel.org
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>
---
Changes in V2 from V1:
 - Added upstream commit id from Linus's tree.
---
 .../intel/int340x_thermal/int3401_thermal.c   |  8 ++++-
 .../processor_thermal_device.c                | 36 ++++++++++++++-----
 .../processor_thermal_device.h                |  1 +
 .../processor_thermal_device_pci.c            | 18 +++++++++-
 .../processor_thermal_device_pci_legacy.c     |  8 ++++-
 5 files changed, 60 insertions(+), 11 deletions(-)

diff --git a/drivers/thermal/intel/int340x_thermal/int3401_thermal.c b/drivers/thermal/intel/int340x_thermal/int3401_thermal.c
index acebc8ba94e2..217786fba185 100644
--- a/drivers/thermal/intel/int340x_thermal/int3401_thermal.c
+++ b/drivers/thermal/intel/int340x_thermal/int3401_thermal.c
@@ -44,15 +44,21 @@ static int int3401_remove(struct platform_device *pdev)
 }
 
 #ifdef CONFIG_PM_SLEEP
+static int int3401_thermal_suspend(struct device *dev)
+{
+	return proc_thermal_suspend(dev);
+}
 static int int3401_thermal_resume(struct device *dev)
 {
 	return proc_thermal_resume(dev);
 }
 #else
+#define int3401_thermal_suspend NULL
 #define int3401_thermal_resume NULL
 #endif
 
-static SIMPLE_DEV_PM_OPS(int3401_proc_thermal_pm, NULL, int3401_thermal_resume);
+static SIMPLE_DEV_PM_OPS(int3401_proc_thermal_pm, int3401_thermal_suspend,
+			 int3401_thermal_resume);
 
 static struct platform_driver int3401_driver = {
 	.probe = int3401_add,
diff --git a/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c b/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c
index fb64acfd5e07..a8d98f1bd6c6 100644
--- a/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c
+++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c
@@ -68,8 +68,7 @@ static const struct attribute_group power_limit_attribute_group = {
 	.name = "power_limits"
 };
 
-static ssize_t tcc_offset_degree_celsius_show(struct device *dev,
-			       struct device_attribute *attr, char *buf)
+static int tcc_get_offset(void)
 {
 	u64 val;
 	int err;
@@ -78,8 +77,20 @@ static ssize_t tcc_offset_degree_celsius_show(struct device *dev,
 	if (err)
 		return err;
 
-	val = (val >> 24) & 0x3f;
-	return sprintf(buf, "%d\n", (int)val);
+	return (val >> 24) & 0x3f;
+}
+
+static ssize_t tcc_offset_degree_celsius_show(struct device *dev,
+					      struct device_attribute *attr,
+					      char *buf)
+{
+	int tcc;
+
+	tcc = tcc_get_offset();
+	if (tcc < 0)
+		return tcc;
+
+	return sprintf(buf, "%d\n", tcc);
 }
 
 static int tcc_offset_update(unsigned int tcc)
@@ -107,8 +118,6 @@ static int tcc_offset_update(unsigned int tcc)
 	return 0;
 }
 
-static int tcc_offset_save = -1;
-
 static ssize_t tcc_offset_degree_celsius_store(struct device *dev,
 				struct device_attribute *attr, const char *buf,
 				size_t count)
@@ -131,8 +140,6 @@ static ssize_t tcc_offset_degree_celsius_store(struct device *dev,
 	if (err)
 		return err;
 
-	tcc_offset_save = tcc;
-
 	return count;
 }
 
@@ -345,6 +352,18 @@ void proc_thermal_remove(struct proc_thermal_device *proc_priv)
 }
 EXPORT_SYMBOL_GPL(proc_thermal_remove);
 
+static int tcc_offset_save = -1;
+
+int proc_thermal_suspend(struct device *dev)
+{
+	tcc_offset_save = tcc_get_offset();
+	if (tcc_offset_save < 0)
+		dev_warn(dev, "failed to save offset (%d)\n", tcc_offset_save);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(proc_thermal_suspend);
+
 int proc_thermal_resume(struct device *dev)
 {
 	struct proc_thermal_device *proc_dev;
@@ -352,6 +371,7 @@ int proc_thermal_resume(struct device *dev)
 	proc_dev = dev_get_drvdata(dev);
 	proc_thermal_read_ppcc(proc_dev);
 
+	/* Do not update if saving failed */
 	if (tcc_offset_save >= 0)
 		tcc_offset_update(tcc_offset_save);
 
diff --git a/drivers/thermal/intel/int340x_thermal/processor_thermal_device.h b/drivers/thermal/intel/int340x_thermal/processor_thermal_device.h
index 5a1cfe4864f1..c1d8de6dc3d1 100644
--- a/drivers/thermal/intel/int340x_thermal/processor_thermal_device.h
+++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_device.h
@@ -83,6 +83,7 @@ void proc_thermal_mbox_remove(struct pci_dev *pdev);
 int processor_thermal_send_mbox_cmd(struct pci_dev *pdev, u16 cmd_id, u32 cmd_data, u32 *cmd_resp);
 int proc_thermal_add(struct device *dev, struct proc_thermal_device *priv);
 void proc_thermal_remove(struct proc_thermal_device *proc_priv);
+int proc_thermal_suspend(struct device *dev);
 int proc_thermal_resume(struct device *dev);
 int proc_thermal_mmio_add(struct pci_dev *pdev,
 			  struct proc_thermal_device *proc_priv,
diff --git a/drivers/thermal/intel/int340x_thermal/processor_thermal_device_pci.c b/drivers/thermal/intel/int340x_thermal/processor_thermal_device_pci.c
index 11dd2e825f4f..b4bcd3fe9eb2 100644
--- a/drivers/thermal/intel/int340x_thermal/processor_thermal_device_pci.c
+++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_device_pci.c
@@ -314,6 +314,20 @@ static void proc_thermal_pci_remove(struct pci_dev *pdev)
 }
 
 #ifdef CONFIG_PM_SLEEP
+static int proc_thermal_pci_suspend(struct device *dev)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct proc_thermal_device *proc_priv;
+	struct proc_thermal_pci *pci_info;
+
+	proc_priv = pci_get_drvdata(pdev);
+	pci_info = proc_priv->priv_data;
+
+	if (!pci_info->no_legacy)
+		return proc_thermal_suspend(dev);
+
+	return 0;
+}
 static int proc_thermal_pci_resume(struct device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
@@ -335,10 +349,12 @@ static int proc_thermal_pci_resume(struct device *dev)
 	return 0;
 }
 #else
+#define proc_thermal_pci_suspend NULL
 #define proc_thermal_pci_resume NULL
 #endif
 
-static SIMPLE_DEV_PM_OPS(proc_thermal_pci_pm, NULL, proc_thermal_pci_resume);
+static SIMPLE_DEV_PM_OPS(proc_thermal_pci_pm, proc_thermal_pci_suspend,
+			 proc_thermal_pci_resume);
 
 static const struct pci_device_id proc_thermal_pci_ids[] = {
 	{ PCI_DEVICE_DATA(INTEL, ADL_THERMAL, PROC_THERMAL_FEATURE_RAPL | PROC_THERMAL_FEATURE_FIVR | PROC_THERMAL_FEATURE_DVFS | PROC_THERMAL_FEATURE_MBOX) },
diff --git a/drivers/thermal/intel/int340x_thermal/processor_thermal_device_pci_legacy.c b/drivers/thermal/intel/int340x_thermal/processor_thermal_device_pci_legacy.c
index f5fc1791b11e..4571a1a53b84 100644
--- a/drivers/thermal/intel/int340x_thermal/processor_thermal_device_pci_legacy.c
+++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_device_pci_legacy.c
@@ -107,15 +107,21 @@ static void proc_thermal_pci_remove(struct pci_dev *pdev)
 }
 
 #ifdef CONFIG_PM_SLEEP
+static int proc_thermal_pci_suspend(struct device *dev)
+{
+	return proc_thermal_suspend(dev);
+}
 static int proc_thermal_pci_resume(struct device *dev)
 {
 	return proc_thermal_resume(dev);
 }
 #else
+#define proc_thermal_pci_suspend NULL
 #define proc_thermal_pci_resume NULL
 #endif
 
-static SIMPLE_DEV_PM_OPS(proc_thermal_pci_pm, NULL, proc_thermal_pci_resume);
+static SIMPLE_DEV_PM_OPS(proc_thermal_pci_pm, proc_thermal_pci_suspend,
+			 proc_thermal_pci_resume);
 
 static const struct pci_device_id proc_thermal_pci_ids[] = {
 	{ PCI_DEVICE_DATA(INTEL, BDW_THERMAL, 0) },
-- 
2.17.1

