Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE124FEAE6
	for <lists+stable@lfdr.de>; Wed, 13 Apr 2022 01:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbiDLXUj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 19:20:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbiDLXTf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 19:19:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85253EDF20;
        Tue, 12 Apr 2022 16:02:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43F16B82008;
        Tue, 12 Apr 2022 20:59:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFE1CC385A5;
        Tue, 12 Apr 2022 20:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649797172;
        bh=echZLwx9n6N4PApQtdLZZjGiswUO8NM1Rdbk8m1ciSc=;
        h=Date:To:From:Subject:From;
        b=FewzLynK11mnf043ZgT7rmiaPf00V0WQtwygxAMZ47Nlm3kS+zVBfcwcqCmKIp3T1
         +gO5psgwygAEmCE8hnj0bpbTij96XecbGStSaXWpkic3Czo1nHWYOxSPXZITfTWB2t
         s5G2f1y3/sxXiORFTGOYvB/sFl/DC0J0EHHEu7FI=
Date:   Tue, 12 Apr 2022 13:59:31 -0700
To:     mm-commits@vger.kernel.org, surenb@google.com,
        stable@vger.kernel.org, rppt@linux.ibm.com,
        anshuman.khandual@arm.com, quic_sudaraja@quicinc.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-check-pfn-is-valid-before-moving-to-freelist.patch added to -mm tree
Message-Id: <20220412205931.EFE1CC385A5@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: check pfn is valid before moving to freelist
has been added to the -mm tree.  Its filename is
     mm-page_alloc-check-pfn-is-valid-before-moving-to-freelist.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-check-pfn-is-valid-before-moving-to-freelist.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-check-pfn-is-valid-before-moving-to-freelist.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sudarshan Rajagopalan <quic_sudaraja@quicinc.com>
Subject: mm, page_alloc: check pfn is valid before moving to freelist

Check if pfn is valid before or not before moving it to freelist.

There are possible scenario where a pageblock can have partial physical
hole and partial part of System RAM.  This happens when base address in
RAM partition table is not aligned to pageblock size.

Example:

Say we have this first two entries in RAM partition table -

Base Addr: 0x0000000080000000 Length: 0x0000000058000000
Base Addr: 0x00000000E3930000 Length: 0x0000000020000000
...

Physical hole: 0xD8000000 - 0xE3930000

On system having 4K as page size and hence pageblock size being 4MB, the
base address 0xE3930000 is not aligned to 4MB pageblock size.

Now we will have pageblock which has partial physical hole and partial part
of System RAM -

Pageblock [0xE3800000 - 0xE3C00000] -
	0xE3800000 - 0xE3930000 -- physical hole
	0xE3930000 - 0xE3C00000 -- System RAM

Now doing __alloc_pages say we get a valid page with PFN 0xE3B00 from
__rmqueue_fallback, we try to put other pages from the same pageblock as well
into freelist by calling steal_suitable_fallback().

We then search for freepages from start of the pageblock due to below code -

 move_freepages_block(zone, page, migratetype, ...)
{
    pfn = page_to_pfn(page);
    start_pfn = pfn & ~(pageblock_nr_pages - 1);
    end_pfn = start_pfn + pageblock_nr_pages - 1;
...
}

With the pageblock which has partial physical hole at the beginning, we
will run into PFNs from the physical hole whose struct page is not
initialized and is invalid, and system would crash as we operate on
invalid struct page to find out of page is in Buddy or LRU or not

[  107.629453][ T9688] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
[  107.639214][ T9688] Mem abort info:
[  107.642829][ T9688]   ESR = 0x96000006
[  107.646696][ T9688]   EC = 0x25: DABT (current EL), IL = 32 bits
[  107.652878][ T9688]   SET = 0, FnV = 0
[  107.656751][ T9688]   EA = 0, S1PTW = 0
[  107.660705][ T9688]   FSC = 0x06: level 2 translation fault
[  107.666455][ T9688] Data abort info:
[  107.670151][ T9688]   ISV = 0, ISS = 0x00000006
[  107.674827][ T9688]   CM = 0, WnR = 0
[  107.678615][ T9688] user pgtable: 4k pages, 39-bit VAs, pgdp=000000098a237000
[  107.685970][ T9688] [0000000000000000] pgd=0800000987170003, p4d=0800000987170003, pud=0800000987170003, pmd=0000000000000000
[  107.697582][ T9688] Internal error: Oops: 96000006 [#1] PREEMPT SMP

[  108.209839][ T9688] pc : move_freepages_block+0x174/0x27c
[  108.215407][ T9688] lr : steal_suitable_fallback+0x20c/0x398

[  108.305908][ T9688] Call trace:
[  108.309151][ T9688]  move_freepages_block+0x174/0x27c        [PageLRU]
[  108.314359][ T9688]  steal_suitable_fallback+0x20c/0x398
[  108.319826][ T9688]  rmqueue_bulk+0x250/0x934
[  108.324325][ T9688]  rmqueue_pcplist+0x178/0x2ac
[  108.329086][ T9688]  rmqueue+0x5c/0xc10
[  108.333048][ T9688]  get_page_from_freelist+0x19c/0x430
[  108.338430][ T9688]  __alloc_pages+0x134/0x424
[  108.343017][ T9688]  page_cache_ra_unbounded+0x120/0x324
[  108.348494][ T9688]  do_sync_mmap_readahead+0x1b0/0x234
[  108.353878][ T9688]  filemap_fault+0xe0/0x4c8
[  108.358375][ T9688]  do_fault+0x168/0x6cc
[  108.362518][ T9688]  handle_mm_fault+0x5c4/0x848
[  108.367280][ T9688]  do_page_fault+0x3fc/0x5d0
[  108.371867][ T9688]  do_translation_fault+0x6c/0x1b0
[  108.376985][ T9688]  do_mem_abort+0x68/0x10c
[  108.381389][ T9688]  el0_ia+0x50/0xbc
[  108.385175][ T9688]  el0t_32_sync_handler+0x88/0xbc
[  108.390208][ T9688]  el0t_32_sync+0x1b8/0x1bc

Hence, avoid operating on invalid pages within the same pageblock by
checking if pfn is valid or not.

Link: https://lkml.kernel.org/r/fb3c8c008994b2ed96f74b6b9698ff998b689bd2.1649794059.git.quic_sudaraja@quicinc.com
Signed-off-by: Sudarshan Rajagopalan <quic_sudaraja@quicinc.com>
Fixes: 859a85ddf90e7140 ("mm: remove pfn_valid_within() and CONFIG_HOLES_IN_ZONE")
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/page_alloc.c~mm-page_alloc-check-pfn-is-valid-before-moving-to-freelist
+++ a/mm/page_alloc.c
@@ -2521,6 +2521,11 @@ static int move_freepages(struct zone *z
 	int pages_moved = 0;
 
 	for (pfn = start_pfn; pfn <= end_pfn;) {
+		if (!pfn_valid(pfn)) {
+			pfn++;
+			continue;
+		}
+
 		page = pfn_to_page(pfn);
 		if (!PageBuddy(page)) {
 			/*
_

Patches currently in -mm which might be from quic_sudaraja@quicinc.com are

mm-page_alloc-check-pfn-is-valid-before-moving-to-freelist.patch

