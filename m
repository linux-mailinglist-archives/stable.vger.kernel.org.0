Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAA64220D1
	for <lists+stable@lfdr.de>; Sat, 18 May 2019 01:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727899AbfEQXyI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 19:54:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:46844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726200AbfEQXyI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 May 2019 19:54:08 -0400
Received: from akpm3.svl.corp.google.com (unknown [104.133.8.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 457B0206B6;
        Fri, 17 May 2019 23:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558137246;
        bh=46EgAaHhIwBPceogvBKatKYkl6bUD8JJOfvPB7ODAAk=;
        h=Date:From:To:Subject:From;
        b=KfOoSTXvBsovP3RO24/iuq770yWQIfLPMOWFo2KPF8dRyQhw5KDIOpFP7trS21+b+
         VbzpIallmQk7qY9dqXTUu0smHv55AbCzg1msTLXXnb9pV2T9tleFT9kiFYePoY4+Lo
         1g1p6VBe7IMlqn5UYFLHv3AqAToFzT03l2rbbt6Y=
Date:   Fri, 17 May 2019 16:54:05 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ydroneaud@opteya.com,
        stable@vger.kernel.org, semen.protsenko@linaro.org,
        mikko.rapeli@iki.fi, jiazhouyang09@gmail.com, fabf@skynet.be,
        dhowells@redhat.com, dan.carpenter@oracle.com,
        colin.king@canonical.com, arnd@arndb.de, jaharkes@cs.cmu.edu
Subject:  + coda-pass-the-host-file-in-vma-vm_file-on-mmap.patch
 added to -mm tree
Message-ID: <20190517235405.-ixPh%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: coda: pass the host file in vma->vm_file on mmap
has been added to the -mm tree.  Its filename is
     coda-pass-the-host-file-in-vma-vm_file-on-mmap.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/coda-pass-the-host-file-in-vma-vm_file-on-mmap.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/coda-pass-the-host-file-in-vma-vm_file-on-mmap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from jaharkes@cs.cmu.edu are

coda-pass-the-host-file-in-vma-vm_file-on-mmap.patch
coda-potential-buffer-overflow-in-coda_psdev_write.patch
coda-dont-try-to-print-names-that-were-considered-too-long.patch
uapi-linux-coda_psdevh-move-coda_req_-from-uapi-to-kernel-side-headers.patch
coda-change-codas-user-api-to-use-64-bit-time_t-in-timespec.patch
coda-bump-module-version.patch
coda-remove-uapi-linux-coda_psdevh.patch

