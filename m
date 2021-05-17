Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E234383587
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239797AbhEQPXC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:23:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:57498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244000AbhEQPRO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:17:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D17C161919;
        Mon, 17 May 2021 14:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261985;
        bh=Cd5mqYR84zBiwxDbvgj+kl3P4OKZXzWnnKmbnkpyB6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HvKpYeYb5zBa5WRV4EKfwLto2zSd3fJWxTuhR3yD+YMNaTouy0fqKyPAz8qJ2wDh+
         jUSisFGW2g8fG55y+RchAYrY5hQsFTZtrE/GHGCWGj01OGd5/N0eZm8+fgEK6Brkac
         egUm3M8wMVd3SZ8DaLk1UywyLOmusyJOXc4P874g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 095/289] f2fs: move ioctl interface definitions to separated file
Date:   Mon, 17 May 2021 16:00:20 +0200
Message-Id: <20210517140308.385166603@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit fa4320cefb8537a70cc28c55d311a1f569697cd3 ]

Like other filesystem does, we introduce a new file f2fs.h in path of
include/uapi/linux/, and move f2fs-specified ioctl interface definitions
to that file, after then, in order to use those definitions, userspace
developer only need to include the new header file rather than
copy & paste definitions from fs/f2fs/f2fs.h.

Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 MAINTAINERS                 |  1 +
 fs/f2fs/f2fs.h              | 79 ---------------------------------
 fs/f2fs/file.c              |  1 +
 include/trace/events/f2fs.h |  1 +
 include/uapi/linux/f2fs.h   | 87 +++++++++++++++++++++++++++++++++++++
 5 files changed, 90 insertions(+), 79 deletions(-)
 create mode 100644 include/uapi/linux/f2fs.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 24cdfcf334ea..4fef10dd2975 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6694,6 +6694,7 @@ F:	Documentation/filesystems/f2fs.rst
 F:	fs/f2fs/
 F:	include/linux/f2fs_fs.h
 F:	include/trace/events/f2fs.h
+F:	include/uapi/linux/f2fs.h
 
 F71805F HARDWARE MONITORING DRIVER
 M:	Jean Delvare <jdelvare@suse.com>
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 699815e94bd3..af294eb23283 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -402,85 +402,6 @@ static inline bool __has_cursum_space(struct f2fs_journal *journal,
 	return size <= MAX_SIT_JENTRIES(journal);
 }
 
-/*
- * f2fs-specific ioctl commands
- */
-#define F2FS_IOCTL_MAGIC		0xf5
-#define F2FS_IOC_START_ATOMIC_WRITE	_IO(F2FS_IOCTL_MAGIC, 1)
-#define F2FS_IOC_COMMIT_ATOMIC_WRITE	_IO(F2FS_IOCTL_MAGIC, 2)
-#define F2FS_IOC_START_VOLATILE_WRITE	_IO(F2FS_IOCTL_MAGIC, 3)
-#define F2FS_IOC_RELEASE_VOLATILE_WRITE	_IO(F2FS_IOCTL_MAGIC, 4)
-#define F2FS_IOC_ABORT_VOLATILE_WRITE	_IO(F2FS_IOCTL_MAGIC, 5)
-#define F2FS_IOC_GARBAGE_COLLECT	_IOW(F2FS_IOCTL_MAGIC, 6, __u32)
-#define F2FS_IOC_WRITE_CHECKPOINT	_IO(F2FS_IOCTL_MAGIC, 7)
-#define F2FS_IOC_DEFRAGMENT		_IOWR(F2FS_IOCTL_MAGIC, 8,	\
-						struct f2fs_defragment)
-#define F2FS_IOC_MOVE_RANGE		_IOWR(F2FS_IOCTL_MAGIC, 9,	\
-						struct f2fs_move_range)
-#define F2FS_IOC_FLUSH_DEVICE		_IOW(F2FS_IOCTL_MAGIC, 10,	\
-						struct f2fs_flush_device)
-#define F2FS_IOC_GARBAGE_COLLECT_RANGE	_IOW(F2FS_IOCTL_MAGIC, 11,	\
-						struct f2fs_gc_range)
-#define F2FS_IOC_GET_FEATURES		_IOR(F2FS_IOCTL_MAGIC, 12, __u32)
-#define F2FS_IOC_SET_PIN_FILE		_IOW(F2FS_IOCTL_MAGIC, 13, __u32)
-#define F2FS_IOC_GET_PIN_FILE		_IOR(F2FS_IOCTL_MAGIC, 14, __u32)
-#define F2FS_IOC_PRECACHE_EXTENTS	_IO(F2FS_IOCTL_MAGIC, 15)
-#define F2FS_IOC_RESIZE_FS		_IOW(F2FS_IOCTL_MAGIC, 16, __u64)
-#define F2FS_IOC_GET_COMPRESS_BLOCKS	_IOR(F2FS_IOCTL_MAGIC, 17, __u64)
-#define F2FS_IOC_RELEASE_COMPRESS_BLOCKS				\
-					_IOR(F2FS_IOCTL_MAGIC, 18, __u64)
-#define F2FS_IOC_RESERVE_COMPRESS_BLOCKS				\
-					_IOR(F2FS_IOCTL_MAGIC, 19, __u64)
-#define F2FS_IOC_SEC_TRIM_FILE		_IOW(F2FS_IOCTL_MAGIC, 20,	\
-						struct f2fs_sectrim_range)
-
-/*
- * should be same as XFS_IOC_GOINGDOWN.
- * Flags for going down operation used by FS_IOC_GOINGDOWN
- */
-#define F2FS_IOC_SHUTDOWN	_IOR('X', 125, __u32)	/* Shutdown */
-#define F2FS_GOING_DOWN_FULLSYNC	0x0	/* going down with full sync */
-#define F2FS_GOING_DOWN_METASYNC	0x1	/* going down with metadata */
-#define F2FS_GOING_DOWN_NOSYNC		0x2	/* going down */
-#define F2FS_GOING_DOWN_METAFLUSH	0x3	/* going down with meta flush */
-#define F2FS_GOING_DOWN_NEED_FSCK	0x4	/* going down to trigger fsck */
-
-/*
- * Flags used by F2FS_IOC_SEC_TRIM_FILE
- */
-#define F2FS_TRIM_FILE_DISCARD		0x1	/* send discard command */
-#define F2FS_TRIM_FILE_ZEROOUT		0x2	/* zero out */
-#define F2FS_TRIM_FILE_MASK		0x3
-
-struct f2fs_gc_range {
-	u32 sync;
-	u64 start;
-	u64 len;
-};
-
-struct f2fs_defragment {
-	u64 start;
-	u64 len;
-};
-
-struct f2fs_move_range {
-	u32 dst_fd;		/* destination fd */
-	u64 pos_in;		/* start position in src_fd */
-	u64 pos_out;		/* start position in dst_fd */
-	u64 len;		/* size to move */
-};
-
-struct f2fs_flush_device {
-	u32 dev_num;		/* device number to flush */
-	u32 segments;		/* # of segments to flush */
-};
-
-struct f2fs_sectrim_range {
-	u64 start;
-	u64 len;
-	u64 flags;
-};
-
 /* for inline stuff */
 #define DEF_INLINE_RESERVED_SIZE	1
 static inline int get_extra_isize(struct inode *inode);
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 498e3aac7934..28f0bde38806 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -31,6 +31,7 @@
 #include "gc.h"
 #include "trace.h"
 #include <trace/events/f2fs.h>
+#include <uapi/linux/f2fs.h>
 
 static vm_fault_t f2fs_filemap_fault(struct vm_fault *vmf)
 {
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index f8f1e85ff130..56b113e3cd6a 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -6,6 +6,7 @@
 #define _TRACE_F2FS_H
 
 #include <linux/tracepoint.h>
+#include <uapi/linux/f2fs.h>
 
 #define show_dev(dev)		MAJOR(dev), MINOR(dev)
 #define show_dev_ino(entry)	show_dev(entry->dev), (unsigned long)entry->ino
diff --git a/include/uapi/linux/f2fs.h b/include/uapi/linux/f2fs.h
new file mode 100644
index 000000000000..28bcfe8d2c27
--- /dev/null
+++ b/include/uapi/linux/f2fs.h
@@ -0,0 +1,87 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+
+#ifndef _UAPI_LINUX_F2FS_H
+#define _UAPI_LINUX_F2FS_H
+#include <linux/types.h>
+#include <linux/ioctl.h>
+
+/*
+ * f2fs-specific ioctl commands
+ */
+#define F2FS_IOCTL_MAGIC		0xf5
+#define F2FS_IOC_START_ATOMIC_WRITE	_IO(F2FS_IOCTL_MAGIC, 1)
+#define F2FS_IOC_COMMIT_ATOMIC_WRITE	_IO(F2FS_IOCTL_MAGIC, 2)
+#define F2FS_IOC_START_VOLATILE_WRITE	_IO(F2FS_IOCTL_MAGIC, 3)
+#define F2FS_IOC_RELEASE_VOLATILE_WRITE	_IO(F2FS_IOCTL_MAGIC, 4)
+#define F2FS_IOC_ABORT_VOLATILE_WRITE	_IO(F2FS_IOCTL_MAGIC, 5)
+#define F2FS_IOC_GARBAGE_COLLECT	_IOW(F2FS_IOCTL_MAGIC, 6, __u32)
+#define F2FS_IOC_WRITE_CHECKPOINT	_IO(F2FS_IOCTL_MAGIC, 7)
+#define F2FS_IOC_DEFRAGMENT		_IOWR(F2FS_IOCTL_MAGIC, 8,	\
+						struct f2fs_defragment)
+#define F2FS_IOC_MOVE_RANGE		_IOWR(F2FS_IOCTL_MAGIC, 9,	\
+						struct f2fs_move_range)
+#define F2FS_IOC_FLUSH_DEVICE		_IOW(F2FS_IOCTL_MAGIC, 10,	\
+						struct f2fs_flush_device)
+#define F2FS_IOC_GARBAGE_COLLECT_RANGE	_IOW(F2FS_IOCTL_MAGIC, 11,	\
+						struct f2fs_gc_range)
+#define F2FS_IOC_GET_FEATURES		_IOR(F2FS_IOCTL_MAGIC, 12, __u32)
+#define F2FS_IOC_SET_PIN_FILE		_IOW(F2FS_IOCTL_MAGIC, 13, __u32)
+#define F2FS_IOC_GET_PIN_FILE		_IOR(F2FS_IOCTL_MAGIC, 14, __u32)
+#define F2FS_IOC_PRECACHE_EXTENTS	_IO(F2FS_IOCTL_MAGIC, 15)
+#define F2FS_IOC_RESIZE_FS		_IOW(F2FS_IOCTL_MAGIC, 16, __u64)
+#define F2FS_IOC_GET_COMPRESS_BLOCKS	_IOR(F2FS_IOCTL_MAGIC, 17, __u64)
+#define F2FS_IOC_RELEASE_COMPRESS_BLOCKS				\
+					_IOR(F2FS_IOCTL_MAGIC, 18, __u64)
+#define F2FS_IOC_RESERVE_COMPRESS_BLOCKS				\
+					_IOR(F2FS_IOCTL_MAGIC, 19, __u64)
+#define F2FS_IOC_SEC_TRIM_FILE		_IOW(F2FS_IOCTL_MAGIC, 20,	\
+						struct f2fs_sectrim_range)
+
+/*
+ * should be same as XFS_IOC_GOINGDOWN.
+ * Flags for going down operation used by FS_IOC_GOINGDOWN
+ */
+#define F2FS_IOC_SHUTDOWN	_IOR('X', 125, __u32)	/* Shutdown */
+#define F2FS_GOING_DOWN_FULLSYNC	0x0	/* going down with full sync */
+#define F2FS_GOING_DOWN_METASYNC	0x1	/* going down with metadata */
+#define F2FS_GOING_DOWN_NOSYNC		0x2	/* going down */
+#define F2FS_GOING_DOWN_METAFLUSH	0x3	/* going down with meta flush */
+#define F2FS_GOING_DOWN_NEED_FSCK	0x4	/* going down to trigger fsck */
+
+/*
+ * Flags used by F2FS_IOC_SEC_TRIM_FILE
+ */
+#define F2FS_TRIM_FILE_DISCARD		0x1	/* send discard command */
+#define F2FS_TRIM_FILE_ZEROOUT		0x2	/* zero out */
+#define F2FS_TRIM_FILE_MASK		0x3
+
+struct f2fs_gc_range {
+	__u32 sync;
+	__u64 start;
+	__u64 len;
+};
+
+struct f2fs_defragment {
+	__u64 start;
+	__u64 len;
+};
+
+struct f2fs_move_range {
+	__u32 dst_fd;		/* destination fd */
+	__u64 pos_in;		/* start position in src_fd */
+	__u64 pos_out;		/* start position in dst_fd */
+	__u64 len;		/* size to move */
+};
+
+struct f2fs_flush_device {
+	__u32 dev_num;		/* device number to flush */
+	__u32 segments;		/* # of segments to flush */
+};
+
+struct f2fs_sectrim_range {
+	__u64 start;
+	__u64 len;
+	__u64 flags;
+};
+
+#endif /* _UAPI_LINUX_F2FS_H */
-- 
2.30.2



