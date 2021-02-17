Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF49331D961
	for <lists+stable@lfdr.de>; Wed, 17 Feb 2021 13:28:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231889AbhBQM2V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Feb 2021 07:28:21 -0500
Received: from mx2.suse.de ([195.135.220.15]:57804 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230473AbhBQM2U (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Feb 2021 07:28:20 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id C95DAB9D4;
        Wed, 17 Feb 2021 12:27:38 +0000 (UTC)
To:     Mike Rapoport <rppt@kernel.org>
Cc:     Michal Hocko <mhocko@suse.com>, Mel Gorman <mgorman@suse.de>,
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
References: <e5ce315f-64f7-75e3-b587-ad0062d5902c@redhat.com>
 <YCaAHI/rFp1upRLc@dhcp22.suse.cz> <20210214180016.GO242749@kernel.org>
 <YCo4Lyio1h2Heixh@dhcp22.suse.cz> <20210215212440.GA1307762@kernel.org>
 <YCuDUG89KwQNbsjA@dhcp22.suse.cz> <20210216110154.GB1307762@kernel.org>
 <b1302d8e-5380-18d1-0f55-2dfd61f470e6@suse.cz>
 <YCvEeWuU2tBUUNBG@dhcp22.suse.cz>
 <caeebbcc-b6c9-624b-3eeb-591bf59f28a6@suse.cz>
 <20210216174914.GD1307762@kernel.org>
From:   Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH v5 1/1] mm: refactor initialization of struct page for
 holes in memory layout
Message-ID: <0255912b-19af-e8fc-9a04-06a519287716@suse.cz>
Date:   Wed, 17 Feb 2021 13:27:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210216174914.GD1307762@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/16/21 6:49 PM, Mike Rapoport wrote:
> Hi Vlastimil,
> 
> On Tue, Feb 16, 2021 at 05:39:12PM +0100, Vlastimil Babka wrote:
>> 
>> 
>> So, Andrea could you please check if this fixes the original
>> fast_isolate_around() issue for you? With the VM_BUG_ON not removed, DEBUG_VM
>> enabled, no changes to struct page initialization...
>> It relies on pageblock_pfn_to_page as the rest of the compaction code.
> 
> Pardon my ignorance of compaction internals, but does this mean that with
> your patch we'll never call set_pfnblock_flags_mask() for a pfn in a hole?

No it doesn't mean that kind of guarantee. But we will not call it anymore (if
my patch is correct) from a path which we currently know it's doing that and
triggering the VM_BUG_ON. So that's a targetted fix that matches stable backport
criteria. It doesn't contradict your patch as a way to improve mainline, I still
agree it's best long-term if we initialize the struct pages without such
surprises. But I also agree with Michal that there's a risk of replacing one
corner case with another and thus we shouldn't do that as a stable fix.
