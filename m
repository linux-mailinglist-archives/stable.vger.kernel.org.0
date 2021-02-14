Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E32CD31B18D
	for <lists+stable@lfdr.de>; Sun, 14 Feb 2021 18:29:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbhBNR37 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Feb 2021 12:29:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:49562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229759AbhBNR36 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 14 Feb 2021 12:29:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F4D064E08;
        Sun, 14 Feb 2021 17:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613323757;
        bh=Jg/hxcmrt1OLpohmuaNMK3aXYRGAXzsF42r6hglIF5s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UsGftF9PDGm67w/5WT5j8t9iMoWYfNaHNsd5R6HJFCxy0YVyqILNCEKKf+d7cOYj7
         RcW4fl3ClLfNcL/105tTwVg5ULS4lTZfmul2g5sDYU1SZZkaxg4gPI/cO+EgQSjEXZ
         NABBFOxxa9NirbHNGN9B2GeXGwBBiHd1OjbLAWVABjXfUihVIaktXF6VYqAxOMGbQJ
         JJavbprWtSxWSQzG33x3pZMRpH504tAJpRkhTNBU53HXgtFJqoyFVOD4P7upxSqexG
         T/JwZ8eIn+HFTDki9X1mCfZFeMJwWwJArgd2wmDwdZBDzqIEj3paOekTgAXD7oJMsx
         G0Gxbav60HoZg==
Date:   Sun, 14 Feb 2021 19:29:06 +0200
From:   Mike Rapoport <rppt@kernel.org>
To:     David Hildenbrand <david@redhat.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Baoquan He <bhe@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        =?utf-8?Q?=C5=81ukasz?= Majczak <lma@semihalf.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@kernel.org>,
        Mike Rapoport <rppt@linux.ibm.com>, Qian Cai <cai@lca.pw>,
        "Sarvela, Tomi P" <tomi.p.sarvela@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, stable@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v5 1/1] mm: refactor initialization of struct page for
 holes in memory layout
Message-ID: <20210214172906.GN242749@kernel.org>
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

On Fri, Feb 12, 2021 at 10:56:19AM +0100, David Hildenbrand wrote:
> On 12.02.21 10:55, David Hildenbrand wrote:
> > On 08.02.21 12:08, Mike Rapoport wrote:
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
> 
> > starts in the middle of a section and the other one ends in the middle
> > of a section?
> 
> > Could it be a problem? (e.g., would we have to look at neighboring nodes
> > when making the decision to extend, and how far to extend?)

Having a node end/start in a middle of a section would be a problem, but in
this case I don't see a way to detect how a node should be extended :(

We can return to a v4 [1] without x86 modifications.
With that we'll have struct pages corresponding to a hole in a middle of a
zone with correct zone link and a good guess for the node.

As for the pfn 0 on x86, it'll remain outside any node and zone, but since
it was the case since, like forever, I think we can live with it.

[1] https://lore.kernel.org/lkml/20210130221035.4169-1-rppt@kernel.org

-- 
Sincerely yours,
Mike.
