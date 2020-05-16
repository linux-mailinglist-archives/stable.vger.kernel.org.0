Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF271D645C
	for <lists+stable@lfdr.de>; Sat, 16 May 2020 23:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbgEPVvt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 May 2020 17:51:49 -0400
Received: from outils.crapouillou.net ([89.234.176.41]:46924 "EHLO
        crapouillou.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726660AbgEPVvt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 16 May 2020 17:51:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crapouillou.net;
        s=mail; t=1589665874; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xiwtAtYu45iFXDcDagg5aGZp3J1GaKnWUnkhlQPNwrQ=;
        b=hLiE2p98/HJlrqner3vfu136buvMUH01+JbjHiA1cV2YzReQ0BXaNKeu1QgvG4Ye7fim3t
        tFDT3/KiduYBJ2gEqqJIe16FuofXRzkRax25LVaLBlSJVv2wbuKDqOFp2ysKILMuy+EVUT
        qxmafI3wwXgG3qCTfaVAZVgmlqn34Rc=
From:   Paul Cercueil <paul@crapouillou.net>
To:     David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>,
        Rob Herring <robh+dt@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>
Cc:     od@zcrc.me, dri-devel@lists.freedesktop.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Cercueil <paul@crapouillou.net>, stable@vger.kernel.org
Subject: [PATCH 06/12] gpu/drm: Ingenic: Fix incorrect assumption about plane->index
Date:   Sat, 16 May 2020 23:50:51 +0200
Message-Id: <20200516215057.392609-6-paul@crapouillou.net>
In-Reply-To: <20200516215057.392609-1-paul@crapouillou.net>
References: <20200516215057.392609-1-paul@crapouillou.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

plane->index is NOT the index of the color plane in a YUV frame.
Actually, a YUV frame is represented by a single drm_plane, even though
it contains three Y, U, V planes.

Cc: stable@vger.kernel.org # v5.3
Fixes: 90b86fcc47b4 ("DRM: Add KMS driver for the Ingenic JZ47xx SoCs")
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
---
 drivers/gpu/drm/ingenic/ingenic-drm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/ingenic/ingenic-drm.c b/drivers/gpu/drm/ingenic/ingenic-drm.c
index 97244462599b..3207105755c9 100644
--- a/drivers/gpu/drm/ingenic/ingenic-drm.c
+++ b/drivers/gpu/drm/ingenic/ingenic-drm.c
@@ -386,7 +386,7 @@ static void ingenic_drm_plane_atomic_update(struct drm_plane *plane,
 		addr = drm_fb_cma_get_gem_addr(state->fb, state, 0);
 		width = state->src_w >> 16;
 		height = state->src_h >> 16;
-		cpp = state->fb->format->cpp[plane->index];
+		cpp = state->fb->format->cpp[0];
 
 		priv->dma_hwdesc->addr = addr;
 		priv->dma_hwdesc->cmd = width * height * cpp / 4;
-- 
2.26.2

