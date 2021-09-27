Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70137419AC6
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236597AbhI0RMQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:12:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:47912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236603AbhI0RKN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:10:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2E4F61222;
        Mon, 27 Sep 2021 17:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762467;
        bh=tB+TSLVCyg2lo4gJi80zk2pIoN619vd5g6K3Qfp2PCA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x53OFlCgZRmYZHGjKnk12/qMKOWT794IeXikbAz93vDSt4coW0EkA1O7GrBGTqRCj
         7j4rmSilkeqa7RJrwAZExl1RWc9Fns4wgGJDYx+gzHt5b8Kx0FzPXYpmju0jOGnCdI
         FUZCTCSjEoncjwyUP1l13DaLPa57fcFyBdXMyb+8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Markus Suvanto <markus.suvanto@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 034/103] afs: Fix updating of i_blocks on file/dir extension
Date:   Mon, 27 Sep 2021 19:02:06 +0200
Message-Id: <20210927170226.924474536@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170225.702078779@linuxfoundation.org>
References: <20210927170225.702078779@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 9d37e1cab2a9d2cee2737973fa455e6f89eee46a ]

When an afs file or directory is modified locally such that the total file
size is extended, i_blocks needs to be recalculated too.

Fix this by making afs_write_end() and afs_edit_dir_add() call
afs_set_i_size() rather than setting inode->i_size directly as that also
recalculates inode->i_blocks.

This can be tested by creating and writing into directories and files and
then examining them with du.  Without this change, directories show a 4
blocks (they start out at 2048 bytes) and files show 0 blocks; with this
change, they should show a number of blocks proportional to the file size
rounded up to 1024.

Fixes: 31143d5d515e ("AFS: implement basic file write support")
Fixes: 63a4681ff39c ("afs: Locally edit directory data for mkdir/create/unlink/...")
Reported-by: Markus Suvanto <markus.suvanto@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Marc Dionne <marc.dionne@auristor.com>
Tested-by: Markus Suvanto <markus.suvanto@gmail.com>
cc: linux-afs@lists.infradead.org
Link: https://lore.kernel.org/r/163113612442.352844.11162345591911691150.stgit@warthog.procyon.org.uk/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/dir_edit.c |  4 ++--
 fs/afs/inode.c    | 10 ----------
 fs/afs/internal.h | 10 ++++++++++
 fs/afs/write.c    |  2 +-
 4 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/afs/dir_edit.c b/fs/afs/dir_edit.c
index 2ffe09abae7f..3a9cffc081b9 100644
--- a/fs/afs/dir_edit.c
+++ b/fs/afs/dir_edit.c
@@ -264,7 +264,7 @@ void afs_edit_dir_add(struct afs_vnode *vnode,
 		if (b == nr_blocks) {
 			_debug("init %u", b);
 			afs_edit_init_block(meta, block, b);
-			i_size_write(&vnode->vfs_inode, (b + 1) * AFS_DIR_BLOCK_SIZE);
+			afs_set_i_size(vnode, (b + 1) * AFS_DIR_BLOCK_SIZE);
 		}
 
 		/* Only lower dir pages have a counter in the header. */
@@ -297,7 +297,7 @@ void afs_edit_dir_add(struct afs_vnode *vnode,
 new_directory:
 	afs_edit_init_block(meta, meta, 0);
 	i_size = AFS_DIR_BLOCK_SIZE;
-	i_size_write(&vnode->vfs_inode, i_size);
+	afs_set_i_size(vnode, i_size);
 	slot = AFS_DIR_RESV_BLOCKS0;
 	page = page0;
 	block = meta;
diff --git a/fs/afs/inode.c b/fs/afs/inode.c
index ae3016a9fb23..f81a972bdd29 100644
--- a/fs/afs/inode.c
+++ b/fs/afs/inode.c
@@ -53,16 +53,6 @@ static noinline void dump_vnode(struct afs_vnode *vnode, struct afs_vnode *paren
 		dump_stack();
 }
 
-/*
- * Set the file size and block count.  Estimate the number of 512 bytes blocks
- * used, rounded up to nearest 1K for consistency with other AFS clients.
- */
-static void afs_set_i_size(struct afs_vnode *vnode, u64 size)
-{
-	i_size_write(&vnode->vfs_inode, size);
-	vnode->vfs_inode.i_blocks = ((size + 1023) >> 10) << 1;
-}
-
 /*
  * Initialise an inode from the vnode status.
  */
diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index ffe318ad2e02..dc08a3d9b3a8 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -1573,6 +1573,16 @@ static inline void afs_update_dentry_version(struct afs_operation *op,
 			(void *)(unsigned long)dir_vp->scb.status.data_version;
 }
 
+/*
+ * Set the file size and block count.  Estimate the number of 512 bytes blocks
+ * used, rounded up to nearest 1K for consistency with other AFS clients.
+ */
+static inline void afs_set_i_size(struct afs_vnode *vnode, u64 size)
+{
+	i_size_write(&vnode->vfs_inode, size);
+	vnode->vfs_inode.i_blocks = ((size + 1023) >> 10) << 1;
+}
+
 /*
  * Check for a conflicting operation on a directory that we just unlinked from.
  * If someone managed to sneak a link or an unlink in on the file we just
diff --git a/fs/afs/write.c b/fs/afs/write.c
index d37b5cfcf28f..be60cf110382 100644
--- a/fs/afs/write.c
+++ b/fs/afs/write.c
@@ -184,7 +184,7 @@ int afs_write_end(struct file *file, struct address_space *mapping,
 		write_seqlock(&vnode->cb_lock);
 		i_size = i_size_read(&vnode->vfs_inode);
 		if (maybe_i_size > i_size)
-			i_size_write(&vnode->vfs_inode, maybe_i_size);
+			afs_set_i_size(vnode, maybe_i_size);
 		write_sequnlock(&vnode->cb_lock);
 	}
 
-- 
2.33.0



