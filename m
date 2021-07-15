Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A363B3CA640
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238427AbhGOSqx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:46:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:48308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231679AbhGOSqr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:46:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F24A6613D1;
        Thu, 15 Jul 2021 18:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626374633;
        bh=T6B42xJXCvzxyS1Yyia+GXBfJd7XvG9BGKMmjXmNc3o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bm8Z13mPfVE9NpYlAkgxnCXU7zyoyt/9FERQijTYanOY17i2AE8MvBl/JPX2kFhRa
         DZccrML9nUwNhW3yk6TYzMOVz3rHFuhtXNUgEzmGEL5o+D+WWK11Oj9SHlsFdWKXdH
         WgWarE8QN1aKthJd31C39DedHrZ26vBY1cKZs6ZI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pekka Paalanen <pekka.paalanen@collabora.com>,
        Thierry Reding <treding@nvidia.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        linux-tegra@vger.kernel.org
Subject: [PATCH 5.4 083/122] drm/tegra: Dont set allow_fb_modifiers explicitly
Date:   Thu, 15 Jul 2021 20:38:50 +0200
Message-Id: <20210715182512.573693683@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182448.393443551@linuxfoundation.org>
References: <20210715182448.393443551@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit be4306ad928fcf736cbe2616b6dd19d91f1bc083 upstream.

Since

commit 890880ddfdbe256083170866e49c87618b706ac7
Author: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Date:   Fri Jan 4 09:56:10 2019 +0100

    drm: Auto-set allow_fb_modifiers when given modifiers at plane init

this is done automatically as part of plane init, if drivers set the
modifier list correctly. Which is the case here.

It was slightly inconsistently though, since planes with only linear
modifier support haven't listed that explicitly. Fix that, and cc:
stable to allow userspace to rely on this. Again don't backport
further than where Paul's patch got added.

Cc: stable@vger.kernel.org # v5.1 +
Cc: Pekka Paalanen <pekka.paalanen@collabora.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Cc: Thierry Reding <thierry.reding@gmail.com>
Cc: Jonathan Hunter <jonathanh@nvidia.com>
Cc: linux-tegra@vger.kernel.org
Link: https://patchwork.freedesktop.org/patch/msgid/20210413094904.3736372-10-daniel.vetter@ffwll.ch
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/tegra/dc.c  |   10 ++++++++--
 drivers/gpu/drm/tegra/drm.c |    2 --
 2 files changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/tegra/dc.c
+++ b/drivers/gpu/drm/tegra/dc.c
@@ -919,6 +919,11 @@ static const struct drm_plane_helper_fun
 	.atomic_disable = tegra_cursor_atomic_disable,
 };
 
+static const uint64_t linear_modifiers[] = {
+	DRM_FORMAT_MOD_LINEAR,
+	DRM_FORMAT_MOD_INVALID
+};
+
 static struct drm_plane *tegra_dc_cursor_plane_create(struct drm_device *drm,
 						      struct tegra_dc *dc)
 {
@@ -947,7 +952,7 @@ static struct drm_plane *tegra_dc_cursor
 
 	err = drm_universal_plane_init(drm, &plane->base, possible_crtcs,
 				       &tegra_plane_funcs, formats,
-				       num_formats, NULL,
+				       num_formats, linear_modifiers,
 				       DRM_PLANE_TYPE_CURSOR, NULL);
 	if (err < 0) {
 		kfree(plane);
@@ -1065,7 +1070,8 @@ static struct drm_plane *tegra_dc_overla
 
 	err = drm_universal_plane_init(drm, &plane->base, possible_crtcs,
 				       &tegra_plane_funcs, formats,
-				       num_formats, NULL, type, NULL);
+				       num_formats, linear_modifiers,
+				       type, NULL);
 	if (err < 0) {
 		kfree(plane);
 		return ERR_PTR(err);
--- a/drivers/gpu/drm/tegra/drm.c
+++ b/drivers/gpu/drm/tegra/drm.c
@@ -122,8 +122,6 @@ static int tegra_drm_load(struct drm_dev
 	drm->mode_config.max_width = 4096;
 	drm->mode_config.max_height = 4096;
 
-	drm->mode_config.allow_fb_modifiers = true;
-
 	drm->mode_config.normalize_zpos = true;
 
 	drm->mode_config.funcs = &tegra_drm_mode_config_funcs;


