Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AAC847BC3B
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 09:56:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234382AbhLUI42 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Dec 2021 03:56:28 -0500
Received: from verein.lst.de ([213.95.11.211]:45942 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233874AbhLUI42 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Dec 2021 03:56:28 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id A0D3868AFE; Tue, 21 Dec 2021 09:56:23 +0100 (CET)
Date:   Tue, 21 Dec 2021 09:56:23 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc:     Baoquan He <bhe@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, akpm@linux-foundation.org, hch@lst.de,
        cl@linux.com, John.p.donnelly@oracle.com,
        kexec@lists.infradead.org, stable@vger.kernel.org,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH v3 5/5] mm/slub: do not create dma-kmalloc if no
 managed pages in DMA zone
Message-ID: <20211221085623.GA7733@lst.de>
References: <20211213122712.23805-1-bhe@redhat.com> <20211213122712.23805-6-bhe@redhat.com> <20211213134319.GA997240@odroid> <20211214053253.GB2216@MiWiFi-R3L-srv> <Ybx2szXEgl1tN4MD@ip-172-31-30-232.ap-northeast-1.compute.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ybx2szXEgl1tN4MD@ip-172-31-30-232.ap-northeast-1.compute.internal>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 17, 2021 at 11:38:27AM +0000, Hyeonggon Yoo wrote:
> My understanding is any buffer requested from kmalloc (without
> GFP_DMA/DMA32) can be used by device driver because it allocates
> continuous physical memory. It doesn't mean that buffer allocated
> with kmalloc is free of addressing limitation.

Yes.

> 
> the addressing limitation comes from the capability of device, not
> allocation size. if you allocate memory using alloc_pages() or kmalloc(),
> the device has same limitation. and vmalloc can't be used for
> devices because they have no MMU.

vmalloc can be used as well, it just needs to be setup as a scatterlist
and needs a little lover for DMA challenged platforms with the
invalidate_kernel_vmap_range and flush_kernel_vmap_range helpers.

> But we can map memory outside DMA zone into bounce buffer (which resides
> in DMA zone) using DMA API.

Yes, although in a few specific cases the bounce buffer could also come
from somewhere else.

