Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 678893261C7
	for <lists+stable@lfdr.de>; Fri, 26 Feb 2021 12:09:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbhBZLIy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Feb 2021 06:08:54 -0500
Received: from mx2.suse.de ([195.135.220.15]:47746 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230165AbhBZLIw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Feb 2021 06:08:52 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 56765AF33;
        Fri, 26 Feb 2021 11:08:10 +0000 (UTC)
Subject: Re: [PATCH v7 1/1] mm/page_alloc.c: refactor initialization of struct
 page for holes in memory layout
To:     Mike Rapoport <rppt@linux.ibm.com>
Cc:     Mike Rapoport <rppt@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Baoquan He <bhe@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        David Hildenbrand <david@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        =?UTF-8?Q?=c5=81ukasz_Majczak?= <lma@semihalf.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@kernel.org>,
        Qian Cai <cai@lca.pw>,
        "Sarvela, Tomi P" <tomi.p.sarvela@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org, x86@kernel.org
References: <20210224153950.20789-1-rppt@kernel.org>
 <20210224153950.20789-2-rppt@kernel.org>
 <a4b2ba7e-96a5-6a75-dad7-626d054f9e8b@suse.cz>
 <20210225180521.GH1854360@linux.ibm.com>
 <a458a933-91c7-9fb5-d7f8-b9a7af93a11c@suse.cz>
 <20210226105900.GK1854360@linux.ibm.com>
From:   Vlastimil Babka <vbabka@suse.cz>
Message-ID: <aeb4aeb9-4ca7-723a-d989-226d537adfb3@suse.cz>
Date:   Fri, 26 Feb 2021 12:08:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210226105900.GK1854360@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/26/21 11:59 AM, Mike Rapoport wrote:
> On Thu, Feb 25, 2021 at 07:38:44PM +0100, Vlastimil Babka wrote:
>> On 2/25/21 7:05 PM, Mike Rapoport wrote:
>> >> 
>> >> What if two zones are adjacent? I.e. if the hole was at a boundary between two
>> >> zones.
>> > 
>> > What do you mean by "adjacent zones"? If there is a hole near the zone
>> > boundary, zone span would be clamped to exclude the hole.
>> 
>> Yeah, zone span should exclude those pages, but you still somehow handle them?
>> That's how I read "pages that are not spanned by any node will get links to the
>> adjacent zone/node."
>> So is it always a unique zone/node can be determined?
>> 
>> Let's say we have:
>> 
>> <memory on node 0>
>> ---- pageblock boundary ----
>> <more memory on node 0>
>> <a hole>
>> <memory on node 1>
>> ---- pageblock boundary ----
>> 
>> Now I hope such configurations don't really exist :) But if we simulated them in
>> QEMU, what would be the linkage in struct pages in that hole?
> 
> I don't think such configuration is possible in practice but it can be
> forced with e.g memmap="2M hole at 4G - 1M".

Right.

> The hole in your example the hole will get node1 for node and zone that
> spans the beginning of node1 for zone.

Yeah the comments in v8 make that clear now, thanks!

