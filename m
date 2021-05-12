Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0070737C911
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237941AbhELQOw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:14:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:33628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239288AbhELQHq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:07:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7227961434;
        Wed, 12 May 2021 15:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833833;
        bh=86psEU0rP41Bx+u3AuXxaT+SqBAH7dpDzWUNJJk1e8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YkF1CLlP7jwSME2xcpSEyYWM+skfRtDuZZvgGgNzLSvmsADEiVWrYGZEwd9HoOSff
         akUVdAiRID1nfOmHDq0U5WJsoX/sSQmvcxTmW/jlA2KKOQTl1aBJCe4eU4DtrY89Lx
         hi2pPC1nBEEyn8tup4fT6EHFu44LObQZZv/APE1w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Quanyang Wang <quanyang.wang@windriver.com>,
        Jyri Sarha <jyri.sarha@iki.fi>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 307/601] drm/tilcdc: send vblank event when disabling crtc
Date:   Wed, 12 May 2021 16:46:24 +0200
Message-Id: <20210512144837.926853448@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quanyang Wang <quanyang.wang@windriver.com>

[ Upstream commit f1a75f4dd8edf272b6b7cdccf6ba6254ec9d15fa ]

When run xrandr to change resolution on Beaglebone Black board, it will
print the error information:

root@beaglebone:~# xrandr -display :0 --output HDMI-1 --mode 720x400
[drm:drm_crtc_commit_wait] *ERROR* flip_done timed out
[drm:drm_atomic_helper_wait_for_dependencies] *ERROR* [CRTC:32:tilcdc crtc] commit wait timed out
[drm:drm_crtc_commit_wait] *ERROR* flip_done timed out
[drm:drm_atomic_helper_wait_for_dependencies] *ERROR* [CONNECTOR:34:HDMI-A-1] commit wait timed out
[drm:drm_crtc_commit_wait] *ERROR* flip_done timed out
[drm:drm_atomic_helper_wait_for_dependencies] *ERROR* [PLANE:31:plane-0] commit wait timed out
tilcdc 4830e000.lcdc: already pending page flip!

This is because there is operation sequence as below:

drm_atomic_connector_commit_dpms(mode is DRM_MODE_DPMS_OFF):
    ...
    drm_atomic_helper_setup_commit <- init_completion(commit_A->flip_done)
    drm_atomic_helper_commit_tail
        tilcdc_crtc_atomic_disable
        tilcdc_plane_atomic_update <- drm_crtc_send_vblank_event in tilcdc_crtc_irq
                                      is skipped since tilcdc_crtc->enabled is 0
        tilcdc_crtc_atomic_flush   <- drm_crtc_send_vblank_event is skipped since
                                      crtc->state->event is set to be NULL in
                                      tilcdc_plane_atomic_update
drm_mode_setcrtc:
    ...
    drm_atomic_helper_setup_commit <- init_completion(commit_B->flip_done)
    drm_atomic_helper_wait_for_dependencies
        drm_crtc_commit_wait   <- wait for commit_A->flip_done completing

Just as shown above, the steps which could complete commit_A->flip_done
are all skipped and commit_A->flip_done will never be completed. This will
result a time-out ERROR when drm_crtc_commit_wait check the commit_A->flip_done.
So add drm_crtc_send_vblank_event in tilcdc_crtc_atomic_disable to
complete commit_A->flip_done.

Fixes: cb345decb4d2 ("drm/tilcdc: Use standard drm_atomic_helper_commit")
Signed-off-by: Quanyang Wang <quanyang.wang@windriver.com>
Reviewed-by: Jyri Sarha <jyri.sarha@iki.fi>
Tested-by: Jyri Sarha <jyri.sarha@iki.fi>
Signed-off-by: Jyri Sarha <jyri.sarha@iki.fi>
Link: https://patchwork.freedesktop.org/patch/msgid/20210209082415.382602-1-quanyang.wang@windriver.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tilcdc/tilcdc_crtc.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/tilcdc/tilcdc_crtc.c b/drivers/gpu/drm/tilcdc/tilcdc_crtc.c
index 30213708fc99..d99afd19ca08 100644
--- a/drivers/gpu/drm/tilcdc/tilcdc_crtc.c
+++ b/drivers/gpu/drm/tilcdc/tilcdc_crtc.c
@@ -515,6 +515,15 @@ static void tilcdc_crtc_off(struct drm_crtc *crtc, bool shutdown)
 
 	drm_crtc_vblank_off(crtc);
 
+	spin_lock_irq(&crtc->dev->event_lock);
+
+	if (crtc->state->event) {
+		drm_crtc_send_vblank_event(crtc, crtc->state->event);
+		crtc->state->event = NULL;
+	}
+
+	spin_unlock_irq(&crtc->dev->event_lock);
+
 	tilcdc_crtc_disable_irqs(dev);
 
 	pm_runtime_put_sync(dev->dev);
-- 
2.30.2



