Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25D7019B3F1
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387747AbgDAQ1s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:27:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:52692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387513AbgDAQ1p (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:27:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4702C20857;
        Wed,  1 Apr 2020 16:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585758464;
        bh=Wrk9OXZgPsOQlw2xzX5W6GJYysO13Yr7y4wFC6R2q4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E/VVwZL5cmNZP0JhmEIHNBPYXYxMQ2VCzykcf+aLck23JYkHcQ5fp91lyPqH04br4
         lb4D19hEUYTrZDwDDLkErB/3/BCIR8fAFnVFke4PLIiSnRNkSUU+9qhRiqsoQziz3C
         rmv4ItiiweWbSUppjsYhxjYpHkZndcDOrhOA3t7I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 4.19 098/116] vt: selection, introduce vc_is_sel
Date:   Wed,  1 Apr 2020 18:17:54 +0200
Message-Id: <20200401161554.871695334@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161542.669484650@linuxfoundation.org>
References: <20200401161542.669484650@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>

commit dce05aa6eec977f1472abed95ccd71276b9a3864 upstream.

Avoid global variables (namely sel_cons) by introducing vc_is_sel. It
checks whether the parameter is the current selection console. This will
help putting sel_cons to a struct later.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Link: https://lore.kernel.org/r/20200219073951.16151-1-jslaby@suse.cz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/vt/selection.c |    5 +++++
 drivers/tty/vt/vt.c        |    7 ++++---
 drivers/tty/vt/vt_ioctl.c  |    2 +-
 include/linux/selection.h  |    4 +++-
 4 files changed, 13 insertions(+), 5 deletions(-)

--- a/drivers/tty/vt/selection.c
+++ b/drivers/tty/vt/selection.c
@@ -85,6 +85,11 @@ void clear_selection(void)
 	}
 }
 
+bool vc_is_sel(struct vc_data *vc)
+{
+	return vc == sel_cons;
+}
+
 /*
  * User settable table: what characters are to be considered alphabetic?
  * 128 bits. Locked by the console lock.
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -890,8 +890,9 @@ static void hide_softcursor(struct vc_da
 
 static void hide_cursor(struct vc_data *vc)
 {
-	if (vc == sel_cons)
+	if (vc_is_sel(vc))
 		clear_selection();
+
 	vc->vc_sw->con_cursor(vc, CM_ERASE);
 	hide_softcursor(vc);
 }
@@ -901,7 +902,7 @@ static void set_cursor(struct vc_data *v
 	if (!con_is_fg(vc) || console_blanked || vc->vc_mode == KD_GRAPHICS)
 		return;
 	if (vc->vc_deccm) {
-		if (vc == sel_cons)
+		if (vc_is_sel(vc))
 			clear_selection();
 		add_softcursor(vc);
 		if ((vc->vc_cursor_type & 0x0f) != 1)
@@ -1210,7 +1211,7 @@ static int vc_do_resize(struct tty_struc
 		}
 	}
 
-	if (vc == sel_cons)
+	if (vc_is_sel(vc))
 		clear_selection();
 
 	old_rows = vc->vc_rows;
--- a/drivers/tty/vt/vt_ioctl.c
+++ b/drivers/tty/vt/vt_ioctl.c
@@ -43,7 +43,7 @@ char vt_dont_switch;
 extern struct tty_driver *console_driver;
 
 #define VT_IS_IN_USE(i)	(console_driver->ttys[i] && console_driver->ttys[i]->count)
-#define VT_BUSY(i)	(VT_IS_IN_USE(i) || i == fg_console || vc_cons[i].d == sel_cons)
+#define VT_BUSY(i)	(VT_IS_IN_USE(i) || i == fg_console || vc_is_sel(vc_cons[i].d))
 
 /*
  * Console (vt and kd) routines, as defined by USL SVR4 manual, and by
--- a/include/linux/selection.h
+++ b/include/linux/selection.h
@@ -13,8 +13,8 @@
 
 struct tty_struct;
 
-extern struct vc_data *sel_cons;
 struct tty_struct;
+struct vc_data;
 
 extern void clear_selection(void);
 extern int set_selection(const struct tiocl_selection __user *sel, struct tty_struct *tty);
@@ -23,6 +23,8 @@ extern int sel_loadlut(char __user *p);
 extern int mouse_reporting(void);
 extern void mouse_report(struct tty_struct * tty, int butt, int mrx, int mry);
 
+bool vc_is_sel(struct vc_data *vc);
+
 extern int console_blanked;
 
 extern const unsigned char color_table[];


