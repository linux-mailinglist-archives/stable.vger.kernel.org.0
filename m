Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 483B628826
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389286AbfEWTWg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:22:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:60672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390503AbfEWTWg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:22:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F86421841;
        Thu, 23 May 2019 19:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639355;
        bh=a9UcbVbIAa9yFWsS81lStfkrnBa1VMhlC8V7xi8PUFQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dEi+6ED1DAVZcsk/Z8YpbRbU0dNNEev6iWz0S5mV49bHZOscadyt+em2pfjbhhDfN
         zVr6Hpd8CRrwtcp0NpJD4adgTMN3/oWlegbfR7pvsg+ctTQyPv0q5tvBbGk1O2ca/W
         iAy0NcJEdLv/MLi6BPz4QCP8iBMvr7dMzVAGiOas=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Bernie Thompson <bernie@plugable.com>,
        Ladislav Michl <ladis@linux-mips.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH 5.0 057/139] udlfb: introduce a rendering mutex
Date:   Thu, 23 May 2019 21:05:45 +0200
Message-Id: <20190523181728.109604911@linuxfoundation.org>
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

commit babc250e278eac7b0e671bdaedf833759b43bb78 upstream.

Rendering calls may be done simultaneously from the workqueue,
dlfb_ops_write, dlfb_ops_ioctl, dlfb_ops_set_par and dlfb_dpy_deferred_io.
The code is robust enough so that it won't crash on concurrent rendering.

However, concurrent rendering may cause display corruption if the same
pixel is simultaneously being rendered. In order to avoid this corruption,
this patch adds a mutex around the rendering calls.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: Bernie Thompson <bernie@plugable.com>
Cc: Ladislav Michl <ladis@linux-mips.org>
Cc: <stable@vger.kernel.org>
[b.zolnierkie: replace "dlfb:" with "uldfb:" in the patch summary]
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/video/fbdev/udlfb.c |   41 ++++++++++++++++++++++++++++++-----------
 include/video/udlfb.h       |    1 +
 2 files changed, 31 insertions(+), 11 deletions(-)

--- a/drivers/video/fbdev/udlfb.c
+++ b/drivers/video/fbdev/udlfb.c
@@ -596,7 +596,7 @@ static int dlfb_render_hline(struct dlfb
 
 static int dlfb_handle_damage(struct dlfb_data *dlfb, int x, int y, int width, int height)
 {
-	int i;
+	int i, ret;
 	char *cmd;
 	cycles_t start_cycles, end_cycles;
 	int bytes_sent = 0;
@@ -606,21 +606,29 @@ static int dlfb_handle_damage(struct dlf
 
 	start_cycles = get_cycles();
 
+	mutex_lock(&dlfb->render_mutex);
+
 	aligned_x = DL_ALIGN_DOWN(x, sizeof(unsigned long));
 	width = DL_ALIGN_UP(width + (x-aligned_x), sizeof(unsigned long));
 	x = aligned_x;
 
 	if ((width <= 0) ||
 	    (x + width > dlfb->info->var.xres) ||
-	    (y + height > dlfb->info->var.yres))
-		return -EINVAL;
+	    (y + height > dlfb->info->var.yres)) {
+		ret = -EINVAL;
+		goto unlock_ret;
+	}
 
-	if (!atomic_read(&dlfb->usb_active))
-		return 0;
+	if (!atomic_read(&dlfb->usb_active)) {
+		ret = 0;
+		goto unlock_ret;
+	}
 
 	urb = dlfb_get_urb(dlfb);
-	if (!urb)
-		return 0;
+	if (!urb) {
+		ret = 0;
+		goto unlock_ret;
+	}
 	cmd = urb->transfer_buffer;
 
 	for (i = y; i < y + height ; i++) {
@@ -654,7 +662,11 @@ error:
 		    >> 10)), /* Kcycles */
 		   &dlfb->cpu_kcycles_used);
 
-	return 0;
+	ret = 0;
+
+unlock_ret:
+	mutex_unlock(&dlfb->render_mutex);
+	return ret;
 }
 
 static void dlfb_init_damage(struct dlfb_data *dlfb)
@@ -782,17 +794,19 @@ static void dlfb_dpy_deferred_io(struct
 	int bytes_identical = 0;
 	int bytes_rendered = 0;
 
+	mutex_lock(&dlfb->render_mutex);
+
 	if (!fb_defio)
-		return;
+		goto unlock_ret;
 
 	if (!atomic_read(&dlfb->usb_active))
-		return;
+		goto unlock_ret;
 
 	start_cycles = get_cycles();
 
 	urb = dlfb_get_urb(dlfb);
 	if (!urb)
-		return;
+		goto unlock_ret;
 
 	cmd = urb->transfer_buffer;
 
@@ -825,6 +839,8 @@ error:
 	atomic_add(((unsigned int) ((end_cycles - start_cycles)
 		    >> 10)), /* Kcycles */
 		   &dlfb->cpu_kcycles_used);
+unlock_ret:
+	mutex_unlock(&dlfb->render_mutex);
 }
 
 static int dlfb_get_edid(struct dlfb_data *dlfb, char *edid, int len)
@@ -986,6 +1002,8 @@ static void dlfb_ops_destroy(struct fb_i
 
 	cancel_work_sync(&dlfb->damage_work);
 
+	mutex_destroy(&dlfb->render_mutex);
+
 	if (info->cmap.len != 0)
 		fb_dealloc_cmap(&info->cmap);
 	if (info->monspecs.modedb)
@@ -1682,6 +1700,7 @@ static int dlfb_usb_probe(struct usb_int
 	dlfb->ops = dlfb_ops;
 	info->fbops = &dlfb->ops;
 
+	mutex_init(&dlfb->render_mutex);
 	dlfb_init_damage(dlfb);
 	spin_lock_init(&dlfb->damage_lock);
 	INIT_WORK(&dlfb->damage_work, dlfb_damage_work);
--- a/include/video/udlfb.h
+++ b/include/video/udlfb.h
@@ -48,6 +48,7 @@ struct dlfb_data {
 	int base8;
 	u32 pseudo_palette[256];
 	int blank_mode; /*one of FB_BLANK_ */
+	struct mutex render_mutex;
 	int damage_x;
 	int damage_y;
 	int damage_x2;


