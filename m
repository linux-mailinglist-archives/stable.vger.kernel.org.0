Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC9255CA99
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244351AbiF1CZB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 22:25:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244065AbiF1CXs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 22:23:48 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE53722C;
        Mon, 27 Jun 2022 19:23:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 20FA6CE1BD3;
        Tue, 28 Jun 2022 02:23:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A68AC36AE2;
        Tue, 28 Jun 2022 02:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656382979;
        bh=mZorZnBDhd8tM4rvi3iSjxVRtl1UH9oN/D4gw/tPpL8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G1A/7izxd8ZfUnP++fvQU2Y3ixUS9ouGMbAvDj8cahTx7lGBWDzKhMAvDE+lLCcjL
         0y45jUpN6uxgFXyi04aU8rTFhrZFvRlA3dvNbfC3GzZ3Ea5Wqzw/0smq7/ZQ0iT1y7
         tumR+8yqYta3k+HjgnmMBbHqbscKtXRl/vFKtzlPV0naBmGpEqkfoFS9oLTdf2Xfln
         isxR6rMADrbOBLggggAhHcxFK4SdwPGlKV3o48dzgzm8e67uCSjpEsgLwqO0MQyCBA
         KbBc9UAX8LhPET9vgzMAGt2vlJsRhlS3mVSf2n8f6qY6vez5AlDnRC4E8a58mhfCG3
         hkxaGU0QjZO/g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maxime Ripard <maxime@cerno.tech>, Melissa Wen <mwen@igalia.com>,
        Sasha Levin <sashal@kernel.org>, emma@anholt.net,
        mripard@kernel.org, airlied@linux.ie, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 08/34] drm/vc4: crtc: Move the BO handling out of common page-flip callback
Date:   Mon, 27 Jun 2022 22:22:15 -0400
Message-Id: <20220628022241.595835-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628022241.595835-1-sashal@kernel.org>
References: <20220628022241.595835-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit 4d12c36fb73b5c49fe2f95d06515fd9846010fd2 ]

We'll soon introduce another completion callback source that won't need
to use the BO reference counting, so let's move it around to create a
function we will be able to share between both callbacks.

Reviewed-by: Melissa Wen <mwen@igalia.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://lore.kernel.org/r/20220610115149.964394-11-maxime@cerno.tech
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_crtc.c | 34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_crtc.c b/drivers/gpu/drm/vc4/vc4_crtc.c
index c0332b69d22c..94bc20247ef9 100644
--- a/drivers/gpu/drm/vc4/vc4_crtc.c
+++ b/drivers/gpu/drm/vc4/vc4_crtc.c
@@ -722,21 +722,8 @@ vc4_async_page_flip_complete(struct vc4_async_flip_state *flip_state)
 	drm_crtc_vblank_put(crtc);
 	drm_framebuffer_put(flip_state->fb);
 
-	/* Decrement the BO usecnt in order to keep the inc/dec calls balanced
-	 * when the planes are updated through the async update path.
-	 * FIXME: we should move to generic async-page-flip when it's
-	 * available, so that we can get rid of this hand-made cleanup_fb()
-	 * logic.
-	 */
-	if (flip_state->old_fb) {
-		struct drm_gem_cma_object *cma_bo;
-		struct vc4_bo *bo;
-
-		cma_bo = drm_fb_cma_get_gem_obj(flip_state->old_fb, 0);
-		bo = to_vc4_bo(&cma_bo->base);
-		vc4_bo_dec_usecnt(bo);
+	if (flip_state->old_fb)
 		drm_framebuffer_put(flip_state->old_fb);
-	}
 
 	kfree(flip_state);
 
@@ -747,8 +734,27 @@ static void vc4_async_page_flip_seqno_complete(struct vc4_seqno_cb *cb)
 {
 	struct vc4_async_flip_state *flip_state =
 		container_of(cb, struct vc4_async_flip_state, cb.seqno);
+	struct vc4_bo *bo = NULL;
+
+	if (flip_state->old_fb) {
+		struct drm_gem_cma_object *cma_bo =
+			drm_fb_cma_get_gem_obj(flip_state->old_fb, 0);
+		bo = to_vc4_bo(&cma_bo->base);
+	}
 
 	vc4_async_page_flip_complete(flip_state);
+
+	/*
+	 * Decrement the BO usecnt in order to keep the inc/dec
+	 * calls balanced when the planes are updated through
+	 * the async update path.
+	 *
+	 * FIXME: we should move to generic async-page-flip when
+	 * it's available, so that we can get rid of this
+	 * hand-made cleanup_fb() logic.
+	 */
+	if (bo)
+		vc4_bo_dec_usecnt(bo);
 }
 
 /* Implements async (non-vblank-synced) page flips.
-- 
2.35.1

