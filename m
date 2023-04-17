Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06D906E5218
	for <lists+stable@lfdr.de>; Mon, 17 Apr 2023 22:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbjDQUvO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 16:51:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjDQUvN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 16:51:13 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2081.outbound.protection.outlook.com [40.107.92.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A96261BE6;
        Mon, 17 Apr 2023 13:51:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UjK14ZHPln6AExWIZaz1oGaeaMxr0H5ZO3u7DEwdWueHAapWqHI8LLqW9DmKWM8+oRiPdDqrB+3EUksX17HxR9vadiKj6ROvzaXvzdY3UESqfJjjEOQHhBMqqdoyN64XbibJgvOXUqozpnNt4FM2bBcoU9QhFGtJOmdSGGVlIJUAL28EovwxahEN2EKpLU8bcyMyPU8JDiVnazpgU7EOiB0/ovchT8c9DYlpgRoNj9vYlbLryNi8/mSYop0sFLUQiTbo9RdUWxJiQ9O6tVe/lPxySv1HfoSYPp+I4VQyDENymQ9Ba4oN3GBKez3I9GkyhCzD7PRsmzC7/oHwj1lOTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K0GsZF7y+bnHqgUYW5tKSxc5X4Zu08FT9hlgc1adet4=;
 b=asQLXyLKn0WrfEhQwF42e8MyYKpa5YrGAXeoJr8sg+81utmPrlXGRzLLxGrbN0GynjqLnfgPd4BXYXu2KIdI0F1j8+MQTG+oT7TDCD6xFr5QJ6MGtOyThRgfBM/O7Nc7TTNt40b9/6mcNIs9u/zYcYatl9Ow1415Epv/OrSnO2IfxLOX6v4HEecBssv0cTud+j+LeyPSs+0B+s1mbps874yqP/rH80gh50uLkv/ymyEPCJnu5eYQ6Sxe8CRNmWgbJPDE646AOHMNsBfslk6jorWgn4td++dejRXyP+GuLs6kXW/kyZrSAacw4zu4IqWjFak5JTAEsPMxxiBWXv9J2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.freedesktop.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K0GsZF7y+bnHqgUYW5tKSxc5X4Zu08FT9hlgc1adet4=;
 b=G4YOd2mYGeS4IhMqF5dg+xGia7twuBpbNcAlEZfzhWI5/XzHxsc408MTiv4ePu2W4t65CbAIJ7yENghMFl1aYHEa5lVsVhoIsTh02WvKsSvaNNccvQHHGwBJ9EPFlKDVfOENO1cybf8JX3W5UPCJd1kmbP1DSeZl4e9dgctXyrg=
Received: from CY5PR15CA0250.namprd15.prod.outlook.com (2603:10b6:930:66::24)
 by CYYPR12MB8656.namprd12.prod.outlook.com (2603:10b6:930:c3::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Mon, 17 Apr
 2023 20:51:09 +0000
Received: from CY4PEPF0000B8EB.namprd05.prod.outlook.com
 (2603:10b6:930:66:cafe::95) by CY5PR15CA0250.outlook.office365.com
 (2603:10b6:930:66::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.46 via Frontend
 Transport; Mon, 17 Apr 2023 20:51:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000B8EB.mail.protection.outlook.com (10.167.241.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6340.5 via Frontend Transport; Mon, 17 Apr 2023 20:51:09 +0000
Received: from hamza-pc.localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 17 Apr
 2023 15:51:07 -0500
From:   Hamza Mahfooz <hamza.mahfooz@amd.com>
To:     <amd-gfx@lists.freedesktop.org>
CC:     Hamza Mahfooz <hamza.mahfooz@amd.com>, <stable@vger.kernel.org>,
        "Harry Wentland" <harry.wentland@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        "Rodrigo Siqueira" <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Hersen Wu <hersenxs.wu@amd.com>,
        Stylon Wang <stylon.wang@amd.com>,
        Luben Tuikov <luben.tuikov@amd.com>,
        <dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] drm/amd/display: fix flickering caused by S/G mode
Date:   Mon, 17 Apr 2023 16:52:19 -0400
Message-ID: <20230417205220.420676-1-hamza.mahfooz@amd.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000B8EB:EE_|CYYPR12MB8656:EE_
X-MS-Office365-Filtering-Correlation-Id: e8c7a34b-f030-41a8-93ae-08db3f8578bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aYhbqXmYldpAGk7oizbPPWmSNNVNgV3tdwyoTF2CaJzIIzOHJX2Z/GaNGgqNsa8/QUQi2YqlD28Aegjd4GnOPzZ4GUmKM3bC6g/qJPC71qe9uqlJ7QxEJJNBAMK9OGpjMtUkCez7Rwp+K0Mvq0StBgMfa7PWoHUxBL3nGT+snyloxKZMXrNbMh4N2S1u2CA6GU6oZm2dJ9aigdKTKYlB3iqTn96j3d6UxloOhbsMw64LNnSy/U7HLHRBJK6yIk35zsvdI6I0G4GwGMwDItGYSaW9DBLBnpxqkvUuMuq5VpRAuiR0liTnxCR2KPMQ1SShJBpaCcj/xPggLich98mPcUIDd/YzrU6//XsCEcUw4uuQEsfTMWpjVug49kew9P4ESiKHaYI3KKpUuZIyf798tExXls03jIARphFlVbf5Q5ivWW6InakL7qdHFn3+27kKLGP04uuDyY5fDEQkOofkzes5eqDaa5k2HO8AlAYvgvrAdLnt3sHuArtpil2cFkAQd3GOFWQTQ4gZwR2N3gPStITOYeJ1XAyq8J0bjE1mk3CHhWd8Kcl9cSCeNlKDKT84Gydg1K9QHHtkmQAtFVXdWuvekxY/u4d/5o+VcNpYtEmuth55AyP860FdBg2BmYTVOgMjA+bveTYFAJi60kuwOkpnlKgV8IVxp6K2o9oh+sZxdbtJpBvAxsidwlfOoebzpmgBo/LT38RaLLaScyLo4w==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(136003)(39860400002)(376002)(451199021)(46966006)(36840700001)(40470700004)(1076003)(26005)(82740400003)(356005)(316002)(41300700001)(81166007)(40460700003)(186003)(16526019)(478600001)(82310400005)(36756003)(6666004)(54906003)(966005)(70586007)(70206006)(86362001)(40480700001)(6916009)(4326008)(2616005)(36860700001)(5660300002)(8936002)(8676002)(47076005)(2906002)(83380400001)(426003)(44832011)(336012)(36900700001)(16060500005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2023 20:51:09.0853
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e8c7a34b-f030-41a8-93ae-08db3f8578bd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000B8EB.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8656
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
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
Fixes: 81d0bcf99009 ("drm/amdgpu: make display pinning more flexible (v2)")
Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
---
v2: make a number of clarifications to the commit message and drop
    locking.
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c    | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index da3045fdcb6d..fd1b323f0e85 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -7897,6 +7897,13 @@ static void amdgpu_dm_commit_cursors(struct drm_atomic_state *state)
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
@@ -7916,6 +7923,7 @@ static void amdgpu_dm_commit_planes(struct drm_atomic_state *state,
 			to_dm_crtc_state(drm_atomic_get_old_crtc_state(state, pcrtc));
 	int planes_count = 0, vpos, hpos;
 	unsigned long flags;
+	uint32_t mem_type;
 	u32 target_vblank, last_flip_vblank;
 	bool vrr_active = amdgpu_dm_crtc_vrr_active(acrtc_state);
 	bool cursor_update = false;
@@ -8035,13 +8043,17 @@ static void amdgpu_dm_commit_planes(struct drm_atomic_state *state,
 			}
 		}
 
+		mem_type = get_mem_type(old_plane_state->fb);
+
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
+			(!mem_type || get_mem_type(fb) == mem_type);
 
 		timestamp_ns = ktime_get_ns();
 		bundle->flip_addrs[planes_count].flip_timestamp_in_us = div_u64(timestamp_ns, 1000);
-- 
2.40.0

