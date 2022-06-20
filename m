Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00E15551595
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 12:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239255AbiFTKRl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 06:17:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236511AbiFTKRk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 06:17:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 037C613F69;
        Mon, 20 Jun 2022 03:17:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B0267B8100E;
        Mon, 20 Jun 2022 10:17:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11AA8C341CD;
        Mon, 20 Jun 2022 10:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655720253;
        bh=aImB4dOAnpq7fh83qe9WnFO2jaS12cjvFvZjTv0nroc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yUmvhvmRw3/ZAXcKitI1BMSv+r0TqfV64BDHoZ/kO2QT6n/DT8xZEM4mGmEJUtvNc
         shEMA3hJfdKjQjcCJLgtOql20A/gsWbYHvgceKs7RLzMa9ynzcCSgaZgWCSW6lIr28
         rOyYSlAl46rLAomRQs+PqiiIP0dBK7a5UOUo85Dg=
Date:   Mon, 20 Jun 2022 12:17:22 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Xianting Tian <xianting.tian@linux.alibaba.com>
Cc:     akpm@linux-foundation.org, ziy@nvidia.com, stable@vger.kernel.org,
        guoren@kernel.org, huanyi.xj@alibaba-inc.com, guohanjun@huawei.com,
        zjb194813@alibaba-inc.com, tianhu.hh@alibaba-inc.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4.9] mm: page_alloc: validate buddy page before using
Message-ID: <YrBJMtDdslrvUIAW@kroah.com>
References: <20220616161928.3565294-1-xianting.tian@linux.alibaba.com>
 <Yqw5ZPyeMemfeKKY@kroah.com>
 <c091b3a2-394a-59b4-dd98-98774e33afea@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c091b3a2-394a-59b4-dd98-98774e33afea@linux.alibaba.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 17, 2022 at 04:25:35PM +0800, Xianting Tian wrote:
> 
> 在 2022/6/17 下午4:20, Greg KH 写道:
> > On Fri, Jun 17, 2022 at 12:19:28AM +0800, Xianting Tian wrote:
> > > Commit 787af64d05cd ("mm: page_alloc: validate buddy before check its migratetype.")
> > > fixes a bug in 1dd214b8f21c and there is a similar bug in d9dddbf55667 that
> > > can be fixed in a similar way too.
> > > 
> > > In addition, for RISC-V arch the first 2MB RAM could be reserved for opensbi,
> > > so it would have pfn_base=512 and mem_map began with 512th PFN when
> > > CONFIG_FLATMEM=y.
> > > But __find_buddy_pfn algorithm thinks the start pfn 0, it could get 0 pfn or
> > > less than the pfn_base value. We need page_is_buddy() to verify the buddy to
> > > prevent accessing an invalid buddy.
> > > 
> > > Fixes: d9dddbf55667 ("mm/page_alloc: prevent merging between isolated and other pageblocks")
> > > Cc: stable@vger.kernel.org
> > > Reported-by: zjb194813@alibaba-inc.com
> > > Reported-by: tianhu.hh@alibaba-inc.com
> > > Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
> > > ---
> > >   mm/page_alloc.c | 3 +++
> > >   1 file changed, 3 insertions(+)
> > > 
> > > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > > index a6e682569e5b..1c423faa4b62 100644
> > > --- a/mm/page_alloc.c
> > > +++ b/mm/page_alloc.c
> > > @@ -864,6 +864,9 @@ static inline void __free_one_page(struct page *page,
> > >   			buddy_idx = __find_buddy_index(page_idx, order);
> > >   			buddy = page + (buddy_idx - page_idx);
> > > +
> > > +			if (!page_is_buddy(page, buddy, order))
> > > +				goto done_merging;
> > >   			buddy_mt = get_pageblock_migratetype(buddy);
> > >   			if (migratetype != buddy_mt
> > > -- 
> > > 2.17.1
> > > 
> > What is the git commit id of this change in Linus's tree?
> 
> It is this one,
> 
> commit 787af64d05cd528aac9ad16752d11bb1c6061bb9
> Author: Zi Yan <ziy@nvidia.com>
> Date:   Wed Mar 30 15:45:43 2022 -0700
> 
>     mm: page_alloc: validate buddy before check its migratetype.
> 
>     Whenever a buddy page is found, page_is_buddy() should be called to
>     check its validity.  Add the missing check during pageblock merge check.
> 
>     Fixes: 1dd214b8f21c ("mm: page_alloc: avoid merging non-fallbackable
> pageblocks with others")
>     Link:
> https://lore.kernel.org/all/20220330154208.71aca532@gandalf.local.home/
>     Reported-and-tested-by: Steven Rostedt <rostedt@goodmis.org>
>     Signed-off-by: Zi Yan <ziy@nvidia.com>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 

All now queued up, thanks.

greg k-h
