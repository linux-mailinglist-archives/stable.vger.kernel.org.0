Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4F1B46CEB6
	for <lists+stable@lfdr.de>; Wed,  8 Dec 2021 09:12:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235521AbhLHIQB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Dec 2021 03:16:01 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:43498 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244682AbhLHIP5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Dec 2021 03:15:57 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id AC64F2190C;
        Wed,  8 Dec 2021 08:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1638951143; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EqPRBZg91RMq41owz+XvEfa3k4OtiHy0sHFbutmVHzQ=;
        b=gdHURKuUPwiBpBFl+lD9+bX30gLnE+tgp/QZtUmE1aFil5NLjMMFrR4wM3p4WS6+5gSfCs
        C5/mdHAvTOIeaf4SxV9HCsUcwPW1emS87THiZ11Zp1t7PG2myd9qNDWuwk4W5S4cKJTIQq
        U01WTK2NBjnUNXwNZZkZDd5y9q87MlQ=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 67671A3B81;
        Wed,  8 Dec 2021 08:12:23 +0000 (UTC)
Date:   Wed, 8 Dec 2021 09:12:22 +0100
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
Message-ID: <YbBo5uvV7wtgOYrj@dhcp22.suse.cz>
References: <Ya992YvnZ3e3G6h0@dhcp22.suse.cz>
 <b7deaf90-8c3c-c22a-b8dc-e6d98bc93ae6@redhat.com>
 <Ya+EHUYgzo8GaCeq@dhcp22.suse.cz>
 <d01c20fe-86d2-1dc8-e56d-15c0da49afb3@redhat.com>
 <Ya+LbaD8mkvIdq+c@dhcp22.suse.cz>
 <Ya+Nq2fWrSgl79Bn@dhcp22.suse.cz>
 <2E174230-04F3-4798-86D5-1257859FFAD8@vmware.com>
 <21539fc8-15a8-1c8c-4a4f-8b85734d2a0e@redhat.com>
 <78E39A43-D094-4706-B4BD-18C0B18EB2C3@vmware.com>
 <f9786109-518f-38d4-0270-a3e87a13c4ef@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f9786109-518f-38d4-0270-a3e87a13c4ef@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 07-12-21 19:03:28, David Hildenbrand wrote:
> On 07.12.21 18:17, Alexey Makhalov wrote:
> > 
> > 
> >> On Dec 7, 2021, at 9:13 AM, David Hildenbrand <david@redhat.com> wrote:
> >>
> >> On 07.12.21 18:02, Alexey Makhalov wrote:
> >>>
> >>>
> >>>> On Dec 7, 2021, at 8:36 AM, Michal Hocko <mhocko@suse.com> wrote:
> >>>>
> >>>> On Tue 07-12-21 17:27:29, Michal Hocko wrote:
> >>>> [...]
> >>>>> So your proposal is to drop set_node_online from the patch and add it as
> >>>>> a separate one which handles
> >>>>> 	- sysfs part (i.e. do not register a node which doesn't span a
> >>>>> 	  physical address space)
> >>>>> 	- hotplug side of (drop the pgd allocation, register node lazily
> >>>>> 	  when a first memblocks are registered)
> >>>>
> >>>> In other words, the first stage
> >>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> >>>> index c5952749ad40..f9024ba09c53 100644
> >>>> --- a/mm/page_alloc.c
> >>>> +++ b/mm/page_alloc.c
> >>>> @@ -6382,7 +6382,11 @@ static void __build_all_zonelists(void *data)
> >>>> 	if (self && !node_online(self->node_id)) {
> >>>> 		build_zonelists(self);
> >>>> 	} else {
> >>>> -		for_each_online_node(nid) {
> >>>> +		/*
> >>>> +		 * All possible nodes have pgdat preallocated
> >>>> +		 * free_area_init
> >>>> +		 */
> >>>> +		for_each_node(nid) {
> >>>> 			pg_data_t *pgdat = NODE_DATA(nid);
> >>>>
> >>>> 			build_zonelists(pgdat);
> >>>
> >>> Will it blow up memory usage for the nodes which might never be onlined?
> >>> I prefer the idea of init on demand.
> >>>
> >>> Even now there is an existing problem.
> >>> In my experiments, I observed _huge_ memory consumption increase by increasing number
> >>> of possible numa nodes. I’m going to report it in separate mail thread.
> >>
> >> I already raised that PPC might be problematic in that regard. Which
> >> architecture / setup do you have in mind that can have a lot of possible
> >> nodes?
> >>
> > It is x86_64 VMware VM, not the regular one, but specially configured (1 vCPU per node,
> > with hot-plug support, 128 possible nodes)  
> 
> I thought the pgdat would be smaller but I just gave it a test:

Yes, pgdat is quite large! Just embeded zones can eat a lot.

> On my system, pgdata_t is 173824 bytes. So 128 nodes would correspond to
> 21 MiB, which is indeed a lot. I assume it's due to "struct zonelist",
> which has MAX_ZONES_PER_ZONELIST == (MAX_NUMNODES * MAX_NR_ZONES) zone
> references ...

This is what pahole tells me
struct pglist_data {
        struct zone                node_zones[4] __attribute__((__aligned__(64))); /*     0  5632 */
        /* --- cacheline 88 boundary (5632 bytes) --- */
        struct zonelist            node_zonelists[1];    /*  5632    80 */
	[...]
        /* size: 6400, cachelines: 100, members: 27 */
        /* sum members: 6369, holes: 5, sum holes: 31 */

with my particular config (which is !NUMA). I haven't really checked
whether there are other places which might scale with MAX_NUM_NODES or
something like that.

Anyway, is 21MB of wasted space for 128 Node machine something really
note worthy?
-- 
Michal Hocko
SUSE Labs
