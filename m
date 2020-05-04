Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2030D1C3052
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 02:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbgEDAHa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 May 2020 20:07:30 -0400
Received: from outils.crapouillou.net ([89.234.176.41]:48602 "EHLO
        crapouillou.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726415AbgEDAHa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 May 2020 20:07:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crapouillou.net;
        s=mail; t=1588550848; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-transfer-encoding:content-transfer-encoding:
         in-reply-to:references; bh=Og/j3lrDawHdRp8z99AJL6zzmAtKNk6LO+CSF386elo=;
        b=dxkuOxVWPCvXN+DOozc5p52AeLVU3kGASNLM1TsJxlihOuYd1MacV87YqItPrh86fkGjQA
        HQgIAT4GKO5d+A70Tc1nm0xF13pRizM0DJB30GjcjofG12yQZYAlOeMuhEoeahwgGT8UdJ
        2X+Khc37SMZ+zNEyJPjQ8TDKMGpElIY=
From:   Paul Cercueil <paul@crapouillou.net>
To:     David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>
Cc:     od@zcrc.me, "H . Nikolaus Schaller" <hns@goldelico.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Paul Cercueil <paul@crapouillou.net>, stable@vger.kernel.org
Subject: [PATCH] gpu/drm: ingenic: Fix bogus crtc_atomic_check callback
Date:   Mon,  4 May 2020 02:07:20 +0200
Message-Id: <20200504000720.311584-1-paul@crapouillou.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The code was comparing the SoC's maximum height with the mode's width,
and vice-versa. D'oh.

Cc: stable@vger.kernel.org # v5.6+
Fixes: a7c909b7c037 ("gpu/drm: ingenic: Check for display size in CRTC atomic check")
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
---
 drivers/gpu/drm/ingenic/ingenic-drm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/ingenic/ingenic-drm.c b/drivers/gpu/drm/ingenic/ingenic-drm.c
index 9dfe7cb530e1..5f19e07c152e 100644
--- a/drivers/gpu/drm/ingenic/ingenic-drm.c
+++ b/drivers/gpu/drm/ingenic/ingenic-drm.c
@@ -328,8 +328,8 @@ static int ingenic_drm_crtc_atomic_check(struct drm_crtc *crtc,
 	if (!drm_atomic_crtc_needs_modeset(state))
 		return 0;
 
-	if (state->mode.hdisplay > priv->soc_info->max_height ||
-	    state->mode.vdisplay > priv->soc_info->max_width)
+	if (state->mode.hdisplay > priv->soc_info->max_width ||
+	    state->mode.vdisplay > priv->soc_info->max_height)
 		return -EINVAL;
 
 	rate = clk_round_rate(priv->pix_clk,
-- 
2.26.2

