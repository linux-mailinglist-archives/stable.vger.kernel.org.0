Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7377B8686B
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 20:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732609AbfHHSFM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 14:05:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49342 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729780AbfHHSFM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 14:05:12 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0BF1381F07;
        Thu,  8 Aug 2019 18:05:11 +0000 (UTC)
Received: from whitewolf.redhat.com (ovpn-124-143.rdu2.redhat.com [10.10.124.143])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EAC265C219;
        Thu,  8 Aug 2019 18:05:01 +0000 (UTC)
From:   Lyude Paul <lyude@redhat.com>
To:     nouveau@lists.freedesktop.org
Cc:     Bohdan Milar <bmilar@redhat.com>, Ben Skeggs <bskeggs@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@redhat.com>,
        Jerry Zuo <Jerry.Zuo@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Juston Li <juston.li@intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Karol Herbst <karolherbst@gmail.com>,
        Ilia Mirkin <imirkin@alum.mit.edu>, stable@vger.kernel.org,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drm/nouveau: Only recalculate PBN/VCPI on mode/connector changes
Date:   Thu,  8 Aug 2019 14:04:37 -0400
Message-Id: <20190808180439.19118-1-lyude@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Thu, 08 Aug 2019 18:05:11 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/gpu/drm/nouveau/dispnv50/disp.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/dispnv50/disp.c b/drivers/gpu/drm/nouveau/dispnv50/disp.c
index 126703816794..5d23ab8e4917 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/disp.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c
@@ -771,16 +771,20 @@ nv50_msto_atomic_check(struct drm_encoder *encoder,
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
+			asyh->dp.pbn = drm_dp_calc_pbn_mode(bpp, clock);
+		}
 
-	if (crtc_state->mode_changed) {
 		slots = drm_dp_atomic_find_vcpi_slots(state, &mstm->mgr,
 						      mstc->port,
 						      asyh->dp.pbn);
-- 
2.21.0

