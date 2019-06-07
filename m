Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08C1D390D8
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731340AbfFGPqH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:46:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:58262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730496AbfFGPqG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:46:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F06B9212F5;
        Fri,  7 Jun 2019 15:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922366;
        bh=FW5w7A6SuCFU64s92XNLYs79VvKZL7XkFiSjqhtCBGw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y6gFuFo50wwbWu/b6PiDoTDri6oMyTKfRMUBzHBKNujYijolyAMw9l+3t2IMUytEd
         ASziqBDQwH021aaD8c2m7M3eIiUHv8s6BAh69h4F4S4aFJj8NhrlNQo9PCYEUTfctU
         S2G8ZsjrCaaM1GLBtVMx/Wd5BF7RA8jUHWI87F64=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Keith Packard <keithp@keithp.com>,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Daniel Vetter <daniel.vetter@intel.com>
Subject: [PATCH 4.19 61/73] drm/lease: Make sure implicit planes are leased
Date:   Fri,  7 Jun 2019 17:39:48 +0200
Message-Id: <20190607153855.793407973@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153848.669070800@linuxfoundation.org>
References: <20190607153848.669070800@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 204f640da6914844b3270b41b29c84f6e3b74083 upstream.

If userspace doesn't enable universal planes, then we automatically
add the primary and cursor planes. But for universal userspace there's
no such check (and maybe we only want to give the lessee one plane,
maybe not even the primary one), hence we need to check for the
implied plane.

v2: don't forget setcrtc ioctl.

v3: Still allow disabling of the crtc in SETCRTC.

Cc: stable@vger.kernel.org
Cc: Keith Packard <keithp@keithp.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190228144910.26488-6-daniel.vetter@ffwll.ch
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/drm_crtc.c  |    4 ++++
 drivers/gpu/drm/drm_plane.c |    8 ++++++++
 2 files changed, 12 insertions(+)

--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -595,6 +595,10 @@ int drm_mode_setcrtc(struct drm_device *
 
 	plane = crtc->primary;
 
+	/* allow disabling with the primary plane leased */
+	if (crtc_req->mode_valid && !drm_lease_held(file_priv, plane->base.id))
+		return -EACCES;
+
 	mutex_lock(&crtc->dev->mode_config.mutex);
 	drm_modeset_acquire_init(&ctx, DRM_MODESET_ACQUIRE_INTERRUPTIBLE);
 retry:
--- a/drivers/gpu/drm/drm_plane.c
+++ b/drivers/gpu/drm/drm_plane.c
@@ -940,6 +940,11 @@ retry:
 		if (ret)
 			goto out;
 
+		if (!drm_lease_held(file_priv, crtc->cursor->base.id)) {
+			ret = -EACCES;
+			goto out;
+		}
+
 		ret = drm_mode_cursor_universal(crtc, req, file_priv, &ctx);
 		goto out;
 	}
@@ -1042,6 +1047,9 @@ int drm_mode_page_flip_ioctl(struct drm_
 
 	plane = crtc->primary;
 
+	if (!drm_lease_held(file_priv, plane->base.id))
+		return -EACCES;
+
 	if (crtc->funcs->page_flip_target) {
 		u32 current_vblank;
 		int r;


