Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C923D2F1931
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 16:08:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731448AbhAKPIT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 10:08:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56193 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731426AbhAKPIT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 10:08:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610377613;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/g7CoqAv3+2DuhrWm4HZxfGTuv3YxRqKxge5jGqMOnw=;
        b=EclrO6p5xLGwCG90HgA4MucTe2prm1zW7rkeXYDhGXbr6XLoPptQ3gBNZKS2hPPxm33U4C
        lc9gPho9wFpGxedsws61zkVtSHi0lgjgbntr5US0BUBDLSm9Q0aGzYaNwyxFVU+yl6ZGuU
        jobLht2H33ilgvIFJtz4J0MRserSg4M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-397-FIhTPNSeNnCUTrXgbggs3Q-1; Mon, 11 Jan 2021 10:06:51 -0500
X-MC-Unique: FIhTPNSeNnCUTrXgbggs3Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 261E715724;
        Mon, 11 Jan 2021 15:06:49 +0000 (UTC)
Received: from ovpn-119-23.rdu2.redhat.com (ovpn-119-23.rdu2.redhat.com [10.10.119.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A425219C59;
        Mon, 11 Jan 2021 15:06:43 +0000 (UTC)
Message-ID: <782e710eac32b1ab3bf9713bcd6afcbc9483e16c.camel@redhat.com>
Subject: Re: [PATCH v2 2/2] mm: fix initialization of struct page for holes
 in memory layout
From:   Qian Cai <qcai@redhat.com>
To:     Mike Rapoport <rppt@kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Baoquan He <bhe@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@kernel.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, stable@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Date:   Mon, 11 Jan 2021 10:06:43 -0500
In-Reply-To: <20210110153956.GD1106298@kernel.org>
References: <20201209214304.6812-1-rppt@kernel.org>
         <20201209214304.6812-3-rppt@kernel.org>
         <768cb57d6ef0989293b3f9fbe0af8e8851723ea1.camel@redhat.com>
         <20210105082403.GA1106298@kernel.org>
         <67ef893f27551f80ecf49ef78c0ebc05d3e41b46.camel@redhat.com>
         <20210106080553.GB1106298@kernel.org>
         <8171f5a5a8b407a1fcca56bab912555bde80d323.camel@redhat.com>
         <20210110153956.GD1106298@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 2021-01-10 at 17:39 +0200, Mike Rapoport wrote:
> On Wed, Jan 06, 2021 at 04:04:21PM -0500, Qian Cai wrote:
> > On Wed, 2021-01-06 at 10:05 +0200, Mike Rapoport wrote:
> > > I think we trigger PF_POISONED_CHECK() in PageSlab(), then
> > > fffffffffffffffe
> > > is "accessed" from VM_BUG_ON_PAGE().
> > > 
> > > It seems to me that we are not initializing struct pages for holes at the
> > > node
> > > boundaries because zones are already clamped to exclude those holes.
> > > 
> > > Can you please try to see if the patch below will produce any useful info:
> > 
> > [    0.000000] init_unavailable_range: spfn: 8c, epfn: 9b, zone: DMA, node:
> > 0
> > [    0.000000] init_unavailable_range: spfn: 1f7be, epfn: 1f9fe, zone:
> > DMA32, node: 0
> > [    0.000000] init_unavailable_range: spfn: 28784, epfn: 288e4, zone:
> > DMA32, node: 0
> > [    0.000000] init_unavailable_range: spfn: 298b9, epfn: 298bd, zone:
> > DMA32, node: 0
> > [    0.000000] init_unavailable_range: spfn: 29923, epfn: 29931, zone:
> > DMA32, node: 0
> > [    0.000000] init_unavailable_range: spfn: 29933, epfn: 29941, zone:
> > DMA32, node: 0
> > [    0.000000] init_unavailable_range: spfn: 29945, epfn: 29946, zone:
> > DMA32, node: 0
> > [    0.000000] init_unavailable_range: spfn: 29ff9, epfn: 2a823, zone:
> > DMA32, node: 0
> > [    0.000000] init_unavailable_range: spfn: 33a23, epfn: 33a53, zone:
> > DMA32, node: 0
> > [    0.000000] init_unavailable_range: spfn: 78000, epfn: 100000, zone:
> > DMA32, node: 0
> > ...
> > [  572.222563][ T2302] kpagecount_read: pfn 47f380 is poisoned
> ...
> > [  590.570032][ T2302] kpagecount_read: pfn 47ffff is poisoned
> > [  604.268653][ T2302] kpagecount_read: pfn 87ff80 is poisoned
> ...
> > [  604.611698][ T2302] kpagecount_read: pfn 87ffbc is poisoned
> > [  617.484205][ T2302] kpagecount_read: pfn c7ff80 is poisoned
> ...
> > [  618.212344][ T2302] kpagecount_read: pfn c7ffff is poisoned
> > [  633.134228][ T2302] kpagecount_read: pfn 107ff80 is poisoned
> ...
> > [  633.874087][ T2302] kpagecount_read: pfn 107ffff is poisoned
> > [  647.686412][ T2302] kpagecount_read: pfn 147ff80 is poisoned
> ...
> > [  648.425548][ T2302] kpagecount_read: pfn 147ffff is poisoned
> > [  663.692630][ T2302] kpagecount_read: pfn 187ff80 is poisoned
> ...
> > [  664.432671][ T2302] kpagecount_read: pfn 187ffff is poisoned
> > [  675.462757][ T2302] kpagecount_read: pfn 1c7ff80 is poisoned
> ...
> > [  676.202548][ T2302] kpagecount_read: pfn 1c7ffff is poisoned
> > [  687.121605][ T2302] kpagecount_read: pfn 207ff80 is poisoned
> ...
> > [  687.860981][ T2302] kpagecount_read: pfn 207ffff is poisoned
> 
> The e820 map has a hole near the end of each node and these holes are not
> initialized with init_unavailable_range() after it was interleaved with
> memmap initialization because such holes are not accounted by
> zone->spanned_pages.
> 
> Yet, I'm still cannot really understand how this never triggered 
> 
> 	VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn), page);
> 
> before v5.7 as all the struct pages for these holes would have zone=0 and
> node=0 ... 
> 
> @Qian, can you please boot your system with memblock=debug and share the
> logs?
> 

http://people.redhat.com/qcai/memblock.txt

