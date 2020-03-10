Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4F917FDB2
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:29:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727059AbgCJN3b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:29:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:56988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728951AbgCJMvm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:51:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C5002468F;
        Tue, 10 Mar 2020 12:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844701;
        bh=y0UAmrvUmkyxgD5jPwVeJBdvYogkBm6vnteCiZOpYhg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q1S+DPl2Hu4znXAy480/7N4B3/Hw4Ut79FHM5bDTxH9fRFh09/2DxUDvQv2z1IuOD
         aO5tXicL2CNczKX17qixQ1DGnoYdOdWw88sJGzfMld7b6DVg4hoXJeAJtLvqXpJG/j
         cnw+2vFr2WTTPccuZ6Flhvb5Zy4+qhzagM9PndI8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        syzbot+26183d9746e62da329b8@syzkaller.appspotmail.com
Subject: [PATCH 5.4 087/168] vt: selection, push sel_lock up
Date:   Tue, 10 Mar 2020 13:38:53 +0100
Message-Id: <20200310123644.079003475@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123635.322799692@linuxfoundation.org>
References: <20200310123635.322799692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>

commit e8c75a30a23c6ba63f4ef6895cbf41fd42f21aa2 upstream.

sel_lock cannot nest in the console lock. Thanks to syzkaller, the
kernel states firmly:

> WARNING: possible circular locking dependency detected
> 5.6.0-rc3-syzkaller #0 Not tainted
> ------------------------------------------------------
> syz-executor.4/20336 is trying to acquire lock:
> ffff8880a2e952a0 (&tty->termios_rwsem){++++}, at: tty_unthrottle+0x22/0x100 drivers/tty/tty_ioctl.c:136
>
> but task is already holding lock:
> ffffffff89462e70 (sel_lock){+.+.}, at: paste_selection+0x118/0x470 drivers/tty/vt/selection.c:374
>
> which lock already depends on the new lock.
>
> the existing dependency chain (in reverse order) is:
>
> -> #2 (sel_lock){+.+.}:
>        mutex_lock_nested+0x1b/0x30 kernel/locking/mutex.c:1118
>        set_selection_kernel+0x3b8/0x18a0 drivers/tty/vt/selection.c:217
>        set_selection_user+0x63/0x80 drivers/tty/vt/selection.c:181
>        tioclinux+0x103/0x530 drivers/tty/vt/vt.c:3050
>        vt_ioctl+0x3f1/0x3a30 drivers/tty/vt/vt_ioctl.c:364

This is ioctl(TIOCL_SETSEL).
Locks held on the path: console_lock -> sel_lock

> -> #1 (console_lock){+.+.}:
>        console_lock+0x46/0x70 kernel/printk/printk.c:2289
>        con_flush_chars+0x50/0x650 drivers/tty/vt/vt.c:3223
>        n_tty_write+0xeae/0x1200 drivers/tty/n_tty.c:2350
>        do_tty_write drivers/tty/tty_io.c:962 [inline]
>        tty_write+0x5a1/0x950 drivers/tty/tty_io.c:1046

This is write().
Locks held on the path: termios_rwsem -> console_lock

> -> #0 (&tty->termios_rwsem){++++}:
>        down_write+0x57/0x140 kernel/locking/rwsem.c:1534
>        tty_unthrottle+0x22/0x100 drivers/tty/tty_ioctl.c:136
>        mkiss_receive_buf+0x12aa/0x1340 drivers/net/hamradio/mkiss.c:902
>        tty_ldisc_receive_buf+0x12f/0x170 drivers/tty/tty_buffer.c:465
>        paste_selection+0x346/0x470 drivers/tty/vt/selection.c:389
>        tioclinux+0x121/0x530 drivers/tty/vt/vt.c:3055
>        vt_ioctl+0x3f1/0x3a30 drivers/tty/vt/vt_ioctl.c:364

This is ioctl(TIOCL_PASTESEL).
Locks held on the path: sel_lock -> termios_rwsem

> other info that might help us debug this:
>
> Chain exists of:
>   &tty->termios_rwsem --> console_lock --> sel_lock

Clearly. From the above, we have:
 console_lock -> sel_lock
 sel_lock -> termios_rwsem
 termios_rwsem -> console_lock

Fix this by reversing the console_lock -> sel_lock dependency in
ioctl(TIOCL_SETSEL). First, lock sel_lock, then console_lock.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Reported-by: syzbot+26183d9746e62da329b8@syzkaller.appspotmail.com
Fixes: 07e6124a1a46 ("vt: selection, close sel_buffer race")
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200228115406.5735-2-jslaby@suse.cz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/vt/selection.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

--- a/drivers/tty/vt/selection.c
+++ b/drivers/tty/vt/selection.c
@@ -214,7 +214,6 @@ static int __set_selection_kernel(struct
 	if (ps > pe)	/* make sel_start <= sel_end */
 		swap(ps, pe);
 
-	mutex_lock(&sel_lock);
 	if (sel_cons != vc_cons[fg_console].d) {
 		clear_selection();
 		sel_cons = vc_cons[fg_console].d;
@@ -260,10 +259,9 @@ static int __set_selection_kernel(struct
 			break;
 		case TIOCL_SELPOINTER:
 			highlight_pointer(pe);
-			goto unlock;
+			return 0;
 		default:
-			ret = -EINVAL;
-			goto unlock;
+			return -EINVAL;
 	}
 
 	/* remove the pointer */
@@ -285,7 +283,7 @@ static int __set_selection_kernel(struct
 	else if (new_sel_start == sel_start)
 	{
 		if (new_sel_end == sel_end)	/* no action required */
-			goto unlock;
+			return 0;
 		else if (new_sel_end > sel_end)	/* extend to right */
 			highlight(sel_end + 2, new_sel_end);
 		else				/* contract from right */
@@ -313,8 +311,7 @@ static int __set_selection_kernel(struct
 	if (!bp) {
 		printk(KERN_WARNING "selection: kmalloc() failed\n");
 		clear_selection();
-		ret = -ENOMEM;
-		goto unlock;
+		return -ENOMEM;
 	}
 	kfree(sel_buffer);
 	sel_buffer = bp;
@@ -339,8 +336,7 @@ static int __set_selection_kernel(struct
 		}
 	}
 	sel_buffer_lth = bp - sel_buffer;
-unlock:
-	mutex_unlock(&sel_lock);
+
 	return ret;
 }
 
@@ -348,9 +344,11 @@ int set_selection_kernel(struct tiocl_se
 {
 	int ret;
 
+	mutex_lock(&sel_lock);
 	console_lock();
 	ret = __set_selection_kernel(v, tty);
 	console_unlock();
+	mutex_unlock(&sel_lock);
 
 	return ret;
 }


