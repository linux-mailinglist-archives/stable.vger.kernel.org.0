Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE3F4B48BD
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:58:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343971AbiBNJ5w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:57:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345110AbiBNJ4f (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:56:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AC72811A0;
        Mon, 14 Feb 2022 01:45:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A9BECB80DC4;
        Mon, 14 Feb 2022 09:45:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C9D2C36AE3;
        Mon, 14 Feb 2022 09:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831906;
        bh=GxhdHPylJZGUA7W2V1+Kn1+bjgaht4Bynzk8qHwc30I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=te+LB/gOy90bQDlvHVkPEK+vs7CZHgte2AibXMSsIvG/LQP0/jwcY8DvMku599ZgA
         +mplAbgmp75apwrzUKqgehKXaf8SY5sbQx8A3Gb4iz96YCBKKb318nTQJ3PNS+86p5
         IU27kad/SGw0E6S2zjPhHkm4YbzO5lnpv/LPJm1Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Antoine Tenart <atenart@kernel.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>,
        Srinivas Pandruvada <srinivas.pIandruvada@linux.intel.com>
Subject: [PATCH 5.15 018/172] thermal/drivers/int340x: Improve the tcc offset saving for suspend/resume
Date:   Mon, 14 Feb 2022 10:24:36 +0100
Message-Id: <20220214092507.012140145@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
References: <20220214092506.354292783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/intel/int340x_thermal/int3401_thermal.c                     |    8 +-
 drivers/thermal/intel/int340x_thermal/processor_thermal_device.c            |   36 +++++++---
 drivers/thermal/intel/int340x_thermal/processor_thermal_device.h            |    1 
 drivers/thermal/intel/int340x_thermal/processor_thermal_device_pci.c        |   18 ++++-
 drivers/thermal/intel/int340x_thermal/processor_thermal_device_pci_legacy.c |    8 +-
 5 files changed, 60 insertions(+), 11 deletions(-)

--- a/drivers/thermal/intel/int340x_thermal/int3401_thermal.c
+++ b/drivers/thermal/intel/int340x_thermal/int3401_thermal.c
@@ -44,15 +44,21 @@ static int int3401_remove(struct platfor
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
--- a/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c
+++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c
@@ -68,8 +68,7 @@ static const struct attribute_group powe
 	.name = "power_limits"
 };
 
-static ssize_t tcc_offset_degree_celsius_show(struct device *dev,
-			       struct device_attribute *attr, char *buf)
+static int tcc_get_offset(void)
 {
 	u64 val;
 	int err;
@@ -78,8 +77,20 @@ static ssize_t tcc_offset_degree_celsius
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
@@ -107,8 +118,6 @@ static int tcc_offset_update(unsigned in
 	return 0;
 }
 
-static int tcc_offset_save = -1;
-
 static ssize_t tcc_offset_degree_celsius_store(struct device *dev,
 				struct device_attribute *attr, const char *buf,
 				size_t count)
@@ -131,8 +140,6 @@ static ssize_t tcc_offset_degree_celsius
 	if (err)
 		return err;
 
-	tcc_offset_save = tcc;
-
 	return count;
 }
 
@@ -345,6 +352,18 @@ void proc_thermal_remove(struct proc_the
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
@@ -352,6 +371,7 @@ int proc_thermal_resume(struct device *d
 	proc_dev = dev_get_drvdata(dev);
 	proc_thermal_read_ppcc(proc_dev);
 
+	/* Do not update if saving failed */
 	if (tcc_offset_save >= 0)
 		tcc_offset_update(tcc_offset_save);
 
--- a/drivers/thermal/intel/int340x_thermal/processor_thermal_device.h
+++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_device.h
@@ -83,6 +83,7 @@ void proc_thermal_mbox_remove(struct pci
 int processor_thermal_send_mbox_cmd(struct pci_dev *pdev, u16 cmd_id, u32 cmd_data, u32 *cmd_resp);
 int proc_thermal_add(struct device *dev, struct proc_thermal_device *priv);
 void proc_thermal_remove(struct proc_thermal_device *proc_priv);
+int proc_thermal_suspend(struct device *dev);
 int proc_thermal_resume(struct device *dev);
 int proc_thermal_mmio_add(struct pci_dev *pdev,
 			  struct proc_thermal_device *proc_priv,
--- a/drivers/thermal/intel/int340x_thermal/processor_thermal_device_pci.c
+++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_device_pci.c
@@ -314,6 +314,20 @@ static void proc_thermal_pci_remove(stru
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
@@ -335,10 +349,12 @@ static int proc_thermal_pci_resume(struc
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
--- a/drivers/thermal/intel/int340x_thermal/processor_thermal_device_pci_legacy.c
+++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_device_pci_legacy.c
@@ -107,15 +107,21 @@ static void proc_thermal_pci_remove(stru
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


