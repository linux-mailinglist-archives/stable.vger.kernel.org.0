Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB56B551835
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 14:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240472AbiFTMGy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 08:06:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240776AbiFTMGx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 08:06:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5FD9244;
        Mon, 20 Jun 2022 05:06:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F7DBB80FBD;
        Mon, 20 Jun 2022 12:06:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DBE5C3411C;
        Mon, 20 Jun 2022 12:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655726808;
        bh=o/sRpSWnQ77rHcRO6Wsnuk14iKbcdwAjn3p2QoTbwZs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kO8bPvqDMz3ShQJqwGwn0w0gxZu4DfowmVXH7LiL+FLsSKY4mfzEPvXx0Oj7UwGUP
         Ik7vm8Vlh9bopU+Y1DXjr50+/2QpC1b8ftaKyFjreHO6FyHTEhmTrZMs+9MPx3Nn1o
         43+8pL1cVAfvkpUL8IuAmK8/gW/YWlskAx2/+UdA=
Date:   Mon, 20 Jun 2022 14:06:45 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Xianting Tian <xianting.tian@linux.alibaba.com>
Cc:     akpm@linux-foundation.org, ziy@nvidia.com, stable@vger.kernel.org,
        guoren@kernel.org, huanyi.xj@alibaba-inc.com, guohanjun@huawei.com,
        zjb194813@alibaba-inc.com, tianhu.hh@alibaba-inc.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5.15] mm: validate buddy page before using
Message-ID: <YrBi1evI1/BF/WLV@kroah.com>
References: <20220616161746.3565225-1-xianting.tian@linux.alibaba.com>
 <20220616161746.3565225-6-xianting.tian@linux.alibaba.com>
 <YrBJVAZWOzmDyUN3@kroah.com>
 <35bd7396-f5aa-e154-9495-0a36fc6f6a33@linux.alibaba.com>
 <YrBdKwFHfy9Lr14c@kroah.com>
 <8b16a502-5ad5-1efb-0d84-ed0a8ae63c0e@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8b16a502-5ad5-1efb-0d84-ed0a8ae63c0e@linux.alibaba.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 20, 2022 at 07:57:05PM +0800, Xianting Tian wrote:
> 
> 在 2022/6/20 下午7:42, Greg KH 写道:
> > On Mon, Jun 20, 2022 at 06:54:44PM +0800, Xianting Tian wrote:
> > > 在 2022/6/20 下午6:17, Greg KH 写道:
> > > > On Fri, Jun 17, 2022 at 12:17:45AM +0800, Xianting Tian wrote:
> > > > > Commit 787af64d05cd ("mm: page_alloc: validate buddy before check its migratetype.")
> > > > > fixes a bug in 1dd214b8f21c and there is a similar bug in d9dddbf55667 that
> > > > > can be fixed in a similar way too.
> > > > > 
> > > > > In unset_migratetype_isolate(), we also need the fix, so move page_is_buddy()
> > > > > from mm/page_alloc.c to mm/internal.h
> > > > > 
> > > > > In addition, for RISC-V arch the first 2MB RAM could be reserved for opensbi,
> > > > > so it would have pfn_base=512 and mem_map began with 512th PFN when
> > > > > CONFIG_FLATMEM=y.
> > > > > But __find_buddy_pfn algorithm thinks the start pfn 0, it could get 0 pfn or
> > > > > less than the pfn_base value. We need page_is_buddy() to verify the buddy to
> > > > > prevent accessing an invalid buddy.
> > > > > 
> > > > > Fixes: d9dddbf55667 ("mm/page_alloc: prevent merging between isolated and other pageblocks")
> > > > > Cc: stable@vger.kernel.org
> > > > > Reported-by: zjb194813@alibaba-inc.com
> > > > > Reported-by: tianhu.hh@alibaba-inc.com
> > > > > Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
> > > > > ---
> > > > >    mm/internal.h       | 34 ++++++++++++++++++++++++++++++++++
> > > > >    mm/page_alloc.c     | 37 +++----------------------------------
> > > > >    mm/page_isolation.c |  3 ++-
> > > > >    3 files changed, 39 insertions(+), 35 deletions(-)
> > > > What is the commit id of this in Linus's tree?
> > > It is also this one，
> > > 
> > > commit 787af64d05cd528aac9ad16752d11bb1c6061bb9
> > > Author: Zi Yan <ziy@nvidia.com>
> > > Date:   Wed Mar 30 15:45:43 2022 -0700
> > > 
> > >      mm: page_alloc: validate buddy before check its migratetype.
> > > 
> > >      Whenever a buddy page is found, page_is_buddy() should be called to
> > >      check its validity.  Add the missing check during pageblock merge check.
> > > 
> > >      Fixes: 1dd214b8f21c ("mm: page_alloc: avoid merging non-fallbackable
> > > pageblocks with others")
> > >      Link:
> > > https://lore.kernel.org/all/20220330154208.71aca532@gandalf.local.home/
> > >      Reported-and-tested-by: Steven Rostedt <rostedt@goodmis.org>
> > >      Signed-off-by: Zi Yan <ziy@nvidia.com>
> > >      Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > This commit looks nothing like what you posted here.
> > 
> > Why the vast difference with no explaination as to why these are so
> > different from the other backports you provided here?  Also why is the
> > subject lines changed?
> 
> Yes, the changes of 5.15 are not same with others branches, because we need
> additional fix for 5.15,
> 
> You can check it in the thread:
> 
> https://lore.kernel.org/linux-mm/435B45C3-E6A5-43B2-A5A2-318C748691FC@nvidia.com/ <https://lore.kernel.org/linux-mm/435B45C3-E6A5-43B2-A5A2-318C748691FC@nvidia.com/>
> 
> Right. But pfn_valid_within() was removed since 5.15. So your fix is
> required for kernels between 5.15 and 5.17 (inclusive).

What is "your fix" here?

This change differs a lot from what is in Linus's tree now, so this all
needs to be resend and fixed up as I mention above if we are going to be
able to take this.  As-is, it's all not correct so are dropped.

thanks,

greg k-h
