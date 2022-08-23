Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB60859D455
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240407AbiHWILr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:11:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241852AbiHWIJ2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:09:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3D7265817;
        Tue, 23 Aug 2022 01:06:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F33506122D;
        Tue, 23 Aug 2022 08:06:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04A38C433C1;
        Tue, 23 Aug 2022 08:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661241975;
        bh=wCsjM0Y0qINZDdkkfipcM2J/EeyQyOFc0gXcZwLfdbU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ovcN/UgtweX4OROOgYFHG3FDjuve1eUL2Cnajp6orszPBZo2ekTeaq6eH2mi8P63V
         +8JEWcbpHKZCntVid61NDk/nxBc0LYwWGQB1WLX2+qkOyt5ngzapWiLS1fWjXzBj69
         kN6omfGo1tuVY6X0FALW2M6XjKuyF9sSscZGXaJI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 5.19 011/365] drm/amdgpu: Only disable prefer_shadow on hawaii
Date:   Tue, 23 Aug 2022 09:58:32 +0200
Message-Id: <20220823080118.645851103@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

commit a6250bdb6c4677ee77d699b338e077b900f94c0c upstream.

We changed it for all asics due to a hibernation regression
on hawaii, but the workaround breaks suspend on a polaris12.
Just disable it for hawaii.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216119
Fixes: 3a4b1cc28fbd ("drm/amdgpu/display: disable prefer_shadow for generic fb helpers")
Reviewed-and-tested-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vkms.c          |    3 +--
 drivers/gpu/drm/amd/amdgpu/dce_v10_0.c            |    3 +--
 drivers/gpu/drm/amd/amdgpu/dce_v11_0.c            |    3 +--
 drivers/gpu/drm/amd/amdgpu/dce_v6_0.c             |    3 +--
 drivers/gpu/drm/amd/amdgpu/dce_v8_0.c             |    7 +++++--
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    7 +++++--
 6 files changed, 14 insertions(+), 12 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vkms.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vkms.c
@@ -496,8 +496,7 @@ static int amdgpu_vkms_sw_init(void *han
 	adev_to_drm(adev)->mode_config.max_height = YRES_MAX;
 
 	adev_to_drm(adev)->mode_config.preferred_depth = 24;
-	/* disable prefer shadow for now due to hibernation issues */
-	adev_to_drm(adev)->mode_config.prefer_shadow = 0;
+	adev_to_drm(adev)->mode_config.prefer_shadow = 1;
 
 	adev_to_drm(adev)->mode_config.fb_base = adev->gmc.aper_base;
 
--- a/drivers/gpu/drm/amd/amdgpu/dce_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/dce_v10_0.c
@@ -2796,8 +2796,7 @@ static int dce_v10_0_sw_init(void *handl
 	adev_to_drm(adev)->mode_config.max_height = 16384;
 
 	adev_to_drm(adev)->mode_config.preferred_depth = 24;
-	/* disable prefer shadow for now due to hibernation issues */
-	adev_to_drm(adev)->mode_config.prefer_shadow = 0;
+	adev_to_drm(adev)->mode_config.prefer_shadow = 1;
 
 	adev_to_drm(adev)->mode_config.fb_modifiers_not_supported = true;
 
--- a/drivers/gpu/drm/amd/amdgpu/dce_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/dce_v11_0.c
@@ -2914,8 +2914,7 @@ static int dce_v11_0_sw_init(void *handl
 	adev_to_drm(adev)->mode_config.max_height = 16384;
 
 	adev_to_drm(adev)->mode_config.preferred_depth = 24;
-	/* disable prefer shadow for now due to hibernation issues */
-	adev_to_drm(adev)->mode_config.prefer_shadow = 0;
+	adev_to_drm(adev)->mode_config.prefer_shadow = 1;
 
 	adev_to_drm(adev)->mode_config.fb_modifiers_not_supported = true;
 
--- a/drivers/gpu/drm/amd/amdgpu/dce_v6_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/dce_v6_0.c
@@ -2673,8 +2673,7 @@ static int dce_v6_0_sw_init(void *handle
 	adev_to_drm(adev)->mode_config.max_width = 16384;
 	adev_to_drm(adev)->mode_config.max_height = 16384;
 	adev_to_drm(adev)->mode_config.preferred_depth = 24;
-	/* disable prefer shadow for now due to hibernation issues */
-	adev_to_drm(adev)->mode_config.prefer_shadow = 0;
+	adev_to_drm(adev)->mode_config.prefer_shadow = 1;
 	adev_to_drm(adev)->mode_config.fb_modifiers_not_supported = true;
 	adev_to_drm(adev)->mode_config.fb_base = adev->gmc.aper_base;
 
--- a/drivers/gpu/drm/amd/amdgpu/dce_v8_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/dce_v8_0.c
@@ -2693,8 +2693,11 @@ static int dce_v8_0_sw_init(void *handle
 	adev_to_drm(adev)->mode_config.max_height = 16384;
 
 	adev_to_drm(adev)->mode_config.preferred_depth = 24;
-	/* disable prefer shadow for now due to hibernation issues */
-	adev_to_drm(adev)->mode_config.prefer_shadow = 0;
+	if (adev->asic_type == CHIP_HAWAII)
+		/* disable prefer shadow for now due to hibernation issues */
+		adev_to_drm(adev)->mode_config.prefer_shadow = 0;
+	else
+		adev_to_drm(adev)->mode_config.prefer_shadow = 1;
 
 	adev_to_drm(adev)->mode_config.fb_modifiers_not_supported = true;
 
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -3894,8 +3894,11 @@ static int amdgpu_dm_mode_config_init(st
 	adev_to_drm(adev)->mode_config.max_height = 16384;
 
 	adev_to_drm(adev)->mode_config.preferred_depth = 24;
-	/* disable prefer shadow for now due to hibernation issues */
-	adev_to_drm(adev)->mode_config.prefer_shadow = 0;
+	if (adev->asic_type == CHIP_HAWAII)
+		/* disable prefer shadow for now due to hibernation issues */
+		adev_to_drm(adev)->mode_config.prefer_shadow = 0;
+	else
+		adev_to_drm(adev)->mode_config.prefer_shadow = 1;
 	/* indicates support for immediate flip */
 	adev_to_drm(adev)->mode_config.async_page_flip = true;
 


