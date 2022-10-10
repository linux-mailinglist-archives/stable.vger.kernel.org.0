Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69AB75F99A8
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 09:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232146AbiJJHOi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 03:14:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232306AbiJJHN4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 03:13:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 314436398;
        Mon, 10 Oct 2022 00:09:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 889E660AB4;
        Mon, 10 Oct 2022 07:08:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B8BEC433D7;
        Mon, 10 Oct 2022 07:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665385709;
        bh=1mtKAi/zHZdZig8z+X4KJu1aze1xFbM3lIKHKqtYoJE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t8PCuVbsn8KJ0H4Fy5v1CBGnSxywCaG791g0vgcMg3sf0RqRYirt+VY8mdQJr60di
         piLzQislwkL6DDY7uUIrKCBaFkm0JDrLLfrxazm5sYCyfzxlNjzaSu2WSgCvhuxoZC
         xEgCgYFefjBzeC8CIwtHCVtXaPkEylPOO+YPe1Sc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Naoya Horiguchi <naoya.horiguchi@nec.com>,
        David Hildenbrand <david@redhat.com>,
        Yang Shi <shy828301@gmail.com>, Michal Hocko <mhocko@suse.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Oscar Salvador <osalvador@suse.de>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 32/37] mm/huge_memory: use pfn_to_online_page() in split_huge_pages_all()
Date:   Mon, 10 Oct 2022 09:05:51 +0200
Message-Id: <20221010070332.125282026@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221010070331.211113813@linuxfoundation.org>
References: <20221010070331.211113813@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naoya Horiguchi <naoya.horiguchi@nec.com>

[ Upstream commit 2b7aa91ba0e86b8643f5d3c83874c80599c731d7 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/huge_memory.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 34d2979489fd..07941a1540cb 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2885,11 +2885,9 @@ static void split_huge_pages_all(void)
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
-- 
2.35.1



