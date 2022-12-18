Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3946501EB
	for <lists+stable@lfdr.de>; Sun, 18 Dec 2022 17:39:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232421AbiLRQi6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Dec 2022 11:38:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232330AbiLRQiG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Dec 2022 11:38:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14D21B30;
        Sun, 18 Dec 2022 08:13:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 545E3B80BA4;
        Sun, 18 Dec 2022 16:13:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46B4BC433EF;
        Sun, 18 Dec 2022 16:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671380005;
        bh=d1v8U2axErALdvkTQ4tfoR54pNwtFOawkjZl0P7vDXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aIXlyk+KVJB97UujxuvyQGcF+ybHEzfl0bOLJ2V63o2MUkZwwEs/huAVmAmoZeWrd
         FOKGVduPNk4eGNqrs1n7/YQdh8BtUCqvGTvOtDurfPCRXn42AxOp67hGO0GY8u6n5e
         ry5yFgHX2lInFXlVi1T5TCjmN2EPABLCNmtTYFE5tHU1zSWeRoYWjJ3kV18np2PcnV
         v3wRsP53vFDR0zLfxnqjp3TxQt5oEA+erNlJiTBA9dmjfNPu0HABRwdi+elUGuRYP9
         3PjRywkLLUPhUv71DmEeUT+FMrgF2fjY/Q7V3Tw9hspatMwyalyS9rhEcqoyZL/d+C
         sOg9RhU1qwkmQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hamza Mahfooz <hamza.mahfooz@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, sunpeng.li@amd.com,
        Rodrigo.Siqueira@amd.com, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@gmail.com, daniel@ffwll.ch,
        Wayne.Lin@amd.com, Jerry.Zuo@amd.com, lyude@redhat.com,
        ian.chen@amd.com, colin.i.king@gmail.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 09/46] Revert "drm/amd/display: Limit max DSC target bpp for specific monitors"
Date:   Sun, 18 Dec 2022 11:12:07 -0500
Message-Id: <20221218161244.930785-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218161244.930785-1-sashal@kernel.org>
References: <20221218161244.930785-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

