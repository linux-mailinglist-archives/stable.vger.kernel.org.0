Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEB304753A7
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 08:27:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240525AbhLOH1O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 02:27:14 -0500
Received: from verein.lst.de ([213.95.11.211]:55363 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240524AbhLOH1O (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Dec 2021 02:27:14 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 600A268AFE; Wed, 15 Dec 2021 08:27:10 +0100 (CET)
Date:   Wed, 15 Dec 2021 08:27:10 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc:     Vlastimil Babka <vbabka@suse.cz>, Baoquan He <bhe@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, hch@lst.de, cl@linux.com,
        John.p.donnelly@oracle.com, kexec@lists.infradead.org,
        stable@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH v3 5/5] mm/slub: do not create dma-kmalloc if no
 managed pages in DMA zone
Message-ID: <20211215072710.GA3010@lst.de>
References: <20211213122712.23805-1-bhe@redhat.com> <20211213122712.23805-6-bhe@redhat.com> <20211213134319.GA997240@odroid> <20211214053253.GB2216@MiWiFi-R3L-srv> <f5ff82eb-73b6-55b5-53d7-04ab73ce5035@suse.cz> <20211215044818.GB1097530@odroid> <20211215070335.GA1165926@odroid>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211215070335.GA1165926@odroid>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 15, 2021 at 07:03:35AM +0000, Hyeonggon Yoo wrote:
> I'm not sure that allocating from ZONE_DMA32 instead of ZONE_DMA
> for kdump kernel is nice way to solve this problem.

What is the problem with zones in kdump kernels?

> Devices that requires ZONE_DMA memory is rare but we still support them.

Indeed.

> >     1) Do not call warn_alloc in page allocator if will always fail
> >     to allocate ZONE_DMA pages.
> > 
> > 
> >     2) let's check all callers of kmalloc with GFP_DMA
> >     if they really need GFP_DMA flag and replace those by DMA API or
> >     just remove GFP_DMA from kmalloc()
> > 
> >     3) Drop support for allocating DMA memory from slab allocator
> >     (as Christoph Hellwig said) and convert them to use DMA32
> 
> 	(as Christoph Hellwig said) and convert them to use *DMA API*
> 
> >     and see what happens

This is the right thing to do, but it will take a while.  In fact
I dont think we really need the warning in step 1, a simple grep
already allows to go over them.  I just looked at the uses of GFP_DMA
in drivers/scsi for example, and all but one look bogus.

> > > > Yeah, I have the same guess too for get_capabilities(), not sure about other
> > > > callers. Or, as ChristophL and ChristophH said(Sorry, not sure if this is
> > > > the right way to call people when the first name is the same. Correct me if
> > > > it's wrong), any buffer requested from kmalloc can be used by device driver.
> > > > Means device enforces getting memory inside addressing limit for those
> > > > DMA transferring buffer which is usually large, Megabytes level with
> > > > vmalloc() or alloc_pages(), but doesn't care about this kind of small
> > > > piece buffer memory allocated with kmalloc()? Just a guess, please tell
> > > > a counter example if anyone happens to know, it could be easy.

The way this works is that the dma_map* calls will bounce buffer memory
that does to fall into the addressing limitations.  This is a performance
overhead, but allows drivers to address all memory in a system.  If the
driver controls memory allocation it should use one of the dma_alloc_*
APIs that allocate addressable memory from the start.  The allocator
will dip into ZONE_DMA and ZONE_DMA32 when needed.
