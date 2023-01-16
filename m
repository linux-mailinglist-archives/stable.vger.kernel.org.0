Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71BD966C581
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:07:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232177AbjAPQHA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:07:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232084AbjAPQGU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:06:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4865252AC
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:04:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6CFE8B8107A
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:04:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA2BEC433D2;
        Mon, 16 Jan 2023 16:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885084;
        bh=wwpfJmI1YXcpT+4ylqrACW3ZhuunBEfws9jqAaFWiSc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wSM/lGjiQYSCw0/FfFv/kjSPyt0Kzl3nR50BJt9sJLyy68gCwmbajz+QpW3leNCOe
         RL5WWvxx/eJjlhp5/bzvP4fahl2kuODzhpsnAawU6Jz4f6kIsyWTEC0+ze9rHryuO3
         w//zVrA9XUXf9TT/s2XqzbIGQgPZo8C7YONLCztM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Willy Tarreau <w@1wt.eu>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 61/86] tools/nolibc/types: split syscall-specific definitions into their own files
Date:   Mon, 16 Jan 2023 16:51:35 +0100
Message-Id: <20230116154749.607355459@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154747.036911298@linuxfoundation.org>
References: <20230116154747.036911298@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Willy Tarreau <w@1wt.eu>

[ Upstream commit cc7a492ad0a076dff5cb4281b1516676d7924fcf ]

The macros and type definitions used by a number of syscalls were moved
to types.h where they will be easier to maintain. A few of them
are arch-specific and must not be moved there (e.g. O_*, sys_stat_struct).
A warning about them was placed at the top of the file.

Signed-off-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Stable-dep-of: 184177c3d6e0 ("tools/nolibc: restore mips branch ordering in the _start block")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/nolibc/nolibc.h | 110 +---------------------------
 tools/include/nolibc/types.h  | 133 ++++++++++++++++++++++++++++++++++
 2 files changed, 135 insertions(+), 108 deletions(-)
 create mode 100644 tools/include/nolibc/types.h

diff --git a/tools/include/nolibc/nolibc.h b/tools/include/nolibc/nolibc.h
index 41eb7e647238..fbfc02aa99c3 100644
--- a/tools/include/nolibc/nolibc.h
+++ b/tools/include/nolibc/nolibc.h
@@ -92,7 +92,9 @@
 #include <linux/fs.h>
 #include <linux/loop.h>
 #include <linux/time.h>
+#include "types.h"
 
+/* Used by programs to avoid std includes */
 #define NOLIBC
 
 /* this way it will be removed if unused */
@@ -109,114 +111,6 @@ static int errno;
  */
 #define MAX_ERRNO 4095
 
-/* for poll() */
-struct pollfd {
-	int fd;
-	short int events;
-	short int revents;
-};
-
-/* for getdents64() */
-struct linux_dirent64 {
-	uint64_t       d_ino;
-	int64_t        d_off;
-	unsigned short d_reclen;
-	unsigned char  d_type;
-	char           d_name[];
-};
-
-/* commonly an fd_set represents 256 FDs */
-#define FD_SETSIZE 256
-typedef struct { uint32_t fd32[FD_SETSIZE/32]; } fd_set;
-
-/* needed by wait4() */
-struct rusage {
-	struct timeval ru_utime;
-	struct timeval ru_stime;
-	long   ru_maxrss;
-	long   ru_ixrss;
-	long   ru_idrss;
-	long   ru_isrss;
-	long   ru_minflt;
-	long   ru_majflt;
-	long   ru_nswap;
-	long   ru_inblock;
-	long   ru_oublock;
-	long   ru_msgsnd;
-	long   ru_msgrcv;
-	long   ru_nsignals;
-	long   ru_nvcsw;
-	long   ru_nivcsw;
-};
-
-/* stat flags (WARNING, octal here) */
-#define S_IFDIR       0040000
-#define S_IFCHR       0020000
-#define S_IFBLK       0060000
-#define S_IFREG       0100000
-#define S_IFIFO       0010000
-#define S_IFLNK       0120000
-#define S_IFSOCK      0140000
-#define S_IFMT        0170000
-
-#define S_ISDIR(mode)  (((mode) & S_IFDIR) == S_IFDIR)
-#define S_ISCHR(mode)  (((mode) & S_IFCHR) == S_IFCHR)
-#define S_ISBLK(mode)  (((mode) & S_IFBLK) == S_IFBLK)
-#define S_ISREG(mode)  (((mode) & S_IFREG) == S_IFREG)
-#define S_ISFIFO(mode) (((mode) & S_IFIFO) == S_IFIFO)
-#define S_ISLNK(mode)  (((mode) & S_IFLNK) == S_IFLNK)
-#define S_ISSOCK(mode) (((mode) & S_IFSOCK) == S_IFSOCK)
-
-#define DT_UNKNOWN 0
-#define DT_FIFO    1
-#define DT_CHR     2
-#define DT_DIR     4
-#define DT_BLK     6
-#define DT_REG     8
-#define DT_LNK    10
-#define DT_SOCK   12
-
-/* all the *at functions */
-#ifndef AT_FDCWD
-#define AT_FDCWD             -100
-#endif
-
-/* lseek */
-#define SEEK_SET        0
-#define SEEK_CUR        1
-#define SEEK_END        2
-
-/* reboot */
-#define LINUX_REBOOT_MAGIC1         0xfee1dead
-#define LINUX_REBOOT_MAGIC2         0x28121969
-#define LINUX_REBOOT_CMD_HALT       0xcdef0123
-#define LINUX_REBOOT_CMD_POWER_OFF  0x4321fedc
-#define LINUX_REBOOT_CMD_RESTART    0x01234567
-#define LINUX_REBOOT_CMD_SW_SUSPEND 0xd000fce2
-
-
-/* The format of the struct as returned by the libc to the application, which
- * significantly differs from the format returned by the stat() syscall flavours.
- */
-struct stat {
-	dev_t     st_dev;     /* ID of device containing file */
-	ino_t     st_ino;     /* inode number */
-	mode_t    st_mode;    /* protection */
-	nlink_t   st_nlink;   /* number of hard links */
-	uid_t     st_uid;     /* user ID of owner */
-	gid_t     st_gid;     /* group ID of owner */
-	dev_t     st_rdev;    /* device ID (if special file) */
-	off_t     st_size;    /* total size, in bytes */
-	blksize_t st_blksize; /* blocksize for file system I/O */
-	blkcnt_t  st_blocks;  /* number of 512B blocks allocated */
-	time_t    st_atime;   /* time of last access */
-	time_t    st_mtime;   /* time of last modification */
-	time_t    st_ctime;   /* time of last status change */
-};
-
-#define WEXITSTATUS(status)   (((status) & 0xff00) >> 8)
-#define WIFEXITED(status)     (((status) & 0x7f) == 0)
-
 /* Below comes the architecture-specific code. For each architecture, we have
  * the syscall declarations and the _start code definition. This is the only
  * global part. On all architectures the kernel puts everything in the stack
diff --git a/tools/include/nolibc/types.h b/tools/include/nolibc/types.h
new file mode 100644
index 000000000000..2f09abaf95f1
--- /dev/null
+++ b/tools/include/nolibc/types.h
@@ -0,0 +1,133 @@
+/* SPDX-License-Identifier: LGPL-2.1 OR MIT */
+/*
+ * Special types used by various syscalls for NOLIBC
+ * Copyright (C) 2017-2021 Willy Tarreau <w@1wt.eu>
+ */
+
+#ifndef _NOLIBC_TYPES_H
+#define _NOLIBC_TYPES_H
+
+#include "std.h"
+#include <linux/time.h>
+
+
+/* Only the generic macros and types may be defined here. The arch-specific
+ * ones such as the O_RDONLY and related macros used by fcntl() and open(), or
+ * the layout of sys_stat_struct must not be defined here.
+ */
+
+/* stat flags (WARNING, octal here) */
+#define S_IFDIR        0040000
+#define S_IFCHR        0020000
+#define S_IFBLK        0060000
+#define S_IFREG        0100000
+#define S_IFIFO        0010000
+#define S_IFLNK        0120000
+#define S_IFSOCK       0140000
+#define S_IFMT         0170000
+
+#define S_ISDIR(mode)  (((mode) & S_IFDIR)  == S_IFDIR)
+#define S_ISCHR(mode)  (((mode) & S_IFCHR)  == S_IFCHR)
+#define S_ISBLK(mode)  (((mode) & S_IFBLK)  == S_IFBLK)
+#define S_ISREG(mode)  (((mode) & S_IFREG)  == S_IFREG)
+#define S_ISFIFO(mode) (((mode) & S_IFIFO)  == S_IFIFO)
+#define S_ISLNK(mode)  (((mode) & S_IFLNK)  == S_IFLNK)
+#define S_ISSOCK(mode) (((mode) & S_IFSOCK) == S_IFSOCK)
+
+/* dirent types */
+#define DT_UNKNOWN     0x0
+#define DT_FIFO        0x1
+#define DT_CHR         0x2
+#define DT_DIR         0x4
+#define DT_BLK         0x6
+#define DT_REG         0x8
+#define DT_LNK         0xa
+#define DT_SOCK        0xc
+
+/* commonly an fd_set represents 256 FDs */
+#define FD_SETSIZE     256
+
+/* Special FD used by all the *at functions */
+#ifndef AT_FDCWD
+#define AT_FDCWD       (-100)
+#endif
+
+/* whence values for lseek() */
+#define SEEK_SET       0
+#define SEEK_CUR       1
+#define SEEK_END       2
+
+/* cmd for reboot() */
+#define LINUX_REBOOT_MAGIC1         0xfee1dead
+#define LINUX_REBOOT_MAGIC2         0x28121969
+#define LINUX_REBOOT_CMD_HALT       0xcdef0123
+#define LINUX_REBOOT_CMD_POWER_OFF  0x4321fedc
+#define LINUX_REBOOT_CMD_RESTART    0x01234567
+#define LINUX_REBOOT_CMD_SW_SUSPEND 0xd000fce2
+
+/* Macros used on waitpid()'s return status */
+#define WEXITSTATUS(status) (((status) & 0xff00) >> 8)
+#define WIFEXITED(status)   (((status) & 0x7f) == 0)
+
+
+/* for select() */
+typedef struct {
+	uint32_t fd32[FD_SETSIZE / 32];
+} fd_set;
+
+/* for poll() */
+struct pollfd {
+	int fd;
+	short int events;
+	short int revents;
+};
+
+/* for getdents64() */
+struct linux_dirent64 {
+	uint64_t       d_ino;
+	int64_t        d_off;
+	unsigned short d_reclen;
+	unsigned char  d_type;
+	char           d_name[];
+};
+
+/* needed by wait4() */
+struct rusage {
+	struct timeval ru_utime;
+	struct timeval ru_stime;
+	long   ru_maxrss;
+	long   ru_ixrss;
+	long   ru_idrss;
+	long   ru_isrss;
+	long   ru_minflt;
+	long   ru_majflt;
+	long   ru_nswap;
+	long   ru_inblock;
+	long   ru_oublock;
+	long   ru_msgsnd;
+	long   ru_msgrcv;
+	long   ru_nsignals;
+	long   ru_nvcsw;
+	long   ru_nivcsw;
+};
+
+/* The format of the struct as returned by the libc to the application, which
+ * significantly differs from the format returned by the stat() syscall flavours.
+ */
+struct stat {
+	dev_t     st_dev;     /* ID of device containing file */
+	ino_t     st_ino;     /* inode number */
+	mode_t    st_mode;    /* protection */
+	nlink_t   st_nlink;   /* number of hard links */
+	uid_t     st_uid;     /* user ID of owner */
+	gid_t     st_gid;     /* group ID of owner */
+	dev_t     st_rdev;    /* device ID (if special file) */
+	off_t     st_size;    /* total size, in bytes */
+	blksize_t st_blksize; /* blocksize for file system I/O */
+	blkcnt_t  st_blocks;  /* number of 512B blocks allocated */
+	time_t    st_atime;   /* time of last access */
+	time_t    st_mtime;   /* time of last modification */
+	time_t    st_ctime;   /* time of last status change */
+};
+
+#endif /* _NOLIBC_TYPES_H */
-- 
2.35.1



