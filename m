Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7480163237
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 21:06:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbgBRT7z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 14:59:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:38800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726557AbgBRT7w (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 14:59:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6ED3920659;
        Tue, 18 Feb 2020 19:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582055991;
        bh=DtG1klsFYIJX4cADiDULKjR/ydcpU3huW4ineSvRNjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pgBhDxdAoNJ7x7B2YJEvD/cXQp7D+PoRV23dl/4mjAq5JJDeM6t2t8CxxUhkZqjx6
         dDJVzUL8x4cbUVzDvV9wRJt/ZyoITGRA9sSZ9DybY7gZYRRHlR+o3T1rVKO/G3AYGO
         uyPBH6ryLw6NNAvKKEQnlVy1umvqsqbgq+KK8oZw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jernej Skrabec <jernej.skrabec@siol.net>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Maxime Ripard <maxime@cerno.tech>
Subject: [PATCH 5.4 60/66] Revert "drm/sun4i: drv: Allow framebuffer modifiers in mode config"
Date:   Tue, 18 Feb 2020 20:55:27 +0100
Message-Id: <20200218190433.633379307@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200218190428.035153861@linuxfoundation.org>
References: <20200218190428.035153861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jernej Skrabec <jernej.skrabec@siol.net>

commit cf913e9683273f2640501094fa63a67e29f437b3 upstream.

This reverts commit 9db9c0cf5895e4ddde2814360cae7bea9282edd2.

Setting mode_config.allow_fb_modifiers manually is completely
unnecessary. It is set automatically by drm_universal_plane_init() based
on the fact if modifier list is provided or not. Even more, it breaks
DE2 and DE3 as they don't support any modifiers beside linear. Modifiers
aware applications can be confused by provided empty modifier list - at
least linear modifier should be included, but it's not for DE2 and DE3.

Fixes: 9db9c0cf5895 ("drm/sun4i: drv: Allow framebuffer modifiers in mode config")
Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>
Reviewed-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20200126065937.9564-1-jernej.skrabec@siol.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/sun4i/sun4i_drv.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/gpu/drm/sun4i/sun4i_drv.c
+++ b/drivers/gpu/drm/sun4i/sun4i_drv.c
@@ -85,7 +85,6 @@ static int sun4i_drv_bind(struct device
 	}
 
 	drm_mode_config_init(drm);
-	drm->mode_config.allow_fb_modifiers = true;
 
 	ret = component_bind_all(drm->dev, drm);
 	if (ret) {


