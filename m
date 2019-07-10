Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 635B56490D
	for <lists+stable@lfdr.de>; Wed, 10 Jul 2019 17:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728217AbfGJPDe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jul 2019 11:03:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:35522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728207AbfGJPDd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Jul 2019 11:03:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8144721530;
        Wed, 10 Jul 2019 15:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562771012;
        bh=jyNK6v7ZXgHIt1v/x0V6eXb0cohrsUZiPA+zCWQ19pk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XOxuemFHjPQSCG+dllZusWOdpD2M2XAl/KQAboaKB9pM++mYOIozAqJMIwi1GKU5k
         KJNoQJftHchn6R803rm9NJBRL9ITasvU9IGSlud9UCdgtcMNVFwoLU/HPBhqCdcMcR
         Lkk3RZ0zI2xhV001VJ0Edp/XygQgYGeokcjC+JGY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Robert Beckett <bob.beckett@collabora.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.14 6/8] drm/imx: notify drm core before sending event during crtc disable
Date:   Wed, 10 Jul 2019 11:03:16 -0400
Message-Id: <20190710150319.7258-6-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190710150319.7258-1-sashal@kernel.org>
References: <20190710150319.7258-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Beckett <bob.beckett@collabora.com>

[ Upstream commit 78c68e8f5cd24bd32ba4ca1cdfb0c30cf0642685 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/imx/ipuv3-crtc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/imx/ipuv3-crtc.c b/drivers/gpu/drm/imx/ipuv3-crtc.c
index 957fbf8c55eb..7845202d0486 100644
--- a/drivers/gpu/drm/imx/ipuv3-crtc.c
+++ b/drivers/gpu/drm/imx/ipuv3-crtc.c
@@ -99,14 +99,14 @@ static void ipu_crtc_atomic_disable(struct drm_crtc *crtc,
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
-- 
2.20.1

