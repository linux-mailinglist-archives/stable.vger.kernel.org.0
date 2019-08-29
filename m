Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64B5BA174E
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 12:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727331AbfH2Kye (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 06:54:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:57754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727998AbfH2Ku3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Aug 2019 06:50:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 21F6023405;
        Thu, 29 Aug 2019 10:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567075828;
        bh=1PDDwa62TovBTA6YWNtEKEwSvnc8ibL6y5KWyB5arQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G2h8anLRNnfRyUPBKdNIQQ5mQWZS8I8dXprE0anIQ9+/i3Uy9g3RCPWFlZ9sV9C7Q
         vWKxsFs3cwrwCBD+vhixIDzN5V/HqErQEJh/Mq8z6guwPUSSb76r10S7u9NplosIW8
         0DOPdprI7QlH4XPVwJROcCLklAnw13H2XrOxyGPA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oleg Nesterov <oleg@redhat.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Jann Horn <jannh@google.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Michal Hocko <mhocko@suse.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 16/29] userfaultfd_release: always remove uffd flags and clear vm_userfaultfd_ctx
Date:   Thu, 29 Aug 2019 06:49:56 -0400
Message-Id: <20190829105009.2265-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829105009.2265-1-sashal@kernel.org>
References: <20190829105009.2265-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

[ Upstream commit 46d0b24c5ee10a15dfb25e20642f5a5ed59c5003 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/userfaultfd.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index e1ebdbe40032e..9c2955f67f708 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -881,6 +881,7 @@ static int userfaultfd_release(struct inode *inode, struct file *file)
 	/* len == 0 means wake all */
 	struct userfaultfd_wake_range range = { .len = 0, };
 	unsigned long new_flags;
+	bool still_valid;
 
 	WRITE_ONCE(ctx->released, true);
 
@@ -896,8 +897,7 @@ static int userfaultfd_release(struct inode *inode, struct file *file)
 	 * taking the mmap_sem for writing.
 	 */
 	down_write(&mm->mmap_sem);
-	if (!mmget_still_valid(mm))
-		goto skip_mm;
+	still_valid = mmget_still_valid(mm);
 	prev = NULL;
 	for (vma = mm->mmap; vma; vma = vma->vm_next) {
 		cond_resched();
@@ -908,19 +908,20 @@ static int userfaultfd_release(struct inode *inode, struct file *file)
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
-- 
2.20.1

