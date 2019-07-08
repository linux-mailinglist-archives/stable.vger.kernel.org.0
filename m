Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 607E0622C4
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:29:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389301AbfGHP2t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:28:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:57386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389357AbfGHP2r (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:28:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF18420645;
        Mon,  8 Jul 2019 15:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599726;
        bh=vbZc4uPPnLp+N+12ISZPZmUubYAfhhAjCpDjEMR9Hdw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FdYiVsEmpYyA7yCQEn5ic2MsyCINX4YZUXBqg54nLVy+joq36Yno4ay389s1fVDb1
         abnqQRl82yGXPcBAaQYDsMyvKSEqWlk02K3e8jcDMBEJSS8gL2vMoMr4kBM9GLbRj6
         ABkCyW1117YrkTKDQEh8TOZ9lnE2IFRkBrFLYQjw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Beckett <bob.beckett@collabora.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 4.19 58/90] drm/imx: notify drm core before sending event during crtc disable
Date:   Mon,  8 Jul 2019 17:13:25 +0200
Message-Id: <20190708150525.378226208@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150521.829733162@linuxfoundation.org>
References: <20190708150521.829733162@linuxfoundation.org>
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
@@ -98,14 +98,14 @@ static void ipu_crtc_atomic_disable(stru
 	ipu_dc_disable(ipu);
 	ipu_prg_disable(ipu);
 
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


