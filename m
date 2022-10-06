Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD86E5F7041
	for <lists+stable@lfdr.de>; Thu,  6 Oct 2022 23:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231693AbiJFV1s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Oct 2022 17:27:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232500AbiJFV1r (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Oct 2022 17:27:47 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2061.outbound.protection.outlook.com [40.107.223.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF167BA240
        for <stable@vger.kernel.org>; Thu,  6 Oct 2022 14:27:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FyJRorHMiEtPQr6kgj16Rnd0Eq3KutkfR2tENb0fsLc7CR2o3Yx5w/2E0PcLW2l+dlQ3HJqDy6FmrV6b55KG+FndAexga7YI6f7SdVYaHdqJ+QntDEx8NTTyCU7dNgIC+4Zmru7rxU/iNDBFk3EKm0Ibz0w4iKp14/pqeegHqNDH4akWUTENibI3ecgERHZkf04S11Ue5g1YDfYWfmCYv7GnG39/ByPYJl4K7RJzTONZmSeImIC36gFBoFPBxxrOzv8xRbNVvcdg9tRgfwWQqmy4UYCtL2FQ25xzXW357G4C+weLSOCieo9Y3jhlXRKYGeEpCqCt8ZjTvMq1rphf0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yprDSQuRdaiIWTdJhqZJhjvDt/4JrfW2o+V8PdKXyko=;
 b=M5d8MTsD62NSA2j9CuJLO9yMiTHKux++AvD+Q+7lzsMofHLlnBsjle1Xq7pPh/Z+i2paVpaW1q2WV8qemguMt9VdInX7LOg5V4/4s9o5OnvImPIl9SNokgta48f4wq6e1Lycx1akQIk+nukmvAReArGLIlaj/GJGE8RKBsqY1psANH+ieQwUhCkqm5CJrvoWGrGWbnW+FM5q1VniUr8guaEdzJ5bxYqUKXf14WXkTMgjGZuActY3rcYw+LveeKfrmt7inld/QsTj6j6/i3xHkeAZCvo7jkW7XLEm3i5U6uC89GVewziK74jS6i9bOKJ/SEtSQWNSgQU/5mwBdcBLRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yprDSQuRdaiIWTdJhqZJhjvDt/4JrfW2o+V8PdKXyko=;
 b=RequoDbAVPhzVFS3Sf2wpSbPyIQ2soMoBVmkdQ1CkhkOH/lp5XX+BNiLeI3fV9Ob3SFj3Sm8UgofZp8/J3a5RF1N19NRKCNh4Yru8L4I7v515j+ZaGa5CM1zj4fvrTgz6+srzlXndu/rHB2D/2f59OBAABWS/IiVaIt7mhxwYNA=
Received: from BN9PR03CA0096.namprd03.prod.outlook.com (2603:10b6:408:fd::11)
 by SN7PR12MB7226.namprd12.prod.outlook.com (2603:10b6:806:2a9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Thu, 6 Oct
 2022 21:27:43 +0000
Received: from BN8NAM11FT028.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fd:cafe::77) by BN9PR03CA0096.outlook.office365.com
 (2603:10b6:408:fd::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.29 via Frontend
 Transport; Thu, 6 Oct 2022 21:27:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT028.mail.protection.outlook.com (10.13.176.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5709.10 via Frontend Transport; Thu, 6 Oct 2022 21:27:43 +0000
Received: from localhost.localdomain (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Thu, 6 Oct
 2022 16:27:40 -0500
From:   Qingqing Zhuo <qingqing.zhuo@amd.com>
To:     <amd-gfx@lists.freedesktop.org>
CC:     <Harry.Wentland@amd.com>, <Sunpeng.Li@amd.com>,
        <Bhawanpreet.Lakha@amd.com>, <Rodrigo.Siqueira@amd.com>,
        <Aurabindo.Pillai@amd.com>, <qingqing.zhuo@amd.com>,
        <roman.li@amd.com>, <wayne.lin@amd.com>, <stylon.wang@amd.com>,
        <solomon.chiu@amd.com>, <pavle.kotarac@amd.com>,
        <agustin.gutierrez@amd.com>, Fangzhi Zuo <Jerry.Zuo@amd.com>,
        Roman Li <Roman.Li@amd.com>,
        Mark Broadworth <mark.broadworth@amd.com>,
        <stable@vger.kernel.org>
Subject: [PATCH 10/23] drm/amd/display: Validate DSC After Enable All New CRTCs
Date:   Thu, 6 Oct 2022 17:26:37 -0400
Message-ID: <20221006212650.561923-11-qingqing.zhuo@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221006212650.561923-1-qingqing.zhuo@amd.com>
References: <20221006212650.561923-1-qingqing.zhuo@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT028:EE_|SN7PR12MB7226:EE_
X-MS-Office365-Filtering-Correlation-Id: c5cfb104-502c-47d8-f9df-08daa7e19afc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nbcR5JH2PoqhyXL+2MT3Cwpkn9DFxIKRUhy4lu/XtgAx6eUWCY02qEuO2c1pPF99OCS1oXlRwU9uEKKIfTNsie9osZTsSxopKAcZAF5+pY4sHzE7iiL/oQ9X4dyUCfbioFWNI/nItiCoNy1LaEPlMZ5b6db4uidkMgt2tXycmnHnoLLPaDyCqhnwIOaQFbOtyeP9NTLH0Tjgl7DvWys6xmAXhFiFAL9QaVQjCIvnr2gYC8PjvfwDvhq9p8xEpmF9SqtpB1fqlaMegRUyi1zwwnffcmA/bvbhtkCwrPvh+MQgMGS0vgADzAsXrN2R1uAYcw3dP9jlF7Mr2VBNnmVev1M9Q6MMlmh+38LmNmDNYYLj/3DVIDheInqi+zB1K+j0F41AChcmdwq519/JCmzlsa+VCkc3KdxiZnJv9Gbv9Ni+bLWIlZzlwMqd6FvUA0Jga4qOY3+LSFHDO5e1rhcIEy7j1UgdQUBfRu3bwjkME5Bu5zPwgA0/YEgtmbXEH0dzc0PQQElnoy0cwWz5BsB4XeCE4bPE8yVXWQ1NSBMIaDlzuQzX9m66X7Cx6bUw9Eke8ec/VghSkoX9MzHNIWopyoixBeWVqbJvMzI/XpGKxEYw+OFAxYUWhJJ9m+ddTS1+hiYTlVmCZQwzoZCmfD1NcnvNnqOuFLMF/XRnkto39OrDFNRIYEyaH6v06smRCfjcd7hMiZbRLWelph2gQI1e/wYG77trJV8l3L7/JtY7rnVhUKPtJ6umdv6djV1cnDvBPrtqJ1cu3WTyGhYE3Y2AK3p4LztfwYUcSrV86aM2GHasPOrdGbfdTDepmxiGOV05YzshhG1rmbmxPPpZiNiViCpE3nRm6O6vAA32ds9HPQ8=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(396003)(39860400002)(376002)(451199015)(40470700004)(46966006)(36840700001)(81166007)(8676002)(36756003)(4326008)(54906003)(40480700001)(356005)(6916009)(82310400005)(426003)(40460700003)(47076005)(2616005)(70586007)(16526019)(36860700001)(1076003)(186003)(336012)(83380400001)(478600001)(6666004)(82740400003)(26005)(86362001)(316002)(70206006)(8936002)(15650500001)(44832011)(41300700001)(5660300002)(2906002)(15273001)(17423001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2022 21:27:43.5315
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c5cfb104-502c-47d8-f9df-08daa7e19afc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT028.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7226
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fangzhi Zuo <Jerry.Zuo@amd.com>

Before enabling new crtc, stream_count in dc_state does not sync with
that in drm_atomic_state. Validating dsc in such case would leave
newly added stream not jointly participating in dsc optimization with
existing streams, but simply using default initialized vcpi all the time
which gives wrong dsc determination decision.

Consider the scenaio where one 4k60 connected to the dock under dp-alt mode.
Since dp-alt mode is 2-lane setup, stream 1 consumes 63 slots with dsc needed.
Then hook up a second 4k60 to the dock.
stream 2 connected with 65 slot initialized by default without dsc.
dsc pre validate will not jointly optimize stream 2 with stream 1 before crtc 2 added
into the dc_state. That leads to stream 2 not getting dsc optimization,
and trigger atomic_check failure all the time, as 65 > 63 limit.

After getting all new crtcs added into the state, stream_count in dc_state
correctly reflect that in drm_atomic_state which comes up with correct dsc decision.

Fixes: 71be4b16d39a ("drm/amd/display: dsc validate fail not pass to atomic check")
Reviewed-by: Roman Li <Roman.Li@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Fangzhi Zuo <Jerry.Zuo@amd.com>
Tested-by: Mark Broadworth <mark.broadworth@amd.com>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 17c3daac837a..63f076a46260 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -9408,10 +9408,6 @@ static int amdgpu_dm_atomic_check(struct drm_device *dev,
 				}
 			}
 		}
-		if (!pre_validate_dsc(state, &dm_state, vars)) {
-			ret = -EINVAL;
-			goto fail;
-		}
 	}
 #endif
 	for_each_oldnew_crtc_in_state(state, crtc, old_crtc_state, new_crtc_state, i) {
@@ -9545,6 +9541,15 @@ static int amdgpu_dm_atomic_check(struct drm_device *dev,
 		}
 	}
 
+#if defined(CONFIG_DRM_AMD_DC_DCN)
+	if (dc_resource_is_dsc_encoding_supported(dc)) {
+		if (!pre_validate_dsc(state, &dm_state, vars)) {
+			ret = -EINVAL;
+			goto fail;
+		}
+	}
+#endif
+
 	/* Run this here since we want to validate the streams we created */
 	ret = drm_atomic_helper_check_planes(dev, state);
 	if (ret) {
-- 
2.25.1

