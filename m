Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B013F5EB116
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 21:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbiIZTPj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 15:15:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbiIZTPh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 15:15:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CA73476F0;
        Mon, 26 Sep 2022 12:15:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E3B6A60EB1;
        Mon, 26 Sep 2022 19:15:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 411C9C433D6;
        Mon, 26 Sep 2022 19:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664219735;
        bh=KPhpBcI4mH9+2pjc4hq3rwiWRb1GOEJSBWxmO+7/JOA=;
        h=Date:To:From:Subject:From;
        b=TkVQxSi/kyKSwvKa4jMqGfFfKI618IOM4blOcJvBw7PYiT2i5hlQiebYMJdx+BeEf
         WsRCbmIb70vg8DI2i/PAz1hzG2qRcsyqWLIJsCVgppzJS7dEZkaTG6aM48fSCKqD1X
         9NtfDIMq6cB2Z7ZGGbSsjFP8A5KucZD/zWhu0lMs=
Date:   Mon, 26 Sep 2022 12:15:34 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        stable@vger.kernel.org, songmuchun@bytedance.com,
        shy828301@gmail.com, osalvador@suse.de, mhocko@suse.com,
        linmiaohe@huawei.com, kirill.shutemov@linux.intel.com,
        david@redhat.com, naoya.horiguchi@nec.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-huge_memory-use-pfn_to_online_page-in-split_huge_pages_all.patch removed from -mm tree
Message-Id: <20220926191535.411C9C433D6@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm/huge_memory: use pfn_to_online_page() in split_huge_pages_all()
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-use-pfn_to_online_page-in-split_huge_pages_all.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: mm/huge_memory: use pfn_to_online_page() in split_huge_pages_all()
Date: Thu, 8 Sep 2022 13:11:50 +0900

NULL pointer dereference is triggered when calling thp split via debugfs
on the system with offlined memory blocks.  With debug option enabled, the
following kernel messages are printed out:

  page:00000000467f4890 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x121c000
  flags: 0x17fffc00000000(node=0|zone=2|lastcpupid=0x1ffff)
  raw: 0017fffc00000000 0000000000000000 dead000000000122 0000000000000000
  raw: 0000000000000000 0000000000000000 00000001ffffffff 0000000000000000
  page dumped because: unmovable page
  page:000000007d7ab72e is uninitialized and poisoned
  page dumped because: VM_BUG_ON_PAGE(PagePoisoned(p))
  ------------[ cut here ]------------
  kernel BUG at include/linux/mm.h:1248!
  invalid opcode: 0000 [#1] PREEMPT SMP PTI
  CPU: 16 PID: 20964 Comm: bash Tainted: G          I        6.0.0-rc3-foll-numa+ #41
  ...
  RIP: 0010:split_huge_pages_write+0xcf4/0xe30

This shows that page_to_nid() in page_zone() is unexpectedly called for an
offlined memmap.

Use pfn_to_online_page() to get struct page in PFN walker.

Link: https://lkml.kernel.org/r/20220908041150.3430269-1-naoya.horiguchi@linux.dev
Fixes: f1dd2cd13c4b ("mm, memory_hotplug: do not associate hotadded memory to zones until online")      [visible after d0dc12e86b319]
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Co-developed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: <stable@vger.kernel.org>	[5.10+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-use-pfn_to_online_page-in-split_huge_pages_all
+++ a/mm/huge_memory.c
@@ -2894,11 +2894,9 @@ static void split_huge_pages_all(void)
 		max_zone_pfn = zone_end_pfn(zone);
 		for (pfn = zone->zone_start_pfn; pfn < max_zone_pfn; pfn++) {
 			int nr_pages;
-			if (!pfn_valid(pfn))
-				continue;
 
-			page = pfn_to_page(pfn);
-			if (!get_page_unless_zero(page))
+			page = pfn_to_online_page(pfn);
+			if (!page || !get_page_unless_zero(page))
 				continue;
 
 			if (zone != page_zone(page))
_

Patches currently in -mm which might be from naoya.horiguchi@nec.com are

mmhwpoisonhugetlbmemory_hotplug-hotremove-memory-section-with-hwpoisoned-hugepage.patch
mm-hwpoison-move-definitions-of-num_poisoned_pages_-to-memory-failurec.patch
mm-hwpoison-pass-pfn-to-num_poisoned_pages_.patch
mm-hwpoison-introduce-per-memory_block-hwpoison-counter.patch

