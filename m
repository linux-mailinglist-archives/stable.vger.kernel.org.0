Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8924528B9C3
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 16:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbgJLOD3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 10:03:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:39220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730562AbgJLNgd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:36:33 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F5252087E;
        Mon, 12 Oct 2020 13:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602509792;
        bh=ian+zxc+942wa2VjMkKMsqgnSf/6GG5nIsuzRADA73I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VoN5p7owFpIA1W7uLBTrMwHuQmY3pQ0aEEm15+9xr0QlNoLDF4HpRl1ebLwGwUavb
         8WwsNiN29zUmyA9wfTNR8cGB4/fgrm8jzqu1PRUB1xcEG1yKVeQJWKQkeY9CvaSqaV
         ZXRwO9FOEwsPUD6gf/URH4D0NNchc0AoUnBBub6E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peilin Ye <yepeilin.cs@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 4.14 32/70] fbdev, newport_con: Move FONT_EXTRA_WORDS macros into linux/font.h
Date:   Mon, 12 Oct 2020 15:26:48 +0200
Message-Id: <20201012132631.724847804@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132630.201442517@linuxfoundation.org>
References: <20201012132630.201442517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peilin Ye <yepeilin.cs@gmail.com>

commit bb0890b4cd7f8203e3aa99c6d0f062d6acdaad27 upstream.

drivers/video/console/newport_con.c is borrowing FONT_EXTRA_WORDS macros
from drivers/video/fbdev/core/fbcon.h. To keep things simple, move all
definitions into <linux/font.h>.

Since newport_con now uses four extra words, initialize the fourth word in
newport_set_font() properly.

Cc: stable@vger.kernel.org
Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/7fb8bc9b0abc676ada6b7ac0e0bd443499357267.1600953813.git.yepeilin.cs@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/video/console/newport_con.c     |    7 +------
 drivers/video/fbdev/core/fbcon.h        |    7 -------
 drivers/video/fbdev/core/fbcon_rotate.c |    1 +
 drivers/video/fbdev/core/tileblit.c     |    1 +
 include/linux/font.h                    |    8 ++++++++
 5 files changed, 11 insertions(+), 13 deletions(-)

--- a/drivers/video/console/newport_con.c
+++ b/drivers/video/console/newport_con.c
@@ -35,12 +35,6 @@
 
 #define FONT_DATA ((unsigned char *)font_vga_8x16.data)
 
-/* borrowed from fbcon.c */
-#define REFCOUNT(fd)	(((int *)(fd))[-1])
-#define FNTSIZE(fd)	(((int *)(fd))[-2])
-#define FNTCHARCNT(fd)	(((int *)(fd))[-3])
-#define FONT_EXTRA_WORDS 3
-
 static unsigned char *font_data[MAX_NR_CONSOLES];
 
 static struct newport_regs *npregs;
@@ -522,6 +516,7 @@ static int newport_set_font(int unit, st
 	FNTSIZE(new_data) = size;
 	FNTCHARCNT(new_data) = op->charcount;
 	REFCOUNT(new_data) = 0;	/* usage counter */
+	FNTSUM(new_data) = 0;
 
 	p = new_data;
 	for (i = 0; i < op->charcount; i++) {
--- a/drivers/video/fbdev/core/fbcon.h
+++ b/drivers/video/fbdev/core/fbcon.h
@@ -151,13 +151,6 @@ static inline int attr_col_ec(int shift,
 #define attr_bgcol_ec(bgshift, vc, info) attr_col_ec(bgshift, vc, info, 0)
 #define attr_fgcol_ec(fgshift, vc, info) attr_col_ec(fgshift, vc, info, 1)
 
-/* Font */
-#define REFCOUNT(fd)	(((int *)(fd))[-1])
-#define FNTSIZE(fd)	(((int *)(fd))[-2])
-#define FNTCHARCNT(fd)	(((int *)(fd))[-3])
-#define FNTSUM(fd)	(((int *)(fd))[-4])
-#define FONT_EXTRA_WORDS 4
-
     /*
      *  Scroll Method
      */
--- a/drivers/video/fbdev/core/fbcon_rotate.c
+++ b/drivers/video/fbdev/core/fbcon_rotate.c
@@ -14,6 +14,7 @@
 #include <linux/fb.h>
 #include <linux/vt_kern.h>
 #include <linux/console.h>
+#include <linux/font.h>
 #include <asm/types.h>
 #include "fbcon.h"
 #include "fbcon_rotate.h"
--- a/drivers/video/fbdev/core/tileblit.c
+++ b/drivers/video/fbdev/core/tileblit.c
@@ -13,6 +13,7 @@
 #include <linux/fb.h>
 #include <linux/vt_kern.h>
 #include <linux/console.h>
+#include <linux/font.h>
 #include <asm/types.h>
 #include "fbcon.h"
 
--- a/include/linux/font.h
+++ b/include/linux/font.h
@@ -57,4 +57,12 @@ extern const struct font_desc *get_defau
 /* Max. length for the name of a predefined font */
 #define MAX_FONT_NAME	32
 
+/* Extra word getters */
+#define REFCOUNT(fd)	(((int *)(fd))[-1])
+#define FNTSIZE(fd)	(((int *)(fd))[-2])
+#define FNTCHARCNT(fd)	(((int *)(fd))[-3])
+#define FNTSUM(fd)	(((int *)(fd))[-4])
+
+#define FONT_EXTRA_WORDS 4
+
 #endif /* _VIDEO_FONT_H */


