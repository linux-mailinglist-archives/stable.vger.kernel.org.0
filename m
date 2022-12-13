Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6DE64B6A1
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 14:54:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234639AbiLMNyy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 08:54:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234027AbiLMNyx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 08:54:53 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2078.outbound.protection.outlook.com [40.107.237.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 728A3644A
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 05:54:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I4Kjp5/rJjsmc1m6U8yKI6ZF0hhpT8Csf23Q3Ij+wh1DSPp11sM73EBn+7VhYXBUL4Sa561gnZKF4tTkhEiWu2YLUJbo16UuuNmYWuEVgKUiZhV88EcfEk8Nhhw7QD6jft/EGr/0AT3EaNHx8YrOmX/am5lIcuV1U6LbHSefuAfBL8OU1/6lUthtaS9WlbjlHtP1msz0rG7z7BqwsJ7kf+j/EQgLJmmp/B9yH7J6Dzqe6be3cC7WleuRuUY8p2fg4m2PFs5ONjhMHmVsv5T0+RKvup+dcP7xAmCJGBJ5vyuHBZe83S+kQCtO4M4wpSSUcdn0DMqHmi1KmDdIcvgLLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cg3FFdOzz3IvDWEckFR1dAMBtq/UvkOhHQrMVUQtP6s=;
 b=bLZTzFn0WPJmhosOjdNzqUX3X8SjzYz8kSrOxXiTdnc3JZ4pugy7e8dYJFqOfl1BlHM/TN7SkL/xkSsvl0iimB7aqJi+AVgQQle1gZVMVRvaFFdkOd8YhS2xJb2wSkTZ7R4GQqFUYSpx97jopeF+E8x6KW2yijgjpn8OTUXdGqtKclIu3LZUb9Gh/MY+wBL+y3VRVHdJ7oWxp36DpFSyI/Ea7O4HbDekl8IolTQVUk3wEpJXWUGob/E5eDyVHsn5PaYkbcuUkMUv4UtfUlAzBPo2OMjz/2cVjjNj40FT0e+yXPO22AJsrARU+SA9ikeP/n2o68PO/qZ5cZIqTxoBrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cg3FFdOzz3IvDWEckFR1dAMBtq/UvkOhHQrMVUQtP6s=;
 b=H1y7tyQ3RDGjjqu2fn5XvcT+rzdAMkcbQZR3qUFwLNIrKxDPQKAOkKuAlE3ozzpGAYE7LH9i+D3TOVFDHiot/UnrlGi4iOKtWGzzEnFQWpfFZQma7HY5NxD83mdT5zAiPS5o3dr1fNNmYpLdtPz/PUx/9V6uKG+LNgkPOreGv04=
Received: from MW2PR16CA0017.namprd16.prod.outlook.com (2603:10b6:907::30) by
 DM4PR12MB6616.namprd12.prod.outlook.com (2603:10b6:8:8e::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.19; Tue, 13 Dec 2022 13:54:50 +0000
Received: from CO1NAM11FT089.eop-nam11.prod.protection.outlook.com
 (2603:10b6:907:0:cafe::45) by MW2PR16CA0017.outlook.office365.com
 (2603:10b6:907::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.11 via Frontend
 Transport; Tue, 13 Dec 2022 13:54:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT089.mail.protection.outlook.com (10.13.175.179) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5901.21 via Frontend Transport; Tue, 13 Dec 2022 13:54:49 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 13 Dec
 2022 07:54:44 -0600
Received: from alan-new-dev.amd.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Tue, 13 Dec 2022 07:54:42 -0600
From:   Alan Liu <HaoPing.Liu@amd.com>
To:     <brahma_sw_dev@amd.com>
CC:     <ray.huang@amd.com>, <wayne.lin@amd.com>, <haoping.liu@amd.com>,
        "Yunxiang Li" <Yunxiang.Li@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        "Rodrigo Siqueira" <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        <stable@vger.kernel.org>
Subject: [PATCH 4/9] drm/amd/display: Fix vblank refcount in vrr transition
Date:   Tue, 13 Dec 2022 21:54:02 +0800
Message-ID: <20221213135407.1595953-4-HaoPing.Liu@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221213135407.1595953-1-HaoPing.Liu@amd.com>
References: <20221213135407.1595953-1-HaoPing.Liu@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT089:EE_|DM4PR12MB6616:EE_
X-MS-Office365-Filtering-Correlation-Id: db055737-3c76-487a-37ca-08dadd119a1f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7+xA74r0l3VBQ57SgmadjmFSdxVJGI1X2fwdbG85bi56wwirrqAImqUSWiX+7ChSNMUAnTjCVxJOKcg/5CfVrG5iCEZs01rCWtrYn2Z7z7UA5ZuDK9Ta9jCSFm4CTtMG7FT2HKHCnMRyrs89AWduMNB74diQ9DN7wiTmfSrjEmqLEfZ7hUYFf9Cv4ubRx9RYfPx+p/fyPPR3fEi8N8eC3/+aQEK47YXTbWDcIr7YjKUxDIzmWXCOZSMSSHOVtrSdbQdFkw+IP00PdjzrGuIXeySoe8LKrCag0mpE+xHjvNQeZO1plHOPIAq+6wGF3MA8Yq6DPHS6lEs0dAXpY2R0Gql4lNu/s4arsMBY6Tx++A646fxKzKdstXeIlUoEsW5FXKVpmwl77wSxA7AGtCr/ousGQJFrYJ5tldW2HVVOjlcGRQNZE5pYylUcEin2RW705IxOeUkv6gGGdTc/8yn1ZABY2BPV/A8y0ZjENdMXIVAV5Ez9Q/Klag4/YLoIfMSmVM0ITSbyMshmjgh/El9U6ztXHkjd+tLPYviggwZzG+BkFZHxbj3wbDdGmafWymxRRUDcMgZHBIy08dwsFUzPuBRsRbHiZUnA5QiD70QV8HhaspL/gwVGrRLp7UimP/LaGS6mdSSTTFARfLdZUdshC76ALcCALsZO370Cc2zo7fZYLxGoCBMk2KzeKO3PUA4Y
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:CA;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(346002)(136003)(396003)(451199015)(46966006)(40470700004)(36840700001)(82740400003)(478600001)(2906002)(966005)(83380400001)(356005)(81166007)(336012)(36860700001)(2616005)(40460700003)(82310400005)(7696005)(36756003)(6666004)(186003)(1076003)(426003)(26005)(47076005)(70586007)(6862004)(8936002)(4326008)(40480700001)(41300700001)(70206006)(8676002)(6636002)(5660300002)(54906003)(37006003)(86362001)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2022 13:54:49.4703
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: db055737-3c76-487a-37ca-08dadd119a1f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT089.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6616
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yunxiang Li <Yunxiang.Li@amd.com>

manage_dm_interrupts disable/enable vblank using drm_crtc_vblank_off/on
which causes drm_crtc_vblank_get in vrr_transition to fail, and later
when drm_crtc_vblank_put is called the refcount on vblank will be messed
up. Therefore move the call to after manage_dm_interrupts.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1247
Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1380

Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Reviewed-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Yunxiang Li <Yunxiang.Li@amd.com>
Signed-off-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 55 +++++++++----------
 1 file changed, 26 insertions(+), 29 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 7183e39a2bc9..354a99ff6a1f 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -9176,15 +9176,15 @@ static void amdgpu_dm_handle_vrr_transition(struct dm_crtc_state *old_state,
 		 * We also need vupdate irq for the actual core vblank handling
 		 * at end of vblank.
 		 */
-		dm_set_vupdate_irq(new_state->base.crtc, true);
-		drm_crtc_vblank_get(new_state->base.crtc);
+		WARN_ON(dm_set_vupdate_irq(new_state->base.crtc, true) != 0);
+		WARN_ON(drm_crtc_vblank_get(new_state->base.crtc) != 0);
 		DRM_DEBUG_DRIVER("%s: crtc=%u VRR off->on: Get vblank ref\n",
 				 __func__, new_state->base.crtc->base.id);
 	} else if (old_vrr_active && !new_vrr_active) {
 		/* Transition VRR active -> inactive:
 		 * Allow vblank irq disable again for fixed refresh rate.
 		 */
-		dm_set_vupdate_irq(new_state->base.crtc, false);
+		WARN_ON(dm_set_vupdate_irq(new_state->base.crtc, false) != 0);
 		drm_crtc_vblank_put(new_state->base.crtc);
 		DRM_DEBUG_DRIVER("%s: crtc=%u VRR on->off: Drop vblank ref\n",
 				 __func__, new_state->base.crtc->base.id);
@@ -9917,23 +9917,6 @@ static void amdgpu_dm_atomic_commit_tail(struct drm_atomic_state *state)
 		mutex_unlock(&dm->dc_lock);
 	}
 
-	/* Count number of newly disabled CRTCs for dropping PM refs later. */
-	for_each_oldnew_crtc_in_state(state, crtc, old_crtc_state,
-				      new_crtc_state, i) {
-		if (old_crtc_state->active && !new_crtc_state->active)
-			crtc_disable_count++;
-
-		dm_new_crtc_state = to_dm_crtc_state(new_crtc_state);
-		dm_old_crtc_state = to_dm_crtc_state(old_crtc_state);
-
-		/* For freesync config update on crtc state and params for irq */
-		update_stream_irq_parameters(dm, dm_new_crtc_state);
-
-		/* Handle vrr on->off / off->on transitions */
-		amdgpu_dm_handle_vrr_transition(dm_old_crtc_state,
-						dm_new_crtc_state);
-	}
-
 	/**
 	 * Enable interrupts for CRTCs that are newly enabled or went through
 	 * a modeset. It was intentionally deferred until after the front end
@@ -9943,16 +9926,29 @@ static void amdgpu_dm_atomic_commit_tail(struct drm_atomic_state *state)
 	for_each_oldnew_crtc_in_state(state, crtc, old_crtc_state, new_crtc_state, i) {
 		struct amdgpu_crtc *acrtc = to_amdgpu_crtc(crtc);
 #ifdef CONFIG_DEBUG_FS
-		bool configure_crc = false;
 		enum amdgpu_dm_pipe_crc_source cur_crc_src;
 #if defined(CONFIG_DRM_AMD_SECURE_DISPLAY)
-		struct crc_rd_work *crc_rd_wrk = dm->crc_rd_wrk;
+		struct crc_rd_work *crc_rd_wrk;
+#endif
+#endif
+		/* Count number of newly disabled CRTCs for dropping PM refs later. */
+		if (old_crtc_state->active && !new_crtc_state->active)
+			crtc_disable_count++;
+
+		dm_new_crtc_state = to_dm_crtc_state(new_crtc_state);
+		dm_old_crtc_state = to_dm_crtc_state(old_crtc_state);
+
+		/* For freesync config update on crtc state and params for irq */
+		update_stream_irq_parameters(dm, dm_new_crtc_state);
+
+#ifdef CONFIG_DEBUG_FS
+#if defined(CONFIG_DRM_AMD_SECURE_DISPLAY)
+		crc_rd_wrk = dm->crc_rd_wrk;
 #endif
 		spin_lock_irqsave(&adev_to_drm(adev)->event_lock, flags);
 		cur_crc_src = acrtc->dm_irq_params.crc_src;
 		spin_unlock_irqrestore(&adev_to_drm(adev)->event_lock, flags);
 #endif
-		dm_new_crtc_state = to_dm_crtc_state(new_crtc_state);
 
 		if (new_crtc_state->active &&
 		    (!old_crtc_state->active ||
@@ -9960,16 +9956,19 @@ static void amdgpu_dm_atomic_commit_tail(struct drm_atomic_state *state)
 			dc_stream_retain(dm_new_crtc_state->stream);
 			acrtc->dm_irq_params.stream = dm_new_crtc_state->stream;
 			manage_dm_interrupts(adev, acrtc, true);
+		}
+		/* Handle vrr on->off / off->on transitions */
+		amdgpu_dm_handle_vrr_transition(dm_old_crtc_state, dm_new_crtc_state);
 
 #ifdef CONFIG_DEBUG_FS
+		if (new_crtc_state->active &&
+		    (!old_crtc_state->active ||
+		     drm_atomic_crtc_needs_modeset(new_crtc_state))) {
 			/**
 			 * Frontend may have changed so reapply the CRC capture
 			 * settings for the stream.
 			 */
-			dm_new_crtc_state = to_dm_crtc_state(new_crtc_state);
-
 			if (amdgpu_dm_is_valid_crc_source(cur_crc_src)) {
-				configure_crc = true;
 #if defined(CONFIG_DRM_AMD_SECURE_DISPLAY)
 				if (amdgpu_dm_crc_window_is_activated(crtc)) {
 					spin_lock_irqsave(&adev_to_drm(adev)->event_lock, flags);
@@ -9981,12 +9980,10 @@ static void amdgpu_dm_atomic_commit_tail(struct drm_atomic_state *state)
 					spin_unlock_irqrestore(&adev_to_drm(adev)->event_lock, flags);
 				}
 #endif
-			}
-
-			if (configure_crc)
 				if (amdgpu_dm_crtc_configure_crc_source(
 					crtc, dm_new_crtc_state, cur_crc_src))
 					DRM_DEBUG_DRIVER("Failed to configure crc source");
+			}
 #endif
 		}
 	}
-- 
2.25.1

