Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E92664F27AA
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233514AbiDEIHy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:07:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234899AbiDEH7D (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:59:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51770E094;
        Tue,  5 Apr 2022 00:53:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D6CBB81BAF;
        Tue,  5 Apr 2022 07:53:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF488C340EE;
        Tue,  5 Apr 2022 07:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145201;
        bh=zEeKefMZYRslSx40JLS5O+6+t08QoeqPa7ZuL/Iyqg4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U/C3R/o9zsgn5VKBMfkfq65/ar2+WqOhIPAJx59dHD8H2zYbU8CxEqS9ADGMh7mtX
         efQaaXDQIYrDRLMnSjtKyh8O+qX7LcDtm3wgsoZac0pQqBadzyhWqONc+szHsUHcA0
         eZdeE8u3yQdSpfozk7MQR/G5ylP8F6XJlvagY+ow=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0321/1126] video: fbdev: fbcvt.c: fix printing in fb_cvt_print_name()
Date:   Tue,  5 Apr 2022 09:17:48 +0200
Message-Id: <20220405070417.037970983@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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



