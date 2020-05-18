Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A84531D815C
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730218AbgERRrY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:47:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:47680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730216AbgERRrY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:47:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F4D120657;
        Mon, 18 May 2020 17:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824043;
        bh=z5M26JN3oKmUKVO7Mo17wDGwsf4KLmWreqXcBVOtFX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r2hAtbCu74E/dld5Nzo1TaAz/D37SSKBUUi0dMVHRulDnIUEbsIg/7twHKSb6qOmY
         zO1V/npM3PmnIOp2rvWNOdWY2ejzJlIRsBjYKPouPxIvOYNEmBYcCN7o2ElzgkozRb
         TpooiGtEBkpZCSw2eC360WUvTWgfexwhquJcqkl0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+c8a8197c8852f566b9d9@syzkaller.appspotmail.com,
        syzbot+40b71e145e73f78f81ad@syzkaller.appspotmail.com,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yang Shi <yang.shi@linux.alibaba.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 049/114] shmem: fix possible deadlocks on shmlock_user_lock
Date:   Mon, 18 May 2020 19:36:21 +0200
Message-Id: <20200518173512.163301759@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173503.033975649@linuxfoundation.org>
References: <20200518173503.033975649@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hugh Dickins <hughd@google.com>

[ Upstream commit ea0dfeb4209b4eab954d6e00ed136bc6b48b380d ]

Recent commit 71725ed10c40 ("mm: huge tmpfs: try to split_huge_page()
when punching hole") has allowed syzkaller to probe deeper, uncovering a
long-standing lockdep issue between the irq-unsafe shmlock_user_lock,
the irq-safe xa_lock on mapping->i_pages, and shmem inode's info->lock
which nests inside xa_lock (or tree_lock) since 4.8's shmem_uncharge().

user_shm_lock(), servicing SysV shmctl(SHM_LOCK), wants
shmlock_user_lock while its caller shmem_lock() holds info->lock with
interrupts disabled; but hugetlbfs_file_setup() calls user_shm_lock()
with interrupts enabled, and might be interrupted by a writeback endio
wanting xa_lock on i_pages.

This may not risk an actual deadlock, since shmem inodes do not take
part in writeback accounting, but there are several easy ways to avoid
it.

Requiring interrupts disabled for shmlock_user_lock would be easy, but
it's a high-level global lock for which that seems inappropriate.
Instead, recall that the use of info->lock to guard info->flags in
shmem_lock() dates from pre-3.1 days, when races with SHMEM_PAGEIN and
SHMEM_TRUNCATE could occur: nowadays it serves no purpose, the only flag
added or removed is VM_LOCKED itself, and calls to shmem_lock() an inode
are already serialized by the caller.

Take info->lock out of the chain and the possibility of deadlock or
lockdep warning goes away.

Fixes: 4595ef88d136 ("shmem: make shmem_inode_info::lock irq-safe")
Reported-by: syzbot+c8a8197c8852f566b9d9@syzkaller.appspotmail.com
Reported-by: syzbot+40b71e145e73f78f81ad@syzkaller.appspotmail.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Yang Shi <yang.shi@linux.alibaba.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Link: http://lkml.kernel.org/r/alpine.LSU.2.11.2004161707410.16322@eggly.anvils
Link: https://lore.kernel.org/lkml/000000000000e5838c05a3152f53@google.com/
Link: https://lore.kernel.org/lkml/0000000000003712b305a331d3b1@google.com/
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/shmem.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index f9a1e0ba259f3..24005c3b345ca 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2129,7 +2129,11 @@ int shmem_lock(struct file *file, int lock, struct user_struct *user)
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	int retval = -ENOMEM;
 
-	spin_lock_irq(&info->lock);
+	/*
+	 * What serializes the accesses to info->flags?
+	 * ipc_lock_object() when called from shmctl_do_lock(),
+	 * no serialization needed when called from shm_destroy().
+	 */
 	if (lock && !(info->flags & VM_LOCKED)) {
 		if (!user_shm_lock(inode->i_size, user))
 			goto out_nomem;
@@ -2144,7 +2148,6 @@ int shmem_lock(struct file *file, int lock, struct user_struct *user)
 	retval = 0;
 
 out_nomem:
-	spin_unlock_irq(&info->lock);
 	return retval;
 }
 
-- 
2.20.1



