Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 079CF4C1A40
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 18:52:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243546AbiBWRxT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Feb 2022 12:53:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243545AbiBWRxR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Feb 2022 12:53:17 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2079.outbound.protection.outlook.com [40.107.94.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBA4D1115;
        Wed, 23 Feb 2022 09:52:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kERDEFP0dnQc0WbzpCq5HeRbjH5FOaRmYSqyRLiYEaUEGUOtdWitycN/DLDvOQl0Lzevpv2Zwh9Cer2IWpgu94fI0qKs+0khNQsa6jUA3vvwR/lh3v1sxwoH9mksWAqlEmYw9ATMxetU95D18MfrI0n+ScUu1KoU2Q9tWbYVBHgrjp+ViCwigd+Z2BZes0CVSGI8rlcoaJcO5kGrLmIJI6jvgq+QUSt+relzhYm+LBYqMTr7TpsAE1sOYACKUSfjsBhr24HL73nku/jQItfwkTjlx59I2GhbZrUU1ffXyVxPls7+Ah54qMtHfPFGQZVN5XYzVPkKNIXANQVsBI1vpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QSJMQm7jlF21VhvS1PBfiQeHU0TIRutaK3GgAjwjjeU=;
 b=RhdmMCbp9tK4CmEWqcRQh4qjyU6/ginAb+Gcor3EryDlKVZjDrtd3V8XAhGokUCfShas+8/mii9xO8NSjlJSgYQGGr/CZmTvGvxX4mKaSCMFZ9bdmHMrB2BnkWeRgBuMQSmnsSMEE67m/yb4Fui+3tNtJ9/FfA0lrOFY3N+D7cK0RxN7xH+wiDq5uXZHVWvy2+NS1iu/WE1bwCmTeNmX5n516K9auLv/slc+nG1wRWspSp4RmcNFltNIoGdGwk9zRrEPJcBPAJDbX/2Rda+UfHOidsoXMtvldbJn/j/osU3SMGeY3vlZPA6COGRvawvVuwo3jkdPuz4w8xv9SZPD5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QSJMQm7jlF21VhvS1PBfiQeHU0TIRutaK3GgAjwjjeU=;
 b=eOzgwHpiatxHwzeOKom6Y6kUzn2ahySNKeA9qqaOdkNbTBkfKUYa1XFyVq18dNfx29t0Zh/b5/ZMyIOJBw7n/amVjlyuu5mq2JO+iBd3k1maLi4XZRhd6u/UGs/1E2ZeBAs5rV7rnKYV1J3Vmf5tySXLCvvfWEuH3vaY9hK1oA0=
Received: from DM5PR10CA0023.namprd10.prod.outlook.com (2603:10b6:4:2::33) by
 DM4PR12MB5200.namprd12.prod.outlook.com (2603:10b6:5:397::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5017.22; Wed, 23 Feb 2022 17:52:47 +0000
Received: from DM6NAM11FT028.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:2:cafe::8) by DM5PR10CA0023.outlook.office365.com
 (2603:10b6:4:2::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21 via Frontend
 Transport; Wed, 23 Feb 2022 17:52:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT028.mail.protection.outlook.com (10.13.173.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5017.22 via Frontend Transport; Wed, 23 Feb 2022 17:52:47 +0000
Received: from AUS-LX-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Wed, 23 Feb
 2022 11:52:45 -0600
From:   Mario Limonciello <mario.limonciello@amd.com>
To:     Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <mgross@linux.intel.com>,
        "open list:X86 PLATFORM DRIVERS" 
        <platform-driver-x86@vger.kernel.org>
CC:     Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Goswami Sanket <Sanket.Goswami@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        <stable@vger.kernel.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH v3] platform/x86: amd-pmc: Set QOS during suspend on CZN w/ timer wakeup
Date:   Wed, 23 Feb 2022 11:52:37 -0600
Message-ID: <20220223175237.6209-1-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d2fc31c6-16d2-4c9f-68dd-08d9f6f54d42
X-MS-TrafficTypeDiagnostic: DM4PR12MB5200:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB52009B59A7C24DE54302409AE23C9@DM4PR12MB5200.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4SONDt9vfkPWqQmmJL8LNHRCw+r/dHoEM5t/O/dMoWfv2IuKTXnjy3LebPW3DB7S8tu0IOBSYiIWR72wObgXoxEgFCzq2siNfQ2974wOn4akTmYYGUlbdW4eC9VYMNcFj+duhTvK1VKbIprqrKD69C/JMp5nYFAOZKuUU483l1CEKZ6T87zwjNQj6ElpvWyveysdlxecTvxHKdk1LpSSpGIzK1kFaqxWWauREK37gxc9E/7M2rxxIDvhNaNBe3kKm/u7p0Uvr+hGpC5r54llyKmYgCR4k12v1KJyWWA8RGvvF0LKGYzics2K7EHQpdsI4sw8+i+Q+5V1d0Tt641SN+vnVcQ0buquFNdkG83JL8BKTy7F1cXYiP3/k9ddp0XlkyRBsyUl+5E6b+uT4zXbnR1TgdcsJFatX7IRszaUKcE+uFSwZ4t2qmdKJFnZKDz0X7dvNtGNO9tQMkr7suB84JBmqE1BGr2pYcqputkFY/JKlB2owXXPMElo13Yuo0xmXEnqxdaiIPL25qcz7q8lQQSRQxqjU6M5BsE4JsivwJTrdl+qPoAzPbrig/3X0clHl+IB2IKIWN5mRdCsFaXpY9zXoTJLu2ynvgRBd7xWAiYmG3bwDe4rExgN2jPQUXyC/DWP4OlfBtPuKYPZU+lGZ0uLBYcR1NKY71Hj1l/t8OW+D3zxwrYIpb+A3ppJvShgJsMFmozExF9knpqqJ91kSN+VE28ixpNlLavlml3F1/r0F5NIfeMqgqpuGk2Vrm4/fzoE8WeskzLpPDmYR6BvadniX4Miu2Qs+VSV3PW/IF8=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(36860700001)(70586007)(70206006)(26005)(186003)(16526019)(86362001)(8676002)(7696005)(5660300002)(4326008)(8936002)(15650500001)(40460700003)(47076005)(82310400004)(44832011)(6666004)(966005)(110136005)(1076003)(426003)(336012)(54906003)(356005)(2906002)(508600001)(316002)(81166007)(2616005)(45080400002)(83380400001)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 17:52:47.2160
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d2fc31c6-16d2-4c9f-68dd-08d9f6f54d42
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT028.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5200
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 59348401ebed ("platform/x86: amd-pmc: Add special handling for
timer based S0i3 wakeup") adds support for using another platform timer
in lieu of the RTC which doesn't work properly on some systems. This path
was validated and worked well before submission. During the 5.16-rc1 merge
window other patches were merged that caused this to stop working properly.

When this feature was used with 5.16-rc1 or later some OEM laptops with the
matching firmware requirements from that commit would shutdown instead of
program a timer based wakeup.

This was bisected to commit 8d89835b0467 ("PM: suspend: Do not pause
cpuidle in the suspend-to-idle path").  This wasn't supposed to cause any
negative impacts and also tested well on both Intel and ARM platforms.
However this changed the semantics of when CPUs are allowed to be in the
deepest state. For the AMD systems in question it appears this causes a
firmware crash for timer based wakeup.

It's hypothesized to be caused by the `amd-pmc` driver sending `OS_HINT`
and all the CPUs going into a deep state while the timer is still being
programmed. It's likely a firmware bug, but to avoid it don't allow setting
CPUs into the deepest state while using CZN timer wakeup path.

If later it's discovered that this also occurs from "regular" suspends
without a timer as well or on other silicon, this may be later expanded to
run in the suspend path for more scenarios.

Cc: stable@vger.kernel.org # 5.16+
Suggested-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://lore.kernel.org/linux-acpi/BL1PR12MB51570F5BD05980A0DCA1F3F4E23A9@BL1PR12MB5157.namprd12.prod.outlook.com/T/#mee35f39c41a04b624700ab2621c795367f19c90e
Fixes: 8d89835b0467 ("PM: suspend: Do not pause cpuidle in the suspend-to-idle path")
Fixes: 23f62d7ab25b ("PM: sleep: Pause cpuidle later and resume it earlier during system transitions")
Fixes: 59348401ebed ("platform/x86: amd-pmc: Add special handling for timer based S0i3 wakeup"
Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
---
changes from v2->v3:
 * Create a define for the latency value, and document it
 * Minor comment rewording
 * Add Rafael's tag

 drivers/platform/x86/amd-pmc.c | 42 ++++++++++++++++++++++++++--------
 1 file changed, 33 insertions(+), 9 deletions(-)

diff --git a/drivers/platform/x86/amd-pmc.c b/drivers/platform/x86/amd-pmc.c
index 4c72ba68b315..18b0f6ee65ce 100644
--- a/drivers/platform/x86/amd-pmc.c
+++ b/drivers/platform/x86/amd-pmc.c
@@ -21,6 +21,7 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/platform_device.h>
+#include <linux/pm_qos.h>
 #include <linux/rtc.h>
 #include <linux/suspend.h>
 #include <linux/seq_file.h>
@@ -85,6 +86,9 @@
 #define PMC_MSG_DELAY_MIN_US		50
 #define RESPONSE_REGISTER_LOOP_MAX	20000
 
+/* QoS request for letting CPUs in idle states, but not the deepest */
+#define AMD_PMC_MAX_IDLE_STATE_LATENCY	3
+
 #define SOC_SUBSYSTEM_IP_MAX	12
 #define DELAY_MIN_US		2000
 #define DELAY_MAX_US		3000
@@ -131,6 +135,7 @@ struct amd_pmc_dev {
 	struct device *dev;
 	struct pci_dev *rdev;
 	struct mutex lock; /* generic mutex lock */
+	struct pm_qos_request amd_pmc_pm_qos_req;
 #if IS_ENABLED(CONFIG_DEBUG_FS)
 	struct dentry *dbgfs_dir;
 #endif /* CONFIG_DEBUG_FS */
@@ -521,6 +526,14 @@ static int amd_pmc_verify_czn_rtc(struct amd_pmc_dev *pdev, u32 *arg)
 	rc = rtc_alarm_irq_enable(rtc_device, 0);
 	dev_dbg(pdev->dev, "wakeup timer programmed for %lld seconds\n", duration);
 
+	/*
+	 * Prevent CPUs from getting into deep idle states while sending OS_HINT
+	 * which is otherwise generally safe to send when at least one of the CPUs
+	 * is not in deep idle states.
+	 */
+	cpu_latency_qos_update_request(&pdev->amd_pmc_pm_qos_req, AMD_PMC_MAX_IDLE_STATE_LATENCY);
+	wake_up_all_idle_cpus();
+
 	return rc;
 }
 
@@ -538,24 +551,31 @@ static int __maybe_unused amd_pmc_suspend(struct device *dev)
 	/* Activate CZN specific RTC functionality */
 	if (pdev->cpu_id == AMD_CPU_ID_CZN) {
 		rc = amd_pmc_verify_czn_rtc(pdev, &arg);
-		if (rc < 0)
-			return rc;
+		if (rc)
+			goto fail;
 	}
 
 	/* Dump the IdleMask before we send hint to SMU */
 	amd_pmc_idlemask_read(pdev, dev, NULL);
 	msg = amd_pmc_get_os_hint(pdev);
 	rc = amd_pmc_send_cmd(pdev, arg, NULL, msg, 0);
-	if (rc)
+	if (rc) {
 		dev_err(pdev->dev, "suspend failed\n");
+		goto fail;
+	}
 
 	if (enable_stb)
 		rc = amd_pmc_write_stb(pdev, AMD_PMC_STB_PREDEF);
-	if (rc)	{
+	if (rc) {
 		dev_err(pdev->dev, "error writing to STB\n");
-		return rc;
+		goto fail;
 	}
 
+	return 0;
+fail:
+	if (pdev->cpu_id == AMD_CPU_ID_CZN)
+		cpu_latency_qos_update_request(&pdev->amd_pmc_pm_qos_req,
+						PM_QOS_DEFAULT_VALUE);
 	return rc;
 }
 
@@ -579,12 +599,15 @@ static int __maybe_unused amd_pmc_resume(struct device *dev)
 	/* Write data incremented by 1 to distinguish in stb_read */
 	if (enable_stb)
 		rc = amd_pmc_write_stb(pdev, AMD_PMC_STB_PREDEF + 1);
-	if (rc)	{
+	if (rc)
 		dev_err(pdev->dev, "error writing to STB\n");
-		return rc;
-	}
 
-	return 0;
+	/* Restore the QoS request back to defaults if it was set */
+	if (pdev->cpu_id == AMD_CPU_ID_CZN)
+		cpu_latency_qos_update_request(&pdev->amd_pmc_pm_qos_req,
+						PM_QOS_DEFAULT_VALUE);
+
+	return rc;
 }
 
 static const struct dev_pm_ops amd_pmc_pm_ops = {
@@ -722,6 +745,7 @@ static int amd_pmc_probe(struct platform_device *pdev)
 	amd_pmc_get_smu_version(dev);
 	platform_set_drvdata(pdev, dev);
 	amd_pmc_dbgfs_register(dev);
+	cpu_latency_qos_add_request(&dev->amd_pmc_pm_qos_req, PM_QOS_DEFAULT_VALUE);
 	return 0;
 
 err_pci_dev_put:
-- 
2.34.1

