Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B355713201C
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 08:01:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725914AbgAGHBJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 02:01:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:38482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725781AbgAGHBJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 02:01:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB161206DB;
        Tue,  7 Jan 2020 07:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578380468;
        bh=ul7WI8DQtboNNMuwCoJ7Wzq7n9YYqhztV7I81moLcjA=;
        h=Subject:To:From:Date:From;
        b=qv5OO/U+UrlEGu0PhwBjiEBfjK4Vu0DukVY9+xbZ4W5efj4scVHhk4IKqd7h3xQ8O
         dwYTx19M38h0/Tzpqb/Znm1DU8MR77aQYhw4qeWJpu2bHVpXaofAQ41YUhgdDxLVYf
         x77JUHZIX21V4FNRPvjiQYMJ5cS2WYL+xCR803is=
Subject: patch "chardev: Avoid potential use-after-free in 'chrdev_open()'" added to char-misc-linus
To:     will@kernel.org, akpm@linux-foundation.org,
        gregkh@linuxfoundation.org, hdanton@sina.com,
        stable@vger.kernel.org, viro@zeniv.linux.org.uk
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 07 Jan 2020 08:01:05 +0100
Message-ID: <1578380465174211@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    chardev: Avoid potential use-after-free in 'chrdev_open()'

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 68faa679b8be1a74e6663c21c3a9d25d32f1c079 Mon Sep 17 00:00:00 2001
From: Will Deacon <will@kernel.org>
Date: Thu, 19 Dec 2019 12:02:03 +0000
Subject: chardev: Avoid potential use-after-free in 'chrdev_open()'

'chrdev_open()' calls 'cdev_get()' to obtain a reference to the
'struct cdev *' stashed in the 'i_cdev' field of the target inode
structure. If the pointer is NULL, then it is initialised lazily by
looking up the kobject in the 'cdev_map' and so the whole procedure is
protected by the 'cdev_lock' spinlock to serialise initialisation of
the shared pointer.

Unfortunately, it is possible for the initialising thread to fail *after*
installing the new pointer, for example if the subsequent '->open()' call
on the file fails. In this case, 'cdev_put()' is called, the reference
count on the kobject is dropped and, if nobody else has taken a reference,
the release function is called which finally clears 'inode->i_cdev' from
'cdev_purge()' before potentially freeing the object. The problem here
is that a racing thread can happily take the 'cdev_lock' and see the
non-NULL pointer in the inode, which can result in a refcount increment
from zero and a warning:

  |  ------------[ cut here ]------------
  |  refcount_t: addition on 0; use-after-free.
  |  WARNING: CPU: 2 PID: 6385 at lib/refcount.c:25 refcount_warn_saturate+0x6d/0xf0
  |  Modules linked in:
  |  CPU: 2 PID: 6385 Comm: repro Not tainted 5.5.0-rc2+ #22
  |  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
  |  RIP: 0010:refcount_warn_saturate+0x6d/0xf0
  |  Code: 05 55 9a 15 01 01 e8 9d aa c8 ff 0f 0b c3 80 3d 45 9a 15 01 00 75 ce 48 c7 c7 00 9c 62 b3 c6 08
  |  RSP: 0018:ffffb524c1b9bc70 EFLAGS: 00010282
  |  RAX: 0000000000000000 RBX: ffff9e9da1f71390 RCX: 0000000000000000
  |  RDX: ffff9e9dbbd27618 RSI: ffff9e9dbbd18798 RDI: ffff9e9dbbd18798
  |  RBP: 0000000000000000 R08: 000000000000095f R09: 0000000000000039
  |  R10: 0000000000000000 R11: ffffb524c1b9bb20 R12: ffff9e9da1e8c700
  |  R13: ffffffffb25ee8b0 R14: 0000000000000000 R15: ffff9e9da1e8c700
  |  FS:  00007f3b87d26700(0000) GS:ffff9e9dbbd00000(0000) knlGS:0000000000000000
  |  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  |  CR2: 00007fc16909c000 CR3: 000000012df9c000 CR4: 00000000000006e0
  |  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  |  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  |  Call Trace:
  |   kobject_get+0x5c/0x60
  |   cdev_get+0x2b/0x60
  |   chrdev_open+0x55/0x220
  |   ? cdev_put.part.3+0x20/0x20
  |   do_dentry_open+0x13a/0x390
  |   path_openat+0x2c8/0x1470
  |   do_filp_open+0x93/0x100
  |   ? selinux_file_ioctl+0x17f/0x220
  |   do_sys_open+0x186/0x220
  |   do_syscall_64+0x48/0x150
  |   entry_SYSCALL_64_after_hwframe+0x44/0xa9
  |  RIP: 0033:0x7f3b87efcd0e
  |  Code: 89 54 24 08 e8 a3 f4 ff ff 8b 74 24 0c 48 8b 3c 24 41 89 c0 44 8b 54 24 08 b8 01 01 00 00 89 f4
  |  RSP: 002b:00007f3b87d259f0 EFLAGS: 00000293 ORIG_RAX: 0000000000000101
  |  RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f3b87efcd0e
  |  RDX: 0000000000000000 RSI: 00007f3b87d25a80 RDI: 00000000ffffff9c
  |  RBP: 00007f3b87d25e90 R08: 0000000000000000 R09: 0000000000000000
  |  R10: 0000000000000000 R11: 0000000000000293 R12: 00007ffe188f504e
  |  R13: 00007ffe188f504f R14: 00007f3b87d26700 R15: 0000000000000000
  |  ---[ end trace 24f53ca58db8180a ]---

Since 'cdev_get()' can already fail to obtain a reference, simply move
it over to use 'kobject_get_unless_zero()' instead of 'kobject_get()',
which will cause the racing thread to return -ENXIO if the initialising
thread fails unexpectedly.

Cc: Hillf Danton <hdanton@sina.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Reported-by: syzbot+82defefbbd8527e1c2cb@syzkaller.appspotmail.com
Signed-off-by: Will Deacon <will@kernel.org>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191219120203.32691-1-will@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/char_dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/char_dev.c b/fs/char_dev.c
index 00dfe17871ac..c5e6eff5a381 100644
--- a/fs/char_dev.c
+++ b/fs/char_dev.c
@@ -352,7 +352,7 @@ static struct kobject *cdev_get(struct cdev *p)
 
 	if (owner && !try_module_get(owner))
 		return NULL;
-	kobj = kobject_get(&p->kobj);
+	kobj = kobject_get_unless_zero(&p->kobj);
 	if (!kobj)
 		module_put(owner);
 	return kobj;
-- 
2.24.1


