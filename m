Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38BD263E9D2
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 07:20:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbiLAGU6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Dec 2022 01:20:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbiLAGU5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Dec 2022 01:20:57 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2047.outbound.protection.outlook.com [40.107.92.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F9DDAB001
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 22:20:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d0O/GXfu25QykIwt2P2ff0Hpi0KHITzxoB0yvEjlOKNE2uBUREOaygfw8QandpY8jOUNmyuNVE0pnckU/f59zEeupn84JCIkxoy4Z16YuZKhUaS7KTPutEM8F2JqmJuj8dqa4UoOj84Eua6B1lKVVd1zDGJ5Ryjt6w97V+404Xv3gKIzmH9xY+Y5IC17IzzSIRTzlWmalpgEKzn3Th7nE43UHUYYZsD7si12yXQtdkv/H6ABy1wNcS2vxc4aZmakMlc2xxW21r1UlDBECRFs/tLlDNY4nlaxwBadKBItk68ZQijpOdfd8ahxrotBjL9gmRjctj3DUtSuTv80oIEB/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4fuPr1i4Ikj9n501+rNTEL9fWO/Dn6w4YVwJH4asuB8=;
 b=g7tl/TW2Oq5SgLcQSgsrqC/FanXZXlZmTZphUtR95WAeceWtGTQNA30/tVBc9CMiaz7qOq7bsm2mbvRNvU9rhHlBkSyCRXBKA+hdA5xv33sG3j2B0K9ngI8JFB9tTBijgCZWQX/3ar0qT8zyfy7k1f3cJ/7hwFPqHqaTb848LMkirRwuLaqHd59AzfVRlH+B3f3BcGCjneVg/+qv0Bilq/H2D4rJULz9duuQUNB9Hgs/JrlvgpjEz8Qf7Zcbaoas07/cDvSuJ/ThVC5QEz3uEUZKBUemoIRJK0jfz5z0b+WA6dUu+OAaD8U/JPZYBr654DE1n01VfHQisdLDKF+Gog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4fuPr1i4Ikj9n501+rNTEL9fWO/Dn6w4YVwJH4asuB8=;
 b=2/zhq6urbAL9rsgGHoLGFdicWU0VB2jX6W/v43uqK6r0Xi9PuoJ7XyKPlHxl+TJ7mIk/qs//+KhyKcnoduw/k6LfgMTpxSAMrsqlDRzW5d7yPLWTVoSQyluskiLE35S9Q5KBX7/wJPp3cG1iH2TRXTWIk5/5dN9NOPksrUUa57E=
Received: from MW4PR04CA0148.namprd04.prod.outlook.com (2603:10b6:303:84::33)
 by IA1PR12MB6284.namprd12.prod.outlook.com (2603:10b6:208:3e4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Thu, 1 Dec
 2022 06:20:54 +0000
Received: from CO1NAM11FT023.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:84:cafe::71) by MW4PR04CA0148.outlook.office365.com
 (2603:10b6:303:84::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23 via Frontend
 Transport; Thu, 1 Dec 2022 06:20:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT023.mail.protection.outlook.com (10.13.175.35) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5834.8 via Frontend Transport; Thu, 1 Dec 2022 06:20:53 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 1 Dec
 2022 00:20:52 -0600
Received: from prike-code-pc.amd.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Thu, 1 Dec 2022 00:20:46 -0600
From:   Prike Liang <Prike.Liang@amd.com>
To:     <prike.liang@amd.com>
CC:     Prike Liang <Prike.Liang@amd.com>, <stable@vger.kernel.org>
Subject: [PATCH] drm/amdgpu/sdma_v4_0: turn off SDMA ring buffer in the s2idle suspend
Date:   Thu, 1 Dec 2022 14:20:45 +0800
Message-ID: <20221201062045.979816-1-Prike.Liang@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT023:EE_|IA1PR12MB6284:EE_
X-MS-Office365-Filtering-Correlation-Id: 7969fd8c-cfa0-42fa-60e6-08dad3643358
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pbuQk2UzqDmw9he0eQo+E1HhWuR9igaTQzOEiaxWbklGiHUIhc25bXi+DJraENrjmWOrWZp9pECZ+5Ot7WWv3sQXCWL1G8wKxZ47JykmE1ruOghaFgGo0aDCPr8ODTTwMPH5LPx4tlSzRcvSqrfzWpAHI4nZpPEZ9CL2D9Vz0B/Tp2hN1EQg+9uZuRXdKMVDsnMtk81I9dVIvVjhPvDl3jzv0/u6QeQ5NmT5b6SwwzYPaHwU8dwGle//BzGS0dVEyde4s4x3TyN83w6W8N+rnuDMyCOF0ErkDsLJKoIDO4e6YlwkrC8wj8/9JknEBqBc6fDDkbcKC/C9jWYCXt/ORdlYDSO+nASzV2KmYA7w1zIvQbtkqir/adyaY78iHntBpD78Psf6OigO6RXcU04VqPdzzqspEB95yGiGUUT/qZzM+Ow8N2HuPJztu4qf5lFVAW6uejQaYwcz+vL9uy+PMXzGYh4+ZAFSU7tjybrXtdX3DvuPj37YoIvIYPx6jKG10Sj2E9IB6m3jwcCH+MjRdCjGvxoudRXoLwxAJCz0yr/dPm8euuvPChiykWirBZWJSWUt1C5UbqAweG+oc6eHWIu1W/W4HU3FkeGjjo+0ON4Lj+A1+oBv4LlJ1VJCwnXgdmwqHEG0Q3ej82HA0gVg6gC+8xruGd5s7RNsdtpKGQ+jecYJ20y22PrW3glxvK63
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(346002)(39860400002)(396003)(451199015)(36840700001)(40470700004)(46966006)(47076005)(40480700001)(426003)(41300700001)(1076003)(336012)(186003)(2616005)(81166007)(6862004)(8936002)(82740400003)(36756003)(2906002)(86362001)(36860700001)(83380400001)(40460700003)(5660300002)(316002)(37006003)(70586007)(70206006)(356005)(54906003)(966005)(4326008)(8676002)(6200100001)(478600001)(7696005)(82310400005)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 06:20:53.6248
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7969fd8c-cfa0-42fa-60e6-08dad3643358
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT023.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6284
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
 drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c b/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
index 1122bd4eae98..2b9fe9f00343 100644
--- a/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
@@ -913,7 +913,7 @@ static void sdma_v4_0_ring_emit_fence(struct amdgpu_ring *ring, u64 addr, u64 se
  *
  * Stop the gfx async dma ring buffers (VEGA10).
  */
-static void sdma_v4_0_gfx_stop(struct amdgpu_device *adev)
+static void sdma_v4_0_gfx_stop(struct amdgpu_device *adev, bool stop)
 {
 	u32 rb_cntl, ib_cntl;
 	int i;
@@ -922,10 +922,10 @@ static void sdma_v4_0_gfx_stop(struct amdgpu_device *adev)
 
 	for (i = 0; i < adev->sdma.num_instances; i++) {
 		rb_cntl = RREG32_SDMA(i, mmSDMA0_GFX_RB_CNTL);
-		rb_cntl = REG_SET_FIELD(rb_cntl, SDMA0_GFX_RB_CNTL, RB_ENABLE, 0);
+		rb_cntl = REG_SET_FIELD(rb_cntl, SDMA0_GFX_RB_CNTL, RB_ENABLE, stop ? 0 : 1);
 		WREG32_SDMA(i, mmSDMA0_GFX_RB_CNTL, rb_cntl);
 		ib_cntl = RREG32_SDMA(i, mmSDMA0_GFX_IB_CNTL);
-		ib_cntl = REG_SET_FIELD(ib_cntl, SDMA0_GFX_IB_CNTL, IB_ENABLE, 0);
+		ib_cntl = REG_SET_FIELD(ib_cntl, SDMA0_GFX_IB_CNTL, IB_ENABLE, stop ? 0 : 1);
 		WREG32_SDMA(i, mmSDMA0_GFX_IB_CNTL, ib_cntl);
 	}
 }
@@ -1044,7 +1044,7 @@ static void sdma_v4_0_enable(struct amdgpu_device *adev, bool enable)
 	int i;
 
 	if (!enable) {
-		sdma_v4_0_gfx_stop(adev);
+		sdma_v4_0_gfx_stop(adev, true);
 		sdma_v4_0_rlc_stop(adev);
 		if (adev->sdma.has_page_queue)
 			sdma_v4_0_page_stop(adev);
@@ -1960,8 +1960,10 @@ static int sdma_v4_0_suspend(void *handle)
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
 
 	/* SMU saves SDMA state for us */
-	if (adev->in_s0ix)
+	if (adev->in_s0ix) {
+		sdma_v4_0_gfx_stop(adev, true);
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
+		sdma_v4_0_gfx_stop(adev, false);
+		amdgpu_ttm_set_buffer_funcs_status(adev, true);
 		return 0;
+	}
 
 	return sdma_v4_0_hw_init(adev);
 }
-- 
2.25.1

