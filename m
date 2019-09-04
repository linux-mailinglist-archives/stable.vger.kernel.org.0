Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B80D4A8E18
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733121AbfIDR4C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 13:56:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:33144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733100AbfIDR4C (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 13:56:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D9A221883;
        Wed,  4 Sep 2019 17:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567619761;
        bh=z6lJx5LHEJyB+ZMovtOJ+d4dKwYokh0c7+rh2PGTlLk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=apadRopfMXEG1lJivQGFoiK0fOhvxCYEsNccDoytvuSEHhh7W19RT7z/wAs26h+bo
         1sADdiixJvGtx4U6jfLx3d2U/+ZZ+DQTxy7ImOpxemRQG3pMuGBJod+PCgFyr3hvfl
         PkOFOgU5Qx01v/HpmRZJXOxF43Gu0ZAXH6oRyZ38=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Jann Horn <jannh@google.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Michal Hocko <mhocko@suse.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.4 25/77] userfaultfd_release: always remove uffd flags and clear vm_userfaultfd_ctx
Date:   Wed,  4 Sep 2019 19:53:12 +0200
Message-Id: <20190904175305.895853890@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175303.317468926@linuxfoundation.org>
References: <20190904175303.317468926@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

commit 46d0b24c5ee10a15dfb25e20642f5a5ed59c5003 upstream.

userfaultfd_release() should clear vm_flags/vm_userfaultfd_ctx even if
mm->core_state != NULL.

Otherwise a page fault can see userfaultfd_missing() == T and use an
already freed userfaultfd_ctx.

Link: http://lkml.kernel.org/r/20190820160237.GB4983@redhat.com
Fixes: 04f5866e41fb ("coredump: fix race condition between mmget_not_zero()/get_task_mm() and core dumping")
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reported-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Tested-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/userfaultfd.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -431,6 +431,7 @@ static int userfaultfd_release(struct in
 	/* len == 0 means wake all */
 	struct userfaultfd_wake_range range = { .len = 0, };
 	unsigned long new_flags;
+	bool still_valid;
 
 	ACCESS_ONCE(ctx->released) = true;
 
@@ -446,8 +447,7 @@ static int userfaultfd_release(struct in
 	 * taking the mmap_sem for writing.
 	 */
 	down_write(&mm->mmap_sem);
-	if (!mmget_still_valid(mm))
-		goto skip_mm;
+	still_valid = mmget_still_valid(mm);
 	prev = NULL;
 	for (vma = mm->mmap; vma; vma = vma->vm_next) {
 		cond_resched();
@@ -458,19 +458,20 @@ static int userfaultfd_release(struct in
 			continue;
 		}
 		new_flags = vma->vm_flags & ~(VM_UFFD_MISSING | VM_UFFD_WP);
-		prev = vma_merge(mm, prev, vma->vm_start, vma->vm_end,
-				 new_flags, vma->anon_vma,
-				 vma->vm_file, vma->vm_pgoff,
-				 vma_policy(vma),
-				 NULL_VM_UFFD_CTX);
-		if (prev)
-			vma = prev;
-		else
-			prev = vma;
+		if (still_valid) {
+			prev = vma_merge(mm, prev, vma->vm_start, vma->vm_end,
+					 new_flags, vma->anon_vma,
+					 vma->vm_file, vma->vm_pgoff,
+					 vma_policy(vma),
+					 NULL_VM_UFFD_CTX);
+			if (prev)
+				vma = prev;
+			else
+				prev = vma;
+		}
 		vma->vm_flags = new_flags;
 		vma->vm_userfaultfd_ctx = NULL_VM_UFFD_CTX;
 	}
-skip_mm:
 	up_write(&mm->mmap_sem);
 	mmput(mm);
 wakeup:


