Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 583564F7D13
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 12:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244434AbiDGKjP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 06:39:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244690AbiDGKhi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 06:37:38 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36B8C1AE19A;
        Thu,  7 Apr 2022 03:34:43 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 938FE21115;
        Thu,  7 Apr 2022 10:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1649327681; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sO0QE8JyTuj2LMUjDwYdva6iLYEDQBctYiGgxMGKAN8=;
        b=LwAe3jQ5+TGKWdY4ZX3tUU+fSU5rP4vpxcto9Sc4TqPdlpx/37BzVOasiq+mZLyGY2r3Zg
        aSkdPXBFU824M9PVCIeBYcjeBeW/5V9U3ZQA6IwASjiNwGdtrFXUf+auXBLpqpRdKE9xIn
        3timskGhpz+vIVqqyIju/BRrPH9QULc=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 5DE87A3B95;
        Thu,  7 Apr 2022 10:34:41 +0000 (UTC)
Date:   Thu, 7 Apr 2022 12:34:40 +0200
From:   Michal Hocko <mhocko@suse.com>
To:     Juergen Gross <jgross@suse.com>
Cc:     xen-devel@lists.xenproject.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org,
        Marek =?iso-8859-1?Q?Marczykowski-G=F3recki?= 
        <marmarek@invisiblethingslab.com>, Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH] mm, page_alloc: fix build_zonerefs_node()
Message-ID: <Yk6+QBacbb6oI8lW@dhcp22.suse.cz>
References: <20220407093221.1090-1-jgross@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220407093221.1090-1-jgross@suse.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Ccing Mel

On Thu 07-04-22 11:32:21, Juergen Gross wrote:
> Since commit 9d3be21bf9c0 ("mm, page_alloc: simplify zonelist
> initialization") only zones with free memory are included in a built
> zonelist. This is problematic when e.g. all memory of a zone has been
> ballooned out.

What is the actual problem there?

> Use populated_zone() when building a zonelist as it has been done
> before that commit.
> 
> Cc: stable@vger.kernel.org
> Fixes: 9d3be21bf9c0 ("mm, page_alloc: simplify zonelist initialization")

Did you mean to refer to 
6aa303defb74 ("mm, vmscan: only allocate and reclaim from zones with
pages managed by the buddy allocator")?

> Reported-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
> Signed-off-by: Juergen Gross <jgross@suse.com>
> ---
>  mm/page_alloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index bdc8f60ae462..3d0662af3289 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -6128,7 +6128,7 @@ static int build_zonerefs_node(pg_data_t *pgdat, struct zoneref *zonerefs)
>  	do {
>  		zone_type--;
>  		zone = pgdat->node_zones + zone_type;
> -		if (managed_zone(zone)) {
> +		if (populated_zone(zone)) {
>  			zoneref_set_zone(zone, &zonerefs[nr_zones++]);
>  			check_highest_zone(zone_type);
>  		}
> -- 
> 2.34.1

-- 
Michal Hocko
SUSE Labs
