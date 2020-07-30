Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 784A12338FE
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 21:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730566AbgG3T0k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 15:26:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730529AbgG3T0j (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jul 2020 15:26:39 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F22D6C06174A
        for <stable@vger.kernel.org>; Thu, 30 Jul 2020 12:26:38 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id g17so18766831qvw.0
        for <stable@vger.kernel.org>; Thu, 30 Jul 2020 12:26:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=fWc6OJCig1UgfvHtWplz+nD9vozoDKzNVIvYHPTkg44=;
        b=gj5uH8D4Swjos7n2MMJejn1TAY3/L82VroaxdW/TCkIJ79VyK0QF+7je5BWTh2VdbP
         S5EJcY/69Oah1CX+JxuEJQFQiERjk/P36vSs5VY/IAzzXXFTcElypDb5ad2LCfKgg07p
         bxmXzb+N1u0FJ/kmrnEpOysUXavSYtx5LY2CqEkI9v108NbkONilghGgiQFXGU6ZnOQS
         tV4PACfZgq/MYzgVSxp7OsSRh4PVZC9+HRmf49Eutm2q6iUHcHMvbPFTIqgYorCXg0F3
         6Rxksb9qwD2MmW8j0Y9pUDSrTzgxYA1mNCTFcqttpvKe9S03LbVAvGFse0CBzYiYrZDF
         25FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=fWc6OJCig1UgfvHtWplz+nD9vozoDKzNVIvYHPTkg44=;
        b=UY/g2wgCWj+jlr3j4Cuc38AG4plya+qEFwcL2Y5z5vwEFIn4OO8G7vyv5o8FR3LV+1
         51+8wknqkCwKT3l2uzQAlTQ2fT5Xuq6GSXUJS+snn38/m8jP7E6i8gOYNcwKtu9Y0nb3
         TL91XmWoBX7kdYFcufG2LSkzrz9v2ASakp5E26BxVxfH+W6PEr3GRFAvM0UizOH9X4Ni
         R61sF8zuCEtXVwHp9+NP1G6ZQJJmtU6meisnZLAj/1Qa5VbIPVVCZBBR/j8ZKMNtqG43
         kvr1wUmKBpeubS1Zex9q0XAWJ1z0/Pb7pTMijo4B6Fpj5KYlpUXmP+E8Um8MDkHkven2
         PtyQ==
X-Gm-Message-State: AOAM533FYyYpXGrYIzmh/FQMAvkIBjk/LwqNMwMxOYgIfr/Ng/hgW6N6
        YYQ0RLW6JSyVMRknE8W9sZLfFgawm5g=
X-Google-Smtp-Source: ABdhPJzEMZe4ramJ8Ov7HBdblAvH3a+W031fHCnG32znIrk4AscZJPDQJ3jlVI/1fwnUZWE1mXm5diLdqiM=
X-Received: by 2002:ad4:40cb:: with SMTP id x11mr702214qvp.176.1596137197459;
 Thu, 30 Jul 2020 12:26:37 -0700 (PDT)
Date:   Thu, 30 Jul 2020 12:26:32 -0700
Message-Id: <20200730192632.3088194-1-surenb@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.163.g6104cc2f0b6-goog
Subject: [PATCH v2 1/1] staging: android: ashmem: Fix lockdep warning for
 write operation
From:   Suren Baghdasaryan <surenb@google.com>
To:     surenb@google.com
Cc:     gregkh@linuxfoundation.org, arve@android.com, tkjos@android.com,
        maco@android.com, joel@joelfernandes.org, christian@brauner.io,
        hridya@google.com, mhocko@kernel.org, hdanton@sina.com,
        ebiggers@kernel.org, devel@driverdev.osuosl.org,
        linux-mm@kvack.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@android.com,
        syzbot+7a0d9d0b26efefe61780@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

syzbot report [1] describes a deadlock when write operation against an
ashmem fd executed at the time when ashmem is shrinking its cache results
in the following lock sequence:

Possible unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   lock(fs_reclaim);
                                lock(&sb->s_type->i_mutex_key#13);
                                lock(fs_reclaim);
   lock(&sb->s_type->i_mutex_key#13);

kswapd takes fs_reclaim and then inode_lock while generic_perform_write
takes inode_lock and then fs_reclaim. However ashmem does not support
writing into backing shmem with a write syscall. The only way to change
its content is to mmap it and operate on mapped memory. Therefore the race
that lockdep is warning about is not valid. Resolve this by introducing a
separate lockdep class for the backing shmem inodes.

[1]: https://lkml.kernel.org/lkml/0000000000000b5f9d059aa2037f@google.com/

Reported-by: syzbot+7a0d9d0b26efefe61780@syzkaller.appspotmail.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
 drivers/staging/android/ashmem.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/staging/android/ashmem.c b/drivers/staging/android/ashmem.c
index c05a214191da..10b4be1f3e78 100644
--- a/drivers/staging/android/ashmem.c
+++ b/drivers/staging/android/ashmem.c
@@ -95,6 +95,15 @@ static DEFINE_MUTEX(ashmem_mutex);
 static struct kmem_cache *ashmem_area_cachep __read_mostly;
 static struct kmem_cache *ashmem_range_cachep __read_mostly;
 
+/*
+ * A separate lockdep class for the backing shmem inodes to resolve the lockdep
+ * warning about the race between kswapd taking fs_reclaim before inode_lock
+ * and write syscall taking inode_lock and then fs_reclaim.
+ * Note that such race is impossible because ashmem does not support write
+ * syscalls operating on the backing shmem.
+ */
+static struct lock_class_key backing_shmem_inode_class;
+
 static inline unsigned long range_size(struct ashmem_range *range)
 {
 	return range->pgend - range->pgstart + 1;
@@ -396,6 +405,7 @@ static int ashmem_mmap(struct file *file, struct vm_area_struct *vma)
 	if (!asma->file) {
 		char *name = ASHMEM_NAME_DEF;
 		struct file *vmfile;
+		struct inode *inode;
 
 		if (asma->name[ASHMEM_NAME_PREFIX_LEN] != '\0')
 			name = asma->name;
@@ -407,6 +417,8 @@ static int ashmem_mmap(struct file *file, struct vm_area_struct *vma)
 			goto out;
 		}
 		vmfile->f_mode |= FMODE_LSEEK;
+		inode = file_inode(vmfile);
+		lockdep_set_class(&inode->i_rwsem, &backing_shmem_inode_class);
 		asma->file = vmfile;
 		/*
 		 * override mmap operation of the vmfile so that it can't be
-- 
2.28.0.163.g6104cc2f0b6-goog

