Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16E53473E4F
	for <lists+stable@lfdr.de>; Tue, 14 Dec 2021 09:38:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231862AbhLNIif (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Dec 2021 03:38:35 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:49628 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbhLNIif (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Dec 2021 03:38:35 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id E076C1F3C4;
        Tue, 14 Dec 2021 08:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1639471113; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YxBgd60xxvmPh600wNZTY4w7KXnu0mHxHrDaqy+o98A=;
        b=vVvheb2IkU+9MQvKe8kp/a+f0guikXyJAnX57LL0b9Spp1rmzBXcKVMYv7AC3h/HpFhznH
        4wr8dnj3mj449LOYEcW1JhvRrJkjkhCS9WRL0TP5R29ZUhahxJicw5MR8xPg6AqsJNJF9A
        YPeyptfBpPp3onsg+s/QHeycWIFUXgo=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 97D7DA3B88;
        Tue, 14 Dec 2021 08:38:33 +0000 (UTC)
Date:   Tue, 14 Dec 2021 09:38:33 +0100
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
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Nico Pache <npache@redhat.com>
Subject: Re: [PATCH v3] mm: fix panic in __alloc_pages
Message-ID: <YbhYCT0z04la1vjZ@dhcp22.suse.cz>
References: <YYrGpn/52HaLCAyo@fedora>
 <YYrSC7vtSQXz652a@dhcp22.suse.cz>
 <BAE95F0C-FAA7-40C6-A0D6-5049B1207A27@vmware.com>
 <YZN3ExwL7BiDS5nj@dhcp22.suse.cz>
 <5239D699-523C-4F0C-923A-B068E476043E@vmware.com>
 <YZYQUn10DrKhSE7L@dhcp22.suse.cz>
 <Ya89aqij6nMwJrIZ@dhcp22.suse.cz>
 <YbHfBgPQMkjtuHYF@dhcp22.suse.cz>
 <YbdhdySBaHJ/UxBZ@dhcp22.suse.cz>
 <ba5f460b-fc6c-601b-053c-086185fd3049@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ba5f460b-fc6c-601b-053c-086185fd3049@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon 13-12-21 16:07:18, David Hildenbrand wrote:
> On 13.12.21 16:06, Michal Hocko wrote:
> > On Thu 09-12-21 11:48:42, Michal Hocko wrote:
> > [...]
> >> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> >> index 852041f6be41..2d38a431f62f 100644
> >> --- a/mm/memory_hotplug.c
> >> +++ b/mm/memory_hotplug.c
> >> @@ -1161,19 +1161,21 @@ static void reset_node_present_pages(pg_data_t *pgdat)
> >>  }
> >>  
> >>  /* we are OK calling __meminit stuff here - we have CONFIG_MEMORY_HOTPLUG */
> >> -static pg_data_t __ref *hotadd_new_pgdat(int nid)
> >> +static pg_data_t __ref *hotadd_init_pgdat(int nid)
> >>  {
> >>  	struct pglist_data *pgdat;
> >>  
> >>  	pgdat = NODE_DATA(nid);
> >> -	if (!pgdat) {
> >> -		pgdat = arch_alloc_nodedata(nid);
> >> -		if (!pgdat)
> >> -			return NULL;
> >>  
> >> +	/*
> >> +	 * NODE_DATA is preallocated (free_area_init) but its internal
> >> +	 * state is not allocated completely. Add missing pieces.
> >> +	 * Completely offline nodes stay around and they just need
> >> +	 * reintialization.
> >> +	 */
> >> +	if (!pgdat->per_cpu_nodestats) {
> >>  		pgdat->per_cpu_nodestats =
> >>  			alloc_percpu(struct per_cpu_nodestat);
> >> -		arch_refresh_nodedata(nid, pgdat);
> > 
> > This should really be 
> > diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> > index 42211485bcf3..2daa88ce8c80 100644
> > --- a/mm/memory_hotplug.c
> > +++ b/mm/memory_hotplug.c
> > @@ -1173,7 +1173,7 @@ static pg_data_t __ref *hotadd_init_pgdat(int nid)
> >  	 * Completely offline nodes stay around and they just need
> >  	 * reintialization.
> >  	 */
> > -	if (!pgdat->per_cpu_nodestats) {
> > +	if (pgdat->per_cpu_nodestats == &boot_nodestats) {
> >  		pgdat->per_cpu_nodestats =
> >  			alloc_percpu(struct per_cpu_nodestat);
> >  	} else {
> > 
> 
> I'll try giving this some churn later this week -- busy with other stuff.

Please hang on, this needs to be done yet slightly differently. I will
post something more resembling a final patch later today. For the
purpose of the testing this should be sufficient for now.
-- 
Michal Hocko
SUSE Labs
