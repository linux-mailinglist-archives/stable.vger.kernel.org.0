Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48A9D31B61E
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 10:04:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbhBOJBZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 04:01:25 -0500
Received: from mx2.suse.de ([195.135.220.15]:50006 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229783AbhBOJBY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 04:01:24 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1613379637; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZQWJ8QEjpLvqVVRPY5L/a3kejC8e54tG2MpJnL0Ffzc=;
        b=SzyiVD+4a++QK/wfXH2nED0hIs8vUHBhLAtgznr4BTzH0zaEV6BzZC+8MgJNWMnaw4QDLy
        tlNHAFzPgQ7ii+qV0vpKS/pRjU5ZFmHvzYZKRvhy4uFBd7zfJnG4yqbpoXzpxX4L0+RExX
        NlcHpldaXyaRwVp4zdvixsz2TG8fFUU=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 3B38DAE76;
        Mon, 15 Feb 2021 09:00:37 +0000 (UTC)
Date:   Mon, 15 Feb 2021 10:00:31 +0100
From:   Michal Hocko <mhocko@suse.com>
To:     Mike Rapoport <rppt@kernel.org>, Mel Gorman <mgorman@suse.de>
Cc:     David Hildenbrand <david@redhat.com>,
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
Message-ID: <YCo4Lyio1h2Heixh@dhcp22.suse.cz>
References: <20210208110820.6269-1-rppt@kernel.org>
 <YCZZeAAC8VOCPhpU@dhcp22.suse.cz>
 <e5ce315f-64f7-75e3-b587-ad0062d5902c@redhat.com>
 <YCaAHI/rFp1upRLc@dhcp22.suse.cz>
 <20210214180016.GO242749@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210214180016.GO242749@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun 14-02-21 20:00:16, Mike Rapoport wrote:
> On Fri, Feb 12, 2021 at 02:18:20PM +0100, Michal Hocko wrote:
> > On Fri 12-02-21 11:42:15, David Hildenbrand wrote:
> > > On 12.02.21 11:33, Michal Hocko wrote:
> > [...]
> > > > I have to digest this but my first impression is that this is more heavy
> > > > weight than it needs to. Pfn walkers should normally obey node range at
> > > > least. The first pfn is usually excluded but I haven't seen real
> > > 
> > > We've seen examples where this is not sufficient. Simple example:
> > > 
> > > Have your physical memory end within a memory section. Easy via QEMU, just
> > > do a "-m 4000M". The remaining part of the last section has fake/wrong
> > > node/zone info.
> > 
> > Does this really matter though. If those pages are reserved then nobody
> > will touch them regardless of their node/zone ids.
> >
> > > Hotplug memory. The node/zone gets resized such that PFN walkers might
> > > stumble over it.
> > > 
> > > The basic idea is to make sure that any initialized/"online" pfn belongs to
> > > exactly one node/zone and that the node/zone spans that PFN.
> > 
> > Yeah, this sounds like a good idea but what is the poper node for hole
> > between two ranges associated with a different nodes/zones? This will
> > always be a random number. We should have a clear way to tell "do not
> > touch those pages" and PageReserved sounds like a good way to tell that.
>  
> Nobody should touch reserved pages, but I don't think we can ensure that.

Touching a reserved page which doesn't belong to you is a bug. Sure we
cannot enforce that rule by runtime checks. But incorrect/misleading zone/node 
association is the least of the problem when somebody already does that.

> We can correctly set the zone links for the reserved pages for holes in the
> middle of a zone based on the architecture constraints and with only the
> holes in the beginning/end of the memory will be not spanned by any
> node/zone which in practice does not seem to be a problem as the VM_BUG_ON
> in set_pfnblock_flags_mask() never triggered on pfn 0.

I really fail to see what you mean by correct zone/node for a memory
range which is not associated with any real node.
 
> I believe that any improvement in memory map consistency is a step forward.

I do agree but we are talking about a subtle bug (VM_BUG_ON) which would
be better of with a simplistic fix first. You can work on consistency
improvements on top of that.

> > > > problems with that. The VM_BUG_ON blowing up is really bad but as said
> > > > above we can simply make it less offensive in presence of reserved pages
> > > > as those shouldn't reach that path AFAICS normally.
> > > 
> > > Andrea tried tried working around if via PG_reserved pages and it resulted
> > > in quite some ugly code. Andrea also noted that we cannot rely on any random
> > > page walker to do the right think when it comes to messed up node/zone info.
> > 
> > I am sorry, I haven't followed previous discussions. Has the removal of
> > the VM_BUG_ON been considered as an immediate workaround?
> 
> It was never discussed, but I'm not sure it's a good idea.
> 
> Judging by the commit message that introduced the VM_BUG_ON (commit
> 86051ca5eaf5 ("mm: fix usemap initialization")) there was yet another
> inconsistency in the memory map that required a special care.

Can we actually explore that path before adding yet additional
complexity and potentially a very involved fix for a subtle problem?

Mel who is author of this code might help us out. I have to say I do not
see the point for the VM_BUG_ON other than a better debuggability. If
there is a real incosistency problem as a result then we should be
handling that situation for non debugging kernels as well.
-- 
Michal Hocko
SUSE Labs
