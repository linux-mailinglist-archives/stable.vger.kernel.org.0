Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 017746899EB
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 14:41:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232075AbjBCNk7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 08:40:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231478AbjBCNk7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 08:40:59 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98E44D53F;
        Fri,  3 Feb 2023 05:40:57 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 47B6020E35;
        Fri,  3 Feb 2023 13:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1675431656; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tY5edR91yzo/JtbvHeQc/omNEXLCescxC3sbLjJzUk4=;
        b=qcmucqr6byPGYqRE8EiCPiPdWai+MGsFAUXL7NvhdbLTyngY9UK7+TuwqeEAWt3XOtFxp/
        r1yDjFhQ10f2PFTdFL3KQgFNY3zidsK8NZS1rgX9Ff46yTSBWqNo3/lut30TRXyQ6VLGVY
        2cx4dW0XnwnzOdVCVoLAA71/mmyR+FM=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1D9801346D;
        Fri,  3 Feb 2023 13:40:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id b15NBOgO3WMmCgAAMHmgww
        (envelope-from <mhocko@suse.com>); Fri, 03 Feb 2023 13:40:56 +0000
Date:   Fri, 3 Feb 2023 14:40:55 +0100
From:   Michal Hocko <mhocko@suse.com>
To:     Mike Kravetz <mike.kravetz@oracle.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Naoya Horiguchi <naoya.horiguchi@linux.dev>,
        James Houghton <jthoughton@google.com>,
        Peter Xu <peterx@redhat.com>, Yang Shi <shy828301@gmail.com>,
        Vishal Moola <vishal.moola@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Muchun Song <songmuchun@bytedance.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: hugetlb: proc: check for hugetlb shared PMD in
 /proc/PID/smaps
Message-ID: <Y90O5+UVYaaN1U3y@dhcp22.suse.cz>
References: <20230126222721.222195-1-mike.kravetz@oracle.com>
 <20230126222721.222195-2-mike.kravetz@oracle.com>
 <4ad5163f-5368-0bd8-de9b-1400a7a653ed@redhat.com>
 <20230127150411.7c3b7b99fa4884a6af0b9351@linux-foundation.org>
 <Y9R2ZXMxeF6Lpw4g@monkey>
 <Y9e56ofZ+E4buuam@dhcp22.suse.cz>
 <Y9g/70m15SwxkLfc@monkey>
 <Y9oY9850e/8LQ78i@dhcp22.suse.cz>
 <Y9rUHw2kuSwg2ntI@monkey>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9rUHw2kuSwg2ntI@monkey>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed 01-02-23 13:05:35, Mike Kravetz wrote:
> On 02/01/23 08:47, Michal Hocko wrote:
> > On Mon 30-01-23 14:08:47, Mike Kravetz wrote:
> > > On 01/30/23 13:36, Michal Hocko wrote:
> > > > On Fri 27-01-23 17:12:05, Mike Kravetz wrote:
> > > > > On 01/27/23 15:04, Andrew Morton wrote:
> > > > > > On Fri, 27 Jan 2023 17:23:39 +0100 David Hildenbrand <david@redhat.com> wrote:
> > > > > > > On 26.01.23 23:27, Mike Kravetz wrote:
> > > > 
> > > > Yes, this looks simple enough. My only concern would be that this
> > > > special casing might be required on other places which is hard to
> > > > evaluate. I thought PSS reported by smaps would be broken as well but it
> > > > seems pss is not really accounted for hugetlb mappings at all.
> > > > 
> > > > Have you tried to look into {in,de}creasing the map count of the page when
> > > > the the pte is {un}shared for it?
> > > 
> > > A quick thought is that it would not be too difficult.  It would need
> > > to include the following:
> > > - At PMD share time in huge_pmd_share(),
> > >   Go through all entries in the PMD, and increment map and ref count for
> > >   all referenced pages.  huge_pmd_share is just adding another sharing
> > >   process.
> > > - At PMD unshare time in huge_pmd_unshare(),
> > >   Go through all entries in the PMD, and decrement map and ref count for
> > >   all referenced pages.  huge_pmd_unshare is just removing one sharing
> > >   process.
> > > - At page fault time, check if we are adding a new entry to a shared PMD.
> > >   If yes, add 'num_of_sharing__processes - 1' to the ref and map count.
> > > 
> > > In each of the above operations, we are holding the PTL lock (which is
> > > really the split/PMD lock) so synchronization should not be an issue.
> > > 
> > > Although I mention processes sharing the PMD above, it is really mappings/vmas
> > > sharing the PMD.  You could have two mappings of the same object in the same
> > > process sharing PMDs.
> > > 
> > > I'll code this up and see how it looks.
> > 
> > Thanks!
> >  
> > > However, unless you have an objection I would prefer the simple patches
> > > move forward, especially for stable backports.
> > 
> > Yes, the current patch is much simpler and more suitable for stable
> > backports. If the explicit map count modifications are not all that
> > terrible then this would sound like a more appropriate long term plan
> > though.
> 
> The approach mentioned above seems to be simple enough.  Patch is below.
> 
> I 'tested' with the same method and tests used to measure fault scalabilty
> when developing vma based locking [1].  I figured this would be a good stress
> of the share, unshare and fault paths.  With the patch, we are doing more
> with the page table lock held, so I expected to see a little difference
> in scalability, but not as much as actually measured:
> 
> 				next-20230131
> test		instances	unmodified	patched
> --------------------------------------------------------------------------
> Combined faults 24		61888.4		58314.8
> Combined forks  24		  157.3		  130.1

So faults are 6 % slower while forks are hit by 18%. This is quite a
lot and more than I expected. pmd sharing shouldn't really be a common
operation AFAICS. It should only happen with the first mapping in the
pud (so once every 1GB/2MB faults for fully populated mappings).

It would be good to know whether this is purely lock contention based
or the additional work in each #pf and unmapping makes a big impact as
well.

> These tests could seem a bit like a micro-benchmark targeting these code
> paths.  However, I put them together based on the description of a
> customer workload that prompted the vma based locking work.  And, performance
> of these tests seems to reflect performance of their workloads.
> 
> This extra overhead is the cost needed to make shared PMD map counts be
> accurate and in line with what is normal and expected.  I think it is
> worth the cost.  Other opinions?  Of course, the patch below may have
> issues so please take a look.

If 18% slowdown really reflects a real workload then this might just be
too expensive I am afraid.

> [1] https://lore.kernel.org/linux-mm/20220914221810.95771-1-mike.kravetz@oracle.com/
> 
> 
> >From bff5a717521f96b0e5075ac4b5a1ef84a3589b7e Mon Sep 17 00:00:00 2001
> From: Mike Kravetz <mike.kravetz@oracle.com>
> Date: Mon, 30 Jan 2023 20:14:14 -0800
> Subject: [PATCH] hugetlb: Adjust hugetlbp page ref/map counts for PMD sharing
> 
> When hugetlb PMDS are shared, the sharing code simply adds the shared
> PMD to another processes page table.  It will not update the ref/map
> counts of pages referenced by the shared PMD.  As a result, the ref/map
> count will only reflect when the page was added to the shared PMD.  Even
> though the shared PMD may be in MANY process page tables, ref/map counts
> on the pages will only appear to be that of a single process.
> 
> Update ref/map counts to take PMD sharing into account.  This is done in
> three distinct places:
> 1) At PMD share time in huge_pmd_share(),
>    Go through all entries in the PMD, and increment map and ref count for
>    all referenced pages.  huge_pmd_share is just adding another use and
>    mapping of each page.
> 2) At PMD unshare time in huge_pmd_unshare(),
>    Go through all entries in the PMD, and decrement map and ref count for
>    all referenced pages.  huge_pmd_unshare is just removing one use and
>    mapping of each page.
> 3) When faulting in a new hugetlb page,
>    Check if we are adding a new entry to a shared PMD.  If yes, add
>    'num_of_sharing__processes - 1' to the ref and map count.

Honestly, I didn't really have much time to think about this very deeply
so I might be missing something here. The patch seems correct to me.
adjust_shared_pmd_page_counts's delta parameter is confusing because it
implies a delta adjustments while it justs want to be "bool increase"
instead.

Thanks for looking into this Mike!
[...]
> +static void adjust_shared_pmd_page_counts(pmd_t *pmd_start, int delta)
> +{
> +	struct folio *folio;
> +	struct page *page;
> +	pte_t *ptep, pte;
> +	int i;
> +
> +	for (i= 0; i < PTRS_PER_PMD; i++) {
> +		ptep = (pte_t *)(pmd_start + i);
> +
> +		pte = huge_ptep_get(ptep);
> +		if (huge_pte_none(pte) || !pte_present(pte))
> +			continue;
> +
> +		page = pte_page(pte);
> +		folio = (struct folio *)page;
> +		if (delta > 0) {
> +			folio_get(folio);
> +			atomic_inc(&folio->_entire_mapcount);
> +		} else {
> +			folio_put(folio);
> +			atomic_dec(&folio->_entire_mapcount);
> +		}
> +	}
> +}
[...]

-- 
Michal Hocko
SUSE Labs
