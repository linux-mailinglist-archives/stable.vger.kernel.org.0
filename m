Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8DABCEE7
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 19:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410175AbfIXQs7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 12:48:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:41034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2410171AbfIXQs7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Sep 2019 12:48:59 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4C7E21971;
        Tue, 24 Sep 2019 16:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569343738;
        bh=D+5+refmVJN0BInrZBrBKnq8Z+wMu8TansF66Q6t0aY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dmMn16/+8C1Kt/mfXjFzO5ts9/8r8F9M82BELxYYFHyGaabuc1+Yy+aYOqXp7BOnl
         h9S/s6Ivhr2jFnrqbX96Y3uGeVIllMsj0A60yfS0u0lQBpIcOXmFnB7bBOJCR1wgIo
         EG5m8S0/STJ5GjVzbDRSKVlf79OrGfTlVqkhpxFk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Lucas Stach <l.stach@pengutronix.de>,
        Philippe Cornu <philippe.cornu@st.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 06/50] drm/stm: attach gem fence to atomic state
Date:   Tue, 24 Sep 2019 12:48:03 -0400
Message-Id: <20190924164847.27780-6-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190924164847.27780-1-sashal@kernel.org>
References: <20190924164847.27780-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ahmad Fatoum <a.fatoum@pengutronix.de>

[ Upstream commit 8fabc9c3109a71b3577959a05408153ae69ccd8d ]

To properly synchronize with other devices the fence from the GEM
object backing the framebuffer needs to be attached to the atomic
state, so the commit work can wait on fence signaling.

Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Acked-by: Philippe Cornu <philippe.cornu@st.com>
Tested-by: Philippe Cornu <philippe.cornu@st.com>
Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20190712084228.8338-1-l.stach@pengutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/stm/ltdc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/stm/ltdc.c b/drivers/gpu/drm/stm/ltdc.c
index 808d9fb627e97..477d0a27b9a5d 100644
--- a/drivers/gpu/drm/stm/ltdc.c
+++ b/drivers/gpu/drm/stm/ltdc.c
@@ -19,6 +19,7 @@
 #include <drm/drm_crtc_helper.h>
 #include <drm/drm_fb_cma_helper.h>
 #include <drm/drm_gem_cma_helper.h>
+#include <drm/drm_gem_framebuffer_helper.h>
 #include <drm/drm_of.h>
 #include <drm/drm_bridge.h>
 #include <drm/drm_plane_helper.h>
@@ -825,6 +826,7 @@ static const struct drm_plane_funcs ltdc_plane_funcs = {
 };
 
 static const struct drm_plane_helper_funcs ltdc_plane_helper_funcs = {
+	.prepare_fb = drm_gem_fb_prepare_fb,
 	.atomic_check = ltdc_plane_atomic_check,
 	.atomic_update = ltdc_plane_atomic_update,
 	.atomic_disable = ltdc_plane_atomic_disable,
-- 
2.20.1

