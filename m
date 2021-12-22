Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC76147D126
	for <lists+stable@lfdr.de>; Wed, 22 Dec 2021 12:41:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240236AbhLVLlX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Dec 2021 06:41:23 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:39656 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237624AbhLVLlX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Dec 2021 06:41:23 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id D483B212B9;
        Wed, 22 Dec 2021 11:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1640173281; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ps07gwicxIa6if6MGpsmNI9n6pnErUxgnZxQzcd6Lbk=;
        b=sP3nnik3EJAsx3SWWYmI+EC3wsLNXWfVbcgv3VLqEXO8fzAegf2b6Sv4hNKy/1wb8fF78n
        yDahY3G7ZuiIOAuh2CvzSLLFls2YtMKRdz0LdF2BGksXesvgavLjoLsPDVvl5wba9Dv2zr
        PuTQcX61PzWQjpPDl++F1vLDoiqNCqc=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id B8BB1A3B84;
        Wed, 22 Dec 2021 11:41:21 +0000 (UTC)
Date:   Wed, 22 Dec 2021 12:41:18 +0100
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
Message-ID: <YcMO3qm9UDcPZjCT@dhcp22.suse.cz>
References: <2291C572-3B22-4BE5-8C7A-0D6A4609547B@vmware.com>
 <YbHS2qN4wY+1hWZp@dhcp22.suse.cz>
 <B5B3BCE0-853B-444E-BAD8-823CEE8A3E59@vmware.com>
 <YbIEqflrP/vxIsXZ@dhcp22.suse.cz>
 <7D1564FA-5AC6-47F3-BC5A-A11716CD40F2@vmware.com>
 <YbMZsczMGpChaWz0@dhcp22.suse.cz>
 <YbyIVPAc2A2sWO8/@dhcp22.suse.cz>
 <FD8165E2-E17E-458E-B4EE-8C4DB21BA3B6@vmware.com>
 <YcGignpJgdvy9Vnu@dhcp22.suse.cz>
 <078460FE-84C4-442C-BD80-97DB90557809@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <078460FE-84C4-442C-BD80-97DB90557809@vmware.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 21-12-21 20:23:34, Alexey Makhalov wrote:
> 
> 
> > On Dec 21, 2021, at 1:46 AM, Michal Hocko <mhocko@suse.com> wrote:
> > 
> > On Tue 21-12-21 05:46:16, Alexey Makhalov wrote:
> >> Hi Michal,
> >> 
> >> The patchset looks good to me. I didn’t find any issues during the testing.
> > 
> > Thanks a lot. Can I add your Tested-by: tag?
> Sure, thanks.

Thanks I will add those then.
 
> >> I have one concern regarding dmesg output. Do you think this messaging is
> >> valid if possible node is not yet present?
> >> Or is it only the issue for virtual machines?
> >> 
> >>  Node XX uninitialized by the platform. Please report with boot dmesg.
> >>  Initmem setup node XX [mem 0x0000000000000000-0x0000000000000000]
> > 
> > AFAIU the Initmem part of the output is what concerns you, right? Yeah,
> First line actually, this sentence “Please report with boot dmesg.”. But
> there is nothing to fix, at least for VMs.

I am still not sure because at least x86 aims at handling that at the
platform code. David has given us a way to trigger this from kvm/qemu so
I will play with that. I can certainly change the wording but this whole
thing was meant to do a fixup after the arch specific code has initialized
everything.

> > that really is more cryptic than necessary. Does this look any better?
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index 34743dcd2d66..7e18a924be7e 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -7618,9 +7618,14 @@ static void __init free_area_init_node(int nid)
> > 	pgdat->node_start_pfn = start_pfn;
> > 	pgdat->per_cpu_nodestats = NULL;
> > 
> > -	pr_info("Initmem setup node %d [mem %#018Lx-%#018Lx]\n", nid,
> > -		(u64)start_pfn << PAGE_SHIFT,
> > -		end_pfn ? ((u64)end_pfn << PAGE_SHIFT) - 1 : 0);
> > +	if (start_pfn != end_pfn) {
> > +		pr_info("Initmem setup node %d [mem %#018Lx-%#018Lx]\n", nid,
> > +			(u64)start_pfn << PAGE_SHIFT,
> > +			end_pfn ? ((u64)end_pfn << PAGE_SHIFT) - 1 : 0);
> > +	} else {
> > +		pr_info("Initmem setup node %d as memoryless\n", nid);
> > +	}
> > +
> > 	calculate_node_totalpages(pgdat, start_pfn, end_pfn);
> > 
> > 	alloc_node_mem_map(pgdat);
> Second line looks much better.

OK, I will fold that in. I think it is more descriptive as well.
> 
> Thank you,
> —Alexey
> 

-- 
Michal Hocko
SUSE Labs
