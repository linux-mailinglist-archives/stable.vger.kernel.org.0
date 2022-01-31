Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF3EE4A50D2
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 22:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379568AbiAaVGq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 16:06:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379546AbiAaVGj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 16:06:39 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 702A6C061714
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 13:06:38 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id m14so27679546wrg.12
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 13:06:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9fqlEl5FrV6kXAQC/GZqlLwA2XdAQw5mGx02dUfQyG8=;
        b=VVhyGNyp2pNzByagiAchpIT0TdYXQJYBqI6Tj+98mGiUnBiYlrikTw1HMgQurEBYgJ
         k7OFmH40lEG4+klF8jn739hTAlJJuI02RekLiRa4mJzUuWA4nG+TJ1CDh7NoB2CDbrFl
         lZ3Dfl5UkvYNoa0R8IdO/bpfKd+FzZ8+pTmvg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9fqlEl5FrV6kXAQC/GZqlLwA2XdAQw5mGx02dUfQyG8=;
        b=YGZs2jddib0zgChyDmPFsp7xFjsIyZupdefOJ4fe+j1uQqk2W12UsPyCCWkmFbrgBC
         /kTM4WRUaEvSTfzvZ74R23yKBYErKLoXRyAJAq9ZjcvLMFZr0FickcDuOKF9pzs63N27
         eBSLGqyZ+CR/Qjs11Th4W5F6dOQtwL7P+40Dyq4BJDks1ClRvI/Y9lSEDtmAptglj+ta
         MdHGEf4lGZ0HnsA3KlR2bgBWhyr5jGWoF0UdZKYt7g7TSRwc1k0sEtPrXFnSgP4F/Fsi
         u4ydSbigjs+rqh2F26yDw/GEyBKVjWCyV8caX4suR3P6qJ03OuxvjyyaIMiiu1n4Pn98
         UP1w==
X-Gm-Message-State: AOAM530n8DtnLEj3JKA2JWDt0WvUQAVESa0WifSuuqchIX2UZcWS6bv4
        HiHHLDI9eCbAL5lgeMaRvzSmhA==
X-Google-Smtp-Source: ABdhPJwhhRMCDydJRHK91UdopQ+RbUoVBpBpykMV1ybTBNYtKvX6zza63AUoOvl1/pJlEVkeQlw0Jg==
X-Received: by 2002:a05:6000:1ac8:: with SMTP id i8mr19547319wry.542.1643663196898;
        Mon, 31 Jan 2022 13:06:36 -0800 (PST)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id b11sm314961wmq.46.2022.01.31.13.06.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jan 2022 13:06:36 -0800 (PST)
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
To:     DRI Development <dri-devel@lists.freedesktop.org>
Cc:     Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        linux-fbdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Claudio Suarez <cssk@net-c.es>, stable@vger.kernel.org,
        Dave Airlie <airlied@gmail.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Pavel Machek <pavel@ucw.cz>, Sam Ravnborg <sam@ravnborg.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Sven Schnelle <svens@stackframe.org>,
        Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH 02/21] fbcon: Resurrect fbcon accelerated scrolling code
Date:   Mon, 31 Jan 2022 22:05:33 +0100
Message-Id: <20220131210552.482606-3-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220131210552.482606-1-daniel.vetter@ffwll.ch>
References: <20220131210552.482606-1-daniel.vetter@ffwll.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit b3ec8cdf457e ("fbdev: Garbage collect fbdev
scrolling acceleration, part 1 (from TODO list)"), but with a twist:

Because distros like fedora&suse (probably more) really want to move
away from fbcon as much as possible, and don't have a need for fancy
accelerated fbcon even less, hide the code behind an option.

There's also been noises about resurrecting the scrollback code and
other pieces, so there's plenty of need for such an option it seems.

Compared to direct revert I did move functions around a bit so they're
all in one block, to minimize the number of #ifdef.

I also tried to stuff this all into a separate file, but that didn't
really look much better. I also considered duplicating fbcon_scroll()
since that's a bit meh now, but again didn't seem worth the trouble.
Maybe when we resurect more code.

And finally to shut up unused parameter warnings warnings the macros
became static inline.

References: https://lore.kernel.org/dri-devel/feea8303-2b83-fc36-972c-4fc8ad723bde@gmx.de/
Fixes: b3ec8cdf457e ("fbdev: Garbage collect fbdev scrolling acceleration, part 1 (from TODO list)")
Cc: Claudio Suarez <cssk@net-c.es>
Cc: <stable@vger.kernel.org> # v5.16+
Cc: Dave Airlie <airlied@gmail.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Fbdev development list <linux-fbdev@vger.kernel.org>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Javier Martinez Canillas <javierm@redhat.com>
Cc: DRI Development <dri-devel@lists.freedesktop.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Claudio Suarez <cssk@net-c.es>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Daniel Vetter <daniel.vetter@intel.com>
Cc: Sven Schnelle <svens@stackframe.org>
Cc: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
---
 Documentation/gpu/todo.rst              |  13 +-
 drivers/video/console/Kconfig           |  11 +
 drivers/video/fbdev/core/bitblit.c      |  16 +
 drivers/video/fbdev/core/fbcon.c        | 491 +++++++++++++++++++++++-
 drivers/video/fbdev/core/fbcon.h        |  59 +++
 drivers/video/fbdev/core/fbcon_ccw.c    |  28 +-
 drivers/video/fbdev/core/fbcon_cw.c     |  28 +-
 drivers/video/fbdev/core/fbcon_rotate.h |  21 +
 drivers/video/fbdev/core/fbcon_ud.c     |  37 +-
 drivers/video/fbdev/core/tileblit.c     |  16 +
 drivers/video/fbdev/skeletonfb.c        |  12 +-
 include/linux/fb.h                      |   2 +-
 12 files changed, 701 insertions(+), 33 deletions(-)

diff --git a/Documentation/gpu/todo.rst b/Documentation/gpu/todo.rst
index da138dd39883..29506815d24a 100644
--- a/Documentation/gpu/todo.rst
+++ b/Documentation/gpu/todo.rst
@@ -303,19 +303,16 @@ Level: Advanced
 Garbage collect fbdev scrolling acceleration
 --------------------------------------------
 
-Scroll acceleration has been disabled in fbcon. Now it works as the old
-SCROLL_REDRAW mode. A ton of code was removed in fbcon.c and the hook bmove was
-removed from fbcon_ops.
-Remaining tasks:
+Scroll acceleration is disabled in fbcon by hard-wiring p->scrollmode =
+SCROLL_REDRAW. There's a ton of code this will allow us to remove:
 
-- a bunch of the hooks in fbcon_ops could be removed or simplified by calling
+- lots of code in fbcon.c
+
+- a bunch of the hooks in fbcon_ops, maybe the remaining hooks could be called
   directly instead of the function table (with a switch on p->rotate)
 
 - fb_copyarea is unused after this, and can be deleted from all drivers
 
-- after that, fb_copyarea can be deleted from fb_ops in include/linux/fb.h as
-  well as cfb_copyarea
-
 Note that not all acceleration code can be deleted, since clearing and cursor
 support is still accelerated, which might be good candidates for further
 deletion projects.
diff --git a/drivers/video/console/Kconfig b/drivers/video/console/Kconfig
index 840d9813b0bc..f83f5c755084 100644
--- a/drivers/video/console/Kconfig
+++ b/drivers/video/console/Kconfig
@@ -78,6 +78,17 @@ config FRAMEBUFFER_CONSOLE
 	help
 	  Low-level framebuffer-based console driver.
 
+config FRAMEBUFFER_CONSOLE_LEGACY_ACCELERATION
+       bool "Enable legacy fbcon code for hw acceleration"
+       depends on FRAMEBUFFER_CONSOLE
+       default n
+	help
+	 Only enable this options if you are in full control of machine since
+	 the fbcon acceleration code is essentially unmaintained and known
+	 problematic.
+
+	 If unsure, select n.
+
 config FRAMEBUFFER_CONSOLE_DETECT_PRIMARY
        bool "Map the console to the primary display device"
        depends on FRAMEBUFFER_CONSOLE
diff --git a/drivers/video/fbdev/core/bitblit.c b/drivers/video/fbdev/core/bitblit.c
index 01fae2c96965..f98e8f298bc1 100644
--- a/drivers/video/fbdev/core/bitblit.c
+++ b/drivers/video/fbdev/core/bitblit.c
@@ -43,6 +43,21 @@ static void update_attr(u8 *dst, u8 *src, int attribute,
 	}
 }
 
+static void bit_bmove(struct vc_data *vc, struct fb_info *info, int sy,
+		      int sx, int dy, int dx, int height, int width)
+{
+	struct fb_copyarea area;
+
+	area.sx = sx * vc->vc_font.width;
+	area.sy = sy * vc->vc_font.height;
+	area.dx = dx * vc->vc_font.width;
+	area.dy = dy * vc->vc_font.height;
+	area.height = height * vc->vc_font.height;
+	area.width = width * vc->vc_font.width;
+
+	info->fbops->fb_copyarea(info, &area);
+}
+
 static void bit_clear(struct vc_data *vc, struct fb_info *info, int sy,
 		      int sx, int height, int width)
 {
@@ -378,6 +393,7 @@ static int bit_update_start(struct fb_info *info)
 
 void fbcon_set_bitops(struct fbcon_ops *ops)
 {
+	ops->bmove = bit_bmove;
 	ops->clear = bit_clear;
 	ops->putcs = bit_putcs;
 	ops->clear_margins = bit_clear_margins;
diff --git a/drivers/video/fbdev/core/fbcon.c b/drivers/video/fbdev/core/fbcon.c
index 99ecd9a6d844..2ff90061c7f3 100644
--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -1125,6 +1125,14 @@ static void fbcon_init(struct vc_data *vc, int init)
 
 	ops->graphics = 0;
 
+	/*
+	 * No more hw acceleration for fbcon.
+	 *
+	 * FIXME: Garbage collect all the now dead code after sufficient time
+	 * has passed.
+	 */
+	p->scrollmode = SCROLL_REDRAW;
+
 	/*
 	 *  ++guenther: console.c:vc_allocate() relies on initializing
 	 *  vc_{cols,rows}, but we must not set those if we are only
@@ -1211,13 +1219,14 @@ static void fbcon_deinit(struct vc_data *vc)
  *  This system is now divided into two levels because of complications
  *  caused by hardware scrolling. Top level functions:
  *
- *	fbcon_clear(), fbcon_putc(), fbcon_clear_margins()
+ *	fbcon_bmove(), fbcon_clear(), fbcon_putc(), fbcon_clear_margins()
  *
  *  handles y values in range [0, scr_height-1] that correspond to real
  *  screen positions. y_wrap shift means that first line of bitmap may be
  *  anywhere on this display. These functions convert lineoffsets to
  *  bitmap offsets and deal with the wrap-around case by splitting blits.
  *
+ *	fbcon_bmove_physical_8()    -- These functions fast implementations
  *	fbcon_clear_physical_8()    -- of original fbcon_XXX fns.
  *	fbcon_putc_physical_8()	    -- (font width != 8) may be added later
  *
@@ -1390,6 +1399,291 @@ static void fbcon_set_disp(struct fb_info *info, struct fb_var_screeninfo *var,
 	}
 }
 
+#ifdef CONFIG_FRAMEBUFFER_CONSOLE_LEGACY_ACCELERATION
+static void fbcon_redraw_move(struct vc_data *vc, struct fbcon_display *p,
+			      int line, int count, int dy)
+{
+	unsigned short *s = (unsigned short *)
+		(vc->vc_origin + vc->vc_size_row * line);
+
+	while (count--) {
+		unsigned short *start = s;
+		unsigned short *le = advance_row(s, 1);
+		unsigned short c;
+		int x = 0;
+		unsigned short attr = 1;
+
+		do {
+			c = scr_readw(s);
+			if (attr != (c & 0xff00)) {
+				attr = c & 0xff00;
+				if (s > start) {
+					fbcon_putcs(vc, start, s - start,
+						    dy, x);
+					x += s - start;
+					start = s;
+				}
+			}
+			console_conditional_schedule();
+			s++;
+		} while (s < le);
+		if (s > start)
+			fbcon_putcs(vc, start, s - start, dy, x);
+		console_conditional_schedule();
+		dy++;
+	}
+}
+
+static __inline__ void ywrap_up(struct vc_data *vc, int count)
+{
+	struct fb_info *info = registered_fb[con2fb_map[vc->vc_num]];
+	struct fbcon_ops *ops = info->fbcon_par;
+	struct fbcon_display *p = &fb_display[vc->vc_num];
+
+	p->yscroll += count;
+	if (p->yscroll >= p->vrows)	/* Deal with wrap */
+		p->yscroll -= p->vrows;
+	ops->var.xoffset = 0;
+	ops->var.yoffset = p->yscroll * vc->vc_font.height;
+	ops->var.vmode |= FB_VMODE_YWRAP;
+	ops->update_start(info);
+	scrollback_max += count;
+	if (scrollback_max > scrollback_phys_max)
+		scrollback_max = scrollback_phys_max;
+	scrollback_current = 0;
+}
+
+static __inline__ void ywrap_down(struct vc_data *vc, int count)
+{
+	struct fb_info *info = registered_fb[con2fb_map[vc->vc_num]];
+	struct fbcon_ops *ops = info->fbcon_par;
+	struct fbcon_display *p = &fb_display[vc->vc_num];
+
+	p->yscroll -= count;
+	if (p->yscroll < 0)	/* Deal with wrap */
+		p->yscroll += p->vrows;
+	ops->var.xoffset = 0;
+	ops->var.yoffset = p->yscroll * vc->vc_font.height;
+	ops->var.vmode |= FB_VMODE_YWRAP;
+	ops->update_start(info);
+	scrollback_max -= count;
+	if (scrollback_max < 0)
+		scrollback_max = 0;
+	scrollback_current = 0;
+}
+
+static __inline__ void ypan_up(struct vc_data *vc, int count)
+{
+	struct fb_info *info = registered_fb[con2fb_map[vc->vc_num]];
+	struct fbcon_display *p = &fb_display[vc->vc_num];
+	struct fbcon_ops *ops = info->fbcon_par;
+
+	p->yscroll += count;
+	if (p->yscroll > p->vrows - vc->vc_rows) {
+		ops->bmove(vc, info, p->vrows - vc->vc_rows,
+			    0, 0, 0, vc->vc_rows, vc->vc_cols);
+		p->yscroll -= p->vrows - vc->vc_rows;
+	}
+
+	ops->var.xoffset = 0;
+	ops->var.yoffset = p->yscroll * vc->vc_font.height;
+	ops->var.vmode &= ~FB_VMODE_YWRAP;
+	ops->update_start(info);
+	fbcon_clear_margins(vc, 1);
+	scrollback_max += count;
+	if (scrollback_max > scrollback_phys_max)
+		scrollback_max = scrollback_phys_max;
+	scrollback_current = 0;
+}
+
+static __inline__ void ypan_up_redraw(struct vc_data *vc, int t, int count)
+{
+	struct fb_info *info = registered_fb[con2fb_map[vc->vc_num]];
+	struct fbcon_ops *ops = info->fbcon_par;
+	struct fbcon_display *p = &fb_display[vc->vc_num];
+
+	p->yscroll += count;
+
+	if (p->yscroll > p->vrows - vc->vc_rows) {
+		p->yscroll -= p->vrows - vc->vc_rows;
+		fbcon_redraw_move(vc, p, t + count, vc->vc_rows - count, t);
+	}
+
+	ops->var.xoffset = 0;
+	ops->var.yoffset = p->yscroll * vc->vc_font.height;
+	ops->var.vmode &= ~FB_VMODE_YWRAP;
+	ops->update_start(info);
+	fbcon_clear_margins(vc, 1);
+	scrollback_max += count;
+	if (scrollback_max > scrollback_phys_max)
+		scrollback_max = scrollback_phys_max;
+	scrollback_current = 0;
+}
+
+static __inline__ void ypan_down(struct vc_data *vc, int count)
+{
+	struct fb_info *info = registered_fb[con2fb_map[vc->vc_num]];
+	struct fbcon_display *p = &fb_display[vc->vc_num];
+	struct fbcon_ops *ops = info->fbcon_par;
+
+	p->yscroll -= count;
+	if (p->yscroll < 0) {
+		ops->bmove(vc, info, 0, 0, p->vrows - vc->vc_rows,
+			    0, vc->vc_rows, vc->vc_cols);
+		p->yscroll += p->vrows - vc->vc_rows;
+	}
+
+	ops->var.xoffset = 0;
+	ops->var.yoffset = p->yscroll * vc->vc_font.height;
+	ops->var.vmode &= ~FB_VMODE_YWRAP;
+	ops->update_start(info);
+	fbcon_clear_margins(vc, 1);
+	scrollback_max -= count;
+	if (scrollback_max < 0)
+		scrollback_max = 0;
+	scrollback_current = 0;
+}
+
+static __inline__ void ypan_down_redraw(struct vc_data *vc, int t, int count)
+{
+	struct fb_info *info = registered_fb[con2fb_map[vc->vc_num]];
+	struct fbcon_ops *ops = info->fbcon_par;
+	struct fbcon_display *p = &fb_display[vc->vc_num];
+
+	p->yscroll -= count;
+
+	if (p->yscroll < 0) {
+		p->yscroll += p->vrows - vc->vc_rows;
+		fbcon_redraw_move(vc, p, t, vc->vc_rows - count, t + count);
+	}
+
+	ops->var.xoffset = 0;
+	ops->var.yoffset = p->yscroll * vc->vc_font.height;
+	ops->var.vmode &= ~FB_VMODE_YWRAP;
+	ops->update_start(info);
+	fbcon_clear_margins(vc, 1);
+	scrollback_max -= count;
+	if (scrollback_max < 0)
+		scrollback_max = 0;
+	scrollback_current = 0;
+}
+
+static void fbcon_bmove_rec(struct vc_data *vc, struct fbcon_display *p, int sy, int sx,
+			    int dy, int dx, int height, int width, u_int y_break)
+{
+	struct fb_info *info = registered_fb[con2fb_map[vc->vc_num]];
+	struct fbcon_ops *ops = info->fbcon_par;
+	u_int b;
+
+	if (sy < y_break && sy + height > y_break) {
+		b = y_break - sy;
+		if (dy < sy) {	/* Avoid trashing self */
+			fbcon_bmove_rec(vc, p, sy, sx, dy, dx, b, width,
+					y_break);
+			fbcon_bmove_rec(vc, p, sy + b, sx, dy + b, dx,
+					height - b, width, y_break);
+		} else {
+			fbcon_bmove_rec(vc, p, sy + b, sx, dy + b, dx,
+					height - b, width, y_break);
+			fbcon_bmove_rec(vc, p, sy, sx, dy, dx, b, width,
+					y_break);
+		}
+		return;
+	}
+
+	if (dy < y_break && dy + height > y_break) {
+		b = y_break - dy;
+		if (dy < sy) {	/* Avoid trashing self */
+			fbcon_bmove_rec(vc, p, sy, sx, dy, dx, b, width,
+					y_break);
+			fbcon_bmove_rec(vc, p, sy + b, sx, dy + b, dx,
+					height - b, width, y_break);
+		} else {
+			fbcon_bmove_rec(vc, p, sy + b, sx, dy + b, dx,
+					height - b, width, y_break);
+			fbcon_bmove_rec(vc, p, sy, sx, dy, dx, b, width,
+					y_break);
+		}
+		return;
+	}
+	ops->bmove(vc, info, real_y(p, sy), sx, real_y(p, dy), dx,
+		   height, width);
+}
+
+static void fbcon_bmove(struct vc_data *vc, int sy, int sx, int dy, int dx,
+			int height, int width)
+{
+	struct fb_info *info = registered_fb[con2fb_map[vc->vc_num]];
+	struct fbcon_display *p = &fb_display[vc->vc_num];
+
+	if (fbcon_is_inactive(vc, info))
+		return;
+
+	if (!width || !height)
+		return;
+
+	/*  Split blits that cross physical y_wrap case.
+	 *  Pathological case involves 4 blits, better to use recursive
+	 *  code rather than unrolled case
+	 *
+	 *  Recursive invocations don't need to erase the cursor over and
+	 *  over again, so we use fbcon_bmove_rec()
+	 */
+	fbcon_bmove_rec(vc, p, sy, sx, dy, dx, height, width,
+			p->vrows - p->yscroll);
+}
+
+static void fbcon_redraw_blit(struct vc_data *vc, struct fb_info *info,
+			struct fbcon_display *p, int line, int count, int ycount)
+{
+	int offset = ycount * vc->vc_cols;
+	unsigned short *d = (unsigned short *)
+	    (vc->vc_origin + vc->vc_size_row * line);
+	unsigned short *s = d + offset;
+	struct fbcon_ops *ops = info->fbcon_par;
+
+	while (count--) {
+		unsigned short *start = s;
+		unsigned short *le = advance_row(s, 1);
+		unsigned short c;
+		int x = 0;
+
+		do {
+			c = scr_readw(s);
+
+			if (c == scr_readw(d)) {
+				if (s > start) {
+					ops->bmove(vc, info, line + ycount, x,
+						   line, x, 1, s-start);
+					x += s - start + 1;
+					start = s + 1;
+				} else {
+					x++;
+					start++;
+				}
+			}
+
+			scr_writew(c, d);
+			console_conditional_schedule();
+			s++;
+			d++;
+		} while (s < le);
+		if (s > start)
+			ops->bmove(vc, info, line + ycount, x, line, x, 1,
+				   s-start);
+		console_conditional_schedule();
+		if (ycount > 0)
+			line++;
+		else {
+			line--;
+			/* NOTE: We subtract two lines from these pointers */
+			s -= vc->vc_size_row;
+			d -= vc->vc_size_row;
+		}
+	}
+}
+#endif
+
 static void fbcon_redraw(struct vc_data *vc, struct fbcon_display *p,
 			 int line, int count, int offset)
 {
@@ -1450,6 +1744,9 @@ static bool fbcon_scroll(struct vc_data *vc, unsigned int t, unsigned int b,
 {
 	struct fb_info *info = registered_fb[con2fb_map[vc->vc_num]];
 	struct fbcon_display *p = &fb_display[vc->vc_num];
+#ifdef CONFIG_FRAMEBUFFER_CONSOLE_LEGACY_ACCELERATION
+	int scroll_partial = info->flags & FBINFO_PARTIAL_PAN_OK;
+#endif
 
 	if (fbcon_is_inactive(vc, info))
 		return true;
@@ -1466,6 +1763,7 @@ static bool fbcon_scroll(struct vc_data *vc, unsigned int t, unsigned int b,
 	case SM_UP:
 		if (count > vc->vc_rows)	/* Maximum realistic size */
 			count = vc->vc_rows;
+#ifndef CONFIG_FRAMEBUFFER_CONSOLE_LEGACY_ACCELERATION
 		fbcon_redraw(vc, p, t, b - t - count,
 			     count * vc->vc_cols);
 		fbcon_clear(vc, b - count, 0, count, vc->vc_cols);
@@ -1475,10 +1773,99 @@ static bool fbcon_scroll(struct vc_data *vc, unsigned int t, unsigned int b,
 			    vc->vc_video_erase_char,
 			    vc->vc_size_row * count);
 		return true;
+#else
+		if (logo_shown >= 0)
+			goto redraw_up;
+		switch (p->scrollmode) {
+		case SCROLL_MOVE:
+			fbcon_redraw_blit(vc, info, p, t, b - t - count,
+				     count);
+			fbcon_clear(vc, b - count, 0, count, vc->vc_cols);
+			scr_memsetw((unsigned short *) (vc->vc_origin +
+							vc->vc_size_row *
+							(b - count)),
+				    vc->vc_video_erase_char,
+				    vc->vc_size_row * count);
+			return true;
+
+		case SCROLL_WRAP_MOVE:
+			if (b - t - count > 3 * vc->vc_rows >> 2) {
+				if (t > 0)
+					fbcon_bmove(vc, 0, 0, count, 0, t,
+						    vc->vc_cols);
+				ywrap_up(vc, count);
+				if (vc->vc_rows - b > 0)
+					fbcon_bmove(vc, b - count, 0, b, 0,
+						    vc->vc_rows - b,
+						    vc->vc_cols);
+			} else if (info->flags & FBINFO_READS_FAST)
+				fbcon_bmove(vc, t + count, 0, t, 0,
+					    b - t - count, vc->vc_cols);
+			else
+				goto redraw_up;
+			fbcon_clear(vc, b - count, 0, count, vc->vc_cols);
+			break;
+
+		case SCROLL_PAN_REDRAW:
+			if ((p->yscroll + count <=
+			     2 * (p->vrows - vc->vc_rows))
+			    && ((!scroll_partial && (b - t == vc->vc_rows))
+				|| (scroll_partial
+				    && (b - t - count >
+					3 * vc->vc_rows >> 2)))) {
+				if (t > 0)
+					fbcon_redraw_move(vc, p, 0, t, count);
+				ypan_up_redraw(vc, t, count);
+				if (vc->vc_rows - b > 0)
+					fbcon_redraw_move(vc, p, b,
+							  vc->vc_rows - b, b);
+			} else
+				fbcon_redraw_move(vc, p, t + count, b - t - count, t);
+			fbcon_clear(vc, b - count, 0, count, vc->vc_cols);
+			break;
+
+		case SCROLL_PAN_MOVE:
+			if ((p->yscroll + count <=
+			     2 * (p->vrows - vc->vc_rows))
+			    && ((!scroll_partial && (b - t == vc->vc_rows))
+				|| (scroll_partial
+				    && (b - t - count >
+					3 * vc->vc_rows >> 2)))) {
+				if (t > 0)
+					fbcon_bmove(vc, 0, 0, count, 0, t,
+						    vc->vc_cols);
+				ypan_up(vc, count);
+				if (vc->vc_rows - b > 0)
+					fbcon_bmove(vc, b - count, 0, b, 0,
+						    vc->vc_rows - b,
+						    vc->vc_cols);
+			} else if (info->flags & FBINFO_READS_FAST)
+				fbcon_bmove(vc, t + count, 0, t, 0,
+					    b - t - count, vc->vc_cols);
+			else
+				goto redraw_up;
+			fbcon_clear(vc, b - count, 0, count, vc->vc_cols);
+			break;
+
+		case SCROLL_REDRAW:
+		      redraw_up:
+			fbcon_redraw(vc, p, t, b - t - count,
+				     count * vc->vc_cols);
+			fbcon_clear(vc, b - count, 0, count, vc->vc_cols);
+			scr_memsetw((unsigned short *) (vc->vc_origin +
+							vc->vc_size_row *
+							(b - count)),
+				    vc->vc_video_erase_char,
+				    vc->vc_size_row * count);
+			return true;
+		}
+		break;
+#endif
 
 	case SM_DOWN:
 		if (count > vc->vc_rows)	/* Maximum realistic size */
 			count = vc->vc_rows;
+#ifndef CONFIG_FRAMEBUFFER_CONSOLE_LEGACY_ACCELERATION
 		fbcon_redraw(vc, p, b - 1, b - t - count,
 			     -count * vc->vc_cols);
 		fbcon_clear(vc, t, 0, count, vc->vc_cols);
@@ -1488,10 +1875,96 @@ static bool fbcon_scroll(struct vc_data *vc, unsigned int t, unsigned int b,
 			    vc->vc_video_erase_char,
 			    vc->vc_size_row * count);
 		return true;
+#else
+		if (logo_shown >= 0)
+			goto redraw_down;
+		switch (p->scrollmode) {
+		case SCROLL_MOVE:
+			fbcon_redraw_blit(vc, info, p, b - 1, b - t - count,
+				     -count);
+			fbcon_clear(vc, t, 0, count, vc->vc_cols);
+			scr_memsetw((unsigned short *) (vc->vc_origin +
+							vc->vc_size_row *
+							t),
+				    vc->vc_video_erase_char,
+				    vc->vc_size_row * count);
+			return true;
+
+		case SCROLL_WRAP_MOVE:
+			if (b - t - count > 3 * vc->vc_rows >> 2) {
+				if (vc->vc_rows - b > 0)
+					fbcon_bmove(vc, b, 0, b - count, 0,
+						    vc->vc_rows - b,
+						    vc->vc_cols);
+				ywrap_down(vc, count);
+				if (t > 0)
+					fbcon_bmove(vc, count, 0, 0, 0, t,
+						    vc->vc_cols);
+			} else if (info->flags & FBINFO_READS_FAST)
+				fbcon_bmove(vc, t, 0, t + count, 0,
+					    b - t - count, vc->vc_cols);
+			else
+				goto redraw_down;
+			fbcon_clear(vc, t, 0, count, vc->vc_cols);
+			break;
+
+		case SCROLL_PAN_MOVE:
+			if ((count - p->yscroll <= p->vrows - vc->vc_rows)
+			    && ((!scroll_partial && (b - t == vc->vc_rows))
+				|| (scroll_partial
+				    && (b - t - count >
+					3 * vc->vc_rows >> 2)))) {
+				if (vc->vc_rows - b > 0)
+					fbcon_bmove(vc, b, 0, b - count, 0,
+						    vc->vc_rows - b,
+						    vc->vc_cols);
+				ypan_down(vc, count);
+				if (t > 0)
+					fbcon_bmove(vc, count, 0, 0, 0, t,
+						    vc->vc_cols);
+			} else if (info->flags & FBINFO_READS_FAST)
+				fbcon_bmove(vc, t, 0, t + count, 0,
+					    b - t - count, vc->vc_cols);
+			else
+				goto redraw_down;
+			fbcon_clear(vc, t, 0, count, vc->vc_cols);
+			break;
+
+		case SCROLL_PAN_REDRAW:
+			if ((count - p->yscroll <= p->vrows - vc->vc_rows)
+			    && ((!scroll_partial && (b - t == vc->vc_rows))
+				|| (scroll_partial
+				    && (b - t - count >
+					3 * vc->vc_rows >> 2)))) {
+				if (vc->vc_rows - b > 0)
+					fbcon_redraw_move(vc, p, b, vc->vc_rows - b,
+							  b - count);
+				ypan_down_redraw(vc, t, count);
+				if (t > 0)
+					fbcon_redraw_move(vc, p, count, t, 0);
+			} else
+				fbcon_redraw_move(vc, p, t, b - t - count, t + count);
+			fbcon_clear(vc, t, 0, count, vc->vc_cols);
+			break;
+
+		case SCROLL_REDRAW:
+		      redraw_down:
+			fbcon_redraw(vc, p, b - 1, b - t - count,
+				     -count * vc->vc_cols);
+			fbcon_clear(vc, t, 0, count, vc->vc_cols);
+			scr_memsetw((unsigned short *) (vc->vc_origin +
+							vc->vc_size_row *
+							t),
+				    vc->vc_video_erase_char,
+				    vc->vc_size_row * count);
+			return true;
+		}
+#endif
 	}
 	return false;
 }
 
+
 static void updatescrollmode(struct fbcon_display *p,
 					struct fb_info *info,
 					struct vc_data *vc)
@@ -1664,7 +2137,21 @@ static int fbcon_switch(struct vc_data *vc)
 
 	updatescrollmode(p, info, vc);
 
-	scrollback_phys_max = 0;
+	switch (p->scrollmode) {
+	case SCROLL_WRAP_MOVE:
+		scrollback_phys_max = p->vrows - vc->vc_rows;
+		break;
+	case SCROLL_PAN_MOVE:
+	case SCROLL_PAN_REDRAW:
+		scrollback_phys_max = p->vrows - 2 * vc->vc_rows;
+		if (scrollback_phys_max < 0)
+			scrollback_phys_max = 0;
+		break;
+	default:
+		scrollback_phys_max = 0;
+		break;
+	}
+
 	scrollback_max = 0;
 	scrollback_current = 0;
 
diff --git a/drivers/video/fbdev/core/fbcon.h b/drivers/video/fbdev/core/fbcon.h
index a00603b4451a..5246d0f2574b 100644
--- a/drivers/video/fbdev/core/fbcon.h
+++ b/drivers/video/fbdev/core/fbcon.h
@@ -29,6 +29,7 @@ struct fbcon_display {
     /* Filled in by the low-level console driver */
     const u_char *fontdata;
     int userfont;                   /* != 0 if fontdata kmalloc()ed */
+    u_short scrollmode;             /* Scroll Method */
     u_short inverse;                /* != 0 text black on white as default */
     short yscroll;                  /* Hardware scrolling */
     int vrows;                      /* number of virtual rows */
@@ -51,6 +52,8 @@ struct fbcon_display {
 };
 
 struct fbcon_ops {
+	void (*bmove)(struct vc_data *vc, struct fb_info *info, int sy,
+		      int sx, int dy, int dx, int height, int width);
 	void (*clear)(struct vc_data *vc, struct fb_info *info, int sy,
 		      int sx, int height, int width);
 	void (*putcs)(struct vc_data *vc, struct fb_info *info,
@@ -149,6 +152,62 @@ static inline int attr_col_ec(int shift, struct vc_data *vc,
 #define attr_bgcol_ec(bgshift, vc, info) attr_col_ec(bgshift, vc, info, 0)
 #define attr_fgcol_ec(fgshift, vc, info) attr_col_ec(fgshift, vc, info, 1)
 
+    /*
+     *  Scroll Method
+     */
+
+/* There are several methods fbcon can use to move text around the screen:
+ *
+ *                     Operation   Pan    Wrap
+ *---------------------------------------------
+ * SCROLL_MOVE         copyarea    No     No
+ * SCROLL_PAN_MOVE     copyarea    Yes    No
+ * SCROLL_WRAP_MOVE    copyarea    No     Yes
+ * SCROLL_REDRAW       imageblit   No     No
+ * SCROLL_PAN_REDRAW   imageblit   Yes    No
+ * SCROLL_WRAP_REDRAW  imageblit   No     Yes
+ *
+ * (SCROLL_WRAP_REDRAW is not implemented yet)
+ *
+ * In general, fbcon will choose the best scrolling
+ * method based on the rule below:
+ *
+ * Pan/Wrap > accel imageblit > accel copyarea >
+ * soft imageblit > (soft copyarea)
+ *
+ * Exception to the rule: Pan + accel copyarea is
+ * preferred over Pan + accel imageblit.
+ *
+ * The above is typical for PCI/AGP cards. Unless
+ * overridden, fbcon will never use soft copyarea.
+ *
+ * If you need to override the above rule, set the
+ * appropriate flags in fb_info->flags.  For example,
+ * to prefer copyarea over imageblit, set
+ * FBINFO_READS_FAST.
+ *
+ * Other notes:
+ * + use the hardware engine to move the text
+ *    (hw-accelerated copyarea() and fillrect())
+ * + use hardware-supported panning on a large virtual screen
+ * + amifb can not only pan, but also wrap the display by N lines
+ *    (i.e. visible line i = physical line (i+N) % yres).
+ * + read what's already rendered on the screen and
+ *     write it in a different place (this is cfb_copyarea())
+ * + re-render the text to the screen
+ *
+ * Whether to use wrapping or panning can only be figured out at
+ * runtime (when we know whether our font height is a multiple
+ * of the pan/wrap step)
+ *
+ */
+
+#define SCROLL_MOVE	   0x001
+#define SCROLL_PAN_MOVE	   0x002
+#define SCROLL_WRAP_MOVE   0x003
+#define SCROLL_REDRAW	   0x004
+#define SCROLL_PAN_REDRAW  0x005
+
 #ifdef CONFIG_FB_TILEBLITTING
 extern void fbcon_set_tileops(struct vc_data *vc, struct fb_info *info);
 #endif
diff --git a/drivers/video/fbdev/core/fbcon_ccw.c b/drivers/video/fbdev/core/fbcon_ccw.c
index ffa78936eaab..9cd2c4b05c32 100644
--- a/drivers/video/fbdev/core/fbcon_ccw.c
+++ b/drivers/video/fbdev/core/fbcon_ccw.c
@@ -59,12 +59,31 @@ static void ccw_update_attr(u8 *dst, u8 *src, int attribute,
 	}
 }
 
+
+static void ccw_bmove(struct vc_data *vc, struct fb_info *info, int sy,
+		     int sx, int dy, int dx, int height, int width)
+{
+	struct fbcon_ops *ops = info->fbcon_par;
+	struct fb_copyarea area;
+	u32 vyres = GETVYRES(ops->p->scrollmode, info);
+
+	area.sx = sy * vc->vc_font.height;
+	area.sy = vyres - ((sx + width) * vc->vc_font.width);
+	area.dx = dy * vc->vc_font.height;
+	area.dy = vyres - ((dx + width) * vc->vc_font.width);
+	area.width = height * vc->vc_font.height;
+	area.height  = width * vc->vc_font.width;
+
+	info->fbops->fb_copyarea(info, &area);
+}
+
 static void ccw_clear(struct vc_data *vc, struct fb_info *info, int sy,
 		     int sx, int height, int width)
 {
+	struct fbcon_ops *ops = info->fbcon_par;
 	struct fb_fillrect region;
 	int bgshift = (vc->vc_hi_font_mask) ? 13 : 12;
-	u32 vyres = info->var.yres;
+	u32 vyres = GETVYRES(ops->p->scrollmode, info);
 
 	region.color = attr_bgcol_ec(bgshift,vc,info);
 	region.dx = sy * vc->vc_font.height;
@@ -121,7 +140,7 @@ static void ccw_putcs(struct vc_data *vc, struct fb_info *info,
 	u32 cnt, pitch, size;
 	u32 attribute = get_attribute(info, scr_readw(s));
 	u8 *dst, *buf = NULL;
-	u32 vyres = info->var.yres;
+	u32 vyres = GETVYRES(ops->p->scrollmode, info);
 
 	if (!ops->fontbuffer)
 		return;
@@ -210,7 +229,7 @@ static void ccw_cursor(struct vc_data *vc, struct fb_info *info, int mode,
 	int attribute, use_sw = vc->vc_cursor_type & CUR_SW;
 	int err = 1, dx, dy;
 	char *src;
-	u32 vyres = info->var.yres;
+	u32 vyres = GETVYRES(ops->p->scrollmode, info);
 
 	if (!ops->fontbuffer)
 		return;
@@ -368,7 +387,7 @@ static int ccw_update_start(struct fb_info *info)
 {
 	struct fbcon_ops *ops = info->fbcon_par;
 	u32 yoffset;
-	u32 vyres = info->var.yres;
+	u32 vyres = GETVYRES(ops->p->scrollmode, info);
 	int err;
 
 	yoffset = (vyres - info->var.yres) - ops->var.xoffset;
@@ -383,6 +402,7 @@ static int ccw_update_start(struct fb_info *info)
 
 void fbcon_rotate_ccw(struct fbcon_ops *ops)
 {
+	ops->bmove = ccw_bmove;
 	ops->clear = ccw_clear;
 	ops->putcs = ccw_putcs;
 	ops->clear_margins = ccw_clear_margins;
diff --git a/drivers/video/fbdev/core/fbcon_cw.c b/drivers/video/fbdev/core/fbcon_cw.c
index 92e5b7fb51ee..88d89fad3f05 100644
--- a/drivers/video/fbdev/core/fbcon_cw.c
+++ b/drivers/video/fbdev/core/fbcon_cw.c
@@ -44,12 +44,31 @@ static void cw_update_attr(u8 *dst, u8 *src, int attribute,
 	}
 }
 
+
+static void cw_bmove(struct vc_data *vc, struct fb_info *info, int sy,
+		     int sx, int dy, int dx, int height, int width)
+{
+	struct fbcon_ops *ops = info->fbcon_par;
+	struct fb_copyarea area;
+	u32 vxres = GETVXRES(ops->p->scrollmode, info);
+
+	area.sx = vxres - ((sy + height) * vc->vc_font.height);
+	area.sy = sx * vc->vc_font.width;
+	area.dx = vxres - ((dy + height) * vc->vc_font.height);
+	area.dy = dx * vc->vc_font.width;
+	area.width = height * vc->vc_font.height;
+	area.height  = width * vc->vc_font.width;
+
+	info->fbops->fb_copyarea(info, &area);
+}
+
 static void cw_clear(struct vc_data *vc, struct fb_info *info, int sy,
 		     int sx, int height, int width)
 {
+	struct fbcon_ops *ops = info->fbcon_par;
 	struct fb_fillrect region;
 	int bgshift = (vc->vc_hi_font_mask) ? 13 : 12;
-	u32 vxres = info->var.xres;
+	u32 vxres = GETVXRES(ops->p->scrollmode, info);
 
 	region.color = attr_bgcol_ec(bgshift,vc,info);
 	region.dx = vxres - ((sy + height) * vc->vc_font.height);
@@ -106,7 +125,7 @@ static void cw_putcs(struct vc_data *vc, struct fb_info *info,
 	u32 cnt, pitch, size;
 	u32 attribute = get_attribute(info, scr_readw(s));
 	u8 *dst, *buf = NULL;
-	u32 vxres = info->var.xres;
+	u32 vxres = GETVXRES(ops->p->scrollmode, info);
 
 	if (!ops->fontbuffer)
 		return;
@@ -193,7 +212,7 @@ static void cw_cursor(struct vc_data *vc, struct fb_info *info, int mode,
 	int attribute, use_sw = vc->vc_cursor_type & CUR_SW;
 	int err = 1, dx, dy;
 	char *src;
-	u32 vxres = info->var.xres;
+	u32 vxres = GETVXRES(ops->p->scrollmode, info);
 
 	if (!ops->fontbuffer)
 		return;
@@ -350,7 +369,7 @@ static void cw_cursor(struct vc_data *vc, struct fb_info *info, int mode,
 static int cw_update_start(struct fb_info *info)
 {
 	struct fbcon_ops *ops = info->fbcon_par;
-	u32 vxres = info->var.xres;
+	u32 vxres = GETVXRES(ops->p->scrollmode, info);
 	u32 xoffset;
 	int err;
 
@@ -366,6 +385,7 @@ static int cw_update_start(struct fb_info *info)
 
 void fbcon_rotate_cw(struct fbcon_ops *ops)
 {
+	ops->bmove = cw_bmove;
 	ops->clear = cw_clear;
 	ops->putcs = cw_putcs;
 	ops->clear_margins = cw_clear_margins;
diff --git a/drivers/video/fbdev/core/fbcon_rotate.h b/drivers/video/fbdev/core/fbcon_rotate.h
index b528b2e54283..21cb81615883 100644
--- a/drivers/video/fbdev/core/fbcon_rotate.h
+++ b/drivers/video/fbdev/core/fbcon_rotate.h
@@ -11,6 +11,27 @@
 #ifndef _FBCON_ROTATE_H
 #define _FBCON_ROTATE_H
 
+#ifdef CONFIG_FRAMEBUFFER_CONSOLE_LEGACY_ACCELERATION
+#define GETVYRES(s,i) ({                           \
+        (s == SCROLL_REDRAW || s == SCROLL_MOVE) ? \
+        (i)->var.yres : (i)->var.yres_virtual; })
+
+#define GETVXRES(s,i) ({                           \
+        (s == SCROLL_REDRAW || s == SCROLL_MOVE || !(i)->fix.xpanstep) ? \
+        (i)->var.xres : (i)->var.xres_virtual; })
+#else
+static inline u32 GETVYRES(int s, struct fb_info *i)
+{
+	return i->var.yres;
+}
+
+static inline u32 GETVXRES(int s, struct fb_info *i)
+{
+	return i->var.xres;
+}
+#endif
+
+
 static inline int pattern_test_bit(u32 x, u32 y, u32 pitch, const char *pat)
 {
 	u32 tmp = (y * pitch) + x, index = tmp / 8,  bit = tmp % 8;
diff --git a/drivers/video/fbdev/core/fbcon_ud.c b/drivers/video/fbdev/core/fbcon_ud.c
index 09619bd8e021..8d5e66b1bdfb 100644
--- a/drivers/video/fbdev/core/fbcon_ud.c
+++ b/drivers/video/fbdev/core/fbcon_ud.c
@@ -44,13 +44,33 @@ static void ud_update_attr(u8 *dst, u8 *src, int attribute,
 	}
 }
 
+
+static void ud_bmove(struct vc_data *vc, struct fb_info *info, int sy,
+		     int sx, int dy, int dx, int height, int width)
+{
+	struct fbcon_ops *ops = info->fbcon_par;
+	struct fb_copyarea area;
+	u32 vyres = GETVYRES(ops->p->scrollmode, info);
+	u32 vxres = GETVXRES(ops->p->scrollmode, info);
+
+	area.sy = vyres - ((sy + height) * vc->vc_font.height);
+	area.sx = vxres - ((sx + width) * vc->vc_font.width);
+	area.dy = vyres - ((dy + height) * vc->vc_font.height);
+	area.dx = vxres - ((dx + width) * vc->vc_font.width);
+	area.height = height * vc->vc_font.height;
+	area.width  = width * vc->vc_font.width;
+
+	info->fbops->fb_copyarea(info, &area);
+}
+
 static void ud_clear(struct vc_data *vc, struct fb_info *info, int sy,
 		     int sx, int height, int width)
 {
+	struct fbcon_ops *ops = info->fbcon_par;
 	struct fb_fillrect region;
 	int bgshift = (vc->vc_hi_font_mask) ? 13 : 12;
-	u32 vyres = info->var.yres;
-	u32 vxres = info->var.xres;
+	u32 vyres = GETVYRES(ops->p->scrollmode, info);
+	u32 vxres = GETVXRES(ops->p->scrollmode, info);
 
 	region.color = attr_bgcol_ec(bgshift,vc,info);
 	region.dy = vyres - ((sy + height) * vc->vc_font.height);
@@ -142,8 +162,8 @@ static void ud_putcs(struct vc_data *vc, struct fb_info *info,
 	u32 mod = vc->vc_font.width % 8, cnt, pitch, size;
 	u32 attribute = get_attribute(info, scr_readw(s));
 	u8 *dst, *buf = NULL;
-	u32 vyres = info->var.yres;
-	u32 vxres = info->var.xres;
+	u32 vyres = GETVYRES(ops->p->scrollmode, info);
+	u32 vxres = GETVXRES(ops->p->scrollmode, info);
 
 	if (!ops->fontbuffer)
 		return;
@@ -239,8 +259,8 @@ static void ud_cursor(struct vc_data *vc, struct fb_info *info, int mode,
 	int attribute, use_sw = vc->vc_cursor_type & CUR_SW;
 	int err = 1, dx, dy;
 	char *src;
-	u32 vyres = info->var.yres;
-	u32 vxres = info->var.xres;
+	u32 vyres = GETVYRES(ops->p->scrollmode, info);
+	u32 vxres = GETVXRES(ops->p->scrollmode, info);
 
 	if (!ops->fontbuffer)
 		return;
@@ -390,8 +410,8 @@ static int ud_update_start(struct fb_info *info)
 {
 	struct fbcon_ops *ops = info->fbcon_par;
 	int xoffset, yoffset;
-	u32 vyres = info->var.yres;
-	u32 vxres = info->var.xres;
+	u32 vyres = GETVYRES(ops->p->scrollmode, info);
+	u32 vxres = GETVXRES(ops->p->scrollmode, info);
 	int err;
 
 	xoffset = vxres - info->var.xres - ops->var.xoffset;
@@ -409,6 +429,7 @@ static int ud_update_start(struct fb_info *info)
 
 void fbcon_rotate_ud(struct fbcon_ops *ops)
 {
+	ops->bmove = ud_bmove;
 	ops->clear = ud_clear;
 	ops->putcs = ud_putcs;
 	ops->clear_margins = ud_clear_margins;
diff --git a/drivers/video/fbdev/core/tileblit.c b/drivers/video/fbdev/core/tileblit.c
index 72af95053bcb..2768eff247ba 100644
--- a/drivers/video/fbdev/core/tileblit.c
+++ b/drivers/video/fbdev/core/tileblit.c
@@ -16,6 +16,21 @@
 #include <asm/types.h>
 #include "fbcon.h"
 
+static void tile_bmove(struct vc_data *vc, struct fb_info *info, int sy,
+		       int sx, int dy, int dx, int height, int width)
+{
+	struct fb_tilearea area;
+
+	area.sx = sx;
+	area.sy = sy;
+	area.dx = dx;
+	area.dy = dy;
+	area.height = height;
+	area.width = width;
+
+	info->tileops->fb_tilecopy(info, &area);
+}
+
 static void tile_clear(struct vc_data *vc, struct fb_info *info, int sy,
 		       int sx, int height, int width)
 {
@@ -118,6 +133,7 @@ void fbcon_set_tileops(struct vc_data *vc, struct fb_info *info)
 	struct fb_tilemap map;
 	struct fbcon_ops *ops = info->fbcon_par;
 
+	ops->bmove = tile_bmove;
 	ops->clear = tile_clear;
 	ops->putcs = tile_putcs;
 	ops->clear_margins = tile_clear_margins;
diff --git a/drivers/video/fbdev/skeletonfb.c b/drivers/video/fbdev/skeletonfb.c
index 0fe922f726e9..bcacfb6934fa 100644
--- a/drivers/video/fbdev/skeletonfb.c
+++ b/drivers/video/fbdev/skeletonfb.c
@@ -505,15 +505,15 @@ void xxxfb_fillrect(struct fb_info *p, const struct fb_fillrect *region)
 }
 
 /**
- *      xxxfb_copyarea - OBSOLETE function.
+ *      xxxfb_copyarea - REQUIRED function. Can use generic routines if
+ *                       non acclerated hardware and packed pixel based.
  *                       Copies one area of the screen to another area.
- *                       Will be deleted in a future version
  *
  *      @info: frame buffer structure that represents a single frame buffer
  *      @area: Structure providing the data to copy the framebuffer contents
  *	       from one region to another.
  *
- *      This drawing operation copied a rectangular area from one area of the
+ *      This drawing operation copies a rectangular area from one area of the
  *	screen to another area.
  */
 void xxxfb_copyarea(struct fb_info *p, const struct fb_copyarea *area) 
@@ -645,9 +645,9 @@ static const struct fb_ops xxxfb_ops = {
 	.fb_setcolreg	= xxxfb_setcolreg,
 	.fb_blank	= xxxfb_blank,
 	.fb_pan_display	= xxxfb_pan_display,
-	.fb_fillrect	= xxxfb_fillrect,	/* Needed !!!   */
-	.fb_copyarea	= xxxfb_copyarea,	/* Obsolete     */
-	.fb_imageblit	= xxxfb_imageblit,	/* Needed !!!   */
+	.fb_fillrect	= xxxfb_fillrect, 	/* Needed !!! */
+	.fb_copyarea	= xxxfb_copyarea,	/* Needed !!! */
+	.fb_imageblit	= xxxfb_imageblit,	/* Needed !!! */
 	.fb_cursor	= xxxfb_cursor,		/* Optional !!! */
 	.fb_sync	= xxxfb_sync,
 	.fb_ioctl	= xxxfb_ioctl,
diff --git a/include/linux/fb.h b/include/linux/fb.h
index 3da95842b207..02f362c661c8 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -262,7 +262,7 @@ struct fb_ops {
 
 	/* Draws a rectangle */
 	void (*fb_fillrect) (struct fb_info *info, const struct fb_fillrect *rect);
-	/* Copy data from area to another. Obsolete. */
+	/* Copy data from area to another */
 	void (*fb_copyarea) (struct fb_info *info, const struct fb_copyarea *region);
 	/* Draws a image to the display */
 	void (*fb_imageblit) (struct fb_info *info, const struct fb_image *image);
-- 
2.33.0

