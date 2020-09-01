Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFA38258FB7
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 16:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728229AbgIAOAe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 10:00:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:50182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728142AbgIAN7w (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 09:59:52 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F57E206EF;
        Tue,  1 Sep 2020 13:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598968791;
        bh=L8d1DCremfnBG5eZMtHhbtp3tiFhxrUx4EdWmT14ZPQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Uu8ClbbZEJr0m2EW4kq0vvjxia5hgQa8O2H8CmKG0m5hijMg/NXbxywHjAIrA3z4T
         OQEWroFg/GM8meUNbyzokcfPT6Saq5JNpLOYWSHYfoDZjDS08+NV69RD2I19FFMnnL
         umIlwt3rm/4jxGKudlHSGjawsFxcvoJhgT47FG/A=
Date:   Tue, 1 Sep 2020 16:00:18 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Doug Berger <opendmb@gmail.com>
Cc:     stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Pavel Tatashin <pasha.tatashin@oracle.com>,
        Russell King <linux@armlinux.org.uk>,
        Michal Hocko <mhocko@kernel.org>,
        Olof Johansson <olof@lixom.net>,
        Zhaoyang Huang <zhaoyang.huang@unisoc.com>,
        zhaoyang <huangzhaoyang@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Baoquan He <bhe@redhat.com>
Subject: Re: RFC: backport of commit a32c1c61212d
Message-ID: <20200901140018.GD397411@kroah.com>
References: <bd960a80-c953-ad11-cdfd-1e48ffdce443@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd960a80-c953-ad11-cdfd-1e48ffdce443@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 25, 2020 at 03:58:27PM -0700, Doug Berger wrote:
> I recently tracked down a problem I observed when booting a v5.4 kernel
> on a sparsemem UMA arm platform which includes a no-map reserved-memory
> region in the middle of its HighMem zone.
> 
> When memmap_init_zone() is invoked the pfn's that correspond to the
> no-map region fail the early_pfn_valid() check and the struct page
> structures are not initialized creating a "hole" in the memmap. Later in
> my boot sequence the sock_init() initcall leads to a bpf_prog_alloc()
> which ends up stealing a page from the block containing the no-map
> region which then leads to a call of move_freepages_block() to
> reclassify the migratetype of the entire block.
> 
> The function move_freepages() includes a check of pfn_valid_within for
> each page in the range, but since the arm architecture doesn't include
> HOLES_IN_ZONE this check is optimized out and the uninitialized struct
> page is accessed. Specifically, PageLRU() calls compound_head() on the
> page and if the page->compound_head value is odd the value is used as a
> pointer to the head struct page. For uninitialized memory there is a
> high chance that a random value of compound head will be odd and contain
> an invalid pointer value that causes the kernel to abort and panic.
> 
> As you might imagine specifying HOLES_IN_ZONE for the arm build allows
> pfn_valid_within to protect against accessing the uninitialized struct
> page. However, the performance penalty this incurs seems unnecessary.
> 
> Commit 35fd1eb1e821 ("mm/sparse: abstract sparse buffer allocations") as
> part of the "sparse_init rewrite" series introduced in v4.19 changed the
> way sparsemem memmaps are initialized. Prior to this patch the sparsemem
> memmaps are initialized to all 0's. I observed that on older kernels the
> "uninitialized" struct page access also occurs, but the 0
> page->compound_head indicates no compound head and the page pointer is
> therefore not corrupted. The other logic ends up causing the page to be
> skipped and everything "happens to work".
> 
> While considering solutions to this issue I observed that the problem
> does not occur in the current upstream as a result of a combination of
> other commits. The following commits provided functionality to
> initialize struct page structures for pages that are unavailable like
> the no-map region in my system:
> commit a4a3ede2132a ("mm: zero reserved and unavailable struct pages")
> commit 907ec5fca3dc ("mm: zero remaining unavailable struct pages")
> commit ec393a0f014e ("mm: return zero_resv_unavail optimization")
> commit e822969cab48 ("mm/page_alloc.c: fix uninitialized memmaps on a
> partially populated last section")
> commit 4b094b7851bf ("mm/page_alloc.c: initialize memmap of unavailable
> memory directly")
> 
> However, those commits added the functionality to the free_area_init()
> and free_area_init_nodes() functions and the non-NUMA arm architecture
> did not begin calling free_area_init() until the following commit in v5.8:
> commit a32c1c61212d ("arm: simplify detection of memory zone boundaries")
> 
> Prior to that commit the non-NUMA arm architecture called
> free_area_init_node() directly at the end of zone_sizes_init().
> 
> So while the problem appears to be fixed upstream by commit a32c1c61212d
> ("arm: simplify detection of memory zone boundaries") it is still
> present in stable branches between v4.19.y and v5.7.y inclusive and
> probably for architectures other than arm as well that didn't call
> free_area_init(). This upstream commit is not easily/safely backportable
> to stable branches, but if we focus on the sliver of functionality that
> adds the initialization code from free_area_init() to the
> zones_sizes_init() function used by non-NUMA arm kernels I believe a
> simple patch could be developed for each relevant stable branch to
> resolve the issue I am observing. Similar patches could also be applied
> for other architectures that now call free_area_init() upstream but not
> in one of these stable branches, but I am not in a position to test
> those architectures.
> 
> For the linux-5.4.y branch such a patch might look like this:
> >From 671c341b5cdb8360349c33ade43115e28ca56a8a Mon Sep 17 00:00:00 2001
> From: Doug Berger <opendmb@gmail.com>
> Date: Tue, 25 Aug 2020 14:39:43 -0700
> Subject: [PATCH] ARM: mm: sync zone_sizes_init with free_area_init
> 
> The arm architecture does not invoke the common function
> free_area_init(). Instead for non-NUMA builds it invokes
> free_area_init_node() directly from zone_sizes_init().
> 
> As a result recent changes in free_area_init() are not
> picked up by arm architecture builds.
> 
> This commit adds the updates to the zone_sizes_init()
> function to achieve parity with the free_area_init()
> functionality.
> 
> Fixes: 35fd1eb1e821 ("mm/sparse: abstract sparse buffer allocations")
> Signed-off-by: Doug Berger <opendmb@gmail.com>
> Cc: stable@vger.kernel.org
> ---
>  arch/arm/mm/init.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
> index 6f19ba53fd1f..4f171d834c60 100644
> --- a/arch/arm/mm/init.c
> +++ b/arch/arm/mm/init.c
> @@ -169,6 +169,7 @@ static void __init zone_sizes_init(unsigned long
> min, unsigned long max_low,
>                         arm_dma_zone_size >> PAGE_SHIFT);
>  #endif
> 
> +       zero_resv_unavail();
>         free_area_init_node(0, zone_size, min, zhole_size);
>  }
> 
> -- 
> 2.7.4
> 
> I am unclear of the mechanics for submitting such a stable patch when it
> represents a perhaps less than obvious sliver of the upstream commit
> that fixes the issue, so I am soliciting guidance with this email.
> 
> Thank you for taking the time to read this far, and please let me know
> how I can improve the situation,

I'm confused, what exactly are you asking for here?  Is there a specific
commit you wish to see backported to the 5.4 kernel, or are you trying
to say you want something that is not in Linus's tree, backported
instead?

thanks,

greg k-h
