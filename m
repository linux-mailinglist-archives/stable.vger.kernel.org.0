Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D57F4EA4C6
	for <lists+stable@lfdr.de>; Tue, 29 Mar 2022 03:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbiC2Bvt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 21:51:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbiC2Bvs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 21:51:48 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2081.outbound.protection.outlook.com [40.107.100.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ABA03B03F
        for <stable@vger.kernel.org>; Mon, 28 Mar 2022 18:50:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RdutMdNJHxTm2VCcC1UGdmPhOiwHO+BIdOq2CSTt9LounOYuHjArunZo+lPQaJFVSoeaKcmh6rjs5tKDBjPb3d0u9ld+trCTANQh+3Stq9+SLMIPnSz22o75SC12kEZFP89vA/4jMsgW0m6xVsyh3aMxF1j2hTSGig/d1LssB0LorfQMJ0z6kz3FO7QcFTnfQ1JkFoLVTMhOyq84pP+HzhY0BJeYMtptDgdU4tefXbL3XRPnKBXSi3Rx7GePHY5RSCJRbA/JF5Lm7kz4/x8RX5oGSyGTlA+5XiQxH0Qc7E9ag4PWn040gyO4KMhPR0I8H5c1pUhEpoHnfiDW7nElcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XCmOrmpRPi/GNXoXew+wAqVqAKYhKoCt8Sr9pGz04hA=;
 b=QbuscaCYA6CFIZa07BZLiZjb3B/BoweffRJwn/V6D0i4NETMJn5z11GGz/Cl7V65B0zJLJRdJ8oUT1tJ9ja9KI7sxE3Mqt+Piy/HxctZeDqu0t9KYiXxsjGEt++1RNcqZCvBo/vqLDpy8o+xPphXJGpqX29syno1+tOLtYKVWpfyuKWwaKF7DHhUmsmi8D7IyTHThaxzvQ64G8gLh7JF4Sc7PFOI8PEY+SLIAsABv3+Mr5pRNelDZtaNLTpNc7JLml4NPxRTY2W2vgeAcfRoCKMSnj0nm3w5l8OTOfBZPrw/10QBMeIY5uJt639Sp6OudFSZM6iY2nm1sEwckjwHug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XCmOrmpRPi/GNXoXew+wAqVqAKYhKoCt8Sr9pGz04hA=;
 b=QfQXOIFBfTiTSogZ4x3xFG1Tv2+VhV7IGly1l9b6tyMg+nyS1Jz30YKltjEkzCablGlzTkStLAaSThdGVMwSzKrDzA2VWZv1S+8xLes8Buz8b8jdOvtcPjYw7yRoykmjh9yaQU0nQeOuuJIt3kTFnlXwHLVl7VgC5IvqjoJqgqE=
Received: from BN6PR19CA0069.namprd19.prod.outlook.com (2603:10b6:404:e3::31)
 by DM4PR12MB5342.namprd12.prod.outlook.com (2603:10b6:5:39f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.17; Tue, 29 Mar
 2022 01:50:04 +0000
Received: from BN8NAM11FT036.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:e3:cafe::8) by BN6PR19CA0069.outlook.office365.com
 (2603:10b6:404:e3::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.23 via Frontend
 Transport; Tue, 29 Mar 2022 01:50:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT036.mail.protection.outlook.com (10.13.177.168) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5102.17 via Frontend Transport; Tue, 29 Mar 2022 01:50:03 +0000
Received: from AUS-LX-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Mon, 28 Mar
 2022 20:49:58 -0500
From:   Mario Limonciello <mario.limonciello@amd.com>
To:     <stable@vger.kernel.org>
CC:     <mpearson@lenovo.com>, <Richard.Gong@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Evan Quan <evan.quan@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 1/2] drm/amdgpu: move PX checking into amdgpu_device_ip_early_init
Date:   Mon, 28 Mar 2022 20:49:51 -0500
Message-ID: <20220329014952.471-1-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d78d593e-d5b8-444e-d950-08da1126719b
X-MS-TrafficTypeDiagnostic: DM4PR12MB5342:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB5342A2FF3D9DB75E85FA6E0DE21E9@DM4PR12MB5342.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nRsviXDDna2UtJap8TkIUfEtoRHnHkOJuqp76HA/RZtpOyw0GXrWNeHYNQH1k+L5/OJdWAImGoHNMqELODxXzhyK4corOOEJlg25LKgj8lwYLUBlbnVB91eW2Dmv49FIpg/hIFLEjgvhJaedD9E+izRPa73TD8Nf3TsilcAwSV1QpfLuiGXhsRCKHeoUtJl6x3D2zr5yXpfAZW2o5xs8RgTb6z9xq5X026IP/FTR7ESCRHJLOEFJuaC3v+01yKGkp2D1vqOLoNL6ejC2Y7iZoMnMuGTYaOwxc8DxuV2Jwx+3KK8viJkjvHXgQSsjock/ZfjoUvPx/V3NaTjhDiZG9ZuD/Q1eN+2AyrC0NcxBKgiIzqC5UbiT2056LLUjxYIkDz5HKtuiViC10Nbh/SqmTcFqDJYHrPcubiMmqXUHyzoEpObQy1XyTifEZfwciyKL5o87jHRpPubOb9INcJJl3B3ACoXWNwkSnMKvLvesk/XpA+VZI/S7vqbxSfyEshOHNLzuqdzCorpSllzwNd1nZHx+G42rC0dnGbSWUtM4x6bRFF7QlF15bbkshkI7kWKOaczjLaVM2tIiaIvnzRoc5ve47I6zSDzE+vsrD3zszkW9SOqXb3HSxYy7qBK1nQ7tlri1/Po+XBmq+QGhWyPmOzafI1v+2L85OkeqtTjxwG9/Z15A9+DQ+XDxtmfYcgXa3bcBnieJupAHTdM8zmJmiA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(84040400005)(46966006)(40470700004)(36840700001)(81166007)(36860700001)(6916009)(8676002)(4326008)(2616005)(426003)(336012)(186003)(26005)(316002)(86362001)(508600001)(70206006)(1076003)(70586007)(54906003)(356005)(2906002)(82310400004)(44832011)(5660300002)(36756003)(16526019)(47076005)(7696005)(6666004)(8936002)(40460700003)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2022 01:50:03.8033
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d78d593e-d5b8-444e-d950-08da1126719b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT036.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5342
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

We need to set the APU flag from IP discovery before
we evaluate this code.

Acked-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 901e2be20dc55079997ea1885ea77fc72e6826e7)

Modified nearby headers in 5.16.y/5.15.y since matching header changes
didn't happen yet.

Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
---
Please apply to both 5.15.y and 5.16.y.

 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 13 +++++++++++++
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c    | 11 -----------
 2 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 694c3726e0f4..ea3af6f59ca4 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -30,6 +30,7 @@
 #include <linux/module.h>
 #include <linux/console.h>
 #include <linux/slab.h>
+#include <linux/pci.h>
 
 #include <drm/drm_atomic_helper.h>
 #include <drm/drm_probe_helper.h>
@@ -2070,6 +2071,8 @@ static int amdgpu_device_parse_gpu_info_fw(struct amdgpu_device *adev)
  */
 static int amdgpu_device_ip_early_init(struct amdgpu_device *adev)
 {
+	struct drm_device *dev = adev_to_drm(adev);
+	struct pci_dev *parent;
 	int i, r;
 
 	amdgpu_device_enable_virtual_display(adev);
@@ -2134,6 +2137,16 @@ static int amdgpu_device_ip_early_init(struct amdgpu_device *adev)
 		break;
 	}
 
+	if (amdgpu_has_atpx() &&
+	    (amdgpu_is_atpx_hybrid() ||
+	     amdgpu_has_atpx_dgpu_power_cntl()) &&
+	    ((adev->flags & AMD_IS_APU) == 0) &&
+	    !pci_is_thunderbolt_attached(to_pci_dev(dev->dev)))
+		adev->flags |= AMD_IS_PX;
+
+	parent = pci_upstream_bridge(adev->pdev);
+	adev->has_pr3 = parent ? pci_pr3_present(parent) : false;
+
 	amdgpu_amdkfd_device_probe(adev);
 
 	adev->pm.pp_feature = amdgpu_pp_feature_mask;
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
index 09ad17944eb2..704702fef257 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
@@ -152,21 +152,10 @@ static void amdgpu_get_audio_func(struct amdgpu_device *adev)
 int amdgpu_driver_load_kms(struct amdgpu_device *adev, unsigned long flags)
 {
 	struct drm_device *dev;
-	struct pci_dev *parent;
 	int r, acpi_status;
 
 	dev = adev_to_drm(adev);
 
-	if (amdgpu_has_atpx() &&
-	    (amdgpu_is_atpx_hybrid() ||
-	     amdgpu_has_atpx_dgpu_power_cntl()) &&
-	    ((flags & AMD_IS_APU) == 0) &&
-	    !pci_is_thunderbolt_attached(to_pci_dev(dev->dev)))
-		flags |= AMD_IS_PX;
-
-	parent = pci_upstream_bridge(adev->pdev);
-	adev->has_pr3 = parent ? pci_pr3_present(parent) : false;
-
 	/* amdgpu_device_init should report only fatal error
 	 * like memory allocation failure or iomapping failure,
 	 * or memory manager initialization failure, it must
-- 
2.34.1

