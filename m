Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 780EB46D06B
	for <lists+stable@lfdr.de>; Wed,  8 Dec 2021 10:55:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbhLHJ7G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Dec 2021 04:59:06 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:53386 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230491AbhLHJ7F (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Dec 2021 04:59:05 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 2BCBB218B0;
        Wed,  8 Dec 2021 09:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1638957333; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=34yZn4yaf3zVBT1zz2/zUE5HMZzmdxI7YEkwnvgIihA=;
        b=bZKVfqXQxkHqoe08XNKLXU9wQkf9xQTSG9t4xEU0QbooQfVWQzwPRQWCsT3y3pgdRtzIXB
        q59VhveONPZNx1Jdc9HvwpPp/KjHwO6qRbirZxvlMz3+3OEt+040AKeT0xfK6QtlvQ422s
        HmLi+5pZz2mzuRuNAS8qqYXo27LbTXs=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id E7E1FA3B81;
        Wed,  8 Dec 2021 09:55:32 +0000 (UTC)
Date:   Wed, 8 Dec 2021 10:55:32 +0100
From:   Michal Hocko <mhocko@suse.com>
To:     Alexey Makhalov <amakhalov@vmware.com>
Cc:     Dennis Zhou <dennis@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        Oscar Salvador <osalvador@suse.de>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v3] mm: fix panic in __alloc_pages
Message-ID: <YbCBFO6HL9plOURf@dhcp22.suse.cz>
References: <YYqstfX8PSGDfWsn@dhcp22.suse.cz>
 <YYrGpn/52HaLCAyo@fedora>
 <YYrSC7vtSQXz652a@dhcp22.suse.cz>
 <BAE95F0C-FAA7-40C6-A0D6-5049B1207A27@vmware.com>
 <YZN3ExwL7BiDS5nj@dhcp22.suse.cz>
 <5239D699-523C-4F0C-923A-B068E476043E@vmware.com>
 <YZYQUn10DrKhSE7L@dhcp22.suse.cz>
 <Ya89aqij6nMwJrIZ@dhcp22.suse.cz>
 <YbBywDwc2bCxWGAQ@dhcp22.suse.cz>
 <9DA4ABBB-264F-4AD7-A4D4-DCBD371BE051@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9DA4ABBB-264F-4AD7-A4D4-DCBD371BE051@vmware.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed 08-12-21 08:57:28, Alexey Makhalov wrote:
> 
> 
> > On Dec 8, 2021, at 12:54 AM, Michal Hocko <mhocko@suse.com> wrote:
> > 
> > Alexey,
> > this is still not finalized but it would really help if you could give
> > it a spin on your setup. I still have to think about how to transition
> > from a memoryless node to standard node (in hotplug code). Also there
> > might be other surprises on the way.
> > 
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index c5952749ad40..8ed8db2ccb13 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -6382,7 +6382,11 @@ static void __build_all_zonelists(void *data)
> > 	if (self && !node_online(self->node_id)) {
> > 		build_zonelists(self);
> > 	} else {
> > -		for_each_online_node(nid) {
> > +		/*
> > +		 * All possible nodes have pgdat preallocated
> > +		 * free_area_init
> > +		 */
> > +		for_each_node(nid) {
> > 			pg_data_t *pgdat = NODE_DATA(nid);
> > 
> > 			build_zonelists(pgdat);
> > @@ -8032,8 +8036,32 @@ void __init free_area_init(unsigned long *max_zone_pfn)
> > 	/* Initialise every node */
> > 	mminit_verify_pageflags_layout();
> > 	setup_nr_node_ids();
> > -	for_each_online_node(nid) {
> > -		pg_data_t *pgdat = NODE_DATA(nid);
> > +	for_each_node(nid) {
> > +		pg_data_t *pgdat;
> > +
> > +		if (!node_online(nid)) {
> > +			pr_warn("Node %d uninitialized by the platform. Please report with boot dmesg.\n", nid);
> > +
> > +			/* Allocator not initialized yet */
> > +			pgdat = memblock_alloc(sizeof(*pgdat), SMP_CACHE_BYTES);
> > +			if (!pgdat) {
> > +				pr_err("Cannot allocate %zuB for node %d.\n",
> > +						sizeof(*pgdat), nid);
> > +				continue;
> > +			}
> > +			/* TODO do we need this for memoryless nodes */
> > +			pgdat->per_cpu_nodestats = alloc_percpu(struct per_cpu_nodestat);
> > +			arch_refresh_nodedata(nid, pgdat);
> > +			free_area_init_memoryless_node(nid);
> > +			/*
> > +			 * not marking this node online because we do not want to
> > +			 * confuse userspace by sysfs files/directories for node
> > +			 * without any memory attached to it (see topology_init)
> > +			 */
> > +			continue;
> > +		}
> > +
> > +		pgdat = NODE_DATA(nid);
> > 		free_area_init_node(nid);
> > 
> > 		/* Any memory on that node */
> > 
> 
> Sure Michal, I’ll give it a spin.

Thanks!

> Thanks for attention to this topic.
> 
> Regarding memory waste. 
> Here what I found while was using VM 128 possible NUMA nodes.
> My Linux build on VM with only one numa node can be booted on 192Mb RAM,
> But on 128 nodes it requires 1GB RAM just to boot. It is server distro,
> minimal set of systemd services, no UI.
> 
> meminfo shows:
> 1 node case: Percpu:            53760 kB
> 128 nodes:   Percpu:           718048 kB !!!
> 
> Initial analisys multinode memory consumption showed at least difference in this:
> 
> Every memcgroup allocates mem_cgroup_per_node info for all possible node.
> Each mem_cgroup_per_node has per cpu stats.
> That means, each mem cgroup allocates 128*(sizeof struct mem_cgroup_per_node) + 16384*(sizeof struct lruvec_stats_percpu)
> 
> See: mem_cgroup_alloc() -> alloc_mem_cgroup_per_node_info()
> 
> There is also old comment about it in alloc_mem_cgroup_per_node_info()
>         /*
>          * This routine is called against possible nodes.
>          * But it's BUG to call kmalloc() against offline node.
>          *
>          * TODO: this routine can waste much memory for nodes which will
>          *       never be onlined. It's better to use memory hotplug callback
>          *       function.
>          */

Please report that separately. There are likely more places like that.
I do not think many subsystems (including MM) optimize for a very sparse
possible node masks.

-- 
Michal Hocko
SUSE Labs
