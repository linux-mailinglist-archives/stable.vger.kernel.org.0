Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B25F14F7EA8
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 14:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237238AbiDGMGR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 08:06:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245130AbiDGMGI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 08:06:08 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 968E0C31DE;
        Thu,  7 Apr 2022 05:04:02 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 50D771F85A;
        Thu,  7 Apr 2022 12:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1649333041; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yD6Hv0Qev4TUL19bY/g1Sx375Qm9AbFeZHHdH3oY4hs=;
        b=nyUXqwYZBdRJ+l/n+nNGbkZWDe7Bqq+oy/9xD+GmBS6dBr+gvMlU+jcSshfTcrFJFz1eKf
        WOdzx1NwqOpGiWVEPbEodpWKamYAO+1G6nea8neoVBEI9wnICynBWROc1V3VeqRcWfHsxN
        oH6daT+1azkNl7uvjrk1FB4sy6VhfOs=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 0887EA3B96;
        Thu,  7 Apr 2022 12:04:00 +0000 (UTC)
Date:   Thu, 7 Apr 2022 14:04:00 +0200
From:   Michal Hocko <mhocko@suse.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Juergen Gross <jgross@suse.com>, xen-devel@lists.xenproject.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org,
        Marek =?iso-8859-1?Q?Marczykowski-G=F3recki?= 
        <marmarek@invisiblethingslab.com>, Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH] mm, page_alloc: fix build_zonerefs_node()
Message-ID: <Yk7TMKBAkuSVZRLT@dhcp22.suse.cz>
References: <20220407093221.1090-1-jgross@suse.com>
 <Yk6+QBacbb6oI8lW@dhcp22.suse.cz>
 <f08c1493-9238-0009-56b4-dc0ab3571b33@suse.com>
 <Yk7F2KzRrhLjYw4Z@dhcp22.suse.cz>
 <5e97a7f5-1fc9-d0b4-006e-6894d5653c06@suse.com>
 <Yk7NqTlw7lmFzpKb@dhcp22.suse.cz>
 <770d8283-4315-3d83-4f8b-723308fffe5c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <770d8283-4315-3d83-4f8b-723308fffe5c@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu 07-04-22 13:58:44, David Hildenbrand wrote:
[...]
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index 3589febc6d31..130a2feceddc 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -6112,10 +6112,8 @@ static int build_zonerefs_node(pg_data_t *pgdat, struct zoneref *zonerefs)
> >  	do {
> >  		zone_type--;
> >  		zone = pgdat->node_zones + zone_type;
> > -		if (managed_zone(zone)) {
> > -			zoneref_set_zone(zone, &zonerefs[nr_zones++]);
> > -			check_highest_zone(zone_type);
> > -		}
> > +		zoneref_set_zone(zone, &zonerefs[nr_zones++]);
> > +		check_highest_zone(zone_type);
> >  	} while (zone_type);
> >  
> >  	return nr_zones;
> 
> I don't think having !populated zones in the zonelist is a particularly
> good idea. Populated vs !populated changes only during page
> onlininge/offlining.
> 
> If I'm not wrong, with your patch we'd even include ZONE_DEVICE here ...

What kind of problem that would cause? The allocator wouldn't see any
pages at all so it would fallback to the next one. Maybe kswapd would
need some tweak to have a bail out condition but as mentioned in the
thread already. !populated or !managed for that matter are not all that
much different from completely depleted zones. The fact that we are
making that distinction has led to some bugs and I suspect it makes the
code more complex without a very good reason.

> I'd vote for going with the simple fix first, which should be good
> enough AFAIKT.

yes, see the other reply

-- 
Michal Hocko
SUSE Labs
