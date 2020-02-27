Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7F8917214F
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:49:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729554AbgB0Nnr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:43:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:39044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729696AbgB0Nno (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:43:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D4DE20726;
        Thu, 27 Feb 2020 13:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811024;
        bh=D2UNR+MPHKFDoSdnx/q3n2QdWmDMWLZ48WZzdXaaRSo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1jiUjjOtXFxFr22DjPCOUPa43s0RHMCzhzxxkhRzh4ciwR1K5qkkKbkVLOMEJZZyW
         ZKJvgDfC+uCxyAXb8OAukY70RZe9xv54iDS8YvHTs+BD2Kw4+Djt0k5guIpEIaphJd
         PqfpTWKM+zX7Vg1TycNejVuLiXF8lNnf2GCknigQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Todd Kjos <tkjos@google.com>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>
Subject: [PATCH 4.4 086/113] staging: android: ashmem: Disallow ashmem memory from being remapped
Date:   Thu, 27 Feb 2020 14:36:42 +0100
Message-Id: <20200227132225.514339915@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132211.791484803@linuxfoundation.org>
References: <20200227132211.791484803@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suren Baghdasaryan <surenb@google.com>

commit 6d67b0290b4b84c477e6a2fc6e005e174d3c7786 upstream.

When ashmem file is mmapped, the resulting vma->vm_file points to the
backing shmem file with the generic fops that do not check ashmem
permissions like fops of ashmem do. If an mremap is done on the ashmem
region, then the permission checks will be skipped. Fix that by disallowing
mapping operation on the backing shmem file.

Reported-by: Jann Horn <jannh@google.com>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: stable <stable@vger.kernel.org> # 4.4,4.9,4.14,4.18,5.4
Signed-off-by: Todd Kjos <tkjos@google.com>
Reviewed-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Link: https://lore.kernel.org/r/20200127235616.48920-1-tkjos@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/android/ashmem.c |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

--- a/drivers/staging/android/ashmem.c
+++ b/drivers/staging/android/ashmem.c
@@ -357,8 +357,23 @@ static inline vm_flags_t calc_vm_may_fla
 	       _calc_vm_trans(prot, PROT_EXEC,  VM_MAYEXEC);
 }
 
+static int ashmem_vmfile_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	/* do not allow to mmap ashmem backing shmem file directly */
+	return -EPERM;
+}
+
+static unsigned long
+ashmem_vmfile_get_unmapped_area(struct file *file, unsigned long addr,
+				unsigned long len, unsigned long pgoff,
+				unsigned long flags)
+{
+	return current->mm->get_unmapped_area(file, addr, len, pgoff, flags);
+}
+
 static int ashmem_mmap(struct file *file, struct vm_area_struct *vma)
 {
+	static struct file_operations vmfile_fops;
 	struct ashmem_area *asma = file->private_data;
 	int ret = 0;
 
@@ -399,6 +414,19 @@ static int ashmem_mmap(struct file *file
 		}
 		vmfile->f_mode |= FMODE_LSEEK;
 		asma->file = vmfile;
+		/*
+		 * override mmap operation of the vmfile so that it can't be
+		 * remapped which would lead to creation of a new vma with no
+		 * asma permission checks. Have to override get_unmapped_area
+		 * as well to prevent VM_BUG_ON check for f_ops modification.
+		 */
+		if (!vmfile_fops.mmap) {
+			vmfile_fops = *vmfile->f_op;
+			vmfile_fops.mmap = ashmem_vmfile_mmap;
+			vmfile_fops.get_unmapped_area =
+					ashmem_vmfile_get_unmapped_area;
+		}
+		vmfile->f_op = &vmfile_fops;
 	}
 	get_file(asma->file);
 


