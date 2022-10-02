Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 052D75F2295
	for <lists+stable@lfdr.de>; Sun,  2 Oct 2022 12:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbiJBK0V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Oct 2022 06:26:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbiJBK0U (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Oct 2022 06:26:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EF4C2251E
        for <stable@vger.kernel.org>; Sun,  2 Oct 2022 03:26:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21212B80D20
        for <stable@vger.kernel.org>; Sun,  2 Oct 2022 10:26:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BE5DC433D6;
        Sun,  2 Oct 2022 10:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664706376;
        bh=YPy2wWG0zeggavlbdECPJn3I1wvDawlEXqO8l7blKdk=;
        h=Subject:To:Cc:From:Date:From;
        b=PE+C+ouMyIkSxs9gTMfP0vuEcTz0RHvvDFsHAm/cW57ZZmpz3z38R+oSN4Y5OBPRM
         VNWJSs3aOAooPVPhv2AHK9ouj5wMjB7nhe+MuodtmDg5bIejOgFKnuK1M86vDfvERR
         oeer6lZqoSIpXh0/VkgUUV4i1lEmi7uiFl+66GRY=
Subject: FAILED: patch "[PATCH] mm/huge_memory: use pfn_to_online_page() in" failed to apply to 5.10-stable tree
To:     naoya.horiguchi@nec.com, akpm@linux-foundation.org,
        david@redhat.com, kirill.shutemov@linux.intel.com,
        linmiaohe@huawei.com, mhocko@suse.com, osalvador@suse.de,
        shy828301@gmail.com, songmuchun@bytedance.com,
        stable@vger.kernel.org, willy@infradead.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 02 Oct 2022 12:26:45 +0200
Message-ID: <16647064055051@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

2b7aa91ba0e8 ("mm/huge_memory: use pfn_to_online_page() in split_huge_pages_all()")
a17206dac7b2 ("mm/huge_memory: minor cleanup for split_huge_pages_all")
fa6c02315f74 ("mm: huge_memory: a new debugfs interface for splitting THP tests")
f3a45709d2bb ("selftests/vm: hmm-tests: remove the libhugetlbfs dependency")
f545605cc08e ("selftests/vm: minor cleanup: Makefile and gup_test.c")
b9dcfdff8b4b ("selftests/vm: use a common gup_test.h")
9c84f229268f ("mm/gup_benchmark: rename to mm/gup_test")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2b7aa91ba0e86b8643f5d3c83874c80599c731d7 Mon Sep 17 00:00:00 2001
From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Date: Thu, 8 Sep 2022 13:11:50 +0900
Subject: [PATCH] mm/huge_memory: use pfn_to_online_page() in
 split_huge_pages_all()

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

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index e9414ee57c5b..f42bb51e023a 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
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

