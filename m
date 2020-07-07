Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27534216D70
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 15:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbgGGNHU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 09:07:20 -0400
Received: from crapouillou.net ([89.234.176.41]:45622 "EHLO crapouillou.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727895AbgGGNHU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 09:07:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crapouillou.net;
        s=mail; t=1594127238; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-transfer-encoding:content-transfer-encoding:
         in-reply-to:references; bh=q4SL+J9EcSs3AmwoAqYh6KtTKakyJwet0kGs7hQIwls=;
        b=oGVl+d2QBm9o2o6lk5l695qSljJjF4/YG8hccdm0JZHMHeYz7GToeP5W2suvKjba/Ao1pt
        txvnvr8/VKbzzK/aI2UCIKqeglqi4kQC1uI8fGhtdXQoxeMcOeXwEsrAora64eKbc6bG9i
        v/OVyZnTgodjWIPO3jJkj7dwKCMTMG8=
From:   Paul Cercueil <paul@crapouillou.net>
To:     Thierry Reding <thierry.reding@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>
Cc:     dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Paul Cercueil <paul@crapouillou.net>, stable@vger.kernel.org
Subject: [PATCH 1/2] drm/panel-simple: Fix inverted V/H SYNC for Frida FRD350H54004 panel
Date:   Tue,  7 Jul 2020 15:07:06 +0200
Message-Id: <20200707130707.51843-1-paul@crapouillou.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The FRD350H54004 panel was marked as having active-high VSYNC and HSYNC
signals, which sorts-of worked, but resulted in the picture fading out
under certain circumstances.

Fix this issue by marking VSYNC and HSYNC signals active-low.

Fixes: 7b6bd8433609 ("drm/panel: simple: Add support for the Frida FRD350H54004 panel")
Cc: stable@vger.kernel.org # v5.5
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
---
 drivers/gpu/drm/panel/panel-simple.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index 5178f87d6574..1188d191076b 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -1703,7 +1703,7 @@ static const struct drm_display_mode frida_frd350h54004_mode = {
 	.vsync_end = 240 + 2 + 6,
 	.vtotal = 240 + 2 + 6 + 2,
 	.vrefresh = 60,
-	.flags = DRM_MODE_FLAG_PHSYNC | DRM_MODE_FLAG_PVSYNC,
+	.flags = DRM_MODE_FLAG_NHSYNC | DRM_MODE_FLAG_NVSYNC,
 };
 
 static const struct panel_desc frida_frd350h54004 = {
-- 
2.27.0

