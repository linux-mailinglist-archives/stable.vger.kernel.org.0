Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4AA120150A
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390863AbgFSQRU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:17:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:59144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390845AbgFSPCd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:02:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 119D221841;
        Fri, 19 Jun 2020 15:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578952;
        bh=ZR4AINEJ0HXo04aAnhgMlxdhz1Gu2pYnd6eCZvpm7hM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ipp+7iYjpTx8u6JUg3Nlb4xRfPBByl5MDYipwn7cn9mQo55K1EUG64hAhGSN9+ZQx
         OoMX4s6/W3rTtpK+FD5QwG8PO5s+aXZi9SVy44YpMTvtRhHjgMFpce4E4Oz56B7rbd
         UNUYIp6ZfvlOXraD/1NjHcnfvGPOdKTlkWPdFapE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Marcos Paulo de Souza <mpdesouza@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.19 189/267] btrfs: send: emit file capabilities after chown
Date:   Fri, 19 Jun 2020 16:32:54 +0200
Message-Id: <20200619141657.810851803@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141648.840376470@linuxfoundation.org>
References: <20200619141648.840376470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcos Paulo de Souza <mpdesouza@suse.com>

commit 89efda52e6b6930f80f5adda9c3c9edfb1397191 upstream.

Whenever a chown is executed, all capabilities of the file being touched
are lost.  When doing incremental send with a file with capabilities,
there is a situation where the capability can be lost on the receiving
side. The sequence of actions bellow shows the problem:

  $ mount /dev/sda fs1
  $ mount /dev/sdb fs2

  $ touch fs1/foo.bar
  $ setcap cap_sys_nice+ep fs1/foo.bar
  $ btrfs subvolume snapshot -r fs1 fs1/snap_init
  $ btrfs send fs1/snap_init | btrfs receive fs2

  $ chgrp adm fs1/foo.bar
  $ setcap cap_sys_nice+ep fs1/foo.bar

  $ btrfs subvolume snapshot -r fs1 fs1/snap_complete
  $ btrfs subvolume snapshot -r fs1 fs1/snap_incremental

  $ btrfs send fs1/snap_complete | btrfs receive fs2
  $ btrfs send -p fs1/snap_init fs1/snap_incremental | btrfs receive fs2

At this point, only a chown was emitted by "btrfs send" since only the
group was changed. This makes the cap_sys_nice capability to be dropped
from fs2/snap_incremental/foo.bar

To fix that, only emit capabilities after chown is emitted. The current
code first checks for xattrs that are new/changed, emits them, and later
emit the chown. Now, __process_new_xattr skips capabilities, letting
only finish_inode_if_needed to emit them, if they exist, for the inode
being processed.

This behavior was being worked around in "btrfs receive" side by caching
the capability and only applying it after chown. Now, xattrs are only
emmited _after_ chown, making that workaround not needed anymore.

Link: https://github.com/kdave/btrfs-progs/issues/202
CC: stable@vger.kernel.org # 4.4+
Suggested-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/send.c |   67 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 67 insertions(+)

--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -23,6 +23,7 @@
 #include "btrfs_inode.h"
 #include "transaction.h"
 #include "compression.h"
+#include "xattr.h"
 
 /*
  * Maximum number of references an extent can have in order for us to attempt to
@@ -4543,6 +4544,10 @@ static int __process_new_xattr(int num,
 	struct fs_path *p;
 	struct posix_acl_xattr_header dummy_acl;
 
+	/* Capabilities are emitted by finish_inode_if_needed */
+	if (!strncmp(name, XATTR_NAME_CAPS, name_len))
+		return 0;
+
 	p = fs_path_alloc();
 	if (!p)
 		return -ENOMEM;
@@ -5105,6 +5110,64 @@ static int send_extent_data(struct send_
 	return 0;
 }
 
+/*
+ * Search for a capability xattr related to sctx->cur_ino. If the capability is
+ * found, call send_set_xattr function to emit it.
+ *
+ * Return 0 if there isn't a capability, or when the capability was emitted
+ * successfully, or < 0 if an error occurred.
+ */
+static int send_capabilities(struct send_ctx *sctx)
+{
+	struct fs_path *fspath = NULL;
+	struct btrfs_path *path;
+	struct btrfs_dir_item *di;
+	struct extent_buffer *leaf;
+	unsigned long data_ptr;
+	char *buf = NULL;
+	int buf_len;
+	int ret = 0;
+
+	path = alloc_path_for_send();
+	if (!path)
+		return -ENOMEM;
+
+	di = btrfs_lookup_xattr(NULL, sctx->send_root, path, sctx->cur_ino,
+				XATTR_NAME_CAPS, strlen(XATTR_NAME_CAPS), 0);
+	if (!di) {
+		/* There is no xattr for this inode */
+		goto out;
+	} else if (IS_ERR(di)) {
+		ret = PTR_ERR(di);
+		goto out;
+	}
+
+	leaf = path->nodes[0];
+	buf_len = btrfs_dir_data_len(leaf, di);
+
+	fspath = fs_path_alloc();
+	buf = kmalloc(buf_len, GFP_KERNEL);
+	if (!fspath || !buf) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = get_cur_path(sctx, sctx->cur_ino, sctx->cur_inode_gen, fspath);
+	if (ret < 0)
+		goto out;
+
+	data_ptr = (unsigned long)(di + 1) + btrfs_dir_name_len(leaf, di);
+	read_extent_buffer(leaf, buf, data_ptr, buf_len);
+
+	ret = send_set_xattr(sctx, fspath, XATTR_NAME_CAPS,
+			strlen(XATTR_NAME_CAPS), buf, buf_len);
+out:
+	kfree(buf);
+	fs_path_free(fspath);
+	btrfs_free_path(path);
+	return ret;
+}
+
 static int clone_range(struct send_ctx *sctx,
 		       struct clone_root *clone_root,
 		       const u64 disk_byte,
@@ -5936,6 +5999,10 @@ static int finish_inode_if_needed(struct
 			goto out;
 	}
 
+	ret = send_capabilities(sctx);
+	if (ret < 0)
+		goto out;
+
 	/*
 	 * If other directory inodes depended on our current directory
 	 * inode's move/rename, now do their move/rename operations.


