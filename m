Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9F743C5362
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352354AbhGLHyj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:54:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:35404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350308AbhGLHut (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:50:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E14A6198B;
        Mon, 12 Jul 2021 07:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075861;
        bh=/7Aazw9y9rIjsnZ1DU2aSYlJczfHRqMOr7MkK05i3xk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G+qofZr2za9dcRWU/76pLgzSJjM8yuc5egMrGMpsYRNqSZGsR9N6RPv9yw7wJtuUY
         93Snv32n4DU3LV3rRXVeAAxetHRZ8rSrqUWDphaU068HHxgIo5GZ5Y89aIonvS2r1M
         hNpiQJaMFtZyf6HJA9bKEOYTNdHWKLfbQVOtXIec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas Stach <l.stach@pengutronix.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 397/800] drm/imx: ipuv3-plane: fix PRG modifiers after drm managed resource conversion
Date:   Mon, 12 Jul 2021 08:07:00 +0200
Message-Id: <20210712061009.399934792@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lucas Stach <l.stach@pengutronix.de>

[ Upstream commit 17b9a94656fe19aef3647c4f93d93be51697ceb1 ]

The conversion to drm managed resources introduced two bugs: the plane is now
always initialized with the linear-only list, while the list with the Vivante
GPU modifiers should have been used when the PRG/PRE engines are present. This
masked another issue, as ipu_plane_format_mod_supported() is now called before
the private plane data is set up, so if a non-linear modifier is supplied in
the plane modifier list, we run into a NULL pointer dereference checking for
the PRG presence. To fix this just remove the check from this function, as we
know that it will only be called with a non-linear modifier, if the plane init
code has already determined that the PRG/PRE is present.

Fixes: 699e7e543f1a ("drm/imx: ipuv3-plane: use drm managed resources")
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Link: https://lore.kernel.org/r/20210510145927.988661-1-l.stach@pengutronix.de
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/imx/ipuv3-plane.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/imx/ipuv3-plane.c b/drivers/gpu/drm/imx/ipuv3-plane.c
index fc8f4834ed7b..233310712deb 100644
--- a/drivers/gpu/drm/imx/ipuv3-plane.c
+++ b/drivers/gpu/drm/imx/ipuv3-plane.c
@@ -345,10 +345,11 @@ static bool ipu_plane_format_mod_supported(struct drm_plane *plane,
 	if (modifier == DRM_FORMAT_MOD_LINEAR)
 		return true;
 
-	/* without a PRG there are no supported modifiers */
-	if (!ipu_prg_present(ipu))
-		return false;
-
+	/*
+	 * Without a PRG the possible modifiers list only includes the linear
+	 * modifier, so we always take the early return from this function and
+	 * only end up here if the PRG is present.
+	 */
 	return ipu_prg_format_supported(ipu, format, modifier);
 }
 
@@ -869,6 +870,10 @@ struct ipu_plane *ipu_plane_init(struct drm_device *dev, struct ipu_soc *ipu,
 		formats = ipu_plane_rgb_formats;
 		format_count = ARRAY_SIZE(ipu_plane_rgb_formats);
 	}
+
+	if (ipu_prg_present(ipu))
+		modifiers = pre_format_modifiers;
+
 	ipu_plane = drmm_universal_plane_alloc(dev, struct ipu_plane, base,
 					       possible_crtcs, &ipu_plane_funcs,
 					       formats, format_count, modifiers,
@@ -883,9 +888,6 @@ struct ipu_plane *ipu_plane_init(struct drm_device *dev, struct ipu_soc *ipu,
 	ipu_plane->dma = dma;
 	ipu_plane->dp_flow = dp;
 
-	if (ipu_prg_present(ipu))
-		modifiers = pre_format_modifiers;
-
 	drm_plane_helper_add(&ipu_plane->base, &ipu_plane_helper_funcs);
 
 	if (dp == IPU_DP_FLOW_SYNC_BG || dp == IPU_DP_FLOW_SYNC_FG)
-- 
2.30.2



