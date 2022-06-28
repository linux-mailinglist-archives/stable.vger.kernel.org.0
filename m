Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22D4855DD50
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244868AbiF1C37 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 22:29:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244685AbiF1C1r (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 22:27:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 394C925E9E;
        Mon, 27 Jun 2022 19:25:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C3A6861922;
        Tue, 28 Jun 2022 02:25:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5435C341CD;
        Tue, 28 Jun 2022 02:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656383127;
        bh=ad2FX3ZQroRMSFtiEC/UDm+xiK8OJDZ67Y/c7byKK68=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KE3J2rFPVJ6+8UxZUTat0idncT2MymAJs3Z0RxPUkyAva74iwOV/Fn86/JgebaD4+
         N+7hg295Khp9Mbya4yWBenoqFRmSYEGdACuvh/x6jaazWwVafIe041yYAg6xcRU5TL
         v2evOnJ+gBpIHjT2BYPkBoTptO8fccvOXO0moIQsOkLzRIm7LE/eHdQPOqBccfthpH
         MqWR5GIqeDKJtWBCQS59AkVb8Kla62Kv0lMtVcCvkFn6mFgtFEyddTpc1SiWrEkiJ7
         eWYyWRpRuicHzvm5FHBAqeD5C79BUQzU+tGMTe9xgEvvHzWSAvjno5ReCipHs8XDdS
         Wt9+k+pz22HjA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maxime Ripard <maxime@cerno.tech>, Melissa Wen <mwen@igalia.com>,
        Sasha Levin <sashal@kernel.org>, emma@anholt.net,
        mripard@kernel.org, airlied@linux.ie, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 04/22] drm/vc4: crtc: Use an union to store the page flip callback
Date:   Mon, 27 Jun 2022 22:24:59 -0400
Message-Id: <20220628022518.596687-4-sashal@kernel.org>
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

[ Upstream commit 2523e9dcc3be91bf9fdc0d1e542557ca00bbef42 ]

We'll need to extend the vc4_async_flip_state structure to rely on
another callback implementation, so let's move the current one into a
union.

Reviewed-by: Melissa Wen <mwen@igalia.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://lore.kernel.org/r/20220610115149.964394-10-maxime@cerno.tech
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_crtc.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_crtc.c b/drivers/gpu/drm/vc4/vc4_crtc.c
index 5615ceb15708..9152d4d9c5d7 100644
--- a/drivers/gpu/drm/vc4/vc4_crtc.c
+++ b/drivers/gpu/drm/vc4/vc4_crtc.c
@@ -823,17 +823,17 @@ struct vc4_async_flip_state {
 	struct drm_framebuffer *old_fb;
 	struct drm_pending_vblank_event *event;
 
-	struct vc4_seqno_cb cb;
+	union {
+		struct vc4_seqno_cb seqno;
+	} cb;
 };
 
 /* Called when the V3D execution for the BO being flipped to is done, so that
  * we can actually update the plane's address to point to it.
  */
 static void
-vc4_async_page_flip_complete(struct vc4_seqno_cb *cb)
+vc4_async_page_flip_complete(struct vc4_async_flip_state *flip_state)
 {
-	struct vc4_async_flip_state *flip_state =
-		container_of(cb, struct vc4_async_flip_state, cb);
 	struct drm_crtc *crtc = flip_state->crtc;
 	struct drm_device *dev = crtc->dev;
 	struct vc4_dev *vc4 = to_vc4_dev(dev);
@@ -872,6 +872,14 @@ vc4_async_page_flip_complete(struct vc4_seqno_cb *cb)
 	up(&vc4->async_modeset);
 }
 
+static void vc4_async_page_flip_seqno_complete(struct vc4_seqno_cb *cb)
+{
+	struct vc4_async_flip_state *flip_state =
+		container_of(cb, struct vc4_async_flip_state, cb.seqno);
+
+	vc4_async_page_flip_complete(flip_state);
+}
+
 /* Implements async (non-vblank-synced) page flips.
  *
  * The page flip ioctl needs to return immediately, so we grab the
@@ -942,8 +950,8 @@ static int vc4_async_page_flip(struct drm_crtc *crtc,
 	 */
 	drm_atomic_set_fb_for_plane(plane->state, fb);
 
-	vc4_queue_seqno_cb(dev, &flip_state->cb, bo->seqno,
-			   vc4_async_page_flip_complete);
+	vc4_queue_seqno_cb(dev, &flip_state->cb.seqno, bo->seqno,
+			   vc4_async_page_flip_seqno_complete);
 
 	/* Driver takes ownership of state on successful async commit. */
 	return 0;
-- 
2.35.1

