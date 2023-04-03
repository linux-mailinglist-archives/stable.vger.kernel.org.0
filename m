Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 064D46D4852
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233348AbjDCO1l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:27:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233344AbjDCO1k (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:27:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A17C319A9
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:27:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD6F6B81C15
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:27:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 268CEC433EF;
        Mon,  3 Apr 2023 14:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532055;
        bh=CWtyyx3MgD4WAeRD4gojJ7zwP2RRGe6+mgHkGYRc3vM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=encBFfk/JVsvvXkdcg7j0hvTGbkyJ1PFE5xDNxpfYNL4pjDgjaqwZ7LFbp8LLvtz9
         e2UWWwSITY2IAo22O/5my1u6GVSEWFBz/qfqWNUBlErQZItCt6qSC2NdTWUoFFTwnM
         3VjST+EI5OU60yYqrOsqo7z0++TvPzQDQBNf3/vo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Johan Hovold <johan+linaro@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 109/173] drm/meson: fix missing component unbind on bind errors
Date:   Mon,  3 Apr 2023 16:08:44 +0200
Message-Id: <20230403140417.967398654@linuxfoundation.org>
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

From: Johan Hovold <johan+linaro@kernel.org>

[ Upstream commit ba98413bf45edbf33672e2539e321b851b2cfbd1 ]

Make sure to unbind all subcomponents when binding the aggregate device
fails.

Fixes: a41e82e6c457 ("drm/meson: Add support for components")
Cc: stable@vger.kernel.org      # 4.12
Cc: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Acked-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20230306103533.4915-1-johan+linaro@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/meson/meson_drv.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/meson/meson_drv.c b/drivers/gpu/drm/meson/meson_drv.c
index 090878bd74f6a..5c29ddf93eb3f 100644
--- a/drivers/gpu/drm/meson/meson_drv.c
+++ b/drivers/gpu/drm/meson/meson_drv.c
@@ -339,19 +339,19 @@ static int meson_drv_bind_master(struct device *dev, bool has_components)
 
 	ret = meson_plane_create(priv);
 	if (ret)
-		goto exit_afbcd;
+		goto unbind_all;
 
 	ret = meson_overlay_create(priv);
 	if (ret)
-		goto exit_afbcd;
+		goto unbind_all;
 
 	ret = meson_crtc_create(priv);
 	if (ret)
-		goto exit_afbcd;
+		goto unbind_all;
 
 	ret = drm_irq_install(drm, priv->vsync_irq);
 	if (ret)
-		goto exit_afbcd;
+		goto unbind_all;
 
 	drm_mode_config_reset(drm);
 
@@ -369,6 +369,9 @@ static int meson_drv_bind_master(struct device *dev, bool has_components)
 
 uninstall_irq:
 	drm_irq_uninstall(drm);
+unbind_all:
+	if (has_components)
+		component_unbind_all(drm->dev, drm);
 exit_afbcd:
 	if (priv->afbcd.ops)
 		priv->afbcd.ops->exit(priv);
-- 
2.39.2



