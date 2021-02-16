Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA8031CE3B
	for <lists+stable@lfdr.de>; Tue, 16 Feb 2021 17:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbhBPQj7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Feb 2021 11:39:59 -0500
Received: from mx2.suse.de ([195.135.220.15]:48438 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229764AbhBPQjz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Feb 2021 11:39:55 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 8B82FAB4C;
        Tue, 16 Feb 2021 16:39:13 +0000 (UTC)
Subject: Re: [PATCH v5 1/1] mm: refactor initialization of struct page for
 holes in memory layout
To:     Michal Hocko <mhocko@suse.com>
Cc:     Mike Rapoport <rppt@kernel.org>, Mel Gorman <mgorman@suse.de>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Baoquan He <bhe@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        =?UTF-8?Q?=c5=81ukasz_Majczak?= <lma@semihalf.com>,
        Mike Rapoport <rppt@linux.ibm.com>, Qian Cai <cai@lca.pw>,
        "Sarvela, Tomi P" <tomi.p.sarvela@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org, x86@kernel.org
References: <20210208110820.6269-1-rppt@kernel.org>
 <YCZZeAAC8VOCPhpU@dhcp22.suse.cz>
 <e5ce315f-64f7-75e3-b587-ad0062d5902c@redhat.com>
 <YCaAHI/rFp1upRLc@dhcp22.suse.cz> <20210214180016.GO242749@kernel.org>
 <YCo4Lyio1h2Heixh@dhcp22.suse.cz> <20210215212440.GA1307762@kernel.org>
 <YCuDUG89KwQNbsjA@dhcp22.suse.cz> <20210216110154.GB1307762@kernel.org>
 <b1302d8e-5380-18d1-0f55-2dfd61f470e6@suse.cz>
 <YCvEeWuU2tBUUNBG@dhcp22.suse.cz>
From:   Vlastimil Babka <vbabka@suse.cz>
Message-ID: <caeebbcc-b6c9-624b-3eeb-591bf59f28a6@suse.cz>
Date:   Tue, 16 Feb 2021 17:39:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YCvEeWuU2tBUUNBG@dhcp22.suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 2/16/21 2:11 PM, Michal Hocko wrote:
> On Tue 16-02-21 13:34:56, Vlastimil Babka wrote:
>> On 2/16/21 12:01 PM, Mike Rapoport wrote:
>> >> 
>> >> I do understand that. And I am not objecting to the patch. I have to
>> >> confess I haven't digested it yet. Any changes to early memory
>> >> intialization have turned out to be subtle and corner cases only pop up
>> >> later. This is almost impossible to review just by reading the code.
>> >> That's why I am asking whether we want to address the specific VM_BUG_ON
>> >> first with something much less tricky and actually reviewable. And
>> >> that's why I am asking whether dropping the bug_on itself is safe to do
>> >> and use as a hot fix which should be easier to backport.
>> > 
>> > I can't say I'm familiar enough with migration and compaction code to say
>> > if it's ok to remove that bug_on. It does point to inconsistency in the
>> > memmap, but probably it's not important.
>> 
>> On closer look, removing the VM_BUG_ON_PAGE() in set_pfnblock_flags_mask() is
>> not safe. If we violate the zone_spans_pfn condition, it means we will write
>> outside of the pageblock bitmap for the zone, and corrupt something.
> 
> Isn't it enough that at least some pfn from the pageblock belongs to the
> zone in order to have the bitmap allocated for the whole page block
> (even if it partially belongs to a different zone)?
> 
>> Actually
>> similar thing can happen in __get_pfnblock_flags_mask() where there's no
>> VM_BUG_ON, but there we can't corrupt memory. But we could theoretically fault
>> to do accessing some unmapped range?
>> 
>> So the checks would have to become unconditional !DEBUG_VM and return instead of
>> causing a BUG. Or we could go back one level and add some checks to
>> fast_isolate_around() to detect a page from zone that doesn't match cc->zone.
> 
> Thanks for looking deeper into that. This sounds like a much more
> targeted fix to me.

So, Andrea could you please check if this fixes the original
fast_isolate_around() issue for you? With the VM_BUG_ON not removed, DEBUG_VM
enabled, no changes to struct page initialization...
It relies on pageblock_pfn_to_page as the rest of the compaction code.

Thanks!

----8<----
From f5c8d7bc77d2ec0b4cfec44820ce6f602fdb3a86 Mon Sep 17 00:00:00 2001
From: Vlastimil Babka <vbabka@suse.cz>
Date: Tue, 16 Feb 2021 17:32:34 +0100
Subject: [PATCH] mm, compaction: make fast_isolate_around() robust against
 pfns from a wrong zone

TBD

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/compaction.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 190ccdaa6c19..b75645e4678d 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1288,7 +1288,7 @@ static void
 fast_isolate_around(struct compact_control *cc, unsigned long pfn, unsigned long nr_isolated)
 {
 	unsigned long start_pfn, end_pfn;
-	struct page *page = pfn_to_page(pfn);
+	struct page *page;
 
 	/* Do not search around if there are enough pages already */
 	if (cc->nr_freepages >= cc->nr_migratepages)
@@ -1300,7 +1300,11 @@ fast_isolate_around(struct compact_control *cc, unsigned long pfn, unsigned long
 
 	/* Pageblock boundaries */
 	start_pfn = pageblock_start_pfn(pfn);
-	end_pfn = min(pageblock_end_pfn(pfn), zone_end_pfn(cc->zone)) - 1;
+	end_pfn = min(pageblock_end_pfn(pfn), zone_end_pfn(cc->zone));
+
+	page = pageblock_pfn_to_page(start_pfn, end_pfn, cc->zone);
+	if (!page)
+		return;
 
 	/* Scan before */
 	if (start_pfn != pfn) {
@@ -1486,7 +1490,7 @@ fast_isolate_freepages(struct compact_control *cc)
 	}
 
 	cc->total_free_scanned += nr_scanned;
-	if (!page)
+	if (!page || page_zone(page) != cc->zone)
 		return cc->free_pfn;
 
 	low_pfn = page_to_pfn(page);
-- 
2.30.0

