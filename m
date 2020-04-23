Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED461B67C9
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:09:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728637AbgDWXG4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:06:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50718 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728627AbgDWXG4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:56 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvi-0004w6-Tf; Fri, 24 Apr 2020 00:06:51 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvd-00E71y-TD; Fri, 24 Apr 2020 00:06:45 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        syzbot+59997e8d5cbdc486e6f6@syzkaller.appspotmail.com,
        "Jiri Slaby" <jslaby@suse.cz>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date:   Fri, 24 Apr 2020 00:07:28 +0100
Message-ID: <lsq.1587683028.869006475@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 221/245] vt: selection, close sel_buffer race
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

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
References: https://bugzilla.kernel.org/show_bug.cgi?id=206361
Link: https://lore.kernel.org/r/20200210081131.23572-2-jslaby@suse.cz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/tty/vt/selection.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

--- a/drivers/tty/vt/selection.c
+++ b/drivers/tty/vt/selection.c
@@ -13,6 +13,7 @@
 #include <linux/tty.h>
 #include <linux/sched.h>
 #include <linux/mm.h>
+#include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/types.h>
 
@@ -40,6 +41,7 @@ static volatile int sel_start = -1; 	/*
 static int sel_end;
 static int sel_buffer_lth;
 static char *sel_buffer;
+static DEFINE_MUTEX(sel_lock);
 
 /* clear_selection, highlight and highlight_pointer can be called
    from interrupt (via scrollback/front) */
@@ -163,7 +165,7 @@ int set_selection(const struct tiocl_sel
 	char *bp, *obp;
 	int i, ps, pe, multiplier;
 	u16 c;
-	int mode;
+	int mode, ret = 0;
 
 	poke_blanked_console();
 
@@ -203,6 +205,7 @@ int set_selection(const struct tiocl_sel
 		pe = tmp;
 	}
 
+	mutex_lock(&sel_lock);
 	if (sel_cons != vc_cons[fg_console].d) {
 		clear_selection();
 		sel_cons = vc_cons[fg_console].d;
@@ -248,9 +251,10 @@ int set_selection(const struct tiocl_sel
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
@@ -272,7 +276,7 @@ int set_selection(const struct tiocl_sel
 	else if (new_sel_start == sel_start)
 	{
 		if (new_sel_end == sel_end)	/* no action required */
-			return 0;
+			goto unlock;
 		else if (new_sel_end > sel_end)	/* extend to right */
 			highlight(sel_end + 2, new_sel_end);
 		else				/* contract from right */
@@ -299,7 +303,8 @@ int set_selection(const struct tiocl_sel
 	if (!bp) {
 		printk(KERN_WARNING "selection: kmalloc() failed\n");
 		clear_selection();
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto unlock;
 	}
 	kfree(sel_buffer);
 	sel_buffer = bp;
@@ -324,7 +329,9 @@ int set_selection(const struct tiocl_sel
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
 		if (test_bit(TTY_THROTTLED, &tty->flags)) {
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
 

