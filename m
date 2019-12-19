Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF75126B87
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:57:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730280AbfLSS5e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:57:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:52166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730744AbfLSSzz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:55:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 880EC2468C;
        Thu, 19 Dec 2019 18:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781755;
        bh=DgQmfFODGhLO7JQvXewluc2BUtibznHL8k9J2ESLWmg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nYOeoM1+F8Bi0gJ6fhDlWi/6b2hjXuqhEQkYlo9CG7Bujdwjq4V4bCv3eEOvE3opG
         Ck0zSzn5o9/1Kyykg/Z6lx3fnbeUN1tTE9KQGAlrIpttg1IZ29BwppzAss4XwfBaQN
         fGt3aAyK1C/7dbLboe9MOW450RHwOj20cWXq5cXc=
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
        Sean Paul <seanpaul@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH 5.4 66/80] drm/nouveau/kms/nv50-: Call outp_atomic_check_view() before handling PBN
Date:   Thu, 19 Dec 2019 19:34:58 +0100
Message-Id: <20191219183137.703692301@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183031.278083125@linuxfoundation.org>
References: <20191219183031.278083125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lyude Paul <lyude@redhat.com>

commit 310d35771ee9040f5744109fc277206ad96ba253 upstream.

Since nv50_outp_atomic_check_view() can set crtc_state->mode_changed, we
probably should be calling it before handling any PBN changes. Just a
precaution.

Signed-off-by: Lyude Paul <lyude@redhat.com>
Fixes: 232c9eec417a ("drm/nouveau: Use atomic VCPI helpers for MST")
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: David Airlie <airlied@redhat.com>
Cc: Jerry Zuo <Jerry.Zuo@amd.com>
Cc: Harry Wentland <harry.wentland@amd.com>
Cc: Juston Li <juston.li@intel.com>
Cc: Sean Paul <seanpaul@chromium.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: <stable@vger.kernel.org> # v5.1+
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/dispnv50/disp.c |   48 +++++++++++++++++---------------
 1 file changed, 26 insertions(+), 22 deletions(-)

--- a/drivers/gpu/drm/nouveau/dispnv50/disp.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c
@@ -770,32 +770,36 @@ nv50_msto_atomic_check(struct drm_encode
 	struct nv50_mstm *mstm = mstc->mstm;
 	struct nv50_head_atom *asyh = nv50_head_atom(crtc_state);
 	int slots;
+	int ret;
 
-	if (crtc_state->mode_changed || crtc_state->connectors_changed) {
-		/*
-		 * When restoring duplicated states, we need to make sure that
-		 * the bw remains the same and avoid recalculating it, as the
-		 * connector's bpc may have changed after the state was
-		 * duplicated
-		 */
-		if (!state->duplicated) {
-			const int bpp = connector->display_info.bpc * 3;
-			const int clock = crtc_state->adjusted_mode.clock;
-
-			asyh->dp.pbn = drm_dp_calc_pbn_mode(clock, bpp);
-		}
-
-		slots = drm_dp_atomic_find_vcpi_slots(state, &mstm->mgr,
-						      mstc->port,
-						      asyh->dp.pbn);
-		if (slots < 0)
-			return slots;
+	ret = nv50_outp_atomic_check_view(encoder, crtc_state, conn_state,
+					  mstc->native);
+	if (ret)
+		return ret;
+
+	if (!crtc_state->mode_changed && !crtc_state->connectors_changed)
+		return 0;
+
+	/*
+	 * When restoring duplicated states, we need to make sure that the bw
+	 * remains the same and avoid recalculating it, as the connector's bpc
+	 * may have changed after the state was duplicated
+	 */
+	if (!state->duplicated) {
+		const int bpp = connector->display_info.bpc * 3;
+		const int clock = crtc_state->adjusted_mode.clock;
 
-		asyh->dp.tu = slots;
+		asyh->dp.pbn = drm_dp_calc_pbn_mode(clock, bpp);
 	}
 
-	return nv50_outp_atomic_check_view(encoder, crtc_state, conn_state,
-					   mstc->native);
+	slots = drm_dp_atomic_find_vcpi_slots(state, &mstm->mgr, mstc->port,
+					      asyh->dp.pbn);
+	if (slots < 0)
+		return slots;
+
+	asyh->dp.tu = slots;
+
+	return 0;
 }
 
 static void


