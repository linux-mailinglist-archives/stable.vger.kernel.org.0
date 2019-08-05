Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B679481CE8
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730941AbfHENYG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:24:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:60862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730160AbfHENYF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:24:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F83D2067D;
        Mon,  5 Aug 2019 13:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565011445;
        bh=5g4/R91xu4czyvStOQwsVtxcB69iOwxdVH04GP7H0N4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n3ITrh2w3Y3kk09bokM7fNhnLG07WTzaJN2kMQPaEcA8PL/wluAb0ykUebkutHtBV
         6Xa06g9UYRSESOKX+cO+Dffl3dsIOAheI8Ym7GnkEdecboSHY+3daePf5nJa+NlIsS
         fn9Q9GBUR/4C21m2EqkEo0Y/Bjg8oLVXe3q1U8I8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lyude Paul <lyude@redhat.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@redhat.com>,
        Jerry Zuo <Jerry.Zuo@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Juston Li <juston.li@intel.com>,
        Karol Herbst <karolherbst@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Ilia Mirkin <imirkin@alum.mit.edu>
Subject: [PATCH 5.2 091/131] drm/nouveau: Only release VCPI slots on mode changes
Date:   Mon,  5 Aug 2019 15:02:58 +0200
Message-Id: <20190805124958.059380045@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124951.453337465@linuxfoundation.org>
References: <20190805124951.453337465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lyude Paul <lyude@redhat.com>

commit 412e85b605315fd129a849599cf4a5a7959573a8 upstream.

Looks like a regression got introduced into nv50_mstc_atomic_check()
that somehow didn't get found until now. If userspace changes
crtc_state->active to false but leaves the CRTC enabled, we end up
calling drm_dp_atomic_find_vcpi_slots() using the PBN calculated in
asyh->dp.pbn. However, if the display is inactive we end up calculating
a PBN of 0, which inadvertently causes us to have an allocation of 0.
>From there, if userspace then disables the CRTC afterwards we end up
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
Acked-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190801220216.15323-1-lyude@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/dispnv50/disp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/nouveau/dispnv50/disp.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c
@@ -775,7 +775,7 @@ nv50_msto_atomic_check(struct drm_encode
 			drm_dp_calc_pbn_mode(crtc_state->adjusted_mode.clock,
 					     connector->display_info.bpc * 3);
 
-	if (drm_atomic_crtc_needs_modeset(crtc_state)) {
+	if (crtc_state->mode_changed) {
 		slots = drm_dp_atomic_find_vcpi_slots(state, &mstm->mgr,
 						      mstc->port,
 						      asyh->dp.pbn);


