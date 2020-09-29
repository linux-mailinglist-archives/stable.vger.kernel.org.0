Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4AB827CC6C
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729532AbgI2MgM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:36:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:37026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729392AbgI2LU6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:20:58 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3CB722574;
        Tue, 29 Sep 2020 11:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378299;
        bh=M9BLECcRmg4gwlCqeaZTtuc1dLUoMa95rWXGsAzJuMo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PlntG8/8CoALkhHMGd7PkT0Q2DAmz0sQDwKu5ANTkksEb7q539UI6m15cPWbGiPsz
         V6pwairyvGKk/X+WbNW83oH5kUVVqyFDT+ep1tPO9QTHYJS5mYEDOBAtcSWhaas+I2
         a3YOMLDkJGPKHElj2hJXyFyXRqb0dMTw5uo66gL4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <cai@lca.pw>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Elver <elver@google.com>,
        Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 132/166] mm/swap_state: fix a data race in swapin_nr_pages
Date:   Tue, 29 Sep 2020 13:00:44 +0200
Message-Id: <20200929105941.793008586@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105935.184737111@linuxfoundation.org>
References: <20200929105935.184737111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 755be95d52f9c..3ceea86818bd4 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -524,10 +524,11 @@ static unsigned long swapin_nr_pages(unsigned long offset)
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



