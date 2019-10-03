Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50CF8CA917
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404561AbfJCQhY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:37:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:46690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404549AbfJCQhU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:37:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6A34215EA;
        Thu,  3 Oct 2019 16:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120640;
        bh=lxArp3kU4HFZxrzSHItw74m76dcaz61ksoyl0nVuO+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZZdjzL/jtDlmWacfTtqVnY75xbOLvuLvZ+7/8IUz/E+9RRUVLIkXtsGtVh1UW0r8d
         s8uX5ynw1SAMidi7iCkokdKq0yO76Hy1p5Zmpc7vvJb/ev7V5sTsglG+JE3RiFMH8d
         JeTscCmncwV+0ELLTrAPgrwhfoNeg2CnOafGKqZc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        Boaz Harrosh <boazh@netapp.com>, Jan Kara <jack@suse.cz>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 5.2 298/313] mm: Handle MADV_WILLNEED through vfs_fadvise()
Date:   Thu,  3 Oct 2019 17:54:36 +0200
Message-Id: <20191003154602.510522173@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit 692fe62433d4ca47605b39f7c416efd6679ba694 upstream.

Currently handling of MADV_WILLNEED hint calls directly into readahead
code. Handle it by calling vfs_fadvise() instead so that filesystem can
use its ->fadvise() callback to acquire necessary locks or otherwise
prepare for the request.

Suggested-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Boaz Harrosh <boazh@netapp.com>
CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/madvise.c |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -14,6 +14,7 @@
 #include <linux/userfaultfd_k.h>
 #include <linux/hugetlb.h>
 #include <linux/falloc.h>
+#include <linux/fadvise.h>
 #include <linux/sched.h>
 #include <linux/ksm.h>
 #include <linux/fs.h>
@@ -275,6 +276,7 @@ static long madvise_willneed(struct vm_a
 			     unsigned long start, unsigned long end)
 {
 	struct file *file = vma->vm_file;
+	loff_t offset;
 
 	*prev = vma;
 #ifdef CONFIG_SWAP
@@ -298,12 +300,20 @@ static long madvise_willneed(struct vm_a
 		return 0;
 	}
 
-	start = ((start - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
-	if (end > vma->vm_end)
-		end = vma->vm_end;
-	end = ((end - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
-
-	force_page_cache_readahead(file->f_mapping, file, start, end - start);
+	/*
+	 * Filesystem's fadvise may need to take various locks.  We need to
+	 * explicitly grab a reference because the vma (and hence the
+	 * vma's reference to the file) can go away as soon as we drop
+	 * mmap_sem.
+	 */
+	*prev = NULL;	/* tell sys_madvise we drop mmap_sem */
+	get_file(file);
+	up_read(&current->mm->mmap_sem);
+	offset = (loff_t)(start - vma->vm_start)
+			+ ((loff_t)vma->vm_pgoff << PAGE_SHIFT);
+	vfs_fadvise(file, offset, end - start, POSIX_FADV_WILLNEED);
+	fput(file);
+	down_read(&current->mm->mmap_sem);
 	return 0;
 }
 


