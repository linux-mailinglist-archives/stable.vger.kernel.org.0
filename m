Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 823436B3DFD
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 12:36:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbjCJLgr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 06:36:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbjCJLgh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 06:36:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 314F775A47
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 03:36:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C047561389
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 11:36:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2631C433D2;
        Fri, 10 Mar 2023 11:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678448190;
        bh=wYGm+m1Z11QzB8/Z3DNrhQw8Vh9qLgFmWqnIOLEoazg=;
        h=Subject:To:Cc:From:Date:From;
        b=FmA+Es59Y10L65KDTynd9/t7r4jhFwO5mlZfLFtZ4nF5BJCuVfpEFIjrORRr3CIjB
         Z2tfMgV0NDJ6my6KhlcTOtqGjhX9XePdC8e/wG/SvDnT8Sv6MPXRwPp0o8fWxPrEwG
         m/LsntCSo/jHNvkMaVn0EZNhdkTGFQlQHMV1FSqc=
Subject: FAILED: patch "[PATCH] drm/amdgpu: skip MES for S0ix as well since it's part of GFX" failed to apply to 6.2-stable tree
To:     alexander.deucher@amd.com, mario.limonciello@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 10 Mar 2023 12:36:19 +0100
Message-ID: <167844817994148@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.2-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-6.2.y
git checkout FETCH_HEAD
git cherry-pick -x 5620a1889e4ce248b0013123024bd4b20df8b56e
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '167844817994148@kroah.com' --subject-prefix 'PATCH 6.2.y' HEAD^..

Possible dependencies:

5620a1889e4c ("drm/amdgpu: skip MES for S0ix as well since it's part of GFX")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5620a1889e4ce248b0013123024bd4b20df8b56e Mon Sep 17 00:00:00 2001
From: Alex Deucher <alexander.deucher@amd.com>
Date: Fri, 16 Dec 2022 11:42:20 -0500
Subject: [PATCH] drm/amdgpu: skip MES for S0ix as well since it's part of GFX

It's also part of gfxoff.

Cc: stable@vger.kernel.org # 6.0, 6.1
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 582a80a9850e..e4609b8d574c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -3018,14 +3018,15 @@ static int amdgpu_device_ip_suspend_phase2(struct amdgpu_device *adev)
 			continue;
 		}
 
-		/* skip suspend of gfx and psp for S0ix
+		/* skip suspend of gfx/mes and psp for S0ix
 		 * gfx is in gfxoff state, so on resume it will exit gfxoff just
 		 * like at runtime. PSP is also part of the always on hardware
 		 * so no need to suspend it.
 		 */
 		if (adev->in_s0ix &&
 		    (adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_PSP ||
-		     adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_GFX))
+		     adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_GFX ||
+		     adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_MES))
 			continue;
 
 		/* SDMA 5.x+ is part of GFX power domain so it's covered by GFXOFF */

