Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 361D126B571
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727246AbgIOXoa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:44:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:47666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726951AbgIOOd4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:33:56 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EAFE23C2D;
        Tue, 15 Sep 2020 14:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179923;
        bh=h+LDTVU6B+QYrUuEFbdmHcygt5Pw7j+MzrI28AjRQw0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vUB8ZyKrVbup/ZPfaj9y4zgpgklI8NUmQJVw3QKyjvMbG0V8GBGfGOsd/i6kxnqNS
         kD/LVRseK/ZLZVOyhSc+tqAeMpv2Wpb88xbDymiPRlL3tauhCS5NMyGHeiSFoAi9sT
         rL7GwqNcqHnnRRnVpF8cw7QATEGQMxwyinbVq/Gg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <maxime@cerno.tech>,
        Chen-Yu Tsai <wens@csie.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 039/177] drm/sun4i: backend: Support alpha property on lowest plane
Date:   Tue, 15 Sep 2020 16:11:50 +0200
Message-Id: <20200915140655.512533098@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit e359c70462d2a82aae80274d027351d38792dde6 ]

Unlike what we previously thought, only the per-pixel alpha is broken on
the lowest plane and the per-plane alpha isn't. Remove the check on the
alpha property being set on the lowest plane to reject a mode.

Fixes: dcf496a6a608 ("drm/sun4i: sun4i: Introduce a quirk for lowest plane alpha support")
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Reviewed-by: Chen-Yu Tsai <wens@csie.org>
Cc: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200728134810.883457-1-maxime@cerno.tech
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sun4i/sun4i_backend.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/sun4i/sun4i_backend.c b/drivers/gpu/drm/sun4i/sun4i_backend.c
index 072ea113e6be5..30672c4c634da 100644
--- a/drivers/gpu/drm/sun4i/sun4i_backend.c
+++ b/drivers/gpu/drm/sun4i/sun4i_backend.c
@@ -589,8 +589,7 @@ static int sun4i_backend_atomic_check(struct sunxi_engine *engine,
 
 	/* We can't have an alpha plane at the lowest position */
 	if (!backend->quirks->supports_lowest_plane_alpha &&
-	    (plane_states[0]->fb->format->has_alpha ||
-	    (plane_states[0]->alpha != DRM_BLEND_ALPHA_OPAQUE)))
+	    (plane_states[0]->alpha != DRM_BLEND_ALPHA_OPAQUE))
 		return -EINVAL;
 
 	for (i = 1; i < num_planes; i++) {
-- 
2.25.1



