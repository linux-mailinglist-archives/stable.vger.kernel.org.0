Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6223555CF1C
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243401AbiF1CTb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 22:19:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243385AbiF1CTH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 22:19:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1087101E5;
        Mon, 27 Jun 2022 19:19:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57BC9B818E4;
        Tue, 28 Jun 2022 02:19:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFA1DC341CC;
        Tue, 28 Jun 2022 02:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656382744;
        bh=aJpHDBxSPKCrtqU2Fk3HhwOSeJ8BR8h2i1IZBNLNVyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AbJKJFM7413prlg3NOX6WnA2HoSek/O5NLnJdJoyNBlMpyvWfi6DcGRK6QIN95gzA
         a4irJ3dJlOhs4LAHV8rhBKiBRid/izBaI/YSlizta5PKy7m/V9wSi+K0U8IyWCMJiu
         9o+jBJRSOk3fG/TMi6MmY0jTQRsugkMBu3Zs6FJkaPN98siSOaSivkRya4aw5sFvuC
         QZoufhweCdD0WaEexotmOH4byDgbrxy4RAtZGRut0pi+2yGJ8dnsCyG0feSESyO4Qi
         hwgnrkg/XMNaqjBqvOFmIF3zBS9c7vai2x8K3Sg874mHPflo+rvAXoV5ECA+pJcMqD
         fQOrBrpK8SO9A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maxime Ripard <maxime@cerno.tech>, Melissa Wen <mwen@igalia.com>,
        Sasha Levin <sashal@kernel.org>, emma@anholt.net,
        mripard@kernel.org, airlied@linux.ie, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.18 11/53] drm/vc4: crtc: Use an union to store the page flip callback
Date:   Mon, 27 Jun 2022 22:17:57 -0400
Message-Id: <20220628021839.594423-11-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628021839.594423-1-sashal@kernel.org>
References: <20220628021839.594423-1-sashal@kernel.org>
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
index 477b3c5ad089..3669d7a06439 100644
--- a/drivers/gpu/drm/vc4/vc4_crtc.c
+++ b/drivers/gpu/drm/vc4/vc4_crtc.c
@@ -769,17 +769,17 @@ struct vc4_async_flip_state {
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
 	struct drm_plane *plane = crtc->primary;
@@ -815,6 +815,14 @@ vc4_async_page_flip_complete(struct vc4_seqno_cb *cb)
 	kfree(flip_state);
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
@@ -875,8 +883,8 @@ static int vc4_async_page_flip(struct drm_crtc *crtc,
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

