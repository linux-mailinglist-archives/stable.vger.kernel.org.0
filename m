Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49A655938F8
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbiHOS53 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:57:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244472AbiHOSx5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:53:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 189BC48C83;
        Mon, 15 Aug 2022 11:30:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D855B81062;
        Mon, 15 Aug 2022 18:30:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2E25C433C1;
        Mon, 15 Aug 2022 18:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588201;
        bh=0N4As4azLpHBEk0eq2k/MWRlxyWK2E4iyLDYUMLXGQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hgvkswPjp4f8h8ApA+D+YhaRXgGpmW87zraGkswrPgeO/CgpQBnRqRgzT3xEt5R+p
         M6TFdQregJZQYICQINJL54nWip7Op6HpNeGmynBHp/psiwbum4XbdnLgkm1XvqUm6W
         KfVF/i+UeCQa3ibGth+5VLHHbPi1njF2BHKOm1rk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 295/779] drm/vc4: plane: Fix margin calculations for the right/bottom edges
Date:   Mon, 15 Aug 2022 19:58:59 +0200
Message-Id: <20220815180349.907225246@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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
index e9d214d42cc7..8574acefd40e 100644
--- a/drivers/gpu/drm/vc4/vc4_plane.c
+++ b/drivers/gpu/drm/vc4/vc4_plane.c
@@ -303,16 +303,16 @@ static int vc4_plane_margins_adj(struct drm_plane_state *pstate)
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



