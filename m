Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0A3231EDF7
	for <lists+stable@lfdr.de>; Thu, 18 Feb 2021 19:06:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbhBRSFX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Feb 2021 13:05:23 -0500
Received: from mx2.suse.de ([195.135.220.15]:53732 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234560AbhBRRng (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Feb 2021 12:43:36 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A15FFAE03;
        Thu, 18 Feb 2021 17:42:46 +0000 (UTC)
Subject: Re: [PATCH] mm, compaction: make fast_isolate_freepages() stay within
 zone
To:     linux-mm@kvack.org, Mel Gorman <mgorman@techsingularity.net>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Michal Hocko <mhocko@kernel.org>,
        Mike Rapoport <rppt@kernel.org>, stable@vger.kernel.org,
        Qian Cai <cai@lca.pw>, David Rientjes <rientjes@google.com>
References: <20210217173300.6394-1-vbabka@suse.cz>
From:   Vlastimil Babka <vbabka@suse.cz>
Message-ID: <17a70bb4-5f61-d462-d722-cef8e1010351@suse.cz>
Date:   Thu, 18 Feb 2021 18:42:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210217173300.6394-1-vbabka@suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/17/21 6:33 PM, Vlastimil Babka wrote:
> Compaction always operates on pages from a single given zone when isolating
> both pages to migrate and freepages. Pageblock boundaries are intersected with
> zone boundaries to be safe in case zone starts or ends in the middle of
> pageblock. The use of pageblock_pfn_to_page() protects against non-contiguous
> pageblocks.
> 
> The functions fast_isolate_freepages() and fast_isolate_around() don't
> currently protect the fast freepage isolation thoroughly enough against these
> corner cases, and can result in freepage isolation operate outside of zone
> boundaries:
> 
> - in fast_isolate_freepages() if we get a pfn from the first pageblock of a
>   zone that starts in the middle of that pageblock, 'highest' can be a pfn
>   outside of the zone. If we fail to isolate anything in this function, we
>   may then call fast_isolate_around() on a pfn outside of the zone and there
>   effectively do a set_pageblock_skip(page_to_pfn(highest)) which may currently
>   hit a VM_BUG_ON() in some configurations
> - fast_isolate_around() checks only the zone end boundary and not beginning,
>   nor that the pageblock is contiguous (with pageblock_pfn_to_page()) so it's
>   possible that we end up calling isolate_freepages_block() on a range of pfn's
>   from two different zones and end up e.g. isolating freepages under the wrong
>   zone's lock.
> 
> This patch should fix the above issues.

Sorry, totally forgot these:

Reported-by: Qian Cai <cai@lca.pw>
Reported-by: Andrea Arcangeli <aarcange@redhat.com>

> Fixes: 5a811889de10 ("mm, compaction: use free lists to quickly locate a migration target")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Also thanks David and Mel for the acks!

Thanks to Mike I was able to boot v5.11 in qemu with memmap containing a type 20
hole as Andrea reported, but can't reproduce the bug so far (i.e. without this
patch, with DEBUG_VM enabled) using transhuge-stress; might need some more
nuanced workload...
