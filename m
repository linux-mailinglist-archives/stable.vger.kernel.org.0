Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9C176064C8
	for <lists+stable@lfdr.de>; Thu, 20 Oct 2022 17:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbiJTPjP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Oct 2022 11:39:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbiJTPjO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Oct 2022 11:39:14 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2088.outbound.protection.outlook.com [40.107.243.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4173D1B90C7
        for <stable@vger.kernel.org>; Thu, 20 Oct 2022 08:39:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZBAEDbMxUFUBI/DcRXYfrcxkilGnJq/eMvn0VhaAL28tJjc+AqCrGMeCZCZD4WkyzsBHbfXsQhuG1WK0n50Z4dcWGxHrX+/hDSqWr0zUfgOy6wOGQoKXod6fRjIf6y620GI/Zic0HuOfR7Qv4iSrk5W55rPf4Wk84my8XAaQUq4svAu8fXc5sQ7ki8mAJ/XvoUUG7OK2n4nuClzMEBwRcAPhIMv4A2vHldPQAyFs6oz8ptUnIRxzspcKryHugWbi9o0uHc+Gl/fUbg9GvO9FSaDVg/p6f8pHGGkEAhIG6zRmH4bq2wV70Ce2qhzLW0UuTsHKb5Z1iwwxD+IJint0hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=de6EBgYp2B7UjJLfeKZmJF18R6x/116XA7HbZGKBuj4=;
 b=MO3o49+aSORxkCShJ8rKVOw1RiaUisQ9B3i3rueHvLXmweMzN8062t7pbipPqrJ9LdGVZfaTP8JvfjkGVhNKVb5lCWScQlJ2EFz0ljUedgqEUqr0enH61ljvr/xsUTU+utY6nsYM7P+qBcXYMmdXF3haqiGYS27R2+O5Z0eebHNB+G7kt1VcX2p8NXi1HJNF0xKZXK3SlMj3v82uLgFLawBRNMtnd8K0wmOsXHP8GHPmnsHhiUicMDT3YVS6DA0XVBdgNFxXres0xSqsGx327bE8ev8F+0l+NGDBBesk32/HJ/c/CTdnh8tgOineWklI5LuLhcDAB9YO2UMwMhUmlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=de6EBgYp2B7UjJLfeKZmJF18R6x/116XA7HbZGKBuj4=;
 b=sM2fPonviEPfLKvPd6Ya3fW/xCX7YdDJdHqsRilYWp1gwLwlDiv2bG4X2pkY4KJjG4FLaO+sXpoglB/qo/MOrxfk1gdtoDj1aMuaLVNRRQXXjY1QUglV9vxKUlJesJxL2JxYBv1WOUcX8lBLA9c3iKcDYbv6wuZrH1wVimTr/Kk=
Received: from BN9P223CA0005.NAMP223.PROD.OUTLOOK.COM (2603:10b6:408:10b::10)
 by BN9PR12MB5132.namprd12.prod.outlook.com (2603:10b6:408:119::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.35; Thu, 20 Oct
 2022 15:39:11 +0000
Received: from BN8NAM11FT012.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10b:cafe::cd) by BN9P223CA0005.outlook.office365.com
 (2603:10b6:408:10b::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.35 via Frontend
 Transport; Thu, 20 Oct 2022 15:39:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT012.mail.protection.outlook.com (10.13.177.55) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5746.16 via Frontend Transport; Thu, 20 Oct 2022 15:39:11 +0000
Received: from tr4.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 20 Oct
 2022 10:39:10 -0500
From:   Alex Deucher <alexander.deucher@amd.com>
To:     <stable@vger.kernel.org>, <gregkh@linuxfoundation.org>
CC:     Alex Deucher <alexander.deucher@amd.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 1/2] Revert "drm/amdgpu: move nbio sdma_doorbell_range() into sdma code for vega"
Date:   Thu, 20 Oct 2022 11:38:56 -0400
Message-ID: <20221020153857.565160-1-alexander.deucher@amd.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT012:EE_|BN9PR12MB5132:EE_
X-MS-Office365-Filtering-Correlation-Id: 80626682-ce36-4f79-915e-08dab2b13bf0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Fkne6ZO13nMVvnZ7SJHMxfleaAZfZCLWT83GMgyZOJgSgyt/tqy6QKJ30hFJdSNzBhBcKV/l0pCLN8x3yTgXKdNO50H0oFMBtXtgq/jiZcG6X3/7nMOPZNItS8q1yHEjGVZanxpzkLADYNuEOxAW8DKFFnHt67DiiHaD9RwHJMhVf0HYSbLwgRGjVNra5vWvkc6/o1Z6uGJ30Q4qfL20D/c+v4YhCUPy8gkG8rLYJNjA4JwLN5nqQpAlcqkPKMfQZbRE0BNKDPlwaGDI0rkMY/83lLwcTMZmzIcT+8O9NNvXfZN0lE0PTqkum/ekLK/iBf8JJNx0tL4Ryav6umTVyzFY0FvJsCPrQYKO6svUQsJbClZ7o4H7M3HLfs0WehgiOe6JDLgUe3F3Pn1NM36jtl+1kQsaAI4dqo5TsGOmDl4T09sVMS8ucy5ZGRihEX5zJj5IozjZ9Xg0PIaahUF1mNYbzalHG8qMIsdHXQXUxChlqgIJdtdnL0Blm1EHkOUrcXjIOKkqb2LAh2o/DLDTBY6UumiX9xTi3BfLzyPuWtPTXBn9YXN5Pg7+nhP8VjTRd2CJ2g3H5desaJ6JtnCoVFXyJPr4Ye5eNQ004UeHHAwZvp2h5DTdFpQF7VuFFTJJCtgZQLLawuFb9MYo5VWxGJeMIS/lF6WUXKLWXKASHrRo4TaQTEZncl95bFmJLtc9Th08lID7rxIjFlYgUi/lLy7+IfzxCCgOYOysWyp5akm4+C1woTRY1n8DTXRIagh9
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(39860400002)(346002)(376002)(451199015)(46966006)(40470700004)(36840700001)(7696005)(426003)(356005)(81166007)(82310400005)(47076005)(966005)(40460700003)(8676002)(70206006)(336012)(4326008)(70586007)(41300700001)(2616005)(316002)(5660300002)(36860700001)(8936002)(40480700001)(16526019)(1076003)(186003)(26005)(86362001)(478600001)(2906002)(36756003)(83380400001)(54906003)(110136005)(6666004)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2022 15:39:11.0454
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 80626682-ce36-4f79-915e-08dab2b13bf0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT012.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5132
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 9f55f36f749a7608eeef57d7d72991a9bd557341.

This patch was backported incorrectly when Sasha backported it and
the patch that caused the regression that this patch set fixed
was reverted in commit 412b844143e3 ("Revert "PCI/portdrv: Don't disable AER reporting in get_port_device_capability()"").
This isn't necessary and causes a regression so drop it.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2216
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: <stable@vger.kernel.org>    # 5.10
---
 drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c |  5 -----
 drivers/gpu/drm/amd/amdgpu/soc15.c     | 25 +++++++++++++++++++++++++
 2 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c b/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
index a1a8e026b9fa..1f2e2460e121 100644
--- a/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
@@ -1475,11 +1475,6 @@ static int sdma_v4_0_start(struct amdgpu_device *adev)
 		WREG32_SDMA(i, mmSDMA0_CNTL, temp);
 
 		if (!amdgpu_sriov_vf(adev)) {
-			ring = &adev->sdma.instance[i].ring;
-			adev->nbio.funcs->sdma_doorbell_range(adev, i,
-				ring->use_doorbell, ring->doorbell_index,
-				adev->doorbell_index.sdma_doorbell_range);
-
 			/* unhalt engine */
 			temp = RREG32_SDMA(i, mmSDMA0_F32_CNTL);
 			temp = REG_SET_FIELD(temp, SDMA0_F32_CNTL, HALT, 0);
diff --git a/drivers/gpu/drm/amd/amdgpu/soc15.c b/drivers/gpu/drm/amd/amdgpu/soc15.c
index abd649285a22..7212b9900e0a 100644
--- a/drivers/gpu/drm/amd/amdgpu/soc15.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
@@ -1332,6 +1332,25 @@ static int soc15_common_sw_fini(void *handle)
 	return 0;
 }
 
+static void soc15_doorbell_range_init(struct amdgpu_device *adev)
+{
+	int i;
+	struct amdgpu_ring *ring;
+
+	/* sdma/ih doorbell range are programed by hypervisor */
+	if (!amdgpu_sriov_vf(adev)) {
+		for (i = 0; i < adev->sdma.num_instances; i++) {
+			ring = &adev->sdma.instance[i].ring;
+			adev->nbio.funcs->sdma_doorbell_range(adev, i,
+				ring->use_doorbell, ring->doorbell_index,
+				adev->doorbell_index.sdma_doorbell_range);
+		}
+
+		adev->nbio.funcs->ih_doorbell_range(adev, adev->irq.ih.use_doorbell,
+						adev->irq.ih.doorbell_index);
+	}
+}
+
 static int soc15_common_hw_init(void *handle)
 {
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
@@ -1351,6 +1370,12 @@ static int soc15_common_hw_init(void *handle)
 
 	/* enable the doorbell aperture */
 	soc15_enable_doorbell_aperture(adev, true);
+	/* HW doorbell routing policy: doorbell writing not
+	 * in SDMA/IH/MM/ACV range will be routed to CP. So
+	 * we need to init SDMA/IH/MM/ACV doorbell range prior
+	 * to CP ip block init and ring test.
+	 */
+	soc15_doorbell_range_init(adev);
 
 	return 0;
 }
-- 
2.37.3

