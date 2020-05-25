Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E187E1E1235
	for <lists+stable@lfdr.de>; Mon, 25 May 2020 17:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404126AbgEYP6f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 May 2020 11:58:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:56426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404076AbgEYP6e (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 May 2020 11:58:34 -0400
Received: from kernel.org (unknown [87.70.212.59])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1635F2071A;
        Mon, 25 May 2020 15:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590422313;
        bh=wiDKEyw484GXmzSpZVclCFGRQEPFTvq5irNs419nfE4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aJELzVEPKY+5KMeo8hwIzuqSdQOIGJRHj/t/iF3JINZEsAtYxfFOUSrWPkz21CKEb
         B3vg9eQI7Das73bdaUmYck2p+l4ymM+jeed8WASz0bR5SGfs0HEDOf2iFB+RvIlCur
         jJA4oOH7cASC0Bl1E46qbLND7ovDEJmEy0zytSs4=
Date:   Mon, 25 May 2020 18:58:25 +0300
From:   Mike Rapoport <rppt@kernel.org>
To:     "Kirill A. Shutemov" <kirill@shutemov.name>
Cc:     "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Tony Luck <tony.luck@intel.com>, x86@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Dave Hansen <dave.hansen@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH] x86/mm: Fix boot with some memory above MAXMEM
Message-ID: <20200525155825.GB13247@kernel.org>
References: <20200511191721.1416-1-kirill.shutemov@linux.intel.com>
 <20200525044902.rsb46bxu5hdsqglt@box>
 <20200525145943.GA13247@kernel.org>
 <20200525150820.zljiamptpzi37ohx@box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200525150820.zljiamptpzi37ohx@box>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 25, 2020 at 06:08:20PM +0300, Kirill A. Shutemov wrote:
> On Mon, May 25, 2020 at 05:59:43PM +0300, Mike Rapoport wrote:
> > On Mon, May 25, 2020 at 07:49:02AM +0300, Kirill A. Shutemov wrote:
> > > On Mon, May 11, 2020 at 10:17:21PM +0300, Kirill A. Shutemov wrote:
> > > > A 5-level paging capable machine can have memory above 46-bit in the
> > > > physical address space. This memory is only addressable in the 5-level
> > > > paging mode: we don't have enough virtual address space to create direct
> > > > mapping for such memory in the 4-level paging mode.
> > > > 
> > > > Currently, we fail boot completely: NULL pointer dereference in
> > > > subsection_map_init().
> > > > 
> > > > Skip creating a memblock for such memory instead and notify user that
> > > > some memory is not addressable.
> > > > 
> > > > Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > > > Reviewed-by: Dave Hansen <dave.hansen@intel.com>
> > > > Cc: stable@vger.kernel.org # v4.14
> > > > ---
> > > 
> > > Gentle ping.
> > > 
> > > It's not urgent, but it's a bug fix. Please consider applying.
> > > 
> > > > Tested with a hacked QEMU: https://gist.github.com/kiryl/d45eb54110944ff95e544972d8bdac1d
> > > > 
> > > > ---
> > > >  arch/x86/kernel/e820.c | 19 +++++++++++++++++--
> > > >  1 file changed, 17 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
> > > > index c5399e80c59c..d320d37d0f95 100644
> > > > --- a/arch/x86/kernel/e820.c
> > > > +++ b/arch/x86/kernel/e820.c
> > > > @@ -1280,8 +1280,8 @@ void __init e820__memory_setup(void)
> > > >  
> > > >  void __init e820__memblock_setup(void)
> > > >  {
> > > > +	u64 size, end, not_addressable = 0;
> > > >  	int i;
> > > > -	u64 end;
> > > >  
> > > >  	/*
> > > >  	 * The bootstrap memblock region count maximum is 128 entries
> > > > @@ -1307,7 +1307,22 @@ void __init e820__memblock_setup(void)
> > > >  		if (entry->type != E820_TYPE_RAM && entry->type != E820_TYPE_RESERVED_KERN)
> > > >  			continue;
> > > >  
> > > > -		memblock_add(entry->addr, entry->size);
> > > > +		if (entry->addr >= MAXMEM) {
> > > > +			not_addressable += entry->size;
> > > > +			continue;
> > > > +		}
> > > > +
> > > > +		end = min_t(u64, end, MAXMEM - 1);
> > > > +		size = end - entry->addr;
> > > > +		not_addressable += entry->size - size;
> > > > +		memblock_add(entry->addr, size);
> > > > +	}
> > > > +
> > > > +	if (not_addressable) {
> > > > +		pr_err("%lldGB of physical memory is not addressable in the paging mode\n",
> > > > +		       not_addressable >> 30);
> > > > +		if (!pgtable_l5_enabled())
> > > > +			pr_err("Consider enabling 5-level paging\n");
> > 
> > Could this happen at all when l5 is enabled?
> > Does it mean we need kmap() for 64-bit?
> 
> It's future-profing. Who knows what paging modes we would have in the
> future.

Than maybe

	pr_err("%lldGB of physical memory is not addressable in %s the paging mode\n",
               not_addressable >> 30, pgtable_l5_enabled() "5-level" ? "4-level");

"the paging mode" on its own sounds a bit awkward to me.

> -- 
>  Kirill A. Shutemov

-- 
Sincerely yours,
Mike.
