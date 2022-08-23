Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8063C59E2CF
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232388AbiHWLRt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:17:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346593AbiHWLRN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:17:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74C9DBD75E;
        Tue, 23 Aug 2022 02:20:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB1DB60F85;
        Tue, 23 Aug 2022 09:20:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBF29C433D7;
        Tue, 23 Aug 2022 09:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661246434;
        bh=I84a5gVb/NLiQQOrHwz9RdfRGp+3FyR7lZPvKAxpz2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SeQ5xqJgJ8irXhPvFqgk6/N+VKC++eqbIkN8orPCYiIr6E2YleRsmEkOYiC0j74E8
         flPoHyniogiN/taCD19+kvh1D1t0zEneiCWt/rsBoPUabwTdD0x/1IsPpu4WYVM53X
         7OFsdldGO062//28CLTYEm5I5u4/xsAmPEdbsOJY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 109/389] drm/vc4: plane: Fix margin calculations for the right/bottom edges
Date:   Tue, 23 Aug 2022 10:23:07 +0200
Message-Id: <20220823080120.160869237@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
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

From: Dave Stevenson <dave.stevenson@raspberrypi.com>

[ Upstream commit b7c3d6821627861f4ea3e1f2b595d0ed9e80aac8 ]

The current plane margin calculation code clips the right and bottom
edges of the range based using the left and top margins.

This is obviously wrong, so let's fix it.

Fixes: 666e73587f90 ("drm/vc4: Take margin setup into account when updating planes")
Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Link: https://lore.kernel.org/r/20220613144800.326124-6-maxime@cerno.tech
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_plane.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_plane.c b/drivers/gpu/drm/vc4/vc4_plane.c
index 6e787f684e52..cdcd19698b3c 100644
--- a/drivers/gpu/drm/vc4/vc4_plane.c
+++ b/drivers/gpu/drm/vc4/vc4_plane.c
@@ -288,16 +288,16 @@ static int vc4_plane_margins_adj(struct drm_plane_state *pstate)
 					       adjhdisplay,
 					       crtc_state->mode.hdisplay);
 	vc4_pstate->crtc_x += left;
-	if (vc4_pstate->crtc_x > crtc_state->mode.hdisplay - left)
-		vc4_pstate->crtc_x = crtc_state->mode.hdisplay - left;
+	if (vc4_pstate->crtc_x > crtc_state->mode.hdisplay - right)
+		vc4_pstate->crtc_x = crtc_state->mode.hdisplay - right;
 
 	adjvdisplay = crtc_state->mode.vdisplay - (top + bottom);
 	vc4_pstate->crtc_y = DIV_ROUND_CLOSEST(vc4_pstate->crtc_y *
 					       adjvdisplay,
 					       crtc_state->mode.vdisplay);
 	vc4_pstate->crtc_y += top;
-	if (vc4_pstate->crtc_y > crtc_state->mode.vdisplay - top)
-		vc4_pstate->crtc_y = crtc_state->mode.vdisplay - top;
+	if (vc4_pstate->crtc_y > crtc_state->mode.vdisplay - bottom)
+		vc4_pstate->crtc_y = crtc_state->mode.vdisplay - bottom;
 
 	vc4_pstate->crtc_w = DIV_ROUND_CLOSEST(vc4_pstate->crtc_w *
 					       adjhdisplay,
-- 
2.35.1



