Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA65C431D82
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233885AbhJRNwG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:52:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:47684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233948AbhJRNuK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:50:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4F6760F11;
        Mon, 18 Oct 2021 13:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564269;
        bh=hcLD8jw7S9eVpfvObzQtoQYN/G3O82DDn2OSUIXuI3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i6rsvBWteFekiUy+harD4XJ8VbUjRlL9XUn8kh89gyqLOvYr+74kut50Rn6R9m7aI
         ge7c5lmjRqTTXT++FVAcDUVKC1dQR+ynq6ad1nLcCh2p6Cm06R3sr+LPSYGsFDgEqT
         8FLjBS5sagZZ0+3eChFoYHmuZ21IMx9y3PoM1Fdk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Zimmermann <tzimmermann@suse.de>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Amanoel Dawod <kernel@amanoeldawod.com>,
        =?UTF-8?q?Zolt=C3=A1n=20K=C5=91v=C3=A1g=C3=B3?= 
        <dirty.ice.hu@gmail.com>,
        Michael Stapelberg <michael+lkml@stapelberg.ch>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Maxime Ripard <maxime@cerno.tech>,
        dri-devel@lists.freedesktop.org, Dave Airlie <airlied@redhat.com>
Subject: [PATCH 5.14 025/151] drm/fbdev: Clamp fbdev surface size if too large
Date:   Mon, 18 Oct 2021 15:23:24 +0200
Message-Id: <20211018132341.499234552@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Zimmermann <tzimmermann@suse.de>

commit b693e42921e0220c0d564c55c6cdc680b0f85390 upstream.

Clamp the fbdev surface size of the available maximumi height to avoid
failing to init console emulation. An example error is shown below.

  bad framebuffer height 2304, should be >= 768 && <= 768
  [drm] Initialized simpledrm 1.0.0 20200625 for simple-framebuffer.0 on minor 0
  simple-framebuffer simple-framebuffer.0: [drm] *ERROR* fbdev: Failed to setup generic emulation (ret=-22)

This is especially a problem with drivers that have very small screen
sizes and cannot over-allocate at all.

v2:
	* reduce warning level (Ville)

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: 11e8f5fd223b ("drm: Add simpledrm driver")
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Reported-by: Amanoel Dawod <kernel@amanoeldawod.com>
Reported-by: Zoltán Kővágó <dirty.ice.hu@gmail.com>
Reported-by: Michael Stapelberg <michael+lkml@stapelberg.ch>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Maxime Ripard <maxime@cerno.tech>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v5.14+
Link: https://patchwork.freedesktop.org/patch/msgid/20211005070355.7680-1-tzimmermann@suse.de
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_fb_helper.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -1506,6 +1506,7 @@ static int drm_fb_helper_single_fb_probe
 {
 	struct drm_client_dev *client = &fb_helper->client;
 	struct drm_device *dev = fb_helper->dev;
+	struct drm_mode_config *config = &dev->mode_config;
 	int ret = 0;
 	int crtc_count = 0;
 	struct drm_connector_list_iter conn_iter;
@@ -1663,6 +1664,11 @@ static int drm_fb_helper_single_fb_probe
 	/* Handle our overallocation */
 	sizes.surface_height *= drm_fbdev_overalloc;
 	sizes.surface_height /= 100;
+	if (sizes.surface_height > config->max_height) {
+		drm_dbg_kms(dev, "Fbdev over-allocation too large; clamping height to %d\n",
+			    config->max_height);
+		sizes.surface_height = config->max_height;
+	}
 
 	/* push down into drivers */
 	ret = (*fb_helper->funcs->fb_probe)(fb_helper, &sizes);


