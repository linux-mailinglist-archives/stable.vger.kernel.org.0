Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 488BD499D89
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1582812AbiAXWYY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:24:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381209AbiAXWTa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:19:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2F25C04A2F1;
        Mon, 24 Jan 2022 12:49:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 489C4B811A9;
        Mon, 24 Jan 2022 20:49:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C198C340E7;
        Mon, 24 Jan 2022 20:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057374;
        bh=q7ihR5Snu2W1wGEKLmd6hmJZ58qgPjBl7VGdE/uxV+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aFSWhDkn94emBiThBWnZx7tk9LJ4SHIWnNZmwfgQeXkg766qNEkOt661tmgESNrpW
         bSUFrzxz+6cPUFkWXnO8yY+WYlIh7Cc9H10RI7qiVl+mRBjTcoKQvQpCSaxuKHQF2p
         xcSzaWKTjL9T4tlgRoyI1tnvqEnl/Bo+qddipIIA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Maxime Ripard <maxime@cerno.tech>
Subject: [PATCH 5.15 759/846] drm/vc4: crtc: Drop feed_txp from state
Date:   Mon, 24 Jan 2022 19:44:36 +0100
Message-Id: <20220124184127.147164301@linuxfoundation.org>
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

commit a16c66401fd831f70a02d33e9bcaac585637c29f upstream.

Accessing the crtc->state pointer from outside the modesetting context
is not allowed. We thus need to copy whatever we need from the KMS state
to our structure in order to access it.

In VC4, a number of users of that pointers have crept in over the years,
the first one being whether or not the downstream controller of the
pixelvalve is our writeback controller.

Fortunately for us, Since commit 39fcb2808376 ("drm/vc4: txp: Turn the
TXP into a CRTC of its own") this is no longer something that can change
from one commit to the other and is hardcoded.

Let's set this flag in struct vc4_crtc if we happen to be the TXP, and
drop the flag from our private state structure.

Link: https://lore.kernel.org/all/YWgteNaNeaS9uWDe@phenom.ffwll.local/
Link: https://lore.kernel.org/r/20211025141113.702757-2-maxime@cerno.tech
Fixes: 008095e065a8 ("drm/vc4: Add support for the transposer block")
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vc4/vc4_crtc.c |    3 +--
 drivers/gpu/drm/vc4/vc4_drv.h  |    6 +++++-
 drivers/gpu/drm/vc4/vc4_hvs.c  |    7 +++----
 drivers/gpu/drm/vc4/vc4_kms.c  |    3 ++-
 drivers/gpu/drm/vc4/vc4_txp.c  |    3 +--
 5 files changed, 12 insertions(+), 10 deletions(-)

--- a/drivers/gpu/drm/vc4/vc4_crtc.c
+++ b/drivers/gpu/drm/vc4/vc4_crtc.c
@@ -715,7 +715,7 @@ static void vc4_crtc_handle_page_flip(st
 	spin_lock_irqsave(&dev->event_lock, flags);
 	if (vc4_crtc->event &&
 	    (vc4_state->mm.start == HVS_READ(SCALER_DISPLACTX(chan)) ||
-	     vc4_state->feed_txp)) {
+	     vc4_crtc->feeds_txp)) {
 		drm_crtc_send_vblank_event(crtc, vc4_crtc->event);
 		vc4_crtc->event = NULL;
 		drm_crtc_vblank_put(crtc);
@@ -893,7 +893,6 @@ struct drm_crtc_state *vc4_crtc_duplicat
 		return NULL;
 
 	old_vc4_state = to_vc4_crtc_state(crtc->state);
-	vc4_state->feed_txp = old_vc4_state->feed_txp;
 	vc4_state->margins = old_vc4_state->margins;
 	vc4_state->assigned_channel = old_vc4_state->assigned_channel;
 
--- a/drivers/gpu/drm/vc4/vc4_drv.h
+++ b/drivers/gpu/drm/vc4/vc4_drv.h
@@ -495,6 +495,11 @@ struct vc4_crtc {
 	struct drm_pending_vblank_event *event;
 
 	struct debugfs_regset32 regset;
+
+	/**
+	 * @feeds_txp: True if the CRTC feeds our writeback controller.
+	 */
+	bool feeds_txp;
 };
 
 static inline struct vc4_crtc *
@@ -521,7 +526,6 @@ struct vc4_crtc_state {
 	struct drm_crtc_state base;
 	/* Dlist area for this CRTC configuration. */
 	struct drm_mm_node mm;
-	bool feed_txp;
 	bool txp_armed;
 	unsigned int assigned_channel;
 
--- a/drivers/gpu/drm/vc4/vc4_hvs.c
+++ b/drivers/gpu/drm/vc4/vc4_hvs.c
@@ -375,7 +375,7 @@ static void vc4_hvs_update_dlist(struct
 
 		spin_lock_irqsave(&dev->event_lock, flags);
 
-		if (!vc4_state->feed_txp || vc4_state->txp_armed) {
+		if (!vc4_crtc->feeds_txp || vc4_state->txp_armed) {
 			vc4_crtc->event = crtc->state->event;
 			crtc->state->event = NULL;
 		}
@@ -395,10 +395,9 @@ void vc4_hvs_atomic_enable(struct drm_cr
 {
 	struct drm_device *dev = crtc->dev;
 	struct vc4_dev *vc4 = to_vc4_dev(dev);
-	struct drm_crtc_state *new_crtc_state = drm_atomic_get_new_crtc_state(state, crtc);
-	struct vc4_crtc_state *vc4_state = to_vc4_crtc_state(new_crtc_state);
 	struct drm_display_mode *mode = &crtc->state->adjusted_mode;
-	bool oneshot = vc4_state->feed_txp;
+	struct vc4_crtc *vc4_crtc = to_vc4_crtc(crtc);
+	bool oneshot = vc4_crtc->feeds_txp;
 
 	vc4_hvs_update_dlist(crtc);
 	vc4_hvs_init_channel(vc4, crtc, mode, oneshot);
--- a/drivers/gpu/drm/vc4/vc4_kms.c
+++ b/drivers/gpu/drm/vc4/vc4_kms.c
@@ -233,6 +233,7 @@ static void vc4_hvs_pv_muxing_commit(str
 	unsigned int i;
 
 	for_each_new_crtc_in_state(state, crtc, crtc_state, i) {
+		struct vc4_crtc *vc4_crtc = to_vc4_crtc(crtc);
 		struct vc4_crtc_state *vc4_state = to_vc4_crtc_state(crtc_state);
 		u32 dispctrl;
 		u32 dsp3_mux;
@@ -253,7 +254,7 @@ static void vc4_hvs_pv_muxing_commit(str
 		 * TXP IP, and we need to disable the FIFO2 -> pixelvalve1
 		 * route.
 		 */
-		if (vc4_state->feed_txp)
+		if (vc4_crtc->feeds_txp)
 			dsp3_mux = VC4_SET_FIELD(3, SCALER_DISPCTRL_DSP3_MUX);
 		else
 			dsp3_mux = VC4_SET_FIELD(2, SCALER_DISPCTRL_DSP3_MUX);
--- a/drivers/gpu/drm/vc4/vc4_txp.c
+++ b/drivers/gpu/drm/vc4/vc4_txp.c
@@ -391,7 +391,6 @@ static int vc4_txp_atomic_check(struct d
 {
 	struct drm_crtc_state *crtc_state = drm_atomic_get_new_crtc_state(state,
 									  crtc);
-	struct vc4_crtc_state *vc4_state = to_vc4_crtc_state(crtc_state);
 	int ret;
 
 	ret = vc4_hvs_atomic_check(crtc, state);
@@ -399,7 +398,6 @@ static int vc4_txp_atomic_check(struct d
 		return ret;
 
 	crtc_state->no_vblank = true;
-	vc4_state->feed_txp = true;
 
 	return 0;
 }
@@ -482,6 +480,7 @@ static int vc4_txp_bind(struct device *d
 
 	vc4_crtc->pdev = pdev;
 	vc4_crtc->data = &vc4_txp_crtc_data;
+	vc4_crtc->feeds_txp = true;
 
 	txp->pdev = pdev;
 


