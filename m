Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7B1D99AF7
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390303AbfHVRIY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:08:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:57922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390293AbfHVRIY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:08:24 -0400
Received: from sasha-vm.mshome.net (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22D2123426;
        Thu, 22 Aug 2019 17:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566493702;
        bh=0LTmTNwpvJLRBvXUOxICpyUtLuayTAWdXmzMpq08Kmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z8gfdprQfxpC0d1dVvYYlw6E/656L6jlUXkKhCCspBxSI8JOb2Yj/VHe5g+FSOn+4
         OnayP2hAhcJZRpP6omKmsxW2TP54kxX4KJDLC9MFrlMKEO3rpW7nrq4WzA5diwN/JT
         E+pVr3BhnPrcb68h6qGRxLwgfY+BozoOM0IrtQmo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lyude Paul <lyude@redhat.com>, Bohdan Milar <bmilar@redhat.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@redhat.com>,
        Jerry Zuo <Jerry.Zuo@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Juston Li <juston.li@intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Karol Herbst <karolherbst@gmail.com>,
        Ilia Mirkin <imirkin@alum.mit.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.2 014/135] drm/nouveau: Only recalculate PBN/VCPI on mode/connector changes
Date:   Thu, 22 Aug 2019 13:06:10 -0400
Message-Id: <20190822170811.13303-15-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190822170811.13303-1-sashal@kernel.org>
References: <20190822170811.13303-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.10-rc1
X-KernelTest-Deadline: 2019-08-24T17:07+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lyude Paul <lyude@redhat.com>

commit db1231ddc04682f60d56ff42447f13099c6c4a4c upstream.

I -thought- I had fixed this entirely, but it looks like that I didn't
test this thoroughly enough as we apparently still make one big mistake
with nv50_msto_atomic_check() - we don't handle the following scenario:

* CRTC #1 has n VCPI allocated to it, is attached to connector DP-4
  which is attached to encoder #1. enabled=y active=n
* CRTC #1 is changed from DP-4 to DP-5, causing:
  * DP-4 crtc=#1→NULL (VCPI n→0)
  * DP-5 crtc=NULL→#1
  * CRTC #1 steals encoder #1 back from DP-4 and gives it to DP-5
  * CRTC #1 maintains the same mode as before, just with a different
    connector
* mode_changed=n connectors_changed=y
  (we _SHOULD_ do VCPI 0→n here, but don't)

Once the above scenario is repeated once, we'll attempt freeing VCPI
from the connector that we didn't allocate due to the connectors
changing, but the mode staying the same. Sigh.

Since nv50_msto_atomic_check() has broken a few times now, let's rethink
things a bit to be more careful: limit both VCPI/PBN allocations to
mode_changed || connectors_changed, since neither VCPI or PBN should
ever need to change outside of routing and mode changes.

Changes since v1:
* Fix accidental reversal of clock and bpp arguments in
  drm_dp_calc_pbn_mode() - William Lewis

Signed-off-by: Lyude Paul <lyude@redhat.com>
Reported-by: Bohdan Milar <bmilar@redhat.com>
Tested-by: Bohdan Milar <bmilar@redhat.com>
Fixes: 232c9eec417a ("drm/nouveau: Use atomic VCPI helpers for MST")
References: 412e85b60531 ("drm/nouveau: Only release VCPI slots on mode changes")
Cc: Lyude Paul <lyude@redhat.com>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: David Airlie <airlied@redhat.com>
Cc: Jerry Zuo <Jerry.Zuo@amd.com>
Cc: Harry Wentland <harry.wentland@amd.com>
Cc: Juston Li <juston.li@intel.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Karol Herbst <karolherbst@gmail.com>
Cc: Ilia Mirkin <imirkin@alum.mit.edu>
Cc: <stable@vger.kernel.org> # v5.1+
Acked-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190809005307.18391-1-lyude@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/dispnv50/disp.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/dispnv50/disp.c b/drivers/gpu/drm/nouveau/dispnv50/disp.c
index 847b7866137dd..bdaf5ffd25045 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/disp.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c
@@ -766,16 +766,20 @@ nv50_msto_atomic_check(struct drm_encoder *encoder,
 	struct nv50_head_atom *asyh = nv50_head_atom(crtc_state);
 	int slots;
 
-	/* When restoring duplicated states, we need to make sure that the
-	 * bw remains the same and avoid recalculating it, as the connector's
-	 * bpc may have changed after the state was duplicated
-	 */
-	if (!state->duplicated)
-		asyh->dp.pbn =
-			drm_dp_calc_pbn_mode(crtc_state->adjusted_mode.clock,
-					     connector->display_info.bpc * 3);
+	if (crtc_state->mode_changed || crtc_state->connectors_changed) {
+		/*
+		 * When restoring duplicated states, we need to make sure that
+		 * the bw remains the same and avoid recalculating it, as the
+		 * connector's bpc may have changed after the state was
+		 * duplicated
+		 */
+		if (!state->duplicated) {
+			const int bpp = connector->display_info.bpc * 3;
+			const int clock = crtc_state->adjusted_mode.clock;
+
+			asyh->dp.pbn = drm_dp_calc_pbn_mode(clock, bpp);
+		}
 
-	if (crtc_state->mode_changed) {
 		slots = drm_dp_atomic_find_vcpi_slots(state, &mstm->mgr,
 						      mstc->port,
 						      asyh->dp.pbn);
-- 
2.20.1

