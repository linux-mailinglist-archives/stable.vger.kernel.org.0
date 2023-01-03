Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91F2365C943
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 23:19:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233682AbjACWTe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 17:19:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233335AbjACWTc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 17:19:32 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2073.outbound.protection.outlook.com [40.107.102.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C71C14037;
        Tue,  3 Jan 2023 14:19:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gvdI0FyWQgb6r+BfPBT1Wwt98ffNvgZ5H6bTbelVF8fkqqFi8LfTA4oh8Ushy1adFLVCMvYcdUeRcHfbiydcIkiscsX7gFZ/JEdyyC2tWUE4MIrY1K4kQUr2F+1oh0WUYSKjVUpxhp+mfn6wVntBMkFs+Ib6Kwn5F47XLK685fWpaPxRsRqbogyWKvzSMYwq/BkdGoATNXS0x8vLlFUe8ShMiCTzkpIGXCxL6JRK3uxdsO9/mCyU3b19j7fOu3NfFeur8WEfqfkY5tiwKzCKlSNEShzVXh+YsHrZQ26wLUG1eRRcg3px2F/2DOhP2cP9z3A/fXYDbIFzRR26+z3xng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZEBFDgYD/g52LWJ43EKRazYa6C3BX62CThMucEPHIxw=;
 b=T3p70t+LJ4Fc1tyCBp4NmpvbzLaTaZo6nTRtCUJHkam1waZsb4mdw2RUeuDOiPFPgdCsUCJpbWTgx4t/RStdM00BUxmEKg+YYoPHn9I+d60qIcXGlddoWenduZEkzQyUNZcD+XjFQHOVwYpb7mDOfQfKPW5HggbeM1iWSCgPs2CWQKH2LvHFOlAr22dxPb6L6tAP7MFAueALVBerbZS6NjKMUN0Y40Uo4fyXx5oOuHUZGTDV4YibAE0HykZfo7AW+Rx8Ys+fg3apzS9Akh4RB+G00MaLjP/jpcgY0ZbPCPZYTmoq1NYPsEo1IjhTudER6h1h82qBMF8aXABIxl3EmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZEBFDgYD/g52LWJ43EKRazYa6C3BX62CThMucEPHIxw=;
 b=2gPaJ7kEH6x5567lLV7bBYK7GHY7PS4T//cJ5fNwJpTGTNcYKpuGV3WVyAqAMrrWpQ7OKGUVV0XM/nlGKzDMe65rph/DaiIAIKRheyeXewQT2uau/hP0Y8/+NJVa92eYzLbePrg22DsIx62boIAGkIaYQtwyGTFLuDFHrp8X4ss=
Received: from DM6PR10CA0026.namprd10.prod.outlook.com (2603:10b6:5:60::39) by
 DS7PR12MB8292.namprd12.prod.outlook.com (2603:10b6:8:e2::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5944.19; Tue, 3 Jan 2023 22:19:28 +0000
Received: from DS1PEPF0000E654.namprd02.prod.outlook.com
 (2603:10b6:5:60:cafe::96) by DM6PR10CA0026.outlook.office365.com
 (2603:10b6:5:60::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5966.19 via Frontend
 Transport; Tue, 3 Jan 2023 22:19:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF0000E654.mail.protection.outlook.com (10.167.18.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5944.8 via Frontend Transport; Tue, 3 Jan 2023 22:19:27 +0000
Received: from AUS-LX-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 3 Jan
 2023 16:19:26 -0600
From:   Mario Limonciello <mario.limonciello@amd.com>
To:     Alex Deucher <alexander.deucher@amd.com>,
        <linux-kernel@vger.kernel.org>
CC:     Javier Martinez Canillas <javierm@redhat.com>,
        Carlos Soriano Sanchez <csoriano@redhat.com>,
        <amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
        David Airlie <airlied@gmail.com>,
        "Daniel Vetter" <daniel@ffwll.ch>, <christian.koenig@amd.com>,
        Lazar Lijo <Lijo.Lazar@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        <stable@vger.kernel.org>, "Pan, Xinhui" <Xinhui.Pan@amd.com>
Subject: [PATCH v4 01/27] drm/amd: Delay removal of the firmware framebuffer
Date:   Tue, 3 Jan 2023 16:18:20 -0600
Message-ID: <20230103221852.22813-2-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230103221852.22813-1-mario.limonciello@amd.com>
References: <20230103221852.22813-1-mario.limonciello@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E654:EE_|DS7PR12MB8292:EE_
X-MS-Office365-Filtering-Correlation-Id: 26522b20-592b-4624-215d-08daedd89422
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JJBHoLcPqIXmYzU8RE6X8B/G8Ll/ndZU5w2Am2LqKHBkpOMLyLcVysO5ekusySv8S2x1Pr/LsbVVtVfoL2YArmPhMTo2FSG0ev6CVM35ImRAc85RfQQcqNddEXBOTrMLGq0OfSuW/C8R7wVR2aF+wk5C7AsZi5BzuGVNadbWKEZitzyzVswmWZB95qFHjDMKaS2IHrHBDjOVFVBQoK7iw+6pD8IhjgQV56+EI3SmQmxZ7sveMPColnW5CbfDAFLaNVTsAHs2dTkXp/UPVfhEWo0uhllFMZULe5zs6nkBbOEc2oXfUFN+9T2tjkhYaojLFHozTmJfo+OYm+hgTiEmIQ3vAPEdnyianQhV7zE+J6mDOom1EaXF4poqhCzxDZU3rDPJUjNgiQ00LMRLLWFcKio+lV0Hnqo3WegyhVDxuy7G9evadkf09ZPYSvyNBM7j5EzsujoChb8NAVfCq0DhCvJBukeHFzDX2v2CSod1FMzmpX2aEFhr2kv5cgaGCPmef4cAgZtco1FPPsdxEpqI/VieHBb+Ax/ID+evFm65eHL1DGnW+L4FV58sWHgyexkac6FH8lwOiXWQtrwA9E8L5bZ/rO47mMLFLSxmQoVpDEOxRyjsy+YHMfAhtPN0SoG21eontJRfzJGUi2tRp5sZJ0RJ3gc6XfmbcunB5nfo6mZrN7doIj6hc/JzVz7Ipqr22+Dq+wFGjbU7nhItumsFGNHAMuRwLMNbjLlWl1Zq//Us9GZERqXKdTy8VHWqDynT
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(396003)(346002)(136003)(451199015)(36840700001)(40470700004)(46966006)(82310400005)(82740400003)(8676002)(36860700001)(8936002)(70586007)(4326008)(70206006)(41300700001)(5660300002)(86362001)(81166007)(83380400001)(356005)(1076003)(7696005)(2616005)(44832011)(316002)(110136005)(54906003)(2906002)(336012)(26005)(16526019)(40480700001)(47076005)(40460700003)(36756003)(186003)(478600001)(6666004)(426003)(22166009)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2023 22:19:27.9548
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 26522b20-592b-4624-215d-08daedd89422
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E654.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8292
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Removing the firmware framebuffer from the driver means that even
if the driver doesn't support the IP blocks in a GPU it will no
longer be functional after the driver fails to initialize.

This change will ensure that unsupported IP blocks at least cause
the driver to work with the EFI framebuffer.

Cc: stable@vger.kernel.org
Suggested-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
---
v3->v4:
 * Drop all R-b/A-b tags.
 * Move to after early IP init instead
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 8 ++++++++
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c    | 6 ------
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 9a1a5c2864a0..cdb681398a99 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -37,6 +37,7 @@
 #include <linux/pci-p2pdma.h>
 
 #include <drm/drm_atomic_helper.h>
+#include <drm/drm_aperture.h>
 #include <drm/drm_probe_helper.h>
 #include <drm/amdgpu_drm.h>
 #include <linux/vgaarb.h>
@@ -89,6 +90,8 @@ MODULE_FIRMWARE("amdgpu/navi12_gpu_info.bin");
 #define AMDGPU_MAX_RETRY_LIMIT		2
 #define AMDGPU_RETRY_SRIOV_RESET(r) ((r) == -EBUSY || (r) == -ETIMEDOUT || (r) == -EINVAL)
 
+static const struct drm_driver amdgpu_kms_driver;
+
 const char *amdgpu_asic_name[] = {
 	"TAHITI",
 	"PITCAIRN",
@@ -3685,6 +3688,11 @@ int amdgpu_device_init(struct amdgpu_device *adev,
 	if (r)
 		return r;
 
+	/* Get rid of things like offb */
+	r = drm_aperture_remove_conflicting_pci_framebuffers(adev->pdev, &amdgpu_kms_driver);
+	if (r)
+		return r;
+
 	/* Enable TMZ based on IP_VERSION */
 	amdgpu_gmc_tmz_set(adev);
 
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index db7e34eacc35..b9f14ec9edb2 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -23,7 +23,6 @@
  */
 
 #include <drm/amdgpu_drm.h>
-#include <drm/drm_aperture.h>
 #include <drm/drm_drv.h>
 #include <drm/drm_gem.h>
 #include <drm/drm_vblank.h>
@@ -2096,11 +2095,6 @@ static int amdgpu_pci_probe(struct pci_dev *pdev,
 	}
 #endif
 
-	/* Get rid of things like offb */
-	ret = drm_aperture_remove_conflicting_pci_framebuffers(pdev, &amdgpu_kms_driver);
-	if (ret)
-		return ret;
-
 	adev = devm_drm_dev_alloc(&pdev->dev, &amdgpu_kms_driver, typeof(*adev), ddev);
 	if (IS_ERR(adev))
 		return PTR_ERR(adev);
-- 
2.34.1

