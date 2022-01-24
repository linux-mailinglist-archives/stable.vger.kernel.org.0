Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD853499AD4
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376386AbiAXVrM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:47:12 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58390 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1456791AbiAXVkC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:40:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2CE736150B;
        Mon, 24 Jan 2022 21:40:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13F90C340E4;
        Mon, 24 Jan 2022 21:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060400;
        bh=erMBbhktD/e8ZzmhSjqjLHdeMwvuoTg8BFvNKzz4T5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gkRvDXrrIfXvJaA0nr77GUWNNcV8TeOlOgL7hVP04jB8fsVZWJ6nF4Sek3Hp43deK
         /5d5xM7gQPJ6JstqZ1n9s9HXIF6LU2/DUzDCz6DwCuy0Wuf9Bm734f3uJrovCPTOf9
         wqrG1qWaY6ZVfo/T9xG2pGfU7Kr4EZlYJwwfPiQs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Maxime Ripard <maxime@cerno.tech>
Subject: [PATCH 5.16 0934/1039] drm/vc4: Fix non-blocking commit getting stuck forever
Date:   Mon, 24 Jan 2022 19:45:23 +0100
Message-Id: <20220124184156.685114259@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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


