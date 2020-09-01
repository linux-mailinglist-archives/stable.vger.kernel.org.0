Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D477259598
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731243AbgIAPxY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:53:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:37616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731769AbgIAPrF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:47:05 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BB4F2098B;
        Tue,  1 Sep 2020 15:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598975224;
        bh=cqdJArXFd7aP7OjDu5Uuh9YTc22wLIsy8eyrkxsB8+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q9GlzzHYnrxwKrs2w4iIxbiIoUY7cSus+grHVgnwB9BKrOpflOFNeSePqCu4NwiEF
         LC5+nN+/kb6p2tWM5d8gmajHyFhBncyJh9ftiMU3aLlvBwxPhkHHvllITc84FQtOMK
         mk0rg6ugP3DQ3/rCXhFBTpSU/58dbyXI5uHlX80o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Roland Scheidegger <sroland@vmware.com>
Subject: [PATCH 5.8 250/255] drm/vmwgfx/stdu: Use drm_mode_config_reset
Date:   Tue,  1 Sep 2020 17:11:46 +0200
Message-Id: <20200901151012.748809197@linuxfoundation.org>
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

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 68745d1edf1700a668c15ecbed466d18f14c7e9b upstream.

When converting to atomic the state reset was done by directly calling
the functions, and before the modeset object was fully initialized.
This means the various ->dev pointers weren't set up.

After

commit 51f644b40b4b794b28b982fdd5d0dd8ee63f9272
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Fri Jun 12 18:00:49 2020 +0200

    drm/atomic-helper: reset vblank on crtc reset

this started to oops because now we're trying to derefence
drm_crtc->dev. Fix this up by entirely switching over to
drm_mode_config_reset, called once everything is set up.

Fixes: 51f644b40b4b ("drm/atomic-helper: reset vblank on crtc reset")
Reported-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Tested-by: Roland Scheidegger <sroland@vmware.com>
Signed-off-by: Roland Scheidegger <sroland@vmware.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/vmwgfx/vmwgfx_stdu.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_stdu.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_stdu.c
@@ -1738,8 +1738,6 @@ static int vmw_stdu_init(struct vmw_priv
 	stdu->base.is_implicit = false;
 
 	/* Initialize primary plane */
-	vmw_du_plane_reset(primary);
-
 	ret = drm_universal_plane_init(dev, primary,
 				       0, &vmw_stdu_plane_funcs,
 				       vmw_primary_plane_formats,
@@ -1754,8 +1752,6 @@ static int vmw_stdu_init(struct vmw_priv
 	drm_plane_enable_fb_damage_clips(primary);
 
 	/* Initialize cursor plane */
-	vmw_du_plane_reset(cursor);
-
 	ret = drm_universal_plane_init(dev, cursor,
 			0, &vmw_stdu_cursor_funcs,
 			vmw_cursor_plane_formats,
@@ -1769,8 +1765,6 @@ static int vmw_stdu_init(struct vmw_priv
 
 	drm_plane_helper_add(cursor, &vmw_stdu_cursor_plane_helper_funcs);
 
-	vmw_du_connector_reset(connector);
-
 	ret = drm_connector_init(dev, connector, &vmw_stdu_connector_funcs,
 				 DRM_MODE_CONNECTOR_VIRTUAL);
 	if (ret) {
@@ -1798,7 +1792,6 @@ static int vmw_stdu_init(struct vmw_priv
 		goto err_free_encoder;
 	}
 
-	vmw_du_crtc_reset(crtc);
 	ret = drm_crtc_init_with_planes(dev, crtc, &stdu->base.primary,
 					&stdu->base.cursor,
 					&vmw_stdu_crtc_funcs, NULL);
@@ -1894,6 +1887,8 @@ int vmw_kms_stdu_init_display(struct vmw
 		}
 	}
 
+	drm_mode_config_reset(dev);
+
 	DRM_INFO("Screen Target Display device initialized\n");
 
 	return 0;


