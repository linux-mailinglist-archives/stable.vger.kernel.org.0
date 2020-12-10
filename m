Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECA882D5080
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 02:54:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbgLJBwv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 20:52:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49606 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726570AbgLJBws (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Dec 2020 20:52:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607565081;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yatyL7brUpdT9nN7wHFOuWownO2RnkXmQv5daJIQu4Q=;
        b=XVzTJ/SXYwfCgh5a1SsPqAbxQT7Uldn7LuyfUUwcDsQQbxnlCfEOlFbLsu8LhpZzZzQX35
        4zO/s7P//vDmYwgMxoGjDR+QWLuFQwk/E2ViVpzZqbF2pczb8UzYqxuYkXAKf5H5/1ps+i
        CFdfIU2eUdlT5u5HOydXA/xenlsYmgw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-420-4P76lbMNO3u9kQ0cf8ISTg-1; Wed, 09 Dec 2020 20:51:13 -0500
X-MC-Unique: 4P76lbMNO3u9kQ0cf8ISTg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 928711934102;
        Thu, 10 Dec 2020 01:51:09 +0000 (UTC)
Received: from mail (ovpn-119-164.rdu2.redhat.com [10.10.119.164])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0EE055D6BA;
        Thu, 10 Dec 2020 01:51:06 +0000 (UTC)
Date:   Wed, 9 Dec 2020 20:51:05 -0500
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     Mike Rapoport <rppt@kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Baoquan He <bhe@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@kernel.org>,
        Mike Rapoport <rppt@linux.ibm.com>, Qian Cai <cai@lca.pw>,
        Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/2] mm: fix initialization of struct page for holes
 in memory layout
Message-ID: <X9F/Cc946aKaA8gr@redhat.com>
References: <20201209214304.6812-1-rppt@kernel.org>
 <20201209214304.6812-3-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201209214304.6812-3-rppt@kernel.org>
User-Agent: Mutt/2.0.2 (2020-11-20)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

On Wed, Dec 09, 2020 at 11:43:04PM +0200, Mike Rapoport wrote:
> +void __init __weak memmap_init(unsigned long size, int nid,
> +			       unsigned long zone,
> +			       unsigned long range_start_pfn)
> +{
> +	unsigned long start_pfn, end_pfn, hole_start_pfn = 0;
>  	unsigned long range_end_pfn = range_start_pfn + size;
> +	u64 pgcnt = 0;
>  	int i;
>  
>  	for_each_mem_pfn_range(i, nid, &start_pfn, &end_pfn, NULL) {
>  		start_pfn = clamp(start_pfn, range_start_pfn, range_end_pfn);
>  		end_pfn = clamp(end_pfn, range_start_pfn, range_end_pfn);
> +		hole_start_pfn = clamp(hole_start_pfn, range_start_pfn,
> +				       range_end_pfn);
>  
>  		if (end_pfn > start_pfn) {
>  			size = end_pfn - start_pfn;
>  			memmap_init_zone(size, nid, zone, start_pfn,
>  					 MEMINIT_EARLY, NULL, MIGRATE_MOVABLE);
>  		}
> +
> +		if (hole_start_pfn < start_pfn)
> +			pgcnt += init_unavailable_range(hole_start_pfn,
> +							start_pfn, zone, nid);
> +		hole_start_pfn = end_pfn;
>  	}

After applying the new 1/2, the above loop seem to be functionally a
noop compared to what was in -mm yesterday, so the above looks great
as far as I'm concerned.

Unlike the simple fix this will not loop over holes that aren't part
of memblock.memory nor memblock.reserved and it drops the static
variable which would have required ordering and serialization.

By being functionally equivalent, it looks it also suffers from the
same dependency on pfn 0 (and not just pfn 0) being reserved that you
pointed out earlier.

I suppose to drop that further dependency we need a further round down
in this logic to the start of the pageblock_order or max-order like
mentioned yesterday?

If the first pfn of a pageblock (or maybe better a max-order block) is
valid, but not in memblock.reserved nor memblock.memory and any other
pages in such pageblock is freed to the buddy allocator, we should
make sure the whole pageblock gets initialized (or at least the pages
with a pfn lower than the one that was added to the buddy). So
applying a round down in the above loop might just do the trick.

Since the removal of that extra dependency was mostly orthogonal with
the above, I guess it's actually cleaner to do it incrementally.

I'd suggest to also document why we're doing it, in the code (not just
commit header) of the incremental patch, by mentioning which are the
specific VM invariants we're enforcing that the VM code always
depended upon, that required the rundown etc...

In the meantime I'll try to update all systems again with this
implementation to test it.

Thanks!
Andrea

