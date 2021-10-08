Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19964426986
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 13:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240733AbhJHLjN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 07:39:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:59462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241722AbhJHLgH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 07:36:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD2CC6120C;
        Fri,  8 Oct 2021 11:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633692732;
        bh=mZ1IzySuIkz9ncXQhrJHYYLV/1oXdhU8HZhudSY/knQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jfdNI3KDrk+MoXcqbBcf+8LWX+lUIZpIxdlNiskhsUzANzYzr1ge7htVQgI6qHW3k
         e7Njf+3HF7z7NQnTTUymKNB+aOE4OXkXjXCiyqwfeFjtT3cywX7xR89HbuFgHCKuvV
         Cw436pluqWJxA3cflQsRCJU3lS+Cz6ef2oyhmvo8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Markus Suvanto <markus.suvanto@gmail.com>,
        linux-afs@lists.infradead.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 02/48] afs: Add missing vnode validation checks
Date:   Fri,  8 Oct 2021 13:27:38 +0200
Message-Id: <20211008112720.094892148@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211008112720.008415452@linuxfoundation.org>
References: <20211008112720.008415452@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 3978d816523991dd86cf9aae88c295230a5ea3b2 ]

afs_d_revalidate() should only be validating the directory entry it is
given and the directory to which that belongs; it shouldn't be validating
the inode/vnode to which that dentry points.  Besides, validation need to
be done even if we don't call afs_d_revalidate() - which might be the case
if we're starting from a file descriptor.

In order for afs_d_revalidate() to be fixed, validation points must be
added in some other places.  Certain directory operations, such as
afs_unlink(), already check this, but not all and not all file operations
either.

Note that the validation of a vnode not only checks to see if the
attributes we have are correct, but also gets a promise from the server to
notify us if that file gets changed by a third party.

Add the following checks:

 - Check the vnode we're going to make a hard link to.
 - Check the vnode we're going to move/rename.
 - Check the vnode we're going to read from.
 - Check the vnode we're going to write to.
 - Check the vnode we're going to sync.
 - Check the vnode we're going to make a mapped page writable for.

Some of these aren't strictly necessary as we're going to perform a server
operation that might get the attributes anyway from which we can determine
if something changed - though it might not get us a callback promise.

Signed-off-by: David Howells <dhowells@redhat.com>
Tested-by: Markus Suvanto <markus.suvanto@gmail.com>
cc: linux-afs@lists.infradead.org
Link: https://lore.kernel.org/r/163111667354.283156.12720698333342917516.stgit@warthog.procyon.org.uk/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/dir.c   | 11 +++++++++++
 fs/afs/file.c  | 16 +++++++++++++++-
 fs/afs/write.c | 17 +++++++++++++++--
 3 files changed, 41 insertions(+), 3 deletions(-)

diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index 54ee54ae36bc..4579bbda4634 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -1760,6 +1760,10 @@ static int afs_link(struct dentry *from, struct inode *dir,
 		goto error;
 	}
 
+	ret = afs_validate(vnode, op->key);
+	if (ret < 0)
+		goto error_op;
+
 	afs_op_set_vnode(op, 0, dvnode);
 	afs_op_set_vnode(op, 1, vnode);
 	op->file[0].dv_delta = 1;
@@ -1773,6 +1777,8 @@ static int afs_link(struct dentry *from, struct inode *dir,
 	op->create.reason	= afs_edit_dir_for_link;
 	return afs_do_sync_operation(op);
 
+error_op:
+	afs_put_operation(op);
 error:
 	d_drop(dentry);
 	_leave(" = %d", ret);
@@ -1957,6 +1963,11 @@ static int afs_rename(struct user_namespace *mnt_userns, struct inode *old_dir,
 	if (IS_ERR(op))
 		return PTR_ERR(op);
 
+	ret = afs_validate(vnode, op->key);
+	op->error = ret;
+	if (ret < 0)
+		goto error;
+
 	afs_op_set_vnode(op, 0, orig_dvnode);
 	afs_op_set_vnode(op, 1, new_dvnode); /* May be same as orig_dvnode */
 	op->file[0].dv_delta = 1;
diff --git a/fs/afs/file.c b/fs/afs/file.c
index db035ae2a134..5efa1cf2a20a 100644
--- a/fs/afs/file.c
+++ b/fs/afs/file.c
@@ -24,12 +24,13 @@ static void afs_invalidatepage(struct page *page, unsigned int offset,
 static int afs_releasepage(struct page *page, gfp_t gfp_flags);
 
 static void afs_readahead(struct readahead_control *ractl);
+static ssize_t afs_file_read_iter(struct kiocb *iocb, struct iov_iter *iter);
 
 const struct file_operations afs_file_operations = {
 	.open		= afs_open,
 	.release	= afs_release,
 	.llseek		= generic_file_llseek,
-	.read_iter	= generic_file_read_iter,
+	.read_iter	= afs_file_read_iter,
 	.write_iter	= afs_file_write,
 	.mmap		= afs_file_mmap,
 	.splice_read	= generic_file_splice_read,
@@ -502,3 +503,16 @@ static int afs_file_mmap(struct file *file, struct vm_area_struct *vma)
 		vma->vm_ops = &afs_vm_ops;
 	return ret;
 }
+
+static ssize_t afs_file_read_iter(struct kiocb *iocb, struct iov_iter *iter)
+{
+	struct afs_vnode *vnode = AFS_FS_I(file_inode(iocb->ki_filp));
+	struct afs_file *af = iocb->ki_filp->private_data;
+	int ret;
+
+	ret = afs_validate(vnode, af->key);
+	if (ret < 0)
+		return ret;
+
+	return generic_file_read_iter(iocb, iter);
+}
diff --git a/fs/afs/write.c b/fs/afs/write.c
index e86f5a245514..2dfe3b3a53d6 100644
--- a/fs/afs/write.c
+++ b/fs/afs/write.c
@@ -807,6 +807,7 @@ int afs_writepages(struct address_space *mapping,
 ssize_t afs_file_write(struct kiocb *iocb, struct iov_iter *from)
 {
 	struct afs_vnode *vnode = AFS_FS_I(file_inode(iocb->ki_filp));
+	struct afs_file *af = iocb->ki_filp->private_data;
 	ssize_t result;
 	size_t count = iov_iter_count(from);
 
@@ -822,6 +823,10 @@ ssize_t afs_file_write(struct kiocb *iocb, struct iov_iter *from)
 	if (!count)
 		return 0;
 
+	result = afs_validate(vnode, af->key);
+	if (result < 0)
+		return result;
+
 	result = generic_file_write_iter(iocb, from);
 
 	_leave(" = %zd", result);
@@ -835,13 +840,18 @@ ssize_t afs_file_write(struct kiocb *iocb, struct iov_iter *from)
  */
 int afs_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 {
-	struct inode *inode = file_inode(file);
-	struct afs_vnode *vnode = AFS_FS_I(inode);
+	struct afs_vnode *vnode = AFS_FS_I(file_inode(file));
+	struct afs_file *af = file->private_data;
+	int ret;
 
 	_enter("{%llx:%llu},{n=%pD},%d",
 	       vnode->fid.vid, vnode->fid.vnode, file,
 	       datasync);
 
+	ret = afs_validate(vnode, af->key);
+	if (ret < 0)
+		return ret;
+
 	return file_write_and_wait_range(file, start, end);
 }
 
@@ -855,11 +865,14 @@ vm_fault_t afs_page_mkwrite(struct vm_fault *vmf)
 	struct file *file = vmf->vma->vm_file;
 	struct inode *inode = file_inode(file);
 	struct afs_vnode *vnode = AFS_FS_I(inode);
+	struct afs_file *af = file->private_data;
 	unsigned long priv;
 	vm_fault_t ret = VM_FAULT_RETRY;
 
 	_enter("{{%llx:%llu}},{%lx}", vnode->fid.vid, vnode->fid.vnode, page->index);
 
+	afs_validate(vnode, af->key);
+
 	sb_start_pagefault(inode->i_sb);
 
 	/* Wait for the page to be written to the cache before we allow it to
-- 
2.33.0



