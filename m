Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1758D319CC1
	for <lists+stable@lfdr.de>; Fri, 12 Feb 2021 11:41:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbhBLKjX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Feb 2021 05:39:23 -0500
Received: from mx2.suse.de ([195.135.220.15]:45978 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230383AbhBLKil (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Feb 2021 05:38:41 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1613126274; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CEZkfyq7c0HGgwSW7w7T0gscG26D0F30UkRDuR38AsM=;
        b=dWPfd+mQe25awJB+EwHVl+CPT6wfHtjfT4jfw4ayvaNY+WkkW1/DRjat0T5oGQUVK6Xidl
        ehyPrjAWVV4C7MI+WRShrEF5eOQXUwNWDXr4cAGvg5BixsppQUF0Ui7KnbyW37avrYllQj
        teHwKiCW+k6lxA59/cJR50DLxKPZX18=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 36AE9AD62;
        Fri, 12 Feb 2021 10:37:54 +0000 (UTC)
Date:   Fri, 12 Feb 2021 11:37:53 +0100
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
Message-ID: <YCZagVNiYz/mRl+2@dhcp22.suse.cz>
References: <20210208110820.6269-1-rppt@kernel.org>
 <5dccbc93-f260-7f14-23bc-6dee2dff6c13@redhat.com>
 <a6cf3a26-a174-abab-a5a0-6cf89ebe4af7@redhat.com>
 <YCZUOf0jGyWx0IwL@dhcp22.suse.cz>
 <1523f1a6-41be-1fc7-08b9-b777a5b4ef24@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1523f1a6-41be-1fc7-08b9-b777a5b4ef24@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri 12-02-21 11:16:28, David Hildenbrand wrote:
> On 12.02.21 11:11, Michal Hocko wrote:
> > On Fri 12-02-21 10:56:19, David Hildenbrand wrote:
> > > On 12.02.21 10:55, David Hildenbrand wrote:
> > > > On 08.02.21 12:08, Mike Rapoport wrote:
> > [...]
> > > > > @@ -6519,8 +6581,19 @@ void __init get_pfn_range_for_nid(unsigned int nid,
> > > > >     		*end_pfn = max(*end_pfn, this_end_pfn);
> > > > >     	}
> > > > > -	if (*start_pfn == -1UL)
> > > > > +	if (*start_pfn == -1UL) {
> > > > >     		*start_pfn = 0;
> > > > > +		return;
> > > > > +	}
> > > > > +
> > > > > +#ifdef CONFIG_SPARSEMEM
> > > > > +	/*
> > > > > +	 * Sections in the memory map may not match actual populated
> > > > > +	 * memory, extend the node span to cover the entire section.
> > > > > +	 */
> > > > > +	*start_pfn = round_down(*start_pfn, PAGES_PER_SECTION);
> > > > > +	*end_pfn = round_up(*end_pfn, PAGES_PER_SECTION);
> > > > 
> > > > Does that mean that we might create overlapping zones when one node
> > > 
> > > s/overlapping zones/overlapping nodes/
> > 
> > I didn't get to review the patch yet. Just wanted to note that we can
> > interleave nodes/zone. Or what kind of concern do you have in mind?
> 
> I know that we can have it after boot, when hotplugging memory. How about
> during boot?

I have seen systems where NUMA nodes are interleaved.

> For example, which node will a PFN then actually be assigned to?

I would have to double check all the details but I do remember there was
a non trivial work to handle those systems.
-- 
Michal Hocko
SUSE Labs
