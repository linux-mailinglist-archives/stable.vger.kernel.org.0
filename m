Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E01F1B4E2
	for <lists+stable@lfdr.de>; Mon, 13 May 2019 13:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728460AbfEML12 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 May 2019 07:27:28 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53676 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726866AbfEML12 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 May 2019 07:27:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=QlLTDpUw3LQEBrJUE4pLazn/f1TqZvICJfFNqlHW/BQ=; b=IwWEzplkAkvkiV39U9/PKkoJb
        Mbh2qFemubE06kI3RAvtqVE74136gc9EF11rwqkOIOqh3/Zllt/rNxayUsNYx6Yj8YS0buszvdTIM
        Oq52Pqhn1KbDNJdTxbEQ422JPZew+5gXySaIlAa/rb9C1GdAjiksksYWL51W/r5Hso54fqJLiFOl4
        2M4jC9VETnBTqBXWBiKdZWNGoC6oDaUtY6skxz7RpfawLsiEltTDWKsYd8p7rf9LOdhi6mI5GoZBb
        mvTgrr+48M9/o80HvkCIe6Jk4fUIuU/z1rUoPxpqQo3zTyOR4J6/ryDq//uAqZ1NGHDLwtnhHKe+T
        dPYpqSBng==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hQ96x-0006dy-89; Mon, 13 May 2019 11:27:16 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 7CB452029F87D; Mon, 13 May 2019 13:27:12 +0200 (CEST)
Date:   Mon, 13 May 2019 13:27:12 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Nadav Amit <namit@vmware.com>
Cc:     Yang Shi <yang.shi@linux.alibaba.com>,
        "jstancek@redhat.com" <jstancek@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.vnet.ibm.com>,
        Nick Piggin <npiggin@gmail.com>,
        Minchan Kim <minchan@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH] mm: mmu_gather: remove __tlb_reset_range() for force
 flush
Message-ID: <20190513112712.GO2623@hirez.programming.kicks-ass.net>
References: <20190509083726.GA2209@brain-police>
 <20190509103813.GP2589@hirez.programming.kicks-ass.net>
 <F22533A7-016F-4506-809A-7E86BAF24D5A@vmware.com>
 <20190509182435.GA2623@hirez.programming.kicks-ass.net>
 <04668E51-FD87-4D53-A066-5A35ABC3A0D6@vmware.com>
 <20190509191120.GD2623@hirez.programming.kicks-ass.net>
 <7DA60772-3EE3-4882-B26F-2A900690DA15@vmware.com>
 <20190513083606.GL2623@hirez.programming.kicks-ass.net>
 <20190513091205.GO2650@hirez.programming.kicks-ass.net>
 <847D4C2F-BD26-4BE0-A5BA-3C690D11BF77@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <847D4C2F-BD26-4BE0-A5BA-3C690D11BF77@vmware.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 13, 2019 at 09:21:01AM +0000, Nadav Amit wrote:
> > On May 13, 2019, at 2:12 AM, Peter Zijlstra <peterz@infradead.org> wrote:

> >> The other thing I was thinking of is trying to detect overlap through
> >> the page-tables themselves, but we have a distinct lack of storage
> >> there.
> > 
> > We might just use some state in the pmd, there's still 2 _pt_pad_[12] in
> > struct page to 'use'. So we could come up with some tlb generation
> > scheme that would detect conflict.
> 
> It is rather easy to come up with a scheme (and I did similar things) if you
> flush the table while you hold the page-tables lock. But if you batch across
> page-tables it becomes harder.

Yeah; finding that out now. I keep finding holes :/

> Thinking about it while typing, perhaps it is simpler than I think - if you
> need to flush range that runs across more than a single table, you are very
> likely to flush a range of more than 33 entries, so anyhow you are likely to
> do a full TLB flush.

We can't rely on the 33, that x86 specific. Other architectures can have
another (or no) limit on that.

> So perhaps just avoiding the batching if only entries from a single table
> are flushed would be enough.

That's near to what Will suggested initially, just flush the entire
thing when there's a conflict.
