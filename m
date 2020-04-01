Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB6019AFA0
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732511AbgDAQTq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:19:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:42108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732509AbgDAQTp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:19:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12BCD214D8;
        Wed,  1 Apr 2020 16:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585757984;
        bh=RDAjuBB4KW4yL7sP70yBhPT0EQ7PiWA5pPyjEhswzno=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hm3EqzD5rUnMifxbPVL5CIyHCTkAxfvRPe9/Sx+LpJz8NsD1casWqPSjGzxyjqUss
         BDHDMxRynor6mAMBB279NHEOZ1CZKfKx8q31JuQNkziNAgf0CuU6Jlu06/tiSPdKEQ
         0g+gj3ACnDqgHmUW6yeMoHWlZ/uDbio9CkI9ipl8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+522643ab5729b0421998@syzkaller.appspotmail.com,
        Jiri Slaby <jslaby@suse.cz>, Eric Biggers <ebiggers@google.com>
Subject: [PATCH 5.6 08/10] vt: vt_ioctl: fix VT_DISALLOCATE freeing in-use virtual console
Date:   Wed,  1 Apr 2020 18:17:24 +0200
Message-Id: <20200401161420.269513071@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161413.974936041@linuxfoundation.org>
References: <20200401161413.974936041@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit ca4463bf8438b403596edd0ec961ca0d4fbe0220 upstream.

The VT_DISALLOCATE ioctl can free a virtual console while tty_release()
is still running, causing a use-after-free in con_shutdown().  This
occurs because VT_DISALLOCATE considers a virtual console's
'struct vc_data' to be unused as soon as the corresponding tty's
refcount hits 0.  But actually it may be still being closed.

Fix this by making vc_data be reference-counted via the embedded
'struct tty_port'.  A newly allocated virtual console has refcount 1.
Opening it for the first time increments the refcount to 2.  Closing it
for the last time decrements the refcount (in tty_operations::cleanup()
so that it happens late enough), as does VT_DISALLOCATE.

Reproducer:
	#include <fcntl.h>
	#include <linux/vt.h>
	#include <sys/ioctl.h>
	#include <unistd.h>

	int main()
	{
		if (fork()) {
			for (;;)
				close(open("/dev/tty5", O_RDWR));
		} else {
			int fd = open("/dev/tty10", O_RDWR);

			for (;;)
				ioctl(fd, VT_DISALLOCATE, 5);
		}
	}

KASAN report:
	BUG: KASAN: use-after-free in con_shutdown+0x76/0x80 drivers/tty/vt/vt.c:3278
	Write of size 8 at addr ffff88806a4ec108 by task syz_vt/129

	CPU: 0 PID: 129 Comm: syz_vt Not tainted 5.6.0-rc2 #11
	Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20191223_100556-anatol 04/01/2014
	Call Trace:
	 [...]
	 con_shutdown+0x76/0x80 drivers/tty/vt/vt.c:3278
	 release_tty+0xa8/0x410 drivers/tty/tty_io.c:1514
	 tty_release_struct+0x34/0x50 drivers/tty/tty_io.c:1629
	 tty_release+0x984/0xed0 drivers/tty/tty_io.c:1789
	 [...]

	Allocated by task 129:
	 [...]
	 kzalloc include/linux/slab.h:669 [inline]
	 vc_allocate drivers/tty/vt/vt.c:1085 [inline]
	 vc_allocate+0x1ac/0x680 drivers/tty/vt/vt.c:1066
	 con_install+0x4d/0x3f0 drivers/tty/vt/vt.c:3229
	 tty_driver_install_tty drivers/tty/tty_io.c:1228 [inline]
	 tty_init_dev+0x94/0x350 drivers/tty/tty_io.c:1341
	 tty_open_by_driver drivers/tty/tty_io.c:1987 [inline]
	 tty_open+0x3ca/0xb30 drivers/tty/tty_io.c:2035
	 [...]

	Freed by task 130:
	 [...]
	 kfree+0xbf/0x1e0 mm/slab.c:3757
	 vt_disallocate drivers/tty/vt/vt_ioctl.c:300 [inline]
	 vt_ioctl+0x16dc/0x1e30 drivers/tty/vt/vt_ioctl.c:818
	 tty_ioctl+0x9db/0x11b0 drivers/tty/tty_io.c:2660
	 [...]

Fixes: 4001d7b7fc27 ("vt: push down the tty lock so we can see what is left to tackle")
Cc: <stable@vger.kernel.org> # v3.4+
Reported-by: syzbot+522643ab5729b0421998@syzkaller.appspotmail.com
Acked-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Link: https://lore.kernel.org/r/20200322034305.210082-2-ebiggers@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/vt/vt.c       |   23 ++++++++++++++++++++++-
 drivers/tty/vt/vt_ioctl.c |   12 ++++--------
 2 files changed, 26 insertions(+), 9 deletions(-)

--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -1075,6 +1075,17 @@ static void visual_deinit(struct vc_data
 	module_put(vc->vc_sw->owner);
 }
 
+static void vc_port_destruct(struct tty_port *port)
+{
+	struct vc_data *vc = container_of(port, struct vc_data, port);
+
+	kfree(vc);
+}
+
+static const struct tty_port_operations vc_port_ops = {
+	.destruct = vc_port_destruct,
+};
+
 int vc_allocate(unsigned int currcons)	/* return 0 on success */
 {
 	struct vt_notifier_param param;
@@ -1100,6 +1111,7 @@ int vc_allocate(unsigned int currcons)	/
 
 	vc_cons[currcons].d = vc;
 	tty_port_init(&vc->port);
+	vc->port.ops = &vc_port_ops;
 	INIT_WORK(&vc_cons[currcons].SAK_work, vc_SAK);
 
 	visual_init(vc, currcons, 1);
@@ -3254,6 +3266,7 @@ static int con_install(struct tty_driver
 
 	tty->driver_data = vc;
 	vc->port.tty = tty;
+	tty_port_get(&vc->port);
 
 	if (!tty->winsize.ws_row && !tty->winsize.ws_col) {
 		tty->winsize.ws_row = vc_cons[currcons].d->vc_rows;
@@ -3289,6 +3302,13 @@ static void con_shutdown(struct tty_stru
 	console_unlock();
 }
 
+static void con_cleanup(struct tty_struct *tty)
+{
+	struct vc_data *vc = tty->driver_data;
+
+	tty_port_put(&vc->port);
+}
+
 static int default_color           = 7; /* white */
 static int default_italic_color    = 2; // green (ASCII)
 static int default_underline_color = 3; // cyan (ASCII)
@@ -3414,7 +3434,8 @@ static const struct tty_operations con_o
 	.throttle = con_throttle,
 	.unthrottle = con_unthrottle,
 	.resize = vt_resize,
-	.shutdown = con_shutdown
+	.shutdown = con_shutdown,
+	.cleanup = con_cleanup,
 };
 
 static struct cdev vc0_cdev;
--- a/drivers/tty/vt/vt_ioctl.c
+++ b/drivers/tty/vt/vt_ioctl.c
@@ -310,10 +310,8 @@ static int vt_disallocate(unsigned int v
 		vc = vc_deallocate(vc_num);
 	console_unlock();
 
-	if (vc && vc_num >= MIN_NR_CONSOLES) {
-		tty_port_destroy(&vc->port);
-		kfree(vc);
-	}
+	if (vc && vc_num >= MIN_NR_CONSOLES)
+		tty_port_put(&vc->port);
 
 	return ret;
 }
@@ -333,10 +331,8 @@ static void vt_disallocate_all(void)
 	console_unlock();
 
 	for (i = 1; i < MAX_NR_CONSOLES; i++) {
-		if (vc[i] && i >= MIN_NR_CONSOLES) {
-			tty_port_destroy(&vc[i]->port);
-			kfree(vc[i]);
-		}
+		if (vc[i] && i >= MIN_NR_CONSOLES)
+			tty_port_put(&vc[i]->port);
 	}
 }
 


