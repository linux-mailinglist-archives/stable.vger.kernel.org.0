Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF449119A52
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:53:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727699AbfLJVvv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:51:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:54570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727649AbfLJVHw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:07:52 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23EBA2467E;
        Tue, 10 Dec 2019 21:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012071;
        bh=mk6v7PugOCdv0pyqEXROB9lEEbSmRmp4CJlBrEzNeqY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ChWTHNB6+8bRTzUTSMnJj6mDmvpWCp371tMi/C4S/ZYuxN1uHBI1SRAMUSHcAXwyI
         qCY3fLWYxfvd1m6nknUWQGF3V6R0eVy18IbRQLDgU6vEKNzsst9QFFtnrXVBHfhqKX
         RpvrtpfyG2hN112mJ9qdnBUJjmhVWsLoPPjN3Dwg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jagan Teki <jagan@amarulasolutions.com>,
        Merlijn Wajer <merlijn@wizzup.org>,
        Maxime Ripard <mripard@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 052/350] drm/sun4i: dsi: Fix TCON DRQ set bits
Date:   Tue, 10 Dec 2019 16:02:37 -0500
Message-Id: <20191210210735.9077-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jagan Teki <jagan@amarulasolutions.com>

[ Upstream commit 7ac6269968826f9cad61b501bb613cc5cadb7229 ]

The LCD timing definitions between Linux DRM vs Allwinner are different,
below diagram shows this clear differences.

           Active                 Front           Sync           Back
           Region                 Porch                          Porch
<-----------------------><----------------><--------------><-------------->
  //////////////////////|
 ////////////////////// |
//////////////////////  |..................                ................
                                           ________________
<----- [hv]display ----->
<------------- [hv]sync_start ------------>
<--------------------- [hv]sync_end ---------------------->
<-------------------------------- [hv]total ------------------------------>

<----- lcd_[xy] -------->		  <- lcd_[hv]spw ->
					  <---------- lcd_[hv]bp --------->
<-------------------------------- lcd_[hv]t ------------------------------>

The DSI driver misinterpreted the hbp term from the BSP code to refer
only to the backporch, when in fact it was backporch + sync. Thus the
driver incorrectly used the horizontal front porch plus sync in its
calculation of the DRQ set bit value, when it should not have included
the sync timing.

Including additional sync timings leads to flip_done timed out as:

WARNING: CPU: 0 PID: 31 at drivers/gpu/drm/drm_atomic_helper.c:1429 drm_atomic_helper_wait_for_vblanks.part.1+0x298/0x2a0
[CRTC:46:crtc-0] vblank wait timed out
Modules linked in:
CPU: 0 PID: 31 Comm: kworker/0:1 Not tainted 5.1.0-next-20190514-00026-g01f0c75b902d-dirty #13
Hardware name: Allwinner sun8i Family
Workqueue: events deferred_probe_work_func
[<c010ed54>] (unwind_backtrace) from [<c010b76c>] (show_stack+0x10/0x14)
[<c010b76c>] (show_stack) from [<c0688c70>] (dump_stack+0x84/0x98)
[<c0688c70>] (dump_stack) from [<c011d9e4>] (__warn+0xfc/0x114)
[<c011d9e4>] (__warn) from [<c011da40>] (warn_slowpath_fmt+0x44/0x68)
[<c011da40>] (warn_slowpath_fmt) from [<c040cd50>] (drm_atomic_helper_wait_for_vblanks.part.1+0x298/0x2a0)
[<c040cd50>] (drm_atomic_helper_wait_for_vblanks.part.1) from [<c040e694>] (drm_atomic_helper_commit_tail_rpm+0x5c/0x6c)
[<c040e694>] (drm_atomic_helper_commit_tail_rpm) from [<c040e4dc>] (commit_tail+0x40/0x6c)
[<c040e4dc>] (commit_tail) from [<c040e5cc>] (drm_atomic_helper_commit+0xbc/0x128)
[<c040e5cc>] (drm_atomic_helper_commit) from [<c0411b64>] (restore_fbdev_mode_atomic+0x1cc/0x1dc)
[<c0411b64>] (restore_fbdev_mode_atomic) from [<c04156f8>] (drm_fb_helper_restore_fbdev_mode_unlocked+0x54/0xa0)
[<c04156f8>] (drm_fb_helper_restore_fbdev_mode_unlocked) from [<c0415774>] (drm_fb_helper_set_par+0x30/0x54)
[<c0415774>] (drm_fb_helper_set_par) from [<c03ad450>] (fbcon_init+0x560/0x5ac)
[<c03ad450>] (fbcon_init) from [<c03eb8a0>] (visual_init+0xbc/0x104)
[<c03eb8a0>] (visual_init) from [<c03ed1b8>] (do_bind_con_driver+0x1b0/0x390)
[<c03ed1b8>] (do_bind_con_driver) from [<c03ed780>] (do_take_over_console+0x13c/0x1c4)
[<c03ed780>] (do_take_over_console) from [<c03ad800>] (do_fbcon_takeover+0x74/0xcc)
[<c03ad800>] (do_fbcon_takeover) from [<c013c9c8>] (notifier_call_chain+0x44/0x84)
[<c013c9c8>] (notifier_call_chain) from [<c013cd20>] (__blocking_notifier_call_chain+0x48/0x60)
[<c013cd20>] (__blocking_notifier_call_chain) from [<c013cd50>] (blocking_notifier_call_chain+0x18/0x20)
[<c013cd50>] (blocking_notifier_call_chain) from [<c03a6e44>] (register_framebuffer+0x1e0/0x2f8)
[<c03a6e44>] (register_framebuffer) from [<c04153c0>] (__drm_fb_helper_initial_config_and_unlock+0x2fc/0x50c)
[<c04153c0>] (__drm_fb_helper_initial_config_and_unlock) from [<c04158c8>] (drm_fbdev_client_hotplug+0xe8/0x1b8)
[<c04158c8>] (drm_fbdev_client_hotplug) from [<c0415a20>] (drm_fbdev_generic_setup+0x88/0x118)
[<c0415a20>] (drm_fbdev_generic_setup) from [<c043f060>] (sun4i_drv_bind+0x128/0x160)
[<c043f060>] (sun4i_drv_bind) from [<c044b598>] (try_to_bring_up_master+0x164/0x1a0)
[<c044b598>] (try_to_bring_up_master) from [<c044b668>] (__component_add+0x94/0x140)
[<c044b668>] (__component_add) from [<c0445e1c>] (sun6i_dsi_probe+0x144/0x234)
[<c0445e1c>] (sun6i_dsi_probe) from [<c0452ef4>] (platform_drv_probe+0x48/0x9c)
[<c0452ef4>] (platform_drv_probe) from [<c04512cc>] (really_probe+0x1dc/0x2c8)
[<c04512cc>] (really_probe) from [<c0451518>] (driver_probe_device+0x60/0x160)
[<c0451518>] (driver_probe_device) from [<c044f7a4>] (bus_for_each_drv+0x74/0xb8)
[<c044f7a4>] (bus_for_each_drv) from [<c045107c>] (__device_attach+0xd0/0x13c)
[<c045107c>] (__device_attach) from [<c0450474>] (bus_probe_device+0x84/0x8c)
[<c0450474>] (bus_probe_device) from [<c0450900>] (deferred_probe_work_func+0x64/0x90)
[<c0450900>] (deferred_probe_work_func) from [<c0135970>] (process_one_work+0x204/0x420)
[<c0135970>] (process_one_work) from [<c013690c>] (worker_thread+0x274/0x5a0)
[<c013690c>] (worker_thread) from [<c013b3d8>] (kthread+0x11c/0x14c)
[<c013b3d8>] (kthread) from [<c01010e8>] (ret_from_fork+0x14/0x2c)
Exception stack(0xde539fb0 to 0xde539ff8)
9fa0:                                     00000000 00000000 00000000 00000000
9fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
9fe0: 00000000 00000000 00000000 00000000 00000013 00000000
---[ end trace b57eb1e5c64c6b8b ]---
random: fast init done
[drm:drm_atomic_helper_wait_for_dependencies] *ERROR* [CRTC:46:crtc-0] flip_done timed out
[drm:drm_atomic_helper_wait_for_dependencies] *ERROR* [CONNECTOR:48:DSI-1] flip_done timed out
[drm:drm_atomic_helper_wait_for_dependencies] *ERROR* [PLANE:30:plane-0] flip_done timed out

With the terms(as described in above diagram) fixed, the panel
displays correctly without any timeouts.

Tested-by: Merlijn Wajer <merlijn@wizzup.org>
Signed-off-by: Jagan Teki <jagan@amarulasolutions.com>
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20191003064527.15128-2-jagan@amarulasolutions.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c b/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c
index 1636344ba9ec2..f83522717488a 100644
--- a/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c
+++ b/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c
@@ -437,9 +437,9 @@ static void sun6i_dsi_setup_burst(struct sun6i_dsi *dsi,
 			     SUN6I_DSI_BURST_LINE_SYNC_POINT(SUN6I_DSI_SYNC_POINT));
 
 		val = SUN6I_DSI_TCON_DRQ_ENABLE_MODE;
-	} else if ((mode->hsync_end - mode->hdisplay) > 20) {
+	} else if ((mode->hsync_start - mode->hdisplay) > 20) {
 		/* Maaaaaagic */
-		u16 drq = (mode->hsync_end - mode->hdisplay) - 20;
+		u16 drq = (mode->hsync_start - mode->hdisplay) - 20;
 
 		drq *= mipi_dsi_pixel_format_to_bpp(device->format);
 		drq /= 32;
-- 
2.20.1

