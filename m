Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 797FA9A359
	for <lists+stable@lfdr.de>; Fri, 23 Aug 2019 00:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394137AbfHVW6c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 18:58:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:36780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727461AbfHVW6c (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 18:58:32 -0400
Received: from akpm3.svl.corp.google.com (unknown [104.133.8.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD2E5205C9;
        Thu, 22 Aug 2019 22:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566514711;
        bh=pk/gf4q5QaGlLDCKQoP8DAczlMcx4jBdG7/AhpHSMnU=;
        h=Date:From:To:Subject:From;
        b=0o85AGLTiHbi/NXmVrRm9Ea+FP1gK+2BkTnf+g8fnUE04GvlvsActfx76YB/FfH/4
         wf4geV6qCeCtGkkUO4tp7l75iqWN1tAB6jVXF/Qk/CPo6csruQb8tC3xpOB3TwCYTS
         lRdiROlEEtflcAlw61W8mkTWyoRJzIA3FwEKqnc4=
Date:   Thu, 22 Aug 2019 15:58:30 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        stable@vger.kernel.org, rppt@linux.ibm.com, peterx@redhat.com,
        penguin-kernel@I-love.SAKURA.ne.jp, mhocko@suse.com,
        jgg@mellanox.com, jannh@google.com, aarcange@redhat.com,
        oleg@redhat.com
Subject:  +
 =?us-ascii?Q?userfaultfd=5Frelease-always-remove-uffd-flags-and-clear-?=
 =?us-ascii?Q?vm=5Fuserfaultfd=5Fctx.patch?= added to -mm tree
Message-ID: <20190822225830.pMW2W%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.11
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: userfaultfd_release: always remove uffd flags and clear vm_userfaultfd_ctx
has been added to the -mm tree.  Its filename is
     userfaultfd_release-always-remove-uffd-flags-and-clear-vm_userfaultfd_ctx.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd_release-always-remove-uffd-flags-and-clear-vm_userfaultfd_ctx.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd_release-always-remove-uffd-flags-and-clear-vm_userfaultfd_ctx.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

userfaultfd_release-always-remove-uffd-flags-and-clear-vm_userfaultfd_ctx.patch
aio-simplify-read_events.patch

