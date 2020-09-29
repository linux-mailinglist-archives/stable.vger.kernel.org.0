Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C06EA27C9A7
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731926AbgI2MMl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:12:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:53440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730139AbgI2Lha (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6FB8823B54;
        Tue, 29 Sep 2020 11:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379252;
        bh=OMVk3fI/tZs7pnCPVX8Wp4T55m38T8i17r0bLUz066E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HmOxfVc0eI40vAk9Bn4HpRsAe8uKJZXxkGiFmsgfgPpQgsMBYCDkwD168VVYeyFCl
         FXiz/NvzQ4x6EfaZMQNVC1eMgGwREl4/Uchl3GlhsB7uQlg7wiY3bxoyaU6NvTVKVM
         gZeX1MStvOScLYzfUGnBfQLR2PaWBJLXcL+y+GjE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephan Gerhold <stephan@gerhold.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 080/388] drm/mcde: Handle pending vblank while disabling display
Date:   Tue, 29 Sep 2020 12:56:51 +0200
Message-Id: <20200929110014.353970838@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephan Gerhold <stephan@gerhold.net>

[ Upstream commit 97de863673f07f424dd0666aefb4b6ecaba10171 ]

Disabling the display using MCDE currently results in a warning
together with a delay caused by some timeouts:

    mcde a0350000.mcde: MCDE display is disabled
    ------------[ cut here ]------------
    WARNING: CPU: 0 PID: 20 at drivers/gpu/drm/drm_atomic_helper.c:2258 drm_atomic_helper_commit_hw_done+0xe0/0xe4
    Hardware name: ST-Ericsson Ux5x0 platform (Device Tree Support)
    Workqueue: events drm_mode_rmfb_work_fn
    [<c010f468>] (unwind_backtrace) from [<c010b54c>] (show_stack+0x10/0x14)
    [<c010b54c>] (show_stack) from [<c079dd90>] (dump_stack+0x84/0x98)
    [<c079dd90>] (dump_stack) from [<c011d1b0>] (__warn+0xb8/0xd4)
    [<c011d1b0>] (__warn) from [<c011d230>] (warn_slowpath_fmt+0x64/0xc4)
    [<c011d230>] (warn_slowpath_fmt) from [<c0413048>] (drm_atomic_helper_commit_hw_done+0xe0/0xe4)
    [<c0413048>] (drm_atomic_helper_commit_hw_done) from [<c04159cc>] (drm_atomic_helper_commit_tail_rpm+0x44/0x6c)
    [<c04159cc>] (drm_atomic_helper_commit_tail_rpm) from [<c0415f5c>] (commit_tail+0x50/0x10c)
    [<c0415f5c>] (commit_tail) from [<c04160dc>] (drm_atomic_helper_commit+0xbc/0x128)
    [<c04160dc>] (drm_atomic_helper_commit) from [<c0430790>] (drm_framebuffer_remove+0x390/0x428)
    [<c0430790>] (drm_framebuffer_remove) from [<c0430860>] (drm_mode_rmfb_work_fn+0x38/0x48)
    [<c0430860>] (drm_mode_rmfb_work_fn) from [<c01368a8>] (process_one_work+0x1f0/0x43c)
    [<c01368a8>] (process_one_work) from [<c0136d48>] (worker_thread+0x254/0x55c)
    [<c0136d48>] (worker_thread) from [<c013c014>] (kthread+0x124/0x150)
    [<c013c014>] (kthread) from [<c01010e8>] (ret_from_fork+0x14/0x2c)
    Exception stack(0xeb14dfb0 to 0xeb14dff8)
    dfa0:                                     00000000 00000000 00000000 00000000
    dfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
    dfe0: 00000000 00000000 00000000 00000000 00000013 00000000
    ---[ end trace 314909bcd4c7d50c ]---
    [drm:drm_atomic_helper_wait_for_dependencies] *ERROR* [CRTC:32:crtc-0] flip_done timed out
    [drm:drm_atomic_helper_wait_for_dependencies] *ERROR* [CONNECTOR:34:DSI-1] flip_done timed out
    [drm:drm_atomic_helper_wait_for_dependencies] *ERROR* [PLANE:31:plane-0] flip_done timed out

The reason for this is that there is a vblank event pending, but we
never handle it after disabling the vblank interrupts.

Check if there is an vblank event pending when disabling the display,
and clear it by sending a fake vblank event in that case.

Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Tested-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20191106165835.2863-8-stephan@gerhold.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mcde/mcde_display.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/gpu/drm/mcde/mcde_display.c b/drivers/gpu/drm/mcde/mcde_display.c
index 751454ae3cd10..28ed506285018 100644
--- a/drivers/gpu/drm/mcde/mcde_display.c
+++ b/drivers/gpu/drm/mcde/mcde_display.c
@@ -946,6 +946,7 @@ static void mcde_display_disable(struct drm_simple_display_pipe *pipe)
 	struct drm_crtc *crtc = &pipe->crtc;
 	struct drm_device *drm = crtc->dev;
 	struct mcde *mcde = drm->dev_private;
+	struct drm_pending_vblank_event *event;
 
 	if (mcde->te_sync)
 		drm_crtc_vblank_off(crtc);
@@ -953,6 +954,15 @@ static void mcde_display_disable(struct drm_simple_display_pipe *pipe)
 	/* Disable FIFO A flow */
 	mcde_disable_fifo(mcde, MCDE_FIFO_A, true);
 
+	event = crtc->state->event;
+	if (event) {
+		crtc->state->event = NULL;
+
+		spin_lock_irq(&crtc->dev->event_lock);
+		drm_crtc_send_vblank_event(crtc, event);
+		spin_unlock_irq(&crtc->dev->event_lock);
+	}
+
 	dev_info(drm->dev, "MCDE display is disabled\n");
 }
 
-- 
2.25.1



