Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC24259595
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728069AbgIAPxX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:53:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:37732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731966AbgIAPrH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:47:07 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B68D206EF;
        Tue,  1 Sep 2020 15:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598975226;
        bh=g1INWakGBIgs/nscnZh9/+Vm5t6hweU8xuekIBcxMdE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oq4qHNk+UPwVkNuFChRawehgpCIoYeZcF4ueJoKwnF0T3ei2+qjoVBvgdNJWrq0Ne
         5CSlgxvfvLW+8dAFibKCPRhWvVETD8obyo4VqHBPkWA3tfGT0g248iATcJkvTE+DhX
         Qzt9PSp3E/bZInQKlAYsiupeOMCN1rnq9YsE9eE0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Charmaine Lee <charmainel@vmware.com>,
        Zack Rusin <zackr@vmware.com>,
        Roland Scheidegger <sroland@vmware.com>
Subject: [PATCH 5.8 251/255] drm/vmwgfx/sou: Use drm_mode_config_reset
Date:   Tue,  1 Sep 2020 17:11:47 +0200
Message-Id: <20200901151012.796233310@linuxfoundation.org>
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

commit 1338441cf166e2ef789af5915b961d4e13a4ec31 upstream.

Same problem as in stdu, same fix.

Fixes: 51f644b40b4b ("drm/atomic-helper: reset vblank on crtc reset")
Acked-by: Charmaine Lee <charmainel@vmware.com>
Reviewed-by: Zack Rusin <zackr@vmware.com>
Signed-off-by: Roland Scheidegger <sroland@vmware.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/vmwgfx/vmwgfx_scrn.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_scrn.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_scrn.c
@@ -859,8 +859,6 @@ static int vmw_sou_init(struct vmw_priva
 	sou->base.is_implicit = false;
 
 	/* Initialize primary plane */
-	vmw_du_plane_reset(primary);
-
 	ret = drm_universal_plane_init(dev, &sou->base.primary,
 				       0, &vmw_sou_plane_funcs,
 				       vmw_primary_plane_formats,
@@ -875,8 +873,6 @@ static int vmw_sou_init(struct vmw_priva
 	drm_plane_enable_fb_damage_clips(primary);
 
 	/* Initialize cursor plane */
-	vmw_du_plane_reset(cursor);
-
 	ret = drm_universal_plane_init(dev, &sou->base.cursor,
 			0, &vmw_sou_cursor_funcs,
 			vmw_cursor_plane_formats,
@@ -890,7 +886,6 @@ static int vmw_sou_init(struct vmw_priva
 
 	drm_plane_helper_add(cursor, &vmw_sou_cursor_plane_helper_funcs);
 
-	vmw_du_connector_reset(connector);
 	ret = drm_connector_init(dev, connector, &vmw_sou_connector_funcs,
 				 DRM_MODE_CONNECTOR_VIRTUAL);
 	if (ret) {
@@ -918,8 +913,6 @@ static int vmw_sou_init(struct vmw_priva
 		goto err_free_encoder;
 	}
 
-
-	vmw_du_crtc_reset(crtc);
 	ret = drm_crtc_init_with_planes(dev, crtc, &sou->base.primary,
 					&sou->base.cursor,
 					&vmw_screen_object_crtc_funcs, NULL);
@@ -973,6 +966,8 @@ int vmw_kms_sou_init_display(struct vmw_
 
 	dev_priv->active_display_unit = vmw_du_screen_object;
 
+	drm_mode_config_reset(dev);
+
 	DRM_INFO("Screen Objects Display Unit initialized\n");
 
 	return 0;


