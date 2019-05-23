Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68EE0288D8
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391843AbfEWT3K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:29:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:42116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391416AbfEWT3I (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:29:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F4B3217D7;
        Thu, 23 May 2019 19:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639748;
        bh=eGjSZCeMlhs3mCdvp+rkNdXCGOMD6kWJsci1m1TlAcw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z9/ojJAzgr+icF4P/kgbUQrtYGistxrAkr5InlcJPWHgrX6bis4GnvxfH7M3QSRjX
         V9JlsQLJ/FSJEhD4ZJSX1gIw9C0u3zMigGstnm7GLY8Iy8AB84rXBRIf/YCGHTX/8n
         SJ8z3cQbgcRC+5y9aEwC4N4Jfb5HXIo/Fe9uLFbk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Bernie Thompson <bernie@plugable.com>,
        Ladislav Michl <ladis@linux-mips.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH 5.1 064/122] udlfb: fix sleeping inside spinlock
Date:   Thu, 23 May 2019 21:06:26 +0200
Message-Id: <20190523181713.201724775@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181705.091418060@linuxfoundation.org>
References: <20190523181705.091418060@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

commit 6b11f9d8433b471fdd3ebed232b43a4b723be6ff upstream.

If a framebuffer device is used as a console, the rendering calls
(copyarea, fillrect, imageblit) may be done with the console spinlock
held. On udlfb, these function call dlfb_handle_damage that takes a
blocking semaphore before acquiring an URB.

In order to fix the bug, this patch changes the calls copyarea, fillrect
and imageblit to offload USB work to a workqueue.

A side effect of this patch is 3x improvement in console scrolling speed
because the device doesn't have to be updated after each copyarea call.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: Bernie Thompson <bernie@plugable.com>
Cc: Ladislav Michl <ladis@linux-mips.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/video/fbdev/udlfb.c |   56 +++++++++++++++++++++++++++++++++++++++++---
 include/video/udlfb.h       |    6 ++++
 2 files changed, 59 insertions(+), 3 deletions(-)

--- a/drivers/video/fbdev/udlfb.c
+++ b/drivers/video/fbdev/udlfb.c
@@ -657,6 +657,50 @@ error:
 	return 0;
 }
 
+static void dlfb_init_damage(struct dlfb_data *dlfb)
+{
+	dlfb->damage_x = INT_MAX;
+	dlfb->damage_x2 = 0;
+	dlfb->damage_y = INT_MAX;
+	dlfb->damage_y2 = 0;
+}
+
+static void dlfb_damage_work(struct work_struct *w)
+{
+	struct dlfb_data *dlfb = container_of(w, struct dlfb_data, damage_work);
+	int x, x2, y, y2;
+
+	spin_lock_irq(&dlfb->damage_lock);
+	x = dlfb->damage_x;
+	x2 = dlfb->damage_x2;
+	y = dlfb->damage_y;
+	y2 = dlfb->damage_y2;
+	dlfb_init_damage(dlfb);
+	spin_unlock_irq(&dlfb->damage_lock);
+
+	if (x < x2 && y < y2)
+		dlfb_handle_damage(dlfb, x, y, x2 - x, y2 - y);
+}
+
+static void dlfb_offload_damage(struct dlfb_data *dlfb, int x, int y, int width, int height)
+{
+	unsigned long flags;
+	int x2 = x + width;
+	int y2 = y + height;
+
+	if (x >= x2 || y >= y2)
+		return;
+
+	spin_lock_irqsave(&dlfb->damage_lock, flags);
+	dlfb->damage_x = min(x, dlfb->damage_x);
+	dlfb->damage_x2 = max(x2, dlfb->damage_x2);
+	dlfb->damage_y = min(y, dlfb->damage_y);
+	dlfb->damage_y2 = max(y2, dlfb->damage_y2);
+	spin_unlock_irqrestore(&dlfb->damage_lock, flags);
+
+	schedule_work(&dlfb->damage_work);
+}
+
 /*
  * Path triggered by usermode clients who write to filesystem
  * e.g. cat filename > /dev/fb1
@@ -693,7 +737,7 @@ static void dlfb_ops_copyarea(struct fb_
 
 	sys_copyarea(info, area);
 
-	dlfb_handle_damage(dlfb, area->dx, area->dy,
+	dlfb_offload_damage(dlfb, area->dx, area->dy,
 			area->width, area->height);
 }
 
@@ -704,7 +748,7 @@ static void dlfb_ops_imageblit(struct fb
 
 	sys_imageblit(info, image);
 
-	dlfb_handle_damage(dlfb, image->dx, image->dy,
+	dlfb_offload_damage(dlfb, image->dx, image->dy,
 			image->width, image->height);
 }
 
@@ -715,7 +759,7 @@ static void dlfb_ops_fillrect(struct fb_
 
 	sys_fillrect(info, rect);
 
-	dlfb_handle_damage(dlfb, rect->dx, rect->dy, rect->width,
+	dlfb_offload_damage(dlfb, rect->dx, rect->dy, rect->width,
 			      rect->height);
 }
 
@@ -940,6 +984,8 @@ static void dlfb_ops_destroy(struct fb_i
 {
 	struct dlfb_data *dlfb = info->par;
 
+	cancel_work_sync(&dlfb->damage_work);
+
 	if (info->cmap.len != 0)
 		fb_dealloc_cmap(&info->cmap);
 	if (info->monspecs.modedb)
@@ -1636,6 +1682,10 @@ static int dlfb_usb_probe(struct usb_int
 	dlfb->ops = dlfb_ops;
 	info->fbops = &dlfb->ops;
 
+	dlfb_init_damage(dlfb);
+	spin_lock_init(&dlfb->damage_lock);
+	INIT_WORK(&dlfb->damage_work, dlfb_damage_work);
+
 	INIT_LIST_HEAD(&info->modelist);
 
 	if (!dlfb_alloc_urb_list(dlfb, WRITES_IN_FLIGHT, MAX_TRANSFER)) {
--- a/include/video/udlfb.h
+++ b/include/video/udlfb.h
@@ -48,6 +48,12 @@ struct dlfb_data {
 	int base8;
 	u32 pseudo_palette[256];
 	int blank_mode; /*one of FB_BLANK_ */
+	int damage_x;
+	int damage_y;
+	int damage_x2;
+	int damage_y2;
+	spinlock_t damage_lock;
+	struct work_struct damage_work;
 	struct fb_ops ops;
 	/* blit-only rendering path metrics, exposed through sysfs */
 	atomic_t bytes_rendered; /* raw pixel-bytes driver asked to render */


