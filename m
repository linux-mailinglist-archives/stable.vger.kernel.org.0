Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0C875010FA
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 16:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245267AbiDNNsR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343956AbiDNNjc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:39:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 305DDA94E2;
        Thu, 14 Apr 2022 06:35:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1E9461D29;
        Thu, 14 Apr 2022 13:35:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA023C385A1;
        Thu, 14 Apr 2022 13:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943340;
        bh=zEeKefMZYRslSx40JLS5O+6+t08QoeqPa7ZuL/Iyqg4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L4QcMyCk6hluYj5p9hell/IKZFBGJ416D/UEGliKC1N/ysEouPCki+ZPOaTXx1dXW
         WcAwsBxDUu7TEIJiLsMio+l9m9u3eoNrsyAkM6M8mSFXGhwZWrOfbkIaOexDgDhhYo
         ZezwDQolHloEw6VS4HtefS0lP68iWVlo9U1FfFuY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 119/475] video: fbdev: fbcvt.c: fix printing in fb_cvt_print_name()
Date:   Thu, 14 Apr 2022 15:08:24 +0200
Message-Id: <20220414110858.482690346@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 78482af095abd9f4f29f1aa3fe575d25c6ae3028 ]

This code has two bugs:
1) "cnt" is 255 but the size of the buffer is 256 so the last byte is
   not used.
2) If we try to print more than 255 characters then "cnt" will be
   negative and that will trigger a WARN() in snprintf(). The fix for
   this is to use scnprintf() instead of snprintf().

We can re-write this code to be cleaner:
1) Rename "offset" to "off" because that's shorter.
2) Get rid of the "cnt" variable and just use "size - off" directly.
3) Get rid of the "read" variable and just increment "off" directly.

Fixes: 96fe6a2109db ("fbdev: Add VESA Coordinated Video Timings (CVT) support")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/core/fbcvt.c | 53 +++++++++++++-------------------
 1 file changed, 21 insertions(+), 32 deletions(-)

diff --git a/drivers/video/fbdev/core/fbcvt.c b/drivers/video/fbdev/core/fbcvt.c
index 55d2bd0ce5c0..64843464c661 100644
--- a/drivers/video/fbdev/core/fbcvt.c
+++ b/drivers/video/fbdev/core/fbcvt.c
@@ -214,9 +214,11 @@ static u32 fb_cvt_aspect_ratio(struct fb_cvt_data *cvt)
 static void fb_cvt_print_name(struct fb_cvt_data *cvt)
 {
 	u32 pixcount, pixcount_mod;
-	int cnt = 255, offset = 0, read = 0;
-	u8 *buf = kzalloc(256, GFP_KERNEL);
+	int size = 256;
+	int off = 0;
+	u8 *buf;
 
+	buf = kzalloc(size, GFP_KERNEL);
 	if (!buf)
 		return;
 
@@ -224,43 +226,30 @@ static void fb_cvt_print_name(struct fb_cvt_data *cvt)
 	pixcount_mod = (cvt->xres * (cvt->yres/cvt->interlace)) % 1000000;
 	pixcount_mod /= 1000;
 
-	read = snprintf(buf+offset, cnt, "fbcvt: %dx%d@%d: CVT Name - ",
-			cvt->xres, cvt->yres, cvt->refresh);
-	offset += read;
-	cnt -= read;
+	off += scnprintf(buf + off, size - off, "fbcvt: %dx%d@%d: CVT Name - ",
+			    cvt->xres, cvt->yres, cvt->refresh);
 
-	if (cvt->status)
-		snprintf(buf+offset, cnt, "Not a CVT standard - %d.%03d Mega "
-			 "Pixel Image\n", pixcount, pixcount_mod);
-	else {
-		if (pixcount) {
-			read = snprintf(buf+offset, cnt, "%d", pixcount);
-			cnt -= read;
-			offset += read;
-		}
+	if (cvt->status) {
+		off += scnprintf(buf + off, size - off,
+				 "Not a CVT standard - %d.%03d Mega Pixel Image\n",
+				 pixcount, pixcount_mod);
+	} else {
+		if (pixcount)
+			off += scnprintf(buf + off, size - off, "%d", pixcount);
 
-		read = snprintf(buf+offset, cnt, ".%03dM", pixcount_mod);
-		cnt -= read;
-		offset += read;
+		off += scnprintf(buf + off, size - off, ".%03dM", pixcount_mod);
 
 		if (cvt->aspect_ratio == 0)
-			read = snprintf(buf+offset, cnt, "3");
+			off += scnprintf(buf + off, size - off, "3");
 		else if (cvt->aspect_ratio == 3)
-			read = snprintf(buf+offset, cnt, "4");
+			off += scnprintf(buf + off, size - off, "4");
 		else if (cvt->aspect_ratio == 1 || cvt->aspect_ratio == 4)
-			read = snprintf(buf+offset, cnt, "9");
+			off += scnprintf(buf + off, size - off, "9");
 		else if (cvt->aspect_ratio == 2)
-			read = snprintf(buf+offset, cnt, "A");
-		else
-			read = 0;
-		cnt -= read;
-		offset += read;
-
-		if (cvt->flags & FB_CVT_FLAG_REDUCED_BLANK) {
-			read = snprintf(buf+offset, cnt, "-R");
-			cnt -= read;
-			offset += read;
-		}
+			off += scnprintf(buf + off, size - off, "A");
+
+		if (cvt->flags & FB_CVT_FLAG_REDUCED_BLANK)
+			off += scnprintf(buf + off, size - off, "-R");
 	}
 
 	printk(KERN_INFO "%s\n", buf);
-- 
2.34.1



