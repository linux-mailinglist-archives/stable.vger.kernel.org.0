Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FFAB657E44
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:52:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbiL1Pw3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:52:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234255AbiL1PwJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:52:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AD3D18B05
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:51:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE05761560
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:51:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F11F2C433D2;
        Wed, 28 Dec 2022 15:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242718;
        bh=d1v8U2axErALdvkTQ4tfoR54pNwtFOawkjZl0P7vDXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bUfR1gmDK/wMCuKbUapaq2msThSyT3BxWAu6oOjivcPxEE3wTgRIc0oUCtwLUpzzu
         o+bAOSC65YDA72kgZq8wX02GGMjHXS1TMkbzqq/z7n4apiYE5A1LF/EEgbUSbqt0Vx
         5sv/hr3eMiiADjNus087iqYkaOpZQB0TAlahrX4U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Harry Wentland <harry.wentland@amd.com>,
        Hamza Mahfooz <hamza.mahfooz@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 637/731] Revert "drm/amd/display: Limit max DSC target bpp for specific monitors"
Date:   Wed, 28 Dec 2022 15:42:24 +0100
Message-Id: <20221228144314.976604811@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

[ Upstream commit 6803dfd3a69ccb318772463a86e40929fd4fbac7 ]

This reverts commit 55eea8ef98641f6e1e1c202bd3a49a57c1dd4059.

This quirk is now handled in the DRM core, so we can drop all of
the internal code that was added to handle it.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/amdgpu_dm/amdgpu_dm_helpers.c | 35 -------------------
 1 file changed, 35 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
index d793eec69d61..6fee12c91ef5 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
@@ -40,39 +40,6 @@
 
 #include "dm_helpers.h"
 
-struct monitor_patch_info {
-	unsigned int manufacturer_id;
-	unsigned int product_id;
-	void (*patch_func)(struct dc_edid_caps *edid_caps, unsigned int param);
-	unsigned int patch_param;
-};
-static void set_max_dsc_bpp_limit(struct dc_edid_caps *edid_caps, unsigned int param);
-
-static const struct monitor_patch_info monitor_patch_table[] = {
-{0x6D1E, 0x5BBF, set_max_dsc_bpp_limit, 15},
-{0x6D1E, 0x5B9A, set_max_dsc_bpp_limit, 15},
-};
-
-static void set_max_dsc_bpp_limit(struct dc_edid_caps *edid_caps, unsigned int param)
-{
-	if (edid_caps)
-		edid_caps->panel_patch.max_dsc_target_bpp_limit = param;
-}
-
-static int amdgpu_dm_patch_edid_caps(struct dc_edid_caps *edid_caps)
-{
-	int i, ret = 0;
-
-	for (i = 0; i < ARRAY_SIZE(monitor_patch_table); i++)
-		if ((edid_caps->manufacturer_id == monitor_patch_table[i].manufacturer_id)
-			&&  (edid_caps->product_id == monitor_patch_table[i].product_id)) {
-			monitor_patch_table[i].patch_func(edid_caps, monitor_patch_table[i].patch_param);
-			ret++;
-		}
-
-	return ret;
-}
-
 /* dm_helpers_parse_edid_caps
  *
  * Parse edid caps
@@ -158,8 +125,6 @@ enum dc_edid_status dm_helpers_parse_edid_caps(
 	kfree(sads);
 	kfree(sadb);
 
-	amdgpu_dm_patch_edid_caps(edid_caps);
-
 	return result;
 }
 
-- 
2.35.1



