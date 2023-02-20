Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9DAE69CE9F
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 15:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232764AbjBTOAy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 09:00:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232763AbjBTOAy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 09:00:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2D9E1E9F8
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 06:00:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8271B60EAD
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:59:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9284AC433D2;
        Mon, 20 Feb 2023 13:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901597;
        bh=oqiT5wxPtZsbZmtJ5ApI5pO5NWyVhndGcNGQBGQ/niY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YtsnocPDWRxYSOFfP4PiJIJh1OIRSVDp0budRPdsRrB/899PPbW+hqMuyGGUeCMly
         cSie5WI4IXPoW7PiPdF+1+yhth6bR166hpADryDJs/WUc+WzYN/XepEj4V1jxpcRKl
         tchOQ/vd3sWoo9J0gEJtoFtFCoeaw4NAyTGljFlA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Maxime Ripard <maxime@cerno.tech>
Subject: [PATCH 6.1 079/118] drm/vc4: Fix YUV plane handling when planes are in different buffers
Date:   Mon, 20 Feb 2023 14:36:35 +0100
Message-Id: <20230220133603.574607411@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Stevenson <dave.stevenson@raspberrypi.com>

commit 6b77b16de75a6efc0870b1fa467209387cbee8f3 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vc4/vc4_plane.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/vc4/vc4_plane.c
+++ b/drivers/gpu/drm/vc4/vc4_plane.c
@@ -340,7 +340,7 @@ static int vc4_plane_setup_clipping_and_
 {
 	struct vc4_plane_state *vc4_state = to_vc4_plane_state(state);
 	struct drm_framebuffer *fb = state->fb;
-	struct drm_gem_dma_object *bo = drm_fb_dma_get_gem_obj(fb, 0);
+	struct drm_gem_dma_object *bo;
 	int num_planes = fb->format->num_planes;
 	struct drm_crtc_state *crtc_state;
 	u32 h_subsample = fb->format->hsub;
@@ -359,8 +359,10 @@ static int vc4_plane_setup_clipping_and_
 	if (ret)
 		return ret;
 
-	for (i = 0; i < num_planes; i++)
+	for (i = 0; i < num_planes; i++) {
+		bo = drm_fb_dma_get_gem_obj(fb, i);
 		vc4_state->offsets[i] = bo->dma_addr + fb->offsets[i];
+	}
 
 	/*
 	 * We don't support subpixel source positioning for scaling,


