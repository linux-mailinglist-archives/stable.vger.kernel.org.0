Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A95B39061
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731731AbfFGPvd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:51:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:37370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732172AbfFGPua (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:50:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC6342146E;
        Fri,  7 Jun 2019 15:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922629;
        bh=//FzWUZwojhZSX2h7n6QW9yj312ANGnl+VXJWOpRgLs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gwg9WkTb13hCnvHM11+tU8LN9Y85J+SgTjLfU/eOm6rB3L/HvhPITV4Qc6oclzGTg
         LjUDgqi4xOYMyFsHwYnal93md8H1Ukzjni12Rq5XMCJQQyFi9k+XF0vXNfPOAcWWY7
         3mgfUuawsHvn2cbhBzG0wjeRVb7DoNjdJRJFgF0Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Keith Packard <keithp@keithp.com>,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Daniel Vetter <daniel.vetter@intel.com>
Subject: [PATCH 5.1 82/85] drm/lease: Make sure implicit planes are leased
Date:   Fri,  7 Jun 2019 17:40:07 +0200
Message-Id: <20190607153857.941099432@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153849.101321647@linuxfoundation.org>
References: <20190607153849.101321647@linuxfoundation.org>
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
@@ -559,6 +559,10 @@ int drm_mode_setcrtc(struct drm_device *
 
 	plane = crtc->primary;
 
+	/* allow disabling with the primary plane leased */
+	if (crtc_req->mode_valid && !drm_lease_held(file_priv, plane->base.id))
+		return -EACCES;
+
 	mutex_lock(&crtc->dev->mode_config.mutex);
 	DRM_MODESET_LOCK_ALL_BEGIN(dev, ctx,
 				   DRM_MODESET_ACQUIRE_INTERRUPTIBLE, ret);
--- a/drivers/gpu/drm/drm_plane.c
+++ b/drivers/gpu/drm/drm_plane.c
@@ -960,6 +960,11 @@ retry:
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
@@ -1062,6 +1067,9 @@ int drm_mode_page_flip_ioctl(struct drm_
 
 	plane = crtc->primary;
 
+	if (!drm_lease_held(file_priv, plane->base.id))
+		return -EACCES;
+
 	if (crtc->funcs->page_flip_target) {
 		u32 current_vblank;
 		int r;


