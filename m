Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B79751F307F
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 03:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728911AbgFIA7q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:59:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:53664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726848AbgFHXI2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:08:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D76120842;
        Mon,  8 Jun 2020 23:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657707;
        bh=MG/3TpAGaOZF6VTeqb+xQuY8+HXVC7ADyGDWqkiUHqY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AIf79oh4PyWlhw0Yl8NRaa0ka65DDTKJdJtYArXyOIO6ZeUyfum2BSPVafeKDw7ip
         mvnHkdl3cHWEXu1QXriWoXyVk7/1aNpR6PR9tXLHVN3gwJ++JDE1oe9dCEOsZTdM4p
         DcCdQ84JL6gtm6iSYP9BpIg1TpbOco2zvr6TBlak=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Zimmermann <tzimmermann@suse.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Dave Airlie <airlied@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Noralf=20Tr=C3=B8nnes?= <noralf@tronnes.org>,
        Sam Ravnborg <sam@ravnborg.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.7 104/274] drm/ast: Allocate initial CRTC state of the correct size
Date:   Mon,  8 Jun 2020 19:03:17 -0400
Message-Id: <20200608230607.3361041-104-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit f0adbc382b8bb46a2467c4e5e1027763a197c8e1 ]

The ast driver inherits from DRM's CRTC state, but still uses the atomic
helper for struct drm_crtc_funcs.reset, drm_atomic_helper_crtc_reset().

The helper only allocates enough memory for the core CRTC state. That
results in an out-ouf-bounds access when duplicating the initial CRTC
state. Simplified backtrace shown below:

[   21.469321] ==================================================================
[   21.469434] BUG: KASAN: slab-out-of-bounds in ast_crtc_atomic_duplicate_state+0x84/0x100 [ast]
[   21.469445] Read of size 8 at addr ffff888036c1c5f8 by task systemd-udevd/382
[   21.469451]
[   21.469464] CPU: 2 PID: 382 Comm: systemd-udevd Tainted: G            E     5.5.0-rc6-1-default+ #214
[   21.469473] Hardware name: Sun Microsystems SUN FIRE X2270 M2/SUN FIRE X2270 M2, BIOS 2.05    07/01/2010
[   21.469480] Call Trace:
[   21.469501]  dump_stack+0xb8/0x110
[   21.469528]  print_address_description.constprop.0+0x1b/0x1e0
[   21.469557]  ? ast_crtc_atomic_duplicate_state+0x84/0x100 [ast]
[   21.469581]  ? ast_crtc_atomic_duplicate_state+0x84/0x100 [ast]
[   21.469597]  __kasan_report.cold+0x1a/0x35
[   21.469640]  ? ast_crtc_atomic_duplicate_state+0x84/0x100 [ast]
[   21.469665]  kasan_report+0xe/0x20
[   21.469693]  ast_crtc_atomic_duplicate_state+0x84/0x100 [ast]
[   21.469733]  drm_atomic_get_crtc_state+0xbf/0x1c0
[   21.469768]  __drm_atomic_helper_set_config+0x81/0x5a0
[   21.469803]  ? drm_atomic_plane_check+0x690/0x690
[   21.469843]  ? drm_client_rotation+0xae/0x240
[   21.469876]  drm_client_modeset_commit_atomic+0x230/0x390
[   21.469888]  ? __mutex_lock+0x8f0/0xbe0
[   21.469929]  ? drm_client_firmware_config.isra.0+0xa60/0xa60
[   21.469948]  ? drm_client_modeset_commit_force+0x28/0x230
[   21.470031]  ? memset+0x20/0x40
[   21.470078]  drm_client_modeset_commit_force+0x90/0x230
[   21.470110]  drm_fb_helper_restore_fbdev_mode_unlocked+0x5f/0xc0
[   21.470132]  drm_fb_helper_set_par+0x59/0x70
[   21.470155]  fbcon_init+0x61d/0xad0
[   21.470185]  ? drm_fb_helper_restore_fbdev_mode_unlocked+0xc0/0xc0
[   21.470232]  visual_init+0x187/0x240
[   21.470266]  do_bind_con_driver+0x2e3/0x460
[   21.470321]  do_take_over_console+0x20a/0x290
[   21.470371]  do_fbcon_takeover+0x85/0x100
[   21.470402]  register_framebuffer+0x2fd/0x490
[   21.470425]  ? kzalloc.constprop.0+0x10/0x10
[   21.470503]  __drm_fb_helper_initial_config_and_unlock+0xf2/0x140
[   21.470533]  drm_fbdev_client_hotplug+0x162/0x250
[   21.470563]  drm_fbdev_generic_setup+0xd2/0x155
[   21.470602]  ast_driver_load+0x688/0x850 [ast]
<...>
[   21.472625] ==================================================================

Allocating enough memory for struct ast_crtc_state in a custom ast CRTC
reset handler fixes the problem.

v2:
	* implement according to drm_atomic_helper_crtc_reset()
	* update state with __drm_atomic_helper_crtc_reset()

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: 83be6a3ceb11 ("drm/ast: Introduce struct ast_crtc_state")
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Gerd Hoffmann <kraxel@redhat.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: "Noralf Trønnes" <noralf@tronnes.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200130094012.32140-1-tzimmermann@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/ast/ast_mode.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/ast/ast_mode.c b/drivers/gpu/drm/ast/ast_mode.c
index cdd6c46d6557..7a9f20a2fd30 100644
--- a/drivers/gpu/drm/ast/ast_mode.c
+++ b/drivers/gpu/drm/ast/ast_mode.c
@@ -881,6 +881,17 @@ static const struct drm_crtc_helper_funcs ast_crtc_helper_funcs = {
 	.atomic_disable = ast_crtc_helper_atomic_disable,
 };
 
+static void ast_crtc_reset(struct drm_crtc *crtc)
+{
+	struct ast_crtc_state *ast_state =
+		kzalloc(sizeof(*ast_state), GFP_KERNEL);
+
+	if (crtc->state)
+		crtc->funcs->atomic_destroy_state(crtc, crtc->state);
+
+	__drm_atomic_helper_crtc_reset(crtc, &ast_state->base);
+}
+
 static void ast_crtc_destroy(struct drm_crtc *crtc)
 {
 	drm_crtc_cleanup(crtc);
@@ -919,7 +930,7 @@ static void ast_crtc_atomic_destroy_state(struct drm_crtc *crtc,
 }
 
 static const struct drm_crtc_funcs ast_crtc_funcs = {
-	.reset = drm_atomic_helper_crtc_reset,
+	.reset = ast_crtc_reset,
 	.set_config = drm_crtc_helper_set_config,
 	.gamma_set = drm_atomic_helper_legacy_gamma_set,
 	.destroy = ast_crtc_destroy,
-- 
2.25.1

