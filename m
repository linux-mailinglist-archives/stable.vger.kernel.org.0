Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D468B658248
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:34:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234795AbiL1QeV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:34:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234884AbiL1Qdo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:33:44 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2050.outbound.protection.outlook.com [40.107.92.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FC981C422;
        Wed, 28 Dec 2022 08:31:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HRvKj2Y2xU80pP2N8FX2Brxkw/nFtJXlQANdePCo8O4f+SscPCdQKF6mrPm3fQrBmIUsJNZ+uQolX+AZBM8o/tYdDjhsOkjZb/9GUFkP6A8H6wzniVlMpG8M9lGDT0gSsMWv6WZfYPXTmG1SYS11cBvJA7aWnRvxYKHQTHnJUnxoqbN8vDFtOGzwYapV/ObfOm7HiPcx7hrQ+PqhCtn3hUcKJcZeMjHWHopjBgSwCN8DhpNVf1qZCLNeJbMYtxcvDDMGou8FEGraBSsUSxxjYWKAUdwH8OLinLsIcKIll+qalIpw0nKb7CgiNU1hL78eLqwM3k9qHNXYHRL9qKf8qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3TZHV2AKS8NtkzB2OMhyt5+RyFvGI1SgBVmjItlq+D0=;
 b=Q/OxzqGMokUsZA8JkE720eAilQ5FA+PWyfpU8fxxlH1LFklUnIXZX3Il+AdJS+UpOntmaTx0S9H7mxUtz7QbQRgV4FPonrqMwKCKKApn8v/EFRE5pG6pXszMzOHF6am51EE+GTfdNSKdk2tSKV3MDIQDqPJ6XJHtjhUWXeB50U2aieuJtrE6wevVOZwoCWLkYh/QcEfSpY98sEs9hgrl12u32nONfIqzkMhGRVmWmeegDaoDd4eVtiprf2m2Tyv7Qtnfm+bV7eqcHX1YCXHyInaurXlijY5eOD4BxC1UKwgO2wPYU9lePHdk1/SeyyvwxSQ1jVp2T6Uygjttq7IUvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3TZHV2AKS8NtkzB2OMhyt5+RyFvGI1SgBVmjItlq+D0=;
 b=gyzKeqi8lCrN5FXRDZRPEKT1j47dV5j8xZ4wmxvWYledlRuI9WCGUbFLYdi4Mx/sBMpkhfu+wf6TvGUX9SKUqofq2Z+NSDsgor2XwoftipP5wCMAU6M00kqcVmxfjwzgYdlIOwUuHkvyjPmk3tgRPC5iJdW2dfx4qp7P/B9G/kI=
Received: from MW4PR03CA0073.namprd03.prod.outlook.com (2603:10b6:303:b6::18)
 by SJ1PR12MB6193.namprd12.prod.outlook.com (2603:10b6:a03:459::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.14; Wed, 28 Dec
 2022 16:31:15 +0000
Received: from CO1NAM11FT089.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b6:cafe::50) by MW4PR03CA0073.outlook.office365.com
 (2603:10b6:303:b6::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5966.17 via Frontend
 Transport; Wed, 28 Dec 2022 16:31:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT089.mail.protection.outlook.com (10.13.175.179) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5966.18 via Frontend Transport; Wed, 28 Dec 2022 16:31:15 +0000
Received: from AUS-LX-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 28 Dec
 2022 10:31:14 -0600
From:   Mario Limonciello <mario.limonciello@amd.com>
To:     Javier Martinez Canillas <javierm@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        <linux-kernel@vger.kernel.org>
CC:     Carlos Soriano Sanchez <csoriano@redhat.com>,
        <amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
        "David Airlie" <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>, <christian.koenig@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        <stable@vger.kernel.org>, Alex Deucher <alex.deucher@amd.com>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>
Subject: [PATCH v2 01/11] drm/amd: Delay removal of the firmware framebuffer
Date:   Wed, 28 Dec 2022 10:30:48 -0600
Message-ID: <20221228163102.468-2-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221228163102.468-1-mario.limonciello@amd.com>
References: <20221228163102.468-1-mario.limonciello@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT089:EE_|SJ1PR12MB6193:EE_
X-MS-Office365-Filtering-Correlation-Id: 09b82481-d060-4c61-4d46-08dae8f0f0b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E1DAYOdMvQv6rAFpJ6eej7/g5KU7yLa7ZjvMeXYuV3kwjg6ZubJa78tsYLWB8/RfDNBasw1poPCQSoQLELUqgzfcUlSZxQQ3o2IXC5T1GpI6bwE+DYQz2YWXErjk5pfwT5YGUPyQBLjpPL+/mUHd+D9YGTWU4SJoC3TQdy+VQS/C7/+qAlnq495Wtz9mEn9sf/a4ue0GDJWh9EGZ/kxeqHA31031xgFEDf+H/A3EGw2LVUfbyoyIsPNVDfwpgQvCkMm52cQ+hkofqgtKW7TBRn0Cc4qCUwqyCd1s/8eu0U8KfurdfWL0RM73WNEc97bmc2fiIcYP9cz05boRZs4N94ExhsUeXhwkxItYFpJ0o8ikkgz0eQQu3XGrHYMgkeI6yJUATtBdnJYuq/NoBsHTmzw+fGmPC3p7nVUDX3xjeKbUF/Pr2Fs2Ld5Yjch8kx7IChOure7n6bhBEBUO3wAx5U/cP/sJyyM7qshzTV7HsoL2D1x017Ak4TFNrBOvlu2YhFgaQ1MS91s88wJ8qdHecdaY1zYYSdIWsq+wwnz96C3TgCWQnvZbPc4IUmQ8ZKzk5lno9SV/KSD2jF56+q4MzV5UZh76Ckdrl3nwLY5OFoop6df3fG0CNcR1hpsST7aHMZMLri2NRTa22zD9Fk4rUlX9ze/XI+cgtN7HXJ+QhLavA6Nicg3Yli2odXcXMgabEx/7BWE6YrE85/kVnrMUGNz0boE5kWUnY0W0KahrYws=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(396003)(376002)(39860400002)(451199015)(36840700001)(46966006)(40470700004)(2906002)(54906003)(83380400001)(110136005)(40460700003)(6666004)(44832011)(36756003)(316002)(26005)(1076003)(2616005)(7696005)(478600001)(82740400003)(186003)(356005)(16526019)(81166007)(336012)(82310400005)(47076005)(426003)(36860700001)(86362001)(4326008)(8676002)(8936002)(41300700001)(40480700001)(70206006)(5660300002)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Dec 2022 16:31:15.2836
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 09b82481-d060-4c61-4d46-08dae8f0f0b5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT089.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6193
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
Suggested-by: Alex Deucher <alex.deucher@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 8 ++++++++
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c    | 6 ------
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 9a1a5c2864a0..84d83be2087c 100644
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
@@ -2140,6 +2143,11 @@ static int amdgpu_device_ip_early_init(struct amdgpu_device *adev)
 		break;
 	}
 
+	/* Get rid of things like offb */
+	r = drm_aperture_remove_conflicting_pci_framebuffers(adev->pdev, &amdgpu_kms_driver);
+	if (r)
+		return r;
+
 	if (amdgpu_has_atpx() &&
 	    (amdgpu_is_atpx_hybrid() ||
 	     amdgpu_has_atpx_dgpu_power_cntl()) &&
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

