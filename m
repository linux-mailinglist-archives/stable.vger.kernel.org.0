Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94956694ADA
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 16:17:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbjBMPRA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 10:17:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbjBMPQx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 10:16:53 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2075.outbound.protection.outlook.com [40.107.243.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4D71BBB7
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 07:16:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wvo68PRKt4DLqnyxMqNemjqMglgdvUEJtTpOYjXW6/XVEQr4u8E8jX3dc+6fg0dXPFKbqEAxOE3HQdv0EwRNflI0Il6Z5yqgWNpgvZW9db0EeEmfhrdumbZ0+F0u+jF2PHXNa+iIETgM8fp+UqVUXBHHbzhbQc7Ke+BJdz9SUSSGRgnCusU1Ce6qMWMqizK8fPbEIVMvIDHT1QdrdkP4Gihitw9y3xwr2DEJSVEArumwRl51vnOlM0P7xo3kbWYp5ofF+uP9hnhmQw3jInPsb5Wd948OZPVUbln+7bEbe/yfSAVrrTp/hS8/DLMY+vziwz01P7PIjz0nxda/cSWl7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zh7wgUo0Rk7BkMjOTv+lCKwOQ/B1AUFaIp9gyjf2+N8=;
 b=SeFgsOMZ1glax39dyodTXkrYVI7PcbB4+SFIkTNoauIbLGtG8OW6bwbWmycJpbcBw6DtJzafxD9grBrfgHU67SkXir3KMyNoJe0/z+Z/Wy8nZTB8iwycgJa7h6xk23OnHuzfnVSVZZfAx6ssez+wozNU3ndX7toaOGRNGdEvSK8KPIWVqXu6UW47HQfIi4MXl1vzBgnANliDNXKczsnl+zD4NeJ6IAt0jPeVDkjh+eE4N0CJ9mZEF6+kiko4QZrB359e+xXwG+4r9Sq3EwJF/vDvWqC+bG0+AzoxrSr0P5rrQEEUZnqohHDnB7wujIjK/xjSmaGum4jE+J2VG/313w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zh7wgUo0Rk7BkMjOTv+lCKwOQ/B1AUFaIp9gyjf2+N8=;
 b=vjx/S3mv0bxUQEcr5wKTZ9K7bH3by/Y42Cdtpg40UhWL69Tk4B2H2uVaCJRGGrl9lRE/0lln/ovo80TeJoCY8rN5dAIg7f1m9fmiUmFipOcY5u/0aH1j37Epdjf7CmhYedEubsgtORJY3ek11FwuXynDk7RdeqbMfgyhCH1Erk0=
Received: from MW4PR04CA0095.namprd04.prod.outlook.com (2603:10b6:303:83::10)
 by IA1PR12MB7494.namprd12.prod.outlook.com (2603:10b6:208:41a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Mon, 13 Feb
 2023 15:16:01 +0000
Received: from CO1NAM11FT014.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:83:cafe::e4) by MW4PR04CA0095.outlook.office365.com
 (2603:10b6:303:83::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24 via Frontend
 Transport; Mon, 13 Feb 2023 15:16:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT014.mail.protection.outlook.com (10.13.175.99) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6086.24 via Frontend Transport; Mon, 13 Feb 2023 15:16:01 +0000
Received: from AUS-LX-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 13 Feb
 2023 09:16:00 -0600
From:   Mario Limonciello <mario.limonciello@amd.com>
To:     <stable@vger.kernel.org>
CC:     Mario Limonciello <mario.limonciello@amd.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Xaver Hugl <xaver.hugl@gmail.com>,
        "Hans de Goede" <hdegoede@redhat.com>
Subject: [5.15.y backport 1/1] platform/x86/amd: pmc: Disable IRQ1 wakeup for RN/CZN
Date:   Mon, 13 Feb 2023 09:15:43 -0600
Message-ID: <20230213151543.176-2-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230213151543.176-1-mario.limonciello@amd.com>
References: <20230213151543.176-1-mario.limonciello@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT014:EE_|IA1PR12MB7494:EE_
X-MS-Office365-Filtering-Correlation-Id: dd278e1e-620a-4e58-4faa-08db0dd53776
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N6YlC79un2myhMChALBojJkmFWYCFc4WChRUmUlL315XzSSbXh2S6e6Tu8XavPZW9H4YshBhKYozHjZe+DGhuFYBgXtTsxbRTL6L7rUKCXMXdAJQ4Qhg0CeUZOQghjxvhH3IoPV8up6bRanvMBM6yy/wsFRDho3zpji3tJUfsSubfWpbjE/7+iy7Q8S9WYRstHFa27IUBFoha5D/2UdwLg+BUY2fLiC6DCjZ9+wZRbjhHf1Pz/40NSflSCGO6lvMivN6qafMluMsED8urWds1++lLq6x5pqU5HaGIpWoOm3kAiTfcz82KzZKYPScsNLtsdB1fNslTge85uOviNh/+Q36amVemZ9lhmRI/8FFgnAZ8yoybCg/9YtXbN8aJVN4qe50N3k4NX3POI36qoY1fyV8kE/1I8y0Pex6nDb+lpVKBgPTAzGGMiHh4VMEh/k1P7CLCjNdzSaMej3qaakPh+JeXXyciixQ2dWcUvbzSc4N6KwWBCWlybtgMDw3/addnmpsNk2naTrH0/QF3moc5P4zW+wXYCAvA35PFpQE5W4sZEc75rZ+vpEteB7qiVpgqyk+aS2dVJk4743M+MmMaM0MepqcBui7IYX0dkzxKt6JfDqJz+VE6E91rdS9HV4x8++1MSnQIoj+fc6OZ/91cHT8VPkxnL6EWbVLCXpWD8AQ8vwZfAhlQMgAotpZTibce9TV1JiabcreXA2/hX0/Vs32mG1MK/Xa0Jj/2g9uEDpg/TIAObZYRaCFM4GgOt82
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(136003)(396003)(39860400002)(451199018)(36840700001)(40470700004)(46966006)(356005)(86362001)(478600001)(2906002)(186003)(16526019)(26005)(1076003)(44832011)(2616005)(5660300002)(81166007)(40460700003)(82740400003)(36860700001)(8936002)(6666004)(41300700001)(316002)(966005)(336012)(82310400005)(7696005)(40480700001)(426003)(8676002)(70206006)(70586007)(47076005)(4326008)(6916009)(54906003)(36756003)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 15:16:01.1034
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dd278e1e-620a-4e58-4faa-08db0dd53776
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT014.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7494
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

By default when the system is configured for low power idle in the FADT
the keyboard is set up as a wake source.  This matches the behavior that
Windows uses for Modern Standby as well.

It has been reported that a variety of AMD based designs there are
spurious wakeups are happening where two IRQ sources are active.

For example:
```
PM: Triggering wakeup from IRQ 9
PM: Triggering wakeup from IRQ 1
```

In these designs IRQ 9 is the ACPI SCI and IRQ 1 is the keyboard.
One way to trigger this problem is to suspend the laptop and then unplug
the AC adapter.  The SOC will be in a hardware sleep state and plugging
in the AC adapter returns control to the kernel's s2idle loop.

Normally if just IRQ 9 was active the s2idle loop would advance any EC
transactions and no other IRQ being active would cause the s2idle loop
to put the SOC back into hardware sleep state.

When this bug occurred IRQ 1 is also active even if no keyboard activity
occurred. This causes the s2idle loop to break and the system to wake.

This is a platform firmware bug triggering IRQ1 without keyboard activity.
This occurs in Windows as well, but Windows will enter "SW DRIPS" and
then with no activity enters back into "HW DRIPS" (hardware sleep state).

This issue affects Renoir, Lucienne, Cezanne, and Barcelo platforms. It
does not happen on newer systems such as Mendocino or Rembrandt.

It's been fixed in newer platform firmware.  To avoid triggering the bug
on older systems check the SMU F/W version and adjust the policy at suspend
time for s2idle wakeup from keyboard on these systems. A lot of thought
and experimentation has been given around the timing of disabling IRQ1,
and to make it work the "suspend" PM callback is restored.

Reported-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Reported-by: Xaver Hugl <xaver.hugl@gmail.com>
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2115
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/1951
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20230120191519.15926-1-mario.limonciello@amd.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
(cherry picked from commit 8e60615e8932167057b363c11a7835da7f007106)
(cherry picked from commit f6045de1f53268131ea75a99b210b869dcc150b2)
These have been hand modified for missing dependency commits.
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/1921#note_1770257
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
---
 drivers/platform/x86/amd-pmc.c | 59 ++++++++++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)

diff --git a/drivers/platform/x86/amd-pmc.c b/drivers/platform/x86/amd-pmc.c
index d3efd514614c..4320c79bd6fc 100644
--- a/drivers/platform/x86/amd-pmc.c
+++ b/drivers/platform/x86/amd-pmc.c
@@ -20,6 +20,7 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/platform_device.h>
+#include <linux/serio.h>
 #include <linux/suspend.h>
 #include <linux/seq_file.h>
 #include <linux/uaccess.h>
@@ -110,6 +111,10 @@ struct amd_pmc_dev {
 	u32 base_addr;
 	u32 cpu_id;
 	u32 active_ips;
+/* SMU version information */
+	u16 major;
+	u16 minor;
+	u16 rev;
 	struct device *dev;
 	struct mutex lock; /* generic mutex lock */
 #if IS_ENABLED(CONFIG_DEBUG_FS)
@@ -201,6 +206,24 @@ static int s0ix_stats_show(struct seq_file *s, void *unused)
 }
 DEFINE_SHOW_ATTRIBUTE(s0ix_stats);
 
+static int amd_pmc_get_smu_version(struct amd_pmc_dev *dev)
+{
+	int rc;
+	u32 val;
+
+	rc = amd_pmc_send_cmd(dev, 0, &val, SMU_MSG_GETSMUVERSION, 1);
+	if (rc)
+		return rc;
+
+	dev->major = (val >> 16) & GENMASK(15, 0);
+	dev->minor = (val >> 8) & GENMASK(7, 0);
+	dev->rev = (val >> 0) & GENMASK(7, 0);
+
+	dev_dbg(dev->dev, "SMU version is %u.%u.%u\n", dev->major, dev->minor, dev->rev);
+
+	return 0;
+}
+
 static void amd_pmc_dbgfs_unregister(struct amd_pmc_dev *dev)
 {
 	debugfs_remove_recursive(dev->dbgfs_dir);
@@ -339,12 +362,48 @@ static int amd_pmc_get_os_hint(struct amd_pmc_dev *dev)
 	return -EINVAL;
 }
 
+static int amd_pmc_czn_wa_irq1(struct amd_pmc_dev *pdev)
+{
+	struct device *d;
+	int rc;
+
+	if (!pdev->major) {
+		rc = amd_pmc_get_smu_version(pdev);
+		if (rc)
+			return rc;
+	}
+
+	if (pdev->major > 64 || (pdev->major == 64 && pdev->minor > 65))
+		return 0;
+
+	d = bus_find_device_by_name(&serio_bus, NULL, "serio0");
+	if (!d)
+		return 0;
+	if (device_may_wakeup(d)) {
+		dev_info_once(d, "Disabling IRQ1 wakeup source to avoid platform firmware bug\n");
+		disable_irq_wake(1);
+		device_set_wakeup_enable(d, false);
+	}
+	put_device(d);
+
+	return 0;
+}
+
 static int __maybe_unused amd_pmc_suspend(struct device *dev)
 {
 	struct amd_pmc_dev *pdev = dev_get_drvdata(dev);
 	int rc;
 	u8 msg;
 
+	if (pdev->cpu_id == AMD_CPU_ID_CZN) {
+		int rc = amd_pmc_czn_wa_irq1(pdev);
+
+		if (rc) {
+			dev_err(pdev->dev, "failed to adjust keyboard wakeup: %d\n", rc);
+			return rc;
+		}
+	}
+
 	/* Reset and Start SMU logging - to monitor the s0i3 stats */
 	amd_pmc_send_cmd(pdev, 0, NULL, SMU_MSG_LOG_RESET, 0);
 	amd_pmc_send_cmd(pdev, 0, NULL, SMU_MSG_LOG_START, 0);
-- 
2.34.1

