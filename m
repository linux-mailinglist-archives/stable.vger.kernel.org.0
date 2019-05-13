Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 983FB1B26D
	for <lists+stable@lfdr.de>; Mon, 13 May 2019 11:12:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728542AbfEMJMP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 May 2019 05:12:15 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:56162 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726132AbfEMJMP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 May 2019 05:12:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=FhRnavH5ISIIL5pl8TyT+ztasWjBJfJsuvguEoKrBnk=; b=EvAbLVwUdc20zwJRefzd8QXJc
        xGFN34vOXzCUBVBHMhCvseLFXe61OQl6jTYmI2IpoiF9NNOUAeidWxIdaXszHhOK2X4r7hDNLaykV
        49pGvyK6Pe3kV8vOdLD5SMVPTkx4njIp7Rjq3/I8BEcLabvbNulz/3l6BHOJmklPrznaTshp+UpOx
        kFaXb295xKAyC0BS5R96yYYxOexobeYwZNvi69E7DTKFRtFrA6aEZjbLlEMYOW6EcWGUYJUNjOC4y
        TQcZWQE/WrzhWeSjXI8wcoe0LHeXtYXIZBSUhs9LnSBw9IViT06alNECta0qlYxO7RU5kHB8K3q93
        RAjmE9aqg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hQ70B-0002mG-NM; Mon, 13 May 2019 09:12:07 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id DB1D02029F888; Mon, 13 May 2019 11:12:05 +0200 (CEST)
Date:   Mon, 13 May 2019 11:12:05 +0200
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
Message-ID: <20190513091205.GO2650@hirez.programming.kicks-ass.net>
References: <1557264889-109594-1-git-send-email-yang.shi@linux.alibaba.com>
 <20190509083726.GA2209@brain-police>
 <20190509103813.GP2589@hirez.programming.kicks-ass.net>
 <F22533A7-016F-4506-809A-7E86BAF24D5A@vmware.com>
 <20190509182435.GA2623@hirez.programming.kicks-ass.net>
 <04668E51-FD87-4D53-A066-5A35ABC3A0D6@vmware.com>
 <20190509191120.GD2623@hirez.programming.kicks-ass.net>
 <7DA60772-3EE3-4882-B26F-2A900690DA15@vmware.com>
 <20190513083606.GL2623@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190513083606.GL2623@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 13, 2019 at 10:36:06AM +0200, Peter Zijlstra wrote:
> On Thu, May 09, 2019 at 09:21:35PM +0000, Nadav Amit wrote:
> > It may be possible to avoid false-positive nesting indications (when the
> > flushes do not overlap) by creating a new struct mmu_gather_pending, with
> > something like:
> > 
> >   struct mmu_gather_pending {
> >  	u64 start;
> > 	u64 end;
> > 	struct mmu_gather_pending *next;
> >   }
> > 
> > tlb_finish_mmu() would then iterate over the mm->mmu_gather_pending
> > (pointing to the linked list) and find whether there is any overlap. This
> > would still require synchronization (acquiring a lock when allocating and
> > deallocating or something fancier).
> 
> We have an interval_tree for this, and yes, that's how far I got :/
> 
> The other thing I was thinking of is trying to detect overlap through
> the page-tables themselves, but we have a distinct lack of storage
> there.

We might just use some state in the pmd, there's still 2 _pt_pad_[12] in
struct page to 'use'. So we could come up with some tlb generation
scheme that would detect conflict.
