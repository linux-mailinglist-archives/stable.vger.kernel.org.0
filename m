Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EEB246BF4C
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 16:29:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238718AbhLGPdB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 10:33:01 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:44582 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238634AbhLGPdB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 10:33:01 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 5001E1FDFE;
        Tue,  7 Dec 2021 15:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1638890970; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qPce+P64BVI4ZDW0Ye0BHkwVzrW0PZ4iqeaPwRwX998=;
        b=rJLhMAJ7xdJl7yL7oTpBNRwkd7XrNy/xfugYKFelg9NmK5tcvuj+Y6unmVjag/030Xcc+C
        aZBjLUXpjSjAQQblvH8WwJrBurIM3RKCxZOFAA/DpmzWCA4wKPkUYWbo85eHMzttrNY0Mw
        QyQM754+/w6fabTyz9uIrH3VvzEs8R4=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 1FEBDA3B87;
        Tue,  7 Dec 2021 15:29:30 +0000 (UTC)
Date:   Tue, 7 Dec 2021 16:29:29 +0100
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
Message-ID: <Ya992YvnZ3e3G6h0@dhcp22.suse.cz>
References: <BAE95F0C-FAA7-40C6-A0D6-5049B1207A27@vmware.com>
 <YZN3ExwL7BiDS5nj@dhcp22.suse.cz>
 <5239D699-523C-4F0C-923A-B068E476043E@vmware.com>
 <YZYQUn10DrKhSE7L@dhcp22.suse.cz>
 <Ya89aqij6nMwJrIZ@dhcp22.suse.cz>
 <1043a1a4-b7f2-8730-d192-7cab9f15ee24@redhat.com>
 <Ya9P5NxhcZDcyptT@dhcp22.suse.cz>
 <ab5cfba0-1d49-4e4d-e2c8-171e24473c1b@redhat.com>
 <Ya9gN3rZ1eQou3rc@dhcp22.suse.cz>
 <77e785e6-cf34-0cff-26a5-852d3786a9b8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77e785e6-cf34-0cff-26a5-852d3786a9b8@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 07-12-21 16:09:39, David Hildenbrand wrote:
> On 07.12.21 14:23, Michal Hocko wrote:
> > On Tue 07-12-21 13:28:31, David Hildenbrand wrote:
> > [...]
> >> But maybe I am missing something important regarding online vs. offline
> >> nodes that your patch changes?
> > 
> > I am relying on alloc_node_data setting the node online. But if we are
> > to change the call to arch_alloc_node_data then the patch needs to be
> > more involved. Here is what I have right now. If this happens to be the
> > right way then there is some additional work to sync up with the hotplug
> > code.
> > 
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index c5952749ad40..a296e934ad2f 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -8032,8 +8032,23 @@ void __init free_area_init(unsigned long *max_zone_pfn)
> >  	/* Initialise every node */
> >  	mminit_verify_pageflags_layout();
> >  	setup_nr_node_ids();
> > -	for_each_online_node(nid) {
> > -		pg_data_t *pgdat = NODE_DATA(nid);
> > +	for_each_node(nid) {
> > +		pg_data_t *pgdat;
> > +
> > +		if (!node_online(nid)) {
> > +			pr_warn("Node %d uninitialized by the platform. Please report with memory map.\n", nid);
> > +			pgdat = arch_alloc_nodedata(nid);
> > +			pgdat->per_cpu_nodestats = alloc_percpu(struct per_cpu_nodestat);
> > +			arch_refresh_nodedata(nid, pgdat);
> > +			node_set_online(nid);
> 
> Setting all possible nodes online might result in quite some QE noice,
> because all these nodes will then be visible in the sysfs and
> try_offline_nodes() is essentially for the trash.

I am not sure I follow. I believe sysfs will not get populate because I
do not call register_one_node.

You are right that try_offline_nodes will be reduce which is good imho.
More changes will be possible (hopefully to drop some ugly code) on top
of this change (or any other that achieves that there are no NULL pgdat
for possible nodes).
 
> I agree to prealloc the pgdat, I don't think we should actually set the
> nodes online. Node onlining/offlining should be done when we do have
> actual CPUs/memory populated.

If we keep the offline/online node state notion we are not solving an
important aspect of the problem - confusing api.

Node states do not really correspond to logical states and that makes
it really hard to wrap head around. I think we should completely drop
for_each_online_node because that just doesn't mean anything without
synchronization with hotplug. People who really need to iterate over all
numa nodes should be using for_each_node and do not expect any surprises
that the node doesn't exist. It is much more easier to think in scope of
completely depleted numa node (and get ENOMEM when strictly requiring
local node resources - e.g. via __GFP_THISNODE) than some special node
without any memory that need a special treatment.
-- 
Michal Hocko
SUSE Labs
