Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85B1F2D5722
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 10:30:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726313AbgLJJ2g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 04:28:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:38984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726763AbgLJJ2f (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 04:28:35 -0500
Date:   Thu, 10 Dec 2020 10:29:09 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607592474;
        bh=9IBGE7YExpBUElirt6uWH7rWMH+57P9GaY6SS3rQU1k=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=qY5DJbue3kOO4ieeWJO79wbG8Pr/Dlgx50r4S6Ki7OrXc/Drj0uHpOZfs1OEPsQjP
         XVmgGZlyqPEnL1zxrDXgmYAvHsvC6VdJLofAa3tNB40G+FOlQTA8/k7r3o915Wr0FQ
         Cw+5C1Jqhi5eFc4Tns+qeTWz0p0yS9AphA3iZiEM=
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mike Rapoport <rppt@kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Baoquan He <bhe@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@kernel.org>,
        Mike Rapoport <rppt@linux.ibm.com>, Qian Cai <cai@lca.pw>,
        Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/2] mm: fix initialization of struct page for holes
 in memory layout
Message-ID: <X9HqZZsCalKVMkix@kroah.com>
References: <20201209214304.6812-1-rppt@kernel.org>
 <20201209214304.6812-3-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201209214304.6812-3-rppt@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 09, 2020 at 11:43:04PM +0200, Mike Rapoport wrote:
> From: Mike Rapoport <rppt@linux.ibm.com>
> 
> There could be struct pages that are not backed by actual physical memory.
> This can happen when the actual memory bank is not a multiple of
> SECTION_SIZE or when an architecture does not register memory holes
> reserved by the firmware as memblock.memory.
> 
> Such pages are currently initialized using init_unavailable_mem() function
> that iterated through PFNs in holes in memblock.memory and if there is a
> struct page corresponding to a PFN, the fields if this page are set to
> default values and it is marked as Reserved.
> 
> init_unavailable_mem() does not take into account zone and node the page
> belongs to and sets both zone and node links in struct page to zero.
> 
> On a system that has firmware reserved holes in a zone above ZONE_DMA, for
> instance in a configuration below:
> 
> 	# grep -A1 E820 /proc/iomem
> 	7a17b000-7a216fff : Unknown E820 type
> 	7a217000-7bffffff : System RAM
> 
> unset zone link in struct page will trigger
> 
> 	VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn), page);
> 
> because there are pages in both ZONE_DMA32 and ZONE_DMA (unset zone link in
> struct page) in the same pageblock.
> 
> Interleave initialization of pages that correspond to holes with the
> initialization of memory map, so that zone and node information will be
> properly set on such pages.
> 
> Fixes: 73a6e474cb37 ("mm: memmap_init: iterate over memblock regions rather
> that check each PFN")
> Reported-by: Andrea Arcangeli <aarcange@redhat.com>
> Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
> ---
>  mm/page_alloc.c | 152 +++++++++++++++++++++---------------------------
>  1 file changed, 65 insertions(+), 87 deletions(-)


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
