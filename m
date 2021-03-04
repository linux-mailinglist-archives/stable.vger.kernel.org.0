Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1C9832D8D1
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 18:46:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232135AbhCDRnR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 12:43:17 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53956 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230450AbhCDRmt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Mar 2021 12:42:49 -0500
Received: from [95.90.240.160] (helo=wittgenstein.fritz.box)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1lHrzC-0001Yc-Mn; Thu, 04 Mar 2021 17:42:06 +0000
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Christoph Hellwig <hch@lst.de>,
        David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux>
Cc:     linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] mount: fix mounting of detached mounts onto targets that reside on shared mounts
Date:   Thu,  4 Mar 2021 18:41:55 +0100
Message-Id: <20210304174155.61792-1-christian.brauner@ubuntu.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Creating a series of detached mounts, attaching them to the filesystem,
and unmounting them can be used to trigger an integer overflow in
ns->mounts causing the kernel to block any new mounts in count_mounts()
and returning ENOSPC because it falsely assumes that the maximum number
of mounts in the mount namespace has been reached, i.e. it thinks it
can't fit the new mounts into the mount namespace anymore.

Depending on the number of mounts in your system, this can be reproduced
on any kernel that supportes open_tree() and move_mount() with the
following instructions:

1. Compile the following program "repro.c" via "make repro"
  > cat repro.c

  #define _GNU_SOURCE
  #include <errno.h>
  #include <fcntl.h>
  #include <getopt.h>
  #include <limits.h>
  #include <stdbool.h>
  #include <stdio.h>
  #include <stdlib.h>
  #include <linux/mount.h>
  #include <sys/syscall.h>
  #include <sys/types.h>
  #include <unistd.h>

  /* open_tree() */
  #ifndef OPEN_TREE_CLONE
  #define OPEN_TREE_CLONE 1
  #endif

  #ifndef OPEN_TREE_CLOEXEC
  #define OPEN_TREE_CLOEXEC O_CLOEXEC
  #endif

  #ifndef __NR_open_tree
  	#if defined __alpha__
  		#define __NR_open_tree 538
  	#elif defined _MIPS_SIM
  		#if _MIPS_SIM == _MIPS_SIM_ABI32	/* o32 */
  			#define __NR_open_tree 4428
  		#endif
  		#if _MIPS_SIM == _MIPS_SIM_NABI32	/* n32 */
  			#define __NR_open_tree 6428
  		#endif
  		#if _MIPS_SIM == _MIPS_SIM_ABI64	/* n64 */
  			#define __NR_open_tree 5428
  		#endif
  	#elif defined __ia64__
  		#define __NR_open_tree (428 + 1024)
  	#else
  		#define __NR_open_tree 428
  	#endif
  #endif

  /* move_mount() */
  #ifndef MOVE_MOUNT_F_EMPTY_PATH
  #define MOVE_MOUNT_F_EMPTY_PATH 0x00000004 /* Empty from path permitted */
  #endif

  #ifndef __NR_move_mount
  	#if defined __alpha__
  		#define __NR_move_mount 539
  	#elif defined _MIPS_SIM
  		#if _MIPS_SIM == _MIPS_SIM_ABI32	/* o32 */
  			#define __NR_move_mount 4429
  		#endif
  		#if _MIPS_SIM == _MIPS_SIM_NABI32	/* n32 */
  			#define __NR_move_mount 6429
  		#endif
  		#if _MIPS_SIM == _MIPS_SIM_ABI64	/* n64 */
  			#define __NR_move_mount 5429
  		#endif
  	#elif defined __ia64__
  		#define __NR_move_mount (428 + 1024)
  	#else
  		#define __NR_move_mount 429
  	#endif
  #endif

  static inline int sys_open_tree(int dfd, const char *filename, unsigned int flags)
  {
  	return syscall(__NR_open_tree, dfd, filename, flags);
  }

  static inline int sys_move_mount(int from_dfd, const char *from_pathname, int to_dfd,
  				 const char *to_pathname, unsigned int flags)
  {
  	return syscall(__NR_move_mount, from_dfd, from_pathname, to_dfd, to_pathname, flags);
  }

  static void usage(void)
  {
  	const char *text = "mount-new [--recursive] <source> <target>\n";
  	fprintf(stderr, "%s", text);
  	_exit(EXIT_SUCCESS);
  }

  #define exit_usage(format, ...)                         \
  	({                                              \
  		fprintf(stderr, format, ##__VA_ARGS__); \
  		usage();                                \
  	})

  #define exit_log(format, ...)                           \
  	({                                              \
  		fprintf(stderr, format, ##__VA_ARGS__); \
  		exit(EXIT_FAILURE);                     \
  	})

  static const struct option longopts[] = {
  	{"recursive",	no_argument,		0,	'a'},
  	{"help",	no_argument,		0,	'b'},
  	{ NULL,		no_argument,		0,	 0 },
  };

  int main(int argc, char *argv[])
  {
  	int index = 0;
  	bool recursive = false;
  	int fd_tree, new_argc, ret;
  	char *source, *target;
  	char *const *new_argv;

  	while ((ret = getopt_long_only(argc, argv, "", longopts, &index)) != -1) {
  		switch (ret) {
  		case 'a':
  			recursive = true;
  			break;
  		case 'b':
  			/* fallthrough */
  		default:
  			usage();
  		}
  	}

  	new_argv = &argv[optind];
  	new_argc = argc - optind;
  	if (new_argc < 2)
  		exit_usage("Missing source or target mountpoint\n\n");
  	source = new_argv[0];
  	target = new_argv[1];

  	fd_tree = sys_open_tree(-EBADF, source,
  				OPEN_TREE_CLONE |
  				OPEN_TREE_CLOEXEC |
  				AT_EMPTY_PATH |
  				(recursive ? AT_RECURSIVE : 0));
  	if (fd_tree < 0) {
  		exit_log("%m - Failed to open %s\n", source);
  		exit(EXIT_FAILURE);
  	}

  	ret = sys_move_mount(fd_tree, "", -EBADF, target, MOVE_MOUNT_F_EMPTY_PATH);
  	if (ret < 0)
  		exit_log("%m - Failed to attach mount to %s\n", target);
  	close(fd_tree);

  	exit(EXIT_SUCCESS);
  }

2. Run a loop like:

while true; do sudo ./repro; done

and wait for the kernel to refuse any new mounts by returning ENOSPC.
Depending on the number of mounts you have on the system this might take
shorter or longer.

The root cause of this is that detached mounts aren't handled correctly
when the destination mount point is MS_SHARED causing  a borked mount
tree and ultimately to a miscalculation of the number of mounts in the
mount namespace.

Detached mounts created via
open_tree(fd, path, OPEN_TREE_CLONE)
are essentially like an unattached new mount, or an unattached
bind-mount. They can then later on be attached to the filesystem via
move_mount() which calles into attach_recursive_mount(). Part of
attaching it to the filesystem is making sure that mounts get correctly
propagated in case the destination mountpoint is MS_SHARED, i.e.  is a
shared mountpoint. This is done by calling into propagate_mnt() which
walks the list of peers calling propagate_one() on each mount in this
list making sure it receives the propagation event.
For new mounts and bind-mounts propagate_one() knows to skip them by
realizing that there's no mount namespace attached to them.
However, detached mounts have an anonymous mount namespace attached to
them and so they aren't skipped causing the mount table to get wonky and
ultimately preventing any new mounts via the ENOSPC issue.

So teach propagation to handle detached mounts by making it aware of
them. I've been tracking this issue down for the last couple of days by
unmounting everything in my current mount table leaving only /proc and
/sys mounted and running the reproducer above verifying the counting of
the mounts. With this fix the counts are correct and the ENOSPC issue
can't be reproduced.

Fixes: 2db154b3ea8e ("vfs: syscall: Add move_mount(2) to move mounts around")
Cc: Christoph Hellwig <hch@lst.de>
Cc: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org
Cc: <stable@vger.kernel.org>
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 fs/pnode.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/pnode.h b/fs/pnode.h
index 26f74e092bd9..988f1aa9b02a 100644
--- a/fs/pnode.h
+++ b/fs/pnode.h
@@ -12,7 +12,7 @@
 
 #define IS_MNT_SHARED(m) ((m)->mnt.mnt_flags & MNT_SHARED)
 #define IS_MNT_SLAVE(m) ((m)->mnt_master)
-#define IS_MNT_NEW(m)  (!(m)->mnt_ns)
+#define IS_MNT_NEW(m)  (!(m)->mnt_ns || is_anon_ns((m)->mnt_ns))
 #define CLEAR_MNT_SHARED(m) ((m)->mnt.mnt_flags &= ~MNT_SHARED)
 #define IS_MNT_UNBINDABLE(m) ((m)->mnt.mnt_flags & MNT_UNBINDABLE)
 #define IS_MNT_MARKED(m) ((m)->mnt.mnt_flags & MNT_MARKED)

base-commit: f69d02e37a85645aa90d18cacfff36dba370f797
-- 
2.27.0

