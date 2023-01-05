Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB71765E3B7
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 04:44:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbjAEDoF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 22:44:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbjAEDnz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 22:43:55 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2051.outbound.protection.outlook.com [40.107.223.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 674E748CE1;
        Wed,  4 Jan 2023 19:43:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gZbsKuAZclfuAk/N5bFm8kY5YRrUgg+VIV8QKNvXQERmKdoTwZiEZF2zqwoUWa4ZYbZrtS3rTudDm58OzPj8pM5Hr9/w3Xl5wincpw9p+ERV8tasxWhtPefTUGxF+qc9G0FRy8yFue3+0vhtTIoZ8kiGkE4FIXKltZWPcs8BHiCCnZiWoSNddZfB342QxpsBA0LiKKPf1KVTeDBVYu1a3lP3xBaN7WBL2phJRbQkQb0LDHuW+SZia3ev0ccjURQ2SHGMQoP3ITf4JXVtoogAaq01s/zmpPjdl3jOgaoaMcGc4n8XQk0sHhNWra2WFvw3bYpNimXEZcQSq2VqdVJLYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uvbVg7tgGQ1o3dOCs/2IDLLyXibOqwjh4qWD4SEXY3U=;
 b=lCVQGHzuTRVw8CAANW4D5i64ppGnz7YIUJS5Zam1xPR/QTW48ansSkHj0Q5lnXkzbG+qNwISo2cRjrFpw6XOJBU6xpmXMNUC5nLlQ3ODJWgiG9Npzypjw1BvtmS9lFBIm7UUy1G4vJ7G0ne/fEUAdxCdF2nfToKbL1fZEziQblA7fWhfJ21JRnw/Ay5Hqd3GiIQ8slVrMAjxyeAQMA41bABpDm7/x7QCOZSuIjKQl6jsUHr0ZknCuib5xhiaGf/OpRYiwZPFYo97yVW7uvzU6fiIiTUVcYKuphhROPyWagX+bJ7q+4odocaYw7tQ7WQz2kDLrDPMaCWMlqCKYOdaXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uvbVg7tgGQ1o3dOCs/2IDLLyXibOqwjh4qWD4SEXY3U=;
 b=vswyO2XZ+EETGmvL4GmHsd9mtFInhGeVyHZfJ41+6uAljpeYZSv63Lw7tzUapNqUXHxov6ApeGHgKXh41ykaiqxpOoQktP0w6+kx6oBR+uB6t1FdSjtJJKW/xhn3vFb6YTpRgYH4foRsBLRhrsyvwMKNQXAjrAKz9dSxosWZKqs=
Received: from BN0PR08CA0006.namprd08.prod.outlook.com (2603:10b6:408:142::26)
 by LV2PR12MB5752.namprd12.prod.outlook.com (2603:10b6:408:14d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 03:43:52 +0000
Received: from BN8NAM11FT096.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:142:cafe::17) by BN0PR08CA0006.outlook.office365.com
 (2603:10b6:408:142::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.14 via Frontend
 Transport; Thu, 5 Jan 2023 03:43:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT096.mail.protection.outlook.com (10.13.177.195) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5944.17 via Frontend Transport; Thu, 5 Jan 2023 03:43:52 +0000
Received: from AUS-LX-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 4 Jan
 2023 21:43:50 -0600
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
Subject: [PATCH v6 01/45] drm/amd: Delay removal of the firmware framebuffer
Date:   Wed, 4 Jan 2023 21:42:35 -0600
Message-ID: <20230105034327.1439-2-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230105034327.1439-1-mario.limonciello@amd.com>
References: <20230105034327.1439-1-mario.limonciello@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT096:EE_|LV2PR12MB5752:EE_
X-MS-Office365-Filtering-Correlation-Id: c3c2b430-eec4-46f6-f0c8-08daeecf1045
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rXabP4VQEz6gd/AwjhZJ41LeZ/kDpR3h3X+caJ4QjL+DPyH36kO0Kl2hE9LgNCIHbv6aPqcP8IBA0QD+NBJVl2J6Jq6rGzhOvbTwgftUy0TYQ8KIkaBtNA0+FBmvPSnUZLhPmCQZc5+o1JzRcBKXK6lyVneBYvWPuU5+oM5S85gsaGqUyU8clYQph4Xq+2rxFVNZvi03hsaqLrx9DcLomNVtX3s2qZERoS8RU3xbGpEE3qH71F3Se5aRWcLThaCW/N8v+sYBu92++vENznpEB8ZPsbCKZ9VUvjBHG/QOHemHoSl14cDNe9MXUwt0vOuvd2rN0gidzeOlYWA+y2tTwbKtz979sgr6a17didFlnL+wcurZFqIFdxo+iRfIikblngojEX8PMVPZsRK9P4fTkFyQtnCHi84Jv+MR+wkaIRYAbapPaHMJwY8sjJNsLHHFGjqRWqMiwyK1yqzdalpWlrstABD98MG53TQWDWioESP2DlVGx14s+A27Fa908jONtRY1s8tOLCpGlpwED9YSP/m3qtTUmKqhOKkPt+0xd9xic/ZVmtoz7aAJ8vqCHwdwN5yt2Vg/LNVSB5bHSARD/7FubJkTd3kaXFZ7CAgSkAUxLE6lmtEdi5fhyFTsIP6OW/m8cvzBqCBrQEvjbLwV2t2y2wx6kKscn8LAqZ64V7HLROeLDh+upviiFtZ5Jk8ct/AAwtAPRU+rZ+ZL2M2Kr7+uRVDCelPQh+ABi4AVS80=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(39860400002)(376002)(346002)(451199015)(46966006)(36840700001)(40470700004)(16526019)(6666004)(54906003)(7696005)(81166007)(26005)(186003)(110136005)(4326008)(70586007)(2616005)(70206006)(336012)(1076003)(8676002)(316002)(478600001)(36860700001)(41300700001)(47076005)(83380400001)(426003)(5660300002)(8936002)(44832011)(356005)(2906002)(82740400003)(40460700003)(36756003)(82310400005)(86362001)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 03:43:52.4537
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c3c2b430-eec4-46f6-f0c8-08daeecf1045
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT096.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5752
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

