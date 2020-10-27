Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E68B929C065
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:16:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1783134AbgJ0O54 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:57:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:59094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1783122AbgJ0O5z (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:57:55 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F33120714;
        Tue, 27 Oct 2020 14:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810674;
        bh=Hpmimh0nSaGwfbdxGmIyGDDXwA4oR24ywM7o1Oez3LE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AdYWeq65Yj7mQQnCi8DspXgu1nnDAEnCiPgmPkvKecSkYKLLKHojQcb05CivKGmhG
         BPrqaft6tc7ZmbLpSNR8jh6jFVa0YofOIgrUlhzVOwjaxppIGh638W1ld+HyqU1qkr
         Qf4n7DdnzuHIGQi8fCkzECbxV5DhWk6WTd9gWluI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Agner <stefan@agner.ch>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 224/633] drm: mxsfb: check framebuffer pitch
Date:   Tue, 27 Oct 2020 14:49:27 +0100
Message-Id: <20201027135533.191516014@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Agner <stefan@agner.ch>

[ Upstream commit d5a0c816900419105a12e7471bf074319dfa34be ]

The lcdif IP does not support a framebuffer pitch (stride) other than
framebuffer width. Check for equality and reject the framebuffer
otherwise.

This prevents a distorted picture when using 640x800 and running the
Mesa graphics stack. Mesa tries to use a cache aligned stride, which
leads at that particular resolution to width != stride. Currently
Mesa has no fallback behavior, but rejecting this configuration allows
userspace to handle the issue correctly.

Fixes: 45d59d704080 ("drm: Add new driver for MXSFB controller")
Signed-off-by: Stefan Agner <stefan@agner.ch>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200908141654.266836-1-stefan@agner.ch
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mxsfb/mxsfb_drv.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/mxsfb/mxsfb_drv.c b/drivers/gpu/drm/mxsfb/mxsfb_drv.c
index 497cf443a9afa..0b02e65a89e79 100644
--- a/drivers/gpu/drm/mxsfb/mxsfb_drv.c
+++ b/drivers/gpu/drm/mxsfb/mxsfb_drv.c
@@ -26,6 +26,7 @@
 #include <drm/drm_drv.h>
 #include <drm/drm_fb_cma_helper.h>
 #include <drm/drm_fb_helper.h>
+#include <drm/drm_fourcc.h>
 #include <drm/drm_gem_cma_helper.h>
 #include <drm/drm_gem_framebuffer_helper.h>
 #include <drm/drm_irq.h>
@@ -87,8 +88,26 @@ void mxsfb_disable_axi_clk(struct mxsfb_drm_private *mxsfb)
 		clk_disable_unprepare(mxsfb->clk_axi);
 }
 
+static struct drm_framebuffer *
+mxsfb_fb_create(struct drm_device *dev, struct drm_file *file_priv,
+		const struct drm_mode_fb_cmd2 *mode_cmd)
+{
+	const struct drm_format_info *info;
+
+	info = drm_get_format_info(dev, mode_cmd);
+	if (!info)
+		return ERR_PTR(-EINVAL);
+
+	if (mode_cmd->width * info->cpp[0] != mode_cmd->pitches[0]) {
+		dev_dbg(dev->dev, "Invalid pitch: fb width must match pitch\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	return drm_gem_fb_create(dev, file_priv, mode_cmd);
+}
+
 static const struct drm_mode_config_funcs mxsfb_mode_config_funcs = {
-	.fb_create		= drm_gem_fb_create,
+	.fb_create		= mxsfb_fb_create,
 	.atomic_check		= drm_atomic_helper_check,
 	.atomic_commit		= drm_atomic_helper_commit,
 };
-- 
2.25.1



