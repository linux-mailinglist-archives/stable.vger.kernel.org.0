Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1092F3F6C
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 01:46:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438468AbhALWrE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 17:47:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:33980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436769AbhALWrE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 17:47:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3B4A230F9;
        Tue, 12 Jan 2021 22:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610491583;
        bh=Rqin12tOcaSlTV0JXx5zAMTAIc0/hFy8RZqaB/MNwdY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Cg8lDoFec4nxn4ii7SgesxmcAdK/ZNLOi6F8E53v1gyb6dhcaSQ3/EepChN1EE7ri
         PdHcEkZ4wmBKZVHZXlAR0Axg/WiQVXdc9BAgfZlNjb4rGDaiu4kRyocGIMv/T7wBMR
         MxflRnIiu+vwQRcw+whzQ6OjfrlMmmT5Oa4PGt+Mx/IwfxlQzhohMkWUbRi3u6hd1q
         Wba5BkCe3gusMjnr7aThGGrqpYpkTjqDM+ezRikDJbRcfCFU/zxb4n4Tt7PawBBTnr
         bIEh4ze/hUCI1EpS+8TP0sdQx+TIiTj/9ChoepX5Fy9MB5aenX7Gf61IBY9dTCarAp
         eMmy7vyDn1kNA==
Date:   Tue, 12 Jan 2021 22:46:17 +0000
From:   Will Deacon <will@kernel.org>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Yu Zhao <yuzhao@google.com>,
        Laurent Dufour <ldufour@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Vinayak Menon <vinmenon@codeaurora.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Xu <peterx@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>, surenb@google.com
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
Message-ID: <20210112224616.GA10512@willie-the-truck>
References: <20210105153727.GK3040@hirez.programming.kicks-ass.net>
 <bfb1cbe6-a705-469d-c95a-776624817e33@codeaurora.org>
 <0201238b-e716-2a3c-e9ea-d5294ff77525@linux.vnet.ibm.com>
 <X/3VE64nr91WCtuM@hirez.programming.kicks-ass.net>
 <ec912505-ed4d-a45d-2ed4-7586919da4de@linux.vnet.ibm.com>
 <C7D5A74C-25BF-458A-AAD9-61E484B9F225@gmail.com>
 <X/3+6ZnRCNOwhjGT@google.com>
 <2C7AE23B-ACA3-4D55-A907-AF781C5608F0@gmail.com>
 <20210112214337.GA10434@willie-the-truck>
 <F33D2DD9-97D5-44A0-890B-35FE686E36DC@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F33D2DD9-97D5-44A0-890B-35FE686E36DC@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 12, 2021 at 02:29:51PM -0800, Nadav Amit wrote:
> > On Jan 12, 2021, at 1:43 PM, Will Deacon <will@kernel.org> wrote:
> > 
> > On Tue, Jan 12, 2021 at 12:38:34PM -0800, Nadav Amit wrote:
> >>> On Jan 12, 2021, at 11:56 AM, Yu Zhao <yuzhao@google.com> wrote:
> >>> On Tue, Jan 12, 2021 at 11:15:43AM -0800, Nadav Amit wrote:
> >>>> I will send an RFC soon for per-table deferred TLB flushes tracking.
> >>>> The basic idea is to save a generation in the page-struct that tracks
> >>>> when deferred PTE change took place, and track whenever a TLB flush
> >>>> completed. In addition, other users - such as mprotect - would use
> >>>> the tlb_gather interface.
> >>>> 
> >>>> Unfortunately, due to limited space in page-struct this would only
> >>>> be possible for 64-bit (and my implementation is only for x86-64).
> >>> 
> >>> I don't want to discourage you but I don't think this would end up
> >>> well. PPC doesn't necessarily follow one-page-struct-per-table rule,
> >>> and I've run into problems with this before while trying to do
> >>> something similar.
> >> 
> >> Discourage, discourage. Better now than later.
> >> 
> >> It will be relatively easy to extend the scheme to be per-VMA instead of
> >> per-table for architectures that prefer it this way. It does require
> >> TLB-generation tracking though, which Andy only implemented for x86, so I
> >> will focus on x86-64 right now.
> > 
> > Can you remind me of what we're missing on arm64 in this area, please? I'm
> > happy to help get this up and running once you have something I can build
> > on.
> 
> Let me first finish making something that we can use as a basis for a
> discussion. I do not waste your time before I have something ready.

Sure thing! Give me a shout when you're ready.

Will
