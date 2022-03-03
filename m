Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FCA04CC969
	for <lists+stable@lfdr.de>; Thu,  3 Mar 2022 23:47:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236822AbiCCWrr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Mar 2022 17:47:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231805AbiCCWrq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Mar 2022 17:47:46 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2050.outbound.protection.outlook.com [40.107.93.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7664516BFA8
        for <stable@vger.kernel.org>; Thu,  3 Mar 2022 14:47:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mwVxXQ8VreHbhewAvewMB7MrB+ip+xEod1UHjsIKoEzuGPZbnnnK80WhTg62V6coysfSxX7D0JY0KkQC4eEMxtb3Q1wekMZI7FSfvpOiHEhMhzWsWD6b88G8RJVWiGJG6HZJrW9wR4hWEHVCrexCbvUJeKfGhAloFikleQG8tSIF5R/ivbuZZYeco4fIviLdpzFnP2khJ9B4asYZIPUTriKSdRM5py3Q5qh0hbfDBI/61myVJqU2Igbfljcf/ODAhuTwgl5GmFAvczWgAnf7avDCejLLKYNvS34T8EQ3xv3W7/Zbdnep7OR70reDCUMU6BaSPCihCN4sJnU8dHaHgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bi7un6YXliFcQtuFFhgV8QZzs60muA3GWjFwurT7/t8=;
 b=NOMmIpFvvkXOdSJThTvT344rrzC/AT6TskZMWNolgzs8zrG4oUVeJ1A0r9KST93b5AM4G2Ygkf1rrs0Nb0mC5iH6ciPFfKvmfJMjFV/5yztefHMtpE2LUQ8wPHdAdG2C+M8+UXO2D4Eu5RrWHptWjGgHb+gFthGzvz2y3VfrhePO88yolFX7Gmn5sZPAlruJ1YzB1Zz2kRHJSkFSwjMy1ffRllBb+/LVFCxoG/uZuXc2xCe3YEfQGKBlyXq0kfArFbnA8SX5QOCph0iMe0p55HWrCFw2LCQU3CUKOyt4S+axKhkZ2rBhL3cGHGO919bEuHCwAQPJv6jHL8egPoGmlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bi7un6YXliFcQtuFFhgV8QZzs60muA3GWjFwurT7/t8=;
 b=Spz0DeIiCa4NYrCApXDzN12MGt+8rywHoI9NjtrJt/HMZkBkXHlLvniDSFe7YNLFJx3BS2wiH9fOBtXXEVYB9uIu12qZEOplSk7HKWJfpSSd1WnuvesqXJAEPaUnyUJkiP7mrR3rlqhW+oAxGkc71qRGkxDrcys49LiSLlPgXUw=
Received: from DM5PR20CA0010.namprd20.prod.outlook.com (2603:10b6:3:93::20) by
 DM8PR12MB5431.namprd12.prod.outlook.com (2603:10b6:8:34::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5038.14; Thu, 3 Mar 2022 22:46:53 +0000
Received: from DM6NAM11FT016.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:93:cafe::ca) by DM5PR20CA0010.outlook.office365.com
 (2603:10b6:3:93::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.13 via Frontend
 Transport; Thu, 3 Mar 2022 22:46:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT016.mail.protection.outlook.com (10.13.173.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5038.14 via Frontend Transport; Thu, 3 Mar 2022 22:46:53 +0000
Received: from doryam3r2rack03-34.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.18; Thu, 3 Mar 2022 16:46:51 -0600
From:   Richard Gong <richard.gong@amd.com>
To:     <stable@vger.kernel.org>
CC:     <richard.gong@amd.com>,
        =?UTF-8?q?Michel=20D=C3=A4nzer?= <mdaenzer@redhat.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 2/2] drm/amd/display: For vblank_disable_immediate, check PSR is really used
Date:   Thu, 3 Mar 2022 16:46:25 -0600
Message-ID: <20220303224625.2108948-2-richard.gong@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220303224625.2108948-1-richard.gong@amd.com>
References: <20220303224625.2108948-1-richard.gong@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6588f529-f874-4e32-4f05-08d9fd67b67d
X-MS-TrafficTypeDiagnostic: DM8PR12MB5431:EE_
X-Microsoft-Antispam-PRVS: <DM8PR12MB54319DC1B0041794CCDFF05B95049@DM8PR12MB5431.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vXgQ0KzMchEUbruj5n1FJwikLA3hdxWpw04G6bI2/g0O3uxqG6O6VcCUDDULaa45q9FBNO1M0KBsfLzVoxOE5AwdpQduA4qkleLaApG/ZX3zmDpSKSm3hf8m1YKkgnSA4vg7eFVuIxUqObZPDJehS3QTeEw60jgsf7/RUSZyvq9Ss39R6dm27I/3wlcMQEUYGNbCWnX4PvXfq0P65WoNrr3MtaBDXm0NxtjUiyWSiqGEPHKfUQ2NQ4WYAyTR7zAovGs3tQLQUbG/RQtgDElzkxkZKcchiQ1Abqfie9ScujWRBlDFzCCzEuqgNdV01ktOo51JgOLhNk2KRfqdL72x/W5wgDbJ0om4LJUF24Y4CadyyJk5E/j382F2DozHpXWCj+LUEwqNWVVVskgsAmxq9U1pa8vP4hOI79faEkMTxOw3wCd2P7syae/1EN2uqo79qUeJHJ/My2KovFfvONlVvyt0mi6hjeAiyP4PXXOny4y6Qt14ZGEG+aRlM591sqZ3jMiE0lxzVKm6EsX3IjRdN8qEKaKHQb5de0Nqn+da1YNdz49MEDUdp2N5xWpB1g5Aq4dwAyLCqvg5j3bfeF4XZf+FWHSF7HhM0ryangTQIcZhD5vL1qEXv8oo7SE9D7Z8aaeeLRJrWawioDPDyY6j5cTzxhp0ddRBaVtKjms5Hb254S1k+wQ3FPjYe6Qj0Uq50qa66B/pkdNPeS7aKQD6+q3ddmaZeV6wmW/jrsieH5U=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(426003)(66574015)(36860700001)(7696005)(2906002)(26005)(6666004)(16526019)(44832011)(336012)(82310400004)(83380400001)(1076003)(47076005)(2616005)(36756003)(4326008)(508600001)(6916009)(54906003)(316002)(40460700003)(86362001)(70206006)(70586007)(8676002)(8936002)(5660300002)(186003)(81166007)(356005)(14773001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2022 22:46:53.3666
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6588f529-f874-4e32-4f05-08d9fd67b67d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT016.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5431
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michel Dänzer <mdaenzer@redhat.com>

'commit 4d22336f9039 ("drm/amd/display: For vblank_disable_immediate, check PSR is really used")'

Fixes: 708978487304 ("drm/amdgpu/display: Only set vblank_disable_immediate when PSR is not enabled")

Kernel version to apply: 5.15.17+

Even if PSR is allowed for a present GPU, there might be no eDP link
which supports PSR.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Michel Dänzer <mdaenzer@redhat.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c   | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 76967adc5160..cd611444ad17 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -3812,6 +3812,9 @@ static int amdgpu_dm_initialize_drm_device(struct amdgpu_device *adev)
 	}
 #endif
 
+	/* Disable vblank IRQs aggressively for power-saving. */
+	adev_to_drm(adev)->vblank_disable_immediate = true;
+
 	/* loops over all connectors on the board */
 	for (i = 0; i < link_cnt; i++) {
 		struct dc_link *link = NULL;
@@ -3858,19 +3861,17 @@ static int amdgpu_dm_initialize_drm_device(struct amdgpu_device *adev)
 				update_connector_ext_caps(aconnector);
 			if (amdgpu_dc_feature_mask & DC_PSR_MASK)
 				amdgpu_dm_set_psr_caps(link);
+
+			/* TODO: Fix vblank control helpers to delay PSR entry to allow this when
+			 * PSR is also supported.
+			 */
+			if (link->psr_settings.psr_feature_enabled)
+				adev_to_drm(adev)->vblank_disable_immediate = false;
 		}
 
 
 	}
 
-	/*
-	 * Disable vblank IRQs aggressively for power-saving.
-	 *
-	 * TODO: Fix vblank control helpers to delay PSR entry to allow this when PSR
-	 * is also supported.
-	 */
-	adev_to_drm(adev)->vblank_disable_immediate = !psr_feature_enabled;
-
 	/* Software is initialized. Now we can register interrupt handlers. */
 	switch (adev->asic_type) {
 #if defined(CONFIG_DRM_AMD_DC_SI)
-- 
2.25.1

