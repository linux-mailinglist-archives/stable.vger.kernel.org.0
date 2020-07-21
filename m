Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E39C2284E2
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 18:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728156AbgGUQH2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jul 2020 12:07:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:52306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726919AbgGUQH1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Jul 2020 12:07:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9EE002073A;
        Tue, 21 Jul 2020 16:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595347647;
        bh=3b3IMJRuuf23i0DcwCCGjMPmC/1pk8aArLOsuDAkxDc=;
        h=Subject:To:From:Date:From;
        b=JOfPgTLFmsOjk1cmKuaqJDK2nRLAc10wyFSG9Ws2BGA8IUwvB/0kimyLpOyj1UYWi
         1wf01DQaHi59qLZK8t48LqKcn+7iXWNPtwLZ3RKAug6lRs6llSyp4vDKoSrOsdSPWf
         jlQGq+gX3ZLM6Uflo/CT+E+y/QZmEoToFYEApA58=
Subject: patch "vt: Reject zero-sized screen buffer size." added to tty-linus
To:     penguin-kernel@I-love.SAKURA.ne.jp, gregkh@linuxfoundation.org,
        stable@vger.kernel.org,
        syzbot+017265e8553724e514e8@syzkaller.appspotmail.com
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 21 Jul 2020 18:07:35 +0200
Message-ID: <1595347655245173@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    vt: Reject zero-sized screen buffer size.

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From ce684552a266cb1c7cc2f7e623f38567adec6653 Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Sun, 12 Jul 2020 20:10:12 +0900
Subject: vt: Reject zero-sized screen buffer size.

syzbot is reporting general protection fault in do_con_write() [1] caused
by vc->vc_screenbuf == ZERO_SIZE_PTR caused by vc->vc_screenbuf_size == 0
caused by vc->vc_cols == vc->vc_rows == vc->vc_size_row == 0 caused by
fb_set_var() from ioctl(FBIOPUT_VSCREENINFO) on /dev/fb0 , for
gotoxy(vc, 0, 0) from reset_terminal() from vc_init() from vc_allocate()
 from con_install() from tty_init_dev() from tty_open() on such console
causes vc->vc_pos == 0x10000000e due to
((unsigned long) ZERO_SIZE_PTR) + -1U * 0 + (-1U << 1).

I don't think that a console with 0 column or 0 row makes sense. And it
seems that vc_do_resize() does not intend to allow resizing a console to
0 column or 0 row due to

  new_cols = (cols ? cols : vc->vc_cols);
  new_rows = (lines ? lines : vc->vc_rows);

exception.

Theoretically, cols and rows can be any range as long as
0 < cols * rows * 2 <= KMALLOC_MAX_SIZE is satisfied (e.g.
cols == 1048576 && rows == 2 is possible) because of

  vc->vc_size_row = vc->vc_cols << 1;
  vc->vc_screenbuf_size = vc->vc_rows * vc->vc_size_row;

in visual_init() and kzalloc(vc->vc_screenbuf_size) in vc_allocate().

Since we can detect cols == 0 or rows == 0 via screenbuf_size = 0 in
visual_init(), we can reject kzalloc(0). Then, vc_allocate() will return
an error, and con_write() will not be called on a console with 0 column
or 0 row.

We need to make sure that integer overflow in visual_init() won't happen.
Since vc_do_resize() restricts cols <= 32767 and rows <= 32767, applying
1 <= cols <= 32767 and 1 <= rows <= 32767 restrictions to vc_allocate()
will be practically fine.

This patch does not touch con_init(), for returning -EINVAL there
does not help when we are not returning -ENOMEM.

[1] https://syzkaller.appspot.com/bug?extid=017265e8553724e514e8

Reported-and-tested-by: syzbot <syzbot+017265e8553724e514e8@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200712111013.11881-1-penguin-kernel@I-love.SAKURA.ne.jp
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vt/vt.c | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 48a8199f7845..42d8c67a481f 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -1092,10 +1092,19 @@ static const struct tty_port_operations vc_port_ops = {
 	.destruct = vc_port_destruct,
 };
 
+/*
+ * Change # of rows and columns (0 means unchanged/the size of fg_console)
+ * [this is to be used together with some user program
+ * like resize that changes the hardware videomode]
+ */
+#define VC_MAXCOL (32767)
+#define VC_MAXROW (32767)
+
 int vc_allocate(unsigned int currcons)	/* return 0 on success */
 {
 	struct vt_notifier_param param;
 	struct vc_data *vc;
+	int err;
 
 	WARN_CONSOLE_UNLOCKED();
 
@@ -1125,6 +1134,11 @@ int vc_allocate(unsigned int currcons)	/* return 0 on success */
 	if (!*vc->vc_uni_pagedir_loc)
 		con_set_default_unimap(vc);
 
+	err = -EINVAL;
+	if (vc->vc_cols > VC_MAXCOL || vc->vc_rows > VC_MAXROW ||
+	    vc->vc_screenbuf_size > KMALLOC_MAX_SIZE || !vc->vc_screenbuf_size)
+		goto err_free;
+	err = -ENOMEM;
 	vc->vc_screenbuf = kzalloc(vc->vc_screenbuf_size, GFP_KERNEL);
 	if (!vc->vc_screenbuf)
 		goto err_free;
@@ -1143,7 +1157,7 @@ int vc_allocate(unsigned int currcons)	/* return 0 on success */
 	visual_deinit(vc);
 	kfree(vc);
 	vc_cons[currcons].d = NULL;
-	return -ENOMEM;
+	return err;
 }
 
 static inline int resize_screen(struct vc_data *vc, int width, int height,
@@ -1158,14 +1172,6 @@ static inline int resize_screen(struct vc_data *vc, int width, int height,
 	return err;
 }
 
-/*
- * Change # of rows and columns (0 means unchanged/the size of fg_console)
- * [this is to be used together with some user program
- * like resize that changes the hardware videomode]
- */
-#define VC_RESIZE_MAXCOL (32767)
-#define VC_RESIZE_MAXROW (32767)
-
 /**
  *	vc_do_resize	-	resizing method for the tty
  *	@tty: tty being resized
@@ -1201,7 +1207,7 @@ static int vc_do_resize(struct tty_struct *tty, struct vc_data *vc,
 	user = vc->vc_resize_user;
 	vc->vc_resize_user = 0;
 
-	if (cols > VC_RESIZE_MAXCOL || lines > VC_RESIZE_MAXROW)
+	if (cols > VC_MAXCOL || lines > VC_MAXROW)
 		return -EINVAL;
 
 	new_cols = (cols ? cols : vc->vc_cols);
@@ -1212,7 +1218,7 @@ static int vc_do_resize(struct tty_struct *tty, struct vc_data *vc,
 	if (new_cols == vc->vc_cols && new_rows == vc->vc_rows)
 		return 0;
 
-	if (new_screen_size > KMALLOC_MAX_SIZE)
+	if (new_screen_size > KMALLOC_MAX_SIZE || !new_screen_size)
 		return -EINVAL;
 	newscreen = kzalloc(new_screen_size, GFP_USER);
 	if (!newscreen)
@@ -3393,6 +3399,7 @@ static int __init con_init(void)
 		INIT_WORK(&vc_cons[currcons].SAK_work, vc_SAK);
 		tty_port_init(&vc->port);
 		visual_init(vc, currcons, 1);
+		/* Assuming vc->vc_{cols,rows,screenbuf_size} are sane here. */
 		vc->vc_screenbuf = kzalloc(vc->vc_screenbuf_size, GFP_NOWAIT);
 		vc_init(vc, vc->vc_rows, vc->vc_cols,
 			currcons || !vc->vc_sw->con_save_screen);
-- 
2.27.0


