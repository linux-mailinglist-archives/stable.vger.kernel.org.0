Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82189126B8A
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbfLSS5e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:57:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:52308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730470AbfLSS4A (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:56:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18FC5206EC;
        Thu, 19 Dec 2019 18:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781759;
        bh=ziShp+8CXKXiSUANFpqSVBSkVhPf9J2ROseHKxsZvNI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y+Ii/Kn4ef+KhgE9v8cNZyqj/RwuiWBZHXEG74S6fuCtkT7/aGbwS3kZS0p5S05Vt
         bMk5OHW+sl2Eqx3AP/ReCdSB8LjgXsTrZhPsbjilG1dtbSs4X9JnjwtfCCdV0TV6jf
         T7mOySTCXqkHRDPqIr1jnhqJ76gw44N5UqptbNd4=
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
        Sam Ravnborg <sam@ravnborg.org>,
        Sean Paul <seanpaul@chromium.org>
Subject: [PATCH 5.4 68/80] drm/nouveau/kms/nv50-: Limit MST BPC to 8
Date:   Thu, 19 Dec 2019 19:35:00 +0100
Message-Id: <20191219183139.213169231@linuxfoundation.org>
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

commit ae5769d4670982bc483885b120b557a9ffd57527 upstream.

Noticed this while working on some unrelated CRC stuff. Currently,
userspace has very little support for BPCs higher than 8. While this
doesn't matter for most things, on MST topologies we need to be careful
about ensuring that we do our best to make any given display
configuration fit within the bandwidth restraints of the topology, since
otherwise less people's monitor configurations will work.

Allowing for BPC settings higher than 8 dramatically increases the
required bandwidth for displays in most configurations, and consequently
makes it a lot less likely that said display configurations will pass
the atomic check.

In the future we want to fix this correctly by making it so that we
adjust the bpp for each display in a topology to be as high as possible,
while making sure to lower the bpp of each display in the event that we
run out of bandwidth and need to rerun our atomic check. But for now,
follow the behavior that both i915 and amdgpu are sticking to.

Signed-off-by: Lyude Paul <lyude@redhat.com>
Fixes: 232c9eec417a ("drm/nouveau: Use atomic VCPI helpers for MST")
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: David Airlie <airlied@redhat.com>
Cc: Jerry Zuo <Jerry.Zuo@amd.com>
Cc: Harry Wentland <harry.wentland@amd.com>
Cc: Juston Li <juston.li@intel.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Sean Paul <seanpaul@chromium.org>
Cc: <stable@vger.kernel.org> # v5.1+
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/dispnv50/disp.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/nouveau/dispnv50/disp.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c
@@ -798,7 +798,14 @@ nv50_msto_atomic_check(struct drm_encode
 	if (!state->duplicated) {
 		const int clock = crtc_state->adjusted_mode.clock;
 
-		asyh->or.bpc = connector->display_info.bpc;
+		/*
+		 * XXX: Since we don't use HDR in userspace quite yet, limit
+		 * the bpc to 8 to save bandwidth on the topology. In the
+		 * future, we'll want to properly fix this by dynamically
+		 * selecting the highest possible bpc that would fit in the
+		 * topology
+		 */
+		asyh->or.bpc = min(connector->display_info.bpc, 8U);
 		asyh->dp.pbn = drm_dp_calc_pbn_mode(clock, asyh->or.bpc * 3);
 	}
 


