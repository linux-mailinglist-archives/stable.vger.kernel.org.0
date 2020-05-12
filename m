Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A2DD1CF74F
	for <lists+stable@lfdr.de>; Tue, 12 May 2020 16:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730470AbgELOh3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 May 2020 10:37:29 -0400
Received: from gateway24.websitewelcome.com ([192.185.50.66]:15566 "EHLO
        gateway24.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729962AbgELOh2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 May 2020 10:37:28 -0400
X-Greylist: delayed 131130 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 May 2020 10:37:28 EDT
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway24.websitewelcome.com (Postfix) with ESMTP id 1B31248F1
        for <stable@vger.kernel.org>; Tue, 12 May 2020 09:37:26 -0500 (CDT)
Received: from br540.hostgator.com.br ([108.179.252.180])
        by cmsmtp with SMTP
        id YW29j7AgeVQh0YW2AjC9W9; Tue, 12 May 2020 09:37:26 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=mpdesouza.com; s=default; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=d+OGwaNu9BrvRAhyhAUB5XSO3kOQraQlrJB9jBro6RQ=; b=uU3ZkHruteYkWo+AB0ct0CxLIz
        o/wyJ9GNAv4TeezfzKM2vDHyGQphS7D97Fl2oxcNI7jD/sYljTsYnIR4O+Vi4d1wVkRuU+pg86hlo
        gp+5O4ZOKe+BpXAXc5mEUZauijWyuYAQTEZvmB9k0K3V38P1DiQJ87Qdqy6RpGrq2znNbCTeTx+59
        mStOqY82GvVeN6/6LBpE+xW56+iaAiX7dGJhXVmntfSDlx+fIHJgVJn3R/kPRysjULZ7PYmA7tBEN
        8nwJ/FDC5FAwLpeyWuLYY1e9EMVRF+wG1cbCP1fdSVPt1MDD5PQyV5N5LUs/OzvPpiZpaxuD9U+oo
        SS9dVu9Q==;
Received: from [177.96.46.59] (port=40688 helo=hephaestus.prv.suse.net)
        by br540.hostgator.com.br with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.92)
        (envelope-from <marcos@mpdesouza.com>)
        id 1jYW29-002u1s-1s; Tue, 12 May 2020 11:37:25 -0300
From:   Marcos Paulo de Souza <marcos@mpdesouza.com>
To:     dsterba@suse.com, linux-btrfs@vger.kernel.org, wqu@suse.com,
        fdmanana@suse.com
Cc:     Marcos Paulo de Souza <mpdesouza@suse.com>, stable@vger.kernel.org
Subject: [PATCH v4] btrfs: send: Emit file capabilities after chown
Date:   Tue, 12 May 2020 11:40:38 -0300
Message-Id: <20200512144038.29498-1-marcos@mpdesouza.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - br540.hostgator.com.br
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - mpdesouza.com
X-BWhitelist: no
X-Source-IP: 177.96.46.59
X-Source-L: No
X-Exim-ID: 1jYW29-002u1s-1s
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (hephaestus.prv.suse.net) [177.96.46.59]:40688
X-Source-Auth: marcos@mpdesouza.com
X-Email-Count: 1
X-Source-Cap: bXBkZXNvNTM7bXBkZXNvNTM7YnI1NDAuaG9zdGdhdG9yLmNvbS5icg==
X-Local-Domain: yes
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcos Paulo de Souza <mpdesouza@suse.com>

[PROBLEM]
Whenever a chown is executed, all capabilities of the file being touched are
lost.  When doing incremental send with a file with capabilities, there is a
situation where the capability can be lost in the receiving side. The
sequence of actions bellow shows the problem:

$ mount /dev/sda fs1
$ mount /dev/sdb fs2

$ touch fs1/foo.bar
$ setcap cap_sys_nice+ep fs1/foo.bar
$ btrfs subvol snap -r fs1 fs1/snap_init
$ btrfs send fs1/snap_init | btrfs receive fs2

$ chgrp adm fs1/foo.bar
$ setcap cap_sys_nice+ep fs1/foo.bar

$ btrfs subvol snap -r fs1 fs1/snap_complete
$ btrfs subvol snap -r fs1 fs1/snap_incremental

$ btrfs send fs1/snap_complete | btrfs receive fs2
$ btrfs send -p fs1/snap_init fs1/snap_incremental | btrfs receive fs2

At this point, only a chown was emitted by "btrfs send" since only the group
was changed. This makes the cap_sys_nice capability to be dropped from
fs2/snap_incremental/foo.bar

[FIX]
Only emit capabilities after chown is emitted. The current code
first checks for xattrs that are new/changed, emits them, and later emit
the chown. Now, __process_new_xattr skips capabilities, letting only
finish_inode_if_needed to emit them, if they exist, for the inode being
processed.

This behavior was being worked around in "btrfs receive"
side by caching the capability and only applying it after chown. Now,
xattrs are only emmited _after_ chown, making that hack not needed
anymore.

Link: https://github.com/kdave/btrfs-progs/issues/202
CC: stable@vger.kernel.org
Suggested-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
---
 Changes from v3:
 * Fixed a comment that didn't start with an uppercase (suggested by David)
 * Removed a temporary var and used XATTR_NAME_CAPS directly (suggested by
   David)
 * Removed the (char *) cast before assigning the data_ptr (suggested by David)
 * Use buf_len previously computed instead of calling btrfs_dir_data_len twice
  (suggested by David)

 Changes from v2:
 * Tag Stable correctly
 * Forgot to add v2 in the latest patch. Now set to v3 to avoid confusion

 Changes from v1:
 * Constify name var in send_capabilities function (suggested by Filipe)
 * Changed btrfs_alloc_path -> alloc_path_for_send() in send_capabilities
  (suggested by Filipe)
 * Removed a redundant sentence in the commit message (suggested by Filipe)
 * Added the Reviewed-By tag from Filipe

 Changes from RFC:
 * Explained about chown + drop capabilities problem in the commit message (suggested
   by Filipe and David)
 * Changed the commit message to show describe the fix (suggested by Filipe)
 * Skip the xattr in __process_new_xattr if it's a capability, since it'll be
   handled in finish_inode_if_needed now (suggested by Filipe).
 * Created function send_capabilities to query if the inode has caps, and if
   yes, emit them.
 * Call send_capabilities in finish_inode_if_needed _after_ the needs_chown
   check. (suggested by Filipe)

 fs/btrfs/send.c | 67 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 67 insertions(+)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 6b86841315be..58c777e3dc7a 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -23,6 +23,7 @@
 #include "btrfs_inode.h"
 #include "transaction.h"
 #include "compression.h"
+#include "xattr.h"
 
 /*
  * Maximum number of references an extent can have in order for us to attempt to
@@ -4545,6 +4546,10 @@ static int __process_new_xattr(int num, struct btrfs_key *di_key,
 	struct fs_path *p;
 	struct posix_acl_xattr_header dummy_acl;
 
+	/* Capabilities are emitted by finish_inode_if_needed */
+	if (!strncmp(name, XATTR_NAME_CAPS, name_len))
+		return 0;
+
 	p = fs_path_alloc();
 	if (!p)
 		return -ENOMEM;
@@ -5107,6 +5112,64 @@ static int send_extent_data(struct send_ctx *sctx,
 	return 0;
 }
 
+/*
+ * Search for a capability xattr related to sctx->cur_ino. If the capability if
+ * found, call send_set_xattr function to emit it.
+ *
+ * Return %0 if there isn't a capability, or when the capability was emitted
+ * successfully, or < %0 if an error occurred.
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
+		/* there is no xattr for this inode */
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
@@ -6010,6 +6073,10 @@ static int finish_inode_if_needed(struct send_ctx *sctx, int at_end)
 			goto out;
 	}
 
+	ret = send_capabilities(sctx);
+	if (ret < 0)
+		goto out;
+
 	/*
 	 * If other directory inodes depended on our current directory
 	 * inode's move/rename, now do their move/rename operations.
-- 
2.25.1

