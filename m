Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B96922802D
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 14:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728364AbgGUMnS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jul 2020 08:43:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726904AbgGUMnR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jul 2020 08:43:17 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4082C061794;
        Tue, 21 Jul 2020 05:43:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=95YZXz3xxlBOTS58dhuQjh4OGBpdFgqsFCQfxS9mS3k=; b=Ig/x4pHHVBpLErcMn0lsrCPY9M
        0BNQWBie4Cz8aoJX0pZEKqzc8nkJlu4m+dUhTgMalQJ9z+8TarVYFNW62Bb0SHNvGL2a0/5kqyGTV
        sTCtKlD4n1L7yzYRjDWGwGujF7C5js5WlfPgiamtUQIw8K75AEKJWyV0aBi+kotG7nC1xvMsXlk/+
        mJv5oF+8g2R+kpNzDk4/zd+Qjscef+YImXtGWEhQLIr9/5hnOjQB2ejJ+wE655ykvI9RsS2L1m5yw
        E/Rt7duHDyIa3xKMou6IEtHda1xjbeUeT+Va7CicrbG/ghxqafAsFqi7yXoxFxxNNZ8JK3GWUSfAV
        36ECX8pQ==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jxrc0-00039d-CK; Tue, 21 Jul 2020 12:43:12 +0000
Date:   Tue, 21 Jul 2020 13:43:12 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     js1304@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kernel-team@lge.com, Christoph Hellwig <hch@infradead.org>,
        Roman Gushchin <guro@fb.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Michal Hocko <mhocko@suse.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/page_alloc: fix memalloc_nocma_{save/restore} APIs
Message-ID: <20200721124312.GE15516@casper.infradead.org>
References: <1595302129-23895-1-git-send-email-iamjoonsoo.kim@lge.com>
 <20200721120533.GD15516@casper.infradead.org>
 <4c484ce0-cfed-0c50-7a20-d1474ce9afee@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c484ce0-cfed-0c50-7a20-d1474ce9afee@suse.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 21, 2020 at 02:38:56PM +0200, Vlastimil Babka wrote:
> On 7/21/20 2:05 PM, Matthew Wilcox wrote:
> > On Tue, Jul 21, 2020 at 12:28:49PM +0900, js1304@gmail.com wrote:
> >> @@ -4619,8 +4631,10 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
> >>  		wake_all_kswapds(order, gfp_mask, ac);
> >>  
> >>  	reserve_flags = __gfp_pfmemalloc_flags(gfp_mask);
> >> -	if (reserve_flags)
> >> +	if (reserve_flags) {
> >>  		alloc_flags = reserve_flags;
> >> +		alloc_flags = current_alloc_flags(gfp_mask, alloc_flags);
> >> +	}
> > 
> > Is this right?  Shouldn't you be passing reserve_flags to
> > current_alloc_flags() here?  Also, there's no need to add { } here.
> 
> Note the "alloc_flags = reserve_flags;" line is not being deleted here. But if
> it was, your points would be true, and yeah it would be a bit more tidy.

Oh ... I should wake up a little more.

Yeah, I'd recommend just doing this:

-		alloc_flags = reserve_flags;
+		alloc_flags = current_alloc_flags(gfp_mask, reserve_flags);

