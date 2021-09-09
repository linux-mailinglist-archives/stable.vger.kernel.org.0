Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4EA040432F
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 03:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349279AbhIIBro (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Sep 2021 21:47:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:39686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349304AbhIIBrk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Sep 2021 21:47:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFDCB61167;
        Thu,  9 Sep 2021 01:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631151991;
        bh=h7WoPbhk4P1tddmUKXsOWaZI7zGyW1QsZZxFbB4hm/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gDfTdktCPhFNy4SSh9nE6a7SCjhZLyZNYV6hQWuReZus7e5TWfmC39YMEWyq9bKw5
         meL/9EnJORqF0rU1wIcCG9waH0rvfejnnQRSiRH4BKoE/G+QtxSEynX5iuiSV0e3p6
         OWyoCzH7e+0rTJfno8hsmVREplRABX6/RQrRiBgUPsl6GDxqIGeQJbODm6rf2gtoIO
         NzfYPYj0eZVDG+bpWvKowzkYwBbnC9Mh3XlK3k3BAe/MCrhxg3EC/lt9FWtQoWreqi
         LsXHpIPZI7tE0a11aVNg9Ntg7Gyckp6q3dmI34lW80kFJxVtgcojyp7Kp+8QQ+lVob
         6HlCyg+z1KeIA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Tomi Valkeinen <tomba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.14 006/252] drm/omap: Follow implicit fencing in prepare_fb
Date:   Wed,  8 Sep 2021 21:42:16 -0400
Message-Id: <20210909014623.128976-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909014623.128976-1-sashal@kernel.org>
References: <20210909014623.128976-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Vetter <daniel.vetter@ffwll.ch>

[ Upstream commit 942d8344d5f14b9ea2ae43756f319b9f44216ba4 ]

I guess no one ever tried running omap together with lima or panfrost,
not even sure that's possible. Anyway for consistency, fix this.

Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Cc: Tomi Valkeinen <tomba@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20210622165511.3169559-12-daniel.vetter@ffwll.ch
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/omapdrm/omap_plane.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/omapdrm/omap_plane.c b/drivers/gpu/drm/omapdrm/omap_plane.c
index 801da917507d..512af976b7e9 100644
--- a/drivers/gpu/drm/omapdrm/omap_plane.c
+++ b/drivers/gpu/drm/omapdrm/omap_plane.c
@@ -6,6 +6,7 @@
 
 #include <drm/drm_atomic.h>
 #include <drm/drm_atomic_helper.h>
+#include <drm/drm_gem_atomic_helper.h>
 #include <drm/drm_plane_helper.h>
 
 #include "omap_dmm_tiler.h"
@@ -29,6 +30,8 @@ static int omap_plane_prepare_fb(struct drm_plane *plane,
 	if (!new_state->fb)
 		return 0;
 
+	drm_gem_plane_helper_prepare_fb(plane, new_state);
+
 	return omap_framebuffer_pin(new_state->fb);
 }
 
-- 
2.30.2

