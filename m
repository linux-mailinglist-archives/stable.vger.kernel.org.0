Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5467269B990
	for <lists+stable@lfdr.de>; Sat, 18 Feb 2023 12:06:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbjBRLGR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Feb 2023 06:06:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjBRLGQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Feb 2023 06:06:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06C831A64F
        for <stable@vger.kernel.org>; Sat, 18 Feb 2023 03:06:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 963C060B45
        for <stable@vger.kernel.org>; Sat, 18 Feb 2023 11:06:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6539C433D2;
        Sat, 18 Feb 2023 11:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676718375;
        bh=Az90uwmlmaB208Xy70Iw4uaywTqg+erGTRyNMoxaDM8=;
        h=Subject:To:Cc:From:Date:From;
        b=jLOdlTiYT22arYyqIy8pOBnz/y+tnyxLswWxlDIyx+2/9K/fvxNzLkWMzIJpOX1yX
         qAaIXoV4AXsjAqHSAzbVgEJrBn7DKsCHPgmjmVRrvcAT3OyetVzwXQJVo+V4h1lgYc
         fi1Wsb/+3pF35lWSCIKLWBRkH9DWbNRSGCEVX3iQ=
Subject: FAILED: patch "[PATCH] drm/vc4: Fix YUV plane handling when planes are in different" failed to apply to 4.19-stable tree
To:     dave.stevenson@raspberrypi.com, maxime@cerno.tech
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 18 Feb 2023 12:06:08 +0100
Message-ID: <1676718368165118@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

6b77b16de75a ("drm/vc4: Fix YUV plane handling when planes are in different buffers")
8c30eecc6769 ("drm/gem: rename struct drm_gem_dma_object.{paddr => dma_addr}")
4a83c26a1d87 ("drm/gem: rename GEM CMA helpers to GEM DMA helpers")
6bcfe8eaeef0 ("drm/fb: rename FB CMA helpers to FB DMA helpers")
5e8bf00ea915 ("drm/fb: remove unused includes of drm_fb_cma_helper.h")
a4d847df8b44 ("drm/fsl-dcu: Use drm_plane_helper_destroy()")
254e5e8829a9 ("drm: Remove unnecessary include statements of drm_plane_helper.h")
382fc1f68132 ("drm/atomic-helper: Move DRM_PLANE_HELPER_NO_SCALING to atomic helpers")
b7345c9799da ("drm/vc4: txp: Protect device resources")
e23a5e14aa27 ("Backmerge tag 'v5.19-rc6' of git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux into drm-next")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6b77b16de75a6efc0870b1fa467209387cbee8f3 Mon Sep 17 00:00:00 2001
From: Dave Stevenson <dave.stevenson@raspberrypi.com>
Date: Fri, 27 Jan 2023 16:57:08 +0100
Subject: [PATCH] drm/vc4: Fix YUV plane handling when planes are in different
 buffers

YUV images can either be presented as one allocation with offsets
for the different planes, or multiple allocations with 0 offsets.

The driver only ever calls drm_fb_[dma|cma]_get_gem_obj with plane
index 0, therefore any application using the second approach was
incorrectly rendered.

Correctly determine the address for each plane, removing the
assumption that the base address is the same for each.

Fixes: fc04023fafec ("drm/vc4: Add support for YUV planes.")
Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20230127155708.454704-1-maxime@cerno.tech

diff --git a/drivers/gpu/drm/vc4/vc4_plane.c b/drivers/gpu/drm/vc4/vc4_plane.c
index 8b92a45a3c89..bd5acc4a8687 100644
--- a/drivers/gpu/drm/vc4/vc4_plane.c
+++ b/drivers/gpu/drm/vc4/vc4_plane.c
@@ -340,7 +340,7 @@ static int vc4_plane_setup_clipping_and_scaling(struct drm_plane_state *state)
 {
 	struct vc4_plane_state *vc4_state = to_vc4_plane_state(state);
 	struct drm_framebuffer *fb = state->fb;
-	struct drm_gem_dma_object *bo = drm_fb_dma_get_gem_obj(fb, 0);
+	struct drm_gem_dma_object *bo;
 	int num_planes = fb->format->num_planes;
 	struct drm_crtc_state *crtc_state;
 	u32 h_subsample = fb->format->hsub;
@@ -359,8 +359,10 @@ static int vc4_plane_setup_clipping_and_scaling(struct drm_plane_state *state)
 	if (ret)
 		return ret;
 
-	for (i = 0; i < num_planes; i++)
+	for (i = 0; i < num_planes; i++) {
+		bo = drm_fb_dma_get_gem_obj(fb, i);
 		vc4_state->offsets[i] = bo->dma_addr + fb->offsets[i];
+	}
 
 	/*
 	 * We don't support subpixel source positioning for scaling,

