Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63A8B158029
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 17:51:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727499AbgBJQv3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 11:51:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:42356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727003AbgBJQv3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 11:51:29 -0500
Received: from localhost (unknown [104.132.1.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E65820838;
        Mon, 10 Feb 2020 16:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581353488;
        bh=Ce8kXQ9T5gX59JnbPXNw4G+gvEgPEenLfc9x509t1cI=;
        h=Subject:To:From:Date:From;
        b=dJpiVhcSWqw9wYpYnYSyxlrfU2SjyaMvbLNKtj+xmGiqVcAuWjctNLIRuOHhvHVhC
         bl95upb/41B3EMby8/6/W8GKwKQdRdTIfqKrlcY44R0JafWBBiva8cs8R40vWuRB8/
         1N6qM5zhbG04wgaAiNZpDX6/Rc3NkGd9PyGorvzM=
Subject: patch "staging: android: ashmem: Disallow ashmem memory from being remapped" added to staging-linus
To:     surenb@google.com, gregkh@linuxfoundation.org, jannh@google.com,
        joel@joelfernandes.org, stable@vger.kernel.org, tkjos@google.com
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 10 Feb 2020 08:51:27 -0800
Message-ID: <1581353487249@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: android: ashmem: Disallow ashmem memory from being remapped

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 6d67b0290b4b84c477e6a2fc6e005e174d3c7786 Mon Sep 17 00:00:00 2001
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 27 Jan 2020 15:56:16 -0800
Subject: staging: android: ashmem: Disallow ashmem memory from being remapped

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
 drivers/staging/android/ashmem.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/staging/android/ashmem.c b/drivers/staging/android/ashmem.c
index 5891d0744a76..8044510d8ec6 100644
--- a/drivers/staging/android/ashmem.c
+++ b/drivers/staging/android/ashmem.c
@@ -351,8 +351,23 @@ static inline vm_flags_t calc_vm_may_flags(unsigned long prot)
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
 
@@ -393,6 +408,19 @@ static int ashmem_mmap(struct file *file, struct vm_area_struct *vma)
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
 
-- 
2.25.0


