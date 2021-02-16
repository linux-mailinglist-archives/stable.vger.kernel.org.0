Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD5CD31C94F
	for <lists+stable@lfdr.de>; Tue, 16 Feb 2021 12:06:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbhBPLEt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Feb 2021 06:04:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:35064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230122AbhBPLCp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Feb 2021 06:02:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A6D764DEC;
        Tue, 16 Feb 2021 11:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613473324;
        bh=F9xS1rR+waUJ6pldremMhnydAS8IhLLyVoVwmU9feZM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DJ8O/kceVbOPBGlphi7x/GCt71EML56KNwx3aC184oMuvDHgyx2XLbCw2gSwklC1D
         AT7r1daEX9eX6N8JOf3BrtEU9YwaZ5JqyUeNdFvCk72bagPLlg8oFL1d/k8xeCGL7g
         F0Ohy2EX8C5jkRN7+cPLp4xb+bsUzYBdPWS/wPkzUFCp2Alm10EesU+YjrW/VzvS7b
         CI+hxb/RIajRftxZygXPZlb8eME/FU2rCWrSHwW3S4F2YpWDftudZt3M5BfLHg+OVe
         tSsoa9qoMmN4anSUaCBkFL/TufuHjWldKfBtksVGXPsGnr6glJn+HoxVfMSrvX5w+T
         t9sm+4iarOqsQ==
Date:   Tue, 16 Feb 2021 13:01:54 +0200
From:   Mike Rapoport <rppt@kernel.org>
To:     Michal Hocko <mhocko@suse.com>
Cc:     Mel Gorman <mgorman@suse.de>, David Hildenbrand <david@redhat.com>,
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
        Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, stable@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v5 1/1] mm: refactor initialization of struct page for
 holes in memory layout
Message-ID: <20210216110154.GB1307762@kernel.org>
References: <20210208110820.6269-1-rppt@kernel.org>
 <YCZZeAAC8VOCPhpU@dhcp22.suse.cz>
 <e5ce315f-64f7-75e3-b587-ad0062d5902c@redhat.com>
 <YCaAHI/rFp1upRLc@dhcp22.suse.cz>
 <20210214180016.GO242749@kernel.org>
 <YCo4Lyio1h2Heixh@dhcp22.suse.cz>
 <20210215212440.GA1307762@kernel.org>
 <YCuDUG89KwQNbsjA@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YCuDUG89KwQNbsjA@dhcp22.suse.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 16, 2021 at 09:33:20AM +0100, Michal Hocko wrote:
> On Mon 15-02-21 23:24:40, Mike Rapoport wrote:
> > On Mon, Feb 15, 2021 at 10:00:31AM +0100, Michal Hocko wrote:
> > > On Sun 14-02-21 20:00:16, Mike Rapoport wrote:
> > > > On Fri, Feb 12, 2021 at 02:18:20PM +0100, Michal Hocko wrote:
> > > 
> > > > We can correctly set the zone links for the reserved pages for holes in the
> > > > middle of a zone based on the architecture constraints and with only the
> > > > holes in the beginning/end of the memory will be not spanned by any
> > > > node/zone which in practice does not seem to be a problem as the VM_BUG_ON
> > > > in set_pfnblock_flags_mask() never triggered on pfn 0.
> > > 
> > > I really fail to see what you mean by correct zone/node for a memory
> > > range which is not associated with any real node.
> > 
> > We know architectural zone constraints, so we can have always have 1:1
> > match from pfn to zone. Node indeed will be a guess.
> 
> That is true only for some zones.

Hmm, and when is it not true?

> Also we do require those to be correct when the memory is managed by the
> page allocator. I believe we can live with incorrect zones when they are
> in holes.
 
Note that the holes Andrea reported in the first place are not ranges that
are not populated, but rather ranges that arch didn't report as usable,
i.e. there is physical memory and it perfectly fits into an existing node
and zone.

> > > > > I am sorry, I haven't followed previous discussions. Has the removal of
> > > > > the VM_BUG_ON been considered as an immediate workaround?
> > > > 
> > > > It was never discussed, but I'm not sure it's a good idea.
> > > > 
> > > > Judging by the commit message that introduced the VM_BUG_ON (commit
> > > > 86051ca5eaf5 ("mm: fix usemap initialization")) there was yet another
> > > > inconsistency in the memory map that required a special care.
> > > 
> > > Can we actually explore that path before adding yet additional
> > > complexity and potentially a very involved fix for a subtle problem?
> > 
> > This patch was intended as a fix for inconsistency of the memory map that
> > is the root cause for triggering this VM_BUG_ON and other corner case
> > problems. 
> > 
> > The previous version [1] is less involved as it does not extend node/zone
> > spans.
> 
> I do understand that. And I am not objecting to the patch. I have to
> confess I haven't digested it yet. Any changes to early memory
> intialization have turned out to be subtle and corner cases only pop up
> later. This is almost impossible to review just by reading the code.
> That's why I am asking whether we want to address the specific VM_BUG_ON
> first with something much less tricky and actually reviewable. And
> that's why I am asking whether dropping the bug_on itself is safe to do
> and use as a hot fix which should be easier to backport.

I can't say I'm familiar enough with migration and compaction code to say
if it's ok to remove that bug_on. It does point to inconsistency in the
memmap, but probably it's not important.
 
-- 
Sincerely yours,
Mike.
