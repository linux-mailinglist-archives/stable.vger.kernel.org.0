Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE0A72F9200
	for <lists+stable@lfdr.de>; Sun, 17 Jan 2021 12:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728408AbhAQL3X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Jan 2021 06:29:23 -0500
Received: from aposti.net ([89.234.176.197]:36706 "EHLO aposti.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728382AbhAQL3W (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 17 Jan 2021 06:29:22 -0500
From:   Paul Cercueil <paul@crapouillou.net>
To:     David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>
Cc:     Sam Ravnborg <sam@ravnborg.org>, od@zcrc.me,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Paul Cercueil <paul@crapouillou.net>, stable@vger.kernel.org
Subject: [PATCH 2/3] drm/ingenic: Register devm action to cleanup encoders
Date:   Sun, 17 Jan 2021 11:26:45 +0000
Message-Id: <20210117112646.98353-3-paul@crapouillou.net>
In-Reply-To: <20210117112646.98353-1-paul@crapouillou.net>
References: <20210117112646.98353-1-paul@crapouillou.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since the encoders have been devm-allocated, they will be freed way
before drm_mode_config_cleanup() is called. To avoid use-after-free
conditions, we then must ensure that drm_encoder_cleanup() is called
before the encoders are freed.

Fixes: c369cb27c267 ("drm/ingenic: Support multiple panels/bridges")
Cc: <stable@vger.kernel.org> # 5.8+
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
---
 drivers/gpu/drm/ingenic/ingenic-drm-drv.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/gpu/drm/ingenic/ingenic-drm-drv.c b/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
index 368bfef8b340..d23a3292a0e0 100644
--- a/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
+++ b/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
@@ -803,6 +803,11 @@ static void __maybe_unused ingenic_drm_release_rmem(void *d)
 	of_reserved_mem_device_release(d);
 }
 
+static void ingenic_drm_encoder_cleanup(void *encoder)
+{
+	drm_encoder_cleanup(encoder);
+}
+
 static int ingenic_drm_bind(struct device *dev, bool has_components)
 {
 	struct platform_device *pdev = to_platform_device(dev);
@@ -1011,6 +1016,11 @@ static int ingenic_drm_bind(struct device *dev, bool has_components)
 			return ret;
 		}
 
+		ret = devm_add_action_or_reset(dev, ingenic_drm_encoder_cleanup,
+					       encoder);
+		if (ret)
+			return ret;
+
 		ret = drm_bridge_attach(encoder, bridge, NULL, 0);
 		if (ret) {
 			dev_err(dev, "Unable to attach bridge\n");
-- 
2.29.2

