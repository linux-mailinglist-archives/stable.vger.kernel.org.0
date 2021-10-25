Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D97D43A27E
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236900AbhJYTt3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:49:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:37926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237885AbhJYTqk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:46:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5BC6611C6;
        Mon, 25 Oct 2021 19:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190777;
        bh=YIHW13cDRJP5kWNiL/7/1vcqEh+IIZBZ5tzxJSOydRc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vUVHK+rCUkKQnWFbd5Avlrsh9KGcIfPbgY6zKQrzigpFf2iPWTZ//Z4Xykh3XXOa9
         mz0VLpq+CrU2rrsD0y6+H7FUWZx2fiygE1W7xXw1I9Xswp9H0EVO1GiVyQzw7kmGWT
         5RXxPQUCtVINghXW4fp/sFyRvfBNzNH9QR8DUyzw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Edmund Dea <edmund.j.dea@intel.com>,
        Anitha Chrisanthus <anitha.chrisanthus@intel.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 060/169] drm/kmb: Disable change of plane parameters
Date:   Mon, 25 Oct 2021 21:14:01 +0200
Message-Id: <20211025191025.114156921@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Edmund Dea <edmund.j.dea@intel.com>

[ Upstream commit 982f8ad666a1123028a077b6b009871a0dc9df26 ]

Due to HW limitations, KMB cannot change height, width, or
pixel format after initial plane configuration.

v2: removed memset disp_cfg as it is already zero.

Fixes: 7f7b96a8a0a1 ("drm/kmb: Add support for KeemBay Display")
Signed-off-by: Edmund Dea <edmund.j.dea@intel.com>
Signed-off-by: Anitha Chrisanthus <anitha.chrisanthus@intel.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20211013233632.471892-4-anitha.chrisanthus@intel.com
Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/kmb/kmb_drv.h   |  1 +
 drivers/gpu/drm/kmb/kmb_plane.c | 43 ++++++++++++++++++++++++++++++++-
 drivers/gpu/drm/kmb/kmb_plane.h |  6 +++++
 3 files changed, 49 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/kmb/kmb_drv.h b/drivers/gpu/drm/kmb/kmb_drv.h
index ebbaa5f422d5..178aa14f2efc 100644
--- a/drivers/gpu/drm/kmb/kmb_drv.h
+++ b/drivers/gpu/drm/kmb/kmb_drv.h
@@ -45,6 +45,7 @@ struct kmb_drm_private {
 	spinlock_t			irq_lock;
 	int				irq_lcd;
 	int				sys_clk_mhz;
+	struct disp_cfg			init_disp_cfg[KMB_MAX_PLANES];
 	struct layer_status		plane_status[KMB_MAX_PLANES];
 	int				kmb_under_flow;
 	int				kmb_flush_done;
diff --git a/drivers/gpu/drm/kmb/kmb_plane.c b/drivers/gpu/drm/kmb/kmb_plane.c
index ecee6782612d..45cb096455b5 100644
--- a/drivers/gpu/drm/kmb/kmb_plane.c
+++ b/drivers/gpu/drm/kmb/kmb_plane.c
@@ -67,8 +67,21 @@ static const u32 kmb_formats_v[] = {
 
 static unsigned int check_pixel_format(struct drm_plane *plane, u32 format)
 {
+	struct kmb_drm_private *kmb;
+	struct kmb_plane *kmb_plane = to_kmb_plane(plane);
 	int i;
+	int plane_id = kmb_plane->id;
+	struct disp_cfg init_disp_cfg;
 
+	kmb = to_kmb(plane->dev);
+	init_disp_cfg = kmb->init_disp_cfg[plane_id];
+	/* Due to HW limitations, changing pixel format after initial
+	 * plane configuration is not supported.
+	 */
+	if (init_disp_cfg.format && init_disp_cfg.format != format) {
+		drm_dbg(&kmb->drm, "Cannot change format after initial plane configuration");
+		return -EINVAL;
+	}
 	for (i = 0; i < plane->format_count; i++) {
 		if (plane->format_types[i] == format)
 			return 0;
@@ -81,11 +94,17 @@ static int kmb_plane_atomic_check(struct drm_plane *plane,
 {
 	struct drm_plane_state *new_plane_state = drm_atomic_get_new_plane_state(state,
 										 plane);
+	struct kmb_drm_private *kmb;
+	struct kmb_plane *kmb_plane = to_kmb_plane(plane);
+	int plane_id = kmb_plane->id;
+	struct disp_cfg init_disp_cfg;
 	struct drm_framebuffer *fb;
 	int ret;
 	struct drm_crtc_state *crtc_state;
 	bool can_position;
 
+	kmb = to_kmb(plane->dev);
+	init_disp_cfg = kmb->init_disp_cfg[plane_id];
 	fb = new_plane_state->fb;
 	if (!fb || !new_plane_state->crtc)
 		return 0;
@@ -98,6 +117,16 @@ static int kmb_plane_atomic_check(struct drm_plane *plane,
 		return -EINVAL;
 	if (new_plane_state->crtc_w < KMB_MIN_WIDTH || new_plane_state->crtc_h < KMB_MIN_HEIGHT)
 		return -EINVAL;
+
+	/* Due to HW limitations, changing plane height or width after
+	 * initial plane configuration is not supported.
+	 */
+	if ((init_disp_cfg.width && init_disp_cfg.height) &&
+	    (init_disp_cfg.width != fb->width ||
+	    init_disp_cfg.height != fb->height)) {
+		drm_dbg(&kmb->drm, "Cannot change plane height or width after initial configuration");
+		return -EINVAL;
+	}
 	can_position = (plane->type == DRM_PLANE_TYPE_OVERLAY);
 	crtc_state =
 		drm_atomic_get_existing_crtc_state(state,
@@ -296,6 +325,7 @@ static void kmb_plane_atomic_update(struct drm_plane *plane,
 	unsigned char plane_id;
 	int num_planes;
 	static dma_addr_t addr[MAX_SUB_PLANES];
+	struct disp_cfg *init_disp_cfg;
 
 	if (!plane || !new_plane_state || !old_plane_state)
 		return;
@@ -317,7 +347,8 @@ static void kmb_plane_atomic_update(struct drm_plane *plane,
 	}
 	spin_unlock_irq(&kmb->irq_lock);
 
-	src_w = (new_plane_state->src_w >> 16);
+	init_disp_cfg = &kmb->init_disp_cfg[plane_id];
+	src_w = new_plane_state->src_w >> 16;
 	src_h = new_plane_state->src_h >> 16;
 	crtc_x = new_plane_state->crtc_x;
 	crtc_y = new_plane_state->crtc_y;
@@ -448,6 +479,16 @@ static void kmb_plane_atomic_update(struct drm_plane *plane,
 
 	/* Enable DMA */
 	kmb_write_lcd(kmb, LCD_LAYERn_DMA_CFG(plane_id), dma_cfg);
+
+	/* Save initial display config */
+	if (!init_disp_cfg->width ||
+	    !init_disp_cfg->height ||
+	    !init_disp_cfg->format) {
+		init_disp_cfg->width = width;
+		init_disp_cfg->height = height;
+		init_disp_cfg->format = fb->format->format;
+	}
+
 	drm_dbg(&kmb->drm, "dma_cfg=0x%x LCD_DMA_CFG=0x%x\n", dma_cfg,
 		kmb_read_lcd(kmb, LCD_LAYERn_DMA_CFG(plane_id)));
 
diff --git a/drivers/gpu/drm/kmb/kmb_plane.h b/drivers/gpu/drm/kmb/kmb_plane.h
index 486490f7a3ec..99207b35365c 100644
--- a/drivers/gpu/drm/kmb/kmb_plane.h
+++ b/drivers/gpu/drm/kmb/kmb_plane.h
@@ -62,6 +62,12 @@ struct layer_status {
 	u32 ctrl;
 };
 
+struct disp_cfg {
+	unsigned int width;
+	unsigned int height;
+	unsigned int format;
+};
+
 struct kmb_plane *kmb_plane_init(struct drm_device *drm);
 void kmb_plane_destroy(struct drm_plane *plane);
 #endif /* __KMB_PLANE_H__ */
-- 
2.33.0



