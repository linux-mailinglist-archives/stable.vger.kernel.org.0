Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7091B19B3F4
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387773AbgDAQ2G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:28:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:53220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732965AbgDAQ2F (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:28:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BFA920857;
        Wed,  1 Apr 2020 16:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585758483;
        bh=xEtiESbTIcESJ4xqcCwq5ZZHvMgmrv9aSMzI+0ZLmPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mTk7vT381QIIVWIAV5BYGwWaWHHQVBSikKolHiM7vo+gYadwBK+0ALBpsjMg+FXyG
         l6RRs5j6nkgII71kpM0rJY3SeJ9r8xf3aZ8CBoP1OgBu11LVAW6M37mnwdpDMBufat
         86XjLJ5ur0D2iryv9gbBT4gqBFE4KSZcJNcOzVrY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH 4.19 103/116] vt: vt_ioctl: fix use-after-free in vt_in_use()
Date:   Wed,  1 Apr 2020 18:17:59 +0200
Message-Id: <20200401161555.391066531@linuxfoundation.org>
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

From: Eric Biggers <ebiggers@google.com>

commit 7cf64b18b0b96e751178b8d0505d8466ff5a448f upstream.

vt_in_use() dereferences console_driver->ttys[i] without proper locking.
This is broken because the tty can be closed and freed concurrently.

We could fix this by using 'READ_ONCE(console_driver->ttys[i]) != NULL'
and skipping the check of tty_struct::count.  But, looking at
console_driver->ttys[i] isn't really appropriate anyway because even if
it is NULL the tty can still be in the process of being closed.

Instead, fix it by making vt_in_use() require console_lock() and check
whether the vt is allocated and has port refcount > 1.  This works since
following the patch "vt: vt_ioctl: fix VT_DISALLOCATE freeing in-use
virtual console" the port refcount is incremented while the vt is open.

Reproducer (very unreliable, but it worked for me after a few minutes):

	#include <fcntl.h>
	#include <linux/vt.h>

	int main()
	{
		int fd, nproc;
		struct vt_stat state;
		char ttyname[16];

		fd = open("/dev/tty10", O_RDONLY);
		for (nproc = 1; nproc < 8; nproc *= 2)
			fork();
		for (;;) {
			sprintf(ttyname, "/dev/tty%d", rand() % 8);
			close(open(ttyname, O_RDONLY));
			ioctl(fd, VT_GETSTATE, &state);
		}
	}

KASAN report:

	BUG: KASAN: use-after-free in vt_in_use drivers/tty/vt/vt_ioctl.c:48 [inline]
	BUG: KASAN: use-after-free in vt_ioctl+0x1ad3/0x1d70 drivers/tty/vt/vt_ioctl.c:657
	Read of size 4 at addr ffff888065722468 by task syz-vt2/132

	CPU: 0 PID: 132 Comm: syz-vt2 Not tainted 5.6.0-rc5-00130-g089b6d3654916 #13
	Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20191223_100556-anatol 04/01/2014
	Call Trace:
	 [...]
	 vt_in_use drivers/tty/vt/vt_ioctl.c:48 [inline]
	 vt_ioctl+0x1ad3/0x1d70 drivers/tty/vt/vt_ioctl.c:657
	 tty_ioctl+0x9db/0x11b0 drivers/tty/tty_io.c:2660
	 [...]

	Allocated by task 136:
	 [...]
	 kzalloc include/linux/slab.h:669 [inline]
	 alloc_tty_struct+0x96/0x8a0 drivers/tty/tty_io.c:2982
	 tty_init_dev+0x23/0x350 drivers/tty/tty_io.c:1334
	 tty_open_by_driver drivers/tty/tty_io.c:1987 [inline]
	 tty_open+0x3ca/0xb30 drivers/tty/tty_io.c:2035
	 [...]

	Freed by task 41:
	 [...]
	 kfree+0xbf/0x200 mm/slab.c:3757
	 free_tty_struct+0x8d/0xb0 drivers/tty/tty_io.c:177
	 release_one_tty+0x22d/0x2f0 drivers/tty/tty_io.c:1468
	 process_one_work+0x7f1/0x14b0 kernel/workqueue.c:2264
	 worker_thread+0x8b/0xc80 kernel/workqueue.c:2410
	 [...]

Fixes: 4001d7b7fc27 ("vt: push down the tty lock so we can see what is left to tackle")
Cc: <stable@vger.kernel.org> # v3.4+
Acked-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Link: https://lore.kernel.org/r/20200322034305.210082-3-ebiggers@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/vt/vt_ioctl.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/drivers/tty/vt/vt_ioctl.c
+++ b/drivers/tty/vt/vt_ioctl.c
@@ -43,9 +43,15 @@ bool vt_dont_switch;
 
 static inline bool vt_in_use(unsigned int i)
 {
-	extern struct tty_driver *console_driver;
+	const struct vc_data *vc = vc_cons[i].d;
 
-	return console_driver->ttys[i] && console_driver->ttys[i]->count;
+	/*
+	 * console_lock must be held to prevent the vc from being deallocated
+	 * while we're checking whether it's in-use.
+	 */
+	WARN_CONSOLE_UNLOCKED();
+
+	return vc && kref_read(&vc->port.kref) > 1;
 }
 
 static inline bool vt_busy(int i)
@@ -643,15 +649,16 @@ int vt_ioctl(struct tty_struct *tty,
 		struct vt_stat __user *vtstat = up;
 		unsigned short state, mask;
 
-		/* Review: FIXME: Console lock ? */
 		if (put_user(fg_console + 1, &vtstat->v_active))
 			ret = -EFAULT;
 		else {
 			state = 1;	/* /dev/tty0 is always open */
+			console_lock(); /* required by vt_in_use() */
 			for (i = 0, mask = 2; i < MAX_NR_CONSOLES && mask;
 							++i, mask <<= 1)
 				if (vt_in_use(i))
 					state |= mask;
+			console_unlock();
 			ret = put_user(state, &vtstat->v_state);
 		}
 		break;
@@ -661,10 +668,11 @@ int vt_ioctl(struct tty_struct *tty,
 	 * Returns the first available (non-opened) console.
 	 */
 	case VT_OPENQRY:
-		/* FIXME: locking ? - but then this is a stupid API */
+		console_lock(); /* required by vt_in_use() */
 		for (i = 0; i < MAX_NR_CONSOLES; ++i)
 			if (!vt_in_use(i))
 				break;
+		console_unlock();
 		uival = i < MAX_NR_CONSOLES ? (i+1) : -1;
 		goto setint;		 
 


