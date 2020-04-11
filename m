Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B90B81A4E2B
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 07:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725901AbgDKFKF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 01:10:05 -0400
Received: from mail-co1nam11on2132.outbound.protection.outlook.com ([40.107.220.132]:9824
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725869AbgDKFKF (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 01:10:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OLbk3H5epLur58b8bBh5hvP8aN/+yO/LwMvniFKq05rFCnE0bVuSalyDRjA9hhKjbiaXxa+moolKyxOHYnRnfIFliTHk8xxDuYkaelRkVpmkiaYh5SP15sChRKuolyodra8mJGYJGFsV9Idj5z/Y0TOLa4T4SYL+22WwVcfe+4UqLacbTc91Yb3gT8vmKbdKh3xvpYsbOn57FzVnx16HJY8zRP/qRI8Wlnkqudfg7eH2t9+mcs99VFjcOQXeO81OYrnsS2iGYWbZQfGbf0mtfc6Klx/pDPZ1/0/rgmJJ15sOuAztovV930a4E2YfbKrpLQPSzkh7scf8pU7a2XPjxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YPbd0cE0XSRsoW3HfTrsW1+g2mKCnulzLfld8u0a4a4=;
 b=YI6SCbDdtA7mRLa61yw2hOU+npiPHuxWpyToccYltPTW39x6Pb6sFNZUIyni2bdkeHecCyWJPYqZtfUwGCfF0yMaT8hGH5BJyD2fGS2AR4+jVc6mH3jq5uZ6D3nXHimB/PfW+d4+N6+jUZAOSii8cfOYIIiKQLe0auF3vi68JvhLSN0QgoOapEHNj4YB6poXX52G3S6cynMitRNb0DZr2+1wppj5OYOCLnq7AnFdwQGD5rWVAmfZMZE4dvEd5GAmZnGY0mNkpcJ1LZGUgJWkWUlSYK97ys8t7+ffK4nvNBysDyuonH1wx0MJOA8pD3ADk2uYThJbNgKXWoVabIsc6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YPbd0cE0XSRsoW3HfTrsW1+g2mKCnulzLfld8u0a4a4=;
 b=bcLLmuAyy448O3WRmGCAbqETGuXsEU0/SOEp/SncYya5BEt8P21K13tKGzt3IoP4lm11X95YMDGTDo3NrzCrEnYbUMja3+MyoEP90IxDH5RlOINAXBCNE42sabeYjPwmmDmwCdrKMNexl4p8WRvaOonqTNpaO1uJjIFyEGpv5po=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
Received: from BN8PR21MB1139.namprd21.prod.outlook.com (2603:10b6:408:72::10)
 by BN8PR21MB1361.namprd21.prod.outlook.com (2603:10b6:408:a7::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.6; Sat, 11 Apr
 2020 05:09:26 +0000
Received: from BN8PR21MB1139.namprd21.prod.outlook.com
 ([fe80::b01b:e85:784d:4581]) by BN8PR21MB1139.namprd21.prod.outlook.com
 ([fe80::b01b:e85:784d:4581%9]) with mapi id 15.20.2921.009; Sat, 11 Apr 2020
 05:09:25 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, mikelley@microsoft.com,
        vkuznets@redhat.com
Cc:     Dexuan Cui <decui@microsoft.com>, stable@vger.kernel.org
Subject: [PATCH v2] Drivers: hv: vmbus: Fix Suspend-to-Idle for Generation-2 VM
Date:   Fri, 10 Apr 2020 22:08:04 -0700
Message-Id: <1586581684-113131-1-git-send-email-decui@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Reply-To: decui@microsoft.com
Content-Type: text/plain
X-ClientProxiedBy: MWHPR21CA0043.namprd21.prod.outlook.com
 (2603:10b6:300:129::29) To BN8PR21MB1139.namprd21.prod.outlook.com
 (2603:10b6:408:72::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (13.77.154.182) by MWHPR21CA0043.namprd21.prod.outlook.com (2603:10b6:300:129::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.3 via Frontend Transport; Sat, 11 Apr 2020 05:09:23 +0000
X-Mailer: git-send-email 1.8.3.1
X-Originating-IP: [13.77.154.182]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e355bd01-ca56-467a-eee6-08d7ddd68031
X-MS-TrafficTypeDiagnostic: BN8PR21MB1361:|BN8PR21MB1361:|BN8PR21MB1361:
X-MS-Exchange-Transport-Forked: True
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-Microsoft-Antispam-PRVS: <BN8PR21MB13612B052D57F5F5D4786694BFDF0@BN8PR21MB1361.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 03706074BC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR21MB1139.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(136003)(39860400002)(366004)(376002)(346002)(396003)(66556008)(16526019)(66476007)(66946007)(82950400001)(36756003)(86362001)(316002)(6666004)(4326008)(82960400001)(3450700001)(2906002)(52116002)(10290500003)(81156014)(6486002)(15650500001)(2616005)(5660300002)(8936002)(26005)(478600001)(6506007)(186003)(8676002)(956004)(6512007);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g0MTkOj68Q8rMMRjqzUAGyYo93KF8U3h631KkAKv/Ubq0ZijPlhQARuIIT7BceDcpxqPlbBGE3Ra3WiU8qXpomAXjRj0P6YTQobNs9L3sOIt5U4SLXIjjY7ZQHveZ/xZusTDhs9Y00npAo7XZ8zV43+QKuMyVfs3hwVPbu3ujqfR/g6LtExoRu6fi2MGEXkUjpYlKhAKu3/1/DonSVxg0XfEKlul32O2MB0NsNm8BqXxoi84GrAcDYKOaCpKfUQ3+9Kt3++GRjoW1vKFJkkZc2JQ+2725P/fsojRFA47enM2FZgKPgLIed7jJO0OYrOFc++sAhAV6/brJTKuYM/DvW77omVm0JRcE2yFZyDy/6b48Sz3FwpHgHFTyorBQFdQE3xBzGcKaZ2WO+0BP+xsyaNulM73a/2HzTbGQCt/zxHK9aTkEj8I3u0+/fI2Gck8
X-MS-Exchange-AntiSpam-MessageData: bsPNd9KxiN7vQKSbjDSqeaj8SzTC12T42I29c7ZosQLc/yhKMSXpzM+3wxzIrqiRQ0zY1tZrXYWbKlXFG5d5oj+jma3XIHrsqLJ7swavz7HJN7nFDAKGIyoi1RKQ2T25zIG2huEgq2AWv0LRnJtYmg==
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e355bd01-ca56-467a-eee6-08d7ddd68031
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2020 05:09:25.4692
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xcqZAm1knKMr2wXmuTArceEVrEUCWMeblyf1kDu286/9IIipKP43kMZ/bet0HJ3y4ir1Us2XeX6WYSdBMgnnOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR21MB1361
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Before the hibernation patchset (e.g. f53335e3289f), in a Generation-2
Linux VM on Hyper-V, the user can run "echo freeze > /sys/power/state" to
freeze the system, i.e. Suspend-to-Idle. The user can press the keyboard
or move the mouse to wake up the VM.

With the hibernation patchset, Linux VM on Hyper-V can hibernate to disk,
but Suspend-to-Idle is broken: when the synthetic keyboard/mouse are
suspended, there is no way to wake up the VM.

Fix the issue by not suspending and resuming the vmbus devices upon
Suspend-to-Idle.

Fixes: f53335e3289f ("Drivers: hv: vmbus: Suspend/resume the vmbus itself for hibernation")
Cc: stable@vger.kernel.org
Signed-off-by: Dexuan Cui <decui@microsoft.com>
---

Changes in v2:
    Added "#define vmbus_suspend NULL", etc. for the case where
CONFIG_PM_SLEEP is not defined.
    Many thanks to kbuild test robot <lkp@intel.com> for this!

 drivers/hv/vmbus_drv.c | 43 ++++++++++++++++++++++++++++++++++---------
 1 file changed, 34 insertions(+), 9 deletions(-)

diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 029378c..f2985bd 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -950,6 +950,9 @@ static int vmbus_resume(struct device *child_device)
 
 	return drv->resume(dev);
 }
+#else
+#define vmbus_suspend NULL
+#define vmbus_resume NULL
 #endif /* CONFIG_PM_SLEEP */
 
 /*
@@ -969,11 +972,22 @@ static void vmbus_device_release(struct device *device)
 }
 
 /*
- * Note: we must use SET_NOIRQ_SYSTEM_SLEEP_PM_OPS rather than
- * SET_SYSTEM_SLEEP_PM_OPS: see the comment before vmbus_bus_pm.
+ * Note: we must use the "noirq" ops: see the comment before vmbus_bus_pm.
+ *
+ * suspend_noirq/resume_noirq are set to NULL to support Suspend-to-Idle: we
+ * shouldn't suspend the vmbus devices upon Suspend-to-Idle, otherwise there
+ * is no way to wake up a Generation-2 VM.
+ *
+ * The other 4 ops are for hibernation.
  */
+
 static const struct dev_pm_ops vmbus_pm = {
-	SET_NOIRQ_SYSTEM_SLEEP_PM_OPS(vmbus_suspend, vmbus_resume)
+	.suspend_noirq	= NULL,
+	.resume_noirq	= NULL,
+	.freeze_noirq	= vmbus_suspend,
+	.thaw_noirq	= vmbus_resume,
+	.poweroff_noirq	= vmbus_suspend,
+	.restore_noirq	= vmbus_resume,
 };
 
 /* The one and only one */
@@ -2253,6 +2267,9 @@ static int vmbus_bus_resume(struct device *dev)
 
 	return 0;
 }
+#else
+#define vmbus_bus_suspend NULL
+#define vmbus_bus_resume NULL
 #endif /* CONFIG_PM_SLEEP */
 
 static const struct acpi_device_id vmbus_acpi_device_ids[] = {
@@ -2263,16 +2280,24 @@ static int vmbus_bus_resume(struct device *dev)
 MODULE_DEVICE_TABLE(acpi, vmbus_acpi_device_ids);
 
 /*
- * Note: we must use SET_NOIRQ_SYSTEM_SLEEP_PM_OPS rather than
- * SET_SYSTEM_SLEEP_PM_OPS, otherwise NIC SR-IOV can not work, because the
- * "pci_dev_pm_ops" uses the "noirq" callbacks: in the resume path, the
- * pci "noirq" restore callback runs before "non-noirq" callbacks (see
+ * Note: we must use the "no_irq" ops, otherwise hibernation can not work with
+ * PCI device assignment, because "pci_dev_pm_ops" uses the "noirq" ops: in
+ * the resume path, the pci "noirq" restore op runs before "non-noirq" op (see
  * resume_target_kernel() -> dpm_resume_start(), and hibernation_restore() ->
  * dpm_resume_end()). This means vmbus_bus_resume() and the pci-hyperv's
- * resume callback must also run via the "noirq" callbacks.
+ * resume callback must also run via the "noirq" ops.
+ *
+ * Set suspend_noirq/resume_noirq to NULL for Suspend-to-Idle: see the comment
+ * earlier in thie file before vmbus_pm.
  */
+
 static const struct dev_pm_ops vmbus_bus_pm = {
-	SET_NOIRQ_SYSTEM_SLEEP_PM_OPS(vmbus_bus_suspend, vmbus_bus_resume)
+	.suspend_noirq	= NULL,
+	.resume_noirq	= NULL,
+	.freeze_noirq	= vmbus_bus_suspend,
+	.thaw_noirq	= vmbus_bus_resume,
+	.poweroff_noirq	= vmbus_bus_suspend,
+	.restore_noirq	= vmbus_bus_resume
 };
 
 static struct acpi_driver vmbus_acpi_driver = {
-- 
1.8.3.1

