Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D56F171B81
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:03:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733231AbgB0ODA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:03:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:37964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733239AbgB0OC7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:02:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4CF7021556;
        Thu, 27 Feb 2020 14:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812177;
        bh=HnHBsupfmC2HjE7tBAwdjVnpc/KCha0vmnjyMlZrWGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X+rGMASAOlBmBSMaRnZeXIMEJQgnq3NSoa28k4MuITBBhQvEx81vHqPfrsxbpPd+u
         Mmhpx6KfWNEGTICQSsXowC5GIo5dPOj1PzeV461wyhO7E/ZMVRFd+YJ5vHgAEy0Y8q
         zh5WcoYz6KOKlBR9cvulS9TOVSgBrOx8MiJ3NteI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        syzbot+59997e8d5cbdc486e6f6@syzkaller.appspotmail.com
Subject: [PATCH 4.19 15/97] vt: selection, close sel_buffer race
Date:   Thu, 27 Feb 2020 14:36:23 +0100
Message-Id: <20200227132217.117431951@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132214.553656188@linuxfoundation.org>
References: <20200227132214.553656188@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>

commit 07e6124a1a46b4b5a9b3cacc0c306b50da87abf5 upstream.

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
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200210081131.23572-2-jslaby@suse.cz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/vt/selection.c |   23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

--- a/drivers/tty/vt/selection.c
+++ b/drivers/tty/vt/selection.c
@@ -14,6 +14,7 @@
 #include <linux/tty.h>
 #include <linux/sched.h>
 #include <linux/mm.h>
+#include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/types.h>
 
@@ -43,6 +44,7 @@ static volatile int sel_start = -1; 	/*
 static int sel_end;
 static int sel_buffer_lth;
 static char *sel_buffer;
+static DEFINE_MUTEX(sel_lock);
 
 /* clear_selection, highlight and highlight_pointer can be called
    from interrupt (via scrollback/front) */
@@ -173,7 +175,7 @@ int set_selection(const struct tiocl_sel
 	char *bp, *obp;
 	int i, ps, pe, multiplier;
 	u32 c;
-	int mode;
+	int mode, ret = 0;
 
 	poke_blanked_console();
 	if (copy_from_user(&v, sel, sizeof(*sel)))
@@ -200,6 +202,7 @@ int set_selection(const struct tiocl_sel
 	if (ps > pe)	/* make sel_start <= sel_end */
 		swap(ps, pe);
 
+	mutex_lock(&sel_lock);
 	if (sel_cons != vc_cons[fg_console].d) {
 		clear_selection();
 		sel_cons = vc_cons[fg_console].d;
@@ -245,9 +248,10 @@ int set_selection(const struct tiocl_sel
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
@@ -269,7 +273,7 @@ int set_selection(const struct tiocl_sel
 	else if (new_sel_start == sel_start)
 	{
 		if (new_sel_end == sel_end)	/* no action required */
-			return 0;
+			goto unlock;
 		else if (new_sel_end > sel_end)	/* extend to right */
 			highlight(sel_end + 2, new_sel_end);
 		else				/* contract from right */
@@ -297,7 +301,8 @@ int set_selection(const struct tiocl_sel
 	if (!bp) {
 		printk(KERN_WARNING "selection: kmalloc() failed\n");
 		clear_selection();
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto unlock;
 	}
 	kfree(sel_buffer);
 	sel_buffer = bp;
@@ -322,7 +327,9 @@ int set_selection(const struct tiocl_sel
 		}
 	}
 	sel_buffer_lth = bp - sel_buffer;
-	return 0;
+unlock:
+	mutex_unlock(&sel_lock);
+	return ret;
 }
 
 /* Insert the contents of the selection buffer into the
@@ -351,6 +358,7 @@ int paste_selection(struct tty_struct *t
 	tty_buffer_lock_exclusive(&vc->port);
 
 	add_wait_queue(&vc->paste_wait, &wait);
+	mutex_lock(&sel_lock);
 	while (sel_buffer && sel_buffer_lth > pasted) {
 		set_current_state(TASK_INTERRUPTIBLE);
 		if (signal_pending(current)) {
@@ -358,7 +366,9 @@ int paste_selection(struct tty_struct *t
 			break;
 		}
 		if (tty_throttled(tty)) {
+			mutex_unlock(&sel_lock);
 			schedule();
+			mutex_lock(&sel_lock);
 			continue;
 		}
 		__set_current_state(TASK_RUNNING);
@@ -367,6 +377,7 @@ int paste_selection(struct tty_struct *t
 					      count);
 		pasted += count;
 	}
+	mutex_unlock(&sel_lock);
 	remove_wait_queue(&vc->paste_wait, &wait);
 	__set_current_state(TASK_RUNNING);
 


