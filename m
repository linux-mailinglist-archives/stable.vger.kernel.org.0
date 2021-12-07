Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF4FE46BAC5
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 13:13:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236139AbhLGMQ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 07:16:56 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:54072 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236125AbhLGMQ4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 07:16:56 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 030171FDFD;
        Tue,  7 Dec 2021 12:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1638879205; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nGck5MdPvuP3udnx0I0W++3cIdM5m6MOLBwXn7e6OPk=;
        b=muppBV7reovZWWYXLcS82WCyOFpyW1j5ftWfE/cX6yaoc1+dnWhLq9ZCofCj6MkCqPNKpw
        RmfL0vspK+TY5OjV1OwG+hud53k5o1E+aAr3oFrMEckRXixaTWHh71g1Q0WHS1NARwh6NI
        M3IUSIKHbje9+Ti48IB9H/Rs+Hj7zAU=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id C895DA3B89;
        Tue,  7 Dec 2021 12:13:24 +0000 (UTC)
Date:   Tue, 7 Dec 2021 13:13:24 +0100
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
Message-ID: <Ya9P5NxhcZDcyptT@dhcp22.suse.cz>
References: <2e191db3-286f-90c6-bf96-3f89891e9926@gmail.com>
 <YYqstfX8PSGDfWsn@dhcp22.suse.cz>
 <YYrGpn/52HaLCAyo@fedora>
 <YYrSC7vtSQXz652a@dhcp22.suse.cz>
 <BAE95F0C-FAA7-40C6-A0D6-5049B1207A27@vmware.com>
 <YZN3ExwL7BiDS5nj@dhcp22.suse.cz>
 <5239D699-523C-4F0C-923A-B068E476043E@vmware.com>
 <YZYQUn10DrKhSE7L@dhcp22.suse.cz>
 <Ya89aqij6nMwJrIZ@dhcp22.suse.cz>
 <1043a1a4-b7f2-8730-d192-7cab9f15ee24@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1043a1a4-b7f2-8730-d192-7cab9f15ee24@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 07-12-21 12:08:57, David Hildenbrand wrote:
> On 07.12.21 11:54, Michal Hocko wrote:
> > Hi,
> > I didn't have much time to dive into this deeper and I have hit some
> > problems handling this in an arch specific code so I have tried to play
> > with this instead:
> > 
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index c5952749ad40..4d71759d0d9b 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -8032,8 +8032,16 @@ void __init free_area_init(unsigned long *max_zone_pfn)
> >  	/* Initialise every node */
> >  	mminit_verify_pageflags_layout();
> >  	setup_nr_node_ids();
> > -	for_each_online_node(nid) {
> > +	for_each_node(nid) {
> >  		pg_data_t *pgdat = NODE_DATA(nid);
> > +
> > +		if (!node_online(nid)) {
> > +			pr_warn("Node %d uninitialized by the platform. Please report with memory map.\n");
> > +			alloc_node_data(nid);
> 
> That's x86 specific and not exposed to generic code -- at least in my
> code base. I think we'd want an arch_alloc_nodedata() variant that
> allocates via memblock -- and initializes all fields to 0. So
> essentially a generic alloc_node_data().

you are right

> 
> > +			free_area_init_memoryless_node(nid);
> 
> That's really just free_area_init_node() below, I do wonder what value
> free_area_init_memoryless_node() has as of today.

I am not sure there is any real value in having this special name for
this but I have kept is sync with what x86 does currently. If we want to
remove the wrapper then just do it everywhere. I can do that on top.

> > +			continue;
> > +		}
> > +
> >  		free_area_init_node(nid);
> >  
> >  		/* Any memory on that node */
> > 
> > Could you give it a try? I do not have any machine which would exhibit
> > the problem so I cannot really test this out. I hope build_zone_info
> > will not choke on this. I assume the node distance table is
> > uninitialized for these nodes and IIUC this should lead to an assumption
> > that all other nodes are close. But who knows that can blow up there.
> > 
> > Btw. does this make any sense at all to others?
> > 
> 
> __build_all_zonelists() has to update the zonelists of all nodes I think.

I am not sure what you mean. This should be achieved by this patch
because the boot time build_all_zonelists will go over all online nodes
(i.e. with pgdat). free_area_init happens before that. I am just worried
that the arch specific node_distance() will generate a complete garbage
or blow up for some reason.
-- 
Michal Hocko
SUSE Labs
