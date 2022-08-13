Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D875591907
	for <lists+stable@lfdr.de>; Sat, 13 Aug 2022 08:29:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235295AbiHMG3S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Aug 2022 02:29:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232374AbiHMG3R (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Aug 2022 02:29:17 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5C5496FC6;
        Fri, 12 Aug 2022 23:29:16 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 42EE168AA6; Sat, 13 Aug 2022 08:29:13 +0200 (CEST)
Date:   Sat, 13 Aug 2022 08:29:13 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Michal Hocko <mhocko@suse.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        john.p.donnelly@oracle.com, david@redhat.com, bhe@redhat.com
Subject: Re: + dma-pool-do-not-complain-if-dma-pool-is-not-allocated.patch
 added to mm-hotfixes-unstable branch
Message-ID: <20220813062913.GA10523@lst.de>
References: <20220810013308.5E23AC433C1@smtp.kernel.org> <20220810140030.GA24195@lst.de> <YvP9YITH0RpgpblG@dhcp22.suse.cz> <20220811092911.GA22246@lst.de> <YvTRFxkmSuDAyVdI@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YvTRFxkmSuDAyVdI@dhcp22.suse.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 11, 2022 at 11:51:19AM +0200, Michal Hocko wrote:
> this will not consider any gaps in the zone. We have zone_managed_pages
> which tells you how many pages there are in the zone which have been
> provided to the page allocator which seems like something that would fit
> better. And it is also much better than basing it on the global amount
> of memory which just doesn't make much sens for constrained zones

Yes, that is a much better helper.

> Except that it will not work for this case as
> +static unsigned long calculate_pool_size(unsigned long zone_pages)
> +{
> +       unsigned long nr_pages = min_t(unsigned long,
> +                                      zone_pages / (SZ_1G / SZ_128K),
> +                                      MAX_ORDER_NR_PAGES);
> +
> +       return max_t(unsigned long, nr_pages << PAGE_SHIFT, SZ_128K);
> +}
> 
> this will return 128kB, correct?

Yes.

> The DMA zone still has 126kB of usable memory. I think what you
> want/need to do something like

No.  If you don't have 128k free you have another bug and we really
should warn here.  Please go back to that system and figure out what
uses up almost all of ZONE_DMA on that system, because we have another
big problem there.
