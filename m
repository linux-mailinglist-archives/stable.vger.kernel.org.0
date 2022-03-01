Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C01E24C8219
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 05:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232210AbiCAESB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 23:18:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231749AbiCAESA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 23:18:00 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2061.outbound.protection.outlook.com [40.107.95.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A162D473A9
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 20:17:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a7C+44muDXTKs2DyKifNAlsdDGRTMyaSgZJobRH6VyimydgBuiAusQEbZX8+10fvLuA2CtP06UpRBADq6uxqv/oIFxDR70NwTVNTIkRihANmye6hz1dS6R+ghXeIGGr12jimyjCggrRIJ18414bC34PBFHCDi9vMIzWnDRgMoaBVuGKpv80RdEcjsT20Vqb8rwS7bOPQ0Nv6ObHxZbG+2b5KT4wv+xgZLB2DZuZsRU1Cbphb/UCTihQe3CaYfuGTwTcPQ7pSeBYa0cl8cs4u63QX+ZhIDKNFwJhokcil6YJezB485H2HUqLnBTDgl3CXvpRX7XSLh/4OiAYDtevqBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U6y8mqyyhWyqlJo2e4/XejuiGNB4xdDJ0j1WpeM3o+k=;
 b=Uz48IC4NoqRUgR+Kp4SDynt0haRpfiOW9i+wu/GslqEakaZ02qtnz/7+/xhwGacsqU2CttR1V3qCmxFEXkjrdfAv3NLGq876/Aae7XU7OgLXeIU7pKVld12/v/Po6JcLHV6gont8RQ4YrQcNpp/GCvO/ybkIFT4EfwBlZUVBpgNaN+ep7DsKGX+flGn/zkDAVdOiqkNJjPOboG5QyZsZkspnPQfstETIJ23AQI4EcxMoINgAuHS5uT6AWNcT3TBGO4egQcigRs4zMlPoo8kF/78obgM9HTpCIC4oeCb61be1sDDpGJ4k7NVr5pTXa3QvHYK/RLGvY5kfJPYZUoicEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U6y8mqyyhWyqlJo2e4/XejuiGNB4xdDJ0j1WpeM3o+k=;
 b=0qVrgfOsAOX7XqGrVQgV8HbZF2eKLybz8R4E/M/b0I5PR3oREKMc+qzyR41tZXR6Gfgwe8xQzwzX10RZPHhkSTzpISvjTMGHUnQuwC94ooB5kK/Xk2JqvU27wescmdp18n8ve4pesJdt+H6WY12hFhoKgM1mIMbXQDFu221mHuQ=
Received: from MWHPR07CA0017.namprd07.prod.outlook.com (2603:10b6:300:116::27)
 by BN9PR12MB5084.namprd12.prod.outlook.com (2603:10b6:408:135::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Tue, 1 Mar
 2022 04:17:17 +0000
Received: from CO1NAM11FT065.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:116:cafe::57) by MWHPR07CA0017.outlook.office365.com
 (2603:10b6:300:116::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21 via Frontend
 Transport; Tue, 1 Mar 2022 04:17:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT065.mail.protection.outlook.com (10.13.174.62) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5017.22 via Frontend Transport; Tue, 1 Mar 2022 04:17:16 +0000
Received: from localhost.localdomain (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Mon, 28 Feb
 2022 22:17:15 -0600
From:   Mario Limonciello <mario.limonciello@amd.com>
To:     <stable@vger.kernel.org>
CC:     Mario Limonciello <mario.limonciello@amd.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH] platform/x86: amd-pmc: Set QOS during suspend on CZN w/ timer wakeup
Date:   Mon, 28 Feb 2022 22:15:10 -0600
Message-ID: <20220301041510.1122030-1-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 61678031-48e4-4556-d56f-08d9fb3a5ee5
X-MS-TrafficTypeDiagnostic: BN9PR12MB5084:EE_
X-Microsoft-Antispam-PRVS: <BN9PR12MB50845EFBB252766F60BE4A92E2029@BN9PR12MB5084.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E82IweGU0JH3NjaivggH9bAyJ1pPlgxj2o+vV51gIdxIvWZKunu9BsWZb4cN4hWfFKXAdUfJgo1hBQRi2iOXKmc3GzFF5bvcRUUKKAPdAmesH5SVlBSRNLh83kjOHtqrAqZ/YtKzAm8wFy2QV5NCzr6G1pVGTfUWqQ+YX/vrSljbkX7B7p86hGaLZC0nZPzyNsJKUbCNgki35jVRozh+XvbWPPAMkE0kIfich0sOPr+eVbSBBFY8RRS/kig1oelLlGdKmNRrP4kMrTclGlTwIjKLiEaclNiO9wLCxHp+IARYGl/pGLOGSbmkrdTfR5NcorJykUay7N57vsj7718sQr7Q0CgtLBoBITkmGhkFEY1dwTLECrOH2cN74sh6dIDeQQWZlIWLVeYa3zEhyuzPYcfp2+lhRU+NLNYAXKMJIWf9bKoT3YLdqcymVfuZXldcpnLIeZyFpjyKSnml4/l6dVBMK+peYeTtGkxhJA4w0wtKy+wWh3fSFkI7UYOIonMySmaSIwVyWnTuGmzgeOg7XHdyk1iwbkIQRKdLILwqb6gjZ2Cglhzakwy3yyVEwPzvI067MU9rh5UagMrb8umpqR0Mg4uRfX5oO/3w099XJtvZZk/+dWHDPA1jIgGBPuxzJc45DpUsGu79bGrKqh/8gJsc0SL0nmtmVuHI4ZWfUjYhRmZFGYVDPoA7SbwMcvhSMOtwktYVJCHKlqyJCQCoDcsrFNpybt5B6lEfAHQiOy5+f+0385eGL4sO1aZacPO7DY/Q4F5mF2HOBuc1ALmtEi57y5/SY7LmDxbgUjCGWswYI8Q52mdBKdoevy9BpBS7/TuV1NDElBn3I8JgjcgNfw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(356005)(45080400002)(81166007)(6666004)(966005)(36756003)(83380400001)(36860700001)(47076005)(40460700003)(508600001)(54906003)(426003)(336012)(6916009)(44832011)(1076003)(86362001)(5660300002)(316002)(16526019)(186003)(26005)(82310400004)(70586007)(70206006)(8676002)(15650500001)(2906002)(4326008)(2616005)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2022 04:17:16.6712
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 61678031-48e4-4556-d56f-08d9fb3a5ee5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT065.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5084
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
Link: https://lore.kernel.org/r/20220223175237.6209-1-mario.limonciello@amd.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
(cherry picked from commit 68af28426b3ca1bf9ba21c7d8bdd0ff639e5134c)
---
This didn't apply cleanly to 5.16.y because 5.16.y doesn't contain the STB
feature.  Manually fixed up the commit for this.
This is *only* intended for 5.16.

 drivers/platform/x86/amd-pmc.c | 34 ++++++++++++++++++++++++++++++----
 1 file changed, 30 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/amd-pmc.c b/drivers/platform/x86/amd-pmc.c
index 8c74733530e3..11d0f829302b 100644
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
@@ -79,6 +80,9 @@
 #define PMC_MSG_DELAY_MIN_US		50
 #define RESPONSE_REGISTER_LOOP_MAX	20000
 
+/* QoS request for letting CPUs in idle states, but not the deepest */
+#define AMD_PMC_MAX_IDLE_STATE_LATENCY	3
+
 #define SOC_SUBSYSTEM_IP_MAX	12
 #define DELAY_MIN_US		2000
 #define DELAY_MAX_US		3000
@@ -123,6 +127,7 @@ struct amd_pmc_dev {
 	u8 rev;
 	struct device *dev;
 	struct mutex lock; /* generic mutex lock */
+	struct pm_qos_request amd_pmc_pm_qos_req;
 #if IS_ENABLED(CONFIG_DEBUG_FS)
 	struct dentry *dbgfs_dir;
 #endif /* CONFIG_DEBUG_FS */
@@ -459,6 +464,14 @@ static int amd_pmc_verify_czn_rtc(struct amd_pmc_dev *pdev, u32 *arg)
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
 
@@ -476,17 +489,24 @@ static int __maybe_unused amd_pmc_suspend(struct device *dev)
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
 
+	return 0;
+fail:
+	if (pdev->cpu_id == AMD_CPU_ID_CZN)
+		cpu_latency_qos_update_request(&pdev->amd_pmc_pm_qos_req,
+						PM_QOS_DEFAULT_VALUE);
 	return rc;
 }
 
@@ -507,7 +527,12 @@ static int __maybe_unused amd_pmc_resume(struct device *dev)
 	/* Dump the IdleMask to see the blockers */
 	amd_pmc_idlemask_read(pdev, dev, NULL);
 
-	return 0;
+	/* Restore the QoS request back to defaults if it was set */
+	if (pdev->cpu_id == AMD_CPU_ID_CZN)
+		cpu_latency_qos_update_request(&pdev->amd_pmc_pm_qos_req,
+						PM_QOS_DEFAULT_VALUE);
+
+	return rc;
 }
 
 static const struct dev_pm_ops amd_pmc_pm_ops = {
@@ -597,6 +622,7 @@ static int amd_pmc_probe(struct platform_device *pdev)
 	amd_pmc_get_smu_version(dev);
 	platform_set_drvdata(pdev, dev);
 	amd_pmc_dbgfs_register(dev);
+	cpu_latency_qos_add_request(&dev->amd_pmc_pm_qos_req, PM_QOS_DEFAULT_VALUE);
 	return 0;
 }
 
-- 
2.34.1

