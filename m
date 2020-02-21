Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9465167692
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:37:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731950AbgBUIga (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:36:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:40396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731927AbgBUIG3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:06:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE9152465D;
        Fri, 21 Feb 2020 08:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272389;
        bh=mD/81wOsSpiXRMLsMfU2sksf0W/6xASYrsz7X25q6NI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fIg9DYANMpqcRz/SWRQkYXiM4VdnPvwj9TffY7AkCCibR8zJTBi4Y3oiDLPMDxRPE
         QS/xAcJ08Xi/yv3w2D8LELTog14eVtXR1uql9Yj16tZ/qoOj+eF7pq2n0Gp094wYvU
         2/KeCCYKtl+MjK1ooNeE09i8mAm2cNghAU9Fkr6s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 124/344] gpu/drm: ingenic: Avoid null pointer deference in plane atomic update
Date:   Fri, 21 Feb 2020 08:38:43 +0100
Message-Id: <20200221072400.127480914@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Cercueil <paul@crapouillou.net>

[ Upstream commit 354b051c5dcbeb35bbfd5d54161364fc7a75a58a ]

It is possible that there is no drm_framebuffer associated with a given
plane state.

v2: Handle drm_plane->state which can be NULL too

Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Link: https://patchwork.freedesktop.org/patch/msgid/20191210144142.33143-2-paul@crapouillou.net
# *** extracted tags ***
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/ingenic/ingenic-drm.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/ingenic/ingenic-drm.c b/drivers/gpu/drm/ingenic/ingenic-drm.c
index 2e2ed653e9c6b..f156f245fdecf 100644
--- a/drivers/gpu/drm/ingenic/ingenic-drm.c
+++ b/drivers/gpu/drm/ingenic/ingenic-drm.c
@@ -371,14 +371,18 @@ static void ingenic_drm_plane_atomic_update(struct drm_plane *plane,
 	struct ingenic_drm *priv = drm_plane_get_priv(plane);
 	struct drm_plane_state *state = plane->state;
 	unsigned int width, height, cpp;
+	dma_addr_t addr;
 
-	width = state->crtc->state->adjusted_mode.hdisplay;
-	height = state->crtc->state->adjusted_mode.vdisplay;
-	cpp = state->fb->format->cpp[plane->index];
+	if (state && state->fb) {
+		addr = drm_fb_cma_get_gem_addr(state->fb, state, 0);
+		width = state->crtc->state->adjusted_mode.hdisplay;
+		height = state->crtc->state->adjusted_mode.vdisplay;
+		cpp = state->fb->format->cpp[plane->index];
 
-	priv->dma_hwdesc->addr = drm_fb_cma_get_gem_addr(state->fb, state, 0);
-	priv->dma_hwdesc->cmd = width * height * cpp / 4;
-	priv->dma_hwdesc->cmd |= JZ_LCD_CMD_EOF_IRQ;
+		priv->dma_hwdesc->addr = addr;
+		priv->dma_hwdesc->cmd = width * height * cpp / 4;
+		priv->dma_hwdesc->cmd |= JZ_LCD_CMD_EOF_IRQ;
+	}
 }
 
 static void ingenic_drm_encoder_atomic_mode_set(struct drm_encoder *encoder,
-- 
2.20.1



