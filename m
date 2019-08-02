Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 026777F2CA
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390199AbfHBJvT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:51:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:48294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405293AbfHBJot (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:44:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78B3B206A2;
        Fri,  2 Aug 2019 09:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739088;
        bh=PioM6E1DLBvXX0KAILLLE8843voALZ6piJ4Mw3YYv8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uLFIhCqrJPQ8MXGFv9z/PPWHe3uhZQqN39utvccb1qi7hmS0G3pWmdyDME4IW9iIY
         4XVkswfB1Pfwrh4AGa3aVRkDkbRpewt4KuQtGre5Lz2LaP77U49F6AAcEmMl18qUZf
         6A0mM0aIsryqoyyerVxN76YQCVs30f8iqCW00s3A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Harkes <jaharkes@cs.cmu.edu>,
        Arnd Bergmann <arnd@arndb.de>,
        Colin Ian King <colin.king@canonical.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        David Howells <dhowells@redhat.com>,
        Fabian Frederick <fabf@skynet.be>,
        Mikko Rapeli <mikko.rapeli@iki.fi>,
        Sam Protsenko <semen.protsenko@linaro.org>,
        Yann Droneaud <ydroneaud@opteya.com>,
        Zhouyang Jia <jiazhouyang09@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.9 108/223] coda: pass the host file in vma->vm_file on mmap
Date:   Fri,  2 Aug 2019 11:35:33 +0200
Message-Id: <20190802092246.248764414@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092238.692035242@linuxfoundation.org>
References: <20190802092238.692035242@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Harkes <jaharkes@cs.cmu.edu>

commit 7fa0a1da3dadfd9216df7745a1331fdaa0940d1c upstream.

Patch series "Coda updates".

The following patch series is a collection of various fixes for Coda,
most of which were collected from linux-fsdevel or linux-kernel but
which have as yet not found their way upstream.

This patch (of 22):

Various file systems expect that vma->vm_file points at their own file
handle, several use file_inode(vma->vm_file) to get at their inode or
use vma->vm_file->private_data.  However the way Coda wrapped mmap on a
host file broke this assumption, vm_file was still pointing at the Coda
file and the host file systems would scribble over Coda's inode and
private file data.

This patch fixes the incorrect expectation and wraps vm_ops->open and
vm_ops->close to allow Coda to track when the vm_area_struct is
destroyed so we still release the reference on the Coda file handle at
the right time.

[This patch differs from the original upstream patch because older stable
 kernels do not have the call_mmap vfs helper so we call f_ops->mmap
 directly.]

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jan Harkes <jaharkes@cs.cmu.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/coda/file.c |   69 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 68 insertions(+), 1 deletion(-)

--- a/fs/coda/file.c
+++ b/fs/coda/file.c
@@ -60,6 +60,41 @@ coda_file_write_iter(struct kiocb *iocb,
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
@@ -67,6 +102,8 @@ coda_file_mmap(struct file *coda_file, s
 	struct coda_inode_info *cii;
 	struct file *host_file;
 	struct inode *coda_inode, *host_inode;
+	struct coda_vm_ops *cvm_ops;
+	int ret;
 
 	cfi = CODA_FTOC(coda_file);
 	BUG_ON(!cfi || cfi->cfi_magic != CODA_MAGIC);
@@ -75,6 +112,13 @@ coda_file_mmap(struct file *coda_file, s
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
 
@@ -88,6 +132,7 @@ coda_file_mmap(struct file *coda_file, s
 	 * the container file on us! */
 	else if (coda_inode->i_mapping != host_inode->i_mapping) {
 		spin_unlock(&cii->c_lock);
+		kfree(cvm_ops);
 		return -EBUSY;
 	}
 
@@ -96,7 +141,29 @@ coda_file_mmap(struct file *coda_file, s
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


