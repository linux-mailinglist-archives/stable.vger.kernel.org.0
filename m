Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 079A8695392
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 23:05:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbjBMWF5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 17:05:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbjBMWFz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 17:05:55 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2071.outbound.protection.outlook.com [40.107.93.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5699C1F919
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:05:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cl4Vfgq01igpvY39oAk2h+bWGyka6iefBQCV8GECx+or2KjCfpGWyQAP5Vq9OjXpFWL26aG9T4Xv937O40ML5puPGSxCocIUV3O/Q0zfk0/qLpAO7KkylzMmAYF0v7LJNu0yLyT2HjlOqqEI09/P5vMo9yA5LesB+TIivmXXw/aS/PjRlchFEXV9Pfu6/X8CgHFqaJLj+gVbSXxyhFh5+UhzrWpkaZBf/NRbh9wbYqC1azfz6BxdgA61KN7dXZmJi0SzgWqsWHjxpAPlqWN0dBuOS+3Msa4j2v9Niwexb9/ATVfZyjid9HiId7k0amUMVt7ntZxhnfbOMUWed0rEzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DJNUAu+khc7ugjDLywQJ2BFh/XGMy/xhxp62k0X4P8I=;
 b=QtdpnYS0apx6Ch+N/paio391QYlf+6/Gw6Nhjez/UDeqbpjc9iIF2gxHTP4t56ND/OftrcxjLNXASxkTcpsCrSRCOFOVPVK3udYmLg85KXO5ddKLzVIHvaCMjYG9jIrlCQd2ZYBH+EBWiARqhxZa5dTvZGsmUp9DDYun90o+jAhah/atT1mGZe6t/KVm5l+MJ6yOMzvho6AARpTcNIScRYE3pTlCIdgebw+Q47NLv00JKYvKOh/AUwFm4mil07M7EBrFXNcfm/OKX4S5YrqmGf00DPe2ibIz5DPuSfIU4Cfrv6bLsIoDgDsAaGuZ9SvbNIV9c5Cilkc0KicNgL3gVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DJNUAu+khc7ugjDLywQJ2BFh/XGMy/xhxp62k0X4P8I=;
 b=v3iaulfR2NLAngY8Gcr8wHw/bso0deDiCr2iBd4fvvrvNsQ6MLSLaJsbhK1VFHX/7AlWB8f4C2rWCv8RNOYjYSppADQ9H6MX7QHV9nVEAjEbAbyssN5oWhWkby8QRet3kE8XX84Hpdep9Hg7KSZKX4nXGnkhfSEZdfy3HrSzC1Y=
Received: from DM6PR02CA0144.namprd02.prod.outlook.com (2603:10b6:5:332::11)
 by SJ0PR12MB8165.namprd12.prod.outlook.com (2603:10b6:a03:4e4::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Mon, 13 Feb
 2023 22:05:50 +0000
Received: from DS1PEPF0000E62F.namprd02.prod.outlook.com
 (2603:10b6:5:332:cafe::3c) by DM6PR02CA0144.outlook.office365.com
 (2603:10b6:5:332::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24 via Frontend
 Transport; Mon, 13 Feb 2023 22:05:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF0000E62F.mail.protection.outlook.com (10.167.17.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6111.8 via Frontend Transport; Mon, 13 Feb 2023 22:05:49 +0000
Received: from AUS-LX-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 13 Feb
 2023 16:05:48 -0600
From:   Mario Limonciello <mario.limonciello@amd.com>
To:     <stable@vger.kernel.org>
CC:     Sanket Goswami <Sanket.Goswami@amd.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5.15.y v2 1/4] platform/x86: amd-pmc: Export Idlemask values based on the APU
Date:   Mon, 13 Feb 2023 16:05:34 -0600
Message-ID: <20230213220537.6534-2-mario.limonciello@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E62F:EE_|SJ0PR12MB8165:EE_
X-MS-Office365-Filtering-Correlation-Id: cd0678ed-3b71-4498-5883-08db0e0e7779
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ofljV8Gb6DD2jBOb/u8wYpkGhI9zyzgRAkUYGg1fi33gLejAmxnBUXgPGdFIenvM7fW2RkDsH4/rNjbAjXRkBIo+xT29JgGHo/cR/LRam9nZg7KqBGTMBinUzfnKmXMPaPPeb/m+KuM9NzbaiP7ErpoNEQSLsyYU8ig+YJj9h/gG5gTUYOVUhMABDqsNch0A1eMN6uObSbekAJKgnQClrRq7/1VH0EurPcTIwEtmiu0R1/ZRZqYfka7Km0Dj3s2Z2EOnkhY1MVLGQ7IRBbcDoDz7e+fJFpHAQiZi5fNPEJQCHPIMIXcdZPggRAdSyjkbliwyu7tRB3drI+R83VjJKFymgJgLmlrjzXlKnCX0KKN0OgaL2bHrb8D/Sw/swU3bmyOg3gwONWLu6aWHBUtstVNJRy+95UfSKNBTUiPL3ZRGID5cmIF+UBqBatRbbynp9M40uEvvfED9p/LcAtliT56SCPoV5b7zIYJj7yTvu4d2Xrl6KaZjIjAC4Z8jBrEmzxpaKruVorB7WvoCcyi6oRaB1tHbadlJMRLlj04ApY6ibloHH6ljtWhjEf7SYgB8HBNP0YUn+tARSqRBTCrIS9S4VBzx9mGZQyk88QDh3ep0R5pjt9ijyOVmbHfGvQOS9W094W9JDkCYrRaFse3GeczR6hAJZP12kbuvyG7haTHZ2M08GZ2njqNXqzQNW/t5d8FasVOpLxDwUaIbhqgUr4swOzOt8kjRUP/yot0vUEXVO2OixeH+CmG6O5Km5m6YYZ5XUacTQ3EHVsRH+j64hg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(39860400002)(136003)(346002)(451199018)(36840700001)(40470700004)(46966006)(8936002)(36860700001)(1076003)(41300700001)(5660300002)(4326008)(6916009)(36756003)(81166007)(356005)(8676002)(70206006)(70586007)(86362001)(40460700003)(966005)(40480700001)(478600001)(336012)(2616005)(426003)(82740400003)(2906002)(316002)(6666004)(54906003)(26005)(82310400005)(7696005)(44832011)(47076005)(16526019)(83380400001)(186003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 22:05:49.9204
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cd0678ed-3b71-4498-5883-08db0e0e7779
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E62F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB8165
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sanket Goswami <Sanket.Goswami@amd.com>

IdleMask is the metric used by the PM firmware to know the status of each
of the Hardware IP blocks monitored by the PM firmware.

Knowing this value is key to get the information of s2idle suspend/resume
status. This value is mapped to PMC scratch registers, retrieve them
accordingly based on the CPU family and the underlying firmware support.

Co-developed-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Signed-off-by: Sanket Goswami <Sanket.Goswami@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20210916124002.2529-1-Sanket.Goswami@amd.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
(cherry picked from commit f6045de1f53268131ea75a99b210b869dcc150b2)
Although only part of the commit is required, full commit is backported
to allow for clearer backports in the future if needed.
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
---
 drivers/platform/x86/amd-pmc.c | 76 ++++++++++++++++++++++++++++++++++
 1 file changed, 76 insertions(+)

diff --git a/drivers/platform/x86/amd-pmc.c b/drivers/platform/x86/amd-pmc.c
index d3efd514614c..98283d8bef94 100644
--- a/drivers/platform/x86/amd-pmc.c
+++ b/drivers/platform/x86/amd-pmc.c
@@ -29,6 +29,10 @@
 #define AMD_PMC_REGISTER_RESPONSE	0x980
 #define AMD_PMC_REGISTER_ARGUMENT	0x9BC
 
+/* PMC Scratch Registers */
+#define AMD_PMC_SCRATCH_REG_CZN		0x94
+#define AMD_PMC_SCRATCH_REG_YC		0xD14
+
 /* Base address of SMU for mapping physical address to virtual address */
 #define AMD_PMC_SMU_INDEX_ADDRESS	0xB8
 #define AMD_PMC_SMU_INDEX_DATA		0xBC
@@ -110,6 +114,10 @@ struct amd_pmc_dev {
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
@@ -201,6 +209,66 @@ static int s0ix_stats_show(struct seq_file *s, void *unused)
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
+static int amd_pmc_idlemask_read(struct amd_pmc_dev *pdev, struct device *dev,
+				 struct seq_file *s)
+{
+	u32 val;
+
+	switch (pdev->cpu_id) {
+	case AMD_CPU_ID_CZN:
+		val = amd_pmc_reg_read(pdev, AMD_PMC_SCRATCH_REG_CZN);
+		break;
+	case AMD_CPU_ID_YC:
+		val = amd_pmc_reg_read(pdev, AMD_PMC_SCRATCH_REG_YC);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (dev)
+		dev_dbg(pdev->dev, "SMU idlemask s0i3: 0x%x\n", val);
+
+	if (s)
+		seq_printf(s, "SMU idlemask : 0x%x\n", val);
+
+	return 0;
+}
+
+static int amd_pmc_idlemask_show(struct seq_file *s, void *unused)
+{
+	struct amd_pmc_dev *dev = s->private;
+	int rc;
+
+	if (dev->major > 56 || (dev->major >= 55 && dev->minor >= 37)) {
+		rc = amd_pmc_idlemask_read(dev, NULL, s);
+		if (rc)
+			return rc;
+	} else {
+		seq_puts(s, "Unsupported SMU version for Idlemask\n");
+	}
+
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(amd_pmc_idlemask);
+
 static void amd_pmc_dbgfs_unregister(struct amd_pmc_dev *dev)
 {
 	debugfs_remove_recursive(dev->dbgfs_dir);
@@ -213,6 +281,8 @@ static void amd_pmc_dbgfs_register(struct amd_pmc_dev *dev)
 			    &smu_fw_info_fops);
 	debugfs_create_file("s0ix_stats", 0644, dev->dbgfs_dir, dev,
 			    &s0ix_stats_fops);
+	debugfs_create_file("amd_pmc_idlemask", 0644, dev->dbgfs_dir, dev,
+			    &amd_pmc_idlemask_fops);
 }
 #else
 static inline void amd_pmc_dbgfs_register(struct amd_pmc_dev *dev)
@@ -349,6 +419,8 @@ static int __maybe_unused amd_pmc_suspend(struct device *dev)
 	amd_pmc_send_cmd(pdev, 0, NULL, SMU_MSG_LOG_RESET, 0);
 	amd_pmc_send_cmd(pdev, 0, NULL, SMU_MSG_LOG_START, 0);
 
+	/* Dump the IdleMask before we send hint to SMU */
+	amd_pmc_idlemask_read(pdev, dev, NULL);
 	msg = amd_pmc_get_os_hint(pdev);
 	rc = amd_pmc_send_cmd(pdev, 1, NULL, msg, 0);
 	if (rc)
@@ -371,6 +443,9 @@ static int __maybe_unused amd_pmc_resume(struct device *dev)
 	if (rc)
 		dev_err(pdev->dev, "resume failed\n");
 
+	/* Dump the IdleMask to see the blockers */
+	amd_pmc_idlemask_read(pdev, dev, NULL);
+
 	return 0;
 }
 
@@ -458,6 +533,7 @@ static int amd_pmc_probe(struct platform_device *pdev)
 	if (err)
 		dev_err(dev->dev, "SMU debugging info not supported on this platform\n");
 
+	amd_pmc_get_smu_version(dev);
 	platform_set_drvdata(pdev, dev);
 	amd_pmc_dbgfs_register(dev);
 	return 0;
-- 
2.34.1

