Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A970F15CBBB
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 21:11:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727652AbgBMULh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 15:11:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:51592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728063AbgBMULh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 15:11:37 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D44E5218AC;
        Thu, 13 Feb 2020 20:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581624697;
        bh=RQG9jclqKYZYa0rtoyBmuDpV3VxKdpP9oCnOy2VSmec=;
        h=Subject:To:From:Date:From;
        b=tq84sLuaZjH3CtCkR6klql5UYNnkG8stp0H/cTscCFQtu67uno0M7tqYQNXJchnAf
         nXp3I53j6619Kql87weUrvFglrQwWNOOT6y5auVuIDAPxbVDKJjDl2aRxYqGyHFWGr
         ZqSrKF7Znr15cRzhNSgKjlEh/bxIoA79ogTARaZQ=
Subject: patch "vt: selection, close sel_buffer race" added to tty-linus
To:     jslaby@suse.cz, gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 13 Feb 2020 12:11:36 -0800
Message-ID: <1581624696168183@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    vt: selection, close sel_buffer race

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 07e6124a1a46b4b5a9b3cacc0c306b50da87abf5 Mon Sep 17 00:00:00 2001
From: Jiri Slaby <jslaby@suse.cz>
Date: Mon, 10 Feb 2020 09:11:31 +0100
Subject: vt: selection, close sel_buffer race

syzkaller reported this UAF:
BUG: KASAN: use-after-free in n_tty_receive_buf_common+0x2481/0x2940 drivers/tty/n_tty.c:1741
Read of size 1 at addr ffff8880089e40e9 by task syz-executor.1/13184

CPU: 0 PID: 13184 Comm: syz-executor.1 Not tainted 5.4.7 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
Call Trace:
...
 kasan_report+0xe/0x20 mm/kasan/common.c:634
 n_tty_receive_buf_common+0x2481/0x2940 drivers/tty/n_tty.c:1741
 tty_ldisc_receive_buf+0xac/0x190 drivers/tty/tty_buffer.c:461
 paste_selection+0x297/0x400 drivers/tty/vt/selection.c:372
 tioclinux+0x20d/0x4e0 drivers/tty/vt/vt.c:3044
 vt_ioctl+0x1bcf/0x28d0 drivers/tty/vt/vt_ioctl.c:364
 tty_ioctl+0x525/0x15a0 drivers/tty/tty_io.c:2657
 vfs_ioctl fs/ioctl.c:47 [inline]

It is due to a race between parallel paste_selection (TIOCL_PASTESEL)
and set_selection_user (TIOCL_SETSEL) invocations. One uses sel_buffer,
while the other frees it and reallocates a new one for another
selection. Add a mutex to close this race.

The mutex takes care properly of sel_buffer and sel_buffer_lth only. The
other selection global variables (like sel_start, sel_end, and sel_cons)
are protected only in set_selection_user. The other functions need quite
some more work to close the races of the variables there. This is going
to happen later.

This likely fixes (I am unsure as there is no reproducer provided) bug
206361 too. It was marked as CVE-2020-8648.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Reported-by: syzbot+59997e8d5cbdc486e6f6@syzkaller.appspotmail.com
References: https://bugzilla.kernel.org/show_bug.cgi?id=206361
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200210081131.23572-2-jslaby@suse.cz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vt/selection.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/vt/selection.c b/drivers/tty/vt/selection.c
index 44d974d4159f..0c50d7410b31 100644
--- a/drivers/tty/vt/selection.c
+++ b/drivers/tty/vt/selection.c
@@ -16,6 +16,7 @@
 #include <linux/tty.h>
 #include <linux/sched.h>
 #include <linux/mm.h>
+#include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/types.h>
 
@@ -45,6 +46,7 @@ static volatile int sel_start = -1; 	/* cleared by clear_selection */
 static int sel_end;
 static int sel_buffer_lth;
 static char *sel_buffer;
+static DEFINE_MUTEX(sel_lock);
 
 /* clear_selection, highlight and highlight_pointer can be called
    from interrupt (via scrollback/front) */
@@ -186,7 +188,7 @@ int set_selection_kernel(struct tiocl_selection *v, struct tty_struct *tty)
 	char *bp, *obp;
 	int i, ps, pe, multiplier;
 	u32 c;
-	int mode;
+	int mode, ret = 0;
 
 	poke_blanked_console();
 
@@ -212,6 +214,7 @@ int set_selection_kernel(struct tiocl_selection *v, struct tty_struct *tty)
 	if (ps > pe)	/* make sel_start <= sel_end */
 		swap(ps, pe);
 
+	mutex_lock(&sel_lock);
 	if (sel_cons != vc_cons[fg_console].d) {
 		clear_selection();
 		sel_cons = vc_cons[fg_console].d;
@@ -257,9 +260,10 @@ int set_selection_kernel(struct tiocl_selection *v, struct tty_struct *tty)
 			break;
 		case TIOCL_SELPOINTER:
 			highlight_pointer(pe);
-			return 0;
+			goto unlock;
 		default:
-			return -EINVAL;
+			ret = -EINVAL;
+			goto unlock;
 	}
 
 	/* remove the pointer */
@@ -281,7 +285,7 @@ int set_selection_kernel(struct tiocl_selection *v, struct tty_struct *tty)
 	else if (new_sel_start == sel_start)
 	{
 		if (new_sel_end == sel_end)	/* no action required */
-			return 0;
+			goto unlock;
 		else if (new_sel_end > sel_end)	/* extend to right */
 			highlight(sel_end + 2, new_sel_end);
 		else				/* contract from right */
@@ -309,7 +313,8 @@ int set_selection_kernel(struct tiocl_selection *v, struct tty_struct *tty)
 	if (!bp) {
 		printk(KERN_WARNING "selection: kmalloc() failed\n");
 		clear_selection();
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto unlock;
 	}
 	kfree(sel_buffer);
 	sel_buffer = bp;
@@ -334,7 +339,9 @@ int set_selection_kernel(struct tiocl_selection *v, struct tty_struct *tty)
 		}
 	}
 	sel_buffer_lth = bp - sel_buffer;
-	return 0;
+unlock:
+	mutex_unlock(&sel_lock);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(set_selection_kernel);
 
@@ -364,6 +371,7 @@ int paste_selection(struct tty_struct *tty)
 	tty_buffer_lock_exclusive(&vc->port);
 
 	add_wait_queue(&vc->paste_wait, &wait);
+	mutex_lock(&sel_lock);
 	while (sel_buffer && sel_buffer_lth > pasted) {
 		set_current_state(TASK_INTERRUPTIBLE);
 		if (signal_pending(current)) {
@@ -371,7 +379,9 @@ int paste_selection(struct tty_struct *tty)
 			break;
 		}
 		if (tty_throttled(tty)) {
+			mutex_unlock(&sel_lock);
 			schedule();
+			mutex_lock(&sel_lock);
 			continue;
 		}
 		__set_current_state(TASK_RUNNING);
@@ -380,6 +390,7 @@ int paste_selection(struct tty_struct *tty)
 					      count);
 		pasted += count;
 	}
+	mutex_unlock(&sel_lock);
 	remove_wait_queue(&vc->paste_wait, &wait);
 	__set_current_state(TASK_RUNNING);
 
-- 
2.25.0


