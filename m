Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA49826F1DF
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbgIRCy1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:54:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:57840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727933AbgIRCHa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:07:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E30D92395B;
        Fri, 18 Sep 2020 02:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394849;
        bh=VTQoAoqYGfRwWaGjxQi8u51L4JKtV0UYPVCsZYsx8Yg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AWGSYwfsHsvabrddcUo/HGvhE80kYQPBCh8EkGUKJvURCDXG30xtMShtQ9FQ07UYR
         1yuE32y+moZVcCb9ijQPufUhBcM+QFsMjEf7TWqBxy5eF+NkjBTmAGJ499mvKSkerx
         rXT5xaa+sHIJrb2Oq7kBzpFiMCA+r1CHoPZi7te8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qian Cai <cai@lca.pw>, Andrew Morton <akpm@linux-foundation.org>,
        Marco Elver <elver@google.com>,
        Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org
Subject: [PATCH AUTOSEL 5.4 306/330] mm/swap_state: fix a data race in swapin_nr_pages
Date:   Thu, 17 Sep 2020 22:00:46 -0400
Message-Id: <20200918020110.2063155-306-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <cai@lca.pw>

[ Upstream commit d6c1f098f2a7ba62627c9bc17cda28f534ef9e4a ]

"prev_offset" is a static variable in swapin_nr_pages() that can be
accessed concurrently with only mmap_sem held in read mode as noticed by
KCSAN,

 BUG: KCSAN: data-race in swap_cluster_readahead / swap_cluster_readahead

 write to 0xffffffff92763830 of 8 bytes by task 14795 on cpu 17:
  swap_cluster_readahead+0x2a6/0x5e0
  swapin_readahead+0x92/0x8dc
  do_swap_page+0x49b/0xf20
  __handle_mm_fault+0xcfb/0xd70
  handle_mm_fault+0xfc/0x2f0
  do_page_fault+0x263/0x715
  page_fault+0x34/0x40

 1 lock held by (dnf)/14795:
  #0: ffff897bd2e98858 (&mm->mmap_sem#2){++++}-{3:3}, at: do_page_fault+0x143/0x715
  do_user_addr_fault at arch/x86/mm/fault.c:1405
  (inlined by) do_page_fault at arch/x86/mm/fault.c:1535
 irq event stamp: 83493
 count_memcg_event_mm+0x1a6/0x270
 count_memcg_event_mm+0x119/0x270
 __do_softirq+0x365/0x589
 irq_exit+0xa2/0xc0

 read to 0xffffffff92763830 of 8 bytes by task 1 on cpu 22:
  swap_cluster_readahead+0xfd/0x5e0
  swapin_readahead+0x92/0x8dc
  do_swap_page+0x49b/0xf20
  __handle_mm_fault+0xcfb/0xd70
  handle_mm_fault+0xfc/0x2f0
  do_page_fault+0x263/0x715
  page_fault+0x34/0x40

 1 lock held by systemd/1:
  #0: ffff897c38f14858 (&mm->mmap_sem#2){++++}-{3:3}, at: do_page_fault+0x143/0x715
 irq event stamp: 43530289
 count_memcg_event_mm+0x1a6/0x270
 count_memcg_event_mm+0x119/0x270
 __do_softirq+0x365/0x589
 irq_exit+0xa2/0xc0

Signed-off-by: Qian Cai <cai@lca.pw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Marco Elver <elver@google.com>
Cc: Hugh Dickins <hughd@google.com>
Link: http://lkml.kernel.org/r/20200402213748.2237-1-cai@lca.pw
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/swap_state.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/swap_state.c b/mm/swap_state.c
index 4ce014dc4571a..7c434fcfff0dd 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -511,10 +511,11 @@ static unsigned long swapin_nr_pages(unsigned long offset)
 		return 1;
 
 	hits = atomic_xchg(&swapin_readahead_hits, 0);
-	pages = __swapin_nr_pages(prev_offset, offset, hits, max_pages,
+	pages = __swapin_nr_pages(READ_ONCE(prev_offset), offset, hits,
+				  max_pages,
 				  atomic_read(&last_readahead_pages));
 	if (!hits)
-		prev_offset = offset;
+		WRITE_ONCE(prev_offset, offset);
 	atomic_set(&last_readahead_pages, pages);
 
 	return pages;
-- 
2.25.1

