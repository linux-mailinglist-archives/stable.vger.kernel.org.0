Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01B45593FC0
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243004AbiHOVCq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:02:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347471AbiHOVB7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:01:59 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07AC7C993B;
        Mon, 15 Aug 2022 12:13:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 32EFBCE1262;
        Mon, 15 Aug 2022 19:13:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2603BC433B5;
        Mon, 15 Aug 2022 19:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590829;
        bh=DuodYeglwcyYUVWH7MhHNAR31lBBl3gMZdqVDqjhWOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YKAppNgkVDSngJjhKoAEvS2F10YqXYYe9QDs6nSo32ddHg779QmsNQk4b65GNOqep
         YlELcdvCyM38sJNCr9ICBMapQtAFRnnkBYNQWi2hgUVQT4X4XFvO5XDNY2lqYfR82C
         nIRN0KmPAkoZES9poNuYHw8sQGgSAy3CGj6+DTGo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dom Cobley <popcornmix@gmail.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0384/1095] drm/vc4: plane: Remove subpixel positioning check
Date:   Mon, 15 Aug 2022 19:56:23 +0200
Message-Id: <20220815180445.569159390@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Dom Cobley <popcornmix@gmail.com>

[ Upstream commit 517db1ab1566dba3093dbdb8de4263ba4aa66416 ]

There is little harm in ignoring fractional coordinates
(they just get truncated).

Without this:
modetest -M vc4 -F tiles,gradient -s 32:1920x1080-60 -P89@74:1920x1080*.1.1@XR24

is rejected. We have the same issue in Kodi when trying to
use zoom options on video.

Note: even if all coordinates are fully integer. e.g.
src:[0,0,1920,1080] dest:[-10,-10,1940,1100]

it will still get rejected as drm_atomic_helper_check_plane_state
uses drm_rect_clip_scaled which transforms this to fractional src coords

Fixes: 21af94cf1a4c ("drm/vc4: Add support for scaling of display planes.")
Signed-off-by: Dom Cobley <popcornmix@gmail.com>
Link: https://lore.kernel.org/r/20220613144800.326124-5-maxime@cerno.tech
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_plane.c | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_plane.c b/drivers/gpu/drm/vc4/vc4_plane.c
index 920a9eefe426..c2c33f200416 100644
--- a/drivers/gpu/drm/vc4/vc4_plane.c
+++ b/drivers/gpu/drm/vc4/vc4_plane.c
@@ -339,7 +339,6 @@ static int vc4_plane_setup_clipping_and_scaling(struct drm_plane_state *state)
 	struct vc4_plane_state *vc4_state = to_vc4_plane_state(state);
 	struct drm_framebuffer *fb = state->fb;
 	struct drm_gem_cma_object *bo = drm_fb_cma_get_gem_obj(fb, 0);
-	u32 subpixel_src_mask = (1 << 16) - 1;
 	int num_planes = fb->format->num_planes;
 	struct drm_crtc_state *crtc_state;
 	u32 h_subsample = fb->format->hsub;
@@ -361,18 +360,15 @@ static int vc4_plane_setup_clipping_and_scaling(struct drm_plane_state *state)
 	for (i = 0; i < num_planes; i++)
 		vc4_state->offsets[i] = bo->paddr + fb->offsets[i];
 
-	/* We don't support subpixel source positioning for scaling. */
-	if ((state->src.x1 & subpixel_src_mask) ||
-	    (state->src.x2 & subpixel_src_mask) ||
-	    (state->src.y1 & subpixel_src_mask) ||
-	    (state->src.y2 & subpixel_src_mask)) {
-		return -EINVAL;
-	}
-
-	vc4_state->src_x = state->src.x1 >> 16;
-	vc4_state->src_y = state->src.y1 >> 16;
-	vc4_state->src_w[0] = (state->src.x2 - state->src.x1) >> 16;
-	vc4_state->src_h[0] = (state->src.y2 - state->src.y1) >> 16;
+	/*
+	 * We don't support subpixel source positioning for scaling,
+	 * but fractional coordinates can be generated by clipping
+	 * so just round for now
+	 */
+	vc4_state->src_x = DIV_ROUND_CLOSEST(state->src.x1, 1 << 16);
+	vc4_state->src_y = DIV_ROUND_CLOSEST(state->src.y1, 1 << 16);
+	vc4_state->src_w[0] = DIV_ROUND_CLOSEST(state->src.x2, 1 << 16) - vc4_state->src_x;
+	vc4_state->src_h[0] = DIV_ROUND_CLOSEST(state->src.y2, 1 << 16) - vc4_state->src_y;
 
 	vc4_state->crtc_x = state->dst.x1;
 	vc4_state->crtc_y = state->dst.y1;
-- 
2.35.1



