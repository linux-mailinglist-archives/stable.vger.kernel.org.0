Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE27F1B681B
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729330AbgDWXMb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:12:31 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50034 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728496AbgDWXGv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:51 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvV-0004hY-85; Fri, 24 Apr 2020 00:06:37 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvT-00E6sV-0O; Fri, 24 Apr 2020 00:06:35 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Hillf Danton" <hdanton@sina.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        syzbot+82defefbbd8527e1c2cb@syzkaller.appspotmail.com,
        "Al Viro" <viro@zeniv.linux.org.uk>,
        "Will Deacon" <will@kernel.org>
Date:   Fri, 24 Apr 2020 00:06:25 +0100
Message-ID: <lsq.1587683028.306418837@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 158/245] chardev: Avoid potential use-after-free in
 'chrdev_open()'
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

From: Will Deacon <will@kernel.org>

commit 68faa679b8be1a74e6663c21c3a9d25d32f1c079 upstream.

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
Link: https://lore.kernel.org/r/20191219120203.32691-1-will@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/char_dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/char_dev.c
+++ b/fs/char_dev.c
@@ -348,7 +348,7 @@ static struct kobject *cdev_get(struct c
 
 	if (owner && !try_module_get(owner))
 		return NULL;
-	kobj = kobject_get(&p->kobj);
+	kobj = kobject_get_unless_zero(&p->kobj);
 	if (!kobj)
 		module_put(owner);
 	return kobj;

