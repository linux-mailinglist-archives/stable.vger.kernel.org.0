Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B51668D79F
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:01:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232025AbjBGNBi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:01:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231994AbjBGNBe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:01:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F0213928E
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:01:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7305AB81991
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:00:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A75FDC433D2;
        Tue,  7 Feb 2023 13:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675774851;
        bh=+D/Od7NPdnKTYAE9Bsp8AJSmn4Ekefz0I673fJMZ8Mg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rt7rijkIHvDDZZx//w27zY+sKEBw78r4+TQJU1rZ92L1gQqu83reEO5SeTsjeNmun
         i5e8fnNYkCLaw27rh2vDa2+t+ZQ+3t/T43Iy50ZwUlYPFl9hTqs6Me5yN0Mt6B/LwF
         c27NJLfwYEDquDq5BWRoAULIuh1L3eiCMSvP9LmI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Javier Martinez Canillas <javierm@redhat.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 025/208] drm/ssd130x: Init display before the SSD130X_DISPLAY_ON command
Date:   Tue,  7 Feb 2023 13:54:39 +0100
Message-Id: <20230207125635.443016647@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Javier Martinez Canillas <javierm@redhat.com>

[ Upstream commit 343c700480982214dc4f834f536a49a4098e556a ]

Commit 622113b9f11f ("drm/ssd130x: Replace simple display helpers with the
atomic helpers") changed the driver to just use the atomic helpers instead
of the simple KMS abstraction layer.

But the commit also made a subtle change on the display power sequence and
initialization order, by moving the ssd130x_power_on() call to the encoder
.atomic_enable handler and the ssd130x_init() call to CRTC .reset handler.

Before this change, both ssd130x_power_on() and ssd130x_init() were called
in the simple display pipeline .enable handler, so the display was already
initialized by the time the SSD130X_DISPLAY_ON command was sent.

For some reasons, it only made the ssd130x SPI driver to fail but the I2C
was still working. That is the reason why the bug was not noticed before.

To revert to the old driver behavior, move the ssd130x_init() call to the
encoder .atomic_enable as well. Besides fixing the panel not being turned
on when using SPI, it also gets rid of the custom CRTC .reset callback.

Fixes: 622113b9f11f ("drm/ssd130x: Replace simple display helpers with the atomic helpers")
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20230125184230.3343206-1-javierm@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/solomon/ssd130x.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/solomon/ssd130x.c b/drivers/gpu/drm/solomon/ssd130x.c
index bc41a5ae810a..4bb3a247732d 100644
--- a/drivers/gpu/drm/solomon/ssd130x.c
+++ b/drivers/gpu/drm/solomon/ssd130x.c
@@ -665,18 +665,8 @@ static const struct drm_crtc_helper_funcs ssd130x_crtc_helper_funcs = {
 	.atomic_check = ssd130x_crtc_helper_atomic_check,
 };
 
-static void ssd130x_crtc_reset(struct drm_crtc *crtc)
-{
-	struct drm_device *drm = crtc->dev;
-	struct ssd130x_device *ssd130x = drm_to_ssd130x(drm);
-
-	ssd130x_init(ssd130x);
-
-	drm_atomic_helper_crtc_reset(crtc);
-}
-
 static const struct drm_crtc_funcs ssd130x_crtc_funcs = {
-	.reset = ssd130x_crtc_reset,
+	.reset = drm_atomic_helper_crtc_reset,
 	.destroy = drm_crtc_cleanup,
 	.set_config = drm_atomic_helper_set_config,
 	.page_flip = drm_atomic_helper_page_flip,
@@ -695,6 +685,12 @@ static void ssd130x_encoder_helper_atomic_enable(struct drm_encoder *encoder,
 	if (ret)
 		return;
 
+	ret = ssd130x_init(ssd130x);
+	if (ret) {
+		ssd130x_power_off(ssd130x);
+		return;
+	}
+
 	ssd130x_write_cmd(ssd130x, 1, SSD130X_DISPLAY_ON);
 
 	backlight_enable(ssd130x->bl_dev);
-- 
2.39.0



