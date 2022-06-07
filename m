Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85B6C54197C
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353247AbiFGVWX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:22:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380807AbiFGVQ7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:16:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 738981CFF9;
        Tue,  7 Jun 2022 11:57:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E57E6176D;
        Tue,  7 Jun 2022 18:57:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17A41C34115;
        Tue,  7 Jun 2022 18:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628259;
        bh=5x9rPzB2VVz92YlALq//O6CF/mu6mIhkuZuW8AeZanY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M1EQ+6DNZDpd6mArIc4lyfhVmCb+KjQra5NnoljBuvL4bGOFjrbE911LJUY4VToSk
         BJ05b3LKMBv/racdkcCwa68QxlFbshbSWwJs0rJIu2+qRHuP2peMvCTgwh6z7B9mVI
         huUzLRzmh20t0QeGuhTSk3MVoR10y4CNk0zfZgx8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 264/879] drm/ssd130x: Fix rectangle updates
Date:   Tue,  7 Jun 2022 18:56:22 +0200
Message-Id: <20220607165010.513065628@linuxfoundation.org>
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

[ Upstream commit a97e753fd358e23155ae42c61292dfd57eb54c4a ]

The rectangle update functions ssd130x_fb_blit_rect() and
ssd130x_update_rect() do not behave correctly when x1 != 0 or y1 !=
0, or when y1 or y2 are not aligned to display page boundaries.
E.g. when used as a text console, only the first line of text is shown
on the display.

  1. The buffer passed by ssd130x_fb_blit_rect() points to the first
     byte of monochrome bitmap data, and thus has its origin at (x1,
     y1), while ssd130x_update_rect() assumes it is at (0, 0).
     Fix ssd130x_update_rect() by changing the vertical and horizontal
     loop ranges, and adding the offsets only when needed.

  2. In ssd130x_fb_blit_rect(), align y1 and y2 to the display page
     boundaries before doing the color conversion, so the full page
     is converted and updated.
     Remove the correction for an unaligned y1 from
     ssd130x_update_rect(), and add a check to make sure y1 is aligned.

Fixes: a61732e808672cfa ("drm: Add driver for Solomon SSD130x OLED displays")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Javier Martinez Canillas <javierm@redhat.com>
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220317081830.1211400-4-geert@linux-m68k.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/solomon/ssd130x.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/solomon/ssd130x.c b/drivers/gpu/drm/solomon/ssd130x.c
index caee851efd57..7c99af4ce9dd 100644
--- a/drivers/gpu/drm/solomon/ssd130x.c
+++ b/drivers/gpu/drm/solomon/ssd130x.c
@@ -355,11 +355,14 @@ static int ssd130x_update_rect(struct ssd130x_device *ssd130x, u8 *buf,
 	unsigned int width = drm_rect_width(rect);
 	unsigned int height = drm_rect_height(rect);
 	unsigned int line_length = DIV_ROUND_UP(width, 8);
-	unsigned int pages = DIV_ROUND_UP(y % 8 + height, 8);
+	unsigned int pages = DIV_ROUND_UP(height, 8);
+	struct drm_device *drm = &ssd130x->drm;
 	u32 array_idx = 0;
 	int ret, i, j, k;
 	u8 *data_array = NULL;
 
+	drm_WARN_ONCE(drm, y % 8 != 0, "y must be aligned to screen page\n");
+
 	data_array = kcalloc(width, pages, GFP_KERNEL);
 	if (!data_array)
 		return -ENOMEM;
@@ -401,13 +404,13 @@ static int ssd130x_update_rect(struct ssd130x_device *ssd130x, u8 *buf,
 	if (ret < 0)
 		goto out_free;
 
-	for (i = y / 8; i < y / 8 + pages; i++) {
+	for (i = 0; i < pages; i++) {
 		int m = 8;
 
 		/* Last page may be partial */
-		if (8 * (i + 1) > ssd130x->height)
+		if (8 * (y / 8 + i + 1) > ssd130x->height)
 			m = ssd130x->height % 8;
-		for (j = x; j < x + width; j++) {
+		for (j = 0; j < width; j++) {
 			u8 data = 0;
 
 			for (k = 0; k < m; k++) {
@@ -454,6 +457,10 @@ static int ssd130x_fb_blit_rect(struct drm_framebuffer *fb, const struct iosys_m
 	int ret = 0;
 	u8 *buf = NULL;
 
+	/* Align y to display page boundaries */
+	rect->y1 = round_down(rect->y1, 8);
+	rect->y2 = min_t(unsigned int, round_up(rect->y2, 8), ssd130x->height);
+
 	buf = kcalloc(fb->width, fb->height, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
-- 
2.35.1



