Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A3287E51B
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 00:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728928AbfHAWCe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 18:02:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43408 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726403AbfHAWCe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 1 Aug 2019 18:02:34 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C25D730EA981;
        Thu,  1 Aug 2019 22:02:30 +0000 (UTC)
Received: from malachite.bss.redhat.com (dhcp-10-20-1-11.bss.redhat.com [10.20.1.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 15EB61001281;
        Thu,  1 Aug 2019 22:02:25 +0000 (UTC)
From:   Lyude Paul <lyude@redhat.com>
To:     nouveau@lists.freedesktop.org
Cc:     Ben Skeggs <bskeggs@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@redhat.com>,
        Jerry Zuo <Jerry.Zuo@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Juston Li <juston.li@intel.com>,
        Karol Herbst <karolherbst@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Ilia Mirkin <imirkin@alum.mit.edu>, stable@vger.kernel.org,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drm/nouveau: Only release VCPI slots on mode changes
Date:   Thu,  1 Aug 2019 18:02:15 -0400
Message-Id: <20190801220216.15323-1-lyude@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Thu, 01 Aug 2019 22:02:34 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Looks like a regression got introduced into nv50_mstc_atomic_check()
that somehow didn't get found until now. If userspace changes
crtc_state->active to false but leaves the CRTC enabled, we end up
calling drm_dp_atomic_find_vcpi_slots() using the PBN calculated in
asyh->dp.pbn. However, if the display is inactive we end up calculating
a PBN of 0, which inadvertently causes us to have an allocation of 0.
From there, if userspace then disables the CRTC afterwards we end up
accidentally attempting to free the VCPI twice:

WARNING: CPU: 0 PID: 1484 at drivers/gpu/drm/drm_dp_mst_topology.c:3336
drm_dp_atomic_release_vcpi_slots+0x87/0xb0 [drm_kms_helper]
RIP: 0010:drm_dp_atomic_release_vcpi_slots+0x87/0xb0 [drm_kms_helper]
Call Trace:
 drm_atomic_helper_check_modeset+0x3f3/0xa60 [drm_kms_helper]
 ? drm_atomic_check_only+0x43/0x780 [drm]
 drm_atomic_helper_check+0x15/0x90 [drm_kms_helper]
 nv50_disp_atomic_check+0x83/0x1d0 [nouveau]
 drm_atomic_check_only+0x54d/0x780 [drm]
 ? drm_atomic_set_crtc_for_connector+0xec/0x100 [drm]
 drm_atomic_commit+0x13/0x50 [drm]
 drm_atomic_helper_set_config+0x81/0x90 [drm_kms_helper]
 drm_mode_setcrtc+0x194/0x6a0 [drm]
 ? vprintk_emit+0x16a/0x230
 ? drm_ioctl+0x163/0x390 [drm]
 ? drm_mode_getcrtc+0x180/0x180 [drm]
 drm_ioctl_kernel+0xaa/0xf0 [drm]
 drm_ioctl+0x208/0x390 [drm]
 ? drm_mode_getcrtc+0x180/0x180 [drm]
 nouveau_drm_ioctl+0x63/0xb0 [nouveau]
 do_vfs_ioctl+0x405/0x660
 ? recalc_sigpending+0x17/0x50
 ? _copy_from_user+0x37/0x60
 ksys_ioctl+0x5e/0x90
 ? exit_to_usermode_loop+0x92/0xe0
 __x64_sys_ioctl+0x16/0x20
 do_syscall_64+0x59/0x190
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
WARNING: CPU: 0 PID: 1484 at drivers/gpu/drm/drm_dp_mst_topology.c:3336
drm_dp_atomic_release_vcpi_slots+0x87/0xb0 [drm_kms_helper]
---[ end trace 4c395c0c51b1f88d ]---
[drm:drm_dp_atomic_release_vcpi_slots [drm_kms_helper]] *ERROR* no VCPI for
[MST PORT:00000000e288eb7d] found in mst state 000000008e642070

So, fix this by doing what we probably should have done from the start: only
call drm_dp_atomic_find_vcpi_slots() when crtc_state->mode_changed is set, so
that VCPI allocations remain for as long as the CRTC is enabled.

Signed-off-by: Lyude Paul <lyude@redhat.com>
Fixes: 232c9eec417a ("drm/nouveau: Use atomic VCPI helpers for MST")
Cc: Lyude Paul <lyude@redhat.com>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: David Airlie <airlied@redhat.com>
Cc: Jerry Zuo <Jerry.Zuo@amd.com>
Cc: Harry Wentland <harry.wentland@amd.com>
Cc: Juston Li <juston.li@intel.com>
Cc: Karol Herbst <karolherbst@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Ilia Mirkin <imirkin@alum.mit.edu>
Cc: <stable@vger.kernel.org> # v5.1+
---
 drivers/gpu/drm/nouveau/dispnv50/disp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/dispnv50/disp.c b/drivers/gpu/drm/nouveau/dispnv50/disp.c
index 8497768f1b41..126703816794 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/disp.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c
@@ -780,7 +780,7 @@ nv50_msto_atomic_check(struct drm_encoder *encoder,
 			drm_dp_calc_pbn_mode(crtc_state->adjusted_mode.clock,
 					     connector->display_info.bpc * 3);
 
-	if (drm_atomic_crtc_needs_modeset(crtc_state)) {
+	if (crtc_state->mode_changed) {
 		slots = drm_dp_atomic_find_vcpi_slots(state, &mstm->mgr,
 						      mstc->port,
 						      asyh->dp.pbn);
-- 
2.21.0

