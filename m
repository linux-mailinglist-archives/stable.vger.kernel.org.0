Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB2504EA37
	for <lists+stable@lfdr.de>; Fri, 21 Jun 2019 16:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726029AbfFUOH0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jun 2019 10:07:26 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:43546 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbfFUOHZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Jun 2019 10:07:25 -0400
Received: by mail-pg1-f195.google.com with SMTP id f25so3427469pgv.10;
        Fri, 21 Jun 2019 07:07:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=B9MbqUVZ6G19blzK9C/nkDqisYrvP0LYF0mShhHWuxw=;
        b=lOBd+HVMv320N1woFRqwNylMIxbiTQfNRbF/AHuUNBEjxQ7emmCHOkdA8QDk0yLfAh
         aO2GP/DmzWaH4Pg8diNbgfpd9aRePF/Q0xQFQm4ypEqpDDseJ7ogrhg7ogmYI3RPh9I7
         PXsVpwPcJkNnO4FTqXaCs26yhCYK+NKDiWLiUuH1Fxw35ExG6HP1jA5viTTtVW/oyIOd
         s+JdJk6eNsPuy6bhZbdMqmKNfRmn34HWx/VgEHKTxq3fccFUYyCc1CEa1VHYLiWwFBW/
         QT7RzdACqo4tFezRHqjTbdPQX/yAPEjduQwreXBFWMgP6iBIac1GEVLQvo5VrAM4tdOT
         NVGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=B9MbqUVZ6G19blzK9C/nkDqisYrvP0LYF0mShhHWuxw=;
        b=sZX1LP/dNqSBpSMco0euHeGA57BmV8ghJUnQhIveFPeHcU6nC1unf6Tgvv19FQrvLL
         3eUwm4scyHOps3ibW6jHrMmPzJ/2L5SGMvO6E+6/qvhVctQ8gceQXlOJ4p/5Zvh8S9Li
         SmKtgA6mxNRCkFSR5V2gG7uWHOrU0b9wyxX1iZx3qZSDJXYFGBpzpDpykipjLWEunn9o
         KYC/dBczGx/cSTD3VrGtMCb1GSExkYaRlGTqKUdMQezs7iA9ye7oaGPQrF8o0oh0y1Ud
         SkK0/ZfjfKZNgHqjMsltwTdeGESlllx0T/W7p3LrZIvCMxH3xBrN3+ra8T0HHxaXUpu0
         8FtA==
X-Gm-Message-State: APjAAAW7JJ1Bfx5Pl/EkZCHgKRvtUuNcilOuWge5TKtpJ0BO6UDfatTe
        AG7Bu3hCivPz6r9OCVGAzAg=
X-Google-Smtp-Source: APXvYqwrRphIx8JSIR9al4LlncdG1rD27NbYACKxsZn0B4B6xTwrmoSIm8B0VLJd/wYsCPFzfkv8qw==
X-Received: by 2002:a17:90a:9b08:: with SMTP id f8mr6983306pjp.103.1561126044926;
        Fri, 21 Jun 2019 07:07:24 -0700 (PDT)
Received: from bharath12345-Inspiron-5559 ([103.110.42.36])
        by smtp.gmail.com with ESMTPSA id 11sm3041870pfo.19.2019.06.21.07.07.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Jun 2019 07:07:24 -0700 (PDT)
Date:   Fri, 21 Jun 2019 19:37:17 +0530
From:   Bharath Vedartham <linux.bhar@gmail.com>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Alan Jenkins <alan.christopher.jenkins@gmail.com>,
        Mel Gorman <mgorman@techsingularity.net>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm: fix setting the high and low watermarks
Message-ID: <20190621140717.GA28387@bharath12345-Inspiron-5559>
References: <20190621114325.711-1-alan.christopher.jenkins@gmail.com>
 <3d15b808-b7cd-7379-a6a9-d3cf04b7dcec@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d15b808-b7cd-7379-a6a9-d3cf04b7dcec@suse.cz>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 21, 2019 at 02:09:31PM +0200, Vlastimil Babka wrote:
> On 6/21/19 1:43 PM, Alan Jenkins wrote:
> > When setting the low and high watermarks we use min_wmark_pages(zone).
> > I guess this is to reduce the line length.  But we forgot that this macro
> > includes zone->watermark_boost.  We need to reset zone->watermark_boost
> > first.  Otherwise the watermarks will be set inconsistently.
> > 
> > E.g. this could cause inconsistent values if the watermarks have been
> > boosted, and then you change a sysctl which triggers
> > __setup_per_zone_wmarks().
> > 
> > I strongly suspect this explains why I have seen slightly high watermarks.
> > Suspicious-looking zoneinfo below - notice high-low != low-min.
> > 
> > Node 0, zone   Normal
> >   pages free     74597
> >         min      9582
> >         low      34505
> >         high     36900
> > 
> > https://unix.stackexchange.com/questions/525674/my-low-and-high-watermarks-seem-higher-than-predicted-by-documentation-sysctl-vm/525687
> > 
> > Signed-off-by: Alan Jenkins <alan.christopher.jenkins@gmail.com>
> > Fixes: 1c30844d2dfe ("mm: reclaim small amounts of memory when an external
> >                       fragmentation event occurs")
> > Cc: stable@vger.kernel.org
> 
> Nice catch, thanks!
> 
> Acked-by: Vlastimil Babka <vbabka@suse.cz>
> 
> Personally I would implement it a bit differently, see below. If you
> agree, it's fine if you keep the authorship of the whole patch.
> 
> > ---
> > 
> > Tested by compiler :-).
> > 
> > Ideally the commit message would be clear about what happens the
> > *first* time __setup_per_zone_watermarks() is called.  I guess that
> > zone->watermark_boost is *usually* zero, or we would have noticed
> > some wild problems :-).  However I am not familiar with how the zone
> > structures are allocated & initialized.  Maybe there is a case where
> > zone->watermark_boost could contain an arbitrary unitialized value
> > at this point.  Can we rule that out?
> 
> Dunno if there's some arch override, but generic_alloc_nodedata() uses
> kzalloc() so it's zeroed.
> 
> -----8<-----
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index d66bc8abe0af..3b2f0cedf78e 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -7624,6 +7624,7 @@ static void __setup_per_zone_wmarks(void)
>  
>  	for_each_zone(zone) {
>  		u64 tmp;
> +		unsigned long wmark_min;
>  
>  		spin_lock_irqsave(&zone->lock, flags);
>  		tmp = (u64)pages_min * zone_managed_pages(zone);
> @@ -7642,13 +7643,13 @@ static void __setup_per_zone_wmarks(void)
>  
>  			min_pages = zone_managed_pages(zone) / 1024;
>  			min_pages = clamp(min_pages, SWAP_CLUSTER_MAX, 128UL);
> -			zone->_watermark[WMARK_MIN] = min_pages;
> +			wmark_min = min_pages;
>  		} else {
>  			/*
>  			 * If it's a lowmem zone, reserve a number of pages
>  			 * proportionate to the zone's size.
>  			 */
> -			zone->_watermark[WMARK_MIN] = tmp;
> +			wmark_min = tmp;
>  		}
>  
>  		/*
> @@ -7660,8 +7661,9 @@ static void __setup_per_zone_wmarks(void)
>  			    mult_frac(zone_managed_pages(zone),
>  				      watermark_scale_factor, 10000));
>  
> -		zone->_watermark[WMARK_LOW]  = min_wmark_pages(zone) + tmp;
> -		zone->_watermark[WMARK_HIGH] = min_wmark_pages(zone) + tmp * 2;
> +		zone->_watermark[WMARK_MIN]  = wmark_min;
> +		zone->_watermark[WMARK_LOW]  = wmark_min + tmp;
> +		zone->_watermark[WMARK_HIGH] = wmark_min + tmp * 2;
>  		zone->watermark_boost = 0;
Do you think this could cause a race condition between
__setup_per_zone_wmarks and pgdat_watermark_boosted which checks whether
the watermark_boost of each zone is non-zero? pgdat_watermark_boosted is
not called with a zone lock.
Here is a probable case scenario:
watermarks are boosted in steal_suitable_fallback(which happens under a
zone lock). After that kswapd is woken up by
wakeup_kswapd(zone,0,0,zone_idx(zone)) in rmqueue without holding a
zone lock. Lets say someone modified min_kfree_bytes, this would lead to
all the zone->watermark_boost being set to 0. This may cause
pgdat_watermark_boosted to return false, which would not wakeup kswapd
as intended by boosting the watermark. This behaviour is similar to waking up kswapd for a
balanced node.

Also if kswapd was woken up successfully because of watermarks being
boosted. In balance_pgdat, we use nr_boost_reclaim to count number of
pages to reclaim because of boosting. nr_boost_reclaim is calculated as:
nr_boost_reclaim = 0;
for (i = 0; i <= classzone_idx; i++) {
	zone = pgdat->node_zones + i;
	if (!managed_zone(zone))
		continue;

	nr_boost_reclaim += zone->watermark_boost;
	zone_boosts[i] = zone->watermark_boost;
}
boosted = nr_boost_reclaim;

This is not under a zone_lock. This could lead to nr_boost_reclaim to
be 0 if min_kfree_bytes is set to 0. Which would wake up kcompactd
without reclaiming memory. 
kcompactd compaction might be spurious if the if the memory reclaim step is not happening?

Any thoughts?
>  		spin_unlock_irqrestore(&zone->lock, flags);
>

