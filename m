Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E92DF404DE5
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345952AbhIIMHS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:07:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:42132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345073AbhIIMC1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:02:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F393261507;
        Thu,  9 Sep 2021 11:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188001;
        bh=h7WoPbhk4P1tddmUKXsOWaZI7zGyW1QsZZxFbB4hm/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jC7YsuWuxmjAQAdMsB0lUP15vWilvUh+pJxdeIB9aBvGQFECvWRKvhWm1AwYp9RoK
         kuqbRRO0EHiHgNQASa/7jygon/wjHOBOtb6SQhIb3nHtDQ0Qrl+nIZehakpHCYTQxy
         b5NSCqyadzOcs68vIKGiC/i8jOB8J7jPtOlvZIy46sMOAhU8QYpxa9I2sXyNC1p7AV
         sFQDGSY3HcMdVD/DNvkEATspKzIc61vT+z3efy2xs0+tGLKE1PXzHiNK3l0CPamd33
         akwc9ebbxboZ+dI8zeU1sVwq+pXwBJm2leywLvmz31BdoqNKArfU7ASiJxgaWzvLI1
         QkW3ABSs6AW2g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Tomi Valkeinen <tomba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.13 004/219] drm/omap: Follow implicit fencing in prepare_fb
Date:   Thu,  9 Sep 2021 07:43:00 -0400
Message-Id: <20210909114635.143983-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
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

