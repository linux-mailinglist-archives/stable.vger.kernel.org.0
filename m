Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42697272C6E
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728424AbgIUQcQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:32:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:57558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728417AbgIUQcN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:32:13 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6AAE620757;
        Mon, 21 Sep 2020 16:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600705933;
        bh=HfncYKPwYgNi3iCxwvWGSC58k36zuKOdf/HdWoFv6rk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SjKnz1E3xVUoNYXqoFbfFc6dHXYEPmuIGvRJfuHcmbnVuX2LNz7rsjeFYXsh5/vh9
         sXQrJ5x/La7gTjAN01ydAm3FObqp8F+TPnT30sev8g8KEPt2DzMn34ImwWQDQA2qlm
         DOOpM882hSuYrpbTbWdVHQxF1kqnosR50K7j9Dzs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yuan Ming <yuanmingbuaa@gmail.com>,
        Willy Tarreau <w@1wt.eu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.4 21/46] fbcon: remove now unusued softback_lines cursor() argument
Date:   Mon, 21 Sep 2020 18:27:37 +0200
Message-Id: <20200921162034.298075856@linuxfoundation.org>
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

commit 06a0df4d1b8b13b551668e47b11fd7629033b7df upstream.

Since the softscroll code got removed, this argument is always zero and
makes no sense any more.

Tested-by: Yuan Ming <yuanmingbuaa@gmail.com>
Tested-by: Willy Tarreau <w@1wt.eu>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/video/console/bitblit.c   |   11 +----------
 drivers/video/console/fbcon.c     |    4 ++--
 drivers/video/console/fbcon.h     |    2 +-
 drivers/video/console/fbcon_ccw.c |   11 +----------
 drivers/video/console/fbcon_cw.c  |   11 +----------
 drivers/video/console/fbcon_ud.c  |   11 +----------
 drivers/video/console/tileblit.c  |    2 +-
 7 files changed, 8 insertions(+), 44 deletions(-)

--- a/drivers/video/console/bitblit.c
+++ b/drivers/video/console/bitblit.c
@@ -234,7 +234,7 @@ static void bit_clear_margins(struct vc_
 }
 
 static void bit_cursor(struct vc_data *vc, struct fb_info *info, int mode,
-		       int softback_lines, int fg, int bg)
+		       int fg, int bg)
 {
 	struct fb_cursor cursor;
 	struct fbcon_ops *ops = info->fbcon_par;
@@ -247,15 +247,6 @@ static void bit_cursor(struct vc_data *v
 
 	cursor.set = 0;
 
-	if (softback_lines) {
-		if (y + softback_lines >= vc->vc_rows) {
-			mode = CM_ERASE;
-			ops->cursor_flash = 0;
-			return;
-		} else
-			y += softback_lines;
-	}
-
  	c = scr_readw((u16 *) vc->vc_pos);
 	attribute = get_attribute(info, c);
 	src = vc->vc_font.data + ((c & charmask) * (w * vc->vc_font.height));
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -370,7 +370,7 @@ static void fb_flashcursor(struct work_s
 	c = scr_readw((u16 *) vc->vc_pos);
 	mode = (!ops->cursor_flash || ops->cursor_state.enable) ?
 		CM_ERASE : CM_DRAW;
-	ops->cursor(vc, info, mode, 0, get_color(vc, info, c, 1),
+	ops->cursor(vc, info, mode, get_color(vc, info, c, 1),
 		    get_color(vc, info, c, 0));
 	console_unlock();
 }
@@ -1270,7 +1270,7 @@ static void fbcon_cursor(struct vc_data
 
 	ops->cursor_flash = (mode == CM_ERASE) ? 0 : 1;
 
-	ops->cursor(vc, info, mode, 0, get_color(vc, info, c, 1),
+	ops->cursor(vc, info, mode, get_color(vc, info, c, 1),
 		    get_color(vc, info, c, 0));
 }
 
--- a/drivers/video/console/fbcon.h
+++ b/drivers/video/console/fbcon.h
@@ -62,7 +62,7 @@ struct fbcon_ops {
 	void (*clear_margins)(struct vc_data *vc, struct fb_info *info,
 			      int bottom_only);
 	void (*cursor)(struct vc_data *vc, struct fb_info *info, int mode,
-		       int softback_lines, int fg, int bg);
+		       int fg, int bg);
 	int  (*update_start)(struct fb_info *info);
 	int  (*rotate_font)(struct fb_info *info, struct vc_data *vc);
 	struct fb_var_screeninfo var;  /* copy of the current fb_var_screeninfo */
--- a/drivers/video/console/fbcon_ccw.c
+++ b/drivers/video/console/fbcon_ccw.c
@@ -219,7 +219,7 @@ static void ccw_clear_margins(struct vc_
 }
 
 static void ccw_cursor(struct vc_data *vc, struct fb_info *info, int mode,
-		       int softback_lines, int fg, int bg)
+		       int fg, int bg)
 {
 	struct fb_cursor cursor;
 	struct fbcon_ops *ops = info->fbcon_par;
@@ -236,15 +236,6 @@ static void ccw_cursor(struct vc_data *v
 
 	cursor.set = 0;
 
-	if (softback_lines) {
-		if (y + softback_lines >= vc->vc_rows) {
-			mode = CM_ERASE;
-			ops->cursor_flash = 0;
-			return;
-		} else
-			y += softback_lines;
-	}
-
  	c = scr_readw((u16 *) vc->vc_pos);
 	attribute = get_attribute(info, c);
 	src = ops->fontbuffer + ((c & charmask) * (w * vc->vc_font.width));
--- a/drivers/video/console/fbcon_cw.c
+++ b/drivers/video/console/fbcon_cw.c
@@ -202,7 +202,7 @@ static void cw_clear_margins(struct vc_d
 }
 
 static void cw_cursor(struct vc_data *vc, struct fb_info *info, int mode,
-		      int softback_lines, int fg, int bg)
+		      int fg, int bg)
 {
 	struct fb_cursor cursor;
 	struct fbcon_ops *ops = info->fbcon_par;
@@ -219,15 +219,6 @@ static void cw_cursor(struct vc_data *vc
 
 	cursor.set = 0;
 
-	if (softback_lines) {
-		if (y + softback_lines >= vc->vc_rows) {
-			mode = CM_ERASE;
-			ops->cursor_flash = 0;
-			return;
-		} else
-			y += softback_lines;
-	}
-
  	c = scr_readw((u16 *) vc->vc_pos);
 	attribute = get_attribute(info, c);
 	src = ops->fontbuffer + ((c & charmask) * (w * vc->vc_font.width));
--- a/drivers/video/console/fbcon_ud.c
+++ b/drivers/video/console/fbcon_ud.c
@@ -249,7 +249,7 @@ static void ud_clear_margins(struct vc_d
 }
 
 static void ud_cursor(struct vc_data *vc, struct fb_info *info, int mode,
-		      int softback_lines, int fg, int bg)
+		      int fg, int bg)
 {
 	struct fb_cursor cursor;
 	struct fbcon_ops *ops = info->fbcon_par;
@@ -267,15 +267,6 @@ static void ud_cursor(struct vc_data *vc
 
 	cursor.set = 0;
 
-	if (softback_lines) {
-		if (y + softback_lines >= vc->vc_rows) {
-			mode = CM_ERASE;
-			ops->cursor_flash = 0;
-			return;
-		} else
-			y += softback_lines;
-	}
-
  	c = scr_readw((u16 *) vc->vc_pos);
 	attribute = get_attribute(info, c);
 	src = ops->fontbuffer + ((c & charmask) * (w * vc->vc_font.height));
--- a/drivers/video/console/tileblit.c
+++ b/drivers/video/console/tileblit.c
@@ -80,7 +80,7 @@ static void tile_clear_margins(struct vc
 }
 
 static void tile_cursor(struct vc_data *vc, struct fb_info *info, int mode,
-			int softback_lines, int fg, int bg)
+			int fg, int bg)
 {
 	struct fb_tilecursor cursor;
 	int use_sw = (vc->vc_cursor_type & 0x10);


