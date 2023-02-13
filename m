Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8FAD695393
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 23:05:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbjBMWF6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 17:05:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbjBMWF5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 17:05:57 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2066.outbound.protection.outlook.com [40.107.94.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9236A1EBF7
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:05:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hANMT6cPEclwiJ3F0QDeuoEF9A1Jjvt5wSZodxVgUr4E3UtpZC4PwjRhs+cODTWG+n0eJ1/JUQKEJSbXFUwk5OqxieJtQV+Vz6fXu1YJ3G4Hc+AO7Y1SBncWT0yIG7a+4rXR75UEo2bpQVgBOOLFKU30ndFbdIJY7LXc4nxNdY6uztXMGORkNh4Tr4o3PcTuPlswc3nM6qZyzEJG/aDt7uCpRftAesgxvCipjTNnIA6XqfGUHen9zOFNaQghup/BKkV9JRVANjGEHRVtGsyTjF7Kip3eGFO7v7GBStLfyTvS0TQ1XM9BgAcbaTpRsXCg5za/bkOO8FjS+LC6iNBlaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u56K5DUWcIn6dPGUTACndxQgkDUjs9xo+UsNYOnly+o=;
 b=K/HBp7QEF446UaTRK9hi2ZC50j51rG6kPzY3JjwqVK5of5N3/r/2acsPK29YVTiO+EYpXzzGJY4dSCUms8Qo6+SKDUfKzY8IM87h9g30MX6LR+s78TKLVD02U/BxiThxGDonNjYmXYE38ydnoYiwcA5HKfjRMBK+k6HdPOH5gyPt4cdicgvBDh3Tgv+EYouPUTqzro4VKYJeiAUfuKcrHVSCzzgqtjsTMAPsGTlApi0K/k6z1KzjGKtWaVwm3NDl52Jcrq5TEHM5AvtSHnrISdu/OJnTeJgVDHcDzaZvpOYsU1sfixFfn14/MFWjq76HB2Nlg6M93/4w7BOTSrkCwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u56K5DUWcIn6dPGUTACndxQgkDUjs9xo+UsNYOnly+o=;
 b=b9/rZM8cjBhFcQRJNseZM2orMD/A+UlQv9JqHkCMbFedhHm6VSAypmbTUFHtIcfIkCZ/PuxDJLCpbc+WdnGzXqaa30k9Iv5deLTnXyCwqP1jfU9MV9uc1cB0JmhohKvdoaBAzWHbrlKGSmWDnB5bGnIhh53TYl3kK5TqU5yM604=
Received: from DM6PR02CA0152.namprd02.prod.outlook.com (2603:10b6:5:332::19)
 by DS0PR12MB6584.namprd12.prod.outlook.com (2603:10b6:8:d0::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.21; Mon, 13 Feb 2023 22:05:51 +0000
Received: from DS1PEPF0000E62F.namprd02.prod.outlook.com
 (2603:10b6:5:332:cafe::94) by DM6PR02CA0152.outlook.office365.com
 (2603:10b6:5:332::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24 via Frontend
 Transport; Mon, 13 Feb 2023 22:05:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF0000E62F.mail.protection.outlook.com (10.167.17.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6111.8 via Frontend Transport; Mon, 13 Feb 2023 22:05:51 +0000
Received: from AUS-LX-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 13 Feb
 2023 16:05:50 -0600
From:   Mario Limonciello <mario.limonciello@amd.com>
To:     <stable@vger.kernel.org>
CC:     Mario Limonciello <mario.limonciello@amd.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Xaver Hugl <xaver.hugl@gmail.com>,
        "Hans de Goede" <hdegoede@redhat.com>
Subject: [PATCH 5.15.y v2 4/4] platform/x86/amd: pmc: Disable IRQ1 wakeup for RN/CZN
Date:   Mon, 13 Feb 2023 16:05:37 -0600
Message-ID: <20230213220537.6534-5-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230213220537.6534-1-mario.limonciello@amd.com>
References: <20230213220537.6534-1-mario.limonciello@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E62F:EE_|DS0PR12MB6584:EE_
X-MS-Office365-Filtering-Correlation-Id: f05f6b13-9a7c-4dd2-af4d-08db0e0e7873
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T7V8wOH3LAPCYCSJ2r/QCWJcic1Oi7eY/ktFr399ZfjuCNhYlAHuc748LuULNNCtQMl0OltalrgTLmC4MpybzOFFplQmqWgf6ywD6eZfo1P6E0VJRrAWWExlihhxVavknq2v+bJZfSO/4LDi/rTTkWm/4xyVmT6kf3GvG8jqSLj8wDt/oAvu7/hP26ym5YB1gnhbidT5QYBpMYqRugI+DraVpsI2zXo4kaIqLQgrCa2euc43yeLaVCmAYR66LPcqy8wwStb0HeKfN2/VEWpMp62l7KqAX0CD3A4tuU53+HmFfj1QZHz1T7Gu7kgVpGLfJJ9SfrgEjG2yXWwoSROzbHG5fY163n8grDSLwKpJHWaROl/AnDkqGzcyTNDinb7LMUiE9Xktt+m4Gsws9Qg+8bv2eckCm0qop+0LX7NtKDiBU5R2Tflf+2VMNC4DIJljJGqgZhz5tVF4aZ2VVp93oL6Wln1vOrYQe0RyDnH2C7OlUuDK3fDKjPlAYmL9LjJJbm6MNfc54whIvxOmJrK73KbuRR+3JtmoPRYNQkj0esA1z1Wkhsf68UPvxh/GA5vrxK/zp1eCC77o6Wts6UkAxV55xCKQANMT2roOE6s0eX5rmnTY6Dsg7zCcWTPjsiOzuIjpAMqUsYeF2/vwCVfHidih2//C6VK47uYl6UIv4rFxVbkMS+fxxgFVWv9vtznBulg2S6BmH210xkijaIRkSc77r9tarHc83zNImrjgnD881rxDCqJidZAJwtEj28m6
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(346002)(136003)(376002)(451199018)(40470700004)(36840700001)(46966006)(83380400001)(336012)(426003)(47076005)(36756003)(82740400003)(478600001)(54906003)(7696005)(356005)(40480700001)(966005)(86362001)(316002)(82310400005)(36860700001)(40460700003)(81166007)(41300700001)(186003)(26005)(5660300002)(44832011)(16526019)(6666004)(8936002)(1076003)(2616005)(70586007)(70206006)(2906002)(8676002)(4326008)(6916009)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 22:05:51.5454
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f05f6b13-9a7c-4dd2-af4d-08db0e0e7873
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E62F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6584
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
This has been hand modified for missing dependency commits.
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/1921#note_1770257
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
---
 drivers/platform/x86/amd-pmc.c | 37 ++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/drivers/platform/x86/amd-pmc.c b/drivers/platform/x86/amd-pmc.c
index e6158d0f2ac3..83fea28bbb4f 100644
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
@@ -412,12 +413,48 @@ static int amd_pmc_get_os_hint(struct amd_pmc_dev *dev)
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

