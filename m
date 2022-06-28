Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56D9355C8FE
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244885AbiF1CaE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 22:30:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244691AbiF1C1r (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 22:27:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 861AD25E9B;
        Mon, 27 Jun 2022 19:25:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 412C5B81C0E;
        Tue, 28 Jun 2022 02:25:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADDDAC385A2;
        Tue, 28 Jun 2022 02:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656383128;
        bh=2GFNxfbfgJwBO/JnDWPtSFfZrOQJgMiGWEiqxbP9VBY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oCVAx/ooXyf4V8T35kLlEm8ae+HDlkmZEgl+apevAkvxdC5e8PI44tuZhtX+q8xNI
         GdBQqdLDldVqcCfw7pWTtmlADDw2UFMl/SLYymwMINd0P0YyT4hmtfweQCyEoafckX
         1KupPN5bez3jkTetlb6y8ST9VyvxUK7xYkvFwCkQV6qO4WphF9H+RpBBby7vu6kOcf
         1OgIbuupuTf1ZJzomEuNzdKa5ObaeHjEYyarrwUgmA4VC/6fykbdho6sHmBmtcZGLb
         aRu3HQ/F25fFSiNcfnbMRJZ9dyWrYCYue7/Tp7OgUQ2/jf6DNKavuAMaW4SVf52ODN
         n76ARRJg5nJGw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maxime Ripard <maxime@cerno.tech>, Melissa Wen <mwen@igalia.com>,
        Sasha Levin <sashal@kernel.org>, emma@anholt.net,
        mripard@kernel.org, airlied@linux.ie, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 05/22] drm/vc4: crtc: Move the BO handling out of common page-flip callback
Date:   Mon, 27 Jun 2022 22:25:00 -0400
Message-Id: <20220628022518.596687-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628022518.596687-1-sashal@kernel.org>
References: <20220628022518.596687-1-sashal@kernel.org>
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
index 9152d4d9c5d7..c85af9f54e0d 100644
--- a/drivers/gpu/drm/vc4/vc4_crtc.c
+++ b/drivers/gpu/drm/vc4/vc4_crtc.c
@@ -851,21 +851,8 @@ vc4_async_page_flip_complete(struct vc4_async_flip_state *flip_state)
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
 
@@ -876,8 +863,27 @@ static void vc4_async_page_flip_seqno_complete(struct vc4_seqno_cb *cb)
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

