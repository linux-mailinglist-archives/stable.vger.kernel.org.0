Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C84AD621478
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:01:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234941AbiKHOBn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:01:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234949AbiKHOBh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:01:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40EDE682B3
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:01:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D1A476152D
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:01:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1563C433C1;
        Tue,  8 Nov 2022 14:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916096;
        bh=p8b2hTvH9GVMRAwvndYCtY9fxlRCRZamGuqz+oL8d9M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dqc9HcslTQsDFQthgeTUgXMCqgzo4HXo+1XJqDuav6pBHnuIsEsgtIEPPgdJD6Kmm
         bczQO9g2/FjzDeKibA+UwVOVxwJlyHg/nHFe2Ju9uK9/JeuBh+f9etNN7GfYKmiE45
         /PNuTVbGJHqzLNbcd0mVRFXskE+fEN0GHC4Rh4Bc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Helge Deller <deller@gmx.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 061/144] video/fbdev/stifb: Implement the stifb_fillrect() function
Date:   Tue,  8 Nov 2022 14:38:58 +0100
Message-Id: <20221108133347.847284996@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
References: <20221108133345.346704162@linuxfoundation.org>
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

From: Helge Deller <deller@gmx.de>

[ Upstream commit 9c379c65241707e44072139d782bc2dfec9b4ab3 ]

The stifb driver (for Artist/HCRX graphics on PA-RISC) was missing
the fillrect function.
Tested on a 715/64 PA-RISC machine and in qemu.

Signed-off-by: Helge Deller <deller@gmx.de>
Stable-dep-of: 776d875fd4cb ("fbdev: stifb: Fall back to cfb_fillrect() on 32-bit HCRX cards")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/stifb.c | 45 +++++++++++++++++++++++++++++++++++--
 1 file changed, 43 insertions(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/stifb.c b/drivers/video/fbdev/stifb.c
index b0470f4f595e..7753e586e65a 100644
--- a/drivers/video/fbdev/stifb.c
+++ b/drivers/video/fbdev/stifb.c
@@ -1041,6 +1041,47 @@ stifb_copyarea(struct fb_info *info, const struct fb_copyarea *area)
 	SETUP_FB(fb);
 }
 
+#define ARTIST_VRAM_SIZE			0x000804
+#define ARTIST_VRAM_SRC				0x000808
+#define ARTIST_VRAM_SIZE_TRIGGER_WINFILL	0x000a04
+#define ARTIST_VRAM_DEST_TRIGGER_BLOCKMOVE	0x000b00
+#define ARTIST_SRC_BM_ACCESS			0x018008
+#define ARTIST_FGCOLOR				0x018010
+#define ARTIST_BGCOLOR				0x018014
+#define ARTIST_BITMAP_OP			0x01801c
+
+static void
+stifb_fillrect(struct fb_info *info, const struct fb_fillrect *rect)
+{
+	struct stifb_info *fb = container_of(info, struct stifb_info, info);
+
+	if (rect->rop != ROP_COPY)
+		return cfb_fillrect(info, rect);
+
+	SETUP_HW(fb);
+
+	if (fb->info.var.bits_per_pixel == 32) {
+		WRITE_WORD(0xBBA0A000, fb, REG_10);
+
+		NGLE_REALLY_SET_IMAGE_PLANEMASK(fb, 0xffffffff);
+	} else {
+		WRITE_WORD(fb->id == S9000_ID_HCRX ? 0x13a02000 : 0x13a01000, fb, REG_10);
+
+		NGLE_REALLY_SET_IMAGE_PLANEMASK(fb, 0xff);
+	}
+
+	WRITE_WORD(0x03000300, fb, ARTIST_BITMAP_OP);
+	WRITE_WORD(0x2ea01000, fb, ARTIST_SRC_BM_ACCESS);
+	NGLE_QUICK_SET_DST_BM_ACCESS(fb, 0x2ea01000);
+	NGLE_REALLY_SET_IMAGE_FG_COLOR(fb, rect->color);
+	WRITE_WORD(0, fb, ARTIST_BGCOLOR);
+
+	NGLE_SET_DSTXY(fb, (rect->dx << 16) | (rect->dy));
+	SET_LENXY_START_RECFILL(fb, (rect->width << 16) | (rect->height));
+
+	SETUP_FB(fb);
+}
+
 static void __init
 stifb_init_display(struct stifb_info *fb)
 {
@@ -1105,7 +1146,7 @@ static const struct fb_ops stifb_ops = {
 	.owner		= THIS_MODULE,
 	.fb_setcolreg	= stifb_setcolreg,
 	.fb_blank	= stifb_blank,
-	.fb_fillrect	= cfb_fillrect,
+	.fb_fillrect	= stifb_fillrect,
 	.fb_copyarea	= stifb_copyarea,
 	.fb_imageblit	= cfb_imageblit,
 };
@@ -1297,7 +1338,7 @@ static int __init stifb_init_fb(struct sti_struct *sti, int bpp_pref)
 		goto out_err0;
 	}
 	info->screen_size = fix->smem_len;
-	info->flags = FBINFO_DEFAULT | FBINFO_HWACCEL_COPYAREA;
+	info->flags = FBINFO_HWACCEL_COPYAREA | FBINFO_HWACCEL_FILLRECT;
 	info->pseudo_palette = &fb->pseudo_palette;
 
 	/* This has to be done !!! */
-- 
2.35.1



