Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4861326192B
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 20:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731755AbgIHSI0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 14:08:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:56086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731350AbgIHQLt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:11:49 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A92D9247FC;
        Tue,  8 Sep 2020 15:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579777;
        bh=C3CcciRVixUYp6L5MEomGa9r80COzfaklmvDwSBzuPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fUj+FBRRHzcxsjOhFWWvfH15EQMTkgJhf/qukBFpxAfFt5nUCCxZH2jtC0wHj6nFm
         uMXqRI2eCKsNW+i+Ondsz9dZwx/YxV7DHsuxjYb594gEvRXLaxdPl7uTP8p9aYAaFO
         DiEAE+0jVSMkzvtbsdDreZ5mobHkYK+0cHx65gAk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 012/129] drm/omap: fix incorrect lock state
Date:   Tue,  8 Sep 2020 17:24:13 +0200
Message-Id: <20200908152230.311363985@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152229.689878733@linuxfoundation.org>
References: <20200908152229.689878733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tomi Valkeinen <tomi.valkeinen@ti.com>

[ Upstream commit 7fd5b25499bcec157dd4de9a713425efcf4571cd ]

After commit 92cc68e35863c1c61c449efa2b2daef6e9926048 ("drm/vblank: Use
spin_(un)lock_irq() in drm_crtc_vblank_on()") omapdrm locking is broken:

WARNING: inconsistent lock state
5.8.0-rc2-00483-g92cc68e35863 #13 Tainted: G        W
--------------------------------
inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
swapper/0/0 [HC1[1]:SC0[0]:HE0:SE1] takes:
ea98222c (&dev->event_lock#2){?.+.}-{2:2}, at: drm_handle_vblank+0x4c/0x520 [drm]
{HARDIRQ-ON-W} state was registered at:
  trace_hardirqs_on+0x9c/0x1ec
  _raw_spin_unlock_irq+0x20/0x58
  omap_crtc_atomic_enable+0x54/0xa0 [omapdrm]
  drm_atomic_helper_commit_modeset_enables+0x218/0x270 [drm_kms_helper]
  omap_atomic_commit_tail+0x48/0xc4 [omapdrm]
  commit_tail+0x9c/0x190 [drm_kms_helper]
  drm_atomic_helper_commit+0x154/0x188 [drm_kms_helper]
  drm_client_modeset_commit_atomic+0x228/0x268 [drm]
  drm_client_modeset_commit_locked+0x60/0x1d0 [drm]
  drm_client_modeset_commit+0x24/0x40 [drm]
  drm_fb_helper_restore_fbdev_mode_unlocked+0x54/0xa8 [drm_kms_helper]
  drm_fb_helper_set_par+0x2c/0x5c [drm_kms_helper]
  drm_fb_helper_hotplug_event.part.0+0xa0/0xbc [drm_kms_helper]
  drm_kms_helper_hotplug_event+0x24/0x30 [drm_kms_helper]
  output_poll_execute+0x1a8/0x1c0 [drm_kms_helper]
  process_one_work+0x268/0x800
  worker_thread+0x30/0x4e0
  kthread+0x164/0x190
  ret_from_fork+0x14/0x20

The reason for this is that omapdrm calls drm_crtc_vblank_on() while
holding event_lock taken with spin_lock_irq().

It is not clear why drm_crtc_vblank_on() and drm_crtc_vblank_get() are
called while holding event_lock. I don't see any problem with moving
those calls outside the lock, which is what this patch does.

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200819103021.440288-1-tomi.valkeinen@ti.com
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/omapdrm/omap_crtc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/omapdrm/omap_crtc.c b/drivers/gpu/drm/omapdrm/omap_crtc.c
index 3c5ddbf30e974..f5e18802e7bc6 100644
--- a/drivers/gpu/drm/omapdrm/omap_crtc.c
+++ b/drivers/gpu/drm/omapdrm/omap_crtc.c
@@ -451,11 +451,12 @@ static void omap_crtc_atomic_enable(struct drm_crtc *crtc,
 	if (omap_state->manually_updated)
 		return;
 
-	spin_lock_irq(&crtc->dev->event_lock);
 	drm_crtc_vblank_on(crtc);
+
 	ret = drm_crtc_vblank_get(crtc);
 	WARN_ON(ret != 0);
 
+	spin_lock_irq(&crtc->dev->event_lock);
 	omap_crtc_arm_event(crtc);
 	spin_unlock_irq(&crtc->dev->event_lock);
 }
-- 
2.25.1



