Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F67F9D85B
	for <lists+stable@lfdr.de>; Mon, 26 Aug 2019 23:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728643AbfHZVbr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Aug 2019 17:31:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:40422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728755AbfHZVbr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Aug 2019 17:31:47 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE02921872;
        Mon, 26 Aug 2019 21:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566855106;
        bh=N0NyF4QrMb5XEHv2iz+7eDG0p/T4vRH3LdRla8ZA0Wg=;
        h=Date:From:To:Subject:From;
        b=vVLZMx8wkf5ChRz+7J4A5/q/RM5DNyATFT/Yg7ctahCrhygDPLC12aBnmlHJ2Pn3w
         xOYogbsh3sjSmTom+rJuDbAXszYGZjjCTILTdmaaFrXMhTnCAKyzyoRfJpzBOJYXEo
         gMz7WHDtqBANPCCauafAeGbYGEZublzTBrVxk62s=
Date:   Mon, 26 Aug 2019 14:31:45 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, jannh@google.com, jgg@mellanox.com,
        mhocko@suse.com, mm-commits@vger.kernel.org, oleg@redhat.com,
        penguin-kernel@I-love.SAKURA.ne.jp, peterx@redhat.com,
        rppt@linux.ibm.com, stable@vger.kernel.org,
        wangkefeng.wang@huawei.com
Subject:  [merged]
 =?US-ASCII?Q?userfaultfd=5Frelease-always-remove-uffd-flags-and-clear-?=
 =?US-ASCII?Q?vm=5Fuserfaultfd=5Fctx.patch?= removed from -mm tree
Message-ID: <20190826213145.YOKQLV6pE%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: userfaultfd_release: always remove uffd flags and clear vm_userfaultfd_ctx
has been removed from the -mm tree.  Its filename was
     userfaultfd_release-always-remove-uffd-flags-and-clear-vm_userfaultfd_ctx.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: userfaultfd_release: always remove uffd flags and clear vm_userfaultfd_ctx

userfaultfd_release() should clear vm_flags/vm_userfaultfd_ctx even
if mm->core_state != NULL.

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
---

 fs/userfaultfd.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

--- a/fs/userfaultfd.c~userfaultfd_release-always-remove-uffd-flags-and-clear-vm_userfaultfd_ctx
+++ a/fs/userfaultfd.c
@@ -880,6 +880,7 @@ static int userfaultfd_release(struct in
 	/* len == 0 means wake all */
 	struct userfaultfd_wake_range range = { .len = 0, };
 	unsigned long new_flags;
+	bool still_valid;
 
 	WRITE_ONCE(ctx->released, true);
 
@@ -895,8 +896,7 @@ static int userfaultfd_release(struct in
 	 * taking the mmap_sem for writing.
 	 */
 	down_write(&mm->mmap_sem);
-	if (!mmget_still_valid(mm))
-		goto skip_mm;
+	still_valid = mmget_still_valid(mm);
 	prev = NULL;
 	for (vma = mm->mmap; vma; vma = vma->vm_next) {
 		cond_resched();
@@ -907,19 +907,20 @@ static int userfaultfd_release(struct in
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
_

Patches currently in -mm which might be from oleg@redhat.com are

aio-simplify-read_events.patch

