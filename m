Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBF4230C01C
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 14:50:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232920AbhBBNtn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 08:49:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:38148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232957AbhBBNrY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:47:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8AA2A64F97;
        Tue,  2 Feb 2021 13:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273315;
        bh=Kt3W7cA1hg+sePDqblda2yarj6vgGtie9dE1Zw3Hj5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fib7qLc2QehfZp9yKA43uML8adp2dGevT2c/c5v2gcTzZuCcuxZgG5OVGYRMKFIaq
         UZ/z1E+/mSlwE8P/8102AxeeRnEuFz1mVmbUPQVVDH9UMcKXhU0N/Aixw8pYz58NeI
         y7xO1JW6/uLptAGF3VWQYLsFoY85DR+GnrA5tcX8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dom Cobley <popcornmix@gmail.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Lucas Nussbaum <lucas@debian.org>,
        Ryutaroh Matsumoto <ryutaroh@ict.e.titech.ac.jp>
Subject: [PATCH 5.10 060/142] drm/vc4: Correct lbm size and calculation
Date:   Tue,  2 Feb 2021 14:37:03 +0100
Message-Id: <20210202133000.198376282@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dom Cobley <popcornmix@gmail.com>

commit 78e5330329ee206d6aa4593a90320fd837f7966e upstream.

LBM base address is measured in units of pixels per cycle.
That is 4 for 2711 (hvs5) and 2 for 2708.

We are wasting 75% of lbm by indexing without the scaling.
But we were also using too high a size for the lbm resulting
in partial corruption (right hand side) of vertically
scaled images, usually at 4K or lower resolutions with more layers.

The physical RAM of LBM on 2711 is 8 * 1920 * 16 * 12-bit
(pixels are stored 12-bits per component regardless of format).

The LBM address indexes work in units of pixels per clock,
so for 4 pixels per clock that means we have 32 * 1920 = 60K

Fixes: c54619b0bfb3 ("drm/vc4: Add support for the BCM2711 HVS5")
Signed-off-by: Dom Cobley <popcornmix@gmail.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Tested-By: Lucas Nussbaum <lucas@debian.org>
Tested-By: Ryutaroh Matsumoto <ryutaroh@ict.e.titech.ac.jp>
Link: https://patchwork.freedesktop.org/patch/msgid/20210121105759.1262699-1-maxime@cerno.tech
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/vc4/vc4_hvs.c   |    8 ++++----
 drivers/gpu/drm/vc4/vc4_plane.c |    7 ++++++-
 2 files changed, 10 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/vc4/vc4_hvs.c
+++ b/drivers/gpu/drm/vc4/vc4_hvs.c
@@ -618,11 +618,11 @@ static int vc4_hvs_bind(struct device *d
 	 * for now we just allocate globally.
 	 */
 	if (!hvs->hvs5)
-		/* 96kB */
-		drm_mm_init(&hvs->lbm_mm, 0, 96 * 1024);
+		/* 48k words of 2x12-bit pixels */
+		drm_mm_init(&hvs->lbm_mm, 0, 48 * 1024);
 	else
-		/* 70k words */
-		drm_mm_init(&hvs->lbm_mm, 0, 70 * 2 * 1024);
+		/* 60k words of 4x12-bit pixels */
+		drm_mm_init(&hvs->lbm_mm, 0, 60 * 1024);
 
 	/* Upload filter kernels.  We only have the one for now, so we
 	 * keep it around for the lifetime of the driver.
--- a/drivers/gpu/drm/vc4/vc4_plane.c
+++ b/drivers/gpu/drm/vc4/vc4_plane.c
@@ -437,6 +437,7 @@ static void vc4_write_ppf(struct vc4_pla
 static u32 vc4_lbm_size(struct drm_plane_state *state)
 {
 	struct vc4_plane_state *vc4_state = to_vc4_plane_state(state);
+	struct vc4_dev *vc4 = to_vc4_dev(state->plane->dev);
 	u32 pix_per_line;
 	u32 lbm;
 
@@ -472,7 +473,11 @@ static u32 vc4_lbm_size(struct drm_plane
 		lbm = pix_per_line * 16;
 	}
 
-	lbm = roundup(lbm, 32);
+	/* Align it to 64 or 128 (hvs5) bytes */
+	lbm = roundup(lbm, vc4->hvs->hvs5 ? 128 : 64);
+
+	/* Each "word" of the LBM memory contains 2 or 4 (hvs5) pixels */
+	lbm /= vc4->hvs->hvs5 ? 4 : 2;
 
 	return lbm;
 }


