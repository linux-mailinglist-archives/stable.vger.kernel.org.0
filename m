Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 619CF65DA2C
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239711AbjADQmU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:42:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239660AbjADQlz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:41:55 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2076.outbound.protection.outlook.com [40.107.100.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 709811AA09;
        Wed,  4 Jan 2023 08:41:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J6SV2o3DVYiQVK+vrgIkFNBJjufxGd7uo5eFiil7s36i4+iycHEzxkaF2a2rZqO+m+i8wVoTWCunR5m6ZnY+2uqIL+516qwubBwwCnQ0vEDwwEyAk/11eAA5iJazN2A8roPUibd8x2qZGrGcsoHhkP4gWa6Hk9uQYJTtavr+UL9u/FTM3HIKCjY+x6Mct6ZIy+96DZgZ98JUOP55xHrpf9i/5saeWIEGAV/vkJo6E+dvmsEY9pJltGT+8tbp0idKBEYEuxjz2ZYfKrPlviwhqgAHrh3XzyiifJbj8ALMnx+j70L8Nl8WvUH6YbbHU41tQkoOZ3OkJup47Ln97/1glQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m/W2v75+G03JpFiqlh+KJepaevNRkX/3FquwmPd1Y3Y=;
 b=nceH22RXZmJfe2vq7U40PchDMBE62DMtAnX89EXGBYzk+qXQaRx83AelXAa7e4jB2FKiPW5AzQPOMJHF7K2OLWkiG7jXIGT9DuMoZp0ldNiT5KzAAVclMpclqKGRvbR8C3WpQNqpoY098rkTpaIfrriI0XA0t9UAG6khJUlLTXyBkYVMSgTGLvkkRU6kdsWBNL5vxmJ3nOupO8tRV92rW2N0D3xALeatt1suPWqxBiAJcuTJjlBgbMKZF4nWbvPnTQb/dHmba/pealfcD4ij5/e9wLTroJvkSLkaRrJOLT+0040kSNDdz5fVX1szJbMYov4z1r9sDAhuq9i7vesyOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m/W2v75+G03JpFiqlh+KJepaevNRkX/3FquwmPd1Y3Y=;
 b=RurEih6XtkNF4aya0tcyR88LxbfwSwcsLQ7hAU8Q8Lr0IOzJeh8bOWBvgDjVqVHhIsVN/ttosyR1aAk4MnbyISy4qWac5bItD+spLQOtDpKEgjLbah5TJoTmwYjRNUCG73yqQa/tfG+PBujU7oCMb+5R2zVlgfaTDsowwGujAsc=
Received: from DS7PR03CA0307.namprd03.prod.outlook.com (2603:10b6:8:2b::13) by
 IA1PR12MB6411.namprd12.prod.outlook.com (2603:10b6:208:388::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Wed, 4 Jan
 2023 16:41:50 +0000
Received: from DS1PEPF0000E644.namprd02.prod.outlook.com
 (2603:10b6:8:2b:cafe::e5) by DS7PR03CA0307.outlook.office365.com
 (2603:10b6:8:2b::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.14 via Frontend
 Transport; Wed, 4 Jan 2023 16:41:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF0000E644.mail.protection.outlook.com (10.167.17.200) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5944.8 via Frontend Transport; Wed, 4 Jan 2023 16:41:50 +0000
Received: from AUS-LX-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 4 Jan
 2023 10:41:45 -0600
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
Subject: [PATCH v5 01/45] drm/amd: Delay removal of the firmware framebuffer
Date:   Wed, 4 Jan 2023 10:39:50 -0600
Message-ID: <20230104164042.30271-2-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230104164042.30271-1-mario.limonciello@amd.com>
References: <20230104164042.30271-1-mario.limonciello@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E644:EE_|IA1PR12MB6411:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d4e3923-978c-4986-cdff-08daee729427
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w/RbPgZE9so4v4lgNh6pc9rRK9wtfeF5Q3ECeexBNfWWRx9aqjReecVHCI9Oee82fxbtGxb8dXFlzLd7JHfFFAZje6nIltLPA8Nkb5996lsXmadkl5TDybjykiWTjQwP/AeoqI1XcK+9Cr23BSthWiVURelBzfHqZd7ROttIOKLBlWZOwpZFjVUAp2IGHotjI0bjBRdLFdUkjNlxeuKeN+FKSOAPO7MEqaXDrn0fykHywRHYTbNCRzweaMdPgi9K1CrQ2f92wMzzB7x8nDfR+WkWIXO3p8jumgn7Ho3WmpfL+3/G1vtoYKCYvvAs69EHOepvp4fjf4Q4j0gvihq7SWX5b2HcGFqH7ZLH5bmHwnsqO0j4E7v4W9UAmgZdwpdztoee5+MHnzDIZmaEZB04mmcapb5C7EfVnPT1TRic9VVSaR49cBZZB5Woqs+kdD3S899RVVcAExhfxnFyIe4a57fI7J3WX7KvSQAzOag73+FI1O8xK3k/yxH5Zr1mKXKNG+QC9pfdJ1HSg4xzIJS2f38r1rx3qCtFi1SXdIGe4oWt/WTlOloUUJBk3YBaL5XnUCIWk4SoPpaDETyJyBCOtj/Zytfm7cRtjQWd1NJkiuPjcPSs+dtek5UwPVy5U8UFjpDnLty2PRVNNQvuhzebHjKMefrqLGDRMYv+BYFZv+24xOhhuU7467bARhIcnBzmZU2RQpCNZoCDMslhpd7+xTREQ7OhDHHs3JUDqwZm3WE=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(136003)(376002)(396003)(451199015)(46966006)(36840700001)(40470700004)(83380400001)(426003)(47076005)(1076003)(16526019)(26005)(6666004)(336012)(82310400005)(7696005)(40480700001)(86362001)(40460700003)(36860700001)(36756003)(81166007)(82740400003)(356005)(2616005)(186003)(316002)(4326008)(478600001)(41300700001)(8676002)(2906002)(5660300002)(8936002)(44832011)(70586007)(54906003)(70206006)(110136005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2023 16:41:50.4884
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d4e3923-978c-4986-cdff-08daee729427
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E644.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6411
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
v4->v5:
 * no changes
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

