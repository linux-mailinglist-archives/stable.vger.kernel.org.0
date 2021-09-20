Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D483411D7A
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347048AbhITRUw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:20:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:46334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348354AbhITRSu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:18:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BCB20613D1;
        Mon, 20 Sep 2021 16:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157196;
        bh=K0a0OxK+BpIgYpUkTtJGCGeftmPam2ydRSt3zkLoLZs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bN1nQ7chBobJQNLEpwqi7pRrv20wkYX0TWZWMctXMHIc0262BhWH8aTuUlnhpQHrc
         qK0p5OqCbuUPBEeJRWM1veMjzA9Yp0EeF5quF21gmSHu3ofV66R9PxJfoUawn2xN1I
         H05eT+Sb7xXS1YzQ8d522r/fkgGd7+eKlDD1HIzE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot <syzbot+04168c8063cfdde1db5e@syzkaller.appspotmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH 4.14 097/217] fbmem: dont allow too huge resolutions
Date:   Mon, 20 Sep 2021 18:41:58 +0200
Message-Id: <20210920163927.924664877@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163924.591371269@linuxfoundation.org>
References: <20210920163924.591371269@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>

commit 8c28051cdcbe9dfcec6bd0a4709d67a09df6edae upstream.

syzbot is reporting page fault at vga16fb_fillrect() [1], for
vga16fb_check_var() is failing to detect multiplication overflow.

  if (vxres * vyres > maxmem) {
    vyres = maxmem / vxres;
    if (vyres < yres)
      return -ENOMEM;
  }

Since no module would accept too huge resolutions where multiplication
overflow happens, let's reject in the common path.

Link: https://syzkaller.appspot.com/bug?extid=04168c8063cfdde1db5e [1]
Reported-by: syzbot <syzbot+04168c8063cfdde1db5e@syzkaller.appspotmail.com>
Debugged-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/185175d6-227a-7b55-433d-b070929b262c@i-love.sakura.ne.jp
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/core/fbmem.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/video/fbdev/core/fbmem.c
+++ b/drivers/video/fbdev/core/fbmem.c
@@ -34,6 +34,7 @@
 #include <linux/fb.h>
 #include <linux/fbcon.h>
 #include <linux/mem_encrypt.h>
+#include <linux/overflow.h>
 
 #include <asm/fb.h>
 
@@ -983,6 +984,7 @@ fb_set_var(struct fb_info *info, struct
 	if ((var->activate & FB_ACTIVATE_FORCE) ||
 	    memcmp(&info->var, var, sizeof(struct fb_var_screeninfo))) {
 		u32 activate = var->activate;
+		u32 unused;
 
 		/* When using FOURCC mode, make sure the red, green, blue and
 		 * transp fields are set to 0.
@@ -1007,6 +1009,11 @@ fb_set_var(struct fb_info *info, struct
 		if (var->xres < 8 || var->yres < 8)
 			return -EINVAL;
 
+		/* Too huge resolution causes multiplication overflow. */
+		if (check_mul_overflow(var->xres, var->yres, &unused) ||
+		    check_mul_overflow(var->xres_virtual, var->yres_virtual, &unused))
+			return -EINVAL;
+
 		ret = info->fbops->fb_check_var(var, info);
 
 		if (ret)


