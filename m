Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B31AA14ACDB
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 00:58:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbgA0X41 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jan 2020 18:56:27 -0500
Received: from mail-pf1-f202.google.com ([209.85.210.202]:54602 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbgA0X41 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jan 2020 18:56:27 -0500
Received: by mail-pf1-f202.google.com with SMTP id v14so7425615pfm.21
        for <stable@vger.kernel.org>; Mon, 27 Jan 2020 15:56:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=dRo8BvIKoRhSD2Tn9OfOhx2I4O53vRoQo3RBdWWB7eE=;
        b=Uw9ndpoLPLVM3Cb40YS7MHZg7Y4O9skGXttW8XbPWDLLxAteeFE7drT1tLrpPPaQsI
         bZEVdNVizBQmdzyxz/rcBZfQL7Kjg/iV5kJRlP8AJmOsDvs7nHGQrmKj4p9giBwu4kHT
         0E7xh8ZTLk0nQPUuMGp9wt/mWAdev1sz+7QRIgYGhxRlhjQneEFOuokB3v9RyXXLz6pp
         G31wPOoFFSDHz2FIFeSUupUc7GtKVv2bN+lIn8HzwO4kXJSLK++wGduZroloS9CHphd/
         ZiqHyvK5tg2zw1+NbIUDE8tw7R0JeZDnnccNFJzAVU8W4JIPbVUc4icJnHbKdeQ7d9MC
         BNsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=dRo8BvIKoRhSD2Tn9OfOhx2I4O53vRoQo3RBdWWB7eE=;
        b=VjInPsD68hV9en0efUqaKs4uagH5FbVTjx3Oyl2TkQU/DVbITI6AHufWfe33+b9GWm
         jjmziG1OLLV6hKDcpURRqKQurWQtyEUhOrSgShs7HNHD9Bo48hLgn4RyKvpwBZm0QPQV
         Dx5Jc9hgS8t8pYsGYetEer+dNudfGZcunx9O6wtRZnAQyauP3lfrdZ2GD5imbHB4UHeJ
         tnUz/QbFDQ77iyTgFdcgxoDyWTwQrMZmLVVdPPIkuf2VfmviHJgjKO0Q8WajEhmfG6fB
         uAe90azoDY4Mx9Pb1p3ONfcMZJNv64voe5ifzbDtuxpsZn1tdc+tq6mQVLvh7xD+ySa1
         WIzg==
X-Gm-Message-State: APjAAAXqvLyH8hYxlJifhXayz7IqhP/Lp1ESiRIIEDp/O2MfEGeC/Hpq
        9kSUG9LNCmB/CLzCgcJUCD6d2chDCQ==
X-Google-Smtp-Source: APXvYqwz2z0aFgThZxhvv3L6SvsHVrydMHnFK5ay+ILi5QybHwC3uagUqAF2vWJs7qoiwmhLBLKiXgYFZQ==
X-Received: by 2002:a63:bc01:: with SMTP id q1mr23355022pge.442.1580169386231;
 Mon, 27 Jan 2020 15:56:26 -0800 (PST)
Date:   Mon, 27 Jan 2020 15:56:16 -0800
Message-Id: <20200127235616.48920-1-tkjos@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.0.341.g760bfbb309-goog
Subject: [PATCH v2] staging: android: ashmem: Disallow ashmem memory from
 being remapped
From:   Todd Kjos <tkjos@google.com>
To:     tkjos@google.com, surenb@google.com, gregkh@linuxfoundation.org,
        arve@android.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, maco@google.com
Cc:     joel@joelfernandes.org, kernel-team@android.com,
        Jann Horn <jannh@google.com>, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suren Baghdasaryan <surenb@google.com>

When ashmem file is mmapped, the resulting vma->vm_file points to the
backing shmem file with the generic fops that do not check ashmem
permissions like fops of ashmem do. If an mremap is done on the ashmem
region, then the permission checks will be skipped. Fix that by disallowing
mapping operation on the backing shmem file.

Reported-by: Jann Horn <jannh@google.com>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: stable <stable@vger.kernel.org> # 4.4,4.9,4.14,4.18,5.4
Signed-off-by: Todd Kjos <tkjos@google.com>
---
 drivers/staging/android/ashmem.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

v2: update commit message as suggested by joelaf@google.com.

diff --git a/drivers/staging/android/ashmem.c b/drivers/staging/android/ashmem.c
index 74d497d39c5a..c6695354b123 100644
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
2.25.0.341.g760bfbb309-goog

