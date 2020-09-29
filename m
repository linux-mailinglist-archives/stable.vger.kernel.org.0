Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BCAE27C6C4
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731146AbgI2Lsa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:48:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:50254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731138AbgI2Ls0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:48:26 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B3F821D46;
        Tue, 29 Sep 2020 11:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601380104;
        bh=Z9zINBTkfZmfbOq4gDCIpgMI0kU5zrXfwt8ME2p+uig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U+zSoteUyoU0eWeqe+KzZ+AnX17HtWClsGQHSQHvsVJs1sIDF/zzqbpiP9ROdyaC1
         morLrN/euEgbr75D7EOR7VKYhJy89pVQCn6MKIh0OoYcjt37LA5teuMWm/N9SeD7DU
         ZaILKRFujhkCQ5OwS6WNBpsXY0V4v6ZJnzwIs3Ow=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+ecf80462cb7d5d552bc7@syzkaller.appspotmail.com,
        Minchan Kim <minchan@kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 70/99] mm: validate pmd after splitting
Date:   Tue, 29 Sep 2020 13:01:53 +0200
Message-Id: <20200929105933.173288917@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105929.719230296@linuxfoundation.org>
References: <20200929105929.719230296@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Minchan Kim <minchan@kernel.org>

[ Upstream commit ce2684254bd4818ca3995c0d021fb62c4cf10a19 ]

syzbot reported the following KASAN splat:

  general protection fault, probably for non-canonical address 0xdffffc0000000003: 0000 [#1] PREEMPT SMP KASAN
  KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
  CPU: 1 PID: 6826 Comm: syz-executor142 Not tainted 5.9.0-rc4-syzkaller #0
  Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
  RIP: 0010:__lock_acquire+0x84/0x2ae0 kernel/locking/lockdep.c:4296
  Code: ff df 8a 04 30 84 c0 0f 85 e3 16 00 00 83 3d 56 58 35 08 00 0f 84 0e 17 00 00 83 3d 25 c7 f5 07 00 74 2c 4c 89 e8 48 c1 e8 03 <80> 3c 30 00 74 12 4c 89 ef e8 3e d1 5a 00 48 be 00 00 00 00 00 fc
  RSP: 0018:ffffc90004b9f850 EFLAGS: 00010006
  Call Trace:
    lock_acquire+0x140/0x6f0 kernel/locking/lockdep.c:5006
    __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
    _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
    spin_lock include/linux/spinlock.h:354 [inline]
    madvise_cold_or_pageout_pte_range+0x52f/0x25c0 mm/madvise.c:389
    walk_pmd_range mm/pagewalk.c:89 [inline]
    walk_pud_range mm/pagewalk.c:160 [inline]
    walk_p4d_range mm/pagewalk.c:193 [inline]
    walk_pgd_range mm/pagewalk.c:229 [inline]
    __walk_page_range+0xe7b/0x1da0 mm/pagewalk.c:331
    walk_page_range+0x2c3/0x5c0 mm/pagewalk.c:427
    madvise_pageout_page_range mm/madvise.c:521 [inline]
    madvise_pageout mm/madvise.c:557 [inline]
    madvise_vma mm/madvise.c:946 [inline]
    do_madvise+0x12d0/0x2090 mm/madvise.c:1145
    __do_sys_madvise mm/madvise.c:1171 [inline]
    __se_sys_madvise mm/madvise.c:1169 [inline]
    __x64_sys_madvise+0x76/0x80 mm/madvise.c:1169
    do_syscall_64+0x31/0x70 arch/x86/entry/common.c:46
    entry_SYSCALL_64_after_hwframe+0x44/0xa9

The backing vma was shmem.

In case of split page of file-backed THP, madvise zaps the pmd instead
of remapping of sub-pages.  So we need to check pmd validity after
split.

Reported-by: syzbot+ecf80462cb7d5d552bc7@syzkaller.appspotmail.com
Fixes: 1a4e58cce84e ("mm: introduce MADV_PAGEOUT")
Signed-off-by: Minchan Kim <minchan@kernel.org>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/madvise.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index d4aa5f7765435..0e0d61003fc6f 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -381,9 +381,9 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 		return 0;
 	}
 
+regular_page:
 	if (pmd_trans_unstable(pmd))
 		return 0;
-regular_page:
 #endif
 	tlb_change_page_size(tlb, PAGE_SIZE);
 	orig_pte = pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
-- 
2.25.1



