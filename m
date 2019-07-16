Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF226B25B
	for <lists+stable@lfdr.de>; Wed, 17 Jul 2019 01:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389037AbfGPX2G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jul 2019 19:28:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:49884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728414AbfGPX2G (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jul 2019 19:28:06 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD67F217D9;
        Tue, 16 Jul 2019 23:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563319685;
        bh=A1rFSGSMIJgVPUnqmVGQ0ywdUTXA3T49xutsZqULnp8=;
        h=Date:From:To:Subject:From;
        b=m+cbkSNd8+1YjLvz4tkjZCr/u0jITIo53rCCzBq1VEUPkkc8DflUABblpcMFCIqTa
         OVGetl+WqTJCUeoxfAluUjitm0dYaYXtENLBOOUcpGxHWCOVWX5Ixg7+0XYErkuIum
         2IuviCkEUxYphr6EPtgXALtI07i+xTNhiHnG5Xww=
Date:   Tue, 16 Jul 2019 16:28:04 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, arnd@arndb.de, colin.king@canonical.com,
        dan.carpenter@oracle.com, dhowells@redhat.com, fabf@skynet.be,
        jaharkes@cs.cmu.edu, jiazhouyang09@gmail.com, mikko.rapeli@iki.fi,
        mm-commits@vger.kernel.org, semen.protsenko@linaro.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        ydroneaud@opteya.com
Subject:  [patch 046/100] coda: pass the host file in vma->vm_file
 on mmap
Message-ID: <20190716232804.TmkyrfB2j%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Harkes <jaharkes@cs.cmu.edu>
Subject: coda: pass the host file in vma->vm_file on mmap

Patch series "Coda updates".

The following patch series is a collection of various fixes for Coda, most
of which were collected from linux-fsdevel or linux-kernel but which have
as yet not found their way upstream.


This patch (of 22):

Various file systems expect that vma->vm_file points at their own file
handle, several use file_inode(vma->vm_file) to get at their inode or use
vma->vm_file->private_data.  However the way Coda wrapped mmap on a host
file broke this assumption, vm_file was still pointing at the Coda file
and the host file systems would scribble over Coda's inode and private
file data.

This patch fixes the incorrect expectation and wraps vm_ops->open and
vm_ops->close to allow Coda to track when the vm_area_struct is destroyed
so we still release the reference on the Coda file handle at the right
time.

Link: http://lkml.kernel.org/r/0e850c6e59c0b147dc2dcd51a3af004c948c3697.1558117389.git.jaharkes@cs.cmu.edu
Signed-off-by: Jan Harkes <jaharkes@cs.cmu.edu>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Colin Ian King <colin.king@canonical.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Fabian Frederick <fabf@skynet.be>
Cc: Mikko Rapeli <mikko.rapeli@iki.fi>
Cc: Sam Protsenko <semen.protsenko@linaro.org>
Cc: Yann Droneaud <ydroneaud@opteya.com>
Cc: Zhouyang Jia <jiazhouyang09@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coda/file.c |   70 +++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 68 insertions(+), 2 deletions(-)

--- a/fs/coda/file.c~coda-pass-the-host-file-in-vma-vm_file-on-mmap
+++ a/fs/coda/file.c
@@ -27,6 +27,13 @@
 #include "coda_linux.h"
 #include "coda_int.h"
 
+struct coda_vm_ops {
+	atomic_t refcnt;
+	struct file *coda_file;
+	const struct vm_operations_struct *host_vm_ops;
+	struct vm_operations_struct vm_ops;
+};
+
 static ssize_t
 coda_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 {
@@ -61,6 +68,34 @@ coda_file_write_iter(struct kiocb *iocb,
 	return ret;
 }
 
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
@@ -68,6 +103,8 @@ coda_file_mmap(struct file *coda_file, s
 	struct coda_inode_info *cii;
 	struct file *host_file;
 	struct inode *coda_inode, *host_inode;
+	struct coda_vm_ops *cvm_ops;
+	int ret;
 
 	cfi = CODA_FTOC(coda_file);
 	BUG_ON(!cfi || cfi->cfi_magic != CODA_MAGIC);
@@ -76,6 +113,13 @@ coda_file_mmap(struct file *coda_file, s
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
 
@@ -89,6 +133,7 @@ coda_file_mmap(struct file *coda_file, s
 	 * the container file on us! */
 	else if (coda_inode->i_mapping != host_inode->i_mapping) {
 		spin_unlock(&cii->c_lock);
+		kfree(cvm_ops);
 		return -EBUSY;
 	}
 
@@ -97,7 +142,29 @@ coda_file_mmap(struct file *coda_file, s
 	cfi->cfi_mapcount++;
 	spin_unlock(&cii->c_lock);
 
-	return call_mmap(host_file, vma);
+	vma->vm_file = get_file(host_file);
+	ret = call_mmap(vma->vm_file, vma);
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
@@ -207,4 +274,3 @@ const struct file_operations coda_file_o
 	.fsync		= coda_fsync,
 	.splice_read	= generic_file_splice_read,
 };
-
_
