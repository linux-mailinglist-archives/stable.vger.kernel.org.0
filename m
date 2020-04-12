Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 226461A5C65
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 05:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbgDLDvH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 23:51:07 -0400
Received: from mail-eopbgr750112.outbound.protection.outlook.com ([40.107.75.112]:9159
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726155AbgDLDvH (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 23:51:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QDhzzK2WEXiaUp5tS3CHuifrhHw3F7eKDMw+srND+0Wnjqj6lbjkd0/l/+FTAmo7wc7P22pa8SxfWNLT/LazgqbZbqT/fc+QlaycB5UY7JeTgrQ7pcftBZtDdrg5LMk4HMulCknqyZRaz3ZAnU7TVL2YVQRUOdXWwVdJi9rfs4RTjhHi53cgspHohltw0YjIEvk08c1Qvabf2kh7tyMnCTL8a7qpYsrPDdyKCPjOvaW8pEnZ/MMcISDRmgWpJMAuM6pdkn8Z7seuPM5o00gdnBvu0n++6gx74bJOnVmaplOU1jOU6d+pFs3eRkFiBnyjP5hoes8G+vLVVHc9kYOpGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BGw2xFJzqzymQE1QWyX3g47zsfz7JjZyilx0b9xFBLQ=;
 b=NQm60xDPRD7QSz9/PqCKPHALnmsH+1o7xE6MbBJvx4s6MmRxsFEKTJFTXs5VEWhqtr5Qu3Wa2nr9rF9m5z8i683O0eYUV8WGX0by7t98CCo9kEKULb9pNaZLgHxPEvVjVwkQHpKbGIM24HHy/acfdQTLw06WsxgNrYlrU917nphPVITLZtgnjy2sRsAYRAJ+oT/zphwvh61niHO6oVUZcj0DZBBUhV+5CLrV9H+PxAHqDcyCXn6mAJ/B8Og8CUccViu6ecq071Ukii8ka/mqI1SDw1cWpdh1ApyynLedHt/xCqQd8o+XDtYbfEkyv0G+DzQqEgePk6dvkYcsPzsr6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BGw2xFJzqzymQE1QWyX3g47zsfz7JjZyilx0b9xFBLQ=;
 b=RZ8onQF5ZD+sg2aNWiAvVfB6AsLPMiA332mEMG9/7CpefrOSCYCU9gh9yNN7Vjy18Fx/wuZE8vR6eieq9u7QB9SDeWIk/bvVQN0O0Ahn7z21HnfK7NU1Z1BomKkv8wA9sfIiUBJETCkPVOUe2wEqHWSgeHNqa6SS79MRX2Kx8Sc=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
Received: from BN8PR21MB1139.namprd21.prod.outlook.com (2603:10b6:408:72::10)
 by BN8PR21MB1203.namprd21.prod.outlook.com (2603:10b6:408:76::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.5; Sun, 12 Apr
 2020 03:50:54 +0000
Received: from BN8PR21MB1139.namprd21.prod.outlook.com
 ([fe80::b01b:e85:784d:4581]) by BN8PR21MB1139.namprd21.prod.outlook.com
 ([fe80::b01b:e85:784d:4581%9]) with mapi id 15.20.2921.009; Sun, 12 Apr 2020
 03:50:53 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, mikelley@microsoft.com,
        vkuznets@redhat.com
Cc:     Dexuan Cui <decui@microsoft.com>, stable@vger.kernel.org
Subject: [PATCH v3] Drivers: hv: vmbus: Fix Suspend-to-Idle for Generation-2 VM
Date:   Sat, 11 Apr 2020 20:50:35 -0700
Message-Id: <1586663435-36243-1-git-send-email-decui@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Reply-To: decui@microsoft.com
Content-Type: text/plain
X-ClientProxiedBy: MWHPR2201CA0048.namprd22.prod.outlook.com
 (2603:10b6:301:16::22) To BN8PR21MB1139.namprd21.prod.outlook.com
 (2603:10b6:408:72::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (13.77.154.182) by MWHPR2201CA0048.namprd22.prod.outlook.com (2603:10b6:301:16::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.23 via Frontend Transport; Sun, 12 Apr 2020 03:50:51 +0000
X-Mailer: git-send-email 1.8.3.1
X-Originating-IP: [13.77.154.182]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 308a4ca4-38b8-411c-864e-08d7de94b286
X-MS-TrafficTypeDiagnostic: BN8PR21MB1203:|BN8PR21MB1203:|BN8PR21MB1203:
X-MS-Exchange-Transport-Forked: True
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-Microsoft-Antispam-PRVS: <BN8PR21MB12032B10D24950737665701CBFDC0@BN8PR21MB1203.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0371762FE7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR21MB1139.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(39860400002)(376002)(366004)(396003)(346002)(136003)(82960400001)(26005)(4326008)(36756003)(956004)(6666004)(15650500001)(82950400001)(2616005)(6486002)(186003)(6512007)(478600001)(52116002)(86362001)(16526019)(10290500003)(66556008)(6506007)(66946007)(316002)(8936002)(8676002)(5660300002)(3450700001)(2906002)(66476007)(81156014);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Si1MvXDVzl35Vmx8AR1FYTk4bynCyooJfSPMn2lggjILcI7Lba8gSxbuqBVr6tQU0FprOQbRLV34MR2VcaWWE2I4dTAm+3yYYJhOs0e+rYTI0ajLii9nKr1Z3Pz7YC/roSDAldESMf9xQ4fYU5GVD5I5QExfme10l00dF23CCCFKOxVQQiYen5+PJH2RKMV0Le1batRSnv7k62oUZE/uDG3/JCepCTLFWRwCGy5xmM38JsXB+NVtA/pI2IVMX760to3IixhQE8APpU1zWE6XAIR7trsVAd0Ey37AqykGG64BZ3ota7WwlRUEytTuhX5k8QEx/pxNp1HzZgkrB9YRc/j0wDUbmrZQchB7HYxzhyQDgjfg+waBz8Pl1iPQOzgjyivR/yj0aOGl9ss6M02wBASz1HcFm0FCF78pTol3VUKHtcTrv2oTTeJtVCKZkeH3
X-MS-Exchange-AntiSpam-MessageData: YWkvUahIBAJaJvi7i3td/7AboIAV94oD8OuSN7aLLdxn4t/ZgfXdShofNVugXUWRmKjurN2zSK+4b4d9xnsHDZXKF7L5XpEnfMuIeUBGykW5iu4YHCXs8YzobePjM4YMWtSDzchbzJmjwcj8nj0j4A==
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 308a4ca4-38b8-411c-864e-08d7de94b286
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2020 03:50:53.7875
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7+YS0T66diuXv6eH+9l0AElRePSKJYaPUw6rUrUMIXV8d72pnto5N8Gr3f8Vm9SpQTdYEb1WDcfjPVxcPzLF1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR21MB1203
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
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Signed-off-by: Dexuan Cui <decui@microsoft.com>
---

Changes in v2:
    Added "#define vmbus_suspend NULL", etc. for the case where
CONFIG_PM_SLEEP is not defined.
    Many thanks to kbuild test robot <lkp@intel.com> for this!

Changes in v3:
    Fixed a typo in the comment before "vmbus_bus_pm": thie -> this.
    Added Michael's Reviewed-by.

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
+ * earlier in this file before vmbus_pm.
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

