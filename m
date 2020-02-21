Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4648216758A
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:31:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730794AbgBUI3K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:29:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:56122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387802AbgBUISR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:18:17 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15E7724692;
        Fri, 21 Feb 2020 08:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582273096;
        bh=GgRpWvLJvUfADI6jpLR7sdNqSk1r0qN4laNyfzj7NUw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VoY3mrXuf2cot9SFT0nNhU2zZfFjd9IjVHVIlBo8j5iA+fjB6cYHC0F5FMn26OIg0
         4MY8CozmpAtAMcIwr5KWgSH3TFTmMs6Y39R+IdKJrNC+7wqXsZdQCMNeVM31ii9Yoj
         /Jhqh7Ik6Fo/9Wgj5b9j3LUyKcZvultMTimkmbdk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 010/191] drm/gma500: Fixup fbdev stolen size usage evaluation
Date:   Fri, 21 Feb 2020 08:39:43 +0100
Message-Id: <20200221072252.304048436@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072250.732482588@linuxfoundation.org>
References: <20200221072250.732482588@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

[ Upstream commit fd1a5e521c3c083bb43ea731aae0f8b95f12b9bd ]

psbfb_probe performs an evaluation of the required size from the stolen
GTT memory, but gets it wrong in two distinct ways:
- The resulting size must be page-size-aligned;
- The size to allocate is derived from the surface dimensions, not the fb
  dimensions.

When two connectors are connected with different modes, the smallest will
be stored in the fb dimensions, but the size that needs to be allocated must
match the largest (surface) dimensions. This is what is used in the actual
allocation code.

Fix this by correcting the evaluation to conform to the two points above.
It allows correctly switching to 16bpp when one connector is e.g. 1920x1080
and the other is 1024x768.

Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20191107153048.843881-1-paul.kocialkowski@bootlin.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/gma500/framebuffer.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/gma500/framebuffer.c b/drivers/gpu/drm/gma500/framebuffer.c
index adefae58b5fcd..b4035ef72af8a 100644
--- a/drivers/gpu/drm/gma500/framebuffer.c
+++ b/drivers/gpu/drm/gma500/framebuffer.c
@@ -480,6 +480,7 @@ static int psbfb_probe(struct drm_fb_helper *helper,
 		container_of(helper, struct psb_fbdev, psb_fb_helper);
 	struct drm_device *dev = psb_fbdev->psb_fb_helper.dev;
 	struct drm_psb_private *dev_priv = dev->dev_private;
+	unsigned int fb_size;
 	int bytespp;
 
 	bytespp = sizes->surface_bpp / 8;
@@ -489,8 +490,11 @@ static int psbfb_probe(struct drm_fb_helper *helper,
 	/* If the mode will not fit in 32bit then switch to 16bit to get
 	   a console on full resolution. The X mode setting server will
 	   allocate its own 32bit GEM framebuffer */
-	if (ALIGN(sizes->fb_width * bytespp, 64) * sizes->fb_height >
-	                dev_priv->vram_stolen_size) {
+	fb_size = ALIGN(sizes->surface_width * bytespp, 64) *
+		  sizes->surface_height;
+	fb_size = ALIGN(fb_size, PAGE_SIZE);
+
+	if (fb_size > dev_priv->vram_stolen_size) {
                 sizes->surface_bpp = 16;
                 sizes->surface_depth = 16;
         }
-- 
2.20.1



