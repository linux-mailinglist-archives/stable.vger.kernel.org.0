Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C23A165F1A7
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 18:02:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233400AbjAERCK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 12:02:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233954AbjAERCC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 12:02:02 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2085.outbound.protection.outlook.com [40.107.220.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8406713DC5;
        Thu,  5 Jan 2023 09:01:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WwSfTK1vxeli12B7AXB6oWmryAv6UxmTQ5PKcglwV9bb8nXHz8/jOWFadIstzbhWQgPeI8QpOI1vn6AIhp8+Tpac2ftmMaaEOVT6sl5O8L4IMZlymXCXT/iYZhNliDavn+CqimwEYJ+o+FjVDaeWGFRWxeIXrfm0i51SDHioPahJS0dWVsCC1gPzB28lB4CF6hUg72P5AOHpl0YhBE1wGhxWpCR5iwgd7r7I6/yYONTs2UhqsOldIhVXynT/vEfw0jsZ8v/vqEsLH7iROHpP6ZJqwO6zICmrFEOGHRvWDROrgCOtHWo1WhCAa8Jz5gH6oZANlaZK+48GGFNdr3Cq+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FTLNGpVA0h+SXLS+KiTeOahDLsAlGKgmtm5t+7ygJjY=;
 b=C3GRD2hzPeCaFb4AxIg/kTO6hcccCrTdUxTsKaUmAmUcoP7U6O9CNitWB4zSUkmnT21lYCivF09tLx1Pulf245sxuyvLWm/XaFE/JIHoY9v0b1UOtFk6F6NKq6RdUIjxd4vMTSzIFlH6pCAPHIcRvAy3Bn/X7FS9qF+4p3tu303hF6pc8d1kNpaJ6eoDz9+Sm4BmLicA4zI2OJtpOJMBvu350YLNQw/vFNs6xG91jv5aOHLj7kLD9nfRgVKYUA1kdr5ptCz1a7VdUGtOgAI9ww1DwlqV5IqzwHWiCKz6dM3tZGVlU98yfyMkhT5CnAPTiRU98/6oZoGLgHIcHWySvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FTLNGpVA0h+SXLS+KiTeOahDLsAlGKgmtm5t+7ygJjY=;
 b=V4DZ20VnXrRVxnhwkiamPcViKOfukekj8tNOOqFki5LkFPL7/5r93Kjz1KGVXcAmEtZuMvwVY+hXwKPEAgK1LuCYbWTjGQuat4MlBfBl+/cGSdp5WUONwRmUQHzW8nDEH5A3vljZf/48qb2PGe2Nd6riQusM2ZFgtuxJNc7na/U=
Received: from BN0PR02CA0009.namprd02.prod.outlook.com (2603:10b6:408:e4::14)
 by MW3PR12MB4412.namprd12.prod.outlook.com (2603:10b6:303:58::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 17:01:57 +0000
Received: from BN8NAM11FT107.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e4:cafe::53) by BN0PR02CA0009.outlook.office365.com
 (2603:10b6:408:e4::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.15 via Frontend
 Transport; Thu, 5 Jan 2023 17:01:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT107.mail.protection.outlook.com (10.13.176.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5966.18 via Frontend Transport; Thu, 5 Jan 2023 17:01:56 +0000
Received: from AUS-LX-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 5 Jan
 2023 11:01:55 -0600
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
        <stable@vger.kernel.org>, Lijo Lazar <lijo.lazar@amd.com>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>, David Airlie <airlied@linux.ie>
Subject: [PATCH v7 01/45] drm/amd: Delay removal of the firmware framebuffer
Date:   Thu, 5 Jan 2023 11:00:47 -0600
Message-ID: <20230105170138.717-2-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230105170138.717-1-mario.limonciello@amd.com>
References: <20230105170138.717-1-mario.limonciello@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT107:EE_|MW3PR12MB4412:EE_
X-MS-Office365-Filtering-Correlation-Id: 226e5475-d060-4965-ccea-08daef3e8d88
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QiNXOZsYrjQ+g2q5FC5H6zhhLmcHy7ywfsaHxWx6IF7HL/vNMoJ+LnPqSOK6ZcPMwpobPFVG2Ng4PQpB8aMi1F6jJmPg9MXjjCN7baOT6FojWEw2/EJ3rYHodQLi7hhVZ/xDhblhVZzbDOCbhY7QaVqIdwD4L4z+/5N+xKHhJWHfCSwk4c0j3GczRlVf5pgx/gbxAV9Bt3R7FJVLcy4e4I2LqcHCpUlEKCzfu/lUflmssbKNYCL4tPRM9+pAZSuCEy9uH7iQ75WW7CWlXK56n6bksUdCI9bN79/ZECRPJXI4obuCpAVo8m5tuIFJddERklJq1fHt2c7wgTPndqYqk9yunYIxSR5n3N9SvCNvq9HW6SEShne43LT7n4mMAdKYRxoF0YK8A9QsKemfv8q0IDMlNdr0AeS1WQ/k00unK1dCly3TzCVtm22Z27Z8KFhPrPOnfzUIPnCwAFMPNGnFgFDU6C2jbX35+SZy0GaQrliVHhgcUGW9Db8bNdkKztY+8YfshxcoiCMkc1DfyjLkrfEt19Ua5FuB/suCG904ntfnuk9vlmJ4yOOGpazbJVPGIG1nb83ehDE5Q4v81N3KxS/i91a7K83YldF99Sn4U+8EvgysCtEcDcvPizWVi9M44tZwLaz6CfSanNHMORjNWyL5+ac5vtCWEzO0O7RBi9RP8rP0v+l3vW/6nWpOKUUWS4d9PowN//PlswSujdC2uQwadQNH2jzvPbPVBJOrvBU=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(396003)(376002)(136003)(451199015)(36840700001)(46966006)(40470700004)(44832011)(2616005)(36860700001)(47076005)(336012)(83380400001)(426003)(40480700001)(86362001)(81166007)(82310400005)(40460700003)(82740400003)(1076003)(356005)(36756003)(54906003)(2906002)(110136005)(70206006)(316002)(41300700001)(8936002)(70586007)(8676002)(5660300002)(4326008)(186003)(26005)(6666004)(16526019)(7696005)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 17:01:56.7597
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 226e5475-d060-4965-ccea-08daef3e8d88
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT107.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4412
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
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
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

