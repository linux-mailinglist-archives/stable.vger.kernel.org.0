Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA26B4ABC10
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:45:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383384AbiBGLaN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:30:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383753AbiBGLXb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:23:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A9D4C0401CE;
        Mon,  7 Feb 2022 03:23:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE5436077B;
        Mon,  7 Feb 2022 11:23:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90E6AC004E1;
        Mon,  7 Feb 2022 11:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233006;
        bh=GR6H+ftY5linrJ930hL1g5iF836J1cG1GcMO7XjXECo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X+iGrM4Ddqn2fNW8AKbIMrpziza4dokLesqUh9yvbxmS4FVfKXanPDzrC/J+vXqng
         86t9c8h/lZuM5kllqzkfEpeUewuG97+yauMU0pBDTnVBr0uPsUixxGHeNsjDKCkUYB
         wH3O690KeiUZE8gwEk1kK0SXHZy2t3EwlfcaYfJk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 5.10 61/74] fbcon: Add option to enable legacy hardware acceleration
Date:   Mon,  7 Feb 2022 12:06:59 +0100
Message-Id: <20220207103759.228901949@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103757.232676988@linuxfoundation.org>
References: <20220207103757.232676988@linuxfoundation.org>
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

From: Helge Deller <deller@gmx.de>

commit a3f781a9d6114c1d1e01defb7aa234dec45d2a5f upstream.

Add a config option CONFIG_FRAMEBUFFER_CONSOLE_LEGACY_ACCELERATION to
enable bitblt and fillrect hardware acceleration in the framebuffer
console. If disabled, such acceleration will not be used, even if it is
supported by the graphics hardware driver.

If you plan to use DRM as your main graphics output system, you should
disable this option since it will prevent compiling in code which isn't
used later on when DRM takes over.

For all other configurations, e.g. if none of your graphic cards support
DRM (yet), DRM isn't available for your architecture, or you can't be
sure that the graphic card in the target system will support DRM, you
most likely want to enable this option.

In the non-accelerated case (e.g. when DRM is used), the inlined
fb_scrollmode() function is hardcoded to return SCROLL_REDRAW and as such the
compiler is able to optimize much unneccesary code away.

In this v3 patch version I additionally changed the GETVYRES() and GETVXRES()
macros to take a pointer to the fbcon_display struct. This fixes the build when
console rotation is enabled and helps the compiler again to optimize out code.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org # v5.10+
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20220202135531.92183-4-deller@gmx.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/console/Kconfig           |   20 ++++++++++++++++
 drivers/video/fbdev/core/fbcon.c        |   39 ++++++++++++++++++++++----------
 drivers/video/fbdev/core/fbcon.h        |   15 +++++++++++-
 drivers/video/fbdev/core/fbcon_ccw.c    |   10 ++++----
 drivers/video/fbdev/core/fbcon_cw.c     |   10 ++++----
 drivers/video/fbdev/core/fbcon_rotate.h |    4 +--
 drivers/video/fbdev/core/fbcon_ud.c     |   20 ++++++++--------
 7 files changed, 84 insertions(+), 34 deletions(-)

--- a/drivers/video/console/Kconfig
+++ b/drivers/video/console/Kconfig
@@ -78,6 +78,26 @@ config FRAMEBUFFER_CONSOLE
 	help
 	  Low-level framebuffer-based console driver.
 
+config FRAMEBUFFER_CONSOLE_LEGACY_ACCELERATION
+	bool "Enable legacy fbcon hardware acceleration code"
+	depends on FRAMEBUFFER_CONSOLE
+	default y if PARISC
+	default n
+	help
+	  This option enables the fbcon (framebuffer text-based) hardware
+	  acceleration for graphics drivers which were written for the fbdev
+	  graphics interface.
+
+	  On modern machines, on mainstream machines (like x86-64) or when
+	  using a modern Linux distribution those fbdev drivers usually aren't used.
+	  So enabling this option wouldn't have any effect, which is why you want
+	  to disable this option on such newer machines.
+
+	  If you compile this kernel for older machines which still require the
+	  fbdev drivers, you may want to say Y.
+
+	  If unsure, select n.
+
 config FRAMEBUFFER_CONSOLE_DETECT_PRIMARY
        bool "Map the console to the primary display device"
        depends on FRAMEBUFFER_CONSOLE
--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -1147,11 +1147,13 @@ static void fbcon_init(struct vc_data *v
 
 	ops->graphics = 0;
 
+#ifdef CONFIG_FRAMEBUFFER_CONSOLE_LEGACY_ACCELERATION
 	if ((cap & FBINFO_HWACCEL_COPYAREA) &&
 	    !(cap & FBINFO_HWACCEL_DISABLED))
 		p->scrollmode = SCROLL_MOVE;
 	else /* default to something safe */
 		p->scrollmode = SCROLL_REDRAW;
+#endif
 
 	/*
 	 *  ++guenther: console.c:vc_allocate() relies on initializing
@@ -1717,7 +1719,7 @@ static bool fbcon_scroll(struct vc_data
 			count = vc->vc_rows;
 		if (logo_shown >= 0)
 			goto redraw_up;
-		switch (p->scrollmode) {
+		switch (fb_scrollmode(p)) {
 		case SCROLL_MOVE:
 			fbcon_redraw_blit(vc, info, p, t, b - t - count,
 				     count);
@@ -1807,7 +1809,7 @@ static bool fbcon_scroll(struct vc_data
 			count = vc->vc_rows;
 		if (logo_shown >= 0)
 			goto redraw_down;
-		switch (p->scrollmode) {
+		switch (fb_scrollmode(p)) {
 		case SCROLL_MOVE:
 			fbcon_redraw_blit(vc, info, p, b - 1, b - t - count,
 				     -count);
@@ -1958,12 +1960,12 @@ static void fbcon_bmove_rec(struct vc_da
 		   height, width);
 }
 
-static void updatescrollmode(struct fbcon_display *p,
+static void updatescrollmode_accel(struct fbcon_display *p,
 					struct fb_info *info,
 					struct vc_data *vc)
 {
+#ifdef CONFIG_FRAMEBUFFER_CONSOLE_LEGACY_ACCELERATION
 	struct fbcon_ops *ops = info->fbcon_par;
-	int fh = vc->vc_font.height;
 	int cap = info->flags;
 	u16 t = 0;
 	int ypan = FBCON_SWAP(ops->rotate, info->fix.ypanstep,
@@ -1984,12 +1986,6 @@ static void updatescrollmode(struct fbco
 	int fast_imageblit = (cap & FBINFO_HWACCEL_IMAGEBLIT) &&
 		!(cap & FBINFO_HWACCEL_DISABLED);
 
-	p->vrows = vyres/fh;
-	if (yres > (fh * (vc->vc_rows + 1)))
-		p->vrows -= (yres - (fh * vc->vc_rows)) / fh;
-	if ((yres % fh) && (vyres % fh < yres % fh))
-		p->vrows--;
-
 	if (good_wrap || good_pan) {
 		if (reading_fast || fast_copyarea)
 			p->scrollmode = good_wrap ?
@@ -2003,6 +1999,27 @@ static void updatescrollmode(struct fbco
 		else
 			p->scrollmode = SCROLL_REDRAW;
 	}
+#endif
+}
+
+static void updatescrollmode(struct fbcon_display *p,
+					struct fb_info *info,
+					struct vc_data *vc)
+{
+	struct fbcon_ops *ops = info->fbcon_par;
+	int fh = vc->vc_font.height;
+	int yres = FBCON_SWAP(ops->rotate, info->var.yres, info->var.xres);
+	int vyres = FBCON_SWAP(ops->rotate, info->var.yres_virtual,
+				   info->var.xres_virtual);
+
+	p->vrows = vyres/fh;
+	if (yres > (fh * (vc->vc_rows + 1)))
+		p->vrows -= (yres - (fh * vc->vc_rows)) / fh;
+	if ((yres % fh) && (vyres % fh < yres % fh))
+		p->vrows--;
+
+	/* update scrollmode in case hardware acceleration is used */
+	updatescrollmode_accel(p, info, vc);
 }
 
 #define PITCH(w) (((w) + 7) >> 3)
@@ -2163,7 +2180,7 @@ static int fbcon_switch(struct vc_data *
 
 	updatescrollmode(p, info, vc);
 
-	switch (p->scrollmode) {
+	switch (fb_scrollmode(p)) {
 	case SCROLL_WRAP_MOVE:
 		scrollback_phys_max = p->vrows - vc->vc_rows;
 		break;
--- a/drivers/video/fbdev/core/fbcon.h
+++ b/drivers/video/fbdev/core/fbcon.h
@@ -29,7 +29,9 @@ struct fbcon_display {
     /* Filled in by the low-level console driver */
     const u_char *fontdata;
     int userfont;                   /* != 0 if fontdata kmalloc()ed */
-    u_short scrollmode;             /* Scroll Method */
+#ifdef CONFIG_FRAMEBUFFER_CONSOLE_LEGACY_ACCELERATION
+    u_short scrollmode;             /* Scroll Method, use fb_scrollmode() */
+#endif
     u_short inverse;                /* != 0 text black on white as default */
     short yscroll;                  /* Hardware scrolling */
     int vrows;                      /* number of virtual rows */
@@ -208,6 +210,17 @@ static inline int attr_col_ec(int shift,
 #define SCROLL_REDRAW	   0x004
 #define SCROLL_PAN_REDRAW  0x005
 
+static inline u_short fb_scrollmode(struct fbcon_display *fb)
+{
+#ifdef CONFIG_FRAMEBUFFER_CONSOLE_LEGACY_ACCELERATION
+	return fb->scrollmode;
+#else
+	/* hardcoded to SCROLL_REDRAW if acceleration was disabled. */
+	return SCROLL_REDRAW;
+#endif
+}
+
+
 #ifdef CONFIG_FB_TILEBLITTING
 extern void fbcon_set_tileops(struct vc_data *vc, struct fb_info *info);
 #endif
--- a/drivers/video/fbdev/core/fbcon_ccw.c
+++ b/drivers/video/fbdev/core/fbcon_ccw.c
@@ -65,7 +65,7 @@ static void ccw_bmove(struct vc_data *vc
 {
 	struct fbcon_ops *ops = info->fbcon_par;
 	struct fb_copyarea area;
-	u32 vyres = GETVYRES(ops->p->scrollmode, info);
+	u32 vyres = GETVYRES(ops->p, info);
 
 	area.sx = sy * vc->vc_font.height;
 	area.sy = vyres - ((sx + width) * vc->vc_font.width);
@@ -83,7 +83,7 @@ static void ccw_clear(struct vc_data *vc
 	struct fbcon_ops *ops = info->fbcon_par;
 	struct fb_fillrect region;
 	int bgshift = (vc->vc_hi_font_mask) ? 13 : 12;
-	u32 vyres = GETVYRES(ops->p->scrollmode, info);
+	u32 vyres = GETVYRES(ops->p, info);
 
 	region.color = attr_bgcol_ec(bgshift,vc,info);
 	region.dx = sy * vc->vc_font.height;
@@ -140,7 +140,7 @@ static void ccw_putcs(struct vc_data *vc
 	u32 cnt, pitch, size;
 	u32 attribute = get_attribute(info, scr_readw(s));
 	u8 *dst, *buf = NULL;
-	u32 vyres = GETVYRES(ops->p->scrollmode, info);
+	u32 vyres = GETVYRES(ops->p, info);
 
 	if (!ops->fontbuffer)
 		return;
@@ -229,7 +229,7 @@ static void ccw_cursor(struct vc_data *v
 	int attribute, use_sw = vc->vc_cursor_type & CUR_SW;
 	int err = 1, dx, dy;
 	char *src;
-	u32 vyres = GETVYRES(ops->p->scrollmode, info);
+	u32 vyres = GETVYRES(ops->p, info);
 
 	if (!ops->fontbuffer)
 		return;
@@ -387,7 +387,7 @@ static int ccw_update_start(struct fb_in
 {
 	struct fbcon_ops *ops = info->fbcon_par;
 	u32 yoffset;
-	u32 vyres = GETVYRES(ops->p->scrollmode, info);
+	u32 vyres = GETVYRES(ops->p, info);
 	int err;
 
 	yoffset = (vyres - info->var.yres) - ops->var.xoffset;
--- a/drivers/video/fbdev/core/fbcon_cw.c
+++ b/drivers/video/fbdev/core/fbcon_cw.c
@@ -50,7 +50,7 @@ static void cw_bmove(struct vc_data *vc,
 {
 	struct fbcon_ops *ops = info->fbcon_par;
 	struct fb_copyarea area;
-	u32 vxres = GETVXRES(ops->p->scrollmode, info);
+	u32 vxres = GETVXRES(ops->p, info);
 
 	area.sx = vxres - ((sy + height) * vc->vc_font.height);
 	area.sy = sx * vc->vc_font.width;
@@ -68,7 +68,7 @@ static void cw_clear(struct vc_data *vc,
 	struct fbcon_ops *ops = info->fbcon_par;
 	struct fb_fillrect region;
 	int bgshift = (vc->vc_hi_font_mask) ? 13 : 12;
-	u32 vxres = GETVXRES(ops->p->scrollmode, info);
+	u32 vxres = GETVXRES(ops->p, info);
 
 	region.color = attr_bgcol_ec(bgshift,vc,info);
 	region.dx = vxres - ((sy + height) * vc->vc_font.height);
@@ -125,7 +125,7 @@ static void cw_putcs(struct vc_data *vc,
 	u32 cnt, pitch, size;
 	u32 attribute = get_attribute(info, scr_readw(s));
 	u8 *dst, *buf = NULL;
-	u32 vxres = GETVXRES(ops->p->scrollmode, info);
+	u32 vxres = GETVXRES(ops->p, info);
 
 	if (!ops->fontbuffer)
 		return;
@@ -212,7 +212,7 @@ static void cw_cursor(struct vc_data *vc
 	int attribute, use_sw = vc->vc_cursor_type & CUR_SW;
 	int err = 1, dx, dy;
 	char *src;
-	u32 vxres = GETVXRES(ops->p->scrollmode, info);
+	u32 vxres = GETVXRES(ops->p, info);
 
 	if (!ops->fontbuffer)
 		return;
@@ -369,7 +369,7 @@ static void cw_cursor(struct vc_data *vc
 static int cw_update_start(struct fb_info *info)
 {
 	struct fbcon_ops *ops = info->fbcon_par;
-	u32 vxres = GETVXRES(ops->p->scrollmode, info);
+	u32 vxres = GETVXRES(ops->p, info);
 	u32 xoffset;
 	int err;
 
--- a/drivers/video/fbdev/core/fbcon_rotate.h
+++ b/drivers/video/fbdev/core/fbcon_rotate.h
@@ -12,11 +12,11 @@
 #define _FBCON_ROTATE_H
 
 #define GETVYRES(s,i) ({                           \
-        (s == SCROLL_REDRAW || s == SCROLL_MOVE) ? \
+        (fb_scrollmode(s) == SCROLL_REDRAW || fb_scrollmode(s) == SCROLL_MOVE) ? \
         (i)->var.yres : (i)->var.yres_virtual; })
 
 #define GETVXRES(s,i) ({                           \
-        (s == SCROLL_REDRAW || s == SCROLL_MOVE || !(i)->fix.xpanstep) ? \
+        (fb_scrollmode(s) == SCROLL_REDRAW || fb_scrollmode(s) == SCROLL_MOVE || !(i)->fix.xpanstep) ? \
         (i)->var.xres : (i)->var.xres_virtual; })
 
 
--- a/drivers/video/fbdev/core/fbcon_ud.c
+++ b/drivers/video/fbdev/core/fbcon_ud.c
@@ -50,8 +50,8 @@ static void ud_bmove(struct vc_data *vc,
 {
 	struct fbcon_ops *ops = info->fbcon_par;
 	struct fb_copyarea area;
-	u32 vyres = GETVYRES(ops->p->scrollmode, info);
-	u32 vxres = GETVXRES(ops->p->scrollmode, info);
+	u32 vyres = GETVYRES(ops->p, info);
+	u32 vxres = GETVXRES(ops->p, info);
 
 	area.sy = vyres - ((sy + height) * vc->vc_font.height);
 	area.sx = vxres - ((sx + width) * vc->vc_font.width);
@@ -69,8 +69,8 @@ static void ud_clear(struct vc_data *vc,
 	struct fbcon_ops *ops = info->fbcon_par;
 	struct fb_fillrect region;
 	int bgshift = (vc->vc_hi_font_mask) ? 13 : 12;
-	u32 vyres = GETVYRES(ops->p->scrollmode, info);
-	u32 vxres = GETVXRES(ops->p->scrollmode, info);
+	u32 vyres = GETVYRES(ops->p, info);
+	u32 vxres = GETVXRES(ops->p, info);
 
 	region.color = attr_bgcol_ec(bgshift,vc,info);
 	region.dy = vyres - ((sy + height) * vc->vc_font.height);
@@ -162,8 +162,8 @@ static void ud_putcs(struct vc_data *vc,
 	u32 mod = vc->vc_font.width % 8, cnt, pitch, size;
 	u32 attribute = get_attribute(info, scr_readw(s));
 	u8 *dst, *buf = NULL;
-	u32 vyres = GETVYRES(ops->p->scrollmode, info);
-	u32 vxres = GETVXRES(ops->p->scrollmode, info);
+	u32 vyres = GETVYRES(ops->p, info);
+	u32 vxres = GETVXRES(ops->p, info);
 
 	if (!ops->fontbuffer)
 		return;
@@ -259,8 +259,8 @@ static void ud_cursor(struct vc_data *vc
 	int attribute, use_sw = vc->vc_cursor_type & CUR_SW;
 	int err = 1, dx, dy;
 	char *src;
-	u32 vyres = GETVYRES(ops->p->scrollmode, info);
-	u32 vxres = GETVXRES(ops->p->scrollmode, info);
+	u32 vyres = GETVYRES(ops->p, info);
+	u32 vxres = GETVXRES(ops->p, info);
 
 	if (!ops->fontbuffer)
 		return;
@@ -410,8 +410,8 @@ static int ud_update_start(struct fb_inf
 {
 	struct fbcon_ops *ops = info->fbcon_par;
 	int xoffset, yoffset;
-	u32 vyres = GETVYRES(ops->p->scrollmode, info);
-	u32 vxres = GETVXRES(ops->p->scrollmode, info);
+	u32 vyres = GETVYRES(ops->p, info);
+	u32 vxres = GETVXRES(ops->p, info);
 	int err;
 
 	xoffset = vxres - info->var.xres - ops->var.xoffset;


