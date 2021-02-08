Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D783C31415D
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 22:12:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235206AbhBHVLt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 16:11:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:60726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234822AbhBHVLp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 16:11:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6A8C64E45;
        Mon,  8 Feb 2021 21:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612818662;
        bh=rw1M/5Z9nW1OXLXxGPke2t4Sf5KHR4/hWloUz77521A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=2a2mx7n3FKjwwpdOwk8iNmm4Q44kNg+z3ogc4HeFgLbmy/iFjO2aZGXrpgUNJf6hX
         pbfDUi8vHUc14crCNpbXM6YfZja8m7yxLirMvWPC459Gca3QYSBHJbxPKnewm5zxwu
         BHWTY6NSNGUbUWAvN+0tDNb9rRPaRu5tnWRc6TGQ=
Date:   Mon, 8 Feb 2021 13:11:00 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Mike Rapoport <rppt@kernel.org>
Cc:     Andrea Arcangeli <aarcange@redhat.com>,
        Baoquan He <bhe@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        David Hildenbrand <david@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        =?UTF-8?Q?=C5=81ukasz?= Majczak <lma@semihalf.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@kernel.org>,
        Mike Rapoport <rppt@linux.ibm.com>, Qian Cai <cai@lca.pw>,
        "Sarvela, Tomi P" <tomi.p.sarvela@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, stable@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v5 1/1] mm: refactor initialization of struct page for
 holes in memory layout
Message-Id: <20210208131100.7273d249a5d00cac0d247fcf@linux-foundation.org>
In-Reply-To: <20210208110820.6269-1-rppt@kernel.org>
References: <20210208110820.6269-1-rppt@kernel.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon,  8 Feb 2021 13:08:20 +0200 Mike Rapoport <rppt@kernel.org> wrote:

> There could be struct pages that are not backed by actual physical memory.
> This can happen when the actual memory bank is not a multiple of
> SECTION_SIZE or when an architecture does not register memory holes
> reserved by the firmware as memblock.memory.
> 
> Such pages are currently initialized using init_unavailable_mem() function
> that iterates through PFNs in holes in memblock.memory and if there is a
> struct page corresponding to a PFN, the fields of this page are set to
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
> because there are pages in both ZONE_DMA32 and ZONE_DMA (unset zone link
> in struct page) in the same pageblock.
> 
> ...
>
> 
> Fixes: 73a6e474cb37 ("mm: memmap_init: iterate over memblock regions rather
> that check each PFN")

What are your thoughts on the priority of this (rather large!) fix? 
Are such systems sufficiently common to warrant a 5.11 merge?  -stable?
