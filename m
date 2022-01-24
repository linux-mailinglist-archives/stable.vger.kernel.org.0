Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04960499D8A
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381573AbiAXWY0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:24:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1583740AbiAXWTa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:19:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95DD9C04A2F9;
        Mon, 24 Jan 2022 12:49:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 533E9B8122A;
        Mon, 24 Jan 2022 20:49:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FF58C340E5;
        Mon, 24 Jan 2022 20:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057377;
        bh=erMBbhktD/e8ZzmhSjqjLHdeMwvuoTg8BFvNKzz4T5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dWSvV1l8SxIMtm/hAdZd63CQPCY7TcQU4idySKkv7vKjSTzrXybusfsme7XYnO5WD
         571oKWYDxS+XyMt1Fa0BxzA9c3pKMF+46/YCofF64x2yve5WNi7ddYRPGFU1YSHkOx
         MDxP0uDazfcccerv/H25b6XySVFXDLf+473PUjXw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Maxime Ripard <maxime@cerno.tech>
Subject: [PATCH 5.15 760/846] drm/vc4: Fix non-blocking commit getting stuck forever
Date:   Mon, 24 Jan 2022 19:44:37 +0100
Message-Id: <20220124184127.181674912@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime@cerno.tech>

commit 0c250c150c74a90db298bf2a8bcd0a1dabed2e2f upstream.

In some situation, we can end up being stuck on a non-blocking that went
through properly.

The situation that seems to trigger it reliably is to first start a
non-blocking commit, and then right after, and before we had any vblank
interrupt), start a blocking commit.

This will lead to the first commit workqueue to be scheduled, setup the
display, while the second commit is waiting for the first one to be
completed.

The vblank interrupt will then be raised, vc4_crtc_handle_vblank() will
run and will compare the active dlist in the HVS channel to the one
associated with the crtc->state.

However, at that point, the second commit is waiting using
drm_atomic_helper_wait_for_dependencies that occurs after
drm_atomic_helper_swap_state has been called, so crtc->state points to
the second commit state. vc4_crtc_handle_vblank() will compare the two
dlist addresses and since they don't match will ignore the interrupt.

The vblank event will never be reported, and the first and second commit
will wait for the first commit completion until they timeout.

The underlying reason is that it was never safe to do so. Indeed,
accessing the ->state pointer access synchronization is based on
ownership guarantees that can only occur within the functions and hooks
defined as part of the KMS framework, and obviously the irq handler
isn't one of them. The rework to move to generic helpers only uncovered
the underlying issue.

However, since the code path between
drm_atomic_helper_wait_for_dependencies() and
drm_atomic_helper_wait_for_vblanks() is serialised and we can't get two
commits in that path at the same time, we can work around this issue by
setting a variable associated to struct drm_crtc to the dlist we expect,
and then using it from the vc4_crtc_handle_vblank() function.

Since that state is shared with the modesetting path, we also need to
introduce a spinlock to protect the code shared between the interrupt
handler and the modesetting path, protecting only our new variable for
now.

Link: https://lore.kernel.org/all/YWgteNaNeaS9uWDe@phenom.ffwll.local/
Link: https://lore.kernel.org/r/20211025141113.702757-3-maxime@cerno.tech
Fixes: 56d1fe0979dc ("drm/vc4: Make pageflip completion handling more robust.")
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vc4/vc4_crtc.c |    5 ++++-
 drivers/gpu/drm/vc4/vc4_drv.h  |   14 ++++++++++++++
 drivers/gpu/drm/vc4/vc4_hvs.c  |    7 +++++--
 3 files changed, 23 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/vc4/vc4_crtc.c
+++ b/drivers/gpu/drm/vc4/vc4_crtc.c
@@ -713,8 +713,9 @@ static void vc4_crtc_handle_page_flip(st
 	unsigned long flags;
 
 	spin_lock_irqsave(&dev->event_lock, flags);
+	spin_lock(&vc4_crtc->irq_lock);
 	if (vc4_crtc->event &&
-	    (vc4_state->mm.start == HVS_READ(SCALER_DISPLACTX(chan)) ||
+	    (vc4_crtc->current_dlist == HVS_READ(SCALER_DISPLACTX(chan)) ||
 	     vc4_crtc->feeds_txp)) {
 		drm_crtc_send_vblank_event(crtc, vc4_crtc->event);
 		vc4_crtc->event = NULL;
@@ -728,6 +729,7 @@ static void vc4_crtc_handle_page_flip(st
 		 */
 		vc4_hvs_unmask_underrun(dev, chan);
 	}
+	spin_unlock(&vc4_crtc->irq_lock);
 	spin_unlock_irqrestore(&dev->event_lock, flags);
 }
 
@@ -1127,6 +1129,7 @@ int vc4_crtc_init(struct drm_device *drm
 		return PTR_ERR(primary_plane);
 	}
 
+	spin_lock_init(&vc4_crtc->irq_lock);
 	drm_crtc_init_with_planes(drm, crtc, primary_plane, NULL,
 				  crtc_funcs, NULL);
 	drm_crtc_helper_add(crtc, crtc_helper_funcs);
--- a/drivers/gpu/drm/vc4/vc4_drv.h
+++ b/drivers/gpu/drm/vc4/vc4_drv.h
@@ -500,6 +500,20 @@ struct vc4_crtc {
 	 * @feeds_txp: True if the CRTC feeds our writeback controller.
 	 */
 	bool feeds_txp;
+
+	/**
+	 * @irq_lock: Spinlock protecting the resources shared between
+	 * the atomic code and our vblank handler.
+	 */
+	spinlock_t irq_lock;
+
+	/**
+	 * @current_dlist: Start offset of the display list currently
+	 * set in the HVS for that CRTC. Protected by @irq_lock, and
+	 * copied in vc4_hvs_update_dlist() for the CRTC interrupt
+	 * handler to have access to that value.
+	 */
+	unsigned int current_dlist;
 };
 
 static inline struct vc4_crtc *
--- a/drivers/gpu/drm/vc4/vc4_hvs.c
+++ b/drivers/gpu/drm/vc4/vc4_hvs.c
@@ -365,10 +365,9 @@ static void vc4_hvs_update_dlist(struct
 	struct vc4_dev *vc4 = to_vc4_dev(dev);
 	struct vc4_crtc *vc4_crtc = to_vc4_crtc(crtc);
 	struct vc4_crtc_state *vc4_state = to_vc4_crtc_state(crtc->state);
+	unsigned long flags;
 
 	if (crtc->state->event) {
-		unsigned long flags;
-
 		crtc->state->event->pipe = drm_crtc_index(crtc);
 
 		WARN_ON(drm_crtc_vblank_get(crtc) != 0);
@@ -388,6 +387,10 @@ static void vc4_hvs_update_dlist(struct
 		HVS_WRITE(SCALER_DISPLISTX(vc4_state->assigned_channel),
 			  vc4_state->mm.start);
 	}
+
+	spin_lock_irqsave(&vc4_crtc->irq_lock, flags);
+	vc4_crtc->current_dlist = vc4_state->mm.start;
+	spin_unlock_irqrestore(&vc4_crtc->irq_lock, flags);
 }
 
 void vc4_hvs_atomic_enable(struct drm_crtc *crtc,


