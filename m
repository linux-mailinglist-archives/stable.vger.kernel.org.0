Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20DBE49A4D8
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2371998AbiAYAKW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:10:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2363964AbiAXXq1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:46:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9715EC05A1B9;
        Mon, 24 Jan 2022 13:40:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 384F36150F;
        Mon, 24 Jan 2022 21:40:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 126E1C340E4;
        Mon, 24 Jan 2022 21:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060403;
        bh=NYew2eLHnOVBJzWS0JUQya8E9KMDLrukBSAFBS4kna0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SUa+wJcQp/cwSvWoEV0Cu+UpbdIN6GCRF8tct1O9jXO9bIIutOisSU8ctgACfDhhl
         0m11cNhYFmtJyAlLu+BAmh0LV5AD0UncC2uyT9zEqEhXQqm5Ang1cIgeQi3vft+FJx
         n6jEHBXkC3H2nl+9GwxA0MN3qfuUPg5L2xZEmtl4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Maxime Ripard <maxime@cerno.tech>
Subject: [PATCH 5.16 0935/1039] drm/vc4: crtc: Copy assigned channel to the CRTC
Date:   Mon, 24 Jan 2022 19:45:24 +0100
Message-Id: <20220124184156.717792487@linuxfoundation.org>
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

commit eeb6ab4639590130d25670204ab7b6011333d685 upstream.

Accessing the crtc->state pointer from outside the modesetting context
is not allowed. We thus need to copy whatever we need from the KMS state
to our structure in order to access it.

In VC4, a number of users of that pointers have crept in over the years,
and the previous commits removed them all but the HVS channel a CRTC has
been assigned.

Let's move this channel in struct vc4_crtc at atomic_begin() time, drop
it from our private state structure, and remove our use of crtc->state
from our vblank handler entirely.

Link: https://lore.kernel.org/all/YWgteNaNeaS9uWDe@phenom.ffwll.local/
Link: https://lore.kernel.org/r/20211025141113.702757-4-maxime@cerno.tech
Fixes: 87ebcd42fb7b ("drm/vc4: crtc: Assign output to channel automatically")
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vc4/vc4_crtc.c |    4 ++--
 drivers/gpu/drm/vc4/vc4_drv.h  |    9 +++++++++
 drivers/gpu/drm/vc4/vc4_hvs.c  |   12 ++++++++++++
 drivers/gpu/drm/vc4/vc4_txp.c  |    1 +
 4 files changed, 24 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/vc4/vc4_crtc.c
+++ b/drivers/gpu/drm/vc4/vc4_crtc.c
@@ -708,8 +708,7 @@ static void vc4_crtc_handle_page_flip(st
 	struct drm_crtc *crtc = &vc4_crtc->base;
 	struct drm_device *dev = crtc->dev;
 	struct vc4_dev *vc4 = to_vc4_dev(dev);
-	struct vc4_crtc_state *vc4_state = to_vc4_crtc_state(crtc->state);
-	u32 chan = vc4_state->assigned_channel;
+	u32 chan = vc4_crtc->current_hvs_channel;
 	unsigned long flags;
 
 	spin_lock_irqsave(&dev->event_lock, flags);
@@ -955,6 +954,7 @@ static const struct drm_crtc_funcs vc4_c
 static const struct drm_crtc_helper_funcs vc4_crtc_helper_funcs = {
 	.mode_valid = vc4_crtc_mode_valid,
 	.atomic_check = vc4_crtc_atomic_check,
+	.atomic_begin = vc4_hvs_atomic_begin,
 	.atomic_flush = vc4_hvs_atomic_flush,
 	.atomic_enable = vc4_crtc_atomic_enable,
 	.atomic_disable = vc4_crtc_atomic_disable,
--- a/drivers/gpu/drm/vc4/vc4_drv.h
+++ b/drivers/gpu/drm/vc4/vc4_drv.h
@@ -514,6 +514,14 @@ struct vc4_crtc {
 	 * handler to have access to that value.
 	 */
 	unsigned int current_dlist;
+
+	/**
+	 * @current_hvs_channel: HVS channel currently assigned to the
+	 * CRTC. Protected by @irq_lock, and copied in
+	 * vc4_hvs_atomic_begin() for the CRTC interrupt handler to have
+	 * access to that value.
+	 */
+	unsigned int current_hvs_channel;
 };
 
 static inline struct vc4_crtc *
@@ -926,6 +934,7 @@ extern struct platform_driver vc4_hvs_dr
 void vc4_hvs_stop_channel(struct drm_device *dev, unsigned int output);
 int vc4_hvs_get_fifo_from_output(struct drm_device *dev, unsigned int output);
 int vc4_hvs_atomic_check(struct drm_crtc *crtc, struct drm_atomic_state *state);
+void vc4_hvs_atomic_begin(struct drm_crtc *crtc, struct drm_atomic_state *state);
 void vc4_hvs_atomic_enable(struct drm_crtc *crtc, struct drm_atomic_state *state);
 void vc4_hvs_atomic_disable(struct drm_crtc *crtc, struct drm_atomic_state *state);
 void vc4_hvs_atomic_flush(struct drm_crtc *crtc, struct drm_atomic_state *state);
--- a/drivers/gpu/drm/vc4/vc4_hvs.c
+++ b/drivers/gpu/drm/vc4/vc4_hvs.c
@@ -393,6 +393,18 @@ static void vc4_hvs_update_dlist(struct
 	spin_unlock_irqrestore(&vc4_crtc->irq_lock, flags);
 }
 
+void vc4_hvs_atomic_begin(struct drm_crtc *crtc,
+			  struct drm_atomic_state *state)
+{
+	struct vc4_crtc *vc4_crtc = to_vc4_crtc(crtc);
+	struct vc4_crtc_state *vc4_state = to_vc4_crtc_state(crtc->state);
+	unsigned long flags;
+
+	spin_lock_irqsave(&vc4_crtc->irq_lock, flags);
+	vc4_crtc->current_hvs_channel = vc4_state->assigned_channel;
+	spin_unlock_irqrestore(&vc4_crtc->irq_lock, flags);
+}
+
 void vc4_hvs_atomic_enable(struct drm_crtc *crtc,
 			   struct drm_atomic_state *state)
 {
--- a/drivers/gpu/drm/vc4/vc4_txp.c
+++ b/drivers/gpu/drm/vc4/vc4_txp.c
@@ -435,6 +435,7 @@ static void vc4_txp_atomic_disable(struc
 
 static const struct drm_crtc_helper_funcs vc4_txp_crtc_helper_funcs = {
 	.atomic_check	= vc4_txp_atomic_check,
+	.atomic_begin	= vc4_hvs_atomic_begin,
 	.atomic_flush	= vc4_hvs_atomic_flush,
 	.atomic_enable	= vc4_txp_atomic_enable,
 	.atomic_disable	= vc4_txp_atomic_disable,


