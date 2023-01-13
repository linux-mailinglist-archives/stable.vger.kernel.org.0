Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5402B66A28E
	for <lists+stable@lfdr.de>; Fri, 13 Jan 2023 20:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbjAMTEB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Jan 2023 14:04:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbjAMTEA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Jan 2023 14:04:00 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2076.outbound.protection.outlook.com [40.107.237.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29BE2544F5
        for <stable@vger.kernel.org>; Fri, 13 Jan 2023 11:03:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aWDmJpTxsooJlkp/vio+InpaeqnX+RJQ71f1eUqOvvv1V7cS+xZM+F/2Ova/i/KyyuLgwYNaWJCYBGEIjad43E3HaLZMt2fvhPKgctL+sbmcHJZC/ZMA5w4Kk9CWXFCgOY+GiAO3c0pVeBr7gvWXZtSXp/KJCjL14ap0zHD34SDZMlxnQPEeNfoleNlRrV3SyHsfGkg66p3l5glcFttwBpbCcFJUlkgAoNYRk1YuZL4ZHJ8zCAjvBlt1yuHUfWj53ATTY4bAgIOEr+ZILaAYibPngOdGvVGOnysN5I9N9SsV+ogwPt8hgtXUWdNI25ZKWmJRTb/kLV4KRW49zXvtHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Al9e5O4FK9iShdN+000OwuQSbdFPFsF0OLda3TNCH7c=;
 b=ZNepkSZiUK2gClsH2hyIXphI1ype/75RVzhNeMb4bUJsOzQoCkKBZZ9aWjmi8Cd6SrzfYD3PHZ7ZZ0AEcQyR/7g5+uUSGWr3VFSETE9oj1bjLtvGdW0Dp3VdqXdBkDPDGhGKEqEqUlqBlTXOSS/VvBj62HfCfTJQt1nx+L5qxJj/x/iGCVUdVLxhjlkzyo/QsnAR+AQotfyUB5WbiG0WjWPwqELo9Of/vdgZ40YVcITODnmpJgvqJLXpPB4Re4zEjCIlr8Herg+YN+KTXpH/v3kefQrn2BsoxQios8f8sGqoZrXUfQIeB3pTWgkNc6LGfBblhQ6sCKZmzvjLsen0lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linuxfoundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Al9e5O4FK9iShdN+000OwuQSbdFPFsF0OLda3TNCH7c=;
 b=En8vzg8vX4no7puyWjPo09RhEDBsXynh3ip2gX71Sd3owJmxwAcEMp36DpY55GN2EjuTofDolNy1OJo1eH4onl9Dw3RIjprXpxQxuBJJYimvTu9qeP6qgjEDFIb0ao9O8FkmCgzZNGqHiys4amcNtuDNB+JTS10qLUM35I4euak=
Received: from MW4PR03CA0310.namprd03.prod.outlook.com (2603:10b6:303:dd::15)
 by BL1PR12MB5304.namprd12.prod.outlook.com (2603:10b6:208:314::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Fri, 13 Jan
 2023 19:03:54 +0000
Received: from CO1NAM11FT111.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:dd:cafe::ff) by MW4PR03CA0310.outlook.office365.com
 (2603:10b6:303:dd::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.16 via Frontend
 Transport; Fri, 13 Jan 2023 19:03:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT111.mail.protection.outlook.com (10.13.174.61) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6002.13 via Frontend Transport; Fri, 13 Jan 2023 19:03:53 +0000
Received: from tr4.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 13 Jan
 2023 13:03:20 -0600
From:   Alex Deucher <alexander.deucher@amd.com>
To:     <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
CC:     Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>,
        Yury Zhuravlev <stalkerg@gmail.com>,
        Guchun Chen <guchun.chen@amd.com>,
        "Asher Song" <Asher.Song@amd.com>
Subject: [PATCH] Revert "drm/amdgpu: Revert "drm/amdgpu: getting fan speed pwm for vega10 properly""
Date:   Fri, 13 Jan 2023 14:03:02 -0500
Message-ID: <20230113190302.2210187-1-alexander.deucher@amd.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT111:EE_|BL1PR12MB5304:EE_
X-MS-Office365-Filtering-Correlation-Id: ea2625d2-29e3-4251-0bf1-08daf598ea53
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Pv3qW4y/+A//qev5DYxUoSSk2Y6JNTCcgN8duaxO8SEDUNxjinoTVQRisnlTVKPEPUDBvCZms/oy4QpIuQfVRLPF2nWgecdDSIqYCVLjkR6ICOUnd2siuLIC2LRJ1d85U77GngXb+Noz7AmziKuMwpvUaDC/L7Wgl8gNOmbMCu42LOYT1YBCfhD8R+mEUChP+gohFk7Ip28iEASjrzWbnlrQQmDWVVRWmlCFBQWGY29CSTC1NUQScqAxt2+eKS6vrCVveELMf3Wb1Js4b0jVIK9t0TPXtW2jQateo2gioouVirSI696mHoUqSWtJ1tQRehuqSGwSCQXJdWflZJgCXgC6vYZng9qd+K6D3T9877+OFCwYWPu2LsubY3eOpc9OCmTjsmE0K0EuPurEshQ59XZCg1ytoAZHb6N5j3ULjVGij4YWSJNzWSMLfsID94ZBdB4FZAOnsiUx4b5yUGS8Rf4V96kWXYv98tmEIqIxmOvwxXH/I6FbZO8lKCAbbmMOGrMjzqT+DZmDBN3chSpNoaDF+WSwwfaDho6+GucgPJyhpaGn9ce/l61RyWNR1lUVxqu7ood24i+x1+Hq2fxRuHxj5zQnh/BbTFbxsBhsGPNv2er6NESO3TKuWr4MyPcnZlIrq7xI9M6mj1yXq+79LsnWmkQFTeFm6pxMXrbV65BQcnKsgBrVfZoZWuTZrxe16u+bVNfrpCddEjyTLVw67X3pNdpNnAvMA8aZQ0E7yP0=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(376002)(346002)(39860400002)(451199015)(46966006)(36840700001)(40470700004)(70206006)(8936002)(5660300002)(110136005)(54906003)(41300700001)(4326008)(2906002)(70586007)(316002)(8676002)(478600001)(7696005)(356005)(81166007)(426003)(82740400003)(186003)(82310400005)(26005)(16526019)(6666004)(36756003)(36860700001)(1076003)(336012)(47076005)(40480700001)(40460700003)(86362001)(2616005)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2023 19:03:53.9929
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ea2625d2-29e3-4251-0bf1-08daf598ea53
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT111.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5304
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 9ccd11718d76b95c69aa773f2abedef560776037.

The original commit 16fb4dca95daa ("drm/amdgpu: getting fan speed pwm for vega10 properly")
was reverted in commit 4545ae2ed3f2 ("drm/amdgpu: Revert "drm/amdgpu: getting fan speed pwm for vega10 properly"").
but the test that resulted in the revert was wrong and was fixed so the
revert was reverted in commit 30b8e7b8ee3b ("Revert "drm/amdgpu: Revert "drm/amdgpu: getting fan speed pwm for vega10 properly""").
That should have been the end of it, but then Sasha picked up the
original revert again and it was committed as 9ccd11718d76.  So drop
that commit so we get back to where we need to be.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Sasha Levin <sashal@kernel.org>
Cc: stable@vger.kernel.org # 6.1.x
Cc: Yury Zhuravlev <stalkerg@gmail.com>
Cc: Guchun Chen <guchun.chen@amd.com>
Cc: Asher Song <Asher.Song@amd.com>
---
 .../amd/pm/powerplay/hwmgr/vega10_thermal.c   | 25 +++++++++----------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_thermal.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_thermal.c
index dad3e3741a4e..190af79f3236 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_thermal.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_thermal.c
@@ -67,22 +67,21 @@ int vega10_fan_ctrl_get_fan_speed_info(struct pp_hwmgr *hwmgr,
 int vega10_fan_ctrl_get_fan_speed_pwm(struct pp_hwmgr *hwmgr,
 		uint32_t *speed)
 {
-	uint32_t current_rpm;
-	uint32_t percent = 0;
-
-	if (hwmgr->thermal_controller.fanInfo.bNoFan)
-		return 0;
+	struct amdgpu_device *adev = hwmgr->adev;
+	uint32_t duty100, duty;
+	uint64_t tmp64;
 
-	if (vega10_get_current_rpm(hwmgr, &current_rpm))
-		return -1;
+	duty100 = REG_GET_FIELD(RREG32_SOC15(THM, 0, mmCG_FDO_CTRL1),
+				CG_FDO_CTRL1, FMAX_DUTY100);
+	duty = REG_GET_FIELD(RREG32_SOC15(THM, 0, mmCG_THERMAL_STATUS),
+				CG_THERMAL_STATUS, FDO_PWM_DUTY);
 
-	if (hwmgr->thermal_controller.
-			advanceFanControlParameters.usMaxFanRPM != 0)
-		percent = current_rpm * 255 /
-			hwmgr->thermal_controller.
-			advanceFanControlParameters.usMaxFanRPM;
+	if (!duty100)
+		return -EINVAL;
 
-	*speed = MIN(percent, 255);
+	tmp64 = (uint64_t)duty * 255;
+	do_div(tmp64, duty100);
+	*speed = MIN((uint32_t)tmp64, 255);
 
 	return 0;
 }
-- 
2.39.0

