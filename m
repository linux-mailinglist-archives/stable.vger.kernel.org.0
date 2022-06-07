Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 601665418ED
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350553AbiFGVSS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:18:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380813AbiFGVQ7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:16:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5916B11C1D;
        Tue,  7 Jun 2022 11:57:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B36CA6159D;
        Tue,  7 Jun 2022 18:57:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2756C385A2;
        Tue,  7 Jun 2022 18:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628262;
        bh=jgkNuQnH2JVLqt1XUkjKASunCg6Sd0cNwbnANHgb/0Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iUBvKzLBmaSIJcYPLmoWZfwh4oRAAljJb9ynDrxEtnjk5y0fEGcp4zb1AhL8LjlEH
         xdV2zgpuB2sk2jRdsQurugJT7KS90UbUhgeZ/Hzqg+foA+lKyPniEpSimM4xy7C6st
         uEVoRpTgSYdRpFInek3KVq/HmFbLDzuDdJfGw3r0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 265/879] drm/ssd130x: Reduce temporary buffer sizes
Date:   Tue,  7 Jun 2022 18:56:23 +0200
Message-Id: <20220607165010.541528639@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

[ Upstream commit 4442ac1af10442d6e7e824fdc226f89ed94d5b53 ]

ssd130x_clear_screen() allocates a temporary buffer sized to hold one
byte per pixel, while it only needs to hold one bit per pixel.

ssd130x_fb_blit_rect() allocates a temporary buffer sized to hold one
byte per pixel for the whole frame buffer, while it only needs to hold
one bit per pixel for the part that is to be updated.
Pass dst_pitch to drm_fb_xrgb8888_to_mono(), as we have already
calculated it anyway.

Fixes: a61732e808672cfa ("drm: Add driver for Solomon SSD130x OLED displays")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Javier Martinez Canillas <javierm@redhat.com>
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220317081830.1211400-5-geert@linux-m68k.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/solomon/ssd130x.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/solomon/ssd130x.c b/drivers/gpu/drm/solomon/ssd130x.c
index 7c99af4ce9dd..38b6c2c14f53 100644
--- a/drivers/gpu/drm/solomon/ssd130x.c
+++ b/drivers/gpu/drm/solomon/ssd130x.c
@@ -440,7 +440,8 @@ static void ssd130x_clear_screen(struct ssd130x_device *ssd130x)
 		.y2 = ssd130x->height,
 	};
 
-	buf = kcalloc(ssd130x->width, ssd130x->height, GFP_KERNEL);
+	buf = kcalloc(DIV_ROUND_UP(ssd130x->width, 8), ssd130x->height,
+		      GFP_KERNEL);
 	if (!buf)
 		return;
 
@@ -454,6 +455,7 @@ static int ssd130x_fb_blit_rect(struct drm_framebuffer *fb, const struct iosys_m
 {
 	struct ssd130x_device *ssd130x = drm_to_ssd130x(fb->dev);
 	void *vmap = map->vaddr; /* TODO: Use mapping abstraction properly */
+	unsigned int dst_pitch;
 	int ret = 0;
 	u8 *buf = NULL;
 
@@ -461,11 +463,12 @@ static int ssd130x_fb_blit_rect(struct drm_framebuffer *fb, const struct iosys_m
 	rect->y1 = round_down(rect->y1, 8);
 	rect->y2 = min_t(unsigned int, round_up(rect->y2, 8), ssd130x->height);
 
-	buf = kcalloc(fb->width, fb->height, GFP_KERNEL);
+	dst_pitch = DIV_ROUND_UP(drm_rect_width(rect), 8);
+	buf = kcalloc(dst_pitch, drm_rect_height(rect), GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 
-	drm_fb_xrgb8888_to_mono(buf, 0, vmap, fb, rect);
+	drm_fb_xrgb8888_to_mono(buf, dst_pitch, vmap, fb, rect);
 
 	ssd130x_update_rect(ssd130x, buf, rect);
 
-- 
2.35.1



