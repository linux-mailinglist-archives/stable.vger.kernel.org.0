Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF63931CAE4
	for <lists+stable@lfdr.de>; Tue, 16 Feb 2021 14:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbhBPNMM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Feb 2021 08:12:12 -0500
Received: from mx2.suse.de ([195.135.220.15]:46888 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229802AbhBPNMK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Feb 2021 08:12:10 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1613481083; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Tu/09opR+rOaWunzc6yzJsQqaBcSy0Wetier3xAJdn4=;
        b=pwG37zROGA+8faCWLvy+Mf8FosYPMk8/PJ8dt1dtBwllWesrisk2vfB4D5gXvqF0weUMJj
        zIvbNC31ZflpX/m7QJRpotSmwfUnQQy11rAmmFdlGS733eAW1d4ax98IvmiEwD84RsGhGV
        v03nCahzJJXdkQMef0yVo4JjkmuO3r4=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1AA64AF2C;
        Tue, 16 Feb 2021 13:11:23 +0000 (UTC)
Date:   Tue, 16 Feb 2021 14:11:21 +0100
From:   Michal Hocko <mhocko@suse.com>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Mike Rapoport <rppt@kernel.org>, Mel Gorman <mgorman@suse.de>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Baoquan He <bhe@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        =?utf-8?Q?=C5=81ukasz?= Majczak <lma@semihalf.com>,
        Mike Rapoport <rppt@linux.ibm.com>, Qian Cai <cai@lca.pw>,
        "Sarvela, Tomi P" <tomi.p.sarvela@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v5 1/1] mm: refactor initialization of struct page for
 holes in memory layout
Message-ID: <YCvEeWuU2tBUUNBG@dhcp22.suse.cz>
References: <20210208110820.6269-1-rppt@kernel.org>
 <YCZZeAAC8VOCPhpU@dhcp22.suse.cz>
 <e5ce315f-64f7-75e3-b587-ad0062d5902c@redhat.com>
 <YCaAHI/rFp1upRLc@dhcp22.suse.cz>
 <20210214180016.GO242749@kernel.org>
 <YCo4Lyio1h2Heixh@dhcp22.suse.cz>
 <20210215212440.GA1307762@kernel.org>
 <YCuDUG89KwQNbsjA@dhcp22.suse.cz>
 <20210216110154.GB1307762@kernel.org>
 <b1302d8e-5380-18d1-0f55-2dfd61f470e6@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b1302d8e-5380-18d1-0f55-2dfd61f470e6@suse.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 16-02-21 13:34:56, Vlastimil Babka wrote:
> On 2/16/21 12:01 PM, Mike Rapoport wrote:
> >> 
> >> I do understand that. And I am not objecting to the patch. I have to
> >> confess I haven't digested it yet. Any changes to early memory
> >> intialization have turned out to be subtle and corner cases only pop up
> >> later. This is almost impossible to review just by reading the code.
> >> That's why I am asking whether we want to address the specific VM_BUG_ON
> >> first with something much less tricky and actually reviewable. And
> >> that's why I am asking whether dropping the bug_on itself is safe to do
> >> and use as a hot fix which should be easier to backport.
> > 
> > I can't say I'm familiar enough with migration and compaction code to say
> > if it's ok to remove that bug_on. It does point to inconsistency in the
> > memmap, but probably it's not important.
> 
> On closer look, removing the VM_BUG_ON_PAGE() in set_pfnblock_flags_mask() is
> not safe. If we violate the zone_spans_pfn condition, it means we will write
> outside of the pageblock bitmap for the zone, and corrupt something.

Isn't it enough that at least some pfn from the pageblock belongs to the
zone in order to have the bitmap allocated for the whole page block
(even if it partially belongs to a different zone)?

> Actually
> similar thing can happen in __get_pfnblock_flags_mask() where there's no
> VM_BUG_ON, but there we can't corrupt memory. But we could theoretically fault
> to do accessing some unmapped range?
> 
> So the checks would have to become unconditional !DEBUG_VM and return instead of
> causing a BUG. Or we could go back one level and add some checks to
> fast_isolate_around() to detect a page from zone that doesn't match cc->zone.

Thanks for looking deeper into that. This sounds like a much more
targeted fix to me.

> The question is if there is another code that will break if a page_zone()
> suddenly changes e.g. in the middle of the pageblock - __pageblock_pfn_to_page()
> assumes that if first and last page is from the same zone, so are all pages in
> between, and the rest relies on that. But maybe if Andrea's
> fast_isolate_around() issue is fixed, that's enough for stable backport.

There might be some other cases but I think it would be better to have a
single fix for this particular issue and have it fixed properly and only
then build something more robust on top.
-- 
Michal Hocko
SUSE Labs
