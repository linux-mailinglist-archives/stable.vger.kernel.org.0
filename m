Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B616287B6
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389913AbfEWTWd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:22:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:60516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389861AbfEWTWa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:22:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 126632133D;
        Thu, 23 May 2019 19:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639349;
        bh=bRt5aQ02+ZCB3U16y6YlI6tuHQ0IH4I6lTxjjEgaPq4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yc/biC5yJRfP//qvy813BNWHKIJgtWQBQuocbMnGKC75+sw0U3XCUD+e22Uv5seIa
         MOGCL2NaF4WM6tPfvGy5SdVSOEnjSiS2cJ7VTatFGFJefrSj7aZ0VcNcGGLYGp15JO
         OIaVc5PdG8AJLXRi+Ran6jTCMO0GjOtYGgYigkQA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Bernie Thompson <bernie@plugable.com>,
        Ladislav Michl <ladis@linux-mips.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH 5.0 055/139] udlfb: delete the unused parameter for dlfb_handle_damage
Date:   Thu, 23 May 2019 21:05:43 +0200
Message-Id: <20190523181727.806500916@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181720.120897565@linuxfoundation.org>
References: <20190523181720.120897565@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

commit bd86b6c5c60711dbd4fa21bdb497a188ecb6cf63 upstream.

Remove the unused parameter "data" and unused variable "ret".

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: Bernie Thompson <bernie@plugable.com>
Cc: Ladislav Michl <ladis@linux-mips.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/video/fbdev/udlfb.c |   21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

--- a/drivers/video/fbdev/udlfb.c
+++ b/drivers/video/fbdev/udlfb.c
@@ -594,10 +594,9 @@ static int dlfb_render_hline(struct dlfb
 	return 0;
 }
 
-static int dlfb_handle_damage(struct dlfb_data *dlfb, int x, int y,
-	       int width, int height, char *data)
+static int dlfb_handle_damage(struct dlfb_data *dlfb, int x, int y, int width, int height)
 {
-	int i, ret;
+	int i;
 	char *cmd;
 	cycles_t start_cycles, end_cycles;
 	int bytes_sent = 0;
@@ -641,7 +640,7 @@ static int dlfb_handle_damage(struct dlf
 			*cmd++ = 0xAF;
 		/* Send partial buffer remaining before exiting */
 		len = cmd - (char *) urb->transfer_buffer;
-		ret = dlfb_submit_urb(dlfb, urb, len);
+		dlfb_submit_urb(dlfb, urb, len);
 		bytes_sent += len;
 	} else
 		dlfb_urb_completion(urb);
@@ -679,7 +678,7 @@ static ssize_t dlfb_ops_write(struct fb_
 				(u32)info->var.yres);
 
 		dlfb_handle_damage(dlfb, 0, start, info->var.xres,
-			lines, info->screen_base);
+			lines);
 	}
 
 	return result;
@@ -695,7 +694,7 @@ static void dlfb_ops_copyarea(struct fb_
 	sys_copyarea(info, area);
 
 	dlfb_handle_damage(dlfb, area->dx, area->dy,
-			area->width, area->height, info->screen_base);
+			area->width, area->height);
 }
 
 static void dlfb_ops_imageblit(struct fb_info *info,
@@ -706,7 +705,7 @@ static void dlfb_ops_imageblit(struct fb
 	sys_imageblit(info, image);
 
 	dlfb_handle_damage(dlfb, image->dx, image->dy,
-			image->width, image->height, info->screen_base);
+			image->width, image->height);
 }
 
 static void dlfb_ops_fillrect(struct fb_info *info,
@@ -717,7 +716,7 @@ static void dlfb_ops_fillrect(struct fb_
 	sys_fillrect(info, rect);
 
 	dlfb_handle_damage(dlfb, rect->dx, rect->dy, rect->width,
-			      rect->height, info->screen_base);
+			      rect->height);
 }
 
 /*
@@ -859,8 +858,7 @@ static int dlfb_ops_ioctl(struct fb_info
 		if (area.y > info->var.yres)
 			area.y = info->var.yres;
 
-		dlfb_handle_damage(dlfb, area.x, area.y, area.w, area.h,
-			   info->screen_base);
+		dlfb_handle_damage(dlfb, area.x, area.y, area.w, area.h);
 	}
 
 	return 0;
@@ -1065,8 +1063,7 @@ static int dlfb_ops_set_par(struct fb_in
 			pix_framebuffer[i] = 0x37e6;
 	}
 
-	dlfb_handle_damage(dlfb, 0, 0, info->var.xres, info->var.yres,
-			   info->screen_base);
+	dlfb_handle_damage(dlfb, 0, 0, info->var.xres, info->var.yres);
 
 	return 0;
 }


