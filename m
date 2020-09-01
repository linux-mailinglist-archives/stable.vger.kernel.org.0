Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3241E2593BB
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730585AbgIAPaF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:30:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:60048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730580AbgIAPaC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:30:02 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF7BD206C0;
        Tue,  1 Sep 2020 15:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974202;
        bh=rCyF4ksN2Ht7HesuQ4IXcJCM/op/1avwDTAnycy6+4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qHCO5GkTtJI1esPrIaxBGVV9UgXhYWC/pnRQmTBF9a7t8WNhI1vKbfWF8a5g5XBa8
         /ut52X7hQ0iFVJUNZSdUfT62w8Au6eiYeusd9U0xJFgrImrSVFmGIrKbmmrgaPibVM
         RRHD/pa8pMfTFT+VVi8kbUZvxO+0BN0sWt66TA60=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 084/214] gpu/drm: ingenic: Use the planes src_[x,y] to configure DMA length
Date:   Tue,  1 Sep 2020 17:09:24 +0200
Message-Id: <20200901150957.018382104@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150952.963606936@linuxfoundation.org>
References: <20200901150952.963606936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Cercueil <paul@crapouillou.net>

[ Upstream commit 52e4607dace1eeeb2e012fca291dc4e6cb449bff ]

Instead of obtaining the width/height of the framebuffer from the CRTC
state, obtain it from the current plane state.

v2: No change

Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Link: https://patchwork.freedesktop.org/patch/msgid/20191210144142.33143-3-paul@crapouillou.net
# *** extracted tags ***
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/ingenic/ingenic-drm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/ingenic/ingenic-drm.c b/drivers/gpu/drm/ingenic/ingenic-drm.c
index 376fca6ca9f47..e746b3a6f7cbc 100644
--- a/drivers/gpu/drm/ingenic/ingenic-drm.c
+++ b/drivers/gpu/drm/ingenic/ingenic-drm.c
@@ -375,8 +375,8 @@ static void ingenic_drm_plane_atomic_update(struct drm_plane *plane,
 
 	if (state && state->fb) {
 		addr = drm_fb_cma_get_gem_addr(state->fb, state, 0);
-		width = state->crtc->state->adjusted_mode.hdisplay;
-		height = state->crtc->state->adjusted_mode.vdisplay;
+		width = state->src_w >> 16;
+		height = state->src_h >> 16;
 		cpp = state->fb->format->cpp[plane->index];
 
 		priv->dma_hwdesc->addr = addr;
-- 
2.25.1



