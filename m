Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A435F40E6DD
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347325AbhIPR0D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:26:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:46940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348097AbhIPRX6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:23:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D363761A40;
        Thu, 16 Sep 2021 16:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810608;
        bh=h7WoPbhk4P1tddmUKXsOWaZI7zGyW1QsZZxFbB4hm/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Aeg8BH7Yp5kfL86n4Ucn3F5GToiX4xidbzJBI2mryR4Rims44nEMyeKgNfCt6LJzf
         u4e0ORWZ2febI6QP++0LP0cHTA5FxlEGNB8ybxUYY6DdKStcFoZ600u8rfoo9whbio
         VV9lavh6BeMnY4EPgn8oVRIUmXSfjBO/TBQqBnwo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Tomi Valkeinen <tomba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 161/432] drm/omap: Follow implicit fencing in prepare_fb
Date:   Thu, 16 Sep 2021 17:58:30 +0200
Message-Id: <20210916155816.207004228@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



