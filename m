Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81965328DCC
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:19:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241217AbhCATR1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:17:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:39786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241072AbhCATMh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:12:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3603A6148E;
        Mon,  1 Mar 2021 17:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618618;
        bh=ww4uA/vln3djsDjUK01OiYj6lV9V77c+5w0zly9b3rI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=011OUlANzxQOp+0gsqeaSjWqZPHHA53k+isbstb+KYb7/GimUdT48HaTVnRuVdMjI
         tdJkxrUOf8hWfCiMokoVOoS78ph9OHLCPhCZPeFT9ZJ98Rm1S9SpSLDryQiupHhdXo
         EdkYwUg2iR3lgKjNwGLhRhgCvsET52HzGljadE/E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 153/663] drm: rcar-du: Fix leak of CMM platform device reference
Date:   Mon,  1 Mar 2021 17:06:41 +0100
Message-Id: <20210301161149.344468123@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

[ Upstream commit 9fa120458da142da0d1d3eaf6f6a3a2c2c91d27b ]

The device references acquired by of_find_device_by_node() are not
released by the driver. Fix this by registering a cleanup action.

Fixes: 8de707aeb452 ("drm: rcar-du: kms: Initialize CMM instances")
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Reviewed-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rcar-du/rcar_du_kms.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/rcar-du/rcar_du_kms.c b/drivers/gpu/drm/rcar-du/rcar_du_kms.c
index 7015e22872bbe..ecc894f0bc430 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_kms.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_kms.c
@@ -14,6 +14,7 @@
 #include <drm/drm_fb_cma_helper.h>
 #include <drm/drm_gem_cma_helper.h>
 #include <drm/drm_gem_framebuffer_helper.h>
+#include <drm/drm_managed.h>
 #include <drm/drm_probe_helper.h>
 #include <drm/drm_vblank.h>
 
@@ -726,8 +727,12 @@ static int rcar_du_cmm_init(struct rcar_du_device *rcdu)
 		 * disabled: return 0 and let the DU continue probing.
 		 */
 		ret = rcar_cmm_init(pdev);
-		if (ret)
+		if (ret) {
+			platform_device_put(pdev);
 			return ret == -ENODEV ? 0 : ret;
+		}
+
+		rcdu->cmms[i] = pdev;
 
 		/*
 		 * Enforce suspend/resume ordering by making the CMM a provider
@@ -739,13 +744,20 @@ static int rcar_du_cmm_init(struct rcar_du_device *rcdu)
 				"Failed to create device link to CMM%u\n", i);
 			return -EINVAL;
 		}
-
-		rcdu->cmms[i] = pdev;
 	}
 
 	return 0;
 }
 
+static void rcar_du_modeset_cleanup(struct drm_device *dev, void *res)
+{
+	struct rcar_du_device *rcdu = to_rcar_du_device(dev);
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(rcdu->cmms); ++i)
+		platform_device_put(rcdu->cmms[i]);
+}
+
 int rcar_du_modeset_init(struct rcar_du_device *rcdu)
 {
 	static const unsigned int mmio_offsets[] = {
@@ -766,6 +778,10 @@ int rcar_du_modeset_init(struct rcar_du_device *rcdu)
 	if (ret)
 		return ret;
 
+	ret = drmm_add_action(&rcdu->ddev, rcar_du_modeset_cleanup, NULL);
+	if (ret)
+		return ret;
+
 	dev->mode_config.min_width = 0;
 	dev->mode_config.min_height = 0;
 	dev->mode_config.normalize_zpos = true;
-- 
2.27.0



