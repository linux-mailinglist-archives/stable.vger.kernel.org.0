Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4F1E259585
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbgIAPwf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:52:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:37818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731971AbgIAPrR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:47:17 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA2D920E65;
        Tue,  1 Sep 2020 15:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598975229;
        bh=KI0Iw7jt/uePuXhcc4g7fCyL4uZjq16A3xL7iZVwnUI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J/ShobqtF7zfGrYea+VGLmvvdgCTN4w63wp8NQiJzXBeez6+6EpEzMzdY7XrSatu6
         Lqe14oIlhreHSlEoOzP05KP7kDFDO63ifkkHpyDHo50eX1FNI0Vu93Z3zVO1t53v6J
         7Kd7hpJy27n7pfJg59p/P31F0hqYycMPE7ICUYuE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Charmaine Lee <charmainel@vmware.com>,
        Zack Rusin <zackr@vmware.com>,
        Roland Scheidegger <sroland@vmware.com>
Subject: [PATCH 5.8 252/255] drm/vmwgfx/ldu: Use drm_mode_config_reset
Date:   Tue,  1 Sep 2020 17:11:48 +0200
Message-Id: <20200901151012.842283953@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roland Scheidegger <sroland@vmware.com>

commit 981243371a5d832af5bc572071172e955d02fe88 upstream.

Same problem as in stdu, same fix.

Fixes: 51f644b40b4b ("drm/atomic-helper: reset vblank on crtc reset")
Acked-by: Charmaine Lee <charmainel@vmware.com>
Reviewed-by: Zack Rusin <zackr@vmware.com>
Signed-off-by: Roland Scheidegger <sroland@vmware.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c
@@ -387,8 +387,6 @@ static int vmw_ldu_init(struct vmw_priva
 	ldu->base.is_implicit = true;
 
 	/* Initialize primary plane */
-	vmw_du_plane_reset(primary);
-
 	ret = drm_universal_plane_init(dev, &ldu->base.primary,
 				       0, &vmw_ldu_plane_funcs,
 				       vmw_primary_plane_formats,
@@ -402,8 +400,6 @@ static int vmw_ldu_init(struct vmw_priva
 	drm_plane_helper_add(primary, &vmw_ldu_primary_plane_helper_funcs);
 
 	/* Initialize cursor plane */
-	vmw_du_plane_reset(cursor);
-
 	ret = drm_universal_plane_init(dev, &ldu->base.cursor,
 			0, &vmw_ldu_cursor_funcs,
 			vmw_cursor_plane_formats,
@@ -417,7 +413,6 @@ static int vmw_ldu_init(struct vmw_priva
 
 	drm_plane_helper_add(cursor, &vmw_ldu_cursor_plane_helper_funcs);
 
-	vmw_du_connector_reset(connector);
 	ret = drm_connector_init(dev, connector, &vmw_legacy_connector_funcs,
 				 DRM_MODE_CONNECTOR_VIRTUAL);
 	if (ret) {
@@ -445,7 +440,6 @@ static int vmw_ldu_init(struct vmw_priva
 		goto err_free_encoder;
 	}
 
-	vmw_du_crtc_reset(crtc);
 	ret = drm_crtc_init_with_planes(dev, crtc, &ldu->base.primary,
 					&ldu->base.cursor,
 					&vmw_legacy_crtc_funcs, NULL);
@@ -520,6 +514,8 @@ int vmw_kms_ldu_init_display(struct vmw_
 
 	dev_priv->active_display_unit = vmw_du_legacy;
 
+	drm_mode_config_reset(dev);
+
 	DRM_INFO("Legacy Display Unit initialized\n");
 
 	return 0;


