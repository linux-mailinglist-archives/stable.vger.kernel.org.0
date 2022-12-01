Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40FC463EA99
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 08:56:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbiLAH4o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Dec 2022 02:56:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbiLAH4o (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Dec 2022 02:56:44 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on20607.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8b::607])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C886E51316
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 23:56:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QiBxyfdpgIq3A5B/XUtR2U1eLty0ERZMN4/Vz8ju0F4HLoSkipwMAuRZ832gYrwVvsoCmrw/MXnh+aoOGWaJ5PNf++NOw6OE9b2dPxdAeJx/53eGs2XaGhC2LqrebKHKHPTWKxEfQvrEd8Rhax7KRkgr1TSurnhzM41gXiQKZSjC0DTQcdfzGrd+TEVdMgM9FZ2uEnOCsjBpxuR6VsbVHD5ZROylmx+hUoCR6hNiwv2Oom2o26sm9bH8b58FPm3kPB5Cgj+BwEUOdJLKXsiuS376GLY/YCbysp4ablnz617XY15WH5m2LGigz2hKEpAP/fuzMUHIz0yC3RIQSFkLgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AVj6XGUFBHx0Js1wdAPZGZru1YBW0iNgUsIdINMxRAM=;
 b=XCowpNYARxeuFb8HoQc1JjTRoCsOGLBlELQMKAfwmAFfHGFf9jGSpXp2wVAiQyDGZ//rXxeNCaLr1VHRdzkLZZ+yRhTAhoHTaS20G852/+JbVzcWd7uMiq1c9jZbHHReXg/BACS360btSEWfWdnth6//H6AMbRdSL/eCEPBtamlDXwmaaS9mFrs+LElogDJgBOdQBtKIkv9lEM9x+VfpffzL0GLGzJ6DFcPftgkXoDuJQRA/pRk3W7p7/ILlafwma6uTk9XMPEjv6Sstm49i+JMQ+VDhKBKQ7YCxrSZoJG0Batr4zXHLuHbFTVWGHKxG6BiMpfUZAiZIiGgUxED3zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AVj6XGUFBHx0Js1wdAPZGZru1YBW0iNgUsIdINMxRAM=;
 b=MIm/SfIW3eDyr3S4VQTh0vmtd19HfyHeksou8VLjwJo/b04pDOZ9TyuaSvp0Gtf9cl2XznvWK3ANnvwFTFx7GlVoKiwAbKfepEs3v5My57+vOHz4NECu18QkevpfvRh6AxldmrlQ55m+ENPqSTI08wQEeD/TVBseEf2ukEJUm4c=
Received: from CY5PR15CA0134.namprd15.prod.outlook.com (2603:10b6:930:68::23)
 by MN2PR12MB4501.namprd12.prod.outlook.com (2603:10b6:208:269::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Thu, 1 Dec
 2022 07:56:39 +0000
Received: from CY4PEPF0000C970.namprd02.prod.outlook.com
 (2603:10b6:930:68:cafe::46) by CY5PR15CA0134.outlook.office365.com
 (2603:10b6:930:68::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8 via Frontend
 Transport; Thu, 1 Dec 2022 07:56:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CY4PEPF0000C970.mail.protection.outlook.com (10.167.242.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5880.8 via Frontend Transport; Thu, 1 Dec 2022 07:56:39 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 1 Dec
 2022 01:56:38 -0600
Received: from prike-code-pc.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Thu, 1 Dec 2022 01:56:36 -0600
From:   Prike Liang <Prike.Liang@amd.com>
To:     <amd-gfx@lists.freedesktop.org>
CC:     <Alexander.Deucher@amd.com>, <Mario.Limonciello@amd.com>,
        <Lijo.Lazar@amd.com>, Prike Liang <Prike.Liang@amd.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v2] drm/amdgpu/sdma_v4_0: turn off SDMA ring buffer in the s2idle suspend
Date:   Thu, 1 Dec 2022 15:56:31 +0800
Message-ID: <20221201075631.983346-1-Prike.Liang@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C970:EE_|MN2PR12MB4501:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c8f2623-81c8-4f1f-3163-08dad37193fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7n5Ch7w2vVXG/qILd39QNKvc5D1gS6AcU7QgKJ3GtnQxD3rSjr2jZuOX/5GuKt6cIDLoCmfnw5wnBql170os9bkPDXNxjPxCHm9Or79rPc2nj43yFVAr+5AY9Vn1cdlx34oOXjqYXn38iezj+w9fYJjufQcxUJtvpTGaIoVFECxHRiSohcj3KfpnmOXDzBn5onHQ7mc0JPe3BjscJYyK1rNWzXuO8geUlMkhRY3SBb+az8eo2JwEtVHy4B9kUk/HW5LQ+ghBVCFMBswF2f8472Vm8xWkGFELFxA7jsZae4yNTS08JHgOeaM35TdDgbKEdmbupVlwANt4xIWlFra0X7tpbT/nX7ftyqSm3mMnmuTtWxIqJtRNq0hEggV8UlF7nO8QdeheJoT7U1LDTPfQYfH8kGLk0lekp9LQtIAcjOO+brAneb7w3NQnZOKPUUEJ886XorxDdfnrE32TES7O6CjqQNUAgRPjAumqYcNy7HBxiA68sBWyMsC5TE2WQqgHfwRg1ZXltwDCTE6bNb5VYog4tfykZly2nWuKgPMEvBChuT1XhrYDwvv02Ovyb/bMvcvw/AosN8JgokooOhCJVR2zx4BofcIjJqS08N+fyLq7TvoXbMAvSSJGaq5PQL8GhqYIXOGmzUG0VrJJWNfKTAMFY53O1Wnxqwy50kUzNTPzUInK4kupJCBLmTl4xix9
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(346002)(396003)(376002)(451199015)(36840700001)(46966006)(40470700004)(6666004)(356005)(2906002)(40480700001)(36756003)(40460700003)(7696005)(86362001)(81166007)(478600001)(966005)(36860700001)(26005)(316002)(5660300002)(70586007)(6916009)(70206006)(41300700001)(54906003)(8936002)(4326008)(8676002)(186003)(2616005)(82740400003)(336012)(82310400005)(83380400001)(1076003)(426003)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 07:56:39.2927
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c8f2623-81c8-4f1f-3163-08dad37193fe
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C970.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4501
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In the SDMA s0ix save process requires to turn off SDMA ring buffer for
avoiding the SDMA in-flight request, otherwise will suffer from SDMA page
fault which causes by page request from in-flight SDMA ring accessing at
SDMA restore phase.

Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2248
Cc: stable@vger.kernel.org # 6.0
Fixes: f8f4e2a51834 ("drm/amdgpu: skipping SDMA hw_init and hw_fini for S0ix.")

Signed-off-by: Prike Liang <Prike.Liang@amd.com>
---
-v2: change the name sdma_v4_0_gfx_stop() to sdma_v4_0_gfx_enable() (Lijo)
---
 drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c b/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
index 1122bd4eae98..4d780e4430e7 100644
--- a/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
@@ -907,13 +907,13 @@ static void sdma_v4_0_ring_emit_fence(struct amdgpu_ring *ring, u64 addr, u64 se
 
 
 /**
- * sdma_v4_0_gfx_stop - stop the gfx async dma engines
+ * sdma_v4_0_gfx_enable - enable the gfx async dma engines
  *
  * @adev: amdgpu_device pointer
- *
- * Stop the gfx async dma ring buffers (VEGA10).
+ * @enable: enable SDMA RB/IB
+ * control the gfx async dma ring buffers (VEGA10).
  */
-static void sdma_v4_0_gfx_stop(struct amdgpu_device *adev)
+static void sdma_v4_0_gfx_enable(struct amdgpu_device *adev, bool enable)
 {
 	u32 rb_cntl, ib_cntl;
 	int i;
@@ -922,10 +922,10 @@ static void sdma_v4_0_gfx_stop(struct amdgpu_device *adev)
 
 	for (i = 0; i < adev->sdma.num_instances; i++) {
 		rb_cntl = RREG32_SDMA(i, mmSDMA0_GFX_RB_CNTL);
-		rb_cntl = REG_SET_FIELD(rb_cntl, SDMA0_GFX_RB_CNTL, RB_ENABLE, 0);
+		rb_cntl = REG_SET_FIELD(rb_cntl, SDMA0_GFX_RB_CNTL, RB_ENABLE, enable ? 1 : 0);
 		WREG32_SDMA(i, mmSDMA0_GFX_RB_CNTL, rb_cntl);
 		ib_cntl = RREG32_SDMA(i, mmSDMA0_GFX_IB_CNTL);
-		ib_cntl = REG_SET_FIELD(ib_cntl, SDMA0_GFX_IB_CNTL, IB_ENABLE, 0);
+		ib_cntl = REG_SET_FIELD(ib_cntl, SDMA0_GFX_IB_CNTL, IB_ENABLE, enable ? 1 : 0);
 		WREG32_SDMA(i, mmSDMA0_GFX_IB_CNTL, ib_cntl);
 	}
 }
@@ -1044,7 +1044,7 @@ static void sdma_v4_0_enable(struct amdgpu_device *adev, bool enable)
 	int i;
 
 	if (!enable) {
-		sdma_v4_0_gfx_stop(adev);
+		sdma_v4_0_gfx_enable(adev, enable);
 		sdma_v4_0_rlc_stop(adev);
 		if (adev->sdma.has_page_queue)
 			sdma_v4_0_page_stop(adev);
@@ -1960,8 +1960,10 @@ static int sdma_v4_0_suspend(void *handle)
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
 
 	/* SMU saves SDMA state for us */
-	if (adev->in_s0ix)
+	if (adev->in_s0ix) {
+		sdma_v4_0_gfx_enable(adev, false);
 		return 0;
+	}
 
 	return sdma_v4_0_hw_fini(adev);
 }
@@ -1971,8 +1973,12 @@ static int sdma_v4_0_resume(void *handle)
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
 
 	/* SMU restores SDMA state for us */
-	if (adev->in_s0ix)
+	if (adev->in_s0ix) {
+		sdma_v4_0_enable(adev, true);
+		sdma_v4_0_gfx_enable(adev, true);
+		amdgpu_ttm_set_buffer_funcs_status(adev, true);
 		return 0;
+	}
 
 	return sdma_v4_0_hw_init(adev);
 }
-- 
2.25.1

