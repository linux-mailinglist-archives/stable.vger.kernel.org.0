Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFBC762231
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729700AbfGHPXY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:23:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:50430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388180AbfGHPXY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:23:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C126214C6;
        Mon,  8 Jul 2019 15:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599403;
        bh=jFLaiQnvGp8UNDb9IEsBU0xxlAQbsJv2AIo7kzHMCzY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uxe67mSaNQNRWI0Tcap1whKAbQvYwpC/FSm3mfbOQlRYAq02fx2m3jmsCivVBYdQq
         k8idI7erMoWCvjZzFD6Vu8J9h45IFznoXrWmUupGuJHuHLaGjxQONt/Oo8nJgjrQmv
         2qqBUoOY8l/c564A4P18vW9k8tnk1so4R2UF1mjo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Beckett <bob.beckett@collabora.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 4.9 093/102] drm/imx: notify drm core before sending event during crtc disable
Date:   Mon,  8 Jul 2019 17:13:26 +0200
Message-Id: <20190708150531.279646248@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150525.973820964@linuxfoundation.org>
References: <20190708150525.973820964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Beckett <bob.beckett@collabora.com>

commit 78c68e8f5cd24bd32ba4ca1cdfb0c30cf0642685 upstream.

Notify drm core before sending pending events during crtc disable.
This fixes the first event after disable having an old stale timestamp
by having drm_crtc_vblank_off update the timestamp to now.

This was seen while debugging weston log message:
Warning: computed repaint delay is insane: -8212 msec

This occurred due to:
1. driver starts up
2. fbcon comes along and restores fbdev, enabling vblank
3. vblank_disable_fn fires via timer disabling vblank, keeping vblank
seq number and time set at current value
(some time later)
4. weston starts and does a modeset
5. atomic commit disables crtc while it does the modeset
6. ipu_crtc_atomic_disable sends vblank with old seq number and time

Fixes: a474478642d5 ("drm/imx: fix crtc vblank state regression")

Signed-off-by: Robert Beckett <bob.beckett@collabora.com>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/imx/ipuv3-crtc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/imx/ipuv3-crtc.c
+++ b/drivers/gpu/drm/imx/ipuv3-crtc.c
@@ -76,14 +76,14 @@ static void ipu_crtc_atomic_disable(stru
 	drm_atomic_helper_disable_planes_on_crtc(old_crtc_state, false);
 	ipu_dc_disable(ipu);
 
+	drm_crtc_vblank_off(crtc);
+
 	spin_lock_irq(&crtc->dev->event_lock);
 	if (crtc->state->event) {
 		drm_crtc_send_vblank_event(crtc, crtc->state->event);
 		crtc->state->event = NULL;
 	}
 	spin_unlock_irq(&crtc->dev->event_lock);
-
-	drm_crtc_vblank_off(crtc);
 }
 
 static void imx_drm_crtc_reset(struct drm_crtc *crtc)


