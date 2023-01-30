Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A698F681029
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:01:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236814AbjA3OBG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:01:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236767AbjA3OBD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:01:03 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 081FA3A87F
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:00:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 30DF6CE16B2
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 13:59:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 080E7C433EF;
        Mon, 30 Jan 2023 13:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087181;
        bh=QrZI8hFtJkR++wIhIssFj18C62dKOEnprenkMxcC1to=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YkfEUmTnpwj6WhpBZp5bKlDOzO0pR5lSXrojpU+he+H3iZI0HF0VVC8NCftsv1BVb
         FVwkWZyd5t/LKOFmJ/B5gqqOuBtxwMbZdPn7DmJLQCZL2wln3d4dXSNPp+cPQ/bRXS
         KLgm/oNa2SF7s9ZmR3R13b5yr4J2kiQagvRtY1LU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alex Deucher <alexander.deucher@amd.com>,
        Hamza Mahfooz <hamza.mahfooz@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 123/313] drm/amd/display: fix issues with driver unload
Date:   Mon, 30 Jan 2023 14:49:18 +0100
Message-Id: <20230130134342.378484063@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hamza Mahfooz <hamza.mahfooz@amd.com>

[ Upstream commit e433adc60f7f847e734c56246b09291532f29b6d ]

Currently, we run into a number of WARN()s when attempting to unload the
amdgpu driver (e.g. using "modprobe -r amdgpu"). These all stem from
calling drm_encoder_cleanup() too early. So, to fix this we can stop
calling drm_encoder_cleanup() from amdgpu_dm_fini() and instead have it
be called from amdgpu_dm_encoder_destroy(). Also, we don't need to free
in amdgpu_dm_encoder_destroy() since mst_encoders[] isn't explicitly
allocated by the slab allocator.

Fixes: f74367e492ba ("drm/amdgpu/display: create fake mst encoders ahead of time (v4)")
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c           | 4 ----
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c | 1 -
 2 files changed, 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index e10f1f15c9c4..7b222fe9716a 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1737,10 +1737,6 @@ static void amdgpu_dm_fini(struct amdgpu_device *adev)
 		adev->dm.vblank_control_workqueue = NULL;
 	}
 
-	for (i = 0; i < adev->dm.display_indexes_num; i++) {
-		drm_encoder_cleanup(&adev->dm.mst_encoders[i].base);
-	}
-
 	amdgpu_dm_destroy_drm_device(&adev->dm);
 
 #if defined(CONFIG_DRM_AMD_SECURE_DISPLAY)
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
index 6483ba266893..b7369c7b71e4 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -468,7 +468,6 @@ static const struct drm_connector_helper_funcs dm_dp_mst_connector_helper_funcs
 static void amdgpu_dm_encoder_destroy(struct drm_encoder *encoder)
 {
 	drm_encoder_cleanup(encoder);
-	kfree(encoder);
 }
 
 static const struct drm_encoder_funcs amdgpu_dm_encoder_funcs = {
-- 
2.39.0



