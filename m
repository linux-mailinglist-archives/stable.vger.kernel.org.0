Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 706A161685
	for <lists+stable@lfdr.de>; Sun,  7 Jul 2019 21:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727052AbfGGTkV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jul 2019 15:40:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58158 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727690AbfGGTiT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jul 2019 15:38:19 -0400
Received: from 94.197.121.43.threembb.co.uk ([94.197.121.43] helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCzG-0006j1-7y; Sun, 07 Jul 2019 20:38:14 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz9-0005gL-GM; Sun, 07 Jul 2019 20:38:07 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Kirill Smelkov" <kirr@nexedi.com>,
        "Miklos Szeredi" <mszeredi@redhat.com>, stable@vger.kernel.org
Date:   Sun, 07 Jul 2019 17:54:17 +0100
Message-ID: <lsq.1562518457.894543405@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 123/129] fuse: Add FOPEN_STREAM to use stream_open()
In-Reply-To: <lsq.1562518456.876074874@decadent.org.uk>
X-SA-Exim-Connect-IP: 94.197.121.43
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.70-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Kirill Smelkov <kirr@nexedi.com>

commit bbd84f33652f852ce5992d65db4d020aba21f882 upstream.

Starting from commit 9c225f2655e3 ("vfs: atomic f_pos accesses as per
POSIX") files opened even via nonseekable_open gate read and write via lock
and do not allow them to be run simultaneously. This can create read vs
write deadlock if a filesystem is trying to implement a socket-like file
which is intended to be simultaneously used for both read and write from
filesystem client.  See commit 10dce8af3422 ("fs: stream_open - opener for
stream-like files so that read and write can run simultaneously without
deadlock") for details and e.g. commit 581d21a2d02a ("xenbus: fix deadlock
on writes to /proc/xen/xenbus") for a similar deadlock example on
/proc/xen/xenbus.

To avoid such deadlock it was tempting to adjust fuse_finish_open to use
stream_open instead of nonseekable_open on just FOPEN_NONSEEKABLE flags,
but grepping through Debian codesearch shows users of FOPEN_NONSEEKABLE,
and in particular GVFS which actually uses offset in its read and write
handlers

	https://codesearch.debian.net/search?q=-%3Enonseekable+%3D
	https://gitlab.gnome.org/GNOME/gvfs/blob/1.40.0-6-gcbc54396/client/gvfsfusedaemon.c#L1080
	https://gitlab.gnome.org/GNOME/gvfs/blob/1.40.0-6-gcbc54396/client/gvfsfusedaemon.c#L1247-1346
	https://gitlab.gnome.org/GNOME/gvfs/blob/1.40.0-6-gcbc54396/client/gvfsfusedaemon.c#L1399-1481

so if we would do such a change it will break a real user.

Add another flag (FOPEN_STREAM) for filesystem servers to indicate that the
opened handler is having stream-like semantics; does not use file position
and thus the kernel is free to issue simultaneous read and write request on
opened file handle.

This patch together with stream_open() should be added to stable kernels
starting from v3.14+. This will allow to patch OSSPD and other FUSE
filesystems that provide stream-like files to return FOPEN_STREAM |
FOPEN_NONSEEKABLE in open handler and this way avoid the deadlock on all
kernel versions. This should work because fuse_finish_open ignores unknown
open flags returned from a filesystem and so passing FOPEN_STREAM to a
kernel that is not aware of this flag cannot hurt. In turn the kernel that
is not aware of FOPEN_STREAM will be < v3.14 where just FOPEN_NONSEEKABLE
is sufficient to implement streams without read vs write deadlock.

Cc: stable@vger.kernel.org # v3.14+
Signed-off-by: Kirill Smelkov <kirr@nexedi.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/fuse/file.c            | 4 +++-
 include/uapi/linux/fuse.h | 2 ++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index bc8f5de48fd9..69e471b042a6 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -214,7 +214,9 @@ void fuse_finish_open(struct inode *inode, struct file *file)
 		file->f_op = &fuse_direct_io_file_operations;
 	if (!(ff->open_flags & FOPEN_KEEP_CACHE))
 		invalidate_inode_pages2(inode->i_mapping);
-	if (ff->open_flags & FOPEN_NONSEEKABLE)
+	if (ff->open_flags & FOPEN_STREAM)
+		stream_open(inode, file);
+	else if (ff->open_flags & FOPEN_NONSEEKABLE)
 		nonseekable_open(inode, file);
 	if (fc->atomic_o_trunc && (file->f_flags & O_TRUNC)) {
 		struct fuse_inode *fi = get_fuse_inode(inode);
diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
index 25084a052a1e..cff91b018953 100644
--- a/include/uapi/linux/fuse.h
+++ b/include/uapi/linux/fuse.h
@@ -205,10 +205,12 @@ struct fuse_file_lock {
  * FOPEN_DIRECT_IO: bypass page cache for this open file
  * FOPEN_KEEP_CACHE: don't invalidate the data cache on open
  * FOPEN_NONSEEKABLE: the file is not seekable
+ * FOPEN_STREAM: the file is stream-like (no file position at all)
  */
 #define FOPEN_DIRECT_IO		(1 << 0)
 #define FOPEN_KEEP_CACHE	(1 << 1)
 #define FOPEN_NONSEEKABLE	(1 << 2)
+#define FOPEN_STREAM		(1 << 4)
 
 /**
  * INIT request/reply flags

