Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72A956C1978
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:33:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233148AbjCTPd4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:33:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233122AbjCTPdb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:33:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D765A3647C
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:26:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62D27B80EC5
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:26:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF274C4339B;
        Mon, 20 Mar 2023 15:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325981;
        bh=v81g5Ju93yPkz3l72tZo5MVgoURquqy4Asl0YshQPVI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S3KvYiH3+GYO/Q+/+PaW0wZ1beX97O4KQKPnm2eeKdWFpC/Cs9Bzh473QmluQQ38D
         N7JT56ys+yaTFNozdzJqnTy1SZ/U/v6B+pMtR7rfp2i2nH9h0vY+4MbfAXF5wNk+kM
         YSwbgz/zl6moxBlRuxs6keZMUewAURXo9bwUjOiw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Helge Deller <deller@gmx.de>
Subject: [PATCH 6.1 178/198] fbdev: stifb: Provide valid pixelclock and add fb_check_var() checks
Date:   Mon, 20 Mar 2023 15:55:16 +0100
Message-Id: <20230320145514.952107318@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
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

commit 203873a535d627c668f293be0cb73e26c30f9cc7 upstream.

Find a valid modeline depending on the machine graphic card
configuration and add the fb_check_var() function to validate
Xorg provided graphics settings.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/stifb.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

--- a/drivers/video/fbdev/stifb.c
+++ b/drivers/video/fbdev/stifb.c
@@ -922,6 +922,28 @@ SETUP_HCRX(struct stifb_info *fb)
 /* ------------------- driver specific functions --------------------------- */
 
 static int
+stifb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
+{
+	struct stifb_info *fb = container_of(info, struct stifb_info, info);
+
+	if (var->xres != fb->info.var.xres ||
+	    var->yres != fb->info.var.yres ||
+	    var->bits_per_pixel != fb->info.var.bits_per_pixel)
+		return -EINVAL;
+
+	var->xres_virtual = var->xres;
+	var->yres_virtual = var->yres;
+	var->xoffset = 0;
+	var->yoffset = 0;
+	var->grayscale = fb->info.var.grayscale;
+	var->red.length = fb->info.var.red.length;
+	var->green.length = fb->info.var.green.length;
+	var->blue.length = fb->info.var.blue.length;
+
+	return 0;
+}
+
+static int
 stifb_setcolreg(u_int regno, u_int red, u_int green,
 	      u_int blue, u_int transp, struct fb_info *info)
 {
@@ -1145,6 +1167,7 @@ stifb_init_display(struct stifb_info *fb
 
 static const struct fb_ops stifb_ops = {
 	.owner		= THIS_MODULE,
+	.fb_check_var	= stifb_check_var,
 	.fb_setcolreg	= stifb_setcolreg,
 	.fb_blank	= stifb_blank,
 	.fb_fillrect	= stifb_fillrect,
@@ -1164,6 +1187,7 @@ static int __init stifb_init_fb(struct s
 	struct stifb_info *fb;
 	struct fb_info *info;
 	unsigned long sti_rom_address;
+	char modestr[32];
 	char *dev_name;
 	int bpp, xres, yres;
 
@@ -1342,6 +1366,9 @@ static int __init stifb_init_fb(struct s
 	info->flags = FBINFO_HWACCEL_COPYAREA | FBINFO_HWACCEL_FILLRECT;
 	info->pseudo_palette = &fb->pseudo_palette;
 
+	scnprintf(modestr, sizeof(modestr), "%dx%d-%d", xres, yres, bpp);
+	fb_find_mode(&info->var, info, modestr, NULL, 0, NULL, bpp);
+
 	/* This has to be done !!! */
 	if (fb_alloc_cmap(&info->cmap, NR_PALETTE, 0))
 		goto out_err1;


