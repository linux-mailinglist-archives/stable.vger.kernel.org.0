Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D18EC46CEEE
	for <lists+stable@lfdr.de>; Wed,  8 Dec 2021 09:29:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244884AbhLHIcd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Dec 2021 03:32:33 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:40382 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244921AbhLHIcT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Dec 2021 03:32:19 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id A9C461FD3E;
        Wed,  8 Dec 2021 08:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1638952126; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8jOtDrtIuUC+6AZeMWYSP6Zp5FfJzCxI6gdKH79Q3oE=;
        b=qbdpBARfIbesry/V8RaRcinPXaRJxJwhYj8O3sDVeC4ZyoRAI9Yr/EMIfWa1Q7sIxdKEOz
        8C7eQ2guFG4WfDK60cTXU7RgI1B9REMbotLV4Q+Oss98kLyLP93kVHcqONMrsiQV5jcoRh
        2EmTVKz9wTdl53cpNlzjNNznJlxEYxE=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 76C36A3B81;
        Wed,  8 Dec 2021 08:28:46 +0000 (UTC)
Date:   Wed, 8 Dec 2021 09:28:44 +0100
From:   Michal Hocko <mhocko@suse.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Alexey Makhalov <amakhalov@vmware.com>,
        Dennis Zhou <dennis@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oscar Salvador <osalvador@suse.de>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v3] mm: fix panic in __alloc_pages
Message-ID: <YbBsvDarxh0oGYXk@dhcp22.suse.cz>
References: <ab5cfba0-1d49-4e4d-e2c8-171e24473c1b@redhat.com>
 <Ya9gN3rZ1eQou3rc@dhcp22.suse.cz>
 <77e785e6-cf34-0cff-26a5-852d3786a9b8@redhat.com>
 <Ya992YvnZ3e3G6h0@dhcp22.suse.cz>
 <b7deaf90-8c3c-c22a-b8dc-e6d98bc93ae6@redhat.com>
 <Ya+EHUYgzo8GaCeq@dhcp22.suse.cz>
 <d01c20fe-86d2-1dc8-e56d-15c0da49afb3@redhat.com>
 <Ya+LbaD8mkvIdq+c@dhcp22.suse.cz>
 <Ya+Nq2fWrSgl79Bn@dhcp22.suse.cz>
 <235e8656-a947-b446-c39c-fa0f72b65ac7@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <235e8656-a947-b446-c39c-fa0f72b65ac7@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 07-12-21 17:40:36, David Hildenbrand wrote:
> On 07.12.21 17:36, Michal Hocko wrote:
> > On Tue 07-12-21 17:27:29, Michal Hocko wrote:
> > [...]
> >> So your proposal is to drop set_node_online from the patch and add it as
> >> a separate one which handles 
> >> 	- sysfs part (i.e. do not register a node which doesn't span a
> >> 	  physical address space)
> >> 	- hotplug side of (drop the pgd allocation, register node lazily
> >> 	  when a first memblocks are registered)
> > 
> 
> > In other words, the first stage
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index c5952749ad40..f9024ba09c53 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -6382,7 +6382,11 @@ static void __build_all_zonelists(void *data)
> >  	if (self && !node_online(self->node_id)) {
> >  		build_zonelists(self);
> >  	} else {
> > -		for_each_online_node(nid) {
> > +		/*
> > +		 * All possible nodes have pgdat preallocated
> > +		 * free_area_init
> > +		 */
> > +		for_each_node(nid) {
> >  			pg_data_t *pgdat = NODE_DATA(nid);
> >  
> >  			build_zonelists(pgdat);
> > @@ -8032,8 +8036,24 @@ void __init free_area_init(unsigned long *max_zone_pfn)
> >  	/* Initialise every node */
> >  	mminit_verify_pageflags_layout();
> >  	setup_nr_node_ids();
> > -	for_each_online_node(nid) {
> > -		pg_data_t *pgdat = NODE_DATA(nid);
> > +	for_each_node(nid) {
> > +		pg_data_t *pgdat;
> > +
> > +		if (!node_online(nid)) {
> > +			pr_warn("Node %d uninitialized by the platform. Please report with boot dmesg.\n", nid);
> > +			pgdat = arch_alloc_nodedata(nid);
> 
> Is the buddy fully up an running at that point? I don't think so, so we
> might have to allocate via memblock instead. But I might be wrong.

No, not only the page allocator is not ready but slab allocator used by
the generic implementation is not up yet either. I will look deeper into
this later today but I suspect the only choice is to use the memblock
allocator - same way the arch specific code allocates pgdats.

-- 
Michal Hocko
SUSE Labs
