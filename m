Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 746874CC968
	for <lists+stable@lfdr.de>; Thu,  3 Mar 2022 23:46:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234478AbiCCWrg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Mar 2022 17:47:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231805AbiCCWrf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Mar 2022 17:47:35 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2079.outbound.protection.outlook.com [40.107.243.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DAFF16BFA8
        for <stable@vger.kernel.org>; Thu,  3 Mar 2022 14:46:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j7q19sBMYRbH04cyUfwxa7Ixb6XJlVkinvE9JRkmLq5P3Qh8paFyRp/JwpwGGkDI8hKixi+jk4Dw23UU43kHn9ndU+cuUZBh/TINHywJce1w4y/LiQGL/uV2LG9OgSMXVsvFZ21veriUnamrQiJFmdv2TJ4m5Xu1fe245oKerb/iX0MFsKC+5uV6owaXNioOLkQB41lSUcbPI35m6Qx/tvRWHmqLYrY0bTqe+ryfhShN/2hYU022pQjEIVSCF70U6a2ARlLzamenOkbF1F/RPoFbfYFkV3S69F5UWk0+BT6LmJW7/noaKOtFTfLpMt1kvOA6lhCidxPfhAHmIlEFJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Djpxw02bqJy3CeyUSWjhn7YU9M6OlwDyL6omqa2z0hE=;
 b=Uam6TwUvYAjmZskYgus89JdfsIuPjmHf1+h+8XKmil09tunuGtJJl97tKhX8qEpOXeyKbzxWlan2OYsZkyqXkJSCamY/64TrWTEg9H8zKdq0/5EacAPbnKUAAV608G6WhGFwWhNMt7pRPZP8ngFEkoIa8YJ24beips4Xmdm/nRRr4zHBCRWbHuKcVH+PTN9uyko3BF22geDkpLP30nCO4TJvtHYuGigADnXA/LeOu+6jEQzT26RrpYXvuPiCbzmzxCE2IZL02IKMcu7q5XO1MFlFYplDhdX6Mn2PpftYNokZBEJqUAYawAzH1mv/inSzI1gAA/SIIJEv5QWDT3GFMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Djpxw02bqJy3CeyUSWjhn7YU9M6OlwDyL6omqa2z0hE=;
 b=rgdmrA03qBH9R+WfpyZq2O7kBhAO4vC1EnGCIpikAwa/XGtG59eYCT7XLO61ntEEqZSHnSXeyYm7hDc7scN9j9uP/aPgIS7OI2lIkzS6uvuWxcIwXI4Uws2pdNAhr6o/m+PCr5tARLKj7DanNOeXhu5rIFh2DeVh20tzeXyGnJk=
Received: from DM6PR14CA0067.namprd14.prod.outlook.com (2603:10b6:5:18f::44)
 by DM4PR12MB5842.namprd12.prod.outlook.com (2603:10b6:8:65::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Thu, 3 Mar
 2022 22:46:47 +0000
Received: from DM6NAM11FT031.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:18f:cafe::d4) by DM6PR14CA0067.outlook.office365.com
 (2603:10b6:5:18f::44) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14 via Frontend
 Transport; Thu, 3 Mar 2022 22:46:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT031.mail.protection.outlook.com (10.13.172.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5038.14 via Frontend Transport; Thu, 3 Mar 2022 22:46:47 +0000
Received: from doryam3r2rack03-34.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.18; Thu, 3 Mar 2022 16:46:45 -0600
From:   Richard Gong <richard.gong@amd.com>
To:     <stable@vger.kernel.org>
CC:     <richard.gong@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Harry Wentland <harry.wentland@amd.com>
Subject: [PATCH 1/2] drm/amdgpu/display: Only set vblank_disable_immediate when PSR is not enabled
Date:   Thu, 3 Mar 2022 16:46:24 -0600
Message-ID: <20220303224625.2108948-1-richard.gong@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7899aab9-9199-401a-2120-08d9fd67b2ed
X-MS-TrafficTypeDiagnostic: DM4PR12MB5842:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB5842839E9165540D8B9CCC3895049@DM4PR12MB5842.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 87Oc7+6g8FNY6HmPnZJ9vQ+iXgsufo5hYYhfNxIckfgDQO2rVQjmIadI3bpFI++em2Mc+jDcELqHfmZZO+/eCrvAhCaYcB7IqyKi2d6k3hkVdb2JHaB8g8uOb0HCT4eOmohlh0seiHWGBdpJz/B2hxs/w9mpjnfwQTinGad12yMCn7snTU6aojVyR214TicJvAlWLcsGGfHZ1zAvemE3XRGGJgLhj6tqZkhInTPVdIMfQmFLAdT52XwCK1PTgutQ5IEm2uNLYtxLYKteXRAIxGqutpDUPwuNU69wX4PzEhnDb5QDp5H3oR0EpLPGKorKhU7NiXqg2wIOQuOtsObW2oACP4ysx6a3ReicUJ1FIuEB0fPRIo53wD/++53KyJ9RsUd6evpKi0IYIhDzwMzhnUV3NxBB1/Ev7YvmcMebG3eWnc/NulOsQ6M3wc3grtJBFGmymxGkPxHOzYTwmBGZr2CwKGGDBY2PZ4NbPPDGGUewx6aCNslTW7jUGTeRj0Tu0kumxbi9gS5xqZfEcTgXpTRtwii6BSEXDDLDNrCT5I6bDXmCCCLB/EcoWJ8zz7Iv5dJ4Oc6m/9dTHPAPTobrSsDT8mSmtPKpjrap0SMo9XRb5UlNdAmcOugWfGe53gsDn2l4FeXQLmGAUklerbSWe1Q5MTYqMN46Q7DkMUPu5QipQNCGqe4OK5ZevOLGFlx117D8SJcm4FJ2A14b9qXoPA5Me0W/YxAkwW0cwdFdHZs=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(7696005)(426003)(336012)(40460700003)(26005)(1076003)(2906002)(16526019)(186003)(2616005)(82310400004)(86362001)(36860700001)(83380400001)(47076005)(356005)(81166007)(54906003)(6916009)(6666004)(44832011)(5660300002)(4326008)(8936002)(70206006)(508600001)(316002)(36756003)(70586007)(8676002)(14773001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2022 22:46:47.3885
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7899aab9-9199-401a-2120-08d9fd67b2ed
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT031.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5842
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

'commit 708978487304 ("drm/amdgpu/display: Only set vblank_disable_immediate when PSR is not enabled")'

Fixes: 92020e81ddbe ("drm/amdgpu/display: set vblank_disable_immediate for DC")

Kernel version to apply: 5.15.17+

[Why]
PSR currently relies on the kernel's delayed vblank on/off mechanism
as an implicit bufferring mechanism to prevent excessive entry/exit.

Without this delay the user experience is impacted since it can take
a few frames to enter/exit.

[How]
Only allow vblank disable immediate for DC when psr is not supported.

Leave a TODO indicating that this support should be extended in the
future to delay independent of the vblank interrupt.

Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 5ae9b8133d6d..76967adc5160 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1279,9 +1279,6 @@ static int amdgpu_dm_init(struct amdgpu_device *adev)
 	adev_to_drm(adev)->mode_config.cursor_width = adev->dm.dc->caps.max_cursor_size;
 	adev_to_drm(adev)->mode_config.cursor_height = adev->dm.dc->caps.max_cursor_size;
 
-	/* Disable vblank IRQs aggressively for power-saving */
-	adev_to_drm(adev)->vblank_disable_immediate = true;
-
 	if (drm_vblank_init(adev_to_drm(adev), adev->dm.display_indexes_num)) {
 		DRM_ERROR(
 		"amdgpu: failed to initialize sw for display support.\n");
@@ -3866,6 +3863,14 @@ static int amdgpu_dm_initialize_drm_device(struct amdgpu_device *adev)
 
 	}
 
+	/*
+	 * Disable vblank IRQs aggressively for power-saving.
+	 *
+	 * TODO: Fix vblank control helpers to delay PSR entry to allow this when PSR
+	 * is also supported.
+	 */
+	adev_to_drm(adev)->vblank_disable_immediate = !psr_feature_enabled;
+
 	/* Software is initialized. Now we can register interrupt handlers. */
 	switch (adev->asic_type) {
 #if defined(CONFIG_DRM_AMD_DC_SI)
-- 
2.25.1

