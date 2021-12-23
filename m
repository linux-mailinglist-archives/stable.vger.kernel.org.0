Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA09747E09C
	for <lists+stable@lfdr.de>; Thu, 23 Dec 2021 09:52:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347163AbhLWIwn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Dec 2021 03:52:43 -0500
Received: from verein.lst.de ([213.95.11.211]:53185 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229563AbhLWIwn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Dec 2021 03:52:43 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id AB43A68AA6; Thu, 23 Dec 2021 09:52:38 +0100 (CET)
Date:   Thu, 23 Dec 2021 09:52:38 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc:     Christoph Hellwig <hch@lst.de>, Baoquan He <bhe@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, cl@linux.com,
        John.p.donnelly@oracle.com, kexec@lists.infradead.org,
        stable@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH v3 5/5] mm/slub: do not create dma-kmalloc if no
 managed pages in DMA zone
Message-ID: <20211223085238.GA7555@lst.de>
References: <20211213122712.23805-1-bhe@redhat.com> <20211213122712.23805-6-bhe@redhat.com> <20211213134319.GA997240@odroid> <20211214053253.GB2216@MiWiFi-R3L-srv> <Ybx2szXEgl1tN4MD@ip-172-31-30-232.ap-northeast-1.compute.internal> <20211221085623.GA7733@lst.de> <YcMb7+RESj1nEx9l@ip-172-31-30-232.ap-northeast-1.compute.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YcMb7+RESj1nEx9l@ip-172-31-30-232.ap-northeast-1.compute.internal>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 22, 2021 at 12:37:03PM +0000, Hyeonggon Yoo wrote:
> Oh I misunderstood this. Underlying physical address of vmalloc()-allocated memory
> can be mapped using DMA API, and it needs to be setup as scatterlist because
> the allocated memory is not physically continuous. Right?

Yes.

> BTW, looking at the API I think the scsi case can be converted to use
> dma_alloc_pages(). but driver requires 512 bytes of buffer and the API
> supports allocating by at least page size.

Overallocating is not generally a problem, but if the allocations are for
a slow path it might make more sense to stick to dma_map_* and bounce
buffer if needed.

> It's not a big problem as it allocates a single buffer but in other
> cases maybe not. Can't we use dma pool for non-coherent pages?

No.
