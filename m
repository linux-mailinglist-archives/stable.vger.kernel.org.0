Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42CB35525CB
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 22:31:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240918AbiFTUbu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 16:31:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235229AbiFTUbt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 16:31:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A193218395;
        Mon, 20 Jun 2022 13:31:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 34E5A6106D;
        Mon, 20 Jun 2022 20:31:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7FC8C3411B;
        Mon, 20 Jun 2022 20:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655757107;
        bh=c5JYQCTEJwthjiNlM6ApZqgO8Kp0+7GZBTD5xWFoZDU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=S1sj5YCEHTQ7XgW/eO6pCw1uVSDGLG2AjOIqRdZAfDUaKdtAdx6Vsx2S4pXdp1UXs
         62vu6pl8cjxSDgT1uKc5dn/UbNHf2+w+w4Q2LkoXipX0WHH4q35zHa1k0Y6f7h73N4
         4n9rEdvIyOPV8y53NYUcQ33vZr6/52p4d/dD1wAQ=
Date:   Mon, 20 Jun 2022 22:31:43 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Zi Yan <ziy@nvidia.com>
Cc:     Xianting Tian <xianting.tian@linux.alibaba.com>,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        guoren@kernel.org, huanyi.xj@alibaba-inc.com, guohanjun@huawei.com,
        zjb194813@alibaba-inc.com, tianhu.hh@alibaba-inc.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5.15] mm: validate buddy page before using
Message-ID: <YrDZL+h86q7iOGWq@kroah.com>
References: <YrBJVAZWOzmDyUN3@kroah.com>
 <35bd7396-f5aa-e154-9495-0a36fc6f6a33@linux.alibaba.com>
 <YrBdKwFHfy9Lr14c@kroah.com>
 <8b16a502-5ad5-1efb-0d84-ed0a8ae63c0e@linux.alibaba.com>
 <YrBi1evI1/BF/WLV@kroah.com>
 <d52e17da-a382-0028-2b16-105ab7053028@linux.alibaba.com>
 <YrBnE6Q1pijgE3gR@kroah.com>
 <3371C275-E45D-445F-838E-D43C60BCD750@nvidia.com>
 <YrBuEvLX/ENMx6Zj@kroah.com>
 <62DC5603-F88E-40A3-A4AD-EEFA7027C399@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <62DC5603-F88E-40A3-A4AD-EEFA7027C399@nvidia.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 20, 2022 at 10:13:59AM -0400, Zi Yan wrote:
> On 20 Jun 2022, at 8:54, Greg KH wrote:
> 
> > On Mon, Jun 20, 2022 at 08:45:13AM -0400, Zi Yan wrote:
> >> On 20 Jun 2022, at 8:24, Greg KH wrote:
> >>
> >>> On Mon, Jun 20, 2022 at 08:18:40PM +0800, Xianting Tian wrote:
> >>>>
> >>>> 在 2022/6/20 下午8:06, Greg KH 写道:
> >>>>> On Mon, Jun 20, 2022 at 07:57:05PM +0800, Xianting Tian wrote:
> >>>>>> 在 2022/6/20 下午7:42, Greg KH 写道:
> >>>>>>> On Mon, Jun 20, 2022 at 06:54:44PM +0800, Xianting Tian wrote:
> >>>>>>>> 在 2022/6/20 下午6:17, Greg KH 写道:
> >>>>>>>>> On Fri, Jun 17, 2022 at 12:17:45AM +0800, Xianting Tian wrote:
> >>>>>>>>>> Commit 787af64d05cd ("mm: page_alloc: validate buddy before check its migratetype.")
> >>>>>>>>>> fixes a bug in 1dd214b8f21c and there is a similar bug in d9dddbf55667 that
> >>>>>>>>>> can be fixed in a similar way too.
> >>>>>>>>>>
> >>>>>>>>>> In unset_migratetype_isolate(), we also need the fix, so move page_is_buddy()
> >>>>>>>>>> from mm/page_alloc.c to mm/internal.h
> >>>>>>>>>>
> >>>>>>>>>> In addition, for RISC-V arch the first 2MB RAM could be reserved for opensbi,
> >>>>>>>>>> so it would have pfn_base=512 and mem_map began with 512th PFN when
> >>>>>>>>>> CONFIG_FLATMEM=y.
> >>>>>>>>>> But __find_buddy_pfn algorithm thinks the start pfn 0, it could get 0 pfn or
> >>>>>>>>>> less than the pfn_base value. We need page_is_buddy() to verify the buddy to
> >>>>>>>>>> prevent accessing an invalid buddy.
> >>>>>>>>>>
> >>>>>>>>>> Fixes: d9dddbf55667 ("mm/page_alloc: prevent merging between isolated and other pageblocks")
> >>>>>>>>>> Cc: stable@vger.kernel.org
> >>>>>>>>>> Reported-by: zjb194813@alibaba-inc.com
> >>>>>>>>>> Reported-by: tianhu.hh@alibaba-inc.com
> >>>>>>>>>> Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
> >>>>>>>>>> ---
> >>>>>>>>>>     mm/internal.h       | 34 ++++++++++++++++++++++++++++++++++
> >>>>>>>>>>     mm/page_alloc.c     | 37 +++----------------------------------
> >>>>>>>>>>     mm/page_isolation.c |  3 ++-
> >>>>>>>>>>     3 files changed, 39 insertions(+), 35 deletions(-)
> >>>>>>>>> What is the commit id of this in Linus's tree?
> >>>>>>>> It is also this one，
> >>>>>>>>
> >>>>>>>> commit 787af64d05cd528aac9ad16752d11bb1c6061bb9
> >>>>>>>> Author: Zi Yan <ziy@nvidia.com>
> >>>>>>>> Date:   Wed Mar 30 15:45:43 2022 -0700
> >>>>>>>>
> >>>>>>>>       mm: page_alloc: validate buddy before check its migratetype.
> >>>>>>>>
> >>>>>>>>       Whenever a buddy page is found, page_is_buddy() should be called to
> >>>>>>>>       check its validity.  Add the missing check during pageblock merge check.
> >>>>>>>>
> >>>>>>>>       Fixes: 1dd214b8f21c ("mm: page_alloc: avoid merging non-fallbackable
> >>>>>>>> pageblocks with others")
> >>>>>>>>       Link:
> >>>>>>>> https://lore.kernel.org/all/20220330154208.71aca532@gandalf.local.home/
> >>>>>>>>       Reported-and-tested-by: Steven Rostedt <rostedt@goodmis.org>
> >>>>>>>>       Signed-off-by: Zi Yan <ziy@nvidia.com>
> >>>>>>>>       Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> >>>>>>> This commit looks nothing like what you posted here.
> >>>>>>>
> >>>>>>> Why the vast difference with no explaination as to why these are so
> >>>>>>> different from the other backports you provided here?  Also why is the
> >>>>>>> subject lines changed?
> >>>>>> Yes, the changes of 5.15 are not same with others branches, because we need
> >>>>>> additional fix for 5.15,
> >>>>>>
> >>>>>> You can check it in the thread:
> >>>>>>
> >>>>>> https://lore.kernel.org/linux-mm/435B45C3-E6A5-43B2-A5A2-318C748691FC@nvidia.com/ <https://lore.kernel.org/linux-mm/435B45C3-E6A5-43B2-A5A2-318C748691FC@nvidia.com/>
> >>>>>>
> >>>>>> Right. But pfn_valid_within() was removed since 5.15. So your fix is
> >>>>>> required for kernels between 5.15 and 5.17 (inclusive).
> >>>>> What is "your fix" here?
> >>>>>
> >>>>> This change differs a lot from what is in Linus's tree now, so this all
> >>>>> needs to be resend and fixed up as I mention above if we are going to be
> >>>>> able to take this.  As-is, it's all not correct so are dropped.
> >>>>
> >>>> I think, for branches except 5.15,  you can just backport Zi Yan's commit
> >>>> 787af64d05cd in Linus tree. I won't send more patches further,
> >>>
> >>> So just for 5.18?  I am confused.
> >>>
> >>>> For 5.15, because it need additional fix except commit 787af64d05cd,  I will
> >>>> send a new patch as your comments.
> >>>>
> >>>> Is it ok for you?
> >>>
> >>> No, please send fixed up patches for all branches you want them applied
> >>> to as I do not understand what to do here at all, sorry.
> >>
> >> Hi Greg,
> >>
> >> The fixes sent by Xianting do not exist in Linus’s tree, since the bug is
> >> fixed by another commit, which was not intended to fix the bug from the commit
> >> d9dddbf55667. These fixes only target the stable branches.
> >
> > Then that all needs to be documented very very very well as to why we
> > can't just take the commit that is in Linus's tree.
> >
> > Why can't we take that commit instead?
> 
> The situation is a little complicated.
> 
> The bug from commit d9dddbf55667 was not discovered back then. The commit 1dd214b8f21c
> was trying to get migratetype merging more rigid and made the bug easy to get
> hit, but none of us were aware of that the bug also exists in commit d9dddbf55667.
> Then the commit 787af64d05cd fixed the bug, but since the original code was
> changed by commit 1dd214b8f21c, thus, it does not directly apply to
> commit d9dddbf55667. So I do not think it makes sense to use the original commits
> 1dd214b8f21c and 787af64d05cd, since the former makes a non bug fixing change and
> the latter fixes the bug revealed by the former.

That is exactly what we want to apply, we almost never want to apply
stuff that is not upstream.  When we do apply "custom" patches, they are
almost always wrong.  We have a long history of this, please let's just
take the originals please.

> As a result, Xianting's patches fix the bug directly, looking more reasonable to me.

Again, please no, let's take the originals and keep in step with what is
in Linus's tree which makes maintance and tracking and everything so
much easier over time.

thanks,

greg k-h
