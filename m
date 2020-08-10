Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C076240A76
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbgHJPTd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:19:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:49496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726923AbgHJPTc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:19:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D519820772;
        Mon, 10 Aug 2020 15:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597072771;
        bh=x7ozp1mq3C1BY63eMKEcpS3peJBmk+UfyCtDfXhOuww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WW6uMb+OJ6RboRehNYnJoIzRHhcgrWZ2qegXVnXxkh0WuH9H63mqm8F0NZHG20xBl
         j4LKR2fM+fOZD5YiRIF5ZW9gUeRSgSVC/WwprNKWjHKc7D4BozhfoLFXiHSO5PMbEH
         QYzYGadu5utuJK9AS3xHO26L0DMtaimcfRVliTeg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+7a0d9d0b26efefe61780@syzkaller.appspotmail.com,
        Suren Baghdasaryan <surenb@google.com>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>
Subject: [PATCH 5.8 12/38] staging: android: ashmem: Fix lockdep warning for write operation
Date:   Mon, 10 Aug 2020 17:19:02 +0200
Message-Id: <20200810151804.498690435@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810151803.920113428@linuxfoundation.org>
References: <20200810151803.920113428@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suren Baghdasaryan <surenb@google.com>

commit 3e338d3c95c735dc3265a86016bb4c022ec7cadc upstream.

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
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Link: https://lore.kernel.org/r/20200730192632.3088194-1-surenb@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/android/ashmem.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

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
@@ -396,6 +405,7 @@ static int ashmem_mmap(struct file *file
 	if (!asma->file) {
 		char *name = ASHMEM_NAME_DEF;
 		struct file *vmfile;
+		struct inode *inode;
 
 		if (asma->name[ASHMEM_NAME_PREFIX_LEN] != '\0')
 			name = asma->name;
@@ -407,6 +417,8 @@ static int ashmem_mmap(struct file *file
 			goto out;
 		}
 		vmfile->f_mode |= FMODE_LSEEK;
+		inode = file_inode(vmfile);
+		lockdep_set_class(&inode->i_rwsem, &backing_shmem_inode_class);
 		asma->file = vmfile;
 		/*
 		 * override mmap operation of the vmfile so that it can't be


