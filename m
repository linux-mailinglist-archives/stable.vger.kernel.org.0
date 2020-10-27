Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D713529C030
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:13:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1784680AbgJ0O7a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:59:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:32846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1784669AbgJ0O71 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:59:27 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A72B20715;
        Tue, 27 Oct 2020 14:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810767;
        bh=mNhTHkVmX3M/Ysu7IIgyyOYMb5QWzrLt9mkFamXepxU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d0/CmsMpAPj6VoxscQZ2frKvauU2pTWpX37QYuuL6XswjtexSnslQlXEKe/gDvTAN
         653JoVAD42M/V2eyF5aseSMU2HebKpWDJJeBpTSn7/p8OFbjUjsFqal3CcaNNr7xsC
         nbKTztT322WpbdgC+AeUckOIWG6fOHnJS2r0Pb3o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Kuai <yukuai3@huawei.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 257/633] drm: rcar-du: Put reference to VSP device
Date:   Tue, 27 Oct 2020 14:50:00 +0100
Message-Id: <20201027135534.716222545@linuxfoundation.org>
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

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

[ Upstream commit 2a32dbdc2c7db5463483fa01fb220fd1b770c6bc ]

The reference to the VSP device acquired with of_find_device_by_node()
in rcar_du_vsp_init() is never released. Fix it with a drmm action,
which gets run both in the probe error path and in the remove path.

Fixes: 6d62ef3ac30b ("drm: rcar-du: Expose the VSP1 compositor through KMS planes")
Reported-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rcar-du/rcar_du_vsp.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
index f1a81c9b184d4..fa09b3ae8b9d4 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
@@ -13,6 +13,7 @@
 #include <drm/drm_fourcc.h>
 #include <drm/drm_gem_cma_helper.h>
 #include <drm/drm_gem_framebuffer_helper.h>
+#include <drm/drm_managed.h>
 #include <drm/drm_plane_helper.h>
 #include <drm/drm_vblank.h>
 
@@ -341,6 +342,13 @@ static const struct drm_plane_funcs rcar_du_vsp_plane_funcs = {
 	.atomic_destroy_state = rcar_du_vsp_plane_atomic_destroy_state,
 };
 
+static void rcar_du_vsp_cleanup(struct drm_device *dev, void *res)
+{
+	struct rcar_du_vsp *vsp = res;
+
+	put_device(vsp->vsp);
+}
+
 int rcar_du_vsp_init(struct rcar_du_vsp *vsp, struct device_node *np,
 		     unsigned int crtcs)
 {
@@ -357,6 +365,10 @@ int rcar_du_vsp_init(struct rcar_du_vsp *vsp, struct device_node *np,
 
 	vsp->vsp = &pdev->dev;
 
+	ret = drmm_add_action(rcdu->ddev, rcar_du_vsp_cleanup, vsp);
+	if (ret < 0)
+		return ret;
+
 	ret = vsp1_du_init(vsp->vsp);
 	if (ret < 0)
 		return ret;
-- 
2.25.1



