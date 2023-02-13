Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48FC2695391
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 23:05:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbjBMWF4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 17:05:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbjBMWFz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 17:05:55 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on20604.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::604])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D4A51EBF7
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:05:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aC5ihNha4s5wNq0UHd5OFfglpkYl0vvrQUvB3q0IhQ8ipnsP7mHcstx8fKWh5R0sU8ds28SgJ0aIUPByRNUbiW0kiPOmthraWZRZ9iBl7JV49EyZ8qUTkYxIdRygAav9IZw+SX3apOKkYbs8N8mr2f2UqyXSbIczGME11/DT4ZO7gGl2AoYHZ/hh5gJtyFgxkD9zgyhZD5alndeZok2FDGYoALfMn65uibr47TINfqvJtTJ7cuzEsOnbBG+9DwGXI6NnPdW4fPfSdnTN67Cvaz24fcqtIKrGjHtHHbpUarcZw3j6yFsR5InJbA43h/HBg1WwhVv89GD7J1Y0qr4gLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K0Pa0YFlkF+0GwblmNac9+DK3g9Dy5xd5nOgamCpqMA=;
 b=Ov1ReadN54xeEkm+t8dn3jAPdXzPcMXMjxyHr9w1+qGRWAQqYlHkJ7nHfC7ID4UYRuYd9kJpsx8w3MxA2JAdLU0DgHfHDBDqsGR3oycYJu7zT+NBPKNzYIqDt7hNPjSVR9ZOHZM1q7I/UuVLluQvWPSRdoYAxQewrDBmO9W2Rcw+wt0q2deLEr6S9Mu+8kXh0pJIhNTiOk2s7KDa7ZQbVdnSz6XH8ravCvn/nlfWFz6Pjuak0T61dDj2euaYdshntNetQGcQzrEnQnXjM9GQok3QKxla6hXP0KDBG/MmaRrVdWUWtouRawjESc2QT2bGJcq1lb96v9mPLOkelsDBgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K0Pa0YFlkF+0GwblmNac9+DK3g9Dy5xd5nOgamCpqMA=;
 b=n3GTW4A4CvbC2k4DXu2rvb3X85AbX7jZC4hOq3gDvq9E8zbHR4Ve4oB2oecW3cq9vq3ptE/55UhDWwfOnui+JQWfAFEqHWcewHns4R6MnsPX3eO6IExMtd902TYoqkCg6Sv54rwke2WXiXRDyYkoKZUvkjEUy0nntS+OXrrmiLU=
Received: from DM6PR02CA0148.namprd02.prod.outlook.com (2603:10b6:5:332::15)
 by BY5PR12MB4148.namprd12.prod.outlook.com (2603:10b6:a03:208::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Mon, 13 Feb
 2023 22:05:50 +0000
Received: from DS1PEPF0000E62F.namprd02.prod.outlook.com
 (2603:10b6:5:332:cafe::15) by DM6PR02CA0148.outlook.office365.com
 (2603:10b6:5:332::15) with Microsoft SMTP Server (version=TLS1_2,
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
 15.20.6111.8 via Frontend Transport; Mon, 13 Feb 2023 22:05:50 +0000
Received: from AUS-LX-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 13 Feb
 2023 16:05:49 -0600
From:   Mario Limonciello <mario.limonciello@amd.com>
To:     <stable@vger.kernel.org>
CC:     Hans de Goede <hdegoede@redhat.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Sanket Goswami <Sanket.Goswami@amd.com>,
        "Nathan Chancellor" <nathan@kernel.org>,
        Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 5.15.y v2 2/4] platform/x86: amd-pmc: Fix compilation when CONFIG_DEBUGFS is disabled
Date:   Mon, 13 Feb 2023 16:05:35 -0600
Message-ID: <20230213220537.6534-3-mario.limonciello@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E62F:EE_|BY5PR12MB4148:EE_
X-MS-Office365-Filtering-Correlation-Id: adac5280-3a8f-4b83-0611-08db0e0e77c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MB1xvKlWiQ3SqzUiXWBOkl465ktvuDgTRFmrY/e1xRMw723yGc+AjZdjrYgx3Awf8FusX/rPwqew9nFdXFDackil66Dq3NO1r76cJQFESTfmvDJV/fsuezx2k328PIspoCgiNZG3hMPhkMwzFAtz4o02salwF69rceCfs+jWmQBqV1odIzAJ296HnsJ1yrxx0r1js60J2jAFYBUnBDY4ysmq+Zas0qr8/BbO2z3qxFbfeP8CIIxGUPZ+mY6a15d1vd06gk1i/ICev5+/v7gtduh5GjQNbRpjTIAmbTcQZEGwuNGbZfhIDAWGEDxxYGmsoUugvii4WTOtBkh0+deTxb3LPVwM3ebSCEzvt1c+TmPL6d+f1H7DfMl22+mPh+klisdmi272XVgfSvz66aTIlhtmFiGrEgQrwnjYMV0NWl1/GSIgqC4WIVd0kHZXTZHYJi1UFah0dELKEnh43UfSnxwdRyRwBom2fpZWge8FIcECE4IAoWztuKM8JC9LU9GPtRix2S+ekICMgQy/wC2pqn8dHAeNUSpR4mD7E74SC2TTcVSydB2zZV+k42arNVNULCtgGuaumWEiFLg1HAu4xmqG4UDZNwx/WvDKBMTFN07iG02+XOIINag2GQ3wBA4nd1GkjcWPrPlZmVJfMz6sKjxtNbw43IAvA4KvtjLgtcjvu2SsR9HWZ+DmRE3pNraMvu1TZ8oUoT6unKHzn6Klm/6TsWkmPh54s0NLE8ogVpI=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(39860400002)(376002)(136003)(451199018)(46966006)(40470700004)(36840700001)(40460700003)(54906003)(83380400001)(316002)(70586007)(70206006)(8936002)(5660300002)(4326008)(8676002)(6916009)(2616005)(41300700001)(6666004)(1076003)(478600001)(16526019)(186003)(26005)(426003)(47076005)(336012)(7696005)(356005)(36756003)(40480700001)(82310400005)(86362001)(36860700001)(2906002)(44832011)(81166007)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 22:05:50.4204
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: adac5280-3a8f-4b83-0611-08db0e0e77c8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E62F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4148
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

The amd_pmc_get_smu_version() and amd_pmc_idlemask_read() functions are
used in the probe / suspend/resume code, so they are also used when
CONFIG_DEBUGFS is disabled, move them outside of the #ifdef CONFIG_DEBUGFS
block.

Note this purely moves the code to above the #ifdef CONFIG_DEBUGFS,
the code is completely unchanged.

Fixes: f6045de1f532 ("platform/x86: amd-pmc: Export Idlemask values based on the APU")
Cc: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Cc: Sanket Goswami <Sanket.Goswami@amd.com>
Reported-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
(cherry picked from commit 40635cd32f0d83573a558dc30e9ba3469e769249)
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
---
 drivers/platform/x86/amd-pmc.c | 86 +++++++++++++++++-----------------
 1 file changed, 43 insertions(+), 43 deletions(-)

diff --git a/drivers/platform/x86/amd-pmc.c b/drivers/platform/x86/amd-pmc.c
index 98283d8bef94..67bc3079cdce 100644
--- a/drivers/platform/x86/amd-pmc.c
+++ b/drivers/platform/x86/amd-pmc.c
@@ -155,6 +155,49 @@ struct smu_metrics {
 	u64 timecondition_notmet_totaltime[SOC_SUBSYSTEM_IP_MAX];
 } __packed;
 
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
 #ifdef CONFIG_DEBUG_FS
 static int smu_fw_info_show(struct seq_file *s, void *unused)
 {
@@ -209,49 +252,6 @@ static int s0ix_stats_show(struct seq_file *s, void *unused)
 }
 DEFINE_SHOW_ATTRIBUTE(s0ix_stats);
 
-static int amd_pmc_get_smu_version(struct amd_pmc_dev *dev)
-{
-	int rc;
-	u32 val;
-
-	rc = amd_pmc_send_cmd(dev, 0, &val, SMU_MSG_GETSMUVERSION, 1);
-	if (rc)
-		return rc;
-
-	dev->major = (val >> 16) & GENMASK(15, 0);
-	dev->minor = (val >> 8) & GENMASK(7, 0);
-	dev->rev = (val >> 0) & GENMASK(7, 0);
-
-	dev_dbg(dev->dev, "SMU version is %u.%u.%u\n", dev->major, dev->minor, dev->rev);
-
-	return 0;
-}
-
-static int amd_pmc_idlemask_read(struct amd_pmc_dev *pdev, struct device *dev,
-				 struct seq_file *s)
-{
-	u32 val;
-
-	switch (pdev->cpu_id) {
-	case AMD_CPU_ID_CZN:
-		val = amd_pmc_reg_read(pdev, AMD_PMC_SCRATCH_REG_CZN);
-		break;
-	case AMD_CPU_ID_YC:
-		val = amd_pmc_reg_read(pdev, AMD_PMC_SCRATCH_REG_YC);
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	if (dev)
-		dev_dbg(pdev->dev, "SMU idlemask s0i3: 0x%x\n", val);
-
-	if (s)
-		seq_printf(s, "SMU idlemask : 0x%x\n", val);
-
-	return 0;
-}
-
 static int amd_pmc_idlemask_show(struct seq_file *s, void *unused)
 {
 	struct amd_pmc_dev *dev = s->private;
-- 
2.34.1

