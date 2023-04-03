Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2443B6D4850
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233345AbjDCO1h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:27:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233344AbjDCO1g (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:27:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CC7731984
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:27:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40D7AB81C1C
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:27:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D22DC4339B;
        Mon,  3 Apr 2023 14:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532052;
        bh=bxh4Im4MNB+kYEPjhoLdRJTOVRxeKJsCl/GzbTaFKCI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SN1M/eeYQv4Z/dOIiEgFQDn1fnwqD8k5yxlWLPlsIUb34ScdspF/lH7GIZy/Mt8Hb
         gVt/yHlZX3Ay8uVCucxkDLeQJ+bjjpLzXmeK1ry65UTh3LMrKPRUTcPr57Li1dZyOP
         tF7wMimyyT/iFW1eXQscasQ9xQi9zxAY4RDOWW64=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 108/173] drm/meson: Fix error handling when afbcd.ops->init fails
Date:   Mon,  3 Apr 2023 16:08:43 +0200
Message-Id: <20230403140417.938459326@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140414.174516815@linuxfoundation.org>
References: <20230403140414.174516815@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit fa747d75f65d1b1cbc3f4691fa67b695e8a399c8 ]

When afbcd.ops->init fails we need to free the struct drm_device. Also
all errors which come after afbcd.ops->init was successful need to exit
the AFBCD, just like meson_drv_unbind() does.

Fixes: d1b5e41e13a7e9 ("drm/meson: Add AFBCD module driver")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Acked-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20211230235515.1627522-3-martin.blumenstingl@googlemail.com
Stable-dep-of: ba98413bf45e ("drm/meson: fix missing component unbind on bind errors")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/meson/meson_drv.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/meson/meson_drv.c b/drivers/gpu/drm/meson/meson_drv.c
index b0bfe85f5f6a8..090878bd74f6a 100644
--- a/drivers/gpu/drm/meson/meson_drv.c
+++ b/drivers/gpu/drm/meson/meson_drv.c
@@ -320,38 +320,38 @@ static int meson_drv_bind_master(struct device *dev, bool has_components)
 	if (priv->afbcd.ops) {
 		ret = priv->afbcd.ops->init(priv);
 		if (ret)
-			return ret;
+			goto free_drm;
 	}
 
 	/* Encoder Initialization */
 
 	ret = meson_venc_cvbs_create(priv);
 	if (ret)
-		goto free_drm;
+		goto exit_afbcd;
 
 	if (has_components) {
 		ret = component_bind_all(drm->dev, drm);
 		if (ret) {
 			dev_err(drm->dev, "Couldn't bind all components\n");
-			goto free_drm;
+			goto exit_afbcd;
 		}
 	}
 
 	ret = meson_plane_create(priv);
 	if (ret)
-		goto free_drm;
+		goto exit_afbcd;
 
 	ret = meson_overlay_create(priv);
 	if (ret)
-		goto free_drm;
+		goto exit_afbcd;
 
 	ret = meson_crtc_create(priv);
 	if (ret)
-		goto free_drm;
+		goto exit_afbcd;
 
 	ret = drm_irq_install(drm, priv->vsync_irq);
 	if (ret)
-		goto free_drm;
+		goto exit_afbcd;
 
 	drm_mode_config_reset(drm);
 
@@ -369,6 +369,9 @@ static int meson_drv_bind_master(struct device *dev, bool has_components)
 
 uninstall_irq:
 	drm_irq_uninstall(drm);
+exit_afbcd:
+	if (priv->afbcd.ops)
+		priv->afbcd.ops->exit(priv);
 free_drm:
 	drm_dev_put(drm);
 
-- 
2.39.2



