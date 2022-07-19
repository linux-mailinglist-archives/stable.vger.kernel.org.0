Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68EB6579D92
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241962AbiGSMwm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:52:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241964AbiGSMvo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:51:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B8F852E5B;
        Tue, 19 Jul 2022 05:20:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C563618C1;
        Tue, 19 Jul 2022 12:20:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C368C341C6;
        Tue, 19 Jul 2022 12:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233225;
        bh=AwrNUyJ+gTyGLLuHMZvIklSgNiAJstrEsmVJBq3MzzE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hpNLE3rzcYajz/8Rj+/OXJ2IQO9NOm+B4XyB9+6BDnt0LMGv9HPR6PQE7RqwwoEV/
         4xuS0pFtTXn8MvcPaxF6E81IMDQaghcFmFHF5YYXDY5cduXInD9SJXUUVAuK4SuwDb
         UTTNtKlK90+62boFhj3SZH9P0ffnpOItLSRZVwfI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 049/231] drm/amdgpu/display: disable prefer_shadow for generic fb helpers
Date:   Tue, 19 Jul 2022 13:52:14 +0200
Message-Id: <20220719114718.397171732@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 3a4b1cc28fbdc2325b3e3ed7d8024995a75f9216 ]

Seems to break hibernation.  Disable for now until we can root
cause it.

Fixes: 087451f372bf ("drm/amdgpu: use generic fb helpers instead of setting up AMD own's.")
Bug: https://bugzilla.kernel.org/show_bug.cgi?id=216119
Acked-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vkms.c          | 3 ++-
 drivers/gpu/drm/amd/amdgpu/dce_v10_0.c            | 3 ++-
 drivers/gpu/drm/amd/amdgpu/dce_v11_0.c            | 3 ++-
 drivers/gpu/drm/amd/amdgpu/dce_v6_0.c             | 3 ++-
 drivers/gpu/drm/amd/amdgpu/dce_v8_0.c             | 3 ++-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 3 ++-
 6 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vkms.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vkms.c
index 5224d9a39737..842670d4a12e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vkms.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vkms.c
@@ -494,7 +494,8 @@ static int amdgpu_vkms_sw_init(void *handle)
 	adev_to_drm(adev)->mode_config.max_height = YRES_MAX;
 
 	adev_to_drm(adev)->mode_config.preferred_depth = 24;
-	adev_to_drm(adev)->mode_config.prefer_shadow = 1;
+	/* disable prefer shadow for now due to hibernation issues */
+	adev_to_drm(adev)->mode_config.prefer_shadow = 0;
 
 	adev_to_drm(adev)->mode_config.fb_base = adev->gmc.aper_base;
 
diff --git a/drivers/gpu/drm/amd/amdgpu/dce_v10_0.c b/drivers/gpu/drm/amd/amdgpu/dce_v10_0.c
index 288fce7dc0ed..9c964cd3b5d4 100644
--- a/drivers/gpu/drm/amd/amdgpu/dce_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/dce_v10_0.c
@@ -2796,7 +2796,8 @@ static int dce_v10_0_sw_init(void *handle)
 	adev_to_drm(adev)->mode_config.max_height = 16384;
 
 	adev_to_drm(adev)->mode_config.preferred_depth = 24;
-	adev_to_drm(adev)->mode_config.prefer_shadow = 1;
+	/* disable prefer shadow for now due to hibernation issues */
+	adev_to_drm(adev)->mode_config.prefer_shadow = 0;
 
 	adev_to_drm(adev)->mode_config.fb_modifiers_not_supported = true;
 
diff --git a/drivers/gpu/drm/amd/amdgpu/dce_v11_0.c b/drivers/gpu/drm/amd/amdgpu/dce_v11_0.c
index cbe5250b31cb..e0ad9f27dc3f 100644
--- a/drivers/gpu/drm/amd/amdgpu/dce_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/dce_v11_0.c
@@ -2914,7 +2914,8 @@ static int dce_v11_0_sw_init(void *handle)
 	adev_to_drm(adev)->mode_config.max_height = 16384;
 
 	adev_to_drm(adev)->mode_config.preferred_depth = 24;
-	adev_to_drm(adev)->mode_config.prefer_shadow = 1;
+	/* disable prefer shadow for now due to hibernation issues */
+	adev_to_drm(adev)->mode_config.prefer_shadow = 0;
 
 	adev_to_drm(adev)->mode_config.fb_modifiers_not_supported = true;
 
diff --git a/drivers/gpu/drm/amd/amdgpu/dce_v6_0.c b/drivers/gpu/drm/amd/amdgpu/dce_v6_0.c
index 982855e6cf52..3caf6f386042 100644
--- a/drivers/gpu/drm/amd/amdgpu/dce_v6_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/dce_v6_0.c
@@ -2673,7 +2673,8 @@ static int dce_v6_0_sw_init(void *handle)
 	adev_to_drm(adev)->mode_config.max_width = 16384;
 	adev_to_drm(adev)->mode_config.max_height = 16384;
 	adev_to_drm(adev)->mode_config.preferred_depth = 24;
-	adev_to_drm(adev)->mode_config.prefer_shadow = 1;
+	/* disable prefer shadow for now due to hibernation issues */
+	adev_to_drm(adev)->mode_config.prefer_shadow = 0;
 	adev_to_drm(adev)->mode_config.fb_modifiers_not_supported = true;
 	adev_to_drm(adev)->mode_config.fb_base = adev->gmc.aper_base;
 
diff --git a/drivers/gpu/drm/amd/amdgpu/dce_v8_0.c b/drivers/gpu/drm/amd/amdgpu/dce_v8_0.c
index 84440741c60b..7c75df5bffed 100644
--- a/drivers/gpu/drm/amd/amdgpu/dce_v8_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/dce_v8_0.c
@@ -2693,7 +2693,8 @@ static int dce_v8_0_sw_init(void *handle)
 	adev_to_drm(adev)->mode_config.max_height = 16384;
 
 	adev_to_drm(adev)->mode_config.preferred_depth = 24;
-	adev_to_drm(adev)->mode_config.prefer_shadow = 1;
+	/* disable prefer shadow for now due to hibernation issues */
+	adev_to_drm(adev)->mode_config.prefer_shadow = 0;
 
 	adev_to_drm(adev)->mode_config.fb_modifiers_not_supported = true;
 
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 6dc9808760fc..b55a433e829e 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -3847,7 +3847,8 @@ static int amdgpu_dm_mode_config_init(struct amdgpu_device *adev)
 	adev_to_drm(adev)->mode_config.max_height = 16384;
 
 	adev_to_drm(adev)->mode_config.preferred_depth = 24;
-	adev_to_drm(adev)->mode_config.prefer_shadow = 1;
+	/* disable prefer shadow for now due to hibernation issues */
+	adev_to_drm(adev)->mode_config.prefer_shadow = 0;
 	/* indicates support for immediate flip */
 	adev_to_drm(adev)->mode_config.async_page_flip = true;
 
-- 
2.35.1



