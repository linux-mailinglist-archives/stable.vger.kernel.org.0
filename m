Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA40B43A36B
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237314AbhJYT7W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:59:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:41842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238586AbhJYTzl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:55:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8D6761252;
        Mon, 25 Oct 2021 19:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635191156;
        bh=2L7slUI3KLJv+6ss2VUYGEA+XtvVywRDadS02uYxBUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=flGesoOUuTDvzI1LR2kcJv6KUdhUYJbP5b4ZBp1dHzKoMt4w3OxDxLWVImrwTcbdy
         RX/hbZED0vuoeY5B0RzZG+DoT88NnAtjxrAWHHeHjVRRrN2arlXflxJHjkKTvC3iPK
         NEpnscS5wNuCY3/5MDdw8OPTQZMBLS0zj0Uvp+M0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Edmund Dea <edmund.j.dea@intel.com>,
        Anitha Chrisanthus <anitha.chrisanthus@intel.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 159/169] drm/kmb: Limit supported mode to 1080p
Date:   Mon, 25 Oct 2021 21:15:40 +0200
Message-Id: <20211025191037.563115136@linuxfoundation.org>
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

From: Anitha Chrisanthus <anitha.chrisanthus@intel.com>

[ Upstream commit a79f40cccd4644c32f6d5ae1ccf091a262e1dc57 ]

KMB only supports single resolution(1080p), this commit checks for
1920x1080x60 or 1920x1080x59 in crtc_mode_valid.
Also, modes with vfp < 4 are not supported in KMB display. This change
prunes display modes with vfp < 4.

v2: added vfp check

Fixes: 7f7b96a8a0a1 ("drm/kmb: Add support for KeemBay Display")
Co-developed-by: Edmund Dea <edmund.j.dea@intel.com>
Signed-off-by: Edmund Dea <edmund.j.dea@intel.com>
Signed-off-by: Anitha Chrisanthus <anitha.chrisanthus@intel.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Link:https://patchwork.freedesktop.org/patch/msgid/20211013233632.471892-2-anitha.chrisanthus@intel.com
Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/kmb/kmb_crtc.c | 34 ++++++++++++++++++++++++++++++++++
 drivers/gpu/drm/kmb/kmb_drv.h  |  9 ++++++++-
 2 files changed, 42 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/kmb/kmb_crtc.c b/drivers/gpu/drm/kmb/kmb_crtc.c
index 4f240466cf63..06613ffeaaf8 100644
--- a/drivers/gpu/drm/kmb/kmb_crtc.c
+++ b/drivers/gpu/drm/kmb/kmb_crtc.c
@@ -186,11 +186,45 @@ static void kmb_crtc_atomic_flush(struct drm_crtc *crtc,
 	spin_unlock_irq(&crtc->dev->event_lock);
 }
 
+static enum drm_mode_status
+		kmb_crtc_mode_valid(struct drm_crtc *crtc,
+				    const struct drm_display_mode *mode)
+{
+	int refresh;
+	struct drm_device *dev = crtc->dev;
+	int vfp = mode->vsync_start - mode->vdisplay;
+
+	if (mode->vdisplay < KMB_CRTC_MAX_HEIGHT) {
+		drm_dbg(dev, "height = %d less than %d",
+			mode->vdisplay, KMB_CRTC_MAX_HEIGHT);
+		return MODE_BAD_VVALUE;
+	}
+	if (mode->hdisplay < KMB_CRTC_MAX_WIDTH) {
+		drm_dbg(dev, "width = %d less than %d",
+			mode->hdisplay, KMB_CRTC_MAX_WIDTH);
+		return MODE_BAD_HVALUE;
+	}
+	refresh = drm_mode_vrefresh(mode);
+	if (refresh < KMB_MIN_VREFRESH || refresh > KMB_MAX_VREFRESH) {
+		drm_dbg(dev, "refresh = %d less than %d or greater than %d",
+			refresh, KMB_MIN_VREFRESH, KMB_MAX_VREFRESH);
+		return MODE_BAD;
+	}
+
+	if (vfp < KMB_CRTC_MIN_VFP) {
+		drm_dbg(dev, "vfp = %d less than %d", vfp, KMB_CRTC_MIN_VFP);
+		return MODE_BAD;
+	}
+
+	return MODE_OK;
+}
+
 static const struct drm_crtc_helper_funcs kmb_crtc_helper_funcs = {
 	.atomic_begin = kmb_crtc_atomic_begin,
 	.atomic_enable = kmb_crtc_atomic_enable,
 	.atomic_disable = kmb_crtc_atomic_disable,
 	.atomic_flush = kmb_crtc_atomic_flush,
+	.mode_valid = kmb_crtc_mode_valid,
 };
 
 int kmb_setup_crtc(struct drm_device *drm)
diff --git a/drivers/gpu/drm/kmb/kmb_drv.h b/drivers/gpu/drm/kmb/kmb_drv.h
index 5869890b8fc7..bf085e95b28f 100644
--- a/drivers/gpu/drm/kmb/kmb_drv.h
+++ b/drivers/gpu/drm/kmb/kmb_drv.h
@@ -20,11 +20,18 @@
 #define DRIVER_MAJOR			1
 #define DRIVER_MINOR			1
 
+/* Platform definitions */
+#define KMB_CRTC_MIN_VFP		4
+#define KMB_CRTC_MAX_WIDTH		1920 /* max width in pixels */
+#define KMB_CRTC_MAX_HEIGHT		1080 /* max height in pixels */
+#define KMB_CRTC_MIN_WIDTH		1920
+#define KMB_CRTC_MIN_HEIGHT		1080
 #define KMB_FB_MAX_WIDTH		1920
 #define KMB_FB_MAX_HEIGHT		1080
 #define KMB_FB_MIN_WIDTH		1
 #define KMB_FB_MIN_HEIGHT		1
-
+#define KMB_MIN_VREFRESH		59    /*vertical refresh in Hz */
+#define KMB_MAX_VREFRESH		60    /*vertical refresh in Hz */
 #define KMB_LCD_DEFAULT_CLK		200000000
 #define KMB_SYS_CLK_MHZ			500
 
-- 
2.33.0



