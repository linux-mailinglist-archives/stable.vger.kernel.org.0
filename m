Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DFFC4ABCB0
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:49:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387040AbiBGLis (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:38:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385695AbiBGLcK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:32:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84375C0401D8;
        Mon,  7 Feb 2022 03:32:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 210BB60B20;
        Mon,  7 Feb 2022 11:32:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC198C004E1;
        Mon,  7 Feb 2022 11:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233528;
        bh=rfau10TEWfiRA3xex5IvwTz7/kPBt7AmT1dqmMihsZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zcUvSGDV8WNj9Lr4YtbROblNVLFGC8ArxuZon2AAWURDoRDe8194UHlbh+43kZf07
         62vaysUWPEVroYkHSqT2WiyZ6vHaYY755hArTI0iYrRCxkbjTBKBboqD48eCDyJT4s
         kkgHsYEOievQ6ikcZ3Nga9LNayBrBXSK60JxwIak=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sven Schnelle <svens@stackframe.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 5.16 040/126] Revert "fbcon: Disable accelerated scrolling"
Date:   Mon,  7 Feb 2022 12:06:11 +0100
Message-Id: <20220207103805.511971144@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103804.053675072@linuxfoundation.org>
References: <20220207103804.053675072@linuxfoundation.org>
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

commit 87ab9f6b7417349aa197a6c7098d4fdd4beebb74 upstream.

This reverts commit 39aead8373b3c20bb5965c024dfb51a94e526151.

Revert the first (of 2) commits which disabled scrolling acceleration in
fbcon/fbdev.  It introduced a regression for fbdev-supported graphic cards
because of the performance penalty by doing screen scrolling by software
instead of using the existing graphic card 2D hardware acceleration.

Console scrolling acceleration was disabled by dropping code which
checked at runtime the driver hardware capabilities for the
BINFO_HWACCEL_COPYAREA or FBINFO_HWACCEL_FILLRECT flags and if set, it
enabled scrollmode SCROLL_MOVE which uses hardware acceleration to move
screen contents.  After dropping those checks scrollmode was hard-wired
to SCROLL_REDRAW instead, which forces all graphic cards to redraw every
character at the new screen position when scrolling.

This change effectively disabled all hardware-based scrolling acceleration for
ALL drivers, because now all kind of 2D hardware acceleration (bitblt,
fillrect) in the drivers isn't used any longer.

The original commit message mentions that only 3 DRM drivers (nouveau, omapdrm
and gma500) used hardware acceleration in the past and thus code for checking
and using scrolling acceleration is obsolete.

This statement is NOT TRUE, because beside the DRM drivers there are around 35
other fbdev drivers which depend on fbdev/fbcon and still provide hardware
acceleration for fbdev/fbcon.

The original commit message also states that syzbot found lots of bugs in fbcon
and thus it's "often the solution to just delete code and remove features".
This is true, and the bugs - which actually affected all users of fbcon,
including DRM - were fixed, or code was dropped like e.g. the support for
software scrollback in vgacon (commit 973c096f6a85).

So to further analyze which bugs were found by syzbot, I've looked through all
patches in drivers/video which were tagged with syzbot or syzkaller back to
year 2005. The vast majority fixed the reported issues on a higher level, e.g.
when screen is to be resized, or when font size is to be changed. The few ones
which touched driver code fixed a real driver bug, e.g. by adding a check.

But NONE of those patches touched code of either the SCROLL_MOVE or the
SCROLL_REDRAW case.

That means, there was no real reason why SCROLL_MOVE had to be ripped-out and
just SCROLL_REDRAW had to be used instead. The only reason I can imagine so far
was that SCROLL_MOVE wasn't used by DRM and as such it was assumed that it
could go away. That argument completely missed the fact that SCROLL_MOVE is
still heavily used by fbdev (non-DRM) drivers.

Some people mention that using memcpy() instead of the hardware acceleration is
pretty much the same speed. But that's not true, at least not for older graphic
cards and machines where we see speed decreases by factor 10 and more and thus
this change leads to console responsiveness way worse than before.

That's why the original commit is to be reverted. By reverting we
reintroduce hardware-based scrolling acceleration and fix the
performance regression for fbdev drivers.

There isn't any impact on DRM when reverting those patches.

Signed-off-by: Helge Deller <deller@gmx.de>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Sven Schnelle <svens@stackframe.org>
Cc: stable@vger.kernel.org # v5.10+
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20220202135531.92183-3-deller@gmx.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/gpu/todo.rst       |   21 ------------------
 drivers/video/fbdev/core/fbcon.c |   45 ++++++++++++++++++++++++++++++++-------
 2 files changed, 37 insertions(+), 29 deletions(-)

--- a/Documentation/gpu/todo.rst
+++ b/Documentation/gpu/todo.rst
@@ -311,27 +311,6 @@ Contact: Daniel Vetter, Noralf Tronnes
 
 Level: Advanced
 
-Garbage collect fbdev scrolling acceleration
---------------------------------------------
-
-Scroll acceleration is disabled in fbcon by hard-wiring p->scrollmode =
-SCROLL_REDRAW. There's a ton of code this will allow us to remove:
-
-- lots of code in fbcon.c
-
-- a bunch of the hooks in fbcon_ops, maybe the remaining hooks could be called
-  directly instead of the function table (with a switch on p->rotate)
-
-- fb_copyarea is unused after this, and can be deleted from all drivers
-
-Note that not all acceleration code can be deleted, since clearing and cursor
-support is still accelerated, which might be good candidates for further
-deletion projects.
-
-Contact: Daniel Vetter
-
-Level: Intermediate
-
 idr_init_base()
 ---------------
 
--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -1025,7 +1025,7 @@ static void fbcon_init(struct vc_data *v
 	struct vc_data *svc = *default_mode;
 	struct fbcon_display *t, *p = &fb_display[vc->vc_num];
 	int logo = 1, new_rows, new_cols, rows, cols;
-	int ret;
+	int cap, ret;
 
 	if (WARN_ON(info_idx == -1))
 	    return;
@@ -1034,6 +1034,7 @@ static void fbcon_init(struct vc_data *v
 		con2fb_map[vc->vc_num] = info_idx;
 
 	info = registered_fb[con2fb_map[vc->vc_num]];
+	cap = info->flags;
 
 	if (logo_shown < 0 && console_loglevel <= CONSOLE_LOGLEVEL_QUIET)
 		logo_shown = FBCON_LOGO_DONTSHOW;
@@ -1135,13 +1136,11 @@ static void fbcon_init(struct vc_data *v
 
 	ops->graphics = 0;
 
-	/*
-	 * No more hw acceleration for fbcon.
-	 *
-	 * FIXME: Garbage collect all the now dead code after sufficient time
-	 * has passed.
-	 */
-	p->scrollmode = SCROLL_REDRAW;
+	if ((cap & FBINFO_HWACCEL_COPYAREA) &&
+	    !(cap & FBINFO_HWACCEL_DISABLED))
+		p->scrollmode = SCROLL_MOVE;
+	else /* default to something safe */
+		p->scrollmode = SCROLL_REDRAW;
 
 	/*
 	 *  ++guenther: console.c:vc_allocate() relies on initializing
@@ -1953,15 +1952,45 @@ static void updatescrollmode(struct fbco
 {
 	struct fbcon_ops *ops = info->fbcon_par;
 	int fh = vc->vc_font.height;
+	int cap = info->flags;
+	u16 t = 0;
+	int ypan = FBCON_SWAP(ops->rotate, info->fix.ypanstep,
+				  info->fix.xpanstep);
+	int ywrap = FBCON_SWAP(ops->rotate, info->fix.ywrapstep, t);
 	int yres = FBCON_SWAP(ops->rotate, info->var.yres, info->var.xres);
 	int vyres = FBCON_SWAP(ops->rotate, info->var.yres_virtual,
 				   info->var.xres_virtual);
+	int good_pan = (cap & FBINFO_HWACCEL_YPAN) &&
+		divides(ypan, vc->vc_font.height) && vyres > yres;
+	int good_wrap = (cap & FBINFO_HWACCEL_YWRAP) &&
+		divides(ywrap, vc->vc_font.height) &&
+		divides(vc->vc_font.height, vyres) &&
+		divides(vc->vc_font.height, yres);
+	int reading_fast = cap & FBINFO_READS_FAST;
+	int fast_copyarea = (cap & FBINFO_HWACCEL_COPYAREA) &&
+		!(cap & FBINFO_HWACCEL_DISABLED);
+	int fast_imageblit = (cap & FBINFO_HWACCEL_IMAGEBLIT) &&
+		!(cap & FBINFO_HWACCEL_DISABLED);
 
 	p->vrows = vyres/fh;
 	if (yres > (fh * (vc->vc_rows + 1)))
 		p->vrows -= (yres - (fh * vc->vc_rows)) / fh;
 	if ((yres % fh) && (vyres % fh < yres % fh))
 		p->vrows--;
+
+	if (good_wrap || good_pan) {
+		if (reading_fast || fast_copyarea)
+			p->scrollmode = good_wrap ?
+				SCROLL_WRAP_MOVE : SCROLL_PAN_MOVE;
+		else
+			p->scrollmode = good_wrap ? SCROLL_REDRAW :
+				SCROLL_PAN_REDRAW;
+	} else {
+		if (reading_fast || (fast_copyarea && !fast_imageblit))
+			p->scrollmode = SCROLL_MOVE;
+		else
+			p->scrollmode = SCROLL_REDRAW;
+	}
 }
 
 #define PITCH(w) (((w) + 7) >> 3)


