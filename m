Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68A2841A754
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 07:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238846AbhI1F5F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 01:57:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:47430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236810AbhI1F5E (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Sep 2021 01:57:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF2C9611C7;
        Tue, 28 Sep 2021 05:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632808526;
        bh=Okme8nbDieejk7OQKsSrbhKamF5ID3JuzPw1+9C8rfo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f5fgT9E8G2+3gQMBMc7AhXwgxyg+cnQFgbmN3+FkNnQhXgNGvw+Y6aT+42G9i8enN
         oZB7+4uMn3XmtrvQkf0c6fRpTCKcCHXaivUwohW1HhpyFQih4IEFu6EYVYDM8eJG5B
         qMqgvX08OI5tYwxY/zQ/QXGUpK642hK+lkozv+e0wZ9gR5DrHfagCWDyWe3RPsT/yL
         49pNGp7BtODxEAaxbGWrFqGURTxJastCu3+tjxd7sqMmiCrDCj54ibiOzC2ur1Ijc8
         x1TBJPYeRKSl5B0hnwoJbmsRT9iCfq7MWzkf9VDE4uonYX2P8uOvfQJ7DPzuKDtMIa
         Ul5k5gsqXI7+w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Markus Suvanto <markus.suvanto@gmail.com>,
        linux-afs@lists.infradead.org, Sasha Levin <sashal@kernel.org>,
        marc.dionne@auristor.com
Subject: [PATCH AUTOSEL 5.14 02/40] afs: Add missing vnode validation checks
Date:   Tue, 28 Sep 2021 01:54:46 -0400
Message-Id: <20210928055524.172051-2-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210928055524.172051-1-sashal@kernel.org>
References: <20210928055524.172051-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index ac829e63c570..a8e3ae55f1f9 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -1792,6 +1792,10 @@ static int afs_link(struct dentry *from, struct inode *dir,
 		goto error;
 	}
 
+	ret = afs_validate(vnode, op->key);
+	if (ret < 0)
+		goto error_op;
+
 	afs_op_set_vnode(op, 0, dvnode);
 	afs_op_set_vnode(op, 1, vnode);
 	op->file[0].dv_delta = 1;
@@ -1805,6 +1809,8 @@ static int afs_link(struct dentry *from, struct inode *dir,
 	op->create.reason	= afs_edit_dir_for_link;
 	return afs_do_sync_operation(op);
 
+error_op:
+	afs_put_operation(op);
 error:
 	d_drop(dentry);
 	_leave(" = %d", ret);
@@ -1989,6 +1995,11 @@ static int afs_rename(struct user_namespace *mnt_userns, struct inode *old_dir,
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
index c0534697268e..0886dc007970 100644
--- a/fs/afs/write.c
+++ b/fs/afs/write.c
@@ -801,6 +801,7 @@ int afs_writepages(struct address_space *mapping,
 ssize_t afs_file_write(struct kiocb *iocb, struct iov_iter *from)
 {
 	struct afs_vnode *vnode = AFS_FS_I(file_inode(iocb->ki_filp));
+	struct afs_file *af = iocb->ki_filp->private_data;
 	ssize_t result;
 	size_t count = iov_iter_count(from);
 
@@ -816,6 +817,10 @@ ssize_t afs_file_write(struct kiocb *iocb, struct iov_iter *from)
 	if (!count)
 		return 0;
 
+	result = afs_validate(vnode, af->key);
+	if (result < 0)
+		return result;
+
 	result = generic_file_write_iter(iocb, from);
 
 	_leave(" = %zd", result);
@@ -829,13 +834,18 @@ ssize_t afs_file_write(struct kiocb *iocb, struct iov_iter *from)
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
 
@@ -849,11 +859,14 @@ vm_fault_t afs_page_mkwrite(struct vm_fault *vmf)
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

