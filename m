Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06A914F8070
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 15:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239581AbiDGN0C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 09:26:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343643AbiDGNZx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 09:25:53 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA958EBAF5;
        Thu,  7 Apr 2022 06:23:49 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 134C21F85A;
        Thu,  7 Apr 2022 13:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1649337828; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6kx9n4k18EeAoUx1f5fom/mHD05wbK+BXq9P0qrUE0s=;
        b=CBAIxuyfQWJKGRJKMV4AiNEBZCl0yC6CKa9+31uIG8KGlgrDvozgdg9H1WZA0Oo1Qzsgle
        64ixAZFYMZlAuBacbmCFiMKqUs10OgYbsUUINBsozhl49g8dtsH3VltZo2pH0YoMF6NF4N
        pxfOnpdtge2avIwq0hr1p2OkqbUYSgY=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id D2BE9A3B9C;
        Thu,  7 Apr 2022 13:23:47 +0000 (UTC)
Date:   Thu, 7 Apr 2022 15:23:44 +0200
From:   Michal Hocko <mhocko@suse.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Juergen Gross <jgross@suse.com>, xen-devel@lists.xenproject.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org,
        Marek =?iso-8859-1?Q?Marczykowski-G=F3recki?= 
        <marmarek@invisiblethingslab.com>, Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH] mm, page_alloc: fix build_zonerefs_node()
Message-ID: <Yk7l4CEpQFoPnYB/@dhcp22.suse.cz>
References: <20220407093221.1090-1-jgross@suse.com>
 <Yk6+QBacbb6oI8lW@dhcp22.suse.cz>
 <f08c1493-9238-0009-56b4-dc0ab3571b33@suse.com>
 <Yk7F2KzRrhLjYw4Z@dhcp22.suse.cz>
 <5e97a7f5-1fc9-d0b4-006e-6894d5653c06@suse.com>
 <Yk7NqTlw7lmFzpKb@dhcp22.suse.cz>
 <770d8283-4315-3d83-4f8b-723308fffe5c@redhat.com>
 <Yk7TMKBAkuSVZRLT@dhcp22.suse.cz>
 <ca22625e-b72c-059a-9242-f10b291be4fe@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca22625e-b72c-059a-9242-f10b291be4fe@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu 07-04-22 14:12:38, David Hildenbrand wrote:
> On 07.04.22 14:04, Michal Hocko wrote:
> > On Thu 07-04-22 13:58:44, David Hildenbrand wrote:
> > [...]
> >>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> >>> index 3589febc6d31..130a2feceddc 100644
> >>> --- a/mm/page_alloc.c
> >>> +++ b/mm/page_alloc.c
> >>> @@ -6112,10 +6112,8 @@ static int build_zonerefs_node(pg_data_t *pgdat, struct zoneref *zonerefs)
> >>>  	do {
> >>>  		zone_type--;
> >>>  		zone = pgdat->node_zones + zone_type;
> >>> -		if (managed_zone(zone)) {
> >>> -			zoneref_set_zone(zone, &zonerefs[nr_zones++]);
> >>> -			check_highest_zone(zone_type);
> >>> -		}
> >>> +		zoneref_set_zone(zone, &zonerefs[nr_zones++]);
> >>> +		check_highest_zone(zone_type);
> >>>  	} while (zone_type);
> >>>  
> >>>  	return nr_zones;
> >>
> >> I don't think having !populated zones in the zonelist is a particularly
> >> good idea. Populated vs !populated changes only during page
> >> onlininge/offlining.
> >>
> >> If I'm not wrong, with your patch we'd even include ZONE_DEVICE here ...
> > 
> > What kind of problem that would cause? The allocator wouldn't see any
> > pages at all so it would fallback to the next one. Maybe kswapd would
> > need some tweak to have a bail out condition but as mentioned in the
> > thread already. !populated or !managed for that matter are not all that
> > much different from completely depleted zones. The fact that we are
> > making that distinction has led to some bugs and I suspect it makes the
> > code more complex without a very good reason.
> 
> I assume performance problems. Assume you have an ordinary system with
> multiple NUMA nodes and no MOVABLE memory. Most nodes will only have
> ZONE_NORMAL. Yet, you'd include ZONE_DMA* and ZONE_MOVABLE that will
> always remain empty to be traversed on each and every allocation
> fallback. Of course, we could measure, but IMHO at least *that* part of
> memory onlining/offlining is not the complicated part :D

You've got a good point here. I guess there will be usecases that really
benefit from every single CPU cycle spared in the allocator hot path
which really depends on the zonelists traversing.

I have very briefly had a look at our remaining usage of managed_zone()
and there are not that many left. We have 2 in page_alloc.c via
has_managed_dma(). I guess we could drop that one and use __GFP_NOWARN
in dma_atomic_pool_init but this is nothing really earth shattering.
The remaining occurances are in vmscan.c:
	- should_continue_reclaim, pgdat_balanced - required because
	  they iterate all zones withing the zoneindex and need to
	  decide whether they are balanced or not. We can make empty
	  zones special case and make them always balanced
	- kswapd_shrink_node - required because we would be increasing
	  reclaim target for empty zones
	- update_reclaim_active - required because we do not want to
	  alter zone state if it is not a subject of the reclaim which
	  empty zones are not by definition.
	- balance_pgdat - first check is likely a microoptimization,
	  reclaim_idx is needed to have a populated zone there
	- wakeup_kswapd - I dunno
	- shrink_node, allow_direct_reclaim, lruvec_lru_size - microptimizations
	- pgdat_watermark_boosted - microptimizations I suspect as empty
	  zone shouldn't ever get watermark_boost
	- pgdat_balanced - functionally dd

So we can get rid of quite some but we will still need some of them.
-- 
Michal Hocko
SUSE Labs
