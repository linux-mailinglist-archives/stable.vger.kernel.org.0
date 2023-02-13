Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4F32694953
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:58:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231145AbjBMO63 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:58:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231189AbjBMO6N (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:58:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 340F51D920
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:57:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 87DC3B81257
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:57:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E086AC433EF;
        Mon, 13 Feb 2023 14:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300220;
        bh=HpOwlCXmT8chzfzakI7yGN2VY3qN3NeZA0KFzZODdHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G7St4+qyLjvCvz6fzBsACKQwLznjihbJfJoM119+8NgKYHdPco0IprMJ6Dpwq9op2
         SwWdnTr16ePHvzwGItDI+EKotIgUyyz+6VLqGxzDsPCq5Cg3csF12sZgK+N4tiT7Nz
         7+CcCEp5oMsqa9P8GKA0P56VZB8LgLJdtQ4MoQcw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yifan Zhang <yifan1.zhang@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 110/114] drm/amd/display: properly handling AGP aperture in vm setup
Date:   Mon, 13 Feb 2023 15:49:05 +0100
Message-Id: <20230213144747.904689820@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

commit 5c4e8c71d1202cd84d870e7e5cb8d6b52f9c3507 upstream.

Take into account whether or not the AGP aperture is
enabled or not when calculating the system aperture.

Fixes white screens with DCN 3.1.4.

Based on a patch from Yifan Zhang <yifan1.zhang@amd.com>

Cc: Yifan Zhang <yifan1.zhang@amd.com>
Acked-by: Harry Wentland <harry.wentland@amd.com>
Reviewed-by: Yifan Zhang <yifan1.zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.1.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   42 ++++++++++++++--------
 1 file changed, 28 insertions(+), 14 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1193,24 +1193,38 @@ static void mmhub_read_system_context(st
 
 	memset(pa_config, 0, sizeof(*pa_config));
 
-	logical_addr_low  = min(adev->gmc.fb_start, adev->gmc.agp_start) >> 18;
-	pt_base = amdgpu_gmc_pd_addr(adev->gart.bo);
-
-	if (adev->apu_flags & AMD_APU_IS_RAVEN2)
-		/*
-		 * Raven2 has a HW issue that it is unable to use the vram which
-		 * is out of MC_VM_SYSTEM_APERTURE_HIGH_ADDR. So here is the
-		 * workaround that increase system aperture high address (add 1)
-		 * to get rid of the VM fault and hardware hang.
-		 */
-		logical_addr_high = max((adev->gmc.fb_end >> 18) + 0x1, adev->gmc.agp_end >> 18);
-	else
-		logical_addr_high = max(adev->gmc.fb_end, adev->gmc.agp_end) >> 18;
-
 	agp_base = 0;
 	agp_bot = adev->gmc.agp_start >> 24;
 	agp_top = adev->gmc.agp_end >> 24;
 
+	/* AGP aperture is disabled */
+	if (agp_bot == agp_top) {
+		logical_addr_low  = adev->gmc.vram_start >> 18;
+		if (adev->apu_flags & AMD_APU_IS_RAVEN2)
+			/*
+			 * Raven2 has a HW issue that it is unable to use the vram which
+			 * is out of MC_VM_SYSTEM_APERTURE_HIGH_ADDR. So here is the
+			 * workaround that increase system aperture high address (add 1)
+			 * to get rid of the VM fault and hardware hang.
+			 */
+			logical_addr_high = (adev->gmc.fb_end >> 18) + 0x1;
+		else
+			logical_addr_high = adev->gmc.vram_end >> 18;
+	} else {
+		logical_addr_low  = min(adev->gmc.fb_start, adev->gmc.agp_start) >> 18;
+		if (adev->apu_flags & AMD_APU_IS_RAVEN2)
+			/*
+			 * Raven2 has a HW issue that it is unable to use the vram which
+			 * is out of MC_VM_SYSTEM_APERTURE_HIGH_ADDR. So here is the
+			 * workaround that increase system aperture high address (add 1)
+			 * to get rid of the VM fault and hardware hang.
+			 */
+			logical_addr_high = max((adev->gmc.fb_end >> 18) + 0x1, adev->gmc.agp_end >> 18);
+		else
+			logical_addr_high = max(adev->gmc.fb_end, adev->gmc.agp_end) >> 18;
+	}
+
+	pt_base = amdgpu_gmc_pd_addr(adev->gart.bo);
 
 	page_table_start.high_part = (u32)(adev->gmc.gart_start >> 44) & 0xF;
 	page_table_start.low_part = (u32)(adev->gmc.gart_start >> 12);


