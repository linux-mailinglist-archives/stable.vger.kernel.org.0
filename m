Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC64442DD1
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 13:27:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbhKBM3v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Nov 2021 08:29:51 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:37670 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbhKBM3s (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Nov 2021 08:29:48 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id CAFE11FD75;
        Tue,  2 Nov 2021 12:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1635856031; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Lb3sXNgxIYkY72+OGozUnacdQhpziHv4MBif6sV3P3Q=;
        b=XcqGPV5wA8l4NnlzvUr7wGo7VA5dT478XE+Bx4Na/Uykvj5PJjFmxQGw6HAeNMFkqykBKT
        ZbCvPMfhpanF4zJpRJJw5b/udrOm4+1jNmon8wJhb8LRKtPeD2hu0fvZyFJkfWoXrUO84u
        c0msjVUeEu9Wis80hBBUKlh7oD1v2uA=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 9BFE8A3B81;
        Tue,  2 Nov 2021 12:27:11 +0000 (UTC)
Date:   Tue, 2 Nov 2021 13:27:11 +0100
From:   Michal Hocko <mhocko@suse.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Alexey Makhalov <amakhalov@vmware.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Oscar Salvador <OSalvador@suse.com>
Subject: Re: [PATCH] mm: fix panic in __alloc_pages
Message-ID: <YYEun6s/mF9bE+rQ@dhcp22.suse.cz>
References: <20211101201312.11589-1-amakhalov@vmware.com>
 <YYDtDkGNylpAgPIS@dhcp22.suse.cz>
 <7136c959-63ff-b866-b8e4-f311e0454492@redhat.com>
 <C69EF2FE-DFF6-492E-AD40-97A53739C3EC@vmware.com>
 <YYD/FkpAk5IvmOux@dhcp22.suse.cz>
 <b2e4a611-45a6-732a-a6d3-6042afd2af6e@redhat.com>
 <E34422F0-A44A-48FD-AE3B-816744359169@vmware.com>
 <b3908fce-6b07-8390-b691-56dd2f85c05f@redhat.com>
 <YYEkqH8l0ASWv/JT@dhcp22.suse.cz>
 <42abfba6-b27e-ca8b-8cdf-883a9398b506@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <42abfba6-b27e-ca8b-8cdf-883a9398b506@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 02-11-21 13:06:06, David Hildenbrand wrote:
> On 02.11.21 12:44, Michal Hocko wrote:
> > On Tue 02-11-21 12:00:57, David Hildenbrand wrote:
> >> On 02.11.21 11:34, Alexey Makhalov wrote:
> > [...]
> >>>> The node onlining logic when onlining a CPU sounds bogus as well: Let's
> >>>> take a look at try_offline_node(). It checks that:
> >>>> 1) That no memory is *present*
> >>>> 2) That no CPU is *present*
> >>>>
> >>>> We should online the node when adding the CPU ("present"), not when
> >>>> onlining the CPU.
> >>>
> >>> Possible.
> >>> Assuming try_online_node was moved under add_cpu(), let’s
> >>> take look on this call stack:
> >>> add_cpu()
> >>>   try_online_node()
> >>>     __try_online_node()
> >>>       hotadd_new_pgdat()
> >>> At line 1190 we'll have a problem:
> >>> 1183         pgdat = NODE_DATA(nid);
> >>> 1184         if (!pgdat) {
> >>> 1185                 pgdat = arch_alloc_nodedata(nid);
> >>> 1186                 if (!pgdat)
> >>> 1187                         return NULL;
> >>> 1188
> >>> 1189                 pgdat->per_cpu_nodestats =
> >>> 1190                         alloc_percpu(struct per_cpu_nodestat);
> >>> 1191                 arch_refresh_nodedata(nid, pgdat);
> >>>
> >>> alloc_percpu() will go for all possible CPUs and will eventually end up
> >>> calling alloc_pages_node() trying to use subject nid for corresponding CPU
> >>> hitting the same state #2 problem as NODE_DATA(nid) is still NULL and nid
> >>> is not yet online.
> >>
> >> Right, we will end up calling pcpu_alloc_pages()->alloc_pages_node() for
> >> each possible CPU. We use cpu_to_node() to come up with the NID.
> > 
> > Shouldn't this be numa_mem_id instead? Memory less nodes are odd little
> 
> Hm, good question. Most probably yes for offline nodes.
> 
> diff --git a/mm/percpu-vm.c b/mm/percpu-vm.c
> index 2054c9213c43..c21ff5bb91dc 100644
> --- a/mm/percpu-vm.c
> +++ b/mm/percpu-vm.c
> @@ -84,15 +84,19 @@ static int pcpu_alloc_pages(struct pcpu_chunk *chunk,
>                             gfp_t gfp)
>  {
>         unsigned int cpu, tcpu;
> -       int i;
> +       int i, nid;
>  
>         gfp |= __GFP_HIGHMEM;
>  
>         for_each_possible_cpu(cpu) {
> +               nid = cpu_to_node(cpu);
> +
> +               if (nid == NUMA_NO_NODE || !node_online(nid))
> +                       nid = numa_mem_id();

or simply nid = cpu_to_mem(cpu)

>                 for (i = page_start; i < page_end; i++) {
>                         struct page **pagep = &pages[pcpu_page_idx(cpu, i)];
>  
> -                       *pagep = alloc_pages_node(cpu_to_node(cpu), gfp, 0);
> +                       *pagep = alloc_pages_node(nid, gfp, 0);
>                         if (!*pagep)
>                                 goto err;
>                 }
> 
> 
> > critters crafted into the MM code without wider considerations. From
> > time to time we are struggling with some fallouts but the primary thing
> > is that zonelists should be valid for all memory less nodes.
> 
> Yes, but a zonelist cannot be correct for an offline node, where we might
> not even have an allocated pgdat yet. No pgdat, no zonelist. So as soon as
> we allocate the pgdat and set the node online (->hotadd_new_pgdat()), the zone lists have to be correct. And I can spot an build_all_zonelists() in hotadd_new_pgdat().

Yes, that is what I had in mind. We are talking about two things here.
Memoryless nodes and offline nodes. The later sounds like a bug to me.

> I agree that someone passing an offline NID into an allocator function
> should be fixed.

Right

> Maybe __alloc_pages_bulk() and alloc_pages_node() should bail out directly
> (VM_BUG()) in case we're providing an offline node with eventually no/stale pgdat as
> preferred nid.

Historically, those allocation interfaces were not trying to be robust
against wrong inputs because that adds cpu cycles for everybody for
"what if buggy" code. This has worked (surprisingly) well. Memory less
nodes have brought in some confusion but this is still something that we
can address on a higher level. Nobody give arbitrary nodes as an input.
cpu_to_node might be tricky because it can point to a memory less node
which along with __GFP_THISNODE is very likely not something anybody
wants. Hence cpu_to_mem should be used for allocations. I hate we have
two very similar APIs...

But something seems wrong in this case. cpu_to_node shouldn't return
offline nodes. That is just a land mine. It is not clear to me how the
cpu has been brought up so that the numa node allocation was left
behind. As pointed in other email add_cpu resp. cpu_up is not it.
Is it possible that the cpu bring up was only half way?
-- 
Michal Hocko
SUSE Labs
