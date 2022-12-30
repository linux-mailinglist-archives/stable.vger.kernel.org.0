Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09E8C6594D8
	for <lists+stable@lfdr.de>; Fri, 30 Dec 2022 06:21:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234464AbiL3FVz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Dec 2022 00:21:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234449AbiL3FVp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Dec 2022 00:21:45 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2056.outbound.protection.outlook.com [40.107.244.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F7D817E2E;
        Thu, 29 Dec 2022 21:21:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i4VSB7WZfDF+qqE/V3iimEtNDeR8S8kMd64/g2W1W1sMUdPiE6mJaxVfONSLEiYj6vV5JJ1Vr7QfXZEJzdpn1UrztkVzVrGIxFsKfobZVtn+mZnDc3+2TFJT9wlkdO1MP4pg1dMkiY5tzqOwPhapqMuIkKQotuCURpnF9QuHufaGtp0pg6jTARwVSIrU4t7PrbwIxe/zuHkXthTMEMaaISAYGeJNiMddpRbkcODnBG7lrY61MFkv+TfTIsNjARNzz22wqfbRxb4Ll9KrYayNFW/M1cSRsDoMsiiP8476oII5+NbhQ9NEqDTgOZSbYJhRDSmrTggEclFeCcZnwL92/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ztmrlVQwBHdDHYiX3HhGPKTRMPa4VFISf+/APMrVVVY=;
 b=ZtPV/nHlV2JWxTA/tU6WaXmxLP9a+p4gJwL1q3y868mqeSd1g3c5JVCXLrjI2rUi2rPkfZCbYEgF5hfR1B4DKBNsKegrvXn+YgWxmuoVnt/GxCbAm+eaf/niFYrwMqKLYtHdaiKC9e1f7Mdx1bdbNBs2iCpRe9benE1cAjviZBklM6+LSNO6jVhOhrKG6rCbEieU+kqvIpbq7P6u0feWvzQyzYEnQwNN9E5uAD3GnmQf6fJV2JM8YpEhd89moMMJzx3CDC4v8nCPJDUQNmiCV3oHfc3+3kwEkk1W2dWmIlnEGjqxVleaR6aYLTZfR7G3ZLBo1ALRVU4oINOTqkRrpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ztmrlVQwBHdDHYiX3HhGPKTRMPa4VFISf+/APMrVVVY=;
 b=fXlhCzRWGUyUz+hTr1lFe7V0vZsQ5ERrSLXa5kxFlY1/uIk4oSrj6hFUd5HaX1GEgVj0CDmi6G7XUkvYIO+WoCMK+W/gWOBH/wo7ALO7D2QpG+JJ9c0X2kp5UeIXDFJlZcTF4I1V7Mn+U5qeWMpouU5e9gW4OOu4PUHOZMsfTX0=
Received: from MW4PR03CA0350.namprd03.prod.outlook.com (2603:10b6:303:dc::25)
 by SN7PR12MB7321.namprd12.prod.outlook.com (2603:10b6:806:298::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.16; Fri, 30 Dec
 2022 05:21:42 +0000
Received: from CO1NAM11FT033.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:dc:cafe::e9) by MW4PR03CA0350.outlook.office365.com
 (2603:10b6:303:dc::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.17 via Frontend
 Transport; Fri, 30 Dec 2022 05:21:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT033.mail.protection.outlook.com (10.13.174.247) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5966.17 via Frontend Transport; Fri, 30 Dec 2022 05:21:41 +0000
Received: from AUS-LX-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 29 Dec
 2022 23:21:36 -0600
From:   Mario Limonciello <mario.limonciello@amd.com>
To:     Alex Deucher <alexander.deucher@amd.com>,
        <linux-kernel@vger.kernel.org>
CC:     Javier Martinez Canillas <javierm@redhat.com>,
        Carlos Soriano Sanchez <csoriano@redhat.com>,
        <amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
        David Airlie <airlied@gmail.com>,
        "Daniel Vetter" <daniel@ffwll.ch>, <christian.koenig@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        <stable@vger.kernel.org>, "Pan, Xinhui" <Xinhui.Pan@amd.com>
Subject: [PATCH v3 01/11] drm/amd: Delay removal of the firmware framebuffer
Date:   Thu, 29 Dec 2022 23:21:05 -0600
Message-ID: <20221230052119.15096-2-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221230052119.15096-1-mario.limonciello@amd.com>
References: <20221230052119.15096-1-mario.limonciello@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT033:EE_|SN7PR12MB7321:EE_
X-MS-Office365-Filtering-Correlation-Id: 6157a733-d474-4321-6fb6-08daea25bbfa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tAZs10rkhCzxgSLRHfGEtNwaY974Xg1Z4FX7tGNgg1JGKfrfUKIzvHoGsqeLq1BnoF/vfpPTM4qNXEMIEqoAlXMIdn4mETbGbZR0WVUo2y7/z1jhwNznQiMQWlNdurHQ+5Hmvb+vIYSjTpYLwj8KcrNvue34c6X3N+fugEkdJWyBzOku5wtqPApIbKgQFUQF1qFWxN5YXeh3ea253T3wKEJx7JFaRP2Cgipovt769RMwUqLwyd/7i5nYiLYKckZ27Z/ewlgAH09XQQd2b0GIpgq4nbfbeZAfAkvxvPc5HZfPyoi/vEiB4u/ohZcOghXB2Tih6q5Mj50v7/MwvcohTxiNYzAIae90HmiXwW2gcZmMKEEVrdNpbrgfFc6nFhRUvpRl4pcQ4Pf1UkpYCzScr/BbpPFUsUBosVEZxIU2CApkWWisET47Upf1FjT5nS601Tpa81kNlFFPWXPKKUu4tS/zdchXRnACn0U1mh/iYHIvcPinIXFe+Ydjb0E4w9eZYSuFb3958QfaGgDctsDlX5sZGRkrXAgzAsMWyAPdvVGYn90Qq9/Ub2PNK8H8UQWwQyn/ypmresKQXtUNdhDmxaIqdtFp4+HoOUJ29/NW7k1KP17VI6QVpOGpXkEimIC6uDpejO3ZV1tuit9SrKp3VRukMz8rc0utF6HAGgJ/cNdYZA7r0PBqBEtD14J7Bc+dM6ZfIB1qB4O7Cy4Xmod7aNG8R2dhsp6YO74uEOBPyxQ=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(136003)(39860400002)(346002)(451199015)(40470700004)(36840700001)(46966006)(86362001)(70206006)(8676002)(4326008)(2906002)(41300700001)(44832011)(8936002)(5660300002)(70586007)(40480700001)(83380400001)(478600001)(2616005)(47076005)(6666004)(26005)(16526019)(1076003)(426003)(40460700003)(186003)(81166007)(316002)(356005)(54906003)(7696005)(110136005)(82740400003)(336012)(36860700001)(82310400005)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2022 05:21:41.3381
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6157a733-d474-4321-6fb6-08daea25bbfa
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT033.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7321
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
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
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

