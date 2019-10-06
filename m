Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C95BCD6EB
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729020AbfJFRjH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:39:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:38566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729767AbfJFRjH (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:39:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BADE4222BE;
        Sun,  6 Oct 2019 17:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383546;
        bh=mQyM+MYzJfX0sMNye8DCPt5zXmK09F28LgbBWbDWYCw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JUiZ5cgOTjDAR/aAnvCPEBk+pdx+0uGQ6KJnWH0PHYB5ltx80IBEn7G3BhGAm2XNS
         PX41yGr/108zRWPmd0xDdI7H1WlgmFKwNJV3l3zAHwF1Ywislk0Y2xPjy6YBQ/GPr3
         3caKbNizFEG8EFw3cKZgZcvmE6rJ1OAs8XbrFDA4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+7d6a57304857423318a5@syzkaller.appspotmail.com,
        David Howells <dhowells@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Eric Biggers <ebiggers@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 5.2 137/137] vfs: set fs_context::user_ns for reconfigure
Date:   Sun,  6 Oct 2019 19:22:01 +0200
Message-Id: <20191006171220.808492952@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171209.403038733@linuxfoundation.org>
References: <20191006171209.403038733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit 1dd9bc08cf1420d466dd8dcfcc233777e61ca5d2 upstream.

fs_context::user_ns is used by fuse_parse_param(), even during remount,
so it needs to be set to the existing value for reconfigure.

Reproducer:

	#include <fcntl.h>
	#include <sys/mount.h>

	int main()
	{
		char opts[128];
		int fd = open("/dev/fuse", O_RDWR);

		sprintf(opts, "fd=%d,rootmode=040000,user_id=0,group_id=0", fd);
		mkdir("mnt", 0777);
		mount("foo",  "mnt", "fuse.foo", 0, opts);
		mount("foo", "mnt", "fuse.foo", MS_REMOUNT, opts);
	}

Crash:
	BUG: kernel NULL pointer dereference, address: 0000000000000000
	#PF: supervisor read access in kernel mode
	#PF: error_code(0x0000) - not-present page
	PGD 0 P4D 0
	Oops: 0000 [#1] SMP
	CPU: 0 PID: 129 Comm: syz_make_kuid Not tainted 5.3.0-rc5-next-20190821 #3
	Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-20181126_142135-anatol 04/01/2014
	RIP: 0010:map_id_range_down+0xb/0xc0 kernel/user_namespace.c:291
	[...]
	Call Trace:
	 map_id_down kernel/user_namespace.c:312 [inline]
	 make_kuid+0xe/0x10 kernel/user_namespace.c:389
	 fuse_parse_param+0x116/0x210 fs/fuse/inode.c:523
	 vfs_parse_fs_param+0xdb/0x1b0 fs/fs_context.c:145
	 vfs_parse_fs_string+0x6a/0xa0 fs/fs_context.c:188
	 generic_parse_monolithic+0x85/0xc0 fs/fs_context.c:228
	 parse_monolithic_mount_data+0x1b/0x20 fs/fs_context.c:708
	 do_remount fs/namespace.c:2525 [inline]
	 do_mount+0x39a/0xa60 fs/namespace.c:3107
	 ksys_mount+0x7d/0xd0 fs/namespace.c:3325
	 __do_sys_mount fs/namespace.c:3339 [inline]
	 __se_sys_mount fs/namespace.c:3336 [inline]
	 __x64_sys_mount+0x20/0x30 fs/namespace.c:3336
	 do_syscall_64+0x4a/0x1a0 arch/x86/entry/common.c:290
	 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Reported-by: syzbot+7d6a57304857423318a5@syzkaller.appspotmail.com
Fixes: 408cbe695350 ("vfs: Convert fuse to use the new mount API")
Cc: David Howells <dhowells@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/fs_context.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/fs/fs_context.c
+++ b/fs/fs_context.c
@@ -279,10 +279,8 @@ static struct fs_context *alloc_fs_conte
 		fc->user_ns = get_user_ns(reference->d_sb->s_user_ns);
 		break;
 	case FS_CONTEXT_FOR_RECONFIGURE:
-		/* We don't pin any namespaces as the superblock's
-		 * subscriptions cannot be changed at this point.
-		 */
 		atomic_inc(&reference->d_sb->s_active);
+		fc->user_ns = get_user_ns(reference->d_sb->s_user_ns);
 		fc->root = dget(reference);
 		break;
 	}


