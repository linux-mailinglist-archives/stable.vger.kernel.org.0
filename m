Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC2415E12B
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404156AbgBNQRU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:17:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:48520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404428AbgBNQRT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:17:19 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D1EE24691;
        Fri, 14 Feb 2020 16:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697039;
        bh=CUISSiBSlSrDmC+eVEdnDHyB3n0xiY+2COTGTTS0AcM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JbopUCIGed7zaAiZer3jDaBrHLwaZMCrsa8gBeg4dGpPKlOOywIbdFec0jq1FulYN
         +JDCwR5bWe9EXcD5IeniaTy9tSX7SGy9Syy1RXQMYziCapdMPVVmJbYPYaAyozd55W
         jkTVbz175og2HM8fiCFCQwSEj1xud7CWjAGDtaPk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.14 002/186] drm/gma500: Fixup fbdev stolen size usage evaluation
Date:   Fri, 14 Feb 2020 11:14:11 -0500
Message-Id: <20200214161715.18113-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161715.18113-1-sashal@kernel.org>
References: <20200214161715.18113-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 2570c7f647a63..883fc45870dd9 100644
--- a/drivers/gpu/drm/gma500/framebuffer.c
+++ b/drivers/gpu/drm/gma500/framebuffer.c
@@ -486,6 +486,7 @@ static int psbfb_probe(struct drm_fb_helper *helper,
 		container_of(helper, struct psb_fbdev, psb_fb_helper);
 	struct drm_device *dev = psb_fbdev->psb_fb_helper.dev;
 	struct drm_psb_private *dev_priv = dev->dev_private;
+	unsigned int fb_size;
 	int bytespp;
 
 	bytespp = sizes->surface_bpp / 8;
@@ -495,8 +496,11 @@ static int psbfb_probe(struct drm_fb_helper *helper,
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

