Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 186296E98F5
	for <lists+stable@lfdr.de>; Thu, 20 Apr 2023 17:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230483AbjDTP7c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Apr 2023 11:59:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjDTP7a (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Apr 2023 11:59:30 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on20618.outbound.protection.outlook.com [IPv6:2a01:111:f400:7ea9::618])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C549D94
        for <stable@vger.kernel.org>; Thu, 20 Apr 2023 08:59:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g2BlfANmQR478Y3Bb3gJqmny9B3UcJBmCrhsT9vJDJsxSpL+MP7vsBsT0DeNTvXT/ikV0aJiKRFbzk3jrL0BjeN0goKeFdLEF0lxUD+8c3Rc+9D0Uj1al6M3A9wMsdhRVWE2wqypV7vGjr/SWL2Fw1JceBap71usl0uIx9nJcPBvliV1AbDqZr/yVkbdDNes7iXfIw2TxdYvyOw/NollC/1AT7Ale26IGgmSRk3AkN6o6Jp9eQd7T+vAA5NdH+7DNrQs/sMC8vWmmtIgKvcdteANKZbjlLxOmWM/rU/flXQrp43mKt57EXSz/JotMYgJfrJfdKlPEFCdumjtt2p3BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gLCxxLj+J2a06+rguLbb5qkmegtV1Hzd0FE6TZB2Lzg=;
 b=VF1lLa0ZPLF6A2a41WN+NOLBtAsgUvw76mPgFe4llrPLSQudaJM2jyu207D0frVuVnHa6p0Uvi9hrJAgV7bO8jQ4oUFAsRErQMy/JITpKBAr80xftCyA8JSP7MGU7r3pm80sCD6xgzrlSjGosPNenYlJ0OjXzSbmLfJHurPcF3z1ToJnRJPh9QlX8pYruoZRvRyr9VyGUHSg2NoB6up0wnmHTx1f1StwXhl2lNW1i5tF7oMP0FPnNTBI6sqfxlMyJDPl9YUhtwk9vHAOr+qzatT92k3BPfEFOpJouctuMLZo3wyR4S4dIuy3WwVY10UuLOkM4slQk8Yp2twd1tzepA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gLCxxLj+J2a06+rguLbb5qkmegtV1Hzd0FE6TZB2Lzg=;
 b=HQUui6Sml+1G3Sln/NPpJXfDQafkY0qqP2KIz1j/wqM7l0DoHLgsuN0CRbW6YqYS/Ulf0VoZY4iav+OQ+VvFTCJ3/RcuU9ymoTPIOPViJbc8RROor4hQRcwemfwGEYpEGflmUUpGz51dfUFp7/BMKmgoi6Uo7s8tnmuB7yvDJgs=
Received: from BN0PR04CA0194.namprd04.prod.outlook.com (2603:10b6:408:e9::19)
 by CY5PR12MB6177.namprd12.prod.outlook.com (2603:10b6:930:26::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.21; Thu, 20 Apr
 2023 15:59:24 +0000
Received: from BN8NAM11FT096.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e9:cafe::9c) by BN0PR04CA0194.outlook.office365.com
 (2603:10b6:408:e9::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.25 via Frontend
 Transport; Thu, 20 Apr 2023 15:59:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT096.mail.protection.outlook.com (10.13.177.195) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6319.25 via Frontend Transport; Thu, 20 Apr 2023 15:59:24 +0000
Received: from hamza-pc.localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 20 Apr
 2023 10:59:23 -0500
From:   Hamza Mahfooz <hamza.mahfooz@amd.com>
To:     <amd-gfx@lists.freedesktop.org>
CC:     Hamza Mahfooz <hamza.mahfooz@amd.com>, <stable@vger.kernel.org>,
        Roman Li <Roman.Li@amd.com>
Subject: [PATCH v4] drm/amd/display: fix flickering caused by S/G mode
Date:   Thu, 20 Apr 2023 12:00:36 -0400
Message-ID: <20230420160036.130360-1-hamza.mahfooz@amd.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT096:EE_|CY5PR12MB6177:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c8683c7-70b3-4ac4-6040-08db41b83636
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MDicwTihXdtxTXwJPHbVTMKM7vo6PuBbchqY8t1Zcz2in9V1RzGQZWkx/Zzbg1t1klCHgJ++mwKUm/vS192HxM3EKZov2zhnbz7F+vPJJHjJ+P9XdXc96xF6YwxqmAvEjaIx3E7/+p6aDCwybzdmwAGLatUdw3613ZNkv3fnTHDf6rqdw6pnuu2eh0gGFgBkRKn2ekWn6s2hb4oIFNiaPxRnlwvBJC0m8EoeKzWbK3AGPvCqZgQVoJfDDfSyzGpCun0TBcqGnpSY5ugPuKfh5Drm4V0bydS/81UZ+H3DQQTW1Sadwuhi85Ig95UgirBte8YN3qaUNoIoBLdPID7s4v4Sc66ZlfnI31K36P6LzIt1DPOBRYtxnMEGYAFE9U2X8zBEEbBURr1q4Wd6/igcwPKyaufVTxzaB7FophKUtRYf6LAG2VOhNtcTMnS7aWmmm1+PfmISqwx/gg/dXpThj7ET3aG700KJUL/NRrtrDV4xQ77+js/4VS0D5lVeGoOTSHBfmrc46OyYDNPTvhu0ORMgXntGlEceLSLh/tMcdYrBf+EzhAZwy5kCBYbWJTfiQZsjv2HbJOiYUGyIkRZHNloIXsBDO979kEGUvFLBoGadyFckQhuaaz2fE5zqv7M07b6nVOGLwSI0AVctK/8m7lYLwLNhbQN/eDN6yuEDqcCm2yxu2tCeYJCOgCgXORGjqVwoQmaw+rnAbRPtLmLX0Q==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(136003)(396003)(376002)(451199021)(36840700001)(46966006)(40470700004)(5660300002)(40460700003)(44832011)(54906003)(478600001)(82740400003)(8936002)(40480700001)(41300700001)(8676002)(316002)(82310400005)(356005)(4326008)(81166007)(6916009)(70206006)(70586007)(1076003)(26005)(2906002)(186003)(16526019)(2616005)(36860700001)(36756003)(426003)(336012)(83380400001)(6666004)(47076005)(966005)(86362001)(36900700001)(16060500005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 15:59:24.1909
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c8683c7-70b3-4ac4-6040-08db41b83636
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT096.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6177
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Currently, on a handful of ASICs. We allow the framebuffer for a given
plane to exist in either VRAM or GTT. However, if the plane's new
framebuffer is in a different memory domain than it's previous
framebuffer, flipping between them can cause the screen to flicker. So,
to fix this, don't perform an immediate flip in the aforementioned case.

Cc: stable@vger.kernel.org
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2354
Reviewed-by: Roman Li <Roman.Li@amd.com>
Fixes: 81d0bcf99009 ("drm/amdgpu: make display pinning more flexible (v2)")
Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
---
v2: make a number of clarifications to the commit message and drop
    locking.
v3: use a stronger check
v4: drop mem_type
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index dfcb9815b5a8..76a776fd8437 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -7900,6 +7900,13 @@ static void amdgpu_dm_commit_cursors(struct drm_atomic_state *state)
 			amdgpu_dm_plane_handle_cursor_update(plane, old_plane_state);
 }
 
+static inline uint32_t get_mem_type(struct drm_framebuffer *fb)
+{
+	struct amdgpu_bo *abo = gem_to_amdgpu_bo(fb->obj[0]);
+
+	return abo->tbo.resource ? abo->tbo.resource->mem_type : 0;
+}
+
 static void amdgpu_dm_commit_planes(struct drm_atomic_state *state,
 				    struct dc_state *dc_state,
 				    struct drm_device *dev,
@@ -8042,11 +8049,13 @@ static void amdgpu_dm_commit_planes(struct drm_atomic_state *state,
 
 		/*
 		 * Only allow immediate flips for fast updates that don't
-		 * change FB pitch, DCC state, rotation or mirroing.
+		 * change memory domain, FB pitch, DCC state, rotation or
+		 * mirroring.
 		 */
 		bundle->flip_addrs[planes_count].flip_immediate =
 			crtc->state->async_flip &&
-			acrtc_state->update_type == UPDATE_TYPE_FAST;
+			acrtc_state->update_type == UPDATE_TYPE_FAST &&
+			get_mem_type(old_plane_state->fb) == get_mem_type(fb);
 
 		timestamp_ns = ktime_get_ns();
 		bundle->flip_addrs[planes_count].flip_timestamp_in_us = div_u64(timestamp_ns, 1000);
-- 
2.40.0

