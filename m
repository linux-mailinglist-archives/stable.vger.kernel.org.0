Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF98D1A4BD3
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 00:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbgDJWR7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Apr 2020 18:17:59 -0400
Received: from mail-bn8nam11on2111.outbound.protection.outlook.com ([40.107.236.111]:57441
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726594AbgDJWR7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Apr 2020 18:17:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BrvVPiPTobMyjQjuytem5MLLhUefGDnLWDPxtiz9NxHjd7dW12blvyTAcUz0hfO2U+/WISgmyd0Q63sayRsepX+PSCkH98QNo+QraP751WvexPhMouafcO/bXvQGV0ADBrixps9BWOSuExX2Tb/tdKLfDPLQEJNTZJwNg25xmY5jRkEExShR8WIiVPraLp9j/SaQTNwBfslJUentmah6mFAVM1il4/JGkPWZyvF7s45vGRLaMKMG+TtOFIillzjiyhLDVL6ldTq/wVODVefquAxOg6P8Xz/vBpJFWypLRjqNdTeQmThwigLKeM0NdG8Xd57neunPfVPczcvWLFRdaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=94oKViTZYfV255bKs841lRpVgakFZ99tR9nmqF+B94s=;
 b=OnS1pxZvhRK1OMe4A0kPdvAbg/5H7x5EUwVYANz+003SCzXoipAABU2Oqj9EWdmj2p3t+GXp0kn+9IF9h0IBbkW3mP/6+8CFMahwSPHrm85Ts9Mgu84zi5Wk5d7wMaD96qras6fuomzrgjKWyVf/HFRTSVhBIvVMjxXZaLrX2Vj8+yk3EXVhrH/HzNVHHax/wDV2GnnViQSDxruBkk2eP8T7IG0TmzubgyhjprlEcPPUZ4XD91/FOgBNdyJyiW7fzlyTEgERvGExCB2dggaL7XpKlpy6OdOXGcB4llW0YywfpzX6Gyc3vtozRksYuO85sbwDhJidZla1QQxUG5VFuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=94oKViTZYfV255bKs841lRpVgakFZ99tR9nmqF+B94s=;
 b=UE0L9XV5wybrs8jxIG/4JPiAtkq4RNg7Pn14PioKz6pTHp7P5pv/PSMwZuZApxeei4HW7AOqqmKcdYVNnX88C8xQM7lv22zjeY76MjBx57dBwEGf4XHHSHJu/yA4+IbPrwud2+WThfATI96K6M+pCROv34o29CfxegJ+q7Ie7hU=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
Received: from BN8PR21MB1139.namprd21.prod.outlook.com (2603:10b6:408:72::10)
 by BN8PR21MB1204.namprd21.prod.outlook.com (2603:10b6:408:76::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.6; Fri, 10 Apr
 2020 22:17:57 +0000
Received: from BN8PR21MB1139.namprd21.prod.outlook.com
 ([fe80::b01b:e85:784d:4581]) by BN8PR21MB1139.namprd21.prod.outlook.com
 ([fe80::b01b:e85:784d:4581%9]) with mapi id 15.20.2921.009; Fri, 10 Apr 2020
 22:17:57 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, mikelley@microsoft.com,
        vkuznets@redhat.com
Cc:     Dexuan Cui <decui@microsoft.com>, stable@vger.kernel.org
Subject: [PATCH] Drivers: hv: vmbus: Fix Suspend-to-Idle for Generation-2 VM
Date:   Fri, 10 Apr 2020 15:17:35 -0700
Message-Id: <1586557055-13776-1-git-send-email-decui@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Reply-To: decui@microsoft.com
Content-Type: text/plain
X-ClientProxiedBy: MWHPR1201CA0023.namprd12.prod.outlook.com
 (2603:10b6:301:4a::33) To BN8PR21MB1139.namprd21.prod.outlook.com
 (2603:10b6:408:72::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (13.77.154.182) by MWHPR1201CA0023.namprd12.prod.outlook.com (2603:10b6:301:4a::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.15 via Frontend Transport; Fri, 10 Apr 2020 22:17:55 +0000
X-Mailer: git-send-email 1.8.3.1
X-Originating-IP: [13.77.154.182]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f4b8a624-5e37-4764-9453-08d7dd9d0508
X-MS-TrafficTypeDiagnostic: BN8PR21MB1204:|BN8PR21MB1204:|BN8PR21MB1204:
X-MS-Exchange-Transport-Forked: True
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-Microsoft-Antispam-PRVS: <BN8PR21MB12045D104EBBA1E639B4C2A3BFDE0@BN8PR21MB1204.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0369E8196C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR21MB1139.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(396003)(39860400002)(366004)(136003)(376002)(346002)(52116002)(6506007)(316002)(66946007)(16526019)(478600001)(186003)(10290500003)(2616005)(2906002)(66476007)(66556008)(956004)(3450700001)(6666004)(86362001)(4326008)(5660300002)(6486002)(8936002)(6512007)(15650500001)(82960400001)(8676002)(82950400001)(36756003)(81156014)(26005);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QLaYedKGN9rSIMenATmwN0WWnszgVLE3QSR925jQMQj/6hCQTAUipmkAdt6zohjUWaz72qz/fUizoMCN6JIV1ARq9xZ29nxB6L9jNfNZZCzh+dQBD8ZlG9tlsVLtKt2AVCTQlO7G/LzIafzZmnmkVdv5imoMUs2kVNyGQi2pKHiXnlOW8IC4IwkMX5rSxQwZ1WWhq2RSGYv/RkrQ+1TVhtz5vPGXxPGqhCJhXDXs3RjFN4g0EP7Oq1v12mtY7l0lZj8zRPbVGPmHwj4g/TolAFfwE9/YuTqCjsxssrCqD2JjyqQd+SGYOUJwW0Mw98+yAXtyWpeDRoGy25if//ATCuBNqd3evYXzjooPh0mZ++cgRa+ar++S87vBURWLKk2SyQCYldXK5ISEp4SsyB5TZaz3di4lKvVaKI80HmywUip92rSOu2vk8rO4t4vLXVmR
X-MS-Exchange-AntiSpam-MessageData: K0qEpyo/SZwQku1rkwNdtO765VruqqyI9gXlcE1LrjX2L3uR2BGCzGlnGJ/Li9WfpjEb4Ce4hUdlLNQRvYvoZvPfzfhpcoKCT5QoMkTMw+Qi6l0zYPwOVLO/xpPzBRxdGTK5IBWe4rOXJVmwo9X8lw==
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4b8a624-5e37-4764-9453-08d7dd9d0508
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2020 22:17:56.8492
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yvFbxO1+TJQb/2HeqedsNN2AQt6ATbw6lYDG7OWHvt6mTCV0XXPAP97oKNQxAtdiQctM+KFuBuZGXD7GncCK2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR21MB1204
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
 drivers/hv/vmbus_drv.c | 37 ++++++++++++++++++++++++++++---------
 1 file changed, 28 insertions(+), 9 deletions(-)

diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 029378c27421..821185d20cbd 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -969,11 +969,22 @@ static void vmbus_device_release(struct device *device)
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
@@ -2263,16 +2274,24 @@ static const struct acpi_device_id vmbus_acpi_device_ids[] = {
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
2.19.1

