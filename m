Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75CE333BA9D
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:11:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235283AbhCOOJs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:09:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:52490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234594AbhCOOE1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:04:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3A9664EF8;
        Mon, 15 Mar 2021 14:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615817064;
        bh=x3Htg2voxND8Ah2g0xemyHciB6hV7tmKLcRWo8Y2DHg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NEQ9RI/8HPTNrZymOQ0C96y36LM5azbLJnmbedegf1QZzUBTwzPkLbTGi6J6uWDY+
         bEwtazM44z59lwSXnTcKdtpTktLORk9/0eJskOz3UxOwFU/6gZogLVV8IoObLz4Dvw
         F3cUGz4iKd9HGbEjU/VnVQx17LlrxD6GPhsqj0Zk=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lior Ribak <liorribak@gmail.com>,
        Helge Deller <deller@gmx.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.11 283/306] binfmt_misc: fix possible deadlock in bm_register_write
Date:   Mon, 15 Mar 2021 14:55:46 +0100
Message-Id: <20210315135517.252925776@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Lior Ribak <liorribak@gmail.com>

commit e7850f4d844e0acfac7e570af611d89deade3146 upstream.

There is a deadlock in bm_register_write:

First, in the begining of the function, a lock is taken on the binfmt_misc
root inode with inode_lock(d_inode(root)).

Then, if the user used the MISC_FMT_OPEN_FILE flag, the function will call
open_exec on the user-provided interpreter.

open_exec will call a path lookup, and if the path lookup process includes
the root of binfmt_misc, it will try to take a shared lock on its inode
again, but it is already locked, and the code will get stuck in a deadlock

To reproduce the bug:
$ echo ":iiiii:E::ii::/proc/sys/fs/binfmt_misc/bla:F" > /proc/sys/fs/binfmt_misc/register

backtrace of where the lock occurs (#5):
0  schedule () at ./arch/x86/include/asm/current.h:15
1  0xffffffff81b51237 in rwsem_down_read_slowpath (sem=0xffff888003b202e0, count=<optimized out>, state=state@entry=2) at kernel/locking/rwsem.c:992
2  0xffffffff81b5150a in __down_read_common (state=2, sem=<optimized out>) at kernel/locking/rwsem.c:1213
3  __down_read (sem=<optimized out>) at kernel/locking/rwsem.c:1222
4  down_read (sem=<optimized out>) at kernel/locking/rwsem.c:1355
5  0xffffffff811ee22a in inode_lock_shared (inode=<optimized out>) at ./include/linux/fs.h:783
6  open_last_lookups (op=0xffffc9000022fe34, file=0xffff888004098600, nd=0xffffc9000022fd10) at fs/namei.c:3177
7  path_openat (nd=nd@entry=0xffffc9000022fd10, op=op@entry=0xffffc9000022fe34, flags=flags@entry=65) at fs/namei.c:3366
8  0xffffffff811efe1c in do_filp_open (dfd=<optimized out>, pathname=pathname@entry=0xffff8880031b9000, op=op@entry=0xffffc9000022fe34) at fs/namei.c:3396
9  0xffffffff811e493f in do_open_execat (fd=fd@entry=-100, name=name@entry=0xffff8880031b9000, flags=<optimized out>, flags@entry=0) at fs/exec.c:913
10 0xffffffff811e4a92 in open_exec (name=<optimized out>) at fs/exec.c:948
11 0xffffffff8124aa84 in bm_register_write (file=<optimized out>, buffer=<optimized out>, count=19, ppos=<optimized out>) at fs/binfmt_misc.c:682
12 0xffffffff811decd2 in vfs_write (file=file@entry=0xffff888004098500, buf=buf@entry=0xa758d0 ":iiiii:E::ii::i:CF
", count=count@entry=19, pos=pos@entry=0xffffc9000022ff10) at fs/read_write.c:603
13 0xffffffff811defda in ksys_write (fd=<optimized out>, buf=0xa758d0 ":iiiii:E::ii::i:CF
", count=19) at fs/read_write.c:658
14 0xffffffff81b49813 in do_syscall_64 (nr=<optimized out>, regs=0xffffc9000022ff58) at arch/x86/entry/common.c:46
15 0xffffffff81c0007c in entry_SYSCALL_64 () at arch/x86/entry/entry_64.S:120

To solve the issue, the open_exec call is moved to before the write
lock is taken by bm_register_write

Link: https://lkml.kernel.org/r/20210228224414.95962-1-liorribak@gmail.com
Fixes: 948b701a607f1 ("binfmt_misc: add persistent opened binary handler for containers")
Signed-off-by: Lior Ribak <liorribak@gmail.com>
Acked-by: Helge Deller <deller@gmx.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/binfmt_misc.c |   29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -647,12 +647,24 @@ static ssize_t bm_register_write(struct
 	struct super_block *sb = file_inode(file)->i_sb;
 	struct dentry *root = sb->s_root, *dentry;
 	int err = 0;
+	struct file *f = NULL;
 
 	e = create_entry(buffer, count);
 
 	if (IS_ERR(e))
 		return PTR_ERR(e);
 
+	if (e->flags & MISC_FMT_OPEN_FILE) {
+		f = open_exec(e->interpreter);
+		if (IS_ERR(f)) {
+			pr_notice("register: failed to install interpreter file %s\n",
+				 e->interpreter);
+			kfree(e);
+			return PTR_ERR(f);
+		}
+		e->interp_file = f;
+	}
+
 	inode_lock(d_inode(root));
 	dentry = lookup_one_len(e->name, root, strlen(e->name));
 	err = PTR_ERR(dentry);
@@ -676,21 +688,6 @@ static ssize_t bm_register_write(struct
 		goto out2;
 	}
 
-	if (e->flags & MISC_FMT_OPEN_FILE) {
-		struct file *f;
-
-		f = open_exec(e->interpreter);
-		if (IS_ERR(f)) {
-			err = PTR_ERR(f);
-			pr_notice("register: failed to install interpreter file %s\n", e->interpreter);
-			simple_release_fs(&bm_mnt, &entry_count);
-			iput(inode);
-			inode = NULL;
-			goto out2;
-		}
-		e->interp_file = f;
-	}
-
 	e->dentry = dget(dentry);
 	inode->i_private = e;
 	inode->i_fop = &bm_entry_operations;
@@ -707,6 +704,8 @@ out:
 	inode_unlock(d_inode(root));
 
 	if (err) {
+		if (f)
+			filp_close(f, NULL);
 		kfree(e);
 		return err;
 	}


