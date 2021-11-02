Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F204442F14
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 14:25:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbhKBN1k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Nov 2021 09:27:40 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:41762 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbhKBN1j (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Nov 2021 09:27:39 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id E13231FD4B;
        Tue,  2 Nov 2021 13:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1635859503; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LwDs2sHGHE3IzcldDT02gDKZstNcYwZdum+ziVK7+28=;
        b=FuXMBCMQdkMztrh1yd9gDX8FqCeehgRs+YFAUW/vBKrnbmAUQvOWg69oqyNNuxjCMFwr1n
        y54GAMDAwZ0SS8n/kphoILa7wXVfJCsE82id5g/IE+snN8eyO7LhnGzC7I5rYa8ntrPBB+
        YX1jZW7iOdh6w5/fboXWxplxK6rx+CA=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 9FDBBA3B8E;
        Tue,  2 Nov 2021 13:25:03 +0000 (UTC)
Date:   Tue, 2 Nov 2021 14:25:03 +0100
From:   Michal Hocko <mhocko@suse.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Alexey Makhalov <amakhalov@vmware.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Oscar Salvador <OSalvador@suse.com>
Subject: Re: [PATCH] mm: fix panic in __alloc_pages
Message-ID: <YYE8L4gs8/+HH6bf@dhcp22.suse.cz>
References: <7136c959-63ff-b866-b8e4-f311e0454492@redhat.com>
 <C69EF2FE-DFF6-492E-AD40-97A53739C3EC@vmware.com>
 <YYD/FkpAk5IvmOux@dhcp22.suse.cz>
 <b2e4a611-45a6-732a-a6d3-6042afd2af6e@redhat.com>
 <E34422F0-A44A-48FD-AE3B-816744359169@vmware.com>
 <b3908fce-6b07-8390-b691-56dd2f85c05f@redhat.com>
 <YYEkqH8l0ASWv/JT@dhcp22.suse.cz>
 <42abfba6-b27e-ca8b-8cdf-883a9398b506@redhat.com>
 <YYEun6s/mF9bE+rQ@dhcp22.suse.cz>
 <e7aed7c0-b7b1-4a94-f323-0bcde2f879d2@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e7aed7c0-b7b1-4a94-f323-0bcde2f879d2@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 02-11-21 13:39:06, David Hildenbrand wrote:
> >> Yes, but a zonelist cannot be correct for an offline node, where we might
> >> not even have an allocated pgdat yet. No pgdat, no zonelist. So as soon as
> >> we allocate the pgdat and set the node online (->hotadd_new_pgdat()), the zone lists have to be correct. And I can spot an build_all_zonelists() in hotadd_new_pgdat().
> > 
> > Yes, that is what I had in mind. We are talking about two things here.
> > Memoryless nodes and offline nodes. The later sounds like a bug to me.
> 
> Agreed. memoryless nodes should just have proper zonelists -- which
> seems to be the case.
> 
> >> Maybe __alloc_pages_bulk() and alloc_pages_node() should bail out directly
> >> (VM_BUG()) in case we're providing an offline node with eventually no/stale pgdat as
> >> preferred nid.
> > 
> > Historically, those allocation interfaces were not trying to be robust
> > against wrong inputs because that adds cpu cycles for everybody for
> > "what if buggy" code. This has worked (surprisingly) well. Memory less
> > nodes have brought in some confusion but this is still something that we
> > can address on a higher level. Nobody give arbitrary nodes as an input.
> > cpu_to_node might be tricky because it can point to a memory less node
> > which along with __GFP_THISNODE is very likely not something anybody
> > wants. Hence cpu_to_mem should be used for allocations. I hate we have
> > two very similar APIs...
> 
> To be precise, I'm wondering if we should do:
> 
> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> index 55b2ec1f965a..8c49b88336ee 100644
> --- a/include/linux/gfp.h
> +++ b/include/linux/gfp.h
> @@ -565,7 +565,7 @@ static inline struct page *
>  __alloc_pages_node(int nid, gfp_t gfp_mask, unsigned int order)
>  {
>         VM_BUG_ON(nid < 0 || nid >= MAX_NUMNODES);
> -       VM_WARN_ON((gfp_mask & __GFP_THISNODE) && !node_online(nid));
> +       VM_WARN_ON(!node_online(nid));
> 
>         return __alloc_pages(gfp_mask, order, nid, NULL);
>  }
> 
> (Or maybe VM_BUG_ON)
> 
> Because it cannot possibly work and we'll dereference NULL later.

VM_BUG_ON would be silent for most configurations and crash would happen
even without it so I am not sure about the additional value. VM_WARN_ON
doesn't really add much on top - except it would crash in some
configurations. If we really care to catch this case then we would have
to do a reasonable fallback with a printk note and a dumps stack.
Something like
	if (unlikely(!node_online(nid))) {
		pr_err("%d is an offline numa node and using it is a bug in a caller. Please report...\n");
		dump_stack();
		nid = numa_mem_id();
	}

But again this is adding quite some cycles to a hotpath of the page
allocator. Is this worth it?

> > But something seems wrong in this case. cpu_to_node shouldn't return
> > offline nodes. That is just a land mine. It is not clear to me how the
> > cpu has been brought up so that the numa node allocation was left
> > behind. As pointed in other email add_cpu resp. cpu_up is not it.
> > Is it possible that the cpu bring up was only half way?
> 
> I tried to follow the code (what sets a CPU present, what sets a CPU
> online, when do we update cpu_to_node() mapping) and IMHO it's all a big
> mess. Maybe it's clearer to people familiar with that code, but CPU
> hotplug in general seems to be a confusing piece of (arch-specific) code.

Yes there are different arch specific parts that make this quite hard to
follow.

I think we want to learn how exactly Alexey brought that cpu up. Because
his initial thought on add_cpu resp cpu_up doesn't seem to be correct.
Or I am just not following the code properly. Once we know all those
details we can get in touch with cpu hotplug maintainers and see what
can we do.

Btw. do you plan to send a patch for pcp allocator to use cpu_to_mem?
One last thing, there were some mentions of __GFP_THISNODE but I fail to
see connection with the pcp allocator...
-- 
Michal Hocko
SUSE Labs
