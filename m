Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1691268116C
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:13:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237258AbjA3ON1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:13:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237283AbjA3ONW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:13:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52E613BDB8
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:13:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 337FC61035
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:13:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C5D2C433D2;
        Mon, 30 Jan 2023 14:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087989;
        bh=rk0jz7qaU8yzDod79Bcnm5n/Qf72E3j6ztNf1smrrsQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TRtBPiFt7298Fj+8G7S8c0zDJMaqDyzXtnEFsOLkL++M9+8CS3nlJlUAXab3Synq9
         Khuv/06yttvDppebfXJ9/ZMpvisqPBtEvYrIGyjvtakQpY6ewNEhMo6dGocGriXJJW
         o30+l4c4w3awKji6i9IIxJIqeTplu0cp0uRoCWCc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alex Deucher <alexander.deucher@amd.com>,
        Hamza Mahfooz <hamza.mahfooz@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 078/204] drm/amd/display: fix issues with driver unload
Date:   Mon, 30 Jan 2023 14:50:43 +0100
Message-Id: <20230130134319.759028119@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
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
index 409739ee5ba0..a2d9e0af0654 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1688,10 +1688,6 @@ static void amdgpu_dm_fini(struct amdgpu_device *adev)
 	}
 #endif
 
-	for (i = 0; i < adev->dm.display_indexes_num; i++) {
-		drm_encoder_cleanup(&adev->dm.mst_encoders[i].base);
-	}
-
 	amdgpu_dm_destroy_drm_device(&adev->dm);
 
 #if defined(CONFIG_DRM_AMD_SECURE_DISPLAY)
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
index 652cf108b3c2..bc02e3e0d17d 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -385,7 +385,6 @@ static const struct drm_connector_helper_funcs dm_dp_mst_connector_helper_funcs
 static void amdgpu_dm_encoder_destroy(struct drm_encoder *encoder)
 {
 	drm_encoder_cleanup(encoder);
-	kfree(encoder);
 }
 
 static const struct drm_encoder_funcs amdgpu_dm_encoder_funcs = {
-- 
2.39.0



