Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6721C15F4
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730176AbgEANgw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:36:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:35508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730902AbgEANgv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:36:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E240324953;
        Fri,  1 May 2020 13:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340210;
        bh=tU8TJhxBIWcjE1Am1/vlBCvgrjTH7SCZbgZ7JE4Qicw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s6+aJyfNSzN0zAlBMG4e+mpxV/FIXW1hMmFPC02Qy+5CuPWYFd5iAeuBc+lJxIkLF
         2d3deSTjJza4AeR3s7U5yEag28XdM/lYxSfjmpIH0R6ZU2C8aXMB7nNmJ3ASYjp99P
         XSjZdmUANVCBBB6ttlmhqOX8iflJ5xBFyUkt+muU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+e27980339d305f2dbfd9@syzkaller.appspotmail.com,
        Yang Shi <yang.shi@linux.alibaba.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 25/46] mm: shmem: disable interrupt when acquiring info->lock in userfaultfd_copy path
Date:   Fri,  1 May 2020 15:22:50 +0200
Message-Id: <20200501131507.682072631@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131457.023036302@linuxfoundation.org>
References: <20200501131457.023036302@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Shi <yang.shi@linux.alibaba.com>

commit 94b7cc01da5a3cc4f3da5e0ff492ef008bb555d6 upstream.

Syzbot reported the below lockdep splat:

    WARNING: possible irq lock inversion dependency detected
    5.6.0-rc7-syzkaller #0 Not tainted
    --------------------------------------------------------
    syz-executor.0/10317 just changed the state of lock:
    ffff888021d16568 (&(&info->lock)->rlock){+.+.}, at: spin_lock include/linux/spinlock.h:338 [inline]
    ffff888021d16568 (&(&info->lock)->rlock){+.+.}, at: shmem_mfill_atomic_pte+0x1012/0x21c0 mm/shmem.c:2407
    but this lock was taken by another, SOFTIRQ-safe lock in the past:
     (&(&xa->xa_lock)->rlock#5){..-.}

    and interrupts could create inverse lock ordering between them.

    other info that might help us debug this:
     Possible interrupt unsafe locking scenario:

           CPU0                    CPU1
           ----                    ----
      lock(&(&info->lock)->rlock);
                                   local_irq_disable();
                                   lock(&(&xa->xa_lock)->rlock#5);
                                   lock(&(&info->lock)->rlock);
      <Interrupt>
        lock(&(&xa->xa_lock)->rlock#5);

     *** DEADLOCK ***

The full report is quite lengthy, please see:

  https://lore.kernel.org/linux-mm/alpine.LSU.2.11.2004152007370.13597@eggly.anvils/T/#m813b412c5f78e25ca8c6c7734886ed4de43f241d

It is because CPU 0 held info->lock with IRQ enabled in userfaultfd_copy
path, then CPU 1 is splitting a THP which held xa_lock and info->lock in
IRQ disabled context at the same time.  If softirq comes in to acquire
xa_lock, the deadlock would be triggered.

The fix is to acquire/release info->lock with *_irq version instead of
plain spin_{lock,unlock} to make it softirq safe.

Fixes: 4c27fe4c4c84 ("userfaultfd: shmem: add shmem_mcopy_atomic_pte for userfaultfd support")
Reported-by: syzbot+e27980339d305f2dbfd9@syzkaller.appspotmail.com
Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: syzbot+e27980339d305f2dbfd9@syzkaller.appspotmail.com
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Link: http://lkml.kernel.org/r/1587061357-122619-1-git-send-email-yang.shi@linux.alibaba.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/shmem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2350,11 +2350,11 @@ static int shmem_mfill_atomic_pte(struct
 
 	lru_cache_add_anon(page);
 
-	spin_lock(&info->lock);
+	spin_lock_irq(&info->lock);
 	info->alloced++;
 	inode->i_blocks += BLOCKS_PER_PAGE;
 	shmem_recalc_inode(inode);
-	spin_unlock(&info->lock);
+	spin_unlock_irq(&info->lock);
 
 	inc_mm_counter(dst_mm, mm_counter_file(page));
 	page_add_file_rmap(page, false);


