Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3E5C411BDD
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345061AbhITRD1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:03:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:53956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343756AbhITRB1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:01:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77CCD6140D;
        Mon, 20 Sep 2021 16:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156789;
        bh=JoJnfJUhrHuuTFazKuu0Ypzikb0GMKaDZPZ1lsyY3es=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UVqbLd+4C1ya5F2QDwF2xOAxDo31u9heoqzz1muJFxu4ercLOk0vaBeoKMgFy0LXS
         svkyNfYlEevg0yGcOSa09xgi0GfraayBywg8oUzmWSPg7GmfGwpIXmCrzA9p2uSDm1
         YywYegoGT2M5ZV9aOZrG/+FK/sALtQY8WCsyi0jM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot <syzbot+04168c8063cfdde1db5e@syzkaller.appspotmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH 4.9 087/175] fbmem: dont allow too huge resolutions
Date:   Mon, 20 Sep 2021 18:42:16 +0200
Message-Id: <20210920163920.923900194@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163918.068823680@linuxfoundation.org>
References: <20210920163918.068823680@linuxfoundation.org>
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
@@ -32,6 +32,7 @@
 #include <linux/device.h>
 #include <linux/efi.h>
 #include <linux/fb.h>
+#include <linux/overflow.h>
 
 #include <asm/fb.h>
 
@@ -981,6 +982,7 @@ fb_set_var(struct fb_info *info, struct
 	if ((var->activate & FB_ACTIVATE_FORCE) ||
 	    memcmp(&info->var, var, sizeof(struct fb_var_screeninfo))) {
 		u32 activate = var->activate;
+		u32 unused;
 
 		/* When using FOURCC mode, make sure the red, green, blue and
 		 * transp fields are set to 0.
@@ -1005,6 +1007,11 @@ fb_set_var(struct fb_info *info, struct
 		if (var->xres < 8 || var->yres < 8)
 			return -EINVAL;
 
+		/* Too huge resolution causes multiplication overflow. */
+		if (check_mul_overflow(var->xres, var->yres, &unused) ||
+		    check_mul_overflow(var->xres_virtual, var->yres_virtual, &unused))
+			return -EINVAL;
+
 		ret = info->fbops->fb_check_var(var, info);
 
 		if (ret)


