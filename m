Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85103272C75
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728478AbgIUQcb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:32:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:57634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728427AbgIUQcR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:32:17 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3DCA235F9;
        Mon, 21 Sep 2020 16:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600705935;
        bh=mUB9LSDkQjmKRBhMpYIZ5OSZkr77dosOFdY2iOxg0ZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vKQWfDrFn+RrJNJlxCvLcqAoF9cAgMPWIcsBHtPTAB+pCPtSsy6mAuEA5o7SvdHYE
         NjZG+VbItl6KcjB66H19ufdqG8KmgdrIerZX4Kanrm4p1D2ejUaOOk6O0JBD2b8ASx
         F806H00jiHPxgERCsUsT4Rz2BjkpMMVse+kvXLYw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, NopNop Nop <nopitydays@gmail.com>,
        Willy Tarreau <w@1wt.eu>,
        =?UTF-8?q?=E5=BC=A0=E4=BA=91=E6=B5=B7?= <zhangyunhai@nsfocus.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.4 22/46] vgacon: remove software scrollback support
Date:   Mon, 21 Sep 2020 18:27:38 +0200
Message-Id: <20200921162034.333966952@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162033.346434578@linuxfoundation.org>
References: <20200921162033.346434578@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 973c096f6a85e5b5f2a295126ba6928d9a6afd45 upstream.

Yunhai Zhang recently fixed a VGA software scrollback bug in commit
ebfdfeeae8c0 ("vgacon: Fix for missing check in scrollback handling"),
but that then made people look more closely at some of this code, and
there were more problems on the vgacon side, but also the fbcon software
scrollback.

We don't really have anybody who maintains this code - probably because
nobody actually _uses_ it any more.  Sure, people still use both VGA and
the framebuffer consoles, but they are no longer the main user
interfaces to the kernel, and haven't been for decades, so these kinds
of extra features end up bitrotting and not really being used.

So rather than try to maintain a likely unused set of code, I'll just
aggressively remove it, and see if anybody even notices.  Maybe there
are people who haven't jumped on the whole GUI badnwagon yet, and think
it's just a fad.  And maybe those people use the scrollback code.

If that turns out to be the case, we can resurrect this again, once
we've found the sucker^Wmaintainer for it who actually uses it.

Reported-by: NopNop Nop <nopitydays@gmail.com>
Tested-by: Willy Tarreau <w@1wt.eu>
Cc: 张云海 <zhangyunhai@nsfocus.com>
Acked-by: Andy Lutomirski <luto@amacapital.net>
Acked-by: Willy Tarreau <w@1wt.eu>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/configs/pasemi_defconfig |    1 
 arch/powerpc/configs/ppc6xx_defconfig |    1 
 arch/x86/configs/i386_defconfig       |    1 
 arch/x86/configs/x86_64_defconfig     |    1 
 drivers/video/console/Kconfig         |   25 -----
 drivers/video/console/vgacon.c        |  161 ----------------------------------
 6 files changed, 1 insertion(+), 189 deletions(-)

--- a/arch/powerpc/configs/pasemi_defconfig
+++ b/arch/powerpc/configs/pasemi_defconfig
@@ -115,7 +115,6 @@ CONFIG_FB_NVIDIA=y
 CONFIG_FB_NVIDIA_I2C=y
 CONFIG_FB_RADEON=y
 # CONFIG_LCD_CLASS_DEVICE is not set
-CONFIG_VGACON_SOFT_SCROLLBACK=y
 CONFIG_LOGO=y
 CONFIG_SOUND=y
 CONFIG_SND=y
--- a/arch/powerpc/configs/ppc6xx_defconfig
+++ b/arch/powerpc/configs/ppc6xx_defconfig
@@ -797,7 +797,6 @@ CONFIG_FB_TRIDENT=m
 CONFIG_FB_SM501=m
 CONFIG_FB_IBM_GXT4500=y
 CONFIG_LCD_PLATFORM=m
-CONFIG_VGACON_SOFT_SCROLLBACK=y
 CONFIG_FRAMEBUFFER_CONSOLE=y
 CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
 CONFIG_LOGO=y
--- a/arch/x86/configs/i386_defconfig
+++ b/arch/x86/configs/i386_defconfig
@@ -218,7 +218,6 @@ CONFIG_FB_MODE_HELPERS=y
 CONFIG_FB_TILEBLITTING=y
 CONFIG_FB_EFI=y
 # CONFIG_LCD_CLASS_DEVICE is not set
-CONFIG_VGACON_SOFT_SCROLLBACK=y
 CONFIG_LOGO=y
 # CONFIG_LOGO_LINUX_MONO is not set
 # CONFIG_LOGO_LINUX_VGA16 is not set
--- a/arch/x86/configs/x86_64_defconfig
+++ b/arch/x86/configs/x86_64_defconfig
@@ -212,7 +212,6 @@ CONFIG_FB_MODE_HELPERS=y
 CONFIG_FB_TILEBLITTING=y
 CONFIG_FB_EFI=y
 # CONFIG_LCD_CLASS_DEVICE is not set
-CONFIG_VGACON_SOFT_SCROLLBACK=y
 CONFIG_LOGO=y
 # CONFIG_LOGO_LINUX_MONO is not set
 # CONFIG_LOGO_LINUX_VGA16 is not set
--- a/drivers/video/console/Kconfig
+++ b/drivers/video/console/Kconfig
@@ -22,31 +22,6 @@ config VGA_CONSOLE
 
 	  Say Y.
 
-config VGACON_SOFT_SCROLLBACK
-       bool "Enable Scrollback Buffer in System RAM"
-       depends on VGA_CONSOLE
-       default n
-       help
-         The scrollback buffer of the standard VGA console is located in
-	 the VGA RAM.  The size of this RAM is fixed and is quite small.
-	 If you require a larger scrollback buffer, this can be placed in
-	 System RAM which is dynamically allocated during initialization.
-	 Placing the scrollback buffer in System RAM will slightly slow
-	 down the console.
-
-	 If you want this feature, say 'Y' here and enter the amount of
-	 RAM to allocate for this buffer.  If unsure, say 'N'.
-
-config VGACON_SOFT_SCROLLBACK_SIZE
-       int "Scrollback Buffer Size (in KB)"
-       depends on VGACON_SOFT_SCROLLBACK
-       range 1 1024
-       default "64"
-       help
-         Enter the amount of System RAM to allocate for the scrollback
-	 buffer.  Each 64KB will give you approximately 16 80x25
-	 screenfuls of scrollback buffer
-
 config MDA_CONSOLE
 	depends on !M68K && !PARISC && ISA
 	tristate "MDA text console (dual-headed)"
--- a/drivers/video/console/vgacon.c
+++ b/drivers/video/console/vgacon.c
@@ -180,159 +180,6 @@ static inline void vga_set_mem_top(struc
 	write_vga(12, (c->vc_visible_origin - vga_vram_base) / 2);
 }
 
-#ifdef CONFIG_VGACON_SOFT_SCROLLBACK
-/* software scrollback */
-static void *vgacon_scrollback;
-static int vgacon_scrollback_tail;
-static int vgacon_scrollback_size;
-static int vgacon_scrollback_rows;
-static int vgacon_scrollback_cnt;
-static int vgacon_scrollback_cur;
-static int vgacon_scrollback_save;
-static int vgacon_scrollback_restore;
-
-static void vgacon_scrollback_init(int pitch)
-{
-	int rows = CONFIG_VGACON_SOFT_SCROLLBACK_SIZE * 1024/pitch;
-
-	if (vgacon_scrollback) {
-		vgacon_scrollback_cnt  = 0;
-		vgacon_scrollback_tail = 0;
-		vgacon_scrollback_cur  = 0;
-		vgacon_scrollback_rows = rows - 1;
-		vgacon_scrollback_size = rows * pitch;
-	}
-}
-
-static void vgacon_scrollback_startup(void)
-{
-	vgacon_scrollback = kcalloc(CONFIG_VGACON_SOFT_SCROLLBACK_SIZE, 1024, GFP_NOWAIT);
-	vgacon_scrollback_init(vga_video_num_columns * 2);
-}
-
-static void vgacon_scrollback_update(struct vc_data *c, int t, int count)
-{
-	void *p;
-
-	if (!vgacon_scrollback_size || c->vc_num != fg_console)
-		return;
-
-	p = (void *) (c->vc_origin + t * c->vc_size_row);
-
-	while (count--) {
-		if ((vgacon_scrollback_tail + c->vc_size_row) >
-		    vgacon_scrollback_size)
-			vgacon_scrollback_tail = 0;
-
-		scr_memcpyw(vgacon_scrollback + vgacon_scrollback_tail,
-			    p, c->vc_size_row);
-		vgacon_scrollback_cnt++;
-		p += c->vc_size_row;
-		vgacon_scrollback_tail += c->vc_size_row;
-
-		if (vgacon_scrollback_tail >= vgacon_scrollback_size)
-			vgacon_scrollback_tail = 0;
-
-		if (vgacon_scrollback_cnt > vgacon_scrollback_rows)
-			vgacon_scrollback_cnt = vgacon_scrollback_rows;
-
-		vgacon_scrollback_cur = vgacon_scrollback_cnt;
-	}
-}
-
-static void vgacon_restore_screen(struct vc_data *c)
-{
-	vgacon_scrollback_save = 0;
-
-	if (!vga_is_gfx && !vgacon_scrollback_restore) {
-		scr_memcpyw((u16 *) c->vc_origin, (u16 *) c->vc_screenbuf,
-			    c->vc_screenbuf_size > vga_vram_size ?
-			    vga_vram_size : c->vc_screenbuf_size);
-		vgacon_scrollback_restore = 1;
-		vgacon_scrollback_cur = vgacon_scrollback_cnt;
-	}
-}
-
-static int vgacon_scrolldelta(struct vc_data *c, int lines)
-{
-	int start, end, count, soff;
-
-	if (!lines) {
-		c->vc_visible_origin = c->vc_origin;
-		vga_set_mem_top(c);
-		return 1;
-	}
-
-	if (!vgacon_scrollback)
-		return 1;
-
-	if (!vgacon_scrollback_save) {
-		vgacon_cursor(c, CM_ERASE);
-		vgacon_save_screen(c);
-		vgacon_scrollback_save = 1;
-	}
-
-	vgacon_scrollback_restore = 0;
-	start = vgacon_scrollback_cur + lines;
-	end = start + abs(lines);
-
-	if (start < 0)
-		start = 0;
-
-	if (start > vgacon_scrollback_cnt)
-		start = vgacon_scrollback_cnt;
-
-	if (end < 0)
-		end = 0;
-
-	if (end > vgacon_scrollback_cnt)
-		end = vgacon_scrollback_cnt;
-
-	vgacon_scrollback_cur = start;
-	count = end - start;
-	soff = vgacon_scrollback_tail - ((vgacon_scrollback_cnt - end) *
-					 c->vc_size_row);
-	soff -= count * c->vc_size_row;
-
-	if (soff < 0)
-		soff += vgacon_scrollback_size;
-
-	count = vgacon_scrollback_cnt - start;
-
-	if (count > c->vc_rows)
-		count = c->vc_rows;
-
-	if (count) {
-		int copysize;
-
-		int diff = c->vc_rows - count;
-		void *d = (void *) c->vc_origin;
-		void *s = (void *) c->vc_screenbuf;
-
-		count *= c->vc_size_row;
-		/* how much memory to end of buffer left? */
-		copysize = min(count, vgacon_scrollback_size - soff);
-		scr_memcpyw(d, vgacon_scrollback + soff, copysize);
-		d += copysize;
-		count -= copysize;
-
-		if (count) {
-			scr_memcpyw(d, vgacon_scrollback, count);
-			d += count;
-		}
-
-		if (diff)
-			scr_memcpyw(d, s, diff * c->vc_size_row);
-	} else
-		vgacon_cursor(c, CM_MOVE);
-
-	return 1;
-}
-#else
-#define vgacon_scrollback_startup(...) do { } while (0)
-#define vgacon_scrollback_init(...)    do { } while (0)
-#define vgacon_scrollback_update(...)  do { } while (0)
-
 static void vgacon_restore_screen(struct vc_data *c)
 {
 	if (c->vc_origin != c->vc_visible_origin)
@@ -369,7 +216,6 @@ static int vgacon_scrolldelta(struct vc_
 	vga_set_mem_top(c);
 	return 1;
 }
-#endif /* CONFIG_VGACON_SOFT_SCROLLBACK */
 
 static const char *vgacon_startup(void)
 {
@@ -566,10 +412,7 @@ static const char *vgacon_startup(void)
 	vgacon_xres = screen_info.orig_video_cols * VGA_FONTWIDTH;
 	vgacon_yres = vga_scan_lines;
 
-	if (!vga_init_done) {
-		vgacon_scrollback_startup();
-		vga_init_done = 1;
-	}
+	vga_init_done = 1;
 
 	return display_desc;
 }
@@ -865,7 +708,6 @@ static int vgacon_switch(struct vc_data
 			vgacon_doresize(c, c->vc_cols, c->vc_rows);
 	}
 
-	vgacon_scrollback_init(c->vc_size_row);
 	return 0;		/* Redrawing not needed */
 }
 
@@ -1398,7 +1240,6 @@ static int vgacon_scroll(struct vc_data
 	oldo = c->vc_origin;
 	delta = lines * c->vc_size_row;
 	if (dir == SM_UP) {
-		vgacon_scrollback_update(c, t, lines);
 		if (c->vc_scr_end + delta >= vga_vram_end) {
 			scr_memcpyw((u16 *) vga_vram_base,
 				    (u16 *) (oldo + delta),


