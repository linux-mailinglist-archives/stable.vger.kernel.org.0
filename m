Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3EA013312C
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 21:58:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727328AbgAGU6U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 15:58:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:57268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727822AbgAGU6T (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 15:58:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB59221744;
        Tue,  7 Jan 2020 20:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430698;
        bh=bXA2aXAoMwRwk9E7vq7jPFZdaJyFMqRgbUf+s41nX+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cXIXT2kc5lct4qw+7KvFhl0GVtvik+B5LZ4nqwEP3WAqHXPW6RXS8iK7S0H4JH/RD
         3cnDRmC9gMD2mouBDN0UNsPmtGKHbYMVjmQ1f65TGvr18T7VWojVtgJPhJMsaZmDvw
         jzNm516xkFWN29zbcTWSLxDVQsLcq1YLUtazc6b4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        syzbot+03ee87124ee05af991bd@syzkaller.appspotmail.com,
        Johannes Weiner <hannes@cmpxchg.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Hillf Danton <hdanton@sina.com>,
        Hugh Dickins <hughd@google.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 060/191] shmem: pin the file in shmem_fault() if mmap_sem is dropped
Date:   Tue,  7 Jan 2020 21:53:00 +0100
Message-Id: <20200107205336.207883389@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

[ Upstream commit 8897c1b1a1795cab23d5ac13e4e23bf0b5f4e0c6 ]

syzbot found the following crash:

  BUG: KASAN: use-after-free in perf_trace_lock_acquire+0x401/0x530 include/trace/events/lock.h:13
  Read of size 8 at addr ffff8880a5cf2c50 by task syz-executor.0/26173

  CPU: 0 PID: 26173 Comm: syz-executor.0 Not tainted 5.3.0-rc6 #146
  Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
  Call Trace:
     perf_trace_lock_acquire+0x401/0x530 include/trace/events/lock.h:13
     trace_lock_acquire include/trace/events/lock.h:13 [inline]
     lock_acquire+0x2de/0x410 kernel/locking/lockdep.c:4411
     __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
     _raw_spin_lock+0x2f/0x40 kernel/locking/spinlock.c:151
     spin_lock include/linux/spinlock.h:338 [inline]
     shmem_fault+0x5ec/0x7b0 mm/shmem.c:2034
     __do_fault+0x111/0x540 mm/memory.c:3083
     do_shared_fault mm/memory.c:3535 [inline]
     do_fault mm/memory.c:3613 [inline]
     handle_pte_fault mm/memory.c:3840 [inline]
     __handle_mm_fault+0x2adf/0x3f20 mm/memory.c:3964
     handle_mm_fault+0x1b5/0x6b0 mm/memory.c:4001
     do_user_addr_fault arch/x86/mm/fault.c:1441 [inline]
     __do_page_fault+0x536/0xdd0 arch/x86/mm/fault.c:1506
     do_page_fault+0x38/0x590 arch/x86/mm/fault.c:1530
     page_fault+0x39/0x40 arch/x86/entry/entry_64.S:1202

It happens if the VMA got unmapped under us while we dropped mmap_sem
and inode got freed.

Pinning the file if we drop mmap_sem fixes the issue.

Link: http://lkml.kernel.org/r/20190927083908.rhifa4mmaxefc24r@box
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: syzbot+03ee87124ee05af991bd@syzkaller.appspotmail.com
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/shmem.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 7a22e3e03d11..6074714fdbd4 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2022,16 +2022,14 @@ static vm_fault_t shmem_fault(struct vm_fault *vmf)
 		    shmem_falloc->waitq &&
 		    vmf->pgoff >= shmem_falloc->start &&
 		    vmf->pgoff < shmem_falloc->next) {
+			struct file *fpin;
 			wait_queue_head_t *shmem_falloc_waitq;
 			DEFINE_WAIT_FUNC(shmem_fault_wait, synchronous_wake_function);
 
 			ret = VM_FAULT_NOPAGE;
-			if ((vmf->flags & FAULT_FLAG_ALLOW_RETRY) &&
-			   !(vmf->flags & FAULT_FLAG_RETRY_NOWAIT)) {
-				/* It's polite to up mmap_sem if we can */
-				up_read(&vma->vm_mm->mmap_sem);
+			fpin = maybe_unlock_mmap_for_io(vmf, NULL);
+			if (fpin)
 				ret = VM_FAULT_RETRY;
-			}
 
 			shmem_falloc_waitq = shmem_falloc->waitq;
 			prepare_to_wait(shmem_falloc_waitq, &shmem_fault_wait,
@@ -2049,6 +2047,9 @@ static vm_fault_t shmem_fault(struct vm_fault *vmf)
 			spin_lock(&inode->i_lock);
 			finish_wait(shmem_falloc_waitq, &shmem_fault_wait);
 			spin_unlock(&inode->i_lock);
+
+			if (fpin)
+				fput(fpin);
 			return ret;
 		}
 		spin_unlock(&inode->i_lock);
-- 
2.20.1



