Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 850C8319C68
	for <lists+stable@lfdr.de>; Fri, 12 Feb 2021 11:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbhBLKL4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Feb 2021 05:11:56 -0500
Received: from mx2.suse.de ([195.135.220.15]:44622 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229948AbhBLKLx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Feb 2021 05:11:53 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1613124666; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oyySMBM6VdigTL9j5eqbCLhS/R0Ql/YiJi2owvKug4w=;
        b=BjrSeaVaW2gwYyzIRdDR/cKkRycWDBgXGXAhbgQ/wu5fwnF611jaqJ8gXXYm988rn4e0NS
        pOEyQdBawm4RRlD0BZ6JEzYBwge0pg7f6atRTzR79Av9IaAauY4g+k+Srsak3akTEYDS5R
        qLY44RJdi7RynByaatgsbf1tFg5l6Xg=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 7B24CB807;
        Fri, 12 Feb 2021 10:11:06 +0000 (UTC)
Date:   Fri, 12 Feb 2021 11:11:05 +0100
From:   Michal Hocko <mhocko@suse.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Mike Rapoport <rppt@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Baoquan He <bhe@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        =?utf-8?Q?=C5=81ukasz?= Majczak <lma@semihalf.com>,
        Mel Gorman <mgorman@suse.de>,
        Mike Rapoport <rppt@linux.ibm.com>, Qian Cai <cai@lca.pw>,
        "Sarvela, Tomi P" <tomi.p.sarvela@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, stable@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v5 1/1] mm: refactor initialization of struct page for
 holes in memory layout
Message-ID: <YCZUOf0jGyWx0IwL@dhcp22.suse.cz>
References: <20210208110820.6269-1-rppt@kernel.org>
 <5dccbc93-f260-7f14-23bc-6dee2dff6c13@redhat.com>
 <a6cf3a26-a174-abab-a5a0-6cf89ebe4af7@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a6cf3a26-a174-abab-a5a0-6cf89ebe4af7@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri 12-02-21 10:56:19, David Hildenbrand wrote:
> On 12.02.21 10:55, David Hildenbrand wrote:
> > On 08.02.21 12:08, Mike Rapoport wrote:
[...]
> > > @@ -6519,8 +6581,19 @@ void __init get_pfn_range_for_nid(unsigned int nid,
> > >    		*end_pfn = max(*end_pfn, this_end_pfn);
> > >    	}
> > > -	if (*start_pfn == -1UL)
> > > +	if (*start_pfn == -1UL) {
> > >    		*start_pfn = 0;
> > > +		return;
> > > +	}
> > > +
> > > +#ifdef CONFIG_SPARSEMEM
> > > +	/*
> > > +	 * Sections in the memory map may not match actual populated
> > > +	 * memory, extend the node span to cover the entire section.
> > > +	 */
> > > +	*start_pfn = round_down(*start_pfn, PAGES_PER_SECTION);
> > > +	*end_pfn = round_up(*end_pfn, PAGES_PER_SECTION);
> > 
> > Does that mean that we might create overlapping zones when one node
> 
> s/overlapping zones/overlapping nodes/

I didn't get to review the patch yet. Just wanted to note that we can
interleave nodes/zone. Or what kind of concern do you have in mind?

-- 
Michal Hocko
SUSE Labs
