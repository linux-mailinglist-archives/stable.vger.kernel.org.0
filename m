Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B822FCBC9A
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 16:05:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388727AbfJDOFY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 10:05:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47413 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388657AbfJDOFY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Oct 2019 10:05:24 -0400
Received: from [213.220.153.21] (helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1iGOCv-0002p9-PZ; Fri, 04 Oct 2019 14:05:21 +0000
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Will Deacon <will@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amir Goldstein <amir73il@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Varad Gautam <vrd@amazon.de>, stable@vger.kernel.org,
        Jan Glauber <jglauber@marvell.com>
Subject: [PATCH] devpts: Fix NULL pointer dereference in dcache_readdir()
Date:   Fri,  4 Oct 2019 16:05:03 +0200
Message-Id: <20191004140503.9817-1-christian.brauner@ubuntu.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will@kernel.org>

Closing /dev/pts/ptmx removes the corresponding pty under /dev/pts/
without synchronizing against concurrent path walkers. This can lead to
'dcache_readdir()' tripping over a 'struct dentry' with a NULL 'd_inode'
field:

  | BUG: kernel NULL pointer dereference, address: 0000000000000000
  | #PF: supervisor read access in kernel mode
  | #PF: error_code(0x0000) - not-present page
  | PGD 0 P4D 0
  | SMP PTI
  | CPU: 9 PID: 179 Comm: ptmx Not tainted 5.4.0-rc1+ #5
  | RIP: 0010:dcache_readdir+0xe1/0x150
  | Code: 48 83 f8 01 74 a2 48 83 f8 02 74 eb 4d 8d a7 90 00 00 00 45 31 f6 eb 42 48 8b 43 30 48 8b 4d 08 48 89 ef 8b 53 24 48 8b 73 28 <44> 0f b7 08 4c 8b 55 00 4c 8b 40 40 66 41 c1 e9 0c 41 83 e1 0f e8
  | RSP: 0018:ffffa7df8044be58 EFLAGS: 00010286
  | RAX: 0000000000000000 RBX: ffff9511c78f3ec0 RCX: 0000000000000002
  | RDX: 0000000000000001 RSI: ffff9511c78f3ef8 RDI: ffffa7df8044bed0
  | RBP: ffffa7df8044bed0 R08: 0000000000000000 R09: 00000000004bc478
  | R10: ffff9511c877c6a8 R11: ffff9511c8dde600 R12: ffff9511c878c460
  | R13: ffff9511c878c3c0 R14: 0000000000000000 R15: ffff9511c9442cc0
  | FS:  00007fc5ea2e1700(0000) GS:ffff9511ca280000(0000) knlGS:0000000000000000
  | CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  | CR2: 0000000000000000 CR3: 0000000047d68002 CR4: 0000000000760ea0
  | DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  | DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  | PKRU: 55555554
  | Call Trace:
  |  iterate_dir+0x137/0x190
  |  ksys_getdents64+0x97/0x130
  |  ? iterate_dir+0x190/0x190
  |  __x64_sys_getdents64+0x11/0x20
  |  do_syscall_64+0x43/0x110
  |  entry_SYSCALL_64_after_hwframe+0x44/0xa9

In this case, one CPU is deleting the dentry and clearing the inode
pointer via:

	 devpts_pty_kill()
		-> dput()
			-> dentry_kill()
				-> __dentry_kill()
					-> dentry_unlink_inode()

whilst the other is traversing the directory an obtaining a reference
to the dentry being deleted via:

	sys_getdents64()
		-> iterate_dir()
			-> dcache_readdir()
				-> next_positive()

Prevent the race by acquiring the inode lock of the parent in
'devpts_pty_kill()' so that path walkers are held off until the dentry
has been completely torn down.

Will's fix didn't link to the commit it fixes so I tracked it down.
devpts_pty_kill() used to take inode_lock() before removing a pts
device. The inode_lock() got removed in
8ead9dd54716 ("devpts: more pty driver interface cleanups"). The
reasoning behind the removal seemed to be that the inode_lock() was only
needed because d_find_alias(inode) had to be called before that commit
to find the dentry that was supposed to be removed. Linus then changed
the pty driver to stash away the dentry and subsequently got rid of the
inode_lock(). However, it seems that the inode_lock() is needed to
protect against the race outlined above. So add it back.

Note that this bug had been brought up before in November 2018 before
(cf. [1]). But a fix never got merged because a proper commit wasn't
sent. The issue came back up when Will and I talked about it at Kernel
Recipes in Paris. So here is a fix which prevents the issue. I very much
vote we get this merged asap, since as an unprivileged user I can do:

unshare -U --map-root --mount
mount -t devpts devpts
./<run_reproducer_below

/* Reproducer */
Note that the reproducer will take a little while. Will reported usually
around 10s. For me it took a few minutes.

 #ifndef _GNU_SOURCE
 #define _GNU_SOURCE 1
 #endif
 #include <dirent.h>
 #include <errno.h>
 #include <fcntl.h>
 #include <pthread.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <sys/stat.h>
 #include <sys/types.h>
 #include <unistd.h>

 static void *readdir_thread(void *arg)
 {
 	DIR *d = arg;
 	struct dirent *dent;

 	for (;;) {
 		errno = 0;
 		dent = readdir(d);
 		if (!dent) {
 			if (errno)
 				perror("readdir");
 			break;
 		}
 		rewinddir(d);
 	}

 	return NULL;
 }

 int main(void)
 {
 	DIR *d;
 	pthread_t t;
 	int ret = 0;

 	d = opendir("/dev/pts");
 	if (!d) {
 		ret = errno;
 		perror("opendir");
 		exit(EXIT_FAILURE);
 	}

 	ret = pthread_create(&t, NULL, readdir_thread, d);
 	if (ret) {
 		errno = ret;
 		perror("pthread_create");
 		exit(EXIT_FAILURE);
 	}

 	for (;;) {
 		int dfd;
 		int fd;

 		dfd = dirfd(d);
 		if (dfd < 0) {
 			perror("dirfd");
 			break;
 		}

 		fd = openat(dirfd(d), "ptmx", O_RDONLY | O_NONBLOCK | O_CLOEXEC);
 		if (fd < 0) {
 			perror("openat");
 			break;
 		}
 		close(fd);
 	}

 	pthread_join(t, NULL);
 	closedir(d);
 	exit(EXIT_SUCCESS);
 }

/* References */
[1]: https://lore.kernel.org/r/20181109143744.GA12128@hc

Fixes: 8ead9dd54716 ("devpts: more pty driver interface cleanups")
Cc: <stable@vger.kernel.org>
Cc: Jan Glauber <jglauber@marvell.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Will Deacon <will@kernel.org>
Reviewed-by: Christian Brauner <christian.brauner@ubuntu.com>
[christian.brauner@ubuntu.com: dig into history and add context and reproducer to commit message]
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 fs/devpts/inode.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
index 42e5a766d33c..4b4546347aac 100644
--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -617,13 +617,18 @@ void *devpts_get_priv(struct dentry *dentry)
  */
 void devpts_pty_kill(struct dentry *dentry)
 {
-	WARN_ON_ONCE(dentry->d_sb->s_magic != DEVPTS_SUPER_MAGIC);
+	struct super_block *sb = dentry->d_sb;
+	struct dentry *parent = sb->s_root;
 
+	WARN_ON_ONCE(sb->s_magic != DEVPTS_SUPER_MAGIC);
+
+	inode_lock(parent->d_inode);
 	dentry->d_fsdata = NULL;
 	drop_nlink(dentry->d_inode);
 	fsnotify_unlink(d_inode(dentry->d_parent), dentry);
 	d_drop(dentry);
 	dput(dentry);	/* d_alloc_name() in devpts_pty_new() */
+	inode_unlock(parent->d_inode);
 }
 
 static int __init init_devpts_fs(void)
-- 
2.23.0

