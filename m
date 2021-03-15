Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFECD33B678
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:59:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232223AbhCON55 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:57:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:34114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231976AbhCON50 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:57:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C58F664F2B;
        Mon, 15 Mar 2021 13:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816646;
        bh=vIoJfkP/KyKIowEL//154z/eF4hgW/Ht+kKhEUmzkKo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jWbduCVYUimb37W/zPEKAJAWiaM0MvEHpb0xBhcoQp0Lhh9Qqitz6TgSzVNg7gfFK
         xhpqrpR0lrIx2hprUMGNDzCy8ITKpzJHYEnwMQIeTyg2XdznMFGScYTtke53NNIi3U
         OyNeLVfZEA7jVg8jGkt0DYHRkFqW/uXI4K/jb/dU=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH 5.4 023/168] mount: fix mounting of detached mounts onto targets that reside on shared mounts
Date:   Mon, 15 Mar 2021 14:54:15 +0100
Message-Id: <20210315135551.116785615@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135550.333963635@linuxfoundation.org>
References: <20210315135550.333963635@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Christian Brauner <christian.brauner@ubuntu.com>

commit ee2e3f50629f17b0752b55b2566c15ce8dafb557 upstream.

Creating a series of detached mounts, attaching them to the filesystem,
and unmounting them can be used to trigger an integer overflow in
ns->mounts causing the kernel to block any new mounts in count_mounts()
and returning ENOSPC because it falsely assumes that the maximum number
of mounts in the mount namespace has been reached, i.e. it thinks it
can't fit the new mounts into the mount namespace anymore.

Depending on the number of mounts in your system, this can be reproduced
on any kernel that supportes open_tree() and move_mount() by compiling
and running the following program:

  /* SPDX-License-Identifier: LGPL-2.1+ */

  #define _GNU_SOURCE
  #include <errno.h>
  #include <fcntl.h>
  #include <getopt.h>
  #include <limits.h>
  #include <stdbool.h>
  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>
  #include <sys/mount.h>
  #include <sys/stat.h>
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
                  #if _MIPS_SIM == _MIPS_SIM_ABI32        /* o32 */
                          #define __NR_open_tree 4428
                  #endif
                  #if _MIPS_SIM == _MIPS_SIM_NABI32       /* n32 */
                          #define __NR_open_tree 6428
                  #endif
                  #if _MIPS_SIM == _MIPS_SIM_ABI64        /* n64 */
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
                  #if _MIPS_SIM == _MIPS_SIM_ABI32        /* o32 */
                          #define __NR_move_mount 4429
                  #endif
                  #if _MIPS_SIM == _MIPS_SIM_NABI32       /* n32 */
                          #define __NR_move_mount 6429
                  #endif
                  #if _MIPS_SIM == _MIPS_SIM_ABI64        /* n64 */
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

  static bool is_shared_mountpoint(const char *path)
  {
          bool shared = false;
          FILE *f = NULL;
          char *line = NULL;
          int i;
          size_t len = 0;

          f = fopen("/proc/self/mountinfo", "re");
          if (!f)
                  return 0;

          while (getline(&line, &len, f) > 0) {
                  char *slider1, *slider2;

                  for (slider1 = line, i = 0; slider1 && i < 4; i++)
                          slider1 = strchr(slider1 + 1, ' ');

                  if (!slider1)
                          continue;

                  slider2 = strchr(slider1 + 1, ' ');
                  if (!slider2)
                          continue;

                  *slider2 = '\0';
                  if (strcmp(slider1 + 1, path) == 0) {
                          /* This is the path. Is it shared? */
                          slider1 = strchr(slider2 + 1, ' ');
                          if (slider1 && strstr(slider1, "shared:")) {
                                  shared = true;
                                  break;
                          }
                  }
          }
          fclose(f);
          free(line);

          return shared;
  }

  static void usage(void)
  {
          const char *text = "mount-new [--recursive] <base-dir>\n";
          fprintf(stderr, "%s", text);
          _exit(EXIT_SUCCESS);
  }

  #define exit_usage(format, ...)                              \
          ({                                                   \
                  fprintf(stderr, format "\n", ##__VA_ARGS__); \
                  usage();                                     \
          })

  #define exit_log(format, ...)                                \
          ({                                                   \
                  fprintf(stderr, format "\n", ##__VA_ARGS__); \
                  exit(EXIT_FAILURE);                          \
          })

  static const struct option longopts[] = {
          {"help",        no_argument,            0,      'a'},
          { NULL,         no_argument,            0,       0 },
  };

  int main(int argc, char *argv[])
  {
          int exit_code = EXIT_SUCCESS, index = 0;
          int dfd, fd_tree, new_argc, ret;
          char *base_dir;
          char *const *new_argv;
          char target[PATH_MAX];

          while ((ret = getopt_long_only(argc, argv, "", longopts, &index)) != -1) {
                  switch (ret) {
                  case 'a':
                          /* fallthrough */
                  default:
                          usage();
                  }
          }

          new_argv = &argv[optind];
          new_argc = argc - optind;
          if (new_argc < 1)
                  exit_usage("Missing base directory\n");
          base_dir = new_argv[0];

          if (*base_dir != '/')
                  exit_log("Please specify an absolute path");

          /* Ensure that target is a shared mountpoint. */
          if (!is_shared_mountpoint(base_dir))
                  exit_log("Please ensure that \"%s\" is a shared mountpoint", base_dir);

          dfd = open(base_dir, O_RDONLY | O_DIRECTORY | O_CLOEXEC);
          if (dfd < 0)
                  exit_log("%m - Failed to open base directory \"%s\"", base_dir);

          ret = mkdirat(dfd, "detached-move-mount", 0755);
          if (ret < 0)
                  exit_log("%m - Failed to create required temporary directories");

          ret = snprintf(target, sizeof(target), "%s/detached-move-mount", base_dir);
          if (ret < 0 || (size_t)ret >= sizeof(target))
                  exit_log("%m - Failed to assemble target path");

          /*
           * Having a mount table with 10000 mounts is already quite excessive
           * and shoult account even for weird test systems.
           */
          for (size_t i = 0; i < 10000; i++) {
                  fd_tree = sys_open_tree(dfd, "detached-move-mount",
                                          OPEN_TREE_CLONE |
                                          OPEN_TREE_CLOEXEC |
                                          AT_EMPTY_PATH);
                  if (fd_tree < 0) {
                          fprintf(stderr, "%m - Failed to open %d(detached-move-mount)", dfd);
                          exit_code = EXIT_FAILURE;
                          break;
                  }

                  ret = sys_move_mount(fd_tree, "", dfd, "detached-move-mount", MOVE_MOUNT_F_EMPTY_PATH);
                  if (ret < 0) {
                          if (errno == ENOSPC)
                                  fprintf(stderr, "%m - Buggy mount counting");
                          else
                                  fprintf(stderr, "%m - Failed to attach mount to %d(detached-move-mount)", dfd);
                          exit_code = EXIT_FAILURE;
                          break;
                  }
                  close(fd_tree);

                  ret = umount2(target, MNT_DETACH);
                  if (ret < 0) {
                          fprintf(stderr, "%m - Failed to unmount %s", target);
                          exit_code = EXIT_FAILURE;
                          break;
                  }
          }

          (void)unlinkat(dfd, "detached-move-mount", AT_REMOVEDIR);
          close(dfd);

          exit(exit_code);
  }

and wait for the kernel to refuse any new mounts by returning ENOSPC.
How many iterations are needed depends on the number of mounts in your
system. Assuming you have something like 50 mounts on a standard system
it should be almost instantaneous.

The root cause of this is that detached mounts aren't handled correctly
when source and target mount are identical and reside on a shared mount
causing a broken mount tree where the detached source itself is
propagated which propagation prevents for regular bind-mounts and new
mounts. This ultimately leads to a miscalculation of the number of
mounts in the mount namespace.

Detached mounts created via
open_tree(fd, path, OPEN_TREE_CLONE)
are essentially like an unattached new mount, or an unattached
bind-mount. They can then later on be attached to the filesystem via
move_mount() which calls into attach_recursive_mount(). Part of
attaching it to the filesystem is making sure that mounts get correctly
propagated in case the destination mountpoint is MS_SHARED, i.e. is a
shared mountpoint. This is done by calling into propagate_mnt() which
walks the list of peers calling propagate_one() on each mount in this
list making sure it receives the propagation event.
The propagate_one() functions thereby skips both new mounts and bind
mounts to not propagate them "into themselves". Both are identified by
checking whether the mount is already attached to any mount namespace in
mnt->mnt_ns. The is what the IS_MNT_NEW() helper is responsible for.

However, detached mounts have an anonymous mount namespace attached to
them stashed in mnt->mnt_ns which means that IS_MNT_NEW() doesn't
realize they need to be skipped causing the mount to propagate "into
itself" breaking the mount table and causing a disconnect between the
number of mounts recorded as being beneath or reachable from the target
mountpoint and the number of mounts actually recorded/counted in
ns->mounts ultimately causing an overflow which in turn prevents any new
mounts via the ENOSPC issue.

So teach propagation to handle detached mounts by making it aware of
them. I've been tracking this issue down for the last couple of days and
then verifying that the fix is correct by
unmounting everything in my current mount table leaving only /proc and
/sys mounted and running the reproducer above overnight verifying the
number of mounts counted in ns->mounts. With this fix the counts are
correct and the ENOSPC issue can't be reproduced.

This change will only have an effect on mounts created with the new
mount API since detached mounts cannot be created with the old mount API
so regressions are extremely unlikely.

Link: https://lore.kernel.org/r/20210306101010.243666-1-christian.brauner@ubuntu.com
Fixes: 2db154b3ea8e ("vfs: syscall: Add move_mount(2) to move mounts around")
Cc: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org
Cc: <stable@vger.kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/pnode.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


