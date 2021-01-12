Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDCF12F3DB1
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 01:44:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393435AbhALVos (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 16:44:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:42982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393396AbhALVoY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 16:44:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7203B23125;
        Tue, 12 Jan 2021 21:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610487824;
        bh=fUc8zKy8QlIlGEn9mAZ3xsP8Aqf0/jWjU6oHB+NFKLk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=c05oLJZEd+FTQqLS2Eo2hfjCAn+G7eZBr7dKYa2riIT7G3/vBgp4ZcsKCHc0Lra1y
         8tLY3R1LmgQhja73U7CL6SuyGpVBTADjcIwpbA446H40FAhv5tbgOYxGnQ04qwftMs
         JvGV0Bz5ZbjKf8H4Mj7NOtogrhbFLMrkLShWm8JfXuZGrVu4Q68Hl2WwhKsyRZjhrv
         8olhyunFuPBSprrKUicpL3M4iYfP9jKbXyzTDM9NnpM8puXTyLIN9LE6cnfYzwq2BZ
         GHADmqR6C8LEm5jNT4fdY474RwN7wo8jMwipU+LnbbTQZob5VpEIdtTi469g+pLQJG
         eG85eCwVIFG+A==
Date:   Tue, 12 Jan 2021 21:43:38 +0000
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
Message-ID: <20210112214337.GA10434@willie-the-truck>
References: <CALCETrV=8tY7h=aaudWBEn-MJnNkm2wz5qjH49SYqwkjYTpOaA@mail.gmail.com>
 <CAHk-=wj=CcOHQpG0cUGfoMCt2=Uaifpqq-p-mMOmW8XmrBn4fQ@mail.gmail.com>
 <20210105153727.GK3040@hirez.programming.kicks-ass.net>
 <bfb1cbe6-a705-469d-c95a-776624817e33@codeaurora.org>
 <0201238b-e716-2a3c-e9ea-d5294ff77525@linux.vnet.ibm.com>
 <X/3VE64nr91WCtuM@hirez.programming.kicks-ass.net>
 <ec912505-ed4d-a45d-2ed4-7586919da4de@linux.vnet.ibm.com>
 <C7D5A74C-25BF-458A-AAD9-61E484B9F225@gmail.com>
 <X/3+6ZnRCNOwhjGT@google.com>
 <2C7AE23B-ACA3-4D55-A907-AF781C5608F0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2C7AE23B-ACA3-4D55-A907-AF781C5608F0@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 12, 2021 at 12:38:34PM -0800, Nadav Amit wrote:
> > On Jan 12, 2021, at 11:56 AM, Yu Zhao <yuzhao@google.com> wrote:
> > On Tue, Jan 12, 2021 at 11:15:43AM -0800, Nadav Amit wrote:
> >> I will send an RFC soon for per-table deferred TLB flushes tracking.
> >> The basic idea is to save a generation in the page-struct that tracks
> >> when deferred PTE change took place, and track whenever a TLB flush
> >> completed. In addition, other users - such as mprotect - would use
> >> the tlb_gather interface.
> >> 
> >> Unfortunately, due to limited space in page-struct this would only
> >> be possible for 64-bit (and my implementation is only for x86-64).
> > 
> > I don't want to discourage you but I don't think this would end up
> > well. PPC doesn't necessarily follow one-page-struct-per-table rule,
> > and I've run into problems with this before while trying to do
> > something similar.
> 
> Discourage, discourage. Better now than later.
> 
> It will be relatively easy to extend the scheme to be per-VMA instead of
> per-table for architectures that prefer it this way. It does require
> TLB-generation tracking though, which Andy only implemented for x86, so I
> will focus on x86-64 right now.

Can you remind me of what we're missing on arm64 in this area, please? I'm
happy to help get this up and running once you have something I can build
on.

Will
