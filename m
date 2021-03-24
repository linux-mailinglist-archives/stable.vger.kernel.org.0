Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 768F4347F32
	for <lists+stable@lfdr.de>; Wed, 24 Mar 2021 18:22:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237083AbhCXRVb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Mar 2021 13:21:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:50680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237064AbhCXRVN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Mar 2021 13:21:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E1BD61A15;
        Wed, 24 Mar 2021 17:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616606473;
        bh=j6Z+E/Z93szItTThM2X88ad/uJAIBOKNMYjWIpCcd90=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OUBnS9RNEQ1I2I6jeIAAuBEdeey/t08Fygstth6vU1aAs3ErjHcH61Nyx7hspG0IB
         BSQUzSBs82yTTvwN+tyJcG7YQFsaw+zRF9a61Yn26AfvtvUqmZTkqnxrHPQlPFbJbS
         IQEJqjrd6sZMYArwK1IrUOo/Tr3JWbDjrg3CmrW4=
Date:   Wed, 24 Mar 2021 18:21:11 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Miles Chen =?utf-8?B?KOmZs+awkeaouik=?= 
        <miles.chen@mediatek.com>, mike.kravetz@oracle.com,
        Nathan Chancellor <nathan@kernel.org>, dbueso@suse.de,
        Andrew Morton <akpm@linux-foundation.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Subject: Re: please pick 552546366a30 to 5.4.y
Message-ID: <YFt1Bx32z8UiLJcl@kroah.com>
References: <CAKwvOdmCpMf1Zp3tB=oqse6-Bsm_ybJQ=G5h__kEuOa47CjBHg@mail.gmail.com>
 <YFtxnlHk4TLqtP5z@kroah.com>
 <CAKwvOd=2k_NaC1U9MwNHzfCHAfhwi55fyoTa+AHFM=drh9d3Ng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOd=2k_NaC1U9MwNHzfCHAfhwi55fyoTa+AHFM=drh9d3Ng@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 24, 2021 at 10:09:08AM -0700, Nick Desaulniers wrote:
> On Wed, Mar 24, 2021 at 10:06 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Wed, Mar 24, 2021 at 09:47:49AM -0700, Nick Desaulniers wrote:
> > > Dear stable kernel maintainers,
> > > Please consider cherry-picking
> > > commit 552546366a30 ("hugetlbfs: hugetlb_fault_mutex_hash() cleanup")
> > > to linux-5.4.y.  It first landed in v5.5-rc1 and fixes an instance of
> > > the warning -Wsizeof-array-div.
> >
> > What shows that warning?  I don't see it here with my gcc builds :)
> 
> $ make LLVM=1 -j72 defconfig
> $ ./scripts/config -e CONFIG_HUGETLBFS
> $ make LLVM=1 -j72 mm/hugetlb.o
> ...
>   CC      mm/hugetlb.o
> mm/hugetlb.c:4159:40: warning: expression does not compute the number
> of elements in this array; element type is 'unsigned long', not 'u32'
> (aka 'unsigned int') [-Wsizeof-array-div]
>         hash = jhash2((u32 *)&key, sizeof(key)/sizeof(u32), 0);
>                                           ~~~ ^
> mm/hugetlb.c:4153:16: note: array 'key' declared here
>         unsigned long key[2];
>                       ^
> mm/hugetlb.c:4159:40: note: place parentheses around the 'sizeof(u32)'
> expression to silence this warning
>         hash = jhash2((u32 *)&key, sizeof(key)/sizeof(u32), 0);
>                                               ^

Ok, will queue it up, thanks.

greg k-h
