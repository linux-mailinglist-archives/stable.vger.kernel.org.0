Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E67AD37C68B
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233422AbhELPwC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:52:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:50380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237026AbhELPrw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:47:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B32C619B1;
        Wed, 12 May 2021 15:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833068;
        bh=kzRxTDRP5HaOG8JkM+meVdg+XFrZG7I6wvzZ0UN3/To=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tn4ShPbYRYy5hbtQJSj4lrRlclVUi43O9L4IQQb4lXClXLCxd6GPDpqGPzpWV1Mb/
         kMNalSJOMKDZDi3P6cuizmWD8Pxl0W4gpPJUyLAaj8qwQZCmETsluQDZ4XFYkEyLe4
         lyaeyFMTE7oLznrnzW1dc8ddzvwbwQP+19q+NvcU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Dionne <marc.dionne@auristor.com>,
        David Howells <dhowells@redhat.com>,
        linux-afs@lists.infradead.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 522/530] afs: Fix speculative status fetches
Date:   Wed, 12 May 2021 16:50:32 +0200
Message-Id: <20210512144836.906247345@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 22650f148126571be1098d34160eb4931fc77241 ]

The generic/464 xfstest causes kAFS to emit occasional warnings of the
form:

        kAFS: vnode modified {100055:8a} 30->31 YFS.StoreData64 (c=6015)

This indicates that the data version received back from the server did not
match the expected value (the DV should be incremented monotonically for
each individual modification op committed to a vnode).

What is happening is that a lookup call is doing a bulk status fetch
speculatively on a bunch of vnodes in a directory besides getting the
status of the vnode it's actually interested in.  This is racing with a
StoreData operation (though it could also occur with, say, a MakeDir op).

On the client, a modification operation locks the vnode, but the bulk
status fetch only locks the parent directory, so no ordering is imposed
there (thereby avoiding an avenue to deadlock).

On the server, the StoreData op handler doesn't lock the vnode until it's
received all the request data, and downgrades the lock after committing the
data until it has finished sending change notifications to other clients -
which allows the status fetch to occur before it has finished.

This means that:

 - a status fetch can access the target vnode either side of the exclusive
   section of the modification

 - the status fetch could start before the modification, yet finish after,
   and vice-versa.

 - the status fetch and the modification RPCs can complete in either order.

 - the status fetch can return either the before or the after DV from the
   modification.

 - the status fetch might regress the locally cached DV.

Some of these are handled by the previous fix[1], but that's not sufficient
because it checks the DV it received against the DV it cached at the start
of the op, but the DV might've been updated in the meantime by a locally
generated modification op.

Fix this by the following means:

 (1) Keep track of when we're performing a modification operation on a
     vnode.  This is done by marking vnode parameters with a 'modification'
     note that causes the AFS_VNODE_MODIFYING flag to be set on the vnode
     for the duration.

 (2) Alter the speculation race detection to ignore speculative status
     fetches if either the vnode is marked as being modified or the data
     version number is not what we expected.

Note that whilst the "vnode modified" warning does get recovered from as it
causes the client to refetch the status at the next opportunity, it will
also invalidate the pagecache, so changes might get lost.

Fixes: a9e5c87ca744 ("afs: Fix speculative status fetch going out of order wrt to modifications")
Reported-by: Marc Dionne <marc.dionne@auristor.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Tested-and-reviewed-by: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Link: https://lore.kernel.org/r/160605082531.252452.14708077925602709042.stgit@warthog.procyon.org.uk/ [1]
Link: https://lore.kernel.org/linux-fsdevel/161961335926.39335.2552653972195467566.stgit@warthog.procyon.org.uk/ # v1
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/dir.c          | 7 +++++++
 fs/afs/dir_silly.c    | 3 +++
 fs/afs/fs_operation.c | 6 ++++++
 fs/afs/inode.c        | 6 ++++--
 fs/afs/internal.h     | 2 ++
 fs/afs/write.c        | 1 +
 6 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index 9dc6f4b1c417..628ba3fed36d 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -1337,6 +1337,7 @@ static int afs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 
 	afs_op_set_vnode(op, 0, dvnode);
 	op->file[0].dv_delta = 1;
+	op->file[0].modification = true;
 	op->file[0].update_ctime = true;
 	op->dentry	= dentry;
 	op->create.mode	= S_IFDIR | mode;
@@ -1418,6 +1419,7 @@ static int afs_rmdir(struct inode *dir, struct dentry *dentry)
 
 	afs_op_set_vnode(op, 0, dvnode);
 	op->file[0].dv_delta = 1;
+	op->file[0].modification = true;
 	op->file[0].update_ctime = true;
 
 	op->dentry	= dentry;
@@ -1554,6 +1556,7 @@ static int afs_unlink(struct inode *dir, struct dentry *dentry)
 
 	afs_op_set_vnode(op, 0, dvnode);
 	op->file[0].dv_delta = 1;
+	op->file[0].modification = true;
 	op->file[0].update_ctime = true;
 
 	/* Try to make sure we have a callback promise on the victim. */
@@ -1636,6 +1639,7 @@ static int afs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
 
 	afs_op_set_vnode(op, 0, dvnode);
 	op->file[0].dv_delta = 1;
+	op->file[0].modification = true;
 	op->file[0].update_ctime = true;
 
 	op->dentry	= dentry;
@@ -1710,6 +1714,7 @@ static int afs_link(struct dentry *from, struct inode *dir,
 	afs_op_set_vnode(op, 0, dvnode);
 	afs_op_set_vnode(op, 1, vnode);
 	op->file[0].dv_delta = 1;
+	op->file[0].modification = true;
 	op->file[0].update_ctime = true;
 	op->file[1].update_ctime = true;
 
@@ -1905,6 +1910,8 @@ static int afs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	afs_op_set_vnode(op, 1, new_dvnode); /* May be same as orig_dvnode */
 	op->file[0].dv_delta = 1;
 	op->file[1].dv_delta = 1;
+	op->file[0].modification = true;
+	op->file[1].modification = true;
 	op->file[0].update_ctime = true;
 	op->file[1].update_ctime = true;
 
diff --git a/fs/afs/dir_silly.c b/fs/afs/dir_silly.c
index 04f75a44f243..dae9a57d7ec0 100644
--- a/fs/afs/dir_silly.c
+++ b/fs/afs/dir_silly.c
@@ -73,6 +73,8 @@ static int afs_do_silly_rename(struct afs_vnode *dvnode, struct afs_vnode *vnode
 	afs_op_set_vnode(op, 1, dvnode);
 	op->file[0].dv_delta = 1;
 	op->file[1].dv_delta = 1;
+	op->file[0].modification = true;
+	op->file[1].modification = true;
 	op->file[0].update_ctime = true;
 	op->file[1].update_ctime = true;
 
@@ -201,6 +203,7 @@ static int afs_do_silly_unlink(struct afs_vnode *dvnode, struct afs_vnode *vnode
 	afs_op_set_vnode(op, 0, dvnode);
 	afs_op_set_vnode(op, 1, vnode);
 	op->file[0].dv_delta = 1;
+	op->file[0].modification = true;
 	op->file[0].update_ctime = true;
 	op->file[1].op_unlinked = true;
 	op->file[1].update_ctime = true;
diff --git a/fs/afs/fs_operation.c b/fs/afs/fs_operation.c
index 71c58723763d..a82515b47350 100644
--- a/fs/afs/fs_operation.c
+++ b/fs/afs/fs_operation.c
@@ -118,6 +118,8 @@ static void afs_prepare_vnode(struct afs_operation *op, struct afs_vnode_param *
 		vp->cb_break_before	= afs_calc_vnode_cb_break(vnode);
 		if (vnode->lock_state != AFS_VNODE_LOCK_NONE)
 			op->flags	|= AFS_OPERATION_CUR_ONLY;
+		if (vp->modification)
+			set_bit(AFS_VNODE_MODIFYING, &vnode->flags);
 	}
 
 	if (vp->fid.vnode)
@@ -223,6 +225,10 @@ int afs_put_operation(struct afs_operation *op)
 
 	if (op->ops && op->ops->put)
 		op->ops->put(op);
+	if (op->file[0].modification)
+		clear_bit(AFS_VNODE_MODIFYING, &op->file[0].vnode->flags);
+	if (op->file[1].modification && op->file[1].vnode != op->file[0].vnode)
+		clear_bit(AFS_VNODE_MODIFYING, &op->file[1].vnode->flags);
 	if (op->file[0].put_vnode)
 		iput(&op->file[0].vnode->vfs_inode);
 	if (op->file[1].put_vnode)
diff --git a/fs/afs/inode.c b/fs/afs/inode.c
index bf44e245d7dc..ae3016a9fb23 100644
--- a/fs/afs/inode.c
+++ b/fs/afs/inode.c
@@ -293,8 +293,9 @@ void afs_vnode_commit_status(struct afs_operation *op, struct afs_vnode_param *v
 			op->flags &= ~AFS_OPERATION_DIR_CONFLICT;
 		}
 	} else if (vp->scb.have_status) {
-		if (vp->dv_before + vp->dv_delta != vp->scb.status.data_version &&
-		    vp->speculative)
+		if (vp->speculative &&
+		    (test_bit(AFS_VNODE_MODIFYING, &vnode->flags) ||
+		     vp->dv_before != vnode->status.data_version))
 			/* Ignore the result of a speculative bulk status fetch
 			 * if it splits around a modification op, thereby
 			 * appearing to regress the data version.
@@ -909,6 +910,7 @@ int afs_setattr(struct dentry *dentry, struct iattr *attr)
 	}
 	op->ctime = attr->ia_ctime;
 	op->file[0].update_ctime = 1;
+	op->file[0].modification = true;
 
 	op->ops = &afs_setattr_operation;
 	ret = afs_do_sync_operation(op);
diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index 525ef075fcd9..ffe318ad2e02 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -640,6 +640,7 @@ struct afs_vnode {
 #define AFS_VNODE_PSEUDODIR	7 		/* set if Vnode is a pseudo directory */
 #define AFS_VNODE_NEW_CONTENT	8		/* Set if file has new content (create/trunc-0) */
 #define AFS_VNODE_SILLY_DELETED	9		/* Set if file has been silly-deleted */
+#define AFS_VNODE_MODIFYING	10		/* Set if we're performing a modification op */
 
 	struct list_head	wb_keys;	/* List of keys available for writeback */
 	struct list_head	pending_locks;	/* locks waiting to be granted */
@@ -756,6 +757,7 @@ struct afs_vnode_param {
 	bool			set_size:1;	/* Must update i_size */
 	bool			op_unlinked:1;	/* True if file was unlinked by op */
 	bool			speculative:1;	/* T if speculative status fetch (no vnode lock) */
+	bool			modification:1;	/* Set if the content gets modified */
 };
 
 /*
diff --git a/fs/afs/write.c b/fs/afs/write.c
index c9195fc67fd8..d37b5cfcf28f 100644
--- a/fs/afs/write.c
+++ b/fs/afs/write.c
@@ -450,6 +450,7 @@ static int afs_store_data(struct address_space *mapping,
 	afs_op_set_vnode(op, 0, vnode);
 	op->file[0].dv_delta = 1;
 	op->store.mapping = mapping;
+	op->file[0].modification = true;
 	op->store.first = first;
 	op->store.last = last;
 	op->store.first_offset = offset;
-- 
2.30.2



