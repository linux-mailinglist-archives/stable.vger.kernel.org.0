Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C412D6EA035
	for <lists+stable@lfdr.de>; Fri, 21 Apr 2023 01:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231843AbjDTXuj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Apr 2023 19:50:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbjDTXui (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Apr 2023 19:50:38 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2083.outbound.protection.outlook.com [40.107.93.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A90E42D4C
        for <stable@vger.kernel.org>; Thu, 20 Apr 2023 16:50:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lWYLkEXv2T55XD2qjpvtwiZnFGRnW0x3IofMJ5jhbl8y0nTnN21H61ggRSp4ahFyhE/TVcbZtGx+dDsHo3/wr2dhkfel9/Dsumr8t9Ots87PdvyJQvKcYsu2q5tb3WII8kXGks/J1KiPyKWUT9682Dy6yc7IG3j6ZDxDeNRqwKqTsQLvdmOpjdI80xpRbLONnmpYOnobk/g6S+2OPBT88TlNsLcb4V7xSTwpK42I7vy3qtP6gTtOIhUl22lu1rAJJvyhlgfrqi557kIKk0vL8YCTYw/VpyGHj/HtG3zsytOfYFglBAouSNzgoP3gDpCCOltEk4Ui+PjJI8PMFTC/2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rQ20VZsQxCTma6cVX6Fv06zdEfAhjCzTwPHd3fKspHk=;
 b=oAWaZc6my3teTRG8n3txjle/jZ1mxqTXKOZW7asMhBbAUFEAZGgODxz6bedz629arfNA4+FHwdeHNY6nprynm5mJVTPm6I4hCEkmmOjG6bZPjs8H/0dWjOIfcCYAXGN16MgOvCHgz4hjhX+g1VimbP8uP7uAJ8DVy6/y64R1kvPhYMz24yabwDEGZp2yM2nUPcKkc7RHSKkOgextrtklPyH+dI1q3xlx1Pni4bu/UWo3bNjyhnQlZEe70Wst8SDTfdchnJcc2Kt87Knyjuu2v2SEYJy3U5rdDyZ7l61udQeiI29QbWBvAOOf57abCZX7OGo2ewuauX/CQEdL8hTggA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rQ20VZsQxCTma6cVX6Fv06zdEfAhjCzTwPHd3fKspHk=;
 b=20N3N4AqJTzq7Hv9BEwj3+4Bxxk35vzdWkEFwaX3tEgMHH6oA04ItIQ5CTjNIxBn+gWff5KHPHYhakva0RJ6w23PyQ0X6GJqKEpLcnYsGYg6aq5NKiihcBDSycltA9Bqpa6+HKkERaU+9b3BwSSA2ofToN94T9ErVOpEyhepnS8=
Received: from DM6PR02CA0158.namprd02.prod.outlook.com (2603:10b6:5:332::25)
 by BN9PR12MB5257.namprd12.prod.outlook.com (2603:10b6:408:11e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Thu, 20 Apr
 2023 23:50:33 +0000
Received: from DM6NAM11FT004.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:332:cafe::a6) by DM6PR02CA0158.outlook.office365.com
 (2603:10b6:5:332::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.25 via Frontend
 Transport; Thu, 20 Apr 2023 23:50:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT004.mail.protection.outlook.com (10.13.172.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6319.22 via Frontend Transport; Thu, 20 Apr 2023 23:50:33 +0000
Received: from smtp.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 20 Apr
 2023 18:50:31 -0500
From:   Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
To:     <amd-gfx@lists.freedesktop.org>
CC:     <Harry.Wentland@amd.com>, <Sunpeng.Li@amd.com>,
        <Bhawanpreet.Lakha@amd.com>, <Rodrigo.Siqueira@amd.com>,
        <Aurabindo.Pillai@amd.com>, <qingqing.zhuo@amd.com>,
        <roman.li@amd.com>, <wayne.lin@amd.com>, <stylon.wang@amd.com>,
        <solomon.chiu@amd.com>, <pavle.kotarac@amd.com>,
        <agustin.gutierrez@amd.com>, Alan Liu <HaoPing.Liu@amd.com>,
        <stable@vger.kernel.org>, Wayne Lin <Wayne.Lin@amd.com>
Subject: [PATCH 14/21] drm/amd/display: Fix in secure display context creation
Date:   Thu, 20 Apr 2023 17:49:44 -0600
Message-ID: <20230420234951.1772270-15-Rodrigo.Siqueira@amd.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230420234951.1772270-1-Rodrigo.Siqueira@amd.com>
References: <20230420234951.1772270-1-Rodrigo.Siqueira@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT004:EE_|BN9PR12MB5257:EE_
X-MS-Office365-Filtering-Correlation-Id: a3ff75ef-2116-4cde-d277-08db41fa07fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OWaWIMqSc+RQnA0DHJhw1nJ4AA9tZqmbkksICHw8zYH9ylUSt/6CCwhxT7CGt+JcOyioHOhID95OIG7Uv7NthX5uPWZREv7y8rXUnA66uVwXZQCLp9KW++QoHH0j98CbrW7CDhdlOxYaIS3tY0LR9z2vL4wiPGmOOO68EPU/w9uPa0CFnbBNtyRqG3Sfk7OegjDMXv2NMKbwl1Gfbl15utIG6g6BZk+aaTgwxSuWGpv53LMuNp5ewFmimU4f1vpwuuTGoDq9uJTPT47AdWrC6jAS0F3/FnxiW+hcJfs4iMdmfk2c889btvQ215W11+3IAZifpudcfGt3GawZo//Z9MppWjpS7P3a84YIAdThxS5gS+10j1CTaha4qiahSky6d0uomAZhOdU6z0G8SzbAuvq99la4ZpOOsDXupjoD6Hgc13QWO+DytxYXs39c6xKu1QVvRtqflsnaEoG1kMLvAUw4skMQeXPSb5et4iqY5JNa5pOC98Ozal2Or0NMWk/z37XmdnS9u7uLYHKJhbPWO2rAuHThcjyOOX4ZyOAQGh+FmSkRf5kbvM/5QaB3GfLxYBlqDT34Myw3hQ+HsrZJOURi4m4xPLQXr41W9LiX/wBV3mLO3SzNzAkT6bH3N31i/MsZDEFJ5peGwCER9W3nDX/yfO0yT22mGCzcyujCnFsy925dcCbCUkkODS3+47Kecn4e6KsiwUKL1aD1TMJshvFEA4wxyzyhFqLN24BQUgo=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(376002)(346002)(136003)(451199021)(36840700001)(46966006)(40470700004)(40460700003)(2906002)(8936002)(8676002)(86362001)(356005)(81166007)(5660300002)(82310400005)(36756003)(41300700001)(40480700001)(1076003)(6666004)(26005)(54906003)(82740400003)(478600001)(2616005)(36860700001)(47076005)(83380400001)(426003)(336012)(186003)(16526019)(316002)(70586007)(6916009)(4326008)(70206006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 23:50:33.3758
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a3ff75ef-2116-4cde-d277-08db41fa07fc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT004.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5257
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Liu <HaoPing.Liu@amd.com>

[Why & How]
We need to store CRTC information in secure_display_ctx, so postpone
the call to amdgpu_dm_crtc_secure_display_create_contexts() until we
initialize all CRTCs.

Cc: stable@vger.kernel.org
Reviewed-by: Wayne Lin <Wayne.Lin@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alan Liu <HaoPing.Liu@amd.com>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c     | 11 +++++------
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crc.h |  2 +-
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 4db4f5a371a5..48c94e7c3839 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1775,12 +1775,6 @@ static int amdgpu_dm_init(struct amdgpu_device *adev)
 
 		dc_init_callbacks(adev->dm.dc, &init_params);
 	}
-#if defined(CONFIG_DRM_AMD_SECURE_DISPLAY)
-	adev->dm.secure_display_ctxs = amdgpu_dm_crtc_secure_display_create_contexts(adev);
-	if (!adev->dm.secure_display_ctxs) {
-		DRM_ERROR("amdgpu: failed to initialize secure_display_ctxs.\n");
-	}
-#endif
 	if (dc_is_dmub_outbox_supported(adev->dm.dc)) {
 		init_completion(&adev->dm.dmub_aux_transfer_done);
 		adev->dm.dmub_notify = kzalloc(sizeof(struct dmub_notification), GFP_KERNEL);
@@ -1839,6 +1833,11 @@ static int amdgpu_dm_init(struct amdgpu_device *adev)
 		goto error;
 	}
 
+#if defined(CONFIG_DRM_AMD_SECURE_DISPLAY)
+	adev->dm.secure_display_ctxs = amdgpu_dm_crtc_secure_display_create_contexts(adev);
+	if (!adev->dm.secure_display_ctxs)
+		DRM_ERROR("amdgpu: failed to initialize secure display contexts.\n");
+#endif
 
 	DRM_DEBUG_DRIVER("KMS initialized.\n");
 
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crc.h b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crc.h
index 935adca6f048..748e80ef40d0 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crc.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crc.h
@@ -100,7 +100,7 @@ struct secure_display_context *amdgpu_dm_crtc_secure_display_create_contexts(
 #else
 #define amdgpu_dm_crc_window_is_activated(x)
 #define amdgpu_dm_crtc_handle_crc_window_irq(x)
-#define amdgpu_dm_crtc_secure_display_create_contexts()
+#define amdgpu_dm_crtc_secure_display_create_contexts(x)
 #endif
 
 #endif /* AMD_DAL_DEV_AMDGPU_DM_AMDGPU_DM_CRC_H_ */
-- 
2.39.2

