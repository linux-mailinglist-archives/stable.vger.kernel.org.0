Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 855FE72096
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 22:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730895AbfGWURL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 16:17:11 -0400
Received: from hurricane.elijah.cs.cmu.edu ([128.2.209.191]:47538 "EHLO
        hurricane.elijah.cs.cmu.edu" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728985AbfGWURL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 16:17:11 -0400
Received: from jaharkes by hurricane.elijah.cs.cmu.edu with local (Exim 4.92)
        (envelope-from <jaharkes@hurricane.elijah.cs.cmu.edu>)
        id 1hq1Di-00057x-Jq; Tue, 23 Jul 2019 16:17:10 -0400
From:   Jan Harkes <jaharkes@cs.cmu.edu>
To:     stable@vger.kernel.org
Cc:     Jan Harkes <jaharkes@cs.cmu.edu>
Subject: [PATCH] coda: pass the host file in vma->vm_file on mmap
Date:   Tue, 23 Jul 2019 16:17:01 -0400
Message-Id: <20190723201701.19236-1-jaharkes@cs.cmu.edu>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 7fa0a1da3dadfd9216df7745a1331fdaa0940d1c upstream.

Various file systems expect that vma->vm_file points at their own file
handle, several use file_inode(vma->vm_file) to get at their inode or
use vma->vm_file->private_data. However the way Coda wrapped mmap on a
host file broke this assumption, vm_file was still pointing at the Coda
file and the host file systems would scribble over Coda's inode and
private file data.

This patch fixes the incorrect expectation and wraps vm_ops->open and
vm_ops->close to allow Coda to track when the vm_area_struct is
destroyed so we still release the reference on the Coda file handle at
the right time.

This patch differs from the original upstream patch because older stable
kernels do not have the call_mmap vfs helper so we call f_ops->mmap
directly.

Cc: stable@vger.kernel.org # 4.9.x
Cc: stable@vger.kernel.org # 4.4.x
Cc: stable@vger.kernel.org # 3.16.x
Signed-off-by: Jan Harkes <jaharkes@cs.cmu.edu>
---
 fs/coda/file.c | 69 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 68 insertions(+), 1 deletion(-)

diff --git a/fs/coda/file.c b/fs/coda/file.c
index 9e83b7790212..933dcddcb024 100644
--- a/fs/coda/file.c
+++ b/fs/coda/file.c
@@ -93,6 +93,41 @@ coda_file_write(struct file *coda_file, const char __user *buf, size_t count, lo
 	return ret;
 }
 
+struct coda_vm_ops {
+	atomic_t refcnt;
+	struct file *coda_file;
+	const struct vm_operations_struct *host_vm_ops;
+	struct vm_operations_struct vm_ops;
+};
+
+static void
+coda_vm_open(struct vm_area_struct *vma)
+{
+	struct coda_vm_ops *cvm_ops =
+		container_of(vma->vm_ops, struct coda_vm_ops, vm_ops);
+
+	atomic_inc(&cvm_ops->refcnt);
+
+	if (cvm_ops->host_vm_ops && cvm_ops->host_vm_ops->open)
+		cvm_ops->host_vm_ops->open(vma);
+}
+
+static void
+coda_vm_close(struct vm_area_struct *vma)
+{
+	struct coda_vm_ops *cvm_ops =
+		container_of(vma->vm_ops, struct coda_vm_ops, vm_ops);
+
+	if (cvm_ops->host_vm_ops && cvm_ops->host_vm_ops->close)
+		cvm_ops->host_vm_ops->close(vma);
+
+	if (atomic_dec_and_test(&cvm_ops->refcnt)) {
+		vma->vm_ops = cvm_ops->host_vm_ops;
+		fput(cvm_ops->coda_file);
+		kfree(cvm_ops);
+	}
+}
+
 static int
 coda_file_mmap(struct file *coda_file, struct vm_area_struct *vma)
 {
@@ -100,6 +135,8 @@ coda_file_mmap(struct file *coda_file, struct vm_area_struct *vma)
 	struct coda_inode_info *cii;
 	struct file *host_file;
 	struct inode *coda_inode, *host_inode;
+	struct coda_vm_ops *cvm_ops;
+	int ret;
 
 	cfi = CODA_FTOC(coda_file);
 	BUG_ON(!cfi || cfi->cfi_magic != CODA_MAGIC);
@@ -108,6 +145,13 @@ coda_file_mmap(struct file *coda_file, struct vm_area_struct *vma)
 	if (!host_file->f_op->mmap)
 		return -ENODEV;
 
+	if (WARN_ON(coda_file != vma->vm_file))
+		return -EIO;
+
+	cvm_ops = kmalloc(sizeof(struct coda_vm_ops), GFP_KERNEL);
+	if (!cvm_ops)
+		return -ENOMEM;
+
 	coda_inode = file_inode(coda_file);
 	host_inode = file_inode(host_file);
 
@@ -121,6 +165,7 @@ coda_file_mmap(struct file *coda_file, struct vm_area_struct *vma)
 	 * the container file on us! */
 	else if (coda_inode->i_mapping != host_inode->i_mapping) {
 		spin_unlock(&cii->c_lock);
+		kfree(cvm_ops);
 		return -EBUSY;
 	}
 
@@ -129,7 +174,29 @@ coda_file_mmap(struct file *coda_file, struct vm_area_struct *vma)
 	cfi->cfi_mapcount++;
 	spin_unlock(&cii->c_lock);
 
-	return host_file->f_op->mmap(host_file, vma);
+	vma->vm_file = get_file(host_file);
+	ret = host_file->f_op->mmap(host_file, vma);
+
+	if (ret) {
+		/* if call_mmap fails, our caller will put coda_file so we
+		 * should drop the reference to the host_file that we got.
+		 */
+		fput(host_file);
+		kfree(cvm_ops);
+	} else {
+		/* here we add redirects for the open/close vm_operations */
+		cvm_ops->host_vm_ops = vma->vm_ops;
+		if (vma->vm_ops)
+			cvm_ops->vm_ops = *vma->vm_ops;
+
+		cvm_ops->vm_ops.open = coda_vm_open;
+		cvm_ops->vm_ops.close = coda_vm_close;
+		cvm_ops->coda_file = coda_file;
+		atomic_set(&cvm_ops->refcnt, 1);
+
+		vma->vm_ops = &cvm_ops->vm_ops;
+	}
+	return ret;
 }
 
 int coda_open(struct inode *coda_inode, struct file *coda_file)
-- 
2.20.1

