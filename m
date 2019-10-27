Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60C7DE69BB
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:38:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728197AbfJ0VDB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:03:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:48176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728200AbfJ0VDB (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:03:01 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 650772064A;
        Sun, 27 Oct 2019 21:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210179;
        bh=NQwEx9RcIChQVdBetcBfQfha/A6S/ukjoDootdvuEps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OSWfncbeY2TmnOvXptI2Rr65nCbtkiOErAwwjdRVRmi/kqOS3KbaW36eiK7MCdDYI
         HZZENqPEyzynadM0dcHia8MwRlEKwwrtk6vVWUjJffF90eEof2k334yEUWrBgmwk1d
         6uA5WFyAjZ31qiyuIY3s1cYzxdpgXtUU9MGb8IhA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, zhong jiang <zhongjiang@huawei.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 18/41] memfd: Fix locking when tagging pins
Date:   Sun, 27 Oct 2019 22:00:56 +0100
Message-Id: <20191027203115.316932905@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203056.220821342@linuxfoundation.org>
References: <20191027203056.220821342@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Wilcox (Oracle) <willy@infradead.org>

The RCU lock is insufficient to protect the radix tree iteration as
a deletion from the tree can occur before we take the spinlock to
tag the entry.  In 4.19, this has manifested as a bug with the following
trace:

kernel BUG at lib/radix-tree.c:1429!
invalid opcode: 0000 [#1] SMP KASAN PTI
CPU: 7 PID: 6935 Comm: syz-executor.2 Not tainted 4.19.36 #25
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
RIP: 0010:radix_tree_tag_set+0x200/0x2f0 lib/radix-tree.c:1429
Code: 00 00 5b 5d 41 5c 41 5d 41 5e 41 5f c3 48 89 44 24 10 e8 a3 29 7e fe 48 8b 44 24 10 48 0f ab 03 e9 d2 fe ff ff e8 90 29 7e fe <0f> 0b 48 c7 c7 e0 5a 87 84 e8 f0 e7 08 ff 4c 89 ef e8 4a ff ac fe
RSP: 0018:ffff88837b13fb60 EFLAGS: 00010016
RAX: 0000000000040000 RBX: ffff8883c5515d58 RCX: ffffffff82cb2ef0
RDX: 0000000000000b72 RSI: ffffc90004cf2000 RDI: ffff8883c5515d98
RBP: ffff88837b13fb98 R08: ffffed106f627f7e R09: ffffed106f627f7e
R10: 0000000000000001 R11: ffffed106f627f7d R12: 0000000000000004
R13: ffffea000d7fea80 R14: 1ffff1106f627f6f R15: 0000000000000002
FS:  00007fa1b8df2700(0000) GS:ffff8883e2fc0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fa1b8df1db8 CR3: 000000037d4d2001 CR4: 0000000000160ee0
Call Trace:
 memfd_tag_pins mm/memfd.c:51 [inline]
 memfd_wait_for_pins+0x2c5/0x12d0 mm/memfd.c:81
 memfd_add_seals mm/memfd.c:215 [inline]
 memfd_fcntl+0x33d/0x4a0 mm/memfd.c:247
 do_fcntl+0x589/0xeb0 fs/fcntl.c:421
 __do_sys_fcntl fs/fcntl.c:463 [inline]
 __se_sys_fcntl fs/fcntl.c:448 [inline]
 __x64_sys_fcntl+0x12d/0x180 fs/fcntl.c:448
 do_syscall_64+0xc8/0x580 arch/x86/entry/common.c:293

The problem does not occur in mainline due to the XArray rewrite which
changed the locking to exclude modification of the tree during iteration.
At the time, nobody realised this was a bugfix.  Backport the locking
changes to stable.

Cc: stable@vger.kernel.org
Reported-by: zhong jiang <zhongjiang@huawei.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/shmem.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index f11aec40f2e1d..62668379623b2 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1854,11 +1854,12 @@ static void shmem_tag_pins(struct address_space *mapping)
 	void **slot;
 	pgoff_t start;
 	struct page *page;
+	unsigned int tagged = 0;
 
 	lru_add_drain();
 	start = 0;
-	rcu_read_lock();
 
+	spin_lock_irq(&mapping->tree_lock);
 restart:
 	radix_tree_for_each_slot(slot, &mapping->page_tree, &iter, start) {
 		page = radix_tree_deref_slot(slot);
@@ -1866,19 +1867,20 @@ static void shmem_tag_pins(struct address_space *mapping)
 			if (radix_tree_deref_retry(page))
 				goto restart;
 		} else if (page_count(page) - page_mapcount(page) > 1) {
-			spin_lock_irq(&mapping->tree_lock);
 			radix_tree_tag_set(&mapping->page_tree, iter.index,
 					   SHMEM_TAG_PINNED);
-			spin_unlock_irq(&mapping->tree_lock);
 		}
 
-		if (need_resched()) {
-			cond_resched_rcu();
-			start = iter.index + 1;
-			goto restart;
-		}
+		if (++tagged % 1024)
+			continue;
+
+		spin_unlock_irq(&mapping->tree_lock);
+		cond_resched();
+		start = iter.index + 1;
+		spin_lock_irq(&mapping->tree_lock);
+		goto restart;
 	}
-	rcu_read_unlock();
+	spin_unlock_irq(&mapping->tree_lock);
 }
 
 /*
-- 
2.20.1



