Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F397846C0AF
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 17:27:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239640AbhLGQbB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 11:31:01 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:54594 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239631AbhLGQbA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 11:31:00 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 68F0C21763;
        Tue,  7 Dec 2021 16:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1638894449; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kIF7c/GC399ClUmX9kOCgFAXVwR1ENNV1ti6qlHDyxE=;
        b=MmhP3fHYP/OFuMvrgV6vV32tQ5r69cLHLQSZNcKJXiHI3PuOOZySlpPbdCBdk/fwjo3pi8
        jgtjx5jIgAl9fwArKG26wB9uLnWJIB3iESXRxLkR53gZL+NHT3Fpf87hFG/XMfmrzJ0Ged
        AgL4ZRpRWaGRkCfSS+mWi64FVoAboUA=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 333D9A3B88;
        Tue,  7 Dec 2021 16:27:29 +0000 (UTC)
Date:   Tue, 7 Dec 2021 17:27:25 +0100
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
Message-ID: <Ya+LbaD8mkvIdq+c@dhcp22.suse.cz>
References: <Ya89aqij6nMwJrIZ@dhcp22.suse.cz>
 <1043a1a4-b7f2-8730-d192-7cab9f15ee24@redhat.com>
 <Ya9P5NxhcZDcyptT@dhcp22.suse.cz>
 <ab5cfba0-1d49-4e4d-e2c8-171e24473c1b@redhat.com>
 <Ya9gN3rZ1eQou3rc@dhcp22.suse.cz>
 <77e785e6-cf34-0cff-26a5-852d3786a9b8@redhat.com>
 <Ya992YvnZ3e3G6h0@dhcp22.suse.cz>
 <b7deaf90-8c3c-c22a-b8dc-e6d98bc93ae6@redhat.com>
 <Ya+EHUYgzo8GaCeq@dhcp22.suse.cz>
 <d01c20fe-86d2-1dc8-e56d-15c0da49afb3@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d01c20fe-86d2-1dc8-e56d-15c0da49afb3@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 07-12-21 17:09:50, David Hildenbrand wrote:
> On 07.12.21 16:56, Michal Hocko wrote:
> > On Tue 07-12-21 16:34:30, David Hildenbrand wrote:
> >> On 07.12.21 16:29, Michal Hocko wrote:
> >>> On Tue 07-12-21 16:09:39, David Hildenbrand wrote:
> >>>> On 07.12.21 14:23, Michal Hocko wrote:
> >>>>> On Tue 07-12-21 13:28:31, David Hildenbrand wrote:
> >>>>> [...]
> >>>>>> But maybe I am missing something important regarding online vs. offline
> >>>>>> nodes that your patch changes?
> >>>>>
> >>>>> I am relying on alloc_node_data setting the node online. But if we are
> >>>>> to change the call to arch_alloc_node_data then the patch needs to be
> >>>>> more involved. Here is what I have right now. If this happens to be the
> >>>>> right way then there is some additional work to sync up with the hotplug
> >>>>> code.
> >>>>>
> >>>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> >>>>> index c5952749ad40..a296e934ad2f 100644
> >>>>> --- a/mm/page_alloc.c
> >>>>> +++ b/mm/page_alloc.c
> >>>>> @@ -8032,8 +8032,23 @@ void __init free_area_init(unsigned long *max_zone_pfn)
> >>>>>  	/* Initialise every node */
> >>>>>  	mminit_verify_pageflags_layout();
> >>>>>  	setup_nr_node_ids();
> >>>>> -	for_each_online_node(nid) {
> >>>>> -		pg_data_t *pgdat = NODE_DATA(nid);
> >>>>> +	for_each_node(nid) {
> >>>>> +		pg_data_t *pgdat;
> >>>>> +
> >>>>> +		if (!node_online(nid)) {
> >>>>> +			pr_warn("Node %d uninitialized by the platform. Please report with memory map.\n", nid);
> >>>>> +			pgdat = arch_alloc_nodedata(nid);
> >>>>> +			pgdat->per_cpu_nodestats = alloc_percpu(struct per_cpu_nodestat);
> >>>>> +			arch_refresh_nodedata(nid, pgdat);
> >>>>> +			node_set_online(nid);
> >>>>
> >>>> Setting all possible nodes online might result in quite some QE noice,
> >>>> because all these nodes will then be visible in the sysfs and
> >>>> try_offline_nodes() is essentially for the trash.
> >>>
> >>> I am not sure I follow. I believe sysfs will not get populate because I
> >>> do not call register_one_node.
> >>
> >> arch/x86/kernel/topology.c:topology_init()
> >>
> >> for_each_online_node(i)
> >> 	register_one_node(i);
> > 
> > Right you are.
> >  
> >>> You are right that try_offline_nodes will be reduce which is good imho.
> >>> More changes will be possible (hopefully to drop some ugly code) on top
> >>> of this change (or any other that achieves that there are no NULL pgdat
> >>> for possible nodes).
> >>>
> >>
> >> No to exposing actually offline nodes to user space via sysfs.
> > 
> > Why is that a problem with the sysfs for non-populated nodes?
> > 
> 
> https://lore.kernel.org/linuxppc-dev/20200428093836.27190-1-srikar@linux.vnet.ibm.com/t/

Thanks. It is good to be reminded that we are in cicling around this
problem for quite some time without really forward much.

> Contains some points -- certainly nothing unfixable but it clearly shows
> that users expect only nodes with actual memory and cpus to be online --
> that's why we export the possible+online state to user space. My point
> is to be careful with such drastic changes and do one step at a time.
>
> I think preallocation of the pgdat is a reasonable thing to have without
> changing user-space visible semantics or even in-kernel semantics.

So your proposal is to drop set_node_online from the patch and add it as
a separate one which handles 
	- sysfs part (i.e. do not register a node which doesn't span a
	  physical address space)
	- hotplug side of (drop the pgd allocation, register node lazily
	  when a first memblocks are registered)

Makes sense?
-- 
Michal Hocko
SUSE Labs
