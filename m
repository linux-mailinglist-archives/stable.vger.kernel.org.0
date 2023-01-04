Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDD5265D5EC
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 15:37:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234103AbjADOh4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 09:37:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231967AbjADOh4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 09:37:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40D88F2
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 06:37:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CFF3561748
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 14:37:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5FF0C433D2;
        Wed,  4 Jan 2023 14:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672843074;
        bh=zjhCSGf0Vs1L6sxMD6q9W+WIeAfBEY2gjy77xRQp8/I=;
        h=Subject:To:Cc:From:Date:From;
        b=h2Xb5ADRN6/ANIZVeP23H380yCAIJQAtsOrZIxjPZRSsc4w/8Y7pzu7AlEf+AF8N6
         Ki59JvVl7Sy79n4rkIBsqlHU9q+VEw3DnN2vTHW03fe8fEuLewx5wNrAacY7PoqVkG
         chfyEfjMYIl9kl1O4l28tQRx/HBw5eK+AVEi1Igc=
Subject: FAILED: patch "[PATCH] drm/amd/display: Revert logic for plane modifiers" failed to apply to 6.0-stable tree
To:     samsagax@gmail.com, alexander.deucher@amd.com,
        bas@basnieuwenhuizen.nl, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 15:37:43 +0100
Message-ID: <167284306345198@kroah.com>
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


The patch below does not apply to the 6.0-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

93e28cf81406 ("drm/amd/display: Revert logic for plane modifiers")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 93e28cf81406519622383ae51d6fd183b744ac46 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Joaqu=C3=ADn=20Ignacio=20Aramend=C3=ADa?=
 <samsagax@gmail.com>
Date: Mon, 24 Oct 2022 08:33:59 -0300
Subject: [PATCH] drm/amd/display: Revert logic for plane modifiers
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This file was split in commit 5d945cbcd4b16a29d6470a80dfb19738f9a4319f
("drm/amd/display: Create a file dedicated to planes") and the logic in
dm_plane_format_mod_supported() function got changed by a switch logic.
That change broke drm_plane modifiers setting on series 5000 APUs
(tested on OXP mini AMD 5800U and HP Dev One 5850U PRO)
leading to Gamescope not working as reported on GitHub[1]

To reproduce the issue, enter a TTY and run:

$ gamescope -- vkcube

With said commit applied it will abort. This one restores the old logic,
fixing the issue that affects Gamescope.

[1](https://github.com/Plagman/gamescope/issues/624)

Cc: <stable@vger.kernel.org> # 6.0.x
Signed-off-by: Joaquín Ignacio Aramendía <samsagax@gmail.com>
Reviewed-by: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c
index dfd3be49eac8..e6854f7270a6 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c
@@ -1369,7 +1369,7 @@ static bool dm_plane_format_mod_supported(struct drm_plane *plane,
 {
 	struct amdgpu_device *adev = drm_to_adev(plane->dev);
 	const struct drm_format_info *info = drm_format_info(format);
-	struct hw_asic_id asic_id = adev->dm.dc->ctx->asic_id;
+	int i;
 
 	enum dm_micro_swizzle microtile = modifier_gfx9_swizzle_mode(modifier) & 3;
 
@@ -1386,49 +1386,13 @@ static bool dm_plane_format_mod_supported(struct drm_plane *plane,
 		return true;
 	}
 
-	/* check if swizzle mode is supported by this version of DCN */
-	switch (asic_id.chip_family) {
-	case FAMILY_SI:
-	case FAMILY_CI:
-	case FAMILY_KV:
-	case FAMILY_CZ:
-	case FAMILY_VI:
-		/* asics before AI does not have modifier support */
-		return false;
-	case FAMILY_AI:
-	case FAMILY_RV:
-	case FAMILY_NV:
-	case FAMILY_VGH:
-	case FAMILY_YELLOW_CARP:
-	case AMDGPU_FAMILY_GC_10_3_6:
-	case AMDGPU_FAMILY_GC_10_3_7:
-		switch (AMD_FMT_MOD_GET(TILE, modifier)) {
-		case AMD_FMT_MOD_TILE_GFX9_64K_R_X:
-		case AMD_FMT_MOD_TILE_GFX9_64K_D_X:
-		case AMD_FMT_MOD_TILE_GFX9_64K_S_X:
-		case AMD_FMT_MOD_TILE_GFX9_64K_D:
-			return true;
-		default:
-			return false;
-		}
-		break;
-	case AMDGPU_FAMILY_GC_11_0_0:
-	case AMDGPU_FAMILY_GC_11_0_1:
-		switch (AMD_FMT_MOD_GET(TILE, modifier)) {
-		case AMD_FMT_MOD_TILE_GFX11_256K_R_X:
-		case AMD_FMT_MOD_TILE_GFX9_64K_R_X:
-		case AMD_FMT_MOD_TILE_GFX9_64K_D_X:
-		case AMD_FMT_MOD_TILE_GFX9_64K_S_X:
-		case AMD_FMT_MOD_TILE_GFX9_64K_D:
-			return true;
-		default:
-			return false;
-		}
-		break;
-	default:
-		ASSERT(0); /* Unknown asic */
-		break;
+	/* Check that the modifier is on the list of the plane's supported modifiers. */
+	for (i = 0; i < plane->modifier_count; i++) {
+		if (modifier == plane->modifiers[i])
+			break;
 	}
+	if (i == plane->modifier_count)
+		return false;
 
 	/*
 	 * For D swizzle the canonical modifier depends on the bpp, so check

