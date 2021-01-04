Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D4702E9513
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 13:42:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726129AbhADMmI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 07:42:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:33958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726124AbhADMmH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 07:42:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BFF6A20770;
        Mon,  4 Jan 2021 12:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609764087;
        bh=k+ALmKQOX1HWwUSlFT0WUOPs7eBZFWQDb63EdX0IGfo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j5mRSoFk/SRMZGzB2dAgeklNXo8JkPrtPeIEIb6QB/feSw6tNt5S2xpM4EBr17Gs5
         LxlZjHkwuPF4UbRzWP8UEtLboDRRmzgfGkTadwxMVzcWI5N5NjtsSgVeFs+tPGP0Ve
         hIhFeasG0uwx9qpuUFJ0l2+NDrenUBH1EPgPCS7w=
Date:   Mon, 4 Jan 2021 13:42:53 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pavel Tatashin <pasha.tatashin@soleen.com>
Cc:     stable@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com,
        dan.j.williams@intel.com, shile.zhang@linux.alibaba.com,
        daniel.m.jordan@oracle.com, ktkhai@virtuozzo.com, david@redhat.com,
        jmorris@namei.org, sashal@kernel.org, vbabka@suse.cz,
        torvalds@linux-foundation.org
Subject: Re: [PATCH 4.19 1/7] mm: drop meminit_pfn_in_nid as it is redundant
Message-ID: <X/MNTd+aL2Tj2hV9@kroah.com>
References: <20200619132425.425063-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200619132425.425063-1-pasha.tatashin@soleen.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 19, 2020 at 09:24:19AM -0400, Pavel Tatashin wrote:
> From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> 
> From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> 
> commit 56ec43d8b02719402c9fcf984feb52ec2300f8a5 upstream.
> 
> As best as I can tell the meminit_pfn_in_nid call is completely redundant.
> The deferred memory initialization is already making use of
> for_each_free_mem_range which in turn will call into __next_mem_range
> which will only return a memory range if it matches the node ID provided
> assuming it is not NUMA_NO_NODE.
> 
> I am operating on the assumption that there are no zones or pgdata_t
> structures that have a NUMA node of NUMA_NO_NODE associated with them.  If
> that is the case then __next_mem_range will never return a memory range
> that doesn't match the zone's node ID and as such the check is redundant.
> 
> So one piece I would like to verify on this is if this works for ia64.
> Technically it was using a different approach to get the node ID, but it
> seems to have the node ID also encoded into the memblock.  So I am
> assuming this is okay, but would like to get confirmation on that.
> 
> On my x86_64 test system with 384GB of memory per node I saw a reduction
> in initialization time from 2.80s to 1.85s as a result of this patch.
> 
> Link: http://lkml.kernel.org/r/20190405221219.12227.93957.stgit@localhost.localdomain
> Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> Reviewed-by: Pavel Tatashin <pavel.tatashin@microsoft.com>
> Acked-by: Michal Hocko <mhocko@suse.com>
> Cc: Mike Rapoport <rppt@linux.ibm.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Khalid Aziz <khalid.aziz@oracle.com>
> Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> Cc: Laurent Dufour <ldufour@linux.vnet.ibm.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Mel Gorman <mgorman@techsingularity.net>
> Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
> Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: <yi.z.zhang@linux.intel.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Pavel Tatashin <pasha.tatashin@soleen.com>
> ---
>  mm/page_alloc.c | 51 ++++++++++++++-----------------------------------
>  1 file changed, 14 insertions(+), 37 deletions(-)

Given the recent changes backported to 4.19.y, is this series still
needed?

If so, can you please regenerate it and resend as it does not apply to
the current 4.19.y tree.

thanks,

greg k-h
