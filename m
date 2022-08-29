Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE64D5A44DA
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 10:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbiH2ISX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 04:18:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229903AbiH2ISW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 04:18:22 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2058.outbound.protection.outlook.com [40.107.237.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B4B553D30
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 01:18:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HLaNgcYhIqBZsBh6fCYtmN7zGXInJDyHEjFeTK0eMji8JFKt4cfVAlZOAWV0rVwPamb49xHVKowMlH38C4nTCNruJ5VbPGKrtKvqDRl0sviL3T5cUjRSXh3Nj6tq6GcEicePW163YRUNrnlG8gMPI0U5E2tAl3voN6eIuRhluzPQJ2cf9Xj8F24kBpN5/hk1XgCZAu/iA2wpKpZuEk1GnyAD/KEvo4qeZTvdyAEkwcR12w3oC22g8QfhAudcj+hIYtzaBei0O8BlZOQlgYQJAr+Z6kop10MUlCGWRC2uEYeMXxQTg16nVVqjpctf1GGJRqcj2JvNYWGfF/WLER8pOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1x5FnwuJIsLnMq3JGAV8Iw0lVVFbqzVFlKpqsL3+kfc=;
 b=kdYKv9uFjklN1dTDWmR6ej6kKWDfb4wrM7fQNSuVxR/WItsSL3FMkXL+rlrfqMMHxoxAAlhqmbSwQPD/ldKMvWhmBEuVRpdS48A9+bzIT9NV0JVE99d/SXpVoLBBahBVHZslWG8HrVAwGuQy8SgTJeQWbcHoI1NLgp2c3+ZXHynJFe8NKz55pcprW1npdzCXbrJi2cfyX6kQNqwURx1Qbvws7U9H/yCEMVP6TGhbab95HIIsL0rqrpthPPUDfJWe/g6dkJw/pPbONOuu3rvNUXxHsTGL1j2PIlAgXepGRzB8dqjf7czFibBbj4N4uS2rTyoj30x1IlEu50SReoBI4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1x5FnwuJIsLnMq3JGAV8Iw0lVVFbqzVFlKpqsL3+kfc=;
 b=S+yl+M44N3HeGUvfBdiUG68NX+H9CCz38jjqo8R5CF+t9qImeb1oKP/JpSSaL7vQLWl6Vy2P4/aXmPJXbUlSgDhinlFu7cl+aVYGIzfxiv8s438BYsOx810S04fPUpNyN6WI4VdUsMTS1x/DIY1KYg2ppGshPLZ00zu5TkHVQho=
Received: from DM6PR02CA0135.namprd02.prod.outlook.com (2603:10b6:5:1b4::37)
 by BL0PR12MB5553.namprd12.prod.outlook.com (2603:10b6:208:1c9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Mon, 29 Aug
 2022 08:18:15 +0000
Received: from DM6NAM11FT045.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1b4:cafe::e9) by DM6PR02CA0135.outlook.office365.com
 (2603:10b6:5:1b4::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15 via Frontend
 Transport; Mon, 29 Aug 2022 08:18:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT045.mail.protection.outlook.com (10.13.173.123) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5566.15 via Frontend Transport; Mon, 29 Aug 2022 08:18:15 +0000
Received: from mlse-blrlinux-ll.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Mon, 29 Aug
 2022 03:18:11 -0500
From:   Lijo Lazar <lijo.lazar@amd.com>
To:     <amd-gfx@lists.freedesktop.org>
CC:     <Hawking.Zhang@amd.com>, <Alexander.Deucher@amd.com>,
        <Felix.Kuehling@amd.com>, <Christian.Koenig@amd.com>,
        <tseewald@gmail.com>, <helgaas@kernel.org>, <sr@denx.de>,
        <stable@vger.kernel.org>
Subject: [PATCH v2 2/2] drm/amdgpu: Init VF's HDP flush reg offset early
Date:   Mon, 29 Aug 2022 13:47:52 +0530
Message-ID: <20220829081752.1258274-2-lijo.lazar@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220829081752.1258274-1-lijo.lazar@amd.com>
References: <20220829081752.1258274-1-lijo.lazar@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c2b15503-51a1-4078-5f6b-08da8997058a
X-MS-TrafficTypeDiagnostic: BL0PR12MB5553:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wpJ69voLpUYvZjklkwL5BizqcGWGP7/RsjrXFZ9qb5Vh7B3UcXhDzfXfWujzltE40QXr12kvxfhIuPFeiiClsReY41vxR/VAvhp4/W6qADXC2iCtYnr3RsD1BA5GHTBSC8AjDMQgijIfnESYoemefizjbFScxRGI4ZJ8Bwk1ksqn6B5Wp4DZC2SINj0D8HkIl6GlMWog4uW/cuhDrQNGlqOxvmEZZvADMPHmOgTa5RIWv6LlqKGCDtT6pseA8rVgWzobkD7ElzR1RnuxSEykGqgaUxThXeZJbQour7nCkf0TRufoI6IAlfEtrqXPXrqs51VFTGc/CWg+qclqxYn6Gp1xQCv0vqIAsCLH+yFHAjgOHB6l8lO72K/C4WA0/sTuSLntEWiURzUGIMjLbuiZ8ztMY+ms9j50f8ol+eJ0Dysh0ud5yPezLoPFEYwiFXDKmYlOCEgkjUNedoaib/6QFPqyDusARz/5W+pxmHG5ORL8d8FXwTkZtvX3qPD4jTsr73yNVjdoMF1C/o/zC5jGhXbadlGYfA8W+Iil10YxLOBQncUkWq/rR4cHft2Pf1881Fq+0s8lgaPiCFM/ejvJbc+Ujk36IdNxPjja0DefMqVMrB3KAMJi8h0GvXHsRlvusQf1OYnS5IR+5F44v8sd4vfUlClprZ0xW5BC+JNTHX3rVeEv0vrpwIaY1/sYhUCE+PX5pjIxdZ3lMEedKbrdOQwtLzpdXDHBdagZqBWBK57+h+TlErkZHK2lJ7/7m0hnYFo7lr0FQeOGGzTLPtDY8irqX2HqGVz2fa76nhPQO9f0LcLWsajHl5EkLxAEQyzG
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(39860400002)(396003)(346002)(36840700001)(40470700004)(46966006)(44832011)(8676002)(4326008)(478600001)(40480700001)(82740400003)(8936002)(54906003)(356005)(316002)(6916009)(86362001)(5660300002)(70206006)(70586007)(81166007)(47076005)(16526019)(83380400001)(1076003)(186003)(2616005)(36756003)(82310400005)(336012)(7696005)(2906002)(6666004)(40460700003)(41300700001)(426003)(36860700001)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2022 08:18:15.1274
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c2b15503-51a1-4078-5f6b-08da8997058a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT045.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5553
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Make sure the register offsets used for HDP flush in VF is
initialized early so that it works fine during any early HDP flush
sequence. For that, move the offset initialization to *_remap_hdp.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |  3 +--
 drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c     | 23 +++++++++++++--------
 drivers/gpu/drm/amd/amdgpu/nbio_v4_3.c     | 12 +++++++----
 drivers/gpu/drm/amd/amdgpu/nbio_v6_1.c     | 23 +++++++++++++--------
 drivers/gpu/drm/amd/amdgpu/nbio_v7_0.c     | 21 ++++++++++++-------
 drivers/gpu/drm/amd/amdgpu/nbio_v7_2.c     | 24 ++++++++++++++--------
 drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c     | 23 +++++++++++++--------
 7 files changed, 84 insertions(+), 45 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index e420118769a5..9d698b9f4e54 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -2350,8 +2350,7 @@ static void amdgpu_device_prepare_ip(struct amdgpu_device *adev)
 	 * done before hw init of ip blocks to take care of HDP flush
 	 * operations through registers during hw_init.
 	 */
-	if (adev->nbio.funcs && adev->nbio.funcs->remap_hdp_registers &&
-	    !amdgpu_sriov_vf(adev))
+	if (adev->nbio.funcs && adev->nbio.funcs->remap_hdp_registers)
 		adev->nbio.funcs->remap_hdp_registers(adev);
 }
 
diff --git a/drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c b/drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c
index b465baa26762..20fa2c5ad510 100644
--- a/drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c
@@ -65,10 +65,21 @@
 
 static void nbio_v2_3_remap_hdp_registers(struct amdgpu_device *adev)
 {
-	WREG32_SOC15(NBIO, 0, mmREMAP_HDP_MEM_FLUSH_CNTL,
-		adev->rmmio_remap.reg_offset + KFD_MMIO_REMAP_HDP_MEM_FLUSH_CNTL);
-	WREG32_SOC15(NBIO, 0, mmREMAP_HDP_REG_FLUSH_CNTL,
-		adev->rmmio_remap.reg_offset + KFD_MMIO_REMAP_HDP_REG_FLUSH_CNTL);
+	if (amdgpu_sriov_vf(adev))
+		adev->rmmio_remap.reg_offset =
+			SOC15_REG_OFFSET(
+				NBIO, 0,
+				mmBIF_BX_DEV0_EPF0_VF0_HDP_MEM_COHERENCY_FLUSH_CNTL)
+			<< 2;
+
+	if (!amdgpu_sriov_vf(adev)) {
+		WREG32_SOC15(NBIO, 0, mmREMAP_HDP_MEM_FLUSH_CNTL,
+			     adev->rmmio_remap.reg_offset +
+				     KFD_MMIO_REMAP_HDP_MEM_FLUSH_CNTL);
+		WREG32_SOC15(NBIO, 0, mmREMAP_HDP_REG_FLUSH_CNTL,
+			     adev->rmmio_remap.reg_offset +
+				     KFD_MMIO_REMAP_HDP_REG_FLUSH_CNTL);
+	}
 }
 
 static u32 nbio_v2_3_get_rev_id(struct amdgpu_device *adev)
@@ -338,10 +349,6 @@ static void nbio_v2_3_init_registers(struct amdgpu_device *adev)
 
 	if (def != data)
 		WREG32_PCIE(smnPCIE_CONFIG_CNTL, data);
-
-	if (amdgpu_sriov_vf(adev))
-		adev->rmmio_remap.reg_offset = SOC15_REG_OFFSET(NBIO, 0,
-			mmBIF_BX_DEV0_EPF0_VF0_HDP_MEM_COHERENCY_FLUSH_CNTL) << 2;
 }
 
 #define NAVI10_PCIE__LC_L0S_INACTIVITY_DEFAULT		0x00000000 // off by default, no gains over L1
diff --git a/drivers/gpu/drm/amd/amdgpu/nbio_v4_3.c b/drivers/gpu/drm/amd/amdgpu/nbio_v4_3.c
index 982a89f841d5..e011d9856794 100644
--- a/drivers/gpu/drm/amd/amdgpu/nbio_v4_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/nbio_v4_3.c
@@ -30,10 +30,14 @@
 
 static void nbio_v4_3_remap_hdp_registers(struct amdgpu_device *adev)
 {
-	WREG32_SOC15(NBIO, 0, regBIF_BX0_REMAP_HDP_MEM_FLUSH_CNTL,
-		adev->rmmio_remap.reg_offset + KFD_MMIO_REMAP_HDP_MEM_FLUSH_CNTL);
-	WREG32_SOC15(NBIO, 0, regBIF_BX0_REMAP_HDP_REG_FLUSH_CNTL,
-		adev->rmmio_remap.reg_offset + KFD_MMIO_REMAP_HDP_REG_FLUSH_CNTL);
+	if (!amdgpu_sriov_vf(adev)) {
+		WREG32_SOC15(NBIO, 0, regBIF_BX0_REMAP_HDP_MEM_FLUSH_CNTL,
+			     adev->rmmio_remap.reg_offset +
+				     KFD_MMIO_REMAP_HDP_MEM_FLUSH_CNTL);
+		WREG32_SOC15(NBIO, 0, regBIF_BX0_REMAP_HDP_REG_FLUSH_CNTL,
+			     adev->rmmio_remap.reg_offset +
+				     KFD_MMIO_REMAP_HDP_REG_FLUSH_CNTL);
+	}
 }
 
 static u32 nbio_v4_3_get_rev_id(struct amdgpu_device *adev)
diff --git a/drivers/gpu/drm/amd/amdgpu/nbio_v6_1.c b/drivers/gpu/drm/amd/amdgpu/nbio_v6_1.c
index f7f6ddebd3e4..7536ca3fcd69 100644
--- a/drivers/gpu/drm/amd/amdgpu/nbio_v6_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/nbio_v6_1.c
@@ -55,10 +55,21 @@
 
 static void nbio_v6_1_remap_hdp_registers(struct amdgpu_device *adev)
 {
-	WREG32_SOC15(NBIO, 0, mmREMAP_HDP_MEM_FLUSH_CNTL,
-		adev->rmmio_remap.reg_offset + KFD_MMIO_REMAP_HDP_MEM_FLUSH_CNTL);
-	WREG32_SOC15(NBIO, 0, mmREMAP_HDP_REG_FLUSH_CNTL,
-		adev->rmmio_remap.reg_offset + KFD_MMIO_REMAP_HDP_REG_FLUSH_CNTL);
+	if (amdgpu_sriov_vf(adev))
+		adev->rmmio_remap.reg_offset =
+			SOC15_REG_OFFSET(
+				NBIO, 0,
+				mmBIF_BX_DEV0_EPF0_VF0_HDP_MEM_COHERENCY_FLUSH_CNTL)
+			<< 2;
+
+	if (!amdgpu_sriov_vf(adev)) {
+		WREG32_SOC15(NBIO, 0, mmREMAP_HDP_MEM_FLUSH_CNTL,
+			     adev->rmmio_remap.reg_offset +
+				     KFD_MMIO_REMAP_HDP_MEM_FLUSH_CNTL);
+		WREG32_SOC15(NBIO, 0, mmREMAP_HDP_REG_FLUSH_CNTL,
+			     adev->rmmio_remap.reg_offset +
+				     KFD_MMIO_REMAP_HDP_REG_FLUSH_CNTL);
+	}
 }
 
 static u32 nbio_v6_1_get_rev_id(struct amdgpu_device *adev)
@@ -276,10 +287,6 @@ static void nbio_v6_1_init_registers(struct amdgpu_device *adev)
 
 	if (def != data)
 		WREG32_PCIE(smnPCIE_CI_CNTL, data);
-
-	if (amdgpu_sriov_vf(adev))
-		adev->rmmio_remap.reg_offset = SOC15_REG_OFFSET(NBIO, 0,
-			mmBIF_BX_DEV0_EPF0_VF0_HDP_MEM_COHERENCY_FLUSH_CNTL) << 2;
 }
 
 static void nbio_v6_1_program_ltr(struct amdgpu_device *adev)
diff --git a/drivers/gpu/drm/amd/amdgpu/nbio_v7_0.c b/drivers/gpu/drm/amd/amdgpu/nbio_v7_0.c
index aa0326d00c72..6b4ac16a8466 100644
--- a/drivers/gpu/drm/amd/amdgpu/nbio_v7_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/nbio_v7_0.c
@@ -35,10 +35,20 @@
 
 static void nbio_v7_0_remap_hdp_registers(struct amdgpu_device *adev)
 {
-	WREG32_SOC15(NBIO, 0, mmREMAP_HDP_MEM_FLUSH_CNTL,
-		adev->rmmio_remap.reg_offset + KFD_MMIO_REMAP_HDP_MEM_FLUSH_CNTL);
-	WREG32_SOC15(NBIO, 0, mmREMAP_HDP_REG_FLUSH_CNTL,
-		adev->rmmio_remap.reg_offset + KFD_MMIO_REMAP_HDP_REG_FLUSH_CNTL);
+	if (amdgpu_sriov_vf(adev))
+		adev->rmmio_remap.reg_offset =
+			SOC15_REG_OFFSET(NBIO, 0,
+					 mmHDP_MEM_COHERENCY_FLUSH_CNTL)
+			<< 2;
+
+	if (!amdgpu_sriov_vf(adev)) {
+		WREG32_SOC15(NBIO, 0, mmREMAP_HDP_MEM_FLUSH_CNTL,
+			     adev->rmmio_remap.reg_offset +
+				     KFD_MMIO_REMAP_HDP_MEM_FLUSH_CNTL);
+		WREG32_SOC15(NBIO, 0, mmREMAP_HDP_REG_FLUSH_CNTL,
+			     adev->rmmio_remap.reg_offset +
+				     KFD_MMIO_REMAP_HDP_REG_FLUSH_CNTL);
+	}
 }
 
 static u32 nbio_v7_0_get_rev_id(struct amdgpu_device *adev)
@@ -273,9 +283,6 @@ const struct nbio_hdp_flush_reg nbio_v7_0_hdp_flush_reg = {
 
 static void nbio_v7_0_init_registers(struct amdgpu_device *adev)
 {
-	if (amdgpu_sriov_vf(adev))
-		adev->rmmio_remap.reg_offset =
-			SOC15_REG_OFFSET(NBIO, 0, mmHDP_MEM_COHERENCY_FLUSH_CNTL) << 2;
 }
 
 const struct amdgpu_nbio_funcs nbio_v7_0_funcs = {
diff --git a/drivers/gpu/drm/amd/amdgpu/nbio_v7_2.c b/drivers/gpu/drm/amd/amdgpu/nbio_v7_2.c
index 31776b12e4c4..fb4be72eade7 100644
--- a/drivers/gpu/drm/amd/amdgpu/nbio_v7_2.c
+++ b/drivers/gpu/drm/amd/amdgpu/nbio_v7_2.c
@@ -49,10 +49,21 @@
 
 static void nbio_v7_2_remap_hdp_registers(struct amdgpu_device *adev)
 {
-	WREG32_SOC15(NBIO, 0, regBIF_BX0_REMAP_HDP_MEM_FLUSH_CNTL,
-		adev->rmmio_remap.reg_offset + KFD_MMIO_REMAP_HDP_MEM_FLUSH_CNTL);
-	WREG32_SOC15(NBIO, 0, regBIF_BX0_REMAP_HDP_REG_FLUSH_CNTL,
-		adev->rmmio_remap.reg_offset + KFD_MMIO_REMAP_HDP_REG_FLUSH_CNTL);
+	if (amdgpu_sriov_vf(adev))
+		adev->rmmio_remap.reg_offset =
+			SOC15_REG_OFFSET(
+				NBIO, 0,
+				regBIF_BX_PF0_HDP_MEM_COHERENCY_FLUSH_CNTL)
+			<< 2;
+
+	if (!amdgpu_sriov_vf(adev)) {
+		WREG32_SOC15(NBIO, 0, regBIF_BX0_REMAP_HDP_MEM_FLUSH_CNTL,
+			     adev->rmmio_remap.reg_offset +
+				     KFD_MMIO_REMAP_HDP_MEM_FLUSH_CNTL);
+		WREG32_SOC15(NBIO, 0, regBIF_BX0_REMAP_HDP_REG_FLUSH_CNTL,
+			     adev->rmmio_remap.reg_offset +
+				     KFD_MMIO_REMAP_HDP_REG_FLUSH_CNTL);
+	}
 }
 
 static u32 nbio_v7_2_get_rev_id(struct amdgpu_device *adev)
@@ -369,6 +380,7 @@ const struct nbio_hdp_flush_reg nbio_v7_2_hdp_flush_reg = {
 static void nbio_v7_2_init_registers(struct amdgpu_device *adev)
 {
 	uint32_t def, data;
+
 	switch (adev->ip_versions[NBIO_HWIP][0]) {
 	case IP_VERSION(7, 2, 1):
 	case IP_VERSION(7, 3, 0):
@@ -393,10 +405,6 @@ static void nbio_v7_2_init_registers(struct amdgpu_device *adev)
 			WREG32_PCIE_PORT(SOC15_REG_OFFSET(NBIO, 0, regPCIE_CONFIG_CNTL), data);
 		break;
 	}
-
-	if (amdgpu_sriov_vf(adev))
-		adev->rmmio_remap.reg_offset = SOC15_REG_OFFSET(NBIO, 0,
-			regBIF_BX_PF0_HDP_MEM_COHERENCY_FLUSH_CNTL) << 2;
 }
 
 const struct amdgpu_nbio_funcs nbio_v7_2_funcs = {
diff --git a/drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c b/drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c
index 11848d1e238b..3c11af99582f 100644
--- a/drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c
+++ b/drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c
@@ -101,10 +101,21 @@ static void nbio_v7_4_query_ras_error_count(struct amdgpu_device *adev,
 
 static void nbio_v7_4_remap_hdp_registers(struct amdgpu_device *adev)
 {
-	WREG32_SOC15(NBIO, 0, mmREMAP_HDP_MEM_FLUSH_CNTL,
-		adev->rmmio_remap.reg_offset + KFD_MMIO_REMAP_HDP_MEM_FLUSH_CNTL);
-	WREG32_SOC15(NBIO, 0, mmREMAP_HDP_REG_FLUSH_CNTL,
-		adev->rmmio_remap.reg_offset + KFD_MMIO_REMAP_HDP_REG_FLUSH_CNTL);
+	if (amdgpu_sriov_vf(adev))
+		adev->rmmio_remap.reg_offset =
+			SOC15_REG_OFFSET(
+				NBIO, 0,
+				mmBIF_BX_DEV0_EPF0_VF0_HDP_MEM_COHERENCY_FLUSH_CNTL)
+			<< 2;
+
+	if (!amdgpu_sriov_vf(adev)) {
+		WREG32_SOC15(NBIO, 0, mmREMAP_HDP_MEM_FLUSH_CNTL,
+			     adev->rmmio_remap.reg_offset +
+				     KFD_MMIO_REMAP_HDP_MEM_FLUSH_CNTL);
+		WREG32_SOC15(NBIO, 0, mmREMAP_HDP_REG_FLUSH_CNTL,
+			     adev->rmmio_remap.reg_offset +
+				     KFD_MMIO_REMAP_HDP_REG_FLUSH_CNTL);
+	}
 }
 
 static u32 nbio_v7_4_get_rev_id(struct amdgpu_device *adev)
@@ -343,10 +354,6 @@ static void nbio_v7_4_init_registers(struct amdgpu_device *adev)
 {
 	uint32_t baco_cntl;
 
-	if (amdgpu_sriov_vf(adev))
-		adev->rmmio_remap.reg_offset = SOC15_REG_OFFSET(NBIO, 0,
-			mmBIF_BX_DEV0_EPF0_VF0_HDP_MEM_COHERENCY_FLUSH_CNTL) << 2;
-
 	if (adev->ip_versions[NBIO_HWIP][0] == IP_VERSION(7, 4, 4) &&
 	    !amdgpu_sriov_vf(adev)) {
 		baco_cntl = RREG32_SOC15(NBIO, 0, mmBACO_CNTL);
-- 
2.25.1

